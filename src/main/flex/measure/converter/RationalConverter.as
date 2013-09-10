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
    * <p>This class represents a converter multiplying numeric values by an
    *    exact scaling factor (represented as the quotient of two 
    *    <code>long</code> numbers).</p>
    */
   public final class RationalConverter extends UnitConverter {
      /**
       * Holds the converter dividend.
       */
      private var _dividend:Number;
      
      /**
       * Holds the converter divisor (always positive).
       */
      private var _divisor:Number;
      
      /**
       * Creates a rational converter with the specified dividend and 
       * divisor.
       *
       * @param dividend the dividend.
       * @param divisor the positive divisor.
       * @throws IllegalArgumentException if <code>divisor &lt; 0</code>
       * @throws IllegalArgumentException if <code>dividend == divisor</code>
       */
      public function RationalConverter(dividend:Number, divisor:Number) {
         super();
         if (divisor < 0) {
            throw new ArgumentError("Negative divisor");
         }
         if (dividend == divisor) { 
            throw new ArgumentError("Identity converter not allowed");
         }
         _dividend = dividend;
         _divisor = divisor;
      }
      
      /**
       * Returns the dividend for this rational converter.
       *
       * @return this converter dividend.
       */
      public function get dividend():Number {
         return _dividend;
      }
      
      /**
       * Returns the positive divisor for this rational converter.
       *
       * @return this converter divisor.
       */
      public function get divisor():Number {
         return _divisor;
      }
      
      override public function inverse():UnitConverter {
         return _dividend < 0
            ? new RationalConverter(-_divisor, -_dividend)
            : new RationalConverter( _divisor,  _dividend);
      }
      
      override public function convert(amount:Number):Number {
         return amount * _dividend / _divisor;
      }
      
      override public function get isLinear():Boolean {
         return true;
      }
      
      override public function concatenate(converter:UnitConverter):UnitConverter {
         if (converter is RationalConverter) {
            var that:RationalConverter = converter as RationalConverter;
            var dividend:Number = this._dividend * that._dividend;
            var divisor:Number = this._divisor * that._divisor;
            var gcd:Number = gcd(dividend, divisor);
            return RationalConverter.valueOf(dividend / gcd, divisor / gcd);
         }
         else if (converter is MultiplyConverter) {
            return converter.concatenate(this);
         }
         else {
            return super.concatenate(converter);
         }
      }
      
      private static function valueOf(dividend:Number, divisor:Number):UnitConverter {
         return (dividend == 1) && (divisor == 1)
            ? UnitConverter.IDENTITY
            : new RationalConverter(dividend, divisor);
      }
      
      /**
       * Returns the greatest common divisor (Euclid's algorithm).
       *
       * @param  m the first number.
       * @param  nn the second number.
       * @return the greatest common divisor.
       */
      private static function gcd(m:Number, n:Number):Number {
         if (n == 0) {
            return m;
         }
         return gcd(n, m % n);
      }
   }  
}
