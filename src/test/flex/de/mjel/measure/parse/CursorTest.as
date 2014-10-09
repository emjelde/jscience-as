/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.measure.parse {
   import de.mjel.measure.parse.Cursor;

   import org.flexunit.asserts.*;

   public class CursorTest {

      public function CursorTest() {
         super();
      }

      [Test]
      public function isAtEndOfString():void {
         const value:String = "test";

         var cursor:Cursor = new Cursor();
         cursor.index = value.length;  
         assertTrue("cursor at end", cursor.atEnd(value));
      }

      [Test]
      public function isAtLocationInString():void {
         const value:String = "test";
         const str:String = "st";
         const index:int = value.indexOf(str); 

         var cursor:Cursor = new Cursor();
         cursor.index = index;
         assertTrue("cursor at location", cursor.at(str, value));
      }

      [Test]
      public function nextCharInString():void {
         const value:String = "test";
         const str:String = "st";
         const index:int = value.indexOf(str); 

         var cursor:Cursor = new Cursor();
         cursor.index = index;
         assertEquals("next character", str.charAt(0), cursor.nextChar(value));
         assertEquals("cursor incremented", index + 1, cursor.index);
      }

      [Test]
      public function skipAnyInString():void {
         const value:String = "aaabbb";
         const str:String = "a";
         const index:int = value.indexOf("b"); 

         var cursor:Cursor = new Cursor();
         var result:Boolean = cursor.skipAny(str, value);
         assertTrue("cursor has skipped", result);
         assertEquals("cursor moved", index, cursor.index);
      }

      [Test]
      public function skipInString():void {
         const value:String = "this is a test";
         const str:String = "this is a ";
         const index:int = value.indexOf("test"); 

         var cursor:Cursor = new Cursor();
         var result:Boolean = cursor.skip(str, value);
         assertTrue("cursor has skipped", result);
         assertEquals("cursor moved", index, cursor.index);
      }

      [Test]
      public function nextTokenInString():void {
         const value:String = "this is a test";

         var cursor:Cursor = new Cursor();
         assertEquals("nextToken", "this", cursor.nextToken(value, " "));
         assertEquals("nextToken",   "is", cursor.nextToken(value, " "));
         assertEquals("nextToken",    "a", cursor.nextToken(value, " "));
         assertEquals("nextToken", "test", cursor.nextToken(value, " "));
         assertEquals("nextToken",   null, cursor.nextToken(value, " "));
      }

      [Test]
      public function incrementCursor():void {
         var cursor:Cursor = new Cursor();
         var index:int = cursor.index;
         cursor.increment();
         assertEquals("cursor incremented by 1", index + 1, cursor.index);
      }

      [Test]
      public function equalsCursor():void {
         assertTrue("cursor equals", new Cursor().equals(new Cursor()));
         assertFalse("cursor not equals", new Cursor().equals(null));
         assertFalse("cursor not equals", new Cursor().equals("null"));
      }

      [Test]
      public function resetCursor():void {
         var cursor:Cursor = new Cursor();
         cursor.index = 99;
         cursor.errorIndex = 99;
         cursor.reset();
         assertTrue("cursor reset", cursor.index != 99 && cursor.errorIndex != 99);
      }
   }
}
