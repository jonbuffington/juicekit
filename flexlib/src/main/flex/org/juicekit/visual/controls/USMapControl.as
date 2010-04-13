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
  import flash.display.DisplayObjectContainer;
  import flash.display.MovieClip;
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.filters.BitmapFilterQuality;
  import flash.filters.GlowFilter;
  import flash.geom.Rectangle;
  import flash.text.AntiAliasType;
  import flash.text.TextField;
  import flash.text.TextFieldAutoSize;
  import flash.text.TextFormat;
  import flash.text.TextFormatAlign;

  import org.juicekit.util.helper.CSSUtil;
  import org.juicekit.visual.flash.controls.USMap;

  include "../styles/metadata/TextStyles.as";


  /**
   * The USMap class visualizes U.S. state-level data. Each states' graphical
   * treatment is manipulated using a function that maps data values to
   * color values.
   *
   * @author Jon Buffington
   */
  public class USMapControl extends MovieClipControlBase {


    // Invoke the class constructor to initialize the CSS defaults.
    classConstructor();

    private static function classConstructor():void {
      CSSUtil.setDefaultsFor("org.juicekit.visual.controls.USMapControl",
        { fontColor: 0
        , textAlign: TextFormatAlign.LEFT
        }
      );
    }


    /**
     * Constructor.
     */
    public function USMapControl() {
      super();

      // Set the stateAbbrField to "state" for
      // backwards compatibilty with prior library releases.
      stateAbbrField = "state";
    }


    /**
     * @private
     */
    override protected function createMovieClip():MovieClip {
      return new USMap();
    }


    /**
     * @private
     */
    override protected function createChildren():void {
      super.createChildren();
      makeLabels();
    }


    /**
     * Is property name used for text styling?
     */
    private function isTextStyle(styleProp:String):Boolean {
      const textStyleProps:Array = [ "fontColor"
                                   , "fontFamily"
                                   , "fontSize"
                                   , "fontStyle"
                                   , "fontWeight"
                                   , "textAlign"
                                   , "textPosition"
                                   ];
      return textStyleProps.indexOf(styleProp) !== -1;
    }


    /**
     * Store indicator that label styles have changed.
     */
    private var _labelStyleChanged:Boolean = false;


    /**
     * @private
     */
    override public function styleChanged(styleProp:String):void {
      super.styleChanged(styleProp);

      const allStyles:Boolean = !styleProp || styleProp == "styleName";
      if (allStyles || isTextStyle(styleProp)) {
        _labelStyleChanged = true;
      }

      invalidateProperties();
    }


    /**
     * @private
     */
    override protected function commitProperties():void {
      super.commitProperties();

      if (_clip && _labelLayer && _labelStyleChanged) {
        _labelStyleChanged = false;
        styleLabels();
      }
    }


    // Note: The following stateAbbrField property is included to support
    // backwards compatibilty with prior library releases.

    /**
     * Specifies the data <code>Object</code> property name containing
     * a U.S. state two-letter abbreviation.
     *
     * @default "state"
     */
    [Inspectable(category="General")]
    [Bindable]
    public function set stateAbbrField(propertyName:String):void {
      dataKeyField = propertyName;
    }

    /**
     * @private
     */
    public function get stateAbbrField():String {
      return dataKeyField;
    }


    /**
     * Is root node for all label TextSprites.
     */
    private var _labelLayer:Sprite = null;


   /**
     * @private
     *
     * Apply state abbreviation labels to the map.
     */
    private function makeLabels():void {
      var tf:TextField;
      var stateSB:SimpleButton;
      var bounds:Rectangle;

      const states:DisplayObjectContainer = clipDisplayObjectContainer();

      _labelLayer = new Sprite();
      _labelLayer.name = "labels";
      _labelLayer.mouseEnabled = false;
      _labelLayer.mouseChildren = false;
      _clip.addChild(_labelLayer);

      const numStates:int = states.numChildren;
      for (var i:int = 0; i < numStates; i++) {
        stateSB = states.getChildAt(i) as SimpleButton;
        bounds = stateSB.getBounds(_labelLayer);

        tf = new TextField();
        tf.autoSize = TextFieldAutoSize.LEFT;
        tf.antiAliasType = AntiAliasType.ADVANCED;

        tf.name = stateSB.name;
        tf.text = stateSB.name;

        _labelLayer.addChild(tf);

        tf.x = bounds.x + (bounds.width / 2 - tf.textWidth / 2);
        tf.y = bounds.y + (bounds.height / 2 - tf.textHeight / 2);
      }
    }


    private static const labelFilter:GlowFilter = new GlowFilter(0xFFFFFF, 0.5, 2, 2, 8, BitmapFilterQuality.HIGH);

   /**
     * @private
     *
     * Apply styles to the state abbreviation labels.
     */
    private function styleLabels():void {
      const format:TextFormat = new TextFormat( getStyle("fontFamily")
                                              , getStyle("fontSize")
                                              , getStyle("fontColor")
                                              , getStyle("fontWeight") == "bold"
                                              , getStyle("fontStyle") == "italic"
                                              , null
                                              , null
                                              , null
                                              , getStyle("textAlign")
                                              );
      var tf:TextField;
      const numLabels:int = _labelLayer.numChildren;
      for (var i:int = 0; i < numLabels; i++) {
        tf = _labelLayer.getChildAt(i) as TextField;
        tf.setTextFormat(format);
        tf.embedFonts = CSSUtil.isEmbeddedFont(format);
        if (tf.filters.length === 0) {
          tf.filters = [labelFilter];
        }
      }
    }


    /**
     * Return the MovieClip's <code>DisplayObjectContainer</code> containing
     * the <code>SimpleButton</code>s to encode.
     */
    override protected function clipDisplayObjectContainer():DisplayObjectContainer {
      return (_clip as USMap).stateLayout;
    }

  }
}
