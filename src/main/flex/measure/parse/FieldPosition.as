package measure.parse {
   /**
    * FieldPosition is a simple class to identify fields in formatted output.
    */
   public class FieldPosition {
      private var _field:int = 0;
      private var _beginIndex:int = 0;
      private var _endIndex:int = 0;

      public function FieldPosition(field:int=0) {
         super();
         _field = field;
      }

      public function setBeginIndex(value:int):void {
         _beginIndex = value;
      }

      public function getBeginIndex():int {
         return _beginIndex;
      }

      public function getEndIndex():int {
         return _endIndex;
      }

      public function setEndIndex(value:int):void {
         _endIndex = value;
      }
   }
}
