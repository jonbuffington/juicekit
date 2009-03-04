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
  import flare.animate.Transitioner;
  import flare.display.TextSprite;
  import flare.util.Property;
  import flare.vis.data.Data;
  import flare.vis.data.DataSprite;
  import flare.vis.data.NodeSprite;
  import flare.vis.operator.Operator;

  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.filters.BitmapFilterQuality;
  import flash.filters.GlowFilter;
  import flash.text.AntiAliasType;
  import flash.text.TextField;
  import flash.text.TextLineMetrics;

  import org.juicekit.util.helper.CSSUtil;


  /**
   * A LabelLayout places text labels using a DataSprite data property for
   * the text value and DataSprite x and y coordinates to position
   * the text rendering. The rendered text labels are positioned within
   * the DataSprite's coordinates.
   */
  public class Labels extends Operator {

    private static const LABEL_PROP_NAME:String = "#label#";


    /**
     * Store the source property.
     */
    private var _source:Property;

    /**
     * Specifies the property field name to use for sourcing
     * a label's string value.
     */
    public function set source(propertyName:String):void {
      _source = Property.$(propertyName);
    }

    /**
     * @private
     */
    public function get source():String {
      return _source.name;
    }


    /**
     * Store the group name string.
     */
    private var _group:String;

    /**
     * Specifies the data group name to label.
     */
    public function set group(name:String):void {
      _group = name;
    }

    /**
     * @private
     */
    public function get group():String {
      return _group;
    }


    /**
     * Store the labelFormatter property.
     */
    private var _labelFormatter:ILabelFormatter;

    /**
     * Specifies the text formatting object.
     *
     * @param lf Supports the <code>ILabelFormatter</code> interface.
     */
    public function set labelFormatter(lfr:ILabelFormatter):void {
      _labelFormatter = lfr;
    }

    /**
     * @private
     */
    public function get labelFormatter():ILabelFormatter {
      return _labelFormatter;
    }


    /**
     * Store the truncateToFit property.
     */
    private var _truncateToFit:Boolean;

    /**
     * Specifies whether label strings should be truncated to fit within its
     * rectangle's width. If the text string does not fit in the labeled item's
     * width, the text is truncated and an ellipses is appended to the string.
     * If the labeled item's width is not large enough for some portion of the
     * string, an empty label is applied.
     *
     * @default false
     */
    public function set truncateToFit(flag:Boolean):void {
      _truncateToFit = flag;
    }

    /**
     * @private
     */
    public function get truncateToFit():Boolean {
      return _truncateToFit;
    }


    /**
     * Do not remove label sprites when its corresponding <code>DataSprite</code>
     * is removed from the <code>stage</code>. This property is useful to bypass
     * responding to removing and adding back a <code>DataSprite</code>
     * when changing the <code>Visualization</code>'s data root.
     */
    public var ignoreRemovals:Boolean = false;


    /**
     * Is root node for all label TextSprites.
     */
    private var labelLayer:Sprite = null;


    /**
     * Contructor.
     *
     * @param labelField DataSprite property used to source the label's text
     * string.
     *
     * @param labelFormatter An optional ILabelFormatter instance that controls
     * how each label is rendered.
     *
     * @param truncateToFit Specified whether label strings should be
     * truncated to fit within its rectangle's width.
     */
    public function Labels( source:String
                          , group:String = Data.NODES
                          , labelFormatter:ILabelFormatter = null
                          , truncateToFit:Boolean = false
                          ) {
      this.source = source;
      this.group = group;
      this.labelFormatter = labelFormatter;
      this.truncateToFit = truncateToFit;

      labelLayer = new Sprite();
      labelLayer.mouseEnabled = false;
      labelLayer.mouseChildren = false;
      labelLayer.name = "#labelLayer#";
    }


    /**
     * @inheritDoc
     */
    override public function setup():void {
      super.setup();

      if (!visualization.contains(labelLayer)) {
        visualization.addChild(labelLayer);
      }
    }


    /**
     * Disposes of the label <code>Sprite</code> layer from
     * the <code>Visualization</code>'s scene graph. This should only
     * be called after being removed from a
     * <code>Visualization</code>'s operator list.
     */
    public function dispose():void {
      if (labelLayer && visualization.contains(labelLayer)) {
        visualization.removeChild(labelLayer);
      }
      labelLayer = null;
    }


    /**
     * @inheritDoc
     */
    override public function operate(t:Transitioner=null):void {
      t = t ? t : Transitioner.DEFAULT;  // set transitioner

      visualization.data.group(_group).visit(function(ds:DataSprite):void {
        var needsLabel:Boolean = false;
        var label:TextSprite = null;
        var labelText:String = "";  // Default to an empty string.
        var fmt:LabelFormat = null;

        const isVisible:Boolean = ds.visible && ds.alpha > 0;
        const lf:Object = _source.getValue(ds);
        if (isVisible && lf) {
          if (_labelFormatter) {
            fmt = _labelFormatter.labelFormat(ds);
            if (fmt) {
              labelText = lf.toString();
              needsLabel = true;
            }
          }
          else {
            labelText = lf.toString();
            needsLabel = true;
          }

          if (needsLabel) {
//            const wrappedSprite:Object = t.$(dataSprite); // Note: Only one object
//                                                          // can be wrapped at a time.
            const spriteX:Number = t.getValue(ds, "x");
            const spriteU:Number = t.getValue(ds, "u");
            const spriteW:Number = t.getValue(ds, "w");
            const spriteY:Number = t.getValue(ds, "y");
            const spriteV:Number = t.getValue(ds, "v");
            const spriteH:Number = t.getValue(ds, "h");

            var labelX:Number, labelY:Number;

            // Accomodate layouts (e.g., TreeMapLayout) that use the u an v properties.
            if (!isNaN(spriteU) && !isNaN(spriteV)) {
              labelX = spriteU - spriteX;
              labelY = spriteV - spriteY;
            }
            else {
              labelX = spriteX;
              labelY = spriteY;
            }

            label = getLabelFor(ds);

            if (fmt) {
              label.textFormat = fmt;
              label.textMode = CSSUtil.isEmbeddedFont(fmt) ? TextSprite.EMBED : TextSprite.BITMAP;

              switch (fmt.horizontalAnchor) {
                case LabelFormat.LEFT:
                  label.horizontalAnchor = LabelFormat.LEFT;
                  break;
                case LabelFormat.CENTER:
                  label.horizontalAnchor = LabelFormat.CENTER;
                  labelX += (spriteW / 2);
                  break;
                case LabelFormat.RIGHT:
                  label.horizontalAnchor = LabelFormat.RIGHT;
                  labelX += spriteW;
                  break;
              }

              switch (fmt.verticalAnchor) {
                case LabelFormat.TOP:
                  label.verticalAnchor = LabelFormat.TOP;
                  break;
                case LabelFormat.MIDDLE:
                  label.verticalAnchor = LabelFormat.MIDDLE;
                  labelY += (spriteH / 2);
                  break;
                case LabelFormat.BOTTOM:
                  label.verticalAnchor = LabelFormat.BOTTOM;
                  labelY += spriteH;
                  break;
              }
            }
            else {
              // Default to top left layout in the absense of a LabelFormat.
              label.horizontalAnchor = LabelFormat.LEFT;
              label.verticalAnchor = LabelFormat.TOP;
            }

            if (truncateToFit) {
              fitText(label, labelText, spriteW);
            }
            else {
              label.text = labelText;
            }

            // Work-around for a transitioner only wrapping one
            // object (e.g., DataSprite) during a visit.
            t.setValue(label, "x", labelX);
            t.setValue(label, "y", labelY);
          }
          else {
            removeLabelFrom(ds);
          }
        }
        else {
          removeLabelFrom(ds);
        }
      });
    }


    /**
     * Sets the visibility for labels of the <code>root</code> and its
     * children.
     *
     * @param root Refers to the root <code>NodeSprite</code> of
     * a <code>Tree</code>.
     *
     * @param visible Sets the visibility of each <code>NodeSprite</code>
     * in a <code>Tree</code>.
     */
    public function setLabelVisible(root:NodeSprite, visible:Boolean):void {
      root.visitTreeDepthFirst(function(ns:NodeSprite):void {
        const label:TextSprite = getLabelFor(ns, false);
        if (label) {
          label.visible = visible;
        }
      });
    }


    /**
     * Handle removal of labeled DataSprites from the display list (scene graph).
     */
    private function dataSpriteRemoved(event:Event):void {
      const dataSprite:DataSprite = event.target as DataSprite;
      // You may want to ignore remove/adds during changes to the
      // visualization's data root.
      if (!ignoreRemovals) {
        removeLabelFrom(dataSprite);
      }
    }


    private static const labelFilter:GlowFilter = new GlowFilter(0xFFFFFF, 0.75, 2, 2, 8, BitmapFilterQuality.HIGH);

    private function makeLabel(container:DisplayObjectContainer):TextSprite {
      var label:TextSprite = new TextSprite();
      label.textField.selectable = false;
      label.mouseEnabled = false;
      label.textField.filters = [labelFilter];
      label.textField.antiAliasType = AntiAliasType.ADVANCED;

      container.addChild(label);

      return label;
    }


    private function getLabelFor(dataSprite:DataSprite, makeIfAbsent:Boolean = true):TextSprite {
      const container:DisplayObjectContainer = labelLayer;

      var label:TextSprite;

      if (dataSprite.props) {
        label = dataSprite.props[LABEL_PROP_NAME];
        if (!label && makeIfAbsent) {
          label = makeLabel(container);
          dataSprite.addEventListener(Event.REMOVED, dataSpriteRemoved, false, 0, true);
          dataSprite.props[LABEL_PROP_NAME] = label;
        }
      }
      else if (makeIfAbsent) {
        label = makeLabel(container);
        dataSprite.addEventListener(Event.REMOVED, dataSpriteRemoved, false, 0, true);
        dataSprite.props = new Object();
        dataSprite.props[LABEL_PROP_NAME] = label;
      }
      return label;
    }


    private function removeLabelFrom(dataSprite:DataSprite):void {
      const container:DisplayObjectContainer = labelLayer;

      var label:DisplayObject;
      if (dataSprite.props) {
        label = dataSprite.props[LABEL_PROP_NAME];
        if (label) {
          dataSprite.removeEventListener(Event.REMOVED, dataSpriteRemoved);
          container.removeChild(label);
          delete dataSprite.props[LABEL_PROP_NAME];
          label = null;
        }
      }
    }


    private function fitText(ts:TextSprite, s:String, maxW:Number):void {
      const tf:TextField = ts.textField;
      var len:int = s.length;
      ts.text = s;
      var tm:TextLineMetrics = tf.getLineMetrics(0);
      while (len > 0 && tm.width > maxW) {
        len = len - 2;  // Speed up the search.
        s = s.substr(0, len);
        ts.text = s + "…";
        tm = tf.getLineMetrics(0);
      }
      // Scrub a zero length string.
      if (len <= 0) {
        ts.text = "";
      }
    }
  }
}
