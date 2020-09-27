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
    /// 判定分類情報データアクセスオブジェクト
    /// </summary>
    public class JudClassDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public JudClassDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 検索条件を満たす判定分類の一覧を取得する
        /// </summary>
        /// <returns>
        /// judclasscd 判定分類コード
        /// judclassname 判定分類名称
        /// alljudflg 統計用総合判定フラグ
        /// commentonly コメント表示モード
        /// vieworder 判定分類表示順
        /// resultdispmode 検査結果表示モード（判定リンク用）
        /// notautoflg 自動判定対象外フラグ
        /// notnormalflg 通常判定対象外フラグ
        /// </returns>
        public List<dynamic> SelectJudClassList()
        {
            // 検索条件を満たす判定分類テーブルのレコードを取得
            string sql = @"
                    select
                        jc.judclasscd
                        , jc.judclassname
                        , jc.alljudflg
                        , jc.commentonly
                        , jc.vieworder
                        , jc.resultdispmode
                        , jc.notautoflg
                        , jc.notnormalflg
                    from
                        judclass jc
                    order by
                        jc.judclasscd
                ";

            // SQL実行
            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 判定分類コードに対する判定分類名を取得する
        /// </summary>
        /// <param name="judClassCd">判定分類コード</param>
        /// <returns>
        /// judclassname  判定分類名
        /// </returns>
        public dynamic SelectJudClassName(string judClassCd)
        {
            // 検索条件が設定されていない場合は処理を終了する
            if (judClassCd.Trim() == "")
            {
                return null;
            }

            // キー値の設定
            var sqlParam = new
            {
                judclasscd = judClassCd.Trim()
            };

            // 索条件を満たす判定分類テーブルのレコードを取得
            string sql = @"
                select
                    judclassname
                from
                    judclass
                where
                    judclasscd = :judclasscd
                ";

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 判定分類テーブルレコードを削除する
        /// </summary>
        /// <param name="judClassCd">判定分類コード</param>
        /// <returns>削除件数</returns>
        public bool DeleteJudClass(int judClassCd)
        {
            // キー及び更新値の設定
            var sqlParam = new
            {
                judclasscd = judClassCd
            };

            // 判定分類テーブルレコードの削除
            string sql = @"
                    delete judclass
                    where
                        judclasscd = :judclasscd
                    ";

            // SQL実行
            connection.Execute(sql, sqlParam);

            return true;
        }

        /// <summary>
        /// 判定分類テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// judclasscd 判定分類コード
        /// judclassname 判定分類名
        /// alljudflg 統計用総合判定フラグ
        /// commentonly コメント表示モード
        /// vieworder 判定分類表示順
        /// resultdispmode 検査結果表示モード（判定リンク用）
        /// notautoflg 自動判定対象外フラグ
        /// notnormalflg 通常判定対象外フラグ
        /// </param>
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Duplicate 同一キーのレコード存在
        ///	Insert.Error 異常終了
        /// </returns>
        public Insert RegistJudClass(string mode, JToken data)
        {
            string sql; // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var sqlParam = new
            {
                judclasscd = Convert.ToString(data["judclasscd"]),
                judclassname = Convert.ToString(data["judclassname"]),
                alljudflg = Convert.ToString(data["alljudflg"]),
                commentonly = Convert.ToString(data["commentonly"]),
                vieworder = Convert.ToString(data["vieworder"]),
                resultdispmode = Convert.ToString(data["resultdispmode"]),
                notautoflg = Convert.ToString(data["notautoflg"]),
                notnormalflg = Convert.ToString(data["notnormalflg"])
            };

            while (true)
            {
                // 判定分類テーブルレコードの更新
                if (mode == "UPD")
                {
                    sql = @"
                        update judclass
                        set
                            judclassname = :judclassname
                            , alljudflg = :alljudflg
                            , commentonly = :commentonly
                            , vieworder = :vieworder
                            , resultdispmode = :resultdispmode
                            , notautoflg = :notautoflg
                            , notnormalflg = :notnormalflg
                        where
                            judclasscd = :judclasscd
                        ";

                    // SQL実行
                    ret2 = connection.Execute(sql, sqlParam);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす判定分類テーブルのレコードを取得
                // SQL定義
                sql = @"
                    select
                        judclasscd
                    from
                        judclass
                    where
                        judclasscd = :judclasscd
                    ";

                dynamic current = connection.Query(sql, sqlParam).FirstOrDefault();

                if (current != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                sql = @"
                    insert
                    into judclass(
                        judclasscd
                        , judclassname
                        , alljudflg
                        , commentonly
                        , vieworder
                        , resultdispmode
                        , notautoflg
                        , notnormalflg
                    )
                    values (
                        :judclasscd
                        , :judclassname
                        , :alljudflg
                        , :commentonly
                        , :vieworder
                        , :resultdispmode
                        , :notautoflg
                        , :notnormalflg
                    )
                    ";

                // SQL実行
                connection.Execute(sql, sqlParam);

                ret = Insert.Normal;
                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 判定分類レコードを登録する（トランザクション対応）
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// intjudclasscd 判定分類コード
        /// judclassname 判定分類名
        /// alljudflg 統計用総合判定フラグ
        /// aftercarecd アフターケアコード
        /// itemcount 更新検査項目数
        /// itemcd 検査項目コード
        /// commentonly コメント表示モード
        /// vieworder 判定分類表示順
        /// resultdispmode 検査結果表示モード（判定リンク用）
        /// notautoflg 自動判定対象外フラグ
        /// notnormalflg 通常判定対象外フラグ
        /// </param>
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Duplicate 同一キーのレコード存在
        ///	Insert.Error 異常終了
        /// </returns>
        public Insert RegistJudClass_All(string mode, JToken data)
        {
            Insert ret; // 関数戻り値

            ret = Insert.Error;

            using (var transaction = BeginTransaction())
            {

                while (true)
                {
                    // 判定分類テーブルの更新
                    ret = RegistJudClass(mode, data);

                    // 異常終了なら処理終了
                    if (ret != Insert.Normal)
                    {
                        break;
                    }

                    // 判定分類検査項目テーブルの更新
                    ret = RegistJudClass_Item(
                        Convert.ToInt32(data["judclasscd"]),
                        Convert.ToInt32(data["itemcount"]),
                        data["item"]);

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

            return ret;
        }

        /// <summary>
        /// 判定分類内検査項目を登録する
        /// </summary>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="itemCount">更新検査項目数</param>
        /// <param name="data">
        /// itemcd 検査項目コード
        /// </param>
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Error 異常終了
        /// </returns>
        public Insert RegistJudClass_Item(int judClassCd, int itemCount, JToken data)
        {
            string sql; // SQLステートメント
            Insert ret; // 関数戻り値

            ret = Insert.Error;

            // キー及び更新値の設定
            var sqlParam = new
            {
                judclasscd = judClassCd
            };

            // 判定分類内検査項目レコードの削除
            sql = @"
                delete item_jud
                where
                    judclasscd = :judclasscd
                ";

            // SQL実行
            connection.Execute(sql, sqlParam);

            if (itemCount > 0)
            {
                // キー及び更新値の設定再割り当て
                var sqlParamArray = new List<dynamic>();

                for (int i = 0; i < itemCount; i++)
                {
                    sqlParamArray.Add(new
                    {
                        itemcd = Convert.ToString(data[i]["itemcd"]),
                        judclasscd = judClassCd
                    });
                }

                // 新規挿入
                sql = @"
                    insert
                    into item_jud(itemcd, judclasscd)
                    values (:itemcd, :judclasscd)
                    ";

                connection.Execute(sql, sqlParamArray);
            }

            ret = Insert.Normal;

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 判定分類コードに対する情報を取得する
        /// </summary>
        /// <param name="judClassCd">判定分類コード</param>
        /// <returns>判定分類情報</returns>
        public dynamic SelectJudClass(int judClassCd)
        {
            // キー値の設定
            var sqlParam = new
            {
                judclasscd = judClassCd
            };

            // 検索条件を満たす判定分類テーブルのレコードを取得
            string sql = @"
                select
                    jc.judclasscd
                    , jc.judclassname
                    , jc.alljudflg
                    , jc.commentonly
                    , jc.vieworder
                    , jc.resultdispmode
                    , jc.notautoflg
                    , jc.notnormalflg
                    from
                    judclass jc
                where
                    judclasscd = :judclasscd
            ";

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 判定分類に合致する検査項目の一覧を取得する
        /// </summary>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="includeSuffix">サフィックス（省略可能）</param>
        /// <returns>
        /// itemname 検査項目名
        /// classname 検査分類名
        /// </returns>
        public List<dynamic> SelectJudClassItemList(string judClassCd, bool includeSuffix = false)
        {
            string sql; // SQLステートメント

            if (!includeSuffix)
            {
                // 依頼項目で検索する場合
                sql = @"
                        select
                          ic.itemcd
                          , ic.requestname itemname
                          , cs.classname
                        from
                          itemclass cs
                          , item_jud ij
                          , item_p ic
                        where
                          ij.judclasscd = :judclasscd
                          and ij.itemcd = ic.itemcd
                          and cs.classcd = ic.classcd
                        order by
                          ic.itemcd
                    ";
            }
            else
            {
                // 検査項目で検索する場合
                sql = @"
                        select
                          ic.itemcd
                          , ic.suffix
                          , ic.itemname
                          , cs.classname
                        from
                          itemclass cs
                          , item_jud ij
                          , item_c ic
                        where
                          ij.judclasscd = :judclasscd
                          and ij.itemcd = ic.itemcd
                          and cs.classcd = ic.classcd
                        order by
                          ic.itemcd
                          , ic.suffix
                    ";
            }

            // SQL実行
            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 指定の予約番号リストから総合判定件数の最大値を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号リスト</param>
        /// <returns>総合判定件数の最大値</returns>
        public int SelectJudClassMaxCount(int[] rsvNo)
        {
            // 予約番号リストがEmptyの場合は処理を終了する
            if (rsvNo == null || rsvNo.Length == 0)
            {
                throw new ArgumentException();
            }

            // SQL文の編集
            string sql = @"
                    select
                        max(cnt) maxcnt
                    from
                        (select j.rsvno, count(*) cnt from judrsl j
                    ";

            var sqlParam = new Dictionary<string, object>();

            // WHERE句の作成
            if (rsvNo.Length == 1)
            {
                // 1件のみの検索
                sql += @"
                    where
                        j.rsvno = :rsvno
                    ";

                sqlParam.Add("rsvno", rsvNo[0]);
            }
            else
            {
                sql += @"
                    where
                        j.rsvno in (
                    ";

                // 複数件の検索
                for (int i = 0; i < rsvNo.Length; i++)
                {
                    if (i > 0)
                    {
                        sql += ",";
                    }

                    string param = "rsvno" + i.ToString();
                    sql += ":" + param;
                    sqlParam.Add(param, rsvNo[i]);
                }

                sql += " ) ";
            }

            sql += @"
                    group by
                        j.rsvno
                    )";

            // SQL実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            int ret = 0;

            // 検索レコードが存在する場合は件数を戻り値として設定
            // (MAX関数を発行しているので必ず1レコード返ってくる)
            if (result != null)
            {
                ret = result.MAXCNT ?? 0;
            }

            return ret;
        }

        #region 新設メソッド

        ///// <summary>
        ///// 判定分類の一覧を取得する
        ///// </summary>
        ///// <param name="qp">クエリパラメータ</param>
        ///// <returns>判定分類の一覧</returns>
        //public DataSet SelectJudClassList()
        //{
        //    // SQL定義
        //    string sql = @"
        //            select
        //                jc.judclasscd
        //                , jc.judclassname
        //                , jc.alljudflg
        //                , jc.commentonly
        //                , jc.vieworder
        //                , jc.resultdispmode
        //                , jc.notautoflg
        //                , jc.notnormalflg
        //            from
        //                judclass jc
        //            order by
        //                jc.judclasscd
        //        ";

        //    // SQL実行
        //    return new DataSet(Query(sql).ToList());
        //}

        #endregion
    }
}
