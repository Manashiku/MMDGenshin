#define GLOW_SAMPLE 15 // anything above 20 is going to potentially cause lag


float script : STANDARDSGLOBAL < 
    string ScriptOutput = "color"; 
    string ScriptClass = "scene"; 
    string ScriptOrder = "postprocess"; 
> = 0.8;

float2 screen_size : VIEWPORTPIXELSIZE; 
static float2 screen_offset = ((float2)0.5f / screen_size);
float4 clear_color = {0.5f, 0.5f, 0.5f, 0.0};
float clear_depth = 1.0;

// ==========================================================
// TEXTURES 
texture2D screen_texture : RENDERCOLORTARGET < float2 ViewPortRatio = {1.0,1.0};
    int MipLevels = 0;
>;
texture2D depthstencil_texture : RENDERDEPTHSTENCILTARGET <
    // float2 ViewPortRatio = {1.0, 1.0};
    // string Format = "D3DFMT_D24S8";
>;
texture2D glow_texture : OFFSCREENRENDERTARGET
<
    string Description = "glow texture ";
    float2 ViewPortRatio = {1.0f, 1.0f};
    float4 ClearColor = {0.0f, 0.0f, 0.0f, 1.0f};
    float ClearDepth = 1.0f;
	bool AntiAlias = false;
	int Miplevels = 0;
	string DefaultEffect =
	    "self=hide;"
	    "*=glow_off.fx;";
>;

// ==========================================================
// SAMPLERS

sampler screen_sampler = sampler_state
{
    texture = <screen_texture>;
    FILTER = ANISOTROPIC;
    ADDRESSV = CLAMP;
    ADDRESSU = CLAMP;
};

sampler glow_sampler = sampler_state
{
    texture = <glow_texture>;
    FILTER = ANISOTROPIC;
    ADDRESSV = CLAMP;
    ADDRESSU = CLAMP;
};


static float pi = 3.1415926;
static int samples = GLOW_SAMPLE;
static float sigma = (float)samples * 0.25;
static float s = 2 * sigma * sigma; 

float gauss(float2 i)
{
    
    return exp(-(i.x * i.x + i.y * i.y) / s) / (pi * s);
}

float3 gaussianBlur(sampler sp, float2 uv, float2 scale)
{
    float3 pixel = (float3)0.0f;
    float weightSum = 0.0f;
    float weight;
    float2 offset;

    for(int i = -samples / 2; i < samples / 2; i++)
    {
        for(int j = -samples / 2; j < samples / 2; j++)
        {
            offset = float2(i, j);
            weight = gauss(offset);
            pixel += tex2Dlod(sp, float4(uv + scale * offset, 0.0f, 1.0f)).rgb * weight;
            weightSum += weight;
        }
    }
    return pixel / weightSum;
}



// ==========================================================
// STRUCTURE  
struct vs_out
{
    float4 pos : POSITION;
    float2 uv : TEXCOORD0;
};

// ==========================================================
// VERTEX AND PIXEL SHADER
vs_out vs_0(float4 pos : POSITION, float2 uv : TEXCOORD0)
{
    vs_out o;
    o.pos = pos;
    o.uv = uv + screen_offset;
    return o;
}

float4 ps_0(vs_out i) : COLOR
{
    float4 color = (float4)1.0f;
    float2 uv = i.uv;
    color.xyz = color * tex2D(screen_sampler, uv);
    float3 glow = gaussianBlur(glow_sampler, uv, (float2)1.0f / screen_size.xy);
    color.xyz = color.xyz + glow;

    return color;
}

technique post_test <
   string Script =
        "RenderColorTarget0=screen_texture;"
		"RenderDepthStencilTarget=depthstencil_texture;"
		"ClearSetColor=clear_color;"
		"ClearSetDepth=clear_depth;"
		"Clear=Color;"
		"Clear=Depth;"
		"ScriptExternal=Color;"
       
        
        //final pass
        "RenderColorTarget0=;"
		"RenderDepthStencilTarget=;"
		"ClearSetColor=clear_color;"
		"ClearSetDepth=clear_depth;"
		"Clear=Color;"
		"Clear=Depth;"
		"Pass=drawFinal;"
    ;
>
{
    pass drawFinal <string Script = "RenderColorTarget0=;"
    "RenderDepthStencilTarget=;""Draw=Buffer;";>
    {
       
        VertexShader = compile vs_3_0 vs_0();
        ZEnable = false;
		ZWriteEnable = false;
		AlphaBlendEnable = true;
		CullMode = None;
        PixelShader = compile ps_3_0 ps_0();
    }
}
