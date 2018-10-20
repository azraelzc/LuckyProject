using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class ExportAssetBundle {

    public static string BuildTargetPath = Application.dataPath + "/StreamingAssets/";
    [MenuItem("Custom Editor/ExportAssetBundle")]
    static void Example()
    {

        //先删除原有的assetbundle
        string assetPath = BuildTargetPath + "AssetBundle/";
        DirectoryInfo assetfolder = new DirectoryInfo(assetPath);
        if (assetfolder.Exists)
        {
            assetfolder.Delete(true);
        }
        assetfolder.Create();
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
        AssetBundleBuild[] builds = new AssetBundleBuild[1];
        AssetBundleBuild abb = new AssetBundleBuild
        {
            assetBundleName = "myAssetBundle",
            // abb.assetBundleVariant = "hd";
            assetNames = str
        };
        builds[0] = abb;
        BuildPipeline.BuildAssetBundles(assetPath, builds, BuildAssetBundleOptions.None, BuildTarget.Android);
        AssetDatabase.Refresh();
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


    [MenuItem("Custom Editor/CopyPCResouces")]
    static void CopyPCResouces()
    {
        //复制资源
        {
            string path = Application.dataPath + "/AbAsset";
            string outPath = Application.dataPath + "/Resources/AbAsset";
            CopyOldLabFilesToNewLab(path, outPath);
        }
        Debug.Log("======CopyPCResouces end=======");
    }

    /// <summary>
    /// 拷贝oldlab的文件到newlab下面
    /// </summary>
    /// <param name="sourcePath">lab文件所在目录(@"~\labs\oldlab")</param>
    /// <param name="savePath">保存的目标目录(@"~\labs\newlab")</param>
    /// <returns>返回:true-拷贝成功;false:拷贝失败</returns>
    public static bool CopyOldLabFilesToNewLab(string sourcePath, string savePath)
    {
        if (!Directory.Exists(savePath))
        {
            Directory.CreateDirectory(savePath);
        }

        #region //拷贝labs文件夹到savePath下
        try
        {
            string[] labDirs = Directory.GetDirectories(sourcePath);//目录
            string[] labFiles = Directory.GetFiles(sourcePath);//文件
            if (labFiles.Length > 0)
            {
                for (int i = 0; i < labFiles.Length; i++)
                {
                    string path = labFiles[i];
                    if (!path.EndsWith(".meta"))//排除.meta文件
                    {
                        File.Copy(sourcePath + "\\" + Path.GetFileName(labFiles[i]), savePath + "\\" + Path.GetFileName(labFiles[i]), true);
                    }
                }
            }
            if (labDirs.Length > 0)
            {
                for (int j = 0; j < labDirs.Length; j++)
                {
                    Directory.GetDirectories(sourcePath + "\\" + Path.GetFileName(labDirs[j]));

                    //递归调用
                    CopyOldLabFilesToNewLab(sourcePath + "\\" + Path.GetFileName(labDirs[j]), savePath + "\\" + Path.GetFileName(labDirs[j]));
                }
            }
        }
        catch (Exception)
        {
            return false;
        }
        #endregion
        return true;
    }

    [MenuItem("Custom Editor/CopyLuaToPCPackage")]
    static void CopyLuaToPCPackage()
    {
        //复制lua
        {
            string[] fromPaths = { "Lua", "ToLua/Lua" };
            string[] outPaths = { "D:/project/GameEXE", "D:/project/GameEXE/Lua" };
            for (int i = 0; i < fromPaths.Length; i++)
            {
                string fromPath = Application.dataPath + "/LuaFramework/" + fromPaths[i];
                string outPath = outPaths[i];
                CopyOldLabFilesToNewLab(fromPath, outPath);
            }
        }
        Debug.Log("======CopyLuaToPCPackage end=======");
    }
}
