<%@LANGUAGE = VBSCRIPT%>

<%
'-------------------------------------------------------------------------------
'	�ʐڈē��E���H�������� (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
'       �Ǘ��ԍ��FSL-UI-Y0101-236
'       �C����  �F2010.05.28
'       �S����  �FASC)����
'       �C�����e�FReport Designer��Co Reports�ɕύX
'-------------------------------------------------------------------------------
Option Explicit%>
<%
'#### 2010.06.28 SL-UI-Y0101-236 ADD START ####'
%>
<!-- #include virtual = "/webHains/includes/print.inc" -->
<%
'#### 2010.06.28 SL-UI-Y0101-236 ADD END ####'
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'---------------------------------
'	Programmed by ECO)���Y�r
'	Date : 2003.12.15
'	File : prtSchedule.asp
'---------------------------------
%>

<%
	Dim l_cslDate
	Dim l_PerID
	Dim l_rsvNo
	Dim l_dayID
'#### 2010.06.28 SL-UI-Y0101-236 ADD START ####'
	Dim l_useID
	Dim l_IPAddress
	Dim vntMessage		'�ʒm���b�Z�[�W
'#### 2010.06.28 SL-UI-Y0101-236 ADD END ####'

	l_cslDate = Request("p_cslDate")
	l_PerID = Request("p_PerID")
	l_rsvNo = Request("p_rsvNo")
	l_dayID = Request("p_dayID")
'#### 2010.06.28 SL-UI-Y0101-236 ADD START ####'
	l_useID = Request("p_Uid")
	l_IPAddress = Request.ServerVariables("REMOTE_ADDR")  '���s�[����IP�A�h���X���擾
'#### 2010.06.28 SL-UI-Y0101-236 ADD END ####'

'#### 2010.06.28 SL-UI-Y0101-236 ADD START ####'
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
	Call putPrivacyInfoLogWithUserID("PH052", "���H�����̈�����s����", l_useID)

	'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
	Set objPrintCls = Server.CreateObject("HainsprtMealCoupon.prtMealCoupon")

	'�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
	Ret = objPrintCls.PrintOut(l_useID, _
							   l_PerID, _
							   l_rsvNo, _
						       l_cslDate, _
							   l_IPAddress)

	Print = Ret
End Function
'#### 2010.06.28 SL-UI-Y0101-236 ADD END ####'

%>

<!--
'#### 2010.06.28 SL-UI-Y0101-236 DEL START ####'
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">

<HEAD>
</HEAD>

<BODY>

<OBJECT
	id=Rdviewer
	classid="clsid:309A42C6-4114-11D4-AF7B-30A024C32DBA" 
	codebase="http://157.104.16.194:8090/RDServer/rdviewer30.cab#version=3,0,0,398"
	name=Rdviewer 
	width=0% height=0%>
</OBJECT>

<SCRIPT ID=clientEventHandlersVBS TYPE="text/vbscript" LANGUAGE=vbscript>
'#### 2010.06.28 SL-UI-Y0101-236 DEL END ####'
//-->
<!--
   sub window_onload()
      'Rdviewer.IsShowDlg = false
      Rdviewer.FileOpen "http://157.104.16.194:8090/RDServer/form/32_prtMealCoupon.mrd", "/rop /rwait /rp [<%= l_PerID %>] [<%= l_rsvNo %>] [<%= l_cslDate %>] /rpdrv [��t(�~�V���ځj]"
   end sub
   
   sub Rdviewer_FileOpenFinished()
      window.close()
   end sub
-->
<!--
'#### 2010.06.28 SL-UI-Y0101-236 DEL START ####'
</SCRIPT>

<table height='100%' width='100%'>
    <tr align='center' valign='center'>
        <td align='right'><img src='../../images/zzz.gif'></td><td align='left'><b>������ł��D�D�D</b></td>
    </tr>
</table>

</BODY>
</HTML>
'#### 2010.06.28 SL-UI-Y0101-236 DEL END ####'
//-->

<!-- '#### 2010.06.28 SL-UI-Y0101-236 ADD START ####' -->
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
<!-- '#### 2010.06.28 SL-UI-Y0101-236 ADD END ####' -->
