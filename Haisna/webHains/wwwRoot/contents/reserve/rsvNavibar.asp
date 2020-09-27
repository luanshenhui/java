<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		予約情報詳細(ナビバー) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const MODE_SAVE          = "save"			'処理モード(保存)
Const MODE_CANCEL        = "cancel"			'処理モード(受付取り消し)
Const MODE_CANCELRECEIPT = "cancelreceipt"	'処理モード(受付取り消し)
Const MODE_DELETE        = "delete"			'処理モード(削除)
Const MODE_RESTORE       = "restore"		'処理モード(復元)

'データベースアクセス用オブジェクト
Dim objConsult		'受診情報アクセス用

'引数値
Dim strRsvNo		'予約番号

Dim strCancelFlg	'キャンセルフラグ
Dim strCslDate		'受診日
Dim strDayId		'当日ＩＤ
Dim Ret				'関数戻り値

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strRsvNo = Request("rsvNo")

'予約番号が指定されている場合
If strRsvNo <> "" Then

	Set objConsult = Server.CreateObject("HainsConsult.Consult")

	'受診情報読み込み
	Ret = objConsult.SelectConsult(strRsvNo, strCancelFlg, strCslDate, , , , , , , , , , , , , , , , , , , , , , strDayId)

	Set objConsult = Nothing

	If Ret = False Then
		Err.Raise 1000, ,"受診情報が存在しません。"
	End If

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>ナビゲーションバー</TITLE>
<STYLE TYPE="text/css">
<!--
td.rsvtab { background-color:#FFFFFF }
-->
</STYLE>
<!-- #include virtual = "/webHains/includes/noteGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// ウィンドウハンドル
var winCalendar;		// 空き枠検索カレンダー画面
var winCancel;			// キャンセル画面
var winCancelReceipt;	// 受付取り消し画面
var winReceipt;			// 受付画面
var winFriends;			// お連れ様情報画面
var winVisit;			// 来院画面
// ## 2004/04/20 Add By T.Takagi@FSIT 受診日一括変更
var winChangeDate;		// 受診日一括変更画面
// ## 2004/04/20 Add End

// お連れ様情報画面呼び出し
function callFriendWindow() {

	var opened = false;	// 画面が開かれているか
	var url;			// URL文字列

	// すでにガイドが開かれているかチェック
	if ( winFriends != null ) {
		if ( !winFriends.closed ) {
			opened = true;
		}
	}

	// URL編集
	url = '/webHains/contents/friends/editFriends.asp';
	url = url + '?rsvno=<%= strRsvNo %>';

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winFriends.focus();
	} else {
		winFriends = open( url, '', 'width=950,height=550,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}

// 来院画面呼び出し
function callVisitWindow() {

	var opened = false;	// 画面が開かれているか
	var url;			// URL文字列

	// すでにガイドが開かれているかチェック
	if ( winVisit != null ) {
		if ( !winVisit.closed ) {
			opened = true;
		}
	}

	// URL編集
	url = '/webHains/contents/raiin/ReceiptMain.asp';
	url = url + '?rsvno=<%= strRsvNo %>';

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winVisit.focus();
	} else {
		winVisit = open( url, '', 'width=700,height=650,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}

// カレンダー検索画面呼び出し
function callCalendar() {

	var arrOptCd, arrOptBranchNo;	// オプションコード・枝番
	var opened = false;				// 画面が開かれているか

	// すでにガイドが開かれているかチェック
	if ( winCalendar != null ) {
		if ( !winCalendar.closed ) {
			opened = true;
		}
	}

	// 画面が開かれている場合は一旦閉じる
	if ( opened ) {
		winCalendar.close();
	}

	// 空のウィンドウを開く
	winCalendar = window.open('', 'cal', 'status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no,width=700,height=500');

	// オプション検査画面の受診情報を取得する
	arrOptCd       = new Array();
	arrOptBranchNo = new Array();
	top.convOptCd( top.opt.document.optList, arrOptCd, arrOptBranchNo );

	// 引数指定
	var paraForm = document.paramForm;
	var mainForm = top.main.document.entryForm;
	var optForm  = top.opt.document.entryForm;
	paraForm.cslYear.value     = mainForm.cslYear.value;
	paraForm.cslMonth.value    = mainForm.cslMonth.value;
	paraForm.perId.value       = mainForm.perId.value;
	paraForm.orgCd1.value      = mainForm.orgCd1.value;
	paraForm.orgCd2.value      = mainForm.orgCd2.value;
	paraForm.csCd.value        = mainForm.csCd.value;
	paraForm.cslDivCd.value    = mainForm.cslDivCd.value;
	paraForm.rsvGrpCd.value    = mainForm.rsvGrpCd.value;
	paraForm.ctrPtCd.value     = optForm.ctrPtCd.value;
	paraForm.optCd.value       = arrOptCd;
	paraForm.optBranchNo.value = arrOptBranchNo;
<% '## 2003.12.12 Add By T.Takagi@FSIT 現在日を渡す %>
	paraForm.curCslYear.value  = mainForm.cslYear.value;
	paraForm.curCslMonth.value = mainForm.cslMonth.value;
	paraForm.curCslDay.value   = mainForm.cslDay.value;
<% '## 2003.12.12 Add End %>

	// 引数、ターゲットを指定してsubmit
	paraForm.target = 'cal';
	paraForm.submit();

}

// カレンダー画面にて選択された日付および検索された予約群の編集
function setDate( year, month, day, rsvGrpCd, noContract ) {

	// 詳細画面の日付を更新
	var mainForm = top.main.document.entryForm;
	mainForm.cslYear.value  = year;
	mainForm.cslMonth.value = month;
	mainForm.cslDay.value   = day;

	// 予約群を更新
	if  ( rsvGrpCd != '' ) {
		mainForm.selRsvGrpCd.value = rsvGrpCd;
		mainForm.rsvGrpCd.value    = rsvGrpCd;
	}

//	// 契約情報の異なる日付を選択した場合、受診日チェックおよびセットのリロードを行う
//	if ( noContract != null ) {
//
//		top.main.checkDateChanged();
//
//	} else {
//
//		// １次健診歴の内容をクリアする
//		top.main.clearFirstCslInfo();
//
//		// 現表示中の健診歴一覧画面を閉じる
//		top.main.closeConsultWindow();
//
//		// リピータ割引セット制御のための画面読み込み
//		var cslDate = year + '/' + month + '/' + day;
//		var hasRepeaterSet  = top.main.repInfo.hasRepeaterSet.value;
//		var repeaterConsult = top.main.repInfo.repeaterConsult.value;
//		top.replaceCslList( cslDate, mainForm.cslDivCd.value, top.opt.document.entryForm.ctrPtCd.value, mainForm.perId.value, mainForm.gender.value, mainForm.birth.value, hasRepeaterSet, repeaterConsult );
//
//	}

	top.main.checkDateChanged();


}

// キャンセル画面呼び出し
function callCancelWindow() {

	var opened = false;	// 画面が開かれているか
	var url;			// キャンセル画面のURL

	// すでにガイドが開かれているかチェック
	if ( winCancel != null ) {
		if ( !winCancel.closed ) {
			opened = true;
		}
	}

	// キャンセル画面のURL編集
	url = 'rsvCancel.asp';

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winCancel.focus();
	} else {
		winCancel = open( url, '', 'width=500,height=200,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}

// 受付取り消し画面呼び出し
function callCancelReceiptWindow() {

	var opened = false;	// 画面が開かれているか
	var url;			// 受付取り消し画面のURL

	// すでにガイドが開かれているかチェック
	if ( winCancelReceipt != null ) {
		if ( !winCancelReceipt.closed ) {
			opened = true;
		}
	}

	// 受付取り消し画面のURL編集
	url = '/webHains/contents/receipt/rptCancel.asp';
	url = url + '?calledFrom=detail';
	url = url + '&rsvNo=<%= strRsvNo %>';

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winCancelReceipt.focus();
	} else {
		winCancelReceipt = open( url, '', 'width=500,height=385,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}

// 受診歴一覧表示
function callDayliListWindow() {

	// 個人ＩＤの取得
	var curPerId = top.main.document.entryForm.perId.value;
	if ( curPerId == '' ) {
		return;
	}

	var mainForm = top.main.document.entryForm;	// メイン画面のフォームエレメント

	// URL編集
	var url = '/webHains/contents/common/dailyList.asp';
	url = url + '?navi='     + '1';
	url = url + '&key='      + 'ID:' + curPerId;
	url = url + '&strYear='  + '1970';
	url = url + '&strMonth=' + '1';
	url = url + '&strDay='   + '1';
	url = url + '&endYear='  + mainForm.cslYear.value;
	url = url + '&endMonth=' + mainForm.cslMonth.value;
	url = url + '&endDay='   + mainForm.cslDay.value;
	url = url + '&sortKey='  + '12';
	url = url + '&sortType=' + '1';

	open( url );

}

// 受付画面呼び出し
function callReceiptWindow() {

	var opened   = false;						// 画面が開かれているか
	var mainForm = top.main.document.entryForm;	// メイン画面のフォームエレメント
	var optForm  = top.opt.document.entryForm;	// オプション検査画面のフォームエレメント
	var url;									// 受付画面のURL

	// 入力チェック
	if ( !top.checkValue( 0 ) ) {
		return;
	}

	// すでにガイドが開かれているかチェック
	if ( winReceipt != null ) {
		if ( !winReceipt.closed ) {
			opened = true;
		}
	}

	// 受付画面のURL編集
	url = '/webHains/contents/receipt/rptEntryFromDetail.asp';
	url = url + '?calledFrom=detail';
	url = url + '&perId='    + mainForm.perId.value;
	url = url + '&csCd='     + mainForm.csCd.value;
	url = url + '&cslYear='  + mainForm.cslYear.value;
	url = url + '&cslMonth=' + mainForm.cslMonth.value;
	url = url + '&cslDay='   + mainForm.cslDay.value;
	url = url + '&ctrPtCd='  + optForm.ctrPtCd.value;

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winReceipt.focus();
		winReceipt.location.replace( url );
	} else {
		winReceipt = open( url, '', 'width=500,height=385,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}

// 受診情報の削除
function deleteConsult() {

	// 確認メッセージの表示
	if ( !confirm('このキャンセル情報を完全に削除します。よろしいですか？') ) return;

	// submit処理
	top.submitForm('<%= MODE_DELETE %>');

}

// 復元処理
function restoreConsult() {

	// 確認メッセージの表示
	if ( !confirm('このキャンセル情報を予約状態に戻します。よろしいですか？') ) return;

	// submit処理
	top.submitForm('<%= MODE_RESTORE %>');
}

// 保存処理
function saveConsult() {

	// 入力チェック
	if ( !top.checkValue( 0 ) ) return;

	// 確認メッセージの表示
	if ( !confirm('この内容で受診情報を保存します。よろしいですか？') ) return;

	// submit処理
	top.submitForm('<%= MODE_SAVE %>');
}

// 受付画面を閉じる
function closeReceiptWindow() {

	// 受付画面を閉じる
	if ( winReceipt != null ) {
		if ( !winReceipt.closed ) {
			winReceipt.close();
		}
	}

	winReceipt = null;

}

// 予約状況
function showCapacityList() {

	var objForm  = top.main.document.entryForm;
	var cslYear  = parseInt(objForm.cslYear.value);
	var cslMonth = parseInt(objForm.cslMonth.value);
	var cslDay   = parseInt(objForm.cslDay.value);
	var gender   = objForm.gender.value;

	if ( !top.isDate( cslYear, cslMonth, cslDay ) ) {
		alert('受診日の入力形式が正しくありません。');
		return;
	}

	var url = '/webHains/contents/maintenance/capacity/mntCapacityList.asp';
	url = url + '?cslYear='  + cslYear;
	url = url + '&cslMonth=' + cslMonth;
	url = url + '&cslDay='   + cslDay;
	url = url + '&gender='   + gender;
// ## 2004.02.13 Mod By Ishihara@FSIT
//	url = url + '&mode='     + 'all';
	url = url + '&mode='     + 'disp';
// ## 2004.02.13 Mod End
	open( url );

}

// サブ画面を閉じる
function closeWindow() {

	// お連れ様情報画面を閉じる
	if ( winFriends != null ) {
		if ( !winFriends.closed ) {
			winFriends.close();
		}
	}

	// 来院画面を閉じる
	if ( winVisit != null ) {
		if ( !winVisit.closed ) {
			winVisit.close();
		}
	}

	// キャンセル画面を閉じる
	if ( winCancel != null ) {
		if ( !winCancel.closed ) {
			winCancel.close();
		}
	}

	// 受付取り消し画面を閉じる
	if ( winCancelReceipt != null ) {
		if ( !winCancelReceipt.closed ) {
			winCancelReceipt.close();
		}
	}

	// 受付画面を閉じる
	closeReceiptWindow();

	// カレンダー検索画面を閉じる
	if ( winCalendar != null ) {
		if ( !winCalendar.closed ) {
			winCalendar.close();
		}
	}

	// コメント画面を閉じる
	noteGuide_closeGuideNote();

	winFriends       = null;
	winCancel        = null;
	winCancelReceipt = null;
	winCalendar      = null;

// ## 2004/04/20 Add By T.Takagi@FSIT 受診日一括変更
	// 受診日一括変更画面を閉じる
	if ( winChangeDate != null ) {
		if ( !winChangeDate.closed ) {
			winChangeDate.close();
		}
	}

	winChangeDate = null;
// ## 2004/04/20 Add End

}

// ## 2004/04/20 Add By T.Takagi@FSIT 受診日一括変更
// 受診日一括変更画面呼び出し
function callChangeDateWindow() {

	var opened = false;	// 画面が開かれているか
	var url;			// 受診日一括変更画面のURL

	// すでにガイドが開かれているかチェック
	if ( winChangeDate != null ) {
		if ( !winChangeDate.closed ) {
			opened = true;
		}
	}

	// 受診日一括変更画面のURL編集
	url = 'rsvChangeDateAll.asp';
	url = url + '?rsvNo=<%= strRsvNo %>';

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winChangeDate.focus();
	} else {
		winChangeDate = open( url, '', 'width=900,height=385,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}
// ## 2004/04/20 Add End
//-->
</SCRIPT>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%" style="margin:6px 0 2px 0;">
	<TR>
		<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
		<TD WIDTH="100%">
			<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
				<TR>
					<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">受診情報詳細</FONT></B></TD>
				</TR>
			</TABLE>
		</TD>
		<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="8" HEIGHT="1" ALT=""></TD>
	</TR>
</TABLE>

<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="2">
	<TR>
		<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
<%
		'キャンセルを除く未受付受診情報については「キャンセル」ボタンを編集
		If strRsvNo <> "" And strDayId = "" And CLng("0" & strCancelFlg) = CONSULT_USED Then
%>
			<TD>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
				<A HREF="javascript:callCancelWindow()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="この予約をキャンセルします"></A>
            <%  else    %>
                &nbsp;
            <%  end if  %>
			</TD>
			
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
<%
		End If
        
        '2006.07.04 権限管理 追加 by 李　
        if Session("PAGEGRANT") = "4" then 
%>
		<TD><A HREF="rsvMain.asp" TARGET="_top" ONCLICK="javascript:return confirm('新しい予約情報を登録します。よろしいですか？')"><IMG SRC="/webHains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="新規に予約入力を行います"></A></TD>
<%      End If   %>

		<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
<%
		'保存関連ボタンの制御

		'キャンセル者の場合は「削除」「予約状態に戻す」
		If CLng("0" & strCancelFlg) <> CONSULT_USED Then
%>
			<TD><A HREF="javascript:deleteConsult()"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="このキャンセル情報を完全に削除します"></A></TD>
			<TD><A HREF="javascript:restoreConsult()"><IMG SRC="/webHains/images/rebornrsv.gif" WIDTH="77" HEIGHT="24" ALT="予約状態に戻します"></A></TD>
<%
		'それ以外は「保存」

		Else
			if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then 
%>
				<TD><A HREF="javascript:saveConsult()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="変更した内容を保存します"></A></TD>

<%
			end if
		End If

		'キャンセルを除く受診情報については「コメント」ボタンを編集
		If strRsvNo <> "" And CLng("0" & strCancelFlg) = CONSULT_USED Then
%>
            <TD><A HREF="javascript:noteGuide_showGuideNote('1', '1,1,1,1', '', <%= strRsvNo %>)"><IMG SRC="/webHains/images/comment.gif" HEIGHT="24" WIDTH="77" ALT="コメントを登録します"></A></TD>
<%
		End If
%>
		<TD><A HREF="javascript:callDayliListWindow()"><IMG SRC="/webHains/images/history.gif" WIDTH="77" HEIGHT="24" ALT="受診歴を表示します"></A></TD>
<%
		'キャンセルを除く受診情報については「お連れ様」「金額」ボタンを編集
		If strRsvNo <> "" And CLng("0" & strCancelFlg) = CONSULT_USED Then
%>
			<TD><A HREF="javascript:callFriendWindow()"><IMG SRC="/webHains/images/friends.gif" WIDTH="77" HEIGHT="24" ALT="お連れ様を登録します"></A></TD>
			<TD><A HREF="javascript:showCapacityList()"><IMG SRC="/webHains/images/rsvStat.gif" WIDTH="77" HEIGHT="24" ALT="予約状況を表示します"></A></TD>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
			<TD><A HREF="/webHains/contents/perBill/perPaymentInfo.asp?rsvno=<%= strRsvNo %>" TARGET="_blank"><IMG SRC="/webHains/images/price.gif" WIDTH="77" HEIGHT="24" ALT="受診金額情報を表示します"></A></TD>
<%
		Else
%>
			<TD><A HREF="javascript:showCapacityList()"><IMG SRC="/webHains/images/rsvStat.gif" WIDTH="77" HEIGHT="24" ALT="予約状況を表示します"></A></TD>
<%
		End If

		'受付関連ボタンの制御
		Do

			'キャンセル者の場合は不要
			If CLng("0" & strCancelFlg) <> CONSULT_USED Then
				Exit Do
			End If
%>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
<%
			'受付済みの場合は「受付取り消し」「来院」
			If strDayId <> "" Then
                If Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" Then 
%>
				<TD><A HREF="javascript:callCancelReceiptWindow()"><IMG SRC="/webHains/images/cancelrsv.gif" WIDTH="77" HEIGHT="24" ALT="受付を取り消します"></A></TD>
<%
            End If
%>

		    <TD><A HREF="javascript:callVisitWindow()"><IMG SRC="/webHains/images/visit.gif" WIDTH="77" HEIGHT="24" ALT="来院処理を行います"></A></TD>

<%
				Exit Do
			End If

			'それ以外は「受付」

            '2006.07.04 権限管理 追加 by 李　
            if Session("PAGEGRANT") = "4" then 
%>
			<TD><A HREF="javascript:callReceiptWindow()"><IMG SRC="/webHains/images/receiptrsv.gif" WIDTH="77" HEIGHT="24" ALT="受付処理を行います"></A></TD>
<%          End If   %>

<% '## 2004/04/20 Add By T.Takagi@FSIT 受診日一括変更 %>
<%
			'新規以外の場合は「受診日一括変更」
			If strRsvNo <> "" Then
                '2006.07.04 権限管理 追加 by 李　
                if Session("PAGEGRANT") = "4" then 
%>
                    <TD><A HREF="javascript:callChangeDateWindow()"><IMG SRC="/webHains/images/allchange.gif" WIDTH="77" HEIGHT="24" ALT="受診日の一括変更処理を行います"></A></TD>
<%
                End If
            End If
%>
<% '## 2004/04/20 Add End %>
<%
			Exit Do
		Loop
%>
	</TR>
</TABLE>
<FORM NAME="paramForm" ACTION="/webHains/contents/frameReserve/fraRsvCalendar.asp" METHOD="post">
	<INPUT TYPE="hidden" NAME="mode" VALUE="1">
	<INPUT TYPE="hidden" NAME="calledFrom" VALUE="1">
	<INPUT TYPE="hidden" NAME="cslYear">
	<INPUT TYPE="hidden" NAME="cslMonth">
	<INPUT TYPE="hidden" NAME="perId">
	<INPUT TYPE="hidden" NAME="manCnt">
	<INPUT TYPE="hidden" NAME="gender">
	<INPUT TYPE="hidden" NAME="birth">
	<INPUT TYPE="hidden" NAME="age">
	<INPUT TYPE="hidden" NAME="romeName">
	<INPUT TYPE="hidden" NAME="orgCd1">
	<INPUT TYPE="hidden" NAME="orgCd2">
	<INPUT TYPE="hidden" NAME="cslDivCd">
	<INPUT TYPE="hidden" NAME="csCd">
	<INPUT TYPE="hidden" NAME="rsvGrpCd">
	<INPUT TYPE="hidden" NAME="ctrPtCd">
	<INPUT TYPE="hidden" NAME="optCd">
	<INPUT TYPE="hidden" NAME="optBranchNo">
<% '## 2003.12.12 Add By T.Takagi@FSIT 現在日を渡す %>
	<INPUT TYPE="hidden" NAME="curCslYear">
	<INPUT TYPE="hidden" NAME="curCslMonth">
	<INPUT TYPE="hidden" NAME="curCslDay">
<% '## 2003.12.12 Add End %>
</FORM>
</BODY>
</HTML>
