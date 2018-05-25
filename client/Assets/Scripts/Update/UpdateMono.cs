using LuaFramework;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UpdateMono : MonoBehaviour {

    private UpdateUtil updateUtil;
	// Use this for initialization
	void Start () {
        updateUtil = new UpdateUtil();
        CheckVersion(); 
    }
	
	// Update is called once per frame
	void Update () {
		
	}

    public void CheckVersion() 
    {
        Debug.Log("====CheckVersion1=====" + Application.dataPath);
        Debug.Log("====CheckVersion2====="+Application.persistentDataPath); 
        StartCoroutine(updateUtil.CheckVersion((www) => {
            Debug.Log("====CheckVersion111=====" + www.text);
            //updateUtil.DownloadReources(www.text,(www1)=>{

            //});
        }));
    }

    private void UpdateState()
    {

    }
}
