package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Lib;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var fg:FlxSprite;
	var statreal:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;
	var char:FlxSprite;
	var character:FlxSprite;

	var offsetThing:Float = -75;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("THANKS FOR PLAYING", null);
		#end

		persistentUpdate = true;
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);
		bg.screenCenter();

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
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		var path:String = 'modsList.txt';
		if(FileSystem.exists(path))
		{
			var leMods:Array<String> = CoolUtil.coolTextFile(path);
			for (i in 0...leMods.length)
			{
				if(leMods.length > 1 && leMods[0].length > 0) {
					var modSplit:Array<String> = leMods[i].split('|');
					if(!Paths.ignoreModFolders.contains(modSplit[0].toLowerCase()) && !modsAdded.contains(modSplit[0]))
					{
						if(modSplit[1] == '1')
							pushModCreditsToList(modSplit[0]);
						else
							modsAdded.push(modSplit[0]);
					}
				}
			}
		}

		var arrayOfFolders:Array<String> = Paths.getModDirectories();
		arrayOfFolders.push('');
		for (folder in arrayOfFolders)
		{
			pushModCreditsToList(folder);
		}
		#end

		/*v2 ones maby idk i dont have a time machine 
		hollow just kinda does nothing
		fishzy we have not used a single art piece he has made
		chumlee edgyteenagerlol
		paul for the longet i thought his name was pablo
		trumoo majin clyde
		imamarima as of 12/15/2022 i have yet to talk to them
		stress i dont know what to say i had a bit more help this time
		Demo his pc is fixed pog(he just cant use it)
		kinster bruh im not gonna say it here but you know what i want to put
		penove he made the fnaf 2 mod the best mod ever
		firee have we gotten another charcter yet hes done like 8 songs
		gamer freddy stop fing gender swaping stuff
		
		pastra pastra pastra look at me
		You you all messed it up no fun this vol maby next vol*/

		var pisspoop:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color nedded links
			['FNI Team'],
			['Hollow',		'hollow',		'creator/director\n director but funny',								'https://youtube.com/channel/UCUmxl3lKSIYSYHr70j63Gpw',	'FFFFFF'],
			['Fishzy',		'fishman',		'director/Artist\n the best ghoul',								'https://www.youtube.com/channel/UCQFomxfdOFqkG6oPMiAZoQg',	'FFFFFF'],
			['Chumlee',		'chumlee',		'Organizer/Artist\n cumlee',								'https://www.youtube.com/channel/UCcHnObxhq07HLIlyUGz8L6g',	'FFFFFF'],
			['Paul',		'paul',		'Artist\n with a fat blunt',								'https://twitter.com/paulugoncalves6?t=zvIcSaInU96Bsaf6DsrNIw&s=33',	'FFFFFF'],
			['Trumoo',		'trumoo',		'Artist\n made every icon',								'https://twitter.com/Trumoo3603',	'FFFFFF'],
			['ImaMarima',		'imamaria',		'Artist/Animator\n made most if not all of the sprites',						'https://www.youtube.com/@gummywormee41/featured',	'FFFFFF'],
			['Stress',		'stress',		'Coder\n I made everything hi',								'https://twitter.com/stresssfactor',	'FFFFFF'],
			['Demo Pups',		'demo',		'Musician\n pc is probly broken',								'https://www.youtube.com/channel/UCW92Iv4zp2Zk523PZDV51oQ',	'FFFFFF'],
			['Kinster',		'kinster',		'Musician\n Kinkster you cant stop me',								'https://docs.google.com/document/d/1SLXB-EtKpEqrc-3iZ1oEDmmtjnIJ3CjJAp_1uH7L5OU/edit?usp=sharing',	'FFFFFF'],
			['Penove',		'penove',		'Musician\n mod would have died without him',								'https://www.youtube.com/channel/UCMo5DEAD4-33lhM2ZQm_SlQ',	'FFFFFF'],
			['HunterRelo JR',		'Hunter',		'Musician\n cool dude',								'https://www.youtube.com/channel/UCOPs-4n3rykp4M7weCEBfbw',	'FFFFFF'],
			['Firee',		'firee',		'Charters\n the only charter',								'https://twitter.com/Firee_e',	'FFFFFF'],
			['Gamer Freddy',		'gamer',		'Voice Actor\n made the femveldi\'s',								'https://www.youtube.com/channel/UCjfVO7TcPwzCDUGuGVENvdQ',	'FFFFFF'],
			[''],
			['Special Thanks'],
			['MiRiF',		'gone',		'let us use their songs\n They make good songs check them out',								'https://www.youtube.com/@mirif3996/videos',	'FFFFFF'],
			['Afeefflox',		'Afeefflox',		'helped with a unused winfreys chrom\n thanks for helping',								'https://docs.google.com/document/d/1SLXB-EtKpEqrc-3iZ1oEDmmtjnIJ3CjJAp_1uH7L5OU/edit?usp=sharing',	'FFFFFF'],
			['Villustr8ed',		'Villustr8ed',		'made winfreys bg\n also made a unused clyde bg',								'https://docs.google.com/document/d/1SLXB-EtKpEqrc-3iZ1oEDmmtjnIJ3CjJAp_1uH7L5OU/edit?usp=sharing',	'FFFFFF'],
			['vasalto',		'vasalto',		'made Masklophobia\n he left',								'https://docs.google.com/document/d/1SLXB-EtKpEqrc-3iZ1oEDmmtjnIJ3CjJAp_1uH7L5OU/edit?usp=sharing',	'FFFFFF'],
			['You',		'gone',		'for playing this mod\n hey press space or enter for a secret',								'https://docs.google.com/document/d/1SLXB-EtKpEqrc-3iZ1oEDmmtjnIJ3CjJAp_1uH7L5OU/edit?usp=sharing',	'FFFFFF'],
			[''],
			['ultra Special Thanks'],
			['Pastra Spec',		'pastra',		'owns every character in the mod\n pastra matpat collab when',								'https://twitter.com/pastraspec',	'FFFFFF'],
			['Psych Engine',		'psych',		'Psych Engine and all its Contributors\n psych is cool',								'https://gamebanana.com/mods/309789',	'E6E6FA'],
			["Funkin' Crew",			'fnf',		"made a little know indie game called fnf\n you might not have heard of it",								'https://ninja-muffin24.itch.io/funkin',		'F0F8FF']
		];
		//needded links
		//imaMarima Kinster

		for(i in pisspoop){
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			optionText.yAdd -= 70;
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				if(creditsStuff[i][5] != null)
				{
					Paths.currentModDirectory = creditsStuff[i][5];
				}

				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Paths.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
		}
		
		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		//descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		add(descText);

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
		fg.antialiasing = ClientPrefs.globalAntialiasing;
		add(fg);

		bg.color = getCurrentBGColor();
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(!quitting)
		{
			if(creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP)
				{
					changeSelection(-1 * shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(1 * shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if(controls.ACCEPT && (creditsStuff[curSelected][3] == null || creditsStuff[curSelected][3].length > 4)) {
				CoolUtil.browserLoad(creditsStuff[curSelected][3]);
			}
			if (controls.BACK)
			{
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}
		
		for (item in grpOptions.members)
		{
			if(!item.isBold)
			{
				var lerpVal:Float = CoolUtil.boundTo(elapsed * 12, 0, 1);
				if(item.targetY == 0)
				{
					var lastX:Float = item.x;
					item.screenCenter(X);
					item.x = FlxMath.lerp(lastX, item.x - 70, lerpVal);
					item.forceX = item.x;
				}
				else
				{
					item.x = FlxMath.lerp(item.x, 200 + -40 * Math.abs(item.targetY), lerpVal);
					item.forceX = item.x;
				}
			}
		}
		super.update(elapsed);
		Lib.application.window.title = "Friday Night Insomnia - Credits";
	}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int =  getCurrentBGColor();
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}

		descText.text = creditsStuff[curSelected][2];
		descText.y = FlxG.height - descText.height + offsetThing - 60;

		if(moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}

	#if MODS_ALLOWED
	private var modsAdded:Array<String> = [];
	function pushModCreditsToList(folder:String)
	{
		if(modsAdded.contains(folder)) return;

		var creditsFile:String = null;
		if(folder != null && folder.trim().length > 0) creditsFile = Paths.mods(folder + '/data/credits.txt');
		else creditsFile = Paths.mods('data/credits.txt');

		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
		modsAdded.push(folder);
	}
	#end

	function getCurrentBGColor() {
		var bgColor:String = creditsStuff[curSelected][4];
		if(!bgColor.startsWith('0x')) {
			bgColor = '0xFF' + bgColor;
		}
		return Std.parseInt(bgColor);
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}

/*Hollow - creator/directorish

Fishzy  - director/Artist

Chumlee - Organizer/Artist

Paul  - Artist 

Trumoo - Artist

ImaMarima - Artist/Animator

Stress - Coder

Demo Pups - Musician

Kinster - Musician

Penove - Musician  

HunterRelo JR - Musician

Firee - Charters

Gamer Freddy - Voice Actor*/