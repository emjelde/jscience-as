/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.measure.converter {
   
   [Abstract]
   
   /**
    * <p>This class represents a converter of numeric values.</p>
    *
    * <p>It is not required for sub-classes to be immutable (e.g. currency converter).</p>
    *
    * <p>Sub-classes must ensure unicity of the <code>IDENTITY</code> converter.
    *    In other words, if the result of an operation is equivalent to the identity
    *    converter, then the unique <code>IDENTITY</code> instance should be returned.</p>
    */
   public class UnitConverter {
      /**
       * Holds the identity converter (unique). This converter does nothing
       * (<code>ONE.convert(x) == x</code>).
       */
      private static var _IDENTITY:UnitConverter;
      
      public function UnitConverter() {
         super();
      }
      
      /**
       * Identity converter (unique). This converter does nothing (<code>ONE.convert(x) == x</code>).
       */
      public static function get IDENTITY():UnitConverter {
         if (!_IDENTITY) {
            _IDENTITY = new Identity();
         }
         return _IDENTITY;
      }
      
      /**
       * Returns the inverse of this converter. If <code>value</code> is a valid
       * value, then <code>value == inverse().convert(convert(value))</code> to within
       * the accuracy of computer arithmetic.
       *
       * @return the inverse of this converter.
       */
      [Abstract]
      public function inverse():UnitConverter {
         return null;
      }
      
      /**
       * Converts a Number value.
       *
       * @param value the numeric value to convert.
       * @return the converted numeric value.
       * @throws ConversionException if an error occurs during conversion.
       */
      [Abstract]
      public function convert(value:Number):Number {
         return NaN;
      }
      
      /**
       * Indicates if this converter is linear. A converter is linear if
       * <code>convert(u + v) == convert(u) + convert(v)</code> and
       * <code>convert(r * u) == r * convert(u)</code>.
       * For linear converters the following property always hold:<pre>
       *     y1 = c1.convert(x1);
       *     y2 = c2.convert(x2); 
       * then y1*y2 = c1.concatenate(c2).convert(x1*x2)</pre>
       *
       * @return <code>true</code> if this converter is linear;
       *         <code>false</code> otherwise.
       */
      [Abstract]
      public function isLinear():Boolean {
         return false;
      }
      
      /**
       * Concatenates this converter with another converter. The resulting
       * converter is equivalent to first converting by the specified converter,
       * and then converting by this converter.
       * 
       * <p>Note: Implementations must ensure that the <code>IDENTITY</code> instance
       *          is returned if the resulting converter is an identity 
       *          converter.</p> 
       * 
       * @param converter the other converter.
       * @return the concatenation of this converter with the other converter.
       */
      public function concatenate(converter:UnitConverter):UnitConverter {
         return (converter == IDENTITY) ? this : new Compound(converter, this);
      }
      
      /**
       * Indicates whether this converter is considered the same as the  
       * converter specified. To be considered equal this converter 
       * concatenated with the one specified must return the <code>IDENTITY</code>.
       *
       * @param converter the converter with which to compare.
       * @return <code>true</code> if the specified object is a converter 
       *         considered equals to this converter;<code>false</code> otherwise.
       */
      public function equals(converter:Object):Boolean {
         if (!(converter is UnitConverter)) {
            return false;
         }
         return concatenate((converter as UnitConverter).inverse()) == IDENTITY;
      }
   }
}

import de.mjel.measure.converter.UnitConverter;

/**
 * This class represents the identity converter (singleton).
 */
final class Identity extends UnitConverter {
   public function Identity() {
      super();
   }
   
   override public function inverse():UnitConverter {
      return this;
   }
   
   override public function convert(value:Number):Number {
      return value;
   }
   
   override public function isLinear():Boolean {
      return true;
   }
   
   override public function concatenate(converter:UnitConverter):UnitConverter {
      return converter;
   }
}

/**
 * This class represents a compound converter.
 */
final class Compound extends UnitConverter {
   
   /**
    * Holds the first converter.
    */
   private var _first:UnitConverter;
   
   /**
    * Holds the second converter.
    */
   private var _second:UnitConverter;
   
   /**
    * Creates a compound converter resulting from the combined
    * transformation of the specified converters.
    *
    * @param  first the first converter.
    * @param  second the second converter.
    */
   public function Compound(first:UnitConverter, second:UnitConverter) {
      super();
      _first = first;
      _second = second;
   }
   
   override public function inverse():UnitConverter {
      return new Compound(_second.inverse(), _first.inverse());
   }
   
   override public function convert(value:Number):Number {
      return _second.convert(_first.convert(value));
   }
   
   override public function isLinear():Boolean {
      return _first.isLinear() && _second.isLinear();
   }
}
