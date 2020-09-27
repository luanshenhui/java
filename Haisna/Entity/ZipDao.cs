using Dapper;
using Hainsi.Common;
using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 住所情報データアクセスオブジェクト
    /// </summary>
    public class ZipDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public ZipDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 住所マスタ検索用条件節作成
        /// </summary>
        /// <param name="prefCd">都道府県コード</param>
        /// <param name="keys">検索キーの集合</param>
        /// <returns>住所マスタ検索用の条件節</returns>
        public string CreateConditionForZipList(string prefCd, List<string> keys = null)
        {
            string sql = "";        // SQLステートメント

            string zipCd1 = "";      // 郵便番号1
            string zipCd2 = "";      // 郵便番号2
            bool zip = false;        // 検索キーが郵便番号が存在すればTrue
            string condition = "";   // 検索キー
            string ret = "";

            if (keys == null)
            {
                return ret;
            }


            // 検索キー数分の条件節を追加
            for (int i = 0; i < keys.Count; i++)
            {
                while (true)
                {
                    // 検索キー中の半角カナを全角カナに変換する
                    keys[i] = WebHains.StrConvKanaWide(keys[i]);

                    // 検索キーが半角文字のみかチェック
                    if (Util.IsHalfword(keys[i]))
                    {
                        // 郵便番号として認識できるかをチェックし、上3桁と下4桁に分割
                        if (!isZipCd(keys[i], ref zipCd1, ref zipCd2))
                        {
                            return ret;
                        }

                        // 分割後の郵便番号で条件節を作成
                        sql += (string.IsNullOrEmpty(sql) ? " where " : " and ") + " (";
                        sql += " zipcd1 = '" + zipCd1 + "' " + (!string.IsNullOrEmpty(zipCd2) ? " and zipcd2 = '" + zipCd2 + "'" : "");
                        sql += ") ";

                        // 郵便番号存在フラグを立てる
                        zip = true;
                        break;
                    }

                    // 検索キー値が全角文字を含む場合、市区町村・字で部分検索を行う

                    // アプストロフィはOracleの単一引用符と重複するので予め置換
                    condition = keys[i].Replace("'", "''");

                    // 条件節を作成
                    sql += (string.IsNullOrEmpty(sql) ? " where" : " and ") + " (";
                    sql += " cityname like '%" + condition + "%' or section like '%" + condition + "%'";
                    sql += ") ";

                    break;
                }

            }

            // 郵便番号が存在しない場合は都道府県コードを条件節に含める
            if (zip == false && !string.IsNullOrEmpty(prefCd))
            {
                sql += (string.IsNullOrEmpty(sql) ? " where" : " and") + " ";
                sql += "prefcd = '" + prefCd.Trim().Replace("'", "''") + "'";
            }

            return sql;
        }

        /// <summary>
        /// 郵便番号から都道府県コードを取得する
        /// </summary>
        /// <param name="zipCd1">郵便番号１</param>
        /// <returns>都道府県コード</returns>
        public string GetPrefCdFromZip(string zipCd1)
        {
            string sql = "";        // SQLステートメント
            string ret = "";        // 戻り値

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("zipcd1", zipCd1);

            // 端末管理テーブルよりレコードを取得
            sql = @"
                    select
                      prefcd
                    from
                      zip
                    where
                      zipcd1 = :zipcd1
                      and rownum = 1
            ";
            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // レコードが存在する場合
            if (current != null)
            {
                ret = Convert.ToString(current.PREFCD);
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 条件式が郵便番号として認識できるかをチェックし、必要時は上3桁と下4桁に分割
        /// </summary>
        /// <param name="expression">条件式</param>
        /// <param name="zipCd1">郵便番号1</param>
        /// <param name="zipCd2">郵便番号2</param>
        /// <returns>true:認識可能;false:認識終了</returns>
        public bool isZipCd(string expression, ref string zipCd1, ref string zipCd2)
        {
            bool ret = false;       // 戻り値

            // 初期処理
            expression = expression.Trim();
            zipCd1 = "";
            zipCd2 = "";

            while (true)
            {
                // 半角文字列でなければ認識不能
                if (!Util.IsHalfword(expression))
                {
                    return ret;
                }

                // 文字列長をチェック
                switch (expression.Length)
                {
                    case 3:
                        // 3桁の場合
                        for (int i = 0; i < 3; i++)
                        {
                            if (!Information.IsNumeric(expression.Substring(i, 1)))
                            {
                                return false;
                            }
                        }

                        // 郵便番号1のみを編集して処理終了
                        zipCd1 = expression;

                        return true;

                    case 7:
                        // 7桁の場合

                        // 7桁とも数字でなければ認識不能
                        for (int i = 0; i < 7; i++)
                        {
                            if (!Information.IsNumeric(expression.Substring(i, 1)))
                            {
                                return false;
                            }
                        }

                        // 郵便番号1,2を分割編集して処理終了
                        zipCd1 = expression.Substring(0, 3);
                        zipCd2 = expression.Substring(3, 4);

                        return true;

                    case 8:
                        // 8桁の場合

                        // 4桁目がハイフンでそれ以外が数字、でなければ認識不能
                        for (int i = 0; i < 8; i++)
                        {
                            if (i == 3)
                            {
                                if (!expression.Substring(i, 1).Equals("-"))
                                {
                                    return false;
                                }
                            }
                            else
                            {
                                if (!Information.IsNumeric(expression.Substring(i, 1)))
                                {
                                    return false;
                                }
                            }
                        }

                        // 郵便番号1,2を分割編集して処理終了
                        zipCd1 = expression.Substring(0, 3);
                        zipCd2 = expression.Substring(4, 4);

                        return true;

                    default:
                        // それ以外は桁数不一致として認識不能
                        break;
                }

                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 検索条件を満たす住所の一覧を取得する
        /// </summary>
        /// <param name="prefCd">都道府県コード</param>
        /// <param name="keys">検索キーの集合</param>
        /// <param name="startPos">開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <returns>
        /// zipcd1 郵便番号1
        /// zipcd2 郵便番号2
        /// prefcd 都道府県コード
        /// prefname 都道府県名
        /// cityname 市区町村名
        /// section 字
        /// citykname 市区町村カナ名
        /// sectionkname カナ字
        /// </returns>
        public List<dynamic> SelectZipList(string prefCd, List<string> keys, long startPos, long getCount)
        {
            string sql = "";        // SQLステートメント

            string condition;       // 条件節

            // 検索条件より条件節を作成する
            condition = CreateConditionForZipList(prefCd, keys);

            // 検索条件を満たす住所マスタのレコードを取得
            sql = @"
                    select
                      zipwork.zipcd1
                      , zipwork.zipcd2
                      , zipwork.prefcd
                      , pref.prefname
                      , zipwork.cityname
                      , zipwork.section
                      , zipwork.citykname
                      , zipwork.sectionkname
                ";

            // SEQNo順に取得した表に対し行番号を付加するための副問い合わせ
            sql += @"
                    from
                      pref
                      , (
                            select
                              rownum recno
                              , zipcd1
                              , zipcd2
                              , prefcd
                              , cityname
                              , section
                              , citykname
                              , sectionkname
                            from
                              (
                                select
                                  zipcd1
                                  , zipcd2
                                  , prefcd
                                  , cityname
                                  , section
                                  , citykname
                                  , sectionkname
                                from
                                  zip
                ";

            sql += CreateConditionForZipList(prefCd, keys);

            // SEQNo順に取得
            sql += @"
                                order by
                                  prefcd
                                  , seq
                              )
                        ) zipwork
                ";

            // 開始位置から表示件数分のみ取得
            sql += @"
                    where
                      zipwork.recno between " + startPos.ToString() +
                   @"                   and " + (startPos + getCount - 1).ToString() +
                   @"   and zipwork.prefcd = pref.prefcd
                ";

            // 戻り値の設定
            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// 検索条件を満たす住所の件数を取得する
        /// </summary>
        /// <param name="prefCd">都道府県コード</param>
        /// <param name="keys">検索キーの集合</param>
        /// <returns>検索条件を満たすレコード件数</returns>
        public long SelectZipListCount(string prefCd, List<string> keys)
        {
            string sql = "";        // SQLステートメント

            long ret = 0;           // 戻り値

            // 検索条件を満たす住所マスタのレコードを取得
            sql = @"
                    select
                      count(*) count
                    from
                      zip " + CreateConditionForZipList(prefCd, keys)
                ;

            dynamic current = connection.Query(sql).FirstOrDefault();

            // 存在した場合
            if (current != null)
            {
                ret = Convert.ToInt64(current.COUNT);
            }

            // 戻り値の設定
            return ret;
        }

        #region 新設メソッド
        /// <summary>
        /// 郵便番号一覧を取得する
        /// </summary>
        /// <param name="qp">クエリパラメータ</param>
        /// <returns>郵便番号一覧</returns>
        public PartialDataSet SelectZipList(NameValueCollection qp)
        {
            string prefCd = Convert.ToString(qp["prefcd"]) ?? "";
            string keyword = Convert.ToString(qp["keyword"]) ?? "";

            // ページ番号（初期値1）
            if (! long.TryParse(qp["page"], out long page)){
                page = 1;
            }
            page = (page < 1) ? 1 : page;

            // 1ページ表示行数（初期値20）
            if(! long.TryParse(qp["limit"], out long limit)){
                limit = 20;
            }

            // テーブルの読込開始位置
            long startPos = limit * (page - 1) + 1;

            // 半角空白、全角空白でセパレートして空文字要素を消去する
            List<string> keys = Util.SplitBySpase(keyword).ToList();

            // 全行数取得
            long totalCount = SelectZipListCount(prefCd, keys);

            // 表示データ取得
            var data = SelectZipList(prefCd, keys, startPos, limit);

            return new PartialDataSet(totalCount, data);

        }

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <param name="qp">検索値</param>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public IList<string> Validate(NameValueCollection qp)
        {
            string prefCd = Convert.ToString(qp["prefcd"]) ?? "";
            string keyword = Convert.ToString(qp["keyword"]) ?? "";

            // 半角空白、全角空白でセパレートして空文字要素を消去する
            List<string> keys = Util.SplitBySpase(keyword).ToList();

            // エラーメッセージ
            // （エラーメッセージは1つしか返さないがほかのバリデーションと型を合わせるためリストにする）
            var messages = new List<string>();

            string zipCd1Dummy = string.Empty;
            string zipCd2Dummy = string.Empty;
            bool isWideOnly = true;
            foreach (var key in keys)
            {
                // 全角文字を含む文字列の場合はチェックしない
                if (! Util.IsHalfword(key))
                {
                    continue;
                }

                isWideOnly = false;

                // 郵便番号形式チェック
                if(!isZipCd(key, ref zipCd1Dummy, ref zipCd2Dummy))
                {
                    messages.Add("郵便番号の指定形式に誤りがあります。");
                    return messages;
                }
            }

            // 検索文字列が全て全角文字を含む場合は都道府県コード必須
            if(isWideOnly && prefCd == "")
            {
                messages.Add("都道府県は必ず指定して下さい。");
                return messages;
            }

            return messages;
        }
        #endregion
    }
}