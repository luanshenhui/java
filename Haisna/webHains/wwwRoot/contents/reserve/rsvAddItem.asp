<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		予約情報詳細(その他追加検査) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strRowCount		'表示行数
Dim lngCancelFlg	'キャンセルフラグ

Dim i				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
Const ROWCOUNT = "5"	'表示行数のデフォルト値

'パラメータ値の取得
strRowCount  = Request("rowCount")
lngCancelFlg = CLng("0" & Request("cancelFlg"))

strRowCount = IIf(CLng("0" & strRowCount) = 0, ROWCOUNT, strRowCount)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>オプション検査</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/itmGuide.inc" -->
<!--
var cslDiv;		// 項目区分
var cslCd;		// 項目コード
var cslName;	// 項目名称
var editFlg;	// 修正区分

// 予約詳細画面に格納されているその他追加検査情報を格納
cslDiv  = top.main.document.entryForm.cslDiv.value.split(',');
cslCd   = top.main.document.entryForm.cslCd.value.split(',');
cslName = top.main.document.entryForm.cslName.value.split(',');
editFlg = top.main.document.entryForm.editFlg.value.split(',');

// 項目ガイド呼び出し
function callItemGuide() {

	itmGuide_mode     = 1;	// 依頼／結果モード　1:依頼、2:結果
	itmGuide_group    = 1;	// グループ表示有無　0:表示しない、1:表示する
	itmGuide_item     = 1;	// 検査項目表示有無　0:表示しない、1:表示する
	itmGuide_question = 0;	// 問診項目表示有無　0:表示しない、1:表示する

	// ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
	itmGuide_CalledFunction = setGrpItem;

	// 項目ガイド表示
	showGuideItm();
}

// リストの編集
function setGrpItem() {

	var myForm = document.entryForm;	// 自画面のフォームエレメント
	var cslNameElement;					// エレメント名
	var i, j;							// インデックス

	// ガイドにて選択された項目を検索
	for ( i = 0; i < itmGuide_dataDiv.length; i++ ) {

		// 自画面のエレメントを検索
		for ( j = 0; j < myForm.cslDiv.length; j++ ) {

			// すでに存在する項目が選択されている場合は検索終了
			if ( itmGuide_dataDiv[i] == myForm.cslDiv[j].value && itmGuide_itemCd[i] == myForm.cslCd[j].value ) {
				break;
			}

			// 項目未編集行を検索した場合
			if ( myForm.cslDiv[j].value == '' && myForm.cslCd[j].value == '' ) {

				// 項目分類・コードの編集
				myForm.cslDiv[j].value = itmGuide_dataDiv[i];
				myForm.cslCd[j].value  = itmGuide_itemCd[i];

				// 項目名の編集
				document.getElementById('cslName' + j).innerHTML = itmGuide_itemName[i];

				break;
			}

		}

	}

}

// 表示行数の変更
function changeRow() {

	// 現在の入力内容を詳細画面のエレメント値として編集する
	top.setAddItemToMain();

	// 表示行数を変更して再表示
	location.replace('<%= Request.ServerVariables("SCRIPT_NAME") %>?rowCount=' + document.entryForm.rowCount.value)
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 10px; }
</style>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideItm()">
<FORM NAME="entryForm" action="#">
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
		<TR>
			<TD WIDTH="100%">
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
					<TR>
						<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">その他追加検査</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
<%
			'非キャンセル者の場合のみガイド表示可能とする
			If lngCancelFlg = CONSULT_USED Then
%>
				<TD ALIGN="center">&nbsp;<A HREF="JavaScript:callItemGuide()"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="項目ガイドを表示"></A></TD>
<%
			End If
%>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR BGCOLOR="#eeeeee">
			<TD WIDTH="200">名称</TD>
			<TD>指示</TD>
		</TR>
<%
		For i = 0 To CLng(strRowCount) - 1
%>
			<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
				document.write('<INPUT TYPE="hidden" NAME="cslDiv" VALUE="' + (cslDiv[<%= i %>] == null ? '' : cslDiv[<%= i %>]) + '">');
				document.write('<INPUT TYPE="hidden" NAME="cslCd"  VALUE="' + (cslCd[<%= i %>]  == null ? '' : cslCd[<%= i %>] ) + '">');
			</SCRIPT>
			<TR>
				<TD>
					<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
						document.write('<SPAN ID="cslName<%= i %>" STYLE="position:relative">');
						document.write((cslName[<%= i %>] == null ? '' : cslName[<%= i %>] ));
						document.write('</SPAN>');
					</SCRIPT>
				</TD>
				<TD>
					<SELECT NAME="editFlg" <%= IIf(lngCancelFlg <> CONSULT_USED, "DISABLED", "") %>>
						<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
							switch ( editFlg[<%= i %>] ) {
								case '0':
									document.write('<OPTION VALUE="1">追加');
									document.write('<OPTION VALUE="2">削除');
									document.write('<OPTION VALUE="0" SELECTED>この指示を取り消す');
									break;
								case '1':
									document.write('<OPTION VALUE="1" SELECTED>追加');
									document.write('<OPTION VALUE="2">削除');
									document.write('<OPTION VALUE="0">この指示を取り消す');
									break;
								case '2':
									document.write('<OPTION VALUE="1">追加');
									document.write('<OPTION VALUE="2" SELECTED>削除');
									document.write('<OPTION VALUE="0">この指示を取り消す');
									break;
								default:
									document.write('<OPTION VALUE="1">追加');
									document.write('<OPTION VALUE="2">削除');
									document.write('<OPTION VALUE="0">この指示を取り消す');
							}
						</SCRIPT>
					</SELECT>
				</TD>
			</TR>
<%
		Next
%>
		<TR>
			<TD COLSPAN="3" HEIGHT="1" BGCOLOR="#cccccc"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
		</TR>
		<TR>
			<TD ALIGN="right" COLSPAN="3">
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
						<TD></TD>
						<TD NOWRAP>追加検査項目を</TD>
						<TD>
							<SELECT NAME="rowCount" <%= IIf(lngCancelFlg <> CONSULT_USED, "DISABLED", "") %>>
<%
							For i = 5 To 50 Step 5
%>
								<OPTION VALUE="<%= i %>" <%= IIf(i = CLng(strRowCount), "SELECTED", "") %>><%= i %>個
<%
							Next
%>
							</SELECT>
						</TD>
<%
						'非キャンセル者の場合のみ表示ボタンにアンカーを用意する
						If lngCancelFlg = CONSULT_USED Then
%>
							<TD><A HREF="JavaScript:changeRow()"><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示"></A></TD>
<%
						Else
%>
							<TD><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示"></TD>
<%
						End If
%>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

</FORM>
</BODY>
</HTML>
