package {

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.media.Sound;
import flash.geom.Point;
import flash.geom.Rectangle;
import Entity;
import Actor;
import Material;

//  Scene
// 
public class Scene extends Sprite
{
  // scene size
  public var size:Point;
  // current level
  public var level:int;

  // a list of actors.
  private var _actors:Array = null;
  // a list of entities.
  private var _entities:Array = null;
  // a list of factories.
  private var _factories:Array = null;
  
  // view
  private var _window:Rectangle;
  // platesize
  private var _platesize:Point;
  // caption
  private var _caption:Bitmap;
  // construction mode
  private var _construction:Boolean = true;
  // plate status (10: full, 0: none)
  private var _plate:int = 0;
  private static const maxplate:int = 10;
  
  private var _background1:Sprite;
  private var _background2:Sprite;

  // Push sound.
  [Embed(source="../assets/push.mp3")]
  private static const PushSoundCls:Class;
  private static const pushsound:Sound = new PushSoundCls();

  // Scene(width, height)
  public function Scene(width:int, height:int)
  {
    this.size = new Point(width, height);
    _window = new Rectangle(0, 0, width, height);
    _background1 = new PeacefulBackground(width, height);
    _background2 = new AwfulBackground(width, height);
    addChild(_background1);
    addChild(_background2);
  }
  
  // setCenter(p)
  public function setCenter(p:Point, hmargin:int, vmargin:int):void
  {
    // Center the window position.
    if (p.x-hmargin < _window.x) {
      _window.x = p.x-hmargin;
    } else if (_window.x+_window.width < p.x+hmargin) {
      _window.x = p.x+hmargin-_window.width;
    }
    if (p.y-vmargin < _window.y) {
      _window.y = p.y-vmargin;
    } else if (_window.y+_window.height < p.y+vmargin) {
      _window.y = p.y+vmargin-_window.height;
    }
    
    // Adjust the window position to fit the world.
    if (_window.x < 0) {
      _window.x = 0;
    } else if (size.x < _window.x+_window.width) {
      _window.x = size.x-_window.width;
    }
    if (_window.y < 0) {
      _window.y = 0;
    } else if (size.y < _window.y+_window.height) {
      _window.y = size.y-_window.height;
    }
  }

  // translatePoint(p)
  public function translatePoint(p:Point):Point
  {
    return new Point(p.x-_window.x, p.y-_window.y);
  }

  // setLevel(level): changes the current level.
  public function setLevel(level:int):Player
  {
    var player:Player;
    if (0 <= this.level) {
      clearLevel();
    }

    switch (level) {
    case 0:
      _platesize = new Point(300, 300);
      updateCaption("PUSH MATERIALS WITH CURSOR AND\nHOP ONTO THE LEFT PLATFORM.");
      // carrot
      addEntity(new Material(this, 7, 11, 3, 1, 0, false, 0xff8800));
      // cucumber
      addEntity(new Material(this, 11, 8, 1, 3, 1, false, 0x116600));
      // platform
      addPlatform(4, 10, 13, 10);
      player = new Player(this, 7, 3);
      break;

    case 1:
      _platesize = new Point(400, 400);
      updateCaption("STICK MATERIALS TOGETHER AND\nJUMP HIGHER.");
      // tomato
      addEntity(new Material(this, 7, 8, 2, 2, 2, false, 0xff0000));
      // cucumber
      addEntity(new Material(this, 11, 7, 1, 3, 1, false, 0x116600));
      // platform
      addPlatform(3, 9, 15, 7);
      player = new Player(this, 7, 3);
      break;

    case 2:
      _platesize = new Point(500, 400);
      updateCaption("ROASTING MAKES FOOD SMALLER\nBUT STICKABLE.");
      // factories
      addFactory(new RoastingFactory(new Rectangle(10, size.y-10-80, 120, 80)));
      // tomato
      addEntity(new Material(this, 7, 6, 2, 2, 2, false, 0xff0000));
      // cucumber
      addEntity(new Material(this, 13, 7, 1, 3, 1, false, 0x116600));
      // pork
      addEntity(new Material(this, 6, 10, 3, 2, 1, false, 0xffaacc, 0xffccee));
      // platform
      addPlatform(0, 10, 18, 10);
      player = new Player(this, 7, 3);
      break;

    case 3:
      _platesize = new Point(500, 400);
      updateCaption("SEASONING MAKES FOOD LAST LONGER\nBUT NOT STICKABLE.");
      // factories
      addFactory(new SeasoningFactory(new Rectangle(size.x-10-120, size.y-10-80, 120, 80)));
      // cucumber
      addEntity(new Material(this, 6, 10, 1, 3, 1, false, 0x116600));
      // pork
      addEntity(new Material(this, 12, 8, 3, 2, 1, false, 0xffaacc, 0xffccee));
      // fish
      addEntity(new Material(this, 6, 6, 3, 1, 2, true, 0x44aacc));
      // platform
      addPlatform(0, 7, 18, 10);
      player = new Player(this, 7, 3);
      break;

    case 4:
      _platesize = new Point(450, 400);
      updateCaption("ENEMY IS ANNOYING.\nBUT IT CAN BE USED.");
      // pork
      addEntity(new Material(this, 7, 6, 3, 2, 1, false, 0xffaacc, 0xffccee));
      // cucumber
      addEntity(new Material(this, 13, 7, 1, 3, 1, false, 0x116600));
      // tofu
      addEntity(new Material(this, 6, 10, 2, 2, 3, false, 0xffffcc));
      // enemy
      addActor(new Enemy(this, false, 5, 4, 10, 10));
      // platform
      addPlatform(1, 7, 17, 9);
      player = new Player(this, 7, 3);
      break;

    case 5:
      _platesize = new Point(500, 400);
      updateCaption("STICK ALL MATERIALS AND\nATTACK THE ENEMY!");
      // factories
      addFactory(new RoastingFactory(new Rectangle(10, size.y-10-80, 120, 80)));
      // carrot
      addEntity(new Material(this, 7, 11, 3, 1, 0, false, 0xff8800));
      // cucumber
      addEntity(new Material(this, 13, 8, 1, 3, 1, false, 0x116600));
      // pork
      addEntity(new Material(this, 6, 5, 3, 2, 1, false, 0xdd88aa, 0xffccee));
      // tomato
      addEntity(new Material(this, 10, 8, 2, 2, 2, false, 0xff0000));
      // enemy
      addActor(new Enemy(this, true, 2, 5, 2, 4));
      addActor(new Enemy(this, true, 15, 2, 2, 5));
      // platform
      addPlatform(0, 10, 18, 5);
      player = new Player(this, 7, 3);
      break;

    case 6:
      _platesize = new Point(500, 400);
      updateCaption("FINAL LEVEL!\nJUST DO IT.");
      // factories
      addFactory(new RoastingFactory(new Rectangle(10, size.y-10-80, 120, 80)));
      addFactory(new SeasoningFactory(new Rectangle(size.x-10-120, size.y-10-80, 120, 80)));
      // potato
      addEntity(new Material(this, 6, 6, 3, 2, 2, false, 0xccaa44));
      // cucumber
      addEntity(new Material(this, 13, 11, 1, 3, 1, false, 0x116600));
      // pork
      addEntity(new Material(this, 10, 4, 3, 2, 1, false, 0xffaacc, 0xffccee));
      // fish
      addEntity(new Material(this, 12, 8, 3, 1, 2, true, 0x44aacc));
      // tomato
      addEntity(new Material(this, 4, 10, 2, 2, 2, false, 0xff0000));
      // enemy
      addActor(new Enemy(this, false, 7, 9, 3, 4));
      addActor(new Enemy(this, true, 15, 2, 5, 3));
      // platform
      addPlatform(0, 10, 18, 5);
      player = new Player(this, 7, 3);
      break;

    default:
      throw new Error("MLG");

    }
    this.level = level;

    addActor(player);
    return player;
  }

  // clearLevel(): erase everything in the current level.
  private function clearLevel():void
  {
    for each (var actor:Actor in _actors) {
      removeChild(actor);
    }
    _actors = new Array();
    for each (var entity:Entity in _entities) {
      removeChild(entity);
    }
    _entities = new Array();
    for each (var factory:Factory in _entities) {
      removeChild(factory);
    }
    _factories = new Array();
  }

  // addActor(actor)
  public function addActor(actor:Actor):void
  {
    addChild(actor);
    _actors.push(actor);
  }

  // addEntity(entity)
  public function addEntity(entity:Entity):void
  {
    addChild(entity);
    _entities.push(entity);
  }

  // addFactory(factory)
  public function addFactory(factory:Factory):void
  {
    addChild(factory);
    _factories.push(factory);
  }

  // hasOverlappingPlatforms(rect)
  public function hasOverlappingPlatforms(rect:Rectangle):Boolean
  {
    return (_start.bounds.intersects(rect) ||
	    _goal.bounds.intersects(rect));
  }

  // getOverlappingEntities(rect)
  public function getOverlappingEntities(rect:Rectangle):Array
  {
    var entities:Array = new Array();
    var entity:Entity;
    for each (entity in _entities) {
      if (entity.bounds.intersects(rect)) {
	entities.push(entity);
      }
    }
    for each (entity in _actors) {
      if (entity.bounds.intersects(rect)) {
	entities.push(entity);
      }
    }
    return entities;
  }

  // isInsideScreen(rect):
  public function isInsideScreen(rect:Rectangle):Boolean
  {
    return (0 <= rect.left && rect.right <= size.x &&
	    0 <= rect.top && rect.bottom <= size.y);
  }
  
  // isInsidePlate(rect):
  public function isInsidePlate(rect:Rectangle):Boolean
  {
    return (Entity.unit <= rect.left && 
	    rect.right <= size.x-Entity.unit &&
	    Entity.unit <= rect.top && 
	    rect.bottom <= size.y-Entity.unit);
  }

  // hasPlayerStarted(player)
  public function hasPlayerStarted(player:Player):Boolean
  {
    return (_construction && _start.hasContactY(player) < 0);
  }
  // hasPlayerGoaled(player)
  public function hasPlayerGoaled(player:Player):Boolean
  {
    return (!_construction && _goal.hasContactY(player) < 0);
  }

  // setMode(construction)
  public function setMode(construction:Boolean):void
  {
    _construction = construction;
    var factory:Factory;
    for each (var actor:Actor in _actors) {
      actor.setMode(_construction);
    }
    for each (var entity:Entity in _entities) {
      entity.setMode(_construction);
    }
    if (_construction) {
      for each (factory in _factories) {
	addChild(factory);
	setChildIndex(factory, 0);
      }
    } else {
      for each (factory in _factories) {
	removeChild(factory);
      }
    }
  }

  // update()
  public function update():void
  {
    var entity:Entity;
    // move actors.
    for each (entity in _entities) {
      entity.clearForce();
    }
    for each (var actor:Actor in _actors) {
      actor.update();
    }
    for each (entity in _entities) {
      entity.update();
    }
    var material:Material;
    if (_construction) {
      // move/update materials.
      var pushed:Boolean = false;
      for each (entity in _entities) {
	if (entity.moving) {
	  pushed = true;
	}
	if (entity is Material) {
	  material = Material(entity);
	  for each (var factory:Factory in _factories) {
	    if (factory.canAcceptMaterial(material)) {
	      factory.putMaterial(material);
	    }
	  }
	}
      }
      if (pushed) {
	pushsound.play();
      }
    }
    // detect grouped materials.
    for each (entity in _entities) {
	if (entity is Material) {
	  material = Material(entity);
	  material.clearConnection();
	}
    }
    for each (entity in _entities) {
	if (entity is Material) {
	  material = Material(entity);
	  if (!material.stickable) continue;
	  for each (var e:Entity in _entities) {
	    if (e is Material) {
	      var m:Material = Material(e);
	      if (!m.stickable) continue;
	      if (material.hasContact(m)) {
		material.makeConnection(m);
	      }
	    }
	  }
	}
    }
    for each (entity in _entities) {
	if (entity is Material) {
	  material = Material(entity);
	  material.fixateConnection();
	}
    }
    var groups:Array = new Array();
    for each (entity in _entities) {
	if (entity is Material) {
	  material = Material(entity);
	  if (material.group != null && 
	      groups.indexOf(material.group) == -1) {
	    groups.push(material.group);
	  }
	}
    }
    // update the plate.
    if (_construction) {
      updateGraphics(maxplate);
    } else {
      updateGraphics(0);
    }
  }

  // repaint()
  public function repaint():void
  {
    for each (var actor:Actor in _actors) {
      actor.repaint();
    }
    for each (var entity:Entity in _entities) {
      entity.repaint();
    }
    // update the platform.
    _start.repaint();
    _goal.repaint();
  }

  // addPlatform:
  private var _start:Platform;
  private var _goal:Platform;
  private function addPlatform(x0:int, y0:int, x1:int, y1:int):void
  {
    _start = new Platform(this, x0, y0);
    addEntity(_start);
    _goal = new Platform(this, x1, y1);
    addEntity(_goal);
  }

  // updateCaption(title): updates the caption.
  private function updateCaption(title:String):void
  {
    if (_caption != null) {
      removeChild(_caption);
    }
    _caption = Main.Font.render(title, 0xffffff, 2);
    _caption.x = (size.x-_caption.width)/2;
    _caption.y = 8;
    addChild(_caption);
  }

  // updateGraphics(plate): draws a plate.
  private function updateGraphics(plate:int):void
  {
    if (_plate == plate) return;
    if (_plate < plate) {
      // bring up.
      _plate++;
    } else {
      // fold down.
      _plate--;
    }
    _background1.alpha = _plate/maxplate;
    _background2.alpha = (1-_plate/maxplate);
    graphics.clear();

    // draw the plate.
    var h:int = _platesize.y*_plate/maxplate;
    var r:Rectangle = new Rectangle((size.x-_platesize.x)/2, size.y-h, 
				    _platesize.x, h);
    graphics.beginFill(0xeeffff);
    graphics.drawEllipse(r.x, r.y, r.width, r.height);
    graphics.endFill();
    r.inflate(-r.width/8, -r.height/8);
    graphics.beginFill(0xffffff);
    graphics.drawEllipse(r.x, r.y, r.width, r.height);
    graphics.endFill();
    graphics.lineStyle(2, 0x888888);
    graphics.drawEllipse(r.x, r.y, r.width, r.height);
  }

}

} // package

import flash.display.Sprite;
import flash.geom.Rectangle;
import Entity;

class Platform extends Entity
{
  public function Platform(scene:Scene, x:int, y:int)
  {
    super(scene, new Rectangle(Entity.unit*x, Entity.unit*y, 
			       Entity.unit*2, Entity.unit*1));

    graphics.beginFill(0xffffff);
    graphics.drawRect(0, 0, bounds.width, bounds.height);
    graphics.endFill();
    graphics.lineStyle(4, 0x888888);
    graphics.drawRect(0, 0, bounds.width, bounds.height);
  }
}

class PeacefulBackground extends Sprite
{
  public function PeacefulBackground(width:int, height:int)
  {
    graphics.beginFill(0xff0000);
    graphics.drawEllipse(70, 70, 70, 60);
    graphics.endFill();
    graphics.lineStyle(4, 0xff0000);
    for (var i:int = 0; i < 9; i++) {
      var t:Number = i*2*Math.PI/9;
      graphics.moveTo(40*Math.cos(t)+105, 35*Math.sin(t)+100);
      graphics.lineTo(50*Math.cos(t+0.05)+105, 40*Math.sin(t+0.05)+100);
    }
  }
}

class AwfulBackground extends Sprite
{
  public function AwfulBackground(width:int, height:int)
  {
    graphics.lineStyle(1, 0x888888);
    for (var i:int = 0; i < 9; i++) {
      var x:int = ((i*4)%11)*30+100;
      var y:int = i*20+100;
      graphics.moveTo(x, y);
      graphics.lineTo(x+150, y);
    }
  }
}
