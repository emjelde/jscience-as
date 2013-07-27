/*
 * JScience - Java(TM) Tools and Libraries for the Advancement of Sciences.
 * Copyright (C) 2007 - JScience (http://jscience.org/)
 * All rights reserved.
 * 
 * Permission to use, copy, modify, and distribute this software is
 * freely granted, provided that this notice is preserved.
 */
package measure.converter {
   /**
    * Signals that a problem of some sort has occurred either when creating a
    * converter between two units or during the conversion itself.
    */
   public class ConversionError extends Error {
      public function ConversionError(message:*="", id:*=0) {
         super(message, id);
      }
   }
}
