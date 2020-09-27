<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       特定保健指導対象有無登録 (Ver0.0.1)
'       AUTHER  : 張成斗（2009/03/30）
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const GUIDANCE_ITEMCD = "64074"     '特定保健指導　検査項目コード
Const GUIDANCE_SUFFIX = "00"        '特定保健指導　サフィックス

'データベースアクセス用オブジェクト
Dim objResult           '検査結果情報アクセス用
Dim RetResult           '結果検索復帰値
Dim strMessage          '結果登録復帰値

Dim strHTML             'HTML 格納領域

'パラメータ
Dim strAct              '処理状態
Dim strRsvNo            '予約番号

'UpdateResult_tk パラメータ
Dim vntItemCd           '検査項目コード
Dim vntSuffix           'サフィックス
Dim vntResult           '検査結果
Dim vntRslCmtCd1        '結果コメント１
Dim vntRslCmtCd2        '結果コメント２
Dim strIPAddress        'IPアドレス

Dim strResult           '特定保健指導区分（結果テーブル参照値：RSL）
Dim strSentenceCd       '文章コード
Dim lngFlgChk           'フラグチェック件数

Dim strUserId           'ユーザＩＤ
Dim strUserName         'ユーザ名

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objResult = Server.CreateObject("HainsResult.Result")

'パラメータ値の取得
strAct          = Request("action")
strRsvNo        = Request("rsvno")
strSentenceCd   = Request("guideKind")
strSentenceCd   = IIf( strSentenceCd="", "1", strSentenceCd )

strUserId       = Session.Contents("userId")
strIPAddress    = Request.ServerVariables("REMOTE_ADDR")

Do

    '確定
    If strAct = "save" Then
        
        vntItemCd = Array()
        Redim Preserve vntItemCd(0)
        vntItemCd(0) = GUIDANCE_ITEMCD

        vntSuffix  = Array()
        Redim Preserve vntSuffix(0)
        vntSuffix(0) = GUIDANCE_SUFFIX

        vntResult  = Array()
        Redim Preserve vntResult(0)
        vntResult(0) = strSentenceCd

        vntRslCmtCd1  = Array()
        Redim Preserve vntRslCmtCd1(0)
        vntRslCmtCd2  = Array()
        Redim Preserve vntRslCmtCd2(0)

        objResult.UpdateResult strRsvNo, strIPAddress, strUserId, vntItemCd, vntSuffix, vntResult, vntRslCmtCd1, vntRslCmtCd2, strMessage

        If Not IsEmpty(strMessage) Then
            Err.Raise 1000, , strMessage(0) & " " & vntResult(0)
            Err.Raise 1000, , "特定保健指導対象区分の登録ができませんでした。"
            Exit Do
        Else
            'エラーがなければ呼び元画面をリロードして自身を閉じる
            strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
            strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
            strHTML = strHTML & "</BODY>"
            strHTML = strHTML & "</HTML>"
            Response.Write strHTML
            Response.End
            Exit Do
        End If
    
    End If

    Exit Do

Loop

lngFlgChk = 0

'特定保健指導区分結果データ取得
RetResult = objResult.SelectRsl( strRsvNo, GUIDANCE_ITEMCD, GUIDANCE_SUFFIX, strResult )
If RetResult = True Then

    If strResult <> "" Then
        strSentenceCd   = strResult
        lngFlgChk = lngFlgChk + 1
    End If

End If


Set objResult   = Nothing

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>特定健診対象区分登録</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
    function saveAuther(){

/** 特定保健指導区分チェック有無の確認 Start   **/
/** チェックされていないとエラーメッセージ表示 **/
        var objRadio = document.entryForm;
        var j = 0;

        for(i=0 ; i < objRadio.elements.length ; i++)
        {
            if(objRadio.elements[i].type == "radio" || objRadio.elements[i].type == "RADIO" )
            {
                if(objRadio.elements[i].checked == true) {
                    j = j + 1;
                }
            }
        }
        if(j == 0){
            alert("特定保健指導対象区分を選択してください。");
            return;
        }
/** 特定保健指導区分チェック有無の確認 End   **/
        
        document.entryForm.action.value = "save";
        document.entryForm.submit();

    }

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden" NAME="action"  VALUE="<%= strAct %>">
    <INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= strRsvNo %>">

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">■</SPAN><FONT COLOR="#000000">特定保健指導区分登録</FONT></B></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<%
    '### 特定保健指導区分が登録されていなかった場合、未登録メッセージ表示
    If lngFlgChk = 0 Then
%>
        <TR>
            <TD COLSPAN="3"><FONT COLOR="#ff6600"><B>現在、特定保健指導区分が登録されていません。</B></FONT></TD>
        <TR>
<% 
    End If
%>
        <TR>
            <TD>特定保健指導</TD>
            <TD>&nbsp;：&nbsp;</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD><INPUT TYPE="radio" NAME="guideKind" VALUE="1"<%= IIf(strSentenceCd = "1", " CHECKED", "") %>></TD>
                        <TD>対象外</TD>
                        <TD><INPUT TYPE="radio" NAME="guideKind" VALUE="2"<%= IIf(strSentenceCd = "2", " CHECKED", "") %>></TD>
                        <TD>対象</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    
    <BR>
    <TABLE WIDTH="169" BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR>
            <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                <TD>
                    <A HREF="javascript:saveAuther()"><IMG SRC="../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存" border="0"></A>
                </TD>
            <%  end if  %>
            <TD><A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル" border="0"></A></TD>
        </TR>
    </TABLE>
    <BR>
</FORM>
</BODY>
</HTML>