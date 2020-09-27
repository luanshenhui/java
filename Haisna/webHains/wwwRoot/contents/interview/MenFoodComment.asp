<%@ LANGUAGE="VBScript" %>
<%
'========================================
'管理番号：SL-SN-Y0101-007
'修正日  ：2011.11.17
'担当者  ：FJTH)MURTA
'修正内容：面接支援画面　表示不具合対応
'========================================
'-----------------------------------------------------------------------------
'	   食習慣、献立コメント  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const DISPMODE_FOODADVICE = 3		'表示分類：食習慣
Const DISPMODE_MENUADVICE = 4		'表示分類：献立
Const JUDCLASSCD_FOODADVICE = 51	'判定分類コード：食習慣
Const JUDCLASSCD_MENUADVICE = 52	'判定分類コード：献立

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objInterView		'面接情報アクセス用

'パラメータ
Dim	strWinMode			'ウィンドウモード
Dim strGrpNo			'グループNo
Dim lngRsvNo			'予約番号（今回分）
Dim strCsCd				'コースコード
Dim strAct				'処理状態

'食習慣コメント
Dim vntFoodCmtSeq		'表示順
Dim vntFoodCmtCd		'判定コメントコード
Dim vntFoodCmtStc		'判定コメント文章
Dim vntFoodClassCd		'判定分類コード
Dim lngFoodCmtCnt		'行数

'献立コメント
Dim vntMenuCmtSeq		'表示順
Dim vntMenuCmtCd		'判定コメントコード
Dim vntMenuCmtStc		'判定コメント文章
Dim vntMenuClassCd		'判定分類コード
Dim lngMenuCmtCnt		'行数

'更新するコメント情報
Dim vntUpdCmtSeq		'表示順
Dim vntUpdFoodCmtCd		'食習慣コメントコード
Dim vntUpdMenuCmtCd		'献立コメントコード
Dim lngUpdCount			'更新項目数

'## 変更履歴用　追加 2004.01.07
Dim vntUpdFoodCmtStc	'食習慣コメント
Dim vntUpdMenuCmtStc	'献立コメント


Dim i, j				'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'引数値の取得
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")
strAct				= Request("act")

'## 2012.09.11 Add by T.Takagi@RD 切替日付による画面切替
'切替日以降の受診日であれば2012年版用の画面へ
If IsVer201210(lngRsvNo) Then
	Response.Redirect "MenFoodComment201210.asp?winmode=" & strWinMode & "&grpno=" & strGrpNo & "&rsvno=" & lngRsvNo & "&cscd=" & strCsCd
End If
'## 2012.09.11 Add End

'更新するコメント情報
lngFoodCmtCnt   = Clng("0" & Request("FoodCmtCnt"))
vntUpdFoodCmtCd	= ConvIStringToArray(Request("FoodCmtCd"))
'## 変更履歴用に追加　2004.01.07
vntUpdFoodCmtStc= ConvIStringToArray(Request("FoodCmtStc"))
lngMenuCmtCnt   = Clng("0" & Request("MenuCmtCnt"))
vntUpdMenuCmtCd	= ConvIStringToArray(Request("MenuCmtCd"))
'## 変更履歴用に追加　2004.01.07
vntUpdMenuCmtStc= ConvIStringToArray(Request("MenuCmtStc"))

Do
	'保存
	If strAct = "save" Then

		'食習慣コメントコメントの保存
		lngUpdCount = 0
		vntUpdCmtSeq = Array()
		ReDim vntUpdCmtSeq(-1)
		If lngFoodCmtCnt > 0 Then
			For i = 0 To UBound(vntUpdFoodCmtCd)
				ReDim Preserve vntUpdCmtSeq(lngUpdCount)
				vntUpdCmtSeq(lngUpdCount) = lngUpdCount + 1
				lngUpdCount = lngUpdCount + 1
			Next
		End If
		'## 2004.01.07 更新履歴用に文章とユーザＩＤ追加
		objInterview.UpdateTotalJudCmt _
								lngRsvNo, _
								DISPMODE_FOODADVICE, _
								vntUpdCmtSeq, _
								vntUpdFoodCmtCd, _
								vntUpdFoodCmtStc, _
								Session.Contents("userId")

		'献立コメントコメントの保存
		lngUpdCount = 0
		vntUpdCmtSeq = Array()
		ReDim vntUpdCmtSeq(-1)
		If lngMenuCmtCnt > 0 Then
			For i = 0 To UBound(vntUpdMenuCmtCd)
				ReDim Preserve vntUpdCmtSeq(lngUpdCount)
				vntUpdCmtSeq(lngUpdCount) = lngUpdCount + 1
				lngUpdCount = lngUpdCount + 1
			Next
		End If
		'## 2004.01.07 更新履歴用に文章とユーザＩＤ追加
		objInterview.UpdateTotalJudCmt _
								lngRsvNo, _
								DISPMODE_MENUADVICE, _
								vntUpdCmtSeq, _
								vntUpdMenuCmtCd, _
								vntUpdMenuCmtStc, _
								Session.Contents("userId")


		strAct = "saveend"
	End If

	'食習慣コメント取得
'** #### 2011.11.17 SL-SN-Y0101-007 MOD START #### **
'	lngFoodCmtCnt = objInterview.SelectTotalJudCmt( _
'										lngRsvNo, _
'										DISPMODE_FOODADVICE, _
'										1, 0,  , 0, _
'										vntFoodCmtSeq, _
'										vntFoodCmtCd, _
'										vntFoodCmtstc, _
'										vntFoodClassCd _
'										)
	lngFoodCmtCnt = objInterview.SelectTotalJudCmt( _
										lngRsvNo, _
										DISPMODE_FOODADVICE, _
										1, 1, strCsCd , 0, _
										vntFoodCmtSeq, _
										vntFoodCmtCd, _
										vntFoodCmtstc, _
										vntFoodClassCd _
										)
'** #### 2011.11.17 SL-SN-Y0101-007 MOD END #### **

	'献立コメント取得
'** #### 2011.11.17 SL-SN-Y0101-007 MOD START #### **
'	lngMenuCmtCnt = objInterview.SelectTotalJudCmt( _
'										lngRsvNo, _
'										DISPMODE_MENUADVICE, _
'										1, 0,  , 0, _
'										vntMenuCmtSeq, _
'										vntMenuCmtCd, _
'										vntMenuCmtstc, _
'										vntMenuClassCd _
'										)
	lngMenuCmtCnt = objInterview.SelectTotalJudCmt( _
										lngRsvNo, _
										DISPMODE_MENUADVICE, _
										1, 1, strCsCd , 0, _
										vntMenuCmtSeq, _
										vntMenuCmtCd, _
										vntMenuCmtstc, _
										vntMenuClassCd _
										)
'** #### 2011.11.17 SL-SN-Y0101-007 MOD END #### **

Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>食習慣、献立コメント</TITLE>
<!-- #include virtual = "/webHains/includes/commentGuide.inc"    -->
<SCRIPT TYPE="text/javascript">
<!--
var winJudComment;				// ウィンドウハンドル
var jcmGuide_CmtType;			// コメントタイプ(食習慣コメント or 献立コメント)
var jcmGuide_CmtMode;			// 処理モード(追加、挿入、修正、削除)
var jcmGuide_SelectedIndex;	  	// ガイド表示時に選択されたエレメントのインデックス
// 編集前
var varEditCmtCd;
var varEditCmtStc;
var varEditClassCd;
// 編集後
var varNewCmtCd;
var varNewCmtStc;
var varNewClassCd;

// コメントの選択
function selectComment( cmttype, cmtmode ) {
	var myForm = document.entryForm;
	var dispmode;
	var elemCmtCd;
	var elemCmtStc;
	var elemClassCd;
	var i;

	jcmGuide_CmtType = cmttype;
	jcmGuide_CmtMode = cmtmode;

	if ( cmttype == 'Food' ) {
		jcmGuide_SelectedIndex = myForm.selectFoodList.value;
		cmtGuide_editcnt = myForm.FoodCmtCnt.value;
		dispmode = <%= JUDCLASSCD_FOODADVICE %>
		elemCmtCd = myForm.FoodCmtCd;
		elemCmtStc = myForm.FoodCmtStc;
		elemClassCd = myForm.FoodClassCd;
	} else
	if ( cmttype == 'Menu' ) {
		jcmGuide_SelectedIndex = myForm.selectMenuList.value;
		cmtGuide_editcnt = myForm.MenuCmtCnt.value;
		dispmode = <%= JUDCLASSCD_MENUADVICE %>
		elemCmtCd = myForm.MenuCmtCd;
		elemCmtStc = myForm.MenuCmtStc;
		elemClassCd = myForm.MenuClassCd;
	} else {
		return;
	}

	if ( jcmGuide_CmtMode == 'insert' || jcmGuide_CmtMode == 'edit' || jcmGuide_CmtMode == 'delete' ){
		if ( jcmGuide_SelectedIndex == 0 ){
			alert( "編集する行が選択されていません。" );
			return;
		}
	}

	// コメントを編集エリアにセット
	cmtGuide_varEditCmtCd = new Array(0);
	varEditCmtCd = new Array(0);
	varEditCmtStc = new Array(0);
	varEditClassCd = new Array(0);
	for ( i = 0; i < cmtGuide_editcnt; i++ ){
		if ( isNaN(elemCmtCd.length) ){
			cmtGuide_varEditCmtCd[cmtGuide_varEditCmtCd.length ++] = elemCmtCd.value;
			varEditCmtCd[varEditCmtCd.length ++] = elemCmtCd.value;
			varEditCmtStc[varEditCmtStc.length ++] = elemCmtStc.value;
			varEditClassCd[varEditClassCd.length ++] = elemClassCd.value;
		} else {
			cmtGuide_varEditCmtCd[cmtGuide_varEditCmtCd.length ++] = elemCmtCd[i].value;
			varEditCmtCd[varEditCmtCd.length ++] = elemCmtCd[i].value;
			varEditCmtStc[varEditCmtStc.length ++] = elemCmtStc[i].value;
			varEditClassCd[varEditClassCd.length ++] = elemClassCd[i].value;
		}
	}

	if ( jcmGuide_CmtMode == 'delete' ) {
		// 削除のときはコメントガイド必要なし
		setComment();
	} else {
		// コメントガイドの呼出
		cmtGuide_showAdviceComment(dispmode, setComment);
	}
}

// コメントをセット
function setComment() {
	var myForm = document.entryForm;
	var optList;
	var strHtml;
	var i;

	if ( jcmGuide_CmtType == 'Food' ) {
		optList = myForm.selectFoodList;
	} else
	if ( jcmGuide_CmtType == 'Menu' ) {
		optList = myForm.selectMenuList;
	} else {
		return;
	}

	// コメントの編集
	varNewCmtCd = new Array(0);
	varNewCmtStc = new Array(0);
	varNewClassCd = new Array(0);
		// 追加
	if ( jcmGuide_CmtMode == 'add' ) {
		for ( i = 0; i < varEditCmtCd.length; i++ ){
			varNewCmtCd[varNewCmtCd.length ++] = varEditCmtCd[i];
			varNewCmtStc[varNewCmtStc.length ++] = varEditCmtStc[i];
			varNewClassCd[varNewClassCd.length ++] = varEditClassCd[i];
		}
		for ( i = 0; i < cmtGuide_varSelCmtCd.length; i++ ){
			varNewCmtCd[varNewCmtCd.length ++] = cmtGuide_varSelCmtCd[i];
			varNewCmtStc[varNewCmtStc.length ++] = cmtGuide_varSelCmtStc[i];
			varNewClassCd[varNewClassCd.length ++] = cmtGuide_varSelClassCd[i];
		}
	} else
		// 挿入、修正
	if ( jcmGuide_CmtMode == 'insert' || jcmGuide_CmtMode == 'edit' ) {
		for ( i = 0; i < jcmGuide_SelectedIndex - 1; i++ ){
			varNewCmtCd[varNewCmtCd.length ++] = varEditCmtCd[i];
			varNewCmtStc[varNewCmtStc.length ++] = varEditCmtStc[i];
			varNewClassCd[varNewClassCd.length ++] = varEditClassCd[i];
		}
		for ( i = 0; i < cmtGuide_varSelCmtCd.length; i++ ){
			varNewCmtCd[varNewCmtCd.length ++] = cmtGuide_varSelCmtCd[i];
			varNewCmtStc[varNewCmtStc.length ++] = cmtGuide_varSelCmtStc[i];
			varNewClassCd[varNewClassCd.length ++] = cmtGuide_varSelClassCd[i];
		}
		for ( i = jcmGuide_SelectedIndex - 1; i < varEditCmtCd.length; i++ ){
			// 修正のとき選択行は外す
			if ( jcmGuide_CmtMode == 'edit' && i == jcmGuide_SelectedIndex - 1 ) continue;

			varNewCmtCd[varNewCmtCd.length ++] = varEditCmtCd[i];
			varNewCmtStc[varNewCmtStc.length ++] = varEditCmtStc[i];
			varNewClassCd[varNewClassCd.length ++] = varEditClassCd[i];
		}
	} else
		// 削除
	if ( jcmGuide_CmtMode == 'delete' ) {
		for ( i = 0; i < varEditCmtCd.length; i++ ){
			// 削除のとき選択行は外す
			if ( i == jcmGuide_SelectedIndex - 1 ) continue;

			varNewCmtCd[varNewCmtCd.length ++] = varEditCmtCd[i];
			varNewCmtStc[varNewCmtStc.length ++] = varEditCmtStc[i];
			varNewClassCd[varNewClassCd.length ++] = varEditClassCd[i];
		}
	}

	// コメントの再描画
	strHtml = '<INPUT TYPE="hidden" NAME="' + jcmGuide_CmtType + 'CmtCnt"  VALUE="' + varNewCmtCd.length + '">\n';
	for ( i = 0; i < varNewCmtCd.length; i++ ) {
		strHtml = strHtml + '<INPUT TYPE="hidden" NAME="' + jcmGuide_CmtType + 'CmtCd"   VALUE="' + varNewCmtCd[i] + '">\n';
		strHtml = strHtml + '<INPUT TYPE="hidden" NAME="' + jcmGuide_CmtType + 'CmtStc"  VALUE="' + varNewCmtStc[i] + '">\n';
		strHtml = strHtml + '<INPUT TYPE="hidden" NAME="' + jcmGuide_CmtType + 'ClassCd" VALUE="' + varNewClassCd[i] + '">\n';
	}
	document.getElementById(jcmGuide_CmtType + 'List').innerHTML = strHtml;

	// SELECTオブジェクトの再描画
	while ( optList.length > 0 ) {
		optList.options[0] = null;
	}
	for ( i = 0; i < varNewCmtCd.length; i++ ){
		optList.options[optList.length] = new Option( varNewCmtStc[i], i+1 );
	}
}

// 総合コメントガイドを閉じる
function windowClose() {

	// 総合コメントガイドを閉じる
	if ( winJudComment != null ) {
		if ( !winJudComment.closed ) {
			winJudComment.close();
		}
	}

	winJudComment = null;
}

// 保存
function saveMenFoodComment() {

	// モードを指定してsubmit
	document.entryForm.act.value = 'save';
	document.entryForm.submit();

}
//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"   VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="act"     VALUE="<%= strAct %>">

	<!-- タイトルの表示 -->
	<TABLE WIDTH="686" BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">食習慣、献立コメント</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<TABLE WIDTH="686" BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD HEIGHT="10">
			</TD>
		</TR>
		<TR>
			<TD WIDTH="100%" ALIGN="RIGHT">
			<% '2005.08.22 権限管理 Add by 李　--- START %>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
				<A HREF="javascript:saveMenFoodComment()"><IMG SRC="../../images/save.gif" ALT="入力内容を保存します" HEIGHT="24" WIDTH="77"></A>
			<%  else    %>
                 &nbsp;
            <%  end if  %>	
			<% '2005.08.22 権限管理 Add by 李　--- END %>
			<BR>
			</TD>
		</TR>
	</TABLE>
	<!-- 食習慣コメントの表示 -->
	<TABLE WIDTH="366" BORDER="0" CELLSPACING="2" CELLPADDING="0">
		<TR>
			<TD COLSPAN="2"><B><SPAN CLASS="result">■</SPAN></B>食習慣コメント</TD>
		</TR>
		<TR>
			<TD>
				<SELECT STYLE="width:600px" NAME="selectFoodList" SIZE="7">

<%
	For i = 0 To lngFoodCmtCnt - 1
%>
					<OPTION VALUE="<%= vntFoodCmtSeq(i) %>"><%= vntFoodCmtStc(i) %></OPTION>
<%
	Next
%>
				</SELECT>
			</TD>
			<TD VALIGN="top">
				<TABLE WIDTH="64" BORDER="1" CELLSPACING="2" CELLPADDING="0">
					<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Food','add')">追加</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Food','insert')">挿入</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Food','edit')">修正</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Food','delete')">削除</A></TD>
                        </TR>
                    <%  end if  %>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<!-- 献立コメントの表示 -->
	<TABLE WIDTH="366" BORDER="0" CELLSPACING="2" CELLPADDING="0">
		<TR>
			<TD COLSPAN="2"><B><SPAN CLASS="result">■</SPAN></B>献立コメント</TD>
		</TR>
		<TR>
			<TD>
				<SELECT STYLE="width:600px" NAME="selectMenuList" SIZE="7">
<%
	For i = 0 To lngMenuCmtCnt - 1
%>
					<OPTION VALUE="<%= vntMenuCmtSeq(i) %>"><%= vntMenuCmtStc(i) %></OPTION>
<%
	Next
%>
				</SELECT>
			</TD>
			<TD VALIGN="top">
				<TABLE WIDTH="64" BORDER="1" CELLSPACING="2" CELLPADDING="0">
                    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Menu','add')">追加</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Menu','insert')">挿入</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Menu','edit')">修正</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Menu','delete')">削除</A></TD>
                        </TR>
                    <%  end if  %>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<SPAN ID="FoodList">
		<INPUT TYPE="hidden" NAME="FoodCmtCnt" VALUE="<%= lngFoodCmtCnt %>">
<%
For i = 0 To lngFoodCmtCnt - 1
%>
		<INPUT TYPE="hidden" NAME="FoodCmtSeq"  VALUE="<%= vntFoodCmtSeq(i) %>">
		<INPUT TYPE="hidden" NAME="FoodCmtCd"   VALUE="<%= vntFoodCmtCd(i) %>">
		<INPUT TYPE="hidden" NAME="FoodCmtStc"  VALUE="<%= vntFoodCmtStc(i) %>">
		<INPUT TYPE="hidden" NAME="FoodClassCd" VALUE="<%= vntFoodClassCd(i) %>">
<%
Next
%>
	</SPAN>
	<SPAN ID="MenuList">
		<INPUT TYPE="hidden" NAME="MenuCmtCnt" VALUE="<%= lngMenuCmtCnt %>">
<%
For i = 0 To lngMenuCmtCnt - 1
%>
		<INPUT TYPE="hidden" NAME="MenuCmtSeq"  VALUE="<%= vntMenuCmtSeq(i) %>">
		<INPUT TYPE="hidden" NAME="MenuCmtCd"   VALUE="<%= vntMenuCmtCd(i) %>">
		<INPUT TYPE="hidden" NAME="MenuCmtStc"  VALUE="<%= vntMenuCmtStc(i) %>">
		<INPUT TYPE="hidden" NAME="MenuClassCd" VALUE="<%= vntMenuClassCd(i) %>">
<%
Next
%>
	</SPAN>
</FORM>
</BODY>
</HTML>
