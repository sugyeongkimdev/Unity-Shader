
// UV 기초

Shader "Custom/Shader5"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard
        sampler2D _MainTex;

        // UV는 float2 형태이며 좌측 하단이 기준이다 (OpenGL 좌표계)
        // 0 ~ 1의 값을 사용 (x, y) 또는 (u, v)
        // (0.0, 1.0) (0.5, 1.0) (1.0, 1.0)
        // (0.0, 0.5) (0.5, 0.5) (1.0, 0.5)
        // (0.0, 0.0) (0.5, 0.0) (1.0, 0.0)

        // UV를 수정할 때 Texture asset에서의 Wrap Mode 설정
        // Repeat       - UV 반복
        // Clamp        - UV 범위 밖은 마지막 색상으로 채우기
        // Mirror       - 거울처럼 반사
        // Mirror Once  - Mirror 후 Clamp
        // Per-axis     - U축과 V축을 따로 설정

        // ※ 쉐이더와 시간       (타입)                            값(x,     y,      z,          w) (t = time) 
        // _Time                float4 - 씬이 열린 후 부터의 시간     (t/20,  t,      t*2,        t*3)
        // _SinTime             float4 - Sin 그래프 시간             (t/8,   t/4,    t/2,        t)
        // _CosTime             float4 - Cos 그래프 시간             (t/8,   t/4,    t/2,        t)
        // unity_DeltaTime      float4 - 프레임간  시간차            (dt,    1/dt,   smoothDt,   1/smoothDt)

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // 일반 uv 텍스쳐 색상 생성
            //fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            // uv + (0.5, 0.5) 생성
            //fixed4 c = tex2D (_MainTex, IN.uv_MainTex +0.5);
            // uv + time 생성
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex + _Time.y);
            
            // 일반 텍스쳐 생성
            //o.Emission = c;

            // uv의 x 흑백 값(r)
            //o.Emission = IN.uv_MainTex.x;
            //o.Emission = IN.uv_MainTex.r;
            
            // uv의 y 흑백 값(g)
            //o.Emission = IN.uv_MainTex.y;
            //o.Emission = IN.uv_MainTex.g;
            
            // uv의 x,y 흑백 값(rg)
            //o.Emission = IN.uv_MainTex.x * IN.uv_MainTex.y;
            
            // (uv -> xy -> rg) 컬러값(rg0)
            //o.Emission = float3 (IN.uv_MainTex.x, IN.uv_MainTex.y, 0);

            o.Emission = c;
        }
        ENDCG
    }
}
