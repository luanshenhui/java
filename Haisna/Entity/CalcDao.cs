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
    /// 計算情報データアクセスオブジェクト
    /// </summary>
    public class CalcDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public CalcDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 計算（履歴・親）の一覧を取得する
        /// </summary>
        /// <param name="summary">TRUE:検査項目コード、サフィックスでGROUP BY</param>
        /// <param name="itemCd">検査項目コード（空白可）</param>
        /// <param name="suffix">サフィックス（空白可）</param>
        /// <returns>
        /// itemCd         検査項目コード
        /// suffix         サフィックス
        /// itemName       検査項目名
        /// calcHNo        計算履歴Ｎｏ（blnSummary=Trueのとき）
        ///                計算履歴管理数（blnSummary=Falseのとき）
        /// strDate        使用開始日付（blnSummary=Falseのときは返しません）
        /// endDate        使用終了日付（blnSummary=Falseのときは返しません）
        /// fraction       端数処理（blnSummary=Falseのときは返しません）
        /// timing         計算タイミング（blnSummary=Falseのときは返しません）
        /// explanation    説明（blnSummary=Falseのときは返しません）
        /// </returns>
        public List<dynamic> SelectCalcList(bool summary, string itemCd, string suffix)
        {
            string sql; // SQLステートメント

            // 初期処理
            bool selectItem = false;

            var param = new Dictionary<string, object>();

            // 検査項目コードとサフィックスを指定されている場合はフラグON
            if (!"".Equals(itemCd) && !"".Equals(suffix))
            {
                selectItem = true;
                param.Add("itemcd", itemCd);
                param.Add("suffix", suffix);
            }

            // SQL Build
            if (summary == true)
            {
                // 検査項目コード、サフィックスでサマリする場合
                sql = @"
                        select
                          targetcalc.itemcd
                          , targetcalc.suffix
                          , item_c.itemname
                          , targetcalc.calchno
                        from
                          item_c
                          , (
                            select
                              itemcd
                              , suffix
                              , count(calchno) calchno
                            from
                              calc
                            group by
                              itemcd
                              , suffix
                          ) targetcalc
                        where
                          targetcalc.itemcd = item_c.itemcd
                          and targetcalc.suffix = item_c.suffix
                    ";

                // 検査項目コードとサフィックスを指定されている場合は検索条件に追加
                if (selectItem == true)
                {
                    sql += @"
                            and targetcalc.itemcd = :itemcd
                            and targetcalc.suffix = :suffix
                         ";
                }

                // 読み込み順指定
                sql += " order by targetcalc.itemcd, targetcalc.suffix";
            }
            else
            {
                // 履歴を全て取得する場合
                sql = @"
                        select
                          calc.itemcd
                          , calc.suffix
                          , item_c.itemname
                          , calc.calchno
                          , calc.strdate
                          , calc.enddate
                          , calc.fraction
                          , calc.timing
                          , calc.explanation
                        from
                          item_c
                          , calc
                        where
                          calc.itemcd = item_c.itemcd
                          and calc.suffix = item_c.suffix
                     ";

                // 検査項目コードとサフィックスを指定されている場合は検索条件に追加
                if (selectItem == true)
                {
                    sql += @"
                            and calc.itemcd = :itemcd
                            and calc.suffix = :suffix
                         ";
                }

                // 読み込み順指定
                sql += " order by calc.itemcd, calc.suffix, calc.enddate desc";
            }

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 計算詳細の一覧を取得する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="calcHNo">計算履歴No</param>
        /// <returns>
        /// gender         性別
        /// seq            計算順
        /// variable1      変数１
        /// calcItemCd1    計算項目コード１
        /// calcSuffix1    計算サフィックス１
        /// calcItemName1  項目名１
        /// constant1      定数１
        /// operator       演算記号
        /// variable2      変数２
        /// calcItemCd2    計算項目コード２
        /// calcSuffix2    計算サフィックス２
        /// calcItemName2  項目名２
        /// constant2      定数２
        /// calcResult     計算結果
        /// </returns>
        public List<dynamic> SelectCalc_cList(string itemCd, string suffix, int calcHNo)
        {
            // 主キーが設定されていない場合はエラー
            if ("".Equals(itemCd) || "".Equals(suffix))
            {
                throw new ArgumentException();
            }

            var param = new Dictionary<string, object>();
            param.Add("itemcd", itemCd);
            param.Add("suffix", suffix);
            param.Add("calchno", calcHNo);

            // 計算テーブルよりレコードを取得
            string sql = @"
                            select
                              calc_c.gender
                              , calc_c.seq
                              , calc_c.variable1
                              , calc_c.calcitemcd1
                              , calc_c.calcsuffix1
                              , item1.itemname itemname1
                              , calc_c.constant1
                              , calc_c.operator
                              , calc_c.variable2
                              , calc_c.calcitemcd2
                              , calc_c.calcsuffix2
                              , item2.itemname itemname2
                              , calc_c.constant2
                              , calc_c.calcresult
                            from
                              item_c item1
                              , item_c item2
                              , calc_c calc_c
                            where
                              calc_c.itemcd = :itemcd
                              and calc_c.suffix = :suffix
                              and calc_c.calchno = :calchno
                              and calc_c.calcitemcd1 = item1.itemcd(+)
                              and calc_c.calcsuffix1 = item1.suffix(+)
                              and calc_c.calcitemcd2 = item2.itemcd(+)
                              and calc_c.calcsuffix2 = item2.suffix(+)
                            order by
                              calc_c.gender
                              , calc_c.seq
                       ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 計算テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// itemCd          検査項目コード
        /// suffix          サフィックス
        /// calcHNo         計算履歴Ｎｏ
        /// strDate         使用開始日付
        /// endDate         使用終了日付
        /// fraction        端数処理
        /// timing          計算タイミング
        /// explanation     説明
        /// </param>
        /// <returns>
        /// Insert.Normal     正常終了
        ///	Insert.Duplicate  同一キーのレコード存在
        ///	Insert.Error      異常終了
        /// </returns>
        public Insert RegistCalc(string mode, JToken data)
        {
            string sql;  // SQLステートメント
            Insert ret = Insert.Error;  // 関数戻り値
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("itemcd", Convert.ToString(data["itemcd"]));
            param.Add("suffix", Convert.ToString(data["suffix"]));
            param.Add("strdate", Convert.ToDateTime(data["strdate"]));
            param.Add("enddate", Convert.ToDateTime(data["enddate"]));

            // 履歴データの重複チェック
            if ("INS".Equals(mode))
            {
                sql = @"
                        select
                          itemcd
                        from
                          calc
                        where
                          itemcd = :itemcd
                          and suffix = :suffix
                          and (
                            :strdate between strdate and enddate
                            or :enddate between strdate and enddate
                          )
                     ";
            }
            else
            {
                param.Add("calchno", Convert.ToInt32(data["calchno"]));
                sql = @"
                        select
                          itemcd
                        from
                          calc
                        where
                          itemcd = :itemcd
                          and suffix = :suffix
                          and calchno != :calchno
                          and (
                            :strdate between strdate and enddate
                            or :enddate between strdate and enddate
                          )
                     ";
            }

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // 検索レコードが存在する場合
            if (current != null)
            {
                ret = Insert.HistoryDuplicate;
            }

            if ("INS".Equals(mode))
            {
                // 新規登録モード

                // 計算履歴Ｎｏの取得
                sql = @"
                        select
                          nvl(max(calchno) + 1, 0) newno
                        from
                          calc
                        where
                          itemcd = :itemcd
                          and suffix = :suffix
                      ";

                current = connection.Query(sql, param).FirstOrDefault();

                param.Add("calchno", current.NEWNO);
            }

            param.Add("fraction", Convert.ToInt32(data["fraction"]));
            param.Add("timing", Convert.ToInt32(data["timing"]));
            param.Add("explanation", Convert.ToString(data["explanation"]));

            while (true)
            {
                // 計算テーブルレコードの更新
                if ("UPD".Equals(mode))
                {
                    sql = @"
                            update calc
                            set
                              strdate = :strdate
                              , enddate = :enddate
                              , fraction = :fraction
                              , timing = :timing
                              , explanation = :explanation
                            where
                              calc.itemcd = :itemcd
                              and calc.suffix = :suffix
                              and calc.calchno = :calchno
                        ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                sql = @"
                        insert
                        into calc(
                          itemcd
                          , suffix
                          , calchno
                          , strdate
                          , enddate
                          , fraction
                          , timing
                          , explanation
                        )
                        values (
                          :itemcd
                          , :suffix
                          , :calchno
                          , :strdate
                          , :enddate
                          , :fraction
                          , :timing
                          , :explanation
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
        /// 計算テーブル及び計算詳細テーブルレコードを登録する（トランザクション対応）
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// itemCd          検査項目コード
        /// suffix          サフィックス
        /// calcHNo         計算履歴Ｎｏ
        /// strDate         使用開始日付
        /// endDate         使用終了日付
        /// fraction        端数処理
        /// timing          計算タイミング
        /// explanation     説明
        /// itemCount       計算式の明細行数
        /// gender          性別
        /// seq             計算順
        /// variable1       変数１
        /// calcItemCd1     計算項目コード１
        /// calcSuffix1     計算サフィックス１
        /// constant1       定数１
        /// operator        演算記号
        /// variable2       変数２
        /// calcItemCd2     計算項目コード２
        /// calcSuffix2     計算サフィックス２
        /// constant2       定数２
        /// calcResult      計算結果
        /// </param>
        /// <returns>
        /// Insert.Normal     正常終了
        ///	Insert.Duplicate  同一キーのレコード存在
        ///	Insert.Error      異常終了
        /// </returns>
        public Insert RegistCalc_All(string mode, JToken data)
        {
            Insert ret; // 関数戻り値

            ret = Insert.Error;

            using (var transaction = BeginTransaction())
            {
                while (true)
                {
                    // 計算テーブルの更新
                    ret = RegistCalc(mode, data);

                    // 異常終了なら処理終了
                    if (ret != Insert.Normal)
                    {
                        break;
                    }

                    // 計算詳細テーブルの更新
                    ret = RegistCalc_c(data);

                    // 異常終了なら処理終了
                    if (ret != Insert.Normal)
                    {
                        break;
                    }

                    break;
                }

                if (ret == Insert.Normal)
                {
                    // 正常ならCommit これはRootトランザクションなのでCommit
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
        /// 計算詳細テーブルレコードを登録する
        /// </summary>
        /// <param name="data">
        /// itemCount       計算式の明細行数
        /// itemCd          検査項目コード
        /// suffix          サフィックス
        /// calcHNo         計算履歴No
        /// gender          性別
        /// seq             計算順
        /// variable1       変数１
        /// calcItemCd1     計算項目コード１
        /// calcSuffix1     計算サフィックス１
        /// constant1       定数１
        /// operator        演算記号
        /// variable2       変数２
        /// calcItemCd2     計算項目コード２
        /// calcSuffix2     計算サフィックス２
        /// constant2       定数２
        /// calcResult      計算結果
        /// </param>
        /// <returns>
        /// Insert.Normal  正常終了
        ///	Insert.Error   異常終了
        /// </returns>
        public Insert RegistCalc_c(JToken data)
        {
            string sql; // SQLステートメント

            Insert ret = Insert.Error;

            // 対象計算詳細レコードの削除
            var param = new Dictionary<string, object>();
            param.Add("itemcd", Convert.ToString(data["itemcd"]));
            param.Add("suffix", Convert.ToString(data["suffix"]));
            param.Add("calchno", Convert.ToInt32(data["calchno"]));

            sql = @"
                    delete calc_c
                    where
                      itemcd = :itemcd
                      and suffix = :suffix
                      and calchno = :calchno
                 ";
            connection.Execute(sql, param);

            List<JToken> items = data.ToObject<List<JToken>>();
            if (items.Count > 0)
            {
                // キー及び更新値の設定再割り当て
                var paramArray = new List<dynamic>();
                foreach (var rec in items)
                {
                    param = new Dictionary<string, object>();
                    param.Add("itemcd", Convert.ToString(rec["itemcd"]));
                    param.Add("suffix", Convert.ToInt32(rec["suffix"]));
                    param.Add("calchno", Convert.ToString(rec["calchno"]));
                    param.Add("gender", Convert.ToString(rec["gender"]));
                    param.Add("seq", Convert.ToString(rec["seq"]));
                    param.Add("variable1", Convert.ToString(rec["variable1"]));
                    param.Add("calcitemcd1", Convert.ToString(rec["calcitemcd1"]));
                    param.Add("calcsuffix1", Convert.ToString(rec["calcsuffix1"]));
                    param.Add("constant1", Convert.ToString(rec["constant1"]));
                    param.Add("operator", Convert.ToString(rec["operator"]));
                    param.Add("variable2", Convert.ToString(rec["variable2"]));
                    param.Add("calcitemcd2", Convert.ToString(rec["calcitemcd2"]));
                    param.Add("calcsuffix2", Convert.ToString(rec["calcsuffix2"]));
                    param.Add("constant2", Convert.ToString(rec["constant2"]));
                    param.Add("calcresult", Convert.ToString(rec["calcresult"]));
                    paramArray.Add(param);
                }

                // 新規挿入
                sql = @"
                        insert
                        into calc_c(
                          itemcd
                          , suffix
                          , calchno
                          , gender
                          , seq
                          , variable1
                          , calcitemcd1
                          , calcsuffix1
                          , constant1
                          , operator
                          , variable2
                          , calcitemcd2
                          , calcsuffix2
                          , constant2
                          , calcresult
                        )
                        values (
                          :itemcd
                          , :suffix
                          , :calchno
                          , :gender
                          , :seq
                          , :variable1
                          , :calcitemcd1
                          , :calcsuffix1
                          , :constant1
                          , :operator
                          , :variable2
                          , :calcitemcd2
                          , :calcsuffix2
                          , :constant2
                          , :calcresult
                        )
                     ";
                connection.Execute(sql, paramArray);
                ret = Insert.Normal;
            }
            else
            {
                // 0件ならそのまま終了
                ret = Insert.Normal;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 計算テーブルレコードを削除する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="calcHNo">計算履歴No（省略可）</param>
        /// <returns>
        /// True   正常終了
        /// False  異常終了
        /// </returns>
        public bool DeleteCalc(string itemCd, string suffix, string calcHNo = "")
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("itemcd", itemCd);
            param.Add("suffix", suffix);

            if (calcHNo != "")
            {
                param.Add("calchno", calcHNo);
            }

            // SQL Build
            string sql = "delete calc where itemcd = :itemcd and suffix = :suffix";
            if (calcHNo != "")
            {
                sql += " and calchno = :calchno";
            }

            // 計算テーブルレコードの削除
            connection.Execute(sql, param);

            // 戻り値の設定
            return true;
        }
    }
}