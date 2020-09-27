<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      内視鏡チェックリスト入力  (Ver0.0.1)
'      AUTHER  : K.Kagawa@FFCS
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
Const GRPCD_NAISHIKYOU  = "X024"                '内視鏡チェックリスト入力グループコード

'### 2016.06.03 張 使用していない項目削除の為、追加 STR ####################################
Const GRPCD_NAISHIKYOU_NEW  = "X0241"           '内視鏡チェックリスト入力グループコード
Const CHANGE_CSLDATE        = "2016/06/13"      '内視鏡チェックリスト入力画面切替受診日
'### 2016.06.03 張 使用していない項目削除の為、追加 END ####################################

'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objInterView        '面接情報アクセス用
Dim objResult           '検査結果アクセス用COMオブジェクト
'### 2004/01/23 Start K.Kagawa 内視鏡チェックリストの保存確認を追加
Dim objRslOcr           'OCR入力結果アクセス用
'### 2004/01/23 End

'### 2016.01.27 張 個人情報追加の為、修正 STR ##############################################
Dim objConsult              '受診クラス
Dim objFree                 '汎用情報アクセス用
'### 2016.01.27 張 個人情報追加の為、修正 END ##############################################


'パラメータ
Dim strWinMode          'ウィンドウモード
Dim lngRsvNo            '予約番号（今回分）
Dim strGrpNo            'グループNo
Dim strCsCd             'コースコード
Dim strAction           '処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")

'### 2016.06.03 張 使用していない項目削除の為、追加 STR ####################################
Dim strRslGrpCd         '内視鏡チェックリスト入力グループコード設定
'### 2016.06.03 張 使用していない項目削除の為、追加 END ####################################


'検査結果情報
Dim vntPerId            '個人ID
Dim vntCslDate          '検査項目コード
Dim vntHisNo            '履歴No.
Dim vntRsvNo            '予約番号
Dim vntItemCd           '検査項目コード
Dim vntSuffix           'サフィックス
Dim vntResultType       '結果タイプ
Dim vntItemType         '項目タイプ
Dim vntItemName         '検査項目名称
Dim vntResult           '検査結果
Dim vntRslValue         '検査結果
Dim vntUnit             '単位
Dim vntItemQName        '問診文章
Dim vntGrpSeq           '表示順番
Dim vntRslFlg           '検査結果存在フラグ
Dim lngRslCnt           '検査結果数

'検査結果更新情報
Dim vntUpdItemCd        '検査項目コード
Dim vntUpdSuffix        'サフィックス
Dim vntUpdResult        '検査結果
Dim strArrMessage       'エラーメッセージ

Dim strMessage          'エラーメッセージ

Dim strUpdUser          '更新者
Dim strIPAddress        'IPアドレス

Dim lngIndex            'インデックス
Dim Ret                 '復帰値
Dim Ret2                '復帰値
Dim strHTML             'HTML文字列
Dim i, j                'カウンター

'### 2004/01/23 Start K.Kagawa 内視鏡チェックリストの保存確認を追加
Dim vntGFCheckList      '内視鏡チェックリストの状態
'### 2004/01/23 End


'### 2016.01.27 張 個人情報追加の為、修正 STR ##############################################

Dim strPerId                '個人ID
Dim strCslDate              '受診日
Dim strCsName               'コース名
Dim strLastName             '姓
Dim strFirstName            '名
Dim strLastKName            'カナ姓
Dim strFirstKName           'カナ名
Dim strBirth                '生年月日
Dim strAge                  '年齢
Dim strGender               '性別
Dim strGenderName           '性別名称
Dim strDayId                '当日ID
Dim strOrgName              '団体名称

Dim strEraBirth             '生年月日(和暦)
Dim strRealAge              '実年齢

Dim lngConsCount            '受診回数
Dim lngCnt

'### 2016.01.27 張 個人情報追加の為、修正 END ##############################################


'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objInterView    = Server.CreateObject("HainsInterView.InterView")

'### 2016.01.28 張 個人情報追加の為、修正 STR ##############################################
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
'### 2016.01.28 張 個人情報追加の為、修正 END ##############################################

'引数値の取得
strWinMode          = Request("winmode")
strGrpNo            = Request("grpno")
lngRsvNo            = Request("rsvno")
strCsCd             = Request("cscd")
strAction           = Request("act")

'検査結果更新情報
vntUpdItemCd        = ConvIStringToArray(Request("ItemCd"))
vntUpdSuffix        = ConvIStringToArray(Request("Suffix"))
vntUpdResult        = ConvIStringToArray(Request("ChgRsl"))

Do
    '保存
    If strAction = "save" Then
        If Not IsEmpty(vntUpdItemCd) Then
            '更新者の設定
            strUpdUser = Session("USERID")
            'IPアドレスの取得
            strIPAddress = Request.ServerVariables("REMOTE_ADDR")

            'オブジェクトのインスタンス作成
            Set objResult  = Server.CreateObject("HainsResult.Result")

            '検査結果更新
            Ret = objResult.UpdateResultNoCmt( lngRsvNo, strIPAddress, strUpdUser, vntUpdItemCd, vntUpdSuffix, vntUpdResult, strArrMessage )

            'オブジェクトのインスタンス削除
            Set objResult = Nothing

            If Ret Then
                '保存完了
                strAction = "saveend"

                '### 2016.12.16 張 内視鏡チェックリスト登録後は必ず誘導経路変更を行うように仕様追加 STR ###
                'オブジェクトのインスタンス作成
                Set objResult  = Server.CreateObject("HainsResult.Result")
                '検査結果更新
                Ret2 = objResult.UpdateYudo( lngRsvNo, strUpdUser, strMessage )
                'オブジェクトのインスタンス削除
                Set objResult = Nothing
                '### 2016.12.16 張 内視鏡チェックリスト登録後は必ず誘導経路変更を行うように仕様追加 END ###

'### 2004/01/23 Start K.Kagawa 内視鏡チェックリストの保存確認を追加
                '内視鏡チェックリストの状態取得
                Set objRslOcr = Server.CreateObject("HainsRslOcr.OcrNyuryoku")
                Ret = objRslOcr.CheckGF( lngRsvNo, vntGFCheckList )
                Set objRslOcr = Nothing
                If Ret < 0 Then
                    Err.Raise 1000, , "内視鏡チェックリストの状態が取得できません。（予約番号 = " & lngRsvNo & ")"
                End If
'### 2004/01/23 End
            End If
        End If
    End If

'### 2016.01.27 張 個人情報追加の為、修正 STR ##############################################
    Ret = objConsult.SelectConsult(lngRsvNo, _
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

    '### 受診情報が存在しない場合はエラーとする ###
    If Ret = False Then
        Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
    End If

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

    Set objConsult = Nothing

'### 2016.01.27 張 個人情報追加の為、修正 END ##############################################

    '指定対象受診者の検査結果を取得する

''### 2016.06.03 張 使用していない項目削除の為、追加 STR ####################################
''    lngRslCnt = objInterView.SelectHistoryRslList( _
''                        lngRsvNo, _
''                        1, _
''                        GRPCD_NAISHIKYOU, _
''                        0, _
''                        "", _
''                        0, _
''                        0, _
''                        1, _
''                        vntPerId, _
''                        vntCslDate, _
''                        vntHisNo, _
''                        vntRsvNo, _
''                        vntItemCd, _
''                        vntSuffix, _
''                        vntResultType, _
''                        vntItemType, _
''                        vntItemName, _
''                        vntResult, _
''                        vntRslValue, _
''                        , , , , , _
''                        vntUnit, _
''                        , , , , , _
''                        vntItemQName, _
''                        vntGrpSeq, _
''                        vntRslFlg _
''                        )

    If CDate(strCslDate) >= CDate(CHANGE_CSLDATE) Then
        strRslGrpCd = GRPCD_NAISHIKYOU_NEW
    Else
        strRslGrpCd = GRPCD_NAISHIKYOU
    End If

''    lngRslCnt = objInterView.SelectHistoryRslList( _
''                        lngRsvNo, _
''                        1, _
''                        strRslGrpCd, _
''                        0, _
''                        "", _
''                        0, _
''                        0, _
''                        1, _
''                        vntPerId, _
''                        vntCslDate, _
''                        vntHisNo, _
''                        vntRsvNo, _
''                        vntItemCd, _
''                        vntSuffix, _
''                        vntResultType, _
''                        vntItemType, _
''                        vntItemName, _
''                        vntResult, _
''                        vntRslValue, _
''                        , , , , , _
''                        vntUnit, _
''                        , , , , , _
''                        vntItemQName, _
''                        vntGrpSeq, _
''                        vntRslFlg _
''                        )

    lngRslCnt = objInterView.SelectHistoryRslList( _
                        lngRsvNo, _
                        1, _
                        strRslGrpCd, _
                        1, _
                        strCsCd, _
                        0, _
                        0, _
                        1, _
                        vntPerId, _
                        vntCslDate, _
                        vntHisNo, _
                        vntRsvNo, _
                        vntItemCd, _
                        vntSuffix, _
                        vntResultType, _
                        vntItemType, _
                        vntItemName, _
                        vntResult, _
                        vntRslValue, _
                        , , , , , _
                        vntUnit, _
                        , , , , , _
                        vntItemQName, _
                        vntGrpSeq, _
                        vntRslFlg _
                        )

''### 2016.06.03 張 使用していない項目削除の為、追加 END ####################################

    If lngRslCnt < 0 Then
        Err.Raise 1000, , "検査結果が取得できません。（予約番号 = " & lngRsvNo & ")"
    End If


    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 検査結果のタグ生成
'
' 引数　　 : (In)     vntIndex          先頭インデックス
' 　　　　   (In)     vntType           INPUTの属性(TYPE)
' 　　　　   (In)     vntName           INPUTの属性(NAME)
' 　　　　   (In)     vntSize           INPUTの属性(SIZE)
' 　　　　   (In)     vntOnValue        INPUTの属性(VALUE) ※ラジオボタンのみ使用
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditRsl(vntIndex, vntType, vntName, vntSize, vntOnValue)
    Dim strFuncName

    EditRsl = ""
    strFuncName = "javascript:document.entryForm.ChgRsl[" & vntIndex & "].value = this.value"

    Select Case vntType
    Case "text"         'テキスト
        EditRsl = "<INPUT TYPE=""text"" NAME=""" & vntName & """ SIZE=""" & vntSize & """  MAXLENGTH=""8"" STYLE=""text-align:right"" VALUE=""" & vntRslValue(vntIndex) & """"
        EditRsl = EditRsl & " ONCHANGE=""" & strFuncName & """>"

    Case "checkbox"     'チェックボックス
        EditRsl = "<INPUT TYPE=""checkbox"" NAME=""" & vntName & """ VALUE=""" & vntOnValue & """" & IIf(vntRslValue(lngIndex)=vntOnValue, " CHECKED", "")
        EditRsl = EditRsl & " ONCLICK=""javascript:clickRsl( this, " & vntIndex & ")"">"

    Case "radio"        'ラジオボタン
        EditRsl = "<INPUT TYPE=""radio"" NAME=""" & vntName & """ VALUE=""" & vntOnValue & """" & IIf(vntRslValue(lngIndex)=vntOnValue, " CHECKED", "")
        EditRsl = EditRsl & " ONCLICK=""javascript:clickRsl( this, " & vntIndex & ")"">"

    End Select

End Function
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>内視鏡チェックリスト入力</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// 検査結果の選択時処理
function clickRsl( Obj, Index ) {

    // エレメントタイプごとの処理分岐
    switch ( Obj.type ) {
        case 'checkbox':    // チェックボックス
            if( Obj.checked ) {
                document.entryForm.ChgRsl[Index].value = Obj.value
            } else {
                document.entryForm.ChgRsl[Index].value = '';
            }
            break;

        case 'radio':       // ラジオボタン
            // 選択済みをもう一度クリックすると選択解除
            if( document.entryForm.ChgRsl[Index].value == Obj.value ) {
                Obj.checked = false;
                document.entryForm.ChgRsl[Index].value = '';
            } else {
                Obj.checked = true;
                document.entryForm.ChgRsl[Index].value = Obj.value
            }
            break;

        default:
            break;
    }

}

//保存
function saveNaishikyou() {

    // モードを指定してsubmit
    document.entryForm.act.value = 'save';
    document.entryForm.submit();

    return;
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
    body { margin: 15px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <!-- 引数値 -->
    <INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
    <INPUT TYPE="hidden" NAME="grpno"   VALUE="<%= strGrpNo %>">
    <INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
    <INPUT TYPE="hidden" NAME="act"     VALUE="<%= strAction %>">

    <INPUT TYPE="hidden" NAME="before_url"     VALUE="<%= Request.ServerVariables("HTTP_REFERER") %>">

    
<!-- ### 2004/01/23 Start K.Kagawa 内視鏡チェックリストの保存確認を追加 -->
<INPUT TYPE="hidden" NAME="GFCheckList"   VALUE="<%= vntGFCheckList %>">
<!-- ### 2004/01/23 End -->

    <!-- タイトルの表示 -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="">■内視鏡チェックリスト入力</SPAN></B></TD>
        </TR>
    </TABLE>
    <BR>
<%
    'メッセージの編集
    If strAction <> "" Then

        '保存完了時は「保存完了」の通知
        If strAction = "saveend" Then
            Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

        'さもなくばエラーメッセージを編集
        Else
            Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
        End If

    End If
%>

<%
    '### 2016.02.01 張 誘導画面からの呼出し以外は受診者個人情報表示 STR #######################
    If InStr(Request.ServerVariables("HTTP_REFERER"), ".jsp") = 0  Then
%>
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
    <BR>
<%
    End If
    '### 2016.02.01 張 誘導画面からの呼出し以外は受診者個人情報表示 END #######################
%>



    <!-- 内視鏡チェックリストの表示 -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
<%
    strHTML = ""
lngIndex = 0
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">車を運転してきましたか？</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_1", , "0") & "<FONT COLOR=""gray"">はい</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_1", , "1") & "<FONT COLOR=""gray"">いいえ</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 1
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">生検組織検査</TD>" & vbLf
'	strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_2", , "0") & "<FONT COLOR=""gray"">必要時希望する</FONT></TD>" & vbLf
'	strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_2", , "1") & "<FONT COLOR=""gray"">希望しない</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_2", , "0") & "<FONT COLOR=""gray"">必要時同意する</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_2", , "1") & "<FONT COLOR=""gray"">同意しない</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 2
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">上部消化管内視鏡検査の経験</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_3", , "0") & "<FONT COLOR=""gray"">あり</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_3", , "1") & "<FONT COLOR=""gray"">なし</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 3
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">鎮静剤の希望</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_4", , "0") & "<FONT COLOR=""gray"">あり</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_4", , "1") & "<FONT COLOR=""gray"">なし</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_4", , "2") & "<FONT COLOR=""gray"">医師と相談</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 4
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">キシロカインアレルギー</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_5", , "0") & "<FONT COLOR=""gray"">あり</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_5", , "1") & "<FONT COLOR=""gray"">なし</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
'### 2006/09/25 張 薬物アレルギー検査項目削除及び追加による変更 Start ###
'lngIndex = 5
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">薬物アレルギー</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_6", , "0") & "<FONT COLOR=""gray"">あり</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_6", , "1") & "<FONT COLOR=""gray"">なし</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'lngIndex = 6
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">抗凝固剤の使用</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_7", , "0") & "<FONT COLOR=""gray"">あり</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_7", , "1") & "<FONT COLOR=""gray"">なし</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_7", , "2") & "<FONT COLOR=""gray"">休薬中</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'### 2006/10/19 張 鎮静剤アレルギー検査項目削除（Dr.熊倉からの依頼） Start ###
'lngIndex = 5
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">鎮静剤アレルギー</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_6", , "0") & "<FONT COLOR=""gray"">あり</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_6", , "1") & "<FONT COLOR=""gray"">なし</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 5
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">ヨードアレルギー</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_6", , "0") & "<FONT COLOR=""gray"">あり</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_6", , "1") & "<FONT COLOR=""gray"">なし</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 6
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">薬物アレルギー</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_7", , "0") & "<FONT COLOR=""gray"">あり</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_7", , "1") & "<FONT COLOR=""gray"">なし</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

lngIndex = 7

'### 2016.06.03 張 使用していない項目削除の為、修正 STR ####################################
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">抗凝固剤の使用</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_8", , "0") & "<FONT COLOR=""gray"">あり</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_8", , "1") & "<FONT COLOR=""gray"">なし</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_8", , "2") & "<FONT COLOR=""gray"">休薬中</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
    If CDate(strCslDate) >= CDate(CHANGE_CSLDATE) Then
        strHTML = strHTML & "<TR>" & vbLf
        strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">抗凝固剤の使用</TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_8", , "0") & "<FONT COLOR=""gray"">あり</FONT></TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_8", , "1") & "<FONT COLOR=""gray"">なし</FONT></TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Else
        strHTML = strHTML & "<TR>" & vbLf
        strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">抗凝固剤の使用</TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_8", , "0") & "<FONT COLOR=""gray"">あり</FONT></TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_8", , "1") & "<FONT COLOR=""gray"">なし</FONT></TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_8", , "2") & "<FONT COLOR=""gray"">休薬中</FONT></TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    End If
'### 2016.06.03 張 使用していない項目削除の為、修正 END ####################################

'### 2006/09/25 張 薬物アレルギー検査項目削除及び追加による変更 End   ###

    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""1"" HEIGHT=""21"" BORDER=""0""></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf


'### 2006/09/25 張 抗凝固剤薬品表示順番変更のため修正 Start ###
'lngIndex = 7
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">アンプラーグ</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_1", , "1") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'lngIndex = 8
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">ペルサンチン</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_2", , "2") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'lngIndex = 9
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">プレタール</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_3", , "3") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'lngIndex = 10
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">ワーファリン</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_4", , "4") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'lngIndex = 11
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">バファリン８１</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_5", , "5") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'lngIndex = 12
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">エパデール</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_6", , "6") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'lngIndex = 13
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">パナルジン</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_7", , "7") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'lngIndex = 14
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">ドルナー・プロサイリン</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_8", , "8") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'lngIndex = 15
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">オパルモン</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_9", , "9") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'    Response.Write strHTML

'### 2016.06.03 張 使用していない項目削除の為、修正 STR ####################################
'### 切替日付以前の受診者のみ表示する
If CDate(strCslDate) < CDate(CHANGE_CSLDATE) Then

lngIndex = 8
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">ワーファリン</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_4", , "4") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 9
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">バファリン８１</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_5", , "5") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 10
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">パナルジン</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_7", , "7") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 11
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">プレタール</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_3", , "3") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 12
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">ペルサンチン</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_2", , "2") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 13
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">アンプラーグ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_1", , "1") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 14
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">エパデール</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_6", , "6") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 15
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">ドルナー・プロサイリン</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_8", , "8") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 16
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">オパルモン</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_9", , "9") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
'### 2006/09/25 張 抗凝固剤薬品表示順番変更のため修正 End   ###


'### 2006/09/25 張 抗凝固剤薬品追加による項目追加 Start ###
lngIndex = 17
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">コメリアン</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_10", , "10") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 18
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">ロコナール</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_11", , "11") & "<FONT COLOR=""gray"">服薬中</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
'### 2006/09/25 張 抗凝固剤薬品追加による項目追加 End   ###

End If

    Response.Write strHTML

'### 2016.06.03 張 使用していない項目削除の為、修正 END ####################################

%>
    </TABLE>
    <BR>
    <!--A HREF="JavaScript:saveNaishikyou()"><IMG SRC="../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存" BORDER="0"></A-->
    <% '2005.08.22 権限管理 Add by 李　--- START %>
    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
        <A HREF="JavaScript:saveNaishikyou()"><IMG SRC="../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存" BORDER="0"></A>
    <%  else    %>
         &nbsp;
    <%  end if  %>
    <% '2005.08.22 権限管理 Add by 李　--- END %>
    
    <BR>
<%
    '保存用
    strHtml = ""
    For i=0 To lngRslCnt-1
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""ItemCd"" VALUE=""" & vntItemCd(i) & """>"
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""Suffix"" VALUE=""" & vntSuffix(i) & """>"
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""OrgRsl"" VALUE=""" & vntRslValue(i) & """>"
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""ChgRsl"" VALUE=""" & vntRslValue(i) & """>"
    Next
    Response.Write(strHtml)
%>
</FORM>
<%
'-----保存完了処理----- 
%>
<SCRIPT TYPE="text/javascript">
<!--
//### 2004/01/23 Start K.Kagawa 内視鏡チェックリストの保存確認を追加
    // 保存完了時に内視鏡チェックリストの状態を呼出し元に反映する
    if( document.entryForm.act.value == 'saveend' ) {
        opener.document.entryForm.GFCheckList.value = document.entryForm.GFCheckList.value
    }
//### 2004/01/23 End
//-->
</SCRIPT>
</BODY>
</HTML>
