using Dapper;
using Hainsi.Common.Constants;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 請求書分類情報データアクセスオブジェクト
    /// </summary>
    public class DmdClassDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public DmdClassDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 請求書分類レコードを登録する（トランザクション対応）
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// billClassCd         請求書分類コード
        /// billClassName       請求書分類名
        /// defCheck            デフォルトチェック
        /// otherIncome         雑収入扱い
        /// crfFileName         出力ファイル名
        /// itemCount           更新コースコード数
        /// csCd                コースコード
        /// billTitle           請求内訳書用タイトル
        /// </param>
        /// <returns>
        /// Insert.Normal     正常終了
        /// Insert.Duplicate  同一キーのレコード存在
        /// Insert.Error      異常終了
        /// </returns>
        public Insert RegistBillClass_All(string mode, JToken data)
        {
            Insert ret; // 関数戻り値

            ret = Insert.Error;

            using (var transaction = BeginTransaction())
            {
                while (true)
                {
                    // 請求書分類テーブルの更新
                    ret = RegistBillClass(mode, data);

                    // 異常終了なら処理終了
                    if (ret != Insert.Normal)
                    {
                        break;
                    }

                    // 請求書分類内項目テーブルの更新
                    ret = RegistBillClass_C(Convert.ToString(data["billClassCd"]), Convert.ToInt32(data["itemCount"]), data["csCd"].ToObject<List<string>>());

                    // 異常終了なら処理終了
                    if (ret != Insert.Normal)
                    {
                        break;
                    }

                    break;
                }

                if (ret == Insert.Normal)
                {
                    transaction.Commit();
                }
                else
                {
                    // 異常終了ならRollBack
                    transaction.Rollback();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 請求書分類内コースを登録する
        /// </summary>
        /// <param name="billClassCd">請求書分類コード</param>
        /// <param name="itemCount">更新コースコード数</param>
        /// <param name="csCd">コースコード</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Error  異常終了
        /// </returns>
        public Insert RegistBillClass_C(string billClassCd, int itemCount, List<string> csCd)
        {
            string sql; // SQLステートメント

            Insert ret = Insert.Error;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("billclasscd", billClassCd);

            // 請求書分類内コースレコードの削除
            sql = @"
                    delete billclass_c
                    where
                      billclasscd = :billclasscd
                 ";
            connection.Execute(sql, param);

            if (itemCount > 0)
            {
                // キー及び更新値の設定再割り当て
                var paramArray = new List<dynamic>();
                for (int i = 0; i < itemCount; i++)
                {
                    param = new Dictionary<string, object>();
                    param.Add("billclasscd", billClassCd);
                    param.Add("cscd", csCd[i]);
                    paramArray.Add(param);
                }

                // 新規挿入
                sql = @"
                        insert
                        into billclass_c(billclasscd, cscd)
                        values (:billclasscd, :cscd)
                     ";
                connection.Execute(sql, paramArray);
            }

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 請求書分類の一覧を取得する
        /// </summary>
        /// <returns>
        /// billClassCd    請求書分類コード
        /// billClassName  請求書分類名称（省略可）
        /// defCheck       デフォルトチェック
        /// otherIncome    雑収入扱い
        /// crfFileName    出力ファイル名
        /// </returns>
        public dynamic SelectBillClassList()
        {
            // 検索条件を満たす請求書分類分類テーブルのレコードを取得
            string sql = @"
                           select
                             billclasscd
                             , billclassname
                             , defcheck
                             , otherincome
                             , crffilename
                           from
                             billclass
                           order by
                             billclasscd
                       ";

            return connection.Query(sql).FirstOrDefault();
        }

        /// <summary>
        /// 請求書分類管理コースの一覧を取得する
        /// </summary>
        /// <param name="billClassCd">請求書分類コード</param>
        /// <returns>
        /// CsCd           コースコード
        /// CsName         コース名
        /// </returns>
        public List<dynamic> SelectBillClass_cList(string billClassCd)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("billclasscd", billClassCd);

            // 検索条件を満たす請求書分類分類テーブルのレコードを取得
            string sql = @"
                           select
                             billclass_c.cscd
                             , course_p.csname
                           from
                             course_p
                             , 　billclass_c
                           where
                             billclass_c.billclasscd = :billclasscd
                             and course_p.cscd = billclass_c.cscd
                           order by
                             billclass_c.cscd
                       ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 請求書分類情報を取得する
        /// </summary>
        /// <param name="billClassCd">請求書分類コード</param>
        /// <returns>
        /// billClassName   請求書分類名称（省略可）
        /// defCheck        デフォルトチェック（省略可）
        /// otherIncome     雑収入扱い（省略可）
        /// crfFileName     出力ファイル名（省略可）
        /// billTitle       請求内訳書用タイトル（省略可）
        /// </returns>
        public List<dynamic> SelectBillClass(string billClassCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("billclasscd", billClassCd);

            string sql = @"
                           select
                             billclassname
                             , defcheck
                             , otherincome
                             , crffilename
                             , billtitle
                           from
                             billclass
                           where
                             billclasscd = :billclasscd
                       ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 請求書分類テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// billClassCd     請求書分類コード
        /// billClassName   請求書分類名称
        /// defCheck        デフォルトチェック
        /// otherIncome     雑収入扱い
        /// crfFileName     出力ファイル名
        /// billTitle       請求内訳書用タイトル
        /// </param>
        /// <returns>
        /// Insert.Normal     正常終了
        /// Insert.Duplicate  同一キーのレコード存在
        /// Insert.Error      異常終了
        /// </returns>
        public Insert RegistBillClass(string mode, JToken data)
        {
            string sql;  // SQLステートメント
            Insert ret = Insert.Error;  // 関数戻り値
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("billclasscd", Convert.ToString(data["billclasscd"]));
            param.Add("billclassname", Convert.ToString(data["billclassname"]));
            param.Add("defcheck", Convert.ToString(data["defcheck"]));
            param.Add("otherincome", Convert.ToString(data["otherincome"]));
            param.Add("crffilename", Convert.ToString(data["crffilename"]));
            param.Add("billtitle", Convert.ToString(data["billtitle"]));

            while (true)
            {
                // 請求書分類テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update billclass
                            set
                              billclassname = :billclassname
                              , defcheck = :defcheck
                              , otherincome = :otherincome
                              , crffilename = :crffilename
                              , billtitle = :billtitle
                            where
                              billclasscd = :billclasscd
                        ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす請求書分類テーブルのレコードを取得
                sql = @"
                        select
                          billclasscd
                        from
                          billclass
                        where
                          billclasscd = :billclasscd
                    ";

                dynamic current = connection.Query(sql, param).FirstOrDefault();

                if (current != null)
                {
                    ret = Insert.HistoryDuplicate;
                    break;
                }

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                sql = @"
                        insert
                        into billclass(
                          billclasscd
                          , billclassname
                          , defcheck
                          , otherincome
                          , crffilename
                          , billtitle
                        )
                        values (
                          :billclasscd
                          , :billclassname
                          , :defcheck
                          , :otherincome
                          , :crffilename
                          , :billtitle
                        )
                    ";
                connection.Execute(sql, param);

                ret = Insert.Normal;
                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 請求書分類テーブルレコードを削除する
        /// </summary>
        /// <param name="billClassCd">請求書分類コード</param>
        /// <returns>
        /// True   正常終了
        /// False  異常終了
        /// </returns>
        public bool DeleteBillClass(string billClassCd)
        {

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("billclasscd", billClassCd);


            // 請求書分類テーブルレコードの削除
            string sql = @"
                           delete billclass
                           where
                             billclasscd = :billclasscd
                        ";
            connection.Execute(sql, param);

            // 戻り値の設定
            return true;
        }

        /// <summary>
        /// 請求明細分類の一覧を取得する
        /// </summary>
        /// <param name="mode">取得モード（0:すべて、1:一般で使用する請求明細分類のみ、2:健保で使用する請求明細分類のみ）</param>
        /// <returns>
        /// dmdLineClassCd    請求明細分類コード
        /// dmdLineClassName  請求明細分類名
        /// </returns>
        public List<dynamic> SelectDmdLineClassList(int mode = 0)
        {
            // 請求明細分類テーブル読み込み
            string sql = @"
                           select
                             dmdlineclasscd
                             , dmdlineclassname
                           from
                             dmdlineclass
                        ";

            // 一般で使用する請求明細分類のみ取得する場合の条件を追加
            if (mode == 1)
            {
                sql += @"
                         where
                           isrflg is null
                           or isrflg = 0
                     ";
            }

            // 健保で使用する請求明細分類のみ取得する場合の条件を追加
            if (mode == 2)
            {
                sql += @"
                         where
                           isrflg is null
                           or isrflg = 1
                     ";
            }

            sql += " order by dmdlineclasscd";

            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 請求明細分類の一覧を取得する
        /// </summary>
        /// <returns>
        /// mdLineClassCd     請求明細分類コード
        /// mdLineClassName   請求明細分類名称（省略可）
        /// umDetails         健診基本料集計フラグ
        /// srFlg             健保使用フラグ
        /// akeBillLine       請求書明細作成フラグ
        /// </returns>
        public List<dynamic> SelectDmdLineClassItemList()
        {
            // 検索条件を満たす請求明細分類分類テーブルのレコードを取得
            string sql = @"
                           select
                             dmdlineclasscd
                             , dmdlineclassname
                             , sumdetails
                             , isrflg
                             , makebillline
                           from
                             dmdlineclass
                           order by
                             dmdlineclasscd
                        ";

            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 請求明細分類情報を取得する
        /// </summary>
        /// <param name="dmdLineClassCd">請求明細分類コード</param>
        /// <returns>請求明細分類情報</returns>
        public dynamic SelectDmdLineClass(string dmdLineClassCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("dmdlineclasscd", dmdLineClassCd);

            // 検索条件を満たす請求明細分類テーブルのレコードを取得
            string sql = @"
                           select
                             dmdlineclassname
                             , sumdetails
                             , isrflg
                             , makebillline
                           from
                             dmdlineclass
                           where
                             dmdlineclasscd = :dmdlineclasscd
                        ";
            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 請求明細分類テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// dmdLineClassCd      請求明細分類コード
        /// dmdLineClassName    請求明細分類名称
        /// sumDetails          健診基本料集計フラグ
        /// isrFlg              健保使用フラグ
        /// makeBillLine        請求書明細作成フラグ
        /// </param>
        /// <returns>
        /// Insert.Normal     正常終了
        /// Insert.Duplicate  同一キーのレコード存在
        /// Insert.Error      異常終了
        /// </returns>
        public Insert RegistdmdLineClass(string mode, JToken data)
        {
            string sql;  // SQLステートメント
            Insert ret = Insert.Error;  // 関数戻り値
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("dmdlineclasscd", Convert.ToString(data["dmdlineclasscd"]));
            param.Add("dmdlineclassname", Convert.ToString(data["dmdlineclassname"]));
            param.Add("sumdetails", Convert.ToString(data["sumdetails"]));
            param.Add("isrflg", Convert.ToString(data["isrflg"]));
            param.Add("makebillline", Convert.ToString(data["makebillline"]));

            while (true)
            {
                // 請求明細分類テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update dmdlineclass
                            set
                              dmdlineclassname = :dmdlineclassname
                              , sumdetails = :sumdetails
                              , isrflg = :isrflg
                              , makebillline = :makebillline
                            where
                              dmdlineclasscd = :dmdlineclasscd
                        ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす請求明細分類テーブルのレコードを取得
                sql = @"
                        select
                          dmdlineclasscd
                        from
                          dmdlineclass
                        where
                          dmdlineclasscd = :dmdlineclasscd
                     ";

                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 検索レコードが存在する場合
                if (current != null)
                {
                    ret = Insert.HistoryDuplicate;
                }

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                sql = @"
                        insert
                        into dmdlineclass(
                          dmdlineclasscd
                          , dmdlineclassname
                          , sumdetails
                          , isrflg
                          , makebillline
                        )
                        values (
                          :dmdlineclasscd
                          , :dmdlineclassname
                          , :sumdetails
                          , :isrflg
                          , :makebillline
                        )
                    ";
                connection.Execute(sql, param);

                ret = Insert.Normal;
                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 請求明細分類テーブルレコードを削除する
        /// </summary>
        /// <param name="dmdLineClassCd">請求明細分類コード</param>
        /// <returns>
        /// True   正常終了
        /// False  異常終了
        /// </returns>
        public bool DeleteDmdLineClass(string dmdLineClassCd)
        {

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("dmdlineclasscd", dmdLineClassCd);


            // 請求明細分類テーブルレコードの削除
            string sql = @"
                           delete dmdlineclass
                           where
                             dmdlineclasscd = :dmdlineclasscd
                        ";
            connection.Execute(sql, param);

            // 戻り値の設定
            return true;
        }
    }
}
