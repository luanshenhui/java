using Dapper;
using Hainsi.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// フォローアップ情報データアクセスオブジェクト
    /// </summary>
    public class FollowDao : AbstractDao
    {
        const string KYOUBU_GRPCD = "X881"; // 胸部・甲状腺関連検査項目グループコード
        const string HUKUBU_GRPCD = "X882"; // 腹部関連検査項目グループコード
        const string SYOUKA_GRPCD = "X883"; // 消化管関連検査項目グループコード
        const string FUJIN_GRPCD = "X884";  // 婦人科関連検査項目グループコード

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public FollowDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// フォロー対象検査項目を取得する
        /// </summary>
        /// <returns>フォロー対象検査項目のリスト</returns>
        public IList<dynamic> SelectFollowItem()
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("foljudclcd", "FOLJUDCL%");

            var sql = @"
                select
                    free.freefield1 as itemcd
                    , free.freefield3 as itemname
                from
                    free
                where
                    free.freecd like :foljudclcd
                order by
                    to_number(free.freefield2)
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定予約番号の直前のフォロー情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>フォロー情報</returns>
        /// <remarks>前回は1日人間ドック Or 企業健診</remarks>
        public dynamic SelectFollow_Before(int rsvNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("freecd", "CSC01%");

            // 指定予約番号のフォロー情報を取得する
            var sql = @"
                select
                    follow_info.rsvno
                    , lastconsult.csldate
                    , lastconsult.cscd
                from
                    follow_info
                    , (
                        select
                            rsvno
                            , csldate
                            , cscd
                        from
                            (
                                select
                                    b.rsvno rsvno
                                    , b.csldate csldate
                                    , b.cscd cscd
                                from
                                    consult a
                                    , consult b
                                where
                                    a.rsvno = :rsvno
                                    and a.perid = b.perid
                                    and a.csldate > b.csldate
                                    and b.cscd in (
                                        select
                                            freefield1
                                        from
                                            free
                                        where
                                            freecd like :freecd
                                    )
                                order by
                                    b.csldate desc
                            )
                        where
                            rownum = 1
                    ) lastconsult
                where
                    follow_info.rsvno = lastconsult.rsvno
                ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 指定個人IDのフォロー情報の受診歴一覧を取得する
        /// </summary>
        /// <param name="perId">個人ID</param>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>受診歴リスト</returns>
        public IList<dynamic> SelectFollowHistory(string perId, int rsvNo)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("perid", perId);

            // 指定予約番号のフォロー情報を取得する
            var sql = @"
                select distinct
                    history.rsvno
                    , history.csldate
                from
                    (
                        select
                            consult.csldate
                            , consult.rsvno
                        from
                            consult
                            , receipt
                            , follow_info
                        where
                            consult.perid = :perid
                            and consult.csldate <= (
                                select
                                    csldate
                                from
                                    consult
                                where
                                    rsvno = :rsvno
                            )
                            and consult.cancelflg = 0
                            and consult.rsvno = receipt.rsvno
                            and receipt.comedate is not null
                            and consult.rsvno = follow_info.rsvno
                        union
                        select
                            consult.csldate
                            , consult.rsvno
                        from
                            consult
                        where
                            consult.rsvno = :rsvno
                            and consult.cancelflg = 0
                    ) history
                order by
                    history.csldate desc
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定予約番号のフォロー状況管理情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <returns>フォロー状況管理情報</returns>
        public dynamic SelectFollow_Info(int rsvNo, int judClassCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("judclasscd", judClassCd);

            // 指定予約番号と検査項目（判定分類）のフォロー情報を取得する
            var sql = @"
                select
                    follow_info.secequipdiv
                    , follow_info.adddate
                    , follow_info.adduser
                    , follow_info.upddate
                    , follow_info.upduser
                    , follow_info.judcd
                    , follow_info.statuscd
                    , follow_info.secequipname
                    , follow_info.secequipcourse
                    , follow_info.secdoctor
                    , follow_info.secequipaddr
                    , follow_info.secequiptel
                    , follow_info.secplandate
                    , follow_info.reqsenddate
                    , follow_info.reqsenduser
                    , follow_info.reqcheckdate1
                    , follow_info.reqcheckdate2
                    , follow_info.reqcheckdate3
                    , follow_info.reqcanceldate
                    , follow_info.reqconfirmdate
                    , follow_info.reqconfirmuser
                    , follow_info.secremark
                    , follow_info.rsvtestus
                    , follow_info.rsvtestct
                    , follow_info.rsvtestmri
                    , follow_info.rsvtestbf
                    , follow_info.rsvtestgf
                    , follow_info.rsvtestcf
                    , follow_info.rsvtestem
                    , follow_info.rsvtesttm
                    , follow_info.rsvtestetc
                    , follow_info.rsvtestremark
                    , follow_info.rsvtestrefer
                    , follow_info.rsvtestrefertext
                    , fol_get_secrsvexam(follow_info.rsvno, follow_info.judclasscd) as rsvtestname
                    , hainsuser.username
                    , judrsl.judcd rsljudcd
                    , follow_info.judclasscd
                    , judclass.judclassname
                    , (
                        select
                            huser.username
                        from
                            hainsuser huser
                        where
                            huser.userid = follow_info.reqconfirmuser
                    ) as reqconfirmusername
                    , (
                        select
                            huser2.username
                        from
                            hainsuser huser2
                        where
                            huser2.userid = follow_info.reqsenduser
                    ) as reqsendusername
                    , (
                        select
                            huser3.username
                        from
                            hainsuser huser3
                        where
                            huser3.userid = follow_info.adduser
                    ) as addusername
                from
                    follow_info
                    , judrsl
                    , hainsuser
                    , judclass
                where
                    follow_info.rsvno = :rsvno
            ";

            if (judClassCd != 999)
            {
                sql += @"
                    and follow_info.judclasscd = :judclasscd
                ";
            }

            sql += @"
                    and follow_info.rsvno = judrsl.rsvno(+)
                    and follow_info.judclasscd = judrsl.judclasscd(+)
                    and follow_info.upduser = hainsuser.userid(+)
                    and follow_info.judclasscd = judclass.judclasscd(+)
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// フォローアップ結果情報を取得する（受診者・判定分類別特定結果情報）
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="seq">一連番号</param>
        /// <returns>フォローアップ結果情報</returns>
        public dynamic SelectFollow_Rsl(int rsvNo, int judClassCd, int seq)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("judclasscd", judClassCd);
            param.Add("seq", seq);
            param.Add("itemcd", "");
            param.Add("suffix", "");
            param.Add("result", "");

            // 指定予約番号と検査項目（判定分類）のフォロー情報を取得する
            var sql = @"
                select
                    follow_rsl.seccsldate
                    , follow_rsl.upddate
                    , follow_rsl.upduser
                    , follow_rsl.testus
                    , follow_rsl.testct
                    , follow_rsl.testmri
                    , follow_rsl.testbf
                    , follow_rsl.testgf
                    , follow_rsl.testcf
                    , follow_rsl.testem
                    , follow_rsl.testtm
                    , follow_rsl.testetc
                    , follow_rsl.testremark
                    , follow_rsl.testrefer
                    , follow_rsl.testrefertext
                    , follow_rsl.resultdiv
                    , follow_rsl.disremark
                    , follow_rsl.polwithout
                    , follow_rsl.polfollowup
                    , follow_rsl.polmonth
                    , follow_rsl.polreexam
                    , follow_rsl.poldiagst
                    , follow_rsl.poldiag
                    , follow_rsl.poletc1
                    , follow_rsl.polremark1
                    , follow_rsl.polsugery
                    , follow_rsl.polendoscope
                    , follow_rsl.polchemical
                    , follow_rsl.polradiation
                    , follow_rsl.polreferst
                    , follow_rsl.polrefer
                    , follow_rsl.poletc2
                    , follow_rsl.polremark2
                    , hainsuser.username
                from
                    follow_rsl
                    , hainsuser
                where
                    follow_rsl.rsvno = :rsvno
                    and follow_rsl.judclasscd = :judclasscd
                    and follow_rsl.seq = :seq
                    and follow_rsl.upduser = hainsuser.userid
            ";

            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 結果情報の診断名を取得（すべての臓器（検査項目）情報を基に結果を取得）
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <returns>結果情報のリスト</returns>
        public IList<dynamic> SelectFollowRslList(int rsvNo, int judClassCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("judclasscd", judClassCd);

            // 指定検索条件の二次検査結果情報リストを取得する
            var sql = @"
                select
                    follow_rsl.rsvno
                    , follow_rsl.judclasscd
                    , follow_rsl.seq
                    , follow_rsl.seccsldate
                    , follow_rsl.upddate
                    , follow_rsl.upduser
                    , follow_rsl.testus
                    , follow_rsl.testct
                    , follow_rsl.testmri
                    , follow_rsl.testbf
                    , follow_rsl.testgf
                    , follow_rsl.testcf
                    , follow_rsl.testem
                    , follow_rsl.testtm
                    , follow_rsl.testrefer
                    , follow_rsl.testrefertext
                    , follow_rsl.testetc
                    , follow_rsl.testremark
                    , follow_rsl.resultdiv
                    , follow_rsl.disremark
                    , follow_rsl.polwithout
                    , follow_rsl.polfollowup
                    , follow_rsl.polmonth
                    , follow_rsl.polreexam
                    , follow_rsl.poldiagst
                    , follow_rsl.poldiag
                    , follow_rsl.poletc1
                    , follow_rsl.polremark1
                    , follow_rsl.polsugery
                    , follow_rsl.polendoscope
                    , follow_rsl.polchemical
                    , follow_rsl.polradiation
                    , follow_rsl.polreferst
                    , follow_rsl.polrefer
                    , follow_rsl.poletc2
                    , follow_rsl.polremark2
                    , hainsuser.username
                from
                    follow_rsl
                    , hainsuser
                where
                    follow_rsl.rsvno = :rsvno
                    and follow_rsl.judclasscd = :judclasscd
                    and follow_rsl.upduser = hainsuser.userid
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 結果情報の診断名を取得（すべての臓器（検査項目）情報を基に結果を取得或いは登録されている情報のみ取得）
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="seq">一連番号</param>
        /// <param name="rslFlg">結果抽出区分</param>
        /// <returns>結果情報リスト</returns>
        public IList<dynamic> SelectFollowRslItemList(int rsvNo, int judClassCd, int seq, bool rslFlg = false)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("judclasscd", judClassCd);
            param.Add("seq", seq);
            param.Add("kyoubu", KYOUBU_GRPCD);
            param.Add("hukubu", HUKUBU_GRPCD);
            param.Add("syouka", SYOUKA_GRPCD);
            param.Add("fujin", FUJIN_GRPCD);

            // 指定検索条件の臓器ごとの疾患リストを取得する
            var sql = @"
                select
                    lastview.grpname
                    , lastview.itemcd as itemcd
                    , lastview.suffix as suffix
                    , lastview.itemname as itemname
                    , lastview.result as result
                    , nvl(sentence.shortstc, lastview.result) as shortstc
                from
                    (
                        select
                            grp_i.grpcd
                            , grp_p.grpname
                            , item_c.itemcd
                            , item_c.suffix
                            , item_c.itemtype
                            , item_c.itemname
                            , item_c.stcitemcd
                            , follow_i.result
                        from
                            grp_i
                            , grp_p
                            , item_c
                            , (
                                select
                                    follow_rsl_i.itemcd
                                    , follow_rsl_i.suffix
                                    , follow_rsl_i.result
                                from
                                    follow_rsl_i
                                where
                                    follow_rsl_i.rsvno = :rsvno
                                    and follow_rsl_i.judclasscd = :judclasscd
                                    and follow_rsl_i.seq = :seq
                            ) follow_i
                        where
                            grp_i.grpcd in (:kyoubu, :hukubu, :syouka, :fujin)
                            and grp_i.itemcd = item_c.itemcd
                            and grp_i.suffix = item_c.suffix
            ";

            // 結果抽出区分がtrueの場合は登録されている結果のみ取得し、falseの場合は対象全項目を取得
            if (rslFlg)
            {
                sql += @"
                            and item_c.itemcd = follow_i.itemcd
                            and item_c.suffix = follow_i.suffix
                ";
            }
            else
            {
                sql += @"
                            and item_c.itemcd = follow_i.itemcd(+)
                            and item_c.suffix = follow_i.suffix(+)
                ";
            }

            sql += @"
                            and grp_i.grpcd = grp_p.grpcd
                    ) lastview
                    , sentence
                where
                    lastview.stcitemcd = sentence.itemcd(+)
                    and lastview.itemtype = sentence.itemtype(+)
                    and lastview.result = sentence.stccd(+)
                order by
                    lastview.grpcd
                    , lastview.itemcd
                    , lastview.result
            ";

            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定予約番号の基準値以上判定情報（フォロー対象情報）を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judFlg">結果抽出区分</param>
        /// <returns>フォロー対象情報のリスト</returns>
        public IList<dynamic> SelectTargetFollow(int rsvNo, bool judFlg = false)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("foljudclcd", "FOLJUDCL%");
            param.Add("foljudcd", "FOLJUD00%");

            // 指定予約番号のフォロー情報を取得する
            var sql = @"
                select
                    rownum seq
                    , lastview.csldate as csldate
                    , lastview.dayid as dayid
                    , person.lastkname || '　' || person.firstkname as perkname
                    , person.lastname || '　' || person.firstname as pername
                    , trunc(lastview.age) as age
                    , decode(person.gender, 1, '男', 2, '女') as gender
                    , to_char(
                        person.birth
                        , 'EYY.mm.dd'
                        , 'NLS_CALENDAR=''Japanese Imperial'''
                    ) as birth
                    , lastview.rsvno as rsvno
                    , lastview.perid as perid
                    , lastview.judclasscd as judclasscd
                    , judclass.judclassname as judclassname
                    , judclass.resultdispmode as resultdispmode
                    , lastview.judcd as judcd
                    , (
                        select
                            judrsl.judcd
                        from
                            judrsl
                        where
                            judrsl.rsvno = lastview.rsvno
                            and judrsl.judclasscd = lastview.judclasscd
                    ) as rsljudcd
                    , lastview.cscd as cscd
                    , nvl(lastview.equipdiv, '') as equipdiv
                    , nvl(lastview.statuscd, '') as statuscd
                    , nvl(lastview.reqconfirmdate, '') as reqconfirmdate
                    , (
                        select
                            username
                        from
                            hainsuser
                        where
                            hainsuser.userid = lastview.reqconfirmuser
                    ) as reqconfirmuser
                    , lastview.prtseq as prtseq
                    , nvl(follow_prt_h.filename, '') as filename
                    , decode(
                        follow_prt_h.adddate
                        , null
                        , ''
                        , to_char(follow_prt_h.adddate, 'YYYY/MM/DD HH24:MI')
                    ) as prtdate
                    , (
                        select
                            username
                        from
                            hainsuser
                        where
                            hainsuser.userid = follow_prt_h.adduser
                    ) as prtuser
                    , decode(
                        fc_get_result(lastview.rsvno, '30910', '00')
                        , null
                        , '-'
                        , ''
                        , '-'
                        , fc_get_result(lastview.rsvno, '30910', '00')
                    ) as doc_jud
                    , decode(
                        fc_get_result(lastview.rsvno, '23320', '00')
                        , null
                        , '-'
                        , ''
                        , '-'
                        , fc_get_result(lastview.rsvno, '23320', '00')
                    ) as doc_gf
                    , decode(
                        fc_get_result(lastview.rsvno, '23550', '00')
                        , null
                        , '-'
                        , ''
                        , '-'
                        , fc_get_result(lastview.rsvno, '23550', '00')
                    ) as doc_cf
                    , (
                        select
                            username
                        from
                            hainsuser
                        where
                            hainsuser.userid = lastview.adduser
                    ) as adduser
                    , (
                        select
                            username
                        from
                            hainsuser
                        where
                            hainsuser.userid = lastview.upduser
                    ) as upduser
                    , decode(
                        fc_get_result(lastview.rsvno, '30980', '00')
                        , null
                        , '-'
                        , ''
                        , '-'
                        , fc_get_result(lastview.rsvno, '30980', '00')
                    ) as doc_gyne
                    , decode(
                        fc_get_result(lastview.rsvno, '30981', '00')
                        , null
                        , '-'
                        , ''
                        , '-'
                        , fc_get_result(lastview.rsvno, '30981', '00')
                    ) as doc_gynejud
                from
                    (
                        (
                            (
                                select
                                    consult.csldate as csldate
                                    , receipt.dayid as dayid
                                    , consult.rsvno as rsvno
                                    , consult.perid as perid
                                    , consult.age as age
                                    , consult.cscd as cscd
                                    , judrsl.judclasscd as judclasscd
                                    , null as judcd
                                    , null as equipdiv
                                    , null as prtseq
                                    , null as statuscd
                                    , null as reqconfirmdate
                                    , null as reqconfirmuser
                                    , null as adduser
                                    , null as upduser
                                from
                                    consult
                                    , receipt
                                    , judrsl
                                where
                                    consult.rsvno = :rsvno
                                    and consult.cancelflg = 0
                                    and consult.rsvno = receipt.rsvno
                                    and receipt.comedate is not null
                                    and consult.rsvno = judrsl.rsvno
                                    and judrsl.judclasscd in (
                                        select
                                            free.freefield1
                                        from
                                            free
                                        where
                                            free.freecd like :foljudclcd
                                    )
                                    and judrsl.judcd in (
                                        select
                                            free1.freefield1 judcd
                                        from
                                            free
                                            , free free1
                                        where
                                            free.freecd like :foljudclcd
                                            and free.freefield1 = judrsl.judclasscd
                                            and free.freeclasscd = free1.freeclasscd
                                            and free1.freecd like :foljudcd
                                    )
                ";


            // 表示区分がtrueの場合は判定結果が登録されていない検査項目も強制的に表示
            if (judFlg)
            {
                sql += @"
                                union
                                select
                                    consult.csldate as csldate
                                    , receipt.dayid as dayid
                                    , consult.rsvno as rsvno
                                    , consult.perid as perid
                                    , consult.age as age
                                    , consult.cscd as cscd
                                    , judview.judclasscd as judclasscd
                                    , null as judcd
                                    , null as equipdiv
                                    , null as prtseq
                                    , null as statuscd
                                    , null as reqconfirmdate
                                    , null as reqconfirmuser
                                    , null as adduser
                                    , null as upduser
                                from
                                    consult
                                    , receipt
                                    , (
                                        select
                                            rsl.rsvno as rsvno
                                            , item_jud.judclasscd as judclasscd
                                        from
                                            rsl
                                            , item_jud
                                        where
                                            rsl.rsvno = :rsvno
                                            and rsl.stopflg is null
                                            and rsl.itemcd = item_jud.itemcd
                                            and item_jud.judclasscd in (
                                                select
                                                    free.freefield1
                                                from
                                                    free
                                                where
                                                    free.freecd like :foljudclcd
                                            )
                                        group by
                                            rsl.rsvno
                                            , item_jud.judclasscd
                                    ) judview
                                    , judrsl
                                where
                                    consult.rsvno = :rsvno
                                    and consult.cancelflg = 0
                                    and consult.rsvno = receipt.rsvno
                                    and receipt.comedate is not null
                                    and consult.rsvno = judview.rsvno
                                    and judview.rsvno = judrsl.rsvno(+)
                                    and judview.judclasscd = judrsl.judclasscd(+)
                                    and judrsl.judcd is null
                ";
            }

            sql += @"
                            )
                            minus
                            select
                                consult.csldate as csldate
                                , receipt.dayid as dayid
                                , consult.rsvno as rsvno
                                , consult.perid as perid
                                , consult.age as age
                                , consult.cscd as cscd
                                , follow_info.judclasscd as judclasscd
                                , null as judcd
                                , null as equipdiv
                                , null as prtseq
                                , null as statuscd
                                , null as reqconfirmdate
                                , null as reqconfirmuser
                                , null as adduser
                                , null as upduser
                            from
                                consult
                                , receipt
                                , follow_info
                            where
                                consult.rsvno = :rsvno
                                and consult.cancelflg = 0
                                and consult.rsvno = receipt.rsvno
                                and receipt.comedate is not null
                                and consult.rsvno = follow_info.rsvno
                        )
                        union
                        select
                            consult.csldate as csldate
                            , receipt.dayid as dayid
                            , consult.rsvno as rsvno
                            , consult.perid as perid
                            , consult.age as age
                            , consult.cscd as cscd
                            , follow_info.judclasscd as judclasscd
                            , follow_info.judcd as judcd
                            , follow_info.secequipdiv as equipdiv
                            , (
                                select
                                    max(seq)
                                from
                                    follow_prt_h
                                where
                                    rsvno = follow_info.rsvno
                                    and judclasscd = follow_info.judclasscd
                                    and prtdiv = 1
                            ) as prtseq
                            , follow_info.statuscd as statuscd
                            , follow_info.reqconfirmdate as reqconfirmdate
                            , follow_info.reqconfirmuser as reqconfirmuser
                            , follow_info.adduser as adduser
                            , follow_info.upduser as upduser
                        from
                            consult
                            , receipt
                            , follow_info
                        where
                            consult.rsvno = :rsvno
                            and consult.cancelflg = 0
                            and consult.rsvno = receipt.rsvno
                            and receipt.comedate is not null
                            and consult.rsvno = follow_info.rsvno
                    ) lastview
                    , judclass
                    , person
                    , follow_prt_h
                where
                    lastview.judclasscd = judclass.judclasscd
                    and judclass.commentonly is null
                    and lastview.perid = person.perid
                    and lastview.rsvno = follow_prt_h.rsvno(+)
                    and lastview.judclasscd = follow_prt_h.judclasscd(+)
                    and 1 = follow_prt_h.prtdiv(+)
                    and lastview.prtseq = follow_prt_h.seq(+)
                order by
                    lastview.csldate
                    , lastview.dayid
                    , lastview.judclasscd
            ";

            // フォローアップ情報取得
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定日付（受診日）範囲のフォローアップ対象者及び選択者を取得する
        /// </summary>
        /// <param name="startCslDate">開始受診日</param>
        /// <param name="endCslDate">終了受診日</param>
        /// <param name="perId">個人ID</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="equipDiv">フォロー(二次検査施設)区分</param>
        /// <param name="confirmDiv">二次検査結果承認区分</param>
        /// <param name="addUser">フォローアップ初期登録者ID</param>
        /// <param name="pageMaxLine">1ページ表示MAX行</param>
        /// <param name="startPos">表示開始位置</param>
        /// <param name="countFlg">集計フラグ(true:予約番号が重複しない件数、false:レコード件数)</param>
        /// <returns></returns>
        public PartialDataSet SelectTargetFollowList(
            DateTime? startCslDate,
            DateTime? endCslDate,
            string perId,
            string judClassCd,
            string equipDiv,
            string confirmDiv,
            string addUser,
            int pageMaxLine,
            int startPos,
            bool countFlg = false
        )
        {
            // 受診日の設定
            while (true)
            {
                // 双方とも未指定の場合は何もしない
                if ((startCslDate == null) && (endCslDate == null))
                {
                    break;
                }

                // 一方が未指定の場合、もう一方の値と同値として扱う
                if ((startCslDate != null) && (endCslDate == null))
                {
                    endCslDate = startCslDate;
                    break;
                }

                if ((startCslDate == null) && (endCslDate != null))
                {
                    startCslDate = endCslDate;
                    break;
                }

                // 双方とも指定されている場合、大小逆転時に入れ替えを行う
                if (endCslDate < startCslDate)
                {
                    DateTime? wkDate = startCslDate;
                    startCslDate = endCslDate;
                    endCslDate = wkDate;
                    break;
                }

                break;
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("strcsldate", startCslDate);
            param.Add("endcsldate", endCslDate);
            param.Add("strpos", startPos);
            param.Add("endpos", pageMaxLine + startPos - 1);
            param.Add("foljudclcd", "FOLJUDCL%");
            param.Add("foljudcd", "FOLJUD00%");
            param.Add("perid", perId == null ? "" : perId.Trim());
            param.Add("itemcd", judClassCd);
            param.Add("equipdiv", equipDiv);
            param.Add("adduser", addUser == null ? "" : addUser.Trim());

            // 指定検索条件のフォロー対象者リストを取得する
            var sql = @"
                select
                    rownum seq
                    , final.*
                from
                    (
                        select
                            lastview.csldate as csldate
                            , lastview.dayid as dayid
                            , person.lastkname || '　' || person.firstkname as perkname
                            , person.lastname || '　' || person.firstname as pername
                            , trunc(lastview.age) as age
                            , decode(person.gender, 1, '男', 2, '女') as gender
                            , to_char(
                                person.birth
                                , 'EYY.mm.dd'
                                , 'NLS_CALENDAR=''Japanese Imperial'''
                            ) as birth
                            , lastview.rsvno as rsvno
                            , lastview.perid as perid
                            , lastview.judclasscd as judclasscd
                            , judclass.judclassname as judclassname
                            , judclass.resultdispmode as resultdispmode
                            , lastview.judcd as judcd
                            , (
                                select
                                    judrsl.judcd
                                from
                                    judrsl
                                where
                                    judrsl.rsvno = lastview.rsvno
                                    and judrsl.judclasscd = lastview.judclasscd
                            ) as rsljudcd
                            , lastview.cscd as cscd
                            , nvl(lastview.equipdiv, '') as equipdiv
                            , nvl(lastview.statuscd, '') as statuscd
                            , nvl(lastview.reqconfirmdate, '') as reqconfirmdate
                            , (
                                select
                                    username
                                from
                                    hainsuser
                                where
                                    hainsuser.userid = lastview.reqconfirmuser
                            ) as reqconfirmuser
                            , lastview.prtseq as prtseq
                            , nvl(follow_prt_h.filename, '') as filename
                            , decode(
                                follow_prt_h.adddate
                                , null
                                , ''
                                , to_char(follow_prt_h.adddate, 'YYYY/MM/DD HH24:MI')
                            ) as prtdate
                            , (
                                select
                                    username
                                from
                                    hainsuser
                                where
                                    hainsuser.userid = follow_prt_h.adduser
                            ) as prtuser
                            , decode(
                                fc_get_result(lastview.rsvno, '30910', '00')
                                , null
                                , '-'
                                , ''
                                , '-'
                                , fc_get_result(lastview.rsvno, '30910', '00')
                            ) as doc_jud
                            , decode(
                                fc_get_result(lastview.rsvno, '23320', '00')
                                , null
                                , '-'
                                , ''
                                , '-'
                                , fc_get_result(lastview.rsvno, '23320', '00')
                            ) as doc_gf
                            , decode(
                                fc_get_result(lastview.rsvno, '23550', '00')
                                , null
                                , '-'
                                , ''
                                , '-'
                                , fc_get_result(lastview.rsvno, '23550', '00')
                            ) as doc_cf
                            , (
                                select
                                    username
                                from
                                    hainsuser
                                where
                                    hainsuser.userid = lastview.adduser
                            ) as adduser
                            , decode(
                                fc_get_result(lastview.rsvno, '30980', '00')
                                , null
                                , '-'
                                , ''
                                , '-'
                                , fc_get_result(lastview.rsvno, '30980', '00')
                            ) as doc_gyne
                            , decode(
                                fc_get_result(lastview.rsvno, '30981', '00')
                                , null
                                , '-'
                                , ''
                                , '-'
                                , fc_get_result(lastview.rsvno, '30981', '00')
                            ) as doc_gynejud
                        from
                            (
            ";

            // 検索条件として登録者が指定されている場合、登録済のフォローアップ情報のみ検索する
            if (string.IsNullOrEmpty(addUser))
            {
                sql += @"
                                (
                                    select
                                        consult.csldate as csldate
                                        , receipt.dayid as dayid
                                        , consult.rsvno as rsvno
                                        , consult.perid as perid
                                        , consult.age as age
                                        , consult.cscd as cscd
                                        , judrsl.judclasscd as judclasscd
                                        , null as judcd
                                        , null as equipdiv
                                        , null as prtseq
                                        , null as statuscd
                                        , null as reqconfirmdate
                                        , null as reqconfirmuser
                                        , null as adduser
                                    from
                                        consult
                                        , receipt
                                        , judrsl
                                    where
                                        consult.csldate between :strcsldate and :endcsldate
                                        and consult.cancelflg = 0
                ";

                if (!string.IsNullOrEmpty(perId))
                {
                    sql += @"
                                        and consult.perid = :perid
                    ";
                }

                sql += @"
                                        and consult.rsvno = receipt.rsvno
                                        and receipt.comedate is not null
                                        and consult.rsvno = judrsl.rsvno
                                        and judrsl.judclasscd in (
                                            select
                                                free.freefield1
                                            from
                                                free
                                            where
                                                free.freecd like :foljudclcd
                                        )
                                        and judrsl.judcd in (
                                            select
                                                free1.freefield1 judcd
                                            from
                                                free
                                                , free free1
                                            where
                                                free.freecd like :foljudclcd
                                                and free.freefield1 = judrsl.judclasscd
                                                and free.freeclasscd = free1.freeclasscd
                                                and free1.freecd like :foljudcd
                                        )
                                    minus
                                    select
                                        consult.csldate as csldate
                                        , receipt.dayid as dayid
                                        , consult.rsvno as rsvno
                                        , consult.perid as perid
                                        , consult.age as age
                                        , consult.cscd as cscd
                                        , follow_info.judclasscd as judclasscd
                                        , null as judcd
                                        , null as equipdiv
                                        , null as prtseq
                                        , null as statuscd
                                        , null as reqconfirmdate
                                        , null as reqconfirmuser
                                        , null as adduser
                                    from
                                        consult
                                        , receipt
                                        , follow_info
                                    where
                                        consult.csldate between :strcsldate and :endcsldate
                                        and consult.cancelflg = 0

                ";

                if (!string.IsNullOrEmpty(perId))
                {
                    sql += @"
                                        and consult.perid = :perid
                    ";
                }

                sql += @"
                                        and consult.rsvno = receipt.rsvno
                                        and receipt.comedate is not null
                                        and consult.rsvno = follow_info.rsvno
                                )
                                union
                ";
            }

            sql += @"
                                select
                                    consult.csldate as csldate
                                    , receipt.dayid as dayid
                                    , consult.rsvno as rsvno
                                    , consult.perid as perid
                                    , consult.age as age
                                    , consult.cscd as cscd
                                    , follow_info.judclasscd as judclasscd
                                    , follow_info.judcd as judcd
                                    , follow_info.secequipdiv as equipdiv
                                    , (
                                        select
                                            max(seq)
                                        from
                                            follow_prt_h
                                        where
                                            rsvno = follow_info.rsvno
                                            and judclasscd = follow_info.judclasscd
                                            and prtdiv = 1
                                    ) as prtseq
                                    , follow_info.statuscd as statuscd
                                    , follow_info.reqconfirmdate as reqconfirmdate
                                    , follow_info.reqconfirmuser as reqconfirmuser
                                    , follow_info.adduser as adduser
                                from
                                    consult
                                    , receipt
                                    , follow_info
                                where
                                    consult.csldate between :strcsldate and :endcsldate
                                    and consult.cancelflg = 0
            ";

            if (!string.IsNullOrEmpty(perId))
            {
                sql += @"
                                    and consult.perid = :perid
                ";
            }

            sql += @"
                                    and consult.rsvno = receipt.rsvno
                                    and receipt.comedate is not null
                                    and consult.rsvno = follow_info.rsvno
            ";

            if (!string.IsNullOrEmpty(addUser))
            {
                sql += @"
                                    and follow_info.adduser = :adduser
                ";
            }

            sql += @"
                            ) lastview
                            , judclass
                            , person
                            , follow_prt_h
                        where
                            lastview.judclasscd = judclass.judclasscd
                            and judclass.commentonly is null
                            and lastview.perid = person.perid
                            and lastview.rsvno = follow_prt_h.rsvno(+)
                            and lastview.judclasscd = follow_prt_h.judclasscd(+)
                            and 1 = follow_prt_h.prtdiv(+)
                            and lastview.prtseq = follow_prt_h.seq(+)
            ";

            // 検査項目条件チェック
            if (!string.IsNullOrEmpty(judClassCd))
            {
                sql += @"
                            and lastview.judclasscd = :itemcd
                ";
            }

            // 二次検査施設区分条件チェック
            if (!string.IsNullOrEmpty(equipDiv))
            {
                if (!"999".Equals(equipDiv))
                {
                    sql += @"
                            and lastview.equipdiv = :equipdiv
                    ";
                }
                else
                {
                    sql += @"
                            and lastview.equipdiv is null
                    ";
                }
            }

            // 結果承認有無条件チェック
            if ("1".Equals(confirmDiv))
            {
                sql += @"
                            and lastview.reqconfirmdate is not null
                ";
            }
            else
            {
                if ("0".Equals(confirmDiv))
                {
                    sql += @"
                            and lastview.reqconfirmdate is null
                    ";
                }
            }

            sql += @"
                        order by
                            lastview.csldate
                            , lastview.dayid
                            , lastview.judclasscd
                    ) final
            ";

            // 最初にレコード件数だけ取得
            string sql2;
            if (countFlg)
            {
                sql2 = @"
                    select
                        count(distinct rsvno) cnt
                    from
                        (" + sql + @")
                ";
            }
            else
            {
                sql2 = @"
                    select
                        count(*) cnt
                    from
                        (" + sql + @")
                ";
            }

            dynamic data = connection.Query(sql2, param).FirstOrDefault();

            int recCount = Convert.ToInt32(data.CNT);

            sql = @"
                    select
                        *
                    from
                        (" + sql + @")
                    where
                        seq between :strpos and :endpos
            ";

            return new PartialDataSet(recCount, connection.Query(sql, param).ToList());
        }

        /// <summary>
        /// 指定予約番号のフォローアップ結果情報を登録する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="seq">SEQ</param>
        /// <param name="secCslDate">二次検査年月日</param>
        /// <param name="updUser">更新者</param>
        /// <param name="testUS">検査方法US</param>
        /// <param name="testCT">検査方法CT</param>
        /// <param name="testMRI">検査方法MRI</param>
        /// <param name="testBF">検査方法BF</param>
        /// <param name="testGF">検査方法GF</param>
        /// <param name="testCF">検査方法CF</param>
        /// <param name="testEM">検査方法EM</param>
        /// <param name="testTM">検査方法TM</param>
        /// <param name="testEtc">検査方法その他</param>
        /// <param name="testRemark">検査方法その他コメント</param>
        /// <param name="testRefer"></param>
        /// <param name="testReferText"></param>
        /// <param name="resultDiv">二次検査結果</param>
        /// <param name="disRemark">疾患その他コメント</param>
        /// <param name="polWithout">処置不要</param>
        /// <param name="polFollowup">経過観察</param>
        /// <param name="polMonth">経過観察期間</param>
        /// <param name="polReExam">１年後健診</param>
        /// <param name="polDiagSt">本院紹介精査</param>
        /// <param name="polDiag">他院紹介精査</param>
        /// <param name="polEtc1">治療なしその他</param>
        /// <param name="polRemark1">治療なしその他コメント</param>
        /// <param name="polSugery">外科治療</param>
        /// <param name="polEndoscope">内視鏡的治療</param>
        /// <param name="polChemical">化学療法</param>
        /// <param name="polRadiation">放射線治療</param>
        /// <param name="polReferSt">本院紹介治療</param>
        /// <param name="polRefer">他院紹介治療</param>
        /// <param name="polEtc2">治療ありその他</param>
        /// <param name="polRemark2">治療ありその他コメント</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="result">結果</param>
        /// <param name="newSeq">新しいSEQ</param>
        public void UpdateFollow_Rsl(
            int rsvNo,
            int judClassCd,
            int seq,
            DateTime? secCslDate,
            string updUser,
            string testUS,
            string testCT,
            string testMRI,
            string testBF,
            string testGF,
            string testCF,
            string testEM,
            string testTM,
            string testEtc,
            string testRemark,
            string testRefer,
            string testReferText,
            string resultDiv,
            string disRemark,
            string polWithout,
            string polFollowup,
            string polMonth,
            string polReExam,
            string polDiagSt,
            string polDiag,
            string polEtc1,
            string polRemark1,
            string polSugery,
            string polEndoscope,
            string polChemical,
            string polRadiation,
            string polReferSt,
            string polRefer,
            string polEtc2,
            string polRemark2,
            string[] itemCd,
            string[] suffix,
            string[] result,
            out int newSeq
        )
        {
            string stmt = null; // SQLステートメント
            string stmt2 = null; // SQLステートメント2
            string stmt3 = null; // SQLステートメント3

            string itemName; // 変更履歴項目名

            IList<dynamic> beforeItems = null; // 変更前検査項目とその結果
            IList<IDictionary<string, string>> afterItems = new List<IDictionary<string, string>>(); // 変更後検査項目とその結果

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("judclasscd", judClassCd);
            param.Add("seq", seq);

            param.Add("seccsldate", secCslDate);
            param.Add("upduser", updUser);
            param.Add("testus", testUS);
            param.Add("testct", testCT);
            param.Add("testmri", testMRI);
            param.Add("TESTBF", testBF);
            param.Add("testgf", testGF);
            param.Add("testcf", testCF);
            param.Add("testem", testEM);
            param.Add("testtm", testTM);
            param.Add("testetc", testEtc);
            param.Add("testremark", testRemark);
            param.Add("testrefer", testRefer);
            param.Add("testrefertext", testReferText);
            param.Add("resultdiv", resultDiv);
            param.Add("disremark", disRemark);
            param.Add("polwithout", polWithout);
            param.Add("polfollowup", polFollowup);
            param.Add("polmonth", polMonth);
            param.Add("polreexam", polReExam);
            param.Add("poldiagst", polDiagSt);
            param.Add("poldiag", polDiag);
            param.Add("poletc1", polEtc1);
            param.Add("polremark1", polRemark1);
            param.Add("polsugery", polSugery);
            param.Add("polendoscope", polEndoscope);
            param.Add("polchemical", polChemical);
            param.Add("polradiation", polRadiation);
            param.Add("polreferst", polReferSt);
            param.Add("polrefer", polRefer);
            param.Add("poletc2", polEtc2);
            param.Add("polremark2", polRemark2);

            param.Add("itemcd", null);
            param.Add("suffix", null);
            param.Add("result", null);

            // 結果変更の場合：受け取った一連番号、新規登録の場合：付番している新しい一連番号を返す
            newSeq = seq;

            // 指定予約番号・検査項目（判定分類）のフォロー情報を取得する
            var sql = @"
                select
                    follow_rsl.seccsldate
                    , follow_rsl.testus
                    , follow_rsl.testct
                    , follow_rsl.testmri
                    , follow_rsl.testbf
                    , follow_rsl.testgf
                    , follow_rsl.testcf
                    , follow_rsl.testem
                    , follow_rsl.testtm
                    , follow_rsl.testetc
                    , follow_rsl.testremark
                    , follow_rsl.resultdiv
                    , follow_rsl.testrefer
                    , follow_rsl.testrefertext
                    , follow_rsl.disremark
                    , follow_rsl.polwithout
                    , follow_rsl.polfollowup
                    , follow_rsl.polmonth
                    , follow_rsl.polreexam
                    , follow_rsl.poldiagst
                    , follow_rsl.poldiag
                    , follow_rsl.poletc1
                    , follow_rsl.polremark1
                    , follow_rsl.polsugery
                    , follow_rsl.polendoscope
                    , follow_rsl.polchemical
                    , follow_rsl.polradiation
                    , follow_rsl.polrefer
                    , follow_rsl.polreferst
                    , follow_rsl.poletc2
                    , follow_rsl.polremark2
                from
                    follow_rsl
                where
                    follow_rsl.rsvno = :rsvno
                    and follow_rsl.judclasscd = :judclasscd
                    and follow_rsl.seq = :seq
                for update
            ";

            dynamic beforeData = connection.Query(sql, param).FirstOrDefault();

            if (beforeData == null)
            {
                // 該当フォローアップ結果情報すべてのレコードロック
                var sql_lock = @"
                    select
                        follow_rsl.seq
                    from
                        follow_rsl
                    where
                        follow_rsl.rsvno = :rsvno
                        and follow_rsl.judclasscd = :judclasscd
                    for update
                ";

                connection.Query(sql_lock, param);

                // フォローアップ結果情報一連番号取得
                var sql_getseq = @"
                    select
                        nvl(max(follow_rsl.seq), 0) + 1 as newseq
                    from
                        follow_rsl
                    where
                        follow_rsl.rsvno = :rsvno
                        and follow_rsl.judclasscd = :judclasscd
                ";

                dynamic data_getseq = connection.Query(sql_getseq, param).FirstOrDefault();

                if (data_getseq != null)
                {
                    newSeq = Convert.ToInt32(data_getseq.NEWSEQ);
                }
                else
                {
                    newSeq = 1;
                }

                param["seq"] = newSeq;

                var sql_insert_follow_rsl = @"
                    insert
                    into follow_rsl(
                        rsvno
                        , judclasscd
                        , seq
                        , seccsldate
                        , adddate
                        , adduser
                        , upddate
                        , upduser
                        , testus
                        , testct
                        , testmri
                        , testbf
                        , testgf
                        , testcf
                        , testem
                        , testtm
                        , testetc
                        , testremark
                        , testrefer
                        , testrefertext
                        , resultdiv
                        , disremark
                        , polwithout
                        , polfollowup
                        , polmonth
                        , polreexam
                        , poldiagst
                        , poldiag
                        , poletc1
                        , polremark1
                        , polsugery
                        , polendoscope
                        , polchemical
                        , polradiation
                        , polreferst
                        , polrefer
                        , poletc2
                        , polremark2
                    )
                    values (
                        :rsvno
                        , :judclasscd
                        , :seq
                        , :seccsldate
                        , sysdate
                        , :upduser
                        , sysdate
                        , :upduser
                        , :testus
                        , :testct
                        , :testmri
                        , :testbf
                        , :testgf
                        , :testcf
                        , :testem
                        , :testtm
                        , :testetc
                        , :testremark
                        , :testrefer
                        , :testrefertext
                        , :resultdiv
                        , :disremark
                        , :polwithout
                        , :polfollowup
                        , :polmonth
                        , :polreexam
                        , :poldiagst
                        , :poldiag
                        , :poletc1
                        , :polremark1
                        , :polsugery
                        , :polendoscope
                        , :polchemical
                        , :polradiation
                        , :polreferst
                        , :polrefer
                        , :poletc2
                        , :polremark2
                    )
                ";

                connection.Execute(sql_insert_follow_rsl, param);

                // 疾患（診断名）新規挿入
                afterItems = new List<IDictionary<string, string>>();
                for (var j = 0; j < itemCd.Length; j++)
                {
                    var items = new Dictionary<string, string>
                    {
                        { "itemcd", null },
                        { "suffix", null },
                        { "result", null }
                    };

                    if (!string.IsNullOrEmpty(result[j]))
                    {
                        items["itemcd"] = itemCd[j].Trim();
                        items["suffix"] = suffix[j].Trim();

                        param["itemcd"] = itemCd[j].Trim();
                        param["suffix"] = suffix[j].Trim();
                        param["result"] = result[j].Trim();

                        stmt2 = @"
                            select
                                item_c.itemcd as itemcd
                                , item_c.suffix as suffix
                                , item_c.itemname as itemname
                                , sentence.longstc as longstc
                            from
                                item_c
                                , sentence
                            where
                                item_c.itemcd = :itemcd
                                and item_c.suffix = :suffix
                                and item_c.stcitemcd = sentence.itemcd
                                and item_c.itemtype = sentence.itemtype
                                and sentence.stccd = :result
                        ";

                        dynamic data3 = connection.Query(stmt2, param).FirstOrDefault();

                        // 検索レコードが存在する場合
                        if (data3 != null)
                        {
                            items["result"] = Convert.ToString(data3.LONGSTC);
                        }

                        stmt2 = @"
                            insert
                            into follow_rsl_i(
                                rsvno
                                , judclasscd
                                , seq
                                , itemcd
                                , suffix
                                , result
                            )
                            values (
                                :rsvno
                                , :judclasscd
                                , :seq
                                , :itemcd
                                , :suffix
                                , :result
                            )
                        ";

                        connection.Execute(stmt2, param);
                    }

                    afterItems.Add(items);
                }

                // フォローアップ情報の更新日、更新者変更
                stmt3 = @"
                    update follow_info
                    set
                        upddate = sysdate
                        , upduser = :upduser
                    where
                        rsvno = :rsvno
                        and judclasscd = :judclasscd
                ";

                connection.Execute(stmt3, param);

                // 新規登録の場合はLOG出力
                itemName = "二次検査年月日";
                if (secCslDate != null)
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", ((DateTime)secCslDate).ToString("yyyy/MM/dd"));
                }

                // 検査方法登録履歴 Start
                itemName = "検査方法";
                if (!string.IsNullOrEmpty(testUS))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "US");
                }

                if (!string.IsNullOrEmpty(testCT))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "CT");
                }
                if (!string.IsNullOrEmpty(testMRI))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "MRI");
                }
                if (!string.IsNullOrEmpty(testBF))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "BF");
                }
                if (!string.IsNullOrEmpty(testGF))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "GF");
                }
                if (!string.IsNullOrEmpty(testCF))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "CF");
                }
                if (!string.IsNullOrEmpty(testEM))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "注腸");
                }
                if (!string.IsNullOrEmpty(testTM))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "腫瘍マーカー");
                }
                if (!string.IsNullOrEmpty(testEtc))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "その他");
                }
                if (!string.IsNullOrEmpty(testRemark))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", testRemark);
                }
                if (!string.IsNullOrEmpty(testRefer))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "リファー");
                }
                if (!string.IsNullOrEmpty(testReferText))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", testReferText);
                }

                // 二次検査結果区分登録履歴
                itemName = "二次検査結果";
                string resultDivName = "";
                if (!string.IsNullOrEmpty(resultDiv))
                {
                    switch (resultDiv)
                    {
                        case "1":
                            resultDivName = "異常なし";
                            break;
                        case "2":
                            resultDivName = "不明";
                            break;
                        case "3":
                            resultDivName = "所見あり";
                            break;
                    }
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", resultDivName);
                }

                itemName = "その他疾患";
                if (!string.IsNullOrEmpty(disRemark))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", disRemark);
                }

                // 二次検査方針登録履歴
                itemName = "方針（治療なし）";
                if (!string.IsNullOrEmpty(polWithout))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "処置不要");
                }
                if (!string.IsNullOrEmpty(polFollowup))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "経過観察");
                }
                if (!string.IsNullOrEmpty(polMonth))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", polMonth);
                }
                if (!string.IsNullOrEmpty(polReExam))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "１年後健診");
                }
                if (!string.IsNullOrEmpty(polDiagSt))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "本院紹介（精査）");
                }
                if (!string.IsNullOrEmpty(polDiag))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "他院紹介（精査）");
                }
                if (!string.IsNullOrEmpty(polEtc1))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "その他（治療なし）");
                }
                if (!string.IsNullOrEmpty(polRemark1))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", polRemark1);
                }

                itemName = "方針（治療あり）";
                if (!string.IsNullOrEmpty(polSugery))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "外科治療");
                }
                if (!string.IsNullOrEmpty(polEndoscope))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "内視鏡的治療");
                }
                if (!string.IsNullOrEmpty(polChemical))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "化学療法");
                }
                if (!string.IsNullOrEmpty(polRadiation))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "放射線治療");
                }
                if (!string.IsNullOrEmpty(polReferSt))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "本院紹介（治療）");
                }
                if (!string.IsNullOrEmpty(polRefer))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "他院紹介（治療）");
                }
                if (!string.IsNullOrEmpty(polEtc2))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", "その他（治療あり）");
                }
                if (!string.IsNullOrEmpty(polRemark2))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, "", "", "", polRemark2);
                }

                // 二次検査診断名（疾患）登録履歴
                itemName = "診断名（疾患）";
                foreach (var rec in afterItems)
                {
                    if (!string.IsNullOrEmpty(rec["result"]))
                    {
                        InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, rec["itemcd"], rec["suffix"], "", rec["result"]);
                    }
                }
            }
            else
            {
                stmt = @"
                    update follow_rsl
                    set
                        seccsldate = :seccsldate
                        , upddate = sysdate
                        , upduser = :upduser
                        , testus = :testus
                        , testct = :testct
                        , testmri = :testmri
                        , testbf = :testbf
                        , testgf = :testgf
                        , testcf = :testcf
                        , testem = :testem
                        , testtm = :testtm
                        , testetc = :testetc
                        , testremark = :testremark
                        , testrefer = :testrefer
                        , testrefertext = :testrefertext
                        , resultdiv = :resultdiv
                        , disremark = :disremark
                        , polwithout = :polwithout
                        , polfollowup = :polfollowup
                        , polmonth = :polmonth
                        , polreexam = :polreexam
                        , poldiagst = :poldiagst
                        , poldiag = :poldiag
                        , poletc1 = :poletc1
                        , polremark1 = :polremark1
                        , polsugery = :polsugery
                        , polendoscope = :polendoscope
                        , polchemical = :polchemical
                        , polradiation = :polradiation
                        , polreferst = :polreferst
                        , polrefer = :polrefer
                        , poletc2 = :poletc2
                        , polremark2 = :polremark2
                    where
                        rsvno = :rsvno
                        and judclasscd = :judclasscd
                        and seq = :seq
                ";

                connection.Execute(stmt, param);

                // 疾患（診断名）情報削除前変更履歴登録のため結果取得
                stmt2 = @"
                    select
                        last.rsvno as rsvno
                        , last.judclasscd as judclasscd
                        , last.itemcd as itemcd
                        , last.suffix as suffix
                        , last.itemname as itemcdname
                        , sentence.longstc as result
                    from
                        (
                            select
                                follow_rsl_i.rsvno as rsvno
                                , follow_rsl_i.judclasscd as judclasscd
                                , follow_rsl_i.itemcd as itemcd
                                , follow_rsl_i.suffix as suffix
                                , item_c.itemtype as itemtype
                                , item_c.stcitemcd as stcitemcd
                                , follow_rsl_i.result as result
                                , item_c.itemname as itemname
                            from
                                follow_rsl_i
                                , item_c
                            where
                                follow_rsl_i.rsvno = :rsvno
                                and follow_rsl_i.judclasscd = :judclasscd
                                and follow_rsl_i.seq = :seq
                                and follow_rsl_i.itemcd = item_c.itemcd
                                and follow_rsl_i.suffix = item_c.suffix
                        ) last
                        , sentence
                    where
                        last.stcitemcd = sentence.itemcd(+)
                        and last.itemtype = sentence.itemtype(+)
                        and last.result = sentence.stccd(+)
                ";

                beforeItems = connection.Query(stmt2, param).ToList();
            }

            // 疾患（診断名）情報はすべて削除してから挿入
            stmt2 = @"
                delete
                from
                    follow_rsl_i
                where
                    rsvno = :rsvno
                    and judclasscd = :judclasscd
                    and seq = :seq
            ";

            connection.Execute(stmt2, param);

            afterItems = new List<IDictionary<string, string>>();
            for (var j = 0; j < itemCd.Length; j++)
            {
                var items = new Dictionary<string, string>
                {
                    { "itemcd", null },
                    { "suffix", null },
                    { "result", null }
                };

                if (!string.IsNullOrEmpty(result[j]))
                {
                    items["itemcd"] = itemCd[j].Trim();
                    items["suffix"] = suffix[j].Trim();

                    param["itemcd"] = itemCd[j].Trim();
                    param["suffix"] = suffix[j].Trim();
                    param["result"] = result[j].Trim();

                    stmt2 = @"
                        select
                            item_c.itemcd as itemcd
                            , item_c.suffix as suffix
                            , item_c.itemname as itemname
                            , sentence.longstc as longstc
                        from
                            item_c
                            , sentence
                        where
                            item_c.itemcd = :itemcd
                            and item_c.suffix = :suffix
                            and item_c.stcitemcd = sentence.itemcd
                            and item_c.itemtype = sentence.itemtype
                            and sentence.stccd = :result
                    ";

                    dynamic data3 = connection.Query(stmt2, param).FirstOrDefault();

                    // 検索レコードが存在する場合
                    if (data3 != null)
                    {
                        items["result"] = Convert.ToString(data3.LONGSTC);
                    }

                    stmt2 = @"
                        insert
                        into follow_rsl_i(
                            rsvno
                            , judclasscd
                            , seq
                            , itemcd
                            , suffix
                            , result
                        )
                        values (
                            :rsvno
                            , :judclasscd
                            , :seq
                            , :itemcd
                            , :suffix
                            , :result
                        )
                    ";

                    connection.Execute(stmt2, param);
                }

                afterItems.Add(items);
            }

            // フォローアップ情報の更新日、更新者変更
            var sql_update_follow_info = @"
                update follow_info
                set
                    upddate = sysdate
                    , upduser = :upduser
                where
                    rsvno = :rsvno
                    and judclasscd = :judclasscd
            ";

            connection.Execute(sql_update_follow_info, param);

            // 二次検査診断名（疾患）変更履歴（変更前） Start
            itemName = "診断名（疾患）";
            if (beforeItems != null)
            {
                foreach (var rec in beforeItems)
                {
                    InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, Convert.ToString(rec.ITEMCD), Convert.ToString(rec.SUFFIX), Convert.ToString(rec.RESULT), "");
                }
            }

            // 変更LOG出力
            itemName = "二次検査年月日";
            DateTime? beforeSecCslDate = null;
            if (beforeData != null && beforeData.SECCSLDATE != null)
            {
                beforeSecCslDate = Convert.ToDateTime(beforeData.SECCSLDATE);
            }
            if (beforeSecCslDate != secCslDate)
            {
                InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", beforeSecCslDate, secCslDate);
            }

            itemName = "検査方法";
            int? beforeTestUS = null;
            if (beforeData != null && beforeData.TESTUS != null)
            {
                beforeTestUS = Convert.ToInt32(beforeData.TESTUS);
            }

            if (beforeTestUS != Convert.ToInt32(testUS))
            {
                if (beforeTestUS != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "US", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "US");
                }
            }

            int? beforeTestCT = null;
            if (beforeData != null && beforeData.TESTCT != null)
            {
                beforeTestCT = Convert.ToInt32(beforeData.TESTCT);
            }

            if (beforeTestCT != Convert.ToInt32(testCT))
            {
                if (beforeTestCT != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "CT", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "CT");
                }
            }

            int? beforeTestMRI = null;
            if (beforeData != null && beforeData.TESTMRI != null)
            {
                beforeTestMRI = Convert.ToInt32(beforeData.TESTMRI);
            }

            if (beforeTestMRI != Convert.ToInt32(testMRI))
            {
                if (beforeTestMRI != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "MRI", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "MRI");
                }
            }

            int? beforeTestBF = null;
            if (beforeData != null && beforeData.TESTBF != null)
            {
                beforeTestBF = Convert.ToInt32(beforeData.TESTBF);
            }

            if (beforeTestBF != Convert.ToInt32(testBF))
            {
                if (beforeTestBF != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "BF", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "BF");
                }
            }

            int? beforeTestGF = null;
            if (beforeData != null && beforeData.TESTGF != null)
            {
                beforeTestGF = Convert.ToInt32(beforeData.TESTGF);
            }

            if (beforeTestGF != Convert.ToInt32(testGF))
            {
                if (beforeTestGF != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "GF", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "GF");
                }
            }

            int? beforeTestCF = null;
            if (beforeData != null && beforeData.TESTCF != null)
            {
                beforeTestCF = Convert.ToInt32(beforeData.TESTCF);
            }

            if (beforeTestCF != Convert.ToInt32(testCF))
            {
                if (beforeTestCF != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "CF", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "CF");
                }
            }

            int? beforeTestEM = null;
            if (beforeData != null && beforeData.TESTEM != null)
            {
                beforeTestEM = Convert.ToInt32(beforeData.TESTEM);
            }

            if (beforeTestEM != Convert.ToInt32(testEM))
            {
                if (beforeTestEM != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "注腸", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "注腸");
                }
            }

            int? beforeTestTM = null;
            if (beforeData != null && beforeData.TESTTM != null)
            {
                beforeTestTM = Convert.ToInt32(beforeData.TESTTM);
            }

            if (beforeTestTM != Convert.ToInt32(testTM))
            {
                if (beforeTestTM != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "腫瘍マーカー", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "腫瘍マーカー");
                }
            }

            int? beforeTestEtc = null;
            if (beforeData != null && beforeData.TESTETC != null)
            {
                beforeTestEtc = Convert.ToInt32(beforeData.TESTETC);
            }

            if (beforeTestEtc != Convert.ToInt32(testEtc))
            {
                if (beforeTestEtc != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "その他", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "その他");
                }
            }

            string beforeTestRemark = null;
            if (beforeData != null && beforeData.TESTREMARK != null)
            {
                beforeTestRemark = beforeData.TESTREMARK;
            }

            if (beforeTestRemark != testRemark)
            {
                if (beforeTestRemark != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", testRemark, "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", testRemark);
                }
            }

            int? beforeTestRefer = null;
            if (beforeData != null && beforeData.TESTREFER != null)
            {
                beforeTestRefer = Convert.ToInt32(beforeData.TESTREFER);
            }

            if (beforeTestRefer != Convert.ToInt32(testRefer))
            {
                if (beforeTestRefer != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "リファー", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "リファー");
                }
            }

            string beforeTestReferText = null;
            if (beforeData != null && beforeData.TESTREFERTEXT != null)
            {
                beforeTestReferText = beforeData.TESTREFERTEXT;
            }

            if (beforeTestReferText != testReferText)
            {
                if (!string.IsNullOrEmpty(beforeTestReferText))
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", beforeTestReferText, testReferText);
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", testReferText);
                }
            }

            // 二次検査結果区分変更履歴登録
            itemName = "二次検査結果";
            string beforeResultDivName = "";
            string afterResultDivName = "";

            int? beforeResultDiv = null;
            if (beforeData != null && beforeData.RESULTDIV != null)
            {
                beforeResultDiv = Convert.ToInt32(beforeData.RESULTDIV);
            }

            int? afterResultDiv = resultDiv != null ? (int?)Convert.ToInt32(resultDiv) : null;
            if (beforeResultDiv != afterResultDiv)
            {
                switch (beforeResultDiv)
                {
                    case 1:
                        beforeResultDivName = "異常なし";
                        break;
                    case 2:
                        beforeResultDivName = "不明";
                        break;
                    case 3:
                        beforeResultDivName = "所見あり";
                        break;
                    default:
                        beforeResultDivName = null;
                        break;
                }

                switch (afterResultDiv)
                {
                    case 1:
                        afterResultDivName = "異常なし";
                        break;
                    case 2:
                        afterResultDivName = "不明";
                        break;
                    case 3:
                        afterResultDivName = "所見あり";
                        break;
                    default:
                        afterResultDivName = null;
                        break;
                }

                InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", beforeResultDivName, afterResultDivName);
            }

            // 疾患その他変更履歴登録
            itemName = "その他疾患";
            string beforeDisRemark = null;
            if (beforeData != null && beforeData.DISREMARK != null)
            {
                beforeDisRemark = beforeData.DISREMARK;
            }

            if (beforeDisRemark != disRemark)
            {
                InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", beforeDisRemark, disRemark);
            }

            // 二次検査方針変更履歴登録 Start
            itemName = "方針（治療なし）";
            int? beforePolWithout = null;
            if (beforeData != null && beforeData.POLWITHOUT != null)
            {
                beforePolWithout = Convert.ToInt32(beforeData.POLWITHOUT);
            }

            int? afterPolWithout = polWithout != null ? (int?)Convert.ToInt32(polWithout) : null;
            if (beforePolWithout != afterPolWithout)
            {
                if (beforePolWithout != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "処置不要", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "処置不要");
                }
            }

            int? beforePolFollowup = null;
            if (beforeData != null && beforeData.POLFOLLOWUP != null)
            {
                beforePolFollowup = Convert.ToInt32(beforeData.POLFOLLOWUP);
            }

            int? afterPolFollowup = polFollowup != null ? (int?)Convert.ToInt32(polFollowup) : null;
            if (beforePolFollowup != afterPolFollowup)
            {
                if (beforePolWithout != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "経過観察", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "経過観察");
                }
            }

            string beforePolMonth = null;
            if (beforeData != null && beforeData.POLMONTH != null)
            {
                beforePolMonth = Convert.ToString(beforeData.POLMONTH);
            }

            if (beforePolMonth != polMonth)
            {
                InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", beforePolMonth, polMonth);
            }

            int? beforePolReExam = null;
            if (beforeData != null && beforeData.POLREEXAM != null)
            {
                beforePolReExam = Convert.ToInt32(beforeData.POLREEXAM);
            }

            int? afterPolReExam = polReExam != null ? (int?)Convert.ToInt32(polReExam) : null;
            if (beforePolReExam != afterPolReExam)
            {
                if (beforePolReExam != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "１年後健診", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "１年後健診");
                }
            }

            int? beforePolDiagSt = null;
            if (beforeData != null && beforeData.POLDIAGST != null)
            {
                beforePolDiagSt = Convert.ToInt32(beforeData.POLDIAGST);
            }

            int? afterPolDiagSt = polDiagSt != null ? (int?)Convert.ToInt32(polDiagSt) : null;
            if (beforePolDiagSt != afterPolDiagSt)
            {
                if (beforePolDiagSt != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "本院紹介（精査）", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "本院紹介（精査）");
                }
            }

            int? beforePolDiag = null;
            if (beforeData != null && beforeData.POLDIAG != null)
            {
                beforePolDiag = Convert.ToInt32(beforeData.POLDIAG);
            }

            int? afterPolDiag = polDiag != null ? (int?)Convert.ToInt32(polDiag) : null;
            if (beforePolDiag != afterPolDiag)
            {
                if (beforePolDiag != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "他院紹介（精査）", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "他院紹介（精査）");
                }
            }

            int? beforePolEtc1 = null;
            if (beforeData != null && beforeData.POLETC1 != null)
            {
                beforePolEtc1 = Convert.ToInt32(beforeData.POLETC1);
            }

            int? afterPolEtc1 = polEtc1 != null ? (int?)Convert.ToInt32(polEtc1) : null;
            if (beforePolEtc1 != afterPolEtc1)
            {
                if (beforePolEtc1 != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "その他（治療なし）", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "その他（治療なし）");
                }
            }

            string beforePolRemark1 = null;
            if (beforeData != null && beforeData.POLREMARK1 != null)
            {
                beforePolRemark1 = beforeData.POLREMARK1;
            }

            if (beforePolRemark1 != polRemark1)
            {
                InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", beforePolRemark1, polRemark1);
            }

            itemName = "方針（治療あり）";
            int? beforePolSugery = null;
            if (beforeData != null && beforeData.POLSUGERY != null)
            {
                beforePolSugery = Convert.ToInt32(beforeData.POLSUGERY);
            }

            int? afterPolSugery = polSugery != null ? (int?)Convert.ToInt32(polSugery) : null;
            if (beforePolSugery != afterPolSugery)
            {
                if (beforePolSugery != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "外科治療", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "外科治療");
                }
            }

            int? beforePolEndoscope = null;
            if (beforeData != null && beforeData.POLENDOSCOPE != null)
            {
                beforePolEndoscope = Convert.ToInt32(beforeData.POLENDOSCOPE);
            }

            int? afterPolEndoscope = polEndoscope != null ? (int?)Convert.ToInt32(polEndoscope) : null;
            if (beforePolEndoscope != afterPolEndoscope)
            {
                if (beforePolEndoscope != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "内視鏡的治療", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "内視鏡的治療");
                }
            }

            int? beforePolChemical = null;
            if (beforeData != null && beforeData.POLCHEMICAL != null)
            {
                beforePolChemical = Convert.ToInt32(beforeData.POLCHEMICAL);
            }

            int? afterPolChemical = polChemical != null ? (int?)Convert.ToInt32(polChemical) : null;
            if (beforePolChemical != afterPolChemical)
            {
                if (beforePolChemical != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "化学療法", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "化学療法");
                }
            }

            int? beforePolRadiation = null;
            if (beforeData != null && beforeData.POLRADIATION != null)
            {
                beforePolRadiation = Convert.ToInt32(beforeData.POLRADIATION);
            }

            int? afterPolRadiation = polRadiation != null ? (int?)Convert.ToInt32(polRadiation) : null;
            if (beforePolRadiation != afterPolRadiation)
            {
                if (beforePolRadiation != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "放射線治療", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "放射線治療");
                }
            }

            int? beforePolReferSt = null;
            if (beforeData != null && beforeData.POLREFERST != null)
            {
                beforePolReferSt = Convert.ToInt32(beforeData.POLREFERST);
            }

            int? afterPolReferSt = polReferSt != null ? (int?)Convert.ToInt32(polReferSt) : null;
            if (beforePolReferSt != afterPolReferSt)
            {
                if (beforePolReferSt != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "本院紹介（治療）", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "本院紹介（治療）");
                }
            }

            int? beforePolRefer = null;
            if (beforeData != null && beforeData.POLREFER != null)
            {
                beforePolRefer = Convert.ToInt32(beforeData.POLREFER);
            }

            int? afterPolRefer = polRefer != null ? (int?)Convert.ToInt32(polRefer) : null;
            if (beforePolRefer != afterPolRefer)
            {
                if (beforePolRefer != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "他院紹介（治療）", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "他院紹介（治療）");
                }
            }

            int? beforePolEtc2 = null;
            if (beforeData != null && beforeData.POLETC2 != null)
            {
                beforePolEtc2 = Convert.ToInt32(beforeData.POLETC2);
            }

            int? afterPolEtc2 = polEtc2 != null ? (int?)Convert.ToInt32(polEtc2) : null;
            if (beforePolEtc2 != afterPolEtc2)
            {
                if (beforePolEtc2 != null)
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "その他（治療あり）", "");
                }
                else
                {
                    InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", "", "その他（治療あり）");
                }
            }

            string beforePolRemark2 = null;
            if (beforeData != null && beforeData.POLREMARK2 != null)
            {
                beforePolRemark2 = beforeData.POLREMARK2;
            }

            if (beforePolRemark2 != polRemark2)
            {
                InsertFollow_Log(updUser, 2, "U", rsvNo, judClassCd, itemName, "", "", beforePolRemark2, polRemark2);
            }

            // 二次検査診断名（疾患）変更履歴（変更後） Start
            itemName = "診断名（疾患）";
            foreach (var rec in afterItems)
            {
                if (!string.IsNullOrEmpty(rec["result"]))
                {
                    InsertFollow_Log(updUser, 2, "I", rsvNo, judClassCd, itemName, rec["itemcd"], rec["suffix"], "", rec["result"]);
                }
            }
        }

        /// <summary>
        /// 指定予約番号、判定分類、SEQのフォローアップ結果情報を削除します。
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="seq">SEQ</param>
        /// <param name="updUser">更新者</param>
        public void DeleteFollow_Rsl(int rsvNo, int judClassCd, int seq, string updUser)
        {
            string stmt; // SQLステートメント
            string stmt2; // SQLステートメント2
            string stmt3; // SQLステートメント3

            IList<dynamic> beforeItems = new List<dynamic>();

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("judclasscd", judClassCd);
            param.Add("seq", seq);
            param.Add("upduser", updUser);

            // 指定予約番号・検査項目（判定分類）のフォロー情報を取得する
            stmt = @"
                select
                    follow_rsl.seccsldate
                    , follow_rsl.testus
                    , follow_rsl.testct
                    , follow_rsl.testmri
                    , follow_rsl.testbf
                    , follow_rsl.testgf
                    , follow_rsl.testcf
                    , follow_rsl.testem
                    , follow_rsl.testtm
                    , follow_rsl.testetc
                    , follow_rsl.testremark
                    , follow_rsl.resultdiv
                    , follow_rsl.disremark
                    , follow_rsl.polwithout
                    , follow_rsl.polfollowup
                    , follow_rsl.polmonth
                    , follow_rsl.polreexam
                    , follow_rsl.poldiagst
                    , follow_rsl.poldiag
                    , follow_rsl.poletc1
                    , follow_rsl.polremark1
                    , follow_rsl.polsugery
                    , follow_rsl.polendoscope
                    , follow_rsl.polchemical
                    , follow_rsl.polradiation
                    , follow_rsl.polreferst
                    , follow_rsl.polrefer
                    , follow_rsl.poletc2
                    , follow_rsl.testrefer
                    , follow_rsl.testrefertext
                    , follow_rsl.polremark2
                from
                    follow_rsl
                where
                    follow_rsl.rsvno = :rsvno
                    and follow_rsl.judclasscd = :judclasscd
                    and follow_rsl.seq = :seq for update
            ";

            dynamic beforeData = connection.Query(stmt, param).FirstOrDefault();

            if (beforeData != null)
            {
                // 疾患（診断名）情報削除前変更履歴登録のため結果取得
                stmt2 = @"
                    select
                        last.rsvno as rsvno
                        , last.judclasscd as judclasscd
                        , last.itemcd as itemcd
                        , last.suffix as suffix
                        , last.itemname as itemcdname
                        , sentence.longstc as result
                    from
                        (
                            select
                                follow_rsl_i.rsvno as rsvno
                                , follow_rsl_i.judclasscd as judclasscd
                                , follow_rsl_i.itemcd as itemcd
                                , follow_rsl_i.suffix as suffix
                                , item_c.itemtype as itemtype
                                , item_c.stcitemcd as stcitemcd
                                , follow_rsl_i.result as result
                                , item_c.itemname as itemname
                            from
                                follow_rsl_i
                                , item_c
                            where
                                follow_rsl_i.rsvno = :rsvno
                                and follow_rsl_i.judclasscd = :judclasscd
                                and follow_rsl_i.seq = :seq
                                and follow_rsl_i.itemcd = item_c.itemcd
                                and follow_rsl_i.suffix = item_c.suffix
                        ) last
                        , sentence
                    where
                        last.stcitemcd = sentence.itemcd(+)
                        and last.itemtype = sentence.itemtype(+)
                        and last.result = sentence.stccd(+)
                ";

                beforeItems = connection.Query(stmt2, param).ToList();
            }

            // 二次検査結果別疾患情報削除
            stmt = @"
                delete
                from
                    follow_rsl_i
                where
                    rsvno = :rsvno
                    and judclasscd = :judclasscd
                    and seq = :seq
            ";

            connection.Execute(stmt, param);

            // 二次検査結果情報削除
            stmt = @"
                delete
                from
                    follow_rsl
                where
                    rsvno = :rsvno
                    and judclasscd = :judclasscd
                    and seq = :seq
            ";

            connection.Execute(stmt, param);

            // フォローアップ情報の更新日、更新者変更
            stmt3 = @"
                update follow_info
                set
                    upddate = sysdate
                    , upduser = :upduser
                where
                    rsvno = :rsvno
                    and judclasscd = :judclasscd
            ";

            connection.Execute(stmt3, param);

            // 新規登録の場合はLOG出力

            string itemName = "二次検査年月日";
            if (DateTime.TryParse(Convert.ToString(beforeData.SECCSLDATE), out DateTime wkSecCslDate))
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", wkSecCslDate, null);
            }

            // 検査方法登録履歴
            itemName = "検査方法";
            if (beforeData.TESTUS != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "US", "");
            }

            if (beforeData.TESTCT != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "CT", "");
            }

            if (beforeData.TESTMRI != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "MRI", "");
            }

            if (beforeData.TESTBF != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "BF", "");
            }

            if (beforeData.TESTGF != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "GF", "");
            }

            if (beforeData.TESTCF != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "CF", "");
            }

            if (beforeData.TESTEM != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "注腸", "");
            }

            if (beforeData.TESTTM != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "腫瘍マーカー", "");
            }

            if (beforeData.TESTETC != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "その他", "");
            }

            if (beforeData.TESTREMARK != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", beforeData.TESTREMARK, "");
            }

            if (beforeData.TESTREFER != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "リファー", "");
            }

            if (beforeData.TESTREFERTEXT != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", beforeData.TESTREFERTEXT, "");
            }

            // 二次検査結果区分登録履歴
            itemName = "二次検査結果";
            string resultDivName = "";
            if (beforeData.RESULTDIV != null)
            {
                switch (Convert.ToInt32(beforeData.RESULTDIV))
                {
                    case 1:
                        resultDivName = "異常なし";
                        break;
                    case 2:
                        resultDivName = "不明";
                        break;
                    case 3:
                        resultDivName = "所見あり";
                        break;
                }

                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", resultDivName, "");
            }

            itemName = "その他疾患";
            if (beforeData.DISREMARK != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", Convert.ToString(beforeData.DISREMARK), "");
            }

            // 二次検査方針登録履歴
            itemName = "方針（治療なし）";
            if (beforeData.POLWITHOUT != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "処置不要", "");
            }

            if (beforeData.POLFOLLOWUP != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "経過観察", "");
            }

            if (beforeData.POLMONTH != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", Convert.ToInt32(beforeData.POLMONTH), null);
            }

            if (beforeData.POLREEXAM != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "１年後健診", "");
            }

            if (beforeData.POLDIAGST != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "本院紹介（精査）", "");
            }

            if (beforeData.POLDIAG != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "他院紹介（精査）", "");
            }

            if (beforeData.POLETC1 != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "その他（治療なし）", "");
            }

            if (beforeData.POLREMARK1 != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", Convert.ToString(beforeData.POLREMARK1), "");
            }

            itemName = "方針（治療あり）";
            if (beforeData.POLSUGERY != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "外科治療", "");
            }

            if (beforeData.POLENDOSCOPE != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "内視鏡的治療", "");
            }

            if (beforeData.POLCHEMICAL != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "化学療法", "");
            }

            if (beforeData.POLRADIATION != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "放射線治療", "");
            }

            if (beforeData.POLREFERST != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "本院紹介（治療）", "");
            }

            if (beforeData.POLREFER != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "他院紹介（治療）", "");
            }

            if (beforeData.POLETC2 != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "その他（治療あり）", "");
            }

            if (beforeData.POLREMARK2 != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", Convert.ToString(beforeData.POLREMARK2), "");
            }

            // 二次検査診断名（疾患）登録履歴
            itemName = "診断名（疾患）";
            foreach (var rec in beforeItems)
            {
                if (rec.RESULT != null)
                {
                    InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, rec.ITEMCD, rec.SUFFIX, rec.RESULT, "");
                }
            }
        }

        /// <summary>
        /// 受診者・検査項目毎に二次検査実施区分（医療施設区分）、判定結果を一括で登録・変更
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">検査項目（判定分類）</param>
        /// <param name="secEquipDiv">二次検査実施区分（医療施設区分）</param>
        /// <param name="judCd">判定結果</param>
        /// <param name="updUser">更新者</param>
        public void InsertFollow_Info(int[] rsvNo, int[] judClassCd, string[] secEquipDiv, string[] judCd, string updUser)
        {
            string stmt; // SQLステートメント
            string stmt2; // SQLステートメント2
            string stmt3; // SQLステートメント3

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", null);
            param.Add("judclasscd", null);
            param.Add("secequipdiv", null);
            param.Add("judcd", null);
            param.Add("upduser", updUser);

            // 指定予約番号の判定分類(検査項目)別フォロー情報を取得する
            stmt = @"
                select
                    rsvno
                    , judclasscd
                    , secequipdiv
                    , judcd
                from
                    follow_info
                where
                    rsvno = :rsvno
                    and judclasscd = :judclasscd
            ";

            // 指定予約番号の判定分類(検査項目)別フォロー情報と判定結果を挿入
            stmt2 = @"
                insert
                into follow_info(
                    rsvno
                    , judclasscd
                    , secequipdiv
                    , adduser
                    , upduser
                    , judcd
                )
                values (
                    :rsvno
                    , :judclasscd
                    , :secequipdiv
                    , :upduser
                    , :upduser
                    , :judcd
                )
            ";

            // 指定予約番号の判定分類(検査項目)別フォロー情報と判定結果を更新
            stmt3 = @"
                update follow_info
                set
                    secequipdiv = :secequipdiv
                    , judcd = :judcd
                    , upduser = :upduser
                where
                    rsvno = :rsvno
                    and judclasscd = :judclasscd
            ";

            // 件数ループ
            for (var i = 0; i < rsvNo.Length; i++)
            {
                if ((secEquipDiv[i] == "0") || (secEquipDiv[i] == "1") || (secEquipDiv[i] == "2") || (secEquipDiv[i] == "3") || (secEquipDiv[i] == "9"))
                {
                    param["rsvno"] = rsvNo[i];
                    param["judclasscd"] = judClassCd[i];
                    param["secequipdiv"] = secEquipDiv[i];
                    param["judcd"] = judCd[i];

                    // 指定予約番号の判定分類別フォロー情報登録有無チェック
                    dynamic data = connection.Query(stmt, param).FirstOrDefault();

                    if (data == null)
                    {
                        // フォロー情報と判定結果を挿入
                        connection.Execute(stmt2, param);

                        // 挿入の場合はLOG出力
                        string itemName = "二次検査施設区分";
                        string beforeSecEquipDivName = "";
                        string secEquipDivName = "";
                        switch (secEquipDiv[i])
                        {
                            case "0":
                                secEquipDivName = "二次検査場所未定";
                                break;
                            case "1":
                                secEquipDivName = "当センター";
                                break;
                            case "2":
                                secEquipDivName = "本院";
                                break;
                            case "3":
                                secEquipDivName = "他院";
                                break;
                            case "9":
                                secEquipDivName = "対象外";
                                break;
                        }

                        InsertFollow_Log(updUser, 1, "I", rsvNo[i], judClassCd[i], itemName, "", "", beforeSecEquipDivName, secEquipDivName);

                        itemName = "判定分類";
                        string beforeJudCd = "";
                        InsertFollow_Log(updUser, 1, "I", rsvNo[i], judClassCd[i], itemName, "", "", beforeJudCd, judCd[i]);

                    }
                    else
                    {
                        // 変更ログ記録の為変更前データ取得
                        string beforeSecEquipdiv = Convert.ToString(data.SECEQUIPDIV);
                        string beforeJudCd = Convert.ToString(data.JUDCD);

                        // フォロー情報と判定結果を更新
                        connection.Execute(stmt3, param);

                        // 更新前と更新後で値が違う場合はLOG出力
                        string itemName = "二次検査施設区分";
                        string beforeSecEquipDivName = "";
                        string secEquipDivName = "";
                        if (beforeSecEquipdiv != secEquipDiv[i])
                        {
                            switch (beforeSecEquipdiv)
                            {
                                case "0":
                                    beforeSecEquipDivName = "二次検査場所未定";
                                    break;
                                case "1":
                                    beforeSecEquipDivName = "当センター";
                                    break;
                                case "2":
                                    beforeSecEquipDivName = "本院";
                                    break;
                                case "3":
                                    beforeSecEquipDivName = "他院";
                                    break;
                                case "9":
                                    beforeSecEquipDivName = "対象外";
                                    break;
                            }

                            switch (secEquipDiv[i])
                            {
                                case "0":
                                    secEquipDivName = "二次検査場所未定";
                                    break;
                                case "1":
                                    secEquipDivName = "当センター";
                                    break;
                                case "2":
                                    secEquipDivName = "本院";
                                    break;
                                case "3":
                                    secEquipDivName = "他院";
                                    break;
                                case "9":
                                    secEquipDivName = "対象外";
                                    break;
                            }

                            InsertFollow_Log(updUser, 1, "U", rsvNo[i], judClassCd[i], itemName, "", "", beforeSecEquipDivName, secEquipDivName);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// 指定予約番号のフォローアップ情報を更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="secEquipDiv">二次検査実施区分</param>
        /// <param name="updUser">更新者</param>
        /// <param name="judCd">判定コード</param>
        /// <param name="statusCd">ステータス</param>
        /// <param name="secEquipName">病医院名</param>
        /// <param name="secEquipCourse">診療科</param>
        /// <param name="secDoctor">担当医師</param>
        /// <param name="secEquipAddr">病医院住所</param>
        /// <param name="secEquipTel">病医院電話番号</param>
        /// <param name="secPlanDate">二次検査予定日</param>
        /// <param name="rsvTestUS">二次検査予約項目 US</param>
        /// <param name="rsvTestCT">二次検査予約項目 CT</param>
        /// <param name="rsvTestMRI">二次検査予約項目 MRI</param>
        /// <param name="rsvTestBF">二次検査予約項目 BF</param>
        /// <param name="rsvTestGF">二次検査予約項目 GF</param>
        /// <param name="rsvTestCF">二次検査予約項目 CF</param>
        /// <param name="rsvTestEM">二次検査予約項目 注腸</param>
        /// <param name="rsvTestTM">二次検査予約項目 腫瘍マーカー</param>
        /// <param name="rsvTestEtc">二次検査予約項目 その他</param>
        /// <param name="rsvTestRemark">二次検査予約項目 その他コメント</param>
        /// <param name="rsvTestRefer">二次検査予約項目 リファー</param>
        /// <param name="rsvTestReferText">二次検査予約項目 リファー科</param>
        /// <param name="secRemark">備考</param>
        public void UpdateFollow_Info(
            int rsvNo,
            int judClassCd,
            int secEquipDiv,
            string updUser,
            string judCd,
            int? statusCd,
            string secEquipName,
            string secEquipCourse,
            string secDoctor,
            string secEquipAddr,
            string secEquipTel,
            DateTime? secPlanDate,
            int? rsvTestUS,
            int? rsvTestCT,
            int? rsvTestMRI,
            int? rsvTestBF,
            int? rsvTestGF,
            int? rsvTestCF,
            int? rsvTestEM,
            int? rsvTestTM,
            int? rsvTestEtc,
            string rsvTestRemark,
            int? rsvTestRefer,
            string rsvTestReferText,
            string secRemark
        )
        {
            string itemName = null; // 変更履歴項目名

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("judclasscd", judClassCd);
            param.Add("secequipdiv", secEquipDiv);
            param.Add("upduser", updUser);
            param.Add("judcd", judCd);
            param.Add("statuscd", statusCd);
            param.Add("secequipname", secEquipName);
            param.Add("secequipcourse", secEquipCourse);
            param.Add("secdoctor", secDoctor);
            param.Add("secequipaddr", secEquipAddr);
            param.Add("secequiptel", secEquipTel);
            param.Add("secplandate", secPlanDate);
            param.Add("rsvtestus", rsvTestUS);
            param.Add("rsvtestct", rsvTestCT);
            param.Add("rsvtestmri", rsvTestMRI);
            param.Add("rsvtestbf", rsvTestBF);
            param.Add("rsvtestgf", rsvTestGF);
            param.Add("rsvtestcf", rsvTestCF);
            param.Add("rsvtestem", rsvTestEM);
            param.Add("rsvtesttm", rsvTestTM);
            param.Add("rsvtestetc", rsvTestEtc);
            param.Add("rsvtestremark", rsvTestRemark);
            param.Add("rsvtestrefer", rsvTestRefer);
            param.Add("rsvtestrefertext", rsvTestReferText);
            param.Add("secremark", secRemark);

            // 指定予約番号・検査項目（判定分類）のフォロー情報を取得する
            var sql = @"
                select
                    follow_info.secequipdiv
                    , follow_info.judcd
                    , follow_info.statuscd
                    , follow_info.secequipname
                    , follow_info.secequipcourse
                    , follow_info.secdoctor
                    , follow_info.secequipaddr
                    , follow_info.secequiptel
                    , follow_info.secplandate
                    , follow_info.secremark
                    , follow_info.rsvtestus
                    , follow_info.rsvtestct
                    , follow_info.rsvtestmri
                    , follow_info.rsvtestbf
                    , follow_info.rsvtestgf
                    , follow_info.rsvtestcf
                    , follow_info.rsvtestem
                    , follow_info.rsvtesttm
                    , follow_info.rsvtestetc
                    , follow_info.rsvtestremark
                    , follow_info.rsvtestrefer
                    , follow_info.rsvtestrefertext
                from
                    follow_info
                where
                    follow_info.rsvno = :rsvno
                    and follow_info.judclasscd = :judclasscd
            ";

            dynamic beforeData = connection.Query(sql, param).FirstOrDefault();

            if (beforeData == null)
            {
                sql = @"
                    insert
                    into follow_info(
                        rsvno
                        , judclasscd
                        , secequipdiv
                        , adddate
                        , adduser
                        , upddate
                        , upduser
                        , judcd
                        , statuscd
                        , secequipname
                        , secequipcourse
                        , secdoctor
                        , secequipaddr
                        , secequiptel
                        , secplandate
                        , rsvtestus
                        , rsvtestct
                        , rsvtestmri
                        , rsvtestbf
                        , rsvtestgf
                        , rsvtestcf
                        , rsvtestem
                        , rsvtesttm
                        , rsvtestetc
                        , rsvtestremark
                        , rsvtestrefer
                        , rsvtestrefertext
                        , secremark
                    )
                    values (
                        :rsvno
                        , :judclasscd
                        , :secequipdiv
                        , sysdate
                        , :upduser
                        , sysdate
                        , :upduser
                        , :judcd
                        , :statuscd
                        , :secequipname
                        , :secequipcourse
                        , :secdoctor
                        , :secequipaddr
                        , :secequiptel
                        , :secplandate
                        , :rsvtestus
                        , :rsvtestct
                        , :rsvtestmri
                        , :rsvtestbf
                        , :rsvtestgf
                        , :rsvtestcf
                        , :rsvtestem
                        , :rsvtesttm
                        , :rsvtestetc
                        , :rsvtestremark
                        , :rsvtestrefer
                        , :rsvtestrefertext
                        , :secremark
                    )
                ";

                connection.Execute(sql, param);
            }
            else
            {
                sql = @"
                    update follow_info
                    set
                        secequipdiv = :secequipdiv
                        , judcd = :judcd
                        , statuscd = :statuscd
                        , secequipname = :secequipname
                        , secequipcourse = :secequipcourse
                        , secdoctor = :secdoctor
                        , secequipaddr = :secequipaddr
                        , secequiptel = :secequiptel
                        , secplandate = :secplandate
                        , rsvtestus = :rsvtestus
                        , rsvtestct = :rsvtestct
                        , rsvtestmri = :rsvtestmri
                        , rsvtestbf = :rsvtestbf
                        , rsvtestgf = :rsvtestgf
                        , rsvtestcf = :rsvtestcf
                        , rsvtestem = :rsvtestem
                        , rsvtesttm = :rsvtesttm
                        , rsvtestetc = :rsvtestetc
                        , rsvtestremark = :rsvtestremark
                        , rsvtestrefer = :rsvtestrefer
                        , rsvtestrefertext = :rsvtestrefertext
                        , secremark = :secremark
                        , upddate = sysdate
                        , upduser = :upduser
                    where
                        rsvno = :rsvno
                        and judclasscd = :judclasscd
                ";

                connection.Execute(sql, param);

                // 更新前と更新後で値が違う場合はLOG出力
                int beforeSecEquipDiv = Convert.ToInt32(beforeData.SECEQUIPDIV);
                if (beforeSecEquipDiv != secEquipDiv)
                {
                    itemName = "二次検査施設区分";
                    string beforeSecEquipDivName = "";
                    string secEquipDivName = "";

                    switch (beforeSecEquipDiv)
                    {
                        case 0:
                            beforeSecEquipDivName = "二次検査場所未定";
                            break;
                        case 1:
                            beforeSecEquipDivName = "当センター";
                            break;
                        case 2:
                            beforeSecEquipDivName = "本院";
                            break;
                        case 3:
                            beforeSecEquipDivName = "他院";
                            break;
                        case 9:
                            beforeSecEquipDivName = "対象外";
                            break;
                    }

                    switch (secEquipDiv)
                    {
                        case 0:
                            secEquipDivName = "二次検査場所未定";
                            break;
                        case 1:
                            secEquipDivName = "当センター";
                            break;
                        case 2:
                            secEquipDivName = "本院";
                            break;
                        case 3:
                            secEquipDivName = "他院";
                            break;
                        case 9:
                            secEquipDivName = "対象外";
                            break;
                    }

                    InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", beforeSecEquipDivName, secEquipDivName);
                }

                // 判定結果
                string beforeJudCd = Convert.ToString(beforeData.JUDCD);
                if (beforeJudCd != judCd)
                {
                    itemName = "判定結果";
                    InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", beforeJudCd, judCd);
                }

                // 二次検査ステータス
                int beforeStatusCd = Convert.ToInt32(beforeData.STATUSCD);
                if (beforeStatusCd != statusCd)
                {
                    itemName = "二次検査ステータス";
                    string beforeStatusName = "";
                    string statusName = "";

                    switch (beforeStatusCd)
                    {
                        case 11:
                            beforeStatusName = "診断確定：異常なし";
                            break;
                        case 12:
                            beforeStatusName = "診断確定：異常あり";
                            break;
                        case 21:
                            beforeStatusName = "診断未確定(受診施設)：センター";
                            break;
                        case 22:
                            beforeStatusName = "診断未確定(受診施設)：本院";
                            break;
                        case 23:
                            beforeStatusName = "診断未確定(受診施設)：他院";
                            break;
                        case 29:
                            beforeStatusName = "診断未確定(受診施設)：その他（未定・不明）";
                            break;
                        case 99:
                            beforeStatusName = "その他(フォローアップ登録終了)";
                            break;
                    }

                    switch (statusCd)
                    {
                        case 11:
                            statusName = "診断確定：異常なし";
                            break;
                        case 12:
                            statusName = "診断確定：異常あり";
                            break;
                        case 21:
                            statusName = "診断未確定(受診施設)：センター";
                            break;
                        case 22:
                            statusName = "診断未確定(受診施設)：本院";
                            break;
                        case 23:
                            statusName = "診断未確定(受診施設)：他院";
                            break;
                        case 29:
                            statusName = "診断未確定(受診施設)：その他（未定・不明）";
                            break;
                        case 99:
                            statusName = "その他(フォローアップ登録終了)";
                            break;
                    }

                    InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", beforeStatusName, statusName);
                }

                // 二次検査予定日
                DateTime? beforeSecPlanDate = beforeData.SECPLANDATE != null ? DateTime.Parse(Convert.ToString(beforeData.SECPLANDATE)) : null;
                if (beforeSecPlanDate != secPlanDate)
                {
                    itemName = "二次検査予定日";
                    InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", beforeSecPlanDate, secPlanDate);
                }

                itemName = "検査方法";

                int? beforeRsvTestUS = beforeData.RSVTESTUS != null ? Convert.ToInt32(beforeData.RSVTESTUS) : null;
                if (beforeRsvTestUS != rsvTestUS)
                {
                    if (beforeRsvTestUS != null)
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "US", "");
                    }
                    else
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "", "US");
                    }
                }

                int? beforeRsvTestCT = beforeData.RSVTESTCT != null ? Convert.ToInt32(beforeData.RSVTESTCT) : null;
                if (beforeRsvTestCT != rsvTestCT)
                {
                    if (beforeRsvTestCT != null)
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "CT", "");
                    }
                    else
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "", "CT");
                    }
                }

                int? beforeRsvTestMRI = beforeData.RSVTESTMRI != null ? Convert.ToInt32(beforeData.RSVTESTMRI) : null;
                if (beforeRsvTestMRI != rsvTestMRI)
                {
                    if (beforeRsvTestMRI != null)
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "MRI", "");
                    }
                    else
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "", "MRI");
                    }
                }

                int? beforeRsvTestBF = beforeData.RSVTESTBF != null ? Convert.ToInt32(beforeData.RSVTESTBF) : null;
                if (beforeRsvTestBF != rsvTestBF)
                {
                    if (beforeRsvTestBF != null)
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "BF", "");
                    }
                    else
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "", "BF");
                    }
                }

                int? beforeRsvTestGF = beforeData.RSVTESTGF != null ? Convert.ToInt32(beforeData.RSVTESTGF) : null;
                if (beforeRsvTestGF != rsvTestGF)
                {
                    if (beforeRsvTestGF != null)
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "GF", "");
                    }
                    else
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "", "GF");
                    }
                }

                int? beforeRsvTestCF = beforeData.RSVTESTCF != null ? Convert.ToInt32(beforeData.RSVTESTCF) : null;
                if (beforeRsvTestCF != rsvTestCF)
                {
                    if (beforeRsvTestCF != null)
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "CF", "");
                    }
                    else
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "", "CF");
                    }
                }

                int? beforeRsvTestEM = beforeData.RSVTESTEM != null ? Convert.ToInt32(beforeData.RSVTESTEM) : null;
                if (beforeRsvTestEM != rsvTestEM)
                {
                    if (beforeRsvTestEM != null)
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "注腸", "");
                    }
                    else
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "", "注腸");
                    }
                }

                int? beforeRsvTestTM = beforeData.RSVTESTTM != null ? Convert.ToInt32(beforeData.RSVTESTTM) : null;
                if (beforeRsvTestTM != rsvTestTM)
                {
                    if (beforeRsvTestTM != null)
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "腫瘍マーカー", "");
                    }
                    else
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "", "腫瘍マーカー");
                    }
                }

                int? beforeRsvTestEtc = beforeData.RSVTESTETC != null ? Convert.ToInt32(beforeData.RSVTESTETC) : null;
                if (beforeRsvTestEtc != rsvTestEtc)
                {
                    if (beforeRsvTestEtc != null)
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "その他", "");
                    }
                    else
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "", "その他");
                    }
                }

                string beforeRsvTestRemark = Convert.ToString(beforeData.RSVTESTREMARK);
                if (beforeRsvTestRemark != rsvTestRemark)
                {
                    if (!string.IsNullOrEmpty(beforeRsvTestRemark))
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", beforeRsvTestRemark, rsvTestRemark);
                    }
                    else
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "", rsvTestRemark);
                    }
                }

                int? beforeRsvTestRefer = beforeData.RSVTESTREFER != null ? Convert.ToInt32(beforeData.RSVTESTREFER) : null;
                if (beforeRsvTestRefer != rsvTestRefer)
                {
                    if (beforeRsvTestRefer != null)
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "リファー", "");
                    }
                    else
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "", "リファー");
                    }
                }

                string beforeRsvTestReferText = Convert.ToString(beforeData.RSVTESTREFERTEXT);
                if (beforeRsvTestReferText != rsvTestReferText)
                {
                    if (!string.IsNullOrEmpty(beforeRsvTestReferText))
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", beforeRsvTestReferText, rsvTestReferText);
                    }
                    else
                    {
                        InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "", rsvTestReferText);
                    }
                }

                // 病医院名
                string beforeSecEquipName = Convert.ToString(beforeData.SECEQUIPNAME);
                if (beforeSecEquipName != secEquipName)
                {
                    itemName = "病医院名";
                    InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", beforeSecEquipName, secEquipName);
                }

                // 診療科
                string beforeSecEquipCourse = Convert.ToString(beforeData.SECEQUIPCOURSE);
                if (beforeSecEquipCourse != secEquipCourse)
                {
                    itemName = "診療科";
                    InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", beforeSecEquipCourse, secEquipCourse);
                }

                // 担当医師
                string beforeSecDoctor = Convert.ToString(beforeData.SECDOCTOR);
                if (beforeSecDoctor != secDoctor)
                {
                    itemName = "医療機関担当医師";
                    InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", beforeSecDoctor, secDoctor);
                }

                // 住所
                string beforeSecEquipAddr = Convert.ToString(beforeData.SECEQUIPADDR);
                if (beforeSecEquipAddr != secEquipAddr)
                {
                    itemName = "医療機関住所";
                    InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", beforeSecEquipAddr, secEquipAddr);
                }

                // 電話番号
                string beforeSecEquipTel = Convert.ToString(beforeData.SECEQUIPTEL);
                if (beforeSecEquipTel != secEquipTel)
                {
                    itemName = "医療機関電話番号";
                    InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", beforeSecEquipTel, secEquipTel);
                }

                // 備考
                string beforeSecRemark = Convert.ToString(beforeData.SECREMARK);
                if (beforeSecRemark != secRemark)
                {
                    itemName = "備考";
                    InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", beforeSecRemark, secRemark);
                }
            }
        }

        /// <summary>
        /// 指定予約番号のフォロー情報を承認する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">検査項目（判定分類）</param>
        /// <param name="reqConfirmFlg">承認日付（承認解除の場合、空白（Null））</param>
        /// <param name="updUser">承認者</param>
        public void UpdateFollow_Info_Confirm(int rsvNo, int judClassCd, string reqConfirmFlg, string updUser)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("judclasscd", judClassCd);
            param.Add("reqconfirmdate", null);
            param.Add("reqconfirmuser", updUser);

            // 指定予約番号・フォロー情報（承認日）を取得する（変更履歴のため）
            var sql = @"
                select
                    follow_info.reqconfirmdate
                    , follow_info.reqconfirmuser
                from
                    follow_info
                where
                    follow_info.rsvno = :rsvno
                    and follow_info.judclasscd = :judclasscd
            ";

            dynamic data = connection.Query(sql, param).FirstOrDefault();

            if (data != null)
            {
                sql = @"
                    update follow_info
                    set
                ";

                if (reqConfirmFlg.Equals("0"))
                {
                    sql += @"
                        reqconfirmdate = null
                        , reqconfirmuser = null
                    ";
                }
                else
                {
                    sql += @"
                        reqconfirmdate = sysdate
                        , reqconfirmuser = :reqconfirmuser
                    ";
                }

                sql += @"
                    where
                        rsvno = :rsvno
                        and judclasscd = :judclasscd
                ";

                connection.Execute(sql, param);

                // 更新前と更新後で値が違う場合はLOG出力
                string itemName = null;
                if (reqConfirmFlg.Equals("0"))
                {
                    itemName = "承認取消";
                }
                else
                {
                    itemName = "結果承認";
                }

                // 承認処理については「結果承認」と「承認解除」のみ記録
                InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", "", "");
            }
        }

        /// <summary>
        /// 指定予約番号のフォロー情報の勧奨日を更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">検査項目（判定分類）</param>
        /// <param name="checkDate">勧奨日</param>
        /// <param name="reqCheckSeq">勧奨日区分（1:1次勧奨、2:2次勧奨）</param>
        /// <param name="reqCheckMode">勧奨日登録モード（1:勧奨、2:未勧奨）</param>
        /// <param name="updUser">更新者</param>
        public void UpdateFollow_Info_Kansho(int rsvNo, int judClassCd, DateTime? checkDate, int reqCheckSeq, int reqCheckMode, string updUser)
        {
            DateTime? reqCheckDate = null; // 勧奨日

            if (reqCheckMode == 1)
            {
                reqCheckDate = checkDate;
            }
            else if (reqCheckSeq == 2)
            {
                reqCheckDate = null;
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("judclasscd", judClassCd);
            param.Add("reqcheckdate", reqCheckDate);
            param.Add("upduser", updUser);

            // 指定予約番号・フォロー情報（承認日）を取得する（変更履歴のため）
            var sql = @"
                select
                    follow_info.reqcheckdate1
                    , follow_info.reqcheckdate2
                from
                    follow_info
                where
                    follow_info.rsvno = :rsvno
                    and follow_info.judclasscd = :judclasscd
            ";

            dynamic data = connection.Query(sql, param).FirstOrDefault();

            if (data != null)
            {
                sql = @"
                    update follow_info
                    set
                ";

                if (reqCheckMode == 1)
                {
                    sql += @"
                        reqcheckdate1 = :reqcheckdate
                    ";
                }
                else if (reqCheckMode == 2)
                {
                    sql += @"
                        reqcheckdate2 = :reqcheckdate
                    ";
                }

                sql += @"
                        , upduser = :upduser
                        , upddate = sysdate
                    where
                        rsvno = :rsvno
                        and judclasscd = :judclasscd
                ";

                connection.Execute(sql, param);

                DateTime? beforeReqCheckDate1 = data.REQCHECKDATE1 != null ? DateTime.Parse(Convert.ToString(data.REQCHECKDATE1)) : null;
                DateTime? beforeReqCheckDate2 = data.REQCHECKDATE2 != null ? DateTime.Parse(Convert.ToString(data.REQCHECKDATE2)) : null;

                // 勧奨日Log登録
                if ((reqCheckSeq == 1) && (beforeReqCheckDate1 != reqCheckDate))
                {
                    string itemName = "一次勧奨日";
                    InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", beforeReqCheckDate1, reqCheckDate);
                }

                if ((reqCheckSeq == 2) && (beforeReqCheckDate2 != reqCheckDate))
                {
                    string itemName = "二次勧奨日";
                    InsertFollow_Log(updUser, 1, "U", rsvNo, judClassCd, itemName, "", "", beforeReqCheckDate2, reqCheckDate);
                }
            }
        }

        /// <summary>
        /// 指定予約番号、判定分類のフォローアップ情報を削除する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="updUser">更新者</param>
        public void DeleteFollow_Info(int rsvNo, int judClassCd, string updUser)
        {
            string itemName = null; // 変更履歴項目名

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("irsvno", rsvNo);
            param.Add("ijudclasscd", judClassCd);
            param.Add("iseq", 0);

            // 指定予約番号・検査項目（判定分類）のフォロー情報を取得する
            var sql = @"
                select
                    follow_info.secequipdiv
                    , follow_info.judcd
                    , follow_info.statuscd
                    , follow_info.secequipname
                    , follow_info.secequipcourse
                    , follow_info.secdoctor
                    , follow_info.secequipaddr
                    , follow_info.secequiptel
                    , follow_info.secplandate
                    , follow_info.secremark
                    , follow_info.rsvtestus
                    , follow_info.rsvtestct
                    , follow_info.rsvtestmri
                    , follow_info.rsvtestbf
                    , follow_info.rsvtestgf
                    , follow_info.rsvtestcf
                    , follow_info.rsvtestem
                    , follow_info.rsvtesttm
                    , follow_info.rsvtestetc
                    , follow_info.rsvtestremark
                    , follow_info.rsvtestrefer
                    , follow_info.rsvtestrefertext
                from
                    follow_info
                where
                    follow_info.rsvno = :irsvno
                    and follow_info.judclasscd = :ijudclasscd
            ";

            dynamic beforeData = connection.Query(sql, param).FirstOrDefault();

            if (beforeData != null)
            {
                // 二次検査結果データ取得及び削除
                sql = @"
                    select
                        follow_rsl.rsvno
                        , follow_rsl.judclasscd
                        , follow_rsl.seq
                    from
                        follow_rsl
                    where
                        follow_rsl.rsvno = :irsvno
                        and follow_rsl.judclasscd = :ijudclasscd
                ";

                IList<dynamic> data2 = connection.Query(sql, param).ToList();

                foreach (var rec in data2)
                {
                    // 変更履歴を残す為、二次検査結果情報削除モジュールを1件ずつ呼び出して削除処理
                    DeleteFollow_Rsl(rec.RSVNO, rec.JUDCLASSCD, rec.SEQ, updUser);
                }
            }

            // フォローアップ情報削除
            var sql2 = @"
                delete
                from
                    follow_info
                where
                    rsvno = :irsvno
                    and judclasscd = :ijudclasscd
            ";

            connection.Execute(sql2, param);

            // 値が登録されている場合はLOG出力
            if (beforeData != null)
            {
                itemName = "二次検査施設区分";
                string beforeSecEquipDivName = "";

                int beforeSecEquipdiv = Convert.ToInt32(beforeData.SECEQUIPDIV);
                switch (beforeSecEquipdiv)
                {
                    case 0:
                        beforeSecEquipDivName = "二次検査場所未定";
                        break;
                    case 1:
                        beforeSecEquipDivName = "当センター";
                        break;
                    case 2:
                        beforeSecEquipDivName = "本院";
                        break;
                    case 3:
                        beforeSecEquipDivName = "他院";
                        break;
                    case 9:
                        beforeSecEquipDivName = "対象外";
                        break;
                }

                InsertFollow_Log(updUser, 1, "D", rsvNo, judClassCd, itemName, "", "", beforeSecEquipDivName, "");
            }

            // 判定結果
            string beforeJudCd = Convert.ToString(beforeData.JUDCD);
            if (!string.IsNullOrEmpty(beforeJudCd))
            {
                itemName = "判定結果";
                InsertFollow_Log(updUser, 1, "D", rsvNo, judClassCd, itemName, "", "", beforeJudCd, "");
            }

            // 二次検査ステータス
            int? beforeStatusCd = beforeData.STATUSCD != null ? Convert.ToInt32(beforeData.STATUSCD) : null;
            if (beforeStatusCd != null)
            {
                itemName = "二次検査ステータス";
                string beforeStatusName = "";
                switch (beforeStatusCd)
                {
                    case 11:
                        beforeStatusName = "診断確定：異常なし";
                        break;
                    case 12:
                        beforeStatusName = "診断確定：異常あり";
                        break;
                    case 21:
                        beforeStatusName = "診断未確定(受診施設)：センター";
                        break;
                    case 22:
                        beforeStatusName = "診断未確定(受診施設)：本院";
                        break;
                    case 23:
                        beforeStatusName = "診断未確定(受診施設)：他院";
                        break;
                    case 29:
                        beforeStatusName = "診断未確定(受診施設)：その他（未定・不明）";
                        break;
                    case 99:
                        beforeStatusName = "その他(フォローアップ登録終了)";
                        break;
                }

                InsertFollow_Log(updUser, 1, "D", rsvNo, judClassCd, itemName, "", "", beforeStatusName, "");
            }

            // 二次検査予定日
            DateTime? beforeSecPlanDate = beforeData.SECPLANDATE != null ? DateTime.Parse(Convert.ToString(beforeData.SECPLANDATE)) : null;
            if (beforeSecPlanDate != null)
            {
                itemName = "二次検査予定日";
                InsertFollow_Log(updUser, 1, "D", rsvNo, judClassCd, itemName, "", "", beforeSecPlanDate, null);
            }

            // 二次検査予定項目削除履歴
            itemName = "二次検査予定項目";

            int? beforeRsvTestUS = beforeData.RSVTESTUS != null ? Convert.ToInt32(beforeData.RSVTESTUS) : null;
            if (beforeRsvTestUS != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "US", "");
            }

            int? beforeRsvTestCT = beforeData.RSVTESTCT != null ? Convert.ToInt32(beforeData.RSVTESTCT) : null;
            if (beforeRsvTestCT != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "CT", "");
            }

            int? beforeRsvTestMRI = beforeData.RSVTESTMRI != null ? Convert.ToInt32(beforeData.RSVTESTMRI) : null;
            if (beforeRsvTestMRI != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "MRI", "");
            }

            int? beforeRsvTestBF = beforeData.RSVTESTBF != null ? Convert.ToInt32(beforeData.RSVTESTBF) : null;
            if (beforeRsvTestBF != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "BF", "");
            }

            int? beforeRsvTestGF = beforeData.RSVTESTGF != null ? Convert.ToInt32(beforeData.RSVTESTGF) : null;
            if (beforeRsvTestGF != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "GF", "");
            }

            int? beforeRsvTestCF = beforeData.RSVTESTCF != null ? Convert.ToInt32(beforeData.RSVTESTCF) : null;
            if (beforeRsvTestCF != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "CF", "");
            }

            int? beforeRsvTestEM = beforeData.RSVTESTEM != null ? Convert.ToInt32(beforeData.RSVTESTEM) : null;
            if (beforeRsvTestEM != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "注腸", "");
            }

            int? beforeRsvTestTM = beforeData.RSVTESTTM != null ? Convert.ToInt32(beforeData.RSVTESTTM) : null;
            if (beforeRsvTestTM != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "腫瘍マーカー", "");
            }

            int? beforeRsvTestEtc = beforeData.RSVTESTETC != null ? Convert.ToInt32(beforeData.RSVTESTETC) : null;
            if (beforeRsvTestEtc != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "その他", "");
            }

            string beforeRsvTestRemark = Convert.ToString(beforeData.RSVTESTREMARK);
            if (!string.IsNullOrEmpty(beforeRsvTestRemark))
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", beforeRsvTestRemark, "");
            }

            int? beforeRsvTestRefer = beforeData.RSVTESTREFER != null ? Convert.ToInt32(beforeData.RSVTESTREFER) : null;
            if (beforeRsvTestRefer != null)
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", "リファー", "");
            }

            string beforeRsvTestReferText = Convert.ToString(beforeData.RSVTESTREFERTEXT);
            if (!string.IsNullOrEmpty(beforeRsvTestReferText))
            {
                InsertFollow_Log(updUser, 2, "D", rsvNo, judClassCd, itemName, "", "", beforeRsvTestReferText, "");
            }

            // 病医院名
            string beforeSecEquipName = Convert.ToString(beforeData.SECEQUIPNAME);
            if (!string.IsNullOrEmpty(beforeSecEquipName))
            {
                itemName = "病医院名";
                InsertFollow_Log(updUser, 1, "D", rsvNo, judClassCd, itemName, "", "", beforeSecEquipName, "");
            }

            // 診療科
            string beforeSecEquipCourse = Convert.ToString(beforeData.SECEQUIPCOURSE);
            if (!string.IsNullOrEmpty(beforeSecEquipCourse))
            {
                itemName = "診療科";
                InsertFollow_Log(updUser, 1, "D", rsvNo, judClassCd, itemName, "", "", beforeSecEquipCourse, "");
            }

            // 担当医師
            string beforeSecDoctor = Convert.ToString(beforeData.SECDOCTOR);
            if (!string.IsNullOrEmpty(beforeSecDoctor))
            {
                itemName = "医療機関担当医師";
                InsertFollow_Log(updUser, 1, "D", rsvNo, judClassCd, itemName, "", "", beforeSecDoctor, "");
            }

            // 住所
            string beforeSecEquipAddr = Convert.ToString(beforeData.SECEQUIPADDR);
            if (!string.IsNullOrEmpty(beforeSecEquipAddr))
            {
                itemName = "医療機関住所";
                InsertFollow_Log(updUser, 1, "D", rsvNo, judClassCd, itemName, "", "", beforeSecEquipAddr, "");
            }

            // 電話番号
            string beforeSecEquipTel = Convert.ToString(beforeData.SECEQUIPTEL);
            if (!string.IsNullOrEmpty(beforeSecEquipTel))
            {
                itemName = "医療機関電話番号";
                InsertFollow_Log(updUser, 1, "D", rsvNo, judClassCd, itemName, "", "", beforeSecEquipTel, "");
            }

            // 備考
            string beforeSecRemark = Convert.ToString(beforeData.SECREMARK);
            if (!string.IsNullOrEmpty(beforeSecRemark))
            {
                itemName = "備考";
                InsertFollow_Log(updUser, 1, "D", rsvNo, judClassCd, itemName, "", "", beforeSecRemark, "");
            }
        }

        /// <summary>
        /// フォロー状況管理ログレコードを挿入します。
        /// </summary>
        /// <param name="updUser">更新者</param>
        /// <param name="updClass">更新分類</param>
        /// <param name="updDiv">処理区分</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="itemName">変更項目名称</param>
        /// <param name="itemCd">変更項目コード</param>
        /// <param name="suffix">変更サフィックス</param>
        /// <param name="before">変更前</param>
        /// <param name="after">変更後</param>
        public void InsertFollow_Log(
            string updUser,
            int updClass,
            string updDiv,
            int rsvNo,
            int? judClassCd,
            string itemName,
            string itemCd,
            string suffix,
            string before,
            string after
        )
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("lupduser", updUser);
            param.Add("lupdclass", updClass);
            param.Add("lupddiv", updDiv);
            param.Add("lrsvno", rsvNo);
            param.Add("ljudclasscd", judClassCd);
            param.Add("litemcd", itemCd);
            param.Add("lsuffix", suffix);
            param.Add("litemname", itemName);
            param.Add("lbefore", before);
            param.Add("lafter", after);

            var sql = @"
                insert
                into follow_update_log(
                    upddate
                    , upduser
                    , updclass
                    , upddiv
                    , rsvno
                    , judclasscd
                    , itemcd
                    , suffix
                    , itemname
                    , before
                    , after
                )
                values (
                    sysdate
                    , :lupduser
                    , :lupdclass
                    , :lupddiv
                    , :lrsvno
                    , :ljudclasscd
                    , :litemcd
                    , :lsuffix
                    , :litemname
                    , :lbefore
                    , :lafter
                )
            ";

            connection.Execute(sql, param);
        }

        /// <summary>
        /// フォロー状況管理ログレコードを挿入します。
        /// </summary>
        /// <param name="updUser">更新者</param>
        /// <param name="updClass">更新分類</param>
        /// <param name="updDiv">処理区分</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="itemName">変更項目名称</param>
        /// <param name="itemCd">変更項目コード</param>
        /// <param name="suffix">変更サフィックス</param>
        /// <param name="beforeValue">変更前</param>
        /// <param name="afterValue">変更後</param>
        public void InsertFollow_Log(
            string updUser,
            int updClass,
            string updDiv,
            int rsvNo,
            int? judClassCd,
            string itemName,
            string itemCd,
            string suffix,
            int? beforeValue,
            int? afterValue
        )
        {
            string wkBefore = Convert.ToString(beforeValue);
            string wkAfter = Convert.ToString(afterValue);

            InsertFollow_Log(updUser, updClass, updDiv, rsvNo, judClassCd, itemName, itemCd, suffix, wkBefore, wkAfter);
        }

        /// <summary>
        /// フォロー状況管理ログレコードを挿入します。
        /// </summary>
        /// <param name="updUser">更新者</param>
        /// <param name="updClass">更新分類</param>
        /// <param name="updDiv">処理区分</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="itemName">変更項目名称</param>
        /// <param name="itemCd">変更項目コード</param>
        /// <param name="suffix">変更サフィックス</param>
        /// <param name="beforeValue">変更前</param>
        /// <param name="afterValue">変更後</param>
        public void InsertFollow_Log(
            string updUser,
            int updClass,
            string updDiv,
            int rsvNo,
            int? judClassCd,
            string itemName,
            string itemCd,
            string suffix,
            DateTime? beforeValue,
            DateTime? afterValue
        )
        {
            string wkBefore = beforeValue != null ? ((DateTime)beforeValue).ToString("yyyy/mm/dd") : null;
            string wkAfter = afterValue != null ? ((DateTime)afterValue).ToString("yyyy/mm/dd") : null;

            InsertFollow_Log(updUser, updClass, updDiv, rsvNo, judClassCd, itemName, itemCd, suffix, wkBefore, wkAfter);
        }

        /// <summary>
        /// 指定検索条件の変更履歴を取得する
        /// </summary>
        /// <param name="startUpdDate">検索条件：更新日（開始）</param>
        /// <param name="endUpdDate">検索条件：更新日（終了）</param>
        /// <param name="searchUpdUser">検索条件：更新者</param>
        /// <param name="searchUpdClass">検索条件：更新分類（０：すべて）</param>
        /// <param name="orderbyItem">並べ替え項目(0:更新日,1:更新者,2:分類・項目）</param>
        /// <param name="orderbyMode">並べ替え方法(0:昇順,1:降順)</param>
        /// <param name="startPos">取得開始位置</param>
        /// <param name="pageMaxLine">１ページ表示ＭＡＸ行（０：ＭＡＸ行指定無し）</param>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>総レコード数と変更履歴リストとの組</returns>
        public PartialDataSet SelectFollowLogList(
            DateTime? startUpdDate,
            DateTime? endUpdDate,
            string searchUpdUser,
            string searchUpdClass,
            int orderbyItem,
            int orderbyMode,
            int startPos,
            int pageMaxLine,
            int? rsvNo = null
        )
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();

            // 日付未指定の場合、当日日付をセット　（aspの処理とつじつまを合わせるため）
            if (startUpdDate == null)
            {
                startUpdDate = DateTime.Now.Date;
            }

            if (endUpdDate == null)
            {
                endUpdDate = DateTime.Now.Date;
            }

            // 更新日　開始終了あり で開始終了逆
            if (startUpdDate > endUpdDate)
            {
                DateTime? wkDate = startUpdDate;
                startUpdDate = endUpdDate;
                endUpdDate = wkDate;
            }

            param.Add("supddate", startUpdDate);
            param.Add("eupddate", ((DateTime)endUpdDate).AddDays(1));

            // 検索条件の更新者設定有無チェック
            if (!string.IsNullOrEmpty(searchUpdUser))
            {
                param.Add("srcupduser", searchUpdUser.Trim());
            }

            // 検索条件の更新分類設定チェック
            if (string.IsNullOrEmpty(searchUpdClass) || (searchUpdClass.Equals("X")))
            {
                searchUpdClass = "999";
            }

            param.Add("srcupdclass", searchUpdClass);
            param.Add("startpos", startPos);
            if (pageMaxLine > 0)
            {
                param.Add("endpos", (startPos + pageMaxLine - 1));
            }

            string stmt_count = @"
                select
                    count(*) cnt
            ";

            string stmt_data = @"
                select
                    logview.upddate
                    , logview.upduser
                    , logview.updusername
                    , logview.updclass
                    , logview.upddiv
                    , logview.rsvno
                    , logview.judclasscd
                    , nvl(logview.judclassname, logview.judclasscd) judclassname
                    , logview.itemname
                    , logview.itemcd
                    , logview.suffix
                    , logview.itemcdname
                    , logview.before
                    , logview.after
            ";

            string stmt = @"
                from
                    (
                        select
                            rownum seq
                            , updatelogview.upddate
                            , updatelogview.upduser
                            , hainsuser.username updusername
                            , updatelogview.updclass
                            , updatelogview.upddiv
                            , updatelogview.rsvno
                            , updatelogview.judclasscd
                            , updatelogview.itemcd
                            , updatelogview.suffix
                            , judclass.judclassname
                            , updatelogview.itemname
                            , updatelogview.before
                            , updatelogview.after
                            , updatelogview.itemcdname
                        from
                            (
                                select
                                    follow_update_log.upddate
                                    , follow_update_log.upduser
                                    , follow_update_log.updclass
                                    , follow_update_log.upddiv
                                    , follow_update_log.rsvno
                                    , follow_update_log.judclasscd
                                    , follow_update_log.itemname
                                    , follow_update_log.itemcd
                                    , follow_update_log.suffix
                                    , follow_update_log.before
                                    , follow_update_log.after
                                    , nvl(item_c.itemname, '') as itemcdname
                                from
                                    follow_update_log
                                    , item_c
            ";

            int whereFlg = 0; // Where句開始有無フラグ

            stmt += @"
                                where
                                    follow_update_log.upddate between :supddate and :eupddate
                                    and follow_update_log.itemcd = item_c.itemcd(+)
                                    and follow_update_log.suffix = item_c.suffix(+)
            ";

            whereFlg = 1;

            // 検索条件の更新者チェック
            if (!string.IsNullOrEmpty(searchUpdUser))
            {
                stmt += @"
                                " + (whereFlg == 0 ? "where" : "and") + @" follow_update_log.upduser = :srcupduser
                ";

                whereFlg = 1;
            }

            // 検索条件の更新分類チェック
            if (!"999".Equals(searchUpdClass))
            {
                stmt += @"
                                " + (whereFlg == 0 ? "where" : "and") + @" follow_update_log.updclass = :srcupdclass
                ";

                whereFlg = 1;
            }

            // 検索条件の予約番号
            if (rsvNo > 0)
            {
                param.Add("srcrsvno", rsvNo);

                stmt += @"
                                " + (whereFlg == 0 ? "where" : "and") + @" follow_update_log.rsvno = :srcrsvno
                ";

                whereFlg = 1;
            }

            // 降順？
            string stmt2 = null;
            if (orderbyMode == 1)
            {
                stmt2 = @" desc, follow_update_log.updclass";
            }
            else
            {
                stmt2 = @" asc, follow_update_log.updclass";
            }

            // 並び替えの指定
            stmt += @"
                                order by ";

            switch (orderbyItem)
            {
                case 0:
                    // 更新日
                    stmt += "follow_update_log.upddate " + stmt2;
                    break;
                case 1:
                    // 更新者
                    stmt += "follow_update_log.upduser " + stmt2;
                    break;
                case 2:
                    // 分類・項目
                    stmt += " follow_update_log.updclass " + stmt2 + ", follow_update_log.judclasscd" + stmt2;
                    break;
                default:
                    stmt += " follow_update_log.upddate " + stmt2;
                    break;
            }

            stmt += @"
                            ) updatelogview
                            , judclass
                            , hainsuser
                        where
                            updatelogview.judclasscd = judclass.judclasscd(+)
                            and updatelogview.upduser = hainsuser.userid(+)
                    ) logview
            ";

            // 全件数取得
            stmt_count += stmt;

            dynamic data_count = connection.Query(stmt_count, param).FirstOrDefault();

            int totalCount = Convert.ToInt32(data_count.CNT);

            // 取得件数で絞込み
            stmt += @"
                where
                    logview.seq >= :startpos
            ";

            if (pageMaxLine > 0)
            {
                stmt += @"
                    and logview.seq <= :endpos
                ";
            }

            // データ取得
            stmt_data += stmt;

            IList<dynamic> data = connection.Query(stmt_data, param).ToList();

            return new PartialDataSet(totalCount, data);
        }

        /// <summary>
        /// 指定日付（受診日）範囲の勧奨対象者リスト取得する
        /// </summary>
        /// <param name="startCslDate">開始受診日</param>
        /// <param name="endCslDate">終了受診日</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="updUser">更新者</param>
        /// <param name="pastMonth">経過月数</param>
        /// <param name="tartPos">表示開始位置</param>
        /// <param name="pageMaxLine">１ページ表示ＭＡＸ行</param>
        /// <param name="checkDateStat">勧奨日条件チェック</param>
        /// <param name="countFlg">集計フラグ(true:予約番号が重複しない件数、false:レコード件数)</param>
        /// <returns>総レコード数と勧奨対象者リストとの組</returns>
        public PartialDataSet SelectExhortList(
            DateTime? startCslDate,
            DateTime? endCslDate,
            int? judClassCd,
            string updUser,
            int pastMonth,
            int tartPos,
            int pageMaxLine,
            string checkDateStat,
            bool countFlg = false
        )
        {
            // 受診日の設定
            while (true)
            {
                // 双方とも未指定の場合は何もしない
                if ((startCslDate == null) && (endCslDate == null))
                {
                    break;
                }

                // 一方が未指定の場合、もう一方の値と同値として扱う
                if ((startCslDate != null) && (endCslDate == null))
                {
                    endCslDate = startCslDate;
                    break;
                }

                if ((startCslDate == null) && (endCslDate != null))
                {
                    startCslDate = endCslDate;
                    break;
                }

                // 双方とも指定されている場合、大小逆転時に入れ替えを行う
                if (endCslDate < startCslDate)
                {
                    DateTime? wkDate = startCslDate;
                    startCslDate = endCslDate;
                    endCslDate = wkDate;
                    break;
                }

                break;
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("strcsldate", startCslDate);
            param.Add("endcsldate", endCslDate);
            param.Add("strpos", tartPos);
            param.Add("endpos", pageMaxLine + tartPos - 1);

            if (judClassCd != null)
            {
                param.Add("itemcd", judClassCd);
            }

            param.Add("month", pastMonth);

            if (updUser != "")
            {
                param.Add("upduser", updUser);
            }

            // 指定検索条件のフォロー対象者リストを取得する
            var sql = @"
                select
                    rownum seq
                    , final.csldate as csldate
                    , final.rsvno as rsvno
                    , final.perid as perid
                    , final.dayid as dayid
                    , person.lastkname || '　' || person.firstkname as perkname
                    , person.lastname || '　' || person.firstname as pername
                    , decode(person.gender, 1, '男', 2, '女') as gender
                    , trunc(final.age) as age
                    , to_char(
                        person.birth
                        , 'EYY.mm.dd'
                        , 'NLS_CALENDAR=''Japanese Imperial'''
                    ) as birth
                    , final.cscd as cscd
                    , final.judclasscd as judclasscd
                    , judclass.judclassname as judclassname
                    , final.judcd as judcd
                    , final.rsljudcd as rsljudcd
                    , judclass.resultdispmode 　　　　　　　　　　　　　as resultdispmode
                    , nvl(final.secequipdiv, '') as secequipdiv
                    , nvl(final.secplandate, '') as secplandate
                    , nvl(final.reqcheckdate1, '') as reqcheckdate1
                    , nvl(final.reqcheckdate2, '') as reqcheckdate2
                    , fol_get_secrsvexam(final.rsvno, final.judclasscd) as sectestname
                    , (
                        select
                            username
                        from
                            hainsuser
                        where
                            hainsuser.userid = final.adduser
                    ) as adduser
                    , decode(
                        fc_get_result(final.rsvno, '30910', '00')
                        , null
                        , '-'
                        , ''
                        , '-'
                        , fc_get_result(final.rsvno, '30910', '00')
                    ) as doc_jud
                    , decode(
                        fc_get_result(final.rsvno, '23320', '00')
                        , null
                        , '-'
                        , ''
                        , '-'
                        , fc_get_result(final.rsvno, '23320', '00')
                    ) as doc_gf
                    , decode(
                        fc_get_result(final.rsvno, '23550', '00')
                        , null
                        , '-'
                        , ''
                        , '-'
                        , fc_get_result(final.rsvno, '23550', '00')
                    ) as doc_cf
                from
                    (
                        select
                            consult.csldate as csldate
                            , consult.rsvno as rsvno
                            , consult.perid as perid
                            , consult.age as age
                            , consult.cscd as cscd
                            , receipt.dayid as dayid
                            , follow_info.judclasscd as judclasscd
                            , follow_info.judcd as judcd
                            , (
                                select
                                    judrsl.judcd
                                from
                                    judrsl
                                where
                                    judrsl.rsvno = follow_info.rsvno
                                    and judrsl.judclasscd = follow_info.judclasscd
                            ) as rsljudcd
                            , follow_info.secequipdiv as secequipdiv
                            , follow_info.secplandate as secplandate
                            , follow_info.reqcheckdate1 as reqcheckdate1
                            , follow_info.reqcheckdate2 as reqcheckdate2
                            , follow_info.adduser as adduser
                            , (
                                select
                                    count(follow_rsl.rsvno)
                                from
                                    follow_rsl
                                where
                                    follow_rsl.rsvno = follow_info.rsvno
                                    and follow_rsl.judclasscd = follow_info.judclasscd
                            ) as cntrsvno
                        from
                            consult
                            , receipt
                            , follow_info
                        where
                            consult.csldate between :strcsldate and :endcsldate
                            and consult.cancelflg = 0
                            and consult.rsvno = receipt.rsvno
                            and consult.rsvno = follow_info.rsvno
                            and follow_info.secequipdiv < 9
                            and follow_info.reqconfirmdate is null
            ";

            if (judClassCd != null)
            {
                sql += @"
                            and follow_info.judclasscd = :itemcd
                ";
            }

            if (!string.IsNullOrEmpty(updUser))
            {
                sql += @"
                            and follow_info.adduser = :upduser
                ";
            }

            // 勧奨日条件チェック
            if (checkDateStat.Trim().Equals("0"))
            {
                sql += @"
                            and follow_info.reqcheckdate1 is null
                            and follow_info.reqcheckdate2 is null
                ";
            }
            else if (checkDateStat.Trim().Equals("1"))
            {
                sql += @"
                            and follow_info.reqcheckdate1 is not null
                ";
            }
            else if (checkDateStat.Trim().Equals("2"))
            {
                sql += @"
                            and follow_info.reqcheckdate2 is not null
                ";
            }

            sql += @"
                        order by
                            consult.csldate
                            , receipt.dayid
                            , follow_info.judclasscd
                    ) final
                    , person
                    , judclass
                where
                    final.cntrsvno = 0
                    and final.perid = person.perid
                    and final.judclasscd = judclass.judclasscd
                order by
                    final.csldate
                    , final.dayid
                    , final.judclasscd
            ";

            // 最初にレコード件数だけ取得
            string stmt;
            if (countFlg)
            {
                stmt = @"
                    select
                        count(distinct rsvno) cnt
                    from
                        (" + sql + @")
                ";
            }
            else
            {
                stmt = @"
                    select
                        count(*) cnt
                    from
                        (" + sql + @")
                ";
            }

            dynamic data_count = connection.Query(stmt, param).FirstOrDefault();

            int totalCount = Convert.ToInt32(data_count.CNT);

            stmt = @"
                select
                    *
                from
                    (" + stmt + @")
            ";

            stmt += @"
                where seq between :strpos and :endpos
            ";

            IList<dynamic> data = connection.Query(stmt, param).ToList();

            return new PartialDataSet(totalCount, data);
        }

        /// <summary>
        /// 受診者別検査項目別結果データ取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <returns>予約番号（RsvNo）＋検査項目（ItemCd）別結果値</returns>
        public string GetResult(int rsvNo, string itemCd)
        {
            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("itemcd", itemCd);

            var sql = @"
                select
                    sentence.reptstc result
                    , perrsl.rslcmtname rslcmtname
                from
                    (
                        select
                            item_c.itemcd itemcd
                            , item_c.suffix suffix
                            , item_c.stcitemcd stcitemcd
                            , item_c.itemname itemname
                            , item_c.itemtype itemtype
                            , item_c.resulttype resulttype
                            , rsl.result result
                            , rslcmt.rslcmtname rslcmtname
                        from
                            rsl
                            , item_c
                            , rslcmt
                        where
                            rsl.rsvno = :rsvno
                            and rsl.itemcd = :itemcd
                            and rsl.itemcd = item_c.itemcd
                            and rsl.suffix = item_c.suffix
                            and rsl.rslcmtcd1 = rslcmt.rslcmtcd(+)
                    ) perrsl
                    , sentence
                where
                    perrsl.stcitemcd = sentence.itemcd(+)
                    and perrsl.itemtype = sentence.itemtype(+)
                    and perrsl.result = sentence.stccd(+)
            ";

            string[] data = connection.Query(sql, param).Where(rec => rec.RESULT != null).Select(rec => (string)rec.RESULT).ToArray();

            return data.Length > 0 ? string.Join("、", data) : "未検査";
        }

        #region "新設メソッド"
        /// <summary>
        /// フォローガイドの入力チェック
        /// </summary>
        /// <param name="secEquipName">病医院名</param>
        /// <param name="secEquipCourse">診療科</param>
        /// <param name="secDoctor">担当医師</param>
        /// <param name="secEquipAddr">住所</param>
        /// <param name="secEquipTel">電話番号</param>
        /// <param name="secRemark">備考</param>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> ValidateFollow_Info(string secEquipName, string secEquipCourse, string secDoctor, string secEquipAddr, string secEquipTel, string secRemark)
        {
            var messages = new List<string>();
            string message = null;

            // 病医院名
            message = WebHains.CheckWideValue("病医院名", secEquipName, 50);
            if (message != null)
            {
                messages.Add(message);
            }
            // 診療科
            message = WebHains.CheckWideValue("診療科", secEquipCourse, 50);
            if (message != null)
            {
                messages.Add(message);
            }
            // 担当医師
            message = WebHains.CheckWideValue("担当医師", secDoctor, 40);
            if (message != null)
            {
                messages.Add(message);
            }
            // 住所
            message = WebHains.CheckLength("住所", secEquipAddr, 120);
            if (message != null)
            {
                messages.Add(message);
            }
            // 電話番号
            message = WebHains.CheckLength("電話番号", secEquipTel, 15);
            if (message != null)
            {
                messages.Add(message);
            }
            // 備考(改行文字も1字として含む旨を通達)
            message = WebHains.CheckWideValue("備考", secRemark, 400);
            if (message != null)
            {
                messages.Add(message);
            }

            return messages;
        }

        /// <summary>
        /// フォローガイドの入力チェック
        /// </summary>
        /// <param name="polMonth">経過観察期間</param>
        /// <param name="testRemark">その他コメント（検査方法）</param>
        /// <param name="disRemark">その他疾患</param>
        /// <param name="polRemark1">その他コメント（治療なし）</param>
        /// <param name="polRemark2">その他コメント（治療あり）</param>
        /// <returns>エラーがあればエラーメッセージを返す</returns>
        public List<string> ValidateFollow_Rsl(string polMonth, string testRemark, string disRemark, string polRemark1, string polRemark2)
        {
            var messages = new List<string>();
            string message = null;

            // 経過観察期間
            message = WebHains.CheckNumeric("経過観察期間", polMonth, 2);
            if (message != null)
            {
                messages.Add(message);
            }
            // その他コメント（検査方法）
            message = WebHains.CheckLength("その他コメント（検査方法）", testRemark, 200);
            if (message != null)
            {
                messages.Add(message + "（改行文字も含みます）");
            }
            // その他疾患
            message = WebHains.CheckLength("その他疾患", disRemark, 200);
            if (message != null)
            {
                messages.Add(message + "（改行文字も含みます）");
            }
            // その他コメント（治療なし）
            message = WebHains.CheckLength("その他コメント（治療なし）", polRemark1, 200);
            if (message != null)
            {
                messages.Add(message + "（改行文字も含みます）");
            }
            // その他コメント（治療あり）
            message = WebHains.CheckLength("その他コメント（治療あり）", polRemark2, 200);
            if (message != null)
            {
                messages.Add(message + "（改行文字も含みます）");
            }

            return messages;
        }
        #endregion "新設メソッド"
    }
}
