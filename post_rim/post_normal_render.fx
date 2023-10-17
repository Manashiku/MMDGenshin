#define ALPHA_TYPE 0 // 0 : NONE, 1 : OPACITY
#define ALPHA_CLIP_RATE 0.5f

float4x4 mm_wvp : WORLDVIEWPROJECTION;
float4x4 mm_view : VIEW;
#ifdef MIKUMIKUMOVING
float3 light_direction[MMM_LightCount] : LIGHTDIRECTIONS;
bool   light_enable[MMM_LightCount]    : LIGHTENABLES;
float3 light_ambients[MMM_LightCount]   : LIGHTAMBIENTCOLORS;
#else
float3 light_direction : DIRECTION < string Object = "Light"; >;
#endif
bool use_texture;
texture2D diffuse_texture : MATERIALTEXTURE;
sampler2D diffuse_sampler = sampler_state
{
    texture = < diffuse_texture >;
    FILTER = ANISOTROPIC;
    ADDRESSU = WRAP;
    ADDRESSV = WRAP;
};

struct vs_in
{
    float4 pos : POSITION;
    float3 normal : NORMAL;
    float2 uv_a   : TEXCOORD0;
    float2 uv_b   : TEXCOORD1;
    float4 vertex : TEXCOORD2;
    // float3 tangent : TEXCOORD4;
};

struct vs_out 
{
    float4 pos    : POSITION;
    float3 normal     : TEXCOORD0;
    float2 uv : TEXCOORD1;
};

#ifdef MIKUMIKUMOVING 
vs_out vs_model(MMM_SKINNING_INPUT IN,vs_in i)
{
	MMM_SKINNING_OUTPUT mmm = MMM_SkinnedPositionNormal(IN.Pos, IN.Normal, IN.BlendWeight, IN.BlendIndices, IN.SdefC, IN.SdefR0, IN.SdefR1);
    i.pos = mmm.Position;
    i.normal = mmm.Normal;
#else
vs_out vs_model(vs_in i)
{
#endif
    vs_out o;
    // i.pos.xyz = i.pos.xyz + i.normal * 0.05f * i.vertex.a;
    o.pos = mul(i.pos, mm_wvp);
    o.normal = i.normal;
    o.uv = i.uv_a;
    return o;
}

float4 ps_model(vs_out i) : COLOR0
{
    #ifdef MIKUMIKUMOVING
    float ndotl = dot(i.normal, -light_direction[0].xyz);
    #else
    float ndotl = dot(i.normal, -light_direction.xyz);
    #endif

    if(use_texture)
    {
        // sample alpha if it has a texture
        float alpha = tex2D(diffuse_sampler, i.uv).w;
        #if ALPHA_TYPE == 1 
        clip(alpha - ALPHA_CLIP_RATE);
        #endif
    }
    return float4(normalize(i.normal) * 0.5f + 0.5f, 1.0f);
}


technique model_ss_tech < string MMDPass = "object_ss"; > 
{
    pass model_front 
    {
        cullmode = none;
		VertexShader = compile vs_3_0 vs_model();
		PixelShader  = compile ps_3_0 ps_model();
    }
};


technique model_tech < string MMDPass = "object"; > 
{ 
    pass model_front
    {
        cullmode = none;
		VertexShader = compile vs_3_0 vs_model();
		PixelShader  = compile ps_3_0 ps_model();
    }
}

technique mmd_shadow < string MMDPass = "shadow"; > {}
technique mmd_edge < string MMDPass = "edge"; > {}
