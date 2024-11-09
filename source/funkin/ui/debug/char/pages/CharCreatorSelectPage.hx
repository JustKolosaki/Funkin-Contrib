package funkin.ui.debug.char.pages;

import funkin.audio.FunkinSound;
import funkin.data.freeplay.player.PlayerData;
import funkin.data.freeplay.player.PlayerRegistry;
import funkin.graphics.adobeanimate.FlxAtlasSprite;
import funkin.graphics.FunkinSprite;
import funkin.ui.debug.char.pages.subpages.CharSelectIndexSubPage;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import openfl.display.BlendMode;
import openfl.filters.ShaderFilter;
import funkin.ui.charSelect.Lock;
import funkin.util.MathUtil;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.FlxG;

@:allow(funkin.ui.debug.char.pages.subpages.CharSelectIndexSubPage)
class CharCreatorSelectPage extends CharCreatorDefaultPage
{
  var data:WizardGenerateParams;

  var nametag:FlxSprite;
  var transitionGradient:FlxSprite;
  var autoFollow:Bool = false;
  var availableChars:Map<Int, String> = new Map<Int, String>();
  var fadeShader:funkin.graphics.shaders.BlueFade = new funkin.graphics.shaders.BlueFade();

  // used for `PlayableCharacter` generation
  var selectedIndexData:Int = 0;

  var subPages:Map<CharCreatorSelectSubPage, FlxSpriteGroup>;

  var handleInput:Bool = true;

  override public function new(state:CharCreatorState, data:WizardGenerateParams)
  {
    super(state);

    loadAvailableCharacters();
    this.data = data;

    // copied sum code LOL
    initBackground();

    initForeground();

    // gf and player code doodoo

    nametag = new FlxSprite();
    add(nametag);

    subPages = new Map<CharCreatorSelectSubPage, FlxSpriteGroup>();
    subPages.set(IndexSubPage, new CharSelectIndexSubPage(this));

    add(subPages[IndexSubPage]);
  }

  function initBackground():Void
  {
    var bg:FlxSprite = new FlxSprite(-153, -140);
    bg.loadGraphic(Paths.image('charSelect/charSelectBG'));
    add(bg);

    var crowd:FlxAtlasSprite = new FlxAtlasSprite(0, 0, Paths.animateAtlas("charSelect/crowd"));
    crowd.anim.play();
    crowd.anim.onComplete.add(function() {
      crowd.anim.play();
    });
    add(crowd);

    var stageSpr:FlxSprite = new FlxSprite(-40, 391);
    stageSpr.frames = Paths.getSparrowAtlas("charSelect/charSelectStage");
    stageSpr.animation.addByPrefix("idle", "stage full instance 1", 24, true);
    stageSpr.animation.play("idle");
    add(stageSpr);

    var curtains:FlxSprite = new FlxSprite(-47, -49);
    curtains.loadGraphic(Paths.image('charSelect/curtains'));
    add(curtains);

    var barthing = new FlxAtlasSprite(0, 0, Paths.animateAtlas("charSelect/barThing"));
    barthing.anim.play("");
    barthing.anim.onComplete.add(function() {
      barthing.anim.play("");
    });
    barthing.blend = BlendMode.MULTIPLY;
    add(barthing);

    var charLight:FlxSprite = new FlxSprite(800, 250);
    charLight.loadGraphic(Paths.image('charSelect/charLight'));
    add(charLight);

    var charLightGF:FlxSprite = new FlxSprite(180, 240);
    charLightGF.loadGraphic(Paths.image('charSelect/charLight'));
    add(charLightGF);
  }

  function initForeground():Void
  {
    var speakers:FlxAtlasSprite = new FlxAtlasSprite(0, 0, Paths.animateAtlas("charSelect/charSelectSpeakers"));
    speakers.anim.play("");
    speakers.anim.onComplete.add(function() {
      speakers.anim.play("");
    });
    add(speakers);

    var fgBlur:FlxSprite = new FlxSprite(-125, 170);
    fgBlur.loadGraphic(Paths.image('charSelect/foregroundBlur'));
    fgBlur.blend = BlendMode.MULTIPLY;
    add(fgBlur);

    var dipshitBlur = new FlxSprite(419, -65);
    dipshitBlur.frames = Paths.getSparrowAtlas("charSelect/dipshitBlur");
    dipshitBlur.animation.addByPrefix('idle', "CHOOSE vertical offset instance 1", 24, true);
    dipshitBlur.blend = BlendMode.ADD;
    dipshitBlur.animation.play("idle");
    add(dipshitBlur);

    var dipshitBacking = new FlxSprite(423, -17);
    dipshitBacking.frames = Paths.getSparrowAtlas("charSelect/dipshitBacking");
    dipshitBacking.animation.addByPrefix('idle', "CHOOSE horizontal offset instance 1", 24, true);
    dipshitBacking.blend = BlendMode.ADD;
    dipshitBacking.animation.play("idle");
    add(dipshitBacking);

    var chooseDipshit = new FlxSprite(426, -13);
    chooseDipshit.loadGraphic(Paths.image('charSelect/chooseDipshit'));
    add(chooseDipshit);
  }

  function loadAvailableCharacters():Void
  {
    var playerIds:Array<String> = PlayerRegistry.instance.listEntryIds();

    for (playerId in playerIds)
    {
      var player:Null<funkin.ui.freeplay.charselect.PlayableCharacter> = PlayerRegistry.instance.fetchEntry(playerId);
      if (player == null) continue;
      var playerData = player.getCharSelectData();
      if (playerData == null) continue;

      var targetPosition:Int = playerData.position ?? 0;
      while (availableChars.exists(targetPosition))
      {
        targetPosition += 1;
      }

      trace('Placing player ${playerId} at position ${targetPosition}');
      availableChars.set(targetPosition, playerId);
    }
  }

  override function update(elapsed:Float):Void
  {
    super.update(elapsed);

    if (handleInput)
    {
      if (FlxG.keys.justPressed.B)
      {
        cast(subPages[IndexSubPage], CharSelectIndexSubPage).open();
      }
    }
  }
}

enum CharCreatorSelectSubPage
{
  IndexSubPage;
}
