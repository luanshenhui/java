<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		フォローガイド (Ver0.0.1)
'		AUTHER  : Yaguchi Toru@orbsys.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objFollowUp			'フォローアップアクセス用
Dim objJud			'判定情報アクセス用
Dim objSentence			'文章情報アクセス用

'パラメータ
Dim strJudClassCd		'判定コード
Dim strJudClassName		'検診項目
Dim strJudCd			'判定
Dim strSecCslDate		'二次検査日
Dim strComeFlg			'状況
Dim strSecItemCd		'検査項目
Dim strRsvInfoCd		'予約情報
Dim strJudCd2			'結果
Dim strQuestionCd		'アンケート
Dim strfolNote			'備考

Dim strSecCslYear		'二次検査日（年）
Dim strSecCslMonth		'二次検査日（月）
Dim strSecCslDay		'二次検査日（日）

Dim strStcCd1			'文章コード
Dim strShortstc1		'略称
Dim strStcCd2			'文章コード
Dim strShortstc2		'略称
Dim strStcCd3			'文章コード
Dim strShortstc3		'略称
Dim strStcCd4			'文章コード
Dim strShortstc4		'略称
Dim strStcCd5			'文章コード
Dim strShortstc5		'略称
Dim strRsvInfoName		'予約情報名
Dim strQuestionName		'アンケート名

'判定コンボボックス
Dim strArrJudCdSeq		'判定連番
Dim strArrJudCd			'判定コード
Dim strArrWeight		'判定用重み
Dim lngJudListCnt		'判定件数

Dim lngCount			'レコード件数

Dim i				'インデックス
Dim Ret				'復帰値

Dim vntArrSecItemCd		'
Dim vntArrSecItemCd2		'

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objFollowUp     = Server.CreateObject("HainsFollowUp.FollowUp")
Set objJud          = Server.CreateObject("HainsJud.Jud")
Set objSentence     = Server.CreateObject("HainsSentence.Sentence")

'パラメータ値の取得
strJudClassCd	= Request("judClassCd")
strJudClassName	= Request("judClassName")
strJudCd	= Request("judCd")
strSecCslDate	= Request("secCslDate")
If strSecCslDate <> "" Then
	strSecCslYear   = Year(strSecCslDate)
	strSecCslMonth  = Month(strSecCslDate)
	strSecCslDay    = Day(strSecCslDate)
End If
strComeFlg	= Request("comeFlg")
strSecItemCd	= Request("secItemCd")
vntArrSecItemCd = Split(strSecItemCd,"Z")
vntArrSecItemCd2 = Array()
Redim Preserve vntArrSecItemCd2(5)
i = 0
Do Until i > Ubound(vntArrSecItemCd)
	vntArrSecItemCd2(i) = Trim(vntArrSecItemCd(i))
	i = i +1
Loop
strStcCd1       = vntArrSecItemCd2(0)
strStcCd2       = vntArrSecItemCd2(1)
strStcCd3       = vntArrSecItemCd2(2)
strStcCd4       = vntArrSecItemCd2(3)
strStcCd5       = vntArrSecItemCd2(4)
Ret 		= objSentence.SelectSentence("89001", 0, strStcCd1, strShortstc1)
Ret 		= objSentence.SelectSentence("89001", 0, strStcCd2, strShortstc2)
Ret 		= objSentence.SelectSentence("89001", 0, strStcCd3, strShortstc3)
Ret 		= objSentence.SelectSentence("89001", 0, strStcCd4, strShortstc4)
Ret 		= objSentence.SelectSentence("89001", 0, strStcCd5, strShortstc5)
strRsvInfoCd	= Request("rsvInfoCd")
Ret 		= objSentence.SelectSentence("89002", 0, strRsvInfoCd, strRsvInfoName)
strJudCd2	= Request("judCd2")
strQuestionCd	= Request("questionCd")
Ret 		= objSentence.SelectSentence("89003", 0, strQuestionCd, strQuestionName)
strFolNote	= Request("folNote")

'判定取得
Call EditJudListInfo

'-------------------------------------------------------------------------------
'
' 機能　　 : 判定の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditJudListInfo()



	'判定一覧取得
	lngJudListCnt = objJud.SelectJudList( _
    									strArrJudCd, _
										 , , strArrWeight	)

	strArrJudCdSeq = Array()
	Redim Preserve strArrJudCdSeq(lngJudListCnt-1)
	For i = 0 To lngJudListCnt-1
		strArrJudCdSeq(i) = i
	Next


End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>フォローアップ／二次検査予約情報</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc"    -->
<!--
var lngSelectedIndex1;  // ガイド表示時に選択されたエレメントのインデックス
var curYear, curMonth, curDay;	// 日付ガイド呼び出し直前の日付退避用変数

// 日付ガイドまたはカレンダー検索画面呼び出し
function callCalGuide() {

	var myForm = document.folList;	// 自画面のフォームエレメント

	// ガイド呼び出し直前の日付を退避
	curYear  = myForm.secCslYear.value;
	curMonth = myForm.secCslMonth.value;
	curDay   = myForm.secCslDay.value;

	// 日付ガイド表示
	calGuide_showGuideCalendar( 'secCslYear', 'secCslMonth', 'secCslday', dateSelected );

}

function dateSelected() {

}

// 文章ガイド呼び出し
function callStcGuide( index ) {

	var myForm = document.folList;

	// 選択されたエレメントのインデックスを退避(文章コード・略文章のセット用関数にて使用する)
	lngSelectedIndex1 = index;

	// ガイド画面の連絡域に検査項目コードを設定する
	if ( index == 1 ) {
		stcGuide_ItemCd ='89001';
	}
	if ( index == 2 ) {
		stcGuide_ItemCd ='89001';
	}
	if ( index == 3 ) {
		stcGuide_ItemCd ='89001';
	}
	if ( index == 4 ) {
		stcGuide_ItemCd ='89001';
	}
	if ( index == 5 ) {
		stcGuide_ItemCd ='89001';
	}
	if ( index == 6 ) {
		stcGuide_ItemCd ='89002';
	}
	if ( index == 7 ) {
		stcGuide_ItemCd ='89003';
	}

	// ガイド画面の連絡域に項目タイプ（標準）を設定する
	stcGuide_ItemType = '0';

	// ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
	stcGuide_CalledFunction = setStcInfo;

	// 文章ガイド表示
	showGuideStc();
}

// 文章コード・略文章のセット
function setStcInfo() {

	setStc( lngSelectedIndex1, stcGuide_StcCd, stcGuide_ShortStc );

}

// 文章の編集
function setStc( index, stcCd, shortStc ) {

	var myForm = document.folList;			// 自画面のフォームエレメント
	var objStcCd, objShortStc;			// 結果・文章のエレメント
	var stcNameElement;				// 文章のエレメント

	// 編集エレメントの設定
	if ( index == 1 ) {
		objStcCd   	= myForm.stcCd1;
		objShortStc   	= myForm.shortStc1;
	}
	if ( index == 2 ) {
		objStcCd   	= myForm.stcCd2;
		objShortStc   	= myForm.shortStc2;
	}
	if ( index == 3 ) {
		objStcCd   	= myForm.stcCd3;
		objShortStc   	= myForm.shortStc3;
	}
	if ( index == 4 ) {
		objStcCd   	= myForm.stcCd4;
		objShortStc   	= myForm.shortStc4;
	}
	if ( index == 5 ) {
		objStcCd   	= myForm.stcCd5;
		objShortStc   	= myForm.shortStc5;
	}
	if ( index == 6 ) {
		objStcCd   	= myForm.rsvInfoCd;
		objShortStc   	= myForm.rsvInfoName;
	}
	if ( index == 7 ) {
		objStcCd   	= myForm.questionCd;
		objShortStc   	= myForm.questionName;
	}

	stcNameElement = 'stcName' + index;

	// 値の編集
	objStcCd.value   = stcCd;
	objShortStc.value = shortStc;

	if ( document.getElementById(stcNameElement) ) {
		document.getElementById(stcNameElement).innerHTML = shortStc;
	}

}

// 文章のクリア
function callStcClr( index ) {

	var myForm = document.folList;			// 自画面のフォームエレメント
	var objStcCd, objShortStc;			// 結果・文章のエレメント
	var stcNameElement;				// 文章のエレメント

	// 編集エレメントの設定
	if ( index == 1 ) {
		objStcCd   	= myForm.stcCd1;
		objShortStc   	= myForm.shortStc1;
	}
	if ( index == 2 ) {
		objStcCd   	= myForm.stcCd2;
		objShortStc   	= myForm.shortStc2;
	}
	if ( index == 3 ) {
		objStcCd   	= myForm.stcCd3;
		objShortStc   	= myForm.shortStc3;
	}
	if ( index == 4 ) {
		objStcCd   	= myForm.stcCd4;
		objShortStc   	= myForm.shortStc4;
	}
	if ( index == 5 ) {
		objStcCd   	= myForm.stcCd5;
		objShortStc   	= myForm.shortStc5;
	}
	if ( index == 6 ) {
		objStcCd   	= myForm.rsvInfoCd;
		objShortStc   	= myForm.rsvInfoName;
	}
	if ( index == 7 ) {
		objStcCd   	= myForm.questionCd;
		objShortStc   	= myForm.questionName;
	}
	stcNameElement = 'stcName' + index;

	// 値の編集
	objStcCd.value   = '';
	objShortStc.value = '';

	if ( document.getElementById(stcNameElement) ) {
		document.getElementById(stcNameElement).innerHTML = '';
	}

}


// 入力領域データのセット
function selectList() {

	var secCslDate;
	var secCslDateLen;
	var folStcCd = new Array(5);
	var folShortStc = new Array(5);
	var i, j;
	// 呼び元ウィンドウが存在しなければ何もしない
	if ( opener == null ) {
		return false;
	}

	// 親画面の連絡域に対し、文章コード・略文章を編集(リストが単数の場合と複数の場合とで処理を振り分け)

	// 二次検査受診日
	if ( opener.folGuide_SecCslDate != null ) {
		secCslDate = '';
		if (document.folList.secCslYear.value != '' || document.folList.secCslMonth.value != '' || document.folList.secCslDay.value != '') {
			secCslDate = document.folList.secCslYear.value + '/' + document.folList.secCslMonth.value + '/' + document.folList.secCslDay.value;
		}
		opener.folGuide_SecCslDate = secCslDate;
	}

	// 来院
	if ( opener.folGuide_ComeFlg != null ) {
		if ( document.folList.comeFlg.checked ) {
			opener.folGuide_ComeFlg = document.folList.comeFlg.value;
		} else {
			opener.folGuide_ComeFlg = '';
		}
	}

	// 検査項目
	folStcCd[0] = document.folList.stcCd1.value;
	folStcCd[1] = document.folList.stcCd2.value;
	folStcCd[2] = document.folList.stcCd3.value;
	folStcCd[3] = document.folList.stcCd4.value;
	folStcCd[4] = document.folList.stcCd5.value;
	folShortStc[0] = document.folList.shortStc1.value;
	folShortStc[1] = document.folList.shortStc2.value;
	folShortStc[2] = document.folList.shortStc3.value;
	folShortStc[3] = document.folList.shortStc4.value;
	folShortStc[4] = document.folList.shortStc5.value;
	for ( i = 0; i < 5; i++ ) {
		for ( j = i + 1; j < 5; j++ ) {
			//同じ検査項目の場合は空にする
			if ( folStcCd[i] == folStcCd[j] ) {
				folStcCd[j] = '';
				folShortStc[j] = '';
			}
		}
	}
	if ( opener.folGuide_SecItemCd != null ) {
		secItemCd = '';
		secCslDateLen = 0;
		if ( folStcCd[0] != '' ) {
			secItemCd = folStcCd[0];
			secCslDateLen = (folStcCd[0] != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName1 = folShortStc[0];
		}
		if ( folStcCd[1] != '' ) {
			secItemCd = (secCslDateLen > 0) ? secItemCd + 'Z' + folStcCd[1]:folStcCd[1];
			secCslDateLen = (folStcCd[1] != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName2 = folShortStc[1];
		}
		if ( folStcCd[2] != '' ) {
			secItemCd = (secCslDateLen > 0) ? secItemCd + 'Z' + folStcCd[2]:folStcCd[2];
			secCslDateLen = (folStcCd[2] != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName3 = folShortStc[2];
		}
		if ( folStcCd[3] != '' ) {
			secItemCd = (secCslDateLen > 0) ? secItemCd + 'Z' + folStcCd[3]:folStcCd[3];
			secCslDateLen = (folStcCd[3] != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName4 = folShortStc[3];
		}
		if ( folStcCd[4] != '' ) {
			secItemCd = (secCslDateLen > 0) ? secItemCd + 'Z' + folStcCd[4]:folStcCd[4];
			secCslDateLen = (folStcCd[4] != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName5 = folShortStc[4];
		}
		opener.folGuide_SecItemCd = secItemCd;
	}

/*
	if ( opener.folGuide_SecItemCd != null ) {
		secItemCd = '';
		secCslDateLen = 0;
		if ( document.folList.stcCd1.value != '' ) {
			secItemCd = document.folList.stcCd1.value;
			secCslDateLen = (document.folList.stcCd1.value != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName1 = document.folList.shortStc1.value;
		}
		if ( document.folList.stcCd2.value != '' ) {
			secItemCd = (secCslDateLen > 0) ? secItemCd + 'Z' + document.folList.stcCd2.value:document.folList.stcCd2.value;
			secCslDateLen = (document.folList.stcCd2.value != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName2 = document.folList.shortStc2.value;
		}
		if ( document.folList.stcCd3.value != '' ) {
			secItemCd = (secCslDateLen > 0) ? secItemCd + 'Z' + document.folList.stcCd3.value:document.folList.stcCd3.value;
			secCslDateLen = (document.folList.stcCd3.value != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName3 = document.folList.shortStc3.value;
		}
		if ( document.folList.stcCd4.value != '' ) {
			secItemCd = (secCslDateLen > 0) ? secItemCd + 'Z' + document.folList.stcCd4.value:document.folList.stcCd4.value;
			secCslDateLen = (document.folList.stcCd4.value != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName4 = document.folList.shortStc4.value;
		}
		if ( document.folList.stcCd5.value != '' ) {
			secItemCd = (secCslDateLen > 0) ? secItemCd + 'Z' + document.folList.stcCd5.value:document.folList.stcCd5.value;
			secCslDateLen = (document.folList.stcCd5.value != '') ? secCslDateLen + 1:secCslDateLen;
			opener.folGuide_FolName5 = document.folList.shortStc5.value;
		}
		opener.folGuide_SecItemCd = secItemCd;
	}
*/
	// 予約情報
	if ( opener.folGuide_RsvInfoCd != null ) {
//		if ( document.folList.rsvInfoCd.value != '' ) {
			opener.folGuide_RsvInfoCd = document.folList.rsvInfoCd.value;
			opener.folGuide_RsvInfoName = document.folList.rsvInfoName.value;
//		}
	}

	// 検査結果
	if ( opener.folGuide_JudCd2 != null ) {
//		if ( document.folList.judCd2.value != '' ) {
			opener.folGuide_JudCd2 = document.folList.judCd2.value;
//		}
	}

	// アンケート
	if ( opener.folGuide_QuestionCd != null ) {
//		if ( document.folList.questionCd.value != '' ) {
			opener.folGuide_QuestionCd = document.folList.questionCd.value;
			opener.folGuide_QuestionName = document.folList.questionName.value;
//		}
	}

	// 備考
	if ( opener.folGuide_FolNote != null ) {
//		if ( document.folList.folNote.value != '' ) {
			opener.folGuide_FolNote = document.folList.folNote.value;
//		}
	}

	// 連絡域に設定されてある親画面の関数呼び出し
	if ( opener.folGuide_CalledFunction != null ) {
		opener.folGuide_CalledFunction();
	}

	opener.winGuideFol = null;
	close();

	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#ffffff">

<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">

	<INPUT TYPE="hidden" NAME="judClassCd"   VALUE="<%= strJudClassCd   %>">
	<INPUT TYPE="hidden" NAME="judClassName" VALUE="<%= strJudClassName %>">
	<INPUT TYPE="hidden" NAME="judCd"        VALUE="<%= strJudCd        %>">

	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="500">
		<TR>
			<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">フォローアップ登録</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD ALIGN="right">
				<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0">
					<TR>
						<TD><A HREF="javascript:close()"><IMG SRC="../../images/back.gif"  ALT="フォローアップ画面に戻ります" border="0"></A></TD>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>
<!--						<TD><A HREF="javascript:close()"><IMG SRC="../../images/delete.gif"  ALT="健診項目を削除します。" border="0"></A></TD>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>-->

						<TD>
						<% '2005.08.22 権限管理 Add by 李　--- START %>
	           			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
							<A HREF="javascript:selectList()"><IMG SRC="../../images/ok.gif"  ALT="入力したデータを確定します。" border="0"></A>
						<%  else    %>
							 &nbsp;
						<%  end if  %>
						<% '2005.08.22 権限管理 Add by 李　--- END %>
						</TD>
						
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="15"></TD>
		</TR>
	</TABLE>

	<BR>
</FORM>
<FORM NAME="folList" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
		<TR BGCOLOR="#cccccc" ALIGN="center">
			<TD>健診項目</TD>
			<TD><SPAN STYLE=color:"#903000";><%= strJudClassName %></SPAN></TD>
			<TD>判定</TD>
			<TD><SPAN STYLE=color:"#903000";><%= strJudCd %></SPAN></TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
		<TR>
			<TD NOWRAP>二次検査受診日</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP ID="gdeDate"><A HREF="javascript:callCalGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示します"></A></TD>
						<TD NOWRAP><A HREF="javascript:calGuide_clearDate('secCslYear', 'secCslMonth', 'secCslDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
						<TD COLSPAN="4">
							<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
								<TR>
									<TD><%= EditNumberList("secCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSecCslYear, True) %></TD>
									<TD>年</TD>
									<TD><%= EditNumberList("secCslMonth", 1, 12, strSecCslMonth, True) %></TD>
									<TD>月</TD>
									<TD><%= EditNumberList("secCslDay", 1, 31, strSecCslDay, True) %></TD>
									<TD>日</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>来院</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP HEIGHT="35"><INPUT TYPE="checkbox" NAME="comeFlg" VALUE="1" <%= IIf(strComeFlg = "1", " CHECKED", "") %>></TD>
						<TD COLSPAN="6"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>検査項目１</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP><A HREF="javascript:callStcGuide('1')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="検査項目ガイド表示"></A></TD>
						<TD NOWRAP><A HREF="javascript:callStcClr('1')"><IMG SRC="../../images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="検査項目クリア"></A></TD>
						<TD><INPUT TYPE="hidden" NAME="stcCd1" VALUE="<%= strStcCd1 %>"></TD>
						<TD><INPUT TYPE="hidden" NAME="shortStc1" VALUE="<%= strShortstc1 %>"></TD>
						<TD><SPAN ID="stcName1"><%= strShortStc1 %></SPAN></TD>
						<TD COLSPAN="2"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>検査項目２</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP><A HREF="javascript:callStcGuide('2')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="検査項目ガイド表示"></A></TD>
						<TD NOWRAP><A HREF="javascript:callStcClr('2')"><IMG SRC="../../images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="検査項目クリア"></A></TD>
						<TD><INPUT TYPE="hidden" NAME="stcCd2" VALUE="<%= strStcCd2 %>"></TD>
						<TD><INPUT TYPE="hidden" NAME="shortStc2" VALUE="<%= strShortstc2 %>"></TD>
						<TD><SPAN ID="stcName2"><%= strShortStc2 %></SPAN></TD>
						<TD COLSPAN="2"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>検査項目３</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP><A HREF="javascript:callStcGuide('3')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="検査項目ガイド表示"></A></TD>
						<TD NOWRAP><A HREF="javascript:callStcClr('3')"><IMG SRC="../../images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="検査項目クリア"></A></TD>
						<TD><INPUT TYPE="hidden" NAME="stcCd3" VALUE="<%= strStcCd3 %>"></TD>
						<TD><INPUT TYPE="hidden" NAME="shortStc3" VALUE="<%= strShortstc3 %>"></TD>
						<TD><SPAN ID="stcName3"><%= strShortStc3 %></SPAN></TD>
						<TD COLSPAN="2"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>検査項目４</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP><A HREF="javascript:callStcGuide('4')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="検査項目ガイド表示"></A></TD>
						<TD NOWRAP><A HREF="javascript:callStcClr('4')"><IMG SRC="../../images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="検査項目クリア"></A></TD>
						<TD><INPUT TYPE="hidden" NAME="stcCd4" VALUE="<%= strStcCd4 %>"></TD>
						<TD><INPUT TYPE="hidden" NAME="shortStc4" VALUE="<%= strShortstc4 %>"></TD>
						<TD><SPAN ID="stcName4"><%= strShortStc4 %></SPAN></TD>
						<TD COLSPAN="2"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>検査項目５</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP><A HREF="javascript:callStcGuide('5')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="検査項目ガイド表示"></A></TD>
						<TD NOWRAP><A HREF="javascript:callStcClr('5')"><IMG SRC="../../images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="検査項目クリア"></A></TD>
						<TD><INPUT TYPE="hidden" NAME="stcCd5" VALUE="<%= strStcCd5 %>"></TD>
						<TD><INPUT TYPE="hidden" NAME="shortStc5" VALUE="<%= strShortstc5 %>"></TD>
						<TD><SPAN ID="stcName5"><%= strShortStc5 %></SPAN></TD>
						<TD COLSPAN="2"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>予約情報</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP><A HREF="javascript:callStcGuide('6')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="検査項目ガイド表示"></A></TD>
						<TD NOWRAP><A HREF="javascript:callStcClr('6')"><IMG SRC="../../images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="検査項目クリア"></A></TD>
						<TD><INPUT TYPE="hidden" NAME="rsvInfoCd" VALUE="<%= strRsvInfoCd %>"></TD>
						<TD><INPUT TYPE="hidden" NAME="rsvInfoName" VALUE="<%= strRsvInfoName %>"></TD>
						<TD><SPAN ID="stcName6"><%= strRsvInfoName %></SPAN></TD>
						<TD COLSPAN="2"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>検査結果</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP COLSPAN="2"><%= EditDropDownListFromArray("judCd2", strArrJudCd, strArrJudCd, strJudCd2, NON_SELECTED_ADD) %></TD>
						<TD COLSPAN="5"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>アンケート</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD><A HREF="javascript:callStcGuide('7')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="検査項目ガイド表示"></A></TD>
						<TD><A HREF="javascript:callStcClr('7')"><IMG SRC="../../images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="検査項目クリア"></A></TD>
						<TD><INPUT TYPE="hidden" NAME="questionCd" VALUE="<%= strQuestionCd %>"></TD>
						<TD><INPUT TYPE="hidden" NAME="questionName" VALUE="<%= strQuestionName %>"></TD>
						<TD><SPAN ID="stcName7"><%= strQuestionName %></SPAN></TD>
						<TD COLSPAN="2"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>備考</TD>
			<TD COLSPAN="7"><TEXTAREA NAME="folNote" style="ime-mode:active"  COLS="50" ROWS="4"><%= strfolNote %></TEXTAREA></TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
