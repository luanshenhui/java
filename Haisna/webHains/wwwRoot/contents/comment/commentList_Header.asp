<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   情報コメント（ヘッダー）  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objHainsUser		'ユーザ情報アクセス用
Dim objPerson			'個人クラス
Dim objConsult			'受診クラス
Dim objPubNote			'ノートクラス
Dim objOrg				'団体情報アクセス用

'パラメータ
Dim lngRsvNo			'予約番号
Dim strPerId			'個人ID
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strCtrPtCd			'契約パターンコード
Dim lngStrYear			'表示開始年
Dim lngStrMonth			'表示開始月
Dim lngStrDay			'表示開始日
Dim lngEndYear			'表示終了年
Dim lngEndMonth			'表示終了月
Dim lngEndDay			'表示終了日
Dim strPubNoteDivCd		'ノート分類
Dim strPubNoteDivCdCtr	'ノート分類(契約用)
Dim strPubNoteDivCdOrg	'ノート分類(団体用)
Dim lngDispKbn			'表示対象区分
Dim lngDispMode			'表示モード
Dim	strWinMode			'ウィンドウモード
'### 2004/3/24 Added by Ishihara@FSIT 削除データ表示対応
Dim lngIncDelNote		'1:削除データも表示
'### 2004/3/24 Added End

'個人情報
Dim strLastName			'姓
Dim strFirstName		'名
Dim strLastKName		'カナ姓
Dim strFirstKName		'カナ名
Dim strBirth			'生年月日
Dim strGender			'性別
Dim strGenderName		'性別名称

'受診情報
Dim strCslDate			'受診日
Dim strCsCd				'コースコード
Dim strCsName			'コース名
Dim strAge				'年齢
Dim strDayId			'当日ID
Dim strOrgName			'団体漢字名称

'ノート分類
Dim vntPubNoteDivCd		'受診情報ノート分類コード
Dim vntPubNoteDivName	'受診情報ノート分類名称
Dim vntDefaultDispKbn	'表示対象区分初期値
Dim vntOnlyDispKbn		'表示対象区分しばり

'表示対象区分
Dim vntDispKbnCd		'表示対象区分コード
Dim vntDispKbnName		'表示対象区分名称

'ユーザ情報
Dim strUpdUser			'更新者
Dim lngAuthNote      	'参照登録権限
Dim lngDefNoteDispKbn	'ノート初期表示状態

Dim lngCount			'取得件数
Dim Ret					'復帰値
Dim i, j				'カウンター


'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objHainsUser	= Server.CreateObject("HainsHainsUser.HainsUser")
Set objPerson		= Server.CreateObject("HainsPerSon.Person")
Set objConsult		= Server.CreateObject("HainsConsult.Consult")
Set objPubNote		= Server.CreateObject("HainsPubNote.PubNote")
Set objOrg			= Server.CreateObject("HainsOrganization.Organization")

'引数値の取得
lngRsvNo		= CLng("0" & Request("rsvno"))
strPerId		= Request("perid")
strOrgCd1		= Request("orgcd1")
strOrgCd2		= Request("orgcd2")
strCtrPtCd		= Request("ctrptcd")
lngStrYear		= CLng("0" & Request("StrYear"))
lngStrMonth		= CLng("0" & Request("StrMonth"))
lngStrDay		= CLng("0" & Request("StrDay"))
lngEndYear		= CLng("0" & Request("EndYear"))
lngEndMonth		= CLng("0" & Request("EndMonth"))
lngEndDay		= CLng("0" & Request("EndDay"))
strPubNoteDivCd	= Request("PubNoteDivCd")
strPubNoteDivCdCtr	= Request("PubNoteDivCdOrg")
strPubNoteDivCdOrg	= Request("PubNoteDivCdCtr")
lngDispKbn		= CLng("0" & Request("DispKbn"))
lngDispMode		= CLng("0" & Request("DispMode"))
strWinMode		= Request("winmode")
'### 2004/3/24 Added by Ishihara@FSIT 削除データ表示対応
lngIncDelNote   = Request("IncDelNote")
'### 2004/3/24 Added End

strUpdUser		= Session("USERID")


Do
	'ユーザの参照登録権限を取得
	objHainsUser.SelectHainsUser strUpdUser, _
								,,,,,,,,,,,,,,,,,,,,,,,, _
								lngAuthNote, lngDefNoteDispKbn

	If lngRsvNo <> "0" Then
		'受診情報の取得
		Ret = objConsult.SelectConsult(	lngRsvNo, _
										, _
										strCslDate,    _
										strPerId,      _
										strCsCd,       _
										strCsName,     _
										, , _
										strOrgName,     _
										, , _
										strAge,        _
										, , , , , , , , , , , , _
										strDayId,   _
										, , 0, , , , , , , , , , , , , , , _
										strLastName,   _
										strFirstName,  _
										strLastKName,  _
										strFirstKName, _
										strBirth,      _
										strGender )
		If Ret = False Then
			Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
		End If
	Else
		If strPerId <> "" Then
			'個人情報の取得
			Ret = objPerson.SelectPersonInf(	strPerId,      _
												strLastName,   _
												strFirstName,  _
												strLastKName,  _
												strFirstKName, _
												strBirth,      _
												strGender,     _
												strGenderName, _
												strAge )
			If Ret = False Then
				Err.Raise 1000, , "個人情報が存在しません。（個人ID= " & strPerId & " )"
			End If
		End If

		If strOrgCd1 <> "" And strOrgCd2 <> "" Then
			'団体情報を取得する
			Ret = objOrg.SelectOrg_lukes(	strOrgCd1, strOrgCd2, _
											 , , _
											strOrgName )
			If Ret = False Then
				Err.Raise 1000, , "団体情報が取得できません。（団体コード= " & strOrgCd1 & "-" & strOrgCd2 &  "）"
			End If
		End If
	End If

	'ノート分類の取得
	lngCount = objPubNote.SelectPubNoteDivList(	strUpdUser, _
												vntPubNoteDivCd,   _
												vntPubNoteDivName, _
												vntDefaultDispKbn, _
												vntOnlyDispKbn )
	If lngCount < 0 Then
		Err.Raise 1000, , "ノート分類が存在しません。"
	End If

	'表示対象区分
	vntDispKbnCd = Array()
	vntDispKbnName = Array()
	Redim Preserve vntDispKbnCd(1)
	Redim Preserve vntDispKbnName(1)
	vntDispKbnCd(0) = "1":vntDispKbnName(0) = "医療情報のみ表示"
	vntDispKbnCd(1) = "2":vntDispKbnName(1) = "事務情報のみ表示"

Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>コメント一覧</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<!--
var winCommentDetail;			// コメント情報詳細ウィンドウハンドル

// 新規
function calCommentDetail() {
	var myForm = document.entryForm;
	var url;							// URL文字列
	var opened = false;					// 画面がすでに開かれているか


	url = '/WebHains/contents/comment/commentDetail2.asp';
	url = url + '?rsvno='   + myForm.rsvno.value;
	url = url + '&perid='   + myForm.perid.value;
	url = url + '&orgcd1='  + myForm.orgcd1.value;
	url = url + '&orgcd2='  + myForm.orgcd2.value;
	url = url + '&ctrptcd=' + myForm.ctrptcd.value;
	url = url + '&PubNoteDivCd=' + myForm.PubNoteDivCd.value;
	url = url + '&cmtMode=' + parent.params.cmtMode;
	url = url + '&seq=0';

	// すでにガイドが開かれているかチェック
	if ( winCommentDetail != null ) {
		if ( !winCommentDetail.closed ) {
			opened = true;
		}
	}

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winCommentDetail.focus();
		winCommentDetail.location.replace( url );
	} else {
		winCommentDetail = window.open( url, '', 'width=650,height=500,status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no');
	}
}

// 検索
function searchComment() {
	var myForm = document.entryForm;
	var url;		// URL文字列

	// 表示期間入力チェック
	if ( myForm.StrYear.value != '' || myForm.StrMonth.value != '' || myForm.StrDay.value != '' ) {
		if ( !isDate( myForm.StrYear.value, myForm.StrMonth.value, myForm.StrDay.value ) ) {
			alert('表示期間の形式に誤りがあります。');
			return;
		}
	}

	if ( myForm.EndYear.value != '' || myForm.EndMonth.value != '' || myForm.EndDay.value != '' ) {
		if ( !isDate( myForm.EndYear.value, myForm.EndMonth.value, myForm.EndDay.value ) ) {
			alert('表示期間の形式に誤りがあります。');
			return;
		}
	}

	// URL文字列の編集
	url = parent.location.pathname;
	url = url + '?rsvno='        + myForm.rsvno.value;
	url = url + '&perid='        + myForm.perid.value;
	url = url + '&orgcd1='       + myForm.orgcd1.value;
	url = url + '&orgcd2='       + myForm.orgcd2.value;
	url = url + '&ctrptcd='      + myForm.ctrptcd.value;
	url = url + '&StrYear='      + myForm.StrYear.value;
	url = url + '&StrMonth='     + myForm.StrMonth.value;
	url = url + '&StrDay='       + myForm.StrDay.value;
	url = url + '&EndYear='      + myForm.EndYear.value;
	url = url + '&EndMonth='     + myForm.EndMonth.value;
	url = url + '&EndDay='       + myForm.EndDay.value;
	url = url + '&PubNoteDivCd=' + myForm.PubNoteDivCd.value;
	url = url + '&PubNoteDivCdCtr=' + myForm.PubNoteDivCdCtr.value;
	url = url + '&PubNoteDivCdOrg=' + myForm.PubNoteDivCdOrg.value;
	url = url + '&DispKbn='      + myForm.DispKbn.value;
	url = url + '&DispMode='     + myForm.DispMode.value;
	url = url + '&IncDelNote='   + myForm.IncDelNote.value;
	url = url + '&CmtMode='      + parent.params.cmtMode;
	url = url + '&winmode='      + parent.params.winmode;
	url = url + '&act='          + parent.params.act;
	// 検索結果表示
	parent.location.replace(url);

	return;

}

// 表示モードチェック
function checkDispMode() {
	var myForm = document.entryForm;

	if( myForm.Chk.checked ) {
		myForm.DispMode.value = '1';
	} else {
		myForm.DispMode.value = '0';
	}
}

// 削除データモードチェック
function checkIncDelNote() {
	var myForm = document.entryForm;

	if( myForm.chkIncDelNote.checked ) {
		myForm.IncDelNote.value = '1';
	} else {
		myForm.IncDelNote.value = '0';
	}
}

// ウィンドウを閉じる
function windowClose() {

	// 日付ガイドウインドウを閉じる
	calGuide_closeGuideCalendar();

	// コメント情報詳細を閉じる
	if ( winCommentDetail != null ) {
		if ( !winCommentDetail.closed ) {
			winCommentDetail.close();
		}
	}

	winCommentDetail  = null;
}
//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: <%= IIF(lngDispMode="2","0","12") %>px 0 0 <%= IIF(lngDispMode="2","20","5") %>px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<%
	'面接支援のとき
	If lngDispMode = "2" Then
		'「別ウィンドウで表示」の場合、ヘッダー部分表示
		If strWinMode = "1" Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
			Call interviewHeader(lngRsvNo, 0)
		End If
	End  If
%>
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="rsvno"           VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="perid"           VALUE="<%= strPerId %>">
	<INPUT TYPE="hidden" NAME="orgcd1"          VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgcd2"          VALUE="<%= strOrgCd2 %>">
	<INPUT TYPE="hidden" NAME="ctrptcd"         VALUE="<%= strCtrPtCd %>">
	<INPUT TYPE="hidden" NAME="orgStrYear"      VALUE="<%= lngStrYear %>">
	<INPUT TYPE="hidden" NAME="orgStrMonth"     VALUE="<%= lngStrMonth %>">
	<INPUT TYPE="hidden" NAME="orgStrDay"       VALUE="<%= lngStrDay %>">
	<INPUT TYPE="hidden" NAME="orgEndYear"      VALUE="<%= lngEndYear %>">
	<INPUT TYPE="hidden" NAME="orgEndMonth"     VALUE="<%= lngEndMonth %>">
	<INPUT TYPE="hidden" NAME="orgEndDay"       VALUE="<%= lngEndDay %>">
	<INPUT TYPE="hidden" NAME="orgPubNoteDivCd" VALUE="<%= strPubNoteDivCd %>">
	<INPUT TYPE="hidden" NAME="PubNoteDivCdCtr" VALUE="<%= strPubNoteDivCdCtr %>">
	<INPUT TYPE="hidden" NAME="PubNoteDivCdOrg" VALUE="<%= strPubNoteDivCdOrg %>">
	<INPUT TYPE="hidden" NAME="orgDispKbn"      VALUE="<%= lngDispKbn %>">
	<INPUT TYPE="hidden" NAME="DispMode"        VALUE="<%= lngDispMode %>">
	<INPUT TYPE="hidden" NAME="IncDelNote"      VALUE="<%= lngIncDelNote %>">

	<!-- タイトルの表示 -->
	<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
		<TR>
			<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">コメント情報</FONT></B></TD>
		</TR>
	</TABLE>
	<BR>
<%
'面接支援のときは個人・受診情報は表示しない
If lngDispMode <> "2" Then
	If lngRsvNo <> "0" Then

'### 2013.03.26 特定保健指導対象者チェックの為追加　Start ###
Dim objSpecialInterview         '特定健診情報アクセス用
Dim lngSpCheck                  '特定保健指導対象かチェック

Set objSpecialInterview     = Server.CreateObject("HainsSpecialInterview.SpecialInterview")

    lngSpCheck = objSpecialInterview.CheckSpecialTarget(lngRsvNo)

'### 2013.03.26 特定保健指導対象者チェックの為追加　End   ###
%>
	<!-- 受診情報の表示 -->
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD NOWRAP>受診日：</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %></B></FONT></TD>
			<TD NOWRAP>　コース：</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
            <TD NOWRAP>　当日ＩＤ：</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= objCommon.FormatString(strDayID, "0000") %></B></FONT></TD>
			<TD NOWRAP>　団体：</TD>
			<TD NOWRAP><%= strOrgName %></TD>
<%
'### 2013.03.26 特定保健指導対象者チェックの為追加　Start ###
            If lngSpCheck > 0 Then 
%>
            <TD NOWRAP><IMG SRC="../../images/physical10.gif"  HEIGHT="22" WIDTH="22" BORDER="0" ALT="特定保健指導対象"></TD>
<%
            End If
'### 2013.03.26 特定保健指導対象者チェックの為追加　End  ###
%>

		</TR>
	</TABLE>
<%
	Else
		'団体名あり？
		If strOrgName <> "" Then
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD NOWRAP>団体：</TD>
			<TD NOWRAP><%= strOrgName %></TD>
		</TR>
	</TABLE>
<%
		End If
	End If
	If lngRsvNo <> "0" Or strPerId <> "" Then
%>
	<!-- 個人情報の表示 -->
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD NOWRAP><%= strPerId %></TD>
			<TD NOWRAP WIDTH="10">　</TD>
			<TD NOWRAP>　<B><%= strLastName & " " & strFirstName %></B> （<FONT SIZE="-1"><%= strLastKname & "　" & strFirstKName %></FONT>）</TD>
			<TD NOWRAP>　　<%= objCommon.FormatString(CDate(strBirth), "ge（yyyy）.m.d") %>生　<%= Int(strAge) %>歳　<%= IIf(strGender = "1", "男性", "女性") %></TD>
		</TR>
	</TABLE>
<%
	End If
%>
	<BR>
<%
End If
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<!-- 検索条件：表示期間 -->
		<TR>
			<TD NOWRAP>表示期間</TD>
			<TD>：</TD>
			<TD COLSPAN="2">
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('StrYear', 'StrMonth', 'StrDay')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
						<TD><%= EditSelectNumberList("StrYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrYear) %></TD>
						<TD>年</TD>
						<TD><%= EditSelectNumberList("StrMonth", 1, 12, lngStrMonth) %></TD>
						<TD>月</TD>
						<TD><%= EditSelectNumberList("StrDay", 1, 31, lngStrDay) %></TD>
						<TD>日</TD>
						<TD>～</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('EndYear', 'EndMonth', 'EndDay')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
						<TD><%= EditSelectNumberList("EndYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndYear) %></TD>
						<TD>年</TD>
						<TD><%= EditSelectNumberList("EndMonth", 1, 12, lngEndMonth) %></TD>
						<TD>月</TD>
						<TD><%= EditSelectNumberList("EndDay", 1, 31, lngEndDay) %></TD>
						<TD>日</TD>
					</TR>
				</TABLE>
			</TD>
			<TD COLSPAN="3"><INPUT TYPE="checkbox" NAME="chkIncDelNote" VALUE="1" <%= IIf(lngIncDelNote = "1", " CHECKED", "") %> ONCHANGE="javascript:checkIncDelNote()">削除データも表示</TD>
		</TR>
		<!-- 検索条件：コメント種類 -->
		<TR>
			<TD NOWRAP>コメント種類</TD>
			<TD>：</TD>
			<TD>
				<%= EditDropDownListFromArray("PubNoteDivCd", vntPubNoteDivCd, vntPubNoteDivName, strPubNoteDivCd, SELECTED_ALL) %>
				　
<%
	If lngAuthNote = "3" Then
%>
				<%= EditDropDownListFromArray("DispKbn", vntDispKbnCd, vntDispKbnName, lngDispKbn, SELECTED_ALL) %>
<%
	Else
%>
				<INPUT TYPE="hidden" NAME="DispKbn" VALUE="<%= lngDispKbn %>">
<%
	End If
%>
			</TD>
<%
	If lngDispMode = "2" Then
%>
			<TD>&nbsp;</TD>
<%
	Else
%>
			<TD>
				<INPUT TYPE="checkbox" NAME="Chk" VALUE="1" <%= IIf(lngDispMode=1, " CHECKED", "") %> ONCHANGE="javascript:checkDispMode()">契約・団体コメントを表示する
			</TD>
<%
	End If


%>


<%

    '2006.07.04 権限管理 追加 by 李　
    if Session("PAGEGRANT") = "4" then 
%>
			<TD NOWRAP>
				<A HREF="JavaScript:calCommentDetail()"><IMG SRC="../../images/newrsv.gif" ALT="コメントを追加" HEIGHT="24" WIDTH="77" BORDER="0"></A>

<%  else    %>
             <TD NOWRAP>
                 &nbsp;
<%  End If   %>

				<A HREF="JavaScript:searchComment()"><IMG SRC="../../images/b_search.gif" ALT="指定条件で表示" HEIGHT="24" WIDTH="77" BORDER="0"></A>
			</TD>
		</TR>
	</TABLE>

</FORM>
</BODY>
</HTML>
