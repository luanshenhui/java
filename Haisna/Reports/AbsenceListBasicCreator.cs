using Dapper;
using Hainsi.ReportCore;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    //[LoggingParam]
    public class AbsenceListBasicCreator : CsvCreator
    {

        /// <summary>
        /// 社員番号変換対象団体
        /// </summary>
        private const string ORGCD1 = "0100800000";
        private const string ORGCD2 = "1500800000";
        private const string ORGCD3 = "1501200000";

        /// <summary>
        /// 汎用マスタ
        /// </summary>
        private const string FREE_BASIC = "A-BASIC";
        private const string FREE_ORGFORMAT = "A-ORGFORMAT";
        private const string FREE_ORGPATTERN = "AB-";

        /// <summary>
        /// 健診基本情報データを読み込み
        /// </summary>
        /// <returns>健診基本情報データ</returns>
        protected override List<dynamic> GetData()
        {

            string sql =
                  @"
                    select
                        to_char(cst.csldate, 'yyyy-mm-dd') csldate
                        , rep.dayid
                        , cst.rsvno
                        , psn.perid
                        , decode( 
                            cst.orgcd1 || cst.orgcd2
                            , :orgcd1
                            , nvl(cst.empno, cst.isrno)
                            , :orgcd2
                            , nvl(cst.empno, cst.isrno)
                            , :orgcd3
                            , nvl(cst.empno, cst.isrno)
                            , cst.empno
                        ) empno
                        , cst.isrsign
                        , cst.isrno
                        , cst.isrmanno
                        , cst.csldivcd
                        , free.freefield1 csldivname
                        , psn.lastkname || ' ' || psn.firstkname kname
                        , psn.lastname || '　' || psn.firstname name
                        , psn.romename
                        , decode(psn.gender, 1, '男性', '女性') gender
                        , to_char(psn.birth, 'yyyy-mm-dd') birth
                        , cst.cscd
                        , cors.csname
                        , cst.orgcd1
                        , cst.orgcd2
                        , decode(cst.collectticket, 1, '回収済', '未回収') collectticket 
                    from
                        consult cst
                        , person psn
                        , receipt rep
                        , free
                        , course_p cors 
                    where
                        cst.perid = psn.perid 
                        and cst.rsvno = rep.rsvno(+) 
                        and cst.cancelflg = :cancelflg 
                        and cst.cscd = cors.cscd 
                        and cst.csldate between :frdate and :todate 
                        and ( 
                            (cst.orgcd1, cst.orgcd2) in ( 
                                select
                                    orggrp_i.orgcd1
                                    , orggrp_i.orgcd2 
                                from
                                    orggrp_i 
                                where
                                    orggrp_i.orggrpcd = :orggrpcd
                            ) 
                            or (cst.orgcd1 = :orgcd11 and cst.orgcd2 = :orgcd12) 
                            or (cst.orgcd1 = :orgcd21 and cst.orgcd2 = :orgcd22) 
                            or (cst.orgcd1 = :orgcd31 and cst.orgcd2 = :orgcd32) 
                            or (cst.orgcd1 = :orgcd41 and cst.orgcd2 = :orgcd42) 
                            or (cst.orgcd1 = :orgcd51 and cst.orgcd2 = :orgcd52)
                        ) 
                        and cst.csldivcd = free.freecd 
                    order by
                        orgcd1
                        , orgcd2
                        , csldate
                        , dayid 
                    ";

            var sqlParam = new
            {
                frdate = queryParams["startdate"],
                todate = queryParams["enddate"],
                orggrpcd = queryParams["orggrpcd"],
                orgcd11 = queryParams["orgcd11"],
                orgcd12 = queryParams["orgcd12"],
                orgcd21 = queryParams["orgcd21"],
                orgcd22 = queryParams["orgcd22"],
                orgcd31 = queryParams["orgcd31"],
                orgcd32 = queryParams["orgcd32"],
                orgcd41 = queryParams["orgcd41"],
                orgcd42 = queryParams["orgcd42"],
                orgcd51 = queryParams["orgcd51"],
                orgcd52 = queryParams["orgcd52"],
                orgcd1 = ORGCD1,
                orgcd2 = ORGCD2,
                orgcd3 = ORGCD3,
                cancelflg = ConsultCancel.Used
            };

            return CreateCsvFile(connection.Query(sql, sqlParam).ToList());
        }

        private List<dynamic> CreateCsvFile(List<dynamic> data)
        {

            var returnData = new List<dynamic>();

            // 件数0なら処理しない
            if (data.Count == 0)
            {
                return returnData;
            }

            // 汎用マスタの読み込み
            var freeDao = new FreeDao(connection);

            IList<dynamic> tagData= freeDao.SelectFree(1, FREE_BASIC);
            IList<dynamic> orgFormatData = freeDao.SelectFree(0, FREE_ORGFORMAT);

            // 一つ目の団体が汎用マスタと一致する場合はレイアウト変更
            foreach (var orgFormatrec in orgFormatData)
            {
                if (orgFormatrec.FREEFIELD1 == Util.ConvertToString(data[0].ORGCD1) + Util.ConvertToString(data[0].ORGCD2))
                {
                    tagData = freeDao.SelectFreeByClassCd(0, FREE_ORGPATTERN + orgFormatrec.FREEFIELD2);
                    break;
                }
            }

            // 出力データの編集
            foreach (IDictionary<string, object> rec in data)
            {
                var mainDic = new Dictionary<string, object>();

                foreach (var tagRec in tagData)
                {
              
                    foreach (dynamic field in rec.Keys)
                    {
                        if (field == tagRec.FREEFIELD5)
                        {
                            // SQLで取得したフィールド名と汎用テーブルが一致
                            mainDic.Add(tagRec.FREEFIELD3, rec[field]);
                            break;
                        }
                    }
                }

                returnData.Add(mainDic);

            }

            return returnData;
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
