using LuaFramework;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UpdateUtil
{
    public delegate void DownloadCallBack(WWW w);
    public DownloadCallBack downloadCallBack;
    public UpdateUtil()
    {

    }

    private void Init()
    {
        
        
    }

    public IEnumerator CheckVersion(DownloadCallBack cb)
    {
        string url = AppConst.WebUrl + "testHttpServer";  
        return DownloadFile(url, cb);
    }

    public IEnumerator DownloadReources(string path,DownloadCallBack cb)
    {
        string url = AppConst.WebUrl + "testHttpServer/"+ path;
        return DownloadFile(url, cb);
    }

    private IEnumerator DownloadFile(string Path, DownloadCallBack cb) 
    {
        Debug.Log("==DownloadFile===" + Path);
        WWW www = new WWW(Path);
        while (!www.isDone)
        {
            yield return new WaitForEndOfFrame();
        }
        Debug.Log("==DownloadFile size3==" + www.bytesDownloaded + " : "  + www.bytes.ToString());
        if (cb != null)
        {
            cb.Invoke(www);
        }
    }

    public void Destroy()
    {

    }
}
