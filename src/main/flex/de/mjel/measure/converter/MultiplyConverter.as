/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.measure.converter {

   /**
    * <p>This class represents a converter multiplying numeric values by a 
    *    constant scaling factor (approximated as a <code>Number</code>). 
    *    For exact scaling conversions RationalConverter is preferred.</p>
    */
   public final class MultiplyConverter extends UnitConverter {

      /**
       * Identity converter (unique).
       *
       * <p>This converter does nothing (<code>ONE.convert(x) == x</code>).</p>
       */
      public static function get IDENTITY():UnitConverter {
         return UnitConverter.IDENTITY;
      }

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
      
      /**
       * @inheritDoc
       */
      override public function inverse():UnitConverter {
         return new MultiplyConverter(1.0 / factor);
      }
      
      /**
       * @inheritDoc
       */
      override public function convert(amount:Number):Number {
         return factor * amount;
      }
      
      /**
       * @inheritDoc
       */
      override public function isLinear():Boolean {
         return true;
      }
      
      /**
       * @inheritDoc
       */
      override public function concatenate(converter:UnitConverter):UnitConverter {
         var newFactor:Number;
         if (converter is MultiplyConverter) {
            newFactor = factor * (converter as MultiplyConverter).factor;
            return valueOf(newFactor);
         }
         else if (converter is RationalConverter) {
            newFactor = factor
               * (converter as RationalConverter).dividend
               / (converter as RationalConverter).divisor;
            return valueOf(newFactor);
         }
         else {
            return super.concatenate(converter);
         }
      }
      
      /**
       * @private
       */
      private static function valueOf(factor:Number):UnitConverter {
         return factor == 1.0 ? IDENTITY : new MultiplyConverter(factor);
      }
   }
}
