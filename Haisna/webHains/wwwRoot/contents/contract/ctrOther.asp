<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�_����(�_��O��f���ڂ̕��S���Ə��w��) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objContract			'�_����A�N�Z�X�p
Dim objContractControl	'�_��Ǘ����A�N�Z�X�p

'�����l
Dim strOrgCd1			'�c�̃R�[�h1
Dim strOrgCd2			'�c�̃R�[�h2
Dim strCtrPtCd			'�_��p�^�[���R�[�h
Dim strApDiv			'�K�p���敪
Dim strSeq				'SEQ
Dim strBdnOrgCd1		'�c�̃R�[�h1
Dim strBdnOrgCd2		'�c�̃R�[�h2
Dim strArrOrgName		'�c�̖���
Dim strNoCtr			'�_��O���ڕ��S�t���O
Dim strFraction			'�_��O���ڒ[�����S�t���O
Dim strOrgDiv			'�c�̎��
Dim lngCount			'�_��p�^�[�����S�����R�[�h��

'�_��Ǘ����
Dim strOrgName			'�c�̖�
Dim strCsCd				'�R�[�X�R�[�h
Dim strCsName			'�R�[�X��
Dim dtmStrDate			'�_��J�n��
Dim dtmEndDate			'�_��I����

Dim strStrDate			'�ҏW�p�̌_��J�n��
Dim strEndDate			'�ҏW�p�̌_��I����
Dim strHTML				'HTML�ҏW�p
Dim strMessage			'�G���[���b�Z�[�W
Dim i					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")

'�����l�̎擾
strOrgCd1     = Request("orgCd1")
strOrgCd2     = Request("orgCd2")
strCtrPtCd    = Request("ctrPtCd")
strApDiv      = ConvIStringToArray(Request("apDiv"))
strSeq        = ConvIStringToArray(Request("seq"))
strBdnOrgCd1  = ConvIStringToArray(Request("bdnOrgCd1"))
strBdnOrgCd2  = ConvIStringToArray(Request("bdnOrgCd2"))
strArrOrgName = ConvIStringToArray(Request("orgName"))
strNoCtr      = ConvIStringToArray(Request("noCtr"))
strFraction   = ConvIStringToArray(Request("fraction"))
strOrgDiv     = ConvIStringToArray(Request("orgDiv"))

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do
	'�ۑ��{�^��������
	If Not IsEmpty(Request("save.x")) Then

		'�_��O���ڂ̕��S���X�V
		If objContractControl.UpdateOuterContract(strOrgCd1, strOrgCd2, strCtrPtCd, strSeq, strBdnOrgCd1, strBdnOrgCd2, strNoCtr, strFraction) <> 0 Then
			strMessage = "���̌_����̕��S�����͕ύX����Ă��܂��B�X�V�ł��܂���B"
			Exit Do
		End If

		'�G���[���Ȃ���ΌĂь�(�_����)��ʂ������[�h���Ď��g�����
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
		strHTML = strHTML & "<BODY ONLOAD=""JavaScript:if ( opener != null ) opener.location.reload(); close()"">"
		strHTML = strHTML & "</BODY>"
		strHTML = strHTML & "</HTML>"
		Response.Write strHTML
		Response.End

		Exit Do
	End If

	'�_��p�^�[�����S���Ǘ�����ǂݍ���
	lngCount = objContract.SelectCtrPtOrgPrice(strCtrPtCd, , , strSeq, strApDiv, strBdnOrgCd1, strBdnOrgCd2, strArrOrgName, , , , , , , strNoCtr, strFraction, , , strOrgDiv)
	If lngCount <= 0 Then
		Exit Do
	End If

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�_��O��f���ڂ̕��S���w��</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// �_��O���ڕ��S�`�F�b�N���̐���
function checkNoCtr( index ) {

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	// �`�F�b�N�{�b�N�X�̐���
	checkNoCtrOrg( ( myForm.noCtrOrg[ index ].checked ? index : null ) );

	// hidden�f�[�^�ƃ`�F�b�N�{�b�N�X��ԂƂ̓�������

	// ���S�����P���̏ꍇ
	if ( !myForm.noCtr.length ) {
		myForm.noCtr.value = setNoCtr( myForm.noCtrOrg.checked );
		return;
	}

	// ���S���������̏ꍇ
	for ( i = 0; i < myForm.noCtr.length; i++ ) {
		myForm.noCtr[ i ].value = setNoCtr( myForm.noCtrOrg[ i ].checked );
	}

}

// �w��C���f�b�N�X�̃`�F�b�N�{�b�N�X�̂�on�ɂ���
// (�C���f�b�N�X���w�莞�͂��ׂ�off)
function checkNoCtrOrg( index ) {

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	// ���S�����P���̏ꍇ
	if ( !myForm.noCtrOrg.length ) {
		myForm.noCtrOrg.checked = ( index != null );
		return;
	}

	// ���S���������̏ꍇ

	// ��U�S�Ẵ`�F�b�N�{�b�N�X��off�ɂ���
	for ( i = 0; i < myForm.noCtrOrg.length; i++ ) {
		myForm.noCtrOrg[ i ].checked = false;
	}

	// �w��C���f�b�N�X�̃`�F�b�N�{�b�N�X�̂�on�ɂ���
	if ( index != null ) {
		myForm.noCtrOrg[ index ].checked = true;
	}

}

// hidden�f�[�^�̃Z�b�g
function setNoCtr( check ) {

	return ( check ? '1' : '0' );

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="orgCd1"  VALUE="<%= strOrgCd1  %>">
	<INPUT TYPE="hidden" NAME="orgCd2"  VALUE="<%= strOrgCd2  %>">
	<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strCtrPtCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">��</SPAN><FONT COLOR="#000000">�_��O��f���ڂ̕��S���w��</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>
<%
	'�_����̓ǂݍ���
	If objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate) = False Then
		Err.Raise 1000, ,"�_���񂪑��݂��܂���B"
	End If

	'�ҏW�p�̌_��J�n���ݒ�
	If Not IsEmpty(dtmStrDate) Then
		strStrDate = FormatDateTime(dtmStrDate, 1)
	End If

	'�ҏW�p�̌_��I�����ݒ�
	If Not IsEmpty(dtmEndDate) Then
		strEndDate = FormatDateTime(dtmEndDate, 1)
	End If
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD>�_��c��</TD>
			<TD>�F</TD>
			<TD><B><%= strOrgName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>�ΏۃR�[�X</TD>
			<TD>�F</TD>
			<TD><B><%= strCsName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>�_�����</TD>
			<TD>�F</TD>
			<TD><B><%= strStrDate %>�`<%= strEndDate %></B></TD>
		</TR>
	</TABLE>

	<BR>

	<FONT COLOR="#CC9999">��</FONT>&nbsp;�_��O��f���ڂ̗����𕉒S���鎖�Ə����w�肵�ĉ������B<BR><BR>

	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
			<TR BGCOLOR="#eeeeee">
				<TD>���S��</TD>
				<TD COLSPAN="2">���S</TD>
			</TR>
<%
			For i = 0 To Ubound(strApDiv)
%>
				<TR>
					<TD>
						<INPUT TYPE="hidden" NAME="apDiv"     VALUE="<%= strApDiv(i)      %>">
						<INPUT TYPE="hidden" NAME="seq"       VALUE="<%= strSeq(i)        %>">
						<INPUT TYPE="hidden" NAME="bdnOrgCd1" VALUE="<%= strBdnOrgCd1(i)  %>">
						<INPUT TYPE="hidden" NAME="bdnOrgCd2" VALUE="<%= strBdnOrgCd2(i)  %>">
						<INPUT TYPE="hidden" NAME="orgName"   VALUE="<%= strArrOrgName(i) %>">
						<INPUT TYPE="hidden" NAME="noCtr"     VALUE="<%= strNoCtr(i)      %>">
						<INPUT TYPE="hidden" NAME="fraction"  VALUE="<%= strFraction(i)   %>">
						<INPUT TYPE="hidden" NAME="orgDiv"    VALUE="<%= strOrgDiv(i)     %>">
						<%= IIf(strApDiv(i) = CStr(APDIV_MYORG), strOrgName, strArrOrgName(i)) %>
					</TD>
					<TD><INPUT TYPE="checkbox" NAME="noCtrOrg" <%= IIf(strNoCtr(i) = "1", "CHECKED", "") & " " & IIf(strOrgDiv(i) <> "0", "DISABLED", "") %> ONCLICK="javascript:checkNoCtr('<%= i %>')"></TD>
					<TD>���S����</TD>
				</TR>
<%
			Next
%>
	</TABLE>

	<BR>

	<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A>
	<INPUT TYPE="image" NAME="save" SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�">

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
