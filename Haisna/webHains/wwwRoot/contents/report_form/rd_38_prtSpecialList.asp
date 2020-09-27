<%@ LANGUAGE="VBScript" %>

<%
'-------------------------------------------------------------------------------
'   特定健診受診者リスト (Ver0.0.1)
'   AUTHER  :
'-------------------------------------------------------------------------------
Option Explicit
%>

<%
    Dim l_useID             'ログインユーザーID
    Dim l_strSendDate       '検索開始日(受診日)
    Dim l_strUrl            'RD帳票ファイルを設定

    l_useID         = Request("p_Uid")          'ログインユーザID
    l_strSendDate   = Request("p_strSendDate")  '受診日(検索開始日)

    l_strUrl = "38_prtSpecialList.mrd"     '女性受診者リスト帳票
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<OBJECT 
    id=Rdviewer
    classid="clsid:309A42C6-4114-11D4-AF7B-30A024C32DBA" 
    codebase="http://157.104.16.194:8090/RDServer/rdviewer30.cab#version=3,0,0,398" 
    name=Rdviewer width="100%" height="100%">
</OBJECT>

<HEAD>
<SCRIPT TYPE="text/javascript" Language='JavaScript'>
<!--
    function LoadForm()
    {
        Rdviewer.DisplayNoDataMsg(false);
        Rdviewer.SetBackgroundColor(255, 255, 255);
        Rdviewer.AutoAdjust = false;
        Rdviewer.ZoomRatio = 100;
        Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/<%= l_strUrl %>", "/rp [<%= l_strSendDate %>]");
    }
//-->
</SCRIPT>
</HEAD>

<BODY onLoad="LoadForm();"></BODY>
</HTML>