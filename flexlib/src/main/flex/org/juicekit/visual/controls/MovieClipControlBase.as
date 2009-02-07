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
  import org.juicekit.events.DataMouseEvent;
  import org.juicekit.util.helper.CSSUtil;
  import org.juicekit.visual.renderers.RendererBase;

  import flash.display.DisplayObjectContainer;
  import flash.display.Graphics;
  import flash.display.MovieClip;
  import flash.display.SimpleButton;
  import flash.events.MouseEvent;
  import flash.geom.ColorTransform;
  import flash.geom.Point;
  import flash.geom.Rectangle;

  import mx.collections.ArrayCollection;
  import mx.events.ResizeEvent;
  import mx.styles.StyleManager;


  /**
   * Dispatched when the user clicks a pointing device over a
   * <code>MovieClipControlBase</code> instance's rectangle.
   *
   * @eventType org.juicekit.events.DataMouseEvent.CLICK
   */
  [Event(name="jkDataClick", type="org.juicekit.events.DataMouseEvent")]

 /**
   * Dispatched when the user clicks a pointing device over a
   * <code>MovieClipControlBase</code> instance's rectangle.
   *
   * @eventType org.juicekit.events.DataMouseEvent.DOUBLE_CLICK
   */
  [Event(name="jkDataDoubleClick", type="org.juicekit.events.DataMouseEvent")]

  /**
   * Dispatched when the user moves a pointing device away from
   * <code>MovieClipControlBase</code> instance's rectangle.
   *
   * @eventType org.juicekit.events.DataMouseEvent.MOUSE_OUT
   */
  [Event(name="jkDataMouseOut", type="org.juicekit.events.DataMouseEvent")]

  /**
   * Dispatched when the user moves a pointing device over a
   * <code>MovieClipControlBase</code> instance's rectangle.
   *
   * @eventType org.juicekit.events.DataMouseEvent.MOUSE_OVER
   */
  [Event(name="jkDataMouseOver", type="org.juicekit.events.DataMouseEvent")]


  /**
   * Specifies the opaque background color of the control.
   * The default value is <code>undefined</code>.
   * If this style is undefined, the control has a transparent background.
   */
  [Style(name="backgroundColor", type="uint", format="Color", inherit="no")]

  include "../styles/metadata/PaddingStyles.as";


  /**
   * The MovieClipControlBase class provides a wrapper for a Flash
   * <code>MovieClip</code> that contains <code>SimpleButton</code> children.
   * The wrapped MovieClip's SimpleButton children dispatch mouse events
   * and are colored based on data and a colorEncoding function.
   *
   * <p>Note: This class is only a base class for more specific classes.</p>
   *
   * @author Jon Buffington
   */
  public class MovieClipControlBase extends RendererBase {


    // Invoke the class constructor to initialize the CSS defaults.
    classConstructor();

    private static function classConstructor():void {
      CSSUtil.setDefaultsFor("MovieClipControlBase",
        { paddingLeft: 0
        , paddingRight: 0
        , paddingTop: 0
        , paddingBottom: 0
        }
      );
    }


    /**
     * Stores a reference to the wrapped <code>MovieClip</code>.
     */
    protected var _clip:MovieClip = null;


    /**
     * Constructor.
     */
    public function MovieClipControlBase() {
      super();

      // Handle runtime resizing.
      addEventListener(ResizeEvent.RESIZE, onResize);
    }


    /**
     * Return an instance of a specific <code>MovieClip</code> derived class.
     *
     * <p>Note: This method is required to be
     * overridden in the derived class.</p>
     */
    protected function createMovieClip():MovieClip {
      return null;
    }


    /**
     * @private
     */
    override protected function createChildren():void {
      super.createChildren();

      if (!_clip) {
        _clip = createMovieClip();
        addChild(_clip);

        _clip.addEventListener(MouseEvent.CLICK, signalDataMouseEvent);
        _clip.addEventListener(MouseEvent.DOUBLE_CLICK, signalDataMouseEvent);
        _clip.addEventListener(MouseEvent.MOUSE_OUT, signalDataMouseEvent);
        _clip.addEventListener(MouseEvent.MOUSE_OVER, signalDataMouseEvent);
      }
    }


    /**
     * Dispatch a mouse event and its related data.
     */
    protected function signalDataMouseEvent(event:MouseEvent):void {
      const simpleButton:SimpleButton = event.target as SimpleButton;
      if (simpleButton) {
        // Make the local mouse coordinates local to this control.
        const localPt:Point = this.globalToLocal(new Point(event.stageX, event.stageY));
        event.localX = localPt.x;
        event.localY = localPt.y;

        // Dispatch a DataMouseEvent for the event's target.
        dispatchEvent(new DataMouseEvent(event, getButtonData(simpleButton)));
      }
    }


    /**
     * Return the data object associated with the target
     * <code>DisplayObject</code>.
     */
    protected function getButtonData(simpleButton:SimpleButton):Object {
      var retVal:Object = null;

      if (data !== null) {
        const sbInstanceName:String = simpleButton.name;
        const dataArr:Array = data as Array;
        const n:int = dataArr.length;

        for (var i:int = 0; i < n; i++) {
          retVal = dataArr[i];
          if (retVal[dataKeyField] === sbInstanceName) {
            break;
          }
          else {
            retVal = null;
          }
        }
      }

      return retVal;
    }


    /**
     * @private
     */
    override protected function measure():void {
      var defaultWidth:Number = 0;
      var defaultHeight:Number = 0;

      if (_clip) {
        defaultWidth = _clip.width;
        defaultHeight = _clip.height;
      }

      // Add in the padding.
      defaultWidth += getStyle("paddingLeft") + getStyle("paddingRight");
      defaultHeight += getStyle("paddingTop") + getStyle("paddingBottom");

      measuredMinWidth = measuredWidth = defaultWidth;
      measuredMinHeight = measuredHeight = defaultHeight;
    }


   /**
    * Translate control resizing into <code>MovieClip</code> bounds updates.
    */
    private function onResize(event:ResizeEvent):void {
      if (_clip) {
        const r:Rectangle = calcPaddedBounds(width, height);
        _clip.x = r.x;
        _clip.y = r.y;
        _clip.width = r.width;
        _clip.height = r.height;
      }
    }


    /**
     * Return a <code>Rectangle</code> inset by any padding styles.
     *
     * @param w Is the maximum width before any padding is subtracted.
     *
     * @param h Is the maximum height before any padding is subtracted.
     *
     * @return Returns a rectangle inset by the padding styles.
     */
    protected function calcPaddedBounds(w:Number, h:Number):Rectangle {
      const paddingLeft:Number = getStyle("paddingLeft");
      const paddingTop:Number = getStyle("paddingTop");
      const r:Rectangle = new Rectangle();
      r.x = paddingLeft;
      r.y = paddingTop;
      r.width = w - (paddingLeft + getStyle("paddingRight"));
      r.height = h - (paddingTop + getStyle("paddingBottom"));
      return r;
    }


    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
      if (unscaledWidth === 0 && unscaledHeight === 0) {
        return;
      }

      // Clear the default graphics.
      const g:Graphics = this.graphics;
      g.clear();

      const backgroundColor:* = getStyle("backgroundColor");
      const hasBgColor:Boolean = StyleManager.isValidStyleValue(backgroundColor);

      // Draw a background?
      if (hasBgColor) {
        const r:Rectangle = calcPaddedBounds(unscaledWidth, unscaledHeight);

        g.lineStyle();
        g.beginFill(backgroundColor);
        g.drawRect(r.x, r.y, r.width, r.height);
        g.endFill();
      }

      // Apply color encoding function to clip.
      if (_clip) {
        clearMap();
        const table:Array = data as Array;
        if (table) {
          encodeMap(table);
        }
      }
    }


    /**
     * @private
     *
     * Reset any color transformations on each SimpleButton instance.
     */
    private function clearMap():void {
      var sb:SimpleButton;
      const doc:DisplayObjectContainer = clipDisplayObjectContainer();
      const n:int = doc.numChildren;
      for (var i:int = 0; i < n; i++) {
        sb = doc.getChildAt(i) as SimpleButton;
        if (sb) {
          sb.transform.colorTransform = new ColorTransform();
        }
      }
    }


    /**
     * @private
     *
     * Encode map colors by applying the colorEncodingFunction
     * to the array of data objects.
     */
    protected function encodeMap(table:Array):void {
      var sb:SimpleButton;
      var rowObject:Object;
      var colorTransform:ColorTransform;
      var sbName:String;

      const doc:DisplayObjectContainer = clipDisplayObjectContainer();

      if (colorEncodingFunction !== null) {
        const numRows:int = table.length;
        for (var i:int = 0; i < numRows; i++) {
          rowObject = table[i];
          sbName = rowObject[dataKeyField] as String;
          if (sbName) {
            sb = doc.getChildByName(sbName) as SimpleButton;
            if (sb) {
              colorTransform = sb.transform.colorTransform;
              colorTransform.color = colorEncodingFunction(sb.name, rowObject);
              sb.transform.colorTransform = colorTransform;
            }
          }
          else {
            trace("Warning: No string value in data for property '" + dataKeyField + "'.");
          }
        }
      }
    }


    /**
     * Return the MovieClip's <code>DisplayObjectContainer</code> containing
     * the <code>SimpleButton</code>s to encode.
     */
    protected function clipDisplayObjectContainer():DisplayObjectContainer {
      return _clip;
    }


    /**
     * Stores an <code>Array</code> or
     * <code>ArrayCollection</code> of objects
     * whose properties will be used to change the appearance of the the
     * <code>MovieClip</code>'s <code>SimpleButton</code> children.
     */
    override public function set data(value:Object):void {
      function verify(o:Object):Object {
        if (o is Array) {
          return o;
        }
        else if (o is ArrayCollection) {
          return ArrayCollection(o).source;
        }
        else {
          trace("Warning: MovieClipControlBase.data must be an Array or ArrayCollection.")
          return null;
        }
      }

      if (value !== super.data) {
        super.data = value ? verify(value) : null;

        invalidateDisplayList();
      }
    }

    /**
     * @private
     */
    override public function get data():Object {
      return super.data;
    }


    /**
     *  @private
     *  Stores the colorEncodingFunction property.
     */
    private var _colorEncodingFunction:Function = null;

    [Inspectable(category="General")]
    /**
     * References a function that returns a <code>uint</code>
     * color value that is applied to the graphical element. The function
     * is passed a <code>SimpleButton</code>'s name and
     * a data <code>Object</code> matched to the name.
     *
     * <p>The function signature is:
     * <pre>f(name:String, data:Object):uint</pre>
     * </p>
     *
     * @default null
     */
    public function set colorEncodingFunction(value:Function):void {
      _colorEncodingFunction = value;
      invalidateDisplayList();
    }

    /**
     * @private
     */
    public function get colorEncodingFunction():Function {
      return _colorEncodingFunction;
    }


    /**
     * @private
     * Stores the dataKeyField property.
     */
    private var _dataKeyField:String = "name";

    [Inspectable(category="General")]
    /**
     * Specifies the data <code>Object</code> property name
     * that maps to <code>SimpleButton</code> instance names.
     *
     * @default "name"
     */
    public function set dataKeyField(value:String):void {
      if (value !== _dataKeyField) {
        _dataKeyField = value;
        invalidateDisplayList();
      }
    }

    /**
     * @private
     */
    public function get dataKeyField():String {
      return _dataKeyField;
    }
  }
}
