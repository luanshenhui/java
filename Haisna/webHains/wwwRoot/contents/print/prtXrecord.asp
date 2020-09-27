<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		照射録 (Ver0.0.1)
'		AUTHER  : (NSC)birukawa
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode				'印刷モード
Dim vntMessage			'通知メッセージ

'-------------------------------------------------------------------------------
' 固有宣言部（各帳票に応じてこのセクションに変数を定義して下さい）
'-------------------------------------------------------------------------------
'COMオブジェクト
Dim objCommon								'共通クラス
Dim objOrganization							'団体情報アクセス用
Dim objOrgBsd								'事業部情報アクセス用
Dim objOrgRoom								'室部情報アクセス用
Dim objOrgPost								'所属情報アクセス用
Dim objPerson								'個人情報アクセス用
Dim objReport								'帳票情報アクセス用

Dim strOutPutCls							'出力対象
'パラメータ値
Dim strSCslYear, strSCslMonth, strSCslDay				'開始年月日
Dim strECslYear, strECslMonth, strECslDay				'終了年月日
Dim strSDayId								'開始当日ID
Dim strEDayId								'終了当日ID
Dim strParts								'照射方法
Dim strLID								'ログインID
Dim strUID								'ユーザID

Dim strReportOutDate							'出力日

'作業用変数
Dim strSCslDate								'開始日
Dim strECslDate								'終了日

'帳票情報
Dim strArrReportCd							'帳票コード
Dim strArrReportName							'帳票名
Dim strArrHistoryPrint							'過去歴印刷
Dim lngReportCount							'レコード数

Dim i									'ループインデックス
Dim j									'ループインデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'共通引数値の取得
strMode = Request("mode")

'帳票出力処理制御
vntMessage = PrintControl(strMode)

'-------------------------------------------------------------------------------
'
' 機能　　 : URL引数値の取得
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 : URLの引数値を取得する処理を記述して下さい
'
'-------------------------------------------------------------------------------
Sub GetQueryString()

'◆ 開始年月日
	If IsEmpty(Request("strCslYear")) Then
		strSCslYear   = Year(Now())				'開始年
		strSCslMonth  = Month(Now())				'開始月
		strSCslDay    = Day(Now())				'開始日
	Else
		strSCslYear   = Request("strCslYear")			'開始年
		strSCslMonth  = Request("strCslMonth")			'開始月
		strSCslDay    = Request("strCslDay")			'開始日
	End If
	strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
'◆ 終了年月日
	If IsEmpty(Request("endCslYear")) Then
		strECslYear   = Year(Now())				'終了年
		strECslMonth  = Month(Now())				'開始月
		strECslDay    = Day(Now())				'開始日
	Else
		strECslYear   = Request("endCslYear")			'終了年
		strECslMonth  = Request("endCslMonth")			'開始月
		strECslDay    = Request("endCslDay")			'開始日
	End If
	strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
'◆ 開始年月日と終了年月日の大小判定と入替
'   （日付型に変換してチェックしないのは日付として誤った値であったときのエラー回避の為）
	If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
	   Right("00" & Trim(CStr(strSCslMonth)), 2) & _
	   Right("00" & Trim(CStr(strSCslDay)), 2) _
	 > Right("0000" & Trim(CStr(strECslYear)), 4) & _
	   Right("00" & Trim(CStr(strECslMonth)), 2) & _
	   Right("00" & Trim(CStr(strECslDay)), 2) Then
		strSCslYear   = strECslYear
		strSCslMonth  = strECslMonth
		strSCslDay    = strECslDay
		strSCslDate   = strECslDate
		strECslYear   = Request("strCslYear")			'開始年
		strECslMonth  = Request("strCslMonth")			'開始月
		strECslDay    = Request("strCslDay")			'開始日
		strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
	End If

'◆ 開始当日ＩＤ
	strSDayId	= Request("SDayId")
	
'◆ 終了当日ＩＤ
	strEDayId	= Request("EDayId")

'◆ 照射方法
	strParts	= Request("Parts")
     
'◆ ログインＩＤ
	strLID          = Request("LoginId")

'◆ ユーザID
	strUID          = Session("USERID")
	

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 引数値の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim vntArrMessage	'エラーメッセージの集合

	'ここにチェック処理を記述
	With objCommon
'例)		.AppendArray vntArrMessage, コメント
		If strMode <> "" Then
			'受診日チェック
			If Not IsDate(strSCslDate) Then
				.AppendArray vntArrMessage, "開始日付が正しくありません。"
			End If
			If Not IsDate(strECslDate) Then
				.AppendArray vntArrMessage, "終了日付が正しくありません。"
			End If
      
		End If
    
	End With

	'戻り値の編集
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 帳票ドキュメントファイル作成処理
'
' 引数　　 :
'
' 戻り値　 : 印刷ログ情報のシーケンス値
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function Print()

	Dim objPrintCls
	Dim objCommon	'共通クラス
	Dim Ret			'関数戻り値

	If Not IsArray(CheckValue()) Then

		'情報漏えい対策用ログ書き出し
		Call putPrivacyInfoLog("PH037", "照射録の印刷を行った")

		'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
		Set objPrintCls = Server.CreateObject("HainsprtXrecord.prtXrecord")
		
		'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
		Ret = objPrintCls.PrintOut(strSCslDate, strECslDate, strSDayID, strEDayID, strParts, strUID, strLID)

		print = Ret
		
	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Microsoft FrontPage 4.0">
<TITLE>照射録</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 団体画面表示
function showGuideOrgGrp( Cd1, Cd2, CtrlName ) {
	// 団体情報エレメントの参照設定
	orgPostGuide_getElement( Cd1, Cd2, CtrlName );
	// 画面表示
	orgPostGuide_showGuideOrg();
}
// 団体情報削除
function clearGuideOrgGrp( Cd1, Cd2, CtrlName ) {
	// 団体情報エレメントの参照設定
	orgPostGuide_getElement( Cd1, Cd2, CtrlName );
	// 削除
	orgPostGuide_clearOrgInfo();
}
// submit時の処理
function submitForm() {
	document.entryForm.submit();
}
//function selectHistoryPrint( index ) {
//	document.entryForm.historyPrint.value = document.historyPrintForm.historyPrint[ index ].value;
//}
-->
</SCRIPT>
<STYLE TYPE="text/css">
<!--
td.prttab { background-color:#ffffff }
-->
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■照射録</SPAN></B></TD>
		</TR>
	</TABLE>
	<BR>
	<!--- 日付 -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>受診日</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
			<TD>日</TD>
			<TD>～</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, False) %></TD>
			<TD>日</TD>
		</TR>
	</TABLE>
	
	<table border="0" cellpadding="1" cellspacing="2">
		<tr>
			<TD>□</TD>
			<td width="90" nowrap>開始当日ID</td>
			<td>：</td>
			<td><input type="text" name="SDayId" size="20" value="" maxlength="10"> </td>
		</tr>
		<tr>
			<TD>□</TD>
			<td width="90" nowrap>終了当日ID</td>
			<td>：</td>
			<td><input type="text" name="EDayId" size="20" value="" maxlength="10"></td>
		</tr>
	</table>
	<table border="0" cellpadding="1" cellspacing="2">
		<tr>
			<td><font color="#ff0000">■</font></td>
			<td width="92" nowrap>照射方法</td>
			<td>：</td>
			<td><select name="Parts" size="1">
					<option selected value="0">全て</option>
					<option value="1">胃透視</option>
					<option value="2">胸部</option>
					<option value="3">胸部CT</option>
					<option value="4">乳房</option>
					<option value="5">骨密度</option>
				</select></td>
			<td></td>
		</tr>
	</table>
	<table border="0" cellpadding="1" cellspacing="2">
		<tr>
			<td>□</td>
			<td width="92" nowrap>ログインID</td>
			<td>：</td>
			<td><input type="text" name="LoginId" size="20" value="" maxlength="10"></td>
		</tr>
	</table>
	<p><!--- 印刷モード --><BR>
<%
	'印刷モードの初期設定
	strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
    <INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--
		<TD><INPUT TYPE="radio" NAME="mode" VALUE="0" <%= IIf(strMode = PRINTMODE_PREVIEW, "CHECKED", "") %>></TD>
		<TD NOWRAP>プレビュー</TD>

		<TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <%= IIf(strMode = PRINTMODE_DIRECT,  "CHECKED", "") %>></TD>
		<TD NOWRAP>直接出力</TD>
		</TR>
-->
	</TABLE>
	
	
	
	<BR>
	<!--- 印刷ボタン -->
	<!---2006.07.04 権限管理 追加 by 李  -->
    <% If Session("PAGEGRANT") = "4" Then   %>	
		<INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="印刷する"></p>
	<%  End if  %>

	</BLOCKQUOTE>



</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>