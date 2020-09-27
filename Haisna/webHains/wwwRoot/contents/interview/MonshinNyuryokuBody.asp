<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   問診入力 (Ver0.0.1)
'	   AUTHER  : keiko fujii@ffcs.co.jp
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
Const MONLIFE_GRPCD = "X030"		'問診（生活習慣）グループコード
Const MONSELF_GRPCD = "X025"		'問診（自覚症状２）グループコード
Const SELF_ITEMCD   = "877001"		'自覚症状 検査項目コード

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objHainsUser		'ユーザー情報アクセス用
Dim objInterview		'面接情報アクセス用
Dim objSentence			'文章情報アクセス用
Dim objResult			'検査結果情報アクセス用

Dim strWinMode			'ウインドウ表示モード（1:別ウインドウ、0:同ウインドウ）
Dim lngRsvNo			'予約番号（今回分）

Dim	vntLifeSeq			'生活習慣　履歴番号
Dim	vntLifeRsvNo		'生活習慣　予約番号
Dim	vntLifeSuffix		'生活習慣　サフィックス
Dim	vntLifeItemType		'生活習慣　項目コード
Dim	vntLifeItemName		'生活習慣　項目名
Dim vntLifeItemCd		'生活習慣　検査項目コード
Dim vntLifeResult		'生活習慣　回答内容
Dim vntLifeQuestionRank	'生活習慣　問診表示ランク
Dim	vntLifeItemQName	'生活習慣　問診文章
Dim	vntUnit				'生活習慣　単位

Dim	lngLifeCnt			'生活習慣　件数

Dim	vntSelfSeq			'自覚症状　履歴番号
Dim	vntSelfRsvNo		'自覚症状　予約番号
Dim	vntSelfSuffix		'自覚症状　サフィックス
Dim	vntSelfItemType		'自覚症状　項目コード
Dim	vntSelfItemName		'自覚症状　項目名
Dim vntSelfItemCd		'自覚症状　検査項目コード
Dim vntSelfResult		'自覚症状　回答内容
Dim vntSelfStcCd		'自覚症状　文章コード
Dim vntSelfQuestionRank	'自覚症状　問診表示ランク
Dim	vntSelfItemQName	'自覚症状　問診文章

Dim	lngSelfCnt			'自覚症状　件数
Dim	lngSelfCntEx		'自覚症状　実装数

Dim strResult1			'回答内容
Dim strResult2			'回答内容
Dim strResult3			'回答内容
Dim strResult4			'回答内容
Dim vntResult5			'最近気になること
Dim lngQuestionRank		'問診表示ランク

Dim vntSelfCondition		'自覚症状
Dim vntSelfConditionCd		'自覚症状文章コード
Dim vntSelfCondItemCd		'自覚症状 検査項目コード
Dim vntSelfCondSuffix		'自覚症状 サフィックス
Dim vntSelfNumValue			'自覚症状日数
Dim vntSelfNumItemCd		'自覚症状 検査項目コード
Dim vntSelfNumSuffix		'自覚症状 サフィックス
Dim vntSelfDayUnit			'自覚症状単位
Dim vntSelfDayUnitCd		'自覚症状単位文章コード
Dim vntSelfUnitItemCd		'自覚症状 検査項目コード
Dim vntSelfUnitSuffix		'自覚症状 サフィックス
Dim vntSelfCslStat			'自覚症状受診状況
Dim vntSelfCslStatCd		'自覚症状受診状況文章コード
Dim vntSelfCslStatItemCd	'自覚症状 検査項目コード
Dim vntSelfCslStatSuffix	'自覚症状 サフィックス

Dim i					'ループカウンタ
Dim j					'ループカウンタ
Dim lngWkCnt			'ワーク用のカウント

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")
Set objSentence     = Server.CreateObject("HainsSentence.Sentence")
Set objResult       = Server.CreateObject("HainsResult.Result")

'引数値の取得
lngRsvNo         = Request("rsvno")
strWinMode       = Request("winmode")

Do

	'問診結果（生活習慣）検索
''## 2006.05.10 Mod by 李  *****************************
''前回歴表示モード設定
	
'	lngLifeCnt = objInterview.SelectHistoryRslList( _
'					    lngRsvNo, _
'    					1, _
'    					MONLIFE_GRPCD, _
'    					0, _
'    					"", _
'    					2, _
'    					, , _
'						, , _
'    					vntLifeSeq, _
'    					vntLifeRsvNo, _
'    					vntLifeItemCd, _
'    					vntLifeSuffix, _
'    					 , _
'    					vntLifeItemType, _
'    					vntLifeItemName, _
'    					vntLifeResult, _
'						 , , , , , , _
'						vntUnit, _
'						 , , , _
'                        vntLifeQuestionRank, , _
'						vntLifeItemQName _
'						)


	lngLifeCnt = objInterview.SelectHistoryRslList( _
					    lngRsvNo, _
    					1, _
    					MONLIFE_GRPCD, _
    					2, _
    					"CSC01", _
    					2, _
    					, , _
						, , _
    					vntLifeSeq, _
    					vntLifeRsvNo, _
    					vntLifeItemCd, _
    					vntLifeSuffix, _
    					 , _
    					vntLifeItemType, _
    					vntLifeItemName, _
    					vntLifeResult, _
						 , , , , , , _
						vntUnit, _
						 , , , _
                        vntLifeQuestionRank, , _
						vntLifeItemQName _
						)


	'問診結果（自覚症状）検索
'	lngSelfCnt = objInterview.SelectHistoryRslList( _
'					    lngRsvNo, _
'    					1, _
'    					MONSELF_GRPCD, _
'    					0, _
'    					"", _
'    					1, _
'    					, , _
'						, , _
'    					vntSelfSeq, _
'    					vntSelfRsvNo, _
'    					vntSelfItemCd, _
'    					vntSelfSuffix, _
'    					 , _
'    					vntSelfItemType, _
'    					vntSelfItemName, _
'    					vntSelfResult, _
'						vntSelfStcCd, _
'						 , , , , , , , , , _
'                        vntSelfQuestionRank _
'						)

	lngSelfCnt = objInterview.SelectHistoryRslList( _
					    lngRsvNo, _
    					1, _
    					MONSELF_GRPCD, _
    					2, _
    					"CSC01", _
    					1, _
    					, , _
						, , _
    					vntSelfSeq, _
    					vntSelfRsvNo, _
    					vntSelfItemCd, _
    					vntSelfSuffix, _
    					 , _
    					vntSelfItemType, _
    					vntSelfItemName, _
    					vntSelfResult, _
						vntSelfStcCd, _
						 , , , , , , , , , _
                        vntSelfQuestionRank _
						)

''## 2006.05.10 End 李  *****************************


	Exit Do
Loop

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>問診入力</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winJikakushoujyou;				// ウィンドウハンドル
//自覚症状ウインドウ呼び出し
function showJikakushoujyou() {

	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか


	// すでにガイドが開かれているかチェック
	if ( winJikakushoujyou != null ) {
		if ( !winJikakushoujyou.closed ) {
			opened = true;
		}
	}
	url = '/WebHains/contents/interview/jikakushoujyou.asp?rsvno=' + <%= lngRsvNo %>;

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winJikakushoujyou.focus();
		winJikakushoujyou.location.replace( url );
	} else {
		winJikakushoujyou = window.open( url, '', 'width=900,height=500,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

}

function windowClose() {

	// 自覚症状ウインドウを閉じる
	if ( winJikakushoujyou != null ) {
		if ( !winJikakushoujyou.closed ) {
			winJikakushoujyou.close();
		}
	}

	winJikakushoujyou = null;

}

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/mensetsutable.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="813" class="mensetsu-tb">
		<TR ALIGN="center" BGCOLOR="#cccccc">
			<th NOWRAP WIDTH="193">質問内容</th>
			<th COLSPAN="4" NOWRAP>回答内容</th>
		</TR>
<%
		For i = 0 To lngLifeCnt - 1
%>
			<TR BGCOLOR="#ffffff">
				<TD NOWRAP WIDTH="226"><%= vntLifeItemQName(i) %></TD>
<%
				lngQuestionRank = CLng(IIf( IsNumeric(vntLifeQuestionRank(i))=True, vntLifeQuestionRank(i), 0 ))
				strResult1 = "&nbsp;"
				strResult2 = "&nbsp;"
				strResult3 = "&nbsp;"
				strResult4 = "&nbsp;"
				Select Case lngQuestionRank
					Case 1
						strResult1 = vntLifeResult(i) & vntUnit(i)
					Case 2
						strResult2 = vntLifeResult(i) & vntUnit(i)
					Case 3
						strResult3 = vntLifeResult(i) & vntUnit(i)
					Case Else
						strResult4 = vntLifeResult(i) & vntUnit(i)
				End Select
%>
				<TD ALIGN="left" NOWRAP BGCOLOR="#90f0aa" WIDTH="140"><%= strResult1 %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="#ffffcc" WIDTH="140"><%= strResult2 %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="#ffdead" WIDTH="140"><%= strResult3 %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="#eeeeee" WIDTH="100%"><%= strResult4 %></TD>
			</TR>
<%
		Next
%>
<%
		'自覚症状
		vntResult5 = Array()	
		strResult1 = "&nbsp;"
		strResult2 = "&nbsp;"
		strResult3 = "&nbsp;"
		lngWkCnt = 0
		'表示用エリアにセット
		For i = 0 To lngSelfCnt-1
			If vntSelfResult(i) <> "" Then
				Select Case vntSelfSuffix(i)
			    	Case "01"
			    		Redim Preserve vntResult5(lngWkCnt)
			    		vntResult5(lngWkCnt) = vntSelfResult(i)
			    	Case "02"
			    		vntResult5(lngWkCnt) = vntResult5(lngWkCnt) & vntSelfResult(i)
			    	Case "03"
			    		vntResult5(lngWkCnt) = vntResult5(lngWkCnt) & vntSelfResult(i)
			    	Case "04"
			    		vntResult5(lngWkCnt) = vntResult5(lngWkCnt) & vntSelfResult(i)
			    		lngWkCnt = lngWkCnt + 1
			    End Select
			End If
		Next

		For i = 0 To lngWkCnt - 1
%>
			<TR BGCOLOR="#ffffff">
				<TD NOWRAP WIDTH="226">最近気になること</TD>
<!-- ## 2004.02.18 色指定がおかしい -->
<!--
				<TD ALIGN="left" NOWRAP BGCOLOR="#eeeeee" WIDTH="137"><%= strResult1 %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="#ffffcc" WIDTH="147"><%= strResult2 %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="#90f0aa" WIDTH="140"><%= strResult3 %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="#ffdead" WIDTH="100%"><%= vntResult5(i) %></TD>
-->
				<TD ALIGN="left" NOWRAP BGCOLOR="#90f0aa" WIDTH="137"><%= strResult1 %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="#ffffcc" WIDTH="147"><%= strResult2 %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="#ffdead" WIDTH="140"><%= strResult3 %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="#eeeeee" WIDTH="100%"><%= vntResult5(i) %></TD>

			</TR>
<%
		Next
%>
	</TABLE>
	<BR>
	<BR>
	<A HREF="javascript:showJikakushoujyou()"><FONT SIZE="+1">自覚症状</FONT></A>
	<BR><BR>
<%
	If lngSelfCnt > 0 Then
%>
<%
		vntSelfCondition = Array()		
		vntSelfConditionCd = Array()	
		vntSelfCondItemCd = Array()	
		vntSelfCondSuffix = Array()	
		vntSelfNumValue = Array()		
		vntSelfNumItemCd = Array()		
		vntSelfNumSuffix = Array()		
		vntSelfDayUnit = Array()	
		vntSelfDayUnitCd = Array()	
		vntSelfUnitItemCd = Array()	
		vntSelfUnitSuffix = Array()	
		vntSelfCslStat = Array()	
		vntSelfCslStatCd = Array()	
		vntSelfCslStatItemCd = Array()	
		vntSelfCslStatSuffix = Array()	
		lngSelfCntEx = 0
		'表示用エリアにセット
		For i = 0 To lngSelfCnt-1
			lngWkCnt = Int( i / 4 )
			Select Case vntSelfSuffix(i)
				Case "01"
					Redim Preserve vntSelfCondition(lngWkCnt)
					Redim Preserve vntSelfConditionCd(lngWkCnt)
					Redim Preserve vntSelfCondItemCd(lngWkCnt)
					Redim Preserve vntSelfCondSuffix(lngWkCnt)
					vntSelfCondition(lngWkCnt) = vntSelfResult(i)
					vntSelfConditionCd(lngWkCnt) = vntSelfStcCd(i)
					vntSelfCondItemCd(lngWkCnt) = vntSelfItemCd(i)
					vntSelfCondSuffix(lngWkCnt) = vntSelfSuffix(i)
				Case "02"
					Redim Preserve vntSelfNumValue(lngWkCnt)
					Redim Preserve vntSelfNumItemCd(lngWkCnt)
					Redim Preserve vntSelfNumSuffix(lngWkCnt)
					vntSelfNumValue(lngWkCnt) = vntSelfResult(i)
					vntSelfNumItemCd(lngWkCnt) = vntSelfItemCd(i)
					vntSelfNumSuffix(lngWkCnt) = vntSelfSuffix(i)
				Case "03"
					Redim Preserve vntSelfDayUnit(lngWkCnt)
					Redim Preserve vntSelfDayUnitCd(lngWkCnt)
					Redim Preserve vntSelfUnitItemCd(lngWkCnt)
					Redim Preserve vntSelfUnitSuffix(lngWkCnt)
					vntSelfDayUnit(lngWkCnt) = vntSelfResult(i)
					vntSelfDayUnitCd(lngWkCnt) = vntSelfStcCd(i)
					vntSelfUnitItemCd(lngWkCnt) = vntSelfItemCd(i)
					vntSelfUnitSuffix(lngWkCnt) = vntSelfSuffix(i)
				Case "04"
					Redim Preserve vntSelfCslStat(lngWkCnt)
					Redim Preserve vntSelfCslStatCd(lngWkCnt)
					Redim Preserve vntSelfCslStatItemCd(lngWkCnt)
					Redim Preserve vntSelfCslStatSuffix(lngWkCnt)
					vntSelfCslStat(lngWkCnt) = vntSelfResult(i)
					vntSelfCslStatCd(lngWkCnt) = vntSelfStcCd(i)
					vntSelfCslStatItemCd(lngWkCnt) = vntSelfItemCd(i)
					vntSelfCslStatSuffix(lngWkCnt) = vntSelfSuffix(i)
			End Select
		Next
%>
		<TABLE BORDER="1" CELLSPACING="0" CELLPADDING="0" WIDTH="300">
<%
		For i = 0 To UBound( vntSelfConditionCd )
			If vntSelfConditionCd(i) <> "" Then
%>
				<TR>
			    	<TD ALIGN="left" NOWRAP ><%= vntSelfCondition(i) %></TD>
			    	<TD ALIGN="left" NOWRAP ><%= vntSelfNumValue(i) %></TD>
			    	<TD ALIGN="left" NOWRAP ><%= vntSelfDayUnit(i) %></TD>
			    	<TD ALIGN="left" NOWRAP ><%= vntSelfCslStat(i) %></TD>
			    </TR>
<%
			End If
		Next
%>
		</TABLE>
<%
	End If
%>
	<BR>
</FORM>
</BODY>
</HTML>