/*
 * JScience - Java(TM) Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2007 - JScience (http://jscience.org/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package measure.converter {
   /**
    * <p>This class represents a converter multiplying numeric values by a 
    *    constant scaling factor (approximated as a <code>Number</code>). 
    *    For exact scaling conversions RationalConverter is preferred.</p>
    */
   public final class MultiplyConverter extends UnitConverter {
      /**
       * Holds the scale factor.
       */
      private var _factor:Number;
      
      /**
       * Creates a multiply converter with the specified scale factor.
       *
       * @param  factor the scale factor.
       * @throws IllegalArgumentException if offset is one (or close to one).
       */
      public function MultiplyConverter(factor:Number) {
         super();
         if (factor == 1.0) {
            throw new ArgumentError("Identity converter not allowed");
         }
         _factor = factor;
      }
      
      /**
       * Returns the scale factor.
       *
       * @return the scale factor.
       */
      public function get factor():Number {
         return _factor;
      }
      
      override public function inverse():UnitConverter {
         return new MultiplyConverter(1.0 / _factor);
      }
      
      override public function convert(amount:Number):Number {
         return _factor * amount;
      }
      
      override public function get isLinear():Boolean {
         return true;
      }
      
      override public function concatenate(converter:UnitConverter):UnitConverter {
         var factor:Number;
         if (converter is MultiplyConverter) {
            factor = _factor * (converter as MultiplyConverter)._factor;
            return valueOf(factor);
         }
         else if (converter is RationalConverter) {
            factor = _factor
               * (converter as RationalConverter).dividend
               / (converter as RationalConverter).divisor;
            return valueOf(factor);
         }
         else {
            return super.concatenate(converter);
         }
      }
      
      private static function valueOf(factor:Number):UnitConverter {
         return factor == 1.0 ? UnitConverter.IDENTITY : new MultiplyConverter(factor);
      }
   }
}
