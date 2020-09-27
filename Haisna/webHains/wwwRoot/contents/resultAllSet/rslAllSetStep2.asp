<%
'-----------------------------------------------------------------------------
'		結果一括入力(一括結果値入力) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
%>
<!-- #include virtual = "/webHains/includes/EditCourseList.inc" -->
<%
'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const ALIGNMENT_RIGHT = "STYLE=""text-align:right"""	'右寄せ
Const CLASS_ERROR     = "CLASS=""rslErr"""				'エラー表示のクラス指定

Dim objCourse			'コースアクセス用COMオブジェクト
Dim objGrp				'グループアクセス用COMオブジェクト

Dim strAction			'処理モード

Dim lngItemCount		'検査項目数

Dim strArrItemCd()		'編集用検査項目コード
Dim strArrSuffix()		'編集用サフィックス
Dim strArrItemName()	'編集用検査項目名称
Dim strArrResultType()	'編集用結果タイプ
Dim strArrItemType()	'編集用項目タイプ
Dim strArrResult()		'編集用検査結果
Dim strArrResultErr()	'編集用検査結果エラー
Dim strArrShortStc()	'編集用文章略称
Dim lngArrPos()			'結果配列位置
Dim lngArraySize		'配列サイズ

Dim strOldItemCd		'保存用検査項目コード
Dim strOldSuffix		'保存用サフィックス
Dim strOldItemType		'保存用項目タイプ

Dim strElementName		'エレメント名

Dim strAlignMent		'表示位置
Dim strClass			'スタイルシートのCLASS指定

Dim strCsName			'コース名
'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
If Request.ServerVariables("HTTP_REFERER") = "" Then
	Response.End
End If

'オブジェクトのインスタンス作成
Set objGrp = Server.CreateObject("HainsGrp.Grp")

'引数値の取得
strAction = Request("act")

'読み込み処理の制御
Do

	'「次へ」「保存」ボタン押下時にここへ飛んできた場合は何らかのエラーが発生している場合なので処理を抜ける
	If strAction = "next" Or strAction = "save" Then
		Exit Do
	End If

	'デフォルト展開時
	If strAction = "develop" Then

		'結果初期値を設定する
		lngItemCount = objGrp.SelectGrp_I_ItemDefResultList(mstrGrpCd, _
															mstrCslDate, _
															mstrItemCd, _
															mstrSuffix, _
															mstrItemName, _
															mstrResultType, _
															mstrItemType, _
															mstrResult, _
															mstrStcItemCd, _
															mstrShortStc)

		'結果・文章略称および結果チェック用の配列作成
		If lngItemCount > 0 Then
			mstrResultErr = Array()
			ReDim Preserve mstrResultErr(lngItemCount - 1)
		End If

		Exit Do
	End If

	'検査項目読み込み
	lngItemCount = objGrp.SelectGrp_I_ItemList(mstrGrpCd, mstrItemCd, mstrSuffix, mstrItemName, mstrResultType, mstrItemType, mstrStcItemCd)
	If lngItemCount <= 0 Then
		mstrArrMessage("この検査グループに属する検査項目は存在しません。")
		Exit Do
	End If

	'結果・文章略称および結果チェック用の配列作成
	If lngItemCount > 0 Then
		mstrResult    = Array()
		mstrShortStc  = Array()
		mstrResultErr = Array()
		ReDim Preserve mstrResult(lngItemCount - 1)
		ReDim Preserve mstrShortStc(lngItemCount - 1)
		ReDim Preserve mstrResultErr(lngItemCount - 1)
	End If

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>一括結果値入力</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc" -->
<!-- #include virtual = "/webHains/includes/tseGuide.inc" -->
<!--
var lngSelectedIndex1;	// ガイド表示時に選択されたエレメントのインデックス
var lngSelectedIndex2;	// ガイド表示時に選択されたエレメントのインデックス
var lngSelectedIndex3;	// ガイド表示時に選択されたエレメントのインデックス

// 文章ガイド呼び出し
function callStcGuide( index1, index2, index3 ) {

	// 選択されたエレメントのインデックスを退避(文章コード・略文章のセット用関数にて使用する)
	lngSelectedIndex1 = index1;
	lngSelectedIndex2 = index2;
	lngSelectedIndex3 = index3;

	// ガイド画面の連絡域に検査項目コードを設定する
	if ( document.step2.stcItemCd.length != null ) {
		stcGuide_ItemCd = document.step2.stcItemCd[ index1 ].value;
	} else {
		stcGuide_ItemCd = document.step2.stcItemCd.value;
	}

	// ガイド画面の連絡域に項目タイプ（標準）を設定する
	if ( document.step2.itemType.length != null ) {
		stcGuide_ItemType = document.step2.itemType[ index1 ].value;
	} else {
		stcGuide_ItemType = document.step2.itemType.value;
	}

	// ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
	stcGuide_CalledFunction = setStcInfo;

	// 文章ガイド表示
	showGuideStc();
}

// 文章コード・略文章のセット
function setStcInfo() {

	var stcNameElement;	// 略文章を編集するエレメントの名称
	var stcName;		// 略文章を編集するエレメント自身

	// 予め退避したインデックス先のエレメントに、ガイド画面で設定された連絡域の値を編集
	if ( document.step2.result.length != null ) {
		document.step2.result[lngSelectedIndex1].value = stcGuide_StcCd;
	} else {
		document.step2.result.value = stcGuide_StcCd;
	}
	if ( document.step2.shortStc.length != null ) {
		document.step2.shortStc[lngSelectedIndex1].value = stcGuide_ShortStc;
	} else {
		document.step2.shortStc.value = stcGuide_ShortStc;
	}

	// ブラウザごとの団体名編集用エレメントの設定処理
	for ( ; ; ) {

		// エレメント名の編集
		stcNameElement = 'stcName_' + lngSelectedIndex2 + lngSelectedIndex3;

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

// 定性ガイド呼び出し
function callTseGuide( index1 ) {

	// 選択されたエレメントのインデックスを退避(検査結果のセット用関数にて使用する)
	lngSelectedIndex1 = index1;

	// ガイド画面の連絡域に結果タイプを設定する
	if ( document.step2.itemType.length != null ) {
		tseGuide_ResultType = document.step2.resultType[ index1 ].value;
	} else {
		tseGuide_ResultType = document.step2.resultType.value;
	}

	// ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
	tseGuide_CalledFunction = setTseInfo;

	// 文章ガイド表示
	showGuideTse();
}

// 検査結果のセット
function setTseInfo() {

	// 予め退避したインデックス先のエレメントに、ガイド画面で設定された連絡域の値を編集
	if ( document.step2.result.length != null ) {
		document.step2.result[lngSelectedIndex1].value = tseGuide_Result;
	} else {
		document.step2.result.value = tseGuide_Result;
	}

	return false;
}

// デフォルト展開処理
function goDevelopment() {

	document.step2.act.value   = 'develop';
	document.step2.grpCd.value = '<%= mstrGrpCd %>';
	document.step2.submit();

}

// ステップ１に戻る
function goStep1() {

	var myForm = document.step2;	// 自画面のフォームエレメント

	// 現在の保持内容そのままに、ステップ番号のみを変更してsubmit
	myForm.step.value = '1';
	myForm.submit();

}

// submit処理
function submitForm( act ) {

	// 保存時のみ確認画面を表示
	if ( act == 'save' ) {
		if ( !confirm('この内容で検査結果の一括登録を行います。よろしいですか？') ) {
			return;
		}
	}

	document.step2.act.value = act;

	// デフォルト展開時はグループコードを指定する
	if ( act == 'develop' ) {
		document.step2.grpCd.value = '<%= mstrGrpCd %>';
	}

	document.step2.submit();

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsltab  { background-color:#FFFFFF }
</STYLE>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="step2" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<%
	'自分自身のステップ番号を保持し、制御用のASPで使用する
%>
	<INPUT TYPE="hidden" NAME="step" VALUE="<%= mstrStep %>">

	<INPUT TYPE="hidden" NAME="act"  VALUE="">

	<!-- Step1からの引き継ぎ情報 -->

	<INPUT TYPE="hidden" NAME="year"   VALUE="<%= mlngYear   %>">
	<INPUT TYPE="hidden" NAME="month"  VALUE="<%= mlngMonth  %>">
	<INPUT TYPE="hidden" NAME="day"    VALUE="<%= mlngDay    %>">
	<INPUT TYPE="hidden" NAME="csCd"   VALUE="<%= mstrCsCd   %>">
	<INPUT TYPE="hidden" NAME="dayIdF" VALUE="<%= mstrDayIdF %>">
	<INPUT TYPE="hidden" NAME="dayIdT" VALUE="<%= mstrDayIdT %>">

	<BLOCKQUOTE>

	<!-- 表題 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">Step2：一括して登録する結果値を入力してください。</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	If Not IsEmpty(strArrMessage) Then

		'エラーメッセージ編集
		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

	End If
%>
	<BR>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
		<TR>
			<TD NOWRAP>受診日</TD>
			<TD>：</TD>
			<TD><FONT COLOR="#ff6600"><B><%= mlngYear & "/" & Right("00" & mlngMonth, 2) & "/" & Right("00" & mlngDay, 2) %></B></FONT></TD>
			<TD NOWRAP>&nbsp;&nbsp;コース</TD>
			<TD>：</TD>
<%
			'コース名の読み込み
			If mstrCsCd <> "" Then
				Set objCourse = Server.CreateObject("HainsCourse.Course")
				If objCourse.SelectCourse(mstrCsCd, strCsName) = False Then
					Err.Raise 1000, , "コース情報が存在しません。"
				End If
				Set objCourse = Nothing
			Else
				strCsName = "全てのコース"
			End If
%>
			<TD><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
			<TD NOWRAP>&nbsp;&nbsp;当日ＩＤ</TD>
			<TD>：</TD>
			<TD><FONT COLOR="#ff6600"><B><%= IIf(mstrDayIdF <> "" Or mstrDayIdT <> "", mstrDayIdF & IIf(mstrDayIdT <> "", "～", "") & mstrDayIdT, "すべて") %></B></FONT></TD>
		</TR>
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
		<TR>
			<TD>入力結果グループ：</TD>
			<TD><%= EditGrpIList_GrpDiv("grpCd", mstrGrpCd, "", "", ADD_NONE) %></TD>
			<TD>を</TD>
			<TD><A HREF="javascript:submitForm('')"><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="入力用検査項目セットを変更して表示"></A></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="650">
		<TR>
			<TD><INPUT TYPE="checkbox" NAME="allResultClear" VALUE="1"<%= IIf(mstrAllResultClear = "1", " CHECKED", "") %>>このグループの検査結果を全てクリアする</TD>
			<TD ALIGN="RIGHT">
				<A HREF="JavaScript:submitForm('develop')"><IMG SRC="/webHains/images/default.gif" WIDTH="110" HEIGHT="24" ALT="デフォルト値を展開します。"></A>
			</TD>
		</TR>
	</TABLE>
	<BR>
<%
	'配列を表示用に再編集
	For mlngIndex1 = 0 To UBound(mstrItemCd)

		'最初の処理
		If strOldItemCd = "" Then

			'編集用配列作成
			ReDim strArrItemCd(1, lngArraySize)
			ReDim strArrSuffix(1, lngArraySize)
			ReDim strArrItemName(lngArraySize)
			ReDim strArrResultType(1, lngArraySize)
			ReDim strArrItemType(1, lngArraySize)
			ReDim strArrResult(1, lngArraySize)
			ReDim strArrResultErr(1, lngArraySize)
			ReDim strArrShortStc(1, lngArraySize)
			ReDim lngArrPos(1, lngArraySize)
			lngArraySize = lngArraySize + 1

			'検査項目保存
			strOldItemCd   = mstrItemCd(mlngIndex1)
			strOldItemType = mstrItemType(mlngIndex1)

			'部位の場合
			If CStr(mstrItemType(mlngIndex1)) = CStr(ITEMTYPE_BUI) Then

				strArrItemCd(0, lngArraySize - 1)     = mstrItemCd(mlngIndex1)
				strArrSuffix(0, lngArraySize - 1)     = mstrSuffix(mlngIndex1)
				strArrResultType(0, lngArraySize - 1) = mstrResultType(mlngIndex1)
				strArrItemType(0, lngArraySize - 1)   = mstrItemType(mlngIndex1)
				strArrResult(0, lngArraySize - 1)     = mstrResult(mlngIndex1)
				strArrResultErr(0, lngArraySize - 1)  = mstrResultErr(mlngIndex1)
				strArrShortStc(0, lngArraySize - 1)   = mstrShortStc(mlngIndex1)
				lngArrPos(0, lngArraySize -1)         = mlngIndex1

			'部位以外の場合
			Else

				strArrItemCd(1, lngArraySize - 1)     = mstrItemCd(mlngIndex1)
				strArrSuffix(1, lngArraySize - 1)     = mstrSuffix(mlngIndex1)
				strArrResultType(1, lngArraySize - 1) = mstrResultType(mlngIndex1)
				strArrItemType(1, lngArraySize - 1)   = mstrItemType(mlngIndex1)
				strArrResult(1, lngArraySize - 1)     = mstrResult(mlngIndex1)
				strArrResultErr(1, lngArraySize - 1)  = mstrResultErr(mlngIndex1)
				strArrShortStc(1, lngArraySize - 1)   = mstrShortStc(mlngIndex1)
				lngArrPos(1, lngArraySize -1)         = mlngIndex1

			End If

			strArrItemName(lngArraySize - 1) = mstrItemName(mlngIndex1)

		Else

			'前項目と項目コードが一致かつ、前項目タイプが”部位”で今項目タイプが”所見”の場合
			If strOldItemCd = mstrItemCd(mlngIndex1) And CStr(strOldItemType) = CStr(ITEMTYPE_BUI) And CStr(mstrItemType(mlngIndex1)) = CStr(ITEMTYPE_SHOKEN) Then

				strArrItemCd(1, lngArraySize - 1)     = mstrItemCd(mlngIndex1)
				strArrSuffix(1, lngArraySize - 1)     = mstrSuffix(mlngIndex1)
				strArrResultType(1, lngArraySize - 1) = mstrResultType(mlngIndex1)
				strArrItemType(1, lngArraySize - 1)   = mstrItemType(mlngIndex1)
				strArrResult(1, lngArraySize - 1)     = mstrResult(mlngIndex1)
				strArrResultErr(1, lngArraySize - 1)  = mstrResultErr(mlngIndex1)
				strArrShortStc(1, lngArraySize - 1)   = mstrShortStc(mlngIndex1)
				lngArrPos(1, lngArraySize -1)         = mlngIndex1
				strArrItemName(lngArraySize - 1)      = mstrItemName(mlngIndex1)

			Else

				'編集用配列作成
				ReDim Preserve strArrItemCd(1, lngArraySize)
				ReDim Preserve strArrSuffix(1, lngArraySize)
				ReDim Preserve strArrItemName(lngArraySize)
				ReDim Preserve strArrResultType(1, lngArraySize)
				ReDim Preserve strArrItemType(1, lngArraySize)
				ReDim Preserve strArrResult(1, lngArraySize)
				ReDim Preserve strArrResultErr(1, lngArraySize)
				ReDim Preserve strArrShortStc(1, lngArraySize)
				ReDim Preserve lngArrPos(1, lngArraySize)
				lngArraySize = lngArraySize + 1

				'部位の場合
				If CStr(mstrItemType(mlngIndex1)) = CStr(ITEMTYPE_BUI) Then
					strArrItemCd(0, lngArraySize - 1)     = mstrItemCd(mlngIndex1)
					strArrSuffix(0, lngArraySize - 1)     = mstrSuffix(mlngIndex1)
					strArrResultType(0, lngArraySize - 1) = mstrResultType(mlngIndex1)
					strArrItemType(0, lngArraySize - 1)   = mstrItemType(mlngIndex1)
					strArrResult(0, lngArraySize - 1)     = mstrResult(mlngIndex1)
					strArrResultErr(0, lngArraySize - 1)  = mstrResultErr(mlngIndex1)
					strArrShortStc(0, lngArraySize - 1)   = mstrShortStc(mlngIndex1)
					lngArrPos(0, lngArraySize -1)         = mlngIndex1

				'部位以外の場合
				Else
					strArrItemCd(1, lngArraySize - 1)     = mstrItemCd(mlngIndex1)
					strArrSuffix(1, lngArraySize - 1)     = mstrSuffix(mlngIndex1)
					strArrResultType(1, lngArraySize - 1) = mstrResultType(mlngIndex1)
					strArrItemType(1, lngArraySize - 1)   = mstrItemType(mlngIndex1)
					strArrResult(1, lngArraySize - 1)     = mstrResult(mlngIndex1)
					strArrResultErr(1, lngArraySize - 1)  = mstrResultErr(mlngIndex1)
					strArrShortStc(1, lngArraySize - 1)   = mstrShortStc(mlngIndex1)
					lngArrPos(1, lngArraySize -1)         = mlngIndex1

				End If

				strArrItemName(lngArraySize - 1) = mstrItemName(mlngIndex1)

			End If

			'検査項目保存
			strOldItemCd   = mstrItemCd(mlngIndex1)
			strOldItemType = mstrItemType(mlngIndex1)

		End If

	Next

	For mlngIndex1 = 0 To UBound(mstrItemCd)
%>
		<INPUT TYPE="hidden" NAME="itemCd"     VALUE="<%= mstrItemCd(mlngIndex1)     %>">
		<INPUT TYPE="hidden" NAME="suffix"     VALUE="<%= mstrSuffix(mlngIndex1)     %>">
		<INPUT TYPE="hidden" NAME="itemName"   VALUE="<%= mstrItemName(mlngIndex1)   %>">
		<INPUT TYPE="hidden" NAME="resultType" VALUE="<%= mstrResultType(mlngIndex1) %>">
		<INPUT TYPE="hidden" NAME="itemType"   VALUE="<%= mstrItemType(mlngIndex1)   %>">
		<INPUT TYPE="hidden" NAME="resultErr"  VALUE="<%= mstrResultErr(mlngIndex1)  %>">
		<INPUT TYPE="hidden" NAME="stcItemCd"  VALUE="<%= mstrStcItemCd(mlngIndex1)  %>">
		<INPUT TYPE="hidden" NAME="shortStc"   VALUE="<%= mstrShortStc(mlngIndex1)   %>">
<%
	Next
%>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR BGCOLOR="#eeeeee">
			<TD WIDTH="110" BGCOLOR="#eeeeee" ALIGN="right"><B>検査項目名</B></TD>
			<TD WIDTH="100" COLSPAN="2"><B>部位</B></TD>
			<TD WIDTH="100" COLSPAN="2"><B>所見</B></TD>
			<TD><B>部位文章</B></TD>
			<TD><B>所見文章</B></TD>
		</TR>
<%
		For mlngIndex1 = 0 To lngArraySize - 1
%>
			<TR>
				<TD WIDTH="110" NOWRAP ALIGN="right"><%= strArrItemName(mlngIndex1) %></TD>
<%
				'ガイドボタンの編集
				If strArrItemCd(0, mlngIndex1) <> "" Then

					'部位結果ガイドボタンの編集
					Select Case strArrResultType(0, mlngIndex1)

						Case CStr(RESULTTYPE_SENTENCE)
%>
							<TD><A HREF="JavaScript:callStcGuide('<%= lngArrPos(0, mlngIndex1) %>','0','<%= mlngIndex1 %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="検査結果ガイド表示"></A></TD>
<%
						Case CStr(RESULTTYPE_TEISEI1), CStr(RESULTTYPE_TEISEI2)
%>
							<TD><A HREF="JavaScript:callTseGuide('<%= lngArrPos(0, mlngIndex1) %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="定性ガイド表示"></A></TD>
<%
						Case Else
%>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="21"></TD>
<%
					End Select

				Else
%>
					<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="21"></TD>
<%
				End If

				'結果の編集
				If strArrItemCd(0, mlngIndex1) <> "" Then

					If strArrResultType(0, mlngIndex1) = CStr(RESULTTYPE_CALC) Then
%>
						<TD><INPUT TYPE="hidden" NAME="result" VALUE="<%= strArrResult(0, mlngIndex1) %>"></TD>
<%
					Else

						'スタイルシートの設定
						strAlignment = IIf(CLng(strArrResultType(0, mlngIndex1)) = RESULTTYPE_NUMERIC, ALIGNMENT_RIGHT, "")
						strClass     = IIf(strArrResultErr(0, mlngIndex1) <> "", CLASS_ERROR, "")
%>
						<TD><INPUT TYPE="text" NAME="result" SIZE="10" MAXLENGTH="8" VALUE="<%= strArrResult(0, mlngIndex1) %>" <%= strAlignment %> <%= strClass %>></TD>
<%
					End If

				Else
%>
					<TD></TD>
<%
				End If

				'所見結果ガイドボタンの編集
				Select Case strArrResultType(1, mlngIndex1)

					Case CStr(RESULTTYPE_SENTENCE)
%>
						<TD><A HREF="JavaScript:callStcGuide('<%= lngArrPos(1, mlngIndex1) %>','1','<%= CStr(mlngIndex1) %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="検査結果ガイド表示"></A></TD>
<%
					Case CStr(RESULTTYPE_TEISEI1), CStr(RESULTTYPE_TEISEI2)
%>
						<TD><A HREF="JavaScript:callTseGuide('<%= lngArrPos(1, mlngIndex1) %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="定性ガイド表示"></A></TD>
<%
					Case Else
%>
						<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="21"></TD>
<%
				End Select

				'所見結果の編集
				If strArrItemCd(1, mlngIndex1) <> "" Then

					If CStr(strArrResultType(1, mlngIndex1)) = CStr(RESULTTYPE_CALC) Then
%>
						<TD><INPUT TYPE="hidden" NAME="result" VALUE="<%= strArrResult(1, mlngIndex1) %>"></TD>
<%
					Else

						'スタイルシートの設定
						strAlignment = IIf(CLng(strArrResultType(1, mlngIndex1)) = RESULTTYPE_NUMERIC, ALIGNMENT_RIGHT, "")
						strClass     = IIf(strArrResultErr(1, mlngIndex1) <> "", CLASS_ERROR, "")
%>
						<TD><INPUT TYPE="text" NAME="result" SIZE="10" MAXLENGTH="8" VALUE="<%= strArrResult(1, mlngIndex1) %>" <%= strAlignment %> <%= strClass %>></TD>
<%
					End If

				Else
%>
					<TD></TD>
<%
				End If

				strElementName = "stcName_0" & mlngIndex1
%>
				<TD WIDTH="181" NOWRAP><SPAN ID="<%= strElementName %>" STYLE="position:relative"><%= strArrShortStc(0, mlngIndex1) %></SPAN></TD>
<%
				strElementName = "stcName_1" & mlngIndex1
%>
				<TD WIDTH="181" NOWRAP><SPAN ID="<%= strElementName %>" STYLE="position:relative"><%= strArrShortStc(1, mlngIndex1) %></SPAN></TD>
			</TR>
<%
		Next
%>
	</TABLE>

	<BR>

	<A HREF="javascript:goStep1()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>

    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
	    <A HREF="javascript:submitForm('save')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存"></A>
    <%  end if  %>
	<BR><BR>
	
	<A HREF="javascript:submitForm('next')"><IMG SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="次へ"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
