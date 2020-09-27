<%@ LANGUAGE="VBScript" %>

<%
'-------------------------------------------------------------------------------
'   郵便物受領書印刷(請求書、成績表） (Ver0.0.1)
'   AUTHER  :
'-------------------------------------------------------------------------------
Option Explicit
%>

<%
    Dim l_useID             'ログインユーザーID
    Dim l_strSendDate       '検索開始日(発送日)
    Dim l_endSendDate       '検索終了日(発送日)
    Dim l_Option            '帳票の種類
    Dim l_strCscd           '検索コース
    Dim l_strLoginId        '検索担当者ID
    Dim l_strEtc            'コースのその他を対応する為
    Dim l_strUrl            'RD帳票ファイルを設定

    l_useID         = Request("p_Uid")          'ログインユーザID
    l_strSendDate   = Request("p_strSendDate")  '発送日(検索開始日)
    l_endSendDate   = Request("p_endSendDate")  '発送日(検索終了日)
    l_Option        = Request("p_Option")       '郵便物種類
    l_strCscd       = Request("p_strCscd")      '対象コース
    l_strLoginId    = Request("p_strLoginId")   '対象担当者ログインID

    l_strUrl = ""
    IF l_Option = "0" THEN
        l_strUrl = "prtPostBill.mrd"        '郵便物受領書(団体請求書)
    ELSE
        l_strUrl = "prtPostReport.mrd"      '郵便物受領書(成績表)
        '選択コースがその他の場合、1日人間ドック、企業健診、渡航内科、肺ドック以外のコースを抽出するため
        IF l_strCscd = "999" THEN
            l_strCscd = ""
            l_strEtc = "1"
        END IF
    END IF
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
<%
    IF l_Option = "0" THEN
    '団体請求書の場合
%>
        Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/<%= l_strUrl %>", "/rp [<%= l_strSendDate %>] [<%= l_endSendDate %>] [<%= l_strLoginId %>]");
<%
    ELSE
    '成績表の場合
%>
        //alert("/rp [<%= l_strSendDate %>] [<%= l_endSendDate %>] [<%= l_strCscd %>] [<%= l_strEtc %>]");
        Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/<%= l_strUrl %>", "/rp [<%= l_strSendDate %>] [<%= l_endSendDate %>] [<%= l_strCscd %>] [<%= l_strEtc %>] [<%= l_strLoginId %>]");
<%
    END IF
%>
    }
//-->
</SCRIPT>
</HEAD>

<BODY onLoad="LoadForm();"></BODY>
</HTML>