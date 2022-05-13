package riscv.plugins.scheduling.dynamic

import riscv._
import spinal.core._

class Scheduler() extends Plugin[DynamicPipeline] with IssueService {

  private object PrivateRegisters {
    object DEST_FU extends PipelineData(Bits(pipeline.rsStages.size bits))
  }

  override def setup(): Unit = {
    pipeline.service[DecoderService].configure { config =>
      config.addDefault(PrivateRegisters.DEST_FU, B(0))
    }
  }

  override def finish(): Unit = {
    pipeline plug new Area {
      val cdbBMetaData = new DynBundle[PipelineData[spinal.core.Data]]
      val registerBundle = new DynBundle[PipelineData[spinal.core.Data]]

      pipeline.serviceOption[ProspectService] foreach {prospect =>
        val branchService = pipeline.service[BranchService]
        branchService.addIsBranchToBundle(registerBundle)
        branchService.addPendingBranchToBundle(registerBundle)
        branchService.addPendingBranchToBundle(cdbBMetaData)

        prospect.addSecretToBundle(cdbBMetaData)
        prospect.addSecretToBundle(registerBundle)
      }

      cdbBMetaData.addElement(pipeline.data.NEXT_PC.asInstanceOf[PipelineData[Data]], pipeline.data.NEXT_PC.dataType)

      val ret = pipeline.retirementStage
      val ls = pipeline.loadStage
      for (register <- ret.lastValues.keys.toSet union ret.outputs.keys.toSet union ls.lastValues.keys.toSet union ls.outputs.keys.toSet) {
        registerBundle.addElement(register, register.dataType)
      }

      pipeline.rob = new ReorderBuffer(pipeline, 16, registerBundle, cdbBMetaData)

      val rob = pipeline.rob
      rob.build()

      val reservationStations = pipeline.rsStages.map(
        stage => new ReservationStation(stage, rob, pipeline, registerBundle, cdbBMetaData))

      val cdb = new CommonDataBus(reservationStations, rob, cdbBMetaData)
      cdb.build()
      for ((rs, index) <- reservationStations.zipWithIndex) {
        rs.build()
        rs.cdbStream >> cdb.inputs(index)
      }

      val loadManager = new LoadManager(pipeline, pipeline.loadStage, rob, registerBundle, cdbBMetaData)
      loadManager.build()
      loadManager.cdbStream >> cdb.inputs(reservationStations.size)

      val dispatcher = new Dispatcher(pipeline, rob, loadManager, registerBundle) // TODO: confusing name regarding instruction dispatch later
      dispatcher.build()

      pipeline.components = reservationStations :+ loadManager :+ dispatcher

      val dispatchBus = new DispatchBus(reservationStations, rob, dispatcher, registerBundle)
      dispatchBus.build()

      for ((rs, index) <- reservationStations.zipWithIndex) {
        rs.dispatchStream >> dispatchBus.inputs(index)
      }

      val robDataBus = new RobDataBus(rob, registerBundle)
      robDataBus.build()
      dispatcher.rdbStream >> robDataBus.inputs(0)
      loadManager.rdbStream >> robDataBus.inputs(1)

      // Dispatch
      val dispatchStage = pipeline.issuePipeline.stages.last
      dispatchStage.arbitration.isStalled := False

      when (dispatchStage.arbitration.isValid && dispatchStage.arbitration.isReady) {
        val fuMask = dispatchStage.output(PrivateRegisters.DEST_FU)
        val illegalInstruction = fuMask === 0

        var context = when (False) {}

        for ((rs, index) <- reservationStations.zipWithIndex) {
          context = context.elsewhen ((fuMask(index) || illegalInstruction) && rs.isAvailable && rob.isAvailable) {
            rs.execute()
          }
        }

        context.otherwise {
          dispatchStage.arbitration.isStalled := True
        }
      }
    }
  }

  override def setDestinations(opcode: MaskedLiteral, stages: Set[Stage]): Unit = {
    for (stage <- stages) {
      assert(pipeline.rsStages.contains(stage),
        s"Stage ${stage.stageName} is not an execute stage")
    }

    pipeline.service[DecoderService].configure { config =>
      var fuMask = 0

      for (exeStage <- pipeline.rsStages.reverse) {
        val nextBit = if (stages.contains(exeStage)) 1 else 0
        fuMask = (fuMask << 1) | nextBit
      }

      config.addDecoding(opcode, Map(PrivateRegisters.DEST_FU -> B(fuMask)))
    }
  }
}
