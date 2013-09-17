/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.measure {
   import de.mjel.measure.parse.ParsePosition;

   public interface INumberFormat {
      /**
       * Formats a number.
       */
      function format(value:*):String; 

      /**
       * Parses text of given string to produce a number.
       */
      function parse(source:String, pos:ParsePosition=null):Number;
   }
}
