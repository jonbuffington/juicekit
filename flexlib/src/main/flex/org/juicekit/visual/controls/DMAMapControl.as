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


package org.juicekit.visual.controls {
  import org.juicekit.visual.flash.controls.DMAMap;

  import flash.display.MovieClip;


  /**
   * The DMAMapControl class visualizes Nielson Designated Market Areas (DMA).
   * Each areas' graphical treatment is manipulated using a function that
   * maps data values to color values.
   *
   * @author Jon Buffington
   */
  public class DMAMapControl extends MovieClipControlBase {


    /**
     * Constructor.
     */
    public function DMAMapControl() {
      super();
    }


    /**
     * @private
     */
    override protected function createMovieClip():MovieClip {
      return new DMAMap();
    }
  }
}
