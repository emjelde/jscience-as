/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.measure.parse {
   import org.flexunit.asserts.*;

   public class ParseTest {

      public function ParseTest() {
         super();
      }

      [Test]
      public function testParseError():void {
         var message:String = "message";
         var errorOffset:int = 10;
         var parseError:ParseError =
            new ParseError(message, errorOffset);

         assertEquals(message, parseError.message);
         assertEquals(errorOffset, parseError.errorOffset);
      }
   }
}
