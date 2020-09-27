<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���@���ݒ�  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->

<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			    '���ʃN���X
Dim objFollow               '�t�H���[�A�b�v�A�N�Z�X�p 

'�p�����[�^
Dim lngCheckSeq			    '��ʃ��[�h(1 :1������, 2 :2������)
Dim strModeName			    '��ʃ��[�h����
Dim strAction			    '������� (save:�������o�^)

Dim lngRsvNo                '�\��ԍ�
Dim lngJudClassCd           '���蕪�ރR�[�h
Dim lngReqCheckMode         '�������o�^���[�h�i1:���� , 2:�������j
Dim strCheckDate            '������
Dim strReqCheckDate         '�������i�o�^�����j
Dim strReqCheckYear         '�������i�N�j
Dim strReqCheckMonth        '�������i���j
Dim strReqCheckDay          '�������i���j
Dim strUpdUser			    '�X�V��
Dim strArrMessage		    '�G���[���b�Z�[�W
Dim Ret					    '�֐��߂�l

Dim strSql


'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objFollow       = Server.CreateObject("HainsFollow.Follow")

'�����l�̎擾
lngCheckSeq             = Request("mode")
strAction			    = Request("act")
lngRsvNo			    = Request("rsvno")
lngJudClassCd		    = Request("judClassCd")
lngReqCheckMode         = Request("reqCheckMode")
strReqCheckDate         = Request("reqCheckDate")

strReqCheckYear         = Request("reqCheckYear")
strReqCheckMonth        = Request("reqCheckMonth")
strReqCheckDay          = Request("reqCheckDay")

strSql = ""

'�������̐ݒ�

If strAction = "" Then
    If IsDate(strReqCheckDate) Then
        strReqCheckYear = Mid(strReqCheckDate, 1, 4) 
        strReqCheckMonth = Mid(strReqCheckDate, 6, 2) 
        strReqCheckDay = Mid(strReqCheckDate, 9, 2) 
        lngReqCheckMode = 1
    Else   
        strReqCheckYear   = Year(Now())				'�J�n�N
		strReqCheckMonth  = Month(Now())			'�J�n��
		strReqCheckDay    = Day(Now())				'�J�n��
        'strReqCheckDate = strReqCheckYear & "/" & strReqCheckMonth & "/" & strReqCheckDay
        lngReqCheckMode = 2
    End If
End If


Do
	Select Case lngCheckSeq
	Case "1"
		strModeName = "�P������"
	Case "2"
		strModeName = "�Q������"
	Case Else
		strModeName = ""
	End Select


	If strAction = "save" Then
        'strReqCheckDate = strReqCheckYear & "/" & strReqCheckMonth & "/" & strReqCheckDay

        '���̓`�F�b�N
        strArrMessage = CheckValue()
        If Not IsEmpty(strArrMessage) Then
            Exit Do
        End If

		'### �������o�^����
        Ret = objFollow.UpdateFollow_Info_Kansho(lngRsvNo, lngJudClassCd, strReqCheckDate, lngCheckSeq, lngReqCheckMode, Session.Contents("userId"))
        If Ret Then
            strAction = "saveend"
        Else
            strArrMessage = Array("�������o�^�Ɏ��s���܂����B")
            Exit Do
        End If
    End If

	Exit Do
Loop


'-------------------------------------------------------------------------------
Function CheckValue()

    Dim objCommon       '���ʃN���X

    Dim vntArrMessage   '�G���[���b�Z�[�W�̏W��
    Dim strMessage      '�G���[���b�Z�[�W
    Dim i               '�C���f�b�N�X

    '���ʃN���X�̃C���X�^���X�쐬
    Set objCommon = Server.CreateObject("HainsCommon.Common")

    '�e�l�`�F�b�N����
    With objCommon
        '������
        .AppendArray vntArrMessage, .CheckDate("������", strReqCheckYear , strReqCheckMonth, strReqCheckDay, strReqCheckDate)
    End With

    '�߂�l�̕ҏW
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE><%= strModeName %>���̓o�^</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<%
    '### �ۑ�������e��ʂ��ŐV���ŕ\�����A�����̉�ʂ����
    If strAction = "saveend"  Then
%>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
        //�e��ʂ������Ă��Ȃ������ꍇ�A�e��ʃ��t���b�V��
        if (!opener.closed) {
            opener.replaceForm();
        }
        window.close();
//-->
</SCRIPT>
<%
    End If
%>
<SCRIPT TYPE="text/javascript">
<!--
//�ۑ�����
function followRslKansho() {
    var confirmMsg;
    var scnt ;
    var reqFlg;

    reqFlg = '';
    reqFlg = document.entryForm.reqCheckMode.value;

    if (reqFlg == 1) {
        confirmMsg = '�������o�^�������s���܂��B��낵���ł��傤���H';
    } else if (reqFlg == 2) {
        confirmMsg = '�������������s���܂��B��낵���ł��傤���H';
    } else {
      return;
    }

    if ( !confirm( confirmMsg ) ) {
        return;
    }
    with ( document.entryForm ) {
        act.value = 'save';
        submit();
    }
    return false;
}

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 20px 20px 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- �����l -->
	<INPUT TYPE="hidden"    NAME="rsvno"        VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden"    NAME="judClassCd"   VALUE="<%= lngJudClassCd %>">
	<INPUT TYPE="hidden"    NAME="mode"         VALUE="<%= lngCheckSeq %>">
	<INPUT TYPE="hidden"    NAME="act"          VALUE="<%= strAction %>">


	<!-- �^�C�g���̕\�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000"><%= strModeName %>���̓o�^</FONT></B></TD>
		</TR>
	</TABLE>
	<BR>
<%
		If Not IsEmpty(strArrMessage) Then
			'�G���[���b�Z�[�W��ҏW
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If
%>
	<BR>

<!--- ���t -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</FONT></TD>
			<TD WIDTH="76" NOWRAP><%= strModeName %>��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('reqCheckYear', 'reqCheckMonth', 'reqCheckDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("reqCheckYear", YEARRANGE_MIN, YEARRANGE_MAX, strReqCheckYear, True) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("reqCheckMonth", 1, 12, strReqCheckMonth, True) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("reqCheckDay", 1, 31, strReqCheckDay, True) %></TD>
			<TD>��</TD>
		</TR>
	</TABLE>



	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<BR>
        <TR>
			<TD>��</FONT></TD>
            <TD WIDTH="76" NOWRAP><%= strModeName %></TD>
			<TD>�F</TD>

			<TD WIDTH="70">
				<INPUT TYPE="radio" NAME="radio_Kansho" VALUE="1" <%= IIf(IsDate(strReqCheckDate), "CHECKED", "") %> STYLE="ime-mode:disabled" ONCHANGE="javascript:document.entryForm.radio_Kansho.value = this.value;document.entryForm.reqCheckMode.value = this.value">����
            </TD>
            <TD WIDTH="70">
				<INPUT TYPE="radio" NAME="radio_Kansho" VALUE="2" <%= IIf(IsDate(strReqCheckDate), "", "CHECKED") %> STYLE="ime-mode:disabled" ONCHANGE="javascript:document.entryForm.radio_Kansho.value = this.value;document.entryForm.reqCheckMode.value = this.value">������
				<INPUT TYPE="hidden" NAME="reqCheckMode" VALUE="<%= lngReqCheckMode %>">
			</TD>
		</TR>


	</TABLE>
	<BR>
	<TABLE WIDTH="300" BORDER="0" CELLSPACING="2" CELLPADDING="0">
		<BR>
        <TR ALIGN="center">
            <TD  WIDTH="100"></TD>
            <TD>
            <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
           	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>  
                <A HREF="javascript:followRslKansho()">
                <IMG SRC="../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�" border="0"></A>
            <%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 �����Ǘ� Add by ���@--- END %>
            </TD>
            
            <TD><A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��" border="0"></A></TD>
		</TR>
	</TABLE>
	<BR>
</FORM>
</BODY>
</HTML>
