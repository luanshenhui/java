<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���ڃK�C�h(���X�g��) (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MODE_R        = 1			'��˗����[�h�
Const MODE_I        = 2			'����ʃ��[�h�
Const TABLEDIV_I    = 1			'��������ڣ
Const TABLEDIV_G    = 2			'��O���[�v�
Const SELECT_ALL    = "���ׂ�"	'�I������������ׂģ
Const SELECT_OTHERS = "���̑�"	'�I������������̑��

Const DATADIV_P     = "P"		'���ڕ��ޢ�˗����ڣ
Const DATADIV_C     = "C"		'���ڕ��ޢ�������ڣ
Const DATADIV_G     = "G"		'���ڕ��ޢ�O���[�v�

Const ROWCOUNT      = 2			'���ڕ\���񐔁@�Q��

Dim objItem						'���ڃK�C�h�A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objGrp						'���ڃK�C�h�A�N�Z�X�pCOM�I�u�W�F�N�g

Dim strArrItemCd				'���ڃR�[�h
Dim strArrSuffix				'�T�t�B�b�N�X
Dim strArrItemName				'���ږ���
Dim strArrResultType			'���ʃ^�C�v
Dim strArrItemType				'���ڃ^�C�v

Dim lngMode						'�˗��^���ʃ��[�h�@1:�˗��A2:����
Dim lngQuestion					'��f���ڕ\���L���@0:�\�����Ȃ��A1:�\������
Dim lngTableDiv					'�e�[�u���I���敪�@1:�������ځA�@2:�O���[�v�@(0:�f�t�H���g�l)
Dim strClassCd					'��������R�[�h
Dim strClassName				'�������얼
Dim strSearchChar				'�����p�擪������

Dim strDataDiv					'���ڕ���

Dim strDispClassName			'�\���p�I�𕪖�
Dim strDispSearchChar			'�\���p�擪����
Dim strHTML						'HTML������
Dim lngCount					'���R�[�h����
Dim i							'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objItem = Server.CreateObject("HainsItem.Item")
Set objGrp  = Server.CreateObject("HainsGrp.Grp")

'�����l�̎擾
lngMode       = CLng(Request("mode"    ))
lngQuestion   = CLng(Request("question"))
lngTableDiv   = CLng(Request("tableDiv"))
strClassCd    = Request("classCd"   ) & ""
strClassName  = Request("className" ) & ""
strSearchChar = Request("searchChar") & ""

'���R�[�h����������
lngCount = 0

'���������\�����̂̕ҏW(�I�𕪖�)
Select Case strClassCd
	Case ""				'���ׂ�
		strDispClassName = SELECT_ALL
	Case Else			'�w��̑I�𕪖�
		strDispClassName = strClassName
End Select

'���������\�����̂̕ҏW(�擪����)
Select Case strSearchChar
	Case ""				'���ׂ�
		strDispSearchChar = SELECT_ALL
	Case "*"			'���̑�
		strDispSearchChar = SELECT_OTHERS
	Case Else			'�w��̐擪����
		strDispSearchChar = strSearchChar
End Select

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���ڃK�C�h</TITLE>
</HEAD>

<BODY>

<FORM NAME="entryform" ACTION="">
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
		<TR>
			<TD><SPAN STYLE="font-size:9pt;font-weight:bolder">��������</SPAN></TD>
		</TR>
		<TR>
			<TD>
				<SPAN STYLE="font-size:9pt;">�I�𕪖�F<FONT COLOR="#FF6600"><B><%= strDispClassName %></B></FONT></SPAN>&nbsp;
				<SPAN STYLE="font-size:9pt;">�擪�����F<FONT COLOR="#FF6600"><B><%= strDispSearchChar %></B></FONT></SPAN>
			</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%" STYLE="font-size:13px;">
		<TD></TD>
		<TD WIDTH="50%"></TD>
		<TD></TD>
		<TD WIDTH="50%"></TD>
<%
	Do
		'���ڃR�[�h�A���̂̒��o
		Select Case lngTableDiv 

			'�������ڑI����
			Case TABLEDIV_I

				'��˗����[�h�
				If lngMode = MODE_R Then

					'���ڕ��ޢ�˗����ڣ
					strDataDiv = DATADIV_P
					lngCount = objItem.SelectItem_pList(strClassCd, strSearchChar, ITEM_NOTDISP, strArrItemCd, strArrSuffix, strArrItemName)

				'����ʃ��[�h�
				ElseIf lngMode = MODE_I Then

					'���ڕ��ޢ�������ڣ
					strDataDiv = DATADIV_C
					lngCount = objItem.SelectItem_cList(strClassCd, strSearchChar, lngQuestion, strArrItemCd, strArrSuffix, strArrItemName, , strArrResultType, , , strArrItemType)

				'���[�h���I���ł��Ȃ���Ή������Ȃ�
				Else
					Exit Do
				End If

			'�O���[�v�I����
			Case TABLEDIV_G

				'���ڕ��ޢ�O���[�v�
				strDataDiv = DATADIV_G

				'��˗����[�h�
				If lngMode = MODE_R Then
'### 2003.02.17 Updated by Ishihara@FSIT �V�X�e���O���[�v�͔�\��
'					lngCount = objGrp.SelectGrp_pList(GRPDIV_R, strClassCd, strSearchChar, strArrItemCd, strArrSuffix, strArrItemName)
					lngCount = objGrp.SelectGrp_pList(GRPDIV_R, strClassCd, strSearchChar, strArrItemCd, strArrSuffix, strArrItemName, True)

				'����ʃ��[�h�
				ElseIf lngMode = MODE_I Then
'### 2003.02.17 Updated by Ishihara@FSIT �V�X�e���O���[�v�͔�\��
'					lngCount = objGrp.SelectGrp_pList(GRPDIV_I, strClassCd, strSearchChar, strArrItemCd, strArrSuffix, strArrItemName)
					lngCount = objGrp.SelectGrp_pList(GRPDIV_I, strClassCd, strSearchChar, strArrItemCd, strArrSuffix, strArrItemName, True)

				'���[�h���I���ł��Ȃ���Ή������Ȃ�
				Else
					Exit Do
				End If

			'�������ځ^�O���[�v���I������Ă��Ȃ���Ή������Ȃ�
			Case Else
				Exit Do

		End Select

		'�Y�����ڂ��Ȃ��ꍇ�\�����Ȃ�
		If lngCount = 0 Then
			Exit Do
		End If

		'�������ރe�[�u���̕ҏW
		For i = 0 To lngCount - 1

			strHTML = ""

			'���[�񏈗�
			If (i mod ROWCOUNT) = 0 Then
%>
				<TR>
<%
			End If

			'�������ڂ̌��ʃ��[�h�̏ꍇ�̂݌��ʃ^�C�v�E���ڃ^�C�v��ҏW
			If lngTableDiv = TABLEDIV_I And lngMode = MODE_I Then
%>
				<TD><INPUT TYPE="checkbox" NAME="rinam" VALUE="<%= strArrItemCd(i) & "," & strArrSuffix(i) & "," & strDataDiv & "," & strArrItemName(i) & "," & strArrResultType(i) & "," & strArrItemType(i) %>" ONCLICK="top.controlSelectedItem(this)"></TD>
<%
			Else
%>
				<TD><INPUT TYPE="checkbox" NAME="rinam" VALUE="<%= strArrItemCd(i) & "," & strArrSuffix(i) & "," & strDataDiv & "," & strArrItemName(i) & ",," %>" ONCLICK="top.controlSelectedItem(this)"></TD>
<%
			End If
%>
			<TD NOWRAP><%= strArrItemCd(i) & " " & strArrSuffix(i) & " " & strArrItemName(i) %></TD>
<%
			'�E�[�񏈗�
			If (i mod ROWCOUNT) = ROWCOUNT - 1 Then
%>
				</TR>
<%
			End If

		Next

		'�[���񏈗�
		If ((lngCount - 1) mod ROWCOUNT) < ROWCOUNT - 1 Then
%>
			</TR>
<%
		End If

		Exit Do
	Loop
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
