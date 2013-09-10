/*
 * JScience - Java(TM) Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2007 - JScience (http://jscience.org/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package measure.unit {
   import flash.utils.getQualifiedClassName;
   
   import measure.converter.AddConverter;
   import measure.converter.ConversionError;
   import measure.converter.MultiplyConverter;
   import measure.converter.RationalConverter;
   import measure.converter.UnitConverter;
   import measure.parse.ParsePosition;
   
   [Abstract]
   
   /**
    * <p>This class represents a determinate quantity
    *    (as of length, time, heat, or value) adopted as a standard of measurement.</p>
    *
    * <p>It is helpful to think of instances of this class as recording the
    *    history by which they are created. Thus, for example, the string
    *    "g/kg" (which is a dimensionless unit) would result from invoking
    *    the method toString() on a unit that was created by dividing a
    *    gram unit by a kilogram unit. Yet, "kg" divided by "kg" returns
    *    <code>ONE</code> and not "kg/kg" due to automatic unit factorization.</p>
    *
    * <p>This class supports the multiplication of offsets units. The result is
    *    usually a unit not convertible to its standard unit.
    *    Such units may appear in derivative quantities. For example °C/m is an 
    *    unit of gradient, which is common in atmospheric and oceanographic
    *    research.</p>
    *
    * <p>Units raised at rational powers are also supported. For example
    *    the cubic root of "liter" is a unit compatible with meter.</p>
    */
   public class Unit {
      /**
       * Holds the dimensionless unit <code>ONE</code>.
       */
      private static var _ONE:Unit;
      
      /**
       * Holds the unique symbols collection (base unit or alternate units).
       */
      public static const SYMBOL_TO_UNIT:Object = new Object();
      
      public function Unit() {
         super();
      }
      
      /**
       * Dimensionless unit <code>ONE</code>.
       */
      public static function get ONE():Unit {
         if (!_ONE) {
            _ONE = new ProductUnit();
         }
         return _ONE;
      }
      
      /**
       * Returns the base unit, alternate unit or product of base units and alternate
       * units this unit is derived from. The standard unit identifies the "type" of
       * quantity for which this unit is employed.
       * For example:<pre>
       *    function isAngularVelocity(u:Unit):Boolean {
       *       return u.standardUnit.equals(RADIAN.divide(SECOND));
       *    }
       *    assert(REVOLUTION.divide(MINUTE).isAngularVelocity());  
       * <pre>
       * <p><i>Note: Having the same system unit is not sufficient to ensure
       *             that a converter exists between the two units
       *             (e.g. °C/m and K/m).</i></p>
       * 
       * @return the system unit this unit is derived from.
       */
      [Abstract]
      public function get standardUnit():Unit {
         return null;
      }
      
      
      /**
       * Returns the converter from this unit to its system unit.
       * 
       * @return <code>this.getConverterTo(this.getSystemUnit())</code>
       */
      [Abstract]
      public function toStandardUnit():UnitConverter {
         return null;
      }
      
      /**
       * Indicates if the specified unit can be considered equals to 
       * the one specified.
       *
       * @param that the object to compare to.
       * @return <code>true</code> if this unit is considered equal to 
       *         that unit; <code>false</code> otherwise.
       */
      [Abstract]
      public function equals(that:Object):Boolean {
         return false;
      }
      
      /**
       * Indicates if this unit is a standard unit (base units and 
       * alternate units are standard units). The standard unit identifies 
       * the "type" of quantity for which the unit is employed.
       */
      public function get isStandardUnit():Boolean {
         return standardUnit.equals(this);
      }
      
      /**
       * Indicates if this unit is compatible with the unit specified.
       * Units don't need to be equals to be compatible. For example:<pre>
       *     RADIAN.equals(ONE) == false
       *     RADIAN.isCompatible(ONE) == true
       * </pre>
       * @param that the other unit.
       * @return <code>this.getDimension().equals(that.getDimension())</code>
       * @see #getDimension()
       */
      final public function isCompatible(that:Unit):Boolean {
         return (this == that) ||
            this.standardUnit.equals(that.standardUnit) ||
            this.dimension.equals(that.dimension);
      }
      
      /**
       * Returns the dimension of this unit (depends upon the current 
       * dimensional model). 
       *
       * @return the dimension of this unit for the current model.
       */
      final public function get dimension():Dimension {
         var systemUnit:Unit = this.standardUnit;
         if (systemUnit is BaseUnit) {
            return Dimension.model.getDimension(systemUnit as BaseUnit);
         }
         if (systemUnit is AlternateUnit) {
            return (systemUnit as AlternateUnit).parent.dimension;
         }
         // Product of units.
         var productUnit:ProductUnit = systemUnit as ProductUnit;
         var dimension:Dimension = Dimension.NONE;
         for (var i:int = 0; i < productUnit.unitCount; i++) {
            var unit:Unit = productUnit.getUnit(i);
            var d:Dimension = unit.dimension
               .pow(productUnit.getUnitPow(i))
               .root(productUnit.getUnitRoot(i));
            dimension = dimension.times(d);
         }
         return dimension;
      }
      
      /**
       * Returns a converter of numeric values from this unit to another unit.
       *
       * @param that the unit to which to convert the numeric values.
       * @return the converter from this unit to <code>that</code> unit.
       * @throws ConversionException if the conveter cannot be constructed
       *         (e.g. <code>!this.isCompatible(that)</code>).
       */
      final public function getConverterTo(that:Unit):UnitConverter {
         if (this.equals(that)) {
            return UnitConverter.IDENTITY;
         }
         var thisStandardUnit:Unit = this.standardUnit;
         var thatStandardUnit:Unit = that.standardUnit;
         if (thisStandardUnit.equals(thatStandardUnit)) {
            return that.toStandardUnit().inverse().concatenate(this.toStandardUnit());
         }
         // Use dimensional transforms.
         if (!thisStandardUnit.dimension.equals(thatStandardUnit.dimension)) {
            throw new ConversionError(this + " is not compatible with " + that);
         }
         // Transform between SystemUnit and BaseUnits is Identity. 
         var thisTransform:UnitConverter = this.toStandardUnit().concatenate(transformOf(this.getBaseUnits()));
         var thatTransform:UnitConverter = that.toStandardUnit().concatenate(transformOf(that.getBaseUnits()));
         return thatTransform.inverse().concatenate(thisTransform);
      }
      
      private function getBaseUnits():Unit {
         var systemUnit:Unit = this.standardUnit;
         if (systemUnit is BaseUnit) {
            return systemUnit;
         }
         if (systemUnit is AlternateUnit) { 
            return (systemUnit as AlternateUnit).parent.getBaseUnits();
         }
         if (systemUnit is ProductUnit) {
            var productUnit:ProductUnit = systemUnit as ProductUnit;
            var baseUnits:Unit = ONE;
            for (var i:int = 0; i < productUnit.unitCount; i++) {
               var unit:Unit = productUnit.getUnit(i).getBaseUnits();
               unit = unit.pow(productUnit.getUnitPow(i));
               unit = unit.root(productUnit.getUnitRoot(i));
               baseUnits = baseUnits.times(unit);
            }
            return baseUnits;
         }
         else {
            throw new Error("System Unit cannot be an instance of " + getQualifiedClassName(this));            
         }
      }
      
      private static function transformOf(baseUnits:Unit):UnitConverter {
         if (baseUnits is BaseUnit) {
            return Dimension.model.getTransform(baseUnits as BaseUnit);
         }
         // Product of units.
         var productUnit:ProductUnit = baseUnits as ProductUnit;
         var converter:UnitConverter = UnitConverter.IDENTITY;
         for (var i:int = 0; i < productUnit.unitCount; i++) {
            var unit:Unit = productUnit.getUnit(i);
            var cvtr:UnitConverter = transformOf(unit);
            if (!cvtr.isLinear) {
               throw new ConversionError(baseUnits + " is non-linear, cannot convert");
            }
            if (productUnit.getUnitRoot(i) != 1) {
               throw new ConversionError(productUnit + " holds a base unit with fractional exponent");
            }
            var pow:int = productUnit.getUnitPow(i);
            if (pow < 0) { // Negative power.
               pow = -pow;
               cvtr = cvtr.inverse();
            }
            for (var j:int = 0; j < pow; j++) {
               converter = converter.concatenate(cvtr);
            }
         }
         return converter;
      }
      
      /**
       * Returns a unit equivalent to this unit but used in expressions to 
       * distinguish between quantities of a different nature but of the same
       * dimensions.
       *     
       * <p>Examples of alternate units:<pre>
       *    Unit<Angle> RADIAN = ONE.alternate("rad");
       *    Unit<Force> NEWTON = METER.times(KILOGRAM).divide(SECOND.pow(2)).alternate("N");
       *    Unit<Pressure> PASCAL = NEWTON.divide(METER.pow(2)).alternate("Pa");
       *    </pre></p>
       *
       * @param symbol the new symbol for the alternate unit.
       * @return the alternate unit.
       * @throws UnsupportedOperationException if this unit is not a standard unit.
       * @throws IllegalArgumentException if the specified symbol is already 
       *         associated to a different unit.
       */
      final public function alternate(symbol:String):AlternateUnit {
         return new AlternateUnit(symbol, this);
      }
      
      /**
       * Returns the combination of this unit with the specified sub-unit.
       * Compound units are typically used for formatting purpose. 
       * Examples of compound units:<pre>
       *   HOUR_MINUTE = NonSI.HOUR.compound(NonSI.MINUTE);
       *   DEGREE_MINUTE_SECOND_ANGLE = NonSI.DEGREE_ANGLE.compound(
       *       NonSI.DEGREE_MINUTE).compound(NonSI.SECOND_ANGLE);
       *  </pre>
       *
       * @param subUnit the sub-unit to combine with this unit.
       * @return the corresponding compound unit.
       */
      final public function compound(subUnit:Unit):CompoundUnit {
         return new CompoundUnit(this, subUnit);
      }
      
      /**
       * Returns the unit derived from this unit using the specified converter.
       * The converter does not need to be linear. For example:<pre>
       * var DECIBEL:Unit = Unit.ONE.transform(
       *     new LogConverter(10).inverse().concatenate(
       *           new RationalConverter(1, 10)));</pre>
       *
       * @param operation the converter from the transformed unit to this unit.
       * @return the unit after the specified transformation.
       */
      final public function transform(operation:UnitConverter):Unit {
         if (this is TransformedUnit) {
            var tf:TransformedUnit = this as TransformedUnit;
            var parent:Unit = tf.parentUnit;
            var toParent:UnitConverter = tf.toParentUnit().concatenate(operation);
            if (toParent == UnitConverter.IDENTITY) {
               return parent;
            }
            return new TransformedUnit(parent, toParent);
         }
         if (operation == UnitConverter.IDENTITY) {
            return this;
         }
         return new TransformedUnit(this, operation);
      }
      
      /**
       * Returns the result of adding an offset to this unit. The returned unit
       * is convertible with all units that are convertible with this unit.
       *
       * @param  offset the offset added (expressed in this unit,
       *         e.g. <code>CELSIUS = KELVIN.plus(273.15)</code>).
       * @return <code>this.transform(new AddConverter(offset))</code>
       */
      final public function plus(offset:Number):Unit {
         return transform(new AddConverter(offset));
      }
      
      /**
       * <p>If value is <code>Unit</code> then times returns the product of this unit with the one specified.</p>
       * <pre>this * value</pre></p>
       * <p>If value is a integer then times result of multiplying this unit by an exact factor (value).
       * <pre>this.transform(new RationalConverter(factor, 1))</pre></p>
       * <p>Otherwise, times result of multiplying this unit by a an approximate factor (value).
       * <pre>this.transform(new MultiplyConverter(factor))</pre></p>
       *
       * @param value <code>Unit</code> or divisor.
       */
      final public function times(value:*):Unit {
         if (value is Unit) {
            return ProductUnit.getProductInstance(this, value as Unit);
         }
         else if (Number(value) % 1 == 0) {
            return transform(new RationalConverter(Number(value), 1));
         }
         return transform(new MultiplyConverter(Number(value)));
      }
      
      /**
       * Returns the inverse of this unit.
       *
       * @return <code>1 / this</code>
       */
      final public function inverse():Unit {
         return ProductUnit.getQuotientInstance(ONE, this);
      }
      
      /**
       * <p>If value is <code>Unit</code> then divide returns the quotient of this unit with the one specified.</p>
       * <pre>this / value</pre></p>
       * <p>If value is a integer then divide returns the dividing of this unit by an exact divisor (value).
       * <pre>this.transform(new RationalConverter(1 , divisor))</pre></p>
       * <p>Otherwise, divide returns the dividing of this unit by an approximate divisor (value).
       * <pre>this.transform(new MultiplyConverter(1.0 / divisor)</pre></p>
       *
       * @param value <code>Unit</code> or divisor.
       */
      final public function divide(value:*):Unit {
         if (value is Unit) {
            return this.times((value as Unit).inverse());
         }
         else if (Number(value) % 1 == 0) {
            return transform(new RationalConverter(1, Number(value)));
         }
         return transform(new MultiplyConverter(1.0 / Number(value)));
      }
      
      /**
       * Returns a unit equals to the given root of this unit.
       *
       * @param  n the root's order.
       * @return the result of taking the given root of this unit.
       * @throws ArithmeticException if <code>n == 0</code>.
       */
      final public function root(n:int):Unit {
         if (n > 0) {
            return ProductUnit.getRootInstance(this, n);
         }
         else if (n == 0) {
            throw new ArgumentError("Root's order of zero");
         }
         else { // n < 0
            return ONE.divide(this.root(-n));
         }
      }
      
      /**
       * Returns a unit equals to this unit raised to an exponent.
       *
       * @param  n the exponent.
       * @return the result of raising this unit to the exponent.
       */
      final public function pow(n:int):Unit {
         if (n > 0) {
            return this.times(this.pow(n - 1));
         }
         else if (n == 0) {
            return ONE;
         }
         else { // n < 0
            return ONE.divide(this.pow(-n));
         }
      }
      
      /**
       * Returns a unit instance that is defined from the specified
       * character sequence using standard unit format.
       * <p>Examples of valid entries (all for meters per second squared) are:
       *    <code><ul>
       *      <li>m*s-2</li>
       *      <li>m/s²</li>
       *      <li>m·s-²</li>
       *      <li>m*s**-2</li>
       *      <li>m^+1 s^-2</li>
       *    </ul></code></p>
       *
       * @param unit Character sequence to parse.
       * @throws Error if the specified character sequence cannot be correctly parsed (e.g. symbol unknown).
       */
      public static function valueOf(unit:String):Unit {
         var ret:Unit;
         try {
            ret = UnitFormat.getInstance().parseProductUnit(unit, new ParsePosition(0));
         }
         catch (e:Error) {
            throw new ArgumentError(e.message);
         }
         return ret;
      }

      /**
       * Returns the standard <code>String</code> representation of this unit.
       * This representation is not affected by locale.
       */
      final public function toString():String {
         return UnitFormat.getInstance().format(this).toString();
      }
   }
}
