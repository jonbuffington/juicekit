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
  import flash.events.IEventDispatcher;


  /**
   * The InactivityEvent class defines an event to signal a period of
   * inactivity occurred.
   *
   * @author Jon Buffington
   *
   * @see InactivityMonitor
   */
  public class InactivityEvent extends Event {


    /**
     * The <code>InactivityEvent.INACTIVITY_PERIOD</code> constant
     * defines the value of the <code>type</code> property of the event
     * object for a <code>jkInactivityPeriod</code> event.
     */
    public static const INACTIVITY_PERIOD:String = "jkInactivityPeriod";


    /**
     * Constructor.
     *
     * @param type The event type; indicates the action that caused the event.
     *
     * @param bubbles Specifies whether the event can bubble up the
     * display list hierarchy.
     *
     * @param cancelable Specifies whether the behavior associated with
     * the event can be prevented.
     *
     * @param monitored References the watched object that became inactive.
     *
     * @param idleTime Contains the time in milliseconds elapsed since
     * the last activity was observed.
     */
    public function InactivityEvent(type:String,
                  bubbles:Boolean,
                  cancelable:Boolean,
                  monitored:IEventDispatcher,
                  idleTime:Number) {
      super(type, bubbles, cancelable);

      this.monitored = monitored;
      this.idleTime = idleTime;
    }


    /**
     * References the watched object that became inactive.
     */
    public var monitored:IEventDispatcher;


    /**
     * Contains the time in milliseconds elapsed since the last
     * activity was observed.
     */
    public var idleTime:Number;


    /**
     * @inheritDoc
     */
    override public function clone():Event {
      return new InactivityEvent(type, bubbles, cancelable, monitored, idleTime);
    }
  }
}
