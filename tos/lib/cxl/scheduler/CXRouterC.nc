configuration CXRouterC {
  provides interface SplitControl;
  provides interface Send;
  provides interface Receive;

  provides interface CXDownload;

  uses interface Pool<message_t>;
} implementation {
  components SlotSchedulerC;
  components CXRouterP;

  CXDownload = CXRouterP;

  CXRouterP.Neighborhood -> SlotSchedulerC;

  Send = SlotSchedulerC;
  Receive = SlotSchedulerC;
  SplitControl = SlotSchedulerC;

  SlotSchedulerC.Pool = Pool;

  SlotSchedulerC.SlotController -> CXRouterP;

  components CXWakeupC;
  CXRouterP.LppControl -> CXWakeupC;
}
