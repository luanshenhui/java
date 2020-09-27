VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 4  'RequiresNewTransaction
END
Attribute VB_Name = "Request2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

Private Const TRANSACTIONDIV_REQUEST    As String = "LOGREQISP"     '検査依頼用のログ処理ＩＤ
Private Const FREECD_TESTTUBENO         As String = "TESTTUBENO"    '検体番号の発番情報
Private Const FREECD_PATIENTNO          As String = "PATIENTNO"     '患者ＩＤの発番情報
Private Const ITEMCOUNT_OF_ITEM_REC     As Long = 9                 '１検査項目レコード当たりの要検査項目数
Private Const LENGTH_PATIENTNO          As Long = 10                '患者番号の項目長

'
' 機能　　 : 送信ストリーム内容を配列に追加する
'
' 引数　　 : (In)     vntStream  送信ストリームの配列
' 　　　　   (In)     udtBuffer  送信データ
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub AppendStream(ByRef vntStream As Variant, ByRef udtBuffer As BUFFER_REC)

    Dim Index   As Long '次に追加する配列の添字
    
    '配列の作成および要素数の取得
    If IsEmpty(vntStream) Then
        vntStream = Array()
        Index = 0
    Else
        Index = UBound(vntStream) + 1
    End If
    
    '配列の最後部に要素を追加
    ReDim Preserve vntStream(Index)
    
    'バッファ文字列の未初期化部分(Null文字)を空白に置換して追加
    '(全角文字の存在によりバイト数＝文字数とならないのでStrConv関数を使用)
    vntStream(Index) = StrConv(LeftB(StrConv(Replace(udtBuffer.Buffer, vbNullChar, " "), vbFromUnicode), Len(udtBuffer)), vbUnicode)

End Sub

'
' 機能　　 : 検査依頼ファイルの作成
'
' 引数　　 : (In)     lngTransactionId  トランザクションＩＤ
' 　　　　   (In)     strReqCd          依頼元コード
' 　　　　   (In)     strFileName       検査依頼ファイル名
' 　　　　   (In)     dtmCslDate        受診日
' 　　　　   (In)     lngRsvNo          予約番号
' 　　　　   (In)     lngDayId          当日ＩＤ
' 　　　　   (In)     strPerId          個人ＩＤ
' 　　　　   (In)     strName           氏名
' 　　　　   (In)     strKanaName       カナ氏名
' 　　　　   (In)     lngGender         性別
' 　　　　   (In)     dtmBirth          生年月日
' 　　　　   (In)     lngAge            年齢
' 　　　　   (In)     dblPatientNo      患者番号
' 　　　　   (In)     blnIncSentData    送信済みデータを対象とするか(True:対象)
'
' 戻り値　 : True   送信された
' 　　　　   False  送信されなかった
'
' 備考　　 :
'
Public Function CreateFile( _
    ByVal lngTransactionId As Long, _
    ByVal strReqCd As String, _
    ByVal strFileName As String, _
    ByVal dtmCslDate As Date, _
    ByVal lngRsvNo As Long, _
    ByVal lngDayId As Long, _
    ByVal strPerId As String, _
    ByVal strName As String, _
    ByVal strKanaName As String, _
    ByVal lngGender As String, _
    ByVal dtmBirth As Date, _
    ByVal lngAge As Long, _
    ByVal dblPatientNo As Double, _
    ByVal blnIncSentData As Boolean _
) As Boolean

    Dim objConsult          As Object       '受診情報アクセス用
    Dim objFree             As Object       '汎用情報アクセス用
    Dim objHainsLog         As Object       'ログ情報アクセス用

    Dim vntCurTestTubeNo    As Variant      '検体番号
    Dim vntCurSepOrderDiv   As Variant      'オーダ分割区分
    Dim lngTestTubeCount    As Variant      '検体番号管理レコード数

    Dim vntAllSepOrderDiv   As Variant      'オーダ分割区分
    Dim vntAllReqItemCd     As Variant      '検査依頼用項目コード
    Dim lngAllItemCount     As Long         '検査用変換項目数

    Dim lngCurTestTubeNo    As Long         '検体番号

    Dim strNewSepOrderDiv() As String       'オーダ分割区分
    Dim strNewReqItemCd()   As String       '検査依頼用項目コード
    Dim lngNewItemCount     As Long         '検査用変換項目数

    Dim lngSepOrderDiv      As Long         'オーダ分割区分
    Dim strLastReqItemCd()  As String       '検査依頼用項目コード
    Dim lngLastItemCount    As Long         '検査用変換項目数

    Dim lngTestTubeNo       As Long         '現在の最大検体番号
    Dim lngMinTestTubeNo    As Long         '検体番号の最小値
    Dim lngMaxTestTubeNo    As Long         '検体番号の最大値

    Dim lngUseTestTubeNo    As Long         '使用する検体番号

    Dim vntStream           As Variant      '送信ストリーム

    Dim intFileNo           As Integer      'ファイル番号

    Dim strMessage1         As String       'メッセージ１
    Dim strMessage2         As String       'メッセージ２
    Dim Ret                 As Boolean      '関数戻り値
    Dim Ret2                As Boolean      '関数戻り値
    
    Dim i                   As Long         'インデックス
    Dim j                   As Long         'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objConsult = CreateObject("HainsConsult.Consult")
    Set objFree = CreateObject("HainsFree.Free")
    Set objHainsLog = CreateObject("HainsHainsLog.HainsLog")
    
    Do
    
        '検体番号の発番管理情報レコードロック
        If objFree.SelectFree(0, FREECD_TESTTUBENO, , , , , , , , , True) <= 0 Then
            objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "E", "", "検体番号発番管理情報の取得に失敗しました。", ""
            Exit Do
        End If
    
        '指定日における現在の最大検体番号と、検体番号の発番管理情報とを取得
        strMessage1 = GetTestTubeNo(dtmCslDate, lngTestTubeNo, lngMinTestTubeNo, lngMaxTestTubeNo)
        If strMessage1 <> "" Then
            objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "E", "", strMessage1, ""
            Exit Do
        End If
    
        '受診情報をもとにメッセージ２を予め作成
        strMessage2 = "当日ＩＤ=" & Format(lngDayId, "0000") & "、氏名=" & strName & "（" & strPerId & "）、予約番号=" & lngRsvNo
    
        '指定受診情報の要検査依頼項目を取得する
        lngAllItemCount = SelectReqItemFromRsl(lngRsvNo, vntAllSepOrderDiv, vntAllReqItemCd)
        If lngAllItemCount <= 0 Then
            objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "I", "", "送信対象となる依頼項目が存在しません。", strMessage2
            Exit Do
        End If
    
        '現在の検体番号管理レコードを読み込む
        lngTestTubeCount = objConsult.SelectTestTubeMng(lngRsvNo, vntCurTestTubeNo, vntCurSepOrderDiv)
    
        '送信済みデータを含まない場合
        If blnIncSentData = False Then
    
            '要検査依頼項目を検索
            For i = 0 To lngAllItemCount - 1
    
                '検査依頼項目のオーダ分割区分が(すでに送信済みである)検体番号管理情報に存在するかを検索
                lngCurTestTubeNo = -1
                For j = 0 To lngTestTubeCount - 1
                    If vntCurSepOrderDiv(j) = vntAllSepOrderDiv(i) Then
                        lngCurTestTubeNo = vntCurTestTubeNo(j)
                        Exit For
                    End If
                Next j
                
                '存在しない場合は新・要検査依頼項目として退避
                If lngCurTestTubeNo < 0 Then
                    ReDim Preserve strNewSepOrderDiv(lngNewItemCount)
                    ReDim Preserve strNewReqItemCd(lngNewItemCount)
                    strNewSepOrderDiv(lngNewItemCount) = vntAllSepOrderDiv(i)
                    strNewReqItemCd(lngNewItemCount) = vntAllReqItemCd(i)
                    lngNewItemCount = lngNewItemCount + 1
                End If
            
            Next i
            
        '送信済みデータを含む場合
        Else
        
            '全ての項目を新・要検査依頼項目とする
            For i = 0 To lngAllItemCount - 1
                ReDim Preserve strNewSepOrderDiv(lngNewItemCount)
                ReDim Preserve strNewReqItemCd(lngNewItemCount)
                strNewSepOrderDiv(lngNewItemCount) = vntAllSepOrderDiv(i)
                strNewReqItemCd(lngNewItemCount) = vntAllReqItemCd(i)
                lngNewItemCount = lngNewItemCount + 1
            Next i

        End If
    
        'ここで新・要検査依頼項目が存在しない(即ちすでに送信済み)場合はスキップ
        If lngNewItemCount = 0 Then
'            objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "I", "", "送信対象となる依頼項目が存在しません。", strMessage2
            Exit Do
        End If
    
        '同じオーダ分割区分単位に依頼処理を行う
        For i = 0 To lngNewItemCount - 1
    
            '現在の検索内容をスタック
            lngSepOrderDiv = strNewSepOrderDiv(i)
            ReDim Preserve strLastReqItemCd(lngLastItemCount)
            strLastReqItemCd(lngLastItemCount) = strNewReqItemCd(i)
            lngLastItemCount = lngLastItemCount + 1
    
            '現時点で送信を行うかをチェック
            Do
            
                Ret2 = True
                
                '現検索内容が最終情報でなく、かつ次インデックスのオーダ分割区分と値が同一な場合は送信を行わない
                If i < lngNewItemCount - 1 Then
                    If strNewSepOrderDiv(i + 1) = strNewSepOrderDiv(i) Then
                        Exit Do
                    End If
                End If
        
                '検査依頼項目のオーダ分割区分が(すでに送信済みである)検体番号管理情報に存在するかを検索
                lngCurTestTubeNo = -1
                For j = 0 To lngTestTubeCount - 1
                    If CLng(vntCurSepOrderDiv(j)) = lngSepOrderDiv Then
                        lngCurTestTubeNo = vntCurTestTubeNo(j)
                        Exit For
                    End If
                Next j
        
                '存在しない(すなわち検体番号が発番されていない)場合
                If lngCurTestTubeNo < 0 Then

                    '次に発番する検体番号の設定
                    lngTestTubeNo = IIf(lngTestTubeNo <> 0, lngTestTubeNo + 1, lngMinTestTubeNo)

                    '(運用上考えられないが)検体番号が最大値を超えた場合は処理を終了する
                    If lngTestTubeNo > lngMaxTestTubeNo Then
                        objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "E", "", "検体番号が最大値に達します。依頼できません。", ""
                        Ret2 = False
                        Exit Do
                    End If
    
                    '検体番号を更新する
                    objConsult.InsertTestTubeMng dtmCslDate, lngTestTubeNo, lngSepOrderDiv, lngRsvNo
    
                    '以後使用する検体番号の設定
                    lngUseTestTubeNo = lngTestTubeNo
                            
                '発番済みの場合はその値を使用する
                Else
                    lngUseTestTubeNo = lngCurTestTubeNo
                End If
        
                'ストリーム作成
                vntStream = CreateStream(strReqCd, dtmCslDate, lngRsvNo, lngDayId, strPerId, strName, strKanaName, lngGender, dtmBirth, lngAge, lngUseTestTubeNo, dblPatientNo, strLastReqItemCd)
        
                'ファイルの存在を確認
                If Dir(strFileName) = "" Then
                
                    '存在しなければ出力モードでファイルオープン
                    intFileNo = FreeFile()
                    Open strFileName For Output Lock Read Write As #intFileNo
                
                '存在する場合
                Else
                
                    '使用中であれば他で検査依頼処理中と認識し、処理を終了する
                    If Locked(strFileName) Then
                        objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "W", "", "検査依頼ファイルが他で使用されています。", ""
                        Ret2 = False
                        Exit Do
                    End If
                
                    '追加モードでファイルオープン
                    intFileNo = FreeFile()
                    Open strFileName For Append Lock Read Write As #intFileNo
                
                End If
        
                'ファイルに追加
                For j = 0 To UBound(vntStream)
                    Print #intFileNo, vntStream(j)
                Next j
        
                'ファイルクローズ
                Close #intFileNo
                intFileNo = 0
                
                'ログ発行
                objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "I", "", "検査依頼情報が作成されました。", "検体番号=" & lngUseTestTubeNo & "、依頼項目数=" & lngLastItemCount & "、" & strMessage2
        
'## 2003.06.03 Add 2Lines By T.Takagi@FSIT
                Erase strLastReqItemCd
                lngLastItemCount = 0
'## 2003.06.03 Add End
                Exit Do
            Loop
        
            '致命的エラー時は処理を抜ける
            If Ret2 = False Then
                Exit Do
            End If
            
        Next i
        
        Ret = True
        Exit Do
    Loop
    
    'トランザクション制御
    If Ret = True Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    '戻り値の設定
    CreateFile = Ret
    
    Exit Function
    
ErrorHandle:

    'ファイルクローズ
    If intFileNo > 0 Then
        Close #intFileNo
    End If

    'イベントログ書き込み
    WriteErrorLog "Request2.CreateFile"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 検査項目データの初期化
'
' 引数　　 : (In)     dtmCslDate     受診日
' 　　　　   (In)     lngTestTubeNo  検体番号
'
' 戻り値　 : 初期化された文字列
'
' 備考　　 :
'
Private Function CreateItemRecHeader(ByVal dtmCslDate As Date, ByVal lngTestTubeNo As Long) As String

    Dim udtItem     As ITEM_HEADER  '検査項目レコード(ヘッダ部)
    Dim udtBuffer   As BUFFER_REC   '構造体から文字列に変換するためのバッファ

    '検査項目レコードの編集
    With udtItem
        .RecDiv = "O2"
        .CslDate = Format(dtmCslDate, "yyyymmdd")
        .Seq = Right(String(Len(.Seq), "0") & lngTestTubeNo, Len(.Seq))
    End With
    
    '文字列変換
    LSet udtBuffer = udtItem
    
    '戻り値の設定
    CreateItemRecHeader = Left(udtBuffer.Buffer, Len(udtItem))
    
End Function

'
' 機能　　 : 患者番号発番
'
' 引数　　 : (In)     lngTransactionId  トランザクションＩＤ
' 　　　　   (In)     strPerId          個人ＩＤ
'
' 戻り値　 : 患者番号
'
' 備考　　 :
'
Public Function CreatePatientNo(ByVal lngTransactionId As Long, ByVal strPerId As String, ByVal strName As String) As Double

    Dim objFree         As Object       '汎用情報アクセス用
    Dim objHainsLog     As Object       'ログ情報アクセス用
    Dim objPerson       As Object       '個人情報アクセス用

    Dim vntPatientNo    As Variant      '患者番号
    
    Dim dblPatientNo    As Double       '現在の最大患者番号
    Dim dblMinPatientNo As Double       '患者番号の最小値
    Dim dblMaxPatientNo As Double       '患者番号の最大値

    Dim udtRequest      As REQUEST_REC  '被検者レコード
    Dim vntUpdPatientNo As Variant      '更新用患者番号

    Dim strMessage      As String       'メッセージ
    Dim Ret             As Double       '関数戻り値
    Dim i               As Long         'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objFree = CreateObject("HainsFree.Free")
    Set objHainsLog = CreateObject("HainsHainsLog.HainsLog")
    Set objPerson = CreateObject("HainsPerson.Person")

    Do
    
        '患者番号の発番管理情報レコードロック
        If objFree.SelectFree(0, FREECD_PATIENTNO, , , , , , , , , True) <= 0 Then
            objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "E", "", "患者番号発番管理情報の取得に失敗しました。", ""
            Exit Do
        End If
    
        '患者番号の読み込み
        objPerson.SelectPerson strPerId, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , vntPatientNo
    
        'すでに発番されている場合
        If vntPatientNo <> "" Then
        
            '整数チェック
            For i = 1 To Len(vntPatientNo)
                If InStr("0123456789", Mid(vntPatientNo, i, 1)) <= 0 Then
                    objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "E", "", "患者番号の発番体系に誤りがあります。", "患者番号=" & vntPatientNo & "、氏名=" & strName & "（" & strPerId & "）"
                    Exit Do
                End If
            Next i
            
            Ret = vntPatientNo
            Exit Do
        End If
        
        '以下は未発番の場合
        
        '現在の最大患者番号と、患者番号の発番管理情報とを取得
        strMessage = GetPatientNo(dblPatientNo, dblMinPatientNo, dblMaxPatientNo)
        If strMessage <> "" Then
            objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "E", "", strMessage, ""
            Exit Do
        End If

        '次に発番する患者番号の設定
        dblPatientNo = IIf(dblPatientNo <> 0, dblPatientNo + 1, dblMinPatientNo)
    
        '(運用上考えられないが)患者番号が最大値を超えた場合は処理を終了する
        If dblPatientNo > dblMaxPatientNo Then
            objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "E", "", "患者番号が最大値に達します。依頼できません。", ""
            Exit Do
        End If
        
        '患者番号を更新する
        vntUpdPatientNo = Right(String(Len(udtRequest.PatientNo), "0") & dblPatientNo, Len(udtRequest.PatientNo))
        objPerson.UpdatePerson strPerId, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , vntUpdPatientNo

        'ログ発行
        objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "I", "", "患者番号が発番されました。", "患者番号=" & dblPatientNo & "、氏名=" & strName & "（" & strPerId & "）"

        Ret = dblPatientNo
        Exit Do
    Loop
    
    '戻り値の設定
    CreatePatientNo = Ret
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    CreatePatientNo = -1

    'イベントログ書き込み
    WriteErrorLog "Request2.CreatePatientNo"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 送信ストリームの作成
'
' 引数　　 : (In)     strReqCd       依頼元コード
' 　　　　   (In)     dtmCslDate     受診日
' 　　　　   (In)     lngRsvNo       予約番号
' 　　　　   (In)     lngDayId       当日ＩＤ
' 　　　　   (In)     strPerId       個人ＩＤ
' 　　　　   (In)     strName        氏名
' 　　　　   (In)     strKanaName    カナ氏名
' 　　　　   (In)     lngGender      性別
' 　　　　   (In)     dtmBirth       生年月日
' 　　　　   (In)     lngAge         年齢
' 　　　　   (In)     lngTestTubeNo  検体番号
' 　　　　   (In)     dblPatientNo   患者番号
' 　　　　   (In)     strReqItemCd   検査依頼用項目コード
'
' 戻り値　 : 送信ストリームの配列
'
' 備考　　 :
'
Private Function CreateStream( _
    ByVal strReqCd As String, _
    ByVal dtmCslDate As Date, _
    ByVal lngRsvNo As Long, _
    ByVal lngDayId As Long, _
    ByVal strPerId As String, _
    ByVal strName As Variant, _
    ByVal strKanaName As String, _
    ByVal lngGender As String, _
    ByVal dtmBirth As Date, _
    ByVal lngAge As Long, _
    ByVal lngTestTubeNo As Long, _
    ByVal dblPatientNo As Double, _
    ByRef strReqItemCd() As String _
) As Variant

    Dim vntStream       As Variant      '送信ストリーム
    
    Dim udtRequest      As REQUEST_REC  '被検者レコード
    Dim udtItem         As ITEM_REC     '検査項目レコード
    Dim udtBuffer       As BUFFER_REC   '構造体から文字列に変換するためのバッファ
    
    Dim strBuffer       As String       '検査項目レコード編集用のバッファ
    Dim lngEditCount    As Long         '追加された検査項目数
    
    Dim i               As Long         'インデックス
    
    '初期処理
    CreateStream = Empty
    
    '被検者レコードの編集
    With udtRequest
        .RecDiv = "O1"
        .ReqKey.CslDate = Format(dtmCslDate, "yyyymmdd")
        .ReqKey.Seq = Right(String(Len(.ReqKey.Seq), "0") & lngTestTubeNo, Len(.ReqKey.Seq))
        .ReqCd = strReqCd
        .PatientNo = Right(String(Len(.PatientNo), "0") & dblPatientNo, Len(.PatientNo))
        .KanaName = strKanaName
        .Gender = IIf(lngGender = 1, "M", "F")
        .AgeDiv = "Y"
        .Age = Right(String(Len(.Age), "0") & lngAge, Len(.Age))
        .Birth = Format(dtmBirth, "yymmdd")
        .TakeDate = Format(dtmCslDate, "yymmdd")
        .TakeTime = String(Len(.TakeTime), "0")
        .ItemCount = Right(String(Len(.ItemCount), "0") & UBound(strReqItemCd) + 1, Len(.ItemCount))
        .Name = Left(strName & String(Len(.Name), "　"), Len(.Name))
        .TestTubeNo = Right(String(Len(.TestTubeNo), "0") & lngTestTubeNo, Len(.TestTubeNo))
    End With
        
    '送信ストリームに追加
    LSet udtBuffer = udtRequest
    AppendStream vntStream, udtBuffer
    
    '検査項目レコードの初期設定
    lngEditCount = 0
    strBuffer = CreateItemRecHeader(dtmCslDate, lngTestTubeNo)

    '要検査依頼項目の検索
    For i = 0 To UBound(strReqItemCd)
        
        '検査項目レコードの編集
        udtItem.ItemCd = strReqItemCd(i)
        
        '検査項目レコード編集用のバッファに追加
        LSet udtBuffer = udtItem
        strBuffer = strBuffer & Left(udtBuffer.Buffer, Len(udtItem))
        lngEditCount = lngEditCount + 1
    
        '追加された検査項目数が必要数に達した場合
        If lngEditCount >= ITEMCOUNT_OF_ITEM_REC Then

            '送信ストリームに追加
            udtBuffer.Buffer = strBuffer
            AppendStream vntStream, udtBuffer

            '検査項目レコードの初期設定
            lngEditCount = 0
            strBuffer = CreateItemRecHeader(dtmCslDate, lngTestTubeNo)
    
        End If
    
    Next i

    '未追加項目がバッファに残っている場合
    If lngEditCount > 0 Then
    
        '送信ストリームに追加
        udtBuffer.Buffer = strBuffer
        AppendStream vntStream, udtBuffer
    
    End If
    
    '戻り値の設定
    CreateStream = vntStream
    
End Function

'
' 機能　　 : 現在の最大患者番号と、患者番号の発番管理情報とを取得
'
' 引数　　 : (Out)    dblPatientNo     現在の最大患者番号
' 　　　　   (Out)    dblMinPatientNo  患者番号の最小値
' 　　　　   (Out)    dblMaxPatientNo  患者番号の最大値
'
' 戻り値　 : 発番管理情報の不正時にメッセージを返す
'
' 備考　　 :
'
Private Function GetPatientNo(ByRef dblPatientNo As Double, ByRef dblMinPatientNo As Double, ByRef dblMaxPatientNo As Double) As String

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objPatientNo        As OraField         '現在の最大患者番号
    Dim objMinPatientNo     As OraField         '患者番号の最小値
    Dim objMaxPatientNo     As OraField         '患者番号の最大値

    Dim dblMinPatientNo2    As Double           '患者番号の最小値
    Dim dblMaxPatientNo2    As Double           '患者番号の最大値

    Dim strMessage          As String           'メッセージ
    Dim blnError            As Boolean          'エラーフラグ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    dblPatientNo = 0
    dblMinPatientNo = 0
    dblMaxPatientNo = 0
    GetPatientNo = ""
    
    '現在の最大患者番号と汎用テーブルの発番範囲を取得
    strStmt = "SELECT ( SELECT NVL(MAX(PERSON.SPARE1), 0)            " & vbLf & _
              "           FROM PERSON                                " & vbLf & _
              "          WHERE SPARE1        >= PATIENT.MINPATIENTNO " & vbLf & _
              "            AND SPARE1        <= PATIENT.MAXPATIENTNO " & vbLf & _
              "            AND LENGTH(SPARE1) = " & LENGTH_PATIENTNO & vbLf & _
              "       ) PATIENTNO,                                   " & vbLf & _
              "       PATIENT.MINPATIENTNO,                          " & vbLf & _
              "       PATIENT.MAXPATIENTNO                           " & vbLf & _
              "  FROM ( SELECT FREEFIELD1 MINPATIENTNO,              " & vbLf & _
              "                FREEFIELD2 MAXPATIENTNO               " & vbLf & _
              "           FROM FREE                                  " & vbLf & _
              "          WHERE FREECD = '" & FREECD_PATIENTNO & "'   " & vbLf & _
              "       ) PATIENT                                      "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    Do
    
        '検索レコードが存在しない場合はメッセージを編集して終了
        If objOraDyna.EOF Then
            strMessage = "患者番号発番管理情報が汎用テーブルに存在しません。"
            Exit Do
        End If

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPatientNo = objFields("PATIENTNO")
        Set objMinPatientNo = objFields("MINPATIENTNO")
        Set objMaxPatientNo = objFields("MAXPATIENTNO")

        blnError = True
        
        Do
        
            '数値でない場合はエラー
            If Not IsNumeric(objMinPatientNo.Value) Or Not IsNumeric(objMaxPatientNo.Value) Then
                Exit Do
            End If

            '数値変換
            dblMinPatientNo2 = Int(objMinPatientNo.Value)
            dblMaxPatientNo2 = Int(objMaxPatientNo.Value)

            '負の値ならばエラー
            If dblMinPatientNo2 < 0 Or dblMaxPatientNo2 < 0 Then
                Exit Do
            End If

            '桁数が１０桁以外ならばエラー
            If Len(CStr(dblMinPatientNo2)) <> LENGTH_PATIENTNO Or Len(CStr(dblMaxPatientNo2)) <> LENGTH_PATIENTNO Then
                Exit Do
            End If

            '大小逆転時はエラー
            If dblMinPatientNo2 > dblMaxPatientNo2 Then
                Exit Do
            End If

            blnError = False
            Exit Do
        Loop

        'エラー時はメッセージを編集して終了
        If blnError Then
            strMessage = "患者番号発番管理情報の設定に誤りがあります。"
            Exit Do
        End If
        
        '戻り値の設定
        dblPatientNo = objPatientNo.Value
        dblMinPatientNo = dblMinPatientNo2
        dblMaxPatientNo = dblMaxPatientNo2

        Exit Do
    Loop

    '戻り値の設定
    GetPatientNo = strMessage
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Request2.GetPatientNo"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 指定日における現在の最大検体番号と、検体番号の発番管理情報とを取得
'
' 引数　　 : (In)     dtmCslDate        受診日
' 　　　　   (Out)    lngTestTubeNo     現在の最大検体番号
' 　　　　   (Out)    lngMinTestTubeNo  検体番号の最小値
' 　　　　   (Out)    lngMaxTestTubeNo  検体番号の最大値
'
' 戻り値　 : 発番管理情報の不正時にメッセージを返す
'
' 備考　　 :
'
Private Function GetTestTubeNo(ByVal dtmCslDate As Date, ByRef lngTestTubeNo As Long, ByRef lngMinTestTubeNo As Long, ByRef lngMaxTestTubeNo As Long) As String

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objTestTubeNo       As OraField         '現在の最大検体番号
    Dim objMinTestTubeNo    As OraField         '検体番号の最小値
    Dim objMaxTestTubeNo    As OraField         '検体番号の最大値

    Dim lngMinTestTubeNo2   As Long             '検体番号の最小値
    Dim lngMaxTestTubeNo2   As Long             '検体番号の最大値

    Dim strMessage          As String           'メッセージ
    Dim blnError            As Boolean          'エラーフラグ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    lngTestTubeNo = 0
    lngMinTestTubeNo = 0
    lngMaxTestTubeNo = 0
    GetTestTubeNo = ""
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "FREECD", FREECD_TESTTUBENO, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '現在の最大検体番号と汎用テーブルの発番範囲を取得
    strStmt = "SELECT ( SELECT NVL(MAX(TESTTUBENO), 0) " & vbLf & _
              "           FROM TESTTUBEMNG        " & vbLf & _
              "          WHERE CSLDATE = :CSLDATE " & vbLf & _
              "       ) TESTTUBENO,             " & vbLf & _
              "       FREEFIELD1 MINTESTTUBENO, " & vbLf & _
              "       FREEFIELD2 MAXTESTTUBENO  " & vbLf & _
              "  FROM FREE             " & vbLf & _
              " WHERE FREECD = :FREECD "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    Do
    
        '検索レコードが存在しない場合はメッセージを編集して終了
        If objOraDyna.EOF Then
            strMessage = "検体番号発番管理情報が汎用テーブルに存在しません。"
            Exit Do
        End If

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objTestTubeNo = objFields("TESTTUBENO")
        Set objMinTestTubeNo = objFields("MINTESTTUBENO")
        Set objMaxTestTubeNo = objFields("MAXTESTTUBENO")

        blnError = True
        
        Do
        
            '数値でない場合はエラー
            If Not IsNumeric(objMinTestTubeNo.Value) Or Not IsNumeric(objMaxTestTubeNo.Value) Then
                Exit Do
            End If

            '数値変換
            lngMinTestTubeNo2 = Int(objMinTestTubeNo.Value)
            lngMaxTestTubeNo2 = Int(objMaxTestTubeNo.Value)

            '１～９９９９の値をとらない場合はエラー
            If lngMinTestTubeNo2 < 1 Or lngMinTestTubeNo2 > 9999 Or lngMaxTestTubeNo2 < 1 Or lngMaxTestTubeNo2 > 9999 Then
                Exit Do
            End If

            '大小逆転時はエラー
            If lngMinTestTubeNo2 > lngMaxTestTubeNo2 Then
                Exit Do
            End If

            blnError = False
            Exit Do
        Loop

        'エラー時はメッセージを編集して終了
        If blnError Then
            strMessage = "検体番号発番管理情報の設定に誤りがあります。"
            Exit Do
        End If
        
        '戻り値の設定
        lngTestTubeNo = objTestTubeNo.Value
        lngMinTestTubeNo = lngMinTestTubeNo2
        lngMaxTestTubeNo = lngMaxTestTubeNo2

        Exit Do
    Loop

    '戻り値の設定
    GetTestTubeNo = strMessage
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Request2.GetTestTubeNo"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 検査依頼ファイル(と認識されるすべてのファイル)が使用中であるかを判定
'
' 引数　　 : (In)     strFilePath  検査依頼ファイル格納パス
' 　　　　   (In)     strFileName  検査依頼ファイル名
'
' 戻り値　 : True   使用中である
' 　　　　   False  使用されていない
'
' 備考　　 :
'
Private Function IsLocked(ByVal strFilePath As String, ByVal strFileName As String) As Boolean

    Dim strFileName1    As String   'ファイル名(ファイル部)
    Dim strFileName2    As String   'ファイル名(拡張子)
    Dim lngPos          As Long     '検索位置
    Dim strFoundFile    As String   '検索されたファイル名
    Dim Ret             As Boolean  '関数戻り値
    
    'ファイル名に最後に存在するビリオドにて、ファイル名と拡張子に分割する
    lngPos = InStrRev(strFileName, ".")
    If lngPos > 0 Then
        strFileName1 = Left(strFileName, lngPos - 1)
        strFileName2 = Right(strFileName, Len(strFileName) - (lngPos - 1))
    Else
        strFileName1 = strFileName
        strFileName2 = ""
    End If

    '指定パスに存在する指定形式のファイルを検索
    strFoundFile = Dir(strFilePath & strFileName1 & "*" & strFileName2)
    
    'すべてのファイルを検索
    Do Until strFoundFile = ""
    
        '検索したファイルが使用中かを判定
        If Locked(strFilePath & strFoundFile) Then
            Ret = True
            Exit Do
        End If
            
        '次のファイルを検索
        strFoundFile = Dir()
    
    Loop

    '戻り値の設定
    IsLocked = Ret
    
End Function

'
' 機能　　 : 指定受診情報の要検査依頼項目を取得する
'
' 引数　　 : (In)     lngRsvNo        予約番号
' 　　　　   (Out)    vntSepOrderDiv  オーダ分割区分
' 　　　　   (Out)    vntReqItemCd    検査依頼用項目コード
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Private Function SelectReqItemFromRsl(ByVal lngRsvNo As Long, ByRef vntSepOrderDiv As Variant, ByRef vntReqItemCd As Variant) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objSepOrderDiv      As OraField         'オーダ分割区分
    Dim objReqItemCd        As OraField         '検査依頼用項目コード
    
    Dim vntArrSepOrderDiv() As Variant          'オーダ分割区分
    Dim vntArrReqItemCd()   As Variant          '検査依頼用項目コード
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntSepOrderDiv = Empty
    vntReqItemCd = Empty
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '指定受診情報の要検査依頼項目を取得する
    strStmt = "SELECT DISTINCT                             " & vbLf & _
              "       ITEM_H.SEPORDERDIV, ITEM_H.REQITEMCD " & vbLf & _
              "  FROM ITEM_H, RSL, CONSULT                 " & vbLf & _
              " WHERE CONSULT.RSVNO     = :RSVNO           " & vbLf & _
              "   AND CONSULT.RSVNO     = RSL.RSVNO        " & vbLf & _
              "   AND RSL.ITEMCD        = ITEM_H.ITEMCD    " & vbLf & _
              "   AND RSL.SUFFIX        = ITEM_H.SUFFIX    " & vbLf & _
              "   AND ITEM_H.STRDATE   <= CONSULT.CSLDATE  " & vbLf & _
              "   AND ITEM_H.ENDDATE   >= CONSULT.CSLDATE  " & vbLf & _
              "   AND ITEM_H.REQITEMCD   IS NOT NULL       " & vbLf & _
              "   AND ITEM_H.SEPORDERDIV IS NOT NULL       "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objSepOrderDiv = objFields("SEPORDERDIV")
        Set objReqItemCd = objFields("REQITEMCD")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrSepOrderDiv(lngCount)
            ReDim Preserve vntArrReqItemCd(lngCount)
            vntArrSepOrderDiv(lngCount) = objSepOrderDiv.Value
            vntArrReqItemCd(lngCount) = objReqItemCd.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        '戻り値の設定
        vntReqItemCd = vntArrReqItemCd
        vntSepOrderDiv = vntArrSepOrderDiv
    
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectReqItemFromRsl = lngCount
    
    Exit Function
    
ErrorHandle:

    SelectReqItemFromRsl = -1

    'イベントログ書き込み
    WriteErrorLog "Request2.SelectReqItemFromRsl"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : Activateイベント
'
' 備考　　 : COMオブジェクトがアクティブ化された時点でデータベースへの接続を行う
'
Private Sub ObjectControl_Activate()

    Dim objCommon   As Common   '共通クラス
    
    'オブジェクトコンテキストを取得
    Set mobjContext = GetObjectContext()
    
    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")
    
    'データベース接続
    Set mobjOraSession = CreateObject("OracleInProcServer.XOraSession")
    Set mobjOraDb = mobjOraSession.OpenDatabase(objCommon.ConnectString, objCommon.UserName & "/" & objCommon.Password, ORADB_ENLIST_IN_MTS)
    
End Sub

Private Function ObjectControl_CanBePooled() As Boolean

End Function

'
' 機能　　 : DeaActivateイベント
'
' 備考　　 : COMオブジェクトが非アクティブ化された時点でデータベースからの切断を行う
'
Private Sub ObjectControl_Deactivate()

    'データベース切断
    Set mobjOraSession = Nothing
    Set mobjOraDb = Nothing

End Sub
