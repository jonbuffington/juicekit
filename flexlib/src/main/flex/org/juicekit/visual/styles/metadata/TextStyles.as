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


/**
 *  Sets the color of text.
 *
 *  @default 0x000000
 */
[Style(name="fontColor", type="uint", format="Color", inherit="no")]

/**
 *  Name of the font to use.
 *  Unlike in a full CSS implementation,
 *  comma-separated lists are not supported.
 *  You can use any font family name.
 *  If you specify a generic font name,
 *  it is converted to an appropriate device font.
 *
 *  @default "Verdana"
 */
[Style(name="fontFamily", type="String", inherit="yes")]

/**
 *  Sets the height of the text, in pixels.
 *
 *  @default 10
 */
[Style(name="fontSize", type="Number", format="Length", inherit="yes")]

/**
 *  Determines whether the text is italic font.
 *  Recognized values are <code>"normal"</code> and <code>"italic"</code>.
 *
 *  @default "normal"
 */
[Style(name="fontStyle", type="String", enumeration="normal,italic", inherit="yes")]

/**
 *  Determines whether the text is boldface.
 *  Recognized values are <code>"normal"</code> and <code>"bold"</code>.
 *
 *  @default "normal"
 */
[Style(name="fontWeight", type="String", enumeration="normal,bold", inherit="yes")]

/**
 *  Determines the horizontal alignment of text within the cell.
 *  Possible values are <code>"left"</code>, <code>"center"</code>,
 *  or <code>"right"</code>.
 *
 *  @default "left"
 */
[Style(name="textAlign", type="String", enumeration="left,center,right", inherit="yes")]
