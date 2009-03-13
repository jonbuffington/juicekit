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

  import flare.animate.TransitionEvent;
  import flare.display.DirtySprite;
  import flare.util.Property;
  import flare.vis.data.NodeSprite;

  import flash.display.DisplayObject;
  import flash.events.MouseEvent;

  import mx.binding.utils.BindingUtils;
  import mx.binding.utils.ChangeWatcher;
  import mx.containers.HBox;
  import mx.controls.Label;
  import mx.controls.LinkButton;
  import mx.events.FlexEvent;

  import org.juicekit.events.DataMouseEvent;


  /**
   *
   * The <code>TreeMapZoomControl</code> class provides a zoom-in/out
   * companion control for the <code>TreeMapControl</code>. Clicks on a
   * <code>TreeMapControl</code> cause the focus to zoom into branch nodes of
   * treemap. Clicks on the <code>TreeMapZoomControl</code> button path
   * zoom-out to the corresponding branch nodes.
   *
   * @see org.juicekit.visual.controls.TreeMapControl
   *
   * @author Shalini Kataria
   */
  public class TreeMapZoomControl extends HBox
  {
    /*
     * This array contains all the Nodesprites from the root node to the current node.
     */
    private var pathNodes:Array;

    /*
     * Contains the LinkButton View from the root node to the current node.
     */
    private var buttons:Array;

    /*
     * Contains the root node in the treemap data.
     */
    private var rootNode:NodeSprite;

    /*
     * Watches the "data" property of Treemap.
     */
    private var treemapDataWatcher:ChangeWatcher;

    /*
     * Watches the "labelEncodingField" property of the Treemap.
     */
    private var lblEncFieldWatcher:ChangeWatcher;

    /**
    * Holds the "labelEncodingField" of the treemap control.
    */
    public var labelField:String;


    /**
     * Constructor.
     */
    public function TreeMapZoomControl() {
      super();
      this.setStyle("verticalAlign", "middle");
      buttons = new Array();
    }


    /*
     * Store the "tree" property.
     */
    private var _tree:TreeMapControl;

    /**
     * References the companion <code>TreeMapControl</code>.
     *
     * @see org.juicekit.visual.controls.TreeMapControl
     */
    public function set tree(treemap:TreeMapControl):void {
      if (treemap === _tree) return;

      if (_tree) {
        resetView();
        // Unhook _tree.
        _tree.removeEventListener(DataMouseEvent.CLICK, onClickTreeMapControl);
        if (treemapDataWatcher) {
          treemapDataWatcher.unwatch();
          treemapDataWatcher = null;
        }
        if(lblEncFieldWatcher){
          lblEncFieldWatcher.unwatch();
          lblEncFieldWatcher = null;
        }
      }

      _tree = treemap;

      if (_tree) {
        // Hook _tree.
        _tree.addEventListener(DataMouseEvent.CLICK, onClickTreeMapControl, false, 0, true);
        treemapDataWatcher = ChangeWatcher.watch(_tree, "data", onTreeDataChanged);
        lblEncFieldWatcher = BindingUtils.bindProperty(this, "labelField", _tree, "labelEncodingField");
      }
    }

    /**
     * @private
     */
    public function get tree():TreeMapControl{
      return _tree;
    }


    /*
     * This is the event handler defined by the changeWatcher.
     * It is executed whenever the data for treemap is updated.
     */
    private function onTreeDataChanged(event:FlexEvent):void {
      if(tree.data == null){
        resetView();
      }
      if(tree.dataRoot != null){
        this.rootNode = tree.dataRoot; //update the rootNode to point to the dataRoot of this new data set
        tree.minLabelDepth = tree.maxLabelDepth = 1;
        gotoNode(rootNode);
      }
    }


    /*
     * This event handler is executed when a click event occurs on a treemap.
     * It updates the path to the target node.
     */
    private function onClickTreeMapControl(event:DataMouseEvent):void {
      gotoNode(event.sender as NodeSprite);
      beginTransition();
    }


    /*
     * Handles the click event on the LinkButtons.
     * It zooms-out of the treemap to the clicked LinkButton(nodeSprite).
     */
    private function onClickZoomOut(event:MouseEvent):void {
      // Map button to node sprite.
      const ix:int = buttons.indexOf(event.target);
      zoomToTargetNode(pathNodes[ix]);
      beginTransition();
    }


    /*
     * Provide transition effects for zooming into and out of
     * the TreeMapControl.
     */
    private function beginTransition(): void {
       // Make fancy with the animation.
      _tree.transitionPeriod = 0.5;
      _tree.addEventListener(TransitionEvent.END, onEndTransition, false, 0, true);
    }

    private function onEndTransition(event:TransitionEvent):void {
      _tree.removeEventListener(TransitionEvent.END, onEndTransition);
      _tree.transitionPeriod = NaN;
      _tree.minLabelDepth = _tree.maxLabelDepth = _tree.dataRoot.depth + 1;

      // Force flare to render everything.
      callLater(function ():void {
        DirtySprite.renderDirty();
      });
    }


    /*
     * Called with the rootNode whenever data is modified and
     * is called with the clicked node when treemap is clicked.
     */
    private function gotoNode(node:NodeSprite):void {
      const targetDepth:uint = buttons.length + 1;
      const targetNode: NodeSprite = getParentNode(node, targetDepth);
      zoomToTargetNode(targetNode);
    }


    /*
     * Gets the correct node to zoom-in to.
     */
     private function getParentNode(node:NodeSprite, atDepth:uint):NodeSprite {
       var retVal:NodeSprite = node;
       while (retVal.depth > atDepth){
        retVal = retVal.parentNode;
       }
       return retVal;
    }


    private function zoomToTargetNode(targetNode:NodeSprite):void{
      const prop:Property = Property.$("data."+ labelField);
      _tree.dataRoot = targetNode; //update the treemap view
      _tree.minLabelDepth = _tree.maxLabelDepth = _tree.dataRoot.depth + 1;
      resetView();
      pathNodes = makeNodePath(rootNode, targetNode);
      buttons = makePathView(pathNodes, targetNode, prop);
    }


    /*
     * Populates an array with all the nodesprites from the root node to the target node.
     */
    private function makeNodePath(fromNode:NodeSprite, toNode:NodeSprite):Array {
      var nodePathArray:Array;
      var ix:int;

      if (toNode !== fromNode) {
        // Construct a path from node to root.
        nodePathArray = new Array(toNode.depth);
        ix = 0;
        while (toNode.parentNode) {
          nodePathArray[ix++] = toNode.parentNode;
          toNode = toNode.parentNode;
        }

        // Transform the path to root to node.
        nodePathArray = nodePathArray.reverse();
      }
      else {
        // Empty path.
        nodePathArray = new Array();
      }
      return nodePathArray;
    }


    /*
     * This function makes a VIEW (interface) containing LinkButtons for all the path nodes in the array.
     */
    private function makePathView(pathNodes:Array, hereNode:NodeSprite, labelProp:Property):Array {
      // Return button mapping list.
      const retVal:Array = new Array(pathNodes.length);

      var retValIx:int = 0;

      // Create path buttons.
      var button:LinkButton;
      for each (var node:NodeSprite in pathNodes) {
        button = new LinkButton();
        button.label = labelProp.getValue(node);
        button.styleName = "treeMapZoomButton";
        button.addEventListener(MouseEvent.CLICK, onClickZoomOut, false, 0, true);
        addChild(button);

        retVal[retValIx++] = button;
      }

      // Create "Here" label.
      var textField:Label = new Label();
      textField.styleName = "treeMapZoomCurrentLabel";
      textField.text = labelProp.getValue(hereNode);
      addChild(textField);

      return retVal;
    }


    /*
     * Removes all children (LinkButtons and label) from this control.
     */
    private function resetView():void {
      var child:DisplayObject;

      while (numChildren > 0) {
        child = getChildAt(0);
        if (child.hasEventListener(MouseEvent.CLICK)) {
          child.removeEventListener(MouseEvent.CLICK, onClickZoomOut);
        }
        removeChildAt(0);
      }
    }


    /*
     * This function returns the depth (number of LinkButtons) of this control.
     */
    public function get depth():uint{
      return buttons.length;
    }
  }
}
