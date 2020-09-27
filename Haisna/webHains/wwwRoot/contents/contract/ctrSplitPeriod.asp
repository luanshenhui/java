<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		契約情報(契約期間の分割) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objContract			'契約情報アクセス用
Dim objContractControl	'契約情報アクセス用
Dim objCourse			'コース情報アクセス用
Dim objOrganization		'団体情報アクセス用

'前画面から送信されるパラメータ値
Dim strOrgCd1			'団体コード1
Dim strOrgCd2			'団体コード2
Dim strCtrPtCd			'契約パターンコード

'契約期間(自身リダイレクト時に格納)
Dim strYear				'分割年
Dim strMonth 			'分割月
Dim strDay				'分割日

'契約管理情報
Dim strOrgName			'団体名
Dim strCsCd				'コースコード
Dim strCsName			'コース名
Dim dtmStrDate			'契約開始日
Dim dtmEndDate			'契約終了日

Dim strDate				'分割日
Dim strStrDate			'契約開始年月日
Dim strEndDate			'契約終了年月日
Dim strMessage			'エラーメッセージ
Dim strURL				'ジャンプ先のURL
Dim strHTML				'HTML文字列
Dim Ret					'関数戻り値
Dim i					'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon          = Server.CreateObject("HainsCommon.Common")
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")
Set objCourse          = Server.CreateObject("HainsCourse.Course")
Set objOrganization    = Server.CreateObject("HainsOrganization.Organization")

'前画面から送信されるパラメータ値の取得
strOrgCd1  = Request("orgCd1")
strOrgCd2  = Request("orgCd2")
strCtrPtCd = Request("ctrPtCd")

'自身をリダイレクトする場合のみ送信されるパラメータ値の取得
strYear  = Request("year")
strMonth = Request("month")
strDay   = Request("day")

'チェック・更新・読み込み処理の制御
Do
	'保存ボタン押下時
	If Not IsEmpty(Request("save.x")) Then

		'分割日チェック
		Do
			'契約開始日の必須チェック
			If strYear = "" And strMonth = "" And strDay = "" Then
				strMessage = "分割日を入力して下さい。"
				Exit Do
			End If

			'契約開始年月日の編集
			strDate = strYear & "/" & strMonth & "/" & strDay

			'分割日の日付チェック
			If Not IsDate(strDate) Then
				strMessage = "適用開始日の入力形式が正しくありません。"
				Exit Do
			End If

			Exit Do
		Loop

		'年月日チェックにてエラーが存在する場合は処理を終了する
		If strMessage <> "" Then
			Exit Do
		End If

		'契約期間の更新
		Ret = objContractControl.Split(strOrgCd1, strOrgCd2, strCtrPtCd, strDate)
		Select Case Ret
			Case 0
			Case 1
				strMessage = "この契約情報は分割できません。"
				Exit Do
			Case 2
				strMessage = "分割日は必ず契約期間内の日付で指定して下さい。"
				Exit Do
'## 2004.01.27 Add By T.Takagi@FSIT 分割日以降に受付情報があれば分割不可
			Case 3
				strMessage = "分割日以降に受付済み受診情報が存在します。分割できません。"
				Exit Do
'## 2004.01.27 Add End
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

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>契約期間の分割</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryform" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="orgCd1"  VALUE="<%= strOrgCd1  %>">
	<INPUT TYPE="hidden" NAME="orgCd2"  VALUE="<%= strOrgCd2  %>">
	<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strCtrPtCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">■</SPAN><FONT COLOR="#000000">契約期間の分割</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'エラーメッセージの編集
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)

	'契約情報の読み込み
	If objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate) = False Then
		Err.Raise 1000, ,"契約情報が存在しません。"
	End If

	'編集用の契約開始日設定
	If Not IsEmpty(dtmStrDate) Then
		strStrDate = FormatDateTime(dtmStrDate, 1)
	End If

	'編集用の契約終了日設定
	If Not IsEmpty(dtmEndDate) Then
		strEndDate = FormatDateTime(dtmEndDate, 1)
	End If
%>
	<BR>

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
			<TD NOWRAP>対象コース</TD>
			<TD>：</TD>
			<TD><B><%= strCsName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>契約期間</TD>
			<TD>：</TD>
			<TD NOWRAP><B><%= strStrDate %>～<%= strEndDate %></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD><FONT COLOR="#cc9999">●</FONT></TD>
			<TD COLSPAN="7">この契約期間を分割する分割日を指定して下さい。</TD>
		</TR>
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>（例）</TD>
			<TD></TD>
			<TD>契約期間</TD>
			<TD>：</TD>
			<TD ALIGN="right" NOWRAP>2001年</TD>
			<TD ALIGN="right" NOWRAP>4月</TD>
			<TD ALIGN="right" NOWRAP>1日</TD>
			<TD>～</TD>
			<TD ALIGN="right" NOWRAP>2002年</TD>
			<TD ALIGN="right" NOWRAP>&nbsp;&nbsp;3月</TD>
			<TD ALIGN="right" NOWRAP>&nbsp;31日</TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD COLSPAN="3"></TD>
			<TD NOWRAP>分割日</TD>
			<TD>：</TD>
			<TD ALIGN="right" NOWRAP>2001年</TD>
			<TD ALIGN="right" NOWRAP>9月</TD>
			<TD ALIGN="right" NOWRAP>30日</TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD COLSPAN="3"></TD>
			<TD NOWRAP>分割後の契約期間</TD>
			<TD>：</TD>
			<TD ALIGN="right" NOWRAP>2001年</TD>
			<TD ALIGN="right" NOWRAP>4月</TD>
			<TD ALIGN="right" NOWRAP>1日</TD>
			<TD>～</TD>
			<TD ALIGN="right" NOWRAP>2001年</TD>
			<TD ALIGN="right" NOWRAP>9月</TD>
			<TD ALIGN="right" NOWRAP>30日</TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD COLSPAN="5"></TD>
			<TD ALIGN="right" NOWRAP>2001年</TD>
			<TD ALIGN="right" NOWRAP>10月</TD>
			<TD ALIGN="right" NOWRAP>1日</TD>
			<TD>～</TD>
			<TD ALIGN="right" NOWRAP>2002年</TD>
			<TD ALIGN="right" NOWRAP>3月</TD>
			<TD ALIGN="right" NOWRAP>31日</TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="" CELLSPACING="2">
		<TR>
			<TD>分割日：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('year', 'month', 'day')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditSelectNumberList("year", 2000, YEARRANGE_MAX, CLng("0" & strYear) ) %></TD>
			<TD>年</TD>
			<TD><%= EditSelectNumberList("month",1,      12, CLng("0" & strMonth)) %></TD>
			<TD>月</TD>
			<TD><%= EditSelectNumberList("day",  1,      31, CLng("0" & strDay)  ) %></TD>
			<TD>日</TD>
		</TR>
	</TABLE>

	<BR><BR>

	<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A>

    <% '2005.08.22 権限管理 Add by 李　--- START %>
   	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
    	<INPUT TYPE="image" NAME="save" SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存">
    <%  else    %>
         &nbsp;
    <%  end if  %>
    <% '2005.08.22 権限管理 Add by 李　--- END %>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
