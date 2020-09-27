using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity.Model.PubNote;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading;

namespace Hainsi.Entity
{
    /// <summary>
    /// コメント情報データアクセスオブジェクト
    /// </summary>
    public class PubNoteDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public PubNoteDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 指定された条件のコメントを取得する
        /// </summary>
        /// <param name="selInfo">検索情報（1:受診情報、2:個人、3:団体、4:契約 0:個人＋受診情報)</param>
        /// <param name="histFlg">0:今回のみ、1:過去のみ、2:全件</param>
        /// <param name="startDate">表示期間（開始日）</param>
        /// <param name="endDate">表示期間（終了日）</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="seq">０のとき全件</param>
        /// <param name="pubNoteDivCd">受診情報ノート分類コード</param>
        /// <param name="dispKbn">表示対象</param>
        /// <param name="userId">ユーザＩＤ</param>
        /// <param name="incDelNote">1:削除データも結果に含める</param>
        /// <returns>
        /// 0    正常終了
        /// ＜0   異常終了
        /// </returns>
        public List<dynamic> SelectPubNote(int selInfo, int histFlg, string startDate, string endDate, int rsvNo, string perId, string orgCd1, string orgCd2, string ctrPtCd, int seq, string pubNoteDivCd, int dispKbn, string userId, string incDelNote)
        {
            string sql; // SQLステートメント

            string stmtKikan = ""; // SQLステートメント(表示期間)
            string stmtCtrpt = ""; // SQLステートメント(有効契約期間)

            List<dynamic> data = new List<dynamic>();

            // パラメータチェック
            switch (selInfo)
            {
                // 受診情報, 個人
                case 0:
                case 1:
                case 2:
                    if (0 == rsvNo && string.IsNullOrEmpty(perId))
                    {
                        return data;
                    }
                    break;
                // 団体
                case 3:
                    if (0 == rsvNo && string.IsNullOrEmpty(orgCd1) && string.IsNullOrEmpty(orgCd2))
                    {
                        return data;
                    }
                    break;
                // 契約
                case 4:
                    if (0 == rsvNo && string.IsNullOrEmpty(ctrPtCd) && string.IsNullOrEmpty(orgCd1) && string.IsNullOrEmpty(orgCd2))
                    {
                        return data;
                    }
                    break;
                default:
                    throw new ArgumentException();
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("perid", perId);
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd2", orgCd2);
            param.Add("ctrptcd", ctrPtCd);
            param.Add("userid", userId);

            // 表示期間は過去を含むときだけ検索条件として使用する
            if (0 == histFlg)
            {
                stmtKikan = "";
            }
            else
            {
                // 検索条件に表示期間　開始、終了ともあり？
                if (!"".Equals(startDate) && !string.IsNullOrEmpty(startDate)
                    && !"".Equals(endDate) && !string.IsNullOrEmpty(endDate))
                {
                    param.Add("strdate", startDate);
                    param.Add("enddate", endDate);
                    stmtKikan = @"
                                 and consult.csldate between :strdate and :enddate
                              ";
                    stmtCtrpt = @"
                                 and ((ctrpt.enddate >= :strdate and ctrpt.enddate <= :enddate) or (ctrpt.strdate >= :strdate and ctrpt.strdate <= :enddate))
                              ";
                }
                else
                {
                    // 検索条件に表示期間　開始のみ？
                    if ((!"".Equals(startDate) && !string.IsNullOrEmpty(startDate))
                    && ("".Equals(endDate) || string.IsNullOrEmpty(endDate)))
                    {
                        param.Add("strdate", startDate);
                        stmtKikan = @"
                                     and consult.csldate >= :strdate
                                  ";
                        stmtCtrpt = @"
                                     and :strdate between ctrpt.strdate and ctrpt.enddate
                                  ";
                    }
                    else
                    {
                        // 検索条件に表示期間　終了のみ？
                        if (("".Equals(startDate) || string.IsNullOrEmpty(startDate))
                        && (!"".Equals(endDate) && !string.IsNullOrEmpty(endDate)))
                        {
                            param.Add("enddate", endDate);
                            stmtKikan = @"
                                         and consult.csldate <= :enddate
                                      ";
                            stmtCtrpt = @"
                                         and :enddate between ctrpt.strdate and ctrpt.enddate
                                      ";
                        }
                        else
                        {
                            stmtKikan = "";
                        }
                    }
                }
            }

            // ノートを一括取得
            sql = @"
                    select
                      pubnote.selinfo
                      , pubnote.rsvno
                      , pubnote.seq
                      , pubnote.pubnotedivcd
                      , pubnotedivview.pubnotedivname
                      , pubnotedivview.defaultdispkbn
                      , pubnotedivview.onlydispkbn
                      , pubnote.dispkbn
                      , pubnote.upddate
                      , pubnote.upduser
                      , hainsuser.username
                      , pubnote.boldflg
                      , pubnote.pubnote
                      , pubnote.dispcolor
                      , pubnote.csldate
                      , course_p.csname
                      , pubnote.delflg
                    from
                      hainsuser
                      , course_p
                      , (
                ";

            //個人ノートを取得
            if (2 == selInfo || 0 == selInfo)
            {
                sql += @"
                        select
                          2 selinfo
                          , null rsvno
                          , perpubnote.seq
                          , perpubnote.pubnotedivcd
                          , perpubnote.dispkbn
                          , perpubnote.upddate
                          , perpubnote.upduser
                          , perpubnote.boldflg
                          , perpubnote.pubnote
                          , perpubnote.dispcolor
                          , 0 histno
                          , null csldate
                          , null cscd
                          , perpubnote.delflg
                        from
                          perpubnote
                      ";

                if (0 != rsvNo)
                {
                    // 予約番号が指定されている
                    sql += @"
                            where
                              perpubnote.perid = (select perid from consult where rsvno = :rsvno)
                     ";
                }
                else
                {
                    // 個人ＩＤが指定されている
                    sql += @"
                            where
                              perpubnote.perid = :perid
                         ";
                }

                // 削除データを含めない場合
                if ("1" != incDelNote)
                {
                    sql += @"
                            and perpubnote.delflg is null
                         ";
                }
            }

            if (0 == selInfo)
            {
                // 個人＋受診情報とする
                sql += @"
                        union all
                     ";
            }

            // 受診情報ノートを取得
            if (1 == selInfo || 0 == selInfo)
            {
                // 個人＋受診情報とする
                sql += @"
                        select
                          1 selinfo
                          , cslpubnote.rsvno
                          , cslpubnote.seq
                          , cslpubnote.pubnotedivcd
                          , cslpubnote.dispkbn
                          , cslpubnote.upddate
                          , cslpubnote.upduser
                          , cslpubnote.boldflg
                          , cslpubnote.pubnote
                          , cslpubnote.dispcolor
                          , consulthist.histno
                          , consulthist.csldate
                          , consulthist.cscd
                          , cslpubnote.delflg
                        from
                          cslpubnote
                          ,
                     ";
                sql += @"
                        (
                          select
                            rownum histno
                            , rsvno
                            , csldate
                            , cscd
                          from
                            (
                              select
                                consult.rsvno
                                , consult.csldate
                                , consult.cscd
                              from
                                consult
                     ";
                if (0 != rsvNo)
                {
                    // 予約番号が指定されている
                    if (0 == histFlg)
                    {
                        // 今回のみ
                        sql += @"
                                where
                                  consult.rsvno = :rsvno
                                  and consult.cancelflg = 0)
                             ";
                    }
                    else
                    {
                        string sql_histFlg = (histFlg == 1) ? "< " : "<= ";
                        sql += String.Format(@"
                                               where
                                                 consult.perid = (select perid from consult where rsvno = :rsvno)
                                                 and consult.csldate {0} (
                                                     select
                                                         csldate
                                                     from
                                                         consult
                                                     where
                                                         rsvno = :rsvno
                                                  )
                                                  {1}
                                                  and consult.cancelflg = 0
                                                  order by
                                                      consult.csldate desc)
                             ", sql_histFlg, stmtKikan);

                    }
                }
                else
                {
                    // 個人ＩＤが指定されている
                    sql += String.Format(@"
                                           where
                                             consult.perid = :perid
                                             {0}
                                             and consult.cancelflg = 0
                                           order by consult.csldate desc)
                         ", stmtKikan);
                }

                sql += @"
                        ) consulthist
                        where
                          cslpubnote.rsvno = consulthist.rsvno
                     ";

                // 削除データを含めない場合
                if ("1" != incDelNote)
                {
                    sql += @"
                            and cslpubnote.delflg is null
                         ";
                }
            }

            // 団体ノートを取得
            if (3 == selInfo)
            {
                sql += @"
                        select
                          3 selinfo
                          , null rsvno
                          , orgpubnote.seq
                          , orgpubnote.pubnotedivcd
                          , orgpubnote.dispkbn
                          , orgpubnote.upddate
                          , orgpubnote.upduser
                          , orgpubnote.boldflg
                          , orgpubnote.pubnote
                          , orgpubnote.dispcolor
                          , 0 histno
                          , null csldate
                          , null cscd
                          , orgpubnote.delflg
                        from
                          orgpubnote
                     ";

                if (0 != rsvNo)
                {
                    // 予約番号が指定されている
                    sql += @"
                            where
                              orgpubnote.orgcd1 = (select orgcd1 from consult where rsvno = :rsvno)
                              and orgpubnote.orgcd2 = (select orgcd2 from consult where rsvno = :rsvno)
                         ";
                }
                else
                {
                    // 団体コードが指定されている
                    sql += @"
                            where
                              orgpubnote.orgcd1 = :orgcd1
                              and orgpubnote.orgcd2 = :orgcd2
                         ";
                }

                // 削除データを含めない場合
                if ("1" != incDelNote)
                {
                    sql += @"
                            and orgpubnote.delflg is null
                         ";
                }
            }

            // 契約ノートを取得
            if (4 == selInfo)
            {
                sql += @"
                        select
                          4 selinfo
                          , null rsvno
                          , ctrptpubnote.seq
                          , ctrptpubnote.pubnotedivcd
                          , ctrptpubnote.dispkbn
                          , ctrptpubnote.upddate
                          , ctrptpubnote.upduser
                          , ctrptpubnote.boldflg
                          , ctrptpubnote.pubnote
                          , ctrptpubnote.dispcolor
                          , 0 histno
                          , null csldate
                          , null cscd
                          , ctrptpubnote.delflg
                        from
                          ctrptpubnote
                     ";

                if (0 != rsvNo)
                {
                    // 予約番号が指定されている
                    sql += @"
                            where
                              ctrptpubnote.ctrptcd = (
                                select
                                  ctrptcd
                                from
                                  consult
                                where
                                  rsvno = :rsvno
                              )
                         ";
                }
                else
                {
                    // 団体コードが指定されている
                    if (!string.IsNullOrEmpty(ctrPtCd)
                        && 0 != Convert.ToInt32(ctrPtCd)
                        && Util.IsNumber(ctrPtCd))
                    {
                        sql += @"
                                where
                                  ctrptpubnote.ctrptcd = :ctrptcd
                             ";
                    }
                    else
                    {
                        // 団体コードで検索
                        sql += String.Format(@"
                                              where
                                                ctrptpubnote.ctrptcd in (
                                                  select distinct
                                                    ctrpt.ctrptcd
                                                  from
                                                    ctrpt
                                                    , ctrmng
                                                  where
                                                    ctrpt.ctrptcd = ctrmng.ctrptcd
                                                    and orgcd1 = :orgcd1
                                                    and orgcd2 = :orgcd2
                                                    {0} )
                             ", stmtCtrpt);
                    }
                }

                // 削除データを含めない場合
                if ("1" != incDelNote)
                {
                    sql += @"
                            and ctrptpubnote.delflg is null
                         ";
                }
            }

            // 契約ノートを取得
            sql += @"
                   ) pubnote,
                 ";

            sql += @"
                    (
                      select
                        authnote
                        , defnotedispkbn
                      from
                        hainsuser
                      where
                        userid = :userid
                    ) userauthview
                    ,
                 ";

            sql += @"
                    (
                      select
                        pubnotedivcd
                        , pubnotedivname
                        , decode(
                          defaultdispkbn
                          , authnote
                          , defaultdispkbn
                          , defnotedispkbn
                        ) defaultdispkbn
                        , onlydispkbn
                      from
                        (
                          select
                            pubnotediv.pubnotedivcd
                            , pubnotediv.pubnotedivname
                            , nvl(
                              pubnotediv.defaultdispkbn
                              , userview.defnotedispkbn
                            ) defaultdispkbn
                            , pubnotediv.onlydispkbn
                            , userview.authnote
                            , userview.defnotedispkbn
                          from
                            pubnotediv
                            , (
                              select
                                authnote
                                , defnotedispkbn
                              from
                                hainsuser
                              where
                                userid = :userid
                            ) userview
                          where
                            (
                              userview.authnote = 1
                              and (
                                pubnotediv.onlydispkbn = 1
                                or pubnotediv.onlydispkbn is null
                              )
                            )
                            or (
                              userview.authnote = 2
                              and (
                                pubnotediv.onlydispkbn = 2
                                or pubnotediv.onlydispkbn is null
                              )
                            )
                            or (userview.authnote = 3)
                        )
                    ) pubnotedivview
                 ";

            sql += @"
                    where
                      pubnote.pubnotedivcd = pubnotedivview.pubnotedivcd
                      and pubnote.upduser = hainsuser.userid
                      and pubnote.cscd = course_p.cscd(+)
                 ";

            sql += @"
                    and (
                      (
                        userauthview.authnote = 1
                        and (pubnote.dispkbn = 1 or pubnote.dispkbn = 3)
                      )
                      or (
                        userauthview.authnote = 2
                        and (pubnote.dispkbn = 2 or pubnote.dispkbn = 3)
                      )
                      or (userauthview.authnote = 3)
                    )
                 ";

            // Ｓｅｑ指定あり
            if (0 != seq)
            {
                param.Add("seq", seq);
                sql += @"
                        and pubnote.seq = :seq
                     ";
            }

            // 受診情報ノート分類コード指定あり
            if (!string.IsNullOrEmpty(pubNoteDivCd))
            {
                param.Add("pubnotediv", pubNoteDivCd);
                sql += @"
                        and pubnote.pubnotedivcd = :pubnotediv
                     ";
            }

            // 表示対象指定あり
            if (0 != dispKbn)
            {
                param.Add("dispkbn", dispKbn);
                sql += @"
                        and (
                          pubnote.dispkbn = :dispkbn
                          or pubnote.dispkbn = 3
                        )
                     ";
            }

            if (0 == selInfo
                || 1 == selInfo
                || 2 == selInfo)
            {
                sql += @"
                        order by
                          pubnote.selinfo desc
                          , pubnote.csldate desc
                          , pubnote.upddate desc
                     ";
            }
            else
            {
                sql += @"
                        order by
                          pubnote.histno
                          , pubnote.seq
                     ";

            }

            data = connection.Query(sql, param).ToList();

            return data;
        }

        /// <summary>
        /// コメントを登録する
        /// </summary>
        /// <param name="mode">挿入："insert", 更新："update"</param>
        /// <param name="data">コメント情報
        /// perId 個人ＩＤ
        /// seq SEQ
        /// pubNoteDivCd 受診情報ノート分類コード
        /// dispKbn 表示対象
        /// updUser 登録者
        /// boldFlg 太字区分
        /// pubNote ノート
        /// dispColor 表示色
        /// newSeq 新しいＳＥＱ
        /// selInfo 検索情報（1:受診情報、2:個人、3:団体、4:契約）
        /// orgCd1 団体コード１
        /// orgCd2 団体コード２
        /// ctrPtCd 契約パターンコード
        /// rsvNo 予約番号
        /// </param>
        /// <param name="newSeq">新しいＳＥＱ</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert EntryPubNote(string mode, CommentPubNote data, out int newSeq)
        {
            Insert ret = Insert.Error;

            // パラメータチェック
            if (!"insert".Equals(mode) && !"update".Equals(mode))
            {
                throw new ArgumentException();
            }

            switch (data.SelInfo)
            {
                // 受診情報
                case 1:
                    if (0 == data.RsvNo)
                    {
                        // 受診情報コメント登録の呼び出し、または引数が不正です。
                        throw new ArgumentException();
                    }

                    ret = EntryCslPubNote(mode, data, out newSeq);

                    // 異常終了なら処理終了
                    if (Insert.Normal != ret)
                    {
                        break;
                    }

                    break;
                // 個人
                case 2:
                    if ("".Equals(Convert.ToString(data.PerId)))
                    {
                        // 個人コメント登録の呼び出し、または引数が不正です。
                        throw new ArgumentException();
                    }

                    ret = EntryPerPubNote(mode, data, out newSeq);
                    // 異常終了なら処理終了
                    if (Insert.Normal != ret)
                    {
                        break;
                    }
                    break;
                // 団体
                case 3:
                    if ("".Equals(Convert.ToString(data.OrgCd1))
                        || "".Equals(Convert.ToString(data.OrgCd2)))
                    {
                        // 団体コメント登録の呼び出し、または引数が不正です。
                        throw new ArgumentException();
                    }

                    ret = EntryOrgPubNote(mode, data, out newSeq);
                    // 異常終了なら処理終了
                    if (Insert.Normal != ret)
                    {
                        break;
                    }
                    break;
                // 契約
                case 4:
                    if ("".Equals(Convert.ToString(data.CtrPtCd)))
                    {
                        // 契約コメント登録の呼び出し、または引数が不正です。
                        throw new ArgumentException();
                    }

                    ret = EntryCtrPtPubNote(mode, data, out newSeq);
                    // 異常終了なら処理終了
                    if (Insert.Normal != ret)
                    {
                        break;
                    }
                    break;
                default:
                    // プロシージャの呼び出し、または引数が不正です。
                    throw new ArgumentException();
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 受診情報コメントを登録する
        /// </summary>
        /// <param name="mode">挿入："insert", 更新："update"</param>
        /// <param name="data">コメント情報
        /// perId 個人ＩＤ
        /// seq SEQ
        /// pubNoteDivCd 受診情報ノート分類コード
        /// dispKbn 表示対象
        /// updUser 登録者
        /// boldFlg 太字区分
        /// pubNote ノート
        /// dispColor 表示色
        /// newSeq 新しいＳＥＱ
        /// selInfo 検索情報（1:受診情報、2:個人、3:団体、4:契約）
        /// orgCd1 団体コード１
        /// orgCd2 団体コード２
        /// ctrPtCd 契約パターンコード
        /// rsvNo 予約番号
        /// </param>
        /// <param name="newSeq">新しいＳＥＱ</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert EntryCslPubNote(string mode, CommentPubNote data, out int newSeq)
        {
            Insert ret = Insert.Error;
            newSeq = 0;

            using (var transaction = BeginTransaction())
            {
                switch (mode)
                {
                    // 挿入
                    case "insert":

                        ret = InsertCslPubNote(data, out newSeq);

                        // 異常終了なら処理終了
                        if (Insert.Normal != ret)
                        {
                            break;
                        }

                        break;
                    // 更新
                    case "update":
                        ret = UpdateCslPubNote(data);
                        // 異常終了なら処理終了
                        if (Insert.Normal != ret)
                        {
                            break;
                        }
                        break;
                    default:
                        // プロシージャの呼び出し、または引数が不正です。
                        throw new ArgumentException();
                }

                if (ret == Insert.Normal)
                {
                    // トランザクションをコミット
                    transaction.Commit();
                }
                else
                {
                    // 異常終了ならRollBack
                    transaction.Rollback();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 個人コメントを登録する
        /// </summary>
        /// <param name="mode">挿入："insert", 更新："update"</param>
        /// <param name="data">コメント情報
        /// perId 個人ＩＤ
        /// seq SEQ
        /// pubNoteDivCd 受診情報ノート分類コード
        /// dispKbn 表示対象
        /// updUser 登録者
        /// boldFlg 太字区分
        /// pubNote ノート
        /// dispColor 表示色
        /// newSeq 新しいＳＥＱ
        /// selInfo 検索情報（1:受診情報、2:個人、3:団体、4:契約）
        /// orgCd1 団体コード１
        /// orgCd2 団体コード２
        /// ctrPtCd 契約パターンコード
        /// rsvNo 予約番号
        /// </param>
        /// <param name="newSeq">新しいＳＥＱ</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert EntryPerPubNote(string mode, CommentPubNote data, out int newSeq)
        {
            Insert ret = Insert.Error;
            newSeq = 0;

            using (var transaction = BeginTransaction())
            {
                switch (mode)
                {
                    // 挿入
                    case "insert":

                        ret = InsertPerPubNote(data, out newSeq);

                        // 異常終了なら処理終了
                        if (Insert.Normal != ret)
                        {
                            break;
                        }
                        break;
                    // 更新
                    case "update":
                        ret = UpdatePerPubNote(data);
                        // 異常終了なら処理終了
                        if (Insert.Normal != ret)
                        {
                            break;
                        }
                        break;
                    default:
                        // プロシージャの呼び出し、または引数が不正です。
                        throw new ArgumentException();
                }

                if (ret == Insert.Normal)
                {
                    // トランザクションをコミット
                    transaction.Commit();
                }
                else
                {
                    // 異常終了ならRollBack
                    transaction.Rollback();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 団体コメントを登録する
        /// </summary>
        /// <param name="mode">挿入："insert", 更新："update"</param>
        /// <param name="data">コメント情報
        /// perId 個人ＩＤ
        /// seq SEQ
        /// pubNoteDivCd 受診情報ノート分類コード
        /// dispKbn 表示対象
        /// updUser 登録者
        /// boldFlg 太字区分
        /// pubNote ノート
        /// dispColor 表示色
        /// newSeq 新しいＳＥＱ
        /// selInfo 検索情報（1:受診情報、2:個人、3:団体、4:契約）
        /// orgCd1 団体コード１
        /// orgCd2 団体コード２
        /// ctrPtCd 契約パターンコード
        /// rsvNo 予約番号
        /// </param>
        /// <param name="newSeq">新しいＳＥＱ</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert EntryOrgPubNote(string mode, CommentPubNote data, out int newSeq)
        {
            Insert ret = Insert.Error;
            newSeq = 0;

            using (var transaction = BeginTransaction())
            {
                switch (mode)
                {
                    // 挿入
                    case "insert":

                        ret = InsertOrgPubNote(data, out newSeq);

                        // 異常終了なら処理終了
                        if (Insert.Normal != ret)
                        {
                            break;
                        }
                        break;
                    // 更新
                    case "update":
                        ret = UpdateOrgPubNote(data);
                        // 異常終了なら処理終了
                        if (Insert.Normal != ret)
                        {
                            break;
                        }
                        break;
                    default:
                        // プロシージャの呼び出し、または引数が不正です。
                        throw new ArgumentException();
                }

                if (ret == Insert.Normal)
                {
                    // トランザクションをコミット
                    transaction.Commit();
                }
                else
                {
                    // 異常終了ならRollBack
                    transaction.Rollback();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 契約コメントを登録する
        /// </summary>
        /// <param name="mode">挿入："insert", 更新："update"</param>
        /// <param name="data">コメント情報
        /// perId 個人ＩＤ
        /// seq SEQ
        /// pubNoteDivCd 受診情報ノート分類コード
        /// dispKbn 表示対象
        /// updUser 登録者
        /// boldFlg 太字区分
        /// pubNote ノート
        /// dispColor 表示色
        /// newSeq 新しいＳＥＱ
        /// selInfo 検索情報（1:受診情報、2:個人、3:団体、4:契約）
        /// orgCd1 団体コード１
        /// orgCd2 団体コード２
        /// ctrPtCd 契約パターンコード
        /// rsvNo 予約番号
        /// </param>
        /// <param name="newSeq">新しいＳＥＱ</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert EntryCtrPtPubNote(string mode, CommentPubNote data, out int newSeq)
        {
            Insert ret = Insert.Error;
            newSeq = 0;

            using (var transaction = BeginTransaction())
            {
                switch (mode)
                {
                    // 挿入
                    case "insert":

                        ret = InsertCtrPtPubNote(data, out newSeq);

                        // 異常終了なら処理終了
                        if (Insert.Normal != ret)
                        {
                            break;
                        }

                        break;
                    // 更新
                    case "update":
                        ret = UpdateCtrPtPubNote(data);
                        // 異常終了なら処理終了
                        if (Insert.Normal != ret)
                        {
                            break;
                        }
                        break;
                    default:
                        // プロシージャの呼び出し、または引数が不正です。
                        throw new ArgumentException();
                }

                if (ret == Insert.Normal)
                {
                    // トランザクションをコミット
                    transaction.Commit();
                }
                else
                {
                    // 異常終了ならRollBack
                    transaction.Rollback();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 受診情報コメントを新規に登録する
        /// </summary>
        /// <param name="data">受診情報コメント情報
        /// rsvNo 予約番号
        /// pubNoteDivCd 受診情報ノート分類コード
        /// dispKbn 表示対象
        /// updUser 登録者
        /// boldFlg 太字区分
        /// pubNote ノート
        /// dispColor 表示色
        /// </param>
        /// <param name="newSeq">新しいＳＥＱ</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert InsertCslPubNote(CommentPubNote data, out int newSeq)
        {
            string sql; //SQLステートメント
            Insert ret = Insert.Error;
            int ret2;
            bool success = false;  // 処理成功フラグ
            dynamic seq;
            newSeq = 0;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", data.RsvNo);

            while (true)
            {
                sql = @"
                        select
                          nvl(max(seq), 0) + 1 newseq
                        from
                          cslpubnote
                        where
                          rsvno = :rsvno
                    ";

                try
                {
                    for (int i = 0; i < 10; i++)
                    {
                        success = true;

                        // 現仮IDの最大値を取得する
                        seq = connection.Query(sql, param).FirstOrDefault();
                        newSeq = Convert.ToInt32(seq.NEWSEQ);

                        if (success)
                        {
                            break;
                        }

                        // ちょっとだけ待つ
                        Thread.Sleep(1000);
                    }
                }
                catch
                {
                }
                finally
                {
                    // 10回リトライしてもだめな場合は終了(発生しないとは思うが)
                    if (!success)
                    {
                        new Exception("現在他業務にてコメント情報を使用中のため、行番号発番処理は行えませんでした。");
                    }
                }

                param.Add("seq", newSeq);
                param.Add("pubnotedivcd", data.PubNoteDivCd);
                param.Add("dispKbn", data.DispKbn);
                param.Add("upduser", data.UpdUser);
                param.Add("boldflg", data.BoldFlg);
                param.Add("pubnote", data.PubNote.Trim());
                param.Add("dispcolor", data.DispColor);

                sql = @"
                        insert
                        into cslpubnote(
                          rsvno
                          , seq
                          , pubnotedivcd
                          , dispkbn
                          , upddate
                          , upduser
                          , boldflg
                          , pubnote
                          , dispcolor
                        )
                        values (
                          :rsvno
                          , :seq
                          , :pubnotedivcd
                          , :dispkbn
                          , sysdate
                          , :upduser
                          , :boldflg
                          , :pubnote
                          , :dispcolor
                            )
                      ";

                ret2 = connection.Execute(sql, param);

                if (ret2 >= 0)
                {
                    ret = Insert.Normal;
                }

                break;

            }
            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 受診情報コメントを更新する
        /// </summary>
        /// <param name="data">受診情報コメント情報
        /// rsvNo            予約番号
        /// seq              ＳＥＱ
        /// pubNoteDivCd     受診情報ノート分類コード
        /// dispKbn       　 表示対象
        /// updUser       　 登録者
        /// boldFlg        　太字区分
        /// pubNote        　ノート
        /// dispColor        表示色
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateCslPubNote(CommentPubNote data)
        {
            string sql; //SQLステートメント
            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", data.RsvNo);
            param.Add("seq", data.Seq);
            param.Add("pubnotedivcd", data.PubNoteDivCd);
            param.Add("dispKbn", data.DispKbn);
            param.Add("upduser", data.UpdUser);
            param.Add("boldflg", data.BoldFlg);
            param.Add("pubnote", data.PubNote.Trim());
            param.Add("dispcolor", data.DispColor);

            sql = @"
                    update cslpubnote
                    set
                      pubnotedivcd = :pubnotedivcd
                      , dispkbn = :dispkbn
                      , upddate = sysdate
                      , upduser = :upduser
                      , boldflg = :boldflg
                      , pubnote = :pubnote
                      , dispcolor = :dispcolor
                    where
                      rsvno = :rsvno
                      and seq = :seq
                ";

            ret2 = connection.Execute(sql, param);

            if (ret2 > 0)
            {
                ret = Insert.Normal;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 個人コメントを新規に登録する
        /// </summary>
        /// <param name="data">受診情報コメント情報
        /// perId 予約番号
        /// pubNoteDivCd 受診情報ノート分類コード
        /// dispKbn 表示対象
        /// updUser 登録者
        /// boldFlg 太字区分
        /// pubNote ノート
        /// dispColor 表示色
        /// </param>
        /// <param name="newSeq">新しいＳＥＱ</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert InsertPerPubNote(CommentPubNote data, out int newSeq)
        {
            string sql; //SQLステートメント
            Insert ret = Insert.Error;
            bool success = false;  // 処理成功フラグ
            dynamic seq;
            newSeq = 0;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("perid", data.PerId);


            while (true)
            {
                sql = @"
                        select
                          nvl(max(seq), 0) + 1 newseq
                        from
                          perpubnote
                        where
                          perid = :perid
                    ";

                try
                {
                    for (int i = 0; i < 10; i++)
                    {
                        success = true;

                        // 現仮IDの最大値を取得する
                        seq = connection.Query(sql, param).FirstOrDefault();
                        newSeq = Convert.ToInt32(seq.NEWSEQ);

                        if (success)
                        {
                            break;
                        }

                        // ちょっとだけ待つ
                        Thread.Sleep(1000);
                    }
                }
                catch
                {
                }
                finally
                {
                    // 10回リトライしてもだめな場合は終了(発生しないとは思うが)
                    if (!success)
                    {
                        new Exception("現在他業務にてコメント情報を使用中のため、行番号発番処理は行えませんでした。");
                    }
                }

                param.Add("seq", newSeq);
                param.Add("pubnotedivcd", data.PubNoteDivCd);
                param.Add("dispKbn", data.DispKbn);
                param.Add("upduser", data.UpdUser);
                param.Add("boldflg", data.BoldFlg);
                param.Add("pubnote", data.PubNote.Trim());
                param.Add("dispcolor", data.DispColor);

                sql = @"
                        insert
                        into perpubnote(
                          perid
                          , seq
                          , pubnotedivcd
                          , dispkbn
                          , upddate
                          , upduser
                          , boldflg
                          , pubnote
                          , dispcolor
                        )
                        values (
                          :perid
                          , :seq
                          , :pubnotedivcd
                          , :dispkbn
                          , sysdate
                          , :upduser
                          , :boldflg
                          , :pubnote
                          , :dispcolor
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
        /// 個人コメントを更新する
        /// </summary>
        /// <param name="data">個人コメント情報
        /// perId            個人ＩＤ
        /// seq              ＳＥＱ
        /// pubNoteDivCd     受診情報ノート分類コード
        /// dispKbn       　 表示対象
        /// updUser       　 登録者
        /// boldFlg        　太字区分
        /// pubNote        　ノート
        /// dispColor        表示色
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdatePerPubNote(CommentPubNote data)
        {
            string sql; //SQLステートメント
            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("perid", data.PerId);
            param.Add("seq", data.Seq);
            param.Add("pubnotedivcd", data.PubNoteDivCd);
            param.Add("dispKbn", data.DispKbn);
            param.Add("upduser", data.UpdUser);
            param.Add("boldflg", data.BoldFlg);
            param.Add("pubnote", data.PubNote.Trim());
            param.Add("dispcolor", data.DispColor);

            sql = @"
                    update perpubnote
                    set
                      pubnotedivcd = :pubnotedivcd
                      , dispkbn = :dispkbn
                      , upddate = sysdate
                      , upduser = :upduser
                      , boldflg = :boldflg
                      , pubnote = :pubnote
                      , dispcolor = :dispcolor
                    where
                      perid = :perid
                      and seq = :seq
                ";

            ret2 = connection.Execute(sql, param);

            if (ret2 > 0)
            {
                ret = Insert.Normal;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 団体コメントを新規に登録する
        /// </summary>
        /// <param name="data">受診情報コメント情報
        /// orgCd1 団体コード１
        /// orgCd2 団体コード２
        /// pubNoteDivCd 受診情報ノート分類コード
        /// dispKbn 表示対象
        /// updUser 登録者
        /// boldFlg 太字区分
        /// pubNote ノート
        /// dispColor 表示色
        /// </param>
        /// <param name="newSeq">新しいＳＥＱ</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert InsertOrgPubNote(CommentPubNote data, out int newSeq)
        {
            string sql; //SQLステートメント
            Insert ret = Insert.Error;
            bool success = false;  // 処理成功フラグ
            dynamic seq;
            newSeq = 0;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", data.OrgCd1);
            param.Add("orgcd2", data.OrgCd2);

            while (true)
            {
                sql = @"
                        select
                          nvl(max(seq), 0) + 1 newseq
                        from
                          orgpubnote
                        where
                          orgcd1 = :orgcd1
                          and orgcd2 = :orgcd2
                    ";

                try
                {
                    for (int i = 0; i < 10; i++)
                    {
                        success = true;

                        // 現仮IDの最大値を取得する
                        seq = connection.Query(sql, param).FirstOrDefault();

                        newSeq = Convert.ToInt32(seq.NEWSEQ);

                        if (success)
                        {
                            break;
                        }

                        // ちょっとだけ待つ
                        Thread.Sleep(1000);
                    }
                }
                catch
                {
                }
                finally
                {
                    // 10回リトライしてもだめな場合は終了(発生しないとは思うが)
                    if (!success)
                    {
                        new Exception("現在他業務にてコメント情報を使用中のため、行番号発番処理は行えませんでした。");
                    }
                }

                param.Add("seq", newSeq);
                param.Add("pubnotedivcd", data.PubNoteDivCd);
                param.Add("dispKbn", data.DispKbn);
                param.Add("upduser", data.UpdUser);
                param.Add("boldflg", data.BoldFlg);
                param.Add("pubnote", data.PubNote.Trim());
                param.Add("dispcolor", data.DispColor);

                sql = @"
                        insert
                        into orgpubnote(
                          orgcd1
                          , orgcd2
                          , seq
                          , pubnotedivcd
                          , dispkbn
                          , upddate
                          , upduser
                          , boldflg
                          , pubnote
                          , dispcolor
                        )
                        values (
                          :orgcd1
                          , :orgcd2
                          , :seq
                          , :pubnotedivcd
                          , :dispkbn
                          , sysdate
                          , :upduser
                          , :boldflg
                          , :pubnote
                          , :dispcolor
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
        /// 団体コメントを更新する
        /// </summary>
        /// <param name="data">団体コメント情報
        /// orgCd1           団体コード１
        /// orgCd2           団体コード２
        /// seq              ＳＥＱ
        /// pubNoteDivCd     受診情報ノート分類コード
        /// dispKbn       　 表示対象
        /// updUser       　 登録者
        /// boldFlg        　太字区分
        /// pubNote        　ノート
        /// dispColor        表示色
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateOrgPubNote(CommentPubNote data)
        {
            string sql; //SQLステートメント
            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("orgcd1", data.OrgCd1);
            param.Add("orgcd2", data.OrgCd2);
            param.Add("seq", data.Seq);
            param.Add("pubnotedivcd", data.PubNoteDivCd);
            param.Add("dispKbn", data.DispKbn);
            param.Add("upduser", data.UpdUser);
            param.Add("boldflg", data.BoldFlg);
            param.Add("pubnote", data.PubNote.Trim());
            param.Add("dispcolor", data.DispColor);

            sql = @"
                    update orgpubnote
                    set
                      pubnotedivcd = :pubnotedivcd
                      , dispkbn = :dispkbn
                      , upddate = sysdate
                      , upduser = :upduser
                      , boldflg = :boldflg
                      , pubnote = :pubnote
                      , dispcolor = :dispcolor
                    where
                      orgcd1 = :orgcd1
                      and orgcd2 = :orgcd2
                      and seq = :seq
                ";

            ret2 = connection.Execute(sql, param);

            if (ret2 > 0)
            {
                ret = Insert.Normal;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 契約コメントを新規に登録する
        /// </summary>
        /// <param name="data">契約コメント情報
        /// ctrPtCd 契約パターンコード
        /// pubNoteDivCd 受診情報ノート分類コード
        /// dispKbn 表示対象
        /// updUser 登録者
        /// boldFlg 太字区分
        /// pubNote ノート
        /// dispColor 表示色
        /// </param>
        /// <param name="newSeq">新しいＳＥＱ</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert InsertCtrPtPubNote(CommentPubNote data, out int newSeq)
        {
            string sql; //SQLステートメント
            Insert ret = Insert.Error;
            bool success = false;  // 処理成功フラグ
            dynamic seq;
            newSeq = 0;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", data.CtrPtCd);

            while (true)
            {
                sql = @"
                        select
                          nvl(max(seq), 0) + 1 newseq
                        from
                          ctrptpubnote
                        where
                          ctrptcd = :ctrptcd
                    ";

                try
                {
                    for (int i = 0; i < 10; i++)
                    {
                        success = true;

                        // 現仮IDの最大値を取得する
                        seq = connection.Query(sql, param).FirstOrDefault();
                        newSeq = Convert.ToInt32(seq.NEWSEQ);

                        if (success)
                        {
                            break;
                        }

                        // ちょっとだけ待つ
                        Thread.Sleep(1000);
                    }
                }
                catch
                {
                }
                finally
                {
                    // 10回リトライしてもだめな場合は終了(発生しないとは思うが)
                    if (!success)
                    {
                        new Exception("現在他業務にてコメント情報を使用中のため、行番号発番処理は行えませんでした。");
                    }
                }

                param.Add("seq", newSeq);
                param.Add("pubnotedivcd", data.PubNoteDivCd);
                param.Add("dispKbn", data.DispKbn);
                param.Add("upduser", data.UpdUser);
                param.Add("boldflg", data.BoldFlg);
                param.Add("pubnote", data.PubNote.Trim());
                param.Add("dispcolor", data.DispColor);

                sql = @"
                        insert
                        into ctrptpubnote(
                          ctrptcd
                          , seq
                          , pubnotedivcd
                          , dispkbn
                          , upddate
                          , upduser
                          , boldflg
                          , pubnote
                          , dispcolor
                        )
                        values (
                          :ctrptcd
                          , :seq
                          , :pubnotedivcd
                          , :dispkbn
                          , sysdate
                          , :upduser
                          , :boldflg
                          , :pubnote
                          , :dispcolor
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
        /// 契約コメントを更新する
        /// </summary>
        /// <param name="data">契約コメント情報
        /// ctrPtCd          契約パターンコード
        /// seq              ＳＥＱ
        /// pubNoteDivCd     受診情報ノート分類コード
        /// dispKbn       　 表示対象
        /// updUser       　 登録者
        /// boldFlg        　太字区分
        /// pubNote        　ノート
        /// dispColor        表示色
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert UpdateCtrPtPubNote(CommentPubNote data)
        {
            string sql; //SQLステートメント
            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("ctrptcd", data.CtrPtCd);
            param.Add("seq", data.Seq);
            param.Add("pubnotedivcd", data.PubNoteDivCd);
            param.Add("dispKbn", data.DispKbn);
            param.Add("upduser", data.UpdUser);
            param.Add("boldflg", data.BoldFlg);
            param.Add("pubnote", data.PubNote.Trim());
            param.Add("dispcolor", data.DispColor);

            sql = @"
                    update ctrptpubnote
                    set
                      pubnotedivcd = :pubnotedivcd
                      , dispkbn = :dispkbn
                      , upddate = sysdate
                      , upduser = :upduser
                      , boldflg = :boldflg
                      , pubnote = :pubnote
                      , dispcolor = :dispcolor
                    where
                      ctrptcd = :ctrptcd
                      and seq = :seq
                ";

            ret2 = connection.Execute(sql, param);

            if (ret2 > 0)
            {
                ret = Insert.Normal;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// コメントを削除する
        /// </summary>
        /// <param name="selInfo">検索情報（1:受診情報、2:個人、3:団体、4:契約）</param>
        /// <param name="seq"></param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert DeletePubNote(int selInfo, int seq, int? rsvNo = null, string perId = null, string orgCd1 = null, string orgCd2 = null, string ctrPtCd = null)
        {
            string sql; //SQLステートメント
            Insert ret = Insert.Error;

            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("seq", seq);

            using (var transaction = BeginTransaction())
            {
                switch (selInfo)
                {
                    // 受診情報
                    case 1:
                        if (rsvNo == null || 0 == rsvNo)
                        {
                            // 受診情報コメント削除の呼び出し、または引数が不正です。
                            throw new ArgumentException();
                        }

                        param.Add("rsvno", rsvNo);

                        sql = @"
                                update cslpubnote
                                set
                                  delflg = 1
                                where
                                  rsvno = :rsvno
                                  and seq = :seq
                            ";
                        break;
                    // 個人
                    case 2:
                        if (perId == null || "".Equals(perId))
                        {
                            // 個人コメント削除の呼び出し、または引数が不正です。
                            throw new ArgumentException();
                        }

                        param.Add("perid", perId);

                        sql = @"
                                update perpubnote
                                set
                                  delflg = 1
                                where
                                  perid = :perid
                                  and seq = :seq
                            ";
                        break;
                    // 団体
                    case 3:
                        if ((orgCd1 == null || "".Equals(orgCd1))
                            || (orgCd2 == null || "".Equals(orgCd2)))
                        {
                            // 団体コメント削除の呼び出し、または引数が不正です。
                            throw new ArgumentException();
                        }
                        param.Add("orgcd1", orgCd1);
                        param.Add("orgcd2", orgCd2);
                        sql = @"
                                update orgpubnote
                                set
                                  delflg = 1
                                where
                                  orgcd1 = :orgcd1
                                  and orgcd2 = :orgcd2
                                  and seq = :seq
                            ";
                        break;
                    // 契約
                    case 4:
                        if (ctrPtCd == null || "".Equals(ctrPtCd))
                        {
                            // 契約コメント削除の呼び出し、または引数が不正です。
                            throw new ArgumentException();
                        }
                        param.Add("ctrptcd", ctrPtCd);
                        sql = @"
                                update ctrptpubnote
                                set
                                  delflg = 1
                                where
                                  ctrptcd = :ctrptcd
                                  and seq = :seq
                            ";
                        break;
                    default:
                        // プロシージャの呼び出し、または引数が不正です。
                        throw new ArgumentException();
                }

                ret2 = connection.Execute(sql, param);

                if (ret2 > 0)
                {
                    ret = Insert.Normal;
                }

                if (ret == Insert.Normal)
                {
                    // トランザクションをコミット
                    transaction.Commit();
                }
                else
                {
                    // 異常終了ならRollBack
                    transaction.Rollback();
                }
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// 指定ユーザに対して権限のあるノート分類の一覧を取得する
        /// </summary>
        /// <param name="userId">ユーザＩＤ</param>
        /// <returns>
        /// pubNoteDivCd 受診情報ノート分類コード
        /// pubNoteDivName 受診情報ノート分類名称
        /// defaultDispKbn 表示対象区分初期値
        /// onlyDispKbn 表示対象区分しばり
        /// </returns>
        public List<dynamic> SelectPubNoteDivList(string userId)
        {
            string sql; // SQLステートメント

            var param = new Dictionary<string, object>();
            param.Add("userid", userId.Trim());

            sql = @"
                    select
                      pubnotedivview.pubnotedivcd
                      , pubnotedivview.pubnotedivname
                      , pubnotedivview.defaultdispkbn
                      , pubnotedivview.onlydispkbn
                    from
                      (
                        select
                          pubnotediv.pubnotedivcd
                          , pubnotediv.pubnotedivname
                          , nvl(
                            pubnotediv.defaultdispkbn
                            , userview.defnotedispkbn
                          ) defaultdispkbn
                          , pubnotediv.onlydispkbn
                          , userview.authnote
                          , userview.defnotedispkbn
                        from
                          pubnotediv
                          , (
                            select
                              authnote
                              , nvl(defnotedispkbn, authnote) defnotedispkbn
                            from
                              hainsuser
                            where
                              userid = :userid
                          ) userview
                        where
                          (
                            userview.authnote = 1
                            and (
                              pubnotediv.onlydispkbn = 1
                              or pubnotediv.onlydispkbn is null
                            )
                          )
                          or (
                            userview.authnote = 2
                            and (
                              pubnotediv.onlydispkbn = 2
                              or pubnotediv.onlydispkbn is null
                            )
                          )
                          or (userview.authnote = 3)
                      ) pubnotedivview
                ";

            sql += @"
                    order by
                      pubnotedivview.pubnotedivcd
                 ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// ノート分類の一覧を取得する（マスタメンテナンス用）
        /// </summary>
        /// <returns>
        /// pubNoteDivCd     受診情報ノート分類コード
        /// pubNoteDivName   受診情報ノート分類名称
        /// defaultDispKbn   表示対象区分初期値
        /// onlyDispKbn      表示対象区分しばり
        /// </returns>
        public List<dynamic> SelectAllPubNoteDivList()
        {
            string sql; //SQLステートメント

            sql = @"
                    select
                      pubnotediv.pubnotedivcd
                      , pubnotediv.pubnotedivname
                      , pubnotediv.defaultdispkbn
                      , pubnotediv.onlydispkbn
                    from
                      pubnotediv
                    order by
                      pubnotediv.pubnotedivcd
                ";

            return connection.Query(sql).ToList();
        }

        /// <summary>
        /// ノート分類テーブルレコードを削除する
        /// </summary>
        /// <param name="pubNoteDivCd">ノート分類コード</param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool DeletePubNoteDiv(string pubNoteDivCd)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("pubnotedivcd", pubNoteDivCd.Trim());

            // ノート分類テーブルレコードの削除
            sql = @"
                    delete pubnotediv
                    where
                      pubnotedivcd = :pubnotedivcd
                ";

            connection.Execute(sql, param);

            // 戻り値の設定
            return true;

        }

        /// <summary>
        /// ノート分類テーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">ノート分類テーブル情報
        /// pubNoteDivCd ノート分類コード
        /// pubNoteDivName ノート分類名
        /// defaultDispKbn ノート分類略称
        /// onlyDispKbn 表示対象区分しばり
        /// </param>
        /// <returns>
        /// Insert.Normal 正常終了
        /// Insert.Duplicate 同一キーのレコード存在
        /// Insert.Error 異常終了
        /// </returns>
        public Insert RegistPubNoteDiv(string mode, JToken data)
        {
            string sql;     // SQLステートメント

            Insert ret = Insert.Error;
            int ret2;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("pubnotedivcd", Convert.ToString(data["pubNoteDivCd"]).Trim());
            param.Add("pubnotedivname", Convert.ToString(data["pubNoteDivName"]).Trim());
            param.Add("defaultdispkbn", Convert.ToString(data["defaultDispKbn"]).Trim());
            param.Add("onlydispkbn", Convert.ToString(data["onlyDispKbn"]).Trim());


            while (true)
            {
                // ノート分類テーブルレコードの更新
                if (mode.Equals("UPD"))
                {
                    sql = @"
                            update pubnotediv
                            set
                              pubnotedivname = :pubnotedivname
                              , defaultdispkbn = :defaultdispkbn
                              , onlydispkbn = :onlydispkbn
                            where
                              pubnotedivcd = :pubnotedivcd
                        ";

                    ret2 = connection.Execute(sql, param);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たすノート分類テーブルのレコードを取得
                sql = @"
                        select
                          pubnotedivcd
                        from
                          pubnotediv
                        where
                          pubnotedivcd = :pubnotedivcd
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
                        into pubnotediv(
                          pubnotedivcd
                          , pubnotedivname
                          , defaultdispkbn
                          , onlydispkbn
                        )
                        values (
                          :pubnotedivcd
                          , :pubnotedivname
                          , :defaultdispkbn
                          , :onlydispkbn
                        )
                     ";

                ret2 = connection.Execute(sql, param);

                if (ret2 >= 0)
                {
                    ret = Insert.Normal;
                }

                break;
            }

            // 戻り値の設定
            return ret;
        }

        /// <summary>
        /// ノート分類コードに対するノート分類名を取得する
        /// </summary>
        /// <param name="pubNoteDivCd">ノート分類コード</param>
        /// <returns>
        /// pubNoteDivName   ノート分類名
        /// defaultDispKbn   ノート分類略称
        /// onlyDispKbn      表示用順番
        /// </returns>
        public dynamic SelectPubNoteDiv(string pubNoteDivCd)
        {
            string sql; // SQLステートメント

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("pubnotedivcd", pubNoteDivCd.Trim());

            // 検索条件を満たすノート分類テーブルのレコードを取得
            sql = @"
                    select
                      pubnotedivname
                      , defaultdispkbn
                      , onlydispkbn
                    from
                      pubnotediv
                    where
                      pubnotedivcd = :pubnotedivcd
                ";
            return connection.Query(sql, param).FirstOrDefault();
        }

        #region "新設メソッド"

        /// <summary>
        /// コメント登録入力チェック
        /// </summary>
        /// <param name="data">コメント情報</param>
        /// <returns></returns>
        public IList<string> CheckPubNoteValue(CommentPubNote data)
        {
            IList<string> messages = new List<string>();

            if (string.IsNullOrEmpty(data.PubNote))
            {
                messages.Add("コメントが入力されていません。");
            }
            else if (data.RsvNo == 0 && data.SelInfo == 1)
            {
                messages.Add("予約番号がないため受診情報コメントとしては登録できません。");
            }
            else if (string.IsNullOrEmpty(data.PerId) && data.SelInfo == 2)
            {
                messages.Add("個人ＩＤがないため個人コメントとしては登録できません。");
            }
            else if ((string.IsNullOrEmpty(data.OrgCd1) || string.IsNullOrEmpty(data.OrgCd2)) && data.SelInfo == 3)
            {
                messages.Add("団体コードがないため団体コメントとしては登録できません。");
            }
            else if (string.IsNullOrEmpty(data.CtrPtCd) && data.SelInfo == 4)
            {
                messages.Add("契約パターンコードがないため契約コメントとしては登録できません。");
            }

            string message = WebHains.CheckWideValue("コメント", WebHains.StrConvKanaWide(data.PubNote), 400);
            if (message !=null)
            {
                messages.Add(message + "（改行文字も含みます）");
            }
            return messages;
        }

        #endregion
    }
}
