/*
 * EulerLine.hx
 * This file is part of "Linha de Euler"
 *
 * Copyright (C) 2009 - Ian Liu Rodrigues
 *
 * "Linha de Euler" is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * "Linha de Euler" is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
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
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.events.MouseEvent;
import flash.events.Event;

typedef HandleEvent = {
  var x:Float;
  var y:Float;
  var target:Handle;
}

class Label
extends TextField
{
  public var format:TextFormat;
  public var label:String;
  public function new(label:String) {
    super();
    this.label = label;
    format = new TextFormat("Verdana", 11);
    autoSize = TextFieldAutoSize.LEFT;
    multiline = true;
    selectable = false;
    defaultTextFormat = format;
    text = label;
  }
}

class Button
extends Sprite
{
  private var lbl_text:Label;
  private var hit_area:Sprite;
  public function new(label:String) {
    super();
    buttonMode = true;
    hit_area = new Sprite();
    lbl_text = new Label(label);
    addChild(lbl_text);
    addChild(hit_area);
    draw();
  }

  private function request_size(w, h) {
    hit_area.graphics.clear();
    hit_area.graphics.beginFill(0, 0);
    hit_area.graphics.drawRect(0, 0, width, height);
  }

  private function draw() {
    var width = lbl_text.width + 10;
    var height = lbl_text.height + 5;
    graphics.lineStyle(0, 0xAAAAAA);
    graphics.beginFill(0xDDDDDD);
    graphics.drawRect(0, 0, width, height);
    lbl_text.x = 5;
    lbl_text.y = 2.5;
    request_size(width, height);
  }
}

class ToggleButtonEvent
extends Event
{
  public var toggled:Bool;
  public function new(toggled) {
    super("toggled");
    this.toggled = toggled;
  }
}

class ToggleButton
extends Button
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

class Handle
extends Sprite
{
  public function new() {
    super();
    buttonMode = true;
    var g = graphics;
    g.lineStyle(0, 0x666666);
    g.beginFill(0xCCCCCC, 0.5);
    g.drawCircle(0, 0, 8);
    addEventListener(MouseEvent.MOUSE_DOWN,
                     onPress);
  }

  public dynamic function onMove(e) { }

  private function onMouseMove(e) {
    onMove({x: e.stageX, y: e.stageY, target: this});
  }

  private function onPress(e) {
    EulerLine.stage.addEventListener(
        MouseEvent.MOUSE_MOVE,
        onMouseMove);
    EulerLine.stage.addEventListener(
        MouseEvent.MOUSE_UP,
        onRelease);
  }

  private function onRelease(e) {
    EulerLine.stage.removeEventListener(
        MouseEvent.MOUSE_MOVE,
        onMouseMove);
    EulerLine.stage.removeEventListener(
        MouseEvent.MOUSE_UP,
        onRelease);
  }
}

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

class EulerLine
extends Sprite
{
  public static var stage = flash.Lib.current.stage;

  static function main() {
    stage.align = StageAlign.TOP_LEFT;
    stage.scaleMode = StageScaleMode.NO_SCALE;
    flash.Lib.current.addChild(new EulerLine());
  }

  var h1:Handle;
  var h2:Handle;
  var h3:Handle;
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

