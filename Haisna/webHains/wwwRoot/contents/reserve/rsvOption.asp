<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		予約情報詳細(オプション検査情報) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const SETCLASS_REPEATER = "023"	'セット分類(リピータ割引)

'データベースアクセス用オブジェクト
Dim objContract				'契約情報アクセス用
Dim objFree					'汎用情報アクセス用
Dim objSchedule				'スケジュール情報アクセス用

'引数値(共通)
Dim strRsvNo				'予約番号
Dim lngCancelFlg			'キャンセルフラグ
Dim strPerId				'個人ＩＤ
Dim strGender				'性別
Dim strBirth				'生年月日
Dim strOrgCd1				'団体コード１
Dim strOrgCd2				'団体コード２
Dim strCsCd					'コースコード
Dim strCslDate				'受診日
Dim strCslDivCd				'受診区分コード
Dim strRsvGrpCd				'予約群コード
Dim strCtrPtCd				'(読み込み直後の)契約パターンコード
Dim strOptCd				'(読み込み直後の)オプションコード
Dim strOptBranchNo			'(読み込み直後の)オプション枝番
'12.16
Dim strNowCtrPtCd			'(本ASP呼び出し直前の)契約パターンコード
Dim strNowOptCd				'(本ASP呼び出し直前の)オプションコード
Dim strNowOptBranchNo		'(本ASP呼び出し直前の)オプション枝番
'12.16
Dim strChanged				'基本情報(団体・コース・受診区分)が初期から変更されているか
Dim strShowAll				'"1":すべての検査を表示
Dim strInit					'初期読み込みか
Dim strReadNoRep			'指定時はリピータ情報を読まない
'## 2004.10.27 Add By T.Takagi@FSIT 日付変更時はセット比較画面を自動表示
Dim blnDateChanged			'日付が変更されて呼ばれたか
'## 2004.10.27 Add End

'契約情報
Dim strNewCtrPtCd			'契約パターンコード
Dim strAgeCalc				'年齢起算日
Dim strRefOrgCd1			'参照先団体コード１
Dim strRefOrgCd2			'参照先団体コード２
Dim strCsName				'コース名

'オプション検査情報
Dim strArrOptCd				'オプションコード
Dim strArrOptBranchNo		'オプション枝番
Dim strOptName				'オプション名
Dim strSetColor				'セットカラー
Dim strSetClassCd			'セット分類コード
Dim strConsult				'受診要否
Dim strBranchCount			'オプション枝番数
Dim strAddCondition			'追加条件
Dim strHideRsv				'予約画面非表示
Dim strPrice				'総金額
Dim strPerPrice				'個人負担金額
'## 2004.01.04 Add By T.Takagi@FSIT 負担情報有無の取得
Dim strExistsPrice			'負担情報の有無
'## 2004.01.04 Add End
Dim lngCount				'オプション検査数

'非表示オプション情報
Dim strHideElementName()	'エレメント名
Dim strHideOptCd()			'オプションコード
Dim strHideOptBranchNo()	'オプション枝番
Dim strHideConsult()		'受診要否
Dim lngHideCount			'オプション数

'契約情報
Dim strArrCsCd				'コースコード
Dim strArrCsName			'コース名
Dim strArrCtrPtCd			'契約パターンコード
Dim lngCtrCount				'契約情報数

'受診区分情報
Dim strArrCslDivCd			'受診区分コード
Dim strArrCslDivName		'受診区分名
Dim lngCslDivCount			'受診区分数

'予約群情報
Dim strArrRsvGrpCd			'予約群コード
Dim strArrRsvGrpName		'予約群名称
Dim lngRsvGrpCount			'予約群数

Dim strAge					'受診時年齢
Dim strRealAge				'実年齢

Dim blnConsult				'受診チェックの要否
Dim strChecked				'チェックボックスのチェック状態

Dim strPrevOptCd			'直前レコードのオプションコード
Dim lngOptGrpSeq			'オプショングループのSEQ値
Dim strElementType			'オプション選択用のエレメント種別
Dim strElementName			'オプション選択用のエレメント名

Dim blnExist				'存在フラグ
Dim strMessage				'メッセージ
Dim strURL					'ジャンプ先のURL
Dim Ret						'関数戻り値
Dim i, j					'インデックス

Dim blnHasRepeaterSet		'契約におけるリピータ割引セットの有無
Dim blnRepeaterConsult		'リピータ割引セットの受診有無

'12.16
Dim strWkOptCd				'(チェックすべき)オプションコード
Dim strWkOptBranchNo		'(チェックすべき)オプション枝番
'12.16

Dim lngMode					'セット継承モード(0:デフォルト状態に依存、1:引数指定されたセットを全て継承、2:引数指定セットのうち任意受診のみ継承)

'## 2004.10.27 Add By T.Takagi@FSIT 日付変更時はセット比較画面を自動表示
Dim blnCompare				'セット比較画面表示可否
'## 2004.10.27 Add End


'## 2006.06.15 Add by 李
Const SETCLASS_GF	= "003"				'１日ドック（胃内視鏡）
Const KOJIN_DANTAI	= "XXXXXXXXXX"		'個人受診者
Const CSCD_1		= "100"				'コースコード（1日ドック）
Dim strHideSetClassCd()
Dim strSetClassName
Dim blnGF
Dim blnRepeater
'## 2006.06.15 Add End

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objContract = Server.CreateObject("HainsContract.Contract")

'予約基本情報から送信されるパラメータ値の取得
strRsvNo       = Request("rsvNo")
lngCancelFlg   = CLng("0" & Request("cancelFlg"))
strPerId       = Request("perId")
strGender      = Request("gender")
strBirth       = Request("birth")
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
strCsCd        = Request("csCd")
strCslDate     = Request("cslDate")
strCslDivCd    = Request("cslDivCd")
strRsvGrpCd    = Request("rsvGrpCd")
strCtrPtCd     = Request("ctrPtCd")
strOptCd       = ConvIStringToArray(Request("optCd"))
strOptBranchNo = ConvIStringToArray(Request("optBNo"))
'12.16
strNowCtrPtCd     = Request("nowCtrPtCd")
strNowOptCd       = ConvIStringToArray(Request("nowOptCd"))
strNowOptBranchNo = ConvIStringToArray(Request("notOptBNo"))
'12.16
strChanged     = Request("changed")
strShowAll     = Request("showAll")
strInit        = Request("init")
strReadNoRep   = Request("readNoRep")
'## 2004.10.27 Add By T.Takagi@FSIT 日付変更時はセット比較画面を自動表示
blnDateChanged = (Request("dateChanged") <> "")
'## 2004.10.27 Add End

Do

	'日付が正しくない場合は何もしない
	If strCslDate = "" Or Not IsDate(strCslDate) Then
		Exit Do
	End If

	'実年齢計算
	If strBirth <> "" And IsDate(strBirth) Then

		Set objFree = Server.CreateObject("HainsFree.Free")
		strRealAge = objFree.CalcAge(strBirth, strCslDate)
		Set objFree = Nothing

		'小数点以下の切り捨て
		If IsNumeric(strRealAge) Then
			strRealAge = CStr(Int(strRealAge))
		End If

	End If

	'団体が存在しない場合は何もしない
	If strOrgCd1 = "" Or strOrgCd2 = "" Then
		Exit Do
	End If

	'指定団体における受診日時点で有効なすべてのコースを契約管理情報を元に読み込む
	lngCtrCount = objContract.SelectAllCtrMng(strOrgCd1, strOrgCd2, "", strCslDate, strCslDate, , strArrCsCd, , strArrCsName, , , , strArrCtrPtCd)
	If lngCtrCount <= 0 Then
		Exit Do
	End If

	'指定団体における受診日時点で有効な受診区分を契約管理情報を元に読み込む(コース指定時はさらにそのコースで有効なもの)
	lngCslDivCount = objContract.SelectAllCslDiv(strOrgCd1, strOrgCd2, strCsCd, strCslDate, strCslDate, strArrCslDivCd, strArrCslDivName)
	If lngCslDivCount <= 0 Then
		Exit Do
	End If

	'受診日時点で有効なすべてのコースに指定されたコースが存在するかを検索し、その契約パターンコードを取得
	For i = 0 To lngCtrCount - 1
		If strArrCsCd(i) = strCsCd Then
			strNewCtrPtCd = strArrCtrPtCd(i)
			Exit For
		End If
	Next

	'日付がシステム日付を含む以降の場合はコースで有効な群を、過去日の場合はすべての群を取得
	If CDate(strCslDate) >= Date() Then

		'コースが存在しない場合、有効な予約群はなしと判断し、処理を終了する
		If strCsCd = "" Then
			Exit Do
		End If

		Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

		'指定コースにおける有効な予約群コース受診予約群情報を元に読み込む
		lngRsvGrpCount = objSchedule.SelectCourseRsvGrpListSelCourse(strCsCd, 0, strArrRsvGrpCd, strArrRsvGrpName)

		Set objSchedule = Nothing

	Else

		Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

		'すべての予約群を読み込む
		lngRsvGrpCount = objSchedule.SelectRsvGrpList(0, strArrRsvGrpCd, strArrRsvGrpName)

		Set objSchedule = Nothing

	End If

	'指定条件を満たす契約情報が存在しない場合、年齢計算も不能、かつオプション検査の取得も不能なため、処理を終了する
	If strNewCtrPtCd = "" Then
		Exit Do
	End If

	If strBirth = "" Then
		Exit Do
	End If

	'年齢計算に際し、まず契約情報を読み込んで年齢起算日を取得する(参照先の団体は後でアンカー用に使用する)
	objContract.SelectCtrMng strOrgCd1, strOrgCd2, strNewCtrPtCd, , , , , , , , strRefOrgCd1, strRefOrgCd2, strAgeCalc

	'オブジェクトのインスタンス作成
	Set objFree = Server.CreateObject("HainsFree.Free")

	'年齢計算
	strAge = objFree.CalcAge(strBirth, strCslDate, strAgeCalc)

	Set objFree = Nothing

	'選択すべき受診区分が存在するかを検索
	For i = 0 To lngCslDivCount - 1
		If strArrCslDivCd(i) = strCslDivCd Then
			blnExist = True
			Exit For
		End If
	Next

	'選択すべき受診区分が存在しなければオプション検査の取得は不能と判断し、処理を終了する
	If Not blnExist Then
		Exit Do
	End If

	'指定契約パターンの全オプション検査とそのデフォルト受診状態を取得
'## 2004.01.04 Mod By T.Takagi@FSIT 負担情報有無の取得
'	lngCount = objContract.SelectCtrPtOptFromConsult( _
'				   strCslDate,        _
'				   strCslDivCd,       _
'				   strNewCtrPtCd,     _
'				   strPerId,          _
'				   strGender,         _
'				   strBirth, ,        _
'				   True,              _
'				   False,             _
'				   strArrOptCd,       _
'				   strArrOptBranchNo, _
'				   strOptName, ,      _
'				   strSetColor,       _
'				   strSetClassCd,     _
'				   strConsult, , ,    _
'				   strBranchCount,    _
'				   strAddCondition, , _
'				   strHideRsv, , ,    _
'				   strPrice,          _
'				   strPerPrice,       _
'				   1                  _
'			   )
	lngCount = objContract.SelectCtrPtOptFromConsult( _
				   strCslDate,        _
				   strCslDivCd,       _
				   strNewCtrPtCd,     _
				   strPerId,          _
				   strGender,         _
				   strBirth, ,        _
				   True,              _
				   False,             _
				   strArrOptCd,       _
				   strArrOptBranchNo, _
				   strOptName, ,      _
				   strSetColor,       _
				   strSetClassCd,     _
				   strConsult, , ,    _
				   strBranchCount,    _
				   strAddCondition, , _
				   strHideRsv, , ,    _
				   strPrice,          _
				   strPerPrice,       _
				   1, ,               _
				   strExistsPrice     _
			   )
'## 2004.01.04 Mod End

	'デフォルト受診制御の決定
	Do

		'本ASP呼び出し直前の契約パターンと一致する場合
		If strNewCtrPtCd = strNowCtrPtCd Then
			strWkOptCd       = strNowOptCd
			strWkOptBranchNo = strNowOptBranchNo
			lngMode          = 2
			Exit Do
		End If

		'本ASP呼び出し直前の契約パターンとは一致しないが、詳細画面呼び出し直後の契約パターンと一致する場合
		If strNewCtrPtCd = strCtrPtCd Then
			strWkOptCd       = strOptCd
			strWkOptBranchNo = strOptBranchNo
			lngMode          = 1
			Exit Do
		End If

		'それ以外は読み込んだデフォルト状態に依存
		strWkOptCd       = Empty
		strWkOptBranchNo = Empty
		lngMode          = 0

		Exit Do
	Loop

	'読み込んだオプション検査情報を検索し、デフォルト受診制御を行う
	For i = 0 To lngCount - 1
		strConsult(i) = SetConsults(lngMode, strConsult(i), strAddCondition(i), strArrOptCd(i), strArrOptBranchNo(i), strWkOptCd, strWkOptBranchNo)
	Next

	'この時点で受診フラグが立っていない任意受診のセットに対し、先頭セットを受診状態にする
	i = 0
	Do Until i >= lngCount

		Do

			'自動追加オプションはスキップ
			If strAddCondition(i) = "0" Then
				i = i + 1
				Exit Do
			End If

			'枝番数が１のものは(チェックボックス制御となるので)スキップ
			If CLng("0" & strBranchCount(i)) <= 1 Then
				i = i + 1
				Exit Do
			End If

			'現在位置をキープ
			j = i

			strPrevOptCd = strArrOptCd(i)
			blnConsult = False

			'現在位置から同一オプションコードの受診状態を検索
			Do Until i >= lngCount

				'直前レコードとオプションコードが異なる場合は終了
				If strArrOptCd(i) <> strPrevOptCd Then
					Exit Do
				End If

				'すでに受診状態のものがあればフラグ成立
				If strConsult(i) = "1" Then
					blnConsult = True
				End If

				'現在のオプションコードを退避
				strPrevOptCd = strArrOptCd(i)
				i = i + 1
			Loop

			'結果、受診状態のものがなければ先にキープしておいた先頭のオプションを受診状態にする
			If Not blnConsult Then
				strConsult(j) = "1"
			End If

			Exit Do
		Loop

	Loop

	Exit Do
Loop
'-------------------------------------------------------------------------------
'
' 機能　　 : 受診状態の設定
'
' 引数　　 : (In)     lngParaMode            セット継承モード
' 　　　　 : (In)     strParaAddCondition    自動追加モード
' 　　　　 : (In)     strParaOptCd           オプションコード
' 　　　　 : (In)     strParaOptBranchNo     オプション枝番
' 　　　　 : (In)     strParaDefOptCd        継承チェックすべきオプションコードの集合
' 　　　　 : (In)     strParaDefOptBranchNo  継承チェックすべきオプション枝番の集合
'
' 戻り値　 : "1":受診する
' 　　　　 : "0":受診しない
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function SetConsults(lngParaMode, strParaConsult, strParaAddCondition, strParaOptCd, strParaOptBranchNo, strParaDefOptCd, strParaDefOptBranchNo)

	Dim Ret	'関数戻り値
	Dim i	'インデックス

	Do

		'初期設定
		Ret = "0"

		'現在の選択セットを全く継承しない場合、現受診状態をそのまま返す
		If lngParaMode <> 1 And lngParaMode <> 2 Then
			Ret = strParaConsult
			Exit Do
		End If

		'自動追加セットのみ継承する場合、自動追加セットであれば現受診状態をそのまま返す
		If lngParaMode = 2 And strParaAddCondition = "0" Then
			Ret = strParaConsult
			Exit Do
		End If

		'それ以外は現在の選択セットに存在するものを継承する

		'引数未指定時はチェック不能。継承しない。
		If IsEmpty(strParaDefOptCd) Or IsEmpty(strParaDefOptBranchNo) Then
			Exit Do
		End If

		'引数指定されたオプションに対してチェックをつける
		For i = 0 To UBound(strParaDefOptCd)
			If strParaDefOptCd(i) = strParaOptCd And strParaDefOptBranchNo(i) = strParaOptBranchNo Then
				Ret = "1"
				Exit Do
			End If
		Next

		'ここまででヒットしない場合は継承しない
		Exit Do
	Loop

	'戻り値の設定
	SetConsults = Ret

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>オプション検査</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// セット内項目削除画面呼び出し
function callDelItemWindow( selOptCd, selOptBranchNo ) {
	top.callDelItemWindow( '<%= strRsvNo %>', document.entryForm.ctrPtCd.value, selOptCd, selOptBranchNo );
}

// セット情報画面呼び出し
function callSetInfoWindow( selOptCd, selOptBranchNo ) {
	top.callSetInfoWindow( document.entryForm.ctrPtCd.value, selOptCd, selOptBranchNo );
}

// サブ画面を閉じる
function closeWindow() {
	top.closeWindow( top.winCompare );	// 検査セット情報の比較
	top.closeWindow( top.winDelItem );	// セット内項目削除
	top.closeWindow( top.winSetInfo );	// セット内情報
}

// 指定エレメントのチェック状態による行表示色設定
function selColor( selObj ) {

	var rowColor, topColor;	// 行全体の色、先頭列の色

	// 表示色を変更すべきノードを取得
	var changedNode = selObj.parentNode.parentNode;

	// 表示色の設定
	if ( selObj.checked ) {
		rowColor = '#eeeeee';
		topColor = '#ffc0cb';
	} else {
		rowColor = '#ffffff';
		topColor = '#ffffff';
	}

	// 表示色の変更
	changedNode.style.backgroundColor = rowColor;
	changedNode.getElementsByTagName('td')[0].style.backgroundColor = topColor;

}

function setAge( age, realAge ) {

	var ageName = '';

	// 予約詳細画面の年齢を更新する
	top.main.document.entryForm.age.value     = age;
	top.main.document.entryForm.realAge.value = realAge;

	// 実年齢の編集
	if ( realAge != '' ) {
		ageName = realAge + '歳';
	}

	// 受診情報の受診時年齢編集
	if ( age != '' ) {
		ageName = ageName + '（' + age.substring(0, age.indexOf('.')) + '歳）';
	}

	top.main.document.getElementById('dspAge').innerHTML = ageName;

}

// 指定エレメントに対応する行の選択表示
function setRow( selObj,chkFlg ) {

	var objRadio;	// ラジオボタンの集合
	var selFlg;		// 選択フラグ

	// エレメントタイプごとの処理分岐
	switch ( selObj.type ) {

		case 'checkbox':	// チェックボックス
			selColor( selObj );
			break;

		case 'radio':		// ラジオボタン

			// 同名の全エレメントに対する選択表示
			objRadio = document.optList.elements[ selObj.name ];
/*********************************
			selFlg = false;

			// エレメントが全く選択されていないかを判定
			for ( var i = 0; i < objRadio.length; i++ ) {
				if ( objRadio[ i ].checked ) {
					selFlg = true;
				}
			}

			// エレメントが全く選択されていなければ先頭項目を選択
			if ( !selFlg ) {
				objRadio[ 0 ].checked = true;
			}
*********************************/
			for ( var i = 0; i < objRadio.length; i++ ) {
				selColor( objRadio[ i ] );
			}

            // 2006.06.15 Add By 李　：GF特別割引設定 *****
            setGFRepeater( document.optList,chkFlg );  
            // 2006.06.15 Add End.					 *****
    
    }


    //alert(document.optList.hideCheck.value);
}


// 2006.06.15 Add By 李　：GF特別割引設定 *****
function setGFRepeater( objForm,chkFlg ) {

	var GFFlg = false;				// GF検査フラグ
	var RepeaterFlg = false;			// Repeaterフラグ
	var cslDate;
	var selOptCd;
    var hdnOptCd;
    var gfIndex;
    var strCheck = '';
    var hideCheck = false;
    var iscase = false;
    var mainForm = top.main.document.entryForm;

	if ( !objForm ) return;
	if ( objForm.length == null ) return;

	if ( mainForm.orgCd1.value != 'XXXXX' ) return;
	if ( mainForm.orgCd2.value != 'XXXXX' ) return;
	if ( mainForm.csCd.value != '100' ) return;

	cslDate = mainForm.cslYear.value + mainForm.cslMonth.value + mainForm.cslDay.value;

	// 全エレメントを検索
	for ( var i = 0; i < objForm.length; i++ ) {
        selOptCd = objForm.elements[ i ].value.split(',');
		// タイプを判断      
        switch ( objForm.elements[ i ].type ) {

			case 'checkbox':	// チェックボックス、ラジオボタンの場合
            case 'radio':
				// 
				if ( objForm.elements[ i ].checked ) {
					//selOptCd = objForm.elements[ i ].value.split(',');
                    strCheck = CheckFlag(selOptCd[ 3 ]);
				}
				break;

			default:
				continue;

		}

        if (strCheck =="1"){
            GFFlg = true;
        }
        
        if (strCheck =="2"){
            RepeaterFlg = true;
        }

	}


    for ( var j = 0; j < objForm.length; j++ ) {
        selOptCd = objForm.elements[j].value.split(',');

        if ( selOptCd[ 3 ] == '069' ) {
            iscase = true ;
            switch ( objForm.elements[ j ].type ) {
                case 'checkbox':	// チェックボックス、ラジオボタンの場合
                case 'radio':         
                    gfIndex = j;
                    if ( GFFlg  && RepeaterFlg ) {
                        if (chkFlg == 1) {
                             objForm.elements[j].checked = true;
                        } else {
                            hideCheck = true;
                        }

                    } else {
                        objForm.elements[j].checked = false;
                    }
                    
                    selColor( objForm.elements[j] );
                    break;

                case 'hidden':		// 隠しエレメントの場合

                    if ( GFFlg  && RepeaterFlg ) {
                        objForm.elements[j].value = selOptCd[0] + ',' + selOptCd[1] + ',' +'1,' + selOptCd[3] ; 
                    } else {
                        objForm.elements[j].value = selOptCd[0] + ',' + selOptCd[1] + ',' +'0,' + selOptCd[3] ; 
                    }
                    
                    break;

                default:
                    continue;
             }
        }
    }


    if (iscase) {
        //alert(iscase);
        hdnOptCd = objForm.elements[gfIndex].value.split(',');
        if (hideCheck && objForm.elements[gfIndex].checked == false) {
            objForm.hideCheck.value =hdnOptCd[0] + ',' + hdnOptCd[1] + ',' +'1,' + hdnOptCd[3] ;
        } else {
            objForm.hideCheck.value =hdnOptCd[0] + ',' + hdnOptCd[1] + ',' +'0,' + hdnOptCd[3] ;
        }
         //alert(objForm.hideCheck.value);
    }


}


// 2006.06.20 Add By 李　：GF,Repeater Check
function CheckFlag(setClassCd)  {

	if ( setClassCd == '002' || setClassCd == '003' ) {
         return 1;
	}

	if ( setClassCd == '023' ) {
        return 2;
	}

}


// 全行の選択表示
function setRows() {

	// 一覧が存在しなければ何もしない
	if ( !document.optList ) {
		return;
	}

	var objElements = document.optList.elements;
	for ( var i = 0; i < objElements.length; i++ ) {
		setRow( objElements[ i ],0 );
	}

}

// 一覧の再表示
function showOptList() {

	var arrOptCd       = new Array();	// オプションコード
	var arrOptBranchNo = new Array();	// オプション枝番

	// オプション検査情報読み込み
	var url = '<%= Request.ServerVariables("SCRIPT_NAME") %>';

	// 現在の表示条件を基本情報画面より取得
	var mainForm = top.main.document.entryForm;
	url = url + '?rsvno=<%= strRsvNo %>';
	url = url + '&cancelFlg=<%= lngCancelFlg %>';
	url = url + '&gender='   + mainForm.gender.value;
	url = url + '&birth='    + mainForm.birth.value;
	url = url + '&orgCd1='   + mainForm.orgCd1.value;
	url = url + '&orgCd2='   + mainForm.orgCd2.value;
	url = url + '&csCd='     + mainForm.csCd.value;
	url = url + '&cslDate='  + mainForm.cslYear.value + '/' + mainForm.cslMonth.value + '/' + mainForm.cslDay.value;
	url = url + '&cslDivCd=' + mainForm.cslDivCd.value;
	url = url + '&rsvGrpCd=' + mainForm.rsvGrpCd.value;

	// 現在のパターン値、表示方法を取得
	var myForm = document.entryForm;
	url = url + '&ctrPtCd=' + myForm.ctrPtCd.value;
	url = url + '&showAll=' + ( myForm.showAll.checked ? myForm.showAll.value : '');

	// 現在の選択オプション値を取得
	top.convOptCd( document.optList, arrOptCd, arrOptBranchNo );

	// オプション値を追加
	url = url + '&optCd='  + arrOptCd;
	url = url + '&optBNo=' + arrOptBranchNo;

	url = url + '&readNoRep=1';

	// 画面の再読み込み
	location.replace( url );

}
//-->
</SCRIPT>
<style type="text/css">
body { margin: 0 0 0 10px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:setRows()" ONUNLOAD="javascript:closeWindow()">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">検査セット</FONT></B></TD>
	</TR>
</TABLE>
<%
Do
	'契約情報の表示が行えない場合はメッセージを編集
	If Not blnExist Then
%>
		<BR>基本情報を入力して下さい。
<%
		Exit Do
	End If
%>
	<FORM NAME="entryForm" STYLE="margin: 0px" action="#">
		<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strNewCtrPtCd %>">
		<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0">
			<TR>
				<TD NOWRAP>パターンNo.</TD>
				<TD>：</TD>
				<TD><B><%= strNewCtrPtCd %></B></TD>
<%
				'契約参照用のURL編集
				strURL = "/webHains/contents/contract/ctrDetail.asp"
				strURL = strURL & "?orgCd1="  & strRefOrgCd1
				strURL = strURL & "&orgCd2="  & strRefOrgCd2
				strURL = strURL & "&csCd="    & strCsCd
				strURL = strURL & "&ctrPtCd=" & strNewCtrPtCd
%>
				<TD NOWRAP>　<A HREF="<%= Replace(strURL, "&", "&amp;") %>" TARGET="_blank">この契約を参照</A></TD>
<%
				'新規以外の場合「セット情報の比較」アンカーを表示
				If strRsvNo <> "" Then
%>
					<TD NOWRAP>　<A HREF="javascript:function voi(){};voi()" ONCLICK="javascript:top.callCompareWindow()">検査セットの比較</A></TD>
<%
'## 2004.10.27 Add By T.Takagi@FSIT 日付変更時はセット比較画面を自動表示
					blnCompare = True
'## 2004.10.27 Add End
				End If
%>
				<TD WIDTH="100%" ALIGN="right"><INPUT TYPE="checkBox" NAME="showAll" VALUE="1"<%= IIf(strShowAll <> "", " CHECKED", "") %> ONCLICK="javascript:top.main.optionForm.showAll.value = (this.checked ? '1' : '')"></TD>
				<TD NOWRAP>すべての検査を</TD>
				<TD><A HREF="javascript:showOptList()"><IMG SRC="/webHains/images/b_prev.gif" HEIGHT="28" WIDTH="53" ALT="検査セットを再表示します"></A></TD>
			</TR>
			<TR>
				<TD HEIGHT="5"></TD>
			</TR>
		</TABLE>
	</FORM>
<%
	'オプション検査が存在しない場合はメッセージ編集
	If lngCount = 0 Then
		Response.Write "この契約情報のオプション検査は存在しません。"
		Exit Do
	End If

	lngOptGrpSeq = 0
%>
	<FORM NAME="optList" STYLE="margin: 0px" action="#">
		<TABLE ID="optTable" BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="100%">
			<TR>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="1" ALT=""></TD>
			</TR>
			<TR BGCOLOR="#eeeeee" ALIGN="center">
<%
				'契約パターン情報を読み、契約上のコース名を取得
				objContract.SelectCtrPt strNewCtrPtCd, , , , , strCsName
%>
				<TD ALIGN="left" COLSPAN="3" NOWRAP>検査セット名（<%= strCsName %>）</TD>
				<TD NOWRAP>負担金額計</TD>
				<TD NOWRAP>個人負担分</TD>
				<TD NOWRAP>セット内</TD>
				<TD NOWRAP>情報</TD>
				<TD></TD>
			</TR>
<%
			'読み込んだオプション検査情報の検索
			strPrevOptCd = ""

			For i = 0 To lngCount - 1
				'直前レコードとオプションコードが異なる場合
				If strArrOptCd(i) <> strPrevOptCd Then

					'まず編集するエレメントを設定する(枝番数が１つならチェックボックス、さもなくばラジオボタン選択)
					strElementType = IIf(CLng(strBranchCount(i)) = 1, "checkbox", "radio")

					'オプション編集用のエレメント名を定義する
					lngOptGrpSeq   = lngOptGrpSeq + 1
					strElementName = "opt" & CStr(lngOptGrpSeq)

				End If

				'リピータ割引セットであれば
				If strSetClassCd(i) = SETCLASS_REPEATER Then

					'リピータ割引セットの有無を「あり」にする
					blnHasRepeaterSet = True

					'さらに現在の受診状態を取得
					If strConsult(i) = "1" Then
						blnRepeaterConsult = True
					End If

				End If

				'予約画面非表示オプション、かつすべての検査を表示しない場合
				If strHideRsv(i) <> "" And strShowAll = "" Then

					'後で編集するためにここでスタックする
					ReDim Preserve strHideElementName(lngHideCount)
					ReDim Preserve strHideOptCd(lngHideCount)
					ReDim Preserve strHideOptBranchNo(lngHideCount)
					ReDim Preserve strHideConsult(lngHideCount)
					strHideElementName(lngHideCount) = strElementName
					strHideOptCd(lngHideCount) = strArrOptCd(i)
					strHideOptBranchNo(lngHideCount) = strArrOptBranchNo(i)
					strHideConsult(lngHideCount) = strConsult(i)

					'## 2006.06.20 Add by 李 ---------------------------------------
					ReDim Preserve strHideSetClassCd(lngHideCount)
					strHideSetClassCd(lngHideCount) = strSetClassCd(i)
					'## 2006.06.20 End.  ---

					lngHideCount = lngHideCount + 1

				'表示対象オプションの場合
				Else

					'直前レコードとオプションコードが異なる場合はセパレータを編集
					If strPrevOptCd <> "" And strArrOptCd(i) <> strPrevOptCd Then
%>
						<TR><TD HEIGHT="3"></TD></TR>
<%
					End If

					strChecked = IIf(strConsult(i) = "1", " CHECKED", "")
%>
					<TR ALIGN="right">
						<TD></TD>
						<!--2006.06.20 strSetClassCd追加   -->
						<TD><INPUT TYPE="<%= strElementType %>" NAME="<%= strElementName %>" VALUE="<%= strArrOptCd(i) & "," & strArrOptBranchNo(i) & "," & "," & strSetClassCd(i) %>"<%= strChecked %> ONCLICK="javascript:setRow(this,1)"></TD>
						
						<TD ALIGN="left" WIDTH="100%"><FONT COLOR="<%= strSetColor(i) %>">■</FONT><%= strOptName(i) %></TD>
						<TD><%= FormatCurrency(strPrice(i)) %></TD>
						<TD><%= FormatCurrency(strPerPrice(i)) %></TD>
<%
						'キャンセル者でない場合「削除」アンカーを表示する
						If strRsvNo <> "" And lngCancelFlg = CONSULT_USED Then
%>
							<TD ALIGN="center"><A HREF="javascript:callDelItemWindow('<%= strArrOptCd(i) %>','<%= strArrOptBranchNo(i) %>')">削除</A></TD>
<%
						Else
%>
							<TD></TD>
<%
						End If
%>
						<TD><A HREF="javascript:callSetInfoWindow('<%= strArrOptCd(i) %>','<%= strArrOptBranchNo(i) %>')">情報</A></TD>
						<TD NOWRAP>&nbsp;<%= strArrOptCd(i) & "-" & strArrOptBranchNo(i) %></TD>

					</TR>
<%
				End If

				'現レコードのオプションコードを退避
				strPrevOptCd = strArrOptCd(i)
			Next
%>
		</TABLE>
<%
		'スタックされた情報をここでhiddenにて保持
		For i = 0 To lngHideCount - 1
%>
			<INPUT TYPE="hidden" NAME="<%= strHideElementName(i) %>" VALUE="<%= strHideOptCd(i) & "," & strHideOptBranchNo(i) & "," & strHideConsult(i) & "," & strHideSetClassCd(i)  %>">
<%
		Next
%>
        <INPUT TYPE="hidden" NAME="hideCheck"       VALUE="">
	</FORM>
<%
	Exit Do
Loop
%>
<SCRIPT TYPE="text/javascript">
<!--
<%
'コースセレクションボックスの編集
%>
var courseInfo = new Array();
<%
For i = 0 To lngCtrCount - 1
%>
	courseInfo[ <%= i %> ] = new top.codeAndName('<%= strArrCsCd(i) %>', '<%= strArrCsName(i) %>');
<%
Next
%>
top.editCourse(courseInfo, '<%= strCsCd %>');
<%
'受診区分セレクションボックスの編集
%>
var cslDivInfo = new Array();
<%
For i = 0 To lngCslDivCount - 1
%>
	cslDivInfo[ <%= i %> ] = new top.codeAndName( '<%= strArrCslDivCd(i) %>', '<%= strArrCslDivName(i) %>' );
<%
Next
%>
top.editCslDiv(cslDivInfo, '<%= strCslDivCd %>');
<%
'予約群セレクションボックスの編集
%>
var rsvGrpInfo = new Array();
<%
For i = 0 To lngRsvGrpCount - 1
%>
	rsvGrpInfo[ <%= i %> ] = new top.codeAndName( '<%= strArrRsvGrpCd(i) %>', '<%= strArrRsvGrpName(i) %>' );
<%
Next
%>
top.editRsvGrp(rsvGrpInfo, '<%= strRsvGrpCd %>');

<% '年齢を計算し、基本情報に編集する %>
setAge('<%= strAge %>','<%= strRealAge %>');
<%
Do

	'契約情報の表示が行われていない場合
	If Not blnExist Then
%>
		// 最新状態を更新
		top.main.document.repInfo.hasRepeaterSet.value  = '';
		top.main.document.repInfo.repeaterConsult.value = '';
<%
		Exit Do
	End If

	'キャンセル者の場合、すべての入力要素を使用不能にする
	If lngCancelFlg <> CONSULT_USED Then
%>
		if ( document.optList ) {
			var elem = document.optList.elements;
			for ( var i = 0; i < elem.length; i++ ) {
				elem[i].disabled = true;
			}
		}
<%
		Exit Do
	End If

	'すでに入金済みならばここでイネーブル制御を行う(次のリピータ割引検索処理は行わない。金額が狂う。)
%>
//		if ( document.optList ) {
//			var elem = document.optList.elements;
//			for ( var i = 0; i < elem.length; i++ ) {
//				alert(elem[i].name);
//			}
//		}
<%
	'オプション情報その２を読む
	If strReadNoRep = "" Then

		'初期表示時は本画面で求めたリピータ状態を渡す
		If strInit <> "" Then
%>
			var hasRepeaterSet  = '<%= IIf(blnHasRepeaterSet,  "1", "") %>';
			var repeaterConsult = '<%= IIf(blnRepeaterConsult, "1", "") %>';
<%
		'それ以外は基本情報画面でキープしている状態を渡す
		Else
%>
			var hasRepeaterSet  = top.main.repInfo.hasRepeaterSet.value;
			var repeaterConsult = top.main.repInfo.repeaterConsult.value;
<%
		End If
%>
		top.replaceCslList('<%= strCslDate %>','<%= strCslDivCd %>','<%= strNewCtrPtCd %>','<%= strPerId %>','<%= strGender %>','<%= strBirth %>', hasRepeaterSet, repeaterConsult);
<%
	End If

	Exit Do
Loop

'## 2004.10.27 Add By T.Takagi@FSIT 日付変更時はセット比較画面を自動表示
If blnDateChanged And blnCompare Then
%>
top.callCompareWindow();
<%
End If
'## 2004.10.27 Add End
%>
//-->
</SCRIPT>
</BODY>
</HTML>

