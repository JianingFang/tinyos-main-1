module BaconSpiA0PortMappingP{
  provides interface Msp430PortMappingConfigure;
}implementation {
  async command error_t Msp430PortMappingConfigure.configure(){
    atomic{
      PMAPPWD = PMAPKEY;
      PMAPCTL = PMAPRECFG;
      //SPI CLK on P1.4
      //SPI SIMO on P1.3
      //SPI SOMI on P1.2
      P1MAP4 = PM_UCA0CLK;
      P1MAP3 = PM_UCA0SIMO;
      P1MAP2 = PM_UCA0SOMI;
      PMAPPWD = 0x0;
      //switch pins to function
      P1SEL |= (BIT2|BIT3|BIT4);
    }
    return SUCCESS;
  }

  async command error_t Msp430PortMappingConfigure.unconfigure(){
    atomic{
      PMAPPWD = PMAPKEY;
      PMAPCTL = PMAPRECFG;
      P1MAP4 = PM_NONE;
      P1MAP3 = PM_NONE;
      P1MAP2 = PM_NONE;
      PMAPPWD = 0x0;
      //set pins to gnd
      P1OUT &= ~(BIT2|BIT3|BIT4);
      P1SEL &= ~(BIT2|BIT3|BIT4);
      P1DIR |= (BIT2|BIT3|BIT4);
    }
    return SUCCESS;
  }
}
