import flash.display.Sprite;

class Button extends Sprite
{
  private var lbl_text:Label;
  private var hit_area:Sprite;
  public function new(label:String) {
    super();
    buttonMode = true;
    hit_area = new Sprite();
    lbl_text = new Label(label);
    addChild(lbl_text);
    addChild(hit_area);
    draw();
  }

  private function request_size(w, h) {
    hit_area.graphics.clear();
    hit_area.graphics.beginFill(0, 0);
    hit_area.graphics.drawRect(0, 0, width, height);
  }

  private function draw() {
    var width = lbl_text.width + 10;
    var height = lbl_text.height + 5;
    graphics.lineStyle(0, 0xAAAAAA);
    graphics.beginFill(0xDDDDDD);
    graphics.drawRect(0, 0, width, height);
    lbl_text.x = 5;
    lbl_text.y = 2.5;
    request_size(width, height);
  }
}
