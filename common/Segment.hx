
class Segment
{
  public var v1:Vector;
  public var v2:Vector;
  public var dir:Vector;
  public function new(v1:Vector, v2:Vector) {
    this.v1 = v1;
    this.v2 = v2;
    this.dir = v2.minus(v1);
  }

  public static function intersect(v1:Vector, v2:Vector, w1:Vector, w2:Vector)
  {
    var s1:Segment = new Segment(v1, v2);
    var s2:Segment = new Segment(w1, w2);

    var d = s1.dir.cross(s2.dir);
    if (d == 0) return null;
    var t = s2.v1.minus(v1).cross(s2.dir) / d;
    return s1.dir.mult(t).plus(v1);
  }
}
