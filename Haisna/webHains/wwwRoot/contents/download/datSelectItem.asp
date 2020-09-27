<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		汎用情報の抽出　入力制御 (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/download.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objItem				'項目ガイドアクセス用COMオブジェクト
Dim objOrganization		'団体テーブルアクセス用COMオブジェクト
Dim objConsult			'受診情報アクセス用COMオブジェクト
Dim objCSVConsult			'受診情報アクセス用COMオブジェクト
'各ステップで汎用的に使用する引数
Dim mstrStep			'現ページへのステップ

'Step1からの引数
'抽出項目(受診歴情報)
Dim mstrChkDate			'受診日
Dim mstrChkCsCd			'コース
Dim mstrChkOrgCd		'受診団体
'## 2003/5/30 ADD Start NSC(ITO
Dim mstrChkOrgBsdCd		'受診事業所
Dim mstrChkOrgRoomCd    '受診室部
Dim mstrChkOrgPostCd	'受診所属
'## 2003/5/30 ADD End 
Dim mstrChkAge			'受診時年齢
Dim mstrChkJud			'総合判定
'抽出項目(個人情報)
Dim mstrChkPerID		'個人ID
Dim mstrChkName			'氏名
Dim mstrChkBirth		'生年月日
Dim mstrChkGender		'性別
'## 2003/5/30 ADD Start NSC(ITO
Dim mstrChkEmpNo		'従業員番号
Dim mstrChkPOrgCd		'受診団体
Dim mstrChkPOrgBsdCd	'事業所
Dim mstrChkPOrgRoomCd   '室部
Dim mstrChkPOrgPostCd	'所属
Dim mstrChkOverTime  	'超過勤務時間
'## 2003/5/30 ADD End 
'抽出項目(検査結果)
Dim mstrOptResult		'検査結果抽出条件
Dim mlngRowCount		'表示項目数
Dim mstrArrSelItemCd	'検査項目コードの配列
Dim mstrArrSelSuffix	'検査項目サフィックスの配列
Dim mstrChkOption		'結果コメント・正常値フラグ

'Step2からの引数
'受診歴条件
Dim mstrStrDate			'受診年月日(自)
Dim mlngStrYear			'受診年(自)
Dim mlngStrMonth		'受診月(自)
Dim mlngStrDay			'受診日(自)
Dim mstrEndDate			'受診年月日(至)
Dim mlngEndYear			'受診年(至)
Dim mlngEndMonth		'受診月(至)
Dim mlngEndDay			'受診日(至)
Dim mstrCsCd			'コースコード
Dim mstrSubCsCd			'サブコースコード
Dim mstrOrgCd1			'団体コード１
Dim mstrOrgCd2			'団体コード２
Dim mstrOrgBsdCd		'事業所コード
Dim mstrOrgRoomCd		'室部コード
Dim mstrOrgPostCd1		'所属コード
Dim mstrOrgPostCd2		'所属コード

Dim mstrStrAge			'受診時(自)年齢
Dim mstrStrAgeY			'受診時(自)年齢(年)
Dim mstrStrAgeM			'受診時(自)年齢(月)
Dim mstrEndAge			'受診時(至)年齢
Dim mstrEndAgeY			'受診時(至)年齢(年)
Dim mstrEndAgeM			'受診時(至)年齢(月)
Dim mlngGender			'性別
'検査項目条件
Dim mlngRowCountItem	'表示検査項目数
Dim mstrArrItemCd		'検査項目コードの配列
Dim mstrArrSuffix		'検査項目サフィックスの配列
Dim mstrArrRslValueFrom	'検査結果(FROM側)の配列
Dim mstrArrRslMarkFrom	'検査結果(FROM側)範囲指定の配列
Dim mstrArrRslValueTo	'検査結果(TO側)の配列
Dim mstrArrRslMarkTo	'検査結果(TO側)範囲指定の配列
'総合判定条件
Dim mlngRowCountJud		'表示総合判定数
Dim mstrArrJudClassCd	'判定分類コードの配列
Dim mstrArrJudValueFrom	'判定コード(FROM側)の配列
Dim mstrArrJudMarkFrom	'判定コード(FROM側)範囲指定の配列
Dim mstrArrJudValueTo	'判定コード(TO側)の配列
Dim mstrArrJudMarkTo	'判定コード(TO側)範囲指定の配列

'## 2002.6.5 Add 1Line by T.Takagi@FSIT 演算子指定対応
Dim mlngJudOperation	'総合判定条件指定演算子(0:AND、1:OR)
'## 2002.6.5 Add End
'## 2002.6.13 Add 1Line by T.Takagi@FSIT 判定抽出選択機能
Dim mlngJudAll			'判定抽出方法(0:すべて、1:指定判定分類のみ)
'## 2002.6.13 Add End

'抽出状態
Dim mstrEdit			'抽出ボタン押下時"on"

'データ抽出用条件フラグ
Dim mstrArrRslCondition	'検査結果条件配列(条件未指定時:""、指定時は結果タイプ)
Dim mlngArrWeightFrom	'判定用重み配列(FROM側)
Dim mlngArrWeightTo		'判定用重み配列(TO側)
Dim mstrArrJudCondition	'総合判定条件配列(条件未指定時:""、指定時は"CHECK")

'全ステップ共通の作業用変数
Dim strArrMessage		'エラーメッセージ
Dim mstrTempFile		'作業用CSVファイル名
Dim mstrFileName		'出力CSVファイル名
Dim mstrDownloadFile	'ダウンロードファイル名
Dim mlngCount			'出力データ件数
Dim i, j, k				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'CSVファイル格納パス設定
mstrDownloadFile = CSV_DATAPATH & CSV_CONSULT						'ダウンロードファイル名セット
mstrFileName     = Server.MapPath(mstrDownloadFile)					'CSVファイル名セット
mstrTempFile     = Server.MapPath(CSV_DATAPATH & CSV_CONSULTTMP)	'作業用ファイル名セット

'@@@@@@@@@@@@@@
'Response.Write "  mstrFileName = " & mstrFileName
'Response.Write "  mstrTempFile = " & mstrTempFile
'@@@@@@@@@@@@@@


'オブジェクトのインスタンス作成
Set objItem         = Server.CreateObject("HainsItem.Item")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objCSVConsult      = Server.CreateObject("HainsCSVConsult.CSVConsult")
'どのステップから呼ばれたかを求める
mstrStep = Request("step")

'Step1で設定された引数値の取得
mstrChkDate       = Request("chkDate"  )
mstrChkCsCd       = Request("chkCsCd"  )
mstrChkOrgCd      = Request("chkOrgCd" )
'## 2003/5/30 ADD Start NSC(ITO
mstrChkOrgBsdCd   = Request("chkOrgBsdCd" )
mstrChkOrgRoomCd  = Request("chkOrgRoomCd" )
mstrChkOrgPostCd  = Request("chkOrgPostCd" )
'## 2003/5/30 ADD End
mstrChkAge        = Request("chkAge"   )
mstrChkJud        = Request("chkJud"   )
mstrChkPerID      = Request("chkPerID" )
mstrChkName       = Request("chkName"  )
mstrChkBirth      = Request("chkBirth" )
mstrChkGender     = Request("chkGender")
'## 2003/5/30 ADD Start NSC(ITO
mstrChkEmpNo      = Request("chkEmpNo" )
mstrChkPOrgCd     = Request("chkPOrgCd" )
mstrChkPOrgBsdCd  = Request("chkPOrgBsdCd" )
mstrChkPOrgRoomCd = Request("chkPOrgRoomCd" )
mstrChkPOrgPostCd = Request("chkPOrgPostCd" )
mstrChkOverTime   = Request("chkOverTime" )
'## 2003/5/30 ADD End
mstrOptResult     = IIf(IsEmpty(Request("optResult")), CASE_NOTSELECT, Request("optResult"))
mlngRowCount      = IIf(IsEmpty(Request("rowCount" )), ROWCOUNT_ITEM,  CLng(Request("rowCount")))
mstrArrSelItemCd  = ConvIStringToArray(Request("selItemCd"))
mstrArrSelSuffix  = ConvIStringToArray(Request("selSuffix"))
mstrChkOption     = Request("chkOption")

'@@@@@@@@@@@@@@
'Response.Write "  mstrChkOrgBsdCd = " & mstrChkOrgBsdCd
'Response.Write "  mstrChkOrgRoomCd = " & mstrChkOrgRoomCd
'Response.Write "  mstrChkOrgPostCd = " & mstrChkOrgPostCd
'@@@@@@@@@@@@@@

'表示件数変更の処理
If IsArray(mstrArrSelItemCd) Then
	ReDim Preserve mstrArrSelItemCd(mlngRowCount - 1)
	ReDim Preserve mstrArrSelSuffix(mlngRowCount - 1)
Else
	ReDim mstrArrSelItemCd(mlngRowCount - 1)
	ReDim mstrArrSelSuffix(mlngRowCount - 1)
End If

'Step2で設定された引数値の取得
mlngStrYear  = CLng("0" & Request("strYear" ))
mlngStrMonth = CLng("0" & Request("strMonth"))
mlngStrDay   = CLng("0" & Request("strDay"  ))
mlngEndYear  = CLng("0" & Request("endYear" ))
mlngEndMonth = CLng("0" & Request("endMonth"))
mlngEndDay   = CLng("0" & Request("endDay"  ))
mstrCsCd     = Request("csCd"    )
mstrSubCsCd  = Request("SubcsCd"    )
mstrOrgCd1   = Request("orgCd1"  )
mstrOrgCd2   = Request("orgCd2"  )
mstrOrgBsdCd   = Request("orgBsdCd"  )
mstrOrgRoomCd  = Request("orgRoomCd"  )
mstrOrgPostCd1 = Request("orgPostCd1"  )
mstrOrgPostCd2 = Request("orgPostCd2"  )

mstrStrAgeY  = IIf(IsEmpty(Request("strAgeY")),   "0", Request("strAgeY"))
mstrStrAgeM  = Request("strAgeM" )
mstrEndAgeY  = IIf(IsEmpty(Request("endAgeY")), "150", Request("endAgeY"))
mstrEndAgeM  = Request("endAgeM" )
mlngGender   = IIf(IsEmpty(Request("gender")), GENDER_BOTH, Request("gender"))

'## 2002.6.5 Add 1Line by T.Takagi@FSIT 演算子指定対応
mlngJudOperation = CLng("0" & Request("judOperation"))
'## 2002.6.5 Add End
'## 2002.6.13 Add 1Line by T.Takagi@FSIT 判定抽出選択機能
mlngJudAll = CLng("0" & Request("judAll"))
'## 2002.6.13 Add End

mlngRowCountItem    = IIf(IsEmpty(Request("rowCountItem")), ROWCOUNT_ITEM, CLng(Request("rowCountItem")))
mstrArrItemCd       = ConvIStringToArray(Request("itemCd"))
mstrArrSuffix       = ConvIStringToArray(Request("suffix"))
'表示件数変更の処理(検査項目)
If IsArray(mstrArrItemCd) Then
	ReDim Preserve mstrArrItemCd(mlngRowCountItem - 1)
	ReDim Preserve mstrArrSuffix(mlngRowCountItem - 1)
Else
	ReDim mstrArrItemCd(mlngRowCountItem - 1)
	ReDim mstrArrSuffix(mlngRowCountItem - 1)
End If

mstrArrRslValueFrom = ConvIStringToArray(Request("rslValueFrom"))
mstrArrRslMarkFrom  = ConvIStringToArray(Request("rslSignFrom" ))
mstrArrRslValueTo   = ConvIStringToArray(Request("rslValueTo"  ))
mstrArrRslMarkTo    = ConvIStringToArray(Request("rslSignTo"   ))
'表示件数変更の処理(検査結果)
If IsArray(mstrArrRslValueFrom) Then
	ReDim Preserve mstrArrRslValueFrom(mlngRowCountItem - 1)
	ReDim Preserve mstrArrRslMarkFrom(mlngRowCountItem - 1)
	ReDim Preserve mstrArrRslValueTo(mlngRowCountItem - 1)
	ReDim Preserve mstrArrRslMarkTo(mlngRowCountItem - 1)
Else
	ReDim mstrArrRslValueFrom(mlngRowCountItem - 1)
	ReDim mstrArrRslMarkFrom(mlngRowCountItem - 1)
	ReDim mstrArrRslValueTo(mlngRowCountItem - 1)
	ReDim mstrArrRslMarkTo(mlngRowCountItem - 1)
End If

mlngRowCountJud     = IIf(IsEmpty(Request("rowCountJud")), ROWCOUNT_JUDCLASS, CLng(Request("rowCountJud")))
mstrArrJudClassCd   = ConvIStringToArray(Request("judClass"    ))
mstrArrJudValueFrom = ConvIStringToArray(Request("judValueFrom"))
mstrArrJudMarkFrom  = ConvIStringToArray(Request("judSignFrom" ))
mstrArrJudValueTo   = ConvIStringToArray(Request("judValueTo"  ))
mstrArrJudMarkTo    = ConvIStringToArray(Request("judSignTo"   ))
'表示件数変更の処理(総合判定)
If IsArray(mstrArrJudClassCd) Then
	ReDim Preserve mstrArrJudClassCd(mlngRowCountJud - 1)
	ReDim Preserve mstrArrJudValueFrom(mlngRowCountJud - 1)
	ReDim Preserve mstrArrJudMarkFrom(mlngRowCountJud - 1)
	ReDim Preserve mstrArrJudValueTo(mlngRowCountJud - 1)
	ReDim Preserve mstrArrJudMarkTo(mlngRowCountJud - 1)
Else
	ReDim mstrArrJudClassCd(mlngRowCountJud - 1)
	ReDim mstrArrJudValueFrom(mlngRowCountJud - 1)
	ReDim mstrArrJudMarkFrom(mlngRowCountJud - 1)
	ReDim mstrArrJudValueTo(mlngRowCountJud - 1)
	ReDim mstrArrJudMarkTo(mlngRowCountJud - 1)
End If

mstrEdit = Request("edit")

'チェック処理の制御
Do

	'各ステップごとのチェック・更新処理制御
	Select Case mstrStep
		'抽出項目指定
		Case "1"

			'「次へ」ボタンが押されていない場合は処理を抜ける
			If IsEmpty(Request("step2")) Then
				Exit Do
			End If

			'入力チェック
'			strArrMessage = objConsult.CheckValueDatSelect(mstrChkDate,   mstrChkCsCd, _
'														   mstrChkOrgCd,  mstrChkAge, _
'														   mstrChkJud,    mstrChkPerID, _
'														   mstrChkName,   mstrChkBirth, _
'														   mstrChkGender, mstrOptResult, _
'														   mstrArrSelItemCd _
'														  )
			strArrMessage = objConsult.CheckValueDatSelect(mstrChkDate,   mstrChkCsCd, _
														   mstrChkOrgCd,  mstrChkAge, _
														   mstrChkJud,    mstrChkPerID, _
														   mstrChkName,   mstrChkBirth, _
														   mstrChkGender, mstrOptResult, _
														   mstrArrSelItemCd, _
														   mstrChkOrgBsdCd, mstrChkOrgRoomCd, _
														   mstrChkOrgPostCd, mstrChkEmpNo, _ 
														   mstrChkPOrgCd, mstrChkPOrgBsdCd, _
														   mstrChkPOrgRoomCd, mstrChkPOrgPostCd, _
														   mstrChkOverTime  _
														  )

			'チェックエラー時は処理を抜ける
			If Not IsEmpty(strArrMessage) Then
				Exit Do
			End if

			'次画面へ遷移
			mstrStep = "2"
			Exit Do

		'抽出条件指定
		Case "2"

			'「抽出」ボタンが押されていない場合は処理を抜ける
			If mstrEdit <> "on" Then
				Exit Do
			End If

'## 2003.5.30 Add Start  NSC(ITOH
			'所属１が指定ありで所属２が未指定の場合、所属１を２に設定
			If mstrOrgPostCd1 <> "" And _
			   mstrOrgPostCd2 = "" Then
				mstrOrgPostCd2 = mstrOrgPostCd1
			End If
'## 2003.5.30 Add End

			'入力チェック
			strArrMessage = objConsult.CheckValueDatConsult(mlngStrYear, mlngStrMonth, mlngStrDay, _
															mlngEndYear, mlngEndMonth, mlngEndDay, _
															mstrStrAgeY, mstrStrAgeM,  mstrEndAgeY, mstrEndAgeM, _
															mstrArrItemCd,       mstrArrSuffix, _
															mstrArrRslValueFrom, mstrArrRslMarkFrom, _
															mstrArrRslValueTo,   mstrArrRslMarkTo, _
															mstrArrJudClassCd, _
															mstrArrJudValueFrom, mstrArrJudMarkFrom, _
															mstrArrJudValueTo,   mstrArrJudMarkTo, _
															mstrStrDate,         mstrEndDate, _
															mstrStrAge,          mstrEndAge, _
															mstrArrRslCondition, _
															mlngArrWeightFrom,   mlngArrWeightTo, _
															mstrArrJudCondition _
														   )

			'チェックエラー時は処理を抜ける
			If Not IsEmpty(strArrMessage) Then
				Exit Do
			End if

			'CSVファイルを編集
'## 2002.6.5 Modify 26Lines by T.Takagi@FSIT 演算子指定対応
'			mlngCount = objConsult.EditCSVDatConsult(mstrFileName,  mstrTempFile, _
'									mstrChkDate,   mstrChkCsCd,   mstrChkOrgCd,     mstrChkAge,       mstrChkJud, _
'									mstrChkPerID,  mstrChkName,   mstrChkBirth,     mstrChkGender, _
'									mstrOptResult, mstrChkOption, mstrArrSelItemCd, mstrArrSelSuffix, _
'									mstrStrDate, mstrEndDate, mstrCsCd,   mstrOrgCd1,    mstrOrgCd2, _
'									mstrStrAge,  mstrEndAge,  mlngGender, mstrArrItemCd, mstrArrSuffix, _
'									mstrArrRslValueFrom, mstrArrRslMarkFrom, _
'									mstrArrRslValueTo,   mstrArrRslMarkTo, _
'									mstrArrRslCondition, mstrArrJudClassCd, _
'									mlngArrWeightFrom,   mstrArrJudMarkFrom, _
'									mlngArrWeightTo,     mstrArrJudMarkTo, _
'									mstrArrJudCondition _
'						)
'## 2002.6.13 Modify 26Lines by T.Takagi@FSIT 判定抽出選択機能
'			mlngCount = objConsult.EditCSVDatConsult(mstrFileName,  mstrTempFile, _
'									mstrChkDate,   mstrChkCsCd,   mstrChkOrgCd,     mstrChkAge,       mstrChkJud, _
'									mstrChkPerID,  mstrChkName,   mstrChkBirth,     mstrChkGender, _
'									mstrOptResult, mstrChkOption, mstrArrSelItemCd, mstrArrSelSuffix, _
'									mstrStrDate, mstrEndDate, mstrCsCd,   mstrOrgCd1,    mstrOrgCd2, _
'									mstrStrAge,  mstrEndAge,  mlngGender, mstrArrItemCd, mstrArrSuffix, _
'									mstrArrRslValueFrom, mstrArrRslMarkFrom, _
'									mstrArrRslValueTo,   mstrArrRslMarkTo, _
'									mstrArrRslCondition, mstrArrJudClassCd, _
'									mlngArrWeightFrom,   mstrArrJudMarkFrom, _
'									mlngArrWeightTo,     mstrArrJudMarkTo, _
'									mstrArrJudCondition, mlngJudOperation _
'						)
'## 2003.5.30 Modify Start NSC(ITO
'			mlngCount = objConsult.EditCSVDatConsult(mstrFileName,  mstrTempFile, _
'									mstrChkDate,   mstrChkCsCd,   mstrChkOrgCd,     mstrChkAge,       mstrChkJud, _
'									mstrChkPerID,  mstrChkName,   mstrChkBirth,     mstrChkGender, _
'									mstrOptResult, mstrChkOption, mstrArrSelItemCd, mstrArrSelSuffix, _
'									mstrStrDate, mstrEndDate, mstrCsCd,   mstrOrgCd1,    mstrOrgCd2, _
'									mstrStrAge,  mstrEndAge,  mlngGender, mstrArrItemCd, mstrArrSuffix, _
'									mstrArrRslValueFrom, mstrArrRslMarkFrom, _
'									mstrArrRslValueTo,   mstrArrRslMarkTo, _
'									mstrArrRslCondition, mstrArrJudClassCd, _
'									mlngArrWeightFrom,   mstrArrJudMarkFrom, _
'									mlngArrWeightTo,     mstrArrJudMarkTo, _
'									mstrArrJudCondition, mlngJudOperation, mlngJudAll _
'						)
''## 2002.6.13 Modify End
''## 2002.6.5 Modify End
			mlngCount = objConsult.EditCSVDatConsult(mstrFileName,  mstrTempFile, _
									mstrChkDate,   mstrChkCsCd,   mstrChkOrgCd,     mstrChkAge,       mstrChkJud, _
									mstrChkOrgBsdCd,  mstrChkOrgRoomCd, mstrChkOrgPostCd, _ 
									mstrChkPerID,  mstrChkName,   mstrChkBirth,    mstrChkGender, _
									mstrChkEmpNo,   mstrChkPOrgCd,   mstrChkPOrgBsdCd,  mstrChkPOrgRoomCd,  _
									mstrChkPOrgPostCd,   mstrChkOverTime, _
									mstrOptResult, mstrChkOption, mstrArrSelItemCd, mstrArrSelSuffix, _
									mstrStrDate, mstrEndDate, mstrCsCd,   mstrOrgCd1,    mstrOrgCd2, _
									mstrOrgBsdCd, mstrOrgRoomCd, mstrOrgPostCd1, mstrOrgPostCd2, mstrSubCsCd, _
									mstrStrAge,  mstrEndAge,  mlngGender, mstrArrItemCd, mstrArrSuffix, _
									mstrArrRslValueFrom, mstrArrRslMarkFrom, _
									mstrArrRslValueTo,   mstrArrRslMarkTo, _
									mstrArrRslCondition, mstrArrJudClassCd, _
									mlngArrWeightFrom,   mstrArrJudMarkFrom, _
									mlngArrWeightTo,     mstrArrJudMarkTo, _
									mstrArrJudCondition, mlngJudOperation, mlngJudAll _
						)
'## 2003.5.30 Modify End NSC(ITO

			'データがあればダウンロード
			If mlngCount > 0 Then
				Response.Redirect mstrDownloadFile
				Response.End
			End If
			Exit Do

	End Select

	Exit Do
Loop

'各ステップ値ごとの表示ASP制御
Select Case mstrStep

	'抽出項目指定
	Case "1"
%>
		<!-- #include virtual = "/webHains/contents/download/datSelectItemStep1.asp" -->
<%
	'抽出条件指定
	Case "2"
%>
		<!-- #include virtual = "/webHains/contents/download/datSelectItemStep2.asp" -->
<%
End Select
%>
