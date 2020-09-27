<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'        印刷制御 (Ver0.0.1)
'        AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checksession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objConsult          '受診情報アクセス用

Dim strMode             'モード("0":はがき、"1":一式書式)
Dim strActMode          '動作モード("0":保存、"1":印刷)
Dim strRsvNo            '予約番号
Dim strAddrDiv          '住所区分
Dim strOutEng           '英文出力の有無

Dim strCardPrintDate    '確認はがき出力日時
Dim strFormPrintDate    '一式書式出日時
Dim strURL              'URL

Dim Ret                 '関数戻り値
Dim strCsCd             'コースコード

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strMode    = Request("mode")
strActMode = Request("actMode")
strRsvNo   = Request("rsvNo")
strAddrDiv = Request("addrDiv")
strOutEng  = Request("outEng")

'## 2015.05.08 張 メディローカスの予約時印刷するはがきやご案内書は別途管理の為修正 START ##############
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'印刷モードの場合は出力日更新制御を行う
'(保存モード時だと保存後の予約画面再表示とのタイムラグが気になるのでストアドに任せる)
If strActMode = "1" And strMode = "1" Then

    'オブジェクトのインスタンス作成

    '## 2015.05.08 張 メディローカスの予約時印刷するはがきやご案内書は別途管理の為修正  ##
    'Set objConsult = Server.CreateObject("HainsConsult.Consult")

    '受診情報テーブルレコード読込み処理
    objConsult.SelectConsultPrintStatus strRsvNo, strCardPrintDate, strFormPrintDate
    
    'モードごとの処理。対象となる帳票の印刷日時が存在しない場合にシステム日時を更新する。
    Select Case strMode
        Case "0"
            strCardPrintDate = IIf(strCardPrintDate = "", Now(), strCardPrintDate)
        Case "1"
            strFormPrintDate = IIf(strFormPrintDate = "", Now(), strFormPrintDate)
    End Select

    '印刷日時の更新
    objConsult.UpdateConsultPrintStatus strRsvNo, strCardPrintDate, strFormPrintDate

    '## 2015.05.08 張 メディローカスの予約時印刷するはがきやご案内書は別途管理の為修正  ##
    'Set objConsult = Nothing

End If

'受診情報を読み、現在のコースコードを取得
Ret = objConsult.SelectConsult(strRsvNo, , , ,strCsCd)
Set objConsult = Nothing

'## 2015.05.08 張 メディローカスの予約時印刷するはがきやご案内書は別途管理の為修正 END   ##############



'印刷用ASPに制御を移す
Do

    'モードごとの呼び先URL定義

'## 2015.05.08 張 メディローカスの予約時印刷するはがきやご案内書は別途管理 START ##
'    Select Case strMode
'        Case "0"
'            strURL = "/webHains/contents/report_form/hagaki.asp"
'        Case "1"
'            strURL = "/webHains/contents/report_form/annaisho.asp"
'        Case Else
'            Exit Do
'    End Select

    If Left(strCsCd, 1) = "M" Then
        'メディローカス関連コースの場合、別途様式で印刷
        Select Case strMode
            Case "0"
                strURL = "/webHains/contents/report_form/mHagaki.asp"
            Case "1"
                strURL = "/webHains/contents/report_form/mAnnaisho.asp"
            Case Else
                Exit Do
        End Select
    Else
        Select Case strMode
            Case "0"
                strURL = "/webHains/contents/report_form/hagaki.asp"
            Case "1"
                strURL = "/webHains/contents/report_form/annaisho.asp"
            Case Else
                Exit Do
        End Select
    End If

'## 2015.05.08 張 メディローカスの予約時印刷するはがきやご案内書は別途管理 END   ##


    '予約番号
    strURL = strURL & "?p_rsvNo=" & strRsvNo

    '動作モード
    If strActMode = "1" Then
        strURL = strURL & "&p_act=print"
    Else
        strURL = strURL & "&p_act=save"
    End If

    '住所区分
    Select Case strAddrDiv
        Case "1"
            strURL = strURL & "&p_addrdiv=house"
        Case "2"
            strURL = strURL & "&p_addrdiv=company"
        Case "3"
            strURL = strURL & "&p_addrdiv=etc"
    End Select

    '英文有無
    Select Case strOutEng
        Case "1"
            strURL = strURL & "&p_engdiv=eng"
        Case "0"
            strURL = strURL & "&p_engdiv=jap"
    End Select

    Response.Redirect strURL
    Response.End

    Exit Do
Loop
%>
