<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   受診者の検索  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objConsult			'受診クラス

'パラメータ
Dim strCslDate			'受診日
Dim strPerId			'個人ID
Dim lngLineNo			'選択位置
Dim strKey				'検索キー

Dim dtmStrDate			'受診日(自)
Dim dtmEndDate			'受診日(至)
Dim lngArrPrtField		'出力項目の配列
Dim lngSortKey			'ソートキー

'受診情報
Dim strArrRsvNo			'予約番号の配列
Dim strArrCancelFlg		'キャンセルフラグの配列
Dim strArrCslDate		'受診日の配列
Dim strArrPerId			'個人IDの配列
Dim strArrOrgSName		'団体略称の配列
Dim strArrRsvDate		'予約日の配列
Dim strArrAge			'年齢の配列
Dim strArrDayId			'当日IDの配列
Dim strArrWebColor		'コース名表示色の配列
Dim strArrCsName		'コース名の配列
Dim strArrName			'氏名の配列
Dim strArrKanaName		'カナ氏名の配列
Dim strArrBirth			'生年月日の配列
Dim strArrGender		'性別の配列
Dim strArrAddDiv		'追加検査区分の配列
Dim strArrAddName		'追加検査名の配列
Dim strArrRequestName	'検査項目名の配列
Dim strArrIsrSign		'健保記号の配列
Dim strArrIsrNo			'健保番号の配列
Dim strArrSubCsWebColor	'サブコースのwebカラーの配列
Dim strArrSubCsName		'サブコース名の配列
Dim strArrEntry			'結果入力状態の配列
Dim strArrRsvStatus		'予約状況の配列
Dim strArrCardPrintDate	'確認はがき出力日の配列
Dim strArrFormPrintDate	'一式書式出力日の配列
Dim strArrRsvGrpName	'予約群名称の配列
Dim strArrCompPerId		'同伴者個人IDの配列
Dim lngCount			'レコード件数

'## 2003.11.26 Add By T.Takagi@FSIT 自分自身はカウントしてはいけない
Dim lngCount2			'件数
'## 2003.11.26 Add End

Dim i, j				'カウンタ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objConsult		= Server.CreateObject("HainsConsult.Consult")

'引数値の取得
strCslDate			= Request("csldate")
strPerId			= Request("perid")
strKey				= Request("key")

Do
	dtmStrDate = CDate(strCslDate)
	dtmEndDate = 0
	lngArrPrtField = Array(2,4,5,6,10,17,39)
	lngSortKey = lngArrPrtField(0)
	lngSortKey = 11

	'受診情報の読み込み
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者の追加
	lngCount = objConsult.SelectDailyList( _
				   strKey,             dtmStrDate,          dtmEndDate,        _
				   "",                 "",                  "",                  "",                _
				   "",                 "",                  lngArrPrtField,    _
				   lngSortKey,         0,                   0,                   0,                 _
				   strArrRsvNo,        strArrCancelFlg,     strArrCslDate,       strArrPerId,       _
				   strArrOrgSName,     strArrRsvDate,       strArrAge,         _
				   strArrDayId,        strArrWebColor,      strArrCsName,      _
				   strArrName,         strArrKanaName,      strArrBirth,         strArrGender,      _
				   strArrAddDiv,       strArrAddName,       strArrRequestName,                      _
				   strArrIsrSign,      strArrIsrNo,         strArrSubCsWebColor, strArrSubCsName,   _
				   strArrEntry,        strArrRsvStatus,     strArrCardPrintDate, strArrFormPrintDate, _
				   strArrRsvGrpName,   ,                    ,                    ,                  _
				   strArrCompPerId _
			   )
'## 2004/01/20 Add End
	If lngCount < 0 Then
		Err.Raise 1000, , "受診情報が存在しません。（キー= " & strCslDate & " 受診日= " & strCslDate & " )"
	End If


	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>受診者の検索</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 受診者の選択
function selectFriends( index ) {
	var openerForm = opener.document.entryForm;
	var myForm = document.entryForm;
	var i;

// ## 2003.11.26 Add By T.Takagi@FSIT １件だとエラー
	if ( myForm.s_rsvno.length == null ) {

		// 重複チェック
		for ( i = 0; i < openerForm.f_rsvno.length; i++ ) {
			if ( openerForm.f_rsvno[i].value == myForm.s_rsvno.value ) {
				alert( 'すでに選択されています' );
				return;
			}
		}

		// 受診者情報のセット
		openerForm.f_csldate[opener.SelectLineNo].value = <%= strCslDate %>;
		openerForm.f_rsvno[opener.SelectLineNo].value   = myForm.s_rsvno.value;
		openerForm.f_perid[opener.SelectLineNo].value   = myForm.s_perid.value;
		openerForm.f_orgname[opener.SelectLineNo].value = myForm.s_orgname.value;
		openerForm.f_csname[opener.SelectLineNo].value  = myForm.s_csname.value;
		openerForm.f_name[opener.SelectLineNo].value    = myForm.s_name.value;
		openerForm.f_kname[opener.SelectLineNo].value   = myForm.s_kname.value;
		openerForm.f_rsvgrpname[opener.SelectLineNo].value   = myForm.s_rsvgrpname.value;
// ## 2004.01.20 Add By K.Kagawa@FFCS 同伴者設定の追加
		openerForm.comporg[opener.SelectLineNo].value   = myForm.s_compperid.value;
		openerForm.compnew[opener.SelectLineNo].value   = myForm.s_compperid.value;
// ## 2004.01.20 Add End

		// お連れ様リストの再表示
		opener.dispFriendsList();

		opener.winGuide = null;
		close();

		return;
	}
// ## 2003.11.26 Add End

	// 重複チェック
	for( i=0; i<openerForm.f_rsvno.length; i++ ) {
		if( openerForm.f_rsvno[i].value == myForm.s_rsvno[index].value) {
			alert( "すでに選択されています" );
			return;
		}
	}

	// 受診者情報のセット
	openerForm.f_csldate[opener.SelectLineNo].value = <%= strCslDate %>;
	openerForm.f_rsvno[opener.SelectLineNo].value   = myForm.s_rsvno[index].value;
	openerForm.f_perid[opener.SelectLineNo].value   = myForm.s_perid[index].value;
	openerForm.f_orgname[opener.SelectLineNo].value = myForm.s_orgname[index].value;
	openerForm.f_csname[opener.SelectLineNo].value  = myForm.s_csname[index].value;
	openerForm.f_name[opener.SelectLineNo].value    = myForm.s_name[index].value;
	openerForm.f_kname[opener.SelectLineNo].value   = myForm.s_kname[index].value;
	openerForm.f_rsvgrpname[opener.SelectLineNo].value   = myForm.s_rsvgrpname[index].value;
// ## 2004.01.20 Add By K.Kagawa@FFCS 同伴者設定の追加
	openerForm.comporg[opener.SelectLineNo].value   = myForm.s_compperid[index].value;
	openerForm.compnew[opener.SelectLineNo].value   = myForm.s_compperid[index].value;
// ## 2004.01.20 Add End

	// お連れ様リストの再表示
	opener.dispFriendsList();

	opener.winGuide = null;
	close();

	return;
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" ONLOAD="javascript:document.entryForm.key.focus();">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="csldate" VALUE="<%= strCslDate %>">
	<INPUT TYPE="hidden" NAME="perid"   VALUE="<%= strPerId %>">
	<!-- タイトルの表示 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">受診者の検索</FONT></B></TD>
		</TR>
	</TABLE>
	<BR>
	<!-- 検索条件の表示 -->
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="326">
		<TR HEIGHT="20">
			<TD WIDTH="10" ROWSPAN="2"></TD>
			<TD NOWRAP>受診日</TD>
			<TD>：</TD>
			<TD><B><%= strCslDate %></B></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>キー</TD>
			<TD>：</TD>
			<TD NOWRAP><INPUT TYPE="text" NAME="key" SIZE="24" VALUE="<%= strKey %>"></TD>
			<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="document.entryForm.submit();return false;"><IMG SRC="../../images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="この条件で検索"></A></TD>
		</TR>
	</TABLE>
	<BR>
	<!-- 検索件数結果の表示 -->
<%
'## 2003.11.26 Add By T.Takagi@FSIT 自分自身はカウントしてはいけない
	For i = 0 To lngCount - 1
		If strPerId <> strArrPerId(i) Then
			lngCount2 = lngCount2 + 1
		End If
	Next
'## 2003.11.26 Add End
%>
<%
'## 2003.11.26 Mod By T.Takagi@FSIT 自分自身はカウントしてはいけない
'	If lngCount = 0 Then
	If lngCount2 = 0 Then
'## 2003.11.26 Mod End
		Response.Write "検索条件を満たす受診情報は存在しません。 <BR>"
'## 2003.11.26 Add By T.Takagi@FSIT
		Response.Write "</FORM></BODY></HTML>"
		Response.End
'## 2003.11.26 Add End
	Else
%>
		「<FONT COLOR="#ff6600"><B><%= objCommon.FormatString(strCslDate, "yyyy年m月d日") %></B></FONT>」の受診者一覧を表示しています。<BR>
<!-- ## 2003.11.26 Add By T.Takagi@FSIT -->
<!--
		対象受診者は <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>人です。 <BR>
-->
		対象受診者は <FONT COLOR="#ff6600"><B><%= lngCount2 %></B></FONT>人です。 <BR>
<!-- ## 2003.11.26 Add End -->
<%
	End If
%>
	<BR>
	<!-- 検索件数結果一覧の表示 -->
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
		<TR BGCOLOR="#cccccc">
			<TD NOWRAP>対象予約番号</TD>
			<TD NOWRAP>受診コース</TD>
			<TD NOWRAP>個人氏名</TD>
		</TR>
<%
	j=0
	For i = 0 To lngCount - 1
		If strPerId <> strArrPerId(i) Then
%>
		<TR BGCOLOR="#<%= IIf(j Mod 2 = 0, "ffffff", "eeeeee") %>">
			<TD NOWRAP><A HREF="../Reserve/rsvMain.asp?rsvNo=<%= strArrRsvNo(i) %>" TARGET="_blank"><%= strArrRsvNo(i) %></A></TD>
			<TD NOWRAP><FONT COLOR="#<%= strArrWebColor(i) %>">■</FONT><%= strArrCsName(i) %></TD>
			<TD NOWRAP><A HREF="JavaScript:selectFriends(<%= j %>)"><%= strArrName(i) %><FONT SIZE="-1" COLOR="#666666">（<%= strArrKanaName(i) %>）</FONT></A></TD>

			<INPUT TYPE="hidden" NAME="s_rsvno"   VALUE="<%= strArrRsvNo(i) %>">
			<INPUT TYPE="hidden" NAME="s_perid"   VALUE="<%= strArrPerId(i) %>">
			<INPUT TYPE="hidden" NAME="s_orgname" VALUE="<%= strArrOrgSName(i) %>">
			<INPUT TYPE="hidden" NAME="s_csname"  VALUE="<%= strArrCsName(i) %>">
			<INPUT TYPE="hidden" NAME="s_name"    VALUE="<%= strArrName(i) %>">
			<INPUT TYPE="hidden" NAME="s_kname"   VALUE="<%= strArrKanaName(i) %>">
			<INPUT TYPE="hidden" NAME="s_rsvgrpname" VALUE="<%= strArrRsvGrpName(i) %>">
			<INPUT TYPE="hidden" NAME="s_compperid"  VALUE="<%= strArrCompPerId(i) %>">
		</TR>
<%
			j = j + 1
		End If
	Next
%>
	</TABLE>
<!-- ## 2003.11.26 Add By T.Takagi@FSIT -->
<!--
	<BR>
	<BR>
	<BR>
	</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="ffffff">.</FONT></DIV>
-->
</FORM>
<!-- ## 2003.11.26 Add End -->
</BODY>
</HTML>
