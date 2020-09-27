<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		面接情報の登録(Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->

<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objAfterCare		'アフターケア用

Dim strMode				'処理モード
Dim strActMode			'動作モード
Dim strDisp				'表示モード
Dim strPerId			'個人ＩＤ
Dim strContactDate		'面接日
Dim strUserId			'ユーザＩＤ
Dim strRsvNo			'予約番号

'アフターケア情報
Dim strArrContactDate	'面接日
Dim strArrUserId		'ユーザＩＤ
Dim strArrRsvNo			'予約番号
Dim Ret					'関数戻り値

Dim strContactYear		'年度
Dim strURL				'URL文字列
Dim strHedderUrl		'ヘッダのURL
Dim strCareUrl			'管理項目のURL
Dim strDetail			'詳細のURL

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strMode        = Request("mode")
strActMode     = Request("actMode")
strDisp        = Request("disp")
strPerId       = Request("perId")
strContactDate = Request("contactDate")
strUserId      = Request("userId")
strRsvNo       = Request("rsvNo")

'処理モード指定時
If strMode <> "" Then

	'年度の算出
	strContactYear = Year(strContactDate) - IIf(Month(strContactDate) < 4, 1, 0)

	'ヘッダのURL編集
	strHedderUrl = "/webHains/contents/aftercare/AfterCareHedder.asp"
	strHedderUrl = strHedderUrl & "?mode="        & strMode
	strHedderUrl = strHedderUrl & "&disp="        & strDisp
	strHedderUrl = strHedderUrl & "&perId="       & strPerId
	strHedderUrl = strHedderUrl & "&contactDate=" & strContactDate
	strHedderUrl = strHedderUrl & "&contactYear=" & strContactYear
	strHedderUrl = strHedderUrl & "&userId="      & strUserId
	strHedderUrl = strHedderUrl & "&rsvNo="       & strRsvNo

	If strActMode <> "" Then
		strHedderUrl = strHedderUrl & "&actMode=" & strActMode
	End If

End If

Select Case strMode

	'新規時
	Case "NEW"

		'管理項目、詳細のURL編集
		strCareUrl = "/webHains/contents/aftercare/CareItem.asp"
		strCareUrl = strCareUrl & "?rsvNo=" & strRsvNo

		strDetail = "/webHains/contents/aftercare/AfterCareDetails.asp"

	'更新時
	Case "REP"

		'管理項目、詳細のURL編集
		strCareUrl = "/webHains/contents/aftercare/CareItem.asp"
		strCareUrl = strCareUrl & "?perId=" & strPerId
		strCareUrl = strCareUrl & "&contactDate=" & strContactDate 

		strDetail = "/webHains/contents/aftercare/AfterCareDetails.asp"
		strDetail = strDetail & "?perId="       & strPerId
		strDetail = strDetail & "&contactDate=" & strContactDate

	'処理モード未指定時
	Case Else

		'指定個人ＩＤ、面接日のアフターケア情報が存在するかをチェック
		strArrContactDate = strContactDate
		Set objAfterCare = Server.CreateObject("HainsAfterCare.AfterCare")
		Ret = objAfterCare.SelectAfterCare(strPerId, strArrContactDate, , strArrUserId, strArrRsvNo)

		'URLの編集
		strURL = Request.ServerVariables("SCRIPT_NAME")
		If Ret <= 0 Then
			strURL = strURL & "?mode="        & "NEW"
			strURL = strURL & "&disp="        & strDisp
			strURL = strURL & "&perId="       & strPerId
			strURL = strURL & "&contactDate=" & strContactDate
			strURL = strURL & "&userId="      & Session("USERID")
			strURL = strURL & "&rsvNo="       & strRsvNo
		Else
			strURL = strURL & "?mode="        & "REP"
			strURL = strURL & "&disp="        & IIf(strArrRsvNo(0) = "", "1", "0")
			strURL = strURL & "&perId="       & strPerId
			strURL = strURL & "&contactDate=" & strContactDate
			strURL = strURL & "&userId="      & strArrUserId(0)
			strURL = strURL & "&rsvNo="       & strArrRsvNo(0)
		End If

		Response.Redirect strURL
		Response.End

End Select
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Microsoft FrontPage 4.0">
<TITLE>面接情報の登録</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// submit処理
function submitForm( mode ) {

	var headerForm = header.document.entryForm;				// メイン画面のフォームエレメント
	var careForm   = CareItem.document.entryForm;			// 所見のフォームエレメント
	var detailForm = AfterCareDetails.document.entryForm;	// その他フォームエレメント
	var i, j;												// インデックス

	arrJudClassCd   = new Array();
	arrGuidanceDiv  = new Array();
	arrContactStcCd = new Array();
	arrSeq   		= new Array();

	// 動作モードを設定する
	headerForm.actMode.value = mode;

	//  削除の時は所見他の編集を行わない
	if ( mode != 'DEL' ) {

		// 所見のコード編集
		for ( i = 0; i < careForm.judClassCd.length; i++ ) {
			if ( careForm.judClassCd[ i ].checked == true ) {
				arrJudClassCd[ arrJudClassCd.length ]   = careForm.judClassCd[ i ].value;
			}
		}

		// 取得した各種コードを自エレメントに編集する
		// (これでカンマ付きで編集される)
		headerForm.judClassCd.value  = arrJudClassCd;

		// 指導内容区分,定型面接文書コードの編集
		for ( i = 0 , j = 0; i < detailForm.guidanceDiv.length; i++ ) {
			if ( detailForm.guidanceDiv[ i ].value != '' ) {
				arrGuidanceDiv[ arrGuidanceDiv.length ]   = detailForm.guidanceDiv[ i ].value;
				arrContactStcCd[ arrContactStcCd.length ] = detailForm.contactStcCd[ i ].value;
				arrSeq[ arrSeq.length ] = j;
				j++;
			}
		}

		// 取得した各種コードを自エレメントに編集する
		// (これでカンマ付きで編集される)
		headerForm.judClassCd.value  = arrJudClassCd;
		headerForm.guidanceDiv.value  = arrGuidanceDiv;
		headerForm.contactStcCd.value  = arrContactStcCd;
		headerForm.seq.value  = arrSeq;
		headerForm.judClassCdEtc.value  = careForm.judClassCdEtc.value

		headerForm.bloodPressure_h.value  = detailForm.bloodPressure_h.value
		headerForm.bloodPressure_l.value  = detailForm.bloodPressure_l.value
		headerForm.circumStances.value  = detailForm.circumStances.value
		headerForm.careComment.value  = detailForm.careComment.value

	}
	
	// メイン画面をsubmit
	headerForm.submit();
}
//-->
</SCRIPT>
</HEAD>
<FRAMESET ROWS="200,*" BORDER="1" FRAMESPACING="0" FRAMEBORDER="0">
	<FRAME SRC="<%= strHedderUrl %>" NAME="header" SCROLLING="auto">
	<FRAMESET COLS="170,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="NO">
		<FRAME SRC="<%= strCareUrl %>" NAME="CareItem"         SCROLLING="auto">
		<FRAME SRC="<%= strDetail %>"  NAME="AfterCareDetails" SCROLLING="auto">
	</FRAMESET>
</FRAMESET>
</HTML>
