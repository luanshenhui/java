using Dapper;
using Hainsi.Common.Constants;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// フェイルセーフ用データアクセスオブジェクト
    /// </summary>
    public class FailSafeDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public FailSafeDao(IDbConnection connection) : base(connection)
        {
        }

        private const string PREFIX_PERID = "ID"; // 検索時の個人ＩＤ指定

        /// <summary>
        /// 半角数字チェック
        /// </summary>
        /// <param name="itemName">項目名</param>
        /// <param name="expression">文字列式</param>
        /// <param name="length">桁数</param>
        /// <param name="necessary">必須かどうか</param>
        /// <returns>
        /// エラーメッセージ(エラーが無い場合は長さ0の文字列)
        /// </returns>
        public string CheckNumeric(string itemName, string expression, int length, Check necessary = 0)
        {
            string message = ""; // エラーメッセージ
            char[] array = { '1', '2', '3', '4', '5', '6', '7', '8', '9' };

            while (true)
            {
                // 未入力チェック
                if ("".Equals(expression.Trim()))
                {
                    // 必須の場合のみメッセージを返す
                    if (Check.Necessary == necessary)
                    {
                        message = itemName + "を入力して下さい。";
                    }
                    break;
                }

                // 桁数チェック
                if (expression.Trim().Length > length)
                {
                    message = itemName + "は" + Convert.ToString(length) + "文字以内の半角数字で入力して下さい。";
                    break;
                }

                // 半角数字チェック
                for (int i = 0; i < expression.Trim().Length; i++)
                {
                    // 半角数字以外の文字が現れたらチェックを中止する
                    if (Array.IndexOf(array, expression.Substring(i, 1)) == -1)
                    {
                        if (!(i == 0 && '-'.Equals(expression.Substring(i, 1))))
                        {
                            message = itemName + "は" + Convert.ToString(length) + "文字以内の半角数字で入力して下さい。";
                            break;
                        }
                    }
                }
            }

            // 戻り値の設定
            return message;
        }

        /// <summary>
        /// 指定期間の受診情報を取得する。
        /// </summary>
        /// <param name="strCslDate">開始受診日</param>
        /// <param name="endCslDate">終了受診日</param>
        /// <returns>
        /// 指定期間の受診情報
        /// rsvno 予約番号
        /// csldate 受診日
        /// perid 個人ID
        /// cscd コースコード
        /// orgcd1 団体コード１
        /// orgcd2 団体コード２
        /// age 受診時年齢
        /// lastname 姓
        /// firstname 名
        /// csname コース名
        /// morgcd1 負担元コード１
        /// morgcd2 負担元コード２
        /// mprice 金額(CONSULT_M)
        /// mtax 消費税(CONSULT_M)
        /// cprice 金額(CTRPT_PRICE)
        /// ctax 消費税(CTRPT_PRICE)
        /// ctrptcd 契約パターンコード
        /// optcd オプションコード
        /// optbranchNo オプション枝番
        /// optname オプション名
        /// orgsname 団体略称名
        /// optmsg オプションメッセージ(年:年齢, 性:性別, 受:受診区分)
        /// p_age 現在の契約からの受診時年齢
        /// limitflg 限度額フラグ(0:限度額と一致,1:限度額と違う)
        /// </returns>
        public List<dynamic> SelectConsult(DateTime strCslDate, DateTime? endCslDate = null)
        {
            string sql = "";                // SQLステートメント
            string sql2 = "";               // SQLステートメント(金額情報)
            string sql3 = "";               // SQLステートメント(パターン情報)
            string sql4 = "";               // SQLステートメント(限度額情報)
            string sql5 = "";               //SQLステートメント(限度額情報[現在のCONSULT_Mの金額])
            DateTime date;                  // 作業用の日付
            bool targetFlg = false;         // 対象フラグ
            object age = null;              // 年齢
            object p_Age = null;            // 現在の契約からの受診時年齢
            bool limitFlg = false;          // 限度額フラグ
            int totalPrice = 0;             // 限度額
            int price = 0;                  // 限度額[現在のCONSULT_Mの金額]
            int priceCount = 0;             // 金額件数
            int count = 0;

            List<dynamic> consults;         //受診情報
            List<dynamic> consultOpts;      //受診金額確定と契約の情報
            dynamic ctrPatterns;            //パターン情報
            dynamic limitPrices;            //限度額
            dynamic consultMlimitPrices;    //限度額(現在のCONSULT_Mの金額)

            List<dynamic> rets = new List<dynamic>();   //指定期間の受診情報

            // 一方が未指定の場合、もう一方の値と同値として扱う
            if (endCslDate == null)
            {
                endCslDate = strCslDate;
            }
            else
            {
                // 双方とも指定されている場合、大小逆転時に入れ替えを行う
                DateTime wkCslDate = (DateTime)endCslDate;
                if (DateTime.Compare(wkCslDate, strCslDate) < 0)
                {
                    date = strCslDate;
                    strCslDate = wkCslDate;
                    endCslDate = date;
                }
            }

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("strcsldate", strCslDate);
            param.Add("endcsldate", endCslDate);
            param.Add("rsvno", 0);
            param.Add("orgcd1", null);
            param.Add("orgcd2", null);
            param.Add("age", 0);
            param.Add("ctrptcd", 0);
            param.Add("limittaxflg", 0);
            param.Add("gender", 0);
            param.Add("csldivcd", "");

            // 検索条件を満たす受診情報のレコードを取得
            sql = @"
                    select
                      consult.rsvno
                      , consult.csldate
                      , consult.perid
                      , consult.cscd
                      , consult.orgcd1
                      , consult.orgcd2
                      , consult.age
                      , consult.csldivcd
                      , person.gender
                      , person.firstname
                      , person.lastname
                      , course_p.csname
                      , getcslage(person.birth, consult.csldate, ctrpt.agecalc) p_age
                      , consult.ctrptcd as p_ctrptcd
                    from
                      consult
                      , person
                      , course_p
                      , ctrpt
                    where
                      consult.csldate between :strcsldate and :endcsldate
                      and consult.perid = person.perid
                      and consult.cscd = course_p.cscd
                      and consult.ctrptcd = ctrpt.ctrptcd
                    order by
                      consult.csldate
                      , consult.rsvno
                ";

            // 受診金額確定と契約の情報を取得するＳＱＬ
            sql2 = @"
                    select
                      ccon.orgcd1
                      , ccon.orgcd2
                      , nvl(consult_m.price, 0) mprice
                      , nvl(consult_m.taxprice, 0) mtax
                      , ccon.cprice
                      , ccon.ctax
                      , ccon.ctrptcd
                      , ccon.optcd
                      , ccon.optbranchno
                      , ccon.optname
                      , org.orgsname
                      , ccon.optageseq
                      , ccon.gender optgender
                      , ccon.csldivcd optcsldivcd
                    from
                      org
                      , consult_m
                      ,
                 ";

            // 契約取得
            sql2 += @"
                    (
                      select
                        nvl(ctrpt_org.orgcd1, :orgcd1) orgcd1
                        , nvl(ctrpt_org.orgcd2, :orgcd2) orgcd2
                        , nvl(ctrpt_price.price, 0) as cprice
                        , nvl(ctrpt_price.tax, 0) as ctax
                        , consult_o.ctrptcd
                        , consult_o.optcd
                        , consult_o.optbranchno
                        , ctrpt_opt.optname
                        , nvl(ctrpt_optage.seq, '0') optageseq
                        , ctrpt_opt.gender
                        , ctrpt_opt.csldivcd
                        , consult_o.rsvno
                      from
                        consult_o
                        , ctrpt_optage
                        , ctrpt_org
                        , ctrpt_opt
                        , ctrpt_price
                  ";

            sql2 += @"
                    where
                      ctrpt_opt.ctrptcd = ctrpt_price.ctrptcd
                      and ctrpt_opt.optcd = ctrpt_price.optcd
                      and ctrpt_opt.optbranchno = ctrpt_price.optbranchno
                      and ctrpt_price.ctrptcd = ctrpt_org.ctrptcd
                      and ctrpt_price.seq = ctrpt_org.seq
                      and consult_o.rsvno = :rsvno
                      and consult_o.ctrptcd = ctrpt_opt.ctrptcd
                      and consult_o.optcd = ctrpt_opt.optcd
                      and consult_o.optbranchno = ctrpt_opt.optbranchno
                      and consult_o.ctrptcd = ctrpt_optage.ctrptcd(+)
                      and consult_o.optcd = ctrpt_optage.optcd(+)
                      and consult_o.optbranchno = ctrpt_optage.optbranchno(+)
                      and to_char(:age, '999') between ctrpt_optage.strage(+) and ctrpt_optage.endage(+)) ccon
                  ";

            sql2 += @"
                    where
                      ccon.rsvno = consult_m.rsvno(+)
                      and ccon.orgcd1 = consult_m.orgcd1(+)
                      and ccon.orgcd2 = consult_m.orgcd2(+)
                      and ccon.ctrptcd = consult_m.ctrptcd(+)
                      and ccon.optcd = consult_m.optcd(+)
                      and ccon.optbranchno = consult_m.optbranchno(+)
                  ";

            sql2 += @"
                    and (
                      ccon.cprice != nvl(
                        (
                          select
                            price
                          from
                            consult_m
                          where
                            ccon.rsvno = consult_m.rsvno(+)
                            and ccon.orgcd1 = consult_m.orgcd1(+)
                            and ccon.orgcd2 = consult_m.orgcd2(+)
                            and ccon.ctrptcd = consult_m.ctrptcd(+)
                            and ccon.optcd = consult_m.optcd(+)
                            and ccon.optbranchno = consult_m.optbranchno(+)
                        )
                        , 0
                     )
                  ";

            sql2 += @"
                    or ccon.ctax != nvl(
                      (
                        select
                          taxprice
                        from
                          consult_m
                        where
                          ccon.rsvno = consult_m.rsvno(+)
                          and ccon.orgcd1 = consult_m.orgcd1(+)
                          and ccon.orgcd2 = consult_m.orgcd2(+)
                          and ccon.ctrptcd = consult_m.ctrptcd(+)
                          and ccon.optcd = consult_m.optcd(+)
                          and ccon.optbranchno = consult_m.optbranchno(+)
                       )
                       , 0
                     )
                  ";

            sql2 += @"
                    or ccon.optageseq = 0
                    or (ccon.gender != 0 and ccon.gender != :gender)
                    or (
                      ccon.csldivcd != 'CSLDIV000'
                      and ccon.csldivcd != :csldivcd
                      and :csldivcd != 'CSLDIV000'
                    ) )
                    and ccon.orgcd1 = org.orgcd1(+)
                    and ccon.orgcd2 = org.orgcd2(+)
                    order by
                      ccon.orgcd1
                      , ccon.orgcd2
                      , ccon.ctrptcd
                      , ccon.optcd
                      , ccon.optbranchno
                  ";

            // パターン情報取得
            sql3 = @"
                    select
                      limitrate
                      , limittaxflg
                      , limitprice
                    from
                      ctrpt
                    where
                      ctrptcd = :ctrptcd
                      and limitrate > 0
                  ";

            // 限度額取得
            sql4 = @"
                    select
                      nvl(totalprice, 0) totalprice
                    from
                      (
                        select
                          case
                            when :limittaxflg = 0
                              then sum(consult_m.price + consult_m.editprice)
                            else sum(
                              consult_m.price + consult_m.editprice + consult_m.taxprice + consult_m.edittax
                            )
                            end totalprice
                        from
                          ctrpt_opt
                          , consult_m
                          , (
                            select distinct
                              nvl(ctrpt_org.orgcd1, :orgcd1) orgcd1
                              , nvl(ctrpt_org.orgcd2, :orgcd2) orgcd2
                            from
                              ctrpt_org
                            where
                              ctrpt_org.ctrptcd = :ctrptcd
                              and ctrpt_org.limitpriceflg = 0
                          ) targetorg
                        where
                          consult_m.rsvno = :rsvno
                          and consult_m.orgcd1 = targetorg.orgcd1
                          and consult_m.orgcd2 = targetorg.orgcd2
                          and ctrpt_opt.ctrptcd = consult_m.ctrptcd
                          and ctrpt_opt.optcd = consult_m.optcd
                          and ctrpt_opt.optbranchno = consult_m.optbranchno
                          and ctrpt_opt.exceptlimit is null
                          and otherlinedivcd is null
                      ) lastview
                  ";

            // 限度額(現在のCONSULT_Mの金額)取得
            sql5 = @"
                    select
                      consult_m.price
                    from
                      consult_m
                      , (
                        select distinct
                          nvl(ctrpt_org.orgcd1, :orgcd1) orgcd1
                          , nvl(ctrpt_org.orgcd2, :orgcd2) orgcd2
                        from
                          ctrpt_org
                        where
                          ctrpt_org.ctrptcd = :ctrptcd
                          and ctrpt_org.limitpriceflg = 1
                      ) targetorg
                    where
                      consult_m.rsvno = :rsvno
                      and consult_m.orgcd1 = targetorg.orgcd1
                      and consult_m.orgcd2 = targetorg.orgcd2
                      and consult_m.ctrptcd = :ctrptcd
                      and consult_m.optcd = '0'
                      and consult_m.optbranchno = 0
                  ";
            consults = connection.Query(sql, param).ToList();

            count = 0;
            // レコードが存在する場合
            if (consults.Count() > 0)
            {
                // 配列形式で格納する
                foreach (var rec in consults)
                {
                    //キー値の設定
                    if (rec.RSVNO == null)
                    {
                        param["rsvno"] = 0;
                    }
                    else
                    {
                        param["rsvno"] = Convert.ToInt32(rec.RSVNO);
                    }

                    param["orgcd1"] = Convert.ToString(rec.ORGCD1);
                    param["orgcd2"] = Convert.ToString(rec.ORGCD2);
                    param["age"] = Convert.ToString(rec.AGE);
                    param["p_ctrptcd"] = Convert.ToString(rec.P_CTRPTCD);
                    param["gender"] = Convert.ToString(rec.GENDER);
                    param["csldivcd"] = Convert.ToString(rec.CSLDIVCD);

                    int rsvno = Convert.ToInt32(rec.RSVNO);
                    string strAge = Convert.ToString(rec.AGE);
                    string strP_Age = Convert.ToString(rec.P_AGE);
                    string paraGenDer = Convert.ToString(rec.GENDER);
                    string paraCslDivCd = Convert.ToString(rec.CSLDIVCD);

                    targetFlg = false;

                    // 年齢が違う人は対象とする
                    if (strAge.IndexOf(".", StringComparison.Ordinal) >= 0)
                    {
                        age = strAge.Substring(0, strAge.IndexOf(".", StringComparison.Ordinal));
                    }
                    else
                    {
                        age = strAge;
                    }
                    if (strP_Age.IndexOf(".", StringComparison.Ordinal) >= 0)
                    {
                        p_Age = strP_Age.Substring(0, strP_Age.IndexOf(".", StringComparison.Ordinal));
                    }
                    else
                    {
                        p_Age = strP_Age;
                    }
                    if (!age.Equals(p_Age))
                    {
                        targetFlg = true;
                    }

                    // 限度額情報の編集
                    limitFlg = false;
                    while (true)
                    {
                        // 受診情報の存在しない行ならば処理を抜ける
                        if (rsvno == 0)
                        {
                            break;
                        }

                        // 初めてパターン情報を取得する場合

                        //ダイナセットを新規作成
                        ctrPatterns = connection.Query(sql3, param).FirstOrDefault();
                        if (ctrPatterns != null)
                        {
                            // オブジェクトの参照設定
                            param["limittaxflg"] = ctrPatterns["limittaxflg"];

                            int limitRate = Convert.ToInt32(ctrPatterns["limitrate"]);
                            int limitTaxFlg = Convert.ToInt32(ctrPatterns["limittaxflg"]);
                            int limitPrice = Convert.ToInt32(ctrPatterns["limitprice"]);

                            // 初めて限度額情報を取得する場合
                            limitPrices = connection.Query(sql4, param).FirstOrDefault();
                            if (limitPrices != null)
                            {
                                // オブジェクトの参照設定
                                totalPrice = Convert.ToInt32(limitPrices["totalprice"]);

                                // 負担率を掛ける
                                totalPrice = Convert.ToInt32(totalPrice * (limitRate * 0.01));
                            }
                            else
                            {
                                totalPrice = 0;
                            }

                            if (totalPrice > 0)
                            {
                                // 負担金額合計が上限金額よりも大きいなら上限金額をセットする。
                                if (limitPrice != 0)
                                {
                                    if (totalPrice > limitPrice)
                                    {
                                        totalPrice = limitPrice;
                                    }
                                    else
                                    {
                                        totalPrice = (int)(totalPrice / 10) * 10;
                                    }
                                }

                                // 初めて限度額情報[現在のCONSULT_Mの金額]を取得する場合
                                consultMlimitPrices = connection.Query(sql5, param).FirstOrDefault();
                                if (consultMlimitPrices != null)
                                {
                                    // オブジェクトの参照設定
                                    string strPrice = Convert.ToString(consultMlimitPrices["price"]);
                                    if (strPrice != null)
                                    {
                                        price = Convert.ToInt32(strPrice);
                                    }
                                    else
                                    {
                                        price = 0;
                                    }
                                }

                                // 再計算した限度額と現在CONSULT_Mに設定されている限度額を比較して違う場合は対象とする
                                if (totalPrice != price)
                                {
                                    limitFlg = true;
                                }
                            }

                        }
                        // 限度額情報が存在する場合は対象とする
                        if (limitFlg)
                        {
                            targetFlg = true;
                        }
                        break;
                    }

                    List<string> arrMOrgCd12 = new List<string>();
                    List<string> arrMOrgCd22 = new List<string>();
                    List<string> arrMPrice2 = new List<string>();
                    List<string> arrMTax2 = new List<string>();
                    List<string> arrCPrice2 = new List<string>();
                    List<string> arrCTax2 = new List<string>();
                    List<string> arrCtrPtCd2 = new List<string>();
                    List<string> arrOptCd2 = new List<string>();
                    List<string> arrOptBranchNo2 = new List<string>();
                    List<string> arrOptName2 = new List<string>();
                    List<string> arrOrgSName2 = new List<string>();
                    List<string> arrOptMsg2 = new List<string>();

                    // 金額情報の編集
                    while (true)
                    {
                        // 受診情報の存在しない行ならば処理を抜ける
                        if (rsvno == 0)
                        {
                            break;
                        }

                        // 初めて追加検査を取得する場合
                        consultOpts = connection.Query(sql2, param).ToList();

                        // 配列形式で格納する
                        priceCount = 0;
                        if (consultOpts != null)
                        {
                            foreach (var item in consultOpts)
                            {
                                arrMOrgCd12.Add(Convert.ToString(item.ORGCD1));
                                arrMOrgCd22.Add(Convert.ToString(item.ORGCD2));
                                arrMPrice2.Add(Convert.ToString(item.MPRICE));
                                arrMTax2.Add(Convert.ToString(item.MTAX));
                                arrCPrice2.Add(Convert.ToString(item.CPRICE));
                                arrCTax2.Add(Convert.ToString(item.CTAX));
                                arrCtrPtCd2.Add(Convert.ToString(item.CTRPTCD));
                                arrOptCd2.Add(Convert.ToString(item.OPTCD));
                                arrOptBranchNo2.Add(Convert.ToString(item.OPTBRANCHNO));
                                arrOptName2.Add(Convert.ToString(item.OPTNAME));
                                arrOrgSName2.Add(Convert.ToString(item.ORGSNAME));

                                // 返信メッセージは何が違うかを返す
                                if (Convert.ToInt32(item.OPTAGESEQ) == 0)
                                {
                                    arrOptMsg2.Add("年");
                                }
                                else if (Convert.ToInt32(item.OPTGENDER) > 0 && !paraGenDer.Equals(Convert.ToString(item.OPTGENDER)))
                                {
                                    arrOptMsg2.Add("性");
                                }
                                else if (!"CSLDIV000".Equals(Convert.ToString(item.OPTCSLDIVCD))
                                    && !"CSLDIV000".Equals(paraCslDivCd) && !paraCslDivCd.Equals(Convert.ToString(item.OPTCSLDIVCD)))
                                {
                                    arrOptMsg2.Add("受");
                                }
                                else
                                {
                                    arrOptMsg2.Add("");
                                }
                                priceCount++;
                            }
                        }
                        // 金額情報が存在する場合は対象とする
                        if (priceCount > 0)
                        {
                            targetFlg = true;
                        }
                        break;
                    }

                    // 対象者のみ追加
                    if (targetFlg)
                    {
                        var rtnRow = new Dictionary<string, object>();

                        rtnRow.Add("rsvno", Convert.ToString(rec.RSVNO));
                        rtnRow.Add("csldate", Convert.ToString(rec.CSLDATE));
                        rtnRow.Add("perid", Convert.ToString(rec.PERID));
                        rtnRow.Add("cscd", Convert.ToString(rec.CSCD));
                        rtnRow.Add("orgcd1", Convert.ToString(rec.ORGCD1));
                        rtnRow.Add("orgcd2", Convert.ToString(rec.ORGCD2));
                        rtnRow.Add("age", Convert.ToString(age));
                        rtnRow.Add("firstname", Convert.ToString(rec.FIRSTNAME));
                        rtnRow.Add("lastname", Convert.ToString(rec.LASTNAME));
                        rtnRow.Add("csname", Convert.ToString(rec.CSNAME));
                        rtnRow.Add("p_age", Convert.ToString(p_Age));
                        rtnRow.Add("limitflg", limitFlg ? 1 : 0);

                        // 金額情報が存在する場合はカンマ区切りで結合して格納する
                        if (priceCount > 0)
                        {
                            rtnRow.Add("morgcd1", String.Join(",", arrMOrgCd12));
                            rtnRow.Add("morgcd2", String.Join(",", arrMOrgCd22));
                            rtnRow.Add("mprice", String.Join(",", arrMPrice2));
                            rtnRow.Add("mtax", String.Join(",", arrMTax2));
                            rtnRow.Add("cprice", String.Join(",", arrCPrice2));
                            rtnRow.Add("ctax", String.Join(",", arrCTax2));
                            rtnRow.Add("ctrptcd", String.Join(",", arrCtrPtCd2));
                            rtnRow.Add("optcd", String.Join(",", arrOptCd2));
                            rtnRow.Add("optbranchno", String.Join(",", arrOptBranchNo2));
                            rtnRow.Add("optname", String.Join(",", arrOptName2));
                            rtnRow.Add("orgsname", String.Join(",", arrOrgSName2));
                            rtnRow.Add("optmsg", String.Join(",", arrOptMsg2));
                        }
                        else
                        {
                            rtnRow.Add("morgcd1", "");
                            rtnRow.Add("morgcd2", "");
                            rtnRow.Add("mprice", "");
                            rtnRow.Add("mtax", "");
                            rtnRow.Add("cprice", "");
                            rtnRow.Add("ctax", "");
                            rtnRow.Add("ctrptcd", "");
                            rtnRow.Add("optcd", "");
                            rtnRow.Add("optbranchno", "");
                            rtnRow.Add("optname", "");
                            rtnRow.Add("orgsname", "");
                            rtnRow.Add("optmsg", "");
                        }

                        rets.Add(rtnRow);
                    }

                    count++;
                }

            }
            // 戻り値の設定
            return rets;
        }

        /// <summary>
        /// 指定予約番号の受診金額確定を取得する。
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <return>
        /// 受診金額確定
        /// orgcd1 団体コード１
        /// orgcd2 団体コード２
        /// price 金額
        /// editprice 調整金額
        /// taxprice 税額
        /// edittax 税調整税額
        /// ctrptcd 契約パターンコード
        /// optcd オプションコード
        /// optbranchno オプション枝番
        /// </return>
        public List<dynamic> SelectConsult_m(int rsvNo)
        {
            string sql; // SQLステートメント

            //キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 検索条件を満たす受診金額確定テーブルのレコードを取得
            sql = @"
                    select
                      consult_m.orgcd1
                      , consult_m.orgcd2
                      , consult_m.price
                      , consult_m.editprice
                      , consult_m.taxprice
                      , consult_m.edittax
                      , consult_o.ctrptcd
                      , consult_o.optcd
                      , consult_o.optbranchno
                    from
                      consult_m
                      , consult_o
                    where
                      consult_o.rsvno = :rsvno
                      and consult_o.rsvno = consult_m.rsvno(+)
                      and consult_o.ctrptcd = consult_m.ctrptcd(+)
                      and consult_o.optcd = consult_m.optcd(+)
                      and consult_o.optbranchno = consult_m.optbranchno(+)
                    order by
                      consult_o.ctrptcd
                      , consult_o.optcd
                      , consult_o.optbranchno
                 ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// 指定予約番号の受診金額確定を取得する。
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <returns>
        /// 受診金額確定
        /// orgcd1 団体コード１
        /// orgcd2 団体コード２
        /// price 負担金額
        /// tax 消費税
        /// ctrptcd 契約パターンコード
        /// optcd オプションコード
        /// optbranchno オプション枝番
        /// optname オプション名
        /// </returns>
        public List<dynamic> SelectCtrpt_Opt(int rsvNo, string orgCd1, string orgCd2)
        {
            string sql; // SQLステートメント

            //キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("orgcd1", orgCd1);
            param.Add("orgcd1", orgCd2);

            // 検索条件を満たす受診金額確定テーブルのレコードを取得
            sql = @"
                    select
                      baseopt.orgcd1
                      , baseopt.orgcd2
                      , baseopt.price
                      , baseopt.tax
                      , consult_o.ctrptcd
                      , consult_o.optcd
                      , consult_o.optbranchno
                      , baseopt.optname
                    from
                      consult_o
                      ,
                ";

            sql += @"
                    (
                      select
                        ctrpt_org.orgcd1
                        , ctrpt_org.orgcd2
                        , ctrpt_price.price
                        , ctrpt_price.tax
                        , ctrpt_opt.ctrptcd
                        , ctrpt_opt.optcd
                        , ctrpt_opt.optbranchno
                        , ctrpt_opt.optname
                      from
                        ctrpt_org
                        , ctrpt_opt
                        , ctrpt_price
                      where
                        ctrpt_opt.ctrptcd = ctrpt_price.ctrptcd
                        and ctrpt_opt.optcd = ctrpt_price.optcd
                        and ctrpt_opt.optbranchno = ctrpt_price.optbranchno
                        and ctrpt_price.ctrptcd = ctrpt_org.ctrptcd
                        and ctrpt_price.seq = ctrpt_org.seq
                    ) baseopt
                 ";

            sql += @"
                    where
                      consult_o.rsvno = :rsvno
                      and consult_o.ctrptcd = baseopt.ctrptcd(+)
                      and consult_o.optcd = baseopt.optcd(+)
                      and consult_o.optbranchno = baseopt.optbranchno(+)
                    order by
                      consult_o.ctrptcd
                      , consult_o.optcd
                      , consult_o.optbranchno
                 ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }
    }
}
