<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       一覧結果入力 (Ver0.0.1)
'       AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditGrpList.inc" -->
<!-- #include virtual = "/webHains/includes/EditNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/EditRslDailyList.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const STDFLG_H = "H"		'異常（上）
Const STDFLG_U = "U"		'軽度異常（上）
Const STDFLG_D = "D"		'軽度異常（下）
Const STDFLG_L = "L"		'異常（下）
Const STDFLG_T1 = "*"		'定性値異常
Const STDFLG_T2 = "@"		'定性値軽度異常

'データベースアクセス用オブジェクト
Dim objCommon				'共通クラス
Dim objResult				'検査結果アクセス用COMオブジェクト
Dim objConsult				'受診情報アクセス用COMオブジェクト
Dim objGrp					'グループアクセス用COMオブジェクト
Dim objWorkStation			'通過情報アクセス用

Dim strAction				'処理状態(次へボタン押下時:"next")
Dim lngYear					'受診日（年）
Dim lngMonth				'受診日（月）
Dim lngDay					'受診日（日）
Dim strGrpCd				'検査グループコード
Dim strSortKey				'表示順
Dim strDayIdF				'表示開始当日ＩＤ
Dim strGetCount				'表示件数
Dim lngStartPos				'表示開始位置

'受診情報
Dim strRsvNo				'予約番号
Dim strPerId				'個人ＩＤ
Dim strDayId				'当日ＩＤ
Dim strLastName				'姓
Dim strFirstName			'名

'グループ内検査項目情報
Dim strGrpItemCd			'検査項目コード
Dim strGrpSuffix			'サフィックス
Dim strGrpItemName			'検査項目名称

'検査結果情報
Dim strRslRsvNo				'検査項目ごと予約番号
Dim strRslLastName			'検査項目ごと姓
Dim strRslFirstName			'検査項目ごと名
Dim strConsultFlg			'受診項目フラグ
Dim strItemCd				'検査項目コード
Dim strSuffix				'サフィックス
Dim strItemName				'検査項目名称
Dim strResult				'検査結果
Dim strResultType			'結果タイプ
Dim strResultErr			'結果入力エラー
Dim strStdFlg				'基準値フラグ
Dim strInitRsl				'初期読み込み状態の結果

'実際に更新する項目情報を格納した検査結果
Dim strUpdRsvNo				'予約番号
Dim strUpdItemCd			'検査項目コード
Dim strUpdSuffix			'サフィックス
Dim strUpdResult			'検査結果
Dim lngUpdCount				'更新項目数

Dim strCslDate				'受診日
Dim lngDayId				'当日ＩＤ
Dim strArrMessage			'エラーメッセージ

Dim lngAllCount				'条件を満たす全レコード件数
Dim lngCount				'レコード件数
Dim lngItemCount			'検査項目数
Dim lngRslCount				'検査結果数
Dim lngUpdItemCount			'更新項目数

Dim lngWorkGetCount			'取得件数

Dim i						'インデックス
Dim blnFindFlg				'検索フラグ

'端末管理情報
Dim strIPAddress			'IPAddress
Dim strWkstnName			'端末名
Dim strWkstnGrpCd			'グループコード
Dim strWkstnGrpName			'グループ名

'表示色
Dim strH_Color				'基準値フラグ色（Ｈ）
Dim strU_Color				'基準値フラグ色（Ｕ）
Dim strD_Color				'基準値フラグ色（Ｄ）
Dim strL_Color				'基準値フラグ色（Ｌ）
Dim strT1_Color				'基準値フラグ色（＊）
Dim strT2_Color				'基準値フラグ色（＠）

Dim strUpdUser			'更新者

Dim lngChkIndex()		'検査項目コード
Dim strChkItemCd()		'検査項目コード
Dim strChkSuffix()		'サフィックス
Dim strChkResult()		'検査結果
Dim strChkShortStc		'文章略称
Dim strChkResultErr()	'検査結果エラー
Dim lngChkCount			'チェック項目数

Dim strPrevRsvNo		'直前レコードの予約番号
Dim strPrevRslName		'直前レコードの氏名
Dim strArrMessage2		'メッセージ
Dim lngMsgCount			'メッセージ数
Dim j					'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'更新者の設定
strUpdUser = Session("USERID")

'IPアドレスの取得
strIPAddress = Request.ServerVariables("REMOTE_ADDR")

'引数値の取得
strAction		= Request("act")
lngYear			= Request("year")
lngMonth		= Request("month")
lngDay			= Request("day")
strGrpCd		= Request("grpCd")
strSortKey		= Request("sortKey")
strDayIdF		= Request("dayIdF")
strGetCount		= Request("getCount")
lngStartPos 	= CLng("0" & Request("startPos"))

'検索開始位置未指定時は先頭から検索する
If lngStartPos = 0 Then
	lngStartPos = 1
End If

'受診日が未指定の場合は、システム日をデフォルトセット
If lngYear = "" And lngMonth = "" And lngDay = "" Then
	lngYear  = CLng(Year(Now))
	lngMonth = CLng(Month(Now))
	lngDay   = CLng(Day(Now))
Else
	lngYear  = CLng("0" & lngYear)
	lngMonth = CLng("0" & lngMonth)
	lngDay   = CLng("0" & lngDay)
End If

'コードが渡されていない場合
If strGrpCd = "" Then

	'オブジェクトのインスタンス作成
	Set objWorkStation = Server.CreateObject("HainsWorkStation.WorkStation")

	'規定のグループコード取得
	If objWorkStation.SelectWorkstation(strIPAddress, strWkstnName, strWkstnGrpCd, strWkstnGrpName) = True Then
		strGrpCd = strWkstnGrpCd
	End If

	Set objWorkStation = Nothing

End If

'オブジェクトのインスタンス作成
Set objCommon = Server.CreateObject("HainsCommon.Common")

'基準値フラグ色取得
objCommon.SelectStdFlgColor "H_COLOR", strH_Color
objCommon.SelectStdFlgColor "U_COLOR", strU_Color
objCommon.SelectStdFlgColor "D_COLOR", strD_Color
objCommon.SelectStdFlgColor "L_COLOR", strL_Color
objCommon.SelectStdFlgColor "*_COLOR", strT1_Color
objCommon.SelectStdFlgColor "@_COLOR", strT2_Color

'受診情報
strRsvNo     = ConvIStringToArray(Request("rsvNo"))
strPerId     = ConvIStringToArray(Request("perId"))
strDayId     = ConvIStringToArray(Request("dayId"))
strLastName  = ConvIStringToArray(Request("lastName"))
strFirstName = ConvIStringToArray(Request("firstName"))

'グループ内検査項目情報
strGrpItemCd   = ConvIStringToArray(Request("grpItemCd"))
strGrpSuffix   = ConvIStringToArray(Request("grpSuffix"))
strGrpItemName = ConvIStringToArray(Request("grpItemName"))

'検査結果情報
strRslRsvNo     = ConvIStringToArray(Request("rslRsvNo"))
strRslLastName  = ConvIStringToArray(Request("rslLastName"))
strRslFirstName = ConvIStringToArray(Request("rslFirstName"))
strConsultFlg   = ConvIStringToArray(Request("consultFlg"))
strItemCd       = ConvIStringToArray(Request("itemCd"))
strSuffix       = ConvIStringToArray(Request("suffix"))
strItemName     = ConvIStringToArray(Request("itemName"))
strResult       = ConvIStringToArray(Request("result"))
strResultType   = ConvIStringToArray(Request("resultType"))
strResultErr    = ConvIStringToArray(Request("resultErr"))
strStdFlg       = ConvIStringToArray(Request("stdFlg"))
strInitRsl      = ConvIStringToArray(Request("initRsl"))

'件数情報
lngCount     = CLng("0" & Request("count"))
lngItemCount = CLng("0" & Request("itemCount"))
lngRslCount  = CLng("0" & Request("rslCount"))
lngUpdItemCount = CLng("0" & Request("updItemCount"))

Do
	If strAction = "save" Then

		'オブジェクトのインスタンス作成
		Set objResult  = Server.CreateObject("HainsResult.Result")

		strCslDate = CDate(lngYear & "/" & lngMonth & "/" & lngDay)

		'結果入力チェック
		For i = 0 To UBound(strRslRsvNo)

			'直前レコードと予約番号が変わった時点でチェックを行う
			If strPrevRsvNo <> "" And strRslRsvNo(i) <> strPrevRsvNo Then

				'結果入力チェック
				strArrMessage2 = objResult.CheckResult(strCslDate, strChkItemCd, strChkSuffix, strChkResult, strChkShortStc, strChkResultErr)

				'チェック結果を戻す
				For j = 0 To lngChkCount - 1
					strResult(lngChkIndex(j))    = strChkResult(j)
					strResultErr(lngChkIndex(j)) = strChkResultErr(j)
				Next

				'エラーが存在する場合
				If Not IsEmpty(strArrMessage2) Then

					If IsEmpty(strArrMessage) Then
						strArrMessage = Array()
					End If

					'エラーメッセージを追加
					For j = 0 To UBound(strArrMessage2)
						ReDim Preserve strArrMessage(lngMsgCount)
						strArrMessage(lngMsgCount) = strPrevRslName & "　" & strArrMessage2(j)
						lngMsgCount = lngMsgCount + 1
					Next

				End If

				'チェック情報をクリア
				Erase lngChkIndex
				Erase strChkItemCd
				Erase strChkSuffix
				Erase strChkResult
				Erase strChkResultErr
				lngChkCount = 0

			End If

			'チェック情報をスタック
			ReDim Preserve lngChkIndex(lngChkCount)
			ReDim Preserve strChkItemCd(lngChkCount)
			ReDim Preserve strChkSuffix(lngChkCount)
			ReDim Preserve strChkResult(lngChkCount)
			ReDim Preserve strChkResultErr(lngChkCount)
			lngChkIndex(lngChkCount)     = i
			strChkItemCd(lngChkCount)    = strItemCd(i)
			strChkSuffix(lngChkCount)    = strSuffix(i)
			strChkResult(lngChkCount)    = strResult(i)
			strChkResultErr(lngChkCount) = strResultErr(i)
			lngChkCount = lngChkCount + 1

			'現レコードの予約番号、氏名を退避
			strPrevRsvNo   = strRslRsvNo(i)
			strPrevRslName = Trim(strRslLastName(i) & "　" & strRslFirstName(i))

		Next

		'スタック残り分の結果チェック

		'結果入力チェック
		strArrMessage2 = objResult.CheckResult(strCslDate, strChkItemCd, strChkSuffix, strChkResult, strChkShortStc, strChkResultErr)

		'チェック結果を戻す
		For j = 0 To lngChkCount - 1
			strResult(lngChkIndex(j))    = strChkResult(j)
			strResultErr(lngChkIndex(j)) = strChkResultErr(j)
		Next

		'エラーが存在する場合
		If Not IsEmpty(strArrMessage2) Then

			If IsEmpty(strArrMessage) Then
				strArrMessage = Array()
			End If

			'エラーメッセージを追加
			For j = 0 To UBound(strArrMessage2)
				ReDim Preserve strArrMessage(lngMsgCount)
				strArrMessage(lngMsgCount) = strPrevRslName & "　" & strArrMessage2(j)
				lngMsgCount = lngMsgCount + 1
			Next

		End If

		'チェックエラー時は処理を抜ける
		If Not IsEmpty(strArrMessage) Then

			'保存エラー時だけは総カウント数をセット（ページング用のボタンが表示されなくなってしまう）
			lngAllCount = Request("allCountUseSave")
			lngStartPos = Request("startPosUseSave")

			Exit Do
		End If

		lngUpdCount  = 0
		strUpdRsvNo  = Array()
		strUpdItemCd = Array()
		strUpdSuffix = Array()
		strUpdResult = Array()

		'実際に更新を行う項目のみを抽出(結果未入力でチェックなしの項目以外が更新対象)
		For i = 0 To UBound(strRslRsvNo)

			'結果が初期表示時の値から更新されていたらデータ更新
			If strConsultFlg(i) = CStr(CONSULT_ITEM_T) And strResult(i) <> strInitRsl(i) Then
				ReDim Preserve strUpdRsvNo(lngUpdCount)
				ReDim Preserve strUpdItemCd(lngUpdCount)
				ReDim Preserve strUpdSuffix(lngUpdCount)
				ReDim Preserve strUpdResult(lngUpdCount)
				strUpdRsvNo(lngUpdCount)  = strRslRsvNo(i)
				strUpdItemCd(lngUpdCount) = strItemCd(i)
				strUpdSuffix(lngUpdCount) = strSuffix(i)
				strUpdResult(lngUpdCount) = strResult(i)
				lngUpdCount = lngUpdCount + 1
			End If

		Next

		'検査結果更新
		If lngUpdCount > 0 Then

			strArrMessage = objResult.UpdateResultList(strUpdUser, strIPAddress, strUpdRsvNo, strUpdItemCd, strUpdSuffix, strUpdResult)

			If Not IsEmpty(strArrMessage) Then

				'保存エラー時だけは総カウント数をセット（ページング用のボタンが表示されなくなってしまう）
				lngAllCount = Request("allCountUseSave")
				lngStartPos = Request("startPosUseSave")

				Exit Do
			End If

		End If

		'オブジェクトのインスタンス削除
		Set objResult = Nothing

		'保存完了
		strAction = "saveend"

	End If

	'件数カウンタクリア
	lngCount = 0
	lngItemCount = 0
	lngRslCount = 0

	'オブジェクトのインスタンス作成
	Set objResult  = Server.CreateObject("HainsResult.Result")

	'条件入力チェック
	strArrMessage = objResult.CheckRslListSetConditionValue(lngYear, lngMonth, lngDay, strCslDate, strDayIdF)

	'チェックエラー時は処理を抜ける
	If Not IsEmpty(strArrMessage) Then
		Exit Do
	End If

	'オブジェクトのインスタンス削除
	Set objResult  = Nothing

	'オブジェクトのインスタンス作成
	Set objResult  = Server.CreateObject("HainsResult.Result")
	Set objConsult = Server.CreateObject("HainsConsult.Consult")
	Set objGrp     = Server.CreateObject("HainsGrp.Grp")

	lngDayId = CLng("0" & strDayIdF)

	'取得件数未指定時はデフォルト値を取得
	strGetCount = IIf(strGetCount = "", EditRslPageMaxLine(), strGetCount)

	'取得件数の設定
	If IsNumeric(strGetCount) Then
		lngWorkGetCount = CLng(strGetCount)
	End If

	'検索条件を満たしかつ指定開始位置、件数分のレコードを取得
'## 2004.01.09 Mod By T.Takagi@FSIT 来院関連追加
'	lngAllCount = objConsult.SelectConsultList(strCslDate,         _
'											   0,                  _
'											   "",                 _
'											   lngDayId, ,         _
'											   strGrpCd,           _
'											   lngStartPos,        _
'											   lngWorkGetCount,    _
'											   strSortKey, , , , , _
'											   strRsvNo,           _
'											   strDayId, , ,       _
'											   strPerId,           _
'											   strLastName,        _
'											   strFirstName)
	lngAllCount = objConsult.SelectConsultList(strCslDate,         _
											   0,                  _
											   "",                 _
											   lngDayId, ,         _
											   strGrpCd,           _
											   lngStartPos,        _
											   lngWorkGetCount,    _
											   strSortKey, , , , , _
											   strRsvNo,           _
											   strDayId, , ,       _
											   strPerId,           _
											   strLastName,        _
											   strFirstName, , , , , , , , , , , , , , , , , _
											   True)
'## 2004.01.09 Mod End

	'検索結果が存在しない場合はメッセージを編集
	If lngAllCount = 0 Then
		strArrMessage = Array("条件に合致する受診情報は存在しません。")
		Exit Do
	End If

	If Not IsEmpty(strRsvNo) Then
		lngCount = UBound(strRsvNo) + 1
	End If

	'グループ内検査項目を取得
	lngItemCount = objGrp.SelectGrp_I_ItemList(strGrpCd, strGrpItemCd, strGrpSuffix, strGrpItemName)

	'検査結果を取得
	lngRslCount = objResult.SelectRslListSet(strRsvNo, _
											 strLastName, _
											 strFirstName, _
											 strGrpCd, _
											 lngUpdItemCount, _
											 strRslRsvNo, _
											 strRslLastName, _
											 strRslFirstName, _
											 strConsultFlg, _
											 strItemCd, _
											 strSuffix, _
											 strItemName, _
											 strResult, _
											 strResultType, _
											 strStdFlg)

	'読み込んだ直後の結果、結果コメントを初期状態の配列として保持
	strInitRsl = strResult

	'入力チェック用の配列を拡張
	If lngRslCount > 0 Then
		ReDim strResultErr(lngRslCount - 1)
	End If

	Exit Do
Loop

'-----------------------------------------------------------------------------
' 一覧検査結果の編集
'-----------------------------------------------------------------------------
Sub EditRslList()

	Const ALIGNMENT_RIGHT = "STYLE=""text-align:right"""	'右寄せ
	Const CLASS_ERROR     = "CLASS=""rslErr"""				'エラー表示のクラス指定

	Dim strDispStdFlgColor	'編集用基準値表示色
	Dim strAlignMent		'表示位置

	Dim strClass			'スタイルシートのCLASS指定
	Dim strClassStdFlg		'基準値スタイルシートのCLASS指定

	Dim i					'インデックス
	Dim j					'インデックス
	Dim k					'インデックス

%>
	<INPUT TYPE="hidden" NAME="count"         VALUE="<%= lngCount %>">
	<INPUT TYPE="hidden" NAME="itemCount"     VALUE="<%= lngItemCount %>">
	<INPUT TYPE="hidden" NAME="rslCount"      VALUE="<%= lngRslCount %>">
	<INPUT TYPE="hidden" NAME="updItemCount"  VALUE="<%= lngUpdItemCount %>">
<%
	If lngCount = 0 Or lngItemCount = 0 Or lngRslCount = 0 Then
		Exit Sub
	End If

	If lngUpdItemCount = 0 Then
		Call EditMessage("この検査グループに受診した検査項目は存在しません。", MESSAGETYPE_NORMAL)
		Exit Sub
	End If
%>
	「<FONT COLOR="#ff6600"><B><%= lngYear %>年<%= lngMonth %>月<%= lngDay %>日</B></FONT>」の来院済み受診者一覧を表示しています。対象者数は<FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>人です。<BR><BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" class="mensetsu-tb">
		<TR BGCOLOR="#eeeeee">
			<TD NOWRAP>当日ＩＤ</TD>
			<TD NOWRAP>個人ＩＤ</TD>
			<TD NOWRAP>氏名</TD>
<%
			For i = 0 To lngItemCount - 1
%>
				<TD>
					<IMG SRC="/webHains/images/spacer.gif" WIDTH="70" HEIGHT="1"><BR>
					<INPUT TYPE="hidden" NAME="grpItemCd"   VALUE="<%= strGrpItemCd(i) %>">
					<INPUT TYPE="hidden" NAME="grpSuffix"   VALUE="<%= strGrpSuffix(i) %>">
					<INPUT TYPE="hidden" NAME="grpItemName" VALUE="<%= strGrpItemName(i) %>">
					<%= strGrpItemName(i) %>
				</TD>
<%
			Next
%>
		</TR>
<%
		For i = 0 To lngCount - 1
%>
			<TR>
				<TD NOWRAP><%= Right("0000" & strDayId(i), 4) %></TD>
				<TD NOWRAP><%= strPerId(i) %></TD>
				<TD NOWRAP>
					<%= strLastName(i) & "　" & strFirstName(i) %>
					<INPUT TYPE="hidden" NAME="rsvNo"     VALUE="<%= strRsvNo(i) %>">
					<INPUT TYPE="hidden" NAME="perId"     VALUE="<%= strPerId(i) %>">
					<INPUT TYPE="hidden" NAME="dayId"     VALUE="<%= strDayId(i) %>">
					<INPUT TYPE="hidden" NAME="lastName"  VALUE="<%= strLastName(i) %>">
					<INPUT TYPE="hidden" NAME="firstName" VALUE="<%= strFirstName(i) %>">
				</TD>
<%
				For j = 0 To lngItemCount - 1

					blnFindFlg = False
					For k = 0 To lngRslCount - 1

						If strRsvNo(i) = strRslRsvNo(k) And strGrpItemCd(j) = strItemCd(k) And strGrpSuffix(j) = strSuffix(k) Then
%>
							<TD>
								<INPUT TYPE="hidden" NAME="rslRsvNo"     VALUE="<%= strRslRsvNo(k)     %>">
								<INPUT TYPE="hidden" NAME="rslLastName"  VALUE="<%= strRslLastName(k)  %>">
								<INPUT TYPE="hidden" NAME="rslFirstName" VALUE="<%= strRslFirstName(k) %>">
								<INPUT TYPE="hidden" NAME="consultFlg"   VALUE="<%= strConsultFlg(k)   %>">
								<INPUT TYPE="hidden" NAME="itemCd"       VALUE="<%= strItemCd(k)       %>">
								<INPUT TYPE="hidden" NAME="suffix"       VALUE="<%= strSuffix(k)       %>">
								<INPUT TYPE="hidden" NAME="itemName"     VALUE="<%= strItemName(k)     %>">
								<INPUT TYPE="hidden" NAME="resultType"   VALUE="<%= strResultType(k)   %>">
								<INPUT TYPE="hidden" NAME="resultErr"    VALUE="<%= strResultErr(k)    %>">
								<INPUT TYPE="hidden" NAME="stdFlg"       VALUE="<%= strStdFlg(k)       %>">
								<INPUT TYPE="hidden" NAME="initRsl"      VALUE="<%= strInitRsl(k)      %>">
<%
								'基準値フラグにより色を設定する
								Select Case strStdFlg(k)
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

								If strResultErr(k) <> "" Then
									strClass       = CLASS_ERROR
									strClassStdFlg = ""
								Else
									strClass       = ""
									strClassStdFlg = IIf(strDispStdFlgColor <> "", "STYLE=""color:" & strDispStdFlgColor & """", "")
								End If

								'計算項目でなく、かつ受診している場合
								If CLng(strResultType(k)) <> RESULTTYPE_CALC And CLng(strConsultFlg(k)) = CONSULT_ITEM_T Then

									'スタイルシートの設定
									strAlignment = IIf(CLng(strResultType(k)) = RESULTTYPE_NUMERIC, ALIGNMENT_RIGHT, "")
%>
									<INPUT TYPE="text" NAME="result" SIZE="<%= TextLength(8) %>" MAXLENGTH="8" VALUE="<%= strResult(k) %>" <%= strAlignment %> <%= strClass %> <%= strClassStdFlg %>>
<%
								Else
%>
									<INPUT TYPE="hidden" NAME="result" VALUE="<%= strResult(k) %>"><SPAN <%= strClassStdFlg %>><%= strResult(k) %></SPAN>
<%
								End If
%>
							</TD>
<%
							blnFindFlg = True
							Exit For
						End If

					Next

					If Not blnFindFlg Then
%>
						<TD>&nbsp;</TD>
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

'-----------------------------------------------------------------------------
' ページングナビゲーターの編集
'-----------------------------------------------------------------------------
Sub EditNavi()

	Dim strBasedURL			'URLの共通部

	Dim lngTotalPage		'総ページ数
	Dim lngStartPage		'開始ページ番号
	Dim lngCurrentPage		'現在ページ番号
	Dim lngPage				'ページカウンタ
	Dim lngCurrentStartPos	'URLに編集する検索開始位置
	Dim lngGetCount			'表示件数

	If Not IsNumeric(strGetCount) Then
		Exit Sub
	Else
		lngGetCount = CLng(strGetCount)
	End If

'response.write "lngAllCount=" & lngAllCount & "<BR>"
'response.write "lngGetCount=" & lngGetCount & "<BR>"

	'検索件数が表示件数以下の場合、ページングナビゲータは表示しない
	If lngAllCount <= lngGetCount Then
		Exit Sub
	End If

	'総ページ数・現在ページ番号を求める
	lngTotalPage   = Int(lngAllCount / lngGetCount) + IIf(lngAllCount Mod lngGetCount > 0, 1, 0)
	lngCurrentPage = (lngStartPos - 1) / lngGetCount + 1
	lngCurrentStartPos = (lngCurrentPage - 1) * lngGetCount + 1
	strBasedURL = "rslListSet.asp?year=" & lngYear & "&month=" & lngMonth & "&day=" & lngDay & "&grpCd=" & strGrpCd & "&sortKey=" & strSortKey & "&dayIdF=" & strDayIdF & "&getCount=" & strGetCount & "&startPos="

'response.write "lngCurrentPage=" & lngCurrentPage & "<BR>"
'response.write "lngCurrentStartPos=" & lngCurrentStartPos & "<BR>"

	If lngCurrentPage > 1 Then
%>
		<TD>
			<A HREF="<%= strBasedURL & (lngCurrentStartPos - lngGetCount) %>"><IMG SRC="/webHains/images/prevper.gif" WIDTH="77" HEIGHT="24" ALT="前の受診者を表示"></A>
		</TD>
<%
	End If
	If lngCurrentPage < lngTotalPage Then
%>
		<TD>
			<A HREF="<%= strBasedURL & (lngCurrentStartPos + lngGetCount) %>"><IMG SRC="/webHains/images/nextper.gif" WIDTH="77" HEIGHT="24" ALT="次の受診者を表示"></A>
		</TD>
<%
	End If

End Sub

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>ワークシート形式の結果入力</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
function goNextPage() {

	document.rslListSet.submit();
	
	return false;
}

// 保存処理
function saveData() {

	// 条件を変更前の状態に戻す
	document.rslListSet.year.value = '<%= lngYear %>';
	document.rslListSet.month.value = '<%= lngMonth %>';
	document.rslListSet.day.value = '<%= lngDay %>';
	document.rslListSet.grpCd.value = '<%= strGrpCd %>';
	document.rslListSet.sortkey.value = '<%= strSortKey %>';
	document.rslListSet.dayIdF.value = '<%= strDayIdF %>';
	document.rslListSet.getCount.value = '<%= strGetCount %>';

	document.rslListSet.act.value = 'save';
	document.rslListSet.submit();
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/mensetsutable.css">
<STYLE TYPE="text/css">
	td.rsltab  { background-color:#FFFFFF }
	input[name="result"] { width:100% }
	table.mensetsu-tb { margin: 10px 0; border-top: 1px solid #ccc;}
	div.maindiv { margin: 10px 10px 0 10px; }
</STYLE>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="rslListSet" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<div class="maindiv">
<INPUT TYPE="hidden" NAME="act" VALUE="select">
<INPUT TYPE="hidden" NAME="allCountUseSave" VALUE="<%= lngAllCount %>">
<INPUT TYPE="hidden" NAME="startPosUseSave" VALUE="<%= lngStartPos %>">
<!-- 表題 -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">ワークシート形式の結果入力</FONT></B></TD>
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

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1">
		<TR>
			<TD>受診日：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('year', 'month', 'day')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("year", YEARRANGE_MIN, YEARRANGE_MAX, lngYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("month", 1, 12, lngMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("day", 1, 31, lngDay, False) %></TD>
			<TD>日</TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1">
		<TR>
			<TD><%= EditGrpIList_GrpDiv("grpCd", strGrpCd, "", "", "") %></TD>
			<TD>の結果を</TD>
			<TD><%= EditSortKeyList("sortkey", strSortKey) %></TD>
			<TD>番号</TD>
			<TD><INPUT TYPE="text" NAME="dayIdF" SIZE="<%= TextLength(4) %>" MAXLENGTH="4" VALUE="<%= strDayIdF %>"></TD>
			<TD>から</TD>
			<TD><%= EditRslPageMaxLineList("getCount", strGetCount) %></TD>
			<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="javascript:goNextPage();return false;"><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="指定条件で表示"></A></TD>
		</TR>
	</TABLE>

	<BR>
<%
	Call EditRslList
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="180">
		<TR>
<%
			Call EditNavi()

			If lngUpdItemCount > 0 Then
%>
				<TD>
				<% '2005.08.22 権限管理 Add by 李　--- START %>
	           	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>  	
					<A HREF="javascript:saveData()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存"></A>
				<%  else    %>
					 &nbsp;
				<%  end if  %>
				<% '2005.08.22 権限管理 Add by 李　--- END %>
				</TD>
<%
			End If
%>
		</TR>
	</TABLE>
</div>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
