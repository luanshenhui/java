<% 
'-----------------------------------------------------------------------------
'		汎用情報の抽出 (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
%>
<!-- #include virtual = "/webHains/includes/EditCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/EditJudClassList.inc" -->
<!-- #include virtual = "/webHains/includes/EditJudList.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
If Request.ServerVariables("HTTP_REFERER") = "" Then
	Response.End
End If

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objOrgBsd		'事業部情報アクセス用
Dim objOrgRoom		'室部情報アクセス用
Dim objOrgPost		'所属情報アクセス用

Dim strOrgSName			'団体略称
Dim strArrItemName		'検査項目名称
Dim strOrgName			'団体略称
Dim strOrgBsdName	    '事業所名
Dim strOrgRoomName	    '室部名
Dim strOrgPostName1	    '所属１
Dim strOrgPostName2	    '所属２

Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'団体名の取得
If Trim(mstrOrgCd1) <> "" And Trim(mstrOrgCd2) <> "" Then
	Call objOrganization.SelectOrgName(mstrOrgCd1, mstrOrgCd2, strOrgName)
End If
'事業部
If mstrOrgCd1 <> "" And mstrOrgCd2 <> "" And mstrOrgBsdCd <> "" Then
	objOrgBsd.SelectOrgBsd mstrOrgCd1, mstrOrgCd2, mstrOrgBsdCd, , strorgBsdName
End If
'室部
If mstrOrgCd1 <> "" And mstrOrgCd2 <> "" And mstrOrgBsdCd <> "" And mstrOrgRoomCd <> "" Then
	objOrgRoom.SelectOrgRoom mstrOrgCd1, mstrOrgCd2, mstrOrgBsdCd, mstrOrgRoomCd, strOrgRoomName
End If
'所属
If mstrOrgCd1 <> "" And mstrOrgCd2 <> "" And mstrOrgBsdCd <> "" And mstrOrgRoomCd <> "" And mstrOrgPostCd1 <> "" Then
	objOrgPost.SelectOrgPost mstrOrgCd1, mstrOrgCd2, mstrOrgBsdCd, mstrOrgRoomCd, mstrOrgPostCd1, strOrgPostName1
End If
If mstrOrgCd1 <> "" And mstrOrgCd2 <> "" And mstrOrgBsdCd <> "" And mstrOrgRoomCd <> "" And mstrOrgPostCd2 <> "" Then
	objOrgPost.SelectOrgPost mstrOrgCd1, mstrOrgCd2, mstrOrgBsdCd, mstrOrgRoomCd, mstrOrgPostCd2, strOrgPostName2
End If

'検査項目名称の取得
ReDim strArrItemName(mlngRowCountItem - 1)
For i = 0 To mlngRowCountItem - 1
	'検査項目コードがあれば名称を取得、無ければ空白
	If Trim(mstrArrItemCd(i)) <> "" Then
		Call objItem.SelectItemName(mstrArrItemCd(i), mstrArrSuffix(i), strArrItemName(i))
	'名称は空白
	Else
		strArrItemName(i) = ""
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
<TITLE>抽出条件の指定</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/itmGuide.inc" -->
<!-- #include virtual = "/webHains/includes/dtlGuide.inc" -->

<!--
// 団体ガイド呼び出し
function callOrgGuide() {

	orgGuide_showGuideOrg(document.step2.orgCd1, document.step2.orgCd2, 'orgname');

}

// 団体コード・名称のクリア
function clearOrgCd() {

	orgGuide_clearOrgInfo(document.step2.orgCd1, document.step2.orgCd2, 'orgname');

}


// 事業部ガイド呼び出し
function callOrgBsdGuide() {

	var objForm = document.step2;	// 自画面のフォームエレメント
	orgBsdGuide_showGuideOrgBsd( objForm.orgCd1, objForm.orgCd2, objForm.orgBsdCd, '' , 'orgBsdName', null , false );
}

// 入力チェック
function checkData(CheckMode) {

	var myForm = document.entryForm;	// 自画面のフォームエレメント
	var ret    = false;					// 関数戻り値
	var CheckRsl;
	var strErrMsg = '';

	switch (CheckMode){
		case 1 :
			// 事業部選択時のチェック
			if ( myForm.orgCd1.value == '' || myForm.orgCd2.value == '' ){
				strErrMsg = '事業部を選択する場合、団体コードは必須入力です。';
			}
			break;
		case 2 :
			// 室部選択時のチェック
			if ( (myForm.orgCd1.value == '' || myForm.orgCd2.value == '' ) && myForm.orgBsdCd.value == '' ){
				strErrMsg = '室部を選択する場合、団体，事業部コードは必須入力です。';
			}
			break;
		case 3 :
			// 所属選択時のチェック
			if ( (myForm.orgCd1.value == '' || myForm.orgCd2.value == '' ) && myForm.orgBsdCd.value == '' && myForm.orgRoomCd.value == '' ){
				strErrMsg = '所属を選択する場合、団体，事業部，室部コードは必須入力です。';
			}
			break;
	}

	if( strErrMsg != '' ){
		alert(strErrMsg);
		return ret;
	}

	return(true);
}


var lngSelectedIndex;	/* ガイド表示時に選択された検査項目のインデックス */

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
				if ((itmGuide_itemCd[i] == document.step2.itemCd[j].value) && (itmGuide_suffix[i] == document.step2.suffix[j].value)) {
					okFlg = false;
					break;
				}
				j = j + 1;
			} while (j < <%= mlngRowCountItem %>)
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

	icount = <%= mlngRowCountItem %> - lngSelectedIndex;			/* ループ回数を計算 */

	// 予め退避したインデックス先の検査項目情報に、ガイド画面で設定された連絡域の値を編集
	if ( itmGuide_itemCd.length > 0 ) {
		for (i = 0; i < icount; i++ ) {
			if (i < itmOK.length) {
				document.step2.itemCd[lngSelectedIndex + i].value = itmGuide_itemCd[itmOK[i]];
				document.step2.suffix[lngSelectedIndex + i].value = itmGuide_suffix[itmOK[i]];
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
	document.step2.itemCd[index].value = '';
	document.step2.suffix[index].value = '';

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

// 検査項目説明呼び出し
function callDtlGuide( index ) {

	var index;						/* インデックス */

	// 説明画面の連絡域に画面入力値を設定する
	dtlGuide_ItemCd       = document.step2.itemCd[index].value;
	dtlGuide_Suffix       = document.step2.suffix[index].value;
	dtlGuide_CsCd         = document.step2.csCd.options[document.step2.csCd.selectedIndex].value;
	dtlGuide_CslDateYear  = '';
	dtlGuide_CslDateMonth = '';
	dtlGuide_CslDateDay   = '';
	dtlGuide_Age          = '';
	dtlGuide_Gender       = document.step2.gender.options[document.step2.gender.selectedIndex].value;
	if (dtlGuide_Gender == '0') {
		dtlGuide_Gender = '';		/* 性別指定無しの時 */
	}

	// 検査項目説明表示
	showGuideDtl();

	return false;
}

// エレメントの参照設定
function setElement() {

	with ( document.step2 ) {
//		orgPostGuide_getElement( orgCd1, orgCd2, 'orgname', orgBsdCd, 'orgBsdName', orgRoomCd, 'orgRoomName', orgPostCd1, 'OrgPostName1', orgPostCd2, 'OrgPostName2' );
		orgPostGuide_getElement( orgCd1, orgCd2, 'orgname', '', '', '', '', '', '', '', '' );

	}

}
//-->

</SCRIPT>
<STYLE TYPE="text/css">
td.datatab  { background-color:#ffffff }
</STYLE>
</HEAD>

<BODY  ONLOAD="javascript:setElement()" ONUNLOAD="JavaScript:orgGuide_closeGuideOrg()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="step2" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="edit" VALUE="">
	<INPUT TYPE="hidden" NAME="step" VALUE="<%= mstrStep %>">

	<INPUT TYPE="hidden" NAME="chkDate"   VALUE="<%= mstrChkDate %>"  >
	<INPUT TYPE="hidden" NAME="chkCsCd"   VALUE="<%= mstrChkCsCd %>"  >
	<INPUT TYPE="hidden" NAME="chkOrgCd"  VALUE="<%= mstrChkOrgCd %>" >
	<INPUT TYPE="hidden" NAME="chkOrgBsdCd"  VALUE="<%= mstrChkOrgBsdCd %>" >
	<INPUT TYPE="hidden" NAME="chkOrgRoomCd"  VALUE="<%= mstrChkOrgRoomCd %>" >
	<INPUT TYPE="hidden" NAME="chkOrgPostCd"  VALUE="<%= mstrChkOrgPostCd %>" >
	<INPUT TYPE="hidden" NAME="chkAge"    VALUE="<%= mstrChkAge %>"   >
	<INPUT TYPE="hidden" NAME="chkJud"    VALUE="<%= mstrChkJud %>"   >
	<INPUT TYPE="hidden" NAME="chkPerID"  VALUE="<%= mstrChkPerID %>" >
	<INPUT TYPE="hidden" NAME="chkName"   VALUE="<%= mstrChkName %>"  >
	<INPUT TYPE="hidden" NAME="chkBirth"  VALUE="<%= mstrChkBirth %>" >
	<INPUT TYPE="hidden" NAME="chkGender" VALUE="<%= mstrChkGender %>">
	<INPUT TYPE="hidden" NAME="optResult" VALUE="<%= mstrOptResult %>">
	<INPUT TYPE="hidden" NAME="rowCount"  VALUE="<%= mlngRowCount %>" >
	<INPUT TYPE="hidden" NAME="chkPEmpNo"  VALUE="<%= mstrChkEmpNo %>" >
	<INPUT TYPE="hidden" NAME="chkPOrgCd"  VALUE="<%= mstrChkPOrgCd %>" >
	<INPUT TYPE="hidden" NAME="chkPOrgBsdCd"  VALUE="<%= mstrChkPOrgBsdCd %>" >
	<INPUT TYPE="hidden" NAME="chkPOrgRoomCd"  VALUE="<%= mstrChkPOrgRoomCd %>" >
	<INPUT TYPE="hidden" NAME="chkPOrgPostCd"  VALUE="<%= mstrChkPOrgPostCd %>" >
	<INPUT TYPE="hidden" NAME="chkOverTime"  VALUE="<%= mstrChkOverTime %>" >
	<% For i = 0 To mlngRowCount - 1 %>
		<INPUT TYPE="hidden" NAME="selItemCd" VALUE="<%= mstrArrSelItemCd(i) %>">
		<INPUT TYPE="hidden" NAME="selSuffix" VALUE="<%= mstrArrSelSuffix(i) %>">
	<% Next %>
	<INPUT TYPE="hidden" NAME="chkOption" VALUE="<%= mstrChkOption %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="download">■</SPAN><FONT COLOR="#000000">抽出条件の指定</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'メッセージの編集
	If Not IsEmpty(strArrMessage) Then
		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
	Else
		If mstrEdit = "on" And mlngCount = 0 Then
			Call EditMessage("指定のデータはありませんでした｡", MESSAGETYPE_NORMAL)
		End If
	End If
%>
	<BR>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD BGCOLOR="#eeeeee">受診歴条件</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
						<TD NOWRAP>受診日</TD>
						<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>
							<%= EditSelectYearList(YEARS_SYSTEM, "strYear", mlngStrYear) %>年
							<%= EditSelectNumberList("strMonth", 1, 12, mlngStrMonth) %>月
							<%= EditSelectNumberList("strDay",   1, 31, mlngStrDay  ) %>日～
							<%= EditSelectYearList(YEARS_SYSTEM, "endYear", mlngEndYear) %>年
							<%= EditSelectNumberList("endMonth", 1, 12, mlngEndMonth) %>月
							<%= EditSelectNumberList("endDay",   1, 31, mlngEndDay  ) %>日
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
						<TD NOWRAP>コース</TD>
						<TD>：</TD>
			<TD>
				<%= EditCourseList("csCd", mstrCsCd, SELECTED_ALL) %>
			</TD>
		</TR>
<!--
					<tr>
						<td nowrap>サブコース</td>
						<td>：</td>
						<td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_SUB, "SubcsCd", Empty, NON_SELECTED_ADD, False) %></td>
					</tr>
-->
					<TR>
						<TD NOWRAP>団体</TD>
						<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return callOrgGuide()"><IMG SRC="../../images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
						<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return clearOrgCd()"  ><IMG SRC="../../images/delicon.gif"  BORDER="0" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"  ></A></TD>
						<TD WIDTH="5"></TD>
						<TD WIDTH="300">
							<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= mstrOrgCd1 %>">
							<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= mstrOrgCd2 %>">
							<SPAN ID="orgname"><%= strOrgName %></SPAN>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
<!--
		<TR>
			<TD NOWRAP>事業部</TD>
			<TD>：</TD>
			<TD><TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgBsd()"><IMG SRC="/webHains/images/question.gif" BORDER="0"  WIDTH="21" HEIGHT="21" ALT="事業部検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgBsdInfo()"><IMG SRC="/webHains/images/delicon.gif"  BORDER="0" WIDTH="21" HEIGHT="21" ALT="事業所をクリア"></A></TD>
			<INPUT TYPE="hidden" NAME="orgBsdCd"  VALUE="<%= mstrOrgBsdCd %>">
			<TD><SPAN ID="orgBsdName"><%= strOrgBsdName %></SPAN></TD>
			</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>室部</TD>
			<TD>：</TD>
			<TD >
			  <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			    <TD><A HREF="javascript:orgPostGuide_showGuideOrgRoom()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="室部検索ガイドを表示"></A></TD>
			    <TD><A HREF="javascript:orgPostGuide_clearOrgRoomInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="室部をクリア"></A></TD>
			      <INPUT TYPE="hidden" NAME="orgRoomCd"  VALUE="<%= mstrOrgRoomCd %>">
			    <TD><SPAN ID="orgRoomName"><%= strOrgRoomName %></SPAN></TD>
			  </TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>所属</TD>
			<TD>：</TD>
			<TD>
			  <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			    <TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
			    <TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="所属をクリア"></A></TD>
			      <INPUT TYPE="hidden" NAME="orgPostCd1"  VALUE="<%= mstrOrgPostCd1 %>">
			    <TD><SPAN ID="OrgPostName1"><%= strOrgPostName1 %></SPAN></TD>
			    <TD ALIGN="left">～</TD>
			    <TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(2)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
			    <TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(2)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="所属をクリア"></A></TD>
			      <INPUT TYPE="hidden" NAME="orgPostCd2"  VALUE="<%= mstrOrgPostCd2 %>">
			    <TD><SPAN ID="OrgPostName2"><%= strOrgPostName2 %></SPAN></TD>
			  </TABLE>
			</TD>
		</TR>
-->
			<TR>
			<TD NOWRAP>受診時年齢</TD>
			<TD>：</TD>
			<TD><TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
						<TD><%= EditSelectNumberList("strAgeY", 0, 150, CLng(IIf(mstrStrAgeY = "", "-1", mstrStrAgeY))) %></TD>
						<TD>．</TD>
						<TD><%= EditSelectNumberList("strAgeM", 0,  11, CLng(IIf(mstrStrAgeM = "", "-1", mstrStrAgeM))) %></TD>
						<TD>歳以上</TD>
						<TD><%= EditSelectNumberList("endAgeY", 0, 150, CLng(IIf(mstrEndAgeY = "", "-1", mstrEndAgeY))) %></TD>
						<TD>．</TD>
						<TD><%= EditSelectNumberList("endAgeM", 0,  11, CLng(IIf(mstrEndAgeM = "", "-1", mstrEndAgeM))) %></TD>
						<TD>歳以下</TD>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>性別</TD>
			<TD>：</TD>
			<TD><TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><%= EditGenderList("gender", CStr(mlngGender), NON_SELECTED_DEL) %></TD>
				</TR>
			  </TABLE>
			</TD>
		</TR>
	</TABLE>
	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD BGCOLOR="#eeeeee">検査項目</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
<%
		For i = 0 To mlngRowCountItem - 1
%>
			<TR>
				<TD>
					<A HREF="javascript:function voi(){};voi()" ONCLICK="return callItmGuide(<%= i %>)"><IMG SRC="../../images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="項目ガイドを表示"  ></A>
					<A HREF="javascript:function voi(){};voi()" ONCLICK="return clearItemCd(<%= i %>)" ><IMG SRC="../../images/delicon.gif"  BORDER="0" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A>
				</TD>
				<TD WIDTH="90" NOWRAP>
					<INPUT TYPE="hidden" NAME="itemCd" VALUE="<%= mstrArrItemCd(i) %>">
					<INPUT TYPE="hidden" NAME="suffix" VALUE="<%= mstrArrSuffix(i) %>">
					<A HREF="javascript:function voi(){};voi()" ONCLICK="return callDtlGuide('<%= i %>')"><SPAN ID="itemname<%= i %>"><%= strArrItemName(i) %></SPAN></A>
				</TD>
				<TD>の検査結果が</TD>
				<TD><INPUT TYPE="text" NAME="rslValueFrom" SIZE="12" MAXLENGTH="8" VALUE="<%= mstrArrRslValueFrom(i) %>"></TD>
				<TD><%= EditSignList("rslSignFrom", mstrArrRslMarkFrom(i), NON_SELECTED_ADD) %></TD>
				<TD>～</TD>
				<TD><INPUT TYPE="text" NAME="rslValueTo"   SIZE="12" MAXLENGTH="8" VALUE="<%= mstrArrRslValueTo(i) %>"  ></TD>
				<TD><%= EditSignList("rslSignTo",   mstrArrRslMarkTo(i),   NON_SELECTED_ADD) %></TD>
			</TR>
<%
		Next
%>
		<TR>
			<TD ALIGN="right" COLSPAN="8">
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>追加検査項目を&nbsp;</TD>
						<TD>
							<SELECT NAME="rowCountItem">
							<% For i = 10 To 50 Step 10 %>
								<OPTION VALUE="<%= i %>" <%= IIf(i = mlngRowCountItem, "SELECTED", "") %>><%= i %>個
							<% Next %>
							</SELECT>
						</TD>
						<TD>
							<INPUT TYPE="image" NAME="change" ONCLICK="document.step2.edit.value='';" SRC="../../images/b_prev.gif" BORDER="0" WIDTH="53" HEIGHT="28" ALT="表示">
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD BGCOLOR="#eeeeee">総合判定</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="judAll" VALUE="0" <%= IIf(mlngJudAll = 0, "CHECKED", "") %>></TD>
			<TD>すべての判定分類を抽出</TD>
			<TD><INPUT TYPE="radio" NAME="judAll" VALUE="1" <%= IIf(mlngJudAll = 1, "CHECKED", "") %>></TD>
			<TD>以下の条件を満たす判定分類のみを抽出</TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
<%
		For i = 0 To mlngRowCountJud - 1
%>
			<TR>
				<TD><%= EditJudClassList("judClass", mstrArrJudClassCd(i), NON_SELECTED_ADD) %></TD>
				<TD>の判定結果が</TD>
				<TD><%= EditJudList("judValueFrom", mstrArrJudValueFrom(i)) %></TD>
				<TD><%= EditSignList("judSignFrom", mstrArrJudMarkFrom(i), NON_SELECTED_ADD) %></TD>
				<TD>～</TD>
				<TD><%= EditJudList("judValueTo",   mstrArrJudValueTo(i)) %></TD>
				<TD><%= EditSignList("judSignTo",   mstrArrJudMarkTo(i),   NON_SELECTED_ADD) %></TD>
			</TR>
<%
		Next
%>
		<TR>
			<TD COLSPAN="3">
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="radio" NAME="judOperation" VALUE="0" <%= IIf(mlngJudOperation = 0, "CHECKED", "") %>></TD>
						<TD>AND</TD>
						<TD><INPUT TYPE="radio" NAME="judOperation" VALUE="1" <%= IIf(mlngJudOperation = 1, "CHECKED", "") %>></TD>
						<TD>OR</TD>
					</TR>
				</TABLE>
			</TD>
			<TD ALIGN="right" COLSPAN="5">
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>追加分野を&nbsp;</TD>
						<TD>
							<SELECT NAME="rowCountJud">
							<% For i = 5 To 20 Step 5 %>
								<OPTION VALUE="<%= i %>" <%= IIf(i = mlngRowCountJud, "SELECTED", "") %>><%= i %>個
							<% Next %>
							</SELECT>
						</TD>
						<TD>
							<INPUT TYPE="image" NAME="change" ONCLICK="document.step2.edit.value='';" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示">
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR>
	<A HREF="javascript:function voi(){};voi()" ONCLICK="document.step2.edit.value='on';document.step2.submit();return false;"><IMG SRC="/webHains/images/DataSelect.gif"></A></TD>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>