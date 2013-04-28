package {

import flash.display.Sprite;
import flash.media.Sound;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Material
//
public class Material extends Entity
{
  // group: An array of materials it belongs.
  public var group:Array;
  // shape:
  public var shape:int;
  // raw material color.
  public var rawcolor:uint;
  // roasted material color.
  public var roastedcolor:uint;

  // true if roasted.
  private var _roasted:Boolean;
  // true if seasoned.
  private var _seasoned:Boolean;
  // glow
  private var _glow:Glow;

  // Connected sound.
  [Embed(source="../assets/connected.mp3")]
  private static const ConnectedSoundCls:Class;
  private static const connectedsound:Sound = new ConnectedSoundCls();

  // Material(scene, pt)
  public function Material(scene:Scene, 
			   x:int, y:int, width:int, height:int, 
			   shape:int, rawcolor:uint, roastedcolor:uint)
  {
    super(scene, new Rectangle(x*unit, y*unit, width*unit, height*unit));
    this.shape = shape;
    this.rawcolor = rawcolor;
    this.roastedcolor = roastedcolor;
    _glow = new Glow(bounds.width, bounds.height);
    addChild(_glow);
    updateGraphics();
  }

  // clearForce(): clear forces.
  public function clearForce():void
  {
    vx = 0;
    vy = 0;
  }

  // applyForce(dx, dy): apply forces, returns true if it's movable.
  public function applyForce(dx:int, dy:int):Boolean
  {
    var r:Rectangle = getOffsetRect(dx, dy);
    if (vx != 0 || vy != 0) return false;
    if (!scene.isInsidePlate(r)) return false;
    for each (var material:Material in scene.getOverlappingMaterials(r)) {
      if (material != this) {
	if (!material.applyForce(dx, dy)) return false;
      }
    }
    vx = dx;
    vy = dy;
    return true;
  }

  // clearConnection(): clear connections.
  public function clearConnection():void
  {
    this.group = null;
  }

  // makeConnection(material): connect two materials.
  public function makeConnection(material:Material):void
  {
    if (this.group == null) {
      if (material.group != null) {
	this.group = material.group;
	this.group.push(this);
      } else {
	// this.group == null, material.group == null
	var a:Array = new Array();
	a.push(this);
	this.group = a;
	a.push(material);
	material.group = a;
      }
    } else {
      if (material.group == null) {
	material.group = this.group;
	material.group.push(material);
      } else {
	// this.group != null, material.group != null
	material.group.concat(this.group);
	for each (var m:Material in this.group) {
	  m.group = material.group;
	}
      }
    }
  }

  // fixateConnection():
  private var _strength:int;
  public function fixateConnection():void
  {
    var strength:int = (this.group == null)? 1 : this.group.length;
    if (_strength < strength && 
	this.group != null && this.group[0] == this) {
      connectedsound.play();
    }
    if (_strength != strength) {
      _strength = strength;
      updateGraphics();
    }
  }

  // strength
  public function get strength():int
  {
    return _strength;
  }

  // roast()
  public function roast():void
  {
    _roasted = true;
    updateGraphics();
  }

  // season()
  public function season():void
  {
    _seasoned = true;
    updateGraphics();
  }

  // blinking status.
  private var _blink:int;
  private static const cycle:int = 10;

  public override function update():void
  {
    super.update();
    _blink++;
    var phase:int = (_blink % (cycle*2));
    _glow.alpha = ((phase < cycle)? (cycle-phase) : (phase-cycle))/(cycle-1);
  }

  // updateGraphics()
  private function updateGraphics():void
  {
    graphics.clear();
    graphics.beginFill((_roasted)? roastedcolor : rawcolor);
    switch (shape) {
    case 1:
      graphics.drawRoundRect(0, 0, bounds.width, bounds.height, 8, 8);
      break;
    case 2:
      graphics.drawEllipse(0, 0, bounds.width, bounds.height);
      break;
    default:
      graphics.drawRect(0, 0, bounds.width, bounds.height);
      break;
    }
    graphics.endFill();
    if (_seasoned) {
      var v:int = (917+bounds.width)*(43+bounds.height);
      for (var i:int = 0; i < 10; i++) {
	var x:int = v % (bounds.width-4);
	v = ((v+729)*899) % 65537;
	var y:int = v % (bounds.height-4);
	v = ((v+729)*899) % 65537;
	graphics.beginFill(0);
	graphics.drawRect(x, y, 4, 4);
	graphics.endFill();
      }
    }
    _glow.setStrength(strength);
  }
}

} // package

import flash.display.Shape;

class Glow extends Shape
{
  private var _width:int;
  private var _height:int;

  public function Glow(width:int, height:int)
  {
    _width = width;
    _height = height;
  }

  public function setStrength(strength:int):void
  {
    graphics.clear();
    switch (strength) {
    case 0:
    case 1:
      break;
    case 2:
      graphics.lineStyle(2, 0xffff00);
      graphics.drawRect(0, 0, _width, _height);
      break;
    case 3:
      graphics.lineStyle(4, 0xff8800);
      graphics.drawRect(0, 0, _width, _height);
      break;
    default:
      graphics.lineStyle(4, 0xcc0000);
      graphics.drawRect(0, 0, _width, _height);
      break;
    }
  }
}

