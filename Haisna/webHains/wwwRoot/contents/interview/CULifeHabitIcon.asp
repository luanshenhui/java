<%
'-----------------------------------------------------------------------------
'	   �b�t�o�N�ω��i�����K���^�A�C�R���g��j (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�p�����[�^
Dim lngItemNo			'����No
Dim lngIconNo			'�A�C�R��No

Dim strItemName			'���ږ���
Dim strArrImageName		'�C���[�W�t�@�C���Q
Dim strImage			'�\������C���[�W

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
lngItemNo			= Request("itemno")
lngIconNo			= Request("iconno")
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�b�t�o�N�ω�</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
</HEAD>
<BODY>
<%
	Select Case lngItemNo
	Case "1"
		strItemName = "����"
		strArrImageName = Array( _
								"../../images/drinker0.jpg", _
								"../../images/drinker1.jpg", _
								"../../images/drinker2.jpg", _
								"../../images/drinker3.jpg" _
								)
	Case "2"
		strItemName = "�i��"
		strArrImageName = Array( _
								"../../images/smoker0.jpg", _
								"../../images/smoker1.jpg", _
								"../../images/smoker2.jpg", _
								"../../images/smoker3.jpg" _
								)
	Case "3"
		strItemName = "�^��"
		strArrImageName = Array( _
								"../../images/sports0.jpg", _
								"../../images/sports1.jpg", _
								"../../images/sports2.jpg", _
								"../../images/sports3.jpg" _
								)
	Case "4"
'### 2004/3/4 Updated by Ishihara@FSIT ���̂�����Ă���
'		strItemName = "����"
		strItemName = "�`�^�s��"
		strArrImageName = Array( _
								"../../images/life0.jpg",_
								"../../images/life1.jpg", _
								"../../images/life2.jpg", _
								"../../images/life3.jpg" _
								)
	End Select

	strImage = ""

	Select Case lngIconNo
	Case "0","1","2","3"
		strImage = strArrImageName(lngIconNo)
	End Select
	If strImage <> "" Then
%>
		<IMG SRC="<%=strImage%>" ALT="" HEIGHT="300" WIDTH="300">
<%
	End If
%>
</BODY>
</HTML>
