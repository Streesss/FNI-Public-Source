local uhhhhh = ''


function onCreate()
if songName == 'Masklophobia' or songName == 'Distrustful' or songName == 'Performance' or songName == 'Phantasmagoria'then
    uhhhhh = 'dezz'
    end

    if songName == 'Masklophobia' or songName == 'Distrustful' then
        makeLuaSprite('TextIntro1','starttext/clyde1',175,250)
        scaleObject('TextIntro1', 0.7, 0.7)
        makeLuaSprite('TextIntro2','starttext/clyde2',225,250)
        scaleObject('TextIntro2', 0.7, 0.7)
        
        
    elseif songName == 'Performance' or songName == 'Phantasmagoria' then
        makeLuaSprite('TextIntro1','starttext/winfrey1',175,250)
        scaleObject('TextIntro1', 0.7, 0.7)
        makeLuaSprite('TextIntro2','starttext/winfrey2',225,250)
        scaleObject('TextIntro2', 0.7, 0.7)


    end
    if uhhhhh == 'dezz' then
        makeLuaSprite('BlackFadedezz','',0,0)
        makeGraphic('BlackFadedezz',screenWidth,screenHeight,'000000')
        setObjectCamera('BlackFadedezz','other')
        addLuaSprite('BlackFadedezz',true)
        setProperty('skipCountdown',true)
        CountTextCompleted = false
        runTimer('textSongDestroy',6)
        runTimer('text1',2)
        runTimer('text2',3.5)
        runTimer('endtext2',6)
        runTimer('text2sound',3.2) 
        runTimer('endtext2sound',5.5)
        runTimer('textSongDestroysound',1.5)
        setObjectCamera('TextIntro1','other')
        setObjectCamera('TextIntro2','other')
        addLuaSprite('TextIntro1',true)
        runTimer('playsong',0.2)
    end
end

local allowCountdown = false
function onStartCountdown()
	if not allowCountdown and uhhhhh == 'dezz' then
		return Function_Stop;
	end
    return Function_Continue;
end

function onTimerCompleted(tag)
	if tag == 'textSongDestroy' then
		CountTextCompleted = true
		alphaEffectDisable = true
        allowCountdown = true
        removeLuaSprite('TextIntro2',true)
        removeLuaSprite('BlackFadedezz',true)
        startCountdown()
	end
    if tag == 'endtext2sound' then
        playSound('countdown2')
	end
    if tag == 'text1' then
        removeLuaSprite('TextIntro1',true)
	end
    if tag == 'textSongDestroysound' then
        playSound('countdown2')
	end
    if tag == 'text2' then
        addLuaSprite('TextIntro2',true)
	end
    if tag == 'text2sound' then
        playSound('countdown1')
	end
    if tag == 'playsong' then
        playSound('countdown1')
	end
end
