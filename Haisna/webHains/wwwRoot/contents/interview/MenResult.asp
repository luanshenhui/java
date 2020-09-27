<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      検査結果表示～参照モード  (Ver0.0.1)
'      AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<!-- #include virtual = "/webHains/includes/interviewResult.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'パラメータ
Dim strWinMode          'ウィンドウモード
Dim lngRsvNo            '予約番号（今回分）
Dim strGrpNo            'グループNo
Dim strCsCd             'コースコード

Dim strUrlPara          'フレームへのパラメータ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strWinMode          = Request("winmode")
strGrpNo            = Request("grpno")
lngRsvNo            = Request("rsvno")
strCsCd             = Request("cscd")
strSelCsGrp         = Request("csgrp")

'### 2004/01/07 K.Kagawa コースしばりのデフォルト値を判断する
If strSelCsGrp = "" Then
    Dim objInterView    '面接情報アクセス用
    Dim lngCsGrpCnt     'コースグループ数
    Dim vntCsGrpCd      'コースグループコード

    'コースグループ取得
    Set objInterView = Server.CreateObject("HainsInterView.InterView")
    lngCsGrpCnt = objInterview.SelectCsGrp( lngRsvNo, vntCsGrpCd )
    If lngCsGrpCnt > 0 Then
        strSelCsGrp = vntCsGrpCd(0)
    Else
        strSelCsGrp = "0"
    End If
    Set objInterView = Nothing
End If

lngEntryMode        = Request("entrymode")
lngEntryMode        = IIf(lngEntryMode="", INTERVIEWRESULT_REFER, lngEntryMode)
'非表示フラグは参照モードのとき有効
If CStr(lngEntryMode) = CStr(INTERVIEWRESULT_REFER) Then
    lngHideFlg = Request("hideflg")
Else
    lngHideFlg = "0"
End If

'グループ情報取得
Call GetMenResultGrpInfo(strGrpNo)

'フレームへのパラメータ設定
strUrlPara = "?winmode=" & strWinMode 
strUrlPara = strUrlPara & "&rsvno=" & lngRsvNo
strUrlPara = strUrlPara & "&grpno=" & strGrpNo
strUrlPara = strUrlPara & "&cscd=" & strCsCd
strUrlPara = strUrlPara & "&csgrp=" & strSelCsGrp
strUrlPara = strUrlPara & "&entrymode=" & lngEntryMode
strUrlPara = strUrlPara & "&hideflg=" & lngHideFlg
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE><%= strMenResultTitle %>　検査結果表示</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<SCRIPT TYPE="text/javascript" language="javascript">
<!--
        /*** 2006.03.08 張 使っているモニターサイズに従って画面サイズ調整 ***/
        //self.moveTo(0,0);
        //if(screen.availWidth == 1024){
        //    self.resizeTo(screen.availWidth-30,screen.availHeight);
        if(screen.availWidth == 1680){
            self.resizeTo(screen.availWidth-230, screen.availHeight-30);
        }else{
        //    self.resizeTo(screen.availWidth-150,screen.availHeight);
            self.resizeTo(screen.availWidth-350,screen.availHeight-150);
        }

var params = {
    winmode:   "<%= strWinMode %>",
    grpno:     "<%= strGrpNo %>",
    rsvno:     "<%= lngRsvNo %>",
    cscd:      "<%= strCsCd %>",
    csgrp:     "<%= strSelCsGrp %>",
    entrymode: "<%= lngEntryMode %>",
    hideflg:   "<%= lngHideFlg %>"
};
//-->

</SCRIPT>
</HEAD>
<%
    Select Case lngMenResultTypeNo
    Case INTERVIEWRESULT_TYPE1
%>
    <FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="<%= IIf(strWinMode=1,150,65) %>,*">
        <FRAME NAME="header" SRC="MenResultHeader.asp<%= strUrlPara %>">
        <FRAME NAME="body1"  SRC="MenResultBody1.asp<%= strUrlPara %>">
    </FRAMESET>
<%
    Case INTERVIEWRESULT_TYPE2
%>
    <FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="<%= IIf(strWinMode=1,150,65) %>,*,5,*">
        <FRAME NAME="header" SRC="MenResultHeader.asp<%= strUrlPara %>">
        <FRAME NAME="body3"  SRC="<%= IIf(lngEntryMode=INTERVIEWRESULT_REFER,"MenResultBody3.asp","MenResultBody3Entry.asp") %><%= strUrlPara %>">
        <FRAME NAME="blank"  SRC="../common/blank.html">
        <FRAME NAME="body1"  SRC="MenResultBody1.asp<%=strUrlPara%>">
    </FRAMESET>
<%
    Case INTERVIEWRESULT_TYPE3
%>
    <FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="<%= IIf(strWinMode=1,150,65) %>,*">
        <FRAME NAME="header" SRC="MenResultHeader.asp<%= strUrlPara %>">
        <FRAME NAME="body3"  SRC="<%= IIf(lngEntryMode=INTERVIEWRESULT_REFER,"MenResultBody3.asp","MenResultBody3Entry.asp") %><%= strUrlPara %>">
    </FRAMESET>
<%
    End Select
%>
</HTML>
