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
    public class AbsenceListNttDataCreator : CsvCreator
    {

        /// <summary>
        /// 社員番号変換対象団体
        /// </summary>
        private const string ORGCD1 = "0100800000";
        private const string ORGCD2 = "1500800000";
        private const string ORGCD3 = "1501200000";

        /// <summary>
        /// 対象コース
        /// </summary>
        private const string CSCD1 = "100";
        private const string CSCD2 = "105";
        private const string CSCD3 = "110";

        /// <summary>
        /// 汎用コード(薬剤情報)
        /// </summary>
        private const string FREECD_METADIS = "METADIS";
        private const string FREECD_METASTS = "METASTS";

        /// <summary>
        /// グループコード
        /// </summary>
        private const string ALCOHOL_GRPCD = "X038";       // アルコール換算グループコード
        private const string DISEASE_GRPCD = "X026";       // 現病歴・既往歴グループコード
        private const string META_DISEASE_GRPCD = "X068";  // 現病歴グループコード(メタボリック現病歴)
        private const string OCR_ITEM_GRPCD = "X755";  // 特定健診質問項目グループコード

        /// <summary>
        /// NTT-CSV出力データを読み込み
        /// </summary>
        /// <returns>NTT-CSV出力データ</returns>
        protected override List<dynamic> GetData()
        {

            List<dynamic> data;

            if (queryParams["orgbill"] == "1")
            {
                data = SelectAbsenceListFile_Bill();
            }
            else
            {
                data = SelectAbsenceListFile();
            }

            return data;

        }

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージのリスト</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();
            DateTime tmpStartDate;
            DateTime tmpEndDate;

            if (!DateTime.TryParse(queryParams["startdate"], out tmpStartDate))
            {
                messages.Add("開始受診日の入力形式が正しくありません。");
            }
            if (!DateTime.TryParse(queryParams["enddate"], out tmpEndDate))
            {
                messages.Add("終了受診日の入力形式が正しくありません。");
            }

            DateTime tmpBaseDate;
            if (!DateTime.TryParse(GetSpSwitchingDate("CHG201804"), out tmpBaseDate))
            {
                messages.Add("特定健診切替日が取得できません。");
            }

            if (tmpStartDate < tmpBaseDate && tmpEndDate >= tmpBaseDate)
            {
                messages.Add("2018年4月1日をまたがる日付設定はできません。（特定健診・特定保健指導改訂の為）");
            } 
            else if(tmpEndDate < tmpBaseDate && tmpStartDate >= tmpBaseDate)
            {
                messages.Add("2018年4月1日をまたがる日付設定はできません。（特定健診・特定保健指導改訂の為）");
            }
 
            if (string.IsNullOrEmpty(queryParams["orgcd11"])
                && string.IsNullOrEmpty(queryParams["orgcd21"])
                && string.IsNullOrEmpty(queryParams["orgcd31"])
                && string.IsNullOrEmpty(queryParams["orgcd41"])
                && string.IsNullOrEmpty(queryParams["orgcd51"])
                && string.IsNullOrEmpty(queryParams["orggrpcd"]))
            {
                messages.Add("団体を選択してください。");
            }

            if (queryParams["orgbill"] == "1" && string.IsNullOrEmpty(queryParams["billorgcd1"]))
            {
                messages.Add("請求対象団体を選択してください。");
            }

            return messages;
        }


        private List<dynamic> SelectAbsenceListFile()
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
                        to_char(consult.csldate, 'YYYY-MM-DD') as scsldate
                        , receipt.dayid as dayid
                        , consult.rsvno as rsvno
                        , person.perid as perid
                        , decode( 
                            consult.orgcd1 || consult.orgcd2
                            , :orgcd1
                            , nvl(consult.empno, consult.isrno)
                            , :orgcd2
                            , nvl(consult.empno, consult.isrno)
                            , :orgcd3
                            , nvl(consult.empno, consult.isrno)
                            , consult.empno
                        ) as empno
                        , consult.isrsign as isrsign
                        , consult.isrno as isrno
                        , org.spare1 as spare1
                        , consult.csldivcd as csldivcd
                        , free.freefield1 as csldivname
                        , person.lastkname || ' ' || person.firstkname as kname
                        , person.lastname || ' ' || person.firstname as name
                        , person.romename as romename
                        , person.gender as gender
                        , to_char(person.birth, 'YYYY-MM-DD') as birth
                        , decode( 
                            consult.cscd
                            , '110'
                            , substr( 
                                ft_sonyctropt(consult.rsvno, consult.cscd, consult.orgcd1)
                                , 1
                                , 3
                            ) 
                            , consult.cscd
                        ) as cscd
                        , substr( 
                            ft_sonyctropt(consult.rsvno, consult.cscd, consult.orgcd1)
                            , 4
                        ) as csname
                        , consult.orgcd1 as orgcd1
                        , consult.orgcd2 as orgcd2
                        , consult.csldate as csldate
                        , consult.cscd as cscd2
                        , ft_getgrpcd(consult.orgcd1, consult.orgcd2, :orggrpcd) as grpcd 
                    from
                        consult
                        , person
                        , receipt
                        , org
                        , free 
                    where
                        consult.csldate between :frdate and :todate 
                        and consult.cancelflg = :cancelflg 
                        and consult.cscd in (:cscd1, :cscd2, :cscd3) 
                        and consult.rsvno = receipt.rsvno 
                        and receipt.comedate is not null 
                        and consult.perid = person.perid 
                        and consult.orgcd1 = org.orgcd1 
                        and consult.orgcd2 = org.orgcd2
                    ";

            // 団体グループコード
            if (!string.IsNullOrEmpty(queryParams["orggrpcd"]))
            {
                sql += @" 
                        and (consult.orgcd1, consult.orgcd2) in ( 
                                select
                                    orggrp_i.orgcd1
                                    , orggrp_i.orgcd2 
                                from
                                    orggrp_i 
                                where
                                    orggrp_i.orggrpcd = :orggrpcd
                            ) 
                    ";
            }
            // 団体コード
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
                    and consult.csldivcd = free.freecd
                    ";

            // 抽出条件として受診区分を選択した場合
            if (!string.IsNullOrEmpty(queryParams["csldivcd"]))
            {
                sql += @" 
                        and consult.csldivcd = :csldivcd 
                    ";
            }

            // 抽出条件として請求書出力区分を選択した場合
            if (!string.IsNullOrEmpty(queryParams["billprint"]))
            {
                sql += @" 
                        and consult.billprint = :billprint
                    ";
            }

            sql += @" 
                    order by
                        consult.csldate
                        , consult.rsvno
                        , consult.orgcd1
                        , consult.orgcd2
                    ";

            var sqlParam = new
            {
                frdate = queryParams["startdate"],
                todate = queryParams["enddate"],
                orggrpcd = queryParams["orggrpcd"],
                orgcd10 = queryParams["orgcd11"] + queryParams["orgcd12"],
                orgcd20 = queryParams["orgcd21"] + queryParams["orgcd22"],
                orgcd30 = queryParams["orgcd31"] + queryParams["orgcd32"],
                orgcd40 = queryParams["orgcd41"] + queryParams["orgcd42"],
                orgcd50 = queryParams["orgcd51"] + queryParams["orgcd52"],
                csldivcd = queryParams["csldivcd"],
                billprint = queryParams["billprint"],
                orgcd1 = ORGCD1,
                orgcd2 = ORGCD2,
                orgcd3 = ORGCD3,
                cscd1 = CSCD1,
                cscd2 = CSCD2,
                cscd3 = CSCD3,
                cancelflg = ConsultCancel.Used
            };

            return CreateCsvFile(connection.Query(sql, sqlParam).ToList());
        }


        private List<dynamic> SelectAbsenceListFile_Bill()
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
                        to_char(consult.csldate, 'YYYY-MM-DD') as scsldate
                        , receipt.dayid as dayid
                        , consult.rsvno as rsvno
                        , person.perid as perid
                        , decode( 
                            consult.orgcd1 || consult.orgcd2
                            , :orgcd1
                            , nvl(consult.empno, consult.isrno)
                            , :orgcd2
                            , nvl(consult.empno, consult.isrno)
                            , :orgcd3
                            , nvl(consult.empno, consult.isrno)
                            , consult.empno
                        ) as empno
                        , consult.isrsign as isrsign
                        , consult.isrno as isrno
                        , org.spare1 as spare1
                        , consult.csldivcd as csldivcd
                        , free.freefield1 as csldivname
                        , person.lastkname || ' ' || person.firstkname as kname
                        , person.lastname || ' ' || person.firstname as name
                        , person.romename as romename
                        , person.gender as gender
                        , to_char(person.birth, 'YYYY-MM-DD') as birth
                        , decode( 
                            consult.cscd
                            , '110'
                            , ( 
                                decode( 
                                    consult.rsvno
                                    , 308863
                                    , '992'
                                    , substr( 
                                        ft_sonyctropt(consult.rsvno, consult.cscd, consult.orgcd1)
                                        , 1
                                        , 3
                                    )
                                )
                            ) 
                            , consult.cscd
                        ) as cscd
                        , decode( 
                            consult.rsvno
                            , 308863
                            , '一般健診'
                            , substr( 
                                ft_sonyctropt(consult.rsvno, consult.cscd, consult.orgcd1)
                                , 4
                            )
                        ) as csname
                        , consult.orgcd1 as orgcd1
                        , consult.orgcd2 as orgcd2
                        , consult.csldate as csldate
                        , consult.cscd as cscd2
                        , ft_getgrpcd(consult.orgcd1, consult.orgcd2, :orggrpcd) as grpcd 
                    from
                        consult
                        , person
                        , receipt
                        , org
                        , free
                        , ( 
                            select
                                consult.rsvno as rsvno 
                            from
                                consult
                                , receipt
                                , consult_m 
                            where
                                consult.csldate between :frdate and :todate 
                                and consult.cancelflg = :cancelflg 
                                and consult.cscd in (:cscd1, :cscd2, :cscd3
                        ) 
                    ";

            // 団体グループコード
            if (!string.IsNullOrEmpty(queryParams["orggrpcd"]))
            {
                sql += @" 
                        and (consult.orgcd1, consult.orgcd2) in ( 
                                select
                                    orggrp_i.orgcd1
                                    , orggrp_i.orgcd2 
                                from
                                    orggrp_i 
                                where
                                    orggrp_i.orggrpcd = :orggrpcd
                            ) 
                    ";
            }
            // 団体コード
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
                    and consult.rsvno = receipt.rsvno 
                    and receipt.comedate is not null 
                    and consult.rsvno = consult_m.rsvno 
                    and consult_m.orgcd1 = :billorgcd1 
                    and consult_m.orgcd2 = :billorgcd2 
                    group by
                        consult.rsvno) lastview 
                    where
                        consult.csldate between :frdate and :todate 
                        and consult.cancelflg = :cancelflg 
                        and consult.cscd in (:cscd1, :cscd2, :cscd3)
                        and consult.rsvno = receipt.rsvno 
                        and receipt.comedate is not null 
                        and consult.perid = person.perid 
                        and consult.orgcd1 = org.orgcd1 
                        and consult.orgcd2 = org.orgcd2
                    ";

            // 団体グループコード
            if (!string.IsNullOrEmpty(queryParams["orggrpcd"]))
            {
                sql += @" 
                        and (consult.orgcd1, consult.orgcd2) in ( 
                                select
                                    orggrp_i.orgcd1
                                    , orggrp_i.orgcd2 
                                from
                                    orggrp_i 
                                where
                                    orggrp_i.orggrpcd = :orggrpcd
                            ) 
                    ";
            }
            // 団体コード
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
                    and consult.csldivcd = free.freecd
                    ";

            // 抽出条件として受診区分を選択した場合
            if (!string.IsNullOrEmpty(queryParams["csldivcd"]))
            {
                sql += @" 
                        and consult.csldivcd = :csldivcd 
                    ";
            }

            // 抽出条件として請求書出力区分を選択した場合
            if (!string.IsNullOrEmpty(queryParams["billprint"]))
            {
                sql += @" 
                        and consult.billprint = :billprint
                    ";
            }

            sql += @" 
                    and consult.rsvno = lastview.rsvno 
                    order by
                        consult.csldate
                        , consult.rsvno
                        , consult.orgcd1
                        , consult.orgcd2
                    ";

            var sqlParam = new
            {
                frdate = queryParams["startdate"],
                todate = queryParams["enddate"],
                orggrpcd = queryParams["orggrpcd"],
                orgcd10 = queryParams["orgcd11"] + queryParams["orgcd12"],
                orgcd20 = queryParams["orgcd21"] + queryParams["orgcd22"],
                orgcd30 = queryParams["orgcd31"] + queryParams["orgcd32"],
                orgcd40 = queryParams["orgcd41"] + queryParams["orgcd42"],
                orgcd50 = queryParams["orgcd51"] + queryParams["orgcd52"],
                csldivcd = queryParams["csldivcd"],
                billprint = queryParams["billprint"],
                billorgcd1 = queryParams["billorgcd1"],
                billorgcd2 = queryParams["billorgcd2"],
                orgcd1 = ORGCD1,
                orgcd2 = ORGCD2,
                orgcd3 = ORGCD3,
                cscd1 = CSCD1,
                cscd2 = CSCD2,
                cscd3 = CSCD3,
                cancelflg = ConsultCancel.Used
            };

            return CreateCsvFile(connection.Query(sql, sqlParam).ToList());
        }

        private List<dynamic> CreateCsvFile(List<dynamic> data)
        {

            var returnData = new List<dynamic>();

            // バージョン管理
            string sectionItem;
            string sectionSyoken;
            string sectionMonshin;

            DateTime startDate = DateTime.Parse(queryParams["startdate"]);
            DateTime baseDate = DateTime.Parse(GetSpSwitchingDate("CHG201804"));

            if (startDate >= baseDate)
            {
                sectionItem = "A-N-I1804";
                sectionSyoken = "A-N-S1804";
                sectionMonshin = "A-N-M1804";
            }
            else
            {
                sectionItem = "A-N-ITEM";
                sectionSyoken = "A-N-SYO";
                sectionMonshin = "A-N-MON";
            }

            // 件数0なら処理しない
            if (data.Count == 0)
            {
                return returnData;
            }

            // 汎用マスタの読み込み
            var freeDao = new FreeDao(connection);
            //医療機関
            IList<dynamic> clinicData = freeDao.SelectFree(1, "A-N-CLINIC");
            //判定情報
            IList<dynamic> judData = freeDao.SelectFree(1, "A-N-JUD");
            IList<dynamic> jud2Data = freeDao.SelectFree(1, "A-N-JUDT");
            //出力データ
            IList<dynamic> itemData = freeDao.SelectFree(1, sectionItem);
            IList<dynamic> syokenData = freeDao.SelectFree(1, sectionSyoken);
            IList<dynamic> monshinData = freeDao.SelectFree(1, sectionMonshin);
            //判定ヘッダ情報
            IList<dynamic> judHeader = freeDao.SelectFree(1, "A-N-JLP");
            //繰り返し情報
            IList<dynamic> loopData = freeDao.SelectFree(1, "A-N-LOOP");

            //医療機関データの取得
            string clinicName = "";
            string clinicCode = "";
            foreach (var clinicRec in clinicData)
            {
                clinicName = Util.ConvertToString(clinicRec.FREEFIELD1).Trim();
                clinicCode = Util.ConvertToString(clinicRec.FREEFIELD2).Trim();
            }

            //判定結果のヘッダ情報取得
            string jName = "";
            string jCode = "";
            string jContent = "";
            int headerNum = 0;

            //ヘッダ出力用フラグ
            bool isFirst = true;

            foreach (var headerRec in judHeader)
            {
                switch (headerNum)
                {
                    case 0:
                        jName = Util.ConvertToString(headerRec.FREEFIELD1).Trim();
                        break;
                    case 1:
                        jCode = Util.ConvertToString(headerRec.FREEFIELD1).Trim();
                        break;
                    case 2:
                        jContent = Util.ConvertToString(headerRec.FREEFIELD1).Trim();
                        break;
                }
                headerNum++;
            }

            //グループコードの取得
            string grpCd = data[0].GRPCD;

            // 出力データの編集
            foreach (IDictionary<string, object> rec in data)
            {
                // 行データ
                var mainDic = new Dictionary<string, object>();

                // 予約番号の取得
                int rsvno = 0;
                int.TryParse(Util.ConvertToString(rec["RSVNO"]), out rsvno);
                if (rsvno == 0)
                {
                    continue;
                }

                // 検査結果の取得
                int.TryParse(Util.ConvertToString(rec["GENDER"]), out int gender);
                DateTime.TryParse(Util.ConvertToString(rec["CSLDATE"]), out DateTime cslDate);
                var resultData = GetResultData(rsvno, grpCd, gender, cslDate);

                foreach (var itemRec in itemData)
                {

                    string tmpData = "";

                    switch (Util.ConvertToString(itemRec.FREEFIELD1))
                    {
                        case "CLI":
                            // 医療機関
                            switch (Util.ConvertToString(itemRec.FREEFIELD3))
                            {
                                case "NAME":
                                    tmpData = clinicName;
                                    break;

                                case "CODE":
                                    tmpData = clinicCode;
                                    break;
                            }

                            mainDic.Add(Util.ConvertToString(itemRec.FREEFIELD4), tmpData);

                            break;

                        case "BAS":
                            // 抽出結果から出力
                            foreach (dynamic field in rec.Keys)
                            {
                                if (field == Util.ConvertToString(itemRec.FREEFIELD3))
                                {
                                    // SQLで取得したフィールド名と汎用テーブルが一致
                                    tmpData = Util.ConvertToString(rec[field]).Trim();
                                    break;
                                }
                            }

                            mainDic.Add(Util.ConvertToString(itemRec.FREEFIELD4), tmpData);

                            break;

                        case "JUDLOOP":
                            // 判定項目

                            //最大出力項目数取得
                            var loopDataList = new List<string>();
                            loopDataList = GetLoopData(loopData, Util.ConvertToString(itemRec.FREEFIELD2));
                            int maxNum = 0;
                            int.TryParse(loopDataList[2], out maxNum);

                            //出力項目数
                            int outputNum = 0;
                            //婦人科存在チェック
                            bool gyneFlg = false;
                            //婦人科判定テーブル
                            var gyneDic = new Dictionary<int, List<string>>();
                            int gyneCnt = 0;

                            foreach (var detail in GetJudData(rsvno))
                            {
                                // 最大項目に達した場合処理を抜ける
                                if (outputNum >= maxNum)
                                {
                                    break;
                                }

                                outputNum++;

                                if (int.TryParse(Util.ConvertToString(detail.JUDCLASSCD).Trim(), out int judClass))
                                {
                                    switch(judClass)
                                    {
                                        case 25:
                                        case 30:
                                        case 31:
                                            // 婦人科判定
                                            var gyneList = new List<string>()
                                            {
                                                Util.ConvertToString(detail.JUDCD).Trim()
                                                ,Util.ConvertToString(detail.JUDNAME).Trim()
                                                ,Util.ConvertToString(detail.WEIGHT).Trim()
                                            };
                                            gyneDic.Add(gyneCnt, gyneList);
                                            gyneCnt++;
                                            gyneFlg = true;
                                            break;

                                        default:
                                            mainDic.Add(jName + outputNum.ToString(), Util.ConvertToString(detail.JUDCLASSNAME).Trim());
                                            mainDic.Add(jCode + outputNum.ToString(), Util.ConvertToString(detail.JUDCD).Trim());
                                            mainDic.Add(jContent + outputNum.ToString(), Util.ConvertToString(detail.JUDNAME).Trim());
                                            break;
                                    }
                                }  
                            }

                            //婦人科判定の編集
                            if (gyneFlg && outputNum < maxNum)
                            {
                                var gyneJudList = new List<string>();
                                gyneJudList = GetGyneJudData(gyneDic);

                                outputNum++;

                                mainDic.Add(jName + outputNum.ToString(), "婦人科");
                                mainDic.Add(jCode + outputNum.ToString(), gyneJudList[0]);
                                mainDic.Add(jContent + outputNum.ToString(), gyneJudList[1]);
                                
                            }

                            //最大項目数になるまで繰り返し
                            while(outputNum < maxNum)
                            {
                                outputNum++;

                                mainDic.Add(jName + outputNum.ToString(), "");
                                mainDic.Add(jCode + outputNum.ToString(), "");
                                mainDic.Add(jContent + outputNum.ToString(), "");
                                
                            }

                            break;

                        case "CMTLOOP":
                            // 総合コメント

                            //最大出力項目数取得
                            var loopCmtDataList = new List<string>();
                            loopCmtDataList = GetLoopData(loopData, Util.ConvertToString(itemRec.FREEFIELD2));
                            int maxCmtNum = 0;
                            int.TryParse(loopCmtDataList[2], out maxCmtNum);
                            //出力項目数
                            int outputCmtNum = 0;

                            foreach (var cmtRec in GetCmtData(rsvno))
                            {
                                // 最大項目に達した場合処理を抜ける
                                if (outputCmtNum >= maxCmtNum)
                                {
                                    break;
                                }

                                outputCmtNum++;

                                mainDic.Add(itemRec.FREEFIELD4 + outputCmtNum.ToString(), Util.ConvertToString(cmtRec.JUDCMTSTC).Trim());
                                
                            }

                            //最大項目数になるまで繰り返し
                            while (outputCmtNum < maxCmtNum)
                            {
                                outputCmtNum++;

                                mainDic.Add(itemRec.FREEFIELD4 + outputCmtNum.ToString(), "");

                            }

                            break;

                        case "RSL":
                            // 結果

                            // 検査項目コードの分割
                            string itemCd = "";
                            string suffix = "";
                            string[] workList = itemRec.FREEFIELD3.Split('|');
                            switch (workList.Length)
                            {
                                case 2:
                                    itemCd = workList[0].Trim();
                                    suffix = workList[1].Trim();
                                    break;

                                default:
                                    break;
                            }

                            if (suffix == "**")
                            {
                                // 所見項目

                                // 所見情報の取得
                                var syokenDataList = new List<string>();
                                syokenDataList = GetSyokenData(syokenData, Util.ConvertToString(itemRec.FREEFIELD2));

                                //最大出力項目数取得
                                int maxSyokenNum = 0;
                                int.TryParse(syokenDataList[0], out maxSyokenNum);

                                // 所見項目コードの分割
                                string[] syokenWorkList = syokenDataList[3].Split('|');

                                //出力項目数
                                int outputSyokenNum = 0;

                                //未実施フラグ
                                bool stopFlg = false;

                                foreach (string syokenCode in syokenWorkList)
                                {
                                    // 最大項目に達したまたは未実施の場合処理を抜ける
                                    if (outputSyokenNum >= maxSyokenNum || stopFlg == true)
                                    {
                                        break;
                                    }

                                    //所見保存リスト
                                    var syokenTempList = new List<string>();

                                    foreach (var resultSyokenRec in resultData)
                                    {

                                        // 最大項目に達したまたは未実施の場合処理を抜ける
                                        if (outputSyokenNum >= maxSyokenNum || stopFlg == true)
                                        {
                                            break;
                                        }

                                        if (resultSyokenRec.ITEMCD == syokenCode)
                                        {
                                            //所見項目の中でキャンセルされた項目は"未実施"を格納
                                            //グループで管理している複数の所見項目の場合、最初(代表)項目のみ"未実施"を格納
                                            if (resultSyokenRec.STOPFLG == "S")
                                            {
                                                outputSyokenNum++;

                                                // 項目数が1つの場合はヘッダに数値をつけない
                                                if (maxSyokenNum == 1)
                                                {
                                                    mainDic.Add(itemRec.FREEFIELD4, "未実施");
                                                }
                                                else
                                                {
                                                    mainDic.Add(itemRec.FREEFIELD4 + outputSyokenNum.ToString(), "未実施");
                                                }

                                                stopFlg = true;
                                            }
                                            else
                                            {
                                                if (!string.IsNullOrEmpty(resultSyokenRec.REPTSTC.Trim()))
                                                {
                                                    if(syokenDataList[2] == "Y")
                                                    {
                                                        // 部位表示が必要な所見の場合、先頭に部位名称を追加
                                                        outputSyokenNum++;
                                                        // 項目数が1つの場合はヘッダに数値をつけない
                                                        if (maxSyokenNum == 1)
                                                        {
                                                            mainDic.Add(itemRec.FREEFIELD4, resultSyokenRec.REQUESTNAME + "：" + resultSyokenRec.REPTSTC);
                                                        }
                                                        else
                                                        {
                                                            mainDic.Add(itemRec.FREEFIELD4 + outputSyokenNum.ToString(), resultSyokenRec.REQUESTNAME + "：" + resultSyokenRec.REPTSTC);
                                                        }      
                                                    }
                                                    else
                                                    {
                                                        // 同じ所見は除外する
                                                        bool existFlg = false;

                                                        foreach(string tmpSyoken in syokenTempList)
                                                        {
                                                            if (tmpSyoken == resultSyokenRec.REPTSTC.Trim())
                                                            {
                                                                existFlg = true;
                                                            }
                                                        }

                                                        if (!existFlg)
                                                        {
                                                            outputSyokenNum++;

                                                            // 項目数が1つの場合はヘッダに数値をつけない
                                                            if (maxSyokenNum == 1)
                                                            {
                                                                mainDic.Add(itemRec.FREEFIELD4, resultSyokenRec.REPTSTC.Trim());
                                                            }
                                                            else
                                                            {
                                                                mainDic.Add(itemRec.FREEFIELD4 + outputSyokenNum.ToString(), resultSyokenRec.REPTSTC.Trim());
                                                            }

                                                            syokenTempList.Add(resultSyokenRec.REPTSTC.Trim());
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }


                                //最大項目数になるまで繰り返し
                                while (outputSyokenNum < maxSyokenNum)
                                {
                                    outputSyokenNum++;
                                    // 項目数が1つの場合はヘッダに数値をつけない
                                    if (maxSyokenNum == 1)
                                    {
                                        mainDic.Add(itemRec.FREEFIELD4, "");
                                    }
                                    else
                                    {
                                        mainDic.Add(itemRec.FREEFIELD4 + outputSyokenNum.ToString(), "");
                                    }
                                }

                            }
                            else
                            {
                                // 通常項目
                                string tmpResult = "";
                                string lowVal = "";
                                string maxVal = "";
                                foreach (var resultRec in resultData)
                                {
                                    if (resultRec.ITEMCD == itemCd && resultRec.SUFFIX == suffix)
                                    {
                                        //キャンセルフラグが立てられた検査項目のみ"未実施"を格納
                                        if (resultRec.STOPFLG == "S")
                                        {
                                            tmpResult = "未実施";
                                        }
                                        else
                                        {
                                            if (!string.IsNullOrEmpty(Util.ConvertToString(resultRec.REPTSTC).Trim()))
                                            {
                                                tmpResult = Util.ConvertToString(resultRec.REPTSTC).Trim();
                                            }
                                            else
                                            {
                                                switch (resultRec.RESULTTYPE)
                                                {
                                                    case 6:
                                                        var rDate = DateTime.Parse(Convert.ToString(resultRec.RESULT).Trim());
                                                        tmpResult = rDate.toString("YYYY-MM-DD");
                                                        break;
                                                    case 8:
                                                        tmpResult = Util.ConvertToString(resultRec.RESULT).Trim() + Util.ConvertToString(resultRec.RSLCMTNAME).Trim();
                                                        break;
                                                    default:
                                                        tmpResult = AdjustValue(Util.ConvertToString(resultRec.RESULT).Trim());
                                                        break;
                                                }
                                            }
                                        }

                                        // 基準値退避
                                        lowVal = AdjustValue(Util.ConvertToString(resultRec.LOWERVALUE).Trim());
                                        maxVal = AdjustValue(Util.ConvertToString(resultRec.UPPERVALUE).Trim());

                                        break;
                                    }
                                }

                                //値の設定
                                mainDic.Add(itemRec.FREEFIELD4, tmpResult);
                                if (itemRec.FREEFIELD6 == "Y")
                                {
                                    mainDic.Add("下限値:" + itemRec.FREEFIELD4, lowVal);
                                    mainDic.Add("上限値:" + itemRec.FREEFIELD4, maxVal);
                                }
                            }

                            break;
                    }
                }

                // 問診項目
                if (queryParams["ocrcheck"] == "1")
                {

                    //喫煙情報
                    IList<dynamic> smokeData = freeDao.SelectFree(1, "A-N-SMOKE");
                    //睡眠情報
                    IList<dynamic> sleepData = freeDao.SelectFree(1, "A-N-SLEEP");

                    string freAlcohol = "";
                    string stcAlcohol = "";
                    string cntAlcohol = "";

                    string regMeal = "";
                    string stcRegMeal = "";
                    string cntMeal = "";

                    string snack = "";
                    string stcSnack = "";
                    string cntSnack = "";


                    var MonshinResultData = GetMonshinData(rsvno, OCR_ITEM_GRPCD);

                    foreach (var monshinRec in MonshinResultData)
                    {
                        switch (Util.ConvertToString(monshinRec.ITEMCD))
                        {
                            case "63040":
                                freAlcohol = monshinRec.RESULT;
                                stcAlcohol = monshinRec.REPTSTC;
                                break;
                                
                            case "63050":
                                cntAlcohol = monshinRec.RESULT;
                                break;

                            case "61150":
                                regMeal = monshinRec.RESULT;
                                stcRegMeal = monshinRec.REPTSTC;
                                break;

                            case "61160":
                                cntMeal = monshinRec.RESULT;
                                break;

                            case "61210":
                                snack = monshinRec.RESULT;
                                stcSnack = monshinRec.REPTSTC;
                                break;

                            case "61220":
                                cntSnack = monshinRec.RESULT;
                                break;
                        }
                    }

                    string mPressure = "いいえ";
                    string mSugar = "いいえ";
                    string mFat = "いいえ";

                    // 血圧,脂質,糖尿病　薬剤使用情報取得
                    foreach (var medicineRec in GetMedicineData(rsvno))
                    {
                        if (int.TryParse(Util.ConvertToString(medicineRec.KETSUATSU), out int iPressure))
                        {
                            if (iPressure > 0)
                            {
                                mPressure = "はい";
                            }
                        }
                        if (int.TryParse(Util.ConvertToString(medicineRec.TOUNYOU), out int iSugar))
                        {
                            if (iSugar > 0)
                            {
                                mSugar = "はい";
                            }
                        }
                        if (int.TryParse(Util.ConvertToString(medicineRec.SHISITSU), out int iFat))
                        {
                            if (iFat > 0)
                            {
                                mFat = "はい";
                            }
                        }
                    }

                    string mBrain = "いいえ";
                    string mHeart = "いいえ";
                    string mKidney = "いいえ";
                    string mAnemia = "いいえ";

                    // 現病歴,既往歴の問診情報取得
                    foreach (var diseaseRec in GetDiseaseData(rsvno))
                    {
                        switch (Util.ConvertToString(diseaseRec.RSLDISEASE))
                        {
                            case "2":
                            case "3":
                            case "4":
                                // 脳梗塞、クモ膜下出血、脳出血
                                mBrain = "はい";
                                break;
                            case "20":
                            case "21":
                                // 狭心症、心筋梗塞
                                mHeart = "はい";
                                break;
                            case "50":
                                // 貧血
                                mAnemia = "はい";
                                break;
                            case "55":
                                // 慢性腎不全
                                mKidney = "はい";
                                break;
                        }
                        if (diseaseRec.RSLSTATUS == "11")
                        {
                            // 透析中
                            mKidney = "はい";
                        }
                    }

                    foreach (var monshinRec in monshinData)
                    {

                        string MonshinTmp = "";

                        switch (Util.ConvertToString(monshinRec.FREEFIELD1))
                        {
                            case "DIS": //病歴情報
                                switch (Util.ConvertToString(monshinRec.FREEFIELD2))
                                {
                                    case "B": //病歴(脳血管疾患)
                                        MonshinTmp = mBrain;
                                        break;
                                    case "H": //病歴(心血管)
                                        MonshinTmp = mHeart;
                                        break;
                                    case "K": //病歴(腎不全・人工透析)
                                        MonshinTmp = mKidney;
                                        break;
                                    case "A": //病歴(貧血)
                                        MonshinTmp = mAnemia;
                                        break;
                                }
                                break;

                            case "MED":
                                switch (Util.ConvertToString(monshinRec.FREEFIELD2))
                                {
                                    case "P": //服薬1(血圧)
                                        MonshinTmp = mPressure;
                                        break;
                                    case "S": //服薬2(血糖)
                                        MonshinTmp = mSugar;
                                        break;
                                    case "F": //服薬3(脂質)
                                        MonshinTmp = mFat;
                                        break;
                                }
                                break;

                            case "RSL":
                                foreach (var monshinResultRec in MonshinResultData)
                                {
                                    if (monshinResultRec.ITEMCD == monshinRec.FREEFIELD3 && monshinResultRec.SUFFIX == monshinRec.FREEFIELD4)
                                    {
                                        switch (Util.ConvertToString(monshinRec.FREEFIELD2))
                                        {
                                            case "R":
                                                string tmpRet = monshinResultRec.RESULT.Trim();

                                                if (!string.IsNullOrEmpty(tmpRet))
                                                {
                                                    switch (Util.ConvertToString(monshinResultRec.ITEMCD))
                                                    {
                                                        case "63070":
                                                            MonshinTmp = GetStcValue(smokeData, tmpRet);
                                                            break;

                                                        case "63021":
                                                            MonshinTmp = tmpRet + "kg";
                                                            break;

                                                        case "63082":
                                                            MonshinTmp = tmpRet + "分";
                                                            break;

                                                        case "63130":
                                                            MonshinTmp = GetStcValue(sleepData, tmpRet);
                                                            break;

                                                    }
                                                    break;
                                                }

                                                break;
                                            case "S":
                                                MonshinTmp = monshinResultRec.REPTSTC.Trim();
                                                break;

                                        }
                                        break;
                                    }
                                }
                                break;

                            case "CHA":
                                switch (Util.ConvertToString(monshinRec.FREEFIELD2))
                                {
                                    case "A":
                                        switch (freAlcohol)
                                        {
                                            case "1": //習慣的に飲む、ときどき飲むの場合、週間飲酒回数を格納
                                            case "2":
                                                if (!string.IsNullOrEmpty(cntAlcohol))
                                                {
                                                    MonshinTmp = "週 ( " + cntAlcohol + "日)";
                                                }
                                                break;

                                            case "3": //飲まない場合、そのまま結果文章を格納
                                                MonshinTmp = stcAlcohol;
                                                break;

                                        }
                                        break;

                                    case "M":
                                        switch (regMeal)
                                        {
                                            case "2": //それほどでもないの場合、1週間の平均欠食回数を格納
                                                MonshinTmp = stcRegMeal + "(1週間の平均欠食回数 " + cntMeal + "回)";
                                                break;

                                            case "1": //規則正しいの場合、回数は***で表示
                                                MonshinTmp = stcRegMeal;
                                                break;
                                        }
                                        break;

                                    case "S":
                                        switch (snack)
                                        {
                                            case "2": //食べるの場合、1週間の平均間食回数を格納
                                                if (!string.IsNullOrEmpty(cntSnack))
                                                {
                                                    MonshinTmp = stcSnack + "(1週間の平均間食回数 " + cntSnack + "回)";
                                                }
                                                else
                                                {
                                                    MonshinTmp = stcSnack;
                                                }
                                                break;

                                            case "1": //食べないの場合、回数は***で表示
                                                MonshinTmp = stcSnack;
                                                break;
                                        }
                                        break;
                                }
                                break;

                            case "ALC":
                                // 1日飲むアルコール量
                                MonshinTmp = GetResultAlcohol(rsvno);
                                break;
                        }

                        mainDic.Add(monshinRec.FREEFIELD5, MonshinTmp);
                    }
                }

                // ヘッダの作成
                if (isFirst)
                {
                    // ヘッダデータ
                    var headerDic = new Dictionary<string, object>();

                    foreach (var mainRec in mainDic)
                    {
                        if (mainRec.Key.Contains("下限値"))
                        {
                            headerDic.Add(mainRec.Key, "下限値");
                        }
                        else if (mainRec.Key.Contains("上限値"))
                        {
                            headerDic.Add(mainRec.Key, "上限値");
                        }
                        else
                        {
                            headerDic.Add(mainRec.Key, mainRec.Key);
                        }
                    }

                    returnData.Add(headerDic);

                    isFirst = false;
                }

                returnData.Add(mainDic);

            }

            return returnData;
        }

        /// <summary>
        /// 判定情報取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>判定情報データ</returns>
        private dynamic GetJudData(int rsvNo)
        {

            // SQLステートメント定義
            string sql = @"
                        select
                            jc.judclassname
                            , jr.judcd
                            , jr.judclasscd
                            , fr1.freefield2 as judname 
	                        , fr2.freefield2 as weight
                        from
                            judrsl jr 
                            inner join judclass jc 
                                on jr.judclasscd = jc.judclasscd 
                            left join free fr1 
                                on jr.judcd = fr1.freefield1 
                                and fr1.freeclasscd = 'A-N-JUD' 
                            left join free fr2 
                                on jr.judcd = fr2.freefield1 
                                and fr2.freeclasscd = 'A-N-JUD2' 
                        where
                            jr.rsvno = :rsvno
                            and jr.judclasscd between 1 and 31 
                        order by
                            jc.judclasscd
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo
            };

            // SQLステートメント実行
            return connection.Query(sql, sqlParam).ToList();

        }

        /// <summary>
        /// 婦人科判定情報編集
        /// </summary>
        /// <param name="gyneDic">婦人科判定テーブル</param>
        /// <returns>一番重い判定データ</returns>
        private List<string> GetGyneJudData(Dictionary<int, List<string>> gyneDic)
        {

            int weight = 0;
            string jud = "";
            string judContent = "";
            foreach (KeyValuePair<int, List<string>> row in gyneDic)
            {
                if (int.TryParse(row.Value[2], out int TmpWeight))
                {
                    if (TmpWeight > weight)
                    {
                        jud = row.Value[0];
                        judContent = row.Value[1];
                        weight = TmpWeight;
                    }
                }
            }

            var gyneList = new List<string>()
            {
                jud
                ,judContent
            };

            return gyneList;

        }

        /// <summary>
        /// 総合コメント情報取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>総合コメントデータ</returns>
        private dynamic GetCmtData(int rsvNo)
        {

            // SQLステートメント定義
            string sql = @"
                        select
                            a.judcmtcd
                            , b.judcmtstc 
                        from
                            totaljudcmt a
                            , judcmtstc b 
                        where
                            rsvno = :rsvno 
                            and a.dispmode = 1 
                            and a.judcmtcd = b.judcmtcd
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo
            };

            // SQLステートメント実行
            return connection.Query(sql, sqlParam).ToList();

        }

        /// <summary>
        /// 該当する繰り返し情報の取得
        /// </summary>
        /// <param name="loopData">繰り返し情報テーブル</param>
        /// <param name="loopId">識別ID</param>
        /// <returns>繰り返し情報データ</returns>
        private List<string> GetLoopData(IList<dynamic>loopData ,string loopId)
        {

            string startPos = "";
            string endPos = "";
            string loopNum = "";
            foreach (var loopRec in loopData)
            {
                if (loopRec.FREEFIELD1 == loopId)
                {
                    startPos = loopRec.FREEFIELD2;
                    endPos = loopRec.FREEFIELD3;
                    loopNum = loopRec.FREEFIELD4;
                }
            }

            var loopList = new List<string>()
            {
                startPos
                ,endPos
                ,loopNum
            };

            return loopList;

        }

        /// <summary>
        /// 検査結果取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="gender">性別</param>
        /// <param name="cslDate">受診日</param>
        /// <returns>検査結果データ</returns>
        private dynamic GetResultData(int rsvNo, string grpCd, int gender, DateTime cslDate)
        {

            // SQLステートメント定義
            string sql = @"
                        select
                            mresult.itemcd
                            , mresult.suffix
                            , mresult.itemname
                            , mresult.seq
                            , mresult.requestname
                            , mresult.result
                            , nvl(sentence.reptstc, ' ') reptstc
                            , sentence.itemtype
                            , stdvalue.lowervalue
                            , stdvalue.uppervalue
                            , stdvalue.gender
                            , mresult.resulttype
                            , rslcmt.rslcmtname
                            , mresult.stopflg 
                        from
                            sentence
                            , ( 
                                -- 受診者別契約項目を元にして結果データを抽出
                                select
                                    item_c.itemcd as itemcd
                                    , item_c.suffix as suffix
                                    , item_c.itemname as itemname
                                    , item_c.resulttype as resulttype
                                    , item_c.itemtype as itemtype
                                    , item_c.stcitemcd as stcitemcd
                                    , item_p.classcd as classcd
                                    , item_p.requestname as requestname
                                    , grp_i.seq as seq
                                    , rsl.result as result
                                    , decode(rsl.rsvno, null, 'S', rsl.stopflg) as stopflg
                                    , rsl.rslcmtcd1 as rslcmtcd1 
                                from
                                    ( 
                                        -- 受診者別契約項目取得
                                        select
                                            items.rsvno as rsvno
                                            , item_c.itemcd as itemcd
                                            , item_c.suffix as suffix 
                                        from
                                            ( 
                                                select
                                                    consult.rsvno as rsvno
                                                    , ctrpt_item.itemcd as itemcd 
                                                from
                                                    ctrpt_item
                                                    , consult_o
                                                    , consult 
                                                where
                                                    consult.rsvno = :rsvno 
                                                    and consult.rsvno = consult_o.rsvno 
                                                    and consult.ctrptcd = consult_o.ctrptcd 
                                                    and consult.ctrptcd = ctrpt_item.ctrptcd 
                                                    and consult_o.optcd = ctrpt_item.optcd 
                                                    and consult_o.optbranchno = ctrpt_item.optbranchno 
                                                union 
                                                select
                                                    finalgrp.rsvno as rsvno
                                                    , grp_r.itemcd as itemcd 
                                                from
                                                    grp_r
                                                    , ( 
                                                        select
                                                            consult.rsvno
                                                            , consult.cancelflg
                                                            , consult.csldate
                                                            , consult.perid
                                                            , consult.cscd
                                                            , consult.orgcd1
                                                            , consult.orgcd2
                                                            , consult.ctrptcd
                                                            , ctrpt_grp.grpcd 
                                                        from
                                                            ctrpt_grp
                                                            , consult_o
                                                            , consult 
                                                        where
                                                            consult.rsvno = :rsvno 
                                                            and consult.rsvno = consult_o.rsvno 
                                                            and consult.ctrptcd = consult_o.ctrptcd 
                                                            and consult.ctrptcd = ctrpt_grp.ctrptcd 
                                                            and consult_o.optcd = ctrpt_grp.optcd 
                                                            and consult_o.optbranchno = ctrpt_grp.optbranchno
                                                    ) finalgrp 
                                                where
                                                    grp_r.grpcd = finalgrp.grpcd
                                            ) items
                                            , item_c 
                                        where
                                            items.itemcd = item_c.itemcd
                                    ) tot_items
                                    , rsl
                                    , item_c
                                    , item_p
                                    , grp_i 
                                where
                                    tot_items.rsvno = rsl.rsvno(+) 
                                    and tot_items.itemcd = rsl.itemcd(+) 
                                    and tot_items.suffix = rsl.suffix(+) 
                                    and grp_i.grpcd = :grpcd 
                                    and tot_items.itemcd = item_p.itemcd 
                                    and tot_items.itemcd = item_c.itemcd 
                                    and tot_items.suffix = item_c.suffix 
                                    and tot_items.itemcd = grp_i.itemcd 
                                    and tot_items.suffix = grp_i.suffix
                            ) mresult
                            , ( 
                                -- 検査項目別基準値データ取得
                                select
                                    std.itemcd
                                    , std.suffix
                                    , std.strdate
                                    , std.enddate
                                    , std_c.gender
                                    , std_c.stdvaluemngcd
                                    , std_c.lowervalue
                                    , std_c.uppervalue
                                    , std_c.stdflg 
                                from
                                    stdvalue std
                                    , stdvalue_c std_c 
                                where
                                    std.stdvaluemngcd = std_c.stdvaluemngcd 
                                    and std_c.stdflg = 'S' 
                                    and std_c.gender = :gender 
                                    and :csldate between std.strdate and std.enddate
                            ) stdvalue
                            , rslcmt 
                        where
                            mresult.stcitemcd = sentence.itemcd(+) 
                            and mresult.itemtype = sentence.itemtype(+) 
                            and mresult.result = sentence.stccd(+) 
                            and mresult.itemcd = stdvalue.itemcd(+) 
                            and mresult.suffix = stdvalue.suffix(+) 
                            and mresult.rslcmtcd1 = rslcmt.rslcmtcd(+) 
                        order by
                            mresult.seq
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                gender,
                grpcd = grpCd,
                csldate = cslDate
            };

            // SQLステートメント実行
            return connection.Query(sql, sqlParam).ToList();

        }

        /// <summary>
        /// 所見情報の取得
        /// </summary>
        /// <param name="syokenData">所見情報テーブル</param>
        /// <param name="syokenId">識別ID</param>
        /// <returns>所見情報データ</returns>
        private List<string> GetSyokenData(IList<dynamic> syokenData, string syokenId)
        {

            string itemNum = "";
            string itemName = "";
            string buiFlg = "";
            string itemCd = "";
            foreach (var syokenRec in syokenData)
            {
                if (syokenRec.FREEFIELD1 == syokenId)
                {
                    itemNum = syokenRec.FREEFIELD2;
                    itemName = syokenRec.FREEFIELD3;
                    buiFlg = syokenRec.FREEFIELD4;
                    itemCd = syokenRec.FREEFIELD5;
                }
            }

            var syokenList = new List<string>()
            {
                itemNum
                ,itemName
                ,buiFlg
                ,itemCd
            };

            return syokenList;

        }

        /// <summary>
        /// 問診結果取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="grpCd">グループコード</param>
        /// <returns>問診結果データ</returns>
        private dynamic GetMonshinData(int rsvNo,string grpCd)
        {

            // SQLステートメント定義
            string sql = @"
                            select
                                itemrsl.itemcd itemcd
                                , itemrsl.suffix suffix
                                , itemrsl.itemname itemname
                                , itemrsl.result result
                                , sentence.reptstc reptstc 
                            from
                                ( 
                                    select
                                        item_c.itemcd itemcd
                                        , item_c.suffix suffix
                                        , item_c.stcitemcd stcitemcd
                                        , item_c.itemtype itemtype
                                        , item_c.itemname itemname
                                        , rsl.result result 
                                    from
                                        rsl
                                        , grp_i
                                        , item_c 
                                    where
                                        rsl.rsvno = :rsvno 
                                        and grp_i.grpcd = :grpcd 
                                        and rsl.result is not null 
                                        and rsl.itemcd = grp_i.itemcd 
                                        and rsl.suffix = grp_i.suffix 
                                        and rsl.itemcd = item_c.itemcd 
                                        and rsl.suffix = item_c.suffix
                                ) itemrsl
                                , sentence 
                            where
                                itemrsl.stcitemcd = sentence.itemcd(+) 
                                and itemrsl.itemtype = sentence.itemtype(+) 
                                and itemrsl.result = sentence.stccd(+) 
                            order by
                                itemrsl.itemcd
                                , itemrsl.suffix
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                grpcd = grpCd
            };

            // SQLステートメント実行
            return connection.Query(sql, sqlParam).ToList();

        }

        /// <summary>
        /// 現病歴の薬剤治療中情報取得（高血圧、糖尿病、高脂血症）
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>薬剤情報データ</returns>
        private dynamic GetMedicineData(int rsvNo)
        {

            // SQLステートメント定義
            string sql = @"
                            select
                                sum(final.ketsuatsu) as ketsuatsu
                                , sum(final.tounyou) as tounyou
                                , sum(final.shisitsu) as shisitsu 
                            from
                                ( 
                                    select
                                        rslview.rsvno as rsvno
                                        , decode(rslview.result, '19', count(rslview.rsvno), 0) as ketsuatsu
                                        , decode(rslview.result, '48', count(rslview.rsvno), 0) as tounyou
                                        , decode(rslview.result, '47', count(rslview.rsvno), 0) as shisitsu 
                                    from
                                        ( 
                                            select
                                                rsl.rsvno
                                                , free.freefield3 result
                                                , rsl.itemcd
                                                , rsl.suffix 
                                            from
                                                rsl
                                                , consult
                                                , grp_i
                                                , free 
                                            where
                                                consult.rsvno = :rsvno 
                                                and grp_i.grpcd = :disease_grpcd 
                                                and rsl.rsvno = consult.rsvno 
                                                and rsl.itemcd = grp_i.itemcd 
                                                and rsl.suffix = grp_i.suffix 
                                                and rsl.suffix = '01' 
                                                and free.freecd = :freecd1 || rsl.result
                                        ) rslview
                                        , ( 
                                            select
                                                rsl.rsvno
                                                , rsl.result
                                                , rsl.itemcd
                                                , rsl.suffix 
                                            from
                                                rsl
                                                , consult
                                                , grp_i
                                                , free 
                                            where
                                                consult.rsvno = :rsvno 
                                                and grp_i.grpcd = :disease_grpcd 
                                                and rsl.rsvno = consult.rsvno 
                                                and rsl.itemcd = grp_i.itemcd 
                                                and rsl.suffix = grp_i.suffix 
                                                and rsl.suffix = '03' 
                                                and free.freecd = :freecd2 || rsl.result
                                        ) statview 
                                    where
                                        rslview.rsvno = statview.rsvno 
                                        and rslview.itemcd = statview.itemcd 
                                    group by
                                        rslview.rsvno
                                        , rslview.result
                                ) final 
                            group by
                                final.rsvno
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                disease_grpcd = META_DISEASE_GRPCD,
                freecd1 = FREECD_METADIS,
                freecd2 = FREECD_METASTS
            };

            // SQLステートメント実行
            return connection.Query(sql, sqlParam).ToList();

        }

        /// <summary>
        /// 現病歴・既往歴情報取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>現病歴・既往歴データ</returns>
        private dynamic GetDiseaseData(int rsvNo)
        {

            // SQLステートメント定義
            string sql = @"
                            select
                                rslview.result as rsldisease
                                , statview.result as rslstatus 
                            from
                                ( 
                                    select
                                        rsl.rsvno
                                        , rsl.result
                                        , rsl.itemcd
                                        , rsl.suffix 
                                    from
                                        rsl
                                        , grp_i 
                                    where
                                        rsl.rsvno = :rsvno 
                                        and grp_i.grpcd = :disease_grpcd 
                                        and rsl.itemcd = grp_i.itemcd 
                                        and rsl.suffix = grp_i.suffix 
                                        and rsl.suffix = '01'
                                ) rslview
                                , ( 
                                    select
                                        rsl.rsvno
                                        , rsl.result
                                        , rsl.itemcd
                                        , rsl.suffix 
                                    from
                                        rsl
                                        , grp_i 
                                    where
                                        rsl.rsvno = :rsvno 
                                        and grp_i.grpcd = :disease_grpcd 
                                        and rsl.itemcd = grp_i.itemcd 
                                        and rsl.suffix = grp_i.suffix 
                                        and rsl.suffix = '03'
                                ) statview 
                            where
                                rslview.rsvno = statview.rsvno(+) 
                                and rslview.itemcd = statview.itemcd(+)
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                disease_grpcd = DISEASE_GRPCD
            };

            // SQLステートメント実行
            return connection.Query(sql, sqlParam).ToList();

        }

        /// <summary>
        /// 喫煙・睡眠の所見内容を汎用テーブルから取得
        /// </summary>
        /// <param name="freeData">所見情報テーブル</param>
        /// <param name="stcCD">識別ID</param>
        /// <returns>該当する所見</returns>
        private string GetStcValue(IList<dynamic> freeData, string stcCD)
        {

            string returnData = "";

            foreach (var freeRec in freeData)
            {
                if (freeRec.FREEFIELD1 == stcCD)
                {
                    returnData = freeRec.FREEFIELD2;
                }
            }

            return returnData;

        }

        /// <summary>
        /// アルコール換算を取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>1日アルコール合計</returns>
        private string GetResultAlcohol(int rsvNo)
        {

            string returnData = "";

            // SQLステートメント定義
            string sql = @"
                            select
                                nvl(sum(lastview.alcohol), 0) as sumalcohol 
                            from
                                ( 
                                    select
                                        decode( 
                                            rsl.itemcd
                                            , '60180'
                                            , to_number(rsl.result) * 1.26
                                            , '60181'
                                            , to_number(rsl.result) * 0.7
                                            , '60182'
                                            , to_number(rsl.result)
                                            , '60183'
                                            , to_number(rsl.result)
                                            , '60184'
                                            , to_number(rsl.result) * 0.5
                                            , '60185'
                                            , to_number(rsl.result) * 0.5
                                            , '60186'
                                            , to_number(rsl.result) * 0.5
                                            , '60187'
                                            , to_number(rsl.result) * 0.5
                                        ) as alcohol 
                                    from
                                        rsl
                                        , grp_i 
                                    where
                                        rsl.rsvno = :rsvno 
                                        and grp_i.grpcd = :alcohol_grpcd 
                                        and rsl.itemcd = grp_i.itemcd 
                                        and rsl.suffix = grp_i.suffix 
                                        and rsl.result is not null
                                ) lastview
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                alcohol_grpcd = ALCOHOL_GRPCD
            };

            // SQLステートメント実行
            var alcoholData = connection.Query(sql, sqlParam).ToList();

            foreach (var alcoholRec in alcoholData)
            {
                if (float.TryParse(Util.ConvertToString(alcoholRec.SUMALCOHOL), out float fAlcohol))
                {
                    if (fAlcohol < 1)
                    {
                        returnData = "１合未満";
                    }
                    else if (fAlcohol < 2)
                    {
                        returnData = "１～２合未満";
                    }
                    else if (fAlcohol < 2)
                    {
                        returnData = "２～３合未満";
                    }
                    else
                    {
                        returnData = "３合以上";
                    }
                }
            }

            return returnData;

        }


        /// <summary>
        /// 結果値の小数点調整
        /// </summary>
        /// <param name="result">値</param>
        /// <returns>小数点以下が0の場合、切り取った値</returns>
        private string AdjustValue(string result)
        {

            string returnData = "";

            if (float.TryParse(Util.ConvertToString(result).Trim(), out float fResult))
            {
                returnData = fResult.ToString();
            }
            else
            {
                returnData = result;
            }

            return returnData;

        }

        /// <summary>
        /// 特定健診の切り替え日を取得
        /// </summary>
        /// <param name="spItem">識別ID</param>
        /// <returns>切り替え日</returns>
        private string GetSpSwitchingDate(string spItem)
        {

            string returnData = "";

            // 汎用マスタの読み込み
            var freeDao = new FreeDao(connection);

            IList<dynamic> freeData = freeDao.SelectFree(0, spItem);

            foreach (var freeRec in freeData)
            {
                returnData = Util.ConvertToString(freeRec.FREEFIELD1);
            }

            return returnData;

        }

    }

}
