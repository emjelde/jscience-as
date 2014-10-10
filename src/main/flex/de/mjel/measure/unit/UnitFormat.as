/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.measure.unit {
   import de.mjel.measure.converter.AddConverter;
   import de.mjel.measure.converter.MultiplyConverter;
   import de.mjel.measure.converter.RationalConverter;
   import de.mjel.measure.converter.UnitConverter;
   import de.mjel.measure.parse.Appendable;
   import de.mjel.measure.parse.ParseError;
   import de.mjel.measure.parse.ParsePosition;

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
       *
       * @private
       */
      public function UnitFormat() {
         super();
      }

      /**
       * Formats the specified unit.
       *
       * @param unit the unit to format.
       * @param appendable the appendable destination.
       */
      [Abstract]
      public function format(unit:Unit, appendable:Appendable=null):Appendable {
         // Subclasses should override to add implementation
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
         // Subclasses should override to add implementation
         return null;
      }

      /**
       * Parses a sequence of characters to produce a single unit. 
       *
       * @param value the <code>String</code> to parse.
       * @param pos an object holding the parsing index and error position.
       * @return an <code>Unit</code> parsed from the character sequence.
       * @throws ArgumentError if the character sequence does not contain a valid unit identifier.
       */
      [Abstract]
      public function parseSingleUnit(value:String, pos:ParsePosition):Unit {
         // Subclasses should override to add implementation
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
       * @throws ArgumentError if the label is not a <code>isValidIdentifier(String)</code>
       valid identifier.
       */
      [Abstract]
      public function label(unit:Unit, label:String):void {
         // Subclasses should override to add implementation
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
         // Subclasses should override to add implementation
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
         // Subclasses should override to add implementation
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
         var start:int = pos.index;
         try {
            return parseProductUnit(source, pos);
         }
         catch (e:ParseError) {
            pos.index = start;
            pos.errorIndex = e.errorOffset;
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
         DEFAULT.label(NonSI.OUNCE_LIQUID_US, "oz_fl");
         DEFAULT.label(NonSI.GALLON_DRY_US, "gallon_dry_us");
         DEFAULT.label(NonSI.GALLON_UK, "gallon_uk");
         DEFAULT.label(NonSI.OUNCE_LIQUID_UK, "oz_fl_uk");
         DEFAULT.label(NonSI.MEASUREMENT_TON, "measurement_ton");
         DEFAULT.label(NonSI.ROENTGEN, "Roentgen");
// TODO
//         if (Locale.getDefault().getCountry().equals("GB")) {
//            DEFAULT.label(NonSI.GALLON_UK, "gal");
//            DEFAULT.label(NonSI.OUNCE_LIQUID_UK, "oz");
//         }
      }
   }
}
