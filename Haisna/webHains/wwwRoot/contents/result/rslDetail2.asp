<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		結果入力２【グループ指定版】(詳細画面) (Ver0.0.1)
'		AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const ACTMODE_SAVE     = "save"		'動作モード(保存)
Const ACTMODE_CHANGE   = "change"	'動作モード(グループ変更)
Const ACTMODE_SAVEEND  = "saveend"	'動作モード(保存完了)
Const DISPMODE_DETAIL  = "detail"	'表示モード(文章表示)
Const DISPMODE_SIMPLE  = "simple"	'表示モード(略式表示)
Const DISPMODE_DELETE  = "delete"	'表示モード(端末通過情報削除)

Const STDFLG_H = "H"		'異常（上）
Const STDFLG_U = "U"		'軽度異常（上）
Const STDFLG_D = "D"		'軽度異常（下）
Const STDFLG_L = "L"		'異常（下）
Const STDFLG_T1 = "*"		'定性値異常
Const STDFLG_T2 = "@"		'定性値軽度異常

'データベースアクセス用オブジェクト
Dim objCommon		'共通クラス
Dim objConsult		'受診情報アクセス用
Dim objGrp			'グループアクセス用
Dim objResult		'検査結果アクセス用
Dim objFree			'汎用情報アクセス用

'前画面から送信されるパラメータ値
Dim strActMode		'動作モード
Dim strDispMode		'表示状態(文章表示時:"1"、文章非表示時:"2")
Dim strRsvNo		'予約番号
Dim strCode			'入力対象コード（★ここに検査項目グループコードを指定する）
Dim strKeyCslYear	'(受付情報の)受診日(年)
Dim strKeyCslMonth	'(受付情報の)受診日(月)
Dim strKeyCslDay	'(受付情報の)受診日(日)
Dim strKeyCntlNo	'管理番号
Dim strKeyCsCd		'コースコード
Dim strKeyDayId		'当日ID
Dim strIPAddress	'IPAddress

'受診情報
Dim strPerId		'個人ID
Dim strCslDate		'受診日
Dim strCsCd			'コースコード
Dim strCsName		'コース名
Dim strLastName		'姓
Dim strFirstName	'名
Dim strLastKName	'カナ姓
Dim strFirstKName	'カナ名
Dim strBirth		'生年月日
Dim strAge			'年齢
Dim strGender		'性別
Dim strGenderName	'性別名称

'検査結果情報
Dim strConsultFlg	'受診項目フラグ
Dim strItemCd		'検査項目コード
Dim strSuffix		'サフィックス
Dim strItemName		'検査項目名称
Dim strResult		'検査結果
Dim strResultType	'結果タイプ
Dim strItemType		'項目タイプ
Dim strStcItemCd	'文章参照用項目コード
Dim strResultErr	'検査結果エラー
Dim strShortStc		'文章略称
Dim strRslCmtCd1	'結果コメントコード１
Dim strRslCmtErr1	'結果コメントエラー１
Dim strRslCmtName1	'結果コメント名称１
Dim strRslCmtCd2	'結果コメントコード２
Dim strRslCmtErr2	'結果コメントエラー２
Dim strRslCmtName2	'結果コメント名称２
Dim strRet			'検査項目エラー
Dim strBefResult	'前回検査結果
Dim strBefShortStc	'前回文章略称
Dim strDefResult	'省略時検査結果
Dim strDefShortStc	'省略時文章略称
Dim strDefRslCmtCd		'省略時結果コメントコード
Dim strDefRslCmtName	'省略時結果コメント名称
Dim strLastRsvNo	'前回予約番号
Dim strStdFlg		'基準値フラグ
Dim lngCount		'レコード件数
Dim lngUpdItemCount	'更新可能項目数

Dim strInitRsl		'初期読み込み状態の結果
Dim strInitRslCmt1	'初期読み込み状態の結果コメント１
Dim strInitRslCmt2	'初期読み込み状態の結果コメント２
Dim blnUpdated		'TRUE:変更あり、FALSE:変更なし

'実際に更新する項目情報を格納した検査結果
Dim strUpdIndex			'インデックス
Dim strUpdItemCd		'検査項目コード
Dim strUpdSuffix		'サフィックス
Dim strUpdResult		'検査結果
Dim strUpdShortStc		'文章略称
Dim strUpdResultErr		'検査結果エラー
Dim strUpdRslCmtCd1		'結果コメントコード１
Dim strUpdRslCmtName1	'結果コメント名称１
Dim strUpdRslCmtErr1	'結果コメントエラー１
Dim strUpdRslCmtCd2		'結果コメントコード２
Dim strUpdRslCmtName2	'結果コメント名称２
Dim strUpdRslCmtErr2	'結果コメントエラー２
Dim lngUpdCount			'更新項目数

'入力方向
Dim strOrientation	'入力方向（縦、横）
Dim strPortrait		'縦
Dim strLandscape	'横

Dim lngAllCount		'条件を満たす全レコード件数

Dim strElementName	'エレメント名

Dim lngMargin		'マージン値
Dim strSeq			'表示行位置
Dim dtmCslDate		'(受付情報の)受診日
Dim strPrevRsvNo	'(前受診者の)予約番号
Dim strPrevDayId	'(前受診者の)当日ID
Dim strNextRsvNo	'(次受診者の)予約番号
Dim strNextDayId	'(次受診者の)当日ID
Dim strCodeName		'コードに対する名称
Dim strArrMessage	'エラーメッセージ
Dim strHTML			'HTML文字列
Dim strURL			'URL文字列
Dim Ret				'関数戻り値
Dim i, j			'インデックス

'端末管理情報
Dim strWkstnName		'端末名
Dim strWkstnGrpCd		'グループコード
Dim strWkstnGrpName		'グループ名

'表示色
Dim strH_Color		'基準値フラグ色（Ｈ）
Dim strU_Color		'基準値フラグ色（Ｕ）
Dim strD_Color		'基準値フラグ色（Ｄ）
Dim strL_Color		'基準値フラグ色（Ｌ）
Dim strT1_Color		'基準値フラグ色（＊）
Dim strT2_Color		'基準値フラグ色（＠）

Dim dtmDate			'受診日
Dim strUpdUser		'更新者

'## 2004.01.09 Add By T.Takagi@FSIT 来院関連追加
Dim strComeDate			'来院日時
Dim Ret2				'関数戻り値
'## 2004.01.09 Add End

'## 2004.02.12 Add By H.Ishihara@FSIT 未受付状態でも結果入力できるモード追加（希望医師入力）
Dim strNoReceiptMode
'## 2004.02.12 Add End

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon      = Server.CreateObject("HainsCommon.Common")
Set objConsult     = Server.CreateObject("HainsConsult.Consult")
Set objGrp         = Server.CreateObject("HainsGrp.Grp")
Set objResult      = Server.CreateObject("HainsResult.Result")

'更新者の設定
strUpdUser = Session("USERID")

'引数値の取得
strActMode     = Request("actMode")
strDispMode    = Request("dispMode")
strRsvNo       = Request("rsvNo")
strCode        = Request("code")
strKeyCslYear  = Request("cslYear")
strKeyCslMonth = Request("cslMonth")
strKeyCslDay   = Request("cslDay")
strKeyCntlNo   = Request("cntlNo")
strKeyCsCd     = Request("csCd")
strKeyDayId    = Request("dayId")

'## 2004.02.12 Add By H.Ishihara@FSIT 未受付状態でも結果入力できるモード追加（希望医師入力）
strNoReceiptMode = Trim(Request("NoReceipt"))
'## 2004.02.12 Add End

'IPアドレスの取得
strIPAddress = Request.ServerVariables("REMOTE_ADDR")

'表示モードのデフォルト値は「文章表示」とする
strDispMode = IIf(strDispMode = "", DISPMODE_DETAIL, strDispMode)

'基準値フラグ色取得
objCommon.SelectStdFlgColor "H_COLOR", strH_Color
objCommon.SelectStdFlgColor "U_COLOR", strU_Color
objCommon.SelectStdFlgColor "D_COLOR", strD_Color
objCommon.SelectStdFlgColor "L_COLOR", strL_Color
objCommon.SelectStdFlgColor "*_COLOR", strT1_Color
objCommon.SelectStdFlgColor "@_COLOR", strT2_Color

'検査結果情報
strConsultFlg    = ConvIStringToArray(Request("cFlg"))
strItemCd        = ConvIStringToArray(Request("itemCd"))
strSuffix        = ConvIStringToArray(Request("suffix"))
strItemName      = ConvIStringToArray(Request("itemName"))
strResult        = ConvIStringToArray(Request("result"))
strResultErr     = ConvIStringToArray(Request("resultErr"))
strResultType    = ConvIStringToArray(Request("resultType"))
strItemType      = ConvIStringToArray(Request("itemType"))
strStcItemCd     = ConvIStringToArray(Request("stcItemCd"))
strShortStc      = ConvIStringToArray(Request("shortStc"))
strRslCmtCd1     = ConvIStringToArray(Request("rslCmtCd1"))
strRslCmtErr1    = ConvIStringToArray(Request("rslCmtErr1"))
strRslCmtName1   = ConvIStringToArray(Request("rcNm1"))
strRslCmtCd2     = ConvIStringToArray(Request("rslCmtCd2"))
strRslCmtErr2    = ConvIStringToArray(Request("rslCmtErr2"))
strRslCmtName2   = ConvIStringToArray(Request("rcNm2"))
strBefResult     = ConvIStringToArray(Request("befResult"))
strBefShortStc   = ConvIStringToArray(Request("befStc"))
strStdFlg        = ConvIStringToArray(Request("stdFlg"))
strInitRsl       = ConvIStringToArray(Request("initRsl"))
strInitRslCmt1   = ConvIStringToArray(Request("initRslCmt1"))
strInitRslCmt2   = ConvIStringToArray(Request("initRslCmt2"))
strDefResult     = ConvIStringToArray(Request("defResult"))
strDefShortStc   = ConvIStringToArray(Request("defShortStc"))
strDefRslCmtCd   = ConvIStringToArray(Request("defRslCmtCd"))
strDefRslCmtName = ConvIStringToArray(Request("defRslCmtName"))
strLastRsvNo     = Request("lastRsvNo")

lngCount        = CLng("0" & Request("count"))
lngUpdItemCount = CLng("0" & Request("updItemCount"))

'入力定数
strPortrait  = ORIENTATION_PORTRAIT
strLandscape = ORIENTATION_LANDSCAPE

'カーソル方向取得
strOrientation = CLng(objCommon.SelectRslOrientation)
If Trim(strOrientation) = "" Then
	strOrientation = ORIENTATION_PORTRAIT		'縦
End If

'チェック・更新・読み込み処理の制御
Do

	Do
		'各モードごとの処理分岐
		Select Case strActMode

			'保存
			Case ACTMODE_SAVE

				lngUpdCount = 0
				strUpdIndex = Array()
				strUpdItemCd = Array()
				strUpdSuffix = Array()
				strUpdResult = Array()
				strUpdRslCmtCd1 = Array()
				strUpdRslCmtCd2 = Array()

				'実際に更新を行う項目のみを抽出(初期表示データと異なるデータが更新対象)
				For i = 0 To UBound(strConsultFlg)

					Do

						'受診項目でない場合は追加しない
						If strConsultFlg(i) <> CStr(CONSULT_ITEM_T) Then
							Exit Do
						End If

						'結果、結果コメントの何れも更新されていない場合は追加しない
						If strResult(i) = strInitRsl(i) And strRslCmtCd1(i) = strInitRslCmt1(i) And strRslCmtCd2(i) = strInitRslCmt2(i) Then
							Exit Do
						End If

						'更新項目を追加
						ReDim Preserve strUpdIndex(lngUpdCount)
						ReDim Preserve strUpdItemCd(lngUpdCount)
						ReDim Preserve strUpdSuffix(lngUpdCount)
						ReDim Preserve strUpdResult(lngUpdCount)
						ReDim Preserve strUpdRslCmtCd1(lngUpdCount)
						ReDim Preserve strUpdRslCmtCd2(lngUpdCount)
						strUpdIndex(lngUpdCount)     = i
						strUpdItemCd(lngUpdCount)    = strItemCd(i)
						strUpdSuffix(lngUpdCount)    = strSuffix(i)
						strUpdResult(lngUpdCount)    = strResult(i)
						strUpdRslCmtCd1(lngUpdCount) = strRslCmtCd1(i)
						strUpdRslCmtCd2(lngUpdCount) = strRslCmtCd2(i)
						lngUpdCount = lngUpdCount + 1

						Exit Do
					Loop

				Next

				'更新対象となる検査項目があれば
				If lngUpdCount > 0 Then

					'検査結果更新
					If objResult.UpdateResultForDetail(strRsvNo, strIPAddress, strUpdUser, strUpdItemCd, strUpdSuffix, strUpdResult, strUpdShortStc, strUpdResultErr, strUpdRslCmtCd1, strUpdRslCmtName1, strUpdRslCmtErr1, strUpdRslCmtCd2, strUpdRslCmtName2, strUpdRslCmtErr2, strArrMessage) = False Then

						'エラー時は文章表示モードに変更
						strDispMode = DISPMODE_DETAIL

						'チェック結果にて値を置き換える
						For i = 0 To lngUpdCount - 1
							strResult(strUpdIndex(i))      = strUpdResult(i)
							strShortStc(strUpdIndex(i))    = strUpdShortStc(i)
							strResultErr(strUpdIndex(i))   = strUpdResultErr(i)
							strRslCmtCd1(strUpdIndex(i))   = strUpdRslCmtCd1(i)
							strRslCmtName1(strUpdIndex(i)) = strUpdRslCmtName1(i)
							strRslCmtErr1(strUpdIndex(i))  = strUpdRslCmtErr1(i)
							strRslCmtCd2(strUpdIndex(i))   = strUpdRslCmtCd2(i)
							strRslCmtName2(strUpdIndex(i)) = strUpdRslCmtName2(i)
							strRslCmtErr2(strUpdIndex(i))  = strUpdRslCmtErr2(i)
						Next

						Exit Do
					End If

				End If

				'エラーがなければ親フレームREPLACE用のURLを編集
				strURL = "rslMain2.asp"
				strURL = strURL & "?actMode="    & ACTMODE_SAVEEND
				strURL = strURL & "&dispMode="   & strDispMode
				strURL = strURL & "&rsvNo="      & strRsvNo
				strURL = strURL & "&code="       & strCode
				strURL = strURL & "&cslYear="    & strKeyCslYear
				strURL = strURL & "&cslMonth="   & strKeyCslMonth
				strURL = strURL & "&cslDay="     & strKeyCslDay
				strURL = strURL & "&cntlNo="     & strKeyCntlNo
				strURL = strURL & "&csCd="       & strKeyCsCd
				strURL = strURL & "&dayId="      & strKeyDayId
'## 2004.02.12 Add By H.Ishihara@FSIT 未受付状態でも結果入力できるモード追加（希望医師入力）
				strURL = strURL & "&NoReceipt="  & strNoReceiptMode
'## 2004.02.12 Add End

				'親フレームのURLをREPLACEする
				strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
				strHTML = strHTML & "<BODY ONLOAD=""JavaScript:top.location.replace('" & strURL & "')"">"
				strHTML = strHTML & "</BODY>"
				strHTML = strHTML & "</HTML>"
				Response.Write strHTML
				Response.End

		End Select

		Exit Do
	Loop

	'当日IDが指定されている場合
	If strKeyDayId <> "" Then

		'受診日の取得
		dtmCslDate = CDate(strKeyCslYear & "/" & strKeyCslMonth & "/" & strKeyCslDay)

		'受付情報をもとに受診情報を読み込む
		Ret = objConsult.SelectConsultFromReceipt(dtmCslDate,               _
												  CLng("0" & strKeyCntlNo), _
												  CLng(strKeyDayId),        _
												  strRsvNo,                 _
												  strCslDate,               _
												  strPerID,                 _
												  strLastName,              _
												  strFirstName,             _
												  strLastKName,             _
												  strFirstKName,            _
												  strBirth,                 _
												  strGender,                _
												  strCsCd,                  _
												  strCsName,                _
												  strAge)

	'当日IDが指定されていない場合
	Else

		'受診情報検索
		Ret = objConsult.SelectConsult(strRsvNo, 0, strCslDate, strPerId, strCsCd, strCsName, , , , , , _
									   strAge, , , , , , , , , , , , , _
									   strKeyDayId, , , , , , , , , , , , , , , , , , _
									   strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGender)

		If Ret = True And IsDate(strCslDate) Then
			strKeyCslYear = Year(strCslDate)
			strKeyCslMonth = Month(strCslDate)
			strKeyCslDay = Day(strCslDate)
		End If
	End If

	'受診情報が存在しない場合はエラーとする
	If Ret = False Then
		Err.Raise 1000, , "受診情報が存在しません。"
	End If

'## 2004.02.12 Add By H.Ishihara@FSIT 未受付状態でも結果入力できるモード追加（希望医師入力）
	'未受付ノーチェックモードもしくは保存モード以外なら全てチェック
	If strNoReceiptMode <> "1" Then
'## 2004.02.12 Add End

'## 2004.01.09 Add By T.Takagi@FSIT 来院関連追加
		'受付情報及び来院状態を取得
		Ret2 = objConsult.SelectReceipt(strRsvNo, , , , strComeDate)
		If Ret2 = False Then
			Err.Raise 1000, , "この受診者は受付されていません。結果入力はできません。"
		End If
	
		'未来院の受診情報に対する結果入力は不可
		If strComeDate = "" Then
			Err.Raise 1000, , "この受診者はまだ未来院です。結果入力はできません。"
		End If
'## 2004.01.09 Add End

'## 2004.02.12 Add By H.Ishihara@FSIT 未受付状態でも結果入力できるモード追加（希望医師入力）
	End If
'## 2004.02.12 Add End

	'表示モード変更時はテーブルから読み込まない
	If strActMode = ACTMODE_CHANGE Then
		Exit Do
	End If

	'保存モードでチェックエラーが発生した場合はテーブルから読み込まない
	If strActMode = ACTMODE_SAVE And Not IsEmpty(strArrMessage) Then
		Exit Do
	End If

	'検索条件を満たしかつ指定開始位置、件数分のレコードを取得
	lngCount = objResult.SelectRslList( _
				   "", strRsvNo, strCode, lngUpdItemCount, strSeq, _
				   strConsultFlg, strItemCd, strSuffix, strItemName, _
				   strResult, strResultType, strItemType, strStcItemCd, _
				   strShortStc, strRslCmtCd1, strRslCmtName1, strRslCmtCd2, _
				   strRslCmtName2, strBefResult, strBefShortStc, strStdFlg, _
				   strDefResult, strDefShortStc, strDefRslCmtCd, strDefRslCmtName, strLastRsvNo _
			   )

	'読み込んだ直後の結果、結果コメントを初期状態の配列として保持
	strInitRsl     = strResult
	strInitRslCmt1 = strRslCmtCd1
	strInitRslCmt2 = strRslCmtCd2

	'エラー処理用の配列作成
	If lngCount > 0 Then
		ReDim strResultErr(lngCount - 1)
		ReDim strRslCmtErr1(lngCount - 1)
		ReDim strRslCmtErr2(lngCount - 1)
	End If

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 検査結果情報一覧の編集
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditRslList()

	Const ALIGNMENT_RIGHT = "STYLE=""text-align:right"""	'右寄せ

	Const CLASS_ERROR     = "CLASS=""rslErr"""				'エラー表示のクラス指定

	Dim objCourse			'コース情報アクセス用

	Dim strDispStdFlgColor	'編集用基準値表示色
	Dim strAlignMent		'表示位置

	Dim strClass			'スタイルシートのCLASS指定
	Dim strClassStdFlg		'基準値スタイルシートのCLASS指定

	Dim strHTML				'HTML文字列
	Dim i					'インデックス

	Dim strLastCslDate		'前回受診日
	Dim strLastCsCd			'前回コースコード
	Dim strLastCsName		'前回コース名
	Dim strLastCsSName		'前回コース略称
	Dim strLastInfo			'前回情報

	If lngCount = 0 Then
		Exit Sub
	End If
%>
	<INPUT TYPE="hidden" NAME="lastRsvNo" VALUE="<%= strLastRsvNo %>">

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" STYLE="table-layout: fixed;">
		<TR>
			<TD WIDTH="128"></TD>
			<TD WIDTH="21"></TD>
			<TD WIDTH="67"></TD>
			<TD WIDTH="180"></TD>
			<TD WIDTH="21"></TD>
			<TD WIDTH="30"></TD>
			<TD WIDTH="80"></TD>
			<TD WIDTH="21"></TD>
			<TD WIDTH="30"></TD>
			<TD WIDTH="80"></TD>
			<TD WIDTH="200"></TD>
		</TR>
		<TR BGCOLOR="#eeeeee">
			<TD HEIGHT="21" ALIGN="right">検査項目名</TD>
			<TD COLSPAN="2">検査結果</TD>
			<TD>文章</TD>
			<TD COLSPAN="6" ALIGN="center">コメント</TD>
<%
			'前回予約番号が存在する場合
			If strLastRsvNo <> "" Then

				If objConsult.SelectConsult(strLastRsvNo, , strLastCslDate, , strLastCsCd) = True Then

					'オブジェクトのインスタンス作成
					Set objCourse = Server.CreateObject("HainsCourse.Course")

					'コース略称取得
					objCourse.SelectCourse strLastCsCd, strLastCsName, , , , , , , , , , , , , , , , , , , , , , , , strLastCsSName

					Set objCourse = Nothing

					strLastInfo = strLastCslDate & "：" & strLastCsSName

				End If

			End If
%>
			<TD>前回（<%= IIf(strLastInfo <> "", strLastInfo, "なし") %>）</TD>
		</TR>
<%
		'検査結果一覧の編集開始
		For i = 0 To lngCount - 1

			'検査項目名称
%>
			<TR BGCOLOR="#eeeeee">
				<TD ALIGN="right"><A HREF="javascript:callDtlGuide('<%= i %>')"><%= strItemName(i) %></A>
<%
					'結果項目情報
					strHTML = ""
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""cFlg"" VALUE=""" & strConsultFlg(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""itemCd"" VALUE=""" & strItemCd(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""suffix"" VALUE=""" & strSuffix(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""itemName"" VALUE=""" & strItemName(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""resultType"" VALUE=""" & strResultType(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""itemType"" VALUE=""" & strItemType(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""stcItemCd"" VALUE=""" & strStcItemCd(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""shortStc"" VALUE=""" & strShortStc(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""resultErr"" VALUE=""" & strResultErr(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""rslCmtErr1"" VALUE=""" & strRslCmtErr1(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""rcNm1"" VALUE=""" & strRslCmtName1(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""rslCmtErr2"" VALUE=""" & strRslCmtErr2(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""rcNm2"" VALUE=""" & strRslCmtName2(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""befResult"" VALUE=""" & strBefResult(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""befStc"" VALUE=""" & strBefShortStc(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""stdFlg"" VALUE=""" & strStdFlg(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""initRsl"" VALUE=""" & strInitRsl(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""initRslCmt1"" VALUE=""" & strInitRslCmt1(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""initRslCmt2"" VALUE=""" & strInitRslCmt2(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""defResult"" VALUE=""" & strDefResult(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""defShortStc"" VALUE=""" & strDefShortStc(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""defRslCmtCd"" VALUE=""" & strDefRslCmtCd(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""defRslCmtName"" VALUE=""" & strDefRslCmtName(i) & """>"
					Response.Write strHTML
%>
				</TD>
<%
				If Not IsEmpty(strItemCd(i)) And Trim(strItemCd(i)) <> "" And CStr(strConsultFlg(i)) = CStr(CONSULT_ITEM_T) Then

					Select Case CLng(strResultType(i))

						'定性ガイド表示
						Case RESULTTYPE_TEISEI1, RESULTTYPE_TEISEI2
%>
							<TD><A HREF="javascript:callTseGuide('<%= i %>')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="定性ガイド表示"></A></TD>
<%
						'文章ガイド表示
						Case RESULTTYPE_SENTENCE
%>
							<TD><A HREF="javascript:callStcGuide('<%= i %>')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="文章ガイド表示"></A></TD>
<%
						'ガイド表示なし
						Case Else
%>
							<TD HEIGHT="21"></TD>
<%
					End Select

					'検査結果＆文章

					'基準値フラグにより色を設定する
					Select Case strStdFlg(i)
						Case STDFLG_H
							strDispStdFlgColor = strH_Color
						Case STDFLG_U
							strDispStdFlgColor = strU_Color
						Case STDFLG_D
							strDispStdFlgColor = strD_Color
						Case STDFLG_L
							strDispStdFlgColor = strL_Color
						Case STDFLG_T1
							strDispStdFlgColor = strT1_Color
						Case STDFLG_T2
							strDispStdFlgColor = strT2_Color
						Case Else
							strDispStdFlgColor = ""
					End Select

					If strResultErr(i) <> "" Then
						strClass       = CLASS_ERROR
						strClassStdFlg = ""
					Else
						strClass       = ""
						strClassStdFlg = IIf(strDispStdFlgColor <> "", "STYLE=""color:" & strDispStdFlgColor & """", "")
					End If

					'計算結果の場合
					If CLng(strResultType(i)) = RESULTTYPE_CALC Then
%>
						<TD ALIGN="right"><INPUT TYPE="hidden" NAME="result" VALUE="<%= strResult(i) %>"><SPAN <%= strClassStdFlg %>><%= strResult(i) %></SPAN></TD>
<%
					'それ以外の場合
					Else

						'スタイルシートの設定
						strAlignment   = IIf(CLng(strResultType(i)) = RESULTTYPE_NUMERIC, ALIGNMENT_RIGHT, "")
%>
						<TD NOWRAP><INPUT TYPE="text" NAME="result" SIZE="<%= TextLength(8) %>" MAXLENGTH="8" VALUE="<%= strResult(i) %>" <%= strAlignment %> <%= strClass %> <%= strClassStdFlg %> ONFOCUS="return resultClick('<%= i %>')" ONCHANGE="clearStcName('<%= i %>')"></TD>
<%
					End If
%>
					<TD><SPAN ID="stcName<%= i %>"><%= strShortStc(i) %></SPAN></TD>
<%
					'結果コメント1
%>
					<TD><A HREF="javascript:callCmtGuide(1, '<%= i %>')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="結果コメントガイド表示"></A></TD>
<%
					'スタイルシートの設定
					strClass = IIf(strRslCmtErr1(i) <> "", CLASS_ERROR, "")
%>
					<TD><INPUT TYPE="text" NAME="rslCmtCd1" SIZE="3" MAXLENGTH="3" VALUE="<%= strRslCmtCd1(i) %>" <%= strClass %> ONFOCUS="javascript:rlCmtCd1Click('<%= i %>')"></TD>
					<TD><SPAN ID="rcNm1_<%= i %>"><%= strRslCmtName1(i) %></SPAN></TD>
<%
					'結果コメント2
%>
					<TD><A HREF="javascript:callCmtGuide(2, '<%= i %>')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="結果コメントガイド表示"></A></TD>
<%
					'スタイルシートの設定
					strClass = IIf(strRslCmtErr2(i) <> "", CLASS_ERROR, "")
%>
					<TD><INPUT TYPE="text" NAME="rslCmtCd2" SIZE="<%= TextLength(3) %>" MAXLENGTH="3" VALUE="<%= strRslCmtCd2(i) %>" <%= strClass %> ONFOCUS="javascript:rlCmtCd2Click('<%= i %>')"></TD>
					<TD><SPAN ID="rcNm2_<%= i %>"><%= strRslCmtName2(i) %></SPAN></TD>
<%
				Else
%>
					<TD HEIGHT="21"><INPUT TYPE="hidden" NAME="result" VALUE="<%= strResult(i) %>"></TD>
					<TD></TD>
					<TD></TD>
					<TD></TD>
					<TD><INPUT TYPE="hidden" NAME="rslCmtCd1" VALUE="<%= strRslCmtCd1(i) %>"></TD>
					<TD></TD>
					<TD></TD>
					<TD><INPUT TYPE="hidden" NAME="rslCmtCd2" VALUE="<%= strRslCmtCd2(i) %>"></TD>
					<TD></TD>
<%
				End If
%>
				<TD><%= IIf(CLng(strResultType(i)) = RESULTTYPE_SENTENCE, strBefShortStc(i), strBefResult(i)) %></TD>
			</TR>
<%
		Next
%>
	</TABLE>
<%
End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 検査結果情報一覧の編集
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditRslListSimply()

	Const ALIGNMENT_RIGHT = "STYLE=""text-align:right"""	'右寄せ
	Const CLASS_ERROR     = "CLASS=""rslErr"""				'エラー表示のクラス指定

	Dim strDispStdFlgColor	'編集用基準値表示色
	Dim strAlignMent		'表示位置

	Dim strClass			'スタイルシートのCLASS指定
	Dim strClassStdFlg		'基準値スタイルシートのCLASS指定

	Dim i					'インデックス
	Dim j					'インデックス
%>
	<INPUT TYPE="hidden" NAME="lastRsvNo" VALUE="<%= strLastRsvNo %>">

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR BGCOLOR="#eeeeee">
<%
			'表題の編集
			For i = 0 To lngCount - 1

				If i > 2 Then
					Exit For
				End If
%>
				<TD HEIGHT="21" ALIGN="right"><IMG SRC="/webHains/images/spacer.gif" WIDTH="128" HEIGHT="1"><BR>検査項目名</TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="90" HEIGHT="1"><BR>検査結果</TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="110" HEIGHT="1"><BR>前回結果</TD>
<%
			Next
%>
		</TR>
<%
		'検査結果一覧の編集開始
		For i = 0 To lngCount - 1 Step 3
%>
			<TR BGCOLOR="#eeeeee">
<%
				For j = i To i + 2

					If j > (lngCount - 1) Then
						Exit For
					End If

					'検査項目名称
%>
					<TD ALIGN="right"><A HREF="javascript:callDtlGuide('<%= j %>')"><%= strItemName(j) %></A>
<%
						'結果項目情報
%>
						<INPUT TYPE="hidden" NAME="cFlg"        VALUE="<%= strConsultFlg(j)      %>">
						<INPUT TYPE="hidden" NAME="itemCd"      VALUE="<%= strItemCd(j)          %>">
						<INPUT TYPE="hidden" NAME="suffix"      VALUE="<%= strSuffix(j)          %>">
						<INPUT TYPE="hidden" NAME="itemName"    VALUE="<%= strItemName(j)        %>">
						<INPUT TYPE="hidden" NAME="resultType"  VALUE="<%= strResultType(j)      %>">
						<INPUT TYPE="hidden" NAME="itemType"    VALUE="<%= strItemType(j)        %>">
						<INPUT TYPE="hidden" NAME="stcItemCd"   VALUE="<%= strStcItemCd(j)       %>">
						<INPUT TYPE="hidden" NAME="shortStc"    VALUE="<%= strShortStc(j)        %>">
						<INPUT TYPE="hidden" NAME="resultErr"   VALUE="<%= strResultErr(j)       %>">
						<INPUT TYPE="hidden" NAME="rslCmtErr1"  VALUE="<%= strRslCmtErr1(j)      %>">
						<INPUT TYPE="hidden" NAME="rcNm1" VALUE="<%= strRslCmtName1(j)     %>">
						<INPUT TYPE="hidden" NAME="rslCmtErr2"  VALUE="<%= strRslCmtErr2(j)      %>">
						<INPUT TYPE="hidden" NAME="rcNm2" VALUE="<%= strRslCmtName2(j)     %>">
						<INPUT TYPE="hidden" NAME="befResult"   VALUE="<%= strBefResult(j)       %>">
						<INPUT TYPE="hidden" NAME="befStc" VALUE="<%= strBefShortStc(j)     %>">
						<INPUT TYPE="hidden" NAME="stdFlg"      VALUE="<%= strStdFlg(j)          %>">
						<INPUT TYPE="hidden" NAME="initRsl"     VALUE="<%= strInitRsl(j)         %>">
						<INPUT TYPE="hidden" NAME="initRslCmt1" VALUE="<%= strInitRslCmt1(j)     %>">
						<INPUT TYPE="hidden" NAME="initRslCmt2" VALUE="<%= strInitRslCmt2(j)     %>">
						<INPUT TYPE="hidden" NAME="defResult"   VALUE="<%= strDefResult(j)       %>">
						<INPUT TYPE="hidden" NAME="defShortStc" VALUE="<%= strDefShortStc(j)     %>">
						<INPUT TYPE="hidden" NAME="defRslCmtCd"   VALUE="<%= strDefRslCmtCd(j)   %>">
						<INPUT TYPE="hidden" NAME="defRslCmtName" VALUE="<%= strDefRslCmtName(j) %>">
					</TD>
<%
					If Not IsEmpty(strItemCd(j)) And Trim(strItemCd(j)) <> "" And CStr(strConsultFlg(j)) = CStr(CONSULT_ITEM_T) Then
%>
						<TD>
							<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
								<TR>
<%
									Select Case CLng(strResultType(j))

										'定性ガイド表示
										Case RESULTTYPE_TEISEI1, RESULTTYPE_TEISEI2
%>
											<TD><A HREF="javascript:callTseGuide('<%= j %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="定性ガイド表示"></A></TD>
<%
										'文章ガイド表示
										Case RESULTTYPE_SENTENCE
%>
											<TD><A HREF="javascript:callStcGuide('<%= j %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="文章ガイド表示"></A></TD>
<%
										'ガイド表示なし
										Case Else
%>
											<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21"></TD>
<%
									End Select

									'検査結果＆文章

									'基準値フラグにより色を設定する
									Select Case strStdFlg(j)
										Case STDFLG_H
											strDispStdFlgColor = strH_Color
										Case STDFLG_U
											strDispStdFlgColor = strU_Color
										Case STDFLG_D
											strDispStdFlgColor = strD_Color
										Case STDFLG_L
											strDispStdFlgColor = strL_Color
										Case STDFLG_T1
											strDispStdFlgColor = strT1_Color
										Case STDFLG_T2
											strDispStdFlgColor = strT2_Color
										Case Else
											strDispStdFlgColor = ""
									End Select

									If strResultErr(j) <> "" Then
										strClass       = CLASS_ERROR
										strClassStdFlg = ""
									Else
										strClass       = ""
										strClassStdFlg = IIf(strDispStdFlgColor <> "", "STYLE=""{color:" & strDispStdFlgColor & """", "")
									End If

									'計算結果の場合
									If CLng(strResultType(j)) = RESULTTYPE_CALC Then
%>
										<TD><INPUT TYPE="hidden" NAME="result" VALUE="<%= strResult(j) %>"><SPAN <%= strClassStdFlg %>><%= strResult(j) %></SPAN></TD>
<%
									'それ以外の場合
									Else

										'スタイルシートの設定
										strAlignment = IIf(CLng(strResultType(j)) = RESULTTYPE_NUMERIC, ALIGNMENT_RIGHT, "")
%>
										<TD NOWRAP>
											<INPUT TYPE="text" NAME="result" SIZE="<%= TextLength(8) %>" MAXLENGTH="8" VALUE="<%= strResult(j) %>" <%= strAlignment %> <%= strClass %> <%= strClassStdFlg %> ONFOCUS="return resultClick('<%= j %>')" ONCHANGE="clearStcName('<%= j %>')">
										</TD>
<%
									End If
%>
								</TR>
							</TABLE>
						</TD>
<%
						'前回結果
%>
						<TD WIDTH="100">
							&nbsp;<%= strBefResult(j) %>
<%
							'結果コメント１
%>
							<INPUT TYPE="hidden" NAME="rslCmtCd1" VALUE="<%= strRslCmtCd1(j) %>">
<%
							'結果コメント２
%>
							<INPUT TYPE="hidden" NAME="rslCmtCd2" VALUE="<%= strRslCmtCd2(j) %>">
						</TD>
<%
					Else
%>
						<TD>
							<INPUT TYPE="hidden" NAME="result"    VALUE="<%= strResult(j)    %>">
							<INPUT TYPE="hidden" NAME="rslCmtCd1" VALUE="<%= strRslCmtCd1(j) %>">
							<INPUT TYPE="hidden" NAME="rslCmtCd2" VALUE="<%= strRslCmtCd2(j) %>">
						</TD>
						<TD WIDTH="100"><IMG SRC="/webHains/images/spacer.gif" WIDTH="100" HEIGHT="21"></TD>
<%
					End If

				Next
%>
			</TR>
<%
		Next
%>
	</TABLE>
<%
End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="x-ua-compatible" content="IE=10">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>結果入力</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/tseGuide.inc"    -->
<!-- #include virtual = "/webHains/includes/stcGuide.inc"    -->
<!-- #include virtual = "/webHains/includes/cmtGuide.inc"    -->
<!-- #include virtual = "/webHains/includes/dtlGuide.inc"    -->
<!--
var lngSelectedIndex1;  // ガイド表示時に選択されたエレメントのインデックス
var lngSelectedIndex2;  // ガイド表示時に選択されたエレメントのインデックス

// 定性ガイド呼び出し
function callTseGuide( index ) {

	var myForm = document.resultList;

	// 選択されたエレメントのインデックスを退避(定性結果のセット用関数にて使用する)
	lngSelectedIndex1 = index;

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

	var myForm = document.resultList;

	// 予め退避したインデックス先のエレメントに、ガイド画面で設定された連絡域の値を編集
	if ( myForm.result.length != null ) {
		myForm.result[lngSelectedIndex1].value = tseGuide_Result;
	} else {
		myForm.result.value = tseGuide_Result;
	}
	return false;
}

// 文章ガイド呼び出し
function callStcGuide( index ) {

	var myForm = document.resultList;

	// 選択されたエレメントのインデックスを退避(文章コード・略文章のセット用関数にて使用する)
	lngSelectedIndex1 = index;

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

	setStc( lngSelectedIndex1, stcGuide_StcCd, stcGuide_ShortStc );

}

// 検査項目説明呼び出し
function callDtlGuide( index ) {

	var myForm = document.resultList;

	// 説明画面の連絡域に画面入力値を設定する
	if ( myForm.itemCd.length != null ) {
		dtlGuide_ItemCd = myForm.itemCd[ index ].value;
	} else {
		dtlGuide_ItemCd = myForm.itemCd.value;
	}
	if ( myForm.suffix.length != null ) {
		dtlGuide_Suffix = myForm.suffix[ index ].value;
	} else {
		dtlGuide_Suffix = myForm.suffix.value;
	}

	dtlGuide_CsCd         = '<%= strCsCd           %>';
	dtlGuide_CslDateYear  = '<%= Year(strCslDate)  %>';
	dtlGuide_CslDateMonth = '<%= Month(strCslDate) %>';
	dtlGuide_CslDateDay   = '<%= Day(strCslDate)   %>';
	dtlGuide_Age          = '<%= strAge            %>';
	dtlGuide_Gender       = '<%= strGender         %>';

	// 検査項目説明表示
	showGuideDtl();

}

// 結果コメントガイド呼び出し
function callCmtGuide( index1, index2 ) {

	// 選択されたエレメントのインデックスを退避(結果コメントコード・結果コメント名のセット用関数にて使用する)
	lngSelectedIndex1 = index1;
	lngSelectedIndex2 = index2;

	// ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
	cmtGuide_CalledFunction = setCmtInfo;

	// 結果コメントガイド表示
	showGuideCmt();
}

// 結果コメントコード・結果コメント名のセット
function setCmtInfo() {

	var rslCmtNameElement;	/* 結果コメント名を編集するエレメントの名称 */
	var rslCmtName;			/* 結果コメント名を編集するエレメント自身 */
	var myForm = document.resultList;

	// 予め退避したインデックス先のエレメントに、ガイド画面で設定された連絡域の値を編集
	if ( lngSelectedIndex1 == 1 ) {
		if ( myForm.rslCmtCd1.length != null ) {
			myForm.rslCmtCd1[lngSelectedIndex2].value = cmtGuide_RslCmtCd;
		} else {
			myForm.rslCmtCd1.value = cmtGuide_RslCmtCd;
		}
		if ( myForm.rcNm1.length != null ) {
			myForm.rcNm1[lngSelectedIndex2].value = cmtGuide_RslCmtName;
		} else {
			myForm.rcNm1.value = cmtGuide_RslCmtName;
		}
	} else {
		if ( myForm.rslCmtCd2.length != null ) {
			myForm.rslCmtCd2[lngSelectedIndex2].value = cmtGuide_RslCmtCd;
		} else {
			myForm.rslCmtCd2.value = cmtGuide_RslCmtCd;
		}
		if ( myForm.rcNm2.length != null ) {
			myForm.rcNm2[lngSelectedIndex2].value = cmtGuide_RslCmtName;
		} else {
			myForm.rcNm2.value = cmtGuide_RslCmtName;
		}
	}

	// ブラウザごとの結果コメント名編集用エレメントの設定処理
	for ( ; ; ) {

		// エレメント名の編集
		rslCmtNameElement = 'rcNm' + lngSelectedIndex1 + '_' + lngSelectedIndex2;

		// IEの場合
		if ( document.all ) {
			document.all(rslCmtNameElement).innerHTML = cmtGuide_RslCmtName;
			break;
		}

		// Netscape6の場合
		if ( document.getElementById ) {
			document.getElementById(rslCmtNameElement).innerHTML = cmtGuide_RslCmtName;
		}

	break;
	}

	return false;
}

// 入力用検査項目セットを変更して更新
function saveRslDetail() {

	var myForm = document.resultList;

	if ( myForm.count.value == '' ) {
		return false;
	}

	if ( myForm.count.value < 1 ) {
		return false;
	}

	myForm.code.value    = '<%= strCode      %>';
	myForm.actMode.value = '<%= ACTMODE_SAVE %>';
	myForm.submit();

	return false;
}

// 表示モードの切り替え
function chgDetail(dispMode) {

	var myForm = document.resultList;

	myForm.code.value     = '<%= strCode %>';
	myForm.actMode.value  = '<%= ACTMODE_CHANGE %>';
	myForm.dispMode.value = dispMode;

	myForm.submit();

}

// 検索条件取得
function loadPage() {

	var myForm = document.resultList;	// 自画面のフォームエレメント
	var i;								// インデックス

	// 対象検査結果が存在しない場合、何もしない
	if ( myForm.result == null ) {
		return;
	}

	// 先頭の検査結果へカーソル移動
	myForm.activeCount.value = 0;
	myForm.activeColumn.value = 0;

	if ( myForm.result.length != null ) {
		for ( i = 0; i < myForm.count.value; i++ ) {
			if ( myForm.result[i].type == 'text' ) {
				myForm.result[i].focus();
				myForm.activeCount.value = i;
				myForm.activeColumn.value = 0;
				break;
			}
		}
	} else {
		if ( myForm.result.type == 'text' ) {
			myForm.result.focus();
		}
	}

}

// 検査結果クリック
function resultClick( i ) {

	var myForm = document.resultList;

	// 現在のカーソル位置を設定
	myForm.activeCount.value  = i;
	myForm.activeColumn.value = <%= IIf(strDispMode = DISPMODE_DETAIL, "0", "i % 3") %>;

	return false;
}

// 結果コメント１クリック
function rlCmtCd1Click( i ) {

	var myForm = document.resultList;

	// 現在のカーソル位置を設定
	myForm.activeCount.value = i;
	myForm.activeColumn.value = 1;

	return false;
}

// 結果コメント２クリック
function rlCmtCd2Click( i ) {

	var myForm = document.resultList;

	// 現在のカーソル位置を設定
	myForm.activeCount.value = i;
	myForm.activeColumn.value = 2;

	return false;
}

// 文章削除
function clearStcName( i ) {

	var stcNameElement;					// 略文章を編集するエレメントの名称
	var myForm = document.resultList;	// 自画面のフォームエレメント

	if ( myForm.shortStc.length != null ) {
		myForm.shortStc[i].value = '';
	} else {
		myForm.shortStc.value = '';
	}

	// エレメント名の編集
	stcNameElement = 'stcName' + i;

	if ( document.getElementById(stcNameElement) ) {
		document.getElementById(stcNameElement).innerHTML = '';
	}

}

// サブ画面を閉じる
function closeWindow() {

	// 文章ガイドを閉じる
	closeGuideStc();

	// 定性結果ガイドを閉じる
	closeGuideTse();

	// 検査項目説明画面を閉じる
	closeGuideDtl();

	// 結果コメントガイドを閉じる
	closeGuideCmt();

}

// 文章の編集
function setStc( index, stcCd, shortStc ) {

	var myForm = document.resultList;	// 自画面のフォームエレメント
	var objResult, objShortStc;			// 結果・文章のエレメント
	var stcNameElement;					// 文章のエレメント

	// 編集エレメントの設定
	if ( myForm.result.length != null ) {
		objResult   = myForm.result[ index ];
		objShortStc = myForm.shortStc[ index ];
	} else {
		objResult   = myForm.result;
		objShortStc = myForm.shortStc;
	}

	stcNameElement = 'stcName' + index;

	// 値の編集
	objResult.value   = stcCd;
	objShortStc.value = shortStc;

	if ( document.getElementById(stcNameElement) ) {
		document.getElementById(stcNameElement).innerHTML = shortStc;
	}

}
//-->
</SCRIPT>
<!--[if lte IE 9]>
<script type="text/vbscript" src="rslDetail.vbs"></script>
<![endif]-->
<!--[if !(lte IE 9)]><!-->
<script type="text/javascript" src="rslDetail.js"></script>
<!--<![endif]-->
<style type="text/css">
	body { margin: 10px 0 0 20px; }
	td.rsltab  { background-color:#FFFFFF }
</style>
</HEAD>
<BODY ONLOAD="javascript:loadPage()" ONUNLOAD="javascript:closeWindow()">
<FORM NAME="resultList" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="actMode">
<INPUT TYPE="hidden" NAME="dispMode"    VALUE="<%= strDispMode    %>">
<INPUT TYPE="hidden" NAME="rsvNo"       VALUE="<%= strRsvNo       %>">
<INPUT TYPE="hidden" NAME="cslYear"     VALUE="<%= strKeyCslYear  %>">
<INPUT TYPE="hidden" NAME="cslMonth"    VALUE="<%= strKeyCslMonth %>">
<INPUT TYPE="hidden" NAME="cslDay"      VALUE="<%= strKeyCslDay   %>">
<INPUT TYPE="hidden" NAME="cntlNo"      VALUE="<%= strKeyCntlNo   %>">
<INPUT TYPE="hidden" NAME="csCd"        VALUE="<%= strKeyCsCd     %>">
<INPUT TYPE="hidden" NAME="dayId"       VALUE="<%= strKeyDayId    %>">
<INPUT TYPE="hidden" NAME="NoReceipt"   VALUE="<%= strNoReceiptMode %>">

<!-- カーソル入力制御用 -->
<INPUT TYPE="hidden" NAME="orientation" VALUE="<%= strOrientation %>">
<INPUT TYPE="hidden" NAME="portrait"    VALUE="<%= strPortrait    %>">
<INPUT TYPE="hidden" NAME="landscape"   VALUE="<%= strLandscape   %>">
<INPUT TYPE="hidden" NAME="activeCount" >
<INPUT TYPE="hidden" NAME="activeColumn">

<!-- ウインドウ説明見出し -->
<TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD VALIGN="TOP">
			<!-- 表題 -->
			<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%"><!-- or WIDTH="90%" -->
				<TR><TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">結果入力</FONT></B></TD></TR>
			</TABLE>
		</TD>
		<TD WIDTH="5"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5"></TD>
	</TR>
</TABLE>
<%
	'メッセージの編集
	If strActMode <> "" Then

		'保存完了時は「保存完了」の通知
		If strActMode = ACTMODE_SAVEEND Then
			Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

		'さもなくばエラーメッセージを編集
		Else
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If

	End If
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD NOWRAP>受診日：</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %></B></FONT></TD>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
			<TD NOWRAP>受診コース：</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
<%
			If strKeyDayId <> "" Then
%>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD NOWRAP>当日ＩＤ：</TD>
				<TD NOWRAP><FONT COLOR="#ff6600"><B><%= objCommon.FormatString(strKeyDayId, "0000") %></B></FONT></TD>
<%
			End If
%>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
			<TD NOWRAP>予約番号：</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strRsvNo %></B></FONT></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="675">
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
		<TR>
			<TD NOWRAP WIDTH="46" ROWSPAN="2" VALIGN="top"><%= strPerId %></TD>
			<TD NOWRAP><B><%= Trim(strLastName & "　" & strFirstName) %></B> (<FONT SIZE="-1"><%= Trim(strLastKname & "　" & strFirstKName) %></FONT>)</TD>
		</TR>
		<TR>
			<TD VALIGN="top" NOWRAP><%= objCommon.FormatString(strBirth, "ge.m.d") %>生　<%= Trim(strAge) %>歳　<%= IIf(strGender = "1", "男性", "女性") %></TD>
			<TD WIDTH="100%"></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="675">
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
		<TR>
<%
			'グループ名読み込み
			objGrp.SelectGrp_P strCode, strCodeName
%>
			<TD NOWRAP>
				<INPUT TYPE="hidden" NAME="code" VALUE="<%= strCode %>">
				<B><%= strCodeName %></B>グループに該当する検査項目を表示しています。
			</TD>
			<TD WIDTH="100%"></TD>
			
			<TD ALIGN="right">&nbsp;
			<% '2005.08.22 権限管理 Add by 李　--- START %>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
				<A HREF="javascript:function voi(){};voi()" ONCLICK="return saveRslDetail()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存"></A>
			<%  else    %>
                 &nbsp;
            <%  end if  %>
			<% '2005.08.22 権限管理 Add by 李　--- END %>
			</TD>

		</TR>
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="675">
		<TR>
			<TD NOWRAP><A HREF="javascript:chgDetail('<%= IIf(strDispMode = DISPMODE_DETAIL, DISPMODE_SIMPLE, DISPMODE_DETAIL) %>')" METHOD="post">文章結果を表示<%= IIf(strDispMode = DISPMODE_DETAIL, "しない", "する") %></A></TD>
		</TR>
	</TABLE>
<%
	If lngUpdItemCount = 0 Then
		Call EditMessage("この入力検査項目セット内に受診項目は存在しません。", MESSAGETYPE_NORMAL)
%>
		<BR>
<%
	End If
%>
	<INPUT TYPE="hidden" NAME="count"        VALUE="<%= lngCount        %>">
	<INPUT TYPE="hidden" NAME="updItemCount" VALUE="<%= lngUpdItemCount %>">
<%
	'表示モードごとの処理制御
	Select Case strDispMode

		Case DISPMODE_DETAIL	'詳細表示
			Call EditRslList()

		Case DISPMODE_SIMPLE	'略式表示
			Call EditRslListSimply()

	End Select
%>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
