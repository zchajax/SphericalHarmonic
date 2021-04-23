using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SHCreator : MonoBehaviour
{
    public ComputeShader cShader;
    public Material mat;
    public Cubemap envCubeMap;

    private ComputeBuffer SHBuffer;

    void Awake()
    {
        SHBuffer = new ComputeBuffer(9, 16);

        int kernel = cShader.FindKernel("CSMain");
        cShader.SetBuffer(kernel, "RWSHBuffer", SHBuffer);
        cShader.SetTexture(kernel, "CubeMap", envCubeMap);
        cShader.Dispatch(kernel, 9, 1, 1);

        mat.SetBuffer("SHbuffer", SHBuffer);
    }
    private void OnDisable()
    {
        if (SHBuffer != null)
        {
            SHBuffer.Dispose();

            SHBuffer = null;
        }
    }
}
