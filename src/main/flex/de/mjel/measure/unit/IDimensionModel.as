/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.measure.unit {
   import de.mjel.measure.converter.UnitConverter;

   /**
    * This interface represents the mapping between BaseUnit and Dimension.
    * Custom models may allow conversions not possible using the standard model.
    */
   public interface IDimensionModel {
      /**
       * Returns the dimension of the specified base unit (a dimension 
       * particular to the base unit if the base unit is not recognized).
       * 
       * @param unit the base unit for which the dimension is returned.
       * @return the dimension of the specified unit.
       */
      function getDimension(unit:BaseUnit):Dimension;
      
      /**
       * Returns the normalization transform of the specified base unit
       * (<code>IDENTITY</code> if the base unit is not recognized).
       * 
       * @param unit the base unit for which the transform is returned.
       * @return the normalization transform.
       */
      function getTransform(unit:BaseUnit):UnitConverter;
   }
}
