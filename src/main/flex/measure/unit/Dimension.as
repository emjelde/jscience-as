/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package measure.unit {
   /**
    * <p>This class represents the dimension of an unit. Two units <code>u1</code>
    *    and <code>u2</code> are compatible if and
    *    only if <code>(u1.getDimension().equals(u2.getDimension())))</code></p>
    */
   final public class Dimension {
      /**
       * Holds the current physical model.
       */
      private static var _CurrentModel:IDimensionModel;
      
      /**
       * Holds dimensionless.
       */
      public static const NONE:Dimension = new Dimension(Unit.ONE);
      
      /**
       * Holds length dimension (L).
       */
      public static const LENGTH:Dimension = new Dimension('L');
      
      /**
       * Holds mass dimension (M).
       */
      public static const MASS:Dimension = new Dimension('M');
      
      /**
       * Holds time dimension (T).
       */
      public static const TIME:Dimension = new Dimension('T');
      
      /**
       * Holds electric current dimension (I).
       */
      public static const ELECTRIC_CURRENT:Dimension = new Dimension('I');
      
      /**
       * Holds temperature dimension (θ).
       */
      public static const TEMPERATURE:Dimension = new Dimension('θ');
      
      /**
       * Holds amount of substance dimension (N).
       */
      public static const AMOUNT_OF_SUBSTANCE:Dimension = new Dimension('N');
      
      /**
       * Holds the pseudo unit associated to this dimension.
       */
      private var _pseudoUnit:Unit;
      
      /**
       * Creates a new dimension associated to the specified pseudo-unit or symbol.
       */
      public function Dimension(value:*):void {
         super();
         if (value is Unit) {
            _pseudoUnit = value as Unit;
         }
         else {
            var symbol:String = value ? String(value) : "null";
            _pseudoUnit = new BaseUnit("[" + symbol + "]");
         }
      }
      
      /**
       * Returns the product of this dimension with the one specified.
       *
       * @param  that the dimension multiplicand.
       * @return <code>this * that</code>
       */
      final public function times(that:Dimension):Dimension {
         return new Dimension(this._pseudoUnit.times(that._pseudoUnit));
      }
      
      /**
       * Returns the quotient of this dimension with the one specified.
       *
       * @param  that the dimension divisor.
       * @return <code>this / that</code>
       */
      final public function divide(that:Dimension):Dimension {
         return new Dimension(this._pseudoUnit.divide(that._pseudoUnit));
      }
      
      /**
       * Returns this dimension raised to an exponent.
       *
       * @param  n the exponent.
       * @return the result of raising this dimension to the exponent.
       */
      final public function pow(n:int):Dimension {
         return new Dimension(this._pseudoUnit.pow(n));
      }
      
      /**
       * Returns the given root of this dimension.
       *
       * @param  n the root's order.
       * @return the result of taking the given root of this dimension.
       * @throws ArithmeticException if <code>n == 0</code>.
       */
      final public function root(n:int):Dimension {
         return new Dimension(this._pseudoUnit.root(n));
      }
      
      /**
       * Returns the representation of this dimension.
       *
       * @return the representation of this dimension.
       */
      public function toString():String {
         return _pseudoUnit.toString();
      }
      
      /**
       * Indicates if the specified dimension is equals to the one specified.
       *
       * @param that the object to compare to.
       * @return <code>true</code> if this dimension is equals to that dimension;
       *         <code>false</code> otherwise.
       */
      public function equals(that:Object):Boolean {
         if (this == that) {
            return true;
         }
         return (that is Dimension) && _pseudoUnit.equals((that as Dimension)._pseudoUnit);
      }
      
      private static function get CurrentModel():IDimensionModel {
         if (!_CurrentModel) {
            _CurrentModel = new Model();
         }
         return _CurrentModel;
      }
      
      /**
       * Sets the model used to determinate the units dimensions.
       *  
       * @param model the new model to be used when calculating unit dimensions.
       */
      public static function set model(value:IDimensionModel):void {
         Dimension._CurrentModel = value;
      }
      
      /**
       * Returns the model used to determinate the units dimensions.
       */
      public static function get model():IDimensionModel {
         return Dimension.CurrentModel;
      }
   }
}

import measure.converter.RationalConverter;
import measure.converter.UnitConverter;
import measure.unit.BaseUnit;
import measure.unit.Dimension;
import measure.unit.IDimensionModel;
import measure.unit.SI;

/**
 * Standard model (default).
 */
class Model implements IDimensionModel {
   public function Model() {
      super();
   }
   
   public function getDimension(unit:BaseUnit):Dimension {
      if (unit.equals(SI.METRE)) return Dimension.LENGTH;
      if (unit.equals(SI.KILOGRAM)) return Dimension.MASS;
      if (unit.equals(SI.KELVIN)) return Dimension.TEMPERATURE;
      if (unit.equals(SI.SECOND)) return Dimension.TIME;
      if (unit.equals(SI.AMPERE)) return Dimension.ELECTRIC_CURRENT;
      if (unit.equals(SI.MOLE)) return Dimension.AMOUNT_OF_SUBSTANCE;
      if (unit.equals(SI.CANDELA)) return SI.WATT.dimension;
      return new Dimension(new BaseUnit("[" + unit.symbol + "]"));
   }
   
   public function getTransform(unit:BaseUnit):UnitConverter {
      if (unit.equals(SI.CANDELA)) {
         return new RationalConverter(1, 683);
      }
      return UnitConverter.IDENTITY;
   }
}
