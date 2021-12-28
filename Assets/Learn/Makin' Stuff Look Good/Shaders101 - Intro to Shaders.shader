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
		// ť �±� ����
		// ��������Ʈ�� ������ ������Ʈ�� ������ ������..?
		tags { "Queue" = "Transparent" }
		Pass
		{
			// https://docs.unity3d.com/Manual/SL-Blend.html
			// ���� ����
			// �� �ȼ��� �� �Ʒ��� �ȼ��� ȥ�յǴ� ���
			// SrcColor * SrcAlpha + DstColor * OneMinusSrcAlpha
			// �ҽ� ����(SrcColor)�� �����ͼ� �ҽ� ����(SrcAlpha)�� ���� ����
			// ���� ����
			// ���Ҹ��� �̰�

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
				// �ڵ� �����
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
				// uv ����
				//float4 uvColor = float4(i.uv.r, i.uv.g, 1, 1);
				// �ؽ��� ����
				float4 color1 = tex2D(_MainTex, i.uv);
				float4 color2 = tex2D(_SecondTex, i.uv);

				// �ؽ��� ����
				float4 lerpColor = lerp(color1, color2, _Tween);
				// �ؽ��� UV ���� �߰�
				float4 uvTexColor = color1 * float4(i.uv.r, i.uv.g, 0, 1);

				// ȸ������ ����
				float luminance = color1.r * 0.3 + color1.g * 0.59 + 0.11 * color1.b;
				float4 luminanceColor = float4(luminance, luminance, luminance, color1.a);

				// ȸ���� ���� �߰�
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