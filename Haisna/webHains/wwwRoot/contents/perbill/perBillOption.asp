<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		受診セット変更 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objConsult		'受診情報アクセス用

'引数値
Dim lngRsvNo		'予約番号
Dim strCslDate		'受診日
Dim strPerId		'個人ＩＤ
Dim strCtrPtCd		'契約パターンコード
Dim strCslDivCd		'受診区分コード
Dim strOptCd		'オプションコード
Dim strOptBranchNo	'オプション枝番
Dim strConsults		'受診要否

Dim strMessage		'エラーメッセージ
Dim strHTML			'HTML文字列
Dim Ret				'関数戻り値
Dim i				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
lngRsvNo       = CLng("0" & Request("rsvNo"))
strCslDate     = Request("cslDate")
strPerId       = Request("perId")
strCtrPtCd     = Request("ctrPtCd")
strCslDivCd    = Request("cslDivCd")
strOptCd       = ConvIStringToArray(Request("optCd"))
strOptBranchNo = ConvIStringToArray(Request("optBranchNo"))
strConsults    = ConvIStringToArray(Request("consults"))

'保存ボタン押下時
If Not IsEmpty(Request("save.x")) Then

	'保存処理
	Set objConsult = Server.CreateObject("HainsConsult.Consult")

	'受診オプション管理レコードの更新
	Ret = objConsult.UpdateConsult_O(lngRsvNo, strCtrPtCd, strOptCd, strOptBranchNo, strConsults, Request.ServerVariables("REMOTE_ADDR"), Session("USERID"), Session("IGNORE"), strMessage)

	Set objConsult = Nothing

	'エラーがなければ呼び元画面をリロードして自身を閉じる
	If Ret > 0 Then
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
		strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
		strHTML = strHTML & "</BODY>"
		strHTML = strHTML & "</HTML>"
		Response.Write strHTML
		Response.End
	End If

'初期表示時
Else

	Set objConsult = Server.CreateObject("HainsConsult.Consult")

	'受診情報読み込み
	objConsult.SelectConsult lngRsvNo, 0, strCslDate, strPerId, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , strCtrPtCd, , , , , , , , , , , , strCslDivCd

	'現在の受診オプション検査読み込み
	objConsult.SelectConsult_O lngRsvNo, strOptCd, strOptBranchNo

	Set objConsult = Nothing

	'受診すべきオプションが存在する場合
	If IsArray(strOptCd) Then

		'読み込んだ全てのオプションの受診要否を「受診する」に設定
		strConsults = Array()
		ReDim Preserve strConsults(UBound(strOptCd))
		For i = 0 To UBound(strConsults)
			strConsults(i) = "1"
		Next

	End If

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>受診セット変更</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var lngSelectedIndex;  // ガイド表示時に選択されたエレメントのインデックス

// 保存前に現在の選択状態から受診要否を設定する
function setConsults() {

	var objForm = document.entryForm;

	var arrOptCd;		// オプションコード
	var arrOptBranchNo;	// オプション枝番
	var arrConsults;	// 受診要否

	var selOptCd;		// オプションコード

	// オプション検査の受診状態を取得する
	arrOptCd       = new Array();
	arrOptBranchNo = new Array();
	arrConsults    = new Array();

	// 全エレメントを検索
	for ( var i = 0; i < objForm.elements.length; i++ ) {

		// チェックボックス、ラジオボタン以外はスキップ
		if ( objForm.elements[ i ].type != 'checkbox' && objForm.elements[ i ].type != 'radio' ) {
			continue;
		}

		// カンマでコードと枝番を分離してオプションコードを追加
		selOptCd = objForm.elements[ i ].value.split(',');
		arrOptCd[ arrOptCd.length ]             = selOptCd[ 0 ];
		arrOptBranchNo[ arrOptBranchNo.length ] = selOptCd[ 1 ];

		// チェック状態により受診要否を設定
		arrConsults[ arrConsults.length ] = objForm.elements[ i ].checked ? '1' : '0';

	}

	// submit用の項目へ編集
	objForm.optCd.value       = arrOptCd;
	objForm.optBranchNo.value = arrOptBranchNo;
	objForm.consults.value    = arrConsults;

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" ONSUBMIT="javascript:setConsults()">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN>受診セット変更</B></TD>
	</TR>
</TABLE>
<%
If Request("act") = "saveend" Then
	EditMessage "保存が完了しました。", MESSAGETYPE_NORMAL
Else
	If strMessage <> "" Then
		EditMessage strMessage, MESSAGETYPE_WARNING
	End If
End If
%>
<BR>
<INPUT TYPE="image" NAME="save" SRC="../../images/save.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="保存する"><BR><BR>
<INPUT TYPE="hidden" NAME="rsvNo"       VALUE="<%= lngRsvNo    %>">
<INPUT TYPE="hidden" NAME="cslDate"     VALUE="<%= strCslDate  %>">
<INPUT TYPE="hidden" NAME="perId"       VALUE="<%= strPerId    %>">
<INPUT TYPE="hidden" NAME="ctrPtCd"     VALUE="<%= strCtrPtCd  %>">
<INPUT TYPE="hidden" NAME="cslDivCd"    VALUE="<%= strCslDivCd %>">
<INPUT TYPE="hidden" NAME="optCd"       VALUE="">
<INPUT TYPE="hidden" NAME="optBranchNo" VALUE="">
<INPUT TYPE="hidden" NAME="consults"    VALUE="">
<% EditSet() %>
</FORM>
</BODY>
</HTML>
<%
Sub EditSet()

	Dim objContract			'契約情報アクセス用

	'オプション検査情報
	Dim strArrOptCd			'オプションコード
	Dim strArrOptBranchNo	'オプション枝番
	Dim strOptName			'オプション名
	Dim strOptSName			'オプション名
	Dim strSetColor			'セットカラー
	Dim strConsult			'受診要否
	Dim strBranchCount		'オプション枝番数
	Dim strAddCondition		'追加条件
	Dim strHideRpt			'受付画面非表示
	Dim lngCount			'オプション検査数

	Dim blnConsult			'受診チェックの要否
	Dim strChecked			'チェックボックスのチェック状態

	Dim strPrevOptCd		'直前レコードのオプションコード
	Dim lngOptGrpSeq		'オプショングループのSEQ値
	Dim strElementType		'オプション選択用のエレメント種別
	Dim strElementName		'オプション選択用のエレメント名
	Dim lngOptIndex			'編集したオプションのインデックス
	Dim i, j				'インデックス

	Set objContract = Server.CreateObject("HainsContract.Contract")

	'指定契約パターンの全オプション検査を取得
	lngCount = objContract.SelectCtrPtOptFromConsult(strCslDate, strCslDivCd, strCtrPtCd, strPerId, , , , True, False, strArrOptCd, strArrOptBranchNo, strOptName, strOptSName, strSetColor, , , , , strBranchCount, strAddCondition, , , strHideRpt)

	Set objContract = Nothing
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR BGCOLOR="#eeeeee" ALIGN="center">
			<TD COLSPAN="5" NOWRAP>検査セット名</TD>
			<TD NOWRAP>受診条件</TD>
		</TR>
<%
		'読み込んだオプション検査情報の検索
		For i = 0 To lngCount - 1

			'受付画面表示対象であれば
			If strHideRpt(i) = "" Then

				'直前レコードとオプションコードが異なる場合
				If strArrOptCd(i) <> strPrevOptCd Then

					'まず編集するエレメントを設定する(枝番数が１つならチェックボックス、さもなくばラジオボタン選択)
					strElementType = IIf(CLng(strBranchCount(i)) = 1, "checkbox", "radio")

					'オプション編集用のエレメント名を定義する
					lngOptGrpSeq   = lngOptGrpSeq + 1
					strElementName = "opt_" & CStr(lngOptGrpSeq)

				End If

				'受診チェック要否の判定開始
				blnConsult = False

				'引数指定時
				If IsArray(strOptCd) And IsArray(strOptBranchNo) Then

					'引数指定されたオプションに対してチェックをつける
					For j = 0 To UBound(strOptCd)
						If strOptCd(j) = strArrOptCd(i) And strOptBranchNo(j) = strArrOptBranchNo(i) And strConsults(j) = "1" Then
							blnConsult = True
							Exit For
						End If
					Next

				End If

				'直前レコードとオプションコードが異なる場合はセパレータを編集
				If strPrevOptCd <> "" And strArrOptCd(i) <> strPrevOptCd Then
%>
					<TR><TD HEIGHT="3"></TD></TR>
<%
				End If

				strChecked = IIf(blnConsult, " CHECKED", "")
%>
				<TR>
					<TD><INPUT TYPE="<%= strElementType %>" NAME="<%= strElementName %>" VALUE="<%= strArrOptCd(i) & "," & strArrOptBranchNo(i) %>"<%= strChecked %>></TD>
					<TD NOWRAP><%= strArrOptCd(i) %></TD>
					<TD NOWRAP><%= "-" & strArrOptBranchNo(i) %></TD>
					<TD NOWRAP>：</TD>
					<TD NOWRAP><FONT COLOR="<%= strSetColor(i) %>">■</FONT><%= strOptName(i) %></TD>
					<TD ALIGN="center"><%= IIf(strAddCondition(i) = "1", "任意", "") %></TD>
				</TR>
<%
				lngOptIndex = lngOptIndex + 1

				'現レコードのオプションコードを退避
				strPrevOptCd = strArrOptCd(i)

			End If

		Next
%>
	</TABLE>
<%
End Sub
%>
