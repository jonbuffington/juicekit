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
  import flash.external.ExternalInterface;


  /**
   * The Browser class provides a set of functions that provide a bridge
   * between the Flash Player hosted application and the containing browser.
   *
   * @author Jon Buffington
   */
  public final class Browser {


    /**
     * Constructor.
     */
    public function Browser() {
      super();
    }


    /**
     * Copies the value of a named HTTP cookie to the result string.
     *
     * @param name Is the name of the HTTP cookie to be copied.
     * @return Returns a string containing a copy of the named HTTP cookie or an
     *	empty string if the HTTP cookie does not exist.
     */
    public static function getCookieValueByName(name:String):String {
      if (!ExternalInterface.available) {
        trace("getCookieValueByName: ExternalInterface is not available.");
        return "";
      }

      var cookie:String = ExternalInterface.call("(function(){return document.cookie;})", "") as String;
      if (cookie.length === 0) {
        // cookies not in header
        trace("getCookieValueByName: The document.cookie property is empty.");
        return "";
      }
      // cookies are separated by semicolons
      var pairs:Array = cookie.split(";");
      const len:uint = pairs.length;
      for (var i:uint=0; i < len; i++) {
        // each name/value pair is separated by an equal sign
        var pair:Array = pairs[i].split("=");
        if (name === pair[0]) {
          return unescape(pair[1]);
        }
      }
      // 'name' was not found
      trace("getCookieValueByName: '" + name + "' was not found in the cookie.document property.");
      return "";
    }

  }
}
