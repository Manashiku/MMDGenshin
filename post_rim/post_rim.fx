#define rim_color float4(0.25f, 0.25f, 0.25f, 1.0f)
// #define enable_glow

float4x4 mm_wvp : WORLDVIEWPROJECTION;
float4x4 mm_view : VIEW;
#ifdef MIKUMIKUMOVING
float3 light_direction[MMM_LightCount] : LIGHTDIRECTIONS;
bool   light_enable[MMM_LightCount]    : LIGHTENABLES;
float3 light_ambients[MMM_LightCount]   : LIGHTAMBIENTCOLORS;
#else
float3 light_direction : DIRECTION < string Object = "Light"; >;
#endif

static float near = 1.0f; 
static float far  = 1000.f;
static float z_x = 1.0f - far / near;
static float z_y = far / near;
static float4 zbuffer_param = float4(z_x, z_y, z_x / far, z_y / far);

float Script : STANDARDSGLOBAL
<
    string ScriptOutput = "color";
    string ScriptClass = "scene";
    string ScriptOrder = "postprocess";
> = 0.8;

float4 clear_color = { 0.5f, 0.5f, 0.5f, 1.0f };
float clear_depth = 1.0f;

float2 viewport_size : VIEWPORTPIXELSIZE;
float2 screen_size : VIEWPORTPIXELSIZE; 
static const float2 viewport_offset = (float2)0.5f / viewport_size;

texture2D depth_buff : RENDERDEPTHSTENCILTARGET <string Format = "D24S8";>;

texture2D screen_texture   : RENDERCOLORTARGET<string Format = "A16B16G16R16F";>;
texture2D emission_texture : RENDERCOLORTARGET;
texture2D normal_texture : OFFSCREENRENDERTARGET
<
    string Description = "camera normal texture";
    float4 ClearColor = {0.5f, 0.5f, 0.0f, 1.0f};
    float ClearDepth = 1.0f;
  	bool AntiAlias = true;
    string DefaultEffect = "* = post_normal_render.fx;";
>;

texture2D depth_texture : OFFSCREENRENDERTARGET
<
    string Description = "camera depth texture";
    float4 ClearColor = {10.0f, 10.0f, 10.0f, 1.0f};
    float ClearDepth = 1.0f;
  	bool AntiAlias = true;
	string Format = "R32F";
    string DefaultEffect = "* = post_depth_render.fx;";
>;

sampler screen_sampler = sampler_state
{
	texture = <screen_texture>;
	MinFilter = NONE;
	MagFilter = NONE;
	MipFilter = NONE;
	AddressU  = CLAMP;
	AddressV = CLAMP;
};


sampler emission_sampler = sampler_state
{
	texture = <emission_texture>;
	MinFilter = NONE;
	MagFilter = NONE;
	MipFilter = NONE;
	AddressU  = CLAMP;
	AddressV = CLAMP;
};

sampler2D normal_sampler = sampler_state
{
	texture = <normal_texture>;
	MinFilter = NONE;
	MagFilter = NONE;
	MipFilter = NONE;
	AddressU  = CLAMP;
	AddressV = CLAMP;
};

sampler2D depth_sampler = sampler_state
{
	texture = <depth_texture>;
	MinFilter = NONE;
	MagFilter = NONE;
	MipFilter = NONE;
	AddressU  = CLAMP;
	AddressV = CLAMP;
};

#ifdef enable_glow
static float pi = 3.1415926;
static int samples = 25;
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
            pixel += tex2D(sp, uv + scale * offset).rgb * weight;
            weightSum += weight;
        }
    }
    return pixel / weightSum;
}
#endif
struct vs_in
{
    float4 pos : POSITION;
    float2 uv : TEXCOORD0;
};

struct vs_out
{
    float4 pos : POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : TEXCOORD1;
};

vs_out vs_rim(vs_in i)
{
    vs_out o;
    o.pos = i.pos;
    o.uv = i.uv + viewport_offset;
    o.normal = i.pos.xyz * 0.5f + 0.5f;
    return o;
}

float4 ps_emi(vs_out i) : COLOR0
{
	float4 screen = tex2D(screen_sampler, i.uv);
	screen.x = screen.x > 1.0f ? screen.x - 1.01f : 0.0f;
	screen.y = screen.y > 1.0f ? screen.y - 1.01f : 0.0f;
	screen.z = screen.z > 1.0f ? screen.z - 1.01f : 0.0f;
	return float4(screen.xyz, 1.0f);
}

float4 ps_rim(vs_out i) : COLOR0
{

	// initialize inputs 
	float3 quad_normal = normalize(i.normal);
	float2 uv          = i.uv;

	// sample textures using basic uvs
	float4 screen	  = tex2D(screen_sampler, uv);
	float3 normal_tex = tex2D(normal_sampler, uv);
	float depth 	  = tex2D(depth_sampler, uv).x;
	normal_tex = normal_tex * 2.0f - 1.0f;

	// depth = zbuffer_param.x * depth + zbuffer_param.y;
	// depth = 1.0f / depth;

	float3 normal_vs = mul(normal_tex, (float3x3)mm_view);
	float2 normal_depth_coords = normal_vs.xy * (float2)0.00200000009f + uv.xy;

	// sample normal offset depth texture
	float off_depth = tex2D(depth_sampler, normal_depth_coords).x;
	// off_depth = zbuffer_param.x * depth + zbuffer_param.y;
	// off_depth = 1.0f / off_depth;

	float d = -depth + off_depth;
	d = max(d, 0.001f);
	d = pow(d, 0.04f);
	d = d - 0.8f;
	d = d * 10.0f;
	d = clamp(d, 0.0f, 1.0f);
	float d_2 = (d * d) * (d * -2.0f + 3.0f);
	float depth_weird = min(((-depth) + 2.0f) * 0.3f + depth, 1.0f);
	d_2 = depth_weird * d_2;
	// screen.xyz = d_2;
	#ifdef enable_glow
	float3 blur = gaussianBlur(emission_sampler, uv, (float2)1.0f / viewport_size);
	screen.x = screen.x > 1.0f ? screen.x - 1.01f : screen.x;
	screen.y = screen.y > 1.0f ? screen.y - 1.01f : screen.y;
	screen.z = screen.z > 1.0f ? screen.z - 1.01f : screen.z;
	screen.xyz = (screen.xyz + blur);
	#endif
	screen.xyz = screen + (d_2 * rim_color);
    return screen;
}

technique PostEffectTec
<
	string Script =
	"RenderColorTarget0=screen_texture;"
    "RenderDepthStencilTarget=depth_buff;"
    "ClearSetColor=clear_color;"
    "ClearSetDepth=clear_depth;"
    "Clear=Color;"
    "Clear=Depth;"
    "ScriptExternal=Color;"

    // edge detection 
    "RenderColorTarget=emission_texture;"
    "RenderDepthStencilTarget=depth_buff;"
    "Pass=pass_emi;"
    
    "RenderColorTarget0=;"
	"RenderDepthStencilTarget=;"
	"ClearSetColor = clear_color;"
	"ClearSetDepth = clear_depth;"
	"Clear=Color;"
	"Clear=Depth;"
	"Pass=pass_rim;";
>
{
	pass pass_emi < string Script = "Draw=Buffer;"; >
	{
		AlphaBlendEnable = true;
		VertexShader = compile vs_3_0 vs_rim();
		PixelShader  = compile ps_3_0 ps_emi();
	}
	pass pass_rim < string Script = "Draw=Buffer;"; >
	{
		AlphaBlendEnable = true;
		VertexShader = compile vs_3_0 vs_rim();
		PixelShader  = compile ps_3_0 ps_rim();
	}

};
