using Dapper;
using Hainsi.ReportCore;
using Hainsi.Common;
using Hainsi.Common.Constants;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    //[LoggingParam]
    public class AbsenceListJudCntCreator : CsvCreator
    {

        /// <summary>
        /// 出力判定名称
        /// </summary>
        private const string OUTJUD1 = "1 異常を認めず";
        private const string OUTJUD2 = "2 異常あるも日常生活に差し支えない";
        private const string OUTJUD3 = "3 精密検査または再検査を要す";
        private const string OUTJUD4 = "4 治療を要す";

        /// <summary>
        /// 対象コース
        /// </summary>
        private const string CSCD1 = "100";
        private const string CSCD2 = "110";

        /// <summary>
        /// 団体別判定結果CSV出力データを読み込み
        /// </summary>
        /// <returns>団体別判定結果CSV出力データ</returns>
        protected override List<dynamic> GetData()
        {
            bool optOrgCd = false;
            if (!string.IsNullOrEmpty(queryParams["orgcd11"]) || !string.IsNullOrEmpty(queryParams["orgcd12"])
                || !string.IsNullOrEmpty(queryParams["orgcd21"]) || !string.IsNullOrEmpty(queryParams["orgcd22"])
                || !string.IsNullOrEmpty(queryParams["orgcd31"]) || !string.IsNullOrEmpty(queryParams["orgcd32"])
                || !string.IsNullOrEmpty(queryParams["orgcd41"]) || !string.IsNullOrEmpty(queryParams["orgcd42"])
                || !string.IsNullOrEmpty(queryParams["orgcd51"]) || !string.IsNullOrEmpty(queryParams["orgcd52"]))
            {
                optOrgCd = true;
            }

                string sql =
                  @"
                    select
                        decode( 
                            last.weight
                            , 1
                            , :outjud1
                            , 2
                            , :outjud2
                            , 3
                            , :outjud3
                            , 4
                            , :outjud4
                        ) 判定
                        , count(last.rsvno) 人数 
                    from
                        ( 
                            select
                                consult.rsvno as rsvno
                                , decode( 
                                    max(jud.weight)
                                    , 10
                                    , 1
                                    , 15
                                    , 2
                                    , 20
                                    , 2
                                    , 25
                                    , 3
                                    , 30
                                    , 3
                                    , 35
                                    , 3
                                    , 40
                                    , 3
                                    , 45
                                    , 4
                                ) as weight 
                            from
                                consult
                                , receipt
                                , judrsl
                                , jud 
                            where
                                consult.csldate between :frdate and :todate 
                                and consult.cancelflg = :cancelflg 
                                and consult.rsvno = receipt.rsvno 
                                and receipt.comedate is not null
                    ";

            if (optOrgCd)
            {
                sql += @" 
                        and consult.orgcd1 || consult.orgcd2 in ( 
                            :orgcd10
                            , :orgcd20
                            , :orgcd30
                            , :orgcd40
                            , :orgcd50
                        ) 
                    ";
            }

            sql += @" 
                    and consult.cscd in (:cscd1, :cscd2) 
                    and consult.rsvno = judrsl.rsvno 
                    and judrsl.judcd = jud.judcd
                    ";

            // 受診区分を選択した場合、条件に入れる
            if (!string.IsNullOrEmpty(queryParams["csldivcd"]))
            {
                sql += @" 
                        and consult.csldivcd = :csldivcd
                    ";
            }

            sql += @" 
                    group by
                        consult.rsvno) last 
                    group by
                        last.weight 
                    union all 
                    select
                        '合計' 判定
                        , count(consult.rsvno) 人数 
                    from
                        consult
                        , receipt 
                    where
                        consult.csldate between :frdate and :todate 
                        and consult.cancelflg = :cancelflg 
                        and consult.rsvno = receipt.rsvno 
                        and receipt.comedate is not null
                    ";

            if (optOrgCd)
            {
                sql += @" 
                        and consult.orgcd1 || consult.orgcd2 in ( 
                            :orgcd10
                            , :orgcd20
                            , :orgcd30
                            , :orgcd40
                            , :orgcd50
                        ) 
                    ";
            }

            sql += @" 
                    and consult.cscd in (:cscd1, :cscd2) 
                    ";


            // 受診区分を選択した場合、条件に入れる
            if (!string.IsNullOrEmpty(queryParams["csldivcd"]))
            {
                sql += @" 
                        and consult.csldivcd = :csldivcd
                    ";
            }

            var sqlParam = new
            {
                frdate = queryParams["startdate"],
                todate = queryParams["enddate"],
                orgcd10 = queryParams["orgcd11"] + queryParams["orgcd12"],
                orgcd20 = queryParams["orgcd21"] + queryParams["orgcd22"],
                orgcd30 = queryParams["orgcd31"] + queryParams["orgcd32"],
                orgcd40 = queryParams["orgcd41"] + queryParams["orgcd42"],
                orgcd50 = queryParams["orgcd51"] + queryParams["orgcd52"],
                outjud1 = OUTJUD1,
                outjud2 = OUTJUD2,
                outjud3 = OUTJUD3,
                outjud4 = OUTJUD4,
                cscd1 = CSCD1,
                cscd2 = CSCD2,
                csldivcd = queryParams["csldivcd"],
                cancelflg = ConsultCancel.Used
            };

            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージのリスト</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            DateTime tmpDate;

            if (! DateTime.TryParse(queryParams["startdate"], out tmpDate))
            {
                messages.Add("開始受診日の入力形式が正しくありません。");
            }
            if (!DateTime.TryParse(queryParams["enddate"], out tmpDate))
            {
                messages.Add("終了受診日の入力形式が正しくありません。");                        

            }

            return messages;
        }
    }
}
