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


package org.juicekit.util.collection {
  import mx.collections.Sort;
  import mx.collections.SortField;


  /**
   * The AlphanumSort class implements the natural sorting algorithm outlined
   * at <a href="http://www.davekoelle.com/alphanum.html">
   * http://www.davekoelle.com/alphanum.html</a>.
   *
   * <p>"The Alphanum Algorithm sorts strings containing a mix of letters and
   * numbers. Given strings of mixed characters and numbers, it sorts the
   * numbers in value order, while sorting the non-numbers in ASCII order.
   * The end result is a natural sorting order."</p>
   *
   * @author Jon Buffington
   *
   */
  public final class AlphanumSort extends Sort {

    /**
     * Constructor.
     *
     * <p>Creates a new AlphanumSort with no fields set but
     * the a custom comparator set.</p>
     */
    public function AlphanumSort() {
      super();

      compareFunction = alphanumCmp;
    }


    private static const ZERO_ASCII:Number = "0".charCodeAt(0);	// Decimal 48
    private static const NINE_ASCII:Number = "9".charCodeAt(0);	// Decimal 57

    /**
     * @private
     *
     * Returns true if the charCode maps to the ASCII numeral character codes.
     */
    private static function isDigit(chCode:Number):Boolean {
      return chCode >= ZERO_ASCII && chCode <= NINE_ASCII;
      }

    /**
     * @private
     *
     * Transform a string into it numeric and alphabetic parts.
     */
    private static function splitIntoAlphaOrNum(s:String):Array {
      var retVal:Array = new Array;

      const len:int = s.length;
      if (len > 0) {
        var accum:String = new String;
        var wasNum:Boolean = isDigit(s.charCodeAt(0));
        accum += s.charAt(0);
        for (var ix:int	= 1; ix < len; ix++) {
          if (isDigit(s.charCodeAt(ix))) {
            if (wasNum) {
              // Continues to be numeric.
              accum += s.charAt(ix);
            }
            else {
              // Changed to numeric.
              wasNum = true;

              // Capture existing alphabetic.
              retVal.push(accum);

              // Start capturing numeric.
              accum = s.charAt(ix);
            }
          }
          else if (wasNum) {
            // Changed to alphabetic.
            wasNum = false;

            // Capture existing numeric.
            retVal.push(Number(accum));

            // Start capturing alphabetic.
            accum = s.charAt(ix);
          }
          else {
            // Continues to be alphabetic.
            accum += s.charAt(ix);
          }
        }

        // Capture remaining.
        if (wasNum) {
          retVal.push(Number(accum));
        }
        else {
          retVal.push(accum);
        }
      }

      return retVal;
    }


    // Use constants to document the obscure integral comparison return values.
    private static const BOTH_ARE_EQUIV:int = 0;
    private static const LEFT_IS_LESS_THAN_RIGHT:int = -1;
    private static const LEFT_IS_GREATER_THAN_RIGHT:int = 1;


    /**
     * Public function intended to be used directly by sortable types such
     * as <code>ICollectionView</code> or types that accept custom comparison
     * functions (e.g., <code>DataGridColumn</code>).
     *
     * @see mx.collections.ICollectionView
     * @see mx.controls.dataGridClasses.DataGridColumn
     */
    public static function alphanumCompare(left:Object, right:Object):int {
      var retVal:int = BOTH_ARE_EQUIV;

      const ls:Array = splitIntoAlphaOrNum(left.toString());
      const rs:Array = splitIntoAlphaOrNum(right.toString());

      const partsN:int = ls.length;
      var ix:int = 0;
      var lPart:*, rPart:*;

      while ((retVal === BOTH_ARE_EQUIV) && (ix < partsN)) {
        lPart = ls[ix];
        rPart = rs[ix];

        if ((lPart is Number && rPart is Number)
        ||  (lPart is String && rPart is String)) {
          // Handle the case were the left and right are both
          // the same type and are therefore comparable using
          // the built-in operators.
          if (lPart > rPart) {
            retVal = LEFT_IS_GREATER_THAN_RIGHT;
          }
          else if (lPart < rPart) {
            retVal = LEFT_IS_LESS_THAN_RIGHT;
          }
          else {
            retVal = BOTH_ARE_EQUIV;
          }
        }
        else if (!rPart) {
          retVal = LEFT_IS_GREATER_THAN_RIGHT;
        }
        else {
          // Handle the case were the left and right are
          // different types. Use the built-in String comparison.
          var lStr:String = lPart.toString();
          var rStr:String = rPart.toString();

          if (lStr > rStr) {
            retVal = LEFT_IS_GREATER_THAN_RIGHT;
          }
          else if (lStr < rStr) {
            retVal = LEFT_IS_LESS_THAN_RIGHT;
          }
          else {
            // Make an arbitrary decision that the left is
            // greater than the right since they cannot be equal
            // if they are different types.
            retVal = LEFT_IS_GREATER_THAN_RIGHT;
          }
        }

        ix++;
      }
      return retVal;
    }


    /**
     * @private
     *
     * Internal compareFunction used by instances that supports multiple
     * column sorts with the optional fields parameter.
     */
    private static function alphanumCmp(a:Object, b:Object, fields:Array = null):int {
      var retVal:int = BOTH_ARE_EQUIV;

      if (fields && fields.length > 0) {
        var ix:int = 0;
        const fieldsN:int = fields.length;
        var sortField:SortField;
        var propName:String;

        while ((retVal === BOTH_ARE_EQUIV) && (ix < fieldsN)) {
          // Sometimes the fields are SortField instances.
          sortField = fields[ix] as SortField;
          propName = sortField ? sortField.name : fields[ix];
          retVal = alphanumCompare(a[propName], b[propName]);
          ix++;
        }
      }
      else {
        retVal = alphanumCompare(a, b);
      }
      return retVal;
    }

  }
}
