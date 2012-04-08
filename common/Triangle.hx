
class Triangle
{
  var v1:Vector;
  var v2:Vector;
  var v3:Vector;
  public function new(v1, v2, v3) {
    this.v1 = v1;
    this.v2 = v2;
    this.v3 = v3;
  }

  public function medians() {
    var m1 = v2.plus(v3.minus(v2).mult(0.5));
    var m2 = v3.plus(v1.minus(v3).mult(0.5));
    var m3 = v1.plus(v2.minus(v1).mult(0.5));
    return [m1, m2, m3];
  }

  public function heihgts() {
    var h1 = v2.plus(v3.minus(v2).proj(v1.minus(v2)));
    var h2 = v3.plus(v1.minus(v3).proj(v2.minus(v3)));
    var h3 = v1.plus(v2.minus(v1).proj(v3.minus(v1)));
    return [h1, h2, h3];
  }

  public function barycenter() {
    var m1 = v2.plus(v3.minus(v2).mult(0.5));
    var m2 = v3.plus(v1.minus(v3).mult(0.5));
    return Segment.intersect(v1, m1, v2, m2);
  }

  public function orthocenter() {
    var d1 = v2.minus(v3).ortho();
    var h1 = Segment.intersect(v1, d1.plus(v1), v2, v3);
    var d2 = v1.minus(v3).ortho();
    var h2 = Segment.intersect(v2, d2.plus(v2), v1, v3);
    return Segment.intersect(v1, h1, v2, h2);
  }

  public function circumcenter() {
    var m1 = v2.plus(v3.minus(v2).mult(0.5));
    var m2 = v3.plus(v1.minus(v3).mult(0.5));
    var d1 = m1.plus(v2.minus(v3).ortho());
    var d2 = m2.plus(v1.minus(v3).ortho());
    return Segment.intersect(d1, m1, d2, m2);
  }
}
