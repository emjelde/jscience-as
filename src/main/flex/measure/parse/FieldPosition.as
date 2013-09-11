/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package measure.parse {
   /**
    * FieldPosition is a simple class to identify fields in formatted output.
    */
   public class FieldPosition {
      private var _field:int = 0;
      private var _beginIndex:int = 0;
      private var _endIndex:int = 0;

      public function FieldPosition(field:int=0) {
         super();
         _field = field;
      }

      public function setBeginIndex(value:int):void {
         _beginIndex = value;
      }

      public function getBeginIndex():int {
         return _beginIndex;
      }

      public function getEndIndex():int {
         return _endIndex;
      }

      public function setEndIndex(value:int):void {
         _endIndex = value;
      }
   }
}
