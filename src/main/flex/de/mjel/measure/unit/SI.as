/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.measure.unit {
   import de.mjel.measure.converter.MultiplyConverter;
   import de.mjel.measure.converter.RationalConverter;
      
   /**
    * <p>This class contains SI (Système International d'Unités) base units,
    *    and derived units.</p>
    *     
    * <p>It also defines the 20 SI prefixes used to form decimal multiples and
    *    submultiples of SI units. For example:<pre>
    *    HECTO_PASCAL:Unit = HECTO(PASCAL);
    *    KILO_METER:Unit = KILO(METER);
    *    </pre></p>
    */
   final public class SI extends SystemOfUnits {
      public function SI() {
         super();
      }

      /**
       * Holds collection of SI units.
       */
      private static const UNITS:Vector.<Unit> = new Vector.<Unit>();
      private static const INSTANCE:SI = new SI();
       
      /**
       * Returns the unique instance of this class.
       */
      public static function getInstance():SI {
         return INSTANCE;
      }
      
      ////////////////
      // BASE UNITS //
      ////////////////
      
      /**
       * The base unit for electric current quantities (<code>A</code>).
       * The Ampere is that constant current which, if maintained in two straight
       * parallel conductors of infinite length, of negligible circular
       * cross-section, and placed 1 metre apart in vacuum, would produce between
       * these conductors a force equal to 2 × 10-7 newton per metre of length.
       * It is named after the French physicist Andre Ampere (1775-1836).
       */
      public static const AMPERE:BaseUnit = si(new BaseUnit("A"));
      
      /**
       * The base unit for luminous intensity quantities (<code>cd</code>).
       * The candela is the luminous intensity, in a given direction,
       * of a source that emits monochromatic radiation of frequency
       * 540 × 1012 hertz and that has a radiant intensity in that
       * direction of 1/683 watt per steradian
       * @see <a href="http://en.wikipedia.org/wiki/Candela"> 
       *      Wikipedia: Candela</a>
       */
      public static const CANDELA:BaseUnit = si(new BaseUnit("cd"));
      
      /**
       * The base unit for thermodynamic temperature quantities (<code>K</code>).
       * The kelvin is the 1/273.16th of the thermodynamic temperature of the
       * triple point of water. It is named after the Scottish mathematician and
       * physicist William Thomson 1st Lord Kelvin (1824-1907)
       */
      public static const KELVIN:BaseUnit = si(new BaseUnit("K"));
      
      /**
       * The base unit for mass quantities (<code>kg</code>).
       * It is the only SI unit with a prefix as part of its name and symbol.
       * The kilogram is equal to the mass of an international prototype in the
       * form of a platinum-iridium cylinder kept at Sevres in France.
       */
      public static const KILOGRAM:BaseUnit = si(new BaseUnit("kg"));
      
      /**
       * The base unit for length quantities (<code>m</code>).
       * One meter was redefined in 1983 as the distance traveled by light in
       * a vacuum in 1/299,792,458 of a second.
       */
      public static const METRE:BaseUnit = si(new BaseUnit("m"));
      
      /**
       * Equivalent to <code>METRE</code> (American spelling).
       */
      public static const METER:Unit = METRE;
      
      /**
       * The base unit for amount of substance quantities (<code>mol</code>).
       * The mole is the amount of substance of a system which contains as many
       * elementary entities as there are atoms in 0.012 kilogram of carbon 12.
       */
      public static const MOLE:BaseUnit = si(new BaseUnit("mol"));
      
      /**
       * The base unit for duration quantities (<code>s</code>).
       * It is defined as the duration of 9,192,631,770 cycles of radiation
       * corresponding to the transition between two hyperfine levels of
       * the ground state of cesium (1967 Standard).
       */
      public static const SECOND:BaseUnit = si(new BaseUnit("s"));
      
      
      ////////////////////////////////
      // SI DERIVED ALTERNATE UNITS //
      ////////////////////////////////
      
      /**
       * The derived unit for mass quantities (<code>g</code>).
       * The base unit for mass quantity is <code>KILOGRAM</code>.
       */
      public static const GRAM:Unit = KILOGRAM.divide(1000);
      
      /**
       * The unit for plane angle quantities (<code>rad</code>).
       * One radian is the angle between two radii of a circle such that the
       * length of the arc between them is equal to the radius.
       */
      public static const RADIAN:AlternateUnit = si(new AlternateUnit("rad", Unit.ONE));
      
      /**
       * The unit for solid angle quantities (<code>sr</code>).
       * One steradian is the solid angle subtended at the center of a sphere by
       * an area on the surface of the sphere that is equal to the radius squared.
       * The total solid angle of a sphere is 4*Pi steradians.
       */
      public static const STERADIAN:AlternateUnit = si(new AlternateUnit("sr", Unit.ONE));
      
      /**
       * The unit for binary information (<code>bit</code>).
       */
      public static const BIT:AlternateUnit = si(new AlternateUnit("bit", Unit.ONE));
      
      /**
       * The derived unit for frequency (<code>Hz</code>).
       * A unit of frequency equal to one cycle per second.
       * After Heinrich Rudolf Hertz (1857-1894), German physicist who was the
       * first to produce radio waves artificially.
       */
      public static const HERTZ:AlternateUnit = si(new AlternateUnit("Hz", Unit.ONE.divide(SECOND)));
      
      /**
       * The derived unit for force (<code>N</code>).
       * One newton is the force required to give a mass of 1 kilogram an Force
       * of 1 metre per second per second. It is named after the English
       * mathematician and physicist Sir Isaac Newton (1642-1727).
       */
      public static const NEWTON:AlternateUnit = si(new AlternateUnit("N", METRE.times(KILOGRAM).divide(SECOND.pow(2))));
      
      /**
       * The derived unit for pressure, stress (<code>Pa</code>).
       * One pascal is equal to one newton per square meter. It is named after
       * the French philosopher and mathematician Blaise Pascal (1623-1662).
       */
      public static const PASCAL:AlternateUnit = si(new AlternateUnit("Pa", NEWTON.divide(METRE.pow(2))));
      
      /**
       * The derived unit for energy, work, quantity of heat (<code>J</code>).
       * One joule is the amount of work done when an applied force of 1 newton
       * moves through a distance of 1 metre in the direction of the force.
       * It is named after the English physicist James Prescott Joule (1818-1889).
       */
      public static const JOULE:AlternateUnit = si(new AlternateUnit("J", NEWTON.times(METRE)));
      
      /**
       * The derived unit for power, radiant, flux (<code>W</code>).
       * One watt is equal to one joule per second. It is named after the British
       * scientist James Watt (1736-1819).
       */
      public static const WATT:AlternateUnit = si(new AlternateUnit("W", JOULE.divide(SECOND)));
      
      /**
       * The derived unit for electric charge, quantity of electricity
       * (<code>C</code>).
       * One Coulomb is equal to the quantity of charge transferred in one second
       * by a steady current of one ampere. It is named after the French physicist
       * Charles Augustin de Coulomb (1736-1806).
       */
      public static const COULOMB:AlternateUnit = si(new AlternateUnit("C", SECOND.times(AMPERE)));
      
      /**
       * The derived unit for electric potential difference, electromotive force
       * (<code>V</code>).
       * One Volt is equal to the difference of electric potential between two
       * points on a conducting wire carrying a constant current of one ampere
       * when the power dissipated between the points is one watt. It is named
       * after the Italian physicist Count Alessandro Volta (1745-1827).
       */
      public static const VOLT:AlternateUnit = si(new AlternateUnit("V", WATT.divide(AMPERE)));
      
      /**
       * The derived unit for capacitance (<code>F</code>).
       * One Farad is equal to the capacitance of a capacitor having an equal
       * and opposite charge of 1 coulomb on each plate and a potential difference
       * of 1 volt between the plates. It is named after the British physicist
       * and chemist Michael Faraday (1791-1867).
       */
      public static const FARAD:AlternateUnit = si(new AlternateUnit("F", COULOMB.divide(VOLT)));
      
      /**
       * The derived unit for electric resistance (<code>Ω</code> or 
       * <code>Ohm</code>).
       * One Ohm is equal to the resistance of a conductor in which a current of
       * one ampere is produced by a potential of one volt across its terminals.
       * It is named after the German physicist Georg Simon Ohm (1789-1854).
       */
      public static const OHM:AlternateUnit = si(new AlternateUnit("Ω", VOLT.divide(AMPERE)));
      
      /**
       * The derived unit for electric conductance (<code>S</code>).
       * One Siemens is equal to one ampere per volt. It is named after
       * the German engineer Ernst Werner von Siemens (1816-1892).
       */
      public static const SIEMENS:AlternateUnit = si(new AlternateUnit("S", AMPERE.divide(VOLT)));
      
      /**
       * The derived unit for magnetic flux (<code>Wb</code>).
       * One Weber is equal to the magnetic flux that in linking a circuit of one
       * turn produces in it an electromotive force of one volt as it is uniformly
       * reduced to zero within one second. It is named after the German physicist
       * Wilhelm Eduard Weber (1804-1891).
       */
      public static const WEBER:AlternateUnit = si(new AlternateUnit("Wb", VOLT.times(SECOND)));
      
      /**
       * The derived unit for magnetic flux density (<code>T</code>).
       * One Tesla is equal equal to one weber per square meter. It is named
       * after the Serbian-born American electrical engineer and physicist
       * Nikola Tesla (1856-1943).
       */
      public static const TESLA:AlternateUnit = si(new AlternateUnit("T", WEBER.divide(METRE.pow(2))));
      
      /**
       * The derived unit for inductance (<code>H</code>).
       * One Henry is equal to the inductance for which an induced electromotive
       * force of one volt is produced when the current is varied at the rate of
       * one ampere per second. It is named after the American physicist
       * Joseph Henry (1791-1878).
       */
      public static const HENRY:AlternateUnit = si(new AlternateUnit("H", WEBER.divide(AMPERE)));
      
      /**
       * The derived unit for Celsius temperature (<code>℃</code>).
       * This is a unit of temperature such as the freezing point of water
       * (at one atmosphere of pressure) is 0 ℃, while the boiling point is
       * 100 ℃.
       */
      public static const CELSIUS:Unit = si(KELVIN.plus(273.15));
      
      /**
       * The derived unit for luminous flux (<code>lm</code>).
       * One Lumen is equal to the amount of light given out through a solid angle
       * by a source of one candela intensity radiating equally in all directions.
       */
      public static const LUMEN:AlternateUnit = si(new AlternateUnit("lm", CANDELA.times(STERADIAN)));
      
      /**
       * The derived unit for illuminance (<code>lx</code>).
       * One Lux is equal to one lumen per square meter.
       */
      public static const LUX:AlternateUnit = si(new AlternateUnit("lx", LUMEN.divide(METRE.pow(2))));
      
      /**
       * The derived unit for activity of a radionuclide (<code>Bq</code>).
       * One becquerel is the radiation caused by one disintegration per second.
       * It is named after the French physicist, Antoine-Henri Becquerel
       * (1852-1908).
       */
      public static const BECQUEREL:AlternateUnit = si(new AlternateUnit("Bq", Unit.ONE.divide(SECOND)));
      
      /**
       * The derived unit for absorbed dose, specific energy (imparted), kerma
       * (<code>Gy</code>).
       * One gray is equal to the dose of one joule of energy absorbed per one
       * kilogram of matter. It is named after the British physician
       * L. H. Gray (1905-1965).
       */
      public static const GRAY:AlternateUnit = si(new AlternateUnit("Gy", JOULE.divide(KILOGRAM)));
      
      /**
       * The derived unit for dose equivalent (<code>Sv</code>).
       * One Sievert is equal  is equal to the actual dose, in grays, multiplied
       * by a "quality factor" which is larger for more dangerous forms of
       * radiation. It is named after the Swedish physicist Rolf Sievert
       * (1898-1966).
       */
      public static const SIEVERT:AlternateUnit = si(new AlternateUnit("Sv", JOULE.divide(KILOGRAM)));
      
      /**
       * The derived unit for catalytic activity (<code>kat</code>).
       */
      public static const KATAL:AlternateUnit = si(new AlternateUnit("kat", MOLE.divide(SECOND)));
      
      //////////////////////////////
      // SI DERIVED PRODUCT UNITS //
      //////////////////////////////
      
      /**
       * The metric unit for velocity quantities (<code>m/s</code>).
       */
      public static const METRES_PER_SECOND:Unit = si(new ProductUnit(METRE.divide(SECOND)));
      
      /**
       * Equivalent to <code>METRES_PER_SECOND</code>.
       */
      public static const METERS_PER_SECOND:Unit = METRES_PER_SECOND;
      
      /**
       * The metric unit for acceleration quantities (<code>m/s²</code>).
       */
      public static const METRES_PER_SQUARE_SECOND:Unit = si(new ProductUnit(METRES_PER_SECOND.divide(SECOND)));
      
      /**
       * Equivalent to <code>METRES_PER_SQUARE_SECOND</code>.
       */
      public static const METERS_PER_SQUARE_SECOND:Unit = METRES_PER_SQUARE_SECOND;
      
      /**
       * The metric unit for area quantities (<code>m²</code>).
       */
      public static const SQUARE_METRE:Unit = si(new ProductUnit(METRE.times(METRE)));
      
      /**
       * The metric unit for volume quantities (<code>m³</code>).
       */
      public static const CUBIC_METRE:Unit = si(new ProductUnit(SQUARE_METRE.times(METRE)));
      
      /**
       * Equivalent to <code>KILO(METRE)</code>.
       */
      public static const KILOMETRE:Unit = METER.times(1000);
      
      /**
       * Equivalent to <code>KILOMETRE</code>.
       */
      public static const KILOMETER:Unit = KILOMETRE;
      
      /**
       * Equivalent to <code>CENTI(METRE)</code>.
       */
      public static const CENTIMETRE:Unit = METRE.divide(100);
      
      /**
       * Equivalent to <code>CENTIMETRE</code>.
       */
      public static const CENTIMETER:Unit = CENTIMETRE;
      
      /**
       * Equivalent to <code>MILLI(METRE)</code>.
       */
      public static const MILLIMETRE:Unit = METRE.divide(1000);
      
      /**
       * Equivalent to <code>MILLIMETRE</code>.
       */
      public static const MILLIMETER:Unit = MILLIMETRE;
      
      /////////////////
      // SI PREFIXES //
      /////////////////
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>24</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e24)</code>.
       */
      public static function YOTTA(unit:Unit):Unit {
         return unit.transform(E24);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>21</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e21)</code>.
       */
      public static function ZETTA(unit:Unit):Unit {
         return unit.transform(E21);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>18</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e18)</code>.
       */
      public static function EXA(unit:Unit):Unit {
         return unit.transform(E18);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>15</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e15)</code>.
       */
      public static function PETA(unit:Unit):Unit {
         return unit.transform(E15);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>12</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e12)</code>.
       */
      public static function TERA(unit:Unit):Unit {
         return unit.transform(E12);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>9</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e9)</code>.
       */
      public static function GIGA(unit:Unit):Unit {
         return unit.transform(E9);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>6</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e6)</code>.
       */
      public static function MEGA(unit:Unit):Unit {
         return unit.transform(E6);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>3</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e3)</code>.
       */
      public static function KILO(unit:Unit):Unit {
         return unit.transform(E3);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>2</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e2)</code>.
       */
      public static function HECTO(unit:Unit):Unit {
         return unit.transform(E2);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>1</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e1)</code>.
       */
      public static function DEKA(unit:Unit):Unit {
         return unit.transform(E1);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>-1</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e-1)</code>.
       */
      public static function DECI(unit:Unit):Unit {
         return unit.transform(Em1);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>-2</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e-2)</code>.
       */
      public static function CENTI(unit:Unit):Unit {
         return unit.transform(Em2);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>-3</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e-3)</code>.
       */
      public static function MILLI(unit:Unit):Unit {
         return unit.transform(Em3);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>-6</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e-6)</code>.
       */
      public static function MICRO(unit:Unit):Unit {
         return unit.transform(Em6);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>-9</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e-9)</code>.
       */
      public static function NANO(unit:Unit):Unit {
         return unit.transform(Em9);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>-12</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e-12)</code>.
       */
      public static function PICO(unit:Unit):Unit {
         return unit.transform(Em12);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>-15</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e-15)</code>.
       */
      public static function FEMTO(unit:Unit):Unit {
         return unit.transform(Em15);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>-18</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e-18)</code>.
       */
      public static function ATTO(unit:Unit):Unit {
         return unit.transform(Em18);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>-21</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e-21)</code>.
       */
      public static function ZEPTO(unit:Unit):Unit {
         return unit.transform(Em21);
      }
      
      /**
       * Returns the specified unit multiplied by the factor
       * <code>10<sup>-24</sup></code>
       *
       * @param  unit any unit.
       * @return <code>unit.multiply(1e-24)</code>.
       */
      public static function YOCTO(unit:Unit):Unit {
         return unit.transform(Em24);
      }
      
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
      private static function si(unit:Unit):* {
         UNITS.push(unit);
         return unit;
      }
      
      // Holds prefix converters (optimization).
      
      internal static const  E24:MultiplyConverter = new MultiplyConverter(1E24);
      internal static const  E21:MultiplyConverter = new MultiplyConverter(1E21);
      internal static const  E18:RationalConverter = new RationalConverter(1000000000000000000, 1);
      internal static const  E15:RationalConverter = new RationalConverter(1000000000000000, 1);
      internal static const  E12:RationalConverter = new RationalConverter(1000000000000, 1);
      internal static const   E9:RationalConverter = new RationalConverter(1000000000, 1);
      internal static const   E6:RationalConverter = new RationalConverter(1000000, 1);
      internal static const   E3:RationalConverter = new RationalConverter(1000, 1);
      internal static const   E2:RationalConverter = new RationalConverter(100, 1);
      internal static const   E1:RationalConverter = new RationalConverter(10, 1);
      internal static const  Em1:RationalConverter = new RationalConverter(1, 10);
      internal static const  Em2:RationalConverter = new RationalConverter(1, 100);
      internal static const  Em3:RationalConverter = new RationalConverter(1, 1000);
      internal static const  Em6:RationalConverter = new RationalConverter(1, 1000000);
      internal static const  Em9:RationalConverter = new RationalConverter(1, 1000000000);
      internal static const Em12:RationalConverter = new RationalConverter(1, 1000000000000);
      internal static const Em15:RationalConverter = new RationalConverter(1, 1000000000000000);
      internal static const Em18:RationalConverter = new RationalConverter(1, 1000000000000000000);
      internal static const Em21:MultiplyConverter = new MultiplyConverter(1E-21);
      internal static const Em24:MultiplyConverter = new MultiplyConverter(1E-24);
   }
}
