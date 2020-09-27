using Dapper;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// メール送信用受診情報データアクセスオブジェクト
    /// </summary>
    public class MailConsultDao : AbstractDao
    {
        private const string ORGCD1_PERSON = "XXXXX";         // 個人受診
        private const string ORGCD2_PERSON = "XXXXX";         // 個人受診

        private const long RSVGRPCD_KIGYO1 = 50;              // 企業健診判定のための予約群コード1
        private const long RSVGRPCD_KIGYO2 = 51;              // 企業健診判定のための予約群コード2
        private const string OPTCD_KIGYO1 = "1000";           // 企業健診のコース名となる契約オプションのコード1
        private const string OPTCD_KIGYO2 = "1001";           // 企業健診のコース名となる契約オプションのコード2

        private const string GRPCD_STOMAC = "X502";           // 胃部受診項目判定用グループコード
        private const string FREECD_OPTIONS = "LST000021%";   // オプション検査名称取得用汎用テーブルレコードキー
        private const string FREECD_STOMAC = "LST000022%";    // 胃部受診項目名称取得用汎用テーブルレコードキー

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public MailConsultDao(IDbConnection connection) : base(connection)
        {

        }

        /// <summary>
        /// 受診情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// rsvno 予約番号
        /// csldate 受診日
        /// csname コース名
        /// csename 英語コース名
        /// strtime 開始時間
        /// endtime 終了時間
        /// perid 個人ID
        /// lastname 姓
        /// firstname 名
        /// lastkname カナ姓
        /// firstkname カナ名
        /// romename ローマ字名
        /// gender 性別
        /// birth 生年月日
        /// orgname 団体名称
        /// orgename 団体英語名称
        /// sendmaildiv 予約確認メール送信先
        /// email e-Mail
        /// perprice 個人負担金額
        /// price 受診金額
        /// </returns>
        public dynamic SelectConsult(string rsvNo)
        {
            string sql = "";                                // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("orgcd1_person", ORGCD1_PERSON);
            param.Add("orgcd2_person", ORGCD2_PERSON);
            param.Add("rsvgrpcd_kigyo1", RSVGRPCD_KIGYO1);
            param.Add("rsvgrpcd_kigyo2", RSVGRPCD_KIGYO2);
            param.Add("optcd_kigyo1", OPTCD_KIGYO1);
            param.Add("optcd_kigyo2", OPTCD_KIGYO2);

            // 指定予約番号の受診情報を取得
            sql = @"
                    select
                      consult.rsvno
                      , consult.csldate
                      , consult.perid
                      , consult.sendmaildiv
                      , org.orgname
                      , nvl(org.orgename, org.orgname) orgename
                      , person.lastname
                      , person.firstname
                      , person.lastkname
                      , person.firstkname
                      , person.romename
                      , person.gender
                      , person.birth
                      , peraddr.email
                      , rsvgrp.strtime
                      , rsvgrp.endtime
            ";

            // コース名の取得
            // ・予約群コードが50, 51(企業健診用の予約群)の場合、受診オプションのうちオプションコードが1000または1001のものを検索し、その名称を採用
            // ・それ以外は契約パターンのコース名を採用
            // (はがき、ご案内書のコース名取得処理と同一仕様)
            sql += @"
                        , case 
                          when consult.rsvgrpcd in (:rsvgrpcd_kigyo1, :rsvgrpcd_kigyo2) 
                            then ( 
                            select
                              optname 
                            from
                              ( 
                                select
                                  ctrpt_opt.optname 
                                from
                                  ctrpt_opt
                                  , consult_o 
                                where
                                  consult_o.rsvno = :rsvno 
                                  and consult_o.ctrptcd = ctrpt_opt.ctrptcd 
                                  and consult_o.optcd = ctrpt_opt.optcd 
                                  and consult_o.optbranchno = ctrpt_opt.optbranchno 
                                  and ctrpt_opt.optcd in (:optcd_kigyo1, :optcd_kigyo2) 
                                order by
                                  ctrpt_opt.ctrptcd
                                  , ctrpt_opt.optcd
                                  , ctrpt_opt.optbranchno
                              ) options 
                            where
                              rownum = 1
                          ) 
                          else ctrpt.csname 
                          end csname
            ";

            // 英語コース名の取得(契約パターンテーブルより取得)
            sql += @"
                        , nvl(ctrpt.csename, ctrpt.csname) csename 
            ";

            // 個人負担金額
            sql += @"
                        , ( 
                          select
                            nvl(sum(price + editprice + taxprice + edittax), 0) 
                          from
                            consult_m 
                          where
                            rsvno = consult.rsvno 
                            and orgcd1 = :orgcd1_person 
                            and orgcd2 = :orgcd2_person
                        ) perprice
            ";

            // 受診金額
            sql += @"
                        , ( 
                          select
                            nvl(sum(price + editprice + taxprice + edittax), 0) 
                          from
                            consult_m 
                          where
                            rsvno = consult.rsvno
                        ) price
            ";

            sql += @"
                    from
                      ctrpt
                      , rsvgrp
                      , org
                      , peraddr
                      , person
                      , consult
            ";

            sql += @"
                    where
                      consult.rsvno = :rsvno 
                      and consult.perid = person.perid 
                      and consult.perid = peraddr.perid(+) 
                      and consult.sendmaildiv = peraddr.addrdiv(+) 
                      and consult.orgcd1 = org.orgcd1 
                      and consult.orgcd2 = org.orgcd2 
                      and consult.rsvgrpcd = rsvgrp.rsvgrpcd 
                      and consult.ctrptcd = ctrpt.ctrptcd
            ";

            // 戻り値の設定
            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 検索条件を満たす受診者の一覧を取得する(予約確認メール送信用受診者検索)
        /// </summary>
        /// <param name="strCslDate">開始受診日</param>
        /// <param name="endCslDate">終了受診日</param>
        /// <param name="csCd">コースコード</param>
        /// <param name="orgCd1">団体コード1</param>
        /// <param name="orgCd2">団体コード2</param>
        /// <param name="perId">個人ID</param>
        /// <param name="status">状態(1:未送信、2:送信済み)</param>
        /// <returns>
        /// rsvno 予約番号
        /// csldate 受診日
        /// csname コース名
        /// webcolor webカラー
        /// rsvgrpname 予約群名称
        /// perid 個人ID
        /// lastname 姓
        /// firstname 名
        /// lastkname カナ姓
        /// firstkname カナ名
        /// gender 性別
        /// birth 生年月日
        /// age 受診時年齢
        /// orgsname 団体略称
        /// sendmaildiv 予約確認メール送信先
        /// email e-Mail
        /// sendmaildate 予約確認メール送信日時
        /// </returns>
        public List<dynamic> SelectConsultList(DateTime strCslDate, DateTime endCslDate, string csCd, string orgCd1, string orgCd2, string perId, long status)
        {
            string sql = "";                                // SQLステートメント
            DateTime date = DateTime.Now;                           // 作業用の日付

            // 受診日の設定（大小逆転時に入れ替えを行う）
            if (endCslDate < strCslDate)
            {
                date = strCslDate;
                strCslDate = endCslDate;
                endCslDate = date;
            }

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("strcsldate", strCslDate);
            param.Add("endcsldate", endCslDate);
            param.Add("cscd", (!string.IsNullOrEmpty(csCd) ? csCd : null));
            param.Add("orgcd1", (!string.IsNullOrEmpty(orgCd1) ? orgCd1 : null));
            param.Add("orgcd2", (!string.IsNullOrEmpty(orgCd2) ? orgCd2 : null));
            param.Add("perid", (!string.IsNullOrEmpty(perId) ? perId : null));

            // 指定条件を満たす受診情報を取得する
            sql = @"
                    select
                      consult.rsvno
                      , consult.csldate
                      , consult.perid
                      , trim(to_char(consult.age, '999.99')) age
                      , consult.sendmaildiv
                      , consult.sendmaildate
                      , org.orgsname
                      , person.lastname
                      , person.firstname
                      , person.lastkname
                      , person.firstkname
                      , person.gender
                      , person.birth
                      , peraddr.email
                      , course_p.webcolor
                      , course_p.csname
                      , rsvgrp.rsvgrpname
            ";

            sql += @"
                    from
                      rsvgrp
                      , course_p
                      , org
                      , peraddr
                      , person
                      , consult
            ";

            sql += @"
                    where
                      consult.csldate between :strcsldate and :endcsldate 
                      and consult.cscd = nvl(:cscd, consult.cscd) 
                      and consult.orgcd1 = nvl(:orgcd1, consult.orgcd1) 
                      and consult.orgcd2 = nvl(:orgcd2, consult.orgcd2) 
                      and consult.perid = nvl(:perid, consult.perid) 
                      and consult.perid = person.perid 
                      and consult.perid = peraddr.perid(+) 
                      and consult.sendmaildiv = peraddr.addrdiv(+) 
                      and consult.orgcd1 = org.orgcd1 
                      and consult.orgcd2 = org.orgcd2 
                      and consult.cscd = course_p.cscd 
                      and consult.rsvgrpcd = rsvgrp.rsvgrpcd
            ";

            // 状態による条件指定
            switch (status)
            {
                case 1:
                    sql += @"
                                and consult.sendmaildate is null
                    ";
                    break;
                case 2:
                    sql += @"
                                and consult.sendmaildate is not null            
                    ";
                    break;
            }

            sql += @"
                    order by
                      consult.csldate
                      , consult.cscd
                      , consult.rsvgrpcd
                      , consult.perid
                      , consult.rsvno
            ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// オプション検査名称を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// optionname オプション名称
        /// optionename オプション英語名称
        /// </returns>
        public List<dynamic> SelectOptionNameList(string rsvNo)
        {
            string sql = "";                                // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("freecd_options", FREECD_OPTIONS);

            // 指定予約番号の受診オプション情報を読み、かつ汎用テーブルからオプション検査名称を取得
            sql = @"
                    select
                      optionname
                      , optionename 
                    from
                      ( 
                        select
                          nvl(free.freefield2, setclass.setclassname) optionname
                          , nvl(free.freefield3, setclass.setclassname) optionename 
                        from
                          setclass
                          , free
                          , ( 
                            select distinct
                              ctrpt_opt.setclasscd 
                            from
                              ctrpt_opt
                              , consult_o 
                            where
                              consult_o.rsvno = :rsvno 
                              and consult_o.ctrptcd = ctrpt_opt.ctrptcd 
                              and consult_o.optcd = ctrpt_opt.optcd 
                              and consult_o.optbranchno = ctrpt_opt.optbranchno
                          ) setclasses 
                        where
                          free.freecd like :freecd_options 
                          and setclasses.setclasscd = free.freefield1 
                          and setclasses.setclasscd = setclass.setclasscd
                      ) optionnames 
                    order by
                      optionname
                      , optionename
            ";

            sql += @"
                    from
                      rsvgrp
                      , course_p
                      , org
                      , peraddr
                      , person
                      , consult
            ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 胃部受診情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// consultname 受診名称
        /// consultename 受診英語名称
        /// </returns>
        public dynamic SelectStomacConsultInfo(string rsvNo)
        {
            string sql = "";                // SQLステートメント

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("grpcd_stomac", GRPCD_STOMAC);
            param.Add("freecd_stomac", FREECD_STOMAC);

            // 指定予約番号の胃部受診情報を取得
            sql = @"
                    select
                      free.freefield3 as consultname
                      , free.freefield4 as consultename
                    from
                      free
                      , grp_i
                      , consultitemlist 
                    where
                      consultitemlist.rsvno = :rsvno 
                      and grp_i.grpcd = :grpcd_stomac 
                      and free.freecd like :freecd_stomac 
                      and consultitemlist.itemcd = grp_i.itemcd 
                      and grp_i.grpcd = free.freefield1 
                      and grp_i.seq = free.freefield2 
                    order by
                      free.freecd
            ";

            // 戻り値の設定
            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 送信日時、送信者を更新する
        /// </summary>
        /// <param name="data">
        /// rsvno 予約番号
        /// userid ユーザID
        /// </param>
        /// <returns>
        /// true 正常終了
        /// false 異常終了
        /// </returns>
        public bool UpdateConsult(JToken data)
        {
            string sql = "";        // SQLステートメント

            bool ret = false;

            // キー及び更新値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", Convert.ToInt32(data["rsvno"]));
            param.Add("sendmailuser", Convert.ToString(data["userid"]));

            // 送信日時、送信者の更新
            sql = @"
                    update consult 
                    set
                      sendmaildate = sysdate
                      , sendmailuser = :sendmailuser 
                    where
                      rsvno = :rsvno
            ";

            connection.Execute(sql, param);

            // 戻り値の設定
            ret = true;

            return ret;
        }



    }
}