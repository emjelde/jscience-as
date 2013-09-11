/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package measure.unit {
   import measure.converter.AddConverter;
   import measure.converter.MultiplyConverter;
   import measure.converter.RationalConverter;
   import measure.converter.UnitConverter;
   import measure.parse.Appendable;
   import measure.parse.ParsePosition;

   [Abstract]

   /**
    * <p>This class provides the interface for formatting and parsing units</p>
    *  
    * <p>For all SI units, the 20 SI prefixes used to form decimal
    *  multiples and sub-multiples of SI units are recognized.
    *  Non SI units are directly recognized. For example:<code>
    *    Unit.valueOf("m°C").equals(SI.MILLI(SI.CELSIUS))
    *    Unit.valueOf("kW").equals(SI.KILO(SI.WATT))
    *    Unit.valueOf("ft").equals(SI.METER.times(0.3048))</code></p>
    */
   public class UnitFormat {
      /**
       * Holds the standard unit format.
       */
      private static var _DEFAULT:DefaultFormat;
      
      protected static function get DEFAULT():DefaultFormat {
         if (!_DEFAULT) {
            _DEFAULT = new DefaultFormat();
            _DEFAULT.init();
         }
         return _DEFAULT;
      }

      /**
       * Holds the ASCIIFormat unit format.
       */
      private static var _ASCII:ASCIIFormat;
      
      private static function get ASCII():ASCIIFormat {
         if (!_ASCII) {
            _ASCII = new ASCIIFormat();
            _ASCII.init();
         }
         return _ASCII;
      }

      /**
       * Returns the unit format.
       *
       * @return the default unit format (locale sensitive).
       */
      public static function getInstance(inLocale:*=null):UnitFormat {
         return DEFAULT;
      }

      /**
       * Returns the <a href="http://aurora.regenstrief.org/UCUM/ucum.html">UCUM
       * </a> international unit format; this format uses characters range
       * <code>0000-007F</code> exclusively and <b>is not</b> locale-sensitive.
       * For example: <code>kg.m/s2</code>
       * 
       * @return the UCUM international format.
       */
      public static function getUCUMInstance():UnitFormat {
         return UnitFormat.ASCII; // TBD - Provide UCUM implementation.
      }

      /**
       * Base constructor.
       */
      public function UnitFormat() {
      }

      /**
       * Formats the specified unit.
       *
       * @param unit the unit to format.
       * @param appendable the appendable destination.
       */
      [Abstract]
      public function format(unit:Unit, appendable:Appendable=null):Appendable {
         return appendable;
      }

      /**
       * Parses a sequence of characters to produce a unit or a rational product
       * of unit. 
       *
       * @param value the <code>String</code> to parse.
       * @param pos an object holding the parsing index and error position.
       * @return an <code>Unit</code> parsed from the character sequence.
       * @throws Error if the string contains illegal syntax.
       */
      [Abstract]
      public function parseProductUnit(value:String, pos:ParsePosition):Unit {
         return null;
      }

      /**
       * Parses a sequence of characters to produce a single unit. 
       *
       * @param value the <code>String</code> to parse.
       * @param pos an object holding the parsing index and error position.
       * @return an <code>Unit</code> parsed from the character sequence.
       * @throws Error if the character sequence does not contain a valid unit identifier.
       */
      [Abstract]
      public function parseSingleUnit(value:String, pos:ParsePosition):Unit {
         return null;
      }

      /**
       * Attaches a system-wide label to the specified unit. For example:
       * <code>
       *   UnitFormat.getInstance().label(DAY.multiply(365), "year");
       *   UnitFormat.getInstance().label(METER.multiply(0.3048), "ft");
       * </code>
       *
       * <p>If the specified label is already associated to an unit the previous 
       *   association is discarded or ignored.</p>
       * 
       * @param unit the unit being labelled. 
       * @param label the new label for this unit.
       * @throws Error if the label is not a <code>isValidIdentifier(String)</code>
       valid identifier.
       */
      [Abstract]
      public function label(unit:Unit, label:String):void {
      }

      /**
       * Attaches a system-wide alias to this unit. Multiple aliases may
       * be attached to the same unit. Aliases are used during parsing to
       * recognize different variants of the same unit. For example:
       * <code>
       *   UnitFormat.getInstance().alias(METER.multiply(0.3048), "foot");
       *   UnitFormat.getInstance().alias(METER.multiply(0.3048), "feet");
       *   UnitFormat.getInstance().alias(METER, "meter");
       *   UnitFormat.getInstance().alias(METER, "metre");
       * </code>
       *
       * <p>If the specified label is already associated to an unit the previous 
       *   association is discarded or ignored.</p>
       *
       * @param unit the unit being aliased.
       * @param alias the alias attached to this unit.
       * @throws ArgumentError if the label is not a <code>isValidIdentifier(String)</code>
       *      valid identifier.
       */
      [Abstract]
      public function alias(unit:Unit, alias:String):void {
      }

      /**
       * Indicates if the specified name can be used as unit identifier.
       *
       * @param name the identifier to be tested.
       * @return <code>true</code> if the name specified can be used as 
       *      label or alias for this format;<code>false</code> otherwise.
       */
      [Abstract]
      public function isValidIdentifier(name:String):Boolean {
         return false;
      }

      /**
       * Parses the text from a string to produce an object.
       * 
       * @param source the string source, part of which should be parsed.
       * @param pos the cursor position.
       * @return the corresponding unit or <code>null</code> if the string 
       *      cannot be parsed.
       */
      final public function parseObject(source:String, pos:ParsePosition):Unit {
         var start:int = pos.getIndex();
         try {
            return parseProductUnit(source, pos);
         }
         catch (e:Error) {
            pos.setIndex(start);
// TODO: Event for error offset
//            pos.setErrorIndex(e.getErrorOffset());
         }
         return null;
      }

      ////////////////////////////////////////////////////////
      // Initializes the standard unit database for SI units.

      private static const SI_UNITS:Array = [
         SI.AMPERE, SI.BECQUEREL, SI.CANDELA, SI.COULOMB, SI.FARAD, SI.GRAY, SI.HENRY,
         SI.HERTZ, SI.JOULE, SI.KATAL, SI.KELVIN, SI.LUMEN, SI.LUX,
         SI.METRE, SI.MOLE, SI.NEWTON, SI.OHM, SI.PASCAL, SI.RADIAN,
         SI.SECOND, SI.SIEMENS, SI.SIEVERT, SI.STERADIAN, SI.TESLA, SI.VOLT,
         SI.WATT, SI.WEBER
      ];

      private static const PREFIXES:Array = [
         "Y", "Z", "E", "P", "T", "G", "M", "k", "h",
         "da", "d", "c", "m", "µ", "n", "p", "f", "a", "z", "y"
      ];

      private static const CONVERTERS:Array = [
         SI.E24, SI.E21, SI.E18, SI.E15, SI.E12, SI.E9, SI.E6, SI.E3, SI.E2, SI.E1, SI.Em1,
         SI.Em2, SI.Em3, SI.Em6, SI.Em9, SI.Em12, SI.Em15, SI.Em18, SI.Em21, SI.Em24
      ];

      private static function asciiPrefix(prefix:String):String {
         return prefix == "µ" ? "micro" : prefix;
      }

      protected function init():void {
         var i:int;
         var j:int;
         var u:Unit;
         var si:Unit;

         for (i = 0; i < SI_UNITS.length; i++) {
            for (j = 0; j < PREFIXES.length; j++) {
               si = SI_UNITS[i];
               u = si.transform(CONVERTERS[j]);
               var symbol:String = (si is BaseUnit) ?
                  (si as BaseUnit).symbol : (si as AlternateUnit).symbol;
               DEFAULT.label(u, PREFIXES[j] + symbol);
               if (PREFIXES[j] == "µ") {
                  ASCII.label(u, "micro" + symbol);
               }
            }
         }
         // Special case for KILOGRAM.
         DEFAULT.label(SI.GRAM, "g");
         for (i = 0; i < PREFIXES.length; i++) {
            if (CONVERTERS[i] == SI.E3) continue;  // kg is already defined.
            DEFAULT.label(SI.KILOGRAM.transform(CONVERTERS[i].concatenate(SI.Em3)), PREFIXES[i] + "g");
            if (PREFIXES[i] == "µ") {
               ASCII.label(SI.KILOGRAM.transform(CONVERTERS[i].concatenate(SI.Em3)), "microg");
            }
         }

         // Alias and ASCIIFormat for Ohm
         DEFAULT.alias(SI.OHM, "Ohm");
         ASCII.label(SI.OHM, "Ohm");
         for (i = 0; i < PREFIXES.length; i++) {
            DEFAULT.alias(SI.OHM.transform(CONVERTERS[i]), PREFIXES[i] + "Ohm");
            ASCII.label(SI.OHM.transform(CONVERTERS[i]), asciiPrefix(PREFIXES[i]) + "Ohm");
         }

         // Special case for DEGREE_CElSIUS.
         DEFAULT.label(SI.CELSIUS, "℃");
         DEFAULT.alias(SI.CELSIUS, "°C");
         ASCII.label(SI.CELSIUS, "Celsius");
         for (i = 0; i < PREFIXES.length; i++) {
            DEFAULT.label(SI.CELSIUS.transform(CONVERTERS[i]), PREFIXES[i] + "℃");
            DEFAULT.alias(SI.CELSIUS.transform(CONVERTERS[i]), PREFIXES[i] + "°C");
            ASCII.label(SI.CELSIUS.transform(CONVERTERS[i]), asciiPrefix(PREFIXES[i]) + "Celsius");
         }
         
         ////////////////////////////////////////////////////////////////////////
         // To be moved in resource bundle in future release (locale dependent).
         DEFAULT.label(NonSI.PERCENT, "%");
         DEFAULT.label(NonSI.DECIBEL, "dB");
         DEFAULT.label(NonSI.G, "grav");
         DEFAULT.label(NonSI.ATOM, "atom");
         DEFAULT.label(NonSI.REVOLUTION, "rev");
         DEFAULT.label(NonSI.DEGREE_ANGLE, "°");
         ASCII.label(NonSI.DEGREE_ANGLE, "degree_angle");
         DEFAULT.label(NonSI.MINUTE_ANGLE, "'");
         DEFAULT.label(NonSI.SECOND_ANGLE, "\"");
         DEFAULT.label(NonSI.CENTIRADIAN, "centiradian");
         DEFAULT.label(NonSI.GRADE, "grade");
         DEFAULT.label(NonSI.ARE, "a");
         DEFAULT.label(NonSI.HECTARE, "ha");
         DEFAULT.label(NonSI.BYTE, "byte");
         DEFAULT.label(NonSI.MINUTE, "min");
         DEFAULT.label(NonSI.HOUR, "h");
         DEFAULT.label(NonSI.DAY, "day");
         DEFAULT.label(NonSI.WEEK, "week");
         DEFAULT.label(NonSI.YEAR, "year");
         DEFAULT.label(NonSI.MONTH, "month");
         DEFAULT.label(NonSI.DAY_SIDEREAL, "day_sidereal");
         DEFAULT.label(NonSI.YEAR_SIDEREAL, "year_sidereal");
         DEFAULT.label(NonSI.YEAR_CALENDAR, "year_calendar");
         DEFAULT.label(NonSI.E, "e");
         DEFAULT.label(NonSI.FARADAY, "Fd");
         DEFAULT.label(NonSI.FRANKLIN, "Fr");
         DEFAULT.label(NonSI.GILBERT, "Gi");
         DEFAULT.label(NonSI.ERG, "erg");
         DEFAULT.label(NonSI.ELECTRON_VOLT, "eV");
         DEFAULT.label(SI.KILO(NonSI.ELECTRON_VOLT), "keV");
         DEFAULT.label(SI.MEGA(NonSI.ELECTRON_VOLT), "MeV");
         DEFAULT.label(SI.GIGA(NonSI.ELECTRON_VOLT), "GeV");
         DEFAULT.label(NonSI.LAMBERT, "La");
         DEFAULT.label(NonSI.FOOT, "ft");
         DEFAULT.label(NonSI.FOOT_SURVEY_US, "foot_survey_us");
         DEFAULT.label(NonSI.YARD, "yd");
         DEFAULT.label(NonSI.INCH, "in");
         DEFAULT.label(NonSI.MILE, "mi");
         DEFAULT.label(NonSI.NAUTICAL_MILE, "nmi");
         DEFAULT.label(NonSI.MILES_PER_HOUR, "mph");
         DEFAULT.label(NonSI.ANGSTROM, "Å");
         ASCII.label(NonSI.ANGSTROM, "Angstrom");
         DEFAULT.label(NonSI.ASTRONOMICAL_UNIT, "ua");
         DEFAULT.label(NonSI.LIGHT_YEAR, "ly");
         DEFAULT.label(NonSI.PARSEC, "pc");
         DEFAULT.label(NonSI.POINT, "pt");
         DEFAULT.label(NonSI.PIXEL, "pixel");
         DEFAULT.label(NonSI.MAXWELL, "Mx");
         DEFAULT.label(NonSI.GAUSS, "G");
         DEFAULT.label(NonSI.ATOMIC_MASS, "u");
         DEFAULT.label(NonSI.ELECTRON_MASS, "me");
         DEFAULT.label(NonSI.POUND, "lb");
         DEFAULT.label(NonSI.OUNCE, "oz");
         DEFAULT.label(NonSI.TON_US, "ton_us");
         DEFAULT.label(NonSI.TON_UK, "ton_uk");
         DEFAULT.label(NonSI.METRIC_TON, "t");
         DEFAULT.label(NonSI.DYNE, "dyn");
         DEFAULT.label(NonSI.KILOGRAM_FORCE, "kgf");
         DEFAULT.label(NonSI.POUND_FORCE, "lbf");
         DEFAULT.label(NonSI.HORSEPOWER, "hp");
         DEFAULT.label(NonSI.ATMOSPHERE, "atm");
         DEFAULT.label(NonSI.BAR, "bar");
         DEFAULT.label(NonSI.MILLIMETER_OF_MERCURY, "mmHg");
         DEFAULT.label(NonSI.INCH_OF_MERCURY, "inHg");
         DEFAULT.label(NonSI.RAD, "rd");
         DEFAULT.label(NonSI.REM, "rem");
         DEFAULT.label(NonSI.CURIE, "Ci");
         DEFAULT.label(NonSI.RUTHERFORD, "Rd");
         DEFAULT.label(NonSI.SPHERE, "sphere");
         DEFAULT.label(NonSI.RANKINE, "°R");
         ASCII.label(NonSI.RANKINE, "degree_rankine");
         DEFAULT.label(NonSI.FAHRENHEIT, "°F");
         ASCII.label(NonSI.FAHRENHEIT, "degree_fahrenheit");
         DEFAULT.label(NonSI.KNOT, "kn");
         DEFAULT.label(NonSI.MACH, "Mach");
         DEFAULT.label(NonSI.C, "c");
         DEFAULT.label(NonSI.LITRE, "L");
         DEFAULT.label(SI.MICRO(NonSI.LITRE), "µL");
         ASCII.label(SI.MICRO(NonSI.LITRE), "microL");
         DEFAULT.label(SI.MILLI(NonSI.LITRE), "mL");
         DEFAULT.label(SI.CENTI(NonSI.LITRE), "cL");
         DEFAULT.label(SI.DECI(NonSI.LITRE), "dL");
         DEFAULT.label(NonSI.GALLON_LIQUID_US, "gal");
         DEFAULT.label(NonSI.OUNCE_LIQUID_US, "oz");
         DEFAULT.label(NonSI.GALLON_DRY_US, "gallon_dry_us");
         DEFAULT.label(NonSI.GALLON_UK, "gallon_uk");
         DEFAULT.label(NonSI.OUNCE_LIQUID_UK, "oz_uk");
         DEFAULT.label(NonSI.ROENTGEN, "Roentgen");
// TODO
//         if (Locale.getDefault().getCountry().equals("GB")) {
//            DEFAULT.label(NonSI.GALLON_UK, "gal");
//            DEFAULT.label(NonSI.OUNCE_LIQUID_UK, "oz");
//         }
      }
   }
}

import measure.converter.AddConverter;
import measure.converter.MultiplyConverter;
import measure.converter.RationalConverter;
import measure.converter.UnitConverter;
import measure.parse.Appendable;
import measure.parse.ParsePosition;
import measure.unit.AlternateUnit;
import measure.unit.BaseUnit;
import measure.unit.CompoundUnit;
import measure.unit.ProductUnit;
import measure.unit.TransformedUnit;
import measure.unit.Unit;
import measure.unit.UnitFormat;

import flash.utils.Dictionary;

import mx.utils.StringUtil;

/**
 * This class represents the standard format.
 */
class DefaultFormat extends UnitFormat {
   /**
    * Constructor.
    */
   public function DefaultFormat() {
      super();
   }

   /**
    * Holds the name to unit mapping.
    */
   protected var _nameToUnit:Dictionary = new Dictionary();

   /**
    * Holds the unit to name mapping.
    */
   protected var _unitToName:Dictionary = new Dictionary();

   override public function label(unit:Unit, label:String):void {
      if (!isValidIdentifier(label)) {
         throw new ArgumentError("Label: " + label + " is not a valid identifier.");
      }
      _nameToUnit[label] = unit;
      _unitToName[unit] = label;
   }

   override public function alias(unit:Unit, alias:String):void {
      if (!isValidIdentifier(alias)) {
         throw new ArgumentError("Alias: " + alias + " is not a valid identifier.");
      }
      _nameToUnit[alias] = unit;
   }

   override public function isValidIdentifier(name:String):Boolean {
      if ((name == null) || (name.length == 0)) {
         return false;
      }
      for (var i:int = 0; i < name.length; i++) {
         if (!isUnitIdentifierPart(name.charAt(i))) {
            return false;
         }
      }
      return true;
   }

   // Returns the name for the specified unit or null if product unit.
   public function nameFor(unit:Unit):String {
      // Searches label database.
      var label:String = _unitToName[unit];
      if (label) {
         return label;
      }
      if (unit is BaseUnit) {
         return (unit as BaseUnit).symbol;
      }
      if (unit is AlternateUnit) {
         return (unit as AlternateUnit).symbol;
      }
      if (unit is TransformedUnit) {
         var tfmUnit:TransformedUnit = unit as TransformedUnit;
         var baseUnits:Unit = tfmUnit.standardUnit;
         var cvtr:UnitConverter = tfmUnit.toStandardUnit();
         var result:String = "";
         var baseUnitName:String = baseUnits.toString();
         if ((baseUnitName.indexOf("·") >= 0) ||
               (baseUnitName.indexOf("*") >= 0) ||
               (baseUnitName.indexOf("/") >= 0)) {
            // We could use parentheses whenever baseUnits is an
            // ProductUnit, but most ProductUnits have aliases,
            // so we'd end up with a lot of unnecessary parentheses.
            result = result.concat("(", baseUnitName, ")");
         }
         else {
            result = result.concat(baseUnitName);
         }
         if (cvtr is AddConverter) {
            result = result.concat("+", (cvtr as AddConverter).offset);
         }
         else if (cvtr is RationalConverter) {
            var dividend:Number = (cvtr as RationalConverter).dividend;
            if (dividend != 1) {
               result = result.concat("*", dividend);
            }
            var divisor:Number = (cvtr as RationalConverter).divisor;
            if (divisor != 1) {
               result = result.concat("/", divisor);
            }
         }
         else if (cvtr is MultiplyConverter) {
            result = result.concat("*", (cvtr as MultiplyConverter).factor);
         }
         else { // Other converters.
            return "[" + baseUnits + "?]";
         }
         return result;
      }
      // Compound unit.
      if (unit is CompoundUnit) {
         var cpdUnit:CompoundUnit = unit as CompoundUnit;
         return nameFor(cpdUnit.higher).toString() + ":" + nameFor(cpdUnit.lower);
      }
      return null; // Product unit.
   }

   // Returns the unit for the specified name.
   public function unitFor(name:String):Unit {
      var unit:Unit = _nameToUnit[name];
      if (unit) {
         return unit;
      }
      unit = Unit.SYMBOL_TO_UNIT[name];
      return unit;
   }

   ////////////////////////////
   // Parsing.

   override public function parseSingleUnit(value:String, pos:ParsePosition):Unit {
      var startIndex:int = pos.getIndex();
      var name:String = readIdentifier(value, pos);
      var unit:Unit = unitFor(name);
      check(unit != null, name + " not recognized", value, startIndex);
      return unit;
   }

   override public function parseProductUnit(value:String, pos:ParsePosition):Unit {
      var result:Unit = Unit.ONE;
      var token:int = nextToken(value, pos);
      switch (token) {
         case IDENTIFIER:
            result = parseSingleUnit(value, pos);
            break;
         case OPEN_PAREN:
            pos.setIndex(pos.getIndex() + 1);
            result = parseProductUnit(value, pos);
            token = nextToken(value, pos);
            check(token == CLOSE_PAREN, "')' expected", value, pos.getIndex());
            pos.setIndex(pos.getIndex() + 1);
            break;
      }
      token = nextToken(value, pos);
      var d:Number;
      var n:Number;
      while (true) {
         switch (token) {
            case EXPONENT:
               var e:Exponent = readExponent(value, pos);
               if (e.pow != 1) {
                  result = result.pow(e.pow);
               }
               if (e.root != 1) {
                  result = result.root(e.root);
               }   
               break;
            case MULTIPLY:
               pos.setIndex(pos.getIndex() + 1);
               token = nextToken(value, pos);
               if (token == INTEGER) {
                  n = readInteger(value, pos);
                  if (n != 1) {
                     result = result.times(n);
                  }
               }
               else if (token == FLOAT) {
                  d = readNumber(value, pos);
                  if (d != 1.0) {
                     result = result.times(d);
                  }
               }
               else {
                  result = result.times(parseProductUnit(value, pos));
               }
               break;
            case DIVIDE:
               pos.setIndex(pos.getIndex() + 1);
               token = nextToken(value, pos);
               if (token == INTEGER) {
                  n = readInteger(value, pos);
                  if (n != 1) {
                     result = result.divide(n);
                  }
               }
               else if (token == FLOAT) {
                  d = readNumber(value, pos);
                  if (d != 1.0) {
                     result = result.divide(d);
                  }
               }
               else {
                  result = result.divide(parseProductUnit(value, pos));
               }
               break;
            case PLUS:
               pos.setIndex(pos.getIndex() + 1);
               token = nextToken(value, pos);
               if (token == INTEGER) {
                  n = readInteger(value, pos);
                  if (n != 1) {
                     result = result.plus(n);
                  }
               }
               else if (token == FLOAT) {
                  d = readNumber(value, pos);
                  if (d != 1.0) {
                     result = result.plus(d);
                  }
               }
               else {
                  throw new Error("not a number", pos.getIndex());
               }
               break;
            case EOF:
            case CLOSE_PAREN:
               return result;
            default:
               throw new Error("unexpected token " + token, pos.getIndex());
         }
         token = nextToken(value, pos);
      }

      return result;
   }

   private static const EOF:int = 0;
   private static const IDENTIFIER:int = 1;
   private static const OPEN_PAREN:int = 2;
   private static const CLOSE_PAREN:int = 3;
   private static const EXPONENT:int = 4;
   private static const MULTIPLY:int = 5;
   private static const DIVIDE:int = 6;
   private static const PLUS:int = 7;
   private static const INTEGER:int = 8;
   private static const FLOAT:int = 9;

   private function nextToken(value:String, pos:ParsePosition):int {
      var length:int = value.length;
      while (pos.getIndex() < length) {
         var c:String = value.charAt(pos.getIndex());
         if (isUnitIdentifierPart(c)) {
            return IDENTIFIER;
         }
         else if (c == "(") {
            return OPEN_PAREN;
         }
         else if (c == ")") {
            return CLOSE_PAREN;
         }
         else if ((c == "^") || (c == "¹") || (c == "²") || (c == "³")) {
            return EXPONENT;
         }
         else if (c == "*") {
            var c2:String = value.charAt(pos.getIndex() + 1);
            if (c2 == "*") {
               return EXPONENT;
            } else {
               return MULTIPLY;
            }
         }
         else if (c == "·") {
            return MULTIPLY;
         }
         else if (c == "/") {
            return DIVIDE;
         }
         else if (c == "+") {
            return PLUS;
         }
         else if ((c == "-") || isDigit(c)) {
            var index:int = pos.getIndex() + 1;
            while ((index < length) && (isDigit(c) || (c == "-") || (c == ".") || (c == "E"))) {
               c = value.charAt(index++);
               if (c == ".") {
                  return FLOAT;
               }
            }
            return INTEGER;
         }
         pos.setIndex(pos.getIndex() + 1);
      }
      return EOF;
   }

   private function check(expr:Boolean, message:String, value:String, index:int):void {
      if (!expr) {
         throw new ArgumentError(message + " (in " + value + " at index " + index + ")", index);
      }
   }

   private function readExponent(value:String, pos:ParsePosition):Exponent {
      var c:String = value.charAt(pos.getIndex());
      if (c == "^") {
         pos.setIndex(pos.getIndex()+1);
      }
      else if (c == "*") {
         pos.setIndex(pos.getIndex()+2);
      }
      const length:int = value.length;
      var pow:int = 0;
      var isPowNegative:Boolean = false;
      var root:int = 0;
      var isRootNegative:Boolean = false;
      var isRoot:Boolean = false;
      while (pos.getIndex() < length) {
         c = value.charAt(pos.getIndex());
         if (c == "¹") {
            if (isRoot) {
               root = root * 10 + 1;
            }
            else {
               pow = pow * 10 + 1;
            }
         }
         else if (c == "²") {
            if (isRoot) {
               root = root * 10 + 2;
            }
            else {
               pow = pow * 10 + 2;
            }
         }
         else if (c == "³") {
            if (isRoot) {
               root = root * 10 + 3;
            }
            else {
               pow = pow * 10 + 3;
            }
         }
         else if (c == "-") {
            if (isRoot) {
               isRootNegative = true;
            }
            else {
               isPowNegative = true;
            }
         }
         else if (c.match(/[0-9]/).length > 0) {
            if (isRoot) {
               root = root * 10 + parseInt(c);
            }
            else {
               pow = pow * 10 + parseInt(c);
            }
         }
         else if (c == ":") {
            isRoot = true;
         }
         else {
            break;
         }
         pos.setIndex(pos.getIndex()+1);
      }
      if (pow == 0) {
         pow = 1;
      }
      if (root == 0) {
         root = 1;
      }
      return new Exponent(isPowNegative ? -pow : pow, isRootNegative ? -root : root);
   }

   private function readInteger(value:String, pos:ParsePosition):Number {
      var length:int = value.length;
      var result:int = 0;
      var isNegative:Boolean = false;
      while (pos.getIndex() < length) {
         var c:String = value.charAt(pos.getIndex());
         if (c == "-") {
            isNegative = true;
         }
         else if (c.match(/[0-9]/)) {
            result = result * 10 + parseInt(c);
         }
         else {
            break;
         }
         pos.setIndex(pos.getIndex()+1);
      }
      return isNegative ? -result : result;
   }

   private function readNumber(value:String, pos:ParsePosition):Number {
      var length:int = value.length;
      var start:int = pos.getIndex();
      var end:int = start + 1;
      while (end < length) {
         if ("012356789+-.E".indexOf(value.charAt(end)) < 0) {
            break;
         }
         end += 1;
      }
      pos.setIndex(end+1);
      return Number(value.substring(start, end));
   }

   private function readIdentifier(value:String, pos:ParsePosition):String {
      var length:int = value.length;
      var start:int = pos.getIndex();
      var i:int = start;
      while ((++i < length) && isUnitIdentifierPart(value.charAt(i))) { 
         // continue
      }
      pos.setIndex(i);
      return value.substring(start, i);
   }

   ////////////////////////////
   // Formatting.

   override public function format(unit:Unit, appendable:Appendable=null):Appendable {
      if (!appendable) {
         appendable = new Appendable();
      }
      var name:String = nameFor(unit);
      if (name) {
         return appendable.append(name);
      }
      if (!(unit is ProductUnit)) {
         throw new ArgumentError("Cannot format given Object as a Unit");
      }
      // Product unit.
      var productUnit:ProductUnit = (unit as ProductUnit);
      var invNbr:int = 0;
      var i:int;

      // Write positive exponents first.
      var start:Boolean = true;
      var pow:int;
      var root:int
      for (i = 0; i < productUnit.unitCount; i++) {
         pow = productUnit.getUnitPow(i);
         if (pow >= 0) {
            if (!start) {
               appendable.append("·"); // Separator.
            }
            name = nameFor(productUnit.getUnit(i));
            root = productUnit.getUnitRoot(i);
            append(appendable, name, pow, root);
            start = false;
         }
         else {
            invNbr++;
         }
      }

      // Write negative exponents.
      if (invNbr != 0) {
         if (start) {
            appendable.append("1"); // e.g. 1/s
         }
         appendable.append("/");
         if (invNbr > 1) {
            appendable.append("(");
         }
         start = true;
         for (i = 0; i < productUnit.unitCount; i++) {
            pow = productUnit.getUnitPow(i);
            if (pow < 0) {
               name = nameFor(productUnit.getUnit(i));
               root = productUnit.getUnitRoot(i);
               if (!start) {
                  appendable.append("·"); // Separator.
               }
               append(appendable, name, -pow, root);
               start = false;
            }
         }
         if (invNbr > 1) {
            appendable.append(")");
         }
      }
      return appendable;
   }

   private function append(appendable:Appendable, symbol:String, pow:int, root:int):Appendable {
      appendable.append(symbol);
      if ((pow != 1) || (root != 1)) {
         // Write exponent.
         if ((pow == 2) && (root == 1)) {
            appendable.append("²"); // Square
         }
         else if ((pow == 3) && (root == 1)) {
            appendable.append("³"); // Cubic
         }
         else {
            // Use general exponent form.
            appendable.append("^");
            appendable.append(pow.toString());
            if (root != 1) {
               appendable.append(":");
               appendable.append(root.toString());
            }
         }
      }
      return appendable;
   }

   protected function isUnitIdentifierPart(ch:String):Boolean {
      return isLetter(ch) ||
         (!isWhitespace(ch) && !isDigit(ch)
          && (ch != "·") && (ch != "*") && (ch != "/")
          && (ch != "(") && (ch != ")") && (ch != "[") && (ch != "]")   
          && (ch != "¹") && (ch != "²") && (ch != "³") 
          && (ch != "^") && (ch != "+") && (ch != "-"));
   }

   private function isUpperCase(value:String):Boolean {
      return isValidCode(value, 65, 90);
   }

   private function isLowerCase(value:String):Boolean {
      return isValidCode(value, 97, 122);
   }

   private function isWhitespace(value:String):Boolean {
      return value == " ";
   }

   private function isDigit(value:String):Boolean {
      return isValidCode(value, 48, 57);
   }

   private function isLetter(value:String):Boolean {
      return (isLowerCase(value) || isUpperCase(value));
   }

   private function isValidCode(value:String, minCode:Number, maxCode:Number):Boolean {
      if ((value == null) || (StringUtil.trim(value).length < 1)) {
         return false;
      }
      for (var i:int = value.length - 1; i >= 0; i--) {
         var code : Number = value.charCodeAt(i);
         if ((code < minCode) || (code > maxCode)) {
            return false;
         }
      }
      return true;
   }
}

/**
 * This class represents the ASCIIFormat format.
 */
class ASCIIFormat extends DefaultFormat {

   override public function nameFor(unit:Unit):String {
      // First search if specific ASCII name should be used.
      var name:String = _unitToName[unit];
      if (name != null) {
         return name;
      }
      // Else returns default name.
      return DEFAULT.nameFor(unit);
   }

   override public function unitFor(name:String):Unit {
      // First search if specific ASCII name.
      var unit:Unit = _nameToUnit[name];
      if (unit != null) {
         return unit;
      }
      // Else returns default mapping.
      return DEFAULT.unitFor(name);
   }

   override public function format(unit:Unit, appendable:Appendable=null):Appendable {
         if (!appendable) {
            appendable = new Appendable();
         }
         var name:String = nameFor(unit);
         if (name != null) {
            return appendable.append(name);
         }
         if (!(unit is ProductUnit)) {
            throw new ArgumentError("Cannot format given Object as a Unit");
         }
         var productUnit:ProductUnit = (unit as ProductUnit);
         for (var i:int = 0; i < productUnit.unitCount; i++) {
            if (i != 0) {
               appendable.append("*"); // Separator.
            }
            name = nameFor(productUnit.getUnit(i));
            var pow:int = productUnit.getUnitPow(i);
            var root:int = productUnit.getUnitRoot(i);
            appendable.append(name);
            if ((pow != 1) || (root != 1)) {
               // Use general exponent form.
               appendable.append("^");
               appendable.append(pow.toString());
               if (root != 1) {
                  appendable.append(":");
                  appendable.append(root.toString());
               }
            }
         }
         return appendable;
      }
}

/**
 * This class represents an exponent with both a power (numerator)
 * and a root (denominator).
 */
class Exponent {
   public var pow:int;
   public var root:int;
   public function Exponent(pow:int, root:int) {
      super();
      this.pow = pow;
      this.root = root;
   }
}
