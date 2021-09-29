
// 텍스쳐 블랜딩

Shader "Custom/Shader6"
{
    Properties
    {
         _MainTex ("MainTex", 2D) = "white" {}
         _SubTex ("SubTex", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        
        // alpha:fade는 알파 사용, 최적화에 좋지 않으므로 공부용으로만 사용
        #pragma surface surf Standard alpha:fade
        
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SubTex;
        };
        
        sampler2D _MainTex;
        sampler2D _SubTex;
        float _Lerp;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c1 = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 c2 = tex2D (_SubTex, IN.uv_SubTex);

            // c1, c2를 c1의 알파값을 기준으로 블랜딩
            fixed4 c3 = lerp(c2, c1, c1.a);
            // 위와 같은 결과
            //fixed4 c3 = lerp(c1, c2, 1-c1.a);

            // 반대로 섞기
            //fixed4 c3 = lerp(c1, c2, c1.a);

            // c3 표시
            o.Emission = c3;
            o.Alpha = c3.a;

        }
        ENDCG
    }
}
