using Dapper;
using Hainsi.Common;
using Hainsi.ReportCore;
using System;
using System.Collections.Generic;
using System.Linq;
using Hainsi.Entity;

namespace Hainsi.Reports
{
    //[LoggingParam]
    public class AbsenceCompanyCreator : CsvCreator
    {

        /// <summary>
        /// ファイル名
        /// </summary>
        private const string FILENAME_DEF = "CONTRACT";

        /// <summary>
        /// 汎用コード
        /// </summary>
        private const string FREECD_SETTING = "A-COMPANY";     //設定情報
        
        /// <summary>
        /// 団体別契約セット情報を読み込み
        /// </summary>
        /// <returns>団体別契約セット情報</returns>
        protected override List<dynamic> GetData()
        {
            string sql =
                  @"
                    select
                        lastview.ctrptcd as ctrptcd
                        , lastview.setclasscd as setclasscd
                        , lastview.optcd as optcd
                        , lastview.optbranchno as optbranchno
                        , lastview.optname as optname
                        , lastview.addcondition as addcondition
                        , lastview.csldivname as csldivname
                        , lastview.gender as gender
                        , lastview.exceptlimit as exceptlimit
                        , lastview.perpricename as perpricename
                        , decode( 
                            lastview.perpricename
                            , ''
                            , lastview.optname
                            , lastview.perpricename
                        ) as perpricename2
                        , lastview.perprice as perprice
                        , lastview.pertax as pertax
                        , lastview.orgpricename as orgpricename
                        , decode( 
                            lastview.orgpricename
                            , ''
                            , lastview.optname
                            , lastview.orgpricename
                        ) as orgpricename2
                        , lastview.orgprice as orgprice
                        , lastview.orgtax as orgtax
                        , lastview.org2pricename as org2pricename
                        , decode( 
                            lastview.org2pricename
                            , ''
                            , lastview.optname
                            , lastview.org2pricename
                        ) as org2pricename2
                        , lastview.org2price as org2price
                        , lastview.org2tax as org2tax
                        , lastview.org3pricename as org3pricename
                        , decode( 
                            lastview.org3pricename
                            , ''
                            , lastview.optname
                            , lastview.org3pricename
                        ) as org3pricename2
                        , lastview.org3price as org3price
                        , lastview.org3tax as org3tax 
                    from
                        ( 
                            select distinct
                                ctrpt_opt.ctrptcd as ctrptcd
                                , ctrpt_opt.setclasscd as setclasscd
                                , ctrpt_opt.optcd as optcd
                                , ctrpt_opt.optbranchno as optbranchno
                                , ctrpt_opt.optname as optname
                                , decode(ctrpt_optgrp.addcondition, 1, '任意', '') as addcondition
                                , free.freefield1 as csldivname
                                , decode(ctrpt_opt.gender, 0, '共通', 1, '男性', 2, '女性') as gender
                                , decode(nvl(ctrpt_opt.exceptlimit, 0), 0, '○', '') as exceptlimit
                                , nvl( 
                                    ( 
                                        select
                                            ctrpt_price.billprintname 
                                        from
                                            ctrpt_price 
                                        where
                                            ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                            and ctrpt_price.optcd = ctrpt_opt.optcd 
                                            and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                            and ctrpt_price.seq = '1'
                                    ) 
                                    , ''
                                ) as perpricename
                                , nvl( 
                                    ( 
                                        select
                                            ctrpt_price.price 
                                        from
                                            ctrpt_price 
                                        where
                                            ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                            and ctrpt_price.optcd = ctrpt_opt.optcd 
                                            and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                            and ctrpt_price.seq = '1'
                                    ) 
                                    , 0
                                ) as perprice
                                , nvl( 
                                    ( 
                                        select
                                            ctrpt_price.tax 
                                        from
                                            ctrpt_price 
                                        where
                                            ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                            and ctrpt_price.optcd = ctrpt_opt.optcd 
                                            and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                            and ctrpt_price.seq = '1'
                                    ) 
                                    , 0
                                ) as pertax
                                , nvl( 
                                    ( 
                                        select
                                            ctrpt_price.billprintname 
                                        from
                                            ctrpt_price 
                                        where
                                            ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                            and ctrpt_price.optcd = ctrpt_opt.optcd 
                                            and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                            and ctrpt_price.seq = '2'
                                    ) 
                                    , ''
                                ) as orgpricename
                                , nvl( 
                                    ( 
                                        select
                                            ctrpt_price.price 
                                        from
                                            ctrpt_price 
                                        where
                                            ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                            and ctrpt_price.optcd = ctrpt_opt.optcd 
                                            and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                            and ctrpt_price.seq = '2'
                                    ) 
                                    , 0
                                ) as orgprice
                                , nvl( 
                                    ( 
                                        select
                                            ctrpt_price.tax 
                                        from
                                            ctrpt_price 
                                        where
                                            ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                            and ctrpt_price.optcd = ctrpt_opt.optcd 
                                            and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                            and ctrpt_price.seq = '2'
                                    ) 
                                    , 0
                                ) as orgtax
                                , nvl( 
                                    ( 
                                        select
                                            ctrpt_price.billprintname 
                                        from
                                            ctrpt_price 
                                        where
                                            ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                            and ctrpt_price.optcd = ctrpt_opt.optcd 
                                            and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                            and ctrpt_price.seq = '3'
                                    ) 
                                    , ''
                                ) as org2pricename
                                , nvl( 
                                    ( 
                                        select
                                            ctrpt_price.price 
                                        from
                                            ctrpt_price 
                                        where
                                            ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                            and ctrpt_price.optcd = ctrpt_opt.optcd 
                                            and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                            and ctrpt_price.seq = '3'
                                    ) 
                                    , 0
                                ) as org2price
                                , nvl( 
                                    ( 
                                        select
                                            ctrpt_price.tax 
                                        from
                                            ctrpt_price 
                                        where
                                            ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                            and ctrpt_price.optcd = ctrpt_opt.optcd 
                                            and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                            and ctrpt_price.seq = '3'
                                    ) 
                                    , 0
                                ) as org2tax
                                , nvl( 
                                    ( 
                                        select
                                            ctrpt_price.billprintname 
                                        from
                                            ctrpt_price 
                                        where
                                            ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                            and ctrpt_price.optcd = ctrpt_opt.optcd 
                                            and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                            and ctrpt_price.seq = '4'
                                    ) 
                                    , ''
                                ) as org3pricename
                                , nvl( 
                                    ( 
                                        select
                                            ctrpt_price.price 
                                        from
                                            ctrpt_price 
                                        where
                                            ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                            and ctrpt_price.optcd = ctrpt_opt.optcd 
                                            and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                            and ctrpt_price.seq = '4'
                                    ) 
                                    , 0
                                ) as org3price
                                , nvl( 
                                    ( 
                                        select
                                            ctrpt_price.tax 
                                        from
                                            ctrpt_price 
                                        where
                                            ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                            and ctrpt_price.optcd = ctrpt_opt.optcd 
                                            and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                            and ctrpt_price.seq = '4'
                                    ) 
                                    , 0
                                ) as org3tax 
                            from
                                ctrmng
                                , ctrpt
                                , ctrpt_opt
                                , ctrpt_optgrp
                                , ctrpt_optage
                                , free 
                            where
                                ctrmng.orgcd1 = :orgcd1 
                                and ctrmng.orgcd2 = :orgcd2 
                                and ctrmng.cscd = :cscd 
                                and ctrmng.ctrptcd = ctrpt.ctrptcd 
                                and ctrpt.strdate <= :frdate 
                                and ctrpt.enddate >= :frdate 
                                and ctrpt.ctrptcd = ctrpt_opt.ctrptcd 
                                and ctrpt_optgrp.ctrptcd = ctrpt_opt.ctrptcd 
                                and ctrpt_optgrp.optcd = ctrpt_opt.optcd 
                                and ctrpt_opt.csldivcd = free.freecd 
                                and ctrpt_optage.ctrptcd = ctrpt_opt.ctrptcd 
                                and ctrpt_optage.optcd = ctrpt_opt.optcd 
                                and ctrpt_optage.optbranchno = ctrpt_opt.optbranchno 
                            order by
                                ctrpt_opt.ctrptcd
                                , ctrpt_opt.optcd
                                , ctrpt_opt.optbranchno
                        ) lastview 
            ";

            ///金額が「0」のセット情報はデフォルトでは抽出しない
            if (queryParams["priceflg"] != "1")
            {
                sql += @"
                    where
                        perprice + pertax + orgprice + orgtax + org2price + org2tax + org3price + org3tax > 0 
                ";
            }

            sql += @"
                    order by
                        lastview.ctrptcd
                        , lastview.optcd
                        , lastview.optbranchno
            ";

            //基準日
            string cslDate = queryParams["csldate"];

            //団体コード
            string orgCd1 = queryParams["orgcd1"];
            string orgCd2 = queryParams["orgcd2"];

            //コースコード
            string csCd = queryParams["cscd"];


            var sqlParam = new
            {
                frdate = cslDate,
                orgcd1 = orgCd1,
                orgcd2 = orgCd2,
                cscd = csCd
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

            //## 出力ファイル名称編集（"CONTRACT"＋団体コード＋出力日付） ##
            FileName = FILENAME_DEF + "_" + queryParams["orgcd1"] + "-" + queryParams["orgcd2"]
                                                                    + "_" + DateTime.Today.ToString("yyyyMMdd") + ".csv";

            //編集データ初期化
            outPutData = new List<object>();

            //ヘッダ情報
            List<string> headerData = new List<string>();

            //明細データ
            List<string> detailData = new List<string>();

            //編集情報取得
            var freeDao = new FreeDao(connection);
            IList<dynamic> settingData = freeDao.SelectFree(1, FREECD_SETTING);

            if (dataList.Count > 0)
            {

                //契約基本情報取得
                var ctrpt_info = GetContractInfo(dataList[0].CTRPTCD);

                if ( ctrpt_info.Count > 0 )
                {
                    var info = ctrpt_info[0];

                    headerData.Add("■契約団体　：　" + Util.ConvertToString(info.ORGCDEDIT).Trim() + Util.ConvertToString(info.ORGNAME).Trim());

                    headerData.Add("■契約コース　：　" + Util.ConvertToString(info.CSNAME).Trim());

                    headerData.Add("■契約期間　：　" + Util.ConvertToString(info.STRDATE).Trim() + " ～ " + Util.ConvertToString(info.ENDDATE).Trim());

                    //### 負担元２請求団体チェック
                    if (Util.ConvertToString(info.ORG2CD).Trim() != "")
                    {
                        headerData.Add("■負担元２請求団体　：　" + Util.ConvertToString(info.ORG2CD).Trim() + Util.ConvertToString(info.ORG2NAME).Trim());
                    }

                    //### 負担元３請求団体チェック
                    if (Util.ConvertToString(info.ORG3CD).Trim() != "")
                    {
                        headerData.Add("■負担元３請求団体　：　" + Util.ConvertToString(info.ORG3CD).Trim() + Util.ConvertToString(info.ORG3NAME).Trim());
                    }

                    //### 限度率 ＞ 0 の契約のみ、限度額設定情報記載
                    decimal.TryParse(Util.ConvertToString(info.LIMITRATE), out decimal limitRate);

                    if (limitRate > 0)
                    {
                        headerData.Add("　限度額減算対象負担元　：　" + Util.ConvertToString(info.SUBORGNAME).Trim());

                        headerData.Add("　　　　限度額　：　総金額に対する限度率　" + Util.ConvertToString(info.LIMITRATE).Trim() + " ％　（　" + Util.ConvertToString(info.LIMITTAXFLG).Trim() + "　）");

                        headerData.Add("　　　　上限金額：　" + Util.ConvertToString(info.LIMITPRICE).Trim() + " 円");

                        headerData.Add("　減算した金額の負担元　：　" + Util.ConvertToString(info.ADDORGNAME).Trim());
                    }

                }

                //## 契約セット情報を繰り返し読み込む
                int dataCnt = 0;
                foreach (var dataItem in dataList)
                {
                    //## 契約セット情報作成

                    //レコード情報
                    Dictionary<string, object> rec = new Dictionary<string, object> { };

                    //汎用マスタの情報に合わせて編集処理
                    foreach ( var setting in settingData )
                    {
                        //汎用マスタの設定取得
                        string setDType = Util.ConvertToString(setting.FREEFIELD1); //データタイプ
                        string setLink = Util.ConvertToString(setting.FREEFIELD2);  //区分
                        string setItemCode = Util.ConvertToString(setting.FREEFIELD3);  //項目コード
                        string setItemName = Util.ConvertToString(setting.FREEFIELD4);  //項目名
                        string setFixedRsl = Util.ConvertToString(setting.FREEFIELD5);  //固定結果
                        int.TryParse(Util.ConvertToString(setting.FREEFIELD6), out int setSize);    //サイズ

                        //変換結果
                        string sResult = "";

                        //設定情報に従って結果編集
                        switch (setDType.Trim())
                        {
                            case "BAS":    //## データベースからの直接取得情報
                                IDictionary<string, object> itemDatas = dataList[dataCnt];
                                foreach (KeyValuePair<string, object> item in itemDatas)
                                {
                                    //DBのフィールド名と値を取得
                                    string dbFiledName = item.Key;  //フィールド名
                                    string dbValue = Util.ConvertToString(item.Value);    //値

                                    if ( (dbFiledName == setItemCode.Trim()) && (dbValue != ""))
                                    {
                                        //## 文章の中に含まれている空白を削除、最大サイズチェック
                                        sResult = CheckSize(CheckSpace(dbValue.Trim()), setSize);
                                        break;
                                    }
                                }
                                break;

                            case "EDT":  //編集情報
                                //### 検査セット対象年齢取得
                                if ( setItemCode.Trim() == "AGE" )
                                {
                                    sResult = GetIncludeAge(dataItem.CTRPTCD
                                                          , Util.ConvertToString(dataItem.SETCLASSCD).Trim()
                                                          , Util.ConvertToString(dataItem.OPTCD).Trim()
                                                          , Util.ConvertToString(dataItem.OPTBRANCHNO).Trim());
                                }
                                break;

                            case "CHK":  //チェック情報

                                //### 限度額対象記載有無判断
                                if ( setItemCode.Trim() == "EXCEPTLIMIT")
                                {
                                    //### 限度率 ＞ 0 の契約のみ、限度額対象区分記載
                                    decimal.TryParse(Util.ConvertToString(ctrpt_info[0].LIMITRATE), out decimal limitRate);

                                    if (limitRate > 0)
                                    {
                                        sResult = Util.ConvertToString(dataItem.EXCEPTLIMIT).Trim();
                                    }
                                    else
                                    {
                                        sResult = "";
                                  }
                                }

                                break;

                            case "FIX":  //固定情報
                                sResult = CheckSize(CheckSpace(setFixedRsl.Trim()), setSize);
                                break;
                        }

                        //カラム名をキーにして結果追加
                        rec.Add(setItemName, sResult.Trim());
                    }

                    //１行分をカンマ編集した値を出力用文字列をリストに追加
                    if (queryParams["addQuotes"] == "1")
                    {
                        //ダブルクォートあり
                        detailData.Add("\"" + string.Join( "\"" + "," + "\"", rec.Values) + "\"");
                    }
                    else
                    {
                        //ダブルクォートなし
                        detailData.Add(string.Join(",", rec.Values));
                    }

                    dataCnt++;

                }
            }
            
            //編集後データ設定
            if (headerData.Count > 0)
            {
                //ヘッダ追加
                foreach ( string header in headerData )
                {
                    Dictionary<string, object> header_rec = new Dictionary<string, object>
                    {
                        { "outcol", header }
                    };
                    outPutData.Add(header_rec);
                }
            }

            if (detailData.Count > 0)
            {
                //ヘッダを出力する場合、１行目に挿入する
                if (queryParams["detailNoHeader"] != "1")
                {
                    List<string> detailHeader = new List<string>();
                    foreach (var setting in settingData)
                    {
                        //汎用マスタのFREEFIELD4を明細ヘッダとして出力
                        detailHeader.Add(Util.ConvertToString(setting.FREEFIELD4));
                    }

                    //明細ヘッダ追加
                    string detail_head = "";
                    if (queryParams["addQuotes"] == "1")
                    {
                        //ダブルクォートあり
                        detail_head = "\"" + string.Join("\"" + "," + "\"", detailHeader) + "\"";
                    }
                    else
                    {
                        //ダブルクォートなし
                        detail_head = string.Join(",", detailHeader);
                    }

                    Dictionary<string, object> detail_rec = new Dictionary<string, object>
                    {
                        { "outcol", detail_head }
                    };
                    outPutData.Add(detail_rec);
                }

                //明細追加
                foreach (string detail in detailData)
                {
                    Dictionary<string, object> detail_rec = new Dictionary<string, object>
                    {
                        { "outcol", detail }
                    };
                    outPutData.Add(detail_rec);
                }
            }

            ret = true;

            //戻り値設定
            return ret;

        }

        /// <summary>
        /// 契約基本情報取得
        /// </summary>
        /// <param name="ctrptcd">契約パターンコード</param>
        /// <returns>取得リストデータ</returns>
        private dynamic GetContractInfo(int ctrptCd)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    org.orgcd1 as orgcd1
                    , org.orgcd2 as orgcd2
                    , '(' || org.orgcd1 || '-' || org.orgcd2 || ')' as orgcdedit
                    , org.orgname as orgname
                    , ctrmng.cscd as cscd
                    , course_p.csname as csname_cs
                    , ctrmng.ctrptcd as ctrptcd
                    , ( 
                        select
                            '(' || ctrpt_org.orgcd1 || '-' || ctrpt_org.orgcd2 || ')' 
                        from
                            ctrpt_org 
                        where
                            ctrpt_org.ctrptcd = ctrmng.ctrptcd 
                            and ctrpt_org.apdiv = '2' 
                            and ctrpt_org.seq = '3'
                    ) as org2cd
                    , ( 
                        select
                            org2.orgname 
                        from
                            ctrpt_org
                            , org org2 
                        where
                            org2.orgcd1 = ctrpt_org.orgcd1 
                            and org2.orgcd2 = ctrpt_org.orgcd2 
                            and ctrpt_org.ctrptcd = ctrpt.ctrptcd 
                            and ctrpt_org.apdiv = '2' 
                            and ctrpt_org.seq = '3'
                    ) as org2name
                    , ( 
                        select
                            '(' || ctrpt_org.orgcd1 || '-' || ctrpt_org.orgcd2 || ')' 
                        from
                            ctrpt_org 
                        where
                            ctrpt_org.ctrptcd = ctrmng.ctrptcd 
                            and ctrpt_org.apdiv = '2' 
                            and ctrpt_org.seq = '4'
                    ) as org3cd
                    , ( 
                        select
                            org2.orgname 
                        from
                            ctrpt_org
                            , org org2 
                        where
                            org2.orgcd1 = ctrpt_org.orgcd1 
                            and org2.orgcd2 = ctrpt_org.orgcd2 
                            and ctrpt_org.ctrptcd = ctrpt.ctrptcd 
                            and ctrpt_org.apdiv = '2' 
                            and ctrpt_org.seq = '4'
                    ) as org3name
                    , ctrpt.csname as csname
                    , ctrpt.cslmethod as cslmethod
                    , to_char(ctrpt.strdate, 'YYYY/MM/DD') as strdate
                    , to_char(ctrpt.enddate, 'YYYY/MM/DD') as enddate
                    , ctrpt.limitrate as limitrate
                    , decode(ctrpt.limittaxflg, 0, '消費税を含まない', 1, '消費税を含む') as limittaxflg
                    , ctrpt.limitprice as limitprice
                    , ( 
                        select
                            decode( 
                                ctrpt_org.apdiv
                                , 0
                                , '個人'
                                , 1
                                , org.orgname
                                , 2
                                , org2.orgname
                            ) 
                        from
                            ctrpt_org
                            , org org2 
                        where
                            ctrpt_org.ctrptcd = ctrpt.ctrptcd 
                            and ctrpt_org.limitpriceflg = 0 
                            and ctrpt_org.orgcd1 = org2.orgcd1(+) 
                            and ctrpt_org.orgcd2 = org2.orgcd2(+)
                    ) as suborgname
                    , ( 
                        select
                            decode( 
                                ctrpt_org.apdiv
                                , 0
                                , '個人'
                                , 1
                                , org.orgname
                                , 2
                                , org2.orgname
                            ) 
                        from
                            ctrpt_org
                            , org org2 
                        where
                            ctrpt_org.ctrptcd = ctrpt.ctrptcd 
                            and ctrpt_org.limitpriceflg = 1 
                            and ctrpt_org.orgcd1 = org2.orgcd1(+) 
                            and ctrpt_org.orgcd2 = org2.orgcd2(+)
                    ) as addorgname
                    , to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') as printdate 
                from
                    org
                    , ctrmng
                    , ctrpt
                    , course_p 
                where
                    ctrmng.ctrptcd = :ctrptcd 
                    and ctrmng.orgcd1 = org.orgcd1 
                    and ctrmng.orgcd2 = org.orgcd2 
                    and ctrmng.ctrptcd = ctrpt.ctrptcd 
                    and ctrmng.cscd = course_p.cscd(+)
                ";

            // パラメータセット
            var sqlParam = new
            {
                ctrptcd = ctrptCd
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 年齢取得
        /// </summary>
        /// <param name="ctrptCd">契約パターンコード</param>
        /// <param name="setClassCd">セット分類コード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchNo">オプション枝番</param>
        /// <returns>出力年齢</returns>
        private string GetIncludeAge(int ctrptCd, string setClassCd, string optCd, string optBranchNo)
        {
            // 戻り値初期化
            string ageStr = "";

            // SQLステートメント定義
            string sql = @"
                select
                    ctrpt_opt.ctrptcd as ctrptcd
                    , ctrpt_opt.setclasscd as setclasscd
                    , ctrpt_opt.optcd as optcd
                    , ctrpt_opt.optbranchno as optbranchno
                    , ctrpt_optage.strage as strage
                    , ctrpt_optage.endage as endage 
                from
                    ctrpt_opt
                    , ctrpt_optage 
                where
                    ctrpt_opt.ctrptcd = :ctrptcd 
                    and ctrpt_opt.setclasscd = :setclasscd 
                    and ctrpt_opt.optcd = :optcd 
                    and ctrpt_opt.optbranchno = :optbranchno 
                    and ctrpt_optage.ctrptcd = ctrpt_opt.ctrptcd 
                    and ctrpt_optage.optcd = ctrpt_opt.optcd 
                    and ctrpt_optage.optbranchno = ctrpt_opt.optbranchno 
                order by
                    ctrpt_optage.seq
                ";

            // パラメータセット
            var sqlParam = new
            {
                ctrptcd = ctrptCd,
                setclasscd = setClassCd,
                optcd = optCd,
                optbranchno = optBranchNo
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            if ( result.Count > 0)
            {

                foreach( var detail in result )
                {
                    // 初期化
                    int.TryParse(Util.ConvertToString(detail.STRAGE), out int wkTemp1); //開始年齢
                    int.TryParse(Util.ConvertToString(detail.ENDAGE), out int wkTemp2); //終了年齢

                    if (wkTemp1 == 0)
                    {
                        //開始年齢なし
                        if (wkTemp2 < 100)
                        {
                            //終了年齢が100歳未満
                            if ( wkTemp2 != 0)
                            {
                                ageStr += " " + wkTemp2 + "歳以下";
                            }

                        }

                    }
                    else
                    {
                        //開始年齢あり
                        if (wkTemp2 < 100)
                        {
                            if (wkTemp2 == 0)
                            {
                                //終了年齢なし
                                ageStr += " " + wkTemp1 + "歳以上";
                            }
                            else
                            {
                                //開始年齢・終了年齢あり
                                ageStr += " " + wkTemp1 + "歳" + "～" + wkTemp2 + "歳";
                            }
                        }
                        else if (wkTemp2 > 99)
                        {
                            //開始年齢あり、終了年齢が100歳以上
                            ageStr += " " + wkTemp1 + "歳以上";
                        }
                    }

                }

            }

            // 戻り値設定
            return ageStr;
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
            string wkCslDate = queryParams["csldate"];
            if (!DateTime.TryParse(wkCslDate, out DateTime wkDate))
            {
                messages.Add("基準日が正しくありません。");
            }

            string orgcd1 = queryParams["orgcd1"];
            string orgcd2 = queryParams["orgcd2"];
            if ( string.IsNullOrEmpty(orgcd1.Trim()) && string.IsNullOrEmpty(orgcd2.Trim()))
            {
                messages.Add("団体を選択してください。");
            }

            return messages;
        }
    }
}
