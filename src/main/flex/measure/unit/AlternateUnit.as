/*
 * JScience - Java(TM) Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2007 - JScience (http://jscience.org/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package measure.unit {
   import measure.converter.UnitConverter;
   
   /**
    * <p>This class represents the units used in expressions to distinguish
    *    between quantities of a different nature but of the same dimensions.</p>
    *     
    * <p>Instances of this class are created through the <code>alternate(String)</code> method.</p>
    */
   final public class AlternateUnit extends DerivedUnit {
      /**
       * Holds the symbol.
       */
      private var _symbol:String;
      
      /**
       * Holds the parent unit (a system unit).
       */
      private var _parent:Unit;
      
      /**
       * Creates an alternate unit for the specified unit identified by the 
       * specified symbol. 
       *
       * @param symbol the symbol for this alternate unit.
       * @param parent the system unit from which this alternate unit is
       *        derived.
       * @throws UnsupportedOperationException if the source is not 
       *         a standard unit.
       * @throws IllegalArgumentException if the specified symbol is 
       *         associated to a different unit.
       */
      public function AlternateUnit(symbol:String, parent:Unit) {
         super();
         if (!parent.isStandardUnit) {
            throw new ArgumentError(this + " is not a standard unit");
         }
         _symbol = symbol;
         _parent = parent;
         // Checks if the symbol is associated to a different unit.
         var unit:Unit = Unit.SYMBOL_TO_UNIT[symbol];
         if (!unit) {
            Unit.SYMBOL_TO_UNIT[symbol] = this;
            return;
         }
         if (unit is AlternateUnit) {
            var existingUnit:AlternateUnit = unit as AlternateUnit;
            if (symbol == existingUnit._symbol && _parent == existingUnit._parent) {
               return; // OK, same unit.
            }
         }
         throw new ArgumentError("Symbol " + symbol + " is associated to a different unit");
      }
      
      /**
       * Returns the symbol for this alternate unit.
       *
       * @return this alternate unit symbol.
       */
      final public function get symbol():String {
         return _symbol;
      }
      
      /**
       * Returns the parent unit from which this alternate unit is derived 
       * (a system unit itself).
       *
       * @return the parent of the alternate unit.
       */
      final public function get parent():Unit {
         return _parent;
      }
      
      override final public function get standardUnit():Unit {
         return this;
      }
      
      override final public function toStandardUnit():UnitConverter {
         return UnitConverter.IDENTITY;
      }
      
      /**
       * Indicates if this alternate unit is considered equals to the specified 
       * object (both are alternate units with equal symbol, equal base units
       * and equal converter to base units).
       *
       * @param  that the object to compare for equality.
       * @return <code>true</code> if <code>this</code> and <code>that</code>
       *         are considered equals; <code>false</code>otherwise. 
       */
      override public function equals(that:Object):Boolean {
         if (this == that) {
            return true;
         }
         if (!(that is AlternateUnit)) {
            return false;
         }
         var thatUnit:AlternateUnit = that as AlternateUnit;
         return this._symbol == thatUnit._symbol; // Symbols are unique.
      }
   }  
}
