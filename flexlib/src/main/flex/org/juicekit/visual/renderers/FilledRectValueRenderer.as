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


  /**
   * Stroke color used when drawing the rectangles.
   *
   * @default 0xCCCCCC
   */
  [Style(name="rectStrokeColor", type="uint", format="Color", inherit="no")]

  /**
   * Pixel outline stroke size of a rectangle.
   *
   * @default 1
   */
  [Style(name="rectStrokeSize", type="Number", format="Length", inherit="no")]

   /**
   * Fill color used when drawing the rectangles.
   *
   * @default 0x333E3E
   */
  [Style(name="rectFillColor", type="uint", format="Color", inherit="no")]

   /**
   * Fill color used when drawing the off rectangles.
   *
   * @default 0xCCCCCC
   */
  [Style(name="offRectFillColor", type="uint", format="Color", inherit="no")]

  /**
   * Pixel spacing between the rectangles.
   *
   * @default 2
   */
  [Style(name="rectGap", type="Number", format="Length", inherit="no")]

  /**
   * Pixel width of each rectangle.
   *
   * @default 5
   */
  [Style(name="rectWidth", type="Number", format="Length", inherit="no")]

  /**
   * Pixel height of each rectangle.
   *
   * @default 6
   */
  [Style(name="rectHeight", type="Number", format="Length", inherit="no")]

  /**
   * Number of rectangles to display.
   *
   * @default 5
   */
  [Style(name="rectCount", type="uint", inherit="no")]

  include "../styles/metadata/PaddingStyles.as";


  /**
   * The FilledRectValueRenderer class renderers numeric <code>data</code>
   * filling up to <code>rectCount</code> number of rectangles.
   * This renderer is useful for decorating values with a value scale
   * from 1 to <code>rectCount</code> where <code>rectCount</code> represents
   * the highest weighted value.
   *
   * <p>The <code>data</code> range is 0 to <code>rectCount</code> inclusive.</p>
   */
  public class FilledRectValueRenderer extends NumberRendererBase {


    // Invoke the class constructor to initialize the CSS defaults.
    classConstructor();

    private static function classConstructor():void {
      const defaultColor:uint = 0xCCCCCC;
      CSSUtil.setDefaultsFor("FilledRectValueRenderer",
        { rectStrokeColor: defaultColor
        , rectStrokeSize: 1
        , rectFillColor: 0x333E3E
        , offRectFillColor: defaultColor
        , rectGap: 2
        , rectWidth: 5
        , rectHeight: 6
        , rectCount: 5
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
    public function FilledRectValueRenderer() {
      super();
    }


    private var rectsToFill:uint = 0;


    /**
     * @private
     */
    override protected function commitProperties():void {
      if (dataPropertyChanged) {
        const n:uint = numberValue;
        if (isNaN(n)) {
          rectsToFill = 0;
        }
        else {
          const rectCount:uint = getStyle("rectCount");
          rectsToFill = Math.min(n, rectCount);
        }
      }

      super.commitProperties();
    }


    /**
     * Calculate the width of all rects.
     */
    private function get rectsWidth():Number {
      const rectCount:uint = getStyle("rectCount");
      const rectWidth:Number = getStyle("rectWidth");
      const rectGap:Number = getStyle("rectGap");
      return rectCount * rectWidth + (rectCount - 1) * rectGap;
    }


    /**
     * @private
     */
    override protected function measure():void {
      super.measure();

      // Add in the padding.
      var w:Number = getStyle("paddingLeft") + getStyle("paddingRight") + rectsWidth;
      var h:Number = getStyle("paddingTop") + getStyle("paddingBottom");

      measuredMinWidth = measuredWidth = w;
      measuredMinHeight = measuredHeight = h;
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

      const paddingLeft:Number = getStyle("paddingLeft");
      const paddingTop:Number = getStyle("paddingTop");
      const paddingRight:Number = getStyle("paddingRight");
      const paddingBottom:Number = getStyle("paddingBottom");

      const insetX:Number = paddingLeft + paddingRight;
      const insetY:Number = paddingTop + paddingBottom;
      const insetW:Number = unscaledWidth - insetX;
      const insetH:Number = unscaledHeight - insetY;

      const rectFillColor:uint = getStyle("rectFillColor");
      const offRectFillColor:uint = getStyle("offRectFillColor");
      const rectWidth:Number = getStyle("rectWidth");
      const rectHeight:Number = getStyle("rectHeight");
      const rectGap:Number = getStyle("rectGap");
      const rectCount:Number = getStyle("rectCount");
      const leftCoord:Number = unscaledWidth - paddingRight - rectsWidth;
      const topCoord:Number = (insetH - rectHeight) / 2;
      const xIncr:Number = rectWidth + rectGap;

      const g:Graphics = graphics;
      g.clear();
      g.lineStyle(getStyle("rectStrokeSize"), getStyle("rectStrokeColor"), this.alpha);
      for (var i:uint = 0, x:Number = leftCoord; i < rectCount; i++, x += xIncr) {
        if (rectsToFill > i) {
          g.beginFill(rectFillColor, this.alpha);
        }
        else {
          g.beginFill(offRectFillColor, this.alpha);
        }
        g.drawRect(x, topCoord, rectWidth, rectHeight);
        g.endFill();
      }
    }

  }
}
