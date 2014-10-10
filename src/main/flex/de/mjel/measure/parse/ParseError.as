/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.measure.parse {
   /**
    * Signals that a problem of some sort has occurred either when creating a
    * converter between two units or during the conversion itself.
    */
   public class ParseError extends Error {

      private var _errorOffset:int = -1;

      public function ParseError(message:*="", errorOffset:int=-1, id:*=0) {
         super(message, id);
         _errorOffset = errorOffset;
      }

      public function get errorOffset():int {
         return errorOffset;
      }
   }
}
