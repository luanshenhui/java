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
    public class AbsenceListJudCreator : CsvCreator
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
        private const string FREE_JUD = "ABS-JUD";
        private const string FREE_BASEPATTERN = "BASE";
        private const string FREE_JUDPATTERN = "JUD";
        private const string FREE_ORGFORMAT = "A-JORGFORMAT";
        private const string FREE_ORGPATTERN = "AJ-";

        /// <summary>
        /// 団体別判定結果CSV出力データを読み込み
        /// </summary>
        /// <returns>団体別判定結果CSV出力データ</returns>
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
                        , psn.gender
                        , to_char(psn.birth, 'yyyy-mm-dd') birth
                        , cst.cscd
                        , cors.csname
                        , cst.orgcd1
                        , cst.orgcd2 
                    from
                        consult cst
                        , person psn
                        , receipt rep
                        , free
                        , course_p cors 
                    where
                        cst.perid = psn.perid 
                        and cst.rsvno = rep.rsvno 
                        and rep.comedate is not null 
                        and cst.cancelflg = :cancelflg
                        and cst.cscd = cors.cscd 
                        and cst.csldate between :frdate and :todate 
                        and cst.orgcd1 || cst.orgcd2 in ( 
                            :orgcd10
                            , :orgcd20
                            , :orgcd30
                            , :orgcd40
                            , :orgcd50
                        ) 
                        and cst.csldivcd = free.freecd 
                    order by
                        orgcd1
                        , orgcd2
                        , csldate
                        , rsvno
                    ";

            var sqlParam = new
            {
                frdate = queryParams["startdate"],
                todate = queryParams["enddate"],
                orgcd10 = queryParams["orgcd11"] + queryParams["orgcd12"],
                orgcd20 = queryParams["orgcd21"] + queryParams["orgcd22"],
                orgcd30 = queryParams["orgcd31"] + queryParams["orgcd32"],
                orgcd40 = queryParams["orgcd41"] + queryParams["orgcd42"],
                orgcd50 = queryParams["orgcd51"] + queryParams["orgcd52"],
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

            IList<dynamic> tagData = freeDao.SelectFreeByClassCd(0, FREE_JUD);
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
                // 判定情報の取得
                var judData = GetJud(Util.ConvertToString(rec["RSVNO"]));

                foreach (var tagRec in tagData)
                {
                    if (tagRec.FREEFIELD1 == FREE_BASEPATTERN)
                    {
                        // 基本情報
                        foreach (dynamic field in rec.Keys)
                        {
                            if (field == tagRec.FREEFIELD5)
                            {
                                // 取得したフィールド名と汎用テーブルが一致
                                mainDic.Add(tagRec.FREEFIELD3, rec[field]);
                                break;
                            }
                        }
                    }
                    else if (tagRec.FREEFIELD1 == FREE_JUDPATTERN)
                    {
                        // 判定情報
                        string judValue = ""; 
                        foreach (var judRec in judData)
                        {
                            if (Util.ConvertToString(judRec.JUDCLASSCD) == tagRec.FREEFIELD2)
                            {
                                // 取得した判定と汎用テーブルが一致
                                judValue = judRec.JUDCD;
                                break;
                            }
                        }
                        mainDic.Add(tagRec.FREEFIELD3, judValue);
                    }
                }

                returnData.Add(mainDic);

            }

            return returnData;
        }

        /// <summary>
        /// 該当の RSVNOの判定結果を読み込み
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns></returns>
        private dynamic GetJud(string rsvNo)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    jc.judclassname
                    , jr.judcd
                    , jr.judclasscd 
                from
                    judrsl jr
                    , judclass jc 
                where
                    jr.rsvno = :rsvno 
                    and jr.judclasscd between 1 and 29 
                    and jr.judclasscd = jc.judclasscd 
                order by
                    jc.judclasscd
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo
            };

            // SQL実行
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
