<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	日本総合健診医学会統計 (Ver0.0.1)
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
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode			'印刷モード
Dim vntMessage		'通知メッセージ
Dim strURL			'URL
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
Dim strObject1								'出力対象
Dim strObject2								'出力対象
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
	
 	strObject     = Request("object")		'対象
 	strObject1     = Request("object1")		'対象
 	strObject2     = Request("object2")		'対象
	
       
 
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

	Dim objPrintCls	
	Dim Ret			'関数戻り値

	If Not IsArray(CheckValue()) Then

		If strObject = 1 then
			'オブジェクトのインスタンス作成（プロジェクト名.クラス名）	
			Set objPrintCls = Server.CreateObject("HainsJHEPconsult1.JHEPconsult1")

			'受診者数についてドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
			Ret = objPrintCls.PrintJHEPconsult1( _
								Session("USERID"), _
							      	, _
							    	strSCslDate, _
							    	strECslDate _
							 	) 
		

			Print = Ret
		End If

		If strObject1 = 1 then
			'オブジェクトのインスタンス作成（プロジェクト名.クラス名）	
			Set objPrintCls = Server.CreateObject("HainsJHEPconsult2.JHEPconsult2")

			'受診者数についてドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
			Ret = objPrintCls.PrintJHEPconsult2( _
								Session("USERID"), _
							      	, _
							    	strSCslDate, _
							    	strECslDate _
							 	) 
		

			Print = Ret
		End If

		If strObject2 = 1 then
			'オブジェクトのインスタンス作成（プロジェクト名.クラス名）	
			Set objPrintCls = Server.CreateObject("HainsJHEPconsult3.JHEPconsult3")

			'受診者数についてドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
			Ret = objPrintCls.PrintJHEPconsult3( _
								Session("USERID"), _
							      	, _
							    	strSCslDate, _
							    	strECslDate _
							 	) 
		

			Print = Ret
		End If


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
<TITLE>日本総合健診医学会統計</TITLE>
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
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><Font color="#0000FF">■日本総合健診医学会統計</font></TD>
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
				<!--- 出力対象 -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>□</TD>
			<TD WIDTH="204" NOWRAP>受診者数について</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="checkbox" NAME="object" VALUE="1" <% = IIf(CStr(strObject) = "1", "CHECKED", "") %> checked></TD>
			<TD>出力する</TD>
		</TR>
	</TABLE>
	<table border="0" cellpadding="1" cellspacing="2">
		<tr>
			<td>□</td>
			<td width="204" nowrap>総合健診受診者・有所見率</td>
			<td>：</td>
			<td><input type="checkbox" name="object1" value="1" <% = iif(cstr(strobject1) = "1", "checked", "") %> checked></td>
			<td>出力する</td>
		</tr>
	</table>
	<table border="0" cellpadding="1" cellspacing="2">
		<tr>
			<td>□</td>
			<td width="203" nowrap>診断基準・基準値の記載</td>
			<td>：</td>
			<td><input type="checkbox" name="object2" value="1" <% = iif(cstr(strobject2) = "1", "checked", "") %> checked></td>
			<td>出力する</td>
		</tr>
	</table>
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
 
	</BLOCKQUOTE>
<!--
<%= strSCslDate %>
<BR>
<%= strECslDate %>
<br>
<%= strObject %>
<BR>
<%= strObject1 %>
<BR>
<%= strObject2 %>
<BR>
-->
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>