VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "HainsUser"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'########################################
'管理番号：SL-HS-Y0101-002
'修正日  ：2010.08.30
'担当者  ：FJTH)KOMURO
'作成内容：オラクルセッション対応
'########################################
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

'
' 機能　　 : ログインIDとパスワードが一致するかチェック
'
' 引数　　 : (In)     strUserID      ユーザID
' 　　　　   (In)     strPassWord    パスワード
' 　　　　   (Out)    vntUserName    利用者漢字氏名
' 　　　　   (Out)    vntAuthTblMnt  テーブルメンテナンス権限
' 　　　　   (Out)    vntAuthRsv     予約業務権限
' 　　　　   (Out)    vntAuthRsl     結果入力業務権限
' 　　　　   (Out)    vntAuthJud     判定入力業務権限
' 　　　　   (Out)    vntAuthPrn     印刷、データ抽出業務権限
' 　　　　   (Out)    vntAuthDmd     請求業務権限
' 　　　　   (In)     vntEncode      TRUE:パスワード暗号化済み
' 　　　　   (Out)    vntIgnoreFlg   予約枠無視フラグ
' 　　　　   (Out)    vntAuthExt1    マスタメンテナンス権限 ##2004.12.22 ADD FJTH)C.M
'
' 戻り値　 : 0  正常終了
' 　　　　   1  ユーザＩＤ不一致
' 　　　　   2  パスワード不一致
' 　　　　   3  権限なし
' 　　　　   9  異常終了
'
' 備考　　 :
'
'## 2004.12.22 UPD ST FJTH)C.M マスタメンテナンス権限追加
'Public Function CheckIDandPassword(
'    ByVal strUserID As String,
'    ByVal strPassword As String,
'    ByRef vntUserName As Variant,
'    ByRef vntAuthTblMnt As Variant,
'    ByRef vntAuthRsv As Variant,
'    ByRef vntAuthRsl As Variant,
'    ByRef vntAuthJud As Variant,
'    ByRef vntAuthPrn As Variant,
'    ByRef vntAuthDmd As Variant,
'    Optional ByVal vntEncode As Variant,
'    Optional ByRef vntIgnoreFlg As Variant
') As Long
Public Function CheckIDandPassword( _
                                    ByVal strUserID As String, _
                                    ByVal strPassword As String, _
                                    ByRef vntUserName As Variant, _
                                    ByRef vntAuthTblMnt As Variant, _
                                    ByRef vntAuthRsv As Variant, _
                                    ByRef vntAuthRsl As Variant, _
                                    ByRef vntAuthJud As Variant, _
                                    ByRef vntAuthPrn As Variant, _
                                    ByRef vntAuthDmd As Variant, _
                                    Optional ByVal vntEncode As Variant, _
                                    Optional ByRef vntIgnoreFlg As Variant, _
                                    Optional ByRef vntAuthExt1 As Variant, _
                                    Optional ByRef vntDeptCd As Variant, _
                                    Optional ByRef vntUsrGrpCd As Variant _
                                    ) As Long
'## 2004.12.22 UPD ED
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objPassWord         As OraField         'パスワード
    Dim objUserName         As OraField         '利用者漢字氏名
    Dim objAuthTblMnt       As OraField         'テーブルメンテナンス権限
    Dim objAuthRsv          As OraField         '予約業務権限
    Dim objAuthRsl          As OraField         '結果入力業務権限
    Dim objAuthJud          As OraField         '判定入力業務権限
    Dim objAuthPrn          As OraField         '印刷、データ抽出業務権限
    Dim objAuthDmd          As OraField         '請求業務権限
    Dim objIgnoreFlg        As OraField         '予約枠無視フラグ
    Dim strEscPassWd        As String
'## 2004.12.22 ADD ST FJTH)C.M マスタメンテナンス権限追加
    Dim objAuthExt1         As OraField         'マスタメンテナンス権限
'## 2004.12.22 ADD ED
    Dim strEncodePassword   As String           'エンコード後のパスワード
    
'## 2005.07.26 Add By 李
    Dim objDeptCd          As OraField
    Dim objUsrGrpCd        As OraField
'## 2005.07.26 Add End.
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    If Not IsMissing(vntIgnoreFlg) Then vntIgnoreFlg = Empty
    
    If Not IsMissing(vntDeptCd) Then vntDeptCd = Empty
    If Not IsMissing(vntUsrGrpCd) Then vntUsrGrpCd = Empty
    
    '初期設定
    CheckIDandPassword = 9
    
    'ユーザIDが設定されていない場合は処理を終了する
    If Trim(strUserID) = "" Then
        CheckIDandPassword = 1
        Exit Function
    End If
        
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "USERID", UCase(Trim(strUserID)), ORAPARM_INPUT
    
    '検索条件を満たすWebユーザIDテーブルのレコードを取得
'## 2004.12.22 UPD ST FJTH)C.M マスタメンテナンス権限追加
'    strStmt = "SELECT PASSWORD, USERNAME, AUTHTBLMNT, AUTHRSV, " & vbLf & _
'              "       AUTHRSL,  AUTHJUD,  AUTHPRN,    AUTHDMD, " & vbLf & _
'              "       IGNOREFLG                                " & vbLf & _
'              "  FROM HAINSUSER                                " & vbLf & _
'              " WHERE USERID = :USERID                         "
    strStmt = "SELECT PASSWORD, USERNAME, AUTHTBLMNT, AUTHRSV,  " & vbLf & _
              "       AUTHRSL,  AUTHJUD,  AUTHPRN,    AUTHDMD,  " & vbLf & _
              "       IGNOREFLG, AUTHEXT1                       " & vbLf & _
              "       ,DEPTCD, USRGRPCD                          " & vbLf & _
              "  FROM HAINSUSER                                 " & vbLf & _
              " WHERE USERID = :USERID                          "
'## 2004.12.22 UPD ED
'## 2004.01.04 Add By T.Takagi@FSIT 削除フラグ追加
    strStmt = strStmt & vbLf & _
              "   AND DELFLG IS NULL "
'## 2004.01.04 Add End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '初期値の値をクリアする
    vntAuthTblMnt = 0
    vntAuthRsv = 0
    vntAuthRsl = 0
    vntAuthJud = 0
    vntAuthPrn = 0
    vntAuthDmd = 0
'## 2004.12.22 ADD ST FJTH)C.M マスタメンテナンス権限追加
    vntAuthExt1 = 0
'## 2004.12.22 ADD ED

    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPassWord = objFields("PASSWORD")
        Set objUserName = objFields("USERNAME")
        Set objAuthTblMnt = objFields("AUTHTBLMNT")
        Set objAuthRsv = objFields("AUTHRSV")
        Set objAuthRsl = objFields("AUTHRSL")
        Set objAuthJud = objFields("AUTHJUD")
'### 2003.03.03 Modified by Ishihara@FSIT おいおい、前からのバグが残
'        Set objAuthPrn = objFields("AUTHJUD")
        Set objAuthPrn = objFields("AUTHPRN")
'### 2003.03.03 Modified End
        Set objAuthDmd = objFields("AUTHDMD")
        Set objIgnoreFlg = objFields("IGNOREFLG")
'## 2004.12.22 ADD ST FJTH)C.M マスタメンテナンス権限追加
        Set objAuthExt1 = objFields("AUTHEXT1")
'## 2004.12.22 ADD ED
    
    
'## 2005.07.26 Add By 李
        Set objDeptCd = objFields("DEPTCD")
        Set objUsrGrpCd = objFields("USRGRPCD")
'## 2005.07.26 Add End.
        
        Call TBLIni
        strEncodePassword = SecretCodeMake(UCase(strPassword))
        
        '既にエンコード済みの場合、そのまま渡す
        If IsMissing(vntEncode) = False Then
            If vntEncode = True Then
                strEncodePassword = strPassword
            End If
        End If
        
        '戻り値の設定
        If objPassWord.Value & "" = strEncodePassword Then
            CheckIDandPassword = 0
            vntUserName = objUserName.Value
            vntAuthTblMnt = objAuthTblMnt.Value
            vntAuthRsv = objAuthRsv.Value
            vntAuthRsl = objAuthRsl.Value
            vntAuthJud = objAuthJud.Value
            vntAuthPrn = objAuthPrn.Value
            vntAuthDmd = objAuthDmd.Value
'## 2004.12.22 ADD ST FJTH)C.M マスタメンテナンス権限追加
            vntAuthExt1 = objAuthExt1.Value
'## 2004.12.22 ADD ED
    
            If Not IsMissing(vntIgnoreFlg) Then vntIgnoreFlg = objIgnoreFlg.Value & ""
            
            'まったく権限がないユーザはログインさせない
'## 2004.12.22 UPD ST FJTH)C.M マスタメンテナンス権限追加
'            If (vntAuthTblMnt = 0) And _
'               (vntAuthRsv = 0) And _
'               (vntAuthRsl = 0) And _
'               (vntAuthJud = 0) And _
'               (vntAuthPrn = 0) And _
'               (vntAuthDmd = 0) Then
'                CheckIDandPassword = 3
'            End If
            If (vntAuthTblMnt = 0) And _
               (vntAuthRsv = 0) And _
               (vntAuthRsl = 0) And _
               (vntAuthJud = 0) And _
               (vntAuthPrn = 0) And _
               (vntAuthExt1 = 0) And _
               (vntAuthDmd = 0) Then
                CheckIDandPassword = 3
            End If
'## 2004.12.22 UPD ED
        
'## 2005.07.26 Add By 李
            If Not IsMissing(vntDeptCd) Then vntDeptCd = objDeptCd.Value & ""
            If Not IsMissing(vntUsrGrpCd) Then vntUsrGrpCd = objUsrGrpCd.Value & ""

'## 2005.07.26 Add End.
        
        
        Else
            CheckIDandPassword = 2
        End If
    
    Else
        CheckIDandPassword = 1
    End If
    
'#### 2010.08.30 SL-HS-Y0101-002 ADD START ####
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'#### 2010.08.30 SL-HS-Y0101-002 ADD END ####
    
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "HainsUser.CheckIDandPassword"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : ユーザテーブルレコードの読み込み
'            面接医、判定医、看護師、栄養士、診察医フラグ　追加　2003.10.14
'
' 引数　　 : (In)     strUserID         ユーザID
' 　　　　 : (Out)    vntUserName       利用者漢字氏名
' 　　　　 : (Out)    vntTntKa          所属部課コード
' 　　　　 : (Out)    vntTntBt          所属病棟コード
' 　　　　 : (Out)    vntTntRm          所属病室コード
' 　　　　 : (Out)    vntTntSy          職制コード
' 　　　　 : (Out)    vntTntSt          有効開始日
' 　　　　 : (Out)    vntTntEd          有効終了日
' 　　　　 : (Out)    vntPassWord       パスワード
' 　　　　 : (Out)    vntAuthTblMnt     テーブルメンテナンス権限
' 　　　　 : (Out)    vntAuthRsv        予約権限
' 　　　　 : (Out)    vntAuthRsl        結果権限
' 　　　　 : (Out)    vntAuthJud        判定権限
' 　　　　 : (Out)    vntAuthPrn        印刷権限
' 　　　　 : (Out)    vntAuthDmd        請求権限
'### 2003/11/22 Modified by Ishihara@FSIT 聖路加未使用項目削除
' 　　　　 : (Out)    vntDoctorFlg      判定医フラグ（未使用）
' 　　　　 : (Out)    vntKname          カナ名
' 　　　　 : (Out)    vntEname          英語名
' 　　　　 : (Out)    vntPassDecode     TRUE:デコードしてパスワードを返す
' 　　　　 : (Out)    vntMenFlg         面接医フラグ
' 　　　　 : (Out)    vntHanFlg         判定医フラグ
' 　　　　 : (Out)    vntKanFlg         看護師フラグ
' 　　　　 : (Out)    vntEiFlg          栄養士フラグ
' 　　　　 : (Out)    vntShinFlg        診察医フラグ
' 　　　　 : (Out)    vntIgnoreFlg      予約枠無視フラグ
'## 2003.11.25 Mod By T.Takagi@FSIT 参照登録権限・ノート初期表示状態を追加
' 　　　　 : (Out)    vntAuthNote       参照登録権限
' 　　　　 : (Out)    vntDefNoteDispKbn ノート初期表示状態
'## 2003.12.22 Add
' 　　　　 : (Out)    vntNailg          内視鏡医フラグ
' 　　　　 : (Out)    vntSentenceCd     ユーザ対応文章コード
'## 2004.01.04 Add By T.Takagi@FSIT 削除フラグ追加
' 　　　　 : (Out)    vntDelFlg         削除フラグ
'## 2004.01.04 Add End
'## 2004.01.08 Add By H.Ishihara マスタメンテナンス用に完全修正
' 　　　　 : (Out)    vntShortStc       文章（ユーザ対応文章コードからの名称）
' 　　　　 : (Out)    vntAuthExt1       予備権限１
' 　　　　 : (Out)    vntAuthExt2       予備権限２
' 　　　　 : (Out)    vntAuthExt3       予備権限３
'## 2004.01.08 Add End

'## 2005.07.26 Add by 李
' 　　　　 : (Out)    vntDeptCd         職種分類
' 　　　　 : (Out)    vntUsrGrpCd       使用者分類
'## 2005.07.26 Add End.

'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
'## 2003.11.25 Mod By T.Takagi@FSIT 参照登録権限・ノート初期表示状態を追加
'Public Function SelectHainsUser(
'    ByVal strUserID As String,
'    ByRef vntUserName As Variant,
'    Optional ByRef vntTntKa As Variant,
'    Optional ByRef vntTntBt As Variant,
'    Optional ByRef vntTntRm As Variant,
'    Optional ByRef vntTntSy As Variant,
'    Optional ByRef vntTntSt As Variant,
'    Optional ByRef vntTntEd As Variant,
'    Optional ByRef vntPassWord As Variant,
'    Optional ByRef vntAuthTblMnt As Variant,
'    Optional ByRef vntAuthRsv As Variant,
'    Optional ByRef vntAuthRsl As Variant,
'    Optional ByRef vntAuthJud As Variant,
'    Optional ByRef vntAuthPrn As Variant,
'    Optional ByRef vntAuthDmd As Variant,
'    Optional ByRef vntDoctorFlg As Variant,
'    Optional ByRef vntKname As Variant, Optional ByRef vntEname As Variant,
'    Optional ByVal vntPassDecode As Variant,
'    Optional ByRef vntMenFlg As Variant, Optional ByRef vntHanFlg As Variant,
'    Optional ByRef vntKanFlg As Variant, Optional ByRef vntEiFlg As Variant,
'    Optional ByRef vntShinFlg As Variant, Optional ByRef vntIgnoreFlg As Variant
') As Boolean
'## 2004.01.04 Mod By T.Takagi@FSIT 削除フラグ追加
'Public Function SelectHainsUser(
'    ByVal strUserID As String,
'    ByRef vntUserName As Variant,
'    Optional ByRef vntTntKa As Variant,
'    Optional ByRef vntTntBt As Variant,
'    Optional ByRef vntTntRm As Variant,
'    Optional ByRef vntTntSy As Variant,
'    Optional ByRef vntTntSt As Variant,
'    Optional ByRef vntTntEd As Variant,
'    Optional ByRef vntPassWord As Variant,
'    Optional ByRef vntAuthTblMnt As Variant,
'    Optional ByRef vntAuthRsv As Variant,
'    Optional ByRef vntAuthRsl As Variant,
'    Optional ByRef vntAuthJud As Variant,
'    Optional ByRef vntAuthPrn As Variant,
'    Optional ByRef vntAuthDmd As Variant,
'    Optional ByRef vntDoctorFlg As Variant,
'    Optional ByRef vntKname As Variant, Optional ByRef vntEname As Variant,
'    Optional ByVal vntPassDecode As Variant,
'    Optional ByRef vntMenFlg As Variant, Optional ByRef vntHanFlg As Variant,
'    Optional ByRef vntKanFlg As Variant, Optional ByRef vntEiFlg As Variant,
'    Optional ByRef vntShinFlg As Variant, Optional ByRef vntIgnoreFlg As Variant,
'    Optional ByRef vntAuthNote As Variant, Optional ByRef vntDefNoteDispKbn As Variant,
'    Optional ByRef vntNaiFlg As Variant, Optional ByRef vntSentenceCd As Variant
') As Boolean

'
'###### 2005.04.04 Edit by 李 ########################################
'Public Function SelectHainsUser( _
'    ByVal strUserID As String, _
'    ByRef vntUserName As Variant, _
'    Optional ByRef vntTntKa As Variant, Optional ByRef vntTntBt As Variant, _
'    Optional ByRef vntTntRm As Variant, Optional ByRef vntTntSy As Variant, _
'    Optional ByRef vntTntSt As Variant, Optional ByRef vntTntEd As Variant, _
'    Optional ByRef vntPassWord As Variant, Optional ByRef vntAuthTblMnt As Variant, _
'    Optional ByRef vntAuthRsv As Variant, Optional ByRef vntAuthRsl As Variant, _
'    Optional ByRef vntAuthJud As Variant, Optional ByRef vntAuthPrn As Variant, _
'    Optional ByRef vntAuthDmd As Variant, Optional ByRef vntDoctorFlg As Variant, _
'    Optional ByRef vntKname As Variant, Optional ByRef vntEname As Variant, _
'    Optional ByVal vntPassDecode As Variant, _
'    Optional ByRef vntMenFlg As Variant, Optional ByRef vntHanFlg As Variant, _
'    Optional ByRef vntKanFlg As Variant, Optional ByRef vntEiFlg As Variant, _
'    Optional ByRef vntShinFlg As Variant, Optional ByRef vntIgnoreFlg As Variant, _
'    Optional ByRef vntAuthNote As Variant, Optional ByRef vntDefNoteDispKbn As Variant, Optional ByRef vntNaiFlg As Variant, _
'    Optional ByRef vntSentenceCd As Variant, Optional ByRef vntDelFlg As Variant, Optional ByRef vntShortStc As Variant, _
'    Optional ByRef vntAuthExt1 As Variant, Optional ByRef vntAuthExt2 As Variant, Optional ByRef vntAuthExt3 As Variant) As Boolean
'## 2004.01.04 Mod End
'## 2003.11.25 Mod End
    
'#### ユーザーグループ , 権限グループ 追加
Public Function SelectHainsUser( _
    ByVal strUserID As String, _
    ByRef vntUserName As Variant, _
    Optional ByRef vntTntKa As Variant, Optional ByRef vntTntBt As Variant, _
    Optional ByRef vntTntRm As Variant, Optional ByRef vntTntSy As Variant, _
    Optional ByRef vntTntSt As Variant, Optional ByRef vntTntEd As Variant, _
    Optional ByRef vntPassWord As Variant, Optional ByRef vntAuthTblMnt As Variant, _
    Optional ByRef vntAuthRsv As Variant, Optional ByRef vntAuthRsl As Variant, _
    Optional ByRef vntAuthJud As Variant, Optional ByRef vntAuthPrn As Variant, _
    Optional ByRef vntAuthDmd As Variant, Optional ByRef vntDoctorFlg As Variant, _
    Optional ByRef vntKname As Variant, Optional ByRef vntEname As Variant, _
    Optional ByVal vntPassDecode As Variant, _
    Optional ByRef vntMenFlg As Variant, Optional ByRef vntHanFlg As Variant, _
    Optional ByRef vntKanFlg As Variant, Optional ByRef vntEiFlg As Variant, _
    Optional ByRef vntShinFlg As Variant, Optional ByRef vntIgnoreFlg As Variant, _
    Optional ByRef vntAuthNote As Variant, Optional ByRef vntDefNoteDispKbn As Variant, Optional ByRef vntNaiFlg As Variant, _
    Optional ByRef vntSentenceCd As Variant, Optional ByRef vntDelFlg As Variant, Optional ByRef vntShortStc As Variant, _
    Optional ByRef vntAuthExt1 As Variant, Optional ByRef vntAuthExt2 As Variant, Optional ByRef vntAuthExt3 As Variant, _
    Optional ByRef vntDeptCd As Variant, Optional ByRef vntUsrGrpCd As Variant) As Boolean
   
'#### 2005.04.04 Edit End ...
   
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objUserName     As OraField         'ユーザ名
    Dim objTntKa(4)     As OraField         '所属部課コード
    Dim objTntBt(4)     As OraField         '所属病棟コード
    Dim objTntRm(4)     As OraField         '所属病室コード
    Dim objTntSy(4)     As OraField         '職制コード
    Dim objTntSt(4)     As OraField         '有効開始日
    Dim objTntEd(4)     As OraField         '有効終了日
    Dim objPassWord     As OraField         'パスワード
    Dim objAuthTblMnt   As OraField         'テーブルメンテナンス権限
    Dim objAuthRsv      As OraField         '予約業務権限
    Dim objAuthRsl      As OraField         '結果入力業務権限
    Dim objAuthJud      As OraField         '判定入力業務権限
    Dim objAuthPrn      As OraField         '印刷、データ抽出業務権限
    Dim objAuthDmd      As OraField         '請求業務権限
'### 2003/11/22 Deleted by Ishihara@FSIT 聖路加未使用のため削除
'    Dim objDoctorFlg    As OraField         '判定医フラグ
'### 2003/11/22 Deleted End
    Dim objKname        As OraField         '利用者カナ氏名
    Dim objEname        As OraField         '利用者英字氏名
    Dim objMenFlg       As OraField         '面接医フラグ
    Dim objHanFlg       As OraField         '判定医フラグ
    Dim objKanFlg       As OraField         '看護師フラグ
    Dim objEiFlg        As OraField         '栄養士フラグ
    Dim objShinFlg      As OraField         '診察医フラグ
    Dim objIgnoreFlg    As OraField         '予約枠無視フラグ
    
'## 2003.11.25 Add By T.Takagi@FSIT 参照登録権限・ノート初期表示状態を追加
    Dim objAuthNote         As OraField         '参照登録権限
    Dim objDefNoteDispKbn   As OraField         'ノート初期表示状態
'## 2003.11.25 Add End
    
'## 2003.12.22 add start
    Dim objNaiFlg      As OraField          '内視鏡医フラグ
    Dim objSentenceCd  As OraField          'ユーザ対応文章コード
'## 2003.12.22 add end
    
'## 2004.01.04 Add By T.Takagi@FSIT 削除フラグ追加
    Dim objDelFlg       As OraField          '削除フラグ
'## 2004.01.04 Add End

'## 2004.01.08 Add By H.Ishihara マスタメンテナンス用に完全修正
    Dim objShortStc     As OraField          '省略文章
    Dim objAuthExt1     As OraField          '予備権限1
    Dim objAuthExt2     As OraField          '予備権限2
    Dim objAuthExt3     As OraField          '予備権限3
'## 2004.01.08 Add End
      
'## 2005.04.04 Add by 李。ユーザーグループ , 権限グループ 追加
    Dim objDeptCd       As OraField          'ユーザーグループ
    Dim objUsrGrpCd     As OraField          '権限グループ
'## 2005.04.04 Add End
    
    Dim vntRetTntKa     As Variant          '所属部課コード
    Dim vntRetTntBt     As Variant          '所属病棟コード
    Dim vntRetTntRm     As Variant          '所属病室コード
    Dim vntRetTntSy     As Variant          '職制コード
    Dim vntRetTntSt     As Variant          '有効開始日
    Dim vntRetTntEd     As Variant          '有効終了日
    
    Dim strCurDate      As String           '現在の日付
    Dim strTntSt        As String           '有効開始日
    Dim strTntEd        As String           '有効終了日
    
    Dim blnRegal        As Boolean          'チェックが正常か
    Dim i               As Long             'インデックス
    Dim strDecodePassword   As String       'DECODE済みパスワード
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntUserName = Empty
    If Not IsMissing(vntTntKa) Then vntTntKa = Empty
    If Not IsMissing(vntTntBt) Then vntTntBt = Empty
    If Not IsMissing(vntTntRm) Then vntTntRm = Empty
    If Not IsMissing(vntTntSy) Then vntTntSy = Empty
    If Not IsMissing(vntTntSt) Then vntTntSt = Empty
    If Not IsMissing(vntTntEd) Then vntTntEd = Empty
    If Not IsMissing(vntPassWord) Then vntPassWord = Empty
    If Not IsMissing(vntAuthTblMnt) Then vntAuthTblMnt = Empty
    If Not IsMissing(vntAuthRsv) Then vntAuthRsv = Empty
    If Not IsMissing(vntAuthRsl) Then vntAuthRsl = Empty
    If Not IsMissing(vntAuthJud) Then vntAuthJud = Empty
    If Not IsMissing(vntAuthPrn) Then vntAuthPrn = Empty
    If Not IsMissing(vntAuthDmd) Then vntAuthDmd = Empty
    If Not IsMissing(vntDoctorFlg) Then vntDoctorFlg = Empty
    If Not IsMissing(vntKname) Then vntKname = Empty
    If Not IsMissing(vntEname) Then vntEname = Empty
    If Not IsMissing(vntMenFlg) Then vntMenFlg = Empty
    If Not IsMissing(vntHanFlg) Then vntHanFlg = Empty
    If Not IsMissing(vntKanFlg) Then vntKanFlg = Empty
    If Not IsMissing(vntEiFlg) Then vntEiFlg = Empty
    If Not IsMissing(vntShinFlg) Then vntShinFlg = Empty
    If Not IsMissing(vntIgnoreFlg) Then vntIgnoreFlg = Empty
'## 2003.11.25 Add By T.Takagi@FSIT 参照登録権限・ノート初期表示状態を追加
    If Not IsMissing(vntAuthNote) Then vntAuthNote = Empty
    If Not IsMissing(vntDefNoteDispKbn) Then vntDefNoteDispKbn = Empty
'## 2003.11.25 Add End
    
'## 2003.12.22 add start
    If Not IsMissing(vntNaiFlg) Then vntNaiFlg = Empty
    If Not IsMissing(vntSentenceCd) Then vntSentenceCd = Empty
'## 2003.12.22 add end
   
'## 2004.01.04 Add By T.Takagi@FSIT 削除フラグ追加
    If Not IsMissing(vntDelFlg) Then vntDelFlg = Empty
'## 2004.01.04 Add End
   
'## 2004.01.08 Add By H.Ishihara@FSIT 文章追加
    If Not IsMissing(vntShortStc) Then vntShortStc = Empty
'## 2004.01.08 Add End
   
'## 2005.04.04 Add by 李。ユーザーグループ , 権限グループ 追加
   If Not IsMissing(vntDeptCd) Then vntDeptCd = Empty
   If Not IsMissing(vntUsrGrpCd) Then vntUsrGrpCd = Empty
'## 2005.04.04 Add End ...
   
   
   'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "USERID", Trim(strUserID), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たすユーザIDテーブルのレコードを取得
'### 2003/11/22 Modified by Ishihara@FSIT 聖路加未使用項目削除
'    strStmt = "SELECT USERNAME, PASSWORD, AUTHTBLMNT, AUTHRSV, AUTHRSL, AUTHJUD, AUTHPRN, AUTHDMD, DOCTORFLG, KNAME, ENAME, " & vbLf & _
              "       MENFLG, HANFLG, KANFLG, EIFLG, SHINFLG, IGNOREFLG, "
'## 2003.11.25 Mod By T.Takagi@FSIT 参照登録権限・ノート初期表示状態を追加
'    strStmt = "SELECT USERNAME, PASSWORD, AUTHTBLMNT, AUTHRSV, AUTHRSL, AUTHJUD, AUTHPRN, AUTHDMD, KNAME, ENAME, " & vbLf & _
'              "       MENFLG, HANFLG, KANFLG, EIFLG, SHINFLG, IGNOREFLG"
'##### 2003.12.22 更に内視鏡医フラグ（NAIFLG), ユーザ対応文章コード(SENTENCECD) 追加
'    strStmt = "SELECT USERNAME, PASSWORD, AUTHTBLMNT, AUTHRSV, AUTHRSL, AUTHJUD, AUTHPRN, AUTHDMD, KNAME, ENAME, " & vbLf & _
'              "       MENFLG, HANFLG, KANFLG, EIFLG, SHINFLG, IGNOREFLG, AUTHNOTE, DEFNOTEDISPKBN, NAIFLG, SENTENCECD "
'### 2004.01.08 更に文章コードからの文章を追加
    'ユーザ対応文章コードは診察医でばりばりシバリ。コードまで抱き込み（笑）
    strStmt = "SELECT USERNAME, PASSWORD, AUTHTBLMNT, AUTHRSV, AUTHRSL, AUTHJUD, AUTHPRN, AUTHDMD, KNAME, ENAME,           " & vbLf & _
              "       MENFLG, HANFLG, KANFLG, EIFLG, SHINFLG, IGNOREFLG, AUTHNOTE, DEFNOTEDISPKBN, NAIFLG, SENTENCECD,     " & vbLf & _
              "       (SELECT SHORTSTC FROM SENTENCE WHERE ITEMCD = '30910' AND ITEMTYPE = 0 AND STCCD = SENTENCECD ) SHORTSTC, " & vbLf & _
              "       AUTHEXT1, AUTHEXT2, AUTHEXT3 "
'### 2004.01.08 更に文章コードからの文章を追加
'## 2003.11.25 Mod End
'### 2003/11/22 Modified End
    
'### 2003/11/22 Deleted by Ishihara@FSIT 聖路加未使用項目削除
'    '部課コード～有効終了日までの列を6回編集
'    For i = 1 To 5
'        strStmt = strStmt & vbLf & _
'              "       TNT" & i & "KA, " & vbLf & _
'              "       TNT" & i & "BT, " & vbLf & _
'              "       TNT" & i & "RM, " & vbLf & _
'              "       TNT" & i & "SY, " & vbLf & _
'              "       TNT" & i & "ST, " & vbLf & _
'              "       TNT" & i & "ED, "
'    Next i
'
'    '最後の2文字分は不要なので削る
'    strStmt = Left(strStmt, Len(strStmt) - 2)
'### 2003/11/22 Deleted End
    
'## 2004.01.04 Add By T.Takagi@FSIT 削除フラグ追加
    strStmt = RTrim(strStmt) & ", DELFLG "
'## 2004.01.04 Add End
    
    
'## 2005.04.04 Add by 李。ユーザーグループ , 権限グループ 追加
    strStmt = RTrim(strStmt) & ", DEPTCD, USRGRPCD "
'## 2005.04.04 Add End ..


    strStmt = strStmt & vbLf & _
              "  FROM HAINSUSER        " & vbLf & _
              " WHERE USERID = :USERID "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objUserName = objFields("USERNAME")
        Set objPassWord = objFields("PASSWORD")
        Set objAuthTblMnt = objFields("AUTHTBLMNT")
        Set objAuthRsv = objFields("AUTHRSV")
        Set objAuthRsl = objFields("AUTHRSL")
        Set objAuthJud = objFields("AUTHJUD")
        Set objAuthPrn = objFields("AUTHPRN")
        Set objAuthDmd = objFields("AUTHDMD")
'### 2003/11/22 Deleted by Ishihara@FSIT 聖路加未使用項目削除
'        Set objDoctorFlg = objFields("DOCTORFLG")
'### 2003/11/22 Deleted End
        Set objKname = objFields("KNAME")
        Set objEname = objFields("ENAME")
        Set objMenFlg = objFields("MENFLG")
        Set objHanFlg = objFields("HANFLG")
        Set objKanFlg = objFields("KANFLG")
        Set objEiFlg = objFields("EIFLG")
        Set objShinFlg = objFields("SHINFLG")
        Set objIgnoreFlg = objFields("IGNOREFLG")
'## 2003.11.25 Add By T.Takagi@FSIT 参照登録権限・ノート初期表示状態を追加
        Set objAuthNote = objFields("AUTHNOTE")
        Set objDefNoteDispKbn = objFields("DEFNOTEDISPKBN")
'## 2003.11.25 Add End
        
'## 2003.12.22 add start
        Set objNaiFlg = objFields("NAIFLG")
        Set objSentenceCd = objFields("SENTENCECD")
'## 2003.12.22 add end

'## 2004.01.04 Add By T.Takagi@FSIT 削除フラグ追加
        Set objDelFlg = objFields("DELFLG")
'## 2004.01.04 Add End

'## 2004.01.08 Add By H.Ishihara@FSIT 文章追加
        Set objShortStc = objFields("SHORTSTC")
        Set objAuthExt1 = objFields("AUTHEXT1")
        Set objAuthExt2 = objFields("AUTHEXT2")
        Set objAuthExt3 = objFields("AUTHEXT3")
'## 2004.01.08 Add End

'## 2005.04.04 Add by 李。ユーザーグループ , 権限グループ 追加
        Set objDeptCd = objFields("DEPTCD")
        Set objUsrGrpCd = objFields("USRGRPCD")
'## 2005.04.04 Add End ...


'### 2003/11/22 Deleted by Ishihara@FSIT 聖路加未使用項目削除
'        For i = 0 To UBound(objTntKa)
'            Set objTntKa(i) = objFields("TNT" & (i + 1) & "KA")
'            Set objTntBt(i) = objFields("TNT" & (i + 1) & "BT")
'            Set objTntRm(i) = objFields("TNT" & (i + 1) & "RM")
'            Set objTntSy(i) = objFields("TNT" & (i + 1) & "SY")
'            Set objTntSt(i) = objFields("TNT" & (i + 1) & "ST")
'            Set objTntEd(i) = objFields("TNT" & (i + 1) & "ED")
'        Next i
'
'        strCurDate = Format(Now, "yyyy/mm/dd")
'
'        '部課コード～有効終了日までを取得
'        For i = 0 To UBound(objTntKa)
'
'            '有効開始・終了日の取得
'            strTntSt = Format(objTntSt(i).Value & "", "0000/00/00")
'            strTntEd = Format(objTntEd(i).Value & "", "0000/00/00")
'
'            '有効開始・終了日範囲チェック
'            Select Case True
'                Case strTntSt = "" And strTntEd = ""
'                    blnRegal = False
'                Case strTntSt <> "" And strTntEd = ""
'                    blnRegal = (strCurDate >= strTntSt)
'                Case strTntSt = "" And strTntEd <> ""
'                    blnRegal = (strCurDate <= strTntEd)
'                Case Else
'                    blnRegal = (strCurDate >= strTntSt) And (strCurDate <= strTntEd)
'            End Select
'
'            'チェック正常であれば部課コード～有効終了日までを取得
'            If blnRegal Then
'                vntRetTntKa = objTntKa(i).Value & ""
'                vntRetTntBt = objTntBt(i).Value & ""
'                vntRetTntRm = objTntRm(i).Value & ""
'                vntRetTntSy = objTntSy(i).Value & ""
'                vntRetTntSt = objTntSt(i).Value & ""
'                vntRetTntEd = objTntEd(i).Value & ""
'                Exit For
'            End If
'
'        Next i
'### 2003/11/22 Deleted End
    
        '戻り値の設定
        vntUserName = objUserName.Value
'### 2003/11/22 Deleted by Ishihara@FSIT 聖路加未使用項目削除
'        If Not IsMissing(vntTntKa) Then vntTntKa = vntRetTntKa
'        If Not IsMissing(vntTntBt) Then vntTntBt = vntRetTntBt
'        If Not IsMissing(vntTntRm) Then vntTntRm = vntRetTntRm
'        If Not IsMissing(vntTntSy) Then vntTntSy = vntRetTntSy
'        If Not IsMissing(vntTntSt) Then vntTntSt = vntRetTntSt
'        If Not IsMissing(vntTntEd) Then vntTntEd = vntRetTntEd
'### 2003/11/22 Deleted End
        If Not IsMissing(vntPassWord) Then vntPassWord = objPassWord.Value & ""

'## 2002.03.28 Modified 1Line by H.Ishihara@FSIT ID&PASSWORD 両方共UCASE
        'Decode済みのパスワードを返す場合
        If (IsMissing(vntPassDecode) = False) And (IsMissing(vntPassWord) = False) Then
            If vntPassDecode = True Then
                Call TBLIni
                strDecodePassword = SecretCodeDecode(objPassWord.Value & "")
                vntPassWord = strDecodePassword
            End If
        End If
'## 2002.03.28 Modified End
        
        If Not IsMissing(vntAuthTblMnt) Then vntAuthTblMnt = objAuthTblMnt.Value & ""
        If Not IsMissing(vntAuthRsv) Then vntAuthRsv = objAuthRsv.Value & ""
        If Not IsMissing(vntAuthRsl) Then vntAuthRsl = objAuthRsl.Value & ""
        If Not IsMissing(vntAuthJud) Then vntAuthJud = objAuthJud.Value & ""
        If Not IsMissing(vntAuthPrn) Then vntAuthPrn = objAuthPrn.Value & ""
        If Not IsMissing(vntAuthDmd) Then vntAuthDmd = objAuthDmd.Value & ""
'### 2003/11/22 Modified by Ishihara@FSIT 聖路加未使用項目削除
'        If Not IsMissing(vntDoctorFlg) Then vntDoctorFlg = objDoctorFlg.Value & ""
        If Not IsMissing(vntDoctorFlg) Then vntDoctorFlg = 0
'### 2003/11/22 Modified End
        If Not IsMissing(vntKname) Then vntKname = objKname.Value & ""
        If Not IsMissing(vntEname) Then vntEname = objEname.Value & ""
        If Not IsMissing(vntMenFlg) Then vntMenFlg = objMenFlg.Value & ""
        If Not IsMissing(vntHanFlg) Then vntHanFlg = objHanFlg.Value & ""
        If Not IsMissing(vntKanFlg) Then vntKanFlg = objKanFlg.Value & ""
        If Not IsMissing(vntEiFlg) Then vntEiFlg = objEiFlg.Value & ""
        If Not IsMissing(vntShinFlg) Then vntShinFlg = objShinFlg.Value & ""
        If Not IsMissing(vntIgnoreFlg) Then vntIgnoreFlg = objIgnoreFlg.Value & ""
            
'## 2003.11.25 Add By T.Takagi@FSIT 参照登録権限・ノート初期表示状態を追加
        If Not IsMissing(vntAuthNote) Then vntAuthNote = objAuthNote.Value & ""
        If Not IsMissing(vntDefNoteDispKbn) Then vntDefNoteDispKbn = objDefNoteDispKbn.Value & ""
'## 2003.11.25 Add End
            
'## 2003.12.22 add start
        If Not IsMissing(vntNaiFlg) Then vntNaiFlg = objNaiFlg.Value & ""
        If Not IsMissing(vntSentenceCd) Then vntSentenceCd = objSentenceCd.Value & ""
'## 2003.12.22 add end
'## 2004.01.04 Add By T.Takagi@FSIT 削除フラグ追加
        If Not IsMissing(vntDelFlg) Then vntDelFlg = objDelFlg.Value & ""
'## 2004.01.04 Add End
       
'## 2004.01.08 Add By Ishihara@FSIT 文章追加
        If Not IsMissing(vntShortStc) Then vntShortStc = objShortStc.Value & ""
        If Not IsMissing(vntAuthExt1) Then vntAuthExt1 = objAuthExt1.Value & ""
        If Not IsMissing(vntAuthExt2) Then vntAuthExt2 = objAuthExt2.Value & ""
        If Not IsMissing(vntAuthExt3) Then vntAuthExt3 = objAuthExt3.Value & ""
'## 2004.01.08 Add End
       
       
'## 2005.04.04 Add by 李。ユーザーグループ , 権限グループ 追加
        If Not IsMissing(vntDeptCd) Then vntDeptCd = objDeptCd.Value & ""
        If Not IsMissing(vntUsrGrpCd) Then vntUsrGrpCd = objUsrGrpCd.Value & ""
'## 2005.04.04 Add End ...
       
       SelectHainsUser = True
    
    End If
    
    'バインド変数の削除
    objOraParam.Remove "USERID"
    
    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "HainsUser.SelectHainsUser"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 判定医師の一覧を取得する
'
' 引数　　 : (In)     strDoctorFlg  判定医フラグ
' 　　　　 : (Out)    vntDoctorCd   医師コード
' 　　　　 : (Out)    vntDoctorName 医師名
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectDoctorList(ByVal strDoctorFlg As String, _
                                 ByRef vntDoctorCd As Variant, _
                                 ByRef vntDoctorName As Variant _
                                ) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objDoctorCd         As OraField         '医師コード
    Dim objDoctorName       As OraField         '医師名
    
    Dim vntArrDoctorCd()    As Variant          '医師コードの配列
    Dim vntArrDoctorName()  As Variant          '医師名の配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Err.Raise 1000, , "SelectDoctorListメソッドは使用禁止です。判定医フラグを使用してはいけません。ソースコードの見直しを行ってください。"
    
    '検索条件が設定されていない場合はエラー
    If strDoctorFlg <> DOCTORFLG_USER And strDoctorFlg <> DOCTORFLG_DOCTOR Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    '初期処理
    vntDoctorCd = Empty
    vntDoctorName = Empty
    SelectDoctorList = 0
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DOCTORFLG", strDoctorFlg, ORAPARM_INPUT, ORATYPE_NUMBER
    
    'ユーザテーブルより判定医師のレコードを取得
    strStmt = "SELECT USERID, USERNAME          " & vbLf & _
              "  FROM HAINSUSER                 " & vbLf & _
              "  WHERE DOCTORFLG = :DOCTORFLG   " & vbLf & _
              "  ORDER BY USERID                "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objDoctorCd = objFields("USERID")
        Set objDoctorName = objFields("USERNAME")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrDoctorCd(lngCount)
            ReDim Preserve vntArrDoctorName(lngCount)
            vntArrDoctorCd(lngCount) = objDoctorCd.Value & ""
            vntArrDoctorName(lngCount) = objDoctorName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntDoctorCd = vntArrDoctorCd
    vntDoctorName = vntArrDoctorName
    SelectDoctorList = lngCount
        
    Set objOraDyna = Nothing
    objOraParam.Remove "DOCTORFLG"
    Set objOraParam = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "HainsUser.SelectDoctorList"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : ユーザ一覧を取得する
'
' 引数　　 : (Out)    vntUserID         ユーザコード
' 　　　　 : (Out)    vntUserName       ユーザ名
' 　　　　 : (In)     vntSearchCode     検索用コード（省略可）
' 　　　　 : (In)     vntSearchString   検索用文字列（省略可）
' 　　　　 : (Out)    vntDelFlg         削除フラグ
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectUserList(ByRef vntUserID As Variant, _
                               ByRef vntUserName As Variant, _
                               Optional ByVal vntSearchCode As Variant, _
                               Optional ByVal vntSearchString As Variant, _
                               Optional ByRef vntDelFlg As Variant _
                               ) As Long
    
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objUserID           As OraField         'ユーザコード
    Dim objUserName         As OraField         'ユーザ名
    Dim objDelFlg           As OraField         '削除フラグ
    
    Dim vntArrUserID()      As Variant          'ユーザコードの配列
    Dim vntArrUserName()    As Variant          'ユーザ名の配列
    Dim vntArrDelFlg()      As Variant          '削除フラグの配列
    Dim lngCount            As Long             'レコード数
    Dim blnWhereFlg         As Boolean
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntUserID = Empty
    vntUserName = Empty
    SelectUserList = 0
    lngCount = 0
    blnWhereFlg = False
    
    'ユーザテーブルより判定ユーザのレコードを取得
'### 2004/1/8 Updated by Ishihara@FSIT 削除フラグ追加
'    strStmt = "SELECT USERID, USERNAME " & vbLf & _
              "  FROM HAINSUSER " & vbLf
    strStmt = "SELECT USERID, USERNAME, DELFLG " & vbLf & _
              "  FROM HAINSUSER " & vbLf
'### 2004/1/8 Updated End
    
    '検索用文字列の設定（マスタメンテ用？）
    If IsMissing(vntSearchCode) = False Then
        If Trim(vntSearchCode) <> "" Then
            strStmt = strStmt & " WHERE USERID LIKE '%" & vntSearchCode & "%'" & vbLf
            blnWhereFlg = True
        End If
    End If
                                 
    If IsMissing(vntSearchString) = False Then
        If Trim(vntSearchString) <> "" Then
            If blnWhereFlg = False Then
                strStmt = strStmt & " WHERE USERNAME LIKE '%" & vntSearchString & "%'" & vbLf
            Else
                strStmt = strStmt & "   AND USERNAME LIKE '%" & vntSearchString & "%'" & vbLf
            End If
        End If
    End If
    
    strStmt = strStmt & vbLf & _
              " ORDER BY USERID"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objUserID = objFields("USERID")
        Set objUserName = objFields("USERNAME")
        Set objDelFlg = objFields("DELFLG")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrUserID(lngCount)
            ReDim Preserve vntArrUserName(lngCount)
            ReDim Preserve vntArrDelFlg(lngCount)
            vntArrUserID(lngCount) = objUserID.Value & ""
            vntArrUserName(lngCount) = objUserName.Value & ""
            vntArrDelFlg(lngCount) = objDelFlg.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntUserID = vntArrUserID
    vntUserName = vntArrUserName
    If IsMissing(vntDelFlg) = False Then vntDelFlg = vntArrDelFlg
    SelectUserList = lngCount
        
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "HainsUser.SelectUserList"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : ユーザ名を取得する
'
' 引数　　 : (In)     strUserId     ユーザＩＤ
' 　　　　 : (In)     vntDoctorFlg  判定医フラグ（省略可）
' 　　　　 : (Out)    vntUserName   ユーザ名（省略可）
'
' 戻り値　 : True     データあり
' 　　　　 : False    データなし
'
' 備考　　 : ユーザ名を省略可とすることで、入力チェックにも対応
'
Public Function SelectUserName(ByVal strUserID As String, _
                               Optional ByVal vntDoctorFlg As Variant, _
                               Optional ByRef vntUserName As Variant _
                              ) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objUserName         As OraField         'ユーザ名

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
'    objOraParam.Add "USERID", LCase(Trim(strUserID)), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2002.03.28 Modified 1Line by H.Ishihara@FSIT ID&PASSWORD 両方共UCASE
'    objOraParam.Add "USERID", Trim(strUserID), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "USERID", UCase(Trim(strUserID)), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2002.03.28 Modified End
'### 2003/11/22 Deleted by Ishihara@FSIT 聖路加未使用項目削除
'    If Not IsMissing(vntDoctorFlg) Then
'        objOraParam.Add "DOCTORFLG", Trim(vntDoctorFlg), ORAPARM_INPUT, ORATYPE_NUMBER
'    End If
    If Not IsMissing(vntDoctorFlg) Then
        Err.Raise 1000, , "SelectUserNameメソッドにて判定医フラグを使用してはいけません。ソースコードの見直しを行ってください。"
    End If
'### 2003/11/22 Deleted End
    
    '検索条件を満たすユーザテーブルのレコードを取得
    strStmt = "SELECT H.USERNAME                                        " & vbLf & _
              "  FROM HAINSUSER H                                       " & vbLf & _
              " WHERE H.USERID    = :USERID                             "
'### 2003/11/22 Deleted by Ishihara@FSIT 聖路加未使用項目削除
'    If Not IsMissing(vntDoctorFlg) Then
'        strStmt = strStmt & vbLf & _
'               "  AND H.DOCTORFLG = :DOCTORFLG                          "
'    End If
'### 2003/11/22 Deleted End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objUserName = objFields("USERNAME")

        If Not IsMissing(vntUserName) Then
            vntUserName = objUserName.Value
        End If
        
        SelectUserName = True
    Else
        If Not IsMissing(vntUserName) Then
            vntUserName = ""
        End If
    End If

    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "HainsUser.SelectUserName"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : ユーザテーブルレコードを登録する
'
' 引数　　 : (In)    strMode            登録モード
'                                       ("INS":挿入、"UPD":更新、"PWD"：パスワード変更)
' 　　　　   (In)    strUserID          ユーザＩＤ
' 　　　　   (In)    strUserName        ユーザ名
' 　　　　   (In)    strPassword        パスワード
' 　　　　   (In)    intAuthTblMnt      テーブルメンテナンス権限
' 　　　　   (In)    intAuthRsv         予約業務権限
' 　　　　   (In)    intAuthRsl         結果入力業務権限
' 　　　　   (In)    intAuthJud         判定入力業務権限
' 　　　　   (In)    intAuthPrn         印刷、データ抽出業務権限
' 　　　　   (In)    intAuthDmd         請求業務権限
' 　　　　   (In)    intDoctorFlg       判定医フラグ
' 　　　　   (In)    strKname           利用者カナ氏名
' 　　　　   (In)    strEname           利用者英字氏名
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'

'＃### 2005.04.04 Edit by 李

'Public Function RegistHainsUser(ByVal strMode As String, _
'                                ByVal strUserID As String, ByVal strUserName As String, ByVal strPassword As String, _
'                                Optional ByVal strDelFlg As String, _
'                                Optional ByVal intAuthTblMnt As Integer, _
'                                Optional ByVal intAuthRsv As Integer, _
'                                Optional ByVal intAuthRsl As Integer, _
'                                Optional ByVal intAuthJud As Integer, _
'                                Optional ByVal intAuthPrn As Integer, _
'                                Optional ByVal intAuthDmd As Integer, _
'                                Optional ByVal intAuthExt1 As Integer, _
'                                Optional ByVal intAuthExt2 As Integer, _
'                                Optional ByVal intAuthExt3 As Integer, _
'                                Optional ByVal intMenFlg As Integer, _
'                                Optional ByVal intHanFlg As Integer, _
'                                Optional ByVal intKanFlg As Integer, _
'                                Optional ByVal intEiFlg As Integer, _
'                                Optional ByVal intShinFlg As Integer, _
'                                Optional ByVal intNaiFlg As Integer, _
'                                Optional ByVal intIgnoreFlg As Integer, _
'                                Optional ByVal intAuthNote As Integer, _
'                                Optional ByVal strKname As String, _
'                                Optional ByVal strEname As String, _
'                                Optional ByVal strSentenceCd As String, _
'                                Optional ByVal strDefNoteDispKbn As String) As Long

'#### ユーザーグループ , 権限グループ 追加
Public Function RegistHainsUser(ByVal strMode As String, _
                                ByVal strUserID As String, ByVal strUserName As String, ByVal strPassword As String, _
                                Optional ByVal strDelFlg As String, _
                                Optional ByVal intAuthTblMnt As Integer, _
                                Optional ByVal intAuthRsv As Integer, _
                                Optional ByVal intAuthRsl As Integer, _
                                Optional ByVal intAuthJud As Integer, _
                                Optional ByVal intAuthPrn As Integer, _
                                Optional ByVal intAuthDmd As Integer, _
                                Optional ByVal intAuthExt1 As Integer, _
                                Optional ByVal intAuthExt2 As Integer, _
                                Optional ByVal intAuthExt3 As Integer, _
                                Optional ByVal intMenFlg As Integer, _
                                Optional ByVal intHanFlg As Integer, _
                                Optional ByVal intKanFlg As Integer, _
                                Optional ByVal intEiFlg As Integer, _
                                Optional ByVal intShinFlg As Integer, _
                                Optional ByVal intNaiFlg As Integer, _
                                Optional ByVal intIgnoreFlg As Integer, Optional ByVal intAuthNote As Integer, _
                                Optional ByVal strKname As String, Optional ByVal strEname As String, _
                                Optional ByVal strSentenceCd As String, Optional ByVal strDefNoteDispKbn As String, _
                                Optional ByVal strDeptGrpCd As String, _
                                Optional ByVal strUsrGrpCd As String) As Long


'エラーハンドラの設定
On Error GoTo ErrorHandle

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    Dim Ret                     As Long             '関数戻り値
    
    Dim strInsStringFields      As String           'InsertSQL用、列名定義文字列
    Dim strInsStringData        As String           'InsertSQL用、バインド変数名定義文字列
    Dim blnImportMode           As Boolean          'TRUE:インポートモード、FALSE:通常モード
    Dim strEncodePassword       As String           'エンコード後のパスワード
    
    Ret = INSERT_ERROR
    blnImportMode = False

    'パスワードをエンコード
    Call TBLIni
    strEncodePassword = SecretCodeMake(UCase(strPassword))
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "UserID", UCase(Trim(strUserID)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UserName", Trim(strUserName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "Password", Trim(strEncodePassword), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    objOraParam.Add "DelFlg", Trim(strDelFlg), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "AuthTblMnt", Trim(intAuthTblMnt), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "AuthRsv", Trim(intAuthRsv), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "AuthRsl", Trim(intAuthRsl), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "AuthJud", Trim(intAuthJud), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "AuthPrn", Trim(intAuthPrn), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "AuthDmd", Trim(intAuthDmd), ORAPARM_INPUT, ORATYPE_NUMBER

    objOraParam.Add "AuthExt1", Trim(intAuthExt1), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "AuthExt2", Trim(intAuthExt2), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "AuthExt3", Trim(intAuthExt3), ORAPARM_INPUT, ORATYPE_NUMBER
    
    objOraParam.Add "MenFlg", Trim(intMenFlg), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "HanFlg", Trim(intHanFlg), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "KanFlg", Trim(intKanFlg), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "EiFlg", Trim(intEiFlg), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ShinFlg", Trim(intShinFlg), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "NaiFlg", Trim(intNaiFlg), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    objOraParam.Add "IgnoreFlg", Trim(intIgnoreFlg), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "AuthNote", Trim(intAuthNote), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "Kname", Trim(strKname), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "Ename", Trim(strEname), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SentenceCd", Trim(strSentenceCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DefNoteDispKbn", Trim(strDefNoteDispKbn), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
' 2005.04.04 Add by 李
'#### ユーザーグループ , 権限グループ 追加
    objOraParam.Add "DeptCd", Trim(strDeptGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UsrGrpCd", Trim(strUsrGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
' 2005.04.04 Add End ...
    

    Do
        'パスワードのみの更新
        If strMode = "PWD" Then
'############ 2005.08.04 Add By 李：パスワード変更日追加 #####################################
'            strStmt = "UPDATE HAINSUSER SET PASSWORD = :PASSWORD WHERE USERID = :USERID"
            strStmt = " UPDATE HAINSUSER SET                " & vbCrLf & _
                      "         PASSWORD    = :PASSWORD,    " & vbCrLf & _
                      "         PWDSETDATE  = SYSDATE       " & vbCrLf & _
                      " WHERE USERID = :USERID              "
'############ 2005.08.04 Add By 李：パスワード変更日追加 #####################################
            Ret = mobjOraDb.ExecuteSQL(strStmt)
            
            If Ret > 0 Then
                Ret = INSERT_NORMAL
            End If
            Exit Do
        End If
        
        'ユーザテーブルレコードの更新
        If strMode = "UPD" Then
            strStmt = _
                "UPDATE HAINSUSER " & _
                "   SET USERNAME   = :USERNAME," & vbLf & _
                "       PASSWORD   = :PASSWORD," & vbLf & _
                "       DELFLG     = :DELFLG," & vbLf

            strStmt = strStmt & _
                " AUTHTBLMNT     = :AUTHTBLMNT    ," & _
                " AUTHRSV        = :AUTHRSV       ," & _
                " AUTHRSL        = :AUTHRSL       ," & _
                " AUTHJUD        = :AUTHJUD       ," & _
                " AUTHPRN        = :AUTHPRN       ," & _
                " AUTHDMD        = :AUTHDMD       ," & _
                " AUTHEXT1       = :AUTHEXT1      ," & _
                " AUTHEXT2       = :AUTHEXT2      ," & _
                " AUTHEXT3       = :AUTHEXT3      ,"


            ' 2005.04.04 Add by 李
            '#### ユーザーグループ , 権限グループ 追加
                strStmt = strStmt & _
                " DEPTCD         = :DEPTCD        ," & _
                " USRGRPCD       = :USRGRPCD      ,"
            ' 2005.04.04 Add End ...

            strStmt = strStmt & _
                " MENFLG         = :MENFLG        ," & _
                " HANFLG         = :HANFLG        ," & _
                " KANFLG         = :KANFLG        ," & _
                " EIFLG          = :EIFLG         ," & _
                " SHINFLG        = :SHINFLG       ," & _
                " IGNOREFLG      = :IGNOREFLG     ," & _
                " AUTHNOTE       = :AUTHNOTE      ," & _
                " KNAME          = :KNAME         ," & _
                " ENAME          = :ENAME         ," & _
                " SENTENCECD     = :SENTENCECD    ," & _
                " DEFNOTEDISPKBN = :DEFNOTEDISPKBN," & _
                " NAIFLG         = :NAIFLG        " & _
                " WHERE USERID   = :USERID"
            
            Ret = mobjOraDb.ExecuteSQL(strStmt)
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '通常モードの場合のみ、検索（インポートモードは既に読み込み済み）
        If blnImportMode = False Then
        
            '検索条件を満たすユーザテーブルのレコードを取得
            strStmt = "SELECT USERID FROM HAINSUSER WHERE USERID = :USERID"
            Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
                
            If Not objOraDyna.EOF Then
                Ret = INSERT_DUPLICATE
                Exit Do
            End If
        
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        strStmt = ""
        'Insert Field文字列作成
        
'''     2005.04.04 Edit by 李
'''     #### ユーザーグループ , 権限グループ 追加

'        strStmt = strStmt & " INSERT INTO HainsUser ( USERID, PASSWORD, DELFLG, AUTHTBLMNT, AUTHRSV, AUTHRSL, AUTHJUD, AUTHPRN, AUTHDMD, AUTHEXT1, AUTHEXT2, AUTHEXT3, MENFLG, HANFLG, KANFLG, EIFLG, SHINFLG, IGNOREFLG, AUTHNOTE, USERNAME, KNAME, ENAME, SENTENCECD, DEFNOTEDISPKBN, NAIFLG ) "
'        strStmt = strStmt & "                VALUES (:USERID, :PASSWORD, :DELFLG, :AUTHTBLMNT, :AUTHRSV, :AUTHRSL, :AUTHJUD, :AUTHPRN, :AUTHDMD, :AUTHEXT1, :AUTHEXT2, :AUTHEXT3, :MENFLG, :HANFLG, :KANFLG, :EIFLG, :SHINFLG, :IGNOREFLG, :AUTHNOTE, :USERNAME, :KNAME, :ENAME, :SENTENCECD, :DEFNOTEDISPKBN, :NAIFLG )"
                
        strStmt = strStmt & " INSERT INTO HainsUser ( USERID, PASSWORD, DELFLG, AUTHTBLMNT, AUTHRSV, AUTHRSL, AUTHJUD, AUTHPRN, AUTHDMD, "
        strStmt = strStmt & "                         AUTHEXT1, AUTHEXT2, AUTHEXT3, MENFLG, HANFLG, KANFLG, EIFLG, SHINFLG, IGNOREFLG,  "
        strStmt = strStmt & "                         AUTHNOTE, USERNAME, KNAME, ENAME, SENTENCECD, DEFNOTEDISPKBN, NAIFLG , DEPTCD, USRGRPCD, PWDSETDATE )   "
        
        strStmt = strStmt & "                VALUES (:USERID, :PASSWORD, :DELFLG, :AUTHTBLMNT, :AUTHRSV, :AUTHRSL, :AUTHJUD, :AUTHPRN, :AUTHDMD, "
        strStmt = strStmt & "                        :AUTHEXT1, :AUTHEXT2, :AUTHEXT3, :MENFLG, :HANFLG, :KANFLG, :EIFLG, :SHINFLG, :IGNOREFLG,  "
        strStmt = strStmt & "                        :AUTHNOTE, :USERNAME, :KNAME, :ENAME, :SENTENCECD, :DEFNOTEDISPKBN, :NAIFLG, :DEPTCD, :USRGRPCD, SYSDATE ) "
        
        
        '最終的な文字列をbuild
        mobjOraDb.ExecuteSQL strStmt
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    RegistHainsUser = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistHainsUser = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "HainsUser.RegistHainsUser"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function



'
''
'' 機能　　 : ユーザテーブルレコードを登録する
''
'' 引数　　 : (In)    strMode            登録モード
''                                       ("INS":挿入、"UPD":更新、"IMP":電カルユーザインポート、"PWD"：パスワード変更)
'' 　　　　   (In)    strUserID          ユーザＩＤ
'' 　　　　   (In)    strUserName        ユーザ名
'' 　　　　   (In)    strPassword        パスワード
'' 　　　　   (In)    intAuthTblMnt      テーブルメンテナンス権限
'' 　　　　   (In)    intAuthRsv         予約業務権限
'' 　　　　   (In)    intAuthRsl         結果入力業務権限
'' 　　　　   (In)    intAuthJud         判定入力業務権限
'' 　　　　   (In)    intAuthPrn         印刷、データ抽出業務権限
'' 　　　　   (In)    intAuthDmd         請求業務権限
'' 　　　　   (In)    intDoctorFlg       判定医フラグ
'' 　　　　   (In)    strKname           利用者カナ氏名
'' 　　　　   (In)    strEname           利用者英字氏名
''
'' 戻り値　 : INSERT_NORMAL     正常終了
'' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
'' 　　　　   INSERT_ERROR      異常終了
''
'' 備考　　 :
''
'Public Function RegistHainsUser(ByVal strMode As String, ByVal strUserID As String, ByVal strUserName As String, ByVal strPassword As String, _
'                                Optional ByVal intAuthTblMnt As Integer, Optional ByVal intAuthRsv As Integer, Optional ByVal intAuthRsl As Integer, Optional ByVal intAuthJud As Integer, _
'                                Optional ByVal intAuthPrn As Integer, Optional ByVal intAuthDmd As Integer, Optional ByVal intDoctorFlg As Integer, Optional ByVal strKname As String, Optional ByVal strEname As String, _
'                                Optional ByVal vntbirth As Variant, Optional ByVal vntsex As Variant, Optional ByVal vntemail As Variant, Optional ByVal vntpocketbell As Variant, _
'                                Optional ByVal vntshokuKbn As Variant, Optional ByVal vntngKbn As Variant, Optional ByVal vntiraikbn As Variant, Optional ByVal vntTNT1KA As Variant, _
'                                Optional ByVal vntTNT1BT As Variant, Optional ByVal vntTNT1RM As Variant, Optional ByVal vntTNT1SY As Variant, Optional ByVal vntTNT1ST As Variant, _
'                                Optional ByVal vntTNT1ED As Variant, Optional ByVal vntTNT2KA As Variant, Optional ByVal vntTNT2BT As Variant, Optional ByVal vntTNT2RM As Variant, _
'                                Optional ByVal vntTNT2SY As Variant, Optional ByVal vntTNT2ST As Variant, Optional ByVal vntTNT2ED As Variant, Optional ByVal vntTNT3KA As Variant, _
'                                Optional ByVal vntTNT3BT As Variant, Optional ByVal vntTNT3RM As Variant, Optional ByVal vntTNT3SY As Variant, Optional ByVal vntTNT3ST As Variant, _
'                                Optional ByVal vntTNT3ED As Variant, Optional ByVal vntTNT4KA As Variant, Optional ByVal vntTNT4BT As Variant, Optional ByVal vntTNT4RM As Variant, _
'                                Optional ByVal vntTNT4SY As Variant, Optional ByVal vntTNT4ST As Variant, Optional ByVal vntTNT4ED As Variant, Optional ByVal vntTNT5KA As Variant, _
'                                Optional ByVal vntTNT5BT As Variant, Optional ByVal vntTNT5RM As Variant, Optional ByVal vntTNT5SY As Variant, Optional ByVal vntTNT5ST As Variant, _
'                                Optional ByVal vntTNT5ED As Variant, Optional ByVal vntYUKOST As Variant, Optional ByVal vntYUKOED As Variant, Optional ByVal vntPASSYUKOED As Variant, _
'                                Optional ByVal vntUPDYMD As Variant, Optional ByVal vntCRTYMD As Variant, Optional ByVal vntSTPFLG As Variant) As Long
'
''エラーハンドラの設定
'On Error GoTo ErrorHandle
'
'    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
'    Dim objOraDyna              As OraDynaset       'ダイナセット
'    Dim strStmt                 As String           'SQLステートメント
'    Dim Ret                     As Long             '関数戻り値
'
'    Dim strInsStringFields      As String           'InsertSQL用、列名定義文字列
'    Dim strInsStringData        As String           'InsertSQL用、バインド変数名定義文字列
'    Dim blnImportMode           As Boolean          'TRUE:インポートモード、FALSE:通常モード
'
''## 2002.03.14 Add 4Lines by T.Takagi@FSIT
'    Dim strEncodePassword       As String           'エンコード後のパスワード
'
'    '電カルからの取り込み以外は引数のパスワードをエンコード
'    If strMode <> "IMP" Then
'        Call TBLIni
''## 2002.03.28 Modified 1Line by H.Ishihara@FSIT ID&PASSWORD 両方共UCASE
''        strEncodePassword = SecretCodeMake(strPassword)
'        strEncodePassword = SecretCodeMake(UCase(strPassword))
''## 2002.03.28 Modified End
'    Else
'        strEncodePassword = strPassword
'    End If
''## 2002.03.14 Add End
'
'    Ret = INSERT_ERROR
'    blnImportMode = False
'
'    'キー及び更新値の設定
'    Set objOraParam = mobjOraDb.Parameters
''## 2002.03.30 Modified 1Line by H.Ishihara@FSIT ID&PASSWORD 両方共UCASE
'    objOraParam.Add "UserID", UCase(Trim(strUserID)), ORAPARM_INPUT, ORATYPE_VARCHAR2
''## 2002.03.28 Modified End
'    objOraParam.Add "UserName", Trim(strUserName), ORAPARM_INPUT, ORATYPE_VARCHAR2
''## 2002.03.14 Mod 2Lines by T.Takagi@FSIT
''    objOraParam.Add "Password", Trim(strPassword), ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "Password", Trim(strEncodePassword), ORAPARM_INPUT, ORATYPE_VARCHAR2
''## 2002.03.14 Mod End
'    objOraParam.Add "AuthTblMnt", Trim(intAuthTblMnt), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "AuthRsv", Trim(intAuthRsv), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "AuthRsl", Trim(intAuthRsl), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "AuthJud", Trim(intAuthJud), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "AuthPrn", Trim(intAuthPrn), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "AuthDmd", Trim(intAuthDmd), ORAPARM_INPUT, ORATYPE_NUMBER
''### 2003/11/22 Deleted by Ishihara@FSIT 聖路加未使用項目削除
''    objOraParam.Add "DoctorFlg", Trim(intDoctorFlg), ORAPARM_INPUT, ORATYPE_NUMBER
''### 2003/11/22 Deleted End
'    objOraParam.Add "Kname", Trim(strKname), ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "Ename", Trim(strEname), ORAPARM_INPUT, ORATYPE_VARCHAR2
'
''### 2003/11/22 Deleted by Ishihara@FSIT 聖路加未使用項目削除
''    If IsMissing(vntbirth) = False Then
''        If Trim(vntbirth) = "" Then
''            objOraParam.Add "BIRTH", Null, ORAPARM_INPUT, ORATYPE_DATE
''        Else
''            objOraParam.Add "BIRTH", CDate(vntbirth), ORAPARM_INPUT, ORATYPE_DATE
''        End If
''    End If
''
''    If IsMissing(vntsex) = False Then objOraParam.Add "SEX", CInt(vntsex), ORAPARM_INPUT, ORATYPE_NUMBER
''    If IsMissing(vntemail) = False Then objOraParam.Add "EMAIL", Trim(vntemail), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntpocketbell) = False Then objOraParam.Add "POCKETBELL", Trim(vntpocketbell), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntshokuKbn) = False Then objOraParam.Add "SHOKUKBN", Trim(vntshokuKbn), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntngKbn) = False Then objOraParam.Add "NGKBN", Trim(vntngKbn), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntiraikbn) = False Then objOraParam.Add "IRAIKBN", Trim(vntiraikbn), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT1KA) = False Then objOraParam.Add "TNT1KA", Trim(vntTNT1KA), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT1BT) = False Then objOraParam.Add "TNT1BT", Trim(vntTNT1BT), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT1RM) = False Then objOraParam.Add "TNT1RM", Trim(vntTNT1RM), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT1SY) = False Then objOraParam.Add "TNT1SY", Trim(vntTNT1SY), ORAPARM_INPUT, ORATYPE_VARCHAR2
''
''    If IsMissing(vntTNT1ST) = False Then
''        If Trim(vntTNT1ST) = "" Then
''            objOraParam.Add "TNT1ST", Null, ORAPARM_INPUT, ORATYPE_DATE
''        Else
''            objOraParam.Add "TNT1ST", CDate(vntTNT1ST), ORAPARM_INPUT, ORATYPE_DATE
''        End If
''    End If
''
''    If IsMissing(vntTNT1ED) = False Then
''        If Trim(vntTNT1ED) = "" Then
''            objOraParam.Add "TNT1ED", Null, ORAPARM_INPUT, ORATYPE_DATE
''        Else
''            objOraParam.Add "TNT1ED", CDate(vntTNT1ED), ORAPARM_INPUT, ORATYPE_DATE
''        End If
''    End If
''
''    If IsMissing(vntTNT2KA) = False Then objOraParam.Add "TNT2KA", Trim(vntTNT2KA), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT2BT) = False Then objOraParam.Add "TNT2BT", Trim(vntTNT2BT), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT2RM) = False Then objOraParam.Add "TNT2RM", Trim(vntTNT2RM), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT2SY) = False Then objOraParam.Add "TNT2SY", Trim(vntTNT2SY), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT2ST) = False Then
''        If Trim(vntTNT2ST) = "" Then
''            objOraParam.Add "TNT2ST", Null, ORAPARM_INPUT, ORATYPE_DATE
''        Else
''            objOraParam.Add "TNT2ST", CDate(vntTNT2ST), ORAPARM_INPUT, ORATYPE_DATE
''        End If
''    End If
''
''    If IsMissing(vntTNT2ED) = False Then
''        If Trim(vntTNT2ED) = "" Then
''            objOraParam.Add "TNT2ED", Null, ORAPARM_INPUT, ORATYPE_DATE
''        Else
''            objOraParam.Add "TNT2ED", CDate(vntTNT2ED), ORAPARM_INPUT, ORATYPE_DATE
''        End If
''    End If
''
''    If IsMissing(vntTNT3KA) = False Then objOraParam.Add "TNT3KA", Trim(vntTNT3KA), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT3BT) = False Then objOraParam.Add "TNT3BT", Trim(vntTNT3BT), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT3RM) = False Then objOraParam.Add "TNT3RM", Trim(vntTNT3RM), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT3SY) = False Then objOraParam.Add "TNT3SY", Trim(vntTNT3SY), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT3ST) = False Then
''        If Trim(vntTNT3ST) = "" Then
''            objOraParam.Add "TNT3ST", Null, ORAPARM_INPUT, ORATYPE_DATE
''        Else
''            objOraParam.Add "TNT3ST", CDate(vntTNT3ST), ORAPARM_INPUT, ORATYPE_DATE
''        End If
''    End If
''
''    If IsMissing(vntTNT3ED) = False Then
''        If Trim(vntTNT3ED) = "" Then
''            objOraParam.Add "TNT3ED", Null, ORAPARM_INPUT, ORATYPE_DATE
''        Else
''            objOraParam.Add "TNT3ED", CDate(vntTNT3ED), ORAPARM_INPUT, ORATYPE_DATE
''        End If
''    End If
''
''    If IsMissing(vntTNT4KA) = False Then objOraParam.Add "TNT4KA", Trim(vntTNT4KA), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT4BT) = False Then objOraParam.Add "TNT4BT", Trim(vntTNT4BT), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT4RM) = False Then objOraParam.Add "TNT4RM", Trim(vntTNT4RM), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT4SY) = False Then objOraParam.Add "TNT4SY", Trim(vntTNT4SY), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT4ST) = False Then
''        If Trim(vntTNT4ST) = "" Then
''            objOraParam.Add "TNT4ST", Null, ORAPARM_INPUT, ORATYPE_DATE
''        Else
''            objOraParam.Add "TNT4ST", CDate(vntTNT4ST), ORAPARM_INPUT, ORATYPE_DATE
''        End If
''    End If
''
''    If IsMissing(vntTNT4ED) = False Then
''        If Trim(vntTNT4ED) = "" Then
''            objOraParam.Add "TNT4ED", Null, ORAPARM_INPUT, ORATYPE_DATE
''        Else
''            objOraParam.Add "TNT4ED", CDate(vntTNT4ED), ORAPARM_INPUT, ORATYPE_DATE
''        End If
''    End If
''
''    If IsMissing(vntTNT5KA) = False Then objOraParam.Add "TNT5KA", Trim(vntTNT5KA), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT5BT) = False Then objOraParam.Add "TNT5BT", Trim(vntTNT5BT), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT5RM) = False Then objOraParam.Add "TNT5RM", Trim(vntTNT5RM), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT5SY) = False Then objOraParam.Add "TNT5SY", Trim(vntTNT5SY), ORAPARM_INPUT, ORATYPE_VARCHAR2
''    If IsMissing(vntTNT5ST) = False Then
''        If Trim(vntTNT5ST) = "" Then
''            objOraParam.Add "TNT5ST", Null, ORAPARM_INPUT, ORATYPE_DATE
''        Else
''            objOraParam.Add "TNT5ST", CDate(vntTNT5ST), ORAPARM_INPUT, ORATYPE_DATE
''        End If
''    End If
''
''    If IsMissing(vntTNT5ED) = False Then
''        If Trim(vntTNT5ED) = "" Then
''            objOraParam.Add "TNT5ED", Null, ORAPARM_INPUT, ORATYPE_DATE
''        Else
''            objOraParam.Add "TNT5ED", CDate(vntTNT5ED), ORAPARM_INPUT, ORATYPE_DATE
''        End If
''    End If
''
''    If IsMissing(vntYUKOST) = False Then
''        If Trim(vntYUKOST) = "" Then
''            objOraParam.Add "YUKOST", Null, ORAPARM_INPUT, ORATYPE_DATE
''        Else
''            objOraParam.Add "YUKOST", CDate(vntYUKOST), ORAPARM_INPUT, ORATYPE_DATE
''        End If
''    End If
''
''    If IsMissing(vntYUKOED) = False Then
''        If Trim(vntYUKOED) = "" Then
''            objOraParam.Add "YUKOED", Null, ORAPARM_INPUT, ORATYPE_DATE
''        Else
''            objOraParam.Add "YUKOED", CDate(vntYUKOED), ORAPARM_INPUT, ORATYPE_DATE
''        End If
''    End If
''
''    If IsMissing(vntPASSYUKOED) = False Then
''        If Trim(vntPASSYUKOED) = "" Then
''            objOraParam.Add "PASSYUKOED", Null, ORAPARM_INPUT, ORATYPE_DATE
''        Else
''            objOraParam.Add "PASSYUKOED", CDate(vntPASSYUKOED), ORAPARM_INPUT, ORATYPE_DATE
''        End If
''    End If
''
''    If IsMissing(vntUPDYMD) = False Then
''        If Trim(vntUPDYMD) = "" Then
''            objOraParam.Add "UPDYMD", Null, ORAPARM_INPUT, ORATYPE_DATE
''        Else
''            objOraParam.Add "UPDYMD", CDate(vntUPDYMD), ORAPARM_INPUT, ORATYPE_DATE
''        End If
''    End If
''    If IsMissing(vntCRTYMD) = False Then
''        If Trim(vntCRTYMD) = "" Then
''            objOraParam.Add "CRTYMD", Null, ORAPARM_INPUT, ORATYPE_DATE
''        Else
''            objOraParam.Add "CRTYMD", CDate(vntCRTYMD), ORAPARM_INPUT, ORATYPE_DATE
''        End If
''    End If
''
''    If IsMissing(vntSTPFLG) = False Then objOraParam.Add "STPFLG", Trim(vntSTPFLG), ORAPARM_INPUT, ORATYPE_VARCHAR2
''### 2003/11/22 Deleted End
'
'    '電カルユーザインポートモードの場合、先にセレクトしてモード設定
'    If strMode = "IMP" Then
'
'        blnImportMode = True
'
'        '検索条件を満たすユーザテーブルのレコードを取得
'        strStmt = "SELECT USERID FROM HAINSUSER WHERE USERID = :USERID"
'        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
'
'        If objOraDyna.EOF Then
'            strMode = "INS"
'        Else
'            strMode = "UPD"
'        End If
'
'    End If
'
'    Do
'        'パスワードのみの更新
'        If strMode = "PWD" Then
'            strStmt = "UPDATE HAINSUSER SET PASSWORD = :PASSWORD WHERE USERID = :USERID"
'            Ret = mobjOraDb.ExecuteSQL(strStmt)
'            If Ret > 0 Then
'                Ret = INSERT_NORMAL
'            End If
'            Exit Do
'        End If
'
'        'ユーザテーブルレコードの更新
'        If strMode = "UPD" Then
'            strStmt = "UPDATE HAINSUSER " & _
'                      "   SET USERNAME   = :USERNAME," & _
'                      "       PASSWORD   = :PASSWORD,"
'
'            If blnImportMode = False Then
'
'                '電カルユーザインポートモードの以外場合、HainsUser権限を更新する
''## 2003.11.25 Mod by T.Takagi@FSIT 聖路加未使用項目削除
''                strStmt = strStmt & _
''                          "       AUTHTBLMNT = :AUTHTBLMNT," & _
''                          "       AUTHRSV    = :AUTHRSV," & _
''                          "       AUTHRSL    = :AUTHRSL," & _
''                          "       AUTHJUD    = :AUTHJUD," & _
''                          "       AUTHPRN    = :AUTHPRN," & _
''                          "       AUTHDMD    = :AUTHDMD," & _
''                          "       DOCTORFLG  = :DOCTORFLG,"
'                strStmt = strStmt & _
'                          "       AUTHTBLMNT = :AUTHTBLMNT," & _
'                          "       AUTHRSV    = :AUTHRSV," & _
'                          "       AUTHRSL    = :AUTHRSL," & _
'                          "       AUTHJUD    = :AUTHJUD," & _
'                          "       AUTHPRN    = :AUTHPRN," & _
'                          "       AUTHDMD    = :AUTHDMD,"
''## 2003.11.25 Mod End
'
'            End If
'
'            strStmt = strStmt & _
'                      "       KNAME      = :KNAME," & _
'                      "       ENAME      = :ENAME"
'
''### 2003/11/22 Deleted by Ishihara@FSIT 聖路加未使用項目削除
''            '電カル連携ユーザ情報を必要に応じてセット
''            If IsMissing(vntbirth) = False Then strStmt = strStmt & "      ,BIRTH       = :BIRTH"
''            If IsMissing(vntsex) = False Then strStmt = strStmt & "        ,SEX         = :SEX"
''            If IsMissing(vntemail) = False Then strStmt = strStmt & "      ,EMAIL       = :EMAIL"
''            If IsMissing(vntpocketbell) = False Then strStmt = strStmt & " ,POCKETBELL  = :POCKETBELL"
''            If IsMissing(vntshokuKbn) = False Then strStmt = strStmt & "   ,SHOKUKBN    = :SHOKUKBN"
''            If IsMissing(vntngKbn) = False Then strStmt = strStmt & "      ,NGKBN       = :NGKBN"
''            If IsMissing(vntiraikbn) = False Then strStmt = strStmt & "    ,IRAIKBN     = :IRAIKBN"
''            If IsMissing(vntTNT1KA) = False Then strStmt = strStmt & "     ,TNT1KA      = :TNT1KA"
''            If IsMissing(vntTNT1BT) = False Then strStmt = strStmt & "     ,TNT1BT      = :TNT1BT"
''            If IsMissing(vntTNT1RM) = False Then strStmt = strStmt & "     ,TNT1RM      = :TNT1RM"
''            If IsMissing(vntTNT1SY) = False Then strStmt = strStmt & "     ,TNT1SY      = :TNT1SY"
''            If IsMissing(vntTNT1ST) = False Then strStmt = strStmt & "     ,TNT1ST      = :TNT1ST"
''            If IsMissing(vntTNT1ED) = False Then strStmt = strStmt & "     ,TNT1ED      = :TNT1ED"
''            If IsMissing(vntTNT2KA) = False Then strStmt = strStmt & "     ,TNT2KA      = :TNT2KA"
''            If IsMissing(vntTNT2BT) = False Then strStmt = strStmt & "     ,TNT2BT      = :TNT2BT"
''            If IsMissing(vntTNT2RM) = False Then strStmt = strStmt & "     ,TNT2RM      = :TNT2RM"
''            If IsMissing(vntTNT2SY) = False Then strStmt = strStmt & "     ,TNT2SY      = :TNT2SY"
''            If IsMissing(vntTNT2ST) = False Then strStmt = strStmt & "     ,TNT2ST      = :TNT2ST"
''            If IsMissing(vntTNT2ED) = False Then strStmt = strStmt & "     ,TNT2ED      = :TNT2ED"
''            If IsMissing(vntTNT3KA) = False Then strStmt = strStmt & "     ,TNT3KA      = :TNT3KA"
''            If IsMissing(vntTNT3BT) = False Then strStmt = strStmt & "     ,TNT3BT      = :TNT3BT"
''            If IsMissing(vntTNT3RM) = False Then strStmt = strStmt & "     ,TNT3RM      = :TNT3RM"
''            If IsMissing(vntTNT3SY) = False Then strStmt = strStmt & "     ,TNT3SY      = :TNT3SY"
''            If IsMissing(vntTNT3ST) = False Then strStmt = strStmt & "     ,TNT3ST      = :TNT3ST"
''            If IsMissing(vntTNT3ED) = False Then strStmt = strStmt & "     ,TNT3ED      = :TNT3ED"
''            If IsMissing(vntTNT4KA) = False Then strStmt = strStmt & "     ,TNT4KA      = :TNT4KA"
''            If IsMissing(vntTNT4BT) = False Then strStmt = strStmt & "     ,TNT4BT      = :TNT4BT"
''            If IsMissing(vntTNT4RM) = False Then strStmt = strStmt & "     ,TNT4RM      = :TNT4RM"
''            If IsMissing(vntTNT4SY) = False Then strStmt = strStmt & "     ,TNT4SY      = :TNT4SY"
''            If IsMissing(vntTNT4ST) = False Then strStmt = strStmt & "     ,TNT4ST      = :TNT4ST"
''            If IsMissing(vntTNT4ED) = False Then strStmt = strStmt & "     ,TNT4ED      = :TNT4ED"
''            If IsMissing(vntTNT5KA) = False Then strStmt = strStmt & "     ,TNT5KA      = :TNT5KA"
''            If IsMissing(vntTNT5BT) = False Then strStmt = strStmt & "     ,TNT5BT      = :TNT5BT"
''            If IsMissing(vntTNT5RM) = False Then strStmt = strStmt & "     ,TNT5RM      = :TNT5RM"
''            If IsMissing(vntTNT5SY) = False Then strStmt = strStmt & "     ,TNT5SY      = :TNT5SY"
''            If IsMissing(vntTNT5ST) = False Then strStmt = strStmt & "     ,TNT5ST      = :TNT5ST"
''            If IsMissing(vntTNT5ED) = False Then strStmt = strStmt & "     ,TNT5ED      = :TNT5ED"
''            If IsMissing(vntYUKOST) = False Then strStmt = strStmt & "     ,YUKOST      = :YUKOST"
''            If IsMissing(vntYUKOED) = False Then strStmt = strStmt & "     ,YUKOED      = :YUKOED"
''            If IsMissing(vntPASSYUKOED) = False Then strStmt = strStmt & " ,PASSYUKOED  = :PASSYUKOED"
''            If IsMissing(vntUPDYMD) = False Then strStmt = strStmt & "     ,UPDYMD      = :UPDYMD"
''            If IsMissing(vntCRTYMD) = False Then strStmt = strStmt & "     ,CRTYMD      = :CRTYMD"
''            If IsMissing(vntSTPFLG) = False Then strStmt = strStmt & "     ,STPFLG      = :STPFLG"
''### 2003/11/22 Deleted End
'
'            strStmt = strStmt & _
'                      " WHERE USERID     = :USERID"
'
'            Ret = mobjOraDb.ExecuteSQL(strStmt)
'            If Ret > 0 Then
'                Ret = INSERT_NORMAL
'                Exit Do
'            End If
'        End If
'
'        '通常モードの場合のみ、検索（インポートモードは既に読み込み済み）
'        If blnImportMode = False Then
'
'            '検索条件を満たすユーザテーブルのレコードを取得
'            strStmt = "SELECT USERID FROM HAINSUSER WHERE USERID = :USERID"
'            Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
'
'            If Not objOraDyna.EOF Then
'                Ret = INSERT_DUPLICATE
'                Exit Do
'            End If
'
'        End If
'
'        '更新モードでない場合、または更新レコードがない場合は挿入を行う
'        strStmt = ""
''        strStmt = strStmt & "INSERT INTO HainsUser ( USERID, PASSWORD, AUTHTBLMNT, AUTHRSV, AUTHRSL, AUTHJUD, AUTHPRN, AUTHDMD, DOCTORFLG, USERNAME, KNAME, ENAME)"
''        strStmt = strStmt & "               VALUES (:USERID,:PASSWORD,:AUTHTBLMNT,:AUTHRSV,:AUTHRSL,:AUTHJUD,:AUTHPRN,:AUTHDMD,:DOCTORFLG,:USERNAME,:KNAME,:ENAME)"
'
'
''    Dim strInsStringFields      As String           'InsertSQL用、列名定義文字列
''    Dim strInsStringData        As String           'InsertSQL用、バインド変数名定義文字列
'
'        'Insert Field文字列作成
''## 2003.11.25 Mod by T.Takagi@FSIT 聖路加未使用項目削除
''        strInsStringFields = "INSERT INTO HainsUser ( USERID, PASSWORD, AUTHTBLMNT, AUTHRSV, AUTHRSL, AUTHJUD, AUTHPRN, AUTHDMD, DOCTORFLG, USERNAME, KNAME, ENAME"
'        strInsStringFields = "INSERT INTO HainsUser ( USERID, PASSWORD, AUTHTBLMNT, AUTHRSV, AUTHRSL, AUTHJUD, AUTHPRN, AUTHDMD, USERNAME, KNAME, ENAME"
''## 2003.11.25 Mod End
'
''### 2003/11/22 Deleted by Ishihara@FSIT 聖路加未使用項目削除
''        If IsMissing(vntbirth) = False Then strInsStringFields = strInsStringFields & "      ,BIRTH     "
''        If IsMissing(vntsex) = False Then strInsStringFields = strInsStringFields & "        ,SEX       "
''        If IsMissing(vntemail) = False Then strInsStringFields = strInsStringFields & "      ,EMAIL     "
''        If IsMissing(vntpocketbell) = False Then strInsStringFields = strInsStringFields & " ,POCKETBELL"
''        If IsMissing(vntshokuKbn) = False Then strInsStringFields = strInsStringFields & "   ,SHOKUKBN  "
''        If IsMissing(vntngKbn) = False Then strInsStringFields = strInsStringFields & "      ,NGKBN     "
''        If IsMissing(vntiraikbn) = False Then strInsStringFields = strInsStringFields & "    ,IRAIKBN   "
''        If IsMissing(vntTNT1KA) = False Then strInsStringFields = strInsStringFields & "     ,TNT1KA    "
''        If IsMissing(vntTNT1BT) = False Then strInsStringFields = strInsStringFields & "     ,TNT1BT    "
''        If IsMissing(vntTNT1RM) = False Then strInsStringFields = strInsStringFields & "     ,TNT1RM    "
''        If IsMissing(vntTNT1SY) = False Then strInsStringFields = strInsStringFields & "     ,TNT1SY    "
''        If IsMissing(vntTNT1ST) = False Then strInsStringFields = strInsStringFields & "     ,TNT1ST    "
''        If IsMissing(vntTNT1ED) = False Then strInsStringFields = strInsStringFields & "     ,TNT1ED    "
''        If IsMissing(vntTNT2KA) = False Then strInsStringFields = strInsStringFields & "     ,TNT2KA    "
''        If IsMissing(vntTNT2BT) = False Then strInsStringFields = strInsStringFields & "     ,TNT2BT    "
''        If IsMissing(vntTNT2RM) = False Then strInsStringFields = strInsStringFields & "     ,TNT2RM    "
''        If IsMissing(vntTNT2SY) = False Then strInsStringFields = strInsStringFields & "     ,TNT2SY    "
''        If IsMissing(vntTNT2ST) = False Then strInsStringFields = strInsStringFields & "     ,TNT2ST    "
''        If IsMissing(vntTNT2ED) = False Then strInsStringFields = strInsStringFields & "     ,TNT2ED    "
''        If IsMissing(vntTNT3KA) = False Then strInsStringFields = strInsStringFields & "     ,TNT3KA    "
''        If IsMissing(vntTNT3BT) = False Then strInsStringFields = strInsStringFields & "     ,TNT3BT    "
''        If IsMissing(vntTNT3RM) = False Then strInsStringFields = strInsStringFields & "     ,TNT3RM    "
''        If IsMissing(vntTNT3SY) = False Then strInsStringFields = strInsStringFields & "     ,TNT3SY    "
''        If IsMissing(vntTNT3ST) = False Then strInsStringFields = strInsStringFields & "     ,TNT3ST    "
''        If IsMissing(vntTNT3ED) = False Then strInsStringFields = strInsStringFields & "     ,TNT3ED    "
''        If IsMissing(vntTNT4KA) = False Then strInsStringFields = strInsStringFields & "     ,TNT4KA    "
''        If IsMissing(vntTNT4BT) = False Then strInsStringFields = strInsStringFields & "     ,TNT4BT    "
''        If IsMissing(vntTNT4RM) = False Then strInsStringFields = strInsStringFields & "     ,TNT4RM    "
''        If IsMissing(vntTNT4SY) = False Then strInsStringFields = strInsStringFields & "     ,TNT4SY    "
''        If IsMissing(vntTNT4ST) = False Then strInsStringFields = strInsStringFields & "     ,TNT4ST    "
''        If IsMissing(vntTNT4ED) = False Then strInsStringFields = strInsStringFields & "     ,TNT4ED    "
''        If IsMissing(vntTNT5KA) = False Then strInsStringFields = strInsStringFields & "     ,TNT5KA    "
''        If IsMissing(vntTNT5BT) = False Then strInsStringFields = strInsStringFields & "     ,TNT5BT    "
''        If IsMissing(vntTNT5RM) = False Then strInsStringFields = strInsStringFields & "     ,TNT5RM    "
''        If IsMissing(vntTNT5SY) = False Then strInsStringFields = strInsStringFields & "     ,TNT5SY    "
''        If IsMissing(vntTNT5ST) = False Then strInsStringFields = strInsStringFields & "     ,TNT5ST    "
''        If IsMissing(vntTNT5ED) = False Then strInsStringFields = strInsStringFields & "     ,TNT5ED    "
''        If IsMissing(vntYUKOST) = False Then strInsStringFields = strInsStringFields & "     ,YUKOST    "
''        If IsMissing(vntYUKOED) = False Then strInsStringFields = strInsStringFields & "     ,YUKOED    "
''        If IsMissing(vntPASSYUKOED) = False Then strInsStringFields = strInsStringFields & " ,PASSYUKOED"
''        If IsMissing(vntUPDYMD) = False Then strInsStringFields = strInsStringFields & "     ,UPDYMD    "
''        If IsMissing(vntCRTYMD) = False Then strInsStringFields = strInsStringFields & "     ,CRTYMD    "
''        If IsMissing(vntSTPFLG) = False Then strInsStringFields = strInsStringFields & "     ,STPFLG    "
''### 2003/11/22 Deleted End
'        strInsStringFields = strInsStringFields & ")"
'
''## 2003.11.25 Mod by T.Takagi@FSIT 聖路加未使用項目削除
''        strInsStringData = "                 VALUES (:USERID,:PASSWORD,:AUTHTBLMNT,:AUTHRSV,:AUTHRSL,:AUTHJUD,:AUTHPRN,:AUTHDMD,:DOCTORFLG,:USERNAME,:KNAME,:ENAME"
'        strInsStringData = "                 VALUES (:USERID,:PASSWORD,:AUTHTBLMNT,:AUTHRSV,:AUTHRSL,:AUTHJUD,:AUTHPRN,:AUTHDMD,:USERNAME,:KNAME,:ENAME"
''## 2003.11.25 Mod End
'
''### 2003/11/22 Deleted by Ishihara@FSIT 聖路加未使用項目削除
''        If IsMissing(vntbirth) = False Then strInsStringData = strInsStringData & "      ,:BIRTH     "
''        If IsMissing(vntsex) = False Then strInsStringData = strInsStringData & "        ,:SEX       "
''        If IsMissing(vntemail) = False Then strInsStringData = strInsStringData & "      ,:EMAIL     "
''        If IsMissing(vntpocketbell) = False Then strInsStringData = strInsStringData & " ,:POCKETBELL"
''        If IsMissing(vntshokuKbn) = False Then strInsStringData = strInsStringData & "   ,:SHOKUKBN  "
''        If IsMissing(vntngKbn) = False Then strInsStringData = strInsStringData & "      ,:NGKBN     "
''        If IsMissing(vntiraikbn) = False Then strInsStringData = strInsStringData & "    ,:IRAIKBN   "
''        If IsMissing(vntTNT1KA) = False Then strInsStringData = strInsStringData & "     ,:TNT1KA    "
''        If IsMissing(vntTNT1BT) = False Then strInsStringData = strInsStringData & "     ,:TNT1BT    "
''        If IsMissing(vntTNT1RM) = False Then strInsStringData = strInsStringData & "     ,:TNT1RM    "
''        If IsMissing(vntTNT1SY) = False Then strInsStringData = strInsStringData & "     ,:TNT1SY    "
''        If IsMissing(vntTNT1ST) = False Then strInsStringData = strInsStringData & "     ,:TNT1ST    "
''        If IsMissing(vntTNT1ED) = False Then strInsStringData = strInsStringData & "     ,:TNT1ED    "
''        If IsMissing(vntTNT2KA) = False Then strInsStringData = strInsStringData & "     ,:TNT2KA    "
''        If IsMissing(vntTNT2BT) = False Then strInsStringData = strInsStringData & "     ,:TNT2BT    "
''        If IsMissing(vntTNT2RM) = False Then strInsStringData = strInsStringData & "     ,:TNT2RM    "
''        If IsMissing(vntTNT2SY) = False Then strInsStringData = strInsStringData & "     ,:TNT2SY    "
''        If IsMissing(vntTNT2ST) = False Then strInsStringData = strInsStringData & "     ,:TNT2ST    "
''        If IsMissing(vntTNT2ED) = False Then strInsStringData = strInsStringData & "     ,:TNT2ED    "
''        If IsMissing(vntTNT3KA) = False Then strInsStringData = strInsStringData & "     ,:TNT3KA    "
''        If IsMissing(vntTNT3BT) = False Then strInsStringData = strInsStringData & "     ,:TNT3BT    "
''        If IsMissing(vntTNT3RM) = False Then strInsStringData = strInsStringData & "     ,:TNT3RM    "
''        If IsMissing(vntTNT3SY) = False Then strInsStringData = strInsStringData & "     ,:TNT3SY    "
''        If IsMissing(vntTNT3ST) = False Then strInsStringData = strInsStringData & "     ,:TNT3ST    "
''        If IsMissing(vntTNT3ED) = False Then strInsStringData = strInsStringData & "     ,:TNT3ED    "
''        If IsMissing(vntTNT4KA) = False Then strInsStringData = strInsStringData & "     ,:TNT4KA    "
''        If IsMissing(vntTNT4BT) = False Then strInsStringData = strInsStringData & "     ,:TNT4BT    "
''        If IsMissing(vntTNT4RM) = False Then strInsStringData = strInsStringData & "     ,:TNT4RM    "
''        If IsMissing(vntTNT4SY) = False Then strInsStringData = strInsStringData & "     ,:TNT4SY    "
''        If IsMissing(vntTNT4ST) = False Then strInsStringData = strInsStringData & "     ,:TNT4ST    "
''        If IsMissing(vntTNT4ED) = False Then strInsStringData = strInsStringData & "     ,:TNT4ED    "
''        If IsMissing(vntTNT5KA) = False Then strInsStringData = strInsStringData & "     ,:TNT5KA    "
''        If IsMissing(vntTNT5BT) = False Then strInsStringData = strInsStringData & "     ,:TNT5BT    "
''        If IsMissing(vntTNT5RM) = False Then strInsStringData = strInsStringData & "     ,:TNT5RM    "
''        If IsMissing(vntTNT5SY) = False Then strInsStringData = strInsStringData & "     ,:TNT5SY    "
''        If IsMissing(vntTNT5ST) = False Then strInsStringData = strInsStringData & "     ,:TNT5ST    "
''        If IsMissing(vntTNT5ED) = False Then strInsStringData = strInsStringData & "     ,:TNT5ED    "
''        If IsMissing(vntYUKOST) = False Then strInsStringData = strInsStringData & "     ,:YUKOST    "
''        If IsMissing(vntYUKOED) = False Then strInsStringData = strInsStringData & "     ,:YUKOED    "
''        If IsMissing(vntPASSYUKOED) = False Then strInsStringData = strInsStringData & " ,:PASSYUKOED"
''        If IsMissing(vntUPDYMD) = False Then strInsStringData = strInsStringData & "     ,:UPDYMD    "
''        If IsMissing(vntCRTYMD) = False Then strInsStringData = strInsStringData & "     ,:CRTYMD    "
''        If IsMissing(vntSTPFLG) = False Then strInsStringData = strInsStringData & "     ,:STPFLG    "
''### 2003/11/22 Deleted End
'        strInsStringData = strInsStringData & ")"
'
'        '最終的な文字列をbuild
'        strStmt = strInsStringFields & strInsStringData
'        mobjOraDb.ExecuteSQL strStmt
'        Ret = INSERT_NORMAL
'
'        Exit Do
'    Loop
'
'    'バインド変数の削除
'    Do Until objOraParam.Count <= 0
'        objOraParam.Remove (objOraParam.Count - 1)
'    Loop
'
'    'トランザクションをコミット
'    mobjContext.SetComplete
'
'    '戻り値の設定
'    RegistHainsUser = Ret
'
'    Exit Function
'
'ErrorHandle:
'
'    'その他の戻り値設定
'    RegistHainsUser = INSERT_ERROR
'
'    'イベントログ書き込み
'    WriteErrorLog "HainsUser.RegistHainsUser"
'
'    'エラー発生時はトランザクションをアボートに設定
'    mobjContext.SetAbort
'
'    'エラーをもう一回引き起こす
'    Err.Raise Err.Number, Err.Source, Err.Description
'
'End Function
'
' 機能　　 : ユーザテーブルレコードを削除する
'
' 引数　　 : (In)   strUserID    ユーザＩＤ
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteHainsUser(ByVal strUserID As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
'## 2002.03.28 Modified 1Line by H.Ishihara@FSIT ID&PASSWORD 両方共UCASE
'    objOraParam.Add "UserID", Trim(strUserID), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UserID", Trim(UCase(strUserID)), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2002.03.28 Modified End

    'ユーザテーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE HAINSUSER WHERE USERID = :USERID"
    
    'バインド変数の削除
    objOraParam.Remove "UserID"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteHainsUser = True

    Exit Function
    
ErrorHandle:

    DeleteHainsUser = False

    'イベントログ書き込み
    WriteErrorLog "HainsUser.DeleteHainsUser"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

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
'
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
