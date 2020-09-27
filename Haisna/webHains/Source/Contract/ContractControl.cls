VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "ContractControl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext As ObjectContext    'オブジェクトコンテキスト

'
' 機能　　 : 金額情報のチェック
'
' 引数　　 : (In)     strItemName  項目名
' 　　　　   (In)     vntPrice     金額
'
' 戻り値　 : エラーメッセージ(正常時は長さ0の文字列)
'
' 備考　　 :
'
Private Function CheckCtrPtPrice(ByVal strItemName As String, ByRef vntPrice As Variant) As String

    Dim objCommon   As Common   '共通クラス
    
    Dim strMessage  As String   'メッセージ
    
    Dim i           As Long     'インデックス
        
    'オブジェクトのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    '負担金額のチェック
    For i = 0 To UBound(vntPrice)
        strMessage = objCommon.CheckNumeric(strItemName, Trim(vntPrice(i)), LENGTH_CTRPT_PRICE_PRICE)
        If strMessage <> "" Then
            Exit For
        End If
    Next i
            
    CheckCtrPtPrice = strMessage
    
End Function

'
' 機能　　 : 契約情報のコピー処理
'
' 引数　　 : (In)     strOrgCd1     団体コード1
' 　　　　   (In)     strOrgCd2     団体コード2
' 　　　　   (In)     strRefOrgCd1  参照先団体コード1
' 　　　　   (In)     strRefOrgCd2  参照先団体コード2
' 　　　　   (In)     lngCtrPtCd    契約パターンコード
' 　　　　   (In)     lngStrYear    契約開始年
' 　　　　   (In)     lngStrMonth   契約開始月
' 　　　　   (In)     lngStrDay     契約開始日
' 　　　　   (In)     lngEndYear    契約終了年
' 　　　　   (In)     lngEndMonth   契約終了月
' 　　　　   (In)     lngEndDay     契約終了日
'
' 戻り値　 : 0   正常終了
' 　　　　   1   契約期間が同一コースの他契約情報と重複
' 　　　　   2   契約団体自身が参照契約情報の負担元として存在
' 　　　　   <0  異常終了
'
' 備考　　 :
'
'
Public Function Copy( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strRefOrgCd1 As String, _
    ByVal strRefOrgCd2 As String, _
    ByVal lngCtrPtCd As Long, _
    ByVal lngStrYear As Long, _
    ByVal lngStrMonth As Long, _
    ByVal lngStrDay As Long, _
    ByVal lngEndYear As Long, _
    ByVal lngEndMonth As Long, _
    ByVal lngEndDay As Long _
) As String

    Dim objContract     As Contract     '契約情報アクセス用
    Dim objOrganization As Object       '団体情報アクセス用
    
    Dim vntCsCd         As Variant      'コースコード
    Dim vntStrDate      As Variant      '契約開始日
    Dim vntEndDate      As Variant      '契約終了日
    Dim vntOrgEquals    As Variant      '参照先団体一致フラグ
    Dim vntReferred     As Variant      '参照済みフラグ
    Dim vntOverlap      As Variant      '契約期間重複フラグ
    Dim vntExistBdn     As Variant      '負担元存在フラグ
    Dim lngCount        As Long         '契約情報数
    
    Dim dtmStrDate      As Date         '契約開始年月日
    Dim dtmEndDate      As Date         '契約終了年月日
    Dim lngNewCtrPtCd   As Variant      '(新)契約パターンコード
    
    Dim Ret             As Long         '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objContract = mobjContext.CreateInstance("HainsContract.Contract")
    Set objOrganization = mobjContext.CreateInstance("HainsOrganization.Organization")
    
    '同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
    '(基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
    If objOrganization.LockOrgRecord(strOrgCd1, strOrgCd2) = False Then
        Err.Raise vbObjectError + 513, "", "団体情報が存在しません。"
        Exit Function
    End If
    
    '同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
    If objContract.LockCtrPt(lngCtrPtCd) = False Then
        Err.Raise vbObjectError + 513, "", "契約情報が存在しません。"
        Exit Function
    End If
    
    '参照先団体契約情報の指定契約パターンにおける参照・コピー処理可否を取得する
    lngCount = objContract.SelectCtrMngRefer(strOrgCd1, strOrgCd2, strRefOrgCd1, strRefOrgCd2, vntCsCd, lngCtrPtCd, vntStrDate, vntEndDate, vntOrgEquals, vntReferred, vntOverlap, vntExistBdn)
    If lngCount <= 0 Then
        Err.Raise vbObjectError + 513, "", "契約情報が存在しません。"
        Exit Function
    End If
    
    '契約開始年月日の取得
    If lngStrYear <> 0 And lngStrMonth <> 0 And lngStrDay <> 0 Then
        dtmStrDate = CDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay)
    End If

    '契約終了年月日の取得
    If lngEndYear <> 0 And lngEndMonth <> 0 And lngEndDay <> 0 Then
        dtmEndDate = CDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay)
    End If
    
    Do
        '同一団体・コースにおいて既存の契約情報と契約期間が重複しないかをチェックする
        If objContract.CheckContractPeriod(strOrgCd1, strOrgCd2, vntCsCd, 0, dtmStrDate, dtmEndDate) = True Then
            Ret = 1
            Exit Do
        End If
    
        '契約団体が参照先契約団体契約情報の負担元として存在する場合
        If vntExistBdn Then
            Ret = 2
            Exit Do
        End If
    
        '次回発番契約パターンコードを取得する
        lngNewCtrPtCd = objContract.IncreaseCtrPtCd()
        
        '契約パターンテーブルの複写
        objContract.CopyCtrPt lngCtrPtCd, lngNewCtrPtCd, dtmStrDate, dtmEndDate
        
        '契約パターンの複写
        objContract.Copy lngCtrPtCd, lngNewCtrPtCd
        
        '指定団体、コースの、今発番した契約パターンコードを持つ契約情報を作成する
        objContract.InsertCtrMng strOrgCd1, strOrgCd2, vntCsCd, "", "", lngNewCtrPtCd
                
        Exit Do
    Loop
    
    'エラーの有無によるトランザクション制御
    If Ret = 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    '戻り値の設定
    Copy = Ret
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "ContractControl.Copy"

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 参照中契約情報のコピー処理
'
' 引数　　 : (In)     strOrgCd1     団体コード1
' 　　　　   (In)     strOrgCd2     団体コード2
' 　　　　   (In)     strRefOrgCd1  参照先団体コード1
' 　　　　   (In)     strRefOrgCd2  参照先団体コード2
' 　　　　   (In)     lngCtrPtCd    契約パターンコード
'
' 戻り値　 : 0   正常終了
' 　　　　   1   契約団体自身が参照契約情報の負担元として存在
' 　　　　   <0  異常終了
'
' 備考　　 :
'
'
Public Function CopyReferredContract( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strRefOrgCd1 As String, _
    ByVal strRefOrgCd2 As String, _
    ByVal lngCtrPtCd As Long _
) As String

    Dim objContract     As Contract     '契約情報アクセス用
    Dim objOrganization As Object       '団体情報アクセス用
    
    Dim vntCsCd         As Variant      'コースコード
    Dim vntStrDate      As Variant      '契約開始日
    Dim vntEndDate      As Variant      '契約終了日
    Dim vntOrgEquals    As Variant      '参照先団体一致フラグ
    Dim vntReferred     As Variant      '参照済みフラグ
    Dim vntOverlap      As Variant      '契約期間重複フラグ
    Dim vntExistBdn     As Variant      '負担元存在フラグ
    Dim lngCount        As Long         '契約情報数
    
    Dim lngNewCtrPtCd   As Variant      '(新)契約パターンコード
    
    Dim Ret             As Long         '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objOrganization = mobjContext.CreateInstance("HainsOrganization.Organization")
    Set objContract = mobjContext.CreateInstance("HainsContract.Contract")
    
    '同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
    '(基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
    If objOrganization.LockOrgRecord(strOrgCd1, strOrgCd2) = False Then
        Err.Raise vbObjectError + 513, "", "団体情報が存在しません。"
        Exit Function
    End If
    
    '同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
    If objContract.LockCtrPt(lngCtrPtCd) = False Then
        Err.Raise vbObjectError + 513, "", "契約情報が存在しません。"
        Exit Function
    End If
    
    '参照先団体契約情報の指定契約パターンにおける参照・コピー処理可否を取得する
    lngCount = objContract.SelectCtrMngRefer(strOrgCd1, strOrgCd2, strRefOrgCd1, strRefOrgCd2, vntCsCd, lngCtrPtCd, vntStrDate, vntEndDate, vntOrgEquals, vntReferred, vntOverlap, vntExistBdn)
    If lngCount <= 0 Then
        Err.Raise vbObjectError + 513, "", "契約情報が存在しません。"
        Exit Function
    End If
    
    Do
        '契約団体が参照先契約団体契約情報の負担元として存在する場合
        If vntExistBdn Then
            Ret = 1     '本メソッドにおいては本状態が発生していると請求周りが機能しなくなるので起こりえないのだが、一応
            Exit Do
        End If
    
        '次回発番契約パターンコードを取得する
        lngNewCtrPtCd = objContract.IncreaseCtrPtCd()
        
        '契約パターンテーブルの複写
        objContract.CopyCtrPt lngCtrPtCd, lngNewCtrPtCd, 0, 0
        
        '契約パターンの複写
        objContract.Copy lngCtrPtCd, lngNewCtrPtCd
        
        '指定団体、契約パターンの契約情報を削除する
        objContract.DeleteCtrMng strOrgCd1, strOrgCd2, lngCtrPtCd
        
        '指定団体、コースの、今発番した契約パターンコードを持つ契約情報を作成する
        objContract.InsertCtrMng strOrgCd1, strOrgCd2, vntCsCd, "", "", lngNewCtrPtCd
                
        '現状態で新契約パターンを参照している全契約情報の契約期間内における、全ての受診情報の契約パターン値を付け替える
        objContract.UpdateConsultCtrPt strOrgCd1, strOrgCd2, lngCtrPtCd, lngNewCtrPtCd
        
        Exit Do
    Loop
    
    'エラーの有無によるトランザクション制御
    If Ret = 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    '戻り値の設定
    CopyReferredContract = Ret
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "ContractControl.CopyReferredContract"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 契約情報の削除処理
'
' 引数　　 : (In)     strOrgCd1   団体コード1
' 　　　　   (In)     strOrgCd2   団体コード2
' 　　　　   (In)     lngCtrPtCd  契約パターンコード
'
' 戻り値　 : 0   正常終了
' 　　　　   1   他団体からの被参照契約情報である
' 　　　　   2   契約期間内に受診情報が存在
'
' 備考　　 :
'
'
Public Function DeleteContract(ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByVal lngCtrPtCd As Long) As Long

    Dim objContract     As Contract '契約情報アクセス用
    Dim objOrganization As Object   '団体情報アクセス用
    
    Dim vntMinCslDate   As Variant  '最小受診日
    Dim vntMaxCslDate   As Variant  '最大受診日
    
    Dim Ret             As Long     '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objContract = mobjContext.CreateInstance("HainsContract.Contract")
    Set objOrganization = mobjContext.CreateInstance("HainsOrganization.Organization")
    
    '同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
    '(基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
    If objOrganization.LockOrgRecord(strOrgCd1, strOrgCd2) = False Then
        Err.Raise vbObjectError + 513, "", "団体情報が存在しません。"
        Exit Function
    End If

    Do
        '同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
        If objContract.LockCtrPt(lngCtrPtCd) = False Then
            Exit Do     '←すでに存在しないならば処理を終了させる
        End If
        
        '指定団体、コースの契約情報を参照している契約情報が存在するかをチェック
        If objContract.CheckContractReferred(strOrgCd1, strOrgCd2, lngCtrPtCd) = True Then
            Ret = 1
            Exit Do
        End If
        
        '契約期間内に受診情報が存在するかをチェック
        If objContract.CheckConsultIntoContract(lngCtrPtCd, vntMinCslDate, vntMaxCslDate) = True Then
            Ret = 2
            Exit Do
        End If
        
        '指定団体、契約パターンの契約情報を削除する
        objContract.DeleteCtrMng strOrgCd1, strOrgCd2, lngCtrPtCd
        
        '契約パターンを削除する
        objContract.DeleteCtrPt lngCtrPtCd
    
        Exit Do
    Loop
    
    'エラーの有無によるトランザクション制御
    If Ret = 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    '戻り値の設定
    DeleteContract = Ret
    
    Exit Function
    
ErrorHandle:

    DeleteContract = -1
    
    'イベントログ書き込み
    WriteErrorLog "ContractControl.DeleteContract"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : オプションの削除処理
'
' 引数　　 : (In)     strOrgCd1       団体コード1
' 　　　　   (In)     strOrgCd2       団体コード2
' 　　　　   (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     strOptCd        オプションコード
' 　　　　   (In)     lngOptBranchNo  オプション枝番
'
' 戻り値　 : 0   正常終了
' 　　　　   1   受診オプション管理テーブルで参照されているレコードを削除しようとした
' 　　　　   2   追加オプション負担金テーブルで参照されているレコードを削除しようとした
' 　　　　   3   webオプション検査テーブルで参照されているレコードを削除しようとした
' 　　　　   <0  異常終了
'
' 備考　　 :
'
'
Public Function DeleteOption(ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByVal lngCtrPtCd As Long, ByVal strOptCd As String, ByVal lngOptBranchNo As Long) As Long

    Dim objContract     As Contract '契約情報アクセス用
    Dim objOrganization As Object   '団体情報アクセス用

    Dim Ret             As Long     '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objContract = CreateObject("HainsContract.Contract")
    Set objOrganization = CreateObject("HainsOrganization.Organization")
    
    '同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
    '(基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
    If objOrganization.LockOrgRecord(strOrgCd1, strOrgCd2) = False Then
        Err.Raise vbObjectError + 513, "", "団体情報が存在しません。"
        Exit Function
    End If

    '同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
    If objContract.LockCtrPt(lngCtrPtCd) = False Then
        Err.Raise vbObjectError + 513, "", "契約情報が存在しません。"
        Exit Function
    End If

    '指定契約パターン、オプションコードのオプション検査情報を削除する
    Ret = objContract.DeleteCtrPtOpt(lngCtrPtCd, strOptCd, lngOptBranchNo)

    '指定契約パターン、オプションコードのオプショングループ情報を削除する
    If Ret = 0 Then
        objContract.DeleteCtrPtOptGrp lngCtrPtCd, strOptCd
    End If

    'エラーの有無によるトランザクション制御
    If Ret = 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    '戻り値の設定
    DeleteOption = Ret
    
    Exit Function
    
ErrorHandle:

    DeleteOption = -1

    'イベントログ書き込み
    WriteErrorLog "ContractControl.DeleteOption"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 負担情報の抽出
'
' 引数　　 : (In/Out) vntSeq          SEQ
' 　　　　   (In/Out) vntApDiv        適用元区分
' 　　　　   (In/Out) vntOrgCd1       団体コード1
' 　　　　   (In/Out) vntOrgCd2       団体コード2
' 　　　　   (In/Out) vntPrice        負担金額
' 　　　　   (In/Out) vntTaxFlg       税負担フラグ
' 　　　　   (In/Out) vntAddUpFlg     １次基本料集計フラグ
' 　　　　   (In)     blnReCreateSeq  再発番フラグ(True指定時はSEQの再発番を行う)
'
' 戻り値　 :
'
' 備考　　 : 渡された負担情報より、団体コードの存在するもののみを抽出。
' 　　　　   ただし、個人負担・契約団体負担の情報は上記条件に関わらず無条件に抽出する。
'
Private Sub GetCtrPtOrg( _
    ByRef vntSeq As Variant, _
    ByRef vntApDiv As Variant, _
    ByRef vntOrgCd1 As Variant, _
    ByRef vntOrgCd2 As Variant, _
    ByRef vntPrice As Variant, _
    ByRef vntTaxFlg As Variant, _
    Optional ByVal blnReCreateSeq As Boolean _
)

    Dim vntArrSeq()     As Variant  'SEQの配列
    Dim vntArrApDiv()   As Variant  '適用元区分の配列
    Dim vntArrOrgCd1()  As Variant  '団体コード1の配列
    Dim vntArrOrgCd2()  As Variant  '団体コード2の配列
    Dim vntArrPrice()   As Variant  '負担金額の配列
    Dim vntArrTaxFlg()  As Variant  '税負担フラグの配列
    Dim lngCount        As Long     '割り当て負担情報数
    
    Dim blnAdd          As Boolean  '割り当て対象フラグ
    Dim i               As Long     'インデックス
    
    '負担金額情報から挿入に必要な情報のみ取得
    For i = 0 To UBound(vntSeq)

        '適用元区分による処理振り分け
        Select Case CLng(vntApDiv(i))

            '個人負担・自社負担の場合
            Case APDIV_PERSON, APDIV_MYORG

                'そのまま割り当て対象とする
                blnAdd = True

            '指定団体負担の場合
            Case Else

                '団体コードが存在すれば割り当て対象とする
                blnAdd = (vntOrgCd1(i) <> "" Or vntOrgCd2(i) <> "")

        End Select

        '割り当て対象の場合
        If blnAdd Then

            '配列を拡張
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrApDiv(lngCount)
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrTaxFlg(lngCount)

            '作業用の配列に追加する
            vntArrApDiv(lngCount) = vntApDiv(i)
            vntArrOrgCd1(lngCount) = vntOrgCd1(i)
            vntArrOrgCd2(lngCount) = vntOrgCd2(i)
            vntArrPrice(lngCount) = vntPrice(i)
            vntArrTaxFlg(lngCount) = vntTaxFlg(i)

            '再発番フラグ指定時、SEQは 1 から順番に付番(未指定時は引数値をそのまま適用)
            If blnReCreateSeq Then
                vntArrSeq(lngCount) = CStr(lngCount + 1)
            Else
                vntArrSeq(lngCount) = vntSeq(i)
            End If

            '割り当て情報数をインクリメント
            lngCount = lngCount + 1

        End If

    Next

    '作業用の配列情報で引数値を更新する
    vntSeq = vntArrSeq
    vntApDiv = vntArrApDiv
    vntOrgCd1 = vntArrOrgCd1
    vntOrgCd2 = vntArrOrgCd2
    vntPrice = vntArrPrice
    vntTaxFlg = vntArrTaxFlg
    
End Sub

'
' 機能　　 : 新しい契約情報を作成する
'
' 引数　　 : (In)     strOrgCd1       団体コード１
' 　　　　   (In)     strOrgCd2       団体コード２
' 　　　　   (In)     strCsCd         コースコード
' 　　　　   (In)     lngStrYear      契約開始年
' 　　　　   (In)     lngStrMonth     契約開始月
' 　　　　   (In)     lngStrDay       契約開始日
' 　　　　   (In)     lngEndYear      契約終了年
' 　　　　   (In)     lngEndMonth     契約終了月
' 　　　　   (In)     lngEndDay       契約終了日
' 　　　　   (In)     vntSeq          SEQ
' 　　　　   (In)     vntApDiv        適用元区分
' 　　　　   (In)     vntOrgCd1       (負担元の)団体コード１
' 　　　　   (In)     vntOrgCd2       (負担元の)団体コード２
' 　　　　   (In)     vntPrice        負担金額
' 　　　　   (In)     vntTaxFlg       消費税負担フラグ
' 　　　　   (In)     lngTaxFraction  税端数区分
' 　　　　   (In)     strAgeCalc      年齢起算日
' 　　　　   (In)     strCsName       コース名
' 　　　　   (In)     vntStrAge       開始年齢
' 　　　　   (In)     vntEndAge       終了年齢
' 　　　　   (In)     vntAgeDiv       年齢区分
'
' 戻り値　 : > 0  作成された契約情報の契約パターンコード
' 　　　　   0    契約団体の現契約情報と契約期間が重複
' 　　　　   < 0  異常終了
'
' 備考　　 :
'
Public Function InsertContract( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strCsCd As String, _
    ByVal lngStrYear As Long, _
    ByVal lngStrMonth As Long, _
    ByVal lngStrDay As Long, _
    ByVal lngEndYear As Long, _
    ByVal lngEndMonth As Long, _
    ByVal lngEndDay As Long, _
    ByRef vntSeq As Variant, _
    ByRef vntApDiv As Variant, _
    ByRef vntOrgCd1 As Variant, _
    ByRef vntOrgCd2 As Variant, _
    ByRef vntPrice As Variant, _
    ByRef vntTaxFlg As Variant, _
    Optional ByVal lngTaxFraction As Long = 1, _
    Optional ByVal strAgeCalc As String = "", _
    Optional ByVal strCsName As String = "", _
    Optional ByRef vntStrAge As Variant, _
    Optional ByRef vntEndAge As Variant, _
    Optional ByRef vntAgeDiv As Variant _
) As Long

    Dim objContract     As Contract     '契約情報アクセス用
    Dim objCourse       As Object       'コース情報アクセス用
    Dim objOrganization As Object       '団体情報アクセス用
    
    Dim dtmStrDate      As Date         '契約開始年月日
    Dim dtmEndDate      As Date         '契約終了年月日
    Dim lngCtrPtCd      As Long         '契約パターンコード
    
    Dim vntArrSeq       As Variant      'SEQの配列
    Dim vntArrApDiv     As Variant      '適用元区分の配列
    Dim vntArrOrgCd1    As Variant      '団体コード1の配列
    Dim vntArrOrgCd2    As Variant      '団体コード2の配列
    Dim vntArrPrice     As Variant      '負担金額の配列
    Dim vntArrTaxFlg    As Variant      '税負担フラグの配列

    Dim vntCsName       As Variant      'コース名
    
    Dim Ret             As Long         '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objContract = CreateObject("HainsContract.Contract")
    Set objOrganization = CreateObject("HainsOrganization.Organization")
    
    '更新対象負担情報の抽出
    vntArrSeq = vntSeq
    vntArrApDiv = vntApDiv
    vntArrOrgCd1 = vntOrgCd1
    vntArrOrgCd2 = vntOrgCd2
    vntArrPrice = vntPrice
    vntArrTaxFlg = vntTaxFlg
    Call GetCtrPtOrg(vntArrSeq, vntArrApDiv, vntArrOrgCd1, vntArrOrgCd2, vntArrPrice, vntArrTaxFlg, True)
    
    '同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
    '(基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
    If objOrganization.LockOrgRecord(strOrgCd1, strOrgCd2) = False Then
        Err.Raise vbObjectError + 513, "", "団体情報が存在しません。"
        Exit Function
    End If
        
    '契約開始年月日の取得
    If lngStrYear <> 0 And lngStrMonth <> 0 And lngStrDay <> 0 Then
        dtmStrDate = CDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay)
    End If

    '契約終了年月日の取得
    If lngEndYear <> 0 And lngEndMonth <> 0 And lngEndDay <> 0 Then
        dtmEndDate = CDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay)
    End If
    
    Do
        '同一団体・コースにおいて既存の契約情報と契約期間が重複しないかをチェックする
        If objContract.CheckContractPeriod(strOrgCd1, strOrgCd2, strCsCd, 0, dtmStrDate, dtmEndDate) = True Then
            Ret = 0
            Exit Do
        End If
        
        '次に発番する契約パターンコードを取得する
        lngCtrPtCd = objContract.IncreaseCtrPtCd()
        
        'コース名取得
        If strCsName = "" Then
            Set objCourse = CreateObject("HainsCourse.Course")
            objCourse.SelectCourse strCsCd, vntCsName
        Else
            vntCsName = strCsName
        End If
        
        '契約パターンテーブル挿入
        objContract.InsertCtrPt lngCtrPtCd, dtmStrDate, dtmEndDate, strAgeCalc, lngTaxFraction, vntCsName
        
        '契約管理テーブル挿入
        objContract.InsertCtrMng strOrgCd1, strOrgCd2, strCsCd, "", "", lngCtrPtCd
        
        '年齢区分情報があれば契約パターン年齢区分テーブル挿入
        If Not IsMissing(vntStrAge) And Not IsMissing(vntEndAge) And Not IsMissing(vntAgeDiv) Then
            If Not IsEmpty(vntStrAge) And Not IsEmpty(vntEndAge) And Not IsEmpty(vntAgeDiv) Then
                objContract.InsertCtrPtAge lngCtrPtCd, vntStrAge, vntEndAge, vntAgeDiv
            End If
        End If
        
        '契約パターン負担元管理テーブル挿入
        objContract.InsertCtrPtOrg lngCtrPtCd, vntArrSeq, vntArrApDiv, vntArrOrgCd1, vntArrOrgCd2, vntArrTaxFlg
        
        '正常終了した場合は契約パターンコードを返す
        Ret = lngCtrPtCd
        
        Exit Do
    Loop
    
    'エラーの有無によるトランザクション制御
    If Ret > 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    '戻り値の設定
    InsertContract = Ret
    
    Exit Function
    
ErrorHandle:

    '戻り値の設定
    InsertContract = -1

    'イベントログ書き込み
    WriteErrorLog "ContractControl.InsertContract"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 契約情報の参照
'
' 引数　　 : (In)     strOrgCd1     団体コード1
' 　　　　   (In)     strOrgCd2     団体コード2
' 　　　　   (In)     strRefOrgCd1  参照先団体コード1
' 　　　　   (In)     strRefOrgCd2  参照先団体コード2
' 　　　　   (In)     lngCtrPtCd    契約パターンコード
'
' 戻り値　 : 0   正常終了
' 　　　　   1   参照先団体が契約団体自身の契約を参照している
' 　　　　   2   参照先団体の契約情報がすでに契約団体自身から参照されている
' 　　　　   3   契約団体の現契約情報と契約期間が重複
' 　　　　   4   契約団体自身が参照契約情報の負担元として存在
' 　　　　   <0  異常終了
'
' 備考　　 :
'
'
Public Function Refer( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strRefOrgCd1 As String, _
    ByVal strRefOrgCd2 As String, _
    ByVal lngCtrPtCd As Long _
) As Long

    Dim objContract     As Contract '契約情報アクセス用
    Dim objOrganization As Object   '団体情報アクセス用

    Dim vntCsCd         As Variant  'コースコード
    Dim vntStrDate      As Variant  '契約開始日
    Dim vntEndDate      As Variant  '契約終了日
    Dim vntOrgEquals    As Variant  '参照先団体一致フラグ
    Dim vntReferred     As Variant  '参照済みフラグ
    Dim vntOverlap      As Variant  '契約期間重複フラグ
    Dim vntExistBdn     As Variant  '負担元存在フラグ
    Dim lngCount        As Long     '契約情報数
    
    Dim Ret             As Long     '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objContract = CreateObject("HainsContract.Contract")
    Set objOrganization = CreateObject("HainsOrganization.Organization")

    '同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
    '(基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
    If objOrganization.LockOrgRecord(strOrgCd1, strOrgCd2) = False Then
        Err.Raise vbObjectError + 513, "", "団体情報が存在しません。"
        Exit Function
    End If

    '同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
    If objContract.LockCtrPt(lngCtrPtCd) = False Then
        Err.Raise vbObjectError + 513, "", "契約情報が存在しません。"
        Exit Function
    End If

    '参照先団体契約情報の指定契約パターンにおける参照・コピー処理可否を取得する
    lngCount = objContract.SelectCtrMngRefer(strOrgCd1, strOrgCd2, strRefOrgCd1, strRefOrgCd2, vntCsCd, lngCtrPtCd, vntStrDate, vntEndDate, vntOrgEquals, vntReferred, vntOverlap, vntExistBdn)
    If lngCount <= 0 Then
        Err.Raise vbObjectError + 513, "", "契約情報が存在しません。"
        Exit Function
    End If

    Do
        '契約団体自身の契約情報を参照している場合はエラー
        '(※本フラグ成立時は必ず参照済みフラグ・契約期間重複フラグも成立するため、先にチェックする必要がある)
        If vntOrgEquals Then
            Ret = 1
            Exit Do
        End If

        'すでに契約団体自身から参照されている場合はエラー
        '(※本フラグ成立時は必ず契約期間重複フラグも成立するため、先にチェックする必要がある)
        If vntReferred Then
            Ret = 2
            Exit Do
        End If
        
        '契約期間が重複する場合はエラー
        If vntOverlap Then
            Ret = 3
            Exit Do
        End If

        '契約団体が参照先契約団体契約情報の負担元として存在する場合
        If vntExistBdn Then
            Ret = 4
            Exit Do
        End If

        '契約管理テーブルレコードの挿入
        objContract.InsertCtrMngRefer strOrgCd1, strOrgCd2, strRefOrgCd1, strRefOrgCd2, lngCtrPtCd

        Ret = 0
        Exit Do
    Loop

   'エラーの有無によるトランザクション制御
    If Ret = 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If

    '戻り値の設定
    Refer = Ret
    
    Exit Function
    
ErrorHandle:

    Refer = -1

    'イベントログ書き込み
    WriteErrorLog "ContractControl.Refer"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 契約情報の参照解除処理
'
' 引数　　 : (In)     strOrgCd1   団体コード1
' 　　　　   (In)     strOrgCd2   団体コード2
' 　　　　   (In)     lngCtrPtCd  契約パターンコード
'
' 戻り値　 : 0   正常終了
' 　　　　   1   契約期間内に受診情報が存在
' 　　　　   <0  異常終了
'
' 備考　　 :
'
'
Public Function Release(ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByVal lngCtrPtCd As Long) As Long

    Dim objContract     As Contract '契約情報アクセス用
    Dim objOrganization As Object   '団体情報アクセス用
    
    Dim vntMinCslDate   As Variant  '最小受診日
    Dim vntMaxCslDate   As Variant  '最大受診日
    
    Dim Ret             As Long     '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objContract = mobjContext.CreateInstance("HainsContract.Contract")
    Set objOrganization = mobjContext.CreateInstance("HainsOrganization.Organization")
    
    '同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
    '(基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
    If objOrganization.LockOrgRecord(strOrgCd1, strOrgCd2) = False Then
        Err.Raise vbObjectError + 513, "", "団体情報が存在しません。"
        Exit Function
    End If

    Do
        '同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
        If objContract.LockCtrPt(lngCtrPtCd) = False Then
            Exit Do     '←すでに存在しないならば処理を終了させる
        End If
        
        '契約期間内に受診情報が存在するかをチェック
        If objContract.CheckConsultIntoContract(lngCtrPtCd, vntMinCslDate, vntMaxCslDate, strOrgCd1, strOrgCd2) = True Then
            Ret = 1
            Exit Do
        End If
        
        '指定団体、契約パターンの契約情報を削除する
        objContract.DeleteCtrMng strOrgCd1, strOrgCd2, lngCtrPtCd
        
        Exit Do
    Loop
    
    'エラーの有無によるトランザクション制御
    If Ret = 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    '戻り値の設定
    Release = Ret
    
    Exit Function
    
ErrorHandle:

    Release = -1
    
    'イベントログ書き込み
    WriteErrorLog "ContractControl.Release"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 追加オプションの書き込み処理
'
' 引数　　 : (In)     strMode               処理モード("INS":挿入、"UPD":更新)
' 　　　　   (In)     strOrgCd1             団体コード1
' 　　　　   (In)     strOrgCd2             団体コード2
' 　　　　   (In)     lngCtrPtCd            契約パターンコード
' 　　　　   (In)     strOptCd              オプションコード
' 　　　　   (In)     lngOptBranchNo        オプション枝番
' 　　　　   (In)     strOptName            オプション名
' 　　　　   (In)     strOptSName           オプション略称
' 　　　　   (In)     strCsCd               コースコード
' 　　　　   (In)     strSetColor           セットカラー
' 　　　　   (In)     strSetClassCd         セット分類コード
' 　　　　   (In)     strRsvFraCd           予約枠コード
' 　　　　   (In)     strCslDivCd           受診区分コード
' 　　　　   (In)     lngGender             受診可能性別
' 　　　　   (In)     strLastRefMonth       前回値参照用月数
' 　　　　   (In)     strLastRefCsCd        前回値参照用コースコード
' 　　　　   (In)     lngAddCondition       追加条件
' 　　　　   (In)     strHideRsvFra         予約枠画面非表示
' 　　　　   (In)     strHideRsv            予約画面非表示
' 　　　　   (In)     strHideRpt            受付画面非表示
' 　　　　   (In)     strHideQuestion       問診画面非表示
' 　　　　   (In)     strExceptLimit        限度額設定除外
' 　　　　   (In)     vntStrAge             受診対象開始年齢
' 　　　　   (In)     vntEndAge             受診対象終了年齢
' 　　　　   (In)     vntSeq                SEQ
' 　　　　   (In)     vntOrgCd1             (負担元情報の)団体コード１
' 　　　　   (In)     vntOrgCd2             (負担元情報の)団体コード２
' 　　　　   (In)     vntPrice              負担金額
' 　　　　   (In)     vntTax                消費税
' 　　　　   (In)     vntBillPrintName      請求書出力名
' 　　　　   (In)     vntBillPrintEName     請求書英語出力名
' 　　　　   (In)     vntOrgDiv             団体種別
' 　　　　   (In)     vntGrpCd              グループコード
' 　　　　   (In)     vntItemCd             検査項目コード
'
' 戻り値　 : 0   正常終了
' 　　　　   1   負担元情報が変更されている
' 　　　　   2   調整金額が設定されてある負担元の負担金額をクリアしようとした
' 　　　　   3   同一オプションコードのオプション検査が存在
' 　　　　   <0  異常終了
'
' 備考　　 :
'
Public Function SetAddOption( _
    ByVal strMode As String, _
    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByVal lngCtrPtCd As Long, _
    ByVal strOptCd As String, ByVal lngOptBranchNo As Long, ByVal strOptName As String, ByVal strOptSName As String, _
    ByVal strCsCd As String, ByVal strSetColor As String, ByVal strSetClassCd As String, ByVal strRsvFraCd As String, _
    ByVal strCslDivCd As String, ByVal lngGender As Long, _
    ByVal strLastRefMonth As String, ByVal strLastRefCsCd As String, _
    ByVal lngAddCondition As Long, _
    ByVal strHideRsvFra As String, ByVal strHideRsv As String, ByVal strHideRpt As String, ByVal strHideQuestion As String, _
    ByVal strExceptLimit As String, _
    ByRef vntStrAge As Variant, _
    ByRef vntEndAge As Variant, _
    ByRef vntSeq As Variant, _
    ByRef vntOrgCd1 As Variant, _
    ByRef vntOrgCd2 As Variant, _
    ByRef vntPrice As Variant, _
    ByRef vntTax As Variant, _
    ByRef vntBillPrintName As Variant, ByRef vntBillPrintEName As Variant, _
    ByRef vntOrgDiv As Variant, _
    ByRef vntGrpCd As Variant, _
    ByRef vntItemCd As Variant _
) As Variant

    Dim objContract     As Contract '契約情報アクセス用
    Dim objFree         As Object   '汎用情報アクセス用
    Dim objOrganization As Object   '団体情報アクセス用
    
    Dim blnExistOpt     As Boolean  'オプション情報の有無
    Dim Ret             As Long     '関数戻り値
    
    Dim vntStrDate      As Variant  '契約開始日
    Dim vntEndDate      As Variant  '契約終了日
    Dim vntAgeCalc      As Variant  '年齢起算日
    
    Dim vntFreeDate     As Variant  '汎用日付
    Dim vntFreeField1   As Variant  '汎用フィールド１(汎用日付以前の税率)
    Dim vntFreeField2   As Variant  '汎用フィールド２(汎用日付以後の税率)
    
    Dim strTaxRate      As String   '税率
    Dim dblTaxRate      As Double   '税率
    Dim lngPrice        As Long     '負担金額
    
    Dim vntArrTax       As Variant  '消費税
    
    Dim Ret2            As Boolean  '関数戻り値
    Dim Ret3            As Long     '関数戻り値
    Dim i               As Long     'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objContract = CreateObject("HainsContract.Contract")
    
    '処理モードのチェック
    strMode = UCase(strMode)
    If strMode <> "INS" And strMode <> "UPD" Then
        Err.Raise vbObjectError + 513, "", "処理モードの値が不正です。"
        Exit Function
    End If
    
    '同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
    '(基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
    Set objOrganization = CreateObject("HainsOrganization.Organization")
    Ret2 = objOrganization.LockOrgRecord(strOrgCd1, strOrgCd2)
    Set objOrganization = Nothing
    
    If Ret2 = False Then
        Err.Raise vbObjectError + 513, "", "団体情報が存在しません。"
        Exit Function
    End If
    
    '同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
    If objContract.LockCtrPt(lngCtrPtCd) = False Then
        Err.Raise vbObjectError + 513, "", "契約情報が存在しません。"
        Exit Function
    End If
    
    Do
        
        '負担元情報のチェック(引数指定された団体とデータベース上のそれが完全一致しているか)
        If objContract.CheckCtrPtOrg(lngCtrPtCd, vntSeq, vntOrgCd1, vntOrgCd2) = False Then
            Ret = 1
            Exit Do
        End If
        
        '契約パターンオプション管理テーブルレコードの存在を確認する
        blnExistOpt = objContract.SelectCtrPtOpt(lngCtrPtCd, strOptCd, lngOptBranchNo)
        
        '各モードごとの処理分岐
        Select Case strMode
        
            '新規モードの場合
            Case "INS"
        
                'レコードが存在していればエラー
                If blnExistOpt Then
                    Ret = 3
                    Exit Do
                End If

            '更新モードの場合
            Case "UPD"
        
                'レコードの存在有無によるモード変更を行う
                If Not blnExistOpt Then
                    strMode = "INS"
                End If

        End Select

        '契約パターンオプショングループテーブルの更新
        objContract.MergeCtrPtOptGrp lngCtrPtCd, strOptCd, lngAddCondition, strHideRsvFra, strHideRsv, strHideRpt, strHideQuestion
    
        '契約パターンオプション管理テーブルの書き込み
        objContract.SetCtrPtOpt_Add strMode, lngCtrPtCd, strOptCd, lngOptBranchNo, strOptName, strOptSName, strCsCd, strSetColor, strSetClassCd, strRsvFraCd, strCslDivCd, lngGender, strLastRefMonth, strLastRefCsCd, strExceptLimit
        
        '契約パターンオプション年齢条件テーブル削除
        objContract.DeleteCtrPtOptAge lngCtrPtCd, strOptCd, lngOptBranchNo
        
        '受診対象年齢が存在する場合
        If Not IsEmpty(vntStrAge) And Not IsEmpty(vntEndAge) Then
            
            '契約パターンオプション年齢条件テーブル挿入
            objContract.InsertCtrPtOptAge lngCtrPtCd, strOptCd, lngOptBranchNo, vntStrAge, vntEndAge
        
        End If

        '消費税の計算
        Do
        
            vntArrTax = vntTax
            
            '契約パターンテーブルを読み、契約開始日を取得
            objContract.SelectCtrPt lngCtrPtCd, vntStrDate, vntEndDate, vntAgeCalc

            '汎用テーブルを読み、税率を取得
            Set objFree = CreateObject("HainsFree.Free")
            Ret3 = objFree.SelectFree(0, "TAX", , , vntFreeDate, vntFreeField1, vntFreeField2)
            Set objFree = Nothing
            
            If Ret3 <= 0 Then
                Exit Do
            End If

            '汎用日付未設定時は計算しない
            If Not IsDate(vntFreeDate) Then
                Exit Do
            End If

            '汎用日付と契約開始日との関係よりいずれの税率を使用するかを判定
            strTaxRate = IIf(vntStrDate >= vntFreeDate, vntFreeField2, vntFreeField1)

            '設定値が不正ならば計算しない
            If Not IsNumeric(strTaxRate) Then
                Exit Do
            End If
            
            dblTaxRate = CDbl(strTaxRate)
            
            '設定値が不正ならば計算しない
            If dblTaxRate < 0 Then
                Exit Do
            End If
            
            '消費税未設定ならば負担金額より消費税を計算する(端数は切り捨て)
            If IsArray(vntArrTax) Then
                For i = 0 To UBound(vntArrTax)
                    If vntArrTax(i) = "" Then
                        If vntPrice(i) <> "" Then
                            lngPrice = CLng(vntPrice(i))
                        Else
                            lngPrice = 0
                        End If
                        vntArrTax(i) = Fix(lngPrice * dblTaxRate)
                    End If
                Next i
            Else
                If vntArrTax = "" Then
                    If vntPrice <> "" Then
                        lngPrice = CLng(vntPrice)
                    Else
                        lngPrice = 0
                    End If
                    vntArrTax = Fix(lngPrice * dblTaxRate)
                End If
            End If
            
            Exit Do
        Loop
        
        '契約パターン負担金額管理テーブルの書き込み
        If objContract.SetCtrPtPrice(strMode, lngCtrPtCd, vntSeq, strOptCd, lngOptBranchNo, vntPrice, vntOrgDiv, vntArrTax, vntBillPrintName, vntBillPrintEName) <> 0 Then
            Ret = 2
            Exit Do
        End If

        '契約パターン内グループテーブル削除
        objContract.DeleteCtrPtGrp lngCtrPtCd, strOptCd, lngOptBranchNo
            
        'グループが存在する場合
        If Not IsEmpty(vntGrpCd) Then
            
            '契約パターン内グループテーブル挿入
            objContract.InsertCtrPtGrp lngCtrPtCd, strOptCd, lngOptBranchNo, vntGrpCd
        
        End If

        '契約パターン内検査項目テーブル削除
        objContract.DeleteCtrPtItem lngCtrPtCd, strOptCd, lngOptBranchNo
        
        '検査項目が存在する場合
        If Not IsEmpty(vntItemCd) Then
            
            '契約パターン内検査項目テーブル挿入
            objContract.InsertCtrPtItem lngCtrPtCd, strOptCd, lngOptBranchNo, vntItemCd
        
        End If

        Exit Do
    Loop
    
    Set objContract = Nothing
    
    'エラーの有無によるトランザクション制御
    If Ret = 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    '戻り値の設定
    SetAddOption = Ret
    
    Exit Function
    
ErrorHandle:

    SetAddOption = -1

    'イベントログ書き込み
    WriteErrorLog "ContractControl.SetAddOption"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 契約情報の分割
'
' 引数　　 : (In)     strOrgCd1   団体コード1
' 　　　　   (In)     strOrgCd2   団体コード2
' 　　　　   (In)     lngCtrPtCd  契約パターンコード
' 　　　　   (In)     dtmDate     分割日
'
' 戻り値　 : 0   正常終了
' 　　　　   1   契約情報分割不能
' 　　　　   2   分割日指定に誤り
'## 2004.01.27 Add By T.Takagi@FSIT 分割日以降に受付情報があれば分割不可
' 　　　　   3   分割日以降に受付情報あり
'## 2004.01.27 Add End
' 　　　　   <0  異常終了
'
' 備考　　 :
'
Public Function Split(ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByVal lngCtrPtCd As Long, ByVal dtmDate As Date) As Long

    Dim objContract     As Contract '契約情報アクセス用
    Dim objOrganization As Object   '団体情報アクセス用

    Dim vntOrgName      As Variant  '団体名称
    Dim vntCsCd         As Variant  'コースコード
    Dim vntCsName       As Variant  'コース名
    Dim vntStrDate      As Variant  '契約開始日
    Dim vntEndDate      As Variant  '契約終了日
    
    Dim lngNewCtrPtCd   As Variant  '(新)契約パターンコード
    
    Dim Ret             As Long     '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objContract = CreateObject("HainsContract.Contract")
    Set objOrganization = CreateObject("HainsOrganization.Organization")

    '指定団体・契約パターンを参照している全ての団体に対する他トランザクションからの操作を防ぐため、団体テーブルレコードをロックする
    '(最低でも指定団体の契約管理情報のレコードが1つ存在するべきなので、ここではエラーを発生させる)
    If objContract.LockOrgReferringContract(strOrgCd1, strOrgCd2, lngCtrPtCd) = False Then
        Err.Raise vbObjectError + 513, "", "団体情報が存在しません。"
        Exit Function
    End If

    '指定団体・契約パターンの契約情報を参照している全ての契約情報を持つ受診情報テーブルレコードのロック
    '(契約情報より先に受診情報に対してロックを適用する。一般的な受診情報更新処理では受診情報のほうを先にロックしているため。)
    objContract.LockConsultReferringContract strOrgCd1, strOrgCd2, lngCtrPtCd

    '同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
    If objContract.LockCtrPt(lngCtrPtCd) = False Then
        Err.Raise vbObjectError + 513, "", "契約情報が存在しません。"
        Exit Function
    End If

    Do
        '契約管理情報の読み込み
        objContract.SelectCtrMng strOrgCd1, strOrgCd2, lngCtrPtCd, vntOrgName, vntCsCd, vntCsName, vntStrDate, vntEndDate

        '契約開始・終了日が等しい場合は分割できない
        If vntStrDate = vntEndDate Then
            Ret = 1
            Exit Do
        End If
        
        '分割日が契約期間に含まれない場合は分割できない
        If dtmDate < CDate(vntStrDate) Or dtmDate >= CDate(vntEndDate) Then
            Ret = 2
            Exit Do
        End If
        
'## 2004.01.27 Add By T.Takagi@FSIT 分割日以降に受付情報があれば分割不可
        '以降に受付情報があれば分割不可
        If objContract.CheckConsultIntoContract_Rpt(lngCtrPtCd, dtmDate + 1, vntEndDate) > 0 Then
            Ret = 3
            Exit Do
        End If
'## 2004.01.27 Add End

        '現契約パターンの契約終了日を分割日で更新する
        objContract.UpdateCtrPt_Period lngCtrPtCd, vntStrDate, dtmDate

        '次回発番契約パターンコードを取得する
        lngNewCtrPtCd = objContract.IncreaseCtrPtCd()

        '契約パターンテーブルの複写(契約開始日は分割日の翌日、契約終了日は前契約パターンの契約終了日とする
        objContract.CopyCtrPt lngCtrPtCd, lngNewCtrPtCd, dtmDate + 1, vntEndDate

        '現契約パターンの内容を新契約パターンの契約情報として複写する
        objContract.Copy lngCtrPtCd, lngNewCtrPtCd

        '指定団体の現契約パターンを参照している全団体に対し、新契約パターンの参照情報を作成する
        objContract.InsertCtrMngAllRefer strOrgCd1, strOrgCd2, lngCtrPtCd, lngNewCtrPtCd

        '現状態で新契約パターンを参照している全契約情報の契約期間内における、全ての受診情報の契約パターン値を付け替える
        objContract.UpdateConsultCtrPt strOrgCd1, strOrgCd2, lngCtrPtCd, lngNewCtrPtCd

        Exit Do
    Loop
    
    'エラーの有無によるトランザクション制御
    If Ret = 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    '戻り値の設定
    Split = Ret

    Exit Function
    
ErrorHandle:

    Split = -1

    'イベントログ書き込み
    WriteErrorLog "ContractControl.Split"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'## 2002.11.10 Add Function By T.Takagi@FSIT 東急対応
'
' 機能　　 : 年齢起算日・年齢区分を更新する
'
' 引数　　 : (In)     strOrgCd1   団体コード1
' 　　　　   (In)     strOrgCd2   団体コード2
' 　　　　   (In)     lngCtrPtCd  契約パターンコード
' 　　　　   (In)     strAgeCalc  年齢起算日
' 　　　　   (In)     vntStrAge   開始年齢
' 　　　　   (In)     vntEndAge   終了年齢
' 　　　　   (In)     vntAgeDiv   年齢区分
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function UpdateAgeDiv( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal lngCtrPtCd As Long, _
    ByVal strAgeCalc As String, _
    ByRef vntStrAge As Variant, _
    ByRef vntEndAge As Variant, _
    ByRef vntAgeDiv As Variant _
) As Long

    Dim objContract     As Contract     '契約情報アクセス用
    Dim objOrganization As Object       '団体情報アクセス用
    
    Dim Ret             As Long         '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objContract = CreateObject("HainsContract.Contract")
    Set objOrganization = CreateObject("HainsOrganization.Organization")
    
    '同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
    '(基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
    If objOrganization.LockOrgRecord(strOrgCd1, strOrgCd2) = False Then
        Err.Raise vbObjectError + 513, "", "団体情報が存在しません。"
        Exit Function
    End If
        
    '同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
    If objContract.LockCtrPt(lngCtrPtCd) = False Then
        Err.Raise vbObjectError + 513, "", "契約情報が存在しません。"
        Exit Function
    End If
    
    '契約パターンテーブルの年齢起算日を更新
    objContract.UpdateCtrPt_AgeCalc lngCtrPtCd, strAgeCalc
        
    '契約パターン年齢区分テーブル削除
    objContract.DeleteCtrPtAge lngCtrPtCd
        
    '年齢区分情報があれば契約パターン年齢区分テーブル挿入
    If Not IsEmpty(vntStrAge) Then
        objContract.InsertCtrPtAge lngCtrPtCd, vntStrAge, vntEndAge, vntAgeDiv
    End If
        
    '戻り値の設定
    UpdateAgeDiv = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    UpdateAgeDiv = False

    'イベントログ書き込み
    WriteErrorLog "ContractControl.UpdateAgeDiv"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 契約情報の更新（負担元情報・負担金額情報）をする
'
' 引数　　 : (In)     strOrgCd1       団体コード1
' 　　　　   (In)     strOrgCd2       団体コード2
' 　　　　   (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     vntSeq          SEQ
' 　　　　   (In)     vntApDiv        適用元区分
' 　　　　   (In)     vntOrgCd1       (負担元の)団体コード1
' 　　　　   (In)     vntOrgCd2       (負担元の)団体コード2
' 　　　　   (In)     vntPrice        負担金額
' 　　　　   (In)     vntTaxFlg       消費税負担フラグ
' 　　　　   (Out)    vntRefOrgName   参照団体名称(負担元団体として指定されたが本パターンを参照している団体の名称)
'
' 戻り値　 : 0   正常終了
' 　　　　   1   コース基本項目以外の負担を行う負担元情報を削除しようとした
' 　　　　   2   追加オプション負担金テーブルで参照されている負担金額を削除しようとした
' 　　　　   3   この契約情報を参照している契約団体が負担元として存在
' 　　　　   4   受診情報で参照されているレコードを削除しようとした
' 　　　　   5   限度額負担の設定が行われている負担元を削除しようとした
' 　　　　   <0  異常終了
'
' 備考　　 :
'
Public Function UpdateContract( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal lngCtrPtCd As Long, _
    ByRef vntSeq As Variant, _
    ByRef vntApDiv As Variant, _
    ByRef vntOrgCd1 As Variant, _
    ByRef vntOrgCd2 As Variant, _
    ByRef vntPrice As Variant, _
    ByRef vntTaxFlg As Variant, _
    ByRef vntRefOrgName As Variant _
) As Long

    Dim objContract         As Contract '契約情報アクセス用
    Dim objOrganization     As Object   '団体情報アクセス用
    
    Dim vntArrSeq           As Variant  'SEQの配列
    Dim vntArrApDiv         As Variant  '適用元区分の配列
    Dim vntArrOrgCd1        As Variant  '団体コード1の配列
    Dim vntArrOrgCd2        As Variant  '団体コード2の配列
    Dim vntArrPrice         As Variant  '負担金額の配列
    Dim vntArrTaxFlg        As Variant  '税負担フラグの配列
    Dim lngCount            As Long     '負担元数
    
    Dim vntCurSeq           As Variant  '(DB上の)SEQの配列
    Dim vntCurOptBurden     As Variant  '(DB上の)オプション負担対象フラグ
    Dim vntCurLimitPriceFlg As Variant  '(DB上の)限度額負担フラグ
    Dim lngCurCount         As Long     '(DB上の)負担元数
    
    Dim strMode             As String   '処理モード("INS":更新情報の挿入、"UPD":更新情報の更新、"DEL":DB情報の削除)
    Dim Ret                 As Long     '関数戻り値
    Dim Ret2                As Long     '関数戻り値
    Dim i                   As Long     'インデックス
    Dim j                   As Long     'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objContract = CreateObject("HainsContract.Contract")
    Set objOrganization = CreateObject("HainsOrganization.Organization")

    '同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
    '(基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
    If objOrganization.LockOrgRecord(strOrgCd1, strOrgCd2) = False Then
        Err.Raise vbObjectError + 513, "", "団体情報が存在しません。"
        Exit Function
    End If

    '同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
    If objContract.LockCtrPt(lngCtrPtCd) = False Then
        Err.Raise vbObjectError + 513, "", "契約情報が存在しません。"
        Exit Function
    End If
    
    '更新対象負担情報の抽出
    vntArrSeq = vntSeq
    vntArrApDiv = vntApDiv
    vntArrOrgCd1 = vntOrgCd1
    vntArrOrgCd2 = vntOrgCd2
    vntArrPrice = vntPrice
    vntArrTaxFlg = vntTaxFlg
    Call GetCtrPtOrg(vntArrSeq, vntArrApDiv, vntArrOrgCd1, vntArrOrgCd2, vntArrPrice, vntArrTaxFlg)

    lngCount = UBound(vntArrSeq) + 1
        
    '現時点におけるデータベース上の追加・削除オプションおよび契約外項目負担情報を取得
    lngCurCount = objContract.SelectCtrPtOrgPrice(lngCtrPtCd, , , vntCurSeq, , , , , , , , , , , , , vntCurOptBurden, , , vntCurLimitPriceFlg)

    '負担元情報が存在しない場合はエラーを発生させる
    '(全ての契約情報は少なくとも個人負担用の負担元レコードを1つ所有する。従って本異常時は契約情報自体が存在しないに等しい。)
    If lngCurCount <= 0 Then
        Err.Raise vbObjectError + 513, "", "契約情報が存在しません。"
        Exit Function
    End If

    '(i:更新情報のインデックス、j:データベース情報のインデックス)
    i = 0
    j = 0

    '更新情報とデータベース上との負担元情報のマッチングを行う
    Do Until i >= lngCount And j >= lngCurCount
        
        '処理モードの決定
        Do
            '更新情報が最後まで検索されている場合
            If i >= lngCount Then
                strMode = "DEL"
                Exit Do
            End If

            'データベース情報が最後まで検索されている場合
            If j >= lngCurCount Then
                strMode = "INS"
                Exit Do
            End If

            '更新情報のSEQ値がデータベース上のそれより大きい場合
            If CLng(vntArrSeq(i)) > CLng(vntCurSeq(j)) Then
                strMode = "DEL"
                Exit Do
            End If

            'データベース上のSEQ値が更新情報のそれより大きい場合
            If CLng(vntArrSeq(i)) < CLng(vntCurSeq(j)) Then
                strMode = "INS"
                Exit Do
            End If

            '上記のいずれの条件にも合致しない場合、即ち双方のSEQ値が等しい場合
            strMode = "UPD"
            Exit Do
        Loop
        
        '処理モードごとの処理
        Select Case strMode
        
            '更新情報の挿入
            Case "INS"
            
                '契約パターン負担元管理テーブルの挿入
                objContract.InsertCtrPtOrg lngCtrPtCd, vntArrSeq(i), vntArrApDiv(i), vntArrOrgCd1(i), vntArrOrgCd2(i), vntArrTaxFlg(i)
            
                '現存する全てのオプション検査（基本コースを除く）に対し、指定された契約パターン、SEQの負担金額レコードを作成
                objContract.InsertCtrPtPrice lngCtrPtCd, vntArrSeq(i)
                
                '次の更新情報を検索するためにインデックスをインクリメント
                i = i + 1
            
            '更新情報の更新
            Case "UPD"
                
                '契約パターン負担元管理テーブルの更新
                objContract.UpdateCtrPtOrg lngCtrPtCd, vntArrSeq(i), vntArrOrgCd1(i), vntArrOrgCd2(i), vntArrTaxFlg(i)
                
                '次の更新情報およびデータベース情報を検索するためにインデックスをインクリメント
                i = i + 1
                j = j + 1
            
            'データベース情報の更新
            Case "DEL"
                
                'セットの負担を行う負担元は削除できない
                If vntCurOptBurden(j) <> "0" Then
                    Ret = 1
                    Exit Do
                End If
                
                '限度額負担の設定が行われている負担元は削除できない
                If vntCurLimitPriceFlg(i) <> "" Then
                    Ret = 5
                    Exit Do
                End If

                '削除対象負担元の子レコードとなるすべての契約パターン負担金額管理レコードを削除
                objContract.DeleteCtrPtPrice lngCtrPtCd, vntCurSeq(j)

                '契約パターン負担元管理テーブルの削除
                Ret2 = objContract.DeleteCtrPtOrg(lngCtrPtCd, vntCurSeq(j))
                Select Case Ret2
                    Case 0
                    Case 1
                        Ret = 1 '←「コース基本項目以外の負担を行う負担元は削除できない」と同義
                        Exit Do
                    Case 2, 3, 4
                        Ret = 4
                        Exit Do
                    Case Else
                        Ret = -1
                        Exit Do
                End Select

                '次のデータベース情報を検索するためにインデックスをインクリメント
                j = j + 1
        
        End Select
    
    Loop
        
    'ここまで正常の場合
    If Ret = 0 Then
    
        'この状態の負担元管理情報に存在する団体がこのパターンを参照しているかをチェックする
        If objContract.CheckDemandOrgReferred(strOrgCd1, strOrgCd2, lngCtrPtCd, vntRefOrgName) = True Then
            Ret = 3
        End If
        
    End If
    
    'エラーの有無によるトランザクション制御
    If Ret = 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    '戻り値の設定
    UpdateContract = Ret

    Exit Function
    
ErrorHandle:

    UpdateContract = -1

    'イベントログ書き込み
    WriteErrorLog "ContractControl.UpdateContract"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 限度額情報の更新
'
' 引数　　 : (In)     strOrgCd1       団体コード１
' 　　　　   (In)     strOrgCd2       団体コード２
' 　　　　   (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     vntSeq          ＳＥＱ
' 　　　　   (In)     vntOrgCd1       (負担元情報の)団体コード１
' 　　　　   (In)     vntOrgCd2       (負担元情報の)団体コード２
' 　　　　   (In)     strSeqOrg       対象負担元ＳＥＱ
' 　　　　   (In)     strLimitRate    限度率
' 　　　　   (In)     lngLimitTaxFlg  限度額消費税フラグ
' 　　　　   (In)     strLimitPrice   上限金額
' 　　　　   (In)     strSeqBdnOrg    減算した金額の負担元ＳＥＱ
'
' 戻り値　 : 0   正常終了
' 　　　　   1   負担元情報が変更されている
' 　　　　   <0  異常終了
'
' 備考　　 :
'
Public Function UpdateLimitPrice( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal lngCtrPtCd As Long, _
    ByRef vntSeq As Variant, _
    ByRef vntOrgCd1 As Variant, _
    ByRef vntOrgCd2 As Variant, _
    ByVal strSeqOrg As String, _
    ByVal strLimitRate As String, _
    ByVal lngLimitTaxFlg As Long, _
    ByVal strLimitPrice As String, _
    ByVal strSeqBdnOrg As String _
) As Long

    Dim objContract     As Contract '契約情報アクセス用
    Dim objOrganization As Object   '団体情報アクセス用

    Dim Ret             As Variant  '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'オブジェクトのインスタンス作成
    Set objContract = CreateObject("HainsContract.Contract")
    Set objOrganization = CreateObject("HainsOrganization.Organization")

    '同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
    '(基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
    If objOrganization.LockOrgRecord(strOrgCd1, strOrgCd2) = False Then
        Err.Raise vbObjectError + 513, "", "団体情報が存在しません。"
        Exit Function
    End If

    '同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
    If objContract.LockCtrPt(lngCtrPtCd) = False Then
        Err.Raise vbObjectError + 513, "", "契約情報が存在しません。"
        Exit Function
    End If
    
    Do
        '負担元情報のチェック
        If IsArray(vntSeq) And IsArray(vntOrgCd1) And IsArray(vntOrgCd2) Then
            If objContract.CheckCtrPtOrg(lngCtrPtCd, vntSeq, vntOrgCd1, vntOrgCd2) = False Then
                Ret = 1
                Exit Do
            End If
        End If
        
        '契約パターンテーブル更新
        objContract.UpdateCtrPt lngCtrPtCd, , , , , , , , strLimitRate, lngLimitTaxFlg, strLimitPrice
        
        '契約パターン負担元管理テーブル更新
        objContract.UpdateCtrPtOrgLimit lngCtrPtCd, strSeqOrg, strSeqBdnOrg
        
        Exit Do
    Loop
    
    'エラーの有無によるトランザクション制御
    If Ret = 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If

    '戻り値の設定
    UpdateLimitPrice = Ret
    
    Exit Function
    
ErrorHandle:
    
    UpdateLimitPrice = -1

    'イベントログ書き込み
    WriteErrorLog "ContractControl.UpdateLimitPrice"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 契約外項目の負担情報更新
'
' 引数　　 : (In)     strOrgCd1    団体コード1
' 　　　　   (In)     strOrgCd2    団体コード2
' 　　　　   (In)     lngCtrPtCd   契約パターンコード
' 　　　　   (In)     vntSeq       SEQ
' 　　　　   (In)     vntOrgCd1    (負担元情報の)団体コード1
' 　　　　   (In)     vntOrgCd2    (負担元情報の)団体コード2
' 　　　　   (In)     vntNoCtr     契約外項目負担フラグ
' 　　　　   (In)     vntFraction  契約外項目端数負担フラグ
'
' 戻り値　 : 0   正常終了
' 　　　　   1   負担元情報が変更されている
' 　　　　   <0  異常終了
'
' 備考　　 :
'
Public Function UpdateOuterContract( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal lngCtrPtCd As Long, _
    ByRef vntSeq As Variant, _
    ByRef vntOrgCd1 As Variant, _
    ByRef vntOrgCd2 As Variant, _
    ByRef vntNoCtr As Variant, _
    ByRef vntFraction As Variant _
) As Long

    Dim objContract     As Contract '契約情報アクセス用
    Dim objOrganization As Object   '団体情報アクセス用

    Dim Ret             As Variant  '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'オブジェクトのインスタンス作成
    Set objContract = CreateObject("HainsContract.Contract")
    Set objOrganization = CreateObject("HainsOrganization.Organization")

    '同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
    '(基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
    If objOrganization.LockOrgRecord(strOrgCd1, strOrgCd2) = False Then
        Err.Raise vbObjectError + 513, "", "団体情報が存在しません。"
        Exit Function
    End If

    '同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
    If objContract.LockCtrPt(lngCtrPtCd) = False Then
        Err.Raise vbObjectError + 513, "", "契約情報が存在しません。"
        Exit Function
    End If
    
    Do
        '負担元情報のチェック
        If objContract.CheckCtrPtOrg(lngCtrPtCd, vntSeq, vntOrgCd1, vntOrgCd2) = False Then
            Ret = 1
            Exit Do
        End If

        '契約パターン負担元管理テーブル更新
        objContract.UpdateCtrPtOrgNoCtr lngCtrPtCd, vntSeq, vntNoCtr, vntFraction

        Exit Do
    Loop
    
    'エラーの有無によるトランザクション制御
    If Ret = 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If

    '戻り値の設定
    UpdateOuterContract = Ret
    
    Exit Function
    
ErrorHandle:
    
    UpdateOuterContract = -1

    'イベントログ書き込み
    WriteErrorLog "ContractControl.UpdateOuterContract"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 契約期間の更新
'
' 引数　　 : (In)     strOrgCd1   団体コード1
' 　　　　   (In)     strOrgCd2   団体コード2
' 　　　　   (In)     strCsCd     コースコード
' 　　　　   (In)     lngCtrPtCd  契約パターンコード
' 　　　　   (In)     dtmStrDate  契約開始日
' 　　　　   (In)     dtmEndDate  契約終了日
'
' 戻り値　 : 0   正常終了
' 　　　　   1   指定された契約期間に適用可能なコース履歴が存在しない
' 　　　　   2   同一団体・コースの他契約情報と契約期間が重複
' 　　　　   3   契約期間変更により、契約パターンの存在しない受診情報が発生
'
' 備考　　 :
'
Public Function UpdatePeriod( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strCsCd As String, _
    ByVal lngCtrPtCd As Long, _
    ByVal dtmStrDate As Date, _
    ByVal dtmEndDate As Date _
) As String

    Dim objContract     As Contract '契約情報アクセス用
    Dim objCourse       As Object   'コース情報アクセス用
    Dim objOrganization As Object   '団体情報アクセス用

    Dim vntMinCslDate   As Variant  '最小受診日
    Dim vntMaxCslDate   As Variant  '最大受診日

    Dim Ret             As Long     '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objContract = CreateObject("HainsContract.Contract")
    Set objCourse = CreateObject("HainsCourse.Course")
    Set objOrganization = CreateObject("HainsOrganization.Organization")

    '同一団体に対する他トランザクションからの操作を防ぐため、指定団体の団体テーブルレコードをロックする
    '(基本的に団体テーブル非存在という事象はあるべきではないので、ここではエラーを発生させる)
    If objOrganization.LockOrgRecord(strOrgCd1, strOrgCd2) = False Then
        Err.Raise vbObjectError + 513, "", "団体情報が存在しません。"
        Exit Function
    End If

    '同一契約パターンに対する他トランザクションからの操作を防ぐため、レコードロックを行う
    If objContract.LockCtrPt(lngCtrPtCd) = False Then
        Err.Raise vbObjectError + 513, "", "契約情報が存在しません。"
        Exit Function
    End If

    Do
        '契約適用期間がコース適用期間に含まれるかチェック
        If objCourse.GetHistoryCount(strCsCd, dtmStrDate, dtmEndDate) <= 0 Then
            Ret = 1
            Exit Do
        End If
        
        '同一団体・コースにおいて既存の契約情報と契約期間が重複しないかをチェックする
        If objContract.CheckContractPeriod(strOrgCd1, strOrgCd2, strCsCd, lngCtrPtCd, dtmStrDate, dtmEndDate) = True Then
            Ret = 2
            Exit Do
        End If
        
         '契約期間内に受診情報が存在するかをチェック
        If objContract.CheckConsultIntoContract(lngCtrPtCd, vntMinCslDate, vntMaxCslDate) = True Then
            
            '更新する契約開始日より古い日付の受診情報が存在する、または更新する契約終了日より新しい日付の受診情報が存在する場合はエラー
            If vntMinCslDate < dtmStrDate Or vntMaxCslDate > dtmEndDate Then
                Ret = 3
                Exit Do
            End If
            
        End If
       
        '契約パターンテーブル更新
        objContract.UpdateCtrPt_Period lngCtrPtCd, dtmStrDate, dtmEndDate

        Exit Do
    Loop
    
    'エラーの有無によるトランザクション制御
    If Ret = 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If

    '戻り値の設定
    UpdatePeriod = Ret
    
    Exit Function
    
ErrorHandle:

    UpdatePeriod = -1

    'イベントログ書き込み
    WriteErrorLog "ContractControl.UpdatePeriod"
    
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

    'オブジェクトコンテキストを取得
    Set mobjContext = GetObjectContext()

End Sub

Private Function ObjectControl_CanBePooled() As Boolean

End Function

'
' 機能　　 : Deactivateイベント
'
' 備考　　 : COMオブジェクトが非アクティブ化された時点でデータベースからの切断を行う
'
Private Sub ObjectControl_Deactivate()

    'オブジェクトコンテキストの解放
    Set mobjContext = Nothing

End Sub
