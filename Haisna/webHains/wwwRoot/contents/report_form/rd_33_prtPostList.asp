<%@ LANGUAGE="VBScript" %>

<%
'-------------------------------------------------------------------------------
'   �X�֕���̏����(�������A���ѕ\�j (Ver0.0.1)
'   AUTHER  :
'-------------------------------------------------------------------------------
Option Explicit
%>

<%
    Dim l_useID             '���O�C�����[�U�[ID
    Dim l_strSendDate       '�����J�n��(������)
    Dim l_endSendDate       '�����I����(������)
    Dim l_Option            '���[�̎��
    Dim l_strCscd           '�����R�[�X
    Dim l_strLoginId        '�����S����ID
    Dim l_strEtc            '�R�[�X�̂��̑���Ή������
    Dim l_strUrl            'RD���[�t�@�C����ݒ�

    l_useID         = Request("p_Uid")          '���O�C�����[�UID
    l_strSendDate   = Request("p_strSendDate")  '������(�����J�n��)
    l_endSendDate   = Request("p_endSendDate")  '������(�����I����)
    l_Option        = Request("p_Option")       '�X�֕����
    l_strCscd       = Request("p_strCscd")      '�ΏۃR�[�X
    l_strLoginId    = Request("p_strLoginId")   '�ΏےS���҃��O�C��ID

    l_strUrl = ""
    IF l_Option = "0" THEN
        l_strUrl = "prtPostBill.mrd"        '�X�֕���̏�(�c�̐�����)
    ELSE
        l_strUrl = "prtPostReport.mrd"      '�X�֕���̏�(���ѕ\)
        '�I���R�[�X�����̑��̏ꍇ�A1���l�ԃh�b�N�A��ƌ��f�A�n�q���ȁA�x�h�b�N�ȊO�̃R�[�X�𒊏o���邽��
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
    '�c�̐������̏ꍇ
%>
        Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/<%= l_strUrl %>", "/rp [<%= l_strSendDate %>] [<%= l_endSendDate %>] [<%= l_strLoginId %>]");
<%
    ELSE
    '���ѕ\�̏ꍇ
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