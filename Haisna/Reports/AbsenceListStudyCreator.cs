using Dapper;
using Hainsi.ReportCore;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualBasic;

namespace Hainsi.Reports
{
    //[LoggingParam]
    public class AbsenceListStudyCreator : CsvCreator
    {

        /// <summary>
        /// 対象コース
        /// </summary>
        private const string CSCD1 = "100";
        private const string CSCD2 = "105";
        private const string CSCD3 = "110";

        /// <summary>
        /// 汎用コード
        /// </summary>
        private const string FREECD_GRP = "A-STUDYGRP"; //検査結果取得用　グループコード設定
        private const string FREECD_HUJIN_CLASS = "GYNECLASS%";     //婦人科クラス

        /// <summary>
        /// 汎用分類コード
        /// </summary>
        private const string FREECLASSCD = "ABS-STUDY"; //検査結果取得用
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
        /// 健診基本情報データを読み込み
        /// </summary>
        /// <returns>健診基本情報データ</returns>
        protected override List<dynamic> GetData()
        {

            string sql =
                  @"
                    select
                        lastview.csldate as csldate
                        , lastview.dayid as dayid
                        , lastview.perid as perid
                        , lastview.rsvno as rsvno
                        , lastview.gender as gender
                        , lastview.birth as birth
                        , lastview.isrsign as isrsign
                        , lastview.isrorgno as isrorgno
                        , lastview.isrno as isrno
                        , lastview.csldivname as csldivname
                        , lastview.kname as kname
                        , lastview.name as name
                        , lastview.romename as romename
                        , lastview.csname as csname
                        , lastview.orgname as orgname
                        , lastview.rsvgrpname as rsvgrpname
                        , to_char(consult.csldate, 'YYYY/MM/DD') as before_csldate
                        , receipt.dayid as before_dayid
                        , consult.rsvno as before_rsvno 
                    from
                        ( 
                            select
                                to_char(consult.csldate, 'YYYY/MM/DD') as csldate
                                , receipt.dayid as dayid
                                , consult.rsvno as rsvno
                                , person.perid as perid
                                , decode(person.gender, 1, '男', 2, '女', '') as gender
                                , to_char(person.birth, 'YYYY/MM/DD') as birth
                                , consult.isrsign as isrsign
                                , nvl(consult.isrmanno, org.spare1) as isrorgno
                                , consult.isrno as isrno
                                , consult.csldivcd as csldivcd
                                , free.freefield1 as csldivname
                                , person.lastkname || '　' || person.firstkname as kname
                                , person.lastname || '　' || person.firstname as name
                                , person.romename as romename
                                , consult.cscd as cscd
                                , course_p.csname as csname
                                , consult.orgcd1 as orgcd1
                                , consult.orgcd2 as orgcd2
                                , org.orgname as orgname
                                , consult.rsvgrpcd as rsvgrpcd
                                , rsvgrp.rsvgrpname as rsvgrpname
                                , ( 
                                    select
                                        max(cst.csldate) 
                                    from
                                        consult cst
                                        , receipt rcp 
                                    where
                                        cst.perid = consult.perid 
                                        and cst.csldate < consult.csldate 
                                        and cst.cancelflg = :cancelflg 
                                        and cst.cscd in (:cscd1, :cscd2, :cscd3) 
                                        and cst.rsvno = rcp.rsvno 
                                        and rcp.comedate is not null
                                ) before_csldate 
                            from
                                consult
                                , person
                                , receipt
                                , free
                                , course_p
                                , org
                                , rsvgrp 
                            where
                                consult.csldate between :frdate and :todate 
                                and consult.cancelflg = :cancelflg 
                                and consult.cscd in (:cscd1, :cscd2, :cscd3) 
                                and consult.csldivcd = free.freecd 
                                and consult.perid = person.perid 
                                and consult.rsvno = receipt.rsvno(+) 
                                and consult.cscd = course_p.cscd 
                                and consult.rsvgrpcd = rsvgrp.rsvgrpcd 
                                and consult.orgcd1 = org.orgcd1 
                                and consult.orgcd2 = org.orgcd2
                        ) lastview
                        , consult
                        , receipt 
                    where
                        consult.csldate = lastview.before_csldate 
                        and consult.perid = lastview.perid 
                        and consult.cancelflg = :cancelflg 
                        and consult.cscd in (:cscd1, :cscd2, :cscd3) 
                        and consult.rsvno = receipt.rsvno 
                        and receipt.comedate is not null 
                    order by
                        lastview.csldate
                        , lastview.dayid
                        , lastview.rsvgrpcd
                        , lastview.orgcd1
                        , lastview.orgcd2
                        , lastview.perid
                    ";

            // 出力ファイル名定義
            FileName = "STUDY" + DateTime.Parse(queryParams["startdate"]).ToString("yyyyMMdd") + ".csv";

            var sqlParam = new
            {
                frdate = queryParams["startdate"],
                todate = (string.IsNullOrEmpty(Util.ConvertToString(queryParams["enddate"]))) ? queryParams["startdate"] : queryParams["enddate"],
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

            // 件数0なら処理しない
            if (data.Count == 0)
            {
                return returnData;
            }

            // 汎用マスタの読み込み
            var freeDao = new FreeDao(connection);

            IList<dynamic> tagData = freeDao.SelectFreeByClassCd(0, FREECLASSCD);

            // 出力データの編集
            foreach (IDictionary<string, object> rec in data)
            {

                //予約番号退避
                dynamic result = null;
                if (int.TryParse(Util.ConvertToString(rec["BEFORE_RSVNO"]), out int rsvno))
                {
                    // 検査結果取得
                    result = GetResult(rsvno);
                }
                

                //受診日退避
                DateTime.TryParse(Util.ConvertToString(rec["CSLDATE"]), out DateTime csldate);

                var mainDic = new Dictionary<string, object>();

                foreach (var tagRec in tagData)
                {

                    string tmpData = "";

                    //サイズ調整の設定
                    bool sizeFlg = int.TryParse(Util.ConvertToString(tagRec.FREEFIELD6), out int setSize);

                    switch (tagRec.FREEFIELD1)
                    {
                        case "BAS":
                            // 抽出結果から出力
                            foreach (dynamic field in rec.Keys)
                            {
                                if (field == tagRec.FREEFIELD2)
                                {
                                    // SQLで取得したフィールド名と汎用テーブルが一致
                                    tmpData = Util.ConvertToString(rec[field]).Trim();

                                    // 受診者被保険者証記号、受診者被保険者証番号データの中に全角文字が含まれている場合は全角文字で表示
                                    if ((field == "ISRSIGN") ||( field == "ISRNO"))
                                    {
                                        if (tmpData.Length != WebHains.LenB(tmpData))
                                        {
                                            tmpData = Strings.StrConv(tmpData, VbStrConv.Wide);
                                        }
                                    }
                                    break;
                                }
                            }
                            break;

                        case "FIX":
                            // 固定値
                            tmpData = Util.ConvertToString(tagRec.FREEFIELD7).Trim();
                            break;


                        case "RSL":
                            // 検査結果
                            if (int.TryParse(Util.ConvertToString(rec["BEFORE_RSVNO"]), out rsvno))
                            {
                                if (Util.ConvertToString(tagRec.FREEFIELD5).Trim() != "")
                                {
                                    if (SelectJudRsl(rsvno, Util.ConvertToString(tagRec.FREEFIELD5).Trim(), true) == "＊＊")
                                    {
                                        if (Util.ConvertToString(tagRec.FREEFIELD6).Trim() == "S") // 結果タイプが「文章タイプ」の場合、文章参照
                                        {
                                            tmpData = "＊＊＊＊＊";
                                        }
                                        else
                                        {
                                            tmpData = "********";
                                        }
                                    }
                                    else
                                    {
                                        if (SelectJudRsl(rsvno, Util.ConvertToString(tagRec.FREEFIELD5).Trim(), true) == "－－")
                                        {
                                            if (Util.ConvertToString(tagRec.FREEFIELD6).Trim() == "S")   // 結果タイプが「文章タイプ」の場合、文章参照
                                            {
                                                tmpData = "検査せず";
                                            }
                                            else
                                            {
                                                tmpData = "--------";
                                            }
                                        }
                                        else
                                        {
                                            tmpData = GetRslString(tagRec, result, Util.ConvertToString(tagRec.FREEFIELD7).Trim());
                                        }
                                    }
                                }
                                else
                                {
                                    tmpData = GetRslString(tagRec, result, Util.ConvertToString(tagRec.FREEFIELD7).Trim());
                                }
                            }
                            break;

                        case "ORSL":
                            // 単一オプション検査結果
                            if (int.TryParse(Util.ConvertToString(rec["BEFORE_RSVNO"]), out rsvno))
                            {
                                tmpData = GetOptRslString(rsvno, tagRec, Util.ConvertToString(tagRec.FREEFIELD7).Trim());
                            }
                            break;

                        case "STC":
                            // 所見格納（検査項目グループ）
                            if (int.TryParse(Util.ConvertToString(rec["BEFORE_RSVNO"]), out rsvno))
                            {
                                if (SelectJudRsl(rsvno, Util.ConvertToString(tagRec.FREEFIELD5).Trim(), true) == "＊＊")
                                {
                                    tmpData = "＊＊＊＊＊";
                                }
                                else
                                {
                                    if (SelectJudRsl(rsvno, Util.ConvertToString(tagRec.FREEFIELD5).Trim(), true) == "－－")
                                    {
                                        tmpData = "検査せず";
                                    }
                                    else
                                    {
                                        tmpData = GetReptStc(rsvno, Util.ConvertToString(tagRec.FREEFIELD7).Trim());
                                    }
                                }
                            }
                            break;

                        case "ISTC":
                            // 所見格納（依頼項目）
                            if (int.TryParse(Util.ConvertToString(rec["BEFORE_RSVNO"]), out rsvno))
                            {
                                if (SelectJudRsl(rsvno, Util.ConvertToString(tagRec.FREEFIELD5).Trim(), true) == "＊＊")
                                {
                                    tmpData = "＊＊＊＊＊";
                                }
                                else
                                {
                                    if (SelectJudRsl(rsvno, Util.ConvertToString(tagRec.FREEFIELD5).Trim(), true) == "－－")
                                    {
                                        tmpData = "検査せず";
                                    }
                                    else
                                    {
                                        tmpData = GetItemReptStc(rsvno, Util.ConvertToString(tagRec.FREEFIELD2).Trim());
                                    }
                                }
                            }
                            break;

                        case "EYE":
                            // 眼底結果（その他所見）
                            if (int.TryParse(Util.ConvertToString(rec["BEFORE_RSVNO"]), out rsvno))
                            {
                                tmpData = GetReptStc(rsvno, Util.ConvertToString(tagRec.FREEFIELD7).Trim());
                            }
                            break;

                        case "JUD":
                            // 判定結果
                            if (int.TryParse(Util.ConvertToString(rec["BEFORE_RSVNO"]), out rsvno))
                            {
                                tmpData = SelectJudRsl(rsvno, Util.ConvertToString(tagRec.FREEFIELD5).Trim(), true);
                            }
                            break;

                        case "RS1":
                            // 定性(便潜血)
                            if (int.TryParse(Util.ConvertToString(rec["BEFORE_RSVNO"]), out rsvno))
                            {
                                if (SelectJudRsl(rsvno, Util.ConvertToString(tagRec.FREEFIELD5).Trim(), true) == "＊＊")
                                {
                                    tmpData = "＊＊＊＊＊";
                                }
                                else
                                {
                                    tmpData = GetTeiseiStool(rsvno);
                                }
                            }
                            break;

                        case "FUC":    //## 婦人科クラス
                            if (int.TryParse(Util.ConvertToString(rec["BEFORE_RSVNO"]), out rsvno))
                            {
                                if (SelectJudRsl(rsvno, Util.ConvertToString(tagRec.FREEFIELD5).Trim(), true) == "＊＊")
                                {
                                    tmpData = "＊＊＊＊＊";
                                }
                                else
                                {
                                    if (SelectJudRsl(rsvno, Util.ConvertToString(tagRec.FREEFIELD5).Trim(), true) == "－－")
                                    {
                                        tmpData = "検査せず";
                                    }
                                    else
                                    {
                                        tmpData = GetHujinClass(rsvno);
                                    }
                                }
                            }
                            break;

                        case "FUK":
                            // 子宮頸部細胞診診断
                            if (int.TryParse(Util.ConvertToString(rec["BEFORE_RSVNO"]), out rsvno))
                            {
                                if (SelectJudRsl(rsvno, Util.ConvertToString(tagRec.FREEFIELD5).Trim(), true) == "＊＊")
                                {
                                    tmpData = "＊＊＊＊＊";
                                }
                                else
                                {
                                    if (SelectJudRsl(rsvno, Util.ConvertToString(tagRec.FREEFIELD5).Trim(), true) == "－－")
                                    {
                                        tmpData = "検査せず";
                                    }
                                    else
                                    {
                                        tmpData = GetReptStc_FUJIN(rsvno, Util.ConvertToString(tagRec.FREEFIELD2).Trim(), FU_FCLASS_KEBU);
                                    }
                                }
                            }
                            break;

                        case "FUN":
                            // 婦人科診察内診診断
                            if (int.TryParse(Util.ConvertToString(rec["BEFORE_RSVNO"]), out rsvno))
                            {
                                if (SelectJudRsl(rsvno, Util.ConvertToString(tagRec.FREEFIELD5).Trim(), true) == "＊＊")
                                {
                                    tmpData = "＊＊＊＊＊";
                                }
                                else
                                {
                                    if (SelectJudRsl(rsvno, Util.ConvertToString(tagRec.FREEFIELD5).Trim(), true) == "－－")
                                    {
                                        tmpData = "検査せず";
                                    }
                                    else
                                    {
                                        tmpData = GetReptStc_FUJIN(rsvno, Util.ConvertToString(tagRec.FREEFIELD2).Trim(), FU_NAISHIN);
                                    }
                                }
                            }
                            break;

                        case "PLQ":
                            // 頸動脈超音波プラーク情報
                            if (int.TryParse(Util.ConvertToString(rec["BEFORE_RSVNO"]), out rsvno))
                            {
                                if (SelectJudRsl(rsvno, Util.ConvertToString(tagRec.FREEFIELD5).Trim(), true) == "＊＊")
                                {
                                    tmpData = "＊＊＊＊＊";
                                }
                                else
                                {
                                    tmpData = GetPlaqueStc(rsvno);
                                }
                            }
                            break;

                        case "UNIT":
                            // 単位
                            if (int.TryParse(Util.ConvertToString(rec["BEFORE_RSVNO"]), out rsvno))
                            {
                                tmpData = GetItemUnit(Util.ConvertToString(tagRec.FREEFIELD2).Trim(), Util.ConvertToString(tagRec.FREEFIELD3).Trim(), csldate);
                            }
                            break;

                        case "TCMT":  
                            // 総合コメント
                            if (int.TryParse(Util.ConvertToString(rec["BEFORE_RSVNO"]), out rsvno))
                            {
                                tmpData = GetTotalCmt(rsvno, 1);
                            }
                            break;

                        case "JCMT":  
                            // 生活指導コメント
                            if (int.TryParse(Util.ConvertToString(rec["BEFORE_RSVNO"]), out rsvno))
                            {
                                tmpData = GetTotalCmt(rsvno, 2);
                            }
                            break;

                        case "PRSL":  
                            // 身体情報 
                            if (int.TryParse(Util.ConvertToString(rec["BEFORE_RSVNO"]), out rsvno))
                            {
                                tmpData = GetPerResult(Util.ConvertToString(rec["PERID"]), Util.ConvertToString(tagRec.FREEFIELD2).Trim(), Util.ConvertToString(tagRec.FREEFIELD3).Trim());
                            }
                            break;

                        case "FOL":
                            // フォローアップ情報 
                            if (int.TryParse(Util.ConvertToString(rec["BEFORE_RSVNO"]), out rsvno))
                            {
                                tmpData = GetFollowInfo(rsvno);
                            }
                            break;

                        case "NOTE":
                            // チャート情報 
                            if (int.TryParse(Util.ConvertToString(rec["BEFORE_RSVNO"]), out rsvno))
                            {
                                tmpData = GetCslNote(rsvno, Util.ConvertToString(tagRec.FREEFIELD5).Trim());
                            }
                            break;

                        case "BLK":    
                            // 空欄
                            tmpData = "";
                            break;
                    }

                    //サイズ調整（サイズ指定があり、数値）
                    if ((!string.IsNullOrEmpty(tagRec.FREEFIELD6)) && (sizeFlg == true))
                    {
                        tmpData = CheckSize(tmpData, setSize);
                    }

                    mainDic.Add(Util.ConvertToString(tagRec.FREEFIELD4), tmpData);
                
            }

                returnData.Add(mainDic);

            }

            return returnData;
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
                        , sentence.longstc longstc
                        , sentence.reptstc reptstc 
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
                                                    and consult.cancelflg = 0
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
                if (result[0].STOPED == "ON")
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
        private string GetOptRslString(int rsvNo, dynamic settingInfo, string point)
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
                itemcd = settingInfo.FREEFIELD2.Trim(),
                suffix = settingInfo.FREEFIELD3.Trim()
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            if (result.Count > 0)
            {
                var rsl = result[0];

                string resultStr = Util.ConvertToString(rsl.RESULT);    //検査結果
                decimal.TryParse(resultStr, out decimal rslData);    //検査結果を数値に変換

                //小数点以下桁数によって分類
                if (string.IsNullOrEmpty(point.Trim()))
                {
                    //小数点以下桁数がない場合
                    //## 結果タイプが「文章タイプ」の場合、文章参照
                    if (settingInfo.FREEFIELD6.Trim() == "S")
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
                if (settingInfo.FREEFIELD6.Trim() == "C")
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

            if (fClass == FU_NAISHIN)
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
            else if ((fClass == FU_FCLASS_KEBU) || (fClass == FU_FCLASS_CLASS))
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
        private string GetRslString(dynamic settingInfo, dynamic rslDatas, string point)
        {
            string ret = "";

            //検査結果と汎用テーブル情報をもとに、結果を変換して返す
            foreach (var rsl in rslDatas)
            {
                //検査結果レコードと汎用テーブルの検査項目が一致した場合
                if ((rsl.ITEMCODE == settingInfo.FREEFIELD2.Trim()) && (rsl.SUFFIX == settingInfo.FREEFIELD3.Trim()))
                {
                    string resultStr = Util.ConvertToString(rsl.RESULT);    //検査結果
                    decimal.TryParse(resultStr, out decimal result);    //検査結果を数値に変換

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
                        ret = result.ToString(format);

                    }

                    //## 検査結果に符号(COMMENT1）が登録されている場合結合
                    if (settingInfo.FREEFIELD6.Trim() == "C")
                    {
                        ret += Util.ConvertToString(rsl.RSLCMTNAME).Trim();
                    }

                }

            }

            // 戻り値設定
            return ret.Trim();
        }

        /// <summary>
        /// 身体情報取得
        /// </summary>
        /// <param name="perID_p">患者ID</param>
        /// <param name="itemCd_p">検査項目コード</param>
        /// <param name="suffix_p">サフィックス</param>
        /// <returns>結果値</returns>
        private string GetPerResult(string perId_p,string itemCd_p, string suffix_p)
        {

            // SQLステートメント定義
            string sql = @"
                        select
                            nvl(sentence.longstc, '') as longstc 
                        from
                            perresult
                            , item_c
                            , sentence 
                        where
                            perresult.perid = :perid 
                            and perresult.itemcd = :itemcd 
                            and perresult.suffix = :suffix 
                            and perresult.itemcd = item_c.itemcd 
                            and perresult.suffix = item_c.suffix 
                            and item_c.stcitemcd = sentence.itemcd 
                            and item_c.itemtype = sentence.itemtype 
                            and perresult.result = sentence.stccd
            ";

            // パラメータセット
            var sqlParam = new
            {
                perid = perId_p,
                itemcd = itemCd_p,
                suffix = suffix_p
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? "" : (Util.ConvertToString(result.LONGSTC).Trim());
        }

        /// <summary>
        /// フォローアップ情報取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>フォローアップ情報</returns>
        private string GetFollowInfo(int rsvNo)
        {
            string ret = "";

            // SQLステートメント定義
            string sql = @"
                        select
                            judclass.judclassname as judclassname
                            , decode( 
                                follow_info.secequipdiv
                                , 0
                                , '二次検査場所未定'
                                , 1
                                , '当センター'
                                , 2
                                , '本院'
                                , 3
                                , '他院'
                                , ''
                            ) as equipdiv
                            , decode(follow_info.reqconfirmdate, null, '未承認', '承認済') as reqconfirm 
                        from
                            follow_info
                            , judclass 
                        where
                            follow_info.rsvno = :rsvno 
                            and follow_info.secequipdiv < 9 
                            and follow_info.judclasscd = judclass.judclasscd
            ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            bool isFirst = true;
            foreach (var rsl in result)
            {

                if (isFirst)
                {
                    ret += rsl.JUDCLASSNAME.Trim() + "・" + rsl.EQUIPDIV.Trim() + "・" + rsl.REQCONFIRM.Trim();
                    isFirst = false;
                }
                else
                {
                    ret += "／" + rsl.JUDCLASSNAME.Trim() + "・" + rsl.EQUIPDIV.Trim() + "・" + rsl.REQCONFIRM.Trim();
                }
            }

            // 戻り値設定
            return ret;
        }

        /// <summary>
        /// 受診時コメント（チャート情報）取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="noteDivCd">受診情報ノート分類コード</param>
        /// <returns>フォローアップ情報</returns>
        private string GetCslNote(int rsvNo,string noteDivCd)
        {
            string ret = "";

            // SQLステートメント定義
            string sql = @"
                            select
                                cslpubnote.pubnote as pubnote 
                            from
                                cslpubnote 
                            where
                                cslpubnote.rsvno = :rsvno 
                                and cslpubnote.delflg is null 
            ";

            if (!string.IsNullOrEmpty(noteDivCd))
            {
                sql += @"
                        and cslpubnote.pubnotedivcd = :pubnotedivcd
                       ";
            }

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                pubnotedivcd = noteDivCd
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            bool isFirst = true;
            foreach (var rsl in result)
            {

                if (isFirst)
                {
                    ret += rsl.PUBNOTE.Trim();
                    isFirst = false;
                }
                else
                {
                    ret += "／" + rsl.PUBNOTE.Trim();
                }
            }

            // 戻り値設定
            return ret;
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

            if (! DateTime.TryParse(queryParams["startdate"], out DateTime tmpDate))
            {
                messages.Add("開始受診日の入力形式が正しくありません。");
            }

            return messages;
        }
    }
}
