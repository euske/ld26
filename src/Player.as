package {

import flash.events.Event;
import flash.media.Sound;
import flash.geom.Rectangle;
import flash.geom.Point;

//  Player
//
public class Player extends Actor
{
  // Jump/attack sound.
  [Embed(source="../assets/jump1.mp3")]
  private static const Jump1SoundCls:Class;
  private static const jump1sound:Sound = new Jump1SoundCls();
  [Embed(source="../assets/jump2.mp3")]
  private static const Jump2SoundCls:Class;
  private static const jump2sound:Sound = new Jump2SoundCls();
  [Embed(source="../assets/jump3.mp3")]
  private static const Jump3SoundCls:Class;
  private static const jump3sound:Sound = new Jump3SoundCls();
  [Embed(source="../assets/attack.mp3")]
  private static const AttackSoundCls:Class;
  private static const attacksound:Sound = new AttackSoundCls();
  
  // Move sound.
  [Embed(source="../assets/move.mp3")]
  private static const MoveSoundCls:Class;
  private static const movesound:Sound = new MoveSoundCls();

  protected static const gravity:int = 2;

  // last updated strength.
  private var _strength:int;
  // _dx, _dy: intent to move.
  private var _dx:int, _dy:int;
  // _dead:
  private var _dead:Boolean;

  // Player(scene)
  public function Player(scene:Scene, x:int, y:int)
  {
    super(scene, x, y);
  }

  // setDirectionX(dx)
  public function setDirectionX(dx:int):void
  {
    if (_construction) {
      if (dx != 0) {
	_dx = dx;
      }
    } else {
      _dx = dx*4*_strength;
    }
  }

  // setDirectionY(dy)
  public function setDirectionY(dy:int):void
  {
    if (_construction) {
      if (dy != 0) {
	_dy = dy;
      }
    } else {
      if (dy != 0) {
	jump();
      } else {
	_jumpkey = false;
      }
    }
  }

  // jump()
  public static const jumpvelocity:int = 14;

  private var _jumpkey:Boolean;
  public function jump():void
  {
    if (_construction) return;
    if (_jumpkey) return;
    _jumpkey = true;

    var v:int;
    switch (_strength) {
    case 2:
      jump2sound.play();
      v = -20;
      break;
    case 3:
      jump3sound.play();
      v = -30;
      break;
    case 4:
      attacksound.play();
      v = -40
      break;
    default:
      jump1sound.play();
      v = -14
      break;
    }
    setVelocity(v);
  }

  // setMode
  public override function setMode(construction:Boolean):void
  {
    super.setMode(construction);
    _dead = false;
    _strength = 1;
    _dx = 0;
    _dy = 0;
    
    graphics.clear();
    graphics.beginFill(0x00cc00);
    graphics.drawRect(0, 0, unit, unit);
    graphics.endFill();
  }

  protected override function get blinking():Boolean
  {
    return _construction;
  }

  public function get dead():Boolean
  {
    return _dead;
  }
  
  public override function update():void
  {
    var entity:Entity;
    if (_construction) {
      vx = _dx*unit;
      vy = _dy*unit;
      _dx = 0;
      _dy = 0;
    } else {
      // platformer mode.
      vx = _dx;
      vy += gravity;
      var r:Rectangle = getOffsetRect(vx, vy);
      if (scene.size.y <= r.bottom) {
	_dead = true;
      }
      for each (entity in scene.getOverlappingEntities(r)) {
	if (entity is Enemy) {
	  var enemy:Enemy = Enemy(entity);
	  if (enemy.lethal) {
	    _dead = true;
	  }
	}
      }
    }
    super.update();
    if (_construction) {
      if (moving) {
	movesound.play();
	resetblink();
      }
    } else {
      // platformer mode.
      var entities:Array = scene.getOverlappingEntities(getOffsetRect(0, +1));
      if (entities.length != 0) {
	_strength = 1;
      }
      for each (entity in entities) {
	if (entity is Material) {
	  var material:Material = Material(entity);
	  _strength = Math.max(_strength, material.strength);
	}
      }
    }
  }
}

} // package
