
/* Copyright (c) 2000-2003 The Regents of the University of California.  
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the copyright holder nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * HilTimerMilliC provides a parameterized interface to a virtualized
 * 32khz timer.  Timer32khzC in tos/chips/msp430/timer uses this component to
 * allocate new timers.
 *
 * @author Cory Sharp <cssharp@eecs.berkeley.edu>
 * @author Doug carlson <carlson@cs.jhu.edu>
 * @see  Please refer to TEP 102 for more information about this component and its
 *          intended use.
 */

configuration HilTimer32khzC
{
  provides interface Init;
  provides interface Timer<T32khz> as Timer32khz[ uint8_t num ];
  provides interface LocalTime<T32khz>;
}
implementation
{
  components new Alarm32khz32C();
  components new AlarmToTimerC(T32khz);
  components new VirtualizeTimerC(T32khz,uniqueCount(UQ_TIMER_32KHZ));
  components new CounterToLocalTimeC(T32khz);
  components Counter32khz32C;

  Init = Alarm32khz32C;
  Timer32khz = VirtualizeTimerC;
  LocalTime = CounterToLocalTimeC;

  VirtualizeTimerC.TimerFrom -> AlarmToTimerC;
  AlarmToTimerC.Alarm -> Alarm32khz32C;
  CounterToLocalTimeC.Counter -> Counter32khz32C;
}

