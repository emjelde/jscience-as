/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.measure.unit {
   /**
    * This class represents a system of units, it groups units together
    * for historical or cultural reasons. Nothing prevents a unit from
    * belonging to several system of units at the same time
    * (for example an imperial system would have many of the units
    * held by NonSI).
    */
   public class SystemOfUnits {
      /**
       * Returns a read only view over the units defined in this system.
       */
      public function get units():Vector.<Unit> {
         return new Vector.<Unit>();
      }
   }
}
