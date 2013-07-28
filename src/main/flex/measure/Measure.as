/*
 * JScience - Java(TM) Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2007 - JScience (http://jscience.org/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package measure {
   import measure.unit.CompoundUnit;
   import measure.unit.Unit;
   
   import mx.utils.ObjectUtil;
   
   [Abstract]
   
   /**
    * <p>This class represents the result of a measurement stated in a 
    *    known unit.</p>
    * 
    * <p>There is no constraint upon the measurement value itself: scalars, 
    *    vectors, or even data sets are valid values as long as 
    *    an aggregate magnitude can be determined (See <code>Measurable</code>).</p>
    */
   public class Measure implements Measurable {
      /**
       * Default constructor.
       */
      public function Measure() {
         super();
      }
      
      /**
       * Returns the scalar measure for the specified <code>value</code>
       * stated in the specified unit.
       * 
       * @param value the measurement value.
       * @param unit the measurement unit.
       */
      public static function valueOf(value:*, unit:Unit):Measure {
         var value:Number = Number(value);
         return new MeasureNumber(value, unit);
      }
      
      /**
       * Returns the measurement value of this measure.
       *    
       * @return the measurement value.
       */
      [Abstract]
      public function getValue():Number {
         return NaN;
      }
      
      /**
       * Returns the measurement unit of this measure.
       * 
       * @return the measurement unit.
       */
      [Abstract]
      public function getUnit():Unit {
         return null;
      }
      
      /**
       * Returns the measure equivalent to this measure but stated in the 
       * specified unit. This method may result in lost of precision 
       * (e.g. measure of integral value).
       * 
       * @param unit the new measurement unit.
       * @return the measure stated in the specified unit.
       */
      [Abstract]
      public function to(unit:Unit):Measure {
         return null;
      }
      
      /**
       * Returns the value of this measure stated in the specified unit as 
       * a <code>double</code>. If the measure has too great a magnitude to 
       * be represented as a <code>double</code>, it will be converted to 
       * <code>Double.NEGATIVE_INFINITY</code> or
       * <code>Double.POSITIVE_INFINITY</code> as appropriate.
       * 
       * @param unit the unit in which this measure is stated.
       * @return the numeric value after conversion to type <code>double</code>.
       */
      [Abstract]
      public function value(unit:Unit):Number {
         return NaN;
      }
      
      /**
       * Returns the estimated integral value of this measure stated in 
       * the specified unit as a <code>int</code>. 
       * 
       * <p>Note: This method differs from the <code>int(...)</code>
       *          in the sense that the closest integer value is returned 
       *          and an Error is raised instead of a bit truncation in case of
       *          overflow (safety critical).</p> 
       * 
       * @param unit the unit in which the measurable value is stated.
       * @return the numeric value after conversion to type <code>int</code>.
       * @throws Error if this quantity cannot be represented as a <code>int</code>
       *               number in the specified unit.
       */
      public function intValue(unit:Unit):int {
         var numberValue:Number = value(unit);
         if ((numberValue > int.MAX_VALUE) || (numberValue < int.MIN_VALUE)) {
            throw new Error("Overflow");
         }
         return int(numberValue);
      }
      
      /**
       * Compares this measure against the specified object for 
       * strict equality (same unit and amount).
       * To compare measures stated using different units the  
       * <code>compareTo</code> method should be used. 
       *
       * @param obj the object to compare with.
       * @return <code>true</code> if both objects are identical (same 
       *         unit and same amount); <code>false</code> otherwise.
       */
      public function equals(obj:Object):Boolean {
         if (!(obj is Measure)) {
            return false;
         }
         var that:Measure = obj as Measure;
         return this.getUnit().equals(that.getUnit()) &&
            this.getValue() == (that.getValue());
      }

// TODO
//      /**
//       * Returns the <code>String</code> representation of this measure
//       * The string produced for a given measure is always the same;
//       * it is not affected by locale.  This means that it can be used
//       * as a canonical string representation for exchanging data, 
//       * or as a key for a Hashtable, etc.  Locale-sensitive
//       * measure formatting and parsing is handled by the {@link
//       * MeasureFormat} class and its subclasses.
//       * 
//       * @return the string representation of this measure.
//       */
//      public function toString():String {
//      }
      
      /**
       * Compares this measure to the specified measurable quantity.
       * This method compares the <code>Measurable.value(Unit)</code> of 
       * both this measure and the specified measurable stated in the 
       * same unit (this measure's unit).
       * 
       * @return a negative integer, zero, or a positive integer as this measure
       *         is less than, equal to, or greater than the specified measurable
       *         quantity.
       */
      public function compareTo(that:Measurable):int {
         return ObjectUtil.compare(this.value(getUnit()), that.value(getUnit()));
      }
   }
}

import measure.Measure;
import measure.unit.Unit;

/**
 * Scalar implementation for <code>Number</code> values.
 */
final class MeasureNumber extends Measure {
   private var _value:Number;
   private var _unit:Unit;
   
   public function MeasureNumber(value:Number, unit:Unit) {
      _value = value;
      _unit = unit;
   }
   
   override public function getUnit():Unit {
      return _unit;
   }
   
   override public function getValue():Number {
      return _value;
   }
   
   override public function to(unit:Unit):Measure {
      if ((unit == _unit) || (unit.equals(_unit))) {
         return this;
      }
      return new MeasureNumber(value(unit), unit);
   }
   
   override public function value(unit:Unit):Number {
      if ((unit == _unit) || (unit.equals(_unit))) {
         return _value;
      }
      return _unit.getConverterTo(unit).convert(_value);
   }
}
