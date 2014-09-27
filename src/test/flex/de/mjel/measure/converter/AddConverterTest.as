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

   public class AddConverterTest {

      public function AddConverterTest() {
         super();
      }

      [Test(expected="ArgumentError")]
      public function identityConverterZeroOffset():void {
         new AddConverter(0.0);
      }

      [Test(expected="ArgumentError")]
      public function identityConverterNaNOffset():void {
         new AddConverter(Number.NaN);
      }

      [Test]
      public function inverse():void {
         var converter:AddConverter = new AddConverter(1);
         assertEquals(-1, (converter.inverse() as AddConverter).offset);
      }

      [Test]
      public function convert():void {
         var converter:AddConverter = new AddConverter(1);
         assertEquals(0, converter.convert(-1));
      }

      [Test]
      public function isLinear():void {
         var converter:AddConverter = new AddConverter(1);
         assertFalse(converter.isLinear());
      }

      [Test]
      public function concatenate():void {
         var a:AddConverter = new AddConverter(1);
         var b:AddConverter = new AddConverter(2);
         assertEquals(3, (a.concatenate(b) as AddConverter).offset);

         var c:AddConverter = new AddConverter(3);
         var d:AddConverter = new AddConverter(-3);
         assertEquals(AddConverter.IDENTITY, c.concatenate(d));
         assertEquals(c, c.concatenate(AddConverter.IDENTITY));
      }

      [Test]
      public function equals():void {
         var a:AddConverter = new AddConverter(1);
         var b:AddConverter = new AddConverter(1);
         assertTrue(a.equals(b));
      }
   }
}
