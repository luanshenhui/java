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
    /// 進捗分類情報データアクセスオブジェクト
    /// </summary>
    public class ProgressDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public ProgressDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 進捗分類テーブルレコードを削除する
        /// </summary>
        /// <param name="progressCd">進捗分類コード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteProgress(string progressCd)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("progresscd", progressCd.Trim());

            // 進捗分類テーブルレコードの削除
            sql = @"
                    delete progress
                    where
                      progresscd = :progresscd
                ";
            connection.Execute(sql, param);

            // 戻り値の設定
            return true;

        }

        /// <summary>
        /// 進捗管理用分類テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">進捗管理用分類テーブル情報
        /// progressCd 進捗管理用分類コード
        /// progressName 進捗管理用分類名
        /// progressSName 進捗管理用分類略称
        /// seq 表示順番
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistProgress(string mode, JToken data)
        {
            string sql; // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("progresscd", Convert.ToString(data["progressCd"]));
            param.Add("progressname", Convert.ToString(data["progressName"]));
            param.Add("progresssname", Convert.ToString(data["progressSName"]));
            param.Add("seq", Convert.ToString(data["seq"]));

            while (true)
            {
                // 進捗管理用分類テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update pref
                            set
                              prefname = :prefname
                            where
                              prefcd = :prefcd
                        ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす進捗管理用分類テーブルのレコードを取得
                sql = @"
                        select
                          progresscd
                        from
                          progress
                        where
                          progresscd = :progresscd
                    ";

                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 存在した場合、新規挿入不可
                if (current != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                sql = @"
                        insert
                        into progress
                        (
                          progresscd
                          , progressname
                          , progresssname
                          , seq)
                        values
                        (
                          :progresscd
                          , :progressname
                          , :progresssname
                          , :seq
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
        /// 進捗分類の一覧を取得する
        /// </summary>
        /// <returns>
        /// progressCd　進捗分類コード
        /// progressName　進捗分類名称（省略可）
        /// progressSName 進捗分類略称（省略可）
        /// seq 表示順番（省略可）
        /// </returns>
        public List<dynamic> SelectProgressList()
        {
            string sql; // SQLステートメント

            // 検索条件を満たす進捗分類テーブルのレコードを取得
            sql = @"
                    select
                      pg.progresscd
                      , pg.progressname
                      , pg.progresssname
                      , pg.seq
                    from
                      progress pg
                    order by
                      pg.seq
                ";

            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 進捗分類コードに対する進捗分類名を取得する
        /// </summary>
        /// <param name="progressCd">進捗分類コード</param>
        /// <returns>
        /// progressName　進捗分類名称（省略可）
        /// progressSName 進捗分類略称（省略可）
        /// seq 表示順番（省略可）
        /// </returns>
        public dynamic SelectProgress(string progressCd)
        {
            string sql; // SQLステートメント

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("progresscd", progressCd);

            // 検索条件を満たす進捗分類テーブルのレコードを取得
            sql = @"
                    select
                      progressname
                      , progresssname
                      , seq
                    from
                      progress
                    where
                      progresscd = :progresscd
                ";
            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 指定予約番号の検査結果に対し、進捗分類ごとの入力状態を取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// progressCd　進捗分類コード
        /// status 入力状態("2":入力完了、"1":未入力、"0":依頼なし、"3":未入力だが端末は通過)
        /// </returns>
        public IList<dynamic> SelectProgressRsl(int rsvNo)
        {
            string sql; // SQLステートメント

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 検索条件を満たす進捗分類テーブルのレコードを取得
            sql = @"
                    select
                      progresscd
                      , case
                        when inputcount = 0
                          then 1
                        when entry = 0
                          then 1
                        when notentry = 1
                          then 3
                        else 2
                        end status
                    from
                      checkentry
                    where
                      rsvno = :rsvno
                ";

            return connection.Query(sql, param).ToList();
        }
    }


}
