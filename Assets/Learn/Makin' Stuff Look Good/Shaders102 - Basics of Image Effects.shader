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

			// ����Ƽ ��� ���
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
			// ���� �ؽ����� �ȼ�ũ��(�̸� �ؼ��̶�� ǥ��)�� ���� ���� �� �ֵ��� cg ���̴� �������� ����
			// ��ũ�� ũ�Ⱑ 1920/1080�̸� (1/1920, 1/1080)�� ��ȯ
			float4 _MainTex_TexelSize;
			
			// �߰� �ȼ����� 8������� �ȼ��� �����ؼ� ��հ��� ���� �����
			// �� 9���� ���ø� �ϹǷ� ������ ���� ���ҰŰ�����...
			float4 blurBox(sampler2D tex, float2 uv, float4 size)
			{
				float4 c = tex2D(tex, uv + float2(-size.x, size.y)) + tex2D(tex, uv + float2(0, size.y)) + tex2D(tex, uv + float2(size.x, size.y)) +
				tex2D(tex, uv + float2(-size.x, 0)) + tex2D(tex, uv + float2(0, 0)) + tex2D(tex, uv + float2(size.x, 0)) +
				tex2D(tex, uv + float2(-size.x, -size.y)) + tex2D(tex, uv + float2(0, -size.y)) + tex2D(tex, uv + float2(size.x, -size.y));

				return c / 9;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				// ����Ƽ �ð�
				float timeNormal = _Time.y * 2;

				// uv ����
				float4 uvColor = float4(i.uv.r, i.uv.g, 0, 1);
				// MainTex
				float4 texColor = tex2D(_MainTex, i.uv);
				//float color = uvColor * texColor;
				//float4 color = texColor;

				//  disp xy ����
				float2 disp = tex2D(_DisplaceTex, i.uv).xy;
				// 0~1 -> -1~1 
				disp = ((disp * 2) - 1) * _Magnitude;
				//float color = tex2D(_MainTex, i.uv + disp);

				// dist UV �︵��
				float disp2 = tex2D(_DisplaceTex, i.uv + timeNormal).xy;
				disp2 = ((disp2 * 2) - 1) * _Magnitude;
				//float color = tex2D(_MainTex, i.uv + disp2);

				// ��ó��
				float4 blureColor = blurBox(_MainTex, i.uv, _MainTex_TexelSize);
				float4 color = blureColor;


				return color;
			}
			ENDCG
		}
	}
}