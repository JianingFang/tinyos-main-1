 #include "I2CSynch.h"
configuration I2CSynchMasterC{
  provides interface I2CSynchMaster;
} implementation {
  components I2CSynchMasterP;
  components LocalTime32khzC;
  components LocalTimeMilliC;
  components new I2CComMasterClientC(I2C_COM_CLIENT_ID_SYNCH);

  I2CSynchMasterP.I2CComMaster -> I2CComMasterClientC;
  I2CSynchMasterP.LocalTime32k -> LocalTime32khzC;
  I2CSynchMasterP.LocalTimeMilli -> LocalTimeMilliC;

  I2CSynchMaster = I2CSynchMasterP;
}
