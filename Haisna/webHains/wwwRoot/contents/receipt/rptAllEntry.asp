<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		一括受付処理 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/EditCourseList.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const MODE_RECEIPT = "0"	'処理モード(受付)
Const MODE_CANCEL  = "1"	'処理モード(受付取り消し)
Const CSCD_ALL     = "allcourse"

'データベースアクセス用オブジェクト
Dim objConsult		'受診情報アクセス用

'引数値
Dim strReceipt		'確定ボタン押下有無
Dim lngCslYear		'受診年
Dim lngCslMonth		'受診月
Dim lngCslDay		'受診日
Dim strCsCd			'コースコード
Dim strMode			'処理モード
Dim strUseEmptyId	'空き番号の使用有無
Dim strForce		'強制フラグ

Dim lngReceiptMode	'受付処理モード
Dim strMessage		'エラーメッセージ
Dim strHTML			'HTML文字列
Dim lngCount		'処理件数

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'引数値の取得
strReceipt    = Request("receipt.x")
lngCslYear    = CLng("0" & Request("cYear") )
lngCslMonth   = CLng("0" & Request("cMonth"))
lngCslDay     = CLng("0" & Request("cDay")  )
strCsCd       = Request("csCd")
strMode       = Request("mode")
strUseEmptyId = Request("useEmptyId")
strForce      = Request("forceFlg")

'チェック・更新・読み込み処理の制御
Do

	'「確定」ボタン押下時以外は何もしない
	If strReceipt = "" Then
		Exit Do
	End If

	'受診年月日の必須チェック
	If lngCslYear + lngCslMonth + lngCslDay = 0 Then
		strMessage = "受診日を入力して下さい。"
		Exit Do
	End If

	'受診年月日の日付チェック
	If Not IsDate(lngCslYear & "/" & lngCslMonth & "/" & lngCslDay) Then
		strMessage = "受診日の入力形式が正しくありません。"
		Exit Do
	End If

'### 2003/3/9 Deleted by Ishihara@FSIT コース必須チェック解除
'	'コースの必須チェック
'	If strCsCd = "" Then
'		strMessage = "コースを選択して下さい。"
'		Exit Do
'	End If
'### 2003/3/9 Deleted End

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : コース一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strMode                取得モード
' 　　　　   (In)     strName                エレメント名
' 　　　　   (In)     strSelectedCsCd        リストにて選択すべきコースコード
' 　　　　   (In)     vntNotSelectedRowCtrl  リスト未選択行の制御
' 　　　　   (In)     blnAddRegularCourse    True指定時は全定期健診コース指定行を追加
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditCourseList(strName, strSelectedCsCd)

	Dim objCourse	'コース情報アクセス用COMオブジェクト

	Dim strCsCd		'コースコード
	Dim strCsName	'コース名
	Dim lngCount	'件数

	'オブジェクトのインスタンス作成
	Set objCourse = Server.CreateObject("HainsCourse.Course")

	'コース情報の読み込み
	lngCount = objCourse.SelectCourseList(strCsCd, strCsName, , 1)

	'サイズを１つ増やして「すべてのコース」の行を追加
	ReDim Preserve strCsCd(lngCount)
	ReDim Preserve strCsName(lngCount)
	strCsCd(lngCount)   = CSCD_ALL
	strCsName(lngCount) = "すべて"
	lngCount = lngCount + 1

	'ドロップダウンリストの編集
	EditCourseList = EditDropDownListFromArray(strName, strCsCd, strCsName, strSelectedCsCd, NON_SELECTED_ADD)

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>一括受付</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var okFlg = false;	// 画面クローズの可否

// 画面を閉じる
function closeWindow() {

	if ( okFlg ) {
		opener.location.reload();
		close();
	}
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 20px; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:closeWindow()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">

	<!-- 表題 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">一括受付</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'一括受付処理開始
	Do
		'「確定」ボタンが押されていない、またはここまででエラーが発生している場合は何もしない
		If strReceipt = "" Or strMessage <> "" Then
			Exit Do
		End If

		'処理中メッセージを表示
%>
		<BR><%= IIf(strMode = MODE_RECEIPT, "受付", "受付解除") %>処理中です．．．<BR>
<%
		Response.Flush

		'処理モードごとの分岐
		Select Case strMode

			'受付処理
			Case MODE_RECEIPT

				'一括受付
				lngReceiptMode = IIf(strUseEmptyId <> "", 2, 1)
				lngCount = objConsult.ReceiptAll(lngReceiptMode, lngCslYear, lngCslMonth, lngCslDay, 0, IIf(strCsCd = CSCD_ALL, "", strCsCd), Request.ServerVariables("REMOTE_ADDR"), Session("USERID"))

				'エラー時はメッセージを編集
				If lngCount = -14 Then
					strMessage = "発番可能な最大番号に達しました。一括受付できません。"
					Exit Do
				End If

				If lngCount < 0 Then
					strMessage = "一括受付処理で異常が発生しました。（" & lngCount & "）"
					Exit Do
				End If

			'受付解除処理
			Case MODE_CANCEL

				'一括受付取り消し
'## 2004.01.03 Mod By T.Takagi@FSIT 更新者対応
'				lngCount = objConsult.CancelReceiptAll(lngCslYear, lngCslMonth, lngCslDay, 0, IIf(strCsCd = CSCD_ALL, "", strCsCd), (strForce <> ""))
				lngCount = objConsult.CancelReceiptAll(Session("USERID"), lngCslYear, lngCslMonth, lngCslDay, 0, IIf(strCsCd = CSCD_ALL, "", strCsCd), (strForce <> ""))
'## 2004.01.03 Mod End

		End Select

		'正常であれば親画面をリロードできるよう、フラグを成立させる
%>
		<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
		<!--
		okFlg = true;
		//-->
		</SCRIPT>
<%
		Response.End

		Exit Do
	Loop

	'エラーメッセージの編集
	If strMessage <> "" THEN
		Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
		<BR>
<%
	End If
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
		<TR>
			<TD NOWRAP>受診日</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('cYear', 'cMonth', 'cDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("cYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("cMonth", 1, 12, lngCslMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("cDay", 1, 31, lngCslDay, False) %></TD>
			<TD>日</TD>
			<TD WIDTH="100%"></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>コース</TD>
			<TD>：</TD>
			<TD COLSPAN="8"><%= EditCourseList("csCd", strCsCd) %></TD>
		</TR>
	</TABLE>

	<BR>

	指定された受診日、コースに該当する全ての受診者に

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1"></TD>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="<%= MODE_RECEIPT %>" CHECKED></TD>
			<TD COLSPAN="2">当日ＩＤを割り当てる</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD><INPUT TYPE="checkbox" NAME="useEmptyId"></TD>
			<TD NOWRAP>空き番号が存在する場合、その番号で割り当てを行う</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1"></TD>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="<%= MODE_CANCEL %>"></TD>
			<TD COLSPAN="2">受付を解除する</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD><INPUT TYPE="checkbox" NAME="forceFlg"></TD>
			<TD NOWRAP>結果が入力されている場合も強制的に受付を取り消す</TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="3" ALIGN="right">
		<TR>
			<TD>
            <% '2005.08.22 権限管理 Add by 李　--- START %>
        	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %> 
                <INPUT TYPE="image" NAME="receipt" SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="この内容で確定">
            <%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 権限管理 Add by 李　--- END %>
            </TD>

			<TD><A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A></TD>
		</TR>
	</TABLE>

</FORM>
</BODY>
</HTML>
