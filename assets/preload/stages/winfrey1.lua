function onCreate()
	-- background shit

    makeLuaSprite('sky', 'winfreysky', -1100, -1550);
	scaleObject('sky', 2, 2)
	addLuaSprite('sky', false);

    makeLuaSprite('floor', 'winfreyfloor', -1200, 350);
	scaleObject('floor', 3, 1)
	addLuaSprite('floor', false);

    makeLuaSprite('grass', 'winfreygrass', 200, -300);
	scaleObject('grass', 1.4, 1.4)
	addLuaSprite('grass', true);

	makeLuaSprite('grass2', 'winfreygrass', 0, -50);
	scaleObject('grass2', 1.4, 1.4)
	addLuaSprite('grass2', true);

	makeLuaSprite('grass3', 'winfreygrass', -600, -50);
	scaleObject('grass3', 1.4, 1.4)
	addLuaSprite('grass3', true);

	makeLuaSprite('tree', 'winfreytrees', -1200, -1550);
	scaleObject('tree', 2, 2.6)
	addLuaSprite('tree', false);

	makeLuaSprite('fog', 'fogw', -1600, -1500);
	scaleObject('fog', 3.4, 3.4)
	setLuaSpriteScrollFactor('fog', 2, 2)
	addLuaSprite('fog', true);

    makeAnimatedLuaSprite('Static', 'static', 0, 0)
	scaleObject('Static', 1.36, 1.36)
    setObjectCamera('Static', 'other')
    precacheImage('static')
	addAnimationByPrefix('Static', 'static', 'Static', 24, true)
    setProperty('Static.alpha', 0.2)
    addLuaSprite('Static', true)

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end