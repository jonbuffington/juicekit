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
  import flash.events.MouseEvent;


  /**
   * The DataMouseEvent class defines an event to signal a
   * mouse event occurred on/over a visual representation of a data object.
   *
   * @author Jon Buffington
   */
  public class DataMouseEvent extends MouseEvent {


    /**
     * The <code>DataMouseEvent.CLICK</code> constant
     * defines the value of the <code>type</code> property of the event
     * object for a <code>DataMouseEvent</code> event.
     */
    public static const CLICK:String = "jkDataClick";

    /**
     * The <code>DataMouseEvent.DOUBLE_CLICK</code> constant
     * defines the value of the <code>type</code> property of the event
     * object for a <code>DataMouseEvent</code> event.
     */
    public static const DOUBLE_CLICK:String = "jkDataDoubleClick";

    /**
     * The <code>DataMouseEvent.MOUSE_OUT</code> constant
     * defines the value of the <code>type</code> property of the event
     * object for a <code>DataMouseEvent</code> event.
     */
    public static const MOUSE_OUT:String = "jkDataMouseOut";

    /**
     * The <code>DataMouseEvent.MOUSE_OVER</code> constant
     * defines the value of the <code>type</code> property of the event
     * object for a <code>DataMouseEvent</code> event.
     */
    public static const MOUSE_OVER:String = "jkDataMouseOver";


    private function mapEvents(mouseEventType:String):String {
      var retVal:String;
      switch (mouseEventType) {
        case MouseEvent.CLICK:
          retVal = CLICK;
          break;
        case MouseEvent.DOUBLE_CLICK:
          retVal = DOUBLE_CLICK;
          break;
        case MouseEvent.MOUSE_OUT:
          retVal = MOUSE_OUT;
          break;
        case MouseEvent.MOUSE_OVER:
          retVal = MOUSE_OVER;
          break;
        default:
          retVal = mouseEventType;  // Support the clone operation.
      }
      return retVal;
    }


    /**
     * Constructor.
     *
     * @param event References the originating <code>MouseEvent</code>
     * that this instance will wrap.
     *
     * @param data Contains a reference to the related data
     * <code>Object</code>.
     */
    public function DataMouseEvent(event:MouseEvent, data:Object = null) {
      super( mapEvents(event.type)
           , event.bubbles
           , event.cancelable
           , event.localX
           , event.localY
           , event.relatedObject
           , event.ctrlKey
           , event.altKey
           , event.shiftKey
           , event.buttonDown
           , event.delta
           );

      this.data = data;
      this.sender = event.target as EventDispatcher;
    }


    /**
     * Contains a reference to the event's data <code>Object</code>.
     */
    public var data:Object;


    /**
     * Contains a reference to this wrapped event's original
     * <code>EventDispatcher</code>.
     */
    public var sender:EventDispatcher;


    /**
     * @private
     */
    override public function clone():Event {
      return new DataMouseEvent(this, data);
    }
  }
}
