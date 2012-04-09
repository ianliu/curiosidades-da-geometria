/*
 * OrthicTriangle.hx
 * This file is part of Curiosidades da Geometria
 *
 * Copyright (C) 2012 - Ian Liu Rodrigues
 *
 * Curiosidades da Geometria is free software; you can redistribute it
 * and/or modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 *
 * Curiosidades da Geometria is distributed in the hope that it will be
 * useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with "Linha de Euler"; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, 
 * Boston, MA  02110-1301  USA
 */

import Handle;
import flash.display.Sprite;
import flash.display.Graphics;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

class OrthicTriangle extends Sprite
{
  public static var stage = flash.Lib.current.stage;

  var minPerimeter:Float;

  // Triangulo de fora
  var h1:Handle;
  var h2:Handle;
  var h3:Handle;

  // Triangulo de dentro
  var h4:Handle;
  var h5:Handle;
  var h6:Handle;

  var showHeights : ToggleButton;
  var minPerimeterLabel : Label;
  var currentPerimeterLabel : Label;

  public function new() {
    super();

    h1 = new Handle();
    h2 = new Handle();
    h3 = new Handle();
    h4 = new Handle(0xff0000, 4);
    h5 = new Handle(0x00ff00, 4);
    h6 = new Handle(0x0000ff, 4);
    showHeights = new ToggleButton("Mostrar alturas");
    minPerimeterLabel = new Label("");
    currentPerimeterLabel = new Label("");

    h1.onMove = onOutterMove;
    h2.onMove = onOutterMove;
    h3.onMove = onOutterMove;
    h4.constrain(h1, h2);
    h5.constrain(h2, h3);
    h6.constrain(h3, h1);
    h4.addEventListener("move", innerMoved);
    h5.addEventListener("move", innerMoved);
    h6.addEventListener("move", innerMoved);
    showHeights.addEventListener("toggled", redraw);
    OrthicTriangle.stage.addEventListener(Event.RESIZE, reposition);

    for (w in [h1, h2, h3, h4, h5, h6, showHeights,
         minPerimeterLabel, currentPerimeterLabel])
      addChild(w);

    var w = OrthicTriangle.stage.stageWidth;
    var h = OrthicTriangle.stage.stageHeight;

    h1.x = w * 0.1;
    h1.y = h * 0.1;
    h2.x = w * 0.7;
    h2.y = h * 0.2;
    h3.x = w * 0.5;
    h3.y = h * 0.7;

    reposition();
    minPerimeter = calculateMaxPerimeter();
    updateInnerTri();
    draw(graphics);
  }

  public function reposition(?e:Event = null) {
    var width = OrthicTriangle.stage.stageWidth;
    var height = OrthicTriangle.stage.stageHeight;
    var max = 300;
    minPerimeterLabel.x = width - max - 10;
    minPerimeterLabel.y = 40;
    showHeights.x = width - max - 10;
    showHeights.y = 10;
    currentPerimeterLabel.x = width - max - 10;
    currentPerimeterLabel.y = 70;
  }

  function updateInnerTri() {
    var u = new Vector(h1.x, h1.y);
    var v = new Vector(h2.x, h2.y);
    var p = u.plus(v.minus(u).mult(0.5));
    h4.x = p.x;
    h4.y = p.y;

    u = new Vector(h2.x, h2.y);
    v = new Vector(h3.x, h3.y);
    p = u.plus(v.minus(u).mult(0.5));
    h5.x = p.x;
    h5.y = p.y;

    u = new Vector(h3.x, h3.y);
    v = new Vector(h1.x, h1.y);
    p = u.plus(v.minus(u).mult(0.5));
    h6.x = p.x;
    h6.y = p.y;

    calculatePerimeter();
  }

  public function onOutterMove(e:HandleEvent) {
    e.target.x = e.x;
    e.target.y = e.y;
    minPerimeter = calculateMaxPerimeter();
    updateInnerTri();
    draw(graphics);
  }

  function calculateMaxPerimeter() {
    var v1 = new Vector(h1.x, h1.y);
    var v2 = new Vector(h2.x, h2.y);
    var v3 = new Vector(h3.x, h3.y);
    var t = new Triangle(v1, v2, v3);
    return t.perimeter();
  }

  public function redraw(e) {
    draw(graphics);
  }

  function innerMoved(e) {
    calculatePerimeter();
    draw(graphics);
  }

  function calculatePerimeter() {
    var v1 = new Vector(h4.x, h4.y);
    var v2 = new Vector(h5.x, h5.y);
    var v3 = new Vector(h6.x, h6.y);
    var t = new Triangle(v1, v2, v3);
    var p = t.perimeter();
    if (minPerimeter > p)
      minPerimeter = p;
    minPerimeterLabel.text = "Perímetro mínimo: " + Math.round(minPerimeter * 10) / 10;
    currentPerimeterLabel.text = "Perímetro atual: " + Math.round(p * 10) / 10;
  }

  public function draw(g:Graphics) {
    g.clear();
    g.lineStyle(0);
    g.moveTo(h1.x, h1.y);
    g.lineTo(h2.x, h2.y);
    g.lineTo(h3.x, h3.y);
    g.lineTo(h1.x, h1.y);

    g.lineStyle(0);
    g.moveTo(h4.x, h4.y);
    g.lineTo(h5.x, h5.y);
    g.lineTo(h6.x, h6.y);
    g.lineTo(h4.x, h4.y);

    if (showHeights.toggled) {
      var u = new Vector(h1.x, h1.y);
      var v = new Vector(h2.x, h2.y);
      var w = new Vector(h3.x, h3.y);
      var t = new Triangle(u, v, w);
      var h = t.heihgts();
      g.lineStyle(0, 0xaaaaaa);
      g.moveTo(h1.x, h1.y);
      g.lineTo(h[0].x, h[0].y);
      g.moveTo(h2.x, h2.y);
      g.lineTo(h[1].x, h[1].y);
      g.moveTo(h3.x, h3.y);
      g.lineTo(h[2].x, h[2].y);
    }
  }

  static function main() {
    stage.align = StageAlign.TOP_LEFT;
    stage.scaleMode = StageScaleMode.NO_SCALE;
    flash.Lib.current.addChild(new OrthicTriangle());
  }
}


