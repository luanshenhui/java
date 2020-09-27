<%
'-----------------------------------------------------------------------------
'	   ＣＵ経年変化（生活習慣／アイコン拡大） (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'パラメータ
Dim lngItemNo			'項目No
Dim lngIconNo			'アイコンNo

Dim strItemName			'項目名称
Dim strArrImageName		'イメージファイル群
Dim strImage			'表示するイメージ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
lngItemNo			= Request("itemno")
lngIconNo			= Request("iconno")
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>ＣＵ経年変化</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
</HEAD>
<BODY>
<%
	Select Case lngItemNo
	Case "1"
		strItemName = "飲酒"
		strArrImageName = Array( _
								"../../images/drinker0.jpg", _
								"../../images/drinker1.jpg", _
								"../../images/drinker2.jpg", _
								"../../images/drinker3.jpg" _
								)
	Case "2"
		strItemName = "喫煙"
		strArrImageName = Array( _
								"../../images/smoker0.jpg", _
								"../../images/smoker1.jpg", _
								"../../images/smoker2.jpg", _
								"../../images/smoker3.jpg" _
								)
	Case "3"
		strItemName = "運動"
		strArrImageName = Array( _
								"../../images/sports0.jpg", _
								"../../images/sports1.jpg", _
								"../../images/sports2.jpg", _
								"../../images/sports3.jpg" _
								)
	Case "4"
'### 2004/3/4 Updated by Ishihara@FSIT 名称が誤っている
'		strItemName = "生活"
		strItemName = "Ａ型行動"
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
