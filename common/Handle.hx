import flash.display.Sprite;
import flash.events.MouseEvent;

typedef HandleEvent = {
  var x:Float;
  var y:Float;
  var target:Handle;
}

class Handle extends Sprite
{
  public function new() {
    super();
    buttonMode = true;
    var g = graphics;
    g.lineStyle(0, 0x666666);
    g.beginFill(0xCCCCCC, 0.5);
    g.drawCircle(0, 0, 8);
    addEventListener(MouseEvent.MOUSE_DOWN, onPress);
  }

  public dynamic function onMove(e) { }

  private function onMouseMove(e) {
    onMove({x: e.stageX, y: e.stageY, target: this});
  }

  private function onPress(e) {
    EulerLine.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    EulerLine.stage.addEventListener(MouseEvent.MOUSE_UP, onRelease);
  }

  private function onRelease(e) {
    EulerLine.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    EulerLine.stage.removeEventListener(MouseEvent.MOUSE_UP, onRelease);
  }
}
