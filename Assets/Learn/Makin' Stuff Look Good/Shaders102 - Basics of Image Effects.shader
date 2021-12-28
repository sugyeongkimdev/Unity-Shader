//https://www.youtube.com/watch?v=kpBnIAPtsj8

Shader "LearnShader/Sader101_Basic"
{
	properties
	{
		_MainTex ("Texture", 2D) = "white" { }
		_DisplaceTex("Displacement Texture", 2D) = "white"{}
		_Magnitude("Magnitude", range(0,1)) = 1
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			// 유니티 기능 사용
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;
			sampler2D _DisplaceTex;
			float _Magnitude;
			// 메인 텍스쳐의 픽셀크기(이를 텍셀이라고 표현)를 쉽게 얻을 수 있도록 cg 쉐이더 범위에서 정의
			// 스크린 크기가 1920/1080이면 (1/1920, 1/1080)을 반환
			float4 _MainTex_TexelSize;
			
			// 중간 픽셀에서 8방면으로 픽셀을 참조해서 평균값을 내는 블러기능
			// 총 9번을 샘플링 하므로 성능이 좋지 못할거같은데...
			float4 blurBox(sampler2D tex, float2 uv, float4 size)
			{
				float4 c = tex2D(tex, uv + float2(-size.x, size.y)) + tex2D(tex, uv + float2(0, size.y)) + tex2D(tex, uv + float2(size.x, size.y)) +
				tex2D(tex, uv + float2(-size.x, 0)) + tex2D(tex, uv + float2(0, 0)) + tex2D(tex, uv + float2(size.x, 0)) +
				tex2D(tex, uv + float2(-size.x, -size.y)) + tex2D(tex, uv + float2(0, -size.y)) + tex2D(tex, uv + float2(size.x, -size.y));

				return c / 9;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				// 유니티 시간
				float timeNormal = _Time.y * 2;

				// uv 색상
				float4 uvColor = float4(i.uv.r, i.uv.g, 0, 1);
				// MainTex
				float4 texColor = tex2D(_MainTex, i.uv);
				//float color = uvColor * texColor;
				//float4 color = texColor;

				//  disp xy 색상값
				float2 disp = tex2D(_DisplaceTex, i.uv).xy;
				// 0~1 -> -1~1 
				disp = ((disp * 2) - 1) * _Magnitude;
				//float color = tex2D(_MainTex, i.uv + disp);

				// dist UV 울링임
				float disp2 = tex2D(_DisplaceTex, i.uv + timeNormal).xy;
				disp2 = ((disp2 * 2) - 1) * _Magnitude;
				//float color = tex2D(_MainTex, i.uv + disp2);

				// 블러처리
				float4 blureColor = blurBox(_MainTex, i.uv, _MainTex_TexelSize);
				float4 color = blureColor;


				return color;
			}
			ENDCG
		}
	}
}