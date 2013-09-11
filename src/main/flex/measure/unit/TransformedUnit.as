/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package measure.unit {
   import measure.converter.UnitConverter;

   /**
    * <p>This class represents the units derived from other units using converters.</p>
    *     
    * <p>Examples of transformed units:<pre>
    *       CELSIUS = KELVIN.add(273.15);
    *       FOOT = METER.multiply(0.3048);
    *       MILLISECOND = MILLI(SECOND);</pre></p>
    *     
    * <p>Transformed units have no label. But like any other units,
    *    they may have labels attached to them:<pre>
    *       UnitFormat.getStandardInstance().label(FOOT, "ft");</pre>
    *    or aliases:<pre>
    *       UnitFormat.getStandardInstance().alias(CENTI(METER)), "centimeter");
    *       UnitFormat.getStandardInstance().alias(CENTI(METER)), "centimetre");</pre></p>
    */
   final public class TransformedUnit extends DerivedUnit {
      /**
       * Holds the parent unit (not a transformed unit).
       */
      private var _parentUnit:Unit;
      
      /**
       * Holds the converter to the parent unit.
       */
      private var _toParentUnit:UnitConverter;
      
      /**
       * Creates a transformed unit from the specified parent unit.
       *
       * @param parentUnit the untransformed unit from which this unit is 
       *        derived.
       * @param  toParentUnit the converter to the parent units.
       * @throws ArgumentError if <code>toParentUnit == UnitConverter.IDENTITY</code>
       */
      public function TransformedUnit(parentUnit:Unit, toParentUnit:UnitConverter) {
         super();
         if (toParentUnit == UnitConverter.IDENTITY) {
            throw new ArgumentError("Identity not allowed");
         }
         _parentUnit = parentUnit;
         _toParentUnit = toParentUnit;
      }
      
      /**
       * Returns the parent unit for this unit. The parent unit is the 
       * untransformed unit from which this unit is derived.
       *
       * @return the untransformed unit from which this unit is derived.
       */
      public function get parentUnit():Unit {
         return _parentUnit;
      }
      
      /**
       * Returns the converter to the parent unit.
       *
       * @return the converter to the parent unit.
       */
      public function toParentUnit():UnitConverter {
         return _toParentUnit;
      }
      
      /**
       * Indicates if this transformed unit is considered equals to the specified 
       * object (both are transformed units with equal parent unit and equal
       * converter to parent unit).
       *
       * @param  that the object to compare for equality.
       * @return <code>true</code> if <code>this</code> and <code>that</code>
       *         are considered equals; <code>false</code>otherwise. 
       */
      override public function equals(that:Object):Boolean {
         if (this == that) {
            return true;
         }
         if (!(that is TransformedUnit)) {
            return false;
         }
         var thatUnit:TransformedUnit = that as TransformedUnit; 
         return this._parentUnit.equals(thatUnit._parentUnit) &&
            this._toParentUnit.equals(thatUnit._toParentUnit);
      }
      
      override public function get standardUnit():Unit {
         return _parentUnit.standardUnit;
      }
      
      override public function toStandardUnit():UnitConverter {
         return _parentUnit.toStandardUnit().concatenate(_toParentUnit);
      }
   }
}
