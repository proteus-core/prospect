package riscv.plugins.memory

import riscv._
import spinal.core._

class Fetcher(fetchStage: Stage) extends Plugin[Pipeline] with FetchService {
  private var addressTranslator = new FetchAddressTranslator {
    override def translate(stage: Stage, address: UInt): UInt = {
      address
    }
  }

  private var addressTranslatorChanged = false

  override def build(): Unit = {
    fetchStage plug new Area {
      import fetchStage._

      val ibus = pipeline.service[MemoryService].createInternalIBus(fetchStage)
      val ibusCtrl = new MemBusControl(ibus)

      arbitration.isReady := False

      val pc = input(pipeline.data.PC)
      val nextPc = pc + 4

      when(arbitration.isRunning) {
        val fetchAddress = addressTranslator.translate(fetchStage, pc)
        val (valid, rdata) = ibusCtrl.read(fetchAddress)

        when(valid) {
          arbitration.isReady := True

          output(pipeline.data.NEXT_PC) := nextPc
          output(pipeline.data.IR) := rdata
        }
      }
    }
  }

  override def setAddressTranslator(translator: FetchAddressTranslator): Unit = {
    assert(!addressTranslatorChanged, "FetchAddressTranslator can only be set once")

    addressTranslator = translator
    addressTranslatorChanged = true
  }
}
