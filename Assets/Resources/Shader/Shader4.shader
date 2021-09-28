
// 기본적인 수학 함수 사용

//Built-In Function
//https://www.shaderific.com/glsl-functions/

Shader "Custom/Shader4"
{
    Properties
    {
        // 기본적인 프로퍼티 설명은 이제 생략함

         _MainTex ("MainTex", 2D) = "white" {}

        _Color ("Color", Color) = (0.3, 0.6, 0.9, 1)
        _ColorLerp ("Color Lerp", Range(0, 1)) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        #pragma surface surf Standard

        struct Input
        {
            float2 uv_MainTex;
        };
        
        sampler2D _MainTex;
        fixed4 _Color;
        float _ColorLerp;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 lerpColor = lerp(c, _Color, _ColorLerp);

            o.Emission = lerpColor;
        }
        ENDCG
    }
}
