<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   栄養指導  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const GRPCD_EIYOSHIDO = "X019"	'栄養計算結果グループコード

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objInterView		'面接情報アクセス用
Dim objConsult			'受診クラス
Dim objJudgement		'判定用

'パラメータ
Dim strAction			'処理状態
Dim	strWinMode			'ウィンドウモード
Dim strGrpNo			'グループNo
Dim lngRsvNo			'予約番号（今回分）
Dim strCsCd				'コースコード

'受診情報用変数
Dim strCslDate			'受診日
Dim strDayId			'当日ID

'検査結果
Dim vntItemCd			'検査項目コード
Dim vntSuffix			'サフィックス
Dim vntResultType		'結果タイプ
Dim vntItemType			'項目タイプ
Dim vntItemName			'検査項目名称
Dim vntResult			'検査結果
Dim lngRslCnt			'検査結果数

'栄養計算結果
Dim vntTargetTotalEnergy	'総エネルギー（目標量）
Dim vntTargetSweet			'菓子・飲料（目標量）
Dim vntTargetAlcohol		'アルコール（目標量）
Dim vntTargetProtein		'蛋白質（目標量）
Dim vntTargetFat			'脂質（目標量）
Dim vntTargetcarbohydrate	'炭水化物（目標量）
Dim vntTargetCalcium		'カルシウム（目標量）
Dim vntTargetIron			'鉄（目標量）
Dim vntTargetCholesterol	'コレステロール（目標量）
Dim vntTargetSalt			'塩分（目標量）
Dim vntTotalEnergy			'総エネルギー（摂取量）
Dim vntSweet				'菓子・飲料（摂取量）
Dim vntAlcohol				'アルコール（摂取量）
Dim vntProtein				'蛋白質（摂取量）
Dim vntFat					'脂質（摂取量）
Dim vntCarbohydrate			'炭水化物（摂取量）
Dim vntCalcium				'カルシウム（摂取量）
Dim vntIron					'鉄（摂取量）
Dim vntCholesterol			'コレステロール（摂取量）
Dim vntSalt					'塩分（摂取量）
Dim vntRateTotalEnergy		'総エネルギー（充足率）
Dim vntRateSweet			'菓子・飲料（充足率）
Dim vntRateAlcohol			'アルコール（充足率）
Dim vntRateProtein			'蛋白質（充足率）
Dim vntRateFat				'脂質（充足率）
Dim vntRateCarbohydrate		'炭水化物（充足率）
Dim vntRateCalcium			'カルシウム（充足率）
Dim vntRateIron				'鉄（充足率）
Dim vntRateCholesterol		'コレステロール（充足率）
Dim vntRateSalt				'塩分（充足率）
Dim vntMorningCereals		'穀類および芋類（朝）
Dim vntMorningFruit			'果物（朝）
Dim vntMorningMeat			'魚介・肉・卵・大豆製品（朝）
Dim vntMorningDairy			'乳製品（朝）
Dim vntMorningOils			'油脂・多脂性食品（朝）
Dim vntMorningVegetable		'野菜（朝）
Dim vntMorningFavorite		'嗜好品（朝）
Dim vntMorningOthers		'その他（朝）
Dim vntLunchCereals			'穀類および芋類（昼）
Dim vntLunchFruit			'果物（昼）
Dim vntLunchMeat			'魚介・肉・卵・大豆製品（昼）
Dim vntLunchDairy			'乳製品（朝）
Dim vntLunchOils			'油脂・多脂性食品（昼）
Dim vntLunchVegetable		'野菜（昼）
Dim vntLunchFavorite		'嗜好品（昼）
Dim vntLunchOthers			'その他（昼）
Dim vntDinnerCereals		'穀類および芋類（夕）
Dim vntDinnerFruit			'果物（夕）
Dim vntDinnerMeat			'魚介・肉・卵・大豆製品（夕）
Dim vntDinnerDairy			'乳製品（朝）
Dim vntDinnerOils			'油脂・多脂性食品（夕）
Dim vntDinnerVegetable		'野菜（夕）
Dim vntDinnerFavorite		'嗜好品（夕）
Dim vntDinnerOthers			'その他（夕）

Dim dblRate(5,2)			'充足率(食品摂取状況)
Dim dblNyuRate				'充足率(乳製品)
Dim dblFavorite(2)			'嗜好品
Dim dblRateP				'充足率(タンパク質)
Dim dblRateC				'充足率(炭水化物)
Dim dblRateF				'充足率(脂質)

'栄養再計算用
Dim vntCalcFlg()		'計算対象フラグ
Dim vntArrDayId()		'当日ＩＤ（複数指定の場合の計算処理への引数）
Dim strArrMessage		'エラーメッセージ

Dim strUpdUser			'更新者
Dim strIPAddress		'IPアドレス

Dim i, j				'インデックス
Dim Ret					'復帰値

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'引数値の取得
strAction			= Request("act")
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")

Do	
	'受診情報検索
	Set objConsult = Server.CreateObject("HainsConsult.Consult")
	Ret = objConsult.SelectConsult(lngRsvNo, _
									, _
									strCslDate, _
									, , , , , , , , , , , , , , , , , , , , , _
									strDayId _
									)
	'受診情報が存在しない場合はエラーとする
	If Ret = False Then
		Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
	End If

	'栄養再計算
	If strAction = "calc" Then
		'更新者の設定
		strUpdUser = Session("USERID")
		'IPアドレスの取得
		strIPAddress = Request.ServerVariables("REMOTE_ADDR")

        '### 2008.04.01 張 特定健診階層化判定追加によって修正 ###
        'Redim Preserve vntCalcFlg(5)

        '### 2012.10.06 張 食習慣の自動判定修正 Start ###
        'Redim Preserve vntCalcFlg(6)
        Redim Preserve vntCalcFlg(7)
        '### 2012.10.06 張 食習慣の自動判定修正 End   ###

        vntCalcFlg(0) = 0
		vntCalcFlg(1) = 0
		vntCalcFlg(2) = 1	'栄養計算のみ起動
		vntCalcFlg(3) = 0
		vntCalcFlg(4) = 0
		vntCalcFlg(5) = 0
		vntCalcFlg(6) = 0
'## 2012.10.06 Add by ishihara@RD 食習慣の自動判定
		vntCalcFlg(7) = 0
'## 2012.10.06 Add End

		Redim Preserve vntArrDayId(0)

		'判定メイン呼び出し
		Set objJudgement = Server.CreateObject("HainsJudgement.JudgementControl")
		Ret = objJudgement.JudgeAutomaticallyMain (strUpdUser, _
												strIPAddress, _
												strCslDate, _
												 vntCalcFlg, _
												1, _
												strDayId, _
												strDayId, _
												vntArrDayId, _
												"", _
												"", _
												0, _
												0)

		If Ret = True Then
			strAction = "calcend"
		Else
			objCommon.AppendArray strArrMessage, "自動判定が異常終了しました。（詳細は？）"
		End If
	End If

	'栄養計算結果取得
	lngRslCnt = objInterView.SelectHistoryRslList( _
						lngRsvNo, _
						1, _
						GRPCD_EIYOSHIDO, _
						0, _
						"", _
						0, _
						0, _
						0, _
						, _
						, _
						, _
						, _
						vntItemCd, _
						vntSuffix, _
						vntResultType, _
						vntItemType, _
						vntItemName, _
						vntResult _
						)
	If lngRslCnt < 0 Then
		Err.Raise 1000, , "栄養計算結果が取得できません。（予約番号 = " & lngRsvNo & ")"
	End If

	'栄養計算結果のセット
	For i=0 To lngRslCnt-1

		Select Case (vntItemCd(i) & "-" & vntSuffix(i))
		Case "60011-00"	'総エネルギー（目標量）
			vntTargetTotalEnergy = vntResult(i)
		Case "60012-00"	'菓子・飲料（目標量）
			vntTargetSweet = vntResult(i)
		Case "60013-00"	'アルコール（目標量）
			vntTargetAlcohol = vntResult(i)
		Case "60014-00"	'蛋白質（目標量）
			vntTargetProtein = vntResult(i)
		Case "60015-00"	'脂質（目標量）
			vntTargetFat = vntResult(i)
		Case "60016-00"	'炭水化物（目標量）
			vntTargetcarbohydrate = vntResult(i)
		Case "60017-00"	'カルシウム（目標量）
			vntTargetCalcium = vntResult(i)
		Case "60018-00"	'鉄（目標量）
			vntTargetIron = vntResult(i)
		Case "60019-00"	'コレステロール（目標量）
			vntTargetCholesterol = vntResult(i)
		Case "60020-00"	'塩分（目標量）
			vntTargetSalt = vntResult(i)

		Case "60510-01"	'総エネルギー（摂取量）
			vntTotalEnergy = vntResult(i)
		Case "XXXXX-XX"	'菓子・飲料（摂取量）
			'嗜好品（昼）と同じ
		Case "XXXXX-XX"	'アルコール（摂取量）
			'嗜好品（夕）と同じ
		Case "60511-01"	'蛋白質（摂取量）
			vntProtein = vntResult(i)
		Case "60512-01"	'脂質（摂取量）
			vntFat = vntResult(i)
		Case "60513-01"	'炭水化物（摂取量）
			vntCarbohydrate = vntResult(i)
		Case "60514-01"	'カルシウム（摂取量）
			vntCalcium = vntResult(i)
		Case "60515-01"	'鉄（摂取量）
			vntIron = vntResult(i)
		Case "60516-01"	'コレステロール（摂取量）
			vntCholesterol = vntResult(i)
		Case "60517-01"	'塩分（摂取量）
			vntSalt = vntResult(i)

		Case "60561-00"	'総エネルギー（充足率）
			vntRateTotalEnergy = vntResult(i)
		Case "60562-00"	'菓子・飲料（充足率）
			vntRateSweet = vntResult(i)
		Case "60563-00"	'アルコール（充足率）
			vntRateAlcohol = vntResult(i)
		Case "60564-00"	'蛋白質（充足率）
			vntRateProtein = vntResult(i)
		Case "60565-00"	'脂質（充足率）
			vntRateFat = vntResult(i)
		Case "60566-00"	'炭水化物（充足率）
			vntRateCarbohydrate = vntResult(i)
		Case "60567-00"	'カルシウム（充足率）
			vntRateCalcium = vntResult(i)
		Case "60568-00"	'鉄（充足率）
			vntRateIron = vntResult(i)
		Case "60569-00"	'コレステロール（充足率）
			vntRateCholesterol = vntResult(i)
		Case "60570-00"	'塩分（充足率）
			vntRateSalt = vntResult(i)

		Case "60501-01"	'穀類および芋類（朝）
			vntMorningCereals = vntResult(i)
		Case "60502-01"	'果物（朝）
			vntMorningFruit = vntResult(i)
		Case "60503-01"	'魚介・肉・卵・大豆製品（朝）
			vntMorningMeat = vntResult(i)
		Case "60504-01"	'乳製品（朝）
			vntMorningDairy = vntResult(i)
		Case "60505-01"	'油脂・多脂性食品（朝）
			vntMorningOils = vntResult(i)
		Case "60506-01"	'野菜（朝）
			vntMorningVegetable = vntResult(i)
		Case "60507-01"	'嗜好品（朝）
			vntMorningFavorite = vntResult(i)

		Case "60501-02"	'穀類および芋類（昼）
			vntLunchCereals = vntResult(i)
		Case "60502-02"	'果物（昼）
			vntLunchFruit = vntResult(i)
		Case "60503-02"	'魚介・肉・卵・大豆製品（昼）
			vntLunchMeat = vntResult(i)
		Case "60504-02"	'乳製品（昼）
			vntLunchDairy = vntResult(i)
		Case "60505-02"	'油脂・多脂性食品（昼）
			vntLunchOils = vntResult(i)
		Case "60506-02"	'野菜（昼）
			vntLunchVegetable = vntResult(i)
		Case "60507-02"	'嗜好品（昼）
			vntLunchFavorite = vntResult(i)
			vntSweet = vntResult(i)

		Case "60501-03"	'穀類および芋類（夕）
			vntDinnerCereals = vntResult(i)
		Case "60502-03"	'果物（夕）
			vntDinnerFruit = vntResult(i)
		Case "60503-03"	'魚介・肉・卵・大豆製品（夕）
			vntDinnerMeat = vntResult(i)
		Case "60504-03"	'乳製品（夕）
			vntDinnerDairy = vntResult(i)
		Case "60505-03"	'油脂・多脂性食品（夕）
			vntDinnerOils = vntResult(i)
		Case "60506-03"	'野菜（夕）
			vntDinnerVegetable = vntResult(i)
		Case "60507-03"	'嗜好品（夕）
			vntDinnerFavorite = vntResult(i)
			vntAlcohol = vntResult(i)
		End Select
	Next

	'充足率の編集
	For i = 0 To UBound(dblRate,1)
		For j = 0 To UBound(dblRate,2)
			dblRate(i, j) = "0.0"
		Next
	Next
	If vntMorningCereals <> "" Then
		dblRate(0, 0) = IIf(IsNumeric(vntMorningCereals),   objCommon.FormatString(CDbl(vntMorningCereals), "0.0"),   "0.0")
	End If
	If vntLunchCereals <> "" Then
		dblRate(0, 1) = IIf(IsNumeric(vntLunchCereals),     objCommon.FormatString(CDbl(vntLunchCereals), "0.0"),     "0.0")
	End If
	If vntDinnerCereals <> "" Then
		dblRate(0, 2) = IIf(IsNumeric(vntDinnerCereals),    objCommon.FormatString(CDbl(vntDinnerCereals), "0.0"),    "0.0")
	End If
	If vntMorningFruit <> "" Then
		dblRate(1, 0) = IIf(IsNumeric(vntMorningFruit),     objCommon.FormatString(CDbl(vntMorningFruit), "0.0"),     "0.0")
	End If
	If vntLunchFruit <> "" Then
		dblRate(1, 1) = IIf(IsNumeric(vntLunchFruit),       objCommon.FormatString(CDbl(vntLunchFruit), "0.0"),       "0.0")
	End If
	If vntDinnerFruit <> "" Then
		dblRate(1, 2) = IIf(IsNumeric(vntDinnerFruit),      objCommon.FormatString(CDbl(vntDinnerFruit), "0.0"),      "0.0")
	End If
	If vntMorningMeat <> "" Then
		dblRate(2, 0) = IIf(IsNumeric(vntMorningMeat),      objCommon.FormatString(CDbl(vntMorningMeat), "0.0"),      "0.0")
	End If
	If vntLunchMeat <> "" Then
		dblRate(2, 1) = IIf(IsNumeric(vntLunchMeat),        objCommon.FormatString(CDbl(vntLunchMeat), "0.0"),        "0.0")
	End If
	If vntDinnerMeat <> "" Then
		dblRate(2, 2) = IIf(IsNumeric(vntDinnerMeat),       objCommon.FormatString(CDbl(vntDinnerMeat), "0.0"),       "0.0")
	End If
	If vntMorningDairy <> "" Then
		dblRate(3, 0) = IIf(IsNumeric(vntMorningDairy),     objCommon.FormatString(CDbl(vntMorningDairy), "0.0"),     "0.0")
	End If
	If vntLunchDairy <> "" Then
		dblRate(3, 1) = IIf(IsNumeric(vntLunchDairy),       objCommon.FormatString(CDbl(vntLunchDairy), "0.0"),       "0.0")
	End If
	If vntDinnerDairy <> "" Then
		dblRate(3, 2) = IIf(IsNumeric(vntDinnerDairy),      objCommon.FormatString(CDbl(vntDinnerDairy), "0.0"),      "0.0")
	End If
	If vntMorningOils <> "" Then
		dblRate(4, 0) = IIf(IsNumeric(vntMorningOils),      objCommon.FormatString(CDbl(vntMorningOils), "0.0"),      "0.0")
	End If
	If vntLunchOils <> "" Then
		dblRate(4, 1) = IIf(IsNumeric(vntLunchOils),        objCommon.FormatString(CDbl(vntLunchOils), "0.0"),        "0.0")
	End If
	If vntDinnerOils <> "" Then
		dblRate(4, 2) = IIf(IsNumeric(vntDinnerOils),       objCommon.FormatString(CDbl(vntDinnerOils), "0.0"),       "0.0")
	End If
	If vntMorningVegetable <> "" Then
		dblRate(5, 0) = IIf(IsNumeric(vntMorningVegetable), objCommon.FormatString(CDbl(vntMorningVegetable), "0.0"), "0.0")
	End If
	If vntLunchVegetable <> "" Then
		dblRate(5, 1) = IIf(IsNumeric(vntLunchVegetable),   objCommon.FormatString(CDbl(vntLunchVegetable), "0.0"),   "0.0")
	End If
	If vntDinnerVegetable <> "" Then
		dblRate(5, 2) = IIf(IsNumeric(vntDinnerVegetable),  objCommon.FormatString(CDbl(vntDinnerVegetable), "0.0"),  "0.0")
	End If
	For i=0 To 2
		dblNyuRate = objCommon.FormatString(CDbl(dblNyuRate) + CDbl(dblRate(3, i)), "0.0")
	Next

	dblRateP="0.0"
	dblRateC="0.0"
	dblRateF="0.0"
	If vntRateProtein <> "" Then
		dblRateP = IIf(IsNumeric(vntRateProtein),      objCommon.FormatString(CDbl(vntRateProtein), "0.0"),      "0.0")
	End If
	If vntRateCarbohydrate <> "" Then
		dblRateC = IIf(IsNumeric(vntRateCarbohydrate), objCommon.FormatString(CDbl(vntRateCarbohydrate), "0.0"), "0.0")
	End If
	If vntRateFat <> "" Then
		dblRateF = IIf(IsNumeric(vntRateFat),          objCommon.FormatString(CDbl(vntRateFat), "0.0"),          "0.0")
	End If

	'嗜好品
	For i=0 To UBound(dblFavorite)
		dblFavorite(i) = "0"
	Next
	If vntMorningFavorite <> "" Then
		dblFavorite(0) = IIf(IsNumeric(vntMorningFavorite), objCommon.FormatString(vntMorningFavorite, "0"), 0)
	End If
	If vntLunchFavorite <> "" Then
		dblFavorite(1) = IIf(IsNumeric(vntLunchFavorite),   objCommon.FormatString(vntLunchFavorite,   "0"), 0)
	End If
	If vntDinnerFavorite <> "" Then
		dblFavorite(2) = IIf(IsNumeric(vntDinnerFavorite),  objCommon.FormatString(vntDinnerFavorite,  "0"), 0)
	End If


	'オブジェクトのインスタンス削除
	Set objInterview = Nothing
	Set objConsult = Nothing
	Set objJudgement = Nothing
Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="x-ua-compatible" content="IE=10">
<TITLE>栄養指導</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
//食習慣問診画面呼び出し
function callShokusyukan() {
	var url;							// URL文字列

	url = '/WebHains/contents/interview/Shokusyukan.asp';
	url = url + '?winmode=' + '<%= strWinMode %>';
	url = url + '&grpno=' + '<%= strGrpNo %>';
	url = url + '&rsvno=' + '<%= lngRsvNo %>';
	url = url + '&cscd=' + '<%= strCsCd %>';

	location.href(url);

}

var winMenFoodComment;			// ウィンドウハンドル

//食習慣、問診コメント入力画面呼び出し
function callMenFoodComment() {
	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか

	var i;


	// ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
//	CalledFunction = functionName;

	// すでにガイドが開かれているかチェック
	if ( winMenFoodComment != null ) {
		if ( !winMenFoodComment.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/interview/MenFoodComment.asp';
	url = url + '?winmode=' + '<%= strWinMode %>';
	url = url + '&grpno=' + '<%= strGrpNo %>';
	url = url + '&rsvno=' + '<%= lngRsvNo %>';
	url = url + '&cscd=' + '<%= strCsCd %>';

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winMenFoodComment.focus();
		winMenFoodComment.location.replace( url );
	} else {
		winMenFoodComment = window.open( url, '', 'width=750,height=350,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

}
// 食習慣、問診コメント入力画面を閉じる
function closeMenFoodComment() {

	if ( winMenFoodComment != null ) {
		if ( !winMenFoodComment.closed ) {
			winMenFoodComment.close();
		}
	}

	winMenFoodComment = null;
}

//栄養再計算画面呼び出し
function callMenEiyokeisan() {

	// 確認メッセージ
	if( !confirm('栄養計算をします。よろしいですか？') ) return;

	document.entryForm.act.value = "calc";
	document.entryForm.submit();

}
//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeMenFoodComment()">
<%
	'「別ウィンドウで表示」の場合、ヘッダー部分表示
	If strWinMode = "1" Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
		Call interviewHeader(lngRsvNo, 0)
	End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="act"       VALUE="<%= strAction %>">
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="RslCnt"    VALUE="<%= lngRslCnt %>">

	<!-- タイトルの表示 -->
	<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
		<TR>
			<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">栄養指導</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="5" WIDTH="1"></TD>
		</TR>
		<TR>
			<TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><A HREF="JavaScript:callShokusyukan()">食習慣問診</A></TD>
			<TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><A HREF="JavaScript:callMenFoodComment()">食習慣、問診コメント入力</A></TD>
<%
	'運用開始前（移行データ）については再計算不可とする
	If objCommon.FormatString(strCslDate, "yyyy/mm/dd") > "2004/01/04" Then
%>
			<TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><A HREF="JavaScript:callMenEiyokeisan()">栄養再計算</A></TD>
<%
	End If
%>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	If strAction <> "" Then

		Select Case strAction

			'保存完了時は「正常終了」の通知
			Case "calcend"
				Call EditMessage("計算が正常終了しました。", MESSAGETYPE_NORMAL)

			'さもなくばエラーメッセージを編集
			Case Else
				Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

		End Select

	End If
%>
	<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD ROWSPAN="2" VALIGN="top">
				<OBJECT ID="HainsChartBar" CLASSID="CLSID:C785ABB0-B256-4EC1-8B6F-CD7F4D923F08" CODEBASE="/webHains/cab/Graph/HainsChartBar.CAB#version=1,0,0,1"></OBJECT>
<script type="text/javascript">
<!--
	var GraphActiveX = document.getElementById('HainsChartBar');
<%
For i=0 To UBound(dblRate, 1)
	For j=0 To UBound(dblRate, 2)
%>
		GraphActiveX.SetRate(<%= i %>, <%= j %>, <%= dblRate(i, j) %>);
<%
	Next
Next
%>
		GraphActiveX.SetNyuRate(<%= dblNyuRate %>);
		GraphActiveX.ShowGraph();
//-->
</script>
				<BR>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" WIDTH="100%" BGCOLOR="#ffffff" STYLE="font-size: 13px;">
					<TR>
						<TD></TD>
						<TD NOWRAP WIDTH="100">⑦嗜好食品</TD>
						<TD NOWRAP>菓子・飲料：</TD>
						<TD NOWRAP>　<B><%= dblFavorite(1) %>kcal</B></TD>
						<TD NOWRAP><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="50"></TD>
						<TD NOWRAP>アルコール：</TD>
						<TD NOWRAP>　<B><%= dblFavorite(2) %>kcal</B></TD>
						<TD WIDTH="100%"></TD>
					</TR>
				</TABLE>
			</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" ALIGN="left">
					<TR BGCOLOR="#cccccc">
						<TD NOWRAP WIDTH="100%">&nbsp;</TD>
						<TD NOWRAP>目標量</TD>
						<TD NOWRAP>摂取量</TD>
						<TD NOWRAP>充足率(％)</TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>総エネルギー（kcal）</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetTotalEnergy="", "&nbsp;", objCommon.FormatString(vntTargetTotalEnergy, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTotalEnergy="", "&nbsp;", objCommon.FormatString(vntTotalEnergy, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateTotalEnergy="", "&nbsp;", objCommon.FormatString(vntRateTotalEnergy, "0.0")) %></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>菓子・飲料（kcal）</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetSweet="", "&nbsp;", objCommon.FormatString(vntTargetSweet, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntSweet="", "&nbsp;", objCommon.FormatString(vntSweet, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateSweet="", "&nbsp;", objCommon.FormatString(vntRateSweet, "0.0")) %></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>アルコール（kcal）</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetAlcohol="", "&nbsp;", objCommon.FormatString(vntTargetAlcohol, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntAlcohol="", "&nbsp;", objCommon.FormatString(vntAlcohol, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateAlcohol="", "&nbsp;", objCommon.FormatString(vntRateAlcohol, "0.0")) %></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>タンパク質（g）</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetProtein="", "&nbsp;", objCommon.FormatString(vntTargetProtein, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntProtein="", "&nbsp;", objCommon.FormatString(vntProtein, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateProtein="", "&nbsp;", objCommon.FormatString(vntRateProtein, "0.0")) %></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>脂質（g）</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetFat="", "&nbsp;", objCommon.FormatString(vntTargetFat, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntFat="", "&nbsp;", objCommon.FormatString(vntFat, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateFat="", "&nbsp;", objCommon.FormatString(vntRateFat, "0.0")) %></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>炭水化物（g）</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetCarbohydrate="", "&nbsp;", objCommon.FormatString(vntTargetCarbohydrate, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntCarbohydrate="", "&nbsp;", objCommon.FormatString(vntCarbohydrate, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateCarbohydrate="", "&nbsp;", objCommon.FormatString(vntRateCarbohydrate, "0.0")) %></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>カルシウム（mg）</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetCalcium="", "&nbsp;", objCommon.FormatString(vntTargetCalcium, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntCalcium="", "&nbsp;", objCommon.FormatString(vntCalcium, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateCalcium="", "&nbsp;", objCommon.FormatString(vntRateCalcium, "0.0")) %></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>鉄（mg）</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetIron="", "&nbsp;", objCommon.FormatString(vntTargetIron, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntIron="", "&nbsp;", objCommon.FormatString(vntIron, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateIron="", "&nbsp;", objCommon.FormatString(vntRateIron, "0.0")) %></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>コレステロール（mg）</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetCholesterol="", "&nbsp;", objCommon.FormatString(vntTargetCholesterol, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntCholesterol="", "&nbsp;", objCommon.FormatString(vntCholesterol, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateCholesterol="", "&nbsp;", objCommon.FormatString(vntRateCholesterol, "0.0")) %></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>塩分（g）</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetSalt="", "&nbsp;", objCommon.FormatString(vntTargetSalt, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntSalt="", "&nbsp;", objCommon.FormatString(vntSalt, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateSalt="", "&nbsp;", objCommon.FormatString(vntRateSalt, "0.0")) %></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>
				<OBJECT ID="HainsChartEnergy" CLASSID="CLSID:70E5B4BA-2BEE-4ADB-8041-DB39CA74DE59" CODEBASE="/webHains/cab/Graph/HainsChartEnergy.CAB#version=1,0,0,1"></OBJECT>
<script type="text/javascript">
<!--
	var GraphActiveX = document.getElementById('HainsChartEnergy');
	GraphActiveX.SetRateP(<%= dblRateP %>);	// 充足率(タンパク質)
	GraphActiveX.SetRateC(<%= dblRateC %>);	// 充足率(炭水化物)
	GraphActiveX.SetRateF(<%= dblRateF %>);	// 充足率(脂質)
	GraphActiveX.ShowGraph();
//-->
</script>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
