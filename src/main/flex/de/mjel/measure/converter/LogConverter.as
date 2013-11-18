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
    * <p>This class represents a logarithmic converter. Such converter 
    *    is typically used to create logarithmic unit. For example:<pre>
    *    var BEL:Unit = Unit.ONE.transform(new LogConverter(10).inverse);
    *    </pre></p>
    */
   public final class LogConverter extends UnitConverter {
      
      /**
       * Holds the logarithmic base.
       */
      private var _base:Number;
      
      /**
       * Holds the natural logarithm of the base.
       */
      private var _logBase:Number;
      
      /**
       * Holds the inverse of the natural logarithm of the base.
       */
      private var _invLogBase:Number;
      
      /**
       * Creates a logarithmic converter having the specified base.
       * 
       * @param  base the logarithmic base (e.g. <code>Math.E</code> for
       *         the Natural Logarithm).
       */
      public function LogConverter(base:Number) {
         _base = base;
         _logBase = Math.log(base);
         _invLogBase = 1.0 / _logBase;
      }
      
      /**
       * Returns the logarithmic base of this converter.
       */
      public function get base():Number {
         return _base;
      }
      
      override public function inverse():UnitConverter {
         return new Inverse(_logBase);
      }
      
      override public function convert(amount:Number):Number {
         return _invLogBase * Math.log(amount);
      }
      
      override public function isLinear():Boolean {
         return false;
      }
   }
}

import de.mjel.measure.converter.UnitConverter;

/**
 * This class represents the inverse of the logarithmic converter
 * (exponentiation converter).
 */
class Inverse extends UnitConverter {
   /**
    * Holds the natural logarithm of the base.
    */
   private var _logBase:Number;
   
   public function Inverse(logBase:Number):void {
      _logBase = logBase;
   }
   
   override public function inverse():UnitConverter {
      return this;
   }
   
   override public function convert(amount:Number):Number {
      return Math.exp(_logBase * amount);
   }
   
   override public function isLinear():Boolean {
      return false;
   }
}
