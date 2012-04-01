import flash.events.Event;
import flash.events.MouseEvent;

class ToggleButtonEvent extends Event
{
  public var toggled:Bool;
  public function new(toggled) {
    super("toggled");
    this.toggled = toggled;
  }
}

class ToggleButton extends Button
{
  public var toggled:Bool;

  public function new(label) {
    super(label);
    toggled = false;
    addEventListener(MouseEvent.CLICK, onClick);
  }

  private function onClick(e) {
    toggled = !toggled;
    draw();
    dispatchEvent(new ToggleButtonEvent(toggled));
  }

  private override function draw() {
    var width = lbl_text.width + 20;
    var height = lbl_text.height + 5;
    graphics.clear();
    graphics.lineStyle(2, 0xAAAAAA);
    graphics.beginFill(0xFFFFFF);
    var o = (height-10)/2;
    graphics.drawRect(0, o, 10, 10);
    graphics.endFill();
    if (toggled) {
      graphics.lineStyle(2);
      graphics.moveTo(0, 4+o);
      graphics.lineTo(4, 8+o);
      graphics.lineTo(12, o);
    }
    lbl_text.x = 15;
    lbl_text.y = 2.5;
    request_size(width, height);
  }
}
