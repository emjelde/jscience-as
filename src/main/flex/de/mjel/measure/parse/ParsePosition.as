/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.measure.parse {
   import flash.utils.getQualifiedClassName;  

   /**
    * ParsePosition is a simple class to keep track of the current position during parsing.
    *
    * <p>By design, as you parse through a string with differnt formats,
    *    you can use the same <code>ParsePosition</code>, since the index
    *    parameter records the current position.</code></p>
    */
   public class ParsePosition {
      private var _index:int = 0;
      private var _errorIndex:int = -1;

      public function ParsePosition(index:int) {
         _index = index;
      }

      public function get index():int {
         return _index;
      }

      public function set index(value:int):void {
         _index = value;
      }

      public function get errorIndex():int {
         return _errorIndex;
      }

      public function set errorIndex(value:int):void {
         _errorIndex = value;
      }

      public function toString():String {
         return getQualifiedClassName(this) + "[index=" + _index + ",errorIndex=" + _errorIndex + "]";
      }
   }
}
