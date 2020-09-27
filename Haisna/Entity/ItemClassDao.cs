using Dapper;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 検査分類情報データアクセスオブジェクト
    /// </summary>
    public class ItemClassDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public ItemClassDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 入力値のチェックを行う
        /// </summary>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> Validate(JToken data)
        {
            var messages = new List<string>();

            // 検査分類コード
            if (string.IsNullOrEmpty(Convert.ToString(data["classcd"])))
            {
                messages.Add("検査分類コードが入力されていません。");
            }
            // 検査分類名
            if (string.IsNullOrEmpty(Convert.ToString(data["classname"])))
            {
                messages.Add("検査分類名が入力されていません。");
            }

            return messages;
        }

        /// <summary>
        /// 検査分類レコードを取得する
        /// </summary>
        /// <param name="qp">クエリーパラメータ</param>
        /// <returns>検査分類レコード</returns>
        public PartialDataSet SelectItemClassList(NameValueCollection qp)
        {
            string keyword = qp["keyword"];
            string page = qp["page"];
            string limit = qp["limit"];

            var sqlParam = new Dictionary<string, object>();

            // SQL定義
            string sql = @"
                    select
                        classcd
                      , classname
                    from
                        itemclass
                    where 1 = 1 ";

            // キーワードが指定されている場合、グループ名検索条件に含める
            if (!string.IsNullOrEmpty(keyword))
            {
                sql += " and classname like :keyword ";
                sqlParam.Add("keyword", "%" + keyword + "%");
            }

            sql += " order by classcd ";

            // SQL実行結果を返す
            return new PartialDataSet(Query(sql, page, limit, sqlParam));
        }

        /// <summary>
        /// 編集画面用初期表示
        /// </summary>
        /// <param name="classCd"></param>
        /// <returns></returns>
        /// <remarks>メソッド名は仮置き</remarks>
        public dynamic SelectItemClass(string classCd)
        {

            // SQL定義
            string sql = @"
                    select
                        classname
                    from
                        itemclass
                    where
                        classcd = :itemclasscd
                ";

            // パラメータセット
            var sqlParam = new
            {
                itemclasscd = classCd
            };

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();

        }


    }
}
