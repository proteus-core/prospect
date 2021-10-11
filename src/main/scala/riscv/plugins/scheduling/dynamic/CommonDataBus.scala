package riscv.plugins.scheduling.dynamic

import riscv.Config
import spinal.core._
import spinal.lib.{Stream, StreamArbiterFactory}

// TODO: can we save area by making some signals ROB-exclusive?
// TODO: would it make sense to move the signals common to CdbMessage and RobEntry into one
//  structure? (seems to make more and more sense as we have more and more signals)
case class CdbMessage(robIndexBits: BitCount)(implicit config: Config) extends Bundle {
  val robIndex: UInt = UInt(robIndexBits)
  val writeValue: UInt = UInt(config.xlen bits)
}

trait CdbListener {
  def onCdbMessage(cdbMessage: CdbMessage)
}

class CommonDataBus(reservationStations: Seq[ReservationStation], rob: ReorderBuffer)
                   (implicit config: Config) extends Area {
  val inputs: Vec[Stream[CdbMessage]] =
    Vec(Stream(HardType(CdbMessage(rob.indexBits))), reservationStations.size)

  private val arbitratedInputs = StreamArbiterFactory.roundRobin.on(inputs)

  def build(): Unit = {
    when (arbitratedInputs.valid) {
      arbitratedInputs.ready := True
      val listeners = reservationStations :+ rob
      for (listener <- listeners) {
        listener.onCdbMessage(arbitratedInputs.payload)
      }
    } otherwise {
      arbitratedInputs.ready := False
    }
  }
}

class UncommonDataBus(reservationStations: Seq[ReservationStation], rob: ReorderBuffer) extends Area {
  val inputs: Vec[Stream[RobRegisterBox]] = Vec(Stream(HardType(RobRegisterBox())), reservationStations.size)
  private val arbitratedInputs = StreamArbiterFactory.roundRobin.on(inputs)

  def build(): Unit = {
    when (arbitratedInputs.valid) {
      arbitratedInputs.ready := True
      rob.onUdbMessage(arbitratedInputs.payload)
    } otherwise {
      arbitratedInputs.ready := False
    }
  }
}
