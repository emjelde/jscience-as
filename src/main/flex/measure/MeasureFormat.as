/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package measure {
   import measure.parse.FieldPosition;
   import measure.parse.ParsePosition;
   import measure.unit.Unit;
   import measure.unit.UnitFormat;
   
   [Abstract]

   /**
    * <p>This class provides the interface for formatting and parsing measures.</p>
    *     
    * <p>As a minimum, instances of this class should be able to parse/format
    *    measure using <code>CompoundUnit</code>.</p>  
    */
   public class MeasureFormat {
      private static var DEFAULT:MeasureFormat;
      
      public function MeasureFormat() {
         super();
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
      public static function getInstance(numberFormat:INumberFormat=null, unitFormat:UnitFormat=null):MeasureFormat {
         if (numberFormat && unitFormat) {
            var measureFormat:MeasureFormat = new NumberUnit(numberFormat, unitFormat);
         }
         if (!DEFAULT) {
            DEFAULT = new NumberUnit(new NumberFormatImpl(), UnitFormat.getInstance());
         }
         return DEFAULT;
      }

      [Abstract]
      public function format(obj:Measure, toAppendTo:String=null, pos:FieldPosition=null):String {
         return null;
      }

      /**
       * @private
       */
      [Abstract]
      public function formatCompound(value:Number, unit:Unit, toAppendTo:String=null, pos:FieldPosition=null):String {
         return null;
      }

      [Abstract]
      public function parseObject(source:String, pos:ParsePosition=null):Object {
         return null;
      }
   }
}

import flash.globalization.LocaleID;
import flash.globalization.NumberFormatter;

import measure.Measure;
import measure.MeasureFormat;
import measure.INumberFormat;
import measure.parse.Appendable;
import measure.parse.FieldPosition;
import measure.parse.ParsePosition;
import measure.unit.CompoundUnit;
import measure.unit.Unit;
import measure.unit.UnitFormat;

final class NumberUnit extends MeasureFormat {
   private var _numberFormat:INumberFormat;
   private var _unitFormat:UnitFormat;
   
   public function NumberUnit(numberFormat:INumberFormat=null, unitFormat:UnitFormat=null) {
      super();
      _numberFormat = numberFormat;
      _unitFormat = unitFormat;
   }
   
   override public function format(obj:Measure, toAppendTo:String=null, pos:FieldPosition=null):String {
      if (toAppendTo == null) {
         toAppendTo = "";
      }
      if (pos == null) {
         pos = new FieldPosition();
      }
      var value:Number = obj.getValue();
      var unit:Unit = obj.getUnit();
      if (unit is CompoundUnit) {
         return formatCompound(value, unit as CompoundUnit, toAppendTo, pos);
      }
      
      toAppendTo += _numberFormat.format(value);
      
      if (!obj.getUnit().equals(Unit.ONE)) {
         toAppendTo = toAppendTo.concat(' ');

         var appendable:Appendable = new Appendable()
            .append(toAppendTo, pos.getBeginIndex(), pos.getEndIndex()); 

         toAppendTo = _unitFormat.format(unit, appendable).toString();
      }
      return toAppendTo;
   }
   
   // Measure using Compound unit have no separators in their representation.
   override public function formatCompound(value:Number, unit:Unit, toAppendTo:String=null, pos:FieldPosition=null):String {
      if (toAppendTo == null) {
         toAppendTo = "";
      }
      if (pos == null) {
         pos = new FieldPosition();
      }
      if (!(unit is CompoundUnit)) {
         toAppendTo = toAppendTo.concat(value);

         var appendable:Appendable = new Appendable()
            .append(toAppendTo, pos.getBeginIndex(), pos.getEndIndex());

         return _unitFormat.format(unit, appendable).toString();
      }
      var high:Unit = (unit as CompoundUnit).higher;
      var low:Unit = (unit as CompoundUnit).lower; // The unit in which the value is stated.
      var highValue:Number = low.getConverterTo(high).convert(value);
      var lowValue:Number = value - high.getConverterTo(low).convert(highValue);
      formatCompound(highValue, high, toAppendTo, pos);
      formatCompound(lowValue, low, toAppendTo, pos);
      return toAppendTo;
   }
   
   override public function parseObject(source:String, pos:ParsePosition=null):Object {
      if (pos == null) {
         pos = new ParsePosition(0);
      }
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
      var l:Number = lowMeasure.getValue(unit) + high.getConverterTo(unit).convert(highValue);
      return Measure.valueOf(l, unit);
   }
   
   private static function measureOf(value:Number, unit:Unit):Measure {
      return Measure.valueOf(value, unit);
   }
   
   private function isWhitespace(value:String):Boolean {
      return value == " ";
   }
}

final class NumberFormatImpl implements INumberFormat {
   private var _delegate:NumberFormatter = new NumberFormatter(LocaleID.DEFAULT);

   public function NumberFormatImpl() {
      super();
   }

   public function format(value:*):String {
      return _delegate.formatNumber(Number(value));
   }

   public function parse(source:String, pos:ParsePosition=null):Number {
      var number:Number = parseFloat(source);
      // TODO: FIXME this may be a bad way to get string length of number
      pos.setIndex(pos.getIndex() + String(number).length);
      return number;
   }
}
