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
    * Signals that an error has been reached unexpectedly while parsing.
    */
   public class ParseError extends Error {

      private var _errorOffset:int = -1;

      /**
       * Constructs a ParseError with the specified detail message and offset.
       * A detail message is a String that describes this particular exception. 
       *
       * @param message the detail message.
       * @param errorOffset the position where the error is found while parsing
       * @param id contains the reference number associated with the specific error message.
       */
      public function ParseError(message:*="", errorOffset:int=-1, id:*=0) {
         super(message, id);
         _errorOffset = errorOffset;
      }

      /**
       * Returns the position where the error was found.
       */
      public function get errorOffset():int {
         return errorOffset;
      }
   }
}
