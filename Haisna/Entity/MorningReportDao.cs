using Dapper;
using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 朝レポート用データアクセスオブジェクト
    /// </summary>
    public class MorningReportDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public MorningReportDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 指定日の時間帯別受診者情報を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="needUnReceipt">未受付者取得フラグ</param>
        /// <returns>
        /// csCd コースコード
        /// needUnReceipt 未受付者取得フラグ
        /// rsvGrpName 予約群名称
        /// maleCount 男性人数
        /// femaleCount 女性人数
        /// </returns>
        public List<dynamic> SelectRsvFraDaily(string cslDate, string csCd = "", bool needUnReceipt = false)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();

            if (!Information.IsDate(cslDate))
            {
                cslDate = DateTime.Now.ToString("yyyy/MM/dd");
            }
            param.Add("csldate", cslDate);
            param.Add("cscd", csCd.Trim());

            // 時間帯別受診者情報を取得
            sql = @"
                    select
                      ( 
                        select
                          rsvgrpname 
                        from
                          rsvgrp 
                        where
                          rsvgrpcd = consultlist.rsvgrpcd
                      ) rsvgrpname
                      , max(consultlist.malecount) malecount
                      , max(consultlist.femalecount) femalecount
                ";
            sql += @"
                    from
                      ( 
                        select
                          rsvgrpcd
                          , decode(gender, 1, count(*), 0) malecount
                          , decode(gender, 2, count(*), 0) femalecount 
                        from
                          ( 
                            select
                              rsvgrp.rsvgrpcd
                              , person.gender
                              , nvl(receipt.dayid, 0) checkdayid 
                            from
                              rsvgrp
                              , person
                              , receipt
                              , consult 
                            where
                              consult.csldate = :csldate
                 ";

            // コースコードの指定あり
            if (!"".Equals(csCd))
            {
                sql += @"
                        and consult.cscd = :cscd
                     ";
            }

            sql += @"
                    and consult.cancelflg = '0' 
                    and consult.perid = person.perid 
                    and consult.rsvgrpcd = rsvgrp.rsvgrpcd 
                    and consult.csldate = receipt.csldate(+) 
                    and consult.rsvno = receipt.rsvno(+)
                 )";

            // 未受付者を除く
            if (!needUnReceipt)
            {
                sql += @"
                        where
                          checkdayid > 0
                     ";
            }

            sql += @"
                    group by
                      rsvgrpcd
                      , gender
                 ";

            // 予約群テーブルをもとに空の時間帯別受診者情報を作成し、結合
            sql += @"
                    union all 
                    select
                      rsvgrp.rsvgrpcd
                      , 0 malecount
                      , 0 femalecount 
                    from
                      rsvgrp) consultlist
                 ";

            sql += @"
                    group by
                      rsvgrpcd 
                    order by
                      rsvgrpcd
                 ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定日の同伴者（お連れ様）受診者情報を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="needUnReceipt">未受付者取得フラグ</param>>
        /// <returns>
        /// csCd コースコード
        /// needUnReceipt 未受付者取得フラグ
        /// rsvNo 予約番号
        /// perId 個人ＩＤ
        /// compFlag 同伴者フラグ（1:同伴者, 2:お連れ様）
        /// compRsvNo 予約番号（同伴者またはお連れ様）
        /// compPerId 個人ＩＤ（同伴者またはお連れ様）
        /// </returns>
        public List<dynamic> SelectFriendsDaily(DateTime cslDate, string csCd = "", bool needUnReceipt = false)
        {
            string sql; // SQLステートメント
            string sql2 = "";

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);
            param.Add("cscd", csCd.Trim());

            // 同伴者（お連れ様）受診者情報を取得
            sql = @"
                    select
                      friendlist1.rsvno rsvno
                      , friendlist1.dayid dayid
                      , friendlist1.perid perid
                      , friendlist1.lastname lastname
                      , friendlist1.firstname firstname
                      , nvl2( 
                        friendlist1.compperid
                        , decode( 
                          friendlist1.compperid
                          , nvl(friendlist2.perid, 0)
                          , '1'
                          , '2'
                        ) 
                        , '2'
                      ) compflag
                      , friendlist2.rsvno comprsvno
                      , friendlist2.dayid compdayid
                      , friendlist2.perid compperid
                      , friendlist2.lastname complastname
                      , friendlist2.firstname compfirstname 
                    from
                ";
            // お連れ様を取得 ****************************************************Start
            sql2 = @"
                    select
                      friends.csldate
                      , friends.seq
                      , friends.rsvno
                      , receipt.dayid
                      , person.perid
                      , person.lastname
                      , person.firstname
                      , person.compperid 
                    from
                      friends
                      , consult
                      , receipt
                      , person 
                    where
                      friends.csldate = :csldate 
                      and friends.rsvno = consult.rsvno 
                      and consult.cancelflg = '0' 
                      and consult.csldate = receipt.csldate(+) 
                      and consult.rsvno = receipt.rsvno(+) 
                      and consult.perid = person.perid
                ";

            // コースコードの指定あり
            if (!"".Equals(csCd))
            {
                sql2 += @"
                        and consult.cscd = :cscd
                     ";
            }

            // 未受付者を除く
            if (!needUnReceipt)
            {
                sql2 += @"
                        and receipt.dayid is not null
                     ";
            }
            // お連れ様を取得**************************************************** End

            sql += String.Format(@"
                    ({0}
                 ", sql2);

            sql += String.Format(@"
                    ) friendlist1
                    , ({0}
                 ", sql2);

            sql += @"
                    ) friendlist2
                 ";

            // 同伴者情報
            sql += @"
                    where
                      friendlist1.csldate = friendlist2.csldate 
                      and friendlist1.seq = friendlist2.seq 
                      and friendlist1.rsvno <> friendlist2.rsvno
                 ";

            sql += @"
                    order by
                      dayid nulls last
                      , compflag
                      , compdayid nulls last
                      , perid
                      , compperid
                 ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定日の同姓受診者情報を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="needUnReceipt">未受付者取得フラグ</param>
        /// <returns>
        /// csCd コースコード
        /// needUnReceipt 未受付者取得フラグ
        /// dayID 当日ＩＤ
        /// perId 個人ＩＤ
        /// lastName 姓
        /// firstName 名
        /// </returns>
        public List<dynamic> SelectSameNameDaily(DateTime cslDate, string csCd = "", bool needUnReceipt = false)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);
            param.Add("cscd", csCd.Trim());

            // 同姓受診者情報を取得
            sql = @"
                    select
                      per1.perid perid
                      , per1.dayid dayid
                      , per1.lastname lastname
                      , per1.firstname firstname 
                    from
                ";

            sql += @"
                    ( 
                      select
                        perid
                        , dayid
                        , lastname
                        , firstname
                        , lastkname
                        , firstkname 
                      from
                        ( 
                          select
                            consult.perid
                            , receipt.dayid
                            , person.lastname
                            , person.firstname
                            , person.lastkname
                            , person.firstkname
                            , nvl(receipt.dayid, 0) checkdayid 
                          from
                            person
                            , receipt
                            , consult 
                          where
                            consult.csldate = :csldate
                 ";

            // コースコードの指定あり
            if (!"".Equals(csCd))
            {
                sql += @"
                        and consult.cscd = :cscd
                     ";
            }

            sql += @"
                    and consult.cancelflg = '0' 
                    and consult.perid = person.perid 
                    and consult.csldate = receipt.csldate(+) 
                    and consult.rsvno = receipt.rsvno(+)
                    )
                 ";

            // 未受付者を除く
            if (!needUnReceipt)
            {
                sql += @"
                        where
                          checkdayid > 0
                     ";
            }

            sql += @"
                    ) PER1
                 ";
            // 同姓のチェック
            sql += @"
                    where
                      exists ( 
                        select
                          consult.perid 
                        from
                          person
                          , receipt
                          , consult 
                        where
                          consult.csldate = :csldate
                 ";

            // コースコードの指定あり
            if (!"".Equals(csCd))
            {
                sql += @"
                        and consult.cscd = :cscd
                     ";
            }

            sql += @"
                    and consult.cancelflg = '0' 
                    and consult.perid = person.perid 
                    and consult.csldate = receipt.csldate(+) 
                    and consult.rsvno = receipt.rsvno(+) 
                    and person.perid <> per1.perid 
                    and person.lastkname = per1.lastkname 
                    and person.firstkname = per1.firstkname)
                 ";

            // ソート順（名前順）の指定
            sql += @"
                    order by
                      per1.lastkname
                      , per1.firstkname
                      , per1.dayid nulls last
                      , per1.perid
                 ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定日のセット別受診者情報を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="needUnReceipt">未受付者取得フラグ</param>
        /// <returns>
        /// csCd コースコード
        /// needUnReceipt 未受付者取得フラグ
        /// setName セット名
        /// maleCount 男性人数
        /// femaleCount 女性人数
        /// </returns>
        public List<dynamic> SelectSetCountDaily(DateTime cslDate, string csCd = "", bool needUnReceipt = false)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);
            param.Add("cscd", csCd.Trim());

            // セット別受診者情報を取得
            sql = @"
                    select
                      setname
                      , max(malecount) malecount
                      , max(femalecount) femalecount
                ";

            sql += @"
                    from
                      ( 
                        select
                          sortkey
                          , setname
                          , decode(gender, 1, count(*), 0) malecount
                          , decode(gender, 2, count(*), 0) femalecount 
                        from
                          (
                 ";

            sql += @"
                    select distinct
                      setgrp.sortkey
                      , setgrp.setname
                      , consultview.perid
                      , consultview.gender 
                    from
                      ( 
                        select
                          person.perid
                          , person.gender
                          , consultitemlist.itemcd
                          , nvl(receipt.dayid, 0) checkdayid 
                        from
                          person
                          , receipt
                          , consultitemlist 
                        where
                          consultitemlist.csldate = :csldate
                 ";

            // コースコードの指定あり
            if (!"".Equals(csCd))
            {
                sql += @"
                        and consultitemlist.cscd = :cscd
                     ";
            }

            sql += @"
                    and consultitemlist.cancelflg = '0' 
                    and consultitemlist.perid = person.perid 
                    and consultitemlist.csldate = receipt.csldate(+) 
                    and consultitemlist.rsvno = receipt.rsvno(+)) consultview
                    , 
                 ";

            sql += @"
                    ( 
                      select
                        free.freefield1 sortkey
                        , free.freefield2 setname
                        , grp_r.itemcd 
                      from
                        grp_r
                        , free 
                      where
                        free.freecd like 'MORSETGRP%' 
                        and free.freefield3 = grp_r.grpcd
                    ) setgrp 
                    where
                      consultview.itemcd = setgrp.itemcd
                 ";

            // 未受付者を除く
            if (!needUnReceipt)
            {
                sql += @"
                        and consultview.checkdayid > 0
                     ";
            }

            sql += @")
                    group by
                      sortkey
                      , setname
                      , gender
                 ";
            // 空のセット別受診者情報を作成し、結合
            sql += @"
                    union all 
                    select
                      free.freefield1 sortkey
                      , free.freefield2 setname
                      , 0 malecount
                      , 0 femalecount 
                    from
                      free 
                    where
                      free.freecd like 'MORSETGRP%')
                 ";

            sql += @"
                    group by
                      sortkey
                      , setname 
                    order by
                      sortkey
                      , setname
                 ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定日のコメント情報を取得する
        /// </summary>
        /// <param name="cslDate">受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="pubNoteDivCd">受診情報ノート分類コード</param>
        /// <param name="dispKbn">表示対象</param>
        /// <param name="userId">ユーザＩＤ</param>
        /// <param name="needUnReceipt">未受付者取得フラグ</param>
        /// <returns>
        /// rsvNo 予約番号
        /// sortNo 表示順（1:個人、2:受診情報）
        /// seq SEQ
        /// pubNoteDivCd 受診情報ノート分類コード
        /// pubNoteDivName 受診情報ノート分類名称
        /// defaultDispKbn 表示対象区分初期値
        /// onlyDispKbn 表示対象区分しばり
        /// dispKbn 表示対象区分
        /// updDate 登録日時
        /// updUser 登録者
        /// userName 登録者名
        /// boldFlg 太字区分
        /// pubNote ノート
        /// dispColor 表示色
        /// cslDate 受診日
        /// csName コース名
        /// dayID 当日ＩＤ
        /// lastName 姓
        /// firstName 名
        /// </returns>
        public List<dynamic> SelectPubNoteDaily(DateTime cslDate, string csCd, string userId, string pubNoteDivCd, int dispKbn, bool needUnReceipt = false)
        {
            string sql; // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("csldate", cslDate);
            if (csCd == null)
            {
                csCd = "";
            }
            param.Add("cscd", csCd.Trim());
            param.Add("userid", userId.Trim());

            // ノートを一括取得
            sql = @"
                    select
                      pubnote.rsvno
                      , pubnote.sortno
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
                      , receipt.dayid
                      , course_p.csname
                      , person.lastname
                      , person.firstname 
                    from
                      hainsuser
                      , receipt
                      , course_p
                      , person
                      , (
                ";
            // 個人ノートを取得
            sql += @"
                    select
                      1 sortno
                      , consult.rsvno
                      , consult.perid
                      , consult.csldate
                      , consult.cscd
                      , perpubnote.seq
                      , perpubnote.pubnotedivcd
                      , perpubnote.dispkbn
                      , perpubnote.upddate
                      , perpubnote.upduser
                      , perpubnote.boldflg
                      , perpubnote.pubnote
                      , perpubnote.dispcolor
                 ";

            sql += @"
                    from
                      consult
                      , perpubnote
                 ";

            sql += @"
                    where
                      consult.csldate = :csldate 
                      and consult.perid = perpubnote.perid 
                      and perpubnote.delflg is null
                 ";
            sql += @"
                    union all
                 ";
            // 受診情報ノートを取得
            sql += @"
                    select
                      2 sortno
                      , consult.rsvno
                      , consult.perid
                      , consult.csldate
                      , consult.cscd
                      , cslpubnote.seq
                      , cslpubnote.pubnotedivcd
                      , cslpubnote.dispkbn
                      , cslpubnote.upddate
                      , cslpubnote.upduser
                      , cslpubnote.boldflg
                      , cslpubnote.pubnote
                      , cslpubnote.dispcolor
                 ";

            sql += @"
                    from
                      consult
                      , cslpubnote
                 ";

            sql += @"
                    where
                      consult.csldate = :csldate 
                      and consult.rsvno = cslpubnote.rsvno 
                      and cslpubnote.delflg is null
                 ";

            sql += @"
                    ) pubnote
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
                      and pubnote.csldate = receipt.csldate(+) 
                      and pubnote.rsvno = receipt.rsvno(+) 
                      and pubnote.cscd = course_p.cscd(+) 
                      and pubnote.perid = person.perid
                 ";

            // コースコードの指定あり
            if (!"".Equals(csCd))
            {
                sql += @"
                        and pubnote.cscd = :cscd
                     ";
            }

            // 未受付者を除く
            if (!needUnReceipt)
            {
                sql += @"
                        and receipt.dayid is not null
                     ";
            }

            // 受診情報ノート分類コード指定あり？
            if (!"".Equals(pubNoteDivCd))
            {
                param.Add("pubnotediv", pubNoteDivCd);
                sql += @"
                        and pubnote.pubnotedivcd = :pubnotediv
                     ";
            }

            // 表示対象指定あり？
            if (0 != Convert.ToInt32(dispKbn))
            {
                param.Add("dispkbn", dispKbn);
                sql += @"
                        and ( 
                          pubnote.dispkbn = :dispkbn 
                          or pubnote.dispkbn = 3
                        ) 
                     ";
            }
            sql += @"
                    order by
                      receipt.dayid nulls last
                      , person.perid
                      , pubnote.sortno
                      , pubnote.seq
                 ";

            return connection.Query(sql, param).ToList();
        }
    }
}