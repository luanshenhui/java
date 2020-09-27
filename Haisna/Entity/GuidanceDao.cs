using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 指導内容情報データアクセスオブジェクト
    /// </summary>
    public class GuidanceDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public GuidanceDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 指導内容の一覧を取得する
        /// </summary>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="key">検索キーの集合（省略可）</param>
        /// <param name="startPos">開始位置（省略可）</param>
        /// <param name="getCount">取得件数（省略可）</param>
        /// <returns>
        /// guidanceCd     指導内容コード
        /// guidanceStc    指導内容
        /// judClassCd     判定分類コード（省略可）
        /// judClassName   判定分類名（省略可）
        /// key            検索キーの集合（省略可）
        /// </returns>
        public List<dynamic> SelectGuidanceList(string judClassCd, string[] key = null, string startPos = null, string getCount = null)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            if (Util.IsNumber(judClassCd))
            {
                param.Add("judclasscd", int.Parse(judClassCd));
            }

            if (Util.IsNumber(getCount))
            {
                param.Add("seq_from", long.Parse(startPos));
                param.Add("seq_to", long.Parse(startPos) + long.Parse(getCount) - 1);
            }

            // 指導内容テーブルよりレコードを取得
            string sql = @"
                           select
                             seq
                             , judclasscd
                             , guidancecd
                             , guidancestc
                             , judclassname
                           from
                             (
                               select
                                 rownum seq
                                 , guidance.judclasscd
                                 , guidance.guidancecd
                                 , guidance.guidancestc
                                 , judclass.judclassname
                               from
                                 judclass
                                 , guidance
                    ";

            // 判定分類の指定がある場合は、条件文追加
            if (Util.IsNumber(judClassCd))
            {
                sql += @"
                        where
                          (
                            guidance.judclasscd = :judclasscd
                            or guidance.judclasscd is null
                          )
                          and guidance.judclasscd = judclass.judclasscd(+)
                        where
                          guidance.judclasscd = judclass.judclasscd(+)
                     ";
            }

            // 名称指定がある場合は、条件文追加
            if (key != null)
            {
                sql += "              and " + CreateConditionForGuidanceList(key);
            }

            sql += " order by guidance.guidancecd )";

            // ページングナビゲータ用の指定がある場合
            if (Util.IsNumber(getCount))
            {
                sql += " where seq between :seq_from and :seq_to ";
            }

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 検索条件を満たす指導文章の件数を取得する
        /// </summary>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="key">検索キーの集合</param>
        /// <returns>検索条件を満たすレコード件数</returns>
        public int SelectGuidanceListCount(string judClassCd, string[] key)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            if (!judClassCd.Equals(""))
            {
                param.Add("judclasscd", judClassCd);
            }

            // 指導内容テーブルよりレコードを取得
            string sql = @"
                           select
                             count(guidancecd) cnt
                           from
                             guidance
                     ";

            // 判定分類の指定がある場合は、条件文追加
            if (Util.IsNumber(judClassCd))
            {
                sql += " where (guidance.judclasscd = :judclasscd or guidance.judclasscd is null)";
            }

            // 名称指定がある場合は、条件文追加
            if (key != null)
            {
                // 判定分類の指定がない場合は、条件文追加
                if (!Util.IsNumber(judClassCd))
                {
                    sql += " where ";
                }
                else
                {
                    sql += " and ";
                }

                sql += "                   " + CreateConditionForGuidanceList(key);
            }

            return connection.Query(sql, param).FirstOrDefault()["cnt"];
        }

        /// <summary>
        /// 指導文章テーブル検索用条件節作成
        /// </summary>
        /// <param name="key">検索キーの集合</param>
        /// <returns>指導文章テーブル検索用の条件節</returns>
        private string CreateConditionForGuidanceList(string[] key)
        {
            string sql = "";  // SQLステートメント

            // 引数未設定時は何もしない
            if (key == null)
            {
                return sql;
            }

            // 検索キー数分の条件節を追加
            for (int i = 0; i <= key.Length; i++)
            {
                // 2番目以降の条件節はANDで連結
                if (i >= 1)
                {
                    sql += " and";
                }

                // 検索キー中の半角カナを全角カナに変換する
                key[i] = WebHains.StrConvKanaWide(key[i]);

                // 検索キーが半角文字のみかチェック
                if (Util.ConvertToBytes(key[i]).Length <= 8)
                {
                    sql += " ( guidance.guidancestc like '%" + key[i] + "%'";
                    sql += " or guidance.guidancecd  like '" + key[i] + "%' )";
                }
                else
                {
                    sql += "guidance.guidancestc like '%" + key[i] + "%'";
                }
            }

            return sql;
        }

        /// <summary>
        /// 指導内容名称を取得する
        /// </summary>
        /// <param name="guidanceCd">指導内容コード</param>
        /// <returns>
        /// guidanceStc      指導内容名称（省略可）
        /// judClassCd       判定分類コード
        /// judClassName     判定分類コード
        /// </returns>
        public dynamic SelectGuidance(string guidanceCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("guidancecd", guidanceCd);

            // 検索条件を満たす指導内容テーブルのレコードを取得
            string sql = @"
                           select
                             guidance.guidancestc
                             , guidance.judclasscd
                             , judclass.judclassname
                           from
                             judclass
                             , guidance
                           where
                             guidance.guidancecd = :guidancecd
                             and guidance.judclasscd = judclass.judclasscd(+)
                       ";

            return connection.Query(sql).FirstOrDefault();
        }

        /// <summary>
        /// 指導内容テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// guidancecd      指導内容コード
        /// guidancestc     指導内容名
        /// judclasscd      判定分類コード
        /// </param>
        /// <returns>
        /// Insert.Normal     正常終了
        /// Insert.Duplicate  同一キーのレコード存在
        /// Insert.Error      異常終了
        /// </returns>
        public Insert RegistGuidance(string mode, JToken data)
        {
            string sql;  // SQLステートメント
            Insert ret = Insert.Error;  // 関数戻り値
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("guidancecd", Convert.ToString(data["guidancecd"]));
            param.Add("guidancestc", Convert.ToString(data["guidancestc"]));
            param.Add("judclasscd", Convert.ToDateTime(data["judclasscd"]));

            while (true)
            {
                // 指導内容テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update guidance
                            set
                              guidancestc = :guidancestc
                              , judclasscd = :judclasscd
                            where
                              guidancecd = :guidancecd
                        ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす指導内容テーブルのレコードを取得
                sql = @"
                        select
                          guidancecd
                        from
                          guidance
                        where
                          guidancecd = :guidancecd
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
                        into guidance(guidancecd, guidancestc, judclasscd)
                        values (:guidancecd, :guidancestc, :judclasscd)
                    ";

                connection.Execute(sql, param);

                ret = Insert.Normal;
                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 指導内容テーブルレコードを削除する
        /// </summary>
        /// <param name="guidanceCd">指導内容コード</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool DeleteGuidance(string guidanceCd)
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("guidancecd", guidanceCd);

            // 指導内容テーブルレコードの削除
            string sql = "delete guidance where guidancecd = :guidancecd";
            connection.Execute(sql, param);

            // 戻り値の設定
            return true;
        }
    }
}