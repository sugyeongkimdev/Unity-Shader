using UnityEngine;

// 버텍스 유틸
public class VertexUtil
{

    //============================================================//
    
    // https://stackoverflow.com/questions/45854076/set-color-for-each-vertex-in-a-triangle

    // 메쉬의 각 정점으로 삼각형 만들어서 나누기
    public static void SplitMesh (Mesh mesh)
    {
        int[] triangles = mesh.triangles;
        Vector3[] verts = mesh.vertices;
        Vector3[] normals = mesh.normals;
        Vector2[] uvs = mesh.uv;

        int leng = triangles.Length;
        Vector3[] newVerts = new Vector3[leng];
        Vector3[] newNormals = new Vector3[leng];
        Vector2[] newUvs = new Vector2[leng];

        for(int i = 0; i < leng; i++)
        {
            newVerts[i] = verts[triangles[i]];
            newNormals[i] = normals[triangles[i]];
            if(uvs.Length > 0)
            {
                newUvs[i] = uvs[triangles[i]];
            }
            triangles[i] = i;
        }

        mesh.vertices = newVerts;
        mesh.normals = newNormals;
        mesh.uv = newUvs;
        mesh.triangles = triangles;
    }

    // 각 버텍스 정점에 색 칠하기
    public static void DrawColor (Mesh mesh)
    {
        Color[] colors = new Color[mesh.vertexCount];
        for(int i = 0; i < colors.Length; i += 3)
        {
            colors[i] = Color.red;
            colors[i + 1] = Color.green;
            colors[i + 2] = Color.blue;
        }
        mesh.colors = colors;
    }

    //============================================================//
}
