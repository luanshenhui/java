<%
'-----------------------------------------------------------------------------
'	   �b�t�o�N�ω��i�����K���j (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const GRPCD_CULIFEHABIT = "X017"	'�b�t�o�N�ω��i�����K���j�O���[�v�R�[�h

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objInterView		'�ʐڏ��A�N�Z�X�p

'�p�����[�^
Dim	strWinMode			'�E�B���h�E���[�h
Dim strGrpNo			'�O���[�vNo
Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim strCsCd				'�R�[�X�R�[�h

'��f���ꗗ�p�ϐ�
Dim lngLastDspMode		'�O���\�����[�h�i0:���ׂāA1:����R�[�X�A2:�C�ӎw��j
Dim vntCsGrp			'�O���\�����[�h��0:null ��1:�R�[�X�R�[�h ��2:�R�[�X�O���[�v�R�[�h
Dim vntHisPerId			'�l�h�c
Dim vntHisRsvNo			'�\��ԍ�
Dim vntHisCslDate		'��f��
Dim vntCsCd				'�R�[�X�R�[�h
Dim vntCsName			'�R�[�X��
Dim vntCsSName			'�R�[�X����
Dim lngHisCount			'�\����

'�������ʗp�ϐ�
Dim vntPerId			'�\��ԍ�
Dim vntCslDate			'�������ڃR�[�h
Dim vntHisNo			'����No.
Dim vntRsvNo			'�\��ԍ�
Dim vntItemCd			'�������ڃR�[�h
Dim vntSuffix			'�T�t�B�b�N�X
Dim vntResultType		'���ʃ^�C�v
Dim vntItemType			'���ڃ^�C�v
Dim vntItemName			'�������ږ���
Dim vntResult			'��������
Dim lngRslCnt			'�������ʐ�

Dim lngItemCnt			'�\�����錟�����ڐ�
Dim strArrItemInfo()	'�\�����錟�����ڏ��
Dim strArrResult()		'�\�����錟�����ڌ���
Dim strItem				'�����Ώۂ̌�������
Dim strItemName			'���ږ���
Dim strArrImageName		'�C���[�W�t�@�C���Q
Dim strImage			'�\������C���[�W
Dim i, j				'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'�����l�̎擾
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")
strSelCsGrp			= Request("csgrp")
strSelCsGrp			= IIf(strSelCsGrp="", "0", strSelCsGrp)

Select Case strSelCsGrp
	'���ׂẴR�[�X
	Case "0"
		lngLastDspMode = 0
		vntCsGrp = ""
	'����R�[�X
	Case "1"
		lngLastDspMode = 1
		vntCsGrp = strCsCd
	Case Else
		lngLastDspMode = 2
		vntCsGrp = strSelCsGrp
End Select

Do	

	'�w�肳�ꂽ�l�h�c�̎�f���ꗗ���擾����
	lngHisCount = objInterView.SelectConsultHistory( _
						lngRsvNo, _
						False, _
						lngLastDspMode, _
						vntCsGrp, _
						10, _
						0, _
						vntHisPerId, _
						vntHisRsvNo, _
						vntHisCslDate, _
						vntCsCd, _
						vntCsName, _
						vntCsSName, _
						1 _
						)
	If lngHisCount < 1 Then
		Err.Raise 1000, , "��f�����擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
	End If

	'�w��Ώێ�f�҂̌������ʂ��擾����
	lngRslCnt = objInterView.SelectHistoryRslList( _
						lngRsvNo, _
						lngHisCount, _
						GRPCD_CULIFEHABIT, _
						lngLastDspMode, _
						vntCsGrp, _
						0, _
						0, _
						1, _
						vntPerId, _
						vntCslDate, _
						vntHisNo, _
						vntRsvNo, _
						vntItemCd, _
						vntSuffix, _
						vntResultType, _
						vntItemType, _
						vntItemName, _
						vntResult, _
						, , , , , , , , , , _
						, , , , , , , , _
						1 _
						)
	If lngRslCnt < 0 Then
		Err.Raise 1000, , "�������ʂ��擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
	End If

	lngItemCnt = 0
	Redim strArrItemInfo( 3, -1 )
	Redim strArrResult( lngHisCount-1, -1 )
	'�I������Ă��錟�����ڂ𒊏o
	strItem = ""
	For i=0 To lngRslCnt-1
		If strItem <> vntItemCd(i) & "-" & vntSuffix(i) Then
				lngItemCnt = lngItemCnt + 1
				Redim Preserve strArrItemInfo( 3, lngItemCnt ) 
				Redim Preserve strArrResult( lngHisCount-1, lngItemCnt ) 
		End If

		strArrItemInfo( 0, lngItemCnt ) = vntItemName(i)
		strArrItemInfo( 1, lngItemCnt ) = vntItemCd(i)
		strArrItemInfo( 2, lngItemCnt ) = vntSuffix(i)
		'�ߋ��̌��ʂ����ɂ���悤�ɂ���
		strArrResult( lngHisCount - vntHisNo(i), lngItemCnt ) = vntResult(i)

		strItem = vntItemCd(i) & "-" & vntSuffix(i)
	Next
Exit Do
Loop
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�b�t�o�N�ω�</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winBigIcon;						// �A�C�R���g��E�B���h�E�n���h��

// �A�C�R���g��
function callBigIcon( itemno, iconno ) {
	var url;							// URL������
	var opened = false;					// ��ʂ����łɊJ����Ă��邩

	url = '/WebHains/contents/interview/CULifeHabitIcon.asp';
	url = url + '?itemno=' + itemno;
	url = url + '&iconno=' + iconno;

	// ���łɃE�B���h�E���J����Ă��邩�`�F�b�N
	if ( winBigIcon != null ) {
		if ( !winBigIcon.closed ) {
			opened = true;
		}
	}

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winBigIcon.focus();
		winBigIcon.location.replace( url );
	} else {
		winBigIcon = window.open( url, '', 'width=300,height=300,status=no,directories=no,menubar=no,resizable=no,scrollbars=no,toolbar=no,location=no');
	}

}

// �T�u��ʂ����
function closeWindow() {

	// �����I����ʂ����
	if ( winBigIcon != null ) {
		if ( !winBigIcon.closed ) {
			winBigIcon.close();
		}
	}

	winBigIcon  = null;
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">

	<!-- �����K���̕\�� -->
	<TABLE BORDER="1" CELLSPACING="1" CELLPADDING="1">
		<TR ALIGN="center" BGCOLOR="#cccccc">
			<TD WIDTH="130" NOWRAP>&nbsp;</TD>
<%
	For i=0 To lngHisCount-1
%>
			<TD WIDTH="60" NOWRAP><%= vntHisCslDate(i) %></TD>
<%
	Next
%>
		</TR>
<%
	For i=1 To lngItemCnt
		Select Case i
		Case "1"
			strItemName = "����"
			strArrImageName = Array( _
									"../../images/drinker0.jpg", _
									"../../images/drinker1.jpg", _
									"../../images/drinker2.jpg", _
									"../../images/drinker3.jpg" _
									)
		Case "2"
			strItemName = "�i��"
			strArrImageName = Array( _
									"../../images/smoker0.jpg", _
									"../../images/smoker1.jpg", _
									"../../images/smoker2.jpg", _
									"../../images/smoker3.jpg" _
									)
		Case "3"
			strItemName = "�^��"
			strArrImageName = Array( _
									"../../images/sports0.jpg", _
									"../../images/sports1.jpg", _
									"../../images/sports2.jpg", _
									"../../images/sports3.jpg" _
									)
		Case "4"
'### 2004/3/4 Updated by Ishihara@FSIT ���̂�����Ă���
'			strItemName = "����"
			strItemName = "�`�^�s��"
			strArrImageName = Array( _
									"../../images/life0.jpg",_
									"../../images/life1.jpg", _
									"../../images/life2.jpg", _
									"../../images/life3.jpg" _
									)
		End Select
%>	
		<TR ALIGN="right">
			<TD NOWRAP HEIGHT="40" ALIGN="left"><FONT SIZE="6"><%= strItemName %></FONT></TD>
<%
		For j=0 To lngHisCount-1
			strImage = ""

			Select Case strArrResult(j, i)
			Case "0","1","2","3"
				strImage = strArrImageName(strArrResult(j, i))
			End Select
			If strImage <> "" Then
%>
				<TD NOWRAP ALIGN="center"><A HREF="javascript:callBigIcon(<%= i %>, <%= strArrResult(j, i) %>)"><IMG SRC="<%= strImage %>" ALT="<%= strArrResult(j, i) %>" HEIGHT="40" WIDTH="40"></A></TD>
<%
			Else
%>
				<TD NOWRAP>&nbsp;</TD>
<%
			End If
		Next
%>
		</TR>
<%
	Next
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
