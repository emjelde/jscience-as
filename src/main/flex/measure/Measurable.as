/*
 * JScience - Java(TM) Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2007 - JScience (http://jscience.org/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package measure {
   import measure.unit.Unit;

   /**
    * <p>This interface represents the measurable, countable, or comparable 
    *    property or aspect of a thing.</p>
    *     
    * <p>Implementing instances are typically the result of a measurement:<pre>
    *        Measurable weight = Measure.valueOf(180.0, POUND);
    *    </pre>
    *     
    * <p>Although measurable instances are for the most part scalar quantities; 
    *    more complex implementations (e.g. vectors, data set) are allowed as 
    *    long as an aggregate magnitude can be determined. For example:<pre>
    *    class Velocity3D implements Measurable {
    *         private var x:Number, y:Number, z:Number; // Meter per seconds.
    *         public var doubleValue(unit:Number) { ... } // Returns vector norm.
    *         ... 
    *    }
    *    class Sensors extends Measure {
    *         public function doubleValue(unit:Unit) { ... } // Returns median value. 
    *         ...
    *    }</pre></p>
    */
   public interface Measurable {
      /**
       * Returns the value of this measurable stated in the specified unit as 
       * a <code>Number</code>. If the measurable has too great a magnitude to 
       * be represented as a <code>double</code>, it will be converted to 
       * <code>Number.NEGATIVE_INFINITY</code> or
       * <code>Number.POSITIVE_INFINITY</code> as appropriate.
       * 
       * @param unit the unit in which this measurable value is stated.
       * @return the numeric value after conversion to type <code>Number</code>.
       */
      function value(unit:Unit):Number;
   }
}
