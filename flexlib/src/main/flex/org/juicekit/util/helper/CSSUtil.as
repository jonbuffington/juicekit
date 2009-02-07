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
     * Sets the style property defaults for a custom class.
     *
     * @param className Is a string name of custom class for attaching
     *  the following default style properties.
     *
     * @param defaults Is a simple dictionary object with keys (properties)
     *	matching desired style property names and values holding the
     *	style properties' respective initial values. <p>Example object literal:
     *	<code>{ strokeColor: 0xCCCCCC, fillColor: 0xCCCCCC }</code></p>
     *
     * @return Returns the default CSSStyleDeclaration associated with
     *	the custom className.
     */
    public static function setDefaultsFor(className:String, defaults:Object):CSSStyleDeclaration {
      var updated:Boolean = false;
      var p:*;
      var prop:String;
      var styleDecl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(className);
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
          if (p === undefined) {
            styleDecl.setStyle(prop, defaults[prop]);
            updated = true;
          }
        }
      }
      if (updated) {
        StyleManager.setStyleDeclaration(className, styleDecl, true);
      }
      return styleDecl;
    }

  }
}
