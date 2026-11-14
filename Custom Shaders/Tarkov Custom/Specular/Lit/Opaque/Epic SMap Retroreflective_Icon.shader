// Made with Amplify Shader Editor v1.9.9.14
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tarkov Custom/Specular/Lit/Opaque/Epic SMap Retroreflective_Icon"
{
	Properties
	{
		[MaterialEnum(Static, 0, Characters, 1, Hands, 2)] _StencilType( "Stencil Type", Range( 0, 2 ) ) = 0
		_Color( "Base Color Correction", Color ) = ( 1, 1, 1 )
		_MainTex( "Base Color (RGB) Spec (A)", 2D ) = "black" {}
		_DiffuseBaseStrength( "Diffuse Base Strength", Float ) = 1
		_DiffuseAngularBoost( "Diffuse Angular Boost", Float ) = 0
		_SpecularColorIntensity( "Specular Color Intensity", Range( 0, 1 ) ) = 0
		_Glossness( "Specular Mult", Range( 0, 10 ) ) = 1
		_SpecularBaseStrength( "Specular Base Strength", Float ) = 2
		_SpecularAngularBoost( "Specular Angular Boost", Float ) = 0
		[Header(BSG gloss map may also be used here)] _SpecMap( "AO (R) Gloss (G)", 2D ) = "gray" {}
		[Toggle( _USEBSGGLOSS_ON )] _UseBSGGloss( "Use BSG Gloss", Float ) = 0
		_Specularness( "Smoothness", Range( 0, 10 ) ) = 1
		[Normal] _BumpMap( "Normal Map", 2D ) = "bump" {}
		_NormalIntensity( "Normal Intensity", Float ) = 1
		[Toggle] _RainEffectsMaterial( "Enable Rain on This Material", Float ) = 1
		[HideInInspector][Space(10)] _DropsSpec( "Drops Spec", Float ) = 128
		[HideInInspector] _RippleTexScale( "Ripple Texture Scale", Float ) = 4
		[HideInInspector] _SkinnedMeshMaterial( "Skinned Mesh Material", Float ) = 0
		_RippleFakeLightIntensityOffset( "Rain Highlight Mask Threshold", Float ) = 0.7
		_NdotLOffset( "Rain Highlight Surface Facing Bias", Float ) = 0.4
		_NightRippleFakeLightOffset( "Rain Highlight Sun Height Fade Offset", Float ) = 0.2
		_ThermalSettingsMinMaxBaseInfluenceAdd( "Thermal Settings (Min, Max, Base Influence, Add)", Vector ) = ( 0.1, 0.2, 0.28, 0 )
		[HideInInspector] _LocalRain( "_LocalRain", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _LocalRainAverage( "_LocalRainAverage", Vector ) = ( 0, 0, 0, 0 )
		[Toggle( USEHEAT )] USEHEAT( "Enable Localized Heat Glow", Float ) = 0
		[HDR] _HeatColor1( "Heat Glow Color - Lower Heat", Color ) = ( 1, 0, 0, 1 )
		[HDR] _HeatColor2( "Heat Glow Color - Higher Heat", Color ) = ( 1, 0.34, 0, 1 )
		[HideInInspector] _HeatTemp( "Heat Temperature (Celsius - Game Driven)", Float ) = 0
		[HideInInspector] _HeatCenter( "Heat Region Center (Local XYZ)", Vector ) = ( 0, 0, 0, 1 )
		[HideInInspector] _HeatSize( "Heat Region Size (Local XYZ)", Vector ) = ( 0.02, 0.04, 0.02, 1 )
		[HideInInspector] _HeatThermalFactor( "Game Thermal Brightness Multiplier", Float ) = 1
		[HideInInspector] _HeatVisible( "Visible Heat Glow Strength", Float ) = 1
		[HideInInspector] _HeatVisibleFactor( "Game Heat Glow Multiplier", Float ) = 1


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

		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0

		//_InstancedTerrainNormals("Specular Highlights", Float) = 1.0
	}

	SubShader
	{
		

		

		Tags { "RenderType"="Opaque" "Queue"="Geometry" "DisableBatching"="False" }

	LOD 0

		Cull Back
		AlphaToMask Off
		ZWrite On
		ZClip True
		ZTest LEqual
		ColorMask RGBA
		Blend One Zero, One Zero
		BlendOp Add, Add
		Offset 0 , 0

		

		Blend One Zero, One Zero
		BlendOp Add, Add
		

		CGINCLUDE
			#pragma target 3.5
			// ensure rendering platforms toggle list is visible

			#ifndef GLOBAL_HEADER_INCLUDED
			#define GLOBAL_HEADER_INCLUDED
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
			#endif
		ENDCG

		
		Pass
		{
			
			Name "ForwardBase"
			Tags { "LightMode"="ForwardBase" }

			Blend One Zero, One Zero
			BlendOp Add, Add

			CGPROGRAM
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
				#pragma shader_feature_local_fragment _GLOSSYREFLECTIONS_OFF
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#pragma multi_compile_fog
				#define ASE_FOG
				#define _SPECULAR_SETUP 1
				#define ASE_VERSION 19914
				#define ASE_USING_SAMPLING_MACROS 1

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
				#define ASE_NEEDS_FRAG_NORMAL
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
				#define ASE_NEEDS_WORLD_POSITION
				#define ASE_NEEDS_FRAG_WORLD_POSITION
				#define ASE_NEEDS_WORLD_TANGENT
				#define ASE_NEEDS_FRAG_WORLD_TANGENT
				#define ASE_NEEDS_WORLD_NORMAL
				#define ASE_NEEDS_FRAG_WORLD_NORMAL
				#define ASE_NEEDS_FRAG_WORLD_BITANGENT
				#define ASE_NEEDS_FRAG_POSITION
				#pragma multi_compile _ Rain
				#pragma multi_compile _ USERAIN
				#pragma multi_compile _ TRIPLANAR
				#pragma multi_compile _ USEHEAT
				#pragma shader_feature_local _USEBSGGLOSS_ON
				#pragma multi_compile _ FAKERIPPLELIGHT
				#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
				#else//ASE Sampling Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
				#endif//ASE Sampling Macros
				


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
					half3 normal : NORMAL;
					half4 tangent : TANGENT;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					ASE_SV_POSITION_QUALIFIERS float4 pos : SV_POSITION;
					float4 worldPos : TEXCOORD0; // xyz = positionWS, w = fogCoord
					half3 normalWS : TEXCOORD1;
					float4 tangentWS : TEXCOORD2; // holds terrainUV ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					half4 ambientOrLightmapUV : TEXCOORD3;
					UNITY_LIGHTING_COORDS( 4, 5 )
					float4 ase_texcoord6 : TEXCOORD6;
					float3 ase_normal : NORMAL;
					float4 ase_texcoord7 : TEXCOORD7;
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

				uniform float _StencilType;
				uniform float _DropsSpec;
				uniform float3 _Color;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_MainTex);
				uniform float4 _MainTex_ST;
				SamplerState sampler_MainTex;
				uniform float _RainEffectsMaterial;
				uniform float _RainIntensity;
				uniform float _RainIntensityRippleScale;
				uniform float3 _LocalRainAverage;
				uniform float3 _LocalRain;
				uniform float _SkinnedMeshMaterial;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_RippleTexture);
				uniform float _RippleTexScale;
				SamplerState sampler_RippleTexture;
				uniform float3 _EnvironmentRippleCycle;
				uniform float _WetDropAlbedo;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_BumpMap);
				uniform float4 _BumpMap_ST;
				SamplerState sampler_BumpMap;
				uniform float _NormalIntensity;
				uniform float _WetDropNormal;
				uniform float _DiffuseAngularBoost;
				uniform float _DiffuseBaseStrength;
				uniform float4 _ThermalSettingsMinMaxBaseInfluenceAdd;
				uniform float _SpecularAngularBoost;
				uniform float _SpecularBaseStrength;
				uniform float4 _HeatColor1;
				uniform float4 _HeatColor2;
				uniform float4 _HeatCenter;
				uniform float4 _HeatSize;
				uniform float _HeatTemp;
				uniform float _HeatVisibleFactor;
				uniform float _HeatThermalFactor;
				uniform float _ThermalVisionOn;
				uniform float _SpecularColorIntensity;
				uniform float _Glossness;
				uniform float _WetDropGlossness;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_SpecMap);
				uniform float4 _SpecMap_ST;
				SamplerState sampler_SpecMap;
				uniform float _Specularness;
				uniform float _WetDropSpecular;
				uniform float _HeatVisible;
				uniform float4 _SunDirection;
				uniform float _NdotLOffset;
				uniform float _RippleFakeLightIntensityOffset;
				uniform float _NightRippleFakeLightOffset;
				uniform float _RippleFakeLightIntensity;


				
				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					o.ase_texcoord6.xy = v.texcoord.xyzw.xy;
					o.ase_normal = v.normal;
					o.ase_texcoord7 = v.vertex;
					
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
							#if defined( ASE_WRITE_DEPTH )
								, out float outputDepth : ASE_SV_DEPTH
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

					float2 uv_MainTex = IN.ase_texcoord6.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					float4 tex2DNode13 = SAMPLE_TEXTURE2D( _MainTex, sampler_MainTex, uv_MainTex );
					float3 temp_output_106_0 = ( _Color * tex2DNode13.rgb );
					float dotResult230 = dot( IN.ase_normal , _LocalRainAverage );
					float dotResult227 = dot( IN.ase_normal , _LocalRain );
					float4 tex2DNode25_g1 = SAMPLE_TEXTURE2D( _RippleTexture, sampler_RippleTexture, ( uv_MainTex / _RippleTexScale ) );
					float temp_output_34_0_g1 = ( tex2DNode25_g1.r * saturate( ( 1.0 - ( fmod( ( ( ( tex2DNode25_g1.a * _EnvironmentRippleCycle.y ) + _EnvironmentRippleCycle.x ) / _EnvironmentRippleCycle.y ) , 1.0 ) * _EnvironmentRippleCycle.y ) ) ) * _EnvironmentRippleCycle.z );
					float temp_output_183_13 = temp_output_34_0_g1;
					float3 break196 = max( ( abs( IN.ase_normal ) - 0.49 ), 0.0 );
					float temp_output_197_0 = ( break196.x + break196.y + break196.z );
					float temp_output_198_0 = ( break196.x / temp_output_197_0 );
					float3 break202 = ( IN.ase_texcoord7.xyz * _RippleTexScale );
					float2 appendResult203 = (float2(break202.y , break202.z));
					float4 tex2DNode25_g9 = SAMPLE_TEXTURE2D( _RippleTexture, sampler_RippleTexture, appendResult203 );
					float temp_output_34_0_g9 = ( tex2DNode25_g9.r * saturate( ( 1.0 - ( fmod( ( ( ( tex2DNode25_g9.a * _EnvironmentRippleCycle.y ) + _EnvironmentRippleCycle.x ) / _EnvironmentRippleCycle.y ) , 1.0 ) * _EnvironmentRippleCycle.y ) ) ) * _EnvironmentRippleCycle.z );
					float temp_output_199_0 = ( break196.y / temp_output_197_0 );
					float2 appendResult205 = (float2(break202.z , break202.x));
					float4 tex2DNode25_g8 = SAMPLE_TEXTURE2D( _RippleTexture, sampler_RippleTexture, appendResult205 );
					float temp_output_34_0_g8 = ( tex2DNode25_g8.r * saturate( ( 1.0 - ( fmod( ( ( ( tex2DNode25_g8.a * _EnvironmentRippleCycle.y ) + _EnvironmentRippleCycle.x ) / _EnvironmentRippleCycle.y ) , 1.0 ) * _EnvironmentRippleCycle.y ) ) ) * _EnvironmentRippleCycle.z );
					float temp_output_200_0 = ( break196.z / temp_output_197_0 );
					float2 appendResult207 = (float2(break202.x , break202.y));
					float4 tex2DNode25_g7 = SAMPLE_TEXTURE2D( _RippleTexture, sampler_RippleTexture, appendResult207 );
					float temp_output_34_0_g7 = ( tex2DNode25_g7.r * saturate( ( 1.0 - ( fmod( ( ( ( tex2DNode25_g7.a * _EnvironmentRippleCycle.y ) + _EnvironmentRippleCycle.x ) / _EnvironmentRippleCycle.y ) , 1.0 ) * _EnvironmentRippleCycle.y ) ) ) * _EnvironmentRippleCycle.z );
					float staticSwitch219 = ( float )0;
					#ifdef TRIPLANAR
					{
						staticSwitch219 = ( ( temp_output_198_0 * temp_output_34_0_g9 ) + ( temp_output_199_0 * temp_output_34_0_g8 ) + ( temp_output_200_0 * temp_output_34_0_g7 ) );
					}
					#else
					{
						staticSwitch219 = temp_output_183_13;
					}
					#endif
					float ifLocalVar221 = 0;
					if( _SkinnedMeshMaterial <= 0.0 )
					ifLocalVar221 = staticSwitch219;
					else
					ifLocalVar221 = temp_output_183_13;
					float ifLocalVar243 = 0;
					if( _SkinnedMeshMaterial <= 0.0 )
					{
						ifLocalVar243 = ifLocalVar221;
					}
					else
					{
						ifLocalVar243 = ( 0.35 * ifLocalVar221 );
					}
					float temp_output_278_0 = ( _RainEffectsMaterial * ( ( saturate( ( _RainIntensity * _RainIntensityRippleScale ) ) * saturate( ( max( dotResult230, 0.0 ) + max( dotResult227, 0.0 ) ) ) ) * ifLocalVar243 ) );
					float3 staticSwitch268 = ( float3 )0;
					#ifdef USERAIN
					{
						float3 color261 = IsGammaSpace() ? float3( 0, 0, 0 ) : float3( 0, 0, 0 );
						float3 lerpResult262 = lerp( temp_output_106_0 , color261 , ( temp_output_278_0 * _WetDropAlbedo ));
						staticSwitch268 = lerpResult262;
					}
					#else
					{
						staticSwitch268 = temp_output_106_0;
					}
					#endif
					#ifdef Rain
					float3 staticSwitch269 = staticSwitch268;
					#else
					float3 staticSwitch269 = temp_output_106_0;
					#endif
					float2 uv_BumpMap = IN.ase_texcoord6.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
					float3 tex2DNode49 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _BumpMap, sampler_BumpMap, uv_BumpMap ), _NormalIntensity );
					float2 appendResult16_g1 = (float2(tex2DNode25_g1.g , tex2DNode25_g1.b));
					float2 temp_output_183_0 = ( ( ( appendResult16_g1 * 2.0 ) - 1.0 ) * saturate( ( temp_output_34_0_g1 - 0.5 ) ) );
					float2 appendResult16_g9 = (float2(tex2DNode25_g9.g , tex2DNode25_g9.b));
					float2 appendResult16_g8 = (float2(tex2DNode25_g8.g , tex2DNode25_g8.b));
					float2 appendResult16_g7 = (float2(tex2DNode25_g7.g , tex2DNode25_g7.b));
					float2 staticSwitch220 = ( float2 )0;
					#ifdef TRIPLANAR
					{
						staticSwitch220 = ( ( temp_output_198_0 * ( ( ( appendResult16_g9 * 2.0 ) - 1.0 ) * saturate( ( temp_output_34_0_g9 - 0.5 ) ) ) ) + ( temp_output_199_0 * ( ( ( appendResult16_g8 * 2.0 ) - 1.0 ) * saturate( ( temp_output_34_0_g8 - 0.5 ) ) ) ) + ( temp_output_200_0 * ( ( ( appendResult16_g7 * 2.0 ) - 1.0 ) * saturate( ( temp_output_34_0_g7 - 0.5 ) ) ) ) );
					}
					#else
					{
						staticSwitch220 = temp_output_183_0;
					}
					#endif
					float3 staticSwitch271 = ( float3 )0;
					#ifdef USERAIN
					{
						float2 ifLocalVar223 = 0;
						if( _SkinnedMeshMaterial <= 0.0 )
						ifLocalVar223 = staticSwitch220;
						else
						ifLocalVar223 = temp_output_183_0;
						float3 appendResult249 = (float3(( 7.0 * ifLocalVar223 ) , 1.0));
						float3 normalizeResult251 = normalize( appendResult249 );
						float3 lerpResult264 = lerp( tex2DNode49 , normalizeResult251 , ( _WetDropNormal * temp_output_278_0 ));
						staticSwitch271 = lerpResult264;
					}
					#else
					{
						staticSwitch271 = tex2DNode49;
					}
					#endif
					#ifdef Rain
					float3 staticSwitch270 = staticSwitch271;
					#else
					float3 staticSwitch270 = tex2DNode49;
					#endif
					float3 tanToWorld0 = float3( TangentWS.x, BitangentWS.x, NormalWS.x );
					float3 tanToWorld1 = float3( TangentWS.y, BitangentWS.y, NormalWS.y );
					float3 tanToWorld2 = float3( TangentWS.z, BitangentWS.z, NormalWS.z );
					float3 ase_viewVectorTS =  tanToWorld0 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).x + tanToWorld1 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).y  + tanToWorld2 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).z;
					float3 ase_viewDirTS = normalize( ase_viewVectorTS );
					float3 normalizeResult132 = normalize( ase_viewDirTS );
					float dotResult130 = dot( staticSwitch270 , normalizeResult132 );
					float temp_output_133_0 = ( 1.0 - dotResult130 );
					float Angle_Ref137 = ( ( temp_output_133_0 * temp_output_133_0 ) * 0.5 );
					float3 Surface_Albedo284 = ( staticSwitch269 * ( ( Angle_Ref137 * _DiffuseAngularBoost ) + _DiffuseBaseStrength ) );
					float3 temp_cast_0 = (0.0).xxx;
					float temp_output_145_0 = ( ( ( Angle_Ref137 * _SpecularAngularBoost ) + _SpecularBaseStrength ) * 0.5 );
					float3 staticSwitch283 = ( float3 )0;
					#ifdef USEHEAT
					{
						float4 break289 = _HeatCenter;
						float3 appendResult291 = (float3(break289.x , break289.y , break289.z));
						float4 break290 = _HeatSize;
						float3 appendResult292 = (float3(break290.x , break290.y , break290.z));
						float temp_output_22_0_g293 = max( ( ( _HeatTemp - 30.0 ) * 0.1 ), 0.0 );
						float temp_output_24_0_g293 = ( max( ( 1.0 - length( ( ( IN.ase_texcoord7.xyz - appendResult291 ) / max( abs( appendResult292 ), 0.0001 ) ) ) ), 0.0 ) * ( temp_output_22_0_g293 * temp_output_22_0_g293 ) );
						float3 lerpResult25_g293 = lerp( _HeatColor1.rgb , _HeatColor2.rgb , temp_output_24_0_g293);
						float Specular_Angle_Response287 = temp_output_145_0;
						staticSwitch283 = ( ( ( lerpResult25_g293 * temp_output_24_0_g293 ) * _HeatVisibleFactor ) * Specular_Angle_Response287 );
					}
					#else
					{
						staticSwitch283 = temp_cast_0;
					}
					#endif
					float3 Localized_Heat_Radiance297 = staticSwitch283;
					float3 staticSwitch308 = ( float3 )0;
					#ifdef USEHEAT
					{
						staticSwitch308 = ( Surface_Albedo284 + ( Localized_Heat_Radiance297 * 10.0 ) );
					}
					#else
					{
						staticSwitch308 = ( Surface_Albedo284 * _ThermalSettingsMinMaxBaseInfluenceAdd.z );
					}
					#endif
					float4 break4_g309 = _ThermalSettingsMinMaxBaseInfluenceAdd;
					float ifLocalVar311 = 0;
					if( _ThermalVisionOn <= 0.0 )
					{
						ifLocalVar311 = 0.0;
					}
					else
					{
						ifLocalVar311 = 1.0;
					}
					float3 lerpResult312 = lerp( Surface_Albedo284 , ( min( max( staticSwitch308, ( break4_g309.x * _HeatThermalFactor ) ), break4_g309.y ) + break4_g309.w ) , ifLocalVar311);
					
					float3 Surface_Normal285 = staticSwitch270;
					
					float3 temp_cast_1 = (tex2DNode13.a).xxx;
					float3 lerpResult109 = lerp( temp_cast_1 , ( tex2DNode13.rgb * tex2DNode13.a ) , _SpecularColorIntensity);
					float3 temp_output_116_0 = ( lerpResult109 * _Glossness );
					float3 staticSwitch274 = ( float3 )0;
					#ifdef USERAIN
					{
						float3 color266 = IsGammaSpace() ? float3( 1, 1, 1 ) : float3( 1, 1, 1 );
						float3 lerpResult265 = lerp( temp_output_116_0 , color266 , ( _WetDropGlossness * temp_output_278_0 ));
						staticSwitch274 = lerpResult265;
					}
					#else
					{
						staticSwitch274 = temp_output_116_0;
					}
					#endif
					#ifdef Rain
					float3 staticSwitch275 = staticSwitch274;
					#else
					float3 staticSwitch275 = temp_output_116_0;
					#endif
					
					float2 uv_SpecMap = IN.ase_texcoord6.xy * _SpecMap_ST.xy + _SpecMap_ST.zw;
					float4 tex2DNode11 = SAMPLE_TEXTURE2D( _SpecMap, sampler_SpecMap, uv_SpecMap );
					float3 temp_cast_2 = (tex2DNode11.g).xxx;
					#ifdef _USEBSGGLOSS_ON
					float3 staticSwitch123 = tex2DNode11.rgb;
					#else
					float3 staticSwitch123 = temp_cast_2;
					#endif
					float3 temp_output_85_0 = ( staticSwitch123 * _Specularness );
					float3 staticSwitch272 = ( float3 )0;
					#ifdef USERAIN
					{
						float3 temp_cast_3 = (1.0).xxx;
						float3 lerpResult263 = lerp( temp_output_85_0 , temp_cast_3 , ( _WetDropSpecular * temp_output_278_0 ));
						staticSwitch272 = lerpResult263;
					}
					#else
					{
						staticSwitch272 = temp_output_85_0;
					}
					#endif
					#ifdef Rain
					float3 staticSwitch273 = staticSwitch272;
					#else
					float3 staticSwitch273 = temp_output_85_0;
					#endif
					
					float staticSwitch124 = ( float )0;
					#ifdef _USEBSGGLOSS_ON
					{
						staticSwitch124 = 1.0;
					}
					#else
					{
						staticSwitch124 = tex2DNode11.r;
					}
					#endif
					
					float3 Visible_Heat_Emission300 = ( Localized_Heat_Radiance297 * _HeatVisible );
					float staticSwitch319 = ( float )0;
					#ifdef USERAIN
					{
						float staticSwitch318 = ( float )0;
						#ifdef FAKERIPPLELIGHT
						{
							float3 tanNormal314 = Surface_Normal285;
							float3 worldNormal314 = float3( dot( tanToWorld0, tanNormal314 ), dot( tanToWorld1, tanNormal314 ), dot( tanToWorld2, tanNormal314 ) );
							float3 temp_output_4_0_g316 = _SunDirection.xyz;
							float3 temp_output_14_0_g316 = ( temp_output_4_0_g316 * -1.0 );
							float dotResult18_g316 = dot( worldNormal314 , ( temp_output_14_0_g316 / max( length( temp_output_14_0_g316 ), 0.0001 ) ) );
							float Material_Drop_Mask286 = ifLocalVar243;
							float3 break27_g316 = Surface_Normal285;
							float2 appendResult28_g316 = (float2(break27_g316.x , break27_g316.y));
							float ifLocalVar30_g316 = 0;
							if( length( appendResult28_g316 ) <= 0.32 )
							ifLocalVar30_g316 = 0.0;
							else
							ifLocalVar30_g316 = 1.0;
							float ifLocalVar31_g316 = 0;
							if( break27_g316.x <= 0.0 )
							ifLocalVar31_g316 = 0.0;
							else
							ifLocalVar31_g316 = 1.0;
							staticSwitch318 = ( ( ( ( ( saturate( ( max( dotResult18_g316, 0.0 ) + _NdotLOffset ) ) * ceil( ( Material_Drop_Mask286 - _RippleFakeLightIntensityOffset ) ) ) * saturate( ( _NightRippleFakeLightOffset - temp_output_4_0_g316.y ) ) ) * ( ifLocalVar30_g316 * ifLocalVar31_g316 ) ) * _RippleFakeLightIntensity ) * _RainEffectsMaterial );
						}
						#else
						{
							staticSwitch318 = 0.0;
						}
						#endif
						staticSwitch319 = staticSwitch318;
					}
					#else
					{
						staticSwitch319 = 0.0;
					}
					#endif
					#ifdef Rain
					float staticSwitch320 = staticSwitch319;
					#else
					float staticSwitch320 = 0.0;
					#endif
					float Rain_Highlight_Emission321 = staticSwitch320;
					

					o.Albedo = lerpResult312;
					o.Normal = Surface_Normal285;

					half3 Specular = saturate( ( temp_output_145_0 * staticSwitch275 ) );
					half Metallic = 0;
					half Smoothness = staticSwitch273.x;
					half Occlusion = staticSwitch124;

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

					o.Emission = ( Visible_Heat_Emission300 + Rain_Highlight_Emission321 );
					o.Alpha = 1;
					half AlphaClipThreshold = 0.5;
					half AlphaClipThresholdShadow = 0.5;
					half3 BakedGI = 0;
					half3 Transmission = 1;
					half3 Translucency = 1;

					#if defined( ASE_WRITE_DEPTH )
						IN.pos.z = IN.pos.z;
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

					#if defined( ASE_WRITE_DEPTH )
						outputDepth = IN.pos.z;
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
				#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#pragma multi_compile_fog
				#define ASE_FOG
				#define _SPECULAR_SETUP 1
				#define ASE_VERSION 19914
				#define ASE_USING_SAMPLING_MACROS 1

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
				#define ASE_NEEDS_FRAG_NORMAL
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
				#define ASE_NEEDS_WORLD_POSITION
				#define ASE_NEEDS_FRAG_WORLD_POSITION
				#define ASE_NEEDS_FRAG_WORLD_TANGENT
				#define ASE_NEEDS_WORLD_NORMAL
				#define ASE_NEEDS_FRAG_WORLD_NORMAL
				#define ASE_NEEDS_FRAG_WORLD_BITANGENT
				#define ASE_NEEDS_FRAG_POSITION
				#pragma multi_compile _ Rain
				#pragma multi_compile _ USERAIN
				#pragma multi_compile _ TRIPLANAR
				#pragma multi_compile _ USEHEAT
				#pragma shader_feature_local _USEBSGGLOSS_ON
				#pragma multi_compile _ FAKERIPPLELIGHT
				#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
				#else//ASE Sampling Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
				#endif//ASE Sampling Macros
				


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
					half3 normal : NORMAL;
					half4 tangent : TANGENT;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					ASE_SV_POSITION_QUALIFIERS float4 pos : SV_POSITION;
					float4 worldPos : TEXCOORD0; // xyz = positionWS, w = fogCoord
					half3 normalWS : TEXCOORD1;
					float4 tangentWS : TEXCOORD2; // holds terrainUV ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					UNITY_LIGHTING_COORDS( 3, 4 )
					float4 ase_texcoord5 : TEXCOORD5;
					float3 ase_normal : NORMAL;
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

				uniform float _StencilType;
				uniform float _DropsSpec;
				uniform float3 _Color;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_MainTex);
				uniform float4 _MainTex_ST;
				SamplerState sampler_MainTex;
				uniform float _RainEffectsMaterial;
				uniform float _RainIntensity;
				uniform float _RainIntensityRippleScale;
				uniform float3 _LocalRainAverage;
				uniform float3 _LocalRain;
				uniform float _SkinnedMeshMaterial;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_RippleTexture);
				uniform float _RippleTexScale;
				SamplerState sampler_RippleTexture;
				uniform float3 _EnvironmentRippleCycle;
				uniform float _WetDropAlbedo;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_BumpMap);
				uniform float4 _BumpMap_ST;
				SamplerState sampler_BumpMap;
				uniform float _NormalIntensity;
				uniform float _WetDropNormal;
				uniform float _DiffuseAngularBoost;
				uniform float _DiffuseBaseStrength;
				uniform float4 _ThermalSettingsMinMaxBaseInfluenceAdd;
				uniform float _SpecularAngularBoost;
				uniform float _SpecularBaseStrength;
				uniform float4 _HeatColor1;
				uniform float4 _HeatColor2;
				uniform float4 _HeatCenter;
				uniform float4 _HeatSize;
				uniform float _HeatTemp;
				uniform float _HeatVisibleFactor;
				uniform float _HeatThermalFactor;
				uniform float _ThermalVisionOn;
				uniform float _SpecularColorIntensity;
				uniform float _Glossness;
				uniform float _WetDropGlossness;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_SpecMap);
				uniform float4 _SpecMap_ST;
				SamplerState sampler_SpecMap;
				uniform float _Specularness;
				uniform float _WetDropSpecular;
				uniform float _HeatVisible;
				uniform float4 _SunDirection;
				uniform float _NdotLOffset;
				uniform float _RippleFakeLightIntensityOffset;
				uniform float _NightRippleFakeLightOffset;
				uniform float _RippleFakeLightIntensity;


				
				v2f VertexFunction (appdata v  ) {
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					o.ase_texcoord5.xy = v.texcoord.xyzw.xy;
					o.ase_normal = v.normal;
					o.ase_texcoord6 = v.vertex;
					
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
					#if defined( ASE_WRITE_DEPTH )
					, out float outputDepth : ASE_SV_DEPTH
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

					float2 uv_MainTex = IN.ase_texcoord5.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					float4 tex2DNode13 = SAMPLE_TEXTURE2D( _MainTex, sampler_MainTex, uv_MainTex );
					float3 temp_output_106_0 = ( _Color * tex2DNode13.rgb );
					float dotResult230 = dot( IN.ase_normal , _LocalRainAverage );
					float dotResult227 = dot( IN.ase_normal , _LocalRain );
					float4 tex2DNode25_g1 = SAMPLE_TEXTURE2D( _RippleTexture, sampler_RippleTexture, ( uv_MainTex / _RippleTexScale ) );
					float temp_output_34_0_g1 = ( tex2DNode25_g1.r * saturate( ( 1.0 - ( fmod( ( ( ( tex2DNode25_g1.a * _EnvironmentRippleCycle.y ) + _EnvironmentRippleCycle.x ) / _EnvironmentRippleCycle.y ) , 1.0 ) * _EnvironmentRippleCycle.y ) ) ) * _EnvironmentRippleCycle.z );
					float temp_output_183_13 = temp_output_34_0_g1;
					float3 break196 = max( ( abs( IN.ase_normal ) - 0.49 ), 0.0 );
					float temp_output_197_0 = ( break196.x + break196.y + break196.z );
					float temp_output_198_0 = ( break196.x / temp_output_197_0 );
					float3 break202 = ( IN.ase_texcoord6.xyz * _RippleTexScale );
					float2 appendResult203 = (float2(break202.y , break202.z));
					float4 tex2DNode25_g9 = SAMPLE_TEXTURE2D( _RippleTexture, sampler_RippleTexture, appendResult203 );
					float temp_output_34_0_g9 = ( tex2DNode25_g9.r * saturate( ( 1.0 - ( fmod( ( ( ( tex2DNode25_g9.a * _EnvironmentRippleCycle.y ) + _EnvironmentRippleCycle.x ) / _EnvironmentRippleCycle.y ) , 1.0 ) * _EnvironmentRippleCycle.y ) ) ) * _EnvironmentRippleCycle.z );
					float temp_output_199_0 = ( break196.y / temp_output_197_0 );
					float2 appendResult205 = (float2(break202.z , break202.x));
					float4 tex2DNode25_g8 = SAMPLE_TEXTURE2D( _RippleTexture, sampler_RippleTexture, appendResult205 );
					float temp_output_34_0_g8 = ( tex2DNode25_g8.r * saturate( ( 1.0 - ( fmod( ( ( ( tex2DNode25_g8.a * _EnvironmentRippleCycle.y ) + _EnvironmentRippleCycle.x ) / _EnvironmentRippleCycle.y ) , 1.0 ) * _EnvironmentRippleCycle.y ) ) ) * _EnvironmentRippleCycle.z );
					float temp_output_200_0 = ( break196.z / temp_output_197_0 );
					float2 appendResult207 = (float2(break202.x , break202.y));
					float4 tex2DNode25_g7 = SAMPLE_TEXTURE2D( _RippleTexture, sampler_RippleTexture, appendResult207 );
					float temp_output_34_0_g7 = ( tex2DNode25_g7.r * saturate( ( 1.0 - ( fmod( ( ( ( tex2DNode25_g7.a * _EnvironmentRippleCycle.y ) + _EnvironmentRippleCycle.x ) / _EnvironmentRippleCycle.y ) , 1.0 ) * _EnvironmentRippleCycle.y ) ) ) * _EnvironmentRippleCycle.z );
					float staticSwitch219 = ( float )0;
					#ifdef TRIPLANAR
					{
						staticSwitch219 = ( ( temp_output_198_0 * temp_output_34_0_g9 ) + ( temp_output_199_0 * temp_output_34_0_g8 ) + ( temp_output_200_0 * temp_output_34_0_g7 ) );
					}
					#else
					{
						staticSwitch219 = temp_output_183_13;
					}
					#endif
					float ifLocalVar221 = 0;
					if( _SkinnedMeshMaterial <= 0.0 )
					ifLocalVar221 = staticSwitch219;
					else
					ifLocalVar221 = temp_output_183_13;
					float ifLocalVar243 = 0;
					if( _SkinnedMeshMaterial <= 0.0 )
					{
						ifLocalVar243 = ifLocalVar221;
					}
					else
					{
						ifLocalVar243 = ( 0.35 * ifLocalVar221 );
					}
					float temp_output_278_0 = ( _RainEffectsMaterial * ( ( saturate( ( _RainIntensity * _RainIntensityRippleScale ) ) * saturate( ( max( dotResult230, 0.0 ) + max( dotResult227, 0.0 ) ) ) ) * ifLocalVar243 ) );
					float3 staticSwitch268 = ( float3 )0;
					#ifdef USERAIN
					{
						float3 color261 = IsGammaSpace() ? float3( 0, 0, 0 ) : float3( 0, 0, 0 );
						float3 lerpResult262 = lerp( temp_output_106_0 , color261 , ( temp_output_278_0 * _WetDropAlbedo ));
						staticSwitch268 = lerpResult262;
					}
					#else
					{
						staticSwitch268 = temp_output_106_0;
					}
					#endif
					#ifdef Rain
					float3 staticSwitch269 = staticSwitch268;
					#else
					float3 staticSwitch269 = temp_output_106_0;
					#endif
					float2 uv_BumpMap = IN.ase_texcoord5.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
					float3 tex2DNode49 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _BumpMap, sampler_BumpMap, uv_BumpMap ), _NormalIntensity );
					float2 appendResult16_g1 = (float2(tex2DNode25_g1.g , tex2DNode25_g1.b));
					float2 temp_output_183_0 = ( ( ( appendResult16_g1 * 2.0 ) - 1.0 ) * saturate( ( temp_output_34_0_g1 - 0.5 ) ) );
					float2 appendResult16_g9 = (float2(tex2DNode25_g9.g , tex2DNode25_g9.b));
					float2 appendResult16_g8 = (float2(tex2DNode25_g8.g , tex2DNode25_g8.b));
					float2 appendResult16_g7 = (float2(tex2DNode25_g7.g , tex2DNode25_g7.b));
					float2 staticSwitch220 = ( float2 )0;
					#ifdef TRIPLANAR
					{
						staticSwitch220 = ( ( temp_output_198_0 * ( ( ( appendResult16_g9 * 2.0 ) - 1.0 ) * saturate( ( temp_output_34_0_g9 - 0.5 ) ) ) ) + ( temp_output_199_0 * ( ( ( appendResult16_g8 * 2.0 ) - 1.0 ) * saturate( ( temp_output_34_0_g8 - 0.5 ) ) ) ) + ( temp_output_200_0 * ( ( ( appendResult16_g7 * 2.0 ) - 1.0 ) * saturate( ( temp_output_34_0_g7 - 0.5 ) ) ) ) );
					}
					#else
					{
						staticSwitch220 = temp_output_183_0;
					}
					#endif
					float3 staticSwitch271 = ( float3 )0;
					#ifdef USERAIN
					{
						float2 ifLocalVar223 = 0;
						if( _SkinnedMeshMaterial <= 0.0 )
						ifLocalVar223 = staticSwitch220;
						else
						ifLocalVar223 = temp_output_183_0;
						float3 appendResult249 = (float3(( 7.0 * ifLocalVar223 ) , 1.0));
						float3 normalizeResult251 = normalize( appendResult249 );
						float3 lerpResult264 = lerp( tex2DNode49 , normalizeResult251 , ( _WetDropNormal * temp_output_278_0 ));
						staticSwitch271 = lerpResult264;
					}
					#else
					{
						staticSwitch271 = tex2DNode49;
					}
					#endif
					#ifdef Rain
					float3 staticSwitch270 = staticSwitch271;
					#else
					float3 staticSwitch270 = tex2DNode49;
					#endif
					float3 tanToWorld0 = float3( TangentWS.x, BitangentWS.x, NormalWS.x );
					float3 tanToWorld1 = float3( TangentWS.y, BitangentWS.y, NormalWS.y );
					float3 tanToWorld2 = float3( TangentWS.z, BitangentWS.z, NormalWS.z );
					float3 ase_viewVectorTS =  tanToWorld0 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).x + tanToWorld1 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).y  + tanToWorld2 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).z;
					float3 ase_viewDirTS = normalize( ase_viewVectorTS );
					float3 normalizeResult132 = normalize( ase_viewDirTS );
					float dotResult130 = dot( staticSwitch270 , normalizeResult132 );
					float temp_output_133_0 = ( 1.0 - dotResult130 );
					float Angle_Ref137 = ( ( temp_output_133_0 * temp_output_133_0 ) * 0.5 );
					float3 Surface_Albedo284 = ( staticSwitch269 * ( ( Angle_Ref137 * _DiffuseAngularBoost ) + _DiffuseBaseStrength ) );
					float3 temp_cast_0 = (0.0).xxx;
					float temp_output_145_0 = ( ( ( Angle_Ref137 * _SpecularAngularBoost ) + _SpecularBaseStrength ) * 0.5 );
					float3 staticSwitch283 = ( float3 )0;
					#ifdef USEHEAT
					{
						float4 break289 = _HeatCenter;
						float3 appendResult291 = (float3(break289.x , break289.y , break289.z));
						float4 break290 = _HeatSize;
						float3 appendResult292 = (float3(break290.x , break290.y , break290.z));
						float temp_output_22_0_g293 = max( ( ( _HeatTemp - 30.0 ) * 0.1 ), 0.0 );
						float temp_output_24_0_g293 = ( max( ( 1.0 - length( ( ( IN.ase_texcoord6.xyz - appendResult291 ) / max( abs( appendResult292 ), 0.0001 ) ) ) ), 0.0 ) * ( temp_output_22_0_g293 * temp_output_22_0_g293 ) );
						float3 lerpResult25_g293 = lerp( _HeatColor1.rgb , _HeatColor2.rgb , temp_output_24_0_g293);
						float Specular_Angle_Response287 = temp_output_145_0;
						staticSwitch283 = ( ( ( lerpResult25_g293 * temp_output_24_0_g293 ) * _HeatVisibleFactor ) * Specular_Angle_Response287 );
					}
					#else
					{
						staticSwitch283 = temp_cast_0;
					}
					#endif
					float3 Localized_Heat_Radiance297 = staticSwitch283;
					float3 staticSwitch308 = ( float3 )0;
					#ifdef USEHEAT
					{
						staticSwitch308 = ( Surface_Albedo284 + ( Localized_Heat_Radiance297 * 10.0 ) );
					}
					#else
					{
						staticSwitch308 = ( Surface_Albedo284 * _ThermalSettingsMinMaxBaseInfluenceAdd.z );
					}
					#endif
					float4 break4_g309 = _ThermalSettingsMinMaxBaseInfluenceAdd;
					float ifLocalVar311 = 0;
					if( _ThermalVisionOn <= 0.0 )
					{
						ifLocalVar311 = 0.0;
					}
					else
					{
						ifLocalVar311 = 1.0;
					}
					float3 lerpResult312 = lerp( Surface_Albedo284 , ( min( max( staticSwitch308, ( break4_g309.x * _HeatThermalFactor ) ), break4_g309.y ) + break4_g309.w ) , ifLocalVar311);
					
					float3 Surface_Normal285 = staticSwitch270;
					
					float3 temp_cast_1 = (tex2DNode13.a).xxx;
					float3 lerpResult109 = lerp( temp_cast_1 , ( tex2DNode13.rgb * tex2DNode13.a ) , _SpecularColorIntensity);
					float3 temp_output_116_0 = ( lerpResult109 * _Glossness );
					float3 staticSwitch274 = ( float3 )0;
					#ifdef USERAIN
					{
						float3 color266 = IsGammaSpace() ? float3( 1, 1, 1 ) : float3( 1, 1, 1 );
						float3 lerpResult265 = lerp( temp_output_116_0 , color266 , ( _WetDropGlossness * temp_output_278_0 ));
						staticSwitch274 = lerpResult265;
					}
					#else
					{
						staticSwitch274 = temp_output_116_0;
					}
					#endif
					#ifdef Rain
					float3 staticSwitch275 = staticSwitch274;
					#else
					float3 staticSwitch275 = temp_output_116_0;
					#endif
					
					float2 uv_SpecMap = IN.ase_texcoord5.xy * _SpecMap_ST.xy + _SpecMap_ST.zw;
					float4 tex2DNode11 = SAMPLE_TEXTURE2D( _SpecMap, sampler_SpecMap, uv_SpecMap );
					float3 temp_cast_2 = (tex2DNode11.g).xxx;
					#ifdef _USEBSGGLOSS_ON
					float3 staticSwitch123 = tex2DNode11.rgb;
					#else
					float3 staticSwitch123 = temp_cast_2;
					#endif
					float3 temp_output_85_0 = ( staticSwitch123 * _Specularness );
					float3 staticSwitch272 = ( float3 )0;
					#ifdef USERAIN
					{
						float3 temp_cast_3 = (1.0).xxx;
						float3 lerpResult263 = lerp( temp_output_85_0 , temp_cast_3 , ( _WetDropSpecular * temp_output_278_0 ));
						staticSwitch272 = lerpResult263;
					}
					#else
					{
						staticSwitch272 = temp_output_85_0;
					}
					#endif
					#ifdef Rain
					float3 staticSwitch273 = staticSwitch272;
					#else
					float3 staticSwitch273 = temp_output_85_0;
					#endif
					
					float staticSwitch124 = ( float )0;
					#ifdef _USEBSGGLOSS_ON
					{
						staticSwitch124 = 1.0;
					}
					#else
					{
						staticSwitch124 = tex2DNode11.r;
					}
					#endif
					
					float3 Visible_Heat_Emission300 = ( Localized_Heat_Radiance297 * _HeatVisible );
					float staticSwitch319 = ( float )0;
					#ifdef USERAIN
					{
						float staticSwitch318 = ( float )0;
						#ifdef FAKERIPPLELIGHT
						{
							float3 tanNormal314 = Surface_Normal285;
							float3 worldNormal314 = float3( dot( tanToWorld0, tanNormal314 ), dot( tanToWorld1, tanNormal314 ), dot( tanToWorld2, tanNormal314 ) );
							float3 temp_output_4_0_g316 = _SunDirection.xyz;
							float3 temp_output_14_0_g316 = ( temp_output_4_0_g316 * -1.0 );
							float dotResult18_g316 = dot( worldNormal314 , ( temp_output_14_0_g316 / max( length( temp_output_14_0_g316 ), 0.0001 ) ) );
							float Material_Drop_Mask286 = ifLocalVar243;
							float3 break27_g316 = Surface_Normal285;
							float2 appendResult28_g316 = (float2(break27_g316.x , break27_g316.y));
							float ifLocalVar30_g316 = 0;
							if( length( appendResult28_g316 ) <= 0.32 )
							ifLocalVar30_g316 = 0.0;
							else
							ifLocalVar30_g316 = 1.0;
							float ifLocalVar31_g316 = 0;
							if( break27_g316.x <= 0.0 )
							ifLocalVar31_g316 = 0.0;
							else
							ifLocalVar31_g316 = 1.0;
							staticSwitch318 = ( ( ( ( ( saturate( ( max( dotResult18_g316, 0.0 ) + _NdotLOffset ) ) * ceil( ( Material_Drop_Mask286 - _RippleFakeLightIntensityOffset ) ) ) * saturate( ( _NightRippleFakeLightOffset - temp_output_4_0_g316.y ) ) ) * ( ifLocalVar30_g316 * ifLocalVar31_g316 ) ) * _RippleFakeLightIntensity ) * _RainEffectsMaterial );
						}
						#else
						{
							staticSwitch318 = 0.0;
						}
						#endif
						staticSwitch319 = staticSwitch318;
					}
					#else
					{
						staticSwitch319 = 0.0;
					}
					#endif
					#ifdef Rain
					float staticSwitch320 = staticSwitch319;
					#else
					float staticSwitch320 = 0.0;
					#endif
					float Rain_Highlight_Emission321 = staticSwitch320;
					

					o.Albedo = lerpResult312;
					o.Normal = Surface_Normal285;

					half3 Specular = saturate( ( temp_output_145_0 * staticSwitch275 ) );
					half Metallic = 0;
					half Smoothness = staticSwitch273.x;
					half Occlusion = staticSwitch124;

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

					o.Emission = ( Visible_Heat_Emission300 + Rain_Highlight_Emission321 );
					o.Alpha = 1;
					half AlphaClipThreshold = 0.5;
					half3 Transmission = 1;
					half3 Translucency = 1;

					#if defined( ASE_WRITE_DEPTH )
						IN.pos.z = IN.pos.z;
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

					#if defined( ASE_WRITE_DEPTH )
						outputDepth = IN.pos.z;
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
					gi.light.color *= LightAtten;

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
				#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
				#pragma shader_feature_local_fragment _GLOSSYREFLECTIONS_OFF
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
				#define _SPECULAR_SETUP 1
				#define ASE_VERSION 19914
				#define ASE_USING_SAMPLING_MACROS 1

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
				#define ASE_NEEDS_FRAG_NORMAL
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
				#define ASE_NEEDS_WORLD_POSITION
				#define ASE_NEEDS_FRAG_WORLD_POSITION
				#define ASE_NEEDS_WORLD_TANGENT
				#define ASE_NEEDS_FRAG_WORLD_TANGENT
				#define ASE_NEEDS_WORLD_NORMAL
				#define ASE_NEEDS_FRAG_WORLD_NORMAL
				#define ASE_NEEDS_FRAG_WORLD_BITANGENT
				#define ASE_NEEDS_FRAG_POSITION
				#pragma multi_compile _ Rain
				#pragma multi_compile _ USERAIN
				#pragma multi_compile _ TRIPLANAR
				#pragma multi_compile _ USEHEAT
				#pragma shader_feature_local _USEBSGGLOSS_ON
				#pragma multi_compile _ FAKERIPPLELIGHT
				#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
				#else//ASE Sampling Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
				#endif//ASE Sampling Macros
				


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
					half3 normal : NORMAL;
					half4 tangent : TANGENT;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					ASE_SV_POSITION_QUALIFIERS float4 pos : SV_POSITION;
					float4 worldPos : TEXCOORD0; // xyz = positionWS, w = fogCoord
					half3 normalWS : TEXCOORD1;
					float4 tangentWS : TEXCOORD2; // holds terrainUV ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					half4 ambientOrLightmapUV : TEXCOORD3;
					float4 ase_texcoord4 : TEXCOORD4;
					float3 ase_normal : NORMAL;
					float4 ase_texcoord5 : TEXCOORD5;
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

				uniform float _StencilType;
				uniform float _DropsSpec;
				uniform float3 _Color;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_MainTex);
				uniform float4 _MainTex_ST;
				SamplerState sampler_MainTex;
				uniform float _RainEffectsMaterial;
				uniform float _RainIntensity;
				uniform float _RainIntensityRippleScale;
				uniform float3 _LocalRainAverage;
				uniform float3 _LocalRain;
				uniform float _SkinnedMeshMaterial;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_RippleTexture);
				uniform float _RippleTexScale;
				SamplerState sampler_RippleTexture;
				uniform float3 _EnvironmentRippleCycle;
				uniform float _WetDropAlbedo;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_BumpMap);
				uniform float4 _BumpMap_ST;
				SamplerState sampler_BumpMap;
				uniform float _NormalIntensity;
				uniform float _WetDropNormal;
				uniform float _DiffuseAngularBoost;
				uniform float _DiffuseBaseStrength;
				uniform float4 _ThermalSettingsMinMaxBaseInfluenceAdd;
				uniform float _SpecularAngularBoost;
				uniform float _SpecularBaseStrength;
				uniform float4 _HeatColor1;
				uniform float4 _HeatColor2;
				uniform float4 _HeatCenter;
				uniform float4 _HeatSize;
				uniform float _HeatTemp;
				uniform float _HeatVisibleFactor;
				uniform float _HeatThermalFactor;
				uniform float _ThermalVisionOn;
				uniform float _SpecularColorIntensity;
				uniform float _Glossness;
				uniform float _WetDropGlossness;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_SpecMap);
				uniform float4 _SpecMap_ST;
				SamplerState sampler_SpecMap;
				uniform float _Specularness;
				uniform float _WetDropSpecular;
				uniform float _HeatVisible;
				uniform float4 _SunDirection;
				uniform float _NdotLOffset;
				uniform float _RippleFakeLightIntensityOffset;
				uniform float _NightRippleFakeLightOffset;
				uniform float _RippleFakeLightIntensity;


				
				v2f VertexFunction (appdata v  ) {
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					o.ase_texcoord4.xy = v.texcoord.xyzw.xy;
					o.ase_normal = v.normal;
					o.ase_texcoord5 = v.vertex;
					
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
					#if defined( ASE_WRITE_DEPTH )
					, out float outputDepth : ASE_SV_DEPTH
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

					float2 uv_MainTex = IN.ase_texcoord4.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					float4 tex2DNode13 = SAMPLE_TEXTURE2D( _MainTex, sampler_MainTex, uv_MainTex );
					float3 temp_output_106_0 = ( _Color * tex2DNode13.rgb );
					float dotResult230 = dot( IN.ase_normal , _LocalRainAverage );
					float dotResult227 = dot( IN.ase_normal , _LocalRain );
					float4 tex2DNode25_g1 = SAMPLE_TEXTURE2D( _RippleTexture, sampler_RippleTexture, ( uv_MainTex / _RippleTexScale ) );
					float temp_output_34_0_g1 = ( tex2DNode25_g1.r * saturate( ( 1.0 - ( fmod( ( ( ( tex2DNode25_g1.a * _EnvironmentRippleCycle.y ) + _EnvironmentRippleCycle.x ) / _EnvironmentRippleCycle.y ) , 1.0 ) * _EnvironmentRippleCycle.y ) ) ) * _EnvironmentRippleCycle.z );
					float temp_output_183_13 = temp_output_34_0_g1;
					float3 break196 = max( ( abs( IN.ase_normal ) - 0.49 ), 0.0 );
					float temp_output_197_0 = ( break196.x + break196.y + break196.z );
					float temp_output_198_0 = ( break196.x / temp_output_197_0 );
					float3 break202 = ( IN.ase_texcoord5.xyz * _RippleTexScale );
					float2 appendResult203 = (float2(break202.y , break202.z));
					float4 tex2DNode25_g9 = SAMPLE_TEXTURE2D( _RippleTexture, sampler_RippleTexture, appendResult203 );
					float temp_output_34_0_g9 = ( tex2DNode25_g9.r * saturate( ( 1.0 - ( fmod( ( ( ( tex2DNode25_g9.a * _EnvironmentRippleCycle.y ) + _EnvironmentRippleCycle.x ) / _EnvironmentRippleCycle.y ) , 1.0 ) * _EnvironmentRippleCycle.y ) ) ) * _EnvironmentRippleCycle.z );
					float temp_output_199_0 = ( break196.y / temp_output_197_0 );
					float2 appendResult205 = (float2(break202.z , break202.x));
					float4 tex2DNode25_g8 = SAMPLE_TEXTURE2D( _RippleTexture, sampler_RippleTexture, appendResult205 );
					float temp_output_34_0_g8 = ( tex2DNode25_g8.r * saturate( ( 1.0 - ( fmod( ( ( ( tex2DNode25_g8.a * _EnvironmentRippleCycle.y ) + _EnvironmentRippleCycle.x ) / _EnvironmentRippleCycle.y ) , 1.0 ) * _EnvironmentRippleCycle.y ) ) ) * _EnvironmentRippleCycle.z );
					float temp_output_200_0 = ( break196.z / temp_output_197_0 );
					float2 appendResult207 = (float2(break202.x , break202.y));
					float4 tex2DNode25_g7 = SAMPLE_TEXTURE2D( _RippleTexture, sampler_RippleTexture, appendResult207 );
					float temp_output_34_0_g7 = ( tex2DNode25_g7.r * saturate( ( 1.0 - ( fmod( ( ( ( tex2DNode25_g7.a * _EnvironmentRippleCycle.y ) + _EnvironmentRippleCycle.x ) / _EnvironmentRippleCycle.y ) , 1.0 ) * _EnvironmentRippleCycle.y ) ) ) * _EnvironmentRippleCycle.z );
					float staticSwitch219 = ( float )0;
					#ifdef TRIPLANAR
					{
						staticSwitch219 = ( ( temp_output_198_0 * temp_output_34_0_g9 ) + ( temp_output_199_0 * temp_output_34_0_g8 ) + ( temp_output_200_0 * temp_output_34_0_g7 ) );
					}
					#else
					{
						staticSwitch219 = temp_output_183_13;
					}
					#endif
					float ifLocalVar221 = 0;
					if( _SkinnedMeshMaterial <= 0.0 )
					ifLocalVar221 = staticSwitch219;
					else
					ifLocalVar221 = temp_output_183_13;
					float ifLocalVar243 = 0;
					if( _SkinnedMeshMaterial <= 0.0 )
					{
						ifLocalVar243 = ifLocalVar221;
					}
					else
					{
						ifLocalVar243 = ( 0.35 * ifLocalVar221 );
					}
					float temp_output_278_0 = ( _RainEffectsMaterial * ( ( saturate( ( _RainIntensity * _RainIntensityRippleScale ) ) * saturate( ( max( dotResult230, 0.0 ) + max( dotResult227, 0.0 ) ) ) ) * ifLocalVar243 ) );
					float3 staticSwitch268 = ( float3 )0;
					#ifdef USERAIN
					{
						float3 color261 = IsGammaSpace() ? float3( 0, 0, 0 ) : float3( 0, 0, 0 );
						float3 lerpResult262 = lerp( temp_output_106_0 , color261 , ( temp_output_278_0 * _WetDropAlbedo ));
						staticSwitch268 = lerpResult262;
					}
					#else
					{
						staticSwitch268 = temp_output_106_0;
					}
					#endif
					#ifdef Rain
					float3 staticSwitch269 = staticSwitch268;
					#else
					float3 staticSwitch269 = temp_output_106_0;
					#endif
					float2 uv_BumpMap = IN.ase_texcoord4.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
					float3 tex2DNode49 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _BumpMap, sampler_BumpMap, uv_BumpMap ), _NormalIntensity );
					float2 appendResult16_g1 = (float2(tex2DNode25_g1.g , tex2DNode25_g1.b));
					float2 temp_output_183_0 = ( ( ( appendResult16_g1 * 2.0 ) - 1.0 ) * saturate( ( temp_output_34_0_g1 - 0.5 ) ) );
					float2 appendResult16_g9 = (float2(tex2DNode25_g9.g , tex2DNode25_g9.b));
					float2 appendResult16_g8 = (float2(tex2DNode25_g8.g , tex2DNode25_g8.b));
					float2 appendResult16_g7 = (float2(tex2DNode25_g7.g , tex2DNode25_g7.b));
					float2 staticSwitch220 = ( float2 )0;
					#ifdef TRIPLANAR
					{
						staticSwitch220 = ( ( temp_output_198_0 * ( ( ( appendResult16_g9 * 2.0 ) - 1.0 ) * saturate( ( temp_output_34_0_g9 - 0.5 ) ) ) ) + ( temp_output_199_0 * ( ( ( appendResult16_g8 * 2.0 ) - 1.0 ) * saturate( ( temp_output_34_0_g8 - 0.5 ) ) ) ) + ( temp_output_200_0 * ( ( ( appendResult16_g7 * 2.0 ) - 1.0 ) * saturate( ( temp_output_34_0_g7 - 0.5 ) ) ) ) );
					}
					#else
					{
						staticSwitch220 = temp_output_183_0;
					}
					#endif
					float3 staticSwitch271 = ( float3 )0;
					#ifdef USERAIN
					{
						float2 ifLocalVar223 = 0;
						if( _SkinnedMeshMaterial <= 0.0 )
						ifLocalVar223 = staticSwitch220;
						else
						ifLocalVar223 = temp_output_183_0;
						float3 appendResult249 = (float3(( 7.0 * ifLocalVar223 ) , 1.0));
						float3 normalizeResult251 = normalize( appendResult249 );
						float3 lerpResult264 = lerp( tex2DNode49 , normalizeResult251 , ( _WetDropNormal * temp_output_278_0 ));
						staticSwitch271 = lerpResult264;
					}
					#else
					{
						staticSwitch271 = tex2DNode49;
					}
					#endif
					#ifdef Rain
					float3 staticSwitch270 = staticSwitch271;
					#else
					float3 staticSwitch270 = tex2DNode49;
					#endif
					float3 tanToWorld0 = float3( TangentWS.x, BitangentWS.x, NormalWS.x );
					float3 tanToWorld1 = float3( TangentWS.y, BitangentWS.y, NormalWS.y );
					float3 tanToWorld2 = float3( TangentWS.z, BitangentWS.z, NormalWS.z );
					float3 ase_viewVectorTS =  tanToWorld0 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).x + tanToWorld1 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).y  + tanToWorld2 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).z;
					float3 ase_viewDirTS = normalize( ase_viewVectorTS );
					float3 normalizeResult132 = normalize( ase_viewDirTS );
					float dotResult130 = dot( staticSwitch270 , normalizeResult132 );
					float temp_output_133_0 = ( 1.0 - dotResult130 );
					float Angle_Ref137 = ( ( temp_output_133_0 * temp_output_133_0 ) * 0.5 );
					float3 Surface_Albedo284 = ( staticSwitch269 * ( ( Angle_Ref137 * _DiffuseAngularBoost ) + _DiffuseBaseStrength ) );
					float3 temp_cast_0 = (0.0).xxx;
					float temp_output_145_0 = ( ( ( Angle_Ref137 * _SpecularAngularBoost ) + _SpecularBaseStrength ) * 0.5 );
					float3 staticSwitch283 = ( float3 )0;
					#ifdef USEHEAT
					{
						float4 break289 = _HeatCenter;
						float3 appendResult291 = (float3(break289.x , break289.y , break289.z));
						float4 break290 = _HeatSize;
						float3 appendResult292 = (float3(break290.x , break290.y , break290.z));
						float temp_output_22_0_g293 = max( ( ( _HeatTemp - 30.0 ) * 0.1 ), 0.0 );
						float temp_output_24_0_g293 = ( max( ( 1.0 - length( ( ( IN.ase_texcoord5.xyz - appendResult291 ) / max( abs( appendResult292 ), 0.0001 ) ) ) ), 0.0 ) * ( temp_output_22_0_g293 * temp_output_22_0_g293 ) );
						float3 lerpResult25_g293 = lerp( _HeatColor1.rgb , _HeatColor2.rgb , temp_output_24_0_g293);
						float Specular_Angle_Response287 = temp_output_145_0;
						staticSwitch283 = ( ( ( lerpResult25_g293 * temp_output_24_0_g293 ) * _HeatVisibleFactor ) * Specular_Angle_Response287 );
					}
					#else
					{
						staticSwitch283 = temp_cast_0;
					}
					#endif
					float3 Localized_Heat_Radiance297 = staticSwitch283;
					float3 staticSwitch308 = ( float3 )0;
					#ifdef USEHEAT
					{
						staticSwitch308 = ( Surface_Albedo284 + ( Localized_Heat_Radiance297 * 10.0 ) );
					}
					#else
					{
						staticSwitch308 = ( Surface_Albedo284 * _ThermalSettingsMinMaxBaseInfluenceAdd.z );
					}
					#endif
					float4 break4_g309 = _ThermalSettingsMinMaxBaseInfluenceAdd;
					float ifLocalVar311 = 0;
					if( _ThermalVisionOn <= 0.0 )
					{
						ifLocalVar311 = 0.0;
					}
					else
					{
						ifLocalVar311 = 1.0;
					}
					float3 lerpResult312 = lerp( Surface_Albedo284 , ( min( max( staticSwitch308, ( break4_g309.x * _HeatThermalFactor ) ), break4_g309.y ) + break4_g309.w ) , ifLocalVar311);
					
					float3 Surface_Normal285 = staticSwitch270;
					
					float3 temp_cast_1 = (tex2DNode13.a).xxx;
					float3 lerpResult109 = lerp( temp_cast_1 , ( tex2DNode13.rgb * tex2DNode13.a ) , _SpecularColorIntensity);
					float3 temp_output_116_0 = ( lerpResult109 * _Glossness );
					float3 staticSwitch274 = ( float3 )0;
					#ifdef USERAIN
					{
						float3 color266 = IsGammaSpace() ? float3( 1, 1, 1 ) : float3( 1, 1, 1 );
						float3 lerpResult265 = lerp( temp_output_116_0 , color266 , ( _WetDropGlossness * temp_output_278_0 ));
						staticSwitch274 = lerpResult265;
					}
					#else
					{
						staticSwitch274 = temp_output_116_0;
					}
					#endif
					#ifdef Rain
					float3 staticSwitch275 = staticSwitch274;
					#else
					float3 staticSwitch275 = temp_output_116_0;
					#endif
					
					float2 uv_SpecMap = IN.ase_texcoord4.xy * _SpecMap_ST.xy + _SpecMap_ST.zw;
					float4 tex2DNode11 = SAMPLE_TEXTURE2D( _SpecMap, sampler_SpecMap, uv_SpecMap );
					float3 temp_cast_2 = (tex2DNode11.g).xxx;
					#ifdef _USEBSGGLOSS_ON
					float3 staticSwitch123 = tex2DNode11.rgb;
					#else
					float3 staticSwitch123 = temp_cast_2;
					#endif
					float3 temp_output_85_0 = ( staticSwitch123 * _Specularness );
					float3 staticSwitch272 = ( float3 )0;
					#ifdef USERAIN
					{
						float3 temp_cast_3 = (1.0).xxx;
						float3 lerpResult263 = lerp( temp_output_85_0 , temp_cast_3 , ( _WetDropSpecular * temp_output_278_0 ));
						staticSwitch272 = lerpResult263;
					}
					#else
					{
						staticSwitch272 = temp_output_85_0;
					}
					#endif
					#ifdef Rain
					float3 staticSwitch273 = staticSwitch272;
					#else
					float3 staticSwitch273 = temp_output_85_0;
					#endif
					
					float staticSwitch124 = ( float )0;
					#ifdef _USEBSGGLOSS_ON
					{
						staticSwitch124 = 1.0;
					}
					#else
					{
						staticSwitch124 = tex2DNode11.r;
					}
					#endif
					
					float3 Visible_Heat_Emission300 = ( Localized_Heat_Radiance297 * _HeatVisible );
					float staticSwitch319 = ( float )0;
					#ifdef USERAIN
					{
						float staticSwitch318 = ( float )0;
						#ifdef FAKERIPPLELIGHT
						{
							float3 tanNormal314 = Surface_Normal285;
							float3 worldNormal314 = float3( dot( tanToWorld0, tanNormal314 ), dot( tanToWorld1, tanNormal314 ), dot( tanToWorld2, tanNormal314 ) );
							float3 temp_output_4_0_g316 = _SunDirection.xyz;
							float3 temp_output_14_0_g316 = ( temp_output_4_0_g316 * -1.0 );
							float dotResult18_g316 = dot( worldNormal314 , ( temp_output_14_0_g316 / max( length( temp_output_14_0_g316 ), 0.0001 ) ) );
							float Material_Drop_Mask286 = ifLocalVar243;
							float3 break27_g316 = Surface_Normal285;
							float2 appendResult28_g316 = (float2(break27_g316.x , break27_g316.y));
							float ifLocalVar30_g316 = 0;
							if( length( appendResult28_g316 ) <= 0.32 )
							ifLocalVar30_g316 = 0.0;
							else
							ifLocalVar30_g316 = 1.0;
							float ifLocalVar31_g316 = 0;
							if( break27_g316.x <= 0.0 )
							ifLocalVar31_g316 = 0.0;
							else
							ifLocalVar31_g316 = 1.0;
							staticSwitch318 = ( ( ( ( ( saturate( ( max( dotResult18_g316, 0.0 ) + _NdotLOffset ) ) * ceil( ( Material_Drop_Mask286 - _RippleFakeLightIntensityOffset ) ) ) * saturate( ( _NightRippleFakeLightOffset - temp_output_4_0_g316.y ) ) ) * ( ifLocalVar30_g316 * ifLocalVar31_g316 ) ) * _RippleFakeLightIntensity ) * _RainEffectsMaterial );
						}
						#else
						{
							staticSwitch318 = 0.0;
						}
						#endif
						staticSwitch319 = staticSwitch318;
					}
					#else
					{
						staticSwitch319 = 0.0;
					}
					#endif
					#ifdef Rain
					float staticSwitch320 = staticSwitch319;
					#else
					float staticSwitch320 = 0.0;
					#endif
					float Rain_Highlight_Emission321 = staticSwitch320;
					

					o.Albedo = lerpResult312;
					o.Normal = Surface_Normal285;

					half3 Specular = saturate( ( temp_output_145_0 * staticSwitch275 ) );
					half Metallic = 0;
					half Smoothness = staticSwitch273.x;
					half Occlusion = staticSwitch124;

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

					o.Emission = ( Visible_Heat_Emission300 + Rain_Highlight_Emission321 );
					o.Alpha = 1;
					half AlphaClipThreshold = 0.5;
					half3 BakedGI = 0;

					#if defined( ASE_WRITE_DEPTH )
						IN.pos.z = IN.pos.z;
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

					#if defined( ASE_WRITE_DEPTH )
						outputDepth = IN.pos.z;
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
				#define _SPECULAR_SETUP 1
				#define ASE_VERSION 19914
				#define ASE_USING_SAMPLING_MACROS 1

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

				#include "UnityStandardUtils.cginc"
				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_NORMAL
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
				#define ASE_NEEDS_VERT_TANGENT
				#define ASE_NEEDS_VERT_NORMAL
				#define ASE_NEEDS_FRAG_POSITION
				#pragma multi_compile _ Rain
				#pragma multi_compile _ USERAIN
				#pragma multi_compile _ TRIPLANAR
				#pragma multi_compile _ USEHEAT
				#pragma multi_compile _ FAKERIPPLELIGHT
				#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
				#else//ASE Sampling Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
				#endif//ASE Sampling Macros
				


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
					float3 ase_normal : NORMAL;
					float4 ase_texcoord3 : TEXCOORD3;
					float4 ase_texcoord4 : TEXCOORD4;
					float4 ase_texcoord5 : TEXCOORD5;
					float4 ase_texcoord6 : TEXCOORD6;
					float4 ase_texcoord7 : TEXCOORD7;
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

				uniform float _StencilType;
				uniform float _DropsSpec;
				uniform float3 _Color;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_MainTex);
				uniform float4 _MainTex_ST;
				SamplerState sampler_MainTex;
				uniform float _RainEffectsMaterial;
				uniform float _RainIntensity;
				uniform float _RainIntensityRippleScale;
				uniform float3 _LocalRainAverage;
				uniform float3 _LocalRain;
				uniform float _SkinnedMeshMaterial;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_RippleTexture);
				uniform float _RippleTexScale;
				SamplerState sampler_RippleTexture;
				uniform float3 _EnvironmentRippleCycle;
				uniform float _WetDropAlbedo;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_BumpMap);
				uniform float4 _BumpMap_ST;
				SamplerState sampler_BumpMap;
				uniform float _NormalIntensity;
				uniform float _WetDropNormal;
				uniform float _DiffuseAngularBoost;
				uniform float _DiffuseBaseStrength;
				uniform float4 _ThermalSettingsMinMaxBaseInfluenceAdd;
				uniform float _SpecularAngularBoost;
				uniform float _SpecularBaseStrength;
				uniform float4 _HeatColor1;
				uniform float4 _HeatColor2;
				uniform float4 _HeatCenter;
				uniform float4 _HeatSize;
				uniform float _HeatTemp;
				uniform float _HeatVisibleFactor;
				uniform float _HeatThermalFactor;
				uniform float _ThermalVisionOn;
				uniform float _HeatVisible;
				uniform float4 _SunDirection;
				uniform float _NdotLOffset;
				uniform float _RippleFakeLightIntensityOffset;
				uniform float _NightRippleFakeLightOffset;
				uniform float _RippleFakeLightIntensity;


				
				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					float3 ase_positionWS = mul( unity_ObjectToWorld, float4( ( v.vertex ).xyz, 1 ) ).xyz;
					o.ase_texcoord4.xyz = ase_positionWS;
					float3 ase_tangentWS = UnityObjectToWorldDir( v.tangent );
					o.ase_texcoord5.xyz = ase_tangentWS;
					float3 ase_normalWS = UnityObjectToWorldNormal( v.normal );
					o.ase_texcoord6.xyz = ase_normalWS;
					float ase_tangentSign = v.tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
					float3 ase_bitangentWS = cross( ase_normalWS, ase_tangentWS ) * ase_tangentSign;
					o.ase_texcoord7.xyz = ase_bitangentWS;
					
					o.ase_texcoord2.xy = v.texcoord.xyzw.xy;
					o.ase_normal = v.normal;
					o.ase_texcoord3 = v.vertex;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord2.zw = 0;
					o.ase_texcoord4.w = 0;
					o.ase_texcoord5.w = 0;
					o.ase_texcoord6.w = 0;
					o.ase_texcoord7.w = 0;

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

					float2 uv_MainTex = IN.ase_texcoord2.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					float4 tex2DNode13 = SAMPLE_TEXTURE2D( _MainTex, sampler_MainTex, uv_MainTex );
					float3 temp_output_106_0 = ( _Color * tex2DNode13.rgb );
					float dotResult230 = dot( IN.ase_normal , _LocalRainAverage );
					float dotResult227 = dot( IN.ase_normal , _LocalRain );
					float4 tex2DNode25_g1 = SAMPLE_TEXTURE2D( _RippleTexture, sampler_RippleTexture, ( uv_MainTex / _RippleTexScale ) );
					float temp_output_34_0_g1 = ( tex2DNode25_g1.r * saturate( ( 1.0 - ( fmod( ( ( ( tex2DNode25_g1.a * _EnvironmentRippleCycle.y ) + _EnvironmentRippleCycle.x ) / _EnvironmentRippleCycle.y ) , 1.0 ) * _EnvironmentRippleCycle.y ) ) ) * _EnvironmentRippleCycle.z );
					float temp_output_183_13 = temp_output_34_0_g1;
					float3 break196 = max( ( abs( IN.ase_normal ) - 0.49 ), 0.0 );
					float temp_output_197_0 = ( break196.x + break196.y + break196.z );
					float temp_output_198_0 = ( break196.x / temp_output_197_0 );
					float3 break202 = ( IN.ase_texcoord3.xyz * _RippleTexScale );
					float2 appendResult203 = (float2(break202.y , break202.z));
					float4 tex2DNode25_g9 = SAMPLE_TEXTURE2D( _RippleTexture, sampler_RippleTexture, appendResult203 );
					float temp_output_34_0_g9 = ( tex2DNode25_g9.r * saturate( ( 1.0 - ( fmod( ( ( ( tex2DNode25_g9.a * _EnvironmentRippleCycle.y ) + _EnvironmentRippleCycle.x ) / _EnvironmentRippleCycle.y ) , 1.0 ) * _EnvironmentRippleCycle.y ) ) ) * _EnvironmentRippleCycle.z );
					float temp_output_199_0 = ( break196.y / temp_output_197_0 );
					float2 appendResult205 = (float2(break202.z , break202.x));
					float4 tex2DNode25_g8 = SAMPLE_TEXTURE2D( _RippleTexture, sampler_RippleTexture, appendResult205 );
					float temp_output_34_0_g8 = ( tex2DNode25_g8.r * saturate( ( 1.0 - ( fmod( ( ( ( tex2DNode25_g8.a * _EnvironmentRippleCycle.y ) + _EnvironmentRippleCycle.x ) / _EnvironmentRippleCycle.y ) , 1.0 ) * _EnvironmentRippleCycle.y ) ) ) * _EnvironmentRippleCycle.z );
					float temp_output_200_0 = ( break196.z / temp_output_197_0 );
					float2 appendResult207 = (float2(break202.x , break202.y));
					float4 tex2DNode25_g7 = SAMPLE_TEXTURE2D( _RippleTexture, sampler_RippleTexture, appendResult207 );
					float temp_output_34_0_g7 = ( tex2DNode25_g7.r * saturate( ( 1.0 - ( fmod( ( ( ( tex2DNode25_g7.a * _EnvironmentRippleCycle.y ) + _EnvironmentRippleCycle.x ) / _EnvironmentRippleCycle.y ) , 1.0 ) * _EnvironmentRippleCycle.y ) ) ) * _EnvironmentRippleCycle.z );
					float staticSwitch219 = ( float )0;
					#ifdef TRIPLANAR
					{
						staticSwitch219 = ( ( temp_output_198_0 * temp_output_34_0_g9 ) + ( temp_output_199_0 * temp_output_34_0_g8 ) + ( temp_output_200_0 * temp_output_34_0_g7 ) );
					}
					#else
					{
						staticSwitch219 = temp_output_183_13;
					}
					#endif
					float ifLocalVar221 = 0;
					if( _SkinnedMeshMaterial <= 0.0 )
					ifLocalVar221 = staticSwitch219;
					else
					ifLocalVar221 = temp_output_183_13;
					float ifLocalVar243 = 0;
					if( _SkinnedMeshMaterial <= 0.0 )
					{
						ifLocalVar243 = ifLocalVar221;
					}
					else
					{
						ifLocalVar243 = ( 0.35 * ifLocalVar221 );
					}
					float temp_output_278_0 = ( _RainEffectsMaterial * ( ( saturate( ( _RainIntensity * _RainIntensityRippleScale ) ) * saturate( ( max( dotResult230, 0.0 ) + max( dotResult227, 0.0 ) ) ) ) * ifLocalVar243 ) );
					float3 staticSwitch268 = ( float3 )0;
					#ifdef USERAIN
					{
						float3 color261 = IsGammaSpace() ? float3( 0, 0, 0 ) : float3( 0, 0, 0 );
						float3 lerpResult262 = lerp( temp_output_106_0 , color261 , ( temp_output_278_0 * _WetDropAlbedo ));
						staticSwitch268 = lerpResult262;
					}
					#else
					{
						staticSwitch268 = temp_output_106_0;
					}
					#endif
					#ifdef Rain
					float3 staticSwitch269 = staticSwitch268;
					#else
					float3 staticSwitch269 = temp_output_106_0;
					#endif
					float2 uv_BumpMap = IN.ase_texcoord2.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
					float3 tex2DNode49 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _BumpMap, sampler_BumpMap, uv_BumpMap ), _NormalIntensity );
					float2 appendResult16_g1 = (float2(tex2DNode25_g1.g , tex2DNode25_g1.b));
					float2 temp_output_183_0 = ( ( ( appendResult16_g1 * 2.0 ) - 1.0 ) * saturate( ( temp_output_34_0_g1 - 0.5 ) ) );
					float2 appendResult16_g9 = (float2(tex2DNode25_g9.g , tex2DNode25_g9.b));
					float2 appendResult16_g8 = (float2(tex2DNode25_g8.g , tex2DNode25_g8.b));
					float2 appendResult16_g7 = (float2(tex2DNode25_g7.g , tex2DNode25_g7.b));
					float2 staticSwitch220 = ( float2 )0;
					#ifdef TRIPLANAR
					{
						staticSwitch220 = ( ( temp_output_198_0 * ( ( ( appendResult16_g9 * 2.0 ) - 1.0 ) * saturate( ( temp_output_34_0_g9 - 0.5 ) ) ) ) + ( temp_output_199_0 * ( ( ( appendResult16_g8 * 2.0 ) - 1.0 ) * saturate( ( temp_output_34_0_g8 - 0.5 ) ) ) ) + ( temp_output_200_0 * ( ( ( appendResult16_g7 * 2.0 ) - 1.0 ) * saturate( ( temp_output_34_0_g7 - 0.5 ) ) ) ) );
					}
					#else
					{
						staticSwitch220 = temp_output_183_0;
					}
					#endif
					float3 staticSwitch271 = ( float3 )0;
					#ifdef USERAIN
					{
						float2 ifLocalVar223 = 0;
						if( _SkinnedMeshMaterial <= 0.0 )
						ifLocalVar223 = staticSwitch220;
						else
						ifLocalVar223 = temp_output_183_0;
						float3 appendResult249 = (float3(( 7.0 * ifLocalVar223 ) , 1.0));
						float3 normalizeResult251 = normalize( appendResult249 );
						float3 lerpResult264 = lerp( tex2DNode49 , normalizeResult251 , ( _WetDropNormal * temp_output_278_0 ));
						staticSwitch271 = lerpResult264;
					}
					#else
					{
						staticSwitch271 = tex2DNode49;
					}
					#endif
					#ifdef Rain
					float3 staticSwitch270 = staticSwitch271;
					#else
					float3 staticSwitch270 = tex2DNode49;
					#endif
					float3 ase_positionWS = IN.ase_texcoord4.xyz;
					float3 ase_tangentWS = IN.ase_texcoord5.xyz;
					float3 ase_normalWS = IN.ase_texcoord6.xyz;
					float3 ase_bitangentWS = IN.ase_texcoord7.xyz;
					float3 tanToWorld0 = float3( ase_tangentWS.x, ase_bitangentWS.x, ase_normalWS.x );
					float3 tanToWorld1 = float3( ase_tangentWS.y, ase_bitangentWS.y, ase_normalWS.y );
					float3 tanToWorld2 = float3( ase_tangentWS.z, ase_bitangentWS.z, ase_normalWS.z );
					float3 ase_viewVectorTS =  tanToWorld0 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - ase_positionWS : UNITY_MATRIX_V[ 2 ].xyz ).x + tanToWorld1 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - ase_positionWS : UNITY_MATRIX_V[ 2 ].xyz ).y  + tanToWorld2 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - ase_positionWS : UNITY_MATRIX_V[ 2 ].xyz ).z;
					float3 ase_viewDirTS = normalize( ase_viewVectorTS );
					float3 normalizeResult132 = normalize( ase_viewDirTS );
					float dotResult130 = dot( staticSwitch270 , normalizeResult132 );
					float temp_output_133_0 = ( 1.0 - dotResult130 );
					float Angle_Ref137 = ( ( temp_output_133_0 * temp_output_133_0 ) * 0.5 );
					float3 Surface_Albedo284 = ( staticSwitch269 * ( ( Angle_Ref137 * _DiffuseAngularBoost ) + _DiffuseBaseStrength ) );
					float3 temp_cast_0 = (0.0).xxx;
					float3 staticSwitch283 = ( float3 )0;
					#ifdef USEHEAT
					{
						float4 break289 = _HeatCenter;
						float3 appendResult291 = (float3(break289.x , break289.y , break289.z));
						float4 break290 = _HeatSize;
						float3 appendResult292 = (float3(break290.x , break290.y , break290.z));
						float temp_output_22_0_g293 = max( ( ( _HeatTemp - 30.0 ) * 0.1 ), 0.0 );
						float temp_output_24_0_g293 = ( max( ( 1.0 - length( ( ( IN.ase_texcoord3.xyz - appendResult291 ) / max( abs( appendResult292 ), 0.0001 ) ) ) ), 0.0 ) * ( temp_output_22_0_g293 * temp_output_22_0_g293 ) );
						float3 lerpResult25_g293 = lerp( _HeatColor1.rgb , _HeatColor2.rgb , temp_output_24_0_g293);
						float Specular_Angle_Response287 = ( ( ( Angle_Ref137 * _SpecularAngularBoost ) + _SpecularBaseStrength ) * 0.5 );
						staticSwitch283 = ( ( ( lerpResult25_g293 * temp_output_24_0_g293 ) * _HeatVisibleFactor ) * Specular_Angle_Response287 );
					}
					#else
					{
						staticSwitch283 = temp_cast_0;
					}
					#endif
					float3 Localized_Heat_Radiance297 = staticSwitch283;
					float3 staticSwitch308 = ( float3 )0;
					#ifdef USEHEAT
					{
						staticSwitch308 = ( Surface_Albedo284 + ( Localized_Heat_Radiance297 * 10.0 ) );
					}
					#else
					{
						staticSwitch308 = ( Surface_Albedo284 * _ThermalSettingsMinMaxBaseInfluenceAdd.z );
					}
					#endif
					float4 break4_g309 = _ThermalSettingsMinMaxBaseInfluenceAdd;
					float ifLocalVar311 = 0;
					if( _ThermalVisionOn <= 0.0 )
					{
						ifLocalVar311 = 0.0;
					}
					else
					{
						ifLocalVar311 = 1.0;
					}
					float3 lerpResult312 = lerp( Surface_Albedo284 , ( min( max( staticSwitch308, ( break4_g309.x * _HeatThermalFactor ) ), break4_g309.y ) + break4_g309.w ) , ifLocalVar311);
					
					float3 Visible_Heat_Emission300 = ( Localized_Heat_Radiance297 * _HeatVisible );
					float3 Surface_Normal285 = staticSwitch270;
					float staticSwitch319 = ( float )0;
					#ifdef USERAIN
					{
						float staticSwitch318 = ( float )0;
						#ifdef FAKERIPPLELIGHT
						{
							float3 tanNormal314 = Surface_Normal285;
							float3 worldNormal314 = float3( dot( tanToWorld0, tanNormal314 ), dot( tanToWorld1, tanNormal314 ), dot( tanToWorld2, tanNormal314 ) );
							float3 temp_output_4_0_g316 = _SunDirection.xyz;
							float3 temp_output_14_0_g316 = ( temp_output_4_0_g316 * -1.0 );
							float dotResult18_g316 = dot( worldNormal314 , ( temp_output_14_0_g316 / max( length( temp_output_14_0_g316 ), 0.0001 ) ) );
							float Material_Drop_Mask286 = ifLocalVar243;
							float3 break27_g316 = Surface_Normal285;
							float2 appendResult28_g316 = (float2(break27_g316.x , break27_g316.y));
							float ifLocalVar30_g316 = 0;
							if( length( appendResult28_g316 ) <= 0.32 )
							ifLocalVar30_g316 = 0.0;
							else
							ifLocalVar30_g316 = 1.0;
							float ifLocalVar31_g316 = 0;
							if( break27_g316.x <= 0.0 )
							ifLocalVar31_g316 = 0.0;
							else
							ifLocalVar31_g316 = 1.0;
							staticSwitch318 = ( ( ( ( ( saturate( ( max( dotResult18_g316, 0.0 ) + _NdotLOffset ) ) * ceil( ( Material_Drop_Mask286 - _RippleFakeLightIntensityOffset ) ) ) * saturate( ( _NightRippleFakeLightOffset - temp_output_4_0_g316.y ) ) ) * ( ifLocalVar30_g316 * ifLocalVar31_g316 ) ) * _RippleFakeLightIntensity ) * _RainEffectsMaterial );
						}
						#else
						{
							staticSwitch318 = 0.0;
						}
						#endif
						staticSwitch319 = staticSwitch318;
					}
					#else
					{
						staticSwitch319 = 0.0;
					}
					#endif
					#ifdef Rain
					float staticSwitch320 = staticSwitch319;
					#else
					float staticSwitch320 = 0.0;
					#endif
					float Rain_Highlight_Emission321 = staticSwitch320;
					

					o.Albedo = lerpResult312;
					o.Normal = half3( 0, 0, 1 );
					o.Emission = ( Visible_Heat_Emission300 + Rain_Highlight_Emission321 );
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
				#define _SPECULAR_SETUP 1
				#define ASE_VERSION 19914
				#define ASE_USING_SAMPLING_MACROS 1

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
					half3 normal : NORMAL;
					half4 tangent : TANGENT;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					ASE_SV_POSITION_QUALIFIERS UNITY_POSITION( pos );
					V2F_SHADOW_CASTER_NOPOS
					
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

				uniform float _StencilType;
				uniform float _DropsSpec;


				
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
							#if defined( ASE_WRITE_DEPTH )
								, out float outputDepth : ASE_SV_DEPTH
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

					#if defined( ASE_WRITE_DEPTH )
						IN.pos.z = IN.pos.z;
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

					#if defined( ASE_WRITE_DEPTH )
						outputDepth = IN.pos.z;
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
				#define _SPECULAR_SETUP 1
				#define ASE_VERSION 19914
				#define ASE_USING_SAMPLING_MACROS 1

				#pragma vertex vert
				#pragma fragment frag
				#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
				#pragma multi_compile_fwdbase
				#define SCENESELECTIONPASS
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

				

				#if defined(ASE_WRITE_DEPTH_CONSERVATIVE) && (SHADER_TARGET >= 45)
					#define ASE_SV_DEPTH SV_DepthLessEqual
					#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
				#else
					#define ASE_SV_DEPTH SV_Depth
					#define ASE_SV_POSITION_QUALIFIERS
				#endif

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
					ASE_SV_POSITION_QUALIFIERS float4 pos : SV_POSITION;
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

				uniform float _StencilType;
				uniform float _DropsSpec;


				
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
					half4 tangent : TANGENT;
					
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
					o.tangent = v.tangent;
					
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
					o.tangent = patch[0].tangent * bary.x + patch[1].tangent * bary.y + patch[2].tangent * bary.z;
					
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
							#if defined( ASE_WRITE_DEPTH )
								, out float outputDepth : ASE_SV_DEPTH
							#endif
							) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(IN);

					#ifdef LOD_FADE_CROSSFADE
						UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
					#endif

					

					half Alpha = 1;
					half AlphaClipThreshold = 0.5;

					#if defined( ASE_WRITE_DEPTH )
						IN.pos.z = IN.pos.z;
					#endif

					#ifdef _ALPHATEST_ON
						clip( Alpha - AlphaClipThreshold );
					#endif

					#if defined( ASE_WRITE_DEPTH )
						outputDepth = IN.pos.z;
					#endif

					return float4( _ObjectId, _PassValue, 1.0, 1.0 );
				}
			ENDCG
		}

		
		Pass
		{
			
			Name "ScenePickingPass"
			Tags { "LightMode"="Picking" }

			ZWrite On

			CGPROGRAM
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
				#define _SPECULAR_SETUP 1
				#define ASE_VERSION 19914
				#define ASE_USING_SAMPLING_MACROS 1

				#pragma vertex vert
				#pragma fragment frag
				#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2

				#pragma multi_compile_fwdbase
				#ifndef UNITY_PASS_FORWARDBASE
					#define UNITY_PASS_FORWARDBASE
				#endif
				#define SCENEPICKINGPASS
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

				

				#if defined(ASE_WRITE_DEPTH_CONSERVATIVE) && (SHADER_TARGET >= 45)
					#define ASE_SV_DEPTH SV_DepthLessEqual
					#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
				#else
					#define ASE_SV_DEPTH SV_Depth
					#define ASE_SV_POSITION_QUALIFIERS
				#endif

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
					ASE_SV_POSITION_QUALIFIERS float4 pos : SV_POSITION;
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

				uniform float _StencilType;
				uniform float _DropsSpec;


				
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
					half4 tangent : TANGENT;
					
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
					o.tangent = v.tangent;
					
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
					o.tangent = patch[0].tangent * bary.x + patch[1].tangent * bary.y + patch[2].tangent * bary.z;
					
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
							#if defined( ASE_WRITE_DEPTH )
								, out float outputDepth : ASE_SV_DEPTH
							#endif
							) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(IN);

					#ifdef LOD_FADE_CROSSFADE
						UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
					#endif

					

					half Alpha = 1;
					half AlphaClipThreshold = 0.5;

					#if defined( ASE_WRITE_DEPTH )
						IN.pos.z = IN.pos.z;
					#endif

					#ifdef _ALPHATEST_ON
						clip( Alpha - AlphaClipThreshold );
					#endif

					#if defined( ASE_WRITE_DEPTH )
						outputDepth = IN.pos.z;
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
Version=19914
{"type":"AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor","id":325,"pos":[-3650,700],"params":["Inherit","False","4300","900","Game-controlled thermal surface range. X Min / Y Max / Z Detail / W Offset. USEHEAT has its own source path; PBR reflections remain in the lighting model.","15","78","57","77","301","302","303","304","305","306","307","308","309","310","311","312","THERMAL VISION RESPONSE","0.4,0.24,0.52,1","0","0"]}
{"type":"AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor","id":326,"pos":[-3650,1650],"params":["Inherit","False","4300","1700","Heat region uses local coordinates. Game drives Celsius, region, visibility and factors through HotObject. White-hot behavior uses the recovered unclamped curve.","21","52","51","62","61","60","58","281","283","288","289","290","291","292","293","294","295","296","297","298","299","300","LOCALIZED HEAT GLOW","0.55,0.25,0.12,1","0","0"]}
{"type":"AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor","id":327,"pos":[-3650,3400],"params":["Inherit","False","4300","1450","Additional BSG fake light. Rain + USERAIN + FAKERIPPLELIGHT and your per-material rain toggle all gate this output.","14","81","82","80","159","282","313","314","315","316","317","318","319","320","321","RAIN HIGHLIGHT ACCENT","0.12,0.38,0.5,1","0","0"]}
{"type":"AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor","id":217,"pos":[-2832,-1872],"params":["Inherit","False","334.5999","356.1001","Triplanar Mask","","1,1,1,1","","0","0"]}
{"type":"AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor","id":218,"pos":[-2832,-1456],"params":["Inherit","False","334.5999","356.1001","Triplanar XY","","1,1,1,1","","0","0"]}
{"type":"AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor","id":224,"pos":[-2264,-1368],"params":["Inherit","False","253.1824","276.6825","Selected XY","","1,1,1,1","","0","0"]}
{"type":"AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor","id":226,"pos":[-2264,-1784],"params":["Inherit","False","253.1824","276.6825","Selected Mask","","1,1,1,1","","0","0"]}
{"type":"AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor","id":235,"pos":[-4000,-2120],"params":["Inherit","False","875.1047","487.2881","Surface Exposure","","1,1,1,1","","0","0"]}
{"type":"AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor","id":237,"pos":[-4000,-2392],"params":["Inherit","False","609.3743","201.769","Intensity Factor","","1,1,1,1","","0","0"]}
{"type":"AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor","id":240,"pos":[-3144,-2376],"params":["Inherit","False","205.125","176.3269","Rain Coverage","","1,1,1,1","","0","0"]}
{"type":"AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor","id":244,"pos":[-1864,-1984],"params":["Inherit","False","246.115","249.8267","Material Mask","","1,1,1,1","","0","0"]}
{"type":"AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor","id":246,"pos":[-1816,-2360],"params":["Inherit","False","181.0962","165.019","Wet Amount","","1,1,1,1","","0","0"]}
{"type":"AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor","id":252,"pos":[-1768,-1384],"params":["Inherit","False","214.2039","156.5604","Drop Normal","","1,1,1,1","","0","0"]}
{"type":"AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor","id":255,"pos":[-1200,-2656],"params":["Inherit","False","181.2","161.0999","Normal Weight","","1,1,1,1","","0","0"]}
{"type":"AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor","id":256,"pos":[-1200,-2256],"params":["Inherit","False","181.2","161.0999","Diffuse Weight","","1,1,1,1","","0","0"]}
{"type":"AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor","id":257,"pos":[-1200,-2480],"params":["Inherit","False","181.2","161.0999","Specular Weight","","1,1,1,1","","0","0"]}
{"type":"AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor","id":259,"pos":[-1200,-2080],"params":["Inherit","False","181.2","161.0999","Smoothness Weight","","1,1,1,1","","0","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":78,"pos":[-3500,1200],"params":["Inherit","False","Property","_HeatThermalFactor","Game Thermal Brightness Multiplier","32","1","[HideInInspector]","Create","True","0","0","0","False","0","False","Object","-1","","1","1","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":57,"pos":[-3500,1400],"params":["Inherit","False","Global","_ThermalVisionOn","Thermal Vision Active (Game Global)","11","0","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor","id":10,"pos":[-2064,384],"params":["Inherit","True","Property","_BumpMap","Normal Map","14","1","[Normal]","Create","False","0","0","0","False","0","False","","None","None","True","bump","Auto","Texture2D","False","-1","0","2","SAMPLER2D","0","SAMPLERSTATE","1"]}
{"type":"AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor","id":49,"pos":[-1776,384],"params":["Inherit","True","Property","_TextureSample12","Texture Sample 12","6","0","Create","True","0","0","0","False","0","False","","-1","None","None","True","0","False","white","Auto","True","Object","-1","Auto","Texture2D","False","8","0","SAMPLER2D","","False","1","FLOAT2","0,0","False","2","FLOAT","0","False","3","FLOAT2","0,0","False","4","FLOAT2","0,0","False","5","FLOAT","1","False","6","FLOAT","0","False","7","SAMPLERSTATE","","False","6","FLOAT3","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":86,"pos":[-2640,-672],"params":["Inherit","False","Property","_Specularness","Smoothness","13","0","Create","False","0","0","0","False","0","False","Object","-1","","1","0","0","10","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":117,"pos":[-1776,-240],"params":["Inherit","False","Property","_Glossness","Specular Mult","8","0","Create","False","0","0","0","False","0","False","Object","-1","","1","0","0","10","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":42,"pos":[-2640,-752],"params":["Inherit","False","Property","_StencilType","Stencil Type","2","0","Create","True","0","3","Static","0","Character","1","Hands","2","0","True","1","MaterialEnum(Static, 0, Characters, 1, Hands, 2)","False","Object","-1","","0","2","0","2","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor","id":11,"pos":[-1792,128],"params":["Inherit","True","Property","_TextureSample0","Texture Sample 0","3","0","Create","True","0","0","0","False","0","False","","8","None","None","True","0","False","white","Auto","False","Object","-1","Auto","Texture2D","False","8","0","SAMPLER2D","","False","1","FLOAT2","0,0","False","2","FLOAT","0","False","3","FLOAT2","0,0","False","4","FLOAT2","0,0","False","5","FLOAT","1","False","6","FLOAT","0","False","7","SAMPLERSTATE","","False","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":44,"pos":[-2584,-160],"params":["Inherit","False","Property","_NormalIntensity","Normal Intensity","15","0","Create","True","0","0","0","False","0","False","Object","-1","","1","1","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor","id":8,"pos":[-2096,128],"params":["Inherit","True","Property","_SpecMap","AO (R) Gloss (G)","11","1","[Header]","Create","False","1","BSG gloss map may also be used here","0","0","False","0","False","","None","None","False","gray","Auto","Texture2D","False","-1","0","2","SAMPLER2D","0","SAMPLERSTATE","1"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":129,"pos":[-2608,-432],"params":["Inherit","False","Property","_SpecularBaseStrength","Specular Base Strength","9","0","Create","True","0","0","0","False","0","False","Object","-1","","2","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":126,"pos":[-2600,-352],"params":["Inherit","False","Property","_SpecularAngularBoost","Specular Angular Boost","10","0","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":50,"pos":[-2552,-80],"params":["Inherit","False","Property","_DropsSpec","Drops Spec","17","1","[HideInInspector]","Create","False","1","Rain Settings","0","0","True","1","Space(10)","False","Object","-1","","128","128","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":128,"pos":[-2608,-512],"params":["Inherit","False","Property","_DiffuseAngularBoost","Diffuse Angular Boost","6","0","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":127,"pos":[-2608,-592],"params":["Inherit","False","Property","_DiffuseBaseStrength","Diffuse Base Strength","5","0","Create","True","0","0","0","False","0","False","Object","-1","","1","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.ColorNode, AmplifyShaderEditor","id":52,"pos":[-3500,2450],"params":["Inherit","False","Property","_HeatColor1","Heat Glow Color - Lower Heat","27","1","[HDR]","Create","False","0","0","0","True","0","False","Object","-1","","1,0,0,1","0,0,0,0","True","True","0","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.ColorNode, AmplifyShaderEditor","id":51,"pos":[-3500,2680],"params":["Inherit","False","Property","_HeatColor2","Heat Glow Color - Higher Heat","28","1","[HDR]","Create","False","0","0","0","True","0","False","Object","-1","","1,0.34,0,1","0,0,0,0","True","True","0","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":81,"pos":[-3500,3900],"params":["Inherit","False","Property","_NightRippleFakeLightOffset","Rain Highlight Sun Height Fade Offset","22","0","Create","False","0","0","0","True","0","False","Object","-1","","0.2","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":82,"pos":[-3500,4100],"params":["Inherit","False","Property","_NdotLOffset","Rain Highlight Surface Facing Bias","21","0","Create","False","0","0","0","True","0","False","Object","-1","","0.4","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":80,"pos":[-3500,4300],"params":["Inherit","False","Global","_RippleFakeLightIntensity","Rain Highlight Intensity (Game Global)","17","1","[HideInInspector]","Create","False","0","0","0","False","0","False","Object","-1","","0.7","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor","id":9,"pos":[-2096,-112],"params":["Inherit","True","Property","_MainTex","Base Color (RGB) Spec (A)","4","0","Create","False","0","0","0","False","0","False","","None","None","False","black","Auto","Texture2D","False","-1","0","2","SAMPLER2D","0","SAMPLERSTATE","1"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":79,"pos":[-3968,-608],"params":["Inherit","False","Property","_RippleTexScale","Ripple Texture Scale","18","1","[HideInInspector]","Create","False","1","Rain Settings","0","0","False","0","False","Object","-1","","4","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor","id":189,"pos":[-4312,-768],"params":["Inherit","False","0","9","2","_MainTex","3","2","SAMPLER2D","","False","0","FLOAT2","1,1","False","1","FLOAT2","0,0","False","5","FLOAT2","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor","id":190,"pos":[-3528,-632],"params":["Inherit","False","2","2","0","FLOAT2","0,0","False","1","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":195,"pos":[-3768,-1448],"params":["Inherit","False","Constant","_Float8","Float 8","32","0","Create","True","0","0","0","False","0","False","Object","-1","","0.49","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor","id":192,"pos":[-3576,-1552],"params":["Inherit","False","2","2","0","FLOAT3","0,0,0","False","1","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor","id":193,"pos":[-3416,-1552],"params":["Inherit","False","2","2","0","FLOAT3","0,0,0","False","1","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor","id":196,"pos":[-3312,-1552],"params":["Inherit","False","FLOAT3","1","0","FLOAT3","0,0,0","False","16","FLOAT","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT","5","FLOAT","6","FLOAT","7","FLOAT","8","FLOAT","9","FLOAT","10","FLOAT","11","FLOAT","12","FLOAT","13","FLOAT","14","FLOAT","15"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":197,"pos":[-3176,-1552],"params":["Inherit","False","3","3","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":194,"pos":[-3576,-1448],"params":["Inherit","False","Constant","_Float7","Float 7","32","0","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.AbsOpNode, AmplifyShaderEditor","id":191,"pos":[-3728,-1552],"params":["Inherit","False","1","0","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor","id":198,"pos":[-3016,-1824],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor","id":199,"pos":[-3016,-1736],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor","id":200,"pos":[-3016,-1648],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor","id":183,"pos":[-3408,-632],"params":["Inherit","False","Rain Ripple Sample","0","","1","7e68b3d6bfd58ad428633132fb347d6b","0","1","35","FLOAT2","0,0","False","2","FLOAT","13","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor","id":207,"pos":[-3240,-1232],"params":["Inherit","False","FLOAT2","4","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor","id":208,"pos":[-3112,-1232],"params":["Inherit","False","Rain Ripple Sample","0","","7","7e68b3d6bfd58ad428633132fb347d6b","0","1","35","FLOAT2","0,0","False","2","FLOAT","13","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor","id":206,"pos":[-3112,-1320],"params":["Inherit","False","Rain Ripple Sample","0","","8","7e68b3d6bfd58ad428633132fb347d6b","0","1","35","FLOAT2","0,0","False","2","FLOAT","13","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor","id":203,"pos":[-3240,-1408],"params":["Inherit","False","FLOAT2","4","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor","id":204,"pos":[-3112,-1408],"params":["Inherit","False","Rain Ripple Sample","0","","9","7e68b3d6bfd58ad428633132fb347d6b","0","1","35","FLOAT2","0,0","False","2","FLOAT","13","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":211,"pos":[-2808,-1736],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":212,"pos":[-2808,-1648],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":210,"pos":[-2808,-1824],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":209,"pos":[-2624,-1760],"params":["Inherit","False","3","3","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":213,"pos":[-2808,-1320],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":214,"pos":[-2808,-1232],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":216,"pos":[-2624,-1344],"params":["Inherit","False","3","3","0","FLOAT2","0,0","False","1","FLOAT2","0,0","False","2","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":215,"pos":[-2808,-1408],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":201,"pos":[-3680,-1336],"params":["Inherit","False","2","2","0","FLOAT3","0,0,0","False","1","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor","id":205,"pos":[-3240,-1320],"params":["Inherit","False","FLOAT2","4","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor","id":202,"pos":[-3552,-1336],"params":["Inherit","False","FLOAT3","1","0","FLOAT3","0,0,0","False","16","FLOAT","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT","5","FLOAT","6","FLOAT","7","FLOAT","8","FLOAT","9","FLOAT","10","FLOAT","11","FLOAT","12","FLOAT","13","FLOAT","14","FLOAT","15"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":219,"pos":[-2472,-1784],"params":["Inherit","False","Property","_TRIPLANAR","TRIPLANAR","35","0","Create","True","0","0","0","False","0","False","","1","0","0","False","TRIPLANAR","Toggle","2","Key0","Key1","Create","False","False","All","False","False","True","9","1","FLOAT","0","False","0","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","4","FLOAT","0","False","5","FLOAT","0","False","6","FLOAT","0","False","7","FLOAT","0","False","8","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":220,"pos":[-2440,-1368],"params":["Inherit","False","Property","_TRIPLANAR1","TRIPLANAR 1","35","0","Create","True","0","0","0","False","0","False","","1","0","0","False","TRIPLANAR","Toggle","2","Key0","Key1","Reference","219","False","False","All","False","False","True","9","1","FLOAT2","0,0","False","0","FLOAT2","0,0","False","2","FLOAT2","0,0","False","3","FLOAT2","0,0","False","4","FLOAT2","0,0","False","5","FLOAT2","0,0","False","6","FLOAT2","0,0","False","7","FLOAT2","0,0","False","8","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":222,"pos":[-2440,-1528],"params":["Inherit","False","Constant","_Float9","Float 9","35","0","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.ConditionalIfNode, AmplifyShaderEditor","id":223,"pos":[-2216,-1304],"params":["Inherit","False","False","5","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT2","0,0","False","3","FLOAT2","0,0","False","4","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.ConditionalIfNode, AmplifyShaderEditor","id":221,"pos":[-2216,-1720],"params":["Inherit","False","False","5","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","4","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor","id":227,"pos":[-3712,-1840],"params":["Inherit","False","2","0","FLOAT3","0,0,0","False","1","FLOAT3","0,0,0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor","id":228,"pos":[-3560,-1840],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":232,"pos":[-3736,-1920],"params":["Inherit","False","Constant","_Float11","Float 11","35","0","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.Vector3Node, AmplifyShaderEditor","id":162,"pos":[-3968,-2024],"params":["Inherit","False","Property","_LocalRainAverage","_LocalRainAverage","25","1","[HideInInspector]","Create","True","0","0","0","False","0","False","Object","-1","","0,0,0","0,0,0","0","4","FLOAT3","0","FLOAT","1","FLOAT","2","FLOAT","3"]}
{"type":"AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor","id":231,"pos":[-3560,-2048],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":233,"pos":[-3408,-1944],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor","id":234,"pos":[-3296,-1944],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor","id":230,"pos":[-3712,-2048],"params":["Inherit","False","2","0","FLOAT3","0,0,0","False","1","FLOAT3","0,0,0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.Vector4Node, AmplifyShaderEditor","id":159,"pos":[-3500,4500],"params":["Inherit","False","Global","_SunDirection","Sun Direction (Game Global)","31","0","Create","True","0","0","0","False","0","False","Object","-1","","0,0,0,0","0,0,0,0","0","5","FLOAT4","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":158,"pos":[-3968,-2272],"params":["Inherit","False","Global","_RainIntensityRippleScale","_RainIntensityRippleScale","32","1","[HideInInspector]","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":236,"pos":[-3696,-2320],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":152,"pos":[-3936,-2344],"params":["Inherit","False","Global","_RainIntensity","_RainIntensity","32","1","[HideInInspector]","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor","id":238,"pos":[-3544,-2320],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":239,"pos":[-3104,-2320],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":241,"pos":[-2184,-1880],"params":["Inherit","False","Constant","_Float10","Float 10","35","0","Create","True","0","0","0","False","0","False","Object","-1","","0.35","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":242,"pos":[-1984,-1880],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":84,"pos":[-3096,-1960],"params":["Inherit","False","Property","_SkinnedMeshMaterial","Skinned Mesh Material","19","1","[HideInInspector]","Create","False","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":248,"pos":[-2192,-1440],"params":["Inherit","False","Constant","_Float12","Float 12","35","0","Create","True","0","0","0","False","0","False","Object","-1","","7","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":247,"pos":[-2000,-1328],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor","id":249,"pos":[-1864,-1328],"params":["Inherit","False","FLOAT3","4","0","FLOAT2","0,0","False","1","FLOAT","1","False","2","FLOAT","1","False","3","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor","id":251,"pos":[-1728,-1328],"params":["Inherit","False","False","1","0","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":155,"pos":[-1392,-2184],"params":["Inherit","False","Global","_WetDropAlbedo","_WetDropAlbedo","32","1","[HideInInspector]","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":253,"pos":[-1176,-2208],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":260,"pos":[-1176,-2032],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":258,"pos":[-1176,-2432],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":254,"pos":[-1176,-2608],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":156,"pos":[-1392,-2608],"params":["Inherit","False","Global","_WetDropNormal","_WetDropNormal","32","1","[HideInInspector]","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.ColorNode, AmplifyShaderEditor","id":261,"pos":[-1216,-1888],"params":["Inherit","False","Constant","_Color0","Color 0","35","0","Create","True","0","0","0","False","0","False","Object","-1","","0,0,0,0","0,0,0,0","True","False","0","6","FLOAT3","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.LerpOp, AmplifyShaderEditor","id":263,"pos":[-952,-2080],"params":["Inherit","False","3","0","FLOAT3","0,0,0","False","1","FLOAT3","0,0,0","False","2","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.LerpOp, AmplifyShaderEditor","id":262,"pos":[-952,-2256],"params":["Inherit","False","3","0","FLOAT3","0,0,0","False","1","FLOAT3","0,0,0","False","2","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.LerpOp, AmplifyShaderEditor","id":265,"pos":[-952,-2480],"params":["Inherit","False","3","0","FLOAT3","0,0,0","False","1","FLOAT3","0,0,0","False","2","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.LerpOp, AmplifyShaderEditor","id":264,"pos":[-952,-2656],"params":["Inherit","False","3","0","FLOAT3","0,0,0","False","1","FLOAT3","0,0,0","False","2","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.ColorNode, AmplifyShaderEditor","id":266,"pos":[-1216,-1744],"params":["Inherit","False","Constant","_Color1","Color 1","35","0","Create","True","0","0","0","False","0","False","Object","-1","","1,1,1,0","0,0,0,0","True","False","0","6","FLOAT3","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":267,"pos":[-1360,-1960],"params":["Inherit","False","Constant","_Float13","Float 13","35","0","Create","True","0","0","0","False","0","False","Object","-1","","1","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":124,"pos":[-1248,240],"params":["Inherit","False","Property","_Keyword0","Keyword 0","12","0","Create","True","0","0","0","False","0","False","","0","0","0","True","","Toggle","2","Key0","Key1","Reference","123","True","True","All","False","False","True","9","1","FLOAT","0","False","0","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","4","FLOAT","0","False","5","FLOAT","0","False","6","FLOAT","0","False","7","FLOAT","0","False","8","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":125,"pos":[-1416,264],"params":["Inherit","False","Constant","_Float0","Float 0","26","0","Create","True","0","0","0","False","0","False","Object","-1","","1","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.LerpOp, AmplifyShaderEditor","id":109,"pos":[-928,-88],"params":["Inherit","True","3","0","FLOAT3","0,0,0","False","1","FLOAT3","0,0,0","False","2","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":270,"pos":[176,-288],"params":["Inherit","False","Property","_Switch1","Switch 1","35","0","Create","True","0","0","0","False","0","False","","0","0","0","True","","Toggle","2","Key0","Key1","Reference","269","True","True","All","False","False","True","9","1","FLOAT3","0,0,0","False","0","FLOAT3","0,0,0","False","2","FLOAT3","0,0,0","False","3","FLOAT3","0,0,0","False","4","FLOAT3","0,0,0","False","5","FLOAT3","0,0,0","False","6","FLOAT3","0,0,0","False","7","FLOAT3","0,0,0","False","8","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":272,"pos":[-24,-8],"params":["Inherit","False","Property","_Switch3","Switch 3","35","0","Create","True","0","0","0","False","0","False","","0","0","0","True","","Toggle","2","Key0","Key1","Reference","268","True","True","All","False","False","True","9","1","FLOAT3","0,0,0","False","0","FLOAT3","0,0,0","False","2","FLOAT3","0,0,0","False","3","FLOAT3","0,0,0","False","4","FLOAT3","0,0,0","False","5","FLOAT3","0,0,0","False","6","FLOAT3","0,0,0","False","7","FLOAT3","0,0,0","False","8","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":273,"pos":[176,-32],"params":["Inherit","False","Property","_Switch4","Switch 4","35","0","Create","True","0","0","0","False","0","False","","0","0","0","True","","Toggle","2","Key0","Key1","Reference","269","True","True","All","False","False","True","9","1","FLOAT3","0,0,0","False","0","FLOAT3","0,0,0","False","2","FLOAT3","0,0,0","False","3","FLOAT3","0,0,0","False","4","FLOAT3","0,0,0","False","5","FLOAT3","0,0,0","False","6","FLOAT3","0,0,0","False","7","FLOAT3","0,0,0","False","8","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor","id":13,"pos":[-1792,-112],"params":["Inherit","True","Property","_TextureSample2","Texture Sample 0","3","0","Create","True","0","0","0","False","0","False","","9","None","None","True","0","False","white","Auto","False","Object","-1","Auto","Texture2D","False","8","0","SAMPLER2D","","False","1","FLOAT2","0,0","False","2","FLOAT","0","False","3","FLOAT2","0,0","False","4","FLOAT2","0,0","False","5","FLOAT","1","False","6","FLOAT","0","False","7","SAMPLERSTATE","","False","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":122,"pos":[-1104,-64],"params":["Inherit","False","2","2","0","FLOAT3","0,0,0","False","1","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":123,"pos":[-1248,128],"params":["Inherit","False","Property","_UseBSGGloss","Use BSG Gloss","12","0","Create","True","0","0","0","False","0","False","","0","0","0","True","","Toggle","2","Key0","Key1","Create","True","True","All","False","False","True","9","1","FLOAT3","0,0,0","False","0","FLOAT3","0,0,0","False","2","FLOAT3","0,0,0","False","3","FLOAT3","0,0,0","False","4","FLOAT3","0,0,0","False","5","FLOAT3","0,0,0","False","6","FLOAT3","0,0,0","False","7","FLOAT3","0,0,0","False","8","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":268,"pos":[-24,-392],"params":["Inherit","False","Property","_USERAIN","USERAIN","35","0","Create","True","0","0","0","False","0","False","","1","0","0","False","USERAIN","Toggle","2","Key0","Key1","Create","False","False","All","False","False","True","9","1","FLOAT3","0,0,0","False","0","FLOAT3","0,0,0","False","2","FLOAT3","0,0,0","False","3","FLOAT3","0,0,0","False","4","FLOAT3","0,0,0","False","5","FLOAT3","0,0,0","False","6","FLOAT3","0,0,0","False","7","FLOAT3","0,0,0","False","8","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":269,"pos":[176,-416],"params":["Inherit","False","Property","_Rain","Rain","35","0","Create","True","0","0","0","False","0","False","","1","0","0","False","Rain","Toggle","2","Key0","Key1","Create","False","False","All","False","False","True","9","1","FLOAT3","0,0,0","False","0","FLOAT3","0,0,0","False","2","FLOAT3","0,0,0","False","3","FLOAT3","0,0,0","False","4","FLOAT3","0,0,0","False","5","FLOAT3","0,0,0","False","6","FLOAT3","0,0,0","False","7","FLOAT3","0,0,0","False","8","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":276,"pos":[328,-416],"params":["Inherit","False","2","2","0","FLOAT3","0,0,0","False","1","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":140,"pos":[40,-640],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":139,"pos":[-96,-640],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":138,"pos":[-264,-640],"params":["Inherit","False","137","Angle Ref","1","0","OBJECT","","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":271,"pos":[-24,-264],"params":["Inherit","False","Property","_Switch2","Switch 2","35","0","Create","True","0","0","0","False","0","False","","0","0","0","True","","Toggle","2","Key0","Key1","Reference","268","True","True","All","False","False","True","9","1","FLOAT3","0,0,0","False","0","FLOAT3","0,0,0","False","2","FLOAT3","0,0,0","False","3","FLOAT3","0,0,0","False","4","FLOAT3","0,0,0","False","5","FLOAT3","0,0,0","False","6","FLOAT3","0,0,0","False","7","FLOAT3","0,0,0","False","8","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.NormalVertexDataNode, AmplifyShaderEditor","id":188,"pos":[-3936,-1552],"params":["Inherit","False","0","5","FLOAT3","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.PositionNode, AmplifyShaderEditor","id":185,"pos":[-3936,-1336],"params":["Inherit","False","0","0","4","FLOAT3","0","FLOAT","1","FLOAT","2","FLOAT","3"]}
{"type":"AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor","id":132,"pos":[752,-264],"params":["Inherit","False","False","1","0","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.ViewDirInputsCoordNode, AmplifyShaderEditor","id":131,"pos":[544,-264],"params":["Inherit","False","Tangent","False","0","4","FLOAT3","0","FLOAT","1","FLOAT","2","FLOAT","3"]}
{"type":"AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor","id":130,"pos":[912,-288],"params":["Inherit","False","2","0","FLOAT3","0,0,0","False","1","FLOAT3","0,0,0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor","id":133,"pos":[1040,-288],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":134,"pos":[1232,-312],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":135,"pos":[1408,-312],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":136,"pos":[1232,-216],"params":["Inherit","False","Constant","_Float1","Float 1","30","0","Create","True","0","0","0","False","0","False","Object","-1","","0.5","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":137,"pos":[1568,-312],"params":["Inherit","False","Angle Ref","-1","True","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":142,"pos":[-1096,-696],"params":["Inherit","False","137","Angle Ref","1","0","OBJECT","","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":144,"pos":[-776,-696],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":146,"pos":[-848,-784],"params":["Inherit","False","Constant","_Float2","Float 2","30","0","Create","True","0","0","0","False","0","False","Object","-1","","0.5","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":145,"pos":[-664,-696],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":143,"pos":[-920,-696],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":274,"pos":[-392,-104],"params":["Inherit","False","Property","_Switch5","Switch 5","35","0","Create","True","0","0","0","False","0","False","","0","0","0","True","","Toggle","2","Key0","Key1","Reference","268","True","True","All","False","False","True","9","1","FLOAT3","0,0,0","False","0","FLOAT3","0,0,0","False","2","FLOAT3","0,0,0","False","3","FLOAT3","0,0,0","False","4","FLOAT3","0,0,0","False","5","FLOAT3","0,0,0","False","6","FLOAT3","0,0,0","False","7","FLOAT3","0,0,0","False","8","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":275,"pos":[-192,-128],"params":["Inherit","False","Property","_Switch6","Switch 6","35","0","Create","True","0","0","0","False","0","False","","0","0","0","True","","Toggle","2","Key0","Key1","Reference","269","True","True","All","False","False","True","9","1","FLOAT3","0,0,0","False","0","FLOAT3","0,0,0","False","2","FLOAT3","0,0,0","False","3","FLOAT3","0,0,0","False","4","FLOAT3","0,0,0","False","5","FLOAT3","0,0,0","False","6","FLOAT3","0,0,0","False","7","FLOAT3","0,0,0","False","8","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":147,"pos":[-8,-144],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor","id":115,"pos":[144,-144],"params":["Inherit","False","1","0","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":85,"pos":[-1000,128],"params":["Inherit","False","2","2","0","FLOAT3","0,0,0","False","1","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":113,"pos":[-1232,40],"params":["Inherit","False","Property","_SpecularColorIntensity","Specular Color Intensity","7","0","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.Vector3Node, AmplifyShaderEditor","id":161,"pos":[-3936,-1816],"params":["Inherit","False","Property","_LocalRain","_LocalRain","24","1","[HideInInspector]","Create","True","0","0","0","False","0","False","Object","-1","","0,0,0","0,0,0","0","4","FLOAT3","0","FLOAT","1","FLOAT","2","FLOAT","3"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":153,"pos":[-1392,-2032],"params":["Inherit","False","Global","_WetDropSpecular","_WetDropSpecular","32","1","[HideInInspector]","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":154,"pos":[-1392,-2432],"params":["Inherit","False","Global","_WetDropGlossness","_WetDropGlossness","32","1","[HideInInspector]","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":116,"pos":[-656,-88],"params":["Inherit","False","2","2","0","FLOAT3","0,0,0","False","1","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.ConditionalIfNode, AmplifyShaderEditor","id":243,"pos":[-1816,-1928],"params":["Inherit","False","False","5","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","4","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":245,"pos":[-1792,-2312],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":277,"pos":[-1912,-2424],"params":["Inherit","False","Property","_RainEffectsMaterial","Enable Rain on This Material","16","1","[Toggle]","Create","True","0","0","0","False","0","False","Object","-1","","1","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":278,"pos":[-1664,-2312],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":106,"pos":[-1152,-464],"params":["Inherit","False","2","2","0","FLOAT3","0,0,0","False","1","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.ColorNode, AmplifyShaderEditor","id":88,"pos":[-1384,-464],"params":["Inherit","False","Property","_Color","Base Color Correction","3","0","Create","False","0","0","0","False","0","False","Object","-1","","1,1,1,0","1,1,1,0","True","False","0","6","FLOAT3","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":281,"pos":[-3500,3100],"params":["Inherit","False","Property","_HeatVisibleFactor","Game Heat Glow Multiplier","34","1","[HideInInspector]","Create","True","0","0","0","False","0","False","Object","-1","","1","1","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":282,"pos":[-3500,3700],"params":["Inherit","False","Property","_RippleFakeLightIntensityOffset","Rain Highlight Mask Threshold","20","0","Create","True","0","0","0","False","0","False","Object","-1","","0.7","0.7","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":283,"pos":[-950,1800],"params":["Inherit","False","Property","USEHEAT","Enable Localized Heat Glow","26","0","Create","True","0","0","0","False","0","False","","1","0","0","True","USEHEAT","Toggle","2","Key0","Key1","Create","False","False","All","False","False","True","9","1","FLOAT3","0,0,0","False","0","FLOAT3","0,0,0","False","2","FLOAT3","0,0,0","False","3","FLOAT3","0,0,0","False","4","FLOAT3","0,0,0","False","5","FLOAT3","0,0,0","False","6","FLOAT3","0,0,0","False","7","FLOAT3","0,0,0","False","8","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":284,"pos":[560,-420],"params":["Inherit","False","Surface Albedo","-1","True","1","0","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":286,"pos":[-1050,-1600],"params":["Inherit","False","Material Drop Mask","-1","True","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":287,"pos":[560,100],"params":["Inherit","False","Specular Angle Response","-1","True","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.PositionNode, AmplifyShaderEditor","id":288,"pos":[-2900,1850],"params":["Inherit","False","0","0","4","FLOAT3","0","FLOAT","1","FLOAT","2","FLOAT","3"]}
{"type":"AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor","id":289,"pos":[-2900,2050],"params":["Inherit","False","FLOAT4","1","0","FLOAT4","0,0,0,0","False","16","FLOAT","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT","5","FLOAT","6","FLOAT","7","FLOAT","8","FLOAT","9","FLOAT","10","FLOAT","11","FLOAT","12","FLOAT","13","FLOAT","14","FLOAT","15"]}
{"type":"AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor","id":290,"pos":[-2900,2250],"params":["Inherit","False","FLOAT4","1","0","FLOAT4","0,0,0,0","False","16","FLOAT","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT","5","FLOAT","6","FLOAT","7","FLOAT","8","FLOAT","9","FLOAT","10","FLOAT","11","FLOAT","12","FLOAT","13","FLOAT","14","FLOAT","15"]}
{"type":"AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor","id":291,"pos":[-2600,2050],"params":["Inherit","False","FLOAT3","4","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor","id":292,"pos":[-2600,2250],"params":["Inherit","False","FLOAT3","4","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor","id":293,"pos":[-2150,1900],"params":["Inherit","False","Epic Localized Heat Glow","-1","","293","94c880bb465544148e18184db896b852","0","7","1","FLOAT3","0,0,0","False","2","FLOAT3","0,0,0","False","3","FLOAT3","0,0,0","False","4","FLOAT","0","False","5","FLOAT3","0,0,0","False","6","FLOAT3","0,0,0","False","7","FLOAT","0","False","1","FLOAT3","28"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":294,"pos":[-2100,1650],"params":["Inherit","False","287","Specular Angle Response","1","0","OBJECT","","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":295,"pos":[-1500,1900],"params":["Inherit","False","2","2","0","FLOAT3","0,0,0","False","1","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":296,"pos":[-1500,1750],"params":["Inherit","False","Constant","_Constant","Constant","0","0","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":297,"pos":[-700,1800],"params":["Inherit","False","Localized Heat Radiance","-1","True","1","0","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":299,"pos":[-700,2300],"params":["Inherit","False","2","2","0","FLOAT3","0,0,0","False","1","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":300,"pos":[-430,2300],"params":["Inherit","False","Visible Heat Emission","-1","True","1","0","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":301,"pos":[-2300,900],"params":["Inherit","False","284","Surface Albedo","1","0","OBJECT","","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor","id":302,"pos":[-2900,1000],"params":["Inherit","False","FLOAT4","1","0","FLOAT4","0,0,0,0","False","16","FLOAT","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT","5","FLOAT","6","FLOAT","7","FLOAT","8","FLOAT","9","FLOAT","10","FLOAT","11","FLOAT","12","FLOAT","13","FLOAT","14","FLOAT","15"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":303,"pos":[-1950,900],"params":["Inherit","False","2","2","0","FLOAT3","0,0,0","False","1","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":304,"pos":[-2300,1200],"params":["Inherit","False","297","Localized Heat Radiance","1","0","OBJECT","","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":305,"pos":[-2300,1350],"params":["Inherit","False","Constant","_Constant","Constant","0","0","Create","True","0","0","0","False","0","False","Object","-1","","10","10","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":306,"pos":[-1950,1200],"params":["Inherit","False","2","2","0","FLOAT3","0,0,0","False","1","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":307,"pos":[-1650,1200],"params":["Inherit","False","2","2","0","FLOAT3","0,0,0","False","1","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":308,"pos":[-1300,1050],"params":["Inherit","False","Property","_HeatThermalSource","Heat Thermal Source","26","0","Create","True","0","0","0","False","0","False","","1","0","0","False","USEHEAT","Toggle","2","Key0","Key1","Reference","283","False","False","All","False","False","True","9","1","FLOAT3","0,0,0","False","0","FLOAT3","0,0,0","False","2","FLOAT3","0,0,0","False","3","FLOAT3","0,0,0","False","4","FLOAT3","0,0,0","False","5","FLOAT3","0,0,0","False","6","FLOAT3","0,0,0","False","7","FLOAT3","0,0,0","False","8","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor","id":309,"pos":[-900,850],"params":["Inherit","False","Epic Thermal Surface Response","-1","","309","6e93c1b0e87e4dd19f8b1b748984938e","0","3","1","FLOAT3","0,0,0","False","2","FLOAT4","0,0,0,0","False","3","FLOAT","0","False","1","FLOAT3","9"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":310,"pos":[-450,1250],"params":["Inherit","False","Constant","_Constant","Constant","0","0","Create","True","0","0","0","False","0","False","Object","-1","","1","1","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.ConditionalIfNode, AmplifyShaderEditor","id":311,"pos":[-150,1250],"params":["Inherit","False","False","5","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","4","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.LerpOp, AmplifyShaderEditor","id":312,"pos":[150,850],"params":["Inherit","False","3","0","FLOAT3","0,0,0","False","1","FLOAT3","0,0,0","False","2","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":313,"pos":[-2900,3500],"params":["Inherit","False","285","Surface Normal","1","0","OBJECT","","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.WorldNormalVector, AmplifyShaderEditor","id":314,"pos":[-2600,3500],"params":["Inherit","False","False","1","0","FLOAT3","0,0,0","False","4","FLOAT3","0","FLOAT","1","FLOAT","2","FLOAT","3"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":315,"pos":[-2900,3750],"params":["Inherit","False","286","Material Drop Mask","1","0","OBJECT","","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor","id":316,"pos":[-2150,3550],"params":["Inherit","False","Epic Rain Highlight Accent","-1","","316","998aace7cf554d7993b239cc66d0e551","0","8","1","FLOAT3","0,0,0","False","2","FLOAT3","0,0,0","False","3","FLOAT","0","False","4","FLOAT3","0,0,0","False","5","FLOAT","0","False","6","FLOAT","0","False","7","FLOAT","0","False","8","FLOAT","0","False","1","FLOAT","37"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":317,"pos":[-1650,3550],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":318,"pos":[-1350,3550],"params":["Inherit","False","Property","_FakeRippleLighting","Use Game Rain Highlight Accent","27","0","Create","True","0","0","0","False","0","False","","1","0","0","False","FAKERIPPLELIGHT","Toggle","2","Key0","Key1","Create","False","False","All","False","False","True","9","1","FLOAT","0","False","0","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","4","FLOAT","0","False","5","FLOAT","0","False","6","FLOAT","0","False","7","FLOAT","0","False","8","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":319,"pos":[-1050,3550],"params":["Inherit","False","Property","_RainAccentUser","Rain Accent Material Gate","35","0","Create","True","0","0","0","False","0","False","","1","0","0","False","USERAIN","Toggle","2","Key0","Key1","Reference","268","False","False","All","False","False","True","9","1","FLOAT","0","False","0","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","4","FLOAT","0","False","5","FLOAT","0","False","6","FLOAT","0","False","7","FLOAT","0","False","8","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":320,"pos":[-750,3550],"params":["Inherit","False","Property","_RainAccentWeather","Rain Accent Weather Gate","35","0","Create","True","0","0","0","False","0","False","","1","0","0","False","Rain","Toggle","2","Key0","Key1","Reference","269","False","False","All","False","False","True","9","1","FLOAT","0","False","0","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","4","FLOAT","0","False","5","FLOAT","0","False","6","FLOAT","0","False","7","FLOAT","0","False","8","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":321,"pos":[-430,3550],"params":["Inherit","False","Rain Highlight Emission","-1","True","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":323,"pos":[900,400],"params":["Inherit","False","321","Rain Highlight Emission","1","0","OBJECT","","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":324,"pos":[1250,250],"params":["Inherit","False","2","2","0","FLOAT3","0,0,0","False","1","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":285,"pos":[808,-160],"params":["Inherit","False","Surface Normal","-1","True","1","0","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":60,"pos":[-3500,1850],"params":["Inherit","False","Property","_HeatTemp","Heat Temperature (Celsius - Game Driven)","29","1","[HideInInspector]","Create","False","0","0","0","True","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.Vector4Node, AmplifyShaderEditor","id":61,"pos":[-3500,2050],"params":["Inherit","False","Property","_HeatCenter","Heat Region Center (Local XYZ)","30","1","[HideInInspector]","Create","False","0","0","0","True","0","False","Object","-1","","0,0,0,1","0,0,0,1","0","5","FLOAT4","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.Vector4Node, AmplifyShaderEditor","id":62,"pos":[-3500,2250],"params":["Inherit","False","Property","_HeatSize","Heat Region Size (Local XYZ)","31","1","[HideInInspector]","Create","False","0","0","0","True","0","False","Object","-1","","0.02,0.04,0.02,1","0.02,0.04,0.02,0","0","5","FLOAT4","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":58,"pos":[-3500,2900],"params":["Inherit","False","Property","_HeatVisible","Visible Heat Glow Strength","33","1","[HideInInspector]","Create","False","0","0","0","True","0","False","Object","-1","","1","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.Vector4Node, AmplifyShaderEditor","id":77,"pos":[-3500,1000],"params":["Inherit","False","Property","_ThermalSettingsMinMaxBaseInfluenceAdd","Thermal Settings (Min, Max, Base Influence, Add)","23","0","Create","True","0","0","0","False","0","False","Object","-1","","0.1,0.2,0.28,0","0.1,0.2,0.28,0","0","5","FLOAT4","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":322,"pos":[900,200],"params":["Inherit","False","300","Visible Heat Emission","1","0","OBJECT","","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":298,"pos":[-1100,2300],"params":["Inherit","False","297","Localized Heat Radiance","1","0","OBJECT","","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":0,"pos":[0,0],"params":["Float","False","False","-1","3","AmplifyShaderEditor.MaterialInspector","0","3","New Amplify Shader","ed95fe726fd7b4644bb42f4d1ddd2bcd","True","ExtraPrePass","0","0","ExtraPrePass","6","False","True","0","1","False","","0","False","","1","1","False","","0","False","","True","1","False","","1","False","","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","True","True","True","True","True","0","False","","False","False","True","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","True","1","False","","True","3","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","DisableBatching=False=DisableBatching","True","3","True","12","all","0","False","True","1","1","False","","0","False","","1","1","False","","0","False","","True","1","False","","1","False","","False","False","False","False","False","False","False","False","False","False","True","True","0","False","","True","True","True","True","True","True","0","False","","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","False","True","1","LightMode=ForwardBase","False","False","0","","178","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","RenderType=Opaque","Queue=Geometry","DisableBatching=False","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","LightMode=ForwardBase","=","=","=","=","=","=","=","=","=","=","0","Standard","0","True","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":2,"pos":[0,0],"params":["Float","False","False","-1","3","AmplifyShaderEditor.MaterialInspector","0","3","New Amplify Shader","ed95fe726fd7b4644bb42f4d1ddd2bcd","True","ForwardAdd","0","2","ForwardAdd","0","False","True","0","1","False","","0","False","","1","1","False","","0","False","","True","1","False","","1","False","","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","True","True","True","True","True","0","False","","False","False","True","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","True","1","False","","True","3","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","DisableBatching=False=DisableBatching","True","3","True","12","all","0","False","True","4","1","False","","1","False","","0","1","False","","0","False","","False","False","False","False","False","False","False","False","False","False","False","True","False","True","False","False","False","False","False","False","False","False","False","False","True","2","False","","False","False","False","True","1","LightMode=ForwardAdd","False","False","0","","118","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","RenderType=Opaque","Queue=Geometry","DisableBatching=False","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","LightMode=ForwardAdd","=","=","=","=","=","=","=","=","=","=","0","Standard","0","True","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":3,"pos":[0,0],"params":["Float","False","False","-1","3","AmplifyShaderEditor.MaterialInspector","0","3","New Amplify Shader","ed95fe726fd7b4644bb42f4d1ddd2bcd","True","Deferred","0","3","Deferred","0","False","True","0","1","False","","0","False","","1","1","False","","0","False","","True","1","False","","1","False","","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","True","True","True","True","True","0","False","","False","False","True","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","True","1","False","","True","3","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","DisableBatching=False=DisableBatching","True","3","True","12","all","0","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","True","False","True","False","False","False","False","False","False","False","False","False","False","False","False","False","False","True","1","LightMode=Deferred","False","False","0","","104","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","RenderType=Opaque","Queue=Geometry","DisableBatching=False","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","LightMode=Deferred","=","=","=","=","=","=","=","=","=","=","0","Standard","0","True","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":4,"pos":[0,0],"params":["Float","False","False","-1","3","AmplifyShaderEditor.MaterialInspector","0","3","New Amplify Shader","ed95fe726fd7b4644bb42f4d1ddd2bcd","True","Meta","0","4","Meta","0","False","True","0","1","False","","0","False","","1","1","False","","0","False","","True","1","False","","1","False","","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","True","True","True","True","True","0","False","","False","False","True","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","True","1","False","","True","3","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","DisableBatching=False=DisableBatching","True","3","True","12","all","0","False","False","False","False","False","False","False","False","False","False","False","False","False","True","True","2","False","","True","False","False","False","False","False","False","False","False","False","False","False","False","False","False","True","1","LightMode=Meta","False","False","0","","104","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","RenderType=Opaque","Queue=Geometry","DisableBatching=False","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","LightMode=Meta","=","=","=","=","=","=","=","=","=","=","0","Standard","0","True","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":5,"pos":[0,0],"params":["Float","False","False","-1","3","AmplifyShaderEditor.MaterialInspector","0","3","New Amplify Shader","ed95fe726fd7b4644bb42f4d1ddd2bcd","True","ShadowCaster","0","5","ShadowCaster","0","False","True","0","1","False","","0","False","","1","1","False","","0","False","","True","1","False","","1","False","","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","True","True","True","True","True","0","False","","False","False","True","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","True","1","False","","True","3","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","DisableBatching=False=DisableBatching","True","3","True","12","all","0","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","True","False","True","False","False","False","False","False","False","False","False","False","False","True","1","False","","True","3","False","","False","False","True","1","LightMode=ShadowCaster","False","False","0","","110","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","RenderType=Opaque","Queue=Geometry","DisableBatching=False","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","LightMode=ShadowCaster","=","=","=","=","=","=","=","=","=","=","0","Standard","0","True","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":6,"pos":[0,0],"params":["Float","False","False","-1","3","AmplifyShaderEditor.MaterialInspector","0","3","New Amplify Shader","ed95fe726fd7b4644bb42f4d1ddd2bcd","True","SceneSelectionPass","0","6","SceneSelectionPass","0","False","True","0","1","False","","0","False","","1","1","False","","0","False","","True","1","False","","1","False","","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","True","True","True","True","True","0","False","","False","False","True","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","True","1","False","","True","3","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","DisableBatching=False=DisableBatching","True","3","True","12","all","0","False","False","False","False","False","False","False","False","False","False","False","False","False","True","False","True","False","False","False","False","False","False","False","False","False","False","True","1","False","","False","False","False","True","1","LightMode=SceneSelectionPass","False","False","0","","104","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","RenderType=Opaque","Queue=Geometry","DisableBatching=False","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","LightMode=SceneSelectionPass","=","=","=","=","=","=","=","=","=","=","0","Standard","0","True","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":7,"pos":[0,0],"params":["Float","False","False","-1","3","AmplifyShaderEditor.MaterialInspector","0","3","New Amplify Shader","ed95fe726fd7b4644bb42f4d1ddd2bcd","True","ScenePickingPass","0","7","ScenePickingPass","0","False","True","0","1","False","","0","False","","1","1","False","","0","False","","True","1","False","","1","False","","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","True","True","True","True","True","0","False","","False","False","True","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","True","1","False","","True","3","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","DisableBatching=False=DisableBatching","True","3","True","12","all","0","False","False","False","False","False","False","False","False","False","False","False","False","False","True","False","True","False","False","False","False","False","False","False","False","False","False","True","1","False","","False","False","False","True","1","LightMode=Picking","False","False","0","","104","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","RenderType=Opaque","Queue=Geometry","DisableBatching=False","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","=","LightMode=Picking","=","=","=","=","=","=","=","=","=","=","0","Standard","0","True","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":1,"pos":[1700,-100],"params":["Float","False","True","-1","3","AmplifyShaderEditor.MaterialInspector","0","3","Tarkov Custom/Specular/Lit/Opaque/Epic SMap Retroreflective_Icon","ed95fe726fd7b4644bb42f4d1ddd2bcd","True","ForwardBase","0","1","ForwardBase","17","False","True","0","1","False","","0","False","","1","1","False","","0","False","","True","1","False","","1","False","","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","True","True","True","True","True","0","False","","False","False","True","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","True","1","False","","True","3","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","DisableBatching=False=DisableBatching","True","3","True","12","all","0","False","True","1","1","False","","0","False","","1","1","False","","0","False","","True","1","False","","1","False","","False","False","False","False","False","False","False","False","False","False","True","False","True","False","False","False","False","False","False","False","False","False","True","False","False","False","False","True","1","LightMode=ForwardBase","False","False","0","","3","=","=","=","0","Standard","45","Category","0","0","  Instanced Terrain Normals","1","0","Workflow","0","639281168633805685","Surface","0","0","  Blend","0","0","  Dither Shadows","1","0","Two Sided","1","0","Alpha Clipping","0","0","  Use Shadow Threshold","0","0","Deferred Pass","1","0","Normal Space","0","0","Transmission","0","0","  Transmission Shadow","0.5,False,","0","Translucency","0","0","  Translucency Strength","1,False,","0","  Normal Distortion","0.5,False,","0","  Scattering","2,False,","0","  Direct","0.9,False,","0","  Ambient","0.1,False,","0","  Shadow","0.5,False,","0","Cast Shadows","1","0","Receive Shadows","1","0","Receive Specular","2","0","Receive Reflections","2","0","GPU Instancing","1","0","LOD CrossFade","1","0","Built-in Fog","1","0","Ambient Light","1","0","Meta Pass","1","0","Add Pass","1","0","Override Baked GI","0","0","Write Depth","0","0","  Conservative","0","0","Extra Pre Pass","0","0","Tessellation","0","0","  Phong","0","0","  Strength","0.5,False,","0","  Type","0","0","  Tess","16,False,","0","  Min","10,False,","0","  Max","25,False,","0","  Edge Length","16,False,","0","  Max Displacement","25,False,","0","Disable Batching","0","0","Vertex Position","1","0","0","8","False","True","True","True","True","True","True","True","False","","True","0"]}
{"wire":[49,0,10,0]}
{"wire":[49,5,44,0]}
{"wire":[11,0,8,0]}
{"wire":[190,0,189,0]}
{"wire":[190,1,79,0]}
{"wire":[192,0,191,0]}
{"wire":[192,1,195,0]}
{"wire":[193,0,192,0]}
{"wire":[193,1,194,0]}
{"wire":[196,0,193,0]}
{"wire":[197,0,196,0]}
{"wire":[197,1,196,1]}
{"wire":[197,2,196,2]}
{"wire":[191,0,188,0]}
{"wire":[198,0,196,0]}
{"wire":[198,1,197,0]}
{"wire":[199,0,196,1]}
{"wire":[199,1,197,0]}
{"wire":[200,0,196,2]}
{"wire":[200,1,197,0]}
{"wire":[183,35,190,0]}
{"wire":[207,0,202,0]}
{"wire":[207,1,202,1]}
{"wire":[208,35,207,0]}
{"wire":[206,35,205,0]}
{"wire":[203,0,202,1]}
{"wire":[203,1,202,2]}
{"wire":[204,35,203,0]}
{"wire":[211,0,199,0]}
{"wire":[211,1,206,13]}
{"wire":[212,0,200,0]}
{"wire":[212,1,208,13]}
{"wire":[210,0,198,0]}
{"wire":[210,1,204,13]}
{"wire":[209,0,210,0]}
{"wire":[209,1,211,0]}
{"wire":[209,2,212,0]}
{"wire":[213,0,199,0]}
{"wire":[213,1,206,0]}
{"wire":[214,0,200,0]}
{"wire":[214,1,208,0]}
{"wire":[216,0,215,0]}
{"wire":[216,1,213,0]}
{"wire":[216,2,214,0]}
{"wire":[215,0,198,0]}
{"wire":[215,1,204,0]}
{"wire":[201,0,185,0]}
{"wire":[201,1,79,0]}
{"wire":[205,0,202,2]}
{"wire":[205,1,202,0]}
{"wire":[202,0,201,0]}
{"wire":[219,1,183,13]}
{"wire":[219,0,209,0]}
{"wire":[220,1,183,0]}
{"wire":[220,0,216,0]}
{"wire":[223,0,84,0]}
{"wire":[223,1,222,0]}
{"wire":[223,2,183,0]}
{"wire":[223,3,220,0]}
{"wire":[223,4,220,0]}
{"wire":[221,0,84,0]}
{"wire":[221,1,222,0]}
{"wire":[221,2,183,13]}
{"wire":[221,3,219,0]}
{"wire":[221,4,219,0]}
{"wire":[227,0,188,0]}
{"wire":[227,1,161,0]}
{"wire":[228,0,227,0]}
{"wire":[228,1,232,0]}
{"wire":[231,0,230,0]}
{"wire":[231,1,232,0]}
{"wire":[233,0,231,0]}
{"wire":[233,1,228,0]}
{"wire":[234,0,233,0]}
{"wire":[230,0,188,0]}
{"wire":[230,1,162,0]}
{"wire":[236,0,152,0]}
{"wire":[236,1,158,0]}
{"wire":[238,0,236,0]}
{"wire":[239,0,238,0]}
{"wire":[239,1,234,0]}
{"wire":[242,0,241,0]}
{"wire":[242,1,221,0]}
{"wire":[247,0,248,0]}
{"wire":[247,1,223,0]}
{"wire":[249,0,247,0]}
{"wire":[251,0,249,0]}
{"wire":[253,0,278,0]}
{"wire":[253,1,155,0]}
{"wire":[260,0,153,0]}
{"wire":[260,1,278,0]}
{"wire":[258,0,154,0]}
{"wire":[258,1,278,0]}
{"wire":[254,0,156,0]}
{"wire":[254,1,278,0]}
{"wire":[263,0,85,0]}
{"wire":[263,1,267,0]}
{"wire":[263,2,260,0]}
{"wire":[262,0,106,0]}
{"wire":[262,1,261,0]}
{"wire":[262,2,253,0]}
{"wire":[265,0,116,0]}
{"wire":[265,1,266,0]}
{"wire":[265,2,258,0]}
{"wire":[264,0,49,0]}
{"wire":[264,1,251,0]}
{"wire":[264,2,254,0]}
{"wire":[124,1,11,1]}
{"wire":[124,0,125,0]}
{"wire":[109,0,13,4]}
{"wire":[109,1,122,0]}
{"wire":[109,2,113,0]}
{"wire":[270,1,49,0]}
{"wire":[270,0,271,0]}
{"wire":[272,1,85,0]}
{"wire":[272,0,263,0]}
{"wire":[273,1,85,0]}
{"wire":[273,0,272,0]}
{"wire":[13,0,9,0]}
{"wire":[122,0,13,5]}
{"wire":[122,1,13,4]}
{"wire":[123,1,11,2]}
{"wire":[123,0,11,5]}
{"wire":[268,1,106,0]}
{"wire":[268,0,262,0]}
{"wire":[269,1,106,0]}
{"wire":[269,0,268,0]}
{"wire":[276,0,269,0]}
{"wire":[276,1,140,0]}
{"wire":[140,0,139,0]}
{"wire":[140,1,127,0]}
{"wire":[139,0,138,0]}
{"wire":[139,1,128,0]}
{"wire":[271,1,49,0]}
{"wire":[271,0,264,0]}
{"wire":[132,0,131,0]}
{"wire":[130,0,270,0]}
{"wire":[130,1,132,0]}
{"wire":[133,0,130,0]}
{"wire":[134,0,133,0]}
{"wire":[134,1,133,0]}
{"wire":[135,0,134,0]}
{"wire":[135,1,136,0]}
{"wire":[137,0,135,0]}
{"wire":[144,0,143,0]}
{"wire":[144,1,129,0]}
{"wire":[145,0,144,0]}
{"wire":[145,1,146,0]}
{"wire":[143,0,142,0]}
{"wire":[143,1,126,0]}
{"wire":[274,1,116,0]}
{"wire":[274,0,265,0]}
{"wire":[275,1,116,0]}
{"wire":[275,0,274,0]}
{"wire":[147,0,145,0]}
{"wire":[147,1,275,0]}
{"wire":[115,0,147,0]}
{"wire":[85,0,123,0]}
{"wire":[85,1,86,0]}
{"wire":[116,0,109,0]}
{"wire":[116,1,117,0]}
{"wire":[243,0,84,0]}
{"wire":[243,1,222,0]}
{"wire":[243,2,242,0]}
{"wire":[243,3,221,0]}
{"wire":[243,4,221,0]}
{"wire":[245,0,239,0]}
{"wire":[245,1,243,0]}
{"wire":[278,0,277,0]}
{"wire":[278,1,245,0]}
{"wire":[106,0,88,0]}
{"wire":[106,1,13,5]}
{"wire":[283,1,296,0]}
{"wire":[283,0,295,0]}
{"wire":[284,0,276,0]}
{"wire":[286,0,243,0]}
{"wire":[287,0,145,0]}
{"wire":[289,0,61,0]}
{"wire":[290,0,62,0]}
{"wire":[291,0,289,0]}
{"wire":[291,1,289,1]}
{"wire":[291,2,289,2]}
{"wire":[292,0,290,0]}
{"wire":[292,1,290,1]}
{"wire":[292,2,290,2]}
{"wire":[293,1,288,0]}
{"wire":[293,2,291,0]}
{"wire":[293,3,292,0]}
{"wire":[293,4,60,0]}
{"wire":[293,5,52,5]}
{"wire":[293,6,51,5]}
{"wire":[293,7,281,0]}
{"wire":[295,0,293,28]}
{"wire":[295,1,294,0]}
{"wire":[297,0,283,0]}
{"wire":[299,0,298,0]}
{"wire":[299,1,58,0]}
{"wire":[300,0,299,0]}
{"wire":[302,0,77,0]}
{"wire":[303,0,301,0]}
{"wire":[303,1,302,2]}
{"wire":[306,0,304,0]}
{"wire":[306,1,305,0]}
{"wire":[307,0,301,0]}
{"wire":[307,1,306,0]}
{"wire":[308,1,303,0]}
{"wire":[308,0,307,0]}
{"wire":[309,1,308,0]}
{"wire":[309,2,77,0]}
{"wire":[309,3,78,0]}
{"wire":[311,0,57,0]}
{"wire":[311,1,296,0]}
{"wire":[311,2,310,0]}
{"wire":[311,3,296,0]}
{"wire":[311,4,296,0]}
{"wire":[312,0,301,0]}
{"wire":[312,1,309,9]}
{"wire":[312,2,311,0]}
{"wire":[314,0,313,0]}
{"wire":[316,1,314,0]}
{"wire":[316,2,313,0]}
{"wire":[316,3,315,0]}
{"wire":[316,4,159,0]}
{"wire":[316,5,282,0]}
{"wire":[316,6,82,0]}
{"wire":[316,7,81,0]}
{"wire":[316,8,80,0]}
{"wire":[317,0,316,37]}
{"wire":[317,1,277,0]}
{"wire":[318,1,296,0]}
{"wire":[318,0,317,0]}
{"wire":[319,1,296,0]}
{"wire":[319,0,318,0]}
{"wire":[320,1,296,0]}
{"wire":[320,0,319,0]}
{"wire":[321,0,320,0]}
{"wire":[324,0,322,0]}
{"wire":[324,1,323,0]}
{"wire":[285,0,270,0]}
{"wire":[1,0,312,0]}
{"wire":[1,1,285,0]}
{"wire":[1,3,115,0]}
{"wire":[1,5,273,0]}
{"wire":[1,6,124,0]}
{"wire":[1,2,324,0]}
ASEEND*/
//CHKSM=FF37546C2C5383E2125C1B9E9F2B3741224FD3CC