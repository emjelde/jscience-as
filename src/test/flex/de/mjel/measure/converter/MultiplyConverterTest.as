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

   public class MultiplyConverterTest {

      public function MultiplyConverterTest() {
         super();
      }

      [Test(expected="ArgumentError")]
      public function identityConverter():void {
         new MultiplyConverter(1); 
      }

      [Test]
      public function multiplyConverter():void {
         var factor:Number = 2;
         var converter:MultiplyConverter = new MultiplyConverter(factor); 
         assertEquals(factor, converter.factor);
      }

      [Test]
      public function inverse():void {
         var factor:Number = 2;
         var converter:MultiplyConverter = new MultiplyConverter(factor); 
         assertEquals(1 / factor, (converter.inverse() as MultiplyConverter).factor);
      }

      [Test]
      public function convert():void {
         var factor:Number = 2;
         var converter:MultiplyConverter = new MultiplyConverter(factor); 
         assertEquals(factor * factor, converter.convert(factor));
      }

      [Test]
      public function isLinear():void {
         var converter:MultiplyConverter = new MultiplyConverter(2); 
         assertTrue(converter.isLinear());
      }

      [Test]
      public function concatenate():void {
         var factor:Number = 2;
         var a:MultiplyConverter = new MultiplyConverter(factor); 
         assertEquals(factor * factor, (a.concatenate(a) as MultiplyConverter).factor);

         var b:RationalConverter = new RationalConverter(1, 2); 
         assertEquals(MultiplyConverter.IDENTITY, a.concatenate(b));

         var dividend:Number = 1;
         var divisor:Number = 4;
         var c:RationalConverter = new RationalConverter(dividend, divisor); 
         assertEquals(factor * dividend / divisor, (a.concatenate(c) as MultiplyConverter).factor);

         var offset:Number = 2;
         var input:Number = 1;
         var d:AddConverter = new AddConverter(offset);
         assertEquals(a.convert(d.convert(input)), a.concatenate(d).convert(input));
      }

      [Test]
      public function equals():void {
         var a:MultiplyConverter = new MultiplyConverter(2);
         var b:MultiplyConverter = new MultiplyConverter(2);
         assertTrue(a.equals(b));
      }
   }
}
