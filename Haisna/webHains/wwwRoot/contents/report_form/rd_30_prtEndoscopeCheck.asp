<%@LANGUAGE = VBSCRIPT%>
<%Option Explicit%>

<%

    Dim l_Uid                   '���O�C�����[�U�[ID
    Dim l_DayId                 '����ID
    Dim l_ScslDate              '��f��
    
    l_Uid       = Request("p_Uid")
    l_DayId     = Request("p_DayId")
    l_ScslDate  = Request("p_ScslDate")

    '## ��f���t�H�[�}�b�g�ύX
    l_ScslDate = Mid(l_ScslDate, 1, 4) & Mid(l_ScslDate, 6, 2) & Mid(l_ScslDate, 9, 2)

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
        /** 2007/09/06 �� �������`�F�b�N�V�[�g�V�K�쐬�ɂ��ύX(CoReport �� ReportDesigner) Start **/
        //Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/30_prtEndoscopeCheck.mrd", "/rp [<%= l_DayId %>] [<%= l_ScslDate %>]");
        Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/30_prtEndoscopeCheckList.mrd", "/rp [<%= l_DayId %>] [<%= l_ScslDate %>]");
        /** 2007/09/06 �� �������`�F�b�N�V�[�g�V�K�쐬�ɂ��ύX(CoReport �� ReportDesigner) End   **/
    }
//-->
</SCRIPT>
</HEAD>

<BODY onLoad="LoadForm();">
</BODY>
</HTML>