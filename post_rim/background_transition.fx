//======================================================//
//               FADE FROM LAST FRAME                   //
//------------------------------------------------------//
// Written by Manashiku                                 //
// Inspired by the transition effect from the           //
// old IdolMaster games when the camera changed         //
//======================================================//
// -- GLOBALS -- //
float2 screensize : VIEWPORTPIXELSIZE;
static float2 screensizeOffset = (float2(0.5, 0.5) / screensize);
float4 clear_color = { 0.5f, 0.5f, 0.5f, 1 };
float clear_depth = 1;
// -- SLIDERS -- //
float transparent : CONTROLOBJECT <string name="(self)"; string item="Tr";>;


// -- MMD SCRIPT -- //
float Script : STANDARDSGLOBAL <
    string ScriptOutput = "color";
    string ScriptClass = "scene";
    string ScriptOrder = "postprocess";
> = 0.8;


// -- TEXTURES -- // 
texture2D current_frame_texture  : RENDERCOLORTARGET <>;
texture2D depth_texture          : RENDERDEPTHSTENCILTARGET <>;

// -- SAMPLERS -- //
sampler current_sampler = sampler_state 
{
    texture = <current_frame_texture>;
    FILTER = ANISOTROPIC;
    ADDRESSU = CLAMP;
    ADDRESSV = CLAMP;
};



//======================================================//
// --  STRUCTURES -- //
struct vs_out 
{
    float4 pos : POSITION;
    float2 uv : TEXCOORD0;
};

//======================================================//
// -- VERTEX SHADER -- //
vs_out vs_0(float4 pos : POSITION, float2 uv : TEXCOORD0)
{
    vs_out o;
    o.pos = pos;
    o.uv = uv + screensizeOffset;
    return o;
}

//======================================================//
float4 transition_ps(vs_out i, float2 og_uv : TEXCOORD0)  : COLOR
{
    float4 current = tex2D(current_sampler, i.uv);
    float4 final = current;
    return final;
} 

//======================================================//
// -- TECHNIQUE -- //
technique post_tech 
<
    string Script = 
        "RenderColorTarget = current_frame_texture;"
        "RenderDepthStencilTarget = depth_texture;"
        "ClearSetColor = clear_color;"
		"ClearSetDepth = clear_depth;"
		"Clear = Color;"
		"Clear = Depth;"
		"ScriptExternal = Color;"


        "RenderColorTarget =;"
		"RenderDepthStencilTarget =;"
		"Clear = Color;"
		"Clear = Depth;"
		"Pass = transition;"
        ;
> 
{

    pass transition < string Script = "Draw=Buffer;" ; >
    {
        AlphaBlendEnable = false;
		VertexShader = compile vs_2_0 vs_0();
		PixelShader  = compile ps_2_0 transition_ps();
    }
};