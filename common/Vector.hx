
class Vector
{
  public var x:Float;
  public var y:Float;
  public function new(x:Float, y:Float) {
    this.x = x;
    this.y = y;
  }

  public inline function dot(v:Vector) {
    return x*v.x + y*v.y;
  }

  public inline function cross(v:Vector) {
    return x*v.y - y*v.x;
  }

  public inline function length() {
    return Math.sqrt(x*x + y*y);
  }

  public inline function minus(v:Vector) {
    return new Vector(x-v.x, y-v.y);
  }

  public inline function plus(v:Vector) {
    return new Vector(x+v.x, y+v.y);
  }

  public inline function mult(t:Float) {
    return new Vector(x*t, y*t);
  }

  public inline function ortho() {
    return new Vector(-y, x);
  }
}
