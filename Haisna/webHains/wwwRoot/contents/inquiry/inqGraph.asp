<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		���ʎQ��(�O���t) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editGrpList.inc"  -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Dim objResult		'�������ʏ��A�N�Z�X�p

Dim strPerID		'�lID
Dim strGrpCd		'�����O���[�v�R�[�h

Dim strSeq			'SEQ
Dim strItemName		'�������ږ�
Dim strCslDate		'��f��
Dim strResult		'��������
Dim lngCount		'�������ʃ��R�[�h��

Dim lngItemCount	'�O���[�v���������ڐ�
Dim lngCslCount		'��f���

Dim strPrevSeq		'���O���R�[�h��SEQ
Dim lngItemIndex	'�������ڌ����p�C���f�b�N�X
Dim lngCslIndex		'��f�������p�C���f�b�N�X
Dim i				'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objResult = Server.CreateObject("HainsResult.Result")

'�����l�̎擾
strPerID = Request("perID")
strGrpCd = Request("grpCd")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="x-ua-compatible" content="IE=10" >
<TITLE>�O���t</TITLE>
</HEAD>
<BODY BGCOLOR="#ffffff">

<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">

<!-- �\�� -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="inquiry">��</SPAN><FONT COLOR="#000000">�O���t</FONT></B></TD>
	</TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR>
		<TD>�������ڃO���[�v�F</TD>
		<TD><%= EditGrpIList_GrpDiv("grpCd", strGrpCd, "", "", ADD_FIRST) %></TD>
		<TD>�̃O���t��</TD>
		<TD><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�\��"></A>
	</TR>
</TABLE>

</FORM>
<%
Do
	'�O���[�v�����莞�͉������Ȃ�
	If strGrpCd = "" Then
		Exit Do
	End If

	'�������ʂ̓ǂݍ���
	lngCount = objResult.SelectRslHistory(strPerID, strGrpCd, False, strSeq, , , strItemName, strCslDate, , strResult)
	If lngCount <= 0 Then
		EditMessage "���̃O���[�v�Ɍ������ڂ����݂��Ȃ��A���邢�͎�f��񂪑��݂��܂���B", MESSAGETYPE_WARNING
		Exit Do
	End If

	'�O���[�v���������ڐ��J�E���g
	strPrevSeq = ""
	For i = 0 To lngCount - 1

		'�ǂݍ��񂾌������ʏ��̓O���[�v���������ڂ�SEQ���ɑ��݂��邽�߁A
		'���O���R�[�h��SEQ�l���ς�������_�ŃJ�E���g���s��
		If strSeq(i) <> strPrevSeq Then
			lngItemCount = lngItemCount + 1
		End If

		'���O���R�[�h��SEQ�����l�ōX�V
		strPrevSeq = strSeq(i)

	Next

	'��f��񐔃J�E���g
	strPrevSeq = ""
	For i = 0 To lngCount - 1

		'�ǂݍ��񂾌������ʏ��͌������ڒP�ʂɂ����Ď�f���̍~���ɑ��݂��邽�߁A
		'SEQ�l���ς��܂ł̃��R�[�h�����J�E���g����΂��ꂪ��f�Ґ��ƂȂ�
		If strPrevSeq <> "" And strSeq(i) <> strPrevSeq Then
			Exit For
		End If

		'�����Ŏ�f��񐔂��J�E���g
		lngCslCount = lngCslCount + 1

		'���O���R�[�h��SEQ�����l�ōX�V
		strPrevSeq = strSeq(i)

	Next
%>
	<OBJECT ID="HainsChartMain" CLASSID="CLSID:2437FFA5-E1C6-4FA3-9330-13AA3A2E1A56" CODEBASE="/webHains/cab/Chart/HainsChartPrj.CAB#version=1,0,0,2"></OBJECT>

	<script type="text/javascript">
	<!--
	var GraphActiveX = document.getElementById('HainsChartMain');
	GraphActiveX.Rows = <%= lngItemCount %>; // ���ʐ�
	GraphActiveX.Cols = <%= lngCslCount  %>; // ����

		// �������ږ��ݒ�
<%
		strPrevSeq   = ""
		lngItemIndex = 0
		For i = 0 To lngCount - 1

			'�ǂݍ��񂾌������ʏ��̓O���[�v���������ڂ�SEQ���ɑ��݂��邽�߁A
			'���O���R�[�h��SEQ�l���ς�������_�ō��ږ��̕ҏW���s��
			If strSeq(i) <> strPrevSeq Then
				lngItemIndex = lngItemIndex + 1
%>
					GraphActiveX.SetData(0, <%= lngItemIndex %>, "<%= strItemName(i) %>");
<%
			End If

			'���O���R�[�h��SEQ�����l�ōX�V
			strPrevSeq = strSeq(i)

		Next
%>
		// �����f�[�^�ݒ�
<%
		'�擪�����f��񐔕��̎�f���𗚗��f�[�^�Ƃ��ĕҏW
		For i = 0 To lngCslCount - 1
%>
			GraphActiveX.SetData(<%= i + 1 %>, 0, "<%= strCslDate(i) %>");
<%
		Next
%>
		// �������ʒl�ݒ�
<%
		lngItemIndex = 0
		lngCslIndex  = 0

		strPrevSeq = ""
		For i = 0 To lngCount - 1

			'���O���R�[�h��SEQ�l���ς�����ꍇ
			If strSeq(i) <> strPrevSeq Then

				'�������ڃC���f�b�N�X���C���N�������g
				lngItemIndex = lngItemIndex + 1

				'��f���C���f�b�N�X��������
				lngCslIndex = 0

			End If

			'��f���C���f�b�N�X���C���N�������g
			lngCslIndex = lngCslIndex + 1

			If strResult(i) <> "" Then
%>
				GraphActiveX.SetData(<%= lngCslIndex %>, <%= lngItemIndex %>, "<%= strResult(i) %>");
<%
			End If

			'���O���R�[�h��SEQ�����l�ōX�V
			strPrevSeq = strSeq(i)

		Next
%>
		GraphActiveX.Showchart();
	//-->
	</script>
<%
	Exit Do
Loop
%>
</BODY>
</HTML>
