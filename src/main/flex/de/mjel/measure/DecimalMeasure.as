/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.measure {
   import de.mjel.math.BigDecimal;
   import de.mjel.math.MathContext;
   import de.mjel.measure.converter.AddConverter;
   import de.mjel.measure.converter.RationalConverter;
   import de.mjel.measure.converter.UnitConverter;
   import de.mjel.measure.unit.Unit;

   /**
    * <p>This class represents a measure whose value is an arbitrary-precision 
    *    decimal number.</p>
    *     
    * <p>When converting, applications may supply the 
    *    <code>de.mjel.math.MathContext</code>:
    *    <code>
    *      var c:DecimalMeasure = DecimalMeasure.valueOf("299792458 m/s");
    *      var milesPerHour:DecimalMeasure = c.to(MILES_PER_HOUR, MathContext.DECIMAL128);
    *      trace(milesPerHour); // 670616629.3843951324266284896206156 mph
    *    </code>
    */
   public class DecimalMeasure extends Measure {

      /**
       * Holds the BigDecimal value.
       */
      private var _value:BigDecimal;

      /**
       * Holds the unit.
       */
      private var _unit:Unit;

      /**
       * Creates a decimal measure for the specified number stated in the 
       * specified unit.
       */
      public function DecimalMeasure(value:BigDecimal, unit:Unit):void {
         _value = value;
         _unit = unit;
      }

      /**
       * Returns the decimal measure for the specified value stated in the specified unit.
       * 
       * @throws NumberFormatException if the specified value is 
       *         not a valid representation of decimal measure.
       */
      public static function valueOf(value:*, unit:Unit=null):DecimalMeasure {
         if (value is BigDecimal) {
            return new DecimalMeasure(value as BigDecimal, unit);
         }
         else if (value != null) {
            value = String(value);
            var numberLength:int = value.length;
            var unitStartIndex:int = -1;
            for (var i:int = 0; i < value.length; i++) {
               if (isWhitespace(value.charAt(i))) {
                  for (var j:int = i + 1; j < value.length; j++) {
                     if (!isWhitespace(value.charAt(j))) {
                        unitStartIndex = j;
                        break;
                     }
                  }
                  numberLength = i;
                  break;
               }
            }
            var decimal:BigDecimal = new BigDecimal(value.substring(0, numberLength));
            if (unitStartIndex > 0) {
               unit = Unit.valueOf(value.substring(unitStartIndex));
            }
            else {
               unit = Unit.ONE;
            }
            return new DecimalMeasure(decimal, unit);
         }
         else {
            throw new ArgumentError("Invalid arguments");
         }
      }

      private static function isWhitespace(value:String):Boolean {
         return value == " ";
      }

      override public function getUnit():Unit {
         return _unit;
      }

      public function getBigDecimal():BigDecimal {
         return _value;
      }

      override public function getValue(unit:Unit=null):Number {
         if (unit != null && unit != _unit && !unit.equals(_unit)) {
            return _unit.getConverterTo(unit).convert(_value.toNumber());
         }
         return _value.toNumber();
      }

      /**
       * Returns the decimal measure equivalent to this measure but stated in the 
       * specified unit. This method will raise an ArithmeticException if the 
       * resulting measure does not have a terminating decimal expansion.
       * 
       * @param unit the new measurement unit.
       * @return the measure stated in the specified unit.
       * @throws ArithmeticException if the converted measure value does not have
       *         a terminating decimal expansion
       * @see #to(Unit, MathContext)
       */
      override public function to(unit:Unit):Measure {
         return toDecimalMeasure(unit, null);
      }

      /**
       * Returns the decimal measure equivalent to this measure but stated in the 
       * specified unit, the conversion is performed using the specified math
       * context.
       * 
       * @param unit the new measurement unit.
       * @param mathContext the mathContext used to convert 
       *        <code>BigDecimal</code> values or <code>null</code> if none. 
       * @return the measure stated in the specified unit.
       * @throws ArithmeticException if the result is inexact but the
       *         rounding mode is <code>MathContext.UNNECESSARY</code> or 
       *         <code>mathContext.precision == 0</tt> and the quotient has a 
       *         non-terminating decimal expansion.
       */
      public function toDecimalMeasure(unit:Unit, mathContext:MathContext):DecimalMeasure {
         if ((unit == _unit) || (unit.equals(_unit))) {
            return this;
         }
         var result:BigDecimal;
         var cvtr:UnitConverter = _unit.getConverterTo(unit);
         if (cvtr is RationalConverter) {
            var dividend:BigDecimal = BigDecimal.valueOf((cvtr as RationalConverter).dividend);
            var divisor:BigDecimal = BigDecimal.valueOf((cvtr as RationalConverter).divisor);
            result = mathContext == null
               ? _value.multiply(dividend).divide(divisor)
               : _value.multiply(dividend, mathContext).divide(divisor, mathContext);
            return new DecimalMeasure(result, unit);
         }
         else if (cvtr.isLinear()) {
            var factor:BigDecimal = BigDecimal.valueOf(cvtr.convert(1.0));
            result = mathContext == null
               ? _value.multiply(factor)
               : _value.multiply(factor, mathContext);
            return new DecimalMeasure(result, unit);
         }
         else if (cvtr is AddConverter) {
            var offset:BigDecimal = BigDecimal.valueOf((cvtr as AddConverter).offset);
            result = mathContext == null
               ? _value.add(offset)
               : _value.add(offset, mathContext);
            return new DecimalMeasure(result, unit);
         }
         else { // Non-linear and not an offset, convert the double value.
            result = BigDecimal.valueOf(cvtr.convert(_value.toNumber()));
            return new DecimalMeasure(result, unit);
         }
      }
   }
}
