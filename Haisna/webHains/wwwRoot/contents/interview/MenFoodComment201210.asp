<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   食習慣コメント(2012年10月版)  (Ver0.0.1)
'	   AUTHER  : T.Takagi@RD
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
Const DISPMODE_FOODADVICE = 6		'表示分類：新・食習慣
Const JUDCLASSCD_FOODADVICE = 57	'判定分類コード：新・食習慣

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

'更新するコメント情報
Dim vntUpdCmtSeq		'表示順
Dim vntUpdFoodCmtCd		'食習慣コメントコード
Dim lngUpdCount			'更新項目数

'## 変更履歴用　追加 2004.01.07
Dim vntUpdFoodCmtStc	'食習慣コメント


Dim i, j				'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon    = Server.CreateObject("HainsCommon.Common")
Set objInterView = Server.CreateObject("HainsInterView.InterView")

'引数値の取得
strWinMode = Request("winmode")
strGrpNo   = Request("grpno")
lngRsvNo   = Request("rsvno")
strCsCd    = Request("cscd")
strAct     = Request("act")

'更新するコメント情報
lngFoodCmtCnt    = Clng("0" & Request("FoodCmtCnt"))
vntUpdFoodCmtCd	 = ConvIStringToArray(Request("FoodCmtCd"))
vntUpdFoodCmtStc = ConvIStringToArray(Request("FoodCmtStc"))

Do

	'保存
	If strAct = "save" Then

		'食習慣コメントの保存
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

		objInterview.UpdateTotalJudCmt lngRsvNo, DISPMODE_FOODADVICE, vntUpdCmtSeq, vntUpdFoodCmtCd, vntUpdFoodCmtStc, Session.Contents("userId")

		strAct = "saveend"

	End If

	'食習慣コメント取得
	lngFoodCmtCnt = objInterview.SelectTotalJudCmt(lngRsvNo, DISPMODE_FOODADVICE, 1, 1, strCsCd , 0, vntFoodCmtSeq, vntFoodCmtCd, vntFoodCmtstc, vntFoodClassCd)

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
	} else {
		return;
	}

	if ( jcmGuide_CmtMode == 'insert' || jcmGuide_CmtMode == 'edit' || jcmGuide_CmtMode == 'delete' ) {
		if ( jcmGuide_SelectedIndex == 0 ) {
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

    /** 2012/09/24 張 食習慣関連総合コメント登録後コメント登録画面閉じるように変更 START **/
    // 総合コメント保存終了後は、コメント登録画面閉じる
    if(document.entryForm.act.value == 'saveend'){
        opener.refreshForm();
        window.close();
    }
    /** 2012/09/24 張 食習慣関連総合コメント登録後コメント登録画面閉じるように変更 END   **/

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
<BODY ONLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"   VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="act"     VALUE="<%= strAct %>">

	<!-- タイトルの表示 -->
	<TABLE WIDTH="686" BORDER="0" CELLSPACING="0" CELLPADDING="0" style="margin:10px 0 0;">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">食習慣コメント</FONT></B></TD>
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
			<% If Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" Then %>
				<A HREF="javascript:saveMenFoodComment()"><IMG SRC="../../images/save.gif" ALT="入力内容を保存します" HEIGHT="24" WIDTH="77"></A>
			<% Else %>
                &nbsp;
            <% End If %>	
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
</FORM>
</BODY>
</HTML>
