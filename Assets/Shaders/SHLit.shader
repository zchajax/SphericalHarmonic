Shader "Custom/SHLit"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define PI 3.14159265358
            #define Y0(v) (1.0 / 2.0) * sqrt(1.0 / PI)
            #define Y1(v) sqrt(3.0 / (4.0 * PI)) * v.z
            #define Y2(v) sqrt(3.0 / (4.0 * PI)) * v.y
            #define Y3(v) sqrt(3.0 / (4.0 * PI)) * v.x
            #define Y4(v) 1.0 / 2.0 * sqrt(15.0 / PI) * v.x * v.z
            #define Y5(v) 1.0 / 2.0 * sqrt(15.0 / PI) * v.z * v.y
            #define Y6(v) 1.0 / 4.0 * sqrt(5.0 / PI) * (-v.x * v.x - v.z * v.z + 2 * v.y * v.y)
            #define Y7(v) 1.0 / 2.0 * sqrt(15.0 / PI) * v.y * v.x
            #define Y8(v) 1.0 / 4.0 * sqrt(15.0 / PI) * (v.x * v.x - v.z * v.z)

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL0;
                float4 vertex : SV_POSITION;
            };

            StructuredBuffer<float4> SHbuffer;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                float3 v = i.normal.xyz;
                v = normalize(v);
                float4 result =
                    SHbuffer[0] * Y0(v) +
                    SHbuffer[1] * Y1(v) +
                    SHbuffer[2] * Y2(v) +
                    SHbuffer[3] * Y3(v) +
                    SHbuffer[4] * Y4(v) +
                    SHbuffer[5] * Y5(v) +
                    SHbuffer[6] * Y6(v) +
                    SHbuffer[7] * Y7(v) +
                    SHbuffer[8] * Y8(v);

                return result;
            }
            ENDCG
        }
    }
}
