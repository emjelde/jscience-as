/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.measure.unit {
   import org.flexunit.asserts.*;

   import de.mjel.measure.parse.ParsePosition;

   public class UnitFormatTest {

      public function UnitFormatTest() {
         super();
      }

      [Test(expected="ArgumentError")]
      public function invalidIdentifierLabel():void {
         var format:DefaultFormat = new DefaultFormat();  
         format.label(null, "");
      }

      [Test]
      public function setLabel():void {
         var label:String = "ONE";
         var format:DefaultFormat = new DefaultFormat();  

         // Before
         assertEquals(null, format.nameFor(Unit.ONE));
         assertEquals(null, format.unitFor(label));

         format.label(Unit.ONE, label);

         // After
         assertEquals(label, format.nameFor(Unit.ONE));
         assertEquals(Unit.ONE, format.unitFor(label));
      }

      [Test(expected="ArgumentError")]
      public function invalidIdentifierAlias():void {
         var format:DefaultFormat = new DefaultFormat();  
         format.alias(null, "");
      }

      [Test]
      public function setAlias():void {
         var label:String = "ONE";
         var format:DefaultFormat = new DefaultFormat();  

         // Before
         assertEquals(null, format.unitFor(label));

         format.alias(Unit.ONE, label);

         // After
         assertEquals(Unit.ONE, format.unitFor(label));
      }

      [Test]
      public function isValidIdentifier():void {
         var format:DefaultFormat = new DefaultFormat();
         assertFalse(format.isValidIdentifier(null));
         assertFalse(format.isValidIdentifier(""));
         for each (var c:String in ["0","1","2","3","4","5","6","7","8",
                                    "9","·","*","/","(",")","[","]","¹",
                                    "²","³","^","+","-"]) {
            assertFalse(c + " is not a valid identifier",format.isValidIdentifier(c));
         }
         assertTrue(format.isValidIdentifier("abcdefghijklmnopqrstuvwxyz"));
      }

      [Test]
      public function nameFor():void {
         var format:DefaultFormat = new DefaultFormat();
         assertEquals(null, format.nameFor(SI.METRE.divide(SI.SECOND)));
         assertEquals("BaseUnit", format.nameFor(new BaseUnit("BaseUnit")));
         assertEquals("(*)+2", format.nameFor(new BaseUnit("*").plus(2)));
         assertEquals("(*)*2", format.nameFor(new BaseUnit("*").times(2)));
         assertEquals("(*)/2", format.nameFor(new BaseUnit("*").divide(2)));
         assertEquals("+1:+2",
            format.nameFor(new CompoundUnit(Unit.ONE.plus(1), Unit.ONE.plus(2))));
         assertEquals("AlternateUnit",
            format.nameFor(new AlternateUnit("AlternateUnit", Unit.ONE)));
      }

      [Test]
      public function parseSingleUnit():void {
         var label:String = "ONE";
         var format:DefaultFormat = new DefaultFormat();  
         format.label(Unit.ONE, label);
         assertEquals(Unit.ONE, format.parseSingleUnit(label, new ParsePosition(0)));
      }

      [Test(expected="de.mjel.measure.parse.ParseError")]
      public function invalidParseSingleUnit():void {
         var label:String = "label";
         var format:DefaultFormat = new DefaultFormat();  
         // label never added to format should result in a ParseError
         format.parseSingleUnit(label, new ParsePosition(0));
      }

      [Test]
      public function parse():void {
         var format:DefaultFormat = new DefaultFormat();  
         format.label(Unit.ONE, "ONE");
         assertEquals(Unit.ONE.times(Unit.ONE), format.parseProductUnit("ONE*ONE", new ParsePosition(0)));
         assertEquals(Unit.ONE.divide(Unit.ONE), format.parseProductUnit("ONE/ONE", new ParsePosition(0)));
         assertEquals(Unit.ONE.pow(2), format.parseProductUnit("ONE^2", new ParsePosition(0)));
      }
   }
}
