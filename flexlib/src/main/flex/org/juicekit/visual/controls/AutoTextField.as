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


package org.juicekit.visual.controls {

  import org.juicekit.events.AutoTextFieldEvent;

  import flash.events.FocusEvent;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;

  import mx.controls.TextInput;


  /**
   * Dispatched when the enter key or the click focus changes.
   *
   * @eventType org.juicekit.events.AutoTextFieldEvent.INACTIVITY_PERIOD
   */
  [Event(name="jkTextChange", type="org.juicekit.events.AutoTextFieldEvent")]


  /**
   * The AutoTextField class supports directly editing a static-like text field.
   * Editing text is initiated by clicking on the static text.
   * Successful text edits are completed by using the ENTER key or
   * causing the focus to leave the edit field. Text edits can be aborted
   * by using the escape (ESC) key while the edit field is active.
   *
   * @author Jon Buffington
   */
  public class AutoTextField extends TextInput {


    /**
     * Constructor.
     */
    public function AutoTextField() {
      super();

      // default to  disabled state
      enabled = false;

      // hook event handlers
      addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
      addEventListener(KeyboardEvent.KEY_UP, handleKeys);
      addEventListener(FocusEvent.FOCUS_OUT, handleFocusLoss);
    }

    private var _priorTitle:String;	// Used to restore the title string.
    private var _priorColor:uint;

    private function startTitleEdit():void {
      if (!enabled) {
        enabled = true;
        _priorTitle = text;
        _priorColor = getStyle("color");
        setSelection(0, length);
        setStyle("color", getStyle("themeColor"));
      }
    }

    private function abortTitleEdit():void {
      if (enabled) {
        enabled = false;
        text = _priorTitle;	// Restore the text.
        setStyle("color", _priorColor);
      }
    }

    private function endTitleEdit():void {
      if (enabled) {
        enabled = false;
        if (_priorTitle !== text) {
          setStyle("disabledColor", 0);

          dispatchEvent(new AutoTextFieldEvent(AutoTextFieldEvent.TEXT_CHANGE
                            , true
                            , false
                            , _priorTitle
                            , text
                            ));
        }
        else {
          setStyle("color", _priorColor);
        }

        _priorTitle = null;
      }
    }

    /**
     * @private
     *
     * We hook the mouseDown event instead of the click event in order
     * to force selection of the entire text. The default handler of placing
     * the cursor is prevented.
     */
    private function mouseDown(event:MouseEvent):void {
      if (!enabled) {
        startTitleEdit();
        event.preventDefault();
      }
    }

    private function handleFocusLoss(event:FocusEvent):void {
      endTitleEdit();
    }

    private function handleKeys(event:KeyboardEvent):void {
      switch (event.keyCode) {
        // ENTER
        case 13:	// enter or return keys
          endTitleEdit();
          break;
        case 27:	// escape key
          abortTitleEdit();
      }
    }
  }
}
