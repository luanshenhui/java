<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		個人検査情報メンテナンス (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon		'共通クラス
Dim objPerResult	'個人検査結果情報アクセス用
Dim objPerson		'個人情報アクセス用

'引数部
Dim strAction		'動作モード
Dim strPerId		'個人ID

'個人検査情報
Dim strItemCd		'検査項目コード
Dim strSuffix		'サフィックス
Dim strItemName		'検査項目名称
Dim strResult		'検査結果
Dim strResultType	'結果タイプ
Dim strItemType		'項目タイプ
Dim strStcItemCd	'文章参照用項目コード
Dim strShortStc		'文章略称
Dim strIspDate		'検査日
Dim strIspYear		'検査日(年)
Dim strIspMonth		'検査日(月)
Dim strIspDay		'検査日(日)
Dim lngCount		'レコード件数

'個人情報
Dim strLastName		'姓
Dim strFirstName	'名
Dim strLastKName	'カナ姓	
Dim strFirstKName	'カナ名
Dim strBirth		'生年月日
Dim strAge			'年齢
Dim strGender		'性別
Dim strGenderName	'性別名称

Dim lngStartYear	'表示開始年
Dim lngEndYear		'表示終了年
Dim strArrMessage	'エラーメッセージ
Dim i				'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon    = Server.CreateObject("HainsCommon.Common")
Set objPerResult = Server.CreateObject("HainsPerResult.PerResult")
Set objPerson    = Server.CreateObject("HainsPerson.Person")

'引数値の取得
strAction     = Request("act")
strPerId      = Request("perId")

'個人検査結果情報
strItemCd     = ConvIStringToArray(Request("itemCd"))
strSuffix     = ConvIStringToArray(Request("suffix"))
strItemName   = ConvIStringToArray(Request("itemName"))
strResult     = ConvIStringToArray(Request("result"))
strResultType = ConvIStringToArray(Request("resultType"))
strItemType   = ConvIStringToArray(Request("itemType"))
strStcItemCd  = ConvIStringToArray(Request("stcItemCd"))
strShortStc   = ConvIStringToArray(Request("shortStc"))
strIspYear    = ConvIStringToArray(Request("ispYear"))
strIspMonth   = ConvIStringToArray(Request("ispMonth"))
strIspDay     = ConvIStringToArray(Request("ispDay"))

'検査項目数の取得
If Not IsEmpty(strItemCd) Then
	lngCount = UBound(strItemCd) + 1
End If

'検査日の編集
If lngCount > 0 Then
	strIspDate = Array()
	ReDim Preserve strIspDate(lngCount - 1)
	For i = 0 To UBound(strIspDate)
		If strIspYear(i) <> "" Or strIspMonth(i) <> "" Or strIspDay(i) <> "" Then
			strIspDate(i) = strIspYear(i) & "/" & strIspMonth(i) & "/" & strIspDay(i)
		End If
	Next
End If

'検査日表示用にシステム管理年範囲を取得
objCommon.SelectYearsRangeSystem lngStartYear, lngEndYear
lngStartYear = IIf(lngStartYear = 0, YEARRANGE_MIN, lngStartYear)
lngEndYear   = IIf(lngEndYear   = 0, YEARRANGE_MAX, lngEndYear  )

'チェック・更新・読み込み処理の制御
Do

	'保存ボタン押下時
	If strAction = "save" Then

		'検査日チェック(検査結果はチェックしない)
		For i = 0 To UBound(strItemCd)
			If strIspDate(i) <> "" Then
				If Not IsDate(strIspDate(i)) Then
					objCommon.AppendArray strArrMessage, "「" & strItemName(i) & "」検査日の入力形式が正しくありません。"
				End If
			End If
		Next

		'検査日チェックにてエラーが存在する場合は処理を終了する
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'個人検査結果保存
		objPerResult.UpdatePerResult strPerId, strItemCd, strSuffix, strResult, strIspDate

		'エラーがなければ自分自身をリダイレクト
		Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?act=saveend&perId=" & strPerId
		Response.End

	End If

	'個人検査結果読み込み
	lngCount = objPerResult.SelectPerResultList(strPerID, strItemCd, strSuffix, strItemName, strResult, strResultType, strItemType, strStcItemCd, strShortStc, strIspDate)
	If lngCount = 0 Then
		Exit Do
	End If

	'検査日を年・月・日に分割
	strIspYear  = Array()
	strIspMonth = Array()
	strIspDay   = Array()
	ReDim Preserve strIspYear(lngCount - 1)
	ReDim Preserve strIspMonth(lngCount - 1)
	ReDim Preserve strIspDay(lngCount - 1)
	For i = 0 To UBound(strIspDate)
		If strIspDate(i) <> "" Then
			strIspYear(i)  = Year(strIspDate(i))
			strIspMonth(i) = Month(strIspDate(i))
			strIspDay(i)   = Day(strIspDate(i))
		End If
	Next

	Exit Do
Loop

'個人情報読み込み
objPerson.SelectPersonInf strPerId, strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGender, strGenderName, strAge

'-----------------------------------------------------------------------------
' メッセージの編集
'-----------------------------------------------------------------------------
Sub EditPerResultList()

	Const ALIGNMENT_RIGHT = "STYLE=""text-align:right"""	'右寄せ

	Dim strAlignMent	'表示位置

	If lngCount = 0 Then
%>
		個人検査情報は存在しません
<%
		Exit Sub
	End If
%>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR BGCOLOR="#eeeeee">
			<TD WIDTH="128" HEIGHT="21" ALIGN="right">検査項目名</TD>
			<TD COLSPAN="2">検査結果</TD>
			<TD WIDTH="180" NOWRAP>文章</TD>
			<TD>更新時予約日</TD>
		</TR>
<% 
		For i = 0 To lngCount - 1
%>
			<INPUT TYPE="hidden" NAME="itemCd"     VALUE="<%= strItemCd(i)     %>">
			<INPUT TYPE="hidden" NAME="suffix"     VALUE="<%= strSuffix(i)     %>">
			<INPUT TYPE="hidden" NAME="itemName"   VALUE="<%= strItemName(i)   %>">
			<INPUT TYPE="hidden" NAME="resultType" VALUE="<%= strResultType(i) %>">
			<INPUT TYPE="hidden" NAME="itemType"   VALUE="<%= strItemType(i)   %>">
			<INPUT TYPE="hidden" NAME="stcItemCd"  VALUE="<%= strStcItemCd(i)  %>">
			<INPUT TYPE="hidden" NAME="shortStc"   VALUE="<%= strShortStc(i)   %>">
			<TR BGCOLOR="#eeeeee">
				<TD WIDTH="128" NOWRAP ALIGN="right"><A HREF="javascript:callDtlGuide('<%= i %>')"><%= strItemName(i) %></A></TD>
<%
				Select Case CLng(strResultType(i))

					'定性ガイド表示
					Case RESULTTYPE_TEISEI1, RESULTTYPE_TEISEI2
%>
						<TD><A HREF="javascript:callTseGuide('<%= i %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="定性ガイド表示"></A></TD>
<%
					'文章ガイド表示
					Case RESULTTYPE_SENTENCE
%>
						<TD><A HREF="javascript:callStcGuide('<%= i %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="文章ガイド表示"></A></TD>
<%
					'ガイド表示なし
					Case Else
%>
						<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21"></TD>
<%
				End Select

				'検査結果

				'計算結果の場合
				If CLng(strResultType(i)) = RESULTTYPE_CALC Then
%>
					<TD ALIGN="right" WIDTH="75"><INPUT TYPE="hidden" NAME="result" VALUE="<%= strResult(i) %>"><%= strResult(i) %>&nbsp;</TD>
<%
				'それ以外の場合
				Else

					'スタイルシートの設定
					strAlignment   = IIf(CLng(strResultType(i)) = RESULTTYPE_NUMERIC, ALIGNMENT_RIGHT, "")
%>
					<TD WIDTH="75"><INPUT TYPE="text" NAME="result" SIZE="<%= TextLength(9) %>" MAXLENGTH="8" VALUE="<%= strResult(i) %>" <%= strAlignment %> ONCHANGE="clearStcName('<%= i %>')"></TD>
<%
				End If
%>
				<TD WIDTH="180" NOWRAP><SPAN ID="stcName<%= i %>" STYLE="position:relative"><%= IIf(strShortStc(i) <> "", strShortStc(i), "&nbsp;") %></SPAN></TD>
				<TD>
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
							<TD><%= EditNumberList("ispYear", lngStartYear, lngEndYear, strIspYear(i), True) %></TD>
							<TD>年</TD>
							<TD><%= EditNumberList("ispMonth", 1, 12, strIspMonth(i), True) %></TD>
							<TD>月</TD>
							<TD><%= EditNumberList("ispDay", 1, 31, strIspDay(i), True) %></TD>
							<TD>日</TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
<%
		Next
%>
	</TABLE>
<%
End Sub
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>個人検査情報メンテナンス</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc" -->
<!-- #include virtual = "/webHains/includes/dtlGuide.inc" -->
<!-- #include virtual = "/webHains/includes/tseGuide.inc" -->
<!--
var lngSelectedIndex;  // ガイド表示時に選択されたエレメントのインデックス

// 文章ガイド呼び出し
function callStcGuide( index ) {

	var myForm = document.perResult;

	// 選択されたエレメントのインデックスを退避(文章コード・略文章のセット用関数にて使用する)
	lngSelectedIndex = index;

	// ガイド画面の連絡域に検査項目コードを設定する
	if ( myForm.stcItemCd.length != null ) {
		stcGuide_ItemCd = myForm.stcItemCd[ index ].value;
	} else {
		stcGuide_ItemCd = myForm.stcItemCd.value;
	}

	// ガイド画面の連絡域に項目タイプ（標準）を設定する
	if ( myForm.itemType.length != null ) {
		stcGuide_ItemType = myForm.itemType[ index ].value;
	} else {
		stcGuide_ItemType = myForm.itemType.value;
	}

	// ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
	stcGuide_CalledFunction = setStcInfo;

	// 文章ガイド表示
	showGuideStc();
}

// 文章コード・略文章のセット
function setStcInfo() {

	var myForm = document.perResult;

	var stcNameElement; // 略文章を編集するエレメントの名称
	var stcName;        // 略文章を編集するエレメント自身

	// 予め退避したインデックス先のエレメントに、ガイド画面で設定された連絡域の値を編集
	if ( myForm.result.length != null ) {
		myForm.result[lngSelectedIndex].value = stcGuide_StcCd;
	} else {
		myForm.result.value = stcGuide_StcCd;
	}
	if ( myForm.shortStc.length != null ) {
		myForm.shortStc[lngSelectedIndex].value = stcGuide_ShortStc;
	} else {
		myForm.shortStc.value = stcGuide_ShortStc;
	}

	// ブラウザごとの団体名編集用エレメントの設定処理
	for ( ; ; ) {

		// エレメント名の編集
		stcNameElement = 'stcName' + lngSelectedIndex;

		// IEの場合
		if ( document.all ) {
			document.all(stcNameElement).innerHTML = stcGuide_ShortStc;
			break;
		}

		// Netscape6の場合
		if ( document.getElementById ) {
			document.getElementById(stcNameElement).innerHTML = stcGuide_ShortStc;
		}

		break;
	}

	return false;
}

// 検査項目説明呼び出し
function callDtlGuide( index ) {

	// 説明画面の連絡域に画面入力値を設定する
	dtlGuide_ItemCd       = document.perResult.itemCd[ index ].value;
	dtlGuide_Suffix       = document.perResult.suffix[ index ].value;
	dtlGuide_CsCd         = '';
	dtlGuide_CslDateYear  = '<%= Year(Now())  %>';
	dtlGuide_CslDateMonth = '<%= Month(Now()) %>';
	dtlGuide_CslDateDay   = '<%= Day(Now())   %>';
	dtlGuide_Age          = '';
	dtlGuide_Gender       = '<%= strGender    %>';

	// 検査項目説明表示
	showGuideDtl();
}

// ページ送信処理
function goNextPage() {

	document.perResult.submit();

	return false;

}

// 定性ガイド呼び出し
function callTseGuide( index ) {

	var myForm = document.perResult;

	// 選択されたエレメントのインデックスを退避(定性結果のセット用関数にて使用する)
	lngSelectedIndex = index;

	// ガイド画面の連絡域に項目タイプを設定する
	if ( myForm.resultType.length != null ) {
		tseGuide_ResultType = myForm.resultType[ index ].value;
	} else {
		tseGuide_ResultType = myForm.resultType.value;
	}

	// ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
	tseGuide_CalledFunction = setTseInfo;

	// 定性ガイド表示
	showGuideTse();
}

// 定性結果のセット
function setTseInfo() {

	var myForm = document.perResult;

	// 予め退避したインデックス先のエレメントに、ガイド画面で設定された連絡域の値を編集
	if ( myForm.result.length != null ) {
		myForm.result[lngSelectedIndex].value = tseGuide_Result;
	} else {
		myForm.result.value = tseGuide_Result;
	}
	return false;
}

// 文章削除
function clearStcName( index ) {

	var stcNameElement; // 略文章を編集するエレメントの名称

	var myForm = document.perResult;

	if ( myForm.shortStc.length != null ) {
		myForm.shortStc[index].value = '';
	} else {
		myForm.shortStc.value = '';
	}

	// ブラウザごとの団体名編集用エレメントの設定処理
	for ( ; ; ) {

		// エレメント名の編集
		stcNameElement = 'stcName' + index;

		// IEの場合
		if ( document.all ) {
			document.all(stcNameElement).innerHTML = '';
			break;
		}

		// Netscape6の場合
		if ( document.getElementById ) {
			document.getElementById(stcNameElement).innerHTML = '';
		}

		break;
	}

	return false;
}

function saveResult() {

	document.perResult.submit();

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="perResult" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="act"   VALUE="save">
	<INPUT TYPE="hidden" NAME="perID" VALUE="<%= strPerID %>">

	<!-- 表題 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">個人検査情報メンテナンス</FONT></B></TD>
		</TR>
	</TABLE>

	<!-- 操作ボタン -->
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD ALIGN="right">
				<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0">
					<TR>
						<TD><A HREF="mntPersonal.asp?mode=update&perId=<%= strPerId %>"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="検索画面に戻ります"></A></TD>
						<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7"></TD>
<%
						If lngCount > 0 Then
%>
							<TD>
							<% '2005.08.22 権限管理 Add by 李　--- START %>
							<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
								<A HREF="javascript:saveResult()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="入力したデータを保存します"></A>
							<%  else    %>
								 &nbsp;
							<%  end if  %>
							<% '2005.08.22 権限管理 Add by 李　--- END %>
							</TD>

							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7"></TD>
<%
						End If
%>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	If strAction <> "" Then

		'保存完了時は「保存完了」の通知
		If strAction = "saveend" Then
			Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

		'さもなくばエラーメッセージを編集
		Else
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If

	End If
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD><%= strPerID %></TD>
			<TD NOWRAP><B><%= strLastName %>　<%= strFirstName %></B> (<FONT SIZE="-1"><%= strLastKName %>　<%= strFirstKName %></FONT>)</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><%= objCommon.FormatString(strBirth, "gee.mm.dd") %>生　<%= strAge %>歳　<%= strGenderName %></TD>
		</TR>
	</TABLE>

	<INPUT TYPE="hidden" NAME="gender" VALUE="<%= strGender %>">

	<BR>
<%
	'個人検査結果情報の編集
	Call EditPerResultList
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
