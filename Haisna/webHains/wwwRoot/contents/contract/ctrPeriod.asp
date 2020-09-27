<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		契約情報(契約期間の設定) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const ACTMODE_BROWSE = "browse"	'動作モード(参照)

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objContract			'契約情報アクセス用
Dim objContractControl	'契約情報アクセス用
Dim objCourse			'コース情報アクセス用
Dim objOrganization		'団体情報アクセス用

'前画面から送信されるパラメータ値(新規・更新共通)
Dim strActMode			'動作モード(参照:"browse")
Dim strOpMode			'処理モード
Dim strOrgCd1			'団体コード1
Dim strOrgCd2			'団体コード2
Dim strCsCd				'コースコード

'前画面から送信されるパラメータ値(更新のみ)
Dim strCtrPtCd			'契約パターンコード

'自身をリダイレクトする場合のみ送信されるパラメータ値
Dim strNext				'「次へ」ボタン押下の有無
Dim strSave				'「保存」ボタン押下の有無

'契約期間(自身リダイレクト時に格納、或いはデータベースより取得)
Dim strStrYear			'契約開始年
Dim strStrMonth 		'契約開始月
Dim strStrDay			'契約開始日
Dim strEndYear			'契約終了年
Dim strEndMonth 		'契約終了月
Dim strEndDay			'契約終了日

'契約情報
Dim strOrgName			'団体名
Dim strCsName			'コース名
Dim dtmStrDate			'契約開始日
Dim dtmEndDate			'契約終了日
Dim strAgeCalc			'年齢起算日

'契約期間情報
Dim strArrCtrPtCd		'契約パターンコード
Dim dtmArrStrDate		'契約開始日
Dim dtmArrEndDate		'契約終了日
Dim lngCount			'契約情報数

'コース履歴情報
Dim dtmCsStrDate		'コース適用開始日付
Dim dtmCsEndDate		'コース適用終了日付
Dim lngPrice			'コース基本料金
Dim lngTax				'消費税
Dim lngCsCount			'コース履歴数

'固定団体コード
Dim strPerOrgCd1		'個人受診用団体コード1
Dim strPerOrgCd2		'個人受診用団体コード2
Dim strWebOrgCd1		'Web用団体コード1
Dim strWebOrgCd2		'Web用団体コード2

Dim lngMargin			'マージン値
Dim strStrDate			'契約開始年月日
Dim strEndDate			'契約終了年月日
Dim strMessage			'エラーメッセージ
Dim strTitle			'見出し
Dim blnExist			'契約情報の存在有無
Dim strURL				'ジャンプ先のURL
Dim strHTML				'HTML文字列
Dim Ret					'関数戻り値
Dim i					'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'セッション・権限チェック
If Request("actMode") = ACTMODE_BROWSE Then
	Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)
Else
	Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)
End If

'オブジェクトのインスタンス作成
Set objCommon          = Server.CreateObject("HainsCommon.Common")
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")
Set objCourse          = Server.CreateObject("HainsCourse.Course")
Set objOrganization    = Server.CreateObject("HainsOrganization.Organization")

'前画面から送信されるパラメータ値の取得(新規・更新共通)
strActMode = Request("actMode")
strOpMode  = Request("opMode")
strOrgCd1  = Request("orgCd1")
strOrgCd2  = Request("orgCd2")
strCsCd    = Request("csCd")

'前画面から送信されるパラメータ値の取得(更新のみ)
strCtrPtCd = Request("ctrPtCd")

'自身をリダイレクトする場合のみ送信されるパラメータ値の取得
strNext     = Request("next.x")
strSave     = Request("save.x")
strStrYear  = Request("strYear")
strStrMonth = Request("strMonth")
strStrDay   = Request("strDay")
strEndYear  = Request("endYear")
strEndMonth = Request("endMonth")
strEndDay   = Request("endDay")

'デフォルト値の設定
'## 2003.11.07 Mod 6Lines By T.Takagi@FSIT デフォルトの開始日はシステム日付
'strStrYear  = IIf(strStrYear  = "", YEARRANGE_MIN, strStrYear )
'strStrMonth = IIf(strStrMonth = "",    "1", strStrMonth)
'strStrDay   = IIf(strStrDay   = "",    "1", strStrDay  )
strStrYear  = IIf(strStrYear  = "", Year(Date),  strStrYear )
strStrMonth = IIf(strStrMonth = "", Month(Date), strStrMonth)
strStrDay   = IIf(strStrDay   = "", Day(Date),   strStrDay  )
'## 2003.11.07 Mod End
strEndYear  = IIf(strEndYear  = "", YEARRANGE_MAX, strEndYear )
strEndMonth = IIf(strEndMonth = "",   "12", strEndMonth)
strEndDay   = IIf(strEndDay   = "",   "31", strEndDay  )

'チェック・更新・読み込み処理の制御
Do
	'「次へ」「保存」ボタン押下時
	If strNext <> "" Or strSave <> "" Then

		'契約開始終了年月日チェック
		Do
			'契約開始日の必須チェック
			If strStrYear = "" And strStrMonth = "" And strStrDay = "" Then
				strMessage = "契約開始日を入力して下さい。"
				Exit Do
			End If

			'契約開始年月日の編集
			strStrDate = strStrYear & "/" & strStrMonth & "/" & strStrDay

			'契約開始年月日の日付チェック
			If Not IsDate(strStrDate) Then
				strMessage = "契約開始日の入力形式が正しくありません。"
				Exit Do
			End If

			'契約終了日が未入力であればチェック終了
			If strEndYear = "" And strEndMonth = "" And strEndDay = "" Then
				Exit Do
			End If

			'契約終了年月日の編集
			strEndDate = strEndYear & "/" & strEndMonth & "/" & strEndDay

			'契約終了年月日の日付チェック
			If Not IsDate(strEndDate) Then
				strMessage = "契約終了日の入力形式が正しくありません。"
				Exit Do
			End If

			'契約開始・終了年月日の範囲チェック
			If CDate(strStrDate) > CDate(strEndDate) Then
				strMessage = "契約開始・終了日の範囲指定が正しくありません。"
				Exit Do
			End If

			Exit Do
		Loop

		'年月日チェックにてエラーが存在する場合は処理を終了する
		If strMessage <> "" Then
			Exit Do
		End If

		'同一団体・コースにおいて既存の契約情報と契約期間が重複しないかをチェックする
		If objContract.CheckContractPeriod(strOrgCd1, strOrgCd2, strCsCd, strCtrPtCd, strStrDate, strEndDate) = True Then
			strMessage = "すでに登録済みの契約情報と契約期間が重複します。"
			Exit Do
		End If

		'「次へ」ボタン押下時(即ち新規時)
		If strNext <> "" Then

			'契約適用期間がコース適用期間に含まれるかチェック
			If objCourse.GetHistoryCount(strCsCd, strStrDate, strEndDate) <= 0 Then
				strMessage = "指定された契約期間に適用可能なコース履歴が存在しません。"
				Exit Do
			End If

			'ここまで正常であれば次画面へ遷移

			'契約情報の参照・コピーを行う場合は参照先団体の選択画面へ
			If strActMode = ACTMODE_BROWSE Then

				'個人受診、web用団体コードの取得
				objCommon.GetOrgCd ORGCD_KEY_PERSON, strPerOrgCd1, strPerOrgCd2
				objCommon.GetOrgCd ORGCD_KEY_WEB,    strWebOrgCd1, strWebOrgCd2

				'web予約の場合は直接契約情報の選択画面に遷移し、それ以外は参照先契約団体の検索画面へ
				If strOrgCd1 = strWebOrgCd1 And strOrgCd2 = strWebOrgCd2 Then
					strURL = "ctrBrowseContract.asp?opMode=" & strOpMode & "&refOrgCd1=" & strPerOrgCd1 & "&refOrgCd2=" & strPerOrgCd2 & "&"
				Else
					strURL = "ctrBrowseOrg.asp?opMode=" & strOpMode & "&"
				End If

			'新規契約作成時は負担元・負担金額の設定へ
			Else
				strURL = "ctrDemand.asp?"
			End If

			'QueryString値の編集
			strURL = strURL & "orgCd1="   & strOrgCd1   & "&"
			strURL = strURL & "orgCd2="   & strOrgCd2   & "&"
			strURL = strURL & "csCd="     & strCsCd     & "&"
			strURL = strURL & "strYear="  & strStrYear  & "&"
			strURL = strURL & "strMonth=" & strStrMonth & "&"
			strURL = strURL & "strDay="   & strStrDay   & "&"
			strURL = strURL & "endYear="  & strEndYear  & "&"
			strURL = strURL & "endMonth=" & strEndMonth & "&"
			strURL = strURL & "endDay="   & strEndDay

			'次画面へリダイレクト
			Response.Redirect strURL
			Response.End

		End If

		'以下は「保存」ボタン押下時(即ち更新時)の処理となる

		'契約期間の更新
		Ret = objContractControl.UpdatePeriod(strOrgCd1, strOrgCd2, strCsCd, strCtrPtCd, strStrDate, strEndDate)
		Select Case Ret
			Case 0
			Case 1
				strMessage = "指定された契約期間に適用可能なコース履歴が存在しません。"
				Exit Do
			Case 2
				strMessage = "すでに登録済みの契約情報と契約期間が重複します。"
				Exit Do
			Case 3
				strMessage = "契約期間の変更により、この契約情報の参照ができなくなる受診情報が発生します。変更できません。"
				Exit Do
			Case Else
				Exit Do
		End Select

		'エラーがなければ呼び元(契約情報)画面をリロードして自身を閉じる
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
		strHTML = strHTML & "<BODY ONLOAD=""JavaScript:if ( opener != null ) opener.location.reload(); close()"">"
		strHTML = strHTML & "</BODY>"
		strHTML = strHTML & "</HTML>"
		Response.Write strHTML
		Response.End

		Exit Do
	End If

	'契約パターンコード指定時(即ち更新時)
	If strCtrPtCd <> "" Then

		'契約パターン情報の読み込み
		If objContract.SelectCtrPt(strCtrPtCd, dtmStrDate, dtmEndDate, strAgeCalc) = False Then
			Err.Raise 1000, ,"契約情報が存在しません。"
		End If

		'契約開始・終了日から年月日を抽出
		strStrYear  = CStr(DatePart("yyyy", dtmStrDate))
		strStrMonth = CStr(DatePart("m",    dtmStrDate))
		strStrDay   = CStr(DatePart("d",    dtmStrDate))
		strEndYear  = CStr(DatePart("yyyy", dtmEndDate))
		strEndMonth = CStr(DatePart("m",    dtmEndDate))
		strEndDay   = CStr(DatePart("d",    dtmEndDate))

	End If

	Exit Do
Loop

'マージン値の設定
lngMargin = IIf(strActMode = ACTMODE_BROWSE, 0, 20)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>契約期間の設定</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<style type="text/css">
	td.mnttab { background-color:#FFFFFF }
	body { margin: <%= lngMargin %>px 0 0 0; }
</style>
</HEAD>
<BODY>
<%
'契約情報の参照・コピーを行う場合はナビを編集
If strActMode = ACTMODE_BROWSE Then
%>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<%
End If
%>
<FORM NAME="entryform" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>
<%
	'契約パターンコード指定時はその内容をhiddenで保持
	If strCtrPtCd <> "" Then
%>
		<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strCtrPtCd %>">
<%
	End If

	'契約情報の参照・コピーを行う場合動作モード・処理モードの値を保持
	If strActMode = ACTMODE_BROWSE Then
%>
		<INPUT TYPE="hidden" NAME="actMode" VALUE="<%= strActMode %>">
		<INPUT TYPE="hidden" NAME="opMode"  VALUE="<%= strOpMode  %>">
<%
	End If
%>
	<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
	<INPUT TYPE="hidden" NAME="csCd" VALUE="<%= strCsCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">■</SPAN><FONT COLOR="#000000">契約期間の指定</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'エラーメッセージの編集
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>
<%
	'団体名の読み込み
	If objOrganization.SelectOrgName(strOrgCd1, strOrgCd2, strOrgName) = False Then
		Err.Raise 1000, , "団体情報が存在しません。"
	End If

	'コース名の読み込み
	If objCourse.SelectCourse(strCsCd, strCsName) = False Then
		Err.Raise 1000, , "コース情報が存在しません。"
	End If
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD>契約団体</TD>
			<TD>：</TD>
			<TD><B><%= strOrgName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>対象コース</TD>
			<TD>：</TD>
			<TD><B><%= strCsName %></B></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'処理方法に応じたメッセージを編集する
%>
	<FONT COLOR="#cc9999">●</FONT><%= IIf(strActMode = ACTMODE_BROWSE, "コピーする契約情報を適用する", "") %>契約期間を指定して下さい。<BR>
	<FONT COLOR="#cc9999">●</FONT>すでに登録されている契約情報の契約期間にまたがる日付指定はできません。<BR><BR>

	<TABLE BORDER="0" CELLPADDING="" CELLSPACING="2">
		<TR>
			<TD>契約開始日：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditSelectNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, CLng("0" & strStrYear))  %></TD>
			<TD>年</TD>
			<TD><%= EditSelectNumberList("strMonth",   1,   12, CLng("0" & strStrMonth)) %></TD>
			<TD>月</TD>
			<TD><%= EditSelectNumberList("strDay",     1,   31, CLng("0" & strStrDay))   %></TD>
			<TD>日</TD>
		</TR>
		<TR>
			<TD>契約終了日：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditSelectNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, CLng("0" & strEndYear)) %></TD>
			<TD>年</TD>
			<TD><%= EditSelectNumberList("endMonth", 1, 12, CLng("0" & strEndMonth)) %></TD>
			<TD>月</TD>
			<TD><%= EditSelectNumberList("endDay", 1, 31, CLng("0" & strEndDay)) %></TD>
			<TD>日</TD>
		</TR>
	</TABLE>

	<BR><BR>
<%
	'現契約情報の契約期間読み込み
	lngCount = objContract.SelectCtrMngWithPeriod(strOrgCd1, strOrgCd2, strCsCd, strArrCtrPtCd, dtmArrStrDate, dtmArrEndDate)

	'新規・契約期間の変更ごとに応じた見出しの編集
	strTitle = strCsName & "の" & IIf(strCtrPtCd = "", "現在", "その他") & "の契約情報："

	'契約情報の存在有無を判定
	'(新規作成時は1件でも存在すれば、という判定で良いが、契約期間変更時は先に読み込んだ契約期間情報に必ず現在編集中の契約情報が含まれる。
	'故に契約期間情報が1件しかない場合、それは現在編集中の契約情報と一致するため、その考慮をここで行う。)
	blnExist = IIf(strCtrPtCd = "", (lngCount > 0), (lngCount > 1))

	'契約期間が存在する場合の編集処理
	If blnExist Then
%>
		<%= strTitle %>
		<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
			<TR BGCOLOR="#cccccc">
				<TD>契約期間</TD>
			</TR>
<%
			'契約期間一覧の編集
			For i = 0 To lngCount - 1

				'現在編集中契約情報以外の契約期間を編集する
				If strArrCtrPtCd(i) <> strCtrPtCd Then
%>
					<TR BGCOLOR="#eeeeee">
						<TD><%= dtmArrStrDate(i) %>～<%= dtmArrEndDate(i) %></TD>
					</TR>
<%
				End If

			Next
%>
		</TABLE>
<%
	'契約期間が存在しない場合
	Else
%>
		<%= strTitle %>なし
<%
	End If
%>
	<BR><BR>
<%
	'コース履歴の読み込み
	lngCsCount = objCourse.SelectCourseHistory(strCsCd, 0, 0, dtmCsStrDate, dtmCsEndDate, lngPrice, lngTax)
%>
	コースの履歴：
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
		<TR BGCOLOR="#cccccc">
			<TD NOWRAP>適用期間</TD>
<!--
			<TD ALIGN="right"><IMG SRC="/webHains/images/spacer.gif" WIDTH="85" HEIGHT="1"><BR>基本料金</TD>
			<TD ALIGN="right"><IMG SRC="/webHains/images/spacer.gif" WIDTH="85" HEIGHT="1"><BR>消費税</TD>
-->
		</TR>
<%
		'コース一覧の編集
		For i = 0 To lngCsCount - 1
%>
			<TR BGCOLOR="#eeeeee">
				<TD><%= dtmCsStrDate(i) %>～<%= dtmCsEndDate(i) %></TD>
<!--
				<TD ALIGN="right"><%= FormatCurrency(lngPrice(i)) %></TD>
				<TD ALIGN="right"><%= FormatCurrency(lngTax(i)) %></TD>
-->
			</TR>
<%
		Next
%>
	</TABLE>

	<BR><BR>
<%
	'契約パターンコード未指定時は「戻る」「次へ」ボタンを配置
	If strCtrPtCd = "" Then
%>
		<A HREF="JavaScript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>
		<INPUT TYPE="image" NAME="next" SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="次へ">
<%
	'契約パターンコード指定時は「保存」「キャンセル」ボタンを配置
	Else
%>
		<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A>

        <% '2005.08.22 権限管理 Add by 李　--- START %>
    	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
		    <INPUT TYPE="image" NAME="save" SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存">
        <%  else    %>
             &nbsp;
        <%  end if  %>
        <% '2005.08.22 権限管理 Add by 李　--- END %>

<%
	End If
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
