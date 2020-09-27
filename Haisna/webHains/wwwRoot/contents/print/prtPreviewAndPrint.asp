<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		����p�_�C�A���O (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"        -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objReport			'������A�N�Z�X�p
Dim objReportLog		'������O���A�N�Z�X�p

Dim lngPrintSeq			'�v�����gSEQ
Dim strSelPrinter		'�v�����^�I�����[�h(""�ȊO�Ȃ�Β��[�e�[�u���l��K�p)

Dim strFileName			'���[�h�L�������g�t�@�C����
Dim strReportCd			'���[�R�[�h
Dim strReportName		'���[����
Dim strDefaultPrinter	'�f�t�H���g�v�����^

Dim strPrinterName		'�o�̓v�����^
Dim strIPAddress		'IPAddress

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objReport    = Server.CreateObject("HainsReport.Report")
Set objReportLog = Server.CreateObject("HainsReportLog.ReportLog")

'�����l�̎擾
lngPrintSeq   = CLng("0" & Request("seq"))
strSelPrinter = Request("selPrinter")

Do

	'������O���̃v�����gSEQ���L�[�ɁA���[�h�L�������g�t�@�C�������擾����B
	If Not objReportLog.SelectReportLog2(lngPrintSeq, strFileName, strReportCd) Then
		Exit Do
	End If

	'���[���̎擾
	objReport.SelectReport2 strReportCd, strReportName, strDefaultPrinter

	'�v�����^�̐ݒ�(���w�莞�͋N���[���̃f�t�H���g�v�����^���ΏۂƂȂ�)
	If strSelPrinter <> "" Then

		strPrinterName = strDefaultPrinter

		'IP�A�h���X�̎擾
		strIPAddress = Request.ServerVariables("REMOTE_ADDR")

		'�v�����^���Ɏ擾����IP�A�h���X�����݂���ꍇ
		If InStr(strPrinterName, strIPAddress) > 0 Then

			'IP�A�h���X�w�����菜��
			strPrinterName = Replace(strPrinterName, strIPAddress, "")

			'�X�Ɂ��}�[�N����菜��(����Ń��[�J���v�����^�w��ɂ�����)
			strPrinterName = Replace(strPrinterName, "\", "")

		End If

	End If

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���</TITLE>
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY>
<OBJECT CLASSID="clsid:5220CB21-C88D-11CF-B347-00AA00A28331">
	<PARAM NAME="LPKPath" VALUE="/webHains/cab/ViewCtrl/CrView.lpk">
</OBJECT>
<OBJECT CLASSID="clsid:551553D6-DAEA-11D3-BE3F-0090FE014382" CODEBASE="/webHains/cab/ViewCtrl/CrView.cab" ID="MyCrView" WIDTH="0" HEIGHT="0">
	<PARAM NAME="DocumentFileName" VALUE="http://<%= Request.ServerVariables("SERVER_NAME") & PRT_TEMPPATH & strFileName %>">
</OBJECT>
<P ALIGN="center">������ł��D�D�D</P>
<SCRIPT TYPE="text/vbscript" LANGUAGE="VBScript" FOR="MyCrView" EVENT="DownLoaded(Status)">
<!--
Dim Ret

Select Case Status

	Case 0

		'������s
		Ret = MyCrView.PrintOut("<%= strPrinterName %>", "<%= strReportName %>", 0)
		Select Case Ret
			Case 0
			Case -9
				MsgBox "�v�����^���C���X�g�[������Ă��܂���B"
			Case -10
				MsgBox "�w�肳�ꂽ�v�����^<%= IIf(strPrinterName <> "", "�i" & strPrinterName & "�j" , "") %>�͑��݂��܂���B"
			Case Else
				MsgBox "��������ɂ����ăG���[���������܂����B�i�G���[�R�[�h��" & Ret & "�j"
		End Select

	Case 1

		MsgBox "URL�̎w��Ɍ�肪����܂��B"

	Case 2

		MsgBox "CoReport�h�L�������g�t�@�C���̃_�E�����[�h�ŃG���[���������܂����B"

	Case Else

		MsgBox "�_�E�����[�h���ꂽ�t�@�C����CoReport�h�L�������g�t�@�C���̌`���ł͂���܂���B"

End Select

Window.Close
//-->
</SCRIPT>
</BODY>
</HTML>
