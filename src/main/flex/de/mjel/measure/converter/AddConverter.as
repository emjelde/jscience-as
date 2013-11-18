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
    * <p>This class represents a converter adding a constant offset 
    *    (approximated as a <code>double</code>) to numeric values.</p>
    */
   public final class AddConverter extends UnitConverter {
      /**
       * Holds the offset.
       */
      private var _offset:Number;
      
      /**
       * Creates an add converter with the specified offset.
       *
       * @param  offset the offset value.
       * @throws Error if offset is zero (or close to zero).
       */
      public function AddConverter(offset:Number) {
         if (isNaN(offset) || offset == 0.0) {
            throw new ArgumentError("Identity converter not allowed");
         }
         _offset = offset;
      }
      
      /**
       * Returns the offset value for this add converter.
       *
       * @return the offset value.
       */
      public function get offset():Number {
         return _offset;
      }
      
      override public function inverse():UnitConverter {
         return new AddConverter(-_offset);
      }
      
      override public function convert(amount:Number):Number {
         return amount + _offset;
      }
      
      override public function isLinear():Boolean {
         return false;
      }
      
      override public function concatenate(converter:UnitConverter):UnitConverter {
         if (converter is AddConverter) {
            var offset:Number = _offset + (converter as AddConverter)._offset;
            return valueOf(offset);
         }
         else {
            return super.concatenate(converter);
         }
      }
      
      private static function valueOf(offset:Number):UnitConverter {
         var asFloat:Number = parseFloat(offset.toString());
         return (asFloat == 0.0 || isNaN(asFloat)) ?
            UnitConverter.IDENTITY : new AddConverter(offset);
      }
   }
}
