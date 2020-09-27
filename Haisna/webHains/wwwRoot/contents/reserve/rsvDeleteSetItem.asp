<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�\����ڍ�(�Z�b�g�����ڂ̍폜) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objConsult			'��f���A�N�Z�X�p
Dim objContract			'�_����A�N�Z�X�p

'�����l
Dim strRsvNo			'�\��ԍ�
Dim strCtrPtCd			'�_��p�^�[���R�[�h
Dim strOptCd			'�I�v�V�����R�[�h
Dim strOptBranchNo		'�I�v�V�����}��
Dim strItemCd			'�������ڃR�[�h
Dim strConsults			'��f���("1":��f�A"0":����f)

'�������ڏ��
Dim strArrItemCd		'�������ڃR�[�h
Dim strArrRequestName	'�˗����ږ�
Dim strArrConsults		'��f���("1":��f�A"0":����f)
Dim lngCount			'���R�[�h��

Dim strOptName			'�I�v�V������
Dim strHTML				'HTML������
Dim i, j				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objConsult  = Server.CreateObject("HainsConsult.Consult")
Set objContract = Server.CreateObject("HainsContract.Contract")

'�����l�̎擾
strRsvNo       = Request("rsvNo")
strCtrPtCd     = Request("ctrPtCd")
strOptCd       = Request("optCd")
strOptBranchNo = Request("optBranchNo")
strItemCd      = ConvIStringToArray(Request("itemCd"))
strConsults    = ConvIStringToArray(Request("consults"))

'�ۑ��{�^��������
If Not IsEmpty(Request("save.x")) Then

	'��f���������ڃe�[�u���X�V
	objConsult.SetConsult_I strRsvNo, Request.ServerVariables("REMOTE_ADDR"), Session("USERID"), strItemCd, strConsults

	'�G���[���Ȃ���Ύ��g�����
	strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
	strHTML = strHTML & "<BODY ONLOAD=""javascript:close()"">"
	strHTML = strHTML & "</BODY>"
	strHTML = strHTML & "</HTML>"
	Response.Write strHTML
	Response.End

End If

'�w��\��ԍ��̎�f���ɑ΂��A�w��_��p�^�[���E�I�v�V�����ɂ����錟�����ڂ̎�f��Ԃ��擾
lngCount = objContract.SelectCtrPtOptItem(strRsvNo, strCtrPtCd, strOptCd, strOptBranchNo, strArrItemCd, strArrRequestName, strArrConsults)

'�����Ɏ�f��Ԃ��n����Ă���ꍇ
If Not IsEmpty(strItemCd) Then

	'��ɓǂݍ��񂾌������ڂƈ����ɂēn���ꂽ��f��ԂƂ̃}�b�`���O(�}�b�`���Ȃ����ڂɂ��Ă͓ǂݍ��񂾎�f��Ԃ�K�p)
	For i = 0 To lngCount - 1
		For j = 0 To UBound(strItemCd)
			If strItemCd(j) = strArrItemCd(i) Then
				strArrConsults(i) = strConsults(j)
				Exit For
			End If
		Next
	Next

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�Z�b�g�����ڂ̍폜</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// �`�F�b�N���̐���
function checkItem( index, checkBox ) {

	var objConsults;	// ��f��ԗp�G�������g

	// �������ڂ��P���A�����̏ꍇ�ɂ�鐧��
	if ( document.entryForm.itemCd.length == null ) {
		objConsults = document.entryForm.consults;
	} else {
		objConsults = document.entryForm.consults[ index ];
	}

	// ��f��Ԃ̕ҏW
	objConsults.value = checkBox.checked ? '1' : '0';

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="rsvNo"       VALUE="<%= strRsvNo       %>">
	<INPUT TYPE="hidden" NAME="ctrPtCd"     VALUE="<%= strCtrPtCd     %>">
	<INPUT TYPE="hidden" NAME="optCd"       VALUE="<%= strOptCd       %>">
	<INPUT TYPE="hidden" NAME="optBranchNo" VALUE="<%= strOptBranchNo %>">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN>�Z�b�g�����ڂ̍폜</B></TD>
		</TR>
	</TABLE>
<%
	'�_��p�^�[���I�v�V�����Ǘ����ǂݍ���
	objContract.SelectCtrPtOpt strCtrPtCd, strOptCd, strOptBranchNo, strOptName
%>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
		<TR>
			<TD HEIGHT="35" WIDTH="100%" NOWRAP>�����Z�b�g���F<FONT COLOR="#FF6600"><B><%= strOptName %></B></FONT></TD>
<%
			'�������ڂ����݂���ꍇ�̂ݕۑ��{�^����p�ӂ���
			If lngCount > 0 Then
%>
                <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                    <TD><INPUT TYPE="image" NAME="save" SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�"></A></TD>
                <%  end if  %>
<%
			End If
%>
			<TD><A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A></TD>
		</TR>
	</TABLE>
	<FONT COLOR="#cc9999">��</FONT>�Z�b�g����f���ڂ̈ꗗ��\�����Ă��܂��B<BR>
	<FONT COLOR="#cc9999">��</FONT>��f���s��Ȃ����ڂɂ��Ă�<INPUT TYPE="checkbox" CHECKED>�}�[�N���O���ĉ������B<BR><BR>
<%
	Do

		'�Z�b�g�����ڂ����݂��Ȃ��ꍇ
		If lngCount <= 0 Then
%>
			���̃Z�b�g�̎�f���ڂ͑��݂��܂���B
<%
			Exit Do
		End If
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
			<TR>
				<TD></TD>
				<TD WIDTH="50%"></TD>
				<TD></TD>
				<TD WIDTH="50%"></TD>
			</TR>
<%
			'�Z�b�g�����ڂ̕ҏW
			i = 0
			Do
%>
				<TR>
<%
				'�P�s�ӂ�Q�������ڂ�ҏW
				For j = 1 To 2
%>
					<TD><INPUT TYPE="hidden" NAME="itemCd" VALUE="<%= strArrItemCd(i) %>"><INPUT TYPE="hidden" NAME="consults" VALUE="<%= strArrConsults(i) %>"><INPUT TYPE="checkbox" ONCLICK="checkItem(<%= i %>,this)"<%= IIf(strArrConsults(i) = "1", " CHECKED", "") %>></TD>
					<TD NOWRAP><%= strArrRequestName(i) %></TD>
<%
					i = i + 1
					If i >= lngCount Then
						Exit For
					End If

				Next

				If i >= lngCount Then
%>
					</TR>
<%
					Exit Do
				End If

			Loop
%>
		</TABLE>
<%
		Exit Do
	Loop
%>
</FORM>
</BODY>
</HTML>
