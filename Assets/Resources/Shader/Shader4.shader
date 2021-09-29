
// 기본적인 수학 함수 사용

//Built-In Function
//https://www.shaderific.com/glsl-functions/

Shader "Custom/Shader4"
{
    Properties
    {
        // 기본적인 프로퍼티 설명은 이제 생략함
        
         _MainTex ("MainTex", 2D) = "white" {}
        _Lerp ("Lerp", Range(0, 1)) = 0
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
        float _Lerp;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 col = fixed4(0.3, 0.6, 0.9, 1);

            // lerp 함수로 가중치를 사용해서 색상을 설정
            // 인자 a와 b가 같은 타입이어야함
            // 인자 weight는... 보통 float을 쓰지만 a,b의 타입도 됨 (0 ~ 1의 노말값)
            fixed4 c2 = lerp(c, col, _Lerp);
            //fixed4 c2 = ((1 - _Lerp) * c) + (_Lerp * col);
            
            o.Emission = c2;
        }
        ENDCG
    }
}
