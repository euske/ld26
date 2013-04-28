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
  // Dead sound.
  [Embed(source="../assets/dead.mp3")]
  private static const DeadSoundCls:Class;
  private static const deadsound:Sound = new DeadSoundCls();

  // last updated strength.
  private var _strength:int;
  private var _startpos:Point;

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
	_blink = 0;
	movesound.play();
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
	_blink = 0;
	movesound.play();
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
  private var _jumpkey:Boolean;
  public function jump():void
  {
    if (_construction) return;
    if (_jumpkey) return;
    _jumpkey = true;

    switch (_strength) {
    case 2:
      jump2sound.play();
      break;
    case 3:
      jump3sound.play();
      break;
    case 4:
      attacksound.play();
      break;
    default:
      jump1sound.play();
      break;
    }
    setVelocity(-_strength*10);
  }

  // die()
  public function die():void
  {
    deadsound.play();
    bounds.x = _startpos.x;
    bounds.y = _startpos.y-unit;
    _strength = 1;
  }

  // setMode
  public override function setMode(construction:Boolean):void
  {
    super.setMode(construction);
    
    if (construction) {
      bounds.x = Math.floor(bounds.x/unit)*unit;
      bounds.y = Math.floor(bounds.y/unit)*unit;
    } else {
      _startpos = new Point(bounds.x, bounds.y);
      _strength = 1;
    }    
    
    this.alpha = 1.0;
    graphics.clear();
    graphics.beginFill(0x00cc00);
    graphics.drawRect(0, 0, unit, unit);
    graphics.endFill();
  }
  
  // blinking status.
  private var _blink:int;
  private static const cycle:int = 10;

  public override function update():void
  {
    super.update();
    if (_construction) {
      _blink++;
      var phase:int = (_blink % (cycle*2));
      this.alpha = ((phase < cycle)? (cycle-phase) : (phase-cycle))/(cycle-1);
    } else {
      var contacts:Array = scene.getOverlappingMaterials(getOffsetRect(0, +1));
      if (contacts.length != 0) {
	_strength = 1;
      }
      for each (var material:Material in contacts) {
	_strength = Math.max(_strength, material.strength);
      }
    }
  }
}

} // package
