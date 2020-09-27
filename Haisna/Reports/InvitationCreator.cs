using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.ReportCore;
using Hos.CnDraw;
using Hos.CnDraw.Object;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Drawing;

namespace Hainsi.Reports
{
    /// <summary>
    /// 一括送付案内生成クラス
    /// </summary>
    public class InvitationCreator : PdfCreator
    {

        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002050";

        /// <summary>
        /// 汎用コード
        /// </summary>
        private const string FREECD_CETTIME = "CET%";
        private const string FREECD_CSLDIV = "CSLSNM%";
        private const string FREECD_OETTIME = "OET%";

        /// <summary>
        /// 汎用分類コード
        /// </summary>
        private const string FREECLASSCD_PRINTER = "YUDOPRINTER";  //誘導システムプリンタ

        /// <summary>
        /// セット分類コード
        /// </summary>
        private const string SETCLASSCD_CODE01 = "082";
        private const string SETCLASSCD_CODE02 = "083";

        /// <summary>
        /// グループコード
        /// </summary>
        private const string GRPCD_CODE01 = "K0160";
        private const string GRPCD_CODE02 = "K0180";

        /// <summary>
        /// オプションコード
        /// </summary>
        private const string OPTCD_CODE01 = "1000";
        private const string OPTCD_CODE02 = "1001";

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            if (!DateTime.TryParse(queryParams["startdate"], out DateTime wkStrDate))
            {
                messages.Add("開始日付が正しくありません。");
            }

            if (!DateTime.TryParse(queryParams["enddate"], out DateTime wkEndDate))
            {
                messages.Add("終了日付が正しくありません。");
            }

            if (string.IsNullOrEmpty(queryParams["printMode"]))
            {
                messages.Add("モードを選択してください。");
            }

            return messages;
        }

        /// <summary>
        /// 一括送付案内データを読み込む
        /// </summary>
        /// <returns>一括送付案内データ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select distinct
                    person.perid as perid
                    , 'A' || consult.rsvno || 'A' as rsvnobar
                    , peraddr3.addrdiv as addrdiv
                    , '〒' || substr(peraddr3.zipcd, 1, 3) || '－' || substr(peraddr3.zipcd, 4, 4) as zipcode
                    , peraddr3.cityname || peraddr3.address1 || peraddr3.address2 as addr
                    , peraddr3.cityname as cityname
                    , peraddr3.address1 as address1
                    , peraddr3.address2 as address2
                    , peraddr1.tel1 as telhom
                    , peraddr2.tel1 as teloff
                    , peraddr3.phone as phone
                    , person.gender as genderdiv
                    , person.lastname || '  ' || person.firstname || '  ' || '様' as name
                    , person.lastkname || '  ' || person.firstkname as kananame
                    , decode( 
                        consult.formouteng
                        , 1
                        , person.romename
                        , person.lastkname || ' ' || person.firstkname
                    ) as tname
                    , person.gender as gender
                    , decode(person.gender, 1, '(male)', '(female)') as gendername
                    , decode(person.gender, 1, '(男性)', '(女性)') as gendernamej
                    , to_char(person.birth, 'YYYY. MM. DD') as birth
                    , consult.rsvno as rsvno
                    , to_char(consult.csldate, 'YYYY. MM. DD ') as csldate
                    , decode( 
                        to_char(consult.csldate, 'D')
                        , 1
                        , '(日)'
                        , 2
                        , '(月)'
                        , 3
                        , '(火)'
                        , 4
                        , '(水)'
                        , 5
                        , '(木)'
                        , 6
                        , '(金)'
                        , 7
                        , '(土)'
                    ) as jyobi
                    , decode( 
                        to_char(consult.csldate, 'D')
                        , 1
                        , '(SUN)'
                        , 2
                        , '(MON)'
                        , 3
                        , '(TUE)'
                        , 4
                        , '(WED)'
                        , 5
                        , '(THU)'
                        , 6
                        , '(FRI)'
                        , 7
                        , '(SAT)'
                    ) as eyobi
                    , org.orgname as orgname
                    , decode( 
                        consult.formouteng
                        , 1
                        , org.orgename
                        , org.orgname
                    ) as torgname
                    , org.packagesend as packagesend
                    , org.sendcomment as sendcomment
                    , org.sendecomment as sendecomment
                    , consult.rsvgrpcd as rsvgrpcd
                    , rsvgrp.strtime as strtime
                    , sign(rsvgrp.strtime - 1200) as ampm
                    , rsvgrp.endtime as endtime
                    , consult.formouteng as formouteng
                    , substr(rsvgrp.rptendtime, 1, 2) || ':' || substr(rsvgrp.rptendtime, 3, 2) as rptendtime
                    , ( 
                        select
                            decode( 
                                max(free.freefield3)
                                , null
                                , 'NONE'
                                , substr(max(free.freefield3), 1, 2) || ':' || substr(max(free.freefield3), 3, 2)
                            ) 
                        from
                            free 
                        where
                            free.freecd like :freecd_cettime 
                            and free.freefield1 = consult.csldivcd 
                            and free.freefield2 = consult.rsvgrpcd
                    ) as cettime
                    , ( 
                        select
                            decode( 
                                max(free.freefield3)
                                , null
                                , 'NONE'
                                , substr(max(free.freefield3), 1, 2) || ':' || substr(max(free.freefield3), 3, 2)
                            ) 
                        from
                            consult_o
                            , ctrpt_opt
                            , free 
                        where
                            consult_o.rsvno = consult.rsvno 
                            and consult_o.ctrptcd = ctrpt_opt.ctrptcd 
                            and consult_o.optcd = ctrpt_opt.optcd 
                            and consult_o.optbranchno = ctrpt_opt.optbranchno 
                            and ctrpt_opt.setclasscd in (:setclasscd_01, :setclasscd_02) 
                            and free.freecd like 'OET%' 
                            and ctrpt_opt.setclasscd = free.freefield1 
                            and free.freefield2 = consult.rsvgrpcd
                    ) as oettime
                    , decode( 
                        substr(person.perid, 1, 1)
                        , ','
                        , ' '
                        , person.perid
                    ) as perid
                    , ctrpt.csname as csname
                    , ctrpt.csename as csename
                    , decode( 
                        consult.formouteng
                        , 1
                        , ctrpt.csename
                        , decode( 
                            consult.rsvgrpcd
                            , '50'
                            , ctrpt_opt.optname
                            , '51'
                            , ctrpt_opt.optname
                            , ctrpt.csname
                        )
                    ) as tcsname
                    , consult.ctrptcd as ctrptcd
                    , course_rsvgrp.mnggender as mnggender
                    , course_rsvgrp.defcnt as defcnt
                    , course_rsvgrp.defcnt_f as defcnt_f
                    , course_rsvgrp.defcnt_m as defcnt_m
                    , consult.cscd as cscd
                    , ( 
                        select
                            count(ctrpt_grp.grpcd) 
                        from
                            consult_o
                            , ctrpt_grp 
                        where
                            consult_o.rsvno = consult.rsvno 
                            and consult_o.ctrptcd = ctrpt_grp.ctrptcd 
                            and consult_o.optcd = ctrpt_grp.optcd 
                            and consult_o.optbranchno = ctrpt_grp.optbranchno 
                            and ctrpt_grp.grpcd in (:grpcd_01, :grpcd_02)
                    ) as chestcnt
                    , ( 
                        select
                            nvl(free.freefield2, '　') 
                        from
                            free 
                        where
                            freecd like :freecd_csldiv 
                            and freefield1 = consult.csldivcd
                    ) as csldiv
                    , ( 
                        select
                            nvl(free.freefield3, '　') 
                        from
                            free 
                        where
                            freecd like :freecd_csldiv
                            and freefield1 = consult.csldivcd
                    ) as csldive
                    , org.orgcd1 as orgcd1
                    , org.orgcd2 as orgcd2
                    , consult.csldivcd as csldivcd 
                from
                    consult 
                    left join peraddr peraddr1 
                        on peraddr1.perid = consult.perid 
                        and peraddr1.addrdiv = '1' 
                    left join peraddr peraddr2 
                        on peraddr2.perid = consult.perid 
                        and peraddr2.addrdiv = '2' 
                    left join peraddr peraddr3 
                        on peraddr3.perid = consult.perid 
                        and peraddr3.addrdiv = decode( 
                            consult.formaddrdiv
                            , null
                            , '1'
                            , ''
                            , '1'
                            , consult.formaddrdiv
                        ) 
                    , person
                    , rsvgrp
                    , org
                    , ctrpt
                    , course_rsvgrp
                    , consult_o
                    , ctrpt_opt 
                where
                    consult.perid = person.perid 
                    and consult.rsvgrpcd = rsvgrp.rsvgrpcd 
                    and nvl(consult.orgcd1, '') = nvl(org.orgcd1, '') 
                    and nvl(consult.orgcd2, '') = nvl(org.orgcd2, '') 
                    and consult.ctrptcd = ctrpt.ctrptcd 
                    and course_rsvgrp.cscd = consult.cscd 
                    and course_rsvgrp.rsvgrpcd = consult.rsvgrpcd 
                    and consult.cancelflg = :cancelflg  
                    and consult.rsvstatus = 0 
                    and consult.rsvno = consult_o.rsvno 
                    and consult_o.ctrptcd = ctrpt_opt.ctrptcd 
                    and consult_o.optcd = ctrpt_opt.optcd 
                    and consult_o.optbranchno = ctrpt_opt.optbranchno 
                    and consult_o.optcd in (:optcd_01, :optcd_02) 
                    and org.packagesend = 1 
                ";

            //開始受診日
            string sDate = queryParams["startdate"];
            if (!string.IsNullOrEmpty(sDate))
            {
                sql += @"  and consult.csldate >= :startdate ";
            }

            //終了受診日
            string eDate = queryParams["enddate"];
            if (!string.IsNullOrEmpty(eDate))
            {
                sql += @"  and consult.csldate <= :enddate ";
            }

            //コースコード
            // コースコード指定あり＋開始受診日の指定あり
            string csCd = queryParams["cscd"];
            if (!string.IsNullOrEmpty(csCd) && (!string.IsNullOrEmpty(sDate)))
            {
                sql += @"  and consult.cscd = :cscd ";
            }

            // コースコード指定なし＋開始受診日の指定あり
            if ( string.IsNullOrEmpty(csCd) && (!string.IsNullOrEmpty(sDate)))
            {
                sql += @"
                     and consult.cscd in ( 
                         select
                             freefield1 
                         from
                             free 
                         where
                             free.freecd like 'INVCS%'
                     ) 
                     ";
            }

            //一度出力した受診者は対象外＋開始受診日の指定あり
            if (queryParams["object"] == "1" && (!string.IsNullOrEmpty(sDate)))
            {
                sql += @"  and consult.formprintdate is null ";
            }

            sql += @"
                order by
                    orgname
                    , kananame
                ";


            // パラメータセット
            var sqlParam = new
            {
                startdate = sDate,
                enddate = eDate,
                cscd = csCd,
                cancelflg = ConsultCancel.Used,

                freecd_cettime = FREECD_CETTIME,
                freecd_csldiv = FREECD_CSLDIV,
                freecd_oettime = FREECD_OETTIME,

                setclasscd_01 = SETCLASSCD_CODE01,
                setclasscd_02 = SETCLASSCD_CODE02,

                grpcd_01 = GRPCD_CODE01,
                grpcd_02 = GRPCD_CODE02,

                optcd_01 = OPTCD_CODE01,
                optcd_02 = OPTCD_CODE02
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">ご案内書送付チェックリストデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;
            CnLayers cnLayers = cnForm.CnLayers;

            // フォームの各項目を変数にセット
            var zukeiLayer = cnLayers["図形"];
            var yoyakuengLayer = cnLayers["予約情報（英語）"];
            var yoyakujpnLayer = cnLayers["予約情報（日本語）"];
            var yoyakusyaLayer = cnLayers["予約者情報"];
            var kensa1Layer = cnLayers["検査１"];
            var ura1Layer = cnLayers["検査１裏"];
            var ura1_pmLayer = cnLayers["検査１裏（ＰＭ）"];
            var ura1_nLayer = cnLayers["検査１裏（内）"];
            var ura1_nwLayer = cnLayers["検査１裏（内女）"];
            var ura1_wLayer = cnLayers["検査１裏（女）"];
            var kensa2Layer = cnLayers["検査２英"];
            var ura2Layer = cnLayers["検査２英裏"];
            var ura2_pmLayer = cnLayers["検査２英裏（ＰＭ）"];
            var kensa3Layer = cnLayers["検査３"];
            var ura3Layer = cnLayers["検査３裏"];
            var ura3_50Layer = cnLayers["検査３裏（５０）"];
            var ura3_n51Layer = cnLayers["検査３裏（内５１）"];
            var ura3_51Layer = cnLayers["検査３裏（５１）"];
            var ura3_nLayer = cnLayers["検査３裏（内）"];
            var ura3_nwLayer = cnLayers["検査３裏（内女）"];
            var ura3_wLayer = cnLayers["検査３裏（女）"];
            var kensa4Layer = cnLayers["検査４英"];
            var kensa4_50Layer = cnLayers["検査４英（午前）"];
            var kensa4_51Layer = cnLayers["検査４英（午後）"];
            var ura4Layer = cnLayers["検査４英裏"];
            var ura4_50Layer = cnLayers["検査４英裏（午前）"];
            var ura4_51Layer = cnLayers["検査４英裏（午後）"];
            var ura4_wLayer = cnLayers["検査４英裏（女）"];
            var kensa9Layer = cnLayers["検査９"];
            var ura9Layer = cnLayers["検査９裏"];
            var kensa10Layer = cnLayers["検査１０"];
            var kensa11Layer = cnLayers["検査１１"];
            var zipcdField = (CnDataField)cnObjects["ZIPCD"];
            var citynameField = (CnDataField)cnObjects["CITYNAME"];
            var address1Field = (CnDataField)cnObjects["ADDRESS1"];
            var address2Field = (CnDataField)cnObjects["ADDRESS2"];
            var nameField = (CnDataField)cnObjects["NAME"];
            var barcodeField = (CnBarcodeField)cnObjects["BARCODE"];
            var barcdidField = (CnDataField)cnObjects["BARCDID"];
            var csldateField = (CnDataField)cnObjects["CSLDATE"];
            var yobiField = (CnDataField)cnObjects["YOBI"];
            var ch1Field = (CnDataField)cnObjects["CH1"];
            var ch2Field = (CnDataField)cnObjects["CH2"];
            var ch3Field = (CnDataField)cnObjects["CH3"];
            var ch4Field = (CnDataField)cnObjects["CH4"];
            var hour1Field = (CnDataField)cnObjects["HOUR1"];
            var hour2Field = (CnDataField)cnObjects["HOUR2"];
            var hour3Field = (CnDataField)cnObjects["HOUR3"];
            var hour4Field = (CnDataField)cnObjects["HOUR4"];
            var endhField = (CnDataField)cnObjects["ENDH"];
            var companyTextField = (CnTextField)cnObjects["COMPANY"];
            var courseField = (CnDataField)cnObjects["COURSE"];
            var csldivField = (CnDataField)cnObjects["CSLDIV"];
            var toptionField = (CnDataField)cnObjects["TOPTION"];
            var opcomeField = (CnDataField)cnObjects["OPCOME"];
            var optionListField = (CnListField)cnObjects["OPTION"];
            var option_eListField = (CnListField)cnObjects["OPTION_E"];
            var priceField = (CnDataField)cnObjects["PRICE"];
            var takuField = (CnDataField)cnObjects["TAKU"];
            var ikensaField = (CnDataField)cnObjects["IKENSA"];
            var nameknField = (CnDataField)cnObjects["NAMEKN"];
            var genderField = (CnDataField)cnObjects["GENDER"];
            var birthField = (CnDataField)cnObjects["BIRTH"];
            var peridField = (CnDataField)cnObjects["PERID"];
            var telhomeField = (CnDataField)cnObjects["TELHOME"];
            var teloffField = (CnDataField)cnObjects["TELOFF"];
            var telperField = (CnDataField)cnObjects["TELPER"];
            var placejField = (CnDataField)cnObjects["PLACEJ"];
            var tendtimeField = (CnDataField)cnObjects["TENDTIME"];
            var tendcome1Field = (CnDataField)cnObjects["TENDCOME1"];
            var tendcome2Field = (CnDataField)cnObjects["TENDCOME2"];
            var placeeField = (CnDataField)cnObjects["PLACEE"];
            var t1_stanField = (CnDataField)cnObjects["T1-STAN"];
            var t1_zisan1Field = (CnDataField)cnObjects["T1-ZISAN1"];
            var t1_zisan2Field = (CnDataField)cnObjects["T1-ZISAN2"];
            var t1_zisan3Field = (CnDataField)cnObjects["T1-ZISAN3"];
            var t1_zisan4Field = (CnDataField)cnObjects["T1-ZISAN4"];
            var t1_zisan5Field = (CnDataField)cnObjects["T1-ZISAN5"];
            var t1_zisan6Field = (CnDataField)cnObjects["T1-ZISAN6"];
            var t1_zisan7Field = (CnDataField)cnObjects["T1-ZISAN7"];
            var t1_zisan8Field = (CnDataField)cnObjects["T1-ZISAN8"];
            var t1_zisan9Field = (CnDataField)cnObjects["T1-ZISAN9"];
            var t1_stan2Field = (CnDataField)cnObjects["T1-STAN2"];
            var t1_zisan10Field = (CnDataField)cnObjects["T1-ZISAN10"];
            var t1_zisan11Field = (CnDataField)cnObjects["T1-ZISAN11"];
            var t1_comeTextField = (CnTextField)cnObjects["T1-COME"];
            var t1e_stanField = (CnDataField)cnObjects["T1E-STAN"];
            var t1e_stan2Field = (CnDataField)cnObjects["T1E-STAN2"];
            var t1e_comeTextField = (CnTextField)cnObjects["T1E-COME"];
            var t1e_zisan1Field = (CnDataField)cnObjects["T1E-ZISAN1"];
            var t1e_zisan2Field = (CnDataField)cnObjects["T1E-ZISAN2"];
            var t1e_zisan3Field = (CnDataField)cnObjects["T1E-ZISAN3"];
            var t1e_zisan4Field = (CnDataField)cnObjects["T1E-ZISAN4"];
            var t1e_zisan5Field = (CnDataField)cnObjects["T1E-ZISAN5"];
            var t1e_zisan6Field = (CnDataField)cnObjects["T1E-ZISAN6"];
            var t1e_zisan7Field = (CnDataField)cnObjects["T1E-ZISAN7"];
            var t1e_zisan8Field = (CnDataField)cnObjects["T1E-ZISAN8"];
            var t1e_zisan9Field = (CnDataField)cnObjects["T1E-ZISAN9"];
            var t1e_zisan10Field = (CnDataField)cnObjects["T1E-ZISAN10"];
            var t1e_zisan11Field = (CnDataField)cnObjects["T1E-ZISAN11"];
            var t1e_zisan12Field = (CnDataField)cnObjects["T1E-ZISAN12"];
            var t1e_zisan13Field = (CnDataField)cnObjects["T1E-ZISAN13"];
            var t1e_zisan14Field = (CnDataField)cnObjects["T1E-ZISAN14"];
            var t1e_zisan15Field = (CnDataField)cnObjects["T1E-ZISAN15"];
            var t2e_souhu1Field = (CnDataField)cnObjects["T2E-SOUHU1"];
            var t2e_souhu2Field = (CnDataField)cnObjects["T2E-SOUHU2"];
            var t2e_comeTextField = (CnTextField)cnObjects["T2E-COME"];
            var t2e_zisan1Field = (CnDataField)cnObjects["T2E-ZISAN1"];
            var t2e_zisan2Field = (CnDataField)cnObjects["T2E-ZISAN2"];
            var t2e_zisan3Field = (CnDataField)cnObjects["T2E-ZISAN3"];
            var t2e_zisan4Field = (CnDataField)cnObjects["T2E-ZISAN4"];
            var t2e_zisan5Field = (CnDataField)cnObjects["T2E-ZISAN5"];
            var t2e_zisan6Field = (CnDataField)cnObjects["T2E-ZISAN6"];
            var t2e_zisan7Field = (CnDataField)cnObjects["T2E-ZISAN7"];
            var t2e_zisan8Field = (CnDataField)cnObjects["T2E-ZISAN8"];
            var t2e_zisan9Field = (CnDataField)cnObjects["T2E-ZISAN9"];
            var t2e_zisan10Field = (CnDataField)cnObjects["T2E-ZISAN10"];
            var t2e_zisan11Field = (CnDataField)cnObjects["T2E-ZISAN11"];
            var t2e_zisan12Field = (CnDataField)cnObjects["T2E-ZISAN12"];
            var t2e_zisan13Field = (CnDataField)cnObjects["T2E-ZISAN13"];
            var t2e_zisan14Field = (CnDataField)cnObjects["T2E-ZISAN14"];
            var t2e_zisan15Field = (CnDataField)cnObjects["T2E-ZISAN15"];
            var t3_comeTextField = (CnTextField)cnObjects["T3-COME"];
            var t3_souhu1Field = (CnDataField)cnObjects["T3-SOUHU1"];
            var t3_souhu2Field = (CnDataField)cnObjects["T3-SOUHU2"];
            var t3_zisan1Field = (CnDataField)cnObjects["T3-ZISAN1"];
            var t3_zisan2Field = (CnDataField)cnObjects["T3-ZISAN2"];
            var t3_zisan3Field = (CnDataField)cnObjects["T3-ZISAN3"];
            var t3_zisan4Field = (CnDataField)cnObjects["T3-ZISAN4"];
            var t3_zisan5Field = (CnDataField)cnObjects["T3-ZISAN5"];
            var t3_zisan6Field = (CnDataField)cnObjects["T3-ZISAN6"];
            var t3_zisan7Field = (CnDataField)cnObjects["T3-ZISAN7"];
            var t3_zisan8Field = (CnDataField)cnObjects["T3-ZISAN8"];
            var t3_zisan9Field = (CnDataField)cnObjects["T3-ZISAN9"];
            var t3_zisan10Field = (CnDataField)cnObjects["T3-ZISAN10"];
            var t3_zisan11Field = (CnDataField)cnObjects["T3-ZISAN11"];

            string sysdate = DateTime.Today.ToShortDateString();

            int pageNo = 0;

            string ura = "OFF";

            int dataPos = 0;

            // ページ内の項目に値をセット
            while (dataPos < data.Count)
            {
                var detail = data[dataPos];

                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                //全レイヤの印刷をoff
                zukeiLayer.VisibleAtPrint = false;
                yoyakuengLayer.VisibleAtPrint = false;
                yoyakujpnLayer.VisibleAtPrint = false;
                yoyakusyaLayer.VisibleAtPrint = false;
                kensa1Layer.VisibleAtPrint = false;
                ura1Layer.VisibleAtPrint = false;
                ura1_pmLayer.VisibleAtPrint = false;
                ura1_nLayer.VisibleAtPrint = false;
                ura1_nwLayer.VisibleAtPrint = false;
                ura1_wLayer.VisibleAtPrint = false;
                kensa2Layer.VisibleAtPrint = false;
                ura2Layer.VisibleAtPrint = false;
                ura2_pmLayer.VisibleAtPrint = false;
                kensa3Layer.VisibleAtPrint = false;
                ura3Layer.VisibleAtPrint = false;
                ura3_50Layer.VisibleAtPrint = false;
                ura3_51Layer.VisibleAtPrint = false;
                ura3_n51Layer.VisibleAtPrint = false;
                ura3_nLayer.VisibleAtPrint = false;
                ura3_nwLayer.VisibleAtPrint = false;
                ura3_wLayer.VisibleAtPrint = false;
                kensa4Layer.VisibleAtPrint = false;
                kensa4_50Layer.VisibleAtPrint = false;
                kensa4_51Layer.VisibleAtPrint = false;
                ura4Layer.VisibleAtPrint = false;
                ura4_50Layer.VisibleAtPrint = false;
                ura4_51Layer.VisibleAtPrint = false;
                ura4_wLayer.VisibleAtPrint = false;
                kensa9Layer.VisibleAtPrint = false;
                ura9Layer.VisibleAtPrint = false;
                kensa10Layer.VisibleAtPrint = false;
                kensa11Layer.VisibleAtPrint = false;

                //初期値設定（黒）
                ch1Field.TextColor = Color.FromArgb(0, 0, 0);
                ch2Field.TextColor = Color.FromArgb(0, 0, 0);
                ch3Field.TextColor = Color.FromArgb(0, 0, 0);
                ch4Field.TextColor = Color.FromArgb(0, 0, 0);
                hour1Field.TextColor = Color.FromArgb(0, 0, 0);
                hour2Field.TextColor = Color.FromArgb(0, 0, 0);
                hour3Field.TextColor = Color.FromArgb(0, 0, 0);
                hour4Field.TextColor = Color.FromArgb(0, 0, 0);

                if (ura == "OFF")
                {
                    //共通予約者情報の編集"
                    //印刷レイヤの設定（ON）
                    zukeiLayer.VisibleAtPrint = true;
                    yoyakusyaLayer.VisibleAtPrint = true;

                    if (Util.ConvertToString(detail.FORMOUTENG) == "1")
                    {
                        yoyakuengLayer.VisibleAtPrint = true;
                    }
                    else
                    {
                        yoyakujpnLayer.VisibleAtPrint = true;
                    }

                    //郵便番号
                    zipcdField.Text = Util.ConvertToString(detail.ZIPCODE);
                    //市町村
                    citynameField.Text = Util.ConvertToString(detail.CITYNAME);
                    //住所１
                    address1Field.Text = Util.ConvertToString(detail.ADDRESS1);
                    //住所２
                    address2Field.Text = Util.ConvertToString(detail.ADDRESS2);
                    //氏名
                    nameField.Text = Util.ConvertToString(detail.NAME);

                    //バーコード
                    barcodeField.Data = Util.ConvertToString(detail.RSVNOBAR);
                    barcdidField.Text = Util.ConvertToString(detail.RSVNOBAR);

                    //氏名カナ
                    nameknField.Text = Util.ConvertToString(detail.TNAME);

                    //性別
                    if (Util.ConvertToString(detail.FORMOUTENG) == "1")
                    {
                        genderField.Text = Util.ConvertToString(detail.GENDERNAME);
                    }
                    else
                    {
                        genderField.Text = Util.ConvertToString(detail.GENDERNAMEJ);
                    }

                    //生年月日
                    birthField.Text = Util.ConvertToString(detail.BIRTH);

                    //患者ＩＤ
                    if ( (Util.ConvertToString(detail.PERID) != "") && (Convert.ToString(detail.PERID).Substring(0, 1) == "@"))
                        peridField.Text = "";
                    {
                        peridField.Text = Util.ConvertToString(detail.PERID);
                    }

                    //自宅電話番号
                    telhomeField.Text = Util.ConvertToString(detail.TELHOM);

                    //会社電話番号
                    teloffField.Text = Util.ConvertToString(detail.TELOFF);

                    //携帯電話番号
                    telperField.Text = Util.ConvertToString(detail.PHONE);

                }

                int ret1 = 0;
                int ret2 = 0;

                short currentLine = 0;
                short col = 0;

                if (detail.CSCD == "100" || detail.CSCD == "105")
                {
                    if (Util.ConvertToString(detail.FORMOUTENG )!= "1")
                    {
                        if (ura == "OFF")
                        {
                            //＜検査１（表）編集＞
                            //印刷レイヤの設定
                            kensa1Layer.VisibleAtPrint = true;

                            //## 喀痰検査チェック
                            ret1 = GetSub1(detail.RSVNO, detail.CTRPTCD);

                            //## 便中ピロリ菌抗原検査チェック
                            ret2 = GetBen3(detail.RSVNO);

                            if (ret1 > 0)
                            {
                                if (ret2 > 0)
                                {
                                    //送付喀痰
                                    t1_stanField.Text = "□ 喀痰容器（白の袋）";
                                    t1_stan2Field.Text = "□ ピロリ菌採便容器（青の袋）";
                                    //持参品
                                    t1_zisan1Field.Text = "□ 喀痰容器（白の袋）：受診日2日前から当日までの3日間の";
                                    t1_zisan2Field.Text = "　 　　　　　　　　　　痰を採取して下さい。";
                                    t1_zisan3Field.Text = "□ ピロリ菌採便容器（青の袋）：受診当日または前日に便を";
                                    t1_zisan4Field.Text = "　 　　　　　　　　　　　　　　採取して下さい。";
                                    t1_zisan5Field.Text = " 　※検便・検尿などの検体は、受診日にお預かりします。";
                                    t1_zisan6Field.Text = " 　　　後日ご提出いただくことはできません。";
                                    t1_zisan7Field.Text = "□ 診察券（IDカード）：当院を受診したことのある方";
                                    t1_zisan8Field.Text = "□ 眼鏡・コンタクト（使い捨てレンズをご使用の方は予備も";
                                    t1_zisan9Field.Text = " 　お持ち下さい）";
                                    t1_zisan10Field.Text = "□ 保険証";
                                    t1_zisan11Field.Text = "□ 利用券など：ご利用の団体により必要な方";
                                }
                                else
                                {
                                    //送付喀痰
                                    t1_stanField.Text = "□ 喀痰容器（白の袋）";
                                    t1_stan2Field.Text = "";
                                    //持参品
                                    t1_zisan1Field.Text = "□ 喀痰容器（白の袋）：受診日2日前から当日までの3日間の";
                                    t1_zisan2Field.Text = "　 　　　　　　　　　　痰を採取して下さい。";
                                    t1_zisan3Field.Text = " 　※検便・検尿などの検体は、受診日にお預かりします。";
                                    t1_zisan4Field.Text = " 　　　後日ご提出いただくことはできません。";
                                    t1_zisan5Field.Text = "□ 診察券（IDカード）：当院を受診したことのある方";
                                    t1_zisan6Field.Text = "□ 眼鏡・コンタクト（使い捨てレンズをご使用の方は予備も";
                                    t1_zisan7Field.Text = " 　お持ち下さい）";
                                    t1_zisan8Field.Text = "□ 保険証";
                                    t1_zisan9Field.Text = "□ 利用券など：ご利用の団体により必要な方";
                                    t1_zisan10Field.Text = "";
                                    t1_zisan11Field.Text = "";
                                }
                            }
                            else
                            {
                                if (ret2 > 0)
                                {
                                    //送付喀痰
                                    t1_stanField.Text = "□ ピロリ菌採便容器（青の袋）";
                                    t1_stan2Field.Text = "";
                                    //持参品
                                    t1_zisan1Field.Text = "□ ピロリ菌採便容器（青の袋）：受診当日または前日に便を";
                                    t1_zisan2Field.Text = "　 　　　　　　　　　　　　　　採取して下さい。";
                                    t1_zisan3Field.Text = " 　※検便・検尿などの検体は、受診日にお預かりします。";
                                    t1_zisan4Field.Text = " 　　　後日ご提出いただくことはできません。";
                                    t1_zisan5Field.Text = "□ 診察券（IDカード）：当院を受診したことのある方";
                                    t1_zisan6Field.Text = "□ 眼鏡・コンタクト（使い捨てレンズをご使用の方は予備も";
                                    t1_zisan7Field.Text = " 　お持ち下さい）";
                                    t1_zisan8Field.Text = "□ 保険証";
                                    t1_zisan9Field.Text = "□ 利用券など：ご利用の団体により必要な方";
                                    t1_zisan10Field.Text = "";
                                    t1_zisan11Field.Text = "";

                                }
                                else
                                {
                                    //持参品
                                    t1_zisan1Field.Text = " 　※検便・検尿などの検体は、受診日にお預かりします。";
                                    t1_zisan2Field.Text = " 　　　後日ご提出いただくことはできません。";
                                    t1_zisan3Field.Text = "□ 診察券（IDカード）：当院を受診したことのある方";
                                    t1_zisan4Field.Text = "□ 眼鏡・コンタクト（使い捨てレンズをご使用の方は予備も";
                                    t1_zisan5Field.Text = " 　お持ち下さい）";
                                    t1_zisan6Field.Text = "□ 保険証";
                                    t1_zisan7Field.Text = "□ 利用券など：ご利用の団体により必要な方";
                                    t1_zisan8Field.Text = "";
                                    t1_zisan9Field.Text = "";
                                    t1_zisan10Field.Text = "";
                                    t1_zisan11Field.Text = "";
                                }
                            }

                            //コメント欄
                            //個人受診者のリピータ割引コメントはフルオプションや後日GFコースの受診者には出さない
                            if (detail.ORGCD1 == "XXXXX")
                            {
                                if ((detail.CSLDIVCD != "CSLDIV016") && (detail.CSLDIVCD != "CSLDIV017"))
                                {
                                    t1_comeTextField.Text = Util.ConvertToString(detail.SENDCOMMENT).Trim();
                                }

                            }
                            else
                            {
                                t1_comeTextField.Text = Util.ConvertToString(detail.SENDCOMMENT).Trim();
                            }

                            //受診日
                            csldateField.Text = Util.ConvertToString(detail.CSLDATE);

                            //曜日
                            yobiField.Text = Util.ConvertToString(detail.JYOBI);

                            //該当チェック１
                            if (detail.CSCD == "105")
                            {

                                if (Util.ConvertToString(detail.RSVGRPCD) == "20")
                                {
                                    ch1Field.Text = "◎";
                                }
                                else
                                {
                                    ch1Field.Text = "×";
                                    ch1Field.TextColor = Color.FromArgb(204, 204, 204);
                                    hour1Field.TextColor = Color.FromArgb(204, 204, 204);
                                }

                            }
                            else
                            {
                                if (detail.CSCD == "100")
                                {
                                    if (Util.ConvertToString(detail.GENDER) == "1")
                                    {
                                        if (Util.ConvertToString(detail.STRTIME) == "800")
                                        {
                                            ch1Field.Text = "◎";
                                        }
                                        else
                                        {
                                            ch1Field.Text = "×";
                                            ch1Field.TextColor = Color.FromArgb(204, 204, 204);
                                            hour1Field.TextColor = Color.FromArgb(204, 204, 204);
                                        }
                                    }
                                    else
                                    {
                                        if (Util.ConvertToString(detail.STRTIME) == "820")
                                        {
                                            ch1Field.Text = "◎";
                                        }
                                        else
                                        {
                                            ch1Field.Text = "×";
                                            ch1Field.TextColor = Color.FromArgb(204, 204, 204);
                                            hour1Field.TextColor = Color.FromArgb(204, 204, 204);
                                        }
                                    }
                                }
                            }

                            //該当チェック２
                            if (detail.CSCD == "105")
                            {
                                if (Util.ConvertToString(detail.RSVGRPCD) == "25")
                                {
                                    ch2Field.Text = "◎";
                                }
                                else
                                {
                                    ch2Field.Text = "×";
                                    ch2Field.TextColor = Color.FromArgb(204, 204, 204);
                                    hour2Field.TextColor = Color.FromArgb(204, 204, 204);
                                }
                            }
                            else
                            {
                                if (detail.CSCD == "100")
                                {
                                    if (Util.ConvertToString(detail.GENDER) == "1")
                                    {
                                        if (Util.ConvertToString(detail.STRTIME) == "840")
                                        {
                                            ch2Field.Text = "◎";
                                        }
                                        else
                                        {
                                            ch2Field.Text = "×";
                                            ch2Field.TextColor = Color.FromArgb(204, 204, 204);
                                            hour2Field.TextColor = Color.FromArgb(204, 204, 204);
                                        }
                                    }
                                    else
                                    {
                                        if (Util.ConvertToString(detail.STRTIME) == "900")
                                        {
                                            ch2Field.Text = "◎";
                                        }
                                        else
                                        {
                                            ch2Field.Text = "×";
                                            ch2Field.TextColor = Color.FromArgb(204, 204, 204);
                                            hour2Field.TextColor = Color.FromArgb(204, 204, 204);
                                        }
                                    }
                                }
                            }

                            //該当チェック３
                            if (detail.CSCD == "105")
                            {
                                ch3Field.Text = " ";
                            }
                            else
                            {
                                if (detail.CSCD == "100")
                                {
                                    if (Util.ConvertToString(detail.GENDER) == "1")
                                    {
                                        if (Util.ConvertToString(detail.STRTIME) == "920")
                                        {
                                            ch3Field.Text = "◎";
                                        }
                                        else
                                        {
                                            ch3Field.Text = "×";
                                            ch3Field.TextColor = Color.FromArgb(204, 204, 204);
                                            hour3Field.TextColor = Color.FromArgb(204, 204, 204);
                                        }
                                    }
                                    else
                                    {
                                        if (Util.ConvertToString(detail.STRTIME) == "1000")
                                        {
                                            ch3Field.Text = "◎";
                                        }
                                        else
                                        {
                                            ch3Field.Text = "×";
                                            ch3Field.TextColor = Color.FromArgb(204, 204, 204);
                                            hour3Field.TextColor = Color.FromArgb(204, 204, 204);
                                        }
                                    }
                                }
                            }

                            //該当チェック４
                            if (detail.CSCD == "105")
                            {
                                ch4Field.Text = " ";
                            }
                            else
                            {
                                if (detail.CSCD == "100")
                                {
                                    if (Util.ConvertToString(detail.GENDER) == "1")
                                    {
                                        if (Util.ConvertToString(detail.STRTIME) == "1020")
                                        {
                                            ch4Field.Text = "◎";
                                        }
                                        else
                                        {
                                            ch4Field.Text = "×";
                                            ch4Field.TextColor = Color.FromArgb(204, 204, 204);
                                            hour4Field.TextColor = Color.FromArgb(204, 204, 204);
                                        }
                                    }
                                    else
                                    {
                                        if (Util.ConvertToString(detail.STRTIME) == "1040")
                                        {
                                            ch4Field.Text = "◎";
                                        }
                                        else
                                        {
                                            ch4Field.Text = "×";
                                            ch4Field.TextColor = Color.FromArgb(204, 204, 204);
                                            hour4Field.TextColor = Color.FromArgb(204, 204, 204);
                                        }
                                    }
                                }
                            }

                            //受付時間１
                            if (detail.CSCD == "105")
                            {
                                if (Util.ConvertToString(detail.GENDER) == "1")
                                {
                                    hour1Field.Text = "8:00～8:10";
                                }
                                else
                                {
                                    hour1Field.Text = "8:20～8:30";
                              }
                            }
                            else
                            {
                                if (detail.CSCD == "100")
                                {
                                    if (detail.DEFCNT_F > 0)
                                    {
                                        hour1Field.Text = "8:20～8:30";
                                    }
                                    else
                                    {
                                        hour1Field.Text = "8:00～8:10";
                                  }
                                }
                            }

                            //受付時間２
                            if (detail.CSCD == "105")
                            {
                                hour2Field.Text = "13:30～13:40";

                            }
                            else
                            {
                                if (detail.CSCD == "100")
                                {
                                    if (detail.DEFCNT_F > 0)
                                    {
                                        hour2Field.Text = "9:00～9:10";
                                    }
                                    else
                                    {
                                        hour2Field.Text = "8:40～8:50";
                                    }
                                }
                            }

                            //受付時間３
                            if (detail.CSCD == "105")
                            {
                                hour3Field.Text = " ";
                            }
                            else
                            {
                                if (detail.CSCD == "100")
                                {
                                    if (detail.DEFCNT_F > 0)
                                    {
                                        hour3Field.Text = "10:00～10:10";
                                    }
                                    else
                                    {
                                        hour3Field.Text = "9:20～9:30";
                                    }
                                }
                            }

                            //受付時間４
                            if (detail.CSCD == "105")
                            {
                                hour4Field.Text = " ";
                            }
                            else
                            {
                                if (detail.CSCD == "100")
                                {
                                    if (detail.DEFCNT_F > 0)
                                    {
                                        hour4Field.Text = "10:40～10:50";
                                    }
                                    else
                                    {
                                        hour4Field.Text = "10:20～10:30";
                                    }
                                }
                            }

                            //場所
                            placejField.Text = "(聖路加タワー３階)";

                            //終了予定時間
                            tendtimeField.Text = "終了予定時間";
                            tendcome1Field.Text = "（当日の状況により";
                            tendcome2Field.Text = "　　遅れる可能性があります。）";

                            if (detail.CSCD == "105")
                            {
                                if (Util.ConvertToString(detail.RSVGRPCD) == "20")
                                {
                                    if (Util.ConvertToString(detail.GENDER) == "1")
                                    {
                                        endhField.Text = "12:00";
                                    }
                                    else
                                    {
                                        endhField.Text = "13:30";
                                    }
                                }
                                else
                                {
                                    endhField.Text = Util.ConvertToString(detail.RPTENDTIME);
                                }

                            }
                            else
                            {
                                if (detail.OETTIME != "NONE")
                                {
                                    endhField.Text = Util.ConvertToString(detail.OETTIME);

                                }
                                else
                                {
                                    if (detail.CETTIME != "NONE")
                                    {
                                        endhField.Text = Util.ConvertToString(detail.CETTIME);
                                    }
                                    else
                                    {
                                        endhField.Text = Util.ConvertToString(detail.RPTENDTIME);
                                    }
                                }
                            }

                            //団体名
                            companyTextField.Text = Util.ConvertToString(detail.TORGNAME);

                            //コース
                            courseField.Text = Util.ConvertToString(detail.TCSNAME);

                            //受診区分
                            csldivField.Text = (Util.ConvertToString(detail.CSLDIV)).Trim();

                            //胃検査
                            var retIkensa = GetIkensa(detail.RSVNO);
                            if (retIkensa != null)
                            {
                                ikensaField.Text = Util.ConvertToString(retIkensa.IKENSA).Trim();
                            }

                            //オプションタイトル
                            toptionField.Text = "オプション";

                            var retOpt = GetSub2(detail.RSVNO, detail.CTRPTCD);

                            if ( retOpt.Count > 0)
                            {
                                //オプションコメント
                                opcomeField.Text = "オプション料金含む";

                                currentLine = 0;
                                col = 0;

                                foreach (var opt in retOpt)
                                {
                                    if ( Util.ConvertToString(opt.FREEFIELD2).Trim() != "")
                                    {
                                        optionListField.ListCell(col, currentLine).Text = Util.ConvertToString(opt.FREEFIELD2).Trim();
                                        currentLine++;

                                        if (currentLine > (optionListField.ListRows.Length - 1 ))
                                        {
                                            currentLine = 0;
                                            col++;
                                        }
                                    }
                                }
                            }

                            //負担額
                            var retKikaku = GetKikaku(detail.RSVNO);

                            if (retKikaku != null)
                            {
                                priceField.Text = Util.ConvertToString(retKikaku.KIKAKU);
                            }

                            //託児室利用
                            var retKikakuppt = GetKikakuppt(detail.RSVNO, detail.CTRPTCD);

                            if (retKikakuppt != null)
                            {
                                takuField.Text = Util.ConvertToString(retKikakuppt.SETCLASSED1);
                            }

                        }
                        else
                        {
                            //＜検査１（裏）編集＞

                            //印刷レイヤの設定（ON）
                            if (Util.ConvertToString(detail.RSVGRPCD) == "25")
                            {
                                ura1_pmLayer.VisibleAtPrint = true;
                            }
                            else
                            {
                                ura1Layer.VisibleAtPrint = true;
                            }

                            if (detail.CHESTCNT > 0)
                            {

                                ura1_nLayer.VisibleAtPrint = true;

                                if (Util.ConvertToString(detail.GENDER) == "2")
                                {
                                    ura1_nwLayer.VisibleAtPrint = true;
                                }
                            }
                            else
                            {
                                if (Util.ConvertToString(detail.GENDER) == "2")
                                {
                                    ura1_wLayer.VisibleAtPrint = true;
                                }
                            }

                        }


                    }    

                }

                //（100）1日人間ドック,（105）職員ドック英文
                if ( detail.CSCD == "100" || detail.CSCD == "105" )
                {
                    if (Util.ConvertToString(detail.FORMOUTENG ) == "1")
                    {
                        if (ura == "OFF")
                        {
                            //'<検査２（表）編集＞
                            kensa2Layer.VisibleAtPrint = true;

                            //## 喀痰検査チェック
                            ret1 = GetSub1(detail.RSVNO, detail.CTRPTCD);

                            //## 便中ピロリ菌抗原検査チェック
                            ret2 = GetBen3(detail.RSVNO);

                            if (ret1 > 0)
                            {
                                if (ret2 > 0)
                                {
                                    //送付喀痰
                                    //## □ 喀痰容器（白の袋）
                                    t1e_stanField.Text = "□ Sputum collection container(white bag)";
                                    //## □ ピロリ菌採便容器（青の袋）
                                    t1e_stan2Field.Text = "□ Stool collection container for H.Pylori(blue bag)";
                                    //持参品
                                    //## □ 喀痰容器（白の袋）：受診日2日前から当日までの3日間の
                                    t1e_zisan1Field.Text = "□ Sputum collection container(white bag):Please collect phlegm";
                                    //## 痰を採取して下さい。
                                    t1e_zisan2Field.Text = "　　for 3 days starting from 2 days before your appointment";
                                    t1e_zisan3Field.Text = "　　through to the day of your appointment.";
                                    //## □ ピロリ菌採便容器（青の袋）：受診当日または前日に便を
                                    t1e_zisan4Field.Text = "□ Stool collection container for H.Pylori(blue bag):";
                                    //## 採取して下さい。
                                    t1e_zisan5Field.Text = "　　Please take 1 stool sample on the day of or the day";
                                    t1e_zisan6Field.Text = "　　before your appointment.";
                                    //## ※検便・検尿などの検体は、受診日にお預かりします。
                                    t1e_zisan7Field.Text = " 　※ Please submit your stool or urine samples on the day of";
                                    //## 後日ご提出いただくことはできません。
                                    t1e_zisan8Field.Text = " 　　　your appointment. Samples cannot be accepted after the";
                                    t1e_zisan9Field.Text = " 　　　scheduled date.";
                                    //## □ 診察券（IDカード）：当院を受診したことのある方
                                    t1e_zisan10Field.Text = "□ Hospital ID card: if you have been seen at our hospital before";
                                    //## □ 眼鏡・コンタクト（使い捨てレンズをご使用の方は予備も
                                    t1e_zisan11Field.Text = "□ Glasses/contact lens and case (For those who use disposable";
                                    //## お持ち下さい）
                                    t1e_zisan12Field.Text = "　　contact lenses, please bring a spare set)";
                                    //## □ 保険証
                                    t1e_zisan13Field.Text = "□ Japanese National Health Insurance Card";
                                    //## □ 利用券など：ご利用の団体により必要な方
                                    t1e_zisan14Field.Text = "□ Voucher or certification: Please submit if provided by your";
                                    t1e_zisan15Field.Text = "　　contracted company or organization.";

                                }
                                else
                                {
                                    //送付喀痰
                                    //## □ 喀痰容器（白の袋）
                                    t1e_stanField.Text = "□ Sputum collection container(white bag)";
                                    t1e_stan2Field.Text = "";
                                  //持参品
                                  //## □ 喀痰容器（白の袋）：受診日2日前から当日までの3日間の
                                    t1e_zisan1Field.Text = "□ Sputum collection container(white bag):Please collect phlegm";
                                    //## 痰を採取して下さい。
                                    t1e_zisan2Field.Text = "　　for 3 days starting from 2 days before your appointment";
                                    t1e_zisan3Field.Text = "　　through to the day of your appointment.";
                                    //## ※検便・検尿などの検体は、受診日にお預かりします。
                                    t1e_zisan4Field.Text = " 　※ Please submit your stool or urine samples on the day of";
                                    //## ※後日ご提出いただくことはできません。
                                    t1e_zisan5Field.Text = " 　　　your appointment. Samples cannot be accepted after the";
                                    t1e_zisan6Field.Text = " 　　　scheduled date.";
                                    //## □ 診察券（IDカード）：当院を受診したことのある方
                                    t1e_zisan7Field.Text = "□ Hospital ID card: if you have been seen at our hospital before";
                                    //## □ 眼鏡・コンタクト（使い捨てレンズをご使用の方は予備も
                                    t1e_zisan8Field.Text = "□ Glasses/contact lens and case (For those who use disposable";
                                    //## お持ち下さい）
                                    t1e_zisan9Field.Text = "　　contact lenses, please bring a spare set)";
                                    //## □ 保険証
                                    t1e_zisan10Field.Text = "□ Japanese National Health Insurance Card";
                                    //## □ 利用券など：ご利用の団体により必要な方
                                    t1e_zisan11Field.Text = "□ Voucher or certification: Please submit if provided by your";
                                    t1e_zisan12Field.Text = "　　contracted company or organization.";
                                    t1e_zisan13Field.Text = "";
                                    t1e_zisan14Field.Text = "";
                                    t1e_zisan15Field.Text = "";
                                }
                            }
                            else
                            {
                                if (ret2 > 0)
                                {
                                    //送付喀痰
                                    //## □ ピロリ菌採便容器（青の袋）
                                    t1e_stanField.Text = "□ Stool collection container for H.Pylori(blue bag)";
                                    t1e_stan2Field.Text = "";
                                    //持参品
                                    //## □ ピロリ菌採便容器（青の袋）：受診当日または前日に便を
                                    t1e_zisan1Field.Text = "□ Stool collection container for H.Pylori(blue bag):";
                                    //## 採取して下さい。
                                    t1e_zisan2Field.Text = "　　Please take 1 stool sample on the day of or the day before";
                                    t1e_zisan3Field.Text = "　　your appointment.";
                                    //## ※検便・検尿などの検体は、受診日にお預かりします。
                                    t1e_zisan4Field.Text = " 　※ Please submit your stool or urine samples on the day of";
                                    //## 後日ご提出いただくことはできません。
                                    t1e_zisan5Field.Text = " 　　　your appointment. Samples cannot be accepted after the";
                                    t1e_zisan6Field.Text = " 　　　scheduled date.";

                                    //## □ 診察券（IDカード）：当院を受診したことのある方
                                    t1e_zisan7Field.Text = "□ Hospital ID card: if (you have been seen at our hospital before";
                                    //## □ 眼鏡・コンタクト（使い捨てレンズをご使用の方は予備も
                                    t1e_zisan8Field.Text = "□ Glasses/contact lens and case (For those who use disposable";
                                    //## お持ち下さい）
                                    t1e_zisan9Field.Text = "　　contact lenses, please bring a spare set)";
                                    //## □ 保険証
                                    t1e_zisan10Field.Text = "□ Japanese National Health Insurance Card";
                                    //## □ 利用券など：ご利用の団体により必要な方
                                    t1e_zisan11Field.Text = "□ Voucher or certification: Please submit if (provided by your";
                                    t1e_zisan12Field.Text = "　　contracted company or organization.";
                                    t1e_zisan13Field.Text = "";
                                    t1e_zisan14Field.Text = "";
                                    t1e_zisan15Field.Text = "";
                                }
                                else
                                {
                                    //持参品
                                    //## ※検便・検尿などの検体は、受診日にお預かりします。
                                    t1e_zisan1Field.Text = " 　※ Please submit your stool or urine samples on the day of";
                                    //## 後日ご提出いただくことはできません。
                                    t1e_zisan2Field.Text = " 　　　your appointment. Samples cannot be accepted after the";
                                    t1e_zisan3Field.Text = " 　　　scheduled date.";
                                    //## □ 診察券（IDカード）：当院を受診したことのある方
                                    t1e_zisan4Field.Text = "□ Hospital ID card: if you have been seen at our hospital before";
                                    //## □ 眼鏡・コンタクト（使い捨てレンズをご使用の方は予備も
                                    t1e_zisan5Field.Text = "□ Glasses/contact lens and case (For those who use disposable";
                                    //## お持ち下さい）
                                    t1e_zisan6Field.Text = "　　contact lenses, please bring a spare set)";
                                    //## □ 保険証
                                    t1e_zisan7Field.Text = "□ Japanese National Health Insurance Card";
                                    //## □ 利用券など：ご利用の団体により必要な方
                                    t1e_zisan8Field.Text = "□ Voucher or certification: Please submit if provided by your";
                                    t1e_zisan9Field.Text = "　　contracted company or organization.";
                                    t1e_zisan10Field.Text = "";
                                    t1e_zisan11Field.Text = "";
                                    t1e_zisan12Field.Text = "";
                                    t1e_zisan13Field.Text = "";
                                    t1e_zisan14Field.Text = "";
                                    t1e_zisan15Field.Text = "";
                                }

                            }

                            //受診日
                            csldateField.Text = Util.ConvertToString(detail.CSLDATE);

                            //曜日
                            yobiField.Text = Util.ConvertToString(detail.EYOBI);

                            //該当チェック１
                            if (detail.CSCD == "105")
                            {
                                ////### 職員ドック（午後）コース ###
                                if (Util.ConvertToString(detail.RSVGRPCD) == "20")
                                {
                                    ch1Field.Text = "◎";
                                }
                                else
                                {
                                    ch1Field.Text = "×";
                                    ch1Field.TextColor = Color.FromArgb(204, 204, 204);
                                    hour1Field.TextColor = Color.FromArgb(204, 204, 204);
                                }

                            }
                            else
                            {
                                if (detail.CSCD == "100")
                                {
                                    if (Util.ConvertToString(detail.GENDER) == "1")
                                    {
                                        if (Util.ConvertToString(detail.STRTIME) == "800")
                                        {
                                            ch1Field.Text = "◎";
                                        }
                                        else
                                        {
                                            ch1Field.Text = "×";
                                            ch1Field.TextColor = Color.FromArgb(204, 204, 204);
                                            hour1Field.TextColor = Color.FromArgb(204, 204, 204);
                                        }
                                    }
                                    else
                                    {
                                        if (Util.ConvertToString(detail.STRTIME) == "820")
                                        {
                                            ch1Field.Text = "◎";
                                        }
                                        else
                                        {
                                            ch1Field.Text = "×";
                                            ch1Field.TextColor = Color.FromArgb(204, 204, 204);
                                            hour1Field.TextColor = Color.FromArgb(204, 204, 204);
                                        }
                                    }
                                }
                            }

                            //該当チェック２
                            if (detail.CSCD == "105")
                            {

                                ////### 職員ドック（午後）コース ###
                                if (Util.ConvertToString(detail.RSVGRPCD) == "25")
                                {
                                    ch2Field.Text = "◎";
                                }
                                else
                                {
                                    ch2Field.Text = "×";
                                    ch2Field.TextColor = Color.FromArgb(204, 204, 204);
                                    hour2Field.TextColor = Color.FromArgb(204, 204, 204);
                                }

                            }
                            else
                            {
                                if (detail.CSCD == "100")
                                {
                                    if (Util.ConvertToString(detail.GENDER) == "1")
                                    {
                                        if (Util.ConvertToString(detail.STRTIME) == "840")
                                        {
                                            ch2Field.Text = "◎";
                                        }
                                        else
                                        {
                                            ch2Field.Text = "×";
                                            ch2Field.TextColor = Color.FromArgb(204, 204, 204);
                                            hour2Field.TextColor = Color.FromArgb(204, 204, 204);
                                        }
                                    }
                                    else
                                    {
                                        if (Util.ConvertToString(detail.STRTIME) == "900")
                                        {
                                            ch2Field.Text = "◎";
                                        }
                                        else
                                        {
                                            ch2Field.Text = "×";
                                            ch2Field.TextColor = Color.FromArgb(204, 204, 204);
                                            hour2Field.TextColor = Color.FromArgb(204, 204, 204);
                                        }
                                    }
                                }
                            }

                            //該当チェック３
                            if (detail.CSCD == "105")
                            {
                                ch3Field.Text = " ";
                            }
                            else
                            {
                                if (detail.CSCD == "100")
                                {
                                    if (Util.ConvertToString(detail.GENDER) == "1")
                                    {
                                        if (Util.ConvertToString(detail.STRTIME) == "920")
                                        {
                                            ch3Field.Text = "◎";
                                        }
                                        else
                                        {
                                            ch3Field.Text = "×";
                                            ch3Field.TextColor = Color.FromArgb(204, 204, 204);
                                            hour3Field.TextColor = Color.FromArgb(204, 204, 204);
                                        }
                                    }
                                    else
                                    {
                                        if (Util.ConvertToString(detail.STRTIME) == "1000")
                                        {
                                            ch3Field.Text = "◎";
                                        }
                                        else
                                        {
                                            ch3Field.Text = "×";
                                            ch3Field.TextColor = Color.FromArgb(204, 204, 204);
                                            hour3Field.TextColor = Color.FromArgb(204, 204, 204);
                                        }
                                    }
                                }
                            }

                            //該当チェック４
                            if (detail.CSCD == "105")
                            {
                                ch4Field.Text = " ";
                            }
                            else
                            {
                                if (detail.CSCD == "100")
                                {
                                    if (Util.ConvertToString(detail.GENDER) == "1")
                                    {
                                        if (Util.ConvertToString(detail.STRTIME) == "1020")
                                        {
                                            ch4Field.Text = "◎";
                                        }
                                        else
                                        {
                                            ch4Field.Text = "×";
                                            ch4Field.TextColor = Color.FromArgb(204, 204, 204);
                                            hour4Field.TextColor = Color.FromArgb(204, 204, 204);
                                        }
                                    }
                                    else
                                    {
                                        if (Util.ConvertToString(detail.STRTIME) == "1040")
                                        {
                                            ch4Field.Text = "◎";
                                        }
                                        else
                                        {
                                            ch4Field.Text = "×";
                                            ch4Field.TextColor = Color.FromArgb(204, 204, 204);
                                            hour4Field.TextColor = Color.FromArgb(204, 204, 204);
                                        }
                                    }
                                }
                            }

                            //受付時間１
                            if (detail.CSCD == "105")
                            {
                                if (Util.ConvertToString(detail.GENDER) == "1")
                                {
                                    hour1Field.Text = "8:00～8:10";
                                }
                                else
                                {
                                    hour1Field.Text = "8:20～8:30";
                                }
                            }
                            else
                            {
                                if (detail.CSCD == "100")
                                {
                                    if (detail.DEFCNT_F > 0)
                                    {
                                        hour1Field.Text = "8:20～8:30";
                                    }
                                    else
                                    {
                                        hour1Field.Text = "8:00～8:10";
                                    }
                                }
                            }

                            //受付時間２
                            if (detail.CSCD == "105")
                            {
                                ////### 職員ドック（午後）コース ###
                                hour2Field.Text = "13:30～13:40";
                            }
                            else
                            {
                                if (detail.CSCD == "100")
                                {
                                    if (detail.DEFCNT_F > 0)
                                    {
                                        hour2Field.Text = "9:00～9:10";
                                    }
                                    else
                                    {
                                        hour2Field.Text = "8:40～8:50";
                                    }
                                }
                            }

                            //受付時間３
                            if (detail.CSCD == "105")
                            {
                                hour3Field.Text = " ";
                            }
                            else
                            {
                                if (detail.CSCD == "100")
                                {
                                    if (detail.DEFCNT_F > 0)
                                    {
                                        hour3Field.Text = "10:00～10:10";
                                    }
                                    else
                                    {
                                        hour3Field.Text = "9:20～9:30";
                                    }
                                }
                            }

                            //受付時間４
                            if (detail.CSCD == "105")
                            {
                                hour4Field.Text = " ";
                            }
                            else
                            {
                                if (detail.CSCD == "100")
                                {
                                    if (detail.DEFCNT_F > 0)
                                    {
                                        hour4Field.Text = "10:40～10:50";
                                    }
                                    else
                                    {
                                        hour4Field.Text = "10:20～10:30";
                                    }
                                }
                            }

                            //場所
                            placeeField.Text = "(St. Luke's Tower 3F)";

                            //終了予定時間
                            if (detail.CSCD == "105")
                            {

                                if (Util.ConvertToString(detail.RSVGRPCD) == "20")
                                {
                                    if (Util.ConvertToString(detail.GENDER) == "1")
                                    {
                                        endhField.Text = "12:00";
                                    }
                                    else
                                    {
                                        endhField.Text = "13:30";
                                    }
                                }
                                else
                                {
                                    endhField.Text = Util.ConvertToString(detail.RPTENDTIME);
                                }

                            }
                            else
                            {

                                ////#### オプション > 健診コース > 群別終了時間表示 ###
                                if (detail.OETTIME != "NONE")
                                {
                                    endhField.Text = Util.ConvertToString(detail.OETTIME);

                                }
                                else
                                {
                                    if (detail.CETTIME != "NONE")
                                    {
                                        endhField.Text = Util.ConvertToString(detail.CETTIME);
                                    }
                                    else {
                                        endhField.Text = Util.ConvertToString(detail.RPTENDTIME);
                                    }
                                }
                            }

                            //団体名
                            companyTextField.Text = Util.ConvertToString(detail.TORGNAME);

                            //コース
                            courseField.Text = Util.ConvertToString(detail.TCSNAME);

                            //受診区分
                            csldivField.Text = Util.ConvertToString(detail.CSLDIVE).Trim();

                            //胃検査
                            var ikensaE = GetIkensaE(detail.RSVNO);
                            if (ikensaE != null)
                            {
                                ikensaField.Text = Util.ConvertToString(ikensaE.IKENSAE);
                            }

                            //オプションタイトル
                            toptionField.Text = "Options";

                            var retTOpt = GetSub2(detail.RSVNO, detail.CTRPTCD);
                            if (retTOpt.Count > 0)
                            {

                                currentLine = 0;
                                col = 0;

                                //### オプション検査印刷欄2列表記、長い名称のオプション検査を左側に印刷するように ###
                                foreach (var opt in retTOpt)
                                {
                                    if (Util.ConvertToString(opt.FREEFIELD3).Trim() != "")
                                    {
                                        option_eListField.ListCell(col, currentLine).Text = Util.ConvertToString(opt.FREEFIELD3).Trim();
                                        currentLine++;

                                        if (currentLine > (option_eListField.ListRows.Length - 1))
                                        {
                                            currentLine = 0;
                                            col = col++;
                                        }
                                    }
                                }
                            }


                            //負担額
                            var retKikaku = GetKikaku(detail.RSVNO);
                            if (retKikaku != null)
                            {
                                priceField.Text = Util.ConvertToString(retKikaku.KIKAKU);
                            }

                            //コメント
                            //### 個人受診者のリピータ割引コメントはフルオプションや後日GFコースの受診者には出さないように ##########
                            if (detail.ORGCD1 == "XXXXX")
                            {
                                if (detail.CSLDIVCD != "CSLDIV016" && detail.CSLDIVCD != "CSLDIV017") {
                                    t2e_comeTextField.Text = Util.ConvertToString(detail.SENDECOMMENT);
                                }
                            }
                            else
                            {
                                t2e_comeTextField.Text = Util.ConvertToString(detail.SENDECOMMENT);
                            }

                        }
                        else
                        {
                            //<検査２英裏編集＞
                            //レイヤの設定（ON）
                            if (Util.ConvertToString(detail.RSVGRPCD) == "25")
                            {
                                ura2_pmLayer.VisibleAtPrint = true;
                            }
                            else
                            {
                                ura2Layer.VisibleAtPrint = true;
                            }

                        }
                    }
                }

                //（110）企業健診,（155）小児医療センター
                if (detail.CSCD == "110" || detail.CSCD == "155")
                {
                    if (Util.ConvertToString(detail.FORMOUTENG )!= "1")
                    {
                        if (ura == "OFF")
                        {
                            //<検査３（表）編集＞
                            //印刷レイヤの設定（ON）
                            kensa3Layer.VisibleAtPrint = true;

                            //送付品,持参品
                            var retBen = GetBen(detail.RSVNO);

                            if (retBen != null)
                            {
                                if (retBen.BEN != "")
                                {
                                    t3_souhu1Field.Text = "□ 検便容器（緑の袋）";
                                    t3_souhu2Field.Text = "□ 検尿容器（茶色の袋）";
                                    t3_zisan1Field.Text = "□ 検便容器（緑の袋）：受診日の4日前から2回分の便を";
                                    t3_zisan2Field.Text = "　 　　　　　　　　　　採取して下さい。";
                                    t3_zisan3Field.Text = "□ 検尿容器（茶色の袋）：受診当日の朝に最初の尿をおとり";
                                    t3_zisan4Field.Text = "　 　　　　　　　　　　　下さい。";
                                    t3_zisan5Field.Text = "    ※検便・検尿などの検体は、受診日にお預かりします。";
                                    t3_zisan6Field.Text = "       後日ご提出いただくことはできません。";
                                    t3_zisan7Field.Text = "□ 診察券（IDカード）：当院を受診したことのある方";
                                    t3_zisan8Field.Text = "□ 眼鏡・コンタクト（使い捨てレンズをご使用の方は予備も";
                                    t3_zisan9Field.Text = "    お持ち下さい）";
                                    t3_zisan10Field.Text = "□ 保険証";
                                    t3_zisan11Field.Text = "□ 利用券など：ご利用の団体により必要な方";
                                }
                            }
                            else
                            {
                                t3_souhu1Field.Text = "□ 検尿容器（茶色の袋）";
                                t3_zisan1Field.Text = "□ 検尿容器（茶色の袋）：受診当日の朝に最初の尿をおとり";
                                t3_zisan2Field.Text = "　 　　　　　　　　　　　下さい。";
                                t3_zisan3Field.Text = "    ※検尿などの検体は、受診日にお預かりします。";
                                t3_zisan4Field.Text = "       後日ご提出いただくことはできません。";
                                t3_zisan5Field.Text = "□ 診察券（IDカード）：当院を受診したことのある方";
                                t3_zisan6Field.Text = "□ 眼鏡・コンタクト（使い捨てレンズをご使用の方は予備も";
                                t3_zisan7Field.Text = "    お持ち下さい）";
                                t3_zisan8Field.Text = "□ 保険証";
                                t3_zisan9Field.Text = "□ 利用券など：ご利用の団体により必要な方";
                            }

                            //コメント
                            t3_comeTextField.Text = Util.ConvertToString(detail.SENDCOMMENT);

                            //受診日
                            csldateField.Text = Util.ConvertToString(detail.CSLDATE);

                            //曜日
                            yobiField.Text = Util.ConvertToString(detail.JYOBI);

                            if (detail.CSCD == "155")
                            {
                                ch1Field.Text = "◎";

                                if (Util.ConvertToString(detail.gender) == "1")
                                {
                                    hour1Field.Text = "8:00～8:10";
                                }
                                else
                                {
                                    hour1Field.Text = "8:20～8:30";
                                }
                            }
                            else
                            {
                                //該当チェック１
                                if (Util.ConvertToString(detail.STRTIME) == "940")
                                {
                                    ch1Field.Text = "◎";
                                }
                                else
                                {
                                    ch1Field.Text = "×";
                                    ch1Field.TextColor = Color.FromArgb(204, 204, 204);
                                    hour1Field.TextColor = Color.FromArgb(204, 204, 204);
                                }

                                //該当チェック２
                                if (Util.ConvertToString(detail.STRTIME) == "1345")
                                {
                                    ch2Field.Text = "◎";
                                }
                                else
                                {
                                    ch2Field.Text = "×";
                                    ch2Field.TextColor = Color.FromArgb(204, 204, 204);
                                    hour2Field.TextColor = Color.FromArgb(204, 204, 204);
                                }

                                //受付時間１
                                hour1Field.Text = "9:40～9:50";

                                //受付時間２
                                hour2Field.Text = "13:45～13:55";
                            }

                            //場所
                            placejField.Text = "(聖路加タワー３階)";

                            //終了予定時間
                            tendtimeField.Text = "終了予定時間";
                            tendcome1Field.Text = "（当日の状況により";
                            tendcome2Field.Text = "　　遅れる可能性があります。）";

                            if (detail.CSCD == "155")
                            {
                                if (Util.ConvertToString(detail.gender) == "1")
                                {
                                    endhField.Text = "12:00";
                                }
                                else
                                {
                                    endhField.Text = "13:30";
                                }
                            }
                            else
                            {
                                endhField.Text = Util.ConvertToString(detail.RPTENDTIME);
                            }

                            //団体名
                            companyTextField.Text = Util.ConvertToString(detail.TORGNAME);

                            //コース
                            courseField.Text = Util.ConvertToString(detail.TCSNAME);

                            //受診区分
                            csldivField.Text = Util.ConvertToString(detail.CSLDIV).Trim();

                            //胃検査
                            var retIkensa = GetIkensa(detail.RSVNO);
                            if (retIkensa != null)
                            {
                                ikensaField.Text = Util.ConvertToString(retIkensa.IKENSA).Trim();
                            }

                            //オプションタイトル
                            toptionField.Text = "オプション";

                            var retTopt = GetSub2(detail.RSVNO, detail.CTRPTCD);
                            if (retTopt.Count > 0)
                            {
                                //オプションコメント
                                opcomeField.Text = "オプション料金含む";

                                currentLine = 0;
                                col = 0;

                                foreach (var opt in retTopt)
                                {
                                    if (Util.ConvertToString(opt.FREEFIELD2).Trim() != "")
                                    {
                                        optionListField.ListCell(col, currentLine).Text = Util.ConvertToString(opt.FREEFIELD2).Trim();
                                        currentLine = currentLine++;

                                        if (currentLine > (optionListField.ListRows.Length - 1))
                                        {
                                            currentLine = 0;
                                            col++;
                                        }
                                    }

                                }
                            }

                            //負担額
                            var retKikaku = GetKikaku(detail.RSVNO);
                            if (retKikaku != null)
                            {
                                priceField.Text = Util.ConvertToString(retKikaku.KIKAKU);
                            }

                            //託児室利用
                            var retKikakuppt = GetKikakuppt(detail.RSVNO, detail.CTRPTCD);
                            if (retKikakuppt != null)
                            {
                                takuField.Text = Util.ConvertToString(retKikakuppt.SETCLASSED1);
                            }

                        }
                        else
                        {
                            //＜検査３（裏）編集＞
                            //印刷レイヤの設定（ON）
                            ura3Layer.VisibleAtPrint = true;

                            if (detail.CSCD == "155" || Util.ConvertToString(detail.RSVGRPCD) == "50")
                            {
                                ura3_50Layer.VisibleAtPrint = true;
                                if (detail.CHESTCNT > 0)
                                {
                                    ura3_n51Layer.VisibleAtPrint = true;
                                    if (Util.ConvertToString(detail.GENDER) == "2")
                                    {
                                        ura3_nwLayer.VisibleAtPrint = true;
                                    }
                                }
                                else
                                {
                                    if (Util.ConvertToString(detail.GENDER) == "2")
                                    {
                                        ura3_wLayer.VisibleAtPrint = true;
                                    }
                                }
                            }

                            if (Util.ConvertToString(detail.RSVGRPCD) == "51")
                            {
                                if (detail.CHESTCNT > 0)
                                {
                                    ura3_n51Layer.VisibleAtPrint = true;
                                    if (Util.ConvertToString(detail.GENDER) == "2")
                                    {
                                        ura3_wLayer.VisibleAtPrint = true;
                                    }
                                }
                                else
                                {
                                    ura3_51Layer.VisibleAtPrint = true;
                                    if (Util.ConvertToString(detail.GENDER) == "2")
                                    {
                                        ura3_wLayer.VisibleAtPrint = true;
                                    }
                                }
                            }
                        }
                    }
                }

                //（110）企業健診,（155）小児医療センター英文
                if (detail.CSCD == "110" || detail.CSCD == "155")
                {
                    if (Util.ConvertToString(detail.FORMOUTENG ) == "1")
                    {
                        if (ura == "OFF")
                        {
                            //<検査４（表）編集＞
                            //印刷レイヤの設定
                            kensa4Layer.VisibleAtPrint = true;
                            //## 裏面注意事項表示切替
                            if (Util.ConvertToString(detail.RSVGRPCD) == "51")
                            {
                                kensa4_51Layer.VisibleAtPrint = true;
                            }
                            else
                            {
                                kensa4_50Layer.VisibleAtPrint = true;
                            }

                            //## 検便検査チェック
                            var retBen = GetBen(detail.RSVNO);

                            if (retBen != null)
                            {

                                if (retBen.BEN != "")
                                {
                                    //## □ 検便容器（緑の袋）
                                    t2e_souhu1Field.Text = "□ Stool collection container (green bag)";
                                    //## □ 検尿容器（茶色の袋）
                                    t2e_souhu2Field.Text = "□ Urine collection container (brown bag)";

                                    //## □ 検便容器（緑の袋）：受診日の4日前から2回分の便を
                                    t2e_zisan1Field.Text = "□ Stool collection container (green bag) :";
                                    //## 　 　　　　　　　　　　採取して下さい。
                                    t2e_zisan2Field.Text = "　　Please take 2 stool samples on two different days, within";
                                    t2e_zisan3Field.Text = "　　4 days of your appointment.";

                                    //## □ 検尿容器（茶色の袋）：受診当日の朝に最初の尿をおとり
                                    t2e_zisan4Field.Text = "□ Urine collection container (brown bag) :";
                                    //## 　 　　　　　　　　　　　下さい。
                                    t2e_zisan5Field.Text = "　　Please take a urine sample (first morning urine) on the day";
                                    t2e_zisan6Field.Text = "　　of your appointment.";
                                    //##     ※検便・検尿などの検体は、受診日にお預かりします。
                                    t2e_zisan7Field.Text = " 　※ Please submit your stool or urine samples on the day of";
                                    //##        後日ご提出いただくことはできません。
                                    t2e_zisan8Field.Text = " 　　　your appointment. Samples cannot be accepted after the";
                                    t2e_zisan9Field.Text = " 　　　scheduled date.";
                                    //## □ 診察券（IDカード）：当院を受診したことのある方
                                    t2e_zisan10Field.Text = "□ Hospital ID card : if you have been seen at our hospital before";
                                    //## □ 眼鏡・コンタクト（使い捨てレンズをご使用の方は予備も
                                    t2e_zisan11Field.Text = "□ Glasses/contact lens and case (For those who use disposable";
                                    //##     お持ち下さい）
                                    t2e_zisan12Field.Text = "　　contact lenses, please bring a spare set)";
                                    //## □ 保険証
                                    t2e_zisan13Field.Text = "□ Japanese National Health Insurance Card";
                                    //## □ 利用券など：ご利用の団体により必要な方
                                    t2e_zisan14Field.Text = "□ Voucher or certification : Please submit if provided by your";
                                    t2e_zisan15Field.Text = "　　contracted company or organization.";
                                }
                            }
                            else
                            {
                                //## □ 検尿容器（茶色の袋）
                                t2e_souhu1Field.Text = "□ Urine collection container (brown bag)";
                                t2e_souhu2Field.Text = "";

                                //## □ 検尿容器（茶色の袋）：受診当日の朝に最初の尿をおとり
                                t2e_zisan1Field.Text = "□ Urine collection container (brown bag) :";
                                //## 　 　　　　　　　　　　　下さい。
                                t2e_zisan2Field.Text = "　　Please take a urine sample (first morning urine) on the day";
                                t2e_zisan3Field.Text = "　　of your appointment.";
                                //##     ※検尿などの検体は、受診日にお預かりします。
                                t2e_zisan4Field.Text = " 　※ Please submit your a urine sample on the day of";
                                //##        後日ご提出いただくことはできません。
                                t2e_zisan5Field.Text = " 　　　your appointment. Samples cannot be accepted after the";
                                t2e_zisan6Field.Text = " 　　　scheduled date.";
                                //## □ 診察券（IDカード）：当院を受診したことのある方
                                t2e_zisan7Field.Text = "□ Hospital ID card : if you have been seen at our hospital before";
                                //## □ 眼鏡・コンタクト（使い捨てレンズをご使用の方は予備も
                                t2e_zisan8Field.Text = "□ Glasses/contact lens and case (For those who use disposable";
                                //##     お持ち下さい）
                                t2e_zisan9Field.Text = "　　contact lenses, please bring a spare set)";
                                //## □ 保険証
                                t2e_zisan10Field.Text = "□ Japanese National Health Insurance Card";
                                //## □ 利用券など：ご利用の団体により必要な方
                                t2e_zisan11Field.Text = "□ Voucher or certification : Please submit if provided by your";
                                t2e_zisan12Field.Text = "　　contracted company or organization.";
                                t2e_zisan13Field.Text = "";
                                t2e_zisan14Field.Text = "";
                                t2e_zisan15Field.Text = "";
                            }

                            //コメント
                            t2e_comeTextField.Text = Util.ConvertToString(detail.SENDCOMMENT);

                            //受診日
                            csldateField.Text = Util.ConvertToString(detail.CSLDATE);

                            //曜日
                            yobiField.Text = Util.ConvertToString(detail.EYOBI);

                            //該当チェック１
                            if (detail.CSCD == "155")
                            {
                                ch1Field.Text = "◎";

                                if (Util.ConvertToString(detail.GENDER) == "1")
                                {
                                    hour1Field.Text = "8:00～8:10";
                                }
                                else
                                {
                                    hour1Field.Text = "8:20～8:30";
                                }
                            }
                            else
                            {
                                if (Util.ConvertToString(detail.STRTIME) == "940")
                                {
                                    ch1Field.Text = "◎";
                                }
                                else
                                {
                                    ch1Field.Text = "×";
                                    ch1Field.TextColor = Color.FromArgb(204, 204, 204);
                                    hour1Field.TextColor = Color.FromArgb(204, 204, 204);
                                }

                                //該当チェック２
                                if (Util.ConvertToString(detail.STRTIME) == "1345")
                                {
                                    ch2Field.Text = "◎";
                                }
                                else
                                {
                                    ch2Field.Text = "×";
                                    ch2Field.TextColor = Color.FromArgb(204, 204, 204);
                                    hour2Field.TextColor = Color.FromArgb(204, 204, 204);
                                }

                                //受付時間１
                                hour1Field.Text = "9:40～9:50";

                                //受付時間２
                                hour2Field.Text = "13:45～13:55";

                            }

                            //場所
                            placeeField.Text = "(St. Luke's Tower 3F)";

                            //終了予定時間
                            if (detail.CSCD == "155")
                            {
                                if (Util.ConvertToString(detail.GENDER) == "1")
                                {
                                    endhField.Text = "12:00";
                                }
                                else
                                {
                                    endhField.Text = "13:30";
                                }
                            }
                            else
                            {
                                endhField.Text = Util.ConvertToString(detail.RPTENDTIME);
                            }


                            //団体名
                            companyTextField.Text = Util.ConvertToString(detail.TORGNAME);

                            //コース
                            courseField.Text = Util.ConvertToString(detail.TCSNAME);

                            //受診区分
                            csldivField.Text = Util.ConvertToString(detail.CSLDIVE).Trim();

                            //胃検査
                            var retIkensaE = GetIkensaE(detail.RSVNO);
                            if (retIkensaE != null)
                            {
                                ikensaField.Text = Util.ConvertToString(retIkensaE.IKENSAE).Trim();
                            }


                            //オプションタイトル
                            toptionField.Text = "Options";
                            //## オプション検査取得
                            var retTOpt = GetSub2(detail.RSVNO, detail.CTRPTCD);

                            if (retTOpt.Count > 0)
                            {

                                currentLine = 0;
                                col = 0;

                                foreach (var opt in retTOpt)
                                {

                                    if ( Util.ConvertToString(opt.FREEFIELD3).Trim() != "") {

                                        option_eListField.ListCell(col, currentLine).Text = Util.ConvertToString(opt.FREEFIELD3).Trim();
                                        currentLine++;

                                        if (currentLine > (option_eListField.ListRows.Length - 1))
                                        {
                                            currentLine = 0;
                                            col++;
                                        }
                                    }


                                }

                            }

                            //負担額
                            var retKikaku = GetKikaku(detail.RSVNO);
                            if (retKikaku != null)
                            {
                                priceField.Text = Util.ConvertToString(retKikaku.KIKAKU);
                            }

                        }
                        else
                        {
                            //<検査４英裏編集＞
                            //レイヤの設定（ON）
                            ura4Layer.VisibleAtPrint = true;

                            //## 企業健診（午前）、小児医療センターコース
                            if (detail.CSCD == "155" || Util.ConvertToString(detail.RSVGRPCD) == "50")
                            {
                                ura4_50Layer.VisibleAtPrint = true;
                            }

                            //## 企業健診（午後）
                            if (Util.ConvertToString(detail.RSVGRPCD) == "51")
                            {
                                ura4_51Layer.VisibleAtPrint = true;
                                if (Util.ConvertToString(detail.GENDER) == "2")
                                {
                                    ura4_wLayer.VisibleAtPrint = true;
                                }
                            }

                        }
                    }

                }

                //深夜勤務者健診
                if (detail.CSCD == "223")
                {
                    if (ura == "OFF")
                    {
                        //<検査９（表）編集＞
                        //印刷レイヤの設定（ON）
                        kensa9Layer.VisibleAtPrint = true;

                        //受診日
                        csldateField.Text = Util.ConvertToString(detail.CSLDATE);
                        //曜日
                        yobiField.Text = Util.ConvertToString(detail.JYOBI);
                        //チェック１
                        ch1Field.Text = "◎";

                        //受付時間１
                        hour1Field.Text = "13:45～13:55";

                        //場所
                        placejField.Text = "(聖路加タワー３階)";

                        //団体名
                        companyTextField.Text = Util.ConvertToString(detail.TORGNAME);

                        //コース
                        courseField.Text = Util.ConvertToString(detail.TCSNAME);

                        //負担額
                        var retKikaku = GetKikaku(detail.RSVNO);
                        if (retKikaku != null)
                        {
                            priceField.Text = Util.ConvertToString(retKikaku.KIKAKU);
                        }

                    }
                    else
                    {
                        //<検査９（裏）編集＞
                        //印刷レイヤの設定（ON）
                        ura9Layer.VisibleAtPrint = true;
                    }
                }

                //## 225：看大学生健診
                if (detail.CSCD == "225")
                {
                    if ( ura == "OFF" )
                    {
                        //<検査９（表）編集＞
                        //印刷レイヤの設定（ON）
                        kensa11Layer.VisibleAtPrint = true;

                        //受診日
                        csldateField.Text = Util.ConvertToString(detail.CSLDATE);
                        //曜日
                        yobiField.Text = Util.ConvertToString(detail.JYOBI);
                        //チェック１
                        ch1Field.Text = "◎";

                        //受付時間１
                        hour1Field.Text = "13:45～13:55";

                        //場所
                        placejField.Text = "(聖路加タワー３階)";

                        //団体名
                        companyTextField.Text = Util.ConvertToString(detail.TORGNAME);

                        //コース
                        courseField.Text = Util.ConvertToString(detail.TCSNAME);

                        //負担額
                        var retKikaku = GetKikaku(detail.RSVNO);
                        if (retKikaku != null)
                        {
                            priceField.Text = Util.ConvertToString(retKikaku.KIKAKU);
                        }

                    }
                }

                //## 133：レジデンス簡易健診
                if (detail.CSCD == "133")
                {
                    if (ura == "OFF")
                    {
                        //<検査１０（表）編集＞
                        //印刷レイヤの設定（ON）
                        kensa10Layer.VisibleAtPrint = true;

                        //受診日
                        csldateField.Text = Util.ConvertToString(detail.CSLDATE);

                        //曜日
                        yobiField.Text = Util.ConvertToString(detail.JYOBI);

                        //受付時間１
                        hour1Field.Text = "14:00";

                        //場所
                        placejField.Text = "(聖路加タワー３階)";

                        //団体名
                        companyTextField.Text = Util.ConvertToString(detail.TORGNAME);

                        //コース
                        courseField.Text = Util.ConvertToString(detail.TCSNAME);

                        //負担額
                        var retKikaku = GetKikaku(detail.RSVNO);
                        if (retKikaku != null)
                        {
                            priceField.Text = Util.ConvertToString(retKikaku.KIKAKU);
                        }

                    }
                }

                pageNo++;

                // ドキュメントの出力
                PrintOut(cnForm);

                //裏を出力したら次データ読み込む
                if (ura == "ON")
                {
                    ura = "OFF";
                    dataPos++;
                }
                else
                {
                    //印刷の場合は帳票出力日を更新する
                    if (queryParams["printMode"] == "0")
                    {
                        int retMod = UpdateConsult(detail.RSVNO);
                    }
                    ura = "ON";
                }

            }

            //印刷の場合はFREEを更新する
            if ( pageNo > 0 && queryParams["printMode"] == "0")
            {
                int retFree = UpdateFree(queryParams["enddate"]);
            }

        }

        /// <summary>
        /// 喀痰検査
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ctrptCd">契約パターンコード</param>
        /// <returns>検索結果（1：有, -1：無</returns>
        private dynamic GetSub1(int rsvNo, int ctrptCd)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    count(fr.freefield1) as dis 
                from
                    consult_o co
                    , ctrpt_opt cpo
                    , free fr 
                where
                    co.rsvno = :rsvno
                    and co.ctrptcd = :ctrptcd
                    and cpo.ctrptcd = co.ctrptcd 
                    and cpo.optcd = co.optcd 
                    and cpo.optbranchno = co.optbranchno 
                    and fr.freecd like 'LST000021%' 
                    and fr.freefield1 = cpo.setclasscd 
                    and fr.freefield1 in ('006', '008', '105', '110', '117')
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                ctrptcd = ctrptCd
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? -1 : (int)result.DIS;
        }

        /// <summary>
        /// オプション検査
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ctrptCd">契約パターンコード</param>
        /// <returns>検索結果（1：有, -1：無</returns>
        private dynamic GetSub2(int rsvNo, int ctrptCd)
        {
            // SQLステートメント定義
            string sql = @"
                select distinct
                    nvl(free.freefield2, ' ') as freefield2
                    , nvl(free.freefield3, ' ') as freefield3
                    , decode( 
                        free.freefield6
                        , null
                        , 999
                        , to_number(trim(free.freefield6))
                    ) 
                from
                    consult_o
                    , ctrpt_opt
                    , free 
                where
                    consult_o.rsvno = :rsvno
                    and consult_o.ctrptcd = :ctrptcd
                    and ctrpt_opt.ctrptcd = consult_o.ctrptcd 
                    and ctrpt_opt.optcd = consult_o.optcd 
                    and ctrpt_opt.optbranchno = consult_o.optbranchno 
                    and free.freecd like 'LST000021%' 
                    and free.freefield1 = ctrpt_opt.setclasscd 
                order by
                    3
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                ctrptcd = ctrptCd
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 検便
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>取得リストデータ</returns>
        private dynamic GetBen(int rsvNo)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    free.freefield3 as ben 
                from
                    consultitemlist
                    , grp_i
                    , free 
                where
                    consultitemlist.rsvno = :rsvno
                    and consultitemlist.cancelflg = :cancelflg  
                    and grp_i.grpcd = 'X503' 
                    and grp_i.itemcd = consultitemlist.itemcd 
                    and free.freecd = 'LST0000222' 
                    and free.freefield1 = grp_i.grpcd 
                    and free.freefield2 = grp_i.seq
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                cancelflg = ConsultCancel.Used
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 検便３（便中ピロリ菌抗原検査項目チェック）
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>検索結果（-1：無 以外：件数）</returns>
        private dynamic GetBen3(int rsvNo)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    count(sysdate) as ben3 
                from
                    consultitemlist v_csil
                    , grp_r gr 
                where
                    v_csil.rsvno = :rsvno
                    and v_csil.cancelflg = :cancelflg  
                    and gr.grpcd in ('K0897') 
                    and gr.itemcd = v_csil.itemcd
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                cancelflg = ConsultCancel.Used
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? -1 : (int)result.BEN3;
        }

        /// <summary>
        /// 胃検査
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>取得リストデータ</returns>
        private dynamic GetIkensa(int rsvNo)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    fr.freefield3 as ikensa 
                from
                    consultitemlist v_csil
                    , grp_i gi
                    , free fr 
                where
                    v_csil.rsvno = :rsvno
                    and v_csil.cancelflg = :cancelflg  
                    and gi.grpcd = 'X502' 
                    and gi.itemcd = v_csil.itemcd 
                    and fr.freecd like 'LST000022%' 
                    and fr.freefield1 = gi.grpcd 
                    and fr.freefield2 = gi.seq
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                cancelflg = ConsultCancel.Used
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 胃検査（英語）
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>取得リストデータ</returns>
        private dynamic GetIkensaE(int rsvNo)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    fr.freefield4 as ikensae 
                from
                    consultitemlist v_csil
                    , grp_i gi
                    , free fr 
                where
                    v_csil.rsvno = :rsvno
                    and v_csil.cancelflg = :cancelflg  
                    and gi.grpcd = 'X502' 
                    and gi.itemcd = v_csil.itemcd 
                    and fr.freecd like 'LST000022%' 
                    and fr.freefield1 = gi.grpcd 
                    and fr.freefield2 = gi.seq
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                cancelflg = ConsultCancel.Used
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 負担金額
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>取得リストデータ</returns>
        private dynamic GetKikaku(int rsvNo)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    nvl( 
                        sum((price + editprice + taxprice + edittax))
                        , 0
                    ) as kikaku 
                from
                    consult_m 
                where
                    rsvno = :rsvno
                    and orgcd1 = 'XXXXX' 
                    and orgcd2 = 'XXXXX'

                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 託児室利用
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ctrptCd">契約パターンコード</param>
        /// <returns>取得リストデータ</returns>
        private dynamic GetKikakuppt(int rsvNo, int ctrptCd)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    decode(ab.setclasscd, null, ' ', '託児室利用料含む') setclassed1 
                from
                    ( 
                        select
                            sc.setclasscd setclasscd 
                        from
                            consult_o co
                            , ctrpt_opt cpo
                            , setclass sc 
                        where
                            co.rsvno = :rsvno
                            and co.ctrptcd = :ctrptcd
                            and cpo.ctrptcd = co.ctrptcd 
                            and cpo.optcd = co.optcd 
                            and cpo.optbranchno = co.optbranchno 
                            and sc.setclasscd = cpo.setclasscd 
                            and sc.setclasscd in ('019', '020', '021', '022') 
                        union 
                        select
                            null setclasscd 
                        from
                            setclass 
                        order by
                            setclasscd asc
                    ) ab 
                where
                    rownum = 1
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                ctrptcd = ctrptCd
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 帳票出力日を更新
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>更新成功：True　　更新失敗：False</returns>
        private dynamic UpdateConsult(int rsvNo)
        {
            // SQLステートメント定義
            string sql = @"
                update consult 
                set
                    formprintdate = sysdate 
                where
                    rsvno = :rsvno
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo
            };

            // SQLステートメント実行
            return connection.Execute(sql, sqlParam);
        }

        /// <summary>
        /// ＦＲＥＥを更新
        /// </summary>
        /// <param name="endYMD">終了日</param>
        /// <returns>更新成功：True　　更新失敗：False</returns>
        private dynamic UpdateFree(string endYMD)
        {
            // SQLステートメント定義
            string sql = @"
                update free 
                set
                    freedate = :enddate 
                where
                    freecd = 'RSVINTERVAL' 
                    and freeclasscd = 'RSV' 
                    and :enddate > freedate
                ";

            // パラメータセット
            var sqlParam = new
            {
                enddate = endYMD
            };

            // SQLステートメント実行
            return connection.Execute(sql, sqlParam);
        }

    }
}
