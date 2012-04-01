import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class Label extends TextField
{
  public var format:TextFormat;
  public var label:String;
  public function new(label:String) {
    super();
    this.label = label;
    format = new TextFormat("Verdana", 11);
    autoSize = TextFieldAutoSize.LEFT;
    multiline = true;
    selectable = false;
    defaultTextFormat = format;
    text = label;
  }
}

