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
    * <p>This class represent the building blocks on top of which all other
    *    units are created. Base units are typically dimensionally independent.
    *    The actual unit dimension is determinated by the current <code>Model</code>.
    *    For example using the standard model, <code>SI.CANDELA</code> has dimension
    *    of <code>SI.WATT</code>.</p>
    *
    * <p>This class represents the "standard base units" which includes SI base units
    *    and possibly other user-defined base units. It does not represent the base
    *    units of any specific <code>SystemOfUnits</code> (they would have to be base
    *    units across all possible systems otherwise).</p>
    */
   public class BaseUnit extends Unit {
      private var _symbol:String;

      public function BaseUnit(symbol:String) {
         super();
         _symbol = symbol;
         //Checks if the symbol is associated to a different unit.
         var unit:Unit = Unit.SYMBOL_TO_UNIT[symbol];
         if (!unit) {
            Unit.SYMBOL_TO_UNIT[symbol] = this;
            return;
         }
         if (!(unit is BaseUnit)) {
            throw new ArgumentError("Symbol " + symbol + " is associated to a different unit");
         }
      }

      final public function get symbol():String {
         return _symbol;
      }

      override public function equals(that:Object):Boolean {
         if (this == that) {
            return true;
         }
         if (!(that is BaseUnit)) {
            return false;
         }
         var thatUnit:BaseUnit = (that as BaseUnit);
         return symbol == thatUnit.symbol;
      }

      override public function get standardUnit():Unit {
         return this;
      }

      override public function toStandardUnit():UnitConverter {
         return UnitConverter.IDENTITY;
      }
   }
}
