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
   import de.mjel.measure.converter.UnitConverter;

   import org.flexunit.asserts.*;

   public class UnitTest {

      public function UnitTest() {
         super();
      }

      [Test]
      public function plus():void {
         assertEquals("ONE + 0 == ONE", Unit.ONE, Unit.ONE.plus(0));

         var expected:Unit = Unit.ONE;
         var actual:Unit = Unit.ONE.plus(1).plus(-1);
         assertTrue("(+1) + (+-1) == ONE", actual.equals(expected));
      }

      [Test(expected="ArgumentError")]
      public function timesError():void {
         Unit.ONE.times(undefined);
      }

      [Test]
      public function times():void {
         assertEquals("ONE * 1 == ONE", Unit.ONE, Unit.ONE.times(1));
         assertEquals("ONE * ONE == ONE", Unit.ONE, Unit.ONE.times(Unit.ONE));
      }

      [Test(expected="ArgumentError")]
      public function divideError():void {
         Unit.ONE.divide(undefined);
      }

      [Test]
      public function divide():void {
         assertEquals("ONE / 1 == ONE", Unit.ONE, Unit.ONE.divide(1));
         assertEquals("ONE / ONE == ONE", Unit.ONE, Unit.ONE.divide(Unit.ONE));

         const TIMES_TWO:Unit = Unit.ONE.times(2);

         var expected:Unit = TIMES_TWO;
         var actual:Unit = TIMES_TWO.times(TIMES_TWO).divide(TIMES_TWO);
         assertTrue("(*2²) / (*2) == *2", actual.equals(expected));
      }

      [Test]
      public function inverse():void {
         assertEquals(Unit.ONE, Unit.ONE.inverse());

         const TIMES_TWO:Unit = Unit.ONE.times(2);

         var expected:Unit = Unit.ONE.divide(TIMES_TWO);
         var actual:Unit = TIMES_TWO.inverse();
         assertTrue("((*2) / (ONE)).inverse == (ONE) / (*2)", actual.equals(expected));
      }

      [Test(expected="ArgumentError")]
      public function indeterminateRoot():void {
         Unit.ONE.root(0);
      }

      [Test]
      public function pow():void {
         assertEquals(Unit.ONE, Unit.ONE.pow(0));

         var expected:Unit = Unit.ONE;
         var actual:Unit = Unit.ONE.pow(1);
         assertTrue("+1^1 == ONE", actual.equals(expected));

         expected = Unit.ONE.times(Unit.ONE);
         actual = Unit.ONE.pow(2);
         assertTrue("+1^2 == ONE * ONE", actual.equals(expected));

         expected = Unit.ONE.times(Unit.ONE).times(Unit.ONE);
         actual = Unit.ONE.pow(3);
         assertTrue("+1^3 == ONE * ONE * ONE", actual.equals(expected));
      }

      [Test]
      public function root():void {
         var expected:Unit = Unit.ONE;
         var actual:Unit = Unit.ONE.root(1);
         assertTrue("ONE.root(1) == ONE", actual.equals(expected));

         expected = Unit.ONE.plus(2).pow(1/2);
         actual = Unit.ONE.root(2);
         assertTrue("ONE.root(2) == +2^(1/2)", actual.equals(expected));

         expected = Unit.ONE.plus(3).pow(1/2);
         actual = Unit.ONE.root(3);
         assertTrue("ONE.root(3) == +3^(1/2)", actual.equals(expected));
      }

      [Test]
      public function transform():void {
         var expected:Unit = Unit.ONE;
         var actual:Unit = Unit.ONE.transform(UnitConverter.IDENTITY);
         assertTrue("ONE.transform(IDENTITY) == ONE", actual.equals(expected));

         expected = Unit.ONE.plus(1);
         actual = Unit.ONE.transform(new AddConverter(1));
         assertTrue("ONE.transform(AddConverter(1)) == +1", actual.equals(expected));

         expected = Unit.ONE;
         actual = Unit.ONE.plus(1).transform(new AddConverter(-1));
         assertTrue("(+1).transform(AddConverter(-1)) == ONE", actual.equals(expected));
      }

      [Test]
      public function compound():void {
         assertNotNull(Unit.ONE.compound(Unit.ONE));
      }

      [Test]
      public function alternate():void {
         assertNotNull(Unit.ONE.alternate(null));
      }

      [Test]
      public function getConverterTo():void {
         assertEquals(UnitConverter.IDENTITY, Unit.ONE.getConverterTo(Unit.ONE));
         assertNotNull(Unit.ONE.getConverterTo(Unit.ONE.plus(1)));
      }

      [Test]
      public function isCompatible():void {
         assertTrue(Unit.ONE.isCompatible(Unit.ONE));
      }

      [Test]
      public function dimension():void {
         assertEquals(Dimension.NONE, Unit.ONE.dimension);
      }

      [Test]
      public function isStandardUnit():void {
         assertTrue(Unit.ONE.isStandardUnit);
      }

      [Test]
      public function toStandardUnit():void {
         assertEquals(UnitConverter.IDENTITY, Unit.ONE.toStandardUnit());
      }

      [Test]
      public function standardUnit():void {
         assertEquals(Unit.ONE, Unit.ONE.standardUnit);
      }

      [Test]
      public function equals():void {
         assertTrue(Unit.ONE.equals(Unit.ONE));
      }
   }
}
