<%@LANGUAGE = VBSCRIPT%>

<%
'-------------------------------------------------------------------------------
'	�l�ُ�l���X�g (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
'       �Ǘ��ԍ��FSL-UI-Y0101-219
'       �C����  �F2010.06.28
'       �S����  �FASC)����
'       �C�����e�FReport Designer��Co Reports�ɕύX
'-------------------------------------------------------------------------------
Option Explicit%>
<%
'#### 2010.06.28 SL-UI-Y0101-219 ADD START ####'
%>
<!-- #include virtual = "/webHains/includes/print.inc" -->
<%
'#### 2010.06.28 SL-UI-Y0101-219 ADD END ####'
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'---------------------------------------------------------------------
'
'	File Name : rd_17_prtWarningList.asp
'
'	Created Date : 2003.12.16
'
'	Modified Date : 2003.12.29
'
'	Copyright (C) e-Corporation Corporation. All rights reserved.
' 
'---------------------------------------------------------------------

	Dim l_ScslDate
	Dim l_EcslDate
	Dim l_perID
	Dim l_useID
	Dim l_dayID
'#### 2010.06.28 SL-UI-Y0101-219 ADD START ####'
	Dim vntMessage		'�ʒm���b�Z�[�W
    Dim l_Printmode     '0:���ڈ��  1:�v���r���[���
	Dim l_IPAddress
'#### 2010.06.28 SL-UI-Y0101-219 ADD END ####'

	l_ScslDate = Request("p_ScslDate")
	l_EcslDate = Request("p_EcslDate")
	l_useID = Request("p_Uid")
	l_dayID = Request("p_dayID")
    l_Printmode = "0"
	l_IPAddress = Request.ServerVariables("REMOTE_ADDR")  '���s�[����IP�A�h���X���擾

	l_ScslDate = Mid(l_ScslDate, 1, 4) & Mid(l_ScslDate, 6, 2) & Mid(l_ScslDate, 9, 2)
	l_EcslDate = Mid(l_EcslDate, 1, 4) & Mid(l_EcslDate, 6, 2) & Mid(l_EcslDate, 9, 2)

'#### 2010.06.28 SL-UI-Y0101-219 ADD START ####'
'���[�o�͏�������
vntMessage = PrintControl(0)	'���[�h("0":�͂����A"1":�ꎮ����)

Sub GetQueryString()
End Sub

Function CheckValue()
End Function

Function Print()
	Dim objPrintCls	'�c�̈ꗗ�o�͗pCOM�R���|�[�l���g
	Dim Ret			'�֐��߂�l

	'���R�����΍��p���O�����o��
	Call putPrivacyInfoLogWithUserID("PH049", "�ُ�l���X�g�̈�����s����", l_useID)

	'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
	Set objPrintCls = Server.CreateObject("HainsprtWarningList_New.prtWarnList_New")
	'�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
	Ret = objPrintCls.PrintOut(l_useID, l_ScslDate, l_EcslDate, l_dayID, l_Printmode, l_IPAddress)

	Print = Ret
End Function
'#### 2010.06.28 SL-UI-Y0101-219 ADD END ####'

%>
<!--
'#### 2010.06.28 SL-UI-Y0101-219 DEL START ####'
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">

<OBJECT
	id=Rdviewer
	classid="clsid:309A42C6-4114-11D4-AF7B-30A024C32DBA" 
	codebase="http://157.104.16.194:8090/RDServer/rdviewer30.cab#version=3,0,0,398" 
	name=Rdviewer 
	width=0% height=0%>
</OBJECT>


<HEAD>
</HEAD>

<BODY>

<SCRIPT ID=clientEventHandlersVBS TYPE="text/vbscript" LANGUAGE=vbscript>
'#### 2010.06.28 SL-UI-Y0101-219 DEL END ####'
//-->
<!--
   sub window_onload()
      Rdviewer.FileOpen "http://157.104.16.194:8090/RDServer/form/17_prtWarningList-kojin.mrd", "/rop /rwait /rp [<%= l_ScslDate %>] [<%= l_EcslDate %>] [<%= l_dayID %>]"
   end sub
   
   sub Rdviewer_FileOpenFinished()
      window.close()
   end sub
-->
<!--
'#### 2010.06.28 SL-UI-Y0101-219 DEL START ####'
</SCRIPT>

<table height='100%' width='100%'>
    <tr align='center' valign='center'>
        <td align='right'><img src='../../images/zzz.gif'></td><td align='left'><b>������ł��D�D�D</b></td>
    </tr>
</table>

</BODY>
</HTML>
'#### 2010.06.28 SL-UI-Y0101-219 DEL END ####'
//-->

<!-- '#### 2010.06.28 SL-UI-Y0101-219 ADD START ####' -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">

<HEAD>
<SCRIPT TYPE="text/javascript" Language='JavaScript'>
<!--
    function LoadForm() 
    {
      window.opener = window.self.name;
      window.close();
    }
-->
</SCRIPT>
</HEAD>
<BODY onLoad="LoadForm();">

<table height='100%' width='100%'>
    <tr align='center' valign='center'>
        <td align='right'><img src='../../images/zzz.gif'></td><td align='left'><b>������ł��D�D�D</b></td>
    </tr>
</table>

</BODY>
</HTML>
<!-- '#### 2010.06.28 SL-UI-Y0101-219 ADD END ####' -->
