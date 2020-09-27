<%
Const PRT_TEMPPATH = "/webHains/FollowDoc/"      'ＣｏＲｅｐｏｒｔワーク
Const PRT_DATAPATH = "/webHains/Reports/"       'ＣｏＲｅｐｏｒｔフォーム

Const PRINTMODE_PREVIEW = "0"       '印刷モード(プレビュー)
Const PRINTMODE_DIRECT  = "1"       '印刷モード(直接出力)

Const CNST_REQUEST = "001010"
'-------------------------------------------------------------------------------
'
' 機能　　 : 依頼状ASP制御処理
'
' 引数　　 : (In)   strMode  印刷モード
'
' 戻り値　 : メッセージ発生時、メッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function PrintControl(strMode, lngRsvNo, lngJudClassCd, PRT_DIV)

    'COMオブジェクト
    Dim objRequestLog   '印刷ログ情報アクセス用

    '作業用変数
    Dim lngPrintSeq     'プリントSEQ
    Dim strFileName     '帳票ドキュメントファイル名
    Dim vntMessage      'エラーメッセージ
    Dim strURL          'URL文字列

    Dim lngPos          '検索用変数
    Dim strExtension    '拡張子

    '固有引数値の取得
    Call GetQueryString()

    '印刷の制御
    Do

        '印刷終了時は何もしない
        '(印刷終了についてはURLのQueryString値によって通知させている)
        If Not IsEmpty(Request("printOut")) Then
            vntMessage = "印刷処理が完了しました。"
            Exit Do
        End If

        '印刷モード未指定時は何もしない
        If strMode = "" Then
            Exit Do
        End If

        '引数値のチェック
        vntMessage = CheckValue()
        If Not IsEmpty(vntMessage) Then
            Exit Do
        End If

        '■本プログラムにおける帳票出力処理について

        '帳票ドキュメントファイルの作成
        lngPrintSeq = Print()
        If lngPrintSeq <= 0 Then
            vntMessage = "データはありませんでした。"
            Exit Do
        End If

        '印刷ログ情報のプリントSEQをキーに、帳票ドキュメントファイル名を取得する。
        Set objRequestLog = Server.CreateObject("HainsRequestCard.RequestCard")
        If Not objRequestLog.SelectRequestLog(lngRsvNo, lngJudClassCd, PRT_DIV, lngPrintSeq, strFileName) Then
            vntMessage = "データはありませんでした。"
            Exit Do
        End If


       '印刷モードによる処理分岐
       Select Case strMode

           'ActiveXコントロールによるプレビューの場合
           Case PRINTMODE_PREVIEW

                If strFileName = "" Then
                    vntMessage = "データはありませんでした。"
                    Exit Do
                End If

                lngPos = InStrRev(strFileName, ".")
                If lngPos > 0 Then
                    strExtension = UCase(Mid(strFileName, lngPos + 1))
                End If

                'cidファイルの場合は
                If strExtension = "CID" Then

                    '得られた帳票ドキュメントファイル名を引数に付加し、プレビュー表示用のASPを呼び出す。
                    Response.Redirect "prtPreview.asp?documentFileName=" & strFileName
                    Response.End

                End If

           '直接印刷の場合
           Case PRINTMODE_DIRECT

               'ここで、今までの帳票出力では存在しなかった「印刷ログのプリントSEQをキーに帳票の印刷を行う」メソッドを呼び出す。
               If Not objRequestLog.PrintFile(lngPrintSeq, CNST_REQUEST, strFileName) Then
                   vntMessage = "印刷処理で異常が発生しました。"
                   Exit Do
               End If

               '自分自身を印刷終了通知付きでリダイレクトする。
               'これが無いと自身がリロードされる度に印刷処理が行われてしまうので、その回避策的意味合いを持つ。
               strURL = Request.ServerVariables("SCRIPT_NAME")
               strURL = strURL & "?printOut=1"
               strURL = strURL & "&" & Request.ServerVariables("QUERY_STRING")
               Response.Redirect strURL
               Response.End

       End Select

        Exit Do
    Loop

    PrintControl = vntMessage

End Function
%>
