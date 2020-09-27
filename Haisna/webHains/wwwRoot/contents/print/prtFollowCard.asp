<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	FailSafe印刷用 (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode		'印刷モード
Dim vntMessage		'通知メッセージ
Dim strURL		'URL
'-------------------------------------------------------------------------------
' 固有宣言部（各帳票に応じてこのセクションに変数を定義して下さい）
'-------------------------------------------------------------------------------
'COMオブジェクト
Dim objCommon		'共通クラス
Dim objOrganization	'団体情報アクセス用
Dim objOrgBsd		'事業部情報アクセス用
Dim objOrgRoom		'室部情報アクセス用
Dim objOrgPost		'所属情報アクセス用
Dim objPerson		'個人情報アクセス用
Dim objPrtFollowCard	'フォローアップはがきアクセス用

'■■■■■■■■■■ 画面項目にあわせて編集
'引数値
Dim strSCslYear, strSCslMonth, strSCslDay	'開始年月日
Dim strECslYear, strECslMonth, strECslDay	'終了年月日
Dim strSSecYear, strSSecMonth, strSSecDay	'開始二次検査年月日
Dim strESecYear, strESecMonth, strESecDay	'終了二次検査年月日
Dim strSecKbn     				'検索条件二次日フラグ(1:未予約)
Dim strCsCd					'コースコード
'Dim strSCsCd					'サブコースコード
Dim strOrgCd1, strOrgCd2			'団体コード
Dim strOrgBsdCd, strOrgRoomCd			'事業部コード, 室部コード
Dim strSOrgPostCd, strEOrgPostCd		'開始所属コード, 終了所属コード
Dim strPerId					'個人コード
'Dim strReceiptNo				'受付番号
'Dim strZipCd1, strZipCd2			'郵便番号(4, 3)
Dim  prinmode 
'■■■■■■■■■■

'作業用変数
Dim strKey              	'検索キー
Dim lngArrMailMode()		'はがき印刷状態の配列
Dim strArrMailModeName()	'はがき印刷状態名の配列

Dim lngMailMode			'はがき印刷状態の現在値

Dim strOrgName		'団体名
Dim strBsdName		'事業部名
Dim strRoomName		'室部名
Dim strSPostName	'開始所属名
Dim strEPostName	'終了所属名
Dim strLastName		'姓
Dim strFirstName	'名
Dim strPerName		'氏名
Dim strSCslDate		'開始日
Dim strECslDate		'終了日
Dim strSSecDate		'開始二次検査日
Dim strESecDate		'終了二次検査日
Dim prinh
Dim prinhh
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

Call CreateMailInfo()

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
'■■■■■■■■■■ 画面項目にあわせて編集
	'括弧内の文字列はHTML部で記述した項目の名称となります

'◆ 開始年月日
	If IsEmpty(Request("strCslYear")) Then
		strSCslYear   = Year(Now())		'開始年
		strSCslMonth  = Month(Now())		'開始月
		strSCslDay    = Day(Now())		'開始日
	Else
		strSCslYear   = Request("strCslYear")	'開始年
		strSCslMonth  = Request("strCslMonth")	'開始月
		strSCslDay    = Request("strCslDay")	'開始日
	End If
	strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
'◆ 終了年月日
	If IsEmpty(Request("endCslYear")) Then
		strECslYear   = strSCslYear		'終了年
		strECslMonth  = strSCslMonth		'開始月
		strECslDay    = strSCslDay		'開始日
	Else
		strECslYear   = Request("endCslYear")	'終了年
		strECslMonth  = Request("endCslMonth")	'開始月
		strECslDay    = Request("endCslDay")	'開始日
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
		strECslYear   = Request("strCslYear")	'開始年
		strECslMonth  = Request("strCslMonth")	'開始月
		strECslDay    = Request("strCslDay")	'開始日
		strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
	End If
'◆ 開始二次検査年月日
	strSSecYear   = Request("strSecYear")	'開始二次検査年
	strSSecMonth  = Request("strSecMonth")	'開始二次検査月
	strSSecDay    = Request("strSecDay")	'開始二次検査日
	If Request("strSecYear") = "" Then
		strSSecDate   = CDate("0")
	Else
		strSSecDate   = strSSecYear & "/" & strSSecMonth & "/" & strSSecDay
	End If
'◆ 終了二次検査年月日
	strESecYear   = Request("endSecYear")	'終了二次検査年
	strESecMonth  = Request("endSecMonth")	'終了二次検査月
	strESecDay    = Request("endSecDay")	'終了二次検査日
	If Request("endSecYear") = "" Then
		strESecDate   = CDate(strSSecDate)
	Else
		strESecDate   = strESecYear & "/" & strESecMonth & "/" & strESecDay
	End If
'◆ 二次検査フラグ
	If Request("secKbn") = "" Then
		strSecKbn     = "0"			'二次検査フラグ
	Else
		strSecKbn     = Request("secKbn")	'二次検査フラグ
	End If
'◆ コースコード
	strCsCd       = Request("csCd")
'◆ 団体コード
	strOrgCd1     = Request("orgCd1")
	strOrgCd2     = Request("orgCd2")
'◆ 個人ＩＤ
	strPerId      = Request("perId")
'◆ はがき区分
	lngMailMode   = Request("mailMode")
 
'■■■■■■■■■■
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
	Dim Flg
	
'■■■■■■■■■■ 画面項目にあわせて編集
	'ここにチェック処理を記述
	With objCommon
'例)		.AppendArray vntArrMessage, コメント

		If Not IsDate(strSCslDate) Then
			.AppendArray vntArrMessage, "開始日付が正しくありません。"
		End If

		If Not IsDate(strECslDate) Then
			.AppendArray vntArrMessage, "終了日付が正しくありません。"
		End If

		If strSSecDate <> "0" Then
			If Not IsDate(strSSecDate) Then
				.AppendArray vntArrMessage, "開始二次検査日付が正しくありません。"
			End If
		End If

		If strESecDate <> "0" Then
			If Not IsDate(strESecDate) Then
				.AppendArray vntArrMessage, "終了二次検査日付が正しくありません。"
			End If
		End If

	End With
'■■■■■■■■■■

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
' 備考　　 : 帳票ドキュメントファイル作成メソッドを呼び出す。メソッド内では次の処理が行われる。
' 　　　　   ?@印刷ログ情報の作成
' 　　　　   ?A帳票ドキュメントファイルの作成
' 　　　　   ?B処理成功時は印刷ログ情報レコードの主キーであるプリントSEQを戻り値として返す。
' 　　　　   このSEQ値を元に以降のハンドリングを行う。
'
'-------------------------------------------------------------------------------
Function Print()

	Dim objCommon	'共通クラス

	Dim objPrintCls	
	Dim Ret			'関数戻り値

	If Not IsArray(CheckValue()) Then

		'オブジェクトのインスタンス作成（プロジェクト名.クラス名）	
		Set objPrintCls = Server.CreateObject("HainsprtFollowCard.prtFollowCard")

		'受診者数についてドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
		Ret = objPrintCls.PrintOut( _
					   Session("USERID"), _
					   strSCslDate, strECslDate, _
					   strSSecDate, strESecDate, _
					   strSecKbn,   strCsCd, _
					   strOrgCd1,   strOrgCd2, _
					   strPerId,    lngMailMode _
					  ) 

	

		Print = Ret

	End If

End Function
'-------------------------------------------------------------------------------
'
' 機能　　 : １ページ表示ＭＡＸ行の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreateMailInfo()

	Redim Preserve lngArrMailMode(2)
	Redim Preserve strArrMailModeName(2)

	lngArrMailMode(0)     = 0
	strArrMailModeName(0) = "全て"

	lngArrMailMode(1)     = 1
	strArrMailModeName(1) = "出力済みのみ"

	lngArrMailMode(2)     = 2
	strArrMailModeName(2) = "未出力のみ"

End Sub

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<!--- ◆ ↓<Title>の修正を忘れないように ◆ -->
<TITLE>フォローアップはがき印刷用</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// チェックボックスの値を代入
function checkClick(selObj) {

	var myForm = document.entryForm;	// 自画面のフォームエレメント

	if (selObj.checked) {
		selObj.value = '1'
	} else {
		selObj.value = '0'
	}

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>

<BODY >

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">  
	<BLOCKQUOTE>

<!--- タイトル -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><Font color="#0000FF">■フォローアップはがき印刷用</font></TD>
		</TR>
	</TABLE>
<%
	Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>

	<BR>

<!--- 日付 -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>受診日</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
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
			</TD>
		</TR>
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>二次検査受診日</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('strSecYear', 'strSecMonth', 'strSecDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
						<TD><A HREF="javascript:calGuide_clearDate('strSecYear', 'strSecMonth', 'strSecDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
						<TD><%= EditSelectNumberList("strSecYear", YEARRANGE_MIN, YEARRANGE_MAX, strSSecYear) %></TD>
						<TD>年</TD>
						<TD><%= EditSelectNumberList("strSecMonth", 1, 12, strSSecMonth) %></TD>
						<TD>月</TD>
						<TD><%= EditSelectNumberList("strSecDay", 1, 31, strSSecDay) %></TD>
						<TD>日</TD>

						<TD>～</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('endSecYear', 'endSecMonth', 'endSecDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
						<TD><A HREF="javascript:calGuide_clearDate('endSecYear', 'endSecMonth', 'endSecDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
						<TD><%= EditSelectNumberList("endSecYear", YEARRANGE_MIN, YEARRANGE_MAX, strESecYear) %></TD>
						<TD>年</TD>
						<TD><%= EditSelectNumberList("endSecMonth", 1, 12, strESecMonth) %></TD>
						<TD>月</TD>
						<TD><%= EditSelectNumberList("endSecDay", 1, 31, strESecDay) %></TD>
						<TD>日</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD NOWRAP>未予約者</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="checkbox" NAME="secKbn" VALUE="<%=strSecKbn%>" <%= IIf(strSecKbn = "1", " CHECKED","") %> ONCLICK="javascript:checkClick(this)">二次検診予約していない未受診者も対象とする。</TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD NOWRAP>コース</TD>
			<TD>：</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, NON_SELECTED_ADD, False) %></TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD>団体</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:orgGuide_showGuideOrg(document.entryForm.orgCd1, document.entryForm.orgCd2, 'orgName')"><IMG SRC="/webHains/images/question.gif" ALT="団体検索ガイドを表示" HEIGHT="21" WIDTH="21"></A></TD>
						<TD><A HREF="javascript:perGuide_clearPerInfo(document.entryForm.orgCd1, document.entryForm.orgCd2, 'orgName')"><IMG SRC="/webHains/images/delicon.gif" ALT="設定した値をクリア" HEIGHT="21" WIDTH="21"></TD>
						<TD WIDTH="5"></TD>
						<TD>
							<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
							<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
							<INPUT TYPE="hidden" NAME="txtorgName" VALUE="<%= strOrgName %>">
							<SPAN ID="orgName"><%= strOrgName %></SPAN>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD>個人ID</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:perGuide_showGuidePersonal(document.entryForm.perId, 'perName')"><IMG SRC="/webHains/images/question.gif" ALT="個人検索ガイドを表示" HEIGHT="21" WIDTH="21"></A></TD>
						<TD><A HREF="javascript:perGuide_clearPerInfo(document.entryForm.perId, 'perName')"><IMG SRC="/webHains/images/delicon.gif" ALT="設定した値をクリア" HEIGHT="21" WIDTH="21"></TD>
						<TD WIDTH="5"></TD>
						<TD>
							<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strKey %>">
							<INPUT TYPE="hidden" NAME="txtperName" VALUE="<%= strPerName %>">
							<SPAN ID="perName"><%= strPerName %></SPAN>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD>はがき</TD>
			<TD>：</TD>
			<TD><%= EditDropDownListFromArray("mailMode", lngArrMailMode, strArrMailModeName, lngMailMode, NON_SELECTED_DEL) %>　</TD>
		</TR>
	</TABLE>
	<p><BR>
		<!--- 印刷モード --></p>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<!--  2003/02/27  START  START  E.Yamamoto  -->
<INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--  2003/02/27  START  END    E.Yamamoto  -->
<!--  2003/02/27  DEL  START  E.Yamamoto  -->
<!--
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="0" <%= IIf(strMode = PRINTMODE_PREVIEW, "CHECKED", "") %>></TD>
			<TD NOWRAP>プレビュー</TD>

			<TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <%= IIf(strMode = PRINTMODE_DIRECT,  "CHECKED", "") %>></TD>
			<TD NOWRAP>直接出力</TD>
		</TR>
--><!--  2003/02/27  DEL  END    E.Yamamoto  -->
				</TABLE>
				<BR><BR>

<!--- 印刷ボタン -->
	<!---2006.07.04 権限管理 追加 by 李  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
		<INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="印刷する">&nbsp;
	<%  End if  %>

	<INPUT TYPE="hidden" NAME="mode" VALUE="0"> 

	</BLOCKQUOTE>
<!--
<%= strSCslDate %>
<BR>
<%= strECslDate %>
<BR>
-->
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>