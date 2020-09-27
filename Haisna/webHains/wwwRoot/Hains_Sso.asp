<%@ LANGUAGE="VBScript" %>
<%
'########################################
'管理番号：SL-UI-Y0101-003
'作成日  ：2010.06.23
'担当者  ：FJTH)KOMURO
'作成内容：シングルサインオン機能を新規作成
'########################################
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objLogin 		'ユーザーＩＤ、パスワードチェック用ＣＯＭオブジェクト

'パラメータ
Dim strCslDate		'受診日(yyyymmdd)
Dim strUserId		'利用者ID

'ユーザーＩＤ、パスワードチェック
Dim Ret     		'戻り値
Dim strUserName		'利用者漢字氏名
Dim lngAuthTblMnt	'テーブルメンテナンス権限
Dim lngAuthRsv		'予約業務権限
Dim lngAuthRsl		'結果入力業務権限
Dim lngAuthJud		'判定入力業務権限
Dim lngAuthPrn		'印刷、データ抽出業務権限
Dim lngAuthDmd		'請求業務権限
Dim lngIgnoreFlg	'予約枠無視フラグ
Dim lngDeptCd       '
Dim lngUsrGrpCd     '
Dim strDelFlg		'削除フラグ

'リダイレクト用
Dim strURL
Dim strCslYear
Dim strCslMonth
Dim strCslDay

'チェック用
Dim blnDateCheck	'パラメタ日付の有効性
Dim strMessage		'メッセージ編集用

'引数値の取得
strCslDate		= "" & Trim(Request("csldate"))
strUserId		= "" & Trim(Request("userid"))

Do

	'オブジェクトのインスタンス作成
	Set objLogin = Server.CreateObject("HainsHainsUser.HainsUser")

	'利用者情報の検索	
	Ret = objLogin.SelectHainsUser(strUserId, strUserName, , , , , , , , _
		                           lngAuthTblMnt, lngAuthRsv, lngAuthRsl, lngAuthJud, lngAuthPrn, lngAuthDmd, , , , , , , , , , _
								   lngIgnoreFlg, , , , , strDelFlg, , , , , lngDeptCd, lngUsrGrpCd)

	'利用者が存在する場合
	If Ret = True And Trim(strDelFlg) = "" Then
	
		'セッションに各種情報を格納
		Session("USERID")      = strUserId
		Session("USERNAME")    = strUserName
		Session("AUTH_TBLMNT") = lngAuthTblMnt
		Session("AUTH_RSV")    = lngAuthRsv
		Session("AUTH_RSL")    = lngAuthRsl
		Session("AUTH_JUD")    = lngAuthJud
		Session("AUTH_PRN")    = lngAuthPrn
		Session("AUTH_DMD")    = lngAuthDmd
		Session("IGNORE")      = lngIgnoreFlg
		Session("DEPTCD")      = lngDeptCd
		Session("USRGRPCD")    = lngUsrGrpCd
	
		'表示日付を設定
		If strCslDate <> "" And Len(strCslDate) = 10 Then
		
			strCslYear  = Left(strCslDate, 4)
			strCslMonth = Mid(strCslDate, 6, 2)
			strCslDay   = Right(strCslDate, 2)

			'日付が有効化をチェック
			If IsDate(strCslYear & "/" & strCslMonth & "/" & strCslDay) = True Then
			
				blnDateCheck = True
			
			End If
		
		End If

		'日付が有効でない場合、システム日付を設定する
		If blnDateCheck <> True Then

			strCslYear = Right("00" & Year(Now()), 4)
			strCslMonth = Right("0" & Month(Now()), 2)
			strCslDay = Right("0" & Day(Now()), 2)

		End If

		'ターゲットページ＆パラメタの設定
		strURL = Application("STARTPAGE")
		strURL = strURL & "?cslYear="  & strCslYear
		strURL = strURL & "&cslMonth=" & strCslMonth
		strURL = strURL & "&cslDay="   & strCslDay

		'ターゲット先のページへ
		Response.Redirect strURL

	End If

	Exit Do

Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>健診システム起動</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- タイトルの表示 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">健診システム起動</FONT></B></TD>
		</TR>
	</TABLE>
<%
	If Ret <> True Then

		strMessage = "利用者情報が健診システムに登録されていません。"

	ElseIf Trim(strDelFlg) <> "" Then

		strMessage = "利用者情報は健診システムでは利用不可になっています。"

	End If

	If strMessage <> "" Then

		EditMessage strMessage, MESSAGETYPE_WARNING

	End If
%>
	<BR>
</FORM>
</BODY>
</HTML>
