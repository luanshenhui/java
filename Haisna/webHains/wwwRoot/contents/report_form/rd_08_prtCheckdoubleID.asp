<%@LANGUAGE = VBSCRIPT%>

<%Option Explicit%>

<%
'---------------------------------------------------------------------
'
'   File Name : rd_08_prtCheckdoubleID.asp
'
'   Created Date : 2003.12.15
'
'   Modified Date : 2003.12.29
'
'   Copyright (C) e-Corporation Corporation. All rights reserved.
'
'---------------------------------------------------------------------

    Dim l_ScslDate
    Dim l_EcslDate
    '## 2007/05/21 �� �\��󋵂���������ɒǉ�
    Dim l_RsvStatus
    Dim l_RsvStatusName
    Dim l_perID
    Dim l_useID

    l_ScslDate = Request("p_ScslDate")
    l_EcslDate = Request("p_EcslDate")
    '## 2007/05/21 �� �\��󋵂���������ɒǉ� Start
    l_RsvStatus = Request("p_RsvStatus")
    '## 2007/05/21 �� �\��󋵂���������ɒǉ� End
    l_useID = Request("p_Uid")

    l_ScslDate = Mid(l_ScslDate, 1, 4) & Mid(l_ScslDate, 6, 2) & Mid(l_ScslDate, 9, 2) 
    l_EcslDate = Mid(l_EcslDate, 1, 4) & Mid(l_EcslDate, 6, 2) & Mid(l_EcslDate, 9, 2) 

    '## 2007/05/21 �� �\��󋵂����ׂĂ̏ꍇ�A�����������O�����߂Ƀk���ݒ� Start
    If l_RsvStatus = "0" Then
       l_RsvStatusName = "�i �m�� �j"
    ElseIf l_RsvStatus = "1" Then
       l_RsvStatusName = "�i �ۗ� �j"
    ElseIf l_RsvStatus = "2" Then
       l_RsvStatusName = "�i ���m�� �j"
    Else 
       l_RsvStatusName = "�i ���ׂ� �j"
    End If

    If l_RsvStatus = "3" Then
        l_RsvStatus = " "
    End If
    '## 2007/05/21 �� �\��󋵂����ׂĂ̏ꍇ�A�����������O�����߂Ƀk���ݒ� End


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">

<OBJECT
    id=Rdviewer
    classid="clsid:309A42C6-4114-11D4-AF7B-30A024C32DBA" 
    codebase="http://157.104.16.194:8090/RDServer/rdviewer30.cab#version=3,0,0,398" 
    name=Rdviewer 
    width=100% height=100%>
</OBJECT>


<HEAD>
<SCRIPT TYPE="text/javascript" Language='JavaScript'>
<!--
    function LoadForm() 
    {
        Rdviewer.DisplayNoDataMsg(false);
        Rdviewer.SetBackgroundColor(255, 255, 255);
        Rdviewer.AutoAdjust = false;
        Rdviewer.ZoomRatio  = 100;
        /** 2007/05/21 �� �\��󋵂���������ɒǉ� Start **/
        //Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/08_prtCheckdoubleID.mrd", "/rp [<%= l_ScslDate %>] [<%= l_EcslDate %>]");
        Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/08_prtCheckdoubleID.mrd", "/rp [<%= l_ScslDate %>] [<%= l_EcslDate %>] [<%= l_RsvStatus %>] [<%= l_RsvStatusName %>]");
        /** 2007/05/21 �� �\��󋵂���������ɒǉ� End   **/
    }
//-->
</SCRIPT>
</HEAD>

<BODY onLoad="LoadForm();">
</BODY>
</HTML>