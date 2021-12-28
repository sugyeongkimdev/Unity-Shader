using UnityEngine;


[ExecuteInEditMode]
public class Shaders102_Basics_of_Image_Effects : MonoBehaviour
{
    public Material effectMat;

    [Range(0, 10)] public int iterations;
    [Range(0, 4)] public int downRes;

    // 이미지 랜더 직전에 호출됨
    private void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        // https://docs.unity3d.com/kr/530/ScriptReference/Graphics.Blit.html
        // 소스 텍스쳐를 쉐이더를 이용하여 렌더 텍스쳐에 복사
        //Graphics.Blit(src, dst, effectMat);

        //========================================/

        // 이하 블러 효과

        // 해상도 설정(해상도 스케일링)
        // downRes가 늘어날수록 비트가 왼쪽으로 이동하므로 value/2*downRes가 됨
        int width = src.width >> downRes;
        int height = src.height >> downRes;

        // 렌더링 텍스쳐 임시할당 생성
        RenderTexture rt = RenderTexture.GetTemporary(width, height);
        Graphics.Blit(src, rt);

        for (int i = 0; i < iterations; i++)
        {
            RenderTexture rt2 = RenderTexture.GetTemporary(width, height);
            Graphics.Blit(rt, rt2, effectMat);
            // GetTemporary로 임시 할당된 렌더링 텍스쳐를 해제
            RenderTexture.ReleaseTemporary(rt);
            rt = rt2;
        }

        Graphics.Blit(rt, dst);
        RenderTexture.ReleaseTemporary(rt);
    }
}
