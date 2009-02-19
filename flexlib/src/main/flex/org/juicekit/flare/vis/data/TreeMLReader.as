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


package org.juicekit.flare.vis.data {
  import flare.data.DataUtil;
  import flare.util.Property;
  import flare.util.Shapes;
  import flare.vis.data.NodeSprite;
  import flare.vis.data.Tree;


  /**
   * Converts TreeML markup into flare Tree instances.
   * <a href="http://cs.marlboro.edu/courses/fall2006/tutorials/information_visualization/TreeML">
   * TreeML</a> is an XML format originally created for the 2003 InfoVis
   * conference contest. A DTD (Document Type Definition) for TreeML is
   * <a href="http://www.nomencurator.org/InfoVis2003/download/treeml.dtd">
   * available</a>.
   */
  public class TreeMLReader {


    /**
     * Reads data from an external XML format into ActionScript objects.
     *
     * @param input References the loaded XML input data.
     *
     * @return Returns a Tree instance containing input data.
     */
    public static function read(input:XML):Tree {
      const tree:Tree = new Tree();
      const root:NodeSprite = tree.addRoot();
      const typeMap:Object = parseAttrDecls(input);
      return parse(input[BRANCH][0], typeMap, tree, root);
    }


    /**
     * Parse a node in the TreeML input to both extract TreeML attributes
     * and decend into child nodes.
     */
    private static function parse(node:XML, typeMap:Object, tree:Tree, nodeSprite:NodeSprite):Tree {
      // 1. Parse this node's data values;
      nodeSprite.data = parseAttrData(node, typeMap);

      // 2. Provide reasonable defaults to the node visuals.
      nodeSprite.shape = Shapes.BLOCK;

      // 3. Recurse through any children if this is not a leaf.
      if (node.name().localName !== LEAF) {
        var childSprite:NodeSprite;
        for each (var leaf:XML in node[LEAF]) {
          childSprite = tree.addChild(nodeSprite);
          tree = parse(leaf, typeMap, tree, childSprite);
        }
        for each (var branch:XML in node[BRANCH]) {
          childSprite = tree.addChild(nodeSprite);
          tree = parse(branch, typeMap, tree, childSprite);
        }
      }
      return tree;
    }


    /**
     * Parse a TreeML attribute node's data into an ActionScript
     * object using a typeMap to direct value typing.
     *
     * @param node References a branch or leaf node.
     *
     * @return Returns an ActionScript object containing the parsed
     * nodes TreeML attributes.
     */
    private static function parseAttrData(node:XML, typeMap:Object):Object {
      const data:Object = {};
      var name:String;
      for each (var attr:XML in node[ATTR]) {
        name = attr.@[NAME];
        data[name] = DataUtil.parseValue(attr.@[VALUE], typeMap[name]);
      }
      return data;
    }


    /**
     * Parse the attrbuteDecl nodes into a name and type look-up map.
     *
     * @param treeml References the entire treeml document.
     *
     * @return Returns a look-up map object of where DataUtil types
     *  are mapped to TreeML attribute names.
     */
    private static function parseAttrDecls(treeml:XML):Object {
      const decls:Object = {};
      const attrs:XML = treeml[DECLS][0];
      for each (var decl:XML in attrs[DECL]) {
        decls[decl.@[NAME]] = toType(decl.@[TYPE]);
      }
      return decls;
    }


    /**
     * Check the a <code>Property</code>'s values to determine if 1) the children
     * sum to the parent value and, 2) the values are non-negative values.
     *
     * @param rootNode Is the root node of a parsed data set. This value is often
     * the <code>root</code> property of the <code>Tree</code> returned
     * using the <code>parse</code> function.
     *
     * @return Returns true if the values pass the above two rules.
     */
    public static function checkSizeValues(rootNode:NodeSprite, property:Property):Boolean {
      // Negative values are not permitted for size values.
      const rootValue:Number = property.getValue(rootNode) as Number;
      if (rootValue < 0) {
        trace(rootNode.data.name + " has a negative size value = " + rootValue.toString());
        return false;
      }

      // A leaf always validates.
      const childCnt:uint = rootNode.childDegree;
      if (childCnt === 0)
        return true;

      var validates:Boolean = false;
      var childrenSum:Number = 0;

      for (var i:uint = 0, ns:NodeSprite; i < childCnt; ++i) {
        ns = rootNode.getChildNode(i);
        validates = checkSizeValues(ns, property);
        if (!validates)
          break;
        childrenSum += property.getValue(ns) as Number;
      }

      // Only check if all children validate.
      if (validates) {
        // The sum of the children must equal the parent.
        validates = childrenSum === rootValue;
        if (!validates) {
          trace("The children of " + rootNode.data.name + " sum to " + childrenSum + " while the parent claims " + rootValue);
        }
      }
      return validates;
    }

    // -- writer ----------------------------------------------------------



    // -- static helpers --------------------------------------------------

    private static function toType(type:String):int {
      switch (type) {
        case INT:
        case INTEGER:
          return DataUtil.INT;
        case LONG:
        case FLOAT:
        case DOUBLE:
        case REAL:
          return DataUtil.NUMBER;
        case BOOLEAN:
          return DataUtil.BOOLEAN;
        case DATE:
          return DataUtil.DATE;
        case CATEGORY:
        case STRING:
          return DataUtil.STRING;
        default:
          throw new Error("'" + type + "' is an unsupported TreeML data type.");
      }
    }

    private static function fromType(type:int):String {
      switch (type) {
        case DataUtil.INT:    return INT;
        case DataUtil.BOOLEAN:  return BOOLEAN;
        case DataUtil.NUMBER: return DOUBLE;
        case DataUtil.DATE:   return DATE;
        case DataUtil.STRING:
        default:        return STRING;
      }
    }


    //
    // TreeML string tokens
    //
    public static const TREE:String   = "tree";
    public static const BRANCH:String = "branch";
    public static const LEAF:String   = "leaf";
    public static const ATTR:String   = "attribute";
    public static const NAME:String   = "name";
    public static const VALUE:String  = "value";
    public static const TYPE:String   = "type";

    public static const DECLS:String  = "declarations";
    public static const DECL:String   = "attributeDecl";

    public static const INT:String = "Int";
    public static const INTEGER:String = "Integer";
    public static const LONG:String = "Long";
    public static const FLOAT:String = "Float";
    public static const REAL:String = "Real";
    public static const STRING:String = "String";
    public static const DATE:String = "Date";
    public static const CATEGORY:String = "Category";

    // Note: prefuse-specific allowed types
    public static const BOOLEAN:String = "Boolean";
    public static const DOUBLE:String = "Double";
  }
}
