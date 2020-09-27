using Dapper;
using Hainsi.Common.Constants;
using Hainsi.Entity.Model.PerResult;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 個人検査結果情報データアクセスオブジェクト
    /// </summary>
    public class PerResultDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public PerResultDao(IDbConnection connection) : base(connection)
        {

        }

        /// <summary>
        /// 個人検査項目情報を取得する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <returns>
        /// itemCd       検査項目コード
        /// suffix       サフィックス
        /// itemName     検査項目名
        /// result       検査項目コード
        /// resultType   結果タイプ
        /// itemType     項目タイプ
        /// stcItemCd    文章参照用項目コード
        /// shortStc     文章略称
        /// ispDate      検査日
        /// </returns>
        public List<dynamic> SelectPerResultList(string perId)
        {
            string sql; // SQLステートメント

            var param = new Dictionary<string, object>();
            // キー値の設定
            param.Add("perid", perId);
            param.Add("resulttype", ResultType.Sentence);

            // 指定個人の個人検査情報を取得
            sql = @"
                    select
                      basedresult.itemcd
                      , basedresult.suffix
                      , basedresult.result
                      , basedresult.ispdate
                      , basedresult.itemname
                      , basedresult.resulttype
                      , basedresult.itemtype
                      , basedresult.stcitemcd
                      , decode(basedresult.resulttype, :resulttype, sentence.shortstc, null) shortstc
                ";
            // 以下で取得した副問い合わせと文章情報を結合
            sql += @"
                    from
                      sentence
                      ,
                 ";

            // 以下で取得した副問い合わせと検査項目情報を結合
            sql += @"
                    (
                      select
                        baseditem.itemcd
                        , baseditem.suffix
                        , baseditem.result
                        , baseditem.ispdate
                        , item_c.itemname
                        , item_c.resulttype
                        , item_c.itemtype
                        , item_c.stcitemcd
                      from
                        item_c
                        ,
                 ";

            // MAX関数を利用し、重複検査項目をまとめる
            sql += @"
                    (
                      select
                        itemcd
                        , suffix
                        , max(result) result
                        , max(ispdate) ispdate
                 ";

            // 現個人検査情報の取得
            sql += @"
                    from
                      (
                        select
                          itemcd
                          , suffix
                          , result
                          , ispdate
                        from
                          perresult
                        where
                          perid = :perid
                 ";

            // 汎用テーブルで設定されている初期グループをもとに空の個人検査情報レコードを作成し、現個人検査情報と結合
            sql += @"
                    union all
                    select
                      grp_i.itemcd
                      , grp_i.suffix
                      , null result
                      , cast(null as date) ispdate
                    from
                      grp_i
                      , free
                    where
                      free.freecd = 'PERINSPECT'
                      and free.freefield1 = grp_i.grpcd)
                    group by
                      itemcd
                      , suffix) baseditem
                 ";

            // 検査項目情報との結合部
            sql += @"
                    where
                      baseditem.itemcd = item_c.itemcd
                      and baseditem.suffix = item_c.suffix) basedresult
                 ";

            // 文章情報との結合部
            sql += @"
                    where
                      basedresult.stcitemcd = sentence.itemcd(+)
                      and basedresult.itemtype = sentence.itemtype(+)
                      and basedresult.result = sentence.stccd(+)
                 ";
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定グループの個人検査項目情報を取得する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="getSeqMode">取得順 0:グループ内表示順　1:コード＋サフィックス 2:イメージファイル名順</param>
        /// <param name="allDataMode">全件取得モード（0:検査結果に存在する項目を取得、1:検査結果に存在しなくても全項目取得）</param>
        /// <returns>
        /// itemCd       検査項目コード
        /// suffix       サフィックス
        /// itemName     検査項目名
        /// result       検査項目コード
        /// resultType   結果タイプ
        /// itemType     項目タイプ
        /// stcItemCd    文章参照用項目コード
        /// shortStc     文章略称
        /// ispDate      検査日
        /// </returns>
        public List<dynamic> SelectPerResultGrpList(string perId, string grpCd, int? getSeqMode, int? allDataMode)
        {
            string sql; // SQLステートメント
            var param = new Dictionary<string, object>();

            // キー値の設定
            param.Add("perid", perId);
            param.Add("grpcd", grpCd);
            param.Add("resulttype", ResultType.Sentence);

            // 指定個人の個人検査情報を取得
            sql = @"
                    select
                      basedresult.itemcd
                      , basedresult.suffix
                      , basedresult.result
                      , basedresult.ispdate
                      , basedresult.itemname
                      , basedresult.resulttype
                      , basedresult.itemtype
                      , basedresult.stcitemcd
                      , decode(basedresult.resulttype, :resulttype, sentence.shortstc, null) shortstc
                      , sentence.imagefilename
                ";
            // 以下で取得した副問い合わせと文章情報を結合
            sql += @"
                    from
                      sentence
                      ,
                 ";

            // 以下で取得した副問い合わせと検査項目情報を結合
            sql += @"
                    (
                      select
                        baseditem.itemcd
                        , baseditem.suffix
                        , baseditem.seq
                        , baseditem.result
                        , baseditem.ispdate
                        , item_c.itemname
                        , item_c.resulttype
                        , item_c.itemtype
                        , item_c.stcitemcd
                      from
                        item_c
                        ,
                 ";
            // MAX関数を利用し、重複検査項目をまとめる
            sql += @"
                    (
                      select
                        itemcd
                        , suffix
                        , max(seq) seq
                        , max(result) result
                        , max(ispdate) ispdate
                 ";

            // 現個人検査情報の取得
            sql += @"
                    from
                      (
                        select
                          perresult.itemcd
                          , perresult.suffix
                          , grp_i.seq
                          , perresult.result
                          , perresult.ispdate
                        from
                          perresult
                          , grp_i
                        where
                          perresult.perid = :perid
                          and grp_i.grpcd = :grpcd
                          and perresult.itemcd = grp_i.itemcd
                          and perresult.suffix = grp_i.suffix
                          and perresult.result is not null
                 ";
            // 検査結果の無い項目も取得
            if (1 == allDataMode)
            {
                sql += @"
                        union all
                        select
                          grp_i.itemcd
                          , grp_i.suffix
                          , grp_i.seq
                          , null result
                          , cast(null as date) ispdate
                        from
                          grp_i
                        where
                          grp_i.grpcd = :grpcd
                 ";
            }

            sql += @"
                    )
                    group by
                      itemcd
                      , suffix) baseditem
                 ";

            // 検査項目情報との結合部
            sql += @"
                    where
                      baseditem.itemcd = item_c.itemcd
                      and baseditem.suffix = item_c.suffix) basedresult
                 ";

            // 文章情報との結合部
            sql += @"
                    where
                      basedresult.stcitemcd = sentence.itemcd(+)
                      and basedresult.itemtype = sentence.itemtype(+)
                      and basedresult.result = sentence.stccd(+)
                 ";

            // 並び指定
            switch (getSeqMode)
            {
                // グループ内表示順
                case 0:
                    sql += @"
                            order by
                              basedresult.seq
                         ";
                    break;
                // コード＋サフィックス
                case 1:
                    sql += @"
                            order by
                              basedresult.itemcd
                              , basedresult.suffix
                         ";
                    break;
                // イメージファイル名順
                case 2:
                    sql += @"
                            order by
                              sentence.imagefilename
                         ";
                    break;
                default:
                    throw new ArgumentException();
            }

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 個人検査結果テーブルを登録または更新する
        /// </summary>
        /// <param name="perResult">個人検査結果テーブル</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert MergePerResult(PerResult perResult)
        {
            string sql;
            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();

            IList<PerResultItem> items = perResult.PerResultItem;
            if (items.Count > 0)
            {
                // パラメーター値設定
                var paramArray = new List<dynamic>();
                foreach (var rec in items)
                {
                    param = new Dictionary<string, object>();
                    param.Add("perId", Convert.ToString(perResult.PerId));
                    param.Add("suffix", Convert.ToString(rec.Suffix));
                    param.Add("result", Convert.ToString(rec.Result));
                    param.Add("itemcd", Convert.ToString(rec.ItemCd));
                    param.Add("upddiv", Convert.ToInt32(rec.UpdDiv));
                    if (!String.IsNullOrEmpty(rec.IspDate))
                    {
                        param.Add("ispdate", Convert.ToDateTime(rec.IspDate));
                    }
                    else
                    {
                        param.Add("ispdate", null);
                    }

                    paramArray.Add(param);
                }

                using (var transaction = BeginTransaction())
                {

                    // 個人検査結果テーブルマージ用のSQLステートメント作成
                    sql = @"
                            merge
                            into perresult
                              using (
                                select
                                  :perid perid
                                  , :itemcd itemcd
                                  , :suffix suffix
                                  , :upddiv upddiv
                                  , sysdate upddate
                                  , :result result
                                  , :ispdate ispdate
                                from
                                  dual
                              ) setdataview
                                on (
                                  perresult.perid = setdataview.perid
                                  and perresult.itemcd = setdataview.itemcd
                                  and perresult.suffix = setdataview.suffix
                                )
                        ";

                    // 存在する場合、上書き更新
                    sql += @"
                            when matched then update
                            set
                              upddiv = setdataview.upddiv
                              , upddate = setdataview.upddate
                              , result = setdataview.result
                              , ispdate = setdataview.ispdate
                         ";

                    //
                    sql += @"
                            when not matched then
                            insert (
                              perid
                              , itemcd
                              , suffix
                              , upddiv
                              , upddate
                              , result
                              , ispdate
                            )
                            values (
                              setdataview.perid
                              , setdataview.itemcd
                              , setdataview.suffix
                              , setdataview.upddiv
                              , setdataview.upddate
                              , setdataview.result
                              , setdataview.ispdate
                            )
                         ";

                    ret2 = connection.Execute(sql, paramArray);

                    if (ret2 >= 0)
                    {
                        ret = Insert.Normal;
                        transaction.Commit();
                    }
                    else
                    {
                        // 異常終了ならRollBack
                        transaction.Rollback();
                    }
                }
            }
            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 個人検査結果テーブルを更新する
        /// </summary>
        /// <param name="data">個人検査結果テーブル
        /// perid      個人ＩＤ
        /// itemcd     検査項目コード
        /// suffix     サフィックス
        /// result     検査結果
        /// ispdate    検査日
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdatePerResult(PerResult data)
        {
            string sql;  // SQLステートメント
            string sql2; // SQLステートメント
            Insert ret = Insert.Error;
            int ret2;

            using (var transaction = BeginTransaction())
            {

                // キー及び更新値の設定
                var param = new Dictionary<string, object>();
                param.Add("perid", Convert.ToString(data.PerId));
                sql = @"
                        delete perresult
                        where
                          perid = :perid
                    ";

                // 指定個人の全ての個人検査結果情報を削除する
                connection.Execute(sql, param);

                IList<PerResultItem> items = data.PerResultItem;
                if (items.Count > 0)
                {
                    // パラメーター値設定
                    var paramArray = new List<dynamic>();
                    foreach (var rec in items)
                    {
                        param = new Dictionary<string, object>();
                        param.Add("perid", Convert.ToString(data.PerId));
                        param.Add("suffix", Convert.ToString(rec.Suffix));
                        param.Add("result", Convert.ToString(rec.Result));
                        param.Add("itemcd", Convert.ToString(rec.ItemCd));

                        if (!string.IsNullOrEmpty(Convert.ToString(rec.IspDate)))
                        {
                            param.Add("ispdate", Convert.ToDateTime(rec.IspDate));
                        }
                        else
                        {
                            param.Add("ispdate", null);
                        }

                        paramArray.Add(param);
                    }

                    // 個人検査結果テーブル挿入用のSQLステートメント作成
                    sql2 = @"
                            insert
                            into perresult(perid, itemcd, suffix, upddate, result, ispdate)
                            values (
                              :perid
                              , :itemcd
                              , :suffix
                              , sysdate
                              , :result
                              , :ispdate
                            )
                         ";

                    ret2 = connection.Execute(sql2, paramArray);

                    if (ret2 >= 0)
                    {
                        ret = Insert.Normal;
                        transaction.Commit();
                    }
                    else
                    {
                        // 異常終了ならRollBack
                        transaction.Rollback();
                    }
                }
            }
            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 個人検査結果テーブルを削除する
        /// </summary>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeletePerResult(string perId, string []itemCd, string []suffix)
        {
            string sql; // SQLステートメント

            List<Dictionary<string, object>> paramList = new List<Dictionary<string, object>>();

            for (var i=0; i< itemCd.Length;i++) {
                // キー及び更新値の設定
                var param = new Dictionary<string, object>();
                param.Add("perid", perId);
                param.Add("itemcd", itemCd[i]);
                param.Add("suffix", suffix[i]);
                paramList.Add(param);
            }


            // 個人検査結果テーブル削除
            sql = @"
                    delete perresult 
                    where
                      perid = :perid 
                      and itemcd = :itemcd 
                      and suffix = :suffix
                ";

            connection.Execute(sql, paramList);

            return true;
        }
    }
}
