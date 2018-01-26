using UnityEngine;
using System.Collections;
using FairyGUI;

namespace LuaFramework {

    /// <summary>
    /// </summary>
    public class Main : MonoBehaviour {

        void Start() {
            AppFacade.Instance.StartUp();   //启动游戏
            InitUI();
        }

        void InitUI()
        {
            GRoot.inst.SetContentScaleFactor(1334, 750);
            UIConfig.defaultFont = "afont";
            FontManager.RegisterFont(FontManager.GetFont("txjlzy"), "Tensentype JiaLiZhongYuanJ");
            FontManager.RegisterFont(FontManager.GetFont("STXINWEI_1"), "华文新魏");

            //取消所有超链接下划线显示
            FairyGUI.Utils.HtmlParseOptions.DefaultLinkUnderline = false;

            //UIObjectFactory.SetLoaderExtension(typeof(pg.MyGLoader));
        }
    }
}