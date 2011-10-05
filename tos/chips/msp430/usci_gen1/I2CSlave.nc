interface I2CSlave{
  command error_t setOwnAddress(uint16_t addr);
  command error_t enableSlave();
  command error_t disableSlave();
  async event error_t slaveReceive(uint8_t data);
  async event uint8_t slaveTransmit();

  //should these return error so we can say "no, I'm not going to be a
  //slave right now"?
  async event void slaveStart();
  async event void slaveStop();
}