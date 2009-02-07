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

  import flare.animate.TransitionEvent;
  import flare.animate.Transitioner;
  import flare.display.DirtySprite;
  import flare.vis.Visualization;
  import flare.vis.data.DataSprite;

  import flash.display.Graphics;
  import flash.events.MouseEvent;
  import flash.geom.Rectangle;

  import mx.events.ResizeEvent;
  import mx.styles.StyleManager;


  /**
   * Dispatched when the user clicks a pointing device over a
   * <code>TreemapControl</code> instance's rectangle.
   *
   * @eventType org.juicekit.events.DataMouseEvent.CLICK
   */
  [Event(name="jkDataClick", type="org.juicekit.events.DataMouseEvent")]

 /**
   * Dispatched when the user clicks a pointing device over a
   * <code>TreemapControl</code> instance's rectangle.
   *
   * @eventType org.juicekit.events.DataMouseEvent.DOUBLE_CLICK
   */
  [Event(name="jkDataDoubleClick", type="org.juicekit.events.DataMouseEvent")]

  /**
   * Dispatched when the user moves a pointing device away from
   * <code>TreemapControl</code> instance's rectangle.
   *
   * @eventType org.juicekit.events.DataMouseEvent.MOUSE_OUT
   */
  [Event(name="jkDataMouseOut", type="org.juicekit.events.DataMouseEvent")]

  /**
   * Dispatched when the user moves a pointing device over a
   * <code>TreemapControl</code> instance's rectangle.
   *
   * @eventType org.juicekit.events.DataMouseEvent.MOUSE_OVER
   */
  [Event(name="jkDataMouseOver", type="org.juicekit.events.DataMouseEvent")]

  /**
   * Dispatched when an animating <code>Visualization</code>
   * update begins the animation <code>Transition</code>
   *
   * @eventType flare.animate.TransitionEvent
   */
  [Event(name="start", type="flare.animate.TransitionEvent")]

  /**
   * Dispatched when an animating <code>Visualization</code>
   * update completes the animation <code>Transition</code>
   *
   * @eventType flare.animate.TransitionEvent
   */
  [Event(name="end", type="flare.animate.TransitionEvent")]


  /**
   * Specifies the opaque background color of the control.
   * The default value is <code>undefined</code>.
   * If this style is undefined, the control has a transparent background.
   */
  [Style(name="backgroundColor", type="uint", format="Color", inherit="no")]

  include "../styles/metadata/PaddingStyles.as";


  /**
   * The class <code>FlareControlBase</code> provides a common implementation
   * for visual controls based upon the prefure.flare <code>Visualization</code>.
   * The class is only intended to be used as a base implementation
   * for custom controls and is not intended to be directly instantiated.
   *
   * @author Jon Buffington
   */
  public class FlareControlBase extends RendererBase {


    // Invoke the class constructor to initialize the CSS defaults.
    classConstructor();

    private static function classConstructor():void {
      CSSUtil.setDefaultsFor("FlareControlBase",
        { paddingLeft: 0
        , paddingRight: 0
        , paddingTop: 0
        , paddingBottom: 0
        }
      );
      // Note: The backgroundColor style property is undefined to support
      // specifing a transparent background.
    }


    /**
     * Constructor.
     */
    public function FlareControlBase() {
      super();
      addEventListener(ResizeEvent.RESIZE, onResize);
    }


    /**
     * Stores reference to the prefuse.flare <code>Visualization</code> context.
     */
    protected var vis:Visualization = null;


    /**
     * @private
     */
    override protected function createChildren():void {
      super.createChildren();

      if (!vis) {
        vis = makeVisualization();
        if (vis) {
          initVisualization();
          addChild(vis);
        }
      }
    }


    /**
     * Create a prefuse.flare <code>Visualization</code> instance.
     *
     * @return Returns a prefuse.flare <code>Visualization</code> instance.
     */
    protected function makeVisualization():Visualization {
      // Create the Visualization instance.
      return new Visualization();
    }


    /**
     * Initialize the control's prefuse.flare
     * <code>Visualization</code> instance. Derived classes should
     * override this function to add operators to the
     * <code>vis</code> object.
     */
    protected function initVisualization():void {
      addEventListeners();
    }


    /**
     * Add any event listeners to the <code>Visualization</code> instance.
     */
    protected function addEventListeners():void {
      // Hook mouse events.
      vis.addEventListener(MouseEvent.CLICK, signalDataMouseEvent);
      vis.addEventListener(MouseEvent.DOUBLE_CLICK, signalDataMouseEvent);
      vis.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
      vis.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
    }


    /**
     * Remove any event listeners from the <code>Visualization</code> instance.
     */
    protected function removeEventListeners():void {
      // Hook mouse events.
      vis.removeEventListener(MouseEvent.CLICK, signalDataMouseEvent);
      vis.removeEventListener(MouseEvent.DOUBLE_CLICK, signalDataMouseEvent);
      vis.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
      vis.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
    }


    /**
     * Handle mouse out events.
     */
    protected function onMouseOut(event:MouseEvent):void {
      const ds:DataSprite = event.target as DataSprite;
      if (!ds) {
        return;
      }

      signalDataMouseEvent(event);
    }


    /**
     * Handle mouse over events.
     */
    protected function onMouseOver(event:MouseEvent):void {
      const ds:DataSprite = event.target as DataSprite;
      if (!ds) {
        return;
      }

      signalDataMouseEvent(event);
    }


    /**
     * Dispatch <code>DataMouseEvent</code> events.
     */
    protected function signalDataMouseEvent(event:MouseEvent):void {
      if (event.target is DataSprite) {
        callLater(function():void {
          dispatchEvent(new DataMouseEvent(event, DataSprite(event.target).data));
        });
      }
    }


    /**
     * Helper function to produce high-order alpha bits from
     * a Number ranging from 0.0 to 1.0 inclusive.
     *
     * @param alpha Is a <code>Number</code> value ranging from 0.0 to 1.0
     * inclusive where 0.0 is transparent and 1.0 is opaque.
     *
     * @return Returns high-order byte encoding of the alpha value.
     */
    protected static function numToAlphaBits(alpha:Number):uint {
      return Math.round(alpha * 255) << 24;
    }


    /**
     * Convert an RGB color value and alpha specification into a flare
     * compatible ARGB color value.
     *
     * @param rgbColor Is a <code>uint</code> holding the red, green, and
     * blue bytes in the lower three bytes.
     *
     * @param alpha Is a <code>Number</code> value ranging from 0.0 to 1.0
     * inclusive where 0.0 is transparent and 1.0 is opaque.
     *
     * @return Returns a flare compatible ARGB color <code>uint</code>.
     */
    protected static function toARGB(rgbColor:uint, alpha:Number):uint {
      const alphaBits:uint = numToAlphaBits(alpha);
      return rgbColor | alphaBits;
    }


    /**
     * Return a flare-style data property string.
     */
    protected function asFlareProperty(propertyName:String):String {
      return "data." + propertyName;
    }


    /**
     * Store the transitionPeriod property.
     */
    private var _transitionPeriod:Number = NaN;

    [Inspectable(category="General")]
    /**
     * Specifies the animation transition time period in seconds. The
     * default value is <code>NaN</code> which disables animation.
     *
     * @default NaN
     */
    public function set transitionPeriod(seconds:Number):void {
      _transitionPeriod = seconds;
    }

    /**
     * @private
     */
    public function get transitionPeriod():Number {
      return _transitionPeriod;
    }


    /**
     * Signal a TransitionEvent.START event on the transient Transitioner
     * to the listener(s).
     */
    private function onStartTransition(event:TransitionEvent):void {
      dispatchEvent(new TransitionEvent(TransitionEvent.START, event.transition));
      event.transition.removeEventListener(TransitionEvent.START, onStartTransition);
    }

    /**
     * Signal a TransitionEvent.END event on the transient Transitioner
     * to the listener(s).
     */
    private function onEndTransition(event:TransitionEvent):void {
      dispatchEvent(new TransitionEvent(TransitionEvent.END, event.transition));
      event.transition.removeEventListener(TransitionEvent.END, onEndTransition);
    }

    /**
     * Call the <code>update</code> method on the visualization. The
     * <code>transitionPeriod</code> property is used to determine
     * whether animation is appropriate. If animation is appropriate,
     * this method will signal <code>TransitionEvent.START</code>
     * and <code>TransitionEvent.END</code> to any listeners.
     */
    protected function updateVisualization():void {
      if (vis) {
        if (isNaN(transitionPeriod)) {
          vis.update();
        }
        else {
          const t:Transitioner = vis.update(transitionPeriod);
          if (hasEventListener(TransitionEvent.START)) {
            t.addEventListener(TransitionEvent.START, onStartTransition);
          }
          if (hasEventListener(TransitionEvent.END)) {
            t.addEventListener(TransitionEvent.END, onEndTransition);
          }
          t.play();
        }

        // Force a flush of flare's unrendered changes.
        DirtySprite.renderDirty();
      }
    }


    /**
     * @private
     */
    override protected function measure():void {
      var defaultWidth:Number = 0;
      var defaultHeight:Number = 0;

      if (vis) {
        defaultWidth = vis.bounds.width;
        defaultHeight = vis.bounds.height;
      }

      // Add in the padding.
      defaultWidth += getStyle("paddingLeft") + getStyle("paddingRight");
      defaultHeight += getStyle("paddingTop") + getStyle("paddingBottom");

      measuredMinWidth = measuredWidth = defaultWidth;
      measuredMinHeight = measuredHeight = defaultHeight;
    }


    /**
     * Translate control resizing into Visualization bounds updates.
     */
    private function onResize(event:ResizeEvent):void {
      if (vis) {
        const r:Rectangle = calcPaddedBounds(width, height);
        vis.x = r.x;
        vis.y = r.y;
        vis.bounds = r;
      }
    }


    /**
     * Calculates a <code>Rectangle</code> inset by any padding styles.
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

      // Force an update to the visualization to handle resizing.
      if (vis && vis.data) {
        updateVisualization();
      }
    }
  }
}
