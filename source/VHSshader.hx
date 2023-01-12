package;

import flixel.system.FlxAssets.FlxShader;

class VHSShader extends FlxShader
{
	@:glFragmentSource('
    #pragma header
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;
    uniform float iTime;
    #define iChannel0 bitmap
    #define texture flixel_texture2D
    #define fragColor gl_FragColor
    #define mainImage main
    //****MAKE SURE TO remove the parameters from mainImage.
    //SHADERTOY PORT FIX
		
		const float range = 0.05;
    const float noiseQuality = 250.0;
    const float noiseIntensity = 0.0005;
    const float offsetIntensity = 0.002;
    const float colorOffsetIntensity = 1.3;

float rand(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float verticalBar(float pos, float uvY, float offset)
{
    float edge0 = (pos - range);
    float edge1 = (pos + range);

    float x = smoothstep(edge0, pos, uvY) * offset;
    x -= smoothstep(pos, edge1, uvY) * offset;
    return x;
}

void main()
{
	vec2 uv = openfl_TextureCoordv
    
    for (float i = 0.0; i < 0.71; i += 0.1313)
    {
        float d = mod(iTime * i, 1.7); 
        float o = sin(1.0 - tan(iTime * 0.24 * i));
    	o *= offsetIntensity;
        uv.x += verticalBar(d, uv.y, o);
    }
    
    float uvY = uv.y;
    uvY *= noiseQuality;
    uvY = float(int(uvY)) * (1.0 / noiseQuality);
    float noise = rand(vec2(iTime * 0.00001, uvY));
    uv.x += noise * noiseIntensity;

    vec2 offsetR = vec2(0.006 * sin(iTime), 0.0) * colorOffsetIntensity;
    vec2 offsetG = vec2(0.0073 * (cos(iTime * 0.97)), 0.0) * colorOffsetIntensity;
    
    float r = flixel_texture2D(bitmap, uv + offsetR).r;
    float g = flixel_texture2D(bitmap, uv + offsetG).g;
    float b = flixel_texture2D(bitmap, uv).b;

    vec4 tex = vec4(r, g, b, 1.0);
    gl_FragColor = tex;
}')
public function new()
{
	super();
}
}
//hey if you know how to do shaders and want to help dm stress factor#6855 on discord