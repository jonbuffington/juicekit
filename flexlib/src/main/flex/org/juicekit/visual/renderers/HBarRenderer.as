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

  /**
   * Determines the positive fill color.
   *
   * @default 0x000000
   */
  [Style(name="color", type="uint", format="Color", inherit="yes")]

  /**
   * Determines the inverse fill color.
   *
   * @default NaN
   *
   */
  [Style(name="backgroundColor", type="uint", format="Color", inherit="no")]

  /**
   * Maximum width in pixels of the text label before clipping occurs.
   *
   * @default 30
   */
  [Style(name="textWidth", type="Number", format="Length", inherit="no")]

  /**
   *  Number of pixels between the text labels and the horizontal bar.
   *
   * @default 2
   */
  [Style(name="gapWidth", type="Number", format="Length", inherit="no")]

  include "../styles/metadata/PaddingStyles.as";
  include "../styles/metadata/TextStyles.as";


  /**
   * The HBarRenderer class draws a text label and a horizontal bar using
   * the numeric value assigned to this renderer's <code>data</code> property.
   *
   * @author Jon Buffington
   */
  public class HBarRenderer extends NumberRendererBase {


    // Invoke the class constructor to initialize the CSS defaults.
    classConstructor();

    private static function classConstructor():void {
      CSSUtil.setDefaultsFor("HBarRenderer",
        { color: 0x000000
        , backgroundColor: NaN
        , fontColor: 0x000000
        , fontFamily: "Verdana"
        , fontSize: 10
        , fontStyle: "normal"
        , fontWeight: "normal"
        , textAlign: "left"
        , textWidth: 30
        , gapWidth: 2
        , paddingLeft: 0
        , paddingRight: 0
        , paddingTop: 0
        , paddingBottom: 0
        }
      );
    }


    /**
     * Constructor.
     */
    public function HBarRenderer() {
      super();
    }


    /**
     * @private
     *
     * Support text display within this renderer.
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
      const textWidthStyle:Number = getStyle("textWidth");
      textWidth = Math.max(textWidthStyle, textWidth);

      // Add in the padding.
      textWidth += getStyle("paddingLeft") + getStyle("paddingRight");
      textWidth += getStyle("gapWidth");
      textHeight += getStyle("paddingTop") + getStyle("paddingBottom");

      measuredMinWidth = measuredWidth = textWidth;
      measuredMinHeight = measuredHeight = textHeight;
    }


    /**
     * @private
     */
    override protected function commitProperties():void {
      if (dataPropertyChanged) {
        if (listData) {
          var dg:DataGrid = listData.owner as DataGrid;
          var dgc:DataGridColumn = dg.columns[listData.columnIndex];
          _text.text = dgc.itemToLabel(data);
        }
        else {
          _text.text = data.toString();
        }
      }

      super.commitProperties();
    }


    /**
     * Support rendering both absolute and percentage values. Absolute values
     * are compared against maximalValue to synthesize a percentage value.
     *
     * @see MaxDataGridColumn
     */
    override protected function get numberValue():Number {
      var retVal:Number = super.numberValue;

      if (listData) {
        var dg:DataGrid = listData.owner as DataGrid;
        var dgc:DataGridColumn = dg.columns[listData.columnIndex];
        if (dgc is MaxDataGridColumn) {
          retVal /= MaxDataGridColumn(dgc).maximalValue;
          retVal *= 100.0;
        }
        // otherwise the data value is assumed to be a percentage
      }

      return retVal;
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

      _text.setColor(getStyle("fontColor"));

      // Look up the style properties
      const color:Number = getStyle("color");
      const bkgndColor:Number = getStyle("backgroundColor");

      const paddingLeft:Number = getStyle("paddingLeft");
      const paddingTop:Number = getStyle("paddingTop");
      const paddingRight:Number = getStyle("paddingRight");
      const paddingBottom:Number = getStyle("paddingBottom");

      const textWidth:Number = getStyle("textWidth");
      const gapWidth:Number = getStyle("gapWidth");
      const labelWidth:Number = textWidth + gapWidth;

      // cell dimensions
      const insetX:Number = paddingLeft + paddingRight;
      const insetY:Number = paddingTop + paddingBottom;
      const cellHeight:Number = unscaledHeight - insetY;

      // bar dimensions
      const maxBarWidth:Number = unscaledWidth - labelWidth - insetX;
      const barWidth:Number = Math.max(0, maxBarWidth);
      const barX:Number = paddingLeft + labelWidth;
      const barY:Number = paddingTop;
      const barHeight:Number = cellHeight;

      // Calculate length as a percentage of available bar width.
      const clippedValue:Number = Math.min(numberValue, 100.0);
      const barLength:Number = clippedValue * barWidth / 100.0;

      // begin drawing...
      const g:Graphics = this.graphics;
      g.clear();
      g.lineStyle(); // no border

      // draw the background fill
      if ((barWidth > 0) && (barHeight > 0) && !isNaN(barLength)) {
        if (isNaN(bkgndColor)) {
          g.beginFill(0, 0.0);
        }
        else {
          g.beginFill(bkgndColor, this.alpha);
        }
        g.drawRect(barX, barY, barWidth, barHeight);
        g.endFill();
      }

      // draw the foreground fill
      if ((barLength > 0) && (barHeight > 0)) {
        g.beginFill(color, this.alpha);
        g.drawRect(barX, barY, barLength, barHeight);
        g.endFill();
      }

      // Position the text last.
      var lm:TextLineMetrics = measureText(_text.text);
      _text.x = paddingLeft;
      _text.y = unscaledHeight / 2.0;
      _text.y -= lm.ascent;			// Use ascent for number text as
                      // numbers are CAPS.
      _text.height = cellHeight;
      _text.width = textWidth;		// Width is specified in style
    }
  }
}
