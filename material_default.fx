//====================//
//  MATERIAL GENERAL : 
//====================//
#define BACKFACE_USE_UV2 
#define MATERIAL_ALPHA_USE 2 // 0 : none, 1 : AlphaTest, 2 : Emission, 3 : Blush
#define ALPHA_CUTOFF 0.5f   
#define BLUSH_COLOR float4(1.0f, 0.06f, 0.0f, 1.0f)
#define BLUSH_STRENGTH 0.5f
#define BLUSH_SLIDER_NAME "mmd blush facial"
// this is the pmx morph slider that will control the blush so it is animatable 


//====================// 
//   NORMAL MAPPING:
//====================//
#define USE_NORMAL_TEXTURE "normalmap" 
#define NORMAL_BUMP_SCALE 1.0f
// #define DEBUG_VISUALIZE_NORMALS 
// #define DEBUG_VISUALIZE_NORMALS_B 
// this will work regardless of if the normal map is enabled      

//====================// 
//    DETAIL LINE:
//====================// 
#define USE_TEXTURE_LINE
// this will be disabled no matter what if the normal texture is disabled
#define LINE_MULTIPLIER       float4(0.5f, 0.5f, 0.5f, 1.0f)
#define LINE_DISTANCE_CONTROL float3(0.1f, 0.6f, 0.1f)
#define LINE_SMOOTHNESS       0.15f
#define LINE_THICKNESS        0.55f 
// #define DEBUG_VISUALIZE_LINES // test if the lines are rendering properly 

//====================//     
//      SHADOW : 
//====================//
#define USE_SHADOW_TRANSITION
#define USE_LIGHTMAP_AO 
#define USE_VERTEXCOLOR_AO 
#define USE_VERTEXCOLOR_RAMP_WIDTH   
#define USE_RAMP_TEXTURE  
#define SHADOW_RAMP_WIDTH 1.0f 
#define SHADOW_LIGHT_AREA  0.55f 
#define FACE_SHADOW_SOFTNESS 0.0f
#define FACE_LIGHTMAP "sub/tex/facelightmap.png" // face map path
// #define USE_FACE_SHADOW_MAP
// #define DEBUG_VISUALIZE_SHADOW

//====================//
//    MATERIAL 1 : 
//====================//
#define COLOR_1 float4(1.0f, 1.0f, 1.0f, 1.0f)
#define SHADOW_WARM_COLOR_1 float4(0.0f, 0.0f, 0.0f, 1.0f)
#define SHADOW_COOL_COLOR_1 float4(0.0f, 0.0f, 0.0f, 1.0f)
#define USE_SPECULAR_MAT
#define SPECULAR_COLOR float4(1.0f, 1.0f, 1.0f, 1.0f)
// specular color is shared by all materials 
#define SPECULAR_MULTI_1 0.1f
#define SPECULAR_SHINE_1 4.0f
#define USE_OUTLINE 
#define OUTLINE_WIDTH 1.0f
#define OUTLINE_COLOR_1 float4(0.0f, 0.0f, 0.0f, 1.0f)

//====================//
//    MATERIAL 2 : 
//====================//
#define USE_MATERIAL_2
#define COLOR_2 float4(1.0f, 1.0f, 1.0f, 1.0f) 
#define SHADOW_WARM_COLOR_2 float4(0.0f, 0.0f, 0.0f, 1.0f)
#define SHADOW_COOL_COLOR_2 float4(0.0f, 0.0f, 0.0f, 1.0f)
#define SPECULAR_MULTI_2 0.1f
#define SPECULAR_SHINE_2 10.0f
#define OUTLINE_COLOR_2 float4(0.0f, 0.0f, 0.0f, 1.0f)

//====================//
//    MATERIAL 3 : 
//====================//
#define USE_MATERIAL_3
#define COLOR_3 float4(1.0f, 1.0f, 1.0f, 1.0f)
#define SHADOW_WARM_COLOR_3 float4(.0f, .0f, .0f, 1.0f)
#define SHADOW_COOL_COLOR_3 float4(0.0f, 0.0f, 0.0f, 1.0f)  
#define SPECULAR_MULTI_3 0.1f 
#define SPECULAR_SHINE_3 10.0f
#define OUTLINE_COLOR_3 float4(0.0f, 0.0f, 0.0f, 1.0f)

//====================//
//    MATERIAL 4 : 
//====================// 
#define USE_MATERIAL_4
#define COLOR_4 float4(1.0f, 1.0f, 1.0f, 1.0f) 
#define SHADOW_WARM_COLOR_4 float4(0.0f, 0.0f, 0.0f, 1.0f)
#define SHADOW_COOL_COLOR_4 float4(0.0f, 0.0f, 0.0f, 1.0f) 
#define SPECULAR_MULTI_4 0.1f
#define SPECULAR_SHINE_4 10.0f
#define OUTLINE_COLOR_4 float4(0.0, 0.0, 0.0, 1.0f)

//====================//
//    MATERIAL 5 : 
//====================//
#define USE_MATERIAL_5
#define COLOR_5 float4(1.0f, 1.0f, 1.0f, 1.0f) 
#define SHADOW_WARM_COLOR_5 float4(0.0f, 0.0f, 0.0f, 1.0f)
#define SHADOW_COOL_COLOR_5 float4(0.0f, 0.0f, 0.0f, 1.0f)
#define SPECULAR_MULTI_5 0.1f
#define SPECULAR_SHINE_5 10.0f 
#define OUTLINE_COLOR_5 float4(0.0, 0.0, 0.0, 1.0f)

//====================//
//       METAL 
//====================//
#define USE_METAL_MAT            "sub/tex/metalmap.png"
#define USE_SPECULAR_RAMP        "sub/tex/specularramp.PNG"
#define METAL_BRIGHTNESS         3.0f
#define METAL_TILE               float2(1.0f, 1.0f) 
#define METAL_SHARP_OFFSET       0.95f
#define METAL_SHININESS          4.0f
#define METAL_SPECULAR_IN_SHADOW 0.2f
#define METAL_SPECULAR_SCALE     1.0f 
#define METAL_LIGHT              float4(1.0f, 1.0f, 1.0f, 1.0f)
#define METAL_DARK               float4(0.5f, 0.5f, 0.5f, 1.0f)
#define METAL_SHARP_COLOR        float4(0.5f, 0.5f, 0.5f, 1.0f)
#define METAL_SPECULAR_COLOR     float4(1.0f, 1.0f, 1.0f, 1.0f)
#define METAL_SHADOW_COLOR       float4(0.5f, 0.5f, 0.5f, 1.0f)
//============================================================================//
#include "shader.fxsub"