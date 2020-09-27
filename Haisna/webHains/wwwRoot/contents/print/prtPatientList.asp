<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	受診対象者名簿 (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
'       管理番号：SL-UI-Y0101-206
'       修正日  ：2010.05.26
'       担当者  ：ASC)武藤
'       修正内容：Report DesignerをCo Reportsに変更
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/ReportCtl.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode			'印刷モード
Dim vntMessage		'通知メッセージ

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

'引数値
Dim strSCslYear, strSCslMonth, strSCslDay	'開始年月日
Dim strECslYear, strECslMonth, strECslDay	'終了年月日
Dim strCsCd									'コースコード
Dim strOrgBsdCd, strOrgRoomCd				'事業部コード, 室部コード
Dim strSOrgPostCd, strEOrgPostCd			'開始所属コード, 終了所属コード
Dim strPerId								'個人コード
Dim strObject								'出力対象

'作業用変数
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
Dim strURL			'URL
Dim UID

'## 2003/12/29 Upd Start NSC@birukawa 受診日省略可能対応
Dim C_REPORT_CD		'帳票コード（固定）
Dim strRptCslDate	'帳票パラメータ管理テーブルの受診日
Dim strWkDate

C_REPORT_CD = "000090"
'## 2003/12/29 Upd End   NSC@birukawa 受診日省略可能対応


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

'## 2003/12/29 Upd Start NSC@birukawa 受診日省略可能対応
'帳票コードに該当する受診日を取得
strRptCslDate = GetCslDate(C_REPORT_CD)
'## 2003/12/29 Upd End   NSC@birukawa 受診日省略可能対応


'◆ 開始年月日
	If Trim(Request("strCslYear")) <> "" Then
		strSCslYear   = Request("strCslYear")	'開始年
		strSCslMonth  = Request("strCslMonth")	'開始月
		strSCslDay    = Request("strCslDay")	'開始日
		strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
	ElseIf Trim(strRptCslDate) <> "" Then
		'帳票パラメータ管理テーブルに帳票コードに該当するレコードが存在する場合は、
		'受診日の翌日をデフォルト日付とする。
		strWkDate = objCommon.FormatString(DateSerial(CInt(Mid(strRptCslDate, 1, 4)), CInt(Mid(strRptCslDate, 5, 2)), CInt(Mid(strRptCslDate, 7, 2)) + 1),"YYYYMMDD")
		strSCslYear   = Mid(strWkDate, 1, 4)	'開始年
		strSCslMonth  = Mid(strWkDate, 5, 2)	'開始月
		strSCslDay    = Mid(strWkDate, 7, 2)	'開始日
		strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
	End If

'◆ 終了年月日
	If Trim(Request("endCslYear")) <> "" Then
		strECslYear   = Request("endCslYear")	'終了年
		strECslMonth  = Request("endCslMonth")	'開始月
		strECslDay    = Request("endCslDay")	'開始日
		strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
	ElseIf Trim(strRptCslDate) <> "" Then
		'帳票パラメータ管理テーブルに帳票コードに該当するレコードが存在する場合は、
		'受診日の翌日をデフォルト日付とする。
		strWkDate = objCommon.FormatString(DateSerial(CInt(Mid(strRptCslDate, 1, 4)), CInt(Mid(strRptCslDate, 5, 2)), CInt(Mid(strRptCslDate, 7, 2)) + 1),"YYYYMMDD")
		strECslYear   = Mid(strWkDate, 1, 4)	'開始年
		strECslMonth  = Mid(strWkDate, 5, 2)	'開始月
		strECslDay    = Mid(strWkDate, 7, 2)	'開始日
		strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
	End If
'◆ 開始年月日と終了年月日の大小判定と入替
'   （日付型に変換してチェックしないのは日付として誤った値であったときのエラー回避の為）
	If Trim(strSCslDate) <> "" And Trim(strECslDate) <> "" Then
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
	End If
'## 2003/12/29 Upd End   NSC@birukawa 受診日省略可能対応

	strCsCd       = Request("csCd")			'コースコード
'	strSCsCd      = Request("scsCd")		'サブコースコード

'## 2004/1/2 DEL Start (NSC)birukawa 必要ないので削除
''◆ 団体
'	strOrgCd1     = Request("orgCd1")		'団体コード１
'	strOrgCd2     = Request("orgCd2")		'団体コード２
'     strOrgName   = Request("strOrgName")
'	If strOrgCd1 <> "" And strOrgCd2 <> "" Then
'		objOrganization.SelectlukeOrg strOrgCd1, strOrgCd2 , strOrgName
'	End If
'## 2004/1/2 DEL END   (NSC)birukawa 必要ないので削除

'◆ 事業部
'◆ 室部
'◆ 所属

	strPerId      = Request("perId")		'個人コード
	If strPerId <> "" Then
'## 2003/12/29 Upd Start NSC@birukawa メソッド変更
'		objPerson.SelectlukePerson strPerId, strLastName, strFirstName
		objPerson.SelectPerson_lukes strPerId, strLastName, strFirstName
'## 2003/12/29 Upd End   NSC@birukawa メソッド変更
		strPerName = Trim(strLastName) & "　" & Trim(strFirstName)
	End If
UID = Session("USERID")

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

'■■■■■■■■■■ 画面項目にあわせて編集
	'ここにチェック処理を記述
	With objCommon
'例)		.AppendArray vntArrMessage, コメント

		If strMode <> "" Then
'## 2003/12/29 Upd Start NSC@birukawa 受診日省略可能対応
'			If Not IsDate(strSCslDate) Then
'				.AppendArray vntArrMessage, "開始日付が正しくありません。"
'			End If

'			If Not IsDate(strECslDate) Then
'				.AppendArray vntArrMessage, "終了日付が正しくありません。"
'			End If

			If Trim(strSCslDate) <> "" Then 
				If Not IsDate(strSCslDate) Then
					.AppendArray vntArrMessage, "開始日付が正しくありません。"
				End If
			End If

			If Trim(strECslDate) <> "" Then
				If Not IsDate(strECslDate) Then
					.AppendArray vntArrMessage, "終了日付が正しくありません。"
				End If
			End If

			If Trim(strSCslDate) = "" And Trim(strECslDate) <> "" Then
				strSCslYear   = strECslYear
				strSCslMonth  = strECslMonth
				strSCslDay    = strECslDay
				strSCslDate   = strECslDate
			ElseIf Trim(strSCslDate) <> "" And Trim(strECslDate) = "" Then
				strECslYear   = strSCslYear
				strECslMonth  = strSCslMonth
				strECslDay    = strSCslDay
				strECslDate   = strSCslDate
			End If

			'受診日、個人IDのいずれかが入力されていなければエラーとする。
			If Trim(strSCslDate) = "" And Trim(strPerId) = "" Then
				.AppendArray vntArrMessage, "受診日、個人IDのいずれかを入力してください。"
			End If
'## 2003/12/29 Upd End   NSC@birukawa 受診日省略可能対応
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

	Dim objPrintCls	'団体一覧出力用COMコンポーネント
	Dim Ret			'関数戻り値
Dim objCommon	'共通クラス
	If Not IsArray(CheckValue()) Then

        '情報漏えい対策用ログ書き出し
        Call putPrivacyInfoLog("PH020", "新患登録リストの印刷を行った")

'## 2003/12/29 Upd Start NSC@birukawa 受診日省略可能対応
		'受診終了日が設定されていた場合のみ、帳票パラメータ管理テーブル更新
		If Trim(strECslDate) <> "" Then
			Call UpdateReportData(C_REPORT_CD, strECslDate, UID)
		End If
'## 2003/12/29 Upd End   NSC@birukawa 受診日省略可能対応

'■■■■■■■■■■ 画面項目にあわせて編集
		'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
'		Set objPrintCls = Server.CreateObject("HainsCslSheet.CslSheet")
			'プロジェクト名はソースを開いて確認。
		'団体一覧表ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
'		Ret = objPrintCls.PrintCslSheet(Session("USERID"), ,cdate(strSCslDate), cdate(strECslDate),strCsCd, strOrgCd1, strOrgCd2, _
'		                                strOrgBsdCd, strOrgRoomCd, strSOrgPostCd, strEOrgPostCd, strPerId, cint(strObject) )
'■■■■■■■■■■
'		Print = Ret
Set objCommon = Server.CreateObject("HainsCommon.Common")
'#### 2010.05.26 SL-UI-Y0101-206 MOD START ####'
''## 2003/12/27 Upd NSC@Itoh
''strURL = "/webHains/contents/report_form/rd_9_prtPatientList.asp"
'strURL = "/webHains/contents/report_form/rd_09_prtPatientList.asp"
'strURL = strURL & "?p_Uid=" & UID
''## 2003/12/29 Upd Start NSC@birukawa 受診日省略可能対応
''strURL = strURL & "&p_ScslDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
''strURL = strURL & "&p_EcslDate=" & objCommon.FormatString(CDate(strECslDate), "yyyy/mm/dd")
'
'	If Trim(strSCslDate) <> "" Then
'		strURL = strURL & "&p_ScslDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
'	Else
'		strURL = strURL & "&p_ScslDate="
'	End If
'	If Trim(strECslDate) <> "" Then
'		strURL = strURL & "&p_EcslDate=" & objCommon.FormatString(CDate(strECslDate), "yyyy/mm/dd")
'	Else
'		strURL = strURL & "&p_EcslDate="
'	End If
''## 2003/12/29 Upd End   NSC@birukawa 受診日省略可能対応
'Set objCommon = Nothing
'strURL = strURL & "&p_PerID=" & strPerId 
'Response.Redirect strURL
'Response.End

        'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
        Set objPrintCls = Server.CreateObject("HainsprtPatientList.prtPatientList")
        'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
        Ret = objPrintCls.PrintOut(UID, strSCslDate, strECslDate, strPerId)
        Print = Ret
'#### 2010.05.26 SL-UI-Y0101-206 MOD END ####'

	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<!--- ◆ ↓<Title>の修正を忘れないように ◆ -->
<TITLE>新患登録</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// エレメントの参照設定
function setElement() {

	with ( document.entryForm ) {

		// 団体・所属情報エレメントの参照設定（入力項目に団体・所属が無い場合は不要）

		// 個人情報エレメントの参照設定（入力項目に個人情報が無いときは不要）
		orgPostGuide_getPerElement( perId, 'perName' );

	}

}

// 当画面のみは戻るの場合に再読み込みすると日付が更新されてしまいおかしな状態になる。
// よってここではperidのクリアとする
function checkRunStateForprtPatientList() {
	if (document.entryForm.runstate.value == 'run') {
		orgPostGuide_clearAllPerInfo();
	}
}

//-->
</SCRIPT>
<script TYPE="text/javascript" src="/webHains/js/checkRunState.js?v=1.2"></script>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement();checkRunStateForprtPatientList();">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" onsubmit="setRunState();" method="post">
<INPUT TYPE="hidden" NAME="runstate" VALUE="">
	<BLOCKQUOTE>
<!--- タイトル -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■新患登録</SPAN></B></TD>
		</TR>
	</TABLE>
<%
'エラーメッセージ表示

'	Dim strArrMessage
'	strArrMessage = CheckValue()
'	if IsArray(strArrMessage) Then
'		Response.Write "<BR>" & vblf
'		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
'	End If
	Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
	<BR>

<!--- 日付 -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
<!-- ##2003/12/29 Upd End   NSC@birukawa 受診日省略可能対応 
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
-->
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>受診日</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, True) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, True) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, True) %></TD>
			<TD>日</TD>

			<TD>～</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, True) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, True) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, True) %></TD>
			<TD>日</TD>
		</TR>
	</TABLE>
	<!--- 従業員 -->
	<INPUT TYPE="hidden" NAME="perId" VALUE="<% = strPerId %>">
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>個人ID</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuidePersonal()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="個人検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearAllPerInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="perName"><% = strPerName %></SPAN></TD>
		</TR>
	</TABLE>

<!--- 出力対象 --><BR>
<!--- 印刷モード -->
<%
	'印刷モードの初期設定
	strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
%>
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
-->
<!--  2003/02/27  DEL  END    E.Yamamoto  -->
	</TABLE>

	<BR><BR>

<!--- 印刷ボタン -->
	<!---2006.07.04 権限管理 追加 by 李  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
		<INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="印刷する">
	<%  End if  %>

	</BLOCKQUOTE>


</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>