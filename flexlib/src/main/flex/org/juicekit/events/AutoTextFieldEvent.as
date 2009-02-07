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
   * The AutoTextFieldEvent class defines an event to signal a
   * <ocde>AutoTextField</code> object's text was changed.
   *
   * @author Jon Buffington
   *
   * @see org.juicekit.visual.controls.AutoTextField
   */
  public class AutoTextFieldEvent extends Event {


    /**
     * The <code>AutoTextFieldEvent.TEXT_CHANGE</code> constant
     * defines the value of the <code>type</code> property of the event
     * object for a <code>jkTextChange</code> event.
     */
    public static const TEXT_CHANGE:String = "jkTextChange";


    /**
     * Constructor.
     *
     * @param type The event type; indicates the action that caused the event.
     *
     * @param bubbles Specifies whether the event can bubble up
     * the display list hierarchy.
     *
     * @param cancelable Specifies whether the behavior associated
     * with the event can be prevented.
     *
     * @param oldText Contains the field's text prior to the change.
     *
     * @param newText Contains the field's text after to the change.
     */
    public function AutoTextFieldEvent(type:String,
                  bubbles:Boolean = true,
                  cancelable:Boolean = false,
                  oldText:String = "",
                  newText:String = "") {
      super(type, bubbles, cancelable);

      this.oldText = oldText;
      this.newText = newText;
    }


    /**
     * Contains the field's text prior to the change.
     */
    public var oldText:String;


    /**
     * Contains the field's text after to the change.
     */
    public var newText:String;


    /**
     * @inheritDoc
     */
    override public function clone():Event {
      return new AutoTextFieldEvent(type, bubbles, cancelable, oldText, newText);
    }
  }
}
