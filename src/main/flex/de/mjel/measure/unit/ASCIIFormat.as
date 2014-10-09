/*
 * ActionScript Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2013 - jscience-as (http://evan.mjel.de/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package de.mjel.measure.unit {
   import de.mjel.measure.parse.Appendable;

   /**
    * This class represents the ASCIIFormat format.
    */
   internal class ASCIIFormat extends DefaultFormat {

      override public function nameFor(unit:Unit):String {
         // First search if specific ASCII name should be used.
         var name:String = _unitToName[unit];
         if (name != null) {
            return name;
         }
         // Else returns default name.
         return DEFAULT.nameFor(unit);
      }

      override public function unitFor(name:String):Unit {
         // First search if specific ASCII name.
         var unit:Unit = _nameToUnit[name];
         if (unit != null) {
            return unit;
         }
         // Else returns default mapping.
         return DEFAULT.unitFor(name);
      }

      override public function format(unit:Unit, appendable:Appendable=null):Appendable {
         if (!appendable) {
            appendable = new Appendable();
         }
         var name:String = nameFor(unit);
         if (name != null) {
            return appendable.append(name);
         }
         if (!(unit is ProductUnit)) {
            throw new ArgumentError("Cannot format given Object as a Unit");
         }
         var productUnit:ProductUnit = (unit as ProductUnit);
         for (var i:int = 0; i < productUnit.unitCount; i++) {
            if (i != 0) {
               appendable.append("*"); // Separator.
            }
            name = nameFor(productUnit.getUnit(i));
            var pow:int = productUnit.getUnitPow(i);
            var root:int = productUnit.getUnitRoot(i);
            appendable.append(name);
            if ((pow != 1) || (root != 1)) {
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
   }
}
