<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		判定入力 (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const ACTMODE_PREVIOUS = "previous"	'動作モード(前受診者へ)
Const ACTMODE_NEXT     = "next"		'動作モード(次受診者へ)
Const ACTMODE_SAVE     = "save"		'動作モード(保存)
Const ACTMODE_SAVEEND  = "saveend"	'動作モード(保存完了)

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objConsult			'受診情報アクセス用
Dim objJudgeMent		'判定結果アクセス用
Dim objJudgementControl	'判定結果アクセス用
Dim objJud				'判定アクセス用

'前画面から送信されるパラメータ値
Dim strActMode			'動作モード
Dim lngCslYear			'受診日(年)
Dim lngCslMonth			'受診日(月)
Dim lngCslDay			'受診日(日)
Dim strCntlNo			'管理番号
Dim strDayId			'当日ID
Dim strKeyCsCd			'コースコード
Dim strSortKey			'表示順
Dim strBadJud			'「判定の悪い人」
Dim strUnFinished		'「判定未完了者」
Dim strNoPrevNext		'前後受診者への遷移を行わない

'保存時のみ送信されるパラメータ値
Dim strRsvNo			'予約番号

'受診者情報
Dim strPerId			'個人ＩＤ
Dim strCslDate			'受診日
Dim strCsCd				'コースコード
Dim strCsName			'コース名
Dim strLastName			'姓
Dim strFirstName		'名
Dim strLastKName		'カナ姓
Dim strFirstKName		'カナ名
Dim strBirth			'生年月日
Dim strAge				'年齢
Dim strGender			'性別
Dim strDoctorCd			'医師コード
Dim strDoctorName		'医師名

'判定結果情報
Dim strJudClassCd		'判定分類コード
Dim strJudClassName		'判定分類名称
Dim strNoReason			'無条件展開フラグ(0:展開しない 1:展開する)
Dim strJudCd			'判定コード
Dim strBefJudSName		'前回判定名称
Dim strJudDoctorCd		'判定医コード
Dim strJudDoctorName	'判定医名
Dim strFreeJudCmt		'フリー判定コメント

' ★Updated 2002.11.18
Dim strJudCmtCd			'判定コメントコード
Dim strJudCmtStc		'判定コメント
Dim strGuidanceCd		'指導内容コード
Dim strGuidanceStc		'指導内容

Dim strStdJudCd			'定型所見コード
Dim strStdJudNote		'定型所見名称
Dim strArrStdJudCd		'定型所見コードの配列
Dim strArrStdJudNote	'定型所見名称の配列
Dim lngAllCount			'全レコード件数

Dim strInitdoctorCd		'初期読み込み状態の総合判定医
Dim strInitJudCd		'初期読み込み状態の判定
Dim strInitStdJudCd		'初期読み込み状態の定型所見
Dim strInitFreeJudCmt	'初期読み込み状態のフリー判定コメント
Dim strInitJudDoctorCd	'初期読み込み状態の判定医コード

' ★Updated 2002.11.18
Dim strInitJudCmtCd		'初期読み込み状態の判定コメントコード
Dim strInitGuidanceCd	'初期読み込み状態の指導内容コード

Dim strClearJudDoctor	'0:判定医現状維持、1:判定コードクリア
Dim blnUpdated			'TRUE:変更あり、FALSE:変更なし
Dim i					'インデックス

'実際に更新する項目情報を格納した検査結果
Dim strUpdJudClassCd	'判定分類コード	
Dim strUpdJudCd			'判定コード
Dim strUpdStdJudCd		'定型所見コード			--- 臨海未使用(2002.03.26)
Dim strUpdFreeJudCmt	'フリー判定コメント
Dim strUpdJudDoctorCd	'判定医コード
Dim strUpdJudCmtCd      '判定コメントコード
Dim strUpdGuidanceCd    '指導文章コード
Dim lngUpdCount			'更新項目数

Dim strElementName		'エレメント名
Dim strMessage			'エラーメッセージ
Dim lngMessageType		'メッセージの属性
Dim strSecondFlg		'２次健診表示フラグ
Dim dtmCslDate			'受診日
Dim strPrevRsvNo		'(前受診者の)予約番号
Dim strPrevDayId		'(前受診者の)当日ID
Dim strNextRsvNo		'(次受診者の)予約番号
Dim strNextDayId		'(次受診者の)当日ID
Dim blnExists			'受診情報の有無
Dim strHTML				'HTML文字列
Dim strURL				'ジャンプ先のURL

Dim strArrJudCd			'判定コード
Dim strArrJudSName		'判定略称
Dim lngJudCount			'判定数
Dim lngJudIndex			'判定インデックス
Dim strDispJudSName		'判定略称
Dim j					'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon           = Server.CreateObject("HainsCommon.Common")
Set objConsult          = Server.CreateObject("HainsConsult.Consult")
Set objJudgement        = Server.CreateObject("HainsJudgement.Judgement")
Set objJudgementControl = Server.CreateObject("HainsJudgement.JudgementControl")
Set objJud              = Server.CreateObject("HainsJud.Jud")

'全判定を読み込む
lngJudCount = objJud.SelectJudList(strArrJudCd, strArrJudSName)

'引数値の取得
strActMode    = Request("actMode")
lngCslYear    = Request("cslYear")
lngCslMonth   = Request("cslMonth")
lngCslDay     = Request("cslDay")
strCntlNo     = Request("cntlNo")
strDayId      = Request("dayId")
strKeyCsCd    = Request("csCd")
strSortKey    = Request("sortKey")
strBadJud     = Request("badJud")
strUnFinished = Request("unFinished")
strNoPrevNext = Request("noPrevNext")

'受診日の取得
dtmCslDate = CDate(lngCslYear & "/" & lngCslMonth & "/" & lngCslDay)

'「２次健診は表示しない」フラグ取得
strSecondFlg = objCommon.SelectBefJudCourseFlg()

'保存時のみ送信されるパラメータ値の取得
strRsvNo         = Request("rsvNo")
strDoctorCd      = Request("doctorCd")
strInitdoctorCd  = Request("initdoctorCd")

'判定結果情報の取得
strJudClassCd      = ConvIStringToArray(Request("judClassCd"))
strJudClassName    = ConvIStringToArray(Request("judClassName"))
strNoReason        = ConvIStringToArray(Request("noReason"))
strJudCd           = ConvIStringToArray(Request("judCd"))
strBefJudSName     = ConvIStringToArray(Request("befJudSName"))
strJudDoctorCd     = ConvIStringToArray(Request("judDoctorCd"))
strJudDoctorName   = ConvIStringToArray(Request("judDoctorName"))
'## 2003.03.07 Mod 6Lines By T.Takagi@FSIT カンマ対策
'strFreeJudCmt      = ConvIStringToArray(Request("freeJudCmt"))
strFreeJudCmt = Array()
ReDim Preserve strFreeJudCmt(Request("freeJudCmt").Count - 1)
For i = 1 To Request("freeJudCmt").Count
	strFreeJudCmt(i - 1) = Request("freeJudCmt")(i)
Next
'## 2003.03.07 Mod End

strStdJudCd        = ConvIStringToArray(Request("stdJudCd"))
strStdJudNote      = ConvIStringToArray(Request("stdJudNote"))
strInitJudCd       = ConvIStringToArray(Request("initJudCd"))
strInitStdJudCd    = ConvIStringToArray(Request("initStdJudCd"))
'## 2003.03.07 Mod 6Lines By T.Takagi@FSIT カンマ対策
'strInitFreeJudCmt  = ConvIStringToArray(Request("initFreeJudCmt"))
strInitFreeJudCmt = Array()
ReDim Preserve strInitFreeJudCmt(Request("initFreeJudCmt").Count - 1)
For i = 1 To Request("initFreeJudCmt").Count
	strInitFreeJudCmt(i - 1) = Request("initFreeJudCmt")(i)
Next
'## 2003.03.07 Mod End

strInitJudDoctorCd = ConvIStringToArray(Request("initJudDoctorCd"))
strClearJudDoctor  = ConvIStringToArray(Request("clearJudDoctor"))

' ★Updated 2002.11.18
strJudCmtCd        = ConvIStringToArray(Request("JudCmtCd"))
strGuidanceCd      = ConvIStringToArray(Request("GuidanceCd"))
strInitJudCmtCd    = ConvIStringToArray(Request("initJudCmtCd"))
strInitGuidanceCd  = ConvIStringToArray(Request("initGuidanceCd"))

' ★Updated 2002.12.17
strJudCmtStc       = ConvIStringToArray(Request("judCmtStc"))
strGuidanceStc     = ConvIStringToArray(Request("guidanceStc"))

lngAllCount = CLng("0" & Request("allCount"))

'チェック・更新・読み込み処理の制御
Do

	Do
		'各モードごとの処理分岐
		Select Case strActMode

			'保存ボタン押下時
			Case ACTMODE_SAVE

				If lngAllCount > 0 Then

					'実際に更新を行う項目のみを抽出(初期表示データと異なるデータが更新対象)
					lngUpdCount = 0
					strUpdJudClassCd  = Array()
					strUpdJudCd       = Array()
					strUpdStdJudCd    = Array()
					strUpdJudDoctorCd = Array()
					strUpdFreeJudCmt  = Array()
					strUpdJudCmtCd    = Array()
					strUpdGuidanceCd  = Array()

					For i = 0 To UBound(strJudClassCd)

						'判定、フリー判定コメント、定型所見、判定医、何れかが更新されていたらデータ更新
						blnUpdated = False
						If ( strJudCd(i)       <> strInitJudCd(i) ) Or _
						   ( strFreeJudCmt(i)  <> strInitFreeJudCmt(i) ) Or _
						   ( strJudDoctorCd(i) <> strInitJudDoctorCd(i) ) Or _
						   ( strJudCmtCd(i)    <> strInitJudCmtCd(i) ) Or _
						   ( strGuidanceCd(i)  <> strInitGuidanceCd(i) ) Then
							blnUpdated = True
						End If

						'データ更新状態なら配列を拡張して保存状態をセット
						If blnUpdated = True Then

							ReDim Preserve strUpdJudClassCd(lngUpdCount)
							ReDim Preserve strUpdJudCd(lngUpdCount)
							ReDim Preserve strUpdStdJudCd(lngUpdCount)
							ReDim Preserve strUpdFreeJudCmt(lngUpdCount)
							ReDim Preserve strUpdJudDoctorCd(lngUpdCount)
							ReDim Preserve strUpdJudCmtCd(lngUpdCount)
							ReDim Preserve strUpdGuidanceCd(lngUpdCount)

							strUpdJudClassCd(lngUpdCount)  = strJudClassCd(i)
							strUpdJudCd(lngUpdCount)       = strJudCd(i)
							strUpdStdJudCd(lngUpdCount)    = strStdJudCd(i)
							strUpdFreeJudCmt(lngUpdCount)  = strFreeJudCmt(i)
							strUpdJudCmtCd(lngUpdCount)    = strJudCmtCd(i)
							strUpdGuidanceCd(lngUpdCount)  = strGuidanceCd(i)

							'判定医が空白、かつ意図的に消してないなら、ログインユーザセット
							If ( Trim(strJudDoctorCd(i)) = "" ) And ( strClearJudDoctor(i) <> "1" ) Then
								strJudDoctorCd(i) = Session("userid")
							End If
							strUpdJudDoctorCd(lngUpdCount) = strJudDoctorCd(i)

							lngUpdCount = lngUpdCount + 1

						End If
					Next

					'判定入力チェック
					strMessage = objJudgement.CheckValue(strDoctorCd, strJudClassCd, strJudClassName, strJudCd, strStdJudCd, strFreeJudCmt, strJudDoctorCd)
					If Not IsEmpty(strMessage) Then
						lngMessageType = MESSAGETYPE_WARNING
						Exit Do
					End If

					'総合判定医のみ更新された場合、配列に更新されない値をセット
					If ( lngUpdCount < 1 ) And ( strdoctorCd <> strInitdoctorCd ) Then

						ReDim Preserve strUpdJudClassCd(lngUpdCount)
						ReDim Preserve strUpdJudCd(lngUpdCount)
						ReDim Preserve strUpdStdJudCd(lngUpdCount)
						ReDim Preserve strUpdFreeJudCmt(lngUpdCount)
						ReDim Preserve strUpdJudDoctorCd(lngUpdCount)

						strUpdJudClassCd(lngUpdCount)  = "XXXXX"
						strUpdJudCd(lngUpdCount)       = ""
						strUpdStdJudCd(lngUpdCount)    = ""
						strUpdFreeJudCmt(lngUpdCount)  = ""
						strUpdJudDoctorCd(lngUpdCount) = ""

					End If

					'更新対象データが存在するときのみ判定結果保存
					If ( lngUpdCount > 0 ) Or ( strdoctorCd <> strInitdoctorCd ) Then
						objJudgementControl.UpdateJudRsl strRsvNo, strDoctorCd, Session("USERID"), strUpdJudClassCd, strUpdJudCd, strUpdJudDoctorCd, strUpdFreeJudCmt, strUpdStdJudCd, strUpdJudCmtCd, strUpdGuidanceCd
					End If

				End If

				'エラーがなければ親フレームREPLACE用のURLを編集
				strURL = "judMain.asp"
				strURL = strURL & "?actMode="    & ACTMODE_SAVEEND
				strURL = strURL & "&cslYear="    & lngCslYear
				strURL = strURL & "&cslMonth="   & lngCslMonth
				strURL = strURL & "&cslDay="     & lngCslDay
				strURL = strURL & "&cntlNo="     & strCntlNo
				strURL = strURL & "&dayId="      & strDayId
				strURL = strURL & "&csCd="       & strKeyCsCd
				strURL = strURL & "&sortKey="    & strSortKey
				strURL = strURL & "&badJud="     & strBadJud
				strURL = strURL & "&unFinished=" & strUnFinished
				strURL = strURL & "&noPrevNext=" & strNoPrevNext

				'親フレームのURLをREPLACEする
				strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
				strHTML = strHTML & "<BODY ONLOAD=""JavaScript:top.location.replace('" & strURL & "')"">"
				strHTML = strHTML & "</BODY>"
				strHTML = strHTML & "</HTML>"
				Response.Write strHTML
				Response.End

			'保存完了時
			Case ACTMODE_SAVEEND

				'保存完了メッセージを編集する
				strMessage     = "保存が完了しました。"
				lngMessageType = MESSAGETYPE_NORMAL

		End Select

		Exit Do
	Loop

	'受付情報をもとに受診情報を読み込む
	blnExists = objConsult.SelectConsultFromReceipt(dtmCslDate,    _
													strCntlNo,     _
													strDayId,      _
													strRsvNo,      _
													strCslDate,    _
													strPerID,      _
													strLastName,   _
													strFirstName,  _
													strLastKName,  _
													strFirstKName, _
													strBirth,      _
													strGender,     _
													strCsCd,       _
													strCsName,     _
													strAge,        _
													strDoctorCd,   _
									 				strDoctorName)

	'受診情報が存在しない場合はエラーとする
	If blnExists = False Then
		strMessage     = "受診情報が存在しません。"
		lngMessageType = MESSAGETYPE_WARNING
		Exit Do
	End If

	'保存モードでチェックエラーが発生した場合はテーブルから読み込まない
	If strActMode = ACTMODE_SAVE And Not IsEmpty(strMessage) Then
		Exit Do
	End If

	'検索条件を満たす判定結果を取得
	lngAllCount = objJudgement.SelectJudRslList(strRsvNo, _
												strCsCd, _
												strSecondFlg, _
												strJudClassCd, _
												strJudClassName, _
												strNoReason, _
												strJudCd, _
												strBefJudSName, _
												strJudDoctorCd, _
												strJudDoctorName, _
												strFreeJudCmt, _
												strStdJudCd, _
												strStdJudNote, _
												strJudCmtCd, _
												strJudCmtStc, _
												strGuidanceCd, _
												strGuidanceStc)

	'読み込んだ直後の判定情報を初期状態の配列として保持
	strInitJudCd       = strJudCd
	strInitFreeJudCmt  = strFreeJudCmt
	strInitJudDoctorCd = strJudDoctorCd
	strInitdoctorCd    = strDoctorCd
	strInitJudCmtCd    = strJudCmtCd
	strInitGuidanceCd  = strGuidanceCd

	'判定情報が存在しない場合はメッセージを編集する
	If lngAllCount = 0 Then
		strMessage     = "表示すべき判定情報が存在しません。"
		lngMessageType = MESSAGETYPE_WARNING
	End If

	Exit Do
Loop

'-------------------------------------------------------------------------------
' 判定結果一覧の編集
'-------------------------------------------------------------------------------
Sub EditJudRslList()

	Dim strURL	'ジャンプ先のURL
	Dim i		'インデックス
	Dim j		'インデックス

	'対象データが存在しない場合は何もしない
	If lngAllCount = 0 Then
		Exit Sub
	End If
%>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR BGCOLOR="#eeeeee">
			<TD>分野</TD>
			<TD>判定</TD>
			<TD>コメント／指導内容</TD>
		</TR>
<%
		For i = 0 To lngAllCount - 1

			strElementName = "stcName" & i
%>
			<TR>
				<TD VALIGN="top" NOWRAP>
					<INPUT TYPE="hidden" NAME="judClassCd"      VALUE="<%= strJudClassCd(i)      %>">
					<INPUT TYPE="hidden" NAME="judClassName"    VALUE="<%= strJudClassName(i)    %>">
					<INPUT TYPE="hidden" NAME="noReason"        VALUE="<%= strNoreason(i)        %>">
					<INPUT TYPE="hidden" NAME="stdJudCd"        VALUE="<%= strStdJudCd(i)        %>">
					<INPUT TYPE="hidden" NAME="stdJudNote"      VALUE="<%= strStdJudNote(i)      %>">
					<INPUT TYPE="hidden" NAME="befJudSName"     VALUE="<%= strBefJudSName(i)     %>">
					<INPUT TYPE="hidden" NAME="initJudCd"       VALUE="<%= strInitJudCd(i)       %>">
					<INPUT TYPE="hidden" NAME="initFreeJudCmt"  VALUE="<%= strInitFreeJudCmt(i)  %>">
					<INPUT TYPE="hidden" NAME="initJudDoctorCd" VALUE="<%= strInitJudDoctorCd(i) %>">
					<INPUT TYPE="hidden" NAME="clearJudDoctor"  VALUE="0">
					<INPUT TYPE="hidden" NAME="initJudCmtCd"    VALUE="<%= strInitJudCmtCd(i)   %>">
					<INPUT TYPE="hidden" NAME="initGuidanceCd"  VALUE="<%= strInitGuidanceCd(i) %>">
					<INPUT TYPE="hidden" NAME="judCmtCd"        VALUE="<%= strJudCmtCd(i)       %>">
					<INPUT TYPE="hidden" NAME="guidanceCd"      VALUE="<%= strGuidanceCd(i)     %>">
					<INPUT TYPE="hidden" NAME="judCmtStc"       VALUE="<%= strJudCmtStc(i)      %>">
					<INPUT TYPE="hidden" NAME="guidanceStc"     VALUE="<%= strGuidanceStc(i)    %>">
					<INPUT TYPE="hidden" NAME="judCd"           VALUE="<%= strJudCd(i)          %>">
					<IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3" BORDER="0" ALT=""><BR>
<%
					'判定分類
					If strNoreason(i) = "0" Then
%>
						<A HREF="javascript:showRslHistory('<%= strJudClassCd(i) %>')"><B><%= strJudClassName(i) %></B></A><BR>
<%
					Else
%>
						<B><FONT COLOR="#666666"><%= strJudClassName(i) %></FONT></B>
<%
					End If
%>
				</TD>
				<!-- 判定 -->
				<TD WIDTH="125" VALIGN="top">
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
							<TD><A HREF="javascript:callJudGuide(<%= i %>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="判定コメントガイドを表示します"></A></TD>
							<TD><A HREF="javascript:deleteJudInfo(<%= i %>)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="選択した判定コメントを削除します"></A></TD>
<%
							strElementName = "JudSName" & CStr(i)
							lngJudIndex = -1
							strDispJudSName = ""
							For j = 0 To lngJudCount - 1
								If strArrJudCd(j) = strJudCd(i) Then
									lngJudIndex = j
									Exit For
								End If
							Next

							If lngJudIndex >= 0 Then
								strDispJudSName = strArrJudSName(lngJudIndex)
							Else
								strDispJudSName = strJudCd(i)
							End If
%>
							<TD NOWRAP><SPAN ID="<%= strElementName %>"><%= strDispJudSName %></SPAN></TD>
						</TR>
					</TABLE>
				</TD>
				<!-- 判定コメント（固定） -->
				<TD>
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR VALIGN="top">
							<TD><A HREF="javascript:callJcmGuide(<%= i %>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="判定コメントガイドを表示します"></A></TD>
							<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return clearJudCmtCd(<%= i %>)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="選択した判定コメントを削除します"></A></TD>
<%
							strElementName = "JudCmtStc" & CStr(i)
%>
							<TD>
								<IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3" BORDER="0" ALT=""><BR>
								<SPAN ID="<%= strElementName %>"><%= strJudCmtStc(i) %></SPAN>
							</TD>
						</TR>
						<!-- 判定コメント（ワープロ） -->
						<TR>
							<TD COLSPAN="2"></TD>
							<TD><TEXTAREA NAME="freeJudCmt" COLS="50" ROWS="2"><%= strFreeJudCmt(i) %></TEXTAREA></TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
			<TR>
				<TD COLSPAN="2" NOWRAP>
					<FONT SIZE="-1"><%= IIf(strBefJudSName(i) = "", "", "前回：" & strBefJudSName(i)) %></FONT>
					<!-- 定型所見（一応置いておかないとエラーになるため） -->
					<SELECT NAME="stdJudList" SIZE="3" STYLE="width:0;height:0;"></SELECT>
				</TD>
				<TD>
					<!-- 指導文章 -->
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR VALIGN="top">
							<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return callGuidanceGuide(<%= i %>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="指導文章ガイドを表示します"></A></TD>
							<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return clearGuidanceCd(<%= i %>)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="選択した指導文章を削除します"></A></TD>
<%
							strElementName = "GuidanceStc" & CStr(i)
%>
							<TD>
								<IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3" BORDER="0" ALT=""><BR>
								<SPAN ID="<%= strElementName %>"><%= strGuidanceStc(i) %></SPAN>
							</TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
			<TR>
				<TD COLSPAN="2">
					<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
						<TR>
<%
							'結果入力画面のURL編集
							strURL = "/webHains/contents/result/rslMain.asp"
							strURL = strURL & "?rsvNo="      & strRsvNo
							strURL = strURL & "&mode="       & "1"
							strURL = strURL & "&code="       & strJudClassCd(i)
							strURL = strURL & "&cslYear="    & lngCslYear
							strURL = strURL & "&cslMonth="   & lngCslMonth
							strURL = strURL & "&cslDay="     & lngCslDay
							strURL = strURL & "&dayId="      & strDayId
							strURL = strURL & "&noPrevNext=" & "1"
%>
							<TD><A HREF="<%= strURL %>" TARGET="_blank"><IMG SRC="/webHains/images/result.gif" WIDTH="21" HEIGHT="21" ALT="結果入力画面へ移動します"></A></TD>
							<TD><A HREF="<%= strURL %>" TARGET="_blank"><SPAN STYLE="font-size:10px">この判定の結果入力</SPAN></A></TD>
						<TR>
					</TABLE>
				</TD>
				<!-- 判定医 -->
				<TD ALIGN="right">
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
							<TD>
								<INPUT TYPE="hidden" NAME="judDoctorCd" VALUE="<%= strJudDoctorCd(i) %>">
								<INPUT TYPE="hidden" NAME="judDoctorName" VALUE="<%= strJudDoctorName(i) %>">
<%
								strElementName = "docName" & CStr(i)
%>
								<SPAN ID="<%= strElementName %>" STYLE="position:relative;font-weight:bolder;color:#999999"><%= strJudDoctorName(i) %></SPAN>
							</TD>
							<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return callJudDocGuide(<%= i %>)"><IMG SRC="/webHains/images/doctor.gif" WIDTH="77" HEIGHT="24" ALT="<%= strJudClassName(i) %>の判定医師を指定します"></A></TD>
							<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return setJudDoctor(<%= i %>, '1')"><IMG SRC="/webHains/images/disme.gif" WIDTH="21" HEIGHT="21" ALT="現在のログインユーザを判定医にセットします"></TD>
							<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return setJudDoctor(<%= i %>, '0')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="<%= strJudClassName(i) %>の判定医師をクリアします"></A></TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
			<TR><TD COLSPAN="3" HEIGHT="1" BGCOLOR="#FFFFFF"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="2"></TD></TR>
			<TR><TD COLSPAN="3" HEIGHT="1" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD></TR>
			<TR><TD COLSPAN="3" HEIGHT="1" BGCOLOR="#FFFFFF"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="2"></TD></TR>
<%
		Next
%>
<!--
		<TR>
			<TD ALIGN="RIGHT" COLSPAN="6">
				<A HREF="javascript:function voi(){};voi()" ONCLICK="return goNextPage()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存"></A>
			</TD>
		</TR>
-->
	</TABLE>
<%
End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>判定入力</TITLE>
<!-- #include virtual = "/webHains/includes/jcmGuide.inc" -->
<!-- #include virtual = "/webHains/includes/judGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/docGuide.inc" -->
<!-- #include virtual = "/webHains/includes/obsGuide.inc" -->
<!-- #include virtual = "/webHains/includes/guidanceGuide.inc" -->
<!--
var lngSelectedIndex;	// ガイド表示時に選択されたエレメントのインデックス
var winJudHistory;		// 判定歴ウインドウハンドル
var winPerInspection;	// 個人検査情報ウインドウハンドル

// 判定ガイド呼び出し
function callJudGuide( index ) {

	if ( document.judgement.judCd.length != null ) {
		judGuide_ShowGuideJud( document.judgement.judCd[ index ], 'JudSName' + index );
	} else {
		judGuide_ShowGuideJud( document.judgement.judCd, 'JudSName' + index );
	}

}

// 判定の削除
function deleteJudInfo( index ) {

	if ( document.judgement.judCd.length != null ) {
		judGuide_clearJudInfo( document.judgement.judCd[ index ], 'JudSName' + index );
	} else {
		judGuide_clearJudInfo( document.judgement.judCd, 'JudSName' + index );
	}

}

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
	document.judgement.doctorCd.value = docGuide_DoctorCd;
	document.judgement.doctorName.value = docGuide_DoctorName;

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

	document.judgement.doctorCd.value = '';
	document.judgement.doctorName.value = '';

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

// 判定医師名ガイド呼び出し
function callJudDocGuide( index ) {

	// 選択されたエレメントのインデックスを退避(医師コード・医師名のセット用関数にて使用する)
	lngSelectedIndex = index;

	// ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
	docGuide_CalledFunction = setJudDocInfo;

	// 判定医師名ガイド表示
	showGuideDoc();

	return false;
}

// 医師コード・医師名のセット
function setJudDocInfo() {

	var docNameElement;	/* 医師名を編集するエレメントの名称 */
	var docName;		/* 医師名を編集するエレメント自身 */

	// 予め退避したインデックス先のエレメントに、ガイド画面で設定された連絡域の値を編集
	if ( document.judgement.judDoctorCd.length != null ) {
		document.judgement.judDoctorCd[lngSelectedIndex].value = docGuide_DoctorCd;
	} else {
		document.judgement.judDoctorCd.value = docGuide_DoctorCd;
	}
	if ( document.judgement.judDoctorName.length != null ) {
		document.judgement.judDoctorName[lngSelectedIndex].value = docGuide_DoctorName;
	} else {
		document.judgement.judDoctorName.value = docGuide_DoctorName;
	}
	if ( document.judgement.clearJudDoctor.length != null ) {
		document.judgement.clearJudDoctor[lngSelectedIndex].value = '0';
	} else {
		document.judgement.clearJudDoctor.value = '0';
	}

	// ブラウザごとの団体名編集用エレメントの設定処理
	for ( ; ; ) {

		// エレメント名の編集
		docNameElement = 'docName' + lngSelectedIndex;

		// IEの場合
		if ( document.all ) {
			document.all(docNameElement).innerHTML = '' + docGuide_DoctorName;
			break;
		}

		// Netscape6の場合
		if ( document.getElementById ) {
			document.getElementById(docNameElement).innerHTML = '' + docGuide_DoctorName;
		}

		break;
	}

	return false;
}

// 判定医コード・判定医師名のクリア
function setJudDoctor( index, loginmode ) {

	var newcd
	var newname

	if ( loginmode == '0' ) {
		newcd   = '';
		newname = '';
	} else {
		newcd   = document.judgement.logIn.value;
		newname = document.judgement.logInName.value;
	}

	if ( document.judgement.judDoctorCd.length != null ) {
		document.judgement.judDoctorCd[index].value = newcd;
	} else {
		document.judgement.judDoctorCd.value = newcd;
	}

	if ( document.judgement.judDoctorName.length != null ) {
		document.judgement.judDoctorName[index].value = newname;
	} else {
		document.judgement.judDoctorName.value = newname;
	}

	if ( document.judgement.clearJudDoctor.length != null ) {
		document.judgement.clearJudDoctor[index].value = '1';
	} else {
		document.judgement.clearJudDoctor.value = '1';
	}

	// ブラウザごとの団体名編集用エレメントの設定処理
	for ( ; ; ) {

		// エレメント名の編集
		docNameElement = 'docName' + index;

		// IEの場合
		if ( document.all ) {
			document.all(docNameElement).innerHTML = newname;
			break;
		}

		// Netscape6の場合
		if ( document.getElementById ) {
			document.getElementById(docNameElement).innerHTML = newname;
		}

		break;
	}

	return false;
}

// 指導文章ガイド呼び出し
function callGuidanceGuide( index ) {

	// 選択されたエレメントのインデックスを退避
	lngSelectedIndex = index;

	if ( document.judgement.judClassCd.length != null ) {
		guidanceGuide_JudClassCd = document.judgement.judClassCd[index].value;
	} else {
		guidanceGuide_JudClassCd = document.judgement.judClassCd.value;
	}

	// ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
	guidanceGuide_CalledFunction = setGuidanceStcInfo;

	// 判定医師名ガイド表示
	showGuideGuidance();

	return false;
}

// 指導文章のセット
function setGuidanceStcInfo() {

	var guidanceStcElement;

	// 予め退避したインデックス先のエレメントに、ガイド画面で設定された連絡域の値を編集
	if ( document.judgement.guidanceCd.length != null ) {
		document.judgement.guidanceCd[lngSelectedIndex].value = guidanceGuide_GuidanceCd;
		document.judgement.guidanceStc[lngSelectedIndex].value = guidanceGuide_GuidanceStc;
	} else {
		document.judgement.guidanceCd.value = guidanceGuide_GuidanceCd;
		document.judgement.guidanceStc.value = guidanceGuide_GuidanceStc;
	}

	// ブラウザごとの団体名編集用エレメントの設定処理
	for ( ; ; ) {

		// エレメント名の編集
		guidanceStcElement = 'GuidanceStc' + lngSelectedIndex;

		// IEの場合
		if ( document.all ) {
			document.all(guidanceStcElement).innerHTML = guidanceGuide_GuidanceStc;
			break;
		}

		// Netscape6の場合
		if ( document.getElementById ) {
			document.getElementById(guidanceStcElement).innerHTML = guidanceGuide_GuidanceStc;
		}

		break;
	}

	return false;
}

// 指導文章のクリア
function clearGuidanceCd( index ) {

	var guidanceStcElement;

	if ( document.judgement.guidanceCd.length != null ) {
		document.judgement.guidanceCd[index].value = '';
		document.judgement.guidanceStc[index].value = '';
	} else {
		document.judgement.guidanceCd.value = '';
		document.judgement.guidanceStc.value = '';
	}

	// ブラウザごとの編集用エレメントの設定処理
	for ( ; ; ) {

		// エレメント名の編集
		guidanceStcElement = 'GuidanceStc' + index;

		// IEの場合
		if ( document.all ) {
			document.all(guidanceStcElement).innerHTML = '';
			break;
		}

		// Netscape6の場合
		if ( document.getElementById ) {
			document.getElementById(guidanceStcElement).innerHTML = '';
		}

		break;
	}

	return false;
}

// 判定コメントガイド呼び出し
function callJcmGuide( index ) {

	var myForm = document.judgement;	// 自画面のフォームエレメント

	var judClassCd;		// 判定分類コード
	var judCmtCd;		// 判定コメントコード
	var judCmtStc;		// 判定コメント文章
	var freeJudCmtStc;	// 判定コメント文章(フリー入力用)
	var guidanceCd;		// 指導内容コード
	var guidanceStc;	// 指導内容
	var judCd;			// 判定コード
	var judSName;		// 略称

	// 引数の設定
	if ( myForm.judClassCd.length != null ) {
		judClassCd    = myForm.judClassCd[ index ].value;
		judCmtCd      = myForm.judCmtCd[ index ];
		freeJudCmtStc = myForm.freeJudCmt[ index ];
		guidanceCd    = myForm.guidanceCd[ index ];
		judCd         = myForm.judCd[ index ];
	} else {
		judClassCd    = myForm.judClassCd.value;
		judCmtCd      = myForm.judCmtCd;
		freeJudCmtStc = myForm.freeJudCmt;
		guidanceCd    = myForm.guidanceCd;
		judCd         = myForm.judCd;
	}

	judCmtStc   = 'JudCmtStc' + index;
	guidanceStc = 'GuidanceStc' + index;
	judSName    = 'JudSName' + index;

	// 判定コメントガイド表示
	jcmGuide_ShowGuideJcm( judClassCd, judCmtCd, judCmtStc, freeJudCmtStc, guidanceCd, guidanceStc, judCd, judSName );

}

// 判定コメントコードのクリア
function clearJudCmtCd( index ) {


	if ( document.judgement.judCmtCd.length != null ) {
		jcmGuide_clearJudCmtInfo( document.judgement.judCmtCd[ index ], 'JudCmtStc' + index );
// 2003.03.01 Added by Ishihara@FSIT
		document.judgement.freeJudCmt[ index ].value = '';
	} else {
		jcmGuide_clearJudCmtInfo( document.judgement.judCmtCd, 'JudCmtStc' + index );
// 2003.03.01 Added by Ishihara@FSIT
		document.judgement.freeJudCmt.value = '';
	}

}

// 保存処理
function goNextPage() {

	var stdJudList;
	var stdJudCd;
	var stdJudNote;

	var i;
	var j;

	for ( i = 0; i < document.judgement.allCount.value; i++ ) {

		// 各項目の配列を作成
		stdJudCd   = new Array();
		stdJudNote = new Array();

		stdJudList = document.judgement.stdJudList[i];

		if ( stdJudList != null ) {
			for ( j = 0; j < stdJudList.length; j++ ) {
				stdJudCd[stdJudCd.length] = stdJudList.options[j].value;
				stdJudNote[stdJudNote.length] = stdJudList.options[j].text;
			}
			document.judgement.stdJudCd[i].value   = stdJudCd.join(",");
			document.judgement.stdJudNote[i].value = stdJudNote.join(",");
		}

	}

	document.judgement.submit();

	return false;
}

// 結果～時系列表示表示
function showRslHistory( judClassCd ) {

	var url;	// URL文字列

	// 時系列表示のURL編集
	url = '/webHains/contents/result/rslHistory.asp';
	url = url + '?rsvNo=<%= strRsvNo %>';
	url = url + '&gender=<%= strGender %>';
	url = url + '&secondFlg=<%= strSecondFlg %>';

	// 判定分類コード指定時は引数に追加し、未指定時は全項目指定を行う
	if ( judClassCd != null ) {
		url = url + '&judClassCd=' + judClassCd;
	} else {
		// 初期表示時はすべて
		url = url + '&allResult=1';
	}

	// 結果～時系列表示を表示
	top.resultinfo.location.replace(url);
}

// 判定歴表示
function showHistory( perId, Year, Month, Day ) {

	var opened = false;

	// すでにガイドが開かれているかチェック
	if ( winJudHistory != null ) {
		if ( !winJudHistory.closed ) {
			opened = true;
		}
	}

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winJudHistory.focus();
	} else {
		winJudHistory = window.open('/webHains/contents/judgement/judHistory.asp?perId=' + perId + '&year=' + Year + '&month=' + Month + '&day=' + Day, '', 'width=650,height=500,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

}

// 個人検査情報表示
function showPerInspection(perId) {

	var opened = false;

	// すでにガイドが開かれているかチェック
	if ( winPerInspection != null ) {
		if ( !winPerInspection.closed ) {
			opened = true;
		}
	}

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winPerInspection.focus();
	} else {
		winPerInspection = window.open('/webHains/contents/inquiry/inqPerInspection.asp?perId=' + perId, '', 'width=430,height=400,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

}

// 前後受診者の入力画面へ
function showPrevNextPage(actMode) {

	var myForm = document.judgement;	// 自画面のフォームエレメント
	var url;							// URL文字列

	// 判定入力画面のURL編集
	url = 'judMain.asp';
	url = url + '?actMode='    + actMode;
	url = url + '&cslYear='    + myForm.cslYear.value;
	url = url + '&cslMonth='   + myForm.cslMonth.value;
	url = url + '&cslDay='     + myForm.cslDay.value;
	url = url + '&cntlNo='     + myForm.cntlNo.value;
	url = url + '&csCd='       + myForm.csCd.value;
	url = url + '&sortKey='    + myForm.sortKey.value;
	url = url + '&badJud='     + myForm.badJud.value;
	url = url + '&unFinished=' + myForm.unFinished.value;
	url = url + '&rsvNo='      + myForm.rsvNo.value;

	// ページ移動
	top.location.replace(url);
}

// サブ画面を閉じる
function closeWindow() {

	// 個人検査情報画面を閉じる
	if ( winPerInspection != null ) {
		if ( !winPerInspection.closed ) {
			winPerInspection.close();
		}
	}

	// 判定歴画面を閉じる
	if ( winJudHistory != null ) {
		if ( !winJudHistory.closed ) {
			winJudHistory.close();
		}
	}

	// 判定医師名ガイドを閉じる
	closeGuideDoc();

	// 定型所見ガイドを閉じる
//	closeGuideObs();

	// 判定コメントガイドを閉じる
	jcmGuide_closeGuideJcm();

	// 指導文章ガイドを閉じる
	closeGuideGuidance();

	// 判定ガイドを閉じる
	judGuide_closeGuideJud();

	winPerInspection = null;
	winJudHistory  = null;
}
//-->
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#ffffff" ONLOAD="javascript:showRslHistory(null)" ONUNLOAD="javascript:closeWindow()">

<FORM NAME="judgement" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="actMode"    VALUE="<%= ACTMODE_SAVE  %>">
<INPUT TYPE="hidden" NAME="rsvNo"      VALUE="<%= strRsvNo      %>">
<INPUT TYPE="hidden" NAME="cslYear"    VALUE="<%= lngCslYear    %>">
<INPUT TYPE="hidden" NAME="cslMonth"   VALUE="<%= lngCslMonth   %>">
<INPUT TYPE="hidden" NAME="cslDay"     VALUE="<%= lngCslDay     %>">
<INPUT TYPE="hidden" NAME="cntlNo"     VALUE="<%= strCntlNo     %>">
<INPUT TYPE="hidden" NAME="dayId"      VALUE="<%= strDayId      %>">
<INPUT TYPE="hidden" NAME="csCd"       VALUE="<%= strKeyCsCd    %>">
<INPUT TYPE="hidden" NAME="sortKey"    VALUE="<%= strSortKey    %>">
<INPUT TYPE="hidden" NAME="badJud"     VALUE="<%= strBadJud     %>">
<INPUT TYPE="hidden" NAME="unFinished" VALUE="<%= strUnFinished %>">
<INPUT TYPE="hidden" NAME="noPrevNext" VALUE="<%= strNoPrevNext %>">
<INPUT TYPE="hidden" NAME="allCount"   VALUE="<%= lngAllCount   %>">
<INPUT TYPE="hidden" NAME="logIn"      VALUE="<%= Session("USERID") %>">
<INPUT TYPE="hidden" NAME="logInName"  VALUE="<%= Session("USERNAME") %>">

	<!-- ウインドウ説明見出し -->
	<TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD VALIGN="TOP">
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
					<TR>
						<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#000000">判定入力</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
			<TD WIDTH="5"></TD>
			<TD WIDTH="50">
<%
				'前後受診者への遷移ボタン編集
				If strNoPrevNext = "" Then

					'前後受診者の予約番号・当日ID取得
					objConsult.SelectCurRsvNoPrevNext dtmCslDate,            _
													  strKeyCsCd,            _
													  strSortKey,            _
													  strCntlNo,             _
													  False,                 _
													  (strBadJud     <> ""), _
													  (strUnFinished <> ""), _
													  strRsvNo,              _
													  strPrevRsvNo,          _
													  strPrevDayId,          _
													  strNextRsvNo,          _
													  strNextDayId
%>
					<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
						<TR HEIGHT="25" VALIGN="TOP">
							<TD WIDTH="25">
<%
								'前受診者が存在する場合はボタン表示
								If strPrevRsvNo <> "" Then
%>
									<A HREF="javascript:showPrevNextPage('<%= ACTMODE_PREVIOUS %>')"><IMG SRC="/webHains/images/review.gif" WIDTH="21" HEIGHT="21" ALT="前の受診者を表示"></A>
<%
								End If
%>
							</TD>
							<TD WIDTH="25">
<%
								'次受診者が存在する場合はボタン表示
								If strNextRsvNo <> "" Then
%>
									<A HREF="javascript:showPrevNextPage('<%= ACTMODE_NEXT %>')"><IMG SRC="/webHains/images/cue.gif" WIDTH="21" HEIGHT="21" ALT="次の受診者を表示"></A>
<%
								End If
%>
							</TD>
						</TR>
					</TABLE>
<%
				End If
%>
			</TD>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	EditMessage strMessage, lngMessageType
%>
	<BR>
<%
	'受診情報の編集
	If blnExists Then
%>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			<TR>
				<TD>受診日：</TD>
				<TD><FONT COLOR="#ff6600"><B><%= dtmCslDate %></B></FONT></TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10"></TD>
				<TD>受診コース：</TD>
				<TD><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10"></TD>
				<TD>当日ID：</TD>
				<TD><FONT COLOR="#ff6600"><B><%= objCommon.FormatString(strDayId, "0000") %></B></FONT></TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10"></TD>
				<TD>予約番号：</TD>
				<TD><FONT COLOR="#ff6600"><B><%= strRsvNo %></B></FONT></TD>
			</TR>
		</TABLE>

		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="626">
			<TR>
				<TD COLSPAN="2"><IMG SRC="/webHains/images/spacer.gif" HEIGHT="3"></TD>
			</TR>
			<TR>
				<TD NOWRAP WIDTH="46" ROWSPAN="2" VALIGN="top"><%= strPerId %></TD>
				<TD NOWRAP><B><%= strLastName & "　" & strFirstName %></B> (<FONT SIZE="-1"><%= strLastKname & "　" & strFirstKName %></FONT>)</TD>
<%
				If lngAllCount > 0 Then
%>
					<TD ROWSPAN="2" VALIGN="bottom" ALIGN="right">
						<A HREF="javascript:function voi(){};voi()" ONCLICK="return goNextPage()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存"></A>
					</TD>
<%
				End If
%>
			</TR>
			<TR>
				<TD NOWRAP><%= objCommon.FormatString(strBirth, "ge.m.d") %>生　<%= strAge %>歳　<%= IIf(strGender = "1", "男性", "女性") %></TD>
			</TR>
		</TABLE>

		<BR>

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			<TR>

<!--				<TD><A HREF="javaScript:showPerInspection('<%= strPerid %>')">個人属性情報を表示</A></TD>-->
				<TD><A HREF="javaScript:showPerInspection('<%= strPerid %>')"><IMG SRC="/webHains/images/insinfo_b.gif" WIDTH="77" HEIGHT="24" ALT="個人情報（既往歴など）を表示します"></A></TD>
				<TD WIDTH="10"></TD>
				<TD><A HREF="javaScript:showHistory('<%= strPerid %>','<%= lngCslYear %>','<%= lngCslMonth %>','<%= lngCslDay %>')"><IMG SRC="/webHains/images/oldJud.gif" WIDTH="77" HEIGHT="24" ALT="過去の判定情報を表示します"></A></TD>
<!--
				<TD>｜</TD>
				<TD><A HREF="/webHains/contents/disease/perDisease.asp?perId=<%= strPerid %>" TARGET="_top">既往歴・家族歴を表示</A></TD>
-->
				<TD><IMG SRC="/webHains/images/spacer.gif" HEIGHT="1" WIDTH="20"></TD>
				<INPUT TYPE="hidden" NAME="doctorCd" VALUE="<%= strDoctorCd %>">
				<INPUT TYPE="hidden" NAME="initdoctorCd"  VALUE="<%= strInitdoctorCd %>">
<%
				If lngAllCount > 0 Then
%>
					<TD><A HREF="javascript:callDocGuide()"><IMG SRC="/webHains/images/doctor.gif" WIDTH="77" HEIGHT="23" ALT="判定医師名検索"></A></TD>
					<TD WIDTH="5"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="2"></TD>
					<TD><A HREF="javascript:delDoctor()"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="判定医師を削除します"></A></TD>
					<TD WIDTH="5"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="2"></TD>
<%
				End If
%>
				<INPUT TYPE="hidden" NAME="doctorName" VALUE="<%= strDoctorName %>">
				<TD><SPAN ID="docName" STYLE="position:relative"><%= strDoctorName %></SPAN></TD>
			</TR>
		</TABLE>
<%
	End If

	'判定結果一覧編集
	Call EditJudRslList()
%>

</FORM>
</BODY>
</HTML>
