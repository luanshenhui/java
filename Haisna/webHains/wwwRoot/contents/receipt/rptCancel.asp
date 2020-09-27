<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		受付処理 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const MODE_CANCELRECEIPT      = "cancelreceipt"			'処理モード(受付取り消し)
Const MODE_CANCELRECEIPTFORCE = "cancelreceiptforce"	'処理モード(強制受付取り消し)
Const CALLED_FROMDETAIL       = "detail"				'呼び元画面(予約詳細)
Const CALLED_FROMLIST         = "list"					'呼び元画面(受診者一覧)
Const CALLED_FROMBCD          = "bcd"					'呼び元画面(バーコード受付)

'データベースアクセス用オブジェクト
Dim objCommon		'共通クラス
Dim objConsult		'受診情報アクセス用

'引数値
Dim strCalledFrom	'呼び元画面("detail":予約詳細、"list":受診者一覧)
Dim strActMode		'「確定」ボタンが押下された場合"1"
Dim lngRsvNo		'予約番号
Dim strCslYear		'受診年
Dim strCslMonth 	'受診月
Dim strCslDay		'受診日
Dim strForce		'強制フラグ

'受診情報
Dim strPerId		'個人ＩＤ
Dim strCslDate		'受診年月日
Dim strCsCd			'コースコード
Dim strCsName		'コース名
Dim strLastName		'姓
Dim strFirstName	'名
Dim strLastKName	'カナ姓
Dim strFirstKName	'カナ名
Dim strBirth		'生年月日
Dim strAge			'受診時年齢
Dim strGender		'性別
Dim strDayId		'当日ID(初日のIDとなる)

Dim strMessage		'エラーメッセージ
Dim strHTML			'HTML文字列
Dim Ret				'関数戻り値

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'引数値の取得
strCalledFrom = Request("calledFrom")
strActMode    = Request("actMode")
lngRsvNo      = Request("rsvNo")
strCslYear    = Request("cslYear")
strCslMonth   = Request("cslMonth")
strCslDay     = Request("cslDay")
strForce      = Request("forceFlg")

'チェック・更新・読み込み処理の制御
Do

	'「確定」ボタン押下時以外は何もしない
	If strActMode = "" Then
		Exit Do
	End If

	'受診者一覧またはバーコード受付画面から呼ばれた時以外は何もしない
	If strCalledFrom <> CALLED_FROMLIST And strCalledFrom <> CALLED_FROMBCD Then
		Exit Do
	End If

	'受付取り消し処理
'## 2004.01.03 Mod By T.Takagi@FSIT 更新者対応
'	Ret = objConsult.CancelReceipt(lngRsvNo, strCslYear, strCslMonth, strCslDay, strMessage, (strForce <> ""))
	Ret = objConsult.CancelReceipt(lngRsvNo, Session("USERID"), strCslYear, strCslMonth, strCslDay, strMessage, (strForce <> ""))
'## 2004.01.03 Mod End
	If Ret <= 0 Then
		Exit Do
	End If

	'エラーがなければ呼び元(受診者一覧)画面をリロードして自身を閉じる
	strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"

	If strCalledFrom = CALLED_FROMLIST Then
		strHTML = strHTML & "<BODY ONLOAD=""JavaScript:if ( opener != null ) opener.location.reload(); close()"">"
	Else
		strHTML = strHTML & "<BODY ONLOAD=""JavaScript:if ( opener != null ) opener.location.href = '/webHains/contents/receipt/rptBarcode.asp'; close()"">"
	End If

	strHTML = strHTML & "</BODY>"
	strHTML = strHTML & "</HTML>"
	Response.Write strHTML
	Response.End

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>受付の取り消し</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 受付取り消し
function cancelReceipt() {

	var myForm = document.entryForm;	// 自画面のフォームエレメント

	// 予約詳細画面から呼ばれた場合
	if ( myForm.calledFrom.value == '<%= CALLED_FROMDETAIL %>' ) {

		// 予約情報詳細画面のsubmit処理
		if ( myForm.forceFlg.checked ) {
			opener.top.submitForm('<%= MODE_CANCELRECEIPTFORCE %>');
		} else {
			opener.top.submitForm('<%= MODE_CANCELRECEIPT %>');
		}

		close();
		return;

	}

	// 受診者一覧またはバーコード受付画面から呼ばれた場合
	if ( myForm.calledFrom.value == '<%= CALLED_FROMLIST %>' || myForm.calledFrom.value == '<%= CALLED_FROMBCD %>' ) {

		// submit処理
		myForm.submit();

	}

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<INPUT TYPE="hidden" NAME="calledFrom" VALUE="<%= strCalledFrom %>">
	<INPUT TYPE="hidden" NAME="actMode"    VALUE="1">
	<INPUT TYPE="hidden" NAME="rsvNo"      VALUE="<%= lngRsvNo %>">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">受付の取り消し</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	If strMessage <> "" Then

		EditMessage strMessage, MESSAGETYPE_WARNING
%>
		<BR>
<%
	End If

	'受診情報の読み込み
	If objConsult.SelectConsult(lngRsvNo, 0, strCslDate, strPerId, strCsCd, strCsName, , , , , , _
								strAge, , , , , , , , , , , , , _
								strDayId, , , , , , , , , , , , , , , , , , _
								strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGender) = False Then
		Err.Raise 1000,,"受診情報が存在しません。"
	End If
%>
	<INPUT TYPE="hidden" NAME="cslYear"  VALUE="<%= Year(CDate(strCslDate))  %>">
	<INPUT TYPE="hidden" NAME="cslMonth" VALUE="<%= Month(CDate(strCslDate)) %>">
	<INPUT TYPE="hidden" NAME="cslDay"   VALUE="<%= Day(CDate(strCslDate))   %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %></B></FONT></TD>
			<TD><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
		</TR>
		<TR>
			<TD><%= strPerId %></TD>
			<TD NOWRAP><B><%= strLastName %>　<%= strFirstName %></B> （<FONT SIZE="-1"><%= strLastKName %>　<%= strFirstKName %></FONT>）</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><%= objCommon.FormatString(strBirth, "ge.m.d") %>生<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1"><%= IIf(CLng(strGender) = GENDER_MALE, "男性", "女性") %></TD>
		</TR>
	</TABLE>

	<BR><B>この受診者の受付を取り消します。</B><BR><BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD><INPUT TYPE="checkbox" NAME="forceFlg" VALUE="1" <%= IIf(strForce = "1", "CHECKED", "") %>></TD>
			<TD NOWRAP>結果が入力されている場合も強制的に受付を取り消す</TD>
		</TR>
	</TABLE>

	<BR><BR>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="3" ALIGN="right">
		<TR>
			<TD>
            <% '2005.08.22 権限管理 Add by 李　--- START %>
           	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>  
                <A HREF="JavaScript:cancelReceipt()"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="受付を取り消す"></A>
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
