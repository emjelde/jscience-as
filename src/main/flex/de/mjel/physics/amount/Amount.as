/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.physics.amount {
   import de.mjel.measure.converter.RationalConverter;
   import de.mjel.measure.converter.UnitConverter;
   import de.mjel.measure.parse.Appendable;
   import de.mjel.measure.unit.Unit;
   import de.mjel.measure.IMeasurable;

   import flash.utils.Dictionary;

   import mx.utils.ObjectUtil;

   /**
    * <p>This class represents a determinate or estimated amount for which 
    *    operations such as addition, subtraction, multiplication and division
    *    can be performed (it implements the <code>Field</code> interface).</p>
    *     
    * <p>The nature of an amount can be deduced from its parameterization 
    *    (compile time) or its unit (run time).
    *    Its precision is given by its <code>absoluteError</code>.</p>
    *     
    * <p>Amounts can be exact, in which case they can be
    *    expressed as an exact <code>long</code> integer in the amount unit.
    *    The framework tries to keep amount exact as much as possible.
    *    For example:
    *    <code>
    *       var m:Amount = Amount.valueOf(33, FOOT).divide(11).times(2);
    *       trace(m);
    *       trace(m.exact ? "exact" : "inexact");
    *       trace(m.exactValue);
    *       > 6 ft
    *       > exact
    *       > 6
    *    </code></p>
    *     
    * <p>Errors (including numeric errors) are calculated using numeric intervals.
    *    It is possible to resolve systems of linear equations involving matrices,
    *    even if the system is close to singularity; in which case the error associated
    *    with some (or all) components of the solution may be large.</p>
    *     
    * <p>By default, non-exact amounts are shown using the plus/minus  
    *    character ('±') (see AmountFormat). For example, 
    *    <code>"(2.0 ± 0.001) km/s"</code> represents a velocity of 
    *    2 km/s with an absolute error of ± 1 m/s. Exact amount use an
    *    integer notation (no decimal point, e.g. <code>"2000 m"</code>).</p>
    *     
    * <p>Operations between different amounts may or may not be authorized 
    *    based upon the current <code>PhysicalModel</code>. For example,
    *    adding <code>Amount&lt;Length&gt; and <code>Amount&lt;Duration&gt; is
    *    not allowed by the <code>StandardModel</code>, but is authorized with the
    *    <code>RelativisticModel</code>.</p>
    */
// TODO: implement Field?
   public final class Amount implements IMeasurable/*, Field*/ {

      /**
       * Holds a dimensionless measure of zero (exact).
       */
      private static var _ZERO:Amount;

      /**
       * Dimensionless measure <code>ZERO</code> (exact).
       */
      public static function get ZERO():Amount {
         if (!_ZERO) {
            _ZERO = new Amount();
            _ZERO._unit = Unit.ONE;
            _ZERO._isExact = true;
            _ZERO._exactValue = 0;
            _ZERO._minimum = 0;
            _ZERO._maximum = 0;
         }
         return _ZERO;
      }

      /**
       * Holds a dimensionless measure of one (exact).
       */
      private static var _ONE:Amount;

      /**
       * Dimensionless measure <code>ONE</code> (exact).
       */
      public static function get ONE():Amount {
         if (!_ONE) {
            _ONE = new Amount();
            _ONE._unit = Unit.ONE;
            _ONE._isExact = true;
            _ONE._exactValue = 1;
            _ONE._minimum = 1;
            _ONE._maximum = 1;
         }
         return _ONE;
      }

      private static const DOUBLE_RELATIVE_ERROR:Number = Math.pow(2, -53);
      private static const DECREMENT:Number = (1.0 - DOUBLE_RELATIVE_ERROR);
      private static const INCREMENT:Number = (1.0 + DOUBLE_RELATIVE_ERROR);

      /**
       * Indicates if this measure is exact.
       */
      private var _isExact:Boolean;

      /**
       * Holds the exact value (when exact) stated in this measure unit.
       */
      private var _exactValue:Number;

      /**
       * Holds the minimum value stated in this measure unit.
       * For inexact measures: _minimum < _maximum 
       */
      private var _minimum:Number;

      /**
       * Holds the maximum value stated in this measure unit.
       * For inexact measures: _maximum > _minimum 
       */
      private var _maximum:Number;

      /**
       * Holds this measure unit. 
       */
      private var _unit:Unit;

      /**
       * Returns the measure corresponding to the specified value.
       *
       * @param value the exact or estimated (± error) value stated in the specified unit.
       * @param unit the unit in which the amount and the error are stated (ignored if value is String).
       * @param error the absolute measurement error (ignored if value is String).
       * @return the corresponding measure object.
       * @throws ArgumentError if <code>error &lt; 0.0</code>
       */
      public static function valueOf(value:*, unit:Unit=null, error:Number=NaN):Amount {
         var amount:Amount = Amount.newInstance(unit);

         if (value is Number) {
            if (value % 1 == 0) {
               amount.setExact(value);
            }
            else {
               amount._isExact = false;
               if (!isNaN(error)) {
                  if (error < 0) {
                     throw new ArgumentError("error: " + error + " is negative");
                  }
                  var min:Number = value - error;
                  var max:Number = value + error;
                  amount._minimum = (min < 0) ? min * INCREMENT : min * DECREMENT;
                  amount._maximum = (max < 0) ? max * DECREMENT : max * INCREMENT;
               }
               else {
                  var valInc:Number = value * INCREMENT;
                  var valDec:Number = value * DECREMENT;
                  amount._minimum = (value < 0) ? valInc : valDec;
                  amount._maximum = (value < 0) ? valDec : valInc;
               }
            }
         }
         else {
            amount = AmountFormat.getInstance().parse(value);
         }

         return amount;
      }

      /**
       * Returns the measure corresponding to the specified interval stated 
       * in the specified unit.
       *
       * @param minimum the lower bound for the measure value.
       * @param maximum the upper bound for the measure value.
       * @param unit the unit for both the minimum and maximum values.
       * @return the corresponding measure object.
       * @throws ArgumentError if <code>minimum &gt; maximum</code>
       */
      public static function rangeOf(minimum:Number, maximum:Number, unit:Unit=null):Amount {
         if (minimum > maximum) {
            throw new ArgumentError("minimum: " + minimum + " greater than maximum: " + maximum);
         }
         var amount:Amount = Amount.newInstance(unit);
         amount._isExact = false;
         amount._minimum = (minimum < 0) ? minimum * INCREMENT : minimum * DECREMENT;
         amount._maximum = (maximum < 0) ? maximum * DECREMENT : maximum * INCREMENT;
         return amount;
      }

      /**
       * Indicates if this measure amount is exact. An exact amount is 
       * guarantee exact only when stated in this measure unit
       * (e.g. <code>this.longValue()</code>); stating the amount
       * in any other unit may introduce conversion errors. 
       *
       * @return <code>true</code> if this measure is exact;
       *         <code>false</code> otherwise.
       */
      public function get exact():Boolean {
         return _isExact;
      }

      /**
       * Returns the unit in which the estimated value and absolute error are stated.
       *
       * @return the measure unit.
       */
      public function get unit():Unit {
         return _unit;
      }

      /**
       * Returns the exact value for this measure stated in this measure unit. 
       *
       * @return the exact measure value (<code>long</code>) stated in this measure's unit.
       * @throws AmountError if this measure is not exact
       */
      public function get exactValue():Number {
         if (!_isExact) {
            throw new AmountError("Inexact measures don't have exact values");
         }
         return _exactValue;
      }

      /**
       * Returns the estimated value for this measure stated in this measure unit. 
       *
       * @return the median value of the measure interval.
       */
      public function get estimatedValue():Number {
         return (_isExact) ? _exactValue : (_minimum + _maximum) * 0.5;
      }

      /**
       * Returns the lower bound interval value for this measure stated in this measure unit.
       *
       * @return the minimum value.
       */
      public function get minimumValue():Number {
         return _minimum;
      }

      /**
       * Returns the upper bound interval value for this measure stated in this measure unit.
       *
       * @return the maximum value.
       */
      public function get maximumValue():Number {
         return _maximum;
      }

      /**
       * Returns the value by which the estimated value may differ from
       * the true value (all stated in base units).
       *
       * @return the absolute error stated in base units.
       */
      public function get absoluteError():Number {
         return Math.abs(_maximum - _minimum) * 0.5;
      }

      /**
       * Returns the percentage by which the estimated amount may differ
       * from the true amount.
       *
       * @return the relative error.
       */
      public function get relativeError():Number {
         return _isExact ? 0 : (_maximum - _minimum) / (_minimum + _maximum);
      }

      /**
       * Returns the measure equivalent to this measure but stated in the 
       * specified unit. The returned measure may not be exact even if this 
       * measure is exact due to conversion errors. 
       *
       * @param unit the unit of the measure to be returned.
       * @return a measure equivalent to this measure but stated in the 
       *         specified unit.
       * @throws ConversionException if the current model does not allows for
       *         conversion to the specified unit.
       */
      public function to(unit:Unit):Amount {
         if ((_unit == unit) || this._unit.equals(unit)) {
            return this;
         }
         var result:Amount;
         var cvtr:UnitConverter = Amount.converterOf(_unit, unit);
         if (cvtr == UnitConverter.IDENTITY) { // No conversion necessary.
            result = Amount.copyOf(this);
            result._unit = unit;
            return result;
         }
         if (cvtr is RationalConverter) { // Exact conversion.
            var rc:RationalConverter = cvtr as RationalConverter;
            result = this.times(rc.dividend).divide(rc.divisor);
            result._unit = unit;
            return result;
         }
         result = Amount.newInstance(unit);
         var min:Number = cvtr.convert(_minimum);
         var max:Number = cvtr.convert(_maximum);
         result._isExact = false;
         result._minimum = (min < 0) ? min * INCREMENT : min * DECREMENT;
         result._maximum = (max < 0) ? max * DECREMENT : max * INCREMENT;
         return result;
      }

      /**
       * Returns the opposite of this measure.
       *
       * @return <code>-this</code>.
       */
      public function get opposite():Amount {
         var amount:Amount = Amount.newInstance(_unit);
         trace(amount);
         if ((_isExact) && (_exactValue != Number.MAX_VALUE)) {
            return amount.setExact(-_exactValue);
         }
         amount._isExact = false;
         amount._minimum = -_maximum;
         amount._maximum = -_minimum;
         return amount;
      }

      /**
       * Returns the sum of this measure with the one specified.
       *
       * @param  that the measure to be added.
       * @return <code>this + that</code>.
       * @throws ConversionException if the current model does not allows for
       *         these quantities to be added.
       */
      public function plus(that:Amount):Amount {
         const thatToUnit:Amount = that.to(_unit);
         var amount:Amount = Amount.newInstance(_unit);
         if (this._isExact && thatToUnit._isExact) {
            var sum:Number = (this._exactValue) + (thatToUnit._exactValue);
            amount.setExact(sum);
         }
         else {
            var min:Number = this._minimum + thatToUnit._minimum;
            var max:Number = this._maximum + thatToUnit._maximum;
            amount._isExact = false;
            amount._minimum = (min < 0) ? min * INCREMENT : min * DECREMENT;
            amount._maximum = (max < 0) ? max * DECREMENT : max * INCREMENT;
         }
         return amount;
      }

      /**
       * Returns the difference of this measure with the one specified.
       *
       * @param  that the measure to be subtracted.
       * @return <code>this - that</code>.
       * @throws ConversionException if the current model does not allows for
       *         these quantities to be subtracted.
       */
      public function minus(that:Amount):Amount {
         const thatToUnit:Amount = that.to(_unit);
         var amount:Amount = Amount.newInstance(_unit);
         if (this._isExact && thatToUnit._isExact) {
            var diff:Number = this._exactValue - thatToUnit._exactValue;
            amount.setExact(diff);
         }
         else {
            var min:Number = this._minimum - thatToUnit._maximum;
            var max:Number = this._maximum - thatToUnit._minimum;
            amount._isExact = false;
            amount._minimum = (min < 0) ? min * INCREMENT : min * DECREMENT;
            amount._maximum = (max < 0) ? max * DECREMENT : max * INCREMENT;
         }
         return amount;
      }

      /**
       * Returns this measure scaled by the specified exact or approximate factor (dimensionless),
       * or product of this measure with the one specified (if <code>factor is Amount</code>).
       *
       * @param factor the scaling factor or measure multiplier.
       * @return <code>this · factor</code>.
       */
      public function times(factor:*):Amount {
         var amount:Amount = Amount.newInstance(_unit);
         var min:Number;
         var max:Number;
         if (factor is Amount) {
            var that:Amount = factor;
            var unit:Unit = Amount.productOf(this._unit, that._unit);
            if (that._isExact) {
               amount = this.times(that._exactValue);
               amount._unit = unit;
            }
            else {
               if (_minimum >= 0) {
                  if (that._minimum >= 0) {
                     min = _minimum * that._minimum;
                     max = _maximum * that._maximum;
                  }
                  else if (that._maximum < 0) {
                     min = _maximum * that._minimum;
                     max = _minimum * that._maximum;
                  }
                  else {
                     min = _maximum * that._minimum;
                     max = _maximum * that._maximum;
                  }
               }
               else if (_maximum < 0) {
                  if (that._minimum >= 0) {
                     min = _minimum * that._maximum;
                     max = _maximum * that._minimum;
                  }
                  else if (that._maximum < 0) {
                     min = _maximum * that._maximum;
                     max = _minimum * that._minimum;
                  }
                  else {
                     min = _minimum * that._maximum;
                     max = _minimum * that._minimum;
                  }
               }
               else {
                  if (that._minimum >= 0) {
                     min = _minimum * that._maximum;
                     max = _maximum * that._maximum;
                  }
                  else if (that._maximum < 0) {
                     min = _maximum * that._minimum;
                     max = _minimum * that._minimum;
                  }
                  else { // Both around zero.
                     min = Math.min(_minimum * that._maximum, _maximum * that._minimum);
                     max = Math.max(_minimum * that._minimum, _maximum * that._maximum);
                  }
               }
               amount._isExact = false;
               amount._minimum = (min < 0) ? min * INCREMENT : min * DECREMENT;
               amount._maximum = (max < 0) ? max * DECREMENT : max * INCREMENT;
            }
         }
         else if (factor is Number) {
            if (factor % 1 == 0) {
               if (this._isExact) {
                  var product:Number = _exactValue * factor;
                  amount.setExact(product);
               }
               else {
                  amount._isExact = false;
                  amount._minimum = (factor > 0) ? _minimum * factor : _maximum * factor;
                  amount._maximum = (factor > 0) ? _maximum * factor : _minimum * factor;
               }
            }
            else {
               min = (factor > 0) ? _minimum * factor : _maximum * factor;
               max = (factor > 0) ? _maximum * factor : _minimum * factor;
               amount._isExact = false;
               amount._minimum = (min < 0) ? min * INCREMENT : min * DECREMENT;
               amount._maximum = (max < 0) ? max * DECREMENT : max * INCREMENT;
            }
         }
         else {
            throw new ArgumentError("factor is not supported");
         }
         return amount;
      }

      /**
       * Returns the multiplicative inverse of this measure.
       * If this measure is possibly zero, then the result is unbounded
       * (]-infinity, +infinity[).
       *
       * @return <code>1 / this</code>.
       */
      public function inverse():Amount {
         var amount:Amount = newInstance(Amount.inverseOf(_unit));
         if ((_isExact) && (_exactValue == 1)) { // Only one exact inverse: one
            amount.setExact(1);
         }
         else {
            amount._isExact = false;
            if ((_minimum <= 0) && (_maximum >= 0)) { // Encompass zero.
               amount._minimum = Number.NEGATIVE_INFINITY;
               amount._maximum = Number.POSITIVE_INFINITY;
            }
            else {
               var min:Number = 1.0 / _maximum;
               var max:Number = 1.0 / _minimum;
               amount._minimum = (min < 0) ? min * INCREMENT : min * DECREMENT;
               amount._maximum = (max < 0) ? max * DECREMENT : max * INCREMENT;
            }
         }
         return amount;
      }

      /**
       * Returns this measure divided by the specified exact or approximate factor (dimensionless).
       *
       * @param factor the scaling factor or measure divisor.
       * @return <code>this · factor</code>.
       */
      public function divide(divisor:*):Amount {
         var amount:Amount = Amount.newInstance(_unit);
         if (divisor is Amount) {
            var that:Amount = divisor;
            if (that._isExact) {
               amount = this.divide(that._exactValue);
               amount._unit = Amount.productOf(this._unit, Amount.inverseOf(that._unit));
            }
            else {
               amount = this.times(that.inverse());
            }
         }
         else if (divisor is Number) {
            if (this._isExact) {
               var quotient:Number = _exactValue / divisor;
               if (quotient % 1 == 0) {
                  return amount.setExact(quotient);
               }
            }
            var min:Number = (divisor > 0) ? _minimum / divisor : _maximum / divisor;
            var max:Number = (divisor > 0) ? _maximum / divisor : _minimum / divisor;
            amount._isExact = false;
            amount._minimum = (min < 0) ? min * INCREMENT : min * DECREMENT;
            amount._maximum = (max < 0) ? max * DECREMENT : max * INCREMENT;
         }
         else {
            throw new ArgumentError("divisor is not supported");
         }
         return amount;
      }

      /**
       * Returns the absolute value of this measure.
       *
       * @return  <code>|this|</code>.
       */
      public function abs():Amount {
         if (_isExact) {
            return (_exactValue < 0)
               ? this.opposite
               : this;
         }
         else {
            return (_minimum >= -_maximum)
               ? this
               : this.opposite;
         }
      }

      /**
       * Returns the square root of this measure.
       *
       * @return <code>sqrt(this)</code>
       * 
       */
      public function sqrt():Amount {
         var amount:Amount = Amount.newInstance(_unit.root(2));
         if (this._isExact) {
            var sqrt:Number = Math.sqrt(_exactValue);
            if (sqrt * sqrt == _exactValue) {
               return amount.setExact(sqrt);
            }
         }
         var min:Number = Math.sqrt(_minimum);
         var max:Number = Math.sqrt(_maximum);
         amount._isExact = false;
         amount._minimum = (min < 0) ? min * INCREMENT : min * DECREMENT;
         amount._maximum = (max < 0) ? max * DECREMENT : max * INCREMENT;
         return amount;
      }

      /**
       * Returns the given root of this measure.
       *
       * @param  n the root's order (n != 0).
       * @return the result of taking the given root of this quantity.
       * @throws ArithmeticException if <code>n == 0</code>.
       */
      public function root(n:int):Amount {
         if (n == 0) {
            throw new Error("Root's order of zero");
         }
         if (n < 0) {
            return this.root(-n).inverse();
         }
         if (n == 2) {
            return this.sqrt();
         }
         var amount:Amount = Amount.newInstance(_unit.root(n));
         if (this._isExact) {
            var root:Number = Math.pow(_exactValue, 1.0 / n);
            var thisRoot:Number = root;
            for (var i:int = 1; i < n; i++) {
               thisRoot *= root;
            }
            if (thisRoot == _exactValue) {
               return amount.setExact(root);
            }
         }
         var min:Number = Math.pow(_minimum, 1.0 / n);
         var max:Number = Math.pow(_maximum, 1.0 / n);
         amount._isExact = false;
         amount._minimum = (min < 0) ? min * INCREMENT : min * DECREMENT;
         amount._maximum = (max < 0) ? max * DECREMENT : max * INCREMENT;
         return amount;
      }

      /**
       * Returns this measure raised at the specified exponent.
       *
       * @param  exp the exponent.
       * @return <code>this<sup>exp</sup></code>
       */
      public function pow(exp:int):Amount {
         if (exp < 0) {
            return this.pow(-exp).inverse();
         }
         if (exp == 0) {
            return ONE;
         }
         var pow2:Amount = this;
         var result:Amount = null;
         while (exp >= 1) { // Iteration.
            if ((exp & 1) == 1) {
               result = (result == null) ? pow2 : result.times(pow2);
            }
            pow2 = pow2.times(pow2);
            exp >>>= 1;
         }
         return result;
      }

      /**
       * Compares this measure with the specified measurable object.
       *
       * @param  that the measure to compare with.
       * @return a negative integer, zero, or a positive integer as this measure
       *         is less than, equal to, or greater than that measurable.
       * @throws ConversionException if the current model does not allows for
       *         these measure to be compared.
       */
      public function compareTo(that:IMeasurable):int {
         var thatValue:Number = that.getValue(_unit);
         return ObjectUtil.compare(this.estimatedValue, thatValue);
      }

      /**
       * Compares this measure against the specified object for strict 
       * equality (same value interval and same units).
       *
       * @param  that the object to compare with.
       * @return <code>true</code> if this measure is identical to that
       *         measure; <code>false</code> otherwise.
       */
      public function equals(that:Object):Boolean {
         if (this == that) {
            return true;
         }
         if (!(that is Amount)) {
            return false;
         }
         var amount:Amount = that as Amount;
         if (!_unit.equals(amount._unit)) {
            return false;
         }
         if (_isExact != amount._isExact) {
            return false;
         }
         if (_isExact && (this._exactValue == amount._exactValue)) {
            return true;
         }
         if (_minimum != amount._minimum) {
            return false;
         }
         if (_maximum != amount._maximum) {
            return false;
         }
         return true;
      }

      /**
       * Indicates if this measure approximates that measure.
       * Measures are considered approximately equals if their value intervals
       * overlaps. It should be noted that less accurate measurements are 
       * more likely to be approximately equals. It is therefore recommended
       * to ensure that the measurement error is not too large before testing
       * for approximate equality.
       *
       * @return <code>this ≅ that</code>
       */
      public function approximates(that:Amount):Boolean {
         var thatToUnit:Amount = that.to(_unit);
         return (this._maximum >= thatToUnit._minimum) && (thatToUnit._maximum >= this._minimum);
      }

      /**
       * Indicates if this measure is ordered before that measure
       * (independently of the measure unit).
       *
       * @return <code>this.compareTo(that) < 0</code>.
       */
      public function isLessThan(that:Amount):Boolean {
         return this.compareTo(that) < 0;
      }

      /**
       * Indicates if this measure is ordered after that measure
       * (independently of the measure unit).
       *
       * @return <code>this.compareTo(that) > 0</code>.
       */
      public function isGreaterThan(that:Amount):Boolean {
         return this.compareTo(that) > 0;
      }

      /**
       * Compares this measure with that measure ignoring the sign.
       *
       * @return <code>|this| > |that|</code>
       */
      public function isLargerThan(that:Amount):Boolean {
         return this.abs().isGreaterThan(that.abs());
      }

      /**
       * Returns the text representation of this amount as a String.
       */
      public function toString():String {
         return AmountFormat.getInstance().format(this, new Appendable()).toString();
      }

      public function getValue(unit:Unit=null):Number {
         if (unit == null) {
            unit = _unit;
         }
         if (!_unit.equals(unit)) {
            return this.to(unit).getValue(unit);
         }
         return this.estimatedValue;
      }

      public function intValue(unit:Unit):int {
         if (!_unit.equals(unit)) {
            return this.to(unit).intValue(unit);
         }
         if (_isExact) {
            return _exactValue;
         }
         var value:Number = this.estimatedValue;
         if ((value >= int.MIN_VALUE) && (value <= int.MAX_VALUE)) {
            return Math.round(value);
         }
         throw new Error(value + " " + _unit + " cannot be represented as int");
      }

      ///////////////////
      // Lookup tables //
      ///////////////////

      private static const INV_LOOKUP:Dictionary = new Dictionary();
      private static const MULT_LOOKUP:Dictionary = new Dictionary();
      private static const CVTR_LOOKUP:Dictionary = new Dictionary();

      private static function productOf(left:Unit, right:Unit):Unit {
         var leftTable:Dictionary = MULT_LOOKUP[left];
         if (leftTable == null) {
            return calculateProductOf(left, right);
         }
         var result:Unit = leftTable[right];
         if (result == null) {
            return calculateProductOf(left, right);
         }
         return result;
      }

      private static function calculateProductOf(left:Unit, right:Unit):Unit {
         var leftTable:Dictionary = MULT_LOOKUP[left];
         if (leftTable == null) {
            leftTable = new Dictionary();
            MULT_LOOKUP[left] = leftTable;
         }
         var result:Unit = leftTable[right];
         if (result == null) {
            result = left.times(right);
            leftTable[right] = result;
         }
         return MULT_LOOKUP[left][right];
      }

      private static function inverseOf(unit:Unit):Unit {
         var inverse:Unit = INV_LOOKUP[unit];
         if (inverse == null) {
            return calculateInverseOf(unit);
         }
         return inverse;
      }

      private static function calculateInverseOf(unit:Unit):Unit {
         var inverse:Unit = INV_LOOKUP[unit];
         if (inverse == null) {
            inverse = unit.inverse();
            INV_LOOKUP[unit] = inverse;
         }
         return INV_LOOKUP[unit];
      }

      private static function converterOf(left:Unit, right:Unit):UnitConverter {
         var leftTable:Dictionary = CVTR_LOOKUP[left];
         if (leftTable == null) {
            return calculateConverterOf(left, right);
         }
         var result:UnitConverter = leftTable[right];
         if (result == null) {
            return calculateConverterOf(left, right);
         }
         return result;
      }

      private static function calculateConverterOf(left:Unit, right:Unit):UnitConverter {
         var leftTable:Dictionary = CVTR_LOOKUP[left];
         if (leftTable == null) {
            leftTable = new Dictionary(); 
            CVTR_LOOKUP[left] = leftTable;
         }
         var result:UnitConverter = leftTable[right];
         if (result == null) {
            result = left.getConverterTo(right);
            leftTable[right] = result;
         }
         return CVTR_LOOKUP[left][right];
      }

      public function copy():Amount {
         var estimate:Amount = Amount.newInstance(_unit);
         estimate._isExact = _isExact;
         estimate._exactValue = _exactValue;
         estimate._minimum = _minimum;
         estimate._maximum = _maximum;
         return estimate;
      }

      //////////////////////
      // Factory Creation //
      //////////////////////

      private static function newInstance(unit:Unit=null):Amount {
         var measure:Amount = new Amount();
         if (unit == null) {
            unit = Unit.ONE;
         }
         measure._unit = unit;
         return measure;
      }

      private static function copyOf(original:Amount):Amount {
         var measure:Amount = new Amount();
         measure._exactValue = original._exactValue;
         measure._isExact = original._isExact;
         measure._maximum = original._maximum;
         measure._minimum = original._minimum;
         measure._unit = original._unit;
         return measure;
      }

      /**
       * private - Use newInstance().
       */
      public function Amount() {
         super();
      }

      private function setExact(exactValue:Number):Amount {
         _isExact = true;
         _exactValue = exactValue;
         if (exactValue % 1 == 0) {
            _minimum = exactValue;
            _maximum = exactValue;
         }
         else {
            var valInc:Number = exactValue * INCREMENT;
            var valDec:Number = exactValue * DECREMENT;
            _minimum = (_exactValue < 0) ? valInc : valDec;
            _maximum = (_exactValue < 0) ? valDec : valInc;
         }
         return this;
      }
   }
}
