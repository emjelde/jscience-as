/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.measure.converter {
   import org.flexunit.asserts.*;

   public class RationalConverterTest {

      public function RationalConverterTest() {
         super();
      }

      [Test(expected="ArgumentError")]
      public function negativeDivisor():void {
         new RationalConverter(1, -1); 
      }

      [Test(expected="ArgumentError")]
      public function identityConverter():void {
         new RationalConverter(1, 1); 
      }

      [Test]
      public function rationalConverter():void {
         var dividend:Number = 1;
         var divisor:Number = 2;
         var converter:RationalConverter = new RationalConverter(dividend, divisor); 
         assertEquals(dividend, converter.dividend);
         assertEquals(divisor, converter.divisor);
      }

      [Test]
      public function inverse():void {
         var dividend:Number = 1;
         var divisor:Number = 2;
         var converter:RationalConverter = new RationalConverter(dividend, divisor); 
         assertEquals(divisor, (converter.inverse() as RationalConverter).dividend);
         assertEquals(dividend, (converter.inverse() as RationalConverter).divisor);
      }

      [Test]
      public function convert():void {
         var dividend:Number = 1;
         var divisor:Number = 2;
         var amount:Number = 2;
         var converter:RationalConverter = new RationalConverter(dividend, divisor); 
         assertEquals(amount * dividend / divisor, converter.convert(amount));
      }

      [Test]
      public function isLinear():void {
         var converter:RationalConverter = new RationalConverter(1, 2); 
         assertTrue(converter.isLinear());
      }

      [Test]
      public function concatenate():void {
         var dividend:Number = 1;
         var divisor:Number = 2;
         var a:RationalConverter = new RationalConverter(dividend, divisor); 
         assertEquals(1 / 4, (a.concatenate(a) as RationalConverter).convert(1));

         var b:RationalConverter = new RationalConverter(2, 1); 
         assertEquals(RationalConverter.IDENTITY, a.concatenate(b));

         var factor:Number = 2;
         var c:MultiplyConverter = new MultiplyConverter(factor); 
         assertEquals(factor * dividend / divisor, a.concatenate(c).convert(1));

         var offset:Number = 2;
         var input:Number = 1;
         var d:AddConverter = new AddConverter(offset);
         assertEquals(a.convert(d.convert(input)), a.concatenate(d).convert(input));
      }

      [Test]
      public function equals():void {
         var a:RationalConverter = new RationalConverter(1, 2);
         var b:RationalConverter = new RationalConverter(1, 2);
         assertTrue(a.equals(b));
      }
   }
}
