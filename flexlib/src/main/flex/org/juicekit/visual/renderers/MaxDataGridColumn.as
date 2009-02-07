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

  import mx.controls.dataGridClasses.DataGridColumn;


  /**
   * The class MaxDataGridColumn provides a maximum value that is used by
   * the HBarRenderer to convert absolute value bars into percentage of
   * maximum value bars.
   *
   * @see org.juicekit.visual.renderers.HBarRenderer
   *
   * @author Jon Buffington
   */
  public class MaxDataGridColumn extends DataGridColumn {


    /**
     * Constructor.
     */
    public function MaxDataGridColumn() {
      super();
    }


    /**
     * Holds a maximum value used by a HBarRenderer to calculate
     * relative percentages.
     */
    public var maximalValue:Number;
  }
}
