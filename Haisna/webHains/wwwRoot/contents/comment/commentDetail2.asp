<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   コメント情報詳細(Ver0.0.1)
'	   AUTHER  : keiko fujii@ffcs.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/InterviewEditDropDown.inc" -->
<%
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objFree				'汎用情報アクセス用
Dim objPubNote			'コメント情報アクセス用
Dim objHainsUser		'ユーザ情報アクセス用
Dim objConsult			'受診情報アクセス用
Dim objPerson			'個人情報アクセス用
Dim objOrg				'団体情報アクセス用

Dim strMode				'処理モード(挿入:"insert"、更新:"update")
Dim strAction			'処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")

Dim strCmtMode			'対象コメント（カンマ区切り）
Dim strArrCmtMode		'対象コメント（配列）

Dim strPerID			'個人ＩＤ
Dim strLastName			'姓
Dim strFirstName		'名
Dim strLastKName		'カナ姓
Dim strFirstKName		'カナ名
Dim strCslDate			'受信日
Dim lngRsvNo			'予約番号
Dim strCtrPtCd			'契約パターンコード（受診コース）
Dim strCsName			'受信コース名
Dim strBirth			'生年月日
Dim strBirthYear		'生年月日(年)
Dim strBirthMonth		'生年月日(月)
Dim strBirthDay			'生年月日(日)
Dim strGender			'性別
Dim strOrgName			'団体名称
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２


'受診情報用変数
Dim strCsCd				'コースコード
Dim strAge				'年齢
Dim strGenderName		'性別名称
Dim strDayId			'当日ID

Dim lngSelInfo			'1:受診情報,2:個人,3:団体,4:契約
Dim lngCheckSelInfo		'1:受診情報,2:個人,3:団体,4:契約（チェック後）

Dim lngSeq         		'seq
Dim lngNewSeq      		'新規時の新しいseq
Dim strPubNoteDivCd		'受診情報ノート分類コード
Dim strPubNoteDivName	'受診情報ノート分類名
Dim lngDispKbn     		'表示対象
Dim lngBoldFlg     		'太字区分
Dim strPubNote     		'ノート
Dim strDispColor        '表示色
Dim lngOnlyDispKbn     	'表示対象しばり

Dim strUpdDate			'更新日付
Dim strUpdUser        	'更新者
Dim strUserName			'ユーザ名
Dim lngAuthNote      	'参照登録権限
Dim lngDefNoteDispKbn	'ノート初期表示状態

'コメント情報取得用
Dim vntSeq         		'seq
Dim vntPubNoteDivCd		'受診情報ノート分類コード
Dim vntDispKbn     		'表示対象
Dim vntBoldFlg     		'太字区分
Dim vntPubNote     		'ノート
Dim vntDispColor        '表示色
Dim vntUpdDate			'更新日付
Dim vntUpdUser        	'更新者
Dim vntUserName			'ユーザ名
Dim vntPubNoteDivName	'受診情報ノート名称
Dim vntDefaultDispKbn	'表示区分初期値
Dim vntOnlyDispKbn		'表示区分しばり
'### 2004/3/24 Added by Ishihara@FSIT 削除データ表示対応
Dim vntDelFlg			'削除フラグ
'### 2004/3/24 Added End

DIm lngNoteCnt			'件数

Dim strArrPubNoteDivCd		'受診情報ノート分類コード
Dim strArrPubNoteDivName	'受診情報ノート分類名称
Dim strArrDefaultDispKbn	'表示対象区分初期値
Dim strArrOnlyDispKbn		'表示対象区分しばり
Dim lngDivCnt				'受診情報ノート分類件数

Dim i				'カウンタ

Dim strArrMessage	'エラーメッセージ
Dim Ret				'関数戻り値

Dim strHTML				'呼び出し元ＨＴＭＬ

Dim strWkSentence		'文章ワークエリア
Dim lngWrtFlg			'書き込みチェックフラグ
Dim strWkSelInfo		'対象コメント番号ワーク
'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objFree         = Server.CreateObject("HainsFree.Free")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objPubNote      = Server.CreateObject("HainsPubNote.PubNote")
Set objPerson       = Server.CreateObject("HainsPerson.Person")
Set objOrg          = Server.CreateObject("HainsOrganization.Organization")

'引数値の取得
strMode           = Request("mode")
strAction         = Request("act")

strCmtMode        = Request("cmtMode")
strArrCmtMode     = split( strCmtMode, "," )
If UBound( strArrCmtMode ) <> 3 Then
	Err.Raise 1000, , "パラメータ：対象コメントが不正です（CmtMode= " & strCmtMode & " )"    
End If

lngSelInfo        = Request("selInfo")
lngCheckSelInfo   = Request("chkSelInfo")
lngRsvNo          = Request("rsvno")
lngAuthNote       = Request("authNote")

strPerId          = Request("perId")
strOrgCd1         = Request("orgCd1")
strOrgCd2         = Request("orgCd2")
strCtrPtCd        = Request("ctrPtCd")
strUpdDate	      = Request("updDate")
strUpdUser        = Session.Contents("userId")

lngSeq          = Request("seq")
strPubNoteDivCd = Request("pubNoteDivCd")
lngDispKbn      = Request("chkDispKbn")
lngOnlyDispKbn  = Request("onlyDispKbn")
strUpdDate      = Request("updDate")
strUpdUser      = Session.Contents("userId")
lngBoldFlg      = Request("checkBoldFlg")
strPubNote      = Request("pubNote")
strDispColor    = Request("dispColor")

'### 2004/06/23 Added by Ishihara@FSIT 更新時には再読込をしないため、削除フラグの持ち越し
vntDelflg = Array(0)
vntDelflg(0) = Request("delflg")
'### 2004/06/23 Added End

strArrDefaultDispKbn	= ConvIStringToArray(Request("arrDefaultDispKbn"))
strArrOnlyDispKbn		= ConvIStringToArray(Request("arrOnlyDispKbn"))

'パラメタのデフォルト値設定
lngRsvNo   = IIf(lngRsvNo = "", 0,  lngRsvNo )
lngSeq     = IIf(IsNumeric(lngSeq) = False, 0,  lngSeq )

If lngSelInfo ="" Then
	For i = 0 To 3
		'対象コメント
		If strArrCmtMode(i) = 1 Then
			'修正時ですでに対象コメントが決まっている
			If lngSelInfo <> "" Then
				If lngSeq > 0 Then
					Err.Raise 1000, , "パラメータ：対象コメントが不正です（CmtMode= " & strCmtMode & " )"
				End If
			Else
				lngSelInfo = CStr(i + 1)
			End If
		End If
	Next
End If

lngCheckSelInfo   = IIf(lngCheckSelInfo = "", lngSelInfo,  lngCheckSelInfo )
lngCheckSelInfo   = IIf(lngCheckSelInfo = "", "1",  lngCheckSelInfo )

objHainsUser.SelectHainsUser strUpdUser, strUserName, _
							,,,,,,,,,,,,,,,,,,,,,,, _
							lngAuthNote, lngDefNoteDispKbn



If strMode = "" Then
	If lngSeq > 0 Then
		strMode = "update"
	Else
		strMode = "insert"
	End If
End If

Do

	lngDivCnt = objPubNote.SelectPubNoteDivList ( strUpdUser, strArrPubNoteDivCd, strArrPubNoteDivName,  strArrDefaultDispKbn, strArrOnlyDispKbn)

	'予約番号あり？
	If lngRsvNo <> 0 Then
		
		'受診情報検索
		Ret = objConsult.SelectConsult(lngRsvNo, _    
									, _    
									strCslDate,    _    
									strPerId,      _    
									strCsCd,       _    
									strCsName,     _    
									strOrgCd1, strOrgCd2, _    
									strOrgName,     _    
									, , _    
									strAge,        _    
									, , , , , , , , , , , , _    
									strDayId,   _    
									, , 0, , , , , , , , , , , , , _
									strCtrPtCd, , _    
									strLastName,   _    
									strFirstName,  _    
									strLastKName,  _    
									strFirstKName, _    
									strBirth,      _    
									strGender )    
            
		'受診情報が存在しない場合はエラーとする    
		If Ret = False Then    
			Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"    
		End If
	Else

		'個人ＩＤあり？
		If strPerId <> "" Then
			'個人ＩＤ情報を取得する
			Ret = objPerson.SelectPerson_lukes(strPerId, _
							strLastName, _
							strFirstName, _
							strLastKName, _
							strFirstKName, _
							,  _
							strBirth, _
							strGender )
			'個人情報が存在しない場合
			If Ret = False Then
				Err.Raise 1000, , "個人情報が取得できません。（個人ＩＤ　= " & strPerId &" ）"
			End If

			strAge = objFree.CalcAge(strBirth)
		End If

		'団体コードあり？
		If strOrgCd1 <> "" And strOrgCd2 <> "" Then
			'団体情報を取得する
			Ret = objOrg.SelectOrg_lukes(strOrgCd1, strOrgCd2, _
							 , , _
							strOrgName )
			'団体情報が存在しない場合
			If Ret = False Then
				Err.Raise 1000, , "団体情報が取得できません。（団体コード　= " & strOrgCd1 & "-" & strOrgCd2 &  "）"
			End If
		End If

		'契約コードあり？？？



	End If




	'削除ボタン押下時
	If strAction = "delete" Then

		Ret = objPubNote.DeletePubNote( _
										lngSelInfo, _
										lngRsvNo , strPerId & "", _
										strOrgCd1 & "", strOrgCd2 & "", strCtrPtCd & "", _
										lngSeq )
		
		
		'更新エラー時は処理を抜ける
		If Ret <> 0 Then
			Exit Do
		Else
			'エラーがなければ呼び元画面を再表示して自身を閉じる
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.parent.location.reload(); close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End
			Exit Do
		End If

	End If

	'保存ボタン押下時
	If strAction = "save" Then
'				Err.Raise 1000, , lngCheckSelInfo & " " & lngSelInfo &" ）"

		'入力チェック
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If


		'登録処理
		Ret = objPubNote.EntryPubNote( _
										strMode, lngCheckSelInfo, _
										lngRsvNo , strPerId & "", _
										strOrgCd1 & "", strOrgCd2 & "", strCtrPtCd & "", _
										lngSeq, strPubNoteDivCd, _
                                  		lngDispKbn, strUpdUser, lngBoldFlg, _
                                  		strPubNote & "", strDispColor & "", _
										lngNewSeq )
		'更新エラー時は処理を抜ける
		If Ret <> 0 Then
			Exit Do
		Else
			'エラーがなければ呼び元画面を再表示して自身を閉じる
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.parent.location.reload(); close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End
			Exit Do
		End If



	End If



	
	'分類等を変えただけのときは読み直ししない
	If strAction = "change" Then
		Exit Do
	End If

	'更新モード
	If strMode = "update" Then
		
		'コメント情報取得
'### 2004/3/24 Updated by Ishihara@FSIT 削除データ表示対応
'		lngNoteCnt = objPubNote.SelectPubNote ( _
'								    lngSelInfo, _
'                           	    	0, "", "", _
'                           	    	lngRsvNo, _
'                            	    strPerId & "", _
'                            	    strOrgCd1 & "", _
'                            	    strOrgCd2 & "", _
'                            	    strCtrPtCd & "", _
'                            	    lngSeq, _
'                            	    "", 0, _
'								    strUpdUser, _
'                            	    vntSeq, _
'                            	    vntPubNoteDivCd, _
'                            	    vntPubNoteDivName, _
'                            	    vntDefaultDispKbn, _
'                            	    vntOnlyDispKbn, _
'                            	    vntDispKbn, _
'                            	    vntUpdDate, _
'                            	    vntUpdUser, _
'                            	    vntUserName, _
'                            	    vntBoldFlg, _
'                            	    vntPubNote, _
'                            	    vntDispColor _
'								)
		lngNoteCnt = objPubNote.SelectPubNote ( _
								    lngSelInfo, _
                           	    	0, "", "", _
                           	    	lngRsvNo, _
                            	    strPerId & "", _
                            	    strOrgCd1 & "", _
                            	    strOrgCd2 & "", _
                            	    strCtrPtCd & "", _
                            	    lngSeq, _
                            	    "", 0, _
								    strUpdUser, _
                            	    vntSeq, _
                            	    vntPubNoteDivCd, _
                            	    vntPubNoteDivName, _
                            	    vntDefaultDispKbn, _
                            	    vntOnlyDispKbn, _
                            	    vntDispKbn, _
                            	    vntUpdDate, _
                            	    vntUpdUser, _
                            	    vntUserName, _
                            	    vntBoldFlg, _
                            	    vntPubNote, _
                            	    vntDispColor, _
									,,,,1, vntDelFlg)
'### 2004/3/24 Updated End

		If lngNoteCnt <= 0 Then
				Err.Raise 1000, , "コメント情報が取得できません。（個人ＩＤ　= " & strPerId &" ）"
		End If
 		
		lngSeq         		= vntSeq(0)         	
        strPubNoteDivCd		= vntPubNoteDivCd(0)	
        strPubNoteDivName	= vntPubNoteDivName(0)	
        lngDispKbn     		= vntDispKbn(0)     	
        lngBoldFlg     	 	= vntBoldFlg(0)    
        strPubNote     	 	= vntPubNote(0)    
        strDispColor        = vntDispColor(0)  
        strUpdDate			= vntUpdDate(0)	
        strUpdUser          = vntUpdUser(0)    
        strUserName			= vntUserName(0)	
        lngOnlyDispKbn      = vntOnlyDispKbn(0) 	

	'新規
	Else
		lngDispKbn = IIf(lngDispKbn = "", lngDefNoteDispKbn,  lngDispKbn )
		lngDispKbn = IIf(lngDispKbn = "", lngAuthNote,  lngDispKbn )
		lngDispKbn = IIf(lngDispKbn = "", "3",  lngDispKbn )

		If strPubNoteDivCd <> "" Then
			objPubNote.SelectPubNoteDiv strPubNoteDivCd, strPubNoteDivName, , lngOnlyDispKbn
		End If
	End If


	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : コメント分類のドロップダウンリスト編集
'
' 引数　　 : 
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function PubNoteDivList()


	If lngDivCnt = 0 Then
		strArrPubNoteDivCd = Array()
		Redim Preserve strArrPubNoteDivCd(0)
		strArrPubNoteDivName = Array()
		Redim Preserve strArrPubNoteDivName(0)
		strArrDefaultDispKbn = Array()
		Redim Preserve strArrDefaultDispKbn(0)
		strArrOnlyDispKbn = Array()
		Redim Preserve strArrOnlyDispKbn(0)
	End If

	PubNoteDivList = EditDropDownListFromArray2("pubNoteDivCd", strArrPubNoteDivCd, strArrPubNoteDivName, strPubNoteDivCd, NON_SELECTED_DEL, "javascript:chkPubNoteDiv()" )

	If strPubNoteDivCd = "" Then
		lngOnlyDispKbn = strArrOnlyDispKbn(0)
	End If

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 入力の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()
	Dim vntArrMessage	'エラーメッセージの集合
	Dim strMessage		'エラーメッセージ

	'各値チェック処理
	With objCommon
		'コメント

		strPubNote = .StrConvKanaWide( strPubNote )

		strMessage = .CheckWideValue("コメント", strPubNote, 400)

		'改行文字も1字として含む旨を通達
		If strMessage <> "" Then
			.AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
		End If
	End With

	'戻り値の編集
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>コメント情報詳細</TITLE>
<!-- #include virtual = "/webHains/includes/colorGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
//コメント分類選択時処理
function chkPubNoteDiv() {

//	var i
<%
	'### 2004/06/24 Added by Ishihara@FSIT 削除データにはロジック不要
	If vntDelFlg(0) <> "1" Then
%>
	with ( document.entryForm ) {
		for ( i = 0; i < arrPubNoteDivCd.length; i++ ){
			if ( arrPubNoteDivCd[i].value == pubNoteDivCd.value ){
				//デフォルトの表示対象セット
				dispKbn.value = arrDefaultDispKbn[i].value;
				// デフォルトの表示対象に対する権限が無い場合
				if (( authNote.value == 1 && (dispKbn.value == 2)) ||
					( authNote.value == 2 && (dispKbn.value == 1))){
					//権限のある表示対象へ
					dispKbn.value = authNote.value;
				} 
				chkDispKbn.value = dispKbn.value;
				onlyDispKbn.value = arrOnlyDispKbn[i].value;
				break;
			}
		}
		act.value = "change"
		submit();
	}
<%
	Else
%>
	return null;
<%
	End If
%>

}

//表示対象チェック
function checkDispKbnAct(index) {

	with ( document.entryForm ) {
		if (index == 0 ){
			dispKbn.value = (dispKbn[index].checked ? '3' : '');
		} else if (index == 1 ){
			dispKbn.value = (dispKbn[index].checked ? '1' : '');
		} else if (index == 2 ){
			dispKbn.value = (dispKbn[index].checked ? '2' : '');
		}
		chkDispKbn.value = dispKbn.value;

	}

}
//対象コメントチェック
function checkSelInfoAct(index) {

	with ( document.entryForm ) {
		if (index == 0 ){
			chkSelInfo.value = (selInfoBtn[index].checked ? '1' : '');
		} else if (index == 1 ){
			chkSelInfo.value = (selInfoBtn[index].checked ? '2' : '');
		} else if (index == 2 ){
			chkSelInfo.value = (selInfoBtn[index].checked ? '3' : '');
		} else if (index == 3 ){
			chkSelInfo.value = (selInfoBtn[index].checked ? '4' : '');
		}

	}

}

//太字区分チェック
function checkBoldFlgAct() {

	with ( document.entryForm ) {
		checkBoldFlg.value = (checkBoldFlg.checked ? '1' : '');
	}

}

//保存処理
function saveData(mode) {

	if ( document.entryForm.pubNote.value == '' ){
		alert( "コメントが入力されていません。");
	} else 	if ( document.entryForm.rsvno.value == 0 && document.entryForm.chkSelInfo.value == 1 ){
		alert( "予約番号がないため受診情報コメントとしては登録できません。");
	} else if ( document.entryForm.perId.value == '' && document.entryForm.chkSelInfo.value == 2 ){
		alert( "個人ＩＤがないため個人コメントとしては登録できません。");
	} else if (( document.entryForm.orgCd1.value == '' || document.entryForm.orgCd2.value == '' )
              && document.entryForm.chkSelInfo.value == 3 ){
		alert( "団体コードがないため団体コメントとしては登録できません。");
	} else if ( document.entryForm.ctrPtCd.value == '' && document.entryForm.chkSelInfo.value == 4 ){
		alert( "契約パターンコードがないため契約コメントとしては登録できません。");
	} else {
		document.entryForm.act.value = "save";
		document.entryForm.mode.value = mode;
		document.entryForm.submit();
	}

}

//削除処理
function deleteData() {

	if ( !confirm( "このコメントを削除してもよろしいですか。")){
		return;
	}
	document.entryForm.act.value = "delete";
	document.entryForm.submit();

}
// 親ウインドウへ戻る
function goBackPage() {

	// カラーウインドウを閉じる
	colorGuide_closeGuideColor();

	close();

	return false;
}

// 色選択ガイド画面を表示
function showGuideColor( elemName, colorElemName ) {

	colorGuide_showGuideColor( document.entryForm.elements[elemName], colorElemName );

}
//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 20px 0 0 25px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:colorGuide_closeGuideColor()">
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="act"    VALUE="<%= strAction %>">
<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">
<INPUT TYPE="hidden" NAME="cmtMode" VALUE="<%= strCmtMode %>">
<INPUT TYPE="hidden" NAME="selInfo"   VALUE="<%= lngSelInfo %>">
<INPUT TYPE="hidden" NAME="authNote"   VALUE="<%= lngAuthNote %>">
<INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
<INPUT TYPE="hidden" NAME="seq"   VALUE="<%= lngSeq %>">
<INPUT TYPE="hidden" NAME="perId"   VALUE="<%= strPerId %>">
<INPUT TYPE="hidden" NAME="orgCd1"   VALUE="<%= strOrgCd1 %>">
<INPUT TYPE="hidden" NAME="orgCd2"   VALUE="<%= strOrgCd2 %>">
<INPUT TYPE="hidden" NAME="ctrPtCd"   VALUE="<%= strCtrPtCd %>">
<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">コメント情報詳細</B></TD>
	</TR>
</TABLE>
<BR>
<TABLE WIDTH="562" BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD></TD>
<%
		'権限が無い場合
		If lngAuthNote = 0  Then
%>
			<TD ALIGN="right"><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="24" WIDTH="77" BORDER="0">　<IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="24" WIDTH="77" BORDER="0"></TD>
<%
		Else
			If strMode = "update" Then

				If vntDelFlg(0) = "1" Then
%>
					<TD><FONT COLOR="RED"><B>このデータは削除されたデータです。修正できません。</B></FONT></TD>
<%
				Else
%>
				<TD ALIGN="right">
				<% '2005.08.22 権限管理 Add by 李　--- START %>
				<%  if Session("PAGEGRANT") = "3"  then   %>
					<A HREF="javascript:deleteData()"><IMG SRC="../../images/delete.gif" ALT="" HEIGHT="24" WIDTH="77" BORDER="0"></A>　
				<%  elseif Session("PAGEGRANT") = "2"  then   %>
					<A HREF="javascript:saveData( '<%= strMode %>' )" ><IMG SRC="../../images/save.gif" ALT="" HEIGHT="24" WIDTH="77" BORDER="0"></A>
				<%  elseif Session("PAGEGRANT") = "4"  then    %>
					<A HREF="javascript:deleteData()"><IMG SRC="../../images/delete.gif" ALT="" HEIGHT="24" WIDTH="77" BORDER="0"></A>　
					<A HREF="javascript:saveData( '<%= strMode %>' )" ><IMG SRC="../../images/save.gif" ALT="" HEIGHT="24" WIDTH="77" BORDER="0"></A>
				<%  else    %>
					&nbsp;
				<%  end if  %>
				<% '2005.08.22 権限管理 Add by 李　--- END %>
				</TD>
<%
				End If
			Else
%>
				<TD ALIGN="right">
				<% '2005.08.22 権限管理 Add by 李　--- START %>
				<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
					<IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="24" WIDTH="77" BORDER="0">　<A HREF="javascript:saveData( '<%= strMode %>' )" ><IMG SRC="../../images/save.gif" ALT="" HEIGHT="24" WIDTH="77" BORDER="0"></A>
				<%  else    %>
					&nbsp;
				<%  end if  %>
				<% '2005.08.22 権限管理 Add by 李　--- END %>
				</TD>
<%
			End If
		End If
%>
	</TR>
</TABLE>
<BR>
<%
	'メッセージの編集
	If strAction <> "" Then

		Select Case strAction

			'保存完了時は「保存完了」の通知
			Case "saveend"
				Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

			'削除完了時は「削除完了」の通知
			Case "deleteend"
				Call EditMessage("削除が完了しました。", MESSAGETYPE_NORMAL)

			'さもなくばエラーメッセージを編集
			Case Else
				Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

		End Select

	End If
%>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
	</TR>
<%
	'予約番号があるとき
	If lngRsvNo <> 0 Then
%>
		<TR>
			<TD NOWRAP>受診日：</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %> </B></FONT></TD>
			<TD NOWRAP>　コース：</TD>
		    <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
		    <TD NOWRAP>　当日ＩＤ：</TD>
		    <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strDayId %></B></FONT></TD>
		    <TD NOWRAP>　団体：</TD>
		    <TD NOWRAP><%= strOrgName %></TD>
		</TR>
<%
	Else
%>
		<TR>
			<TD></TD>
			<TD></TD>
<%
		'コース名あり？
		If strCsName <> "" Then
%>
			<TD NOWRAP>コース：</TD>
		    <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %>　</B></FONT></TD>
<%
		End If
%>
			<TD></TD>
			<TD></TD>
<%
		'団体名あり？
		If strOrgName <> "" Then
%>
		    <TD NOWRAP>団体：</TD>
		    <TD NOWRAP><%= strOrgName %></TD>
<%
		End If
%>
		</TR>
<%
	End If
%>
</TABLE>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD></TD>
		<TD></TD>
		<TD></TD>
	</TR>
	<TR>
<%
		'個人ＩＤあり？
		If strPerId <> "" THEN
%>
			<TD NOWRAP><%= strPerId %></TD>
			<TD NOWRAP>　<B><%= strLastName %>　<%= strFirstName %></B> （<FONT SIZE="-1"><%= strLastKName %>　<%= strFirstKName %></FONT>）</TD>
			<TD NOWRAP>　　<%= objCommon.FormatString(CDate(strBirth), "ge（yyyy）.m.d") %>生　<%= Int(strAge) %>歳　<%= IIf(strGender = "1", "男性", "女性") %></TD>
<%
		Else
%>
			<TD></TD>
			<TD></TD>
			<TD></TD>
<%
		End If
%>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
	<TR>
		<TD NOWRAP>コメント種類</TD>
		<TD>：</TD>
<!--
		<TD COLSPAN="2"><SELECT NAME="csCd" ONCHANGE="JavaScript:changeCourse()">
-->
<%
		'権限が無い場合
		If lngAuthNote = 0  Then
%>
			<TD><%= strPubNoteDivName %></TD>
<%
		Else
%>
			<TD><%= PubNoteDivList() %></TD>
<%
			For i = 0 To lngDivCnt - 1
%>
				<INPUT TYPE="hidden" NAME="arrPubNoteDivCd" VALUE="<%= strArrPubNoteDivCd(i) %>" >
				<INPUT TYPE="hidden" NAME="arrPubNoteDivName" VALUE="<%= strArrPubNoteDivName(i) %>" >
				<INPUT TYPE="hidden" NAME="arrDefaultDispKbn" VALUE="<%= strArrDefaultDispKbn(i) %>" >
				<INPUT TYPE="hidden" NAME="arrOnlyDispKbn" VALUE="<%= strArrOnlyDispKbn(i) %>" >
<%
			Next
		End If
%>
		<TD WIDTH="100%"></TD>
<%
%>
	</TR>
	<TR>
		<INPUT TYPE="hidden" NAME="chkDispKbn" VALUE="<%= lngDispKbn %>" >
		<INPUT TYPE="hidden" NAME="onlyDispKbn" VALUE="<%= lngOnlyDispKbn %>" >
		<TD NOWRAP>表示対象</TD>
		<TD>：</TD>
		<TD COLSPAN="2">
<%
		'表示対象区分しばりあり？ または権限が無い
		If lngOnlyDispKbn = "1" Or lngOnlyDispKbn = "2" Or lngAuthNote = 0  Then
%>
			<INPUT TYPE="hidden" NAME="dispKbn" VALUE="<%= lngDispKbn %>">
<%
		Else
%>
			<INPUT TYPE="radio" NAME="dispKbn" VALUE="<%= lngDispKbn %>" <%= IIf(lngDispKbn = "3", " CHECKED", "") %> ONCLICK="javascript:checkDispKbnAct(0)"  BORDER="0">共通　
<%
		End If
%>
<%
		'表示対象区分 事務のみ？ または権限が無い
		If lngOnlyDispKbn = "2" Or lngAuthNote = 0 Or lngAuthNote = 2  Then
%>
			<INPUT TYPE="hidden" NAME="dispKbn" VALUE="<%= lngDispKbn %>">
<%
		Else
%>
			<INPUT TYPE="radio" NAME="dispKbn" VALUE="<%= lngDispKbn %>" <%= IIf(lngDispKbn = "1", " CHECKED", "") %> ONCLICK="javascript:checkDispKbnAct(1)"  BORDER="0">医療情報　
<%
		End If
%>
<%
		'表示対象区分 医療のみ？ または権限が無い
		If lngOnlyDispKbn = "1"  Or lngAuthNote = 0 Or lngAuthNote = 1 Then
%>
			<INPUT TYPE="hidden" NAME="dispKbn" VALUE="<%= lngDispKbn %>">
<%
		Else
%>
			<INPUT TYPE="radio" NAME="dispKbn" VALUE="<%= lngDispKbn %>" <%= IIf(lngDispKbn = "2", " CHECKED", "") %> ONCLICK="javascript:checkDispKbnAct(2)"  BORDER="0">事務情報
<%
		End If
%>
		</TD>
		<TD WIDTH="100%"></TD>
	</TR>
	<TR>
		<TD VALIGN="top" NOWRAP>コメント</TD>
		<TD VALIGN="top">：</TD>
<!--
		<TD VALIGN="top"><A HREF="commentList.html" TARGET="_blank"><IMG SRC="../../images/question.gif" ALT="" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
-->
		<TD WIDTH="467"><TEXTAREA NAME="pubNote" ROWS="4" COLS="63" STYLE="ime-mode:active;"><%= strPubNote %></TEXTAREA></TD>
		<TD WIDTH="100%"></TD>
	</TR>
	<INPUT TYPE="hidden" NAME="chkSelInfo" VALUE="<%= lngCheckSelInfo %>" >
<%
	lngWrtFlg = 0
	For i = 0 To 3
		If strArrCmtMode(i) = 1 Then
			Select Case i
				Case 0
					strWkSentence = "今回の健診についてコメントを登録"
				Case 1
					strWkSentence = "この受診者に対してコメントを登録"
				Case 2
					strWkSentence = "この団体に対してコメントを登録"
				Case 3
					strWkSentence = "今回の契約に対してコメントを登録"
			End Select
	
			If lngWrtFlg = 0 Then
				lngWrtFlg = 1
%>
				<TR>
					<TD NOWRAP>対象コメント</TD>
					<TD>：</TD>
<%
			Else
%>
				<TR>
					<TD NOWRAP></TD>
					<TD></TD>
<%
			End If

			strWkSelInfo = Cstr(i+1)
%>
				<TD COLSPAN="2"><INPUT TYPE="radio" NAME="selInfoBtn" VALUE="<%= lngCheckSelInfo %>" <%= IIf(lngCheckSelInfo = strWkSelInfo, " CHECKED", "") %> ONCLICK="javascript:checkSelInfoAct(<%= i %>)" BORDER="0"><% = strWkSentence %></TD>
				<TD WIDTH="100%"></TD>
			</TR>
<%
		End If
	Next
%>
	<TR>
		<TD NOWRAP></TD>
		<TD></TD>
		<TD COLSPAN="2"></TD>
		<TD WIDTH="100%"></TD>
	</TR>
	<TR>
		<TD NOWRAP>表示色</TD>
		<TD>：</TD>
		<TD COLSPAN="2">
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:showGuideColor('dispColor', 'elemDispColor')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="色選択ガイド表示"></A></TD>
					<TD><INPUT TYPE="hidden" NAME="dispColor" VALUE="<%= strDispColor %>"><FONT SIZE="4" COLOR="#<%= strDispColor %>" ID="elemDispColor">■</FONT></TD>
					<TD>　<INPUT TYPE="checkbox" NAME="checkBoldFlg" VALUE="1" <%= IIf(lngBoldFlg <> 0, " CHECKED", "") %>  ONCLICK="javascript:checkBoldFlgAct()" border="0"></FONT><FONT COLOR="black">このコメントは太字で表示する</FONT></TD>
				</TR>
			</TABLE>
		</TD>
		<TD WIDTH="100%"></TD>
	</TR>
	<TR HEIGHT="4">
		<TD VALIGN="top" NOWRAP HEIGHT="4"></TD>
		<TD VALIGN="top" HEIGHT="4"></TD>
		<TD HEIGHT="4"></TD>
		<TD WIDTH="467" HEIGHT="4"></TD>
		<TD WIDTH="100%" HEIGHT="4"></TD>
	</TR>
	<TR>
		<TD NOWRAP>更新日時</TD>
		<TD>：</TD>
		<TD COLSPAN="2"><%= strUpdDate %></TD>
		<TD WIDTH="100%"></TD>
	</TR>
	<TR>
		<TD NOWRAP>更新者</TD>
		<TD>：</TD>
		<TD COLSPAN="2"><%= strUserName %></TD>
		<TD WIDTH="100%"></TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD WIDTH="500"></TD>
		<TD>
			<A HREF="javascript:goBackPage()"><IMG SRC="/webHains/images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A></TD>
		</TD>
	</TR>
</TABLE>
</FORM>
</BODY>
</HTML>
