/* DO NOT MODIFY
 * This file cloned from Msp430UsciSpiB0P.nc for A0 */
configuration Msp430UsciSpiA0P {
  provides {
    interface SpiPacket[ uint8_t client ];
    interface SpiByte;
    interface Msp430UsciError;
    interface ResourceConfigure[ uint8_t client ];
  }
  uses {
    interface Msp430UsciConfigure[ uint8_t client ];
    interface Msp430PortMappingConfigure[ uint8_t client ];
    interface HplMsp430GeneralIO as SIMO;
    interface HplMsp430GeneralIO as SOMI;
    interface HplMsp430GeneralIO as CLK;
 }
} implementation {

  components Msp430UsciA0P as UsciC;

  components new Msp430UsciSpiP() as SpiC;
  SpiC.Usci -> UsciC;
  SpiC.Interrupts -> UsciC.Interrupts[MSP430_USCI_SPI];
  SpiC.ArbiterInfo -> UsciC;

  Msp430UsciConfigure = SpiC;
  Msp430PortMappingConfigure = SpiC;
  ResourceConfigure = SpiC;
  SpiPacket = SpiC;
  SpiByte = SpiC;
  Msp430UsciError = SpiC;
  SIMO = SpiC.SIMO;
  SOMI = SpiC.SOMI;
  CLK = SpiC.CLK;
}
