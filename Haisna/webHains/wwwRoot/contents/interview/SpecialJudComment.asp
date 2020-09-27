<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   階層化コメント  (Ver0.0.1)
'	   AUTHER  
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
Const DISPMODE_SPADVICE = 5     '表示分類：特定健診
Const JUDCLASSCD_SPADVICE = 90  '判定分類コード：特定健診

'データベースアクセス用オブジェクト
Dim objCommon             '共通クラス
Dim objSpecialInterview   '特定健診面接情報アクセス用

'パラメータ
Dim	strWinMode          'ウィンドウモード
Dim lngRsvNo            '予約番号
Dim strAct              '処理状態

'階層化コメント
Dim vntSpecialCmtSeq    '表示順
Dim vntSpecialCmtCd     '階層化コメントコード
Dim vntSpecialCmtStc    '階層化コメント文章
Dim vntSpecialClassCd   '判定分類コード
Dim lngSpecialCmtCnt    '行数

'更新するコメント情報
Dim vntUpdCmtSeq        '表示順
Dim vntUpdSpecialCmtCd  '階層化コメントコード
Dim lngUpdCount         '更新項目数

'変更履歴用
Dim vntUpdSpecialCmtStc '階層化コメント

Dim i, j                'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objSpecialInterview	= Server.CreateObject("HainsSpecialInterview.SpecialInterview")

'引数値の取得
strAct              = Request("act")
strWinMode          = Request("winmode")
lngRsvNo            = Request("rsvno")

'更新するコメント情報
lngSpecialCmtCnt   = Clng("0" & Request("SpecialCmtCnt"))
vntUpdSpecialCmtCd  = ConvIStringToArray(Request("SpecialCmtCd"))
'変更履歴用に追加
vntUpdSpecialCmtStc= ConvIStringToArray(Request("SpecialCmtStc"))

Do
    '保存
    If strAct = "save" Then

        '階層化コメントの保存
        lngUpdCount = 0
        vntUpdCmtSeq = Array()
        ReDim vntUpdCmtSeq(-1)
        If lngSpecialCmtCnt > 0 Then
            For i = 0 To UBound(vntUpdSpecialCmtCd)
                ReDim Preserve vntUpdCmtSeq(lngUpdCount)
                vntUpdCmtSeq(lngUpdCount) = lngUpdCount + 1
                lngUpdCount = lngUpdCount + 1
            Next
        End If
        '更新履歴用に文章とユーザＩＤ追加
        objSpecialInterview.UpdateSpecialJudCmt _
                                lngRsvNo, _
                                DISPMODE_SPADVICE, _
                                vntUpdCmtSeq, _
                                vntUpdSpecialCmtCd, _
                                vntUpdSpecialCmtStc, _
                                Session.Contents("userId")

        strAct = "saveend"
    End If


    '階層化コメント取得
    lngSpecialCmtCnt = objSpecialInterview.SelectSpecialJudCmt( _
                                        lngRsvNo, _
                                        DISPMODE_SPADVICE, _
                                        vntSpecialCmtSeq, _
                                        vntSpecialCmtCd, _
                                        vntSpecialCmtstc, _
                                        vntSpecialClassCd _
                                        )

    Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>特定健診判定コメント</TITLE>
<!-- #include virtual = "/webHains/includes/commentGuide.inc"    -->
<SCRIPT TYPE="text/javascript">
<!--
var winJudComment;              // ウィンドウハンドル
var jcmGuide_CmtType;           // コメントタイプ
var jcmGuide_CmtMode;           // 処理モード(追加、挿入、修正、削除)
var jcmGuide_SelectedIndex;     // ガイド表示時に選択されたエレメントのインデックス
// 編集前
var varEditCmtCd;
var varEditCmtStc;
var varEditClassCd;
// 編集後
var varNewCmtCd;
var varNewCmtStc;
var varNewClassCd;

function selectComment( cmttype, cmtmode ) {
    var myForm = document.entryForm;
    var dispmode;
    var elemCmtCd;
    var elemCmtStc;
    var elemClassCd;
    var i;

    jcmGuide_CmtType = cmttype;
    jcmGuide_CmtMode = cmtmode;

    jcmGuide_SelectedIndex = myForm.selectSpecialList.value;
    cmtGuide_editcnt = myForm.SpecialCmtCnt.value;
    dispmode = <%= JUDCLASSCD_SPADVICE %>
    elemCmtCd = myForm.SpecialCmtCd;
    elemCmtStc = myForm.SpecialCmtStc;
    elemClassCd = myForm.SpecialClassCd;

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

    optList = myForm.selectSpecialList;

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


//保存
function saveSpecialComment() {

    // モードを指定してsubmit
    document.entryForm.act.value = 'save';
    document.entryForm.submit();

}

function saveClose(){
    if(document.entryForm.act.value == 'saveend'){
        opener.refreshForm();
        window.close();
    }

}
//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:saveClose();" ONUNLOAD="javascript:cmtGuide_closeAdviceComment();">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
    <!-- 引数値 -->
    <INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
    <INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="act"     VALUE="<%= strAct %>">

    <!-- タイトルの表示 -->
    <TABLE WIDTH="686" BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD WIDTH="100%">
                <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
                    <TR>
                        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">特定健診コメント</FONT></B></TD>
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
            <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                <A HREF="javascript:saveSpecialComment()"><IMG SRC="../../images/save.gif" ALT="入力内容を保存します" HEIGHT="24" WIDTH="77"></A>
            <%  else %>
                 &nbsp;
            <%  end if  %>	
            <BR>
            </TD>
        </TR>
    </TABLE>
    <!-- 階層化コメントの表示 -->
    <TABLE WIDTH="366" BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR>
            <TD COLSPAN="2"><B><SPAN CLASS="result">■</SPAN></B>階層化コメント</TD>
        </TR>
        <TR>
            <TD>
                <SELECT STYLE="width:600px" NAME="selectSpecialList" SIZE="7">

<%
    For i = 0 To lngSpecialCmtCnt - 1
%>
                    <OPTION VALUE="<%= vntSpecialCmtSeq(i) %>"><%= vntSpecialCmtStc(i) %></OPTION>
<%
    Next
%>
                </SELECT>
            </TD>
            <TD VALIGN="top">
                <TABLE WIDTH="64" BORDER="1" CELLSPACING="2" CELLPADDING="0">
                    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Special','add')">追加</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Special','insert')">挿入</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Special','edit')">修正</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Special','delete')">削除</A></TD>
                        </TR>
                     <%  end if  %>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <SPAN ID="SpecialList">
        <INPUT TYPE="hidden" NAME="SpecialCmtCnt" VALUE="<%= lngSpecialCmtCnt %>">
<%
For i = 0 To lngSpecialCmtCnt - 1
%>
        <INPUT TYPE="hidden" NAME="SpecialCmtSeq"  VALUE="<%= vntSpecialCmtSeq(i) %>">
        <INPUT TYPE="hidden" NAME="SpecialCmtCd"   VALUE="<%= vntSpecialCmtCd(i) %>">
        <INPUT TYPE="hidden" NAME="SpecialCmtStc"  VALUE="<%= vntSpecialCmtStc(i) %>">
        <INPUT TYPE="hidden" NAME="SpecialClassCd" VALUE="<%= vntSpecialClassCd(i) %>">
<%
Next
%>
    </SPAN>
</FORM>
</BODY>
</HTML>