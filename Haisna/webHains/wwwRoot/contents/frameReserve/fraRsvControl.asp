<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		予約枠検索(エレメント動的制御) (Ver0.0.1)
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
Const OPTCOUNT_PER_ROW = 3	'１行あたりの最大表示オプション数

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objContract			'契約情報アクセス用
Dim objFree				'汎用情報アクセス用
Dim objOrganization		'団体情報アクセス用
Dim objPerson			'個人情報アクセス用
Dim objSchedule			'スケジュール情報アクセス用

'引数値
Dim strCslDate			'受診日
Dim lngCondIndex		'検索条件インデックス
Dim strPerId			'個人ＩＤ
Dim strGender			'性別
Dim strBirth			'生年月日
Dim strAge				'受診時年齢
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strCsCd				'コースコード
Dim strCslDivCd			'受診区分コード
Dim strRsvGrpCd			'予約群コード
Dim strCtrPtCd			'契約パターンコード
Dim strOptCd			'オプションコード
Dim strOptBranchNo		'オプション枝番

'個人情報
Dim strLastName			'姓
Dim strFirstName		'名
Dim strLastKName		'カナ姓
Dim strFirstKName		'カナ名
Dim strPerBirth			'生年月日
Dim strPerGender		'性別
Dim strPerAge			'受診時年齢
Dim strCompPerId		'同伴者ＩＤ

'20080417 予約枠検査画面にコメントボタン追加のため START
'受信暦情報
Dim lngRsvNo            '最後受信日
Dim lngPerCmt           '個人・過去受信コメント有無
Dim lngHisCsl           '受信暦有無
'20080417 予約枠検査画面にコメントボタン追加のため END

'編集用の個人情報
Dim strPerName			'氏名
Dim strPerKName			'カナ氏名
Dim strPerBirthJpn		'生年月日

'団体情報
Dim strOrgName			'団体名称
Dim strOrgKName			'団体カナ名称

'### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　Start ###
Dim strHighLight        ' 団体名称ハイライト表示区分
'### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　End   ###


'契約情報
Dim strArrCsCd			'コースコード
Dim strArrCsName		'コース名
Dim strArrCtrPtCd		'契約パターンコード
Dim strArrAgeCalc		'年齢起算日
Dim lngCtrCount			'契約情報数

'受診区分情報
Dim strArrCslDivCd		'受診区分コード
Dim strArrCslDivName	'受診区分名
Dim lngCslDivCount		'受診区分数

'予約群情報
Dim strArrRsvGrpCd		'予約群コード
Dim strArrRsvGrpName	'予約群名称
Dim lngRsvGrpCount		'予約群数

'オプション検索時の条件キー
Dim lngKeyGender		'性別
Dim strKeyAge			'受診時年齢

'オプション検査情報
Dim strArrOptCd			'オプションコード
Dim strArrOptBranchNo	'オプション枝番
Dim strOptSName			'オプション略称
Dim strSetColor			'セットカラー
Dim strConsult			'受診要否
Dim strBranchCount		'オプション枝番数
Dim strAddCondition		'追加条件
Dim strHideRsvFra		'予約枠画面非表示
Dim lngCount			'オプション検査数

'表示オプション用のHTML
Dim strShowHTML()		'HTML文字列
Dim lngShowCount		'配列の要素数

Dim strPrevOptCd		'直前レコードのオプションコード
Dim strElementType		'オプション選択用のエレメント種別
Dim lngOptGrpSeq		'オプショングループのSEQ値
Dim strElementName		'オプション選択用のエレメント名
Dim lngHorizIndex		'横方向のインデックス
Dim strHTML				'HTML文字列

Dim strNewCsCd			'コースコード
Dim strNewCtrPtCd		'契約パターンコード
Dim strNewAgeCalc		'年齢起算日
Dim strNewCslDivCd		'受診区分コード
Dim blnEditSet			'セット編集対象フラグ
Dim strMessage			'メッセージ
Dim strChecked			'チェック用文字列
Dim i					'インデックス
'## 2003.11.25 Add By T.Takagi@FSIT 任意受診のセットグループなら先頭をデフォルトで受診状態にする
Dim lngCurIndex			'インデックス
Dim blnExistsSet		'要選択セットの有無
Dim blnEdited			'編集フラグ
'## 2003.11.25 Add End

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objContract = Server.CreateObject("HainsContract.Contract")

'引数値の取得
strCslDate     = Request("cslDate")
lngCondIndex   = CLng("0" & Request("condIndex"))
strPerId       = Request("perId")
strGender      = Request("gender")
strBirth       = Request("birth")
strAge         = Request("age")
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
strCsCd        = Request("csCd")
strCslDivCd    = Request("cslDivCd")
strRsvGrpCd    = Request("rsvGrpCd")
strCtrPtCd     = Request("ctrPtCd")
strOptCd       = ConvIStringToArray(Request("optCd"))
strOptBranchNo = ConvIStringToArray(Request("optBranchNo"))
%>
<SCRIPT TYPE="text/javascript">
<!--
<%
'個人情報読み込み
If strPerId <> "" Then

	'オブジェクトのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")
	Set objPerson = Server.CreateObject("HainsPerson.Person")

	'個人情報読み込み
	If objPerson.SelectPerson_lukes(strPerId, strLastName, strFirstName, strLastKName, strFirstKName, , strPerBirth, strPerGender, , , , strCompPerId) = False Then
		strPerId = Empty
	End If

	'姓名の編集
	strPerName  = Trim(strLastName  & "　" & strFirstName)
	strPerKName = Trim(strLastKName & "　" & strFirstKName)

	'生年月日の編集
	strPerBirthJpn = objCommon.FormatString(strPerBirth, "ge.m.d")

' 20080417 予約枠検査画面にコメントボタン追加のため START    
    '受信暦有無確認
    lngHisCsl = objPerson.SelectPerson_note(strPerId, lngRsvNo, lngPerCmt)
' 20080417 予約枠検査画面にコメントボタン追加のため END
    
    Set objCommon = Nothing
	Set objPerson = Nothing

End If

'オブジェクトのインスタンス作成
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'団体情報読み込み
'### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　Start ###

'objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , strOrgKName, strOrgName
objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2,,strOrgKName,strOrgName,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,strHighLight

'### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　End   ###





Set objOrganization = Nothing

'指定団体における受診日時点で有効なすべての１次健診コースを契約管理情報を元に読み込む
lngCtrCount = objContract.SelectAllCtrMng(strOrgCd1, strOrgCd2, "", strCslDate, strCslDate, , strArrCsCd, , strArrCsName, , , , strArrCtrPtCd, , , strArrAgeCalc, , True)

'受診日時点で有効なすべての契約コースに指定コースが存在するかを検索し、存在時はその契約パターンと年齢起算日とを取得
For i = 0 To lngCtrCount - 1
	If strArrCsCd(i) = strCsCd Then
		strNewCsCd    = strArrCsCd(i)
		strNewCtrPtCd = strArrCtrPtCd(i)
		strNewAgeCalc = strArrAgeCalc(i)
		Exit For
	End If
Next

'年齢計算
Do

	'契約パターンが存在しない場合は何もしない
	If strNewCtrPtCd = "" Then
		Exit Do
	End If

	'オブジェクトのインスタンス作成
	Set objFree = Server.CreateObject("HainsFree.Free")

	'個人情報が存在する場合、個人の生年月日をもとに年齢計算
	If strPerId <> "" Then
		strPerAge = objFree.CalcAge(strPerBirth, strCslDate, strNewAgeCalc)
		If strPerAge <> "" Then
			strPerAge = CStr(Int(strPerAge))
		End If
	End If

	'生年月日条件が指定されている場合
	If strBirth <> "" Then

		'指定された生年月日をもとに年齢計算(同時に年齢条件が指定されている場合、本計算処理によってその値は無効となる)
		strAge = objFree.CalcAge(strBirth, strCslDate, strNewAgeCalc)
		If strAge <> "" Then
			strAge = CStr(CInt(strAge))	'小数点以下を除去
		End If

		Exit Do
	End If

	'生年月日未指定時は年齢値のチェックを行う
	If CheckAge(strAge) Then
		strAge = CStr(CInt(strAge))	'先頭にゼロが入力されている場合は除去
	End If

	Exit Do
Loop

'-------------------------------------------------------------------------------
'個人情報の編集
'-------------------------------------------------------------------------------
%>
// 20080417 予約枠検査画面にコメントボタン追加のため変更 START
//top.editPerson( <%= lngCondIndex %>, '<%= strPerId %>', '<%= strPerName %>', '<%= strPerKName %>', '<%= strPerBirthJpn %>', '<%= strPerAge %>', '<%= strPerGender %>', '<%= strCompPerId %>', <%= IIf(strGender <> "", 1, 0) %>, '<%= strAge %>'
// 20080417 予約枠検査画面にコメントボタン追加のため変更 END

top.editPerson( <%= lngCondIndex %>, '<%= strPerId %>', '<%= strPerName %>', '<%= strPerKName %>', '<%= strPerBirthJpn %>', '<%= strPerAge %>', '<%= strPerGender %>', '<%= strCompPerId %>', <%= IIf(strGender <> "", 1, 0) %>, '<%= strAge %>','<%= lngRsvNo %>','<%= lngPerCmt %>');
<%
'-------------------------------------------------------------------------------
'契約パターン情報の編集
'-------------------------------------------------------------------------------
%>
top.editCtrPtInfo( <%= lngCondIndex %>, '<%= strNewCtrPtCd %>', '<%= strOrgCd1 %>', '<%= strOrgCd2 %>', '<%= strNewCsCd %>' );
<%
'-------------------------------------------------------------------------------
'団体情報の編集
'-------------------------------------------------------------------------------
%>
//top.editOrg( <%= lngCondIndex %>, '<%= strOrgCd1 %>', '<%= strOrgCd2 %>', '<%= strOrgName %>', '<%= strOrgKName %>' );
top.editOrg( <%= lngCondIndex %>, '<%= strOrgCd1 %>', '<%= strOrgCd2 %>', '<%= strOrgName %>', '<%= strOrgKName %>' , '<%= strHighLight %>' );
<%
'-------------------------------------------------------------------------------
'コースセレクションボックスの編集
'-------------------------------------------------------------------------------
%>
var courseInfo = new Array();
<%
For i = 0 To lngCtrCount - 1
%>
	courseInfo[ <%= i %> ] = new top.codeAndName('<%= strArrCsCd(i) %>', '<%= strArrCsName(i) %>');
<%
Next
%>
top.editSelectionBox( 'csCd', <%= lngCondIndex %>, courseInfo, '<%= strCsCd %>' );
<%
'-------------------------------------------------------------------------------
'受診区分セレクションボックスの編集
'-------------------------------------------------------------------------------
%>
var cslDivInfo = new Array();
<%
'指定団体における受診日時点で有効な受診区分を契約管理情報を元に読み込む(コース指定時はさらにそのコースで有効なもの)
lngCslDivCount = objContract.SelectAllCslDiv(strOrgCd1, strOrgCd2, strNewCsCd, strCslDate, strCslDate, strArrCslDivCd, strArrCslDivName)

For i = 0 To lngCslDivCount - 1
%>
	cslDivInfo[ <%= i %> ] = new top.codeAndName( '<%= strArrCslDivCd(i) %>', '<%= strArrCslDivName(i) %>' );
<%
Next
%>
top.editSelectionBox( 'cslDivCd', <%= lngCondIndex %>, cslDivInfo, '<%= strCslDivCd %>' );
<%
'有効なすべての受診区分に指定受診区分が存在するかを検索
For i = 0 To lngCslDivCount - 1
	If strArrCslDivCd(i) = strCslDivCd Then
		strNewCslDivCd = strArrCslDivCd(i)
		Exit For
	End If
Next

'-------------------------------------------------------------------------------
'予約群セレクションボックスの編集
'-------------------------------------------------------------------------------
%>
var rsvGrpInfo = new Array();
<%
'予約群の検索
Do

	'コース未決定時は何もしない
	If strNewCsCd = "" Then
		Exit Do
	End If

	'オブジェクトのインスタンス作成
	Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

	'指定コースにおける有効な予約群コース受診予約群情報を元に読み込む
	lngRsvGrpCount = objSchedule.SelectCourseRsvGrpListSelCourse(strNewCsCd, 0, strArrRsvGrpCd, strArrRsvGrpName)

	Set objSchedule = Nothing

	'予約群が存在しない場合は終了
	If lngRsvGrpCount <= 0 Then
		Exit Do
	End If

	For i = 0 To lngRsvGrpCount - 1
%>
		rsvGrpInfo[ <%= i %> ] = new top.codeAndName( '<%= strArrRsvGrpCd(i) %>', '<%= strArrRsvGrpName(i) %>' );
<%
	Next

	Exit Do
Loop
%>
top.editSelectionBox( 'rsvGrpCd', <%= lngCondIndex %>, rsvGrpInfo, '<%= strRsvGrpCd %>', true );
<%
'-------------------------------------------------------------------------------
'セットの編集
'-------------------------------------------------------------------------------
Do

	'セット表示要否のチェック
	Do

		blnEditSet = False

		'契約パターンなし場合は表示しない
		If strNewCtrPtCd = "" Then
			strMessage = "契約情報が存在しません。"
			Exit Do
		End If

		'受診区分なしの場合は表示しない
		If strNewCslDivCd = "" Then
			strMessage = "受診区分を選択して下さい。"
			Exit Do
		End If

		'個人ＩＤ指定時は表示
		If strPerId <> "" Then
			blnEditSet = True
			Exit Do
		End If

		'以下は個人ＩＤ未指定の場合

		'年齢・性別未確定ならば表示しない
		If strGender = "" And strAge = "" Then
			Exit Do
		End If

		'性別値が正しくない場合は表示しない
		Select Case strGender
			Case CStr(GENDER_MALE), CStr(GENDER_FEMALE)
			Case Else
				strMessage = "性別の値が正しくありません。"
				Exit Do
		End Select

		'年齢値が正しくない場合は表示しない
		If Not CheckAge(strAge) Then
			strMessage = "年齢が指定されていません。または計算できません。"
			Exit Do
		End If

		blnEditSet = True
		Exit Do
	Loop

	'セット表示を行わない場合はセットをクリアし、終了
	If Not blnEditSet Then
%>
		top.editSet( <%= lngCondIndex %>, '<%= strMessage %>' );
<%
		Exit Do
	End If

	'個人ＩＤ指定時
	If strPerId <> "" Then

		'性別、年齢指定は不要
		lngKeyGender = 0
		strKeyAge = ""

	'個人ＩＤ未指定時
	Else

		'性別、年齢を指定
		lngKeyGender = CLng(strGender)
		strKeyAge = strAge

	End If

	'指定契約パターンの全オプション検査とそのデフォルト受診状態を取得
	lngCount = objContract.SelectCtrPtOptFromConsult(strCslDate, strNewCslDivCd, strNewCtrPtCd, strPerId, lngKeyGender, , strKeyAge, True, , strArrOptCd, strArrOptBranchNo, , strOptSName, strSetColor, , strConsult, , , strBranchCount, strAddCondition, strHideRsvFra)

	'表示オプションの編集
	i = 0
	Do Until i >= lngCount

		Do

			'予約枠画面表示非対象、または自動選択オプションである場合はスキップ
			If strHideRsvFra(i) <> "" Or strAddCondition(i) = "0" Then
				i = i + 1
				Exit Do
			End If

			'まず編集するエレメントを設定する(枝番数が１つならチェックボックス、さもなくばラジオボタン選択)
			strElementType = IIf(CLng(strBranchCount(i)) = 1, "checkbox", "radio")

			'オプション編集用のエレメント名を定義する
			lngOptGrpSeq   = lngOptGrpSeq + 1
			strElementName = "opt" & CStr(lngOptGrpSeq)

			'エレメントタイプごとの処理分岐
			Select Case strElementType

				Case "radio"	'ラジオボタンの場合

					'改行処理
					If lngHorizIndex > 0 Then
						AddShowHTMLArray "</TR>"
						lngHorizIndex = 0
					End If

					'編集開始
					AddShowHTMLArray "<TR>"

'## 2003.11.25 Add By T.Takagi@FSIT 任意受診のセットグループなら先頭をデフォルトで受診状態にする
					'現在のインデックスを退避する
					lngCurIndex = i

					'フラグ初期化
					blnExistsSet = False

					'同一オプションの検索
					strPrevOptCd = strArrOptCd(i)
					Do Until i >= lngCount

						'直前レコードとオプションコードが異なる場合は終了
						If strArrOptCd(i) <> strPrevOptCd Then
							Exit Do
						End If

						'チェック対象となるセットの有無を判定し、あれば終了
						If IsConsults(strNewCtrPtCd, strArrOptCd(i), strArrOptBranchNo(i)) Then
							blnExistsSet = True
							Exit Do
						End If

						'現レコードのオプションコードを退避
						strPrevOptCd = strArrOptCd(i)
						i = i + 1
					Loop

					'編集に際し、退避していたインデックスを戻す
					i = lngCurIndex

					'フラグ初期化
					blnEdited = False
'## 2003.11.25 Add End

					'同一オプションを横方向に編集
					strPrevOptCd = strArrOptCd(i)
					Do Until i >= lngCount

						'直前レコードとオプションコードが異なる場合は終了
						If strArrOptCd(i) <> strPrevOptCd Then
							Exit Do
						End If

						'チェック対象かを判定
'## 2003.11.25 Mod By T.Takagi@FSIT 任意受診のセットグループなら先頭をデフォルトで受診状態にする
'						strChecked = IIf(IsConsults(strNewCtrPtCd, strArrOptCd(i), strArrOptBranchNo(i)), " CHECKED", "")

						'チェック対象となるセットが存在するならその内容に準拠
						If blnExistsSet Then
							strChecked = IIf(IsConsults(strNewCtrPtCd, strArrOptCd(i), strArrOptBranchNo(i)), " CHECKED", "")

						'存在しないなら先頭セットのみ受診状態にさせる
						Else

							strChecked = IIf(Not blnEdited, " CHECKED", "")
							blnEdited = True

						End If
'## 2003.11.25 Mod End

						'オプションの編集
						AddShowHTMLArray "<TD><INPUT TYPE=""radio"" NAME=""" & strElementName & """ VALUE=""" & strArrOptCd(i) & "," & strArrOptBranchNo(i) & """" & strChecked & "></TD>"
						AddShowHTMLArray "<TD NOWRAP><FONT COLOR=""" & strSetColor(i) & """>■</FONT><A HREF=""javascript:callSetInfoWindow(\'" & strNewCtrPtCd & "\',\'" & strArrOptCd(i) & "\',\'" & strArrOptBranchNo(i) & "\')"">" & strOptSName(i) & "</A></TD>"

						'現レコードのオプションコードを退避
						strPrevOptCd = strArrOptCd(i)
						i = i + 1
					Loop

					'編集終了
					AddShowHTMLArray "</TR>"

				Case "checkbox"	'チェックボックスの場合

					'改行処理
					If lngHorizIndex >= OPTCOUNT_PER_ROW Then
						AddShowHTMLArray "</TR>"
						lngHorizIndex = 0
					End If

					'列の先頭の場合
					If lngHorizIndex = 0 Then
						AddShowHTMLArray "<TR>"
					End If

					'チェック対象かを判定
					strChecked = IIf(IsConsults(strNewCtrPtCd, strArrOptCd(i), strArrOptBranchNo(i)), " CHECKED", "")

					'オプションの編集
					AddShowHTMLArray "<TD><INPUT TYPE=""checkbox"" NAME=""" & strElementName & """ VALUE=""" & strArrOptCd(i) & "," & strArrOptBranchNo(i) & """" & strChecked & "></TD>"
					AddShowHTMLArray "<TD NOWRAP><FONT COLOR=""" & strSetColor(i) & """>■</FONT><A HREF=""javascript:callSetInfoWindow(\'" & strNewCtrPtCd & "\',\'" & strArrOptCd(i) & "\',\'" & strArrOptBranchNo(i) & "\')"">" & strOptSName(i) & "</A></TD>"

					lngHorizIndex = lngHorizIndex + 1
					i = i + 1

			End Select

			Exit Do
		Loop

	Loop

	'列の編集途中の場合
	If lngHorizIndex > 0 Then
		AddShowHTMLArray "</TR>"
	End If
%>
	var html = '<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">';
	html = html + '<TR>';
	html = html + '<TD VALIGN="top">';
	html = html + '<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">';
	html = html + '<TR>';
	html = html + '<TD NOWRAP>セット：</TD>';
	html = html + '</TR>';
	html = html + '</TABLE>';
	html = html + '</TD>';
	html = html + '<TD NOWRAP>';
<%
	'表示用オプションが存在する場合
	If lngShowCount > 0 Then

		'表示用オプションの編集
%>
		html = html + '<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">';
<%
		For i = 0 To lngShowCount - 1
%>
			html = html + '<%= strShowHTML(i) %>';
<%
		Next
%>
		html = html + '</TABLE>';
<%
	Else
%>
		html = html + 'なし';
<%
	End If
%>
	html = html + '</TD>';
	html = html + '</TR>';
	html = html + '</TABLE>';

	top.editSet( <%= lngCondIndex %>, html );
<%
	Exit Do
Loop
%>
top.editAnchor( <%= lngCondIndex %> );
//-->
</SCRIPT>
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 年齢が０以上の整数かをチェック
'
' 引数　　 : (In)     strAge  年齢
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckAge(strAge)

	Dim i	'インデックス

	If Trim(strAge) = "" Then
		Exit Function
	End If

	'すべての文字列が数字であるかをチェック
	For i = 1 To Len(Trim(strAge))
		If InStr("0123456789", Mid(strAge, i, 1)) <= 0 Then
			Exit Function
		End If
	Next

	CheckAge = True

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 表示オプション用HTML文字列追加
'
' 引数　　 : (In)     strHTML  HTML文字列
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub AddShowHTMLArray(strHTML)

	ReDim Preserve strShowHTML(lngShowCount)
	strShowHTML(lngShowCount) = strHTML
	lngShowCount = lngShowCount + 1

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 非表示オプション用HTML文字列追加
'
' 引数　　 : (In)     strHTML  HTML文字列
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub AddHiddenHTMLArray(strHTML)

	ReDim Preserve strHiddenHTML(lngHiddenCount)
	strHiddenHTML(lngHiddenCount) = strHTML
	lngHiddenCount = lngHiddenCount + 1

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 受診対象かをチェック
'
' 引数　　 : (In)     strCheckCtrPtCd      契約パターンコード
' 　　　　   (In)     strCheckOptCd        オプションコード
' 　　　　   (In)     strCheckOptBranchNo  オプション枝番
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function IsConsults(strCheckCtrPtCd, strCheckOptCd, strCheckOptBranchNo)

	Dim Ret	'関数戻り値
	Dim i	'インデックス

	Do

		Ret = False

		'契約パターン自体が異なれば非対象
		If strCheckCtrPtCd <> strCtrPtCd Then
			Exit Do
		End If

		'チェック対象となるオプションが存在しない場合は非対象
		If Not IsArray(strOptCd) Then
			Exit Do
		End If

		'引数指定されたオプションが存在するかを検索
		For i = 0 To UBound(strOptCd)
			If strOptCd(i) = strCheckOptCd And strOptBranchNo(i) = strCheckOptBranchNo Then
				Ret = True
				Exit Do
			End If
		Next

		Exit Do
	Loop

	IsConsults = Ret

End Function
%>
