<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���ʎQ�Ɓ@�o�N�ω� (Ver0.0.1)
'	   AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editGrpList.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
If Request("mode") = "1" Then
	Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_BUSINESS_TOP)
Else
	Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)
End If

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Dim strAction				'�������(�\���{�^��������:"select")
Dim strPerID				'�l�h�c
Dim strGrpCd				'�����O���[�v�R�[�h
Dim lngCslYear				'��f��(�N)
Dim lngCslMonth				'��f��(��)
Dim lngCslDay				'��f��(��)
Dim strHisCount				'�\����

'�\���F
Dim strH_Color				'��l�t���O�F�i�g�j
Dim strU_Color				'��l�t���O�F�i�t�j
Dim strD_Color				'��l�t���O�F�i�c�j
Dim strL_Color				'��l�t���O�F�i�k�j
Dim strT1_Color				'��l�t���O�F�i���j
Dim strT2_Color				'��l�t���O�F�i���j

Dim objCommon				'���ʊ֐��A�N�Z�X�pCOM�I�u�W�F�N�g

Const STDFLG_H = "H"		'�ُ�i��j
Const STDFLG_U = "U"		'�y�x�ُ�i��j
Const STDFLG_D = "D"		'�y�x�ُ�i���j
Const STDFLG_L = "L"		'�ُ�i���j
Const STDFLG_T1 = "*"		'�萫�l�ُ�
Const STDFLG_T2 = "@"		'�萫�l�y�x�ُ�

Const STDFLG_MARK_HU = "��"	'��l�t���O "H","U" �\���p�L��
Const STDFLG_MARK_DL = "��"	'��l�t���O "D","L" �\���p�L��
Const STDFLG_MARK_T  = "��"	'��l�t���O "@","*" �\���p�L��

Dim lngConsultCount			'��f������
Dim lngGrpCount				'�O���[�v���������ڌ���
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strAction   = Request("act")
strPerID    = Request("perID")
strGrpCd    = Request("grpCd")
lngCslYear  = CLng("0" & Request("cslYear") )
lngCslMonth = CLng("0" & Request("cslMonth"))
lngCslDay   = CLng("0" & Request("cslDay")  )
strHisCount = Request("hisCount")

'��f���̃f�t�H���g�l�ݒ�
lngCslYear  = IIf(lngCslYear  = 0, Year(Date()),  lngCslYear )
lngCslMonth = IIf(lngCslMonth = 0, Month(Date()), lngCslMonth)
lngCslDay   = IIf(lngCslDay   = 0, Day(Date()),   lngCslDay  )

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon = Server.CreateObject("HainsCommon.Common")

'�K��̕\����
If IsEmpty(strHisCount) Then
	strHisCount = objCommon.SelectInqHistoryCount()
End If

'��l�t���O�F�擾
Call objCommon.SelectStdFlgColor("H_COLOR", strH_Color)
Call objCommon.SelectStdFlgColor("U_COLOR", strU_Color)
Call objCommon.SelectStdFlgColor("D_COLOR", strD_Color)
Call objCommon.SelectStdFlgColor("L_COLOR", strL_Color)
Call objCommon.SelectStdFlgColor("*_COLOR", strT1_Color)
Call objCommon.SelectStdFlgColor("@_COLOR", strT2_Color)

'�I�u�W�F�N�g�̃C���X�^���X�폜
Set objCommon = Nothing

'-----------------------------------------------------------------------------
' �\���𐔃h���b�v�_�E���ҏW
'-----------------------------------------------------------------------------
Function EditHisCountList(strName, strSelectedHisCount)

	Dim strHisCount		'�\����
	Dim strHisCountName	'�\���𐔖���

	Dim lngCount		'����

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'�\���𐔏��̓ǂݍ���
	lngCount = objCommon.SelectInqHistoryCountList(strHisCount, strHisCountName)

	If lngCount > 0 Then
		'�h���b�v�_�E�����X�g�̕ҏW
		EditHisCountList = EditDropDownListFromArray(strName, strHisCount, strHisCountName, strSelectedHisCount, NON_SELECTED_DEL)
	End If

	'�I�u�W�F�N�g�̃C���X�^���X�폜
	Set objCommon = Nothing

End Function

'-----------------------------------------------------------------------------
' �������ʕҏW
'-----------------------------------------------------------------------------
Sub EditRslHistory()

	Dim objConsult			'��f���A�N�Z�X�pCOM�I�u�W�F�N�g
	Dim objGrp				'�������ڏ��A�N�Z�X�pCOM�I�u�W�F�N�g
	Dim objResult			'�������ʏ��A�N�Z�X�pCOM�I�u�W�F�N�g

	Dim strKeyCslDate		'��f��
	
	'��f�����
	Dim strRsvNo			'�\��ԍ�
	Dim strCslDate			'��f��
	Dim strCsName			'�R�[�X��

	'�������ڏ��
	Dim strItemCd			'�������ڃR�[�h
	Dim strSuffix			'�T�t�B�b�N�X
	Dim strItemName			'�������ږ���

	'�������ʏ��
	Dim strRslItemCd		'�������ڃR�[�h
	Dim strRslSuffix		'�T�t�B�b�N�X
	Dim strRslRsvNo			'�\��ԍ�
	Dim strResult			'��������
	Dim strStdFlg			'��l�\���F

	Dim strDispResult		'�ҏW�p��������
	Dim strDispStdFlg		'�ҏW�p��l�t���O
	Dim strDispStdFlgColor	'�ҏW�p��l�\���F
	Dim strDispStdFlgMark	'�ҏW�p��l�t���O�L��

	Dim lngHisCount			'�擾��
	Dim lngRslCount			'�������ʌ���

	Dim i					'�C���f�b�N�X
	Dim j					'�C���f�b�N�X
	Dim k					'�C���f�b�N�X

	'�����\�����͉������Ȃ�
	If strAction = "" Then
		Exit Sub
	End If
	
	'�����O���[�v���w�肳��ĂȂ��ꍇ�������Ȃ�
	If strGrpCd = "" Then
		Exit Sub
	End If

	strKeyCslDate = lngCslYear & "/" & lngCslMonth & "/" & lngCslDay

	If Not IsDate(strKeyCslDate) Then
%>
		<BR>��f���̌`���Ɍ�肪����܂��B
<%
		Exit Sub
	End If

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objConsult = Server.CreateObject("HainsConsult.Consult")
	Set objGrp    = Server.CreateObject("HainsGrp.Grp")
	Set objResult  = Server.CreateObject("HainsResult.Result")

	'�擾�𐔂̐ݒ�
	If IsNumeric(strHisCount) Then
		lngHisCount = CLng(strHisCount)
	End If

	'��f��ǎ擾
	lngConsultCount = objConsult.SelectConsultHistory(strPerID, strKeyCslDate, , , lngHisCount, strRsvNo, strCslDate, , strCsName)

	'�O���[�v���������ڎ擾
	lngGrpCount = objGrp.SelectGrpItem_cList(strGrpCd, strItemCd, strSuffix, strItemName)

	'��f�������݂��Ȃ�
	If lngConsultCount = 0 Then
%>
		<BR>���̎�f�҂̎�f���͑��݂��܂���B
<%
		'�I�u�W�F�N�g�̃C���X�^���X�폜
		Set objConsult = Nothing
		Set objGrp    = Nothing
		Set objResult  = Nothing

		Exit Sub
	End If

	'�������ʂ����݂��Ȃ�
	If lngGrpCount = 0 Then
%>
		<BR>���̃O���[�v�̌����͎�f���Ă��܂���B
<%
		'�I�u�W�F�N�g�̃C���X�^���X�폜
		Set objConsult = Nothing
		Set objGrp    = Nothing
		Set objResult  = Nothing

		Exit Sub
	End If

	'�������ʎ擾
	lngRslCount = objResult.SelectInqHistoryRslList(strPerID, strKeyCslDate, strHisCount, strGrpCd, strRslRsvno, strRslItemCd, strRslSuffix, strResult, strStdFlg)
%>
	<BR>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" class="mensetsu-tb">
		<TR ALIGN="center" BGCOLOR="#E6E6E6">
			<TD ROWSPAN="2" ALIGN="center">��������</TD>
<%
			For i = 0 To lngConsultCount - 1
%>
				<TD><A HREF="/webHains/contents/inquiry/inqReport.asp?rsvNo=<%= strRsvNo(i) %>" target="detail"><%= strCslDate(i) %></A></TD>
<%
			Next
%>
		</TR>
		<TR ALIGN="center" BGCOLOR="#e6e6e6">
<%
			For i = 0 To lngConsultCount - 1
%>
				<TD><%= strCsName(i) %></TD>
<%
			Next
%>
		</TR>
<%
		'�������ڐ����[�v
		For i = 0 To lngGrpCount - 1
%>
			<TR>
				<TD NOWRAP><%= strItemName(i) %></TD>
<%
				'�\���𐔃��[�v
				For j = 0 To lngConsultCount - 1

					strDispResult = ""
					strDispStdFlg = ""

					'�������ʐ����[�v
					For k = 0 To lngRslCount - 1
						If strRslItemCd(k) = strItemCd(i) And strRslSuffix(k) = strSuffix(i) And strRslRsvNo(k)  = strRsvNo(j) Then
							strDispResult = strResult(k)
							strDispStdFlg = strStdFlg(k)
							Exit For
						End If
					Next

					'��l�t���O�ɂ��F��ݒ肷��
					Select Case strDispStdFlg
						Case STDFLG_H
							strDispStdFlgColor = strH_Color
							strDispStdFlgMark  = STDFLG_MARK_HU
						Case STDFLG_U
							strDispStdFlgColor = strU_Color
							strDispStdFlgMark  = STDFLG_MARK_HU
						Case STDFLG_D
							strDispStdFlgColor = strD_Color
							strDispStdFlgMark  = STDFLG_MARK_DL
						Case STDFLG_L
							strDispStdFlgColor = strL_Color
							strDispStdFlgMark  = STDFLG_MARK_DL
						Case STDFLG_T1
							strDispStdFlgColor = strT1_Color
							strDispStdFlgMark  = STDFLG_MARK_T
						Case STDFLG_T2
							strDispStdFlgColor = strT2_Color
							strDispStdFlgMark  = STDFLG_MARK_T
						Case Else
							strDispStdFlgColor = "#000000"
							strDispStdFlgMark  = "�@"
					End Select

					If strDispResult = "" Then
						strDispResult = "&nbsp;"
					End If
%>
					<TD>
						<span style="color:<%= strDispStdFlgColor %>"><%= strDispResult %></span>
						<span style="color:<%= strDispStdFlgColor %>"><%= strDispStdFlgMark %></span>
					</TD>
<%
				Next
%>
			</TR>
<%
		Next
%>
	</TABLE>
<%
	'�I�u�W�F�N�g�̃C���X�^���X�폜
	Set objConsult = Nothing
	Set objGrp    = Nothing
	Set objResult  = Nothing

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�o�N�ω�</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/mensetsutable.css">
<style type="text/css">
	body { margin: 0 0 0 10px; }
	table.mensetsu-tb td.noborder { border:none;}
</style>
</HEAD>
<BODY>
<FORM NAME="history" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<DIV ALIGN="left">
<INPUT TYPE="hidden" NAME="act" VALUE="select">
<INPUT TYPE="hidden" NAME="perID" VALUE="<%= strPerID %>">
<INPUT TYPE="hidden" NAME="mode" VALUE="<%= Request("mode") %>">
<!-- �\�� -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="inquiry">��</SPAN><FONT COLOR="#000000">�o�N�ω�</FONT></B></TD>
	</TR>
</TABLE>
<BR>

<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR>
		<TD>�������ڃO���[�v�F</TD>
		<TD><%= EditGrpIList_GrpDiv("grpCd", strGrpCd, "", "", ADD_FIRST) %></TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR>
		<TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear', 'cslMonth', 'cslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
		<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
		<TD>�N</TD>
		<TD><%= EditNumberList("cslMonth", 1, 12, lngCslMonth, False) %></TD>
		<TD>��</TD>
		<TD><%= EditNumberList("cslDay", 1, 31, lngCslDay, False) %></TD>
		<TD>��</TD>
		<TD>����ߋ�</TD>
		<TD><%= EditHisCountList("hisCount", strHisCount) %></TD>
		<TD>���܂�</TD>
		<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="document.history.submit();return false"><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�w�茎����\��"></A></TD>
	</TR>
</TABLE>

<!-- �������ʕҏW -->
<% Call EditRslHistory() %>
<BR>
<% If strAction <> "" And lngConsultCount > 0 And lngGrpCount > 0 Then %>
	<FONT COLOR="<%= strH_Color%>"><%= STDFLG_MARK_HU %></FONT>:�ُ�(��) <FONT COLOR="<%= strU_Color %>"><%= STDFLG_MARK_HU %></FONT>:�y�x�ُ�(��) <FONT COLOR="<%= strD_Color %>"><%= STDFLG_MARK_DL %></FONT>:�y�x�ُ�(��) <FONT COLOR="<%= strL_Color %>"><%= STDFLG_MARK_DL %></FONT>:�ُ�(��) <FONT COLOR="<%= strT1_Color %>"><%= STDFLG_MARK_T %></FONT>:�萫�l�ُ� <FONT COLOR="<%= strT2_Color %>"><%= STDFLG_MARK_T %></FONT>:�萫�l�y�x�ُ�<BR>
<% End If %>
<BR><BR>
</DIV>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>