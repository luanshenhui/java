<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	受診対象者名簿 (Ver0.0.1)
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
Dim YstrSCslYear, YstrSCslMonth, YstrSCslDay	'予約開始年月日
Dim YstrECslYear, YstrECslMonth, YstrECslDay	'予約終了年月日

Dim strCsCd									'コースコード
'Dim strSCsCd								'サブコースコード
Dim strOrgCd1, strOrgCd2					'団体コード
Dim strNotes								'コメント
Dim strOrgBsdCd, strOrgRoomCd				'事業部コード, 室部コード
Dim strSOrgPostCd, strEOrgPostCd			'開始所属コード, 終了所属コード
Dim strPerId								'個人コード
Dim strObject								'出力対象
'■■■■■■■■■■
Dim UID
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

Dim YstrSCslDate		'予約開始日
Dim YstrECslDate		'予約終了日
Dim WYstrSCslDate		'予約開始日
Dim WYstrECslDate		'予約終了日
Dim WstrSCslDate		'開始日
Dim WstrECslDate		'終了日

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
'		strSCslYear   = Year(Now())				'開始年
'		strSCslMonth  = Month(Now())			'開始月
'		strSCslDay    = Day(Now())				'開始日
          WstrSCslDate = DateAdd("M", -9, Now)
          strSCslYear = Mid(WstrSCslDate, 1, 4)
          strSCslMonth = Mid(WstrSCslDate, 6, 2)
'## 2003/12/27 Del NSC@Itoh
'          strSCslDay = Mid(WstrSCslDate, 10, 2)
	Else
		strSCslYear   = Request("strCslYear")	'開始年
		strSCslMonth  = Request("strCslMonth")	'開始月
'## 2003/12/27 Del NSC@Itoh
'		strSCslDay    = Request("strCslDay")	'開始日
	End If

'## 2003/12/27 Upd NSC@Itoh
'	strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
	strSCslDate   = strSCslYear & "/" & strSCslMonth 

'◆ 終了年月日
	If IsEmpty(Request("endCslYear")) Then
'		strECslYear   = Year(Now())				'終了年
'		strECslMonth  = Month(Now())			'開始月
'		strECslDay    = Day(Now())				'開始日
          WstrECslDate = DateAdd("M", -9, Now)
          strECslYear = Mid(WstrSCslDate, 1, 4)
          strECslMonth = Mid(WstrSCslDate, 6, 2)
'## 2003/12/27 Del NSC@Itoh
'          strECslDay = Mid(WstrSCslDate, 10, 2)
	Else
		strECslYear   = Request("endCslYear")	'終了年
		strECslMonth  = Request("endCslMonth")	'開始月
'## 2003/12/27 Del NSC@Itoh
'		strECslDay    = Request("endCslDay")	'開始日
	End If

'## 2003/12/27 Upd NSC@Itoh
'	strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
	strECslDate   = strECslYear & "/" & strECslMonth 

'◆ 開始年月日と終了年月日の大小判定と入替
'   （日付型に変換してチェックしないのは日付として誤った値であったときのエラー回避の為）
'## 2003/12/27 Upd NSC@Itoh
'	If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
'	   Right("00" & Trim(CStr(strSCslMonth)), 2) & _
'	   Right("00" & Trim(CStr(strSCslDay)), 2) _
'	 > Right("0000" & Trim(CStr(strECslYear)), 4) & _
'	   Right("00" & Trim(CStr(strECslMonth)), 2) & _
'	   Right("00" & Trim(CStr(strECslDay)), 2) Then
	If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
	   Right("00" & Trim(CStr(strSCslMonth)), 2) _
	 > Right("0000" & Trim(CStr(strECslYear)), 4) & _
	   Right("00" & Trim(CStr(strECslMonth)), 2) Then

		strSCslYear   = strECslYear
		strSCslMonth  = strECslMonth
'## 2003/12/27 Del NSC@Itoh
'		strSCslDay    = strECslDay
		strSCslDate   = strECslDate
		strECslYear   = Request("strCslYear")	'開始年
		strECslMonth  = Request("strCslMonth")	'開始月
'## 2003/12/27 Del NSC@Itoh
'		strECslDay    = Request("strCslDay")	'開始日

'## 2003/12/27 Upd NSC@Itoh
'		strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
		strECslDate   = strECslYear & "/" & strECslMonth 

	End If


'◆予約 開始年月日
	If IsEmpty(Request("YstrCslYear")) Then
'		YstrSCslYear   = Year(Now())				'開始年
'		YstrSCslMonth  = Month(Now())			'開始月
'		YstrSCslDay    = Day(Now())				'開始日
          WYstrSCslDate = DateAdd("M", -4, Now)
          YstrSCslYear = Mid(WYstrSCslDate, 1, 4)
          YstrSCslMonth = Mid(WYstrSCslDate, 6, 2)
'## 2003/12/27 Del NSC@Itoh
'          YstrSCslDay = Mid(WYstrSCslDate, 10, 2)
	Else
		YstrSCslYear   = Request("YstrCslYear")	'開始年
		YstrSCslMonth  = Request("YstrCslMonth")	'開始月
'## 2003/12/27 Del NSC@Itoh
'		YstrSCslDay    = Request("YstrCslDay")	'開始日
	End If
'## 2003/12/27 Upd NSC@Itoh
'	YstrSCslDate   = YstrSCslYear & "/" & YstrSCslMonth & "/" & YstrSCslDay
	YstrSCslDate   = YstrSCslYear & "/" & YstrSCslMonth 

'◆ 予約終了年月日
	If IsEmpty(Request("YendCslYear")) Then
'		YstrECslYear   = Year(Now())				'終了年
'		YstrECslMonth  = Month(Now())			'開始月
'		YstrECslDay    = Day(Now())				'開始日
          WYstrECslDate = DateAdd("M", +4, Now)
'## 2003/12/29 Upd Start NSC@birukawa
'          YstrECslYear = Mid(WYstrSCslDate, 1, 4)
'          YstrECslMonth = Mid(WYstrSCslDate, 6, 2)
          YstrECslYear = Mid(WYstrECslDate, 1, 4)
          YstrECslMonth = Mid(WYstrECslDate, 6, 2)
'## 2003/12/29 Upd End   NSC@birukawa
'## 2003/12/27 Del NSC@Itoh
'          YstrECslDay = Mid(WYstrSCslDate, 10, 2)
	Else
		YstrECslYear   = Request("YendCslYear")	'終了年
		YstrECslMonth  = Request("YendCslMonth")	'開始月
'## 2003/12/27 Del NSC@Itoh
'		YstrECslDay    = Request("YendCslDay")	'開始日
	End If
'## 2003/12/27 Upd NSC@Itoh
'	YstrECslDate   = YstrECslYear & "/" & YstrECslMonth & "/" & YstrECslDay
	YstrECslDate   = YstrECslYear & "/" & YstrECslMonth 

'◆ 予約開始年月日と予約終了年月日の大小判定と入替
'   （日付型に変換してチェックしないのは日付として誤った値であったときのエラー回避の為）
'## 2003/12/27 Upd NSC@Itoh
'	If Right("0000" & Trim(CStr(YstrSCslYear)), 4) & _
'	   Right("00" & Trim(CStr(YstrSCslMonth)), 2) & _
'	   Right("00" & Trim(CStr(YstrSCslDay)), 2) _
'	 > Right("0000" & Trim(CStr(YstrECslYear)), 4) & _
'	   Right("00" & Trim(CStr(YstrECslMonth)), 2) & _
'	   Right("00" & Trim(CStr(YstrECslDay)), 2) Then
	If Right("0000" & Trim(CStr(YstrSCslYear)), 4) & _
	   Right("00" & Trim(CStr(YstrSCslMonth)), 2) _
	 > Right("0000" & Trim(CStr(YstrECslYear)), 4) & _
	   Right("00" & Trim(CStr(YstrECslMonth)), 2) Then
		YstrSCslYear   = YstrECslYear
		YstrSCslMonth  = YstrECslMonth
'## 2003/12/27 Del NSC@Itoh
'		YstrSCslDay    = YstrECslDay
		YstrSCslDate   = YstrECslDate
		YstrECslYear   = Request("YstrCslYear")	'開始年
		YstrECslMonth  = Request("YstrCslMonth")	'開始月
'## 2003/12/27 Del NSC@Itoh
'		YstrECslDay    = Request("YstrCslDay")	'開始日
'## 2003/12/27 Upd NSC@Itoh
'		YstrECslDate   = YstrECslYear & "/" & YstrECslMonth & "/" & YstrECslDay
		YstrECslDate   = YstrECslYear & "/" & YstrECslMonth
	End If

	strCsCd       = Request("csCd")			'コースコード
'	strSCsCd      = Request("scsCd")		'サブコースコード

'◆ 団体
	strOrgCd1     = Request("orgCd1")		'団体コード１
	strOrgCd2     = Request("orgCd2")		'団体コード２
	If strOrgCd1 <> "" And strOrgCd2 <> "" Then
'## 2004/1/2 Upd Start (NSC)birukawa メソッド名変更
'		objOrganization.SelectlukeOrg strOrgCd1, strOrgCd2, , strOrgName
		objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , strOrgName
'## 2004/1/2 Upd End   (NSC)birukawa メソッド名変更

	End If

'◆ コメント
	strNotes     = Request("notes")			'コメント

     UID = Session("USERID")

'◆ 事業部
'◆ 室部
'◆ 所属
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
'## 2003/12/27 Del NSC@Itoh
'			If Not IsDate(strSCslDate) Then
'				.AppendArray vntArrMessage, "開始日付が正しくありません。"
'			End If
'			If Not IsDate(strECslDate) Then
'				.AppendArray vntArrMessage, "終了日付が正しくありません。"
'			End If
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

          Set objCommon = Server.CreateObject("HainsCommon.Common")
'## 2003/12/27 Upd NSC@Itoh
'		strURL = "/webHains/contents/report_form/rd_1_prtAfterPostcard.asp"
		strURL = "/webHains/contents/report_form/rd_01_prtAfterPostcard.asp"
		strURL = strURL & "?p_Uid=" & UID
'## 2003/12/27 Upd NSC@Itoh
'        strURL = strURL & "&p_ScslDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
'        strURL = strURL & "&p_EcslDate=" & objCommon.FormatString(CDate(strECslDate), "yyyy/mm/dd")
'        strURL = strURL & "&p_yscsldate=" & objCommon.FormatString(CDate(YstrSCslDate ), "yyyy/mm/dd")
'		 strURL = strURL & "&p_yecsldate=" & objCommon.FormatString(CDate(YstrECslDate ), "yyyy/mm/dd") 
        strURL = strURL & "&p_ScslDate=" & objCommon.FormatString(CDate(strSCslDate & "/01"), "yyyy/mm")
        strURL = strURL & "&p_EcslDate=" & objCommon.FormatString(CDate(strECslDate & "/01"), "yyyy/mm")
		strURL = strURL & "&p_yscsldate=" & objCommon.FormatString(CDate(YstrSCslDate & "/01"), "yyyy/mm")
		strURL = strURL & "&p_yecsldate=" & objCommon.FormatString(CDate(YstrECslDate & "/01"), "yyyy/mm") 

		Set objCommon = Nothing
        strURL = strURL & "&p_Org1=" & strOrgCd1
		strURL = strURL & "&p_Org2=" & strOrgCd2

		strURL = strURL & "&p_cmt=" & strNotes
 
		Response.Redirect strURL
		Response.End

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
<TITLE>予約確認はがき</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// エレメントの参照設定
function setNotes() {

	var wk_Notes;
	
	with ( document.entryForm ) {

		if ( NoteDiv.value == 1 ) {
			wk_Notes = ''
			wk_Notes = wk_Notes + '拝啓　貴社ますますご清祥のこととお喜び申し上げます。\n';
			wk_Notes = wk_Notes + 'いつも当院人間ドックをご利用いただきありがとうございます。\n';
			wk_Notes = wk_Notes + 'さて、先月にお受けいただいた人間ドックの請求書をお送り申し上げます。\n';
			wk_Notes = wk_Notes + 'ご確認の上、指定口座までご入金下さいますようお願い申し上げます。\n';
			wk_Notes = wk_Notes + '今後とも、より一層のご厚情を賜りますようお願い申し上げます。\n';
			wk_Notes = wk_Notes + '　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　敬具';
			Notes.value = wk_Notes;

		}

		if ( NoteDiv.value == 2 ) {
			Notes.value = '';
		}

	}

}
// エレメントの参照設定
function setElement() {

	with ( document.entryForm ) {

		// 団体・所属情報エレメントの参照設定（入力項目に団体・所属が無い場合は不要）
		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName' );


	}

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

<!--- タイトル -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■一年目はがき</SPAN></B></TD>
		</TR>
	</TABLE>
	<BR>

<!--- 日付 -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
<!-- ##2003/12/29 Upd NSC@birukawa
			<TD WIDTH="90" NOWRAP>受診日</TD>
-->
			<TD WIDTH="90" NOWRAP>受診年月</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
			<TD>月</TD>
<!-- ## 2003/12/27 Del  NSC@Itoh
			<TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
			<TD>日</TD>
-->
			<TD>～</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, False) %></TD>
			<TD>月</TD>
<!-- ## 2003/12/27 Del  NSC@Itoh
			<TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, False) %></TD>
			<TD>日</TD>
-->
		</TR>
	</TABLE>
<!--- 日付 -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
<!-- ##2003/12/29 Upd NSC@birukawa
			<TD WIDTH="90" NOWRAP>予約日</TD>
-->
			<TD WIDTH="90" NOWRAP>予約年月</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('YstrCslYear', 'YstrCslMonth', 'YstrCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("YstrCslYear", YEARRANGE_MIN, YEARRANGE_MAX, YstrSCslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("YstrCslMonth", 1, 12, YstrSCslMonth, False) %></TD>
			<TD>月</TD>
<!-- ## 2003/12/27 Del  NSC@Itoh
			<TD><%= EditNumberList("YstrCslDay", 1, 31, YstrSCslDay, False) %></TD>
			<TD>日</TD>
-->
			<TD>～</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('YendCslYear', 'YendCslMonth', 'YendCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("YendCslYear", YEARRANGE_MIN, YEARRANGE_MAX, YstrECslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("YendCslMonth", 1, 12, YstrECslMonth, False) %></TD>
			<TD>月</TD>
<!-- ## 2003/12/27 Del  NSC@Itoh
			<TD><%= EditNumberList("YendCslDay", 1, 31, YstrECslDay, False) %></TD>
			<TD>日</TD>
-->
		</TR>
	</TABLE>

<!--- 団体 -->
<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<% = strOrgCd1 %>">
<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<% = strOrgCd2 %>">
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>団体</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="orgName"><% = strOrgName %></SPAN></TD>
		</TR>
	</TABLE>
<!--コメント-->
		<TR>
			<TD ROWSPAN="2" VALIGN="TOP"><font color="black">□</font></TD>
			<TD ROWSPAN="2" VALIGN="TOP" WIDTH="90" NOWRAP>案内文</TD>
			<TD ROWSPAN="2" VALIGN="TOP">：</TD>
			<TD>
				<select name="NoteDiv" size="1" ONCHANGE="javascript:setNotes()">
					<option selected value="1">案内文１</option>
					<option value="2">案内文２</option>
				</select>
			</TD>
		</TR>
		<TR>
			<TD COLSPAN="15">
				<TEXTAREA NAME="Notes" ROWS="10" COLS="80" WRAP="SOFT"></TEXTAREA>
			</TD>
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