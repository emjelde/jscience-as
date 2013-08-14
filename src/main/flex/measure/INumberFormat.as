package measure {
   import measure.parse.ParsePosition;

   public interface INumberFormat {
      /**
       * Formats a number.
       */
      function format(value:*):String; 

      /**
       * Parses text of given string to produce a number.
       */
      function parse(source:String, pos:ParsePosition=null):Number;
   }
}
