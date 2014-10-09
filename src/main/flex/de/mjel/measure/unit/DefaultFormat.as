/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.measure.unit {
   import de.mjel.measure.converter.AddConverter;
   import de.mjel.measure.converter.MultiplyConverter;
   import de.mjel.measure.converter.RationalConverter;
   import de.mjel.measure.converter.UnitConverter;
   import de.mjel.measure.parse.Appendable;
   import de.mjel.measure.parse.ParsePosition;

   import flash.utils.Dictionary;

   import mx.utils.StringUtil;

   /**
    * This class represents the standard format.
    */
   internal class DefaultFormat extends UnitFormat {
      /**
       * Constructor.
       */
      public function DefaultFormat() {
         super();
      }

      /**
       * Holds the name to unit mapping.
       */
      protected var _nameToUnit:Dictionary = new Dictionary();

      /**
       * Holds the unit to name mapping.
       */
      protected var _unitToName:Dictionary = new Dictionary();

      override public function label(unit:Unit, label:String):void {
         if (!isValidIdentifier(label)) {
            throw new ArgumentError("Label: " + label + " is not a valid identifier.");
         }
         _nameToUnit[label] = unit;
         _unitToName[unit] = label;
      }

      override public function alias(unit:Unit, alias:String):void {
         if (!isValidIdentifier(alias)) {
            throw new ArgumentError("Alias: " + alias + " is not a valid identifier.");
         }
         _nameToUnit[alias] = unit;
      }

      override public function isValidIdentifier(name:String):Boolean {
         if ((name == null) || (name.length == 0)) {
            return false;
         }
         for (var i:int = 0; i < name.length; i++) {
            if (!isUnitIdentifierPart(name.charAt(i))) {
               return false;
            }
         }
         return true;
      }

      // Returns the name for the specified unit or null if product unit.
      public function nameFor(unit:Unit):String {
         // Searches label database.
         var label:String = _unitToName[unit];
         if (label) {
            return label;
         }
         if (unit is BaseUnit) {
            return (unit as BaseUnit).symbol;
         }
         if (unit is AlternateUnit) {
            return (unit as AlternateUnit).symbol;
         }
         if (unit is TransformedUnit) {
            var tfmUnit:TransformedUnit = unit as TransformedUnit;
            var baseUnits:Unit = tfmUnit.standardUnit;
            var cvtr:UnitConverter = tfmUnit.toStandardUnit();
            var result:String = "";
            var baseUnitName:String = baseUnits.toString();
            if ((baseUnitName.indexOf("·") >= 0) ||
                  (baseUnitName.indexOf("*") >= 0) ||
                  (baseUnitName.indexOf("/") >= 0)) {
               // We could use parentheses whenever baseUnits is an
               // ProductUnit, but most ProductUnits have aliases,
               // so we'd end up with a lot of unnecessary parentheses.
               result = result.concat("(", baseUnitName, ")");
            }
            else {
               result = result.concat(baseUnitName);
            }
            if (cvtr is AddConverter) {
               result = result.concat("+", (cvtr as AddConverter).offset);
            }
            else if (cvtr is RationalConverter) {
               var dividend:Number = (cvtr as RationalConverter).dividend;
               if (dividend != 1) {
                  result = result.concat("*", dividend);
               }
               var divisor:Number = (cvtr as RationalConverter).divisor;
               if (divisor != 1) {
                  result = result.concat("/", divisor);
               }
            }
            else if (cvtr is MultiplyConverter) {
               result = result.concat("*", (cvtr as MultiplyConverter).factor);
            }
            else { // Other converters.
               return "[" + baseUnits + "?]";
            }
            return result;
         }
         // Compound unit.
         if (unit is CompoundUnit) {
            var cpdUnit:CompoundUnit = unit as CompoundUnit;
            return nameFor(cpdUnit.higher).toString() + ":" + nameFor(cpdUnit.lower);
         }
         return null; // Product unit.
      }

      // Returns the unit for the specified name.
      public function unitFor(name:String):Unit {
         var unit:Unit = _nameToUnit[name];
         if (unit) {
            return unit;
         }
         unit = Unit.SYMBOL_TO_UNIT[name];
         return unit;
      }

      ////////////////////////////
      // Parsing.

      override public function parseSingleUnit(value:String, pos:ParsePosition):Unit {
         var startIndex:int = pos.index;
         var name:String = readIdentifier(value, pos);
         var unit:Unit = unitFor(name);
         check(unit != null, name + " not recognized", value, startIndex);
         return unit;
      }

      override public function parseProductUnit(value:String, pos:ParsePosition):Unit {
         var result:Unit = Unit.ONE;
         var token:int = nextToken(value, pos);
         switch (token) {
            case IDENTIFIER:
               result = parseSingleUnit(value, pos);
               break;
            case OPEN_PAREN:
               pos.index = pos.index + 1;
               result = parseProductUnit(value, pos);
               token = nextToken(value, pos);
               check(token == CLOSE_PAREN, "')' expected", value, pos.index);
               pos.index = pos.index + 1;
               break;
         }
         token = nextToken(value, pos);
         var d:Number;
         var n:Number;
         while (true) {
            switch (token) {
               case EXPONENT:
                  var e:Exponent = readExponent(value, pos);
                  if (e.pow != 1) {
                     result = result.pow(e.pow);
                  }
                  if (e.root != 1) {
                     result = result.root(e.root);
                  }   
                  break;
               case MULTIPLY:
                  pos.index = pos.index + 1;
                  token = nextToken(value, pos);
                  if (token == INTEGER) {
                     n = readInteger(value, pos);
                     if (n != 1) {
                        result = result.times(n);
                     }
                  }
                  else if (token == FLOAT) {
                     d = readNumber(value, pos);
                     if (d != 1.0) {
                        result = result.times(d);
                     }
                  }
                  else {
                     result = result.times(parseProductUnit(value, pos));
                  }
                  break;
               case DIVIDE:
                  pos.index = pos.index + 1;
                  token = nextToken(value, pos);
                  if (token == INTEGER) {
                     n = readInteger(value, pos);
                     if (n != 1) {
                        result = result.divide(n);
                     }
                  }
                  else if (token == FLOAT) {
                     d = readNumber(value, pos);
                     if (d != 1.0) {
                        result = result.divide(d);
                     }
                  }
                  else {
                     result = result.divide(parseProductUnit(value, pos));
                  }
                  break;
               case PLUS:
                  pos.index = pos.index + 1;
                  token = nextToken(value, pos);
                  if (token == INTEGER) {
                     n = readInteger(value, pos);
                     if (n != 1) {
                        result = result.plus(n);
                     }
                  }
                  else if (token == FLOAT) {
                     d = readNumber(value, pos);
                     if (d != 1.0) {
                        result = result.plus(d);
                     }
                  }
                  else {
                     throw new Error("not a number", pos.index);
                  }
                  break;
               case EOF:
               case CLOSE_PAREN:
                  return result;
               default:
                  throw new Error("unexpected token " + token, pos.index);
            }
            token = nextToken(value, pos);
         }

         return result;
      }

      private static const EOF:int = 0;
      private static const IDENTIFIER:int = 1;
      private static const OPEN_PAREN:int = 2;
      private static const CLOSE_PAREN:int = 3;
      private static const EXPONENT:int = 4;
      private static const MULTIPLY:int = 5;
      private static const DIVIDE:int = 6;
      private static const PLUS:int = 7;
      private static const INTEGER:int = 8;
      private static const FLOAT:int = 9;

      private function nextToken(value:String, pos:ParsePosition):int {
         var length:int = value.length;
         while (pos.index < length) {
            var c:String = value.charAt(pos.index);
            if (isUnitIdentifierPart(c)) {
               return IDENTIFIER;
            }
            else if (c == "(") {
               return OPEN_PAREN;
            }
            else if (c == ")") {
               return CLOSE_PAREN;
            }
            else if ((c == "^") || (c == "¹") || (c == "²") || (c == "³")) {
               return EXPONENT;
            }
            else if (c == "*") {
               var c2:String = value.charAt(pos.index + 1);
               if (c2 == "*") {
                  return EXPONENT;
               } else {
                  return MULTIPLY;
               }
            }
            else if (c == "·") {
               return MULTIPLY;
            }
            else if (c == "/") {
               return DIVIDE;
            }
            else if (c == "+") {
               return PLUS;
            }
            else if ((c == "-") || isDigit(c)) {
               var index:int = pos.index + 1;
               while ((index < length) && (isDigit(c) || (c == "-") || (c == ".") || (c == "E"))) {
                  c = value.charAt(index++);
                  if (c == ".") {
                     return FLOAT;
                  }
               }
               return INTEGER;
            }
            pos.index = pos.index + 1;
         }
         return EOF;
      }

      private function check(expr:Boolean, message:String, value:String, index:int):void {
         if (!expr) {
            throw new ArgumentError(message + " (in " + value + " at index " + index + ")", index);
         }
      }

      private function readExponent(value:String, pos:ParsePosition):Exponent {
         var c:String = value.charAt(pos.index);
         if (c == "^") {
            pos.index = pos.index + 1;
         }
         else if (c == "*") {
            pos.index = pos.index + 2;
         }
         const length:int = value.length;
         var pow:int = 0;
         var isPowNegative:Boolean = false;
         var root:int = 0;
         var isRootNegative:Boolean = false;
         var isRoot:Boolean = false;
         while (pos.index < length) {
            c = value.charAt(pos.index);
            if (c == "¹") {
               if (isRoot) {
                  root = root * 10 + 1;
               }
               else {
                  pow = pow * 10 + 1;
               }
            }
            else if (c == "²") {
               if (isRoot) {
                  root = root * 10 + 2;
               }
               else {
                  pow = pow * 10 + 2;
               }
            }
            else if (c == "³") {
               if (isRoot) {
                  root = root * 10 + 3;
               }
               else {
                  pow = pow * 10 + 3;
               }
            }
            else if (c == "-") {
               if (isRoot) {
                  isRootNegative = true;
               }
               else {
                  isPowNegative = true;
               }
            }
            else if ((c.charCodeAt() >= "0".charCodeAt()) && (c.charCodeAt() <= "9".charCodeAt())) {
               if (isRoot) {
                  root = root * 10 + (c.charCodeAt() - "0".charCodeAt());
               }
               else {
                  pow = pow * 10 + (c.charCodeAt() - "0".charCodeAt());
               }
            }
            else if (c == ":") {
               isRoot = true;
            }
            else {
               break;
            }
            pos.index = pos.index + 1;
         }
         if (pow == 0) {
            pow = 1;
         }
         if (root == 0) {
            root = 1;
         }
         return new Exponent(isPowNegative ? -pow : pow, isRootNegative ? -root : root);
      }

      private function readInteger(value:String, pos:ParsePosition):Number {
         var length:int = value.length;
         var result:int = 0;
         var isNegative:Boolean = false;
         while (pos.index < length) {
            var c:String = value.charAt(pos.index);
            if (c == "-") {
               isNegative = true;
            }
            else if ((c.charCodeAt() >= "0".charCodeAt()) && (c.charCodeAt() <= "9".charCodeAt())) {
               result = result * 10 + (c.charCodeAt() - "0".charCodeAt());
            }
            else {
               break;
            }
            pos.index = pos.index + 1;
         }
         return isNegative ? -result : result;
      }

      private function readNumber(value:String, pos:ParsePosition):Number {
         var length:int = value.length;
         var start:int = pos.index;
         var end:int = start + 1;
         while (end < length) {
            if ("012356789+-.E".indexOf(value.charAt(end)) < 0) {
               break;
            }
            end += 1;
         }
         pos.index = end+1;
         return Number(value.substring(start, end));
      }

      private function readIdentifier(value:String, pos:ParsePosition):String {
         var length:int = value.length;
         var start:int = pos.index;
         var i:int = start;
         while ((++i < length) && isUnitIdentifierPart(value.charAt(i))) { 
            // continue
         }
         pos.index = i;
         return value.substring(start, i);
      }

      ////////////////////////////
      // Formatting.

      override public function format(unit:Unit, appendable:Appendable=null):Appendable {
         if (!appendable) {
            appendable = new Appendable();
         }
         var name:String = nameFor(unit);
         if (name) {
            return appendable.append(name);
         }
         if (!(unit is ProductUnit)) {
            throw new ArgumentError("Cannot format given Object as a Unit");
         }
         // Product unit.
         var productUnit:ProductUnit = (unit as ProductUnit);
         var invNbr:int = 0;
         var i:int;

         // Write positive exponents first.
         var start:Boolean = true;
         var pow:int;
         var root:int
         for (i = 0; i < productUnit.unitCount; i++) {
            pow = productUnit.getUnitPow(i);
            if (pow >= 0) {
               if (!start) {
                  appendable.append("·"); // Separator.
               }
               name = nameFor(productUnit.getUnit(i));
               root = productUnit.getUnitRoot(i);
               append(appendable, name, pow, root);
               start = false;
            }
            else {
               invNbr++;
            }
         }

         // Write negative exponents.
         if (invNbr != 0) {
            if (start) {
               appendable.append("1"); // e.g. 1/s
            }
            appendable.append("/");
            if (invNbr > 1) {
               appendable.append("(");
            }
            start = true;
            for (i = 0; i < productUnit.unitCount; i++) {
               pow = productUnit.getUnitPow(i);
               if (pow < 0) {
                  name = nameFor(productUnit.getUnit(i));
                  root = productUnit.getUnitRoot(i);
                  if (!start) {
                     appendable.append("·"); // Separator.
                  }
                  append(appendable, name, -pow, root);
                  start = false;
               }
            }
            if (invNbr > 1) {
               appendable.append(")");
            }
         }
         return appendable;
      }

      private function append(appendable:Appendable, symbol:String, pow:int, root:int):Appendable {
         appendable.append(symbol);
         if ((pow != 1) || (root != 1)) {
            // Write exponent.
            if ((pow == 2) && (root == 1)) {
               appendable.append("²"); // Square
            }
            else if ((pow == 3) && (root == 1)) {
               appendable.append("³"); // Cubic
            }
            else {
               // Use general exponent form.
               appendable.append("^");
               appendable.append(pow.toString());
               if (root != 1) {
                  appendable.append(":");
                  appendable.append(root.toString());
               }
            }
         }
         return appendable;
      }

      protected function isUnitIdentifierPart(ch:String):Boolean {
         return isLetter(ch) ||
            (!isWhitespace(ch) && !isDigit(ch)
             && (ch != "·") && (ch != "*") && (ch != "/")
             && (ch != "(") && (ch != ")") && (ch != "[") && (ch != "]")   
             && (ch != "¹") && (ch != "²") && (ch != "³") 
             && (ch != "^") && (ch != "+") && (ch != "-"));
      }

      private function isUpperCase(value:String):Boolean {
         return isValidCode(value, 65, 90);
      }

      private function isLowerCase(value:String):Boolean {
         return isValidCode(value, 97, 122);
      }

      private function isWhitespace(value:String):Boolean {
         return value == " ";
      }

      private function isDigit(value:String):Boolean {
         return isValidCode(value, 48, 57);
      }

      private function isLetter(value:String):Boolean {
         return (isLowerCase(value) || isUpperCase(value));
      }

      private function isValidCode(value:String, minCode:Number, maxCode:Number):Boolean {
         if ((value == null) || (StringUtil.trim(value).length < 1)) {
            return false;
         }
         for (var i:int = value.length - 1; i >= 0; i--) {
            var code : Number = value.charCodeAt(i);
            if ((code < minCode) || (code > maxCode)) {
               return false;
            }
         }
         return true;
      }
   }
}

/**
 * This class represents an exponent with both a power (numerator)
 * and a root (denominator).
 */
class Exponent {
   public var pow:int;
   public var root:int;
   public function Exponent(pow:int, root:int) {
      super();
      this.pow = pow;
      this.root = root;
   }
}
