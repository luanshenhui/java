<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		判定コメントガイド (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"     -->
<!-- #include virtual = "/webHains/includes/common.inc"           -->
<!-- #include virtual = "/webHains/includes/EditJudClassList.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc"     -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const STARTPOS = 1		'開始位置のデフォルト値

'データベースアクセス用オブジェクト
Dim objJudCmtStc		'判定コメント情報アクセス用
Dim objJudClass			'判定分類情報アクセス用
Dim objCommon			'共通関数アクセス用

Dim strJudClassCd		'検索判定分類コード
Dim strJudClassName		'検索判定分類名称
Dim strKey				'検索キー
Dim lngStartPos			'検索開始位置
Dim lngGetCount			'表示件数

'判定コメント情報
Dim strArrJudCmtCd		'判定コメントコード
Dim strArrJudCmtStc		'判定コメント文章
Dim strArrJudClassCd	'判定分類コード
Dim strArrJudClassName	'判定分類名称

Dim strDispJudCmtStc	'編集用の判定コメント文章
Dim strDispJudCmtCd		'編集用の判定コメントコード

Dim strAction			'
Dim strArrKey			'(分割後の)検索キーの集合
Dim lngAllCount			'条件を満たす全レコード件数
Dim lngCount			'レコード件数
Dim strURL				'URL文字列
Dim i, j				'インデックス
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objJudCmtStc = Server.CreateObject("HainsJudCmtStc.JudCmtStc")
Set objJudClass  = Server.CreateObject("HainsJudClass.JudClass")
Set objCommon    = Server.CreateObject("HainsCommon.Common")

'引数値の取得
strAction     = Request("act")
strJudClassCd = Request("judClassCd")
strKey        = Request("key")
lngStartPos   = Request("startPos")
lngGetCount   = Request("getCount")

'引数省略時のデフォルト値設定
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", objCommon.SelectJudCmtStcPageMaxLine, lngGetCount))

'判定分類名取得
If Not IsEmpty(strJudClassCd) Then
	Call objJudClass.SelectJudClass(strJudClassCd, strJudClassName)
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>判定コメントガイド</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 判定コメントコード・判定コメント文章のセット
function selectList( index ) {

	// 呼び元ウィンドウが存在しなければ何もしない
	if ( opener == null ) {
		return false;
	}

	// 親画面の連絡域に対し、判定コメントコード・判定コメント文章を編集(リストが単数の場合と複数の場合とで処理を振り分け)

	// 判定コメントコード
	if ( opener.jcmGuide_JudCmtCd != null ) {
		if ( document.kensakulist.judCmtCd.length != null ) {
			opener.jcmGuide_JudCmtCd = document.kensakulist.judCmtCd[ index ].value;
		} else {
			opener.cmtGuide_JudCmtCd = document.kensakulist.judCmtCd.value;
		}
	}

	// 判定コメント文章
	if ( opener.jcmGuide_JudCmtStc != null ) {
		if ( document.kensakulist.judCmtStc.length != null ) {
			opener.jcmGuide_JudCmtStc = document.kensakulist.judCmtStc[ index ].value;
		} else {
			opener.jcmGuide_JudCmtStc = document.kensakulist.judCmtStc.value;
		}
	}

	// 連絡域に設定されてある親画面の関数呼び出し
	if ( opener.jcmGuide_CalledFunction != null ) {
		opener.jcmGuide_CalledFunction();
	}

	opener.winGuideJcm = null;
	close();

	return false;
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 15px; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:window.document.entryForm.key.focus();">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<INPUT TYPE="hidden" NAME="act" VALUE="select">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">判定コメントの検索</FONT></B></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR><TD COLSPAN="2">検索条件を入力して下さい。</TD></TR>
	<TR><TD HEIGHT="5"></TD></TR>
	<TR>
		<TD><%= EditJudClassList("judClassCd", strJudClassCd, "全ての判定分類") %></TD>
		<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
		<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="document.entryForm.submit();return false" CLASS="guideItem"><IMG SRC="/webHains/images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="この条件で検索"></A>
	</TR>
</TABLE>
</FORM>
<FORM NAME="kensakulist" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<%
	Do
		If IsEmpty(strAction) Then
			Exit Do
		End If

		'検索キーを空白で分割する
		strArrKey = SplitByBlank(strKey)

		'検索条件を満たすレコード件数を取得
		lngAllCount = objJudCmtStc.SelectJudCmtStcListCount(strJudClassCd, strArrKey)

		'検索結果が存在しない場合はメッセージを編集
		If lngAllCount = 0 Then
%>
			検索条件を満たす判定コメント情報は存在しません。<BR>
			キーワードを減らす、もしくは変更するなどして、再度検索してみて下さい。<BR>
<%
			Exit Do
		End If
%>
		「<FONT COLOR="#FF6600"><B><%= IIf(strJudClassCd = "", "全ての判定分類", strJudClassName) %></B></FONT>」
		<% If strKey <> "" Then %>、「<FONT COLOR="#FF6600"><B><%= strKey %></B></FONT>」<% End If %>の検索結果は <FONT color="#FF6600"><B><%= lngAllCount %></B></FONT>件ありました。<BR><BR>
<%
		'検索条件を満たしかつ指定開始位置、件数分のレコードを取得
		lngCount = objJudCmtStc.SelectJudCmtStcList(strJudClassCd, strArrKey, lngStartPos, lngGetCount, strArrJudCmtCd, strArrJudCmtStc, strArrJudClassCd, strArrJudClassName)
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
<%
		For i = 0 to lngCount - 1

			'表示用判定コメント文章の編集
			strDispJudCmtStc = strArrJudCmtStc(i)
			strDispJudCmtCd  = strArrJudCmtCd(i)

			If strKey <> "" Then

				'検索キーに合致する部分に<B>タグを付加
				For j = 0 To UBound(strArrKey)
					strDispJudCmtStc = Replace(strDispJudCmtStc, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
					strDispJudCmtCd  = Replace(strDispJudCmtCd, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
				Next

			End If
%>
			<TR VALIGN="top">
				<TD>
					<INPUT TYPE="hidden" NAME="judCmtCd"  VALUE="<%= strArrJudCmtCd(i) %>">
					<INPUT TYPE="hidden" NAME="judCmtStc" VALUE="<%= strArrJudCmtStc(i) %>">
					<IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0">
				</TD>
				<TD NOWRAP><%= strDispJudCmtCd %></TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0"></TD>
<!--
				<TD WIDTH="500" NOWRAP><A HREF="javascript:function voi(){};voi()" ONCLICK="selectList(<%= i %>)" CLASS="guideItem"><%= strDispJudCmtStc %></A></TD>
-->
				<TD WIDTH="500" NOWRAP><A HREF="gdeSelectJudCmtStc.asp?judCmtCd=<%= strArrJudCmtCd(i) %>" CLASS="guideItem"><%= strDispJudCmtStc %></A></TD>
				<TD NOWRAP>
<%
					If strArrJudClassName(i) <> "" Then
%>
						<FONT SIZE="-1" COLOR="666666">（<%= strArrJudClassName(i) %>）</FONT>
<%
					End If
%>
				</TD>
			</TR>
<%
		Next
%>		
		</TABLE>
<%
		'ページングナビゲータの編集
%>
		<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?act=select&judClassCd=" & strJudClassCd & "&key=" & Server.URLEncode(strKey), lngAllCount, lngStartPos, lngGetCount) %>
<%
		Exit Do
	Loop
%>
</FORM>
</BODY>
</HTML>
