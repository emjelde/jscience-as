/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.measure {
   import de.mjel.measure.unit.SI;

   import org.flexunit.asserts.*;

   public class MeasureTest {

      public function MeasureTest() {
         super();
      }

      [Test]
      public function valueOf():void {
         assertTrue(Measure.valueOf(1, SI.METRE)
            .equals(Measure.valueOf("1 m")));
         assertEquals(null, Measure.valueOf(null));
      }

      [Test(expected="ArgumentError")]
      public function valueOfArgumentError():void {
         trace(Measure.valueOf("1 null"));
      }
   }
}
