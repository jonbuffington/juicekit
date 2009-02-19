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


package org.juicekit.util.model {
  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;


  /**
   * The ModelObject class provides an a base class for an application's
   * model objects. This class defines the cloning and XML parsing protocols.
   *
   * @author Jon Buffington
   */
  [Bindable]
  public class ModelObject extends EventDispatcher {

    /**
     * Constructor.
     */
    public function ModelObject(target:IEventDispatcher=null) {
      super(target);
    }


    /**
     * Returns a deep clone of the model object.
     */
    public function clone():ModelObject {
      return new ModelObject();
    }


    /**
     * Parse data from the <code>xml</code> fragment and populate the
     * <code>ModelObject</code> instance properties.
     *
     * <p>Note: This method mutates the receiving instance.</p>
     */
    public function parse(xml:XML, context:* = null):void {
    }


    /**
     * Helper function to determine whether an optional attribute is present
     * in an XML tree.
     */
    public static function hasAttribute(xml:XML, name:String):Boolean {
      return xml.attribute(name).length() > 0;
    }

  }
}
