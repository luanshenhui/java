<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      OCR入力結果確認（ボディ）  (Ver0.0.1)
'      AUTHER  :
'-----------------------------------------------------------------------------
'管理番号：SL-UI-Y0101-103
'修正日  ：2010.06.03（新規作成）
'担当者  ：TCS)田村
'修正内容：ＯＣＲシート変更対応
'管理番号：SL-SN-Y0101-607
'修正日  ：2011.12.22
'担当者  ：SOAR)竹野内
'修正内容：前回複写ボタン

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
Const GRPCD_OCRNYURYOKU2 = "X0341"   'OCR入力結果確認グループコード
Const GRPCD_ALLERGY = "X052"        '薬アレルギーグループコード

'### 取得した検査結果の先頭位置[0～]
Const OCRGRP_START1 =   0   '現病歴既往歴
Const OCRGRP_START2 =  90   '生活習慣問診１
Const OCRGRP_START3 = 151   '生活習慣問診２
Const OCRGRP_START4 = 176   '婦人科問診
Const OCRGRP_START5 = 290   '食習慣問診
Const OCRGRP_START6 = 326   '朝食
Const OCRGRP_START7 = 409   '昼食
Const OCRGRP_START8 = 492   '夕食
Const OCRGRP_START9 = 575   '特定健診
Const OCRGRP_START10 = 577   'OCR入力担当者
Const OCRGRP_START_Z = 578   '前コード用　前回値出力用(一部の項目)

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
Set objRslOcrSp     = Server.CreateObject("HainsRslOcrSp2.OcrNyuryokuSp2")

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
                            GRPCD_OCRNYURYOKU2, _
                            2, _
                            "MONSHIN", _
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
                                GRPCD_OCRNYURYOKU2, _
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
                                    GRPCD_OCRNYURYOKU2, _
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
                                    GRPCD_OCRNYURYOKU2, _
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
'### 2010.12.18 MOD STR TCS)H.F
'strArrCode1 = Array( _
'                    "1",  "2",  "3",  "4",  "5",  "6",  "7",  "8",  "9",  "10", _
'                    "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", _
'                    "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", _
'                    "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", _
'                    "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", _
'                    "51", "52", "53", "54", "55", _
'                    "98", "99", _
'                    "101", "102", "103", "104", "105", "106", "107", "108", "109",_
'                    "201", "202", "203", "204", "205", "206", "207", "208", "209", "210", _
'                    "211", "212", "213", "214", "215", "216", "217", _
'                    "XXX" _
'                    )
'strArrName1 = Array( _
'                    "脳腫瘍", "脳梗塞", "クモ膜下出血", "脳出血", "一過性脳虚血発作", "緑内障", "白内障", "糖尿病網膜症", "その他の眼科疾患", "甲状腺機能低下症", _
'                    "甲状腺機能亢進症", "結核・胸膜炎", "肺がん", "肺線維症", "肺気腫", "気管支ぜんそく", "気管支拡張症", "慢性気管支炎", "高血圧", "狭心症", _
'                    "心筋梗塞", "心房中隔欠損症", "心室中隔欠損症", "心臓弁膜症", "不整脈", "食道がん", "胃がん", "胃潰瘍", "胃ポリープ", "十二指腸潰瘍", _
'                    "大腸がん", "大腸ポリープ", "虫垂炎", "痔", "胆石症", "胆のうポリープ", "慢性膵炎", "肝がん", "Ｂ型肝炎", "Ｃ型肝炎", _
'                    "肝硬変", "腎炎・ネフローゼ", "腎結石", "尿路結石", "前立腺がん", "前立腺肥大", "脂質異常症（高脂血症）", "糖尿病", "血液疾患", "貧血", _
'                    "痛風・高尿酸血症", "神経症", "うつ病", "扁桃腺炎", "慢性腎不全", _
'                    "その他", "その他のがん", _
'                    "子宮頚がん", "子宮体がん", "卵巣嚢腫（腫瘍）", "子宮内膜症", "子宮筋腫", "子宮細胞診異常", "乳がん", "乳腺症", "更年期障害", _
'                    "甲状腺疾患", "膠原病", "急性膵炎", "大動脈瘤", "腸閉塞", "腎不全", "前立腺ＰＳＡ高値", "その他の心疾患", "その他の神経筋疾患", "その他の上部消化管疾患", _
'                    "その他の大腸疾患", "その他の肝疾患", "その他の前立腺疾患", "その他の乳房疾患", "皮膚科疾患", "耳鼻科疾患", "整形外科疾患", _
'                    "※入力異常" _
'                    )
strArrCode1 = Array( _
                    "1",  "2",  "3",  "4",  "5",  "6",  "7",  "8",  "9",  "10", _
                    "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", _
                    "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", _
                    "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", _
                    "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", _
                    "51", "52", "53", "54", "55", _
                    "56", "57", "58", "59", "60", "61", "62", "63", "65", "66", _
                    "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", _
                    "98", "99", _
                    "101", "102", "103", "104", "105", "106", "107", "108", "109",_
                    "110", "111", "112", "113", "114", "115",_
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
                    "パーキンソン", "肺炎", "慢性閉塞性肺疾患（COPD）：肺気腫を含む", "間質性肺炎", "気胸", "睡眠時無呼吸症候群", "非定型（非結核性）抗酸菌症", "糖尿病・高血糖", "食道静脈瘤", "逆流性食道炎", _
                    "食道ポリープ", "ヘリコバクターピロリ感染症", "潰瘍性腸炎", "クローン病", "虚血性腸炎", "アルコール性肝障害", "脂肪肝", "難聴", "骨折", "骨粗しょう症", _
                    "その他", "その他のがん", _
                    "子宮頚がん", "子宮体がん", "卵巣嚢腫（腫瘍）", "子宮内膜症", "子宮筋腫", "子宮細胞診異常", "乳がん", "乳腺症", "更年期障害", _
                    "子宮頸部細胞診異常", "子宮体部（内膜）細胞診異常", "内性子宮内膜症（子宮腺筋症）", "外性子宮内膜症（卵巣チョコレート嚢腫・子宮内膜症の", "卵巣腫瘍(悪性・がん・中間群・境界型)", "卵巣腫瘍（良性）", _
                    "甲状腺疾患", "膠原病", "急性膵炎", "大動脈瘤", "腸閉塞", "腎不全", "前立腺ＰＳＡ高値", "その他の心疾患", "その他の神経筋疾患", "その他の上部消化管疾患", _
                    "その他の大腸疾患", "その他の肝疾患", "その他の前立腺疾患", "その他の乳房疾患", "皮膚科疾患", "耳鼻科疾患", "整形外科疾患", _
                    "※入力異常" _
                    )
'### 2010.12.18 MOD END TCS)H.F

'*** 治療状況 ***
''### 2010.12.18 MOD STR TCS)H.F
'strArrCode2 = Array( _
'                    "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11",_
'                    "XXX" _
'                    )
'strArrName2 = Array( _
'                    "手術後薬剤治療中", _
'                    "手術後薬剤なし受診中", _
'                    "内視鏡下切除後薬剤治療中", _
'                    "内視鏡下切除後薬剤なし受診中", _
'                    "薬剤治療中", _
'                    "薬剤なし受診中", _
'                    "手術後治療終了", _
'                    "内視鏡下切除後治療終了", _
'                    "治療終了", _
'                    "放置あるいは治療中断", _
'                    "透析治療中", _
'                    "※入力異常" _
'                    )
strArrCode2 = Array( _
                    "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11","12","13","14",_
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
                    "腹腔鏡下切除後・薬剤治療中", _
                    "腹腔鏡下切除後・薬剤なし受診中", _
                    "腹腔鏡下切除後・治療終了", _
                    "※入力異常" _
                    )
''### 2010.12.18 MOD END TCS)H.F
'*** 続柄 ***
''### 2010.12.18 MOD STR TCS)H.F
'strArrCode3 = Array( _
'                    "1", "2", "3", "4", _
'                    "XXX" _
'                    )
'strArrName3 = Array( _
'                    "父親", _
'                    "母親", _
'                    "兄弟・姉妹", _
'                    "祖父母", _
'                    "※入力異常" _
'                    )
strArrCode3 = Array( _
                    "1", "2", "3", "4", "5", _
                    "XXX" _
                    )
strArrName3 = Array( _
                    "父親", _
                    "母親", _
                    "兄弟・姉妹", _
                    "祖父母", _
                    "おじ・おば", _
                    "※入力異常" _
                    )
''### 2010.12.18 MOD END TCS)H.F

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
                /*** 婦人科問診票のNo.7の「なし」のチェックが他の項目を選択した時に自動的に消える ***/
                lngIndex = <%= OCRGRP_START4 %>;
                if ( Index >= lngIndex + 19 && Index <= lngIndex + 33 ) {
                    document.entryForm.chk4_7_1.checked = false;
                    document.entryForm.ChgRsl[194].value = '';
                }
                ///*************************************************************************************/
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

// SL-UI-Y0101-607 前回複写ボタン追加 ADD STR
//前回複写
function copyOcrNyuryoku() {
    var myForm = document.entryForm;
    var i, j, n;
    var index;                    //病歴データ配列のインデックス
    var cntPreByoureki;           //前回値の件数
    var cntInputedByoreki;        //今回入力欄の件数
    var isOver;                   //今回入力欄の病歴件数が6件かどうかフラグ
    var iconNo = 2;               //メッセージ種別（2=警告）    
    var cntByoreki = new Array(); //現病歴、既往歴、過去歴の登録できる病歴の最大数
    var idxChgRsls = new Array(); //          〃          のインデックス
    var arErrNo = new Array();    //          〃          のエラー行番号
    var arErrMsg = new Array();   //          〃          のエラーメッセージ
    var arCopyByorekiIdx = new Array();//前回値配列の複写済みの病歴インデックス
    var arCopyByorekiCd = new Array(); //複写済み病歴コード

    //病歴数最大値
    cntByoreki = new Array(<%= NOWDISEASE_COUNT %>,<%= DISEASEHIST_COUNT %>,<%= FAMILYHIST_COUNT %>);
    //病歴データ配列のインデックス
    idxChgRsls = new Array(<%= OCRGRP_START1 %> + 5,<%= OCRGRP_START1 %> + 23,<%= OCRGRP_START1 %> + 41);
    //エラー行番号
    arErrNo = new Array(4,10,16);
    //エラーメッセージ
    arErrMsg = new Array('「現病歴」は6件より多く登録できません。','「既往歴」は6件より多く登録できません。','「家族歴」は6件より多く登録できません。');
    
    for(n = 0; n < cntByoreki.length; n++){

        //病歴数オーバーの警告メッセージがあればを削除
        parent.delErrInfo(arErrNo[n], iconNo, arErrMsg[n]);
        document.getElementById("Anchor-ErrInfo"+arErrNo[n]).innerHTML = '';
        
        //処理用変数を初期化
        index = idxChgRsls[n];
        isOver = new Boolean(false);
        cntInputedByoreki = 0;
        cntPreByoureki = 0;
        arCopyByorekiIdx = new Array();
        arCopyByorekiCd = new Array();

        //前回値の件数を取得
        for( i=0; i< cntByoreki[n]; i++ ) {
            if( myForm.PreRsl[index+i*3+0].value != ''){
                cntPreByoureki++;
            }
        }

        //-----------------------------------------------------------------
        //入力チェック
        //・前回値が0件
        //  →何もする必要なし
        //・前回値が1件以上
        //  →ひとつずつチェックして、複写
        //-----------------------------------------------------------------
        if (cntPreByoureki < 1) {
            //何もする必要ない

        }else{

            //今回入力欄 + 前回値 = 12回ループ
            for(idxChgRsl = 0; idxChgRsl < cntByoreki[n] * 2; idxChgRsl++) { 

                //今回入力欄が入力されているか判定
                if((idxChgRsl < 6) && 
                   (myForm.ChgRsl[index+idxChgRsl*3+0].value != '' || 
                    myForm.ChgRsl[index+idxChgRsl*3+1].value != '' || 
                    myForm.ChgRsl[index+idxChgRsl*3+2].value != '')) {
                    //そのまま、病歴数をカウントアップ
                    cntInputedByoreki ++;
                } else {

                    if(idxChgRsl < 6){
                        //ChgRslを初期化
                        for( j=0; j<3; j++ ) {
                            myForm.ChgRsl[index+idxChgRsl*3+j].value = "";
                        }
                    }
                        
                    //前回値の数分ループ
                    for( idxPreRsl=0; idxPreRsl< cntByoreki[n]; idxPreRsl++ ) {

                        //前回値の有無をチェック
                        if( myForm.PreRsl[index+idxPreRsl*3+0].value != '') {

                            //下記のいずれかなら複写対象となる
                            //・前回値が今回入力欄に存在しない
                            //・すでに複写した前回値と同じ病歴
                            if(((myForm.ChgRsl[index+0*3+0].value != myForm.PreRsl[index+idxPreRsl*3+0].value) &&
                                (myForm.ChgRsl[index+1*3+0].value != myForm.PreRsl[index+idxPreRsl*3+0].value) &&
                                (myForm.ChgRsl[index+2*3+0].value != myForm.PreRsl[index+idxPreRsl*3+0].value) &&
                                (myForm.ChgRsl[index+3*3+0].value != myForm.PreRsl[index+idxPreRsl*3+0].value) &&
                                (myForm.ChgRsl[index+4*3+0].value != myForm.PreRsl[index+idxPreRsl*3+0].value) &&
                                (myForm.ChgRsl[index+5*3+0].value != myForm.PreRsl[index+idxPreRsl*3+0].value)) ||
                               ((arCopyByorekiCd.length > 0) &&
                                (arCopyByorekiIdx[0] != idxPreRsl) &&
                                (arCopyByorekiIdx[1] != idxPreRsl) &&
                                (arCopyByorekiIdx[2] != idxPreRsl) &&
                                (arCopyByorekiIdx[3] != idxPreRsl) &&
                                (arCopyByorekiIdx[4] != idxPreRsl) &&
                                (arCopyByorekiIdx[5] != idxPreRsl) &&
                                (arCopyByorekiCd[0] == myForm.PreRsl[index+idxPreRsl*3+0].value ||
                                 arCopyByorekiCd[1] == myForm.PreRsl[index+idxPreRsl*3+0].value ||
                                 arCopyByorekiCd[2] == myForm.PreRsl[index+idxPreRsl*3+0].value ||
                                 arCopyByorekiCd[3] == myForm.PreRsl[index+idxPreRsl*3+0].value ||
                                 arCopyByorekiCd[4] == myForm.PreRsl[index+idxPreRsl*3+0].value ||
                                 arCopyByorekiCd[5] == myForm.PreRsl[index+idxPreRsl*3+0].value))){

                                 //すでに病歴が6件登録されているか判定
                                 if(cntInputedByoreki == 6){
                                     isOver = true;
                                     //画面下方のエラーメッセージスペースに表示
                                     parent.addErrInfo(arErrNo[n], iconNo, arErrMsg[n]);
                                     //テキストボックスのすぐ横に警告アイコン表示
                                     document.getElementById("Anchor-ErrInfo"+arErrNo[n]).innerHTML = '<IMG SRC="../../images/ico_w.gif" WIDTH="16" HEIGHT="16" ALT="'+arErrMsg[n]+'" BORDER="0">';

                                 }else{
                                 
                                     //複写処理
                                     for( j=0; j < 3; j++ ) {
                                         //内部変数ChgRslにコピー
                                         myForm.ChgRsl[index+idxChgRsl*3+j].value =  myForm.PreRsl[index+idxPreRsl*3+j].value;

                                         if(j==0) {
                                             //病名
                                             myForm['list1_'+(n+1)+'_1'+(cntInputedByoreki+1)].value=myForm.ChgRsl[index+idxChgRsl*3+j].value;
                                             //コントロールのフォントを赤字にする
                                             myForm['list1_'+(n+1)+'_1'+(cntInputedByoreki+1)].style.color = 'red';
                                             
                                             //複写した病歴を保持しておく ※インデックスも
                                             arCopyByorekiIdx.push(idxPreRsl);
                                             arCopyByorekiCd.push(myForm.PreRsl[index+idxPreRsl*3+j].value);

                                         } else if(j==1) {
                                             //年齢
                                             document.getElementsByName('Rsl')[cntInputedByoreki+(6*n)].value = myForm.ChgRsl[index+idxChgRsl*3+j].value;

                                         } else {
                                             //症状・続柄
                                             myForm['list1_'+(n+1)+'_2'+(cntInputedByoreki+1)].value=myForm.ChgRsl[index+idxChgRsl*3+j].value;
                                         }
                                     }
                                     //病歴コード欄を空白にする。
                                     document.getElementsByName('disease')[cntInputedByoreki+(6*n)].value = '';
                                     //病歴数をカウントアップ
                                     cntInputedByoreki ++;
                                 }
                                 break;//ループを抜ける
                            } else {
                                //すでにユーザが手入力で登録した病歴
                                //→何もしない
                            }
                        } else {
                            //今回入力欄と前回値の両方が空
                            //→何もしない
                        }
                    }
                    
                    //病数オーバーなら、ループを抜ける
                    if(isOver == true) break;
                }
            }
        }
    }
    
    //２．胃検査を受ける方はお答え下さい
    //（１）手術をされた方へ
    //（２）ヘリコバクター・ピロリに関して
    errNoEx = 22;
    arErrMsg = new Array('「２－（１）手術をされた方へ 」は今回値が入力済みのため、前回値を複写しませんでした。',
                         '「２－（２）ヘリコバクター・ピロリに関して 」は今回値が入力済みのため、前回値を複写しませんでした。');
    index = <%= OCRGRP_START1 %> + 59;
    for(i = 0; i < 2; i ++){
        //警告メッセージを初期化
        parent.delErrInfo((errNoEx+i), iconNo, arErrMsg[i]);
        document.getElementById("Anchor-ErrInfo"+(errNoEx+i)).innerHTML = '';    
    
        name = 'opt1_4_' + (i+1);
        //今回入力欄が未チェック状態か判定
        if(myForm.ChgRsl[i + index].value == ''){
            for(j = 0; j < document.getElementsByName(name).length; j ++){
                if(myForm.PreRsl[i + index].value==document.getElementsByName(name)[j].value){
                    document.getElementsByName(name)[j].checked=true;
                    myForm.ChgRsl[i + index].value=myForm.PreRsl[i + index].value;
                    //ラベルカラーを赤にする
                    document.getElementById('STOMACH'+(i+1)+'_'+(j+1)).style.color='red';
                    break;
                }
            }
        } else if (myForm.PreRsl[i + index].value == myForm.ChgRsl[i + index].value){
            //今回値と前回値が同じ値
            //→何もしない
        } else if (myForm.PreRsl[i + index].value != ''){
            //今回入力欄が入力済みかつ、前回値がある
            //→警告メッセージを表示
            parent.addErrInfo((errNoEx+i), iconNo, arErrMsg[i]);
            //テキストボックスのすぐ横に警告アイコン表示
            document.getElementById("Anchor-ErrInfo"+(errNoEx+i)).innerHTML = '<IMG SRC="../../images/ico_w.gif" WIDTH="16" HEIGHT="16" ALT="'+arErrMsg[i]+'" BORDER="0">';
        }
    }

    //３．以前他院で指摘を受けたものがあれば、ご記入下さい。
    var idName;
    
    index = <%= OCRGRP_START1 %> + 61;
    for( i=0; i< 28; i++ ) {
        idName="";

        //前回値があり、今回入力欄が未チェック状態か判定
        if(myForm.PreRsl[i + index].value != '' &&
           myForm.ChgRsl[i + index].value == '') {
           
            if (i < 7) {
                //（１）上部消化管検査
                name = 'chk1_5_1_' + (i + 1);
                idName='OTHER_HOSPITAL1_'+ (i + 1);
            } else if (i < 18) {
                //（２）上腹部超音波検査
                name = 'chk1_5_2_' + (i - 6);
                idName='OTHER_HOSPITAL2_'+ (i - 6);
            } else if (i < 24) {
                //（３）心電図検査
                name = 'chk1_5_3_' + (i - 17);
                idName='OTHER_HOSPITAL3_'+ (i - 17);
            } else {
                //（４）乳房検査
                name = 'chk1_5_4_' + (i - 23);
                idName='OTHER_HOSPITAL4_'+ (i - 23);
            }
            //チェック状態にする
            document.getElementsByName(name)[0].checked=true;
            //ラベルキャプションを赤色にする
            document.getElementById(idName).style.color='red';
            //処理用配列に反映
            myForm.ChgRsl[i + index].value = myForm.PreRsl[i + index].value;
        }
    }

    //下のフレームのエラーリストを消去
    //parent.lngErrCount = 0;
    parent.error.document.entryForm.selectState.selectedIndex = 2;
    parent.error.chgSelect();

    return;
}
// SL-UI-Y0101-607 前回複写ボタン追加 ADD END

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
        myForm.ChgRsl[index + 75].value = myForm.year14_1.value;
        myForm.ChgRsl[index + 76].value = myForm.month14_1.value;
        myForm.ChgRsl[index + 77].value = myForm.day14_1.value;
        myForm.ChgRsl[index + 78].value = myForm.month14_2.value;
        myForm.ChgRsl[index + 79].value = myForm.day14_2.value;
        myForm.ChgRsl[index + 80].value = myForm.year14_3.value;
        myForm.ChgRsl[index + 81].value = myForm.month14_3.value;
        myForm.ChgRsl[index + 82].value = myForm.day14_3.value;
        myForm.ChgRsl[index + 83].value = myForm.month14_4.value;
        myForm.ChgRsl[index + 84].value = myForm.day14_4.value;




    }

    //********
    // 前詰め
    //********
    // 現病歴
    index = <%= OCRGRP_START1 %> + 5;
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
    index = <%= OCRGRP_START1 %> + 23;
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
    index = <%= OCRGRP_START1 %> + 41;
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
    index = <%= OCRGRP_START2 %> + 37;
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
<!-- センター使用欄 -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20">
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP BGCOLOR="#98fb98" WIDTH="730"><SPAN ID="Anchor-DiseaseHistory" STYLE="position:relative">現病歴・既往歴問診票</SPAN></TD>
            <TD NOWRAP BGCOLOR="#98fb98" WIDTH="220">前回値<%= IIf(vntLstCslDate(0)="", "", "(" & vntLstCslDate(0) & ")") %></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">センター使用欄</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>

<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 0
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>ドック全体" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_0_1", , "1") & "はい　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_0_1", , "2") & "いいえ" & vbLf
    strHTML = strHTML & "　　　　" & vbLf
lngIndex = OCRGRP_START1 + 1
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_0_1", , "1") & "ＧＦ" & vbLf
lngIndex = OCRGRP_START1 + 2
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_0_2", , "1") & "ＨＰＶ" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    '---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START1 + 0
    ' センター使用欄
    Select Case vntLstResult(lngIndex)
    	Case "1"
        	strLstRsl = "はい"
    	Case "2"
        	strLstRsl = "いいえ"
    End Select
lngIndex = OCRGRP_START1 + 1
    If vntLstResult(lngIndex)<> "" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", "　") & "ＧＦ"
    End If
lngIndex = OCRGRP_START1 + 2
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", "　") & "ＨＰＶ"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">ブスコパン可否</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 3
    '薬アレルギーが「あり」のときはブスコパン可否を「否」とする（「可」は選択不可）
    If vntPerResult(0) = "2" Then
        vntResult(lngIndex) = "2"
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & "　　" & "可　　　" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_0_2", , "2") & "否" & vbLf
        strHTML = strHTML & "</TD>" & vbLf
    Else
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_0_2", , "1") & "可　　　" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_0_2", , "2") & "否" & vbLf
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
lngIndex = OCRGRP_START1 + 4
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_0_3", , "1") & "はい　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_0_3", , "2") & "いいえ" & vbLf
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
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
            <TD NOWRAP BGCOLOR="#eeeeee">１．現在治療中又は定期的に受診中の病気について</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
-->
            <TD NOWRAP BGCOLOR="#eeeeee">１－a．現在治療中又は定期的に受診中の病気について</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
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
lngIndex = OCRGRP_START1 + 5 + i*3
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "disease", "list1_1_1" & (i+1), 3, "") & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "list1", "list1_1_1" & (i+1), , "") & vbLf
        strHTML = strHTML & "</TD>" & vbLf
lngIndex = OCRGRP_START1 + 6 + i*3
        strHTML = strHTML & "<TD NOWRAP  ALIGN=""right"">" & EditRsl(lngIndex, "text", "Rsl", 3, "") & "才" & "</TD>" & vbLf
lngIndex = OCRGRP_START1 + 7 + i*3
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "list2", "list1_1_2" & (i+1), , "") & vbLf
        strHTML = strHTML & "</TD>" & vbLf

        '前回値と比較してメッセージを作成
        strLstDiffMsg = ""
        For j=0 To NOWDISEASE_COUNT - 1
            If vntResult(OCRGRP_START1 + 5 + i*3) <> "" Then
                '同じ病名を検索
                If vntResult(OCRGRP_START1 + 5 + i*3) = vntLstResult(OCRGRP_START1 + 5 + j*3) Then
                    '年齢が違う
                    If vntResult(OCRGRP_START1 + 6 + i*3) <> vntLstResult(OCRGRP_START1 + 6 + j*3) Then
                        strLstDiffMsg = strLstDiffMsg & IIf(strLstDiffMsg<>"","、","") & "年齢"
                    End If
                    '治療状態が違う
                    If vntResult(OCRGRP_START1 + 7 + i*3) <> vntLstResult(OCRGRP_START1 + 7 + j*3) Then
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
lngIndex = OCRGRP_START1 + 5 + i*3
        For j=0 To UBound(strArrCode1)
            If vntLstResult(lngIndex) = strArrCode1(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "　") & strArrName1(j)
                Exit For
            End If
        Next
lngIndex = OCRGRP_START1 + 6 + i*3
        strLstRsl =  strLstRsl & IIf(strLstRsl="", "", "　") & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "才")
lngIndex = OCRGRP_START1 + 7 + i*3
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
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
            <TD NOWRAP BGCOLOR="#eeeeee">２．既に治療や定期的な受診が終了した病気について</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
-->
            <TD NOWRAP BGCOLOR="#eeeeee">１－ｂ．既に治療や定期的な受診が終了した病気について</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->
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
lngIndex = OCRGRP_START1 + 23 + i*3
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "disease", "list1_2_1" & (i+1), 3, "") & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "list1", "list1_2_1" & (i+1), , "") & vbLf
        strHTML = strHTML & "</TD>" & vbLf
lngIndex = OCRGRP_START1 + 24 + i*3
        strHTML = strHTML & "<TD NOWRAP  ALIGN=""right"">" & EditRsl(lngIndex, "text", "Rsl", 3, "") & "才" & "</TD>" & vbLf
lngIndex = OCRGRP_START1 + 25 + i*3
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "list2", "list1_2_2" & (i+1), , "") & vbLf
        strHTML = strHTML & "</TD>" & vbLf

        '前回値と比較してメッセージを作成
        strLstDiffMsg = ""
        For j=0 To NOWDISEASE_COUNT - 1
            If vntResult(OCRGRP_START1 + 23 + i*3) <> "" Then
                '同じ病名を検索
                If vntResult(OCRGRP_START1 + 23 + i*3) = vntLstResult(OCRGRP_START1 + 23 + j*3) Then
                    '年齢が違う
                    If vntResult(OCRGRP_START1 + 24 + i*3) <> vntLstResult(OCRGRP_START1 + 24 + j*3) Then
                        strLstDiffMsg = strLstDiffMsg & IIf(strLstDiffMsg<>"","、","") & "年齢"
                    End If
                    '治療状態が違う
                    If vntResult(OCRGRP_START1 + 25 + i*3) <> vntLstResult(OCRGRP_START1 + 25 + j*3) Then
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
lngIndex = OCRGRP_START1 + 23 + i*3
        For j=0 To UBound(strArrCode1)
            If vntLstResult(lngIndex) = strArrCode1(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "　") & strArrName1(j)
                Exit For
            End If
        Next
lngIndex = OCRGRP_START1 + 24 + i*3
        strLstRsl =  strLstRsl & IIf(strLstRsl="", "", "　") & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "才")
lngIndex = OCRGRP_START1 + 25 + i*3
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
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
            <TD NOWRAP BGCOLOR="#eeeeee">３．ご家族（血縁）の方でかかった病気について</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
-->
            <TD NOWRAP BGCOLOR="#eeeeee">１－ｃ．ご家族（血縁）の方でかかった病気について</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->
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
lngIndex = OCRGRP_START1 + 41 + i*3
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "disease", "list1_3_1" & (i+1), 3, "") & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "list1", "list1_3_1" & (i+1), , "") & vbLf
        strHTML = strHTML & "</TD>" & vbLf
lngIndex = OCRGRP_START1 + 42 + i*3
        strHTML = strHTML & "<TD NOWRAP  ALIGN=""right"">" & EditRsl(lngIndex, "text", "Rsl", 3, "") & "才" & "</TD>" & vbLf
lngIndex = OCRGRP_START1 + 43 + i*3
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "list3", "list1_3_2" & (i+1), , "") & vbLf
        strHTML = strHTML & "</TD>" & vbLf

        '前回値と比較してメッセージを作成
        strLstDiffMsg = ""
        For j=0 To NOWDISEASE_COUNT - 1
            If vntResult(OCRGRP_START1 + 41 + i*3) <> "" Then
                '同じ病名を検索
                If vntResult(OCRGRP_START1 + 41 + i*3) = vntLstResult(OCRGRP_START1 + 41 + j*3) Then
                    '発症年齢が違う
                    If vntResult(OCRGRP_START1 + 42 + i*3) <> vntLstResult(OCRGRP_START1 + 42 + j*3) Then
                        strLstDiffMsg = strLstDiffMsg & IIf(strLstDiffMsg<>"","、","") & "発症年齢"
                    End If
                    '続柄が違う
                    If vntResult(OCRGRP_START1 + 43 + i*3) <> vntLstResult(OCRGRP_START1 + 43 + j*3) Then
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
lngIndex = OCRGRP_START1 + 41 + i*3
        For j=0 To UBound(strArrCode1)
            If vntLstResult(lngIndex) = strArrCode1(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "　") & strArrName1(j)
                Exit For
            End If
        Next
lngIndex = OCRGRP_START1 + 42 + i*3
        strLstRsl =  strLstRsl & IIf(strLstRsl="", "", "　") & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "才")
lngIndex = OCRGRP_START1 + 43 + i*3
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
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
            <TD NOWRAP BGCOLOR="#eeeeee">４．胃検査を受ける方はお答え下さい</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
-->
            <TD NOWRAP BGCOLOR="#eeeeee"><SPAN ID="Anchor-Stomach" STYLE="position:relative">２．胃検査を受ける方はお答え下さい</SPAN></TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（１）手術をされた方へ</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 59
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_1", , "1") & "胃全摘手術　" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_1", , "2") & "胃部分切除　" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_1", , "3") & "内視鏡治療（粘膜切除術など）　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_1", , "1") & "<SPAN ID=""STOMACH1_1"">胃全摘手術</SPAN>　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_1", , "2") & "<SPAN ID=""STOMACH1_2"">胃部分切除</SPAN>　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_1", , "3") & "<SPAN ID=""STOMACH1_3"">内視鏡治療（粘膜切除術など）</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "胃全摘手術"
    Case "2"
        strLstRsl = "胃部分切除"
    Case "3"
        strLstRsl = "内視鏡治療（粘膜切除術など）"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>




        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（２）ヘリコバクター・ピロリに関して</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 60
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf

''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>　　　　　ピロリ除菌歴" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "2") & "あり：除菌成功　" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "3") & "あり：除菌不成功　" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "4") & "あり：除菌できたか不明　" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "1") & "なし" & vbLf
'    strHTML = strHTML & "</TD>" & vbLf

    strHTML = strHTML & "<TD NOWRAP>　　　　　ピロリ除菌歴　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "1") & "除菌歴なし　" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "2") & "あり：除菌成功　" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "3") & "あり：除菌不成功　" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "4") & "あり：除菌できたか不明　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "1") & "<SPAN ID=""STOMACH2_1"">除菌歴なし</SPAN>　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "2") & "<SPAN ID=""STOMACH2_2"">あり：除菌成功</SPAN>　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "3") & "<SPAN ID=""STOMACH2_3"">あり：除菌不成功</SPAN>　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "4") & "<SPAN ID=""STOMACH2_4"">あり：除菌できたか不明</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
    strHTML = strHTML & "</TD>" & vbLf
''### 2010.12.18 MOD END TCS)H.F
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "ピロリ菌：除菌歴なし"
    Case "2"
        strLstRsl = "ピロリ菌：除菌歴あり、成功"
    Case "3"
        strLstRsl = "ピロリ菌：除菌歴あり、不成功"
    Case "4"
        strLstRsl = "ピロリ菌：除菌歴あり、除菌できたか不明"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
            <TD NOWRAP BGCOLOR="#eeeeee">５．以前他院で指摘を受けたものがあれば、ご記入下さい。</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
-->
            <TD NOWRAP BGCOLOR="#eeeeee">３．以前他院で指摘を受けたものがあれば、ご記入下さい。</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（１）上部消化管検査</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
lngIndex = OCRGRP_START1 + 61
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_1", , "1") & "食道ポリープ" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_1", , "1") & "食道ポリープ　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_1", , "1") & "<SPAN ID=""OTHER_HOSPITAL1_1"">食道ポリープ</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 62
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_2", , "2") & "胃がん" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_2", , "2") & "胃がん　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_2", , "2") & "<SPAN ID=""OTHER_HOSPITAL1_2"">胃がん</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 63
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_3", , "3") & "慢性胃炎" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_3", , "3") & "慢性胃炎　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_3", , "3") & "<SPAN ID=""OTHER_HOSPITAL1_3"">慢性胃炎</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 64
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_4", , "4") & "胃ポリープ" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_4", , "4") & "胃ポリープ　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_4", , "4") & "<SPAN ID=""OTHER_HOSPITAL1_4"">胃ポリープ</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 65
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_5", , "5") & "胃潰瘍瘢痕" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_5", , "5") & "胃潰瘍瘢痕　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_5", , "5") & "<SPAN ID=""OTHER_HOSPITAL1_5"">胃潰瘍瘢痕</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 66
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_6", , "6") & "十二指腸" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_6", , "6") & "十二指腸　" & vbLf
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 67
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_7", , "7") & "その他" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_7", , "7") & "その他　" & vbLf
''### 2010.12.23 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START1 + 61
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "食道ポリープ"
    End If
lngIndex = OCRGRP_START1 + 62
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "胃がん"
    End If
lngIndex = OCRGRP_START1 + 63
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "慢性胃炎"
    End If
lngIndex = OCRGRP_START1 + 64
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "胃ポリープ"
    End If
lngIndex = OCRGRP_START1 + 65
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "胃潰瘍瘢痕"
    End If
lngIndex = OCRGRP_START1 + 66
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "十二指腸"
    End If
lngIndex = OCRGRP_START1 + 67
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

''### 2010.12.23 ADD STR TCS)H.F
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
lngIndex = OCRGRP_START1 + 66
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_6", , "6") & "十二指腸潰瘍瘢痕　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_6", , "6") & "<SPAN ID=""OTHER_HOSPITAL1_6"">十二指腸潰瘍瘢痕</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
lngIndex = OCRGRP_START1 + 67
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_7", , "7") & "その他　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_7", , "7") & "<SPAN ID=""OTHER_HOSPITAL1_7"">その他</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
''### 2010.12.23 ADD END TCS)H.F
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（２）上腹部超音波検査</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
lngIndex = OCRGRP_START1 + 68
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_1", , "1") & "胆のうポリープ" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_1", , "1") & "胆のうポリープ　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_1", , "1") & "<SPAN ID=""OTHER_HOSPITAL2_1"">胆のうポリープ</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 69
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_2", , "2") & "胆石" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_2", , "2") & "胆石　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_2", , "2") & "<SPAN ID=""OTHER_HOSPITAL2_2"">胆石</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 70
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_3", , "3") & "肝血管腫" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_3", , "3") & "肝血管腫　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_3", , "3") & "<SPAN ID=""OTHER_HOSPITAL2_3"">肝血管腫</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 71
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_4", , "4") & "肝のう胞" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_4", , "4") & "肝のう胞　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_4", , "4") & "<SPAN ID=""OTHER_HOSPITAL2_4"">肝のう胞</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 72
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_5", , "5") & "脂肪肝" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_5", , "5") & "脂肪肝　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_5", , "5") & "<SPAN ID=""OTHER_HOSPITAL2_5"">脂肪肝</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START1 + 68
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "胆のうポリープ"
    End If
lngIndex = OCRGRP_START1 + 69
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "胆石"
    End If
lngIndex = OCRGRP_START1 + 70
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "肝血管腫"
    End If
lngIndex = OCRGRP_START1 + 71
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "肝嚢胞"
    End If
lngIndex = OCRGRP_START1 + 72
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "脂肪肝"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>

<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
lngIndex = OCRGRP_START1 + 73
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_6", , "6") & "腎結石" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_6", , "6") & "腎結石　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_6", , "6") & "<SPAN ID=""OTHER_HOSPITAL2_6"">腎結石</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 74
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_7", , "7") & "腎のう胞" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_7", , "7") & "腎のう胞　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_7", , "7") & "<SPAN ID=""OTHER_HOSPITAL2_7"">腎のう胞</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 75
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_8", , "9") & "水腎症" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_8", , "9") & "水腎症　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_8", , "9") & "<SPAN ID=""OTHER_HOSPITAL2_8"">水腎症</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 76
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_9", , "10") & "副腎腫瘍" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_9", , "10") & "副腎腫瘍　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_9", , "10") & "<SPAN ID=""OTHER_HOSPITAL2_9"">副腎腫瘍</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 77
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_10", , "11") & "リンパ節腫大" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_10", , "11") & "リンパ節腫大　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_10", , "11") & "<SPAN ID=""OTHER_HOSPITAL2_10"">リンパ節腫大</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 78
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_11", , "8") & "その他" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_11", , "8") & "その他　" & vbLf
''### 2010.12.23 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START1 + 73
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "腎結石"
    End If
lngIndex = OCRGRP_START1 + 74
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "腎のう胞"
    End If
lngIndex = OCRGRP_START1 + 75
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "水腎症"
    End If
lngIndex = OCRGRP_START1 + 76
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "副腎腫瘍"
    End If
lngIndex = OCRGRP_START1 + 77
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "リンパ節腫大"
    End If
lngIndex = OCRGRP_START1 + 78
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
''### 2010.12.23 ADD STR TCS)H.F
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
lngIndex = OCRGRP_START1 + 78
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_11", , "8") & "その他　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_11", , "8") & "<SPAN ID=""OTHER_HOSPITAL2_11"">その他</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
''### 2010.12.23 ADD END TCS)H.F
%>


        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（３）心電図検査</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
lngIndex = OCRGRP_START1 + 79
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_1", , "1") & "ＷＰＷ症候群" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_1", , "1") & "ＷＰＷ症候群　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_1", , "1") & "<SPAN ID=""OTHER_HOSPITAL3_1"">ＷＰＷ症候群</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD STR TCS)H.F
lngIndex = OCRGRP_START1 + 80
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_2", , "2") & "完全右脚ブロック" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_2", , "2") & "完全右脚ブロック　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_2", , "2") & "<SPAN ID=""OTHER_HOSPITAL3_2"">完全右脚ブロック</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 81
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_3", , "3") & "不完全右脚ブロック" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_3", , "3") & "不完全右脚ブロック　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_3", , "3") & "<SPAN ID=""OTHER_HOSPITAL3_3"">不完全右脚ブロック</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 82
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_4", , "4") & "不整脈" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_4", , "4") & "不整脈　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_4", , "4") & "<SPAN ID=""OTHER_HOSPITAL3_4"">不整脈</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 83
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_5", , "6") & "右胸心" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_5", , "6") & "右胸心　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_5", , "6") & "<SPAN ID=""OTHER_HOSPITAL3_5"">右胸心</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 84
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_6", , "5") & "その他" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_6", , "5") & "その他　" & vbLf
''### 2010.12.23 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START1 + 79
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "ＷＰＷ症候群"
    End If
lngIndex = OCRGRP_START1 + 80
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "完全右脚ブロック"
    End If
lngIndex = OCRGRP_START1 + 81
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "不完全右脚ブロック"
    End If
lngIndex = OCRGRP_START1 + 82
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "不整脈"
    End If
lngIndex = OCRGRP_START1 + 83
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "右胸心"
    End If
lngIndex = OCRGRP_START1 + 84
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
''### 2010.12.23 ADD STR TCS)H.F
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
lngIndex = OCRGRP_START1 + 84
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_6", , "5") & "その他　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_6", , "5") & "<SPAN ID=""OTHER_HOSPITAL3_6"">その他</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
''### 2010.12.23 ADD END TCS)H.F
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（４）乳房検査</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
lngIndex = OCRGRP_START1 + 85
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_1", , "1") & "乳腺症" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_1", , "1") & "乳腺症　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_1", , "1") & "<SPAN ID=""OTHER_HOSPITAL4_1"">乳腺症</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 86
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_2", , "2") & "繊維線種" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_2", , "2") & "繊維線種　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_2", , "2") & "<SPAN ID=""OTHER_HOSPITAL4_2"">繊維線種</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 87
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_3", , "4") & "乳房形成術" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_3", , "4") & "乳房形成術　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_3", , "4") & "<SPAN ID=""OTHER_HOSPITAL4_3"">乳房形成術　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 88
''### 2010.12.23 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_4", , "3") & "その他" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_4", , "3") & "その他　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_4", , "3") & "<SPAN ID=""OTHER_HOSPITAL4_4"">その他</SPAN>　" & vbLf
' SL-UI-Y0101-607 前回複写ボタン追加 MOD END
''### 2010.12.23 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START1 + 85
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "乳腺症"
    End If
lngIndex = OCRGRP_START1 + 86
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "繊維線種"
    End If
lngIndex = OCRGRP_START1 + 87
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "乳房形成術"
    End If
lngIndex = OCRGRP_START1 + 88
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>



<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（５）女性の方は、下記の質問にお答えください。</TD>
            <TD NOWRAP></TD>
        </TR>
-->
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">４．女性の方は、下記の質問にお答えください。</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->

<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"" ROWSPAN=""2"" VALIGN=""MIDDLE"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
lngIndex = OCRGRP_START1 + 89
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_5_5", , "1") & "はい" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "（妊娠中の方は健診はおうけしておりません、また可能性のある方は、Ｘ検査は受けられません。）</TD>" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_5_5", , "2") & "いいえ" & vbLf
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

<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">１．体重について</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->

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
    strHTML = strHTML & "<TD NOWRAP>　　　　　" & EditRsl(lngIndex, "text", "Rsl", 4, "") & "ｋｇ" & "</TD>" & vbLf
'---前回値---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "ｋｇ")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
<% '#### 2011/01/22 MOD STA TCS)Y.T #### %>
<!--            <TD NOWRAP>　　（２）この半年での体重の変動はどうですか。</TD>-->
            <TD NOWRAP>　　（２）この１年での体重の変動はどうですか。</TD>
<% '#### 2011/01/22 MOD END TCS)Y.T #### %>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 1
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_1_2", , "4") & "3ｋｇ以上増加した　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_1_2", , "2") & "変動なし　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_1_2", , "5") & "3ｋｇ以上減少した　" & vbLf
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
    Case "4"
        strLstRsl = "3ｋｇ以上増加した"
    Case "5"
        strLstRsl = "3ｋｇ以上減少した"
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
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_2_1", , "1") & "習慣的に飲む　" & vbLf
lngIndex = OCRGRP_START2 + 3
    strHTML = strHTML & "（週" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "日）　" & vbLf
lngIndex = OCRGRP_START2 + 2
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_2_1", , "2") & "ときどき飲む　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_2_1", , "3") & "飲まない　" & vbLf
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
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">３．１日の飲酒量はどのくらいですか。</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
-->
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>　　（２）１日の飲酒量はどのくらいですか。</TD>
            <TD NOWRAP></TD>
        </TR>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->
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
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_3_1", , "1") & "吸っている　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_3_1", , "2") & "吸わない　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_3_1", , "3") & "過去に吸っていた　" & vbLf
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
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_1", , "1") & "思う　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_1", , "2") & "思わない　" & vbLf
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
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_3", , "1") & "よく体を動かす　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_3", , "2") & "普通に動いている　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_3", , "3") & "あまり活動的でない　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_3", , "4") & "ほとんど体を動かさない　" & vbLf
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
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_4", , "1") & "ほとんど毎日　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_4", , "2") & "週３～５日　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_4", , "3") & "週１～２日　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_4", , "4") & "ほとんどしない　" & vbLf
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
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_5", , "1") & "はい　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_5", , "2") & "寝不足を感じる　" & vbLf
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
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_6", , "1") & "毎食後に磨く　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_6", , "4") & "１日１～２回は磨く　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_6", , "3") & "１回も磨かない　" & vbLf
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
    Case "4"
        strLstRsl = "１日１～２回は磨く"
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
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_1", , "1") & "肉体頭脳を要す労働　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_1", , "2") & "主に肉体的な労働　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_1", , "3") & "主に頭脳的な労働　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_1", , "4") & "主に座り仕事　" & vbLf
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
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_2", , "1") & "週3日以上　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_2", , "2") & "週2日以上　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_2", , "3") & "週1日　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_2", , "4") & "月3日以下　" & vbLf
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
            <TD NOWRAP>　　（３）職場等への主な移動手段</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 26
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_3", , "1") & "徒歩　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_3", , "2") & "自転車　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_3", , "3") & "自動車（２輪を含む）　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_3", , "4") & "電車・バス　" & vbLf
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
            <TD NOWRAP>　　（４）職場等までの片道移動時間／徒歩時間は</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 27
    strHTML = strHTML & "<TD NOWRAP>　　　　" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "分（片道の通勤時間）　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "分（片道の移動時間）　　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START2 + 28
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "分（片道の歩行時間）　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
lngIndex = OCRGRP_START2 + 27
''### 2010.12.18 MOD STR TCS)H.F
'    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "分（片道の通勤時間）")
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "分（片道の移動時間）")
''### 2010.12.18 MOD END TCS)H.F
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
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_5", , "1") & "あり　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_5", , "2") & "なし　" & vbLf
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
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk2_4_7_6_1", , "1") & "親" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk2_4_7_6_1", , "1") & "親　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START2 + 31
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk2_4_7_6_2", , "2") & "配偶者" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk2_4_7_6_2", , "2") & "配偶者　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START2 + 32
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk2_4_7_6_3", , "3") & "子供" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk2_4_7_6_3", , "3") & "子供　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START2 + 33
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk2_4_7_6_4", , "4") & "独居" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk2_4_7_6_4", , "4") & "独居　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START2 + 34
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk2_4_7_6_5", , "5") & "その他" & vbLf
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
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_7", , "1") & "満足している　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_7", , "2") & "やや満足している　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_7", , "3") & "やや不満　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_7", , "4") & "不満足　" & vbLf
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
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_8", , "1") & "全く無かった　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_8", , "2") & "ややつらいことがあった　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_8", , "3") & "つらいことがあった　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_8", , "4") & "大変つらかった　" & vbLf
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
lngIndex = OCRGRP_START2 + 37
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
lngIndex = OCRGRP_START2 + 37 + i*4
        For j=0 To UBound(strArrCodeJikaku1)
            If vntLstResult(lngIndex) = strArrCodeJikaku1(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "　") & strArrNameJikaku1(j)
                Exit For
            End If
        Next
lngIndex = OCRGRP_START2 + 38 + i*4
        If vntLstResult(lngIndex) <> "" Then
            strLstRsl =  strLstRsl & IIf(strLstRsl="", "", "　") & vntLstResult(lngIndex)
        End If
lngIndex = OCRGRP_START2 + 39 + i*4
        For j=0 To UBound(strArrCodeJikaku3)
            If vntLstResult(lngIndex) = strArrCodeJikaku3(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "　") & strArrNameJikaku3(j)
                Exit For
            End If
        Next
lngIndex = OCRGRP_START2 + 40 + i*4
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
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk3_1_1", , "1") & "<B>本人希望により未回答</B>" & vbLf
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
    strHTML = strHTML & "<TD>　</TD>" & vbLf
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
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
            <TD NOWRAP BGCOLOR="#eeeeee">1.子宮頸ガンの検診を受けたことは</TD>
-->
            <TD NOWRAP BGCOLOR="#eeeeee">1.子宮頸がんの検診を受けたことは</TD>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 0
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "6") & "1年未満　" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "7") & "1～3年前　" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "8") & "3年以上前　" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "5") & "受けたことなし　" & vbLf
'    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "5") & "受けたことなし　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
''### 2010.12.18 MOD END TCS)H.F
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "6"
        strLstRsl = "1年未満"
    Case "7"
        strLstRsl = "1～3年前"
    Case "8"
        strLstRsl = "3年以上前"
    Case "5"
        strLstRsl = "受けたことなし"
	'前コード
    Case "1"
        strLstRsl = "6ケ月以内"
    Case "2"
        strLstRsl = "6ケ月～1年以内"
    Case "3"
        strLstRsl = "1～2年以内"
    Case "4"
        strLstRsl = "3年前以上"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

''### 2010.12.18 ADD STR TCS)H.F
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "6") & "1年未満　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "7") & "1～3年前　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "8") & "3年以上前　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

''### 2010.12.18 ADD END TCS)H.F

%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">2.検診の結果は</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 1
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2_1", , "1") & "異常なし　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2_1", , "2") & "異型上皮" & vbLf
    strHTML = strHTML & "（クラス" & vbLf
lngIndex = OCRGRP_START4 + 2
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2_2", , "1") & "Ⅲa　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2_2", , "2") & "Ⅲb　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2_2", , "3") & "Ⅲ　" & vbLf
    strHTML = strHTML & "）" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "異常なし"
    Case "2"
        strLstRsl = "異型上皮"
		lngIndex = OCRGRP_START4 + 2
        Select Case  vntLstResult(lngIndex) 
        	Case  "1"
		        strLstRsl = strLstRsl & "（クラス：Ⅲa）"
        	Case  "2"
		        strLstRsl = strLstRsl & "（クラス：Ⅲb）"
        	Case  "3"
		        strLstRsl = strLstRsl & "（クラス：Ⅲ）"
        End Select
	'前コード
    Case "3"
        strLstRsl = "異常あり"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "　" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
'#### 2010.07.09 SL-UI-Y0101-113 ADD START ####'
lngIndex = OCRGRP_START4 + 1
'#### 2010.07.09 SL-UI-Y0101-113 ADD END ####'
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2_1", , "4") & "癌の疑い　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2_1", , "4") & "子宮頸がんの疑い　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2_1", , "9") & "その他　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "4"
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = "癌の疑い"
        strLstRsl = "子宮頸がんの疑い"
''### 2010.12.18 MOD END TCS)H.F
    Case "9"
        strLstRsl = "その他"

    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">3.検診を受けた施設は</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 3
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_3", , "4") & "当センター　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_3", , "5") & "当病院　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_3", , "6") & "他施設　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "4"
        strLstRsl = "当センター"
    Case "5"
        strLstRsl = "当病院"
    Case "6"
        strLstRsl = "他施設"
	'前コード
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
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
            <TD NOWRAP BGCOLOR="#eeeeee">4.過去の子宮頸ガン検査で異常は</TD>
-->
            <TD NOWRAP BGCOLOR="#eeeeee">4.過去の子宮頸がん検査で異常は</TD>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 4
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_1", , "1") & "いいえ　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_1", , "2") & "はい　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "いいえ"
    Case "2"
        strLstRsl = "はい"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">　</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　「はい」の場合" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

    strHTML = ""
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD>" & vbLf

    strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPALING=""0"">"
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 5
    strHTML = strHTML & "<TD NOWRAP>　　結果：</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_2", , "1") & "異型上皮" & vbLf
    strHTML = strHTML & "（クラス" & vbLf
lngIndex = OCRGRP_START4 + 6
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_3", , "1") & "Ⅲa　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_3", , "2") & "Ⅲb　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_3", , "3") & "Ⅲ　" & vbLf
    strHTML = strHTML & "）" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "　" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 5
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_2", , "2") & "癌の疑い　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_2", , "2") & "子宮頸がんの疑い　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_2", , "9") & "その他　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf

    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 7
    strHTML = strHTML & "<TD NOWRAP>　　時期：</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_4", , "1") & "1年未満　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_4", , "2") & "1～3年前　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_4", , "3") & "3年以上前　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf

'------------
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 8
    strHTML = strHTML & "<TD NOWRAP>　　施設：</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_5", , "1") & "当センター　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_5", , "2") & "当病院　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_5", , "3") & "他施設　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "</TABLE>"
    strHTML = strHTML & "</TD>" & vbLf

    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPALING=""0"">"
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 5
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "異型上皮"
		lngIndex = OCRGRP_START4 + 6
	    Select Case vntLstResult(lngIndex)
	    Case "1"
	        strLstRsl = strLstRsl & "（クラス：Ⅲa）"
	    Case "2"
	        strLstRsl = strLstRsl & "（クラス：Ⅲb）"
	    Case "3"
	        strLstRsl = strLstRsl & "（クラス：Ⅲ）"
	    End Select
    End Select
    If strLstRsl = "" Then
        strLstRsl = "　"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf

    strLstRsl = ""
lngIndex = OCRGRP_START4 + 5
    Select Case vntLstResult(lngIndex)
    Case "2"
''### 2010.12.18 MOD STR TCS)H.F
        strLstRsl = "子宮頸がんの疑い"
''### 2010.12.18 MOD END TCS)H.F
    Case "9"
        strLstRsl = "その他"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "　"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf

    strLstRsl = ""
lngIndex = OCRGRP_START4 + 7
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "1年未満"
    Case "2"
        strLstRsl = "1～3年前"
    Case "3"
        strLstRsl = "3年以上前"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "　"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 8
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "当センター"
    Case "2"
        strLstRsl = "当病院"
    Case "3"
        strLstRsl = "他施設"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "　"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "</TABLE>" & vbLf

    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">5.ＨＰＶ(ヒトパピローマウィルス）検査を受けたことは</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 9
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_1", , "1") & "受けたことなし　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_1", , "1") & "いいえ　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_1", , "2") & "はい　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "いいえ"
    Case "2"
        strLstRsl = "はい"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">　</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　「はい」の場合" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

    strHTML = ""
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD>" & vbLf
    strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPALING=""0"">"  & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 10
    strHTML = strHTML & "<TD NOWRAP>　　結果：</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_2", , "1") & "陰性　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_2", , "2") & "陽性" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 11
    strHTML = strHTML & "<TD NOWRAP>　　時期：</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_3", , "1") & "1年未満　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_3", , "2") & "1～3年前　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_3", , "3") & "3年以上前　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 12
    strHTML = strHTML & "<TD NOWRAP>　　施設：</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_4", , "1") & "当センター　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_4", , "2") & "当病院　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_4", , "3") & "他施設　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "</TABLE>"
    strHTML = strHTML & "</TD>" & vbLf

'---前回値---
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPALING=""0"">"
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 10
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "陰性"
    Case "2"
        strLstRsl = "陽性"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "　"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf

    strLstRsl = ""
lngIndex = OCRGRP_START4 + 11
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "1年未満"
    Case "2"
        strLstRsl = "1～3年前"
    Case "3"
        strLstRsl = "3年以上前"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "　"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf

    strLstRsl = ""
lngIndex = OCRGRP_START4 + 12
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "当センター"
    Case "2"
        strLstRsl = "当病院"
    Case "3"
        strLstRsl = "他施設"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "　"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "</TABLE>" & vbLf
    strHTML = strHTML & "</TD>" & vbLf

    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
            <TD NOWRAP BGCOLOR="#eeeeee">6.子宮体ガン検査を受けたことは</TD>
-->
            <TD NOWRAP BGCOLOR="#eeeeee">6.子宮体がん検査を受けたことは</TD>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">"  & EditErrInfo &  "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 13
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_1", , "1") & "いいえ　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_1", , "2") & "はい　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "いいえ"
    Case "2"
        strLstRsl = "はい"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "　" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　「はい」の場合" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

    strHTML = ""
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD>" & vbLf
    strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPALING=""0"">"
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 14
    strHTML = strHTML & "<TD NOWRAP>　　結果：</TD>" & vbLf
'### 2010.10.19 ADD STR TCS)H.F ※異常なしが抜けている
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_2", , "1") & "異常なし" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "　" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'### 2010.10.19 ADD END TCS)H.F 
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_2", , "2") & "擬陽性" & vbLf
    strHTML = strHTML & "（クラス" & vbLf
lngIndex = OCRGRP_START4 + 15
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_3", , "1") & "Ⅲa　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_3", , "2") & "Ⅲb　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_3", , "3") & "Ⅲ　" & vbLf
    strHTML = strHTML & "）" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "　" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 14
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_2", , "3") & "癌の疑い　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_2", , "3") & "子宮体がんの疑い　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_2", , "9") & "その他　" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 16
    strHTML = strHTML & "<TD NOWRAP>　　時期：</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_4", , "1") & "1年未満　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_4", , "2") & "1～3年前　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_4", , "3") & "3年以上前　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

'------------
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 17
    strHTML = strHTML & "<TD NOWRAP>　　施設：</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_5", , "1") & "当センター　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_5", , "2") & "当病院　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_5", , "3") & "他施設　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "</TABLE>"
    strHTML = strHTML & "</TD>" & vbLf

    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPALING=""0"">"

lngIndex = OCRGRP_START4 + 14
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "異常なし"
    Case "2"
        strLstRsl = "擬陽性"
		lngIndex = OCRGRP_START4 + 15
	    Select Case vntLstResult(lngIndex)
	    Case "1"
	        strLstRsl = strLstRsl & "（クラス：Ⅲa）"
	    Case "2"
	        strLstRsl = strLstRsl & "（クラス：Ⅲb）"
	    Case "3"
	        strLstRsl = strLstRsl & "（クラス：Ⅲ）"
	    End Select
    Case "3"
        strLstRsl = "異常あり"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "　"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf

lngIndex = OCRGRP_START4 + 14
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "3"
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = "癌の疑い"
        strLstRsl = "子宮体がんの疑い"
''### 2010.12.18 MOD END TCS)H.F
    Case "9"
        strLstRsl = "その他"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "　"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf

lngIndex = OCRGRP_START4 + 16
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "1年未満"
    Case "2"
        strLstRsl = "1～3年前"
    Case "3"
        strLstRsl = "3年以上前"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "　"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    
lngIndex = OCRGRP_START4 + 17
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "当センター"
    Case "2"
        strLstRsl = "当病院"
    Case "3"
        strLstRsl = "他施設"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "　"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "</TABLE>" & vbLf
    strHTML = strHTML & "</TD>" & vbLf

    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">7.婦人科の病気をしたことは</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
lngIndex = OCRGRP_START4 + 18
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_1", , "1") & "ない" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_1", , "1") & "ない　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 19
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_2", , "2") & "子宮筋腫" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_2", , "2") & "子宮筋腫　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 20
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_3", , "11") & "子宮頸管ポリープ" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_3", , "11") & "子宮頸管ポリープ　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 18
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "ない"
    End If
lngIndex = OCRGRP_START4 + 19
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "子宮筋腫"
    End If
lngIndex = OCRGRP_START4 + 20
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "子宮頸管ポリープ"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
lngIndex = OCRGRP_START4 + 21
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_4", , "13") & "内性子宮内膜症（子宮腺筋症）" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_4", , "13") & "内性子宮内膜症（子宮腺筋症）　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 22
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_5", , "14") & "外性子宮内膜症（チョコレートのう腫など）" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_5", , "14") & "外性子宮内膜症（チョコレートのう胞など）　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 21
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "内性子宮内膜症（子宮腺筋症）"
    End If
lngIndex = OCRGRP_START4 + 22
    If vntLstResult(lngIndex)<>"" Then
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "外性子宮内膜症（チョコレートのう腫など）"
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "外性子宮内膜症（チョコレートのう胞など）"
''### 2010.12.18 MOD END TCS)H.F
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
lngIndex = OCRGRP_START4 + 23
''### 20100.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_6", , "15") & "子宮頸ガン" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_6", , "15") & "子宮頸がん　" & vbLf
''### 20100.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 24
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_7", , "16") & "子宮体ガン" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_7", , "16") & "子宮体がん　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 25
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_8", , "17") & "卵巣ガン" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_8", , "17") & "卵巣がん" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 23
    If vntLstResult(lngIndex)<>"" Then
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "子宮頸ガン"
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "子宮頸がん"
''### 2010.12.18 MOD END TCS)H.F
    End If
lngIndex = OCRGRP_START4 + 24
    If vntLstResult(lngIndex)<>"" Then
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "子宮体ガン"
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "子宮体がん"
''### 2010.12.18 MOD END TCS)H.F
    End If
lngIndex = OCRGRP_START4 + 25
    If vntLstResult(lngIndex)<>"" Then
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "卵巣ガン"
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "卵巣がん"
''### 2010.12.18 MOD END TCS)H.F
    End If
'前コード
lngIndex = OCRGRP_START_Z + 4
    If vntLstResult(lngIndex)<>"" Then
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "子宮頸ガン"
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "子宮頸がん"
''### 2010.12.18 MOD END TCS)H.F
    End If


    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
lngIndex = OCRGRP_START4 + 26
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_9", , "18") & "良性卵巣腫瘍（右）" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_9", , "18") & "良性卵巣腫瘍（右）　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 27
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_10", , "19") & "良性卵巣腫瘍（左）" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_10", , "19") & "良性卵巣腫瘍（左）　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 28
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_11", , "22") & "繊毛性疾患" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_11", , "22") & "繊毛性疾患　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 26
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "良性卵巣腫瘍（右）"
    End If
lngIndex = OCRGRP_START4 + 27
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "良性卵巣腫瘍（左）"
    End If
lngIndex = OCRGRP_START4 + 28
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "繊毛性疾患"
    End If
'前コード
lngIndex = OCRGRP_START_Z + 0
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "卵巣腫瘍（右）"
    End If
lngIndex = OCRGRP_START_Z + 2
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "卵巣腫瘍（左）"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
lngIndex = OCRGRP_START4 + 29
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_12", , "20") & "付属器炎" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_12", , "20") & "付属器炎　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 30
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_13", , "4") & "膣炎" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_13", , "4") & "膣炎　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 31
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_14", , "21") & "膀胱子宮脱" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_14", , "21") & "膀胱子宮脱　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 29
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "付属器炎"
    End If
lngIndex = OCRGRP_START4 + 30
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "膣炎"
    End If
lngIndex = OCRGRP_START4 + 31
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "膀胱子宮脱"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
lngIndex = OCRGRP_START4 + 32
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_15", , "9") & "乳ガン" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_15", , "9") & "乳がん　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 33
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_16", , "90") & "その他" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_16", , "90") & "その他　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 32
    If vntLstResult(lngIndex)<>"" Then
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "乳ガン"
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "乳がん"
''### 2010.12.18 MOD END TCS)H.F
    End If
lngIndex = OCRGRP_START4 + 33
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他"
    End If
'前コード
lngIndex = OCRGRP_START_Z + 3
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "月経異常"
    End If
lngIndex = OCRGRP_START_Z + 5
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "不妊"
    End If
lngIndex = OCRGRP_START_Z + 1
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "子宮内膜症"
    End If
lngIndex = OCRGRP_START_Z + 6
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
            <TD NOWRAP BGCOLOR="#eeeeee">8.今までにホルモン療法を受けたことは</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 34
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_8", , "1") & "受けたことなし" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 34
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "受けたことなし"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 34
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_8", , "2") & "ある" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_8", , "2") & "ある　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 35
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "歳から" & vbLf
lngIndex = OCRGRP_START4 + 36
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "年間" & vbLf

    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 34
    Select Case vntLstResult(lngIndex)
    Case "2"
        strLstRsl = "ある→　"
lngIndex = OCRGRP_START4 + 35
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "歳から")
lngIndex = OCRGRP_START4 + 36
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "年間")
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
 
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><BR>　　" & vbLf
lngIndex = OCRGRP_START4 + 37
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_8", , "1") & "現在不妊治療中" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 37
    Select Case vntLstResult(lngIndex)
    Case "2"
        strLstRsl = "現在不妊治療中"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">9.今までに病気で婦人科の手術をしたこと</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 38
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9", , "1") & "受けたことなし　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9", , "2") & "はい　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "受けたことなし"
    Case "2"
        strLstRsl = "はい"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="0">
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
'    strHTML = ""
'    For i=0 To 2
'        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
'        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
'        strHTML = strHTML & "</TR>" & vbLf
'    Next
'    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP CELLSPACING="0" VALIGN="top">
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "　" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>「はい」の場合" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 39
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""100"">" & vbLf
''### 2010.12.18 MOD END TCS)H.F
''### 2010.12.18 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_1", , "1") & "右卵巣　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_1", , "1") & "右卵巣　　　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP >" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""150"">" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 41
''## 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_1", , "1") & "全摘" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_1", , "2") & "部分切除" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_1", , "1") & "全摘　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_1", , "2") & "部分切除" & vbLf
''## 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 40
'### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_2", , "1") & "良性　" & 	vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_2", , "2") & "境界方　" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_2", , "3") & "悪性　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_2", , "1") & "良性　　" & 	vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_2", , "2") & "境界型　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_2", , "3") & "悪性　　" & vbLf
'### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" HEIGHT=""10"" WIDTH=""40""></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 42
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 43
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_3", , "1") & "当院　" & vbLf
'#### 2010.07.09 SL-UI-Y0101-113 MOD START ####'
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_2", , "2") & "他院　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_3", , "2") & "他院　" & vbLf
'#### 2010.07.09 SL-UI-Y0101-113 MOD END ####'

    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 44
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_2", , "1") & "左卵巣　　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP >" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""150"">" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 46
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_1", , "1") & "全摘" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_1", , "2") & "部分切除" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_1", , "1") & "全摘　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_1", , "2") & "部分切除" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 45
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_2", , "1") & "良性　" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_2", , "2") & "境界方　" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_2", , "3") & "悪性　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_2", , "1") & "良性　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_2", , "2") & "境界型　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_2", , "3") & "悪性　　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" HEIGHT=""10"" WIDTH=""40""></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 47
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 48
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_3", , "1") & "当院　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_3", , "2") & "他院　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 49
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
'#### 2010.07.05 SL-UI-Y0101-113 MOD START ####'
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_3", , "1") & "子宮全摘術　　" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_3", , "3") & "子宮全摘術　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_3", , "3") & "子宮全摘術　　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
'#### 2010.07.05 SL-UI-Y0101-113 MOD END ####'

    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 50
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_3_1", , "1") & "膣式　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_3_1", , "2") & "腹式" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_3_1", , "3") & "その他" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" HEIGHT=""10"" WIDTH=""40""></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 51
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 52
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_3_2", , "1") & "当院　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_3_2", , "2") & "他院　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 53
    strHTML = strHTML & "<TD NOWRAP COLSPAN=""2"">" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_4", , "1") & "広汎子宮全摘術　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 54
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 55
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_4_1", , "1") & "当院　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_4_1", , "2") & "他院　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 56
    strHTML = strHTML & "<TD NOWRAP COLSPAN=""2"">" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_5", , "1") & "子宮頸部円錐切除術　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 57
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 58
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_5_1", , "1") & "当院　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_5_1", , "2") & "他院　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 59
    strHTML = strHTML & "<TD NOWRAP COLSPAN=""2"">" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_6", , "1") & "子宮筋腫核出術　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 60
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 61
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_6_1", , "1") & "当院　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_6_1", , "2") & "他院　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 62
    strHTML = strHTML & "<TD NOWRAP COLSPAN=""2"">" & vbLf
''### 2011.01.04 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_7", , "1") & "子宮上部切除術（子宮頸部残存）" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_7", , "1") & "子宮膣上部切断術（子宮頸部残存）" & vbLf
''### 2011.01.04 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 63
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 64
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_7_1", , "1") & "当院　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_7_1", , "2") & "他院　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 65
    strHTML = strHTML & "<TD NOWRAP COLSPAN=""2"">" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_8", , "1") & "その他の手術" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 66
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 67
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_8_1", , "1") & "当院　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_8_1", , "2") & "他院　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
<%
'---前回値---
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28""><TD>　</TD></TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 39
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "右卵巣"
    End If
'前コード
lngIndex = OCRGRP_START_Z + 18
    If (vntLstResult(lngIndex) = "4") AND ( (vntLstResult(lngIndex + 2 ) = "7") OR (vntLstResult(lngIndex + 2 ) = "9") )  Then
        strLstRsl = "右卵巣"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 40
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "　良性"
        Case "2"
            strLstRsl = strLstRsl & "　境界型"
        Case "3"
            strLstRsl = strLstRsl & "　悪性"
        End Select
    End If
lngIndex = OCRGRP_START4 + 41
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "　全摘"
        Case "2"
            strLstRsl = strLstRsl & "　部分切除"
        End Select
    End If
lngIndex = OCRGRP_START4 + 42
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "　" & vntLstResult(lngIndex) & "歳")
'前コード
lngIndex = OCRGRP_START_Z + 18
    If (vntLstResult(lngIndex) = "4") AND ( (vntLstResult(lngIndex + 2 ) = "7") OR (vntLstResult(lngIndex + 2 ) = "9") )  Then
		lngIndex = OCRGRP_START_Z + 19
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "　" & vntLstResult(lngIndex) & "歳")
    End If

lngIndex = OCRGRP_START4 + 43
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "　当院"
        Case "2"
            strLstRsl = strLstRsl & "　他院"
        End Select
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28""><TD>　</TD></TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 44
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "左卵巣"
    End If
'前コード
lngIndex = OCRGRP_START_Z + 18
    If (vntLstResult(lngIndex) = "4") AND ( (vntLstResult(lngIndex + 2 ) = "8") OR (vntLstResult(lngIndex + 2 ) = "9") )  Then
        strLstRsl = "左卵巣"
    End If
    If strLstRsl = "" Then
       strLstRsl = "　"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 45
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "　良性"
        Case "2"
            strLstRsl = strLstRsl & "　境界型"
        Case "3"
            strLstRsl = strLstRsl & "　悪性"
        End Select
    End If
lngIndex = OCRGRP_START4 + 46
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "　全摘"
        Case "2"
            strLstRsl = strLstRsl & "　部分切除"
        End Select
    End If
lngIndex = OCRGRP_START4 + 47
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "　" & vntLstResult(lngIndex) & "歳")
'前コード
lngIndex = OCRGRP_START_Z + 18
    If (vntLstResult(lngIndex) = "4") AND ( (vntLstResult(lngIndex + 2 ) = "8") OR (vntLstResult(lngIndex + 2 ) = "9") )  Then
		lngIndex = OCRGRP_START_Z + 19
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "　" & vntLstResult(lngIndex) & "歳")
    End If

lngIndex = OCRGRP_START4 + 48
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "　当院"
        Case "2"
            strLstRsl = strLstRsl & "　他院"
        End Select
    End If
    If strLstRsl = "" Then
       strLstRsl = "　"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28""><TD>　</TD></TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 49
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "子宮全摘術"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 50
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "　膣式"
        Case "2"
            strLstRsl = strLstRsl & "　腹式"
        Case "3"
            strLstRsl = strLstRsl & "　その他"
        End Select
    End If
lngIndex = OCRGRP_START4 + 51
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "　" & vntLstResult(lngIndex) & "歳")
'前コード
    If (vntLstResult(lngIndex) = "4") AND ( (vntLstResult(lngIndex + 2 ) = "8") OR (vntLstResult(lngIndex + 2 ) = "9") )  Then
		lngIndex = OCRGRP_START_Z + 17
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "　" & vntLstResult(lngIndex) & "歳")
    End If
lngIndex = OCRGRP_START4 + 52
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "　当院"
        Case "2"
            strLstRsl = strLstRsl & "　他院"
        End Select
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28""><TD>　</TD></TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 53
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "広汎子宮全摘術"
    End If
    If strLstRsl = "" Then
       strLstRsl = "　"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 54
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "　" & vntLstResult(lngIndex) & "歳")
lngIndex = OCRGRP_START4 + 55
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "　当院"
        Case "2"
            strLstRsl = strLstRsl & "　他院"
        End Select
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 56
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "子宮頸部円錐切除術"
    End If
    If strLstRsl = "" Then
       strLstRsl = "　"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 57
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "　" & vntLstResult(lngIndex) & "歳")
lngIndex = OCRGRP_START4 + 58
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "　当院"
        Case "2"
            strLstRsl = strLstRsl & "　他院"
        End Select
    End If

    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 59
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "子宮筋腫核出術"
    End If
'前コード
lngIndex = OCRGRP_START_Z + 16
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "子宮筋腫核出術"
    End If
    If strLstRsl = "" Then
       strLstRsl = "　"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 60
    strLstRsl = ""
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "　" & vntLstResult(lngIndex) & "歳")
'前コード
lngIndex = OCRGRP_START_Z + 17
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "　" & vntLstResult(lngIndex) & "歳")
lngIndex = OCRGRP_START4 + 61
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "　当院"
        Case "2"
            strLstRsl = strLstRsl & "　他院"
        End Select
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 62
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
''### 2011.01.04 ADD MOD STR TCS)H.F
''        strLstRsl = "子宮上部切除術（子宮頸部残存）"
        strLstRsl = "子宮膣上部切断術（子宮頸部残存）"
''### 2011.01.04 ADD MOD END TCS)H.F
    End If
    If strLstRsl = "" Then
       strLstRsl = "　"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 63
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "　" & vntLstResult(lngIndex) & "歳")
lngIndex = OCRGRP_START4 + 64
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "　当院"
        Case "2"
            strLstRsl = strLstRsl & "　他院"
        End Select
    End If

    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 65
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "その他の手術"
    End If
    If strLstRsl = "" Then
       strLstRsl = "　"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 66
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "　" & vntLstResult(lngIndex) & "歳")
lngIndex = OCRGRP_START4 + 67
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "　当院"
        Case "2"
            strLstRsl = strLstRsl & "　他院"
        End Select
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
            <TD NOWRAP BGCOLOR="#eeeeee">10.性体験は</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 68
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_10_1", , "1") & "ない　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_10_1", , "2") & "ある" & vbLf
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
            <TD NOWRAP BGCOLOR="#eeeeee">11．妊娠している可能性は</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 69
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_11_1", , "1") & "ない　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_11_1", , "2") & "ある" & vbLf
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
            <TD NOWRAP BGCOLOR="#eeeeee">12．妊娠分娩</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 70
    strHTML = strHTML & "<TD NOWRAP>　　妊娠の回数" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "回" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "回")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 71
    strHTML = strHTML & "<TD NOWRAP>　　分娩の回数" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "回（そのうち帝王切開" & vbLf
lngIndex = OCRGRP_START4 + 72
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "回）" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 71
    If vntLstResult(lngIndex) <> "" Then
        strLstRsl = strLstRsl & vntLstResult(lngIndex) & "回"
    End If
lngIndex = OCRGRP_START4 + 72
    If vntLstResult(lngIndex) <> "" Then
        strLstRsl = strLstRsl & "（帝王切開：" & vntLstResult(lngIndex) & "回）"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">13．閉経しましたか</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 73
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_13_1", , "1") & "いいえ" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 73
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "いいえ"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 73
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_13_1", , "2") & "はい" & vbLf
lngIndex = OCRGRP_START4 + 74
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "歳" & vbLf

    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 73
    Select Case vntLstResult(lngIndex)
    Case "2"
        strLstRsl = "はい→"
lngIndex = OCRGRP_START4 + 74
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "歳")
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">14．月経</TD>
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
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD>　　①最終月経　　　　</TD>" & vbLf
    strHTML = strHTML & "<TD WIDTH=""110"">　　①最終月経　　　　</TD>" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "<TD>　　<A HREF=""javascript:calGuide_showGuideCalendar('year14_1', 'month14_1', 'day14_1')""><IMG SRC=""../../images/question.gif"" WIDTH=""21"" HEIGHT=""21"" ALT=""日付ガイドを表示"" BORDER=""0""></A></TD>" & vbLf
lngIndex = OCRGRP_START4 + 75
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listyear", "year14_1", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>年</TD>" & vbLf
lngIndex = OCRGRP_START4 + 76
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listmonth", "month14_1", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>月</TD>" & vbLf
lngIndex = OCRGRP_START4 + 77
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listday", "day14_1", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>日</TD>" & vbLf
    strHTML = strHTML & "<TD>～</TD>" & vbLf
    strHTML = strHTML & "<TD><A HREF=""javascript:calGuide_showGuideCalendar('', 'month14_2', 'day14_2')""><IMG SRC=""../../images/question.gif"" WIDTH=""21"" HEIGHT=""21"" ALT=""日付ガイドを表示"" BORDER=""0""></A></TD>" & vbLf
    strHTML = strHTML & "<TD></TD>" & vbLf
    strHTML = strHTML & "<TD></TD>" & vbLf
lngIndex = OCRGRP_START4 + 78
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listmonth", "month14_2", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>月</TD>" & vbLf
lngIndex = OCRGRP_START4 + 79
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listday", "day14_2", , "") & "</TD>" & vbLf
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
lngIndex = OCRGRP_START4 + 75
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "年")
lngIndex = OCRGRP_START4 + 76
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "月")
lngIndex = OCRGRP_START4 + 77
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "日")
    strLstRsl = strLstRsl & "～"
lngIndex = OCRGRP_START4 + 78
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "月")
lngIndex = OCRGRP_START4 + 79
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
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD>　　②その前の月経　　　　</TD>" & vbLf
    strHTML = strHTML & "<TD WIDTH=""110"">　　②その前の月経　　　　</TD>" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "<TD>　　<A HREF=""javascript:calGuide_showGuideCalendar('year14_3', 'month14_3', 'day14_3')""><IMG SRC=""../../images/question.gif"" WIDTH=""21"" HEIGHT=""21"" ALT=""日付ガイドを表示"" BORDER=""0""></A></TD>" & vbLf
lngIndex = OCRGRP_START4 + 80
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listyear", "year14_3", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>年</TD>" & vbLf
lngIndex = OCRGRP_START4 + 81
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listmonth", "month14_3", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>月</TD>" & vbLf
lngIndex = OCRGRP_START4 + 82
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listday", "day14_3", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>日</TD>" & vbLf
    strHTML = strHTML & "<TD>～</TD>" & vbLf
    strHTML = strHTML & "<TD><A HREF=""javascript:calGuide_showGuideCalendar('', 'month14_4', 'day14_4')""><IMG SRC=""../../images/question.gif"" WIDTH=""21"" HEIGHT=""21"" ALT=""日付ガイドを表示"" BORDER=""0""></A></TD>" & vbLf
    strHTML = strHTML & "<TD></TD>" & vbLf
    strHTML = strHTML & "<TD></TD>" & vbLf
lngIndex = OCRGRP_START4 + 83
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listmonth", "month14_4", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>月</TD>" & vbLf
lngIndex = OCRGRP_START4 + 84
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listday", "day14_4", , "") & "</TD>" & vbLf
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
lngIndex = OCRGRP_START4 + 80
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "年")
lngIndex = OCRGRP_START4 + 81
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "月")
lngIndex = OCRGRP_START4 + 82
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "日")
    strLstRsl = strLstRsl & "～"
lngIndex = OCRGRP_START4 + 83
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "月")
lngIndex = OCRGRP_START4 + 84
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
lngIndex = OCRGRP_START4 + 85
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>　　③出血量" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_1", , "1") & "少ない　" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_1", , "2") & "ふつう" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_1", , "3") & "多い" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　③出血量　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_1", , "1") & "少ない　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_1", , "2") & "ふつう　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_1", , "3") & "多い" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
<%
    strHTML = ""
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "少ない"
    Case "2"
        strLstRsl = "ふつう"
    Case "3"
        strLstRsl = "多い"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>

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
lngIndex = OCRGRP_START4 + 86
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>　　④月経痛" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_2", , "4") & "軽い　" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_2", , "5") & "ふつう" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_2", , "6") & "強い" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　④月経痛　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_2", , "4") & "軽い　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_2", , "5") & "ふつう　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_2", , "6") & "強い　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
<%
    strHTML = ""
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "4"
        strLstRsl = "軽い"
    Case "5"
        strLstRsl = "ふつう"
    Case "6"
        strLstRsl = "強い"
'前コード
    Case "1"
        strLstRsl = "ない、又は軽い痛み"
    Case "2"
        strLstRsl = "強い痛みが時々ある"
    Case "3"
        strLstRsl = "毎回ひどい痛みがある"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl &  "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">15．6ヶ月以内に月経以外に出血したことは</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 87
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_15_1", , "1") & "ない" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 87
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "ない"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 87
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_15_1", , "4") & "ある" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_15_1", , "4") & "ある　　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 88
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_15_2", , "1") & "閉経後出血" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_15_2", , "2") & "性交時出血" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_15_2", , "3") & "その他の出血" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_15_2", , "1") & "閉経後出血　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_15_2", , "2") & "性交時出血　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_15_2", , "3") & "その他の出血　" & vbLf
''### 2010.12.18 MOD END TCS)H.F

    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 87
    Select Case vntLstResult(lngIndex)
    Case "2", "3","4"
        strLstRsl = "ある"
'前コード
		Select Case vntLstResult(lngIndex)
	    Case "2"
	        strLstRsl = strLstRsl & "（１年以内にある）"
	    Case "3"
	        strLstRsl = strLstRsl & "（１年以上前にある）"
		End Select

		lngIndex = OCRGRP_START4 + 88
	    Select Case vntLstResult(lngIndex)
	    Case "1"
	        strLstRsl = "→" & "閉経後出血"
	    Case "2"
	        strLstRsl = "→" & "性交時出血"
	    Case "3"
	        strLstRsl = "→" & "その他の出血"
	    End Select
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">16．その他気になる症状はありますか</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 89
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_16_1", , "1") & "ない" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 89
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "ない"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 89
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_16_1", , "10") & "ある" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_16_1", , "10") & "ある　　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 90
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_16_1", , "1") & "下腹部痛（月経痛以外で）" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_16_1", , "1") & "下腹部痛（月経痛以外で）　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 91
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_16_1", , "1") & "おりもの（水様性）" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_16_1", , "1") & "おりもの（水様性）　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 92
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_16_1", , "1") & "おりもの（血液、茶色含む）" & vbLf

    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 89
    Select Case vntLstResult(lngIndex)
    Case "4"
	lngIndex = OCRGRP_START4 + 90
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "下腹部痛（月経痛以外で）"
	    End If
	lngIndex = OCRGRP_START4 + 91
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "おりもの（水様性）"
	    End If
	lngIndex = OCRGRP_START4 + 92
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "おりもの（血液、茶色含む）"
	    End If
    End Select
'前コード
	lngIndex = OCRGRP_START_Z + 7
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "おりものが気になる"
    End If
	lngIndex = OCRGRP_START_Z + 8
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "陰部がかゆい"
    End If
	lngIndex = OCRGRP_START_Z + 9
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "下腹部が痛い"
    End If
	lngIndex = OCRGRP_START_Z + 10
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "更年期症状がつらい"
    End If
	lngIndex = OCRGRP_START_Z + 11
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "性交時に出血する"
    End If
    If strLstRsl = "" Then
        strLstRsl = "　"
    Else
        strLstRsl = "はい→" & strLstRsl 
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">17.ご家族で婦人科系のガンにかかられた方は</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>

<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 93
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_17_1", , "1") & "いない　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_17_1", , "10") & "いる　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---前回値---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "いない"
    Case "10"
        strLstRsl = "いる"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "　" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　「いる」の場合" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

    strHTML = ""
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD>" & vbLf

    strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPALING=""0"">"
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""170"">　　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 94
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_1", , "1") & "子宮頸ガン" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_1", , "1") & "子宮頸がん" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""60"">" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 95
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_2", , "1") & "実母　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_2", , "1") & "実母　　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""70"">" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 96
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_3", , "2") & "実姉妹　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_3", , "2") & "実姉妹　　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 97
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_4", , "3") & "その他血縁　" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_4", , "3") & "その他血縁　　" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
lngIndex = OCRGRP_START4 + 98
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_5", , "5") & "子宮体ガン" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_5", , "5") & "子宮体がん" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 99
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_6", , "1") & "実母　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 100
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_7", , "2") & "実姉妹　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 101
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_8", , "3") & "その他血縁　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
lngIndex = OCRGRP_START4 + 102
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_9", , "7") & "卵巣ガン" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_9", , "7") & "卵巣がん" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 103
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_10", , "1") & "実母　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 104
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_11", , "2") & "実姉妹　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 105
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_12", , "3") & "その他血縁　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
lngIndex = OCRGRP_START4 + 106
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_13", , "9") & "その他の婦人科ガン" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_13", , "9") & "その他の婦人科がん" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 107
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_14", , "1") & "実母　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 108
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_15", , "2") & "実姉妹　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 109
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_16", , "3") & "その他血縁　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    Response.Write strHTML

    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>　　" & vbLf
lngIndex = OCRGRP_START4 + 110
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_17", , "8") & "乳ガン" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_17", , "8") & "乳がん" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 111
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_18", , "1") & "実母　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 112
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_19", , "2") & "実姉妹　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 113
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_20", , "3") & "その他血縁　" & vbLf
    strHTML = strHTML & "</TD>" & vbLf

'------------
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "</TABLE>"
    strHTML = strHTML & "</TD>" & vbLf

    strHTML = strHTML & "<TD NOWRAP>" & vbLf
'前回値
    strHTML = strHTML & "  <TABLE BORDER=""0"" CELLSPALING=""0"">"

    strLstRsl = ""
    strHTML = strHTML & "  <TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 94
    Select Case vntLstResult(lngIndex)
    Case "1"
		lngIndex = OCRGRP_START4 + 95
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実母"
	    End If
		lngIndex = OCRGRP_START4 + 96
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実姉妹"
	    End If
		lngIndex = OCRGRP_START4 + 97
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他血縁"
	    End If
    End Select
'前コード
lngIndex = OCRGRP_START_Z + 12
    Select Case vntLstResult(lngIndex)
    Case "6"
		lngIndex = OCRGRP_START_Z + 13
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実母"
		    End If
		lngIndex = OCRGRP_START_Z + 14
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実姉妹"
		    End If
		lngIndex = OCRGRP_START_Z + 15
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他"
		    End If
    End Select
    If strLstRsl = "" Then
       strLstRsl = "　"
    Else
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = "子宮頸ガン→" & strLstRsl
        strLstRsl = "子宮頸がん→" & strLstRsl
''### 2010.12.18 MOD END TCS)H.F
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "  </TR>" & vbLf

    strLstRsl = ""
    strHTML = strHTML & "  <TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 98
    Select Case vntLstResult(lngIndex)
    Case "5"
		lngIndex = OCRGRP_START4 + 99
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実母"
	    End If
		lngIndex = OCRGRP_START4 + 100
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実姉妹"
	    End If
		lngIndex = OCRGRP_START4 + 101
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他血縁"
	    End If
		lngIndex = OCRGRP_START_Z + 13
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実母"
		    End If
		lngIndex = OCRGRP_START_Z + 14
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実姉妹"
		    End If
		lngIndex = OCRGRP_START_Z + 15
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他"
		    End If
    End Select
    If strLstRsl = "" Then
       strLstRsl = "　"
    Else
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = "子宮体ガン→" & strLstRsl
        strLstRsl = "子宮体がん→" & strLstRsl
''### 2010.12.18 MOD END TCS)H.F
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "  </TR>" & vbLf

    strLstRsl = ""
    strHTML = strHTML & "  <TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 102
    Select Case vntLstResult(lngIndex)
    Case "7"
		lngIndex = OCRGRP_START4 + 103
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実母"
	    End If
		lngIndex = OCRGRP_START4 + 104
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実姉妹"
	    End If
		lngIndex = OCRGRP_START4 + 105
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他血縁"
	    End If
		lngIndex = OCRGRP_START_Z + 13
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実母"
		    End If
		lngIndex = OCRGRP_START_Z + 14
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実姉妹"
		    End If
		lngIndex = OCRGRP_START_Z + 15
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他"
		    End If
    End Select
    If strLstRsl = "" Then
       strLstRsl = "　"
    Else
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl =  "卵巣ガン→" & strLstRsl
        strLstRsl =  "卵巣がん→" & strLstRsl
''### 2010.12.18 MOD END TCS)H.F
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "  </TR>" & vbLf

    strLstRsl = ""
    strHTML = strHTML & "  <TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 106
    Select Case vntLstResult(lngIndex)
    Case "9"
		lngIndex = OCRGRP_START4 + 107
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実母"
	    End If
		lngIndex = OCRGRP_START4 + 108
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実姉妹"
	    End If
		lngIndex = OCRGRP_START4 + 109
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他血縁"
	    End If
		lngIndex = OCRGRP_START_Z + 13
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実母"
		    End If
		lngIndex = OCRGRP_START_Z + 14
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実姉妹"
		    End If
		lngIndex = OCRGRP_START_Z + 15
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他"
		    End If
    End Select
    If strLstRsl = "" Then
       strLstRsl = "　"
    Else
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl =  "その他の婦人科ガン→" & strLstRsl
        strLstRsl =  "その他の婦人科がん→" & strLstRsl
''### 2010.12.18 MOD END TCS)H.F
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "  </TR>" & vbLf

    strLstRsl = ""
    strHTML = strHTML & "  <TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 110
    Select Case vntLstResult(lngIndex)
    Case "8"
		lngIndex = OCRGRP_START4 + 111
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実母"
	    End If
		lngIndex = OCRGRP_START4 + 112
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実姉妹"
	    End If
		lngIndex = OCRGRP_START4 + 113
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他血縁"
	    End If

		lngIndex = OCRGRP_START_Z + 13
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実母"
		    End If
		lngIndex = OCRGRP_START_Z + 14
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "実姉妹"
		    End If
		lngIndex = OCRGRP_START_Z + 15
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "その他"
		    End If

    End Select
    If strLstRsl = "" Then
       strLstRsl = "　"
    Else
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl =  "乳ガン→" & strLstRsl
        strLstRsl =  "乳がん→" & strLstRsl
''### 2010.12.18 MOD END TCS)H.F
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "  </TR>" & vbLf

    strHTML = strHTML & "  </TABLE>"

'------------
    strHTML = strHTML & "</TD>" & vbLf

    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>

    </TABLE>
<%
    Else
        strHTML = ""
''### 2011.01.04 MOD STR TCS)H.F
''        For i = 1 To 54
        For i = 1 To 53
''### 2011.01.04 MOD END TCS)H.F
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
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_1", , "1") & "速いほうである</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""120"">" & EditRsl(lngIndex, "radio", "opt5_2_1", , "1") & "速いほうである</TD>" & vbLf
''### 2010.12.18 MOD END TCS)H.F
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_1", , "2") & "それほどでもない</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""130"">" & EditRsl(lngIndex, "radio", "opt5_2_1", , "2") & "それほどでもない</TD>" & vbLf
''### 2010.12.18 MOD END TCS)H.F
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
' SL-UI-Y0101-607 前回複写ボタン追加 ADD STR
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""PreRsl"" VALUE=""" & vntLstResult(i) & """>"
' SL-UI-Y0101-607 前回複写ボタン追加 ADD END
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
