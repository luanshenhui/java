<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       受診セット変更 (Ver0.0.1)
'       AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objConsult          '受診情報アクセス用
Dim objResult           '結果情報アクセス用

'### 2004.09.24 ADD By FSIT)Gouda 受診情報の表示(受診日、当日ID、個人名、予約番号)
Dim objCommon           '共通クラス
Dim objConsult2         '受診クラス
'### 2004.09.24 ADD End 

'### 2016.01.27 張 個人情報追加の為、修正 STR ##############################################
Dim objFree                 '汎用情報アクセス用
'### 2016.01.27 張 個人情報追加の為、修正 END ##############################################

'引数値
Dim lngRsvNo            '予約番号
Dim strCslDate          '受診日
Dim strPerId            '個人ＩＤ
Dim strCtrPtCd          '契約パターンコード
Dim strCslDivCd         '受診区分コード
Dim strOptCd            'オプションコード
Dim strOptBranchNo      'オプション枝番
Dim strConsults         '受診要否
Dim strGrpCd            'グループコード
Dim strOrgRslCmtCd      '元の結果コメントコード
Dim strRslCmtCd         '結果コメントコード

'### 2004.09.24 ADD By FSIT)Gouda 受診情報の表示(受診日、当日ID、個人名、予約番号) 
Dim strLastName         '姓
Dim strFirstName        '名
Dim strLastKName        'カナ姓
Dim strFirstKName       'カナ名
Dim strDayId            '当日ID
'### 2004.09.24 ADD End 


'### 2016.01.27 張 個人情報追加の為、修正 STR ##############################################
Dim strCsCd                 'コースコード
Dim strCsName               'コース名
Dim strBirth                '生年月日
Dim strAge                  '年齢
Dim strGender               '性別
Dim strGenderName           '性別名称
Dim strOrgName              '団体名称

Dim strEraBirth             '生年月日(和暦)
Dim strRealAge              '実年齢

Dim lngConsCount            '受診回数
Dim lngCnt
'### 2016.01.27 張 個人情報追加の為、修正 END ##############################################


Dim strUpdGrpCd()       'グループコード
Dim strUpdRslCmtCd()    '結果コメントコード
Dim lngUpdCount         '更新項目数

Dim strMessage          'エラーメッセージ
Dim Ret                 '関数戻り値
Dim i                   'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'### 2004.09.24 ADD By FSIT)Gouda 受診情報の表示(受診日、当日ID、個人名、予約番号) 
'オブジェクトのインスタンス作成
Set objCommon   = Server.CreateObject("HainsCommon.Common")
Set objConsult2 = Server.CreateObject("HainsConsult.Consult")
'### 2004.09.24 ADD End 

'引数値の取得
lngRsvNo       = CLng("0" & Request("rsvNo"))
strCslDate     = Request("cslDate")
strPerId       = Request("perId")
strCtrPtCd     = Request("ctrPtCd")
strCslDivCd    = Request("cslDivCd")
strGrpCd       = ConvIStringToArray(Request("grpCd"))
strOrgRslCmtCd = ConvIStringToArray(Request("orgRslCmtCd"))
strRslCmtCd    = ConvIStringToArray(Request("rslCmtCd"))


'### 2016.01.27 張 個人情報追加の為、修正 STR ##############################################

'### 2004.09.24 ADD By FSIT)Gouda 受診情報の表示(受診日、当日ID、個人名、予約番号)
'受診情報検索
'Ret = objConsult2.SelectConsult(lngRsvNo,       _
'                                , , , , , , , , , , , _
'                                , , , , , , , , , , , , _
'                                strDayId,       _
'                                , , , , , , , , , , , , , , , , , _
'                                strLastName,    _
'                                strFirstName,   _
'                                strLastKName,   _
'                                strFirstKName )
''### 2004.09.24 ADD End 

Ret = objConsult2.SelectConsult(lngRsvNo, _
                                , _
                                strCslDate, _
                                strPerId, _
                                strCsCd, _
                                strCsName, _
                                , , _
                                strOrgName, _
                                , , _
                                strAge, _
                                , , , , , , , , , , , , _
                                strDayId, _
                                , , 0, , , , , , , , , , , , , , , _
                                strLastName, _
                                strFirstName, _
                                strLastKName, _
                                strFirstKName, _
                                strBirth, _
                                strGender, _
                                , , , , , , lngConsCount )

    '生年月日(西暦＋和暦)の編集
    strEraBirth = objCommon.FormatString(CDate(strBirth), "ge（yyyy）.m.d")

    '実年齢の計算
    If strBirth <> "" Then
        Set objFree = Server.CreateObject("HainsFree.Free")
        strRealAge = objFree.CalcAge(strBirth)
        Set objFree = Nothing
    Else
        strRealAge = ""
    End If

    '小数点以下の切り捨て
    If IsNumeric(strRealAge) Then
        strRealAge = CStr(Int(strRealAge))
    End If

'### 2016.01.27 張 個人情報追加の為、修正 END ##############################################


'保存ボタン押下時
If Not IsEmpty(Request("save.x")) Then

    '更新すべきグループを抽出
    If IsArray(strGrpCd) Then

        '変更の発生したもののみを取得
        For i = 0 To UBound(strGrpCd)
            If strRslCmtCd(i) <> strOrgRslCmtCd(i) Then
                ReDim Preserve strUpdGrpCd(lngUpdCount)
                ReDim Preserve strUpdRslCmtCd(lngUpdCount)
                strUpdGrpCd(lngUpdCount)    = strGrpCd(i)
                strUpdRslCmtCd(lngUpdCount) = strRslCmtCd(i)
                lngUpdCount = lngUpdCount + 1
            End If
        Next

    End If

    '保存すべき項目があれば
    If lngUpdCount > 0 Then

        '保存処理
        Set objResult = Server.CreateObject("HainsResult.Result")

        '検査中止情報の更新
        Ret = objResult.UpdateResultForChangeSet(lngRsvNo, Request.ServerVariables("REMOTE_ADDR"), Session("USERID"), strUpdGrpCd, strUpdRslCmtCd, strMessage)

        Set objResult = Nothing

    Else

        '存在しない場合は正常終了とし、リダイレクトさせる
        Ret = True

    End If

    '保存に成功した場合はリダイレクト
    If Ret = True Then
        Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?rsvNo=" & lngRsvNo & "&act=saveend"
        Response.End
    End If

'初期表示時
Else

    Set objConsult = Server.CreateObject("HainsConsult.Consult")

    '受診情報読み込み
    objConsult.SelectConsult lngRsvNo, 0, strCslDate, strPerId, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , strCtrPtCd, , , , , , , , , , , , strCslDivCd

    '現在の受診オプション検査読み込み
    objConsult.SelectConsult_O lngRsvNo, strOptCd, strOptBranchNo

    Set objConsult = Nothing

    '受診すべきオプションが存在する場合
    If IsArray(strOptCd) Then

        '読み込んだ全てのオプションの受診要否を「受診する」に設定
        strConsults = Array()
        ReDim Preserve strConsults(UBound(strOptCd))
        For i = 0 To UBound(strConsults)
            strConsults(i) = "1"
        Next

    End If

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>受診セット変更</TITLE>
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/cmtGuide.inc" -->
<!--
var lngSelectedIndex;  // ガイド表示時に選択されたエレメントのインデックス

// 保存前に現在の選択状態から受診要否を設定する
function setConsults() {

    var objForm = document.entryForm;

    var arrOptCd;       // オプションコード
    var arrOptBranchNo; // オプション枝番
    var arrConsults;    // 受診要否

    var selOptCd;       // オプションコード

    // オプション検査の受診状態を取得する
    arrOptCd       = new Array();
    arrOptBranchNo = new Array();
    arrConsults    = new Array();

    // 全エレメントを検索
    for ( var i = 0; i < objForm.elements.length; i++ ) {

        // チェックボックス、ラジオボタン以外はスキップ
        if ( objForm.elements[ i ].type != 'checkbox' && objForm.elements[ i ].type != 'radio' ) {
            continue;
        }

        // カンマでコードと枝番を分離してオプションコードを追加
        selOptCd = objForm.elements[ i ].value.split(',');
        arrOptCd[ arrOptCd.length ]             = selOptCd[ 0 ];
        arrOptBranchNo[ arrOptBranchNo.length ] = selOptCd[ 1 ];

        // チェック状態により受診要否を設定
        arrConsults[ arrConsults.length ] = objForm.elements[ i ].checked ? '1' : '0';

    }

    // submit用の項目へ編集
    objForm.optCd.value       = arrOptCd;
    objForm.optBranchNo.value = arrOptBranchNo;
    objForm.consults.value    = arrConsults;

}

// 結果コメントガイド呼び出し
function callCmtGuide( index ) {

    // 選択されたエレメントのインデックスを退避(結果コメントコード・結果コメント名のセット用関数にて使用する)
    lngSelectedIndex = index;

    // ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
    cmtGuide_CalledFunction = setCmtInfo;

    // 結果コメントガイド表示(入力完了コメントのみ)
    showGuideCmt( 1 );
}

// 結果コメントコード・結果コメント名のセット
function setCmtInfo() {

    var myForm = document.entryForm;

    var rslCmtNameElement;  // 結果コメント名を編集するエレメントの名称
    var rslCmtName;         // 結果コメント名を編集するエレメント自身

    // 予め退避したインデックス先のエレメントに、ガイド画面で設定された連絡域の値を編集
    if ( myForm.rslCmtCd.length != null ) {
        myForm.rslCmtCd[ lngSelectedIndex ].value = cmtGuide_RslCmtCd;
    } else {
        myForm.rslCmtCd.value = cmtGuide_RslCmtCd;
    }

    document.getElementById('rcNm' + lngSelectedIndex).innerHTML = cmtGuide_RslCmtName;

}

// 結果コメントのクリア
function clearCmtInfo( index ) {

    var myForm = document.entryForm;

    if ( myForm.rslCmtCd.length != null ) {
        myForm.rslCmtCd[ index ].value = '';
    } else {
        myForm.rslCmtCd.value = '';
    }

    document.getElementById('rcNm' + index).innerHTML = '';

}
//-->
</SCRIPT>
<style type="text/css">
    body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeGuideCmt()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
    <TR>
        <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">■</SPAN>受診セット変更</B></TD>
    </TR>
</TABLE>
<%
If Request("act") = "saveend" Then
    EditMessage "保存が完了しました。", MESSAGETYPE_NORMAL
Else
'## 2004.01.14 Mod By T.Takagi@FSIT エラーは配列で返るので条件修正
'   If strMessage <> "" Then
    If Not IsEmpty(strMessage) Then
'## 2004.01.14 Mod End
        EditMessage strMessage, MESSAGETYPE_WARNING
    End If
End If
%>
<BR>
<%'### 2016.01.27 張 個人情報追加の為、修正 STR ############################################## %>
<!--## 2004.09.24 ADD By FSIT)Gouda 受診情報の表示(受診日、当日ID、個人名、予約番号)-->
<!--TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
    <TR>
        <TD VALIGN="top" NOWRAP>受診日：<FONT COLOR="#ff6600"><B><%= strCslDate %></B></FONT></TD>
        <TD VALIGN="top" WIDTH="10"></TD>
        <TD VALIGN="top" NOWRAP>当日ID：<FONT COLOR="#ff6600"><B><%= objCommon.FormatString(strDayId, "0000") %></B></FONT></TD>		
        <TD VALIGN="top" WIDTH="10"></TD>
        <TD VALIGN="top" NOWRAP>個人名：<B><%= strLastName %>　<%= strFirstName %></B>　(<FONT SIZE="2"><%= strLastKName %>　<%= strFirstKName %>）</FONT></TD>	
        <TD VALIGN="top" WIDTH="10"></TD>
        <TD VALIGN="top" NOWRAP>予約番号：<FONT COLOR="#ff6600"><B><%= lngRsvNo %></B></FONT></TD>
    </TR>
</TABLE-->

<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
    <TR>
        <TD NOWRAP>受診日：</TD>
        <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %></B></FONT></TD>
        <TD NOWRAP>&nbsp;&nbsp;コース：</TD>
        <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
        <TD NOWRAP>&nbsp;&nbsp;当日ＩＤ：</TD>
        <TD NOWRAP><FONT COLOR="#ff6600"><B><%= objCommon.FormatString(strDayID, "0000") %></B></FONT></TD>
        <TD NOWRAP>&nbsp;&nbsp;団体：</TD>
        <TD NOWRAP><%= strOrgName %></TD>
    </TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
        <TD NOWRAP><B><%= strPerId %></B>&nbsp;&nbsp;</TD>
        <TD NOWRAP><B><%= strLastName & " " & strFirstName %></B> （<FONT SIZE="-1"><%= strLastKname & "　" & strFirstKName %></FONT>）&nbsp;&nbsp;</TD>
        <TD NOWRAP><%= FormatDateTime(strBirth, 1) %>生　<%= strRealAge %>歳（<%= Int(strAge) %>歳）&nbsp;&nbsp;<%= IIf(strGender = "1", "男性", "女性") %></TD>
        <TD NOWRAP></TD>
        <TD NOWRAP>&nbsp;&nbsp;受診回数：</TD>
        <TD NOWRAP><FONT COLOR="#ff6600"><B><%= lngConsCount %></B></FONT>&nbsp;&nbsp;</TD>
    </TR>
</TABLE>
<%'### 2016.01.27 張 個人情報追加の為、修正 END ############################################## %>

<BR>
<!--## 2004.09.24 ADD End-->
    <% '2005.08.22 権限管理 Add by 李　--- START %>
    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
    <INPUT TYPE="image" NAME="save" SRC="../../images/save.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="保存する">
    <%  else    %>
         &nbsp;
    <%  end if  %>
    <% '2005.08.22 権限管理 Add by 李　--- END %>

    <BR><BR>

<FONT COLOR="#ffa500">●</FONT>検査セットに結果コメントをセットすることにより、結果が空白でも未入力になりません（金額に変更はありません）。<BR><BR>
<INPUT TYPE="hidden" NAME="rsvNo"    VALUE="<%= lngRsvNo    %>">
<INPUT TYPE="hidden" NAME="cslDate"  VALUE="<%= strCslDate  %>">
<INPUT TYPE="hidden" NAME="perId"    VALUE="<%= strPerId    %>">
<INPUT TYPE="hidden" NAME="ctrPtCd"  VALUE="<%= strCtrPtCd  %>">
<INPUT TYPE="hidden" NAME="cslDivCd" VALUE="<%= strCslDivCd %>">
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
        <TD VALIGN="top"><% EditSet() %></TD>
        <TD><IMG SRC="/webhains/images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
        <TD VALIGN="top"><% EditComment() %></TD>
    </TR>
</TABLE>
</FORM>
</BODY>
</HTML>
<%
Sub EditSet()

    Dim objContract         '契約情報アクセス用

    'オプション検査情報
    Dim strArrOptCd         'オプションコード
    Dim strArrOptBranchNo   'オプション枝番
    Dim strOptName          'オプション名
    Dim strOptSName         'オプション名
    Dim strSetColor         'セットカラー
    Dim strConsult          '受診要否
    Dim strBranchCount      'オプション枝番数
    Dim strAddCondition     '追加条件
    Dim strHideQuestion     '問診画面非表示
    Dim lngCount            'オプション検査数

    Dim blnConsult          '受診チェックの要否
    Dim strChecked          'チェックボックスのチェック状態

    Dim strPrevOptCd        '直前レコードのオプションコード
    Dim lngOptGrpSeq        'オプショングループのSEQ値
    Dim strElementType      'オプション選択用のエレメント種別
    Dim strElementName      'オプション選択用のエレメント名
    Dim lngOptIndex         '編集したオプションのインデックス
    Dim i, j                'インデックス

    Set objContract = Server.CreateObject("HainsContract.Contract")

    '指定契約パターンの全オプション検査を取得
    lngCount = objContract.SelectCtrPtOptFromConsult(strCslDate, strCslDivCd, strCtrPtCd, strPerId, , , , True, False, strArrOptCd, strArrOptBranchNo, strOptName, strOptSName, strSetColor, , , , , strBranchCount, strAddCondition, , , , strHideQuestion)

    Set objContract = Nothing
%>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="3">
        <TR BGCOLOR="#e0e0e0" ALIGN="center">
            <TD COLSPAN="5" NOWRAP>検査セット名</TD>
        </TR>
<%
        '読み込んだオプション検査情報の検索
        For i = 0 To lngCount - 1

            '問診画面表示対象であれば
            If strHideQuestion(i) = "" Then

                '直前レコードとオプションコードが異なる場合
                If strArrOptCd(i) <> strPrevOptCd Then

                    'まず編集するエレメントを設定する(枝番数が１つならチェックボックス、さもなくばラジオボタン選択)
                    strElementType = IIf(CLng(strBranchCount(i)) = 1, "checkbox", "radio")

                    'オプション編集用のエレメント名を定義する
                    lngOptGrpSeq   = lngOptGrpSeq + 1
                    strElementName = "opt_" & CStr(lngOptGrpSeq)

                End If

                '受診チェック要否の判定開始
                blnConsult = False

                '引数指定時
                If IsArray(strOptCd) And IsArray(strOptBranchNo) Then

                    '引数指定されたオプションに対してチェックをつける
                    For j = 0 To UBound(strOptCd)
                        If strOptCd(j) = strArrOptCd(i) And strOptBranchNo(j) = strArrOptBranchNo(i) And strConsults(j) = "1" Then
                            blnConsult = True
                            Exit For
                        End If
                    Next

                End If

                '直前レコードとオプションコードが異なる場合はセパレータを編集
                If strPrevOptCd <> "" And strArrOptCd(i) <> strPrevOptCd Then
%>
                    <TR><TD HEIGHT="3"></TD></TR>
<%
                End If

                strChecked = IIf(blnConsult, " CHECKED", "")
%>
                <TR>
                    <TD><%= IIf(blnConsult, "○", "&nbsp;") %></TD>
                    <TD NOWRAP><%= strArrOptCd(i) %></TD>
                    <TD NOWRAP><%= "-" & strArrOptBranchNo(i) %></TD>
                    <TD NOWRAP>：</TD>
                    <TD NOWRAP><FONT COLOR="<%= strSetColor(i) %>">■</FONT><%= strOptName(i) %></TD>
                </TR>
<%
                lngOptIndex = lngOptIndex + 1

                '現レコードのオプションコードを退避
                strPrevOptCd = strArrOptCd(i)

            End If

        Next
%>
    </TABLE>
<%
End Sub

Sub EditComment()

    Dim objRslCmt           '結果コメント情報アクセス用

    Dim strArrGrpCd         'グループコード
    Dim strArrGrpName       'グループ名
    Dim strArrConsults      '受診フラグ
    Dim strArrRslCmtCd      '結果コメントコード
    Dim strArrRslCmtName    '結果コメント名
    Dim lngCount            'グループ数

    Dim i                   'インデックス

    Set objRslCmt = Server.CreateObject("HainsRslCmt.RslCmt")

    '結果コメント情報読み込み
    lngCount = objRslCmt.SelectRslCmtListForChangeSet(lngRsvNo, "CHGSETGRP", strArrGrpCd, strArrGrpName, strArrConsults, strArrRslCmtCd, strArrRslCmtName)

    Set objRslCmt = Nothing
%>
    <TABLE BORDER="1" CELLSPACING="2" CELLPADDING="0">
        <TR BGCOLOR="#e0e0e0">
            <TD NOWRAP>検査セット名</TD>
            <TD WIDTH="300" NOWRAP>検査コメント</TD>
        </TR>
<%
        For i = 0 To lngCount - 1
%>
            <TR>
<%
                '依頼がある場合
                If strArrConsults(i) <> "" Then
%>
                    <TD NOWRAP><%= strArrGrpName(i) %></TD>
                    <TD><INPUT TYPE="hidden" NAME="grpCd" VALUE="<%= strArrGrpCd(i) %>"><INPUT TYPE="hidden" NAME="consults" VALUE="<%= strArrConsults(i) %>"><INPUT TYPE="hidden" NAME="orgRslCmtCd" VALUE="<%= strArrRslCmtCd(i) %>">
                        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                            <TR>
                                <TD><INPUT TYPE="hidden" NAME="rslCmtCd" VALUE="<%= strArrRslCmtCd(i) %>"><A HREF="javascript:callCmtGuide(<%= i %>)"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="結果コメントガイド表示"></A></TD>
                                <TD><A HREF="javascript:clearCmtInfo(<%= i %>)"><IMG SRC="../../images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="結果コメントをクリア"></A></TD>
                                <TD ID="rcNm<%= i %>" NOWRAP><%= IIf(strArrRslCmtName(i) <> "", Replace(strArrRslCmtName(i), Chr(1), "、"), "&nbsp;") %></TD>
                            </TR>
                        </TABLE>
                    </TD>
<%
                Else
%>
                    <TD NOWRAP><FONT COLOR="#cccccc"><B><DEL><%= strArrGrpName(i) %></DEL></B></FONT></TD>
                    <TD><INPUT TYPE="hidden" NAME="grpCd" VALUE="<%= strArrGrpCd(i) %>"><INPUT TYPE="hidden" NAME="consults" VALUE="<%= strArrConsults(i) %>"><INPUT TYPE="hidden" NAME="orgRslCmtCd" VALUE="<%= strArrRslCmtCd(i) %>">
                        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                            <TR>
                                <TD><INPUT TYPE="hidden" NAME="rslCmtCd" VALUE="<%= strArrRslCmtCd(i) %>"><IMG SRC="../../images/spacer.gif" WIDTH="21" HEIGHT="21" ALT=""></A></TD>
                            </TR>
                        </TABLE>
                    </TD>
<%
                End If
%>
            </TR>
<%
        Next
%>
    </TABLE>
<%
End Sub
%>
