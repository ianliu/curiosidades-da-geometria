import flash.display.Sprite;
import flash.events.MouseEvent;

typedef HandleEvent = {
  var x:Float;
  var y:Float;
  var target:Handle;
}

class Handle extends Sprite
{
  static var stage = flash.Lib.current.stage;

  public function new() {
    super();
    buttonMode = true;
    var g = graphics;
    g.lineStyle(0, 0x666666);
    g.beginFill(0xCCCCCC, 0.5);
    g.drawCircle(0, 0, 8);
    addEventListener(MouseEvent.MOUSE_DOWN, onPress);
  }

  public function constrain(h1:Handle, h2:Handle) {
    this.onMove = function (e) {
      var p:Vector;
      var mouse = new Vector(e.x, e.y);
      var v1 = new Vector(h1.x, h1.y);
      var v2 = new Vector(h2.x, h2.y);
      var u = v2.minus(v1);
      var v = mouse.minus(v1);
      var w = mouse.minus(v2);

      if (v.dot(u) < 0)
        p = v1;
      else if (w.dot(u) > 0)
        p = v2;
      else
        p = v1.plus(v.proj(u));

      e.target.x = p.x;
      e.target.y = p.y;
    }
  }

  public dynamic function onMove(e) { }

  private function onMouseMove(e) {
    onMove({x: e.stageX, y: e.stageY, target: this});
  }

  private function onPress(e) {
    Handle.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    Handle.stage.addEventListener(MouseEvent.MOUSE_UP, onRelease);
  }

  private function onRelease(e) {
    Handle.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    Handle.stage.removeEventListener(MouseEvent.MOUSE_UP, onRelease);
  }
}
