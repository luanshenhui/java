<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       契約情報の参照・登録 (Ver0.0.1)
'       AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editCourseList.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editOrgHeader.inc"        -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/EditSetClassList.inc"     -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const MODE_INSERT    = "INS"    '処理モード(挿入)
Const MODE_UPDATE    = "UPD"    '処理モード(更新)
Const ACTMODE_DELETE = "delete" '動作モード(削除)

'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objContract         '契約情報アクセス用
Dim objContractControl  '契約情報アクセス用
Dim objCourse           'コース情報アクセス用
Dim objFree             '汎用情報アクセス用
DIm objOrganization     '団体情報アクセス用

'引数値
Dim strActMode          '動作モード
Dim strOrgCd1           '団体コード1
Dim strOrgCd2           '団体コード2
Dim strCsCd             'コースコード
Dim lngCtrPtCd          '契約パターンコード
Dim strSubCsCd          '（サブ）コースコード
Dim strSetClassCd       'セット分類コード
Dim strCslDivCd         '受診区分コード
Dim lngGender           '受診可能性別
Dim strStrAge           '開始年齢
Dim strEndAge           '終了年齢

'### 2016.08.04 張 限度額設定有無チェックの為追加 STR ###
Dim strLimitRate        '限度率
Dim lngLimitTaxFlg      '限度額消費税フラグ
Dim strLimitPrice       '上限金額
Dim strExceptLimit      '限度額設定除外

Dim strLimitButton      '限度額設定ボタンイメージファイル設定
Dim strLimitCheck       '限度額設定除外マーク
'### 2016.08.04 張 限度額設定有無チェックの為追加 END ###

'契約管理情報
Dim strCsName           'コース名
Dim strCtrCsName        '(契約情報における)コース名
Dim strWebColor         'webカラー
Dim strStrDate          '契約開始日
Dim strEndDate          '契約終了日
Dim strAgeCalc          '年齢起算日
Dim strCslMethod        '予約方法

'負担元情報
Dim strApDiv            '適用元区分
Dim strOrgSName         '団体略称
Dim lngCount            '負担団体数

'オプション検査情報
Dim strOptCd            'オプションコード
Dim strOptBranchNo      'オプション枝番
Dim strArrWebColor      'webカラー
Dim strArrSubCsName     '管理コース名
Dim strOptName          'オプション名
Dim strSetColor         'セットカラー
Dim strAgeName          '年齢条件
Dim strAddCondition     '追加条件
Dim strCslDivName       '受診区分
Dim strGender           '受診可能性別
Dim strSetClassName     'セット分類名
Dim strSeq              'ＳＥＱ
Dim strPrice            '負担金額
Dim strOrgDiv           '団体種別
'2005/10/21 Add by 李
Dim strTax              '消費税
'2005/10/21 Add End

'### 2016.08.03 張 セット別合計金額表示の為追加 STR ###
Dim lngTotPrice         'セット負担金額
Dim lngTotTax           'セット消費税
'### 2016.08.03 張 セット別合計金額表示の為追加 END ###

Dim lngOptCount         'オプション検査数

'汎用情報
Dim strFreeCd           '汎用コード
Dim strFreeField1       'フィールド１

Dim strMyOrgSName       '自団体略称
Dim strMessage          'エラーメッセージ
Dim strURL              'ジャンプ先のURL
Dim Ret                 '関数戻り値
Dim i, j                'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon          = Server.CreateObject("HainsCommon.Common")
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")
Set objCourse          = Server.CreateObject("HainsCourse.Course")
Set objOrganization    = Server.CreateObject("HainsOrganization.Organization")

'引数値の取得
strActMode    = Request("actMode")
strOrgCd1     = Request("orgCd1")
strOrgCd2     = Request("orgCd2")
strCsCd       = Request("csCd")
lngCtrPtCd    = CLng("0" & Request("ctrPtCd"))
strSubCsCd    = Request("subCsCd")
strSetClassCd = Request("setClassCd")
strCslDivCd   = Request("cslDivCd")
lngGender     = CLng("0" & Request("gender"))
strStrAge     = Request("strAge")
strEndAge     = Request("endAge")

'削除処理の制御
Do

    '削除指定時以外は何もしない
    If strActMode <> ACTMODE_DELETE Then
        Exit Do
    End If

    '指定契約パターンの契約情報を削除
    Ret = objContractControl.DeleteContract(strOrgCd1, strOrgCd2, lngCtrPtCd)
    Select Case Ret
        Case 0
        Case 1
            strMessage = "この契約情報は他団体から参照されています。削除できません。"
            Exit Do
        Case 2
            strMessage = "この契約情報を参照している受診情報が存在します。削除できません。"
            Exit Do
        Case Else
            Exit Do
    End Select

    'エラーがなければ契約コース一覧へ戻る
    strURL = "ctrCourseList.asp"
    strURL = strURL & "?orgCd1=" & strOrgCd1
    strURL = strURL & "&orgCd2=" & strOrgCd2
    Response.Redirect strURL
    Response.End

    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 年齢起算日情報の編集
'
' 引数　　 : (In)     strAgeCalc  年齢起算日
'
' 戻り値　 : 年齢起算日に対する名称
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function AgeCalcName(strAgeCalc)

    '年齢起算日による制御
    Select Case Len(strAgeCalc)
        Case 8
            AgeCalcName = "<B>" & CLng(Left(strAgeCalc, 4)) & "年" & CLng(Mid(strAgeCalc, 5, 2)) & "月" & CLng(Right(strAgeCalc, 2)) & "日</B>"
        Case 4
            AgeCalcName = "<B>" & CLng(Left(strAgeCalc, 2)) & "月" & CLng(Right(strAgeCalc, 2)) & "日</B>"
        Case Else
            AgeCalcName = "<FONT COLOR=""#666666"">（受診日時点の年齢で起算）</FONT>"
    End Select

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 予約方法の編集
'
' 引数　　 : (In)     strCslMethod  予約方法
'
' 戻り値　 : 予約方法に対する名称
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CslMethodName(strCslMethod)

'## 2004.01.19 Mod By T.Takagi@FSIT 内容が全く異なる
'   '年齢起算日による制御
'   Select Case strCslMethod
'       Case "0"
'           CslMethodName = "個人からの電話"
'       Case "1"
'           CslMethodName = "個人（利用券）"
'       Case "2"
'           CslMethodName = "団体からの電話"
'       Case Else
'           CslMethodName = ""
'   End Select
    Select Case strCslMethod
        Case "1"
            CslMethodName = "本人TEL(全部)"
        Case "2"
            CslMethodName = "本人TEL(FAX有り)"
        Case "3"
            CslMethodName = "本人E-MAIL"
        Case "4"
            CslMethodName = "担当者TEL(全部)"
        Case "5"
            CslMethodName = "担当者仮枠(FAX)"
        Case "6"
            CslMethodName = "担当者リスト"
        Case "7"
            CslMethodName = "担当者E-MAIL"
        '## 2009.04.20 張 予約方法項目追加「8：担当者仮枠(郵送)」
        Case "8"
            CslMethodName = "担当者仮枠(郵送)"
        Case Else
            CslMethodName = ""
    End Select
'## 2004.01.19 Mod End

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 :追加条件から名称への変換
'
' 引数　　 : (In)     strAddCondition  追加条件
'
' 戻り値　 : 追加条件に対する名称
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function AddConditionName(strAddCondition)

    'コードから名称への変換
    Select Case strAddCondition
        Case "1"
            AddConditionName = "任意"
        Case Else
            AddConditionName = "&nbsp;"
    End Select

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 性別から名称への変換
'
' 引数　　 : (In)     strGender  性別
'
' 戻り値　 : 性別に対する名称
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function GenderName(strGender)

    'コードから名称への変換
    Select Case strGender
        Case CStr(GENDER_MALE)
            GenderName = "男性"
        Case CStr(GENDER_FEMALE)
            GenderName = "女性"
        Case Else
            GenderName = "&nbsp;"
    End Select

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 受診年齢条件の取得および編集
'
' 引数　　 : (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     strOptCd        オプションコード
' 　　　　   (In)     lngOptBranchNo  オプション枝番
'
' 戻り値　 : 編集後の受診年齢条件
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function AgeName(lngCtrPtCd, strOptCd, lngOptBranchNo)

    Dim strBuffer   '文字列編集バッファ

    Dim strStrAge   '受診対象開始年齢
    Dim strEndAge   '受診対象終了年齢
    Dim lngCount    'レコード数
    Dim i           'インデックス

    '契約パターンオプション年齢条件を読み込む
    lngCount = objContract.SelectCtrPtOptAge(lngCtrPtCd, strOptCd, lngOptBranchNo, strStrAge, strEndAge)
    If lngCount <= 0 Then
        AgeName = "&nbsp;"
        Exit Function
    End If

    '全年齢指定を検索した場合は何も表示させない
    If lngCount = 1 Then
        If Int(strStrAge(0)) = 0 And Int(strEndAge(0)) = 999 Then
            Exit Function
        End If
    End If

    '最大３条件の編集
    i = 0
    Do Until i >= 3

        '配列を最後まで検索した場合は終了
        If i >= lngCount Then
            Exit Do
        End If

        Do
            '受診対象開始・終了年齢値が等しい場合
            If Int(strStrAge(i)) = Int(strEndAge(i)) Then
                strBuffer = strBuffer & IIf(strBuffer <> "", "、", "") & Int(strStrAge(i)) & "歳"
                Exit Do
            End If

            '受診対象開始年齢が最小値の場合
            If Int(strStrAge(i)) = CInt(AGE_MINVALUE) Then
                strBuffer = strBuffer & IIf(strBuffer <> "", "、", "") & Int(strEndAge(i)) & "歳以下"
                Exit Do
            End If

            '受診対象終了年齢が最小値の場合
            If Int(strEndAge(i)) = CInt(AGE_MAXVALUE) Then
                strBuffer = strBuffer & IIf(strBuffer <> "", "、", "") & Int(strStrAge(i)) & "歳以上"
                Exit Do
            End If

            '上記以外
            strBuffer = strBuffer & IIf(strBuffer <> "", "、", "") & Int(strStrAge(i)) & "～" & Int(strEndAge(i)) & "歳"

            Exit Do
        Loop

        i = i + 1
    Loop

    '配列を最後まで検索していない場合は、最後尾に「他」と追加
    If i < lngCount Then
        strBuffer = strBuffer & "他"
    End If

    AgeName = strBuffer

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>契約情報の参照・登録</TITLE>
<!-- #include virtual = "/webHains/includes/noteGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var style = 'status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no';

var winStandard;    // 基本情報ウィンドウオブジェクト
var winLimit;       // 限度額設定ウィンドウオブジェクト
var winPeriod;      // 契約期間指定ウィンドウオブジェクト
var winSplit;       // 契約期間分割ウィンドウオブジェクト
var winDemand;      // 負担元・負担金額設定ウィンドウオブジェクト
var winOption;      // オプション検査登録ウィンドウオブジェクト
var winOther;       // 契約外受診項目負担元指定ウィンドウオブジェクト

// 限度額設定画面を表示
function showStandardWindow() {

    var opened = false; // 画面が開かれているか
    var url;            // 基本情報画面のURL

    var dialogWidth = 780, dialogHeight = 400;
    var dialogTop, dialogLeft;

    // すでにガイドが開かれているかチェック
    if ( winStandard != null ) {
        if ( !winStandard.closed ) {
            opened = true;
        }
    }

    // 基本情報画面のURL編集
    url = 'ctrStandard.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>&ctrPtCd=<%= lngCtrPtCd %>';

    // 画面を中央に表示するための計算
    dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
    dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

    // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winStandard.focus();
    } else {
        winStandard = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',' + style);
    }

}

// 限度額設定画面を表示
function showLimitWindow() {

    var opened = false; // 画面が開かれているか
    var url;            // 限度額設定画面のURL

    var dialogWidth = 650, dialogHeight = 300;
    var dialogTop, dialogLeft;

    // すでにガイドが開かれているかチェック
    if ( winLimit != null ) {
        if ( !winLimit.closed ) {
            opened = true;
        }
    }

    // 限度額設定画面のURL編集
    url = 'ctrLimitPrice.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>&ctrPtCd=<%= lngCtrPtCd %>';

    // 画面を中央に表示するための計算
    dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
    dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

    // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winLimit.focus();
    } else {
        winLimit = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',' + style);
    }

}

// 負担元・負担金額設定画面を表示
function showDemandWindow() {

    var opened = false; // 画面が開かれているか
    var url;            // 負担元・負担金額設定画面のURL

    var dialogWidth = 800, dialogHeight = 650;
    var dialogTop, dialogLeft;

    // すでにガイドが開かれているかチェック
    if ( winDemand != null ) {
        if ( !winDemand.closed ) {
            opened = true;
        }
    }

    // 負担元・負担金額設定画面のURL編集
    url = 'ctrDemand.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>&ctrPtCd=<%= lngCtrPtCd %>';

    // 画面を中央に表示するための計算
    dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
    dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

    // 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
    if ( opened ) {
        winDemand.focus();
    } else {
        winDemand = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',' + style);
    }

}

// 契約期間指定画面を表示
function showPeriodWindow() {

    var opened = false; // 画面が開かれているか
    var url;            // 契約期間指定画面のURL

    var dialogWidth = 800, dialogHeight = 650;
    var dialogTop, dialogLeft;

    // すでにガイドが開かれているかチェック
    if ( winPeriod != null ) {
        if ( !winPeriod.closed ) {
            opened = true;
        }
    }

    // 契約期間指定画面のURL編集
    url = 'ctrPeriod.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>&csCd=<%= strCsCd %>&ctrPtCd=<%= lngCtrPtCd %>';

    // 画面を中央に表示するための計算
    dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
    dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

    // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
    if ( opened ) {
        winPeriod.focus();
        winPeriod.location.replace( url );
    } else {
        winPeriod = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',' + style);
    }

}

// 契約期間分割画面を表示
function showSplitWindow() {

    var opened = false; // 画面が開かれているか
    var url;            // 契約期間分割画面のURL

    var dialogWidth = 600, dialogHeight = 400;
    var dialogTop, dialogLeft;

    // すでにガイドが開かれているかチェック
    if ( winSplit != null ) {
        if ( !winSplit.closed ) {
            opened = true;
        }
    }

    // 契約期間指定画面のURL編集
    url = 'ctrSplitPeriod.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>&ctrPtCd=<%= lngCtrPtCd %>';

    // 画面を中央に表示するための計算
    dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
    dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

    // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
    if ( opened ) {
        winSplit.focus();
        winSplit.location.replace( url );
    } else {
        winSplit = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',' + style);
    }

}

// 検査セット登録画面を表示
function showSetWindow( optCd, optBranchNo ) {

    var opened = false; // 画面が開かれているか
    var url;            // 検査セット登録画面のURL

    var dialogWidth = 950, dialogHeight = 688;
    var dialogTop, dialogLeft;

    // すでにガイドが開かれているかチェック
    if ( winOption != null ) {
        if ( !winOption.closed ) {
            opened = true;
        }
    }

    // 検査セット登録画面のURL編集
    url = 'ctrSet.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>&ctrPtCd=<%= lngCtrPtCd %>';
    if ( optCd ) {
        url = url + '&mode='        + '<%= MODE_UPDATE %>';
        url = url + '&optCd='       + optCd;
        url = url + '&optBranchNo=' + optBranchNo;
    } else {
        url = url + '&mode='        + '<%= MODE_INSERT %>';
    }

    // 画面を中央に表示するための計算
    dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
    dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

    // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
    if ( opened ) {
        winOption.focus();
        winOption.location.replace( url );
    } else {
        winOption = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',' + style );
    }

}

// 契約外受診項目負担元指定画面を表示
function showOtherWindow() {

    var opened = false; // 画面が開かれているか
    var url;            // 契約外受診項目負担元指定画面のURL

    var dialogWidth = 800, dialogHeight = 650;
    var dialogTop, dialogLeft;

    // すでにガイドが開かれているかチェック
    if ( winOther != null ) {
        if ( !winOther.closed ) {
            opened = true;
        }
    }

    // 契約外受診項目負担元指定画面のURL編集
    url = 'ctrOther.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>&ctrPtCd=<%= lngCtrPtCd %>';

    // 画面を中央に表示するための計算
    dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
    dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

    // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
    if ( opened ) {
        winOther.focus();
        winOther.location.replace( url );
    } else {
        winOther = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',' + style );
    }

}

// サブ画面を閉じる
function closeWindow() {

    // 基本情報画面を閉じる
    if ( winStandard != null ) {
        if ( !winStandard.closed ) {
            winStandard.close();
        }
    }

    // 限度額設定画面を閉じる
    if ( winLimit != null ) {
        if ( !winLimit.closed ) {
            winLimit.close();
        }
    }

    // 契約期間指定画面を閉じる
    if ( winPeriod != null ) {
        if ( !winPeriod.closed ) {
            winPeriod.close();
        }
    }

    // 契約期間分割画面を閉じる
    if ( winSplit != null ) {
        if ( !winSplit.closed ) {
            winSplit.close();
        }
    }

    // 負担元・負担金額設定画面を表示
    if ( winDemand != null ) {
        if ( !winDemand.closed ) {
            winDemand.close();
        }
    }

    // オプション検査登録画面を表示
    if ( winOption != null ) {
        if ( !winOption.closed ) {
            winOption.close();
        }
    }

    // 契約外受診項目負担元指定画面を閉じる
    if ( winOther != null ) {
        if ( !winOther.closed ) {
            winOther.close();
        }
    }

    winStandard = null;
    winLimit    = null;
    winPeriod   = null;
    winSplit    = null;
    winDemand   = null;
    winOption   = null;
    winOther    = null;
}
//-->
</SCRIPT>
<style type="text/css">
<!--
    td.mnttab { background-color:#FFFFFF }
-->
</style>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeWindow()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
    <BLOCKQUOTE>

    <INPUT TYPE="hidden" NAME="orgCd1"  VALUE="<%= strOrgCd1  %>">
    <INPUT TYPE="hidden" NAME="orgCd2"  VALUE="<%= strOrgCd2  %>">
    <INPUT TYPE="hidden" NAME="csCd"    VALUE="<%= strCsCd    %>">
    <INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= lngCtrPtCd %>">

    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="85%">
        <TR>
            <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="contract">■</SPAN><FONT COLOR="#000000">契約情報の参照・登録</FONT></B></TD>
        </TR>
    </TABLE>
<%
    'エラーメッセージの編集
    Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="85%">
        <TR>
            <TD HEIGHT="6"></TD>
        </TR>
        <TR>
            <TD ROWSPAN="3" VALIGN="top">
<%
                '団体情報の編集
                Call EditOrgHeader(strOrgCd1, strOrgCd2)
%>
            </TD>
        </TR>
    </TABLE>

    <BR>

    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="85%">
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">現在の契約情報</FONT></B></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" WIDTH="85%">
        <TR><TD HEIGHT="2"></TD></TR>
<%
        '契約パターン情報読み込み

'### 2016.08.04 張 限度額設定有無によってボタン色変更 STR ########################################################################################################

'        If Not objContract.SelectCtrPt(lngCtrPtCd, strStrDate, strEndDate, strAgeCalc, , strCtrCsName, , strCslMethod) Then
'            Err.Raise 1000, ,"契約情報が存在しません。"
'        End If

        If Not objContract.SelectCtrPt(lngCtrPtCd, strStrDate, strEndDate, strAgeCalc, , strCtrCsName, , strCslMethod, strLimitRate, lngLimitTaxFlg, strLimitPrice) Then
            Err.Raise 1000, ,"契約情報が存在しません。"
        End If

        If CLng(strLimitRate) > 0 or CLng(strLimitPrice) then
            strLimitButton = "ctr_limit_blue.gif"
        Else
            strLimitButton = "ctr_limit.gif"
        End If
'### 2016.08.04 張 限度額設定有無によってボタン色変更 STR ########################################################################################################

        'コース情報読み込み
        objCourse.SelectCourse strCsCd, strCsName, , , , , strWebColor
%>
        <TR>
            <TD NOWRAP>受診コース</TD>
            <TD>：</TD>
            <TD WIDTH="100%">
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
                    <TR>
                        <TD NOWRAP><FONT COLOR="#<%= strWebColor %>">■</FONT><B><%= strCsName %></B>&nbsp;&nbsp;<FONT COLOR="#999999">（<%= strCtrCsName %>）</FONT></TD>
<%
                        '削除処理用URLの編集
                        strURL = Request.ServerVariables("SCRIPT_NAME")
                        strURL = strURL & "?actMode=" & ACTMODE_DELETE
                        strURL = strURL & "&orgCd1="  & strOrgCd1
                        strURL = strURL & "&orgCd2="  & strOrgCd2
                        strURL = strURL & "&csCd="    & strCsCd
                        strURL = strURL & "&ctrPtCd=" & lngCtrPtCd

                        '削除用アンカーを編集
%>
                        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                            <TD ALIGN="right"><A HREF="<%= strURL %>" ONCLICK="javascript:return confirm('この契約情報を削除します。よろしいですか？')"><IMG SRC="/webHains/images/delete.gif" BORDER="0" HEIGHT="24" WIDTH="77" ALT="この契約情報を削除します"></A></TD>
                         <%  end if  %>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD>契約期間</TD>
            <TD>：</TD>
            <TD NOWRAP>
                <B><%= objCommon.FormatString(strStrDate, "yyyy年m月d日") %>～<%= objCommon.FormatString(strEndDate, "yyyy年m月d日") %></B><IMG SRC="/webHains/images.spacer.gif" WIDTH="15" HEIGHT="1" ALT="">
                パターンNo.：<B><%= lngCtrPtCd %></B><IMG SRC="/webHains/images.spacer.gif" WIDTH="15" HEIGHT="1" ALT="">
                年齢起算日：<%= AgeCalcName(strAgeCalc) %>
            </TD>
        </TR>
        <TR><TD HEIGHT="2"></TD></TR>
        <TR>
            <TD>予約方法</TD>
            <TD>：</TD>
            <TD><B><%= CslMethodName(strCslMethod) %></B></TD>
        </TR>
    </TABLE>

    <TABLE WIDTH="85%" BORDER="0" CELLSPACING="5" CELLPADDING="1">
        <TR>
            <TD><A HREF="javascript:showStandardWindow()"><IMG SRC="/webHains/images/ctr_basic.gif" HEIGHT="24" WIDTH="110" ALT="基本情報を編集します"></A></TD>
<%'### 2016.08.04 張 限度額設定有無によってボタン色変更 STR ########################################################################################################%>
            <!--TD><A HREF="javascript:showLimitWindow()"><IMG SRC="/webHains/images/ctr_limit.gif" HEIGHT="24" WIDTH="110" ALT="限度額を設定します"></A></TD-->
            <TD><A HREF="javascript:showLimitWindow()"><IMG SRC="/webHains/images/<%=strLimitButton%>" HEIGHT="24" WIDTH="110" ALT="限度額を設定します"></A></TD>
<%'### 2016.08.04 張 限度額設定有無によってボタン色変更 END ########################################################################################################%>
            <TD WIDTH="110"><A HREF="javascript:showDemandWindow()"><IMG SRC="/webHains/images/burden.gif" BORDER="0" HEIGHT="24" WIDTH="110" ALT="負担元情報を編集します"></A></TD>
            <TD WIDTH="110"><A HREF="javascript:showPeriodWindow()"><IMG SRC="/webHains/images/changectr.gif" BORDER="0" HEIGHT="24" WIDTH="110" ALT="契約期間を変更します"></A></TD>
            <TD WIDTH="110"><A HREF="javascript:showSplitWindow()"><IMG SRC="/webHains/images/splitctr.gif" BORDER="0" HEIGHT="24" WIDTH="110" ALT="契約期間を分割します"></A></TD>
<!--
            <TD WIDTH="110"><A HREF="javascript:showOtherWindow()"><IMG SRC="/webHains/images/noctr.gif" BORDER="0" HEIGHT="24" WIDTH="110" ALT="契約外項目の負担方法を設定します"></A></TD>
-->
            <TD WIDTH="110"><A HREF="javascript:noteGuide_showGuideNote('4', '0,0,0,1', '', '', '<%= strOrgCd1 %>', '<%= strOrgCd2 %>','<%= lngCtrPtCd %>')"><IMG SRC="/webHains/images/ctr_comment.gif" HEIGHT="24" WIDTH="110" ALT="コメントを登録します"></A></TD>
            <TD WIDTH="100%" ALIGN="RIGHT"><A HREF="ctrCourseList.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>"><IMG SRC="/webHains/images/gotoctrlist.gif" BORDER="0" HEIGHT="24" WIDTH="110" ALT="契約コース一覧へ戻ります"></A></TD>
        </TR>
    </TABLE>

    <TABLE WIDTH="85%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">検査セットの一覧</FONT></B></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="85%">
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP>管理コース：</TD>
                        <TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_SUB, "subCsCd", strSubCsCd, SELECTED_ALL, False) %></TD>
                        <TD NOWRAP>セット分類：</TD>
                        <TD><%= EditSetClassList("setClassCd", strSetClassCd, SELECTED_ALL) %></TD>
                        <TD NOWRAP>受診区分：</TD>
<%
                        '汎用テーブルから受診区分を読み込む
                        Set objFree = Server.CreateObject("HainsFree.Free")
                        objFree.SelectFree 1, "CSLDIV", strFreeCd, , , strFreeField1
%>
                        <TD><%= EditDropDownListFromArray("cslDivCd", strFreeCd, strFreeField1, strCslDivCd, SELECTED_ALL) %></TD>
                    </TR>
                </TABLE>
            </TD>
            <TD ROWSPAN="2" VALIGN="bottom"><INPUT TYPE="image" NAME="display" SRC="/webHains/images/b_prev.gif" BORDER="0" HEIGHT="28" WIDTH="53" ALT="表示"></TD>

            <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                <TD ROWSPAN="2" ALIGN="right" VALIGN="top" WIDTH="100%"><A HREF="JavaScript:showSetWindow()"><IMG SRC="/webHains/images/newrsv.gif" BORDER="0" HEIGHT="24" WIDTH="77" ALT="新しい検査セットを作成します"></A></TD>
            <%  end if  %>

        </TR>
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP>性別：</TD>
                        <TD>
                            <SELECT NAME="gender">
                                <OPTION VALUE="<%= GENDER_BOTH   %>" <%= IIf(lngGender = GENDER_BOTH,   "SELECTED", "") %>>男女共通
                                <OPTION VALUE="<%= GENDER_MALE   %>" <%= IIf(lngGender = GENDER_MALE,   "SELECTED", "") %>>男性のみ
                                <OPTION VALUE="<%= GENDER_FEMALE %>" <%= IIf(lngGender = GENDER_FEMALE, "SELECTED", "") %>>女性のみ
                            </SELECT>
                        </TD>
                        <TD NOWRAP>年齢：</TD>
                        <TD><%= EditSelectNumberList("strAge", 1, 150, CLng("0" & strStrAge)) %></TD>
                        <TD>～</TD>
                        <TD><%= EditSelectNumberList("endAge", 1, 150, CLng("0" & strEndAge)) %></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

    <BR>
<%
    Do
        'オプション検査情報読み込み
'       lngOptCount = objContract.SelectCtrPtPriceOptAll(lngCtrPtCd, strSubCsCd, strSetClassCd, strCslDivCd, lngGender, strStrAge, strEndAge, strOptCd, strOptBranchNo, strArrWebColor, strArrSubCsName, strOptName, strSetColor, strAgeName, strAddCondition, strCslDivName, strGender, strSetClassName, strSeq, strPrice, strOrgDiv)

        '2005/10/21 消費税追加。Add by 李
        lngOptCount = objContract.SelectCtrPtPriceOptAll(lngCtrPtCd, strSubCsCd, strSetClassCd, strCslDivCd, lngGender, strStrAge, strEndAge, strOptCd, strOptBranchNo, strArrWebColor, strArrSubCsName, strOptName, strSetColor, strAgeName, strAddCondition, strCslDivName, strGender, strSetClassName, strSeq, strPrice, strOrgDiv, strTax)
        '2005/10/21 Add End.

        If lngOptCount <= 0 Then
%>
            検索条件を満たす検査セットは存在しません。
<%
            Exit Do
        End If
%>
        <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
            <TR ALIGN="center" BGCOLOR="#cccccc">
                <TD ROWSPAN="2" COLSPAN="3" NOWRAP>検査セット名</TD>
                <TD ROWSPAN="2" NOWRAP>限度額<BR>対象外</TD>
                <TD COLSPAN="4" NOWRAP>受診条件</TD>
<%
                '自団体略称の読み込み
                objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , , , strMyOrgSName

                '負担元読み込み
                lngCount = objContract.SelectCtrPtOrgPrice(lngCtrPtCd, , , , strApDiv, , , , strOrgSName)

                For i = 0 To lngCount - 1
%>
                    <!--<TD ROWSPAN="2" NOWRAP WIDTH="65"><%= IIf(strApDiv(i) = CStr(APDIV_MYORG), strMyOrgSName, strOrgSName(i)) %></TD>-->
                    <TD COLSPAN="2" NOWRAP><%= IIf(strApDiv(i) = CStr(APDIV_MYORG), strMyOrgSName, strOrgSName(i)) %></TD>
<%
                Next
%>
<%'### 2016.08.04 張 セット別合計金額表示の為修正 STR #######################################################%>
                    <TD COLSPAN="2" NOWRAP BGCOLOR="#C6DBF7">合計額</TD>
<%'### 2016.08.04 張 セット別合計金額表示の為修正 END #######################################################%>
            </TR>

            <TR ALIGN="center" BGCOLOR="#cccccc">
                <TD NOWRAP>受診対象</TD>
                <TD NOWRAP>区分</TD>
                <TD NOWRAP>性別</TD>
                <TD NOWRAP>年齢</TD>
<%
                For i = 0 To lngCount - 1
%>
                    <TD NOWRAP>負担金額</TD>
                    <TD NOWRAP>消費税</TD>
<%
                Next
%>
<%'### 2016.08.04 張 セット別合計金額表示の為修正 STR #######################################################%>
                <TD NOWRAP BGCOLOR="#C6DBF7">負担金額</TD>
                <TD NOWRAP BGCOLOR="#C6DBF7">消費税</TD>
<%'### 2016.08.04 張 セット別合計金額表示の為修正 END #######################################################%>

            </TR>
<%
            'オプション検査の編集
            For i = 0 To lngOptCount - 1


'### 2016.08.04 張 限度額設定対象外チェック追加 STR #######################################################
                If Not objContract.SelectCtrPtOpt(lngCtrPtCd, strOptCd(i), Clng(strOptBranchNo(i)),,,,,,,,,strExceptLimit) Then
                    Err.Raise 1000, ,"契約情報が存在しません。"
                End If
'### 2016.08.04 張 限度額設定対象外チェック追加 END #######################################################

%>
                <TR BGCOLOR="#eeeeee">
                    <TD ALIGN="right" NOWRAP><%= strOptCd(i) %></TD>
                    <TD NOWRAP>-<%= strOptBranchNo(i) %></TD>
                    <TD NOWRAP><FONT COLOR="#<%= strSetColor(i) %>">■</FONT><A HREF="javascript:showSetWindow('<%= strOptCd(i) %>','<%= strOptBranchNo(i) %>')"><%= strOptName(i) %></A></TD>
<%'### 2016.08.04 張 限度額設定対象外チェック追加 STR #######################################################%>
                    <TD ALIGN="center" NOWRAP>
<%              If strExceptLimit = "1" Then    %>
                        <IMG SRC="/webHains/images/check.gif" WIDTH="20" HEIGHT="20" ALT="限度額設定の対象としない">
<%              End If  %>
                    </TD>
<%'### 2016.08.04 張 限度額設定対象外チェック追加 END #######################################################%>
                    <TD ALIGN="center" NOWRAP><%= AddConditionName(strAddCondition(i)) %></TD>
                    <TD NOWRAP><%= strCslDivName(i) %></TD>
                    <TD ALIGN="center" NOWRAP><%= GenderName(strGender(i)) %></TD>
                    <TD NOWRAP><%= strAgeName(i) %></TD>
<%
'### 2016.08.04 張 セット別合計金額表示の為修正 STR #######################################################
                    lngTotPrice = 0
                    lngTotTax   = 0
'### 2016.08.04 張 セット別合計金額表示の為修正 END #######################################################
                    For j = 0 To UBound(strPrice, 1)
%>
                        <TD ALIGN="right" NOWRAP><%= FormatCurrency(strPrice(j, i)) %></TD>
                        <TD ALIGN="right" NOWRAP><%= FormatCurrency(strTax(j, i)) %></TD>
<%
'### 2016.08.04 張 セット別合計金額表示の為修正 STR #######################################################
                        lngTotPrice = lngTotPrice + CLng(strPrice(j, i))
                        lngTotTax   = lngTotTax + CLng(strTax(j, i))
'### 2016.08.04 張 セット別合計金額表示の為修正 END #######################################################
                    Next
%>
<%'### 2016.08.04 張 セット別合計金額表示の為修正 STR #######################################################%>
                    <TD ALIGN="right" NOWRAP BGCOLOR="#EFF3FF"><%= FormatCurrency(CStr(lngTotPrice)) %></TD>
                    <TD ALIGN="right" NOWRAP BGCOLOR="#EFF3FF"><%= FormatCurrency(CStr(lngTotTax)) %></TD>
<%'### 2016.08.04 張 セット別合計金額表示の為修正 END #######################################################%>

                </TR>
<%
            Next
%>
        </TABLE>
<%
        Exit Do
    Loop
%>
    </BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>