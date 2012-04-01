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

import flash.display.Sprite;
import flash.display.Graphics;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

class OrthicTriangle extends Sprite
{
  public static var stage = flash.Lib.current.stage;

  static function main() {
    stage.align = StageAlign.TOP_LEFT;
    stage.scaleMode = StageScaleMode.NO_SCALE;
    flash.Lib.current.addChild(new OrthicTriangle());
  }

  // Triangulo de fora
  var h1:Handle;
  var h2:Handle;
  var h3:Handle;

  // Triangulo de dentro
  var h4:Handle;
  var h5:Handle;
  var h6:Handle;

  var btn1:ToggleButton;
  var btn2:ToggleButton;
  var btn3:ToggleButton;
  var label:Label;

  public function new() {
    super();
    var s = "";
    s += "A reta é desenhada ligando o Circuncentro com o Ortocentro,\n";
    s += "não dependendo do Baricentro, o que prova a reta de Euler!";

    btn1 = new ToggleButton("Esconder medianas");
    btn2 = new ToggleButton("Esconder alturas");
    btn3 = new ToggleButton("Esconder mediatrizes");
    label = new Label(s);

    h1 = new Handle();
    h2 = new Handle();
    h3 = new Handle();

    h1.onMove = onMove;
    h2.onMove = onMove;
    h3.onMove = onMove;

    addChild(h1);
    addChild(h2);
    addChild(h3);
    addChild(btn1);
    addChild(btn2);
    addChild(btn3);
    addChild(label);

    btn1.addEventListener("toggled", redraw);
    btn2.addEventListener("toggled", redraw);
    btn3.addEventListener("toggled", redraw);
    EulerLine.stage.addEventListener(Event.RESIZE, reposition);

    h1.x = 100;
    h1.y = 100;
    h2.x = 200;
    h2.y = 100;
    h3.x = 150;
    h3.y = 200;
    btn1.y = 10;
    btn2.y = 40;
    btn3.y = 70;

    reposition(null);

    draw(graphics);
  }

  public function reposition(e) {
    var width = EulerLine.stage.stageWidth;
    var height = EulerLine.stage.stageHeight;
    label.y = height-label.height;
    label.x = (width-label.width)/2;
    var max = (btn1.width > btn2.width)? btn1.width:btn2.width;
    if (btn3.width > max) max = btn3.width;
    btn1.x = width-max-10;
    btn2.x = width-max-10;
    btn3.x = width-max-10;
  }

  public function onMove(e:HandleEvent) {
    e.target.x = e.x;
    e.target.y = e.y;
    draw(graphics);
  }

  public function redraw(e) {
    draw(graphics);
  }

  public function draw(g:Graphics) {
    var v1 = new Vector(h1.x, h1.y);
    var v2 = new Vector(h2.x, h2.y);
    var v3 = new Vector(h3.x, h3.y);
    var t = new Triangle(v1, v2, v3);
    var bc = t.barycenter();
    var oc = t.orthocenter();
    var cc = t.circumcenter();
    var med = t.medians();
    g.clear();
    g.lineStyle(0);
    g.moveTo(v1.x, v1.y);
    g.lineTo(v2.x, v2.y);
    g.lineTo(v3.x, v3.y);
    g.lineTo(v1.x, v1.y);

    if (!btn1.toggled) {
      g.lineStyle(0, 0xFF0000);
      g.moveTo(v1.x, v1.y);
      g.lineTo(bc.x, bc.y);
      g.lineTo(v2.x, v2.y);
      g.moveTo(v3.x, v3.y);
      g.lineTo(bc.x, bc.y);
    }

    if (!btn2.toggled) {
      g.lineStyle(0, 0xCC00);
      g.moveTo(v1.x, v1.y);
      g.lineTo(oc.x, oc.y);
      g.lineTo(v2.x, v2.y);
      g.moveTo(v3.x, v3.y);
      g.lineTo(oc.x, oc.y);
    }

    if (!btn3.toggled) {
      g.lineStyle(0, 0xFF);
      g.moveTo(med[0].x, med[0].y);
      g.lineTo(cc.x, cc.y);
      g.lineTo(med[1].x, med[1].y);
      g.moveTo(med[2].x, med[2].y);
      g.lineTo(cc.x, cc.y);
    }

    g.lineStyle(0, 0xFF8800);
    g.moveTo(oc.x, oc.y);
    g.lineTo(cc.x, cc.y);

    g.lineStyle(0);
    g.drawCircle(bc.x, bc.y, 3);
    g.drawCircle(oc.x, oc.y, 3);
    g.drawCircle(cc.x, cc.y, 3);
    g.drawCircle(cc.x, cc.y, v1.minus(cc).length());
  }
}


