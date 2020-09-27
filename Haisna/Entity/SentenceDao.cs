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
    /// 文章情報データアクセスオブジェクト
    /// </summary>
    public class SentenceDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public SentenceDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 文章分類テーブルレコードを削除する
        /// </summary>
        /// <param name="stcClassCd">文章分類コード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteStcClass(string stcClassCd)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("stcclasscd", stcClassCd.Trim());

            // 文章分類テーブルレコードの削除
            sql = @"
                    delete stcclass
                    where
                      stcclasscd = :stcclasscd
                ";

            connection.Execute(sql, param);

            // 戻り値の設定
            return true;

        }

        /// <summary>
        /// 文章分類テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">グループ情報
        /// stcClassCd 文章分類コード
        /// stcClassCame 文章分類名
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistStcClass(string mode, JToken data)
        {
            string sql; // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("stcclasscd", Convert.ToString(data["stcClassCd"]));
            param.Add("stcclassname", Convert.ToString(data["stcClassCame"]));

            while (true)
            {
                // 文章分類テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update stcclass
                            set
                              stcclassname = :stcclassname
                            where
                              stcclasscd = :stcclasscd
                        ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす文章分類テーブルのレコードを取得
                sql = @"
                        select
                          stcclassname
                        from
                          stcclass
                        where
                          stcclasscd = :stcclasscd
                    ";

                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 存在した場合、新規挿入不可
                if (current != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 新規挿入
                sql = @"
                        insert
                        into stcclass(stcclasscd, stcclassname)
                        values (:stcclasscd, :stcclassname)
                    ";

                connection.Execute(sql, param);

                ret = Insert.Normal;
                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 文章分類コードに対する文章分類名を取得する
        /// </summary>
        /// <param name="stcClassCd">文章分類コード</param>
        /// <returns>
        /// stcClassName 文章分類名
        /// </returns>
        public dynamic SelectStcClass(string stcClassCd)
        {
            string sql; // SQLステートメント
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("stcclasscd", stcClassCd.Trim());

            // SQL定義
            sql = @"
                    select
                      stcclassname
                    from
                      stcclass
                    where
                      stcclasscd = :stcclasscd
                ";
            //SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 文章分類の一覧を取得する
        /// </summary>
        /// <returns>
        /// stcClassCd 文章分類コード
        /// stcClassName 文章分類名
        /// </returns>
        public List<dynamic> SelectStcClassItemList()
        {
            string sql; // SQLステートメント

            // 文章分類テーブルの全レコードを取得
            sql = @"
                    select
                      stcclasscd
                      , stcclassname
                    from
                      stcclass
                    order by
                      stcclasscd
                ";

            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 最近使った文章の一覧を取得する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="itemType">項目タイプ</param>
        /// <returns>
        /// stcCd 文章コード
        /// shortStc 略文章
        /// </returns>
        public List<dynamic> SelectRecentSentenceList(string itemCd, string itemType)
        {
            string sql; // SQLステートメント

            // 対象検査グループコードが設定されていない場合はエラー
            if (String.IsNullOrEmpty(itemCd))
            {
                throw new ArgumentException();
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("itemcd", itemCd.Trim());
            param.Add("itemtype", itemType.Trim());

            // 文章テーブルよりレコードを取得
            sql = @"
                    select distinct
                      rs.stccd
                      , st.shortstc
                      , rs.alwaysuse
                    from
                      recent_sentence rs
                      , sentence st
                    where
                      rs.itemcd = :itemcd
                      and rs.itemtype = :itemtype
                      and rs.itemcd = st.itemcd
                      and rs.itemtype = st.itemtype
                      and rs.stccd = st.stccd
                    order by
                      rs.alwaysuse desc
                      , rs.stccd
                ";
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 文章を取得する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="itemType">項目タイプ</param>
        /// <param name="stcCd">文章コード</param>
        /// <param name="searchMode">0:引数の検査項目コードで取得、1:文章参照コードで取得</param>
        /// <param name="suffix">サフィックス</param>
        /// <returns>文章情報</returns>
        public dynamic SelectSentence(
            string itemCd,
            ItemType itemType,
            string stcCd,
            int searchMode = 0,
            string suffix = null
        )
        {
            itemCd = itemCd.Trim();
            stcCd = stcCd.Trim();
            suffix = suffix?.Trim();

            // 検索条件が設定されていない場合はエラー
            if (String.IsNullOrEmpty(itemCd))
            {
                throw new ArgumentException();
            }

            string sql; // SQLステートメント
            var param = new Dictionary<string, object>();
            param.Add("itemcd", itemCd);
            param.Add("itemtype", itemType);
            param.Add("stccd", stcCd);

            // 文章テーブルよりレコードを取得
            sql = @"
                select
                    sentence.itemcd
                    , sentence.itemtype
                    , sentence.stccd
                    , sentence.shortstc
                    , sentence.longstc
                    , sentence.engstc
                    , sentence.vieworder
                    , sentence.printorder
                    , sentence.stcclasscd
                    , sentence.imagefilename
                    , sentence.questionrank
                    , sentence.delflg
                    , sentence.insstc
                    , sentence.reptstc
            ";

            // 引数の検査項目で検索
            if (searchMode == 0)
            {
                sql += @"
                    from
                        sentence
                    where
                        itemcd = :itemcd
                        and itemtype = :itemtype
                        and stccd = :stccd
                ";
            }
            else
            {
                if (String.IsNullOrEmpty(suffix))
                {
                    throw new ArgumentException();
                }

                sql += @"
                    from
                        sentence
                        , item_c
                    where
                        item_c.itemcd = :itemcd
                        and item_c.suffix = :suffix
                        and sentence.itemcd = item_c.stcitemcd
                        and sentence.itemtype = :itemtype
                        and sentence.stccd = :stccd
                ";

                param.Add("suffix", suffix);
            }

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 文章テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">文章テーブル情報
        /// itemCd 検査項目コード
        /// itemType 検査項目タイプ
        /// stcCd 文章コード
        /// shortStc 略文章
        /// longStc 文章
        /// engStc 英語文章
        /// stcClassCd 文章分類コード
        /// insStc 検査連携用変換文章
        /// viewOrder 表示順番
        /// printOrder 成績書出力順番
        /// imageFileName イメージファイル名
        /// questionRank 問診表示ランク
        /// delFlg 未使用フラグ
        /// reptStc 報告書用文章
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistSentence(string mode, JToken data)
        {
            string sql; // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("itemcd", Convert.ToString(data["itemCd"]));
            param.Add("itemtype", Convert.ToString(data["itemType"]));
            param.Add("stccd", Convert.ToString(data["stcCd"]));
            param.Add("shortstc", Convert.ToString(data["shortStc"]));
            param.Add("longstc", Convert.ToString(data["longStc"]));
            param.Add("engstc", Convert.ToString(data["engStc"]));
            param.Add("stcclasscd", Convert.ToString(data["stcClassCd"]));
            param.Add("insstc", Convert.ToString(data["insStc"]));
            param.Add("vieworder", Convert.ToString(data["viewOrder"]));
            param.Add("printorder", Convert.ToString(data["printOrder"]));
            param.Add("imagefilename", Convert.ToString(data["imageFileName"]));
            param.Add("questionrank", Convert.ToString(data["questionRank"]));
            param.Add("delflg", Convert.ToString(data["delFlg"]));
            param.Add("reptstc", Convert.ToString(data["reptStc"]));

            while (true)
            {
                // 文章分類テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update sentence
                            set
                              shortstc = :shortstc
                              , longstc = :longstc
                              , engstc = :engstc
                              , stcclasscd = :stcclasscd
                              , insstc = :insstc
                              , vieworder = :vieworder
                              , printorder = :printorder
                              , imagefilename = :imagefilename
                              , questionrank = :questionrank
                              , delflg = :delflg
                              , reptstc = :reptstc
                            where
                              itemcd = :itemcd
                              and itemtype = :itemtype
                              and stccd = :stccd
                        ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす文章分類テーブルのレコードを取得
                sql = @"
                        select
                          itemcd
                        from
                          sentence
                        where
                          itemcd = :itemcd
                          and itemtype = :itemtype
                          and stccd = :stccd
                    ";

                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 存在した場合、新規挿入不可
                if (current != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 新規挿入
                sql = @"
                        insert
                        into sentence(
                          itemcd
                          , itemtype
                          , stccd
                          , shortstc
                          , longstc
                          , engstc
                          , stcclasscd
                          , insstc
                          , vieworder
                          , printorder
                          , imagefilename
                          , questionrank
                          , delflg
                          , reptstc
                        )
                        values (
                          :itemcd
                          , :itemtype
                          , :stccd
                          , :shortstc
                          , :longstc
                          , :engstc
                          , :stcclasscd
                          , :insstc
                          , :vieworder
                          , :printorder
                          , :imagefilename
                          , :questionrank
                          , :delflg
                          , :reptstc
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
        /// 文章テーブルレコードを削除する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="itemType">検査項目タイプ</param>
        /// <param name="stcCd">文章コード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteSentence(string itemCd, int itemType, string stcCd)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("itemcd", itemCd.Trim());
            param.Add("itemtype", Convert.ToString(itemType).Trim());
            param.Add("stccd", stcCd.Trim());

            // 文章分類テーブルレコードの削除
            sql = @"
                    delete sentence
                    where
                      itemcd = :itemcd
                      and itemtype = :itemtype
                      and stccd = :stccd
            ";
            connection.Execute(sql, param);

            // 戻り値の設定
            return true;

        }

        /// <summary>
        /// 文章の一覧を取得する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="itemType">項目タイプ</param>
        /// <param name="searchCode">検索用コード</param>
        /// <param name="searchString">検索用文字列</param>
        /// <param name="stcClassCd">文章分類コード</param>
        /// <param name="selectMode">選択モード(0:全て、1:表示順番）</param>
        /// <returns>文章情報のリスト</returns>
        public IList<dynamic> SelectSentenceList(
            string itemCd,
            ItemType itemType,
            string searchCode = null,
            string searchString = null,
            string stcClassCd = null,
            int selectMode = 1
        )
        {
            itemCd = itemCd?.Trim();
            searchCode = searchCode?.Trim();
            stcClassCd = stcClassCd?.Trim();

            // 検査項目コードを指定されている場合フラグ成立
            Boolean itemSelect = !String.IsNullOrEmpty(itemCd);

            var param = new Dictionary<string, object>();

            // 文章テーブルよりレコードを取得
            string sql = @"
                select
                    sentence.itemcd
                    , item_p.requestname
                    , sentence.itemtype
                    , sentence.stccd
                    , sentence.shortstc
                    , sentence.longstc
                    , sentence.insstc
                from
                    item_p
                    , sentence
                where
                    item_p.itemcd = sentence.itemcd
            ";

            if (selectMode == 1)
            {
                sql += @"
                    and sentence.delflg is null
                ";
            }

            // 条件指定されているときはWHERE句追加
            if (itemSelect)
            {
                sql += @"
                    and sentence.itemcd = :itemcd
                    and sentence.itemtype = :itemtype
                ";

                param.Add("itemcd", itemCd);
                param.Add("itemtype", Convert.ToInt16(itemType));
            }

            // 検索用文字列の設定（マスタメンテ用？）
            if (!String.IsNullOrEmpty(searchCode))
            {
                sql += @"
                    and (sentence.itemcd like :searchcode
                        or sentence.stccd like :searchcode)
                ";

                param.Add("searchcode", $"%{searchCode}%");
            }

            if (!String.IsNullOrEmpty(searchString))
            {
                sql += @"
                    and sentence.longstc like :searchstring
                ";

                param.Add("searchstring", $"%{searchString}%");
            }

            // 文章分類コード指定時の条件節
            if (!String.IsNullOrEmpty(stcClassCd))
            {
                sql += @"
                    and sentence.stcclasscd = :stcclasscd
                ";

                param.Add("stcclasscd", stcClassCd);
            }

            sql += @"
                order by
                    sentence.itemcd
                    , sentence.itemtype
            ";

            if (selectMode == 1)
            {
                sql += @"
                    , sentence.vieworder nulls last
                    , sentence.stccd
                ";
            }

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 文章分類の一覧を取得する
        /// </summary>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="itemType">項目タイプ</param>
        /// <returns>文章分類情報のリスト</returns>
        public IList<dynamic> SelectStcClassList(string itemCd, ItemType itemType)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("itemcd", itemCd.Trim());
            param.Add("itemtype", itemType);

            // 文章テーブルよりレコードを取得
            string sql = @"
                select
                    subsentence.stcclasscd
                    , stcclass.stcclassname
                from
                    stcclass
                    , (
                        select distinct
                            stcclasscd
                        from
                            sentence
                        where
                            itemcd = :itemcd
                            and itemtype = :itemtype
                    ) subsentence
                where
                    subsentence.stcclasscd = stcclass.stcclasscd
            ";

            return connection.Query(sql, param).ToList();
        }
    }
}
