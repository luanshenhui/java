<% 
'-----------------------------------------------------------------------------
'		汎用情報の抽出 (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
If Request.ServerVariables("HTTP_REFERER") = "" Then
	Response.End
End If

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const COLCOUNT = 5		'検査項目の表示列数

Dim strArrSelItemName	'検査項目名

'制御用
Dim imax, jmax			'ループ回数

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'検査項目表示制御用ループ回数の計算
jmax = COLCOUNT
imax = mlngRowCount / jmax

'検査項目名称の再取得
ReDim strArrSelItemName(mlngRowCount - 1)
For i = 0 To mlngRowCount - 1
	'検査項目コードがあれば名称を取得、無ければ空白
	If Trim(mstrArrSelItemCd(i)) <> "" Then
		Call objItem.SelectItemName(mstrArrSelItemCd(i), mstrArrSelSuffix(i), strArrSelItemName(i))
	Else
		strArrSelItemName(i) = ""
	End If
Next
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>抽出データの指定</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/itmGuide.inc" -->
<!--
var lngSelectedIndex;		/* ガイド表示時に選択された検査項目のインデックス */

// 項目ガイド呼び出し
function callItmGuide( index ) {

	// 選択された情報のインデックスを退避
	lngSelectedIndex = index;

	// ガイドに引き渡すデータのセット
	itmGuide_mode     = 2;	// 依頼／結果モード　1:依頼、2:結果
	itmGuide_group    = 0;	// グループ表示有無　0:表示しない、1:表示する
	itmGuide_item     = 1;	// 検査項目表示有無　0:表示しない、1:表示する
	itmGuide_question = 1;	// 問診項目表示有無　0:表示しない、1:表示する

	// ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
	itmGuide_CalledFunction = setItmInfo;

	// 項目ガイド表示
	showGuideItm();

	return false;
}

// 検査項目のセット
function setItmInfo() {

	var itmNameElement = new Array;		/* 検査項目名を編集するエレメントの名称 */
	var itmName        = new Array;		/* 検査項目名を編集するエレメント自身 */
	var itmOK          = new Array;		/* 重複していない項目の添え字の配列 */
	var itmNG          = new Array;		/* 重複している項目の添え字の配列 */
	var okFlg;							/* 重複チェックフラグ */
	var strAlert;						/* アラートメッセージ */
	var i, j;							/* インデックス */
	var icount;							/* ループ回数 */

	// すでに選択済みの項目との重複チェック
	itmOK.length = 0; itmNG.length = 0;
	if ( itmGuide_itemCd.length > 0 ) {
		for (i = 0; i < itmGuide_itemCd.length; i++ ) {
			okFlg = true;
			j = 0;
			do {
				if ((itmGuide_itemCd[i] == document.step1.selItemCd[j].value) && (itmGuide_suffix[i] == document.step1.selSuffix[j].value)) {
					okFlg = false;
					break;
				}
				j = j + 1;
			} while (j < <%= mlngRowCount %>)
			if (okFlg) {
				itmOK[itmOK.length] = i;
			}
			else {
				itmNG[itmNG.length] = i;
			}
		}
		// 重複項目があればアラート表示
		if (itmNG.length > 0) {
			strAlert = '以下の検査項目はすでに選択されています。\n';
			for ( i = 0; i < itmNG.length; i++ ){
				strAlert = strAlert + '・' + itmGuide_itemName[itmNG[i]] + '\n';
			}
			alert(strAlert);
		}
	} else {
		return false;
	}

	icount = <%= mlngRowCount %> - lngSelectedIndex;			/* ループ回数を計算 */

	// 予め退避したインデックス先の検査項目情報に、ガイド画面で設定された連絡域の値を編集
	if ( itmGuide_itemCd.length > 0 ) {
		for (i = 0; i < icount; i++ ) {
			if (i < itmOK.length) {
				document.step1.selItemCd[lngSelectedIndex + i].value = itmGuide_itemCd[itmOK[i]];
				document.step1.selSuffix[lngSelectedIndex + i].value = itmGuide_suffix[itmOK[i]];
			}
		}
	} else {
		return false;
	}

	// ブラウザごとの検査項目名編集用エレメントの設定処理
	if ( itmGuide_itemCd.length > 0 ) {
		for ( ; ; ) {

			// エレメント名の編集
			for (i = 0; i < icount; i++) {
				if (i < itmOK.length) {
					itmNameElement[i] = 'itemname' + (lngSelectedIndex + i);
				}
			}

			// IEの場合
			if ( document.all ) {
				for (i = 0; i < icount; i++) {
					if (i < itmOK.length) {
						document.all(itmNameElement[i]).innerHTML = itmGuide_itemName[itmOK[i]];
					}
				}
				break;
			}

			// Netscape6の場合
			if ( document.getElementById ) {
				for (i = 0; i < icount; i++) {
					if (i < itmOK.length) {
						document.getElementById(itmNameElement[i]).innerHTML = itmGuide_itemName[itmOK[i]];
					}
				}
			}

			break;
		}
	}
	return false;
}

// 検査項目コード・名称のクリア
function clearItemCd( index ) {

	var itmNameElement;			/* 検査項目名を編集するエレメントの名称 */
	var itmName;				/* 検査項目名を編集するエレメント自身 */

	// hidden項目の再設定
	document.step1.selItemCd[index].value = '';
	document.step1.selSuffix[index].value = '';

	// ブラウザごとの検査項目名編集用エレメントの設定処理
	for ( ; ; ) {

		// エレメント名の編集
		itmNameElement = 'itemname' + index;

		// IEの場合
		if ( document.all ) {
			document.all(itmNameElement).innerHTML = '';
			break;
		}

		// Netscape6の場合
		if ( document.getElementById ) {
			document.getElementById(itmNameElement).innerHTML = '';
		}

		break;
	}

	return false;

}

// 再表示
function redirectPage() {

	var i;

	// 「全ての検査項目抽出」選択時のアラート
	if (document.step1.optResult[1].checked) {
		alert('全ての検査項目を抽出すると、1行あたり256列を超える可能性があります。\n' + 
			  '超えた行はExcelでは編集できませんがよろしいですか。');
	}

	// 「検査項目を指定」選択時は検査項目を引継ぎ、それ以外はリセット
	if (document.step1.optResult[2].checked) {
		document.step1.rowCountItem.value = <%= mlngRowCount %>;
		for (i = 0; i < <%= mlngRowCount %>; i++) {
			document.step1.itemCd[i].value = document.step1.selItemCd[i].value;
			document.step1.suffix[i].value = document.step1.selSuffix[i].value;
		}
	}
	else {
		document.step1.rowCountItem.value = '<%= ROWCOUNT_ITEM %>';
		for (i = 0; i < <%= ROWCOUNT_ITEM %>; i++) {
			document.step1.itemCd[i].value = '';
			document.step1.suffix[i].value = '';
		}
	}

	document.step1.step2.value = '1';
	document.step1.submit();						/* 送信 */

}

function changeItemCount() {
	document.step1.step2.value = '';
	document.step1.submit();
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.datatab  { background-color:#ffffff }
</STYLE>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="step1" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="step" VALUE="<%= mstrStep %>">

	<INPUT TYPE="hidden" NAME="rowCountItem" VALUE="<%= mlngRowCount %>">
<%
	For i = 0 To mlngRowCount - 1
%>
		<INPUT TYPE="hidden" NAME="itemCd" VALUE="">
		<INPUT TYPE="hidden" NAME="suffix" VALUE="">
<%
	Next
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="download">■</SPAN><FONT COLOR="#000000">抽出データの指定</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'メッセージの編集
	Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD BGCOLOR="#eeeeee">受診歴情報</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR>
			<TD><INPUT TYPE="checkbox" NAME="chkDate"   <%= IIf(mstrChkDate   = CHK_ON, "CHECKED", "") %>></TD>
			<TD WIDTH="70" NOWRAP>受診日</TD>
			<TD><INPUT TYPE="checkbox" NAME="chkCsCd"   <%= IIf(mstrChkCsCd   = CHK_ON, "CHECKED", "") %>></TD>
			<TD WIDTH="70" NOWRAP>コース</TD>
			<TD><INPUT TYPE="checkbox" NAME="chkAge"    <%= IIf(mstrChkAge    = CHK_ON, "CHECKED", "") %>></TD>
			<TD WIDTH="70" NOWRAP>受診時年齢</TD>
			<TD><INPUT TYPE="checkbox" NAME="chkJud"    <%= IIf(mstrChkJud    = CHK_ON, "CHECKED", "") %>></TD>
						<TD WIDTH="70" NOWRAP>総合判定</TD>
					</TR>
<!--
					<tr>
						<td><INPUT TYPE="checkbox" NAME="chkOrgCd"  <%= IIf(mstrChkOrgCd  = CHK_ON, "CHECKED", "") %>></td>
						<td width="70" nowrap>受診団体</td>
						<td><INPUT TYPE="checkbox" NAME="chkOrgBsdCd"  <%= IIf(mstrChkOrgBsdCd  = CHK_ON, "CHECKED", "") %>></td>
						<td width="70" nowrap>事業部</td>
						<td><INPUT TYPE="checkbox" NAME="chkOrgRoomCd"  <%= IIf(mstrChkOrgRoomCd  = CHK_ON, "CHECKED", "") %>></td>
						<td width="70" nowrap>室部</td>
						<td><INPUT TYPE="checkbox" NAME="chkOrgPostCd"  <%= IIf(mstrChkOrgPostCd  = CHK_ON, "CHECKED", "") %>></td>
						<td width="70" nowrap>所属</td>
					</tr>
-->
				</TABLE>
	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD BGCOLOR="#eeeeee">個人情報</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR>
			<TD><INPUT TYPE="checkbox" NAME="chkPerID"  <%= IIf(mstrChkPerID  = CHK_ON, "CHECKED", "") %>></TD>
			<TD WIDTH="70" NOWRAP>個人ＩＤ</TD>
			<TD><INPUT TYPE="checkbox" NAME="chkName"   <%= IIf(mstrChkName   = CHK_ON, "CHECKED", "") %>></TD>
			<TD WIDTH="70" NOWRAP>氏名</TD>
			<TD><INPUT TYPE="checkbox" NAME="chkBirth"  <%= IIf(mstrChkBirth  = CHK_ON, "CHECKED", "") %>></TD>
			<TD WIDTH="70" NOWRAP>生年月日</TD>
			<TD><INPUT TYPE="checkbox" NAME="chkGender" <%= IIf(mstrChkGender = CHK_ON, "CHECKED", "") %>></TD>
			<TD WIDTH="70" NOWRAP>性別</TD>
<!--			
						<td width="20" nowrap><INPUT TYPE="checkbox" NAME="chkEmpNo" <%= IIf(mstrChkEmpNo = CHK_ON, "CHECKED", "") %>></td>
						<td width="70" nowrap>従業員番号</td>
-->
		</TR>
<!--
					<tr>
						<td><INPUT TYPE="checkbox" NAME="chkPOrgCd"  <%= IIf(mstrchkPOrgCd  = CHK_ON, "CHECKED", "") %>></td>
						<td width="70" nowrap>所属団体</td>
						<td><INPUT TYPE="checkbox" NAME="chkPOrgBsdCd"  <%= IIf(mstrchkPOrgBsdCd  = CHK_ON, "CHECKED", "") %>></td>
						<td width="70" nowrap>事業部</td>
						<td><INPUT TYPE="checkbox" NAME="chkPOrgRoomCd"  <%= IIf(mstrchkPOrgRoomCd  = CHK_ON, "CHECKED", "") %>></td>
						<td width="70" nowrap>室部</td>
						<td><INPUT TYPE="checkbox" NAME="chkPOrgPostCd"  <%= IIf(mstrchkPOrgPostCd  = CHK_ON, "CHECKED", "") %>></td>
						<td width="70" nowrap>所属</td>
						<td width="20" nowrap><INPUT TYPE="checkbox" NAME="chkOverTime"  <%= IIf(mstrchkOverTime  = CHK_ON, "CHECKED", "") %>></td>
						<td width="100" nowrap>超過勤務時間</td>
					</tr>
-->
				</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD BGCOLOR="#eeeeee">検査項目</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR>
			<TD><INPUT TYPE="radio" NAME="optResult" VALUE="<%= CASE_NOTSELECT %>" <%= IIf(mstrOptResult = CASE_NOTSELECT, "CHECKED", "") %>></TD>
			<TD COLSPAN="10">検査結果を抽出しない</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="optResult" VALUE="<%= CASE_ALLSELECT %>" <%= IIf(mstrOptResult = CASE_ALLSELECT, "CHECKED", "") %>></TD>
			<TD COLSPAN="10">すべての検査結果を抽出する</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="optResult" VALUE="<%= CASE_SELECT %>"    <%= IIf(mstrOptResult = CASE_SELECT,    "CHECKED", "") %>></TD>
			<TD COLSPAN="10">抽出する項目を指定する</TD>
		</TR>
		<TR>
			<TD></TD>
			<% For j = 1 To jmax %>
				<TD BGCOLOR="#eeeeee" COLSPAN="2" NOWRAP>検査項目</TD>
			<% Next %>
		</TR>
		<% For i = 1 To imax %>
			<TR>
				<TD></TD>
				<% For j = 1 To jmax %>
					<% k = jmax * ( i - 1 ) + j - 1 %>
					<TD>
					<A HREF="javascript:function voi(){};voi()" ONCLICK="return callItmGuide(<%= k %>)"><IMG SRC="../../images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="項目ガイドを表示"  ></A>
					<A HREF="javascript:function voi(){};voi()" ONCLICK="return clearItemCd(<%= k %>)" ><IMG SRC="../../images/delicon.gif"  BORDER="0" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A>
					</TD>
					<TD WIDTH="90" NOWRAP>
						<INPUT TYPE="hidden" NAME="selItemCd" VALUE="<%= mstrArrSelItemCd(k) %>">
						<INPUT TYPE="hidden" NAME="selSuffix" VALUE="<%= mstrArrSelSuffix(k) %>">
						<SPAN  ID="itemname<%= k %>"><%= strArrSelItemName(k) %></SPAN>
					</TD>
				<% Next %>
			</TR>
		<% Next %>
		<TR>
			<TD><INPUT TYPE="checkbox" NAME="chkOption" <%= IIf(mstrChkOption = CHK_ON, "CHECKED", "") %>></TD>
			<TD COLSPAN="5">結果コメント・正常値フラグを抽出データに含む</TD>
			<TD ALIGN="right" COLSPAN="5">
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>追加検査項目を&nbsp;</TD>
						<TD>
							<SELECT NAME="rowCount">
							<% For i = 10 To 50 Step 10 %>
								<OPTION VALUE="<%= i %>" <%= IIf(i = mlngRowCount, "SELECTED", "") %>><%= i %>個
							<% Next %>
							</SELECT>
						</TD>
						<TD>
							<a href="#" onclick="return changeItemCount();"><img src="/webhains/images/b_prev.gif" width="53" height="28" alt="表示" /></a>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR>
	<input type="hidden" name="step2" value="" />
	<a href="#" onclick="return redirectPage();"><img src="/webHains/images/next.gif" width="72" height="24" alt="次へ" /></a>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>