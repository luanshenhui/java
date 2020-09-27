<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�Ƒ������ (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditConditionList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Dim strMode                             '�������[�h(�}��:"insert"�A�X�V:"update")
Dim strAction                           '�������(�o�^�{�^��������:"save"�A�ۑ�������:"saveend")
Dim strButton                           '�{�^�����(�o�^�{�^��������:"�o�@�^"�A�߂�{�^��������:"�߁@��")
Dim strPerID                            '�l�h�c
Dim strRelation                         '����
Dim strDisCd                            '�a���R�[�h
Dim strDisName                          '�a��
Dim lngStrYear                          '���a�N���i�N�j
Dim lngStrMonth                         '���a�N���i���j
Dim lngEndYear                          '�����N���i�N�j
Dim lngEndMonth                         '�����N���i���j
Dim strCondition                        '���
Dim strMedical                          '��Ë@��
Dim strStrDate                          '���a�N���i�ҏW�p�j
Dim strEndDate                          '�����N���i�ҏW�p�j

Dim strLastName                         '��
Dim strFirstName                        '��
Dim strLastKName                        '�J�i��
Dim strFirstKName                       '�J�i��
Dim strBirth                            '���N����
Dim strGenderName                       '���ʖ���

Dim objCommon                           '���ʊ֐��A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objDisease                          '�������Ƒ������A�N�Z�X�pCOM�I�u�W�F�N�g

Dim strArrMessage                       '�G���[���b�Z�[�W
Dim Ret                                 '�֐��߂�l
Dim i                                   '�C���f�b�N�X
Dim strHTML                             'HTML������

Dim strArrRelation		'����
Dim strArrRelationName	'��������

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strMode       = Request("mode") & ""
strAction     = Request("action") & ""
strButton     = Request("submit") & ""
strPerID      = Request("perid") & ""
strRelation   = Request("relation") & ""
strDisCd      = Request("discd") & ""
strDisName    = Request("disname") & ""
lngStrYear    = CLng("0" & Request("stryear"))
lngStrMonth   = CLng("0" & Request("strmonth"))
lngEndYear    = CLng("0" & Request("endyear"))
lngEndMonth   = CLng("0" & Request("endmonth"))
strCondition  = Request("condition") & ""
strMedical    = Request("medical") & ""

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon = Server.CreateObject("HainsCommon.Common")
Set objDisease = Server.CreateObject("HainsDisease.Disease")

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do 
        '�߂�{�^��������
        If strButton = "�߁@��" Then
                '�������E�Ƒ����ꗗ��ʂɃ��_�C���N�g
                Response.Redirect "perDisease.asp?perID=" & strPerID
                Response.End
        End If

        '���a�N���A�����N���ҏW
        strStrDate = lngStrYear & "/" & lngStrMonth & "/1"
        strEndDate = lngEndYear & "/" & lngEndMonth & "/1"

        '�ۑ��{�^��������
        If strAction = "save" Then

                '���̓`�F�b�N
                strArrMessage = objDisease.CheckValue(strPerID, _
                                                      strRelation, _
                                                      strDisCd, _
                                                      lngStrYear, _
                                                      lngStrMonth, _
                                                      lngEndYear, _
                                                      lngEndMonth,_
                                                      strCondition, _
                                                      strMedical, _
                                                      strStrDate, _
                                                      strEndDate _
                                                     )

                '�`�F�b�N�G���[���͏����𔲂���
                If Not IsEmpty(strArrMessage) Then
                    Exit Do
                End If

                '�ۑ�����
                If strMode = "update" Then

                        '�������Ƒ����e�[�u�����R�[�h�X�V
                        Ret = objDisease.UpdateDisHistory(strPerID, _
                                                          strRelation, _
                                                          strDisCd, _
                                                          strStrDate, _
                                                          strEndDate, _
                                                          strCondition, _
                                                          strMedical _
                                                         )

                        '�f�[�^�Ȃ����̓G���[���b�Z�[�W��ҏW����
                        If Ret = UPDATE_NOTFOUND Then
                                strArrMessage = Array("�Y������f�[�^�͊��ɍ폜����Ă��܂��B")
                                Exit Do
                        End If

                Else
                        '�������Ƒ����e�[�u�����R�[�h�}��
                        Ret = objDisease.InsertDisHistory(strPerID, _
                                                          strRelation, _
                                                          strDisCd, _
                                                          strStrDate, _
                                                          strEndDate, _
                                                          strCondition, _
                                                          strMedical _
                                                         )

                        '�L�[�d�����̓G���[���b�Z�[�W��ҏW����
                        If Ret = INSERT_DUPLICATE Then
                                strArrMessage = Array("���ꑱ���C�a���C���a�N���̉Ƒ�����񂪂��łɑ��݂��܂��B")
                                Exit Do
                        End If

                End If

                '�a���R�[�h�̐������G���[���̓G���[���b�Z�[�W��ҏW����
                If Ret = ALERT_FKEY2 Then
                        strArrMessage = Array("���݂��Ȃ��a���ł��B")
                        Exit Do
                End If

                '�ۑ��ɐ��������ꍇ�A�X�V���[�h�Ń��_�C���N�g
                Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?mode=update&action=saveend&perID=" & strPerID & "&relation=" & strRelation & "&disCd=" & strDisCd & "&stryear=" & lngStrYear & "&strmonth=" & lngStrMonth
                Response.End

        End If

        '�V�K���[�h�̏ꍇ�͓ǂݍ��݂��s��Ȃ�
        If strMode = "insert" Then
            '�����\���ݒ�
            lngStrYear = Year(Now)
            lngStrMonth = Month(Now)
            Exit Do
        End If

        '�������Ƒ����e�[�u�����R�[�h�ǂݍ���
        Call objDisease.SelectDisHistory(strPerID, _
                                         strRelation, _
                                         strDisCd, _
                                         strStrDate, _
                                         lngEndYear, _
                                         lngEndMonth, _
                                         strCondition, _
                                         strMedical, _
                                         strDisName _
                                        )

        Exit Do
Loop

'-----------------------------------------------------------------------------
' ���b�Z�[�W�̕ҏW
'-----------------------------------------------------------------------------
Function EditMessage()

        Dim strHTML     'HTML������
        Dim i           '�C���f�b�N�X

        '������Ԗ��w�莞�ȊO�͉������Ȃ�
        If strAction = "" Then
                Exit Function
        End If

        Do
                '�ۑ��������́u�ۑ������v�̒ʒm
                If strAction = "saveend" Then
                        strHTML = "<FONT COLOR=""#ff6600"" SIZE=""+1""><B>�ۑ����܂����B</B></FONT><BR><BR>"
                        Exit Do
                End If

                '�G���[���b�Z�[�W�̕ҏW
                strHTML = "<UL>"

                For i = 0 To UBound(strArrMessage)
                        strHTML = strHTML & vbLf & "<LI>" & strArrMessage(i)
                Next

                strHTML = strHTML & vbLf & "</UL>"

                Exit Do
        Loop

        EditMessage = strHTML

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�Ƒ�����͉��</TITLE>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryfamily" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

        <INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">
        <INPUT TYPE="hidden" NAME="action" VALUE="save">
		<INPUT TYPE="hidden" NAME="perID" VALUE="<%= strPerID %>">
		<INPUT TYPE="hidden" NAME="medical" VALUE="">
		<INPUT TYPE="hidden" NAME="disname" VALUE="<%= strDisName %>">

<%
        '�C�����̃L�[���ڂ͓��͕s�̂���hidden�ł���
        If strMode = "update" Then
%>
			<INPUT TYPE="hidden" NAME="relation" VALUE="<%= strRelation %>">
			<INPUT TYPE="hidden" NAME="disCd" VALUE="<%= strDisCd %>">
			<INPUT TYPE="hidden" NAME="stryear" VALUE="<%= lngStrYear %>">
			<INPUT TYPE="hidden" NAME="strmonth" VALUE="<%= lngStrMonth %>">
<%
        End If

		'�l���̃��R�[�h���擾
		If objDisease.SelectPerson(strPerID, strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGenderName) Then

			'�l���̕ҏW
%>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="626">
				<TR>
					<TD NOWRAP WIDTH="46" ROWSPAN="2" VALIGN="TOP"><%= strPerID %></TD>
					<TD NOWRAP><B><%= strLastName & "�@" & strFirstName %></B> (<FONT SIZE="-1"><%= strLastKname & "�@" & strFirstKName %></FONT>)</TD>
				</TR>
				<TR>
					<TD NOWRAP><%= strBirth %>���@<%= strGenderName %></TD>
				</TR>
			</TABLE>
<%
		End If
%>
		<BR>

		<BR>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="100%">
			<TR VALIGN="bottom">
				<TD COLSPAN="2"><FONT SIZE="+2"><B>�Ƒ����̓���</B></FONT></TD>
			</TR>
			<TR HEIGHT="2">
				<TD COLSPAN="2" BGCOLOR="#CCCCCC"><IMG SRC="webHains/images/spacer.gif" WIDTH="1" HEIGHT="2" BORDER="0"></TD>
			</TR>
		</TABLE>
		<BR> 

        <%= EditMessage() %>

		<BR> 
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
			<TR>
				<TD><FONT color="#666666">��</FONT>����</TD>
				<TD>�F</TD>
				<TD>
<%
					'�C�����̓L�[���ڕύX�s�i�\���̂݁j
					If strMode = "update" Then
%>
						<%= objCommon.SelectRelationName(strRelation) %>
<%
					Else

						'�������̕ҏW
						If objCommon.SelectRelationList(strArrRelation, strArrRelationName) > 0 Then
%>
							<%= EditDropDownListFromArray("relation", strArrRelation, strArrRelationName, strRelation, NON_SELECTED_ADD) %>
<%
						End If

					End If
%>
				</TD>
			</TR>
			<TR>
				<TD><FONT color="#666666">��</FONT>�a��</TD>
				<TD>�F</TD>
				<TD>
<%
					'�C�����̓L�[���ڕύX�s�i�\���̂݁j
					If strMode = "update" Then
%>
						<%= strDisName %>
<%
					Else
%>
						<INPUT TYPE="text" NAME="disCd" SIZE="<%= TextLength(9) %>" MAXLENGTH="<%= TextMaxLength(18) %>" VALUE="<%= strDisCd %>" >
<%
					End If
%>
				</TD>
			</TR>
			<TR>
				<TD><FONT color="#666666">��</FONT>���a�N��</TD>
				<TD>�F</TD>
				<TD>
<%
					'�C�����̓L�[���ڕύX�s�i�\���̂݁j
					If strMode = "update" Then
%>
						<%= objCommon.FormatString(lngStrYear & "/" & lngStrMonth & "/1", "yyyy�Nmm��") %>
<%
					Else
%>
						<%= EditSelectYearList(YEARS_BIRTH, "stryear", lngStrYear) %>�N
						<%= EditSelectNumberList("strmonth", 1, 12, lngStrMonth) %>��
<%
					End If
%>
				</TD>
			</TR>
			<TR>
				<TD><FONT color="#666666">��</FONT>�����N��</TD>
				<TD>�F</TD>
				<TD>
					<%= EditSelectYearList(YEARS_BIRTH, "endyear", lngEndYear) %>�N
					<%= EditSelectNumberList("endmonth", 1, 12, lngEndMonth) %>��
				</TD>
			</TR>
			<TR>
				<TD><FONT color="#666666">��</FONT>���</TD>
				<TD>�F</TD>
				<TD>
					<%= EditConditionList("condition", strCondition) %>
				</TD>
			</TR>
		</TABLE>
		<BR>
		<BR>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="150">		
			<TR>
				<TD ALIGN="left">
					<INPUT TYPE="submit" NAME="submit" VALUE="�o�@�^">
					<INPUT TYPE="submit" NAME="submit" VALUE="�߁@��">
				</TD>
			</TR>
		</TABLE>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>