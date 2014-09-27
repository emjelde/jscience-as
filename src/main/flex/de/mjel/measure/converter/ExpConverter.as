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
    * <p>This class represents a exponential converter of limited precision.
    *    Such converter is used to create inverse of logarithmic unit.</p>
    *
    * <p>This class is internal, instances are created using the
    *    <code>LogConverter.inverse()</code> method.</p>
    */
   internal final class ExpConverter extends UnitConverter {

      /**
       * Identity converter (unique).
       *
       * <p>This converter does nothing (<code>ONE.convert(x) == x</code>).</p>
       */
      public static function get IDENTITY():UnitConverter {
         return UnitConverter.IDENTITY;
      }
      
      /**
       * Holds the logarithmic base.
       */
      private var _base:Number;
      
      /**
       * Holds the natural logarithm of the base.
       */
      private var _logOfBase:Number;
      
      /**
       * Creates a logarithmic converter having the specified base.
       * 
       * @param  base the logarithmic base (e.g. <code>Math.E</code> for
       *         the Natural Logarithm).
       */
      public function ExpConverter(base:Number) {
         _base = base;
         _logOfBase = Math.log(base);
      }
 
      /**
       * Returns the logarithmic base of this converter.
       */
      public function get base():Number {
         return _base;
      }
      
      /**
       * @inheritDoc
       */
      override public function inverse():UnitConverter {
         return new LogConverter(base);
      }
      
      /**
       * @inheritDoc
       */
      override public function convert(amount:Number):Number {
         return Math.exp(_logOfBase * amount);
      }
      
      /**
       * @inheritDoc
       */
      override public function isLinear():Boolean {
         return false;
      }

      /**
       * @inheritDoc
       */
      override public function equals(converter:Object):Boolean {
         if (!(converter is ExpConverter))
            return false;

         var that:ExpConverter = converter as ExpConverter;
         return this.base == that.base;
      }
   }
}
