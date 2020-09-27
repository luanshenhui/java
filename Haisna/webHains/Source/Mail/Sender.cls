VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Sender"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'----------------------------
'修正履歴
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.3.6
'担当者  ：T.Takagi@RD
'修正内容：新規作成

Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

Private Const TRANSACTIONDIV_RSVSEND    As String = "LOGRSVSEND"    '予約確認メール送信用のログ処理ＩＤ

'
' 機能　　 : 姓名を結合する
'
' 引数　　 : (In)     strLastName   姓
' 　　　　   (In)     strFirstName  名
'
' 戻り値　 : 結合後の氏名
'
' 備考　　 :
'
Private Function JoinName(ByVal strLastName As String, ByVal strFirstName As String)

    JoinName = Trim(Join(Array(strLastName, strFirstName), "　"))
    
End Function

'
' 機能　　 : オプション名称を結合する
'
' 引数　　 : (In)     vntOptionName  オプション名称
' 　　　　   (In)     strDelimiter   デリミタ
'
' 戻り値　 : 結合後のオプション名称
'
' 備考　　 :
'
Private Function JoinOptionName(ByRef vntOptionName As Variant, ByVal strDelimiter As String)

    If IsArray(vntOptionName) Then
        JoinOptionName = Join(vntOptionName, strDelimiter)
    Else
        JoinOptionName = vntOptionName
    End If
    
End Function

'
' 機能　　 : 予約確認メールの送信
'
' 引数　　 : (In)     strUserId  ユーザID
' 　　　　   (In)     strTemplateCd  テンプレートコード
' 　　　　   (In)     strArrRsvNo    予約番号
'
' 戻り値　 : 送信件数
'
' 備考　　 :
'
Public Function Send(ByVal strUserId As String, ByVal strTemplateCd As String, ByRef strArrRsvNo As Variant) As Long

    Dim objConfig           As Object       'メール送信設定アクセス用
    Dim objConsult          As Object       '受診情報アクセス用
    Dim objFree             As Object       '汎用情報アクセス用
    Dim objHainsLog         As Object       'ログ情報アクセス用
    Dim objHainsUser        As Object       'ユーザ情報アクセス用
    Dim objTemplate         As Object       'メールテンプレート情報アクセス用
    
    Dim objBasp             As Object       'BASP21コンポーネント
    
    Dim lngTransId          As Long         'トランザクションID
    Dim vntTitle            As Variant      '表題
    
    Dim vntUserName         As Variant      'ユーザ名
    
    Dim vntMailFrom         As Variant      'FROM
    Dim vntCC               As Variant      'CC
    Dim vntBCC              As Variant      'BCC
    Dim vntSignature        As Variant      '署名
    Dim vntServerName       As Variant      'SMPサーバ名
    Dim vntUserId           As Variant      'ユーザID
    Dim vntPassword         As Variant      'パスワード
    Dim vntPortNo           As Variant      'ポート番号
    
    Dim vntTemplateName     As Variant      'テンプレート名
    Dim vntSubject          As Variant      '表題
    Dim vntBody             As Variant      '本文
    
    Dim vntCslDate          As Variant      '受診日
    Dim vntCsName           As Variant      'コース名
    Dim vntCsEName          As Variant      '英語コース名
    Dim vntStrTime          As Variant      '開始時間
    Dim vntEndTime          As Variant      '終了時間
    Dim vntPerId            As Variant      '個人ID
    Dim vntLastName         As Variant      '姓
    Dim vntFirstName        As Variant      '名
    Dim vntLastKName        As Variant      'カナ姓
    Dim vntFirstKName       As Variant      'カナ名
    Dim vntRomeName         As Variant      'ローマ字名
    Dim vntGender           As Variant      '性別
    Dim vntBirth            As Variant      '生年月日
    Dim vntOrgName          As Variant      '団体名称
    Dim vntOrgEName         As Variant      '団体英語名称
    Dim vntSendMailDiv      As Variant      '予約確認メール送信先
    Dim vntEmail            As Variant      'e-Mail
    Dim vntPerPrice         As Variant      '個人負担金額
    Dim vntPrice            As Variant      '受診金額
    
    Dim vntConsultName      As Variant      '胃部受診項目名
    Dim vntConsultEName     As Variant      '胃部受診項目英語名
    
    Dim vntOptionName       As Variant      'オプション名称
    Dim vntOptionEName      As Variant      'オプション英語名称
    
    Dim strServerName       As String       'SMTPサーバ名
    Dim strMailFrom         As String       'FROM
    Dim strMailTo           As String       'TO
    Dim strBody             As String       '本文
    
    Dim strPerName          As String       '氏名
    Dim strSendMailDivName  As String       '予約確認メール送信先名称
    Dim strMessage          As String       'メッセージ
    Dim strErrMessage       As String       'メール送信時のエラーメッセージ
    
    Dim lngCount            As Long         '送信件数
    
    Dim Ret                 As Boolean      '戻り値
    Dim i                   As Long         'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    Set objHainsLog = CreateObject("HainsHainsLog.HainsLog")
    
    'トランザクションＩＤの取得
    lngTransId = objHainsLog.IncreaseTransactionId()
    
    Set objHainsLog = Nothing

    Set objFree = CreateObject("HainsFree.Free")

    '汎用テーブルから表題を取得
    objFree.SelectFree 0, TRANSACTIONDIV_RSVSEND, , vntTitle

    Set objFree = Nothing

    Set objBasp = CreateObject("BASP21")

    '開始ログの発行
    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVSEND, "I", "", vntTitle & "処理を開始します。", ""

    Do
    
        'ユーザ情報の取得
        Set objHainsUser = CreateObject("HainsHainsUser.HainsUser")
        If objHainsUser.SelectUserName(strUserId, , vntUserName) = False Then
            PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVSEND, "E", "", "指定されたユーザIDは存在しません。", "ユーザID=" & strUserId
            Exit Do
        End If
    
        Set objConfig = CreateObject("HainsMail.Config")
        
        'メール送信設定の取得
        If objConfig.SelectMailConf(vntMailFrom, vntCC, vntBCC, vntSignature, vntServerName, vntUserId, vntPassword, vntPortNo) = False Then
            PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVSEND, "E", "", "メール送信設定の読み込みに失敗しました。", ""
            Exit Do
        End If

        Set objConfig = Nothing

        Ret = True
            
        'メール送信設定の必須項目チェック
        Do
        
            '送信元メールアドレスの必須チェック
            If vntMailFrom = "" Then
                PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVSEND, "E", "", "送信元メールアドレスが設定されていません。", ""
                Ret = False
            End If

            'サーバ名の必須チェック
            If vntServerName = "" Then
                PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVSEND, "E", "", "SMTPサーバーが設定されていません。", ""
                Ret = False
            End If

            Exit Do
        Loop

        If Ret = False Then
            Exit Do
        End If

        Set objTemplate = CreateObject("HainsMail.Template")
        
        'メールテンプレート情報の取得
        If objTemplate.SelectMailTemplate(strTemplateCd, vntTemplateName, vntSubject, vntBody) = False Then
            PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVSEND, "E", "", "指定されたメールテンプレートは存在しません。", "テンプレートコード=" & strTemplateCd
            Exit Do
        End If

        Set objTemplate = Nothing

        '指定テンプレートの通知
        PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVSEND, "I", "", "次のメールテンプレートが指定されました。", "テンプレートコード=" & strTemplateCd & "(" & vntTemplateName & ")"

        'BASP21メール送信メソッドのためのパラメータ設定
        strServerName = vntServerName & IIf(vntPortNo <> "", ":" & vntPortNo, "")
        strMailFrom = vntMailFrom
        If vntUserId <> "" Or vntPassword <> "" Then
            strMailFrom = strMailFrom & vbTab & vntUserId & ":" & vntPassword
        End If
        
        Set objConsult = CreateObject("HainsMail.Consult")
        
        '受診情報の検索
        For i = 0 To UBound(strArrRsvNo)
    
            Do

                strMessage = "予約番号=" & strArrRsvNo(i)
                
                '受診情報読み込み
                Ret = objConsult.SelectConsult( _
                    strArrRsvNo(i), _
                    vntCslDate, _
                    vntCsName, vntCsEName, _
                    vntStrTime, vntEndTime, _
                    vntPerId, _
                    vntLastName, vntFirstName, _
                    vntLastKName, vntFirstKName, _
                    vntRomeName, _
                    vntGender, vntBirth, _
                    vntOrgName, vntOrgEName, _
                    vntSendMailDiv, vntEmail, _
                    vntPerPrice, vntPrice _
                )
                
                If Ret = False Then
                    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVSEND, "W", "", "受診情報が存在しません。", strMessage
                    Exit Do
                End If
                
                '胃部受診項目読み込み
                objConsult.SelectStomacConsultInfo strArrRsvNo(i), vntConsultName, vntConsultEName
                
                'オプション名称読み込み
                objConsult.SelectOptionNameList strArrRsvNo(i), vntOptionName, vntOptionEName
                
                strPerName = Trim(vntLastName & "　" & vntFirstName)
                strMessage = strMessage & "、受診者名=" & strPerName
                
                Select Case vntSendMailDiv
                    Case 1
                        strSendMailDivName = "住所（自宅）"
                    Case 2
                        strSendMailDivName = "住所（勤務先）"
                    Case 3
                        strSendMailDivName = "住所（その他）"
                    Case Else
                        strSendMailDivName = "なし"
                End Select
                
                '送信先メールアドレスの存在チェック
                If vntEmail = "" Then
                    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVSEND, "W", "", "送信先メールアドレスが存在しません。", strMessage & "、送信対象=" & strSendMailDivName
                    Exit Do
                End If
                
                'BASP21メール送信メソッドのための送信先設定
                strMailTo = vntEmail
                If vntCC <> "" Then
                    strMailTo = strMailTo & vbTab & "cc" & vbTab & Replace(vntCC, vbCrLf, vbTab)
                End If
                If vntBCC <> "" Then
                    strMailTo = strMailTo & vbTab & "bcc" & vbTab & Replace(vntBCC, vbCrLf, vbTab)
                End If
                
                '本文のテンプレート変換開始
                strBody = vntBody
                
                '氏名
                strBody = Replace(strBody, "{toName}", JoinName(vntLastName, vntFirstName), , , vbTextCompare)
                strBody = Replace(strBody, "{toKName}", JoinName(vntLastKName, vntFirstKName), , , vbTextCompare)
                strBody = Replace(strBody, "{toEName}", vntRomeName, , , vbTextCompare)
                
                '受診日
                strBody = Replace(strBody, "{jDate}", Format(vntCslDate, "YYYY. MM. DD"), , , vbTextCompare)
                strBody = Replace(strBody, "{jYear}", Year(CDate(vntCslDate)), , , vbTextCompare)
                strBody = Replace(strBody, "{jMonth}", Month(CDate(vntCslDate)), , , vbTextCompare)
                strBody = Replace(strBody, "{jDay}", Day(CDate(vntCslDate)), , , vbTextCompare)
                
                '受付時間
                strBody = Replace(strBody, "{uKaiTm}", IIf(vntStrTime > 0, Format(vntStrTime, "##:#0"), ""), , , vbTextCompare)
                strBody = Replace(strBody, "{uShuTm}", IIf(vntEndTime > 0, Format(vntEndTime, "##:#0"), ""), , , vbTextCompare)
                
                'コース名
                strBody = Replace(strBody, "{corsNm}", vntCsName, , , vbTextCompare)
                strBody = Replace(strBody, "{corsENm}", vntCsEName, , , vbTextCompare)
                
                '胃部受診項目
                strBody = Replace(strBody, "{stomacNm}", vntConsultName, , , vbTextCompare)
                strBody = Replace(strBody, "{stomacENm}", vntConsultEName, , , vbTextCompare)

                'オプション名称
                strBody = Replace(strBody, "{optNms}", JoinOptionName(vntOptionName, "、"), , , vbTextCompare)
                strBody = Replace(strBody, "{optNmsV}", JoinOptionName(vntOptionName, vbCrLf), , , vbTextCompare)
                
                'オプション英語名称
                strBody = Replace(strBody, "{optENms}", JoinOptionName(vntOptionEName, ", "), , , vbTextCompare)
                strBody = Replace(strBody, "{optENmsV}", JoinOptionName(vntOptionEName, vbCrLf), , , vbTextCompare)

                '個人負担金額、受診金額
                strBody = Replace(strBody, "{perPrice}", Format(vntPerPrice, "#,##0"), , , vbTextCompare)
                strBody = Replace(strBody, "{price}", Format(vntPrice, "#,##0"), , , vbTextCompare)

                '個人ID
                strBody = Replace(strBody, "{perId}", IIf(Left(vntPerId, 1) = "@", "", vntPerId), , , vbTextCompare)
                
                '生年月日
                strBody = Replace(strBody, "{birth}", Format(vntBirth, "YYYY. MM. DD"), , , vbTextCompare)

                '性別
                strBody = Replace(strBody, "{gender}", IIf(vntGender = "1", "男性", "女性"), , , vbTextCompare)
                strBody = Replace(strBody, "{genderE}", IIf(vntGender = "1", "male", "female"), , , vbTextCompare)

                '団体名
                strBody = Replace(strBody, "{orgName}", vntOrgName, , , vbTextCompare)
                strBody = Replace(strBody, "{orgEName}", vntOrgEName, , , vbTextCompare)
                
                '署名の追加
                If vntSignature <> "" Then
                    strBody = strBody & vbCrLf & vbCrLf & vntSignature
                End If
                
                'メール送信
                strErrMessage = objBasp.SendMail(strServerName, strMailTo, strMailFrom, vntSubject, strBody, "")
                If strErrMessage <> "" Then
                    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVSEND, "E", "", "予約確認メール送信時にエラーが発生しました。", strMessage & "、送信担当者=" & vntUserName & "、詳細=" & strErrMessage
                    Exit Do
                End If

                '送信完了ログの出力
                PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVSEND, "I", "", "予約確認メールが送信されました。", strMessage & "、送信担当者=" & vntUserName
        
                '送信件数をインクリメント
                lngCount = lngCount + 1
        
                '受診情報の更新
                If objConsult.UpdateConsult(strArrRsvNo(i), strUserId) = False Then
                    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVSEND, "E", "", "受診情報の更新時にエラーが発生しました。", strMessage
                    Exit Do
                End If
        
                Exit Do
            Loop
    
        Next i

        Exit Do
    Loop
    
    '終了ログ
    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVSEND, "I", "", vntTitle & "処理を終了します。", "送信件数=" & lngCount & "件"

    '戻り値の設定
    Send = lngCount
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Sender.Send"

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
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    'データベース接続
    Set mobjOraSession = mobjContext.CreateInstance("OracleInProcServer.XOraSession")
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
    
    'オブジェクトコンテキストの解放
    Set mobjContext = Nothing
    
End Sub


