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

  import flash.display.Graphics;

  //--------------------------------------
  //  Styles
  //--------------------------------------

  /**
   *  Determines the normal condition fill color.
   *
   *  @default 0x000000
   */
  [Style(name="color", type="uint", format="Color", inherit="yes")]

  include "../styles/metadata/PaddingStyles.as";


  /**
   * The IndexCircleRenderer class draws an indexing circle and label based upon
   * the numeric value assigned to this renderer's <code>data</code> property.
   *
   * @author Chris Gemignani
   */
  public class IndexCircleRenderer extends NumberRendererBase {


    private const radius:Number = 3;


    /**
     * Constructor.
     */
    public function IndexCircleRenderer() {
      super();
    }


    /**
     * @private
     */
    override protected function measure():void {
      super.measure();

      // Add in the padding.
      const circleLen:Number = radius + radius;
      measuredMinWidth = measuredWidth = getStyle("paddingLeft") + getStyle("paddingRight") + circleLen;
      measuredMinHeight = measuredHeight = getStyle("paddingTop") + getStyle("paddingBottom") + circleLen;
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

      const left:Number = paddingLeft;
      const top:Number = paddingTop;
      const insetX:Number = paddingLeft + paddingRight;
      const insetY:Number = paddingTop + paddingBottom;
      const width:Number = unscaledWidth - insetX;
      const height:Number = unscaledHeight - insetY;

      // no reason to draw what does not exist
      if ((width > 0) && (height > 0)) {
        const color:Number = getStyle("color");

        // obtain the graphics context
         const g:Graphics = this.graphics;

        // always draw the dividing line
         g.clear();
         g.beginFill(color, this.alpha);
        g.lineStyle(0.1, color);
        const halfHeight:Number = height / 2 + top;
        const halfWidth:Number = width / 2 + left;
        g.moveTo(halfWidth, top);
        g.lineTo(halfWidth, height);
        g.endFill();

        // only render data if available
        if ((data !== null) && (!isNaN(numberValue))) {
          const xposUnbounded:Number = left + Math.min(numberValue, 200.0)*(width / 200.0);
          const xpos:Number = Math.max(xposUnbounded, radius + 1);
          if (xpos < width) {
            g.beginFill(color, this.alpha);
            const ypos:Number = halfHeight;
            g.lineStyle(0.0, color);
            g.drawCircle(xpos, ypos, radius);
          } else {
            const ORANGE:uint = 0xf5b410;
            g.lineStyle(1, ORANGE);
            g.beginFill(ORANGE, this.alpha);
            // draw triangle indicator
            const triangleSize:Number = 8;
            const halfTSize:Number = triangleSize / 2;
            const tleft:Number = width - triangleSize;
            const ttop:Number = halfHeight - halfTSize;
            const tbottom:Number = halfHeight + halfTSize;
             g.moveTo(tleft, ttop);
            g.lineTo(width, halfHeight);
            g.lineTo(tleft, tbottom);
            g.lineTo(tleft, ttop);
          }
          g.endFill();
        }
      }
    }

  }
}
