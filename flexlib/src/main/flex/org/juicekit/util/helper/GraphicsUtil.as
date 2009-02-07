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


package org.juicekit.util.helper
{
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;


  /**
   * The GraphicsUtil class provides functions to assist development of
   * visual components that rely on manipulating the Flash Player's
   * scene graph and graphics coontext.
   *
   * @author Jon Buffington
   */
  public final class GraphicsUtil
  {

    /**
     * Constructor.
     */
    public function GraphicsUtil() {
    }


    /**
     * Dump a textual representation of the scene graph heirarchy to the
     * debug console. To be used during development only. The code for
     * this function originated from Adobe documentation sample code.
     */
    public static function traceDisplayList(container:DisplayObjectContainer
                                           , indentString:String = ""):void {
      if (!container) {
        return;
      }
      var child:DisplayObject;
      for (var ix:int=0; ix < container.numChildren; ix++) {
        child = container.getChildAt(ix);
        trace(indentString, child, child.name);
        if (child is DisplayObjectContainer) {
          traceDisplayList(DisplayObjectContainer(child), indentString + "  ")
        }
      }
    }

  }
}
