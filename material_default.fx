// =================================================================================================//
//                                GENSHIN IMPACT REPLICA SHADER  v0.1                               //
//                         Date : 8/23/2021                  Updated : 3/132022                     //
// =================================================================================================//
// This is the material options for the shader. It's recommended to make multiple copies of this    //
// and edit it those and to save the original one. For the most part you won't actually have to..   //
// Unless you need to add the back side of a material or something..                                //
// This one is specifically for the characters because the environments use a different type of     //
// shader in game.                                                                                  //
// =================================================================================================//
// OPTIONS : 
// Culling
#define is_double_sided 
     //#define use_second_uv // use secondary uv as texture coordinates for flipped faces (double side)
    

// I personally ran into some weird issues editing textures and packing textures
// so this is a work around
// if you only want to use one of these, comment out the ones you arent using
// #define get_lightmap_red_from_separate_image "dummy_light.png"  
// #define get_lightmap_green_from_separate_image "dummy_light.png"
// #define get_lightmap_blue_from_separate_image "dummy_light.png"    
// #define get_lightmap_alpha_from_separate_image "dummy_light.png"

// red : specular intensity and metal mask. black is no specular, grey is specular highlight, pure white is specular + metal highlight
// green : shadow mask. black is completely shaded, grey is shaded with ramp, pure white is no shadow
// blue : specular highlight
// alpha : material ID, see the rgb values in shadow options for what they are

// Face options : 
#define face_tex_name "please replace this.png" 
// put the face light map in the tex folder in sub and just write the name of it as a string on face_tex_name so like "texturename.extension"

// Shadow options :
#define face_shadow_pow 1.0 // controls the change speed of the shadow when the light faces the middle of the face
#define face_rot_offset -1.0 // offset the rotation on face light
#define shadow_rate 0.5 
// changes shadow scale
// choose between 0-4, check the ramps to figure out which ones to use
#define material_ramp_0 0 
#define material_ramp_1 0
#define material_ramp_2 2
#define material_ramp_3 1
#define material_ramp_4 1
// defaults are: a = 1 b = 4 c = 0 d = 2 e = 3
// youll actuall have to play around with these for each model and material since 
// regions arent consistent between models
// some only use a few
// and other use all 5
// there may be a 1-2 value error but these are close enough
#define use_custom_ground_shadow
// tbh this is probably only useful if youre like me and dont load stages 

// Specular options : 
#define use_specular 
#define use_toon_specular // use this for the hard edge specular highlights
// specular color
#define specular_color float4(1.0, 1.0, 1.0, 1.0) 
// specular power/ shininess
#define specular_power_0 6 
#define specular_power_1 10 
#define specular_power_2 10 
#define specular_power_3 10 
#define specular_power_4 10 
// specular rate/multi/intensity
#define specular_rate_0 0.0500000007 
#define specular_rate_1 0.100000001
#define specular_rate_2 0.100000001 
#define specular_rate_3 0.100000001
#define specular_rate_4 0.100000001


// Blush options : 
#define blush_strength 0.2 // max strength, for things that dont use blush set this to 0
#define blush_facial "blush" // name of facial for blush
#define blush_color float4(1.0, 0.062, 0.0, 1.0)

// Glow options : 
// #define is_glow
#define glow_color float4(1.0, 1.0, 1.0, 1.0)

// Outline options : 
#define use_outline
#define outline_thickness 1.0
#define adjust_outline_width float3(0.104999997, 0.245000005, 0.600000024) // set to all 1s if you dont want to use this
// #define use_fov_scale // if you plan on making any renders with perspective off, turn this off
// you will also need to change the outline_thickness accordingly
// #define use_diffuse_texture // use diffuse texture to calculate outline color 
#define use_lightmap_alpha_for_material_region 
// in the same way the alpha channel in the lightmap is used for getting material regions for the ramps
// this will give you more control over what colors certain parts use
// #define outline_color_rgb2float // this will do the conversion from rgb values to float automatically for you
#define outline_color_0 float4(0.009, 0.009, 0.009, 1) // this is the only one thatll be used if you turn off lightmap use
#define outline_color_1 float4(0.001, 0.001, 0.001, 1)
#define outline_color_2 float4(0.56, 0.37, 0.37, 1)
#define outline_color_3 float4(0.01, 0.01, 0.01, 1)
#define outline_color_4 float4(0.52, 0.32, 0.30, 1)

// Rim options : 
// #define use_rim
// #define use_standard
// turn off standard to use a rim thats been offset by the y normal vector, its a different look but not accurate
#define rim_thickness 1.5
#define rim_softness  5 // the higher the value the harder the rim edge is 
#define rim_color float4(1.0, 1.0, 1.0, 0.25) // rgb color, alpha intensity

// Metal options :
#define use_metal
#define metal_tex_name    "dummy_metal.png"
#define metal_scale       float2(1.0, 1.0)
#define metal_brightness  3
#define metal_shadow      0.2
#define metal_spec_scale  15
#define metal_spec_shine  90
#define metal_dark_color  float4(0.63, 0.43, 0.39, 1.0)
#define metal_light_color float4(1.0, 1.0, 1.0, 1.0)
#define metal_specular    float4(1.0, 0.95, 0.81, 1.0)
#define metal_in_shadow   float4(0.86, 0.75, 0.75, 1.0)

// DEBUG :
// #define enable_debug
#define rgbminus 128 
#define rgbstep 100
#define visualize_material_region // this is useful for helping set ramps and outline colors
// region 0 : red
// region 1 : green
// region 2 : blue 
// region 3 : purple
// region 4: : yellow 
// #define display_ramp_color
// #define display_outline_color
#define display_lightmap 
    #define lightmap_red
    #define lightmap_green
    #define lightmap_blue 
    #define lightmap_alpha 


// =================================================================================================//
#include "shader.fx"
