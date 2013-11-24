/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.physics.amount {

// TODO
//   import de.mjel.economics.money.Currency;
//   import de.mjel.economics.money.Money;

   import de.mjel.measure.unit.Unit;
   import de.mjel.measure.unit.UnitFormat;

   [Abstract]

   /**
    * This class provides the interface for formatting and parsing Amount instances.
    */
   public class AmountFormat /*extends TextFormat*/ {

      /**
       * Holds current format.
       */
      private static var _CURRENT:AmountFormat;

      public static function get CURRENT():AmountFormat {
         if (_CURRENT == null) {
            _CURRENT = new PlusMinusError(2);
         }
         return _CURRENT;
      }

      public static function set CURRENT(value:AmountFormat):void {
         _CURRENT = value;
      }

      /**
       * @private
       */
      public function AmountFormat() {
         super();
      }

      /**
       * Returns the current local format
       * (default <code>AmountFormat.getPlusMinusErrorInstance(2)</code>).
       *
       * @return the context local format.
       */
      public static function getInstance():AmountFormat {
         return CURRENT;
      }

      /**
       * Sets the current {@link javolution.context.LocalContext local} format.
       *
       * @param format the new format.
       */
      public static function setInstance(AmountFormat format):void {
         CURRENT = format;
      }

      /**
       * Returns a format for which the error (if present) is stated using 
       * the "±" character; for example <code>"(1.34 ± 0.01) m"</code>.
       * This format can be used for formatting as well as for parsing.
       * 
       * @param digitsInError the maximum number of digits in error.
       */
      public static function getPlusMinusErrorInstance(digitsInError:int):AmountFormat {
         return new PlusMinusError(digitsInError);
      }

      /**
       * Returns a format for which the error is represented by an integer 
       * value in brackets; for example <code>"1.3456[20] m"</code> 
       * is equivalent to <code>"1.3456 ± 0.0020 m"</code>. 
       * This format can be used for formatting as well as for parsing.
       * 
       * @param digitsInError the maximum number of digits in error.
       */
      public static function getBracketErrorInstance(digitsInError:int):AmountFormat {
         return new BracketError(digitsInError);
      }

      /**
       * Returns a format for which only digits guaranteed to be exact are 
       * written out. In other words, the error is always on the
       * last digit and less than the last digit weight. For example,
       * <code>"1.34 m"</code> means a length between <code>1.32 m</code> and
       * <code>1.35 m</code>. This format can be used for formatting only.
       */
      public static function getExactDigitsInstance():AmountFormat {
         return new ExactDigitsOnly();
      }

      [Abstract]
      public function parse(value:String, cursor:Cursor=null):Amount {
         return null;
      }
   }
}

/**
 * This class represents the plus minus error format.
 */
class PlusMinusError extends AmountFormat {

   /**
    * Holds the number of digits in error.
    */
   private var _errorDigits:int;

   /**
    * Creates a plus-minus error format having the specified 
    * number of digits in error.
    * 
    * @param errorDigits the number of digits in error.
    */
   public function PlusMinusError(int errorDigits) {
      _errorDigits = errorDigits;
   }

   override public function format(Amount amount, Appendable appendable):Appendable {
// TODO
//      if (amount.getUnit() is Currency) {
//         return formatMoney(amount, appendable);
//      }
      if (amount.exact) {
         TypeFormat.format(amount.exactValue, appendable);
         appendable.append(" ");
         return UnitFormat.getInstance().format(amount.getUnit(), appendable);
      }
      var value:Number = amount.estimatedValue;
      var error:Number = amount.absoluteError;
      var log10Value:int = int(Math.floor(Math.log(Math.abs(value)) * Math.LOG10E));
      var log10Error:int = int(Math.floor(Math.log(error) * Math.LOG10E));
      var digits:int = log10Value - log10Error - 1; // Exact digits.
      digits = Math.max(1, digits + _errorDigits);

      var scientific:Boolean = (Math.abs(value) >= 1E6) || (Math.abs(value) < 1E-6);
      var showZeros:Boolean = false;
      appendable.append("(");
      TypeFormat.format(value, digits, scientific, showZeros, appendable);
      appendable.append(" ± ");
      scientific = (Math.abs(error) >= 1E6) || (Math.abs(error) < 1E-6);
      showZeros = true;
      TypeFormat.format(error, _errorDigits, scientific, showZeros, appendable);
      appendable.append(") ");
      return UnitFormat.getInstance().format(amount.getUnit(), appendable);
   }

   override public function parse(arg0:String, arg1:Cursor):Amount {
      if (arg1 == null) {
         arg1 = new Cursor();
      }
      var start:int = arg1.getIndex();
      try {
         arg1.skip("(", arg0);
         var value:Number = TypeFormat.parseLong(arg0, 10, arg1);
         if (arg0.charAt(arg1.getIndex()) == " ") { // Exact! 
            arg1.skip(" ", arg0);
            var unit:Unit = UnitFormat.getInstance().parseProductUnit(arg0, arg1);
            return Amount.valueOf(value, unit);
         }
         arg1.setIndex(start);
         var amount:Number = TypeFormat.parseNumber(arg0, arg1);
         arg1.skip(" ", arg0);
         var error:Number = 0;
         if (arg0.charAt(arg1.getIndex()) == "±") { // Error specified. 
            arg1.skip("±", arg0);
            arg1.skip(" ", arg0);
            error = TypeFormat.parseDouble(arg0, arg1);
         }
         arg1.skip(")", arg0);
         arg1.skip(" ", arg0);
         var unit:Unit = UnitFormat.getInstance().parseProductUnit(arg0, arg1);
         return Amount.valueOf(amount, error, unit);
      }
// TODO: Fix error type
      catch (e:Error/*ParseException*/) {
         arg1.setIndex(start);
         arg1.setErrorIndex(e.getErrorOffset());
         return null;
      }
   }
}

/**
 * This class represents the bracket error format.
 */
class BracketError extends AmountFormat {

   /**
    * Holds the number of digits in error.
    */
   private var _errorDigits:int;

   /**
    * Creates a bracket error format having the specified 
    * number of digits in error.
    * 
    * @param bracket the number of digits in error.
    */
   private function BracketError(errorDigits:int) {
      _errorDigits = errorDigits;
   }

   override public function format(arg0:Amount, arg1:Appendable):Appendable {
// TODO
//      if (arg0.getUnit() instanceof Currency) {
//         return formatMoney(arg0, arg1);
//      }
      if (arg0.exact) {
         TypeFormat.format(arg0.getExactValue(), arg1);
         arg1.append(" ");
         return UnitFormat.getInstance().format(arg0.getUnit(), arg1);
      }
      var value:Number = arg0.getEstimatedValue();
      var error:Number = arg0.getAbsoluteError();
      var log10Value:int = int(Math.floor(Math.log(MathLib.abs(value)) * Math.LOG10E));
      var log10Error:int = int(Math.floor(Math.log(error) * Math.LOG10E));
      var digits:int = log10Value - log10Error - 1; // Exact digits.
      digits = Math.max(1, digits + _errorDigits);

      boolean scientific = (MathLib.abs(value) >= 1E6) || (MathLib.abs(value) < 1E-6);
      boolean showZeros = true;
      //TextBuilder tb = TextBuilder.newInstance();
      var tb:Appendable = new Appendable()
      TypeFormat.formatNumber(tb, value, digits, scientific, showZeros);
      var endMantissa:int = 0;
      for (; endMantissa < tb.length; endMantissa++) {
         //if (tb.charAt(endMantissa) == "E") {
         if (tb.toString().charAt(endMantissa) == "E") {
            break;
         }
      }
      var bracketError:int = int((error * Math.pow(1, -log10Error + _errorDigits - 1)));
      //tb.insert(endMantissa, Text.valueOf("[").plus(Text.valueOf(bracketError)).plus("]"));
      var str2:String = "[" + bracketError.toString() + "]";
      tb = new Appendable(str2.slice(0, endMantissa) + tb.toString() + str2.slice(endMantissa)); 

      arg1.append(tb.toString());
      arg1.append(" ");
      return UnitFormat.getInstance().format(arg0.getUnit(), arg1);
   }

   override public function parse(arg0:String, arg1:Cursor):Amount {
      // TBD
      throw new Error("Not supported yet");
   }
}

/**
 * This class represents the exact digits only format.
 */
class ExactDigitsOnly extends AmountFormat {

   /**
    * Default constructor.
    */
   public function ExactDigitsOnly() {
      super();
   }

   override public format(arg0:Amount, arg1:Appendable):Appendable {
// TODO
//      if (arg0.getUnit() instanceof Currency) {
//         return formatMoney(arg0, arg1);
//      }
      if (arg0.exact) {
         TypeFormat.format(arg0.exactValue, arg1);
         arg1.append(" ");
         return UnitFormat.getInstance().format(arg0.getUnit(), arg1);
      }
      var value:Number = arg0.estimatedValue;
      var error:Number = arg0.absoluteError;
      var log10Value:int = (int) Math.floor(Math.log(Math.abs(value)) * Math.LOG10E);
      var log10Error:int = (int) Math.floor(Math.log(error) * Math.LOG10E);
      var digits:int = log10Value - log10Error - 1; // Exact digits.

      boolean scientific = (Math.abs(value) >= 1E6) || (Math.abs(value) < 1E-6);
      boolean showZeros = true;
      TypeFormat.formatNumber(arg1, value, digits, scientific, showZeros);
      arg1.append(" ");
      return UnitFormat.getInstance().format(arg0.getUnit(), arg1);
   }

   override public function parse(arg0:String, arg1:Cursor):Amount {
      throw new Error("This format should not be used for parsing (not enough information on the error)");
   }
}

///**
// * Provides custom formatting for money measurements.
// */
//private static Appendable formatMoney(Amount<Money> arg0, Appendable arg1) {
//   Currency currency = (Currency) arg0.getUnit();
//   var fraction:int = currency.getDefaultFractionDigits();
//   if (fraction == 0) {
//      long amount = arg0.longValue(currency);
//      TypeFormat.format(amount, arg1);
//   } else if (fraction == 2) {
//      long amount = MathLib.round(arg0.doubleValue(arg0.getUnit()) * 100);
//      TypeFormat.format(amount / 100, arg1);
//      arg1.append(".");
//     arg1.append((char) ("0" + (amount % 100) / 10));
//      arg1.append((char) ("0" + (amount % 10)));
//   } else {
//      throw new UnsupportedOperationException();
//   }
//  arg1.append(" ");
//   return UnitFormat.getInstance().format(currency, arg1);
//}

import de.mjel.measure.parse.Cursor;

/**
 * <p>This class provides utility methods to parse strings
 *    into primitive types and to format primitive types into any Appendable.</p>
 *
 * <p>The number of digits when formatting floating point numbers can be 
 *    specified. The default setting for <code>Number</code> is 17 digits 
 *    or even 16 digits when the conversion is lossless back and forth.
 *    For example:<code>
 *        TypeFormat.format(0.2, a) = "0.2" // 17 or 16 digits (as long as lossless conversion), remove trailing zeros.
 *        TypeFormat.format(0.2, 17, false, false, a) = "0.20000000000000001" // Closest 17 digits number.
 *        TypeFormat.format(0.2, 19, false, false, a) = "0.2000000000000000111" // Closest 19 digits.
 *        TypeFormat.format(0.2, 4, false, false, a) = "0.2" // Fixed-point notation, remove trailing zeros.
 *        TypeFormat.format(0.2, 4, false, true, a) = "0.2000" // Fixed-point notation, fixed number of digits.
 *        TypeFormat.format(0.2, 4, true, false, a) = "2.0E-1" // Scientific notation, remove trailing zeros.  
 *        TypeFormat.format(0.2, 4, true, true, a) = "2.000E-1" // Scientific notation, fixed number of digits.
 *        </code</p>
 */
class TypeFormat {

   public function TypeFormat() {
      super();
   }

   private static const DIGIT_TO_CHAR:Array = [
      "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
      "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
      "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
   ];

   private static const POW10_NUMBER:Array = [
      1,
      10,
      100,
      1000,
      10000,
      100000,
      1000000,
      10000000,
      100000000,
      1000000000,
      10000000000,
      100000000000,
      1000000000000,
      10000000000000,
      100000000000000,
      1000000000000000,
      10000000000000000,
      100000000000000000,
      1000000000000000000
   ]; 

   /////////////
   // PARSING //
   /////////////

   /**
    * Parses the specified string as a <code>Boolean</code>.
    *
    * @param value the string to parse.
    * @param cursor the cursor position (being maintained) or
    *        <code>null</code> to parse the whole string.
    * @return the next boolean value.
    * @throws ArgumentError if the specified string 
    *         is different from "true" or "false" ignoring cases.
    */
   public static function parseBoolean(value:String, cursor:Cursor=null):Boolean {
      var start:int = (cursor != null) ? cursor.getIndex() : 0;
      var end:int = value.length;
      if ((end >= start + 5) && (value.charAt(start) == "f" || value.charAt(start) == "F")) { // False.
         if ((value.charAt(++start) == "a" || value.charAt(start) == "A") &&
             (value.charAt(++start) == "l" || value.charAt(start) == "L") &&
             (value.charAt(++start) == "s" || value.charAt(start) == "S") &&
             (value.charAt(++start) == "e" || value.charAt(start) == "E")) {
            increment(cursor, 5, end, value);
            return false;
         }
      }
      else if ((end >= start + 4) && (value.charAt(start) == "t" || value.charAt(start) == "T")) { // True.
         if ((value.charAt(++start) == "r" || value.charAt(start) == "R") &&
             (value.charAt(++start) == "u" || value.charAt(start) == "U") &&
             (value.charAt(++start) == "e" || value.charAt(start) == "E")) {
            increment(cursor, 4, end, value);
            return true;
         }
      }
      throw new ArgumentError("Invalid boolean representation");
   }

   /**
    * Parses the specified string from the specified position
    * as a signed <code>int</code> in the specified radix.
    *
    * @param value the string to parse.
    * @param radix the radix to be used while parsing.
    * @param cursor the cursor position (being maintained) or
    *        <code>null</code> to parse the whole string.
    * @return the corresponding <code>int</code>.
    * @throws NumberFormatException if the specified string
    *         does not contain a parsable <code>int</code>.
    */
   public static function parseLong(value:String, radix:int=10, cursor:Cursor=null):Number {
      var start:int = (cursor != null) ? cursor.getIndex() : 0;
      var end:int = value.length;
      var isNegative:Boolean = false;
      var result:Number = 0; // Accumulates negatively (avoid MIN_VALUE overflow).
      var i:int = start;
      for (; i < end; i++) {
         var c:String = value.charAt(i);
         var digit:int = (c <= "9".charCodeAt()) ? c - "0".charCodeAt()
            : ((c <= "Z".charCodeAt()) && (c >= "A".charCodeAt())) ? c - "A".charCodeAt() + 10
            : ((c <= "z".charCodeAt()) && (c >= "a".charCodeAt())) ? c - "a".charCodeAt() + 10 : -1;
         if ((digit >= 0) && (digit < radix)) {
            var newResult:int = result * radix - digit;
            if (newResult > result) {
               throw new Error("Overflow parsing " + value.substring(start, end));
            }
            result = newResult;
         }
         else if ((c == "-".charCodeAt()) && (i == start)) {
            isNegative = true;
         }
         else if ((c == "+".charCodeAt()) && (i == start)) {
            // Ok.
         }
         else break;
      }
      // Requires one valid digit character and checks for opposite overflow.
      if ((result == 0) && ((end == 0) || (value.charAt(i - 1) != "0"))) {
         throw new Error("Invalid integer representation for " + value.substring(start, end));
      }
      if ((result == Number.MIN_VALUE) && !isNegative) {
         throw new Error("Overflow parsing " + value.substring(start, end));
      }
      increment(cursor, i - start, end, value);
      return isNegative ? result : -result;
   }

   /**
    * Parses the specified string from the specified position 
    * as a <code>double</code>.
    *
    * @param  value the string to parse.
    * @param cursor the cursor position (being maintained) or
    *        <code>null</code> to parse the whole string.
    * @return the double number represented by this string.
    * @throws NumberFormatException if the string does not contain
    *         a parsable <code>double</code>.
    */
   public static function parseNumber(value:String, cursor:Cursor=null):Number {
      const start:int = (cursor != null) ? cursor.getIndex() : 0;
      const end:int = value.length;
      var i:int = start;
      var c:String = value.charAt(i);

      // Checks for NaN.
      if ((c == "N") && match("NaN", value, i, end)) {
         increment(cursor, 3, end, value);
         return Number.NaN;
      }

      // Reads sign.
      boolean isNegative = (c == "-");
      if ((isNegative || (c == "+")) && (++i < end)) {
         c = value.charAt(i);
      }

      // Checks for Infinity.
      if ((c == "I") && match("Infinity", value, i, end)) {
         increment(cursor, i + 8 - start, end, value);
         return isNegative
            ? Number.NEGATIVE_INFINITY
            : Number.POSITIVE_INFINITY;
      }

      // At least one digit or a "." required.
      if (((c < "0".charCodeAt()) || (c > "9".charCodeAt())) && (c != ".")) {
         throw new Error("Digit or \".\" required");
      }

      var digit:int;
      var tmp:int;

      // Reads decimal and fraction.
      var decimal:int = 0;
      var decimalPoint:int = -1;
      while (true) {
         digit = c - "0".charCodeAt();
         if ((digit >= 0) && (digit < 10)) {
            tmp = decimal * 10 + digit;
            if (tmp < decimal) {
               throw new Error("Too many digits - Overflow");
            }
            decimal = tmp;
         }
         else if ((c == ".") && (decimalPoint < 0)) {
            decimalPoint = i;
         }
         else {
            break;
         }
         if (++i >= end) {
            break;
         }
         c = value.charAt(i);
      }
      if (isNegative) {
         decimal = -decimal;
      }

      var fractionLength:int = (decimalPoint >= 0) ? i - decimalPoint - 1 : 0;

      // Reads exponent.
      var exp:int = 0;
      if ((i < end) && ((c == "E") || (c == "e"))) {
         c = value.charAt(++i);
         var isNegativeExp:Boolean = (c == "-");
         if ((isNegativeExp || (c == "+")) && (++i < end)) {
            c = value.charAt(i);
         }
         if ((c < "0") || (c > "9")) { // At least one digit required.  
            throw new Error("Invalid exponent");
         }
         while (true) {
            digit = c - "0".charCodeAt();
            if ((digit >= 0) && (digit < 10)) {
               tmp = exp * 10 + digit;
               if (tmp < exp) {
                  throw new Error("Exponent Overflow");
               }
               exp = tmp;
            }
            else {
               break;
            }
            if (++i >= end) {
               break;
            }
            c = value.charAt(i);
         }
         if (isNegativeExp) {
            exp = -exp;
         }
      }
      increment(cursor, i - start, end, value);
      return Math.pow(decimal, exp - fractionLength);
   }

   private static function match(String str, String value, int start, int length):Boolean {
      for (var i:int = 0; i < str.length; i++) {
         if ((start + i >= length) || value.charAt(start + i) != str.charAt(i)) {
            return false;
         }
      }
      return true;
   }

   ////////////////
   // FORMATTING //
   ////////////////

   /**
    * Formats the specified <code>value</code> and appends the resulting
    * text to the <code>Appendable</code> argument.
    *
    * @param value a <code>Object</code>.
    * @param appendable the <code>Appendable</code> to append.
    * @return the specified <code>Appendable</code> object.
    */
   public static function format(value:Object, appendable:Appendable):Appendable {
      if (value is Boolean) {
         return formatBoolean(appendable, value as Boolean);
      }
      else if (value is Number) {
         if (value % 1 == 0) {
            return formatInteger(appendable, value as Number);
         }
         else {
            return formatNumber(appendable, value as Number,
                  (Math.abs(value as Number) >= 1E7) || (Math.abs(value as Number) < 0.0001), false);
         }
      }
   }

   /**
    * Formats the specified <code>value</code> and appends the resulting
    * text to the <code>Appendable</code> argument.
    *
    * @param value a <code>Object</code>.
    * @param appendable the <code>Appendable</code> to append.
    * @return the specified <code>Appendable</code> object.
    */
   public static function formatBoolean(appendable:Appendable, value:Boolean):Appendable {
      return value ? appendable.append("true") : appendable.append("false");
   }

   /**
    * Formats the specified <code>value</code> and appends the resulting
    * text to the <code>Appendable</code> argument.
    *
    * @param value a <code>Object</code>.
    * @param radix the radix if <code>value</code> is a <code>Number</code>.
    * @param appendable the <code>Appendable</code> to append.
    * @return the specified <code>Appendable</code> object.
    */
   public static function formatInteger(appendable:Appendable, radix:int=10, value:Number):Appendable {
      if (value % 1 != 0) {
         throw new ArgumentError("Number must be an integer");
      }
      if (radix == 10) {
         return appendable.append(value.toString()); // Faster.
      }
      if (radix < 2 || radix > 36) {
         throw new ArgumentError("radix: " + radix);
      }
      if (value < 0) {
         appendable.append("-");
         if (value == Number.MIN_VALUE) { // Negative would overflow.
            appendPositive(appendable, -(value / radix), radix);
            return appendable.append(DIGIT_TO_CHAR[-(value % radix)]);
         }
         value = -value;
      }
      return appendPositive(appendable, value, radix);
   }

   /**
    * Appends the textual representation of the specified <code>double</code>
    * according to the specified formatting arguments.
    *
    * @param d the <code>double</code> value.
    * @param digits the number of significative digits (excludes exponent) or
    *        <code>-1</code> to mimic the standard library (16 or 17 digits).
    * @param scientific <code>true</code> to forces the use of the scientific 
    *        notation (e.g. <code>1.23E3</code>); <code>false</code> 
    *        otherwise. 
    * @param showZero <code>true</code> if trailing fractional zeros are 
    *        represented; <code>false</code> otherwise.
    * @return <code>TypeFormat.format(d, digits, scientific, showZero, this)</code>
    * @throws ArgumentError if <code>(digits &gt; 19)</code>)
    */
   public static function formatNumber(appendable:Appendable, value:Number, digits:int=-1, scientific:Boolean=false, showZero:Boolean=false):Appendable {
      if (digits > 19) {
         throw new ArgumentError("digits: " + digits);
      }
      if (isNaN(value)) {
         return appendable.append("NaN");
      }
      if (value == Number.POSITIVE_INFINITY) {
         return appendable.append("Infinity");
      }
      if (value == Number.NEGATIVE_INFINITY) {
         return appendable.append("-Infinity");
      }
      if (value == 0.0) { // Zero.
         if (digits < 0) {
            return appendable.append("0.0");
         }
         appendable.append('0');
         if (showZero) {
            appendable.append('.');
            for (var j:int = 1; j < digits; j++) {
               appendable.append('0');
            }
         }
         return appendable;
      }
      if (value < 0) { // Work with positive number.
         value = -value;
         appendable.append('-');
      }

      // Find the exponent e such as: value == x.xxx * 10^e
      var e:int = Math.floor(Math.Log(Math.abs(value)) * Math.LOG10E);

      var m:Number;
      if (digits < 0) { // Use 16 or 17 digits.
         // Try 17 digits.
         var m17:Number = Math.pow(d, (17 - 1) - e);
         // Check if we can use 16 digits.
         var m16:Number = m17 / 10;
         var dd:Number = Math.pow(m16, e - 16 + 1);
         if (dd == value) { // 16 digits is enough.
            digits = 16;
            m = m16;
         }
         else { // We cannot remove the last digit.
            digits = 17;
            m = m17;
         }
      }
      else { // Use the specified number of digits.
         m = Math.pow(d, (digits - 1) - e);
      }

      // Formats.
      var pow10:Number;
      if (scientific || (e >= digits)) {
         // Scientific notation has to be used ("x.xxxEyy").
         pow10 = POW10_NUMBER[digits - 1];
         var k:int = int(m / pow10); // Single digit.
         appendable.append((char) ('0' + k));
         m = m - pow10 * k;
         appendFraction(appendable, m, digits - 1, showZero);
         appendable.append('E');
         appendable.append(e);
      }
      else { // Dot within the string ("xxxx.xxxxx").
         var exp:int = digits - e - 1;
         if (exp < POW10_NUMBER.length) {
            pow10 = POW10_NUMBER[exp];
            var l:Number = m / pow10;
            appendable.append(l);
            m = m - pow10 * l;
         }
         else {
            appendable.append('0'); // Result of the division by a power of 10 larger than any long.
         }
         appendFraction(appendable, m, exp, showZero);
      }

      return appendable;
   }

   private static function appendPositive(appendable:Appendable, l1:Number, radix:int):Appendable {
      if (l1 % 1 != 0) {
         throw new ArgumentError("Number must be an integer");
      }
      if (l1 >= radix) {
         var l2:int = l1 / radix;
         if (l2 >= radix) {
            var l3:int = l2 / radix;
            if (l3 >= radix) {
               var l4:int = l3 / radix;
               appendPositive(appendable, l4, radix);
               appendable.append(DIGIT_TO_CHAR[l3 - (l4 * radix)]);
            }
            else {
               appendable.append(DIGIT_TO_CHAR[l3]);
            }
            appendable.append(DIGIT_TO_CHAR[l2 - (l3 * radix)]);
         }
         else {
            appendable.append(DIGIT_TO_CHAR[l2]);
         }
         appendable.append(DIGIT_TO_CHAR[l1 - (l2 * radix)]);
      }
      else {
         appendable.append(DIGIT_TO_CHAR[l1]);
      }
      return appendable;
   }

   private static function appendFraction(appendable:Appendable, value:Number, digits:int, showZero:Boolean):Appendable {
      appendable.append('.');
      if (value == 0) {
         if (showZero) {
            for (var i:int = 0; i < digits; i++) {
               appendable.append('0');
            }
         }
         else {
            appendable.append('0');
         }
      }
      else { // l is different from zero.
         var length:int = digitLength(value);
         for (var j:int = length; j < digits; j++) {
            appendable.append('0'); // Add leading zeros.
         }
         if (!showZero) {
            while (value % 10 == 0) {
               value /= 10; // Remove trailing zeros.
            }
         }
         appendable.append(value);
      }
   }

   /**
    * Returns the number of digits in the minimal ten's-complement 
    * representation of the specified <code>Number</code>, excluding a sign bit.
    * For positive <code>Number</code>, this is equivalent to the number of digit
    * in the ordinary decimal representation. For negative <code>Number</code>,
    * it is equivalent to the number of digit of the positive value 
    * <code>-(value + 1)</code>.
    * 
    * @param value the <code>Number</code> value for which the digit length is returned.
    * @return the digit length of <code>value</code>.
    */
   public static function digitLength(value:Number):int {
      if (value < 0) {
         value = -++value;
      }
      if (value <= int.MAX_VALUE) {
         var i:int = int(value);
         return (i >= 100000) ? (i >= 10000000) ? (i >= 1000000000) ? 10
            : (i >= 100000000) ? 9 : 8 : (i >= 1000000) ? 7 : 6
            : (i >= 100) ? (i >= 10000) ? 5 : (i >= 1000) ? 4 : 3
            : (i >= 10) ? 2 : (i >= 1) ? 1 : 0;
      }
      // At least 10 digits or more.
      return (value >= 100000000000000L) ? (value >= 10000000000000000L) ? (value >= 1000000000000000000L) ? 19
         : (value >= 100000000000000000L) ? 18 : 17
         : (value >= 1000000000000000L) ? 16 : 15
         : (value >= 100000000000L) ? (value >= 10000000000000L) ? 14
         : (value >= 1000000000000L) ? 13 : 12
         : (value >= 10000000000L) ? 11 : 10;
   }

   // Increments the specified cursor if not null.
   private static function increment(cursor:Cursor, inc:int, endIndex:int, value:String):void {
      if (cursor != null) {
         cursor.increment(inc);
      }
      else if (inc != endIndex) { // Whole string must be parsed.
         throw new Error("Extraneous character: \"" + value.charAt(inc) + "\"");
      }
   }
}
