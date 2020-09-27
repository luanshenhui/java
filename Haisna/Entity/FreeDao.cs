using Dapper;
using Hainsi.Common.Constants;
using Hainsi.Entity;
using Hainsi.Entity.Model.Free;
using Newtonsoft.Json.Linq;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 汎用情報データアクセスオブジェクト
    /// </summary>
    public class FreeDao : AbstractDao
    {
        private const String PTN_HEADER_INF = "0000";  // 受診者対象情報

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public FreeDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 受診日時点の年齢計算
        /// </summary>
        /// <param name="birth">生年月日</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="bsDate">起算日</param>
        /// <returns>年齢＋月齢</returns>
        public string CalcAge(DateTime birth, DateTime? cslDate = null, String bsDate = null)
        {
            string sql;

            // 引数値のバインド変数定義
            var param = new Dictionary<string, object>();
            param.Add("birth", birth);
            param.Add("cslDate", DateTime.Now);
            param.Add("bsDate", bsDate);

            // 引数値の設定
            if (cslDate != null)
            {
                param["cslDate"] = cslDate;
            }

            // 年齢計算
            sql = @"
                select
                    getcslage(:birth, :csldate, :bsdate) age
                from
                    dual
            ";

            return connection.Query(sql, param).FirstOrDefault().AGE;
        }

        /// <summary>
        /// 汎用テーブルレコード挿入
        /// </summary>
        /// <param name="data">汎用情報
        /// freeclasscd  汎用分類コード
        /// freename     汎用名
        /// freedate     汎用日付
        /// freefield1   汎用フィールド1
        /// freefield2   汎用フィールド2
        /// freefield3   汎用フィールド3
        /// freefield4   汎用フィールド4
        /// freefield5   汎用フィールド5
        /// freefield6   汎用フィールド6
        /// freefield7   汎用フィールド7
        /// </param>
        /// <returns>
        ///	Insert.Normal     正常終了
        ///	Insert.Duplicate  同一キーのレコード存在
        ///	Insert.Error      異常終了
        ///	</returns>
        public Insert InsertFree(JToken data)
        {
            Insert ret;                 // 関数戻り値
            string insFreeName = "";    // 汎用名

            // 初期処理
            ret = Insert.Error;

            using (var transaction = BeginTransaction())
            {
                try
                {
                    string sql;

                    // デフォルト値の設定
                    switch (Convert.ToString(data["freecd"]).Trim())
                    {
                        case "DOCNO":
                            insFreeName = "文書番号発番管理";
                            break;
                        case "ORDERNO":
                            insFreeName = "オーダ番号発番管理";
                            break;
                        default:
                            insFreeName = Convert.ToString(data["freename"]).Trim();
                            break;
                    }

                    // キー及び更新値の設定
                    var param = new Dictionary<string, object>();
                    param.Add("freecd", Convert.ToString(data["freecd"]).Trim());
                    param.Add("freeclasscd", Convert.ToString(data["freeclasscd"]).Trim());
                    param.Add("freename", insFreeName);
                    if (data["freedate"] != null)
                    {
                        if (Convert.ToString(data["freedate"]).Trim() != "")
                        {
                            param.Add("freedate", Convert.ToDateTime(data["freedate"]));
                        }
                    }
                    if (data["freefield1"] != null)
                    {
                        param.Add("freefield1", Convert.ToString(data["freefield1"]).Trim());
                    }

                    if (data["freefield2"] != null)
                    {
                        param.Add("freefield2", Convert.ToString(data["freefield2"]).Trim());
                    }

                    if (data["freefield3"] != null)
                    {
                        param.Add("freefield3", Convert.ToString(data["freefield3"]).Trim());
                    }

                    if (data["freefield4"] != null)
                    {
                        param.Add("freefield4", Convert.ToString(data["freefield4"]).Trim());
                    }

                    if (data["freefield5"] != null)
                    {
                        param.Add("freefield5", Convert.ToString(data["freefield5"]).Trim());
                    }

                    if (data["freefield6"] != null)
                    {
                        param.Add("freefield6", Convert.ToString(data["freefield6"]).Trim());
                    }

                    if (data["freefield7"] != null)
                    {
                        param.Add("freefield7", Convert.ToString(data["freefield7"]).Trim());
                    }

                    // 汎用テーブルレコードの挿入
                    sql = @"
                            insert
                            into free (freecd, freeclasscd, freename
                        ";

                    // 汎用日付指定時の処理
                    if (data["freedate"] != null)
                    {
                        if (Convert.ToString(data["freedate"]).Trim() != "")
                        {
                            sql += ", freedate";
                        }
                    }

                    // 汎用フィールド指定時の処理
                    if (data["freefield1"] != null)
                    {
                        sql += ", freefield1";
                    }

                    if (data["freefield2"] != null)
                    {
                        sql += ", freefield2";
                    }

                    if (data["freefield3"] != null)
                    {
                        sql += ", freefield3";
                    }

                    if (data["freefield4"] != null)
                    {
                        sql += ", freefield4";
                    }

                    if (data["freefield5"] != null)
                    {
                        sql += ", freefield5";
                    }

                    if (data["freefield6"] != null)
                    {
                        sql += ", freefield6";
                    }

                    if (data["freefield7"] != null)
                    {
                        sql += ", freefield7";
                    }

                    sql += @" )
                        values (:freecd, :freeclasscd, :freename
                    ";

                    // 汎用日付指定時の処理
                    if (data["freedate"] != null)
                    {
                        if (Convert.ToString(data["freedate"]).Trim() != "")
                        {
                            sql += ", :freedate";
                        }
                    }

                    // 汎用フィールド指定時の処理
                    if (data["freefield1"] != null)
                    {
                        sql += ", :freefield1";
                    }

                    if (data["freefield2"] != null)
                    {
                        sql += ", :freefield2";
                    }

                    if (data["freefield3"] != null)
                    {
                        sql += ", :freefield3";
                    }

                    if (data["freefield4"] != null)
                    {
                        sql += ", :freefield4";
                    }

                    if (data["freefield5"] != null)
                    {
                        sql += ", :freefield5";
                    }

                    if (data["freefield6"] != null)
                    {
                        sql += ", :freefield6";
                    }

                    if (data["freefield7"] != null)
                    {
                        sql += ", :freefield7";
                    }

                    sql += " )";

                    connection.Execute(sql, param);

                    // トランザクションをコミット
                    transaction.Commit();

                    // 戻り値の設定
                    ret = Insert.Normal;
                }
                catch (OracleException ex)
                {
                    // キー重複時
                    if (ex.Number == 1)
                    {
                        // 戻り値の設定
                        ret = Insert.Duplicate;
                    }
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 汎用テーブル読み込み
        /// </summary>
        /// <param name="mode">検索モード(0:一意検索、1:前方一致検索、2:全件)</param>
        /// <param name="freeCdKey">汎用コード(検索キー値)</param>
        /// <param name="locking">レコードロック実施有無</param>
        /// <returns>
        /// freeCd      汎用コード
        /// freeName    汎用名
        /// freeDate    汎用日付
        /// freeField1  汎用フィールド1
        /// freeField2  汎用フィールド2
        /// freeField3  汎用フィールド3
        /// freeField4  汎用フィールド4
        /// freeField5  汎用フィールド5
        /// freeClassCd 汎用分類コード
        /// freeField6  汎用フィールド6
        /// freeField7  汎用フィールド7
        /// </returns>
        public List<dynamic> SelectFree(int mode, string freeCdKey, bool locking = false)
        {
            object sqlParam = null;
            string sql;
            string key = "";
            if (freeCdKey != null)
            {
                // 検索モードごとの検索キー値設定
                key = freeCdKey.Trim() + ((mode == 1 || mode == 3) ? "%" : "");
            }

            // キー値の設定
            if (mode != 2)
            {
                sqlParam = new
                {
                    freecd = key
                };
            }

            // 指定予約番号の受診オプション管理情報を取得する
            sql = @"
                    select
                        freecd
                        , freename
                        , freedate
                        , freefield1
                        , freefield2
                        , freefield3
                        , freefield4
                        , freefield5
                        , freeclasscd
                        , freefield6
                        , freefield7
                    from
                        free
                ";

            // 検索モードごとの条件節設定
            switch (mode)
            {
                case 0: // 一意検索の場合
                    sql += " where freecd = :freecd ";
                    break;
                case 1: // 前方一致検索の場合
                    sql += @"
                             where freecd like :freecd
                             order by freecd
                        ";
                    break;
                case 2: // 全件取得の場合
                    sql += " order by freecd";
                    break;
                case 3: // 前方一致検索で順番設定の場合
                    sql += @"
                             where freecd like :freecd
                             order by to_number(freefield3)
                        ";
                    break;
            }

            // レコードロック指定
            if (locking)
            {
                sql += "   for update";
            }

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 汎用テーブル読み込み
        /// </summary>
        /// <param name="mode">検索モード(0:一意検索、1:前方一致検索、2:全件)</param>
        /// <param name="freeCdKey">汎用コード(検索キー値)</param>
        /// <param name="cslDate">受診日</param>
        /// <param name="locking">レコードロック実施有無</param>
        /// <returns>
        /// freeCd      汎用コード
        /// freeName    汎用名
        /// freeDate    汎用日付
        /// freeField1  汎用フィールド1
        /// freeField2  汎用フィールド2
        /// freeField3  汎用フィールド3
        /// freeField4  汎用フィールド4
        /// freeField5  汎用フィールド5
        /// freeClassCd 汎用分類コード
        /// freeField6  汎用フィールド6
        /// freeField7  汎用フィールド7
        /// </returns>
        public List<dynamic> SelectFreeDate(int mode, string freeCdKey, DateTime? cslDate = null, bool locking = false)
        {
            var param = new Dictionary<string, object>();

            string sql;

            // 検索モードごとの検索キー値設定
            string key = freeCdKey.Trim() + ((mode == 1 || mode == 3) ? "%" : "");

            // キー値の設定
            if (mode != 2)
            {
                param.Add("freecd", Convert.ToString(key));
                if (cslDate != null)
                {
                    param.Add("freedate", Convert.ToDateTime(cslDate));
                }
            }

            // 指定予約番号の受診オプション管理情報を取得する
            sql = @"
                    select
                        freecd
                        , freename
                        , freedate
                        , freefield1
                        , freefield2
                        , freefield3
                        , freefield4
                        , freefield5
                        , freeclasscd
                        , freefield6
                        , freefield7
                    from
                        free
                ";

            // 検索モードごとの条件節設定
            switch (mode)
            {
                case 0: // 一意検索の場合
                    sql += " where freecd = :freecd ";
                    break;
                case 1: // 前方一致検索の場合
                    sql += @"
                            where freecd like :freecd
                              and freedate >= :freedate
                            order by freecd
                        ";
                    break;
                case 2: // 全件取得の場合
                    sql += " order by freecd";
                    break;
                case 3: // 前方一致検索で順番設定の場合
                    sql += @"
                            where freecd like :freecd
                              and freedate >= :freedate
                            order by to_number(freefield3)
                        ";
                    break;
            }

            // レコードロック指定
            if (locking)
            {
                sql += "   for update";
            }

            // SQL実行
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// FreeClassCdで汎用テーブル読み込み
        /// </summary>
        /// <param name="mode">検索モード(0:、1:、2:)</param>
        /// <param name="freeClassCd">汎用コード(検索キー値)</param>
        /// <param name="locking">レコードロック実施有無</param>
        /// <returns>
        /// freeCd         汎用コード
        /// freeName       汎用名
        /// freeDate       汎用日付
        /// freeField1     汎用フィールド1
        /// freeField2     汎用フィールド2
        /// freeField3     汎用フィールド3
        /// freeField4     汎用フィールド4
        /// freeField5     汎用フィールド5
        /// freeClassCd    汎用分類コード
        /// freeField6     汎用フィールド6
        /// freeField7     汎用フィールド7
        /// </returns>
        public List<dynamic> SelectFreeByClassCd(int mode, string freeClassCd, bool locking = false)
        {
            string sql;

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("freekey", freeClassCd);

            // 指定予約番号の受診オプション管理情報を取得する
            sql = @"
                    select
                      freecd
                      , freename
                      , freedate
                      , freefield1
                      , freefield2
                      , freefield3
                      , freefield4
                      , freefield5
                      , freeclasscd
                      , freefield6
                      , freefield7
                    from
                      free
                ";

            // 検索モードごとの条件節設定
            switch (mode)
            {
                case 0: // FreeClassCdで検索の場合
                    sql += @"
                            where freeclasscd = :freekey
                            order by freecd
                        ";
                    break;
                case 1: // セキュリティーグループで検索の場合
                    sql += @"
                            where freeclasscd = 'USR'
                              and freefield2 = :freekey
                            order by freecd
                        ";
                    break;
                case 2: // メニューグループ場合画面表示手順で...
                    sql += @"
                            where freeclasscd = :freekey
                            order by to_number(freefield3)
                        ";

                    break;
            }

            // レコードロック指定
            if (locking)
            {
                sql += "   for update";
            }

            // SQL実行
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 文書番号またはオーダ番号の読み込み
        /// </summary>
        /// <param name="freeCd">汎用コード</param>
        /// <param name="seqNo">文書番号またはオーダ番号</param>
        /// <returns>
        /// True   正常終了
        /// False  異常終了
        /// </returns>
        public bool SelectFreeSeqNo(string freeCd, ref long seqNo)
        {
            long retSeqNo;  // 文書番号またはオーダ番号
            Insert ret;     // 関数戻り値

            // 文書番号、オーダ番号以外の場合は何もしない
            switch (freeCd)
            {
                case "DOCNO":
                case "ORDERNO":
                    break;
                default:
                    return false;
            }

            // 文書番号またはオーダ番号の初期設定
            retSeqNo = 0;

            JObject obj = JObject.FromObject(new
            {
                freecd = freeCd,
                freeclasscd = "KAR",
                freename = "",
                seqno = seqNo
            });

            // 汎用テーブルレコードの挿入処理
            ret = InsertFree(obj);
            if (ret == Insert.Error)
            {
                return false;
            }

            // すでにレコードが存在する場合は既存レコードを読み込む
            if (ret == Insert.Duplicate)
            {
                SelectFree(0, freeCd, true);
            }

            // 戻り値の設定
            seqNo = retSeqNo;

            return true;
        }

        /// <summary>
        /// 受診票出力パターンリストの取得
        /// </summary>
        /// <returns>
        /// freeCd         汎用コード
        /// freeName       汎用名
        /// </returns>
        public List<dynamic> SelectJushinhyoPtnList()
        {
            string sql;

            // 汎用テーブルの受診票印刷パターンのうち受診者対象情報を取得
            sql = @"
                    select
                      freecd
                      , freename
                    from
                      free
                    where
                      freecd like 'J__00000'
                    order by
                      freecd
                ";

            // SQL実行
            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 指定の受診票印刷パターンコードからパターン情報を取得する
        /// </summary>
        /// <param name="ptnCd">パターンコード</param>
        /// <param name="ptnName">パターン名</param>
        /// <param name="fedFile">CoReports定義ファイル名</param>
        /// <returns>
        /// rownum    (配列)パターン内連番
        /// itemname  (配列)検査項目枠名
        /// room      (配列)検査室名
        /// floor     (配列)フロア
        /// note      (配列)備考
        /// itemcd    (配列)管理する検査項目コード
        /// </returns>
        public List<dynamic> SelectJushinhyoPtn(string ptnCd, ref string ptnName, ref string fedFile)
        {
            string sql;

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("freeclasscd", ptnCd.Trim());

            // 検索条件を満たす汎用テーブルのレコードを取得
            sql = @"
                    select
                      freecd
                      , freename
                      , freefield1
                      , freefield2
                      , freefield3
                      , freefield4
                      , freefield5
                    from
                      free
                    where
                      freecd like :freeclasscd || '%'
                    order by
                      freecd
                ";

            List<dynamic> data = connection.Query(sql, param).ToList();

            // 戻り値の設定
            List<dynamic> listdata = new List<dynamic>();
            for (int i = 0; i < data.Count; i++)
            {
                if (data[i].FREECD.substring(3, 5) == PTN_HEADER_INF)
                {
                    ptnName = data[i].FREENAME;
                    fedFile = data[i].FREEFIELD5;
                }

                var listitem = new
                {
                    rownum = data[i].FREECD.substring(3, 5),
                    itemname = data[i].FREEFIELD1,
                    room = data[i].FREEFIELD2,
                    floor = data[i].FREEFIELD3,
                    note = data[i].FREEFIELD4,
                    itemCd = data[i].FREEFIELD5
                };

                listdata.Add(listitem);
            }

            return listdata;
        }

        /// <summary>
        /// 汎用テーブルレコード更新
        /// </summary>
        /// <param name="freeCd">汎用コード</param>
        /// <param name="data">汎用情報
        /// freecd       汎用コード
        /// freeclasscd  汎用分類コード
        /// freename     汎用名
        /// freedate     汎用日付
        /// freefield1   汎用フィールド1
        /// freefield2   汎用フィールド2
        /// freefield3   汎用フィールド3
        /// freefield4   汎用フィールド4
        /// freefield5   汎用フィールド5
        /// freefield6   汎用フィールド6
        /// freefield7   汎用フィールド7
        /// </param>
        /// <returns>
        /// True   正常終了
        /// False  異常終了
        /// </returns>
        public bool UpdateFree(string freeCd, UpdateFree data)
        {
            bool ret = false;           // 関数戻り値
            bool set = false;           // SET句を編集したか
            string updFreeName = "";    // 汎用名

            using (var transaction = BeginTransaction())
            {
                try
                {
                    string sql;

                    // デフォルト値の設定
                    switch (freeCd)
                    {
                        case "DOCNO":
                            updFreeName = "文書番号発番管理";
                            break;
                        case "ORDERNO":
                            updFreeName = "オーダ番号発番管理";
                            break;
                        case "DAILYCLS":
                            updFreeName = "日次締め日";
                            break;
                        default:
                            if (data.FreeName != null)
                            {
                                updFreeName = Convert.ToString(data.FreeName).Trim();
                            }
                            break;
                    }

                    // キー及び更新値の設定
                    var param = new Dictionary<string, object>();
                    if (freeCd != null)
                    {
                        param.Add("freecd", freeCd);
                    }

                    if (data.FreeClassCd != null)
                    {
                        param.Add("freeclasscd", Convert.ToString(data.FreeClassCd).Trim());
                    }

                    if (data.FreeName != null)
                    {
                        param.Add("freename", updFreeName);
                    }

                    if (data.FreeDate != null)
                    {
                        // 日付空白の場合は、NULLセット
                        if (Convert.ToString(data.FreeDate).Trim() == "")
                        {
                            param.Add("freedate", null);
                        }
                        else
                        {
                            param.Add("freedate", Convert.ToDateTime(data.FreeDate));
                        }
                    }

                    if (data.FreeField1 != null)
                    {
                        param.Add("freefield1", Convert.ToString(data.FreeField1).Trim());
                    }

                    if (data.FreeField2 != null)
                    {
                        param.Add("freefield2", Convert.ToString(data.FreeField2).Trim());
                    }

                    if (data.FreeField3 != null)
                    {
                        param.Add("freefield3", Convert.ToString(data.FreeField3).Trim());
                    }

                    if (data.FreeField4 != null)
                    {
                        param.Add("freefield4", Convert.ToString(data.FreeField4).Trim());
                    }

                    if (data.FreeField5 != null)
                    {
                        param.Add("freefield4", Convert.ToString(data.FreeField5).Trim());
                    }

                    if (data.FreeField6 != null)
                    {
                        param.Add("freefield4", Convert.ToString(data.FreeField6).Trim());
                    }

                    if (data.FreeField7 != null)
                    {
                        param.Add("freefield4", Convert.ToString(data.FreeField7).Trim());
                    }

                    // 汎用テーブルレコードの更新
                    sql = "update free ";

                    // 汎用分類コード指定時の処理
                    if (data.FreeClassCd != null)
                    {
                        sql += ((set ? "," : "set") + " freeclasscd = :freeclasscd");
                        set = true;
                    }

                    // 汎用名指定時の処理
                    if (data.FreeName != null)
                    {
                        sql += ((set ? "," : "set") + " freename = :freename");
                        set = true;
                    }

                    // 汎用日付指定時の処理
                    if (data.FreeDate != null)
                    {
                        sql += ((set ? "," : "set") + " freedate = :freedate");
                        set = true;
                    }

                    // 汎用フィールド指定時の処理
                    if (data.FreeField1 != null)
                    {
                        sql += ((set ? "," : "set") + " freefield1 = :freefield1");
                        set = true;
                    }

                    if (data.FreeField2 != null)
                    {
                        sql += ((set ? "," : "set") + " freefield2 = :freefield2");
                        set = true;
                    }

                    if (data.FreeField3 != null)
                    {
                        sql += ((set ? "," : "set") + " freefield3 = :freefield3");
                        set = true;
                    }

                    if (data.FreeField4 != null)
                    {
                        sql += ((set ? "," : "set") + " freefield4 = :freefield4");
                        set = true;
                    }

                    if (data.FreeField5 != null)
                    {
                        sql += ((set ? "," : "set") + " freefield5 = :freefield5");
                        set = true;
                    }

                    if (data.FreeField6 != null)
                    {
                        sql += ((set ? "," : "set") + " freefield6 = :freefield6");
                        set = true;
                    }

                    if (data.FreeField7 != null)
                    {
                        sql += ((set ? "," : "set") + " freefield7 = :freefield7");
                        set = true;
                    }

                    // SET句が編集されない場合SQL文が成り立たないのでエラー
                    if (!set)
                    {
                        throw new ArgumentException();
                    }

                    // WHERE句の編集
                    sql += " where freecd = :freecd";

                    connection.Execute(sql, param);

                    // トランザクションをコミット
                    transaction.Commit();

                    // 戻り値の設定
                    ret = true;
                }
                catch
                {
                    // 異常終了ならRollBack
                    transaction.Rollback();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 汎用テーブルレコードを削除する
        /// </summary>
        /// <param name="freeCd">汎用コード</param>
        /// <returns>
        /// True   正常終了
        /// False  異常終了
        /// </returns>
        public bool DeleteFree(string freeCd)
        {

            string sql;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("freecd", freeCd.Trim());

            // 汎用テーブルレコードの削除
            sql = @"
                    delete free
                    where
                      freecd = :freecd
                 ";

            connection.Execute(sql, param);

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// 汎用テーブル読み込み
        /// </summary>
        /// <param name="freeCdKey">汎用コード(検索キー値)</param>
        /// <param name="startPos">開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <returns>
        /// freecd      汎用コード
        /// freeclasscd 汎用分類コード
        /// freename    汎用名
        /// freedate    汎用日付
        /// freefield1  汎用フィールド1
        /// freefield2  汎用フィールド2
        /// freefield3  汎用フィールド3
        /// freefield4  汎用フィールド4
        /// freefield5  汎用フィールド5
        /// </returns>
        public List<dynamic> GdeSelectFree(string freeCdKey, int startPos, int getCount)
        {
            string sql;

            // 開始位置から取得件数分のレコードを取得
            sql = @"
                    select
                      freecd
                      , freeclasscd
                      , freename
                      , freedate
                      , freefield1
                      , freefield2
                      , freefield3
                      , freefield4
                      , freefield5
                      , freefield6
                      , freefield7
                ";

            // 検索条件を満たす個人テーブルのレコードを取得
            sql += @"
                    from
                      (
                        select
                          rownum seq
                          , freecd
                          , freeclasscd
                          , freename
                          , freedate
                          , freefield1
                          , freefield2
                          , freefield3
                          , freefield4
                          , freefield5
                          , freefield6
                          , freefield7
                        from
                          free
                ";
            sql += " where freecd like '" + freeCdKey + "%'";

            // 指導内容区分，定型面接文章コードの順にソート
            sql += " order by freecd )";

            // 取得開始・終了位置を条件として追加
            sql += " where seq between " + Convert.ToString(startPos) + " and " + Convert.ToString(startPos + getCount - 1);

            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 検索条件を満たす汎用テーブルの一覧を取得する
        /// </summary>
        /// <param name="freeCdKey">検索キーの集合</param>
        /// <returns>検索条件を満たすレコード件数</returns>
        public int GdeSelectFreeCount(string freeCdKey)
        {
            string sql;

            sql = @"
                    select
                      count(*) as cnt
                    from
                      free
                ";
            sql += "where freecd like '" + freeCdKey + "%'";
            sql += "order by freecd";

            return Convert.ToInt32(connection.Query(sql).FirstOrDefault().CNT);
        }
    }
}
