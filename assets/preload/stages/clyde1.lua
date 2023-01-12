function onCreate()
	-- background shit
	makeLuaSprite('clyde1', 'clyde1', -1000, -600);
	scaleObject('clyde1', 1.6, 1.6)
	addLuaSprite('clyde1', false);

	makeLuaSprite('clydelight', 'clydelight', -1000, -600);
	scaleObject('clydelight', 1.6, 1.6)
	addLuaSprite('clydelight', true);

	makeAnimatedLuaSprite('Static', 'static', 0, 0)
	scaleObject('Static', 1.36, 1.36)
    setObjectCamera('Static', 'other')
    precacheImage('static')
	addAnimationByPrefix('Static', 'static', 'Static', 24, true)
    setProperty('Static.alpha', 0.2)
    addLuaSprite('Static', true)

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end