<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      OCR入力結果確認（ボディ）  (Ver0.0.1)
'      AUTHER  :
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/InterviewEditDropDown.inc" -->
<!-- #include virtual = "/webHains/includes/EditJikakushoujyou.inc" -->
<%
'### セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const GRPCD_OCRNYURYOKU = "X034"    'OCR入力結果確認グループコード
Const GRPCD_ALLERGY = "X052"        '薬アレルギーグループコード

'### 取得した検査結果の先頭位置[0～]
Const OCRGRP_START1 =   0   '現病歴既往歴
Const OCRGRP_START2 =  86   '生活習慣問診１
Const OCRGRP_START3 = 149   '生活習慣問診２
Const OCRGRP_START4 = 174   '婦人科問診
Const OCRGRP_START5 = 239   '食習慣問診
Const OCRGRP_START6 = 275   '朝食
Const OCRGRP_START7 = 358   '昼食
Const OCRGRP_START8 = 441   '夕食
'### 2008.03.24 張 特定健診関連問診項目追加によって修正 Start ###
Const OCRGRP_START9 = 524   '特定健診
Const OCRGRP_START10 = 526   'OCR入力担当者
'### 2008.03.24 張 特定健診関連問診項目追加によって修正 End   ###

'### リストボックスの数
Const NOWDISEASE_COUNT  = 6         '現病歴の件数
Const DISEASEHIST_COUNT = 6         '既往歴の件数
Const FAMILYHIST_COUNT  = 6         '家族歴の件数


'### データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objConsult          '受診クラス
Dim objResult           '検査結果アクセス用
Dim objPerResult        '個人検査結果情報アクセス用
Dim objRslOcrSp         'OCR入力結果アクセス用
Dim objSentence         '文章情報アクセス用
Dim objHainsUser        'ユーザー情報用

'パラメータ
Dim lngRsvNo            '予約番号（今回分）
Dim strAnchor           '表示開始位置
Dim strAction           '処理状態(保存ボタン押下時:"check" → "save")

'受診情報用変数
Dim strPerId            '個人ID
Dim lngAge              '年齢
Dim lngGender           '性別

'個人検査項目情報用変数
Dim vntPerItemCd        '検査項目コード
Dim vntPerSuffix        'サフィックス
Dim vntPerItemName      '検査項目名
Dim vntPerResult        '検査結果
Dim vntPerResultType    '結果タイプ
Dim vntPerItemType      '項目タイプ
Dim vntPerStcItemCd     '文章参照用項目コード
Dim vntPerStcCd         '文章コード
Dim vntPerShortStc      '文章略称
Dim vntPerIspDate       '検査日
Dim lngPerRslCount      '個人検査項目情報数

'OCR入力結果情報
Dim vntPerId            '個人ID
Dim vntCslDate          '受診日
Dim vntRsvNo            '予約番号
Dim vntItemCd           '検査項目コード
Dim vntSuffix           'サフィックス
Dim vntItemName         '検査項目名称
Dim vntRslFlg           '検査結果存在フラグ
Dim vntResult           '検査結果
Dim vntStopFlg          '検査中止フラグ
Dim vntLstCslDate       '前回受診日
Dim vntLstRsvNo         '前回予約番号
Dim vntLstRslFlg        '前回検査結果存在フラグ
Dim vntLstResult        '前回検査結果
Dim vntLstStopFlg       '前回検査中止フラグ
Dim vntErrCount         'エラー数
Dim vntErrNo            'エラーNo
Dim vntErrState         'エラー状態
Dim vntErrMsg           'エラーメッセージ
Dim lngRslCnt           '検査結果数

'検査結果更新情報
Dim strUpdUser          '更新者
Dim strIPAddress        'IPアドレス
Dim strArrMessage       'エラーメッセージ

Dim lngErrCnt_E         'エラー数（エラー）
Dim lngErrCnt_W         'エラー数（警告）
Dim lngIndex            'インデックス
Dim Ret                 '復帰値
Dim strHTML             'HTML文字列
Dim strLstRsl           '前回値文字列
Dim i, j                'カウンター
Dim strLstDiffMsg       '前回値との差分メッセージ

Dim strOpeNameStcCd     'OCR入力担当者コード
Dim strOpeNameStc       'OCR入力担当者

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objPerResult    = Server.CreateObject("HainsPerResult.PerResult")
Set objRslOcrSp     = Server.CreateObject("HainsRslOcrSp.OcrNyuryokuSp")

'引数値の取得
lngRsvNo        = Request("rsvno")
strAnchor       = Request("anchor")
strAction       = Request("act")
vntItemCd       = ConvIStringToArray(Request("ItemCd"))
vntSuffix       = ConvIStringToArray(Request("Suffix"))
vntResult       = ConvIStringToArray(Request("ChgRsl"))
vntStopFlg      = ConvIStringToArray(Request("StopFlg"))

lngErrCnt_E = 0
lngErrCnt_W = 0

Do
    '受診情報検索（予約番号より個人情報取得）
    Ret = objConsult.SelectConsult(lngRsvNo, _
                                    , , _
                                    strPerId, _
                                    , , , , , , , _
                                    lngAge, _
                                    , , , , , , , , , , , , , , , _
                                    0, , , , , , , , , , , , , , , _
                                    , , , , , _
                                    lngGender _
                                    )

    'オブジェクトのインスタンス削除
    Set objConsult = Nothing

    '受診情報が存在しない場合はエラーとする
    If Ret = False Then
        Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
    End If

    '個人検査結果情報取得（薬剤（ブスコパン）アレルギー）
    lngPerRslCount = objPerResult.SelectPerResultGrpList( strPerId, _
                                                        GRPCD_ALLERGY, _
                                                        0, 1, _
                                                        vntPerItemCd, _
                                                        vntPerSuffix, _
                                                        vntPerItemName, _
                                                        vntPerResult, _
                                                        vntPerResultType, _
                                                        vntPerItemType, _
                                                        vntPerStcItemCd, _
                                                        vntPerShortStc, _
                                                        vntPerIspDate _
                                                        )
    'オブジェクトのインスタンス削除
    Set objPerResult = Nothing

    If lngPerRslCount < 0 Then
        Err.Raise 1000, , "個人検査結果情報が存在しません。（個人ID= " & strPerId & " )"
    End If

    If strAction = "" Then
        'OCR入力結果を取得する
        lngRslCnt = objRslOcrSp.SelectOcrNyuryoku( _
                            lngRsvNo, _
                            GRPCD_OCRNYURYOKU, _
                            0, _
                            "", _
                            vntPerId, _
                            vntCslDate, _
                            vntRsvNo, _
                            vntItemCd, _
                            vntSuffix, _
                            vntItemName, _
                            vntRslFlg, _
                            vntResult, _
                            vntStopFlg, _
                            vntLstCslDate, _
                            vntLstRsvNo, _
                            vntLstRslFlg, _
                            vntLstResult, _
                            vntLstStopFlg, _
                            vntErrCount, _
                            vntErrNo, _
                            vntErrState, _
                            vntErrMsg _
                            )
        If lngRslCnt < 0 Then
            Err.Raise 1000, , "OCR入力結果が取得できません。（予約番号 = " & lngRsvNo & ")"
        End If
    Else
        'チェック
        If strAction = "check" Then
            'OCR入力結果の入力チェック
            lngRslCnt = objRslOcrSp.CheckOcrNyuryoku( _
                                lngRsvNo, _
                                GRPCD_OCRNYURYOKU, _
                                0, _
                                "", _
                                vntItemCd, _
                                vntSuffix, _
                                vntResult, _
                                vntStopFlg, _
                                vntErrCount, _
                                vntErrNo, _
                                vntErrState, _
                                vntErrMsg _
                                )
            If lngRslCnt < 0 Then
                Err.Raise 1000, , "OCR入力結果が取得できません。（予約番号 = " & lngRsvNo & ")"
            End If

            If vntErrCount = 0 Then
                'エラーなしのときは引き続き保存処理を行う
                strAction = "save"
            Else
                '状態別エラー数カウント
                For i=0 To vntErrCount - 1
                    Select Case vntErrState(i)
                    Case "1"    'エラー
                        lngErrCnt_E = lngErrCnt_E + 1
                    Case "2"    '警告
                        lngErrCnt_W = lngErrCnt_W + 1
                    End Select
                Next

                'エラーがある場合はその項目を先頭表示する
                strAnchor = "Anchor-ErrInfo" & vntErrNo(0)

                'OCR入力結果を取得する(検査結果、検査中止フラグ、エラー情報はチェック結果を使用)
                lngRslCnt = objRslOcrSp.SelectOcrNyuryoku( _
                                    lngRsvNo, _
                                    GRPCD_OCRNYURYOKU, _
                                    0, _
                                    "", _
                                    vntPerId, _
                                    vntCslDate, _
                                    vntRsvNo, _
                                    vntItemCd, _
                                    vntSuffix, _
                                    vntItemName, _
                                    vntRslFlg, _
                                    , _
                                    , _
                                    vntLstCslDate, _
                                    vntLstRsvNo, _
                                    vntLstRslFlg, _
                                    vntLstResult, _
                                    vntLstStopFlg _
                                    )
                If lngRslCnt < 0 Then
                    Err.Raise 1000, , "OCR入力結果が取得できません。（予約番号 = " & lngRsvNo & ")"
                End If
            End If
        End If

        '保存
        If strAction = "save" Then
            '更新者の設定
            strUpdUser = Session("USERID")
            'IPアドレスの取得
            strIPAddress = Request.ServerVariables("REMOTE_ADDR")

            '検査結果更新
            Ret = objRslOcrSp.UpdateOcrNyuryoku( _
                                                lngRsvNo, _
                                                strIPAddress, _
                                                strUpdUser, _
                                                vntItemCd, _
                                                vntSuffix, _
                                                vntResult, _
                                                , , _
                                                strArrMessage, _
                                                vntStopFlg _
                                                )

            If Ret = False Then
                'OCR入力結果を取得する(検査結果、エラー情報はチェック結果を使用)
                lngRslCnt = objRslOcrSp.SelectOcrNyuryoku( _
                                    lngRsvNo, _
                                    GRPCD_OCRNYURYOKU, _
                                    0, _
                                    "", _
                                    vntPerId, _
                                    vntCslDate, _
                                    vntRsvNo, _
                                    vntItemCd, _
                                    vntSuffix, _
                                    vntItemName, _
                                    vntRslFlg, _
                                    , _
                                    , _
                                    vntLstCslDate, _
                                    vntLstRsvNo, _
                                    vntLstRslFlg, _
                                    vntLstResult, _
                                    vntLstStopFlg _
                                    )
                If lngRslCnt < 0 Then
                    Err.Raise 1000, , "OCR入力結果が取得できません。（予約番号 = " & lngRsvNo & ")"
                End If

                Exit Do
            Else
                'オブジェクトのインスタンス削除
                Set objRslOcrSp = Nothing

                'エラーがなけれ再表示
                strHTML = "<HTML>"
                strHTML = strHTML & "<BODY ONLOAD=""javascript:top.params.nomsg=1; top.parent.location.reload()"">"
                strHTML = strHTML & "</BODY>"
                strHTML = strHTML & "</HTML>"
                Response.Write strHTML
                Response.End
            End If
        End If
    End If

    'オブジェクトのインスタンス削除
    Set objRslOcrSp = Nothing

Exit Do
Loop

'-------------------------------------------------------------------------------
'ドロップダウンリスト（固定値）
'-------------------------------------------------------------------------------
Dim strArrCode1         'コード(病名)
Dim strArrName1         '名称(病名)
Dim strArrCode2         'コード(治療状況)
Dim strArrName2         '名称(治療状況)
Dim strArrCode3         'コード(続柄)
Dim strArrName3         '名称(続柄)

'*** 病名 ***
strArrCode1 = Array( _
                    "1",  "2",  "3",  "4",  "5",  "6",  "7",  "8",  "9",  "10", _
                    "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", _
                    "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", _
                    "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", _
                    "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", _
                    "51", "52", "53", "54", "55", _
                    "98", "99", _
                    "101", "102", "103", "104", "105", "106", "107", "108", "109",_
                    "201", "202", "203", "204", "205", "206", "207", "208", "209", "210", _
                    "211", "212", "213", "214", "215", "216", "217", _
                    "XXX" _
                    )
strArrName1 = Array( _
                    "脳腫瘍", "脳梗塞", "クモ膜下出血", "脳出血", "一過性脳虚血発作", "緑内障", "白内障", "糖尿病網膜症", "その他の眼科疾患", "甲状腺機能低下症", _
                    "甲状腺機能亢進症", "結核・胸膜炎", "肺がん", "肺線維症", "肺気腫", "気管支ぜんそく", "気管支拡張症", "慢性気管支炎", "高血圧", "狭心症", _
                    "心筋梗塞", "心房中隔欠損症", "心室中隔欠損症", "心臓弁膜症", "不整脈", "食道がん", "胃がん", "胃潰瘍", "胃ポリープ", "十二指腸潰瘍", _
                    "大腸がん", "大腸ポリープ", "虫垂炎", "痔", "胆石症", "胆のうポリープ", "慢性膵炎", "肝がん", "Ｂ型肝炎", "Ｃ型肝炎", _
                    "肝硬変", "腎炎・ネフローゼ", "腎結石", "尿路結石", "前立腺がん", "前立腺肥大", "脂質異常症（高脂血症）", "糖尿病", "血液疾患", "貧血", _
                    "痛風・高尿酸血症", "神経症", "うつ病", "扁桃腺炎", "慢性腎不全", _
                    "その他", "その他のがん", _
                    "子宮頚がん", "子宮体がん", "卵巣嚢腫（腫瘍）", "子宮内膜症", "子宮筋腫", "子宮細胞診異常", "乳がん", "乳腺症", "更年期障害", _
                    "甲状腺疾患", "膠原病", "急性膵炎", "大動脈瘤", "腸閉塞", "腎不全", "前立腺ＰＳＡ高値", "その他の心疾患", "その他の神経筋疾患", "その他の上部消化管疾患", _
                    "その他の大腸疾患", "その他の肝疾患", "その他の前立腺疾患", "その他の乳房疾患", "皮膚科疾患", "耳鼻科疾患", "整形外科疾患", _
                    "※入力異常" _
                    )

'*** 治療状況 ***
strArrCode2 = Array( _
                    "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11",_
                    "XXX" _
                    )
strArrName2 = Array( _
                    "手術後薬剤治療中", _
                    "手術後薬剤なし受診中", _
                    "内視鏡下切除後薬剤治療中", _
                    "内視鏡下切除後薬剤なし受診中", _
                    "薬剤治療中", _
                    "薬剤なし受診中", _
                    "手術後治療終了", _
                    "内視鏡下切除後治療終了", _
                    "治療終了", _
                    "放置あるいは治療中断", _
                    "透析治療中", _
                    "※入力異常" _
                    )
'*** 続柄 ***
strArrCode3 = Array( _
                    "1", "2", "3", "4", _
                    "XXX" _
                    )
strArrName3 = Array( _
                    "父親", _
                    "母親", _
                    "兄弟・姉妹", _
                    "祖父母", _
                    "※入力異常" _
                    )

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
    Dim lngResult
    Dim strArrCode
    Dim strArrName

    Dim blnSearchFlg
    Dim i


    EditRsl = ""
    strFuncName = "javascript:document.entryForm.ChgRsl[" & vntIndex & "].value = this.value"

    Select Case vntType
    Case "text"         'テキスト
        EditRsl = "<INPUT TYPE=""text"" NAME=""" & vntName & """ SIZE=""" & vntSize & """  MAXLENGTH=""8"" STYLE=""text-align:right"" VALUE=""" & vntResult(vntIndex) & """"
        EditRsl = EditRsl & " ONCHANGE=""" & strFuncName & """>"

    Case "checkbox"     'チェックボックス
        EditRsl = "<INPUT TYPE=""checkbox"" NAME=""" & vntName & """ VALUE=""" & vntOnValue & """" & IIf(vntResult(lngIndex)=vntOnValue, " CHECKED", "")
        EditRsl = EditRsl & " ONCLICK=""javascript:clickRsl( this, " & vntIndex & ")"">"

    Case "radio"        'ラジオボタン
        EditRsl = "<INPUT TYPE=""radio"" NAME=""" & vntName & """ VALUE=""" & vntOnValue & """" & IIf(vntResult(lngIndex)=vntOnValue, " CHECKED", "")
        EditRsl = EditRsl & " ONCLICK=""javascript:clickRsl( this, " & vntIndex & ")"">"

    Case "list1"        'ドロップダウンリスト（病名）
        '文章コードのチェック
        blnSearchFlg = False
        If vntResult(vntIndex) = "" Then
            blnSearchFlg = True
        Else
            For i=0 To UBound(strArrCode1)
                If vntResult(vntIndex) = strArrCode1(i) Then
                    blnSearchFlg = True
                    Exit For
                End If
            Next
        End If
        '選択肢以外の場合は値を無効とする
        If blnSearchFlg = False Then
            vntResult(vntIndex) = "XXX"
        End If

        EditRsl = EditDropDownListFromArray2(vntName, strArrCode1, strArrName1, vntResult(vntIndex), NON_SELECTED_ADD, strFuncName)

    Case "disease"      '病名選択用テキスト
        EditRsl = "<INPUT TYPE=""text"" NAME=""disease"" SIZE=""" & vntSize & """  MAXLENGTH=""3"" STYLE=""text-align:right"" VALUE="""""
        EditRsl = EditRsl & " ONCHANGE=""javascript:SelectDiseaseList(document.entryForm." & vntName & ", this)"""
        EditRsl = EditRsl & " ONKEYPRESS=""javascript:Disease_KeyPress(document.entryForm." & vntName & ", this)"""
        EditRsl = EditRsl & ">"

    Case "list2"        'ドロップダウンリスト（治療状況）
        '文章コードのチェック
        blnSearchFlg = False
        If vntResult(vntIndex) = "" Then
            blnSearchFlg = True
        Else
            For i=0 To UBound(strArrCode2)
                If vntResult(vntIndex) = strArrCode2(i) Then
                    blnSearchFlg = True
                    Exit For
                End If
            Next
        End If
        '選択肢以外の場合は値を無効とする
        If blnSearchFlg = False Then
            vntResult(vntIndex) = "XXX"
        End If

        EditRsl = EditDropDownListFromArray2(vntName, strArrCode2, strArrName2, vntResult(vntIndex), NON_SELECTED_ADD, strFuncName)

    Case "list3"        'ドロップダウンリスト（続柄）
        '文章コードのチェック
        blnSearchFlg = False
        If vntResult(vntIndex) = "" Then
            blnSearchFlg = True
        Else
            For i=0 To UBound(strArrCode3)
                If vntResult(vntIndex) = strArrCode3(i) Then
                    blnSearchFlg = True
                    Exit For
                End If
            Next
        End If
        '選択肢以外の場合は値を無効とする
        If blnSearchFlg = False Then
            vntResult(vntIndex) = "XXX"
        End If

        EditRsl = EditDropDownListFromArray2(vntName, strArrCode3, strArrName3, vntResult(vntIndex), NON_SELECTED_ADD, strFuncName)

    Case "listyear"     'ドロップダウンリスト（年）
        '文章コードのチェック
        If IsNumeric(vntResult(vntIndex)) Then
            lngResult = CLng(vntResult(vntIndex))
            '選択肢以外の場合は値を無効とする
            If lngResult < YEARRANGE_MIN Or YEARRANGE_MAX < lngResult Then
                lngResult = ""
            End If
        Else
            lngResult = ""
        End If
        vntResult(vntIndex) = lngResult

        EditRsl = EditSelectNumberList2(vntName, YEARRANGE_MIN, YEARRANGE_MAX, vntResult(vntIndex), strFuncName)

    Case "listmonth"    'ドロップダウンリスト（月）
        '文章コードのチェック
        If IsNumeric(vntResult(vntIndex)) Then
            lngResult = CLng(vntResult(vntIndex))
            '選択肢以外の場合は値を無効とする
            If lngResult < 1 Or 12 < lngResult Then
                lngResult = ""
            End If
        Else
            lngResult = ""
        End If
        vntResult(vntIndex) = lngResult

        EditRsl = EditSelectNumberList2(vntName, 1, 12, lngResult, strFuncName)

    Case "listday"      'ドロップダウンリスト（日）
        '文章コードのチェック
        If IsNumeric(vntResult(vntIndex)) Then
            lngResult = CLng(vntResult(vntIndex))
            '選択肢以外の場合は値を無効とする
            If lngResult < 1 Or 31 < lngResult Then
                lngResult = ""
            End If
        Else
            lngResult = ""
        End If
        vntResult(vntIndex) = lngResult

        EditRsl = EditSelectNumberList2(vntName, 1, 31, lngResult, strFuncName)

    End Select

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 文章コードのチェックを行う
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckStcCd(Result, ArrCode)
    Dim blnSearchFlg
    Dim i

    blnSearchFlg = False
    For i=0 To UBound(ArrCode)
        If Result = ArrCode(i) Then
            blnSearchFlg = True
            Exit For
        End If
    Next
    '選択肢以外の場合は値を無効とする
    If blnSearchFlg = False Then
        Result = ""
    End If

End Function

Dim ErrInfoNo	'エラーNo
'-------------------------------------------------------------------------------
'
' 機能　　 : エラー情報のタグ生成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditErrInfo()
    Dim strAnchor

    ErrInfoNo =ErrInfoNo + 1

    strAnchor = "Anchor-ErrInfo" & ErrInfoNo

    EditErrInfo = "<SPAN ID=""" &  strAnchor & """ STYLE=""position:relative""></SPAN>"

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 献立のタグ生成
'
' 引数　　 : (In)     vntIndex          先頭インデックス
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditMenuList(vntIndex)

    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
'---エラー情報---
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPACING=""2"" CELLPADDING=""2"">" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""20""><TD>&nbsp;</TD></TR>" & vbLf
    For i=0 To 30
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""16"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    strHTML = strHTML & "</TABLE>" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'----------------
    strHTML = strHTML & "<TD NOWRAP WIDTH=""750"">" & vbLf
    strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPACING=""2"" CELLPADDING=""2"">" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""20"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP COLSPAN=""3"">主食</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP COLSPAN=""3"">主菜</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP COLSPAN=""3"">副菜</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    '画面上わかりにくいので表示
    Select Case vntIndex
    Case OCRGRP_START6  '朝食
        strHTML = strHTML & "<TD ROWSPAN=""31"" BGCOLOR=""#ffe4b5"" ALIGN=""center"">朝</TD>" & vbLf
    Case OCRGRP_START7  '昼食
        strHTML = strHTML & "<TD ROWSPAN=""31"" BGCOLOR=""#f0e68c"" ALIGN=""center"">昼</TD>" & vbLf
    Case OCRGRP_START8  '夕食
        strHTML = strHTML & "<TD ROWSPAN=""31"" BGCOLOR=""#add8e6"" ALIGN=""center"">夕</TD>" & vbLf
    End Select
lngIndex = vntIndex + 1
    strHTML = strHTML & "<TD ROWSPAN=""4"" BGCOLOR=""#eeeeee"" ALIGN=""center"">米</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">ご飯（女性用茶碗）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 32
    strHTML = strHTML & "<TD ROWSPAN=""6"" BGCOLOR=""#e0ffff"" ALIGN=""center"">魚</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">刺身盛り合わせ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 63
    strHTML = strHTML & "<TD ROWSPAN=""13"" BGCOLOR=""#98fb98"" ALIGN=""center"">野菜料理</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">野菜サラダ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "皿</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 2
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">ご飯（男性用茶碗）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 33
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">煮魚・焼魚<FONT SIZE=""-1"">（ぶり、さんま、いわし等）</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 64
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">　ノンオイルドレッシング</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 3
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">ご飯（どんぶり茶碗）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 34
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">煮魚・焼魚<FONT SIZE=""-1"">（かれい、たら、ひらめ等）</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 65
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">　マヨネーズ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 4
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">おにぎり</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 35
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">魚のムニエル</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 66
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">　ドレッシング</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 5
    strHTML = strHTML & "<TD ROWSPAN=""9"" BGCOLOR=""#eee8aa"" ALIGN=""center"">めん</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">そば・うどん（天ぷら）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 36
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">エビチリ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 67
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">　塩</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "つまみ</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 6
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">そば・うどん（たぬき）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 37
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">八宝菜</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 68
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">ポテト・マカロニサラダ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 7
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">そば・うどん（ざる・かけ）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 38
    strHTML = strHTML & "<TD ROWSPAN=""9"" BGCOLOR=""#ffc0cb"" ALIGN=""center"">肉</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">ステーキ(150g)</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 69
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">煮物（芋入り）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 8
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">ラーメン</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 39
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">焼き肉</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 70
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">煮物（野菜のみ）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 9
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">五目ラーメン</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 40
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">とりの唐揚</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 71
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">煮物（ひじき・昆布等）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 10
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">焼きそば</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "皿</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 41
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">ハンバーグ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 72
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">肉じゃが</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 11
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">スパゲッティ（クリーム）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 42
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">シチュー</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 73
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">野菜炒め（肉なし）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 12
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">スパゲッティ（その他）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 43
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">肉野菜炒め</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 74
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">おひたし</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 13
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">マカロニグラタン</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 44
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">餃子・シュウマイ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 75
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">酢の物</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 14
    strHTML = strHTML & "<TD ROWSPAN=""8"" BGCOLOR=""#f5deb3"" ALIGN=""center"">パン</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">食パン６枚切り</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "枚</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 45
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">ハム・ウィンナー</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "枚</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 76
    strHTML = strHTML & "<TD ROWSPAN=""3"" BGCOLOR=""#ffdead"" ALIGN=""center"">汁</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffdead"">味噌汁</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffdead"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 15
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">食パン８枚切り</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "枚</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 46
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">ベーコン</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "枚</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 77
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffdead"">コンソメ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffdead"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 16
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">　バター</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 47
    strHTML = strHTML & "<TD ROWSPAN=""4"" BGCOLOR=""#f0e68c"" ALIGN=""center"">揚げ物</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">フライ（コロッケ）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 78
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffdead"">ポタージュ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffdead"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 17
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">　マーガリン</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 48
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">フライ（トンカツ）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 79
    strHTML = strHTML & "<TD ROWSPAN=""4"" BGCOLOR=""#fffacd"" ALIGN=""center"">もう一品</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">チーズ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 18
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">　ジャム類</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 49
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">フライ（えび）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 80
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">枝豆</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 19
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">ミックスサンドイッチ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 50
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">天ぷら</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 81
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">果物</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 20
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">菓子パン</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 51
    strHTML = strHTML & "<TD ROWSPAN=""3"" BGCOLOR=""#eee8aa"" ALIGN=""center"">鍋</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">すき焼き・しゃぶしゃぶ等</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 82
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">お漬物</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 21
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">調理パン</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 52
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">寄鍋・たらちり等</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 22
    strHTML = strHTML & "<TD ROWSPAN=""7"" BGCOLOR=""#f0e68c"" ALIGN=""center"">丼物</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">カツ丼</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 53
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">おでん</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 23
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">親子丼</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 54
    strHTML = strHTML & "<TD ROWSPAN=""5"" BGCOLOR=""#fffacd"" ALIGN=""center"">卵</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">生卵・ゆで卵</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 24
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">天丼</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 55
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">目玉焼き</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 25
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">中華丼</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 56
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">卵焼き</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 26
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">カレーライス</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 57
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">スクランブル</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 27
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">チャーハン・ピラフ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 58
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">かに玉</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 28
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">にぎり・ちらし寿司</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 59
    strHTML = strHTML & "<TD ROWSPAN=""4"" BGCOLOR=""#e6e6fa"" ALIGN=""center"">豆製品</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e6e6fa"">冷・湯豆腐</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e6e6fa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 29
    strHTML = strHTML & "<TD ROWSPAN=""4"" BGCOLOR=""#ffc0cb"" ALIGN=""center"">その他</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">幕の内弁当</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 60
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e6e6fa"">納豆</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e6e6fa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 30
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">シリアル等</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "皿</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 61
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e6e6fa"">マーボ豆腐</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e6e6fa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 31
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">ミックスピザ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 62
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e6e6fa"">五目豆</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e6e6fa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "人前</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "</TABLE>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    Response.Write strHTML

End Sub
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 5">
<TITLE>OCR入力結果確認（新）</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc"    -->
<!--
// 検査結果の選択時処理
function clickRsl( Obj, Index ) {

/*** 婦人科問診票のNo.4、13、15の「なし」のチェックが他の項目を選択した時に自動的に消える ***/
var lngIndex; 

    // エレメントタイプごとの処理分岐
    switch ( Obj.type ) {
        case 'checkbox':    // チェックボックス
            if( Obj.checked ) {
                document.entryForm.ChgRsl[Index].value = Obj.value;
                /*** 婦人科問診票のNo.4、13、15の「なし」のチェックが他の項目を選択した時に自動的に消える ***/
                lngIndex = <%= OCRGRP_START4 %>;
                if ( Index >= lngIndex + 4 && Index <= lngIndex + 14 ) {
                    document.entryForm.chk4_4_1.checked = false;
                    document.entryForm.ChgRsl[177].value = '';
                }
                if( Index >= lngIndex + 50 && Index <= lngIndex + 54 ) {
                    document.entryForm.chk4_13_1.checked = false;
                    document.entryForm.ChgRsl[223].value = '';
                } 
                if( Index >= lngIndex + 57 && Index <= lngIndex + 64 ) {
                    document.entryForm.chk4_15_1.checked = false;
                    document.entryForm.ChgRsl[230].value = '';
                }
                /*************************************************************************************/
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
                document.entryForm.ChgRsl[Index].value = Obj.value;
            }
            break;

        default:
            break;
    }

}

// 病名でキー押下時の処理
function Disease_KeyPress( list_disease, text_disease ){

    // Enterキー
    if ( event.keyCode == 13 ) {
        // 病名の選択処理
        SelectDiseaseList( list_disease, text_disease );
    }
}

// 病名の選択処理
function SelectDiseaseList( list_disease, text_disease ) {

    if( text_disease.value == '' ) return;

    // 病名検索
    for( i=0; i < list_disease.options.length; i++ ) {
        if( list_disease.options[i].value == text_disease.value ) {
            list_disease.selectedIndex = i;
            list_disease.onchange();
            return;
        }
    }
    // 見つからなかったときは、入力異常とする
    list_disease.selectedIndex = list_disease.options.length-1;
    list_disease.onchange();
}

var lngOpeIndex;  // ガイド表示時に選択されたエレメントのインデックス

//OCR入力担当者選択ウインドウ表示
function showUserWindow(index, OpeItemCd) {

    // 選択されたエレメントのインデックスを退避
    lngOpeIndex = index;

    // ガイド画面の連絡域に検査項目コードを設定する
    stcGuide_ItemCd = OpeItemCd;

    // ガイド画面の連絡域に項目タイプ（標準）を設定する
    stcGuide_ItemType = 0;

    // ガイド画面の連絡域にガイド画面から呼び出される自画面の関数を設定する
    stcGuide_CalledFunction = setOpeInfo;

    // 文章ガイド表示
    showGuideStc();
}

// OCR入力担当者の編集
function setOpeInfo( ) {

    document.entryForm.ChgRsl[lngOpeIndex].value = stcGuide_StcCd;

    if ( document.getElementById('OpeName') ) {
        document.getElementById('OpeName').innerHTML = stcGuide_ShortStc;
    }
}

//OCR入力担当者クリア
function clrUser(index) {

    document.entryForm.ChgRsl[index].value = '';

    if ( document.getElementById('OpeName') ) {
        document.getElementById('OpeName').innerHTML = '';
    }
}

// ジャンプ
function JumpAnchor() {
    var PosY;

    if( document.entryForm.anchor.value != '' ) {
        PosY = document.all(document.entryForm.anchor.value).offsetTop;
        if( document.entryForm.anchor.value.indexOf('Anchor-ErrInfo') >= 0 ) {
            PosY = PosY - 28;
        }
        scrollTo(0, PosY);
    }
}

//保存
function saveOcrNyuryoku() {
    var myForm = 	document.entryForm;
    var index;
    var count;
    var buff	= new Array();
    var i, j;

    //**************
    // 設定値の取得
    //**************
    if( <%= lngGender %> ==  2 ) {
        // カレンダーガイドから設定された値を取得
        index = <%= OCRGRP_START4 %>;
        myForm.ChgRsl[index + 32].value = myForm.year11_1.value;
        myForm.ChgRsl[index + 33].value = myForm.month11_1.value;
        myForm.ChgRsl[index + 34].value = myForm.day11_1.value;
        myForm.ChgRsl[index + 35].value = myForm.month11_2.value;
        myForm.ChgRsl[index + 36].value = myForm.day11_2.value;
        myForm.ChgRsl[index + 37].value = myForm.year11_3.value;
        myForm.ChgRsl[index + 38].value = myForm.month11_3.value;
        myForm.ChgRsl[index + 39].value = myForm.day11_3.value;
        myForm.ChgRsl[index + 40].value = myForm.month11_4.value;
        myForm.ChgRsl[index + 41].value = myForm.day11_4.value;
    }

    //********
    // 前詰め
    //********
    // 現病歴
    index = <%= OCRGRP_START1 %> + 2;
    count = 0;
    for( i=0; i< <%= NOWDISEASE_COUNT %>; i++ ) {
        if( myForm.ChgRsl[index+i*3+0].value != ''
          || myForm.ChgRsl[index+i*3+1].value != ''
          || myForm.ChgRsl[index+i*3+2].value != '' ) {
            for( j=0; j < 3; j++ ) {
                buff[count*3+j] =  myForm.ChgRsl[index+i*3+j].value;
            }
            count ++;
        }
    }
    for( i=0; i< <%= NOWDISEASE_COUNT %>; i++ ) {
        if( i < count ) {
            for( j=0; j < 3; j++ ) {
                myForm.ChgRsl[index+i*3+j].value = buff[i*3+j];
            }
        } else {
            for( j=0; j < 3; j++ ) {
                myForm.ChgRsl[index+i*3+j].value = "";
            }
        }
    }
    // 既往歴
    index = <%= OCRGRP_START1 %> + 20;
    count = 0;
    for( i=0; i< <%= DISEASEHIST_COUNT %>; i++ ) {
        if( myForm.ChgRsl[index+i*3+0].value != ''
          || myForm.ChgRsl[index+i*3+1].value != ''
          || myForm.ChgRsl[index+i*3+2].value != '' ) {
            for( j=0; j < 3; j++ ) {
                buff[count*3+j] =  myForm.ChgRsl[index+i*3+j].value;
            }
            count ++;
        }
    }
    for( i=0; i< <%= DISEASEHIST_COUNT %>; i++ ) {
        if( i < count ) {
            for( j=0; j < 3; j++ ) {
                myForm.ChgRsl[index+i*3+j].value = buff[i*3+j];
            }
        } else {
            for( j=0; j < 3; j++ ) {
                myForm.ChgRsl[index+i*3+j].value = "";
            }
        }
    }
    // 家族歴
    index = <%= OCRGRP_START1 %> + 38;
    count = 0;
    for( i=0; i< <%= NOWDISEASE_COUNT %>; i++ ) {
        if( myForm.ChgRsl[index+i*3+0].value != ''
          || myForm.ChgRsl[index+i*3+1].value != ''
          || myForm.ChgRsl[index+i*3+2].value != '' ) {
            for( j=0; j < 3; j++ ) {
                buff[count*3+j] =  myForm.ChgRsl[index+i*3+j].value;
            }
            count ++;
        }
    }
    for( i=0; i< <%= FAMILYHIST_COUNT %>; i++ ) {
        if( i < count ) {
            for( j=0; j < 3; j++ ) {
                myForm.ChgRsl[index+i*3+j].value = buff[i*3+j];
            }
        } else {
            for( j=0; j < 3; j++ ) {
                myForm.ChgRsl[index+i*3+j].value = "";
            }
        }
    }
    // 自覚症状
    index = <%= OCRGRP_START2 %> + 39;
    count = 0;
    for( i=0; i< <%= JIKAKUSHOUJYOU_COUNT %>; i++ ) {
        if( myForm.ChgRsl[index+i*4+0].value != ''
          || myForm.ChgRsl[index+i*4+1].value != ''
          || myForm.ChgRsl[index+i*4+2].value != ''
          || myForm.ChgRsl[index+i*4+3].value != '' ) {
            for( j=0; j < 4; j++ ) {
                buff[count*4+j] =  myForm.ChgRsl[index+i*4+j].value;
            }
            count ++;
        }
    }
    for( i=0; i< <%= JIKAKUSHOUJYOU_COUNT %>; i++ ) {
        if( i < count ) {
            for( j=0; j < 4; j++ ) {
                myForm.ChgRsl[index+i*4+j].value = buff[i*4+j];
            }
        } else {
            for( j=0; j < 4; j++ ) {
                myForm.ChgRsl[index+i*4+j].value = "";
            }
        }
    }


    //下のフレームのエラーリストを消去
    parent.lngErrCount = 0;
    parent.error.document.entryForm.selectState.selectedIndex = 2;
    parent.error.chgSelect();

    // モードを指定してsubmit
    document.entryForm.act.value = 'check';
    document.entryForm.submit();

    return;
}

// ウィンドウを閉じる
function windowClose() {

    // 日付ガイドウインドウを閉じる
    calGuide_closeGuideCalendar();

}
//-->
</SCRIPT>
<%
'-----表示前処理----- 
%>
<SCRIPT TYPE="text/javascript">
<!--
    // エラー情報の初期化
    parent.initErrInfo();

    // エラー情報追加
<%
    For i=0 To vntErrCount - 1
%>
        parent.addErrInfo( <%= vntErrNo(i) %>, <%= vntErrState(i) %>, '<%= vntErrMsg(i) %>' );
<%
    Next
%>
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <!-- 引数値 -->
    <INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="anchor"  VALUE="<%= strAnchor %>">
    <INPUT TYPE="hidden" NAME="act"     VALUE="<%= strAction %>">
<%
    If Not IsEmpty(strArrMessage) Then
        'エラーメッセージを編集
        Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
    End If

    '処理中メッセージを表示
    strHTML = ""
    strHTML = strHTML & "<SPAN ID=""LoadindMessage"">"
    strHTML = strHTML & "<TABLE HEIGHT=""100%"" WIDTH=""100%"">"
    strHTML = strHTML & "<TR ALIGN=""center"" VALIGN=""center""><TD>"
    strHTML = strHTML & "<IMG SRC=""../../images/zzz.gif"">　<B>処理中です．．．</B>"
    strHTML = strHTML & "</TD></TR>"
    strHTML = strHTML & "</TABLE>"
    strHTML = strHTML & "</SPAN>"
    Response.Write strHTML
    Response.Flush
%>
<!-- 
******************************************************
    現病歴既往歴
******************************************************
 -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20">
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP BGCOLOR="#98fb98" WIDTH="730"><SPAN ID="Anchor-DiseaseHistory" STYLE="position:relative">現病歴・既往歴問診票</SPAN></TD>
            <TD NOWRAP BGCOLOR="#98fb98" WIDTH="220">前回値<%= IIf(vntLstCslDate(0)="", "", "(" & vntLstCslDate(0) & ")") %></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">ブスコパン可否</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 0
    '薬アレルギーが「あり」のときはブスコパン可否を「否」とする（「可」は選択不可）
    If vntPerResult(0) = "2" Then
        vntResult(lngIndex) = "2"
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & "　　" & "可　　　" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_1", , "2") & "否" & vbLf
        strHTML = strHTML & "</TD>" & vbLf
    Else
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_1", , "1") & "可　　　" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_1", , "2") & "否" & vbLf
        strHTML = strHTML & "</TD>" & vbLf
    End If
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "可"
    Case "2"
        strLstRsl = "否"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">朝食摂取の有無</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 1
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_2", , "1") & "はい　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_2", , "2") & "いいえ" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "はい"
    Case "2"
        strLstRsl = "いいえ"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">１．現在治療中又は定期的に受診中の病気について</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
                <TR><TD>&nbsp;</TD></TR>
<%
    strHTML = ""
    For i=0 To NOWDISEASE_COUNT - 1
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
                    <TR>
                        <TD NOWRAP BGCOLOR="#eeeeee">病名</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee">発症年齢</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee">治療状況</TD>
                        <TD NOWRAP WIDTH="100%" BGCOLOR="#eeeeee">メッセージ</TD>
                    </TR>
<%
    strHTML = ""
    For i=0 To NOWDISEASE_COUNT - 1
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 2 + i*3
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "disease", "list1_1_1" & (i+1), 3, "") & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "list1", "list1_1_1" & (i+1), , "") & vbLf
        strHTML = strHTML & "</TD>" & vbLf
lngIndex = OCRGRP_START1 + 3 + i*3
        strHTML = strHTML & "<TD NOWRAP  ALIGN=""right"">" & EditRsl(lngIndex, "text", "Rsl", 3, "") & "才" & "</TD>" & vbLf
lngIndex = OCRGRP_START1 + 4 + i*3
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "list2", "list1_1_2" & (i+1), , "") & vbLf
        strHTML = strHTML & "</TD>" & vbLf

        '前回値と比較してメッセージを作成
        strLstDiffMsg = ""
        For j=0 To NOWDISEASE_COUNT - 1
            If vntResult(OCRGRP_START1 + 2 + i*3) <> "" Then
                '同じ病名を検索
                If vntResult(OCRGRP_START1 + 2 + i*3) = vntLstResult(OCRGRP_START1 + 2 + j*3) Then
                    '年齢が違う
                    If vntResult(OCRGRP_START1 + 3 + i*3) <> vntLstResult(OCRGRP_START1 + 3 + j*3) Then
                        strLstDiffMsg = strLstDiffMsg & IIf(strLstDiffMsg<>"","、","") & "年齢"
                    End If
                    '治療状態が違う
                    If vntResult(OCRGRP_START1 + 4 + i*3) <> vntLstResult(OCRGRP_START1 + 4 + j*3) Then
                        strLstDiffMsg = strLstDiffMsg & IIf(strLstDiffMsg<>"","、","") & "治療状態"
                    End If
                    Exit For
                End If
            End If
        Next
        If strLstDiffMsg <> "" Then
            strLstDiffMsg = "<FONT COLOR=""red""><B>　※" & strLstDiffMsg & "違い</B></FONT>"
        End If
        strHTML = strHTML & "<TD NOWRAP>" & strLstDiffMsg & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
                    <TR>
                        <TD NOWRAP>　</TD>
                    </TR>
<%
'---前回値---
    strHTML = ""
    For i=0 To NOWDISEASE_COUNT - 1
        strLstRsl = ""
lngIndex = OCRGRP_START1 + 2 + i*3
        For j=0 To UBound(strArrCode1)
            If vntLstResult(lngIndex) = strArrCode1(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "　") & strArrName1(j)
                Exit For
            End If
        Next
lngIndex = OCRGRP_START1 + 3 + i*3
        strLstRsl =  strLstRsl & IIf(strLstRsl="", "", "　") & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "才")
lngIndex = OCRGRP_START1 + 4 + i*3
        For j=0 To UBound(strArrCode2)
            If vntLstResult(lngIndex) = strArrCode2(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "　") & strArrName2(j)
                Exit For
            End If
        Next
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
'------------
%>
                </TABLE>
            </TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">２．既に治療や定期的な受診が終了した病気について</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
                <TR><TD>&nbsp;</TD></TR>
<%
    strHTML = ""
    For i=0 To DISEASEHIST_COUNT - 1
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
                    <TR>
                        <TD NOWRAP BGCOLOR="#eeeeee">病名</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee">発症年齢</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee">治療状況</TD>
                        <TD NOWRAP WIDTH="100%" BGCOLOR="#eeeeee">メッセージ</TD>
                    </TR>
<%
    strHTML = ""
    For i=0 To DISEASEHIST_COUNT - 1
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 20 + i*3
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "disease", "list1_2_1" & (i+1), 3, "") & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "list1", "list1_2_1" & (i+1), , "") & vbLf
        strHTML = strHTML & "</TD>" & vbLf
lngIndex = OCRGRP_START1 + 21 + i*3
        strHTML = strHTML & "<TD NOWRAP  ALIGN=""right"">" & EditRsl(lngIndex, "text", "Rsl", 3, "") & "才" & "</TD>" & vbLf
lngIndex = OCRGRP_START1 + 22 + i*3
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "list2", "list1_2_2" & (i+1), , "") & vbLf
        strHTML = strHTML & "</TD>" & vbLf

        '前回値と比較してメッセージを作成
        strLstDiffMsg = ""
        For j=0 To NOWDISEASE_COUNT - 1
            If vntResult(OCRGRP_START1 + 20 + i*3) <> "" Then
                '同じ病名を検索
                If vntResult(OCRGRP_START1 + 20 + i*3) = vntLstResult(OCRGRP_START1 + 20 + j*3) Then
                    '年齢が違う
                    If vntResult(OCRGRP_START1 + 21 + i*3) <> vntLstResult(OCRGRP_START1 + 21 + j*3) Then
                        strLstDiffMsg = strLstDiffMsg & IIf(strLstDiffMsg<>"","、","") & "年齢"
                    End If
                    '治療状態が違う
                    If vntResult(OCRGRP_START1 + 22 + i*3) <> vntLstResult(OCRGRP_START1 + 22 + j*3) Then
                        strLstDiffMsg = strLstDiffMsg & IIf(strLstDiffMsg<>"","、","") & "治療状態"
                    End If
                    Exit For
                End If
            End If
        Next
        If strLstDiffMsg <> "" Then
            strLstDiffMsg = "<FONT COLOR=""red""><B>　※" & strLstDiffMsg & "違い</B></FONT>"
        End If
        strHTML = strHTML & "<TD NOWRAP>" & strLstDiffMsg & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
                    <TR>
                        <TD NOWRAP>　</TD>
                    </TR>
<%
'---前回値---
    strHTML = ""
    For i=0 To NOWDISEASE_COUNT - 1
        strLstRsl = ""
lngIndex = OCRGRP_START1 + 20 + i*3
        For j=0 To UBound(strArrCode1)
            If vntLstResult(lngIndex) = strArrCode1(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "　") & strArrName1(j)
                Exit For
            End If
        Next
lngIndex = OCRGRP_START1 + 21 + i*3
        strLstRsl =  strLstRsl & IIf(strLstRsl="", "", "　") & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "才")
lngIndex = OCRGRP_START1 + 22 + i*3
        For j=0 To UBound(strArrCode2)
            If vntLstResult(lngIndex) = strArrCode2(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "　") & strArrName2(j)
                Exit For
            End If
        Next
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
'------------
%>
                </TABLE>
            </TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">３．ご家族の方でかかった病気について</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
                <TR><TD>&nbsp;</TD></TR>
<%
    strHTML = ""
    For i=0 To FAMILYHIST_COUNT - 1
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
                    <TR>
                        <TD NOWRAP BGCOLOR="#eeeeee">病名</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee">発症年齢</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee">続柄</TD>
                        <TD NOWRAP WIDTH="100%" BGCOLOR="#eeeeee">メッセージ</TD>
                    </TR>
<%
    strHTML = ""
    For i=0 To FAMILYHIST_COUNT - 1
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 38 + i*3
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "disease", "list1_3_1" & (i+1), 3, "") & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "list1", "list1_3_1" & (i+1), , "") & vbLf
        strHTML = strHTML & "</TD>" & vbLf
lngIndex = OCRGRP_START1 + 39 + i*3
        strHTML = strHTML & "<TD NOWRAP  ALIGN=""right"">" & EditRsl(lngIndex, "text", "Rsl", 3, "") & "才" & "</TD>" & vbLf
lngIndex = OCRGRP_START1 + 40 + i*3
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "list3", "list1_3_2" & (i+1), , "") & vbLf
        strHTML = strHTML & "</TD>" & vbLf

        '前回値と比較してメッセージを作成
        strLstDiffMsg = ""
        For j=0 To NOWDISEASE_COUNT - 1
            If vntResult(OCRGRP_START1 + 38 + i*3) <> "" Then
                '同じ病名を検索
                If vntResult(OCRGRP_START1 + 38 + i*3) = vntLstResult(OCRGRP_START1 + 38 + j*3) Then
                    '発症年齢が違う
                    If vntResult(OCRGRP_START1 + 39 + i*3) <> vntLstResult(OCRGRP_START1 + 39 + j*3) Then
                        strLstDiffMsg = strLstDiffMsg & IIf(strLstDiffMsg<>"","、","") & "発症年齢"
                    End If
                    '続柄が違う
                    If vntResult(OCRGRP_START1 + 40 + i*3) <> vntLstResult(OCRGRP_START1 + 40 + j*3) Then
                        strLstDiffMsg = strLstDiffMsg & IIf(strLstDiffMsg<>"","、","") & "続柄"
                    End If
                    Exit For
                End If
            End If
        Next
        If strLstDiffMsg <> "" Then
            strLstDiffMsg = "<FONT COLOR=""red""><B>　※" & strLstDiffMsg & "違い</B></FONT>"
        End If
        strHTML = strHTML & "<TD NOWRAP>" & strLstDiffMsg & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
                    <TR>
                        <TD NOWRAP>　</TD>
                    </TR>
<%
'---前回値---
    strHTML = ""
    For i=0 To NOWDISEASE_COUNT - 1
        strLstRsl = ""
lngIndex = OCRGRP_START1 + 38 + i*3
        For j=0 To UBound(strArrCode1)
            If vntLstResult(lngIndex) = strArrCode1(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "　") & strArrName1(j)
                Exit For
            End If
        Next
lngIndex = OCRGRP_START1 + 39 + i*3
        strLstRsl =  strLstRsl & IIf(strLstRsl="", "", "　") & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "才")
lngIndex = OCRGRP_START1 + 40 + i*3
        For j=0 To UBound(strArrCode3)
            If vntLstResult(lngIndex) = strArrCode3(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "　") & strArrName3(j)
                Exit For
            End If
        Next
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
'------------
%>
                </TABLE>
            </TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee"><SPAN ID="Anchor-Stomach" STYLE="position:relative">４．胃検査を受ける方はお答え下さい</SPAN></TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（１）手術をされた方へ</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 56
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_3", , "1") & "胃全摘手術　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_3", , "2") & "胃部分切除　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "胃全摘手術"
    Case "2"
        strLstRsl = "胃部分切除"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（２）妊娠していますか。</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 57
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4", , "1") & "はい" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4", , "2") & "いいえ" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "はい"
    Case "2"
        strLstRsl = "いいえ"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">５．以前他院で指摘を受けたものがあれば、ご記入下さい。</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（１）胸部検査</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
lngIndex = OCRGRP_START1 + 58
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_51_1", , "1") & "肺結核" & vbLf
lngIndex = OCRGRP_START1 + 59
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_51_2", , "2") & "無気肺" & vbLf
lngIndex = OCRGRP_START1 + 60
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_51_3", , "3") & "肺腺維症" & vbLf
lngIndex = OCRGRP_START1 + 61
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_51_4", , "4") & "胸膜瘢痕" & vbLf
lngIndex = OCRGRP_START1 + 62
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_51_5", , "5") & "陳旧性病変" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START1 + 58
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "肺結核"
    End If
lngIndex = OCRGRP_START1 + 59
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "無気肺"
    End If
lngIndex = OCRGRP_START1 + 60
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "肺腺維症"
    End If
lngIndex = OCRGRP_START1 + 61
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "胸膜瘢痕"
    End If
lngIndex = OCRGRP_START1 + 62
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "陳旧性病変"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（２）上部消化管検査</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
lngIndex = OCRGRP_START1 + 63
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_52_1", , "1") & "食道ポリープ" & vbLf
lngIndex = OCRGRP_START1 + 64
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_52_2", , "2") & "胃新生物" & vbLf
lngIndex = OCRGRP_START1 + 65
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_52_3", , "3") & "慢性胃炎" & vbLf
lngIndex = OCRGRP_START1 + 66
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_52_4", , "4") & "胃ポリープ" & vbLf
lngIndex = OCRGRP_START1 + 67
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_52_5", , "5") & "胃潰瘍瘢痕" & vbLf
lngIndex = OCRGRP_START1 + 68
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_52_6", , "6") & "十二指腸" & vbLf
lngIndex = OCRGRP_START1 + 69
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_52_7", , "7") & "その他" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START1 + 63
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "食道ポリープ"
    End If
lngIndex = OCRGRP_START1 + 64
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "胃新生物"
    End If
lngIndex = OCRGRP_START1 + 65
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "慢性胃炎"
    End If
lngIndex = OCRGRP_START1 + 66
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "胃ポリープ"
    End If
lngIndex = OCRGRP_START1 + 67
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "胃潰瘍瘢痕"
    End If
lngIndex = OCRGRP_START1 + 68
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "十二指腸"
    End If
lngIndex = OCRGRP_START1 + 69
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（３）上腹部超音波検査</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
lngIndex = OCRGRP_START1 + 70
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_53_1", , "1") & "胆のうポリープ" & vbLf
lngIndex = OCRGRP_START1 + 71
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_53_2", , "2") & "胆石" & vbLf
lngIndex = OCRGRP_START1 + 72
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_53_3", , "3") & "肝血管腫" & vbLf
lngIndex = OCRGRP_START1 + 73
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_53_4", , "4") & "肝嚢胞" & vbLf
lngIndex = OCRGRP_START1 + 74
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_53_5", , "5") & "脂肪肝" & vbLf
lngIndex = OCRGRP_START1 + 75
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_53_6", , "6") & "腎結石" & vbLf
lngIndex = OCRGRP_START1 + 76
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_53_7", , "7") & "腎嚢胞" & vbLf
lngIndex = OCRGRP_START1 + 77
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_53_8", , "8") & "その他" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START1 + 70
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "胆のうポリープ"
    End If
lngIndex = OCRGRP_START1 + 71
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "胆石"
    End If
lngIndex = OCRGRP_START1 + 72
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "肝血管腫"
    End If
lngIndex = OCRGRP_START1 + 73
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "肝嚢胞"
    End If
lngIndex = OCRGRP_START1 + 74
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "脂肪肝"
    End If
lngIndex = OCRGRP_START1 + 75
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "腎結石"
    End If
lngIndex = OCRGRP_START1 + 76
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "腎嚢胞"
    End If
lngIndex = OCRGRP_START1 + 77
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（４）心電図検査</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
lngIndex = OCRGRP_START1 + 78
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_54_1", , "1") & "ＷＰＷ症候群" & vbLf
lngIndex = OCRGRP_START1 + 79
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_54_2", , "2") & "完全右脚ブロック" & vbLf
lngIndex = OCRGRP_START1 + 80
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_54_3", , "3") & "不完全右脚ブロック" & vbLf
lngIndex = OCRGRP_START1 + 81
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_54_4", , "4") & "不整脈" & vbLf
lngIndex = OCRGRP_START1 + 82
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_54_5", , "5") & "その他" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START1 + 78
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "ＷＰＷ症候群"
    End If
lngIndex = OCRGRP_START1 + 79
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "完全右脚ブロック"
    End If
lngIndex = OCRGRP_START1 + 80
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "不完全右脚ブロック"
    End If
lngIndex = OCRGRP_START1 + 81
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "不整脈"
    End If
lngIndex = OCRGRP_START1 + 82
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（５）乳房検査</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
lngIndex = OCRGRP_START1 + 83
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_55_1", , "1") & "乳腺症" & vbLf
lngIndex = OCRGRP_START1 + 84
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_55_2", , "2") & "繊維線種" & vbLf
lngIndex = OCRGRP_START1 + 85
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_55_3", , "3") & "その他" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START1 + 83
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "乳腺症"
    End If
lngIndex = OCRGRP_START1 + 84
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "繊維線種"
    End If
lngIndex = OCRGRP_START1 + 85
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
    </TABLE>
<!-- 
******************************************************
    生活習慣問診１
******************************************************
 -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20" >
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP WIDTH="730" BGCOLOR="#98fb98"><SPAN ID="Anchor-LifeHabit1" STYLE="position:relative">生活習慣病問診票（１）</SPAN></TD>
            <TD NOWRAP WIDTH="220" BGCOLOR="#98fb98"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（１）１８～２０歳の体重は何ｋｇでしたか。</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 0
    strHTML = strHTML & "<TD NOWRAP>　　　　　" & EditRsl(lngIndex, "text", "Rsl", 3, "") & "ｋｇ" & "</TD>" & vbLf
'---前回値---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "ｋｇ")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（２）この半年での体重の変動はどうですか。</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 1
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_1", , "1") & "2ｋｇ以上増加した　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_1", , "2") & "変動なし　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_1", , "3") & "2ｋｇ以上減少した　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "2ｋｇ以上増加した"
    Case "2"
        strLstRsl = "変動なし"
    Case "3"
        strLstRsl = "2ｋｇ以上減少した"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">２．飲酒について</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（１）週に何日飲みますか。</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 2
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_2", , "1") & "習慣的に飲む　" & vbLf
lngIndex = OCRGRP_START2 + 3
    strHTML = strHTML & "（週" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "日）　" & vbLf
lngIndex = OCRGRP_START2 + 2
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_2", , "2") & "ときどき飲む　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_2", , "3") & "飲まない　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
lngIndex = OCRGRP_START2 + 2
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "習慣的に飲む"
lngIndex = OCRGRP_START2 + 3
        If vntLstResult(lngIndex) <> "" Then
            strLstRsl = strLstRsl & "（週" & vntLstResult(lngIndex) & "日）"
        End If
    Case "2"
        strLstRsl = "ときどき飲む"
    Case "3"
        strLstRsl = "飲まない"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">３．１日の飲酒量はどのくらいですか。</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 4
    strHTML = strHTML & "<TD NOWRAP>　　　　　" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "本（ビール大瓶）</TD>" & vbLf
'---前回値---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "本（ビール大瓶）")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 5
    strHTML = strHTML & "<TD NOWRAP>　　　　　" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "本（ビール３５０ml缶）</TD>" & vbLf
'---前回値---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "本（ビール３５０ml缶）")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 6
    strHTML = strHTML & "<TD NOWRAP>　　　　　" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "本（ビール５００ml缶）</TD>" & vbLf
'---前回値---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "本（ビール５００ml缶）")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 7
    strHTML = strHTML & "<TD NOWRAP>　　　　　" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "合（日本酒）</TD>" & vbLf
'---前回値---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "本（日本酒）")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 8
    strHTML = strHTML & "<TD NOWRAP>　　　　　" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "杯（焼酎）</TD>" & vbLf
'---前回値---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "本（焼酎）")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 9
    strHTML = strHTML & "<TD NOWRAP>　　　　　" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "杯（ワイン）</TD>" & vbLf
'---前回値---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "本（ワイン）")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 10
    strHTML = strHTML & "<TD NOWRAP>　　　　　" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "杯（ウイスキー・ブランデー）</TD>" & vbLf
'---前回値---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "本（ウイスキー・ブランデー）")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 11
    strHTML = strHTML & "<TD NOWRAP>　　　　　" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "杯（その他）</TD>" & vbLf
'---前回値---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "本（その他）")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">３．たばこについて</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（１）現在の喫煙について</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 12
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_3", , "1") & "吸っている　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_3", , "2") & "吸わない　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_3", , "3") & "過去に吸っていた　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "吸っている"
    Case "2"
        strLstRsl = "吸わない"
    Case "3"
        strLstRsl = "過去に吸っていた"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（２）吸い始めた年齢</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
lngIndex = OCRGRP_START2 + 13
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "歳（吸い始めた年齢）　" & vbLf
lngIndex = OCRGRP_START2 + 14
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "歳（やめた年齢）　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
lngIndex = OCRGRP_START2 + 13
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "歳（吸い始めた年齢）")
lngIndex = OCRGRP_START2 + 14
    strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "歳（やめた年齢）")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（３）１日の喫煙本数</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
lngIndex = OCRGRP_START2 + 15
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "本" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "本")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">４．運動について</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（１）運動不足と思いますか。</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 16
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_41", , "1") & "思う　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_41", , "2") & "思わない　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "思う"
    Case "2"
        strLstRsl = "思わない"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（２）１日のおよそ何分くらい歩いてますか。</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 17
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "分" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "分")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（３）日常における身体活動はどのくらいですか。</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 18
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_43", , "1") & "よく体を動かす　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_43", , "2") & "普通に動いている　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_43", , "3") & "あまり活動的でない　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_43", , "4") & "ほとんど体を動かさない　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "よく体を動かす"
    Case "2"
        strLstRsl = "普通に動いている"
    Case "3"
        strLstRsl = "あまり活動的でない"
    Case "4"
        strLstRsl = "ほとんど体を動かさない"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（４）運動習慣は</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 19
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_44", , "1") & "ほとんど毎日　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_44", , "2") & "週３～５日　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_44", , "3") & "週１～２日　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_44", , "4") & "ほとんどしない　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "ほとんど毎日"
    Case "2"
        strLstRsl = "週３～５日"
    Case "3"
        strLstRsl = "週１～２日"
    Case "4"
        strLstRsl = "ほとんどしない"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">５．睡眠について</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　睡眠は十分ですか。</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 20
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_5", , "1") & "はい　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_5", , "2") & "寝不足を感じる　" & vbLf
lngIndex = OCRGRP_START2 + 21
    strHTML = strHTML & "　　　　" & vbLf
    strHTML = strHTML & "睡眠時間（" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "時間）　" & vbLf
lngIndex = OCRGRP_START2 + 22
    strHTML = strHTML & "就寝時刻（" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "時）　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START2 + 20
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "はい"
    Case "2"
        strLstRsl = "寝不足を感じる"
    End Select
lngIndex = OCRGRP_START2 + 21
    strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & IIf(vntLstResult(lngIndex)="", "", "睡眠時間（" & vntLstResult(lngIndex) & "時間）")
lngIndex = OCRGRP_START2 + 22
    strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & IIf(vntLstResult(lngIndex)="", "", "就寝時刻（" & vntLstResult(lngIndex) & "時）")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">６．歯磨きについて</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　歯磨きについて</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 23
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_6", , "1") & "毎食後に磨く　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_6", , "2") & "１日１回は磨く　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_6", , "3") & "１回も磨かない　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "毎食後に磨く"
    Case "2"
        strLstRsl = "１日１回は磨く"
    Case "3"
        strLstRsl = "１回も磨かない"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">７．その他の質問</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（１）あなたの現在の職業は</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 24
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_71", , "1") & "肉体頭脳を要す労働　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_71", , "2") & "主に肉体的な労働　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_71", , "3") & "主に頭脳的な労働　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_71", , "4") & "主に座り仕事　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "肉体頭脳を要す労働"
    Case "2"
        strLstRsl = "主に肉体的な労働"
    Case "3"
        strLstRsl = "主に頭脳的な労働"
    Case "4"
        strLstRsl = "主に座り仕事"
    Case "5"
        strLstRsl = "特に仕事をもっていない"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_71", , "5") & "特に仕事をもっていない　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（２）休日は何日とれますか。</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 25
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_72", , "1") & "週3日以上　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_72", , "2") & "週2日以上　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_72", , "3") & "週1日　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_72", , "4") & "月3日以下　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "週3日以上"
    Case "2"
        strLstRsl = "週2日以上"
    Case "3"
        strLstRsl = "週1日"
    Case "4"
        strLstRsl = "月3日以下"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（３）職場への主な通勤手段</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 26
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_73", , "1") & "徒歩　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_73", , "2") & "自転車　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_73", , "3") & "自動車（２輪を含む）　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_73", , "4") & "電車・バス　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "徒歩"
    Case "2"
        strLstRsl = "自転車"
    Case "3"
        strLstRsl = "自転車（２輪を含む）"
    Case "4"
        strLstRsl = "電車・バス"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（４）職場までの片道通勤時間／徒歩時間は</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 27
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "分（片道の通勤時間）　　" & vbLf
lngIndex = OCRGRP_START2 + 28
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "分（片道の歩行時間）　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
lngIndex = OCRGRP_START2 + 27
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "分（片道の通勤時間）")
lngIndex = OCRGRP_START2 + 28
    strLstRsl = strLstRsl & IIf(strLstRsl="","",", ") & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "分（片道の歩行時間）")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（５）配偶者は</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 29
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_75", , "1") & "あり　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_75", , "2") & "なし　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "あり"
    Case "2"
        strLstRsl = "なし"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（６）一緒にくらしているのは</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 30
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_76_1", , "1") & "親" & vbLf
lngIndex = OCRGRP_START2 + 31
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_76_2", , "2") & "配偶者" & vbLf
lngIndex = OCRGRP_START2 + 32
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_76_3", , "3") & "子供" & vbLf
lngIndex = OCRGRP_START2 + 33
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_76_4", , "4") & "独居" & vbLf
lngIndex = OCRGRP_START2 + 34
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_76_5", , "5") & "その他" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START2 + 30
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "親"
    End If
lngIndex = OCRGRP_START2 + 31
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "配偶者"
    End If
lngIndex = OCRGRP_START2 + 32
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "子供"
    End If
lngIndex = OCRGRP_START2 + 33
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "独居"
    End If
lngIndex = OCRGRP_START2 + 34
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（７）現在の生活に満足していますか。</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 35
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_77", , "1") & "満足している　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_77", , "2") & "やや満足している　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_77", , "3") & "やや不満　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_77", , "4") & "不満足　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "満足している"
    Case "2"
        strLstRsl = "やや満足している"
    Case "3"
        strLstRsl = "やや不満"
    Case "4"
        strLstRsl = "不満足"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（８）１年以内に大変つらい思いをしたことは</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 36
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_78", , "1") & "全く無かった　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_78", , "2") & "ややつらいことがあった　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_78", , "3") & "つらいことがあった　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_78", , "4") & "大変つらかった　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "全く無かった"
    Case "2"
        strLstRsl = "ややつらいことがあった"
    Case "3"
        strLstRsl = "つらいことがあった"
    Case "4"
        strLstRsl = "大変つらかった"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（９）信仰心について</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 37
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_79", , "1") & "ある　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_79", , "2") & "ややある　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_79", , "3") & "ほとんどない　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_79", , "4") & "まったくない　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "ある"
    Case "2"
        strLstRsl = "ややある"
    Case "3"
        strLstRsl = "ほとんどない"
    Case "4"
        strLstRsl = "まったくない"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（１０）ボランティア活動について</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 38
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_710", , "1") & "やっている　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_710", , "2") & "やったことがある　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_710", , "3") & "やりたいと思う　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_710", , "4") & "やりたくない　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "やっている"
    Case "2"
        strLstRsl = "やったことがある"
    Case "3"
        strLstRsl = "やりたいと思う"
    Case "4"
        strLstRsl = "やりたくない"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
                <TR><TD>&nbsp;</TD></TR>
<%
    strHTML = ""
    For i=0 To 5
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
<%
lngIndex = OCRGRP_START2 + 39
    '自覚症状の表示
    Call EditJikakushoujyou( lngIndex )

%>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP>　</TD>
                    </TR>
<%
'---前回値---
    strHTML = ""
    For i=0 To JIKAKUSHOUJYOU_COUNT - 1
        strLstRsl = ""
lngIndex = OCRGRP_START2 + 39 + i*4
        For j=0 To UBound(strArrCodeJikaku1)
            If vntLstResult(lngIndex) = strArrCodeJikaku1(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "　") & strArrNameJikaku1(j)
                Exit For
            End If
        Next
lngIndex = OCRGRP_START2 + 40 + i*4
        If vntLstResult(lngIndex) <> "" Then
            strLstRsl =  strLstRsl & IIf(strLstRsl="", "", "　") & vntLstResult(lngIndex)
        End If
lngIndex = OCRGRP_START2 + 41 + i*4
        For j=0 To UBound(strArrCodeJikaku3)
            If vntLstResult(lngIndex) = strArrCodeJikaku3(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "　") & strArrNameJikaku3(j)
                Exit For
            End If
        Next
lngIndex = OCRGRP_START2 + 42 + i*4
        For j=0 To UBound(strArrCodeJikaku4)
            If vntLstResult(lngIndex) = strArrCodeJikaku4(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "　") & strArrNameJikaku4(j)
                Exit For
            End If
        Next
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
'------------
%>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

<!-- 
******************************************************
    生活習慣問診２
******************************************************
 -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20">
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP WIDTH="730" BGCOLOR="#98FB98"><SPAN ID="Anchor-LifeHabit2" STYLE="position:relative">生活習慣病問診票（２）</SPAN></TD>
            <TD NOWRAP WIDTH="220" BGCOLOR="#98FB98"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">１．Ａ型行動パターン・テスト</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
<%
    strHTML = ""
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START3 + 0
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk3_1", , "1") & "<B>本人希望により未回答</B>" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", "本人希望により未回答")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    Response.Write strHTML
%>
        </TR>
        <TR>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
<%
    strHTML = ""
    For i=0 To 10
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 1
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">1)ストレス,緊張時上腹部に痛み</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_1", , "1") & "<FONT COLOR=""gray"">全くない</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_1", , "2") & "<FONT COLOR=""gray"">時にはある</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_1", , "3") & "<FONT COLOR=""gray"">しばしばある</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 2
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">2)気性は激しい方ですか｡</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_2", , "1") & "<FONT COLOR=""gray"">穏やかな方</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_2", , "2") & "<FONT COLOR=""gray"">普通</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_2", , "3") & "<FONT COLOR=""gray"">幾分激しい</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_2", , "4") & "<FONT COLOR=""gray"">非常に激しい</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 3
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">3)責任感が強いと言われた</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_3", , "1") & "<FONT COLOR=""gray"">全くない</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_3", , "2") & "<FONT COLOR=""gray"">時々ある</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_3", , "3") & "<FONT COLOR=""gray"">しばしばある</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_3", , "4") & "<FONT COLOR=""gray"">いつもある</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 4
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">4)仕事に自信を持っている</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_4", , "1") & "<FONT COLOR=""gray"">全くない</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_4", , "2") & "<FONT COLOR=""gray"">あまりない</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_4", , "3") & "<FONT COLOR=""gray"">ある</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_4", , "4") & "<FONT COLOR=""gray"">非常にある</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 5
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">5)特別に早起きして職場に行く</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_5", , "1") & "<FONT COLOR=""gray"">全くない</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_5", , "2") & "<FONT COLOR=""gray"">時々ある</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_5", , "3") & "<FONT COLOR=""gray"">しばしばある</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_5", , "4") & "<FONT COLOR=""gray"">常にある</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 6
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">6)約束の時間に遅れる方</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_6", , "1") & "<FONT COLOR=""gray"">よく遅れる</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_6", , "2") & "<FONT COLOR=""gray"">時々遅れる</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_6", , "3") & "<FONT COLOR=""gray"">決して遅れない</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_6", , "4") & "<FONT COLOR=""gray"">30分前に行く</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 7
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">7)正しいと思うことは貫く</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_7", , "1") & "<FONT COLOR=""gray"">全くない</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_7", , "2") & "<FONT COLOR=""gray"">時々ある</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_7", , "3") & "<FONT COLOR=""gray"">しばしばある</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_7", , "4") & "<FONT COLOR=""gray"">常にある</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 8
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">8)数日間旅行すると仮定</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_8", , "1") & "<FONT COLOR=""gray"">成り行き任せ</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_8", , "2") & "<FONT COLOR=""gray"">1日単位に計画</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_8", , "3") & "<FONT COLOR=""gray"">時間単位に計画</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 9
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">9)他人から指示された場合</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_9", , "1") & "<FONT COLOR=""gray"">気が楽だと思う</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_9", , "2") & "<FONT COLOR=""gray"">気にとめない</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_9", , "3") & "<FONT COLOR=""gray"">嫌な気がする</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_9", , "4") & "<FONT COLOR=""gray"">怒りを覚える</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 10
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">10)車を追い抜かれた場合</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_10", , "1") & "<FONT COLOR=""gray"">マイペース</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_10", , "2") & "<FONT COLOR=""gray"">追越し返す</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 11
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">11)帰宅時リラックスした気分</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_11", , "1") & "<FONT COLOR=""gray"">すぐになれる</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_11", , "2") & "<FONT COLOR=""gray"">比較的早く</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_11", , "3") & "<FONT COLOR=""gray"">少しイライラ</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_11", , "4") & "<FONT COLOR=""gray"">八つ当たり</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
<%
'---前回値---
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 1
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "全くない"
    Case "2"
        strLstRsl = "時にはある"
    Case "3"
        strLstRsl = "しばしばある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 2
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "穏やかな方"
    Case "2"
        strLstRsl = "普通"
    Case "3"
        strLstRsl = "幾分激しい"
    Case "4"
        strLstRsl = "非常に激しい"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 3
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "全くない"
    Case "2"
        strLstRsl = "時々ある"
    Case "3"
        strLstRsl = "しばしばある"
    Case "4"
        strLstRsl = "いつもある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 4
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "全くない"
    Case "2"
        strLstRsl = "あまりない"
    Case "3"
        strLstRsl = "ある"
    Case "4"
        strLstRsl = "非常にある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 5
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "全くない"
    Case "2"
        strLstRsl = "時々ある"
    Case "3"
        strLstRsl = "時々ある"
    Case "4"
        strLstRsl = "常にある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 6
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "よく遅れる"
    Case "2"
        strLstRsl = "時々遅れる"
    Case "3"
        strLstRsl = "決して遅れない"
    Case "4"
        strLstRsl = "30分前に行く"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 7
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "全くない"
    Case "2"
        strLstRsl = "時々ある"
    Case "3"
        strLstRsl = "しばしばある"
    Case "4"
        strLstRsl = "常にある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 8
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "成り行き任せ"
    Case "2"
        strLstRsl = "1日単位に計画"
    Case "3"
        strLstRsl = "時間単位に計画"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 9
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "気が楽だと思う"
    Case "2"
        strLstRsl = "気にとめない"
    Case "3"
        strLstRsl = "嫌な気がする"
    Case "4"
        strLstRsl = "怒りを覚える"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 10
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "マイペース"
    Case "2"
        strLstRsl = "追越し返す"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 11
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "すぐになれる"
    Case "2"
        strLstRsl = "比較的早く"
    Case "3"
        strLstRsl = "少しイライラ"
    Case "4"
        strLstRsl = "八つ当たり"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
'------------
%>
                </TABLE>
            </TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">２．ストレス・コーピングテスト</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
<%
    strHTML = ""
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START3 + 12
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk3_2", , "1") & "<B>本人希望により未回答</B></TD>" & vbLf
'---前回値---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", "本人希望により未回答")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    Response.Write strHTML
%>
        </TR>
        <TR>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
                    <TR HEIGHT="28"><TD></TD></TR>
<%
    strHTML = ""
    For i=0 To 11
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="1" CELLSPACING="2" CELLPADDING="0">
                    <TR HEIGHT="28">
                        <TD NOWRAP>　</TD>
                        <TD NOWRAP ALIGN="center">全くしない</TD>
                        <TD NOWRAP ALIGN="center">時にはある</TD>
                        <TD NOWRAP ALIGN="center">しばしばある</TD>
                        <TD NOWRAP ALIGN="center">常にある</TD>
                    </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 13
    strHTML = strHTML & "<TD NOWRAP> 1)積極的に解消しようと努力する</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_1", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_1", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_1", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_1", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 14
    strHTML = strHTML & "<TD NOWRAP> 2)自分への挑戦と受け止める </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_2", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_2", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_2", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_2", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 15
    strHTML = strHTML & "<TD NOWRAP> 3)一休みするより頑張ろうとする </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_3", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_3", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_3", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_3", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 16
    strHTML = strHTML & "<TD NOWRAP> 4)衝動買いや高価な買物をする </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_4", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_4", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_4", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_4", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 17
    strHTML = strHTML & "<TD NOWRAP> 5)同僚や家族と出歩いたり飲み食いする </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_5", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_5", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_5", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_5", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 18
    strHTML = strHTML & "<TD NOWRAP> 6)何か新しい事を始めようとする </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_6", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_6", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_6", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_6", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 19
    strHTML = strHTML & "<TD NOWRAP> 7)今の状況から抜け出る事は無理だと思う </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_7", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_7", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_7", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_7", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 20
    strHTML = strHTML & "<TD NOWRAP> 8)楽しかったことをボンヤリ考える </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_8", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_8", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_8", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_8", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 21
    strHTML = strHTML & "<TD NOWRAP> 9)どうすれば良かったのかを思い悩む </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_9", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_9", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_9", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_9", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 22
    strHTML = strHTML & "<TD NOWRAP>10)現在の状況について考えないようにする </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_10", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_10", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_10", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_10", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 23
    strHTML = strHTML & "<TD NOWRAP>11)体の調子の悪い時には病院に行こうかと思う </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_11", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_11", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_11", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_11", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 24
    strHTML = strHTML & "<TD NOWRAP>12)以前よりタバコ・酒・食事の量が増える </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_12", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_12", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_12", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_12", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
<%
'---前回値---
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 13
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "全くしない"
    Case "2"
        strLstRsl = "時にはある"
    Case "3"
        strLstRsl = "しばしばある"
    Case "4"
        strLstRsl = "常にある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 14
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "全くしない"
    Case "2"
        strLstRsl = "時にはある"
    Case "3"
        strLstRsl = "しばしばある"
    Case "4"
        strLstRsl = "常にある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 15
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "全くしない"
    Case "2"
        strLstRsl = "時にはある"
    Case "3"
        strLstRsl = "しばしばある"
    Case "4"
        strLstRsl = "常にある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 16
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "全くしない"
    Case "2"
        strLstRsl = "時にはある"
    Case "3"
        strLstRsl = "しばしばある"
    Case "4"
        strLstRsl = "常にある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 17
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "全くしない"
    Case "2"
        strLstRsl = "時にはある"
    Case "3"
        strLstRsl = "しばしばある"
    Case "4"
        strLstRsl = "常にある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 18
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "全くしない"
    Case "2"
        strLstRsl = "時にはある"
    Case "3"
        strLstRsl = "しばしばある"
    Case "4"
        strLstRsl = "常にある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 19
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "全くしない"
    Case "2"
        strLstRsl = "時にはある"
    Case "3"
        strLstRsl = "しばしばある"
    Case "4"
        strLstRsl = "常にある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 20
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "全くしない"
    Case "2"
        strLstRsl = "時にはある"
    Case "3"
        strLstRsl = "しばしばある"
    Case "4"
        strLstRsl = "常にある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 21
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "全くしない"
    Case "2"
        strLstRsl = "時にはある"
    Case "3"
        strLstRsl = "しばしばある"
    Case "4"
        strLstRsl = "常にある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 22
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "全くしない"
    Case "2"
        strLstRsl = "時にはある"
    Case "3"
        strLstRsl = "しばしばある"
    Case "4"
        strLstRsl = "常にある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 23
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "全くしない"
    Case "2"
        strLstRsl = "時にはある"
    Case "3"
        strLstRsl = "しばしばある"
    Case "4"
        strLstRsl = "常にある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 24
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "全くしない"
    Case "2"
        strLstRsl = "時にはある"
    Case "3"
        strLstRsl = "しばしばある"
    Case "4"
        strLstRsl = "常にある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
'------------
%>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

<!-- 
******************************************************
    婦人科問診
******************************************************
 -->
<% 
    '婦人科問診は女性のみ表示
    If lngGender = 2 Then
%>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20" >
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP WIDTH="730" BGCOLOR="#98fb98"><SPAN ID="Anchor-Fujinka" STYLE="position:relative">婦人科問診票</SAPN></TD>
            <TD NOWRAP WIDTH="220" BGCOLOR="#98fb98"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">1.子宮ガンの検診を受けたことは</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 0
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "1") & "6ケ月以内　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "2") & "6ケ月～1年以内　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "3") & "1～2年以内　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "4") & "3年前以上　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "5") & "受けたことなし　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "6ケ月以内"
    Case "2"
        strLstRsl = "6ケ月～1年以内"
    Case "3"
        strLstRsl = "1～2年以内"
    Case "4"
        strLstRsl = "3年前以上"
    Case "5"
        strLstRsl = "受けたことなし"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">2.検診を受けた施設は</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 1
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2", , "1") & "当院　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2", , "2") & "他集団検診　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2", , "3") & "他医院・他病院　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "当院"
    Case "2"
        strLstRsl = "他集団検診"
    Case "3"
        strLstRsl = "他医院・他病院"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">3.検診の結果は</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 2
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_3", , "1") & "異常なし　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_3", , "2") & "異常あり（異型上皮）　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_3", , "3") & "異常あり　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "異常なし"
    Case "2"
        strLstRsl = "異常あり（異型上皮）"
    Case "3"
        strLstRsl = "異常あり"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">4.婦人科の病気をしたことは</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
lngIndex = OCRGRP_START4 + 3
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_4_1", , "1") & "ない" & vbLf
lngIndex = OCRGRP_START4 + 4
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_4_2", , "4") & "膣炎" & vbLf
lngIndex = OCRGRP_START4 + 5
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_4_3", , "7") & "月経異常" & vbLf
lngIndex = OCRGRP_START4 + 6
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_4_4", , "10") & "不妊" & vbLf
lngIndex = OCRGRP_START4 + 7
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_4_5", , "2") & "子宮筋腫" & vbLf
lngIndex = OCRGRP_START4 + 8
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_4_6", , "5") & "子宮内膜症" & vbLf
lngIndex = OCRGRP_START4 + 9
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_4_7", , "8") & "子宮がん" & vbLf
lngIndex = OCRGRP_START4 + 10
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_4_8", , "11") & "子宮頚管ポリープ" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 3
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "ない"
    End If
lngIndex = OCRGRP_START4 + 4
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "膣炎"
    End If
lngIndex = OCRGRP_START4 + 5
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "月経異常"
    End If
lngIndex = OCRGRP_START4 + 6
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "不妊"
    End If
lngIndex = OCRGRP_START4 + 7
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "子宮筋腫"
    End If
lngIndex = OCRGRP_START4 + 8
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "子宮内膜症"
    End If
lngIndex = OCRGRP_START4 + 9
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "子宮がん"
    End If
lngIndex = OCRGRP_START4 + 10
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "子宮頚管ポリープ"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
lngIndex = OCRGRP_START4 + 11
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_4_9", , "3") & "卵巣腫瘍（右）" & vbLf
lngIndex = OCRGRP_START4 + 12
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_4_10", , "6") & "卵巣腫瘍（左）" & vbLf
lngIndex = OCRGRP_START4 + 13
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_4_11", , "9") & "乳がん" & vbLf
lngIndex = OCRGRP_START4 + 14
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_4_12", , "12") & "びらん" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 11
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "卵巣腫瘍（右）"
    End If
lngIndex = OCRGRP_START4 + 12
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "卵巣腫瘍（左）"
    End If
lngIndex = OCRGRP_START4 + 13
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "乳がん"
    End If
lngIndex = OCRGRP_START4 + 14
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "びらん"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">5.今までにホルモン療法を受けたことは</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 15
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5", , "1") & "なし　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5", , "2") & "ある→　" & vbLf
lngIndex = OCRGRP_START4 + 16
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "歳から" & vbLf
lngIndex = OCRGRP_START4 + 17
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "年間" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 15
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "なし"
    Case "2"
        strLstRsl = "ある→　"
lngIndex = OCRGRP_START4 + 16
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "歳から")
lngIndex = OCRGRP_START4 + 17
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "年間")
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">6.今までに病気で婦人科の手術をしたこと</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 18
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6", , "1") & "なし　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6", , "2") & "ある　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "なし"
    Case "2"
        strLstRsl = "ある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
    strHTML = ""
    For i=0 To 2
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" HEIGHT=""10"" WIDTH=""40""></TD>" & vbLf
lngIndex = OCRGRP_START4 + 19
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_6_1", , "3") & "子宮全摘術" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 20
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = OCRGRP_START4 + 21
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_6_2", , "4") & "卵巣摘出術" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 22
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 23
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_2", , "7") & "右　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_2", , "8") & "左　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_2", , "9") & "両　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_2", , "10") & "部分切除　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = OCRGRP_START4 + 24
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_6_3", , "5") & "子宮筋腫核出術" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 25
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
'---前回値---
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 19
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "子宮全摘術"
lngIndex = OCRGRP_START4 + 20
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "　" & vntLstResult(lngIndex) & "歳")
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 21
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "卵巣摘出術"
lngIndex = OCRGRP_START4 + 22
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "　" & vntLstResult(lngIndex) & "歳")
lngIndex = OCRGRP_START4 + 23
        Select Case vntLstResult(lngIndex)
        Case "7"
            strLstRsl = strLstRsl & "　右"
        Case "8"
            strLstRsl = strLstRsl & "　左"
        Case "9"
            strLstRsl = strLstRsl & "　両"
        Case "10"
            strLstRsl = strLstRsl & "　部分切除"
        End Select
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 24
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "子宮筋腫核出術"
lngIndex = OCRGRP_START4 + 25
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "　" & vntLstResult(lngIndex) & "歳")
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
'------------
%>
                </TABLE>
            </TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">7.妊娠の回数</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 26
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "回" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "回")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">8.出産の回数</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 27
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "回　" & vbLf
lngIndex = OCRGRP_START4 + 28
    strHTML = strHTML & "（そのうち帝王切開は" & EditRsl(lngIndex, "text", "Rsl", 3, "") & "回）" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
lngIndex = OCRGRP_START4 + 27
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "回")
lngIndex = OCRGRP_START4 + 28
    If vntLstResult(lngIndex)<>"" Then
        strlstRsl = strLstRsl & "　（そのうち帝王切開は" & vntLstResult(lngIndex)  & "回）"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">9．１年以内に妊娠または出産</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 29
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9", , "1") & "はい　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9", , "2") & "いいえ　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "はい"
    Case "2"
        strLstRsl = "いいえ"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">10．閉経しましたか</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 30
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_10", , "1") & "いいえ　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_10", , "2") & "はい　→" & vbLf
lngIndex = OCRGRP_START4 + 31
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 30
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "いいえ"
    Case "2"
        strLstRsl = "はい→　"
lngIndex = OCRGRP_START4 + 31
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "歳")
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">11-1．最終月経</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD><A HREF=""javascript:calGuide_showGuideCalendar('year11_1', 'month11_1', 'day11_1')""><IMG SRC=""../../images/question.gif"" WIDTH=""21"" HEIGHT=""21"" ALT=""日付ガイドを表示"" BORDER=""0""></A></TD>" & vbLf
lngIndex = OCRGRP_START4 + 32
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listyear", "year11_1", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>年</TD>" & vbLf
lngIndex = OCRGRP_START4 + 33
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listmonth", "month11_1", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>月</TD>" & vbLf
lngIndex = OCRGRP_START4 + 34
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listday", "day11_1", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>日</TD>" & vbLf
    strHTML = strHTML & "<TD>～</TD>" & vbLf
    strHTML = strHTML & "<TD><A HREF=""javascript:calGuide_showGuideCalendar('', 'month11_2', 'day11_2')""><IMG SRC=""../../images/question.gif"" WIDTH=""21"" HEIGHT=""21"" ALT=""日付ガイドを表示"" BORDER=""0""></A></TD>" & vbLf
lngIndex = OCRGRP_START4 + 35
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listmonth", "month11_2", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>月</TD>" & vbLf
lngIndex = OCRGRP_START4 + 36
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listday", "day11_2", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>日</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
<%
'---前回値---
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 32
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "年")
lngIndex = OCRGRP_START4 + 33
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "月")
lngIndex = OCRGRP_START4 + 34
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "日")
    strLstRsl = strLstRsl & "～"
lngIndex = OCRGRP_START4 + 35
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "月")
lngIndex = OCRGRP_START4 + 36
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "日")
    If strLstRsl = "～" Then
        strLstRsl = ""
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
'------------
%>
                </TABLE>
            </TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">11-2．その前の月経</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD><A HREF=""javascript:calGuide_showGuideCalendar('year11_3', 'month11_3', 'day11_3')""><IMG SRC=""../../images/question.gif"" WIDTH=""21"" HEIGHT=""21"" ALT=""日付ガイドを表示"" BORDER=""0""></A></TD>" & vbLf
lngIndex = OCRGRP_START4 + 37
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listyear", "year11_3", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>年</TD>" & vbLf
lngIndex = OCRGRP_START4 + 38
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listmonth", "month11_3", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>月</TD>" & vbLf
lngIndex = OCRGRP_START4 + 39
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listday", "day11_3", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>日</TD>" & vbLf
    strHTML = strHTML & "<TD>～</TD>" & vbLf
    strHTML = strHTML & "<TD><A HREF=""javascript:calGuide_showGuideCalendar('', 'month11_4', 'day11_4')""><IMG SRC=""../../images/question.gif"" WIDTH=""21"" HEIGHT=""21"" ALT=""日付ガイドを表示"" BORDER=""0""></A></TD>" & vbLf
lngIndex = OCRGRP_START4 + 40
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listmonth", "month11_4", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>月</TD>" & vbLf
lngIndex = OCRGRP_START4 + 41
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listday", "day11_4", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>日</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
<%
'---前回値---
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 37
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "年")
lngIndex = OCRGRP_START4 + 38
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "月")
lngIndex = OCRGRP_START4 + 39
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "日")
    strLstRsl = strLstRsl & "～"
lngIndex = OCRGRP_START4 + 40
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "月")
lngIndex = OCRGRP_START4 + 41
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "日")
    If strLstRsl = "～" Then
        strLstRsl = ""
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
'------------
%>
                </TABLE>
            </TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">11-3．月経周期</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 42
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 2, "") & "日　" & vbLf
lngIndex = OCRGRP_START4 + 43
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_11_3", , "1") & "不規則" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
lngIndex = OCRGRP_START4 + 42
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "日")
lngIndex = OCRGRP_START4 + 43
    If vntLstResult(lngIndex)="1" Then
        strLstRsl = strLstRsl & "　不規則"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">11-4．月経期間</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 44
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 2, "") & "日　" & vbLf
lngIndex = OCRGRP_START4 + 45
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_11_4", , "1") & "不規則" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
lngIndex = OCRGRP_START4 + 44
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "日")
lngIndex = OCRGRP_START4 + 45
    If vntLstResult(lngIndex)="1" Then
        strLstRsl = strLstRsl & "　不規則"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">11-5．月経時の出血量</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 46
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_11_5", , "1") & "少ない　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_11_5", , "2") & "普通　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_11_5", , "3") & "多い　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "少ない"
    Case "2"
        strLstRsl = "普通"
    Case "3"
        strLstRsl = "多い"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">11-6．月経時、下腹部や腰部に痛みはありますか</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 47
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_11_6", , "1") & "ない、又は軽い痛み　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_11_6", , "2") & "強い痛みが時々ある　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_11_6", , "3") & "毎回ひどい痛みがある　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "ない、又は軽い痛み"
    Case "2"
        strLstRsl = "強い痛みが時々ある"
    Case "3"
        strLstRsl = "毎回ひどい痛みがある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">12．今まで月経以外に出血したことはありますか</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 48
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_12", , "1") & "ない　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_12", , "2") & "１年以内にある　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_12", , "3") & "１年以上前にある　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "ない"
    Case "2"
        strLstRsl = "１年以内にある"
    Case "3"
        strLstRsl = "１年以上前にある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">13．その他気になる症状はありますか</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
lngIndex = OCRGRP_START4 + 49
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_13_1", , "1") & "ない" & vbLf
lngIndex = OCRGRP_START4 + 50
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_13_2", , "2") & "おりものが気になる" & vbLf
lngIndex = OCRGRP_START4 + 51
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_13_3", , "3") & "陰部がかゆい" & vbLf
lngIndex = OCRGRP_START4 + 52
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_13_4", , "4") & "下腹部が痛い" & vbLf
lngIndex = OCRGRP_START4 + 53
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_13_5", , "5") & "更年期症状がつらい" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 49
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "ない"
    End If
lngIndex = OCRGRP_START4 + 50
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "おりものが気になる"
    End If
lngIndex = OCRGRP_START4 + 51
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "陰部がかゆい"
    End If
lngIndex = OCRGRP_START4 + 52
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "下腹部が痛い"
    End If
lngIndex = OCRGRP_START4 + 53
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "更年期症状がつらい"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
lngIndex = OCRGRP_START4 + 54
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_13_6", , "6") & "性交時に出血する" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 54
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "性交時に出血する"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">14．現在、性生活はありますか</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 55
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14", , "1") & "ない　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14", , "2") & "ある　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "ない"
    Case "2"
        strLstRsl = "ある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">15．ご家族で婦人科系のガンにかかられた方は</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
lngIndex = OCRGRP_START4 + 56
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_15_1", , "1") & "いない" & vbLf
lngIndex = OCRGRP_START4 + 57
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_15_2", , "2") & "実母" & vbLf
lngIndex = OCRGRP_START4 + 58
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_15_3", , "3") & "実姉妹" & vbLf
lngIndex = OCRGRP_START4 + 59
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_15_4", , "4") & "その他" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 56
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "いない"
    End If
lngIndex = OCRGRP_START4 + 57
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実母"
    End If
lngIndex = OCRGRP_START4 + 58
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実姉妹"
    End If
lngIndex = OCRGRP_START4 + 59
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
lngIndex = OCRGRP_START4 + 60
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_15_5", , "5") & "子宮体ガン" & vbLf
lngIndex = OCRGRP_START4 + 61
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_15_6", , "6") & "子宮頚ガン" & vbLf
lngIndex = OCRGRP_START4 + 62
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_15_7", , "7") & "卵巣ガン" & vbLf
lngIndex = OCRGRP_START4 + 63
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_15_8", , "8") & "乳がん" & vbLf
lngIndex = OCRGRP_START4 + 64
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_15_9", , "9") & "その他の婦人科系ガン" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 60
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "子宮体ガン"
    End If
lngIndex = OCRGRP_START4 + 61
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "子宮頚ガン"
    End If
lngIndex = OCRGRP_START4 + 62
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "卵巣ガン"
    End If
lngIndex = OCRGRP_START4 + 63
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "乳がん"
    End If
lngIndex = OCRGRP_START4 + 64
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他の婦人科系ガン"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
    </TABLE>
<%
    Else
        strHTML = ""
        For i = 1 To 24
            strHTML = strHTML & EditErrInfo
        Next
        Response.Write strHTML
    End If
%>
<!-- 
******************************************************
    食習慣問診
******************************************************
 -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20">
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP WIDTH="956" BGCOLOR="#98FB98"><SPAN ID="Anchor-Syokusyukan" STYLE="position:relative">食習慣問診票</SPAN></TD>
        </TR>
        <TR HEIGHT="20">
<%
    strHTML = ""
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START5 + 0
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk5_1", , "1") & "<B>本人希望により未回答</B></TD>" & vbLf
    Response.Write strHTML
%>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">１．摂取エネルギーについて</TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　カロリー制限を受けていますか</TD>
        </TR>
        <TR HEIGHT="20">
<%
    strHTML = ""
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >　" & vbLf
lngIndex = OCRGRP_START5 + 1
    strHTML = strHTML & "　" & EditRsl(lngIndex, "radio", "opt5_1", , "1") & "はい" & vbLf
lngIndex = OCRGRP_START5 + 2
    strHTML = strHTML & "　" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "kcal" & vbLf
lngIndex = OCRGRP_START5 + 1
    strHTML = strHTML & "　" & EditRsl(lngIndex, "radio", "opt5_1", , "2") & "いいえ" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    Response.Write strHTML
%>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">２．食習慣に当てはまるもの</TD>
        </TR>
        <TR>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
    strHTML = ""
    For i=0 To 8
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 3
    strHTML = strHTML & "<TD NOWRAP>1)食事の速度は速いほうですか</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_1", , "1") & "速いほうである</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_1", , "2") & "それほどでもない</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 4
    strHTML = strHTML & "<TD NOWRAP>2)満腹になるまで食べるほうですか</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_2", , "1") & "そうである</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_2", , "2") & "それほどでもない</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 5
    strHTML = strHTML & "<TD NOWRAP>3)食事の規則性は</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_3", , "1") & "規則正しい</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_3", , "2") & "それほどでもない</TD>" & vbLf
lngIndex = OCRGRP_START5 + 6
    strHTML = strHTML & "<TD NOWRAP>（１週間の平均欠食回数" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "回）</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 7
    strHTML = strHTML & "<TD NOWRAP>4)バランスを考えて食べていますか</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_4", , "1") & "考えている</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_4", , "2") & "それほどでもない</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 8
    strHTML = strHTML & "<TD NOWRAP>5)甘いものはよく食べますか</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_5", , "1") & "よく食べる</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_5", , "2") & "それほどでもない</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 9
    strHTML = strHTML & "<TD NOWRAP>6)脂肪分の多い食事は好んで食べますか</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_6", , "1") & "好んで食べる</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_6", , "2") & "それほどでもない</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 10
    strHTML = strHTML & "<TD NOWRAP>7)味付けは濃いほうですか</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_7", , "1") & "濃い方である</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_7", , "2") & "ふつう</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_7", , "3") & "薄味にしている</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 11
    strHTML = strHTML & "<TD NOWRAP>8)間食をとることがありますか</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_8", , "1") & "食べない</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_8", , "2") & "食べる</TD>" & vbLf
lngIndex = OCRGRP_START5 + 12
    strHTML = strHTML & "<TD NOWRAP>（１週間の平均間食回数" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "回）</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 13
    strHTML = strHTML & "<TD NOWRAP>9)減塩醤油はお使いですか</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_9", , "1") & "使っている</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_9", , "2") & "使っていない</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">３．１日の嗜好品摂取量</TD>
        </TR>
        <TR>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
    strHTML = ""
    For i=0 To 8
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 14
    strHTML = strHTML & "<TD NOWRAP>コーヒー・紅茶</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 23
    strHTML = strHTML & "<TD NOWRAP>あめ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 15
    strHTML = strHTML & "<TD NOWRAP>　砂糖（小さじ）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 24
    strHTML = strHTML & "<TD NOWRAP>チョコレート</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "片</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 16
    strHTML = strHTML & "<TD NOWRAP>　ミルク（小さじ）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "杯</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 25
    strHTML = strHTML & "<TD NOWRAP>スナック菓子</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "皿</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 17
    strHTML = strHTML & "<TD NOWRAP>ジュース（スポーツ飲料も含む）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "00ml</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 26
    strHTML = strHTML & "<TD NOWRAP>ナッツ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "皿（ひとつかみ）</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 18
    strHTML = strHTML & "<TD NOWRAP>果汁・野菜ジュース</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "00ml</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 27
    strHTML = strHTML & "<TD NOWRAP>和菓子（まんじゅうなど）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 19
    strHTML = strHTML & "<TD NOWRAP>炭酸飲料</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "00ml</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 28
    strHTML = strHTML & "<TD NOWRAP>洋菓子（ケーキなど）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 20
    strHTML = strHTML & "<TD NOWRAP>アイス</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 29
    strHTML = strHTML & "<TD NOWRAP>ドーナツ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 21
    strHTML = strHTML & "<TD NOWRAP>シャーベット</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 30
    strHTML = strHTML & "<TD NOWRAP>ゼリー</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 22
    strHTML = strHTML & "<TD NOWRAP>クッキー</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "個</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 31
    strHTML = strHTML & "<TD NOWRAP>せんべい（あられ）</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "枚（ひとつかみ）</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">４．乳製品の１日摂取量</TD>
        </TR>
        <TR>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
    strHTML = ""
    For i=0 To 1
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 32
    strHTML = strHTML & "<TD NOWRAP>普通牛乳</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "00ml</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 34
    strHTML = strHTML & "<TD NOWRAP>低脂肪牛乳</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "00ml</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 33
    strHTML = strHTML & "<TD NOWRAP>普通ヨーグルト</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "00ml</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 35
    strHTML = strHTML & "<TD NOWRAP>低脂肪ヨーグルト</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "00ml</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    
<!-- 
******************************************************
    朝食
******************************************************
 -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20">
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP WIDTH="956" BGCOLOR="#98FB98"><SPAN ID="Anchor-Morning" STYLE="position:relative">朝食について</SPAN></TD>
        </TR>
        <TR HEIGHT="20">	
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（１）毎日食べていますか</TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
lngIndex = OCRGRP_START6 + 0
    strHTML = strHTML & "　" & EditRsl(lngIndex, "radio", "opt6_1", , "1") & "食べる" & vbLf
    strHTML = strHTML & "　" & EditRsl(lngIndex, "radio", "opt6_1", , "2") & "時々食べる" & vbLf
    strHTML = strHTML & "　" & EditRsl(lngIndex, "radio", "opt6_1", , "3") & "食べない" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

    '献立の編集
    Call EditMenuList( OCRGRP_START6 )
%>
    </TABLE>

<!-- 
******************************************************
    昼食
******************************************************
 -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20">
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP WIDTH="956" BGCOLOR="#98FB98"><SPAN ID="Anchor-Lunch" STYLE="position:relative">昼食について</SPAN></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（１）毎日食べていますか</TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""950"">　　" & vbLf
lngIndex = OCRGRP_START7 + 0
    strHTML = strHTML & "　" & EditRsl(lngIndex, "radio", "opt7_1", , "1") & "食べる" & vbLf
    strHTML = strHTML & "　" & EditRsl(lngIndex, "radio", "opt7_1", , "2") & "時々食べる" & vbLf
    strHTML = strHTML & "　" & EditRsl(lngIndex, "radio", "opt7_1", , "3") & "食べない" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

    '献立の編集
    Call EditMenuList( OCRGRP_START7 )
%>
    </TABLE>

<!-- 
******************************************************
    夕食
******************************************************
 -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20">
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP WIDTH="956" BGCOLOR="#98FB98"><SPAN ID="Anchor-Dinner" STYLE="position:relative">夕食について</SPAN></TD>
        </TR>
        <TR HEIGHT="20">	
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（１）毎日食べていますか</TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""950"">　　" & vbLf
lngIndex = OCRGRP_START8 + 0
    strHTML = strHTML & "　" & EditRsl(lngIndex, "radio", "opt8_1", , "1") & "食べる" & vbLf
    strHTML = strHTML & "　" & EditRsl(lngIndex, "radio", "opt8_1", , "2") & "時々食べる" & vbLf
    strHTML = strHTML & "　" & EditRsl(lngIndex, "radio", "opt8_1", , "3") & "食べない" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

    '献立の編集
    Call EditMenuList( OCRGRP_START8 )
%>
    </TABLE>


<!-- 
******************************************************
    特定健診
******************************************************
 -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20">
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP WIDTH="956" BGCOLOR="#98FB98"><SPAN ID="Anchor-Special" STYLE="position:relative">特定健診問診票</SPAN></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">運動や食生活等の生活習慣を改善してみようと思いますか</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START9 + 0
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt9_1", , "1") & "①改善するつもりはない<br>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt9_1", , "2") & "②改善するつもりである（概ね6ヶ月以内）<br>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt9_1", , "3") & "③近いうちに（概ね1ヶ月以内）改善するつもりであり、少しずつはじめている<br>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt9_1", , "4") & "④既に改善に取り組んでいる（6ヶ月未満）<br>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt9_1", , "5") & "⑤既に改善に取り組んでいる（6ヶ月以上）<br>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt9_1", , "6") & "未回答" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "①改善するつもりはない"
    Case "2"
        strLstRsl = "②改善するつもりである（概ね6ヶ月以内）"
    Case "3"
        strLstRsl = "③近いうちに（概ね1ヶ月以内）改善するつもりであり、少しずつはじめている"
    Case "4"
        strLstRsl = "④既に改善に取り組んでいる（6ヶ月未満）"
    Case "5"
        strLstRsl = "⑤既に改善に取り組んでいる（6ヶ月以上）"
    Case "6"
        strLstRsl = "未回答"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">生活習慣の改善について保健指導を受ける機会があれば、利用しますか</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START9 + 1
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt9_2", , "1") & "①はい" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt9_2", , "2") & "②いいえ" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt9_2", , "3") & "未回答" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "①改善するつもりはない"
    Case "2"
        strLstRsl = "②改善するつもりである（概ね6ヶ月以内）"
    Case "3"
        strLstRsl = "未回答"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
    
    </TABLE>

<!-- 
******************************************************
    OCR入力担当者
******************************************************
 -->
    <BR><BR>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20">
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP><SPAN ID="Anchor-Operator" STYLE="position:relative">OCR入力担当者</SPAN></TD>
<%
lngIndex = OCRGRP_START10 + 0

    '未設定の場合はログインユーザをデフォルトとする
    If vntResult(lngIndex) = "" Then
        Set objHainsUser = Server.CreateObject("HainsHainsUser.HainsUser")
        objHainsUser.SelectHainsUser Session("USERID"), strOpeNameStc, _
                                     , , , , , , , , , , _
                                     , , , , , , , , , , _
                                     , , , , , , strOpeNameStcCd
        Set objHainsUser = Nothing

        vntResult(lngIndex) = strOpeNameStcCd
    End If

    If vntResult(lngIndex) <> "" Then
        'OCR入力担当者の名称取得
        Set objSentence = Server.CreateObject("HainsSentence.Sentence")
        objSentence.SelectSentence vntItemCd(lngIndex), 0, vntResult(lngIndex), strOpeNameStc, _
                                    , , , , , , , , , 1, "00"

        Set objSentence = Nothing
    Else
        strOpeNameStc = "※設定なし"
    End If
%>
            <TD><A HREF="javascript:showUserWindow(<%= lngIndex %>, '30960')"><IMG SRC="../../images/question.gif" ALT="" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
            <TD><A HREF="javascript:clrUser(<%= lngIndex %>)"><IMG SRC="../../images/delicon.gif" ALT="" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
            <TD NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="5" HEIGHT="1"></TD>
            <TD NOWRAP><SPAN ID="OpeName"><%= strOpeNameStc %></SPAN></TD>
        </TR>
    </TABLE>

<%
    '保存用
    strHtml = ""
    For i=0 To lngRslCnt-1
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""ItemCd"" VALUE=""" & vntItemCd(i) & """>"
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""Suffix"" VALUE=""" & vntSuffix(i) & """>"
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""OrgRsl"" VALUE=""" & vntResult(i) & """>"
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""ChgRsl"" VALUE=""" & vntResult(i) & """>"
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""StopFlg"" VALUE=""" & vntStopFlg(i) & """>"
    Next
    Response.Write(strHtml)
%>
</FORM>
</BODY>
</HTML>
<%
'-----表示完了処理----- 
%>
<SCRIPT TYPE="text/javascript">
<!--
    var myForm =    document.entryForm;
    var ElementId;
    var strHtml;
    var i;

    // エラー情報の表示
    if( !isNaN(parent.lngErrCount) ) {
        for( i=0; i<parent.lngErrCount; i++ ) {
            if( parent.varErrNo[i] > 0 ) {

                switch ( parent.varErrState[i] ) {
                case 1:     // エラー
                    strHtml = '<IMG SRC="../../images/ico_e.gif" WIDTH="16" HEIGHT="16" ALT="' + parent.varErrMessage[i] + '" BORDER="0">';
                    break;
                case 2:     // 警告
                    strHtml = '<IMG SRC="../../images/ico_w.gif" WIDTH="16" HEIGHT="16" ALT="' + parent.varErrMessage[i] + '" BORDER="0">';
                    break;
                default:
                    strHtml = '&nbsp;';
                }

                // マークを表示
                ElementId = "Anchor-ErrInfo" + parent.varErrNo[i];
                if( document.all ) {
                    document.all(ElementId).innerHTML = strHtml;
                }else if( document.getElementById ) {
                    document.getElementById(ElementId).innerHTML = strHtml;
                }
            }
        }
    }

    // 下のフレームのエラーリスト表示
    if( document.entryForm.act.value != '' ) {
        parent.error.document.entryForm.selectState.selectedIndex = 2;
        parent.error.chgSelect();
    }

    // 処理中メッセージの消去
    if( document.getElementById ) {
        document.getElementById('LoadindMessage').innerHTML = '';
    }

    
    // 表示開始位置にジャンプ
    JumpAnchor();

    if( document.entryForm.act.value == 'check' && <%= lngErrCnt_E %> == 0 && <%= lngErrCnt_W %> > 0 ) {

        if( confirm('警告がありますが、このまま保存しますか？') ) {
            // モードを指定してsubmit
            document.entryForm.act.value = 'save';
            document.entryForm.submit();
        }
    }
//-->
</SCRIPT>
