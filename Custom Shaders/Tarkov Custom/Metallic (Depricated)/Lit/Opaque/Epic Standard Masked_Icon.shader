// Made with Amplify Shader Editor v1.9.9.7
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tarkov Custom/Metallic/Lit/Opaque/Epic Standard Masked_Icon"
{
	Properties
	{
		[MaterialEnum(Static, 0, Characters, 1, Hands, 2)] _StencilType( "Stencil Type", Range( 0, 2 ) ) = 0
		[Toggle( _USECOLORCORRECTION_ON )] _UseColorCorrection( "Use Color Correction", Float ) = 0
		_AlbedoColorCorrection( "Albedo Color Correction", Color ) = ( 1, 1, 1 )
		_Base( "Base Color (RGB)", 2D ) = "black" {}
		_ORM( "ORM (RGB)", 2D ) = "gray" {}
		_MetallicMult( "Metallic Mult", Range( 0, 8 ) ) = 1
		_Smoothness( "Smoothness", Range( 0, 10 ) ) = 1
		[Normal] _BumpMap( "Normal Map", 2D ) = "bump" {}
		_NormalIntensity( "Normal Intensity", Float ) = 1
		[Header(Rain Settings)][Space(10)] _DropsSpec( "Drops Spec", Float ) = 128
		_RippleTexScale( "Ripple Texture Scale", Float ) = 4
		_RippleFakeLightIntensityOffset( "Fake Ripple Light Offset", Float ) = 0.7
		_NightRippleFakeLightOffset( "Fake Night Ripple Light Offset", Float ) = 0.2
		_NdotLOffset( "Normal Dot Light Offset", Float ) = 0.4
		[Toggle] _USERAIN( "Material Effected By Rain", Float ) = 0
		[Header(Heat Settings)][Toggle][Space(10)] USEHEAT( "Use Metal Heat Glow", Float ) = 0
		_HeatVisible( "Heat Visibility (0-1)", Float ) = 1
		_Temperature( "Temperature Settings", Vector ) = ( 0.1, 0.2, 0.28, 0 )
		[HDR] _HeatColor1( "Heat Color 1", Color ) = ( 1, 0, 0, 1 )
		[HDR] _HeatColor2( "Heat Color 2", Color ) = ( 1, 0.34, 0, 1 )
		_HeatCenter( "Heat Center", Vector ) = ( 0, 0, 0, 1 )
		_HeatSize( "Heat Size", Vector ) = ( 0.02, 0.04, 0.02, 1 )
		_HeatTemp( "Heat Temperature", Float ) = 0
		[Header(Color Masking Settings)] _PackedMasksRGBA( "Packed Masks (RGBA)", 2D ) = "black" {}
		[Toggle( _USECOLORMASK_ON )] _UseColorMask( "Use Color Mask", Float ) = 0
		[Toggle( _USERASCOLORMASK_ON )] _UseRAsColorMask( "Use R As Color Mask", Float ) = 0
		[Toggle( _USEGASCOLORMASK_ON )] _UseGAsColorMask( "Use G As Color Mask", Float ) = 0
		[Toggle( _USEBASCOLORMASK_ON )] _UseBAsColorMask( "Use B As Color Mask", Float ) = 0
		[Toggle( _USEAASCOLORMASK_ON )] _UseAAsColorMask( "Use A As Color Mask", Float ) = 0
		_MaskRIntensity( "Mask R Intensity", Range( 0, 5 ) ) = 1
		_MaskGIntensity( "Mask G Intensity", Range( 0, 5 ) ) = 1
		_MaskBIntensity( "Mask B Intensity", Range( 0, 5 ) ) = 1
		_MaskAIntensity( "Mask A Intensity", Range( 0, 5 ) ) = 1
		_MaskRColor( "Mask R Color", Color ) = ( 1, 1, 1 )
		_MaskGColor( "Mask G Color", Color ) = ( 1, 1, 1 )
		_MaskBColor( "Mask B Color", Color ) = ( 1, 1, 1 )
		_MaskAColor( "Mask A Color", Color ) = ( 1, 1, 1 )
		[Toggle( _RISHEIGHT_ON )] _RIsHeight( "R Is Height", Float ) = 0
		[Toggle( _GISHEIGHT_ON )] _GIsHeight( "G Is Height", Float ) = 0
		[Toggle( _BISHEIGHT_ON )] _BIsHeight( "B Is Height", Float ) = 0
		[Toggle( _AISHEIGHT_ON )] _AIsHeight( "A Is Height", Float ) = 0
		[Toggle( _USEMASKMETALLIC_ON )] _UseMaskMetallic( "Use Mask Metallic", Float ) = 0
		_MaskRMetallicLevel( "Mask R Metallic Level", Range( 0, 1 ) ) = 0
		_MaskGMetallicLevel( "Mask G Metallic Level", Range( 0, 1 ) ) = 0
		_MaskBMetallicLevel( "Mask B Metallic Level", Range( 0, 1 ) ) = 0
		_MaskAMetallicLevel( "Mask A Metallic Level", Range( 0, 1 ) ) = 0
		[Toggle( _USEMASKROUGHNESS_ON )] _UseMaskRoughness( "Use Mask Roughness", Float ) = 0
		_MaskRRoughLevel( "Mask R Rough Level", Range( 0, 1 ) ) = 0
		_MaskGRoughLevel( "Mask G Rough Level", Range( 0, 1 ) ) = 0
		_MaskBRoughLevel( "Mask B Rough Level", Range( 0, 1 ) ) = 0
		_MaskARoughLevel( "Mask A Rough Level", Range( 0, 1 ) ) = 0
		_HeightMapStrength( "Height Map Strength", Range( -5, 5 ) ) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}


		//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
		//_TransStrength( "Trans Strength", Range( 0, 50 ) ) = 1
		//_TransNormal( "Trans Normal Distortion", Range( 0, 1 ) ) = 0.5
		//_TransScattering( "Trans Scattering", Range( 1, 50 ) ) = 2
		//_TransDirect( "Trans Direct", Range( 0, 1 ) ) = 0.9
		//_TransAmbient( "Trans Ambient", Range( 0, 1 ) ) = 0.1
		//_TransShadow( "Trans Shadow", Range( 0, 1 ) ) = 0.5

		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25

		//[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		//[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0

		//_InstancedTerrainNormals("Specular Highlights", Float) = 1.0
	}

	SubShader
	{
		

		

		Tags { "RenderType"="Opaque" "Queue"="Geometry" "DisableBatching"="False" }

	LOD 0

		Cull Back
		AlphaToMask Off
		ZWrite On
		ZTest LEqual
		ColorMask RGBA

		Stencil
		{
			Ref [_StencilType]
			WriteMask 3
			Comp Always
			Pass Replace
			Fail Keep
			ZFail Keep
		}

		Blend Off
		

		CGINCLUDE
			#pragma target 3.5
			// ensure rendering platforms toggle list is visible

			float4 FixedTess( float tessValue )
			{
				return tessValue;
			}

			float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
			{
				float3 wpos = mul(o2w,vertex).xyz;
				float dist = distance (wpos, cameraPos);
				float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
				return f;
			}

			float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
			{
				float4 tess;
				tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
				tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
				tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
				tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
				return tess;
			}

			float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
			{
				float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
				float len = distance(wpos0, wpos1);
				float f = max(len * scParams.y / (edgeLen * dist), 1.0);
				return f;
			}

			float DistanceFromPlane (float3 pos, float4 plane)
			{
				float d = dot (float4(pos,1.0f), plane);
				return d;
			}

			bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
			{
				float4 planeTest;
				planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							  (( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							  (( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
				planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							  (( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							  (( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
				planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							  (( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							  (( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
				planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							  (( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							  (( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
				return !all (planeTest);
			}

			float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
			{
				float3 f;
				f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
				f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
				f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

				return CalcTriEdgeTessFactors (f);
			}

			float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
			{
				float3 pos0 = mul(o2w,v0).xyz;
				float3 pos1 = mul(o2w,v1).xyz;
				float3 pos2 = mul(o2w,v2).xyz;
				float4 tess;
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
				return tess;
			}

			float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
			{
				float3 pos0 = mul(o2w,v0).xyz;
				float3 pos1 = mul(o2w,v1).xyz;
				float3 pos2 = mul(o2w,v2).xyz;
				float4 tess;

				if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
				{
					tess = 0.0f;
				}
				else
				{
					tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
					tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
					tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
					tess.w = (tess.x + tess.y + tess.z) / 3.0f;
				}
				return tess;
			}

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
			
			Name "ForwardBase"
			Tags { "LightMode"="ForwardBase" }

			Blend One Zero

			CGPROGRAM
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#pragma multi_compile_fog
				#define ASE_FOG
				#define ASE_VERSION 19907

				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fwdbase
				#ifndef UNITY_PASS_FORWARDBASE
					#define UNITY_PASS_FORWARDBASE
				#endif
				#include "HLSLSupport.cginc"
				#if defined( ASE_GEOMETRY ) || defined( ASE_IMPOSTOR )
					#ifndef UNITY_INSTANCED_LOD_FADE
						#define UNITY_INSTANCED_LOD_FADE
					#endif
					#ifndef UNITY_INSTANCED_SH
						#define UNITY_INSTANCED_SH
					#endif
					#ifndef UNITY_INSTANCED_LIGHTMAPSTS
						#define UNITY_INSTANCED_LIGHTMAPSTS
					#endif
				#endif
				#include "UnityShaderVariables.cginc"
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				#if defined( UNITY_INSTANCING_ENABLED ) && defined( ASE_INSTANCED_TERRAIN ) && ( defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL) || defined(_INSTANCEDTERRAINNORMALS_PIXEL) )
					#define ENABLE_TERRAIN_PERPIXEL_NORMAL
				#endif

				#include "UnityStandardUtils.cginc"
				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
				#pragma shader_feature_local _USECOLORMASK_ON
				#pragma shader_feature_local _USECOLORCORRECTION_ON
				#pragma shader_feature_local _USERASCOLORMASK_ON
				#pragma shader_feature_local _USEGASCOLORMASK_ON
				#pragma shader_feature_local _USEBASCOLORMASK_ON
				#pragma shader_feature_local _USEAASCOLORMASK_ON
				#pragma shader_feature_local _RISHEIGHT_ON
				#pragma shader_feature_local _GISHEIGHT_ON
				#pragma shader_feature_local _BISHEIGHT_ON
				#pragma shader_feature_local _AISHEIGHT_ON
				#pragma shader_feature_local _USEMASKMETALLIC_ON
				#pragma shader_feature_local _USEMASKROUGHNESS_ON


				struct appdata
				{
					float4 vertex : POSITION;
					half3 normal : NORMAL;
					half4 tangent : TANGENT;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 worldPos : TEXCOORD0; // xyz = positionWS, w = fogCoord
					half3 normalWS : TEXCOORD1;
					float4 tangentWS : TEXCOORD2; // holds terrainUV ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					half4 ambientOrLightmapUV : TEXCOORD3;
					UNITY_LIGHTING_COORDS( 4, 5 )
					float4 ase_texcoord6 : TEXCOORD6;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				#ifdef ASE_TRANSMISSION
					float _TransmissionShadow;
				#endif
				#ifdef ASE_TRANSLUCENCY
					float _TransStrength;
					float _TransNormal;
					float _TransScattering;
					float _TransDirect;
					float _TransAmbient;
					float _TransShadow;
				#endif
				#ifdef ASE_TESSELLATION
					float _TessPhongStrength;
					float _TessValue;
					float _TessMin;
					float _TessMax;
					float _TessEdgeLength;
					float _TessMaxDisp;
				#endif

				uniform float _RippleTexScale;
				uniform float _RippleFakeLightIntensityOffset;
				uniform float _NightRippleFakeLightOffset;
				uniform float _NdotLOffset;
				uniform float4 _HeatColor1;
				uniform float4 _HeatColor2;
				uniform float3 _Temperature;
				uniform float4 _HeatSize;
				uniform float4 _HeatCenter;
				uniform float _HeatTemp;
				uniform float _DropsSpec;
				uniform float _USERAIN;
				uniform float USEHEAT;
				uniform float _HeatVisible;
				uniform float _StencilType;
				uniform sampler2D _Base;
				uniform float4 _Base_ST;
				uniform float3 _AlbedoColorCorrection;
				uniform float3 _MaskRColor;
				uniform float _MaskRIntensity;
				uniform sampler2D _PackedMasksRGBA;
				uniform float4 _PackedMasksRGBA_ST;
				uniform float3 _MaskGColor;
				uniform float _MaskGIntensity;
				uniform float3 _MaskBColor;
				uniform float _MaskBIntensity;
				uniform float3 _MaskAColor;
				uniform float _MaskAIntensity;
				float4 _PackedMasksRGBA_TexelSize;
				uniform float _HeightMapStrength;
				uniform sampler2D _BumpMap;
				uniform float4 _BumpMap_ST;
				uniform float _NormalIntensity;
				uniform sampler2D _ORM;
				uniform float4 _ORM_ST;
				uniform float _MetallicMult;
				uniform float _MaskRMetallicLevel;
				uniform float _MaskGMetallicLevel;
				uniform float _MaskBMetallicLevel;
				uniform float _MaskAMetallicLevel;
				uniform float _MaskRRoughLevel;
				uniform float _MaskGRoughLevel;
				uniform float _MaskBRoughLevel;
				uniform float _MaskARoughLevel;
				uniform float _Smoothness;


				float3 CombineSamplesSharp128_g13( float S0, float S1, float S2, float Strength )
				{
					{
					    float3 va = float3( 0.13, 0, ( S1 - S0 ) * Strength );
					    float3 vb = float3( 0, 0.13, ( S2 - S0 ) * Strength );
					    return normalize( cross( va, vb ) );
					}
				}
				
				float3 CombineSamplesSharp128_g14( float S0, float S1, float S2, float Strength )
				{
					{
					    float3 va = float3( 0.13, 0, ( S1 - S0 ) * Strength );
					    float3 vb = float3( 0, 0.13, ( S2 - S0 ) * Strength );
					    return normalize( cross( va, vb ) );
					}
				}
				
				float3 CombineSamplesSharp128_g15( float S0, float S1, float S2, float Strength )
				{
					{
					    float3 va = float3( 0.13, 0, ( S1 - S0 ) * Strength );
					    float3 vb = float3( 0, 0.13, ( S2 - S0 ) * Strength );
					    return normalize( cross( va, vb ) );
					}
				}
				
				float3 CombineSamplesSharp128_g16( float S0, float S1, float S2, float Strength )
				{
					{
					    float3 va = float3( 0.13, 0, ( S1 - S0 ) * Strength );
					    float3 vb = float3( 0, 0.13, ( S2 - S0 ) * Strength );
					    return normalize( cross( va, vb ) );
					}
				}
				

				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					o.ase_texcoord6.xy = v.texcoord.xyzw.xy;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord6.zw = 0;

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

					float3 positionWS = mul( unity_ObjectToWorld, v.vertex ).xyz;
					half3 normalWS = UnityObjectToWorldNormal( v.normal );
					half3 tangentWS = UnityObjectToWorldDir( v.tangent.xyz );

					o.pos = UnityObjectToClipPos( v.vertex );
					o.worldPos.xyz = positionWS;
					o.normalWS = normalWS;
					o.tangentWS = half4( tangentWS, v.tangent.w );

					o.ambientOrLightmapUV = 0;
					#ifdef LIGHTMAP_ON
						o.ambientOrLightmapUV.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					#elif UNITY_SHOULD_SAMPLE_SH
						#ifdef VERTEXLIGHT_ON
							o.ambientOrLightmapUV.rgb += Shade4PointLights(
								unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
								unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
								unity_4LightAtten0, positionWS, normalWS );
						#endif
						o.ambientOrLightmapUV.rgb = ShadeSHPerVertex( normalWS, o.ambientOrLightmapUV.rgb );
					#endif
					#ifdef DYNAMICLIGHTMAP_ON
						o.ambientOrLightmapUV.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
					#endif

					#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
						o.tangentWS.zw = v.texcoord.xy;
						o.tangentWS.xy = v.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					#endif

					UNITY_TRANSFER_LIGHTING(o, v.texcoord1.xy);
					#if defined( ASE_FOG )
						UNITY_TRANSFER_FOG_COMBINED_WITH_WORLD_POS( o, o.pos );
					#endif
					return o;
				}

				#if defined(ASE_TESSELLATION)
				struct VertexControl
				{
					float4 vertex : INTERNALTESSPOS;
					half4 tangent : TANGENT;
					half3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct TessellationFactors
				{
					float edge[3] : SV_TessFactor;
					float inside : SV_InsideTessFactor;
				};

				VertexControl vert ( appdata v )
				{
					VertexControl o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					o.vertex = v.vertex;
					o.tangent = v.tangent;
					o.normal = v.normal;
					o.texcoord = v.texcoord;
					o.texcoord1 = v.texcoord1;
					o.texcoord2 = v.texcoord2;
					
					return o;
				}

				TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
				{
					TessellationFactors o;
					float4 tf = 1;
					float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
					float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
					#if defined(ASE_FIXED_TESSELLATION)
					tf = FixedTess( tessValue );
					#elif defined(ASE_DISTANCE_TESSELLATION)
					tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, UNITY_MATRIX_M, _WorldSpaceCameraPos );
					#elif defined(ASE_LENGTH_TESSELLATION)
					tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams );
					#elif defined(ASE_LENGTH_CULL_TESSELLATION)
					tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
					#endif
					o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
					return o;
				}

				[domain("tri")]
				[partitioning("fractional_odd")]
				[outputtopology("triangle_cw")]
				[patchconstantfunc("TessellationFunction")]
				[outputcontrolpoints(3)]
				VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
				{
				   return patch[id];
				}

				[domain("tri")]
				v2f DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
				{
					appdata o = (appdata) 0;
					o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
					o.tangent = patch[0].tangent * bary.x + patch[1].tangent * bary.y + patch[2].tangent * bary.z;
					o.normal = patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z;
					o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
					o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
					o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
					
					#if defined(ASE_PHONG_TESSELLATION)
					float3 pp[3];
					for (int i = 0; i < 3; ++i)
						pp[i] = o.vertex.xyz - patch[i].normal * (dot(o.vertex.xyz, patch[i].normal) - dot(patch[i].vertex.xyz, patch[i].normal));
					float phongStrength = _TessPhongStrength;
					o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
					#endif
					UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
					return VertexFunction(o);
				}
				#else
				v2f vert ( appdata v )
				{
					return VertexFunction( v );
				}
				#endif

				half4 frag( v2f IN 
							#if defined( ASE_DEPTH_WRITE_ON )
								, out float outputDepth : SV_Depth
							#endif
							) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(IN);

					#ifdef LOD_FADE_CROSSFADE
						UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
					#endif

					#if defined(ASE_LIGHTING_SIMPLE)
						SurfaceOutput o = (SurfaceOutput)0;
					#else
						#if defined(_SPECULAR_SETUP)
							SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
						#else
							SurfaceOutputStandard o = (SurfaceOutputStandard)0;
						#endif
					#endif

					half atten;
					{
						#if defined( ASE_RECEIVE_SHADOWS )
							UNITY_LIGHT_ATTENUATION( temp, IN, IN.worldPos.xyz )
							atten = temp;
						#else
							atten = 1;
						#endif
					}

					float3 PositionWS = IN.worldPos.xyz;
					half3 ViewDirWS = normalize( UnityWorldSpaceViewDir( PositionWS ) );
					float4 ScreenPosNorm = float4( IN.pos.xy * ( _ScreenParams.zw - 1.0 ), IN.pos.zw );
					float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, IN.pos.z ) * IN.pos.w;
					float4 ScreenPos = ComputeScreenPos( ClipPos );
					half3 NormalWS = IN.normalWS;
					half3 TangentWS = IN.tangentWS.xyz;
					half3 BitangentWS = cross( IN.normalWS, IN.tangentWS.xyz ) * IN.tangentWS.w * unity_WorldTransformParams.w;
					half3 LightAtten = atten;

					#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
						float2 sampleCoords = (IN.tangentWS.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
						NormalWS = UnityObjectToWorldNormal(normalize(tex2D(_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
						TangentWS = -cross(unity_ObjectToWorld._13_23_33, NormalWS);
						BitangentWS = cross(NormalWS, -TangentWS);
					#endif

					float2 uv_Base = IN.ase_texcoord6.xy * _Base_ST.xy + _Base_ST.zw;
					float4 tex2DNode13 = tex2D( _Base, uv_Base );
					#ifdef _USECOLORCORRECTION_ON
					float3 staticSwitch90 = ( _AlbedoColorCorrection * tex2DNode13.rgb );
					#else
					float3 staticSwitch90 = tex2DNode13.rgb;
					#endif
					float2 uv_PackedMasksRGBA = IN.ase_texcoord6.xy * _PackedMasksRGBA_ST.xy + _PackedMasksRGBA_ST.zw;
					float4 tex2DNode114 = tex2D( _PackedMasksRGBA, uv_PackedMasksRGBA );
					#ifdef _USERASCOLORMASK_ON
					float staticSwitch115 = ( _MaskRIntensity * tex2DNode114.r );
					#else
					float staticSwitch115 = 0.0;
					#endif
					float3 lerpResult284 = lerp( tex2D( _Base, uv_Base ).rgb , _MaskRColor , staticSwitch115);
					#ifdef _USEGASCOLORMASK_ON
					float staticSwitch118 = ( _MaskGIntensity * tex2DNode114.g );
					#else
					float staticSwitch118 = 0.0;
					#endif
					float3 lerpResult285 = lerp( lerpResult284 , _MaskGColor , staticSwitch118);
					#ifdef _USEBASCOLORMASK_ON
					float staticSwitch116 = ( _MaskBIntensity * tex2DNode114.b );
					#else
					float staticSwitch116 = 0.0;
					#endif
					float3 lerpResult286 = lerp( lerpResult285 , _MaskBColor , staticSwitch116);
					#ifdef _USEAASCOLORMASK_ON
					float staticSwitch117 = ( _MaskAIntensity * tex2DNode114.a );
					#else
					float staticSwitch117 = 0.0;
					#endif
					float3 lerpResult287 = lerp( lerpResult286 , _MaskAColor , staticSwitch117);
					#ifdef _USECOLORMASK_ON
					float3 staticSwitch135 = lerpResult287;
					#else
					float3 staticSwitch135 = staticSwitch90;
					#endif
					
					float3 _FakeNormal = float3(0,0,1);
					float localCalculateUVsSharp110_g13 = ( 0.0 );
					float2 temp_output_85_0_g13 = uv_PackedMasksRGBA;
					float2 UV110_g13 = temp_output_85_0_g13;
					float4 TexelSize110_g13 = _PackedMasksRGBA_TexelSize;
					float2 UV0110_g13 = float2( 0,0 );
					float2 UV1110_g13 = float2( 0,0 );
					float2 UV2110_g13 = float2( 0,0 );
					{
					{
					    UV110_g13.y -= TexelSize110_g13.y * 0.5;
					    UV0110_g13 = UV110_g13;
					    UV1110_g13 = UV110_g13 + float2( TexelSize110_g13.x, 0 );
					    UV2110_g13 = UV110_g13 + float2( 0, TexelSize110_g13.y );
					}
					}
					float4 break134_g13 = tex2D( _PackedMasksRGBA, UV0110_g13 );
					float S0128_g13 = break134_g13.r;
					float4 break136_g13 = tex2D( _PackedMasksRGBA, UV1110_g13 );
					float S1128_g13 = break136_g13.r;
					float4 break138_g13 = tex2D( _PackedMasksRGBA, UV2110_g13 );
					float S2128_g13 = break138_g13.r;
					float temp_output_91_0_g13 = _HeightMapStrength;
					float Strength128_g13 = temp_output_91_0_g13;
					float3 localCombineSamplesSharp128_g13 = CombineSamplesSharp128_g13( S0128_g13 , S1128_g13 , S2128_g13 , Strength128_g13 );
					#ifdef _RISHEIGHT_ON
					float3 staticSwitch120 = localCombineSamplesSharp128_g13;
					#else
					float3 staticSwitch120 = _FakeNormal;
					#endif
					float localCalculateUVsSharp110_g14 = ( 0.0 );
					float2 temp_output_85_0_g14 = uv_PackedMasksRGBA;
					float2 UV110_g14 = temp_output_85_0_g14;
					float4 TexelSize110_g14 = _PackedMasksRGBA_TexelSize;
					float2 UV0110_g14 = float2( 0,0 );
					float2 UV1110_g14 = float2( 0,0 );
					float2 UV2110_g14 = float2( 0,0 );
					{
					{
					    UV110_g14.y -= TexelSize110_g14.y * 0.5;
					    UV0110_g14 = UV110_g14;
					    UV1110_g14 = UV110_g14 + float2( TexelSize110_g14.x, 0 );
					    UV2110_g14 = UV110_g14 + float2( 0, TexelSize110_g14.y );
					}
					}
					float4 break134_g14 = tex2D( _PackedMasksRGBA, UV0110_g14 );
					float S0128_g14 = break134_g14.g;
					float4 break136_g14 = tex2D( _PackedMasksRGBA, UV1110_g14 );
					float S1128_g14 = break136_g14.g;
					float4 break138_g14 = tex2D( _PackedMasksRGBA, UV2110_g14 );
					float S2128_g14 = break138_g14.g;
					float temp_output_91_0_g14 = _HeightMapStrength;
					float Strength128_g14 = temp_output_91_0_g14;
					float3 localCombineSamplesSharp128_g14 = CombineSamplesSharp128_g14( S0128_g14 , S1128_g14 , S2128_g14 , Strength128_g14 );
					#ifdef _GISHEIGHT_ON
					float3 staticSwitch119 = localCombineSamplesSharp128_g14;
					#else
					float3 staticSwitch119 = _FakeNormal;
					#endif
					float localCalculateUVsSharp110_g15 = ( 0.0 );
					float2 temp_output_85_0_g15 = uv_PackedMasksRGBA;
					float2 UV110_g15 = temp_output_85_0_g15;
					float4 TexelSize110_g15 = _PackedMasksRGBA_TexelSize;
					float2 UV0110_g15 = float2( 0,0 );
					float2 UV1110_g15 = float2( 0,0 );
					float2 UV2110_g15 = float2( 0,0 );
					{
					{
					    UV110_g15.y -= TexelSize110_g15.y * 0.5;
					    UV0110_g15 = UV110_g15;
					    UV1110_g15 = UV110_g15 + float2( TexelSize110_g15.x, 0 );
					    UV2110_g15 = UV110_g15 + float2( 0, TexelSize110_g15.y );
					}
					}
					float4 break134_g15 = tex2D( _PackedMasksRGBA, UV0110_g15 );
					float S0128_g15 = break134_g15.b;
					float4 break136_g15 = tex2D( _PackedMasksRGBA, UV1110_g15 );
					float S1128_g15 = break136_g15.b;
					float4 break138_g15 = tex2D( _PackedMasksRGBA, UV2110_g15 );
					float S2128_g15 = break138_g15.b;
					float temp_output_91_0_g15 = _HeightMapStrength;
					float Strength128_g15 = temp_output_91_0_g15;
					float3 localCombineSamplesSharp128_g15 = CombineSamplesSharp128_g15( S0128_g15 , S1128_g15 , S2128_g15 , Strength128_g15 );
					#ifdef _BISHEIGHT_ON
					float3 staticSwitch121 = localCombineSamplesSharp128_g15;
					#else
					float3 staticSwitch121 = _FakeNormal;
					#endif
					float localCalculateUVsSharp110_g16 = ( 0.0 );
					float2 temp_output_85_0_g16 = uv_PackedMasksRGBA;
					float2 UV110_g16 = temp_output_85_0_g16;
					float4 TexelSize110_g16 = _PackedMasksRGBA_TexelSize;
					float2 UV0110_g16 = float2( 0,0 );
					float2 UV1110_g16 = float2( 0,0 );
					float2 UV2110_g16 = float2( 0,0 );
					{
					{
					    UV110_g16.y -= TexelSize110_g16.y * 0.5;
					    UV0110_g16 = UV110_g16;
					    UV1110_g16 = UV110_g16 + float2( TexelSize110_g16.x, 0 );
					    UV2110_g16 = UV110_g16 + float2( 0, TexelSize110_g16.y );
					}
					}
					float4 break134_g16 = tex2D( _PackedMasksRGBA, UV0110_g16 );
					float S0128_g16 = break134_g16.a;
					float4 break136_g16 = tex2D( _PackedMasksRGBA, UV1110_g16 );
					float S1128_g16 = break136_g16.a;
					float4 break138_g16 = tex2D( _PackedMasksRGBA, UV2110_g16 );
					float S2128_g16 = break138_g16.a;
					float temp_output_91_0_g16 = _HeightMapStrength;
					float Strength128_g16 = temp_output_91_0_g16;
					float3 localCombineSamplesSharp128_g16 = CombineSamplesSharp128_g16( S0128_g16 , S1128_g16 , S2128_g16 , Strength128_g16 );
					#ifdef _AISHEIGHT_ON
					float3 staticSwitch122 = localCombineSamplesSharp128_g16;
					#else
					float3 staticSwitch122 = _FakeNormal;
					#endif
					float2 uv_BumpMap = IN.ase_texcoord6.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
					
					float2 uv_ORM = IN.ase_texcoord6.xy * _ORM_ST.xy + _ORM_ST.zw;
					float4 tex2DNode11 = tex2D( _ORM, uv_ORM );
					float4 tex2DNode290 = tex2D( _ORM, uv_ORM );
					float lerpResult273 = lerp( tex2DNode290.b , _MaskRMetallicLevel , staticSwitch115);
					float lerpResult274 = lerp( lerpResult273 , _MaskGMetallicLevel , staticSwitch118);
					float lerpResult275 = lerp( lerpResult274 , _MaskBMetallicLevel , staticSwitch116);
					float lerpResult276 = lerp( lerpResult275 , _MaskAMetallicLevel , staticSwitch117);
					#ifdef _USEMASKMETALLIC_ON
					float staticSwitch282 = lerpResult276;
					#else
					float staticSwitch282 = saturate( ( tex2DNode11.b * _MetallicMult ) );
					#endif
					
					float lerpResult295 = lerp( tex2DNode290.g , _MaskRRoughLevel , staticSwitch115);
					float lerpResult296 = lerp( lerpResult295 , _MaskGRoughLevel , staticSwitch118);
					float lerpResult297 = lerp( lerpResult296 , _MaskBRoughLevel , staticSwitch116);
					float lerpResult298 = lerp( lerpResult297 , _MaskARoughLevel , staticSwitch117);
					#ifdef _USEMASKROUGHNESS_ON
					float staticSwitch300 = lerpResult298;
					#else
					float staticSwitch300 = tex2DNode11.g;
					#endif
					

					o.Albedo = staticSwitch135;
					o.Normal = BlendNormals( BlendNormals( BlendNormals( staticSwitch120 , staticSwitch119 ) , BlendNormals( staticSwitch121 , staticSwitch122 ) ) , UnpackScaleNormal( tex2D( _BumpMap, uv_BumpMap ), _NormalIntensity ) );

					half3 Specular = half3( 0, 0, 0 );
					half Metallic = staticSwitch282;
					half Smoothness = saturate( ( ( 1.0 - staticSwitch300 ) * _Smoothness ) );
					half Occlusion = tex2DNode11.r;

					#if defined(ASE_LIGHTING_SIMPLE)
						o.Specular = Specular.x;
						o.Gloss = Smoothness;
					#else
						#if defined(_SPECULAR_SETUP)
							o.Specular = Specular;
						#else
							o.Metallic = Metallic;
						#endif
						o.Occlusion = Occlusion;
						o.Smoothness = Smoothness;
					#endif

					o.Emission = half3( 0, 0, 0 );
					o.Alpha = 1;
					half AlphaClipThreshold = 0.5;
					half AlphaClipThresholdShadow = 0.5;
					half3 BakedGI = 0;
					half3 Transmission = 1;
					half3 Translucency = 1;

					#if defined( ASE_DEPTH_WRITE_ON )
						float DeviceDepth = IN.pos.z;
					#endif

					#ifdef _ALPHATEST_ON
						clip( o.Alpha - AlphaClipThreshold );
					#endif

					#if defined( ASE_CHANGES_WORLD_POS )
					{
						#if defined( ASE_RECEIVE_SHADOWS )
							UNITY_LIGHT_ATTENUATION( temp, IN, PositionWS )
							LightAtten = temp;
						#else
							LightAtten = 1;
						#endif
					}
					#endif

					#if ( ASE_FRAGMENT_NORMAL == 0 )
						o.Normal = normalize( o.Normal.x * TangentWS + o.Normal.y * BitangentWS + o.Normal.z * NormalWS );
					#elif ( ASE_FRAGMENT_NORMAL == 1 )
						o.Normal = UnityObjectToWorldNormal( o.Normal );
					#elif ( ASE_FRAGMENT_NORMAL == 2 )
						// @diogo: already in world-space; do nothing
					#endif

					#if defined( ASE_DEPTH_WRITE_ON )
						outputDepth = DeviceDepth;
					#endif

					#ifndef USING_DIRECTIONAL_LIGHT
						half3 lightDir = normalize( UnityWorldSpaceLightDir( PositionWS ) );
					#else
						half3 lightDir = _WorldSpaceLightPos0.xyz;
					#endif

					UnityGI gi;
					UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
					gi.indirect.diffuse = 0;
					gi.indirect.specular = 0;
					gi.light.color = _LightColor0.rgb;
					gi.light.dir = lightDir;

					UnityGIInput giInput;
					UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
					giInput.light = gi.light;
					giInput.worldPos = PositionWS;
					giInput.worldViewDir = ViewDirWS;
					giInput.atten = atten;
					#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
						giInput.lightmapUV = IN.ambientOrLightmapUV;
					#else
						giInput.lightmapUV = 0.0;
					#endif
					#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
						giInput.ambient = IN.ambientOrLightmapUV.rgb;
					#else
						giInput.ambient.rgb = 0.0;
					#endif
					giInput.probeHDR[0] = unity_SpecCube0_HDR;
					giInput.probeHDR[1] = unity_SpecCube1_HDR;
					#if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
						giInput.boxMin[0] = unity_SpecCube0_BoxMin;
					#endif
					#ifdef UNITY_SPECCUBE_BOX_PROJECTION
						giInput.boxMax[0] = unity_SpecCube0_BoxMax;
						giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
						giInput.boxMax[1] = unity_SpecCube1_BoxMax;
						giInput.boxMin[1] = unity_SpecCube1_BoxMin;
						giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
					#endif

					#if defined(ASE_LIGHTING_SIMPLE)
						#if defined(_SPECULAR_SETUP)
							LightingBlinnPhong_GI(o, giInput, gi);
						#else
							LightingLambert_GI(o, giInput, gi);
						#endif
					#else
						#if defined(_SPECULAR_SETUP)
							LightingStandardSpecular_GI(o, giInput, gi);
						#else
							LightingStandard_GI(o, giInput, gi);
						#endif
					#endif

					#ifdef ASE_BAKEDGI
						gi.indirect.diffuse = BakedGI;
					#endif

					#if UNITY_SHOULD_SAMPLE_SH && !defined(LIGHTMAP_ON) && defined(ASE_NO_AMBIENT)
						gi.indirect.diffuse = 0;
					#endif

					half4 c = 0;
					#if defined(ASE_LIGHTING_SIMPLE)
						#if defined(_SPECULAR_SETUP)
							c += LightingBlinnPhong (o, ViewDirWS, gi);
						#else
							c += LightingLambert( o, gi );
						#endif
					#else
						#if defined(_SPECULAR_SETUP)
							c += LightingStandardSpecular (o, ViewDirWS, gi);
						#else
							c += LightingStandard(o, ViewDirWS, gi);
						#endif
					#endif

					#ifdef ASE_TRANSMISSION
					{
						half shadow = _TransmissionShadow;
						#ifdef DIRECTIONAL
							half3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, shadow );
						#else
							half3 lightAtten = gi.light.color;
						#endif
						half3 transmission = max(0 , -dot(o.Normal, gi.light.dir)) * lightAtten * Transmission;
						c.rgb += o.Albedo * transmission;
					}
					#endif

					#ifdef ASE_TRANSLUCENCY
					{
						half shadow = _TransShadow;
						half normal = _TransNormal;
						half scattering = _TransScattering;
						half direct = _TransDirect;
						half ambient = _TransAmbient;
						half strength = _TransStrength;

						#ifdef DIRECTIONAL
							half3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, shadow );
						#else
							half3 lightAtten = gi.light.color;
						#endif
						half3 lightDir = gi.light.dir + o.Normal * normal;
						half transVdotL = pow( saturate( dot( ViewDirWS, -lightDir ) ), scattering );
						half3 translucency = lightAtten * (transVdotL * direct + gi.indirect.diffuse * ambient) * Translucency;
						c.rgb += o.Albedo * translucency * strength;
					}
					#endif

					c.rgb += o.Emission;

					#if defined( ASE_FOG )
						UNITY_EXTRACT_FOG_FROM_WORLD_POS( IN );
						UNITY_APPLY_FOG(_unity_fogCoord, c.rgb);
					#endif
					return c;
				}
			ENDCG
		}

		
		Pass
		{
			
			Name "ForwardAdd"
			Tags { "LightMode"="ForwardAdd" }
			ZWrite Off
			Blend One One

			CGPROGRAM
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#pragma multi_compile_fog
				#define ASE_FOG
				#define ASE_VERSION 19907

				#pragma vertex vert
				#pragma fragment frag
				#pragma skip_variants INSTANCING_ON
				#pragma multi_compile_fwdadd_fullshadows
				#ifndef UNITY_PASS_FORWARDADD
					#define UNITY_PASS_FORWARDADD
				#endif
				#include "HLSLSupport.cginc"
				#if defined( ASE_GEOMETRY ) || defined( ASE_IMPOSTOR )
					#ifndef UNITY_INSTANCED_LOD_FADE
						#define UNITY_INSTANCED_LOD_FADE
					#endif
					#ifndef UNITY_INSTANCED_SH
						#define UNITY_INSTANCED_SH
					#endif
					#ifndef UNITY_INSTANCED_LIGHTMAPSTS
						#define UNITY_INSTANCED_LIGHTMAPSTS
					#endif
				#endif
				#include "UnityShaderVariables.cginc"
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				#if defined( UNITY_INSTANCING_ENABLED ) && defined( ASE_INSTANCED_TERRAIN ) && ( defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL) || defined(_INSTANCEDTERRAINNORMALS_PIXEL) )
					#define ENABLE_TERRAIN_PERPIXEL_NORMAL
				#endif

				#include "UnityStandardUtils.cginc"
				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
				#pragma shader_feature_local _USECOLORMASK_ON
				#pragma shader_feature_local _USECOLORCORRECTION_ON
				#pragma shader_feature_local _USERASCOLORMASK_ON
				#pragma shader_feature_local _USEGASCOLORMASK_ON
				#pragma shader_feature_local _USEBASCOLORMASK_ON
				#pragma shader_feature_local _USEAASCOLORMASK_ON
				#pragma shader_feature_local _RISHEIGHT_ON
				#pragma shader_feature_local _GISHEIGHT_ON
				#pragma shader_feature_local _BISHEIGHT_ON
				#pragma shader_feature_local _AISHEIGHT_ON
				#pragma shader_feature_local _USEMASKMETALLIC_ON
				#pragma shader_feature_local _USEMASKROUGHNESS_ON


				struct appdata
				{
					float4 vertex : POSITION;
					half3 normal : NORMAL;
					half4 tangent : TANGENT;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 worldPos : TEXCOORD0; // xyz = positionWS, w = fogCoord
					half3 normalWS : TEXCOORD1;
					float4 tangentWS : TEXCOORD2; // holds terrainUV ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					UNITY_LIGHTING_COORDS( 3, 4 )
					float4 ase_texcoord5 : TEXCOORD5;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				#ifdef ASE_TRANSMISSION
					float _TransmissionShadow;
				#endif
				#ifdef ASE_TRANSLUCENCY
					float _TransStrength;
					float _TransNormal;
					float _TransScattering;
					float _TransDirect;
					float _TransAmbient;
					float _TransShadow;
				#endif
				#ifdef ASE_TESSELLATION
					float _TessPhongStrength;
					float _TessValue;
					float _TessMin;
					float _TessMax;
					float _TessEdgeLength;
					float _TessMaxDisp;
				#endif

				uniform float _RippleTexScale;
				uniform float _RippleFakeLightIntensityOffset;
				uniform float _NightRippleFakeLightOffset;
				uniform float _NdotLOffset;
				uniform float4 _HeatColor1;
				uniform float4 _HeatColor2;
				uniform float3 _Temperature;
				uniform float4 _HeatSize;
				uniform float4 _HeatCenter;
				uniform float _HeatTemp;
				uniform float _DropsSpec;
				uniform float _USERAIN;
				uniform float USEHEAT;
				uniform float _HeatVisible;
				uniform float _StencilType;
				uniform sampler2D _Base;
				uniform float4 _Base_ST;
				uniform float3 _AlbedoColorCorrection;
				uniform float3 _MaskRColor;
				uniform float _MaskRIntensity;
				uniform sampler2D _PackedMasksRGBA;
				uniform float4 _PackedMasksRGBA_ST;
				uniform float3 _MaskGColor;
				uniform float _MaskGIntensity;
				uniform float3 _MaskBColor;
				uniform float _MaskBIntensity;
				uniform float3 _MaskAColor;
				uniform float _MaskAIntensity;
				float4 _PackedMasksRGBA_TexelSize;
				uniform float _HeightMapStrength;
				uniform sampler2D _BumpMap;
				uniform float4 _BumpMap_ST;
				uniform float _NormalIntensity;
				uniform sampler2D _ORM;
				uniform float4 _ORM_ST;
				uniform float _MetallicMult;
				uniform float _MaskRMetallicLevel;
				uniform float _MaskGMetallicLevel;
				uniform float _MaskBMetallicLevel;
				uniform float _MaskAMetallicLevel;
				uniform float _MaskRRoughLevel;
				uniform float _MaskGRoughLevel;
				uniform float _MaskBRoughLevel;
				uniform float _MaskARoughLevel;
				uniform float _Smoothness;


				float3 CombineSamplesSharp128_g13( float S0, float S1, float S2, float Strength )
				{
					{
					    float3 va = float3( 0.13, 0, ( S1 - S0 ) * Strength );
					    float3 vb = float3( 0, 0.13, ( S2 - S0 ) * Strength );
					    return normalize( cross( va, vb ) );
					}
				}
				
				float3 CombineSamplesSharp128_g14( float S0, float S1, float S2, float Strength )
				{
					{
					    float3 va = float3( 0.13, 0, ( S1 - S0 ) * Strength );
					    float3 vb = float3( 0, 0.13, ( S2 - S0 ) * Strength );
					    return normalize( cross( va, vb ) );
					}
				}
				
				float3 CombineSamplesSharp128_g15( float S0, float S1, float S2, float Strength )
				{
					{
					    float3 va = float3( 0.13, 0, ( S1 - S0 ) * Strength );
					    float3 vb = float3( 0, 0.13, ( S2 - S0 ) * Strength );
					    return normalize( cross( va, vb ) );
					}
				}
				
				float3 CombineSamplesSharp128_g16( float S0, float S1, float S2, float Strength )
				{
					{
					    float3 va = float3( 0.13, 0, ( S1 - S0 ) * Strength );
					    float3 vb = float3( 0, 0.13, ( S2 - S0 ) * Strength );
					    return normalize( cross( va, vb ) );
					}
				}
				

				v2f VertexFunction (appdata v  ) {
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					o.ase_texcoord5.xy = v.texcoord.xyzw.xy;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord5.zw = 0;

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

					float3 positionWS = mul( unity_ObjectToWorld, v.vertex ).xyz;
					half3 normalWS = UnityObjectToWorldNormal( v.normal );
					half3 tangentWS = UnityObjectToWorldDir( v.tangent.xyz );

					o.pos = UnityObjectToClipPos( v.vertex );
					o.worldPos.xyz = positionWS;
					o.normalWS = normalWS;
					o.tangentWS = half4( tangentWS, v.tangent.w );

					UNITY_TRANSFER_LIGHTING(o, v.texcoord1.xy);
					#if defined( ASE_FOG )
						UNITY_TRANSFER_FOG_COMBINED_WITH_WORLD_POS( o, o.pos );
					#endif

					#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
						o.tangentWS.zw = v.texcoord.xy;
						o.tangentWS.xy = v.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					#endif
					return o;
				}

				#if defined(ASE_TESSELLATION)
				struct VertexControl
				{
					float4 vertex : INTERNALTESSPOS;
					half4 tangent : TANGENT;
					half3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct TessellationFactors
				{
					float edge[3] : SV_TessFactor;
					float inside : SV_InsideTessFactor;
				};

				VertexControl vert ( appdata v )
				{
					VertexControl o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					o.vertex = v.vertex;
					o.tangent = v.tangent;
					o.normal = v.normal;
					o.texcoord = v.texcoord;
					o.texcoord1 = v.texcoord1;
					o.texcoord2 = v.texcoord2;
					
					return o;
				}

				TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
				{
					TessellationFactors o;
					float4 tf = 1;
					float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
					float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
					#if defined(ASE_FIXED_TESSELLATION)
					tf = FixedTess( tessValue );
					#elif defined(ASE_DISTANCE_TESSELLATION)
					tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, UNITY_MATRIX_M, _WorldSpaceCameraPos );
					#elif defined(ASE_LENGTH_TESSELLATION)
					tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams );
					#elif defined(ASE_LENGTH_CULL_TESSELLATION)
					tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
					#endif
					o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
					return o;
				}

				[domain("tri")]
				[partitioning("fractional_odd")]
				[outputtopology("triangle_cw")]
				[patchconstantfunc("TessellationFunction")]
				[outputcontrolpoints(3)]
				VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
				{
				   return patch[id];
				}

				[domain("tri")]
				v2f DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
				{
					appdata o = (appdata) 0;
					o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
					o.tangent = patch[0].tangent * bary.x + patch[1].tangent * bary.y + patch[2].tangent * bary.z;
					o.normal = patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z;
					o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
					o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
					o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
					
					#if defined(ASE_PHONG_TESSELLATION)
					float3 pp[3];
					for (int i = 0; i < 3; ++i)
						pp[i] = o.vertex.xyz - patch[i].normal * (dot(o.vertex.xyz, patch[i].normal) - dot(patch[i].vertex.xyz, patch[i].normal));
					float phongStrength = _TessPhongStrength;
					o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
					#endif
					UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
					return VertexFunction(o);
				}
				#else
				v2f vert ( appdata v )
				{
					return VertexFunction( v );
				}
				#endif

				half4 frag ( v2f IN 
					#if defined( ASE_DEPTH_WRITE_ON )
					, out float outputDepth : SV_Depth
					#endif
					) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(IN);

					#ifdef LOD_FADE_CROSSFADE
						UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
					#endif

					#if defined(ASE_LIGHTING_SIMPLE)
						SurfaceOutput o = (SurfaceOutput)0;
					#else
						#if defined(_SPECULAR_SETUP)
							SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
						#else
							SurfaceOutputStandard o = (SurfaceOutputStandard)0;
						#endif
					#endif

					half atten;
					{
						#if defined( ASE_RECEIVE_SHADOWS )
							UNITY_LIGHT_ATTENUATION( temp, IN, IN.worldPos.xyz )
							atten = temp;
						#else
							atten = 1;
						#endif
					}

					float3 PositionWS = IN.worldPos.xyz;
					half3 ViewDirWS = normalize( UnityWorldSpaceViewDir( PositionWS ) );
					float4 ScreenPosNorm = float4( IN.pos.xy * ( _ScreenParams.zw - 1.0 ), IN.pos.zw );
					float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, IN.pos.z ) * IN.pos.w;
					float4 ScreenPos = ComputeScreenPos( ClipPos );
					half3 NormalWS = IN.normalWS;
					half3 TangentWS = IN.tangentWS.xyz;
					half3 BitangentWS = cross( IN.normalWS, IN.tangentWS.xyz ) * IN.tangentWS.w * unity_WorldTransformParams.w;
					half3 LightAtten = atten;

					#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
						float2 sampleCoords = (IN.tangentWS.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
						NormalWS = UnityObjectToWorldNormal(normalize(tex2D(_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
						TangentWS = -cross(unity_ObjectToWorld._13_23_33, NormalWS);
						BitangentWS = cross(NormalWS, -TangentWS);
					#endif

					float2 uv_Base = IN.ase_texcoord5.xy * _Base_ST.xy + _Base_ST.zw;
					float4 tex2DNode13 = tex2D( _Base, uv_Base );
					#ifdef _USECOLORCORRECTION_ON
					float3 staticSwitch90 = ( _AlbedoColorCorrection * tex2DNode13.rgb );
					#else
					float3 staticSwitch90 = tex2DNode13.rgb;
					#endif
					float2 uv_PackedMasksRGBA = IN.ase_texcoord5.xy * _PackedMasksRGBA_ST.xy + _PackedMasksRGBA_ST.zw;
					float4 tex2DNode114 = tex2D( _PackedMasksRGBA, uv_PackedMasksRGBA );
					#ifdef _USERASCOLORMASK_ON
					float staticSwitch115 = ( _MaskRIntensity * tex2DNode114.r );
					#else
					float staticSwitch115 = 0.0;
					#endif
					float3 lerpResult284 = lerp( tex2D( _Base, uv_Base ).rgb , _MaskRColor , staticSwitch115);
					#ifdef _USEGASCOLORMASK_ON
					float staticSwitch118 = ( _MaskGIntensity * tex2DNode114.g );
					#else
					float staticSwitch118 = 0.0;
					#endif
					float3 lerpResult285 = lerp( lerpResult284 , _MaskGColor , staticSwitch118);
					#ifdef _USEBASCOLORMASK_ON
					float staticSwitch116 = ( _MaskBIntensity * tex2DNode114.b );
					#else
					float staticSwitch116 = 0.0;
					#endif
					float3 lerpResult286 = lerp( lerpResult285 , _MaskBColor , staticSwitch116);
					#ifdef _USEAASCOLORMASK_ON
					float staticSwitch117 = ( _MaskAIntensity * tex2DNode114.a );
					#else
					float staticSwitch117 = 0.0;
					#endif
					float3 lerpResult287 = lerp( lerpResult286 , _MaskAColor , staticSwitch117);
					#ifdef _USECOLORMASK_ON
					float3 staticSwitch135 = lerpResult287;
					#else
					float3 staticSwitch135 = staticSwitch90;
					#endif
					
					float3 _FakeNormal = float3(0,0,1);
					float localCalculateUVsSharp110_g13 = ( 0.0 );
					float2 temp_output_85_0_g13 = uv_PackedMasksRGBA;
					float2 UV110_g13 = temp_output_85_0_g13;
					float4 TexelSize110_g13 = _PackedMasksRGBA_TexelSize;
					float2 UV0110_g13 = float2( 0,0 );
					float2 UV1110_g13 = float2( 0,0 );
					float2 UV2110_g13 = float2( 0,0 );
					{
					{
					    UV110_g13.y -= TexelSize110_g13.y * 0.5;
					    UV0110_g13 = UV110_g13;
					    UV1110_g13 = UV110_g13 + float2( TexelSize110_g13.x, 0 );
					    UV2110_g13 = UV110_g13 + float2( 0, TexelSize110_g13.y );
					}
					}
					float4 break134_g13 = tex2D( _PackedMasksRGBA, UV0110_g13 );
					float S0128_g13 = break134_g13.r;
					float4 break136_g13 = tex2D( _PackedMasksRGBA, UV1110_g13 );
					float S1128_g13 = break136_g13.r;
					float4 break138_g13 = tex2D( _PackedMasksRGBA, UV2110_g13 );
					float S2128_g13 = break138_g13.r;
					float temp_output_91_0_g13 = _HeightMapStrength;
					float Strength128_g13 = temp_output_91_0_g13;
					float3 localCombineSamplesSharp128_g13 = CombineSamplesSharp128_g13( S0128_g13 , S1128_g13 , S2128_g13 , Strength128_g13 );
					#ifdef _RISHEIGHT_ON
					float3 staticSwitch120 = localCombineSamplesSharp128_g13;
					#else
					float3 staticSwitch120 = _FakeNormal;
					#endif
					float localCalculateUVsSharp110_g14 = ( 0.0 );
					float2 temp_output_85_0_g14 = uv_PackedMasksRGBA;
					float2 UV110_g14 = temp_output_85_0_g14;
					float4 TexelSize110_g14 = _PackedMasksRGBA_TexelSize;
					float2 UV0110_g14 = float2( 0,0 );
					float2 UV1110_g14 = float2( 0,0 );
					float2 UV2110_g14 = float2( 0,0 );
					{
					{
					    UV110_g14.y -= TexelSize110_g14.y * 0.5;
					    UV0110_g14 = UV110_g14;
					    UV1110_g14 = UV110_g14 + float2( TexelSize110_g14.x, 0 );
					    UV2110_g14 = UV110_g14 + float2( 0, TexelSize110_g14.y );
					}
					}
					float4 break134_g14 = tex2D( _PackedMasksRGBA, UV0110_g14 );
					float S0128_g14 = break134_g14.g;
					float4 break136_g14 = tex2D( _PackedMasksRGBA, UV1110_g14 );
					float S1128_g14 = break136_g14.g;
					float4 break138_g14 = tex2D( _PackedMasksRGBA, UV2110_g14 );
					float S2128_g14 = break138_g14.g;
					float temp_output_91_0_g14 = _HeightMapStrength;
					float Strength128_g14 = temp_output_91_0_g14;
					float3 localCombineSamplesSharp128_g14 = CombineSamplesSharp128_g14( S0128_g14 , S1128_g14 , S2128_g14 , Strength128_g14 );
					#ifdef _GISHEIGHT_ON
					float3 staticSwitch119 = localCombineSamplesSharp128_g14;
					#else
					float3 staticSwitch119 = _FakeNormal;
					#endif
					float localCalculateUVsSharp110_g15 = ( 0.0 );
					float2 temp_output_85_0_g15 = uv_PackedMasksRGBA;
					float2 UV110_g15 = temp_output_85_0_g15;
					float4 TexelSize110_g15 = _PackedMasksRGBA_TexelSize;
					float2 UV0110_g15 = float2( 0,0 );
					float2 UV1110_g15 = float2( 0,0 );
					float2 UV2110_g15 = float2( 0,0 );
					{
					{
					    UV110_g15.y -= TexelSize110_g15.y * 0.5;
					    UV0110_g15 = UV110_g15;
					    UV1110_g15 = UV110_g15 + float2( TexelSize110_g15.x, 0 );
					    UV2110_g15 = UV110_g15 + float2( 0, TexelSize110_g15.y );
					}
					}
					float4 break134_g15 = tex2D( _PackedMasksRGBA, UV0110_g15 );
					float S0128_g15 = break134_g15.b;
					float4 break136_g15 = tex2D( _PackedMasksRGBA, UV1110_g15 );
					float S1128_g15 = break136_g15.b;
					float4 break138_g15 = tex2D( _PackedMasksRGBA, UV2110_g15 );
					float S2128_g15 = break138_g15.b;
					float temp_output_91_0_g15 = _HeightMapStrength;
					float Strength128_g15 = temp_output_91_0_g15;
					float3 localCombineSamplesSharp128_g15 = CombineSamplesSharp128_g15( S0128_g15 , S1128_g15 , S2128_g15 , Strength128_g15 );
					#ifdef _BISHEIGHT_ON
					float3 staticSwitch121 = localCombineSamplesSharp128_g15;
					#else
					float3 staticSwitch121 = _FakeNormal;
					#endif
					float localCalculateUVsSharp110_g16 = ( 0.0 );
					float2 temp_output_85_0_g16 = uv_PackedMasksRGBA;
					float2 UV110_g16 = temp_output_85_0_g16;
					float4 TexelSize110_g16 = _PackedMasksRGBA_TexelSize;
					float2 UV0110_g16 = float2( 0,0 );
					float2 UV1110_g16 = float2( 0,0 );
					float2 UV2110_g16 = float2( 0,0 );
					{
					{
					    UV110_g16.y -= TexelSize110_g16.y * 0.5;
					    UV0110_g16 = UV110_g16;
					    UV1110_g16 = UV110_g16 + float2( TexelSize110_g16.x, 0 );
					    UV2110_g16 = UV110_g16 + float2( 0, TexelSize110_g16.y );
					}
					}
					float4 break134_g16 = tex2D( _PackedMasksRGBA, UV0110_g16 );
					float S0128_g16 = break134_g16.a;
					float4 break136_g16 = tex2D( _PackedMasksRGBA, UV1110_g16 );
					float S1128_g16 = break136_g16.a;
					float4 break138_g16 = tex2D( _PackedMasksRGBA, UV2110_g16 );
					float S2128_g16 = break138_g16.a;
					float temp_output_91_0_g16 = _HeightMapStrength;
					float Strength128_g16 = temp_output_91_0_g16;
					float3 localCombineSamplesSharp128_g16 = CombineSamplesSharp128_g16( S0128_g16 , S1128_g16 , S2128_g16 , Strength128_g16 );
					#ifdef _AISHEIGHT_ON
					float3 staticSwitch122 = localCombineSamplesSharp128_g16;
					#else
					float3 staticSwitch122 = _FakeNormal;
					#endif
					float2 uv_BumpMap = IN.ase_texcoord5.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
					
					float2 uv_ORM = IN.ase_texcoord5.xy * _ORM_ST.xy + _ORM_ST.zw;
					float4 tex2DNode11 = tex2D( _ORM, uv_ORM );
					float4 tex2DNode290 = tex2D( _ORM, uv_ORM );
					float lerpResult273 = lerp( tex2DNode290.b , _MaskRMetallicLevel , staticSwitch115);
					float lerpResult274 = lerp( lerpResult273 , _MaskGMetallicLevel , staticSwitch118);
					float lerpResult275 = lerp( lerpResult274 , _MaskBMetallicLevel , staticSwitch116);
					float lerpResult276 = lerp( lerpResult275 , _MaskAMetallicLevel , staticSwitch117);
					#ifdef _USEMASKMETALLIC_ON
					float staticSwitch282 = lerpResult276;
					#else
					float staticSwitch282 = saturate( ( tex2DNode11.b * _MetallicMult ) );
					#endif
					
					float lerpResult295 = lerp( tex2DNode290.g , _MaskRRoughLevel , staticSwitch115);
					float lerpResult296 = lerp( lerpResult295 , _MaskGRoughLevel , staticSwitch118);
					float lerpResult297 = lerp( lerpResult296 , _MaskBRoughLevel , staticSwitch116);
					float lerpResult298 = lerp( lerpResult297 , _MaskARoughLevel , staticSwitch117);
					#ifdef _USEMASKROUGHNESS_ON
					float staticSwitch300 = lerpResult298;
					#else
					float staticSwitch300 = tex2DNode11.g;
					#endif
					

					o.Albedo = staticSwitch135;
					o.Normal = BlendNormals( BlendNormals( BlendNormals( staticSwitch120 , staticSwitch119 ) , BlendNormals( staticSwitch121 , staticSwitch122 ) ) , UnpackScaleNormal( tex2D( _BumpMap, uv_BumpMap ), _NormalIntensity ) );

					half3 Specular = half3( 0, 0, 0 );
					half Metallic = staticSwitch282;
					half Smoothness = saturate( ( ( 1.0 - staticSwitch300 ) * _Smoothness ) );
					half Occlusion = tex2DNode11.r;

					#if defined(ASE_LIGHTING_SIMPLE)
						o.Specular = Specular.x;
						o.Gloss = Smoothness;
					#else
						#if defined(_SPECULAR_SETUP)
							o.Specular = Specular;
						#else
							o.Metallic = Metallic;
						#endif
						o.Occlusion = Occlusion;
						o.Smoothness = Smoothness;
					#endif

					o.Emission = half3( 0, 0, 0 );
					o.Alpha = 1;
					half AlphaClipThreshold = 0.5;
					half3 Transmission = 1;
					half3 Translucency = 1;

					#if defined( ASE_DEPTH_WRITE_ON )
						float DeviceDepth = IN.pos.z;
					#endif

					#ifdef _ALPHATEST_ON
						clip( o.Alpha - AlphaClipThreshold );
					#endif

					#if defined( ASE_CHANGES_WORLD_POS )
					{
						#if defined( ASE_RECEIVE_SHADOWS )
							UNITY_LIGHT_ATTENUATION( temp, IN, PositionWS )
							LightAtten = temp;
						#else
							LightAtten = 1;
						#endif
					}
					#endif

					#if ( ASE_FRAGMENT_NORMAL == 0 )
						o.Normal = normalize( o.Normal.x * TangentWS + o.Normal.y * BitangentWS + o.Normal.z * NormalWS );
					#elif ( ASE_FRAGMENT_NORMAL == 1 )
						o.Normal = UnityObjectToWorldNormal( o.Normal );
					#elif ( ASE_FRAGMENT_NORMAL == 2 )
						// @diogo: already in world-space; do nothing
					#endif

					#if defined( ASE_DEPTH_WRITE_ON )
						outputDepth = DeviceDepth;
					#endif

					#ifndef USING_DIRECTIONAL_LIGHT
						half3 lightDir = normalize( UnityWorldSpaceLightDir( PositionWS ) );
					#else
						half3 lightDir = _WorldSpaceLightPos0.xyz;
					#endif

					UnityGI gi;
					UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
					gi.indirect.diffuse = 0;
					gi.indirect.specular = 0;
					gi.light.color = _LightColor0.rgb;
					gi.light.dir = lightDir;
					gi.light.color *= atten;

					half4 c = 0;
					#if defined(ASE_LIGHTING_SIMPLE)
						#if defined(_SPECULAR_SETUP)
							c += LightingBlinnPhong (o, ViewDirWS, gi);
						#else
							c += LightingLambert( o, gi );
						#endif
					#else
						#if defined(_SPECULAR_SETUP)
							c += LightingStandardSpecular(o, ViewDirWS, gi);
						#else
							c += LightingStandard(o, ViewDirWS, gi);
						#endif
					#endif

					#ifdef ASE_TRANSMISSION
					{
						half shadow = _TransmissionShadow;
						#ifdef DIRECTIONAL
							half3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, shadow );
						#else
							half3 lightAtten = gi.light.color;
						#endif
						half3 transmission = max(0 , -dot(o.Normal, gi.light.dir)) * lightAtten * Transmission;
						c.rgb += o.Albedo * transmission;
					}
					#endif

					#ifdef ASE_TRANSLUCENCY
					{
						half shadow = _TransShadow;
						half normal = _TransNormal;
						half scattering = _TransScattering;
						half direct = _TransDirect;
						half ambient = _TransAmbient;
						half strength = _TransStrength;

						#ifdef DIRECTIONAL
							half3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, shadow );
						#else
							half3 lightAtten = gi.light.color;
						#endif
						half3 lightDir = gi.light.dir + o.Normal * normal;
						half transVdotL = pow( saturate( dot( ViewDirWS, -lightDir ) ), scattering );
						half3 translucency = lightAtten * (transVdotL * direct + gi.indirect.diffuse * ambient) * Translucency;
						c.rgb += o.Albedo * translucency * strength;
					}
					#endif

					#if defined( ASE_FOG )
						UNITY_EXTRACT_FOG_FROM_WORLD_POS( IN );
						UNITY_APPLY_FOG(_unity_fogCoord, c.rgb);
					#endif
					return c;
				}
			ENDCG
		}

		
		Pass
		{
			
			Name "Deferred"
			Tags { "LightMode"="Deferred" }

			AlphaToMask Off

			CGPROGRAM
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
				#define ASE_VERSION 19907

				#pragma vertex vert
				#pragma fragment frag
				#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
				#pragma multi_compile_prepassfinal
				#ifndef UNITY_PASS_DEFERRED
					#define UNITY_PASS_DEFERRED
				#endif
				#include "HLSLSupport.cginc"
				#if defined( ASE_GEOMETRY ) || defined( ASE_IMPOSTOR )
					#ifndef UNITY_INSTANCED_LOD_FADE
						#define UNITY_INSTANCED_LOD_FADE
					#endif
					#ifndef UNITY_INSTANCED_SH
						#define UNITY_INSTANCED_SH
					#endif
					#ifndef UNITY_INSTANCED_LIGHTMAPSTS
						#define UNITY_INSTANCED_LIGHTMAPSTS
					#endif
				#endif
				#include "UnityShaderVariables.cginc"
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"

				#if defined( UNITY_INSTANCING_ENABLED ) && defined( ASE_INSTANCED_TERRAIN ) && ( defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL) || defined(_INSTANCEDTERRAINNORMALS_PIXEL) )
					#define ENABLE_TERRAIN_PERPIXEL_NORMAL
				#endif

				#include "UnityStandardUtils.cginc"
				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
				#pragma shader_feature_local _USECOLORMASK_ON
				#pragma shader_feature_local _USECOLORCORRECTION_ON
				#pragma shader_feature_local _USERASCOLORMASK_ON
				#pragma shader_feature_local _USEGASCOLORMASK_ON
				#pragma shader_feature_local _USEBASCOLORMASK_ON
				#pragma shader_feature_local _USEAASCOLORMASK_ON
				#pragma shader_feature_local _RISHEIGHT_ON
				#pragma shader_feature_local _GISHEIGHT_ON
				#pragma shader_feature_local _BISHEIGHT_ON
				#pragma shader_feature_local _AISHEIGHT_ON
				#pragma shader_feature_local _USEMASKMETALLIC_ON
				#pragma shader_feature_local _USEMASKROUGHNESS_ON


				struct appdata
				{
					float4 vertex : POSITION;
					half3 normal : NORMAL;
					half4 tangent : TANGENT;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 worldPos : TEXCOORD0; // xyz = positionWS, w = fogCoord
					half3 normalWS : TEXCOORD1;
					float4 tangentWS : TEXCOORD2; // holds terrainUV ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					half4 ambientOrLightmapUV : TEXCOORD3;
					float4 ase_texcoord4 : TEXCOORD4;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				#ifdef LIGHTMAP_ON
				float4 unity_LightmapFade;
				#endif
				half4 unity_Ambient;
				#ifdef ASE_TESSELLATION
					float _TessPhongStrength;
					float _TessValue;
					float _TessMin;
					float _TessMax;
					float _TessEdgeLength;
					float _TessMaxDisp;
				#endif

				uniform float _RippleTexScale;
				uniform float _RippleFakeLightIntensityOffset;
				uniform float _NightRippleFakeLightOffset;
				uniform float _NdotLOffset;
				uniform float4 _HeatColor1;
				uniform float4 _HeatColor2;
				uniform float3 _Temperature;
				uniform float4 _HeatSize;
				uniform float4 _HeatCenter;
				uniform float _HeatTemp;
				uniform float _DropsSpec;
				uniform float _USERAIN;
				uniform float USEHEAT;
				uniform float _HeatVisible;
				uniform float _StencilType;
				uniform sampler2D _Base;
				uniform float4 _Base_ST;
				uniform float3 _AlbedoColorCorrection;
				uniform float3 _MaskRColor;
				uniform float _MaskRIntensity;
				uniform sampler2D _PackedMasksRGBA;
				uniform float4 _PackedMasksRGBA_ST;
				uniform float3 _MaskGColor;
				uniform float _MaskGIntensity;
				uniform float3 _MaskBColor;
				uniform float _MaskBIntensity;
				uniform float3 _MaskAColor;
				uniform float _MaskAIntensity;
				float4 _PackedMasksRGBA_TexelSize;
				uniform float _HeightMapStrength;
				uniform sampler2D _BumpMap;
				uniform float4 _BumpMap_ST;
				uniform float _NormalIntensity;
				uniform sampler2D _ORM;
				uniform float4 _ORM_ST;
				uniform float _MetallicMult;
				uniform float _MaskRMetallicLevel;
				uniform float _MaskGMetallicLevel;
				uniform float _MaskBMetallicLevel;
				uniform float _MaskAMetallicLevel;
				uniform float _MaskRRoughLevel;
				uniform float _MaskGRoughLevel;
				uniform float _MaskBRoughLevel;
				uniform float _MaskARoughLevel;
				uniform float _Smoothness;


				float3 CombineSamplesSharp128_g13( float S0, float S1, float S2, float Strength )
				{
					{
					    float3 va = float3( 0.13, 0, ( S1 - S0 ) * Strength );
					    float3 vb = float3( 0, 0.13, ( S2 - S0 ) * Strength );
					    return normalize( cross( va, vb ) );
					}
				}
				
				float3 CombineSamplesSharp128_g14( float S0, float S1, float S2, float Strength )
				{
					{
					    float3 va = float3( 0.13, 0, ( S1 - S0 ) * Strength );
					    float3 vb = float3( 0, 0.13, ( S2 - S0 ) * Strength );
					    return normalize( cross( va, vb ) );
					}
				}
				
				float3 CombineSamplesSharp128_g15( float S0, float S1, float S2, float Strength )
				{
					{
					    float3 va = float3( 0.13, 0, ( S1 - S0 ) * Strength );
					    float3 vb = float3( 0, 0.13, ( S2 - S0 ) * Strength );
					    return normalize( cross( va, vb ) );
					}
				}
				
				float3 CombineSamplesSharp128_g16( float S0, float S1, float S2, float Strength )
				{
					{
					    float3 va = float3( 0.13, 0, ( S1 - S0 ) * Strength );
					    float3 vb = float3( 0, 0.13, ( S2 - S0 ) * Strength );
					    return normalize( cross( va, vb ) );
					}
				}
				

				v2f VertexFunction (appdata v  ) {
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					o.ase_texcoord4.xy = v.texcoord.xyzw.xy;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord4.zw = 0;

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

					float3 positionWS = mul( unity_ObjectToWorld, v.vertex ).xyz;
					half3 normalWS = UnityObjectToWorldNormal( v.normal );
					half3 tangentWS = UnityObjectToWorldDir( v.tangent.xyz );

					o.pos = UnityObjectToClipPos( v.vertex );
					o.worldPos.xyz = positionWS;
					o.normalWS = normalWS;
					o.tangentWS = half4( tangentWS, v.tangent.w );

					o.ambientOrLightmapUV = 0;
					#ifdef LIGHTMAP_ON
						o.ambientOrLightmapUV.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					#elif UNITY_SHOULD_SAMPLE_SH
						#ifdef VERTEXLIGHT_ON
							o.ambientOrLightmapUV.rgb += Shade4PointLights(
								unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
								unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
								unity_4LightAtten0, positionWS, normalWS );
						#endif
						o.ambientOrLightmapUV.rgb = ShadeSHPerVertex( normalWS, o.ambientOrLightmapUV.rgb );
					#endif
					#ifdef DYNAMICLIGHTMAP_ON
						o.ambientOrLightmapUV.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
					#endif

					#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
						o.tangentWS.zw = v.texcoord.xy;
						o.tangentWS.xy = v.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					#endif
					return o;
				}

				#if defined(ASE_TESSELLATION)
				struct VertexControl
				{
					float4 vertex : INTERNALTESSPOS;
					half4 tangent : TANGENT;
					half3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct TessellationFactors
				{
					float edge[3] : SV_TessFactor;
					float inside : SV_InsideTessFactor;
				};

				VertexControl vert ( appdata v )
				{
					VertexControl o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					o.vertex = v.vertex;
					o.tangent = v.tangent;
					o.normal = v.normal;
					o.texcoord = v.texcoord;
					o.texcoord1 = v.texcoord1;
					o.texcoord2 = v.texcoord2;
					
					return o;
				}

				TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
				{
					TessellationFactors o;
					float4 tf = 1;
					float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
					float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
					#if defined(ASE_FIXED_TESSELLATION)
					tf = FixedTess( tessValue );
					#elif defined(ASE_DISTANCE_TESSELLATION)
					tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, UNITY_MATRIX_M, _WorldSpaceCameraPos );
					#elif defined(ASE_LENGTH_TESSELLATION)
					tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams );
					#elif defined(ASE_LENGTH_CULL_TESSELLATION)
					tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
					#endif
					o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
					return o;
				}

				[domain("tri")]
				[partitioning("fractional_odd")]
				[outputtopology("triangle_cw")]
				[patchconstantfunc("TessellationFunction")]
				[outputcontrolpoints(3)]
				VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
				{
				   return patch[id];
				}

				[domain("tri")]
				v2f DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
				{
					appdata o = (appdata) 0;
					o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
					o.tangent = patch[0].tangent * bary.x + patch[1].tangent * bary.y + patch[2].tangent * bary.z;
					o.normal = patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z;
					o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
					o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
					o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
					
					#if defined(ASE_PHONG_TESSELLATION)
					float3 pp[3];
					for (int i = 0; i < 3; ++i)
						pp[i] = o.vertex.xyz - patch[i].normal * (dot(o.vertex.xyz, patch[i].normal) - dot(patch[i].vertex.xyz, patch[i].normal));
					float phongStrength = _TessPhongStrength;
					o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
					#endif
					UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
					return VertexFunction(o);
				}
				#else
				v2f vert ( appdata v )
				{
					return VertexFunction( v );
				}
				#endif

				void frag (v2f IN 
					, out half4 outGBuffer0 : SV_Target0
					, out half4 outGBuffer1 : SV_Target1
					, out half4 outGBuffer2 : SV_Target2
					, out half4 outEmission : SV_Target3
					#if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
					, out half4 outShadowMask : SV_Target4
					#endif
					#if defined( ASE_DEPTH_WRITE_ON )
					, out float outputDepth : SV_Depth
					#endif
				)
				{
					UNITY_SETUP_INSTANCE_ID(IN);

					#ifdef LOD_FADE_CROSSFADE
						UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
					#endif

					#if defined(ASE_LIGHTING_SIMPLE)
						SurfaceOutput o = (SurfaceOutput)0;
					#else
						#if defined(_SPECULAR_SETUP)
							SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
						#else
							SurfaceOutputStandard o = (SurfaceOutputStandard)0;
						#endif
					#endif

					float3 PositionWS = IN.worldPos.xyz;
					half3 ViewDirWS = normalize( UnityWorldSpaceViewDir( PositionWS ) );
					float4 ScreenPosNorm = float4( IN.pos.xy * ( _ScreenParams.zw - 1.0 ), IN.pos.zw );
					float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, IN.pos.z ) * IN.pos.w;
					float4 ScreenPos = ComputeScreenPos( ClipPos );
					half3 NormalWS = IN.normalWS;
					half3 TangentWS = IN.tangentWS.xyz;
					half3 BitangentWS = cross( IN.normalWS, IN.tangentWS.xyz ) * IN.tangentWS.w * unity_WorldTransformParams.w;

					#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
						float2 sampleCoords = (IN.tangentWS.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
						NormalWS = UnityObjectToWorldNormal(normalize(tex2D(_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
						TangentWS = -cross(unity_ObjectToWorld._13_23_33, NormalWS);
						BitangentWS = cross(NormalWS, -TangentWS);
					#endif

					float2 uv_Base = IN.ase_texcoord4.xy * _Base_ST.xy + _Base_ST.zw;
					float4 tex2DNode13 = tex2D( _Base, uv_Base );
					#ifdef _USECOLORCORRECTION_ON
					float3 staticSwitch90 = ( _AlbedoColorCorrection * tex2DNode13.rgb );
					#else
					float3 staticSwitch90 = tex2DNode13.rgb;
					#endif
					float2 uv_PackedMasksRGBA = IN.ase_texcoord4.xy * _PackedMasksRGBA_ST.xy + _PackedMasksRGBA_ST.zw;
					float4 tex2DNode114 = tex2D( _PackedMasksRGBA, uv_PackedMasksRGBA );
					#ifdef _USERASCOLORMASK_ON
					float staticSwitch115 = ( _MaskRIntensity * tex2DNode114.r );
					#else
					float staticSwitch115 = 0.0;
					#endif
					float3 lerpResult284 = lerp( tex2D( _Base, uv_Base ).rgb , _MaskRColor , staticSwitch115);
					#ifdef _USEGASCOLORMASK_ON
					float staticSwitch118 = ( _MaskGIntensity * tex2DNode114.g );
					#else
					float staticSwitch118 = 0.0;
					#endif
					float3 lerpResult285 = lerp( lerpResult284 , _MaskGColor , staticSwitch118);
					#ifdef _USEBASCOLORMASK_ON
					float staticSwitch116 = ( _MaskBIntensity * tex2DNode114.b );
					#else
					float staticSwitch116 = 0.0;
					#endif
					float3 lerpResult286 = lerp( lerpResult285 , _MaskBColor , staticSwitch116);
					#ifdef _USEAASCOLORMASK_ON
					float staticSwitch117 = ( _MaskAIntensity * tex2DNode114.a );
					#else
					float staticSwitch117 = 0.0;
					#endif
					float3 lerpResult287 = lerp( lerpResult286 , _MaskAColor , staticSwitch117);
					#ifdef _USECOLORMASK_ON
					float3 staticSwitch135 = lerpResult287;
					#else
					float3 staticSwitch135 = staticSwitch90;
					#endif
					
					float3 _FakeNormal = float3(0,0,1);
					float localCalculateUVsSharp110_g13 = ( 0.0 );
					float2 temp_output_85_0_g13 = uv_PackedMasksRGBA;
					float2 UV110_g13 = temp_output_85_0_g13;
					float4 TexelSize110_g13 = _PackedMasksRGBA_TexelSize;
					float2 UV0110_g13 = float2( 0,0 );
					float2 UV1110_g13 = float2( 0,0 );
					float2 UV2110_g13 = float2( 0,0 );
					{
					{
					    UV110_g13.y -= TexelSize110_g13.y * 0.5;
					    UV0110_g13 = UV110_g13;
					    UV1110_g13 = UV110_g13 + float2( TexelSize110_g13.x, 0 );
					    UV2110_g13 = UV110_g13 + float2( 0, TexelSize110_g13.y );
					}
					}
					float4 break134_g13 = tex2D( _PackedMasksRGBA, UV0110_g13 );
					float S0128_g13 = break134_g13.r;
					float4 break136_g13 = tex2D( _PackedMasksRGBA, UV1110_g13 );
					float S1128_g13 = break136_g13.r;
					float4 break138_g13 = tex2D( _PackedMasksRGBA, UV2110_g13 );
					float S2128_g13 = break138_g13.r;
					float temp_output_91_0_g13 = _HeightMapStrength;
					float Strength128_g13 = temp_output_91_0_g13;
					float3 localCombineSamplesSharp128_g13 = CombineSamplesSharp128_g13( S0128_g13 , S1128_g13 , S2128_g13 , Strength128_g13 );
					#ifdef _RISHEIGHT_ON
					float3 staticSwitch120 = localCombineSamplesSharp128_g13;
					#else
					float3 staticSwitch120 = _FakeNormal;
					#endif
					float localCalculateUVsSharp110_g14 = ( 0.0 );
					float2 temp_output_85_0_g14 = uv_PackedMasksRGBA;
					float2 UV110_g14 = temp_output_85_0_g14;
					float4 TexelSize110_g14 = _PackedMasksRGBA_TexelSize;
					float2 UV0110_g14 = float2( 0,0 );
					float2 UV1110_g14 = float2( 0,0 );
					float2 UV2110_g14 = float2( 0,0 );
					{
					{
					    UV110_g14.y -= TexelSize110_g14.y * 0.5;
					    UV0110_g14 = UV110_g14;
					    UV1110_g14 = UV110_g14 + float2( TexelSize110_g14.x, 0 );
					    UV2110_g14 = UV110_g14 + float2( 0, TexelSize110_g14.y );
					}
					}
					float4 break134_g14 = tex2D( _PackedMasksRGBA, UV0110_g14 );
					float S0128_g14 = break134_g14.g;
					float4 break136_g14 = tex2D( _PackedMasksRGBA, UV1110_g14 );
					float S1128_g14 = break136_g14.g;
					float4 break138_g14 = tex2D( _PackedMasksRGBA, UV2110_g14 );
					float S2128_g14 = break138_g14.g;
					float temp_output_91_0_g14 = _HeightMapStrength;
					float Strength128_g14 = temp_output_91_0_g14;
					float3 localCombineSamplesSharp128_g14 = CombineSamplesSharp128_g14( S0128_g14 , S1128_g14 , S2128_g14 , Strength128_g14 );
					#ifdef _GISHEIGHT_ON
					float3 staticSwitch119 = localCombineSamplesSharp128_g14;
					#else
					float3 staticSwitch119 = _FakeNormal;
					#endif
					float localCalculateUVsSharp110_g15 = ( 0.0 );
					float2 temp_output_85_0_g15 = uv_PackedMasksRGBA;
					float2 UV110_g15 = temp_output_85_0_g15;
					float4 TexelSize110_g15 = _PackedMasksRGBA_TexelSize;
					float2 UV0110_g15 = float2( 0,0 );
					float2 UV1110_g15 = float2( 0,0 );
					float2 UV2110_g15 = float2( 0,0 );
					{
					{
					    UV110_g15.y -= TexelSize110_g15.y * 0.5;
					    UV0110_g15 = UV110_g15;
					    UV1110_g15 = UV110_g15 + float2( TexelSize110_g15.x, 0 );
					    UV2110_g15 = UV110_g15 + float2( 0, TexelSize110_g15.y );
					}
					}
					float4 break134_g15 = tex2D( _PackedMasksRGBA, UV0110_g15 );
					float S0128_g15 = break134_g15.b;
					float4 break136_g15 = tex2D( _PackedMasksRGBA, UV1110_g15 );
					float S1128_g15 = break136_g15.b;
					float4 break138_g15 = tex2D( _PackedMasksRGBA, UV2110_g15 );
					float S2128_g15 = break138_g15.b;
					float temp_output_91_0_g15 = _HeightMapStrength;
					float Strength128_g15 = temp_output_91_0_g15;
					float3 localCombineSamplesSharp128_g15 = CombineSamplesSharp128_g15( S0128_g15 , S1128_g15 , S2128_g15 , Strength128_g15 );
					#ifdef _BISHEIGHT_ON
					float3 staticSwitch121 = localCombineSamplesSharp128_g15;
					#else
					float3 staticSwitch121 = _FakeNormal;
					#endif
					float localCalculateUVsSharp110_g16 = ( 0.0 );
					float2 temp_output_85_0_g16 = uv_PackedMasksRGBA;
					float2 UV110_g16 = temp_output_85_0_g16;
					float4 TexelSize110_g16 = _PackedMasksRGBA_TexelSize;
					float2 UV0110_g16 = float2( 0,0 );
					float2 UV1110_g16 = float2( 0,0 );
					float2 UV2110_g16 = float2( 0,0 );
					{
					{
					    UV110_g16.y -= TexelSize110_g16.y * 0.5;
					    UV0110_g16 = UV110_g16;
					    UV1110_g16 = UV110_g16 + float2( TexelSize110_g16.x, 0 );
					    UV2110_g16 = UV110_g16 + float2( 0, TexelSize110_g16.y );
					}
					}
					float4 break134_g16 = tex2D( _PackedMasksRGBA, UV0110_g16 );
					float S0128_g16 = break134_g16.a;
					float4 break136_g16 = tex2D( _PackedMasksRGBA, UV1110_g16 );
					float S1128_g16 = break136_g16.a;
					float4 break138_g16 = tex2D( _PackedMasksRGBA, UV2110_g16 );
					float S2128_g16 = break138_g16.a;
					float temp_output_91_0_g16 = _HeightMapStrength;
					float Strength128_g16 = temp_output_91_0_g16;
					float3 localCombineSamplesSharp128_g16 = CombineSamplesSharp128_g16( S0128_g16 , S1128_g16 , S2128_g16 , Strength128_g16 );
					#ifdef _AISHEIGHT_ON
					float3 staticSwitch122 = localCombineSamplesSharp128_g16;
					#else
					float3 staticSwitch122 = _FakeNormal;
					#endif
					float2 uv_BumpMap = IN.ase_texcoord4.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
					
					float2 uv_ORM = IN.ase_texcoord4.xy * _ORM_ST.xy + _ORM_ST.zw;
					float4 tex2DNode11 = tex2D( _ORM, uv_ORM );
					float4 tex2DNode290 = tex2D( _ORM, uv_ORM );
					float lerpResult273 = lerp( tex2DNode290.b , _MaskRMetallicLevel , staticSwitch115);
					float lerpResult274 = lerp( lerpResult273 , _MaskGMetallicLevel , staticSwitch118);
					float lerpResult275 = lerp( lerpResult274 , _MaskBMetallicLevel , staticSwitch116);
					float lerpResult276 = lerp( lerpResult275 , _MaskAMetallicLevel , staticSwitch117);
					#ifdef _USEMASKMETALLIC_ON
					float staticSwitch282 = lerpResult276;
					#else
					float staticSwitch282 = saturate( ( tex2DNode11.b * _MetallicMult ) );
					#endif
					
					float lerpResult295 = lerp( tex2DNode290.g , _MaskRRoughLevel , staticSwitch115);
					float lerpResult296 = lerp( lerpResult295 , _MaskGRoughLevel , staticSwitch118);
					float lerpResult297 = lerp( lerpResult296 , _MaskBRoughLevel , staticSwitch116);
					float lerpResult298 = lerp( lerpResult297 , _MaskARoughLevel , staticSwitch117);
					#ifdef _USEMASKROUGHNESS_ON
					float staticSwitch300 = lerpResult298;
					#else
					float staticSwitch300 = tex2DNode11.g;
					#endif
					

					o.Albedo = staticSwitch135;
					o.Normal = BlendNormals( BlendNormals( BlendNormals( staticSwitch120 , staticSwitch119 ) , BlendNormals( staticSwitch121 , staticSwitch122 ) ) , UnpackScaleNormal( tex2D( _BumpMap, uv_BumpMap ), _NormalIntensity ) );

					half3 Specular = half3( 0, 0, 0 );
					half Metallic = staticSwitch282;
					half Smoothness = saturate( ( ( 1.0 - staticSwitch300 ) * _Smoothness ) );
					half Occlusion = tex2DNode11.r;

					#if defined(ASE_LIGHTING_SIMPLE)
						o.Specular = Specular.x;
						o.Gloss = Smoothness;
					#else
						#if defined(_SPECULAR_SETUP)
							o.Specular = Specular;
						#else
							o.Metallic = Metallic;
						#endif
						o.Occlusion = Occlusion;
						o.Smoothness = Smoothness;
					#endif

					o.Emission = half3( 0, 0, 0 );
					o.Alpha = 1;
					half AlphaClipThreshold = 0.5;
					half3 BakedGI = 0;

					#if defined( ASE_DEPTH_WRITE_ON )
						float DeviceDepth = IN.pos.z;
					#endif

					#if ( ASE_FRAGMENT_NORMAL == 0 )
						o.Normal = normalize( o.Normal.x * TangentWS + o.Normal.y * BitangentWS + o.Normal.z * NormalWS );
					#elif ( ASE_FRAGMENT_NORMAL == 1 )
						o.Normal = UnityObjectToWorldNormal( o.Normal );
					#elif ( ASE_FRAGMENT_NORMAL == 2 )
						// @diogo: already in world-space; do nothing
					#endif

					#ifdef _ALPHATEST_ON
						clip( o.Alpha - AlphaClipThreshold );
					#endif

					#if defined( ASE_DEPTH_WRITE_ON )
						outputDepth = DeviceDepth;
					#endif

					#ifndef USING_DIRECTIONAL_LIGHT
						half3 lightDir = normalize( UnityWorldSpaceLightDir( PositionWS ) );
					#else
						half3 lightDir = _WorldSpaceLightPos0.xyz;
					#endif

					UnityGI gi;
					UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
					gi.indirect.diffuse = 0;
					gi.indirect.specular = 0;
					gi.light.color = 0;
					gi.light.dir = half3( 0, 1, 0 );

					UnityGIInput giInput;
					UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
					giInput.light = gi.light;
					giInput.worldPos = PositionWS;
					giInput.worldViewDir = ViewDirWS;
					giInput.atten = 1;
					#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
						giInput.lightmapUV = IN.ambientOrLightmapUV;
					#else
						giInput.lightmapUV = 0.0;
					#endif
					#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
						giInput.ambient = IN.ambientOrLightmapUV.rgb;
					#else
						giInput.ambient.rgb = 0.0;
					#endif
					giInput.probeHDR[0] = unity_SpecCube0_HDR;
					giInput.probeHDR[1] = unity_SpecCube1_HDR;
					#if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
						giInput.boxMin[0] = unity_SpecCube0_BoxMin;
					#endif
					#ifdef UNITY_SPECCUBE_BOX_PROJECTION
						giInput.boxMax[0] = unity_SpecCube0_BoxMax;
						giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
						giInput.boxMax[1] = unity_SpecCube1_BoxMax;
						giInput.boxMin[1] = unity_SpecCube1_BoxMin;
						giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
					#endif

					#if defined(ASE_LIGHTING_SIMPLE)
						#if defined(_SPECULAR_SETUP)
							LightingBlinnPhong_GI(o, giInput, gi);
						#else
							LightingLambert_GI(o, giInput, gi);
						#endif
					#else
						#if defined(_SPECULAR_SETUP)
							LightingStandardSpecular_GI(o, giInput, gi);
						#else
							LightingStandard_GI(o, giInput, gi);
						#endif
					#endif

					#ifdef ASE_BAKEDGI
						gi.indirect.diffuse = BakedGI;
					#endif

					#if UNITY_SHOULD_SAMPLE_SH && !defined(LIGHTMAP_ON) && defined(ASE_NO_AMBIENT)
						gi.indirect.diffuse = 0;
					#endif

					#if defined(ASE_LIGHTING_SIMPLE)
						#if defined(_SPECULAR_SETUP)
							outEmission = LightingBlinnPhong_Deferred( o, ViewDirWS, gi, outGBuffer0, outGBuffer1, outGBuffer2 );
						#else
							outEmission = LightingLambert_Deferred( o, gi, outGBuffer0, outGBuffer1, outGBuffer2 );
						#endif
					#else
						#if defined(_SPECULAR_SETUP)
							outEmission = LightingStandardSpecular_Deferred( o, ViewDirWS, gi, outGBuffer0, outGBuffer1, outGBuffer2 );
						#else
							outEmission = LightingStandard_Deferred( o, ViewDirWS, gi, outGBuffer0, outGBuffer1, outGBuffer2 );
						#endif
					#endif

					#if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
						outShadowMask = UnityGetRawBakedOcclusions( IN.ambientOrLightmapUV.xy, float3( 0, 0, 0 ) );
					#endif
					#ifndef UNITY_HDR_ON
						outEmission.rgb = exp2(-outEmission.rgb);
					#endif
				}
			ENDCG
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }
			Cull Off

			CGPROGRAM
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
				#define ASE_VERSION 19907

				#pragma vertex vert
				#pragma fragment frag
				#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
				#pragma shader_feature EDITOR_VISUALIZATION
				#ifndef UNITY_PASS_META
					#define UNITY_PASS_META
				#endif
				#include "HLSLSupport.cginc"
				#if defined( ASE_GEOMETRY ) || defined( ASE_IMPOSTOR )
					#ifndef UNITY_INSTANCED_LOD_FADE
						#define UNITY_INSTANCED_LOD_FADE
					#endif
					#ifndef UNITY_INSTANCED_SH
						#define UNITY_INSTANCED_SH
					#endif
					#ifndef UNITY_INSTANCED_LIGHTMAPSTS
						#define UNITY_INSTANCED_LIGHTMAPSTS
					#endif
				#endif
				#include "UnityShaderVariables.cginc"
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "UnityMetaPass.cginc"

				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
				#pragma shader_feature_local _USECOLORMASK_ON
				#pragma shader_feature_local _USECOLORCORRECTION_ON
				#pragma shader_feature_local _USERASCOLORMASK_ON
				#pragma shader_feature_local _USEGASCOLORMASK_ON
				#pragma shader_feature_local _USEBASCOLORMASK_ON
				#pragma shader_feature_local _USEAASCOLORMASK_ON


				struct appdata
				{
					float4 vertex : POSITION;
					half3 normal : NORMAL;
					half4 tangent : TANGENT;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					#ifdef EDITOR_VISUALIZATION
						float2 vizUV : TEXCOORD0;
						float4 lightCoord : TEXCOORD1;
					#endif
					float4 ase_texcoord2 : TEXCOORD2;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				#ifdef ASE_TESSELLATION
					float _TessPhongStrength;
					float _TessValue;
					float _TessMin;
					float _TessMax;
					float _TessEdgeLength;
					float _TessMaxDisp;
				#endif

				uniform float _RippleTexScale;
				uniform float _RippleFakeLightIntensityOffset;
				uniform float _NightRippleFakeLightOffset;
				uniform float _NdotLOffset;
				uniform float4 _HeatColor1;
				uniform float4 _HeatColor2;
				uniform float3 _Temperature;
				uniform float4 _HeatSize;
				uniform float4 _HeatCenter;
				uniform float _HeatTemp;
				uniform float _DropsSpec;
				uniform float _USERAIN;
				uniform float USEHEAT;
				uniform float _HeatVisible;
				uniform float _StencilType;
				uniform sampler2D _Base;
				uniform float4 _Base_ST;
				uniform float3 _AlbedoColorCorrection;
				uniform float3 _MaskRColor;
				uniform float _MaskRIntensity;
				uniform sampler2D _PackedMasksRGBA;
				uniform float4 _PackedMasksRGBA_ST;
				uniform float3 _MaskGColor;
				uniform float _MaskGIntensity;
				uniform float3 _MaskBColor;
				uniform float _MaskBIntensity;
				uniform float3 _MaskAColor;
				uniform float _MaskAIntensity;


				
				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					o.ase_texcoord2.xy = v.texcoord.xyzw.xy;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord2.zw = 0;

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

					#ifdef EDITOR_VISUALIZATION
						o.vizUV = 0;
						o.lightCoord = 0;
						if (unity_VisualizationMode == EDITORVIZ_TEXTURE)
							o.vizUV = UnityMetaVizUV(unity_EditorViz_UVIndex, v.texcoord.xy, v.texcoord1.xy, v.texcoord2.xy, unity_EditorViz_Texture_ST);
						else if (unity_VisualizationMode == EDITORVIZ_SHOWLIGHTMASK)
						{
							o.vizUV = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
							o.lightCoord = mul(unity_EditorViz_WorldToLight, mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)));
						}
					#endif

					o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST);
					return o;
				}

				#if defined(ASE_TESSELLATION)
				struct VertexControl
				{
					float4 vertex : INTERNALTESSPOS;
					float4 tangent : TANGENT;
					float3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct TessellationFactors
				{
					float edge[3] : SV_TessFactor;
					float inside : SV_InsideTessFactor;
				};

				VertexControl vert ( appdata v )
				{
					VertexControl o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					o.vertex = v.vertex;
					o.tangent = v.tangent;
					o.normal = v.normal;
					o.texcoord = v.texcoord;
					o.texcoord1 = v.texcoord1;
					o.texcoord2 = v.texcoord2;
					
					return o;
				}

				TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
				{
					TessellationFactors o;
					float4 tf = 1;
					float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
					float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
					#if defined(ASE_FIXED_TESSELLATION)
					tf = FixedTess( tessValue );
					#elif defined(ASE_DISTANCE_TESSELLATION)
					tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, UNITY_MATRIX_M, _WorldSpaceCameraPos );
					#elif defined(ASE_LENGTH_TESSELLATION)
					tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams );
					#elif defined(ASE_LENGTH_CULL_TESSELLATION)
					tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
					#endif
					o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
					return o;
				}

				[domain("tri")]
				[partitioning("fractional_odd")]
				[outputtopology("triangle_cw")]
				[patchconstantfunc("TessellationFunction")]
				[outputcontrolpoints(3)]
				VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
				{
				   return patch[id];
				}

				[domain("tri")]
				v2f DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
				{
					appdata o = (appdata) 0;
					o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
					o.tangent = patch[0].tangent * bary.x + patch[1].tangent * bary.y + patch[2].tangent * bary.z;
					o.normal = patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z;
					o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
					o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
					o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
					
					#if defined(ASE_PHONG_TESSELLATION)
					float3 pp[3];
					for (int i = 0; i < 3; ++i)
						pp[i] = o.vertex.xyz - patch[i].normal * (dot(o.vertex.xyz, patch[i].normal) - dot(patch[i].vertex.xyz, patch[i].normal));
					float phongStrength = _TessPhongStrength;
					o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
					#endif
					UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
					return VertexFunction(o);
				}
				#else
				v2f vert( appdata v )
				{
					return VertexFunction( v );
				}
				#endif

				half4 frag( v2f IN  ) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(IN);

					#ifdef LOD_FADE_CROSSFADE
						UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
					#endif

					#if defined(ASE_LIGHTING_SIMPLE)
						SurfaceOutput o = (SurfaceOutput)0;
					#else
						#if defined(_SPECULAR_SETUP)
							SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
						#else
							SurfaceOutputStandard o = (SurfaceOutputStandard)0;
						#endif
					#endif

					float2 uv_Base = IN.ase_texcoord2.xy * _Base_ST.xy + _Base_ST.zw;
					float4 tex2DNode13 = tex2D( _Base, uv_Base );
					#ifdef _USECOLORCORRECTION_ON
					float3 staticSwitch90 = ( _AlbedoColorCorrection * tex2DNode13.rgb );
					#else
					float3 staticSwitch90 = tex2DNode13.rgb;
					#endif
					float2 uv_PackedMasksRGBA = IN.ase_texcoord2.xy * _PackedMasksRGBA_ST.xy + _PackedMasksRGBA_ST.zw;
					float4 tex2DNode114 = tex2D( _PackedMasksRGBA, uv_PackedMasksRGBA );
					#ifdef _USERASCOLORMASK_ON
					float staticSwitch115 = ( _MaskRIntensity * tex2DNode114.r );
					#else
					float staticSwitch115 = 0.0;
					#endif
					float3 lerpResult284 = lerp( tex2D( _Base, uv_Base ).rgb , _MaskRColor , staticSwitch115);
					#ifdef _USEGASCOLORMASK_ON
					float staticSwitch118 = ( _MaskGIntensity * tex2DNode114.g );
					#else
					float staticSwitch118 = 0.0;
					#endif
					float3 lerpResult285 = lerp( lerpResult284 , _MaskGColor , staticSwitch118);
					#ifdef _USEBASCOLORMASK_ON
					float staticSwitch116 = ( _MaskBIntensity * tex2DNode114.b );
					#else
					float staticSwitch116 = 0.0;
					#endif
					float3 lerpResult286 = lerp( lerpResult285 , _MaskBColor , staticSwitch116);
					#ifdef _USEAASCOLORMASK_ON
					float staticSwitch117 = ( _MaskAIntensity * tex2DNode114.a );
					#else
					float staticSwitch117 = 0.0;
					#endif
					float3 lerpResult287 = lerp( lerpResult286 , _MaskAColor , staticSwitch117);
					#ifdef _USECOLORMASK_ON
					float3 staticSwitch135 = lerpResult287;
					#else
					float3 staticSwitch135 = staticSwitch90;
					#endif
					

					o.Albedo = staticSwitch135;
					o.Normal = half3( 0, 0, 1 );
					o.Emission = half3( 0, 0, 0 );
					o.Alpha = 1;
					half AlphaClipThreshold = 0.5;

					#ifdef _ALPHATEST_ON
						clip( o.Alpha - AlphaClipThreshold );
					#endif

					UnityMetaInput metaIN;
					UNITY_INITIALIZE_OUTPUT(UnityMetaInput, metaIN);
					metaIN.Albedo = o.Albedo;
					metaIN.Emission = o.Emission;
					#ifdef EDITOR_VISUALIZATION
						metaIN.VizUV = IN.vizUV;
						metaIN.LightCoord = IN.lightCoord;
					#endif
					return UnityMetaFragment(metaIN);
				}
				ENDCG
			}

			
			Pass
			{
				
				Name "ShadowCaster"
				Tags { "LightMode"="ShadowCaster" }
				ZWrite On
				ZTest LEqual
				AlphaToMask Off

				CGPROGRAM
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
				#define ASE_VERSION 19907

				#pragma vertex vert
				#pragma fragment frag
				#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
				#pragma multi_compile_shadowcaster
				#ifndef UNITY_PASS_SHADOWCASTER
					#define UNITY_PASS_SHADOWCASTER
				#endif
				#include "HLSLSupport.cginc"
				#if defined( ASE_GEOMETRY ) || defined( ASE_IMPOSTOR )
					#ifndef UNITY_INSTANCED_LOD_FADE
						#define UNITY_INSTANCED_LOD_FADE
					#endif
					#ifndef UNITY_INSTANCED_SH
						#define UNITY_INSTANCED_SH
					#endif
					#ifndef UNITY_INSTANCED_LIGHTMAPSTS
						#define UNITY_INSTANCED_LIGHTMAPSTS
					#endif
				#endif
				#include "UnityShaderVariables.cginc"
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"

				

				struct appdata
				{
					float4 vertex : POSITION;
					half3 normal : NORMAL;
					half4 tangent : TANGENT;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					V2F_SHADOW_CASTER;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				#ifdef UNITY_STANDARD_USE_DITHER_MASK
					sampler3D _DitherMaskLOD;
				#endif
				#ifdef ASE_TESSELLATION
					float _TessPhongStrength;
					float _TessValue;
					float _TessMin;
					float _TessMax;
					float _TessEdgeLength;
					float _TessMaxDisp;
				#endif

				uniform float _RippleTexScale;
				uniform float _RippleFakeLightIntensityOffset;
				uniform float _NightRippleFakeLightOffset;
				uniform float _NdotLOffset;
				uniform float4 _HeatColor1;
				uniform float4 _HeatColor2;
				uniform float3 _Temperature;
				uniform float4 _HeatSize;
				uniform float4 _HeatCenter;
				uniform float _HeatTemp;
				uniform float _DropsSpec;
				uniform float _USERAIN;
				uniform float USEHEAT;
				uniform float _HeatVisible;
				uniform float _StencilType;


				
				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					

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

				#if defined( ASE_IMPOSTOR )
					// Disable "Normal Bias" because we're rendering billboard impostors and there's no vertex normals.
					unity_LightShadowBias.z = 0;
				#endif

					TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
					return o;
				}

				#if defined(ASE_TESSELLATION)
				struct VertexControl
				{
					float4 vertex : INTERNALTESSPOS;
					half4 tangent : TANGENT;
					half3 normal : NORMAL;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct TessellationFactors
				{
					float edge[3] : SV_TessFactor;
					float inside : SV_InsideTessFactor;
				};

				VertexControl vert ( appdata v )
				{
					VertexControl o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					o.vertex = v.vertex;
					o.tangent = v.tangent;
					o.normal = v.normal;
					o.texcoord1 = v.texcoord1;
					o.texcoord2 = v.texcoord2;
					
					return o;
				}

				TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
				{
					TessellationFactors o;
					float4 tf = 1;
					float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
					float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
					#if defined(ASE_FIXED_TESSELLATION)
					tf = FixedTess( tessValue );
					#elif defined(ASE_DISTANCE_TESSELLATION)
					tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, UNITY_MATRIX_M, _WorldSpaceCameraPos );
					#elif defined(ASE_LENGTH_TESSELLATION)
					tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams );
					#elif defined(ASE_LENGTH_CULL_TESSELLATION)
					tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
					#endif
					o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
					return o;
				}

				[domain("tri")]
				[partitioning("fractional_odd")]
				[outputtopology("triangle_cw")]
				[patchconstantfunc("TessellationFunction")]
				[outputcontrolpoints(3)]
				VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
				{
				   return patch[id];
				}

				[domain("tri")]
				v2f DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
				{
					appdata o = (appdata) 0;
					o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
					o.tangent = patch[0].tangent * bary.x + patch[1].tangent * bary.y + patch[2].tangent * bary.z;
					o.normal = patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z;
					o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
					o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
					
					#if defined(ASE_PHONG_TESSELLATION)
					float3 pp[3];
					for (int i = 0; i < 3; ++i)
						pp[i] = o.vertex.xyz - patch[i].normal * (dot(o.vertex.xyz, patch[i].normal) - dot(patch[i].vertex.xyz, patch[i].normal));
					float phongStrength = _TessPhongStrength;
					o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
					#endif
					UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
					return VertexFunction(o);
				}
				#else
				v2f vert( appdata v )
				{
					return VertexFunction( v );
				}
				#endif

				half4 frag( v2f IN 
							#if defined( ASE_DEPTH_WRITE_ON )
								, out float outputDepth : SV_Depth
							#endif
							) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(IN);

					#ifdef LOD_FADE_CROSSFADE
						UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
					#endif

					#if defined(ASE_LIGHTING_SIMPLE)
						SurfaceOutput o = (SurfaceOutput)0;
					#else
						#if defined(_SPECULAR_SETUP)
							SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
						#else
							SurfaceOutputStandard o = (SurfaceOutputStandard)0;
						#endif
						o.Occlusion = 1;
					#endif

					

					o.Normal = half3( 0, 0, 1 );

					o.Alpha = 1;
					half AlphaClipThreshold = 0.5;
					half AlphaClipThresholdShadow = 0.5;

					#if defined( ASE_DEPTH_WRITE_ON )
						float DeviceDepth = IN.pos.z;
					#endif

					#ifdef _ALPHATEST_SHADOW_ON
						if (unity_LightShadowBias.z != 0.0)
							clip(o.Alpha - AlphaClipThresholdShadow);
						#ifdef _ALPHATEST_ON
						else
							clip(o.Alpha - AlphaClipThreshold);
						#endif
					#else
						#ifdef _ALPHATEST_ON
							clip(o.Alpha - AlphaClipThreshold);
						#endif
					#endif

					#ifdef UNITY_STANDARD_USE_DITHER_MASK
						half alphaRef = tex3D(_DitherMaskLOD, float3(IN.pos.xy*0.25,o.Alpha*0.9375)).a;
						clip(alphaRef - 0.01);
					#endif

					#if defined( ASE_DEPTH_WRITE_ON )
						outputDepth = DeviceDepth;
					#endif

					SHADOW_CASTER_FRAGMENT(IN)
				}
			ENDCG
		}

		
		Pass
		{
			
			Name "SceneSelectionPass"
			Tags { "LightMode"="SceneSelectionPass" }

			ZWrite On

			CGPROGRAM
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
				#define ASE_VERSION 19907

				#pragma vertex vert
				#pragma fragment frag
				#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2

				#pragma multi_compile_fwdbase
				#ifndef UNITY_PASS_FORWARDBASE
					#define UNITY_PASS_FORWARDBASE
				#endif
				#include "HLSLSupport.cginc"
				#if defined( ASE_GEOMETRY ) || defined( ASE_IMPOSTOR )
					#ifndef UNITY_INSTANCED_LOD_FADE
						#define UNITY_INSTANCED_LOD_FADE
					#endif
					#ifndef UNITY_INSTANCED_SH
						#define UNITY_INSTANCED_SH
					#endif
					#ifndef UNITY_INSTANCED_LIGHTMAPSTS
						#define UNITY_INSTANCED_LIGHTMAPSTS
					#endif
				#endif
				#include "UnityShaderVariables.cginc"
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				

				int _ObjectId;
				int _PassValue;

				struct appdata
				{
					float4 vertex : POSITION;
					half3 normal : NORMAL;
					half4 tangent : TANGENT;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 worldPos : TEXCOORD0; // xyz = positionWS
					half3 normalWS : TEXCOORD1;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				#ifdef ASE_TESSELLATION
					float _TessPhongStrength;
					float _TessValue;
					float _TessMin;
					float _TessMax;
					float _TessEdgeLength;
					float _TessMaxDisp;
				#endif

				uniform float _RippleTexScale;
				uniform float _RippleFakeLightIntensityOffset;
				uniform float _NightRippleFakeLightOffset;
				uniform float _NdotLOffset;
				uniform float4 _HeatColor1;
				uniform float4 _HeatColor2;
				uniform float3 _Temperature;
				uniform float4 _HeatSize;
				uniform float4 _HeatCenter;
				uniform float _HeatTemp;
				uniform float _DropsSpec;
				uniform float _USERAIN;
				uniform float USEHEAT;
				uniform float _HeatVisible;
				uniform float _StencilType;


				
				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					

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

					float3 positionWS = mul( unity_ObjectToWorld, v.vertex ).xyz;
					half3 normalWS = UnityObjectToWorldNormal( v.normal );

					o.pos = UnityObjectToClipPos( v.vertex );
					o.worldPos.xyz = positionWS;
					o.normalWS = normalWS;
					return o;
				}

				#if defined(ASE_TESSELLATION)
				struct VertexControl
				{
					float4 vertex : INTERNALTESSPOS;
					half3 normal : NORMAL;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct TessellationFactors
				{
					float edge[3] : SV_TessFactor;
					float inside : SV_InsideTessFactor;
				};

				VertexControl vert ( appdata v )
				{
					VertexControl o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					o.vertex = v.vertex;
					o.normal = v.normal;
					
					return o;
				}

				TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
				{
					TessellationFactors o;
					float4 tf = 1;
					float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
					float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
					#if defined(ASE_FIXED_TESSELLATION)
					tf = FixedTess( tessValue );
					#elif defined(ASE_DISTANCE_TESSELLATION)
					tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, UNITY_MATRIX_M, _WorldSpaceCameraPos );
					#elif defined(ASE_LENGTH_TESSELLATION)
					tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams );
					#elif defined(ASE_LENGTH_CULL_TESSELLATION)
					tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
					#endif
					o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
					return o;
				}

				[domain("tri")]
				[partitioning("fractional_odd")]
				[outputtopology("triangle_cw")]
				[patchconstantfunc("TessellationFunction")]
				[outputcontrolpoints(3)]
				VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
				{
				   return patch[id];
				}

				[domain("tri")]
				v2f DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
				{
					appdata o = (appdata) 0;
					o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
					o.normal = patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z;
					
					#if defined(ASE_PHONG_TESSELLATION)
					float3 pp[3];
					for (int i = 0; i < 3; ++i)
						pp[i] = o.vertex.xyz - patch[i].normal * (dot(o.vertex.xyz, patch[i].normal) - dot(patch[i].vertex.xyz, patch[i].normal));
					float phongStrength = _TessPhongStrength;
					o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
					#endif
					UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
					return VertexFunction(o);
				}
				#else
				v2f vert ( appdata v )
				{
					return VertexFunction( v );
				}
				#endif

				half4 frag( v2f IN 
							#if defined( ASE_DEPTH_WRITE_ON )
								, out float outputDepth : SV_Depth
							#endif
							) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(IN);

					#ifdef LOD_FADE_CROSSFADE
						UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
					#endif

					

					half Alpha = 1;
					half AlphaClipThreshold = 0.5;

					#if defined( ASE_DEPTH_WRITE_ON )
						float DeviceDepth = IN.pos.z;
					#endif

					#ifdef _ALPHATEST_ON
						clip( Alpha - AlphaClipThreshold );
					#endif

					#if defined( ASE_DEPTH_WRITE_ON )
						outputDepth = DeviceDepth;
					#endif

					return float4( _ObjectId, _PassValue, 1.0, 1.0 );
				}
			ENDCG
		}

		
		Pass
		{
			
			Name "ScenePickingPass"
			Tags { "LightMode"="ScenePickingPass" }

			ZWrite On

			CGPROGRAM
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
				#define ASE_VERSION 19907

				#pragma vertex vert
				#pragma fragment frag
				#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2

				#pragma multi_compile_fwdbase
				#ifndef UNITY_PASS_FORWARDBASE
					#define UNITY_PASS_FORWARDBASE
				#endif
				#include "HLSLSupport.cginc"
				#if defined( ASE_GEOMETRY ) || defined( ASE_IMPOSTOR )
					#ifndef UNITY_INSTANCED_LOD_FADE
						#define UNITY_INSTANCED_LOD_FADE
					#endif
					#ifndef UNITY_INSTANCED_SH
						#define UNITY_INSTANCED_SH
					#endif
					#ifndef UNITY_INSTANCED_LIGHTMAPSTS
						#define UNITY_INSTANCED_LIGHTMAPSTS
					#endif
				#endif
				#include "UnityShaderVariables.cginc"
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				

				float4 _SelectionID;

				struct appdata
				{
					float4 vertex : POSITION;
					half3 normal : NORMAL;
					half4 tangent : TANGENT;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 worldPos : TEXCOORD0; // xyz = positionWS
					half3 normalWS : TEXCOORD1;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				#ifdef ASE_TESSELLATION
					float _TessPhongStrength;
					float _TessValue;
					float _TessMin;
					float _TessMax;
					float _TessEdgeLength;
					float _TessMaxDisp;
				#endif

				uniform float _RippleTexScale;
				uniform float _RippleFakeLightIntensityOffset;
				uniform float _NightRippleFakeLightOffset;
				uniform float _NdotLOffset;
				uniform float4 _HeatColor1;
				uniform float4 _HeatColor2;
				uniform float3 _Temperature;
				uniform float4 _HeatSize;
				uniform float4 _HeatCenter;
				uniform float _HeatTemp;
				uniform float _DropsSpec;
				uniform float _USERAIN;
				uniform float USEHEAT;
				uniform float _HeatVisible;
				uniform float _StencilType;


				
				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					

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

					float3 positionWS = mul( unity_ObjectToWorld, v.vertex ).xyz;
					half3 normalWS = UnityObjectToWorldNormal( v.normal );

					o.pos = UnityObjectToClipPos( v.vertex );
					o.worldPos.xyz = positionWS;
					o.normalWS = normalWS;
					return o;
				}

				#if defined(ASE_TESSELLATION)
				struct VertexControl
				{
					float4 vertex : INTERNALTESSPOS;
					half3 normal : NORMAL;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct TessellationFactors
				{
					float edge[3] : SV_TessFactor;
					float inside : SV_InsideTessFactor;
				};

				VertexControl vert ( appdata v )
				{
					VertexControl o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					o.vertex = v.vertex;
					o.normal = v.normal;
					
					return o;
				}

				TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
				{
					TessellationFactors o;
					float4 tf = 1;
					float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
					float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
					#if defined(ASE_FIXED_TESSELLATION)
					tf = FixedTess( tessValue );
					#elif defined(ASE_DISTANCE_TESSELLATION)
					tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, UNITY_MATRIX_M, _WorldSpaceCameraPos );
					#elif defined(ASE_LENGTH_TESSELLATION)
					tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams );
					#elif defined(ASE_LENGTH_CULL_TESSELLATION)
					tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
					#endif
					o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
					return o;
				}

				[domain("tri")]
				[partitioning("fractional_odd")]
				[outputtopology("triangle_cw")]
				[patchconstantfunc("TessellationFunction")]
				[outputcontrolpoints(3)]
				VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
				{
				   return patch[id];
				}

				[domain("tri")]
				v2f DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
				{
					appdata o = (appdata) 0;
					o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
					o.normal = patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z;
					
					#if defined(ASE_PHONG_TESSELLATION)
					float3 pp[3];
					for (int i = 0; i < 3; ++i)
						pp[i] = o.vertex.xyz - patch[i].normal * (dot(o.vertex.xyz, patch[i].normal) - dot(patch[i].vertex.xyz, patch[i].normal));
					float phongStrength = _TessPhongStrength;
					o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
					#endif
					UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
					return VertexFunction(o);
				}
				#else
				v2f vert ( appdata v )
				{
					return VertexFunction( v );
				}
				#endif

				half4 frag( v2f IN 
							#if defined( ASE_DEPTH_WRITE_ON )
								, out float outputDepth : SV_Depth
							#endif
							) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(IN);

					#ifdef LOD_FADE_CROSSFADE
						UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
					#endif

					

					half Alpha = 1;
					half AlphaClipThreshold = 0.5;

					#if defined( ASE_DEPTH_WRITE_ON )
						float DeviceDepth = IN.pos.z;
					#endif

					#ifdef _ALPHATEST_ON
						clip( Alpha - AlphaClipThreshold );
					#endif

					#if defined( ASE_DEPTH_WRITE_ON )
						outputDepth = DeviceDepth;
					#endif

					return _SelectionID;
				}
			ENDCG
		}
		
	}
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19907
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;78;-2144,400;Inherit;False;Global;_HeatThermalFactor;_HeatThermalFactor;15;1;[HideInInspector];Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;57;-2144,496;Inherit;False;Global;_ThermalVisionOn;_ThermalVisionOn;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;79;-2576,-432;Inherit;False;Property;_RippleTexScale;Ripple Texture Scale;10;0;Create;False;0;0;0;True;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;80;-2608,-352;Inherit;False;Property;_RippleFakeLightIntensityOffset;Fake Ripple Light Offset;11;0;Create;False;0;0;0;True;0;False;0.7;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;81;-2640,-272;Inherit;False;Property;_NightRippleFakeLightOffset;Fake Night Ripple Light Offset;12;0;Create;False;0;0;0;True;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;82;-2608,-192;Inherit;False;Property;_NdotLOffset;Normal Dot Light Offset;13;0;Create;False;0;0;0;True;0;False;0.4;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;52;-2576,368;Inherit;False;Property;_HeatColor1;Heat Color 1;19;1;[HDR];Create;False;0;0;0;True;0;False;1,0,0,1;1,0,0,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;51;-2576,576;Inherit;False;Property;_HeatColor2;Heat Color 2;20;1;[HDR];Create;False;0;0;0;True;0;False;1,0.34,0,1;1,0.34,0,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.Vector3Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;77;-2608,208;Inherit;False;Property;_Temperature;Temperature Settings;18;0;Create;False;0;0;0;True;0;False;0.1,0.2,0.28;0.1,0.2,0.28;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector4Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;62;-2608,960;Inherit;False;Property;_HeatSize;Heat Size;22;0;Create;False;0;0;0;True;0;False;0.02,0.04,0.02,1;0.02,0.04,0.02,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;61;-2544,784;Inherit;False;Property;_HeatCenter;Heat Center;21;0;Create;False;0;0;0;True;0;False;0,0,0,1;0,0,0,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;60;-2576,1136;Inherit;False;Property;_HeatTemp;Heat Temperature;23;0;Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;50;-2544,-512;Inherit;False;Property;_DropsSpec;Drops Spec;9;1;[Header];Create;False;1;Rain Settings;0;0;True;1;Space(10);False;128;128;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;84;-2608,-32;Inherit;False;Property;_SkinnedMeshMaterial;Skinned Mesh Material;15;1;[HideInInspector];Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;83;-2608,-112;Inherit;False;Property;_USERAIN;Material Effected By Rain;14;1;[Toggle];Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;59;-2576,48;Inherit;False;Property;USEHEAT;Use Metal Heat Glow;16;2;[Header];[Toggle];Create;False;1;Heat Settings;0;0;True;1;Space(10);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;58;-2576,128;Inherit;False;Property;_HeatVisible;Heat Visibility (0-1);17;0;Create;False;0;0;0;True;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;85;-432,80;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;87;-864,64;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;42;-2640,-752;Inherit;False;Property;_StencilType;Stencil Type;0;0;Create;True;0;3;Static;0;Character;1;Hands;2;0;True;1;MaterialEnum(Static, 0, Characters, 1, Hands, 2);False;0;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;44;-2576,-592;Inherit;False;Property;_NormalIntensity;Normal Intensity;8;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;86;-2640,-672;Inherit;False;Property;_Smoothness;Smoothness;6;0;Create;True;0;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;88;-1632,-320;Inherit;False;Property;_AlbedoColorCorrection;Albedo Color Correction;2;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,1;True;False;0;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;106;-1136,-272;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;90;-928,-160;Inherit;False;Property;_UseColorCorrection;Use Color Correction;1;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;135;-400,-160;Inherit;False;Property;_UseColorMask;Use Color Mask;25;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;192;-224,80;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;10;-1904,384;Inherit;True;Property;_BumpMap;Normal Map;7;1;[Normal];Create;False;0;0;0;False;0;False;None;None;True;bump;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.BlendNormalsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;133;-592,-32;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;121;-3408,-1328;Inherit;False;Property;_BIsHeight;B Is Height;40;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;122;-3408,-1232;Inherit;False;Property;_AIsHeight;A Is Height;41;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;243;-4720,-1808;Inherit;False;2263.854;868.2557;Height Masking;;0,0.3490566,0.0116665,1;;0;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;201;-3936,-1648;Inherit;False;Normal From Texture;-1;;13;9728ee98a55193249b513caf9a0f1676;13,149,0,147,0,143,0,141,0,139,0,151,0,137,0,153,0,159,0,157,0,155,0,135,0,108,0;4;87;SAMPLER2D;0;False;85;FLOAT2;0,0;False;74;SAMPLERSTATE;0;False;91;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;208;-3632,-1760;Inherit;False;Constant;_FakeNormal;Fake Normal;49;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;202;-3936,-1488;Inherit;False;Normal From Texture;-1;;14;9728ee98a55193249b513caf9a0f1676;13,149,1,147,1,143,1,141,1,139,1,151,1,137,1,153,1,159,1,157,1,155,1,135,1,108,0;4;87;SAMPLER2D;0;False;85;FLOAT2;0,0;False;74;SAMPLERSTATE;0;False;91;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;203;-3936,-1328;Inherit;False;Normal From Texture;-1;;15;9728ee98a55193249b513caf9a0f1676;13,149,2,147,2,143,2,141,2,139,2,151,2,137,2,153,2,159,2,157,2,155,2,135,2,108,0;4;87;SAMPLER2D;0;False;85;FLOAT2;0,0;False;74;SAMPLERSTATE;0;False;91;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;204;-3936,-1168;Inherit;False;Normal From Texture;-1;;16;9728ee98a55193249b513caf9a0f1676;13,149,3,147,3,143,3,141,3,139,3,151,3,137,3,153,3,159,3,157,3,155,3,135,3,108,0;4;87;SAMPLER2D;0;False;85;FLOAT2;0,0;False;74;SAMPLERSTATE;0;False;91;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;119;-3408,-1424;Inherit;False;Property;_GIsHeight;G Is Height;39;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;134;-4688,-1312;Inherit;False;Property;_HeightMapStrength;Height Map Strength;52;0;Create;True;0;0;0;False;0;False;1;1;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;205;-3056,-1440;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;207;-2768,-1392;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;206;-3056,-1328;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;120;-3408,-1520;Inherit;False;Property;_RIsHeight;R Is Height;38;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;117;-4896,-2832;Inherit;False;Property;_UseAAsColorMask;Use A As Color Mask;29;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;115;-4896,-3120;Inherit;False;Property;_UseRAsColorMask;Use R As Color Mask;26;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;116;-4896,-2928;Inherit;False;Property;_UseBAsColorMask;Use B As Color Mask;28;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;118;-4896,-3024;Inherit;False;Property;_UseGAsColorMask;Use G As Color Mask;27;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;265;-5056,-3088;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;266;-5056,-2992;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;267;-5056,-2896;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;268;-5056,-2800;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;114;-5648,-2608;Inherit;True;Property;_TextureSample3;Texture Sample 3;29;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;272;-5376,-3088;Inherit;False;Property;_MaskRIntensity;Mask R Intensity;30;0;Create;True;0;0;0;False;0;False;1;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;271;-5376,-2992;Inherit;False;Property;_MaskGIntensity;Mask G Intensity;31;0;Create;True;0;0;0;False;0;False;1;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;270;-5376,-2800;Inherit;False;Property;_MaskAIntensity;Mask A Intensity;33;0;Create;True;0;0;0;False;0;False;1;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;269;-5376,-2896;Inherit;False;Property;_MaskBIntensity;Mask B Intensity;32;0;Create;True;0;0;0;False;0;False;1;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;108;-1040,208;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;193;-832,224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;283;-2112,-3216;Inherit;False;1216.599;463.5762;Metallic Masking;;0.4297348,0.5945516,0.8207547,1;;0;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;11;-1632,128;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;288;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;49;-1616,384;Inherit;True;Property;_TextureSample12;Texture Sample 12;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;9;-1936,-112;Inherit;True;Property;_Base;Base Color (RGB);3;0;Create;False;0;0;0;False;0;False;None;None;False;black;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;13;-1632,-112;Inherit;True;Property;_TextureSample2;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;290;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;289;-5280,-3792;Inherit;False;2090.406;665.4558;Colorize Base Color;;0.5566038,0.2021627,0.2021627,1;;0;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;278;-2032,-3040;Inherit;False;Property;_MaskGMetallicLevel;Mask G Metallic Level;44;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;280;-2032,-2880;Inherit;False;Property;_MaskAMetallicLevel;Mask A Metallic Level;46;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;279;-2032,-2960;Inherit;False;Property;_MaskBMetallicLevel;Mask B Metallic Level;45;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;277;-2032,-3120;Inherit;False;Property;_MaskRMetallicLevel;Mask R Metallic Level;43;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;273;-1664,-3136;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;274;-1456,-3056;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;275;-1264,-2976;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;276;-1072,-2896;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;290;-2976,-2400;Inherit;True;Property;_TextureSample14;Texture Sample 14;3;0;Create;True;0;0;0;False;0;False;288;None;None;True;0;False;white;Auto;False;Instance;11;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;113;-5936,-2608;Inherit;True;Property;_PackedMasksRGBA;Packed Masks (RGBA);24;1;[Header];Create;True;1;Color Masking Settings;0;0;False;0;False;None;None;False;black;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;8;-1936,128;Inherit;True;Property;_ORM;ORM (RGB);4;0;Create;False;0;0;0;False;0;False;None;None;False;gray;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;147;-4832,-3712;Inherit;False;Property;_MaskRColor;Mask R Color;34;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,0,0.1098042,1;True;False;0;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;149;-4832,-3568;Inherit;False;Property;_MaskGColor;Mask G Color;35;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.1257732,1,0,1;True;False;0;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;150;-4832,-3424;Inherit;False;Property;_MaskBColor;Mask B Color;36;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.7075472,0.4881037,0.2503115,1;True;False;0;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;148;-4832,-3280;Inherit;False;Property;_MaskAColor;Mask A Color;37;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,1;True;False;0;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;299;-2112,-2560;Inherit;False;1216.272;412.928;Roughness Masking;;0.8207547,0.4684496,0.7360766,1;;0;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;282;-608,192;Inherit;False;Property;_UseMaskMetallic;Use Mask Metallic;42;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;300;-1232,112;Inherit;False;Property;_UseMaskRoughness;Use Mask Roughness;47;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;284;-4128,-3648;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;285;-3920,-3568;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;286;-3728,-3488;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;287;-3536,-3408;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;288;-5200,-3680;Inherit;True;Property;_TextureSample13;Texture Sample 13;3;0;Create;True;0;0;0;False;0;False;290;None;None;True;0;False;white;Auto;False;Instance;13;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;294;-2032,-2496;Inherit;False;Property;_MaskRRoughLevel;Mask R Rough Level;48;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;291;-2032,-2416;Inherit;False;Property;_MaskGRoughLevel;Mask G Rough Level;49;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;293;-2032,-2336;Inherit;False;Property;_MaskBRoughLevel;Mask B Rough Level;50;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;292;-2032,-2256;Inherit;False;Property;_MaskARoughLevel;Mask A Rough Level;51;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;295;-1664,-2512;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;296;-1456,-2432;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;297;-1264,-2352;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;298;-1072,-2272;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;107;-1712,624;Inherit;False;Property;_MetallicMult;Metallic Mult;5;0;Create;True;0;0;0;False;0;False;1;1;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;0;0,0;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ExtraPrePass;0;0;ExtraPrePass;6;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;2;0,0;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ForwardAdd;0;2;ForwardAdd;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;True;4;1;False;;1;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;True;1;LightMode=ForwardAdd;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;3;0,0;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;Deferred;0;3;Deferred;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Deferred;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;4;0,0;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;Meta;0;4;Meta;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;5;0,0;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ShadowCaster;0;5;ShadowCaster;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;6;0,0;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;SceneSelectionPass;0;6;SceneSelectionPass;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;7;0,0;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ScenePickingPass;0;7;ScenePickingPass;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;False;True;1;LightMode=ScenePickingPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1;0,0;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;8;Tarkov Custom/Metallic/Lit/Opaque/Epic Standard Masked_Icon;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ForwardBase;0;1;ForwardBase;17;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;True;True;True;0;True;_StencilType;255;False;;3;False;;7;False;;3;False;;1;False;;1;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;44;Category;0;0;  Instanced Terrain Normals;1;0;Workflow;1;0;Surface;0;0;  Blend;0;0;  Dither Shadows;1;0;Two Sided;1;0;Alpha Clipping;0;0;  Use Shadow Threshold;0;0;Deferred Pass;1;0;Normal Space;0;0;Transmission;0;0;  Transmission Shadow;0.5,False,;0;Translucency;0;0;  Translucency Strength;1,False,;0;  Normal Distortion;0.5,False,;0;  Scattering;2,False,;0;  Direct;0.9,False,;0;  Ambient;0.1,False,;0;  Shadow;0.5,False,;0;Cast Shadows;1;0;Receive Shadows;1;0;Receive Specular;1;638965988478672004;Receive Reflections;1;638965988492216648;GPU Instancing;1;0;LOD CrossFade;1;0;Built-in Fog;1;0;Ambient Light;1;0;Meta Pass;1;0;Add Pass;1;0;Override Baked GI;0;0;Write Depth;0;0;Extra Pre Pass;0;0;Tessellation;0;0;  Phong;0;0;  Strength;0.5,False,;0;  Type;0;0;  Tess;16,False,;0;  Min;10,False,;0;  Max;25,False,;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Disable Batching;0;0;Vertex Position;1;0;0;8;False;True;True;True;True;True;True;True;False;;False;0
WireConnection;85;0;87;0
WireConnection;85;1;86;0
WireConnection;87;0;300;0
WireConnection;106;0;88;0
WireConnection;106;1;13;5
WireConnection;90;1;13;5
WireConnection;90;0;106;0
WireConnection;135;1;90;0
WireConnection;135;0;287;0
WireConnection;192;0;85;0
WireConnection;133;0;207;0
WireConnection;133;1;49;0
WireConnection;121;1;208;0
WireConnection;121;0;203;40
WireConnection;122;1;208;0
WireConnection;122;0;204;40
WireConnection;201;87;113;0
WireConnection;201;91;134;0
WireConnection;202;87;113;0
WireConnection;202;91;134;0
WireConnection;203;87;113;0
WireConnection;203;91;134;0
WireConnection;204;87;113;0
WireConnection;204;91;134;0
WireConnection;119;1;208;0
WireConnection;119;0;202;40
WireConnection;205;0;120;0
WireConnection;205;1;119;0
WireConnection;207;0;205;0
WireConnection;207;1;206;0
WireConnection;206;0;121;0
WireConnection;206;1;122;0
WireConnection;120;1;208;0
WireConnection;120;0;201;40
WireConnection;117;0;268;0
WireConnection;115;0;265;0
WireConnection;116;0;267;0
WireConnection;118;0;266;0
WireConnection;265;0;272;0
WireConnection;265;1;114;1
WireConnection;266;0;271;0
WireConnection;266;1;114;2
WireConnection;267;0;269;0
WireConnection;267;1;114;3
WireConnection;268;0;270;0
WireConnection;268;1;114;4
WireConnection;114;0;113;0
WireConnection;108;0;11;3
WireConnection;108;1;107;0
WireConnection;193;0;108;0
WireConnection;11;0;8;0
WireConnection;49;0;10;0
WireConnection;49;5;44;0
WireConnection;13;0;9;0
WireConnection;273;0;290;3
WireConnection;273;1;277;0
WireConnection;273;2;115;0
WireConnection;274;0;273;0
WireConnection;274;1;278;0
WireConnection;274;2;118;0
WireConnection;275;0;274;0
WireConnection;275;1;279;0
WireConnection;275;2;116;0
WireConnection;276;0;275;0
WireConnection;276;1;280;0
WireConnection;276;2;117;0
WireConnection;282;1;193;0
WireConnection;282;0;276;0
WireConnection;300;1;11;2
WireConnection;300;0;298;0
WireConnection;284;0;288;5
WireConnection;284;1;147;0
WireConnection;284;2;115;0
WireConnection;285;0;284;0
WireConnection;285;1;149;0
WireConnection;285;2;118;0
WireConnection;286;0;285;0
WireConnection;286;1;150;0
WireConnection;286;2;116;0
WireConnection;287;0;286;0
WireConnection;287;1;148;0
WireConnection;287;2;117;0
WireConnection;295;0;290;2
WireConnection;295;1;294;0
WireConnection;295;2;115;0
WireConnection;296;0;295;0
WireConnection;296;1;291;0
WireConnection;296;2;118;0
WireConnection;297;0;296;0
WireConnection;297;1;293;0
WireConnection;297;2;116;0
WireConnection;298;0;297;0
WireConnection;298;1;292;0
WireConnection;298;2;117;0
WireConnection;1;0;135;0
WireConnection;1;1;133;0
WireConnection;1;4;282;0
WireConnection;1;5;192;0
WireConnection;1;6;11;1
ASEEND*/
//CHKSM=6BDE65EEAAA204766B67B16B771DB902285A5E52