<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	みずほＦＡＸ用紙 (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
'       管理番号：SL-UI-Y0101-203
'       修正日  ：2010.05.17
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
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode			'印刷モード
Dim vntMessage		'通知メッセージ
Dim strURL			'URL
Dim UID
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

'■■■■■■■■■■ 画面項目にあわせて編集
'引数値
Dim strSCslYear, strSCslMonth, strSCslDay	'開始年月日
Dim strECslYear, strECslMonth, strECslDay	'終了年月日
Dim strCsCd									'コースコード
'Dim strSCsCd								'サブコースコード
Dim strOrgCd1, strOrgCd2					'団体コード
Dim strOrgBsdCd, strOrgRoomCd				'事業部コード, 室部コード
Dim strSOrgPostCd, strEOrgPostCd			'開始所属コード, 終了所属コード
Dim strPerId								'個人コード
'Dim strReceiptNo							'受付番号
Dim strObject								'出力対象
'Dim strZipCd1, strZipCd2					'郵便番号(4, 3)
Dim  prinmode 
'■■■■■■■■■■

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
		strSCslYear   = Year(Now())				'開始年
		strSCslMonth  = Month(Now())			'開始月
		strSCslDay    = Day(Now())				'開始日
	Else
		strSCslYear   = Request("strCslYear")	'開始年
		strSCslMonth  = Request("strCslMonth")	'開始月
		strSCslDay    = Request("strCslDay")	'開始日
	End If
	strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
'◆ 終了年月日
	If IsEmpty(Request("endCslYear")) Then
		strECslYear   = Year(Now())				'終了年
		strECslMonth  = Month(Now())			'開始月
		strECslDay    = Day(Now())				'開始日
	Else
		strECslYear   = Request("endCslYear")	'終了年
		strECslMonth  = Request("endCslMonth")	'開始月
		strECslDay    = Request("endCslDay")	'開始日
	End If
	strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
'◆ 開始年月日と終了年月日の大小判定と入替
'   （日付型に変換してチェックしないのは日付として誤った値であったときのエラー回避の為）
'	If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
'	   Right("00" & Trim(CStr(strSCslMonth)), 2) & _
'	   Right("00" & Trim(CStr(strSCslDay)), 2) _
'	 > Right("0000" & Trim(CStr(strECslYear)), 4) & _
'	   Right("00" & Trim(CStr(strECslMonth)), 2) & _
'	   Right("00" & Trim(CStr(strECslDay)), 2) Then
'		strSCslYear   = strECslYear
'		strSCslMonth  = strECslMonth
'		strSCslDay    = strECslDay
'		strSCslDate   = strECslDate
'		strECslYear   = Request("strCslYear")	'開始年
'		strECslMonth  = Request("strCslMonth")	'開始月
'		strECslDay    = Request("strCslDay")	'開始日
'		strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
'	End If

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
			If Not IsDate(strSCslDate) Then
				.AppendArray vntArrMessage, "開始日付が正しくありません。"
			End If

			If Not IsDate(strECslDate) Then
				.AppendArray vntArrMessage, "終了日付が正しくありません。"
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
	Dim objPrintCls	'団体一覧出力用COMコンポーネント
	Dim Ret			'関数戻り値

	If Not IsArray(CheckValue()) Then

        '情報漏えい対策用ログ書き出し
        Call putPrivacyInfoLog("PH016", "みずほFAX用紙の印刷を行った")

'■■■■■■■■■■ 画面項目にあわせて編集
'		'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
'		Set objPrintCls = Server.CreateObject("HainsCslSheet.CslSheet")
'			'プロジェクト名はソースを開いて確認。
'		'団体一覧表ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
'		Ret = objPrintCls.PrintCslSheet(Session("USERID"), ,cdate(strSCslDate), cdate(strECslDate),cint(strObject) )
'■■■■■■■■■■
'		Print = Ret


Set objCommon = Server.CreateObject("HainsCommon.Common")
'#### 2010.05.17 SL-UI-Y0101-203 MOD START ####'
''## 2003/12/27 Upd NSC@Itoh
''strURL = "/webHains/contents/report_form/rd_4_prtFaxPaper.asp"
'strURL = "/webHains/contents/report_form/rd_04_prtFaxPaper.asp"
'strURL = strURL & "?p_Uid=" & UID
'strURL = strURL & "&p_ScslDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
'Set objCommon = Nothing
'Response.Redirect strURL
'Response.End	

        'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
        Set objPrintCls = Server.CreateObject("HainsprtFaxPaper.prtFaxPaper")
        'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
        Ret = objPrintCls.PrintOut(UID, strSCslDate)
        Print = Ret
'#### 2010.05.17 SL-UI-Y0101-203 MOD END ####'
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
<TITLE>みずほFAX用紙</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
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
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><Font color="#0000FF">■</font><font>みずほFAX用紙</font></TD>
		</TR>
	</TABLE>
	<BR>

<!--- 日付 -->
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>予約作成日</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
						<TD>日</TD>
					</TR>
	</TABLE>
<BR>
		
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
--><!--  2003/02/27  DEL  END    E.Yamamoto  -->
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