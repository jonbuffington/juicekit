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

  import mx.utils.StringUtil;

  /**
   * The StringUtil class provides String utility functions.
   *
   * @author Jon Buffington
   */
  public final class StringUtil {


    public static function ltrim(s:String):String {
      for (var i:int = 0; mx.utils.StringUtil.isWhitespace(s[i]); ++i) {
      }
      return s.substring(i);
    }


    public static function rtrim(s:String):String {
      for (var i:int = s.length - 1; mx.utils.StringUtil.isWhitespace(s[i]); --i) {
      }
      return s.substring(0, i + 1);
    }


    public static function substitute(str:String, existing:String, replacement:String):String {
      // FIXME: needs to escape any replacement matches
      var i:int = str.indexOf(existing);
      if (i === -1) {
        return str;
      }
      var retVal:String = new String();
      var k:int = 0;
      const skipLen:uint = existing.length;
      while (i !== -1) {
        retVal += str.substring(k, i) + replacement;
        k = i + skipLen;
        i = str.indexOf(existing, k);
      }
      if (k < str.length) {		// ignore trailing whitespace (e.g., newline)
        retVal += str.substring(k);
      }
      return retVal;
    }


    public static function truncate(s:String, maxLen:int, lastChar:String = "…"):String {
      if (s.length < maxLen) {
        return s;
      }
      else {
        return s.substring(0, maxLen - 1) + lastChar;
      }
    }


    public static function truncateTo(s:String, val:String, lastChar:String = "…"):String {
      var i:int = s.indexOf(val);
      if (i === -1) {
        return s;
      }
      else {
        return s.substring(0, i) + lastChar;
      }
    }


    public static function makeStringFieldSorter(fieldName:String,
                    caseSensitive:Boolean = true):Function {
      return function (obj1:Object, obj2:Object):int {
        var retVal:int = 0;	// equivalent
        var s1:String = obj1[fieldName].toString();
        var s2:String = obj2[fieldName].toString();
        if (!caseSensitive) {
          s1 = s1.toLowerCase();
          s2 = s2.toLowerCase();
        }
        if (s1 > s2) {
          retVal = 1;
        }
        else if (s1 < s2) {
          retVal = -1;
        }
        return retVal;
      }
    }


    public static const CRLF:String = "\r\n";
    public static const LF:String = "\n";

    public static function parseMultilineCSV(s:String
                        , lineSeparator:String = CRLF
                        , hasHeaderAsFirstLine:Boolean = false
                        ):Array {
      // Break the file contents into lines.
      // Note: The RFC4180 says line endings should be CRLF (0x0D0A)
      var retVal:Array = s.split(lineSeparator);

      // Build prototype object map from header?
      var objectMap:Array;
      if (hasHeaderAsFirstLine) {
        objectMap = parseSinglelineCSV(retVal[0]) as Array;
      }
      else {
        objectMap = null;
      }

      // Leave the header row as an array.
      const startIdx:int = objectMap ? 1 : 0;
      if (objectMap) {
        retVal[0] = objectMap;
      }

      // Mutate the string lines into parsed arrays.
      const len:int = retVal.length;
      for (var i:int = startIdx; i < len; i++) {
        retVal[i] = parseSinglelineCSV(retVal[i], objectMap);
      }

      return retVal;
    }

    public static function parseSinglelineCSV(s:String
                          , objectMap:Array = null
                          ):Object {
      // Are we return an object or array?
      var retVal:Object;
      if (objectMap) {
        retVal = new Object;
      }
      else {
        retVal = new Array;
      }

      var currPropIx:int = 0;
      function captureValue(v:String):void {
        // Capture the value as an object property or array element.
        if (objectMap) {
          retVal[objectMap[currPropIx]] = v;
          currPropIx++;
        }
        else {
          retVal.push(v);
        }
      }

      const DQUOTE:String = '"';
      const COMMA:String = ',';

      var accum:String = "";
      var isFieldOpen:Boolean = false;

      var chr:String;

      const len:int = s.length;
      for (var i:int = 0; i < len; i++) {
        chr = s.charAt(i);
        switch (chr) {
          // Handle escaped fields.
          case DQUOTE:
          isFieldOpen = !isFieldOpen;
          break;

          case COMMA:
          if (isFieldOpen) {
            accum += chr;
          }
          else {
            // Capture the field and reset the accumulator.
            captureValue(accum);
            accum = "";
          }
          break;

          default:
          accum += chr;
        }
      }
      // Capture the final accumulation.
      captureValue(accum);

      return retVal;
    }

  }
}
