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
  // perishable:
  public var perishable:Boolean;
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
  [Embed(source="../assets/connect1.mp3")]
  private static const Connect1SoundCls:Class;
  private static const connect1sound:Sound = new Connect1SoundCls();
  // Roasted sound.
  [Embed(source="../assets/roast.mp3")]
  private static const RoastSoundCls:Class;
  private static const roastsound:Sound = new RoastSoundCls();
  // Seasoned sound.
  [Embed(source="../assets/season.mp3")]
  private static const SeasonSoundCls:Class;
  private static const seasonsound:Sound = new SeasonSoundCls();


  // Material(scene, pt)
  public function Material(scene:Scene, 
			   x:int, y:int, width:int, height:int, 
			   shape:int, perishable:Boolean,
			   rawcolor:uint, roastedcolor:uint=0)
  {
    super(scene, new Rectangle(x*unit, y*unit, width*unit, height*unit));
    this.shape = shape;
    this.perishable = perishable;
    this.rawcolor = rawcolor;
    this.roastedcolor = roastedcolor;
    _glow = new Glow(this);
    addChild(_glow);
    updateGraphics();
  }

  // applyForce(dx, dy): apply forces, returns true if it's movable.
  public override function applyForce(dx:int, dy:int):Boolean
  {
    var r:Rectangle = getOffsetRect(dx, dy);
    if (vx != 0 || vy != 0) return false;
    if (!scene.isInsidePlate(r)) return false;
    for each (var entity:Entity in scene.getOverlappingEntities(r)) {
      if (entity != this) {
	if (!entity.applyForce(dx, dy)) return false;
      }
    }
    vx = dx;
    vy = dy;
    return true;
  }

  // stickable:
  public function get stickable():Boolean
  {
    return (roastedcolor == 0 || _roasted);
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
      connect1sound.play();
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
    if (!_seasoned && !_roasted && roastedcolor != 0) {
      _roasted = true;
      roastsound.play();
      bounds.width -= unit;
      bounds.height -= unit;
      updateGraphics();
    }
  }

  // season()
  public function season():void
  {
    if (!_roasted && !_seasoned) {
      _seasoned = true;
      seasonsound.play();
      updateGraphics();
    }
  }

  // bounds:
  private var _rot:int;
  public override function get bounds():Rectangle
  {
    if (_construction) {
      return super.bounds;
    } else {
      return new Rectangle(super.bounds.x, super.bounds.y+_rot, 
			   super.bounds.width, super.bounds.height);
    }
  }

  // setMode(construction)
  private var _construction:Boolean;
  public override function setMode(construction:Boolean):void
  {
    _construction = construction;
    _rot = 0;
  }

  // blinking status.
  private var _blink:int;
  private static const cycle:int = 10;

  public override function update():void
  {
    if (!_construction && perishable && !_seasoned) {
      _rot++;
    }
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
    if (shape == 3) {
      graphics.lineStyle(1, 0x888888);
      graphics.drawRect(0, 0, bounds.width, bounds.height);      
    }
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
import flash.display.Sprite;

class Glow extends Shape
{
  public var sprite:Sprite;

  public function Glow(sprite:Sprite)
  {
    this.sprite = sprite;
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
      graphics.drawRect(0, 0, sprite.width, sprite.height);
      break;
    case 3:
      graphics.lineStyle(4, 0xff8800);
      graphics.drawRect(0, 0, sprite.width, sprite.height);
      break;
    default:
      graphics.lineStyle(4, 0xcc0000);
      graphics.drawRect(0, 0, sprite.width, sprite.height);
      break;
    }
  }
}
