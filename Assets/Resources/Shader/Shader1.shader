

// 쉐이더 "위치/이름"
Shader "Custom/Shader1"
{
    // 이하 ShaderLab이라는 유니티 자체 쉐이더 언어를 사용하여 작성함
    
    // 프로퍼티, 변수명("이름", 데이터타입) = 기본값
    // https://docs.unity3d.com/kr/current/Manual/SL-Properties.html
    Properties
    {
        // 텍스쳐 2D-2D이미지, "white"{}-비어있을경우 휜색 이미지로 변경
        // 이름이 바뀌어도 상관없지만 첫번째 텍스쳐를 _MainTex라고 쓰기 때문에 _MainTex를 사용할 경우
        // '쉐이더가 변경되어도' _MainTex는 유지될 수 있음
        _MainTex ("MainTex", 2D) = "white" {}

        // 색상
        _Color ("Color", Color) = (1, 1, 1, 1)
    }

    // 같은 부동소수이지만 할당된 크기가 틀림
    // float 32비트
    // half 16비트
    // fixed 11비트

    // 붙은 숫자에 따라 UnityEngine의 Vecot2, Vector3, Vector4 처럼 사용함
    // float    float2 (float, float)   float3 (float, float, float)    float4 (float, float, float, float)
    // half     half2  (half, half)     half3  (half, half, half)       half4  (half, half, half, half) 
    // fixed    fixed2 (fixed, fixed)   fixed3 (fixed, fixed, fixed)    fixed4 (fixed, fixed, fixed, fixed) 

    // Color (float, float, float, float)       색상으로 받음,    프로퍼티에서 컬러피커 생성
    // Vector (float, float, float, float)      값으로 받음,     프로퍼티에서 값 필드 생성

    // 2D       sampler중 하나
    // UV계산 전에는 텍스쳐를 색상(float4)로 나타낼 수 없는데 이 상태를 sampler라고 부름


    // 나눗셈보다 곱연산이 상대적으로 빠르고 나눗셈을 곱연산으로 대체 가능


    // 쉐이더
    SubShader
    {
        // 서브 쉐이더 태그
        // https://docs.unity3d.com/kr/current/Manual/SL-SubShaderTags.html
        Tags { "RenderType"="Opaque" }

        // CGPROGRAM, CG 프로그래밍 시작
        // 이하 표준 HLSL/Cg 셰이딩 언어로 작성됨
        CGPROGRAM

        // 이하 '#' 부분은 전처리 또는 스니핏이라고 부르는 부분
        // 쉐이더의 조명계산 설정, 기타 세부적인 분기를 정해주는 부분
        //#pragma surface surf Standard fullforwardshadows
        #pragma surface surf Standard

        // 쉐이더 모델 3.0 이상에서만 돌아가는 쉐이더를 만들겠다는 선언
        // 이 부분을 삭제하면 2.0에서도 돌아가는 쉐이더를 작성하겠다는것이지만 복잡한 기능은 사용할 수 없음
        // #pragma target 3.0

        // Level of Detail을 뜻하는 명령어, 환경설정 상중하같이 성능에 관여하는 부분
        // LOD 200
        
        //======================================================//
        // Input구조체에서 uv를 받아옴
        // uv는 Vertex에 있어서 Vertex에서 가져오는 것을 Input구조체에 넣어서 엔진에게 꺼내라고 명령함
        // 한마디로 엔진에서 받아와야 하는 데이터가 들어감
        // 아무 변수나 넣을 수 없고 정해진 규칙대로만 작성 가능
        // uv는 u와 v로 이루어진 float2이며 텍스쳐 샘플러 앞에 붙여서 이름을 정함
        // uv_MainTex, uv_subTex...

        // Vertex내부 데이터로는 대표적으로
        // 위치(Position), UV(Texcoord), 컬러(Color), 노멀(Normal), 탄젠트(Tangent) 등이 있음
        struct Input
        {
            float2 uv_MainTex;
        };
        //======================================================//
        
        // float4가 아니라 sample2D인 이유는 메모리에 올라왔지만 uv적용 전이기 때문
        // 메인 텍스쳐, material.mainTexture
        sampler2D _MainTex;

        // 위 Properties에서 선언된 변수를 아래와 같이
        // 동일한 형식과 이름으로 선언하면 Properties에서 입력된 외부 값을 가져올 수 있음
        fixed4 _Color;
        
        // 각 구조체의 내부 (SurfaceOutput, SurfaceOutputStandard, SurfaceOutputStandardSpecular)
        // https://docs.unity3d.com/kr/current/Manual/SL-SurfaceShaders.html

        // surf 함수, 색상이나 이미지가 출력되는 부분을 작성할 수 있음
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Color를 담기에는 float4는 할당 낭비임
            // 대부분의 텍스쳐 컬러는 채널당 8비트 이하이므로 fixed4를 사용하는게 효율적임
            // 다만 Color 타입 자체는 float4 (float, float, float, float)와 같음
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

            // 사칙연산 가능
            // float2(0.2, 0.2) + float2 (0.2, 0.2) = float2 (0.4, 0.4)
            // float2(0.2, 0.2) - float2 (0.2, 0.2) = float2 (0, 0)
            // float2(0.2, 0.2) * float2 (0.2, 0.2) = float2 (0.04, 0.04)
            // float2(0.2, 0.2) / float2 (0.2, 0.2) = float2 (1, 1)

            // 데이터 형태가 달라도 계산 가능
            // float2(0.5, 0.3) + 0.2 = float2 (0.7, 0.5)
            // float2(0.5, 0.3) - 0.2 = float2 (0.3, 0.1)
            // float2(0.5, 0.3) * 0.2 = float2 (0.1, 0.06)
            // float2(0.5, 0.3) / 0.2 = float2 (2.5, 1.5)
            
            // 색상은 0부터 1까지만 표현 가능
            // 하지만 위와 같이 데이터 자체는 표현값을 넘어서 유지한 채로 존재함
            
            // rgb를 통해서 순서에 상관없이 색상값에 접근할 수 있음
            //o.Emission = float3(c.r, c.g, c.b);
            //o.Emission = float3(c.rg, c.b);
            //o.Emission = float3(c.rb, c.g);
            //o.Emission = float3(c.gb, c.r);
            //o.Emission = c.rgb
            //o.Emission = c.rrr

            // 조명을 받는 색상 출력
            //o.Albedo = c.rgb;

            // 조명을 받지 않는 색상 출력
            o.Emission = c.rgb;
            
            // 해당 값들은 입력하지 않으면 0으로 입력한것으로 처리됨
            //o.Metallic = 0;
            //o.Smoothness = 0;
        }
        // ENDCG, CG 프로그래밍 끝
        ENDCG
    }

    // 위 SubShader에서 사용하는 그래픽카드에서 지원하지 못할 경우
    // Diffuse 쉐이더를 사용하겠다는 보험성 명령어임
    FallBack "Diffuse"
}
