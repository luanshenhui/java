<%@LANGUAGE = VBSCRIPT%>
<%
'-------------------------------------------------------------------------------
'	�������`�F�b�N���X�g (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
'       �Ǘ��ԍ��FSL-UI-Y0101-218
'       �C����  �F2010.05.28
'       �S����  �FASC)����
'       �C�����e�FReport Designer��Co Reports�ɕύX
'-------------------------------------------------------------------------------
Option Explicit%>
<%
'#### 2010.06.28 SL-UI-Y0101-218 ADD START ####'
%>
<!-- #include virtual = "/webHains/includes/print.inc" -->
<%
'#### 2010.06.28 SL-UI-Y0101-218 ADD END ####'
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
    '#### 2007/09/06 �� �������`�F�b�N�V�[�g�V�K�쐬�ɂ��V�K�쐬(CoReport �� ReportDesigner) ####
    '####               ��������t�Ŏ�f�Ҋm�F�i�t�F���J�[�j�̌�A�������`�F�b�N�V�[�g�������   ####



    Dim l_Uid                   '���O�C�����[�U�[ID
    Dim l_DayId                 '����ID
    Dim l_ScslDate              '��f��
'#### 2010.06.28 SL-UI-Y0101-218 ADD START ####'
	Dim vntMessage		'�ʒm���b�Z�[�W
    Dim l_Printmode             '0:���ڈ��  1:�v���r���[���
	Dim l_IPAddress
'#### 2010.06.28 SL-UI-Y0101-218 ADD END ####'
    
    l_Uid       = Request("p_Uid")
    l_DayId     = Request("p_DayId")
    l_ScslDate  = Request("p_ScslDate")
    l_Printmode = "0"
	l_IPAddress = Request.ServerVariables("REMOTE_ADDR")  '���s�[����IP�A�h���X���擾

'#### 2010.06.28 SL-UI-Y0101-218 ADD START ####'
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
	Call putPrivacyInfoLogWithUserID("PH051", "(��t����)�������`�F�b�N���X�g�̈�����s����", l_Uid)

	'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
		Set objPrintCls = Server.CreateObject("HainsprtEndoscopeCheck2.prtEndoscpChk2")
	'�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
		Ret = objPrintCls.PrintOut(l_Uid, _
                                   l_ScslDate, _
                                   l_DayId, _
                                   l_Printmode, _
                                   l_IPAddress)

	Print = Ret
End Function
'#### 2010.06.28 SL-UI-Y0101-218 ADD END ####'
%>
<!--
'#### 2010.06.28 SL-UI-Y0101-218 DEL START ####'
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">

<OBJECT
    id=Rdviewer
    classid="clsid:309A42C6-4114-11D4-AF7B-30A024C32DBA" 
    codebase="http://157.104.16.194:8090/RDServer/rdviewer30.cab#version=3,0,0,398" 
    name=Rdviewer 
    width="100%" height="100%">
</OBJECT>


<HEAD>
</HEAD>
<BODY>

<SCRIPT ID=clientEventHandlersVBS TYPE="text/vbscript" LANGUAGE=vbscript>
'#### 2010.06.28 SL-UI-Y0101-218 DEL END ####'
//-->
<!--
   sub window_onload()
      Rdviewer.FileOpen "http://157.104.16.194:8090/RDServer/form/30_prtEndoscopeCheckList.mrd", "/rop /rwait /rp [<%= l_DayId %>] [<%= l_ScslDate %>]"
   end sub
   
   sub Rdviewer_FileOpenFinished()
      window.close()
   end sub
-->
<!--
'#### 2010.06.28 SL-UI-Y0101-218 DEL START ####'
</SCRIPT>

<table height='100%' width='100%'>
    <tr align='center' valign='center'>
        <td align='right'><img src='../../images/zzz.gif'></td><td align='left'><b>������ł��D�D�D</b></td>
    </tr>
</table>

</BODY>
</HTML>
'#### 2010.06.28 SL-UI-Y0101-218 DEL END ####'
//-->

<!-- '#### 2010.06.28 SL-UI-Y0101-218 ADD START ####' -->
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
<!-- '#### 2010.06.28 SL-UI-Y0101-218 ADD END ####' -->
