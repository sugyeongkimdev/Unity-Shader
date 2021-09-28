
// 간단한 텍스쳐 합성 기능
// 정확히 작동하는 기능보다는 텍스쳐와 색상에 대해서 이해를 돕기위해서 작성됨

Shader "Custom/Shader2"
{
    Properties
    {
        // 텍스쳐
        _MainTex ("MainTex", 2D) = "white" {}
        _SubTex ("SubTex", 2D) = "white" {}
        // lerp weight
        _Lerp ("Lerp", Range(0, 1)) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard

        // uv 받기
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SubTex;
        };
        
        // 프로퍼티에 정의된 텍스쳐 샘플러
        sampler2D _MainTex;
        sampler2D _SubTex;
        float _Lerp;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // 각 텍스쳐 색상을 가져와서
            fixed4 c1 = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 c2 = tex2D (_SubTex, IN.uv_SubTex);

            // lerp 함수로 가중치를 사용해서 색상을 설정
            fixed4 c3 = lerp(c1, c2, _Lerp);

            // 생략된 부분이 있지만 위 lerp 함수는 아래와 같이 계산되어 작동한다고 보면 됨
            //fixed4 c3 = ((1 - _Lerp) * c1.rgba) + (_Lerp * c2.rgba);

            // 가중치가 적용된 색상을 적용
            o.Emission = c3;
            
        }
        ENDCG
    }
}
