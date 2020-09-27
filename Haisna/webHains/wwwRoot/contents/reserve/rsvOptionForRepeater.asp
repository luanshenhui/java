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
Dim objConsult			'受診情報アクセス用
Dim objContract			'契約情報アクセス用

'引数値(共通)
Dim strPerId			'個人ＩＤ
Dim strGender			'性別
Dim strBirth			'生年月日
Dim strCslDate			'受診日
Dim strCslDivCd			'受診区分コード
Dim strCtrPtCd			'契約パターンコード
Dim blnHasRepeaterSet	'(本処理が呼ばれた時点の)契約におけるリピータ割引セットの有無
Dim blnRepeaterConsult	'(本処理が呼ばれた時点の)リピータ割引セットの受診有無

'オプション検査情報
Dim strArrOptCd			'オプションコード
Dim strArrOptBranchNo	'オプション枝番
Dim strSetClassCd		'セット分類コード
Dim strConsult			'受診要否
Dim strAddCondition		'追加条件
Dim strLastRefCsCd		'前回値参照用コースコード
Dim lngCount			'オプション検査数

Dim strWkLastRefCsCd()	'前回値参照用コースコード
Dim lngCsCount			'前回値参照用コース数

Dim strHisCslDate		'(受診歴の)受診日
Dim strHisCsCd			'(受診歴の)コースコード
Dim lngHisCount			'受診歴数

Dim strStatement()		'編集用ステートメント
Dim lngStaCount			'ステートメント数
Dim i					'インデックス

Dim blnNewHasRepeaterSet	'(本処理後の)契約におけるリピータ割引セットの有無
Dim blnNewRepeaterConsult	'(本処理後の)リピータ割引セットの受診有無

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objContract = Server.CreateObject("HainsContract.Contract")

'パラメータ値の取得
strCslDate  = Request("cslDate")
strCslDivCd = Request("cslDivCd")
strCtrPtCd  = Request("ctrPtCd")
strPerId    = Request("perId")
strGender   = Request("gender")
strBirth    = Request("birth")

blnHasRepeaterSet  = (Request("hasRepSet")  <> "")
blnRepeaterConsult = (Request("repConsult") <> "")

'指定契約パターンの全オプション検査とそのデフォルト受診状態を取得
lngCount = objContract.SelectCtrPtOptFromConsult(strCslDate, strCslDivCd, strCtrPtCd, strPerId, strGender, strBirth, , True, , strArrOptCd, strArrOptBranchNo, , , , strSetClassCd, strConsult, , , , strAddCondition, , , , , , , 1, strLastRefCsCd)
%>
<SCRIPT TYPE="text/javascript">
<!--
function setRepeaterConsults( optCd, optBranchNo, consults ) {

	var objElements = top.opt.document.optList.elements;
	var elemOptCd;

	// オプション検査画面のエレメント検索
	for ( var i = 0; i < objElements.length; i++ ) {

		elemOptCd = objElements[ i ].value.split(',');
		if ( elemOptCd[ 0 ] != optCd || elemOptCd[ 1 ] != optBranchNo ) {
			continue;
		}

		// タイプを判断
		switch ( objElements[ i ].type ) {

			case 'checkbox':	// チェックボックス、ラジオボタンの場合
			case 'radio':
				objElements[ i ].checked = ( consults == '1' );
				break;

			case 'hidden':		// 隠しエレメントの場合
				objElements[ i ].value = optCd + ',' + optBranchNo + ',' + consults;
				break;

			default:

		}

	}

}
<%
'オプション検査の検索
For i = 0 To lngCount - 1

	'リピータ割引のセットであれば
	If strSetClassCd(i) = SETCLASS_REPEATER Then

		'リピータ割引セットの有無を「あり」にする
		blnNewHasRepeaterSet = True

		'そのコースをスタック
		If strLastRefCsCd(i) <> "" Then
			ReDim Preserve strWkLastRefCsCd(lngCsCount)
			strWkLastRefCsCd(lngCsCount) = strLastRefCsCd(i)
			lngCsCount = lngCsCount + 1
		End If

		'さらに現在の受診状態を取得
		If strConsult(i) = "1" Then
			blnNewRepeaterConsult = True
		End If

		'オプション検査画面への編集用関数をスタック
		ReDim Preserve strStatement(lngStaCount)
		strStatement(lngStaCount) = "setRepeaterConsults('" & strArrOptCd(i) & "','" & strArrOptBranchNo(i) & "','" & strConsult(i) & "');"
		lngStaCount = lngStaCount + 1

	End If

Next

'リピータ割引セットがあれば
If blnNewHasRepeaterSet Then

'	Set objConsult = Server.CreateObject("HainsConsult.Consult")
'
'	'受診歴を読む
'	lngHisCount = objConsult.SelectConsultHistory(strPerId, , True, , , , strHisCslDate, strHisCsCd)
'
'	Set objConsult = Nothing

End If

'ステートメント編集
For i = 0 To lngStaCount - 1
	Response.Write strStatement(i) & vbCrLf
Next
%>
// 全行の選択表示
top.opt.setRows();
<%
If Not blnRepeaterConsult And blnNewRepeaterConsult Then
%>
	alert('リピータ割引が対象となりました。');
<%
End If

If blnRepeaterConsult And Not blnNewRepeaterConsult Then
%>
	alert('リピータ割引対象から外れました。');
<%
End If
%>
// 最新状態を更新
top.main.document.repInfo.hasRepeaterSet.value  = '<%= IIf(blnNewHasRepeaterSet,  "1", "") %>';
top.main.document.repInfo.repeaterConsult.value = '<%= IIf(blnNewRepeaterConsult, "1", "") %>';
//-->
</SCRIPT>
