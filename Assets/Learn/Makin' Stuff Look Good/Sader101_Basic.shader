//https://www.youtube.com/watch?v=T-HXmQAMhG0

Shader "LearnShader/Sader101_Basic"
{
	properties
	{
		_MainTex ("Texture", 2D) = "white" { }
		_SecondTex ("Second Texture", 2D) = "white" { }
		_Tween ("Tween", Range(0, 1)) = 0
		_Color ("Color", Color) = (1, 1, 1, 1)
	}

	SubShader
	{
		// 큐 태그 정의
		// 스프라이트가 씬에서 지오메트리 다음에 렌더링..?
		tags { "Queue" = "Transparent" }
		Pass
		{
			// https://docs.unity3d.com/Manual/SL-Blend.html
			// 알파 블렌딩
			// 각 픽셀이 그 아래의 픽셀과 혼합되는 방식
			// SrcColor * SrcAlpha + DstColor * OneMinusSrcAlpha
			// 소스 색상(SrcColor)을 가져와서 소스 알파(SrcAlpha)로 곱한 다음
			// 곱한 값에
			// 뭔소리여 이게

			Blend Srcalpha oneMinusSrcAlpha
			//Blend one one

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			// https://docs.unity3d.com/Manual/SL-VertexProgramInputs.html
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
				// 자동 변경됨
				// https://forum.unity.com/threads/regarding-unity_matrix_mvp-and-unityobjecttoclippos.460940/
				//o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				//o.vertex = UnityObjectToClipPos(v.vertex);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;
			sampler2D _SecondTex;
			float _Tween;
			float4 _Color;

			// frag = fragment?
			float4 frag(v2f i) : SV_TARGET
			{
				// uv 색상
				//float4 uvColor = float4(i.uv.r, i.uv.g, 1, 1);
				// 텍스쳐 색상
				float4 color1 = tex2D(_MainTex, i.uv);
				float4 color2 = tex2D(_SecondTex, i.uv);

				// 텍스쳐 블랜딩
				float4 lerpColor = lerp(color1, color2, _Tween);
				// 텍스쳐 UV 색상 추가
				float4 uvTexColor = color1 * float4(i.uv.r, i.uv.g, 0, 1);

				// 회색으로 변경
				float luminance = color1.r * 0.3 + color1.g * 0.59 + 0.11 * color1.b;
				float4 luminanceColor = float4(luminance, luminance, luminance, color1.a);

				// 회색에 색상 추가
				float4 addColor = luminanceColor * _Color;

				return uvTexColor;

				// blend one one
				//float4 color = tex2D(_MainTex, i.uv);
				//return color * color.a;
			}
			ENDCG
		}
	}
}