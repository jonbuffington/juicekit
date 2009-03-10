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


  /**
   * The JuiceKitEvent class defines the event type string constants
   * for many of the JuiceKit event types,
   * especially custom data binding events.
   *
   * @author Jon Buffington
   */
  public final class JuiceKitEvent extends Event {


    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     * The <code>JuiceKitEvent.DATA_ROOT_CHANGE</code> constant defines the
     * value of the <code>type</code> property of the event object for
     * an <code>dataRootChange</code> event. The <code>dataRootChange</code>
     * event is primarily used for data binding.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType dataRootChange
     */
    public static const DATA_ROOT_CHANGE:String = "dataRootChange";


    /**
     *  Constructor.
     *
     *  @param type The event type; indicates the action that caused the event.
     *
     *  @param bubbles Specifies whether the event can bubble up
     *  the display list hierarchy.
     *
     *  @param cancelable Specifies whether the behavior
     *  associated with the event can be prevented.
     */
    public function JuiceKitEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
      super(type, bubbles, cancelable);
    }


    /**
     *  @private
     */
    override public function clone():Event {
      return new JuiceKitEvent(type, bubbles, cancelable);
    }
  }
}
