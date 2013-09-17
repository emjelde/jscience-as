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
    * <p>This class represents the multi-radix units (such as "hour:min:sec"). 
    *    Instances of this class are created using the compound method.</p>
    *      
    * <p>Examples of compound units:<pre>
    *    Unit<Duration> HOUR_MINUTE_SECOND = HOUR.compound(MINUTE).compound(SECOND);
    *    Unit<Angle> DEGREE_MINUTE_ANGLE = DEGREE_ANGLE.compound(MINUTE_ANGLE);
    *    <pre></p>
    */
   final public class CompoundUnit extends DerivedUnit {
      /**
       * Holds the higher unit.
       */
      private var _high:Unit;
      
      /**
       * Holds the lower unit.
       */
      private var _low:Unit;
      
      /**
       * Creates a compound unit from the specified units. 
       *
       * @param high the high unit.
       * @param low the lower unit(s)
       * @throws ArgumentError if both units do not the same system unit.
       */
      public function CompoundUnit(high:Unit, low:Unit) {
         super();
         if (!high.standardUnit.equals(low.standardUnit)) {
            throw new ArgumentError("Both units do not have the same system unit");
         }
         _high = high;
         _low = low;
      }
      
      /**
       * Returns the lower unit of this compound unit.
       *
       * @return the lower unit.
       */
      public function get lower():Unit {
         return _low;
      }
      
      /**
       * Returns the higher unit of this compound unit.
       *
       * @return the higher unit.
       */
      public function get higher():Unit {
         return _high;
      }
      
      /**
       * Indicates if this compound unit is considered equals to the specified 
       * object (both are compound units with same composing units in the 
       * same order).
       *
       * @param  that the object to compare for equality.
       * @return <code>true</code> if <code>this</code> and <code>that</code>
       *         are considered equals; <code>false</code> otherwise. 
       */
      override public function equals(that:Object):Boolean {
         if (this == that) {
            return true;
         }
         if (!(that is CompoundUnit)) {
            return false;
         }
         var thatUnit:CompoundUnit = that as CompoundUnit;
         return this._high.equals(thatUnit._high) && this._low.equals(thatUnit._low);
      }
      
      override public function get standardUnit():Unit {
         return _low.standardUnit;
      }
      
      override public function toStandardUnit():UnitConverter {
         return _low.toStandardUnit();
      }
   }
}
