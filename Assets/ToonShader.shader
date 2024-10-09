Shader "Custom/ToonShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _RimColor ("Rim Color", Color) = (0,0.5,0.5,0.0)
        _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
        _RampTex ("Ramp Texture", 2D) = "white" {}
        _myFloat("Float", Float) = 0.5
    }
    SubShader
    {
        CGPROGRAM
        // uses the ToonRamp surface
        #pragma surface surf ToonRamp

        float4 _Color;
        sampler2D _RampTex;
        float _myFloat;
        float4 _RimColor;
        float _RimPower;

        //Toon lighting
        float4 LightingToonRamp(SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            float diff = dot(s.Normal, lightDir);
            float h = diff * 0.5 + 0.5;
            float2 rh = h;
            float3 ramp = tex2D(_RampTex, rh).rgb;

            float4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (ramp);
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Color.rgb;

            //Determining where the rim should be
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));

            o.Emission = _RimColor.rgb * pow(rim, _RimPower);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
