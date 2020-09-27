VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Response"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

Private Const TRANSACTIONDIV_RESPONSE   As String = "LOGRESISP"     '検査取り込み用のログ処理ＩＤ
Private Const FREECD_RESFILE            As String = "RESFILE"       '検査結果ファイル情報

Private Type NETRESOURCE
    dwScope As Long
    dwType As Long
    dwDisplayType As Long
    dwUsage As Long
    lpLocalName As String
    lpRemoteName As String
    lpComment As String
    lpProvider As String
End Type

Private Const CONNECT_UPDATE_PROFILE = &H1
Private Const RESOURCETYPE_DISK = &H1

Private Declare Function WNetAddConnection2 _
     Lib "mpr.dll" _
    Alias "WNetAddConnection2A" _
    (lpNetResource As NETRESOURCE, _
     ByVal lpPassword As String, _
     ByVal lpUserName As String, _
     ByVal dwFlags As Long) As Long

'
' 機能　　 : 応答ストリーム内容のチェック
'
' 引数　　 : (In)     udtResponse     検査結果レコード
' 　　　　   (Out)    dtmCslDate      受診日
' 　　　　   (Out)    lngTestTubeNo   検体番号
' 　　　　   (Out)    strSepOrderDiv  オーダ分割区分
' 　　　　   (Out)    lngRsvNo        予約番号
' 　　　　   (Out)    vntMessage1     メッセージ１
' 　　　　   (Out)    vntMessage2     メッセージ２
'
' 戻り値　 :
'
' 備考　　 :
'
'## 2003.02.12 Mod 17Lines By T.Takagi@FSIT オーダ分割区分対応
'Private Sub CheckResponseStream(
'    ByRef udtResponse As RESPONSE_REC,
'    ByRef dtmCslDate As Date,
'    ByRef lngTestTubeNo As Long,
'    ByRef lngRsvNo As Long,
'    ByRef vntMessage1 As Variant,
'    ByRef vntMessage2 As Variant
')
Private Sub CheckResponseStream( _
    ByRef udtResponse As RESPONSE_REC, _
    ByRef dtmCslDate As Date, _
    ByRef lngTestTubeNo As Long, _
    ByRef strSepOrderDiv As String, _
    ByRef lngRsvNo As Long, _
    ByRef vntMessage1 As Variant, _
    ByRef vntMessage2 As Variant _
)
'## 2003.02.12 Mod End

    Dim strCslDate          As String   '受診日
    Dim strSeq              As String   '健診通番
    
    Dim dtmCslDate2         As Date     '受診日
    Dim lngTestTubeNo2      As Long     '検体番号
    Dim lngRsvNo2           As Long     '予約番号
    
    Dim vntArrMessage1()    As Variant  'メッセージ１
    Dim vntArrMessage2()    As Variant  'メッセージ２
    Dim lngCount            As Long     'メッセージ数
    
    Dim strMessage          As String   'メッセージ
    Dim blnError            As Boolean  'エラーフラグ
    Dim i                   As Long     'インデックス
    
    '初期処理
    dtmCslDate = 0
    lngTestTubeNo = 0
'## 2003.02.12 Add 1Line By T.Takagi@FSIT オーダ分割区分対応
    strSepOrderDiv = ""
'## 2003.02.12 Add End
    lngRsvNo = 0
    vntMessage1 = Empty
    vntMessage2 = Empty

    Do
    
        '受診日のチェック
        Do
    
            '必須チェック
            If Trim(udtResponse.ReqKey.CslDate) = "" Then
                ReDim Preserve vntArrMessage1(lngCount)
                ReDim Preserve vntArrMessage2(lngCount)
                vntArrMessage1(lngCount) = "受診日が存在しません。"
                vntArrMessage2(lngCount) = ""
                lngCount = lngCount + 1
                blnError = True
                Exit Do
            End If
            
            strCslDate = Format(udtResponse.ReqKey.CslDate, "!@@@@/@@/@@")
            
            '日付チェック
            If Not IsDate(strCslDate) Then
                ReDim Preserve vntArrMessage1(lngCount)
                ReDim Preserve vntArrMessage2(lngCount)
                vntArrMessage1(lngCount) = "受診日の形式に誤りがあります。"
                vntArrMessage2(lngCount) = "受診日=" & udtResponse.ReqKey.CslDate
                lngCount = lngCount + 1
                blnError = True
                Exit Do
            End If
            
            dtmCslDate2 = strCslDate
            Exit Do
        Loop

        'SEQ(検体番号)のチェック
        Do
    
            '必須チェック
            If Trim(udtResponse.ReqKey.Seq) = "" Then
                ReDim Preserve vntArrMessage1(lngCount)
                ReDim Preserve vntArrMessage2(lngCount)
                vntArrMessage1(lngCount) = "健診通番が存在しません。"
                vntArrMessage2(lngCount) = ""
                lngCount = lngCount + 1
                blnError = True
                Exit Do
            End If
            
            strSeq = Trim(Right(udtResponse.ReqKey.Seq, 4))
            
            '数値チェック１
            If Not IsNumeric(strSeq) Then
                ReDim Preserve vntArrMessage1(lngCount)
                ReDim Preserve vntArrMessage2(lngCount)
                vntArrMessage1(lngCount) = "健診通番の形式に誤りがあります。"
                vntArrMessage2(lngCount) = "健診通番=" & udtResponse.ReqKey.Seq
                lngCount = lngCount + 1
                blnError = True
                Exit Do
            End If
            
            '数値チェック２
            For i = 1 To Len(strSeq)
                Select Case Mid(strSeq, i, 1)
                    Case "0" To "9"
                    Case Else
                        ReDim Preserve vntArrMessage1(lngCount)
                        ReDim Preserve vntArrMessage2(lngCount)
                        vntArrMessage1(lngCount) = "健診通番の形式に誤りがあります。"
                        vntArrMessage2(lngCount) = "健診通番=" & udtResponse.ReqKey.Seq
                        lngCount = lngCount + 1
                        blnError = True
                        Exit Do
                End Select
            Next i
            
            lngTestTubeNo2 = strSeq
            Exit Do
        Loop

        'ここまででエラーがある場合は処理を終了する
        If blnError Then
            Exit Do
        End If
    
        'メッセージ２の基本部を編集
        strMessage = "受診日=" & Format(dtmCslDate2, "yyyy/m/d")
        strMessage = strMessage & "、検体番号=" & lngTestTubeNo2
    
        '受診情報の存在をチェックし、存在する場合は予約番号を取得
'## 2003.02.12 Mod 2Lines By T.Takagi@FSIT オーダ分割区分対応
'        lngRsvNo2 = SelectTestTubeMng(dtmCslDate2, lngTestTubeNo2)
        lngRsvNo2 = SelectTestTubeMng(dtmCslDate2, lngTestTubeNo2, strSepOrderDiv)
'## 2003.02.12 Mod End
        If lngRsvNo2 <= 0 Then
            ReDim Preserve vntArrMessage1(lngCount)
            ReDim Preserve vntArrMessage2(lngCount)
            vntArrMessage1(lngCount) = "受診情報が存在しません。"
            vntArrMessage2(lngCount) = strMessage
            lngCount = lngCount + 1
            blnError = True
        End If

        '戻り値の設定
        dtmCslDate = dtmCslDate2
        lngTestTubeNo = lngTestTubeNo2
        lngRsvNo = lngRsvNo2
        
        Exit Do
    Loop
    
    '戻り値の設定
    If lngCount > 0 Then
        vntMessage1 = vntArrMessage1
        vntMessage2 = vntArrMessage2
    End If
    
End Sub

'
' 機能　　 : 応答ストリームから検査結果レコード構造体への変換
'
' 引数　　 : (In)     strStream      応答ストリーム
'
' 戻り値　 : 検査結果レコード構造体
'
' 備考　　 :
'
Private Function ConvertStreamToResponse(ByVal strStream As String) As RESPONSE_REC

    Dim udtResponse As RESPONSE_REC '検査結果レコード
    Dim lngPtr      As Long         '文字列検索ポインタ
    Dim i           As Long         'インデックス
    
    '検索のためにUnicodeから変換
    strStream = StrConv(strStream, vbFromUnicode)
    
    '変換文字列を検索し、値設定時にUnicode変換
    With udtResponse
        
        lngPtr = 1
        .RecDiv = StrConv(MidB(strStream, lngPtr, Len(.RecDiv)), vbUnicode)
        lngPtr = lngPtr + Len(.RecDiv)
        .CenterDiv = StrConv(MidB(strStream, lngPtr, Len(.CenterDiv)), vbUnicode)
        lngPtr = lngPtr + Len(.CenterDiv)
        
        With .ReqKey
            .CslDate = StrConv(MidB(strStream, lngPtr, Len(.CslDate)), vbUnicode)
            lngPtr = lngPtr + Len(.CslDate)
            .Seq = StrConv(MidB(strStream, lngPtr, Len(.Seq)), vbUnicode)
            lngPtr = lngPtr + Len(.Seq)
            .Space1 = StrConv(MidB(strStream, lngPtr, Len(.Space1)), vbUnicode)
            lngPtr = lngPtr + Len(.Space1)
        End With
        
        With .CslKey
            .CslDate = StrConv(MidB(strStream, lngPtr, Len(.CslDate)), vbUnicode)
            lngPtr = lngPtr + Len(.CslDate)
            .Seq = StrConv(MidB(strStream, lngPtr, Len(.Seq)), vbUnicode)
            lngPtr = lngPtr + Len(.Seq)
            .Space1 = StrConv(MidB(strStream, lngPtr, Len(.Space1)), vbUnicode)
            lngPtr = lngPtr + Len(.Space1)
        End With
        
        .KanaName = StrConv(MidB(strStream, lngPtr, Len(.KanaName)), vbUnicode)
        lngPtr = lngPtr + Len(.KanaName)
        .RepCd = StrConv(MidB(strStream, lngPtr, Len(.RepCd)), vbUnicode)
        lngPtr = lngPtr + Len(.RepCd)
        .Nyubi = StrConv(MidB(strStream, lngPtr, Len(.Nyubi)), vbUnicode)
        lngPtr = lngPtr + Len(.Nyubi)
        .Yoketsu = StrConv(MidB(strStream, lngPtr, Len(.Yoketsu)), vbUnicode)
        lngPtr = lngPtr + Len(.Yoketsu)
        .Bil = StrConv(MidB(strStream, lngPtr, Len(.Bil)), vbUnicode)
        lngPtr = lngPtr + Len(.Bil)
        
        For i = 0 To 4
            With .Results(i)
                .ItemCd = StrConv(MidB(strStream, lngPtr, Len(.ItemCd)), vbUnicode)
                lngPtr = lngPtr + Len(.ItemCd)
                .DisCd = StrConv(MidB(strStream, lngPtr, Len(.DisCd)), vbUnicode)
                lngPtr = lngPtr + Len(.DisCd)
                .MtrCd = StrConv(MidB(strStream, lngPtr, Len(.MtrCd)), vbUnicode)
                lngPtr = lngPtr + Len(.MtrCd)
                .MesCd = StrConv(MidB(strStream, lngPtr, Len(.MesCd)), vbUnicode)
                lngPtr = lngPtr + Len(.MesCd)
                .Suffix = StrConv(MidB(strStream, lngPtr, Len(.Suffix)), vbUnicode)
                lngPtr = lngPtr + Len(.Suffix)
                .Result = StrConv(MidB(strStream, lngPtr, Len(.Result)), vbUnicode)
                lngPtr = lngPtr + Len(.Result)
                .State = StrConv(MidB(strStream, lngPtr, Len(.State)), vbUnicode)
                lngPtr = lngPtr + Len(.State)
                .RslCmtCd1 = StrConv(MidB(strStream, lngPtr, Len(.RslCmtCd1)), vbUnicode)
                lngPtr = lngPtr + Len(.RslCmtCd1)
                .RslCmtCd2 = StrConv(MidB(strStream, lngPtr, Len(.RslCmtCd2)), vbUnicode)
                lngPtr = lngPtr + Len(.RslCmtCd2)
            End With
        Next i
        
        .PatientNo = StrConv(MidB(strStream, lngPtr, Len(.PatientNo)), vbUnicode)
        lngPtr = lngPtr + Len(.PatientNo)
        .CsDiv = StrConv(MidB(strStream, lngPtr, Len(.CsDiv)), vbUnicode)
        lngPtr = lngPtr + Len(.CsDiv)
        .Space1 = StrConv(MidB(strStream, lngPtr, Len(.Space1)), vbUnicode)
    
    End With

    '戻り値の設定
    ConvertStreamToResponse = udtResponse
    
End Function

Public Function CopyFromSharedFolder()

    Dim objFso              As Object       'ファイルシステムオブジェクト
    Dim objCreateCsv        As Object       'CSVファイル情報アクセス用
    Dim objFree             As Object       '汎用情報アクセス用

    Dim udtNETRESOURCE As NETRESOURCE
    
    Dim vntFileName         As Variant      '検査結果ファイル名
    Dim vntServerName       As Variant      'サーバ名
    Dim vntFolderName       As Variant      '共有フォルダ名
    Dim vntUserName         As Variant      'ユーザ名
    Dim vntPassword         As Variant      'パスワード
    Dim vntSharedFileName   As Variant      '共有ファイル名
    
    Dim strSharedFolder     As String
    Dim strSharedFile       As String
    
    Dim strBackUpFileName   As String
    Dim lngPos              As Long
    
    Dim Ret                 As Long
    Dim Ret2                As Boolean
    Dim Ret3                As Long
    
    'オブジェクトのインスタンス作成
    Set objFso = CreateObject("Scripting.FileSystemObject")
    Set objCreateCsv = CreateObject("HainsCreateCsv.CreateCsv")
    Set objFree = CreateObject("HainsFree.Free")
    
    Do
        
        '汎用テーブルから検査結果ファイル情報を取得
        Ret2 = objFree.SelectFree(0, FREECD_RESFILE, , , , vntFileName, vntServerName, vntFolderName, vntUserName, vntPassword, , , vntSharedFileName)
        If Ret2 = False Or vntFileName = "" Or vntServerName = "" Or vntFolderName = "" Or vntSharedFileName = "" Then
            Ret = -1
            Exit Do
        End If
    
        '使用中であれば他で検査結果取り込み中と認識し、処理を終了する
        If objFso.FileExists(vntFileName) = True Then
            If Locked(vntFileName) Then
                Ret = -2
                Exit Do
            End If
        End If
    
        '共有フォルダ名の設定
        strSharedFolder = "\\" & vntServerName & "\" & vntFolderName
        
        With udtNETRESOURCE
            .dwType = RESOURCETYPE_DISK
            .lpLocalName = vbNullString
            .lpRemoteName = strSharedFolder & vbNullChar
            .lpProvider = vbNullString
        End With
    
        Ret2 = WNetAddConnection2(udtNETRESOURCE, vntPassword, vntUserName, CONNECT_UPDATE_PROFILE)
        If Ret2 <> 0 Then
            Ret = -3
            Exit Do
        End If
        
        '共有ファイル名の設定
        strSharedFile = strSharedFolder & "\" & vntSharedFileName
        
        'ファイルが存在しない場合は処理を終了する
        If objFso.FileExists(strSharedFile) = False Then
            Ret = -4
            Exit Do
        End If
        
        If Locked(strSharedFile) Then
            Ret = -5
            Exit Do
        End If
        
        'バックアップファイル名の設定
        lngPos = InStrRev(vntFileName, ".")
        If lngPos <= 0 Then
            strBackUpFileName = vntFileName & ".bak"
        Else
            strBackUpFileName = Left(vntFileName, lngPos) & "bak"
        End If
        
        '重複しないバックアップファイル名を作成
        strBackUpFileName = objCreateCsv.GetNewFile(strBackUpFileName)
        
        'ファイル名の変名
        If objFso.FileExists(vntFileName) = True Then
            Name vntFileName As strBackUpFileName
        End If
        
        On Error GoTo ErrorHandle
        
        'ファイルのコピー
        FileCopy strSharedFile, vntFileName
    
        Kill strSharedFile
    
        Ret = 0
        Exit Do
    Loop

ErrorExit:

    CopyFromSharedFolder = Ret
    
    Exit Function
    
ErrorHandle:

    Ret = -6
    
    Resume ErrorExit
    
End Function

'
' 機能　　 : 結果チェックエラーコードに対応するエラーメッセージの編集
'
' 引数　　 : (In)    strResultErr  エラーコード
'
' 戻り値　 : エラーメッセージ
'
' 備考　　 :
'
Private Function GetErrorMessage(ByVal strResultErr As String) As String

    Dim strMessage  As String   'メッセージ

    If Trim(strResultErr) = "" Then
        Exit Function
    End If

    '各エラーコードごとのメッセージ設定
    Select Case strResultErr
        Case "E01"
            strMessage = "数値結果に不正な文字が含まれます。"
        Case "E02"
            strMessage = "数値結果の桁数が正しくありません。"
        Case "E03"
            strMessage = "数値結果は８桁以内である必要があります。"
        Case "E04"
            strMessage = "数値結果の登録可能範囲外の値です。"
        Case "E05"
            strMessage = "数値結果が格納できません。"
        Case "E06"
            strMessage = "検査結果が変換できません。"
        Case "E11"
            strMessage = "定性（標準）の結果が正しくありません。"
        Case "E21"
            strMessage = "定性（拡張）の結果が正しくありません。"
        Case "E41"
            strMessage = "文章テーブルに存在しない文章コードです。"
        Case "E42"
            strMessage = "文章コードが複数存在します。"
        Case "E6", "E61", "E62", "E63", "E64", "E65"
            strMessage = "日付結果が正しくありません。"
        Case Else
            strMessage = "その他のエラー（" & strResultErr & "）が発生しました。"
    End Select

    '戻り値の設定
    GetErrorMessage = strMessage

End Function

'
' 機能　　 : 検査結果ファイルの取り込み
'
' 引数　　 :
'
' 戻り値　 : 更新レコード数
'
' 備考　　 :
'
Public Function ImportFile() As Long

    Dim objFso              As Object       'ファイルシステムオブジェクト
    Dim objFree             As Object       '汎用情報アクセス用
    Dim objHainsLog         As Object       'ログ情報アクセス用

    Dim lngTransactionId    As Long         'トランザクションＩＤ

    Dim vntFileName         As Variant      '検査結果ファイル名
    Dim intFileNo           As Integer      'ファイル番号

    Dim strStream           As String       '受診ストリーム
    Dim lngLineNo           As Long         '行番号
    
    Dim udtResponse         As RESPONSE_REC '検査結果レコード
    
    Dim strKeyCslDate       As String       '受診日
    Dim strKeySeq           As String       '健診通番
    Dim blnSameKey          As Boolean      '直前のレコードとキーが同一か
    Dim blnKeyError         As Boolean      'キー値がエラーか
    
    Dim dtmCslDate          As Date         '受診日
    Dim lngTestTubeNo       As Long         '検体番号
'## 2003.02.12 Add 1Line By T.Takagi@FSIT オーダ分割区分対応
    Dim strSepOrderDiv      As String       'オーダ分割区分
'## 2003.02.12 Add End
    Dim lngRsvNo            As Long         '予約番号
    
    Dim vntInsItemCd()      As Variant      '検査用変換項目コード
    Dim vntInsResult()      As Variant      '検査用検査結果
    Dim vntInsRslCmtCd1()   As Variant      '検査用結果コメントコード１
    Dim vntInsRslCmtCd2()   As Variant      '検査用結果コメントコード２
    Dim lngCount            As Long         '検査用検査項目数
    
    Dim lngUpdCount         As Long         '更新された受診情報数
    
    Dim vntMessage1         As Variant      'メッセージ１
    Dim vntMessage2         As Variant      'メッセージ２
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
    Dim vntInfoDiv          As Variant      '情報種別
'## 2003.03.03 Add End
    Dim strMessage          As String       'メッセージ
    Dim strMessage2         As String       'メッセージ
    Dim Ret                 As Boolean      '関数戻り値
    Dim Ret2                As Long         '関数戻り値
    Dim i                   As Long         'インデックス
    
'## 2003.03.02 Add 1Line By T.Takagi@FSIT
    Dim Ret3                As Long         '関数戻り値
'## 2003.03.02 Add End
    
'## 2003.03.07 Add 1Line By T.Takagi@FSIT エラーと警告のカウント
    Dim strInfoDiv          As String       '情報区分
'## 2003.03.07 Add End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objFso = CreateObject("Scripting.FileSystemObject")
    Set objFree = CreateObject("HainsFree.Free")
    Set objHainsLog = CreateObject("HainsHainsLog.HainsLog")

    'トランザクションＩＤ・区分の取得
    lngTransactionId = objHainsLog.IncreaseTransactionId()
    
    '開始ログの発行
    PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, "I", "", "検査結果ファイルの取り込み処理を開始します。", ""

    Do
    
'## 2003.03.02 Add 22Lines By T.Takagi@FSIT
        '共有フォルダからのファイルコピー
        Ret3 = CopyFromSharedFolder()
        
        '戻り値ごとの処理分岐
        Select Case Ret3
            Case 0
            Case -1
                PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, "E", "", "汎用テーブルにおける検査結果取り込み情報の設定に誤りがあります。", ""
                Exit Do
            Case -2
                PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, "E", "", "検査結果ファイルが他で使用されています。", ""
                Exit Do
            Case -3
                PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, "W", "", "共有フォルダの接続に失敗しました。", ""
            Case -4
                PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, "W", "", "検査システム上の検査結果取り込みファイルは存在しません。", ""
            Case -5
                PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, "W", "", "検査システム上の検査結果取り込みファイルは他で使用されています。", ""
            Case Else
                PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, "E", "", "コピー処理においてエラーが発生しました。", ""
                Exit Do
        End Select
'## 2003.03.02 Add End
        
        '汎用テーブルから検査結果ファイル情報を取得
        Ret = objFree.SelectFree(0, FREECD_RESFILE, , , , vntFileName)
        If Ret = False Or vntFileName = "" Then
            PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, "E", "", "検査結果ファイル情報が汎用テーブルに存在しません。", ""
            Exit Do
        End If
        
        'ファイルが存在しない場合は処理を終了する
        If objFso.FileExists(vntFileName) = False Then
            PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, "E", "", "検査結果ファイルが存在しません。", "ファイル名=" & vntFileName
            Exit Do
        End If

        '検査結果ファイルが使用中であれば他で検査結果処理中と認識し、処理を終了する
        If Locked(vntFileName) Then
            PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, "E", "", "検査結果ファイルが他で使用されています。", ""
            Exit Do
        End If

        'ファイルオープン
        intFileNo = FreeFile()
        Open vntFileName For Input Lock Read Write As #intFileNo
        
        'ファイル読み込み
        Do Until EOF(intFileNo)
   
            Do
                
                '１行読み込み
                Line Input #intFileNo, strStream
                
                '行番号のインクリメント
                lngLineNo = lngLineNo + 1
                
                '空白行はスキップ
                If Trim(strStream) = "" Then
                    Exit Do
                End If

                '文字列から構造体への変換
                udtResponse = ConvertStreamToResponse(strStream)

                Do
                
                    blnSameKey = False
                
                    '直前レコードのキー情報が存在しない場合はスキップ
                    If strKeyCslDate = "" Then
                        Exit Do
                    End If
                
                    '直前レコードとキー項目が等しい場合はスキップ
                    If Trim(udtResponse.ReqKey.CslDate) = strKeyCslDate And Trim(udtResponse.ReqKey.Seq) = strKeySeq Then
                        blnSameKey = True
                        Exit Do
                    End If
                
                    'スタック情報存在時
                    If lngCount > 0 Then
                        
                        'スタックされた検査結果の更新
'## 2003.02.12 Mod 2Lines By T.Takagi@FSIT オーダ分割区分対応
'                        Ret2 = UpdateResult(lngRsvNo, vntInsItemCd, vntInsResult, vntInsRslCmtCd1, vntInsRslCmtCd2, vntMessage1, vntMessage2)
'## 2003.03.03 Mod 2Lines By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
'                        Ret2 = UpdateResult(lngRsvNo, strSepOrderDiv, vntInsItemCd, vntInsResult, vntInsRslCmtCd1, vntInsRslCmtCd2, vntMessage1, vntMessage2)
                        Ret2 = UpdateResult(lngRsvNo, strSepOrderDiv, vntInsItemCd, vntInsResult, vntInsRslCmtCd1, vntInsRslCmtCd2, vntMessage1, vntMessage2, vntInfoDiv)
'## 2003.03.03 Mod End
'## 2003.02.12 Mod End
                    
                        'ログ発行
'## 2003.03.07 Mod 26Lines By T.Takagi@FSIT エラーと警告のカウント
'                        strMessage = "検査結果が更新されました" & IIf(Not IsEmpty(vntMessage1), "が以下のエラーがあります", "") & "。"
                        Do
                        
                            If IsEmpty(vntMessage1) Then
                                strMessage = "検査結果が更新されました。"
                                strInfoDiv = "I"
                                Exit Do
                            End If
                            
                            '情報区分を検索
                            For i = 0 To UBound(vntMessage1)
                                
                                '詳細にエラーが１個でもあればエラー
                                If vntInfoDiv(i) = "E" Then
                                    strMessage = "検査結果が更新されましたが以下のエラーがあります。"
                                    strInfoDiv = "E"
                                    Exit Do
                                End If
                                
                            Next i
                            
                            'エラーがなかったなら(警告レベルなら）正常とする
                            strMessage = "検査結果が更新されましたが以下の警告があります。"
                            strInfoDiv = "I"
                            Exit Do
                        Loop
'## 2003.03.07 Mod End
                        strMessage2 = "受診日=" & Format(dtmCslDate, "yyyy/m/d")
                        strMessage2 = strMessage2 & "、検体番号=" & lngTestTubeNo
                        strMessage2 = strMessage2 & "、予約番号=" & lngRsvNo
                        strMessage2 = strMessage2 & "、更新項目数=" & Ret2
'## 2003.03.07 Mod 2Lines By T.Takagi@FSIT エラーと警告のカウント
'                        PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, "I", "", strMessage, strMessage2
                        PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, strInfoDiv, "", strMessage, strMessage2
'## 2003.03.07 Mod End
                
                        If Not IsEmpty(vntMessage1) Then
'## 2003.03.03 Mod 4Lines By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
'                            PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, "E", "", vntMessage1, vntMessage2
                            For i = 0 To UBound(vntMessage1)
                                PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, vntInfoDiv(i), "", vntMessage1(i), vntMessage2(i)
                            Next i
'## 2003.03.03 Mod End
                        End If
                
                        '受診情報数をインクリメント
                        lngUpdCount = lngUpdCount + 1
                    
                        'スタックのクリア
                        Erase vntInsItemCd
                        Erase vntInsResult
                        Erase vntInsRslCmtCd1
                        Erase vntInsRslCmtCd2
                        lngCount = 0
                    
                    End If
                    
                    Exit Do
                Loop
                
                'キー項目の退避
                strKeyCslDate = Trim(udtResponse.ReqKey.CslDate)
                strKeySeq = Trim(udtResponse.ReqKey.Seq)
                
                '直前レコードとキーが異なる場合、またはキーは等しいがそのキー自体がエラーの場合
                If (Not blnSameKey) Or (blnSameKey And blnKeyError) Then
                    
                    'レコードのチェックを行う
'## 2003.02.12 Mod 2Lines By T.Takagi@FSIT オーダ分割区分対応
'                    CheckResponseStream udtResponse, dtmCslDate, lngTestTubeNo, lngRsvNo, vntMessage1, vntMessage2
                    CheckResponseStream udtResponse, dtmCslDate, lngTestTubeNo, strSepOrderDiv, lngRsvNo, vntMessage1, vntMessage2
'## 2003.02.12 Mod End
                    
                    If Not IsEmpty(vntMessage1) Then
                        PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, "W", lngLineNo, vntMessage1, vntMessage2
                        blnKeyError = True
                        Exit Do
                    End If
                
                    blnKeyError = False
                End If
                
                '検査結果のスタック
                For i = 0 To UBound(udtResponse.Results)
        
                    With udtResponse.Results(i)
        
                        Do
                        
                            '検査項目コードが存在しなければ追加しない
                            If Trim(.ItemCd) = "" Then
                                Exit Do
                            End If
                        
                            'コメントなしの"!!!!!!!!"は無視
                            If Trim(.Result) = "!!!!!!!!" And Trim(.RslCmtCd1) = "" And Trim(.RslCmtCd2) = "" Then
                                Exit Do
                            End If
                            
                            ReDim Preserve vntInsItemCd(lngCount)
                            ReDim Preserve vntInsResult(lngCount)
                            ReDim Preserve vntInsRslCmtCd1(lngCount)
                            ReDim Preserve vntInsRslCmtCd2(lngCount)
                            vntInsItemCd(lngCount) = Trim(.ItemCd)
                            vntInsResult(lngCount) = Trim(.Result)
                            vntInsRslCmtCd1(lngCount) = Trim(.RslCmtCd1)
                            vntInsRslCmtCd2(lngCount) = Trim(.RslCmtCd2)
                            lngCount = lngCount + 1
                            
                            Exit Do
                        Loop
        
                    End With
                    
                Next i
                    
                Exit Do
            Loop
        
        Loop

        'スタック情報存在時
        If lngCount > 0 Then
            
            'スタックされた検査結果の更新
'## 2003.02.12 Mod 2Lines By T.Takagi@FSIT オーダ分割区分対応
'            Ret2 = UpdateResult(lngRsvNo, vntInsItemCd, vntInsResult, vntInsRslCmtCd1, vntInsRslCmtCd2, vntMessage1, vntMessage2)
'## 2003.03.03 Mod 2Lines By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
'            Ret2 = UpdateResult(lngRsvNo, strSepOrderDiv, vntInsItemCd, vntInsResult, vntInsRslCmtCd1, vntInsRslCmtCd2, vntMessage1, vntMessage2)
            Ret2 = UpdateResult(lngRsvNo, strSepOrderDiv, vntInsItemCd, vntInsResult, vntInsRslCmtCd1, vntInsRslCmtCd2, vntMessage1, vntMessage2, vntInfoDiv)
'## 2003.03.03 Mod End
'## 2003.02.12 Mod End
        
            'ログ発行
 '## 2003.03.07 Mod 26Lines By T.Takagi@FSIT エラーと警告のカウント
'            strMessage = "検査結果が更新されました" & IIf(Not IsEmpty(vntMessage1), "が以下のエラーがあります", "") & "。"
            Do
            
                If IsEmpty(vntMessage1) Then
                    strMessage = "検査結果が更新されました。"
                    strInfoDiv = "I"
                    Exit Do
                End If
                
                '情報区分を検索
                For i = 0 To UBound(vntMessage1)
                    
                    '詳細にエラーが１個でもあればエラー
                    If vntInfoDiv(i) = "E" Then
                        strMessage = "検査結果が更新されましたが以下のエラーがあります。"
                        strInfoDiv = "E"
                        Exit Do
                    End If
                    
                Next i
                
                'エラーがなかったなら(警告レベルなら）正常とする
                strMessage = "検査結果が更新されましたが以下の警告があります。"
                strInfoDiv = "I"
                Exit Do
            Loop
'## 2003.03.07 Mod End
            strMessage2 = "受診日=" & Format(dtmCslDate, "yyyy/m/d")
            strMessage2 = strMessage2 & "、検体番号=" & lngTestTubeNo
            strMessage2 = strMessage2 & "、予約番号=" & lngRsvNo
            strMessage2 = strMessage2 & "、更新項目数=" & Ret2
'## 2003.03.07 Mod 2Lines By T.Takagi@FSIT エラーと警告のカウント
'            PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, "I", "", strMessage, strMessage2
            PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, strInfoDiv, "", strMessage, strMessage2
'## 2003.03.07 Mod End
    
            If Not IsEmpty(vntMessage1) Then
'## 2003.03.03 Mod 4Lines By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
'                PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, "E", "", vntMessage1, vntMessage2
                For i = 0 To UBound(vntMessage1)
                    PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, vntInfoDiv(i), "", vntMessage1(i), vntMessage2(i)
                Next i
'## 2003.03.03 Mod End
            End If
            
            '受診情報数をインクリメント
            lngUpdCount = lngUpdCount + 1
        
        End If

        'ファイルクローズ
        Close #intFileNo

        Exit Do
    Loop

    '終了ログの発行
    PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_RESPONSE, "I", "", "検査結果ファイルの取り込み処理を終了します。", ""
    
    '戻り値の設定
    ImportFile = lngUpdCount
    
    'トランザクションのコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    '戻り値の設定
    ImportFile = -1

    'ファイルクローズ
    Close #intFileNo

    'イベントログ書き込み
    WriteErrorLog "Response.ImportFile"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 受診日・検体番号をもとに受診情報を読み、予約番号とオーダ分割区分を取得する
'
' 引数　　 : (In)     dtmCslDate      受診日
' 　　　　   (In)     lngTestTubeNo   検体番号
' 　　　　   (Out)    strSepOrderDiv  オーダ分割区分
'
' 戻り値　 : １以上   予約番号
' 　　　　   ０　　   レコードなし
'
' 備考　　 :
'
'## 2003.02.12 Mod 2Lines By T.Takagi@FSIT オーダ分割区分対応
'Private Function SelectTestTubeMng(ByVal dtmCslDate As Date, ByVal lngTestTubeNo As Long) As Long
Private Function SelectTestTubeMng(ByVal dtmCslDate As Date, ByVal lngTestTubeNo As Long, ByRef strSepOrderDiv As String) As Long
'## 2003.02.12 Mod End

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objRsvNo        As OraField         '予約番号
'## 2003.02.12 Add 1Line By T.Takagi@FSIT オーダ分割区分対応
    Dim objSepOrderDiv  As OraField         'オーダ分割区分
'## 2003.02.12 Add End

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "TESTTUBENO", lngTestTubeNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '検索条件を満たす受診情報テーブルのレコードを取得
'## 2003.02.12 Mod 2Lines By T.Takagi@FSIT オーダ分割区分対応
'    strStmt = "SELECT RSVNO FROM TESTTUBEMNG WHERE CSLDATE = :CSLDATE AND TESTTUBENO = :TESTTUBENO"
    strStmt = "SELECT RSVNO, SEPORDERDIV FROM TESTTUBEMNG WHERE CSLDATE = :CSLDATE AND TESTTUBENO = :TESTTUBENO"
'## 2003.02.12 Mod End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
'## 2003.02.12 Add 1Line By T.Takagi@FSIT オーダ分割区分対応
        Set objSepOrderDiv = objFields("SEPORDERDIV")
'## 2003.02.12 Add End
        
        Ret = objRsvNo.Value

'## 2003.02.12 Add 1Line By T.Takagi@FSIT オーダ分割区分対応
        strSepOrderDiv = objSepOrderDiv.Value
'## 2003.02.12 Add End

    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectTestTubeMng = Ret
    
    Exit Function

ErrorHandle:

    SelectTestTubeMng = -1

    'イベントログ書き込み
    WriteErrorLog "Response.SelectTestTubeMng"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 検査結果のチェックおよび更新を行う
'
' 引数　　 : (In)     lngRsvNo         予約番号
' 　　　　   (In)     lngSepOrderDiv   オーダ分割区分
' 　　　　   (In)     vntInsItemCd     検査用項目コード
' 　　　　   (In)     vntInsResult     検査用検査結果
' 　　　　   (In)     vntInsRslCmtCd1  検査用結果コメントコード１
' 　　　　   (In)     vntInsRslCmtCd2  検査用結果コメントコード２
' 　　　　   (Out)    vntMessage1      メッセージ１
' 　　　　   (Out)    vntMessage2      メッセージ２
' 　　　　   (OUt)    vntInfoDiv       情報種別
'
' 戻り値　 : 更新された検査項目数
'
' 備考　　 :
'
'## 2003.02.12 Mod 19Lines By T.Takagi@FSIT オーダ分割区分対応
'Private Function UpdateResult(
'    ByVal lngRsvNo As Long,
'    ByRef vntInsItemCd As Variant,
'    ByRef vntInsResult As Variant,
'    ByRef vntInsRslCmtCd1 As Variant,
'    ByRef vntInsRslCmtCd2 As Variant,
'    ByRef vntMessage1 As Variant,
'    ByRef vntMessage2 As Variant
') As Long
'## 2003.03.03 Mod 21Lines By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
'Private Function UpdateResult(
'    ByVal lngRsvNo As Long,
'    ByVal lngSepOrderDiv As Long,
'    ByRef vntInsItemCd As Variant,
'    ByRef vntInsResult As Variant,
'    ByRef vntInsRslCmtCd1 As Variant,
'    ByRef vntInsRslCmtCd2 As Variant,
'    ByRef vntMessage1 As Variant,
'    ByRef vntMessage2 As Variant
') As Long
Private Function UpdateResult( _
    ByVal lngRsvNo As Long, _
    ByVal lngSepOrderDiv As Long, _
    ByRef vntInsItemCd As Variant, _
    ByRef vntInsResult As Variant, _
    ByRef vntInsRslCmtCd1 As Variant, _
    ByRef vntInsRslCmtCd2 As Variant, _
    ByRef vntMessage1 As Variant, _
    ByRef vntMessage2 As Variant, _
    ByRef vntInfoDiv As Variant _
) As Long
'## 2003.03.03 Mod End
'## 2003.02.12 Mod End
    
    Dim objResult           As Object   '検査結果アクセス用

    Dim vntItemCd           As Variant  '検査項目コード
    Dim vntSuffix           As Variant  'サフィックス
    Dim vntItemName         As Variant  '検査項目名
    Dim vntResult           As Variant  '検査結果
    Dim vntResultErr        As Variant  '検査結果のエラー状態
    Dim vntRslCmtCd1        As Variant  '結果コメント１
    Dim vntRslCmtCdErr1     As Variant  '結果コメント１のエラー状態
    Dim vntRslCmtCd2        As Variant  '結果コメント２
    Dim vntRslCmtCdErr2     As Variant  '結果コメント２のエラー状態
    Dim vntRet              As Variant  '検査項目のエラー状態

    Dim vntUpdRsvNo()       As Variant  '予約番号
    Dim vntUpdConsultFlg()  As Variant  '受診フラグ
    Dim vntUpdItemCd()      As Variant  '検査項目コード
    Dim vntUpdSuffix()      As Variant  'サフィックス
    Dim vntUpdResult()      As Variant  '検査結果
    Dim vntUpdRslCmtCd1()   As Variant  '結果コメントコード１
    Dim vntUpdRslCmtCd2()   As Variant  '結果コメントコード２
    Dim lngUpdCount         As Long     '更新項目数

    Dim vntArrMessage1()    As Variant  'メッセージ１
    Dim vntArrMessage2()    As Variant  'メッセージ２
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
    Dim vntArrInfoDiv()     As Variant  '情報種別
'## 2003.03.03 Add End
    Dim lngCount            As Long     'メッセージ数
    
    Dim strMessage          As String   'メッセージ
    Dim strMessage2         As String   'メッセージ
    Dim i                   As Long     'インデックス
    Dim j                   As Long     'インデックス
    
    '初期処理
    vntMessage1 = Empty
    vntMessage2 = Empty
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
    vntInfoDiv = Empty
'## 2003.03.03 Add End
    
    'オブジェクトのインスタンス作成
    Set objResult = CreateObject("HainsResult.Result")
    
    '検査結果チェック
'## 2003.02.12 Mod 10Lines By T.Takagi@FSIT オーダ分割区分対応
'    objResult.CheckRslValueOfInspection lngRsvNo, vntInsItemCd, vntItemCd, vntSuffix, vntItemName, _
'                                                  vntInsResult, vntResult, vntResultErr, _
'                                                  vntInsRslCmtCd1, vntRslCmtCd1, vntRslCmtCdErr1, _
'                                                  vntInsRslCmtCd2, vntRslCmtCd2, vntRslCmtCdErr2, _
'                                                  vntRet
    objResult.CheckRslValueOfInspection lngRsvNo, lngSepOrderDiv, vntInsItemCd, vntItemCd, vntSuffix, vntItemName, _
                                                                  vntInsResult, vntResult, vntResultErr, _
                                                                  vntInsRslCmtCd1, vntRslCmtCd1, vntRslCmtCdErr1, _
                                                                  vntInsRslCmtCd2, vntRslCmtCd2, vntRslCmtCdErr2, _
                                                                  vntRet
'## 2003.02.12 Mod End
    
    'チェック結果を検索
    For i = 0 To UBound(vntInsItemCd)

        'メッセージ２の基本部を編集
        strMessage = "予約番号=" & lngRsvNo & "、検査用項目コード=" & vntInsItemCd(i)
        strMessage2 = "検査項目=" & vntItemName(i) & "（" & vntItemCd(i) & "-" & vntSuffix(i) & "）"

        Do

            '結果チェック全体の戻り値判定
            Select Case CLng(vntRet(i))
                Case 1
                Case 0
                    ReDim Preserve vntArrMessage1(lngCount)
                    ReDim Preserve vntArrMessage2(lngCount)
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
                    ReDim Preserve vntArrInfoDiv(lngCount)
'## 2003.03.03 Add End
                    vntArrMessage1(lngCount) = "依頼がありません。"
                    vntArrMessage2(lngCount) = strMessage & "、" & strMessage2 & "、検査結果=" & vntInsResult(i)
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
                    vntArrInfoDiv(lngCount) = "E"
'## 2003.03.03 Add End
                    lngCount = lngCount + 1
                    Exit Do
                Case -1
                    ReDim Preserve vntArrMessage1(lngCount)
                    ReDim Preserve vntArrMessage2(lngCount)
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
                    ReDim Preserve vntArrInfoDiv(lngCount)
'## 2003.03.03 Add End
                    vntArrMessage1(lngCount) = "検査用項目コードの変換ができません。"
                    vntArrMessage2(lngCount) = strMessage
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
                    vntArrInfoDiv(lngCount) = "W"
'## 2003.03.03 Add End
                    lngCount = lngCount + 1
                    Exit Do
                Case -2
                    ReDim Preserve vntArrMessage1(lngCount)
                    ReDim Preserve vntArrMessage2(lngCount)
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
                    ReDim Preserve vntArrInfoDiv(lngCount)
'## 2003.03.03 Add End
                    vntArrMessage1(lngCount) = "検査用項目コード（OTHER）の変換ができません。"
                    vntArrMessage2(lngCount) = strMessage & "、結果コメント１=" & vntInsRslCmtCd1(i)
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
                    vntArrInfoDiv(lngCount) = "W"
'## 2003.03.03 Add End
                    lngCount = lngCount + 1
                    Exit Do
                Case -3     '更新非対象の場合はエラーを出力せずスキップ
                    Exit Do
            End Select

            '検査結果チェックの戻り値判定
            If vntResultErr(i) <> "" Then
                ReDim Preserve vntArrMessage1(lngCount)
                ReDim Preserve vntArrMessage2(lngCount)
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
                ReDim Preserve vntArrInfoDiv(lngCount)
'## 2003.03.03 Add End
                vntArrMessage1(lngCount) = GetErrorMessage(vntResultErr(i))
                vntArrMessage2(lngCount) = strMessage & "、" & strMessage2 & "、検査結果=" & vntInsResult(i)
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
                vntArrInfoDiv(lngCount) = "E"
'## 2003.03.03 Add End
                lngCount = lngCount + 1
            End If

            '結果コメント１チェックの戻り値判定
            If vntRslCmtCdErr1(i) <> "" Then
                ReDim Preserve vntArrMessage1(lngCount)
                ReDim Preserve vntArrMessage2(lngCount)
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
                ReDim Preserve vntArrInfoDiv(lngCount)
'## 2003.03.03 Add End
                vntArrMessage1(lngCount) = "コメントコードの登録ができません。"
                vntArrMessage2(lngCount) = strMessage & "、" & strMessage2 & "、結果コメント１=" & vntRslCmtCd1(i)
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
                vntArrInfoDiv(lngCount) = "E"
'## 2003.03.03 Add End
                lngCount = lngCount + 1
            End If

            '結果コメント２チェックの戻り値判定
            If vntRslCmtCdErr2(i) <> "" Then
                ReDim Preserve vntArrMessage1(lngCount)
                ReDim Preserve vntArrMessage2(lngCount)
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
                ReDim Preserve vntArrInfoDiv(lngCount)
'## 2003.03.03 Add End
                vntArrMessage1(lngCount) = "コメントコードの登録ができません。"
                vntArrMessage2(lngCount) = strMessage & "、" & strMessage2 & "、結果コメント２=" & vntRslCmtCd2(i)
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
                vntArrInfoDiv(lngCount) = "E"
'## 2003.03.03 Add End
                lngCount = lngCount + 1
            End If

            '結果・コメントのいずれかにエラーがある場合は処理を抜ける
            If vntResultErr(i) <> "" Or vntRslCmtCdErr1(i) <> "" Or vntRslCmtCdErr2(i) <> "" Then
                Exit Do
            End If

            '項目重複チェック
            For j = 0 To lngUpdCount - 1

                'すでに追加している項目は追加できない
                If Trim(vntItemCd(i)) = Trim(vntUpdItemCd(j)) And Trim(vntSuffix(i)) = Trim(vntUpdSuffix(j)) Then
                    ReDim Preserve vntArrMessage1(lngCount)
                    ReDim Preserve vntArrMessage2(lngCount)
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
                    ReDim Preserve vntArrInfoDiv(lngCount)
'## 2003.03.03 Add End
                    vntArrMessage1(lngCount) = "同じレコード内にこの検査項目の結果が存在します。"
                    vntArrMessage2(lngCount) = strMessage & "、" & strMessage2
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
                    vntArrInfoDiv(lngCount) = "E"
'## 2003.03.03 Add End
                    lngCount = lngCount + 1
                    Exit Do
                End If

            Next j

            '更新用項目への追加
            ReDim Preserve vntUpdRsvNo(lngUpdCount)
            ReDim Preserve vntUpdConsultFlg(lngUpdCount)
            ReDim Preserve vntUpdItemCd(lngUpdCount)
            ReDim Preserve vntUpdSuffix(lngUpdCount)
            ReDim Preserve vntUpdResult(lngUpdCount)
            ReDim Preserve vntUpdRslCmtCd1(lngUpdCount)
            ReDim Preserve vntUpdRslCmtCd2(lngUpdCount)
            vntUpdRsvNo(lngUpdCount) = lngRsvNo
            vntUpdConsultFlg(lngUpdCount) = CONSULT_ITEM_T
            vntUpdItemCd(lngUpdCount) = vntItemCd(i)
            vntUpdSuffix(lngUpdCount) = vntSuffix(i)
            vntUpdResult(lngUpdCount) = vntResult(i)
            vntUpdRslCmtCd1(lngUpdCount) = vntRslCmtCd1(i)
            vntUpdRslCmtCd2(lngUpdCount) = vntRslCmtCd2(i)
            lngUpdCount = lngUpdCount + 1

            Exit Do
        Loop

    Next i

    '検査結果更新
    If lngUpdCount > 0 Then
        objResult.UpdateRsl vntUpdRsvNo, vntUpdConsultFlg, vntUpdItemCd, vntUpdSuffix, vntUpdResult, vntUpdRslCmtCd1, vntUpdRslCmtCd2
    End If
    
    '戻り値の設定
    If lngCount > 0 Then
        vntMessage1 = vntArrMessage1
        vntMessage2 = vntArrMessage2
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 全部同じ情報種別では検索しにくいとのこと
        vntInfoDiv = vntArrInfoDiv
'## 2003.03.03 Add End
    End If
    
    UpdateResult = lngUpdCount
    
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
