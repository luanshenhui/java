<%
'-----------------------------------------------------------------------------
'		���ʈꊇ����(��O�҂̑I��) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Dim objConsult		'��f���A�N�Z�X�pCOM�I�u�W�F�N�g

'��f�ҏ��
Dim strRsvNo		'�\��ԍ�
Dim strDayId		'����ID
Dim strLastName		'��
Dim strFirstName	'��
Dim lngCslCount		'��f�Ґ�

Dim lngStrDayId		'�J�n����ID
Dim lngEndDayId		'�I������ID
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
If Request.ServerVariables("HTTP_REFERER") = "" Then
	Response.End
End If

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'����ID�̕ҏW
lngStrDayId = CLng(IIf(mstrDayIdF = "",    0, mstrDayIdF))
lngEndDayId = CLng(IIf(mstrDayIdT = "", 9999, mstrDayIdT))

'��f�ғǂݍ���
'## 2004.01.09 Mod By T.Takagi@FSIT ���@�֘A�ǉ�
'lngCslCount = objConsult.SelectConsultList(mstrCslDate, 0, mstrCsCd, lngStrDayId, lngEndDayId, mstrGrpCd, , , , , , , , strRsvNo, strDayId, , , , strLastName, strFirstName)
'���@�ςݎ�f�҂̂ݑΏ�
lngCslCount = objConsult.SelectConsultList(mstrCslDate, 0, mstrCsCd, lngStrDayId, lngEndDayId, mstrGrpCd, , , , , , , , strRsvNo, strDayId, , , , strLastName, strFirstName, , , , , , , , , , , , , , , , , True)
'## 2004.01.09 Mod End

'��O�҃`�F�b�N�p�̔z��쐬
If lngCslCount > 0 Then
	ReDim strSelectFlg(lngCslCount - 1)
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>��O�҂̑I��</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// �I���t���O�ҏW
function editSelectFlg( checkBox, index ) {

	var myForm = document.step3;

	// �`�F�b�N�{�b�N�X�̏�Ԃ�hidden�����̃G�������g�l�Ƃ��ĕێ�
	if ( myForm.selectFlg.length == null ) {
		myForm.selectFlg.value = checkBox.checked ? '1' : '0';
	} else {
		myForm.selectFlg[index].value = checkBox.checked ? '1' : '0';
	}

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsltab  { background-color:#FFFFFF }
</STYLE>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="step3" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<%
	'�������g�̃X�e�b�v�ԍ���ێ����A����p��ASP�Ŏg�p����
%>
	<INPUT TYPE="hidden" NAME="step" VALUE="<%= mstrStep %>">

	<!-- �O���(Step1)����̈��p����� -->

	<INPUT TYPE="hidden" NAME="year"   VALUE="<%= mlngYear   %>">
	<INPUT TYPE="hidden" NAME="month"  VALUE="<%= mlngMonth  %>">
	<INPUT TYPE="hidden" NAME="day"    VALUE="<%= mlngDay    %>">
	<INPUT TYPE="hidden" NAME="csCd"   VALUE="<%= mstrCsCd   %>">
	<INPUT TYPE="hidden" NAME="dayIdF" VALUE="<%= mstrDayIdF %>">
	<INPUT TYPE="hidden" NAME="dayIdT" VALUE="<%= mstrDayIdT %>">

	<!-- �O���(Step2)����̈��p����� -->

	<INPUT TYPE="hidden" NAME="grpCd"          VALUE="<%= mstrGrpCd          %>">
	<INPUT TYPE="hidden" NAME="allResultClear" VALUE="<%= mstrAllResultClear %>">
<%
	 For mlngIndex1 = 0 To UBound(mstrItemCd)
%>
		<INPUT TYPE="hidden" NAME="itemCd" VALUE="<%= mstrItemCd(mlngIndex1) %>">
		<INPUT TYPE="hidden" NAME="suffix" VALUE="<%= mstrSuffix(mlngIndex1) %>">
		<INPUT TYPE="hidden" NAME="result" VALUE="<%= mstrResult(mlngIndex1) %>">
<%
	Next
%>
	<BLOCKQUOTE>

	<!-- �\�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">Step3�F��O�҂̑I��</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<FONT COLOR="#cc9999">��</FONT>&nbsp;���̈ꊇ���ʓ��͏����ŁA�������ʂ��Z�b�g�������Ȃ���f�҂�I�����Ă��������B<BR><BR>
<%
	If mstrAllResultClear <> "1" Then
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<TR>
				<TD><INPUT TYPE="checkbox" NAME="overWrite" VALUE="1"<%= IIf(mstrOverWrite = "1", " CHECKED", "") %>></TD>
				<TD>���łɓ��͂���Ă��錋�ʂ��㏑������</TD>
			</TR>
		</TABLE>
<%
	End If
%>
	<BR>
<%
	'��f�҈ꗗ�̕ҏW
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
<%
		'�\��̕ҏW
%>
		<TR ALIGN="center" BGCOLOR="#cccccc">
<%
			mlngIndex1 = 0
			Do Until mlngIndex1 = 4 Or mlngIndex1 >= lngCslCount
%>
				<TD NOWRAP>�����h�c</TD>
				<TD NOWRAP WIDTH="115">����</TD>
				<TD NOWRAP BGCOLOR="#ffffff"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1"></TD>
<%
				mlngIndex1 = mlngIndex1 + 1
			Loop
%>
		</TR>
<%
		mlngIndex2 = 0
		For mlngIndex1 = 0 To lngCslCount - 1

			If mlngIndex2 = 0 Then
%>
				<TR BGCOLOR="#eeeeee">
<%
			End If
%>
			<INPUT TYPE="hidden" NAME="rsvNo"     VALUE="<%= strRsvNo(mlngIndex1)     %>">
			<INPUT TYPE="hidden" NAME="selectFlg" VALUE="<%= strSelectFlg(mlngIndex1) %>">
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="checkbox" VALUE="<%= strSelectFlg(mlngIndex1) %>"<%= IIf(strSelectFlg(mlngIndex1) = "1", " CHECKED", "") %> ONCLICK="JavaScript:editSelectFlg(this, <%= mlngIndex1 %>)"></TD>
						<TD><%= Right("0000" & strDayId(mlngIndex1), 4) %></TD>
					</TR>
				</TABLE>
			</TD>
			<TD NOWRAP><%= strLastName(mlngIndex1) %>�@<%= strFirstName(mlngIndex1) %></TD>
			<TD NOWRAP BGCOLOR="#ffffff"></TD>
<%
			If mlngIndex2 = 3 Or mlngIndex2 = lngCslCount - 1 Then
%>
				</TR>
<%
			End If

			mlngIndex2 = mlngIndex2 + 1
			If mlngIndex2 > 3 Then
				mlngIndex2 = 0
			End If

		Next
%>
	</TABLE>

	<BR>

	<A HREF="JavaScript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>

    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
	    <INPUT TYPE="image" NAME="step4" SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�">
    <%  end if  %>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
