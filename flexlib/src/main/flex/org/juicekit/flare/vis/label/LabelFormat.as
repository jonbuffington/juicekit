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


package org.juicekit.flare.vis.label {
  import flare.display.TextSprite;

  import flash.text.TextFormat;


  /**
   * The LabelFormat class describes the style attributes to be applied to
   * text labels of a LabelLayout instance.
   *
   * @author Jon Buffington
   */
  public class LabelFormat extends TextFormat {

    // horizontal anchors
    /**
     * Constant for horizontally aligning the left of the text field
     * to a TextSprite's x-coordinate.
     */
    public static const LEFT:int = TextSprite.LEFT;
    /**
     * Constant for horizontally aligning the center of the text field
     * to a TextSprite's x-coordinate.
     */
    public static const CENTER:int = TextSprite.CENTER;
    /**
     * Constant for horizontally aligning the right of the text field
     * to a TextSprite's x-coordinate.
     */
    public static const RIGHT:int = TextSprite.RIGHT;

   // vertical anchors
    /**
     * Constant for vertically aligning the top of the text field
     * to a TextSprite's y-coordinate.
     */
    public static const TOP:int = TextSprite.TOP;
    /**
     * Constant for vertically aligning the middle of the text field
     * to a TextSprite's y-coordinate.
     */
    public static const MIDDLE:int = TextSprite.MIDDLE;
    /**
     * Constant for vertically aligning the bottom of the text field
     * to a TextSprite's y-coordinate.
     */
    public static const BOTTOM:int = TextSprite.BOTTOM;


    /**
     * Determines how the text is horizontally aligned with
     * respect to a TextSprite's (x,y) location.
     */
    public var horizontalAnchor:uint = LEFT;


    /**
     * Determines how the text is vertically aligned with
     * respect to a TextSprite's (x,y) location.
     */
    public var verticalAnchor:uint = TOP;


    /**
     * Constructor.
     */
    public function LabelFormat(font:String = "Verdana"
                               , size:uint = 10
                               , color:uint = 0
                               , bold:Boolean = false
                               , italic:Boolean = false) {
      super(font, size, color, bold, italic, false, null, null
           , null, null, null, null, null);
    }
  }
}
