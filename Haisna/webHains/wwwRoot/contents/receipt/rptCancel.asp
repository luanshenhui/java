<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		��t���� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MODE_CANCELRECEIPT      = "cancelreceipt"			'�������[�h(��t������)
Const MODE_CANCELRECEIPTFORCE = "cancelreceiptforce"	'�������[�h(������t������)
Const CALLED_FROMDETAIL       = "detail"				'�Ăь����(�\��ڍ�)
Const CALLED_FROMLIST         = "list"					'�Ăь����(��f�҈ꗗ)
Const CALLED_FROMBCD          = "bcd"					'�Ăь����(�o�[�R�[�h��t)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objConsult		'��f���A�N�Z�X�p

'�����l
Dim strCalledFrom	'�Ăь����("detail":�\��ڍׁA"list":��f�҈ꗗ)
Dim strActMode		'�u�m��v�{�^�����������ꂽ�ꍇ"1"
Dim lngRsvNo		'�\��ԍ�
Dim strCslYear		'��f�N
Dim strCslMonth 	'��f��
Dim strCslDay		'��f��
Dim strForce		'�����t���O

'��f���
Dim strPerId		'�l�h�c
Dim strCslDate		'��f�N����
Dim strCsCd			'�R�[�X�R�[�h
Dim strCsName		'�R�[�X��
Dim strLastName		'��
Dim strFirstName	'��
Dim strLastKName	'�J�i��
Dim strFirstKName	'�J�i��
Dim strBirth		'���N����
Dim strAge			'��f���N��
Dim strGender		'����
Dim strDayId		'����ID(������ID�ƂȂ�)

Dim strMessage		'�G���[���b�Z�[�W
Dim strHTML			'HTML������
Dim Ret				'�֐��߂�l

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'�����l�̎擾
strCalledFrom = Request("calledFrom")
strActMode    = Request("actMode")
lngRsvNo      = Request("rsvNo")
strCslYear    = Request("cslYear")
strCslMonth   = Request("cslMonth")
strCslDay     = Request("cslDay")
strForce      = Request("forceFlg")

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'�u�m��v�{�^���������ȊO�͉������Ȃ�
	If strActMode = "" Then
		Exit Do
	End If

	'��f�҈ꗗ�܂��̓o�[�R�[�h��t��ʂ���Ă΂ꂽ���ȊO�͉������Ȃ�
	If strCalledFrom <> CALLED_FROMLIST And strCalledFrom <> CALLED_FROMBCD Then
		Exit Do
	End If

	'��t����������
'## 2004.01.03 Mod By T.Takagi@FSIT �X�V�ґΉ�
'	Ret = objConsult.CancelReceipt(lngRsvNo, strCslYear, strCslMonth, strCslDay, strMessage, (strForce <> ""))
	Ret = objConsult.CancelReceipt(lngRsvNo, Session("USERID"), strCslYear, strCslMonth, strCslDay, strMessage, (strForce <> ""))
'## 2004.01.03 Mod End
	If Ret <= 0 Then
		Exit Do
	End If

	'�G���[���Ȃ���ΌĂь�(��f�҈ꗗ)��ʂ������[�h���Ď��g�����
	strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"

	If strCalledFrom = CALLED_FROMLIST Then
		strHTML = strHTML & "<BODY ONLOAD=""JavaScript:if ( opener != null ) opener.location.reload(); close()"">"
	Else
		strHTML = strHTML & "<BODY ONLOAD=""JavaScript:if ( opener != null ) opener.location.href = '/webHains/contents/receipt/rptBarcode.asp'; close()"">"
	End If

	strHTML = strHTML & "</BODY>"
	strHTML = strHTML & "</HTML>"
	Response.Write strHTML
	Response.End

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>��t�̎�����</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// ��t������
function cancelReceipt() {

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	// �\��ڍ׉�ʂ���Ă΂ꂽ�ꍇ
	if ( myForm.calledFrom.value == '<%= CALLED_FROMDETAIL %>' ) {

		// �\����ڍ׉�ʂ�submit����
		if ( myForm.forceFlg.checked ) {
			opener.top.submitForm('<%= MODE_CANCELRECEIPTFORCE %>');
		} else {
			opener.top.submitForm('<%= MODE_CANCELRECEIPT %>');
		}

		close();
		return;

	}

	// ��f�҈ꗗ�܂��̓o�[�R�[�h��t��ʂ���Ă΂ꂽ�ꍇ
	if ( myForm.calledFrom.value == '<%= CALLED_FROMLIST %>' || myForm.calledFrom.value == '<%= CALLED_FROMBCD %>' ) {

		// submit����
		myForm.submit();

	}

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<INPUT TYPE="hidden" NAME="calledFrom" VALUE="<%= strCalledFrom %>">
	<INPUT TYPE="hidden" NAME="actMode"    VALUE="1">
	<INPUT TYPE="hidden" NAME="rsvNo"      VALUE="<%= lngRsvNo %>">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">��t�̎�����</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	If strMessage <> "" Then

		EditMessage strMessage, MESSAGETYPE_WARNING
%>
		<BR>
<%
	End If

	'��f���̓ǂݍ���
	If objConsult.SelectConsult(lngRsvNo, 0, strCslDate, strPerId, strCsCd, strCsName, , , , , , _
								strAge, , , , , , , , , , , , , _
								strDayId, , , , , , , , , , , , , , , , , , _
								strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGender) = False Then
		Err.Raise 1000,,"��f��񂪑��݂��܂���B"
	End If
%>
	<INPUT TYPE="hidden" NAME="cslYear"  VALUE="<%= Year(CDate(strCslDate))  %>">
	<INPUT TYPE="hidden" NAME="cslMonth" VALUE="<%= Month(CDate(strCslDate)) %>">
	<INPUT TYPE="hidden" NAME="cslDay"   VALUE="<%= Day(CDate(strCslDate))   %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %></B></FONT></TD>
			<TD><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
		</TR>
		<TR>
			<TD><%= strPerId %></TD>
			<TD NOWRAP><B><%= strLastName %>�@<%= strFirstName %></B> �i<FONT SIZE="-1"><%= strLastKName %>�@<%= strFirstKName %></FONT>�j</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><%= objCommon.FormatString(strBirth, "ge.m.d") %>��<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1"><%= IIf(CLng(strGender) = GENDER_MALE, "�j��", "����") %></TD>
		</TR>
	</TABLE>

	<BR><B>���̎�f�҂̎�t���������܂��B</B><BR><BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD><INPUT TYPE="checkbox" NAME="forceFlg" VALUE="1" <%= IIf(strForce = "1", "CHECKED", "") %>></TD>
			<TD NOWRAP>���ʂ����͂���Ă���ꍇ�������I�Ɏ�t��������</TD>
		</TR>
	</TABLE>

	<BR><BR>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="3" ALIGN="right">
		<TR>
			<TD>
            <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
           	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>  
                <A HREF="JavaScript:cancelReceipt()"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="��t��������"></A>
            <%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 �����Ǘ� Add by ���@--- END %>
            </TD>

			<TD><A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
		</TR>
	</TABLE>

</FORM>
</BODY>
</HTML>
