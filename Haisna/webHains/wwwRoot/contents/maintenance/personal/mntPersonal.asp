<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       個人情報メンテナンス (Ver0.0.1)
'       AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
'---------------------------------------------------------------------
'-- 管理番号：SL-UI-Y0101-109
'-- 修正日  ：2010.06.11
'-- 担当者  ：TCS)澤田
'-- 修正内容：ローマ字名をカナ氏名に変更する
'---------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"    -->
<!-- #include virtual = "/webHains/includes/common.inc"          -->
<!-- #include virtual = "/webHains/includes/EditEraYearList.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"     -->
<!-- #include virtual = "/webHains/includes/EditPrefList.inc"    -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon                   '共通クラス
Dim objFree                     '汎用情報アクセス用
Dim objHainsUser                'ユーザ情報アクセス用
Dim objPerson                   '個人情報アクセス用
Dim objPref                     '都道府県情報アクセス用

Dim strMode                     '処理モード(挿入:"insert"、更新:"update")
Dim strAction                   '処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")
Dim strTarget                   'ターゲット先のURL
Dim strPerId                    '個人ＩＤ
Dim strVidFlg                   '仮ＩＤフラグ
Dim strLastName                 '姓
Dim strFirstName                '名
Dim strLastKName                'カナ姓
Dim strFirstKName               'カナ名
Dim strRomeName                 'ローマ字名
Dim strMaidenName               '旧姓
Dim strBirth                    '生年月日
Dim strBirthYear                '生年月日(年)
Dim strBirthMonth               '生年月日(月)
Dim strBirthDay                 '生年月日(日)
Dim strGender                   '性別
Dim strCompPerId                '同伴者個人ＩＤ
Dim strCompName                 '同伴者名
Dim strCompLastName             '同伴者名　姓
Dim strCompFirstName            '同伴者名　名
Dim strMedRName                 '医事連携ローマ字名
Dim strMedName                  '医事連携漢字氏名
Dim strMedBirth                 '医事連携生年月日
Dim strMedGender                '医事連携性別
Dim strMedUpdDate               '医事連携更新日時

Dim strSpare(6)                 '予備(個人予備1, 2、個人情報詳細予備1～5)
Dim strDelFlg                   '削除フラグ
Dim strUpdDate                  '更新日付
Dim strUpdUser                  '更新者

'個人住所情報
Dim strAddrDiv                  '住所区分
Dim strTel                      '電話番号
Dim strExtension                '内線
Dim strSubTel                   '電話番号
Dim strFax                      'ＦＡＸ番号
Dim strPhone                    '携帯
Dim strEMail                    'e-Mail
Dim strZipCd                    '郵便番号
Dim strPrefCd                   '都道府県コード
Dim strCityName                 '市区町村名
Dim strAddress1                 '住所１
Dim strAddress2                 '住所２
Dim lngAddrCount                '住所情報数

Dim strMarriage                 '婚姻区分
Dim strNationCd                 '国籍コード
Dim strPostCardAddr             '１年目はがき宛先
Dim strResidentNo               '住民番号
Dim strUnionNo                  '組合番号
Dim strKarte                    'カルテ番号
Dim strNotes                    '特記事項
'## 2004.02.10 Add By T.Takagi@FSIT 受診回数が存在しない
Dim strCslCount                 '受診回数
'## 2004.02.10 Add End

Dim strSpareName(6)             '予備の表示名称
Dim strSelectedDate             '年月日
Dim strFreeName                 '汎用名
Dim strUserName                 'ユーザ名
Dim strArrMessage               'エラーメッセージ
Dim strHTML                     'HTML文字列
Dim Ret                         '関数戻り値
Dim Ret2                        '関数戻り値
Dim i, j                        'インデックス

Dim strArrGender()              '性別
Dim strArrGenderName()          '性別名称

Dim strArrMarriage              '婚姻区分
Dim strArrMarriageName          '婚姻区分名称

Dim strArrPostCardAddr()        '１年目はがき宛先
Dim strArrPostCardAddrName()    '１年目はがき宛先名称

Dim strArrDelFlg()              '削除フラグコード
Dim strArrDelFlgName()          '削除フラグ名

'汎用情報
Dim strFreeCd                   '汎用コード
Dim strFreeField1               'フィールド１

'編集用の個人住所情報
Dim strEditAddrDiv              '住所区分
Dim strEditTel                  '電話番号
Dim strEditExtension            '内線
Dim strEditSubTel               '電話番号
Dim strEditFax                  'ＦＡＸ番号
Dim strEditPhone                '携帯
Dim strEditEMail                'e-Mail
Dim strEditZipCd                '郵便番号
Dim strEditPrefCd               '都道府県コード
Dim strEditCityName             '市区町村名
Dim strEditAddress1             '住所１
Dim strEditAddress2             '住所２

Dim strPrefName                 '都道府県名
Dim strBuffer                   '文字列バッファ

'更新用の個人住所情報
Dim strUpdAddrDiv()             '住所区分
Dim strUpdTel()                 '電話番号
Dim strUpdExtension()           '内線
Dim strUpdSubTel()              '電話番号
Dim strUpdFax()                 'ＦＡＸ番号
Dim strUpdPhone()               '携帯
Dim strUpdEMail()               'e-Mail
Dim strUpdZipCd()               '郵便番号
Dim strUpdPrefCd()              '都道府県コード
Dim strUpdCityName()            '市区町村名
Dim strUpdAddress1()            '住所１
Dim strUpdAddress2()            '住所２

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strMode       = Request("mode")
strAction     = Request("act")
strTarget     = Request("target")
strPerId      = Request("perId")
strVidFlg     = Request("vidFlg")
strLastName   = Request("lastName")
strFirstName  = Request("firstName")
strLastKName  = Request("lastKName")
strFirstKName = Request("firstKName")
strRomeName   = Request("romeName")
strMaidenName = Request("maidenname")
strBirthYear  = Request("bYear")
strBirthMonth = Request("bMonth")
strBirthDay   = Request("bDay")
strGender     = Request("gender")
strCompPerId  = Request("compPerId")
strCompName   = Request("compName")
strDelFlg     = Request("delFlg")
strUpdDate    = Request("updDate")
strUpdUser    = Session.Contents("userId")
strMedRName   = Request("medRName")
strMedName    = Request("medName")
strMedBirth   = Request("medBirth")
strMedGender  = Request("medGender")
strMedUpdDate = Request("medUpdDate")

strAddrDiv    = ConvIStringToArray(Request("addrDiv"))
strTel        = ConvIStringToArray(Request("directTel"))
strExtension  = ConvIStringToArray(Request("extension"))
strSubTel     = ConvIStringToArray(Request("subTel"))
strFax        = ConvIStringToArray(Request("fax"))
strPhone      = ConvIStringToArray(Request("phone"))
strEMail      = ConvIStringToArray(Request("eMail"))
strZipCd      = ConvIStringToArray(Request("zipCd"))
strPrefCd     = ConvIStringToArray(Request("prefCd"))
strCityName   = ConvIStringToArray(Request("cityName"))
strAddress1   = ConvIStringToArray(Request("address1"))
strAddress2   = ConvIStringToArray(Request("address2"))

strMarriage     = Request("marriage")
strPostCardAddr = Request("postcardaddr")
strNationCd     = Request("nationcd")
strResidentNo   = Request("residentNo")
strUnionNo      = Request("unionNo")
strKarte        = Request("karte")
strNotes        = Request("notes")
strSpare(0)     = Request("spare1")
strSpare(1)     = Request("spare2")
strSpare(2)     = Request("spare3")
strSpare(3)     = Request("spare4")
strSpare(4)     = Request("spare5")
strSpare(5)     = Request("spare6")
strSpare(6)     = Request("spare7")
'## 2004.02.10 Add By T.Takagi@FSIT 受診回数が存在しない
strCslCount     = Request("cslCount")
'## 2004.02.10 Add End

'性別の配列作成
Call CreateGenderInfo()

'削除フラグの配列作成
Call CreateDelFlgInfo()

'１年目はがきあて先コード・名称の配列作成
Call CreatePostCardAddrInfo()

'予備の表示名称取得
For i = 0 To UBound(strSpare)

    '汎用名読み込み
    Set objFree = Server.CreateObject("HainsFree.Free")
    objFree.SelectFree 0, "PERSPARE" & (i + 1), , strFreeName
    Set objFree = Nothing

    '名称が設定されている場合はその内容を保持
    strSpareName(i) = IIf(strFreeName <> "", strFreeName, "汎用キー(" & (i + 1) & ")")

Next

'チェック・更新・読み込み処理の制御
Do

    '削除ボタン押下時
    If strAction = "delete" Then

        Set objPerson = Server.CreateObject("HainsPerson.Person")

        '個人情報の削除
        Ret2 = objPerson.DeletePerson(strPerId)

        Set objPerson = Nothing

        '戻り値ごとの判定
        Select Case Ret2
            Case  0
            Case -1
                strArrMessage = ("アフターケア情報が存在します。削除できません。")
            Case -2
                strArrMessage = ("受診情報が存在します。削除できません。")
            Case -3
                strArrMessage = ("傷病休業情報が存在します。削除できません。")
            Case -4
                strArrMessage = ("就労情報が存在します。削除できません。")
            Case Else
                strArrMessage = ("その他のエラーが発生しました（エラーコード＝" & Ret & "）。")
        End Select

        If Ret2 <> 0 Then
            Exit Do
        End If

        Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?mode=insert&act=deleteend"

    End If

    '保存ボタン押下時
    If strAction = "save" Then

        '住所情報数の設定
        lngAddrCount = UBound(strAddrDiv) + 1

        '入力チェック
        strArrMessage = CheckValue()
        If Not IsEmpty(strArrMessage) Then
            Exit Do
        End If

        '医事住所以外の住所情報を更新対象とする
        j = 0
        For i = 0 To lngAddrCount - 1
            If strAddrDiv(i) <> "4" Then
                ReDim Preserve strUpdAddrDiv(j)
                ReDim Preserve strUpdTel(j)
                ReDim Preserve strUpdExtension(j)
                ReDim Preserve strUpdSubTel(j)
                ReDim Preserve strUpdFax(j)
                ReDim Preserve strUpdPhone(j)
                ReDim Preserve strUpdEMail(j)
                ReDim Preserve strUpdZipCd(j)
                ReDim Preserve strUpdPrefCd(j)
                ReDim Preserve strUpdCityName(j)
                ReDim Preserve strUpdAddress1(j)
                ReDim Preserve strUpdAddress2(j)
                strUpdAddrDiv(j)   = strAddrDiv(i)
                strUpdTel(j)       = strTel(i)
                strUpdExtension(j) = strExtension(i)
                strUpdSubTel(j)    = strSubTel(i)
                strUpdFax(j)       = strFax(i)
                strUpdPhone(j)     = strPhone(i)
                strUpdEMail(j)     = strEMail(i)
                strUpdZipCd(j)     = strZipCd(i)
                strUpdPrefCd(j)    = strPrefCd(i)
                strUpdCityName(j)  = strCityName(i)
                strUpdAddress1(j)  = strAddress1(i)
                strUpdAddress2(j)  = strAddress2(i)
                j = j + 1
            End If
        Next

        '仮ＩＤフラグの設定
        strVidFlg = "1"

        Set objPerson = Server.CreateObject("HainsPerson.Person")

        '保存処理
'## 2004.02.10 Mod By T.Takagi@FSIT 受診回数が存在しない
'        strArrMessage = objPerson.UpdateAllPersonInfo_lukes( _
'                            strMode, _
'                            strPerId,        strVidFlg,      strLastName,    _
'                            strFirstName,    strLastKName,   strFirstKName,  _
'                            strRomeName,     strBirth,       strGender,      _
'                            strSpare(0),     strSpare(1),    strUpdUser,     _
'                            strPostCardAddr, strMaidenName,  strNationCd,    _
'                            strCompPerId,    strUpdAddrDiv,  strUpdTel,      _
'                            strUpdExtension, strUpdSubTel,   strUpdFax,      _
'                            strUpdPhone,     strUpdEMail,    strUpdZipCd,    _
'                            strUpdPrefCd,    strUpdCityName, strUpdAddress1, _
'                            strUpdAddress2,  strMarriage,    strResidentNo,  _
'                            strUnionNo,      strKarte,       strNotes,       _
'                            strSpare(2),     strSpare(3),    strSpare(4),    _
'                            strSpare(5),     strSpare(6),    strDelFlg       _
'                        )
        strArrMessage = objPerson.UpdateAllPersonInfo_lukes( _
                            strMode, _
                            strPerId,        strVidFlg,      strLastName,    _
                            strFirstName,    strLastKName,   strFirstKName,  _
                            strRomeName,     strBirth,       strGender,      _
                            strSpare(0),     strSpare(1),    strUpdUser,     _
                            strPostCardAddr, strMaidenName,  strNationCd,    _
                            strCompPerId,    strUpdAddrDiv,  strUpdTel,      _
                            strUpdExtension, strUpdSubTel,   strUpdFax,      _
                            strUpdPhone,     strUpdEMail,    strUpdZipCd,    _
                            strUpdPrefCd,    strUpdCityName, strUpdAddress1, _
                            strUpdAddress2,  strMarriage,    strResidentNo,  _
                            strUnionNo,      strKarte,       strNotes,       _
                            strSpare(2),     strSpare(3),    strSpare(4),    _
                            strSpare(5),     strSpare(6),    strDelFlg,      _
                            strCslCount                                      _
                        )
'## 2004.02.10 Mod End

        Set objPerson = Nothing

        '更新エラー時は処理を抜ける
        If Not IsEmpty(strArrMessage) Then
            Exit Do
        End If

        '保存に成功した場合、ターゲット指定時は指定先のURLへジャンプし、未指定時は更新モードでリダイレクト
        If strTarget <> "" Then
            Response.Redirect strTarget & "?perid=" & strPerID
        Else
            Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?mode=update&act=saveend&perid=" & strPerID
        End If
        Response.End

    End If

    '新規モードの場合は読み込みを行わない
    If strMode = "insert" Then
'### 2004/1/30 Added by Ishihara@FSIT 新規モードの場合のハガキはデフォルトで自宅
        strPostCardAddr = "1"
        Exit Do
    End If

    Set objPerson = Server.CreateObject("HainsPerson.Person")

    '個人テーブルレコード読み込み
'## 2004.02.10 Mod By T.Takagi@FSIT 受診回数が存在しない
'    objPerson.SelectPerson_lukes strPerId,        strLastName,      strFirstName,    _
'                                 strLastKName,    strFirstKName,    strRomeName,     _
'                                 strBirth,        strGender,        strPostCardAddr, _
'                                 strMaidenName,   strNationCd,      strCompPerId,    _
'                                 strCompLastName, strCompFirstName, strVidflg,       _
'                                 strDelFlg,       strUpdDate,       strUpdUser,      _
'                                 strUserName,     strSpare(0),      strSpare(1),     _
'                                 strMedRName,     strMedName,       strMedBirth,     _
'                                 strMedGender,    strMedUpdDate
    objPerson.SelectPerson_lukes strPerId,        strLastName,      strFirstName,    _
                                 strLastKName,    strFirstKName,    strRomeName,     _
                                 strBirth,        strGender,        strPostCardAddr, _
                                 strMaidenName,   strNationCd,      strCompPerId,    _
                                 strCompLastName, strCompFirstName, strVidflg,       _
                                 strDelFlg,       strUpdDate,       strUpdUser,      _
                                 strUserName,     strSpare(0),      strSpare(1),     _
                                 strMedRName,     strMedName,       strMedBirth,     _
                                 strMedGender,    strMedUpdDate,    strCslCount
'## 2004.02.10 Mod End

    strBirthYear = Year(strBirth)
    strBirthMonth = Month(strBirth)
    strBirthDay = Day(strBirth)

    strCompName = Trim(strCompLastName & "　" &  strCompFirstName)

    '個人詳細情報読み込み
    objPerson.SelectPersonDetail_lukes strPerId, strMarriage, strResidentNo, strUnionNo, strKarte, strNotes, strSpare(2), strSpare(3), strSpare(4), strSpare(5), strSpare(6)

    '個人住所情報読み込み
    lngAddrCount = objPerson.SelectPersonAddr(strPerId, strAddrDiv, strZipCd, strPrefCd, , strCityName, strAddress1, strAddress2, strTel, strPhone, strSubTel, strExtension, strFax, strEMail)

    Set objPerson = Nothing

    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 性別コード・名称の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreateGenderInfo()

    Redim Preserve strArrGender(1)
    Redim Preserve strArrGenderName(1)

    strArrGender(0) = "1":strArrGenderName(0) = "男性"
    strArrGender(1) = "2":strArrGenderName(1) = "女性"

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 戻り先URL編集
'
' 引数　　 :
'
' 戻り値　 : 戻り先のURL
'
' 備考　　 : 各業務ごとに戻り先(検索画面)のURLが異なるため、それを制御
'
'-------------------------------------------------------------------------------
Function EditURLForReturning()

    Dim strURL        '戻り先URL

    Do
        'ターゲット先URLが存在しない場合
        If strTarget = "" Then

            '通常のメンテナンス業務とみなし、同一仮想フォルダの検索画面へ
            strURL = "mntSearchPerson.asp"
            Exit Do

        End If

        Exit Do
    Loop

    EditURLForReturning = strURL

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 個人情報各値の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Const LENGTH_PERSON_ROMENAME = 60
    Const LENGTH_TEL             = 15

    Dim strColumn        '項目名
    Dim vntArrMessage    'エラーメッセージの集合
    Dim strMessage        'エラーメッセージ
    Dim i                'インデックス

    Set objCommon = Server.CreateObject("HainsCommon.Common")

    '各値チェック処理
    With objCommon

'## 2003.12.17 Mod By T.Takagi@FSIT No Check
'        'カナ姓
'        strMessage = .CheckWideValue("カナ姓", strLastKName,  LENGTH_PERSON_LASTKNAME, CHECK_NECESSARY)
'        If strMessage = "" Then
'            If .CheckKana(strLastKName) = False Then
'                strMessage = "カナ姓に不正な文字が含まれます。"
'            End If
'        End If
'        .AppendArray vntArrMessage, strMessage
'
'        'カナ名
'        strMessage = .CheckWideValue("カナ名", strFirstKName,  LENGTH_PERSON_FIRSTKNAME)
'        If strMessage = "" Then
'            If .CheckKana(strFirstKName) = False Then
'                strMessage = "カナ名に不正な文字が含まれます。"
'            End If
'        End If
'        .AppendArray vntArrMessage, strMessage
'
'        '姓名
'        .AppendArray vntArrMessage, .CheckWideValue("姓", strLastName,  LENGTH_PERSON_LASTNAME, CHECK_NECESSARY)
'        .AppendArray vntArrMessage, .CheckWideValue("名", strFirstName, LENGTH_PERSON_FIRSTNAME)
'
'        'ローマ字名
'        .AppendArray vntArrMessage, .CheckNarrowValue("ローマ字名", strRomeName, LENGTH_PERSON_ROMENAME)



'## 2015.03.04 張 ローマ字氏名必須項目チェック追加 START ###################################################

        'ローマ字名
        .AppendArray vntArrMessage, .CheckNarrowValue("ローマ字名", strRomeName, LENGTH_PERSON_ROMENAME)

        'ローマ字名
        If left(strPerId, 1) <> "@" and strRomeName = "" Then
            .AppendArray vntArrMessage, "ローマ字名を入力して下さい。"
        End If

'## 2015.03.04 張 ローマ字氏名必須項目チェック追加 END   ###################################################



        'カナ姓
        If strLastKName = "" Then
            .AppendArray vntArrMessage, "カナ姓を入力して下さい。"
        End If

        '姓
        If strLastName = "" Then
            .AppendArray vntArrMessage, "姓を入力して下さい。"
        End If
'## 2003.12.17 Mod End

        '性別
        If strGender = "" Then
            .AppendArray vntArrMessage, "性別を入力して下さい。"
        End If

        '生年月日
        .AppendArray vntArrMessage, .CheckDate("生年月日", strBirthYear, strBirthMonth, strBirthDay, strBirth, CHECK_NECESSARY)

'## 2004.03.24 Updated By T.Takagi@FSIT レングスチェックのみ復活
'## 2003.12.17 Del By T.Takagi@FSIT No Check
'       '住所情報
'       For i = 0 To lngAddrCount - 1
'
'            '医事情報は表示のみなのでチェック非対象
'            If strAddrDiv(i) <> "4" Then
'
'                'エラー時に表示するための項目名設定
'                Select Case strAddrDiv(i)
'                    Case "1"
'                        strColumn = "（自宅）"
'                    Case "2"
'                        strColumn = "（勤務先）"
'                    Case "3"
'                        strColumn = "（その他）"
'                End Select
'
'                '住所
'                .AppendArray vntArrMessage, .CheckWideValue("市区町村" & strColumn, strCityName(i), LENGTH_CITYNAME)
'                .AppendArray vntArrMessage, .CheckWideValue("番地"     & strColumn, strAddress1(i), LENGTH_ADDRESS)
'                .AppendArray vntArrMessage, .CheckWideValue("屋号"     & strColumn, strAddress2(i), LENGTH_ADDRESS)
'
'                '電話番号１
'                .AppendArray vntArrMessage, .CheckNarrowValue("電話番号１" & strColumn, strTel(i), LENGTH_TEL)
'
'                '携帯番号
'                .AppendArray vntArrMessage, .CheckNarrowValue("携帯番号" & strColumn, strPhone(i), LENGTH_TEL)
'
'                '電話番号２
'                .AppendArray vntArrMessage, .CheckNarrowValue("電話番号２" & strColumn, strSubTel(i), LENGTH_TEL)
'
'                '内線
'                .AppendArray vntArrMessage, .CheckNarrowValue("内線" & strColumn, strExtension(i), LENGTH_PERSONDETAIL_EXTENSION)
'
'                'ＦＡＸ番号
'                .AppendArray vntArrMessage, .CheckNarrowValue("ＦＡＸ番号" & strColumn, strFax(i), LENGTH_TEL)
'
'                'E-Mail
'                strMessage = .CheckNarrowValue("E-Mailアドレス" & strColumn, strEMail(i), LENGTH_EMAIL)
'                If strMessage = "" Then
'                    strMessage = .CheckEMail("E-Mailアドレス" & strColumn, strEMail(i))
'                End If
'                .AppendArray vntArrMessage, strMessage
'
'            End If
'
'        Next
'## 2003.12.17 Del End
        '住所情報
        For i = 0 To lngAddrCount - 1

            '医事情報は表示のみなのでチェック非対象
            If strAddrDiv(i) <> "4" Then

                'エラー時に表示するための項目名設定
                Select Case strAddrDiv(i)
                    Case "1"
                        strColumn = "（自宅）"
                    Case "2"
                        strColumn = "（勤務先）"
                    Case "3"
                        strColumn = "（その他）"
                End Select

                '住所
                .AppendArray vntArrMessage, .CheckLength("市区町村" & strColumn, strCityName(i), LENGTH_CITYNAME)
                .AppendArray vntArrMessage, .CheckLength("住所１"   & strColumn, strAddress1(i), LENGTH_ADDRESS)
                .AppendArray vntArrMessage, .CheckLength("住所２"   & strColumn, strAddress2(i), LENGTH_ADDRESS)

                '電話番号１
                .AppendArray vntArrMessage, .CheckLength("電話番号１" & strColumn, strTel(i), LENGTH_TEL)

                '携帯番号
                .AppendArray vntArrMessage, .CheckLength("携帯番号" & strColumn, strPhone(i), LENGTH_TEL)

                '電話番号２
                .AppendArray vntArrMessage, .CheckLength("電話番号２" & strColumn, strSubTel(i), LENGTH_TEL)

                '内線
                .AppendArray vntArrMessage, .CheckLength("内線" & strColumn, strExtension(i), LENGTH_PERSONDETAIL_EXTENSION)

                'ＦＡＸ番号
                .AppendArray vntArrMessage, .CheckLength("ＦＡＸ番号" & strColumn, strFax(i), LENGTH_TEL)

                'E-Mail
                strMessage = .CheckNarrowValue("E-Mailアドレス" & strColumn, strEMail(i), LENGTH_EMAIL)
                If strMessage = "" Then
                    strMessage = .CheckEMail("E-Mailアドレス" & strColumn, strEMail(i))
                End If
                .AppendArray vntArrMessage, strMessage

            End If

        Next
'## 2004.03.24 Updated End

'## 2004.02.10 Add By T.Takagi@FSIT 受診回数が存在しない
        .AppendArray vntArrMessage, .CheckNumeric("受診回数", strCslCount, 3)
'## 2004.02.10 Add End

        '住民番号
        .AppendArray vntArrMessage, .CheckNarrowValue("住民番号", strResidentNo, LENGTH_PERSONDETAIL_RESIDENTNO)

        '組合番号
        .AppendArray vntArrMessage, .CheckNarrowValue("組合番号", strUnionNo, LENGTH_PERSONDETAIL_UNIONNO)

        'カルテ番号
        .AppendArray vntArrMessage, .CheckNarrowValue("カルテ番号", strKarte, LENGTH_PERSONDETAIL_KARTE)

        '汎用キー
        For i = 0 To UBound(strSpare)

            '文字列長チェック
            .AppendArray vntArrMessage, .CheckLength(strSpareName(i), strSpare(i), IIf(i < 2, LENGTH_PERSON_SPARE, LENGTH_PERSONDETAIL_SPARE))

        Next

        '特記事項
        strMessage = .CheckWideValue("特記事項", strNotes, LENGTH_PERSONDETAIL_NOTES)

        '改行文字も1字として含む旨を通達
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If

    End With

    Set objCommon = Nothing

    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function
'-------------------------------------------------------------------------------
'
' 機能　　 : 削除コード・削除フラグ名称の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreateDelFlgInfo()

    Redim Preserve strArrDelFlg(1)
    Redim Preserve strArrDelFlgName(1)

    strArrDelFlg(0) = "0":strArrDelFlgName(0) = "使用中"
    strArrDelFlg(1) = "1":strArrDelFlgName(1) = "削除済み"

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : １年目はがきあて先コード・名称の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreatePostCardAddrInfo()

'### 2004/1/30 Modified by Ishihara@FSIT １年目はがきあて先にはNULLがあるんですけど
'   Redim Preserve strArrPostCardAddr(2)
'   Redim Preserve strArrPostCardAddrName(2)
    Redim Preserve strArrPostCardAddr(3)
    Redim Preserve strArrPostCardAddrName(3)
'### 2004/1/30 Modified End

    strArrPostCardAddr(0) = "1":strArrPostCardAddrName(0) = "住所（自宅）"
    strArrPostCardAddr(1) = "2":strArrPostCardAddrName(1) = "住所（勤務先）"
    strArrPostCardAddr(2) = "3":strArrPostCardAddrName(2) = "住所（その他）"
'### 2004/1/30 Modified by Ishihara@FSIT １年目はがきあて先にはNULLがあるんですけど
    strArrPostCardAddr(3) = "" :strArrPostCardAddrName(3) = "なし"
'### 2004/1/30 Modified End

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>個人情報メンテナンス</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/zipGuide.inc"  -->
<SCRIPT TYPE="text/javascript">
<!--
// 郵便番号ガイド呼び出し
function callZipGuide( index ) {
    var objForm = document.perdata;
    zipGuide_showGuideZip(objForm.prefCd[ index ].value, objForm.zipCd[ index ], objForm.prefCd[ index ], objForm.cityName[ index ], objForm.address1[ index ] );
}

// 郵便番号のクリア
function clearZipInfo( index ) {
    zipGuide_clearZipInfo( document.perdata.zipCd[ index ] );
}

// 個人ＩＤ付け替えページ呼び出し
function ChangePerID() {

    var Url = '/webHains/contents/maintenance/personal/mntChangePerID.asp';
    Url = Url + '?fromPerID=<%= strPerID %>&lastname=<%= Server.UrlEncode(strLastName) %>&firstname=<%= Server.UrlEncode(strFirstName) %>';
    winUpdateProgress = window.open(Url , '', 'width=450,height=200,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no');
}

// 団体検索ガイド呼び出し
function callOrgGuide( index ) {

    var url = '/webHains/contents/guide/gdeOrganization.asp?dispMode=1';    // 団体検索ガイド画面のURL

    // ガイド画面との連絡域を使用して処理制御を行う
    var objForm = document.perdata;
    orgGuide_ZipCd     = objForm.zipCd[ index ];
    orgGuide_PrefCd    = objForm.prefCd[ index ];
    orgGuide_CityName  = objForm.cityName[ index ];
    orgGuide_Address1  = objForm.address1[ index ];
    orgGuide_Address2  = objForm.address2[ index ];
    orgGuide_DirectTel = objForm.directTel[ index ];
    orgGuide_Tel       = objForm.subtel[ index ];
    orgGuide_Extension = objForm.extension[ index ];
    orgGuide_Fax       = objForm.fax[ index ];
    orgGuide_EMail     = objForm.email[ index ];

    orgGuide_openWindow( url );

}

// 2004.02.17 Add by Ishihara@FSIT
// 同伴者IDの明示的な表示
function editCompPerID_OnClose() {
    
    document.getElementById( 'dispCompID' ).innerHTML = document.perdata.compPerId.value;
}

// 2004.02.17 Add by Ishihara@FSIT
// 同伴者IDの明示的な表示
function editCompPerID_Clear() {
    
    perGuide_clearPerInfo(document.perdata.compPerId, 'compName')
    document.getElementById( 'dispCompID' ).innerHTML = document.perdata.compPerId.value;
}

function saveData() {
    document.perdata.submit();
}

function deleteData() {

    if ( !confirm( 'この個人情報を削除します。よろしいですか？' ) ) {
        return;
    }

    // モードを指定してsubmit
    document.perdata.act.value = 'delete';
    document.perdata.submit();

}

// サブ画面を閉じる
function closeWindow() {
    orgGuide_closeGuideOrg();
    zipGuide_closeGuideZip();
}

// '2004.06.01 ADD STR ORB)T.YAGUCHI
// 医事情報を複写する
function hopeDataCopy() {

    var objForm = document.perdata;
    var s1,s2,s3;

<%
    Set objCommon = Server.CreateObject("HainsCommon.Common")
%>

    s1=objForm.medName.value;
    if ( s1.indexOf('　')>=0 ) {
        s2 = s1.substring(0, s1.indexOf('　'));
        s3 = s1.substring(s1.indexOf('　') + 1);
        objForm.lastname.value = s2;
        objForm.firstname.value = s3;
    } else {
        objForm.lastname.value = s1;
        objForm.firstname.value = '';
    }

    <% '#### 2010.06.11 SL-UI-Y0101-109 ADD START #### %>
    s1=objForm.medRName.value;
    if ( s1.indexOf('　')>=0 ) {
        s2 = s1.substring(0, s1.indexOf('　'));
        s3 = s1.substring(s1.indexOf('　') + 1);
        objForm.lastkname.value     = s2;
        objForm.firstkname.value    = s3;
    } else {
        objForm.lastkname.value     = s1;
        objForm.firstkname.value    = '';
    }
    <% '#### 2010.06.11 SL-UI-Y0101-109 ADD END   #### %>

    <% '#### 2010.06.11 SL-UI-Y0101-109 DEL START #### %>
    // objForm.romeName.value = objForm.medRName.value;
    <% '#### 2010.06.11 SL-UI-Y0101-109 DEL END   #### %>
    objForm.gender.value        = objForm.medGender.value;
    objForm.byear.value         = '<%= objCommon.FormatString(strMedBirth, "ge") %>';
    objForm.bmonth.value        = '<%= objCommon.FormatString(strMedBirth, "m") %>';
    objForm.bday.value          = '<%= objCommon.FormatString(strMedBirth, "d") %>';

    objForm.zipCd[0].value      = objForm.zipCd[1].value;
    objForm.cityName[0].value   = objForm.cityName[1].value;
    objForm.address1[0].value   = objForm.address1[1].value;
    objForm.address2[0].value   = objForm.address2[1].value;
    objForm.directTel[0].value  = objForm.directTel[1].value;
    objForm.phone[0].value      = objForm.phone[1].value;
    objForm.subtel[0].value     = objForm.subtel[1].value;
    objForm.extension[0].value  = objForm.extension[1].value;
    objForm.fax[0].value        = objForm.fax[1].value;
    objForm.email[0].value      = objForm.email[1].value;

<%
    Set objCommon = Nothing
%>

}
// '2004.06.01 ADD END

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="perdata" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
<INPUT TYPE="hidden" NAME="mode"   VALUE="<%= strMode %>">
<INPUT TYPE="hidden" NAME="act"    VALUE="save">
<INPUT TYPE="hidden" NAME="target" VALUE="<%= strTarget %>">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
    <TR>
        <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">個人情報メンテナンス</FONT></B></TD>
    </TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="3" WIDTH="650">
    <TR>
        <TD WIDTH="100%"></TD>
        <TD><A HREF="<%= EditURLForReturning() %>"><IMG SRC="../../../images/back.gif" WIDTH="77" HEIGHT="24" ALT="検索画面に戻ります"></A></TD>
        <TD><A HREF="mntPerInspection.asp?perId=<%= strPerID %>"><IMG SRC="../../../images/insinfo_b.gif" WIDTH="77" HEIGHT="24" ALT="個人検査情報を修正します"></A></TD>
        
        <TD>
        <% '2005.08.22 権限管理 Add by 李　--- START %>
        <%  if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4" then   %>
            <A HREF="javascript:deleteData()"><IMG SRC="../../../images/delete.gif" WIDTH="77" HEIGHT="24" ALT="この個人情報を削除します"></A>

        <%  end if  %>
        <% '2005.08.22 権限管理 Add by 李　--- END %>
        </TD>
        
        <%  if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4" then   %>
            <TD><A HREF="/webHains/contents/maintenance/personal/mntPersonal.asp?mode=insert"><IMG SRC="../../../images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="新規登録します"></A></TD>
        <% End If  %>


        <% '2005.08.22 権限管理 Add by 李　--- START %>
        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
        <TD>
            <A HREF="javascript:saveData()"><IMG SRC="../../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="入力したデータを保存します"></A>    
        </TD>
    
        <TD><A HREF="javascript:ChangePerID()"><IMG SRC="../../../images/idChange.gif" WIDTH="77" HEIGHT="24" ALT="個人ＩＤ付け替え"></A></TD>

        <%  else    %>
             &nbsp;
        <%  end if  %>
        <% '2005.08.22 権限管理 Add by 李　--- END %>

    </TR>
</TABLE>
<BR>
<%
    'メッセージの編集
    Select Case strAction

        Case ""

        '保存完了時は「保存完了」の通知
        Case "saveend"
            Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

        '削除完了時は「削除完了」の通知
        Case "deleteend"
            Call EditMessage("削除が完了しました。", MESSAGETYPE_NORMAL)

        'さもなくばエラーメッセージを編集
        Case Else
            Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

    End Select
%>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">個人ＩＤ</TD>
        <TD NOWRAP><INPUT TYPE="hidden" NAME="perid" VALUE="<%= strPerID %>"><INPUT TYPE="hidden" NAME="vidflg" VALUE="0"><%= strPerID %></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">フリガナ</TD>
        <TD>
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD>姓&nbsp;</TD>
                    <TD><INPUT TYPE="text" NAME="lastkname"  SIZE="50" MAXLENGTH="25" VALUE="<%= strLastKName  %>" STYLE="ime-mode:active;"></TD>
                    <TD>&nbsp;名&nbsp;</TD>
                    <TD><INPUT TYPE="text" NAME="firstkname" SIZE="50" MAXLENGTH="25" VALUE="<%= strFirstKName %>" STYLE="ime-mode:active;"></TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">名前</TD>
        <TD>
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD>姓&nbsp;</TD>
                    <TD><INPUT TYPE="text" NAME="lastname"  SIZE="50" MAXLENGTH="25" VALUE="<%= strLastName  %>" STYLE="ime-mode:active;"></TD>
                    <TD>&nbsp;名&nbsp;</TD>
                    <TD><INPUT TYPE="text" NAME="firstname" SIZE="50" MAXLENGTH="25" VALUE="<%= strFirstName %>" STYLE="ime-mode:active;"></TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">ローマ字名</td>
        <TD><INPUT TYPE="text" NAME="romeName" SIZE="111" MAXLENGTH="60" VALUE="<%= strRomeName %>" STYLE="ime-mode:disabled;width:627px;"></TD>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">性別</TD>
        <TD><%= EditDropDownListFromArray("gender", strArrGender, strArrGenderName, strGender, IIf(strMode = "insert", NON_SELECTED_ADD, NON_SELECTED_DEL)) %></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">生年月日</TD>
<%
        '年月日の形式を作成する
        strSelectedDate = strBirthYear & "/" & strBirthMonth & "/" & strBirthDay

        '日付認識不能時は元号をそのまま関数に渡す
        If Not IsDate(strSelectedDate) Then
            strSelectedDate = strBirthYear
        End If
%>
        <TD>
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD><%= EditEraYearList("byear", strSelectedDate, (strMode = "insert")) %></TD>
                    <TD>&nbsp;年&nbsp;</TD>
                    <TD><%= EditSelectNumberList("bmonth", 1, 12, CLng("0" & strBirthMonth)) %></TD>
                    <TD>&nbsp;月&nbsp;</TD>
                    <TD><%= EditSelectNumberList("bday",   1, 31, CLng("0" & strBirthDay  )) %></TD>
                    <TD>&nbsp;日</TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">使用状態</TD>
        <TD><%= EditDropDownListFromArray("delFlg", strArrDelFlg, strArrDelFlgName, strDelFlg, NON_SELECTED_DEL) %></TD>
    </TR>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>同伴者名</TD>
        <TD>
            <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                <TR>
                
                    <TD><A HREF="javascript:perGuide_showGuidePersonal(document.perdata.compPerId, 'compName', null, editCompPerID_OnClose)"><IMG SRC="../../../images/question.gif" ALT="個人検索ガイドを表示" HEIGHT="21" WIDTH="21"></A></TD>
                    <!-- 2004.02.17 Mod by Ishihara@FSIT -->
<!--                    <TD><A HREF="javascript:perGuide_clearPerInfo(document.perdata.compPerId, 'compName')"><IMG SRC="../../../images/delicon.gif" ALT="設定した値をクリア" HEIGHT="21" WIDTH="21"></TD>-->
                    <TD><A HREF="javascript:editCompPerID_Clear()"><IMG SRC="../../../images/delicon.gif" ALT="設定した値をクリア" HEIGHT="21" WIDTH="21"></TD>
                    <TD>
                        <INPUT TYPE="hidden" NAME="compPerId" VALUE="<%= strCompPerId %>">
                        <SPAN ID="compName"><%= strCompName %></SPAN>
                    </TD>
                    <!-- 2004.02.17 Added by Ishihara@FSIT -->
                    <TD WIDTH="5"></TD>
                    <TD>
                        <FONT COLOR="#999999"><SPAN ID="dispCompID"><%= strCompPerId %></SPAN></FONT>
                    </TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
    <TR>
        <% '2004.06.01 ADD STR ORB)T.YAGUCHI %>
        <!--<TD>医事情報</TD>-->
        <!--<TD>医事情報</TD><TD><IMG SRC="../../../images/spacer.gif" WIDTH="30" HEIGHT="1" ALT=""></TD><TD><IMG SRC="../../../images/hopeCopy.gif" WIDTH="120" HEIGHT="24" ALT=""></TD>-->
        
        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
            <TD>医事情報</TD><TD><IMG SRC="../../../images/spacer.gif" WIDTH="200" HEIGHT="1" ALT=""><A HREF="javascript:hopeDataCopy()"><IMG SRC="../../../images/hopeCopy.gif" WIDTH="120" HEIGHT="24" ALT=""></A></TD>
            <% '2004.06.01 ADD END %>
        <%  end if  %>

    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>漢字氏名</TD>
        <TD><INPUT TYPE="hidden" NAME="medName" VALUE="<%= strMedName %>"><%= strMedName %></TD>
    </TR>
    <TR>
        <% '#### 2010.06.11 SL-UI-Y0101-109 ADD START #### %>
        <TD BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>カナ氏名</TD>
        <% '#### 2010.06.11 SL-UI-Y0101-109 ADD END   #### %>
        <% '#### 2010.06.11 SL-UI-Y0101-109 DEL START #### %>
        <!-- <TD BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>ローマ字名</TD> -->
        <% '#### 2010.06.11 SL-UI-Y0101-109 DEL END   #### %>
        <TD><INPUT TYPE="hidden" NAME="medRName" VALUE="<%= strMedRName %>"><%= strMedRName %></TD>
    </TR>
<%
    Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>生年月日</TD>
        <TD><INPUT TYPE="hidden" NAME="medBirth" VALUE="<%= strMedBirth %>"><%= objCommon.FormatString(strMedBirth, "ggge(yyyy)年m月d日") %></TD>
    </TR>
<%
    Set objCommon = Nothing

    Select Case strMedGender
        Case CStr(GENDER_MALE)
            strBuffer = "男性"
        Case CStr(GENDER_FEMALE)
            strBuffer = "女性"
        Case Else
            strBuffer = ""
    End Select
%>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>性別</TD>
        <TD><INPUT TYPE="hidden" NAME="medGender" VALUE="<%= strMedGender %>"><%= strBuffer %></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>更新日時</TD>
        <TD><INPUT TYPE="hidden" NAME="medUpdDate" VALUE="<%= strMedUpdDate %>"><%= strMedUpdDate %></TD>
    </TR>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
<%
    '個人住所情報の編集開始
    For j = 0 To 3

        '編集用変数の初期化
        strEditTel       = ""
        strEditExtension = ""
        strEditSubTel    = ""
        strEditFax       = ""
        strEditPhone     = ""
        strEditEMail     = ""
        strEditZipCd     = ""
        strEditPrefCd    = ""
        strEditCityName  = ""
        strEditAddress1  = ""
        strEditAddress2  = ""

        '検索用の住所区分を設定
        Select Case j
            Case 0
                strEditAddrDiv = "1"
            Case 1
                strEditAddrDiv = "4"
            Case 2
                strEditAddrDiv = "2"
            Case 3
                strEditAddrDiv = "3"
        End Select

        '読み込んだ個人住所情報から編集すべき住所区分を検索
        For i = 0 To lngAddrCount - 1
            If strAddrDiv(i) = strEditAddrDiv Then
                strEditTel       = strTel(i)
                strEditExtension = strExtension(i)
                strEditSubTel    = strSubTel(i)
                strEditFax       = strFax(i)
                strEditPhone     = strPhone(i)
                strEditEMail     = strEMail(i)
                strEditZipCd     = strZipCd(i)
                strEditPrefCd    = strPrefCd(i)
                strEditCityName  = strCityName(i)
                strEditAddress1  = strAddress1(i)
                strEditAddress2  = strAddress2(i)
                Exit For
            End If
        Next
%>
        <TR>
<%
            Select Case j

                Case 0
%>
                    <TD>住所（自宅）</TD>
<%
                Case 1
%>
                    <TD>住所（医事）</TD>
<%
                Case 2
%>
                    <TD>住所（勤務先）</TD>
                    <TD><A HREF="javascript:callOrgGuide(<%= j %>)">団体住所検索</A></TD>
<%
                Case 3
%>
                    <TD>住所（その他）</TD>
<%
            End Select
%>
        </TR>
<%
        '医事住所以外は入力形式で編集
        If j <> 1 Then
%>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right"><INPUT TYPE="hidden" NAME="addrDiv" VALUE="<%= strEditAddrDiv %>">郵便番号</TD>
                <TD>
                    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                        <TD><A HREF="javascript:callZipGuide(<%= j %>)"><IMG SRC="../../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="郵便番号ガイド表示"></A></TD>
                        <TD><A HREF="javascript:clearZipInfo(<%= j %>)"><IMG SRC="../../../images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="郵便番号を削除します"></A></TD>
                        <TD><INPUT TYPE="text" NAME="zipCd" VALUE="<%= strEditZipCd %>" SIZE="9" MAXLENGTH="7" STYLE="ime-mode:disabled;"></TD>
                    </TABLE>
                </TD>
            </TR>
            <TR>
                <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">都道府県</TD>
                <TD><%= EditPrefList("prefCd", strEditPrefCd) %></TD>
            </TR>
            <TR>
                <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">市区町村</TD>
                <TD><INPUT TYPE="text" NAME="cityName" SIZE="65" MAXLENGTH="50" VALUE="<%= strEditCityName %>" STYLE="ime-mode:active;"></TD>
            </TR>
            <TR>
                <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">住所１</TD>
                <TD><INPUT TYPE="text" NAME="address1" SIZE="78" MAXLENGTH="60" VALUE="<%= strEditAddress1 %>" STYLE="ime-mode:active;"></TD>
            </TR>
            <TR>
                <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">住所２</TD>
                <TD><INPUT TYPE="text" NAME="address2" SIZE="78" MAXLENGTH="60" VALUE="<%= strEditAddress2 %>" STYLE="ime-mode:active;"></TD>
            </TR>
            <TR>
                <TD HEIGHT="10"></TD>
            </TR>
            <TR>
                <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">電話番号１</TD>
                <TD><INPUT TYPE="text" NAME="directTel" SIZE="19" MAXLENGTH="15" VALUE="<%= strEditTel %>" STYLE="ime-mode:disabled;"></TD>
            </TR>
            <TR>
                <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">携帯番号</TD>
                <TD><INPUT TYPE="text" NAME="phone" SIZE="19" MAXLENGTH="15" VALUE="<%= strEditPhone %>" STYLE="ime-mode:disabled;"></TD>
            </TR>
            <TR>
                <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">電話番号２</TD>
                <TD>
                    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                        <TR>
                            <TD><INPUT TYPE="text" NAME="subtel" SIZE="19" MAXLENGTH="15" VALUE="<%= strEditSubTel %>" STYLE="ime-mode:disabled;"></TD>
                            <TD><IMG SRC="../../../images/spacer.gif" WIDTH="50" HEIGHT="1" ALT=""></TD>
                            <TD>内線</TD>
                            <TD>：&nbsp;</TD>
                            <TD><INPUT TYPE="text" NAME="extension" SIZE="15" MAXLENGTH="10" VALUE="<%= strEditExtension %>" STYLE="ime-mode:disabled;"></TD>
                        </TR>
                    </TABLE>
                </TD>
            </TR>
            <TR>
                <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">FAX番号</TD>
                <TD><INPUT TYPE="text" NAME="fax" SIZE="19" MAXLENGTH="15" VALUE="<%= strEditFax %>" STYLE="ime-mode:disabled;"></TD>
            </TR>
            <TR>
                <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">E-mailアドレス</TD>
                <TD><INPUT TYPE="text" NAME="email" SIZE="52" MAXLENGTH="40" VALUE="<%= strEditEmail %>" STYLE="ime-mode:disabled;"></TD>
            </TR>
            <TR>
                <TD HEIGHT="10"></TD>
            </TR>
<%
        Else

            '都道府県名読み込み
            Set objPref = Server.CreateObject("HainsPref.Pref")
            objPref.SelectPref strEditPrefCd, strPrefName
            Set objPref = Nothing
%>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right"><INPUT TYPE="hidden" NAME="addrDiv" VALUE="<%= strEditAddrDiv %>">郵便番号</TD>
                <TD><INPUT TYPE="hidden" NAME="zipCd" VALUE="<%= strEditZipCd %>"><%= strEditZipCd %></TD>
            </TR>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right">都道府県</TD>
                <TD><INPUT TYPE="hidden" NAME="prefCd" VALUE="<%= strEditPrefCd %>"><%= strPrefName %></TD>
            </TR>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right">市区町村</TD>
                <TD><INPUT TYPE="hidden" NAME="cityName" VALUE="<%= strEditCityName %>"><%= strEditCityName %></TD>
            </TR>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right">住所１</TD>
                <TD><INPUT TYPE="hidden" NAME="address1" VALUE="<%= strEditAddress1 %>"><%= strEditAddress1 %></TD>
            </TR>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right">住所２</TD>
                <TD><INPUT TYPE="hidden" NAME="address2" VALUE="<%= strEditAddress2 %>"><%= strEditAddress2 %></TD>
            </TR>
            <TR>
                <TD HEIGHT="10"></TD>
            </TR>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right">電話番号１</TD>
                <TD><INPUT TYPE="hidden" NAME="directTel" VALUE="<%= strEditTel %>"><%= strEditTel %></TD>
            </TR>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right">携帯番号</TD>
                <TD><INPUT TYPE="hidden" NAME="phone" VALUE="<%= strEditPhone %>"><%= strEditPhone %></TD>
            </TR>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right">電話番号２</TD>
                <TD><INPUT TYPE="hidden" NAME="subtel" VALUE="<%= strEditSubTel %>"><INPUT TYPE="hidden" NAME="extension" VALUE="<%= strEditExtension %>">
                    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                        <TR>
                            <TD><%= strEditSubTel %></TD>
                            <TD><IMG SRC="../../../images/spacer.gif" WIDTH="50" HEIGHT="1" ALT=""></TD>
                            <TD>内線</TD>
                            <TD>：&nbsp;</TD>
                            <TD><%= strEditExtension %></TD>
                        </TR>
                    </TABLE>
                </TD>
            </TR>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right">FAX番号</TD>
                <TD><INPUT TYPE="hidden" NAME="fax" VALUE="<%= strEditFax %>"><%= strEditFax %></TD>
            </TR>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right">E-mailアドレス</TD>
                <TD><INPUT TYPE="hidden" NAME="email" VALUE="<%= strEditEmail %>"><%= strEditEmail %></TD>
            </TR>
            <TR>
                <TD HEIGHT="10"></TD>
            </TR>
<%
        End If

    Next
%>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>宛先（一年目のはがき）</TD>
        <TD><%= EditDropDownListFromArray("postcardaddr", strArrPostCardAddr, strArrPostCardAddrName, strPostCardAddr, NON_SELECTED_DEL) %></TD>
    </TR>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">婚姻区分</TD>
        <TD>
<%
            Set objCommon = Server.CreateObject("HainsCommon.Common")

            '婚姻情報の読み込み
            If objCommon.SelectMarriageList(strArrMarriage, strArrMarriageName) > 0 Then
%>
                <%= EditDropDownListFromArray("marriage", strArrMarriage, strArrMarriageName, strMarriage, NON_SELECTED_ADD) %>
<%
            End If

            Set objCommon = Nothing
%>
        </TD>
    </TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">旧姓</TD>
        <TD><INPUT TYPE="text" NAME="maidenname"  SIZE="41" MAXLENGTH="16" VALUE="<%= strMaidenName %>" STYLE="ime-mode:active;"></TD>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
<!-- 2004.02.10 Add By T.Takagi@FSIT 受診回数が存在しない -->
    </TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">受診回数</TD>
        <TD><INPUT TYPE="text" NAME="cslCount" SIZE="3" MAXLENGTH="3" VALUE="<%= strCslCount %>" STYLE="ime-mode:disabled;"></TD>
    <TR>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
<!-- 2004.02.10 Add End -->
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">国籍</TD>
<%
        '汎用テーブルから受診区分を読み込む
        Set objFree = Server.CreateObject("HainsFree.Free")
        objFree.SelectFree 1, "NATION", strFreeCd, , , strFreeField1
        Set objFree = Nothing
%>
        <TD><%= EditDropDownListFromArray("nationcd", strFreeCd, strFreeField1, strNationCd, NON_SELECTED_ADD) %></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">住民番号</TD>
        <TD><INPUT TYPE="text" NAME="residentno" SIZE="19" MAXLENGTH="15" VALUE="<%= strResidentNo %>" STYLE="ime-mode:disabled;"></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">組合番号</TD>
        <TD><INPUT TYPE="text" NAME="unionno" SIZE="19" MAXLENGTH="15" VALUE="<%= strUnionNo %>" STYLE="ime-mode:disabled;"></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">カルテ番号</TD>
        <TD><INPUT TYPE="text" NAME="karte" SIZE="19" MAXLENGTH="15" VALUE="<%= strKarte %>" STYLE="ime-mode:disabled;"></TD>
    </TR>
<%
    For i = 0 To UBound(strSpare)
%>
        <TR>
            <TD BGCOLOR="#eeeeee" ALIGN="right"><%= strSpareName(i) %></TD>
            <TD><INPUT TYPE="text" NAME="spare<%= (i + 1) %>" SIZE="<%= IIf(i <= 1, "20", "26") %>" MAXLENGTH="<%= IIf(i <= 1, "16", "20") %>" VALUE="<%= strSpare(i) %>" STYLE="ime-mode:active;"></TD>
        </TR>
<%
    Next
%>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">特記事項</TD>
        <TD><TEXTAREA NAME="notes" COLS="50" ROWS="2" STYLE="ime-mode:active;"><%= strNotes %></TEXTAREA></TD>
    </TR>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">更新日時</TD>
        <TD><INPUT TYPE="hidden" NAME="upddate" VALUE="<%= strUpdDate %>"><%= strUpdDate %></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">更新者</TD>
<%
        'ユーザ名読み込み
        If strUpdUser <> "" Then
            Set objHainsUser = Server.CreateObject("HainsHainsUser.HainsUser")
            objHainsUser.SelectHainsUser strUpdUser, strUserName
            Set objHainsUser = Nothing
        End If
%>
        <TD><%= strUserName %></TD>
    </TR>
</TABLE>
</BLOCKQUOTE>
</FORM>
<%
If strAction = "saveend" Then
%>
<SCRIPT TYPE="text/javascript">
<!--
// 呼び元(受診情報詳細)画面に情報を渡すための個人情報クラス定義
function Person() {

    this.perId       = '';    // 個人ＩＤ
    this.lastName    = '';    // 姓
    this.firstName   = '';    // 名
    this.lastKName   = '';    // カナ姓
    this.firstKName  = '';    // カナ名
    this.birth       = '';    // 生年月日
    this.birthFull   = '';    // 生年月日(和暦＋西暦)
    this.gender      = '';    // 性別

    this.address = new Array(3);    // 住所

}

for ( ; ; ) {

    // 呼び元画面自体、または呼び元画面の個人情報編集関数が存在しない場合は何もしない
    if ( !opener ) break;

    if ( !opener.setPersonInfo ) break;

    var myForm  = document.perdata;
    var perInfo = new Person();
    var address, zipCd, prefName;

    // 呼び元画面に値を渡すためのクラス要素を編集
    perInfo.perId       = myForm.perid.value;           // 個人ID
    perInfo.lastName    = myForm.lastname.value;        // 姓
    perInfo.firstName   = myForm.firstname.value;       // 名
    perInfo.lastKName   = myForm.lastkname.value;       // カナ姓
    perInfo.firstKName  = myForm.firstkname.value;      // カナ名
    perInfo.birth       = '<%= strBirth %>';            // 生年月日
    perInfo.gender      = myForm.gender.value;          // 性別
<%
    Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
    perInfo.birthFull   = '<%= objCommon.FormatString(strBirth, "ge（yyyy）.m.d") %>';    // 生年月日(和暦＋西暦)
<%
    Set objCommon = Nothing
%>
    for ( var i = 0, j = 0; i < myForm.zipCd.length; i++ ) {

        // 医事情報はスキップ
        if ( i == 1 ) continue;

        // 郵便番号を分割して編集
        zipCd = myForm.zipCd[ i ].value;
        address = zipCd.substring(0, 3);
        if ( zipCd.length > 3 ) {
            address = address + '-' + zipCd.substring(3, zipCd.length);
        }

        prefName = myForm.prefCd[ i ].options[ myForm.prefCd[ i ].selectedIndex ].text;
        if ( prefName != '' ) {
            address = address + ( address != '' ? '　' : '' ) + prefName;
        }

        address = address + myForm.cityName[ i ].value + myForm.address1[ i ].value + myForm.address2[ i ].value;
        perInfo.address[ j ] = address;

        j++;
    }

    opener.setPersonInfo( perInfo, true );
    break;

}
//-->
</SCRIPT>
<%
End If
%>
</BODY>
</HTML>
