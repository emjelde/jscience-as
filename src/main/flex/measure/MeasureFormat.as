/*
 * JScience - Java(TM) Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2007 - JScience (http://jscience.org/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package measure {
   import measure.parse.FieldPosition;
   import measure.parse.ParsePosition;
   import measure.unit.CompoundUnit;
   import measure.unit.Unit;
   import measure.unit.UnitFormat;
   import measure.unit.CompoundUnit;
   import measure.unit.Unit;

   /**
    * <p>This class provides the interface for formatting and parsing measures.</p>
    *     
    * <p>As a minimum, instances of this class should be able to parse/format
    *    measure using <code>CompoundUnit</code>.</p>  
    */
   public class MeasureFormat {
      private static const DEFAULT:MeasureFormat = new MeasureFormat(new NumberFormatImpl(), UnitFormat.getInstance());

      private var _numberFormat:NumberFormat;
      private var _unitFormat:UnitFormat;

      public function MeasureFormat(numberFormat:NumberFormat=null, unitFormat:UnitFormat=null) {
         super();
         _numberFormat = numberFormat;
         _unitFormat = unitFormat;
      }

      /**
       * Returns the measure format using the specified number format and 
       * unit format (the number and unit are separated by a space).
       * Otherwise, returns the measure format for the default locale.
       * 
       * @param numberFormat the number format.
       * @param unitFormat the unit format.
       * @return the corresponding format.
       */
      public static function getInstance(numberFormat:NumberFormat=null, unitFormat:UnitFormat=null):MeasureFormat {
         if (numberFormat && unitFormat) {
            var measureFormat:MeasureFormat = new MeasureFormat(numberFormat, unitFormat);
         }
         return DEFAULT;
      }

      public function format(obj:Measure, toAppendTo:String, pos:FieldPosition):String {
         var value:Number = obj.getValue();
         var unit:Unit = obj.getUnit();
         if (unit is CompoundUnit) {
            return formatCompound(value, unit as CompoundUnit, toAppendTo, pos);
         }

         toAppendTo += _numberFormat.format(value);

         if (!obj.getUnit().equals(Unit.ONE)) {
            toAppendTo = toAppendTo.concat(' ');
            _unitFormat.format(unit, toAppendTo/*, pos*/);
         }
         return toAppendTo;
      }

      // Measure using Compound unit have no separators in their representation.
      internal function formatCompound(value:Number, unit:Unit, toAppendTo:String, pos:FieldPosition):String {
         if (!(unit is CompoundUnit)) {
            toAppendTo = toAppendTo.concat(value);
            return _unitFormat.format(unit, toAppendTo/*, pos*/);
         }
         var high:Unit = (unit as CompoundUnit).higher;
         var low:Unit = (unit as CompoundUnit).lower; // The unit in which the value is stated.
         var highValue:Number = low.getConverterTo(high).convert(value);
         var lowValue:Number = value - high.getConverterTo(low).convert(highValue);
         formatCompound(highValue, high, toAppendTo, pos);
         formatCompound(lowValue, low, toAppendTo, pos);
         return toAppendTo;
      }

      public function parseObject(source:String, pos:ParsePosition):Object {
         var start:int = pos.getIndex();
// TODO: See below
//      try {
            var i:int = start;
            var value:Number = _numberFormat.parse(source, pos);
            if (i == pos.getIndex()) {
               return null; // Cannot parse.
            }
            i = pos.getIndex();
            if (i >= source.length) {
               return measureOf(value, Unit.ONE); // No unit.
            }
            var isCompound:Boolean = !isWhitespace(source.charAt(i));
            if (isCompound) {
               return parseCompound(value, source, pos);
            }
            if (++i >= source.length) {
               return measureOf(value, Unit.ONE); // No unit.
            }
            pos.setIndex(i); // Skips separator.
            var unit:Unit = _unitFormat.parseProductUnit(source, pos);
            return measureOf(value, unit);
// TODO: Handle error
//      }
//      catch (ParseException e) {
//         pos.setIndex(start);
//         pos.setErrorIndex(e.getErrorOffset());
//         return null;
//      }
      }

      private function parseCompound(highValue:Number, source:String, pos:ParsePosition):Object {
         var high:Unit = _unitFormat.parseSingleUnit(source, pos);
         var i:int = pos.getIndex();
         if (i >= source.length || isWhitespace(source.charAt(i))) {
            return measureOf(highValue, high);
         }
         var lowMeasure:Measure = parseObject(source, pos) as Measure;
         var unit:Unit = lowMeasure.getUnit();
         var l:Number = lowMeasure.value(unit) + high.getConverterTo(unit).convert(highValue);
         return Measure.valueOf(l, unit);
      }

      private static function measureOf(value:Number, unit:Unit):Measure {
         return Measure.valueOf(value, unit);
      }

      private function isWhitespace(value:String):Boolean {
         return value == " ";
      }
   }
}

import flash.globalization.NumberFormatter;
import flash.globalization.LocaleID;

import measure.NumberFormat;
import measure.parse.ParsePosition;

final class NumberFormatImpl implements NumberFormat {
   private var _delegate:NumberFormatter = new NumberFormatter(LocaleID.DEFAULT);

   public function NumberFormatImpl() {
      super();
   }

   public function format(value:*):String {
      return _delegate.formatNumber(Number(value));
   }

   public function parse(source:String, pos:ParsePosition=null):Number {
      return _delegate.parseNumber(source);
   }
}
