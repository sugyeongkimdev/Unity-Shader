
// 버텍스, 작성중
// 중요한 부분이니까 계속해서 수정해야할듯

Shader "Custom/Shader8"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // 나중에 찾아보고 작성할 예정
		#pragma surface surf Lambert 
        //#pragma surface surf Standard nomabient
		//#pragma surface surf Lambert vertex:vert

        struct Input
        {
            // 작성 예정
            // :COLOR = 시맨틱 표시자
            // 버텍스에서 색상을 받아오는 부분
            float4 color:COLOR;
        };
        
		void surf (Input IN, inout SurfaceOutput o)
        {
            // 버텍스 색상 표시
			//o.Emission = IN.color.r;
			o.Emission = IN.color.rgb;

            
            //o.Albedo = d.rgb * IN.color.r + e.rgb * IN.color.g + f.rgb * IN.color.b + 
            //          c.rgb * (1-(IN.color.r + IN.color.g + IN.color.b));
		}
        ENDCG
    }
}
