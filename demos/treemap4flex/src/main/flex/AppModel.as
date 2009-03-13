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


package {
  import flash.events.IEventDispatcher;

  import org.juicekit.util.model.ModelObject;


  [Bindable]
  public final class AppModel extends ModelObject {


    /**
     * Hold the data property name used to determine the treemap's
     * rectange color fill (color).
     */
    public var colorPropertyName:String = "";


    /**
     * Hold the data property name used to determine the treemap's
     * label text (name).
     */
    public var labelPropertyName:String = "";


    /**
     * Hold the data property name used to determine the treemap's
     * rectange areas (size).
     */
    public var sizePropertyName:String = "";


    /**
     * Constructor.
     */
    public function AppModel(target:IEventDispatcher=null) {
      super(target);
    }


    /**
     * @inheritDoc
     */
    override public function clone():ModelObject {
      const klone:AppModel = new AppModel();
      klone.colorPropertyName = this.colorPropertyName;
      klone.labelPropertyName = this.labelPropertyName;
      klone.sizePropertyName = this.sizePropertyName;
      return klone;
    }
  }
}
