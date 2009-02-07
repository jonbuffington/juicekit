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
  import flash.display.IBitmapDrawable;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.external.ExternalInterface;
  import flash.net.URLLoader;
  import flash.net.URLLoaderDataFormat;
  import flash.net.URLRequest;
  import flash.net.URLRequestMethod;
  import flash.net.URLVariables;
  import flash.system.System;

  import mx.collections.ArrayCollection;
  import mx.controls.DataGrid;
  import mx.graphics.ImageSnapshot;


  /**
   * The Clipboard class produces string representations of value objects.
   * The string representations are formatted using Tab-Separated Values
   * (TSV) where the <code>TAB</code> character is used for the delimiter.
   *
   * @author Jon Buffington
   */
  public final class Clipboard {

    public static const FIELD_SEPARATOR:String = "\t";
    public static const RECORD_SEPARATOR:String = "\n";


    /**
     * Formats the contents of an Array of objects as a Tab-Separated Values
     * (TSV) string that is copied to the system clipboard.
     *
     * @param objects Is the target array of data objects to be copied.
     *
     * @param propNames List of the object properties names to be copied.
     * The propNames order determines the order of columns in the tab-delimited
     * clipboard contents.
     */
    public static function putArrayOfObjects(objects:Array
                        , propNames:Array
                        ):void {
      // For readibility in the loops, rename the objects to rows.
      const rows:Array = objects;

      // No reason to process an empty data set.
      const rowsN:int = rows.length;
      if (rowsN === 0) {
        return;
      }

      // Set-up a container to hold the intermediate string.
      var s:String = new String();

      // Create an internal function to capture the property iteration
      // structure where the actual getter function is substituted at
      // runtime.
      const propsN:int = propNames.length;
      function appendUsing(valueFunc:Function):void {
        for (var propIx:int = 0; propIx < propsN; propIx++) {
          s += valueFunc(propIx);
          if ((propsN - propIx) > 1) {
            s += FIELD_SEPARATOR;
          }
        }
      }

      // Prepend headers to the clipboard.
      appendUsing(function (ix:int):String {
        return propNames[ix];
      });

      s += RECORD_SEPARATOR;

      // Iterate through the rows.
      var row:Object;
      for (var rowIx:int = 0; rowIx < rowsN; rowIx++) {
        row = rows[rowIx];

        appendUsing(function (ix:int):String {
          const propVal:* = row[propNames[ix]];
          if (propVal) {
            return propVal.toString();
          }
          else {
            return "";
          }
        });

        if ((rowsN - rowIx) > 1) {
          s += RECORD_SEPARATOR;
        }
      }

      System.setClipboard(s);
    }


    /**
     * Put the contents of an Array of arrays, tabularArray, onto
     * the system clipboard formatted as a tab-delimited string.
     *
     * @param tabularArray Is the target Array of data objects to be copied.
     */
    public static function putTabularArray(tabularArray:Array):void {
      const rows:Array = tabularArray;
      const rowsN:int = rows.length;
      if (rowsN === 0) {
        return;
      }

      // Format data for the clipboard
      var s:String = new String();
      var cols:Array;
      var colsN:int;

      for (var rowIx:int = 0; rowIx < rowsN; rowIx++) {
        cols = rows[rowIx];
        colsN = cols.length;
        for (var colIx:int = 0; colIx < colsN; colIx++) {
          s += cols[colIx];
          if ((colsN - colIx) > 1) {
            s += FIELD_SEPARATOR;
          }
        }
        if ((rowsN - rowIx) > 1) {
          s += RECORD_SEPARATOR;
        }
      }

      System.setClipboard(s);
    }


    /**
     * Put a DataGrid's dataProvider Array of arrays onto
     * the system clipboard formatted as a tab-delimited string.
     * The DataGrid's columns' headerText properties define the TSV column
     * titles and the TSV rows are provided by the DataGrid's columns'
     * dataField properties.
     *
     * @param dataGrid Is the target DataGrid with a dataProvider to be copied.
     */
    public static function makeTabularArrayFromDataGrid(dataGrid:DataGrid):Array {
      return getTabularArrayFromSrc(dataGrid, "columns", "headerText", "dataField");
    }


    /**
     * Lower-level data export auxillary function that maps a source's
     * dataProvider into a tabular data (Array of Arrays) structure.
     *
     * @param src Provides data through its <code>dataProvider</code> property.
     *
     * @param itemsPropName Defines the column meta-data (e.g., columns).
     *
     * @param titlePropName Defines the column header name property (e.g., headerText).
     *
     * @param fieldPropName Defines the column data property (e.g., dataField).
     */
    public static function getTabularArrayFromSrc(src:Object
                       , itemsPropName:String
                       , titlePropName:String
                       , fieldPropName:String
                       ):Array {

      var retVal:Array = new Array();

      var rowIx:uint, colIx:uint;	// Looping indexes.

      // Insert titles using the DataGrid columns.
      const items:Array = src[itemsPropName] as Array;
      const itemsN:uint = items.length;
      var titles:Array = new Array();
      for (rowIx = 0; rowIx < itemsN; rowIx++) {
        titles.push(items[rowIx][titlePropName] as String);
      }
      retVal.push(titles);

      // Insert the data values.
      const rows:ArrayCollection = src.dataProvider as ArrayCollection;
      const rowsN:uint = rows.length;
      var val:Object;
      for (rowIx = 0; rowIx < rowsN; rowIx++) {
        var tableRow:Array = new Array();
        var row:Object = rows[rowIx];
        for (colIx = 0; colIx < itemsN; colIx++) { // Cols
          // Get the column's name for the object property.
          var propName:String = items[colIx][fieldPropName] as String;
          if (row.hasOwnProperty(propName)) {
            val = row[propName];
            if (val is Number) {
              tableRow.push(Number(val).toFixed(2));
            }
            else if (val is String) {
              tableRow.push(val);
            }
            else {
              tableRow.push("");
            }
          }
          else {
            tableRow.push("");
          }
        }
        retVal.push(tableRow);
      }

      return retVal;
    }


    /**
     * Copy an image to the clipboard in browsers that have the
     * <code>document.body.createControlRange</code> function. Currently, this
     * function is only supported in Microsoft's Internet Explorer 6 and 7.
     *
     * @param imgBase64Data Contains the image data encoded as base64 data.
     *
     * @param pasteboardSvcURL Is the URL of the JuiceKit PNG pasteboard service
     *        relative to the deployed SWF.
     */
    private static function copyImageToClipboard(imgBase64Data:String, pasteboardSvcURL:String):void {
      const urlReq:URLRequest = new URLRequest(pasteboardSvcURL);

      // Set-up an HTTP POST request containing a www-form-urlencoded
      //   base 64 image data accessed using the "base64image" key.
      const urlVars:URLVariables = new URLVariables();
      urlVars.base64image = imgBase64Data;
      urlReq.method = URLRequestMethod.POST;
      urlReq.data = urlVars;

      /*
       * Sets the non-visible img tag's src to the server cached image.
       */
      function onCopyImageToClipboard(event:Event):void {
        const urlLoader:URLLoader = URLLoader(event.target);
        const imgUrl:String = pasteboardSvcURL + "/" + urlLoader.data.toString();

        trace("onCopyImageToClipboard: " + imgUrl);

        const copyImageToClipboardJS:String =
          "( function (url) { " +
          "function addEvent(tgt, etype, f) { " +
          " if (tgt.addEventListener) { " +
          "  tgt.addEventListener(etype, f, false); " +
          " } else { " +
          "  tgt.attachEvent('on' + etype, f); } }" +
          "var imgEl = document.getElementById('pasteBoardImage'); " +
          "if (!imgEl) { " +
          " imgEl = document.createElement('img'); " +
          " imgEl.id = 'pasteBoardImage'; " +
          " imgEl.width = 0; " +
          " imgEl.height = 0; " +
          " addEvent(imgEl, 'load', function (evt) { " +
          "  if (document.body.createControlRange) { " +
          "   imgEl.contentEditable = 'true'; " +
          "   var controlRange = document.body.createControlRange(); " +
          "   controlRange.addElement(imgEl); " +
          "   controlRange.execCommand('Copy'); " +
          "   imgEl.contentEditable = 'false'; } }); " +
          " document.body.appendChild(imgEl); } " +
          "imgEl.src = url; } ) ";

        ExternalInterface.call(copyImageToClipboardJS, imgUrl);
      }

      /*
       * Displays a connectivity error in the browser status bar.
       */
      function onCopyImageError(event:IOErrorEvent):void {
        trace("onCopyImageError: " + event.text);

        const onCopyImageErrorJS:String =
          "( function (errTxt) { window.status = errTxt; } )";

        ExternalInterface.call(onCopyImageErrorJS, event.text);
      }

      // Create the loader and send the request.
      const urlLoader:URLLoader = new URLLoader();
      urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
      urlLoader.addEventListener(Event.COMPLETE, onCopyImageToClipboard, false, 0, true);
      urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onCopyImageError, false, 0, true);
      urlLoader.load(urlReq);
    }


    /**
     * Copy an image to a browser pop-up window for copying or saving.
     * <code>document.body.createControlRange</code> function. Currently, this
     * function is only supported in Microsoft's Internet Explorer 6 and 7.
     *
     * @param imgBase64Data Contains the image data encoded as base64 data.
     */
    private static function openImageInPopup(imgBase64Data:String):void {
      const imgDataUrl:String = "data:image/png;base64," + imgBase64Data;

      const openImgInPopupJS:String =
        "( function (imgDataUrl) { window.open(imgDataUrl, ''); } )";

      ExternalInterface.call(openImgInPopupJS, imgDataUrl);
    }


    /**
     * Copy an image pf a DisplayObject to the clipboard in browsers that have the
     * <code>document.body.createControlRange</code> function
     * (e.g., Microsoft's Internet Explorer 6 and 7) or, for other browsers,
     * to a browser pop-up window for copying or saving.
     *
     * @param source  References a visible component that supports the
     *        <code>IBitmapDrawable</code> interface.
     *
     * @param pasteboardSvcURL  Is the URL of the JuiceKit PNG pasteboard service
     *        relative to the deployed SWF.
     */
    public static function copyAsImage(source:IBitmapDrawable, pasteboardSvcURL:String):void {
      if (!ExternalInterface.available) {
        throw Error("Cannot copy the image to the browser due to the ExternalInterface being unavailable.");
      }

      const snap:ImageSnapshot = ImageSnapshot.captureImage(source);
      const img64:String = ImageSnapshot.encodeImageAsBase64(snap);

      function hostSupportsClipboard():Boolean {
        const hostSupportsClipboardJS:String =
          "( function () { return (document.body.createControlRange) ? true : false; } )";

        return ExternalInterface.call(hostSupportsClipboardJS) as Boolean;
      }

      if (hostSupportsClipboard()) {
        copyImageToClipboard(img64, pasteboardSvcURL);
      }
      else {
        openImageInPopup(img64);
      }
    }

  }
}
