<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	人間ドック症例別人数統計 (Ver0.0.1)
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
Dim vntMessage			'通知メッセージ
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
Dim strCsKbn					'コース区分	1:１泊人間ドック 2:１日病院外来ドック 3:１日人間ドック 4:その他
Dim strCsCd					'コースコード1～10

Dim  prinmode					'プリントモード 
'■■■■■■■■■■

'作業用変数
Dim strSCslDate		'開始日
Dim strECslDate		'終了日
Dim prinh
Dim prinhh

Dim i
Dim Flg
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
		strECslYear   = Request("strCslYear")	'開始年
		strECslMonth  = Request("strCslMonth")	'開始月
		strECslDay    = Request("strCslDay")	'開始日
		strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
	End If
	
	strCskbn     = Request("Cskbn")			'コース区分

	ReDim strCsCd(10)
        
	strCsCd(1)     = Request("csCd1")			'コースコード1
        strCsCd(2)     = Request("csCd2")			'コースコード2
        strCsCd(3)     = Request("csCd3")			'コースコード3
        strCsCd(4)     = Request("csCd4")			'コースコード4
        strCsCd(5)     = Request("csCd5")			'コースコード5
        strCsCd(6)     = Request("csCd6")			'コースコード6
        strCsCd(7)     = Request("csCd7")			'コースコード7
        strCsCd(8)     = Request("csCd8")			'コースコード8
        strCsCd(9)     = Request("csCd9")			'コースコード9
        strCsCd(10)    = Request("csCd10")			'コースコード10

'    prinh = Request("print.x")
'    prinhh =Request("prevew.x")
    
'    if prinh <> "" then
'       prinmode = "0"
'    elseif prinhh <>"" then
'       prinmode = "1" 
'    end if   
       
 
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
			
			Flg = 0
			For i = 1 To 10
				If Len(strCscd(i)) <> 0 then
					Flg = 1
				End if
			Next 
			
			If Flg = 0 then
				.AppendArray vntArrMessage, "コースコードを１つ以上選択してください。"
			End if
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
' 　　　　   ①印刷ログ情報の作成
' 　　　　   ②帳票ドキュメントファイルの作成
' 　　　　   ③処理成功時は印刷ログ情報レコードの主キーであるプリントSEQを戻り値として返す。
' 　　　　   このSEQ値を元に以降のハンドリングを行う。
'
'-------------------------------------------------------------------------------
Function Print()

	Dim objCommon	'共通クラス

	Dim objPrintCls		'人間ドック症例別人数統計出力用COMコンポーネント
	Dim Ret			'関数戻り値

	If Not IsArray(CheckValue()) Then

'''■■■■■■■■■■ 画面項目にあわせて編集
''		'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
'''		Set objPrintCls = Server.CreateObject("HainsCslSheet.CslSheet")
''			'プロジェクト名はソースを開いて確認。
''
''		'団体一覧表ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
'''		Ret = objPrintCls.PrintCslSheet(Session("USERID"), ,cdate(strSCslDate), cdate(strECslDate),cint(strObject) )
'''■■■■■■■■■■
''
'''		Print = Ret


		'オブジェクトのインスタンス作成（プロジェクト名.クラス名）	
		Set objPrintCls = Server.CreateObject("HainsDockStatistics.DockStatistics")

		'人間ドック症例別人数統計ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
		Ret = objPrintCls.PrintDockStatistics( _
							Session("USERID"), _
						      	, _
						    	strSCslDate, _
						    	strECslDate, _
						    	strCskbn, _
						    	strCsCd(1), _
						    	strCsCd(2), _
						    	strCsCd(3), _
						    	strCsCd(4), _
						    	strCsCd(5), _
						    	strCsCd(6), _
						    	strCsCd(7), _
						    	strCsCd(8), _
						    	strCsCd(9), _
						    	strCsCd(10) _
						 	) 
		

		Print = Ret



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
<TITLE>人間ドック成績報告用紙</TITLE>
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
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><Font color="#0000FF">■</font>人間ドック成績報告用紙</TD>
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
	<BR>	


<!--- コース区分 -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>コース区分</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="Radio" NAME="Cskbn" VALUE="1" <%= "CHECKED" %>>１泊人間ドック</TD>
			<TD><INPUT TYPE="Radio" NAME="Cskbn" VALUE="2" >１日病院外来ドック</TD>
			<TD><INPUT TYPE="Radio" NAME="Cskbn" VALUE="3" >１日人間ドック</TD>
			<TD><INPUT TYPE="Radio" NAME="Cskbn" VALUE="4" >その他</TD>
		</TR>
	</TABLE>
	<BR>
	
<!--- コース１ -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>コース１</TD>
			<TD>：</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd1", strCsCd(1), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>
<!--- コース２ -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>コース２</TD>
			<TD>：</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd2", strCsCd(2), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>
<!--- コース３ -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>コース３</TD>
			<TD>：</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd3", strCsCd(3), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>
<!--- コース４ -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>コース４</TD>
			<TD>：</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd4", strCsCd(4), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>
<!--- コース５ -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>コース５</TD>
			<TD>：</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd5", strCsCd(5), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>
<!--- コース６ -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>コース６</TD>
			<TD>：</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd6", strCsCd(6), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>
<!--- コース７ -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>コース７</TD>
			<TD>：</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd7", strCsCd(7), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>
<!--- コース８ -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>コース８</TD>
			<TD>：</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd8", strCsCd(8), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>
<!--- コース９ -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>コース９</TD>
			<TD>：</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd9", strCsCd(9), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>
<!--- コース１０ -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>コース１０</TD>
			<TD>：</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd10", strCsCd(10), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>

	<BR>


<!--- 印刷モード -->
<%
	'印刷モードの初期設定
	strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<INPUT TYPE="hidden" NAME="mode" VALUE="0">
	</TABLE>

	<BR><BR>

<!--- 印刷ボタン -->
	<!---2006.07.04 権限管理 追加 by 李  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
		<INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="印刷する">&nbsp;
	<%  End if  %>


<!--    <INPUT TYPE="image" NAME="prevew" SRC="/webHains/images/Preview.gif" WIDTH="77" HEIGHT="24" ALT="プレビューする(印刷日を更新しません！)"> -->
 
	</BLOCKQUOTE>
<!-- 2004/01/02 DEL START DEBUG文字列削除 (NSC)Birukawa
<%= strSCslDate %>
<BR>
<%= strECslDate %>
<br>
<%= strCskbn %>
<BR>
<%=  strCsCd(1) %>
<BR>
<%=  strCsCd(2) %>
<BR>
<%=  strCsCd(3) %>
<BR>
<%=  strCsCd(4) %>
<BR>
<%=  strCsCd(5) %>
<BR>
<%=  strCsCd(6) %>
<BR>
<%=  strCsCd(7) %>
<BR>
<%=  strCsCd(8) %>
<BR>
<%=  strCsCd(9) %>
<BR>
<%=  strCsCd(10) %>
<BR>
<%= strMode %>
-->

</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>