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

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.2'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'options',
		//#if MODS_ALLOWED 'mods', #end
		//#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		#if !switch 'youtube' #end
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	var char:FlxSprite;
	var character:FlxSprite;
	var fg:FlxSprite;
	var statreal:FlxSprite;

	override function create()
	{
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Trying to stay awake", null);
		#end
		
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.set(0, yScroll);
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
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.scale.x = 0.5;
			menuItem.scale.y = 0.5;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();

			switch (i)
			{
				case 0:
				menuItem.y = 300;
				menuItem.x = 200;
				case 1:
				menuItem.y = 370;
				menuItem.x = 200;
				case 2:
				menuItem.y = 440;
				menuItem.x = 200;
				case 3:
				menuItem.y = 510;
				menuItem.x = 200;
				case 4:
				menuItem.y = 560;
				menuItem.x = 200;

			}
		}

		//FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Dreams of an Funker", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("the Gingerbread House", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Friday Night Insomnia v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("the Gingerbread House", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();

		char = new FlxSprite(200, 10).loadGraphic(Paths.image('mainmenu/moon'));
			/*char.frames = Paths.getSparrowAtlas('mainmenu/moon');
			char.animation.addByPrefix('idleR', 'logo bumpin', 24, true);//on 'idle normal' change it to your xml one
			char.animation.play('idleR');*/ //you can rename the anim however you want to
			char.scrollFactor.set();
			char.scale.x = 1.1;
			char.scale.y = 1.1;
			//char.flipX = false; 
			char.antialiasing = ClientPrefs.globalAntialiasing;
			add(char);

		switch (FlxG.random.int(1, 2))
            {
			case 1:
		character = new FlxSprite(0, 0).loadGraphic(Paths.image('mainmenu/clyde'));
			/*character.frames = Paths.getSparrowAtlas('clyde');
			character.animation.addByPrefix('idleD', 'Dad idle dance', 24, true);//on 'idle normal' change it to your xml one
			character.animation.play('idleD');*/ //you can rename the anim however you want to
			character.scrollFactor.set();
			character.scale.x = 1;
			character.scale.y = 1;
			//character.flipX = false;
			character.antialiasing = ClientPrefs.globalAntialiasing;
			add(character);

			/*char = new FlxSprite(730, 170).loadGraphic(Paths.image('mainmenu/loschikes/ex'));//put your cords and image here
            char.frames = Paths.getSparrowAtlas('mainmenu/loschikes/ex');//here put the name of the xml
            char.animation.addByPrefix('idleR', 'ex1', 24, true);//on 'idle normal' change it to your xml one
            char.animation.play('idleR');//you can rename the anim however you want to
            char.scrollFactor.set();
            FlxG.sound.play(Paths.sound('appear'), 2);
            char.flipX = true;//this is for flipping it to look left instead of right you can make it however you want
            char.antialiasing = ClientPrefs.globalAntialiasing;
            add(char);*/

		case 2:
		char = new FlxSprite(0, 0).loadGraphic(Paths.image('mainmenu/winfrey'));
			/*char.frames = Paths.getSparrowAtlas('moon');
			char.animation.addByPrefix('idleR', 'logo bumpin', 24, true);//on 'idle normal' change it to your xml one
			char.animation.play('idleR');*/ //you can rename the anim however you want to
			char.scrollFactor.set();
			char.scale.x = 1;
			char.scale.y = 1;
			//char.flipX = false;
			char.antialiasing = ClientPrefs.globalAntialiasing;
			add(char); //use this after i get animations 
			
			}

			statreal = new FlxSprite(0, 0).loadGraphic(Paths.image('Static'));
			statreal.frames = Paths.getSparrowAtlas('Static');
			statreal.animation.addByPrefix('Static', 'Static', 24, true);//on 'idle normal' change it to your xml one
			statreal.animation.play('Static');
			statreal.scrollFactor.set();
			statreal.scale.x = 1.6;
			statreal.scale.y = 1.7;
			statreal.alpha = 0.2;
			//char.flipX = false;
			statreal.antialiasing = ClientPrefs.globalAntialiasing;
			add(statreal);

			fg = new FlxSprite(0, 0).loadGraphic(Paths.image('menuBG'));
			/*char.frames = Paths.getSparrowAtlas('menuBG');
			char.animation.addByPrefix('idleR', 'logo bumpin', 24, true);//on 'idle normal' change it to your xml one
			char.animation.play('idleR');*/ //you can rename the anim however you want to
			fg.scrollFactor.set();
			fg.scale.x = 1;
			fg.scale.y = 1;
			//char.flipX = false;
			fg.antialiasing = ClientPrefs.globalAntialiasing;
			add(fg);
			}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'youtube')
				{
					CoolUtil.browserLoad('https://www.youtube.com/c/Pastraspec');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		Lib.application.window.title = "Friday Night Insomnia - Main Menu";

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
	}

	override function beatHit() {
		super.beatHit();

		if (curBeat % 4 ==2){
		FlxG.camera.zoom = 1.2;
		}

	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
