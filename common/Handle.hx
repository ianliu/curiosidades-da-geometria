import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

typedef HandleEvent = {
  var x:Float;
  var y:Float;
  var target:Handle;
}

private typedef ConstrainData = {
  var h1:Handle;
  var h2:Handle;
}

class HandleMoveEvent extends Event
{
  public var x:Float;
  public var y:Float;

  public function new(x:Float, y:Float) {
    super("move");
    this.x = x;
    this.y = y;
  }
}

class Handle extends Sprite
{
  private var constrainData:ConstrainData;

  public function new(color:Int = 0xCCCCCC, size:Int = 8) {
    super();
    var g = graphics;
    constrainData = null;
    buttonMode = true;
    g.lineStyle(0, 0x666666);
    g.beginFill(color, 0.5);
    g.drawCircle(0, 0, size);
    addEventListener(MouseEvent.MOUSE_DOWN, onPress);
  }

  private function linearConstrainFunc(event:HandleEvent) {
    if (constrainData == null)
      return;

    var h1 = constrainData.h1;
    var h2 = constrainData.h2;
    var p:Vector;
    var mouse = new Vector(event.x, event.y);
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
      p = v1.plus(u.proj(v));

    this.x = p.x;
    this.y = p.y;
  }

  public function constrain(h1:Handle, h2:Handle) {
    if (h1 == null || h2 == null) {
      constrainData = null;
      this.onMove = null;
    } else {
      constrainData = {h1:h1, h2:h2};
      this.onMove = linearConstrainFunc;
    }
  }

  public dynamic function onMove(e) { }

  private function onMouseMove(e) {
    onMove({x: e.stageX, y: e.stageY, target: this});
    dispatchEvent(new HandleMoveEvent(e.stageX, e.stageY));
  }

  private function onPress(e) {
    var s = flash.Lib.current.stage;
    s.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    s.addEventListener(MouseEvent.MOUSE_UP, onRelease);
  }

  private function onRelease(e) {
    var s = flash.Lib.current.stage;
    s.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    s.removeEventListener(MouseEvent.MOUSE_UP, onRelease);
  }
}
