/*
 * -*- Mode: Actionscript -*-
 * *************************************************************************
 *
 * Copyright 2007-2009 Juice, Inc.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * *************************************************************************
 */


package org.juicekit.events {

  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.events.TimerEvent;
  import flash.utils.Timer;


  /**
   * Dispatched when the idle period has expired with no activity.
   *
   * @eventType org.juicekit.events.InactivityEvent.INACTIVITY_PERIOD
   */
  [Event(name="jkInactivityPeriod", type="org.juicekit.events.InactivityEvent")]


  /**
   * The InactivityMonitor class monitors other event dispatchers
   * for keyboard or mouse events in order to signal periods of
   * inactivity to listeners of <code>jkInactivityPeriod</code>.
   *
   * @author Jon Buffington
   *
   * @see InactivityEvent
   */
  public class InactivityMonitor extends EventDispatcher {


    private var _timer:Timer;
    private var _monitored:IEventDispatcher;


    /**
     * Constructor.
     *
     * @param monitored References an IEventDispatcher to be watched for
     * periods of inactivity.
     *
     * @param maxIdle Specifies the minimum number of milliseconds between
     * watched events before an InactivityEvent is dispatched.
     */
    public function InactivityMonitor(monitored:IEventDispatcher = null,
                      maxIdle:Number = 5000) {
      super();
      _timer = new Timer(maxIdle);
      _timer.addEventListener(TimerEvent.TIMER, handleTimer);

      this.monitor = monitored;
    }


    /**
     * Specifies the minimum number of milliseconds between
     * watched events before an InactivityEvent is dispatched.
     */
    public function set maxIdle(value:Number):void {
      _timer.delay = value;
    }

    public function get maxIdle():Number {
      return _timer.delay;
    }


    /**
     * Restarts the idle-period counter from zero.
     */
    public function restart():void {
      if (_monitored) {
        if (_timer.running) {
          // Reset the counter and unfortunately stop the timer.
          _timer.reset();
        }
        // Start/restart the timer.
        _timer.start();
      }
    }

    private function handleTimer(event:TimerEvent):void {
      _timer.reset();	// stop and zero the internal counter
      dispatchEvent(new InactivityEvent(InactivityEvent.INACTIVITY_PERIOD,
                        false,
                        false,
                        _monitored,
                        _timer.delay));
    }

    private function handleActivity(event:Event):void {
      restart();
    }


    /**
     * @private
     */
    private function boot():void {
      if (_monitored) {
        _timer.reset();	// stop and zero the internal counter
        _monitored.addEventListener(MouseEvent.CLICK, handleActivity);
        _monitored.addEventListener(KeyboardEvent.KEY_DOWN, handleActivity);
        _monitored.addEventListener(KeyboardEvent.KEY_UP, handleActivity);
      }
    }

    private function shutdown():void {
      if (_monitored) {
        _timer.reset();	// stop and zero the internal counter
        _monitored.removeEventListener(MouseEvent.CLICK, handleActivity);
        _monitored.removeEventListener(KeyboardEvent.KEY_DOWN, handleActivity);
        _monitored.removeEventListener(KeyboardEvent.KEY_UP, handleActivity);
      }
    }


    /**
     * References an IEventDispatcher to be watched for periods of inactivity.
     */
    public function get monitor():IEventDispatcher {
      return _monitored;
    }

    public function set monitor(monitored:IEventDispatcher):void {
      if (_monitored) {
        shutdown();
      }
      _monitored = monitored;
      if (_monitored) {
        boot();
      }
    }
  }
}
