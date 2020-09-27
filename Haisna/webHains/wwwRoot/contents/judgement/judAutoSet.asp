<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       自動判定 (Ver0.0.1)
'       AUTHER  : Tsutomu Takagi@fsit.fujitsu.com 
'                 スクリーニング画面から改造（K.Fujii)
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objJudgement        '判定用
Dim objNutritionCalc    '栄養計算クラス

'自身をリダイレクトする場合のみ送信されるパラメータ値
Dim strAction       '実行モード

Dim lngCslYear      '受診年
Dim lngCslMonth     '受診月
Dim lngCslDay       '受診日
Dim strCslDate      '受診年月日

Dim strCsCd         'コースコード
Dim strJudClassCd   '判定分類コード
Dim lngEntryCheck   '未入力チェック(0:しない、1:する)
Dim lngReJudge      '再判定(0:しない、1:する)

Dim strtodayId      '当日ＩＤ指定方法

Dim lngStartId      '当日ＩＤ（範囲指定：開始）
Dim lngEndId        '当日ＩＤ（範囲指定：終了）
Dim strPluralId     '当日ＩＤ（複数指定）

Dim strAutoJud      '自動判定チェック
Dim strEiyokeisan   '栄養計算チェック
Dim strActPattern   'Ａ型行動パターンチェック
Dim strPointLost    '失点判定チェック
Dim strStress       'ストレス計算チェック
'## 2012.09.11 Add by T.Takagi@RD 食習慣の自動判定
Dim strShokushukan  '食習慣チェック
'## 2012.09.11 Add End

'### 2006.04.26 張 現病歴関連コメント登録ロジックから婦人科関連コメントを別途管理するために追加
Dim strGyneComment  '現病歴による婦人科コメント登録チェック

'### 2008.03.04 張 特定健診（階層化）判定ロジック追加
Dim strSpecialLevel '特定健診基準値に基づいて階層化判定

Dim vntCalcFlg()    '計算対象フラグ
Dim vntArrDayId     '当日ＩＤ（複数指定の場合の計算処理への引数）
Dim strUpdUser      '更新者
Dim strIPAddress    'IPアドレス

Dim Ret             '関数復帰値
Dim strArrMessage   'エラーメッセージの配列
Dim strMessage      'エラーメッセージ
Dim blnError        'エラーフラグ
Dim lngCount        '判定実施件数
Dim i               'カウンタ

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon    = Server.CreateObject("HainsCommon.Common")
Set objJudgement = Server.CreateObject("HainsJudgement.JudgementControl")

'自身をリダイレクトする場合のみ送信されるパラメータ値の取得
strAction       = Request("action")

lngCslYear      = CLng("0" & Request("cslYear"))
lngCslMonth     = CLng("0" & Request("cslMonth"))
lngCslDay       = CLng("0" & Request("cslDay"))
strCsCd         = Request("csCd")
strJudClassCd   = Request("judClassCd")

strAutoJud      = Request("checkAutoJud")
strEiyokeisan   = Request("checkEiyo")
strActPattern   = Request("checkActPattern")
strPointLost    = Request("checkPointLost")
strStress       = Request("checkStress")

'### 2006.04.26 張 現病歴関連コメント登録ロジックから婦人科関連コメントを別途管理するために追加
strGyneComment  = Request("checkGyneComment")
'### 2008.03.04 張 特定健診（階層化）自動判定ロジック追加
strSpecialLevel = Request("checkSpecialLevel")

'## 2012.09.11 Add by T.Takagi@RD 食習慣の自動判定
strShokushukan = Request("checkShokushukan")
'## 2012.09.11 Add End

lngStartId      = Request("startId")
lngEndId        = Request("endId")
strPluralId     = Request("pluralId")

strtodayId      = Request("chktodayId")
strtodayId      = IIf( strtodayId = "", 1, strtodayId )

lngEntryCheck   = Request("valEntryCheck")
lngReJudge      = Request("valReJudge")

lngEntryCheck   = IIf( lngEntryCheck = "", 1, lngEntryCheck )
lngReJudge      = IIf( lngReJudge = "", 0, lngReJudge )

'受診年月日が渡されていない場合、システム年月日を適用する
lngCslYear      = IIf(lngCslYear  = 0, Year(Now),  lngCslYear)
lngCslMonth     = IIf(lngCslMonth = 0, Month(Now), lngCslMonth)
lngCslDay       = IIf(lngCslDay   = 0, Day(Now),   lngCslDay)

'チェック・更新・読み込み処理の制御
Do

    '自動判定実施要求？
    If strAction = "auto" Then
        blnError = False

        '受診日チェック
        Do

            '必須チェック
            If lngCslYear = 0 And lngCslMonth = 0 And lngCslDay = 0 Then
                objCommon.AppendArray strArrMessage, "受診日を入力して下さい。"
                blnError = True
                Exit Do
            End If

            '受診年月日の編集
            strCslDate = lngCslYear & "/" & lngCslMonth & "/" & lngCslDay

            '受診年月日の日付チェック
            If Not IsDate(strCslDate) Then
                objCommon.AppendArray strArrMessage, "受診日の入力形式が正しくありません。"
                blnError = True
                Exit Do
            End If

            '複数指定時当日IDの編集
            If strtodayId = 2 Then
                vntArrDayId = split( strPluralId, "," )
            Else
                vntArrDayId = Array()
                Redim Preserve vntArrDayId(0)
            End If
            '当日IDのチェック
            If strtodayId = 1 Then
                strMessage = objCommon.CheckNumeric("当日ID", lngStartId, LENGTH_RECEIPT_DAYID, CHECK_NECESSARY)
                If strMessage <> "" Then
                    objCommon.AppendArray strArrMessage, strMessage
                    blnError = True
                    Exit Do
                End If

                strMessage = objCommon.CheckNumeric("当日ID", lngEndId, LENGTH_RECEIPT_DAYID, CHECK_NECESSARY)
                If strMessage <> "" Then
                    objCommon.AppendArray strArrMessage, strMessage
                    blnError = True
                    Exit Do
                End If
            Else
                For i=0 To UBound(vntArrDayId)
                strMessage = objCommon.CheckNumeric("当日ID", vntArrDayId(i), LENGTH_RECEIPT_DAYID, CHECK_NECESSARY)
                    If strMessage <> "" Then
                        objCommon.AppendArray strArrMessage, strMessage
                        blnError = True
                        Exit Do
                    End If
                Next
            End If

            Exit Do
        Loop


        'エラー存在時は処理を終了する
        If Not IsEmpty(strArrMessage) Then
            Exit Do
        End If

        '### 2008.03.04 張 特定健診（階層化）自動判定ロジック追加によって修正
        'Redim Preserve vntCalcFlg(5)
'## 2012.09.11 Update by T.Takagi@RD 食習慣の自動判定
        'Redim Preserve vntCalcFlg(6)
        Redim Preserve vntCalcFlg(7)
'## 2012.09.11 Update End
        If strActPattern = "1" Then
            vntCalcFlg(0) = 1
        Else
            vntCalcFlg(0) = 0
        End If
        If strPointLost = "1" Then
            vntCalcFlg(1) = 1
        Else
            vntCalcFlg(1) = 0
        End If
        If strEiyokeisan = "1" Then
            vntCalcFlg(2) = 1
        Else
            vntCalcFlg(2) = 0
        End If
        If strStress = "1" Then
            vntCalcFlg(3) = 1
        Else
            vntCalcFlg(3) = 0
        End If
        If strAutoJud = "1" Then
            vntCalcFlg(4) = 1
        Else
            vntCalcFlg(4) = 0
        End If

'### 2006.04.26 張 現病歴関連コメント登録ロジックから婦人科関連コメントを別途管理するために追加 Start
        If strGyneComment = "1" Then
            vntCalcFlg(5) = 1
        Else
            vntCalcFlg(5) = 0
        End If
'### 2006.04.26 張 現病歴関連コメント登録ロジックから婦人科関連コメントを別途管理するために追加 End

'### 2008.03.04 張 特定健診（階層化）自動判定ロジック追加 Start
        If strSpecialLevel = "1" Then
            vntCalcFlg(6) = 1
        Else
            vntCalcFlg(6) = 0
        End If
'### 2008.03.04 張 特定健診（階層化）自動判定ロジック追加 End

'## 2012.09.11 Add by T.Takagi@RD 食習慣の自動判定
        If strShokushukan = "1" Then
            vntCalcFlg(7) = 1
        Else
            vntCalcFlg(7) = 0
        End If
'## 2012.09.11 Add End

        '自動判定が選択されているときは「Ａ型行動パターン、失点判定、ストレス点数」 もあわせて計算する
        If vntCalcFlg(4) = 1 Then
            vntCalcFlg(0) = 1
            vntCalcFlg(1) = 1
            vntCalcFlg(3) = 1
        End If

        strUpdUser        = Session.Contents("userId")
        strIPAddress      = Request.ServerVariables("REMOTE_ADDR")

'        response.write "strUpdUser = " & strUpdUser & vbcrlf
'        response.write "strIPAddress = " & strIPAddress & vbcrlf
'        response.write "strCslDate = " & strCslDate & vbcrlf
'        response.write "strtodayId = " & strtodayId & vbcrlf
'        response.write lngStartId
'        response.write lngEndId
'        response.write "strCsCd = " & strCsCd & vbcrlf
'        response.write "strJudClassCd = " & strJudClassCd & vbcrlf
'        response.write "lngEntryCheck = " = lngEntryCheck & vbcrlf
'        response.write "lngReJudge = " = lngReJudge & vbcrlf
'        response.end

        '判定メイン呼び出し
        Ret = objJudgement.JudgeAutomaticallyMain (strUpdUser, _
                                                strIPAddress, _
                                                strCslDate, _
                                                vntCalcFlg, _
                                                strtodayId, _
                                                lngStartId, _
                                                lngEndId, _
                                                vntArrDayId, _
                                                "" & strCsCd, _
                                                "" & strJudClassCd, _
                                                lngEntryCheck, _
                                                lngReJudge)
'''     Ret = objJudgement.JudgeAutomatically (strCslDate, "" & strCsCd, "" & strJudClassCd, "" & strPerId, lngEntryCheck, lngReJudge)

        If Ret = True Then
            strAction = "autoend"
        Else
            objCommon.AppendArray strArrMessage, "自動判定が異常終了しました。（詳細は？）"
        End If

    End If


    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 判定分類一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName                エレメント名
' 　　　　   (In)     strSelectedJudClassCd  リストにて選択すべき判定分類コード
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 依頼項目判定グループに存在する判定分類コードのみ、判定分類コード順
'
'-------------------------------------------------------------------------------
Function EditJudClassList(strName, strSelectedJudClassCd)

    Dim objJudClass         '依頼項目判定分類情報アクセス用

    Dim strJudClassCd       '判定分類コード
    Dim strJudClassName     '判定分類名称
    Dim strAllJudFlg        '統計用総合判定フラグ
    Dim strCommentOnly      'コメント表示モード

    Dim strJudClassCd2()    '判定分類コード
    Dim strJudClassName2()  '判定分類名称

    Dim i, j                'インデックス

    'オブジェクトのインスタンス作成
    Set objJudClass = Server.CreateObject("HainsJudClass.JudClass")

    '判定分類情報の読み込み
    If objJudClass.SelectJudClassList(strJudClassCd, strJudClassName, strAllJudFlg,,, strCommentOnly) <= 0 Then
        Exit Function
    End If

    '総合判定用の判定分類以外を抽出
    'コメント表示のみも対象外
    j = 0
    For i = 0 To UBound(strJudClassCd)
        If strAllJudFlg(i) = "0"  And strCommentOnly(i) <> "1" Then
            ReDim Preserve strJudClassCd2(j)
            ReDim Preserve strJudClassName2(j)
            strJudClassCd2(j)   = strJudClassCd(i)
            strJudClassName2(j) = strJudClassName(i)
            j = j + 1
        End If
    Next

    '総合判定用の判定分類以外が存在しなければ何もしない
    If j = 0 Then
        Exit Function
    End If

    'ドロップダウンリストの編集
    EditJudClassList = EditDropDownListFromArray(strName, strJudClassCd2, strJudClassName2, strSelectedJudClassCd, SELECTED_ALL)

End Function

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<TITLE>自動判定</TITLE>
<SCRIPT TYPE="text/javascript">
<!--

//当日ＩＤチェック
function checktodayIdAct(index) {

    with ( document.entryForm ) {
        if (index == 0 ){
            todayId.value = (todayId[index].checked ? '1' : '');
        } else if (index == 1 ){
            todayId.value = (todayId[index].checked ? '2' : '');
        }
        chktodayId.value = todayId.value;
    }

}

//自動判定チェック
function checkAutoJudAct() {

    with ( document.entryForm ) {
        checkAutoJud.value = (checkAutoJud.checked ? '1' : '');
    }

}
//栄養計算チェック
function checkEiyoAct() {

    with ( document.entryForm ) {
        checkEiyo.value = (checkEiyo.checked ? '1' : '');
    }

}
//Ａ型行動パターンチェック
function checkActPatternAct() {

    with ( document.entryForm ) {
        checkActPattern.value = (checkActPattern.checked ? '1' : '');
    }

}
//失点判定チェック
function checkLostPointAct() {

    with ( document.entryForm ) {
        checkPointLost.value = (checkPointLost.checked ? '1' : '');
    }

}
//ストレス点数チェック
function checkStressAct() {

    with ( document.entryForm ) {
        checkStress.value = (checkStress.checked ? '1' : '');
    }

}

/** 2006.04.26 張 現病歴関連コメント登録ロジックから婦人科関連コメントを別途管理するために追加 Start **/
//婦人科コメントチェック
function checkGyneCommentAct() {
    with ( document.entryForm ) {
        checkGyneComment.value = (checkGyneComment.checked ? '1' : '');
    }
}
/** 2006.04.26 張 現病歴関連コメント登録ロジックから婦人科関連コメントを別途管理するために追加 End   **/

/** 2008.03.04 張 特定健診（階層化）自動判定ロジック追加 Start **/
//特定健診チェック
function checkSpecialLevelAct() {
    with ( document.entryForm ) {
        checkSpecialLevel.value = (checkSpecialLevel.checked ? '1' : '');
    }
}
/** 2008.03.04 張 特定健診（階層化）自動判定ロジック追加 End   **/
<% '## 2012.09.11 Add by T.Takagi@RD 食習慣の自動判定 %>
// 食習慣チェック
function checkShokushukanAct() {

    with ( document.entryForm ) {
        checkShokushukan.value = (checkShokushukan.checked ? '1' : '');
    }

}
<% '## 2012.09.11 Add End %>
// 自動判定実行
function autoJudExe() {

    var myForm;

    myForm = document.entryForm;

    if ( myForm.todayId[0].checked ){
        if ( myForm.startId.value == '' ||
             myForm.endId.value == '' ){
            alert( "当日ＩＤが指定されていません。");
            return;
        }
    }else if ( myForm.todayId[1].checked ){
        if ( myForm.pluralId.value == '' ){
            alert( "当日ＩＤが指定されていません。");
            return;
        }
    }

/** 2006.04.26 張 現病歴関連コメント登録ロジックから婦人科関連コメントを別途管理するために変更 Start **/
    /*
    if (myForm.checkAutoJud.value == '' &&
        myForm.checkEiyo.value == '' &&
        myForm.checkActPattern.value == '' &&
        myForm.checkPointLost.value == '' &&
        myForm.checkStress.value == '' ){
        alert( "計算対象が指定されていません。" );
        return;
    }
    */
    /** 2008.03.04 張 特定健診（階層化）自動判定ロジック追加 Start **/
    /*
    if (myForm.checkAutoJud.value == '' &&
        myForm.checkEiyo.value == '' &&
        myForm.checkActPattern.value == '' &&
        myForm.checkPointLost.value == '' &&
        myForm.checkStress.value == '' &&
        myForm.checkGyneComment.value == '' ){
        alert( "計算対象が指定されていません。" );
        return;
    }
    */
	/* ## 2012.09.11 Update by T.Takagi@RD 食習慣の自動判定 */
	/*
    if (myForm.checkAutoJud.value == '' &&
        myForm.checkEiyo.value == '' &&
        myForm.checkActPattern.value == '' &&
        myForm.checkPointLost.value == '' &&
        myForm.checkStress.value == '' &&
        myForm.checkGyneComment.value == '' &&
        myForm.checkSpecialLevel.value == '' ){
        alert( "計算対象が指定されていません。" );
        return;
    }
	*/
    if (myForm.checkAutoJud.value == '' &&
        myForm.checkShokushukan.value == '' &&
        myForm.checkEiyo.value == '' &&
        myForm.checkActPattern.value == '' &&
        myForm.checkPointLost.value == '' &&
        myForm.checkStress.value == '' &&
        myForm.checkGyneComment.value == '' &&
        myForm.checkSpecialLevel.value == '' ){
        alert( "計算対象が指定されていません。" );
        return;
    }
	/* ## 2012.09.11 Update End */
    /** 2008.03.04 張 特定健診（階層化）自動判定ロジック追加 End   **/
/** 2006.04.26 張 現病歴関連コメント登録ロジックから婦人科関連コメントを別途管理するために変更 End   **/

    // 自動判定のとき
    if (myForm.checkAutoJud.value != '' ) {
        if ( myForm.entryCheck[0].checked ){
            if( !confirm( '結果が揃っていない状態で自動判定を行います。よろしいですか？' )) {
                return;
            }
            myForm.valEntryCheck.value = 0;
        } else {
            myForm.valEntryCheck.value = 1;
        }

        if ( myForm.reJudge[1].checked ){
            if ( !confirm( '既に判定、及びコメントがセットされている場合、その内容を破棄して再自動判定を行ないます。よろしいですか？' )) {
                return;
            }
            myForm.valReJudge.value = 1;
        } else {
            myForm.valReJudge.value = 0;
        }
    }

    myForm.action.value = 'auto';
    myForm.submit();

}

function closeWindow() {

    calGuide_closeGuideCalendar();

}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<STYLE TYPE="text/css">
td.judtab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get" >
    <INPUT TYPE="hidden" NAME="action" VALUE="<%= strAction %>">
    <BLOCKQUOTE>
    
    <!-- 表題 -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="judgement">■</SPAN><FONT COLOR="#000000">自動判定</FONT></B></TD>
        </TR>
    </TABLE>
<%
    'メッセージの編集
    If strAction <> "" Then

        Select Case strAction

            '保存完了時は「正常終了」の通知
            Case "autoend"
                Call EditMessage("自動判定が正常終了しました。", MESSAGETYPE_NORMAL)

            'さもなくばエラーメッセージを編集
            Case Else
                Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

        End Select

    End If
%>
    <BR>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD><FONT COLOR="#ff0000">■</FONT></TD>
            <TD WIDTH="100" NOWRAP>受診日</TD>
            <TD>：</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear', 'cslMonth', 'cslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
                        <TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
                        <TD>年</TD>
                        <TD><%= EditNumberList("cslMonth", 1, 12, lngCslMonth, False) %></TD>
                        <TD>月</TD>
                        <TD><%= EditNumberList("cslDay", 1, 31, lngCslDay, False) %></TD>
                        <TD>日</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD>□</TD>
            <TD WIDTH="100" NOWRAP>コース</TD>
            <TD>：</TD>
            <TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, "すべてのコース", False) %></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <INPUT TYPE="hidden" NAME="chktodayId" VALUE="<%= strtodayId %>" >
        <TR>
            <TD>□</TD>
            <TD WIDTH="100" NOWRAP>当日ID</TD>
            <TD>：</TD>
            <TD NOWRAP><INPUT TYPE="radio" NAME="todayId" VALUE="<%= strtodayId %>" <%= IIf(strtodayId = "1", " CHECKED", "") %> ONCLICK="javascript:checktodayIdAct(0)" BORDER="0">範囲指定<INPUT TYPE="text" NAME="startId" VALUE="<%= lngStartId %>" SIZE="6" BORDER="0" STYLE="ime-mode:disabled;">～<INPUT TYPE="text" NAME="endId" VALUE="<%= lngEndId %>" SIZE="6" BORDER="0" STYLE="ime-mode:disabled;"></SPAN></TD>
        </TR>
        <TR>
            <TD></TD>
            <TD WIDTH="100" NOWRAP></TD>
            <TD></TD>
            <TD NOWRAP><INPUT TYPE="radio" NAME="todayId" VALUE="<%= strtodayId %>" <%= IIf(strtodayId = "2", " CHECKED", "") %> ONCLICK="javascript:checktodayIdAct(1)"  BORDER="0">複数指定<INPUT TYPE="text" NAME="pluralId" VALUE="<%= strPluralId %>" SIZE="35" BORDER="0" STYLE="ime-mode:disabled;"></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD>□</TD>
            <TD WIDTH="100" NOWRAP>計算対象</TD>
            <TD>：</TD>
            <TD><INPUT type="checkbox" name="checkAutoJud" value="<%= strAutoJud %>" <%= IIf(strAutoJud <> "", " CHECKED", "") %> ONCLICK="javascript:checkAutoJudAct()" border="0">自動判定</TD>
<% '## 2012.09.11 Add by T.Takagi@RD 食習慣の自動判定 %>
            <TD><INPUT type="checkbox" name="checkShokushukan" value="<%= strShokushukan %>" <%= IIf(strShokushukan <> "", " CHECKED", "") %> ONCLICK="javascript:checkShokushukanAct()" border="0">食習慣</TD>
<% '## 2012.09.11 Add End %>
            <TD><INPUT type="checkbox" name="checkEiyo" value="<%= strEiyokeisan %>" <%= IIf(strEiyokeisan <> "", " CHECKED", "") %> ONCLICK="javascript:checkEiyoAct()" border="0">栄養計算</TD>
            <TD><INPUT type="checkbox" name="checkActPattern" value="<%= strActPattern %>" <%= IIf(strActPattern <> "", " CHECKED", "") %> ONCLICK="javascript:checkActPatternAct()" border="0">Ａ型行動パターン</TD>
            <TD><INPUT type="checkbox" name="checkPointLost" value="<%= strPointLost %>" <%= IIf(strPointLost <> "", " CHECKED", "") %> ONCLICK="javascript:checkLostPointAct()" border="0">失点判定</td>
            <TD><INPUT type="checkbox" name="checkStress" value="<%= strStress %>" <%= IIf(strStress <> "", " CHECKED", "") %> ONCLICK="javascript:checkStressAct()" border="0">ストレス点数</td>
            <!--## 2006.04.26 張 現病歴関連コメント登録ロジックから婦人科関連コメントを別途管理するために追加 Start ##-->
            <TD><INPUT type="checkbox" name="checkGyneComment" value="<%= strGyneComment %>" <%= IIf(strGyneComment <> "", " CHECKED", "") %> ONCLICK="javascript:checkGyneCommentAct()" border="0">婦人科コメント</td>
            <!--## 2006.04.26 張 現病歴関連コメント登録ロジックから婦人科関連コメントを別途管理するために追加 End   ##-->

            <!--## 2008.03.04 張 特定健診（階層化）自動判定ロジック追加 Start ##-->
            <TD><INPUT type="checkbox" name="checkSpecialLevel" value="<%= strSpecialLevel %>" <%= IIf(strSpecialLevel <> "", " CHECKED", "") %> ONCLICK="javascript:checkSpecialLevelAct()" border="0">特定健診</td>
            <!--## 2008.03.04 張 張 特定健診（階層化）自動判定ロジック追加 End   ##-->
        </TR>
    </TABLE>
    
    <BR>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TD>以下は自動判定のみに適用</TD>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD>□</TD>
            <TD WIDTH="100" NOWRAP>判定分類</TD>
            <TD>：</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD><%= EditJudClassList("judClassCd", strJudClassCd) %></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <INPUT TYPE="hidden" NAME="valEntryCheck" VALUE="<%= lngEntryCheck %>">
            <TD><FONT COLOR="#ff0000">■</FONT></TD>
            <TD WIDTH="100" NOWRAP>未入力チェック</TD>
            <TD>：</TD>
            <TD><INPUT TYPE="radio" NAME="entryCheck" VALUE="0" <%= IIf(lngEntryCheck = 0, "CHECKED", "") %>></TD>
            <TD>しない</TD>
            <TD><INPUT TYPE="radio" NAME="entryCheck" VALUE="1" <%= IIf(lngEntryCheck = 1, "CHECKED", "") %>></TD>
            <TD>する</TD>
        </TR>
        <TR>
            <INPUT TYPE="hidden" NAME="valReJudge" VALUE="<%= lngReJudge %>">
            <TD><FONT COLOR="#ff0000">■</FONT></TD>
            <TD>再判定</TD>
            <TD>：</TD>
            <TD><INPUT TYPE="radio" NAME="reJudge" VALUE="0" <%= IIf(lngReJudge = 0, "CHECKED", "") %>></TD>
            <TD>しない</TD>
            <TD><INPUT TYPE="radio" NAME="reJudge" VALUE="1" <%= IIf(lngReJudge = 1, "CHECKED", "") %>></TD>
            <TD>する</TD>
        </TR>
    </TABLE>

    <BR>

    <A HREF="judMenu.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>
    <% '2005.08.22 権限管理 Add by 李　--- START %>
    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
    <A HREF="javascript:autoJudExe()"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="自動判定を実行"></A>
    <%  else    %>
         &nbsp;
    <%  end if  %>
    <% '2005.08.22 権限管理 Add by 李　--- END %>
    <BR><BR>

<!--
    <A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGSCREENING"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="ログを参照する"></A>
-->

    </BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
