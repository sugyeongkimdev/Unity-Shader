
// 간단한 색상 변경 기능
// 그리고 기본적인 연산

Shader "Custom/Shader3"
{
    Properties
    {
        // 기본 MainTexture
         _MainTex ("MainTex", 2D) = "white" {}
        
        // 색상
        _Color ("Color", Color) = (1, 1, 1, 1)

        // 인스펙터에서 범위를 지정한다, Range(-1,1) == [Range(-1,1)]float
        _Brightness ("Brightness", Range(-1, 1)) = 0
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
        
        sampler2D _MainTex; // 프로퍼티에서 선언하지 않았지만 기본으로 있음
        fixed4 _Color;      // 색상
        float _Brightness;  // float 휘도

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // 샘플러와 uv로 텍스쳐 색상을 만들었고
            // 그 색상에 프로퍼티에서 선언한 색상을 곱해서 외부 색상에따라 변경되게 만듬
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            
            // 밝기만큼 색상을 더해서 조정
            c = c + _Brightness;
                        
            // 색상 반전
            //c = 1 - c;
            
            // 회색처리 (GrayScale)
            //c = (c.r + c.g + c.b) / 3;                    // 대충 작동은 하는 방식
            //c = (c.r * 0.299, c.g * 0.587, c.b * 0.114);  // 정확히 작동하는 계산식중 하나

            o.Emission = c.rgb;
        }
        ENDCG
    }
}
