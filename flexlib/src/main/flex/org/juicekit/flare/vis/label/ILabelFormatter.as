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
  import flare.vis.data.DataSprite;


  /**
   * Inteface for LabelFormatters used by a LabelLayout. This interface
   * describes the callback protocol used to apply style attributes to labels.
   */
  public interface ILabelFormatter {

    /**
     * Returns a LabelFormat for a given data property object.
     *
     * @param data Reference to a DataSprite instance.
     *
     * @result A LabelFormat instance describing the rendering style
     *  attributes of the text label or null if a label should not be
     *  displayed.
     */
    function labelFormat(dataSprite:DataSprite):LabelFormat;
  }
}
