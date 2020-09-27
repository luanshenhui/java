<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   認識レベルの登録（ヘッダ） (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const GRPCD_RECOGLEVEL = "X018"	'認識レベルグループコード
Const JUDCLASSCD_LIFEADVICE = 50	'判定分類コード：生活指導

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objInterView		'面接情報アクセス用
Dim objResult			'検査結果アクセス用COMオブジェクト

'パラメータ
Dim	strWinMode			'ウィンドウモード
Dim strGrpNo			'グループNo
Dim lngRsvNo			'予約番号（今回分）
Dim strCsCd				'コースコード
Dim strAct				'処理状態

'検査結果
Dim vntPerId			'予約番号
Dim vntCslDate			'検査項目コード
Dim vntHisNo			'履歴No.
Dim vntRsvNo			'予約番号
Dim vntItemCd			'検査項目コード
Dim vntSuffix			'サフィックス
Dim vntResultType		'結果タイプ
Dim vntItemType			'項目タイプ
Dim vntItemName			'検査項目名称
Dim vntResult			'検査結果
Dim lngRslCnt			'検査結果数
Dim vntRslCmtCd1		'結果コメント１
Dim vntRslCmtCd2		'結果コメント２

'実際に更新する項目情報を格納した検査結果
Dim vntUpdItemCd		'検査項目コード
Dim vntUpdSuffix		'サフィックス
Dim vntUpdResult		'検査結果
Dim vntUpdRslCmtCd1		'結果コメント１
Dim vntUpdRslCmtCd2		'結果コメント２
Dim lngUpdCount			'更新項目数
Dim strArrMessage		'エラーメッセージ

Dim i, j				'インデックス
Dim index				'インデックス
Dim vntRecogLevelCd		'認識レベル(コード)
Dim vntRecogLevelStr	'認識レベル(文字列)
Dim strRecogLevel		'認識レベル

Dim strUpdUser			'更新者
Dim strIPAddress		'IPアドレス

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

vntUpdItemCd		= ConvIStringToArray(Request("itemcd"))
vntUpdSuffix		= ConvIStringToArray(Request("suffix"))
vntUpdResult		= ConvIStringToArray(Request("recogLevel"))
vntUpdRslCmtCd1		= ConvIStringToArray(Request("cmtcd1"))
vntUpdRslCmtCd2		= ConvIStringToArray(Request("cmtcd2"))

Do	
	'保存
	If strAct = "save" Then
		If Not IsEmpty(vntUpdItemCd) Then
			'更新者の設定
			strUpdUser = Session("USERID")
			'IPアドレスの取得
			strIPAddress = Request.ServerVariables("REMOTE_ADDR")

			'オブジェクトのインスタンス作成
			Set objResult  = Server.CreateObject("HainsResult.Result")

			'検査結果更新
'			strArrMessage = objResult.UpdateRsl_tk( _
'								strUpdUser, _
'								strIPAddress, _
'								lngRsvNo, _
'								vntUpdItemCd, _
'								vntUpdSuffix, _
'								vntUpdResult, _
'								vntUpdRslCmtCd1, _
'								vntUpdRslCmtCd2 _
'								)
			objResult.UpdateResult lngRsvNo, strIPAddress, strUpdUser, vntUpdItemCd, vntUpdSuffix, vntUpdResult, vntUpdRslCmtCd1, vntUpdRslCmtCd2, strArrMessage
			If Not IsEmpty(strArrMessage) Then
				Exit Do
			End If

			'オブジェクトのインスタンス削除
			Set objResult = Nothing
		End If

		'保存完了
		strAct = "saveend"
	End If
	'認識レベル取得
	''## 2006.05.10 Mod by 李  *****************************
	''前回歴表示モード設定
'	lngRslCnt = objInterView.SelectHistoryRslList( _
'						lngRsvNo, _
'						2, _
'						GRPCD_RECOGLEVEL, _
'						0, _
'						"", _
'						0, _
'						0, _
'						0, _
'						vntPerId, _
'						vntCslDate, _
'						vntHisNo, _
'						vntRsvNo, _
'						vntItemCd, _
'						vntSuffix, _
'						vntResultType, _
'						vntItemType, _
'						vntItemName, _
'						, _
'						vntResult, , _
'						vntRslCmtCd1, , _
'						vntRslCmtCd2 _
'						)

	lngRslCnt = objInterView.SelectHistoryRslList( _
						lngRsvNo, _
						2, _
						GRPCD_RECOGLEVEL, _
						1, _
						strCsCd, _
						0, _
						0, _
						0, _
						vntPerId, _
						vntCslDate, _
						vntHisNo, _
						vntRsvNo, _
						vntItemCd, _
						vntSuffix, _
						vntResultType, _
						vntItemType, _
						vntItemName, _
						, _
						vntResult, , _
						vntRslCmtCd1, , _
						vntRslCmtCd2 _
						)
''## 2006.05.10 Mod End. *********************************


	If lngRslCnt < 0 Then
		Err.Raise 1000, , "認識レベルが取得できません。（予約番号 = " & lngRsvNo & ")"
	End If

    vntRecogLevelCd  = Array("1", "2", "3", "4", "5", "0")
    vntRecogLevelStr = Array("☆", "☆☆", "☆☆☆", "☆☆☆☆", "☆☆☆☆☆", "面接未実施")

	Exit Do
Loop
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>認識レベルの登録</TITLE>
<!-- #include virtual = "/webHains/includes/commentGuide.inc"    -->
<SCRIPT TYPE="text/javascript">
<!--
var varEditCmtCd;
var varEditCmtStc;
var varEditClassCd;
var varEditchkCmtDel;

// コメントの選択
function selectComment() {
	var myForm = parent.list.document.entryForm;
	var i;

	// コメントを編集エリアにセット
	cmtGuide_editcnt = myForm.CmtCnt.value;
	cmtGuide_varEditCmtCd = new Array();
	varEditCmtCd = new Array();
	varEditCmtStc = new Array();
	varEditClassCd = new Array();
	varEditchkCmtDel = new Array();

	cmtGuide_varEditCmtCd.length = 0;
	varEditCmtCd.length = 0;
	varEditCmtStc.length = 0;
	varEditClassCd.length = 0;
	varEditchkCmtDel.length = 0;

	for ( i = 0; i < cmtGuide_editcnt; i++ ){
		cmtGuide_varEditCmtCd.length ++;
		varEditCmtCd.length ++;
		varEditCmtStc.length ++;
		varEditClassCd.length ++;
		varEditchkCmtDel.length ++;

		if ( isNaN(myForm.TtlJudCmtCd.length) ){
			cmtGuide_varEditCmtCd[cmtGuide_varEditCmtCd.length - 1] = myForm.TtlJudCmtCd.value;
			varEditCmtCd[varEditCmtCd.length - 1] = myForm.TtlJudCmtCd.value;
			varEditCmtStc[varEditCmtStc.length - 1] = myForm.TtlJudCmtstc.value;
			varEditClassCd[varEditClassCd.length - 1] = myForm.TtlJudClassCd.value;
			varEditchkCmtDel[varEditchkCmtDel.length - 1] = (myForm.chkCmtDel.checked ? 'CHECKED' : '');
		} else {
			cmtGuide_varEditCmtCd[cmtGuide_varEditCmtCd.length - 1] = myForm.TtlJudCmtCd[i].value;
			varEditCmtCd[varEditCmtCd.length - 1] = myForm.TtlJudCmtCd[i].value;
			varEditCmtStc[varEditCmtStc.length - 1] = myForm.TtlJudCmtstc[i].value;
			varEditClassCd[varEditClassCd.length - 1] = myForm.TtlJudClassCd[i].value;
			varEditchkCmtDel[varEditchkCmtDel.length - 1] = (myForm.chkCmtDel[i].checked ? 'CHECKED' : '');
		}
	}
	// ### 2004/11/12 Add by Gouda@FSIT 生活指導コメントの表示分類
	// コメントガイドの呼出
	//cmtGuide_showAdviceComment(<%= JUDCLASSCD_LIFEADVICE %>, setComment);
	cmtGuide_showAdviceComment(<%= JUDCLASSCD_LIFEADVICE %>, setComment, entryForm.recogLevel.value);
	// ### 2004/11/12 Add End
}

// コメントをセット
function setComment() {
	var myForm = parent.list.document.entryForm;
	var elem   = parent.list.document.getElementById('LifeAdviceList');
	var strHtml;
	var i;

	// 生活指導コメントの再描画
	for ( i = 0; i < cmtGuide_varSelCmtCd.length; i++ ){
		varEditCmtCd.length ++;
		varEditCmtStc.length ++;
		varEditClassCd.length ++;

		varEditCmtCd[varEditCmtCd.length - 1] = cmtGuide_varSelCmtCd[i];
		varEditCmtStc[varEditCmtStc.length - 1] = cmtGuide_varSelCmtStc[i];
		varEditClassCd[varEditClassCd.length - 1] = cmtGuide_varSelClassCd[i];
	}
	cmtGuide_editcnt = eval(cmtGuide_editcnt) + eval(cmtGuide_varSelCmtCd.length);

	strHtml = '<TABLE BORDER="0" CELLSPACING="4" CELLPADDING="0" WIDTH="908">\n';
	for ( i = 0; i < cmtGuide_editcnt; i++ ) {
		strHtml = strHtml + '<TR>\n';
		strHtml = strHtml + '<TD WIDTH="100%">' + varEditCmtStc[i] + '</TD>\n';
		strHtml = strHtml + '<TD NOWRAP VALIGN="top"><INPUT TYPE="checkbox" NAME="chkCmtDel" ' + varEditchkCmtDel[i] + '>削除</TD>\n';
		strHtml = strHtml + '<INPUT TYPE="hidden" NAME="TtlJudCmtCd"   VALUE="' + varEditCmtCd[i] + '">\n';
		strHtml = strHtml + '<INPUT TYPE="hidden" NAME="TtlJudCmtstc"  VALUE="' + varEditCmtStc[i] + '">\n';
		strHtml = strHtml + '<INPUT TYPE="hidden" NAME="TtlJudClassCd" VALUE="' + varEditClassCd[i] + '">\n';
		strHtml = strHtml + '<INPUT TYPE="hidden" NAME="CmtDelFlag" VALUE="">\n';
		strHtml = strHtml + '</TR>\n';
		strHtml = strHtml + '<TR>\n';
		strHtml = strHtml + '<TD HEIGHT="1" BGCOLOR="#999999"></TD>\n';
		strHtml = strHtml + '<TD NOWRAP VALIGN="top" HEIGHT="1" BGCOLOR="#999999"></TD>\n';
		strHtml = strHtml + '</TR>\n';
	}
	strHtml = strHtml + '</TABLE>\n';

	elem.innerHTML = strHtml;
	myForm.CmtCnt.value = cmtGuide_editcnt;

}

//保存
function saveRecogLevel() {
	var i;

	// モードを指定してsubmit(ヘッダー)
	with ( parent.header.document.entryForm ) {
		act.value = 'save';
		submit();
	}

	// モードを指定してsubmit(ボディ)
	with ( parent.list.document.entryForm ) {
		if( CmtCnt.value > 0  ) {
			if( chkCmtDel.length > 1 ) {
				for ( i = 0; i < chkCmtDel.length; i++ ) {
					CmtDelFlag[i].value = (chkCmtDel[i].checked ? '1' : '');
				}
			} else {
				CmtDelFlag.value = (chkCmtDel.checked ? '1' : '');
			}
			act.value = 'save';
			submit();
		}
	}

}

//虚血性心疾患画面呼び出し
function callMenKyoketsu() {
	var url;							// URL文字列

	url = '/WebHains/contents/interview/MenKyoketsu.asp';
	url = url + '?winmode=' + '<%= strWinMode %>';
	url = url + '&grpno=' + '<%= strGrpNo %>';
	url = url + '&rsvno=' + '<%= lngRsvNo %>';
	url = url + '&cscd=' + '<%= strCsCd %>';

	parent.location.href(url);

}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:cmtGuide_closeAdviceComment()">
<%
	'「別ウィンドウで表示」の場合、ヘッダー部分表示
	If strWinMode = 1 Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
		Call interviewHeader(lngRsvNo, 0)
	End If
%>
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"   VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="act"     VALUE="<%= strAct %>">

	<!-- タイトルの表示 -->
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="900">
		<TR>
			<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">認識レベルの登録</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2" WIDTH="900">
		<TR>
			<TD NOWRAP>認識レベル：</TD>
<%
	index = -1
	For i=0 To lngRslCnt -1
		If vntHisNo(i) = 1 Then
			index = i
			Exit For
		End If
	Next
	If index > -1 Then
%>
			<INPUT TYPE="hidden" NAME="itemcd" VALUE="<%= vntItemCd(index) %>">
			<INPUT TYPE="hidden" NAME="suffix" VALUE="<%= vntSuffix(index) %>">
			<INPUT TYPE="hidden" NAME="cmtcd1" VALUE="<%= vntRslCmtCd1(index) %>">
			<INPUT TYPE="hidden" NAME="cmtcd2" VALUE="<%= vntRslCmtCd2(index) %>">
			<TD><%= EditDropDownListFromArray("recogLevel", vntRecogLevelCd, vntRecogLevelStr, vntResult(index), NON_SELECTED_ADD) %></TD>
<%
	Else
%>
			<TD><%= EditDropDownListFromArray("recogLevel", vntRecogLevelCd, vntRecogLevelStr, -1, NON_SELECTED_ADD) %></TD>
<%
	End If
%>
			<TD><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="10"></TD>
			<TD NOWRAP>前回認識レベル：</TD>
<%
	index = -1
	strRecogLevel = "&nbsp;"
	For i=0 To lngRslCnt -1
		If vntHisNo(i) = 2 Then
			For j=0 TO UBound(vntRecogLevelCd)
				If vntResult(i) = vntRecogLevelCd(j) Then
					index = j
					Exit For
				End If
			Next
		End If
		If index > -1 Then 
			strRecogLevel = vntRecogLevelStr(index)
			Exit For
		End IF
	Next
%>
			<TD NOWRAP><%= strRecogLevel %></TD>
			<TD NOWRAP WIDTH="100%" ALIGN="right"><A HREF="javascript:selectComment()">コメントの選択</A></TD>
			<TD><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="20"></TD>
			
			<TD>
			<% '2005.08.22 権限管理 Add by 李　--- START %>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
				<A HREF="javascript:saveRecogLevel()"><IMG SRC="../../images/save.gif" ALT="保存" HEIGHT="24" WIDTH="77"></A>
			<%  else    %>
                 &nbsp;
            <%  end if  %>
			<% '2005.08.22 権限管理 Add by 李  ---- END %>
			</TD>
			
			<TD><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="20"></TD>
			<TD NOWRAP><A HREF="JavaScript:callMenKyoketsu()">虚血性心疾患画面へ</A></TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>