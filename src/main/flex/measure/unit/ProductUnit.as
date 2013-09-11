/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package measure.unit {
   import measure.converter.ConversionError;
   import measure.converter.UnitConverter;
   
   /**
    * <p>This class represents units formed by the product of rational powers of
    *    existing units.</p>
    *     
    * <p>This class maintains the canonical form of this product (simplest
    *    form after factorization). For example:
    *    <code>METER.pow(2).divide(METER)</code> returns
    *    <code>METER</code>.</p>
    */
   final public class ProductUnit extends DerivedUnit {
      /**
       * Holds the units composing this product unit.
       */
      private var _elements:Vector.<Element>;
      
      public function ProductUnit(value:*=null) {
         super();
         if (value is ProductUnit) {
            _elements = (value as ProductUnit)._elements;
         }
         else if (value is Vector.<Element>) {
            _elements = (value as Vector.<Element>);
         }
         else {
            _elements = new Vector.<Element>();
         }
      }
      
      /**
       * Returns the unit defined from the product of the specifed elements.
       *
       * @param  leftElems left multiplicand elements.
       * @param  rightElems right multiplicand elements.
       * @return the corresponding unit.
       */
      private static function getInstance(leftElems:Vector.<Element>, rightElems:Vector.<Element>):Unit {
         // Merges left elements with right elements.
         var result:Vector.<Element> = Vector.<Element>(new Array(leftElems.length + rightElems.length));
         var resultIndex:int = 0;
         var i:int, j:int, unit:Unit;
         for (i = 0; i < leftElems.length; i++) {
            unit = leftElems[i].unit;
            var p1:int = leftElems[i].pow;
            var r1:int = leftElems[i].root;
            var p2:int = 0;
            var r2:int = 1;
            for (j = 0; j < rightElems.length; j++) {
               if (unit.equals(rightElems[j].unit)) {
                  p2 = rightElems[j].pow;
                  r2 = rightElems[j].root;
                  break; // No duplicate.
               }
            }
            var pow:int = (p1 * r2) + (p2 * r1);
            var root:int = r1 * r2;
            if (pow != 0) {
               var gcd:int = gcd(Math.abs(pow), root);
               result[resultIndex++] = new Element(unit, pow / gcd, root / gcd);
            }
         }
         
         // Appends remaining right elements not merged.
         for (i = 0; i < rightElems.length; i++) {
            unit = rightElems[i].unit;
            var hasBeenMerged:Boolean = false;
            for (j = 0; j < leftElems.length; j++) {
               if (unit.equals(leftElems[j].unit)) {
                  hasBeenMerged = true;
                  break;
               }
            }
            if (!hasBeenMerged) {
               result[resultIndex++] = rightElems[i];
            }
         }
         
         // Returns or creates instance.
         if (resultIndex == 0) {
            return ONE;
         }
         else if ((resultIndex == 1) && (result[0].pow == result[0].root)) {
            return result[0].unit;
         }
         else {
            var elems:Vector.<Element> = Vector.<Element>(new Array(resultIndex));
            for (i = 0; i < resultIndex; i++) {
               elems[i] = result[i];
            }
            return new ProductUnit(elems);
         }
      }
      
      /**
       * Returns the product of the specified units.
       *
       * @param  left the left unit operand.
       * @param  right the right unit operand.
       * @return <code>left * right</code>
       */
      internal static function getProductInstance(left:Unit, right:Unit):Unit {
         var leftElems:Vector.<Element>;
         if (left is ProductUnit) {
            leftElems = (left as ProductUnit)._elements;
         }
         else {
            leftElems = Vector.<Element>(new Array(new Element(left, 1, 1)));
         }
         
         var rightElems:Vector.<Element>;
         if (right is ProductUnit) {
            rightElems = (right as ProductUnit)._elements;
         }
         else {
            rightElems = Vector.<Element>(new Array(new Element(right, 1, 1)));
         }
         
         return getInstance(leftElems, rightElems);
      }
      
      /**
       * Returns the quotient of the specified units.
       *
       * @param  left the dividend unit operand.
       * @param  right the divisor unit operand.
       * @return <code>dividend / divisor</code>
       */
      internal static function getQuotientInstance(left:Unit, right:Unit):Unit {
         var leftElems:Vector.<Element>;
         if (left is ProductUnit) {
            leftElems = (left as ProductUnit)._elements;
         }
         else {
            leftElems = Vector.<Element>(new Array(new Element(left, 1, 1)));
         }
         
         var rightElems:Vector.<Element>;
         if (right is ProductUnit) {
            var elems:Vector.<Element> = (right as ProductUnit)._elements;
            rightElems = Vector.<Element>(new Array(elems.length));
            for (var i:int = 0; i < elems.length; i++) {
               rightElems[i] = new Element(elems[i].unit, -elems[i].pow, elems[i].root);
            }
         }
         else {
            rightElems = Vector.<Element>(new Array(new Element(right, -1, 1)));
         }
         return getInstance(leftElems, rightElems);
      }
      
      /**
       * Returns the product unit corresponding to the specified root of
       * the specified unit.
       *
       * @param  unit the unit.
       * @param  n the root's order (n &gt; 0).
       * @return <code>unit^(1/nn)</code>
       * @throws ArithmeticException if <code>n == 0</code>.
       */
      internal static function getRootInstance(unit:Unit, n:int):Unit {
         var unitElems:Vector.<Element>;
         if (unit is ProductUnit) {
            var elems:Vector.<Element> = (unit as ProductUnit)._elements;
            unitElems = Vector.<Element>(new Array(elems.length));
            for (var i:int = 0; i < elems.length; i++) {
               var gcd:int = gcd(Math.abs(elems[i].pow), elems[i].root * n);
               unitElems[i] = new Element(elems[i].unit, elems[i].pow / gcd, elems[i].root * n / gcd);
            }
         }
         else {
            unitElems = Vector.<Element>(new Array(new Element(unit, 1, n)));
         }
         return getInstance(unitElems, new Vector.<Element>());
      }
      
      /**
       * Returns the product unit corresponding to this unit raised to
       * the specified exponent.
       *
       * @param  unit the unit.
       * @param  nn the exponent (nn &gt; 0).
       * @return <code>unit^n</code>
       */
      internal static function getPowInstance(unit:Unit, n:int):Unit {
         var unitElems:Vector.<Element>;
         if (unit is ProductUnit) {
            var elems:Vector.<Element> = (unit as ProductUnit)._elements;
            unitElems = Vector.<Element>(new Array(elems.length));
            for (var i:int = 0; i < elems.length; i++) {
               var gcd:int = gcd(Math.abs(elems[i].pow * n), elems[i].root);
               unitElems[i] = new Element(elems[i].unit, elems[i].pow * n / gcd, elems[i].root / gcd);
            }
         }
         else {
            unitElems = Vector.<Element>(new Array(new Element(unit, n, 1)));
         }
         return getInstance(unitElems, new Vector.<Element>());
      }
      
      /**
       * Returns the number of units in this product.
       *
       * @return  the number of units being multiplied.
       */
      public function get unitCount():int {
         return _elements.length;
      }
      
      /**
       * Returns the unit at the specified position.
       *
       * @param  index the index of the unit to return.
       * @return the unit at the specified position.
       */
      public function getUnit(index:int):Unit {
         return _elements[index].unit;
      }
      
      /**
       * Returns the power exponent of the unit at the specified position.
       *
       * @param  index the index of the unit to return.
       * @return the unit power exponent at the specified position.
       */
      public function getUnitPow(index:int):int {
         return _elements[index].pow;
      }
      
      /**
       * Returns the root exponent of the unit at the specified position.
       *
       * @param  index the index of the unit to return.
       * @return the unit root exponent at the specified position.
       */
      public function getUnitRoot(index:int):int {
         return _elements[index].root;
      }
      
      /**
       * Indicates if this product unit is considered equals to the specified 
       * object.
       *
       * @param  that the object to compare for equality.
       * @return <code>true</code> if <code>this</code> and <code>that</code>
       *         are considered equals; <code>false</code>otherwise. 
       */
      override public function equals(that:Object):Boolean {
         if (this == that) {
            return true;
         }
         if (that is ProductUnit) {
            // Two products are equals if they have the same elements
            // regardless of the elements' order.
            var elems:Vector.<Element> = (that as ProductUnit)._elements;
            if (_elements.length == elems.length) {
               for (var i:int = 0; i < _elements.length; i++) {
                  var unitFound:Boolean = false;
                  for (var j:int = 0; j < elems.length; j++) {
                     if (_elements[i].unit.equals(elems[j].unit)) {
                        if ((_elements[i].pow != elems[j].pow) ||
                            (_elements[i].root != elems[j].root)) {
                           return false;
                        }
                        else {
                           unitFound = true;
                           break;
                        }
                     }
                  }
                  if (!unitFound) {
                     return false;
                  }
               }
               return true;
            }
         }
         return false;
      }
      
      override public function get standardUnit():Unit {
         if (hasOnlyStandardUnit) {
            return this;
         }
         var systemUnit:Unit = ONE;
         for (var i:int = 0; i < _elements.length; i++) {
            var unit:Unit = _elements[i].unit.standardUnit;
            unit = unit.pow(_elements[i].pow);
            unit = unit.root(_elements[i].root);
            systemUnit = systemUnit.times(unit);
         }
         return systemUnit;
      }
      
      override public function toStandardUnit():UnitConverter {
         if (hasOnlyStandardUnit) {
            return UnitConverter.IDENTITY;
         }
         var converter:UnitConverter = UnitConverter.IDENTITY;
         for (var i:int = 0; i < _elements.length; i++) {
            var cvtr:UnitConverter = _elements[i].unit.toStandardUnit();
            if (!cvtr.isLinear) {
               throw new ConversionError(_elements[i].unit + " is non-linear, cannot convert");
            }
            if (_elements[i].root != 1) {
               throw new ConversionError(_elements[i].unit + " holds a base unit with fractional exponent");
            }
            var pow:int = _elements[i].pow;
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
       * Indicates if this product unit is a standard unit.
       *
       * @return <code>true</code> if all elements are standard units;
       *         <code>false</code> otherwise.
       */
      private function get hasOnlyStandardUnit():Boolean {
         for (var i:int = 0; i < _elements.length; i++) {
            var u:Unit = _elements[i].unit;
            if (!u.isStandardUnit)
               return false;
         }
         return true;
      }
      
      /**
       * Returns the greatest common divisor (Euclid's algorithm).
       *
       * @param  m the first number.
       * @param  nn the second number.
       * @return the greatest common divisor.
       */
      private static function gcd(m:int, n:int):int {
         if (n == 0) {
            return m;
         } else {
            return gcd(n, m % n);
         }
      }
   }
}

import measure.unit.Unit;

/**
 * Inner product element represents a rational power of a single unit.
 */
final class Element {
   /**
    * Holds the single unit.
    */
   private var _unit:Unit;
   
   /**
    * Holds the power exponent.
    */
   private var _pow:int;
   
   /**
    * Holds the root exponent.
    */
   private var _root:int;
   
   /**
    * Structural constructor.
    *
    * @param  unit the unit.
    * @param  pow the power exponent.
    * @param  root the root exponent.
    */
   public function Element(unit:Unit, pow:int, root:int) {
      super();
      _unit = unit;
      _pow = pow;
      _root = root;
   }
   
   /**
    * Returns this element's unit.
    *
    * @return the single unit.
    */
   public function get unit():Unit {
      return _unit;
   }
   
   /**
    * Returns the power exponent. The power exponent can be negative
    * but is always different from zero.
    *
    * @return the power exponent of the single unit.
    */
   public function get pow():int {
      return _pow;
   }
   
   /**
    * Returns the root exponent. The root exponent is always greater
    * than zero.
    *
    * @return the root exponent of the single unit.
    */
   public function get root():int {
      return _root;
   }
}
