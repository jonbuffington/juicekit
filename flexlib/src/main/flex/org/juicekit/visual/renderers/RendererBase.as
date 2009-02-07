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


package org.juicekit.visual.renderers {

  import mx.controls.listClasses.BaseListData;
  import mx.controls.listClasses.IDropInListItemRenderer;
  import mx.controls.listClasses.IListItemRenderer;
  import mx.core.IDataRenderer;
  import mx.core.UIComponent;
  import mx.events.FlexEvent;


  //--------------------------------------
  //  Events
  //--------------------------------------

  /**
   *  Dispatched when the <code>data</code> property changes.
   *
   *  <p>When you use a component as an item renderer,
   *  the <code>data</code> property contains the data to display.
   *  You can listen for this event and update the component
   *  when the <code>data</code> property changes.</p>
   *
   *  @eventType mx.events.FlexEvent.DATA_CHANGE
   */
  [Event(name="dataChange", type="mx.events.FlexEvent")]


  //--------------------------------------
  //  Excluded APIs
  //--------------------------------------
  [Exclude(name="focusEnabled", kind="property")]
  [Exclude(name="focusPane", kind="property")]
  [Exclude(name="mouseFocusEnabled", kind="property")]
  [Exclude(name="tabEnabled", kind="property")]
  [Exclude(name="focusBlendMode", kind="style")]
  [Exclude(name="focusSkin", kind="style")]
  [Exclude(name="focusThickness", kind="style")]
  [Exclude(name="errorColor", kind="style")]
  [Exclude(name="setFocus", kind="method")]


  /**
   * The class RendererBase provides a common implementation of IDataRenderer,
   * IListItemRenderer, and IDropInListItemRenderer for custom ActionScript
   * renderers. The class is only intended to be used as a base implementation
   * for custom renderers and is not intended to be directly instantiated.
   *
   * @author Jon Buffington
   */
  public class RendererBase extends UIComponent
                implements IDataRenderer,
                      IListItemRenderer,
                      IDropInListItemRenderer {


    /**
     * Constructor.
     */
    public function RendererBase() {
      super();
    }


    private var _listData:BaseListData;

    /**
     * Implement the IDropInListItemRenderer interface.
     */
    public function get listData():BaseListData {
      return _listData;
    }

    public function set listData(value:BaseListData):void {
      _listData = value;
    }


    /**
     * Indicated whether the data property was changed. This property
     * is intended to be used when overriding the
     * <code>commitProperties</code> function.
     */
    protected var dataPropertyChanged:Boolean = false;


    /**
     * Reset the <code>dataPropertyChanged</code> and invalidate
     * the display list.
     */
    override protected function commitProperties():void {
      if (dataPropertyChanged) {
        dataPropertyChanged = false;
        invalidateDisplayList();
      }
      super.commitProperties();
    }


    /*
     * Stores a reference to the data property's value.
     */
    private var _dataValue:Object;

    /**
     * Implement the IDataRenderer interface.
     */
    [Bindable("dataChange")]
    [Inspectable(category="Common")]
    public function get data():Object {
      return _dataValue;
    }

    /**
     * @private
     */
    public function set data(value:Object):void {
      if (value !== _dataValue) {
        _dataValue = value;
        dataPropertyChanged = true;
        invalidateProperties();
        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
    }

  }
}
