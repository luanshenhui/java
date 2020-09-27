namespace Hainsi.Common.Constants
{
    /// <summary>
    /// 有効年の規定値
    /// </summary>
    public enum YearRange
    {
        /// <summary>
        /// デフォルトの最小年
        /// </summary>
        Min = 1970,

        /// <summary>
        /// デフォルトの最大年
        /// </summary>
        Max = 2200,
    }

    /// <summary>
    /// 削除フラグ
    /// </summary>
    public enum DelFlg
    {
        Used = 0,     // 使用中
        Deleted = 1,  // 削除
    }

    /// <summary>
    /// 適用元区分
    /// </summary>
    public enum ApDiv
    {
        Person = 0,    // 個人負担
        MyOrg = 1,     // 自社負担
        Org = 2,       // 指定団体負担
    }

    /// <summary>
    /// オプションコード(契約パターンオプション管理)
    /// </summary>
    public enum OptCd
    {
        Course = 0,   // 基本コース管理情報用
    }

    /// <summary>
    /// オプション区分(契約パターンオプション管理)
    /// </summary>
    public enum OptDiv
    {
        Add = 0,     // 追加オプション
        Delete = 1,  // 削除オプション
        Course = 2,  // 基本コース
    }

    /// <summary>
    /// オプション追加モード(契約パターンオプション管理)
    /// </summary>
    public enum OptAddMode
    {
        Free = 0,        // 希望者のみ
        All = 1,         // 全員対象
        Condition = 2,   // 別途条件指定
        Course = 3,      // 基本コース
    }

    /// <summary>
    /// 性別(個人等)
    /// </summary>
    public enum Gender
    {
        Both = 0,    // 男女
        Male = 1,    // 男
        Female = 2,  // 女
    }

    /// <summary>
    /// 年齢(契約パターンオプション管理・基準値詳細)
    /// </summary>
    public enum Age
    {
        MinValue = 0,   // 最小値
        MaxValue = 999,  // 最大値
    }

    /// <summary>
    /// 挿入時のエラー値
    /// </summary>
    public enum Insert
    {
        Normal = 1,             // 正常
        Duplicate = 0,          // インデックス重複
        Error = -1,             // その他のエラー
        HistoryDuplicate = -2,  // 履歴重複エラー
        NoParent = -3,          // 親キーなしエラー
        FKeyError = -4,         // 外部キーエラー（子レコード存在含む）
    }

    /// <summary>
    /// 更新時のエラー値
    /// </summary>
    public enum Update
    {
        Normal = 1,     // 正常
        NotFound = 0,   // レコードなし
        Error = -1,     // その他のエラー
    }

    /// <summary>
    /// 挿入、更新時の整合性違反のエラー値
    /// </summary>
    public enum AlertFKey
    {
        FKey1 = 11,      // 整合性違反（外部キー１）
        FKey2 = 12,      // 整合性違反（外部キー２）
        FKey3 = 13,      // 整合性違反（外部キー３）
        FKey4 = 14,      // 整合性違反（外部キー４）
        FKey5 = 15,      // 整合性違反（外部キー５）
        FKey6 = 16,      // 整合性違反（外部キー６）
    }

    /// <summary>
    /// チェック関数の固定値
    /// </summary>
    public enum Check
    {
        /// <summary>
        /// 省略可
        /// </summary>
        None = 0,

        /// <summary>
        /// 必須である
        /// </summary>
        Necessary = 1,
    }

    /// <summary>
    /// カレンダー表示位置
    /// </summary>
    public enum Calender
    {
        Top = 1,       // 当月先頭表示
        Middle = 2,    // 当月中段表示
    }

    /// <summary>
    /// ドロップダウン年制御
    /// </summary>
    public enum Years
    {
        System = 1,       // システム管理日付
        Birth = 2,        // 生年月日
    }

    /// <summary>
    /// ドロップダウン制御
    /// </summary>
    public enum Selected
    {
        NonSelectedAdd = 1,   // 未選択あり
        NonSelectedDel = 2,   // 未選択なし
        SelectedAll = 3,       // 「すべて」あり
    }

    /// <summary>
    /// グループ内検査項目検索
    /// </summary>
    public enum GrpDiv
    {
        R = 1,           // 依頼項目
        I = 2,           // 検査結果
    }

    /// <summary>
    /// 結果問診フラグ
    /// </summary>
    public enum RslQue
    {
        R = 0,           // 検査結果
        Q = 1,           // 問診結果
    }

    /// <summary>
    /// 問診結果表示有無
    /// </summary>
    public enum ItemEnabled
    {
        NotDisp = 0,       // 表示しない
        Disp = 1,          // 表示する
    }

    /// <summary>
    /// 個人受診・ウェブ予約団体コード
    /// </summary>
    public enum OrgCdKey
    {
        Person = 1,   // 個人受診
        Web = 2,      // ウェブ予約
    }

    /// <summary>
    /// 受診情報使用中フラグ
    /// </summary>
    public enum ConsultCancel
    {
        Used = 0,       // 使用中
    }

    /// <summary>
    /// 管理番号制御
    /// </summary>
    public enum CntlNo
    {
        Disable = 0,     // 管理番号無効
        Enabled = 1,     // 管理番号有効
    }

    /// <summary>
    /// 結果入力対象モード
    /// </summary>
    public enum RslMode
    {
        JudClass = 1,   // 判定分類
        Progress = 2,   // 進捗分類
    }

    /// <summary>
    /// 結果入力カーソル移動方向
    /// </summary>
    public enum Orientation
    {
        Portrait = 1,   // 縦方向
        Landscape = 2,  // 横方向
    }

    /// <summary>
    /// 休日・祝日に対する予約の許可
    /// </summary>
    public enum HolidayFlg
    {
        Deny = 0,    // 休日・祝日に対する予約を許さない
        Allow = 1,   // 休日・祝日に対する予約を許す
    }

    /// <summary>
    /// 枠を越えた人数の予約の許可
    /// </summary>
    public enum OverRsv
    {
        Deny = 0,      // 枠を越えた人数の予約を許さない
        Allow = 1,     // 枠を越えた人数の予約を許す
    }

    /// <summary>
    /// 予約枠が存在しない場合、予約を許さないフラグ
    /// </summary>
    public enum ReserveFra
    {
        Deny = 0,      // 予約を許さない
        Allow = 1,     // 予約を許す
    }

    /// <summary>
    /// 枠管理タイプ
    /// </summary>
    public enum FraType
    {
        Cs = 0,        // コース枠を管理
        Item = 1,      // 検査項目枠を管理
    }

    /// <summary>
    /// 時間枠
    /// </summary>
    public enum TimeFra
    {
        Non = 0,       // 終日（時間枠管理しない）
    }

    /// <summary>
    /// 休診日
    /// </summary>
    public enum Holiday
    {
        Non = 0,        // 未設定
        Cls = 1,        // 休診日
        Hol = 2,        // 祝日
    }

    /// <summary>
    /// ２次健診フラグ
    /// </summary>
    public enum SCourse
    {
        First = 0,       // 通常コース
        Second = 1,      // ２次健診扱い
    }

    /// <summary>
    /// 請求書明細区分
    /// </summary>
    public enum BillLineDiv
    {
        Cs = 1,    // 基本コースの明細区分コード
        Del = 4,   // 基本コース削除項目の明細区分コード
        Opt = 2,   // オプション検査の明細区分コード
        Add = 3,   // 契約外追加項目の明細区分コード
        Otr = 9,   // その他の明細区分コード
    }

    /// <summary>
    /// 請求書作成方法
    /// </summary>
    public enum BillMethod
    {
        Man = 0,    // 手入力による作成
        Prg = 1,    // 締め処理による作成
    }

    /// <summary>
    /// 請求書未出力フラグ
    /// </summary>
    public enum BillNoPrint
    {
        Allow = 0, // 請求書に出力する
        Deny = 1,  // 請求書に出力しない
    }

    /// <summary>
    /// 判定医フラグ
    /// </summary>
    public enum DoctorFlg
    {
        User = 0,     // 判定医ではない
        Doctor = 1,   // 判定医
    }

    /// <summary>
    /// 入金済み請求書削除御
    /// </summary>
    public enum PaymentBill
    {
        DeleteDisable = 0, // 入金済み請求書削除不可
        DeleteEnabled = 1, // 入金済み請求書削除可
    }

    /// <summary>
    /// 受診フラグ
    /// </summary>
    public enum CslFlg
    {
        UnConsult = 0,   // 未受診
        Consulted = 1,   // 受診
    }

    /// <summary>
    /// 業務コード
    /// </summary>
    public enum BusinessCd
    {
        Nothing = 0,     // なし
        Maintenance = 1, // テーブルメンテナンス
        Reserve = 2,     // 予約
        Result = 3,      // 結果入力
        Judgement = 4,   // 判定入力
        Print = 5,       // 印刷・データ抽出
        Demand = 6,      // 請求
    }

    /// <summary>
    /// 権限
    /// </summary>
    public enum Authority
    {
        Noting = 0,       // 権限なし
        Refer = 1,        // 参照のみ
        Full = 2,         // 更新可能
    }

    /// <summary>
    /// 報告書未出力フラグ
    /// </summary>
    public enum ItemNoPrintFlg
    {
        NoPrint = 1,           // その他検査欄に印字しない
    }

    /// <summary>
    /// システム制御用グループ
    /// </summary>
    public enum GrpSystemGrpFlg
    {
        SystemGrp = 1,          // システム制御用グループ
    }

    /// <summary>
    /// フィールドレングス系
    /// </summary>
    public enum LengthConstants
    {
        /// 共通
        LENGTH_TEL1 = 6,                        // 電話番号(市外局番)
        LENGTH_TEL2 = 4,                        // 電話番号(局番)
        LENGTH_TEL3 = 4,                        // 電話番号(番号)
        LENGTH_EMAIL = 40,                      // e-Mail
        LENGTH_ZIPCD1 = 3,                      // 郵便番号1
        LENGTH_ZIPCD2 = 4,                      // 郵便番号2
        LENGTH_CITYNAME = 50,                   // 市区町村名
        LENGTH_ADDRESS = 60,                    // 住所
        LENGTH_ISRNO = 8,                       // 保険者番号
        LENGTH_ISRSIGN = 16,                    // 健保記号(記号)
        LENGTH_ISRMARK = 12,                    // 健保記号(符号)
        LENGTH_HEISRNO = 12,                    // 健保番号

        /// 個人
        LENGTH_PERSON_PERID = 12,               // 個人ＩＤ
        LENGTH_PERSON_LASTNAME = 32,            // 姓
        LENGTH_PERSON_FIRSTNAME = 32,           // 名
        LENGTH_PERSON_LASTKNAME = 32,           // カナ姓
        LENGTH_PERSON_FIRSTKNAME = 32,          // カナ名
        LENGTH_PERSON_SPARE = 16,               // 予備１（個人）

        /// 個人属性
        LENGTH_PERSONDETAIL_ORGPOSTCD = 8,      // 所属部署コード
        LENGTH_PERSONDETAIL_EXTENSION = 10,     // 内線
        LENGTH_PERSONDETAIL_RESIDENTNO = 15,    // 住民番号
        LENGTH_PERSONDETAIL_UNIONNO = 15,       // 組合番号
        LENGTH_PERSONDETAIL_KARTE = 15,         // カルテ番号
        LENGTH_PERSONDETAIL_EMPNO = 15,         // 従業員番号
        LENGTH_PERSONDETAIL_NOTES = 100,        // 特記事項
        LENGTH_PERSONDETAIL_SPARE = 20,         // 予備

        /// 団体
        LENGTH_ORG_ORGCD1 = 5,                  // 団体コード1
        LENGTH_ORG_ORGCD2 = 5,                  // 団体コード2
        LENGTH_ORG_ORGKNAME = 80,               // カナ名称
        LENGTH_ORG_ORGNAME = 50,                // 漢字名称
        LENGTH_ORG_ORGSNAME = 20,               // 略称
        LENGTH_ORG_EXTENSION = 12,              // 内線
        LENGTH_ORG_CHARGENAME = 20,             // 担当者氏名
        LENGTH_ORG_CHARGEKNAME = 30,            // 担当者カナ名
        LENGTH_ORG_CHARGEPOST = 50,             // 担当者部署名
        LENGTH_ORG_GOVMNGCD = 10,               // 政府管掌コード
        LENGTH_ORG_BANK = 20,                   // 銀行名
        LENGTH_ORG_BRANCH = 20,                 // 支店名
        LENGTH_ORG_ACCOUNTNO = 10,              // 口座番号
        LENGTH_ORG_NOTES = 200,                 // 特記事項
        LENGTH_ORG_SPARE = 12,                  // 予備

        /// 検査項目関連
        LENGTH_ITEM_P_ITEMCD = 6,               // 検査項目コード
        LENGTH_ITEM_C_SUFFIX = 2,               // サフィックス
        LENGTH_ITEM_H_MAXVALUE = 8,             // 最大値
        LENGTH_ITEM_H_MINVALUE = 8,             // 最小値
        LENGTH_ITEM_H_INSITEMCD = 17,           // 検査用項目コード
        LENGTH_ITEM_H_UNIT = 8,                 // 単位
        LENGTH_ITEM_H_DEFRESULT = 8,            // 省略時検査結果
        LENGTH_ITEM_H_DEFRSLCMTCD = 3,          // 省略時結果コメントコード

        /// 電カル関連
        LENGTH_KARTEITEM_KARTEDOCCD = 4,        // 電カル用文書種別コード
        LENGTH_KARTEITEM_KARTEITEMATTR = 3,     // 電カル用項目属性
        LENGTH_KARTEITEM_KARTEITEMCD = 8,       // 電カル用項目コード
        LENGTH_KARTEITEM_KARTEITEMNAME = 50,    // 電カル用項目名
        LENGTH_KARTEITEM_KARTETAGNAME = 20,     // 電カル用タグ名

        /// グループ関連
        LENGTH_GRP_P_GRPCD = 5,                 // グループコード
        LENGTH_GRP_I_SEQ = 4,                   // SEQ

        /// 基準値関連
        LENGTH_STDVALUE_C_STDFLG = 1,           // 基準値フラグ

        /// 予約枠関連
        LENGTH_RSVFRA_P_RSVFRACD = 3,           // 予約枠コード
        LENGTH_SCHEDULE_EMPTYCOUNT = 3,         // 空き人数

        /// 計算関連
        LENGTH_CALC_C_OPERATOR = 1,             // 演算記号
        LENGTH_CALC_C_CALCRESULT = 2,           // 計算結果

        /// コース関連
        LENGTH_COURSE_CSCD = 4,                 // コースコード
        LENGTH_COURSE_H_CSHNO = 2,              // コース履歴番号
        LENGTH_COURSE_JUD_NOREASON = 1,         // 無条件展開フラグ
        LENGTH_COURSE_JUD_SEQ = 3,              // 表示順番

        /// 検査実施日分類
        LENGTH_OPECLASS_OPECLASSCD = 3,         // 検査実施日分類コード

        /// 判定関連
        LENGTH_JUDCLASS_JUDCLASSCD = 3,         // 判定分類コード
        LENGTH_JUD_JUDCD = 2,                   // 判定コード
        LENGTH_JUDCMTSTC_JUDCMTCD = 8,          // 判定コメントコード
        LENGTH_STDJUD_STDJUDCD = 3,             // 定型所見コード
        LENGTH_JUDRSL_FREEJUDCMT = 500,         // フリー判定コメント

        /// 結果関連
        LENGTH_RSL_RESULT = 8,                  // 検査結果
        LENGTH_RSLCMT_RSLCMTCD = 3,             // 結果コメントコード
        LENGTH_RSLCMT_RSLCMTNAME = 30,          // 結果コメント名称

        /// 請求書団体管理
        LENGTH_BILL_ORG_BILLNO = 9,             // 請求書No
        LENGTH_BILL_ORG_SEQ = 4,                // SEQ
        LENGTH_BILL_ORG_CSLORGCD1 = 5,          // 受診団体コード１
        LENGTH_BILL_ORG_CSLORGCD2 = 5,          // 受診団体コード２
        LENGTH_BILL_ORG_CSCD = 4,               // コースコード
        LENGTH_BILL_ORG_CONTRACTPRICE = 8,      // 契約時単価
        LENGTH_BILL_ORG_SUBTOTAL = 8,           // 金額
        LENGTH_BILL_ORG_TAX = 8,                // 消費税
        LENGTH_BILL_ORG_DISCOUNT = 8,           // 値引き
        LENGTH_BILL_ORG_TOTAL = 8,              // 合計

        /// 請求明細
        LENGTH_BILLDETAIL_BILLNO = 9,           // 請求書No
        LENGTH_BILLDETAIL_SEQ = 4,              // SEQ
        LENGTH_BILLDETAIL_LINENO = 3,           // 明細No
        LENGTH_BILLDETAIL_LINEDIV = 1,          // 明細区分
        LENGTH_BILLDETAIL_NOPRINT = 1,          // 請求書未出力フラグ
        LENGTH_BILLDETAIL_DETAILNAME = 30,      // 名称
        LENGTH_BILLDETAIL_PRICE = 8,            // 負担元単価
        LENGTH_BILLDETAIL_CSLMALECNT1 = 5,      // 男性本人人数
        LENGTH_BILLDETAIL_CSLMALECNT2 = 5,      // 男性扶養人数
        LENGTH_BILLDETAIL_CSLFEMALECNT1 = 5,    // 女性本人人数
        LENGTH_BILLDETAIL_CSLFEMALECNT2 = 5,    // 女性扶養人数
        LENGTH_BILLDETAIL_TOTALCNT = 5,         // 合計人数
        LENGTH_BILLDETAIL_SUBTOTAL = 8,         // 金額
        LENGTH_BILLDETAIL_TAX = 8,              // 消費税
        LENGTH_BILLDETAIL_DISCOUNT = 8,         // 値引き
        LENGTH_BILLDETAIL_TOTAL = 8,            // 合計
        LENGTH_BILLDETAIL_AGEDIV = 10,          // 年齢区分
        LENGTH_DMDLINECLASS_DMDLINECLASSCD = 3, // 請求明細分類コード
        LENGTH_BILLDETAIL_EXISTSISR = 1,        // 健診有無区分

        /// 受診情報
        LENGTH_CONSULT_RSVNO = 9,               // 予約番号
        LENGTH_RECEIPT_DAYID = 4,               // 当日ID

        /// BBS
        LENGTH_BBS_HANDLE = 30,                 // 投稿者
        LENGTH_BBS_TITLE = 40,                  // タイトル
        LENGTH_BBS_MESSAGE = 2048,               // メッセージ

        /// 契約
        LENGTH_CTRPT_PRICE_PRICE = 7,           // 負担金額

        /// 病名
        LENGTH_DISEASE_DISCD = 9,               // 病名コード

        /// ユーザ
        LENGTH_HAINSUSER_USERID = 20,           // ユーザID

        /// 文章
        LENGTH_SENTENCE_SHORTSTC = 50,          // 文章略称

        /// 事業部
        LENGTH_ORGBSD_ORGBSDCD = 10,            // 事業部コード
        LENGTH_ORGBSD_ORGBSDKNAME = 80,         // カナ名称
        LENGTH_ORGBSD_ORGBSDNAME = 80,          // 事業部名称

        /// 依頼項目単価
        LENGTH_ITEM_P_PRICE_EXISTSISR = 1,      // 健保有無区分
        LENGTH_ITEM_P_PRICE_SEQ = 3,            // SEQ
        LENGTH_ITEM_P_PRICE_STRAGE = 7,         // 開始年齢
        LENGTH_ITEM_P_PRICE_ENDAGE = 7,         // 終了年齢
        LENGTH_ITEM_P_PRICE_BSDPRICE = 7,       // 団体負担金
        LENGTH_ITEM_P_PRICE_ISRPRICE = 7,       // 健保負担金
    }

    /// <summary>
    /// 受診項目定数
    /// </summary>
    public enum ConsultItem
    {
        T = 1,                     // 受診項目
        F = 2,                     // 非受診項目
    }

    /// <summary>
    /// 結果タイプ定数
    /// </summary>
    public enum ResultType
    {
        Numeric = 0,                 // 数値
        Teisei1 = 1,                 // 定性１
        Teisei2 = 2,                 // 定性２
        Free = 3,                    // フリー
        Sentence = 4,                // 文章
        Calc = 5,                    // 計算
        Date = 6,                    // 日付タイプ
        Memo = 7,                    // メモ型
    }

    /// <summary>
    /// 結果タイプ定数
    /// </summary>
    public enum ItemType
    {
        Standard = 0,                  // 標準
        Bui = 1,                       // 部位
        Shoken = 2,                    // 所見
        Shochi = 3,                    // 処置
    }

    /// <summary>
    /// 未受付受診者対象判断定数
    /// </summary>
    public enum UnReceiptKeep
    {
        Enabled = 1,             // 未受付受診者を対象に含む
        Disable = 2,             // 未受付受診者を対象に含まない
    }

    /// <summary>
    /// 検査結果・前回値対象コース
    /// </summary>
    public enum RslCourse
    {
        All = 0,                      // 全てのコース
        Same = 1,                     // 同一コース
    }

    /// <summary>
    /// 検査結果・前回値２次検査コース
    /// </summary>
    public enum RslSecond
    {
        None = 0,                     // ２次検査のコースは対象外
        All = 1,                      // ２次検査のコースを含む
    }
}
