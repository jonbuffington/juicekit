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
  import mx.collections.ArrayCollection;
  import mx.controls.dataGridClasses.DataGridColumn;
  import mx.formatters.NumberBaseRoundType;
  import mx.formatters.NumberFormatter;


  /**
   * The Formatter class methods produce labeling functions for use as values
   * for a DataGridColumn labelFunction property.
   *
   * @author Jon Buffington
   */
  public final class Formatter {


    /**
     * Creates a number labeling function used by a DataGridColumn instance
     * as a value for the labelFunction property.
     *
     * @param precision Specifies the number of decimal places
     * to include in the output String.
     *
     * @param aux References a function with a method signature
     * of the following form:
     *
     * <pre>labelFunction(item:Object, column:DataGridColumn):String</pre>
     *
     * <p>Where <code>item</code> contains the DataGrid item (row) object,
     * and <code>column</code> specifies the DataGrid column.</p>
     */
    public static function numberLabeler(precision:int, aux:Function = null):Function {
      var nf:NumberFormatter = new NumberFormatter();
      nf.precision = precision;
      nf.rounding = NumberBaseRoundType.NEAREST;
      return function (item:Object, column:DataGridColumn):String {
        var s:String;
        if (aux === null) {
          s = nf.format(item[column.dataField]);
        }
        else {
          s = nf.format(aux(item, column));
        }
        // Pre-pend a leading zero to values less than 1.
        if (precision > 0 && s.charAt(0) === ".") {
          s = "0" + s;
        }
        return s;
      }
    }


    /**
     * Provided as an auxillary function to access an array-based named
     * property value as a String. Intended to be assigned to a
     * DataGridColumn's labelFunction property.
     */
    public static function arrayIndexProperty(item:Object, column:DataGridColumn):String {
      const cachedProp:* = item[column.dataField];
      if (cachedProp!== undefined) {
        return cachedProp.toString();
      }
      // Extract parts from "array.index.property".
      const parts:Array = column.dataField.split(".");
      const arrName:String = parts[0] as String;
      const indexI:uint = parseInt(parts[1] as String);
      const propName:String = parts[2] as String;
      // a safe "item[arrName][indexI][propName].toString()" follows...
      const ac:ArrayCollection = item[arrName];
      if (!ac) {
        return "";
      }
      const obj:Object = ac.getItemAt(indexI);
      if (!obj) {
        return "";
      }
      const prop:* = obj[propName];
      if (prop === undefined) {
        return "";
      }
      // Need to cache value so sorting works.
      item[column.dataField] = prop;
      return prop.toString();
    }


    // TODO: Test and improve the following before making public.
    /**
     * @private
     *
     * A DataGridColumn helper function creates functions to navigate
     * an object tree structure using dotted-name notation. The column
     * parameter's dataField property is parsed to extract an object
     * navigation pattern. This pattern is walked to return the leaf
     * data value as a string. The last member of the pattern must be an
     * Array type which is indexed using the index outer parameter.
     */
    private static function treeNavigator(index:uint):Function {
      return function (item:Object, column:DataGridColumn):String {
        // Note: This is should be foldl.
        const parts:Array = column.dataField.split(".");
        const nextToLast:uint = parts.length - 1;
        var p:* = item;
        for (var i:uint = 0; i < nextToLast; i++) {
          p = p[parts[i]];
          if (p === undefined) {
            break;
          }
        }
        return (!p is Array) ? p[index].toString() : "";
      }
    }
  }
}
