<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       フォローガイド (Ver0.0.1)
'       AUTHER  :
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objFollow               'フォローアップアクセス用 
Dim objJud                  '判定情報アクセス用

Dim strMode                 '処理モード(挿入:"insert"、更新:"update")
Dim strAction               '処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")
Dim strTarget               'ターゲット先のURL

'パラメータ
Dim lngRsvNo                '予約番号
Dim lngJudClassCd           '判定分類コード
Dim strJudClassName         '判定分類名
Dim strJudCd                '判定コード（フォロー確定時判定結果）
Dim strRslJudCd             '判定コード（カレント（現在）判定結果）
Dim strSecEquipDiv          '二次検査実施（施設）区分

Dim strAddDate              '更新日時
Dim strAddUser              '更新者ID
Dim strAddUserName          '更新者氏名
Dim strUpdDate              '更新日時
Dim strUpdUser              '更新者ID
Dim strUpdUserName          '更新者氏名
Dim strStatusCd             'ステータス
Dim strSecEquipName         '病医院名
Dim strSecEquipCourse       '診療科
Dim strSecDoctor            '担当医師
Dim strSecEquipAddr         '病医院住所
Dim strSecEquipTel          '病医院電話番号
Dim strSecPlanDate          '二次検査予定日
Dim strSecPlanYear          '二次検査予定日（年）
Dim strSecPlanMonth         '二次検査予定日（月）
Dim strSecPlanDay           '二次検査予定日（日）

'二次検査予約項目追加　：2009/12/21 yhlee ---------------
Dim strRsvTestUS               '二次検査項目US
Dim strRsvTestCT               '二次検査項目CT
Dim strRsvTestMRI              '二次検査項目MRI
Dim strRsvTestBF               '二次検査項目BF
Dim strRsvTestGF               '二次検査項目GF
Dim strRsvTestCF               '二次検査項目CF
Dim strRsvTestEM               '二次検査項目注腸
Dim strRsvTestTM               '二次検査項目腫瘍マーカー
Dim strRsvTestETC              '二次検査項目その他
Dim strRsvTestRemark           '二次検査項目その他コメント
Dim strRsvTestRefer            '二次検査項目リファー
Dim strRsvTestReferText        '二次検査項目リファー科
Dim strRsvTestName             '
'二次検査項目追加 (End) --------------------------------

Dim strReqSendDate          '依頼状発送日
Dim strReqSendUser          '依頼状発送者ID
Dim strReqSendUserName      '依頼状発送者氏名
Dim strReqCheckDate1        '第一勧奨日
Dim strReqCheckDate2        '第二勧奨日
Dim strReqCheckDate3        '第三勧奨日（予備）
Dim strReqCancelDate        '勧奨中止日
Dim strReqConfirmDate       '結果承認日
Dim strReqConfirmUser       '結果承認者ID
Dim strReqConfirmUserName   '結果承認者氏名
Dim strReqConfirmFlg        '結果承認処理区分（0：承認取消、1：承認）
Dim strSecRemark            '備考
Dim strSecCslDate           '二次実施日
Dim strSecCslYear           '二次実施日（年）
Dim strSecCslMonth          '二次実施日（月）
Dim strSecCslDay            '二次実施日（日）

Dim vntRsvNo                '予約番号
Dim vntJudClassCd           '検査項目（判定分類）
Dim vntSeq                  '一連番号
Dim vntSecCslDate           '二次実施日
Dim vntTestUS               '二次検査項目US
Dim vntTestCT               '二次検査項目CT
Dim vntTestMRI              '二次検査項目MRI
Dim vntTestBF               '二次検査項目BF
Dim vntTestGF               '二次検査項目GF
Dim vntTestCF               '二次検査項目CF
Dim vntTestEM               '二次検査項目注腸
Dim vntTestTM               '二次検査項目腫瘍マーカー
Dim vntTestETC              '二次検査項目その他
Dim vntTestRemark           '二次検査項目その他コメント
'二次検査項目追加　：2009/12/21 yhlee ---------------
Dim vntTestRefer            '二次検査項目リファー
Dim vntTestReferText        '二次検査項目リファー科
'二次検査項目追加　(End)-----------------------------
Dim vntResultDiv            '二次検査結果区分
Dim vntDisRemark            '二次検査結果その他疾患
Dim vntPolWithout           '処置不要（治療方針）：治療なし
Dim vntPolFollowup          '経過観察：治療なし
Dim vntPolMonth             '経過観察期間（ヶ月）：治療なし
Dim vntPolReExam            '1年後健診：治療なし
Dim vntPolDiagSt            '本院紹介（精査）：治療なし
Dim vntPolDiag              '他院紹介（精査）：治療なし
Dim vntPolEtc1              'その他：治療なし
Dim vntPolRemark1           'その他文章：治療なし
Dim vntPolSugery            '外科治療：治療あり
Dim vntPolEndoscope         '内視鏡的治療：治療あり
Dim vntPolChemical          '化学療法：治療あり
Dim vntPolRadiation         '放射線治療：治療あり
Dim vntPolReferSt           '本院紹介：治療あり
Dim vntPolRefer             '他院紹介：治療あり
Dim vntPolEtc2              'その他：治療あり
Dim vntPolRemark2           'その他文章：治療あり
Dim vntAddDate              '作成日付
Dim vntAddUser              '作成者ID
Dim vntAddUserName          '作成者氏名
Dim vntUpdDate              '更新日付
Dim vntUpdUser              '更新者ID
Dim vntUpdUserName          '更新者氏名

'各二次検査結果情報別診断名取得陽
Dim vntGrpName              '検査項目グループ名称（種別）
Dim vntItemCd               '検査項目コード
Dim vntSuffix               'サフィクス
Dim vntItemName             '検査項目名（臓器或は部位）
Dim vntResult               '疾患コード（文章コード）
Dim vntShortStc             '疾患名（文章名称）

'画面表示制御用検査項目
Dim strBeforeGrpName        '前行のグループ名称
Dim strWebGrpName           'グループ名称画面表示用

Dim lngCount                'レコード件数
Dim lngAllCount             '総件数
Dim lngStcCount             '取得診断名件数

'判定コンボボックス
Dim strArrJudCdSeq          '判定連番
Dim strArrJudCd             '判定コード
Dim strArrWeight            '判定用重み
Dim lngJudListCnt           '判定件数

Dim i                       'インデックス
Dim j                       'インデックス
Dim Ret                     '復帰値
Dim rslCnt                  '結果入力欄インデックス

Dim strArrMessage           'エラーメッセージ

'画面表示制御用
Dim strWebResultDivName     '二次検査結果区分（名称）
Dim strWebTestItem          '二次検査項目
Dim strWebPolicy1           '治療なし方針
Dim strWebPolicy2           '治療あり方針

Dim lngPolCount1            '方針（治療なし）数カウント用
Dim lngPolCount2            '方針（治療あり）数カウント用
Dim lngTestCount            '検査項目数カウント用


'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objFollow       = Server.CreateObject("HainsFollow.Follow")
Set objJud          = Server.CreateObject("HainsJud.Jud")

'パラメータ値の取得
strMode                 = Request("mode")
strAction               = Request("act")
strTarget               = Request("target")

lngRsvNo                = Request("rsvno")
lngJudClassCd           = Request("judClassCd")
strJudClassName         = Request("judClassName")
strJudCd                = Request("judCd")
strRslJudCd             = Request("rslJudCd")
strSecEquipDiv          = Request("secEquipDiv")
strUpdDate              = Request("updDate")
strUpdUser              = Request("updUser")
strUpdUserName          = Request("updUserName")
strStatusCd             = Request("statusCd")
strSecEquipName         = Request("secEquipName")
strSecEquipCourse       = Request("secEquipCourse")
strSecDoctor            = Request("secDoctor")
strSecEquipAddr         = Request("secEquipAddr")
strSecEquipTel          = Request("secEquipTel")
strSecPlanDate          = Request("secPlanDate")
strSecPlanYear          = Request("secPlanYear")
strSecPlanMonth         = Request("secPlanMonth")
strSecPlanDay           = Request("secPlanDay")

'二次検査予約項目追加　：2009/12/21 yhlee ---------------
strRsvTestUS               = Request("rsvTestUS")
strRsvTestCT               = Request("rsvTestCT")
strRsvTestMRI              = Request("rsvTestMRI")
strRsvTestBF               = Request("rsvTestBF")
strRsvTestGF               = Request("rsvTestGF")
strRsvTestCF               = Request("rsvTestCF")
strRsvTestEM               = Request("rsvTestEM")
strRsvTestTM               = Request("rsvTestTM")
strRsvTestETC              = Request("rsvTestETC")
strRsvTestRemark           = Request("rsvTestRemark")
strRsvTestRefer            = Request("rsvTestRefer")
strRsvTestReferText        = Request("rsvTestReferText")
'二次検査項目追加　(End)-----------------------------

strReqSendDate          = Request("reqSendDate")
strReqSendUser          = Request("reqSendUser")
strReqSendUserName      = Request("reqSendUserName")
strReqCheckDate1        = Request("reqCheckDate1")
strReqCheckDate2        = Request("reqCheckDate2")
strReqCheckDate3        = Request("reqCheckDate3")
strReqCancelDate        = Request("reqCancelDate")
strReqConfirmDate       = Request("reqConfirmDate")
strReqConfirmUser       = Request("reqConfirmUser")
strReqConfirmUserName   = Request("ReqConfirmUserName")
strReqConfirmFlg        = Request("ReqConfirmFlg")
strSecRemark            = Request("secRemark")

'判定コードリスト取得
Call EditJudListInfo

'チェック・更新・読み込み処理の制御
Do

    '保存ボタン押下時
    If strAction = "save" Then

        '入力チェック
        strArrMessage = CheckValue()
        If Not IsEmpty(strArrMessage) Then
            Exit Do
        End If

'        response.write "lngRsvNo            --> " & lngRsvNo            & "<br>"
'        response.write "lngJudClassCd       --> " & lngJudClassCd       & "<br>"
'        response.write "strSecEquipDiv      --> " & strSecEquipDiv      & "<br>"
'        response.write "updUser             --> " & Session.Contents("userId")      & "<br>"
'        response.write "strJudCd            --> " & strJudCd            & "<br>"
'        response.write "strStatusCd         --> " & strStatusCd         & "<br>"
'        response.write "strSecEquipName     --> " & strSecEquipName     & "<br>"
'        response.write "strSecDoctor        --> " & strSecDoctor        & "<br>"
'        response.write "strSecEquipAddr     --> " & strSecEquipAddr     & "<br>"
'        response.write "strSecEquipTel      --> " & strSecEquipTel      & "<br>"
'        response.write "strSecPlanDate      --> " & strSecPlanDate      & "<br>"
'        response.write "strSecRemark        --> " & strSecRemark        & "<br>"
'        response.end


        '### フォローアップ情報更新処理
'2009.11.26 張
'        Ret = objFollow.UpdateFollow_Info(lngRsvNo, lngJudClassCd, _
'                                          strSecEquipDiv, Session.Contents("userId"), strJudCd, _
'                                          strStatusCd, strSecEquipName, strSecDoctor, _
'                                          strSecEquipAddr, strSecEquipTel, strSecPlanDate, _
'                                          strSecRemark)

'2009.12.22 yhlee
'        Ret = objFollow.UpdateFollow_Info(lngRsvNo, lngJudClassCd, _
'                                          strSecEquipDiv, Session.Contents("userId"), strJudCd, _
'                                          strStatusCd, strSecEquipName, strSecEquipCourse, strSecDoctor, _
'                                          strSecEquipAddr, strSecEquipTel, strSecPlanDate, _
'                                          strSecRemark)

'2009.12.22 yhlee　：二次検査予約項目追加
        Ret = objFollow.UpdateFollow_Info(lngRsvNo, lngJudClassCd, _
                                          strSecEquipDiv, Session.Contents("userId"), strJudCd, _
                                          strStatusCd, strSecEquipName, strSecEquipCourse, strSecDoctor, _
                                          strSecEquipAddr, strSecEquipTel, strSecPlanDate, _
                                          strRsvTestUS, strRsvTestCT, strRsvTestMRI, _
                                          strRsvTestBF, strRsvTestGF, strRsvTestCF, _
                                          strRsvTestEM, strRsvTestTM, strRsvTestETC, _
                                          strRsvTestRemark, strRsvTestRefer, strRsvTestReferText, _
                                          strSecRemark)
        If Ret Then
            strAction = "saveend"
        Else
            strArrMessage = Array("フォローアップ情報更新に失敗しました。")
            Exit Do
        End If

    ElseIf strAction = "delete" Then

        'フォローアップ情報削除処理
        Ret = objFollow.DeleteFollow_Info( lngRsvNo, lngJudClassCd, Session.Contents("userId"))

        If Ret Then
            strAction = "deleteend"
        Else
            strArrMessage = Array("フォローアップ情報削除に失敗しました。")
            Exit Do
        End If

    ElseIf strAction = "confirm" Then

        '### フォローアップ情報承認（又は承認解除）処理
        Ret = objFollow.UpdateFollow_Info_Confirm(lngRsvNo, lngJudClassCd, strReqConfirmFlg, Session.Contents("userId"))
        If Ret Then
            strAction = "saveend"
        Else
            strArrMessage = Array("フォローアップ情報更新に失敗しました。")
            Exit Do
        End If

    End If

    '### フォローアップ情報取得
'    objFollow.SelectFollow_Info lngRsvNo,           lngJudClassCd, _
'                                strJudClassName,    strJudCd,               strRslJudCd, _
'                                strSecEquipDiv,     strUpdDate,             strUpdUser, _
'                                strUpdUserName,     strStatusCd,            strSecEquipName, _
'                                strSecDoctor,       strSecEquipAddr,        strSecEquipTel, _
'                                strSecPlanDate,     strReqSendDate,         strReqSendUser, _
'                                strReqSendUserName, strReqCheckDate1,       strReqCheckDate2, _
'                                strReqCheckDate3,   strReqCancelDate,       strReqConfirmDate, _
'                                strReqConfirmUser,  strReqConfirmUserName,  strSecRemark

'2009.11.26 張
'    objFollow.SelectFollow_Info lngRsvNo,           lngJudClassCd, _
'                                strJudClassName,    strJudCd,               strRslJudCd, _
'                                strSecEquipDiv,     strUpdDate,             strUpdUser, _
'                                strUpdUserName,     strStatusCd,            strSecEquipName, _
'                                strSecDoctor,       strSecEquipAddr,        strSecEquipTel, _
'                                strSecPlanDate,     strReqSendDate,         strReqSendUser, _
'                                strReqSendUserName, strReqCheckDate1,       strReqCheckDate2, _
'                                strReqCheckDate3,   strReqCancelDate,       strReqConfirmDate, _
'                                strReqConfirmUser,  strReqConfirmUserName,  strSecRemark, _
'                                strAddDate,         strAddUser,             strAddUserName

'2009.12.24 李
'    objFollow.SelectFollow_Info lngRsvNo,           lngJudClassCd, _
'                                strJudClassName,    strJudCd,               strRslJudCd, _
'                                strSecEquipDiv,     strUpdDate,             strUpdUser, _
'                                strUpdUserName,     strStatusCd,            strSecEquipName,      strSecEquipCourse, _
'                                strSecDoctor,       strSecEquipAddr,        strSecEquipTel, _
'                                strSecPlanDate,     strReqSendDate,         strReqSendUser, _
'                                strReqSendUserName, strReqCheckDate1,       strReqCheckDate2, _
'                                strReqCheckDate3,   strReqCancelDate,       strReqConfirmDate, _
'                                strReqConfirmUser,  strReqConfirmUserName,  strSecRemark, _
'                                strAddDate,         strAddUser,             strAddUserName

'2009.12.24 二次検査項目追加 : 李 
    objFollow.SelectFollow_Info lngRsvNo,           lngJudClassCd, _
                                strJudClassName,    strJudCd,               strRslJudCd, _
                                strSecEquipDiv,     strUpdDate,             strUpdUser, _
                                strUpdUserName,     strStatusCd,            strSecEquipName,      strSecEquipCourse, _
                                strSecDoctor,       strSecEquipAddr,        strSecEquipTel, _
                                strSecPlanDate,     strReqSendDate,         strReqSendUser, _
                                strReqSendUserName, strReqCheckDate1,       strReqCheckDate2, _
                                strReqCheckDate3,   strReqCancelDate,       strReqConfirmDate, _
                                strReqConfirmUser,  strReqConfirmUserName,  strSecRemark, _
                                strRsvTestName, _
                                strRsvTestUS,       strRsvTestCT,           strRsvTestMRI, _
                                strRsvTestBF,       strRsvTestGF,           strRsvTestCF, _
                                strRsvTestEM,       strRsvTestTM,           strRsvTestEtc, _
                                strRsvTestRemark,   strRsvTestRefer,        strRsvTestReferText, _ 
                                strAddDate,         strAddUser,             strAddUserName

    If strSecPlanDate <> "" Then
        strSecPlanYear   = Year(strSecPlanDate)
        strSecPlanMonth  = Month(strSecPlanDate)
        strSecPlanDay    = Day(strSecPlanDate)
    End If

    '### フォローアップ結果リスト取得
'2009.11.26 張
'    lngAllCount = objFollow.SelectFollowRslList(lngRsvNo,            lngJudClassCd, _
'                                                vntRsvNo,            vntJudClassCd,      vntSeq, _
'                                                vntSecCslDate,       vntTestUS,          vntTestCT, _
'                                                vntTestMRI,          vntTestBF,          vntTestGF, _
'                                                vntTestCF,           vntTestEM,          vntTestTM, _
'                                                vntTestEtc,          vntTestRemark,      vntResultDiv, _
'                                                vntDisRemark,        vntPolWithout,      vntPolFollowup, _
'                                                vntPolMonth,         vntPolReExam,       vntPolDiagSt,      vntPolDiag, _
'                                                vntPolEtc1,          vntPolRemark1,      vntPolSugery, _
'                                                vntPolEndoscope,     vntPolChemical,     vntPolRadiation, _
'                                                vntPolReferSt,       vntPolRefer,        vntPolEtc2,        vntPolRemark2, _
'                                                vntUpdDate,          vntUpdUser,         vntUpdUserName _
'                                                )

    lngAllCount = objFollow.SelectFollowRslList(lngRsvNo,            lngJudClassCd, _
                                                vntRsvNo,            vntJudClassCd,      vntSeq, _
                                                vntSecCslDate,       vntTestUS,          vntTestCT, _
                                                vntTestMRI,          vntTestBF,          vntTestGF, _
                                                vntTestCF,           vntTestEM,          vntTestTM, _
                                                vntTestRefer,        vntTestReferText, _
                                                vntTestEtc,          vntTestRemark,      vntResultDiv, _
                                                vntDisRemark,        vntPolWithout,      vntPolFollowup, _
                                                vntPolMonth,         vntPolReExam,       vntPolDiagSt,      vntPolDiag, _
                                                vntPolEtc1,          vntPolRemark1,      vntPolSugery, _
                                                vntPolEndoscope,     vntPolChemical,     vntPolRadiation, _
                                                vntPolReferSt,       vntPolRefer,        vntPolEtc2,        vntPolRemark2, _
                                                vntUpdDate,          vntUpdUser,         vntUpdUserName _
                                                )

    Exit Do
Loop


'-------------------------------------------------------------------------------
'
' 機能　　 : 判定の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditJudListInfo()

    '判定一覧取得
    lngJudListCnt = objJud.SelectJudList( strArrJudCd, , , strArrWeight)

    strArrJudCdSeq = Array()
    Redim Preserve strArrJudCdSeq(lngJudListCnt-1)
    For i = 0 To lngJudListCnt-1
        strArrJudCdSeq(i) = i
    Next

End Sub


'-------------------------------------------------------------------------------
'
' 機能　　 : フォローアップ情報各値の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim objCommon       '共通クラス

    Dim vntArrMessage   'エラーメッセージの集合
    Dim strMessage      'エラーメッセージ
    Dim i               'インデックス

    '共通クラスのインスタンス作成
    Set objCommon = Server.CreateObject("HainsCommon.Common")

    '各値チェック処理
    With objCommon

        '二次検査予定日
        .AppendArray vntArrMessage, .CheckDate("二次検査予定日", strSecPlanYear, strSecPlanMonth, strSecPlanDay, strSecPlanDate)


        '病医院名
        strMessage = .CheckWideValue("病医院名", strSecEquipName, 50)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If

        '診療科
        strMessage = .CheckWideValue("診療科", strSecEquipCourse, 50)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If

        '担当医師
        strMessage = .CheckWideValue("担当医師", strSecDoctor, 40)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If

        '住所
        strMessage = .CheckLength("住所", strSecEquipAddr, 120)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If

        '住所
        strMessage = .CheckLength("電話番号", strSecEquipTel, 15)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If

        '備考(改行文字も1字として含む旨を通達)
        strMessage = .CheckWideValue("備考", strSecRemark, 400)
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
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>二次検診情報登録</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<%
    '### 保存処理、削除処理後親画面も最新情報で表示
    If strAction = "saveend" Then
%>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
        //親画面が閉じられていなかった場合、親画面リフレッシュ
        if (!opener.closed) {
            opener.replaceForm();
        }
//-->
</SCRIPT>
<%
    ElseIf strAction = "deleteend" Then
%>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
        //親画面が閉じられていなかった場合、親画面リフレッシュ
        if (!opener.closed) {
            opener.replaceForm();
        }
        window.close();
//-->
</SCRIPT>
<%
    End If
%>

<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--

    var winRslFol;          // フォロー結果登録ウィンドウハンドル


    /** 判定分類別フォローアップ情報保存 **/
    function saveData() {

        if ( !confirm( 'フォローアップ情報を変更します。よろしいですか？' ) ) {
            return;
        }
        with ( document.entryForm ) {
            act.value = 'save';
            submit();
        }

        //親画面が閉じられていなかった場合、親画面リフレッシュ
        //if (!opener.closed) {
        //    opener.replaceForm();
        //}
        return false;

    }


    /** 判定分類別フォローアップ情報削除 **/
    function deleteData() {

        if ( !confirm( 'フォローアップ情報を削除します。\nフォローアップ情報は削除すると元に戻す事が出来ません。\n\n削除してよろしいでしょうか？' ) ) {
            return;
        }

        // モードを指定してsubmit
        with ( document.entryForm ) {
            act.value = 'delete';
            submit();
        }
        return false;
    }

    /** フォローアップ結果承認又は承認取消処理 **/
    function followRslConfirm(confirmFlg,statusCd) {
        var confirmMsg;
        var scnt ;

        if (confirmFlg == '1') {
            if(statusCd==''){
                 alert("『ステータス』は必須項目ですので、先に『ステータス』を登録してください。");
                return false;
            }

            confirmMsg = '二次検査結果を承認します。                 \n\n承認してよろしいでしょうか？';
        } else {
            confirmMsg = '承認されている二次検査結果を承認取消します。\n\n承認取消してよろしいでしょうか？';
        }

        if ( !confirm( confirmMsg ) ) {
            return;
        }
        with ( document.entryForm ) {
            reqConfirmFlg.value = confirmFlg;
            act.value = 'confirm';
            submit();
        }
        return false;
    }



    function showFollowRsl(rsvNo, judClassCd, seq) {

        var opened = false; // 画面が開かれているか
        var url;            // URL文字列
        var myForm = document.entryFollowInfo;

        // すでに画面が開かれているかチェック
        if ( winRslFol != null ) {
            if ( !winRslFol.closed ) {
                opened = true;
            }
        }

        // フォロー結果登録画面呼び出し
        url = 'followRslEdit.asp?winmode=1&rsvno='+rsvNo+'&judClassCd=' + judClassCd+'&seq=' + seq;

        // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
        if ( opened ) {
            winRslFol.focus();
            winRslFol.location.replace(url);
        } else {
            /** 2016.09.13 張 結果入力画面初期表示サイズ変更 **/
            //winRslFol = window.open(url, '', 'width=1040,height=700,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
            winRslFol = window.open(url, '', 'width=1140,height=800,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        } 
    }

    // ボタンクリック
    function replaceForm() {

        with ( document.entryForm ) {
            action.value = "";
            submit();
        }
        return false;
    }

    function chkWrite(chkBox, txtArea) {

        if(chkBox.checked) {
            txtArea.disabled = false;
            txtArea.focus();
        } else {
            txtArea.value = "";
            txtArea.disabled = true;
        }
    }

    function onLoad(){
        with (document.entryForm){

            if(rsvTestETC.checked) {
                rsvTestRemark.disabled = false;
            } else {
                rsvTestRemark.disabled = true;
            }

            if(rsvTestRefer.checked) {
                rsvTestReferText.disabled = false;
            } else {
                rsvTestReferText.disabled = true;
            }
        }
    }

    function replace(){
    }

//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY BGCOLOR="#ffffff"  ONLOAD="onLoad();">

<!-- #include virtual = "/webHains/includes/followupHeader.inc" -->
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
    <TR>
        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">フォローアップ情報登録</FONT></B></TD>
    </TR>
</TABLE>
<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
    <TR>
        <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
    </TR>
</TABLE>
<%
    '## 受診者個人情報表示
    Call followupHeader(lngRsvNo)
%>
    <!--BR-->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden"    NAME="mode"         VALUE="<%= strMode %>"      >
    <INPUT TYPE="hidden"    NAME="act"          VALUE=""                    >
    <INPUT TYPE="hidden"    NAME="target"       VALUE="<%= strTarget %>"    >
    <INPUT TYPE="hidden"    NAME="rsvno"        VALUE="<%= lngRsvNo %>"     >
    <INPUT TYPE="hidden"    NAME="judClassCd"   VALUE="<%= lngJudClassCd %>">

<%
    'メッセージの編集
    If strAction <> "" Then

        Select Case strAction

            '保存完了時は「保存完了」の通知
            Case "saveend"
                Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

            'さもなくばエラーメッセージを編集
            Case Else
                Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

        End Select

End If
%>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
        <TR ALIGN="left">
            <TD width="*">
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR align="center">
                        <TD NOWRAP BGCOLOR="#cccccc" width="120" HEIGHT="22">健診項目</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee" width="120"><B><%= strJudClassName %></B></TD>
                        <TD width="20">&nbsp;</TD>
                        <TD NOWRAP BGCOLOR="#cccccc" width="120">判定</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee" width="100"><%= EditDropDownListFromArray("judCd", strArrJudCd, strArrJudCd, strJudCd, NON_SELECTED_ADD) %></TD>
                        <TD NOWRAP><B>&nbsp;最終判定&nbsp;：&nbsp;<%= strRslJudCd %></B></TD>
                    </TR>
                </TABLE>
            </TD>
            
            <% '2010.01.12 権限管理 追加 by 李
                If Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" Then %>
            <TD width="300" align="right">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR align="right">
                        <TD NOWRAP ALIGN="right">&nbsp;
                        <% If strReqConfirmDate = "" Then %>
                            <A HREF="javascript:function voi(){};voi()" ONCLICK="return saveData()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="二次検査結果情報保存"></A>
                            <A HREF="javascript:function voi(){};voi()" ONCLICK="return deleteData()"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="フォローアップ情報削除"></A>
                        <% Else  %>
                            <IMG SRC="/webHains/images/confirm_complete.gif" border="0">
                        <% End If %>
                        </TD>
                    </TR>
                </TABLE>
            </TD>
            <% End If %>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
        <TR>
            <TD NOWRAP WIDTH="120" HEIGHT="25" BGCOLOR="#cccccc" ALIGN="left">&nbsp;二次検査施設</TD>
            <TD NOWRAP>
                <INPUT TYPE="radio" NAME="secEquipDiv" VALUE="0" BORDER="0" <%= IIf(strSecEquipDiv = "0", " CHECKED", "") %>><%= IIf(strSecEquipDiv = "0", "<B>二次検査場所未定</B>", "二次検査場所未定") %>&nbsp;&nbsp;
                <INPUT TYPE="radio" NAME="secEquipDiv" VALUE="1" BORDER="0" <%= IIf(strSecEquipDiv = "1", " CHECKED", "") %>><%= IIf(strSecEquipDiv = "1", "<B>当センター</B>", "当センター") %>&nbsp;&nbsp;
                <%'### 2016.09.13 張 本院→本院・メディローカスに変更 ###%>
                <INPUT TYPE="radio" NAME="secEquipDiv" VALUE="2" BORDER="0" <%= IIf(strSecEquipDiv = "2", " CHECKED", "") %>><%= IIf(strSecEquipDiv = "2", "<B>本院・メディローカス</B>", "本院・メディローカス") %>&nbsp;&nbsp;
                <INPUT TYPE="radio" NAME="secEquipDiv" VALUE="3" BORDER="0" <%= IIf(strSecEquipDiv = "3", " CHECKED", "") %>><%= IIf(strSecEquipDiv = "3", "<B>他院</B>", "他院") %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <INPUT TYPE="radio" NAME="secEquipDiv" VALUE="9" BORDER="0" <%= IIf(strSecEquipDiv = "9", " CHECKED", "") %>><%= IIf(strSecEquipDiv = "9", "<B>対象外</B>", "対象外") %>
            </TD>
        </TR>
        <TR>
            <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc" ALIGN="left">&nbsp;二次検査予定日</TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP ID="gdeDate"><A HREF="javascript:calGuide_showGuideCalendar('secPlanYear', 'secPlanMonth', 'secPlanDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示します"></A></TD>
                        <TD NOWRAP><A HREF="javascript:calGuide_clearDate('secPlanYear', 'secPlanMonth', 'secPlanDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
                                <TR>
                                    <TD><%= EditNumberList("secPlanYear", YEARRANGE_MIN, YEARRANGE_MAX, strSecPlanYear, True) %></TD>
                                    <TD>年</TD>
                                    <TD><%= EditNumberList("secPlanMonth", 1, 12, strSecPlanMonth, True) %></TD>
                                    <TD>月</TD>
                                    <TD><%= EditNumberList("secPlanDay", 1, 31, strSecPlanDay, True) %></TD>
                                    <TD>日</TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>

        <TR>
            <TD NOWRAP BGCOLOR="#cccccc">&nbsp;二次検査予約項目</TD>
            <TD NOWRAP>
                <INPUT TYPE="checkbox" NAME="rsvTestUS"     VALUE="1" <%= IIf( strRsvTestUS = "1", "CHECKED", "") %>>US&nbsp;&nbsp;
                <INPUT TYPE="checkbox" NAME="rsvTestCT"     VALUE="1" <%= IIf( strRsvTestCT = "1", "CHECKED", "") %>>CT&nbsp;&nbsp;
                <INPUT TYPE="checkbox" NAME="rsvTestMRI"    VALUE="1" <%= IIf( strRsvTestMRI = "1", "CHECKED", "") %>>MRI&nbsp;&nbsp;
                <INPUT TYPE="checkbox" NAME="rsvTestBF"     VALUE="1" <%= IIf( strRsvTestBF = "1", "CHECKED", "") %>>BF&nbsp;&nbsp;
                <INPUT TYPE="checkbox" NAME="rsvTestGF"     VALUE="1" <%= IIf( strRsvTestGF = "1", "CHECKED", "") %>>GF&nbsp;&nbsp;
                <INPUT TYPE="checkbox" NAME="rsvTestCF"     VALUE="1" <%= IIf( strRsvTestCF = "1", "CHECKED", "") %>>CF&nbsp;&nbsp;
                <INPUT TYPE="checkbox" NAME="rsvTestEM"     VALUE="1" <%= IIf( strRsvTestEM = "1", "CHECKED", "") %>>注腸&nbsp;&nbsp;
                <INPUT TYPE="checkbox" NAME="rsvTestTM"     VALUE="1" <%= IIf( strRsvTestTM = "1", "CHECKED", "") %>>腫瘍マーカー&nbsp;&nbsp;

                <INPUT TYPE="checkbox" NAME="rsvTestRefer"  VALUE="1" <%= IIf( strRsvTestRefer = "1", "CHECKED", "") %>     ONCLICK="chkWrite(this,rsvTestReferText);">リファー&nbsp;
                <INPUT TYPE="text" NAME="rsvTestReferText" SIZE="10" MAXLENGTH="40" VALUE="<%= strRsvTestReferText %>" STYLE="ime-mode:active;">

                <INPUT TYPE="checkbox" NAME="rsvTestETC"    VALUE="1" <%= IIf( strRsvTestETC = "1", "CHECKED", "") %> ONCLICK="chkWrite(this, rsvTestRemark);">その他&nbsp;
                <INPUT TYPE="text" NAME="rsvTestRemark" SIZE="30" MAXLENGTH="45" VALUE="<%= strRsvTestRemark %>" STYLE="ime-mode:active;">
            </TD>
        </TR>




    </TABLE>
    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
                    <TR>
                        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">検査結果</FONT></B></TD>
                    </TR>
                </TABLE>
            </TD>
            <% '2010.01.12 権限管理 追加 by 李
                If Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" Then %>
            <TD WIDTH="150">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" WIDTH="100%">
                    <TR>
                        <TD NOWRAP HEIGHT="15">
                        <% If strReqConfirmDate = "" Then %>
                            <IMG SRC="../../images/spacer.gif" WIDTH="10">
                            <A HREF="javascript:function voi(){};voi()" ONCLICK="return showFollowRsl('<%= lngRsvNo %>', '<%= lngJudClassCd %>', '0')">
                            <IMG SRC="/webHains/images/b_append.gif" WIDTH="77" HEIGHT="24" ALT="検査結果追加登録">
                            </A>
                        <% End If  %>
                        </TD>
                    </TR>
                </TABLE>
            </TD>
            <% End If %>
        </TR>
    <TABLE>
    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>
<%
    '#### 二次検査結果情報編集
    If lngAllCount > 0 Then

        For i = 0 To UBound(vntRsvNo)

            lngPolCount1 = 0
            lngPolCount2 = 0
            lngTestCount = 0

            If vntSecCslDate(i) <> "" Then
                strSecCslYear   = Year(vntSecCslDate(i))
                strSecCslMonth  = Month(vntSecCslDate(i))
                strSecCslDay    = Day(vntSecCslDate(i))
            End If
%>

    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="95%">
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%">
                <TABLE>
                    <TR>
                        <TD WIDTH="120" HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;検査（治療）実施日</TD>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                                <TR>
                                    <TD NOWRAP WIDTH="150"><FONT COLOR="#ff6600"><B><%= vntSecCslDate(i) %></B></FONT></TD>
                                    <% '2010.01.12 権限管理 追加 by 李
                                        If Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" Then %>
                                    <TD NOWRAP>
                                    <% If strReqConfirmDate = "" Then %>
                                        <A HREF="javascript:function voi(){};voi()" ONCLICK="return showFollowRsl('<%= vntRsvNo(i) %>', '<%= vntJudClassCd(i) %>', '<%= vntSeq(i) %>')">
                                        <IMG SRC="/webHains/images/change.gif" WIDTH="77" HEIGHT="24" ALT="二次検査結果変更">
                                        </A>
                                    <% End If %>
                                    </TD>
                                    <% End If %>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">&nbsp;二次検査項目</TD>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                                <TR>
                                    <TD NOWRAP>
                                    <%
                                        strWebTestItem = ""
                                        If vntTestUS(i) = "1"  Then
                                            strWebTestItem = strWebTestItem & "US&nbsp;&nbsp;" 
                                            lngTestCount = lngTestCount + 1
                                        End If

                                        If vntTestCT(i) = "1"  Then
                                            If lngTestCount > 0 Then
                                                strWebTestItem = strWebTestItem & "/&nbsp;&nbsp;CT&nbsp;&nbsp;"
                                            Else
                                                strWebTestItem = strWebTestItem & "CT&nbsp;&nbsp;"
                                            End If
                                            lngTestCount = lngTestCount + 1
                                        End If

                                        If vntTestMRI(i) = "1" Then
                                            If lngTestCount > 0 Then
                                                strWebTestItem = strWebTestItem & "/&nbsp;&nbsp;MRI&nbsp;&nbsp;"
                                            Else
                                                strWebTestItem = strWebTestItem & "MRI&nbsp;&nbsp;"
                                            End If
                                            lngTestCount = lngTestCount + 1
                                        End If

                                        If vntTestBF(i) = "1"  Then
                                            If lngTestCount > 0 Then
                                                strWebTestItem = strWebTestItem & "/&nbsp;&nbsp;BF&nbsp;&nbsp;"
                                            Else
                                                strWebTestItem = strWebTestItem & "BF&nbsp;&nbsp;"
                                            End If
                                            lngTestCount = lngTestCount + 1
                                        End If

                                        If vntTestGF(i) = "1"  Then
                                            If lngTestCount > 0 Then
                                                strWebTestItem = strWebTestItem & "/&nbsp;&nbsp;GF&nbsp;&nbsp;"
                                            Else
                                                strWebTestItem = strWebTestItem & "GF&nbsp;&nbsp;"
                                            End If
                                            lngTestCount = lngTestCount + 1
                                        End If

                                        If vntTestCF(i) = "1"  Then
                                            If lngTestCount > 0 Then
                                                strWebTestItem = strWebTestItem & "/&nbsp;&nbsp;CF&nbsp;&nbsp;"
                                            Else
                                                strWebTestItem = strWebTestItem & "CF&nbsp;&nbsp;"
                                            End If
                                            lngTestCount = lngTestCount + 1
                                        End If

                                        If vntTestEM(i) = "1"  Then
                                            If lngTestCount > 0 Then
                                                strWebTestItem = strWebTestItem & "/&nbsp;&nbsp;注腸&nbsp;&nbsp;"
                                            Else
                                                strWebTestItem = strWebTestItem & "注腸&nbsp;&nbsp;"
                                            End If
                                            lngTestCount = lngTestCount + 1
                                        End If

                                        If vntTestTM(i) = "1"  Then
                                            If lngTestCount > 0 Then
                                                strWebTestItem = strWebTestItem & "/&nbsp;&nbsp;腫瘍マーカー&nbsp;&nbsp;"
                                            Else
                                                strWebTestItem = strWebTestItem & "腫瘍マーカー&nbsp;&nbsp;"
                                            End If
                                            lngTestCount = lngTestCount + 1
                                        End If
                                        
                                        If vntTestRefer(i) = "1" Then 
                                            If lngTestCount > 0 Then
                                                strWebTestItem = strWebTestItem & "/&nbsp;&nbsp;リファー&nbsp;"
                                            Else
                                                strWebTestItem = strWebTestItem & "リファー&nbsp;"
                                            End If
                                            If vntTestReferText(i) <> "" Then
                                                strWebTestItem = strWebTestItem & "(&nbsp;" & vntTestReferText(i) & "&nbsp;)"
                                            End If
                                        End If

                                        If vntTestETC(i) = "1" Then 
                                            If lngTestCount > 0 Then
                                                strWebTestItem = strWebTestItem & "/&nbsp;&nbsp;その他&nbsp;"
                                            Else
                                                strWebTestItem = strWebTestItem & "その他&nbsp;"
                                            End If
                                            If vntTestRemark(i) <> "" Then
                                                strWebTestItem = strWebTestItem & "(&nbsp;" & vntTestRemark(i) & "&nbsp;)"
                                            End If
                                        End If


                                    %><%= strWebTestItem %>
                                    </TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                    <TR>
                        <TD WIDTH="120" HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;二次検査結果</TD>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                                <TR>
                                    <TD NOWRAP>
                                    <%
                                        strWebResultDivName = ""
                                        Select Case vntResultDiv(i)
                                           Case "1"
                                                strWebResultDivName = "異常なし"
                                           Case "2"
                                                strWebResultDivName = "不明"
                                           Case "3"
                                                strWebResultDivName = "診断名あり"
                                        End Select
                                    %><%= strWebResultDivName %>
                                    </TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                    <TR>
                        <TD WIDTH="120" HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;診断名</TD>
                        <TD WIDTH="100%">
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999">
                                <TR ALIGN="center" BGCOLOR="#cccccc">
                                    <TD NOWRAP WIDTH="130">分類</TD>
                                    <TD NOWRAP WIDTH="160">臓器（部位）</TD>
                                    <TD NOWRAP WIDTH="100%">診断名</TD>
                                </TR>
                <%
                    '二次検査結果情報別疾患（診断名）情報取得（登録されている疾患情報のみ取得）
                    lngStcCount = objFollow.SelectFollowRslItemList(vntRsvNo(i) ,   vntJudClassCd(i),   vntSeq(i), _
                                                                    vntGrpName,     vntItemCd,          vntSuffix, _
                                                                    vntItemName,    vntResult,          vntShortStc, True _
                                                                   )
                    strBeforeGrpName = ""
                    If lngStcCount > 0 Then
                        For j = 0 To UBound(vntGrpName)
                            strWebGrpName = ""
                            If strBeforeGrpName <> vntGrpName(j) Then
                                strWebGrpName = vntGrpName(j)
                            End If
                %>
                                <TR ALIGN="left" BGCOLOR="#ffffff">
                                    <TD NOWRAP WIDTH="130"><%= strWebGrpName %></TD>
                                    <TD NOWRAP WIDTH="160"><%= vntItemName(j) %></TD>
                                    <TD NOWRAP WIDTH="100%"><%= vntShortStc(j) %></TD>
                                </TR>
                <%
                            strBeforeGrpName = vntGrpName(j)
                        Next
                    Else
                %>
                                <TR ALIGN="center" BGCOLOR="#ffffff">
                                    <TD NOWRAP COLSPAN="3"HEIGHT="40">登録されている診断名がありません。</TD>
                                </TR>
                <%
                    End If
                %>
                            </TABLE>
                        </TD>
                    </TR>
                    <TR>
                        <TD WIDTH="120" HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;その他疾患</TD>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                                <TR>
                                    <TD><pre><%= vntDisRemark(i) %></pre></TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">方針（治療なし）</TD>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                                <TR>
                                    <TD NOWRAP>
                                    <%
                                        strWebPolicy1 = ""
                                        If vntPolWithout(i) = "1" Then
                                            strWebPolicy1 = strWebPolicy1 & "処置不要&nbsp;&nbsp;"
                                            lngPolCount1 = lngPolCount1 + 1
                                        End If

                                        If vntPolFollowup(i) = "1" Then
                                            If lngPolCount1 > 0 Then
                                                strWebPolicy1 = strWebPolicy1 & "/&nbsp;&nbsp;経過観察&nbsp;"
                                            Else
                                                strWebPolicy1 = strWebPolicy1 & "経過観察&nbsp;"
                                            End If
                                            If vntPolMonth(i) <> "" Then
                                                strWebPolicy1 = strWebPolicy1 & "(&nbsp;" & vntPolMonth(i) & "&nbsp;ヶ月&nbsp;)&nbsp;&nbsp;"
                                            Else
                                                strWebPolicy1 = strWebPolicy1 & "&nbsp;"
                                            End If
                                            lngPolCount1 = lngPolCount1 + 1
                                        End If

                                        If vntPolReExam(i) = "1" Then
                                            If lngPolCount1 > 0 Then
                                                strWebPolicy1 = strWebPolicy1 & "/&nbsp;&nbsp;1年後健診&nbsp;&nbsp;"
                                            Else
                                                strWebPolicy1 = strWebPolicy1 & "1年後健診&nbsp;&nbsp;"
                                            End If
                                            lngPolCount1 = lngPolCount1 + 1
                                        End If

                                        If vntPolDiagSt(i) = "1" Then
                                            If lngPolCount1 > 0 Then
                                                '### 2016.09.13 張 本院→本院・メディローカスに変更 ###
                                                'strWebPolicy1 = strWebPolicy1 & "/&nbsp;&nbsp;本院紹介（精査）&nbsp;&nbsp;"
                                                strWebPolicy1 = strWebPolicy1 & "/&nbsp;&nbsp;本院・メディローカス紹介（精査）&nbsp;&nbsp;"
                                            Else
                                                '### 2016.09.13 張 本院→本院・メディローカスに変更 ###
                                                'strWebPolicy1 = strWebPolicy1 & "本院紹介（精査）&nbsp;&nbsp;"
                                                strWebPolicy1 = strWebPolicy1 & "本院・メディローカス紹介（精査）&nbsp;&nbsp;"
                                            End If
                                            lngPolCount1 = lngPolCount1 + 1
                                        End If

                                        If vntPolDiag(i) = "1" Then
                                            If lngPolCount1 > 0 Then
                                                strWebPolicy1 = strWebPolicy1 & "/&nbsp;&nbsp;他院紹介（精査）&nbsp;&nbsp;"
                                            Else
                                                strWebPolicy1 = strWebPolicy1 & "他院紹介（精査）&nbsp;&nbsp;"
                                            End If
                                            lngPolCount1 = lngPolCount1 + 1
                                        End If

                                        If vntPolEtc1(i) = "1" Then
                                            If lngPolCount1 > 0 Then
                                                strWebPolicy1 = strWebPolicy1 & "/&nbsp;&nbsp;その他&nbsp;"
                                            Else
                                                strWebPolicy1 = strWebPolicy1 & "その他&nbsp;"
                                            End If
                                            If vntPolRemark1(i) <> "" Then
                                                strWebPolicy1 = strWebPolicy1 & "(&nbsp;" & vntPolRemark1(i) & "&nbsp;)&nbsp;"
                                            End If
                                        End If
                                    %><%= strWebPolicy1 %>
                                    </TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">方針（治療あり）</TD>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                                <TR>
                                    <TD NOWRAP>
                                    <%
                                        strWebPolicy2 = ""
                                        If vntPolSugery(i) = "1" Then
                                            strWebPolicy2 = strWebPolicy2 & "外科治療&nbsp;&nbsp;&nbsp;&nbsp;"
                                            lngPolCount2 = lngPolCount2 + 1
                                        End If

                                        If vntPolEndoscope(i)   = "1" Then
                                            If lngPolCount2 > 0 Then
                                                strWebPolicy2 = strWebPolicy2 & "/&nbsp;&nbsp;内視鏡的治療&nbsp;&nbsp;"
                                            Else
                                                strWebPolicy2 = strWebPolicy2 & "内視鏡的治療&nbsp;&nbsp;"
                                            End If
                                            lngPolCount2 = lngPolCount2 + 1
                                        End If

                                        If vntPolChemical(i) = "1" Then
                                            If lngPolCount2 > 0 Then
                                                strWebPolicy2 = strWebPolicy2 & "/&nbsp;&nbsp;化学療法&nbsp;&nbsp;"
                                            Else
                                                strWebPolicy2 = strWebPolicy2 & "化学療法&nbsp;&nbsp;"
                                            End If
                                            lngPolCount2 = lngPolCount2 + 1
                                        End If

                                        If vntPolRadiation(i) = "1" Then
                                            If lngPolCount2 > 0 Then
                                                strWebPolicy2 = strWebPolicy2 & "/&nbsp;&nbsp;放射線治療&nbsp;&nbsp;"
                                            Else
                                                strWebPolicy2 = strWebPolicy2 & "放射線治療&nbsp;&nbsp;"
                                            End If
                                            lngPolCount2 = lngPolCount2 + 1
                                        End If

                                        If vntPolReferSt(i) = "1" Then
                                            If lngPolCount2 > 0 Then
                                                '### 2016.09.13 張 本院→本院・メディローカスに変更 ###
                                                'strWebPolicy2 = strWebPolicy2 & "/&nbsp;&nbsp;本院紹介&nbsp;&nbsp;"
                                                strWebPolicy2 = strWebPolicy2 & "/&nbsp;&nbsp;本院・メディローカス紹介&nbsp;&nbsp;"
                                            Else
                                                '### 2016.09.13 張 本院→本院・メディローカスに変更 ###
                                                'strWebPolicy2 = strWebPolicy2 & "本院紹介&nbsp;&nbsp;"
                                                strWebPolicy2 = strWebPolicy2 & "本院・メディローカス紹介&nbsp;&nbsp;"
                                            End If
                                            lngPolCount2 = lngPolCount2 + 1
                                        End If

                                        If vntPolRefer(i) = "1" Then
                                            If lngPolCount2 > 0 Then
                                                strWebPolicy2 = strWebPolicy2 & "/&nbsp;&nbsp;他院紹介&nbsp;&nbsp;"
                                            Else
                                                strWebPolicy2 = strWebPolicy2 & "他院紹介&nbsp;&nbsp;"
                                            End If
                                            lngPolCount2 = lngPolCount2 + 1
                                        End If

                                        If vntPolEtc2(i) = "1" Then
                                            If lngPolCount2 > 0 Then
                                                strWebPolicy2 = strWebPolicy2 & "/&nbsp;&nbsp;その他&nbsp;"
                                            Else
                                                strWebPolicy2 = strWebPolicy2 & "その他&nbsp;"
                                            End If
                                            If vntPolRemark2(i) <> "" Then
                                                strWebPolicy2 = strWebPolicy2 & "(&nbsp;" & vntPolRemark2(i) & "&nbsp;)&nbsp;"
                                            End If

                                        End If
                                    %><%= strWebPolicy2 %>
                                    </TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

<%
        Next
    Else
%>

    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="100%" HEIGHT="200">
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%" ALIGN="center">二次検査結果データが未登録状態です。<BR>【追加】ボタンをクリックして二次検査結果登録ができます。
            </TD>
        </TR>
    </TABLE>

<%
    End If
%>

    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">&nbsp;ステータス</TD>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                                <!--TR>
                                    <TD NOWRAP>
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="1" BORDER="0" <%= IIf(strStatusCd = "1", " CHECKED", "") %>>異常なし&nbsp;&nbsp;&nbsp;&nbsp;
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="2" BORDER="0" <%= IIf(strStatusCd = "2", " CHECKED", "") %>>異常あり（フォローなし）&nbsp;&nbsp;&nbsp;&nbsp;
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="3" BORDER="0" <%= IIf(strStatusCd = "3", " CHECKED", "") %>>異常あり（継続フォロー）&nbsp;&nbsp;&nbsp;&nbsp;
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="4" BORDER="0" <%= IIf(strStatusCd = "4", " CHECKED", "") %>>その他終了（連絡とれず）
                                    </TD>
                                </TR-->
                                <TR>
                                    <TD WIDTH="150" NOWRAP ALIGN="RIGHT" BGCOLOR="#eeeeee">診断確定&nbsp;：&nbsp;</TD>
                                    <TD NOWRAP>
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="11" BORDER="0" <%= IIf(strStatusCd = "11", " CHECKED", "") %>>異常なし&nbsp;&nbsp;&nbsp;&nbsp;
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="12" BORDER="0" <%= IIf(strStatusCd = "12", " CHECKED", "") %>>異常あり
                                    </TD>
                                </TR>
                                <TR>
                                    <TD WIDTH="150" NOWRAP ALIGN="RIGHT" BGCOLOR="#eeeeee">診断未確定(受診施設)&nbsp;：&nbsp;</TD>
                                    <TD NOWRAP>
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="21" BORDER="0" <%= IIf(strStatusCd = "21", " CHECKED", "") %>>センター&nbsp;&nbsp;&nbsp;&nbsp;
                                        <%'### 2016.09.13 張 本院→本院・メディローカスに変更 ###%>
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="22" BORDER="0" <%= IIf(strStatusCd = "22", " CHECKED", "") %>>本院・メディローカス&nbsp;&nbsp;&nbsp;&nbsp;
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="23" BORDER="0" <%= IIf(strStatusCd = "23", " CHECKED", "") %>>他院&nbsp;&nbsp;&nbsp;&nbsp;
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="29" BORDER="0" <%= IIf(strStatusCd = "29", " CHECKED", "") %>>その他(未定・不明)
                                    </TD>
                                </TR>
                                <TR>
                                    <TD WIDTH="150" NOWRAP>&nbsp;</TD>
                                    <TD NOWRAP>
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="99" BORDER="0" <%= IIf(strStatusCd = "99", " CHECKED", "") %>>その他(フォローアップ登録終了)
                                    </TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">&nbsp;備考</TD>
                        <TD COLSPAN="7"><TEXTAREA NAME="secRemark" style="ime-mode:active"  COLS="70" ROWS="4"><%= strSecRemark %></TEXTAREA></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <BR>

    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">医療機関</FONT></B></TD>
        </TR>
    </TABLE>
    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">&nbsp;病医院名</TD>
                        <TD><INPUT TYPE="text" NAME="secEquipName" SIZE="70" MAXLENGTH="50" VALUE="<%= strSecEquipName %>" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">&nbsp;診療科</TD>
                        <TD><INPUT TYPE="text" NAME="secEquipCourse" SIZE="70" MAXLENGTH="50" VALUE="<%= strSecEquipCourse %>" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">&nbsp;担当医師</TD>
                        <TD><INPUT TYPE="text" NAME="secDoctor" SIZE="50" MAXLENGTH="40" VALUE="<%= strSecDoctor %>" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">&nbsp;住所</TD>
                        <TD><INPUT TYPE="text" NAME="secEquipAddr" SIZE="100" MAXLENGTH="120" VALUE="<%= strSecEquipAddr %>" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">&nbsp;電話番号</TD>
                        <TD><INPUT TYPE="text" NAME="secEquipTel" SIZE="50" MAXLENGTH="15" VALUE="<%= strSecEquipTel %>" STYLE="ime-mode:inactive;"></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD HEIGHT="22" WIDTH="120" NOWRAP BGCOLOR="#cccccc">&nbsp;最初登録日時</TD>
                        <TD HEIGHT="22" WIDTH="140" NOWRAP ><%= strAddDate %></TD>
                        <TD HEIGHT="22" WIDTH="120" NOWRAP BGCOLOR="#cccccc">&nbsp;最終更新日時</TD>
                        <TD HEIGHT="22" WIDTH="140" NOWRAP ><%= strUpdDate %></TD>
                        <TD HEIGHT="22" WIDTH="120" NOWRAP BGCOLOR="#cccccc">&nbsp;結果承認日時</TD>
                        <TD HEIGHT="22" WIDTH="140" NOWRAP ><%= strReqConfirmDate %></TD>
                        <% '2010.01.12 権限管理 追加 by 李
                            if Session("PAGEGRANT") = "4" then %>
                            <TD ROWSPAN="2" VALIGN="TOP">
                            <% If strReqConfirmDate <> "" Then %>
                                <A HREF="javascript:function voi(){};voi()" ONCLICK="return followRslConfirm('0','<%= strStatusCd %>')">
                                <IMG SRC="/webHains/images/follow_confirm_up.gif" WIDTH="77" HEIGHT="24" ALT="結果承認取消">
                                </A>
                            <% Else %>
                                <A HREF="javascript:function voi(){};voi()" ONCLICK="return followRslConfirm('1','<%= strStatusCd %>')">
                                <IMG SRC="/webHains/images/follow_confirm.gif" WIDTH="77" HEIGHT="24" ALT="結果承認">
                                </A>
                            <% End If %>
                                <INPUT TYPE="hidden"    NAME="reqConfirmFlg"   VALUE="">
                            </TD>
                        <% End If %>  
                    </TR>

                    <TR>
                        <TD HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;最初登録者</TD>
                        <TD><%= strAddUserName %></TD>
                        <TD HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;最終更新者</TD>
                        <TD><%= strUpdUserName %></TD>
                        <TD HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;結果承認者</TD>
                        <TD><%= strReqConfirmUserName %></TD>
                        <TD>&nbsp;</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

</FORM>
</BODY>
</HTML>
