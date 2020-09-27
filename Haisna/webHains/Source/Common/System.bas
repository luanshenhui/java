Attribute VB_Name = "System"
Option Explicit

'
' 機能　　 : エラー情報書き込み
'
' 引数　　 : (In)     strMethodName  呼び出し元のメソッド名
'
' 戻り値　 :
'
' 備考　　 :
'
Public Sub WriteErrorLog(ByVal strMethodName As String)

    Dim strErrorMsg         As String   '編集用エラーメッセージ

    strErrorMsg = Err.Description

    'イベントログ書き込み（メッセージは任意編集追加）
    App.LogEvent vbCrLf & _
                 "webHains Application Error: " & Err.Source & vbCrLf & _
                 strMethodName & " 実行時ｴﾗｰ:'" & Err.Number & "' " & EditAdditionalMessage(strErrorMsg), vbLogEventTypeError

End Sub

' @(e)
'
' 機能　　 : エラーメッセージ再編集
'
' 引数　　 : (In)      strMsg  エラーメッセージ（基本的にはErr.Description)
'
' 機能説明 : エラーメッセージの内容から整合性エラー等を検出した場合、再度メッセージ編集
'
' 備考　　 : マスタメンテのMsgBox用にこの関数もPublic化
'
Public Function EditAdditionalMessage(ByVal strMsg As String) As String

    Dim strLastMessage  As String
    Dim strTargetTable  As String

    EditAdditionalMessage = strMsg

    '整合性エラー（子テーブルあり）の検出
    If InStr(strMsg, "ORA-02292") > 0 Then
        strTargetTable = GetErrorTableName(strMsg)
        If strTargetTable = "" Then

            strLastMessage = "このデータを使用しているデータが存在します。削除できません。" & vbLf & vbLf

        Else

            strLastMessage = GetErrorTableName(strMsg) & "でこのデータを使用しているため削除できません。" & vbLf & vbLf

        End If

        strLastMessage = strLastMessage & strMsg
        strMsg = strLastMessage
    End If

    EditAdditionalMessage = strMsg

End Function


' @(e)
'
' 機能　　 : エラーテーブル名取得
'
' 引数　　 : (In)      strMsg  エラーメッセージ
'
' 機能説明 : エラーメッセージ内のテーブル名から日本語テーブル名を索引して戻す
'
' 備考　　 : テーブル名の索引は１件だけ
'
Private Function GetErrorTableName(strMsg As String) As String

    Dim strLastMessage  As String

    GetErrorTableName = ""

'### 2002.03.21 Modified by H.Ishihara@FSIT 文字列の検索順番がおかしい
    '各テーブル名から検索（テキストエディタのマクロ機能を使ったのでこんな感じ）
'    If InStr(strMsg, "PERSON") > 0 Then GetErrorTableName = "個人テーブル": Exit Function
'    If InStr(strMsg, "PERSONDETAIL") > 0 Then GetErrorTableName = "個人属性テーブル": Exit Function
'    If InStr(strMsg, "WEB_USERID") > 0 Then GetErrorTableName = "webユーザIDテーブル": Exit Function
'    If InStr(strMsg, "PERRESULT") > 0 Then GetErrorTableName = "個人検査結果テーブル": Exit Function
'    If InStr(strMsg, "DISHISTORY") > 0 Then GetErrorTableName = "既往歴家族歴テーブル": Exit Function
'    If InStr(strMsg, "ORG") > 0 Then GetErrorTableName = "団体テーブル": Exit Function
'    If InStr(strMsg, "ORGPOST") > 0 Then GetErrorTableName = "所属テーブル": Exit Function
'    If InStr(strMsg, "ITEMCLASS") > 0 Then GetErrorTableName = "検査分類テーブル": Exit Function
'    If InStr(strMsg, "PROGRESS") > 0 Then GetErrorTableName = "進捗管理用分類テーブル": Exit Function
'    If InStr(strMsg, "OPECLASS") > 0 Then GetErrorTableName = "検査実施日分類テーブル": Exit Function
'    If InStr(strMsg, "ITEM_P") > 0 Then GetErrorTableName = "依頼項目テーブル": Exit Function
'    If InStr(strMsg, "ITEM_JUD") > 0 Then GetErrorTableName = "依頼項目判定分類テーブル": Exit Function
'    If InStr(strMsg, "ITEM_C") > 0 Then GetErrorTableName = "検査項目テーブル": Exit Function
'    If InStr(strMsg, "ITEM_H") > 0 Then GetErrorTableName = "検査項目履歴管理テーブル": Exit Function
'    If InStr(strMsg, "KARTEITEM") > 0 Then GetErrorTableName = "検査項目変換テーブル": Exit Function
'    If InStr(strMsg, "STDVALUE") > 0 Then GetErrorTableName = "基準値テーブル": Exit Function
'    If InStr(strMsg, "STDVALUE_C") > 0 Then GetErrorTableName = "基準値詳細テーブル": Exit Function
'    If InStr(strMsg, "CALC") > 0 Then GetErrorTableName = "計算テーブル": Exit Function
'    If InStr(strMsg, "CALC_C") > 0 Then GetErrorTableName = "計算方法テーブル": Exit Function
'    If InStr(strMsg, "SENTENCE") > 0 Then GetErrorTableName = "文章テーブル": Exit Function
'    If InStr(strMsg, "RECENT_SENTENCE") > 0 Then GetErrorTableName = "最近使った文章テーブル": Exit Function
'    If InStr(strMsg, "GRP_P") > 0 Then GetErrorTableName = "グループテーブル": Exit Function
'    If InStr(strMsg, "GRP_R") > 0 Then GetErrorTableName = "グループ内依頼項目テーブル": Exit Function
'    If InStr(strMsg, "GRP_I") > 0 Then GetErrorTableName = "グループ内検査項目テーブル": Exit Function
'    If InStr(strMsg, "COURSE_P") > 0 Then GetErrorTableName = "コーステーブル": Exit Function
'    If InStr(strMsg, "COURSE_JUD") > 0 Then GetErrorTableName = "コース判定分類テーブル": Exit Function
'    If InStr(strMsg, "COURSE_OPE") > 0 Then GetErrorTableName = "コース項目実施日テーブル": Exit Function
'    If InStr(strMsg, "COURSE_H") > 0 Then GetErrorTableName = "コース履歴管理テーブル": Exit Function
'    If InStr(strMsg, "COURSE_G") > 0 Then GetErrorTableName = "コース内グループテーブル": Exit Function
'    If InStr(strMsg, "COURSE_I") > 0 Then GetErrorTableName = "コース内検査項目テーブル": Exit Function
'    If InStr(strMsg, "RSVFRA_P") > 0 Then GetErrorTableName = "予約枠テーブル": Exit Function
'    If InStr(strMsg, "RSVFRA_C") > 0 Then GetErrorTableName = "予約枠内コーステーブル": Exit Function
'    If InStr(strMsg, "RSVFRA_I") > 0 Then GetErrorTableName = "予約枠内検査項目テーブル": Exit Function
'    If InStr(strMsg, "SCHEDULE") > 0 Then GetErrorTableName = "予約スケジューリングテーブル": Exit Function
'    If InStr(strMsg, "SCHEDULE_H") > 0 Then GetErrorTableName = "病院スケジューリングテーブル": Exit Function
'    If InStr(strMsg, "ORGRSV") > 0 Then GetErrorTableName = "団体予約人数テーブル": Exit Function
'    If InStr(strMsg, "ORGRSV_IFRA") > 0 Then GetErrorTableName = "団体予約検査項目枠テーブル": Exit Function
'    If InStr(strMsg, "ORGRSV_M") > 0 Then GetErrorTableName = "団体名簿テーブル": Exit Function
'    If InStr(strMsg, "ORGRSV_D") > 0 Then GetErrorTableName = "団体名簿明細テーブル": Exit Function
'    If InStr(strMsg, "DISEASE") > 0 Then GetErrorTableName = "病名テーブル": Exit Function
'    If InStr(strMsg, "JUDCLASS") > 0 Then GetErrorTableName = "判定分類テーブル": Exit Function
'    If InStr(strMsg, "JUD") > 0 Then GetErrorTableName = "判定テーブル": Exit Function
'    If InStr(strMsg, "STDJUD") > 0 Then GetErrorTableName = "定型所見テーブル": Exit Function
'    If InStr(strMsg, "JUDCMTSTC") > 0 Then GetErrorTableName = "判定コメントテーブル": Exit Function
'    If InStr(strMsg, "CONSULT") > 0 Then GetErrorTableName = "受診情報テーブル": Exit Function
'    If InStr(strMsg, "CONSULT_OPE") > 0 Then GetErrorTableName = "検査実施日管理テーブル": Exit Function
'    If InStr(strMsg, "CONSULT_O") > 0 Then GetErrorTableName = "受診オプション管理テーブル": Exit Function
'    If InStr(strMsg, "CONSULT_G") > 0 Then GetErrorTableName = "受診時追加グループテーブル": Exit Function
'    If InStr(strMsg, "CONSULT_I") > 0 Then GetErrorTableName = "受診時追加検査項目テーブル": Exit Function
'    If InStr(strMsg, "RECEIPT") > 0 Then GetErrorTableName = "受付情報テーブル": Exit Function
'    If InStr(strMsg, "RSL") > 0 Then GetErrorTableName = "検査結果テーブル": Exit Function
'    If InStr(strMsg, "RSLCMT") > 0 Then GetErrorTableName = "結果コメントテーブル": Exit Function
'    If InStr(strMsg, "JUDRSL") > 0 Then GetErrorTableName = "判定結果テーブル": Exit Function
'    If InStr(strMsg, "JUDRSL_C") > 0 Then GetErrorTableName = "判定所見テーブル": Exit Function
'    If InStr(strMsg, "OPTPRICE") > 0 Then GetErrorTableName = "追加オプション負担金テーブル": Exit Function
'    If InStr(strMsg, "GRPPRICE") > 0 Then GetErrorTableName = "追加グループ負担金テーブル": Exit Function
'    If InStr(strMsg, "ITEMPRICE") > 0 Then GetErrorTableName = "追加検査項目負担金テーブル": Exit Function
'    If InStr(strMsg, "CLOSEMNG") > 0 Then GetErrorTableName = "締め管理テーブル": Exit Function
'    If InStr(strMsg, "CTRMNG") > 0 Then GetErrorTableName = "契約管理テーブル": Exit Function
'    If InStr(strMsg, "CTRPT") > 0 Then GetErrorTableName = "契約パターンテーブル": Exit Function
'    If InStr(strMsg, "CTRPT_ORG") > 0 Then GetErrorTableName = "契約パターン負担元管理テーブル": Exit Function
'    If InStr(strMsg, "CTRPT_OPT") > 0 Then GetErrorTableName = "契約パターンオプション管理テーブル": Exit Function
'    If InStr(strMsg, "CTRPT_GRP") > 0 Then GetErrorTableName = "契約パターン内グループテーブル": Exit Function
'    If InStr(strMsg, "CTRPT_ITEM") > 0 Then GetErrorTableName = "契約パターン内検査項目テーブル": Exit Function
'    If InStr(strMsg, "CTRPT_PRICE") > 0 Then GetErrorTableName = "契約パターン負担金額管理テーブル": Exit Function
'    If InStr(strMsg, "BILL") > 0 Then GetErrorTableName = "請求書テーブル": Exit Function
'    If InStr(strMsg, "BILL_ORG") > 0 Then GetErrorTableName = "請求書団体管理テーブル": Exit Function
'    If InStr(strMsg, "BILLDETAIL") > 0 Then GetErrorTableName = "請求明細テーブル": Exit Function
'    If InStr(strMsg, "PAYMENT") > 0 Then GetErrorTableName = "入金テーブル": Exit Function
'    If InStr(strMsg, "BBS") > 0 Then GetErrorTableName = "掲示板テーブル": Exit Function
'    If InStr(strMsg, "HAINSUSER") > 0 Then GetErrorTableName = "ユーザテーブル": Exit Function
'    If InStr(strMsg, "ZIP") > 0 Then GetErrorTableName = "郵便番号テーブル": Exit Function
'    If InStr(strMsg, "PREF") > 0 Then GetErrorTableName = "都道府県テーブル": Exit Function
'    If InStr(strMsg, "WEB_CS") > 0 Then GetErrorTableName = "webコーステーブル": Exit Function
'    If InStr(strMsg, "WEB_CSDETAIL") > 0 Then GetErrorTableName = "webコース詳細テーブル": Exit Function
'    If InStr(strMsg, "WEB_OPT") > 0 Then GetErrorTableName = "webオプション検査テーブル": Exit Function
'    If InStr(strMsg, "HPTINFO") > 0 Then GetErrorTableName = "ヘルスポイント情報テーブル": Exit Function
'    If InStr(strMsg, "HPTJUD") > 0 Then GetErrorTableName = "ヘルスポイント判定テーブルテーブル": Exit Function
'    If InStr(strMsg, "FREE") > 0 Then GetErrorTableName = "汎用テーブル": Exit Function
'    If InStr(strMsg, "REPORT") > 0 Then GetErrorTableName = "帳票管理テーブル": Exit Function
'    If InStr(strMsg, "REPORTLOG") > 0 Then GetErrorTableName = "印刷ログテーブル": Exit Function
'    If InStr(strMsg, "WORKSTATION") > 0 Then GetErrorTableName = "端末管理テーブル": Exit Function
'    If InStr(strMsg, "ORDEREDDOC") > 0 Then GetErrorTableName = "送信オーダ文書情報テーブル": Exit Function
'    If InStr(strMsg, "ORDEREDITEM") > 0 Then GetErrorTableName = "送信オーダ項目情報テーブル": Exit Function
'    If InStr(strMsg, "ORDERJNL") > 0 Then GetErrorTableName = "オーダ送信ジャーナルテーブル": Exit Function
'    If InStr(strMsg, "ORDERREPORT") > 0 Then GetErrorTableName = "レポート情報テーブル": Exit Function
'
''### 2002.04.12 Added by H.Ishihara@FSIT メンタルヘルス系テーブル追加
'    If InStr(strMsg, "MENTALHEALTH") > 0 Then GetErrorTableName = "メンタルヘルス情報管理テーブル": Exit Function
'    If InStr(strMsg, "MHCOMMNET") > 0 Then GetErrorTableName = "メンタルヘルスコメント情報管理テーブル": Exit Function
''### 2002.04.12 Added End
    If InStr(strMsg, "ZIP") > 0 Then GetErrorTableName = "郵便番号テーブル": Exit Function
    If InStr(strMsg, "ZAIMU_JNL") > 0 Then GetErrorTableName = "財務連携ジャーナルテーブル": Exit Function
    If InStr(strMsg, "ZAIMU") > 0 Then GetErrorTableName = "財務適用テーブル": Exit Function
    If InStr(strMsg, "WORKSTATION") > 0 Then GetErrorTableName = "端末管理テーブル": Exit Function
    If InStr(strMsg, "WEB_USERID") > 0 Then GetErrorTableName = "webユーザIDテーブル": Exit Function
    If InStr(strMsg, "WEB_OPT") > 0 Then GetErrorTableName = "webオプション検査テーブル": Exit Function
    If InStr(strMsg, "WEB_CSDETAIL") > 0 Then GetErrorTableName = "webコース詳細テーブル": Exit Function
    If InStr(strMsg, "WEB_CS") > 0 Then GetErrorTableName = "webコーステーブル": Exit Function
    If InStr(strMsg, "TESTTUBEMNG") > 0 Then GetErrorTableName = "検体番号管理テーブル": Exit Function
    If InStr(strMsg, "STDVALUE_C") > 0 Then GetErrorTableName = "基準値詳細テーブル": Exit Function
    If InStr(strMsg, "STDVALUE") > 0 Then GetErrorTableName = "基準値テーブル": Exit Function
    If InStr(strMsg, "STDJUD") > 0 Then GetErrorTableName = "定型所見テーブル": Exit Function
    If InStr(strMsg, "STDCONTACTSTC") > 0 Then GetErrorTableName = "定型面接文章テーブル": Exit Function
    If InStr(strMsg, "STCCLASS") > 0 Then GetErrorTableName = "文章分類テーブル": Exit Function
    If InStr(strMsg, "SENTENCE") > 0 Then GetErrorTableName = "文章テーブル": Exit Function
    If InStr(strMsg, "SCHEDULE_H") > 0 Then GetErrorTableName = "病院スケジューリングテーブル": Exit Function
    If InStr(strMsg, "SCHEDULE") > 0 Then GetErrorTableName = "予約スケジューリングテーブル": Exit Function
    If InStr(strMsg, "RSVFRA_P") > 0 Then GetErrorTableName = "予約枠テーブル": Exit Function
    If InStr(strMsg, "RSVFRA_I") > 0 Then GetErrorTableName = "予約枠内検査項目テーブル": Exit Function
    If InStr(strMsg, "RSVFRA_C") > 0 Then GetErrorTableName = "予約枠内コーステーブル": Exit Function
    If InStr(strMsg, "RSLENTRYLOG") > 0 Then GetErrorTableName = "検査結果入力ログテーブル": Exit Function
    If InStr(strMsg, "RSLCMT") > 0 Then GetErrorTableName = "結果コメントテーブル": Exit Function
    If InStr(strMsg, "RSL") > 0 Then GetErrorTableName = "検査結果テーブル": Exit Function
    If InStr(strMsg, "ROUNDCLASSPRICE") > 0 Then GetErrorTableName = "まるめ分類金額管理テーブル": Exit Function
    If InStr(strMsg, "ROUNDCLASS") > 0 Then GetErrorTableName = "まるめ分類テーブル": Exit Function
    If InStr(strMsg, "REPORTLOG") > 0 Then GetErrorTableName = "印刷ログテーブル": Exit Function
    If InStr(strMsg, "REPORT") > 0 Then GetErrorTableName = "帳票管理テーブル": Exit Function
    If InStr(strMsg, "RELATION") > 0 Then GetErrorTableName = "続柄テーブル": Exit Function
    If InStr(strMsg, "RECENT_SENTENCE") > 0 Then GetErrorTableName = "最近使った文章テーブル": Exit Function
    If InStr(strMsg, "RECEIPT") > 0 Then GetErrorTableName = "受付情報テーブル": Exit Function
    If InStr(strMsg, "PROGRESS") > 0 Then GetErrorTableName = "進捗管理用分類テーブル": Exit Function
    If InStr(strMsg, "PREF") > 0 Then GetErrorTableName = "都道府県テーブル": Exit Function
    If InStr(strMsg, "PERWORKINFO") > 0 Then GetErrorTableName = "個人就労情報テーブル": Exit Function
    If InStr(strMsg, "PERSONDETAIL") > 0 Then GetErrorTableName = "個人属性テーブル": Exit Function
    If InStr(strMsg, "PERSON") > 0 Then GetErrorTableName = "個人テーブル": Exit Function
    If InStr(strMsg, "PERRESULT") > 0 Then GetErrorTableName = "個人検査結果テーブル": Exit Function
    If InStr(strMsg, "PERDISEASE") > 0 Then GetErrorTableName = "傷病休業情報テーブル": Exit Function
    If InStr(strMsg, "PAYMENT") > 0 Then GetErrorTableName = "入金テーブル": Exit Function
    If InStr(strMsg, "PASSEDINFO") > 0 Then GetErrorTableName = "端末通過情報テーブル": Exit Function
    If InStr(strMsg, "ORGWKPOST") > 0 Then GetErrorTableName = "労基署所属テーブル": Exit Function
    If InStr(strMsg, "ORGRSV_M") > 0 Then GetErrorTableName = "団体名簿テーブル": Exit Function
    If InStr(strMsg, "ORGRSV_IFRA") > 0 Then GetErrorTableName = "団体予約検査項目枠テーブル": Exit Function
    If InStr(strMsg, "ORGRSV_D") > 0 Then GetErrorTableName = "団体名簿明細テーブル": Exit Function
    If InStr(strMsg, "ORGRSV") > 0 Then GetErrorTableName = "団体予約人数テーブル": Exit Function
    If InStr(strMsg, "ORGROOM") > 0 Then GetErrorTableName = "室部テーブル": Exit Function
    If InStr(strMsg, "ORGPOST") > 0 Then GetErrorTableName = "所属テーブル": Exit Function
    If InStr(strMsg, "ORGBSD") > 0 Then GetErrorTableName = "事業部テーブル": Exit Function
    If InStr(strMsg, "ORGBILLCLASS") > 0 Then GetErrorTableName = "団体管理請求書分類テーブル": Exit Function
    If InStr(strMsg, "ORG") > 0 Then GetErrorTableName = "団体テーブル": Exit Function
    If InStr(strMsg, "ORDERREPORT") > 0 Then GetErrorTableName = "レポート情報テーブル": Exit Function
    If InStr(strMsg, "ORDERJNL") > 0 Then GetErrorTableName = "オーダ送信ジャーナルテーブル": Exit Function
    If InStr(strMsg, "ORDEREDITEM") > 0 Then GetErrorTableName = "送信オーダ項目情報テーブル": Exit Function
    If InStr(strMsg, "ORDEREDDOC") > 0 Then GetErrorTableName = "送信オーダ文書情報テーブル": Exit Function
    If InStr(strMsg, "OPTPRICE") > 0 Then GetErrorTableName = "追加オプション負担金テーブル": Exit Function
    If InStr(strMsg, "OPECLASS") > 0 Then GetErrorTableName = "検査実施日分類テーブル": Exit Function
    If InStr(strMsg, "NOCTR_ITEMS_TEMP") > 0 Then GetErrorTableName = "契約外項目料金出力用一時テーブル": Exit Function
    If InStr(strMsg, "MONEY_DETAILS_TEMP") > 0 Then GetErrorTableName = "個人料金計算用一時テーブル": Exit Function
    If InStr(strMsg, "MONEY_CLOSE_TEMP") > 0 Then GetErrorTableName = "締め処理作業一時テーブル": Exit Function
    If InStr(strMsg, "KARTEITEM") > 0 Then GetErrorTableName = "検査項目変換テーブル": Exit Function
    If InStr(strMsg, "JUDRSL_C") > 0 Then GetErrorTableName = "判定所見テーブル": Exit Function
    If InStr(strMsg, "JUDRSL") > 0 Then GetErrorTableName = "判定結果テーブル": Exit Function
    If InStr(strMsg, "JUDCMTSTC") > 0 Then GetErrorTableName = "判定コメントテーブル": Exit Function
    If InStr(strMsg, "JUDCLASS") > 0 Then GetErrorTableName = "判定分類テーブル": Exit Function
    If InStr(strMsg, "JUD") > 0 Then GetErrorTableName = "判定テーブル": Exit Function
    If InStr(strMsg, "ITEMPRICE") > 0 Then GetErrorTableName = "追加検査項目負担金テーブル": Exit Function
    If InStr(strMsg, "ITEMCLASS") > 0 Then GetErrorTableName = "検査分類テーブル": Exit Function
    If InStr(strMsg, "ITEM_P_PRICE") > 0 Then GetErrorTableName = "依頼項目単価テーブル": Exit Function
    If InStr(strMsg, "ITEM_P") > 0 Then GetErrorTableName = "依頼項目テーブル": Exit Function
    If InStr(strMsg, "ITEM_JUD") > 0 Then GetErrorTableName = "依頼項目判定分類テーブル": Exit Function
    If InStr(strMsg, "ITEM_H") > 0 Then GetErrorTableName = "検査項目履歴管理テーブル": Exit Function
    If InStr(strMsg, "ITEM_C") > 0 Then GetErrorTableName = "検査項目テーブル": Exit Function
    If InStr(strMsg, "HPTJUD") > 0 Then GetErrorTableName = "ヘルスポイント判定テーブル": Exit Function
    If InStr(strMsg, "HPTINFO") > 0 Then GetErrorTableName = "ヘルスポイント情報テーブル": Exit Function
    If InStr(strMsg, "HAINSUSER") > 0 Then GetErrorTableName = "ユーザテーブル": Exit Function
    If InStr(strMsg, "HAINSLOG") > 0 Then GetErrorTableName = "ログテーブル": Exit Function
    If InStr(strMsg, "GUIDANCE") > 0 Then GetErrorTableName = "指導内容テーブル": Exit Function
    If InStr(strMsg, "GRPPRICE") > 0 Then GetErrorTableName = "追加グループ負担金テーブル": Exit Function
    If InStr(strMsg, "GRP_R") > 0 Then GetErrorTableName = "グループ内依頼項目テーブル": Exit Function
    If InStr(strMsg, "GRP_P") > 0 Then GetErrorTableName = "グループテーブル": Exit Function
    If InStr(strMsg, "GRP_I") > 0 Then GetErrorTableName = "グループ内検査項目テーブル": Exit Function
    If InStr(strMsg, "FREE") > 0 Then GetErrorTableName = "汎用テーブル": Exit Function
    If InStr(strMsg, "FILMMNG") > 0 Then GetErrorTableName = "フィルム番号管理テーブル": Exit Function
    If InStr(strMsg, "FILMMNG") > 0 Then GetErrorTableName = "フィルム番号管理テーブル": Exit Function
    If InStr(strMsg, "DMDLINECLASS") > 0 Then GetErrorTableName = "請求明細分類テーブル": Exit Function
    If InStr(strMsg, "DISHISTORY") > 0 Then GetErrorTableName = "既往歴家族歴テーブル": Exit Function
    If InStr(strMsg, "DISEASE") > 0 Then GetErrorTableName = "病名テーブル": Exit Function
    If InStr(strMsg, "DISDIV") > 0 Then GetErrorTableName = "病類テーブル": Exit Function
    If InStr(strMsg, "CTRPT_PRICE") > 0 Then GetErrorTableName = "契約パターン負担金額管理テーブル": Exit Function
    If InStr(strMsg, "CTRPT_ORG") > 0 Then GetErrorTableName = "契約パターン負担元管理テーブル": Exit Function
    If InStr(strMsg, "CTRPT_OPTAGE") > 0 Then GetErrorTableName = "契約パターンオプション年齢条件テーブル": Exit Function
    If InStr(strMsg, "CTRPT_OPT") > 0 Then GetErrorTableName = "契約パターンオプション管理テーブル": Exit Function
    If InStr(strMsg, "CTRPT_ITEM") > 0 Then GetErrorTableName = "契約パターン内検査項目テーブル": Exit Function
    If InStr(strMsg, "CTRPT_GRP") > 0 Then GetErrorTableName = "契約パターン内グループテーブル": Exit Function
    If InStr(strMsg, "CTRPT_AGE") > 0 Then GetErrorTableName = "契約パターン年齢区分テーブル": Exit Function
    If InStr(strMsg, "CTRPT") > 0 Then GetErrorTableName = "契約パターンテーブル": Exit Function
    If InStr(strMsg, "CTRMNG") > 0 Then GetErrorTableName = "契約管理テーブル": Exit Function
    If InStr(strMsg, "COURSE_P") > 0 Then GetErrorTableName = "コーステーブル": Exit Function
    If InStr(strMsg, "COURSE_OPE") > 0 Then GetErrorTableName = "コース項目実施日テーブル": Exit Function
    If InStr(strMsg, "COURSE_JUD") > 0 Then GetErrorTableName = "コース判定分類テーブル": Exit Function
    If InStr(strMsg, "COURSE_I") > 0 Then GetErrorTableName = "コース内検査項目テーブル": Exit Function
    If InStr(strMsg, "COURSE_H") > 0 Then GetErrorTableName = "コース履歴管理テーブル": Exit Function
    If InStr(strMsg, "COURSE_G") > 0 Then GetErrorTableName = "コース内グループテーブル": Exit Function
    If InStr(strMsg, "CONSULT_ZAIMU") > 0 Then GetErrorTableName = "財務連携テーブル": Exit Function
    If InStr(strMsg, "CONSULT_OPE") > 0 Then GetErrorTableName = "検査実施日管理テーブル": Exit Function
    If InStr(strMsg, "CONSULT_O") > 0 Then GetErrorTableName = "受診オプション管理テーブル": Exit Function
    If InStr(strMsg, "CONSULT_M") > 0 Then GetErrorTableName = "受診金額確定テーブル": Exit Function
    If InStr(strMsg, "CONSULT_I") > 0 Then GetErrorTableName = "受診時追加検査項目テーブル": Exit Function
    If InStr(strMsg, "CONSULT_G") > 0 Then GetErrorTableName = "受診時追加グループテーブル": Exit Function
    If InStr(strMsg, "CONSULT") > 0 Then GetErrorTableName = "受診情報テーブル": Exit Function
    If InStr(strMsg, "CLOSEMNG") > 0 Then GetErrorTableName = "締め管理テーブル": Exit Function
    If InStr(strMsg, "CALC_C") > 0 Then GetErrorTableName = "計算方法テーブル": Exit Function
    If InStr(strMsg, "CALC") > 0 Then GetErrorTableName = "計算テーブル": Exit Function
    If InStr(strMsg, "BILLDETAIL") > 0 Then GetErrorTableName = "請求明細テーブル": Exit Function
    If InStr(strMsg, "BILLCLASS_C") > 0 Then GetErrorTableName = "請求書分類管理コーステーブル": Exit Function
    If InStr(strMsg, "BILLCLASS") > 0 Then GetErrorTableName = "請求書分類テーブル": Exit Function
    If InStr(strMsg, "BILL_ORG") > 0 Then GetErrorTableName = "請求書団体管理テーブル": Exit Function
    If InStr(strMsg, "BILL_COURSE") > 0 Then GetErrorTableName = "請求書団体別コース管理テーブル": Exit Function
    If InStr(strMsg, "BILL") > 0 Then GetErrorTableName = "請求書テーブル": Exit Function
    If InStr(strMsg, "BBS") > 0 Then GetErrorTableName = "掲示板テーブル": Exit Function
    If InStr(strMsg, "AFTERCARE_M") > 0 Then GetErrorTableName = "アフターケア管理項目テーブル": Exit Function
    If InStr(strMsg, "AFTERCARE_CLOSE") > 0 Then GetErrorTableName = "アフターケア締め管理テーブル": Exit Function
    If InStr(strMsg, "AFTERCARE_C") > 0 Then GetErrorTableName = "アフターケア面接文章テーブル": Exit Function
    If InStr(strMsg, "AFTERCARE") > 0 Then GetErrorTableName = "アフターケアテーブル": Exit Function
'### 2002.03.21 Modified End

End Function

'## 2003.02.06 Add Function By T.Takagi@FSIT SGA浪費対策
'
' 機能　　 : 引数の文字列から改行、２桁以上の空白を除去する
'
' 引数　　 : (In)     Base  元になる文字列
'
' 戻り値　 : 文字列  除去OK
'            ""      除去NG
'
' 備考　　 : 本関数はSQL文から Chr(13)、空白を一括して取り除く場合等に使用
'
Public Function OmitCharSpc(Base As String) As String

'### 2003/05/23 Updated by Ishihara@FSIT 超ロングSQLがくるとオーバーフロー
'    Dim i       As Integer  '文字列操作時の現在のﾎﾟｼﾞｼｮﾆﾝｸﾞ
'    Dim j       As Integer  '検索文字列の発見位置
    Dim i       As Long     '文字列操作時の現在のﾎﾟｼﾞｼｮﾆﾝｸﾞ
    Dim j       As Long     '検索文字列の発見位置
'### 2003/05/23 Updated End

    Dim Ret     As Variant
    Dim Answer  As String

    Dim work As String

    work = vbLf
    OmitCharSpc = ""

'    '' chr(13) 改行除去
'    i = 1
'    Answer = ""
'    Do
'        Ret = InStr(i, Base, work)
'        '' 戻り値がNullの場合
'        If Ret = Null Then
'            MsgBox "引数が正しくありません"
'
'            Exit Function
'        Else
'            j = CInt(Ret)
'            If j = 0 Then
'                '' 検索文字列がない場合
'                Answer = Answer & Mid(Base, i, Len(Base) - i + 1)
'                i = Len(Base) + 1
'            Else
'                '' 検索文字列を発見した場合
'                Answer = Answer & Mid(Base, i, j - i)
'                i = j + 1
'            End If
'        End If
'
'        '' ﾎﾟｼﾞｼｮﾆﾝｸﾞが変換元文字数より大きくなれば Exit Do
'        If i > Len(Base) Then Exit Do
'    Loop
    Answer = Replace(Base, vbLf, " ")

    '' 2桁以上の空白除去
    i = 1
    Base = Trim(Answer)
    Answer = ""
    Do
        Ret = InStr(i, Base, Space(1))
        '' 戻り値がNullの場合
        If Ret = Null Then
'### 2003/05/23 Updated by Ishihara@FSIT それはいけません
'            MsgBox "引数が正しくありません"
            App.LogEvent vbCrLf & _
                         "webHains Application Error: " & "OmitCharSpc" & vbCrLf & _
                         "SQL文がセットされていません。", vbLogEventTypeError
'### 2003/05/23 Updated End

            Exit Function
        Else
'### 2003/05/23 Updated by Ishihara@FSIT 超ロングSQLがくるとオーバーフロー
'            j = CInt(Ret)
            j = CLng(Ret)
'### 2003/05/23 Updated End
            If j = 0 Then
                '' 検索文字列がない場合
                Answer = Answer & Mid(Base, i, Len(Base) - i + 1)
                i = Len(Base) + 1
            Else
                '' 検索文字列を発見した場合
                Answer = Answer & Mid(Base, i, j - i) & Space(1)
                i = j + 1
                '' 次も空白文字の場合、空白以外までシフト
                Do
                    If Mid(Base, i, 1) = Space(1) Then
                        i = i + 1
                    Else
                        Exit Do
                    End If
                Loop
            End If
        End If

        '' ﾎﾟｼﾞｼｮﾆﾝｸﾞが変換元文字数より大きくなれば Exit Do
        If i > Len(Base) Then Exit Do
    Loop

    OmitCharSpc = Answer

End Function
