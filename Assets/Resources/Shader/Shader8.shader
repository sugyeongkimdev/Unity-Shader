
// 버텍스, 작성중

Shader "Custom/Shader8"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        //#pragma surface surf Standard Vertex:vetr
		#pragma surface surf Lambert vertex:vert
        #pragma target 3.0

        struct Input
        {
            //float2 uv_MainTex;
			float4 vertColor;
        };
        
        //sampler2D _MainTex;
        
		void vert(inout appdata_full v, out Input o){
			UNITY_INITIALIZE_OUTPUT(Input, o);
			o.vertColor = v.color;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			o.Emission = IN.vertColor.rgb;
		}
        ENDCG
    }
	FallBack "Diffuse"
}
