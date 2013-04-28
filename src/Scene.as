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
  // a list of deployed materials.
  private var _materials:Array = null;
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

  // Start sound.
  [Embed(source="../assets/start.mp3")]
  private static const StartSoundCls:Class;
  private static const startsound:Sound = new StartSoundCls();
  // Switch sound.
  [Embed(source="../assets/switch.mp3")]
  private static const SwitchSoundCls:Class;
  private static const switchsound:Sound = new SwitchSoundCls();
  // Push sound.
  [Embed(source="../assets/push.mp3")]
  private static const PushSoundCls:Class;
  private static const pushsound:Sound = new PushSoundCls();

  // Scene(width, height)
  public function Scene(width:int, height:int)
  {
    this.size = new Point(width, height);
    _window = new Rectangle(0, 0, width, height);
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
    this.level = level;

    switch (level) {
    case 0:
      _platesize = new Point(300, 300);
      updateCaption("PUSH MATERIALS WITH CURSOR AND\nHOP ONTO THE LEFT PLATFORM.");
      // carrot
      addMaterial(new Material(this, 7, 11, 3, 1, 0, 0xff8800, 0));
      // cucumber
      addMaterial(new Material(this, 11, 8, 1, 3, 1, 0x116600, 0));
      // platform
      setPlatform(4, 10, 13, 10);
      player = new Player(this, 7, 3);
      break;

    case 1:
      _platesize = new Point(400, 400);
      updateCaption("STICK MATERIALS TOGETHER AND\nJUMP HIGHER.");
      // tomato
      addMaterial(new Material(this, 7, 8, 2, 2, 2, 0xff0000, 0));
      // cucumber
      addMaterial(new Material(this, 11, 7, 1, 3, 1, 0x116600, 0));
      // platform
      setPlatform(3, 9, 15, 7);
      player = new Player(this, 7, 3);
      break;

    case 2:
      _platesize = new Point(500, 400);
      updateCaption("ROASTING MAKES FOOD SHRINK BUT HARDER.");
      // factories
      addFactory(new RoastingFactory(new Rectangle(10, size.y-10-80, 120, 80),
				     0xff0000, "ROAST"));
      // tomato
      addMaterial(new Material(this, 7, 6, 2, 2, 2, 0xff0000, 0xff4400));
      // cucumber
      addMaterial(new Material(this, 13, 7, 1, 3, 1, 0x116600, 0x337700));
      // pork
      addMaterial(new Material(this, 5, 10, 3, 2, 0, 0xffaacc, 0xffccee));
      //addFactory(new SeasoningFactory(new Rectangle(size.x-20-160, size.y-20-80, 160, 80),
      //0x008844, "SEASON"));
      // beef
      //addMaterial(new Material(this, 5, 10, 3, 3, 0, 0xcc88cc, 0x884444));
      // pork
      //addMaterial(new Material(this, 4, 4, 7, 3, 0, 0xffcccc, 0xcc8888));
      // lettuce
      //addMaterial(new Material(this, 5, 5, 7, 7, 0, 0x88ffcc, 0x88ff88));
      // tofu
      //addMaterial(new Material(this, 6, 6, 5, 5, 0, 0xcccccc, 0xffffcc));
      // carrot
      //addMaterial(new Material(this, 7, 7, 3, 5, 0, 0xcccc88, 0xcccc88));
      //addActor(new Enemy(this, 5, 5));
      // 
      setPlatform(0, 10, 18, 10);
      player = new Player(this, 7, 3);
      break;

    default:
      throw new Error("MLG");

    }

    addActor(player);
    setMode(true);
    return player;
  }

  // clearLevel(): erase everything in the current level.
  private function clearLevel():void
  {
    for each (var actor:Actor in _actors) {
      removeChild(actor);
    }
    _actors = new Array();
    for each (var material:Material in _materials) {
      removeChild(material);
    }
    _materials = new Array();
    for each (var factory:Factory in _materials) {
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

  // addMaterial(material)
  public function addMaterial(material:Material):void
  {
    addChild(material);
    _materials.push(material);
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

  // getOverlappingMaterials(rect)
  public function getOverlappingMaterials(rect:Rectangle):Array
  {
    var contacts:Array = new Array();
    for each (var material:Material in _materials) {
      if (material.bounds.intersects(rect)) {
	contacts.push(material);
      }
    }
    return contacts;
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

  // setPlayerState(player)
  public function setPlayerState(player:Player):Boolean
  {
    if (_construction) {
      // construction.
      if (_start.hasContactY(player) < 0) {
	// start the platformer.
	setMode(false);
	startsound.play();
      }
    } else {
      // platform.
      if (_goal.hasContactY(player) < 0) {
	// finish the level.
	return true;
      } else if (size.y <= player.bounds.bottom) {
	// dead.
	player.die();
	setMode(true);
      }
    }
    return false;
  }

  // setMode(construction)
  public function setMode(construction:Boolean):void
  {
    _construction = construction;
    var factory:Factory;
    for each (var actor:Actor in _actors) {
      actor.setMode(_construction);
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
    var material:Material;
    // move _actors.
    for each (material in _materials) {
      material.clearForce();
    }
    for each (var actor:Actor in _actors) {
      actor.update();
    }
    for each (material in _materials) {
      material.update();
    }
    if (_construction) {
      // move/update materials.
      var pushed:Boolean = false;
      for each (material in _materials) {
	  if (material.vx != 0 || material.vy != 0) {
	    pushed = true;
	  }
	  for each (var factory:Factory in _factories) {
	      if (factory.canAcceptMaterial(material)) {
		factory.putMaterial(material);
	      }
	    }
	}
      if (pushed) {
	pushsound.play();
      }
      // detect grouped materials.
      for each (material in _materials) {
	  material.clearConnection();
	}
      for each (material in _materials) {
	  for each (var m:Material in _materials) {
	      if (material.hasContact(m)) {
		material.makeConnection(m);
	      }
	    }
	}
      for each (material in _materials) {
	  material.fixateConnection();
	}
      var groups:Array = new Array();
      for each (material in _materials) {
	  if (material.group != null && groups.indexOf(material.group) == -1) {
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
    for each (var material:Material in _materials) {
      material.repaint();
    }
    // update the platform.
    _start.repaint();
    _goal.repaint();
  }

  // setPlatform:
  private var _start:Platform;
  private var _goal:Platform;
  private function setPlatform(x0:int, y0:int, x1:int, y1:int):void
  {
    if (_start != null) {
      removeChild(_start);
    }
    _start = new Platform(this, x0, y0);
    addChild(_start);
    if (_goal != null) {
      removeChild(_goal);
    }
    _goal = new Platform(this, x1, y1);
    addChild(_goal);
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
    graphics.clear();

    // draw the plate.
    var h:int = _platesize.y*_plate/maxplate;
    var r:Rectangle = new Rectangle((size.x-_platesize.x)/2, size.y-h, 
				    _platesize.x, h);
    graphics.beginFill(0xffffff);
    graphics.drawEllipse(r.x, r.y, r.width, r.height);
    graphics.endFill();
    graphics.lineStyle(4, 0x000000);
    r.inflate(-r.width/8, -r.height/8);
    graphics.drawEllipse(r.x, r.y, r.width, r.height);
  }

}

} // package

import flash.geom.Rectangle;
import Entity;

class Platform extends Entity
{
  public function Platform(scene:Scene, x:int, y:int)
  {
    super(scene, new Rectangle(Entity.unit*x, Entity.unit*y, 
			       Entity.unit*2, Entity.unit*1));

    graphics.beginFill(0x888888);
    graphics.drawRect(0, 0, bounds.width, bounds.height);
    graphics.endFill();
    graphics.lineStyle(4, 0xffffff);
    graphics.drawRect(0, 0, bounds.width, bounds.height);
  }
}
