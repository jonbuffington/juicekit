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


package org.juicekit.util.helper {
  import flash.text.Font;
  import flash.text.FontStyle;
  import flash.text.TextFormat;

  import mx.styles.CSSStyleDeclaration;
  import mx.styles.StyleManager;


  /**
   * The CSSUtil class provides a set of static helper functions for
   * manipulating CSS styles.
   *
   * @author Jon Buffington
   */
  public final class CSSUtil {


    /**
     * Sets the style property defaults for a style selector. If the properties
     * already exist, the default specified for that property is ignored.
     *
     * @param selector Is a string name of the selector for attaching
     *  the following default style properties.
     *
     * @param defaults Is a simple dictionary object with keys (properties)
     *	matching desired style property names and values holding the
     *	style properties' respective initial values. <p>Example object literal:
     *	<code>{ strokeColor: 0xCCCCCC, fillColor: 0xCCCCCC }</code></p>
     *
     * @return Returns the <code>CSSStyleDeclaration</code> associated with
     *	the style selector.
     */
    public static function setDefaultsFor(selector:String, defaults:Object):CSSStyleDeclaration {
      var updated:Boolean = false;
      var p:*;
      var prop:String;
      var styleDecl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(selector);
      if (!styleDecl) {
        // If there is no CSS definition then create one
        // and set the default properties and values.
        styleDecl = new CSSStyleDeclaration();
        for (prop in defaults) {
          styleDecl.setStyle(prop, defaults[prop]);
        }
        updated = true;
      }
      else {
        // Confirm a value exists for each property or create one.
        for (prop in defaults) {
          p = styleDecl.getStyle(prop);
          // Do not replace existing property assignments.
          if (p === undefined) {
            styleDecl.setStyle(prop, defaults[prop]);
            updated = true;
          }
        }
      }
      if (updated) {
        StyleManager.setStyleDeclaration(selector, styleDecl, true);
      }
      return styleDecl;
    }


    /**
     * Sets the style properties for a specific style selector.
     *
     * @param selector Is the string name of a style selector.
     *
     * @param values Is a simple dictionary object with keys (properties)
     *  matching desired style property names and values holding the
     *  style properties' respective values. <p>Example object literal:
     *  <code>{ strokeColor: 0xCCCCCC, fillColor: 0xCCCCCC }</code></p>
     *
     * @return Returns the <code>CSSStyleDeclaration</code> associated with
     *  the style selector.
     */
    public static function setStyleFor(selector:String, values:Object):CSSStyleDeclaration {
      var prop:String;
      var styleDecl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(selector);
      if (!styleDecl) {
        // If there is no CSS definition then create one
        // and set the properties and values.
        styleDecl = new CSSStyleDeclaration();
        for (prop in values) {
          styleDecl.setStyle(prop, values[prop]);
        }
      }
      else {
        // Confirm a value exists for each property or create one.
        for (prop in values) {
          styleDecl.setStyle(prop, values[prop]);
        }
      }
      // Write changes to the style manager.
      StyleManager.setStyleDeclaration(selector, styleDecl, true);
      return styleDecl;
    }


    /**
     * Returns true when the font glyph outlines for a given
     * <code>TextFormat</code> are embedded in the SWF.
     *
     * @param tf Is the <code>TextFormat</code> to check.
     *
     * @return Returns true if an embedded font exists.
     */
    public static function isEmbeddedFont(tf:TextFormat):Boolean {
      const fontName:String = tf.font;

      const embeddedFonts:Array = Font.enumerateFonts();
      const embeddedFontsLen:uint = embeddedFonts.length;
      for (var ix:int = 0; ix < embeddedFontsLen; ++ix) {
        var font:Font = Font(embeddedFonts[ix]);

        if (font.fontName === fontName) {
          var found:Boolean = false;
          switch (font.fontStyle) {
            case FontStyle.BOLD_ITALIC:
              found = tf.bold && tf.italic;
              break;
            case FontStyle.BOLD:
              found = tf.bold && !tf.italic;
              break;
            case FontStyle.ITALIC:
              found = !tf.bold && tf.italic;
              break;
            case FontStyle.REGULAR:
              found = !tf.bold && !tf.italic;
              break;
          }
          if (found) {
            return true;
          }
        }
      }
      return false;
    }

  }
}
