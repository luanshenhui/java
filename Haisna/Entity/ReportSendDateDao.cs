using Dapper;
using Hainsi.Common.Constants;
using Hainsi.Entity.Model.Report;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 成績書発送確認用データアクセスオブジェクト
    /// </summary>
    public class ReportSendDateDao : AbstractDao
    {

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public ReportSendDateDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 成績書発送確認テーブルレコードを削除する
        /// </summary>
        /// <param name="mode">削除モード("MAX":最大SEQを削除、"SEL":KEY指定)</param>
        /// <param name="data">成績書発送情報
        /// rsvNo   予約番号
        /// seq     SEQ
        /// </param>
        /// <returns>
        /// true   正常終了
        /// false  異常終了
        /// </returns>
        public bool DeleteConsult_ReptSend(string mode, IList<DateListDetail> data)
        {
            string sql;  // SQLステートメント

            // 成績書発送確認テーブルレコードの削除
            if (mode.Equals("MAX"))
            {
                // キー及び更新値の設定
                var param = new Dictionary<string, object>
                {

                    // バインド変数設定
                    { "rsvno", Convert.ToInt32(data[0].Rsvno) }
                };

                // 最大SEQを予約番号指定で消す
                sql = @"
                        delete consult_repsend
                        where
                          (rsvno, seq) in (
                            select
                              rsvno
                              , max(seq)
                            from
                              consult_repsend
                            where
                              rsvno = :rsvno
                            group by
                              rsvno
                          )
                      ";

                connection.Execute(sql, param);
            }
            else
            {
                var sqlParamList = new List<dynamic>();

                for (int i = 0; i< data.Count; i += 1) {

                    var param = new Dictionary<string, object>
                    {
                        { "rsvno", data[i].Rsvno },
                        { "seq", data[i].Seq }
                    };

                    sqlParamList.Add(param);
                }

                sql = @"
                        delete consult_repsend 
                        where
                            rsvno = :rsvno 
                            and seq = :seq
                    ";

                connection.Execute(sql, sqlParamList);
            }

            return true;
        }

        /// <summary>
        /// 成績書発送確認を更新する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// rsvno       予約番号
        /// chargeuser  発送担当ユーザ
        /// senddate   成績書発送日
        /// </param>
        /// <returns>
        /// Insert.Normal     正常終了
        /// Insert.Duplicate  同一キーのレコード存在
        /// Insert.Error      異常終了
        /// </returns>
        public Insert UpdateReportSendDate(string mode, UserInfo data)
        {
            string sql;                 // SQLステートメント
            Insert ret = Insert.Error;  // 関数戻り値
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", Convert.ToInt32(data.LngRsvNo));
            param.Add("chargeuser", Convert.ToString(data.USERID));
            param.Add("senddate", Convert.ToString(data.SendDate));

            // 更新モードの場合
            if (mode.Equals("UPD"))
            {
                sql = @"
                        update consult_repsend
                        set
                          reportsenddate = to_date(
                            to_char(to_date(:senddate, 'YYYY/MM/DD'), 'YYYY/MM/DD') || to_char(sysdate, 'HH24MISS')
                            , 'YYYY/MM/DDHH24MISS'
                          )
                          , chargeuser = :chargeuser
                        where
                          (rsvno, seq) in (
                            select
                              rsvno
                              , max(seq)
                            from
                              consult_repsend
                            where
                              rsvno = :rsvno
                            group by
                              rsvno
                          )
                      ";

                ret2 = connection.Execute(sql, param);

                if (ret2 > 0)
                {
                    ret = Insert.Normal;
                }
            }
            // 挿入モードの場合
            else
            {
                sql = @"
                        insert
                        into consult_repsend(
                          rsvno
                          , seq
                          , insdate
                          , insuser
                          , reportsenddate
                          , chargeuser
                        )
                        select
                          :rsvno rsvno
                          , (
                            select
                              nvl(max(seq), 0) + 1
                            from
                              consult_repsend
                            where
                              rsvno = :rsvno
                          ) seq
                          , sysdate
                          , :chargeuser
                          , to_date(
                            to_char(to_date(:senddate, 'YYYY/MM/DD'), 'YYYY/MM/DD') || to_char(sysdate, 'HH24MISS')
                            , 'YYYY/MM/DDHH24MISS'
                          )
                          , :chargeuser
                        from
                          dual
                     ";

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                connection.Execute(sql, param);
                ret = Insert.Normal;
            }

            if (ret == Insert.Normal)
            {
                // 検索条件を満たす受診情報テーブルのレコードを取得
                sql = @"
                        select
                          cscd
                        from
                          consult
                        where
                          rsvno = :rsvno
                          and cscd in (
                            select
                              freefield1
                            from
                              free
                            where
                              freecd like 'RPTSEND%'
                          )
                     ";
                dynamic current = connection.Query(sql, param).FirstOrDefault();

                // 存在した場合、新規挿入する
                if (current != null)
                {
                    sql = @"
                            insert
                            into order_jnl(rsvno, tskdate, odrdiv, tskdiv, senddiv)
                            select
                              :rsvno rsvno
                              , sysdate
                              , '2'
                              , '5'
                              , '0'
                            from
                              dual
                         ";

                    // オーダージャーナルを挿入する
                    connection.Execute(sql, param);
                    ret = Insert.Normal;
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 予約番号を指定して最新の成績書出力情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// seq                SEQ
        /// insDate            登録日時
        /// insUser            登録ユーザ
        /// insUserName        登録ユーザ名
        /// reportSendDate     成績書発送日
        /// chargeUser         成績書発送ユーザ
        /// chargeUserName     成績書発送ユーザ名
        /// </returns>
        public List<dynamic> SelectConsult_ReptSendLast(string rsvNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 検索条件を満たすレコードを取得
            string sql = @"
                            select
                              mainview.rsvno
                              , mainview.seq
                              , mainview.insdate
                              , mainview.insuser
                              , user1.username insusername
                              , mainview.reportsenddate
                              , mainview.chargeuser
                              , user2.username chargeusername
                            from
                              hainsuser user1
                              , hainsuser user2
                              , (
                                select
                                  consult_repsend.rsvno
                                  , consult_repsend.seq
                                  , consult_repsend.insdate
                                  , consult_repsend.insuser
                                  , consult_repsend.reportsenddate
                                  , consult_repsend.chargeuser
                                from
                                  consult_repsend
                                where
                                  consult_repsend.rsvno = :rsvno
                                order by
                                  seq desc
                              ) mainview
                            where
                              mainview.insuser = user1.userid
                              and mainview.chargeuser = user2.userid(+)
                              and rownum = 1
                        ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 検索条件を満たす成績書作成情報の一覧を取得する
        /// </summary>
        /// <param name="count">件数モードの戻り値</param>
        /// <param name="mode">モード　CNT:件数をカウントのみ、NULL:データ取得</param>
        /// <param name="key">検索キー</param>
        /// <param name="strCslDate">受診日（開始）</param>
        /// <param name="endCslDate">受診日（終了）</param>
        /// <param name="searchCsCd">コースコード</param>
        /// <param name="searchOrgCd1">団体コード１</param>
        /// <param name="searchOrgCd2">団体コード２</param>
        /// <param name="searchOrgGrpCd">団体グループコード</param>
        /// <param name="sendMode">発送状態（0:全て、1:発送済み、2:未発送）</param>
        /// <param name="startPos">取得開始位置</param>
        /// <param name="pageMaxLine">１ページ表示ＭＡＸ行（０：ＭＡＸ行指定無し）</param>
        /// <returns>
        /// rsvNo              予約番号
        /// cslDate            受診日
        /// dayId              当日ID
        /// perId              個人ID
        /// csCd               コースコード
        /// csName             コース名
        /// webColor           コース用カラー
        /// lastName           漢字名（性）
        /// firstName          漢字名（名）
        /// lastkName          カナ名（性）
        /// firstkName         カナ名（名）
        /// orgCd1             団体コード１
        /// orgCd2             団体コード２
        /// orgName            団体名
        /// sendCount          発送確認履歴数
        /// gfFlg              後日GF対象フラグ
        /// cfFlg              後日CF対象フラグ
        /// seq                発送確認SEQ
        /// insDate            発送確認登録日
        /// reportSendDate     発送確認日
        /// insUserName        発送確認登録者名
        /// chargeUserName     発送確認者名
        /// pubNote            コメント
        /// reportOurEng       英文出力
        /// </returns>
        public List<dynamic> SelectReportSendDateList(ref int count, string mode, string key, DateTime strCslDate, DateTime endCslDate, string searchCsCd,
            string searchOrgCd1, string searchOrgCd2, string searchOrgGrpCd, int sendMode, int startPos = 1, int pageMaxLine = 0)
        {
            string sql;  // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("startpos", startPos);
            if (pageMaxLine > 0)
            {
                param.Add("endpos", startPos + pageMaxLine - 1);
            }

            param.Add("strdate", strCslDate);
            param.Add("enddate", endCslDate);

            // 検索条件を満たすレコードを取得
            if (mode.Equals("CNT"))
            {
                // 件数モードの場合
                sql = "select count(*) reccount";
            }
            else
            {
                // データ明細取得モードの場合
                sql = @"
                        select
                          mainview.*
                          , consult_repsend.seq
                          , consult_repsend.insdate
                          , consult_repsend.insuser
                          , consult_repsend.reportsenddate
                          , consult_repsend.chargeuser
                          , user1.username insusername
                          , user2.username chargeusername
                          , course_p.csname
                          , course_p.webcolor
                          , pubnotepackage.editcslpubnoteoneline(mainview.rsvno, null, 2) pubnote
                        from
                          course_p
                          , hainsuser user1
                          , hainsuser user2
                          , consult_repsend
                          , (select nativeview.*, rownum chkcount
                      ";
            }

            sql += @"
                    from
                      (
                        select
                          receipt.rsvno
                          , receipt.csldate
                          , receipt.dayid
                          , consult.perid
                          , person.lastname
                          , person.firstname
                          , consult.cscd
                          , person.lastkname
                          , person.firstkname
                          , org.orgcd1
                          , org.orgcd2
                          , org.orgsname
                          , consult.reportoureng
                          , (
                            select
                              count(consult_repsend.rsvno)
                            from
                              consult_repsend
                            where
                              consult_repsend.rsvno = receipt.rsvno
                          ) sendcount
                          , (
                            select
                              count(rsl.rsvno)
                            from
                              rsl
                            where
                              rsl.rsvno = consult.rsvno
                              and itemcd = ''
                              and suffix = ''
                          ) gfflg
                          , (
                            select
                              count(rsl.rsvno)
                            from
                              rsl
                            where
                              rsl.rsvno = consult.rsvno
                              and itemcd = ''
                              and suffix = ''
                          ) cfflg
                        from
                    ";

            // 団体グループコードが指定されている場合
            if (!(searchOrgGrpCd == null))
            {
                param.Add("orggrpcd", searchOrgGrpCd);
                sql += " (select orgcd1, orgcd2 from orggrp_i where orggrpcd = :orggrpcd) orggrp, ";
            }

            // ※CONSULTにも日付しばりがあった方がレスポンスがよい
            sql += @"
                    org
                    , person
                    , consult
                    , receipt
                    where
                      receipt.csldate between :strdate and :enddate
                      and consult.csldate between :strdate and :enddate
                      and consult.rsvno = receipt.rsvno
                      and receipt.comedate is not null
                      and person.perid = consult.perid
                      and org.orgcd1 = consult.orgcd1
                      and org.orgcd2 = consult.orgcd2
                   ";

            // コースコードが指定されている場合
            if (!string.IsNullOrEmpty(searchCsCd))
            {
                param.Add("cscd", searchCsCd);
                sql += " and consult.cscd = :cscd ";
            }

            // 個人IDが指定されている場合
            if (!string.IsNullOrEmpty(key))
            {
                param.Add("perid", key);
                sql += " and consult.perid = :perid ";
            }

            // 団体コードが指定されている場合
            if (!string.IsNullOrEmpty(searchOrgCd1) && !string.IsNullOrEmpty(searchOrgCd2))
            {
                param.Add("orgcd1", searchOrgCd1);
                param.Add("orgcd2", searchOrgCd2);
                sql += @"
                    and consult.orgcd1 = :orgcd1
                    and consult.orgcd2 = :orgcd2
                    ";
            }

            // 団体グループコードが指定されている場合
            if (!string.IsNullOrEmpty(searchOrgGrpCd))
            {
                sql += " and consult.orgcd1 = orggrp.orgcd1 and consult.orgcd2 = orggrp.orgcd2 ";
            }

            sql += " order by csldate , dayid   ) nativeview ";

            // 発送済みの指定がある場合
            if (sendMode == 1)
            {
                sql += " where sendcount > 0 ";
            }

            // 未発送の指定がある場合
            if (sendMode == 2)
            {
                sql += " where sendcount = 0 ";
            }

            if (mode.Equals(""))
            {
                // 明細モードの場合
                sql += @"
                        order by
                          nativeview.csldate
                          , nativeview.dayid) mainview
                        where
                          mainview.rsvno = consult_repsend.rsvno(+)
                          and mainview.cscd = course_p.cscd
                          and consult_repsend.insuser = user1.userid(+)
                          and consult_repsend.chargeuser = user2.userid(+)
                    ";

                // 取得件数で絞込み
                sql += " and chkcount >= :startpos ";

                if (pageMaxLine > 0)
                {
                    sql += " and chkcount <= :endpos ";
                }

                sql += " order by mainview.csldate, mainview.dayid, chkcount, seq ";

                return connection.Query(sql, param).ToList();
            }

            if (mode.Equals("CNT"))
            {
                // オブジェクトの参照設定
                count = Convert.ToInt32(connection.Query(sql, param).FirstOrDefault().RECCOUNT);
            }

            return null;
        }
    }
}