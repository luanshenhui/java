<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�ꊇ��t���� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/EditCourseList.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MODE_RECEIPT = "0"	'�������[�h(��t)
Const MODE_CANCEL  = "1"	'�������[�h(��t������)
Const CSCD_ALL     = "allcourse"

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objConsult		'��f���A�N�Z�X�p

'�����l
Dim strReceipt		'�m��{�^�������L��
Dim lngCslYear		'��f�N
Dim lngCslMonth		'��f��
Dim lngCslDay		'��f��
Dim strCsCd			'�R�[�X�R�[�h
Dim strMode			'�������[�h
Dim strUseEmptyId	'�󂫔ԍ��̎g�p�L��
Dim strForce		'�����t���O

Dim lngReceiptMode	'��t�������[�h
Dim strMessage		'�G���[���b�Z�[�W
Dim strHTML			'HTML������
Dim lngCount		'��������

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'�����l�̎擾
strReceipt    = Request("receipt.x")
lngCslYear    = CLng("0" & Request("cYear") )
lngCslMonth   = CLng("0" & Request("cMonth"))
lngCslDay     = CLng("0" & Request("cDay")  )
strCsCd       = Request("csCd")
strMode       = Request("mode")
strUseEmptyId = Request("useEmptyId")
strForce      = Request("forceFlg")

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'�u�m��v�{�^���������ȊO�͉������Ȃ�
	If strReceipt = "" Then
		Exit Do
	End If

	'��f�N�����̕K�{�`�F�b�N
	If lngCslYear + lngCslMonth + lngCslDay = 0 Then
		strMessage = "��f������͂��ĉ������B"
		Exit Do
	End If

	'��f�N�����̓��t�`�F�b�N
	If Not IsDate(lngCslYear & "/" & lngCslMonth & "/" & lngCslDay) Then
		strMessage = "��f���̓��͌`��������������܂���B"
		Exit Do
	End If

'### 2003/3/9 Deleted by Ishihara@FSIT �R�[�X�K�{�`�F�b�N����
'	'�R�[�X�̕K�{�`�F�b�N
'	If strCsCd = "" Then
'		strMessage = "�R�[�X��I�����ĉ������B"
'		Exit Do
'	End If
'### 2003/3/9 Deleted End

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �R�[�X�ꗗ�h���b�v�_�E�����X�g�̕ҏW
'
' �����@�@ : (In)     strMode                �擾���[�h
' �@�@�@�@   (In)     strName                �G�������g��
' �@�@�@�@   (In)     strSelectedCsCd        ���X�g�ɂđI�����ׂ��R�[�X�R�[�h
' �@�@�@�@   (In)     vntNotSelectedRowCtrl  ���X�g���I���s�̐���
' �@�@�@�@   (In)     blnAddRegularCourse    True�w�莞�͑S������f�R�[�X�w��s��ǉ�
'
' �߂�l�@ : HTML������
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function EditCourseList(strName, strSelectedCsCd)

	Dim objCourse	'�R�[�X���A�N�Z�X�pCOM�I�u�W�F�N�g

	Dim strCsCd		'�R�[�X�R�[�h
	Dim strCsName	'�R�[�X��
	Dim lngCount	'����

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objCourse = Server.CreateObject("HainsCourse.Course")

	'�R�[�X���̓ǂݍ���
	lngCount = objCourse.SelectCourseList(strCsCd, strCsName, , 1)

	'�T�C�Y���P���₵�āu���ׂẴR�[�X�v�̍s��ǉ�
	ReDim Preserve strCsCd(lngCount)
	ReDim Preserve strCsName(lngCount)
	strCsCd(lngCount)   = CSCD_ALL
	strCsName(lngCount) = "���ׂ�"
	lngCount = lngCount + 1

	'�h���b�v�_�E�����X�g�̕ҏW
	EditCourseList = EditDropDownListFromArray(strName, strCsCd, strCsName, strSelectedCsCd, NON_SELECTED_ADD)

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�ꊇ��t</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var okFlg = false;	// ��ʃN���[�Y�̉�

// ��ʂ����
function closeWindow() {

	if ( okFlg ) {
		opener.location.reload();
		close();
	}
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 20px; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:closeWindow()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">

	<!-- �\�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�ꊇ��t</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�ꊇ��t�����J�n
	Do
		'�u�m��v�{�^����������Ă��Ȃ��A�܂��͂����܂łŃG���[���������Ă���ꍇ�͉������Ȃ�
		If strReceipt = "" Or strMessage <> "" Then
			Exit Do
		End If

		'���������b�Z�[�W��\��
%>
		<BR><%= IIf(strMode = MODE_RECEIPT, "��t", "��t����") %>�������ł��D�D�D<BR>
<%
		Response.Flush

		'�������[�h���Ƃ̕���
		Select Case strMode

			'��t����
			Case MODE_RECEIPT

				'�ꊇ��t
				lngReceiptMode = IIf(strUseEmptyId <> "", 2, 1)
				lngCount = objConsult.ReceiptAll(lngReceiptMode, lngCslYear, lngCslMonth, lngCslDay, 0, IIf(strCsCd = CSCD_ALL, "", strCsCd), Request.ServerVariables("REMOTE_ADDR"), Session("USERID"))

				'�G���[���̓��b�Z�[�W��ҏW
				If lngCount = -14 Then
					strMessage = "���ԉ\�ȍő�ԍ��ɒB���܂����B�ꊇ��t�ł��܂���B"
					Exit Do
				End If

				If lngCount < 0 Then
					strMessage = "�ꊇ��t�����ňُ킪�������܂����B�i" & lngCount & "�j"
					Exit Do
				End If

			'��t��������
			Case MODE_CANCEL

				'�ꊇ��t������
'## 2004.01.03 Mod By T.Takagi@FSIT �X�V�ґΉ�
'				lngCount = objConsult.CancelReceiptAll(lngCslYear, lngCslMonth, lngCslDay, 0, IIf(strCsCd = CSCD_ALL, "", strCsCd), (strForce <> ""))
				lngCount = objConsult.CancelReceiptAll(Session("USERID"), lngCslYear, lngCslMonth, lngCslDay, 0, IIf(strCsCd = CSCD_ALL, "", strCsCd), (strForce <> ""))
'## 2004.01.03 Mod End

		End Select

		'����ł���ΐe��ʂ������[�h�ł���悤�A�t���O�𐬗�������
%>
		<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
		<!--
		okFlg = true;
		//-->
		</SCRIPT>
<%
		Response.End

		Exit Do
	Loop

	'�G���[���b�Z�[�W�̕ҏW
	If strMessage <> "" THEN
		Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
		<BR>
<%
	End If
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
		<TR>
			<TD NOWRAP>��f��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('cYear', 'cMonth', 'cDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("cYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("cMonth", 1, 12, lngCslMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("cDay", 1, 31, lngCslDay, False) %></TD>
			<TD>��</TD>
			<TD WIDTH="100%"></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>�R�[�X</TD>
			<TD>�F</TD>
			<TD COLSPAN="8"><%= EditCourseList("csCd", strCsCd) %></TD>
		</TR>
	</TABLE>

	<BR>

	�w�肳�ꂽ��f���A�R�[�X�ɊY������S�Ă̎�f�҂�

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1"></TD>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="<%= MODE_RECEIPT %>" CHECKED></TD>
			<TD COLSPAN="2">�����h�c�����蓖�Ă�</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD><INPUT TYPE="checkbox" NAME="useEmptyId"></TD>
			<TD NOWRAP>�󂫔ԍ������݂���ꍇ�A���̔ԍ��Ŋ��蓖�Ă��s��</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1"></TD>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="<%= MODE_CANCEL %>"></TD>
			<TD COLSPAN="2">��t����������</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD><INPUT TYPE="checkbox" NAME="forceFlg"></TD>
			<TD NOWRAP>���ʂ����͂���Ă���ꍇ�������I�Ɏ�t��������</TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="3" ALIGN="right">
		<TR>
			<TD>
            <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
        	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %> 
                <INPUT TYPE="image" NAME="receipt" SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="���̓��e�Ŋm��">
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
