<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �ύX�����i�w�b�_�j (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"    -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objInterView		'�ʐڏ��A�N�Z�X�p

'�p�����[�^
Dim	strWinMode			'�E�B���h�E���[�h
Dim strAct				'�������
Dim lngRsvNo			'�\��ԍ�
Dim strFromDate			'�X�V���i�J�n�j
Dim strFromYear			'�X�V���@�N�i�J�n�j
Dim strFromMonth		'�X�V���@���i�J�n�j
Dim strFromDay			'�X�V���@���i�J�n�j
Dim strToDate			'�X�V���i�J�n�j
Dim strToYear			'�X�V���@�N�i�J�n�j
Dim strToMonth			'�X�V���@���i�J�n�j
Dim strToDay			'�X�V���@���i�J�n�j
Dim strUpdUser			'�X�V��
Dim strClass			'�X�V����
Dim lngOrderbyItem		'���בւ�����(0:�X�V��,1:�X�V��,2:���ށE���ځj
Dim lngOrderbyMode      '���בւ����@(0:����,1:�~��)
Dim lngStartPos				'�\���J�n�ʒu
Dim lngPageMaxLine			'�P�y�[�W�\���l�`�w�s

Dim vntUpdDate            '�X�V����
Dim vntUpdUser            '�X�V��
Dim vntUpdUserName        '�X�V�Ҏ���
Dim vntUpdClass           '�X�V����
Dim vntUpdDiv             '�����敪
Dim vntRsvNo              '�\��ԍ�
Dim vntRsvDate            '�\���
Dim vntItemCd             '�X�V���ڃR�[�h
Dim vntSuffix             '�T�t�B�b�N�X
Dim vntItemName           '�X�V���ږ���
Dim vntJudClassCd         '���蕪�ރR�[�h
Dim vntJudClassName       '���蕪�ޖ���
Dim vntBeforeResult       '�X�V�O�l
Dim vntAfterResult        '�X�V��l

Dim strUpdClassName			'�X�V���ޖ���
Dim strItemName				'���ږ���
Dim strUpdDivName			'�����敪����

Dim lngCount				'�S����

Dim strURL					'�W�����v���URL

Dim i						'���[�v�J�E���^

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'�����l�̎擾
strAct              = Request("action")
strWinMode			= Request("winmode")
lngRsvNo            = Request("rsvno")
strFromDate         = Request("fromDate")
strFromYear         = Request("fromyear")
strFromMonth        = Request("frommonth")
strFromDay          = Request("fromday")
strToDate           = Request("toDate")
strToYear           = Request("toyear")
strToMonth          = Request("tomonth")
strToDay            = Request("today")
strUpdUser          = Request("upduser")
strClass            = Request("updclass")
lngOrderbyItem      = Request("orderbyItem")
lngOrderbyMode      = Request("orderbyMode")
lngStartPos         = Request("startPos")
lngPageMaxLine      = Request("pageMaxLine")

lngStartPos = IIf(lngStartPos = "" , 1, lngStartPos ) 
lngPageMaxLine = IIf(lngPageMaxLine = "" , 0, lngPageMaxLine ) 

Do	

	If strAct <> "" Then
'If lngStartPos <> "1" Then
'Err.Raise 1000, , strFromDate & " " &  strToDate & " " & strUpdUser & " " & strClass & " " & lngOrderby'Item & " " & lngOrderbyMode & " " & lngStartPos & " " & lngPageMaxLine
'End If

		' ## ���������ɗ\��ԍ�(lngRsvNo)�ǉ� 2004.01.07
		lngCount = objInterview.SelectUpdateLogList( _
        				strFromDate,       strToDate, _
        				strUpdUser & "", _
        				strClass, _
        				lngOrderbyItem,    lngOrderbyMode, _
        				lngStartPos,       lngPageMaxLine, _
						lngRsvNo, _
        				vntUpdDate, _
        				vntUpdUser,        vntUpdUserName, _
        				vntUpdClass,       vntUpdDiv, _
        				vntRsvNo,          vntRsvDate, _
        				vntItemCd,         vntSuffix, _
        				vntItemName, _
        				vntJudClassCd,     vntJudClassName, _
        				vntBeforeResult,   vntAfterResult 	)
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
<TITLE>�ύX����</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<INPUT TYPE="hidden" NAME="action" VALUE="<%= strAct %>">
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="fromDate" VALUE="<%= strFromDate %>">
	<INPUT TYPE="hidden" NAME="fromyear" VALUE="<%= strFromYear %>">
	<INPUT TYPE="hidden" NAME="frommonth" VALUE="<%= strFromMonth %>">
	<INPUT TYPE="hidden" NAME="fromday" VALUE="<%= strFromDay %>">
	<INPUT TYPE="hidden" NAME="toDate" VALUE="<%= strToDate %>">
	<INPUT TYPE="hidden" NAME="toyear" VALUE="<%= strToYear %>">
	<INPUT TYPE="hidden" NAME="tomonth" VALUE="<%= strToMonth %>">
	<INPUT TYPE="hidden" NAME="today" VALUE="<%= strToDay %>">
	<INPUT TYPE="hidden" NAME="upduser" VALUE="<%= strUpdUser %>">
	<INPUT TYPE="hidden" NAME="updclass" VALUE="<%= strClass %>">
	<INPUT TYPE="hidden" NAME="orderbyItem" VALUE="<%= lngOrderbyItem %>">
	<INPUT TYPE="hidden" NAME="orderbyMode" VALUE="<%= lngOrderbyMode %>">
	<INPUT TYPE="hidden" NAME="startPos" VALUE="<%= lngStartPos %>">
	<INPUT TYPE="hidden" NAME="pageMaxLine" VALUE="<%= lngPageMaxLine %>">
	

<%
	IF strAct <> "" Then
	If lngCount <= 0 Then
%>
		���������𖞂��������͑��݂��܂���ł����B<BR>
<%
	Else
%>
		�������ʂ� <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>������܂����B
		<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">
			<TR BGCOLOR="#cccccc">
				<TD NOWRAP>�X�V����</TD>
				<TD NOWRAP>�X�V��</TD>
				<TD NOWRAP>����</TD>
				<TD NOWRAP>���ږ���</TD>
				<TD NOWRAP>����</TD>
				<TD WIDTH="228" NOWRAP>�X�V�O</TD>
				<TD NOWRAP WIDTH="244">�X�V��</TD>
			</TR>
<%
			For i = 0 To UBound(vntUpdDate)
				'�X�V���ޖ��̃Z�b�g
				Select Case vntUpdClass(i)
					Case 1
						strUpdClassName = "���f����"
					Case 2
						strUpdClassName = "����"
					Case 3
						strUpdClassName = "�R�����g"
					Case 4
						strUpdClassName = "�l��������"
					Case Else
						strUpdClassName = "���̑�"
				End Select

				'���ږ��̃Z�b�g
				Select Case vntUpdClass(i)
					Case 1
						strItemName = vntItemName(i)
					Case 2
						strItemName = vntJudClassName(i)
					Case 3
						strItemName = IIf( vntItemName(i) = "", vntJudClassName(i), vntItemName(i) )
					Case 4
						strItemName = vntItemName(i)
					Case Else
						strItemName = vntItemName(i)
				End Select

			
				'�����敪���̃Z�b�g
				Select Case vntUpdDiv(i)
					Case "I"
						strUpdDivName = "�}��"
					Case "U"
						strUpdDivName = "�X�V"
					Case "D"
						strUpdDivName = "�폜"
				End Select

%>
				<TR VALIGN="top">
					<TD NOWRAP BGCOLOR="#eeeeee"><%= vntUpdDate(i) %></TD>
					<TD NOWRAP BGCOLOR="#eeeeee"><%= vntUpdUserNAME(i) %></TD>
					<TD NOWRAP BGCOLOR="#eeeeee"><%= strUpdClassName %></TD>
					<TD NOWRAP BGCOLOR="#eeeeee"><%= strItemName %></TD>
					<TD NOWRAP BGCOLOR="#eeeeee"><%= strUpdDivName %></TD>
					<TD NOWRAP BGCOLOR="#eeeeee" WIDTH="228"><%= vntBeforeResult(i) %></TD>
					<TD NOWRAP BGCOLOR="#eeeeee" WIDTH="244"><%= vntAfterResult(i) %></TD>
				</TR>
<%
			Next
%>
<%
			'�S���������̓y�[�W���O�i�r�Q�[�^�s�v
   	     	If lngPageMaxLine <= 0 Then
			Else
				'URL�̕ҏW
				strURL = Request.ServerVariables("SCRIPT_NAME")
				strURL = strURL & "?winmode="     & strWinMode
				strURL = strURL & "&action="      & strAct
				strURL = strURL & "&rsvno="       & lngRsvNo
				strURL = strURL & "&fromDate="    & strFromDate
				strURL = strURL & "&fromyear="    & strFromYear
				strURL = strURL & "&frommonth="   & strFromMonth
				strURL = strURL & "&fromday="     & strFromDay
				strURL = strURL & "&toDate="      & strToDate
				strURL = strURL & "&toyear="      & strToYear
				strURL = strURL & "&tomonth="     & strToMonth
				strURL = strURL & "&today="       & strToDay
				strURL = strURL & "&upduser="     & strUpdUser
				strURL = strURL & "&updclass="    & strClass
				strURL = strURL & "&orderbyItem=" & lngOrderbyItem
				strURL = strURL & "&orderbyMode=" & lngOrderbyMode
				strURL = strURL & "&pageMaxLine=" & lngPageMaxLine

				'�y�[�W���O�i�r�Q�[�^�̕ҏW
'Err.Raise 1000, , lngCount & " " &  lngStartPos & " " & lngPageMaxLine 
%>
				<%= EditPageNavi(strURL, CLng(lngCount), lngStartPos, CLng(lngPageMaxLine)) %>
<%
			End If
%>
		<BR>
<%
	End If
	End If
%>
</FORM>
</BODY>
</HTML>