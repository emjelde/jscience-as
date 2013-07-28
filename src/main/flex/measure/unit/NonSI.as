/*
 * JScience - Java(TM) Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2007 - JScience (http://jscience.org/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package measure.unit {
   import measure.converter.LogConverter;
   import measure.converter.RationalConverter;

   /**
    * <p>This class contains units that are not part of the International
    *    System of Units, that is, they are outside the SI, but are important
    *    and widely used.</p>
    */
   final public class NonSI extends SystemOfUnits {
      public function NonSI() {
         super();
      }

      /**
       * Holds collection of NonSI units.
       */
      private static const UNITS:Vector.<Unit> = new Vector.<Unit>();
      private static const INSTANCE:NonSI = new NonSI();
      
      /**
       * Holds the standard gravity constant: 9.80665 m/s² exact.
       */
      private static const STANDARD_GRAVITY_DIVIDEND:int = 980665;
      private static const STANDARD_GRAVITY_DIVISOR:int  = 100000;
      
      /**
       * Holds the international foot: 0.3048 m exact.
       */
      private static const INTERNATIONAL_FOOT_DIVIDEND:int =  3048;
      private static const INTERNATIONAL_FOOT_DIVISOR:int  = 10000;
      
      /**
       * Holds the avoirdupois pound: 0.45359237 kg exact
       */
      private static const AVOIRDUPOIS_POUND_DIVIDEND:int =  45359237; 
      private static const AVOIRDUPOIS_POUND_DIVISOR:int  = 100000000; 
      
      /**
       * Holds the Avogadro constant.
       */
      private static const AVOGADRO_CONSTANT:Number = 6.02214199e23; // (1/mol).
      
      /**
       * Holds the electric charge of one electron.
       */
      private static const ELEMENTARY_CHARGE:Number = 1.602176462e-19; // (C).
       
      /**
       * Returns the unique instance of this class.
       *
       * @return the NonSI instance.
       */
      public static function getInstance():NonSI {
         return INSTANCE;
      }
      
      ///////////////////
      // Dimensionless //
      ///////////////////
      
      /**
       * A dimensionless unit equals to <code>0.01</code> 
       * (standard name <code>%</code>).
       */
      public static const PERCENT:Unit = nonSI(Unit.ONE.divide(100));
      
      /**
       * A logarithmic unit used to describe a ratio
       * (standard name <code>dB</code>).
       */
      public static const DECIBEL:Unit = nonSI(Unit.ONE
         .transform(new LogConverter(10).inverse().concatenate(
            new RationalConverter(1, 10))));
      
      /////////////////////////
      // Amount of substance //
      /////////////////////////
      
      /**
       * A unit of amount of substance equals to one atom
       * (standard name <code>atom</code>).
       */
      public static const ATOM:Unit = nonSI(SI.MOLE
         .divide(AVOGADRO_CONSTANT));
      
      ////////////
      // Length //
      ////////////
      
      /**
       * A unit of length equal to <code>0.3048 m</code> 
       * (standard name <code>ft</code>).
       */
      public static const FOOT:Unit = nonSI(SI.METRE.times(INTERNATIONAL_FOOT_DIVIDEND).divide(INTERNATIONAL_FOOT_DIVISOR));
      
      /**
       * A unit of length equal to <code>1200/3937 m</code> 
       * (standard name <code>foot_survey_us</code>).
       * See also: <a href="http://www.sizes.com/units/foot.htm">foot</a>
       */
      public static const FOOT_SURVEY_US:Unit = nonSI(SI.METRE.times(1200).divide(3937));
      
      /**
       * A unit of length equal to <code>0.9144 m</code>
       * (standard name <code>yd</code>).
       */
      public static const YARD:Unit = nonSI(FOOT.times(3));
      
      /**
       * A unit of length equal to <code>0.0254 m</code> 
       * (standard name <code>in</code>).
       */
      public static const INCH:Unit = nonSI(FOOT.divide(12));
      
      /**
       * A unit of length equal to <code>1609.344 m</code>
       * (standard name <code>mi</code>).
       */
      public static const MILE:Unit = nonSI(SI.METRE.times(1609344).divide(1000));
      
      /**
       * A unit of length equal to <code>1852.0 m</code>
       * (standard name <code>nmi</code>).
       */
      public static const NAUTICAL_MILE:Unit = nonSI(SI.METRE.times(1852));
      
      /**
       * A unit of length equal to <code>1E-10 m</code>
       * (standard name <code>Å</code>).
       */
      public static const ANGSTROM:Unit = nonSI(SI.METRE.divide(10000000000));
      
      /**
       * A unit of length equal to the average distance from the center of the
       * Earth to the center of the Sun (standard name <code>ua</code>).
       */
      public static const ASTRONOMICAL_UNIT:Unit = nonSI(SI.METRE.times(149597870691.0));
      
      /**
       * A unit of length equal to the distance that light travels in one year
       * through a vacuum (standard name <code>ly</code>).
       */
      public static const LIGHT_YEAR:Unit = nonSI(SI.METRE.times(9.460528405e15));
      
      /**
       * A unit of length equal to the distance at which a star would appear to
       * shift its position by one arcsecond over the course the time
       * (about 3 months) in which the Earth moves a distance of
       * <code>ASTRONOMICAL_UNIT</code> in the direction perpendicular to the
       * direction to the star (standard name <code>pc</code>).
       */
      public static const PARSEC:Unit = nonSI(SI.METRE.times(30856770e9));
      
      /**
       * A unit of length equal to <code>0.013837 INCH</code> exactly
       * (standard name <code>pt</code>).
       * @see     #PIXEL
       */
      public static const POINT:Unit = nonSI(INCH.times(13837).divide(1000000));
      
      /**
       * A unit of length equal to <code>1/72 INCH</code>
       * (standard name <code>pixel</code>).
       * It is the American point rounded to an even 1/72 inch.
       * @see     #POINT
       */
      public static const PIXEL:Unit = nonSI(INCH.divide(72));
      
      /**
       * Equivalent <code>PIXEL</code>
       */
      public static const COMPUTER_POINT:Unit = PIXEL;
      
      //////////////
      // Duration //
      //////////////
      
      /**
       * A unit of duration equal to <code>60 s</code>
       * (standard name <code>min</code>).
       */
      public static const MINUTE:Unit = nonSI(SI.SECOND.times(60));
      
      /**
       * A unit of duration equal to <code>60 MINUTE</code>
       * (standard name <code>h</code>).
       */
      public static const HOUR:Unit = nonSI(MINUTE.times(60));
      
      /**
       * A unit of duration equal to <code>24 HOUR</code>
       * (standard name <code>d</code>).
       */
      public static const DAY:Unit = nonSI(HOUR.times(24));
      
      /**
       * A unit of duration equal to <code>7 DAY</code>
       * (standard name <code>week</code>).
       */
      public static const WEEK:Unit = nonSI(DAY.times(7));
      
      /**
       * A unit of duration equal to 365 days, 5 hours, 49 minutes,
       * and 12 seconds (standard name <code>year</code>).
       */
      public static const YEAR:Unit = nonSI(SI.SECOND.times(31556952));
      
      /**
       * A unit of duration equal to one twelfth of a year
       * (standard name <code>month</code>).
       */
      public static const MONTH:Unit = nonSI(YEAR.divide(12));
      
      /**
       * A unit of duration equal to the time required for a complete rotation of
       * the earth in reference to any star or to the vernal equinox at the
       * meridian, equal to 23 hours, 56 minutes, 4.09 seconds
       * (standard name <code>day_sidereal</code>).
       */
      public static const DAY_SIDEREAL:Unit = nonSI(SI.SECOND.times(86164.09));
      
      /**
       * A unit of duration equal to one complete revolution of the
       * earth about the sun, relative to the fixed stars, or 365 days, 6 hours,
       * 9 minutes, 9.54 seconds (standard name <code>year_sidereal</code>).
       */
      public static const YEAR_SIDEREAL:Unit = nonSI(SI.SECOND.times(31558149.54));
      
      /**
       * A unit of duration equal to <code>365 DAY</code>
       * (standard name <code>year_calendar</code>).
       */
      public static const YEAR_CALENDAR:Unit = nonSI(DAY.times(365));
      
      //////////
      // Mass //
      //////////
      
      /**
       * A unit of mass equal to <code>453.59237 grams</code> (avoirdupois pound,
       * standard name <code>lb</code>).
       */
      public static const POUND:Unit = nonSI(SI.KILOGRAM.times(AVOIRDUPOIS_POUND_DIVIDEND).divide(AVOIRDUPOIS_POUND_DIVISOR));
      
      /**
       * A unit of mass equal to <code>1 / 16 POUND</code>
       * (standard name <code>oz</code>).
       */
      public static const OUNCE:Unit = nonSI(POUND.divide(16));
      
      /**
       * A unit of mass equal to <code>2000 POUND</code> (short ton, 
       * standard name <code>ton_us</code>).
       */
      public static const TON_US:Unit = nonSI(POUND.times(2000));
      
      /**
       * A unit of mass equal to <code>2240 POUND</code> (long ton,
       * standard name <code>ton_uk</code>).
       */
      public static const TON_UK:Unit = nonSI(POUND.times(2240));
      
      /**
       * A unit of mass equal to <code>1000 kg</code> (metric ton,
       * standard name <code>t</code>).
       */
      public static const METRIC_TON:Unit = nonSI(SI.KILOGRAM.times(1000));
      
      /////////////////////
      // Electric charge //
      /////////////////////
      
      /**
       * A unit of electric charge equal to the charge on one electron
       * (standard name <code>e</code>).
       */
      public static const E:Unit = nonSI(SI.COULOMB.times(ELEMENTARY_CHARGE));
      
      /**
       * A unit of electric charge equal to equal to the product of Avogadro's
       * number (see MOLE) and the charge (1 e) on a single electron
       * (standard name <code>Fd</code>).
       */
      public static const FARADAY:Unit = nonSI(SI.COULOMB.times(ELEMENTARY_CHARGE * AVOGADRO_CONSTANT)); // e/mol
      
      /**
       * A unit of electric charge which exerts a force of one dyne on an equal
       * charge at a distance of one centimeter
       * (standard name <code>Fr</code>).
       */
      public static const FRANKLIN:Unit = nonSI(SI.COULOMB.times(3.3356e-10));
      
      /////////////////
      // Temperature //
      /////////////////
      
      /**
       * A unit of temperature equal to <code>5/9 °K</code>
       * (standard name <code>°R</code>).
       */
      public static const RANKINE:Unit = nonSI(SI.KELVIN.times(5).divide(9));
      
      /**
       * A unit of temperature equal to degree Rankine minus 
       * <code>459.67 °R</code> (standard name <code>°F</code>).
       * @see    #RANKINE
       */
      public static const FAHRENHEIT:Unit = nonSI(RANKINE.plus(459.67));
      
      ///////////
      // Angle //
      ///////////
      
      /**
       * A unit of angle equal to a full circle or <code>2<i>&pi;</i> 
       * RADIAN</code> (standard name <code>rev</code>).
       */
      public static const REVOLUTION:Unit = nonSI(SI.RADIAN.times(2.0 * Math.PI));
      
      /**
       * A unit of angle equal to <code>1/360 REVOLUTION</code>
       * (standard name <code>°</code>).
       */
      public static const DEGREE_ANGLE:Unit = nonSI(REVOLUTION.divide(360));
      
      /**
       * A unit of angle equal to <code>1/60 DEGREE_ANGLE</code>
       * (standard name <code>′</code>).
       */
      public static const MINUTE_ANGLE:Unit = nonSI(DEGREE_ANGLE.divide(60));
      
      /**
       *  A unit of angle equal to <code>1/60 MINUTE_ANGLE</code>
       * (standard name <code>"</code>).
       */
      public static const SECOND_ANGLE:Unit = nonSI(MINUTE_ANGLE.divide(60));
      
      /**
       * A unit of angle equal to <code>0.01 RADIAN</code>
       * (standard name <code>centiradian</code>).
       */
      public static const CENTIRADIAN:Unit = nonSI(SI.RADIAN.divide(100));
      
      /**
       * A unit of angle measure equal to <code>1/400 REVOLUTION</code>
       * (standard name <code>grade</code>).
       */
      public static const GRADE:Unit = nonSI(REVOLUTION.divide(400));
      
      //////////////
      // Velocity //
      //////////////
      
      /**
       * A unit of velocity expressing the number of international {@link 
       * #MILE miles} per <code>HOUR</code> (abbreviation <code>mph</code>).
       */
      public static const MILES_PER_HOUR:Unit = nonSI(NonSI.MILE.divide(NonSI.HOUR));
      
      /**
       * A unit of velocity expressing the number of KILOMETRE per 
       * <code>HOUR</code>.
       */
      public static const KILOMETRES_PER_HOUR:Unit = nonSI(SI.KILOMETRE.divide(NonSI.HOUR));
      
      /**
       * Equivalent to <code>KILOMETRES_PER_HOUR</code>.
       */
      public static const KILOMETERS_PER_HOUR:Unit = KILOMETRES_PER_HOUR;
      
      /**
       * A unit of velocity expressing the number of  {@link #NAUTICAL_MILE
       * nautical miles} per <code>HOUR</code> (abbreviation <code>kn</code>).
       */
      public static const KNOT:Unit = nonSI(NonSI.NAUTICAL_MILE.divide(NonSI.HOUR));
      
      /**
       * A unit of velocity to express the speed of an aircraft relative to
       * the speed of sound (standard name <code>Mach</code>).
       */
      public static const MACH:Unit = nonSI(SI.METRES_PER_SECOND.times(331.6));
      
      /**
       * A unit of velocity relative to the speed of light
       * (standard name <code>c</code>).
       */
      public static const C:Unit = nonSI(SI.METRES_PER_SECOND.times(299792458));
      
      //////////////////
      // Acceleration //
      //////////////////
      
      /**
       * A unit of acceleration equal to the gravity at the earth's surface
       * (standard name <code>grav</code>).
       */
      public static const G:Unit = nonSI(SI.METRES_PER_SQUARE_SECOND.times(STANDARD_GRAVITY_DIVIDEND).divide(STANDARD_GRAVITY_DIVISOR));
      
      //////////
      // Area //
      //////////
      
      /**
       * A unit of area equal to <code>100 m²</code>
       * (standard name <code>a</code>).
       */
      public static const ARE:Unit = nonSI(SI.SQUARE_METRE.times(100));
      
      /**
       * A unit of area equal to <code>100 ARE</code>
       * (standard name <code>ha</code>).
       */
      public static const HECTARE:Unit = nonSI(ARE.times(100)); // Exact.
      
      /////////////////
      // Data Amount //
      /////////////////
      
      /**
       * A unit of data amount equal to <code>8 BIT</code>
       * (BinarY TErm, standard name <code>byte</code>).
       */
      public static const BYTE:Unit = nonSI(SI.BIT.times(8));
      
      /**
       * Equivalent <code>BYTE</code>
       */
      public static const OCTET:Unit = BYTE;
      
      
      //////////////////////
      // Electric current //
      //////////////////////
      
      /**
       * A unit of electric charge equal to the centimeter-gram-second
       * electromagnetic unit of magnetomotive force, equal to <code>10/4
       * &pi;ampere-turn</code> (standard name <code>Gi</code>).
       */
      public static const GILBERT:Unit = nonSI(SI.AMPERE.times(10.0 / (4.0 * Math.PI)));
      
      ////////////
      // Energy //
      ////////////
      
      /**
       * A unit of energy equal to <code>1E-7 J</code>
       * (standard name <code>erg</code>).
       */
      public static const ERG:Unit = nonSI(SI.JOULE.divide(10000000));
      
      /**
       * A unit of energy equal to one electron-volt (standard name 
       * <code>eV</code>, also recognized <code>keV, MeV, GeV</code>).
       */
      public static const ELECTRON_VOLT:Unit = nonSI(SI.JOULE.times(ELEMENTARY_CHARGE));
      
      /////////////////
      // Illuminance //
      /////////////////
      
      /**
       * A unit of illuminance equal to <code>1E4 Lx</code>
       * (standard name <code>La</code>).
       */
      public static const LAMBERT:Unit = nonSI(SI.LUX.times(10000));
      
      ///////////////////
      // Magnetic Flux //
      ///////////////////
      
      /**
       * A unit of magnetic flux equal <code>1E-8 Wb</code>
       * (standard name <code>Mx</code>).
       */
      public static const MAXWELL:Unit = nonSI(SI.WEBER.divide(100000000));
      
      ///////////////////////////
      // Magnetic Flux Density //
      ///////////////////////////
      
      /**
       * A unit of magnetic flux density equal <code>1000 A/m</code>
       * (standard name <code>G</code>).
       */
      public static const GAUSS:Unit = nonSI(SI.TESLA.divide(10000));
      
      ///////////
      // Force //
      ///////////
      
      /**
       * A unit of force equal to <code>1E-5 N</code>
       * (standard name <code>dyn</code>).
       */
      public static const DYNE:Unit = nonSI(SI.NEWTON.divide(100000));
      
      /**
       * A unit of force equal to <code>9.80665 N</code>
       * (standard name <code>kgf</code>).
       */
      public static const KILOGRAM_FORCE:Unit = nonSI(SI.NEWTON
         .times(STANDARD_GRAVITY_DIVIDEND).divide(STANDARD_GRAVITY_DIVISOR));
      
      /**
       * A unit of force equal to <code>POUND·G</code>
       * (standard name <code>lbf</code>).
       */
      public static const POUND_FORCE:Unit = nonSI(SI.NEWTON
         .times(1 * AVOIRDUPOIS_POUND_DIVIDEND * STANDARD_GRAVITY_DIVIDEND)
         .divide(1 * AVOIRDUPOIS_POUND_DIVISOR * STANDARD_GRAVITY_DIVISOR));
      
      ///////////
      // Power //
      ///////////
      
      /**
       * A unit of power equal to the power required to raise a mass of 75
       * kilograms at a velocity of 1 meter per second (metric,
       * standard name <code>hp</code>).
       */
      public static const HORSEPOWER:Unit = nonSI(SI.WATT.times(735.499));
      
      //////////////
      // Pressure //
      //////////////
      
      /**
       * A unit of pressure equal to the average pressure of the Earth's
       * atmosphere at sea level (standard name <code>atm</code>).
       */
      public static const ATMOSPHERE:Unit = nonSI(SI.PASCAL.times(101325));
      
      /**
       * A unit of pressure equal to <code>100 kPa</code>
       * (standard name <code>bar</code>).
       */
      public static const BAR:Unit = nonSI(SI.PASCAL.times(100000));
      
      /**
       * A unit of pressure equal to the pressure exerted at the Earth's
       * surface by a column of mercury 1 millimeter high
       * (standard name <code>mmHg</code>).
       */
      public static const MILLIMETER_OF_MERCURY:Unit =nonSI(SI.PASCAL.times(133.322));
      
      /**
       * A unit of pressure equal to the pressure exerted at the Earth's
       * surface by a column of mercury 1 inch high
       * (standard name <code>inHg</code>).
       */
      public static const INCH_OF_MERCURY:Unit = nonSI(SI.PASCAL.times(3386.388));
      
      /////////////////////////////
      // Radiation dose absorbed //
      /////////////////////////////
      
      /**
       * A unit of radiation dose absorbed equal to a dose of 0.01 joule of
       * energy per kilogram of mass (J/kg) (standard name <code>rd</code>).
       */
      public static const RAD:Unit = nonSI(SI.GRAY.divide(100));
      
      /**
       * A unit of radiation dose effective equal to <code>0.01 Sv</code>
       * (standard name <code>rem</code>).
       */
      public static const REM:Unit = nonSI(SI.SIEVERT.divide(100));
      
      //////////////////////////
      // Radioactive activity //
      //////////////////////////
      
      /**
       * A unit of radioctive activity equal to the activity of a gram of radium
       * (standard name <code>Ci</code>).
       */
      public static const CURIE:Unit = nonSI(SI.BECQUEREL.times(37000000000));
      
      /**
       * A unit of radioctive activity equal to 1 million radioactive
       * disintegrations per second (standard name <code>Rd</code>).
       */
      public static const RUTHERFORD:Unit = nonSI(SI.BECQUEREL.times(1000000));
      
      /////////////////
      // Solid angle //
      /////////////////
      
      /**
       * A unit of solid angle equal to <code>4 <i>&pi;</i> steradians</code>
       * (standard name <code>sphere</code>).
       */
      public static const SPHERE:Unit = nonSI(SI.STERADIAN.times(4.0 * Math.PI));
      
      ////////////
      // Volume //
      ////////////
      
      /**
       * A unit of volume equal to one cubic decimeter (default label
       * <code>L</code>, also recognized <code>µL, mL, cL, dL</code>).
       */
      public static const LITRE:Unit = nonSI(SI.CUBIC_METRE.divide(1000));
      
      /**
       * Equivalent to <code>LITRE</code> (American spelling).
       */
      public static const LITER:Unit = LITRE;
      
      /**
       * A unit of volume equal to one cubic inch (<code>in³</code>).
       */
      public static const CUBIC_INCH:Unit = nonSI(INCH.pow(3));
      
      /**
       * A unit of volume equal to one cubic foot (<code>ft³</code>).
       */
      public static const CUBIC_FOOT:Unit = nonSI(FOOT.pow(3));
      
      /**
       * A unit of volume equal to one US gallon, Liquid Unit. The U.S. liquid
       * gallon is based on the Queen Anne or Wine gallon occupying 231 cubic
       * inches (standard name <code>gal</code>).
       */
      public static const GALLON_LIQUID_US:Unit = nonSI(CUBIC_INCH.times(231));
      
      /**
       * A unit of volume equal to <code>1 / 128 GALLON_LIQUID_US</code>
       * (standard name <code>oz_fl</code>).
       */
      public static const OUNCE_LIQUID_US:Unit = nonSI(GALLON_LIQUID_US
         .divide(128));
      
      /**
       * A unit of volume equal to one US dry gallon.
       * (standard name <code>gallon_dry_us</code>).
       */
      public static const GALLON_DRY_US:Unit = nonSI(CUBIC_INCH.times(2688025).divide(10000));
      
      /**
       * A unit of volume equal to <code>4.546 09 LITRE</code>
       * (standard name <code>gal_uk</code>).
       */
      public static const GALLON_UK:Unit = nonSI(LITRE.times(454609).divide(100000));
      
      /**
       * A unit of volume equal to <code>1 / 160 GALLON_UK</code>
       * (standard name <code>oz_fl_uk</code>).
       */
      public static const OUNCE_LIQUID_UK:Unit = nonSI(GALLON_UK.divide(160));

      /**
       * A unit of volume equal to <code>40 CUBIC_FOOT</code>.
       * (standard name <code>measurement_ton</code>).
       */
      public static const MEASUREMENT_TON:Unit = nonSI(CUBIC_FOOT.times(40))

      /**
       * Equivalent to <code>MEASUREMENT_TON</code>.
       */
      public static const FREIGHT_TON:Unit = MEASUREMENT_TON;
      
      ///////////////
      // Viscosity //
      ///////////////
      
      /**
       * A unit of dynamic viscosity equal to <code>1 g/(cm·s)</code>
       * (cgs unit).
       */
      public static const POISE:Unit = nonSI(SI.GRAM.divide(SI.CENTI(SI.METRE).times(SI.SECOND)));
      
      /**
       * A unit of kinematic viscosity equal to <code>1 cm²/s</code>
       * (cgs unit).
       */
      public static const STOKE:Unit = nonSI(SI.CENTI(SI.METRE).pow(2).divide(SI.SECOND));
      
      
      ////////////
      // Others //
      ////////////
      
      /**
       * A unit used to measure the ionizing ability of radiation
       * (standard name <code>Roentgen</code>).
       */
      public static const ROENTGEN:Unit = nonSI(SI.COULOMB.divide(SI.KILOGRAM).times(2.58e-4));
      
      /////////////////////
      // Collection View //
      /////////////////////
      
      /**
       * Returns the units defined in this class.
       *
       * @return the collection of SI units.
       */
      override public function get units():Vector.<Unit> {
         return UNITS;
      }
      
      /**
       * Adds a new unit to the collection.
       *
       * @param  unit the unit being added.
       * @return <code>unit</code>.
       */
      private static function nonSI(unit:Unit):* {
         UNITS.push(unit);
         return unit;
      }
   }
}
