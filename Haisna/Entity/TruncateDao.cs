using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;

#pragma warning disable CS1591

namespace Hainsi.Entity
{
    public class TruncateDao : AbstractDao
    {
        private const string TRANSACTIONDIV_RSVDEL = "LOGRSVDEL";  // 予約一括削除用のログ処理ＩＤ

        // 項目位置情報
        private const int INDEX_CSLDATE1 = 0;     // 受診希望日１
        private const int INDEX_CSLDATE2 = 1;     // 受診希望日２
        private const int INDEX_CSLDATE3 = 2;     // 受診希望日３
        private const int INDEX_RSVGRPCD = 3;     // 予約群コード
        private const int INDEX_NAME = 4;         // 姓名
        private const int INDEX_KNAME = 5;        // カナ姓名
        private const int INDEX_ROMENAME = 6;     // ローマ字名
        private const int INDEX_BIRTH = 7;        // 生年月日
        private const int INDEX_GENDER = 8;       // 性別
        private const int INDEX_CSLDIVCD = 9;     // 受診区分コード
        private const int INDEX_PERID = 10;       // 個人ＩＤ
        private const int INDEX_ZIPCD = 11;       // 郵便番号
        private const int INDEX_TEL = 12;         // 電話番号
        private const int INDEX_ADDRESS = 13;     // 住所
        private const int INDEX_EMPNO = 14;       // 従業員番号（または保険証番号）
        private const int INDEX_SETCLASSCD = 15;  // セット分類コード

        // 項目長情報
        private const int LENGTH_CSLDATE1 = 0;    // 受診希望日１
        private const int LENGTH_CSLDATE2 = 0;    // 受診希望日２
        private const int LENGTH_CSLDATE3 = 0;    // 受診希望日３
        private const int LENGTH_RSVGRPCD = 3;    // 予約群コード
        private const int LENGTH_NAME = 50;       // 姓名
        private const int LENGTH_KNAME = 50;      // カナ姓名
        private const int LENGTH_ROMENAME = 60;   // ローマ字名
        private const int LENGTH_BIRTH = 0;       // 生年月日
        private const int LENGTH_GENDER = 0;      // 性別
        private const int LENGTH_CSLDIVCD = 12;   // 受診区分コード
        private const int LENGTH_PERID = 12;      // 個人ＩＤ
        private const int LENGTH_ZIPCD = 7;       // 郵便番号
        private const int LENGTH_TEL = 15;        // 電話番号
        private const int LENGTH_ADDRESS = 60;    // 住所
        private const int LENGTH_EMPNO = 12;      // 従業員番号
        private const int LENGTH_ISRNO = 16;      // 保険証番号
        private const int LENGTH_SETCLASSCD = 3;  // セット分類コード

        // 項目名情報
        private const string NAME_CSLDATE = "受診希望日";           // 受診希望日
        private const string NAME_CSLDATE1 = "第１受診希望日";      // 受診希望日１
        private const string NAME_CSLDATE2 = "第２受診希望日";      // 受診希望日２
        private const string NAME_CSLDATE3 = "第３受診希望日";      // 受診希望日３
        private const string NAME_RSVGRPCD = "予約群";              // 予約群コード
        private const string NAME_NAME = "漢字名";                  // 姓名
        private const string NAME_KNAME = "カナ名";                 // カナ姓名
        private const string NAME_ROMENAME = "ローマ字氏名";        // ローマ字名
        private const string NAME_BIRTH = "生年月日";               // 生年月日
        private const string NAME_GENDER = "性別";                  // 性別
        private const string NAME_CSLDIVCD = "受診区分";            // 受診区分コード
        private const string NAME_PERID = "患者ＩＤ";               // 個人ＩＤ
        private const string NAME_ZIPCD = "郵便番号";               // 郵便番号
        private const string NAME_TEL = "電話番号";                 // 電話番号
        private const string NAME_ADDRESS = "住所";                 // 住所
        private const string NAME_EMPNO = "従業員番号";             // 従業員番号
        private const string NAME_ISRNO = "保険証番号";             // 保険証番号
        private const string NAME_SETCLASSCD = "セット分類コード";  // セット分類コード

        private const int CSLDATE_MAXCOUNT = 3;                     // 指定可能な受診希望日の最大数

        /// <summary>
        /// 連携データアクセスオブジェクト
        /// </summary>
        readonly CooperationDao cooperationDao;

        /// <summary>
        /// 契約情報アクセスオブジェクト
        /// </summary>
        readonly ContractDao contractDao;

        /// <summary>
        /// 汎用情報アクセスオブジェクト
        /// </summary>
        readonly FreeDao freeDao;

        /// <summary>
        /// ログ情報アクセスオブジェクト
        /// </summary>
        readonly HainsLogDao hainsLogDao;

        /// <summary>
        /// 団体情報アクセスオブジェクト
        /// </summary>
        readonly OrganizationDao organizationDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        /// <param name="cooperationDao">連携データアクセスオブジェクト</param>
        /// <param name="contractDao">契約情報アクセスオブジェクト</param>
        /// <param name="freeDao">汎用情報アクセスオブジェクト</param>
        /// <param name="hainsLogDao">ログ情報アクセスオブジェクト</param>
        /// <param name="organizationDao">団体情報アクセスオブジェクト</param>
        TruncateDao(IDbConnection connection,
                    CooperationDao cooperationDao,
                    ContractDao contractDao,
                    FreeDao freeDao,
                    HainsLogDao hainsLogDao,
                    OrganizationDao organizationDao) : base(connection)
        {
            this.cooperationDao = cooperationDao;
            this.contractDao = contractDao;
            this.freeDao = freeDao;
            this.hainsLogDao = hainsLogDao;
            this.organizationDao = organizationDao;
        }

        /// <summary>
        /// 受診情報の削除を行う
        /// </summary>
        /// <param name="transId">トランザクションＩＤ</param>
        /// <param name="userId">ユーザＩＤ</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="lineNo">行番号</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns>ストアドが完璧になってから記述する</returns>
        private int DeleteConsult(int transId,
                                  string userId,
                                  string orgCd1,
                                  string orgCd2,
                                  int ctrPtCd,
                                  int lineNo,
                                  string cslDate,
                                  string rsvNo,
                                  string perId)
        {
            string sql = "";  // SQLステートメント

            // 受診情報削除用ストアドパッケージの関数呼び出し
            sql = @"
                    begin :ret := consultallpackage.deleteconsult(
                      :transid
                      , :transdiv
                      , :upduser
                      , :orgcd1
                      , :orgcd2
                      , :ctrptcd
                      , :lineno
                      , :csldate
                      , :rsvno
                      , :perid
                    );

                    end;
                ";

            using (var cmd = new OracleCommand())
            {
                // パラメータ設定
                cmd.Parameters.Add("transid", transId);
                cmd.Parameters.Add("transdiv", TRANSACTIONDIV_RSVDEL);
                cmd.Parameters.Add("upduser", userId);
                cmd.Parameters.Add("orgcd1", orgCd1);
                cmd.Parameters.Add("orgcd2", orgCd2);
                cmd.Parameters.Add("ctrptcd", ctrPtCd);
                cmd.Parameters.Add("lineno", lineNo);
                cmd.Parameters.Add("csldate", Convert.ToDateTime(cslDate));
                cmd.Parameters.Add("rsvno", Convert.ToInt32(rsvNo));
                cmd.Parameters.Add("perid", perId);

                // Outputパラメータ
                OracleParameter ret = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                // PL/SQL文の実行
                ExecuteNonQuery(cmd, sql);

                // 戻り値の設定
                return ((OracleDecimal)ret.Value).ToInt32();
            }
        }

        /// <summary>
        /// ＣＳＶファイルから受診情報の削除を行う
        /// </summary>
        /// <param name="fileName">ＣＳＶファイル名</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="userId">ユーザＩＤ</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="startPos">読み込み開始位置</param>
        /// <param name="refReadCount">読み込みレコード数</param>
        /// <param name="refDelCount">削除受診情報数</param>
        public void DeleteFromCsvFile(string fileName,
                                      string orgCd1,
                                      string orgCd2,
                                      string userId,
                                      int ctrPtCd,
                                      int startPos,
                                      ref int refReadCount,
                                      ref int refDelCount)
        {
            List<string> columns;    // 項目値の配列
            int transId;             // トランザクションＩＤ
            string title;            // 表題
            string orgSName;         // 団体略称
            string csCd;             // コースコード
            string csName;           // コース名
            object strDate;          // 契約開始日
            object endDate;          // 契約終了日
            string buffer = "";      // 文字列バッファ
            int lineNo = 0;          // 行番号
            int lastIndex;           // 配列の最終インデックス
            bool error;              // エラーフラグ
            string cslDate = "";     // 受診日
            string rsvNo = "";       // 予約番号
            string perId = "";       // 個人ＩＤ
            int readCount = 0;       // 読み込みレコード数
            int delCount = 0;        // 削除受診情報数
            string strMessage = "";  // メッセージ
            int ret;                // 関数戻り値
            int i;                   // インデックス

            // CSVファイルオープン
            FileStream inFile = null;
            StreamReader inFileReader = null;

            // トランザクションＩＤの取得
            transId = hainsLogDao.IncreaseTransactionId();

            // 汎用テーブルから表題を取得
            title = Convert.ToString(freeDao.SelectFree(0, TRANSACTIONDIV_RSVDEL)[0]["freename"]);

            // 開始ログの発行
            cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVDEL, "I", "", new List<string> { title + "処理を開始します。" }, new List<string> { "" });

            // 指定されたパラメータ情報を編集する
            while (true)
            {

                // 団体略称の取得
                dynamic retOrg = organizationDao.SelectOrg_Lukes(orgCd1, orgCd2);

                // 団体情報が存在しない場合は処理終了
                if (retOrg == null)
                {
                    cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVDEL, "E", "", new List<string> { "団体情報が存在しません。" }, new List<string> { "団体コード=" + orgCd1 + "-" + orgCd2 });
                    break;
                }
                else
                {
                    orgSName = Convert.ToString(retOrg.ORGSNAME);
                }

                // ログ発行
                cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVDEL, "I", "", new List<string> { "■次の団体が指定されました。" }, new List<string> { "団体=" + orgSName + "（" + orgCd1 + "-" + orgCd2 + "）" });

                // 契約管理情報の読み込み
                dynamic contractData = contractDao.SelectCtrMng(orgCd1, orgCd2, ctrPtCd);

                if (contractData == null)
                {
                    cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVDEL, "E", "", new List<string> { "契約情報が存在しません。" }, new List<string> { "契約パターンコード=" + ctrPtCd });
                    break;
                }
                else
                {
                    csCd = contractData.CSCD;
                    csName = contractData.CSNAME;
                    strDate = contractData.STRDATE;
                    endDate = contractData.ENDDATE;
                }

                // ログ発行
                strMessage = "";
                strMessage = strMessage + "契約パターンコード=" + ctrPtCd;
                strMessage = strMessage + "、";
                strMessage = strMessage + "コース=" + csName + "（" + csCd + "）";
                strMessage = strMessage + "、";
                strMessage = strMessage + "契約期間=" + strDate + "～" + endDate;
                cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVDEL, "I", "", new List<string> { "■次の契約情報が指定されました。" }, new List<string> { strMessage });

                // ファイルが存在しない場合は処理を終了する
                if (!File.Exists(fileName))
                {
                    cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVDEL, "E", "", new List<string> { "ファイルが存在しません。" }, new List<string> { "ファイル名=" + fileName });
                    break;
                }

                try
                {
                    // CSVファイルオープン
                    inFile = new FileStream(fileName, FileMode.Open);
                    inFileReader = new StreamReader(inFile);

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
                                break;
                            }

                            // 行データが存在しない場合はスキップ
                            if ("".Equals(buffer.Trim()))
                            {
                                break;
                            }

                            // 読み込みレコード数のインクリメント
                            readCount = readCount + 1;

                            // CSV一括予約の結果レコードはセット分類数が特定できないため、削除に必要な情報はレコードの最終列から逆検索して取得する

                            // カンマ分離
                            columns = buffer.Split(',').ToList();

                            // カラム値の検索
                            for (i = 0; i < columns.Count; i++)
                            {

                                // 先端のダブルクォーテーションを除外
                                if (columns[i].Substring(0, 1) == "\"")
                                {
                                    columns[i] = columns[i].Substring(1);
                                }

                                // 終端のダブルクォーテーションを除外
                                if (columns[i].Substring(columns[i].Length - 1, 1) == "\"")
                                {
                                    columns[i] = columns[i].Substring(0, columns[i].Length - 1);
                                }

                                // 値のトリミング
                                columns[i] = columns[i].Trim();
                            }

                            // 後ろから順に
                            // ・受診希望日毎の検索結果
                            // ・予約群名称
                            // ・個人ＩＤ
                            // ・予約番号
                            // ・受診日
                            // と格納されている前提で処理を実施

                            lastIndex = columns.Count;

                            // 要素数がこれらに満たない場合はスキップ(ログも書かない)
                            if (lastIndex < (CSLDATE_MAXCOUNT + 4) - 1)
                            {
                                break;
                            }

                            // 受診日、予約番号、個人ＩＤを取得する
                            cslDate = columns[lastIndex - (CSLDATE_MAXCOUNT + 3)];
                            rsvNo = columns[lastIndex - (CSLDATE_MAXCOUNT + 2)];
                            perId = columns[lastIndex - (CSLDATE_MAXCOUNT + 1)];

                            // １項目でも値が格納されていないレコードの場合、即ちそれは予約されたレコード情報ではないのでスキップする (ログも書かない)
                            if (cslDate == "" || rsvNo == "" || perId == "")
                            {
                                break;
                            }

                            error = false;

                            // (一応)項目値チェックを行う

                            // 受診日(日付チェック)
                            if (cooperationDao.CnvDate(cslDate) == "")
                            {
                                cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVDEL, "E", lineNo.ToString(), new List<string> { "受診日が日付として認識できません。" }, new List<string> { "受診日=" + cslDate });
                                error = true;
                            }

                            // 予約番号(数値チェック)
                            if (!cooperationDao.CheckNumber(rsvNo))
                            {

                                cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVDEL, "E", lineNo.ToString(), new List<string> { "予約番号が無効です。" }, new List<string> { "予約番号=" + rsvNo });

                                error = true;
                            }
                            // 予約番号(項目長チェック)
                            else if (Convert.ToInt32(rsvNo).ToString().Length > 9)
                            {
                                cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVDEL, "E", lineNo.ToString(), new List<string> { "予約番号の値が長すぎます。" }, new List<string> { "予約番号=" + rsvNo });

                                error = true;
                            }

                            // 個人ＩＤ(項目長チェック)
                            //#ToDo LenB について　どうするか？
                            //If LenB(StrConv(strPerId, vbFromUnicode)) > LENGTH_PERID Then
                            if (Encoding.GetEncoding(932).GetBytes(perId).Length > LENGTH_PERID)
                            {
                                cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVDEL, "E", lineNo.ToString(), new List<string> { "個人ＩＤの値が長すぎます。" }, new List<string> { "個人ＩＤ=" + perId });
                                error = true;
                            }

                            // 項目値チェックエラー時は次レコードへ
                            if (error)
                            {
                                break;
                            }

                            // 受診情報の削除を行う
                            ret = DeleteConsult(transId, userId, orgCd1, orgCd2, ctrPtCd, lineNo, cslDate, rsvNo, perId);

                            if (ret == 0)
                            {
                                delCount += 1;
                            }

                            break;
                        }
                    }
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
                }

                break;
            }

            // 他戻り値の設定
            refReadCount = readCount;
            refDelCount = delCount;

            // 終了ログの発行
            cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVDEL, "I", "", new List<string> { readCount + "件のレコードが読み込まれました。" }, new List<string> { "" });
            cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVDEL, "I", "", new List<string> { delCount + "件の受診情報が削除されました。" }, new List<string> { "" });
            cooperationDao.PutHainsLog(transId, TRANSACTIONDIV_RSVDEL, "I", "", new List<string> { title + "処理を終了します。" }, new List<string> { "" });
        }
    }
}
