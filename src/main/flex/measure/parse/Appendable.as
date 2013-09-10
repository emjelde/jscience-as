package measure.parse {
   /**
    * Appendable is a simple class to which String values can be appended.
    */
   public class Appendable {
      private var _internal:String = "";

      /**
       * Constructor.
       */
      public function Appendable(init:String=null) {
         super();
         if (init) {
            _internal = String(init);
         }
      }

      /**
       * Appends the specified String to this <code>Appendable</code>.
       *
       * @param s The String from which a subsequence will be appended.
       * @param start The index of the first character in the subsequence.
       * @param end The index of the character following the last character in the
       *            subsequence.
       */
      public function append(s:String, start:int=0, end:int=0x7fffffff):Appendable {
         _internal = _internal.concat(String(s).substring(start, end));
         return this;
      }

      public function toString():String {
         return _internal;
      }
   }
}
