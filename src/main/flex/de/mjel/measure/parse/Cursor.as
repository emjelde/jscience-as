/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.measure.parse {

   /**
    * <p>This class represents a parsing cursor over characters. Cursor
    *    allows for token iterations over any String.
    *    <code>
    *    var value:String = "this is a test";
    *    var cursor:Cursor = Cursor.newInstance();
    *    for (var token; (token = cursor.nextToken(value, ' ')) != null;)
    *        trace(token);
    *    </code>
    *    Prints the following output:<pre>
    *       this
    *       is
    *       a
    *       test</pre>
    */
   public class Cursor extends ParsePosition {

      /**
       * Default constructor.
       */
      public function Cursor() {
         super(0);
      }

      /**
       * Indicates if this cursor points to the end of the specified string. 
       *
       * @param value the value iterated by this cursor.
       * @return <code>getIndex() &gt;= value.length</code>
       */
      public function atEnd(value:String):Boolean {
         return getIndex() >= value.length;
      }

      /**
       * Indicates if this cursor points to the specified character(s) in the
       * specified string.
       *
       * @param str the character(s) to test.
       * @param value the string iterated by this cursor.
       * @return <code>true</code> if this cursor points to the specified
       *         character(s); <code>false</code> otherwise.
       */
      public function at(str:String, value:String):Boolean {
         var i:int = getIndex();
         var length:int = str.length;
         if (length == 1) {
            return (i < value.length)
               ? (value.charAt(i) == str)
               : false;
         }
         else {
            for (var j:int = 0; j < str.length;) {
               if ((i >= length) || (str.charAt(j++) != value.charAt(i++))) {
                  return false;
               }
            }
         }
         return true;
      }

      /**
       * Returns the next character at this cursor position. The cursor
       * position is incremented by one.
       *
       * @param value the string iterated by this cursor.
       * @return the next character this cursor points to.
       */
      public function nextChar(value:String):String {
         var i:int = getIndex();
         setIndex(i + 1);
         return value.charAt(i);
      }

      /**
       * Moves this cursor forward until it points to a character
       * different from the specified character.
       *
       * @param c the character to skip.
       * @param value the string iterated by this cursor.
       * @return <code>true</code> if this cursor has skipped at least one 
       *         character;<code>false</code> otherwise (e.g. end of sequence
       *         reached).
       */
      public function skipAny(str:String, value:String):Boolean {
         var i:int = getIndex();
         var n:int = value.length;
         while ((i < n) && (value.charAt(i) == str)) {
            i++;
         }
         if (i == getIndex()) {
            return false; // Cursor not moved.
         }
         setIndex(i);
         return true;
      }

      /**
       * Moves this cursor forward only if at the specified string.
       *
       * @param str the string to skip.
       * @param value the string iterated by this cursor.
       * @return <code>true</code> if this cursor has skipped the specified
       *         character;<code>false</code> otherwise.
       */
      public function skip(str:String, value:String):Boolean {
         if (at(str, value)) {
            increment(str.length);
            return true;
         }
         return false;
      }

      /**
       * Returns the subsequence from the specified cursor position not holding
       * the specified character. For example:<code>
       *    var value:String = "This is a test";
       *    for (var token:String; (token = cursor.nextToken(value, ' ')) != null;) {
       *       trace(token); // one word at a time.
       *    }</code>
       *
       * @param value the string iterated by this cursor.
       * @param str the character(s) being skipped.
       * @return the subsequence not holding the specified character or
       *         <code>null</code> if none.
       */
      public function nextToken(value:String, str:String):String {
         var n:int = value.length;
         for (var i:int = getIndex(); i < n; i++) {
            if (str.indexOf(value.charAt(i)) == -1) {
               var j:int = i;
               for (; (++j < n) && (value.charAt(j) != str);) {
                  // Loop until j at the end of sequence or at specified character.
               }
               setIndex(j);
               return value.substring(i, j);
            }
         }
         setIndex(n);
         return null;
      }

      /**
       * Increments the cursor index by the specified value.
       *
       * @param i the increment value.
       * @return <code>this</code>
       */
      public function increment(i:int=1):Cursor {
         setIndex(getIndex() + i);
         return this;
      }

      /**
       * Returns the string representation of this cursor.
       *
       * @return the index value as a string.
       */
      override public function toString():String {
         return "Index: " + getIndex();
      }

      /**
       * Indicates if this cursor is equals to the specified object.
       *
       * @return <code>true</code> if the specified object is a cursor
       *         at the same index; <code>false</code> otherwise.
       */
      public function equals(that:Object):Boolean {
         if (that == null) {
            return false;
         }
         if (!(that is Cursor)) {
            return false;
         }
         return getIndex() == (that as Cursor).getIndex();
      }

      /**
       * Resets this cursor instance.
       */
      public function reset():void {
         super.setIndex(0);
         super.setErrorIndex(-1);
      }
   }
}
