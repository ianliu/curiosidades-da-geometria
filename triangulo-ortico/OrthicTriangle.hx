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

  var showHeights : ToggleButton;
  var maxHeightLabel : Label;
  var currentHeightLabel : Label;

  public function new() {
    super();

    h1 = new Handle();
    h2 = new Handle();
    h3 = new Handle();
    h4 = new Handle();
    h5 = new Handle();
    h6 = new Handle();

    h1.onMove = onOutterMove;
    h2.onMove = onOutterMove;
    h3.onMove = onOutterMove;
    h4.onMove = onInnerMove;
    h5.onMove = onInnerMove;
    h6.onMove = onInnerMove;

    showHeights = new ToggleButton("Mostrar alturas");
    maxHeightLabel = new Label("");
    currentHeightLabel = new Label("");

    addChild(h1);
    addChild(h2);
    addChild(h3);
    addChild(h4);
    addChild(h5);
    addChild(h6);
    addChild(showHeights);
    addChild(maxHeightLabel);
    addChild(currentHeightLabel);

    showHeights.addEventListener("toggled", redraw);
    EulerLine.stage.addEventListener(Event.RESIZE, reposition);

    h1.x = 100; h1.y = 100;
    h2.x = 200; h2.y = 100;
    h3.x = 150; h3.y = 200;
    showHeights.y = 10;
    maxHeightLabel.y = 40;
    currentHeightLabel.y = 70;

    reposition(null);

    draw(graphics);
  }

  function maxWidth(list:Array<flash.display.DisplayObject>) {
    var max:Float = 0;

    for (w in list)
      if (w.width > max)
        max = w.width;

    return max;
  }

  public function reposition(e) {
    var width = OrthicTriangle.stage.stageWidth;
    var height = OrthicTriangle.stage.stageHeight;
    var max = maxWidth([maxHeightLabel, showHeights, currentHeightLabel]);
    maxHeightLabel.x = width - max - 10;
    showHeights.x = width - max - 10;
    currentHeightLabel.x = width - max - 10;
  }

  public function onOutterMove(e:HandleEvent) {
    e.target.x = e.x;
    e.target.y = e.y;
    draw(graphics);
  }

  public function onInnerMove(e:HandleEvent) {

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


