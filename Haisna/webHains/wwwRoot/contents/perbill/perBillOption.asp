<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		��f�Z�b�g�ύX (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objConsult		'��f���A�N�Z�X�p

'�����l
Dim lngRsvNo		'�\��ԍ�
Dim strCslDate		'��f��
Dim strPerId		'�l�h�c
Dim strCtrPtCd		'�_��p�^�[���R�[�h
Dim strCslDivCd		'��f�敪�R�[�h
Dim strOptCd		'�I�v�V�����R�[�h
Dim strOptBranchNo	'�I�v�V�����}��
Dim strConsults		'��f�v��

Dim strMessage		'�G���[���b�Z�[�W
Dim strHTML			'HTML������
Dim Ret				'�֐��߂�l
Dim i				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
lngRsvNo       = CLng("0" & Request("rsvNo"))
strCslDate     = Request("cslDate")
strPerId       = Request("perId")
strCtrPtCd     = Request("ctrPtCd")
strCslDivCd    = Request("cslDivCd")
strOptCd       = ConvIStringToArray(Request("optCd"))
strOptBranchNo = ConvIStringToArray(Request("optBranchNo"))
strConsults    = ConvIStringToArray(Request("consults"))

'�ۑ��{�^��������
If Not IsEmpty(Request("save.x")) Then

	'�ۑ�����
	Set objConsult = Server.CreateObject("HainsConsult.Consult")

	'��f�I�v�V�����Ǘ����R�[�h�̍X�V
	Ret = objConsult.UpdateConsult_O(lngRsvNo, strCtrPtCd, strOptCd, strOptBranchNo, strConsults, Request.ServerVariables("REMOTE_ADDR"), Session("USERID"), Session("IGNORE"), strMessage)

	Set objConsult = Nothing

	'�G���[���Ȃ���ΌĂь���ʂ������[�h���Ď��g�����
	If Ret > 0 Then
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
		strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
		strHTML = strHTML & "</BODY>"
		strHTML = strHTML & "</HTML>"
		Response.Write strHTML
		Response.End
	End If

'�����\����
Else

	Set objConsult = Server.CreateObject("HainsConsult.Consult")

	'��f���ǂݍ���
	objConsult.SelectConsult lngRsvNo, 0, strCslDate, strPerId, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , strCtrPtCd, , , , , , , , , , , , strCslDivCd

	'���݂̎�f�I�v�V���������ǂݍ���
	objConsult.SelectConsult_O lngRsvNo, strOptCd, strOptBranchNo

	Set objConsult = Nothing

	'��f���ׂ��I�v�V���������݂���ꍇ
	If IsArray(strOptCd) Then

		'�ǂݍ��񂾑S�ẴI�v�V�����̎�f�v�ۂ��u��f����v�ɐݒ�
		strConsults = Array()
		ReDim Preserve strConsults(UBound(strOptCd))
		For i = 0 To UBound(strConsults)
			strConsults(i) = "1"
		Next

	End If

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>��f�Z�b�g�ύX</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var lngSelectedIndex;  // �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X

// �ۑ��O�Ɍ��݂̑I����Ԃ����f�v�ۂ�ݒ肷��
function setConsults() {

	var objForm = document.entryForm;

	var arrOptCd;		// �I�v�V�����R�[�h
	var arrOptBranchNo;	// �I�v�V�����}��
	var arrConsults;	// ��f�v��

	var selOptCd;		// �I�v�V�����R�[�h

	// �I�v�V���������̎�f��Ԃ��擾����
	arrOptCd       = new Array();
	arrOptBranchNo = new Array();
	arrConsults    = new Array();

	// �S�G�������g������
	for ( var i = 0; i < objForm.elements.length; i++ ) {

		// �`�F�b�N�{�b�N�X�A���W�I�{�^���ȊO�̓X�L�b�v
		if ( objForm.elements[ i ].type != 'checkbox' && objForm.elements[ i ].type != 'radio' ) {
			continue;
		}

		// �J���}�ŃR�[�h�Ǝ}�Ԃ𕪗����ăI�v�V�����R�[�h��ǉ�
		selOptCd = objForm.elements[ i ].value.split(',');
		arrOptCd[ arrOptCd.length ]             = selOptCd[ 0 ];
		arrOptBranchNo[ arrOptBranchNo.length ] = selOptCd[ 1 ];

		// �`�F�b�N��Ԃɂ���f�v�ۂ�ݒ�
		arrConsults[ arrConsults.length ] = objForm.elements[ i ].checked ? '1' : '0';

	}

	// submit�p�̍��ڂ֕ҏW
	objForm.optCd.value       = arrOptCd;
	objForm.optBranchNo.value = arrOptBranchNo;
	objForm.consults.value    = arrConsults;

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" ONSUBMIT="javascript:setConsults()">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN>��f�Z�b�g�ύX</B></TD>
	</TR>
</TABLE>
<%
If Request("act") = "saveend" Then
	EditMessage "�ۑ����������܂����B", MESSAGETYPE_NORMAL
Else
	If strMessage <> "" Then
		EditMessage strMessage, MESSAGETYPE_WARNING
	End If
End If
%>
<BR>
<INPUT TYPE="image" NAME="save" SRC="../../images/save.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�ۑ�����"><BR><BR>
<INPUT TYPE="hidden" NAME="rsvNo"       VALUE="<%= lngRsvNo    %>">
<INPUT TYPE="hidden" NAME="cslDate"     VALUE="<%= strCslDate  %>">
<INPUT TYPE="hidden" NAME="perId"       VALUE="<%= strPerId    %>">
<INPUT TYPE="hidden" NAME="ctrPtCd"     VALUE="<%= strCtrPtCd  %>">
<INPUT TYPE="hidden" NAME="cslDivCd"    VALUE="<%= strCslDivCd %>">
<INPUT TYPE="hidden" NAME="optCd"       VALUE="">
<INPUT TYPE="hidden" NAME="optBranchNo" VALUE="">
<INPUT TYPE="hidden" NAME="consults"    VALUE="">
<% EditSet() %>
</FORM>
</BODY>
</HTML>
<%
Sub EditSet()

	Dim objContract			'�_����A�N�Z�X�p

	'�I�v�V�����������
	Dim strArrOptCd			'�I�v�V�����R�[�h
	Dim strArrOptBranchNo	'�I�v�V�����}��
	Dim strOptName			'�I�v�V������
	Dim strOptSName			'�I�v�V������
	Dim strSetColor			'�Z�b�g�J���[
	Dim strConsult			'��f�v��
	Dim strBranchCount		'�I�v�V�����}�Ԑ�
	Dim strAddCondition		'�ǉ�����
	Dim strHideRpt			'��t��ʔ�\��
	Dim lngCount			'�I�v�V����������

	Dim blnConsult			'��f�`�F�b�N�̗v��
	Dim strChecked			'�`�F�b�N�{�b�N�X�̃`�F�b�N���

	Dim strPrevOptCd		'���O���R�[�h�̃I�v�V�����R�[�h
	Dim lngOptGrpSeq		'�I�v�V�����O���[�v��SEQ�l
	Dim strElementType		'�I�v�V�����I��p�̃G�������g���
	Dim strElementName		'�I�v�V�����I��p�̃G�������g��
	Dim lngOptIndex			'�ҏW�����I�v�V�����̃C���f�b�N�X
	Dim i, j				'�C���f�b�N�X

	Set objContract = Server.CreateObject("HainsContract.Contract")

	'�w��_��p�^�[���̑S�I�v�V�����������擾
	lngCount = objContract.SelectCtrPtOptFromConsult(strCslDate, strCslDivCd, strCtrPtCd, strPerId, , , , True, False, strArrOptCd, strArrOptBranchNo, strOptName, strOptSName, strSetColor, , , , , strBranchCount, strAddCondition, , , strHideRpt)

	Set objContract = Nothing
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR BGCOLOR="#eeeeee" ALIGN="center">
			<TD COLSPAN="5" NOWRAP>�����Z�b�g��</TD>
			<TD NOWRAP>��f����</TD>
		</TR>
<%
		'�ǂݍ��񂾃I�v�V�����������̌���
		For i = 0 To lngCount - 1

			'��t��ʕ\���Ώۂł����
			If strHideRpt(i) = "" Then

				'���O���R�[�h�ƃI�v�V�����R�[�h���قȂ�ꍇ
				If strArrOptCd(i) <> strPrevOptCd Then

					'�܂��ҏW����G�������g��ݒ肷��(�}�Ԑ����P�Ȃ�`�F�b�N�{�b�N�X�A�����Ȃ��΃��W�I�{�^���I��)
					strElementType = IIf(CLng(strBranchCount(i)) = 1, "checkbox", "radio")

					'�I�v�V�����ҏW�p�̃G�������g�����`����
					lngOptGrpSeq   = lngOptGrpSeq + 1
					strElementName = "opt_" & CStr(lngOptGrpSeq)

				End If

				'��f�`�F�b�N�v�ۂ̔���J�n
				blnConsult = False

				'�����w�莞
				If IsArray(strOptCd) And IsArray(strOptBranchNo) Then

					'�����w�肳�ꂽ�I�v�V�����ɑ΂��ă`�F�b�N������
					For j = 0 To UBound(strOptCd)
						If strOptCd(j) = strArrOptCd(i) And strOptBranchNo(j) = strArrOptBranchNo(i) And strConsults(j) = "1" Then
							blnConsult = True
							Exit For
						End If
					Next

				End If

				'���O���R�[�h�ƃI�v�V�����R�[�h���قȂ�ꍇ�̓Z�p���[�^��ҏW
				If strPrevOptCd <> "" And strArrOptCd(i) <> strPrevOptCd Then
%>
					<TR><TD HEIGHT="3"></TD></TR>
<%
				End If

				strChecked = IIf(blnConsult, " CHECKED", "")
%>
				<TR>
					<TD><INPUT TYPE="<%= strElementType %>" NAME="<%= strElementName %>" VALUE="<%= strArrOptCd(i) & "," & strArrOptBranchNo(i) %>"<%= strChecked %>></TD>
					<TD NOWRAP><%= strArrOptCd(i) %></TD>
					<TD NOWRAP><%= "-" & strArrOptBranchNo(i) %></TD>
					<TD NOWRAP>�F</TD>
					<TD NOWRAP><FONT COLOR="<%= strSetColor(i) %>">��</FONT><%= strOptName(i) %></TD>
					<TD ALIGN="center"><%= IIf(strAddCondition(i) = "1", "�C��", "") %></TD>
				</TR>
<%
				lngOptIndex = lngOptIndex + 1

				'�����R�[�h�̃I�v�V�����R�[�h��ޔ�
				strPrevOptCd = strArrOptCd(i)

			End If

		Next
%>
	</TABLE>
<%
End Sub
%>
