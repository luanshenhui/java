<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		個人就労情報の登録 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'定数の定義
Const MODE_INSERT           = "insert"	'処理モード(挿入)
Const MODE_UPDATE           = "update"	'処理モード(更新)
Const ACTMODE_SAVE          = "save"	'動作モード(保存)
Const ACTMODE_DELETE        = "delete"	'動作モード(削除)
Const LENGTH_NIGHTWORKCOUNT = 2			'項目長(夜業回数)
Const LENGTH_OVERTIMEINT    = 3			'項目長(時間外就労時間(整数部))
Const LENGTH_OVERTIMEDEC    = 1			'項目長(時間外就労時間(小数部))

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objPerson			'個人情報アクセス用
Dim objPerWorkInfo		'個人就労情報アクセス用

'引数部
Dim strMode				'処理モード
Dim strActMode			'動作モード(保存:"save"、保存完了:"saved")
Dim strPerId			'個人ＩＤ
Dim lngDataYear			'データ年
Dim lngDataMonth		'データ月
Dim strNightWorkCount	'夜業回数
Dim strOverTimeInt		'時間外就労時間(整数部)
Dim strOverTimeDec		'時間外就労時間(小数部)

'個人情報
Dim strLastName			'姓
Dim strFirstName		'名
Dim strLastKName		'カナ姓	
Dim strFirstKName		'カナ名
Dim strBirth			'生年月日
Dim strAge				'年齢
Dim strGender			'性別
Dim strGenderName		'性別名称

Dim dtmDataDate			'データ年月
Dim lngNightWorkCount	'夜業回数
Dim dblOverTime			'時間外就労時間
Dim strArrMessage		'エラーメッセージ
Dim strHTML				'HTML文字列
Dim i					'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon      = Server.CreateObject("HainsCommon.Common")
Set objPerWorkInfo = Server.CreateObject("HainsPerWorkInfo.PerWorkInfo")

'引数値の取得
strMode           = Request("mode")
strActMode        = Request("actMode")
strPerId          = Request("perId")
lngDataYear       = CLng("0" & Request("dataYear"))
lngDataMonth      = CLng("0" & Request("dataMonth"))
strNightWorkCount = Request("nightWorkCount")
strOverTimeInt    = Request("overTimeInt")
strOverTimeDec    = Request("overTimeDec")

'デフォルト値の設定
lngDataYear  = IIf(lngDataYear  = 0, Year(Date),  lngDataYear )
lngDataMonth = IIf(lngDataMonth = 0, Month(Date), lngDataMonth)

'チェック・更新・読み込み処理の制御
Do

	'削除時の処理
	If strActMode = ACTMODE_DELETE Then

		'データ年月の設定
		dtmDataDate = lngDataYear & "/" & lngDataMonth & "/1"

		'個人就労情報テーブルレコード削除
		objPerWorkInfo.DeletePerWorkInfo strPerId, dtmDataDate

		'エラーがなければ呼び元画面をリロードして自身を閉じる
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
		strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
		strHTML = strHTML & "</BODY>"
		strHTML = strHTML & "</HTML>"
		Response.Write strHTML
		Response.End

	End If

	'保存時の処理
	If strActMode = ACTMODE_SAVE Then

		'入力チェック
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'データ年月の設定
		dtmDataDate = lngDataYear & "/" & lngDataMonth & "/1"

		'挿入モードの場合
		If strMode = MODE_INSERT Then

			'個人就労情報テーブルレコードを読み込み、レコードが存在すればエラー
			If objPerWorkInfo.SelectPerWorkInfo(strPerId, dtmDataDate) = True Then
				strArrMessage = Array("同一データ年月の個人就労情報がすでに存在します。")
				Exit Do
			End If

		End If

		'登録値の設定
		If strNightWorkCount <> "" Then
			lngNightWorkCount = CLng(strNightWorkCount)
		End If
		If strOverTimeInt <> "" Or strOverTimeDec <> "" Then
			dblOverTime = CDbl(strOverTimeInt & "." & strOverTimeDec)
		End If

		'個人就労情報テーブルレコード登録
		objPerWorkInfo.RegistPerWorkInfo strPerId, dtmDataDate, lngNightWorkCount, dblOverTime

		'エラーがなければ呼び元画面をリロードして自身を閉じる
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
		strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
		strHTML = strHTML & "</BODY>"
		strHTML = strHTML & "</HTML>"
		Response.Write strHTML
		Response.End

	End If

	'新規の場合は読み込みを行わない
	If strMode = MODE_INSERT Then
		Exit Do
	End If

	'データ年月の設定
	dtmDataDate = lngDataYear & "/" & lngDataMonth & "/1"

	'個人就労情報テーブルレコード読み込み
	objPerWorkInfo.SelectPerWorkInfo strPerId, dtmDataDate, lngNightWorkCount, dblOverTime

	'読み込み値の設定
	strNightWorkCount = CStr(lngNightWorkCount)
	strOverTimeInt    = CStr(Int(dblOverTime))
	strOverTimeDec    = CStr((dblOverTime * 10) Mod 10)

	'処理モードを更新とする
	strMode = MODE_UPDATE

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 各値の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon		'共通クラス
	Dim vntArrMessage	'エラーメッセージの集合

	'オブジェクトのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'各値チェック処理
	With objCommon

		'夜業回数
		.AppendArray vntArrMessage, .CheckNumeric("夜業回数", strNightWorkCount, LENGTH_NIGHTWORKCOUNT)

		'時間外就労時間(整数部)
		.AppendArray vntArrMessage, .CheckNumeric("時間外就労時間（整数部）", strOverTimeInt, LENGTH_OVERTIMEINT)

		'時間外就労時間(小数部)
		.AppendArray vntArrMessage, .CheckNumeric("時間外就労時間（小数部）", strOverTimeDec, LENGTH_OVERTIMEDEC)

	End With

	'戻り値の編集
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>個人就労情報の登録</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// submit時の処理
function submitForm( actMode ) {

	// 削除時は確認メッセージを表示
	if ( actMode == '<%= ACTMODE_DELETE %>' ) {
		if ( !confirm( 'この個人就労情報を削除します。よろしいですか？' ) ) {
			return;
		}
	}

	// 動作モードを指定してsubmit
	document.entryForm.actMode.value = actMode;
	document.entryForm.submit();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 20px; }
	td.mnttab { background-color:#FFFFFF }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">

	<INPUT TYPE="hidden" NAME="mode"    VALUE="<%= strMode  %>">
	<INPUT TYPE="hidden" NAME="actMode" VALUE="">
	<INPUT TYPE="hidden" NAME="perId"   VALUE="<%= strPerId %>">

	<!-- 表題 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">個人就労情報の登録</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	EditMessage strArrMessage, MESSAGETYPE_WARNING
%>
	<BR>
<%
	'個人情報読み込み
	Set objPerson = Server.CreateObject("HainsPerson.Person")
	objPerson.SelectPersonInf strPerId, strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGender, strGenderName, strAge
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD NOWRAP><%= strPerId %></TD>
			<TD NOWRAP><B><%= Trim(strLastName & "　" & strFirstName) %></B> （<FONT SIZE="-1"><%= Trim(strLastKName & "　" & strFirstKName) %></FONT>）</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><%= objCommon.FormatString(strBirth, "gee.mm.dd") %>生　<%= strAge %>歳　<%= strGenderName %></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD NOWRAP>データ年月</TD>
			<TD>：</TD>
<%
			If strMode = MODE_INSERT Then
%>
				<TD>
					<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
						<TR>
							<TD><%= EditNumberList("dataYear", YEARRANGE_MIN, YEARRANGE_MAX, lngDataYear, False) %></TD>
							<TD>&nbsp;年&nbsp;</TD>
							<TD><%= EditNumberList("dataMonth", 1, 12, lngDataMonth, False) %></TD>
							<TD>&nbsp;月</TD>
						</TR>
					</TABLE>
				</TD>
<%
			Else
%>
				<TD NOWRAP><INPUT TYPE="hidden" NAME="dataYear" VALUE="<%= lngDataYear %>"><INPUT TYPE="hidden" NAME="dataMonth" VALUE="<%= lngDataMonth %>"><%= lngDataYear %>年<%= lngDataMonth %>月</TD>
<%
			End If
%>
		</TR>
		<TR>
			<TD HEIGHT="1"></TD>
		</TR>
		<TR>
			<TD NOWRAP>夜業回数</TD>
			<TD>：</TD>
			<TD NOWRAP><INPUT TYPE="text" NAME="nightWorkCount" SIZE="<%= LENGTH_NIGHTWORKCOUNT %>" MAXLENGTH="<%= LENGTH_NIGHTWORKCOUNT %>" VALUE="<%= strNightWorkCount %>">&nbsp;回</TD>
		</TR>
		<TR>
			<TD NOWRAP>時間外就労時間</TD>
			<TD>：</TD>
			<TD NOWRAP><INPUT TYPE="text" NAME="overTimeInt" SIZE="<%= LENGTH_OVERTIMEINT %>" MAXLENGTH="<%= LENGTH_OVERTIMEINT %>" VALUE="<%= strOverTimeInt %>">．<INPUT TYPE="text" NAME="overTimeDec" SIZE="<%= LENGTH_OVERTIMEDEC %>" MAXLENGTH="<%= LENGTH_OVERTIMEDEC %>" VALUE="<%= strOverTimeDec %>">&nbsp;時間</TD>
		</TR>
	</TABLE>

	<BR><BR>
<%
	If strMode = MODE_UPDATE Then
%>
		<A HREF="javascript:submitForm('<%= ACTMODE_DELETE %>')"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="この個人就労情報を削除します"></A>
<%
	End If
%>
	<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A>
	<A HREF="javascript:submitForm('<%= ACTMODE_SAVE %>')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="入力したデータを保存します"></A>

</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
