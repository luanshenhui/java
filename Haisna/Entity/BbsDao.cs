using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity.Model.Bbs;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text.RegularExpressions;

namespace Hainsi.Entity
{
    /// <summary>
    /// 掲示板情報データアクセスオブジェクト
    /// </summary>
    public class BbsDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public BbsDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// ＢＢＳテーブル入力チェック
        /// </summary>
        /// <param name="strDate">表示開始日付</param>
        /// <param name="endDate">表示終了日付</param>
        /// <param name="handle">投稿者</param>
        /// <param name="title">タイトル</param>
        /// <param name="message">メッセージ</param>
        /// <returns>エラー値がある場合、エラーメッセージの配列を返す</returns>
        public List<string> CheckValue(string strDate, string endDate,
                                        string handle, string title, string message)
        {
            var vntArrMessage = new List<string>();   // エラーメッセージの集合
            string strArrMessage = null;           //エラーメッセージ

            // 表示開始日付未入力チェック
            if (string.IsNullOrEmpty(strDate))
            {
                vntArrMessage.Add(string.Format("{0}を入力して下さい。", "表示開始日付"));
            }
            if (string.IsNullOrEmpty(endDate))
            {
                vntArrMessage.Add(string.Format("{0}を入力して下さい。", "表示終了日付"));
            }

            // 投稿者
            strArrMessage = WebHains.CheckWideValue("投稿者", handle.Trim(), Convert.ToInt32(LengthConstants.LENGTH_BBS_HANDLE), Check.Necessary);
            if (strArrMessage != null) {
                vntArrMessage.Add(strArrMessage);
            }


            // タイトル
            strArrMessage = WebHains.CheckWideValue("表題", title.Trim(), Convert.ToInt32(LengthConstants.LENGTH_BBS_TITLE), Check.Necessary);
            if (strArrMessage != null)
            {
                vntArrMessage.Add(strArrMessage);
            }

            // 改行文字も1字として含む旨を通達
            strArrMessage = WebHains.CheckWideValue("コメント", message.Replace("\r", "").Replace("\n", "").Trim(), Convert.ToInt32(LengthConstants.LENGTH_BBS_MESSAGE), Check.Necessary);
            if (strArrMessage != null)
            {
                vntArrMessage.Add(strArrMessage + "（改行文字も含みます）");
            }

            // 戻り値の編集
            return vntArrMessage;
        }

        /// <summary>
        /// 掲示板テーブルに書き込み
        /// </summary>
        /// <param name="data">掲示板データ</param>
        /// <returns>
        /// Insert.Normal  正常終了
        /// Insert.Error   異常終了
        /// </returns>
        public Insert InsertBbs(Bbs data)
        {
            string sql = "";            // SQLステートメント
            Insert ret = Insert.Error;  // 関数戻り値

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("strdate", data.StrDate.Trim());
            sqlParam.Add("enddate",data.EndDate.Trim());
            sqlParam.Add("handle", data.Handle.Trim());
            sqlParam.Add("title", data.Title.Trim());
            sqlParam.Add("message", data.Message.Trim());
            sqlParam.Add("upduser", data.UpdUser.Trim());

            // ＢＢＳテーブル追加処理
            sql = @"
                    insert
                    into bbs(
                        bbskey
                        , strdate
                        , enddate
                        , handle
                        , title
                        , message
                        , upddate
                        , upduser
                    )
                    values (
                        bbskey_seq.nextval
                        , :strdate
                        , :enddate
                        , :handle
                        , :title
                        , :message
                        , sysdate
                        , :upduser
                    )
                ";

            connection.Execute(sql, sqlParam);

            ret = Insert.Normal;
            return ret;
        }

        /// <summary>
        /// 掲示板テーブル削除
        /// </summary>
        /// <param name="bbsKey">キー</param>
        /// <returns>0  正常終了</returns>
        public int DeleteBbs(string bbsKey = "")
        {
            string sql = "";  // SQLステートメント

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("bbskey", bbsKey.Trim());

            // ＢＢＳテーブル削除
            sql = @"
                    delete bbs
                ";

            // キー指定時はキー値で削除し、さもなくば表示終了日付が過去日であるすべてのレコードを削除する
            if (!string.IsNullOrEmpty(bbsKey))
            {
                sql += @"
                        where
                        bbskey = :bbskey
                    ";
            }
            else
            {
                sql += @"
                        where
                            to_char(enddate, 'YYYYMMDD') < to_char(sysdate, 'YYYYMMDD')
                    ";
            }

            connection.Execute(sql, sqlParam);

            return 0;
        }

        /// <summary>
        /// 今日のコメント取得
        /// </summary>
        /// <param name="toDay">今日の日付</param>
        /// <returns>データセット</returns>
        public List<dynamic> SelectAllBbs(string toDay)
        {
            string sql = "";  // SQLステートメント

            // キー値の設定
            var sqlParam = new Dictionary<string, object>();
            sqlParam.Add("today", toDay);

            // BBSテーブルから取得
            sql = @"
                    select
                      bbskey
                      , strdate
                      , enddate
                      , handle
                      , title
                      , message
                      , upddate
                      , upduser
                    from
                      bbs
                    where
                      strdate <= :today
                      and enddate >= :today
                    order by
                      upddate desc
                ";

            // 戻り値の設定
            return connection.Query(sql, sqlParam).ToList();
        }
    }
}