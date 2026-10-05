// Made with Amplify Shader Editor v1.9.9.12
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Other Custom/Epic Red Dot Sight Unlit_Icon"
{
	Properties
	{
		_ReticleMaskRTransparencyA( "Reticle Mask (R) Transparency (A)", 2D ) = "black" {}
		[HDR] _ReticleColor( "Reticle Color", Color ) = ( 1, 0, 0 )
		_ReticleOpacity( "Reticle Opacity", Range( 0, 1 ) ) = 1
		_ReticleSizeAdjustment( "Reticle Size Adjustment", Range( 0, 10 ) ) = 1
		[Toggle( _USENOISE_ON )] _UseNoise( "Use Noise", Float ) = 0
		_NoiseScale( "Noise Scale", Range( 0, 20 ) ) = 1
		[Toggle( _NOISEVARIATION_ON )] _NoiseVariation( "Noise Variation", Float ) = 0
		_NoiseVariationSpeed( "Noise Variation Speed", Range( 0, 10 ) ) = 1
		[Toggle( _INVERTXAXIS_ON )] _InvertXAxis( "Invert X Axis", Float ) = 0
		[Toggle( _INVERTZAXIS_ON )] _InvertZAxis( "Invert Z Axis", Float ) = 0
		[Toggle( _ZAXISPROJECTION_ON )] _ZAxisProjection( "Z Axis Projection", Float ) = 0

	}

	SubShader
	{
		

		

		Tags { "RenderType"="Transparent" "Queue"="Transparent" }

	LOD 0

		ZWrite Off
		Cull Off
		AlphaToMask Off
		ColorMask RGBA
		Blend One Zero, One Zero
		BlendOp Add, Add

		

		Blend One Zero, One Zero
		BlendOp Add, Add
		

		CGINCLUDE
			#pragma target 3.5
			// ensure rendering platforms toggle list is visible

			float4 ComputeClipSpacePosition( float2 screenPosNorm, float deviceDepth )
			{
				float4 positionCS = float4( screenPosNorm * 2.0 - 1.0, deviceDepth, 1.0 );
			#if UNITY_UV_STARTS_AT_TOP
				positionCS.y = -positionCS.y;
			#endif
				return positionCS;
			}
		ENDCG

		
		Pass
		{
			
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }

			Cull Back
			ZWrite Off
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
			BlendOp Add, Add

			

			CGPROGRAM
				#define ASE_SURFACE_TRANSPARENT
				#define ASE_VERSION 19912

				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_instancing
				#include "UnityCG.cginc"

				#include "UnityStandardBRDF.cginc"
				#include "UnityShaderVariables.cginc"
				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#pragma shader_feature_local _INVERTXAXIS_ON
				#pragma shader_feature_local _ZAXISPROJECTION_ON
				#pragma shader_feature_local _INVERTZAXIS_ON
				#pragma shader_feature_local _USENOISE_ON
				#pragma shader_feature_local _NOISEVARIATION_ON


				#if defined(ASE_WRITE_DEPTH_CONSERVATIVE) && (SHADER_TARGET >= 45)
					#define ASE_SV_DEPTH SV_DepthLessEqual
					#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
				#else
					#define ASE_SV_DEPTH SV_Depth
					#define ASE_SV_POSITION_QUALIFIERS
				#endif

				struct appdata
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					float4 tangent : TANGENT;
					float4 ase_texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					ASE_SV_POSITION_QUALIFIERS float4 pos : SV_POSITION;
					float4 ase_texcoord : TEXCOORD0;
					float4 ase_texcoord1 : TEXCOORD1;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				uniform float3 _ReticleColor;
				uniform sampler2D _ReticleMaskRTransparencyA;
				uniform float _ReticleSizeAdjustment;
				uniform float _NoiseScale;
				uniform float _NoiseVariationSpeed;
				uniform float _ThermalVisionOn;
				uniform float _ReticleOpacity;


				float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
				float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
				float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
				float snoise( float2 v )
				{
					const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
					float2 i = floor( v + dot( v, C.yy ) );
					float2 x0 = v - i + dot( i, C.xx );
					float2 i1;
					i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
					float4 x12 = x0.xyxy + C.xxzz;
					x12.xy -= i1;
					i = mod2D289( i );
					float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
					float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
					m = m * m;
					m = m * m;
					float3 x = 2.0 * frac( p * C.www ) - 1.0;
					float3 h = abs( x ) - 0.5;
					float3 ox = floor( x + 0.5 );
					float3 a0 = x - ox;
					m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
					float3 g;
					g.x = a0.x * x0.x + h.x * x0.y;
					g.yz = a0.yz * x12.xz + h.yz * x12.yw;
					return 130.0 * dot( m, g );
				}
				

				v2f vert( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					float3 ase_positionWS = mul( unity_ObjectToWorld, float4( ( v.vertex ).xyz, 1 ) ).xyz;
					o.ase_texcoord.xyz = ase_positionWS;
					
					o.ase_texcoord1.xy = v.ase_texcoord.xy;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord.w = 0;
					o.ase_texcoord1.zw = 0;

					#ifdef ASE_ABSOLUTE_VERTEX_POS
						float3 defaultVertexValue = v.vertex.xyz;
					#else
						float3 defaultVertexValue = float3(0, 0, 0);
					#endif
					float3 vertexValue = defaultVertexValue;
					#ifdef ASE_ABSOLUTE_VERTEX_POS
						v.vertex.xyz = vertexValue;
					#else
						v.vertex.xyz += vertexValue;
					#endif
					v.vertex.w = 1;
					v.normal = v.normal;
					v.tangent = v.tangent;

					o.pos = UnityObjectToClipPos( v.vertex );

					#if defined( ASE_SHADOWS )
						UNITY_TRANSFER_SHADOW( o, v.texcoord );
					#endif
					return o;
				}

				half4 frag( v2f IN 
							#if defined( ASE_WRITE_DEPTH )
								, out float outputDepth : SV_Depth
							#endif
				) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID( IN );
					UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

					float4 ScreenPosNorm = float4( IN.pos.xy * ( _ScreenParams.zw - 1.0 ), IN.pos.zw );
					float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, IN.pos.z ) * IN.pos.w;
					float4 ScreenPos = ComputeScreenPos( ClipPos );

					float3 ase_positionWS = IN.ase_texcoord.xyz;
					float3 ase_viewVectorOS = mul( ( float3x3 )unity_WorldToObject, ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - ase_positionWS : UNITY_MATRIX_V[ 2 ].xyz ) );
					float3 ase_viewDirSafeOS = Unity_SafeNormalize( ase_viewVectorOS );
					float3 appendResult174 = (float3(ase_viewDirSafeOS.x , ase_viewDirSafeOS.y , ase_viewDirSafeOS.z));
					float3 appendResult169 = (float3(ase_viewDirSafeOS.x , ase_viewDirSafeOS.z , ( ase_viewDirSafeOS.y * -1.0 )));
					#ifdef _ZAXISPROJECTION_ON
					float3 staticSwitch172 = appendResult169;
					#else
					float3 staticSwitch172 = appendResult174;
					#endif
					float3 break173 = staticSwitch172;
					#ifdef _INVERTXAXIS_ON
					float staticSwitch132 = break173.x;
					#else
					float staticSwitch132 = ( break173.x * -1.0 );
					#endif
					float temp_output_109_0 = ( abs( break173.y ) * ( _ReticleSizeAdjustment * 0.035 ) );
					#ifdef _INVERTZAXIS_ON
					float staticSwitch133 = break173.z;
					#else
					float staticSwitch133 = ( break173.z * -1.0 );
					#endif
					float2 appendResult57 = (float2(( staticSwitch132 / temp_output_109_0 ) , ( staticSwitch133 / temp_output_109_0 )));
					float4 tex2DNode10 = tex2D( _ReticleMaskRTransparencyA, ( appendResult57 + float2( 0.5,0.5 ) ) );
					float mulTime103 = _Time.y * ( _NoiseVariationSpeed * 20.0 );
					#ifdef _NOISEVARIATION_ON
					float staticSwitch105 = round( mulTime103 );
					#else
					float staticSwitch105 = 0.0;
					#endif
					float2 temp_cast_0 = (staticSwitch105).xx;
					float dotResult4_g2 = dot( temp_cast_0 , float2( 12.9898,78.233 ) );
					float lerpResult10_g2 = lerp( 0.0 , 10.0 , frac( ( sin( dotResult4_g2 ) * 43758.55 ) ));
					float2 temp_cast_1 = (lerpResult10_g2).xx;
					float2 texCoord99 = IN.ase_texcoord1.xy * ( _NoiseScale * float2( 400,400 ) ) + temp_cast_1;
					float simplePerlin2D96 = snoise( texCoord99 );
					simplePerlin2D96 = simplePerlin2D96*0.5 + 0.5;
					#ifdef _USENOISE_ON
					float staticSwitch100 = simplePerlin2D96;
					#else
					float staticSwitch100 = 1.0;
					#endif
					
					float lerpResult175 = lerp( saturate( ( tex2DNode10.a * _ReticleOpacity ) ) , 1.0 , _ThermalVisionOn);
					

					float3 Color = ( ( _ReticleColor * saturate( ( tex2DNode10.a * staticSwitch100 ) ) ) * ( 1.0 - _ThermalVisionOn ) );
					float Alpha = lerpResult175;
					half AlphaClipThreshold = 0.5;
					half AlphaClipThresholdShadow = 0.5;

					#if defined( ASE_WRITE_DEPTH )
						outputDepth = IN.pos.z;
					#endif

					#ifdef _ALPHATEST_ON
						clip( Alpha - AlphaClipThreshold );
					#endif

				#if defined( ASE_SURFACE_TRANSPARENT ) || defined( ASE_OPAQUE_KEEP_ALPHA )
					return half4( Color, Alpha );
				#else
					return half4( Color, 1.0 );
				#endif
				}
			ENDCG
		}

	
	}
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19912
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":148,"pos":[-5296,-504],"params":["Inherit","False","Constant","_Float0","Float 0","10","0","Create","True","0","0","0","False","0","False","Object","-1","","-1","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":170,"pos":[-4968,-544],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.ViewDirInputsCoordNode, AmplifyShaderEditor","id":8,"pos":[-5312,-696],"params":["Inherit","False","Object","True","0","4","FLOAT3","0","FLOAT","1","FLOAT","2","FLOAT","3"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":106,"pos":[-3632,200],"params":["Inherit","False","Constant","_Float2","Float 2","6","0","Create","True","0","0","0","False","0","False","Object","-1","","20","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":108,"pos":[-3760,104],"params":["Inherit","False","Property","_NoiseVariationSpeed","Noise Variation Speed","7","0","Create","True","0","0","0","True","0","False","Object","-1","","1","0","0","10","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor","id":174,"pos":[-4816,-720],"params":["Inherit","False","FLOAT3","4","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor","id":169,"pos":[-4816,-592],"params":["Inherit","False","FLOAT3","4","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":107,"pos":[-3456,120],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":172,"pos":[-4656,-616],"params":["Inherit","False","Property","_ZAxisProjection","Z Axis Projection","10","0","Create","True","0","0","0","False","0","False","","0","0","0","True","","Toggle","2","Key0","Key1","Create","True","True","All","9","1","FLOAT3","0,0,0","False","0","FLOAT3","0,0,0","False","2","FLOAT3","0,0,0","False","3","FLOAT3","0,0,0","False","4","FLOAT3","0,0,0","False","5","FLOAT3","0,0,0","False","6","FLOAT3","0,0,0","False","7","FLOAT3","0,0,0","False","8","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":111,"pos":[-3424,-384],"params":["Inherit","False","Constant","_Float4","Float 3","7","0","Create","True","0","0","0","False","0","False","Object","-1","","0.035","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":110,"pos":[-3504,-464],"params":["Inherit","False","Property","_ReticleSizeAdjustment","Reticle Size Adjustment","3","0","Create","True","0","0","0","True","0","False","Object","-1","","1","1","0","10","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor","id":103,"pos":[-3296,120],"params":["Inherit","False","1","0","FLOAT","20","False","5","FLOAT","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor","id":173,"pos":[-4384,-616],"params":["Inherit","False","FLOAT3","1","0","FLOAT3","0,0,0","False","16","FLOAT","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT","5","FLOAT","6","FLOAT","7","FLOAT","8","FLOAT","9","FLOAT","10","FLOAT","11","FLOAT","12","FLOAT","13","FLOAT","14","FLOAT","15"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":147,"pos":[-4048,-464],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.AbsOpNode, AmplifyShaderEditor","id":39,"pos":[-3248,-576],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":112,"pos":[-3184,-464],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RoundOpNode, AmplifyShaderEditor","id":104,"pos":[-3120,120],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":146,"pos":[-4024,-744],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":133,"pos":[-3808,-528],"params":["Inherit","False","Property","_InvertZAxis","Invert Z Axis","9","0","Create","True","0","0","0","False","0","False","","0","0","0","True","","Toggle","2","Key0","Key1","Create","True","True","All","9","1","FLOAT","0","False","0","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","4","FLOAT","0","False","5","FLOAT","0","False","6","FLOAT","0","False","7","FLOAT","0","False","8","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":109,"pos":[-2992,-560],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":132,"pos":[-3808,-720],"params":["Inherit","False","Property","_InvertXAxis","Invert X Axis","8","0","Create","True","0","0","0","False","0","False","","0","0","0","True","","Toggle","2","Key0","Key1","Create","True","True","All","9","1","FLOAT","0","False","0","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","4","FLOAT","0","False","5","FLOAT","0","False","6","FLOAT","0","False","7","FLOAT","0","False","8","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor","id":98,"pos":[-2704,-32],"params":["Inherit","False","Constant","_Vector1","Vector 1","2","0","Create","True","0","0","0","False","0","False","Object","-1","","400,400","0,0","0","3","FLOAT2","0","FLOAT","1","FLOAT","2"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":102,"pos":[-2800,-176],"params":["Inherit","False","Property","_NoiseScale","Noise Scale","5","0","Create","True","0","0","0","True","0","False","Object","-1","","1","0","0","20","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":105,"pos":[-2976,104],"params":["Inherit","False","Property","_NoiseVariation","Noise Variation","6","0","Create","True","0","0","0","False","0","False","","0","0","0","True","","Toggle","2","Key0","Key1","Create","True","True","All","9","1","FLOAT","0","False","0","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","4","FLOAT","0","False","5","FLOAT","0","False","6","FLOAT","0","False","7","FLOAT","0","False","8","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor","id":59,"pos":[-2752,-512],"params":["Inherit","False","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor","id":58,"pos":[-2752,-592],"params":["Inherit","False","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":101,"pos":[-2464,-176],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor","id":149,"pos":[-2704,104],"params":["Inherit","False","Random Range","-1","","2","7b754edb8aebbfb4a9ace907af661cfc","0","3","1","FLOAT2","0,0","False","2","FLOAT","0","False","3","FLOAT","10","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor","id":57,"pos":[-2400,-592],"params":["Inherit","False","FLOAT2","4","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor","id":77,"pos":[-2432,-480],"params":["Inherit","False","Constant","_Vector0","Vector 0","3","0","Create","True","0","0","0","False","0","False","Object","-1","","0.5,0.5","0,0","0","3","FLOAT2","0","FLOAT","1","FLOAT","2"]}
{"type":"AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor","id":99,"pos":[-2272,-192],"params":["Inherit","False","0","-1","2","3","2","SAMPLER2D","","False","0","FLOAT2","1,1","False","1","FLOAT2","0,0","False","5","FLOAT2","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":60,"pos":[-2160,-576],"params":["Inherit","False","2","2","0","FLOAT2","0,0","False","1","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor","id":9,"pos":[-2208,-432],"params":["Inherit","True","Property","_ReticleMaskRTransparencyA","Reticle Mask (R) Transparency (A)","0","0","Create","True","0","0","0","False","0","False","","None","9be4c310fe8a09f498910fcd93b44d4d","False","black","Auto","Texture2D","False","-1","0","2","SAMPLER2D","0","SAMPLERSTATE","1"]}
{"type":"AmplifyShaderEditor.NoiseGeneratorNode, AmplifyShaderEditor","id":96,"pos":[-2032,-192],"params":["Inherit","False","Simplex2D","True","False","2","0","FLOAT2","425.6,251","False","1","FLOAT","1","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":153,"pos":[-1984,-88],"params":["Inherit","False","Constant","_Float0","Float 0","10","0","Create","True","0","0","0","False","0","False","Object","-1","","1","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor","id":10,"pos":[-1888,-432],"params":["Inherit","True","Property","_TextureSample0","Texture Sample 0","1","0","Create","True","0","0","0","False","0","False","","-1","None","None","True","0","False","white","Auto","False","Object","-1","Auto","Texture2D","False","8","0","SAMPLER2D","","False","1","FLOAT2","0,0","False","2","FLOAT","0","False","3","FLOAT2","0,0","False","4","FLOAT2","0,0","False","5","FLOAT","1","False","6","FLOAT","0","False","7","SAMPLERSTATE","","False","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":100,"pos":[-1776,-208],"params":["Inherit","False","Property","_UseNoise","Use Noise","4","0","Create","True","0","0","0","False","0","False","","0","0","0","True","","Toggle","2","Key0","Key1","Create","True","True","All","9","1","FLOAT","0","False","0","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","4","FLOAT","0","False","5","FLOAT","0","False","6","FLOAT","0","False","7","FLOAT","0","False","8","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":177,"pos":[-1704,32],"params":["Inherit","False","Property","_ReticleOpacity","Reticle Opacity","2","0","Create","True","0","0","0","False","0","False","Object","-1","","1","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":152,"pos":[-1520,-312],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":176,"pos":[-1232,-112],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.ColorNode, AmplifyShaderEditor","id":11,"pos":[-1328,-560],"params":["Inherit","False","Property","_ReticleColor","Reticle Color","1","1","[HDR]","Create","True","0","0","0","False","0","False","Object","-1","","1,0,0,0","1,0,0,1","True","False","0","6","FLOAT3","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor","id":160,"pos":[-1120,-312],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":163,"pos":[-1408,208],"params":["Inherit","False","Global","_ThermalVisionOn","_ThermalVisionOn","10","1","[Toggle]","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor","id":178,"pos":[-1048,-80],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":161,"pos":[-1240,0],"params":["Inherit","False","Constant","_Float0","Float 0","10","0","Create","True","0","0","0","False","0","False","Object","-1","","1","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":162,"pos":[-960,-344],"params":["Inherit","False","2","2","0","FLOAT3","0,0,0","False","1","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor","id":179,"pos":[-832,144],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.LerpOp, AmplifyShaderEditor","id":175,"pos":[-848,-80],"params":["Inherit","True","3","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":167,"pos":[-360,-56],"params":["Inherit","False","2","2","0","FLOAT3","0,0,0","False","1","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":154,"pos":[0,-215],"params":["Float","False","False","-1","3","AmplifyShaderEditor.MaterialInspector","0","7","New Amplify Shader","0770190933193b94aaa3065e307002fa","True","ExtraPrePass","0","0","ExtraPrePass","6","False","True","1","1","False","","0","False","","1","1","False","","0","False","","True","1","False","","1","False","","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","True","True","True","True","True","0","False","","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","False","False","False","True","1","RenderType=Opaque=RenderType","True","3","True","12","all","0","False","True","1","1","False","","0","False","","0","1","False","","0","False","","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","True","True","True","True","0","False","","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","False","True","1","LightMode=ForwardBase","False","False","0","","0","0","Standard","0","False","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":155,"pos":[0,0],"params":["Float","False","True","-1","3","AmplifyShaderEditor.MaterialInspector","0","7","Other Custom/Epic Red Dot Sight Unlit_Icon","0770190933193b94aaa3065e307002fa","True","Unlit","0","1","Unlit","8","False","True","1","1","False","","0","False","","1","1","False","","0","False","","True","1","False","","1","False","","False","False","False","False","False","False","False","False","False","True","0","False","","True","True","2","False","","True","True","True","True","True","True","0","False","","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","True","True","2","False","","False","False","False","True","2","RenderType=Transparent=RenderType","Queue=Transparent=Queue=0","True","3","True","12","all","0","True","True","3","1","False","","10","False","","3","1","False","","10","False","","True","1","False","","1","False","","False","False","False","False","False","False","False","False","False","False","True","True","0","False","","False","True","True","True","True","True","0","False","","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","2","False","","True","3","False","","True","True","0","False","","0","False","","False","True","1","LightMode=ForwardBase","False","False","0","","0","0","Standard","10","Surface","1","639250066989179043","  Keep Alpha","0","0","  Blend","0","0","Alpha Clipping","0","0","  Use Shadow Threshold","0","0","Cast Shadows","0","639250068387531592","Write Depth","0","0","  Conservative","0","0","Extra Pre Pass","0","0","Vertex Position","1","0","0","3","False","True","False","False","","False","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":156,"pos":[0,0],"params":["Float","False","False","-1","3","AmplifyShaderEditor.MaterialInspector","0","1","New Amplify Shader","0770190933193b94aaa3065e307002fa","True","ShadowCaster","0","2","ShadowCaster","0","False","True","1","1","False","","0","False","","1","1","False","","0","False","","True","1","False","","1","False","","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","True","True","True","True","True","0","False","","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","False","False","False","True","1","RenderType=Opaque=RenderType","True","3","True","12","all","0","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","False","False","False","False","False","False","False","False","False","False","False","False","True","1","False","","True","3","False","","False","False","True","1","LightMode=ShadowCaster","False","False","0","","0","0","Standard","0","False","0"]}
{"wire":[170,0,8,2]}
{"wire":[170,1,148,0]}
{"wire":[174,0,8,1]}
{"wire":[174,1,8,2]}
{"wire":[174,2,8,3]}
{"wire":[169,0,8,1]}
{"wire":[169,1,8,3]}
{"wire":[169,2,170,0]}
{"wire":[107,0,108,0]}
{"wire":[107,1,106,0]}
{"wire":[172,1,174,0]}
{"wire":[172,0,169,0]}
{"wire":[103,0,107,0]}
{"wire":[173,0,172,0]}
{"wire":[147,0,173,2]}
{"wire":[147,1,148,0]}
{"wire":[39,0,173,1]}
{"wire":[112,0,110,0]}
{"wire":[112,1,111,0]}
{"wire":[104,0,103,0]}
{"wire":[146,0,173,0]}
{"wire":[146,1,148,0]}
{"wire":[133,1,147,0]}
{"wire":[133,0,173,2]}
{"wire":[109,0,39,0]}
{"wire":[109,1,112,0]}
{"wire":[132,1,146,0]}
{"wire":[132,0,173,0]}
{"wire":[105,0,104,0]}
{"wire":[59,0,133,0]}
{"wire":[59,1,109,0]}
{"wire":[58,0,132,0]}
{"wire":[58,1,109,0]}
{"wire":[101,0,102,0]}
{"wire":[101,1,98,0]}
{"wire":[149,1,105,0]}
{"wire":[57,0,58,0]}
{"wire":[57,1,59,0]}
{"wire":[99,0,101,0]}
{"wire":[99,1,149,0]}
{"wire":[60,0,57,0]}
{"wire":[60,1,77,0]}
{"wire":[96,0,99,0]}
{"wire":[10,0,9,0]}
{"wire":[10,1,60,0]}
{"wire":[100,1,153,0]}
{"wire":[100,0,96,0]}
{"wire":[152,0,10,4]}
{"wire":[152,1,100,0]}
{"wire":[176,0,10,4]}
{"wire":[176,1,177,0]}
{"wire":[160,0,152,0]}
{"wire":[178,0,176,0]}
{"wire":[162,0,11,0]}
{"wire":[162,1,160,0]}
{"wire":[179,0,163,0]}
{"wire":[175,0,178,0]}
{"wire":[175,1,161,0]}
{"wire":[175,2,163,0]}
{"wire":[167,0,162,0]}
{"wire":[167,1,179,0]}
{"wire":[155,0,167,0]}
{"wire":[155,7,175,0]}
ASEEND*/
//CHKSM=5A481EB6BC64B52575D67C1CE4FC71D6AD3E10D8