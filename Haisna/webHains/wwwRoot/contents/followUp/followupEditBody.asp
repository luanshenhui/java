<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      フォローアップ（二次検診／リファー予約情報画面） (Ver0.0.1)
'      AUTHER  : T.Yaguchi@orbsys.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/InterviewEditDropDown.inc" -->
<!-- #include virtual = "/webHains/includes/EditJudClassList.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc"   -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const AUTOJUD_USER = "AUTOJUD"      '自動判定ユーザ

'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objHainsUser        'ユーザー情報アクセス用
Dim objInterview        '面接情報アクセス用
Dim objJud              '判定情報アクセス用
Dim objJudgement        '判定結果アクセス用
Dim objFollowUp         'フォローアップアクセス用
Dim objSentence         '文章情報アクセス用

Dim strUpdMode          '保存モード(INS,UPD)
Dim strAct              '処理状態
Dim strCmtMode          '総合コメント処理モード
Dim strWinMode          'ウインドウ表示モード（1:別ウインドウ、0:同ウインドウ）
Dim strGrpCd            'グループコード

Dim lngRsvNo            '予約番号（今回分）
Dim strCsCd             'コースコード（今回分）

Dim lngStrYear          '受診日(自)(年)
Dim lngStrMonth         '受診日(自)(月)
Dim lngStrDay           '受診日(自)(日)

Dim blnUpdated          'TRUE:変更あり、FALSE:変更なし

Dim lngEditFlg          '修正有無

'受診情報取得用
Dim vntCslRsvNo         '予約番号
Dim vntCslCslDate       '受診日
Dim vntCslCsCd          'コースコード
Dim vntCslCsName        'コース名称
Dim vntCslCsSName       'コース名略称

'Dim strPerId           '個人ＩＤ
'Dim dtmCslDate         '受診日
Dim lngLastDspMode      '前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
Dim vntCsGrp            'コースコード または　コースグループコード

Dim strFollowUpFlg      'フォロー対象者フラグ
Dim strFollowCardFlg    'はがき出力フラグ
Dim strUpdDate          '更新日時
Dim strUpdUserName      '更新者名

Dim vntRsvNo            '予約番号
Dim vntJudClassCd       '判定分類コード
Dim vntJudClassName     '判定分類名称
Dim vntJudCd            '判定コード
Dim vntJudSName         '判定略称
Dim vntWeight           '判定重み
Dim vntWebColor         '表示色
Dim vntUpdUser          '更新者
Dim vntUpdFlg           '更新フラグ   
Dim vntResultDispMode   '検査結果表示モード
Dim vntJudCmtCd         '判定コメントコード
Dim vntJudCmtstc        '判定コメント文章
Dim vntSecCslDate       '二次検査受診日
Dim vntComeFlg          '来院フラグ
Dim vntRsvInfoCd        '予約情報コード
Dim vntJudCd2           '判定コード（フォロー）
Dim vntQuestionCd       'アンケートコード
Dim vntFolNote          'ノート
Dim vntDelFlg           '削除フラグ
Dim vntSecItemCd        '対象検査コード
Dim vntArrSecItemCd     '対象検査コード
Dim lngArrSecItemCd     '対象検査コード数

Dim lngJudClassCount    '判定分類件数
Dim lngLastJudClassCd   '前判定分類コード

Dim lngCount            '件数
Dim lngAllCount         '件数

Dim lngDspPoint         '表示位置

'判定結果編集用領域
Dim vntEditJudClassCd   '判定分類コード
Dim vntEditJudCd        '判定コード
Dim vntEditJudCmtCd     '判定コメントコード

'更新直前の項目情報
Dim vntUpdRsvNo         '予約番号
Dim vntUpdFollowUpFlg   'フォロー対象者フラグ
Dim vntUpdFollowCardFlg 'はがき出力フラグ
Dim vntUpdJudClassCd    '判定分類コード
Dim vntUpdJudClassName  '判定分類名称
Dim vntUpdJudCd         '判定コード
Dim vntUpdSecCslDate    '二次検査受診日
Dim vntUpdComeFlg       '来院フラグ
Dim vntUpdRsvInfoCd     '予約情報コード
Dim vntUpdJudCd2        '判定コード（フォロー）
Dim vntUpdQuestionCd    'アンケートコード
Dim vntUpdFolNote       'ノート
Dim vntUpdSecItemCd     '対象検査コード
Dim vntUpdArrSecItemCd  '対象検査コード
Dim lngUpdArrSecItemCd  '対象検査コード数
Dim lngUpdCount         '更新項目数

'削除するの項目情報
Dim vntDelRsvNo             '予約番号
Dim vntDelJudClassCd()      '判定分類コード
Dim vntDelSecItemCd()       '対象検査コード
Dim vntDelArrSecItemCd()    '対象検査コード
Dim lngDelArrSecItemCd      '対象検査コード数
Dim lngDelCount             '削除項目数
Dim blnDelSecItemCd         '対象検査コード削除フラグ

'前回歴コースコンボボックス
Dim strArrLastCsGrp()       'コースグループコード
Dim strArrLastCsGrpName()   'コースグループ名称

'判定コンボボックス
Dim strArrJudCdSeq      '判定連番
Dim strArrJudCd         '判定コード
Dim strArrWeight        '判定用重み
Dim lngJudListCnt       '判定件数

Dim strStcCd            '文章コード
Dim strShortStc         '略称

Dim i               'ループカウンタ
Dim j               'ループカウンタ
Dim k               'ループカウンタ
Dim l               'ループカウンタ
Dim Ret             '復帰値

Dim strArrMessage   'エラーメッセージ
Dim lngPageKey      '検索条件
Dim lngJudClKey     '検索条件

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")
Set objJud          = Server.CreateObject("HainsJud.Jud")
Set objJudgement    = Server.CreateObject("HainsJudgement.Judgement")
Set objFollowUp     = Server.CreateObject("HainsFollowUp.FollowUp")
Set objSentence     = Server.CreateObject("HainsSentence.Sentence")

'引数値の取得
strUpdMode      = Request("updMode")
strAct          = Request("action")
strCmtMode      = Request("cmtmode")

lngRsvNo        = Request("rsvno")
strCsCd         = Request("cscd")
strWinMode      = Request("winmode")
strGrpCd        = Request("grpcd")

strSelCsGrp     = Request("csgrp")
strSelCsGrp     = IIf( strSelCsGrp="", "0", strSelCsGrp)

Select Case strSelCsGrp
    'すべてのコース
    Case "0"
        lngLastDspMode = 0
        vntCsGrp = ""
    '同一コース
    Case "1"
        lngLastDspMode = 1
        vntCsGrp = strCsCd
    Case Else
        lngLastDspMode = 2
        vntCsGrp = strSelCsGrp
End Select

'初期表示時の判定
strFollowUpFlg      = IIF(Request("followUpFlg")="", 0, Request("followUpFlg"))
strFollowCardFlg    = IIF(Request("followCardFlg")="", 0, Request("followCardFlg"))
vntJudClassCd       = ConvIStringToArray(Request("judClassCd"))
vntJudClassName     = ConvIStringToArray(Request("judClassName"))
vntJudCd            = ConvIStringToArray(Request("judCd"))
vntSecCslDate       = ConvIStringToArray(Request("secCslDate"))
vntComeFlg          = ConvIStringToArray(Request("comeFlg"))
vntSecItemCd        = ConvIStringToArray(Request("secItemCd"))
vntRsvInfoCd        = ConvIStringToArray(Request("rsvInfoCd"))
vntJudCd2           = ConvIStringToArray(Request("judCd2"))
vntQuestionCd       = ConvIStringToArray(Request("questionCd"))
vntFolNote          = ConvIStringToArray(Request("folNote"))
vntDelFlg           = ConvIStringToArray(Request("delFlg"))
lngCount            = CLng(Request("orgCount"))
lngPageKey          = Request("pageKey")
lngJudClKey         = Request("judClKey")

'判定取得
Call EditJudListInfo

Do
    
    '保存
    If strAct = "save"  Then
        
        'フォローの保存
        If strArrMessage = ""  Then
            lngDelCount = 0
'           If strUpdMode = "UPD" Then
'               '一度保存している場合は直前のフォロー状況管理を抽出する。
'               lngCount = objFollowUp.SelectFollow_I(lngRsvNo,           vntUpdJudCd,        _
'                                                 vntUpdJudClassCd,   vntUpdJudClassName, _
'                                                 vntUpdSecCslDate,   vntUpdComeFlg,      _
'                                                 vntUpdRsvInfoCd,    vntUpdJudCd2,       _
'                                                 vntUpdQuestionCd,   vntUpdFolNote,      _
'                                     vntUpdSecItemCd _
'                                                )
'               '削除するべき対象検査コードを抽出する。
'               '画面上の項目と直前に読込んだ項目で比較する。
'               i = 0
'               Do Until i > lngCount - 1
'                   '対象検査コードが存在する場合のみ処理する
'                   IF vntUpdSecItemCd(i) <> "" Then
'                       vntUpdArrSecItemCd = Split(vntUpdSecItemCd(i),"Z")
'                       lngUpdArrSecItemCd = Ubound(vntUpdArrSecItemCd)
'                       lngArrSecItemCd = -1
'                       j = 0
'                       Do Until j > Ubound(vntJudClassCd)
'                           If vntUpdJudClassCd(i) = vntJudClassCd(j) Then
'                               IF vntSecItemCd(j) <> "" Then
'                                   vntArrSecItemCd = Split(vntSecItemCd(j),"Z")
'                                   lngArrSecItemCd = Ubound(vntArrSecItemCd)
'                               End If
'                               Exit Do
'                           End If
'                           j = j + 1
'                       Loop
'                       lngDelArrSecItemCd = 0
'                       k = 0
'                       Do Until k > lngUpdArrSecItemCd
'                           blnDelSecItemCd = True
'                           l = 0
'                           Do Until l > lngArrSecItemCd
'                               If vntUpdArrSecItemCd(k) = vntArrSecItemCd(l) Then
'                                   blnDelSecItemCd = False
'                                   Exit Do
'                               End If
'                               l = l + 1
'                           Loop
'                           '直前の項目が画面上の項目に存在しない場合は削除する。
'                           If blnDelSecItemCd = True Then
'                               Redim Preserve vntDelArrSecItemCd(lngDelArrSecItemCd)
'                               vntDelArrSecItemCd(lngDelArrSecItemCd) = vntUpdArrSecItemCd(k)
'                               lngDelArrSecItemCd = lngDelArrSecItemCd + 1
'                           End If
'                           k = k + 1
'                       Loop
'                       '削除項目が１件以上ある場合は追加。
'                       If lngDelArrSecItemCd > 0 Then
'                           Redim Preserve vntDelJudClassCd(lngDelCount)
'                           Redim Preserve vntDelSecItemCd(lngDelCount)
'                           vntDelJudClassCd(lngDelCount) = vntUpdJudClassCd(i)
'                           vntDelSecItemCd(lngDelCount) = Join(vntDelArrSecItemCd, ",")
'                           lngDelCount = lngDelCount + 1
'                       End If
'                   End If
'                   i = i + 1
'               Loop
'           End If
'
'           '更新対象データが存在するときのみ判定結果保存
'           If ( lngUpdCount > 0 ) Then
                Ret = objFollowUp.SaveFollow(lngRsvNo, strFollowUpFlg, strFollowCardFlg, _
                                     vntJudClassCd, vntSecCslDate, vntComeFlg, _
                                     vntRsvInfoCd, vntJudCd2, vntQuestionCd, _
                                     vntFolNote, vntSecItemCd, vntDelFlg, _
                                     Session.Contents("userId"))
                If Ret = True Then
                    strAct = "saveend"
                Else
                    strArrMessage = "保存に失敗しました"
                End If
'           Else
'               strAct = ""
'           End If
        End If
    End If

    '検索条件に従い受診情報一覧を抽出する
    lngCount = objInterview.SelectConsultHistory( _
                                lngRsvNo, _
                                 , _
                                lngLastDspMode, _
                                vntCsGrp, _
                                3, _
                                 ,  , _
                                vntCslRsvNo, _
                                vntCslCslDate, _
                                vntCslCsCd, _
                                vntCslCsName, _
                                vntCslCsSName _
                                )

    If lngCount <= 0 Then
        Err.Raise 1000, , "受診情報がありません。RsvNo= " & lngRsvNo
    End If

    '今回コースコード退避
    strCsCd = vntCslCsCd(0)

    'フォロー対象者管理情報を読込む
    Ret = objFollowUp.SelectFollow(lngRsvNo, strFollowUpFlg, strFollowCardFlg, strUpdDate, , strUpdUserName)
    If Ret = True Then
        strUpdMode = "UPD"
        '一度保存している場合はフォロー状況管理から抽出する。
'        lngCount = objFollowUp.SelectFollow_I(lngRsvNo,        vntJudCd,        _
'                                          vntJudClassCd,   vntJudClassName, _
'                                          vntSecCslDate,   vntComeFlg,      _
'                                          vntRsvInfoCd,    vntJudCd2,       _
'                                          vntQuestionCd,   vntFolNote,      _
'                              vntSecItemCd _
'                                         )

        lngCount = objFollowUp.SelectJudClFollow_I(lngRsvNo,    lngJudClKey,    vntJudCd,        _
                                          vntJudClassCd,   vntJudClassName, _
                                          vntSecCslDate,   vntComeFlg,      _
                                          vntRsvInfoCd,    vntJudCd2,       _
                                          vntQuestionCd,   vntFolNote,      _
                              vntSecItemCd _
                                         )

        If lngPageKey = 1 Then
            lngAllCount = lngCount
            '検索条件に従い判定結果一覧を抽出する
'            lngCount = objFollowUp.SelectJudHistoryRslList( _
'                                                        lngRsvNo, _
'                                                         , _
'                                                         , _
'                                                        vntUpdRsvNo, _
'                                                        vntUpdJudClassCd, _
'                                                        vntUpdJudClassName, _
'                                                        vntUpdJudCd, _
'                                                        , _
'                                                        , _
'                                                        , _
'                                                        , , _
'                                                        , _
'                                                        , _
'                                                        vntUpdSecCslDate, _
'                                                        vntUpdComeFlg, _
'                                                        vntUpdRsvInfoCd, _
'                                                        vntUpdJudCd2, _
'                                                        vntUpdQuestionCd, _
'                                                        vntUpdFolNote, _
'                                                        vntUpdSecItemCd _
'                                                        )

            lngCount = objFollowUp.SelectJudRslList( _
                                                        lngRsvNo, _
                                                        lngJudClKey, _
                                                         , _
                                                         , _
                                                        vntUpdRsvNo, _
                                                        vntUpdJudClassCd, _
                                                        vntUpdJudClassName, _
                                                        vntUpdJudCd, _
                                                        , _
                                                        , _
                                                        , _
                                                        , , _
                                                        , _
                                                        , _
                                                        vntUpdSecCslDate, _
                                                        vntUpdComeFlg, _
                                                        vntUpdRsvInfoCd, _
                                                        vntUpdJudCd2, _
                                                        vntUpdQuestionCd, _
                                                        vntUpdFolNote, _
                                                        vntUpdSecItemCd _
                                                        )

            i = 0
            Do Until i > lngCount - 1
                Ret = False
                j = 0
                Do Until j > lngAllCount - 1
'                   If vntUpdRsvNo(i) = vntRsvNo(j) And _
'                      vntUpdJudClassCd(i) = vntJudClassCd(j) Then
                    If vntUpdJudClassCd(i) = vntJudClassCd(j) Then

                        Ret = True
                        Exit Do
                    End If
                    j = j + 1
                Loop
                ''判定分類の重いものをフォロー状況管理にない場合は追加する。
                If Ret = False Then
                    'フォロー状況管理が１件もない場合は空になっている為配列型にする
                    If lngAllCount <= 0 Then
                        vntJudCd = Array()
                                vntJudClassCd = Array()
                        vntJudClassName = Array()
                        vntSecCslDate = Array()
                        vntComeFlg = Array()
                        vntRsvInfoCd = Array()
                        vntJudCd2 = Array()
                        vntQuestionCd = Array()
                        vntFolNote = Array()
                        vntSecItemCd = Array()
                    End If
                    Redim Preserve vntJudCd(lngAllCount)
                            Redim Preserve vntJudClassCd(lngAllCount)
                    Redim Preserve vntJudClassName(lngAllCount)
                    Redim Preserve vntSecCslDate(lngAllCount)
                    Redim Preserve vntComeFlg(lngAllCount)
                    Redim Preserve vntRsvInfoCd(lngAllCount)
                    Redim Preserve vntJudCd2(lngAllCount)
                    Redim Preserve vntQuestionCd(lngAllCount)
                    Redim Preserve vntFolNote(lngAllCount)
                    Redim Preserve vntSecItemCd(lngAllCount)

                    vntJudCd(lngAllCount) = vntUpdJudCd(i)
                            vntJudClassCd(lngAllCount) = vntUpdJudClassCd(i)
                    vntJudClassName(lngAllCount) = vntUpdJudClassName(i)
                    vntSecCslDate(lngAllCount) = vntUpdSecCslDate(i)
                    vntComeFlg(lngAllCount) = vntUpdComeFlg(i)
                    vntRsvInfoCd(lngAllCount) = vntUpdRsvInfoCd(i)
                    vntJudCd2(lngAllCount) = vntUpdJudCd2(i)
                    vntQuestionCd(lngAllCount) = vntUpdQuestionCd(i)
                    vntFolNote(lngAllCount) = vntUpdFolNote(i)
                    vntSecItemCd(lngAllCount) = vntSecItemCd(i)
                    lngAllCount = lngAllCount + 1
                End If
                i = i + 1
            Loop
            lngCount = lngAllCount
        End If

    Else
    '一度も保存していない場合は判定結果から判定の重いものを抽出する。
        strUpdMode = "INS"
        '検索条件に従い判定結果一覧を抽出する
'        lngCount = objFollowUp.SelectJudHistoryRslList( _
'                                                    lngRsvNo, _
'                                                     , _
'                                                     , _
'                                                    vntRsvNo, _
'                                                    vntJudClassCd, _
'                                                    vntJudClassName, _
'                                                    vntJudCd, _
'                                                    vntJudSName, _
'                                                    vntWeight, _
'                                                    vntUpdUser, _
'                                                    vntJudCmtCd, , _
'                                                    vntResultDispMode, _
'                                                    vntUpdFlg, _
'                                                    vntSecCslDate, _
'                                                    vntComeFlg, _
'                                                    vntRsvInfoCd, _
'                                                    vntJudCd2, _
'                                                    vntQuestionCd, _
'                                                    vntFolNote, _
'                                                    vntSecItemCd _
'                                                    )

        lngCount = objFollowUp.SelectJudRslList( _
                                                    lngRsvNo, _
                                                    lngJudClKey, _
                                                     , _
                                                     , _
                                                    vntRsvNo, _
                                                    vntJudClassCd, _
                                                    vntJudClassName, _
                                                    vntJudCd, _
                                                    vntJudSName, _
                                                    vntWeight, _
                                                    vntUpdUser, _
                                                    vntJudCmtCd, , _
                                                    vntResultDispMode, _
                                                    vntUpdFlg, _
                                                    vntSecCslDate, _
                                                    vntComeFlg, _
                                                    vntRsvInfoCd, _
                                                    vntJudCd2, _
                                                    vntQuestionCd, _
                                                    vntFolNote, _
                                                    vntSecItemCd _
                                                    )
    End If
'   If lngCount <= 0 Then
'       Err.Raise 1000, , "判定結果がありません。RsvNo= " & lngRsvNo
'   End If
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
    lngJudListCnt = objJud.SelectJudList( _
                                        strArrJudCd, _
                                         , , strArrWeight	)

    strArrJudCdSeq = Array()
    Redim Preserve strArrJudCdSeq(lngJudListCnt-1)
    For i = 0 To lngJudListCnt-1
        strArrJudCdSeq(i) = i
    Next


End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>二次検診／リファー予約情報</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc"    -->
<!-- #include virtual = "/webHains/includes/folGuide.inc"    -->
<!--
var lngSelectedIndex1;  // ガイド表示時に選択されたエレメントのインデックス
var winRslFol;
// フォローガイド呼び出し
function callFolGuide( index ) {

    var myForm = document.resultList;

    // 選択されたエレメントのインデックスを退避(文章コード・略文章のセット用関数にて使用する)
    lngSelectedIndex1 = index;

    // ガイド画面の連絡域に判定分類コードを設定する
    if ( myForm.judClassCd.length != null ) {
        folGuide_JudClassCd = myForm.judClassCd[ index ].value;
    } else {
        folGuide_JudClassCd = myForm.judClassCd.value;
    }

    // ガイド画面の連絡域に健診項目を設定する
    if ( myForm.judClassName.length != null ) {
        folGuide_JudClassName = myForm.judClassName[ index ].value;
    } else {
        folGuide_JudClassName = myForm.judClassName.value;
    }

    // ガイド画面の連絡域に判定（標準）を設定する
    if ( myForm.judCd.length != null ) {
        folGuide_JudCd = myForm.judCd[ index ].value;
    } else {
        folGuide_JudCd = myForm.judCd.value;
    }

    // ガイド画面の連絡域に二次検査日（標準）を設定する
    if ( myForm.secCslDate.length != null ) {
        folGuide_SecCslDate = myForm.secCslDate[ index ].value;
    } else {
        folGuide_SecCslDate = myForm.secCslDate.value;
    }

    // ガイド画面の連絡域に状況（標準）を設定する
    if ( myForm.comeFlg.length != null ) {
        folGuide_ComeFlg = myForm.comeFlg[ index ].value;
    } else {
        folGuide_ComeFlg = myForm.comeFlg.value;
    }

    // ガイド画面の連絡域に検査項目（標準）を設定する
    if ( myForm.secItemCd.length != null ) {
        folGuide_SecItemCd = myForm.secItemCd[ index ].value;
    } else {
        folGuide_SecItemCd = myForm.secItemCd.value;
    }

    // ガイド画面の連絡域に予約情報（標準）を設定する
    if ( myForm.rsvInfoCd.length != null ) {
        folGuide_RsvInfoCd = myForm.rsvInfoCd[ index ].value;
    } else {
        folGuide_RsvInfoCd = myForm.rsvInfoCd.value;
    }

    // ガイド画面の連絡域に結果（標準）を設定する
    if ( myForm.judCd2.length != null ) {
        folGuide_JudCd2 = myForm.judCd2[ index ].value;
    } else {
        folGuide_JudCd2 = myForm.judCd2.value;
    }

    // ガイド画面の連絡域にアンケート（標準）を設定する
    if ( myForm.questionCd.length != null ) {
        folGuide_QuestionCd = myForm.questionCd[ index ].value;
    } else {
        folGuide_QuestionCd = myForm.questionCd.value;
    }

    // ガイド画面の連絡域に備考（標準）を設定する
    if ( myForm.folNote.length != null ) {
        folGuide_FolNote = myForm.folNote[ index ].value;
    } else {
        folGuide_FolNote = myForm.folNote.value;
    }

    // ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
    folGuide_CalledFunction = setFolInfo;

    // 文章ガイド表示
    showGuideFol();
}

// 文章コード・略文章のセット
function setFolInfo() {

    setFol( lngSelectedIndex1, folGuide_JudClassCd, folGuide_JudClassName, folGuide_JudCd, folGuide_SecCslDate, folGuide_ComeFlg, folGuide_SecItemCd, folGuide_RsvInfoCd, folGuide_JudCd2, folGuide_QuestionCd, folGuide_FolNote, folGuide_FolName1, folGuide_FolName2, folGuide_FolName3, folGuide_FolName4, folGuide_FolName5, folGuide_RsvInfoName, folGuide_QuestionName);

}

// 文章の編集
function setFol( index, judClassCd, judClassName, judCd, secCslDate, comeFlg, secItemCd, rsvInfoCd, judCd2, questionCd, folNote, folName1, folName2, folName3, folName4, folName5, rsvInfoName, questionName) {

    var myForm = document.resultList;   // 自画面のフォームエレメント
    var objSecCslDate, objComeFlg;      // 二次検査日・状況のエレメント
    var objSecItemCd, objRsvInfoCd;     // 検査項目・予約情報のエレメント
    var objJudCd2, objQuestionCd;       // 結果・アンケートのエレメント
    var objFolNote;                     // 備考のエレメント
    var folNameElement;                 // 検査項目名のエレメント
    var comeName;                       // 検査項目名のエレメント

    // 編集エレメントの設定
    if ( myForm.judClassName.length != null ) {
        objSecCslDate = myForm.secCslDate[ index ];
        objComeFlg = myForm.comeFlg[ index ];
        objSecItemCd = myForm.secItemCd[ index ];
        objRsvInfoCd = myForm.rsvInfoCd[ index ];
        objJudCd2 = myForm.judCd2[ index ];
        objQuestionCd = myForm.questionCd[ index ];
        objFolNote = myForm.folNote[ index ];
    } else {
        objSecCslDate = myForm.secCslDate;
        objComeFlg = myForm.comeFlg;
        objSecItemCd = myForm.secItemCd;
        objRsvInfoCd = myForm.rsvInfoCd;
        objJudCd2 = myForm.judCd2;
        objQuestionCd = myForm.questionCd;
        objFolNote = myForm.folNote;
    }

    // 値の編集
    objSecCslDate.value = secCslDate;
    objComeFlg.value = comeFlg;
    objSecItemCd.value = secItemCd;
    objRsvInfoCd.value = rsvInfoCd;
    objJudCd2.value = judCd2;
    objQuestionCd.value = questionCd;
    objFolNote.value = folNote;

    folNameElement = 'secCslDateName' + judClassCd;
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = secCslDate;
    }
    comeName = ''
    if ( comeFlg == '1' ) {
        comeName = '来院'
    }
    folNameElement = 'comeFlgName' + judClassCd;
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = comeName;
    }
    folNameElement = 'judCd2Name' + judClassCd;
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = judCd2;
    }
    folNameElement = 'folNoteName' + judClassCd;
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = folNote;
    }


    folNameElement = 'folName' + judClassCd + '0';
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = folName1;
    }
    folNameElement = 'folName' + judClassCd + '1';
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = folName2;
    }
    folNameElement = 'folName' + judClassCd + '2';
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = folName3;
    }
    folNameElement = 'folName' + judClassCd + '3';
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = folName4;
    }
    folNameElement = 'folName' + judClassCd + '4';
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = folName5;
    }

    folNameElement = 'rsvInfoName' + judClassCd;
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = rsvInfoName;
    }
    folNameElement = 'questionName' + judClassCd;
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = questionName;
    }

}

// チェックボックスの値を代入
function setCheck(index, selObj) {

    var myForm = document.resultList;	// 自画面のフォームエレメント

    if ( myForm.delFlg.length != null ) {
        if (selObj.checked) {
            myForm.delFlg[index].value = '1'
        } else {
            myForm.delFlg[index].value = '0'
        }
    } else {
        if (selObj.checked) {
            myForm.delFlg.value = '1'
        } else {
            myForm.delFlg.value = '0'
        }
    }

}

// サブ画面を閉じる
function closeWindow() {

    // フォローガイドを閉じる
    closeGuideFol();

}

function showFollowRsl(rsvNo, index) {

    var opened = false; // 画面が開かれているか
    var url;            // URL文字列
    var myForm = document.resultList;
    var judClassCd;
    var judClassName;
    var judCd;

    // すでにガイドが開かれているかチェック
    if ( winRslFol != null ) {
        if ( !winRslFol.closed ) {
            opened = true;
        }
    }

    // ガイド画面の連絡域に判定分類コードを設定する
    if ( myForm.judClassCd.length != null ) {
        judClassCd = myForm.judClassCd[ index ].value;
    } else {
        judClassCd = myForm.judClassCd.value;
    }

    // ガイド画面の連絡域に健診項目を設定する
    if ( myForm.judClassName.length != null ) {
        judClassName = myForm.judClassName[ index ].value;
    } else {
        judClassName = myForm.judClassName.value;
    }

    // ガイド画面の連絡域に判定（標準）を設定する
    if ( myForm.judCd.length != null ) {
        judCd = myForm.judCd[ index ].value;
    } else {
        judCd = myForm.judCd.value;
    }

    // 文章ガイドのURL編集
    url = 'followupRslEditBody.asp?winmode=1&rsvno='+rsvNo+'&judClassCd=' + judClassCd+'&judClassName=' + judClassName+'&judCd=' + judCd;

    // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
    if ( opened ) {
        winRslFol.focus();
        winRslFol.location.replace(url);
    } else {
        winRslFol = window.open(url, '', 'width=1000,height=700,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }
}


//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<FORM NAME="resultList" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">

    <INPUT TYPE="hidden" NAME="updMode"     VALUE="<%= strUpdMode %>">
    <INPUT TYPE="hidden" NAME="action"      VALUE="<%= strAct %>">
    <INPUT TYPE="hidden" NAME="cmtmode"     VALUE="<%= strCmtMode %>">
    <INPUT TYPE="hidden" NAME="rsvno"       VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="cscd"        VALUE="<%= strCsCd %>">
    <INPUT TYPE="hidden" NAME="winmode"     VALUE="<%= strWinMode %>">
    <INPUT TYPE="hidden" NAME="grpcd"       VALUE="<%= strGrpCd %>">
    <INPUT TYPE="hidden" NAME="followUpFlg" VALUE="<%= strFollowUpFlg %>">
    <INPUT TYPE="hidden" NAME="followCardFlg" VALUE="<%= strFollowCardFlg %>">
    <INPUT TYPE="hidden" NAME="pageKey"     VALUE="<%= lngPageKey %>">

<%
    'メッセージの編集
    If strAct <> "" Then

        Select Case strAct

            '保存完了時は「保存完了」の通知
            Case "saveend"
                Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

            'さもなくばエラーメッセージを編集
            Case Else
                Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

        End Select

    End If
%>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
                    <TR BGCOLOR="#cccccc" ALIGN="center">
                        <TD NOWRAP COLSPAN="1" WIDTH="50">削除</TD>
                        <TD NOWRAP COLSPAN="1" WIDTH="80">健診項目</TD>
                        <TD NOWRAP COLSPAN="1" WIDTH="50">判定</TD>
                        <TD NOWRAP COLSPAN="1" WIDTH="100">二次検査日</TD>
                        <TD NOWRAP COLSPAN="1" WIDTH="80">状況</TD>
                        <TD NOWRAP COLSPAN="1" WIDTH="100">検査項目</TD>
                        <TD NOWRAP COLSPAN="1" WIDTH="100">予約情報</TD>
                        <TD NOWRAP COLSPAN="1" WIDTH="40">結果</TD>
                        <TD NOWRAP COLSPAN="1" WIDTH="100">アンケート</TD>
                        <TD NOWRAP COLSPAN="1" WIDTH="300">備考</TD>
                    </TR>
<%
                    lngJudClassCount = 0
                    lngLastJudClassCd = 0
                    lngDspPoint = 0
                    For i = 0 To lngCount - 1
%>
                        <TR>
                        <TD><INPUT TYPE="checkbox" NAME="delFlgChk" VALUE="1" ONCLICK="javascript:setCheck(<%= i %>,this)"><INPUT TYPE="hidden" NAME="delFlg"></TD>
                        <INPUT TYPE="hidden" NAME="judClassCd" VALUE="<%= vntJudClassCd(i) %>">
                        <!--TD><INPUT TYPE="hidden" NAME="judClassName" VALUE="<%= vntJudClassName(i) %>"><A HREF="javascript:callFolGuide(<%= i %>)"><%= vntJudClassName(i) %></A></TD-->
                        <TD><INPUT TYPE="hidden" NAME="judClassName" VALUE="<%= vntJudClassName(i) %>"><A HREF="javascript:showFollowRsl(<%= lngRsvNo %>, <%= i %>)"><%= vntJudClassName(i) %></A></TD>
                        <TD ALIGN="center"><INPUT TYPE="hidden" NAME="judCd" VALUE="<%= vntJudCd(i) %>"><%= vntJudCd(i) %></TD>
                        <TD><INPUT TYPE="hidden" NAME="secCslDate" VALUE="<%= vntSecCslDate(i) %>"><SPAN ID="secCslDateName<%= vntJudClassCd(i) %>"><%= vntSecCslDate(i) %></SPAN></TD>
                        <TD><INPUT TYPE="hidden" NAME="comeFlg" VALUE="<%= vntComeFlg(i) %>"><SPAN ID="comeFlgName<%= vntJudClassCd(i) %>"><%= IIf(vntComeFlg(i) = "1", "来院","") %></SPAN></TD>
<%
                        IF vntSecItemCd(i) <> "" Then
                            vntArrSecItemCd = Split(vntSecItemCd(i),"Z")
                            lngArrSecItemCd = Ubound(vntArrSecItemCd)
%>
                            <TD><INPUT TYPE="hidden" NAME="secItemCd" VALUE="<%= vntSecItemCd(i) %>">
                                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
<%
                                For j = 0 To lngArrSecItemCd
                                    strShortstc = ""
                                    Ret = objSentence.SelectSentence("89001", 0, vntArrSecItemCd(j), strShortstc)
%>
                                <TR><TD><SPAN ID="folName<%= vntJudClassCd(i) & j %>"><%= strShortstc %></SPAN></TD></TR>
<%
                                Next

                                For j = j To 4
%>
                                <TR><TD><SPAN ID="folName<%= vntJudClassCd(i) & j %>"></SPAN></TD></TR>
<%
                                Next
%>
                                </TABLE>
                            </TD>
<%
                        Else
%>
                            <TD><INPUT TYPE="hidden" NAME="secItemCd" VALUE="">
                                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
<%
                                For j = 0 To 4
%>
                                <TR><TD><SPAN ID="folName<%= vntJudClassCd(i) & j %>"></SPAN></TD></TR>
<%
                                Next
%>
                                </TABLE>
                            </TD>
<%
                        End If
                        strShortstc = ""
                        Ret 		= objSentence.SelectSentence("89002", 0, vntRsvInfoCd(i), strShortstc)
%>
                        <TD><INPUT TYPE="hidden" NAME="rsvInfoCd" VALUE="<%= vntRsvInfoCd(i) %>"><SPAN ID="rsvInfoName<%= vntJudClassCd(i) %>"><%= strShortstc %></SPAN></TD>
                        <TD><INPUT TYPE="hidden" NAME="judCd2" VALUE="<%= vntJudCd2(i) %>"><SPAN ID="judCd2Name<%= vntJudClassCd(i) %>"><%= vntJudCd2(i) %></SPAN></TD>
<%
                        strShortstc = ""
                        Ret = objSentence.SelectSentence("89003", 0, vntQuestionCd(i), strShortstc)
%>
                        <TD><INPUT TYPE="hidden" NAME="questionCd" VALUE="<%= vntQuestionCd(i) %>"><SPAN ID="questionName<%= vntJudClassCd(i) %>"><%= strShortstc %></SPAN></TD>
                        <TD><INPUT TYPE="hidden" NAME="folNote" VALUE="<%= vntFolNote(i) %>"><SPAN ID="folNoteName<%= vntJudClassCd(i) %>"><%= vntFolNote(i) %></SPAN></TD>
                        </TR>
<%
                    Next
%>
                    <INPUT TYPE="hidden" NAME="orgCount" VALUE="<%= lngCount %>">
                </TABLE>
            </TD>
        </TR>
    </TABLE>
</FORM>
<SCRIPT TYPE="text/javascript">
<!--
    var updUserName;
    var updDateName;
    updUserName = '<%= strUpdUserName %>';
    updDateName = '<%= strUpdDate %>';
    parent.updUserSet(updUserName, updDateName);
//	var titleForm  = document.titleForm;	// ヘッダ画面のフォームエレメント
//	document.getElementById('updUserName').innerHTML = '<%= strUpdUserName %>';
//	document.getElementById('updDateName').innerHTML = '<%= strUpdDate %>';
//-->
</SCRIPT>
</BODY>
</HTML>
