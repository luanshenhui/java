using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity.Model.Bill;
using Microsoft.VisualBasic;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;

namespace Hainsi.Entity
{
    /// <summary>
    /// CSVファイルからの一括入金処理用データアクセスオブジェクト
    /// </summary>
    public class PaymentImportCsvDao : AbstractDao
    {
        /// <summary>
        /// 請求情報データアクセスオブジェクト
        /// </summary>
        readonly DemandDao demandDao;

        /// <summary>
        /// 一括入金処理用データアクセスオブジェクト
        /// </summary>
        readonly PaymentAutoDao paymentAutoDao;

        /// <summary>
        /// ログ情報データアクセスオブジェクト
        /// </summary>
        readonly HainsLogDao hainsLogDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        /// <param name="demandDao">請求データアクセスオブジェクト</param>
        /// <param name="paymentAutoDao">自動入金データアクセスオブジェクト</param>
        /// <param name="hainsLogDao">ログデータアクセスオブジェクト</param>
        public PaymentImportCsvDao(IDbConnection connection, DemandDao demandDao, PaymentAutoDao paymentAutoDao, HainsLogDao hainsLogDao) : base(connection)
        {
            this.demandDao = demandDao;
            this.paymentAutoDao = paymentAutoDao;
            this.hainsLogDao = hainsLogDao;
        }

        // 項目位置情報
        private const int INDEX_REQUEST_DATE = 0;                //請求依頼日
        private const int INDEX_SLIP_NO = 1;                     //請求書番号
        private const int INDEX_BOOK_DATE = 2;                   //起票日
        private const int INDEX_BOOK_USER_ID = 3;                //起票者ユーザID
        private const int INDEX_H_SECTION_CODE = 4;              //起票部門コード
        private const int INDEX_CUSTOMER_CODE = 5;               //団体コード
        private const int INDEX_TOTAL_AMOUNT = 6;                //合計金額
        private const int INDEX_TE_TOTAL_AMOUNT = 7;             //合計金額（税抜き）
        private const int INDEX_TAX_FIX = 8;                     //税額
        private const int INDEX_EXTRA_TEXT1 = 9;                 //予備テキスト１
        private const int INDEX_EXTRA_DATE1 = 10;                //予備日付１
        private const int INDEX_ACCOUNT_DATE = 11;               //入金日
        private const int INDEX_CLEARING_DATE = 12;              //計上日

        // 項目長情報
        private const int LENGTH_REQUEST_DATE = 0;                //請求依頼日
        private const int LENGTH_SLIP_NO = 14;                    //請求書番号
        private const int LENGTH_BOOK_DATE = 0;                   //起票日
        private const int LENGTH_BOOK_USER_ID = 32;               //起票者ユーザID
        private const int LENGTH_H_SECTION_CODE = 22;             //起票部門コード
        private const int LENGTH_CUSTOMER_CODE = 10;              //団体コード
        private const int LENGTH_TOTAL_AMOUNT = 22;               //合計金額
        private const int LENGTH_TE_TOTAL_AMOUNT = 22;            //合計金額（税抜き）
        private const int LENGTH_TAX_FIX = 22;                    //税額
        private const int LENGTH_EXTRA_TEXT1 = 200;               //予備テキスト１
        private const int LENGTH_EXTRA_DATE1 = 0;                 //予備日付１
        private const int LENGTH_ACCOUNT_DATE = 0;                //入金日
        private const int LENGTH_CLEARING_DATE = 0;               //計上日

        // 項目名情報
        private const string NAME_REQUEST_DATE = "請求依頼日";            //請求依頼日
        private const string NAME_SLIP_NO = "請求書番号";                 //請求書番号
        private const string NAME_BOOK_DATE = "起票日";                   //起票日
        private const string NAME_BOOK_USER_ID = "起票者ユーザID";        //起票者ユーザID
        private const string NAME_H_SECTION_CODE = "起票部門コード";      //起票部門コード
        private const string NAME_CUSTOMER_CODE = "団体コード";           //団体コード
        private const string NAME_TOTAL_AMOUNT = "合計金額";              //合計金額
        private const string NAME_TE_TOTAL_AMOUNT = "合計金額（税抜き）"; //合計金額（税抜き）
        private const string NAME_TAX_FIX = "税額";                       //税額
        private const string NAME_EXTRA_TEXT1 = "予備テキスト１";         //予備テキスト１
        private const string NAME_EXTRA_DATE1 = "予備日付１";             //予備日付１
        private const string NAME_ACCOUNT_DATE = "入金日";                //入金日
        private const string NAME_CLEARING_DATE = "計上日";               //計上日

        private const int LENGTH_BILLNO = 14;                             //'請求書番号

        private const string TRANSACTIONDIV_PAYMENTCSV = "LOGPAYCSV";         // ＣＳＶ一括予約用のログ処理ＩＤ

        /// <summary>
        /// 配列に格納されたＣＳＶデータのチェックを行う
        /// </summary>
        /// <param name="names">項目名</param>
        /// <param name="columns">カラム値</param>
        /// <param name="lengths">項目長</param>
        /// <param name="message1">メッセージ１</param>
        /// <param name="message2">メッセージ２</param>
        public void CheckColumnValue(string[] names, ref string[] columns, string[] lengths, ref List<string> message1, ref List<string> message2)
        {
            string message;                               //メッセージ
            List<string> arrMessage1 = new List<string>();//メッセージ１
            List<string> arrMessage2 = new List<string>();//メッセージ２
            string stdMessage1;                           //基本メッセージ１
            string stdMessage2;                           //基本メッセージ２
            long nameIndex;                               //項目名情報のインデックス
            bool tooLong;                                 //項目長が長すぎる場合にTrue

            // 基本メッセージの作成(請求番号と金額をもって基本メッセージとする)
            message = "";
            message = message + NAME_CUSTOMER_CODE + "=" + ((!"".Equals(columns[INDEX_CUSTOMER_CODE])) ? columns[INDEX_CUSTOMER_CODE] : "なし");
            message = message + "、";
            message = message + NAME_SLIP_NO + "=" + ((!"".Equals(columns[INDEX_SLIP_NO])) ? columns[INDEX_SLIP_NO] : "なし");
            message = message + "、";
            message = message + NAME_TOTAL_AMOUNT + "=" + ((!"".Equals(columns[INDEX_TOTAL_AMOUNT])) ? columns[INDEX_TOTAL_AMOUNT] : "なし");

            // 項目単位のチェック
            for (int i = 0; i < columns.Length; i++)
            {
                // セット分類に注意しつつ、現在チェック対象である項目の、項目名情報におけるインデックスを定義
                nameIndex = Convert.ToInt32((i >= INDEX_CLEARING_DATE ? INDEX_CLEARING_DATE : i));

                // 必須項目のチェック
                switch (i)
                {
                    // 請求書番号、起票部門コード、団体コード、合計金額、計上日は必須チェックを行う
                    case INDEX_SLIP_NO:
                    case INDEX_H_SECTION_CODE:
                    case INDEX_CUSTOMER_CODE:
                    case INDEX_TOTAL_AMOUNT:
                    case INDEX_CLEARING_DATE:

                        if ("".Equals(columns[i]))
                        {
                            paymentAutoDao.AppendMessage(ref arrMessage1, ref arrMessage2, names[i] + "が設定されていません。", message);
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
                    switch (i)
                    {
                        case INDEX_SLIP_NO:
                            //#ToDo LenB について　どうするか？
                            if (WebHains.LenB(Strings.StrConv(columns[i], VbStrConv.SimplifiedChinese)) > Convert.ToInt32(lengths[i]))
                            {
                                paymentAutoDao.AppendMessage(ref arrMessage1, ref arrMessage2, stdMessage1, stdMessage2);
                                tooLong = true;
                            }
                            break;

                        // 請求依頼日、起票日、入金日、計上日については日付形式のため以降のチェックを行う
                        case INDEX_REQUEST_DATE:
                        case INDEX_BOOK_DATE:
                        case INDEX_ACCOUNT_DATE:
                        case INDEX_CLEARING_DATE:

                            break;
                    }

                    // 項目長エラー時は処理を抜ける
                    if (tooLong)
                    {
                        break;
                    }

                    // 基本メッセージの作成
                    stdMessage1 = names[nameIndex] + "が無効です。";

                    // 項目タイプごとのチェック
                    switch (i)
                    {
                        // 請求依頼日、起票日、入金日、計上日については日付チェックを行う
                        case INDEX_REQUEST_DATE:
                        case INDEX_BOOK_DATE:
                        case INDEX_ACCOUNT_DATE:
                        case INDEX_CLEARING_DATE:

                            if ("".Equals(paymentAutoDao.CnvDate(columns[i])))
                            {
                                paymentAutoDao.AppendMessage(ref arrMessage1, ref arrMessage2, names[i] + "が日付として認識できません。", stdMessage2);
                            }

                            break;

                            // default:
                            // プロシージャの呼び出し、または引数が不正です。
                            // throw new ArgumentException();
                    }
                    break;
                }
            }
            message1 = arrMessage1;
            message2 = arrMessage2;

        }

        /// <summary>
        /// ＣＳＶデータ内各項目値のチェックを行う
        /// </summary>
        /// <param name="csvStream">ＣＳＶデータ</param>
        /// <param name="names">項目名の配列</param>
        /// <param name="lengths">項目長の配列</param>
        /// <param name="columns">項目値の配列</param>
        /// <param name="message1">メッセージ１</param>
        /// <param name="message2">メッセージ２</param>
        /// <returns>
        /// True   エラーなし
        /// False  エラーあり
        /// </returns>
        public bool CheckCsv(string csvStream, string[] names, string[] lengths, ref string[] columns, ref List<string> message1, ref List<string> message2)
        {
            List<string> arrMessage1 = new List<string>();  //メッセージ１
            List<string> arrMessage2 = new List<string>();  //メッセージ２
            string[] arrColumns = new string[] { };                            //項目値の配列
            int maxArraySize;                               //設定すべき配列の最大サイズ
            bool ret = false;

            while (true)
            {
                // レコードが存在しない場合はエラー
                if ("".Equals(csvStream))
                {
                    paymentAutoDao.AppendMessage(ref arrMessage1, ref arrMessage2, "取り込みデータが存在しません。");
                    break;
                }

                // 一旦カンマ分離を行い、要素数がいくつ存在するかを検索
                arrColumns = csvStream.Split(',');

                // 最大要素数は今検索した配列の要素数そのものとする
                maxArraySize = arrColumns.Length;

                // レコード値の配列化
                arrColumns = paymentAutoDao.SetColumnsArrayFromCsvString(csvStream, maxArraySize);

                // CSVデータの項目値チェック
                CheckColumnValue(names, ref arrColumns, lengths, ref arrMessage1, ref arrMessage2);

                // エラー存在時は処理終了
                if (arrMessage1.Count > 0)
                {
                    break;
                }

                ret = true;

                break;
            }
            columns = arrColumns;
            message1 = arrMessage1;
            message2 = arrMessage2;

            return ret;
        }

        /// <summary>
        /// ＣＳＶファイルから入金情報の作成を行う
        /// </summary>
        /// <param name="filePath">ＣＳＶファイルpath</param>
        /// <param name="fileName">ＣＳＶファイル名</param>
        /// <param name="userId">ユーザＩＤ</param>
        /// <param name="startPos">読み込み開始位置</param>
        /// <param name="outFilePath">出力ファイルの書き出し位置</param>
        /// <param name="outFileName">出力ファイル名</param>
        /// <param name="refReadCount">読み込みレコード数</param>
        /// <param name="refWriteCount">作成受診情報数</param>
        public void ImportCsv(string filePath, string fileName, string userId, long startPos, string outFilePath, ref string outFileName, ref string refReadCount, ref string refWriteCount)
        {
            long transId;                                      // トランザクションＩＤ
            string vntTitle = "";                              // 表題
            string[] names;                                    // 項目名の配列
            long elemCount;                                    // 配列の要素数
            string[] lengths;                                  // 項目長の配列
            string[] columns;                                  // 項目値の配列
            string tempFileName;                               // 出力用一時ファイル名
            string buffer = "";                                // 文字列バッファ
            string outBuffer = "";                             // 文字列バッファ
            int lineNo = 0;                                    // 行番号
            string billNo = "";                                // 請求番号（締め日＋請求書SEQ＋請求書枝番）
            string ogrName = "";                               // 団体名称
            string billPrice = "";                             // 請求額（Hains）
            string paymentPrice = "";                          // 入金額（Hains）
            string totalAmount = "";                           // 入金額（COMPANY）
            int readCount = 0;                                 // 読み込みレコード数
            int writeCount = 0;                                // 作成受診情報数
            List<string> message1 = new List<string> { };      // メッセージ１の配列
            List<string> message2 = new List<string> { };      // メッセージ２の配列
            int ret;                                           // 関数戻り値
            string wkFileName = "";                            // ファイル名
            string num = "";
            // CSVファイルオープン
            FileStream inFile = null;
            StreamReader inFileReader = null;

            // 出力用一時ファイルオープン
            FileStream outTempFile = null;
            StreamWriter outTempFileWriter = null;

            // 出力ファイルパス値の補正
            outFilePath = outFilePath + ((!"\\".Equals(outFilePath.Substring(outFilePath.Length - 1))) ? "\\" : "");

            // トランザクションＩＤの取得
            transId = hainsLogDao.IncreaseTransactionId();

            // 項目名の配列を作成
            names = new string[] { NAME_REQUEST_DATE, NAME_SLIP_NO, NAME_BOOK_DATE, NAME_BOOK_USER_ID, NAME_H_SECTION_CODE, NAME_CUSTOMER_CODE, NAME_TOTAL_AMOUNT, NAME_TE_TOTAL_AMOUNT, NAME_TAX_FIX, NAME_EXTRA_TEXT1, NAME_EXTRA_DATE1, NAME_ACCOUNT_DATE, NAME_CLEARING_DATE };
            elemCount = names.Length + 1;

            // 項目長の配列を作成
            lengths = new string[] { Convert.ToString(LENGTH_REQUEST_DATE), Convert.ToString(LENGTH_SLIP_NO), Convert.ToString(LENGTH_BOOK_DATE), Convert.ToString(LENGTH_BOOK_USER_ID), Convert.ToString(LENGTH_H_SECTION_CODE), Convert.ToString(LENGTH_CUSTOMER_CODE), Convert.ToString(LENGTH_TOTAL_AMOUNT), Convert.ToString(LENGTH_TE_TOTAL_AMOUNT), Convert.ToString(LENGTH_TAX_FIX), Convert.ToString(LENGTH_EXTRA_TEXT1), Convert.ToString(LENGTH_EXTRA_DATE1), Convert.ToString(LENGTH_ACCOUNT_DATE), Convert.ToString(LENGTH_CLEARING_DATE) };
            elemCount = lengths.Length + 1;

            columns = new string[] { };

            // 開始ログの発行
            this.paymentAutoDao.PutHainsLog(transId, TRANSACTIONDIV_PAYMENTCSV, "I", "", new List<string> { vntTitle + "処理を開始します。" }, new List<string> { "" });

            // 指定されたパラメータ情報を編集する
            while (true)
            {
                // ファイルが存在しない場合は処理を終了する
                if (!File.Exists(filePath))
                {
                    this.paymentAutoDao.PutHainsLog(transId, TRANSACTIONDIV_PAYMENTCSV, "E", "", new List<string> { "ファイルが存在しません。" }, new List<string> { "ファイル名=" + fileName });
                }

                // 一時ファイル名をランダムに作成
                tempFileName = Path.GetTempFileName();

                try
                {
                    // CSVファイルオープン
                    inFile = new FileStream(filePath, FileMode.Open);
                    inFileReader = new StreamReader(inFile, Encoding.Default);

                    // 出力用一時ファイルオープン
                    outTempFile = new FileStream(tempFileName, FileMode.Append);
                    outTempFileWriter = new StreamWriter(outTempFile, Encoding.Default);
                    // ファイル読み込み
                    while (!inFileReader.EndOfStream)
                    {
                        while (true)
                        {
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

                            // データエラー時
                            if (!CheckCsv(buffer, names, lengths, ref columns, ref message1, ref message2))
                            {
                                // ログを発行
                                this.paymentAutoDao.PutHainsLog(transId, TRANSACTIONDIV_PAYMENTCSV, "E", Convert.ToString(lineNo), message1, message2);

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

                            // 請求情報チェック、入金情報チェック、入金情報の作成を行う
                            ret = InsertPayment(userId, lineNo, columns, ref billNo, ref ogrName, ref billPrice, ref paymentPrice, ref totalAmount);

                            // 出力ファイル用のレコード編集
                            outBuffer = buffer;
                            outBuffer = outBuffer + "," + (ret == 1 ? "○" : "×");
                            outBuffer = outBuffer + "," + billNo;
                            outBuffer = outBuffer + "," + ogrName;
                            outBuffer = outBuffer + "," + billPrice;
                            outBuffer = outBuffer + "," + paymentPrice;
                            outBuffer = outBuffer + "," + totalAmount;

                            // 処理結果を追加
                            switch (ret)
                            {
                                case 0:  // 正常時

                                    outBuffer = outBuffer + "," + "正常に入金処理できました。,,";
                                    break;
                                case 1:  // 正常時

                                    outBuffer = outBuffer + "," + "正常に入金処理できました。,,";
                                    break;
                                case -1: // 請求情報が存在しない

                                    outBuffer = outBuffer + "," + "請求情報がありません。,,";
                                    break;
                                case -2:  // 既に入金情報が存在する（入金済）

                                    outBuffer = outBuffer + "," + "既に入金情報が存在します。,,";
                                    break;
                                case -3:  // 請求額と入金額が異なる

                                    outBuffer = outBuffer + "," + "請求額と入金額が一致しません。,,";
                                    break;
                                case -4:  // 取消請求情報

                                    outBuffer = outBuffer + "," + "取消請求情報です。,,";
                                    break;
                                case -5:  // 団体コードが異なる

                                    outBuffer = outBuffer + "," + "団体情報が一致しません。,,";
                                    break;
                            }

                            // 出力ファイル書き出し
                            outTempFileWriter.WriteLine(outBuffer);

                            // 作成受診情報数のインクリメント
                            if (ret == 1)
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
            // Set objCreateCsv = CreateObject("HainsCreateCsv.CreateCsv")
            // 重複しないファイル名取得
            // strWkFileName = objCreateCsv.GetNewFile(strOutFilePath & vntOutFileName)

            while (true)
            {
                wkFileName = outFilePath + outFileName;
                if (File.Exists(wkFileName))
                {
                    num = outFileName.Substring(outFileName.LastIndexOf("(") + 1, outFileName.LastIndexOf(")") - outFileName.LastIndexOf("(") - 1);
                    bool rel = true;
                    foreach (char c in num)
                    {
                        if ("0123456789".IndexOf(c.ToString()) < 0)
                        {
                            rel = false;
                            outFileName = outFileName.Replace(".", "(1).");
                            break;
                        }
                    }
                    if (rel)
                    {
                        outFileName = outFileName.Replace("(" + num + ")", "(" + (Convert.ToInt32(num) + 1) + ")");
                    }
                }
                else
                {
                    break;
                }
            }
            // 出力用一時ファイルを変名
            File.Move(tempFileName, wkFileName);
            File.Delete(filePath);
            // パス部を除去し、戻り値として返す
            outFileName = wkFileName.Substring(wkFileName.LastIndexOf("\\") + 1);

            // 他戻り値の設定
            if (String.IsNullOrEmpty(refReadCount))
            {
                refReadCount = Convert.ToString(readCount);
            }

            if (String.IsNullOrEmpty(refWriteCount))
            {
                refWriteCount = Convert.ToString(writeCount);
            }

            // 終了ログの発行
            this.paymentAutoDao.PutHainsLog(transId, TRANSACTIONDIV_PAYMENTCSV, "I", "", new List<string> { Convert.ToString(readCount) + "件のレコードが読み込まれました。" }, new List<string> { "" });
            this.paymentAutoDao.PutHainsLog(transId, TRANSACTIONDIV_PAYMENTCSV, "I", "", new List<string> { Convert.ToString(writeCount) + "件の入金情報が作成されました。" }, new List<string> { "" });
            this.paymentAutoDao.PutHainsLog(transId, TRANSACTIONDIV_PAYMENTCSV, "I", "", new List<string> { Convert.ToString(vntTitle) + "処理を終了します。" }, new List<string> { "" });
        }

        /// <summary>
        /// 入金情報を挿入する
        /// </summary>
        /// <param name="userId">ユーザＩＤ</param>
        /// <param name="lineNo">行番号</param>
        /// <param name="columns">項目値の配列</param>
        /// <param name="billNo">請求番号</param>
        /// <param name="orgName">団体名称</param>
        /// <param name="billPrice">請求額</param>
        /// <param name="paymentPrice">入金額（Hains）</param>
        /// <param name="totalAmount">入金額（COMPANY）</param>
        /// <returns>
        /// 1   正常終了
        /// -1  異常終了
        /// </returns>
        public int InsertPayment(string userId, long lineNo, string[] columns, ref string billNo, ref string orgName, ref string billPrice, ref string paymentPrice, ref string totalAmount)
        {
            string sql;                  // SQLステートメント

            string closeDate = "";       // 締め日
            long billSeq = 0;            // 請求書SEQ
            long branchNo = 0;           // 請求書枝番

            long delFlg;                 // 取消区分
            long localBillPrice;         // 請求額
            long localPaymentPrice = 0;  // 入金額

            string orgCd;                // 団体コード

            int ret = 0;                 // 関数戻り値
            bool isBillNo;               // パラメタに請求書番号が指定されている


            isBillNo = false;

            // 請求書番号の妥当性チェック
            if (!"".Equals(columns[INDEX_SLIP_NO].Trim()))
            {
                billNo = columns[INDEX_SLIP_NO].Trim();

                if (Util.IsNumber(billNo))
                {
                    if (Convert.ToDouble(billNo) > 0)
                    {
                        if (billNo.Length == LENGTH_BILLNO)
                        {
                            // 請求書番号を分解
                            closeDate = billNo.Substring(0, 4) + "/" + billNo.Substring(4, 2) + "/" + billNo.Substring(6, 2);
                            billSeq = Convert.ToInt32(billNo.Substring(8, 5));
                            branchNo = Convert.ToInt32(billNo.Substring(13, 1));
                            if (Information.IsDate(closeDate))
                            {
                                isBillNo = true;
                            }

                        }
                    }
                }
            }

            // 請求書番号が正しく指定されていない場合はエラー
            if (!isBillNo)
            {
                throw new ArgumentException();
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("closedate", closeDate);
            param.Add("billseq", billSeq);
            param.Add("branchno", branchNo);

            // 請求情報、入金情報チェック
            sql = @"
                    select
                      bill.closedate as closedate
                      , bill.billseq as billseq
                      , bill.branchno as branchno
                      , bill.delflg as delflg
                      , bill.orgcd1 || '-' || bill.orgcd2 as orgcd
                      , org.orgname as orgname
                      , nvl(totalbase.total, 0) + nvl(totalbase_items.total, 0) as billprice
                      , nvl(paymentbase.paymentprice, 0) as paymentprice
                ";

            sql += @"
                    from
                      bill
                      , org
                      , (
                        select
                          closedate
                          , billseq
                          , branchno
                          , sum(price + editprice + taxprice + edittax) total
                        from
                          billdetail
                        where
                          closedate = :closedate
                          and billseq = :billseq
                          and branchno = :branchno
                        group by
                          closedate
                          , billseq
                          , branchno
                      ) totalbase
                 ";
            sql += @"
                    , (
                      select
                        closedate
                        , billseq
                        , branchno
                        , sum(price + editprice + taxprice + edittax) total
                      from
                        billdetail_items
                      where
                        closedate = :closedate
                        and billseq = :billseq
                        and branchno = :branchno
                      group by
                        closedate
                        , billseq
                        , branchno
                    ) totalbase_items
                 ";
            sql += @"
                    , (
                      select
                        closedate
                        , billseq
                        , branchno
                        , sum(paymentprice) paymentprice
                      from
                        payment
                      where
                        closedate = :closedate
                        and billseq = :billseq
                        and branchno = :branchno
                      group by
                        closedate
                        , billseq
                        , branchno
                    ) paymentbase
                 ";

            sql += @"
                    where
                      bill.closedate = :closedate
                      and bill.billseq = :billseq
                      and bill.branchno = :branchno
                      and org.orgcd1 = bill.orgcd1
                      and org.orgcd2 = bill.orgcd2
                      and bill.closedate = totalbase.closedate(+)
                      and bill.billseq = totalbase.billseq(+)
                      and bill.branchno = totalbase.branchno(+)
                      and bill.closedate = paymentbase.closedate(+)
                      and bill.billseq = paymentbase.billseq(+)
                      and bill.branchno = paymentbase.branchno(+)
                      and bill.closedate = totalbase_items.closedate(+)
                      and bill.billseq = totalbase_items.billseq(+)
                      and bill.branchno = totalbase_items.branchno(+)
                 ";

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // 検索レコードが存在する場合
            if (current != null)
            {
                delFlg = Convert.ToInt32(current.DELFLG);
                orgCd = Convert.ToString(current.ORGCD);
                orgName = Convert.ToString(current.ORGNAME);
                localBillPrice = Convert.ToInt32(current.BILLPRICE);
                localPaymentPrice = Convert.ToInt32(current.PAYMENTPRICE);

                billPrice = Convert.ToString(current.BILLPRICE);
                paymentPrice = Convert.ToString(current.PAYMENTPRICE);
                totalAmount = columns[INDEX_TOTAL_AMOUNT].ToString();

                while (true)
                {
                    // 入金済チェック
                    if (localPaymentPrice > 0)
                    {
                        ret = -2;
                        break;
                    }

                    // 請求額と入金額チェック
                    if (localBillPrice != Convert.ToInt32(columns[INDEX_TOTAL_AMOUNT]))
                    {
                        ret = -3;
                        break;
                    }

                    // 請求書取消チェック
                    if (delFlg == 1)
                    {
                        ret = -4;
                        break;
                    }

                    // 団体コードチェック
                    if (orgCd != Convert.ToString(columns[INDEX_CUSTOMER_CODE]))
                    {
                        ret = -5;
                        break;
                    }

                    // 入金情報登録

                    // 入金情報
                    InsertPayment data = new InsertPayment();
                    // 締め日
                    data.CloseDate = closeDate;
                    // 請求書SEQ
                    data.BillSeq = billSeq;
                    // 請求書枝番
                    data.BranchNo = branchNo;
                    // 入金日
                    data.PaymentDate = paymentAutoDao.CnvDate(columns[INDEX_CLEARING_DATE]);
                    // 入金額
                    data.PaymentPrice = columns[INDEX_TOTAL_AMOUNT];
                    // 入金種別
                    data.PaymentDiv = 3;
                    // 更新者
                    data.Upduser = userId;
                    // コメント
                    data.PayNote = "";
                    // カード種別
                    data.CardKind = "";
                    // 伝票No.
                    data.Creditslipno = "";
                    // 金融機関
                    data.BankCode = "";
                    // レジ番号
                    data.Registerno = "";
                    // 現金
                    data.Cash = "";

                    // 入金情報の書き込み
                    Insert insertRet = demandDao.InsertPayment(billNo, data);
                    ret = Convert.ToInt32(insertRet);

                    break;
                }

            }
            else
            {
                // 請求情報が存在しない
                ret = -1;
            }

            // 戻り値の設定
            return ret;
        }
    }
}
