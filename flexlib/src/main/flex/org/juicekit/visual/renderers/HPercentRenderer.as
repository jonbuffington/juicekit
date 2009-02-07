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
   * Determines the stroke color of the vertical indicator line.
   *
   * @default 0x000000
   */
  [Style(name="color", type="uint", format="Color", inherit="yes")]

  /**
   * Determines the percentage's fill color.
   *
   * @default 0x8DB3DF
   */
  [Style(name="percentColor", type="uint", format="Color", inherit="yes")]

  /**
   * Determines the percentage's fill color.
   *
   * @default 0xCCCCCC
   */
  [Style(name="remainderColor", type="uint", format="Color", inherit="yes")]


  /**
   * Determines the number of pixels width of the vertical indicator
   * line stroke.
   *
   * @default 2
   */
  [Style(name="indicatorWidth", type="Number", format="Length", inherit="no")]


  /**
   * Determines the number of pixels height of the vertical indicator
   * line stroke.
   *
   * @default 8
   */
  [Style(name="indicatorHeight", type="Number", format="Length", inherit="no")]

  include "../styles/metadata/PaddingStyles.as";


  /**
   * The HPercentRenderer class draws a text label and a horizontal rectangle
   * split into two halves. The left half shows the percent value while the right
   * half shows the remainder. The percentage is a numeric value from 0.0 to
   * 100.0 assigned to this renderer's <code>data</code> property. A vertical
   * stroke separates the two halves.
   *
   * @author Jon Buffington
   */
  public class HPercentRenderer extends NumberRendererBase {

    // Invoke the class constructor to initialize the CSS defaults.
    classConstructor();

    private static function classConstructor():void {
      CSSUtil.setDefaultsFor("HPercentRenderer",
        { color: 0x000000
        , percentColor: 0x8DB3DF
        , remainderColor: 0xCCCCCC
        , indicatorWidth: 2
        , indicatorHeight: 8
        , paddingLeft: 0
        , paddingRight: 0
        , paddingTop: 0
        , paddingBottom: 0
        }
      );
    }


    /**
     * @private
     */
    override protected function measure():void {
      super.measure();

      // Add in the padding.
      measuredMinWidth = measuredWidth = getStyle("paddingLeft")
                      + getStyle("paddingRight")
                      + getStyle("indicatorWidth");
      measuredMinHeight = measuredHeight = getStyle("paddingTop")
                      + getStyle("paddingBottom")
                      + getStyle("indicatorHeight");
      }


    /**
     * @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
      super.updateDisplayList(unscaledWidth, unscaledHeight);

      // adjust for padding/inset
      const paddingLeft:Number = getStyle("paddingLeft");
          const paddingTop:Number = getStyle("paddingTop");
          const paddingRight:Number = getStyle("paddingRight");
          const paddingBottom:Number = getStyle("paddingBottom");

      const x:Number = paddingLeft;
      const y:Number = paddingTop;
      const insetX:Number = paddingLeft + paddingRight;
      const insetY:Number = paddingTop + paddingBottom;
      const width:Number = unscaledWidth - insetX;
      const height:Number = unscaledHeight - insetY;

      // no reason to draw what does not exist
      if ((width > 0) && (height > 0) && (!isNaN(numberValue))) {
        const color:Number = getStyle("color");
         const g:Graphics = this.graphics;

        const indicatorWidth:Number = getStyle("indicatorWidth");
        const indicatorHeight:Number = getStyle("indicatorHeight");

        // Calculate xpos as a percentage of width
        const halfIndicatorWidth:Number = indicatorWidth / 2;
        const xrel:Number = (numberValue * width / 100.0) - halfIndicatorWidth;
        const xpos:Number = x + Math.max(xrel, indicatorWidth);
        const ypos:Number = y + (Math.max(height - indicatorHeight, 0) / 2);
        const ymid:Number = height / 2;
         g.clear();

        // draw the left horizontal indicator
        const percentColor:Number = getStyle("percentColor");
        g.lineStyle(2, percentColor);
        g.moveTo(x, ymid);
        g.lineTo(xpos, ymid);

        // draw the right horizontal indicator
        const remainderColor:Number = getStyle("remainderColor");
        g.lineStyle(2, remainderColor);
        g.moveTo(xpos, ymid);
        g.lineTo(x + width, ymid);

        // draw the vertical bar
        g.lineStyle(indicatorWidth, color);
        g.moveTo(xpos, ypos);
        g.lineTo(xpos, ypos + indicatorHeight);
      }
    }

  }
}
