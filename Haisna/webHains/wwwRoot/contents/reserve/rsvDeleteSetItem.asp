<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		予約情報詳細(セット内項目の削除) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objConsult			'受診情報アクセス用
Dim objContract			'契約情報アクセス用

'引数値
Dim strRsvNo			'予約番号
Dim strCtrPtCd			'契約パターンコード
Dim strOptCd			'オプションコード
Dim strOptBranchNo		'オプション枝番
Dim strItemCd			'検査項目コード
Dim strConsults			'受診状態("1":受診、"0":未受診)

'検査項目情報
Dim strArrItemCd		'検査項目コード
Dim strArrRequestName	'依頼項目名
Dim strArrConsults		'受診状態("1":受診、"0":未受診)
Dim lngCount			'レコード数

Dim strOptName			'オプション名
Dim strHTML				'HTML文字列
Dim i, j				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objConsult  = Server.CreateObject("HainsConsult.Consult")
Set objContract = Server.CreateObject("HainsContract.Contract")

'引数値の取得
strRsvNo       = Request("rsvNo")
strCtrPtCd     = Request("ctrPtCd")
strOptCd       = Request("optCd")
strOptBranchNo = Request("optBranchNo")
strItemCd      = ConvIStringToArray(Request("itemCd"))
strConsults    = ConvIStringToArray(Request("consults"))

'保存ボタン押下時
If Not IsEmpty(Request("save.x")) Then

	'受診時検査項目テーブル更新
	objConsult.SetConsult_I strRsvNo, Request.ServerVariables("REMOTE_ADDR"), Session("USERID"), strItemCd, strConsults

	'エラーがなければ自身を閉じる
	strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
	strHTML = strHTML & "<BODY ONLOAD=""javascript:close()"">"
	strHTML = strHTML & "</BODY>"
	strHTML = strHTML & "</HTML>"
	Response.Write strHTML
	Response.End

End If

'指定予約番号の受診情報に対し、指定契約パターン・オプションにおける検査項目の受診状態を取得
lngCount = objContract.SelectCtrPtOptItem(strRsvNo, strCtrPtCd, strOptCd, strOptBranchNo, strArrItemCd, strArrRequestName, strArrConsults)

'引数に受診状態が渡されている場合
If Not IsEmpty(strItemCd) Then

	'先に読み込んだ検査項目と引数にて渡された受診状態とのマッチング(マッチしない項目については読み込んだ受診状態を適用)
	For i = 0 To lngCount - 1
		For j = 0 To UBound(strItemCd)
			If strItemCd(j) = strArrItemCd(i) Then
				strArrConsults(i) = strConsults(j)
				Exit For
			End If
		Next
	Next

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>セット内項目の削除</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// チェック時の制御
function checkItem( index, checkBox ) {

	var objConsults;	// 受診状態用エレメント

	// 検査項目が単数、複数の場合による制御
	if ( document.entryForm.itemCd.length == null ) {
		objConsults = document.entryForm.consults;
	} else {
		objConsults = document.entryForm.consults[ index ];
	}

	// 受診状態の編集
	objConsults.value = checkBox.checked ? '1' : '0';

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="rsvNo"       VALUE="<%= strRsvNo       %>">
	<INPUT TYPE="hidden" NAME="ctrPtCd"     VALUE="<%= strCtrPtCd     %>">
	<INPUT TYPE="hidden" NAME="optCd"       VALUE="<%= strOptCd       %>">
	<INPUT TYPE="hidden" NAME="optBranchNo" VALUE="<%= strOptBranchNo %>">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN>セット内項目の削除</B></TD>
		</TR>
	</TABLE>
<%
	'契約パターンオプション管理情報読み込み
	objContract.SelectCtrPtOpt strCtrPtCd, strOptCd, strOptBranchNo, strOptName
%>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
		<TR>
			<TD HEIGHT="35" WIDTH="100%" NOWRAP>検査セット名：<FONT COLOR="#FF6600"><B><%= strOptName %></B></FONT></TD>
<%
			'検査項目が存在する場合のみ保存ボタンを用意する
			If lngCount > 0 Then
%>
                <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                    <TD><INPUT TYPE="image" NAME="save" SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存"></A></TD>
                <%  end if  %>
<%
			End If
%>
			<TD><A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A></TD>
		</TR>
	</TABLE>
	<FONT COLOR="#cc9999">●</FONT>セット内受診項目の一覧を表示しています。<BR>
	<FONT COLOR="#cc9999">●</FONT>受診を行わない項目については<INPUT TYPE="checkbox" CHECKED>マークを外して下さい。<BR><BR>
<%
	Do

		'セット内項目が存在しない場合
		If lngCount <= 0 Then
%>
			このセットの受診項目は存在しません。
<%
			Exit Do
		End If
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
			<TR>
				<TD></TD>
				<TD WIDTH="50%"></TD>
				<TD></TD>
				<TD WIDTH="50%"></TD>
			</TR>
<%
			'セット内項目の編集
			i = 0
			Do
%>
				<TR>
<%
				'１行辺り２検査項目を編集
				For j = 1 To 2
%>
					<TD><INPUT TYPE="hidden" NAME="itemCd" VALUE="<%= strArrItemCd(i) %>"><INPUT TYPE="hidden" NAME="consults" VALUE="<%= strArrConsults(i) %>"><INPUT TYPE="checkbox" ONCLICK="checkItem(<%= i %>,this)"<%= IIf(strArrConsults(i) = "1", " CHECKED", "") %>></TD>
					<TD NOWRAP><%= strArrRequestName(i) %></TD>
<%
					i = i + 1
					If i >= lngCount Then
						Exit For
					End If

				Next

				If i >= lngCount Then
%>
					</TR>
<%
					Exit Do
				End If

			Loop
%>
		</TABLE>
<%
		Exit Do
	Loop
%>
</FORM>
</BODY>
</HTML>
