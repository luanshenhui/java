using Dapper;
using Hainsi.Common.Constants;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text.RegularExpressions;

namespace Hainsi.Entity
{
    /// <summary>
    /// 2次請求明細情報データアクセスオブジェクト
    /// </summary>
    public class SecondBillDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public SecondBillDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 半角数字チェック
        /// </summary>
        /// <param name="itemName">項目名</param>
        /// <param name="expression">文字列式</param>
        /// <param name="length">桁数</param>
        /// <param name="necessary">必須かどうか</param>
        /// <returns>エラーメッセージ(エラーが無い場合は長さ0の文字列)</returns>
        public string CheckNumeric(string itemName, string expression, long length, Check necessary = Check.None)
        {
            string message = "";     // エラーメッセージ

            while (true)
            {
                // 未入力チェック
                if (string.IsNullOrEmpty(expression) || expression.Trim().Equals(""))
                {
                    // 必須の場合のみメッセージを返す
                    if (necessary == Check.Necessary)
                    {
                        message = itemName + "を入力して下さい。";
                    }
                    break;
                }

                // 桁数チェック
                if (expression.Trim().Length > length)
                {
                    message = itemName + "は" + length.ToString() + "文字以内の半角数字で入力して下さい。";
                    break;
                }

                // 半角数字チェック
                for (int i = 1; i < expression.Trim().Length; i++)
                {
                    // 半角数字以外の文字が現れたらチェックを中止する
                    if (!Regex.IsMatch(expression.Trim(), @"^-?[a-zA-Z0-9]+$"))
                    {
                        message = itemName + "は" + length.ToString() + "文字以内の半角数字で入力して下さい。";
                        break;
                    }
                }


                break;
            }

            return message;
        }

        /// <summary>
        /// ２次請求明細を取得する。
        /// </summary>
        /// <returns>
        /// secondlinedivcd ２次請求明細コード
        /// secondlinedivname ２次請求明細名
        /// stdprice 標準単価
        /// stdtax 標準税額
        /// </returns>
        public List<dynamic> SelectSecondLineDiv()
        {
            string sql = "";        // SQLステートメント

            // 検索条件を満たす個人入金情報テーブルのレコードを取得
            sql = @"
                    select
                      secondlinediv.secondlinedivcd
                      , secondlinediv.secondlinedivname
                      , secondlinediv.stdprice
                      , secondlinediv.stdtax
                    from
                      secondlinediv
                    order by
                      secondlinediv.secondlinedivcd
            ";

            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// ２次請求明細情報を取得する
        /// </summary>
        /// <param name="secondLineDivCd">２次請求明細コード</param>
        /// <returns>
        /// secondlinedivname ２次請求明細名称（省略可）
        /// stdprice 標準単価（省略可）
        /// stdtax 標準税額（省略可）
        /// </returns>
        public dynamic SelectSecondLineDivFromCode(string secondLineDivCd)
        {
            string sql = "";        // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("secondlinedivcd", secondLineDivCd.Trim());

            // 検索条件を満たす２次請求明細テーブルのレコードを取得
            sql = @"
                    select
                      secondlinedivcd
                      , secondlinedivname
                      , stdprice
                      , stdtax
                    from
                      secondlinediv
                    where
                      secondlinedivcd = :secondlinedivcd
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// ２次請求明細テーブルレコードを削除する
        /// </summary>
        /// <param name="secondLineDivCd">２次請求明細コード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeleteSecondLineDiv(string secondLineDivCd)
        {
            string sql = "";        // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("secondlinedivcd", secondLineDivCd.Trim());

            // 検索条件を満たす２次請求明細テーブルのレコードを取得
            sql = @"
                    delete secondlinediv
                    where
                      secondlinedivcd = :secondlinedivcd
            ";

            connection.Execute(sql, param);

            return true;
        }

        /// <summary>
        /// ２次請求明細テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// secondlinedivcd ２次請求明細コード
        /// secondlinedivname ２次請求明細名称
        /// stdprice 標準単価
        /// stdtax 標準税額
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistSecondLineDiv(string mode, JToken data)
        {
            string sql = "";                                // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("secondlinedivcd", Convert.ToString(data["secondlinedivcd"]).Trim());
            param.Add("secondlinedivname", Convert.ToString(data["secondlinedivname"]).Trim());
            param.Add("stdprice", Convert.ToString(data["stdprice"]).Trim());
            param.Add("stdtax", Convert.ToString(data["stdtax"]).Trim());

            while (true)
            {
                // ２次請求明細テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update secondlinediv
                            set
                              secondlinedivname = :secondlinedivname
                              , stdprice 　 = :stdprice
                              , stdtax = :stdtax
                            where
                              secondlinedivcd = :secondlinedivcd
                    ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす２次請求明細テーブルのレコードを取得
                sql = @"
                        select
                          secondlinedivcd
                        from
                          secondlinediv
                        where
                          secondlinedivcd = :secondlinedivcd
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
                        into secondlinediv(
                          secondlinedivcd
                          , secondlinedivname
                          , stdprice
                          , stdtax
                        )
                        values (
                          :secondlinedivcd
                          , :secondlinedivname
                          , :stdprice
                          , :stdtax
                        )
                ";

                connection.Execute(sql, param);

                ret = Insert.Normal;
                break;
            }

            // 戻り値の設定
            return ret;
        }
    }
}