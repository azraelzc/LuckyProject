using System.Collections;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

public class DebugFrame : MonoBehaviour
{
    public static DebugFrame instance { get; private set; }
    public static bool debugMode = true;

    private string _format;
    private float _fps;
    private float _accum;
    public Rect labRect = new Rect(10, 70, 100, 20);
    private GUIStyle labStyle = new GUIStyle();
    public int fomsSize = 20;

    public float FPS
    {
        get { return _fps; }
    }

    void Awake()
    {
        if (instance == null)
        {
            instance = this;
            _sb = new StringBuilder();
        }
        else
        {
            Debug.LogError("multi instance!");
        }
    }

    void Start()
    {
        labStyle.fontSize = fomsSize;
    }

    void OnEnable()
    {
        _labStyle.fontSize = Screen.width / 40;
        Application.logMessageReceived += Application_logMessageReceived;
    }

    void OnDisable()
    {
        Application.logMessageReceived -= Application_logMessageReceived;
    }

    void Update()
    {
        _fps = 1 / Time.deltaTime;
        _format = string.Format("FPS:{0:F1}", _fps);
        freshColor();
    }

    private void freshColor()
    {
        if (_fps < 10)
        {
            labStyle.normal.textColor = Color.red;
        }
        else if (_fps < 25)
        {
            labStyle.normal.textColor = Color.yellow;
        }
        else
        {
            labStyle.normal.textColor = Color.green;
        }
    }

    private void Application_logMessageReceived(string condition, string stackTrace, LogType type)
    {
        OnHandleLog(condition, stackTrace, type);
    }

    private void AutoClear()
    {
        lock (_lockSign)
        {
            if (_messageList.Count > 200)
            {
                _messageList.RemoveRange(0, 100);
            }
        }
    }

    private StringBuilder _sb = null;

    private void OnHandleLog(string message, string stackTrace, LogType type)
    {
        AutoClear();

        _sb.Length = 0;
        _sb.Append("\n------------------------------------------------------------\n");
        _sb.Append(message);
        _sb.Append("\n");
        _sb.Append(stackTrace);
        lock (_lockSign)
        {
            _messageList.Add(new ConsoleMessage(_sb.ToString(), type));
        }
    }

    private bool _debug;
    private Rect _logButtonRect = new Rect(10, 10, 0.15f * Screen.width, 0.08f * Screen.height);
    private string _logButtonName = "日志";

    private Rect _debugAttachTextRect = new Rect(10, 100, 0.15f * Screen.width, 30);
    private string _debugAttachInfo = "调试服务器IP:Port";

    private Rect _debugAttachBtnRect = new Rect(10, 150, 0.15f * Screen.width, 0.08f * Screen.height);
    private string _debugAttachBtnTip = "开始调试";

    private Rect _debugEffectCheck = new Rect(10, 250, 0.15f * Screen.width, 0.08f * Screen.height);
    private string _debugEffectCheckBtnTip = "开始特效检测";

    private bool _showLogWindow;
    private Rect _logWindowRect = new Rect(0.02f * Screen.width,
                                             0.02f * Screen.height,
                                             Screen.width - (2 * 0.02f * Screen.width),
                                             Screen.height - (2 * 0.02f * Screen.height));
    private const int WINDOW_ID = 121121;

    void OnGUI()
    {
        GUI.skin.textField.fontSize = 18;
        GUI.skin.button.fontSize = 18;
        GUI.Label(labRect, _format, labStyle);
        if (debugMode)
        {
            _debug = GUI.Toggle(new Rect(0, 300, 100, 20), _debug, "Debug");
            if (_debug)
            {
                if (GUI.Button(_logButtonRect, _logButtonName))
                {
                    _showLogWindow = !_showLogWindow;
                }

                if (_showLogWindow)
                {
                    _logWindowRect = GUILayout.Window(WINDOW_ID, _logWindowRect, UpdateWindow, _logButtonName);
                }
                
                //_debugAttachInfo = GUI.TextField(_debugAttachTextRect, _debugAttachInfo);                
                //if (GUI.Button(_debugAttachBtnRect, _debugAttachBtnTip))
                //{
                //    _debug = false;
                //    pg.GameSceneMgr.Instance.LuaEventHandle.Call((int)pg.EventEnum.OnRemoteAttachDebug, _debugAttachInfo);                    
                //}

                //if (GUI.Button(_debugEffectCheck, _debugEffectCheckBtnTip))
                //{
                //    EffectFpsCheck.Begin(gameObject);
                //}
            }
        }
    }

    internal struct ConsoleMessage
    {
        public readonly string message;
        public readonly LogType type;

        public ConsoleMessage(string message, LogType type)
        {
            this.message = message;
            this.type = type;
        }
    }

    private Object _lockSign = new Object();
    private Vector2 _scrollPos;
    private List<ConsoleMessage> _messageList = new List<ConsoleMessage>();
    private bool _collapse = false;
    private GUIStyle _labStyle = new GUIStyle();
    private GUIContent _clearLabel = new GUIContent("Clear", "Clear the contents of the console.");
    private GUIContent _collapseLabel = new GUIContent("Collapse", "Hide repeated messages.");
    private Rect _dragRect = new Rect(0, 0, 10000, 20);

    void UpdateWindow(int windowID)
    {
        lock (_lockSign)
        {
            _scrollPos = GUILayout.BeginScrollView(_scrollPos);

            // Go through each logged entry
            for (int i = 0; i < _messageList.Count; i++)
            {
                ConsoleMessage entry = _messageList[i];

                // If this message is the same as the last one and the collapse feature is chosen, skip it
                if (_collapse && i > 0 && entry.message == _messageList[i - 1].message)
                {
                    continue;
                }

                // Change the text colour according to the log type
                switch (entry.type)
                {
                    case LogType.Error:
                    case LogType.Exception:
                        GUI.contentColor = Color.green;
                        _labStyle.normal.textColor = Color.green;
                        break;
                    case LogType.Warning:
                        GUI.contentColor = Color.yellow;
                        _labStyle.normal.textColor = Color.yellow;
                        break;
                    default:
                        GUI.contentColor = Color.white;
                        _labStyle.normal.textColor = Color.white;
                        break;
                }

                GUILayout.Label(entry.message, _labStyle);
            }

            GUI.contentColor = Color.white;

            GUILayout.EndScrollView();

            GUILayout.BeginHorizontal();

            // Clear button
            if (GUILayout.Button(_clearLabel))
            {
                _messageList.Clear();
            }

            // Collapse toggle
            _collapse = GUILayout.Toggle(_collapse, _collapseLabel, GUILayout.ExpandWidth(false));

            GUILayout.EndHorizontal();
            GUI.DragWindow(_dragRect);
        }
    }
}
