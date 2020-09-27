<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		検査項目説明 (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const RSLTYPE_0 = 0			'結果タイプ（数値）の値
Const RSLTYPE_5 = 5			'結果タイプ（計算）の値

Dim strItemCd				'検査項目コード
Dim strSuffix				'サフィックス
Dim strCsCd					'コースコード
Dim strCslDateYear			'受診日（年）
Dim strCslDateMonth			'受診日（月）
Dim strCslDateDay			'受診日（日）
Dim strAge					'年齢
Dim strGender				'性別

Dim objItem					'検査項目アクセス用COMオブジェクト
Dim objStdValue				'基準値アクセス用COMオブジェクト

Dim strItemName				'検査項目名
Dim strItemEName			'英語項目名
Dim strClassName			'検査分類名称
Dim lngRslque				'結果問診フラグ
Dim strRslqueName			'結果問診フラグ名称
Dim lngItemType				'項目タイプ
Dim strItemTypeName			'項目タイプ名称
Dim lngResultType			'結果タイプ
Dim strResultTypeName		'結果タイプ名称

Dim lngHistoryCount			'履歴管理レコード件数
Dim strUnit					'単位
Dim lngFigure1				'整数部桁数
Dim lngFigure2				'小数部桁数
Dim strMaxValue				'最大値
Dim strMinValue				'最小値

Dim lngAgeFlg				'基準値履歴の年齢管理有無（0:無,1:有）
Dim lngGenderFlg			'基準値履歴の性別管理有無（0:無,1:有）
Dim strArrCsCd				'コースコード(配列)
Dim strArrCsName			'コース名(配列)
Dim strArrGender			'性別(配列)
Dim strArrStrAge			'開始年齢(配列)
Dim strArrEndAge			'終了年齢(配列)
Dim strArrLowerValue		'下限値(配列)
Dim strArrUpperValue		'上限値(配列)
Dim strArrStdFlg			'基準値フラグ(配列)
Dim strArrStdFlgColor		'基準値フラグ表示色(配列)
Dim strArrJudCd				'判定コード(配列)
Dim strArrHealthPoint		'ヘルスポイント(配列)

Dim blnRetCd1				'リターンコード
Dim blnRetCd2				'リターンコード
Dim lngCount				'件数

Dim strDispHistoryCount		'編集用の履歴管理数

Dim strDispItemName			'編集用の検査項目名
Dim strDispItemEName		'編集用の英語項目名
Dim strDispClassName		'編集用の検査分類名称
Dim strDispRslque			'編集用の結果問診フラグ
Dim strDispRslqueName		'編集用の結果問診フラグ名称
Dim strDispItemType			'編集用の項目タイプ
Dim strDispItemTypeName		'編集用の項目タイプ名称
Dim strDispResultType		'編集用の結果タイプ
Dim strDispResultTypeName	'編集用の結果タイプ名称

Dim strDispUnit				'編集用の単位
Dim strDispFigure1			'編集用の整数部桁数
Dim strDispFigure2			'編集用の小数部桁数
Dim strDispMaxValue			'編集用の最大値
Dim strDispMinValue			'編集用の最小値

Dim strDispCsCd				'コースコード
Dim strDispCsName			'コース名
Dim strDispGender			'性別
Dim strDispStrAge			'開始年齢
Dim strDispEndAge			'終了年齢
Dim strDispLowerValue		'下限値
Dim strDispUpperValue		'上限値
Dim strDispStdFlg			'基準値フラグ
Dim strDispStdFlgColor		'基準値フラグ表示色
Dim strDispJudCd			'判定コード
Dim strDispHealthPoint		'ヘルスポイント

Dim blnConditionFlg			'適用条件指定フラグ(True:コース、年齢、性別指定あり、False:指定なし)
Dim blnTableEndFlg			'テーブル終了フラグ(True:テーブル終了、False:継続)
Dim lngDisp					'基準値適用条件表示制御用
Dim i, j					'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strItemCd       = Request("itemCd") & ""
strSuffix       = Request("suffix") & ""
strCsCd         = Request("csCd") & ""
strCslDateYear  = Request("cslDateYear") & ""
strCslDateYear  = IIf(strCslDateYear = "", Year(Date), strCslDateYear)
strCslDateMonth = Request("cslDateMonth") & ""
strCslDateMonth = IIf(strCslDateMonth = "", Month(Date), strCslDateMonth)
strCslDateDay   = Request("cslDateDay") & ""
strCslDateDay   = IIf(strCslDateDay = "", Day(Date), strCslDateDay)
strAge          = Request("age") & ""
strGender       = Request("gender") & ""

'適用条件指定フラグの設定
If strCsCd <> "" And strAge <>"" And strGender <> "" Then
	blnConditionFlg = True
Else
	blnConditionFlg = False
End If

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>検査項目説明</TITLE>
</HEAD>
<BODY BGCOLOR="#ffffff">

<%
	'検査項目の基本情報アクセス用COMオブジェクトの割り当て
	Set objItem     = Server.CreateObject("HainsItem.Item")
	Set objStdValue = Server.CreateObject("HainsStdValue.StdValue")

	Do
		'検索条件が存在しない場合は何もしない
		If IsEmpty(strItemCd) Or IsEmpty(strSuffix) Or IsEmpty(strCsCd) Then
%>
			<BR><BR>
			<BLOCKQUOTE>
<%
			Exit Do
		End If

		'検査項目の基本情報を取得
		blnRetCd1 = objItem.SelectItemHeader(strItemCd, strSuffix, _
											 strItemName, strItemEName, strClassName, _
											 lngRslque, strRslqueName, _
											 lngItemType, strItemTypeName, _
											 lngResultType, strResultTypeName _
											)

		'検査項目基本情報の編集
		If blnRetCd1 = True Then

			'検査項目基本情報の取得
			strDispItemName       = RTrim(strItemName)
			strDispItemEName      = RTrim(strItemEName)
			strDispClassName      = RTrim(strClassName)
			strDispRslque         = CStr(lngRslque)
			strDispRslqueName     = RTrim(strRslqueName)
			strDispItemType       = CStr(lngItemType)
			strDispItemTypeName   = RTrim(strItemTypeName)
			strDispResultType     = CStr(lngResultType)
			strDispResultTypeName = RTrim(strResultTypeName)

			'検査項目基本情報の編集
%>
			<FONT SIZE="+2"><B><%= strDispItemName %></B></FONT>
<%
			'英語項目名は空白でない時のみ表示
			If strDispItemEName <> "" Then
%>
				(<%= strDispItemEName %>)
<%
			End If
%>
			<BR><BR>
			<BLOCKQUOTE>
			<B>検査項目基本情報</B><BR><BR>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="262">
				<TR>
					<TD NOWRAP BGCOLOR="#eeeeee">項目コード</TD>
					<TD NOWRAP><%= strItemCd %>-<%= strSuffix %></TD>
				</TR>
				<TR>
					<TD NOWRAP BGCOLOR="#eeeeee">分類</TD>
					<TD NOWRAP><%= strDispClassName %>（<%= strDispRslqueName %>）</TD>
				</TR>
				<TR>
					<TD NOWRAP BGCOLOR="#eeeeee">検査項目タイプ</TD>
					<TD NOWRAP><%= strDispItemTypeName %></TD>
				</TR>
				<TR>
					<TD NOWRAP BGCOLOR="#eeeeee">検査結果タイプ</TD>
					<TD NOWRAP><%= strDispResultTypeName %></TD>
				</TR>
				<TR>
					<TD NOWRAP COLSPAN="2">　</TD>
				</TR>
<%
			'検査項目の履歴情報を取得
			blnRetCd2 = objItem.SelectItemHistory(strItemCd, strSuffix, _
												  strCslDateYear, strCslDateMonth, strCslDateDay, _
												  lngHistoryCount, strUnit, _
												  lngFigure1, lngFigure2, _
												  strMaxValue, strMinValue _
												 )

			'履歴情報は結果タイプが数値または計算項目の時のみ表示
			If lngResultType = RSLTYPE_0 Or lngResultType = RSLTYPE_5  Then

				'適用条件は履歴管理が行われている時のみ表示
				If lngHistoryCount > 1 Then
%>
					<TR>
						<TD NOWRAP COLSPAN="2">受診日：<FONT COLOR="#ff6600">
							<B><%= strCslDateYear %>年<%= strCslDateMonth %>月<%= strCslDateDay %>日</B>
							</FONT>に適用される設定値</TD>
					</TR>
<%
				End If

				'履歴情報は該当受診日のレコードが検索できた時のみ表示
				If blnRetCd2 = True Then
					'検査項目履歴情報の取得
					strDispUnit     = RTrim(strUnit)
					strDispFigure1  = CStr(lngFigure1)
					strDispFigure2  = CStr(lngFigure2)
					strDispMaxValue = RTrim(strMaxValue)
					strDispMinValue = RTrim(strMinValue)
	
					'検査項目基本情報の編集
%>
					<TR>
						<TD NOWRAP BGCOLOR="#eeeeee">単位</TD>
						<TD NOWRAP><%= strDispUnit %></TD>
					</TR>
					<TR>
						<TD NOWRAP BGCOLOR="#eeeeee">桁数</TD>
						<TD NOWRAP>整数部<%= strDispFigure1 %>桁、小数部<%= strDispFigure2 %>桁</TD>
					</TR>
					<TR>
						<TD NOWRAP BGCOLOR="#eeeeee">入力最大値</TD>
						<TD NOWRAP><%= strDispMaxValue %></TD>
					</TR>
					<TR>
						<TD NOWRAP BGCOLOR="#eeeeee">入力最小値</TD>
						<TD NOWRAP><%= strDispMinValue %></TD>
					</TR>
<%
				End If
%>
				<TR>
					<TD NOWRAP COLSPAN="2">　</TD>
				</TR>
<%
			End If

			'履歴管理数の編集(0以下は0とする)
			strDispHistoryCount = CStr(IIf(lngHistoryCount - 1 < 0, 0, lngHistoryCount - 1))
%>
			</TABLE>
			<FONT COLOR="#666666">※検査項目の履歴管理数=<B><%= strDispHistoryCount %></B></FONT><BR><BR>
			<HR WIDTH="450" ALIGN="left">
			<BR>
			<B>基準値関連情報</B><BR><BR>
<%

			'検査項目の基準値情報を取得
			lngCount = objStdValue.SelectItemStdValue(strItemCd, strSuffix, strCsCd, _
													  strCslDateYear, strCslDateMonth, strCslDateDay, _
													  strAge, strGender, _
													  lngHistoryCount, lngAgeFlg, lngGenderFlg, _
													  strArrCsCd, strArrCsName, _
													  strArrGender, strArrStrAge, strArrEndAge, _
													  strArrLowerValue, strArrUpperValue, _
													  strArrStdFlg, strArrStdFlgColor, _
													  strArrJudCd, strArrHealthPoint)

			'コース、受診時年齢、性別がすべて指定されているときは適用条件の表示制御を行う
			If blnConditionFlg Then

				'適用条件の表示制御
				lngDisp = 0
		
				'受診日適用条件は履歴管理が行われている時のみ表示
				If lngHistoryCount > 1 Then
%>
				受診日：<FONT COLOR="#ff6600"><B><%= strCslDateYear %>年<%= strCslDateMonth %>月<%= strCslDateDay %>日</B></FONT>　
<%
					lngDisp = 1
				End If
		
				'年齢適用条件は履歴管理が行われている時のみ表示
				If lngAgeFlg = 1 Then
%>
				受診時年齢：<FONT COLOR="#ff6600"><B><%= strAge %>歳</B></FONT>　
<%
					lngDisp = 1
				End If

				'性別適用条件は履歴管理が行われている時のみ表示
				If lngGenderFlg = 1 Then
%>
				<FONT COLOR="#ff6600"><B><%= IIf(strGender = "1", "男性", IIf(strGender = "2", "女性", "(不明)")) %></B></FONT>
<%
					lngDisp = 1
				End If
		
				'適用条件の表示制御
				If lngDisp = 1 Then
%>
				に適用される設定値<BR>
<%
				End If

			End If

			'レコードが無いとき
			If lngCount = 0 Then
%>
			<BR>
			<FONT COLOR="#666666">※基準値の履歴管理数=<B>0</B></FONT><BR>
			<BR>
<%				
				Exit Do
			End If

			'検査項目基準値情報の編集開始
			j = 0
			For i = 0 To lngCount - 1

				'ヘッダー部の編集
				If j = 0 Then

					'ヘッダー情報の取得
					strDispCsCd    = RTrim(strArrCsCd(i))
					strDispCsName  = IIf(RTrim(strArrCsName(i)) = "", "（共通）", RTrim(strArrCsName(i)))
					strDispGender  = RTrim(strArrGender(i))

					'ヘッダー部出力(コース，年齢，性別未指定時)
					If Not blnConditionFlg Then
%>
						コース：<FONT COLOR="#ff6600"><B><%= strDispCsCd %>　<%= strDispCsName %></B></FONT>　性別：<FONT COLOR="#ff6600"><B><%= strDispGender %></B></FONT><BR>
<%
					End If

					'テーブルヘッダー部出力
%>
					<TABLE BORDER="1" CELLPADDING="1" CELLSPACING="1">
						<TR BGCOLOR="#eeeeee">
							<TD NOWRAP ALIGN="right">No</TD>
							<TD NOWRAP ALIGN="center">年齢</TD>
<%
							Select Case lngResultType

								'定性の場合
								Case RESULTTYPE_TEISEI1, RESULTTYPE_TEISEI2
%>
									<TD NOWRAP>検査結果</TD>
<%
								'文章タイプの場合
								Case RESULTTYPE_SENTENCE
%>
									<TD NOWRAP>検査結果</TD>
									<TD NOWRAP>所見文章</TD>
<%
								'上記以外
								Case Else
%>
									<TD NOWRAP ALIGN="right">下限値</TD>
									<TD NOWRAP ALIGN="center">&nbsp;</TD>
									<TD NOWRAP>上限値</TD>
<%
							End Select
%>
							<TD NOWRAP>基準値フラグ</TD>
							<TD NOWRAP>判定</TD>
							<TD NOWRAP>ヘルスポイント</TD>
						</TR>
<%
				End If

				'検査項目基準値情報の取得
				strDispStrAge      = RTrim(strArrStrAge(i))
				strDispEndAge      = RTrim(strArrEndAge(i))
				strDispLowerValue  = RTrim(strArrLowerValue(i))
				strDispUpperValue  = RTrim(strArrUpperValue(i))
				strDispStdFlg      = RTrim(strArrStdFlg(i))
				strDispStdFlgColor = RTrim(strArrStdFlgColor(i))
				strDispJudCd       = RTrim(strArrJudCd(i))
				strDispHealthPoint = RTrim(strArrHealthPoint(i))

				'検査項目基準値情報の編集
%>
				<TR>
					<TD NOWRAP BGCOLOR="#eeeeee" ALIGN="right"><%= CStr(j + 1) %></TD>
					<TD NOWRAP>
						<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
							<TR>
								<TD NOWRAP ALIGN="right"><%= IIf(strDispStrAge = "", "　", strDispStrAge) %></TD>
								<TD NOWRAP ALIGN="center">～</TD>
								<TD NOWRAP><%= IIf(strDispEndAge = "", "　", strDispEndAge) %></TD>
							</TR>
						</TABLE>
					</TD>
<%
					Select Case lngResultType

						'定性の場合
						Case RESULTTYPE_TEISEI1, RESULTTYPE_TEISEI2
%>
							<TD NOWRAP><%= strDispLowerValue %></TD>
<%
						'文章タイプの場合
						Case RESULTTYPE_SENTENCE
%>
							<TD NOWRAP><%= strDispLowerValue %></TD>
							<TD NOWRAP><%= strDispUpperValue %></TD>
<%
						'上記以外
						Case Else
%>
							<TD NOWRAP ALIGN="right"><%= IIf(strDispLowerValue = "", "　", strDispLowerValue) %></TD>
							<TD NOWRAP ALIGN="center">～</TD>
							<TD NOWRAP><%= IIf(strDispUpperValue = "", "　", strDispUpperValue) %></TD>
<%
					End Select
%>
					<TD NOWRAP><%= IIf(strDispStdFlgColor = "", "", "<FONT COLOR=" & strDispStdFlgColor & ">") %>
						<B><%= IIf(strDispStdFlg = "", "　", strDispStdFlg) %></B>
						<%= IIf(strDispStdFlgColor = "", "", "</FONT>") %></TD>
					<TD NOWRAP><%= IIf(strDispJudCd = "", "　", strDispJudCd) %></TD>
					<TD NOWRAP><%= IIf(strDispHealthPoint = "", "　", strDispHealthPoint) %></TD>
				</TR>
<%
				'最終行あるいは次データとコース，性別が変わる時テーブル終了フラグをセット
				blnTableEndFlg = False
				If i = lngCount - 1 Then
					blnTableEndFlg = True
				Else
					If RTrim(strArrCsCd(i + 1))   <> strDispCsCd   Or _
					   RTrim(strArrGender(i + 1)) <> strDispGender Then
						blnTableEndFlg = True
					End If
				End If

				'テーブル終了
				If blnTableEndFlg Then
%>				
			</TABLE>
			<BR>
<%
					'履歴管理数の編集(0以下は0とする)
					If blnConditionFlg Then
						strDispHistoryCount = CStr(IIf(lngHistoryCount - 1 < 0, 0, lngHistoryCount - 1))
%>
			<FONT COLOR="#666666">※基準値の履歴管理数=<B><%= strDispHistoryCount %></B></FONT><BR>
			<BR>
<%
					End If
					j = 0
				Else
					j = j + 1
				End If

			Next

		'検査項目基本情報が存在しない場合は何もしない
		Else
%>
			<BR><BR>
			<BLOCKQUOTE>
<%
		End If
	
		Exit Do
	Loop

	Set objItem = Nothing

%>
	<A HREF="javascript:function voi(){};voi()" ONCLICK="top.close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A>

	</BLOCKQUOTE>
</BODY>
</HTML>
