<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�l������񃁃��e�i���X (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objPerResult	'�l�������ʏ��A�N�Z�X�p
Dim objPerson		'�l���A�N�Z�X�p

'������
Dim strAction		'���샂�[�h
Dim strPerId		'�lID

'�l�������
Dim strItemCd		'�������ڃR�[�h
Dim strSuffix		'�T�t�B�b�N�X
Dim strItemName		'�������ږ���
Dim strResult		'��������
Dim strResultType	'���ʃ^�C�v
Dim strItemType		'���ڃ^�C�v
Dim strStcItemCd	'���͎Q�Ɨp���ڃR�[�h
Dim strShortStc		'���͗���
Dim strIspDate		'������
Dim strIspYear		'������(�N)
Dim strIspMonth		'������(��)
Dim strIspDay		'������(��)
Dim lngCount		'���R�[�h����

'�l���
Dim strLastName		'��
Dim strFirstName	'��
Dim strLastKName	'�J�i��	
Dim strFirstKName	'�J�i��
Dim strBirth		'���N����
Dim strAge			'�N��
Dim strGender		'����
Dim strGenderName	'���ʖ���

Dim lngStartYear	'�\���J�n�N
Dim lngEndYear		'�\���I���N
Dim strArrMessage	'�G���[���b�Z�[�W
Dim i				'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon    = Server.CreateObject("HainsCommon.Common")
Set objPerResult = Server.CreateObject("HainsPerResult.PerResult")
Set objPerson    = Server.CreateObject("HainsPerson.Person")

'�����l�̎擾
strAction     = Request("act")
strPerId      = Request("perId")

'�l�������ʏ��
strItemCd     = ConvIStringToArray(Request("itemCd"))
strSuffix     = ConvIStringToArray(Request("suffix"))
strItemName   = ConvIStringToArray(Request("itemName"))
strResult     = ConvIStringToArray(Request("result"))
strResultType = ConvIStringToArray(Request("resultType"))
strItemType   = ConvIStringToArray(Request("itemType"))
strStcItemCd  = ConvIStringToArray(Request("stcItemCd"))
strShortStc   = ConvIStringToArray(Request("shortStc"))
strIspYear    = ConvIStringToArray(Request("ispYear"))
strIspMonth   = ConvIStringToArray(Request("ispMonth"))
strIspDay     = ConvIStringToArray(Request("ispDay"))

'�������ڐ��̎擾
If Not IsEmpty(strItemCd) Then
	lngCount = UBound(strItemCd) + 1
End If

'�������̕ҏW
If lngCount > 0 Then
	strIspDate = Array()
	ReDim Preserve strIspDate(lngCount - 1)
	For i = 0 To UBound(strIspDate)
		If strIspYear(i) <> "" Or strIspMonth(i) <> "" Or strIspDay(i) <> "" Then
			strIspDate(i) = strIspYear(i) & "/" & strIspMonth(i) & "/" & strIspDay(i)
		End If
	Next
End If

'�������\���p�ɃV�X�e���Ǘ��N�͈͂��擾
objCommon.SelectYearsRangeSystem lngStartYear, lngEndYear
lngStartYear = IIf(lngStartYear = 0, YEARRANGE_MIN, lngStartYear)
lngEndYear   = IIf(lngEndYear   = 0, YEARRANGE_MAX, lngEndYear  )

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'�ۑ��{�^��������
	If strAction = "save" Then

		'�������`�F�b�N(�������ʂ̓`�F�b�N���Ȃ�)
		For i = 0 To UBound(strItemCd)
			If strIspDate(i) <> "" Then
				If Not IsDate(strIspDate(i)) Then
					objCommon.AppendArray strArrMessage, "�u" & strItemName(i) & "�v�������̓��͌`��������������܂���B"
				End If
			End If
		Next

		'�������`�F�b�N�ɂăG���[�����݂���ꍇ�͏������I������
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'�l�������ʕۑ�
		objPerResult.UpdatePerResult strPerId, strItemCd, strSuffix, strResult, strIspDate

		'�G���[���Ȃ���Ύ������g�����_�C���N�g
		Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?act=saveend&perId=" & strPerId
		Response.End

	End If

	'�l�������ʓǂݍ���
	lngCount = objPerResult.SelectPerResultList(strPerID, strItemCd, strSuffix, strItemName, strResult, strResultType, strItemType, strStcItemCd, strShortStc, strIspDate)
	If lngCount = 0 Then
		Exit Do
	End If

	'��������N�E���E���ɕ���
	strIspYear  = Array()
	strIspMonth = Array()
	strIspDay   = Array()
	ReDim Preserve strIspYear(lngCount - 1)
	ReDim Preserve strIspMonth(lngCount - 1)
	ReDim Preserve strIspDay(lngCount - 1)
	For i = 0 To UBound(strIspDate)
		If strIspDate(i) <> "" Then
			strIspYear(i)  = Year(strIspDate(i))
			strIspMonth(i) = Month(strIspDate(i))
			strIspDay(i)   = Day(strIspDate(i))
		End If
	Next

	Exit Do
Loop

'�l���ǂݍ���
objPerson.SelectPersonInf strPerId, strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGender, strGenderName, strAge

'-----------------------------------------------------------------------------
' ���b�Z�[�W�̕ҏW
'-----------------------------------------------------------------------------
Sub EditPerResultList()

	Const ALIGNMENT_RIGHT = "STYLE=""text-align:right"""	'�E��

	Dim strAlignMent	'�\���ʒu

	If lngCount = 0 Then
%>
		�l�������͑��݂��܂���
<%
		Exit Sub
	End If
%>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR BGCOLOR="#eeeeee">
			<TD WIDTH="128" HEIGHT="21" ALIGN="right">�������ږ�</TD>
			<TD COLSPAN="2">��������</TD>
			<TD WIDTH="180" NOWRAP>����</TD>
			<TD>�X�V���\���</TD>
		</TR>
<% 
		For i = 0 To lngCount - 1
%>
			<INPUT TYPE="hidden" NAME="itemCd"     VALUE="<%= strItemCd(i)     %>">
			<INPUT TYPE="hidden" NAME="suffix"     VALUE="<%= strSuffix(i)     %>">
			<INPUT TYPE="hidden" NAME="itemName"   VALUE="<%= strItemName(i)   %>">
			<INPUT TYPE="hidden" NAME="resultType" VALUE="<%= strResultType(i) %>">
			<INPUT TYPE="hidden" NAME="itemType"   VALUE="<%= strItemType(i)   %>">
			<INPUT TYPE="hidden" NAME="stcItemCd"  VALUE="<%= strStcItemCd(i)  %>">
			<INPUT TYPE="hidden" NAME="shortStc"   VALUE="<%= strShortStc(i)   %>">
			<TR BGCOLOR="#eeeeee">
				<TD WIDTH="128" NOWRAP ALIGN="right"><A HREF="javascript:callDtlGuide('<%= i %>')"><%= strItemName(i) %></A></TD>
<%
				Select Case CLng(strResultType(i))

					'�萫�K�C�h�\��
					Case RESULTTYPE_TEISEI1, RESULTTYPE_TEISEI2
%>
						<TD><A HREF="javascript:callTseGuide('<%= i %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�萫�K�C�h�\��"></A></TD>
<%
					'���̓K�C�h�\��
					Case RESULTTYPE_SENTENCE
%>
						<TD><A HREF="javascript:callStcGuide('<%= i %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���̓K�C�h�\��"></A></TD>
<%
					'�K�C�h�\���Ȃ�
					Case Else
%>
						<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21"></TD>
<%
				End Select

				'��������

				'�v�Z���ʂ̏ꍇ
				If CLng(strResultType(i)) = RESULTTYPE_CALC Then
%>
					<TD ALIGN="right" WIDTH="75"><INPUT TYPE="hidden" NAME="result" VALUE="<%= strResult(i) %>"><%= strResult(i) %>&nbsp;</TD>
<%
				'����ȊO�̏ꍇ
				Else

					'�X�^�C���V�[�g�̐ݒ�
					strAlignment   = IIf(CLng(strResultType(i)) = RESULTTYPE_NUMERIC, ALIGNMENT_RIGHT, "")
%>
					<TD WIDTH="75"><INPUT TYPE="text" NAME="result" SIZE="<%= TextLength(9) %>" MAXLENGTH="8" VALUE="<%= strResult(i) %>" <%= strAlignment %> ONCHANGE="clearStcName('<%= i %>')"></TD>
<%
				End If
%>
				<TD WIDTH="180" NOWRAP><SPAN ID="stcName<%= i %>" STYLE="position:relative"><%= IIf(strShortStc(i) <> "", strShortStc(i), "&nbsp;") %></SPAN></TD>
				<TD>
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
							<TD><%= EditNumberList("ispYear", lngStartYear, lngEndYear, strIspYear(i), True) %></TD>
							<TD>�N</TD>
							<TD><%= EditNumberList("ispMonth", 1, 12, strIspMonth(i), True) %></TD>
							<TD>��</TD>
							<TD><%= EditNumberList("ispDay", 1, 31, strIspDay(i), True) %></TD>
							<TD>��</TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
<%
		Next
%>
	</TABLE>
<%
End Sub
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�l������񃁃��e�i���X</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc" -->
<!-- #include virtual = "/webHains/includes/dtlGuide.inc" -->
<!-- #include virtual = "/webHains/includes/tseGuide.inc" -->
<!--
var lngSelectedIndex;  // �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X

// ���̓K�C�h�Ăяo��
function callStcGuide( index ) {

	var myForm = document.perResult;

	// �I�����ꂽ�G�������g�̃C���f�b�N�X��ޔ�(���̓R�[�h�E�����͂̃Z�b�g�p�֐��ɂĎg�p����)
	lngSelectedIndex = index;

	// �K�C�h��ʂ̘A����Ɍ������ڃR�[�h��ݒ肷��
	if ( myForm.stcItemCd.length != null ) {
		stcGuide_ItemCd = myForm.stcItemCd[ index ].value;
	} else {
		stcGuide_ItemCd = myForm.stcItemCd.value;
	}

	// �K�C�h��ʂ̘A����ɍ��ڃ^�C�v�i�W���j��ݒ肷��
	if ( myForm.itemType.length != null ) {
		stcGuide_ItemType = myForm.itemType[ index ].value;
	} else {
		stcGuide_ItemType = myForm.itemType.value;
	}

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	stcGuide_CalledFunction = setStcInfo;

	// ���̓K�C�h�\��
	showGuideStc();
}

// ���̓R�[�h�E�����͂̃Z�b�g
function setStcInfo() {

	var myForm = document.perResult;

	var stcNameElement; // �����͂�ҏW����G�������g�̖���
	var stcName;        // �����͂�ҏW����G�������g���g

	// �\�ߑޔ������C���f�b�N�X��̃G�������g�ɁA�K�C�h��ʂŐݒ肳�ꂽ�A����̒l��ҏW
	if ( myForm.result.length != null ) {
		myForm.result[lngSelectedIndex].value = stcGuide_StcCd;
	} else {
		myForm.result.value = stcGuide_StcCd;
	}
	if ( myForm.shortStc.length != null ) {
		myForm.shortStc[lngSelectedIndex].value = stcGuide_ShortStc;
	} else {
		myForm.shortStc.value = stcGuide_ShortStc;
	}

	// �u���E�U���Ƃ̒c�̖��ҏW�p�G�������g�̐ݒ菈��
	for ( ; ; ) {

		// �G�������g���̕ҏW
		stcNameElement = 'stcName' + lngSelectedIndex;

		// IE�̏ꍇ
		if ( document.all ) {
			document.all(stcNameElement).innerHTML = stcGuide_ShortStc;
			break;
		}

		// Netscape6�̏ꍇ
		if ( document.getElementById ) {
			document.getElementById(stcNameElement).innerHTML = stcGuide_ShortStc;
		}

		break;
	}

	return false;
}

// �������ڐ����Ăяo��
function callDtlGuide( index ) {

	// ������ʂ̘A����ɉ�ʓ��͒l��ݒ肷��
	dtlGuide_ItemCd       = document.perResult.itemCd[ index ].value;
	dtlGuide_Suffix       = document.perResult.suffix[ index ].value;
	dtlGuide_CsCd         = '';
	dtlGuide_CslDateYear  = '<%= Year(Now())  %>';
	dtlGuide_CslDateMonth = '<%= Month(Now()) %>';
	dtlGuide_CslDateDay   = '<%= Day(Now())   %>';
	dtlGuide_Age          = '';
	dtlGuide_Gender       = '<%= strGender    %>';

	// �������ڐ����\��
	showGuideDtl();
}

// �y�[�W���M����
function goNextPage() {

	document.perResult.submit();

	return false;

}

// �萫�K�C�h�Ăяo��
function callTseGuide( index ) {

	var myForm = document.perResult;

	// �I�����ꂽ�G�������g�̃C���f�b�N�X��ޔ�(�萫���ʂ̃Z�b�g�p�֐��ɂĎg�p����)
	lngSelectedIndex = index;

	// �K�C�h��ʂ̘A����ɍ��ڃ^�C�v��ݒ肷��
	if ( myForm.resultType.length != null ) {
		tseGuide_ResultType = myForm.resultType[ index ].value;
	} else {
		tseGuide_ResultType = myForm.resultType.value;
	}

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	tseGuide_CalledFunction = setTseInfo;

	// �萫�K�C�h�\��
	showGuideTse();
}

// �萫���ʂ̃Z�b�g
function setTseInfo() {

	var myForm = document.perResult;

	// �\�ߑޔ������C���f�b�N�X��̃G�������g�ɁA�K�C�h��ʂŐݒ肳�ꂽ�A����̒l��ҏW
	if ( myForm.result.length != null ) {
		myForm.result[lngSelectedIndex].value = tseGuide_Result;
	} else {
		myForm.result.value = tseGuide_Result;
	}
	return false;
}

// ���͍폜
function clearStcName( index ) {

	var stcNameElement; // �����͂�ҏW����G�������g�̖���

	var myForm = document.perResult;

	if ( myForm.shortStc.length != null ) {
		myForm.shortStc[index].value = '';
	} else {
		myForm.shortStc.value = '';
	}

	// �u���E�U���Ƃ̒c�̖��ҏW�p�G�������g�̐ݒ菈��
	for ( ; ; ) {

		// �G�������g���̕ҏW
		stcNameElement = 'stcName' + index;

		// IE�̏ꍇ
		if ( document.all ) {
			document.all(stcNameElement).innerHTML = '';
			break;
		}

		// Netscape6�̏ꍇ
		if ( document.getElementById ) {
			document.getElementById(stcNameElement).innerHTML = '';
		}

		break;
	}

	return false;
}

function saveResult() {

	document.perResult.submit();

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="perResult" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="act"   VALUE="save">
	<INPUT TYPE="hidden" NAME="perID" VALUE="<%= strPerID %>">

	<!-- �\�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�l������񃁃��e�i���X</FONT></B></TD>
		</TR>
	</TABLE>

	<!-- ����{�^�� -->
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD ALIGN="right">
				<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0">
					<TR>
						<TD><A HREF="mntPersonal.asp?mode=update&perId=<%= strPerId %>"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="������ʂɖ߂�܂�"></A></TD>
						<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7"></TD>
<%
						If lngCount > 0 Then
%>
							<TD>
							<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
							<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
								<A HREF="javascript:saveResult()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="���͂����f�[�^��ۑ����܂�"></A>
							<%  else    %>
								 &nbsp;
							<%  end if  %>
							<% '2005.08.22 �����Ǘ� Add by ���@--- END %>
							</TD>

							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7"></TD>
<%
						End If
%>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	If strAction <> "" Then

		'�ۑ��������́u�ۑ������v�̒ʒm
		If strAction = "saveend" Then
			Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)

		'�����Ȃ��΃G���[���b�Z�[�W��ҏW
		Else
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If

	End If
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD><%= strPerID %></TD>
			<TD NOWRAP><B><%= strLastName %>�@<%= strFirstName %></B> (<FONT SIZE="-1"><%= strLastKName %>�@<%= strFirstKName %></FONT>)</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><%= objCommon.FormatString(strBirth, "gee.mm.dd") %>���@<%= strAge %>�΁@<%= strGenderName %></TD>
		</TR>
	</TABLE>

	<INPUT TYPE="hidden" NAME="gender" VALUE="<%= strGender %>">

	<BR>
<%
	'�l�������ʏ��̕ҏW
	Call EditPerResultList
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
