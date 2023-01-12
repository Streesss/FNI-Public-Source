package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import openfl.Lib;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class ThankYouState extends MusicBeatState
{
	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	var FUCK:FlxSprite;
	var PISS:FlxSprite;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("", null);
		#end
		
		camGame = new FlxCamera();

		FlxG.cameras.reset(camGame);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.set();
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set();
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;

		super.create();
		Lib.application.window.title = "Friday Night Insomnia - Thank You";

		FUCK = new FlxSprite(500, 650).loadGraphic(Paths.image('mainmenu/moon'));// do 400,10
			/*FUCK.frames = Paths.getSparrowAtlas('mainmenu/moon');
			FUCK.animation.addByPrefix('idleR', 'logo bumpin', 24, true);//on 'idle normal' change it to your xml one
			FUCK.animation.play('idleR');*/ //you can rename the anim however you want to
			FUCK.scrollFactor.set();
			FUCK.scale.x = 1;
			FUCK.scale.y = 1;
			//FUCK.flipX = false;
			FUCK.antialiasing = ClientPrefs.globalAntialiasing;
			add(FUCK);

		character = new FlxSprite(550, 70).loadGraphic(Paths.image('mainmenu/clyde'));// do -350,70
			/*character.frames = Paths.getSparrowAtlas('clyde');
			character.animation.addByPrefix('idleD', 'Dad idle dance', 24, true);//on 'idle normal' change it to your xml one
			character.animation.play('idleD');*/ //you can rename the anim however you want to
			character.scrollFactor.set();
			character.scale.x = 0.8;
			character.scale.y = 0.8;
			//character.flipX = false;
			character.antialiasing = ClientPrefs.globalAntialiasing;
			add(character);

		char = new FlxSprite(-950, 70).loadGraphic(Paths.image('mainmenu/winfrey'));// do -700,70
			/*char.frames = Paths.getSparrowAtlas('moon');
			char.animation.addByPrefix('idleR', 'logo bumpin', 24, true);//on 'idle normal' change it to your xml one
			char.animation.play('idleR');*/ //you can rename the anim however you want to
			char.scrollFactor.set();
			char.scale.x = 0.8;
			char.scale.y = 0.8;
			//char.flipX = false;
			char.antialiasing = ClientPrefs.globalAntialiasing;
			add(char); //use this after i get animations 
			
			PISS = new FlxSprite(0, 0).loadGraphic(Paths.image('menuBG'));
			/*char.frames = Paths.getSparrowAtlas('menuBG');
			char.animation.addByPrefix('idleR', 'logo bumpin', 24, true);//on 'idle normal' change it to your xml one
			char.animation.play('idleR');*/ //you can rename the anim however you want to
			PISS.scrollFactor.set();
			PISS.scale.x = 1;
			PISS.scale.y = 1;
			//char.flipX = false;
			PISS.antialiasing = ClientPrefs.globalAntialiasing;
			add(PISS);
			}


	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		
			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}
		}
}
