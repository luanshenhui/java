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
Dim objFollow           'フォローアップアクセス用
Dim objJud              '判定情報アクセス用

Dim strMode             '処理モード(挿入:"insert"、更新:"update")
Dim strAction           '処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")
Dim strTarget           'ターゲット先のURL

'結果情報変更及び新規登録後最新情報表示用
Dim lngNewSeq               '一連番号

'パラメータ
Dim lngRsvNo                '予約番号
Dim lngJudClassCd           '判定分類コード
Dim lngSeq                  '一連番号

Dim strJudClassName         '判定分類名
Dim strJudCd                '判定コード（フォロー確定時判定結果）
Dim strRslJudCd             '判定コード（カレント（現在）判定結果）
Dim strSecEquipDiv          '二次検査実施（施設）区分
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
Dim strSecRemark            '備考

Dim strSecEquipDivName      '二次検査実施（施設）区分名称表示用

Dim strSecCslDate           '二次実施日
Dim strSecCslYear           '二次実施日（年）
Dim strSecCslMonth          '二次実施日（月）
Dim strSecCslDay            '二次実施日（日）

Dim strTestUpdDate          '更新日時
Dim strTestUpdUser          '更新者ID
Dim strTestUpdUserName      '更新者氏名

Dim strTestUS               '二次検査項目US
Dim strTestCT               '二次検査項目CT
Dim strTestMRI              '二次検査項目MRI
Dim strTestBF               '二次検査項目BF
Dim strTestGF               '二次検査項目GF
Dim strTestCF               '二次検査項目CF
Dim strTestEM               '二次検査項目注腸
Dim strTestTM               '二次検査項目腫瘍マーカー
Dim strTestETC              '二次検査項目その他
Dim strTestRemark           '二次検査項目その他コメント
'二次検査項目追加　：2009/12/21 yhlee ---------------
Dim strTestRefer              '二次検査項目りファー
Dim strTestReferText          '二次検査項目りファー科
Dim strRsvTestName            '二次検査予約項目名
'二次検査項目追加 (End) --------------------------------

Dim strResultDiv            '二次検査結果区分
Dim strDisRemark            '二次検査結果その他疾患
Dim strPolWithout           '処置不要（治療方針）：治療なし
Dim strPolFollowup          '経過観察：治療なし
Dim strPolMonth             '経過観察期間（ヶ月）：治療なし
Dim strPolReExam            '1年後健診：治療なし
Dim strPolDiagSt            '本院紹介（精査）：治療なし
Dim strPolDiag              '他院紹介（精査）：治療なし
Dim strPolEtc1              'その他：治療なし
Dim strPolRemark1           'その他文章：治療なし
Dim strPolSugery            '外科治療：治療あり
Dim strPolEndoscope         '内視鏡的治療：治療あり
Dim strPolChemical          '化学療法：治療あり
Dim strPolRadiation         '放射線治療：治療あり
Dim strPolReferSt           '本院紹介：治療あり
Dim strPolRefer             '他院紹介：治療あり
Dim strPolEtc2              'その他：治療あり
Dim strPolRemark2           'その他文章：治療あり

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

'判定コンボボックス
Dim strArrJudCdSeq          '判定連番
Dim strArrJudCd             '判定コード
Dim strArrWeight            '判定用重み
Dim lngJudListCnt           '判定件数
Dim lngAllCount             '総件数

Dim i                       'インデックス
Dim Ret                     '復帰値
Dim rslCnt                  '結果入力欄インデックス
Dim blnFollowRsl            '復帰値（結果取得有無）

Dim strArrMessage           'エラーメッセージ

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objFollow       = Server.CreateObject("HainsFollow.Follow")
Set objJud          = Server.CreateObject("HainsJud.Jud")

'パラメータ値の取得
strMode        = Request("mode")
strAction      = Request("act")
strTarget      = Request("target")

lngRsvNo                = Request("rsvno")
lngJudClassCd           = Request("judClassCd")
lngSeq                  = Request("seq")

strSecCslDate           = Request("secCslDate")
strSecCslYear           = Request("secCslYear")
strSecCslMonth          = Request("secCslMonth")
strSecCslDay            = Request("secCslDay")
strTestUS               = Request("testUS")
strTestCT               = Request("testCT")
strTestMRI              = Request("testMRI")
strTestBF               = Request("testBF")
strTestGF               = Request("testGF")
strTestCF               = Request("testCF")
strTestEM               = Request("testEM")
strTestTM               = Request("testTM")
strTestETC              = Request("testETC")
strTestRemark           = Request("testRemark")

strTestRefer            = Request("testRefer")
strTestReferText        = Request("testReferText")

strResultDiv            = Request("resultDiv")
strDisRemark            = Request("disRemark")
strPolWithout           = Request("polWithout")
strPolFollowup          = Request("polFollowup")
strPolMonth             = Request("polMonth")
strPolReExam            = Request("polReExam")
strPolDiagSt            = Request("polDiagSt")
strPolDiag              = Request("polDiag")
strPolEtc1              = Request("polEtc1")
strPolRemark1           = Request("polRemark1")
strPolSugery            = Request("polSugery")
strPolEndoscope         = Request("polEndoscope")
strPolChemical          = Request("polChemical")
strPolRadiation         = Request("polRadiation")
strPolReferSt           = Request("polReferSt")
strPolRefer             = Request("polRefer")
strPolEtc2              = Request("polEtc2")
strPolRemark2           = Request("polRemark2")

vntGrpName              = ConvIStringToArray(Request("arrGrpName"))
vntItemName             = ConvIStringToArray(Request("arrItemName"))
vntItemCd               = ConvIStringToArray(Request("arrItemCd"))
vntSuffix               = ConvIStringToArray(Request("arrSuffix"))
vntResult               = ConvIStringToArray(Request("arrResult"))
vntShortStc             = ConvIStringToArray(Request("arrShortStc"))

strSecCslDate           = Request("secCslDate")
If strSecCslDate <> "" Then
    strSecCslYear   = Year(strSecCslDate)
    strSecCslMonth  = Month(strSecCslDate)
    strSecCslDay    = Day(strSecCslDate)
End If


'チェック・更新・読み込み処理の制御
Do

    '保存ボタン押下時
    If strAction = "save" Then

        '入力チェック
        strArrMessage = CheckValue()
        If Not IsEmpty(strArrMessage) Then
            Exit Do
        End If

'        response.write "lngSeq               --> " & lngSeq               & "<br>"
'        response.write "strSecCslDate        --> " & strSecCslDate        & "<br>"
'        response.write "strSecCslYear        --> " & strSecCslYear        & "<br>"
'        response.write "strSecCslMonth       --> " & strSecCslMonth       & "<br>"
'        response.write "strSecCslDay         --> " & strSecCslDay         & "<br>"
'        response.write "strTestUS            --> " & strTestUS            & "<br>"
'        response.write "strTestCT            --> " & strTestCT            & "<br>"
'        response.write "strTestMRI           --> " & strTestMRI           & "<br>"
'        response.write "strTestBF            --> " & strTestBF            & "<br>"
'        response.write "strTestGF            --> " & strTestGF            & "<br>"
'        response.write "strTestCF            --> " & strTestCF            & "<br>"
'        response.write "strTestEM            --> " & strTestEM            & "<br>"
'        response.write "strTestTM            --> " & strTestTM            & "<br>"
'        response.write "strTestETC           --> " & strTestETC           & "<br>"
'        response.write "strTestRemark        --> " & strTestRemark        & "<br>"
'        response.write "strResultDiv         --> " & strResultDiv         & "<br>"
'        response.write "strDisRemark         --> " & strDisRemark         & "<br>"
'        response.write "strPolWithout        --> " & strPolWithout        & "<br>"
'        response.write "strPolFollowup       --> " & strPolFollowup       & "<br>"
'        response.write "strPolMonth          --> " & strPolMonth          & "<br>"
'        response.write "strPolReExam         --> " & strPolReExam         & "<br>"
'        response.write "strPolDiag           --> " & strPolDiag           & "<br>"
'        response.write "strPolEtc1           --> " & strPolEtc1           & "<br>"
'        response.write "strPolRemark1        --> " & strPolRemark1        & "<br>"
'        response.write "strPolSugery         --> " & strPolSugery         & "<br>"
'        response.write "strPolEndoscope      --> " & strPolEndoscope      & "<br>"
'        response.write "strPolChemical       --> " & strPolChemical       & "<br>"
'        response.write "strPolRadiation      --> " & strPolRadiation      & "<br>"
'        response.write "strPolRefer          --> " & strPolRefer          & "<br>"
'        response.write "strPolEtc2           --> " & strPolEtc2           & "<br>"
'        response.write "strPolRemark2        --> " & strPolRemark2        & "<br>"
'        response.end

'2009.11.26 張
'        Ret = objFollow.UpdateFollow_Rsl( lngRsvNo,         lngJudClassCd,      lngSeq, _
'                                          strSecCslDate,    Session.Contents("userId"), strTestUS, _
'                                          strTestCT,        strTestMRI,         strTestBF, _
'                                          strTestGF,        strTestCF,          strTestEM, _
'                                          strTestTM,        strTestETC,         strTestRemark, _
'                                          strResultDiv,     strDisRemark,       strPolWithout, _
'                                          strPolFollowup,   strPolMonth,        strPolReExam, _
'                                          strPolDiag,       strPolEtc1,         strPolRemark1, _
'                                          strPolSugery,     strPolEndoscope,    strPolChemical, _
'                                          strPolRadiation,  strPolRefer,        strPolEtc2, _
'                                          strPolRemark2,    vntItemCd,          vntSuffix, _
'                                          vntResult,        lngNewSeq )

        Ret = objFollow.UpdateFollow_Rsl( lngRsvNo,         lngJudClassCd,      lngSeq, _
                                          strSecCslDate,    Session.Contents("userId"), _
                                          strTestUS,        strTestCT,_
                                          strTestMRI,       strTestBF, _
                                          strTestGF,        strTestCF,          strTestEM, _
                                          strTestTM,        strTestETC,         strTestRemark, _
                                          strTestRefer,     strTestReferText, _
                                          strResultDiv,     strDisRemark,       strPolWithout, _
                                          strPolFollowup,   strPolMonth,        strPolReExam, _
                                          strPolDiagSt,     strPolDiag,         strPolEtc1,         strPolRemark1, _
                                          strPolSugery,     strPolEndoscope,    strPolChemical, _
                                          strPolRadiation,  strPolReferSt,      strPolRefer,        strPolEtc2, _
                                          strPolRemark2,    vntItemCd,          vntSuffix, _
                                          vntResult,        lngNewSeq )

        If Ret Then
            strAction = "saveend"
            lngSeq = lngNewSeq
        Else
            strArrMessage = Array("フォローアップ結果情報登録に失敗しました。")
            Exit Do
        End If

    ElseIf strAction = "delete" Then

        Ret = objFollow.DeleteFollow_Rsl( lngRsvNo, lngJudClassCd, lngSeq, Session.Contents("userId"))

        If Ret Then
            strAction = "deleteend"
        Else
            strArrMessage = Array("フォローアップ結果情報削除に失敗しました。")
            Exit Do
        End If

    End If

'2009.11.26 張
'    objFollow.SelectFollow_Info lngRsvNo,           lngJudClassCd, _
'                                strJudClassName,    strJudCd,               strRslJudCd, _
'                                strSecEquipDiv,     strUpdDate,             strUpdUser, _
'                                strUpdUserName,     strStatusCd,            strSecEquipName, _
'                                strSecDoctor,       strSecEquipAddr,        strSecEquipTel, _
'                                strSecPlanDate,     strReqSendDate,         strReqSendUser, _
'                                strReqSendUserName, strReqCheckDate1,       strReqCheckDate2, _
'                                strReqCheckDate3,   strReqCancelDate,       strReqConfirmDate, _
'                                strReqConfirmUser,  strReqConfirmUserName,  strSecRemark

    objFollow.SelectFollow_Info lngRsvNo,           lngJudClassCd, _
                                strJudClassName,    strJudCd,               strRslJudCd, _
                                strSecEquipDiv,     strUpdDate,             strUpdUser, _
                                strUpdUserName,     strStatusCd,            strSecEquipName,        strSecEquipCourse, _
                                strSecDoctor,       strSecEquipAddr,        strSecEquipTel, _
                                strSecPlanDate,     strReqSendDate,         strReqSendUser, _
                                strReqSendUserName, strReqCheckDate1,       strReqCheckDate2, _
                                strReqCheckDate3,   strReqCancelDate,       strReqConfirmDate, _
                                strReqConfirmUser,  strReqConfirmUserName,  strSecRemark, _
                                strRsvTestName

    Select Case strSecEquipDiv
       Case 0
            strSecEquipDivName = "二次検査場所未定"
       Case 1
            strSecEquipDivName = "当センター"
       Case 2
            '### 2016.09.13 張 本院→本院・メディローカスに変更 ###
            'strSecEquipDivName = "本院"
            strSecEquipDivName = "本院・メディローカス"
       Case 3
            strSecEquipDivName = "他院"
    End Select

    If strSecPlanDate <> "" Then
        strSecPlanYear   = Year(strSecPlanDate)
        strSecPlanMonth  = Month(strSecPlanDate)
        strSecPlanDay    = Day(strSecPlanDate)
    End If

'    If strAction = "saveend" Then
'        response.write "lngSeq               --> " & lngSeq               & "<br>"
'        response.end
'    End If

'2009.11.26 張
'    blnFollowRsl = objFollow.SelectFollow_Rsl(lngRsvNo,            lngJudClassCd,      lngSeq, _
'                                              strSecCslDate,       strTestUpdDate,     strTestUpdUser, _
'                                              strTestUpdUserName,  strTestUS,          strTestCT, _
'                                              strTestMRI,          strTestBF,          strTestGF, _
'                                              strTestCF,           strTestEM,          strTestTM, _
'                                              strTestEtc,          strTestRemark,      strResultDiv, _
'                                              strDisRemark,        strPolWithout,      strPolFollowup, _
'                                              strPolMonth,         strPolReExam,       strPolDiag, _
'                                              strPolEtc1,          strPolRemark1,      strPolSugery, _
'                                              strPolEndoscope,     strPolChemical,     strPolRadiation, _
'                                              strPolRefer,         strPolEtc2,         strPolRemark2)

    blnFollowRsl = objFollow.SelectFollow_Rsl(lngRsvNo,            lngJudClassCd,      lngSeq, _
                                              strSecCslDate,       strTestUpdDate,     strTestUpdUser, _
                                              strTestUpdUserName,  strTestUS,          strTestCT, _
                                              strTestMRI,          strTestBF,          strTestGF, _
                                              strTestCF,           strTestEM,          strTestTM, _
                                              strTestEtc,          strTestRemark, _     
                                              strTestRefer,        strTestReferText, _  
                                              strResultDiv, _
                                              strDisRemark,        strPolWithout,      strPolFollowup, _
                                              strPolMonth,         strPolReExam,       strPolDiagSt,        strPolDiag, _
                                              strPolEtc1,          strPolRemark1,      strPolSugery, _
                                              strPolEndoscope,     strPolChemical,     strPolRadiation, _
                                              strPolReferSt,       strPolRefer,        strPolEtc2,          strPolRemark2)

    If strSecCslDate <> "" Then
        strSecCslYear   = Year(strSecCslDate)
        strSecCslMonth  = Month(strSecCslDate)
        strSecCslDay    = Day(strSecCslDate)
    End If
    '対象全部位（臓器）別診断名（疾患）を基に疾患情報を取得）
    lngAllCount = objFollow.SelectFollowRslItemList(lngRsvNo,            lngJudClassCd,      lngSeq, _
                                                    vntGrpName,          vntItemCd,          vntSuffix, _
                                                    vntItemName,         vntResult,          vntShortStc)



    Exit Do
Loop


'-------------------------------------------------------------------------------
'
' 機能　　 : フォローアップ結果各値の妥当性チェックを行う
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

        '二次検査実施日
        .AppendArray vntArrMessage, .CheckDate("二次検査実施日", strSecCslYear, strSecCslMonth, strSecCslDay, strSecCslDate)

        '経過観察期間
        .AppendArray vntArrMessage, .CheckNumeric("経過観察期間", strPolMonth, 2)

        'その他コメント（検査方法）
        strMessage = .CheckLength("その他コメント（検査方法）", strTestRemark, 200)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If

        'その他疾患
        strMessage = .CheckLength("その他疾患", strDisRemark, 200)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If

        'その他コメント（治療なし）
        strMessage = .CheckLength("その他コメント（治療なし）", strPolRemark1, 200)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If

        'その他コメント（治療あり）
        strMessage = .CheckLength("その他コメント（治療あり）", strPolRemark2, 200)
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
<TITLE>二次検診結果登録</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<%
    '### 保存処理、削除処理後親画面も最新情報で表示し、自分の画面を閉じる
    If strAction = "saveend" Or strAction = "deleteend" Then
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
<!-- #include virtual = "/webHains/includes/stcGuide.inc"    -->
<!--
    var lngSelectedIndex1;  // ガイド表示時に選択されたエレメントのインデックス

    // 文章ガイド呼び出し
    function callStcGuide( index ) {

        var myForm = document.entryForm;

        // 選択されたエレメントのインデックスを退避(文章コード・略文章のセット用関数にて使用する)
        lngSelectedIndex1 = index;

        if ( myForm.arrItemcd.length != null ) {
            stcGuide_ItemCd = myForm.arrItemcd[ index ].value;
        } else {
            stcGuide_ItemCd = myForm.arrItemcd.value;
        }

        // ガイド画面の連絡域に項目タイプ（標準）を設定する
        stcGuide_ItemType = '0';

        // ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
        stcGuide_CalledFunction = setStcInfo;

        // 文章ガイド表示
        showGuideStc();
    }

    // 文章コード・略文章のセット
    function setStcInfo() {
        setStc( lngSelectedIndex1, stcGuide_StcCd, stcGuide_ShortStc );
    }

    // 結果疾患（文章）の編集
    function setStc( index, stcCd, shortStc ) {

        var myForm = document.entryForm;    // 自画面のフォームエレメント

        // 値の編集
        if ( myForm.arrItemcd.length != null ) {
            myForm.arrResult[ index ].value = stcCd;
            myForm.arrLongStc[ index ].value = shortStc;
        } else {
            myForm.arrResult.value = stcCd;
            myForm.arrLongStc.value = shortStc;
        }

        if ( document.getElementById('sentence' + index) ) {
            document.getElementById('sentence' + index).innerHTML = shortStc;
        }

    }


    // 結果疾患（文章）のクリア
    function callStcClr( index ) {

        var myForm = document.entryForm;    // 自画面のフォームエレメント

        // 値の編集
        if ( myForm.arrItemcd.length != null ) {
            myForm.arrResult[ index ].value = '';
            myForm.arrLongStc[ index ].value = '';
        } else {
            myForm.arrResult.value = '';
            myForm.arrLongStc.value = '';
        }

        if ( document.getElementById('sentence' + index) ) {
            document.getElementById('sentence' + index).innerHTML = '';
        }

    }




    /** 判定分類別フォローアップ情報保存 **/
    function saveData() {

        var myForm = document.entryForm;    // 自画面のフォームエレメント

        if ( !confirm( 'フォローアップ情報を変更します。よろしいですか？' ) ) {
            return;
        }

        with ( myForm ) {
            if (secCslYear.value == "" || secCslMonth.value == "" || secCslDay.value == ""){
                alert("『二次検査実施日』は必須項目ですので正しく入力してください。");
                return false;
            }
            act.value = 'save';
            submit();
        }

        //親画面が閉じられていなかった場合、親画面リフレッシュ
//        if (!opener.closed) {
//            opener.replaceForm();
//        }

//        close();

        return false;

    }

    /** 判定分類別フォローアップ情報削除 **/
    function deleteData() {

        var myForm = document.entryForm;    // 自画面のフォームエレメント

        if ( !confirm( 'フォローアップ情報を削除します。よろしいですか？' ) ) {
            return;
        }

        // モードを指定してsubmit
        with ( myForm ) {
            act.value = 'delete';
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

            if(testETC.checked) {
                testRemark.disabled = false;
            } else {
                testRemark.disabled = true;
            }

            if(polFollowup.checked) {
                polMonth.disabled = false;
            } else {
                polMonth.disabled = true;
            }

            if(polETC1.checked) {
                polRemark1.disabled = false;
            } else {
                polRemark1.disabled = true;
            }

            if(polETC2.checked) {
                polRemark2.disabled = false;
            } else {
                polRemark2.disabled = true;
            }

        }
    }

//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY BGCOLOR="#ffffff"  ONLOAD="onLoad();">

<!-- #include virtual = "/webHains/includes/followupHeader.inc" -->
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
    <TR>
        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">フォローアップ結果登録</FONT></B></TD>
    </TR>
</TABLE>
<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
    <TR>
        <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
    </TR>
</TABLE>
<%
    '受診者個人情報表示
    Call followupHeader(lngRsvNo)
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden"    NAME="mode"         VALUE="<%= strMode %>"      >
    <INPUT TYPE="hidden"    NAME="act"          VALUE=""                    >
    <INPUT TYPE="hidden"    NAME="target"       VALUE="<%= strTarget %>"    >
    <INPUT TYPE="hidden"    NAME="rsvno"        VALUE="<%= lngRsvNo %>"     >
    <INPUT TYPE="hidden"    NAME="judClassCd"   VALUE="<%= lngJudClassCd %>">
    <INPUT TYPE="hidden"    NAME="seq"          VALUE="<%= lngSeq %>"       >

<%
    'メッセージの編集
    If strAction <> "" Then

        Select Case strAction

            '保存完了時は「保存完了」の通知
            Case "saveend"
                Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

            '削除完了時は「削除完了」の通知
            Case "deleteend"
                Call EditMessage("削除完了しました。", MESSAGETYPE_NORMAL)

            'さもなくばエラーメッセージを編集
            Case Else
                Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

        End Select

End If
%>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
        <TR ALIGN="left">
            <TD width="*">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
                    <TR align="left">
                        <TD NOWRAP BGCOLOR="#cccccc" width="120" HEIGHT="22">&nbsp;健診項目</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee" width="160" ><B>&nbsp;<%= strJudClassName %></B></TD>
                        <TD>&nbsp;</TD>
                        <TD NOWRAP BGCOLOR="#cccccc" width="120">&nbsp;判定</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee" width="160"><B>&nbsp;<%= strJudCd %>&nbsp;(&nbsp;最終判定&nbsp;：&nbsp;<%= strRslJudCd %>&nbsp;)</B></TD>
                        <TD></TD>
                        <TD></TD>
                        <TD></TD>
                    </TR>
                    <TR align="left">
                        <TD NOWRAP BGCOLOR="#cccccc" width="120" HEIGHT="22">&nbsp;二次検査施設</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee" width="160"><B>&nbsp;<%= strSecEquipDivName %></B></TD>
                        <TD>&nbsp;</TD>
                        <TD NOWRAP BGCOLOR="#cccccc" width="120">&nbsp;二次検査予定日</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee" width="160"><B>&nbsp;<%= strSecPlanDate %></B></TD>
                        <TD>&nbsp;</TD>
                        <TD NOWRAP BGCOLOR="#cccccc" width="120">&nbsp;二次検査予定項目</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee" width="180"><B>&nbsp;<%= strRsvTestName %></B></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <BR>
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
            <TD WIDTH="200">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" WIDTH="100%">
                    <TR>
                        <TD NOWRAP HEIGHT="15">
                            <IMG SRC="../../images/spacer.gif" WIDTH="10">
                            <A HREF="javascript:function voi(){};voi()" ONCLICK="return saveData()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="二次検査結果保存"></A>
                        <% If blnFollowRsl Then %>
                            <A HREF="javascript:function voi(){};voi()" ONCLICK="return deleteData()"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="二次検査結果削除"></A>
                        <% End If %>
                        </TD>
                    </TR>
                </TABLE>
            </TD>
            <% End If %>
        </TR>
    <TABLE>

    
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
        <TR>
            <TD WIDTH="100%">
                <TABLE>
                <TR>
                    <TD WIDTH="120" HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;検査（治療）実施日&nbsp;</TD>
                    <TD>
                        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                            <TR>
                                <TD NOWRAP ID="gdeDate"><A HREF="javascript:calGuide_showGuideCalendar('secCslYear', 'secCslMonth', 'secCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示します"></A></TD>
                                <TD NOWRAP><A HREF="javascript:calGuide_clearDate('secCslYear', 'secCslMonth', 'secCslDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
                                <TD>
                                    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
                                        <TR>
                                            <TD><%= EditNumberList("secCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSecCslYear, True) %></TD>
                                            <TD>年</TD>
                                            <TD><%= EditNumberList("secCslMonth", 1, 12, strSecCslMonth, True) %></TD>
                                            <TD>月</TD>
                                            <TD><%= EditNumberList("secCslDay", 1, 31, strSecCslDay, True) %></TD>
                                            <TD>日</TD>
                                        </TR>
                                    </TABLE>
                                </TD>
                                <TD><IMG SRC="../../images/spacer.gif" WIDTH="10"><FONT COLOR="RED">※必須項目</FONT></TD>
                            </TR>
                        </TABLE>
                    </TD>
                </TR>
                <TR>
                    <TD NOWRAP BGCOLOR="#cccccc">&nbsp;二次検査項目</TD>
                    <TD NOWRAP>
                        <INPUT TYPE="checkbox" NAME="testUS"     VALUE="1" <%= IIf( strTestUS = "1", "CHECKED", "") %>>US&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="testCT"     VALUE="1" <%= IIf( strTestCT = "1", "CHECKED", "") %>>CT&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="testMRI"    VALUE="1" <%= IIf( strTestMRI = "1", "CHECKED", "") %>>MRI&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="testBF"     VALUE="1" <%= IIf( strTestBF = "1", "CHECKED", "") %>>BF&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="testGF"     VALUE="1" <%= IIf( strTestGF = "1", "CHECKED", "") %>>GF&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="testCF"     VALUE="1" <%= IIf( strTestCF = "1", "CHECKED", "") %>>CF&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="testEM"     VALUE="1" <%= IIf( strTestEM = "1", "CHECKED", "") %>>注腸&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="testTM"     VALUE="1" <%= IIf( strTestTM = "1", "CHECKED", "") %>>腫瘍マーカー&nbsp;&nbsp;
                        
                        <INPUT TYPE="checkbox" NAME="testRefer"  VALUE="1" <%= IIf( strTestRefer = "1", "CHECKED", "") %> ONCLICK="chkWrite(this,testReferText);">リファー&nbsp;
                        <INPUT TYPE="text" NAME="testReferText" SIZE="10" MAXLENGTH="40" VALUE="<%= strTestReferText %>" STYLE="ime-mode:active;">
                        
                        <INPUT TYPE="checkbox" NAME="testETC"    VALUE="1" <%= IIf( strTestETC = "1", "CHECKED", "") %> ONCLICK="chkWrite(this, testRemark);">その他&nbsp;
                        <INPUT TYPE="text" NAME="testRemark" SIZE="30" MAXLENGTH="45" VALUE="<%= strTestRemark %>" STYLE="ime-mode:active;">
                    </TD>
                </TR>
                <TR>
                    <TD WIDTH="120" HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;二次検査結果</TD>
                    <TD NOWRAP>
                        <INPUT TYPE="radio" NAME="resultDiv" VALUE="1" BORDER="0" <%= IIf(strResultDiv = "1", " CHECKED", "") %>>異常なし&nbsp;&nbsp;
                        <INPUT TYPE="radio" NAME="resultDiv" VALUE="2" BORDER="0" <%= IIf(strResultDiv = "2", " CHECKED", "") %>>不明&nbsp;&nbsp;
                        <INPUT TYPE="radio" NAME="resultDiv" VALUE="3" BORDER="0" <%= IIf(strResultDiv = "3", " CHECKED", "") %>>診断名あり：下記の診断名より選択
                    </TD>
                </TR>
                <TR>
                    <TD WIDTH="120" HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;診断名</TD>
                    <TD>
                        <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="100%">
                            <TR ALIGN="center" BGCOLOR="#cccccc">
                                <TD NOWRAP WIDTH="130">分類</TD>
                                <TD NOWRAP WIDTH="160">臓器（部位）</TD>
                                <TD NOWRAP COLSPAN="3" WIDTH="100%">診断名</TD>
                            </TR>


<%
        lngCount = UBound(vntItemCd)
        
        If lngCount > 0 Then
            strBeforeGrpName = ""

            For i = 0 To lngCount
                strWebGrpName = ""
                If strBeforeGrpName <> vntGrpName(i) Then
                    strWebGrpName = vntGrpName(i)
                End If
%>
                            <TR BGCOLOR="#ffffff">
                                <TD NOWRAP ALIGN="left">&nbsp;<%= strWebGrpName %></TD>
                                <TD NOWRAP ALIGN="left"><SPAN ID="itemname<%=i%>">&nbsp;<%= vntItemName(i) %></SPAN></TD>
                                <TD NOWRAP><A HREF="JavaScript:callStcGuide(<%=i%>)"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="所見選択ガイドを表示します"></A></TD>
                                <TD NOWRAP><A HREF="JavaScript:callStcClr(<%=i%>)"><IMG SRC="../../images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="所見を削除します"></A></TD>
                                <TD NOWRAP ALIGN="left" WIDTH="100%"><SPAN ID="sentence<%=i%>"><%= vntShortStc(i) %></SPAN></TD>
                                <INPUT TYPE="hidden" NAME="arrGrpName"  VALUE="<%= vntGrpName(i) %>">
                                <INPUT TYPE="hidden" NAME="arrItemName" VALUE="<%= vntItemName(i) %>">
                                <INPUT TYPE="hidden" NAME="arrItemcd"   VALUE="<%= vntItemCd(i) %>">
                                <INPUT TYPE="hidden" NAME="arrSuffix"   VALUE="<%= vntSuffix(i) %>">
                                <INPUT TYPE="hidden" NAME="arrResult"   VALUE="<%= vntResult(i) %>">
                                <INPUT TYPE="hidden" NAME="arrLongStc"  VALUE="<%= vntShortStc(i) %>">
                            </TR>
<%
                strBeforeGrpName = vntGrpName(i)
            Next
        End If
%>
                        </TABLE>
                    </TD>
                </TR>

                <TR>
                    <TD NOWRAP BGCOLOR="#cccccc">&nbsp;その他疾患</TD>
                    <TD COLSPAN="7"><TEXTAREA NAME="disRemark" style="ime-mode:active"  COLS="70" ROWS="4"><%= strDisRemark %></TEXTAREA></TD>
                </TR>
                <TR>
                    <TD NOWRAP BGCOLOR="#cccccc">&nbsp;方針（治療なし）</TD>
                    <TD NOWRAP>
                        <INPUT TYPE="checkbox" NAME="polWithout"    VALUE="1" <%= IIf( strPolWithout    = "1", "CHECKED", "") %>>処置不要&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="polFollowup"   VALUE="1" <%= IIf( strPolFollowup   = "1", "CHECKED", "") %> ONCLICK="chkWrite(this, polMonth);">経過観察&nbsp;(
                        <INPUT TYPE="text"     NAME="polMonth" STYLE="text-align:right" SIZE="3" MAXLENGTH="3" VALUE="<%= strPolMonth %>" STYLE="ime-mode:inactive;">&nbsp;)ヶ月&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="polReExam"     VALUE="1" <%= IIf( strPolReExam     = "1", "CHECKED", "") %>>1年後健診&nbsp;&nbsp;
                        <%'### 2016.09.13 張 本院→本院・メディローカスに変更 ###%>
                        <INPUT TYPE="checkbox" NAME="polDiagSt"     VALUE="1" <%= IIf( strPolDiagSt     = "1", "CHECKED", "") %>>本院・メディローカス紹介（精査）&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="polDiag"       VALUE="1" <%= IIf( strPolDiag       = "1", "CHECKED", "") %>>他院紹介（精査）&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="polETC1"       VALUE="1" <%= IIf( strPolETC1       = "1", "CHECKED", "") %> ONCLICK="chkWrite(this, polRemark1);">その他&nbsp;
                        <INPUT TYPE="text" NAME="polRemark1" SIZE="40" MAXLENGTH="50" VALUE="<%= strPolRemark1 %>" STYLE="ime-mode:active;">
                    </TD>
                </TR>

                <TR>
                    <TD NOWRAP BGCOLOR="#cccccc">&nbsp;方針（治療あり）</TD>
                    <TD NOWRAP>
                        <INPUT TYPE="checkbox" NAME="polSugery"     VALUE="1" <%= IIf( strPolSugery     = "1", "CHECKED", "") %>>外科治療&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="polEndoscope"  VALUE="1" <%= IIf( strPolEndoscope  = "1", "CHECKED", "") %>>内視鏡的治療&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="polChemical"   VALUE="1" <%= IIf( strPolChemical   = "1", "CHECKED", "") %>>化学療法&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="polRadiation"  VALUE="1" <%= IIf( strPolRadiation  = "1", "CHECKED", "") %>>放射線治療&nbsp;&nbsp;
                        <%'### 2016.09.13 張 本院→本院・メディローカスに変更 ###%>
                        <INPUT TYPE="checkbox" NAME="polReferSt"    VALUE="1" <%= IIf( strPolReferSt    = "1", "CHECKED", "") %>>本院・メディローカス紹介&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="polRefer"      VALUE="1" <%= IIf( strPolRefer      = "1", "CHECKED", "") %>>他院紹介&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="polETC2"       VALUE="1" <%= IIf( strPolETC2       = "1", "CHECKED", "") %> ONCLICK="chkWrite(this, polRemark2);">その他&nbsp;
                        <INPUT TYPE="text" NAME="polRemark2" SIZE="40" MAXLENGTH="50" VALUE="<%= strPolRemark2 %>" STYLE="ime-mode:active;">
                    </TD>
                </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>


</FORM>
</BODY>
</HTML>
