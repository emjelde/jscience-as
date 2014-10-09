/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.physics.amount {
   import de.mjel.measure.unit.SI;
   import de.mjel.measure.unit.Unit;

   import org.flexunit.asserts.*;

   public class AmountTest {
      public function AmountTest() {
         super();
      }

      [Test]
      public function zeroAmount():void {
         assertEquals(0, Amount.ZERO.exactValue);
         assertEquals(Unit.ONE, Amount.ZERO.unit);
      }

      [Test]
      public function oneAmount():void {
         assertEquals(1, Amount.ONE.exactValue);
         assertEquals(Unit.ONE, Amount.ONE.unit);
      }

      [Test(expected="ArgumentError")]
      public function valueOfNegativeError():void {
         Amount.valueOf(0.1, null, -1);
      }

      [Test]
      public function valueOf():void {
         assertTrue("valueOf(0)", Amount.valueOf(0).equals(Amount.ZERO));
         assertTrue("valueOf(1)", Amount.valueOf(1).equals(Amount.ONE));
         assertEquals("valueOf(-1)", -1, Amount.valueOf(-1).exactValue);
//         assertEquals("valueOf(\"255\")", 255, Amount.valueOf("255").exactValue);

//         var actual:Amount;

//         actual = Amount.valueOf("255 m");
//         assertEquals("valueOf(\"255 m\").exactValue", 255, actual.exactValue);
//         assertEquals("valueOf(\"255 m\").unit", SI.METRE, actual.unit);
      }

      [Test]
      public function exact():void {
         assertTrue("255 is exact", Amount.valueOf(255).exact);
         assertFalse("1/3 is not exact", Amount.valueOf(1/3).exact);
      }

      [Test(expected="ArgumentError")]
      public function rangeOfError():void {
         var minimum:Number = -1;
         var maximum:Number = 1;
         Amount.rangeOf(maximum, minimum);
      }

      [Test]
      public function rangeOfAmount():void {
         var minimum:Number = -1;
         var maximum:Number = 1;
         var amount:Amount = Amount.rangeOf(minimum, maximum);
         assertEquals(minimum, amount.minimumValue);
         assertEquals(maximum, amount.maximumValue);
         assertFalse(amount.exact);
      }

      [Test]
      public function absoluteError():void {
         assertEquals(0, Amount.ZERO.absoluteError);
         assertEquals(0, Amount.ONE.absoluteError);

         var minimum:Number = -1;
         var maximum:Number = 1;
         var amount:Amount = Amount.rangeOf(minimum, maximum);
         assertEquals(Math.abs(maximum - minimum) * 0.5, amount.absoluteError);
      }

      [Test]
      public function relativeError():void {
         assertEquals(0, Amount.ZERO.relativeError);
         assertEquals(0, Amount.ONE.relativeError);

         var minimum:Number = -1;
         var maximum:Number = 1;
         var amount:Amount = Amount.rangeOf(minimum, maximum);
         assertEquals((maximum - minimum) / (minimum + maximum), amount.relativeError);
      }

      [Test]
      public function opposite():void {
         assertEquals(-1, Amount.ONE.opposite.exactValue);
         assertEquals(0, Amount.ZERO.opposite.exactValue);
      }

      [Test]
      public function toAmount():void {
         //assertEquals(Amount.ONE, Amount.ONE.to(Unit.ONE));
         //assertEquals(Amount.ZERO, Amount.ZERO.to(Unit.ONE));

         //TODO
      }

      [Test]
      public function plus():void {
         assertEquals(2, Amount.ONE.plus(Amount.ONE).exactValue);
      }
   }
}
