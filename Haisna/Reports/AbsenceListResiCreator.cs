using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.ReportCore;
using System;
using System.Collections.Generic;
using System.Linq;
using Hainsi.Entity;
using Microsoft.VisualBasic;

namespace Hainsi.Reports
{
    //[LoggingParam]
    public class AbsenceListResiCreator : CsvCreator
    {

        /// <summary>
        /// ファイル名
        /// </summary>
        private const string FILENAME_DEF = "CD";

        /// <summary>
        /// パラメタ
        /// </summary>
        private const int MAX_COUNT_ORG = 5;    //団体コード最大設定数

        /// <summary>
        /// コースコード（未指定時）
        /// </summary>
        private const string CSCD_DEF1 = "100";
        private const string CSCD_DEF2 = "105";
        private const string CSCD_DEF3 = "110";
        private const string CSCD_DEF4 = "133";

        /// <summary>
        /// 汎用コード
        /// </summary>
        private const string FREECD_GRP = "A-RES-GRPCD";     //検査結果取得用　グループコード設定
        private const string FREECD_HUJIN_CLASS = "GYNECLASS%";     //婦人科クラス

        /// <summary>
        /// 汎用分類コード
        /// </summary>
        private const string FREECLASSCD_HUJIN_CLASS = "GYN";       //婦人科クラス

        /// <summary>
        /// グループコード
        /// </summary>
        private const string GRPCD_GYNE = "X663";      //婦人科細胞診グループコード
        private const string GRPCD_STOOL = "X526";      //便潜血グループコード
        private const string GRPCD_PLAQUE = "X530";     //頸動脈超音波プラークグループコード

        /// <summary>
        /// 判定分類コード
        /// </summary>
        private const string JUDCLASSCD_NYUBOU = "24";     //乳房
        private const string JUDCLASSCD_NYUSYOKU = "54";    //乳房触診
        private const string JUDCLASSCD_NYUXSEN = "55";     //乳房Ｘ線
        private const string JUDCLASSCD_NYUCHOU = "56";     //乳房超音波

        /// <summary>
        /// クラス分類
        /// </summary>
        private const string FU_FCLASS_KEBU = "FC1";
        private const string FU_FCLASS_KEBU2 = "FC2";
        private const string FU_FCLASS_CLASS = "FC3";
        private const string FU_NAISHIN = "NAISHIN";

        /// <summary>
        /// 汎用マスタ情報クラス
        /// </summary>
        private class SettingItem
        {
            public string DType { get; set; }      //データタイプ
            public string ItemCode { get; set; }   //項目コード
            public string Suffix { get; set; }     //サフィックス
            public string Link { get; set; }       //区分
            public string ItemName { get; set; }   //項目名
            public string JudClasscd { get; set; } //判定分類コード
            public int Size { get; set; }          //サイズ
            public string FixedRsl { get; set; }   //固定結果
            public string Point { get; set; }      //ポイント
        }

        /// <summary>
        /// 聖路加レジデンス提供用CSV出力情報を読み込み
        /// </summary>
        /// <returns>聖路加レジデンス提供用CSV出力情報</returns>
        protected override List<dynamic> GetData()
        {

            //団体パラメタ
            List<string> orgcd_list = new List<string>();   //団体情報
            for (int i = 1; i <= MAX_COUNT_ORG; i++)
            {
                string para_name1 = "orgcd1" + i.ToString();
                string para_name2 = "orgcd2" + i.ToString();

                //団体コード
                string orgcdWk = "";
                if ((!string.IsNullOrEmpty(queryParams[para_name1])) || (!string.IsNullOrEmpty(queryParams[para_name2])))
                {
                    //団体指定がある場合、値を退避
                    orgcdWk = queryParams[para_name1].Trim() + queryParams[para_name2].Trim();
                    //団体指定がある場合、団体コード１＋２値を退避
                    orgcd_list.Add(orgcdWk);
                }

            }

            //団体グループパラメタ
            string orgGrpcd = queryParams["orggrpcd"];

            //コースパラメタ
            string csCd = queryParams["cscd"];

            //受診区分パラメタ
            string cslDiv = queryParams["cslDiv"];

            //個人番号パラメタ
            string perId = queryParams["perid"];

            //SQLステートメント
            string sql = "";

            //団体請求対象者のみかによってSQL分岐
            if (queryParams["orgBill"] != "1")
            {
                //団体請求対象者以外
                sql += @"
                        select
                            to_char(consult.csldate, 'YYYY/MM/DD') csldate
                            , consult.rsvno rsvno
                            , person.perid perid
                            , person.gender gender
                            , to_char(person.birth, 'YYYY/MM/DD') birth
                            , decode( 
                                length(peraddr.zipcd)
                                , 7
                                , substr(peraddr.zipcd, 1, 3) || '-' || substr(peraddr.zipcd, 4)
                                , peraddr.zipcd
                            ) zipcd
                            , pref.prefname || peraddr.cityname || peraddr.address1 || peraddr.address2 address
                            , consult.isrsign isrsign
                            , nvl(consult.isrmanno, org.spare1) isrorgno
                            , consult.isrno isrno
                            , consult.csldivcd csldivcd
                            , free.freefield1 csldivname
                            , person.lastkname || person.firstkname kname
                            , person.lastname || person.firstname name
                            , person.romename romename
                            , consult.cscd cscd
                            , course_p.csname csname
                            , consult.orgcd1 orgcd1
                            , consult.orgcd2 orgcd2
                            , consult.rsvgrpcd rsvgrpcd
                            , rsvgrp.rsvgrpname rsvgrpname
                            , decode( 
                                ( 
                                    select
                                        min(ctrpt_opt.setclasscd) 
                                    from
                                        consult_o
                                        , ctrpt_opt 
                                    where
                                        consult.rsvno = consult_o.rsvno 
                                        and consult_o.optcd in ('1000', '1001') 
                                        and consult_o.ctrptcd = ctrpt_opt.ctrptcd 
                                        and consult_o.optcd = ctrpt_opt.optcd 
                                        and consult_o.optbranchno = ctrpt_opt.optbranchno
                                ) 
                                , '001'
                                , '23040'
                                , '035'
                                , '23040'
                                , '002'
                                , '23130'
                                , '003'
                                , '23130'
                                , '00000'
                            ) as setclass
                            , to_char(sysdate, 'YYYYMMDD') as outdate 
                        from
                            consult
                            , person
                            , peraddr
                            , receipt
                            , free
                            , course_p
                            , pref
                            , org
                            , rsvgrp 
                        where
                            consult.csldate between :startdate and :enddate 
                            and consult.cancelflg = :cancelflg 
                        ";

                //コース指定
                if (!string.IsNullOrEmpty(csCd))
                {
                    //コース指定あり
                    sql += @"
                            and consult.cscd = :cscd
                    ";
                }
                else
                {
                    //コース指定なし
                    sql += @"
                            and consult.cscd in (:cscd_def1, :cscd_def2, :cscd_def3, :cscd_def4) 
                    ";

                }

                sql += @"
                            and consult.csldivcd = free.freecd 
                            and consult.perid = person.perid 
                            and person.perid = peraddr.perid 
                            and peraddr.prefcd = pref.prefcd(+) 
                            and peraddr.addrdiv = 1 
                            and consult.rsvno = receipt.rsvno 
                            and receipt.comedate is not null 
                            and consult.cscd = course_p.cscd 
                            and consult.rsvgrpcd = rsvgrp.rsvgrpcd 
                            and consult.orgcd1 = org.orgcd1 
                            and consult.orgcd2 = org.orgcd2 
                ";

                //団体グループ指定
                if ((orgcd_list.Count > 0) || (!string.IsNullOrEmpty(orgGrpcd)))
                {
                    sql += @"
                    and ( 
                ";

                    //団体グループ指定
                    if (!string.IsNullOrEmpty(orgGrpcd))
                    {
                        sql += @"
                        (consult.orgcd1, consult.orgcd2) in ( 
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

                    //団体コード指定
                    if (orgcd_list.Count > 0)
                    {
                        //団体グループがある場合はorで連結
                        if (!string.IsNullOrEmpty(orgGrpcd))
                        {
                            sql += @"
                                or  
                        ";
                        }
                        sql += @"
                        ( consult.orgcd1 || consult.orgcd2 in ( '" + String.Join("','", orgcd_list) + "') )";
                    }

                    sql += @"
                    ) 
                ";
                }

                //受診区分指定あり
                if (! string.IsNullOrEmpty(cslDiv))
                {
                    sql += @"
                                and consult.csldivcd = :csldivcd                     
                    ";
                }

                //個人ID指定あり
                if (!string.IsNullOrEmpty(perId))
                {
                    sql += @"
                                and consult.perid = :perid 
                    ";
                }

                sql += @"
                                order by
                                    consult.orgcd1
                                    , consult.orgcd2
                                    , consult.csldate
                                    , receipt.dayid
                ";


            }
            else
            {
                //団体請求対象者のみ
                sql += @"
                    select
                        to_char(consult.csldate, 'YYYY/MM/DD') csldate --エラーになるため、スラッシュ区切りにする
                        , consult.rsvno rsvno
                        , person.perid perid
                        , person.gender gender
                        , to_char(person.birth, 'YYYY/MM/DD') birth --エラーになるため、スラッシュ区切りにする
                        , decode( 
                            length(peraddr.zipcd)
                            , 7
                            , substr(peraddr.zipcd, 1, 3) || '-' || substr(peraddr.zipcd, 4)
                            , peraddr.zipcd
                        ) zipcd
                        , pref.prefname || peraddr.cityname || peraddr.address1 || peraddr.address2 address
                        , consult.isrsign isrsign
                        , nvl(consult.isrmanno, org.spare1) isrorgno
                        , consult.isrno isrno
                        , consult.csldivcd csldivcd
                        , free.freefield1 csldivname
                        , person.lastkname || person.firstkname kname
                        , person.lastname || person.firstname name
                        , person.romename romename
                        , consult.cscd cscd
                        , course_p.csname csname
                        , consult.orgcd1 orgcd1
                        , consult.orgcd2 orgcd2
                        , consult.rsvgrpcd rsvgrpcd
                        , rsvgrp.rsvgrpname rsvgrpname
                        , decode( 
                            ( 
                                select
                                    min(ctrpt_opt.setclasscd) 
                                from
                                    consult_o
                                    , ctrpt_opt 
                                where
                                    consult.rsvno = consult_o.rsvno 
                                    and consult_o.optcd in ('1000', '1001') 
                                    and consult_o.ctrptcd = ctrpt_opt.ctrptcd 
                                    and consult_o.optcd = ctrpt_opt.optcd 
                                    and consult_o.optbranchno = ctrpt_opt.optbranchno
                            ) 
                            , '001'
                            , '23040'
                            , '035'
                            , '23040'
                            , '002'
                            , '23130'
                            , '003'
                            , '23130'
                            , '00000'
                        ) as setclass
                        , to_char(sysdate, 'YYYYMMDD') as outdate 
                    from
                        consult
                        , person
                        , peraddr
                        , receipt
                        , free
                        , course_p
                        , pref
                        , org
                        , rsvgrp
                        
                        --団体請求対象者のみ出力する
                        , ( 
                            select
                                consult.rsvno as rsvno 
                            from
                                consult
                                , receipt
                                , consult_m 
                            where
                                consult.csldate between :startdate and :enddate 
                                and consult.cancelflg = :cancelflg 
                ";

                //コース指定
                if (!string.IsNullOrEmpty(csCd))
                {
                    //コース指定あり
                    sql += @"
                            and consult.cscd = :cscd
                    ";
                }
                else
                {
                    //コース指定なし
                    sql += @"
                            and consult.cscd in (:cscd_def1, :cscd_def2, :cscd_def3, :cscd_def4) 
                    ";
                }

                //団体グループ指定
                if ((orgcd_list.Count > 0) || (!string.IsNullOrEmpty(orgGrpcd)))
                {
                    sql += @"
                    and ( 
                ";

                    //団体グループ指定
                    if (!string.IsNullOrEmpty(orgGrpcd))
                    {
                        sql += @"
                        (consult.orgcd1, consult.orgcd2) in ( 
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

                    //団体コード指定
                    if (orgcd_list.Count > 0)
                    {
                        //団体グループがある場合はorで連結
                        if (!string.IsNullOrEmpty(orgGrpcd))
                        {
                            sql += @"
                                or  
                        ";
                        }
                        sql += @"
                        ( consult.orgcd1 || consult.orgcd2 in ( '" + String.Join("','", orgcd_list) + "') )";
                    }

                    sql += @"
                    ) 
                ";
                }

                sql += @"
                                and consult.rsvno = receipt.rsvno 
                                and receipt.comedate is not null 
                                and consult.rsvno = consult_m.rsvno 
                                and consult_m.orgcd1 || consult_m.orgcd2 = :billorgcd
                            group by
                                consult.rsvno
                        ) lastview 
                    where
                        consult.csldate between :startdate and :enddate 
                        and consult.cancelflg = :cancelflg 
                ";

                //コース指定
                if (!string.IsNullOrEmpty(csCd))
                {
                    //コース指定あり
                    sql += @"
                            and consult.cscd = :cscd
                    ";
                }
                else
                {
                    //コース指定なし
                    sql += @"
                            and consult.cscd in (:cscd_def1, :cscd_def2, :cscd_def3, :cscd_def4) 
                    ";
                }



                sql += @"
                        and consult.csldivcd = free.freecd 
                        and consult.perid = person.perid 
                        and person.perid = peraddr.perid 
                        and peraddr.prefcd = pref.prefcd(+) 
                        and peraddr.addrdiv = 1 
                        and consult.rsvno = receipt.rsvno 
                        and receipt.comedate is not null 
                        and consult.cscd = course_p.cscd 
                        and consult.rsvgrpcd = rsvgrp.rsvgrpcd 
                        and consult.orgcd1 = org.orgcd1 
                        and consult.orgcd2 = org.orgcd2
                ";

                //団体グループ指定
                if ((orgcd_list.Count > 0) || (!string.IsNullOrEmpty(orgGrpcd)))
                {
                    sql += @"
                    and ( 
                ";

                    //団体グループ指定
                    if (!string.IsNullOrEmpty(orgGrpcd))
                    {
                        sql += @"
                        (consult.orgcd1, consult.orgcd2) in ( 
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

                    //団体コード指定
                    if (orgcd_list.Count > 0)
                    {
                        //団体グループがある場合はorで連結
                        if (!string.IsNullOrEmpty(orgGrpcd))
                        {
                            sql += @"
                                or  
                        ";
                        }
                        sql += @"
                        ( consult.orgcd1 || consult.orgcd2 in ( '" + String.Join("','", orgcd_list) + "') )";
                    }

                    sql += @"
                    ) 
                ";
                }

                sql += @"
                            and consult.rsvno = lastview.rsvno 
                ";

                //受診区分指定あり
                if (!string.IsNullOrEmpty(cslDiv))
                {
                    sql += @"
                                and consult.csldivcd = :csldivcd                     
                    ";
                }

                //個人ID指定あり
                if (!string.IsNullOrEmpty(perId))
                {
                    sql += @"
                                and consult.perid = :perid 
                    ";
                }

                sql += @"
                            order by
                                consult.orgcd1
                                , consult.orgcd2
                                , consult.csldate
                                , receipt.dayid
                ";

            }

            DateTime dt;
            var sDate = "";
            var eDate = "";
            if (DateTime.TryParse(Util.ConvertToString(queryParams["startdate"]), out dt))
            {
                sDate = dt.ToString("yyyyMMdd");
            }
            if (!string.IsNullOrEmpty(queryParams["enddate"]))
            {
                if (DateTime.TryParse(Util.ConvertToString(queryParams["enddate"]), out dt))
                {
                    eDate = dt.ToString("yyyyMMdd");
                }
            }
            else
            {
                //終了日付が未入力の場合は開始日付を設定
                eDate = sDate;
            }

            var sqlParam = new
            {
                startdate = sDate,
                enddate = eDate,
                cscd = csCd,
                orggrpcd = orgGrpcd,
                cscd_def1 = CSCD_DEF1,
                cscd_def2 = CSCD_DEF2,
                cscd_def3 = CSCD_DEF3,
                cscd_def4 = CSCD_DEF4,

                csldivcd = cslDiv,
                perid = perId,

                billorgcd = queryParams["billOrgcd1"] + queryParams["billOrgcd2"],

                cancelflg = ConsultCancel.Used
            };

            List<dynamic> dataList = connection.Query(sql, sqlParam).ToList();

            //編集処理
            List<dynamic> outPutData = new List<object>();
            EditData(dataList, out outPutData);

            return outPutData;

        }

        /// <summary>
        /// データ編集
        /// </summary>
        /// <param name="dataList">取得データ</param>
        /// <param name="outPutData">編集後データ</param>
        /// <returns>true：成功　false：失敗</returns>
        private bool EditData( List<dynamic> dataList, out List<dynamic> outPutData )
        {
            bool ret = false;

            //## CD名称取得
            string cdNo = FILENAME_DEF + DateTime.Now.ToString("yyyyMMddHHmmss");

            //## 出力ファイル名称編集 ##
            FileName = cdNo + ".csv";

            //編集データ初期化
            outPutData = new List<object>();
            
            //編集情報取得
            var freeDao = new FreeDao(connection);
            IList<dynamic> settingData = freeDao.SelectFree(1, queryParams["spItem"]);

            //出力対象者情報を最初から繰り返して読み込む
            int dataCnt = 0;
            foreach (var dataItem in dataList)
            {

                //予約番号退避
                int.TryParse( Util.ConvertToString(dataItem.RSVNO), out int rsvno);

                //受診日退避
                DateTime.TryParse(dataItem.CSLDATE, out DateTime csldate);

                //## 検査結果取得
                var result = GetResult(rsvno);

                //レコード情報
                Dictionary<string, object> rec = new Dictionary<string, object>();

                //汎用マスタの情報に合わせて編集処理
                foreach (var setting in settingData)
                {
                    //汎用マスタの設定取得
                    string workData = Util.ConvertToString(setting.FREEFIELD1);

                    //FREEFIELD1にデータタイプ、項目コード、サフィックスを半角ハイフン区切りで保持しているため、分割する
                    string[] workList = workData.Split('-');

                    string setDType = "";   //データタイプ
                    string setItemCode = "";   //項目コード
                    string setSuffix = "";   //サフィックス

                    switch (workList.Length)
                    {
                        case 3:
                            setDType = workList[0];
                            setItemCode = workList[1];
                            setSuffix = workList[2];
                            break;
                        case 2:
                            setDType = workList[0];
                            setItemCode = workList[1];
                            setSuffix = "";
                            break;
                        case 1:
                            setDType = workList[0];
                            setItemCode = "";
                            setSuffix = "";
                            break;
                        default:
                            break;
                    }

                    //設定情報を格納
                    bool sizeFlg = int.TryParse(Util.ConvertToString(setting.FREEFIELD5), out int setSize);
                    SettingItem settingItem = new SettingItem()
                        {
                        DType = setDType,           //データタイプ
                        ItemCode = setItemCode,     //項目コード
                        Suffix = setSuffix,         //サフィックス
                        Link = Util.ConvertToString(setting.FREEFIELD2),        //区分
                        ItemName = Util.ConvertToString(setting.FREEFIELD3),    //項目名
                        JudClasscd = Util.ConvertToString(setting.FREEFIELD4),  //判定分類コード
                        Size = setSize, //サイズ
                        FixedRsl = Util.ConvertToString(setting.FREEFIELD6),    //固定結果
                        Point = Util.ConvertToString(setting.FREEFIELD7),       //小数点数
                    };

                    //変換結果
                    string sResult = "";

                    //設定情報に従って結果編集
                    switch (setDType.Trim())
                    {
                        case "CDNO":    //## CD番号
                            sResult = cdNo;

                            break;

                        case "BAS":    //## 基本情報
                            IDictionary<string, object> itemDatas = dataList[dataCnt];
                            foreach (KeyValuePair<string, object> item in itemDatas)
                            {
                                //DBのフィールド名と値を取得
                                string dbFiledName = item.Key;  //フィールド名
                                string dbValue = Util.ConvertToString(item.Value);    //値

                                if ((dbFiledName == settingItem.ItemCode.Trim()) && (dbValue != ""))
                                {
                                    //## 文章の中に含まれている空白を削除
                                    sResult = CheckSpace(dbValue.Trim());
                                    break;
                                }
                            }

                            //## 受診者被保険者証記号、受診者被保険者証番号データの中に全角文字が含まれている場合は全角文字で表示
                            if ( (setItemCode.Trim() == "ISRSIGN")|| (setItemCode.Trim() == "ISRNO" ))
                            {
                                if (sResult.Trim().Length != WebHains.LenB(sResult.Trim()))
                                {
                                    sResult = Strings.StrConv(sResult, VbStrConv.Wide);
                                }
                            }
                            break;

                        case "FIX":  //固定情報
                            sResult = settingItem.FixedRsl.Trim();
                            break;

                        case "RSL":    //## 検査結果
                            if (settingItem.JudClasscd.Trim() != "")
                            {
                                if (SelectJudRsl(rsvno, settingItem.JudClasscd.Trim(), true) == "＊＊")
                                {
                                    if (settingItem.Link.Trim() == "S") //## 結果タイプが「文章タイプ」の場合、文章参照
                                    {
                                        sResult = "＊＊＊＊＊";
                                    }
                                    else
                                    {
                                        sResult = "********";
                                    }
                                }
                                else
                                {
                                    if (SelectJudRsl(rsvno, settingItem.JudClasscd.Trim(), true) == "－－")
                                    {
                                        if (settingItem.Link.Trim() == "S")   //## 結果タイプが「文章タイプ」の場合、文章参照
                                        {
                                            sResult = "検査せず";
                                        }
                                        else
                                        {
                                            sResult = "--------";
                                        }
                                    }
                                    else
                                    {
                                        sResult = GetRslString(settingItem, result, settingItem.Point.Trim());
                                    }
                                }
                            }
                            else
                            {
                                sResult = GetRslString(settingItem, result, settingItem.Point.Trim());
                            }

                            break;

                        case "ORSL":  //## 単一オプション検査結果
                            sResult = GetOptRslString(rsvno, settingItem, settingItem.Point.Trim());
                            break;

                        case "STC":    //## 所見格納（検査項目グループ）
                            if (SelectJudRsl(rsvno, settingItem.JudClasscd.Trim(), true) == "＊＊")
                            {
                                sResult = "＊＊＊＊＊";
                            }
                            else
                            {
                                if (SelectJudRsl(rsvno, settingItem.JudClasscd.Trim(), true) == "－－")
                                {
                                    sResult = "検査せず";
                                }
                                else
                                {
                                    sResult = GetReptStc(rsvno, settingItem.FixedRsl.Trim());
                                }
                            }
                            break;

                        case "ISTC":   //## 所見格納（依頼項目）
                            if (SelectJudRsl(rsvno, settingItem.JudClasscd.Trim(), true) == "＊＊")
                            {
                                sResult = "＊＊＊＊＊";
                            }
                            else
                            {
                                if (SelectJudRsl(rsvno, settingItem.JudClasscd.Trim(), true) == "－－")
                                {
                                    sResult = "検査せず";
                                }
                                else
                                {
                                    sResult = GetItemReptStc(rsvno, settingItem.ItemCode.Trim());
                                }
                            }
                            break;

                        case "EYE":    //## 眼底結果（その他所見）
                            sResult = GetReptStc(rsvno, settingItem.FixedRsl.Trim());
                            break;

                        case "JUD":    //## 判定結果
                            sResult = SelectJudRsl(rsvno, settingItem.JudClasscd.Trim(), true);
                            break;

                        case "RS1":    //## 定性(便潜血)
                            if (SelectJudRsl(rsvno, settingItem.JudClasscd.Trim(), true) == "＊＊")
                            {
                                sResult = "＊＊＊＊＊";
                            }
                            else
                            {
                                sResult = GetTeiseiStool(rsvno);
                            }
                            break;

                        case "FUC":    //## 婦人科クラス
                            if (SelectJudRsl(rsvno, settingItem.JudClasscd.Trim(), true) == "＊＊")
                            {
                                sResult = "＊＊＊＊＊";
                            }
                            else
                            {
                                if (SelectJudRsl(rsvno, settingItem.JudClasscd.Trim(), true) == "－－")
                                {
                                    sResult = "検査せず";
                                }
                                else
                                {
                                    sResult = GetHujinClass(rsvno);
                                }
                            }
                            break;

                        case "FUK":    //## 子宮頸部細胞診診断
                            if (SelectJudRsl(rsvno, settingItem.JudClasscd.Trim(), true) == "＊＊")
                            {
                                sResult = "＊＊＊＊＊";
                            }
                            else
                            {
                                if (SelectJudRsl(rsvno, settingItem.JudClasscd.Trim(), true) == "－－")
                                {
                                    sResult = "検査せず";
                                }
                                else
                                {
                                    sResult = GetReptStc_FUJIN(rsvno, settingItem.ItemCode.Trim(), FU_FCLASS_KEBU);
                                }
                            }
                            break;

                        case "FUN":    //## 婦人科診察内診診断
                            if (SelectJudRsl(rsvno, settingItem.JudClasscd.Trim(), true) == "＊＊")
                            {
                                sResult = "＊＊＊＊＊";
                            }
                            else
                            {
                                if (SelectJudRsl(rsvno, settingItem.JudClasscd.Trim(), true) == "－－")
                                {
                                    sResult = "検査せず";
                                }
                                else
                                {
                                    sResult = GetReptStc_FUJIN(rsvno, settingItem.ItemCode.Trim(), FU_NAISHIN);
                                }
                            }
                            break;

                        case "PLQ":    //## 頸動脈超音波プラーク情報
                            if (SelectJudRsl(rsvno, settingItem.JudClasscd.Trim(), true) == "＊＊")
                            {
                                sResult = "＊＊＊＊＊";
                            }
                            else
                            {
                                sResult = GetPlaqueStc(rsvno);
                            }
                            break;

                        case "UNIT":  //## 単位
                            sResult = GetItemUnit(settingItem.ItemCode.Trim(), settingItem.Suffix.Trim(), csldate);
                            break;

                        case "TCMT":  //## 総合コメント
                            sResult = GetTotalCmt(rsvno, 1);
                            break;

                        case "JCMT":  //## 生活指導コメント
                            sResult = GetTotalCmt(rsvno, 2);
                            break;

                        case "BLK":    //## 空欄
                            sResult = "";
                            break;
                    }

                    //サイズ調整（サイズ指定があり、数値）
                    if ( (!string.IsNullOrEmpty(setting.FREEFIELD5)) && (sizeFlg == true))
                    {
                        sResult = CheckSize(sResult, setSize);
                    }

                    //カラム名をキーにして結果追加
                    rec.Add(settingItem.ItemName, sResult.Trim());
                }

                //データ追加
                outPutData.Add(rec);

                dataCnt++;
            }

            ret = true;

            //戻り値設定
            return ret;

        }

        /// <summary>
        /// 検査結果取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>取得データ</returns>
        private dynamic GetResult(int rsvNo)
        {
            // SQLステートメント定義
             string sql = @"
                select
                    perrsl.itemcd itemcode
                    , perrsl.suffix suffix
                    , perrsl.itemname itemname
                    , perrsl.result result
                    , perrsl.resulttype resulttype
                    , perrsl.rslcmtname rslcmtname
                    , nvl(sentence.longstc, ' ') longstc
                    , nvl(sentence.reptstc, ' ') reptstc 
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
                            , grp_i
                            , item_c
                            , rslcmt 
                        where
                            rsl.rsvno = :rsvno 
                            and grp_i.grpcd = (select freefield1 from free where freecd = :grpcd) 
                            and rsl.result is not null 
                            and rsl.itemcd = grp_i.itemcd 
                            and rsl.suffix = grp_i.suffix 
                            and rsl.itemcd = item_c.itemcd 
                            and rsl.suffix = item_c.suffix 
                            and rsl.rslcmtcd1 = rslcmt.rslcmtcd(+)
                    ) perrsl
                    , sentence 
                where
                    perrsl.stcitemcd = sentence.itemcd(+) 
                    and perrsl.itemtype = sentence.itemtype(+) 
                    and perrsl.result = sentence.stccd(+) 
                order by
                    perrsl.itemcd
                    , perrsl.suffix

            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                grpcd = FREECD_GRP
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 指定対象受診者の判定結果を取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="convFlg">判定変換フラグ（今回歴はTrue、過去歴はFalse）</param>
        /// <returns>判定結果</returns>
        private string SelectJudRsl(int rsvNo, string judClassCd, bool convFlg)
        {

            //戻り値初期化
            string ret = "";

            // SQLステートメント定義
            string sql = @"
                    select
                        finalrsl.perid
                        , finalrsl.csldate
                        , finalrsl.rsvno
                        , judclass.judclasscd
                        , judclass.judclassname
                        , finalrsl.judcd
                        , jud.judrname 
                    from
                        jud
                        , judclass
                        , ( 
                            select
                                judclassview.csldate
                                , judclassview.rsvno
                                , judclassview.perid
                                , judclassview.judclasscd
                                , judrsl.judcd
                                , judrsl.upduser
                                , judrsl.updflg
                                , judrsl.judcmtcd 
                            from
                                ( 
                                    select
                                        finalconsult.csldate
                                        , finalconsult.rsvno
                                        , finalconsult.perid
                                        , finalconsult.cscd
                                        , course_jud.judclasscd 
                                    from
                                        ( 
                                            select
                                                csldate
                                                , rsvno
                                                , perid
                                                , cscd 
                                            from
                                                consult 
                                            where
                                                consult.rsvno = :rsvno 
                                                and consult.cancelflg = :cancelflg
                                        ) finalconsult
                                        , course_jud 
                                    where
                                        finalconsult.cscd = course_jud.cscd 
                                        and ( 
                                            course_jud.noreason = 1 
                                            or exists ( 
                                                select
                                                    rsl.rsvno 
                                                from
                                                    item_jud
                                                    , rsl 
                                                where
                                                    rsl.rsvno = finalconsult.rsvno 
                                                    and rsl.itemcd = item_jud.itemcd 
                                                    and rsl.stopflg is null 
                                                    and item_jud.judclasscd = course_jud.judclasscd
                                            ) 
                                            or ( 
                                                exists ( 
                                                    select
                                                        rsl.rsvno 
                                                    from
                                                        item_jud
                                                        , rsl 
                                                    where
                                                        rsl.rsvno = finalconsult.rsvno 
                                                        and rsl.itemcd = item_jud.itemcd 
                                                        and rsl.stopflg is null 
                                                        and item_jud.judclasscd in ( 
                                                            :syokujudclasscd
                                                            , :xsenjudclasscd
                                                            , :choujudclasscd
                                                        )
                                                ) 
                                                and course_jud.judclasscd = :nyujudclasscd
                                            )
                                        )
                                ) judclassview
                                , judrsl 
                            where
                                judclassview.rsvno = judrsl.rsvno(+) 
                                and judclassview.judclasscd = judrsl.judclasscd(+)
                        ) finalrsl 
                    where
                        finalrsl.judcd = jud.judcd(+) 
                        and finalrsl.judclasscd(+) = judclass.judclasscd 
                        and judclass.judclasscd = :judclasscd
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                judclasscd = judClassCd,
                syokujudclasscd = JUDCLASSCD_NYUSYOKU,
                xsenjudclasscd = JUDCLASSCD_NYUXSEN,
                choujudclasscd = JUDCLASSCD_NYUCHOU,
                nyujudclasscd = JUDCLASSCD_NYUBOU,

                cancelflg = ConsultCancel.Used
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            if (result != null)
            {
                //検査依頼有無
                bool hitFlg = false;
                if (result.RSVNO != null)
                {
                    //予約番号あり
                    hitFlg = true;
                }

                //判定結果
                string judRName = Util.ConvertToString(result.JUDRNAME).TrimEnd();

                // -- 「＊＊」の判定ロジック
                if (convFlg == true)
                {
                    //今回歴の場合　かつ　検査依頼が無い
                    if (hitFlg == false)
                    {
                        judRName = "＊＊";

                        //検査中止チェック
                        var RetB = SelectJudStoped(rsvNo, judClassCd);
                        if (RetB == true)
                        {
                            //検査中止になった場合
                            judRName = "－－";
                        }
                    }
                }

                ret = judRName;

            }

            // 戻り値設定
            return ret;
        }

        /// <summary>
        /// 判定分類の検査中止チェック
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <returns>true=検査中止、false=通常</returns>
        private bool SelectJudStoped(int rsvNo, string judClassCd)
        {
            bool ret = false;

            // SQLステートメント定義
            string sql = @"
                select distinct
                    decode(rsl.stopflg, null, 'OFF', 'ON') stoped 
                from
                    rsl
                    , ( 
                        select
                            item_c.itemcd
                            , item_c.suffix 
                        from
                            item_jud
                            , item_c 
                        where
                            item_jud.itemcd = item_c.itemcd 
                            and item_jud.judclasscd = :judclasscd
                    ) juditem 
                where
                    rsl.itemcd = juditem.itemcd 
                    and rsl.suffix = juditem.suffix 
                    and rsl.rsvno = :rsvno
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                judclasscd = judClassCd
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            if (result.Count == 1)
            {
                //返ってきた値がすべて検査中止だったら検査中止項目で判断
                if ( result[0].STOPED == "ON" )
                {
                    ret = true;
                }
            }
            else
            {
                //一種類以外（種類なしも含む）の結果が返ってきたら検査中止項目ではない
                ret = false;
            }

            // 戻り値設定
            return ret;
        }

        /// <summary>
        /// 個別オプション検査項目（血液検査など）の結果データ取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="settingInfo">汎用テーブル情報</param>
        /// <param name="point">小数点以下桁数</param>
        /// <returns>結果（検査項目自体が結果テーブルに存在しなかった場合、"********"を返す）</returns>
        private string GetOptRslString(int rsvNo, SettingItem settingInfo, string point)
        {
            string ret = "";

            // SQLステートメント定義
            string sql = @"
                select
                    nvl(sentence.longstc, nvl(final.result, ' ')) as result
                    , nvl(final.rslcmtname, ' ') as rslcmtname 
                from
                    ( 
                        select
                            item_c.stcitemcd as stcitemcd
                            , item_c.itemtype as itemtype
                            , rsl.result as result
                            , rslcmt.rslcmtname as rslcmtname 
                        from
                            rsl
                            , item_c
                            , rslcmt 
                        where
                            rsl.rsvno = :rsvno 
                            and rsl.itemcd = :itemcd 
                            and rsl.suffix = :suffix 
                            and rsl.itemcd = item_c.itemcd 
                            and rsl.suffix = item_c.suffix 
                            and rsl.rslcmtcd1 = rslcmt.rslcmtcd(+)
                    ) final
                    , sentence 
                where
                    final.stcitemcd = sentence.itemcd(+) 
                    and final.itemtype = sentence.itemtype(+) 
                    and final.result = sentence.stccd(+)
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                itemcd = settingInfo.ItemCode,
                suffix = settingInfo.Suffix
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            if ( result.Count > 0)
            {
                var rsl = result[0];

                string resultStr = Util.ConvertToString(rsl.RESULT);    //検査結果
                decimal.TryParse(resultStr, out decimal rslData);    //検査結果を数値に変換

                //小数点以下桁数によって分類
                if (string.IsNullOrEmpty(point.Trim()))
                {
                    //小数点以下桁数がない場合
                    //## 結果タイプが「文章タイプ」の場合、文章参照
                    if (settingInfo.Link == "S")
                    {
                        //## 文章の中に含まれている空白を削除
                        ret = CheckSpace(rsl.REPTSTC);
                    }
                    else
                    {
                        //## 結果タイプが「文章タイプ」以外の場合、結果テーブルの結果参照
                        ret = resultStr.Trim();
                    }
                }
                else
                {
                    //小数点以下桁数設定ありの場合、フォーマットする
                    string format = "";
                    int.TryParse(point, out int pointNum);

                    if (pointNum == 0)
                    {
                        //0の場合
                        format = "#";
                    }
                    else
                    {
                        //0以外の場合
                        format = "#0." + (new string('0', pointNum));
                    }

                    //数値フォーマット
                    ret = rslData.ToString(format);
                }

                //## 検査結果に符号(COMMENT1）が登録されている場合結合
                if (settingInfo.Link.Trim() == "C")
                {
                    ret += Util.ConvertToString(rsl.RSLCMTNAME).Trim();
                }
            }
            else
            {
                //０件の場合
                ret = "********";
            }

            // 戻り値設定
            return ret.Trim();
        }

        /// <summary>
        /// 指定グループ内検査項目における報告書印刷文章を取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="grpCd">グループコード</param>
        /// <returns></returns>
        private string GetReptStc(int rsvNo, string grpCd)
        {
            string ret = "";

            // SQLステートメント定義
            string sql = @"
                select
                    sentence.reptstc reptstc 
                from
                    rsl
                    , item_c
                    , grp_i
                    , sentence 
                where
                    rsl.rsvno = :rsvno 
                    and grp_i.grpcd = :grpcd 
                    and rsl.itemcd = grp_i.itemcd 
                    and rsl.suffix = grp_i.suffix 
                    and rsl.itemcd = item_c.itemcd 
                    and rsl.suffix = item_c.suffix 
                    and item_c.stcitemcd = sentence.itemcd 
                    and item_c.itemtype = sentence.itemtype 
                    and rsl.result = sentence.stccd 
                    and sentence.reptstc <> ' ' 
                order by
                    nvl(sentence.printorder, 99999)
                    , grp_i.seq
                    , rsl.itemcd
                    , rsl.suffix
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                grpcd = grpCd
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            if ( result.Count > 0)
            {
                //所見格納領域
                List<string> rslList = new List<string>();

                foreach (var rsl in result)
                {
                    bool findFlg = false;
                    string reptStc = Util.ConvertToString(rsl.REPTSTC);

                    reptStc = Strings.StrConv(CheckSpace(reptStc), VbStrConv.Wide);

                    //１）重複しない文章のみ抽出
                    foreach( string list in rslList)
                    {
                        //すでに登録されているか確認
                        if (list == reptStc)
                        {
                            findFlg = true;
                            break;
                        }
                    }

                    //２）報告書印刷文章が存在する結果のみ抽出
                    if (string.IsNullOrEmpty(reptStc.Trim()))
                    {
                        findFlg = true;
                    }

                    //条件に該当する場合のみ取得
                    if (findFlg == false)
                    {
                        rslList.Add(reptStc);
                    }
                }

                //## 「著変なし」と他の所見が混ざっている時、「著変なし」は印刷しないように排除
                //データが２件以上あり、著変なしがある場合
                if (rslList.Count > 1)
                {
                    rslList.RemoveAll(s => s.Contains("著変なし"));
                }

                if (rslList.Count > 0)
                {
                    //所見が１つでもある場合、連結して文字列生成
                    ret = string.Join("／", rslList.ToList());
                }

            }

            // 戻り値設定
            return ret;
        }

        /// <summary>
        /// 指定グループ内検査項目における報告書印刷文章を取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <returns>所見（報告書印刷文章）</returns>
        private string GetItemReptStc(int rsvNo, string itemCd)
        {
            string ret = "";

            // SQLステートメント定義
            string sql = @"
                    select
                        sentence.reptstc reptstc 
                    from
                        rsl
                        , item_c
                        , sentence 
                    where
                        rsl.rsvno = :rsvno 
                        and rsl.itemcd = :itemcd 
                        and rsl.itemcd = item_c.itemcd 
                        and rsl.suffix = item_c.suffix 
                        and item_c.stcitemcd = sentence.itemcd 
                        and item_c.itemtype = sentence.itemtype 
                        and rsl.result = sentence.stccd 
                        and sentence.reptstc is not null 
                    order by
                        nvl(sentence.printorder, 99999)
                        , rsl.itemcd
                        , rsl.suffix
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                itemcd = itemCd
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            if (result.Count > 0)
            {
                //所見格納領域
                List<string> rslList = new List<string>();

                foreach (var rsl in result)
                {
                    bool findFlg = false;
                    string reptStc = Util.ConvertToString(rsl.REPTSTC);

                    reptStc = Strings.StrConv(CheckSpace(reptStc), VbStrConv.Wide);

                    //１）重複しない文章のみ抽出
                    foreach (string list in rslList)
                    {
                        //すでに登録されているか確認
                        if (list == reptStc)
                        {
                            findFlg = true;
                            break;
                        }
                    }

                    //２）報告書印刷文章が存在する結果のみ抽出
                    if (string.IsNullOrEmpty(reptStc.Trim()))
                    {
                        findFlg = true;
                    }

                    //条件に該当する場合のみ取得
                    if (findFlg == false)
                    {
                        rslList.Add(reptStc);
                    }
                }

                //## 「著変なし」と他の所見が混ざっている時、「著変なし」は印刷しないように排除
                //データが２件以上あり、著変なしがある場合
                if (rslList.Count > 1)
                {
                    rslList.RemoveAll(s => s.Contains("著変なし"));
                }

                if (rslList.Count > 0)
                {
                    //所見が１つでもある場合、連結して文字列生成
                    ret = string.Join("／", rslList.ToList());
                }

            }

            // 戻り値設定
            return ret;
        }

        /// <summary>
        /// 便潜血結果取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>2回の便潜血結果で悪い結果を採用,1回の結果しかない場合はそのまま</returns>
        private string GetTeiseiStool(int rsvNo)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    lastview.rank
                    , lastview.reptstc 
                from
                    ( 
                        select
                            decode( 
                                sentence.reptstc
                                , '検査せず'
                                , 1
                                , '（－）'
                                , 2
                                , '（＋－）'
                                , 3
                                , '（＋）'
                                , 4
                                , '（２＋）'
                                , 5
                                , 0
                            ) as rank
                            , sentence.reptstc as reptstc 
                        from
                            rsl
                            , grp_i
                            , item_c
                            , sentence 
                        where
                            rsl.rsvno = :rsvno 
                            and grp_i.grpcd = :grpcd 
                            and grp_i.itemcd = rsl.itemcd 
                            and grp_i.suffix = rsl.suffix 
                            and rsl.stopflg is null 
                            and rsl.result is not null 
                            and rsl.itemcd = item_c.itemcd 
                            and rsl.suffix = item_c.suffix 
                            and item_c.stcitemcd = sentence.itemcd 
                            and item_c.itemtype = sentence.itemtype 
                            and rsl.result = sentence.stccd 
                            and sentence.reptstc is not null 
                        order by
                            1 desc
                    ) lastview 
                where
                    rownum = 1
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                grpcd = GRPCD_STOOL
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? "" : (Util.ConvertToString(result.REPTSTC).Trim());

        }

        /// <summary>
        /// 子宮頚部細胞診のクラス分類結果取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>結果テーブル(汎用テーブル)から子宮頚部細胞診のクラス分類結果を取得</returns>
        private string GetHujinClass(int rsvNo)
        {

            // SQLステートメント定義
            string sql = @"
                select
                    sentence.reptstc as reptstc 
                from
                    rsl
                    , grp_i
                    , item_c
                    , sentence 
                where
                    rsl.rsvno = :rsvno 
                    and grp_i.grpcd = :grpcd 
                    and rsl.itemcd = grp_i.itemcd 
                    and rsl.suffix = grp_i.suffix 
                    and rsl.result in ( 
                        select
                            freefield1 
                        from
                            free 
                        where
                            freecd like :freecd_hujin
                            and freeclasscd = :freeclasscd_hujin
                    ) 
                    and rsl.itemcd = item_c.itemcd 
                    and rsl.suffix = item_c.suffix 
                    and item_c.stcitemcd = sentence.itemcd 
                    and item_c.itemtype = sentence.itemtype 
                    and rsl.result = sentence.stccd 
                    and sentence.reptstc is not null
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                grpcd = GRPCD_GYNE,
                freecd_hujin = FREECD_HUJIN_CLASS,
                freeclasscd_hujin = FREECLASSCD_HUJIN_CLASS
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? "" : (Util.ConvertToString(result.REPTSTC).Trim());
        }

        /// <summary>
        /// 婦人科グループ内検査項目における報告書印刷文章を取得()
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="fClass">クラスコード</param>
        /// <returns>所見（報告書印刷文章）</returns>
        private string GetReptStc_FUJIN(int rsvNo, string itemCd, string fClass)
        {
            string ret = "";

            // SQLステートメント定義
            string sql = @"
                select
                    item_c.itemname as itemname
                    , sentence.reptstc as reptstc 
                from
                    rsl
                    , item_c
                    , sentence 
                where
                    rsl.rsvno = :rsvno 
                    and rsl.itemcd = :itemcd 
                    and rsl.itemcd = item_c.itemcd 
                    and rsl.suffix = item_c.suffix 
                    and item_c.itemcd = sentence.itemcd 
                    and item_c.itemtype = sentence.itemtype 
                    and rsl.result = sentence.stccd 
            ";

            if ( fClass == FU_NAISHIN)
            {
                sql += @"
                    and rsl.result not in ( 
                            select
                                freefield1 
                            from
                                free 
                            where
                                freeclasscd in (:freeclass1, :freeclass2, :freeclass3)
                        ) 
                ";
            }
            else if( (fClass == FU_FCLASS_KEBU) || (fClass == FU_FCLASS_CLASS))
            {
                sql += @"
                    and rsl.result in ( 
                            select
                                freefield1 
                            from
                                free 
                            where
                                freeclasscd = :fclass
                        ) 
                ";
            }
            sql += @"
                order by
                    nvl(sentence.printorder, 99999)
                    , rsl.itemcd
                    , rsl.suffix
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                itemcd = itemCd,
                fclass = fClass,

                freeclass1 = FU_FCLASS_KEBU,
                freeclass2 = FU_FCLASS_KEBU2,
                freeclass3 = FU_FCLASS_CLASS
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            if (result.Count > 0)
            {
                //所見格納領域
                List<string> rslList = new List<string>();

                foreach (var rsl in result)
                {
                    bool findFlg = false;
                    string reptStc = Util.ConvertToString(rsl.REPTSTC);

                    //１）重複しない文章のみ抽出
                    foreach (string list in rslList)
                    {
                        //すでに登録されているか確認
                        if (list == reptStc)
                        {
                            findFlg = true;
                            break;
                        }
                    }

                    //２）報告書印刷文章が存在する結果のみ抽出
                    //（### 表示したくないものについて（空白設定されている所見）は無かったものとする）
                    if (string.IsNullOrEmpty(reptStc.Trim()))
                    {
                        findFlg = true;
                    }

                    //条件に該当する場合のみ取得
                    if (findFlg == false)
                    {
                        rslList.Add(reptStc);
                    }
                }

                //## 「著変なし」と他の所見が混ざっている時、「著変なし」は印刷しないように排除
                //データが２件以上あり、著変なしがある場合
                if (rslList.Count > 1)
                {
                    rslList.RemoveAll(s => s.Contains("著変なし"));
                }

                if (rslList.Count > 0)
                {
                    //所見が１つでもある場合、連結して文字列生成
                    ret = string.Join("／", rslList.ToList());
                }

            }

            // 戻り値設定
            return ret;
        }

        /// <summary>
        /// 頸動脈超音波のプラーク情報取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>検査項目グループの中に一つでも「あり」があったら「あり」で戻す</returns>
        private string GetPlaqueStc(int rsvNo)
        {
            string ret = "";

            // SQLステートメント定義
            string sql = @"
                select
                    sentence.reptstc as reptstc 
                from
                    rsl
                    , item_c
                    , grp_i
                    , sentence 
                where
                    rsl.rsvno = :rsvno 
                    and grp_i.grpcd = :grpcd 
                    and rsl.itemcd = grp_i.itemcd 
                    and rsl.suffix = grp_i.suffix 
                    and rsl.itemcd = item_c.itemcd 
                    and rsl.suffix = item_c.suffix 
                    and item_c.stcitemcd = sentence.itemcd 
                    and item_c.itemtype = sentence.itemtype 
                    and rsl.result = sentence.stccd 
                    and sentence.reptstc <> ' ' 
                order by
                    nvl(sentence.printorder, 99999)
                    , grp_i.seq
                    , rsl.itemcd
                    , rsl.suffix
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                grpcd = GRPCD_PLAQUE
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            foreach (var rsl in result)
            {
                //## 「あり」の所見があった時点で終了
                string reptStc = Util.ConvertToString(rsl.REPTSTC);

                if (reptStc == "あり")
                {
                    ret = reptStc;
                    break;
                }

            }

            // 戻り値設定
            return ret;
        }

        /// <summary>
        /// 単位取得
        /// </summary>
        /// <param name="itemCd_p">検査項目コード</param>
        /// <param name="suffix_p">サフィックス</param>
        /// <param name="csldate_p">受診日</param>
        /// <returns>単位</returns>
        private string GetItemUnit(string itemCd_p, string suffix_p, DateTime csldate_p)
        {

            // SQLステートメント定義
            string sql = @"
                select
                    item_h.unit as unit 
                from
                    item_h 
                where
                    item_h.itemcd = :itemcd 
                    and item_h.suffix = :suffix 
                    and :csldate between item_h.strdate and item_h.enddate
            ";

            // パラメータセット
            var sqlParam = new
            {
                itemcd = itemCd_p,
                suffix = suffix_p,
                csldate = csldate_p
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? "" : (Util.ConvertToString(result.UNIT).Trim());
        }

        /// <summary>
        /// 総合コメント、生活指導コメント取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="dispMode">表示分類</param>
        /// <returns>所見（報告書印刷文章）</returns>
        private string GetTotalCmt(int rsvNo, int dispMode)
        {
            string ret = "";

            // SQLステートメント定義
            string sql = @"
                select
                    totaljudcmt.judcmtcd as judcmtcd
                    , judcmtstc.judcmtstc as judcmtstc 
                from
                    totaljudcmt
                    , judcmtstc 
                where
                    totaljudcmt.rsvno = :rsvno 
                    and totaljudcmt.dispmode = :dispmode 
                    and totaljudcmt.judcmtcd = judcmtstc.judcmtcd
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                dispmode = dispMode
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            if (result.Count > 0)
            {
                //所見格納領域
                List<string> rslList = new List<string>();

                foreach (var rsl in result)
                {
                    string judCmtStc = Util.ConvertToString(rsl.JUDCMTSTC);

                    rslList.Add(judCmtStc);
                }

                if (rslList.Count > 0)
                {
                    //所見が１つでもある場合、連結して文字列生成
                    ret = string.Join("／", rslList.ToList());
                }

            }

            // 戻り値設定
            return ret;
        }

        /// <summary>
        /// 結果変換
        /// </summary>
        /// <param name="settingInfo">汎用テーブル情報</param>
        /// <param name="rslDatas">検査結果情報</param>
        /// <param name="point">小数点以下桁数</param>
        /// <returns>変換後データ</returns>
        private string GetRslString(SettingItem settingInfo, dynamic rslDatas, string point)
        {
            string ret = "";

            //検査結果と汎用テーブル情報をもとに、結果を変換して返す
            foreach ( var rsl in rslDatas)
            {
                //検査結果レコードと汎用テーブルの検査項目が一致した場合
                if ( (rsl.ITEMCODE == settingInfo.ItemCode) && (rsl.SUFFIX == settingInfo.Suffix))
                {
                    string resultStr = Util.ConvertToString(rsl.RESULT);    //検査結果
                    decimal.TryParse(resultStr, out decimal result);    //検査結果を数値に変換

                    //小数点以下桁数によって分類
                    if ( string.IsNullOrEmpty(point.Trim()) )
                    {
                        //小数点以下桁数がない場合
                        //## 結果タイプが「文章タイプ」の場合、文章参照
                        if (settingInfo.Link == "S")
                        {
                            //## 文章の中に含まれている空白を削除
                            ret = CheckSpace(rsl.REPTSTC);
                        }
                        else
                        {
                            //## 結果タイプが「文章タイプ」以外の場合、結果テーブルの結果参照
                            ret = resultStr.Trim();
                        }
                    }
                    else
                    {
                        //小数点以下桁数設定ありの場合、フォーマットする
                        string format = "";
                        int.TryParse(point, out int pointNum);

                        if (pointNum == 0)
                        {
                            //0の場合
                            format = "#";
                        }
                        else
                        {
                            //0以外の場合
                            format = "#0." + (new string('0', pointNum));
                        }

                        //数値フォーマット
                        ret = result.ToString(format);

                    }

                    //## 検査結果に符号(COMMENT1）が登録されている場合結合
                    if (settingInfo.Link.Trim() == "C")
                    {
                        ret +=  Util.ConvertToString(rsl.RSLCMTNAME).Trim();
                    }

                }

            }

            // 戻り値設定
            return ret.Trim();
        }

        /// <summary>
        /// 空白削除
        /// </summary>
        /// <param name="value">文字列</param>
        /// <returns>削除後文字列</returns>
        private string CheckSpace(string value)
        {
            string ret = Util.ConvertToString(value);

            //空白削除
            ret = ret.Replace(" ", "").Replace("　", "");

            return ret;
        }

        /// <summary>
        /// 文字列のサイズ（Byte）計算
        /// </summary>
        /// <param name="value">文字列</param>
        /// <param name="size">サイズ</param>
        /// <returns>編集後文字列</returns>
        private string CheckSize(string value, int size)
        {
            string ret = "";

            if (string.IsNullOrEmpty(value))
            {
                return "";
            }

            for (int i = 1; i <= value.Length; i++)
            {

                int nextByte = WebHains.LenB(value.Trim().Substring(i - 1, 1));

                if ((WebHains.LenB(ret) + nextByte) <= size)
                {
                    ret += value.Trim().Substring(i - 1, 1);
                }
                else
                {
                    break;
                }

            }

            return ret;
        }

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージのリスト</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            //入力チェック
            if (!DateTime.TryParse(queryParams["startdate"], out DateTime wkDateStr))
            {
                messages.Add("開始日付が正しくありません。");
            }

            if (!string.IsNullOrEmpty(queryParams["enddate"]))
            {
                if (!DateTime.TryParse(queryParams["enddate"], out DateTime wkDateEnd))
                {
                    messages.Add("終了日付が正しくありません。");
                }
            }

            //団体指定チェック
            bool findFlg = false;
            for (int i = 1; i <= MAX_COUNT_ORG; i++)
            {
                string para_name1 = "orgcd1" + i.ToString();
                string para_name2 = "orgcd2" + i.ToString();

                //団体コードの入力確認
                if ((!string.IsNullOrEmpty(queryParams[para_name1])) || (!string.IsNullOrEmpty(queryParams[para_name2])))
                {
                    //団体指定がある場合、処理を抜ける
                    findFlg = true;
                    break;
                }
            }

            if (findFlg == false && (string.IsNullOrEmpty(queryParams["orggrpcd"])))
            {
                //団体コード、および団体グループ指定がない場合、エラー
                messages.Add("団体を選択してください。");
            }

            //請求対象団体チェック
            if ( (queryParams["orgBill"] == "1") && ( (string.IsNullOrEmpty(queryParams["billOrgcd1"])) || (string.IsNullOrEmpty(queryParams["billOrgcd2"])) ) )
            {
                //団体請求対象者のみで、請求対象団体の指定がない場合、エラー
                messages.Add("請求対象団体を選んでください。");
            }

            //出力項目区分チェック
            if (string.IsNullOrEmpty(queryParams["spItem"]))
            {
                //出力項目区分の指定がない場合はエラー
                messages.Add("出力項目区分を選んでください。");
            }
            else
            {
                //汎用マスタ設定がない場合はエラー
                string freecd = queryParams["spItem"];

                var freeDao = new FreeDao(connection);
                IList<dynamic> settingData = freeDao.SelectFree(1, freecd);

                if ( settingData.Count == 0)
                {
                    messages.Add("指定された出力項目区分の設定がありません。");
                }
            }

            return messages;
        }
    }
}
