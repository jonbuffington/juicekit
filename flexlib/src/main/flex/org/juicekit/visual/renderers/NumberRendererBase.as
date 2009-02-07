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


package org.juicekit.visual.renderers {

  import mx.controls.DataGrid;
  import mx.controls.dataGridClasses.DataGridColumn;


  /**
   * The class NumberRendererBase provides a common implementation for custom
   * ActionScript renderers that draw numeric data values. The class is only
   * intended to be used as a base implementation for custom renderers and
   * is not intended to be directly instantiated.
   *
   * @author Jon Buffington
   */
  public class NumberRendererBase extends RendererBase {


    /**
     * Constructor.
     */
    public function NumberRendererBase() {
      super();
    }


    /**
     * @return Returns the renderer's data value as a Number or NaN.
     */
    protected function get numberValue():Number {
      var numberValue:Number;
      // The following Number type conversions were chosen over the 'as'
      // operator to allow NaN to propogate.
      if (listData) {
        var dg:DataGrid = listData.owner as DataGrid;
        var dgc:DataGridColumn = dg.columns[listData.columnIndex];
        var o:Object = data[dgc.dataField];
        numberValue = (o !== null) ? Number(o) : NaN;
      }
      else {
        numberValue = (data !== null) ? Number(data) : NaN;
      }
      return numberValue;
    }
  }
}
