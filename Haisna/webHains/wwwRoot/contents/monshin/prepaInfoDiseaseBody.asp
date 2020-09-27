<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���f�O�����i��f�j������  (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const DISEASE_GRPCD = "X028"		'�������@�������ڃO���[�v�R�[�h

Dim objCommon				'���ʃN���X
Dim objConsult				'��f�N���X
Dim objPerResult			'�l�������ʏ��A�N�Z�X�p

'�p�����[�^
Dim lngRsvNo				'�\��ԍ�

'��f���p�ϐ�
Dim strPerId				'�lID

'�l�������ڏ��p�ϐ�
Dim vntItemCd				'�������ڃR�[�h
Dim vntSuffix				'�T�t�B�b�N�X
Dim vntItemName				'�������ږ�
Dim vntResult				'��������
Dim vntResultType			'���ʃ^�C�v
Dim vntItemType				'���ڃ^�C�v
Dim vntStcItemCd			'���͎Q�Ɨp���ڃR�[�h
Dim vntStcCd				'���̓R�[�h
Dim vntShortStc				'���͗���
Dim vntIspDate				'������

'�\���p���͑ޔ��G���A
Dim strDspName()			'�a��
Dim strDspAge()				'�늳�N��
Dim strDspStat()			'�������

Dim strColor				'�w�i�F

Dim Ret						'���A�l
Dim lngPerRslCount			'�l�������ڏ��
Dim i, j					'�J�E���^�[

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objPerResult = Server.CreateObject("HainsPerResult.PerResult")

'�����l�̎擾
lngRsvNo			= Request("rsvno")


Do

	'��f��񌟍�
	Ret = objConsult.SelectConsult(lngRsvNo, _
									, _
									, _
									strPerId    )

	'��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ���
	If Ret = False Then
		Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
	End If


	'�l�������ʏ��擾
	lngPerRslCount = objPerResult.SelectPerResultGrpList( strPerId, _
														DISEASE_GRPCD, _
														1, 0, _
														vntItemCd, _
														vntSuffix, _
														vntItemName, _
														vntResult, _
														vntResultType, _
														vntItemType, _
														vntStcItemCd, _
														vntShortStc, _
														vntIspDate _
														)
	If lngPerRslCount < 0 Then
		Err.Raise 1000, , "�l�������ʏ�񂪑��݂��܂���B�i�lID= " & strPerId & " )"
	End If

	Exit Do
Loop

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>������_2</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 5px; }
</style>
</HEAD>
<BODY>
<TABLE WIDTH="300" BORDER="0" CELLSPACING="1" CELLPADDING="0">
<%
		j = 0
		For i = 0 To lngPerRslCount - 1
			Select Case vntSuffix(i)
				'�a��
				Case "01"
					Redim Preserve strDspName(j)
					'���̓^�C�v�H
					If vntResultType(i) = 4 Then
						strDspName(j) = vntShortStc(i)
					Else
						strDspName(j) = vntResult(i)
					End If
				'�늳�N��
				Case "02"
					Redim Preserve strDspAge(j)
					'���̓^�C�v�H
					If vntResultType(i) = 4 Then
						strDspAge(j) = vntShortStc(i)
					Else
						strDspAge(j) = vntResult(i)
					End If
				'�������
				Case "03"
					Redim Preserve strDspStat(j)
					'���̓^�C�v�H
					If vntResultType(i) = 4 Then
						strDspStat(j) = vntShortStc(i)
					Else
						strDspStat(j) = vntResult(i)
					End If
					j = j + 1
				Case Else
			End Select
		Next

		For i = 0 To j - 1
			If i mod 2 = 0 Then
				strColor = ""
			Else
				strColor = "#e0ffff"
			End If
%>
			<TR HEIGHT="17">
				<TD NOWRAP BGCOLOR="<%= strColor %>" WIDTH="100" HEIGHT="17"><%= strDspName(i) %></TD>
				<TD NOWRAP BGCOLOR="<%= strColor %>" WIDTH="70" HEIGHT="17"><%= strDspAge(i) %></TD>
				<TD NOWRAP BGCOLOR="<%= strColor %>" WIDTH="100" HEIGHT="17"><%= strDspStat(i) %></TD>
			</TR>
<%
		Next
%>
		</TABLE>
	</BODY>
</HTML>