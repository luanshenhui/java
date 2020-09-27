<%@LANGUAGE = VBSCRIPT%>
<%
'-----------------------------------------------------------------------------
'       メディローカス健診事前管理票印刷 (Ver0.0.1)
'       AUTHER  : 張　成斗
'-----------------------------------------------------------------------------
%>
<%Option Explicit%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"              -->
<%
    'セッション・権限チェック
    Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

    Dim l_IPAddress
    Dim vntMessage          '通知メッセージ
    Dim UID
    Dim l_rsvNo 
    Dim l_act
    Dim l_addrdiv
    Dim l_engdiv

    l_rsvNo     = Request("p_rsvNo")
    l_act       = Request("p_act")
    l_addrdiv   = Request("p_addrdiv")
    l_engdiv    = Request("p_engdiv")

    l_IPAddress     = Request.ServerVariables("REMOTE_ADDR")  '実行端末のIPアドレスを取得


    '帳票出力処理制御
    vntMessage = PrintControl(0)


    Sub GetQueryString()
        UID = Session("USERID")
    End Sub

    Function CheckValue()
    End Function

    Function Print()
        Dim objCommon       '共通クラス

        Dim objPrintCls     '健診事前管理票出力用COMコンポーネント
        Dim Ret             '関数戻り値

        If Not IsArray(CheckValue()) Then
            Set objCommon = Server.CreateObject("HainsCommon.Common")
        End If

        'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
        '英文出力の有無ごとの呼び先定義（最初は日本語版のみ）
        Select Case l_engdiv
            Case "jap"
                Set objPrintCls = Server.CreateObject("HainsprtReserveMedi.prtReserve_medi")
                'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
                Ret = objPrintCls.PrintOut(UID, l_rsvNo, l_addrdiv, l_engdiv, l_IPAddress)

            Case "eng"
                Set objPrintCls = Server.CreateObject("HainsprtReserveMedi.prtReserve_medi")
                'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
                Ret = objPrintCls.PrintOut(UID, l_rsvNo, l_addrdiv, l_engdiv, l_IPAddress)
            Case Else
        End Select
        Print = Ret
    End Function
%>

