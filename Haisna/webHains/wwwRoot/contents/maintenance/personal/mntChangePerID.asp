<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�l�h�c�t���ւ� (Ver0.0.1)
'		AUTHER  : Ishihara@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Dim strAction		'�������(�m��{�^��������:"execute")
Dim strFromPerId	'�ύX���l�h�c
Dim strLastName		'�ύX����
Dim strFirstName	'�ύX����

Dim strToPerId		'�ύX��l�h�c

Dim objPerson		'�l�h�c�t���ւ��A�N�Z�X�pCOM�I�u�W�F�N�g
Dim strArrMessage	'�G���[���b�Z�[�W
Dim Ret				'�֐��߂�l

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objPerson = Server.CreateObject("HainsPerson.Person")

'�����l�̎擾
strAction		= Request("action") & ""
strFromPerId	= Request("fromPerID") & ""
strLastName		= Request("lastname") & ""
strFirstName	= Request("firstname") & ""
strToPerId		= Request("toPerID") & ""

Do

	'�m��{�^��������
	If strAction = "execute" Then

		'�ă`�F�b�N
		If Trim(strFromPerId) = "" Then
			strArrMessage = "�ϊ��Ώۂ̌l�h�c���w�肳��Ă��܂���B"
			strAction = "retry"
			Exit Do
		End If

		If Trim(strToPerId) = "" Then
			strArrMessage = "�V�����ݒ肷��l�h�c���w�肳��Ă��܂���B"
			strAction = "retry"
			Exit Do
		End If

		'�l�h�c�t���ւ�
		If objPerson.ChangePerID (strFromPerId, strToPerId) = True Then
			strArrMessage = "�h�c�̕t���ւ����������܂����B"
			strAction = "normalend"
		Else
			strArrMessage = "�X�V���ɃG���[���������܂����B"
			strAction = "error"
		End If

		'ID�t���ւ�����
		Exit Do

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
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�l�h�c�̕t���ւ�</TITLE>
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// �l�����K�C�h�Ăяo��
function callPerGuide() {

	// �l�K�C�h�\��
	perGuide_showGuidePersonal( null, null, null, setPerInfo );

}

// �l���̕ҏW
function setPerInfo( perInfo ) {

	var mydoc = document.changeperid;	// ����ʂ̃t�H�[���G�������g

	mydoc.toperid.value = perInfo.perId;
	mydoc.toname.value  = perInfo.perName;

	document.getElementById( 'pername' ).innerHTML = mydoc.toperid.value + ' ' + mydoc.toname.value + ' ' + perInfo.birthJpn + '��';

}

// �����f�ғo�^�A��f�ҏ��C����ʂ����
function closeChangePerID( action ) {

	// �X�V�����̌�łȂ���Ή������Ȃ�
	if ( action != 'normalend' ) {
		return false;
	} else {
		alert ('<%= strArrMessage %>');
		close();
	}

	close();

}

// �m��{�^���������̏���
function ExecuteChangePerID() {

	var EditMsg;

	// ��f�R�[�X�̕K�{�`�F�b�N
	if ( document.changeperid.toperid.value == '' ) {
		alert('�ϊ�����l�h�c���w�肵�ĉ������B');
		return false;
	}

	EditMsg = '<%= strFromPerId %>�@<%= strLastName %>�@<%= strFirstName %>�@�l�̃f�[�^���A';
	EditMsg = EditMsg + document.changeperid.toperid.value + '�@';
	EditMsg = EditMsg + document.changeperid.toname.value;

	res = confirm(EditMsg + '�@�l�̃f�[�^�Ƃ��ĕύX���܂��B��낵���ł����H');

	if ( res == true ){
		document.changeperid.action.value = 'execute';
	} else {
		return false;
	}

	document.changeperid.submit();

	return false;
}

//-->
</SCRIPT>
<style>
body { margin: 10px 10px 5px }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:closeChangePerID( '<%= strAction %>')">
<%
'�ۑ��������͉�ʂ����݂̂Ȃ̂ŉ����ҏW�����Ȃ�
If strAction = "normalend" Then
%>
	<BODY>
	</HTML>
<%
	Response.End
End If
%>

<FORM NAME="changeperid" ACTION="">

	<INPUT TYPE="hidden" NAME="action" VALUE="">
	<INPUT TYPE="hidden" NAME="fromperid" VALUE="<%= strFromPerId %>">
	<INPUT TYPE="hidden" NAME="toperid" VALUE="">
	<INPUT TYPE="hidden" NAME="toname" VALUE="">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�l�h�c�t���ւ�</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
%>
	<BR><B><%= strFromPerId %>�@<%= strLastName %>�@<%= strFirstName %>�@�l</B><BR>�̎�f���f�[�^�����Ɏw�肷��l�h�c�ɕύX���܂��B

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="2">
		<TR>
			<TD NOWRAP ALIGN="right">�l���F</TD>
			<TD COLSPAN="2">
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return callPerGuide()"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�l�����K�C�h��\��"></A></TD>
						<TD WIDTH="5"></TD>
						<TD NOWRAP><SPAN ID="pername"></SPAN>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" ALIGN="RIGHT">
		<TR>
			<TD WIDTH="5"></TD>
			<TD>
            <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
            <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>    
				<A HREF="javascript:function voi(){};voi()" ONCLICK="return ExecuteChangePerID()"><IMG SRC="/webHains/images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�l�h�c�̕t���ւ������s"></A>
			<%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 �����Ǘ� Add by ���@--- END %>
            </TD>

			<TD WIDTH="5"></TD>
			<TD>
				<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A>
			</TD>
		</TR>
	</TABLE>

</FORM>
</BODY>
</HTML>
