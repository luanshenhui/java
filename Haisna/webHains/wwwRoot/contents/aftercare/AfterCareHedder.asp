<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		面接情報の登録(Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objCommon			'共通クラス
Dim objAfterCare		'アフターケア情報用
Dim objPerson			'個人情報用
Dim objFree				'汎用情報用
Dim objHainsUser		'ユーザー情報用

'-----------------------------------------------------------------------------
' 変数宣言
'-----------------------------------------------------------------------------
Const lngGuidanceDivCount	= 8		'指導内容表示数
Const strDoctorFlg 			= 1		'判定医検索用フラグ
Const lngCircumMaxCount		= 400	'面接状況最大文字数
Const lngCareComment		= 400	'総評最大文字数

Const MESSAGE_SAVE_OK 		= "保存が完了しました。"
Const MESSAGE_PERID_NG 		= "個人ＩＤが設定されていません。"
Const MESSAGE_CONTACTDATE_NG 		= "面接日が設定されていません。"
Const MESSAGE_SEQ_NG 		= "シーケンスＮＯが設定されていません。"
Const MESSAGE_DEL_NG 		= "削除処理に失敗しました。"

Dim strArrDisp
strArrDisp = Array("（事後管理指導）","（保健指導）")

Dim strMode				'処理モード
Dim strDisp				'表示モード
Dim strPerId			'個人ＩＤ
Dim strContactDate		'面接日
Dim strContactYear		'面接年度
Dim strUserId			'ユーザーＩＤ
Dim strRsvNo			'予約番号
Dim strActMode			'動作モード

'アフターケア用
Dim strBloodPressure_H 	'血圧（高）
Dim strBloodPressure_L	'血圧（低）
Dim strCircumStances	'面接状況
Dim strCareComment		'コメント（総評）
Dim strJudClassCdEtc	'判定分類その他文字列
Dim strJudClassCd 		'判定分類コード
Dim strSeq				'ＳＥＱＮＯ
Dim strGuidanceDiv		'指導内容区分
Dim strContactStcCd		'定型面接文書コード

'個人情報
'Dim strPerId			'個人ＩＤ
Dim strLastName			'姓
Dim strFirstName		'名
Dim strLastKName		'カナ姓
Dim strFirstKName		'カナ名
Dim strBirth			'生年月日
Dim strGender			'性別
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード2
Dim strOrgKName			'団体カナ名称
Dim strOrgName			'団体漢字名称
Dim strOrgSName			'団体略称
Dim strOrgBsdCd			'事業所コード
Dim strOrgBsdKName		'事業部カナ名称
Dim strOrgBsdName		'事業部名称
Dim strOrgRoomCd		'室部コード
Dim strOrgRoomName		'室部名称
Dim strOrgRoomKName		'室部カナ名称
Dim strOrgPostCd		'所属部署コード
Dim strOrgPostName		'所属名称
Dim strOrgPostKName		'所属カナ名称
Dim strJobName			'職名
Dim strEmpNo			'従業員番号

'判定医
Dim strDoctorCd			'医師コード
Dim strDoctorName		'医師名

Dim strDispPerName		'個人名称（漢字）
Dim strDispPerKName		'個人名称（カナ）
Dim strDispAge			'年齢（表示用）
Dim strDispBirth		'生年月日（表示用）
Dim strEditJudClassCd 	'編集用判定分類コード
Dim strEditGuidanceDiv 	'指導内容区分
Dim strEditContactStcCd '定型面接文章コード
Dim strEditSeq			'SEQ

Dim lngAfterCare		'アフターケア更新結果取得用
Dim strMessage			'エラーメッセージ
Dim strArrMessage		'エラーメッセージ（配列）
Dim strHTML				'HTML文字列
Dim strURL				'URL文字列
Dim i					'ループカウント

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon	 	= Server.CreateObject("HainsCommon.Common")
Set objAfterCare	= Server.CreateObject("HainsAfterCare.AfterCare")

strMode				= Request("mode")
strActMode          = Request("actMode")
strDisp				= Request("disp")
strPerId			= Request("perId")
strContactDate		= Request("contactDate")
strContactYear		= Request("contactYear")
strUserId			= Request("userId")
strRsvNo			= Request("rsvNo")
strJudClassCdEtc	= Trim(Request("judClassCdEtc"))
strBloodPressure_H  = Request("bloodPressure_h")
strBloodPressure_L	= Request("bloodPressure_l")
strCircumStances	= Request("circumStances")
strCareComment		= Request("careComment")
strJudClassCd		= Request("judClassCd")
strGuidanceDiv		= Request("guidanceDiv")
strContactStcCd		= Request("contactStcCd")
strJudClassCd		= IIf( strJudClassCd   = "", Empty, ConvIStringToArray(strJudClassCd)   )
strGuidanceDiv		= IIf( strGuidanceDiv  = "", Empty, ConvIStringToArray(strGuidanceDiv)  )
strContactStcCd		= IIf( strContactStcCd = "", Empty, ConvIStringToArray(strContactStcCd) )
strSeq				= IIf( strSeq          = "", Empty, ConvIStringToArray(strSeq)          )

If Not IsEmpty(strJudClassCd) Then
	strEditJudClassCd = Join(strJudClassCd, ",")
End If

If Not IsEmpty(strGuidanceDiv) Then
	strEditGuidanceDiv = Join(strGuidanceDiv, ",")
End If

If Not IsEmpty(strContactStcCd) Then
	strEditContactStcCd	= Join(strContactStcCd, ",")
End If

If Not IsEmpty(strSeq) Then
	strEditSeq = Join(strSeq, ",")
End If

Do

	Select Case strActMode

		'挿入・更新時
		Case "INS", "UPD"

			'データチェック

			'個人ＩＤ
			If( strPerId = "" ) Then
				objCommon.AppendArray strArrMessage, MESSAGE_PERID_NG
			End If
		
			'面接日
			If( strContactDate = "" ) Then
				objCommon.AppendArray strArrMessage, MESSAGE_CONTACTDATE_NG
			End If

			'血圧(高)
			Do
				If strBloodPressure_H = "" Then
					Exit Do
				End If
		
				'数値でなければエラー
				If Not IsNumeric(strBloodPressure_H) Then
					objCommon.AppendArray strArrMessage, "血圧(高)には数値を入力してください。"
					Exit Do
				End If
		
				'整数部が３桁を超えればエラー
				If Len(CStr(Int(Abs(CDbl(strBloodPressure_H))))) > 3 Then
					objCommon.AppendArray strArrMessage, "血圧(高)の桁数に誤りがあります。"
				End If
		
				Exit Do
			Loop

			'血圧(低)
			Do

				If strBloodPressure_L = "" Then
					Exit Do
				End If
		
				'数値でなければエラー
				If Not IsNumeric(strBloodPressure_L) Then
					objCommon.AppendArray strArrMessage, "血圧(低)には数値を入力してください。"
					Exit Do
				End If
		
				'整数部が３桁を超えればエラー
				If Len(CStr(Int(Abs(CDbl(strBloodPressure_L))))) > 3 Then
					objCommon.AppendArray strArrMessage, "血圧(低)の桁数に誤りがあります。"
				End If
		
				Exit Do
			Loop

			'その他判定分類
			objCommon.AppendArray strArrMessage, objCommon.CheckWideValue("その他入力欄", Trim(strJudClassCdEtc), 20)

			'面接状況
			strMessage = objCommon.CheckWideValue("面接状況", Trim(strCircumStances), lngCircumMaxCount)
			If strMessage <> "" Then
				objCommon.AppendArray strArrMessage, strMessage & "（改行文字を含みます）"
			End If

			'総評
			strMessage = objCommon.CheckWideValue("総評", Trim(strCareComment), lngCareComment)
			If strMessage <> "" Then
				objCommon.AppendArray strArrMessage, strMessage & "（改行文字を含みます）"
			End If

			'エラー時は処理を抜ける
			If Not IsEmpty(strArrMessage) Then
				Exit Do
			End If

			'アフターケア情報の登録
			lngAfterCare = objAfterCare.RegistAfterCare( _
											 strActMode, _
											 strPerId, _
											 strContactDate, _
											 strContactYear, _
											 strUserId, _
											 strRsvNo, _
											 strBloodPressure_H, _
											 strBloodPressure_L, _
											 strCircumStances, _
											 strCareComment, _
											 strJudClassCd, _
											 strGuidanceDiv, _
											 strContactStcCd, _
											 strJudClassCdEtc )

			'保存できない場合
			If lngAfterCare <> INSERT_NORMAL Then
				strArrMessage = Array("この面接日の面接情報がすでに存在します。")
				Exit Do
			End If

			'エラーがなければ呼び元(契約情報)画面をリロードして自身を閉じる
			strURL = "/webHains/contents/aftercare/AfterCareInterview.asp"
			strURL = strURL & "?mode="        & "REP"
			strURL = strURL & "&actMode="     & "saveend"
			strURL = strURL & "&disp="        & strDisp
			strURL = strURL & "&perId="       & strPerId
			strURL = strURL & "&contactDate=" & strContactDate
			strURL = strURL & "&userId="      & strUserId
			strURL = strURL & "&rsvNo="       & strRsvNo

			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( top.opener != null ) top.opener.location.reload(); top.location.replace('" & strURL & "');"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End

		'削除時
		Case "DEL"

			'アフターケア情報の削除
			lngAfterCare = objAfterCare.DeleteAfterData(strPerId, strContactDate)
			If lngAfterCare <> 1 Then
				strArrMessage = Array(MESSAGE_DEL_NG)
				Exit Do
			End If

			'エラーがなければ呼び元(契約情報)画面をリロードして自身を閉じる
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( top.opener != null ) top.opener.location.reload(); top.close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End

	End Select

	Exit Do
Loop

'個人情報の検索

'オブジェクトのインスタンス作成
Set objPerson = Server.CreateObject("HainsPerson.Person")

'個人情報読み込み
objPerson.SelectPerson strPerId,     strLastName,    strFirstName,    _
					   strLastKName, strFirstKName,  strBirth,        _
					   strGender,    strOrgCd1,      strOrgCd2,       _
					   strOrgKName,  strOrgName,     strOrgSName,     _
					   strOrgBsdCd,  strOrgBsdKName, strOrgBsdName,   _
					   strOrgRoomCd, strOrgRoomName, strOrgRoomKName, _
					   strOrgPostCd, strOrgPostName, strOrgPostKName, _
					   , strJobName, , , , , _
					   strEmpNo, Empty, Empty

'表示用名称の編集
strDispPerName 	= Trim(strLastName & "　" & strFirstName)
strDispPerKName = Trim(strLastKName & "　" & strFirstKName)

'年齢の算出
Set objFree = Server.CreateObject("HainsFree.Free")
strDispAge = objFree.CalcAge(strBirth, Date, "")
Set objFree = Nothing

'和暦編集
strDispBirth = objCommon.FormatString(strBirth, "gee.mm.dd")

'性別
strGender = IIf(strGender = CStr(GENDER_MALE), "男性", "女性")

'表示内容の編集
strDispBirth = strDispBirth & "生　" & strDispAge & "歳　" & strGender

'オブジェクトのインスタンスの開放
Set objPerson = Nothing

'判定医の検索
If strUserId <> "" Then

	Set objHainsUser = Server.CreateObject("HainsHainsUser.HainsUser")
	objHainsUser.SelectHainsUser strUserId, strDoctorName
	Set objHainsUser = Nothing

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>面接情報の登録</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
<!-- #include virtual = "/webHains/includes/docGuide.inc" -->
// 判定医師名ガイド呼び出し
function callDocGuide() {

	// ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
	docGuide_CalledFunction = setDocInfo;

	// 判定医師名ガイド表示
	showGuideDoc();
}

// 医師コード・医師名のセット
function setDocInfo() {

	var docNameElement;	// 医師名を編集するエレメントの名称
	var docName;		// 医師名を編集するエレメント自身

	// 予め退避したインデックス先のエレメントに、ガイド画面で設定された連絡域の値を編集
	document.entryForm.userId.value = docGuide_DoctorCd;
	document.entryForm.doctorName.value = docGuide_DoctorName;

	// ブラウザごとの団体名編集用エレメントの設定処理
	for ( ; ; ) {

		// エレメント名の編集
		docNameElement = 'docName';

		// IEの場合
		if ( document.all ) {
			document.all(docNameElement).innerHTML = docGuide_DoctorName;
			break;
		}

		// Netscape6の場合
		if ( document.getElementById ) {
			document.getElementById(docNameElement).innerHTML = docGuide_DoctorName;
		}

		break;
	}

	return false;
}

// 医師コード・医師名のクリア
function delDoctor() {

	document.entryForm.userId.value = '';
	document.entryForm.doctorName.value = '';

	// ブラウザごとの団体名編集用エレメントの設定処理
	for ( ; ; ) {

		// エレメント名の編集
		docNameElement = 'docName';

		// IEの場合
		if ( document.all ) {
			document.all(docNameElement).innerHTML = '';
			break;
		}

		// Netscape6の場合
		if ( document.getElementById ) {
			document.getElementById(docNameElement).innerHTML = '';
		}

		break;
	}

}

// 保存処理
function SaveAfterCare() {

	var objForm = document.entryForm	// 自画面のフォームエレメント

	if ( !checkData() ) {
		return;
	}

	if ( objForm.mode.value == 'NEW' ){
		top.submitForm('INS');
	} else {
		top.submitForm('UPD');
	}

}

// 削除
function DeleteAfterCare() {

	var objForm = document.entryForm	// 自画面のフォームエレメント

	if ( !confirm( 'この面接情報を削除します。よろしいですか？' ) ) {
		return;
	}

	top.submitForm('DEL');

}

function checkData(){

	var objHedder = document.entryForm							// Hedder画面のフォームエレメント
	var objDetail = parent.AfterCareDetails.document.entryForm	// Detail画面のフォームエレメント
	var lngGidCount = <%= lngGuidanceDivCount %>
	var circumMaxCount = <%= lngCircumMaxCount %>
	var careCommentMaxCount = <%= lngCareComment %>
	var i					//ループカウント

	//  指導内容および指導文書のデータチェック
	for( i = 0 ; i < lngGidCount ; i++ ){
		if (objDetail.guidanceDiv[ i ].value == '' && objDetail.contactStcCd[ i ].value != '') {
			alert('指導区分が設定されていない行が存在します。');
			return false;
		}
	}

	// 担当者のデータチェック
	if( objHedder.userId.value == '' ){
		alert('担当者が設定されていません。');
		return false;
	}

    // 面接状況文字数チェック
/*
	if( objDetail.circumStances.value.length > circumMaxCount ){
		alert('面接状況の文字数が多すぎます。');
		return false;
	}
*/
	// 総評文字数チェック
/*
	if( objDetail.careComment.value.length > careCommentMaxCount ){
		alert('総評の入力文字数が多すぎます。');
		return false;
	}
*/
	return true;

}

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="default.css">
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="mode"            VALUE="<%= strMode             %>">
	<INPUT TYPE="hidden" NAME="actMode"         VALUE="">
	<INPUT TYPE="hidden" NAME="disp"            VALUE="<%= strDisp             %>">
	<INPUT TYPE="hidden" NAME="perId"           VALUE="<%= strPerId            %>">
	<INPUT TYPE="hidden" NAME="contactDate"     VALUE="<%= strContactDate      %>">
	<INPUT TYPE="hidden" NAME="contactYear"     VALUE="<%= strContactYear      %>">
	<INPUT TYPE="hidden" NAME="userId"          VALUE="<%= strUserId           %>">
	<INPUT TYPE="hidden" NAME="rsvNo"           VALUE="<%= strRsvNo            %>">
	<INPUT TYPE="hidden" NAME="judClassCd"      VALUE="<%= strEditJudClassCd   %>">
	<INPUT TYPE="hidden" NAME="judClassCdEtc"   VALUE="<%= strJudClassCdEtc    %>">
	<INPUT TYPE="hidden" NAME="guidanceDiv"     VALUE="<%= strEditGuidanceDiv  %>">
	<INPUT TYPE="hidden" NAME="seq"             VALUE="<%= strEditSeq          %>">
	<INPUT TYPE="hidden" NAME="contactStcCd"    VALUE="<%= strEditContactStcCd %>">
	<INPUT TYPE="hidden" NAME="bloodPressure_h" VALUE="<%= strBloodPressure_H  %>">
	<INPUT TYPE="hidden" NAME="bloodPressure_l" VALUE="<%= strBloodPressure_L  %>">
	<INPUT TYPE="hidden" NAME="circumStances"   VALUE="<%= strCircumStances    %>">
	<INPUT TYPE="hidden" NAME="careComment"     VALUE="<%= strCareComment      %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN><FONT COLOR="#000000">面接情報の登録<%= strArrDisp(CLng("0" & strDisp)) %></FONT></B></TD>
		</TR>
	</TABLE>
<%
	'保存完了時は完了通知を行い、さもなくばエラーメッセージを編集する
	If strActMode = "saveend" Then
		Call EditMessage(MESSAGE_SAVE_OK, MESSAGETYPE_NORMAL)
	Else
		If Not IsEmpty(strArrMessage) Then
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If
	End If
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
		<TR>
			<TD NOWRAP><%= strEmpNo %></TD>
			<TD NOWRAP><B><%= strDispPerName %></B> (<FONT SIZE="-1"><%= strDispPerKName %></FONT>)</TD>
			<TD ROWSPAN="3" ALIGN="right" VALIGN="top" WIDTH="100%">
			<A HREF="JavaScript:top.close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="面接情報ウィンドウを閉じます"></A>&nbsp;
			<A HREF="JavaScript:SaveAfterCare()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="この面接情報を登録します"></A>&nbsp;
<%
			If strMode = "REP" Then
%>
				<A HREF="JavaScript:DeleteAfterCare()"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="この面接情報を削除します"></TD>
<%
			End If
%>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><%= strDispBirth %></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD ALIGN="right" NOWRAP>団体：</TD>
			<TD COLSPAN="2">
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD NOWRAP><%= strOrgName %></TD>
						<TD NOWRAP>&nbsp;&nbsp;所属：</TD>
						<TD NOWRAP><%= strOrgPostName %></TD>
						<TD NOWRAP>&nbsp;&nbsp;職種：</TD>
						<TD NOWRAP><%= strJobName %></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD NOWRAP>面接日</TD>
			<TD>：</TD>
			<TD NOWRAP><B><FONT COLOR="#ff6600"><%= strContactDate %></FONT></B></TD>
			<TD NOWRAP>&nbsp;担当者</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:callDocGuide()"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="担当者ガイドを表示しま示"></A></TD>
<!--
						<TD><A HREF="javascript:delDoctor()"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="担当者をクリア"></A></TD>
-->
						<TD><SPAN ID="docName" STYLE="position:relative"><%= Iif(strDoctorName = "", Server.HTMLEncode(Session("USERNAME")), strDoctorName) %></SPAN></TD>
						<INPUT TYPE="hidden" NAME="doctorName" VALUE="<%= Iif(strDoctorName = "", Server.HTMLEncode(Session("USERNAME")), strDoctorName) %>">
					</TR>
				</TABLE>
			</TD>
			</TD>
		</TR>
	</TABLE>

</FORM>
</BODY>
</HTML>

