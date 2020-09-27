<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		請求締め処理 (Ver0.0.1)
'		AUTHER  : Miyuki Gouda@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->

<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'引数値
Dim strAction				'処理状態（確定ボタン押下時:"submit"，締め処理起動完了後:"submitend"）
Dim lngCloseYear			'締め日(年)
Dim lngCloseMonth			'締め日(月)
Dim lngCloseDay				'締め日(日)
Dim strLoginId				'ログインID

'COMオブジェクト
Dim objHainsUser			'ユーザアクセス用COMオブジェクト
Dim objFree					'締め日用COMオブジェクト

'指定条件
Const strKey = "DAILYCLS"	'汎用テーブルのキー
Dim strCloseDate			'締め日
Dim strUserId				'ユーザID
Dim strUserName				'更新者名
Dim strUpdate				'更新日時

'入力チェック
Dim strArrMessage			'エラーメッセージ
Dim lngRet					'更新の戻り値
Dim intRet					'レコードの件数

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strAction     = Request("action") & ""
lngCloseYear  = CLng("0" & Request("closeYear"))
lngCloseMonth = CLng("0" & Request("closeMonth"))
lngCloseDay   = CLng("0" & Request("closeDay"))
strLoginId    = Session.Contents("userId")

'締め日用COMオブジェクトの割り当て
Set objFree = Server.CreateObject("HainsFree.Free") 

'初期設定
strArrMessage = Empty

Do

	'締め日レコードの有無
	intRet = objFree.GdeSelectFreeCount(strKey)
	
	'レコードが存在しない場合は処理を抜ける
	If intRet <= 0 Then
		strArrMessage = "締め日を格納するレコードが存在しません。マスタメンテナンス画面より「KEY = DAILYCLS」のレコードを作成して下さい。"
		Exit Do
	End If

	'確定ボタン押下時
	If strAction = "submit" Then

		'日次締め日の編集
		strCloseDate = lngCloseYear & "/" & lngCloseMonth & "/" & lngCloseDay
	
		'入力日付のチェック
		If Not IsDate(strCloseDate) Then
			strArrMessage = "締め日の入力形式が正しくありません。"
		Else

			'締め日・更新者・更新日時の更新
			lngRet = objFree.UpdateFree(strKey, , , strCloseDate, strLoginId, Now)

			'更新の正常・異常チェック
			If lngRet <> 0 Then
				strAction = "submitend"
			Else 
				strArrMessage = Array("日次締め処理に失敗しました。")
			End If

		End If
	
	End If

	'DBに保存されている日次締め日、更新者ID、更新日時を取得
	objFree.SelectFree 0, strKey, , , strCloseDate, strUserId, strUpdate

	'日次締め日の設定
	'引数なしの場合
	If Trim(lngCloseYear) = 0 Then
	
		'取得した日次締め日が日付として判断できた場合(NULLではない場合) 
		If IsDate(strCloseDate) = True Then 

			'締め日の設定
			lngCloseYear  = CStr(Year(strCloseDate))
			lngCloseMonth = CStr(Month(strCloseDate))
			lngCloseDay   = CStr(Day(strCloseDate))

		'締め日のレコードは存在するが、締め日がNULLの場合
		Else 

			'システム日を設定
			lngCloseYear  = Year(Now())
			lngCloseMonth = Month(Now())
			lngCloseDay   = Day(Now())

		End If
	
	End If
	
	'ユーザ名読み込み
	If Trim(strUserId) <> "" Then
		Set objHainsUser = Server.CreateObject("HainsHainsUser.HainsUser")
		objHainsUser.SelectHainsUser strUserId, strUserName
		Set objHainsUser = Nothing
	End If

	Exit Do

Loop

'締め日用COMオブジェクトの解放
Set objFree = Nothing
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>日次締め処理</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->

<SCRIPT TYPE="text/javascript">
<!--

// 確定ボタン押下時の処理
function goFinish() {

	var msg;

	msg = '';
	msg = msg + document.perentryCondition.closeYear.value + '年';
	msg = msg + document.perentryCondition.closeMonth.value + '月';
	msg = msg + document.perentryCondition.closeDay.value + '日';
	msg = msg + 'の日次締め処理を実行します。';
	
	if ( confirm(msg) ) {
		document.perentryCondition.action.value = 'submit';
		document.perentryCondition.submit();
	}

	return false;
}

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.dmdtab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="JavaScript:orgGuide_closeGuideOrg(); calGuide_closeGuideCalendar()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="perentryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="action" VALUE="">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">日次請求締め処理</FONT></B></TD>
	</TR>
</TABLE>
<%
'メッセージの編集
If strAction <> "" Then

	'更新完了時は「更新完了」の通知
	If strAction = "submitend" Then
		
		strArrMessage = "<FONT COLOR=""#ff6600""><B>日次締め処理を完了しました。</B></FONT>"
		Call EditMessage(strArrMessage, MESSAGETYPE_NORMAL)

	'エラーメッセージを編集
	Else
		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
	End If

End If
%>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
	<TR>
		<TD>締め日</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('closeYear', 'closeMonth', 'closeDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
					<TD><%= EditNumberList("closeYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCloseYear, False) %></TD>
					<TD>年</TD>
					<TD><%= EditNumberList("closeMonth", 1, 12, lngCloseMonth, False) %></TD>
					<TD>月</TD>
					<TD><%= EditNumberList("closeDay", 1, 31, lngCloseDay, False) %></TD>
					<TD>日</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD>更新者</TD>
		<TD>：</TD>
		<TD><%= strUserName %></TD>
		</TD>
	</TR>
	<TR>
		<TD>更新日時</TD>
		<TD>：</TD>
		<TD><%= strUpdate %></TD>
		</TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="500">
<TR>
	<% if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then %>
        <TD ALIGN="RIGHT"><A HREF="javascript:function voi(){};voi()" ONCLICK="return goFinish()" METHOD="post"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="日請求締め確定"></A></TD>
    <% End If %>
</TR>
</TABLE>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
