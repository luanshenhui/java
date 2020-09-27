<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       契約情報(契約基本情報の設定) (Ver0.0.1)
'       AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const MODE_SAVE        = "save" '処理モード（保存）
Const AGECALC_CSLDATE  = 0      '年齢起算方法（受診日指定）
Const AGECALC_DIRECT   = 1      '年齢起算方法（起算日指定）

'データベースアクセス用オブジェクト
Dim objContract         '契約管理情報アクセス用
Dim objContractControl  '契約情報アクセス用

'引数値
Dim strMode             '処理モード
Dim strCtrPtCd          '契約パターンコード
Dim strOrgCd1           '団体コード１
Dim strOrgCd2           '団体コード２
Dim strCsCd             'コースコード
Dim strCtrCsName        '(契約パターン情報の)コース名
Dim strCtrCsEName       '(契約パターン情報の)英語コース名
Dim strCslMethod        '予約方法
Dim lngAgeCalc          '年齢起算方法
Dim lngAgeCalcYear      '年齢起算日（年）
Dim lngAgeCalcMonth     '年齢起算日（月）
Dim lngAgeCalcDay       '年齢起算日（日）

'契約管理情報
Dim strOrgName          '団体名
Dim strCsName           'コース名
Dim dtmStrDate          '契約開始日
Dim dtmEndDate          '契約終了日

Dim strAgeCalc          '年齢起算日
Dim strStrDate          '編集用の契約開始日
Dim strEndDate          '編集用の契約終了日
Dim strMessage          'エラーメッセージ
Dim strHTML             'HTML文字列

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")

'引数値の取得
strMode         = Request("mode")
strCtrPtCd      = Request("ctrPtCd")
strOrgCd1       = Request("orgCd1")
strOrgCd2       = Request("orgCd2")
strCsCd         = Request("csCd")
strCtrCsName    = Request("csName")
strCtrCsEName   = Request("csEName")
strCslMethod    = Request("cslMethod")
lngAgeCalc      = CLng("0" & Request("ageCalc"))
lngAgeCalcYear  = CLng("0" & Request("ageCalcYear"))
lngAgeCalcMonth = CLng("0" & Request("ageCalcMonth"))
lngAgeCalcDay   = CLng("0" & Request("ageCalcDay"))

'更新モードごとの処理制御
Do

    '保存ボタン押下時
    If strMode = MODE_SAVE Then

        '入力チェック
        strMessage = CheckValue()
        If Not IsEmpty(strMessage) Then
            Exit Do
        End If

        '年齢起算日の編集
        strAgeCalc = EditAgeCalc(lngAgeCalc, lngAgeCalcYear, lngAgeCalcMonth, lngAgeCalcDay)

        '契約パターンレコードの更新
        objContract.UpdateCtrPt strCtrPtCd, , , , strAgeCalc, strCtrCsName, strCtrCsEName, strCslMethod

        'エラーがなければ呼び元(契約情報)画面をリロードして自身を閉じる
        strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
        strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
        strHTML = strHTML & "</BODY>"
        strHTML = strHTML & "</HTML>"
        Response.Write strHTML
        Response.End

    End If

    '契約パターン情報読み込み
    objContract.SelectCtrPt strCtrPtCd, , , strAgeCalc, , strCtrCsName, strCtrCsEName, strCslMethod

    '年齢起算日の設定
    Select Case Len(strAgeCalc)
        Case 8
            lngAgeCalc      = AGECALC_DIRECT
            lngAgeCalcYear  = CLng("0" & Mid(strAgeCalc, 1, 4))
            lngAgeCalcMonth = CLng("0" & Mid(strAgeCalc, 5, 2))
            lngAgeCalcDay   = CLng("0" & Mid(strAgeCalc, 7, 2))
        Case 4
            lngAgeCalc      = AGECALC_DIRECT
            lngAgeCalcYear  = 0
            lngAgeCalcMonth = CLng("0" & Mid(strAgeCalc, 1, 2))
            lngAgeCalcDay   = CLng("0" & Mid(strAgeCalc, 3, 2))
        Case Else
            lngAgeCalc      = AGECALC_CSLDATE
            lngAgeCalcYear  = 0
            lngAgeCalcMonth = 0
            lngAgeCalcDay   = 0
    End Select

    Exit Do
Loop

'契約管理情報を読み、団体・コースの名称及び契約期間を取得する
If objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate) = False Then
    Err.Raise 1000, ,"契約情報が存在しません。"
End If

'-------------------------------------------------------------------------------
'
' 機能　　 : 年齢起算日の編集
'
' 引数　　 : (In)     lngAgeCalc       年齢起算方法
' 　　　　 : (In)     lngAgeCalcYear   年齢起算日（年）
' 　　　　 : (In)     lngAgeCalcMonth  年齢起算日（月）
' 　　　　 : (In)     lngAgeCalcDay    年齢起算日（日）
'
' 戻り値　 : 年齢起算日
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditAgeCalc(lngAgeCalc, lngAgeCalcYear, lngAgeCalcMonth, lngAgeCalcDay)

    EditAgeCalc = IIf(lngAgeCalc = 1, IIf(lngAgeCalcYear <> 0, Right("0000" & lngAgeCalcYear, 4), "") & Right("00" & lngAgeCalcMonth, 2) & Right("00" & lngAgeCalcDay, 2), "")

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 引数値の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim objCommon   '共通クラス

    Dim strMessage  'エラーメッセージ

    'オブジェクトのインスタンス作成
    Set objCommon = Server.CreateObject("HainsCommon.Common")

    'コース名チェック
    objCommon.AppendArray strMessage, objCommon.CheckWideValue("コース名", strCtrCsName, 30, CHECK_NECESSARY)

    '英語コース名チェック
    objCommon.AppendArray strMessage, objCommon.CheckNarrowValue("英語コース名", strCtrCsEName, 30)

    '年齢起算方法が「起算日を直接指定」の場合は年齢起算日チェックを行う
    Do
        '受診日で起算する場合は不要
        If lngAgeCalc = 0 Then
            Exit Do
        End If

        '月日が指定されていない場合はエラー
        If lngAgeCalcMonth + lngAgeCalcDay = 0 Then
            objCommon.AppendArray strMessage, "年齢起算日を直接指定する場合は月日を入力して下さい。"
            Exit Do
        End If

        '年が指定されていない場合の月日チェック(閏年でない任意の年を使用して年月日チェックを行う)
        If lngAgeCalcYear = 0 Then
            If Not IsDate("2001/" & lngAgeCalcMonth & "/" & lngAgeCalcDay) Then
                objCommon.AppendArray strMessage, "年齢起算日の入力形式が正しくありません。"
            End If

        '年が指定されている場合の月日チェック
        Else
            If Not IsDate(lngAgeCalcYear & "/" & lngAgeCalcMonth & "/" & lngAgeCalcDay) Then
                objCommon.AppendArray strMessage, "年齢起算日の入力形式が正しくありません。"
            End If
        End If

        Exit Do
    Loop

    '戻り値の編集
    CheckValue = strMessage

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>契約基本情報の設定</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function submitForm( mode ) {
    document.entryForm.mode.value = mode;
    document.entryForm.submit();
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden" NAME="mode"     VALUE="">
    <INPUT TYPE="hidden" NAME="ctrPtCd"  VALUE="<%= strCtrPtCd %>">
    <INPUT TYPE="hidden" NAME="orgCd1"   VALUE="<%= strOrgCd1  %>">
    <INPUT TYPE="hidden" NAME="orgCd2"   VALUE="<%= strOrgCd2  %>">
    <INPUT TYPE="hidden" NAME="csCd"     VALUE="<%= strCsCd    %>">
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">■</SPAN><FONT COLOR="#000000">契約基本情報の設定</FONT></B></TD>
        </TR>
    </TABLE>
<%
    'エラーメッセージの編集
    Call EditMessage(strMessage, MESSAGETYPE_WARNING)

    '編集用の契約開始日設定
    If Not IsEmpty(dtmStrDate) Then
        strStrDate = FormatDateTime(dtmStrDate, 1)
    End If

    '編集用の契約終了日設定
    If Not IsEmpty(dtmEndDate) Then
        strEndDate = FormatDateTime(dtmEndDate, 1)
    End If
%>
    <BR>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD>契約団体</TD>
            <TD>：</TD>
            <TD><B><%= strOrgName %></B></TD>
        </TR>
        <TR>
            <TD HEIGHT="22" NOWRAP>対象コース</TD>
            <TD>：</TD>
            <TD><B><%= strCsName %></B></TD>
        </TR>
        <TR>
            <TD>契約期間</TD>
            <TD>：</TD>
            <TD><B><%= strStrDate %>～<%= strEndDate %></B></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
        </TR>
            <TD NOWRAP>コース名</TD>
            <TD>：</TD>
            <TD><INPUT TYPE="text" NAME="csName" SIZE="52" MAXLENGTH="15" VALUE="<%= strCtrCsName %>" STYLE="ime-mode:active;"></TD>
            <TD NOWRAP><FONT COLOR="#999999">※この契約で適用するコース名を設定します。</FONT></TD>
        </TR>
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD NOWRAP>英語コース名</TD>
            <TD>：</TD>
            <TD COLSPAN="2"><INPUT TYPE="text" NAME="csEName" SIZE="52" MAXLENGTH="30" VALUE="<%= strCtrCsEName %>" STYLE="ime-mode:disabled;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD NOWRAP>予約方法</TD>
            <TD>：</TD>
            <TD COLSPAN="2">
                <SELECT NAME="cslMethod">
                    <OPTION VALUE="">&nbsp;
                    <OPTION VALUE="1"<%= IIf(strCslMethod = "1", " SELECTED", "") %>>本人TEL(全部)
                    <OPTION VALUE="2"<%= IIf(strCslMethod = "2", " SELECTED", "") %>>本人TEL(FAX有り)
                    <OPTION VALUE="3"<%= IIf(strCslMethod = "3", " SELECTED", "") %>>本人E-MAIL
                    <OPTION VALUE="4"<%= IIf(strCslMethod = "4", " SELECTED", "") %>>担当者TEL(全部)
                    <OPTION VALUE="5"<%= IIf(strCslMethod = "5", " SELECTED", "") %>>担当者仮枠(FAX)
                    <%'### 2009.04.20 張 予約方法項目追加「8：担当者仮枠(郵送)」 Start ###%>
                    <OPTION VALUE="8"<%= IIf(strCslMethod = "8", " SELECTED", "") %>>担当者仮枠(郵送)
                    <%'### 2009.04.20 張 予約方法項目追加「8：担当者仮枠(郵送)」 End   ###%>
                    <OPTION VALUE="6"<%= IIf(strCslMethod = "6", " SELECTED", "") %>>担当者リスト
                    <OPTION VALUE="7"<%= IIf(strCslMethod = "7", " SELECTED", "") %>>担当者E-MAIL
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD>年齢起算日</TD>
            <TD>：</TD>
            <TD COLSPAN="2">
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD><INPUT TYPE="radio" NAME="ageCalc" VALUE="0" <%= IIf(lngAgeCalc = "0", "CHECKED", "") %>></TD>
                        <TD NOWRAP>受診日で起算する</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD></TD><TD></TD>
            <TD COLSPAN="2">
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD><INPUT TYPE="radio" NAME="ageCalc" VALUE="1"<%= IIf(lngAgeCalc = "1", " CHECKED", "") %>></TD>
                        <TD NOWRAP>起算日を直接指定&nbsp;</TD>
                        <TD NOWRAP>起算年：</TD>
                        <TD><%= EditSelectNumberList("ageCalcYear", YEARRANGE_MIN, YEARRANGE_MAX, lngAgeCalcYear) %></TD>
                        <TD NOWRAP>&nbsp;起算月日：</TD>
                        <TD><%= EditSelectNumberList("ageCalcMonth", 1, 12, lngAgeCalcMonth) %></TD>
                        <TD>月</TD>
                        <TD><%= EditSelectNumberList("ageCalcDay", 1, 31, lngAgeCalcDay) %></TD>
                        <TD>日</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <BR>
    <A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A>
    <% '2005.08.22 権限管理 Add by 李　--- START %>
    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
        <A HREF="javascript:submitForm('<%= MODE_SAVE %>')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存"></A>
    <%  else    %>
         &nbsp;
    <%  end if  %>
    <% '2005.08.22 権限管理 Add by 李　--- END %>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
