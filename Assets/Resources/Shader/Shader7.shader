
// 노이즈 텍스쳐를 이용한 uv 수정
// 공부용으로 만들었기 때문에 이해는 쉽지만 성능에는 좋지 않음

Shader "Custom/Shader7"
{
    Properties
    {
        // 펄린 노이즈 선택
        [IntRange] _Perlin ("Perlin", range(0,4)) = 1

        // 노이즈 스케일링
        _NoiseScale ("NoiseScale", range(0,1)) = 0.1

        // 노이즈 텍스쳐
        _MainTex ("MainTex", 2D) = "" {}
        _SubTex1 ("SubTex1", 2D) = "" {}
        _SubTex2 ("SubTex2", 2D) = "" {}
        _SubTex3 ("SubTex3", 2D) = "" {}
        _SubTex4 ("SubTex4", 2D) = "" {}
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        
        #pragma surface surf Standard

        // target 4.0인 이유는 텍스쳐가 너무 많아서.
        // 공부목적이므로 텍스쳐와 성능에 관해서는 무시하는 사항
        #pragma target 4.0

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SubTex1;
            float2 uv_SubTex2;
            float2 uv_SubTex3;
            float2 uv_SubTex4;
        };
        
        int _Perlin;
        float _NoiseScale;
        sampler2D _MainTex;
        sampler2D _SubTex1;
        sampler2D _SubTex2;
        sampler2D _SubTex3;
        sampler2D _SubTex4;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // ※ HLSL에서 if 분기는 성능 문제가 있다고 함.
            // 문제는? HLSL에서 if-else 내용을 전부 계산하기 때문에 생기는 이슈
            // if-else 문제는 현재 쉐이더에서는 공부목적으로 작성되었으므로 무시하는 사항

            // 펄린 노이즈 선택, 0은 노이즈 없음
            fixed4 p;
            if(_Perlin == 0)        p = fixed4(_NoiseScale,_NoiseScale,_NoiseScale,_NoiseScale);
            else if(_Perlin == 1)   p = tex2D (_SubTex1, IN.uv_SubTex1);
            else if(_Perlin == 2)   p = tex2D (_SubTex2, IN.uv_SubTex2);
            else if(_Perlin == 3)   p = tex2D (_SubTex3, IN.uv_SubTex3);
            else if(_Perlin == 4)   p = tex2D (_SubTex4, IN.uv_SubTex4);
            
            // 선택된 펄린 노이즈 텍스쳐의 r채널 값을 사용해서 _MainTex의 uv를 변경함
            // 해당 _MainTex의 Wrap mode는 Repeat를 사용함 
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex + (p.r * _NoiseScale));

            // c3 표시
            o.Emission = c;
        }
        ENDCG
    }
}
