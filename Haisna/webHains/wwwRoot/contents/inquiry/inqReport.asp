<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		HTML�񍐏� (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit

'�d�J���ɖ{ASP�ō쐬����HTML�𑗐M���邽�߁A�Z�b�V�����`�F�b�N�͍s��Ȃ�
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'������
Dim strRsvNo				'�\��ԍ�

'��f���
Dim strCslDate				'��f��
Dim strCsName				'�R�[�X��
Dim strAge					'�N��
Dim strReportPrintDate		'�񍐏��o�͓�
Dim strDispCslDate			'�ҏW��f��

'���茋�ʏ��
Dim strJudClassCd			'���蕪�ރR�[�h
Dim strJudClassName			'���蕪�ޖ���
Dim strJudSName				'���薼��
Dim strStdJudNote			'��^��������
Dim strFreeJudCmt			'�t���[����R�����g
Dim strOldJudClassCd		'�ҏW�p���蕪�ރR�[�h
Dim lngJudClassRows			'���蕪�ލs��
Dim lngJudClassRowPos		'���蕪�ނ��ƍs���Z�b�g�ʒu

'��f�Ҍl���ǂݍ���
Dim strPerID				'�l�h�c
Dim strCsCd					'�R�[�X�R�[�h
Dim strLastName				'��
Dim strFirstName			'��
Dim strLastKName			'�J�i��
Dim strFirstKName			'�J�i��
Dim strBirth				'���N�����i���ҏW�j
Dim strGender				'����
Dim strGenderName			'���ʖ��́i"�j��"�C"����"�j
Dim strDayId				'����ID�i���ҏW�j
Dim blnRetCd				'���^�[���R�[�h

'��f�Ҍl���ҏW
Dim strEditCslDate			'��f���i"yyyy/mm/dd"�ҏW�j
Dim strEditBirth			'���N�����i"gee.mm.dd"�ҏW�j
Dim strEditGenderName		'���ʖ��́i"�j"�C"��"�j
Dim strEditDayId			'����ID�i"0001"�ҏW�j

Dim objConsult				'��f���A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objJudgement			'���茋�ʃA�N�Z�X�pCOM�I�u�W�F�N�g
Dim objCommon				'���ʊ֐��A�N�Z�X�pCOM�I�u�W�F�N�g

Dim lngJudCount				'���茋�ʃ��R�[�h����
Dim lngRowCount				'���蕪�ލs���i�J�E���^�j

Dim i						'�C���f�b�N�X
Dim j						'�C���f�b�N�X
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strRsvNo		   = Request("rsvNo")

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objConsult   = Server.CreateObject("HainsConsult.Consult")
Set objJudgement = Server.CreateObject("HainsJudgement.Judgement")
Set objCommon	 = Server.CreateObject("HainsCommon.Common")

'��f�Ҍl���ǂݍ���
blnRetCd = objConsult.SelectConsult(strRsvNo, 0, strCslDate, strPerId, strCsCd, strCsName, , , , , , _
									strAge, , , , , , , , , , , , , _
									strDayId, , , , , , , , , , , , , , , , , , _
									strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGender)


'��f�Ҍl����ҏW����
Set objCommon = Server.CreateObject("HainsCommon.Common")

With objCommon
	strEditCslDate = .FormatString(CDate(strCslDate), "yyyy/mm/dd")
	strEditBirth = .FormatString(CDate(strBirth), "gee.mm.dd")
End With
Set objCommon = Nothing

If Trim(strGender) = CStr(GENDER_MALE) Then
	strEditGenderName = "�j"
ElseIf Trim(strGender) = CStr(GENDER_FEMALE) Then
	strEditGenderName = "��"
Else
	strEditGenderName = strGender
End If
strEditDayId = Trim(strDayId)

If strEditDayId <> "" Then
	Do While Len(strEditDayId) < 4
		strEditDayId = "0" & strEditDayId
	Loop
End If

'��f���ǂݍ���
objConsult.SelectConsult strRsvNo, CONSULT_USED, strCslDate, , ,strCsName, , , , , , strAge, , , ,strReportPrintDate

'��f���ҏW
'strDispCslDate = objCommon.FormatString(strCslDate, "yyyy�Nmm��dd��")

'���茋�ʓǂݍ���
lngJudCount = objJudgement.SelectInquiryJudRslList(strRsvNo, strJudClassCd, strJudClassName, strJudSName, strStdJudNote, strFreeJudCmt)

'���蕪�ނ��Ƃ̍s���擾
If lngJudCount > 0 Then
	ReDim lngJudClassRows(lngJudCount - 1)
	strOldJudClassCd = ""
	For i = 0 To lngJudCount - 1
		'�ŏ��̔��蕪��
		If strOldJudClassCd = "" Then
			strOldJudClassCd = strJudClassCd(i)
			lngJudClassRowPos = 0
			lngRowCount = 0
		End If
		'���蕪�ރR�[�h���ς�����Ƃ�
		If strOldJudClassCd <> strJudClassCd(i) Then
			lngJudClassRows(lngJudClassRowPos) = lngRowCount
			strOldJudClassCd = strJudClassCd(i)
			lngJudClassRowPos = i
			lngRowCount = 0
		End If
		lngRowCount = lngRowCount + 1
	Next
	'�Ō�̔��蕪�ނ̍s�����Z�b�g
	If strOldJudClassCd <> "" Then
		lngJudClassRows(lngJudClassRowPos) = lngRowCount
	End If
End If

'�I�u�W�F�N�g�̃C���X�^���X�폜
Set objConsult		= Nothing
Set objJudgement	= Nothing
Set objCommon		= Nothing

'-----------------------------------------------------------------------------
' �������ʁ^��f���ʕҏW
'-----------------------------------------------------------------------------
Sub EditRslList

	Dim objResult				'�������ʏ��A�N�Z�X�pCOM�I�u�W�F�N�g

	Dim strItemName				'�������ږ�
	Dim strResult				'��������
	Dim strResultType			'���ʃ^�C�v
	Dim strShortStc				'������
	Dim strStdFlgColor			'��l�t���O�\���F
	Dim strRslCmtName1			'���ʃR�����g���̂P
	Dim strRslCmtName2			'���ʃR�����g���̂Q
	Dim strClassName			'��������
	Dim strEditClassName		'��������
	Dim blnBreakFlg				'

	Dim lngCount				'���R�[�h����

	Dim i						'�C���f�b�N�X

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objResult = Server.CreateObject("HainsResult.Result")

	'�������ʓǂݍ���
	lngCount = objResult.SelectInquiryRslList(strRsvNo, _
												RSLQUE_R, _
												strItemName, _
												strResult, _
												strResultType, _
												strShortStc, _
												strStdFlgColor, _
												strRslCmtName1, _
												strRslCmtName2, _
												strClassName)
%>
	<BR>
	<!-- �������� -->
	<TABLE><TR><TD HEIGHT="3"></TD></TR></TABLE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#999999">��</FONT><FONT COLOR="#333333">��������</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE><TR><TD HEIGHT="3"></TD></TR></TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR BGCOLOR="#cccccc">
			<TD WIDTH="110" ALIGN="center" NOWRAP>�������ޖ�</TD>
			<TD WIDTH="160" ALIGN="center" NOWRAP>�������ږ�</TD>
			<TD WIDTH="360" ALIGN="center" NOWRAP>��������</TD>
			<TD ALIGN="center" COLSPAN="2" NOWRAP>�R�����g</TD>
		</TR>
<% 
		strEditClassName = ""
		blnBreakFlg = False
		For i = 0 To lngCount - 1 

			'�Ђ����Ԃ�ɃR���g���[���u���C�N�Ȃǂ��E�E�E
			If i = 0 Then
				strEditClassName = strClassName(i)
			Else
				If strClassName(i) <> strClassName(i - 1) Then
					Response.Write "<TR><TD HEIGHT=""7""></TD></TR>"
					strEditClassName = strClassName(i)
				Else
					strEditClassName = ""
				End If
			End If
%>
			<TR BGCOLOR="#eeeeee">
				<TD WIDTH="110"><%= strEditClassName %></TD>
				<TD WIDTH="160"><%= strItemName(i) %></TD>
				<TD WIDTH="360"><FONT COLOR="<%= strStdFlgColor(i) %>"><% If strStdFlgColor(i) <> "" Then %><B><% End If %>
				<%= IIf(CStr(strResultType(i)) = CStr(RESULTTYPE_SENTENCE), IIf(strShortStc(i)="", "&nbsp;", strShortStc(i)), IIf(strResult(i)="", "&nbsp;", strResult(i))) %></FONT></TD>
				<TD WIDTH="65"><%= IIf(strRslCmtName1(i)="", "&nbsp;", strRslCmtName1(i)) %></TD>
				<TD WIDTH="65"><%= IIf(strRslCmtName2(i)="", "&nbsp;", strRslCmtName2(i)) %></TD>
			</TR>
<% 	
		Next
%>
	</TABLE>

<%
	'��f���ʓǂݍ���
	lngCount = objResult.SelectInquiryRslList(strRsvNo, _
												RSLQUE_Q, _
												strItemName, _
												strResult, _
												strResultType, _
												strShortStc, _
												strStdFlgColor, _
												strRslCmtName1, _
												strRslCmtName2)
%>

	<!-- ��f���� -->
	<TABLE><TR><TD HEIGHT="3"></TD></TR></TABLE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#999999">��</FONT><FONT COLOR="#333333">��f����</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE><TR><TD HEIGHT="3"></TD></TR></TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR BGCOLOR="#cccccc">
			<TD WIDTH="160" ALIGN="center" NOWRAP>��f���ږ�</TD>
			<TD WIDTH="237" ALIGN="center" NOWRAP>��f��</TD>
		</TR>
		<% For i = 0 To lngCount - 1 %>
			<TR BGCOLOR="#eeeeee">
				<TD WIDTH="160" NOWRAP><%= strItemName(i) %></TD>
				<TD WIDTH="237" NOWRAP><%= IIf(CStr(strResultType(i)) = CStr(RESULTTYPE_SENTENCE), IIf(strShortStc(i)="", "&nbsp;", strShortStc(i)), IIf(strResult(i)="", "&nbsp;", strResult(i))) %></TD>
			</TR>
		<% Next %>
	</TABLE>
<%
	'�I�u�W�F�N�g�̃C���X�^���X�폜
	Set objResult = Nothing

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>HTML Report</TITLE>
<style type="text/css">
	body { margin: 0 0 0 10px; }
</style>
</HEAD>
<BODY>
<FORM NAME="report" action="#">

<!-- �\�� -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><FONT COLOR="#6600ff">��</FONT><FONT COLOR="#000000">Report</FONT></B></TD>
	</TR>
</TABLE>


<%
	'��f�Ҍl���̕\��
	If strRsvNo <> 0 Then
%>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			<TR>
				<TD HEIGHT="10"></TD>
			</TR>
			<TR>
				<TD>
					<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
						<TR>
							<TD>��f���F</TD>
							<TD><FONT COLOR="#ff6600"><B><%= strEditCslDate %></B></FONT></TD>
							<TD WIDTH="10"></TD>
							<TD>��f�R�[�X�F</TD>
							<TD><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
							<TD WIDTH="10"></TD>
							<TD>�\��ԍ��F</TD>
							<TD><FONT COLOR="#ff6600"><B><%= strRsvNo %></B></FONT></TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
			<TR><TD HEIGHT="10"></TD></TR>
			<TR>
				<TD>
					<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
						<TR>
							<TD NOWRAP><%= strPerID %></TD>
							<TD WIDTH="5"></TD>
							<TD NOWRAP><B><%= strLastName & "�@" & strFirstName %></B> (<FONT SIZE="-1"><%= strLastKName & "�@" & strFirstKName %></FONT>)</TD>
						</TR>
						<TR>
							<TD HEIGHT="5"></TD>
						</TR>
						<TR>
							<TD></TD>
							<TD></TD>
							<TD NOWRAP><%= strEditBirth %>���@<%= strAge %>�΁@<%= strEditGenderName %></TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
			<TR><TD HEIGHT="10"></TD></TR>
		</TABLE>
<%
	End If
%>

	<!-- ���茋�� -->
	<TABLE><TR><TD HEIGHT="3"></TD></TR></TABLE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#999999">��</FONT><FONT COLOR="#333333">���茋��</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE><TR><TD HEIGHT="3"></TD></TR></TABLE>

	<TABLE WIDTH="100%" BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR BGCOLOR="#cccccc">
			<TD WIDTH="80" ALIGN="center">����</TD>
			<TD ALIGN="center">����</TD>
<!--				<TD ALIGN="center">��^����</TD>-->
<!--			<TD ALIGN="center">�R�����g</TD>	-->
		</TR>
		<% For i = 0 To lngJudCount - 1 %>
			<TR BGCOLOR="#eeeeee">
				<TD NOWRAP><%= IIf(strJudClassName(i)="", "&nbsp;", strJudClassName(i)) %></TD>
				<TD NOWRAP><%= IIf(strJudSName(i)="", "&nbsp;", strJudSName(i)) %></TD>
<!--				<TD NOWRAP><%= IIf(strFreeJudCmt(i)="", "&nbsp;", strFreeJudCmt(i)) %></TD>-->
			</TR>
		<% Next %>
	</TABLE>

<% '�������ʁ^��f���ʕҏW %>
<% Call EditRslList %>
</FORM>
</BODY>
</HTML>
