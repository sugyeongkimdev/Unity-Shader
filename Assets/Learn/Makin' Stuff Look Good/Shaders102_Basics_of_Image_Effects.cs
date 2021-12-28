using UnityEngine;


[ExecuteInEditMode]
public class Shaders102_Basics_of_Image_Effects : MonoBehaviour
{
    public Material effectMat;

    [Range(0, 10)] public int iterations;
    [Range(0, 4)] public int downRes;

    // �̹��� ���� ������ ȣ���
    private void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        // https://docs.unity3d.com/kr/530/ScriptReference/Graphics.Blit.html
        // �ҽ� �ؽ��ĸ� ���̴��� �̿��Ͽ� ���� �ؽ��Ŀ� ����
        //Graphics.Blit(src, dst, effectMat);

        //========================================/

        // ���� �� ȿ��

        // �ػ� ����(�ػ� �����ϸ�)
        // downRes�� �þ���� ��Ʈ�� �������� �̵��ϹǷ� value/2*downRes�� ��
        int width = src.width >> downRes;
        int height = src.height >> downRes;

        // ������ �ؽ��� �ӽ��Ҵ� ����
        RenderTexture rt = RenderTexture.GetTemporary(width, height);
        Graphics.Blit(src, rt);

        for (int i = 0; i < iterations; i++)
        {
            RenderTexture rt2 = RenderTexture.GetTemporary(width, height);
            Graphics.Blit(rt, rt2, effectMat);
            // GetTemporary�� �ӽ� �Ҵ�� ������ �ؽ��ĸ� ����
            RenderTexture.ReleaseTemporary(rt);
            rt = rt2;
        }

        Graphics.Blit(rt, dst);
        RenderTexture.ReleaseTemporary(rt);
    }
}
