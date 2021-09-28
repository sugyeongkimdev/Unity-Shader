#if UNITY_EDITOR

/*

Unity ShaderLab Document
https://docs.unity3d.com/kr/current/Manual/ShadersOverview.html

비쥬얼 스튜디오 Unity ShaderLeb 인텔리전스
https://github.com/wudixiaop/ShaderlabVS

ShaderLab 구문
https://docs.unity3d.com/kr/current/Manual/SL-Shader.html

Built-In Function
https://www.shaderific.com/glsl-functions/

MaterialPropertyDrawer
https://docs.unity3d.com/ScriptReference/MaterialPropertyDrawer.html

렌더링 파이프라인, 모니터에 대한 기본적인 이해
https://nullreferenceexception.tistory.com/53?category=730281

*/

using System;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshRenderer))]
[ExecuteInEditMode]
public class ShaderControll : MonoBehaviour
{

    // 쉐이더 선택
    [Range (1, 4)] public int shaderIndex = 1;

    // 인스턴스화한 메테리얼 접근용도
    public Material currentMaterial;

    // 해당 쉐이더를 인스펙터에 표시
    [TextArea(2,3)]
    public string currentShaderInfo;

    //===================================================//

    private MeshRenderer render;

    //===================================================//

    // 메테리얼 얻기
    private static Dictionary<string, Material> matCachedDic = new Dictionary<string, Material>();
    private string GetName () => $"Custom/Shader{shaderIndex}";
    private Material GetMaterial ()
    {
        if(!matCachedDic.TryGetValue (GetName(), out Material mat))
        {
            Shader shader = Shader.Find (GetName());
            mat = new Material (shader);
            matCachedDic.Add (GetName(), mat);
        }

        switch(shaderIndex)
        {
            case 1:
                currentShaderInfo = "기본적인 쉐이더";
                mat.SetTexture ("_MainTex", LoadTexture (1));
                break;
            case 2:
                currentShaderInfo = "텍스쳐 Lerp 블랜딩 기초";
                mat.SetTexture ("_MainTex", LoadTexture (100));
                mat.SetTexture ("_SubTex", LoadTexture (101));
                break;
            case 3:
                currentShaderInfo = "데이터 제어 기본 및 색상 제어 기본";
                mat.SetTexture ("_MainTex", LoadTexture (1));
                break;
            case 4:
                currentShaderInfo = "기본 내장 함수 사용";
                mat.SetTexture ("_MainTex", LoadTexture (1)); 
                break;
        }

        return currentMaterial = mat;
    }

    // Resouces 폴더에서 이미지 불러오기
    private Texture2D LoadTexture (int index = 1)
    {
        return Resources.Load<Texture2D> ($"Image/Image{index}");
    }

    //===================================================//
    private void Reset ()
    {
        matCachedDic.Clear ();
    }

    private void Update ()
    {
        if(!render)
        {
            render = GetComponent<MeshRenderer> ();
        }

        if(render.sharedMaterial?.name != GetName())
        {
            render.sharedMaterial = GetMaterial ();
        }
    }
}

#endif