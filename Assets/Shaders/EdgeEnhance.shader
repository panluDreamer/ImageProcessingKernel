﻿Shader "Hidden/Kernel/EdgeEnhance"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				half2 uv[9] : TEXCOORD0;
			};

			sampler2D _MainTex;
			half4 _MainTex_TexelSize;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				half2 uv = v.uv;

				o.uv[0] = uv + _MainTex_TexelSize.xy * half2(-1, 1);
				o.uv[1] = uv + _MainTex_TexelSize.xy * half2(0, 1);
				o.uv[2] = uv + _MainTex_TexelSize.xy * half2(1, 1);
				o.uv[3] = uv + _MainTex_TexelSize.xy * half2(-1, 0);
				o.uv[4] = uv + _MainTex_TexelSize.xy * half2(0, 0);
				o.uv[5] = uv + _MainTex_TexelSize.xy * half2(1, 0);
				o.uv[6] = uv + _MainTex_TexelSize.xy * half2(-1, -1);
				o.uv[7] = uv + _MainTex_TexelSize.xy * half2(0, -1);
				o.uv[8] = uv + _MainTex_TexelSize.xy * half2(1, -1);

				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				const float kernel[9] = {0, 0, 0,
										-1, 1, 0,
										0, 0, 0};

				fixed4 col;

				for(int it = 0; it < 9; it++)
				{
					col += tex2D(_MainTex, i.uv[it]) * kernel[it];
				}

				return col;
			}

			ENDCG
		}
	}
}
