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

  import org.juicekit.util.helper.CSSUtil;

  import flash.display.Graphics;
  import flash.text.TextLineMetrics;

  import mx.controls.DataGrid;
  import mx.controls.dataGridClasses.DataGridColumn;
  import mx.core.UITextField;


  //--------------------------------------
  //  Styles
  //--------------------------------------
  [Style(name="labelWidth", type="Number", format="Length", inherit="no")]
  [Style(name="labelGap", type="Number", format="Length", inherit="no")]

  include "../styles/metadata/PaddingStyles.as";

  /*
   * Skin choices for how the custom renderer properties (bar, tick, and dot)
   * are drawn.
   */
  [Style(name="ruleColor", type="uint", format="Color", inherit="no")]
  [Style(name="tickColor", type="uint", format="Color", inherit="no")]
  [Style(name="tickWidth", type="Number", format="Length", inherit="no")]
  [Style(name="tickHeight", type="Number", format="Length", inherit="no")]
  [Style(name="dotColor", type="uint", format="Color", inherit="no")]
  [Style(name="dotRadius", type="Number", format="Length", inherit="no")]



  /**
   * The TripleValueRenderer class displays three values (bar, tick, and dot)
   * against a maximum value. Set the
   * <code>data</code> property to an object containing
   * <code>label</code>, <code>bar</code>, <code>tick</code>,
   * and <code>dot</code> properties.
   *
   * @author Jon Buffington
   */
  public class TripleValueRenderer extends RendererBase {


  // Set-up defaults for the custom CSS properties.
    classConstructor();

    private static function classConstructor():void {
      CSSUtil.setDefaultsFor("TripleValueRenderer",
        { labelWidth: 20
        , labelGap:4
        , ruleColor:0x000000
        , tickColor:0x000000
        , tickWidth:2
        , tickHeight:8
        , dotColor:0x000000
        , dotRadius:4
        }
      );
    }

    public function TripleValueRenderer(maximalValue:Number = NaN) {
      super();
      this.maximalValue = maximalValue;
    }

    /**
     * Add text display to this component.
     */
    private var _text:UITextField;


    /**
     * @private
     */
    override protected function createChildren():void {
      super.createChildren();

      if (!_text) {
        _text = new UITextField();
        _text.styleName = this;
        addChild(_text);
      }
    }

    /**
     * Custom data properties extracted from the 'data' object.
     */
    private var _barVal:Number;
    private var _tickVal:Number;
    private var _dotVal:Number;


    /**
     * @private
     */
    override protected function commitProperties():void {
      if (dataPropertyChanged) {
        var o:Object;
        if (listData) {
          var dg:DataGrid = listData.owner as DataGrid;
          var dgc:DataGridColumn = dg.columns[listData.columnIndex];
          o = data[dgc.dataField];
        }
        else {
          o = data;
        }

        _text.text = o && o.hasOwnProperty("label") ? o.label : " ";
        _barVal = o && o.hasOwnProperty("bar") ? o.bar : NaN;
        _tickVal = o && o.hasOwnProperty("tick") ? o.tick : NaN;
        _dotVal = o && o.hasOwnProperty("dot") ? o.dot : NaN;
      }

      super.commitProperties();
    }


    /**
     * Support rendering both absolute and percentage values. Absolute values
     * are compared against maximalValue to synthesize a percentage value.
     */
    public var maximalValue:Number;

    private function relativeValue(absVal:Number):Number {
      return isNaN(maximalValue) ? absVal : absVal / maximalValue * 100.0;
    }

    private function clampValue(value:Number,
                  width:Number,
                  leftOffset:Number = 0,
                  rightOffset:Number = 0):Number {
      // Get relative (%) value clamped to 100%.
      const percent:Number = Math.min(relativeValue(value), 100.0);
      // Translate relative % to position.
      var x:Number =  percent * width / 100.0;

      // Offset from the left?
      if (x < leftOffset) {
        x = leftOffset
      }
      // Offset from the right?
      const rightBoundary:Number = width - rightOffset;
      if (x > rightBoundary) {
        x = rightBoundary;
      }
      return x;
    }


    /**
     * @private
     */
    override protected function measure():void {
      super.measure();

      var textWidth:Number = 0;
      var textHeight:Number = 0;

      if (_text.text) {
        var lm:TextLineMetrics = measureText(_text.text);
        textWidth = lm.width;
        textHeight = lm.height;
      }

      // adjust for specified width
      const textWidthStyle:Number = getStyle("labelWidth");
      textWidth = Math.max(textWidthStyle, textWidth);

      // Add in the padding.
      textWidth += getStyle("paddingLeft") + getStyle("paddingRight");
      textWidth += getStyle("labelGap");
      textHeight += getStyle("paddingTop") + getStyle("paddingBottom");

      measuredMinWidth = measuredWidth = textWidth;
      measuredMinHeight = measuredHeight = textHeight;
    }


    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                          unscaledHeight:Number):void {
      super.updateDisplayList(unscaledWidth, unscaledHeight);

      if (unscaledWidth === 0 && unscaledHeight === 0) {
        return;
      }

      // Set-up the graphics context.
      const g:Graphics = this.graphics;
      g.clear();
      g.lineStyle();

      // Look up the style properties
      const paddingLeft:Number = getStyle("paddingLeft");
      const paddingTop:Number = getStyle("paddingTop");
      const paddingRight:Number = getStyle("paddingRight");
      const paddingBottom:Number = getStyle("paddingBottom");

      const textWidth:Number = getStyle("labelWidth");
      const spacerWidth:Number = getStyle("labelGap");
      const labelWidth:Number = textWidth + spacerWidth;

      // cell dimensions
      const insetX:Number = paddingLeft + paddingRight;
      const insetY:Number = paddingTop + paddingBottom;
      const offsetX:Number = paddingLeft + labelWidth;
      const cellHeight:Number = unscaledHeight - insetY;
      const maxCellWidth:Number = unscaledWidth - labelWidth - insetX;
      const cellWidth:Number = Math.max(0, maxCellWidth);

      // label posiitoning
      var lm:TextLineMetrics = measureText(_text.text);
      _text.x = paddingLeft;
      _text.y = unscaledHeight / 2.0;
      _text.y -= lm.ascent;			// Use ascent for number text as
                      // numbers are CAPS.
      _text.height = cellHeight;
      _text.width = textWidth;		// Width is specified in style

      // -- Bar --
      if (!isNaN(_barVal)) {
        const barColor:Number = getStyle("ruleColor");
        const barX:Number = offsetX;
        const barY:Number = paddingTop;
        const barH:Number = cellHeight;
        // Calculate length as a percentage of available bar width.
        const barLen:Number = clampValue(_barVal, cellWidth);

        if ((barLen > 0) && (barH > 0)) {
          g.beginFill(barColor, this.alpha);
          g.drawRect(barX, barY, barLen, barH);
          g.endFill();
        }
      }

      // -- Tick --
      if (!isNaN(_tickVal)) {
        const tickColor:Number = getStyle("tickColor");
        const tickW:Number = getStyle("tickWidth");
        const tickH:Number = Math.min(getStyle("tickHeight"), cellHeight);
        const tickY:Number = (cellHeight - tickH) / 2.0;
        const tickX:Number = clampValue(_tickVal, cellWidth, tickW, tickW) +
          offsetX - (tickW / 2.0);

        g.beginFill(tickColor, this.alpha);
        g.drawRect(tickX, tickY, tickW, tickH);
        g.endFill();
      }

      // -- Dot --
      if (!isNaN(_dotVal)) {
        const dotColor:Number = getStyle("dotColor");
        const dotR:Number = getStyle("dotRadius");
        const dotY:Number = cellHeight / 2.0;
        const dotX:Number = clampValue(_dotVal, cellWidth, dotR, dotR) + offsetX;

        g.beginFill(dotColor, this.alpha);
        g.drawCircle(dotX, dotY, dotR);
        g.endFill();
      }
    }

  }
}
