VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "DefineEnum"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'固定値の情報

'webHains有効年の規定値
Public Enum YEARRANGE
    YEARRANGE_MIN = 1970     'デフォルトの最小年
    YEARRANGE_MAX = 2200     'デフォルトの最大年
End Enum

'削除フラグ
Public Enum DELFLG
    DELFLG_USED = 0     '使用中
    DELFLG_DELETED = 1  '削除
End Enum

'適用元区分
Public Enum APDIV
    APDIV_PERSON = 0    '個人負担
    APDIV_MYORG = 1     '自社負担
    APDIV_ORG = 2       '指定団体負担
End Enum

'オプションコード(契約パターンオプション管理)
Public Enum OPTCD
    OPTCD_COURSE = 0    '基本コース管理情報用
End Enum

'オプション区分(契約パターンオプション管理)
Public Enum OPTDIV
    OPTDIV_ADD = 0      '追加オプション
    OPTDIV_DELETE = 1   '削除オプション
    OPTDIV_COURSE = 2   '基本コース
End Enum

'オプション追加モード(契約パターンオプション管理)
Public Enum OPTADDMODE
    OPTADDMODE_FREE = 0         '希望者のみ
    OPTADDMODE_ALL = 1          '全員対象
    OPTADDMODE_CONDITION = 2    '別途条件指定
    OPTADDMODE_COURSE = 3       '基本コース
End Enum

'性別(個人等)
Public Enum GENDER
    GENDER_BOTH = 0     '男女
    GENDER_MALE = 1     '男
    GENDER_FEMALE = 2   '女
End Enum

'年齢(契約パターンオプション管理・基準値詳細)
Public Enum AGE
    AGE_MINVALUE = 0    '最小値
    AGE_MAXVALUE = 999   '最大値
End Enum

'挿入時のエラー値
Public Enum INSERT_RET
     INSERT_NORMAL = 1              '正常
     INSERT_DUPLICATE = 0           'インデックス重複
     INSERT_ERROR = -1              'その他のエラー
     INSERT_HISTORYDUPLICATE = -2   '履歴重複エラー
     INSERT_NOPARENT = -3           '親キーなしエラー
     INSERT_FKEYERROR = -4          '外部キーエラー（子レコード存在含む）
End Enum

'更新時のエラー値
Public Enum UPDATE_RET
     UPDATE_NORMAL = 1      '正常
     UPDATE_NOTFOUND = 0    'レコードなし
     UPDATE_ERROR = -1      'その他のエラー
End Enum

'挿入、更新時の整合性違反のエラー値
Public Enum ALERT_FKEY
     ALERT_FKEY1 = 11       '整合性違反（外部キー１）
     ALERT_FKEY2 = 12       '整合性違反（外部キー２）
     ALERT_FKEY3 = 13       '整合性違反（外部キー３）
     ALERT_FKEY4 = 14       '整合性違反（外部キー４）
     ALERT_FKEY5 = 15       '整合性違反（外部キー５）
     ALERT_FKEY6 = 16       '整合性違反（外部キー６）
End Enum

'チェック関数の固定値
Public Enum CHECK
    CHECK_NECESSARY = 1     '必須である
End Enum

'カレンダー表示位置
Public Enum CALENDER
    CALENDER_TOP = 1        '当月先頭表示
    CALENDER_MIDDLE = 2     '当月中段表示
End Enum

'ドロップダウン年制御
Public Enum YEARS
    YEARS_SYSTEM = 1        'システム管理日付
    YEARS_BIRTH = 2         '生年月日
End Enum

'ドロップダウン制御
Public Enum SELECTED
    NON_SELECTED_ADD = 1    '未選択あり
    NON_SELECTED_DEL = 2    '未選択なし
    SELECTED_ALL = 3        '「すべて」あり
End Enum

'グループ内検査項目検索
Public Enum GRPDIV
    GRPDIV_R = 1            '依頼項目
    GRPDIV_I = 2            '検査結果
End Enum

'結果問診フラグ
Public Enum RSLQUE
    RSLQUE_R = 0            '検査結果
    RSLQUE_Q = 1            '問診結果
End Enum

Public Enum ITEM_ENABLED
    ITEM_NOTDISP = 0        '表示しない
    ITEM_DISP = 1           '表示する
End Enum

'個人受診・ウェブ予約団体コード
Public Enum ORGCD_KEY
    ORGCD_KEY_PERSON = 1    '個人受診
    ORGCD_KEY_WEB = 2       'ウェブ予約
End Enum
'## 2001.10.2 ADD END

'受診情報使用中フラグ
Public Enum CONSULT_CANCEL
    CONSULT_USED = 0        '使用中
End Enum

'管理番号制御
Public Enum CNTLNO
    CNTLNO_DISABLE = 0      '管理番号無効
    CNTLNO_ENABLED = 1      '管理番号有効
End Enum

'結果入力対象モード
Public Enum RSLMODE
    RSLMODE_JUDCLASS = 1    '判定分類
    RSLMODE_PROGRESS = 2    '進捗分類
End Enum

'結果入力カーソル移動方向
Public Enum ORIENTATION
    ORIENTATION_PORTRAIT = 1    '縦方向
    ORIENTATION_LANDSCAPE = 2   '横方向
End Enum

'休日・祝日に対する予約の許可
Public Enum HOLIDAYFLG
    HOLIDAYFLG_DENY = 0     '休日・祝日に対する予約を許さない
    HOLIDAYFLG_ALLOW = 1    '休日・祝日に対する予約を許す
End Enum

'枠を越えた人数の予約の許可
Public Enum OVER_RSV
    OVER_RSV_DENY = 0       '枠を越えた人数の予約を許さない
    OVER_RSV_ALLOW = 1      '枠を越えた人数の予約を許す
End Enum

'予約枠が存在しない場合、予約を許さないフラグ
Public Enum RESERVEFRA
    RESERVEFRA_DENY = 0       '予約を許さない
    RESERVEFRA_ALLOW = 1      '予約を許す
End Enum

'枠管理タイプ
Public Enum FRA_TYPE
    FRA_TYPE_CS = 0         'コース枠を管理
    FRA_TYPE_ITEM = 1       '検査項目枠を管理
End Enum

'時間枠
Public Enum TIME_FRA
    TIME_FRA_NON = 0        '終日（時間枠管理しない）
End Enum

'休診日
Public Enum HOLIDAY
    HOLIDAY_NON = 0         '未設定
    HOLIDAY_CLS = 1         '休診日
    HOLIDAY_HOL = 2         '祝日
End Enum

'２次健診フラグ
Public Enum S_COURSE
    COURSE_FIRST = 0        '通常コース
    COURSE_SECOND = 1       '２次健診扱い
End Enum

'請求書明細区分
Public Enum BILL_LINEDIV
    BILL_LINEDIV_CS = 1     '基本コースの明細区分コード
    BILL_LINEDIV_DEL = 4    '基本コース削除項目の明細区分コード
    BILL_LINEDIV_OPT = 2    'オプション検査の明細区分コード
    BILL_LINEDIV_ADD = 3    '契約外追加項目の明細区分コード
    BILL_LINEDIV_OTR = 9    'その他の明細区分コード
End Enum

'請求書作成方法
Public Enum BILL_METHOD
    BILL_METHOD_MAN = 0     '手入力による作成
    BILL_METHOD_PRG = 1     '締め処理による作成
End Enum

'請求書未出力フラグ
Public Enum BILL_NOPRINT
    BILL_NOPRINT_ALLOW = 0  '請求書に出力する
    BILL_NOPRINT_DENY = 1   '請求書に出力しない
End Enum

'判定医フラグ
Public Enum DOCTORFLG
    DOCTORFLG_USER = 0      '判定医ではない
    DOCTORFLG_DOCTOR = 1    '判定医
End Enum

'入金済み請求書削除御
Public Enum PAYMENTBILL
    PAYMENTBILL_DELETE_DISABLE = 0  '入金済み請求書削除不可
    PAYMENTBILL_DELETE_ENABLED = 1  '入金済み請求書削除可
End Enum

'受診フラグ
Public Enum CSLFLG
    CSLFLG_UNCONSULT = 0    '未受診
    CSLFLG_CONSULTED = 1    '受診
End Enum

'業務コード
Public Enum BUSINESSCD
    BUSINESSCD_NOTHING = 0      'なし
    BUSINESSCD_MAINTENANCE = 1  'テーブルメンテナンス
    BUSINESSCD_RESERVE = 2      '予約
    BUSINESSCD_RESULT = 3       '結果入力
    BUSINESSCD_JUDGEMENT = 4    '判定入力
    BUSINESSCD_PRINT = 5        '印刷・データ抽出
    BUSINESSCD_DEMAND = 6       '請求
End Enum

'権限
Public Enum AUTHORITY
    AUTHORITY_NOTING = 0        '権限なし
    AUTHORITY_REFER = 1         '参照のみ
    AUTHORITY_FULL = 2          '更新可能
End Enum
    
'## 2002.11.10 Add 3Lines By H.Ishihara@FSIT 報告書未出力フラグ対応
Public Enum ITEM_NOPRINTFLG
    ITEM_NOPRINT = 1            'その他検査欄に印字しない
End Enum
'## 2002.11.10 Add End
    
'## 2002.11.10 Add 3Lines By H.Ishihara@FSIT システム制御グループフラグの追加
Public Enum GRP_SYSTEMGRPFLG
    GRP_SYSTEMGRP = 1           'システム制御用グループ
End Enum
'## 2002.11.10 Add End
    
'フィールドレングス系
Public Enum LengthConstants
    
    '共通
    LENGTH_TEL1 = 6                         '電話番号(市外局番)
    LENGTH_TEL2 = 4                         '電話番号(局番)
    LENGTH_TEL3 = 4                         '電話番号(番号)
    LENGTH_EMAIL = 40                       'e-Mail
    LENGTH_ZIPCD1 = 3                       '郵便番号1
    LENGTH_ZIPCD2 = 4                       '郵便番号2
    LENGTH_CITYNAME = 50                    '市区町村名
    LENGTH_ADDRESS = 60                     '住所
    LENGTH_ISRNO = 8                        '保険者番号
    LENGTH_ISRSIGN = 16                     '健保記号(記号)
    LENGTH_ISRMARK = 12                     '健保記号(符号)
    LENGTH_HEISRNO = 12                     '健保番号
    
    '個人
    LENGTH_PERSON_PERID = 12                '個人ＩＤ
    LENGTH_PERSON_LASTNAME = 32             '姓
    LENGTH_PERSON_FIRSTNAME = 32            '名
    LENGTH_PERSON_LASTKNAME = 32            'カナ姓
    LENGTH_PERSON_FIRSTKNAME = 32           'カナ名
    LENGTH_PERSON_SPARE = 16                '予備１（個人）
    
    '個人属性
    LENGTH_PERSONDETAIL_ORGPOSTCD = 8       '所属部署コード
    LENGTH_PERSONDETAIL_EXTENSION = 10      '内線
    LENGTH_PERSONDETAIL_RESIDENTNO = 15     '住民番号
    LENGTH_PERSONDETAIL_UNIONNO = 15        '組合番号
    LENGTH_PERSONDETAIL_KARTE = 15          'カルテ番号
    LENGTH_PERSONDETAIL_EMPNO = 15          '従業員番号
    LENGTH_PERSONDETAIL_NOTES = 100         '特記事項
    LENGTH_PERSONDETAIL_SPARE = 20          '予備
    
    '団体
    LENGTH_ORG_ORGCD1 = 5                   '団体コード1
    LENGTH_ORG_ORGCD2 = 5                   '団体コード2
    LENGTH_ORG_ORGKNAME = 80                'カナ名称
    LENGTH_ORG_ORGNAME = 50                 '漢字名称
    LENGTH_ORG_ORGSNAME = 20                '略称
    LENGTH_ORG_EXTENSION = 12               '内線
    LENGTH_ORG_CHARGENAME = 20              '担当者氏名
    LENGTH_ORG_CHARGEKNAME = 30             '担当者カナ名
    LENGTH_ORG_CHARGEPOST = 50              '担当者部署名
    LENGTH_ORG_GOVMNGCD = 10                '政府管掌コード
    LENGTH_ORG_BANK = 20                    '銀行名
    LENGTH_ORG_BRANCH = 20                  '支店名
    LENGTH_ORG_ACCOUNTNO = 10               '口座番号
    LENGTH_ORG_NOTES = 200                  '特記事項
    LENGTH_ORG_SPARE = 12                   '予備
    
    '検査項目関連
    LENGTH_ITEM_P_ITEMCD = 6                '検査項目コード
    LENGTH_ITEM_C_SUFFIX = 2                'サフィックス
    
    LENGTH_ITEM_H_MAXVALUE = 8              '最大値
    LENGTH_ITEM_H_MINVALUE = 8              '最小値
    LENGTH_ITEM_H_INSITEMCD = 17            '検査用項目コード
    LENGTH_ITEM_H_UNIT = 8                  '単位
    LENGTH_ITEM_H_DEFRESULT = 8             '省略時検査結果
'## 2002.11.10 Mod 1Line By H.Ishihara@FSIT 東急殿対応
'    LENGTH_ITEM_H_DEFRSLCMTCD = 2           '省略時結果コメントコード
    LENGTH_ITEM_H_DEFRSLCMTCD = 3           '省略時結果コメントコード
'## 2002.11.10 Mod End
    
    '電カル関連
    LENGTH_KARTEITEM_KARTEDOCCD = 4         '電カル用文書種別コード
    LENGTH_KARTEITEM_KARTEITEMATTR = 3      '電カル用項目属性
    LENGTH_KARTEITEM_KARTEITEMCD = 8        '電カル用項目コード
    LENGTH_KARTEITEM_KARTEITEMNAME = 50     '電カル用項目名
    LENGTH_KARTEITEM_KARTETAGNAME = 20      '電カル用タグ名
    
    'グループ関連
    LENGTH_GRP_P_GRPCD = 5                  'グループコード
    LENGTH_GRP_I_SEQ = 4                    'SEQ
    
    '基準値関連
    LENGTH_STDVALUE_C_STDFLG = 1            '基準値フラグ
    
    '予約枠関連
    LENGTH_RSVFRA_P_RSVFRACD = 3            '予約枠コード
    LENGTH_SCHEDULE_EMPTYCOUNT = 3          '空き人数
    
    '計算関連
    LENGTH_CALC_C_OPERATOR = 1              '演算記号
    LENGTH_CALC_C_CALCRESULT = 2            '計算結果
    
    'コース関連
    LENGTH_COURSE_CSCD = 4                  'コースコード
    LENGTH_COURSE_H_CSHNO = 2               'コース履歴番号
    LENGTH_COURSE_JUD_NOREASON = 1          '無条件展開フラグ
    LENGTH_COURSE_JUD_SEQ = 3               '表示順番
    
    '検査実施日分類
    LENGTH_OPECLASS_OPECLASSCD = 3          '検査実施日分類コード
    
    '判定関連
    LENGTH_JUDCLASS_JUDCLASSCD = 3          '判定分類コード
    LENGTH_JUD_JUDCD = 2                    '判定コード
    LENGTH_JUDCMTSTC_JUDCMTCD = 8           '判定コメントコード
    LENGTH_STDJUD_STDJUDCD = 3              '定型所見コード
    LENGTH_JUDRSL_FREEJUDCMT = 500          'フリー判定コメント
    
    '結果関連（これはかなり汎用的に使えるはず（例：基準値）
    LENGTH_RSL_RESULT = 8                   '検査結果
'## 2002.11.10 Mod 1Line By H.Ishihara@FSIT 東急殿対応
'    LENGTH_RSLCMT_RSLCMTCD = 2              '結果コメントコード
    LENGTH_RSLCMT_RSLCMTCD = 3              '結果コメントコード
'## 2002.11.10 Mod End

'### 2003.05.13 Modified by Ishihara@FSIT 全然足りてません。
'    LENGTH_RSLCMT_RSLCMTNAME = 8            '結果コメント名称
    LENGTH_RSLCMT_RSLCMTNAME = 30           '結果コメント名称
'### 2003.05.13 Modified by Ishihara@FSIT 全然足りてません。
    
    '請求書団体管理
    LENGTH_BILL_ORG_BILLNO = 9              '請求書No
    LENGTH_BILL_ORG_SEQ = 4                 'SEQ
    LENGTH_BILL_ORG_CSLORGCD1 = 5           '受診団体コード１
    LENGTH_BILL_ORG_CSLORGCD2 = 5           '受診団体コード２
    LENGTH_BILL_ORG_CSCD = 4                'コースコード
    LENGTH_BILL_ORG_CONTRACTPRICE = 8       '契約時単価
    LENGTH_BILL_ORG_SUBTOTAL = 8            '金額
    LENGTH_BILL_ORG_TAX = 8                 '消費税
    LENGTH_BILL_ORG_DISCOUNT = 8            '値引き
    LENGTH_BILL_ORG_TOTAL = 8               '合計
    
    '請求明細
    LENGTH_BILLDETAIL_BILLNO = 9            '請求書No
    LENGTH_BILLDETAIL_SEQ = 4               'SEQ
    LENGTH_BILLDETAIL_LINENO = 3            '明細No
    LENGTH_BILLDETAIL_LINEDIV = 1           '明細区分
    LENGTH_BILLDETAIL_NOPRINT = 1           '請求書未出力フラグ
    LENGTH_BILLDETAIL_DETAILNAME = 30       '名称
    LENGTH_BILLDETAIL_PRICE = 8             '負担元単価
    LENGTH_BILLDETAIL_CSLMALECNT1 = 5       '男性本人人数
    LENGTH_BILLDETAIL_CSLMALECNT2 = 5       '男性扶養人数
    LENGTH_BILLDETAIL_CSLFEMALECNT1 = 5     '女性本人人数
    LENGTH_BILLDETAIL_CSLFEMALECNT2 = 5     '女性扶養人数
    LENGTH_BILLDETAIL_TOTALCNT = 5          '合計人数
    LENGTH_BILLDETAIL_SUBTOTAL = 8          '金額
    LENGTH_BILLDETAIL_TAX = 8               '消費税
    LENGTH_BILLDETAIL_DISCOUNT = 8          '値引き
    LENGTH_BILLDETAIL_TOTAL = 8             '合計
    
'### 2003.01.02 Added by Ishihara@FSIT
    LENGTH_BILLDETAIL_AGEDIV = 10           '年齢区分
    LENGTH_DMDLINECLASS_DMDLINECLASSCD = 3  '請求明細分類コード
    LENGTH_BILLDETAIL_EXISTSISR = 1         '健診有無区分
'### 2003.01.02 Added End
    
    '受診情報
    LENGTH_CONSULT_RSVNO = 9                '予約番号
    LENGTH_RECEIPT_DAYID = 4                '当日ID

    'BBS
    LENGTH_BBS_HANDLE = 30                  '投稿者
    LENGTH_BBS_TITLE = 40                   'タイトル
'### 2002.04.04 Updated by Ishihara@FSIT
'    LENGTH_BBS_MESSAGE = 300                'メッセージ
    LENGTH_BBS_MESSAGE = 2048                'メッセージ
'### 2002.04.04 Updated End

    '契約
    LENGTH_CTRPT_PRICE_PRICE = 7            '負担金額

    '病名
    LENGTH_DISEASE_DISCD = 9                '病名コード

    'ユーザ
    LENGTH_HAINSUSER_USERID = 20            'ユーザID

    '文章
    LENGTH_SENTENCE_SHORTSTC = 50           '文章略称

    '事業部
    LENGTH_ORGBSD_ORGBSDCD = 10             '事業部コード
    LENGTH_ORGBSD_ORGBSDKNAME = 80          'カナ名称
    LENGTH_ORGBSD_ORGBSDNAME = 80           '事業部名称

'## 2002.11.12 Add 6Lines By H.Ishihara@FSIT 東急殿対応
    '依頼項目単価
    LENGTH_ITEM_P_PRICE_EXISTSISR = 1       '健保有無区分
    LENGTH_ITEM_P_PRICE_SEQ = 3             'SEQ
    LENGTH_ITEM_P_PRICE_STRAGE = 7          '開始年齢
    LENGTH_ITEM_P_PRICE_ENDAGE = 7          '終了年齢
    LENGTH_ITEM_P_PRICE_BSDPRICE = 7        '団体負担金
    LENGTH_ITEM_P_PRICE_ISRPRICE = 7        '健保負担金
'## 2002.11.12 Add End

End Enum

'受診項目定数
Public Enum CONSULT_ITEM
    CONSULT_ITEM_T = 1                      '受診項目
    CONSULT_ITEM_F = 2                      '非受診項目
End Enum

'結果タイプ定数
Public Enum RESULTTYPE
    RESULTTYPE_NUMERIC = 0                  '数値
    RESULTTYPE_TEISEI1 = 1                  '定性１
    RESULTTYPE_TEISEI2 = 2                  '定性２
    RESULTTYPE_FREE = 3                     'フリー
    RESULTTYPE_SENTENCE = 4                 '文章
    RESULTTYPE_CALC = 5                     '計算
    RESULTTYPE_DATE = 6                     '日付タイプ
End Enum

'結果タイプ定数
Public Enum ITEMTYPE
    ITEMTYPE_STANDARD = 0                   '標準
    ITEMTYPE_BUI = 1                        '部位
    ITEMTYPE_SHOKEN = 2                     '所見
    ITEMTYPE_SHOCHI = 3                     '処置
End Enum

'未受付受診者対象判断定数
Public Enum UNRECEIPT_KEEP
    UNRECEIPT_KEEP_ENABLED = 1              '未受付受診者を対象に含む
    UNRECEIPT_KEEP_DISABLE = 2              '未受付受診者を対象に含まない
End Enum

'検査結果・前回値対象コース
Public Enum RSLCOURSE
    RSLCOURSE_ALL = 0                       '全てのコース
    RSLCOURSE_SAME = 1                      '同一コース
End Enum

'検査結果・前回値２次検査コース
Public Enum RSLSECOND
    RSLSECOND_NONE = 0                      '２次検査のコースは対象外
    RSLSECOND_ALL = 1                       '２次検査のコースを含む
End Enum

