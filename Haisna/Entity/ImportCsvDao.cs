using Entity.Helper;
using Hainsi.Common.Constants;
using Microsoft.VisualBasic;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;

#pragma warning disable CS1591
#pragma warning disable RECS0022
#pragma warning disable RECS0085
#pragma warning disable RECS0154

namespace Hainsi.Entity
{
    public class ImportCsvDao : AbstractDao
    {
        private List<string> mPrefCd = new List<string>();                           // 都道府県コード
        private List<string> mtPrefName = new List<string>();                        // 都道府県名

        private List<string> mCslDivCd = new List<string>();                         // 受診区分コード
        private List<string> mCslDivName = new List<string>();                       // 受診区分名

        private List<string> mSetClassCd = new List<string>();                       // セット分類コード
        private List<string> mSetClassName = new List<string>();                     // セット分類名

        private List<string> mRsvGrpCd = new List<string>();                         // 予約群コード
        private List<string> mRsvGrpName = new List<string>();                       // 予約群名

        private List<string> mCourseRsvGrpCd = new List<string>();                   // コース内予約群コード
        private List<string> mCourseRsvGrpName = new List<string>();                 // コース内予約群名

        private const string TRANSACTIONDIV_RSVCSV = "LOGRSVCSV";  // ＣＳＶ一括予約用のログ処理ＩＤ

        // 項目位置情報
        private const int INDEX_CSLDATE1 = 0;                 //受診希望日１
        private const int INDEX_CSLDATE2 = 1;                 //受診希望日２
        private const int INDEX_CSLDATE3 = 2;                 //受診希望日３
        private const int INDEX_RSVGRPCD = 3;                 //予約群コード
        private const int INDEX_NAME = 4;                     //姓名
        private const int INDEX_KNAME = 5;                    //カナ姓名
        private const int INDEX_ROMENAME = 6;                 //ローマ字名
        private const int INDEX_BIRTH = 7;                    //生年月日
        private const int INDEX_GENDER = 8;                   //性別
        private const int INDEX_CSLDIVCD = 9;                 //受診区分コード
        private const int INDEX_PERID = 10;                   //個人ＩＤ
        private const int INDEX_ZIPCD = 11;                   //郵便番号
        private const int INDEX_TEL = 12;                     //電話番号
        private const int INDEX_ADDRESS = 13;                 //住所
        private const int INDEX_EMPNO = 14;                   //従業員番号（または保険証番号
        private const int INDEX_SETCLASSCD = 15;              //セット分類コード）

        // 項目長情報
        private const int LENGTH_CSLDATE1 = 0;              //受診希望日１
        private const int LENGTH_CSLDATE2 = 0;              //受診希望日２
        private const int LENGTH_CSLDATE3 = 0;              //受診希望日３
        private const int LENGTH_RSVGRPCD = 3;              //予約群コード
        private const int LENGTH_NAME = 50;                 //姓名
        private const int LENGTH_KNAME = 50;                //カナ姓名
        private const int LENGTH_ROMENAME = 60;             //ローマ字名
        private const int LENGTH_BIRTH = 0;                 //生年月日
        private const int LENGTH_GENDER = 0;                //性別
        private const int LENGTH_CSLDIVCD = 12;             //受診区分コード
        private const int LENGTH_PERID = 12;                //個人ＩＤ
        private const int LENGTH_ZIPCD = 7;                 //郵便番号
        private const int LENGTH_TEL = 15;                  //電話番号
        private const int LENGTH_ADDRESS = 60;              //住所
        private const int LENGTH_EMPNO = 12;                //従業員番号
        private const int LENGTH_ISRNO = 16;                //保険証番号
        private const int LENGTH_SETCLASSCD = 3;            //セット分類コード

        // 項目名情報
        private const string NAME_CSLDATE = "受診希望日";                 //受診希望日
        private const string NAME_CSLDATE1 = "第１受診希望日";            //受診希望日１
        private const string NAME_CSLDATE2 = "第２受診希望日";            //受診希望日２
        private const string NAME_CSLDATE3 = "第３受診希望日";            //受診希望日３
        private const string NAME_RSVGRPCD = "予約群";                    //予約群コード
        private const string NAME_NAME = "漢字名";                        //姓名
        private const string NAME_KNAME = "カナ名";                       //カナ姓名
        private const string NAME_ROMENAME = "ローマ字氏名";              //ローマ字名
        private const string NAME_BIRTH = "生年月日";                     //生年月日
        private const string NAME_GENDER = "性別";                        //性別
        private const string NAME_CSLDIVCD = "受診区分";                  //受診区分コード
        private const string NAME_PERID = "患者ＩＤ";                     //個人ＩＤ
        private const string NAME_ZIPCD = "郵便番号";                     //郵便番号
        private const string NAME_TEL = "電話番号";                       //電話番号
        private const string NAME_ADDRESS = "住所";                       //住所
        private const string NAME_EMPNO = "従業員番号";                   //従業員番号
        private const string NAME_ISRNO = "保険証番号";                   //保険証番号
        private const string NAME_SETCLASSCD = "セット分類コード";        //セット分類コード

        private const long CSLDATE_MAXCOUNT = 3;                          //指定可能な受診希望日の最大数

        /// <summary>
        /// 連携データアクセスオブジェクト
        /// </summary>
        readonly CooperationDao cooperationDao;

        /// <summary>
        /// ログデータアクセスオブジェクト
        /// </summary>
        readonly HainsLogDao hainsLogDao;

        /// <summary>
        /// 汎用情報アクセスオブジェクト
        /// </summary>
        readonly FreeDao freeDao;

        /// <summary>
        /// 都道府県情報アクセスオブジェクト
        /// </summary>
        readonly PrefDao prefDao;

        /// <summary>
        /// セット分類情報アクセスオブジェクト
        /// </summary>
        readonly SetClassDao setClassDao;

        /// <summary>
        /// スケジュール情報アクセスオブジェクト
        /// </summary>
        readonly ScheduleDao scheduleDao;

        /// <summary>
        /// 契約情報アクセスオブジェクト
        /// </summary>
        readonly ContractDao contractDao;

        /// <summary>
        /// 団体情報アクセスオブジェクト
        /// </summary>
        readonly OrganizationDao organizationDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        /// <param name="cooperationDao">連携データアクセスオブジェクト</param>
        /// <param name="hainsLogDao">ログデータアクセスオブジェクト</param>
        /// <param name="freeDao">汎用情報アクセスオブジェクト</param>
        /// <param name="prefDao">都道府県情報アクセスオブジェクト</param>
        /// <param name="setClassDao">セット分類情報アクセスオブジェクト</param>
        /// <param name="scheduleDao">スケジュール情報アクセスオブジェクト</param>
        /// <param name="contractDao">契約情報アクセスオブジェクト</param>
        /// <param name="organizationDao">団体情報アクセスオブジェクト</param>
        public ImportCsvDao(IDbConnection connection,
                            CooperationDao cooperationDao,
                            HainsLogDao hainsLogDao,
                            FreeDao freeDao,
                            PrefDao prefDao,
                            SetClassDao setClassDao,
                            ScheduleDao scheduleDao,
                            ContractDao contractDao,
                            OrganizationDao organizationDao) : base(connection)
        {
            this.cooperationDao = cooperationDao;
            this.hainsLogDao = hainsLogDao;
            this.freeDao = freeDao;
            this.prefDao = prefDao;
            this.setClassDao = setClassDao;
            this.scheduleDao = scheduleDao;
            this.contractDao = contractDao;
            this.organizationDao = organizationDao;
        }

        /// <summary>
        /// 配列に格納されたＣＳＶデータのチェックを行う
        /// </summary>
        /// <param name="noDiv">番号選択(1:従業員番号、2:保険証番号)</param>
        /// <param name="names">項目名</param>
        /// <param name="columns">カラム値</param>
        /// <param name="lengths">項目長</param>
        /// <param name="message1">メッセージ１</param>
        /// <param name="message2">メッセージ２</param>
        private void CheckColumnValue(long noDiv, List<string> names, List<string> columns, List<int> lengths, ref List<string> message1, ref List<string> message2)
        {
            string message;                                 //メッセージ
            List<string> arrMessage1 = new List<string>();  //メッセージ１
            List<string> arrMessage2 = new List<string>();  //メッセージ２
            string stdMessage1;                             //基本メッセージ１
            string stdMessage2;                             //基本メッセージ２
            string lastName = "";                           //姓
            string firstName = "";                          //名
            string prefCd = "";                             //都道府県コード
            string cityName = "";                           //市区町村コード
            string address1 = "";                           //住所１
            string address2 = "";                           //住所２
            string[] zipCd;                                 //郵便番号
            bool tooLong;                                   //項目長が長すぎる場合にTrue
            int nameIndex;                                  //項目名情報のインデックス

            // 基本メッセージの作成(患者ＩＤと姓名をもって基本メッセージとする)
            message = "";
            message = message + NAME_PERID + "=" + ((!"".Equals(columns[INDEX_PERID])) ? columns[INDEX_PERID] : "なし");
            message = message + "、";
            message = message + NAME_NAME + "=" + ((!"".Equals(columns[INDEX_NAME])) ? columns[INDEX_NAME] : "なし");

            // 項目単位のチェック
            for (int i = 0; i < columns.Count; i++)
            {
                //セット分類に注意しつつ、現在チェック対象である項目の、項目名情報におけるインデックスを定義
                nameIndex = Convert.ToInt32((i >= INDEX_SETCLASSCD ? INDEX_SETCLASSCD : i));

                // 必須項目のチェック
                switch (i)
                {
                    // 姓名、カナ姓名、生年月日、性別、受診区分コードは必須チェックを行う
                    case INDEX_NAME:
                    case INDEX_KNAME:
                    case INDEX_BIRTH:
                    case INDEX_GENDER:
                    case INDEX_CSLDIVCD:

                        if ("".Equals(columns[i]))
                        {
                            cooperationDao.AppendMessage(arrMessage1, arrMessage2, names[i] + "が設定されていません。", message);
                        }

                        break;
                    // 受診希望日の場合は複合チェックを行う
                    case INDEX_CSLDATE1:

                        if ("".Equals(columns[INDEX_CSLDATE1]) && "".Equals(columns[INDEX_CSLDATE2]) && "".Equals(columns[INDEX_CSLDATE3]))
                        {
                            cooperationDao.AppendMessage(arrMessage1, arrMessage2, NAME_CSLDATE + "が設定されていません。", message);
                        }

                        break;
                }

                // 項目値が存在する場合のチェック処理
                while (true)
                {
                    // 項目値が存在しなければ制御を抜ける
                    if ("".Equals(columns[i]))
                    {
                        break;
                    }

                    tooLong = false;

                    // 基本メッセージの作成
                    stdMessage1 = names[nameIndex] + "の値が長すぎます。";
                    stdMessage2 = message + "、" + names[nameIndex] + "=" + columns[i];

                    // 項目長のチェック
                    // 受診希望日１、２、３、生年月日については日付形式のため以降のチェックを行う
                    if (i == INDEX_CSLDATE1 || i == INDEX_CSLDATE2 || i == INDEX_CSLDATE3 || i == INDEX_BIRTH)
                    {
                    }
                    // 姓名、カナ姓名は全角変換かつ空白分離後の値でチェックを行う
                    else if (i == INDEX_NAME || i == INDEX_KNAME)
                    {
                        // 姓名に分割
                        cooperationDao.SplitName(columns[i], ref lastName, ref firstName);

                        //#ToDo LenB について　どうするか？
                        //If LenB(StrConv(strLastName, vbFromUnicode)) > vntLengths(i) Or LenB(StrConv(strFirstName, vbFromUnicode)) > vntLengths(i) Then
                        //    If i = INDEX_NAME Then
                        //    AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strMessage
                        //Else
                        //    AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                        //End If
                        //blnTooLong = True
                        //End If
                        if (Encoding.Unicode.GetByteCount(lastName) > lengths[i]
                            || Encoding.Unicode.GetByteCount(firstName) > lengths[i])
                        {
                            if (i == INDEX_NAME)
                            {
                                cooperationDao.AppendMessage(arrMessage1, arrMessage2, stdMessage1, message);
                            }
                            else
                            {
                                cooperationDao.AppendMessage(arrMessage1, arrMessage2, stdMessage1, stdMessage2);
                            }
                            tooLong = true;
                        }
                    }
                    // 住所は最大項目長分割後の値でチェック
                    else if (i == INDEX_ADDRESS)
                    {
                        // 住所の分割
                        SplitAddress(columns[i], ref prefCd, ref cityName, ref address1, ref address2);

                        // 都道府県コードはさておき、市区町村名、住所１は必ず項目長内に収まるよう分割される。よってここでは住所２の項目長チェックを行えばよい。
                        //#ToDo LenB について　どうするか？
                        //If LenB(StrConv(strAddress2, vbFromUnicode)) > vntLengths(i) Then
                        //    AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                        //    blnTooLong = True
                        //End If
                        if (Encoding.Unicode.GetByteCount(address2) > lengths[i])
                        {
                            cooperationDao.AppendMessage(arrMessage1, arrMessage2, stdMessage1, stdMessage2);

                            tooLong = true;
                        }
                    }
                    // セット分類の開始位置以降の場合、すべてセット分類とみなしてチェック
                    else if (i >= INDEX_SETCLASSCD)
                    {
                        //#ToDo LenB について　どうするか？
                        //If LenB(StrConv(vntColumns(i), vbFromUnicode)) > vntLengths(INDEX_SETCLASSCD) Then
                        //    AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                        //    blnTooLong = True
                        //End If

                        if (Encoding.Unicode.GetByteCount(columns[i]) > lengths[INDEX_SETCLASSCD])
                        {
                            cooperationDao.AppendMessage(arrMessage1, arrMessage2, stdMessage1, stdMessage2);

                            tooLong = true;
                        }
                    }
                    // 性別、郵便番号は以降の独自チェックを行う
                    else if (i == INDEX_GENDER || i == INDEX_ZIPCD)
                    {
                    }
                    // 個人ＩＤの場合
                    else if (i == INDEX_PERID)
                    {
                        // ゼロトリミングした状態で項目長チェックを行う
                        //#ToDo LenB について　どうするか？
                        //If LenB(StrConv(LTrimZero(vntColumns(i)), vbFromUnicode)) > vntLengths(i) Then
                        //    AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strMessage
                        //    blnTooLong = True
                        //End If

                        if (Encoding.Unicode.GetByteCount(LTrimZero(columns[i])) > lengths[i])
                        {
                            cooperationDao.AppendMessage(arrMessage1, arrMessage2, stdMessage1, message);

                            tooLong = true;
                        }
                    }
                    // 予約群は以降の独自チェックを行う
                    else if (i == INDEX_RSVGRPCD)
                    {
                    }
                    // それ以外の通常の項目長チェック
                    else
                    {
                        //#ToDo LenB について　どうするか？
                        //If LenB(StrConv(vntColumns(i), vbFromUnicode)) > vntLengths(i) Then
                        //    AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                        //    blnTooLong = True
                        //End If

                        if (Encoding.Unicode.GetByteCount(columns[i]) > lengths[i])
                        {
                            cooperationDao.AppendMessage(arrMessage1, arrMessage2, stdMessage1, stdMessage2);

                            tooLong = true;
                        }
                    }

                    // 項目値が存在しなければ制御を抜ける
                    if (tooLong)
                    {
                        break;
                    }

                    // 基本メッセージの作成
                    stdMessage1 = names[nameIndex] + "が無効です。";

                    // 項目タイプごとのチェック
                    // 受診希望日１、２、３、生年月日については日付チェックを行う
                    if (i == INDEX_CSLDATE1 || i == INDEX_CSLDATE2 || i == INDEX_CSLDATE3 || i == INDEX_BIRTH)
                    {
                        if ("".Equals(columns[i]))
                        {
                            cooperationDao.AppendMessage(arrMessage1, arrMessage2, names[i] + "が日付として認識できません。", stdMessage2);
                        }
                    }
                    // カナ姓名の場合はカナ文字チェックを行う
                    else if (i == INDEX_KNAME)
                    {
                        if (!cooperationDao.CheckKana(columns[i]))
                        {
                            cooperationDao.AppendMessage(arrMessage1, arrMessage2, names[i] + "に不正な文字が含まれます。", stdMessage2);
                        }
                    }
                    // 性別は"1"、"2"しか許さない
                    else if (i == INDEX_GENDER)
                    {
                        if (!cooperationDao.CheckIntoValue(columns[i], new List<string> { "1", "2" }))
                        {
                            cooperationDao.AppendMessage(arrMessage1, arrMessage2, stdMessage1, stdMessage2);
                        }
                    }
                    // 受診区分コードについてはレコード存在チェックを行う
                    else if (i == INDEX_CSLDIVCD)
                    {
                        if (!cooperationDao.CheckIntoValue(columns[i], mCslDivCd))
                        {
                            cooperationDao.AppendMessage(arrMessage1, arrMessage2, stdMessage1, stdMessage2);
                        }
                    }
                    // 郵便番号の場合
                    else if (i == INDEX_ZIPCD)
                    {
                        // ハイフンが存在しない場合
                        if (columns[i].IndexOf("-", StringComparison.Ordinal) < 0)
                        {
                            // 指定の項目長以外はエラー
                            //#ToDo LenB について　どうするか？
                            //If LenB(StrConv(vntColumns(i), vbFromUnicode)) <> vntLengths(i) Then
                            //    AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                            //End If
                            if (Encoding.Unicode.GetByteCount(columns[i]) != lengths[i])
                            {
                                cooperationDao.AppendMessage(arrMessage1, arrMessage2, stdMessage1, stdMessage2);
                            }

                            break;
                        }

                        // ハイフンが存在する場合、ハイフンで分割
                        zipCd = columns[i].Split('-');

                        // 要素が３つ以上ある場合はエラー
                        if (zipCd.Length >= 3)
                        {
                            cooperationDao.AppendMessage(arrMessage1, arrMessage2, stdMessage1, stdMessage2);
                            break;
                        }

                        // この時点で要素は２個のはずなので各要素ごとに項目長チェックを行う
                        for (int j = 0; j < zipCd.Length; j++)
                        {
                            //#ToDo LenB について　どうするか？
                            //If LenB(StrConv(Trim(vntZipCd(j)), vbFromUnicode)) <> IIf(j = 0, LENGTH_ZIPCD1, LENGTH_ZIPCD2) Then
                            //    AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                            //    Exit Do
                            //End If
                            if (Encoding.Unicode.GetByteCount(zipCd[j].Trim()) != Convert.ToInt32(j == 0 ? LengthConstants.LENGTH_ZIPCD1 : LengthConstants.LENGTH_ZIPCD2))
                            {
                                cooperationDao.AppendMessage(arrMessage1, arrMessage2, stdMessage1, stdMessage2);
                                break;
                            }
                        }
                    }
                    // ローマ字名の場合
                    else if (i == INDEX_ROMENAME)
                    {
                        //半角英数字チェック
                        if (!cooperationDao.CheckNarrowValue(columns[i]))
                        {
                            cooperationDao.AppendMessage(arrMessage1, arrMessage2, names[i] + "に不正な文字が含まれます。", stdMessage2);
                        }
                    }
                    // 予約群の場合
                    else if (i == INDEX_RSVGRPCD)
                    {
                        //数字チェック
                        if (!cooperationDao.CheckNumber(columns[i]))
                        {
                            cooperationDao.AppendMessage(arrMessage1, arrMessage2, stdMessage1, stdMessage2);
                            break;
                        }
                        // ゼロトリミングした状態で項目長チェックを行う
                        //#ToDo LenB について　どうするか？
                        //If LenB(StrConv(LTrimZero(vntColumns(i)), vbFromUnicode)) > LENGTH_RSVGRPCD Then
                        //    AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "の値が長すぎます。", strStdMessage2
                        //    Exit Do
                        //End If
                        if (Encoding.Unicode.GetByteCount(LTrimZero(columns[i])) > LENGTH_RSVGRPCD)
                        {
                            cooperationDao.AppendMessage(arrMessage1, arrMessage2, names[i] + "の値が長すぎます。", stdMessage2);
                            break;
                        }

                        // 予約群レコード存在チェック
                        if (!cooperationDao.CheckIntoValue(columns[i], mRsvGrpCd))
                        {
                            cooperationDao.AppendMessage(arrMessage1, arrMessage2, stdMessage1, stdMessage2);
                            break;
                        }

                        // コース予約群レコード存在チェック
                        if (!cooperationDao.CheckIntoValue(columns[i], mCourseRsvGrpCd))
                        {
                            cooperationDao.AppendMessage(arrMessage1, arrMessage2, names[i] + "は指定契約パターンのコース予約群として存在しません。", stdMessage2);
                        }
                    }
                    // セット分類コードについてはレコード存在チェックを行う
                    else if (i >= INDEX_SETCLASSCD)
                    {
                        if (!cooperationDao.CheckIntoValue(columns[i], mSetClassCd))
                        {
                            cooperationDao.AppendMessage(arrMessage1, arrMessage2, stdMessage1, stdMessage2);
                        }
                    }
                    break;
                }
            }

            // 戻り値の設定
            message1 = arrMessage1;
            message2 = arrMessage2;
        }

        /// <summary>
        /// ＣＳＶデータ内各項目値のチェックを行う
        /// </summary>
        /// <param name="noDiv">番号選択(1:従業員番号、2:保険証番号)</param>
        /// <param name="csvStream">ＣＳＶデータ</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="names">項目名の配列</param>
        /// <param name="lengths">項目長の配列</param>
        /// <param name="columns">(Out)項目値の配列</param>
        /// <param name="message1">(Out)メッセージ１</param>
        /// <param name="message2">(Out)メッセージ２</param>
        /// <returns>
        /// true   エラーなし
        /// false  エラーあり
        /// </returns>
        public bool CheckCsv(long noDiv, string csvStream, string orgCd1, string orgCd2, List<string> names, List<int> lengths, ref List<string> columns, ref List<string> message1, ref List<string> message2)
        {
            List<string> arrMessage1 = new List<string>();  //メッセージ１
            List<string> arrMessage2 = new List<string>();  //メッセージ２

            string[] arrColumns = new string[] { };         //項目値の配列
            int maxArraySize;                               //設定すべき配列の最大サイズ
            bool ret = false;

            // 初期処理
            columns = new List<string>();
            message1 = new List<string>();
            message2 = new List<string>();

            while (true)
            {
                // レコードが存在しない場合はエラー
                if ("".Equals(csvStream))
                {
                    cooperationDao.AppendMessage(arrMessage1, arrMessage2, "取り込みデータが存在しません。");
                    break;
                }

                // 一旦カンマ分離を行い、要素数がいくつ存在するかを検索
                arrColumns = csvStream.Split(',');

                // セット分類の開始インデックスまで要素が満たない場合
                if (arrColumns.Length < INDEX_SETCLASSCD)
                {
                    // セット分類は指定されていないものとし、最大要素数はその直前値までとする
                    maxArraySize = INDEX_SETCLASSCD;
                }
                // 何らかのセット分類が指定されている(正確には空のカラムを含めてセット分類列が存在する、の意)場合
                else
                {
                    // 最大要素数は今検索した配列の要素数そのものとする
                    maxArraySize = arrColumns.Length;
                }

                // レコード値の配列化
                columns = cooperationDao.SetColumnsArrayFromCsvString(csvStream, maxArraySize);

                // CSVデータの項目値チェック
                CheckColumnValue(noDiv, names, new List<string>(arrColumns), lengths, ref arrMessage1, ref arrMessage2);

                // エラー存在時は処理終了
                if (arrMessage1.Count > 0)
                {
                    break;
                }

                ret = true;

                break;
            }

            // 戻り値の編集
            columns = new List<string>(arrColumns);
            message1 = arrMessage1;
            message2 = arrMessage2;

            return ret;
        }

        /// <summary>
        /// ＣＳＶファイルから受診情報の作成を行う
        /// </summary>
        /// <param name="fileName">ＣＳＶファイル名</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="userId">ユーザＩＤ</param>`
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="startPos">読み込み開始位置</param>
        /// <param name="addrDiv">住所選択(1:自宅、2:会社)</param>
        /// <param name="noDiv">番号選択(1:従業員番号、2:保険証番号)</param>
        /// <param name="outFilePath">出力ファイルの書き出し位置</param>
        /// <param name="outFileName">(Out)出力ファイル名</param>
        /// <param name="refReadCount">(Out)読み込みレコード数</param>
        /// <param name="refWriteCount">(Out)作成受診情報数</param>
        public void ImportCsv(string fileName, string orgCd1, string orgCd2, string userId, int ctrPtCd, int startPos, int addrDiv, int noDiv, string outFilePath, ref string outFileName, ref int refReadCount, ref int refWriteCount)
        {
            List<string> names = new List<string>();      // 項目名の配列
            List<int> lengths = new List<int>();          // 項目長の配列
            List<string> vntColumns = new List<string>(); // 項目値の配列
            List<string> message1 = new List<string>();   // メッセージ１の配列
            List<string> message2 = new List<string>();   // メッセージ２の配列
            List<string> status;                          // 各受診希望日毎の検索結果

            int transId = 0;           // トランザクションＩＤ
            string title;              // 表題
            string orgSName;           // 団体略称
            string csCd = "";          // コースコード
            string csName = "";        // コース名
            string message = "";       // メッセージ
            string strDate = "";       // 契約開始日
            string endDate = "";       // 契約終了日
            string tempFileName = "";  // 出力用一時ファイル名
            string buffer = "";        // 文字列バッファ
            string outBuffer = "";     // 文字列バッファ
            int lineNo = 0;            // 行番号
            string cslDate = "";       // 受診日
            string rsvNo = "";         // 予約番号
            string perId = "";         // 個人ＩＤ
            string rsvGrpName = "";    // 予約群名称
            int readCount = 0;         // 読み込みレコード数
            int writeCount = 0;        // 作成受診情報数
            string wkFileName = "";    // ファイル名
            int ret;                  // 関数戻り値
            int i;                     // インデックス

            // CSVファイルオープン
            FileStream inFile = null;
            StreamReader inFileReader = null;

            // 出力用一時ファイルオープン
            FileStream outTempFile = null;
            StreamWriter outTempFileWriter = null;

            // 出力ファイルパス値の補正
            outFilePath = outFilePath + (outFilePath.Substring(outFilePath.Length - 1) != "\\" ? "\\" : "");

            // トランザクションＩＤの取得
            transId = hainsLogDao.IncreaseTransactionId();

            // 項目名の配列を作成
            names.Add(NAME_CSLDATE1);
            names.Add(NAME_CSLDATE2);
            names.Add(NAME_CSLDATE3);
            names.Add(NAME_RSVGRPCD);
            names.Add(NAME_NAME);
            names.Add(NAME_KNAME);
            names.Add(NAME_ROMENAME);
            names.Add(NAME_BIRTH);
            names.Add(NAME_GENDER);
            names.Add(NAME_CSLDIVCD);
            names.Add(NAME_PERID);
            names.Add(NAME_ZIPCD);
            names.Add(NAME_TEL);
            names.Add(NAME_ADDRESS);

            // 従業員番号／保険証番号については引数値に応じて設定
            switch (noDiv)
            {
                case 1:
                    names.Add(NAME_EMPNO);
                    break;
                case 2:
                    names.Add(NAME_ISRNO);
                    break;
            }

            // セット分類情報を追加
            names.Add(NAME_EMPNO);

            // 項目長の配列を作成
            lengths.Add(LENGTH_CSLDATE1);
            lengths.Add(LENGTH_CSLDATE2);
            lengths.Add(LENGTH_CSLDATE3);
            lengths.Add(LENGTH_RSVGRPCD);
            lengths.Add(LENGTH_NAME);
            lengths.Add(LENGTH_KNAME);
            lengths.Add(LENGTH_ROMENAME);
            lengths.Add(LENGTH_BIRTH);
            lengths.Add(LENGTH_GENDER);
            lengths.Add(LENGTH_CSLDIVCD);
            lengths.Add(LENGTH_PERID);
            lengths.Add(LENGTH_ZIPCD);
            lengths.Add(LENGTH_TEL);
            lengths.Add(LENGTH_ADDRESS);

            // 従業員番号／保険証番号については引数値に応じて設定
            switch (noDiv)
            {
                case 1:
                    lengths.Add(LENGTH_EMPNO);
                    break;
                case 2:
                    lengths.Add(LENGTH_ISRNO);
                    break;
            }

            // セット分類情報を追加
            lengths.Add(LENGTH_SETCLASSCD);

            // 汎用テーブルから表題を取得
            title = freeDao.SelectFree(0, TRANSACTIONDIV_RSVCSV)[0].FREENAME;

            // 汎用テーブルから受診区分を読み込む
            List<dynamic> freeList = freeDao.SelectFree(1, "CSLDIV");

            foreach (dynamic item in freeList)
            {
                mCslDivCd.Add(item.FREECD);
                mCslDivName.Add(item.FREEFIELD1);
            }

            // 都道府県名→コードへの変換情報取得
            List<dynamic> preList = prefDao.SelectPrefList();

            foreach (dynamic item in preList)
            {
                mPrefCd.Add(item.PREFCD);
                mtPrefName.Add(item.PREFNAME);
            }

            // セット分類情報の読み込み
            List<dynamic> setClassList = setClassDao.SelectSetClassList();

            foreach (dynamic item in setClassList)
            {
                mSetClassCd.Add(item.SETCLASSCD);
                mSetClassName.Add(item.SETCLASSNAME);
            }

            // 予約群情報の読み込み
            List<dynamic> scheduleList = scheduleDao.SelectRsvGrpList(0);

            foreach (dynamic item in scheduleList)
            {
                mRsvGrpCd.Add(item.RSVGRPCD);
                mRsvGrpName.Add(item.RSVGRPNAME);
            }

            // 開始ログの発行
            cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVCSV, "I", "", new List<string> { title + "処理を開始します。" }, new List<string> { "" });

            // 指定されたパラメータ情報を編集する
            while (true)
            {
                // 団体略称の取得
                dynamic orgData = organizationDao.SelectOrg_Lukes(orgCd1, orgCd2);

                // 団体情報が存在しない場合は処理終了
                if (orgData == null)
                {
                    cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVCSV, "E", "", new List<string> { "団体情報が存在しません。" }, new List<string> { "団体コード=" + orgCd1 + "-" + orgCd2 });
                    break;
                }
                else
                {
                    orgSName = orgData.ORGSNAME;
                }

                // ログ発行
                cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVCSV, "I", "", new List<string> { "■次の団体が指定されました。" }, new List<string> { "団体=" + orgSName + "（" + orgCd1 + "-" + orgCd2 + "）" });

                // 契約管理情報の読み込み
                dynamic contractData = contractDao.SelectCtrMng(orgCd1, orgCd2, ctrPtCd);

                if (contractData == null)
                {
                    cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVCSV, "E", "", new List<string> { "契約情報が存在しません。" }, new List<string> { "契約パターンコード=" + ctrPtCd });
                    break;

                }
                else
                {
                    csCd = contractData.CSCD;
                    csName = contractData.CSNAME;
                    strDate = contractData.STRDATE;
                    endDate = contractData.ENDDATE;
                }

                // コース予約群情報の読み込み
                scheduleList = scheduleDao.SelectCourseRsvGrpListSelCourse(csCd, 0);

                foreach (dynamic item in scheduleList)
                {
                    mCourseRsvGrpCd.Add(item.RSVGRPCD);
                    mCourseRsvGrpName.Add(item.RSVGRPNAME);
                }

                // ログ発行
                message = "";
                message = message + "契約パターンコード=" + ctrPtCd;
                message = message + "、";
                message = message + "コース=" + csName + "（" + csCd + "）";
                message = message + "、";
                message = message + "契約期間=" + strDate + "～" + endDate;
                cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVCSV, "I", "", new List<string> { "■次の契約情報が指定されました。" }, new List<string> { message });

                // ファイルが存在しない場合は処理を終了する
                if (!File.Exists(fileName))
                {
                    cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVCSV, "E", "", new List<string> { "ファイルが存在しません。" }, new List<string> { "ファイル名=" + fileName });
                    break;
                }

                // 一時ファイル名をランダムに作成
                tempFileName = Path.GetTempFileName();

                try
                {
                    // CSVファイルオープン
                    inFile = new FileStream(fileName, FileMode.Open);
                    inFileReader = new StreamReader(inFile);

                    // 出力用一時ファイルオープン
                    outTempFile = new FileStream(tempFileName, FileMode.Append);
                    outTempFileWriter = new StreamWriter(outTempFile);

                    // ファイル読み込み
                    while (!inFileReader.EndOfStream)
                    {
                        while (true)
                        {
                            // 検索結果の初期化
                            status = new List<string>();

                            // １行読み込み
                            buffer = inFileReader.ReadLine();

                            // 行番号をインクリメント
                            lineNo = lineNo + 1;

                            // 行番号が読み込み開始位置に達していない場合はスキップ
                            if (lineNo < startPos)
                            {
                                outTempFileWriter.WriteLine(buffer + ",,,,,,,,");
                                break;
                            }

                            // 行データが存在しない場合はスキップ
                            if ("".Equals(buffer.Trim()))
                            {
                                outTempFileWriter.WriteLine("");
                                break;
                            }

                            // 読み込みレコード数のインクリメント
                            readCount = readCount + 1;

                            // CSVデータのチェック
                            if (!CheckCsv(noDiv, buffer, orgCd1, orgCd2, names, lengths, ref vntColumns, ref message1, ref message2))
                            {
                                // データエラー時
                                // ログを発行
                                cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVCSV, "E", lineNo.ToString(), message1, message2);

                                // 出力ファイル用のレコード編集
                                outBuffer = buffer;
                                outBuffer = outBuffer + "," + "×";
                                outBuffer = outBuffer + "," + "";
                                outBuffer = outBuffer + "," + "";
                                outBuffer = outBuffer + "," + "";
                                outBuffer = outBuffer + "," + "";
                                outBuffer = outBuffer + "," + "不正なデータがあります。,,";

                                // 出力ファイル書き出し
                                outTempFileWriter.WriteLine(outBuffer);
                                break;
                            }

                            // 個人情報の作成、予約空き状況のチェック、受診情報の作成を行う
                            ret = InsertConsult(transId, userId, orgCd1, orgCd2, ctrPtCd, addrDiv, noDiv, lineNo, vntColumns, ref cslDate, ref rsvNo, ref perId, ref rsvGrpName, ref status);

                            // 出力ファイル用のレコード編集
                            outBuffer = buffer;
                            outBuffer = outBuffer + "," + (ret == 0 ? "○" : "×");
                            outBuffer = outBuffer + "," + cslDate;
                            outBuffer = outBuffer + "," + rsvNo;
                            outBuffer = outBuffer + "," + perId;
                            outBuffer = outBuffer + "," + rsvGrpName;

                            // 処理結果を追加
                            switch (ret)
                            {
                                case 0:
                                    // 正常時
                                    outBuffer = outBuffer + "," + ",,";

                                    break;
                                case -1:
                                    // 契約情報が存在しない
                                    outBuffer = outBuffer + "," + "契約情報がありません。,,";

                                    break;
                                case -2:
                                    // 指定受診区分が契約セットに存在しない
                                    outBuffer = outBuffer + "," + "受診区分が契約セットに存在しません。,,";

                                    break;
                                case -3:
                                    // 個人情報作成エラー
                                    outBuffer = outBuffer + "," + "個人情報の作成エラーが発生しました。,,";

                                    break;
                                case -4:
                                    // 個人情報が存在しない
                                    outBuffer = outBuffer + "," + "個人情報が存在しません。,,";

                                    break;
                                case -5:
                                    // カナ氏名、生年月日、性別不一致
                                    outBuffer = outBuffer + "," + "個人情報とカナ氏名、生年月日、性別が異なります。,,";

                                    break;
                                case -6:
                                    // 個人情報使用不可
                                    outBuffer = outBuffer + "," + "個人情報が使用できません。,,";

                                    break;
                                case -7:
                                    // すべての受診希望日に対して予約不可
                                    for (i = 0; i < status.Count; i++)
                                    {
                                        outBuffer = outBuffer + "," + status[i];
                                    }

                                    break;
                            }

                            // 出力ファイル書き出し
                            outTempFileWriter.WriteLine(outBuffer);

                            // 作成受診情報数のインクリメント
                            if (ret == 0)
                            {
                                writeCount = writeCount + 1;
                            }

                            break;

                        }

                    }
                    outTempFileWriter.Flush();
                }
                catch
                {
                }
                finally
                {
                    // ファイルクローズ
                    if (inFileReader != null)
                    {
                        inFileReader.Close();
                    }

                    if (inFile != null)
                    {
                        inFile.Close();
                    }

                    if (outTempFileWriter != null)
                    {
                        outTempFileWriter.Close();
                    }

                    if (outTempFile != null)
                    {
                        outTempFile.Close();
                    }
                }

                break;
            }

            // #ToDo CSVを作成する方法をどうするか
            //Set objCreateCsv = CreateObject("HainsCreateCsv.CreateCsv")

            //'重複しないファイル名取得
            //strWkFileName = objCreateCsv.GetNewFile(strOutFilePath & vntOutFileName)

            //Set objCreateCsv = Nothing

            // 出力用一時ファイルを変名
            File.Move(outFilePath + tempFileName, wkFileName);

            // パス部を除去し、戻り値として返す
            outFileName = wkFileName.Substring(wkFileName.LastIndexOf("\\", StringComparison.Ordinal) + 1);

            // 他戻り値の設定
            refReadCount = readCount;
            refWriteCount = writeCount;

            // 終了ログの発行
            cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVCSV, "I", "", new List<string> { readCount + "件のレコードが読み込まれました。" }, new List<string> { "" });
            cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVCSV, "I", "", new List<string> { writeCount + "件の受診情報が作成されました。" }, new List<string> { "" });
            cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVCSV, "I", "", new List<string> { title + "処理を終了します。" }, new List<string> { "" });
        }

        /// <summary>
        /// 個人情報の作成、予約空き状況のチェック、受診情報の作成を行う
        /// </summary>
        /// <param name="transId">トランザクションＩＤ</param>
        /// <param name="userId">ユーザＩＤ</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="addrDiv">住所選択(1:自宅、2:会社)</param>
        /// <param name="noDiv">番号選択(1:従業員番号、2:保険証番号)</param>
        /// <param name="lineNo">行番号</param>
        /// <param name="columns">項目値の配列</param>
        /// <param name="cslDate">(Out)受診日</param>
        /// <param name="rsvNo">(Out)予約番号</param>
        /// <param name="perId">(Out)個人ＩＤ</param>
        /// <param name="rsvGrpName">(Out)予約群名称</param>
        /// <param name="status">(Out)各受診希望日毎の検索結果</param>
        /// <returns>※ストアドが完璧になってから記述する</returns>
        private int InsertConsult(int transId, string userId,
                                string orgCd1, string orgCd2,
                                int ctrPtCd, int addrDiv,
                                int noDiv, int lineNo, List<string> columns,
                                ref string cslDate, ref string rsvNo,
                                ref string perId, ref string rsvGrpName, ref List<string> status)
        {
            string sql = "";                            // SQLステートメント
            string lastName = "";                       // 姓
            string firstName = "";                      // 名
            string prefCd = "";                         // 都道府県コード
            string cityName = "";                       // 市区町村コード
            string address1 = "";                       // 住所１
            string address2 = "";                       // 住所２
            int lngSetClassCount;                       // セット分類数
            int i;                                      // インデックス
            DateTime[] cslDateArr = new DateTime[3];    // 受診希望日
            List<string> classCd = new List<string>();  // セット分類

            // 初期処理
            cslDate = "";
            rsvNo = "";
            perId = "";
            rsvGrpName = "";

            // 受診情報登録用ストアドパッケージの関数呼び出し
            sql = @"
                    begin :ret := consultallpackage.insertconsultfromperid(
                ";

            sql += @"
                    :transid
                    , :transdiv
                    , :upduser
                    , :orgcd1
                    , :orgcd2
                    , :ctrptcd
                    , :addrdiv
                    , :lineno
                    , :csldate
                    , :rsvgrpcd
                    , :lastname
                    , :firstname
                    , :lastkname
                    , :firstkname
                    , :romename
                    , :birth
                    , :gender
                ";

            sql += @"
                    ,:csldivcd
                    , :perid
                    , :zipcd
                    , :prefcd
                    , :cityname
                    , :address1
                    , :address2
                    , :tel
                    , :empno
                    , :isrno
                    , :setclasscd
                    , :entcsldate
                    , :rsvno
                    , :entperid
                    , :rsvgrpname
                    , :message
                ";

            sql += @"
                    );
                    end;
                ";

            using (var cmd = new OracleCommand())
            {
                // パラメータ設定
                // 共通項目
                cmd.Parameters.Add("transid", OracleDbType.Decimal, transId, ParameterDirection.Input);
                cmd.Parameters.Add("transdiv", OracleDbType.Varchar2, TRANSACTIONDIV_RSVCSV, ParameterDirection.Input);
                cmd.Parameters.Add("upduser", OracleDbType.Varchar2, userId, ParameterDirection.Input);
                cmd.Parameters.Add("orgcd1", OracleDbType.Varchar2, orgCd1, ParameterDirection.Input);
                cmd.Parameters.Add("orgcd2", OracleDbType.Varchar2, orgCd2, ParameterDirection.Input);
                cmd.Parameters.Add("ctrptcd", OracleDbType.Decimal, ctrPtCd, ParameterDirection.Input);
                cmd.Parameters.Add("addrdiv", OracleDbType.Decimal, addrDiv, ParameterDirection.Input);
                cmd.Parameters.Add("lineno", OracleDbType.Decimal, lineNo, ParameterDirection.Input);

                // 受診希望日の編集
                if (columns[INDEX_CSLDATE1] != "")
                {
                    cslDateArr[0] = Convert.ToDateTime(cooperationDao.CnvDate(columns[INDEX_CSLDATE1]));
                }
                if (columns[INDEX_CSLDATE2] != "")
                {
                    cslDateArr[1] = Convert.ToDateTime(cooperationDao.CnvDate(columns[INDEX_CSLDATE2]));
                }
                if (columns[INDEX_CSLDATE3] != "")
                {
                    cslDateArr[2] = Convert.ToDateTime(cooperationDao.CnvDate(columns[INDEX_CSLDATE3]));
                }

                // 受診希望日のバインド配列
                cmd.Parameters.AddTable("csldate", cslDateArr, ParameterDirection.Input, OracleDbType.Date, cslDateArr.Length, (int)CSLDATE_MAXCOUNT);

                // 予約群を第３受診希望日と漢字氏名の間に追加
                cmd.Parameters.Add("rsvgrpcd", OracleDbType.Decimal, (columns[INDEX_RSVGRPCD] != "" ? Convert.ToInt32("0" + columns[INDEX_RSVGRPCD]) : 0), ParameterDirection.Input);

                // 氏名を姓名に分割して編集
                cooperationDao.SplitName(columns[INDEX_NAME], ref lastName, ref firstName);
                cmd.Parameters.Add("lastname", OracleDbType.Varchar2, lastName, ParameterDirection.Input);
                cmd.Parameters.Add("firstname", OracleDbType.Varchar2, firstName, ParameterDirection.Input);

                // カナ氏名を姓名に分割して編集
                cooperationDao.SplitName(columns[INDEX_KNAME], ref lastName, ref firstName);
                cmd.Parameters.Add("lastkname", OracleDbType.Varchar2, lastName, ParameterDirection.Input);
                cmd.Parameters.Add("firstkname", OracleDbType.Varchar2, firstName, ParameterDirection.Input);

                // ローマ字名をカナ名と生年月日の間に追加
                cmd.Parameters.Add("romename", OracleDbType.Varchar2, Convert.ToString(columns[INDEX_ROMENAME]), ParameterDirection.Input);

                // 生年月日、性別、受診区分コード、個人ＩＤ
                cmd.Parameters.Add("birth", OracleDbType.Date, Convert.ToDateTime(cooperationDao.CnvDate(columns[INDEX_BIRTH])), ParameterDirection.Input);
                cmd.Parameters.Add("gender", OracleDbType.Decimal, Convert.ToInt32(columns[INDEX_GENDER]), ParameterDirection.Input);
                cmd.Parameters.Add("csldivcd", OracleDbType.Varchar2, Convert.ToString(columns[INDEX_CSLDIVCD]), ParameterDirection.Input);
                cmd.Parameters.Add("perid", OracleDbType.Varchar2, Convert.ToString(columns[INDEX_PERID].TrimStart('0')), ParameterDirection.Input);

                // 郵便番号はハイフンを除去
                cmd.Parameters.Add("zipcd", OracleDbType.Varchar2, Convert.ToString(columns[INDEX_ZIPCD].Replace("-", "")).ToString(), ParameterDirection.Input);

                // 住所を分割して編集
                SplitAddress(columns[INDEX_ADDRESS], ref prefCd, ref cityName, ref address1, ref address2);
                cmd.Parameters.Add("prefcd", OracleDbType.Varchar2, prefCd, ParameterDirection.Input);
                cmd.Parameters.Add("cityname", OracleDbType.Varchar2, cityName, ParameterDirection.Input);
                cmd.Parameters.Add("address1", OracleDbType.Varchar2, address1, ParameterDirection.Input);
                cmd.Parameters.Add("address2", OracleDbType.Varchar2, address2, ParameterDirection.Input);

                // 電話番号
                cmd.Parameters.Add("tel", OracleDbType.Varchar2, Convert.ToString(columns[INDEX_TEL]), ParameterDirection.Input);

                // 従業員番号、保険証番号は引数値に応じて編集
                switch (noDiv)
                {
                    case 1:
                        cmd.Parameters.Add("empno", OracleDbType.Varchar2, Convert.ToString(columns[INDEX_EMPNO]), ParameterDirection.Input);
                        cmd.Parameters.Add("isrno", OracleDbType.Varchar2, null, ParameterDirection.Input);
                        break;
                    case 2:
                        cmd.Parameters.Add("empno", OracleDbType.Varchar2, null, ParameterDirection.Input);
                        cmd.Parameters.Add("isrno", OracleDbType.Varchar2, Convert.ToString(columns[INDEX_EMPNO]), ParameterDirection.Input);
                        break;
                    default:
                        cmd.Parameters.Add("empno", OracleDbType.Varchar2, null, ParameterDirection.Input);
                        cmd.Parameters.Add("isrno", OracleDbType.Varchar2, null, ParameterDirection.Input);
                        break;
                }


                // セット分類のバインド配列定義に際し、セット分類数を求める
                // (項目値配列のセット分類開始位置以降はすべてセット分類とみなす)
                lngSetClassCount = columns.Count - (INDEX_SETCLASSCD - 1);

                // ただし上記の式でセット分類数が得られない場合、セット分類数は暫定で１とする
                // (OO4Oからストアドへ索引付き表を渡す際、配列の要素数が０では異常終了する)
                if (lngSetClassCount <= 0)
                {
                    lngSetClassCount = 1;
                }

                // セット分類の編集
                for (i = INDEX_SETCLASSCD; i <= columns.Count; i++)
                {
                    classCd.Add(Convert.ToString(columns[i]));
                }

                // セット分類のバインド配列定義
                cmd.Parameters.AddTable("setclasscd", classCd.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, lngSetClassCount, LENGTH_SETCLASSCD);

                // 出力用のバインド変数定義
                OracleParameter ret = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);
                OracleParameter entcsldate = cmd.Parameters.Add("entcsldate", OracleDbType.Date, ParameterDirection.Output);
                OracleParameter rsvno = cmd.Parameters.Add("rsvno", OracleDbType.Int32, ParameterDirection.Output);
                OracleParameter entperid = cmd.Parameters.Add("entperid", OracleDbType.Varchar2, ParameterDirection.Output);
                OracleParameter rsvgrpname = cmd.Parameters.Add("rsvgrpname", OracleDbType.Varchar2, ParameterDirection.Output);

                // 受診希望日毎の検索結果用バインド配列
                OracleParameter message = cmd.Parameters.AddTable("message", ParameterDirection.Output, OracleDbType.Varchar2, (int)CSLDATE_MAXCOUNT, 256);

                // PL/SQL文の実行
                ExecuteNonQuery(cmd, sql);

                // 戻り値の取得
                cslDate = Convert.ToString((OracleDecimal)entcsldate.Value);
                rsvNo = Convert.ToString((OracleDecimal)rsvno.Value);
                perId = Convert.ToString((OracleDecimal)entperid.Value);
                rsvGrpName = Convert.ToString((OracleDecimal)rsvgrpname.Value);
                status = ((OracleString[])message.Value).Select(s => s.Value).ToList();

                // 戻り値の設定
                return ((OracleDecimal)ret.Value).ToInt32();
            }
        }

        /// <summary>
        /// 先頭からのゼロ値を除去
        /// </summary>
        /// <param name="strExpression">文字列式</param>
        /// <returns>トリミング後の値</returns>
        private string LTrimZero(string strExpression)
        {
            string strBuffer = "";  // 文字列編集用バッファ

            while (true)
            {
                strBuffer = strExpression.Trim();

                // 未指定時は何もしない
                if (strBuffer == "")
                {
                    break;
                }

                // 半角数字チェック
                if (!cooperationDao.CheckNumber(strBuffer))
                {
                    break;
                }

                // ゼロトリミング
                strBuffer.TrimStart('0');
                break;
            }

            return strBuffer;
        }

        /// <summary>
        /// 住所の分割
        /// </summary>
        /// <param name="address">住所</param>
        /// <param name="prefCd">(Out)都道府県コード</param>
        /// <param name="cityName">(Out)市区町村コード</param>
        /// <param name="address1">(Out)住所１</param>
        /// <param name="address2">(Out)住所２</param>
        public void SplitAddress(string address, ref string prefCd, ref string cityName, ref string address1, ref string address2)
        {
            // 初期処理
            prefCd = "";
            cityName = "";
            address1 = "";
            address2 = "";

            address = address.Trim();
            if ("".Equals(address))
            {
                return;
            }

            // 全角変換(さもないと区切り位置が全角文字の１バイト目と２バイト目の間に発生することがある)
            address = Strings.StrConv(address, VbStrConv.Wide);

            // 先頭文字が都道府県変換情報の都道府県名と一致するかを検索
            for (int i = 0; i < mPrefCd.Count; i++)
            {
                if (address.IndexOf(mtPrefName[i], StringComparison.Ordinal) == 0)
                {
                    // 一致する場合、都道府県名は対応するコードに変換し、住所本体からは除外
                    prefCd = mPrefCd[i];
                    address = address.Substring(mtPrefName[i].Length);
                    break;
                }
            }

            // 残りを50バイト(市区町村コード)、60バイト(住所１)、60バイト(住所２)に分割
            // (ただしCSVデータでは何バイト存在するかわからない。そこでここでは住所２に残りをありったけ格納し、あとは項目長チェックに委ねる。)
            cityName = address.Substring(0, 25);
            address1 = address.Substring(25, 30);

            if (address.Length > 55)
            {
                address1 = address.Substring(address.Length - (address.Length - 55));
            }

            return;
        }
    }
}
