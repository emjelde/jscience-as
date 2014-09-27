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

   public class LogConverterTest {

      public function LogConverterTest() {
         super();
      }

      [Test]
      public function logConverter():void {
         var base:Number = Math.E;
         var converter:LogConverter = new LogConverter(base);
         assertEquals(base, converter.base);

         //var expConverter:ExpConverter = new ExpConverter(base); 
         //assertEquals(base, expConverter.base);
      }

      [Test]
      public function inverse():void {
         var converter:LogConverter = new LogConverter(Math.E);
         assertTrue(Math.exp(Math.E), converter.inverse().convert(1));

         //var expConverter:ExpConverter = new ExpConverter(Math.exp(Math.E));
         //assertTrue(Math.E, converter.inverse().convert(1));
      }

      [Test]
      public function convert():void {
         var converter:LogConverter = new LogConverter(Math.E);
         assertTrue(Math.E, converter.convert(Math.exp(Math.E)));

         //var expConverter:ExpConverter = new ExpConverter(Math.exp(Math.E));
         //assertTrue(Math.exp(Math.E), expConverter.convert(Math.E));
      }

      [Test]
      public function isLinear():void {
         var converter:LogConverter = new LogConverter(Math.E);
         assertFalse(converter.isLinear());

         //var expConverter:ExpConverter = new ExpConverter(Math.E);
         //assertFalse(expConverter.isLinear());
      }

      [Test]
      public function equals():void {
         var a:LogConverter = new LogConverter(Math.E);
         var b:LogConverter = new LogConverter(Math.E);
         assertTrue(a.equals(b));

         //var c:ExpConverter = new ExpConverter(Math.E);
         //var d:ExpConverter = new ExpConverter(Math.E);
         //assertTrue(c.equals(d));
      }
   }
}
