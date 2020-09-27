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
    /// 依頼状発送確認用データアクセスオブジェクト
    /// </summary>
    public class ReqSendCheckDao : AbstractDao
    {

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public ReqSendCheckDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 依頼状発送確認テーブルレコードを削除する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="prtDiv">様式分類</param>
        /// <param name="seq">SEQ</param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool DeleteReqSendDate(int rsvNo, int judClassCd, int prtDiv, int seq)
        {
            string sql;  // SQLステートメント
            bool ret = false;

            using (var transaction = BeginTransaction())
            {
                try
                {
                    // キー及び更新値の設定
                    var param = new Dictionary<string, object>();

                    // 依頼状発送確認レコードの削除
                    // バインド変数設定
                    param.Add("rsvno", rsvNo);
                    param.Add("judclasscd", judClassCd);
                    param.Add("prtdiv", prtDiv);
                    param.Add("seq", seq);

                    // 該当依頼状の発送日と発送者情報を更新
                    sql = @"
                            update follow_prt_h
                            set
                                prtsenddate = null
                                , senduser = null
                            where
                                rsvno = :rsvno
                                and judclasscd = :judclasscd
                                and prtdiv = :prtdiv
                                and seq = :seq
                            ";

                    int ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = true;
                    }

                    if (ret == true)
                    {
                        // フォローアップ情報テーブル更新(最終依頼状発送日・発送者)
                        sql = @"
                                update follow_info
                                set
                                  (reqsenddate, reqsenduser) = (
                                    select
                                      final.reqsenddate
                                      , final.reqsenduser
                                    from
                                      (
                                        select
                                          prtsenddate as reqsenddate
                                          , senduser as reqsenduser
                                        from
                                          follow_prt_h
                                        where
                                          rsvno = :rsvno
                                          and judclasscd = :judclasscd
                                          and prtdiv = :prtdiv
                                          and prtsenddate is not null
                                        order by
                                          prtsenddate desc
                                      ) final
                                    where
                                      rownum = 1
                                  )
                                where
                                  follow_info.rsvno = :rsvno
                                  and follow_info.judclasscd = :judclasscd
                            ";

                        connection.Execute(sql, param);
                    }

                    // トランザクションをコミット
                    transaction.Commit();

                    // 戻り値の設定
                    ret = true;

                }
                catch
                {
                    // 戻り値の設定
                    ret = false;

                    // エラー発生時はトランザクションをアボートに設定
                    transaction.Rollback();
                }
            }

            return ret;
        }

        /// <summary>
        /// 依頼状発送確認を更新
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="prtDiv">様式分類</param>
        /// <param name="seq">依頼状番号</param>
        /// <param name="sendUser">依頼状発送者</param>
        /// <param name="prtSendDate">依頼状発送日</param>
        /// <returns>
        /// Insert.Normal     正常終了
        /// Insert.Duplicate  同一キーのレコード存在
        /// Insert.Error      異常終了
        /// </returns>
        public Insert UpdateReqSendDate(int rsvNo, int judClassCd, int prtDiv, int seq, string sendUser, DateTime prtSendDate)
        {
            string sql;                 // SQLステートメント
            Insert ret = Insert.Error;  // 関数戻り値
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("judclasscd", judClassCd);
            param.Add("prtdiv", prtDiv);
            param.Add("seq", seq);
            param.Add("reqsenduser", sendUser);
            param.Add("reqsenddate", prtSendDate);

            sql = @"
                    update follow_prt_h
                    set
                        prtsenddate = to_date(
                        to_char(
                            to_date(:reqsenddate, 'YYYY/MM/DD')
                            , 'YYYY/MM/DD'
                        ) || to_char(sysdate, 'HH24MISS')
                        , 'YYYY/MM/DDHH24MISS'
                        )
                        , senduser = :reqsenduser
                    where
                        rsvno = :rsvno
                        and judclasscd = :judclasscd
                        and prtdiv = :prtdiv
                        and seq = :seq
                    ";

            ret2 = connection.Execute(sql, param);

            if (ret2 > 0)
            {
                ret = Insert.Normal;
            }


            if (ret == Insert.Normal)
            {
                // フォローアップ情報テーブル更新(最終依頼状発送日・発送者)
                sql = @"
                        update follow_info
                        set
                          (reqsenddate, reqsenduser) = (
                            select
                              final.reqsenddate
                              , final.reqsenduser
                            from
                              (
                                select
                                  prtsenddate as reqsenddate
                                  , senduser as reqsenduser
                                from
                                  follow_prt_h
                                where
                                  rsvno = :rsvno
                                  and judclasscd = :judclasscd
                                  and prtdiv = :prtdiv
                                  and prtsenddate is not null
                                order by
                                  prtsenddate desc
                              ) final
                            where
                              rownum = 1
                          )
                        where
                          follow_info.rsvno = :rsvno
                          and follow_info.judclasscd = :judclasscd
                     ";
                connection.Execute(sql, param);
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 依頼状発送情報取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="prtDiv">様式分類</param>
        /// <returns>
        /// seq                依頼状番号配列
        /// fileName           依頼状ファイル名配列
        /// judClassName       検査項目名配列
        /// addDate            登録日時配列
        /// addUser            登録者配列
        /// reqSendDate        依頼状発送日配列
        /// reqSendUser        依頼状発送者配列
        /// </returns>
        public List<dynamic> SelectAll_SendDate(int rsvNo, int judClassCd, int prtDiv)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("judclasscd", judClassCd);
            param.Add("prtdiv", prtDiv);

            // 検索条件を満たすレコードを取得
            string sql = @"
                           select
                             follow_prt_h.seq as seq
                             , follow_prt_h.filename as filename
                             , (
                               select
                                 judclassname
                               from
                                 judclass
                               where
                                 judclass.judclasscd = :judclasscd
                             ) as judclassname
                             , follow_prt_h.adddate as adddate
                             , (
                               select
                                 hainsuser.username
                               from
                                 hainsuser
                               where
                                 follow_prt_h.adduser = hainsuser.userid
                             ) as adduser
                             , follow_prt_h.prtsenddate as reqsenddate
                             , (
                               select
                                 hainsuser.username
                               from
                                 hainsuser
                               where
                                 follow_prt_h.senduser = hainsuser.userid
                             ) as reqsenduser
                           from
                             follow_prt_h
                           where
                             follow_prt_h.rsvno = :rsvno
                             and follow_prt_h.judclasscd = :judclasscd
                             and follow_prt_h.prtdiv = :prtdiv
                             and (
                               follow_prt_h.prtsenddate is not null
                               or follow_prt_h.senduser is not null
                             )
                       ";

            return connection.Query(sql, param).ToList();
        }
    }
}