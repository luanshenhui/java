<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �a�����  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/interviewResult.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const GRPCD_DISEASEHISTORY = "X026"	'�a���O���[�v�R�[�h

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objInterView		'�ʐڏ��A�N�Z�X�p
Dim objConsult			'��f�N���X
Dim objPerResult			'�l�������ʏ��A�N�Z�X�p
'2004/08/19 ADD STR ORB)T.YAGUCHI ���މ@���̕ύX
Dim objFolRenkei		'HainsFolRenkei�N���X
'2004/08/19 ADD END

'�p�����[�^
Dim	strWinMode			'�E�B���h�E���[�h
Dim strGrpNo			'�O���[�vNo
Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim strCsCd				'�R�[�X�R�[�h

'��������
'Dim lngGetSeqMode		'�擾�� 0:�O���[�v���\�����{���t 1:���t�{�R�[�h�{�T�t�B�b�N�X
'Dim vntPerId			'�\��ԍ�
'Dim vntCslDate			'�������ڃR�[�h
'Dim vntHisNo			'����No.
'Dim vntRsvNo			'�\��ԍ�
Dim strPerId			'�l�h�c
Dim vntItemCd			'�������ڃR�[�h
Dim vntSuffix			'�T�t�B�b�N�X
Dim vntResultType		'���ʃ^�C�v
Dim vntItemType			'���ڃ^�C�v
Dim vntItemName			'�������ږ���
Dim vntResult			'��������
Dim vntStcItemCd		'���͎Q�Ɨp���ڃR�[�h
Dim vntStcCd			'���̓R�[�h
Dim vntShortStc			'���͗���
Dim vntIspDate			'������
Dim lngRslCnt			'�������ʐ�

'�O���E���@��
Dim vntKbn				'���O�敪
Dim vntPatientDate		'���@��
Dim vntDeptName			'�Ȗ�
Dim lngPatientCnt		'����

'�a��
Dim vntInDate			'���@��
Dim vntDisName			'�a��
Dim lngDisCnt			'����

Dim i, j				'�C���f�b�N�X
Dim strBgColor			'�w�i�F
Dim vntArrDisease		'������

Dim Ret					'�֐����A�l
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objPerResult = Server.CreateObject("HainsPerResult.PerResult")
'2004/08/19 ADD STR ORB)T.YAGUCHI ���މ@���̕ύX
Set objFolRenkei = Server.CreateObject("HainsFolRenkei.FolRenkei")
'2004/08/19 ADD END

'�����l�̎擾
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")

Do
'	lngGetSeqMode = 0
	'�w��Ώێ�f�҂̌������ʂ��擾����
'	lngRslCnt = objInterView.SelectHistoryRslList( _
'						lngRsvNo, _
'						1, _
'						GRPCD_DISEASEHISTORY, _
'						0, _
'						"", _
'						lngGetSeqMode, _
'						0, _
'						0, _
'						vntPerId, _
'						vntCslDate, _
'						vntHisNo, _
'						vntRsvNo, _
'						vntItemCd, _
'						vntSuffix, _
'						vntResultType, _
'						vntItemType, _
'						vntItemName, _
'						vntResult _
'						)
	'��f��񌟍�
'    Ret = objConsult.SelectConsult(lngRsvNo, _
'                                    , _
'                                    , _
'                                    strPerId    )

    If strCsCd <> "" Then
        Ret = objConsult.SelectConsult(lngRsvNo, _
                                        , _
                                        , _
                                        strPerId    )
    Else
        Ret = objConsult.SelectConsult(lngRsvNo, _
                                        , _
                                        , _
                                        strPerId, _
                                        strCsCd     )
    End If

	'��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ���
	If Ret = False Then
		Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
	End If

	'## �l�������ʂ���擾����@2003.12.24
'### 2004/06/28 Updated by Ishihara@FSIT �l�������ʂ���ł͂Ȃ��B
'	lngRslCnt = objPerResult.SelectPerResultGrpList( strPerId, _
'														GRPCD_DISEASEHISTORY, _
'														1, 0, _
'														vntItemCd, _
'														vntSuffix, _
'														vntItemName, _
'														vntResult, _
'														vntResultType, _
'														vntItemType, _
'														vntStcItemCd, _
'														vntShortStc, _
'														vntIspDate _
'														)

'''#### 2013.02.01 �� ���������\�񂪑��݂����ꍇ�̕s��Ή��@MOD START #### **
'    lngRslCnt = objInterview.SelectHistoryRslList( _
'                        lngRsvNo, _
'                        1, _
'                        GRPCD_DISEASEHISTORY, _
'                        0, _
'                        "", _
'                        0, _
'                        , , _
'                        , , _
'                        , _
'                        , _
'                        vntItemCd, _
'                        vntSuffix, _
'                         , _
'                        vntResultType, _
'                        vntItemName, _
'                        vntShortStc _
'                        )

    lngRslCnt = objInterview.SelectHistoryRslList( _
                        lngRsvNo, _
                        1, _
                        GRPCD_DISEASEHISTORY, _
                        1, _
                        strCsCd, _
                        0, _
                        , , _
                        , , _
                        , _
                        , _
                        vntItemCd, _
                        vntSuffix, _
                         , _
                        vntResultType, _
                        vntItemName, _
                        vntShortStc _
                        )

'''#### 2013.02.01 �� ���������\�񂪑��݂����ꍇ�̕s��Ή��@MOD END   #### **


'### 2004/06/28 Updated End

	If lngRslCnt < 0 Then
		Err.Raise 1000, , "�������ʂ��擾�ł��܂���B�i�l�h�c = " & strPerId & ")"
	End If

	vntArrDisease = Array()
	ReDim vntArrDisease(2, -1)
	j = 0
	For i = 0 To (lngRslCnt/3)-1
'### 2004/06/28 Updated by Ishihara@FSIT �l�������ʂ���ł͂Ȃ��B
'		If vntResult(i*3+0) <> "" Or vntResult(i*3+1) <> "" Or  vntResult(i*3+2) <> "" Then
		If vntItemCd(i*3+0) <> "" Or vntItemCd(i*3+1) <> "" Or  vntItemCd(i*3+2) <> "" Then
'### 2004/06/28 Updated End
			ReDim Preserve vntArrDisease(2, j)
			vntArrDisease(0, j) = vntShortStc(i*3+0)	'�a��
			vntArrDisease(1, j) = vntShortStc(i*3+1)	'�늳�N��
			vntArrDisease(2, j) = vntShortStc(i*3+2)	'�������
			j = j + 1
		End If
	Next

'2004/08/19 MOD STR ORB)T.YAGUCHI ���މ@���̕ύX
'	'���@�E�O�����擾
'	lngPatientCnt = objInterView.SelectPatientHistory( _
'												lngRsvNo, _
'												vntKbn,   _
'												vntPatientDate, _
'												vntDeptName )
'
'	'�a���擾
'	lngDisCnt = objInterView.SelectDiseaseHistory( _
'												lngRsvNo, _
'												vntInDate,   _
'												vntDisName )
'
	'���@�E�O�����擾
	lngPatientCnt = objFolRenkei.SelectPatientHistory( _
												lngRsvNo, _
												vntKbn,   _
												vntPatientDate, _
												vntDeptName )
	'�a���擾
	lngDisCnt = objFolRenkei.SelectDiseaseHistory( _
												lngRsvNo, _
												vntInDate,   _
												vntDisName )
'2004/08/11 MOD END

Exit Do
Loop
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�a�����</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function openWindow() {
	alert("�n�b�q���͌��ʊm�F��ʂ��Ăяo���I");
}
//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="RslCnt"    VALUE="<%= lngRslCnt %>">

	<!-- �^�C�g���̕\�� -->
	<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
		<TR>
			<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�a�����</FONT></B></TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD VALIGN="top">
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP><B>���a���E������</B></TD>
						<TD></TD>
<!--
						<TD NOWRAP><A HREF="javascript:openWindow()">���͂���</A></TD>
-->
						<TD NOWRAP><A HREF="/webHains/contents/monshin/ocrNyuryoku.asp?rsvno=<%= lngRsvNo %>&anchor=1" TARGET="_blank">���͂���</A></TD>
					</TR>
					<TR BGCOLOR="#cccccc">
						<TD WIDTH="100" NOWRAP>�a��</TD>
						<TD ALIGN="center" NOWRAP>�N��</TD>
						<TD WIDTH="200" NOWRAP>���Ï��</TD>
					</TR>
<%
For i=0 To UBound(vntArrDisease, 2)
	If (i Mod 2) = 0 Then
		strBgColor = ""
	Else
		strBgColor = " BGCOLOR=""#eeeeee"""
	End If
%>
					<TR<%= strBgColor %>>
						<TD NOWRAP><%= IIf(vntArrDisease(0, i)="", "&nbsp;", vntArrDisease(0, i)) %></TD>
						<TD NOWRAP ALIGN="center"><%= IIf(vntArrDisease(1, i)="", "&nbsp;", vntArrDisease(1, i)) %></TD>
						<TD NOWRAP><%= IIf(vntArrDisease(2, i)="", "&nbsp;", vntArrDisease(2, i)) %></TD>
					</TR>
<%
Next
%>
				</TABLE>
			</TD>
			<TD WIDTH="10"></TD>
			<TD VALIGN="top">
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP><B>�񎟌�������</B></TD>
<TD><FONT COLOR="#dddddd" SIZE="-1"><B>��������</B></FONT></TD>
					</TR>
					<TR BGCOLOR="#cccccc">
						<TD WIDTH="100" NOWRAP>��f��</TD>
						<TD WIDTH="200" NOWRAP>��������</TD>
					</TR>
				</TABLE>
			</TD>
			<TD WIDTH="10"></TD>
			<TD VALIGN="top">
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP><B>�O���E���@��</B></TD>
					</TR>
				</TABLE>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR BGCOLOR="#cccccc">
<!-- �K�v���ۂ��������H 2003.12.22
						<TD NOWRAP>���O�敪</TD>
-->
						<TD WIDTH="100" NOWRAP>���@��</TD>
						<TD WIDTH="120" NOWRAP>��</TD>
					</TR>
<%
For i=0 To lngPatientCnt - 1
	If (i Mod 2) = 0 Then
		strBgColor = ""
	Else
		strBgColor = " BGCOLOR=""#eeeeee"""
	End If
%>
					<TR<%= strBgColor %>>
<!-- �K�v���ۂ��������H 2003.12.22
						<TD NOWRAP><%= IIf(vntKbn(i)="1", "�O��", "���@") %></TD>
-->
						<TD NOWRAP><%= vntPatientDate(i) %></TD>
						<TD NOWRAP><%= vntDeptName(i) %></TD>
					</TR>
<%
Next
%>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
		<TR>
			<TD NOWRAP><B>�a��</B></TD>
		</TR>
		<TR BGCOLOR="#cccccc">
			<TD WIDTH="100" NOWRAP>���@��</TD>
			<TD WIDTH="788" NOWRAP>�a��</TD>
		</TR>
<%
For i=0 To lngDisCnt - 1
	If (i Mod 2) = 0 Then
		strBgColor = ""
	Else
		strBgColor = " BGCOLOR=""#eeeeee"""
	End If
%>
					<TR<%= strBgColor %>>
						<TD NOWRAP><%= vntInDate(i) %></TD>
						<TD NOWRAP><%= vntDisName(i) %></TD>
					</TR>
<%
Next
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
