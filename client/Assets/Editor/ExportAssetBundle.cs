using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class ExportAssetBundle {
    [MenuItem("Custom Editor/ExportAssetBundle")]
    static void Example()
    {
        /*
         *  1.创建building map实体
         *  2.指定Assetubndle名称
         *  3.指定变体名称（可选）
         *  4.指定资源路径
         *  5.导出
         */
        List<string> fileNames = new List<string>();
        string path = Application.dataPath + "/AbAsset/";
        DirectoryInfo folder = new DirectoryInfo(path);
        FileInfo[] files = folder.GetFiles();
        DirectoryInfo[] dir = folder.GetDirectories();
        InsertFileName(folder, ref fileNames);
        string[] str = new string[fileNames.Count];
        for (int i = 0; i < fileNames.Count; i++)
        {
            string name = fileNames[i];
            Debug.Log("=====name=====" + name);
            str[i] = name;
        }
        AssetBundleBuild abb = new AssetBundleBuild
        {
            assetBundleName = "myAssetBundle",
            // abb.assetBundleVariant = "hd";
            assetNames = str
        };
        BuildPipeline.BuildAssetBundles("Assets/Resources/AssetBundle", new AssetBundleBuild[1] { abb }, BuildAssetBundleOptions.None, BuildTarget.Android);
    }

    private static void InsertFileName(DirectoryInfo dirInfo,ref List<string> files)
    {
        FileInfo[] fileInfos = dirInfo.GetFiles();
        for (int i = 0; i < fileInfos.Length; i++)
        {
            string fileName = fileInfos[i].FullName;

            if (!fileName.EndsWith("meta"))
            {
                fileName = fileName.Substring(fileName.IndexOf("Assets\\"));
                files.Add(fileName);
            }
        }
        DirectoryInfo[] dir = dirInfo.GetDirectories();
        if (dir.Length > 0)
        {
            for (int i = 0; i < dir.Length; i++)
            {
                InsertFileName(dir[i], ref files);
            }
        }
    }
}
