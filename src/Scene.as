package {

import flash.display.Sprite;
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
  // a list of actors.
  public var actors:Array = null;
  // a list of deployed materials.
  public var materials:Array = null;
  // a list of factories.
  public var factories:Array = null;

  // scene size
  private var _scenesize:Point;
  // view
  private var _window:Rectangle;
  // construction
  private var _construction:Boolean = true;
  // plate status (10: full, 0: none)
  private var _plate:int = 0;

  // Switch sound.
  [Embed(source="../assets/switch.mp3")]
  private static const SwitchSoundCls:Class;
  private static const switchsound:Sound = new SwitchSoundCls();

  // Scene(width, height)
  public function Scene(width:int, height:int)
  {
    _scenesize = new Point(width, height);
    _window = new Rectangle(0, 0, width, height);

    updatePlate(10);
  }

  // size
  public function get size():Point
  {
    return _scenesize;
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
    } else if (_scenesize.x < _window.x+_window.width) {
      _window.x = _scenesize.x-_window.width;
    }
    if (_window.y < 0) {
      _window.y = 0;
    } else if (_scenesize.y < _window.y+_window.height) {
      _window.y = _scenesize.y-_window.height;
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

    switch (level) {
    case 0:
      // tomato
      addMaterial(new Material(this, 4, 7, 2, 2, 2, 0xff0000, 0xff8800));
      // cucumber
      addMaterial(new Material(this, 8, 6, 1, 3, 1, 0x116600, 0x88ff88));
      player = new Player(this, 7, 3);
      break;

    default:
      addFactory(new RoastingFactory(new Rectangle(20, height-20-80, 160, 80),
					   0xff0000, "ROAST"));
      addFactory(new SeasoningFactory(new Rectangle(width-20-160, height-20-80, 160, 80),
					    0x008844, "SEASON"));
      // cucumber
      addMaterial(new Material(this, 1, 1, 4, 7, 0, 0x00cc00, 0x88ff00));
      // tomato
      addMaterial(new Material(this, 2, 2, 6, 6, 0, 0xff0000, 0xff8800));
      // beef
      addMaterial(new Material(this, 3, 3, 5, 5, 0, 0xcc88cc, 0x884444));
      // pork
      addMaterial(new Material(this, 4, 4, 7, 3, 0, 0xffcccc, 0xcc8888));
      // lettuce
      addMaterial(new Material(this, 5, 5, 7, 7, 0, 0x88ffcc, 0x88ff88));
      // tofu
      addMaterial(new Material(this, 6, 6, 5, 5, 0, 0xcccccc, 0xffffcc));
      // carrot
      addMaterial(new Material(this, 7, 7, 3, 5, 0, 0xcccc88, 0xcccc88));
      // chicken
      // onion
      // herb?
      addActor(new Enemy(this, 5, 5));
      break;
    }

    addActor(player);
    setMode(true);
    return player;
  }

  // clearLevel(): erase everything in the current level.
  public function clearLevel():void
  {
    if (actors != null) {
      for each (var actor:Actor in actors) {
        removeChild(actor);
      }
    }
    actors = new Array();
    if (materials != null) {
      for each (var material:Material in materials) {
	removeChild(material);
      }
    }
    materials = new Array();
    if (factories != null) {
      for each (var factory:Factory in materials) {
	removeChild(factory);
      }
    }
    factories = new Array();
  }

  // addActor(actor)
  public function addActor(actor:Actor):void
  {
    addChild(actor);
    actors.push(actor);
  }

  // addMaterial(material)
  public function addMaterial(material:Material):void
  {
    addChild(material);
    materials.push(material);
  }

  // addFactory(factory)
  public function addFactory(factory:Factory):void
  {
    addChild(factory);
    factories.push(factory);
  }

  // removeMaterial(material)
  public function removeMaterial(material:Material):void
  {
    removeChild(material);
    materials.splice(materials.indexOf(material), 1);
  }

  // hasMaterialOverlapping(rect)
  public function hasMaterialOverlapping(rect:Rectangle):Boolean
  {
    for each (var material:Material in materials) {
      if (material.bounds.intersects(rect)) return true;
    }
    return false;
  }

  // getOverlappingMaterials(rect)
  public function getOverlappingMaterials(rect:Rectangle):Array
  {
    var contacts:Array = new Array();
    for each (var material:Material in materials) {
      if (material.bounds.intersects(rect)) {
	contacts.push(material);
      }
    }
    return contacts;
  }

  // isInsideScreen(rect):
  public function isInsideScreen(rect:Rectangle):Boolean
  {
    return (Entity.unit <= rect.left && 
	    rect.right <= _scenesize.x-Entity.unit &&
	    Entity.unit <= rect.top && 
	    rect.bottom <= _scenesize.y-Entity.unit);
  }

  // toggleMode()
  public function toggleMode():void
  {
    setMode(!_construction);
    switchsound.play()
  }

  // setMode(construction)
  public function setMode(construction:Boolean):void
  {
    _construction = construction;
    var factory:Factory;
    for each (var actor:Actor in actors) {
      actor.setMode(_construction);
    }
    if (_construction) {
      for each (factory in factories) {
	addChild(factory);
      }
    } else {
      for each (factory in factories) {
	removeChild(factory);
      }
    }
  }

  // update()
  public function update():void
  {
    var material:Material;
    // initialize.
    for each (material in materials) {
      material.clearForce();
      material.clearConnection();
    }
    // move actors.
    for each (var actor:Actor in actors) {
      actor.update();
    }
    if (_construction) {
      // detect grouped materials.
      var groups:Array = new Array();
      for each (material in materials) {
	  if (material.group != null && groups.indexOf(material.group) == -1) {
	    groups.push(material.group);
	  }
	}
      for each (material in materials) {
	  for each (var m:Material in materials) {
	      if (material.hasContact(m)) {
		material.connectTo(m);
	      }
	    }
	}
      // move/update materials.
      for each (material in materials) {
	  material.update();
	  for each (var factory:Factory in factories) {
	      if (factory.canAcceptMaterial(material)) {
		factory.putMaterial(material);
	      }
	    }
	}
    }
    // update the plate.
    if (_construction) {
      updatePlate(10);
    } else {
      updatePlate(0);
    }
  }

  // repaint()
  public function repaint():void
  {
    for each (var actor:Actor in actors) {
      actor.repaint();
    }
    for each (var material:Material in materials) {
      material.repaint();
    }
  }

  // updatePlate(plate): draws a plate.
  private function updatePlate(plate:int):void
  {
    if (_plate == plate) return;
    if (_plate < plate) {
      // bring up.
      _plate++;
    } else {
      // fold down.
      _plate--;
    }
    var h:int = (_window.height-Entity.unit*2)*_plate/10;
    var r:Rectangle = new Rectangle(Entity.unit, _window.height-h, 
				    _window.width-Entity.unit*2, h);
    graphics.clear()
    graphics.beginFill(0xffffff);
    graphics.drawEllipse(r.x, r.y, r.width, r.height);
    graphics.endFill();
    graphics.lineStyle(4, 0x000000);
    r.inflate(-r.width/8, -r.height/8);
    graphics.drawEllipse(r.x, r.y, r.width, r.height);
  }

}

} // package
