using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.ReportCore;
using Hos.CnDraw;
using Hos.CnDraw.Object;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    /// <summary>
    /// 契約団体調査票生成クラス
    /// </summary>
    public class CompanyconductCreator : PdfCreator
    {

        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "000500";

        /// <summary>
        /// コースコード
        /// </summary>
        private const string cscd_D001 = "100"; //1日ドック選択時コース１
        private const string cscd_D002 = "105"; //1日ドック選択時コース２
        private const string cscd_K001 = "110"; //企業健診選択時コース

        /// <summary>
        /// 受診情報ノート分類コード
        /// </summary>
        private const string PUBNOTE_DIVCD1 = "100";    //注意事項
        private const string PUBNOTE_DIVCD2 = "800";    //団体請求関連情報

        /// <summary>
        /// パラメタ
        /// </summary>
        private const int MAX_COUNT_ORG = 10;    //団体コード最大設定数

        /// <summary>
        /// 定義体フィールド名１ページ目
        /// </summary>
        private const string c1sday = "startday";
        private const string c1page = "page";
        private const string c1orgcd = "orgcd";
        private const string c1orgkana = "orgkana";
        private const string c1orgryaku = "orgryaku";
        private const string c1orgseisiki = "orgseisiki";
        private const string c1orgeigo = "orgeigo";
        private const string c1siyou = "orgsiyou";
        private const string c1syubetu = "orgsyubetu";
        private const string c1keiyaku = "keiyakuday";
        private const string c1PZIP = "orgyubin";
        private const string c1PZIP2 = "orgyubin2";
        private const string c1ADD = "orgadres";
        private const string c1ADD2 = "orgadres2";
        private const string c1mail = "orgmail";
        private const string c1mail2 = "orgmail2";
        private const string c1busyo = "orgbusyo";
        private const string c1busyo2 = "orgbusyo2";
        private const string c1kana = "orgfurigana";
        private const string c1kana2 = "orgfurigana2";
        private const string c1tantou = "orgtantou";
        private const string c1tantou2 = "orgtantou2";
        private const string c1tel = "orgtel1";
        private const string c1tel2 = "orgtel2";
        private const string c1tel3 = "orgtel3";
        private const string c1tel4 = "orgtel4";
        private const string c1naisen = "orgnaisen";
        private const string c1naisen2 = "orgnaisen2";
        private const string c1fax = "orgfax";
        private const string c1fax2 = "orgfax2";
        private const string c1futan2 = "futan2";
        private const string c1futan3 = "futan3";
        private const string c1coment = "come1";
        private const string c1coment1 = "come12";
        private const string c1coment2 = "come2";
        private const string c1coment3 = "come22";
        private const string c1orname2 = "orname2";
        private const string c1endday = "endday";
        private const string c1printdate = "printdate";

        /// <summary>
        /// 定義体フィールド名２ページ目
        /// </summary>
        private const string c2title = "title";
        private const string c2stday = "startday";
        private const string c2orgname = "orgname";
        private const string c2suborgname = "suborgname";
        private const string c2addorgname = "addorgname";
        private const string c2limitrate = "limitrate";
        private const string c2limitprice = "limitprice";
        private const string c2limittaxflg = "limittaxflg";
        private const string c2page = "page";
        private const string c2name = "name";
        private const string c2taisyou = "taisyou";
        private const string c2kubun = "kubun";
        private const string c2seibetu = "seibetu";
        private const string c2age = "age";
        private const string c2limitamt = "limitamt";
        private const string c2madoguti = "madoguti";
        private const string c2tmadoguti = "tmadoguti";
        private const string c2dantai = "dantai";
        private const string c2tdantai = "tdantai";
        private const string c2futan2 = "futan2";
        private const string c2tfutan2 = "tfutan2";
        private const string c2futan3 = "futan3";
        private const string c2tfutan3 = "tfutan3";
        private const string c2goukei = "goukei";
        private const string c2tgoukei = "tgoukei";
        private const string c2endday = "endday";
        private const string c2printdate = "printdate";

        /// <summary>
        /// 定義体フィールド名３ページ目
        /// </summary>
        private const string c3strday = "startday";
        private const string c3page = "page";
        private const string c3list = "list";
        private const string c3orgname = "orgname";
        private const string c3endday = "endday";
        private const string c3printdate = "printdate";

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            //基準日チェック
            if (!DateTime.TryParse(queryParams["csldate"], out DateTime strDate))
            {
                messages.Add("基準日が正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// 契約団体調査票データを読み込む
        /// </summary>
        /// <returns>契約団体調査票データ</returns>
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

            // SQLステートメント定義
            string sql = @"
                select
                    org.orgcd1 || org.orgcd2 as orgcd
                    , org.orgcd1 || '-' || org.orgcd2 as orgcdedit
                    , org.orgkname as orgkname
                    , org.orgname as orgname
                    , org.orgsname as orgsname
                    , org.orgename as orgename
                    , org.delflg as delflg
                    , org.orgdivcd as orgdivcd
                    , free.freefield1 as orgdivname
                    , org.ctrptdate as ctrptdate
                    , org.sendcomment as sendcomment
                    , org.sendecomment as sendecomment
                    , org.inscheck as icheck
                    , org.insbring as ibri
                    , org.insreport as irep
                    , org.billins as bili
                    , org.billcsldiv as bilc
                    , org.reptcsldiv as repc
                    , org.billempno as bile
                    , org.ticketdiv as tdiv
                    , org.ticketaddbill as tbil
                    , org.postcard as poscd
                    , org.ticketcentercall as tic
                    , org.ticketpercall as ticp
                    , orgaddr.zipcd as zipcd1
                    , ( 
                        select
                            pref.prefname 
                        from
                            pref 
                        where
                            pref.prefcd = orgaddr.prefcd
                    ) as prefname1
                    , orgaddr.cityname as cityname1
                    , orgaddr.address1 as address11
                    , orgaddr.address2 as address12
                    , orgaddr.email as email1
                    , orgaddr.chargepost as chargepost1
                    , orgaddr.chargekname as chargekname1
                    , orgaddr.chargename as chargename1
                    , orgaddr.directtel as directtel1
                    , orgaddr.tel as tel1
                    , orgaddr.extension as extension1
                    , orgaddr.fax as fax1
                    , orgaddr2.orgname as orgname2
                    , orgaddr2.zipcd as zipcd2
                    , ( 
                        select
                            pref.prefname 
                        from
                            pref 
                        where
                            pref.prefcd = orgaddr2.prefcd
                    ) as prefname2
                    , orgaddr2.cityname as cityname2
                    , orgaddr2.address1 as address21
                    , orgaddr2.address2 as address22
                    , orgaddr2.email as email2
                    , orgaddr2.chargepost as chargepost2
                    , orgaddr2.chargekname as chargekname2
                    , orgaddr2.chargename as chargename2
                    , orgaddr2.directtel as directtel2
                    , orgaddr2.tel as tel2
                    , orgaddr2.extension as extension2
                    , orgaddr2.fax as fax2
                    , ctrmng.cscd as cscd
                    , ctrmng.ctrptcd as ctrptcd
                    , ( 
                        select
                            ctrpt_org.orgcd1 || '-' || ctrpt_org.orgcd2 
                        from
                            ctrpt_org 
                        where
                            ctrpt_org.ctrptcd = ctrmng.ctrptcd 
                            and ctrpt_org.apdiv = '2' 
                            and ctrpt_org.seq = '3'
                    ) as futan2cd
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
                    ) as futan2name
                    , ( 
                        select
                            ctrpt_org.orgcd1 || '-' || ctrpt_org.orgcd2 
                        from
                            ctrpt_org 
                        where
                            ctrpt_org.ctrptcd = ctrmng.ctrptcd 
                            and ctrpt_org.apdiv = '2' 
                            and ctrpt_org.seq = '4'
                    ) as futan3cd
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
                    ) as futan3name
                    , ctrpt.csname as csname
                    , ctrpt.cslmethod as cslmethod
                    , ctrpt.strdate as strdate
                    , ctrpt.enddate as enddate
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
                    , orgaddr
                    , orgaddr orgaddr2
                    , ctrmng
                    , ctrpt
                    , free 
                where
                    org.orgcd1 = orgaddr.orgcd1(+) 
                    and org.orgcd2 = orgaddr.orgcd2(+) 
                    and '1' = orgaddr.addrdiv(+) 
                    and org.orgcd1 = orgaddr2.orgcd1(+) 
                    and org.orgcd2 = orgaddr2.orgcd2(+) 
                    and org.billaddress = orgaddr2.addrdiv(+) 
                    and ctrpt.strdate <= :frdate 
                    and ctrpt.enddate >= :frdate 
                    and ctrpt.ctrptcd = ctrmng.ctrptcd 
                    and org.orgcd1 = ctrmng.orgcd1 
                    and org.orgcd2 = ctrmng.orgcd2 
                    and org.orgdivcd = free.freecd(+) 
                ";

            //コース指定
            string csKbn_Sql = "";
            string csKbn = queryParams["csKbn"].Trim();

            switch( csKbn)
            {
                case "0":
                    csKbn_Sql = ":free_cscd_d1, :free_cscd_d2, :free_cscd_k1";
                    break;

                case "1" :
                    csKbn_Sql = ":free_cscd_d1, :free_cscd_d2";
                    break;

                case "2":
                    csKbn_Sql = ":free_cscd_k1";
                    break;
            }
            if ( !string.IsNullOrEmpty(csKbn_Sql) )
            {
                sql += @"
                    and ctrmng.cscd in (" + csKbn_Sql + ")";
            }

            //団体指定
            if (orgcd_list.Count > 0)
            {
                sql += @"
                    and org.orgcd1 || org.orgcd2 in ( '" + String.Join("','", orgcd_list) + "') ";
            }

            sql += @"
                order by
                    org.orgcd1
                    , org.orgcd2
                    , ctrmng.cscd
                ";

            // パラメータセット
            var sqlParam = new
            {
                frdate = queryParams["csldate"],

                free_cscd_d1 = cscd_D001,
                free_cscd_d2 = cscd_D002,
                free_cscd_k1 = cscd_K001
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }
        
        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">契約団体調査票データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {

            CnForm cnForm = cnForms[0];
            CnForm cnForm2 = cnForms[1];
            CnForm cnForm3 = cnForms[2];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;     //１ページ目
            CnObjects cnObjects2 = cnForm2.CnObjects;   //２ページ目
            CnObjects cnObjects3 = cnForm3.CnObjects;   //３ページ目

            // フォームの各項目を変数にセット
            //【１ページ目】
            var c1sdayField = (CnDataField)cnObjects[c1sday];
            var c1pageField = (CnDataField)cnObjects[c1page];
            var c1orgcdField = (CnDataField)cnObjects[c1orgcd];
            var c1orgkanaField = (CnDataField)cnObjects[c1orgkana];
            var c1orgryakuField = (CnDataField)cnObjects[c1orgryaku];
            var c1orgseisikiField = (CnDataField)cnObjects[c1orgseisiki];
            var c1orgeigoField = (CnDataField)cnObjects[c1orgeigo];
            var c1siyouField = (CnDataField)cnObjects[c1siyou];
            var c1syubetuField = (CnDataField)cnObjects[c1syubetu];
            var c1keiyakuField = (CnDataField)cnObjects[c1keiyaku];
            var c1PZIPField = (CnDataField)cnObjects[c1PZIP];
            var c1PZIP2Field = (CnDataField)cnObjects[c1PZIP2];
            var c1ADDField = (CnDataField)cnObjects[c1ADD];
            var c1ADD2Field = (CnDataField)cnObjects[c1ADD2];
            var c1mailField = (CnDataField)cnObjects[c1mail];
            var c1mail2Field = (CnDataField)cnObjects[c1mail2];
            var c1busyoField = (CnDataField)cnObjects[c1busyo];
            var c1busyo2Field = (CnDataField)cnObjects[c1busyo2];
            var c1kanaField = (CnDataField)cnObjects[c1kana];
            var c1kana2Field = (CnDataField)cnObjects[c1kana2];
            var c1tantouField = (CnDataField)cnObjects[c1tantou];
            var c1tantou2Field = (CnDataField)cnObjects[c1tantou2];
            var c1telField = (CnDataField)cnObjects[c1tel];
            var c1tel2Field = (CnDataField)cnObjects[c1tel2];
            var c1tel3Field = (CnDataField)cnObjects[c1tel3];
            var c1tel4Field = (CnDataField)cnObjects[c1tel4];
            var c1naisenField = (CnDataField)cnObjects[c1naisen];
            var c1naisen2Field = (CnDataField)cnObjects[c1naisen2];
            var c1faxField = (CnDataField)cnObjects[c1fax];
            var c1fax2Field = (CnDataField)cnObjects[c1fax2];
            var c1futan2Field = (CnDataField)cnObjects[c1futan2];
            var c1futan3Field = (CnDataField)cnObjects[c1futan3];
            var c1comentField = (CnDataField)cnObjects[c1coment];
            var c1coment1Field = (CnDataField)cnObjects[c1coment1];
            var c1coment2Field = (CnDataField)cnObjects[c1coment2];
            var c1coment3Field = (CnDataField)cnObjects[c1coment3];
            var c1orname2Field = (CnDataField)cnObjects[c1orname2];
            var c1enddayField = (CnDataField)cnObjects[c1endday];
            var c1printdateField = (CnDataField)cnObjects[c1printdate];

            //【２ページ目】
            var c2titleField = (CnDataField)cnObjects2[c2title];
            var c2stdayField = (CnDataField)cnObjects2[c2stday];
            var c2enddayField = (CnDataField)cnObjects2[c2endday];
            var c2orgnameField = (CnDataField)cnObjects2[c2orgname];
            var c2suborgnameField = (CnDataField)cnObjects2[c2suborgname];
            var c2addorgnameField = (CnDataField)cnObjects2[c2addorgname];
            var c2limitrateField = (CnDataField)cnObjects2[c2limitrate];
            var c2limitpriceField = (CnDataField)cnObjects2[c2limitprice];
            var c2limittaxflgField = (CnDataField)cnObjects2[c2limittaxflg];
            var c2pageField = (CnDataField)cnObjects2[c2page];
            var c2nameListField = (CnListField)cnObjects2[c2name];
            var c2taisyouListField = (CnListField)cnObjects2[c2taisyou];
            var c2kubunListField = (CnListField)cnObjects2[c2kubun];
            var c2seibetuListField = (CnListField)cnObjects2[c2seibetu];
            var c2ageListField = (CnListField)cnObjects2[c2age];
            var c2limitamtListField = (CnListField)cnObjects2[c2limitamt];
            var c2madogutiListField = (CnListField)cnObjects2[c2madoguti];
            var c2tmadogutiListField = (CnListField)cnObjects2[c2tmadoguti];
            var c2dantaiListField = (CnListField)cnObjects2[c2dantai];
            var c2tdantaiListField = (CnListField)cnObjects2[c2tdantai];
            var c2futan2ListField = (CnListField)cnObjects2[c2futan2];
            var c2tfutan2ListField = (CnListField)cnObjects2[c2tfutan2];
            var c2futan3ListField = (CnListField)cnObjects2[c2futan3];
            var c2tfutan3ListField = (CnListField)cnObjects2[c2tfutan3];
            var c2goukeiListField = (CnListField)cnObjects2[c2goukei];
            var c2tgoukeiListField = (CnListField)cnObjects2[c2tgoukei];
            var c2printdateField = (CnDataField)cnObjects2[c2printdate];

            //【３ページ目】
            var c3strdayField = (CnDataField)cnObjects3[c3strday];
            var c3pageField = (CnDataField)cnObjects3[c3page];
            var c3ListField = (CnListField)cnObjects3[c3list];
            var c3orgnameField = (CnDataField)cnObjects3[c3orgname];
            var c3enddayField = (CnDataField)cnObjects3[c3endday];
            var c3printdateField = (CnDataField)cnObjects3[c3printdate];

            string sysdate = DateTime.Today.ToShortDateString();

            int pageNo = 0;

            string work = "";       //ワーク用
            string work2 = "";       //ワーク用
            string workOut = "";    //ワーク用
            string workAdd1 = "";   //ワーク用
            string workAdd2 = "";   //ワーク用

            int mojiCnt = 0;
            int maxCnt = 0;

            short currentRow = 0;
            short currentCol = 0;

            // ページ内の項目に値をセット
            foreach ( var detail in data )
            {

                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                //ページクリア
                pageNo = 0;
                
                // ▼１ページ目作成-------

                //ヘッダ出力
                c1sdayField.Text = Util.ConvertToString(detail.STRDATE).Trim();
                c1enddayField.Text = Util.ConvertToString(detail.ENDDATE).Trim();
                c1printdateField.Text = Util.ConvertToString(detail.PRINTDATE).Trim();

                //ページ出力
                pageNo++;
                c1pageField.Text = pageNo.ToString();

                //団体コード、団体名称
                c1orgcdField.Text = Util.ConvertToString(detail.ORGCDEDIT).Trim();
                c1orgkanaField.Text = Util.ConvertToString(detail.ORGKNAME).Trim();
                c1orgryakuField.Text = Util.ConvertToString(detail.ORGSNAME).Trim();
                c1orgseisikiField.Text = Util.ConvertToString(detail.ORGNAME).Trim();
                c1orgeigoField.Text = Util.ConvertToString(detail.ORGENAME).Trim();

                //使用状態
                string used = Util.ConvertToString(detail.DELFLG).Trim();

                work = "";
                switch(used)
                {
                    case "0":
                        work = "使用中①";
                        break;
                    case "1":
                        work = "未使用";
                        break;
                    case "2":
                        work = "使用中②";
                        break;
                    case "3":
                        work = "長期未使用";
                        break;
                }
                c1siyouField.Text = work;

                //団体種別
                c1syubetuField.Text = Util.ConvertToString(detail.ORGDIVNAME).Trim();

                //契約日付
                if ( !string.IsNullOrEmpty(Util.ConvertToString(detail.CTRPTDATE)))
                {
                    c1keiyakuField.Text = detail.CTRPTDATE.ToString("yyyy/MM/dd");
                }

                //【住所１】【住所２　請求書送付先】
                //郵便番号
                work = Util.ConvertToString(detail.ZIPCD1).Trim();
                workAdd1 = "";
                workAdd2 = "";
                if ( ! string.IsNullOrEmpty(work))
                {
                    if ( work.Length > 3)
                    {
                        workAdd1 = "〒" + work.Substring(0,3);
                        workAdd2 = "-" + work.Substring(3);
                    }
                    else
                    {
                        workAdd1 = "〒" + work;
                        workAdd2 = "";
                    }
                }
                else
                {
                    workAdd1 = "〒";
                    workAdd2 = "";
                }
                c1PZIPField.Text = workAdd1 + workAdd2;

                work = Util.ConvertToString(detail.ZIPCD2).Trim();
                workAdd1 = "";
                workAdd2 = "";
                if (!string.IsNullOrEmpty(work))
                {
                    if (work.Length > 3)
                    {
                        workAdd1 = "〒" + work.Substring(0, 3);
                        workAdd2 = "-" + work.Substring(3);
                    }
                    else
                    {
                        workAdd1 = "〒" + work;
                        workAdd2 = "";
                    }
                }
                else
                {
                    workAdd1 = "〒";
                    workAdd2 = "";
                }
                c1PZIP2Field.Text = workAdd1 + workAdd2;

                //住所
                work = Util.ConvertToString(detail.PREFNAME1).Trim()
                            + Util.ConvertToString(detail.CITYNAME1).Trim()
                            + Util.ConvertToString(detail.ADDRESS11).Trim()
                            + Util.ConvertToString(detail.ADDRESS12).Trim();
                c1ADDField.Text = work;

                work = Util.ConvertToString(detail.PREFNAME2).Trim()
                            + Util.ConvertToString(detail.CITYNAME2).Trim()
                            + Util.ConvertToString(detail.ADDRESS21).Trim()
                            + Util.ConvertToString(detail.ADDRESS22).Trim();
                c1ADD2Field.Text = work;

                //メール
                c1mailField.Text = Util.ConvertToString(detail.EMAIL1).Trim();
                c1mail2Field.Text = Util.ConvertToString(detail.EMAIL2).Trim();

                //担当部署
                c1busyoField.Text = Util.ConvertToString(detail.CHARGEPOST1).Trim();
                c1busyo2Field.Text = Util.ConvertToString(detail.CHARGEPOST2).Trim();

                //担当名
                c1kanaField.Text = Util.ConvertToString(detail.CHARGEKNAME1).Trim();
                c1kana2Field.Text = Util.ConvertToString(detail.CHARGEKNAME2).Trim();

                c1tantouField.Text = Util.ConvertToString(detail.CHARGENAME1).Trim();
                c1tantou2Field.Text = Util.ConvertToString(detail.CHARGENAME2).Trim();

                //電話番号、内線、ＦＡＸ
                c1telField.Text = Util.ConvertToString(detail.DIRECTTEL1).Trim();
                c1tel2Field.Text = Util.ConvertToString(detail.TEL1).Trim();
                c1tel3Field.Text = Util.ConvertToString(detail.DIRECTTEL2).Trim();
                c1tel4Field.Text = Util.ConvertToString(detail.TEL2).Trim();
                c1naisenField.Text = Util.ConvertToString(detail.EXTENSION1).Trim();
                c1naisen2Field.Text = Util.ConvertToString(detail.EXTENSION2).Trim();
                c1faxField.Text = Util.ConvertToString(detail.FAX1).Trim();
                c1fax2Field.Text = Util.ConvertToString(detail.FAX2).Trim();

                //請求書送付先　団体名
                c1orname2Field.Text = Util.ConvertToString(detail.ORGNAME2).Trim();

                //【請求関係】
                workOut = "";
                work = Util.ConvertToString(detail.FUTAN2CD).Trim();

                if( ! string.IsNullOrEmpty(work))
                {
                    workOut = "負担元2" + "  " + work + "   "
                                + Util.ConvertToString(detail.FUTAN2NAME).Trim()
                                + "   " + Util.ConvertToString(detail.CSNAME).Trim();
                }
                c1futan2Field.Text = workOut;

                workOut = "";
                work = Util.ConvertToString(detail.FUTAN3CD).Trim();

                if (!string.IsNullOrEmpty(work))
                {
                    workOut = "負担元3" + "  " + work + "   "
                                + Util.ConvertToString(detail.FUTAN3NAME).Trim()
                                + "   " + Util.ConvertToString(detail.CSNAME).Trim();
                }
                c1futan3Field.Text = workOut;

                //コメント編集
                work = Util.ConvertToString(detail.SENDCOMMENT).Trim();
                workAdd1 = "";
                workAdd2 = "";
                if ( !string.IsNullOrEmpty(work) )
                {
                    maxCnt = 0;
                    mojiCnt = work.Length;
                    for (int cnt = 1; cnt <= mojiCnt; cnt++)
                    {
                        //次の文字のバイト数取得
                        int byteCnt = WebHains.LenB(work.Substring(cnt - 1, 1));
                        maxCnt += byteCnt;
                        //150バイト以上の場合は
                        if (maxCnt > 150)
                        {
                            workAdd2 += work.Substring(cnt - 1, 1);
                        }
                        else
                        {
                            workAdd1 += work.Substring(cnt - 1, 1);
                        }
                    }
                }
                c1comentField.Text = workAdd1;
                c1coment1Field.Text = workAdd2;

                work = Util.ConvertToString(detail.SENDECOMMENT).Trim();
                workAdd1 = "";
                workAdd2 = "";
                if (!string.IsNullOrEmpty(work))
                {
                    maxCnt = 0;
                    mojiCnt = work.Length;
                    for (int cnt = 1; cnt <= mojiCnt; cnt++)
                    {
                        //次の文字のバイト数取得
                        int byteCnt = WebHains.LenB(work.Substring(cnt - 1, 1));
                        maxCnt += byteCnt;
                        //150バイト以上の場合は
                        if (maxCnt > 150)
                        {
                            workAdd2 += work.Substring(cnt - 1, 1);
                        }
                        else
                        {
                            workAdd1 += work.Substring(cnt - 1, 1);
                        }
                    }
                }
                c1coment2Field.Text = workAdd1;
                c1coment3Field.Text = workAdd2;

                // ドキュメントの出力（１ページ目）
                PrintOut(cnForm);

                // ▼２ページ目作成-------
                int.TryParse( Util.ConvertToString(detail.CTRPTCD), out int ctrptCd);
                string cscd = Util.ConvertToString(detail.CSCD).Trim();

                //契約パターン情報取得
                var retCtrpt = GetCtrptData(ctrptCd, cscd);

                if (retCtrpt.Count > 0)
                {
                    // 編集行を特定する
                    int rowCount = 0;

                    currentCol = 0;
                    currentRow = 0;

                    //明細印字
                    foreach ( var ctrpt in retCtrpt)
                    {
                        //行設定
                        currentRow = (short)(rowCount % c2nameListField.ListRows.Length);

                        //種類
                        c2nameListField.ListCell(currentCol, currentRow).Text =  Util.ConvertToString(ctrpt.ONAME).Trim();

                        //受診対象
                        work = Util.ConvertToString(ctrpt.OPTG).Trim();
                        if (work == "1")
                        {
                            c2taisyouListField.ListCell(currentCol, currentRow).Text = "任意";
                        }
                        else
                        {
                            c2taisyouListField.ListCell(currentCol, currentRow).Text = "";
                        }

                        //受診区分
                        c2kubunListField.ListCell(currentCol, currentRow).Text = Util.ConvertToString(ctrpt.FREE1).Trim();

                        //性別
                        work = Util.ConvertToString(ctrpt.OPGEN).Trim();
                        if (work == "1")
                        {
                            c2seibetuListField.ListCell(currentCol, currentRow).Text = "男性";
                        }
                        else if (work == "2")
                        {
                            c2seibetuListField.ListCell(currentCol, currentRow).Text = "女性";
                        }
                        else
                        {
                            c2seibetuListField.ListCell(currentCol, currentRow).Text = "";
                        }

                        //年齢
                        string ctrptCd_p = Util.ConvertToString(ctrpt.OPTCD).Trim();
                        string optSet = Util.ConvertToString(ctrpt.OPTSET).Trim();
                        string opCd = Util.ConvertToString(ctrpt.OPCD).Trim();
                        string opBrcd = Util.ConvertToString(ctrpt.OPBRCD).Trim();

                        var retAge = GetAgeData(ctrptCd_p, optSet, opCd, opBrcd);

                        if (retAge.Count > 0)
                        {

                            workAdd1 = "";

                            foreach ( var ageData in retAge)
                            {
                                int.TryParse(Util.ConvertToString(ageData.OPSAGE), out int workStart);    //開始年齢
                                int.TryParse(Util.ConvertToString(ageData.OPEAGE), out int workEnd);      //終了年齢

                                if ( workStart == 0 )
                                {
                                    //開始年齢が0
                                    if ( (workEnd < 100) && (workEnd != 0) )
                                    {
                                        //終了年齢が100歳未満　かつ　0以外
                                        workAdd1 += " " + workEnd.ToString() + "歳以下";
                                    }
                                }
                                else if (workStart >= 99)
                                {
                                    //99歳以上
                                }
                                else
                                {
                                    //開始年齢が1歳以上99歳以下
                                    if (workEnd < 100)
                                    {
                                        //終了年齢が100歳未満
                                        if (workEnd == 0)
                                        {
                                            //終了年齢が0
                                            workAdd1 += " " + workStart + "歳以上";
                                        }
                                        else
                                        {
                                            //終了年齢が1以上100歳未満
                                            workAdd1 += " " + workStart + "歳" + "～" + workEnd + "歳";
                                        }
                                    }
                                    else if (workEnd > 99)
                                    {
                                        //終了年齢が100歳以上
                                        workAdd1 += " " + workStart + "歳以上";
                                    }
                                }

                            }

                            //年齢
                            c2ageListField.ListCell(currentCol, currentRow).Text = workAdd1;
                        }

                        //限度額対象
                        work = "";
                        decimal.TryParse(Util.ConvertToString(detail.LIMITRATE), out decimal wkLimitRate);
                        decimal.TryParse(Util.ConvertToString(ctrpt.EXCEPTLIMIT), out decimal wkExceptLimitRate);

                        if ( (wkLimitRate > 0 ) && (wkExceptLimitRate == 0) ) 
                        {
                            work = "○";
                        }
                        else
                        {
                            work = "";
                        }
                        c2limitamtListField.ListCell(currentCol, currentRow).Text = work;

                        //合計クリア
                        decimal goukei = 0;
                        decimal tgoukei = 0;

                        //窓口
                        work = "";
                        decimal.TryParse(Util.ConvertToString(ctrpt.MADOGUTI), out decimal wkMadoguti);
                        decimal.TryParse(Util.ConvertToString(ctrpt.TMADOGUTI), out decimal wkTMadoguti);

                        if (wkMadoguti > 0)
                        {
                            goukei += wkMadoguti;
                            work = "\\" + wkMadoguti.ToString("#,###");
                        }
                        else
                        {
                            work = "";
                        }
                        c2madogutiListField.ListCell(currentCol, currentRow).Text = work;

                        if (wkTMadoguti > 0)
                        {
                            tgoukei += wkTMadoguti;
                            work = "\\" + wkTMadoguti.ToString("#,###");
                        }
                        else
                        {
                            work = "";
                        }
                        c2tmadogutiListField.ListCell(currentCol, currentRow).Text = work;

                        //団体
                        work = "";
                        decimal.TryParse(Util.ConvertToString(ctrpt.DANPRICE), out decimal wkDanprice);
                        decimal.TryParse(Util.ConvertToString(ctrpt.TDANPRICE), out decimal wkTDanprice);

                        if (wkDanprice > 0)
                        {
                            goukei += wkDanprice;
                            work = "\\" + wkDanprice.ToString("#,###");
                        }
                        else
                        {
                            work = "";
                        }
                        c2dantaiListField.ListCell(currentCol, currentRow).Text = work;

                        if (wkTDanprice > 0)
                        {
                            tgoukei += wkTDanprice;
                            work = "\\" + wkTDanprice.ToString("#,###");
                        }
                        else
                        {
                            work = "";
                        }
                        c2tdantaiListField.ListCell(currentCol, currentRow).Text = work;

                        //負担２
                        work = "";
                        decimal.TryParse(Util.ConvertToString(ctrpt.FUTAN2), out decimal wkFutan2);
                        decimal.TryParse(Util.ConvertToString(ctrpt.TFUTAN2), out decimal wkTFutan2);

                        if (wkFutan2 > 0)
                        {
                            goukei += wkFutan2;
                            work = "\\" + wkFutan2.ToString("#,###");
                        }
                        else
                        {
                            work = "";
                        }
                        c2futan2ListField.ListCell(currentCol, currentRow).Text = work;

                        if (wkTFutan2 > 0)
                        {
                            tgoukei += wkTFutan2;
                            work = "\\" + wkTFutan2.ToString("#,###");
                        }
                        else
                        {
                            work = "";
                        }
                        c2tfutan2ListField.ListCell(currentCol, currentRow).Text = work;

                        //負担３
                        work = "";
                        decimal.TryParse(Util.ConvertToString(ctrpt.FUTAN3), out decimal wkFutan3);
                        decimal.TryParse(Util.ConvertToString(ctrpt.TFUTAN3), out decimal wkTFutan3);

                        if (wkFutan3 > 0)
                        {
                            goukei += wkFutan3;
                            work = "\\" + wkFutan3.ToString("#,###");
                        }
                        else
                        {
                            work = "";
                        }
                        c2futan3ListField.ListCell(currentCol, currentRow).Text = work;

                        if (wkTFutan3 > 0)
                        {
                            tgoukei += wkTFutan3;
                            work = "\\" + wkTFutan3.ToString("#,###");
                        }
                        else
                        {
                            work = "";
                        }
                        c2tfutan3ListField.ListCell(currentCol, currentRow).Text = work;

                        //合計
                        work = "";
                        if ( goukei > 0 )
                        {
                            work = "\\" + goukei.ToString("#,###");
                        }
                        c2goukeiListField.ListCell(currentCol, currentRow).Text = work;

                        work = "";
                        if (tgoukei > 0)
                        {
                            work = "\\" + tgoukei.ToString("#,###");
                        }
                        c2tgoukeiListField.ListCell(currentCol, currentRow).Text = work;


                        if (currentRow == c2nameListField.ListRows.Length - 1 || rowCount == retCtrpt.Count - 1)
                        {
                            //最大行超過かレコード数最大値の場合、ヘッダ部を印字し出力
                            work = "";

                            //コース名設定
                            switch (cscd)
                            {
                                case cscd_D001:
                                    work = "一日人間ドック";
                                    break;
                                case cscd_D002:
                                    work = "職員定期健康診断（ドック）";
                                    break;

                                case cscd_K001:
                                    work = "企業健診";
                                    break;
                                default:
                                    work = "一日人間ドック";
                                    break;
                            }
                            c2titleField.Text = work;

                            //契約期間
                            c2stdayField.Text = Util.ConvertToString(detail.STRDATE).Trim();
                            c2enddayField.Text = Util.ConvertToString(detail.ENDDATE).Trim();

                            //印刷日時
                            c2printdateField.Text = Util.ConvertToString(detail.PRINTDATE).Trim();

                            //契約団体名
                            c2orgnameField.Text = Util.ConvertToString(detail.ORGNAME).Trim();

                            //限度額減算対象負担元
                            c2suborgnameField.Text = Util.ConvertToString(detail.SUBORGNAME).Trim();

                            //減算した金額の負担元
                            c2addorgnameField.Text = Util.ConvertToString(detail.ADDORGNAME).Trim();

                            //限度率
                            c2limitrateField.Text = Util.ConvertToString(detail.LIMITRATE).Trim();

                            //上限金額
                            decimal.TryParse(Util.ConvertToString(detail.LIMITPRICE), out decimal limitPrice);

                            work = "";
                            if (limitPrice > 0)
                            {
                                work = limitPrice.ToString("#,###");
                            }
                            else
                            {
                                work = Util.ConvertToString(detail.LIMITPRICE).Trim();
                            }
                            c2limitpriceField.Text = work;

                            //限度額消費税フラグ
                            c2limittaxflgField.Text = Util.ConvertToString(detail.LIMITTAXFLG).Trim();

                            //ページ出力
                            pageNo++;
                            c2pageField.Text = pageNo.ToString();

                            // ドキュメントの出力（２ページ目レイアウト）
                            PrintOut(cnForm2);

                        }

                        // 行カウントをインクリメント
                        rowCount++;

                    }

                }

                // ▼３ページ目作成-------
                //ヘッダ情報
                c3strdayField.Text = Util.ConvertToString(detail.STRDATE).Trim();
                c3enddayField.Text = Util.ConvertToString(detail.ENDDATE).Trim();
                c3printdateField.Text = Util.ConvertToString(detail.PRINTDATE).Trim();
                c3orgnameField.Text = Util.ConvertToString(detail.ORGNAME).Trim();

                //ページ出力
                pageNo++;
                c3pageField.Text = pageNo.ToString();

                currentRow = 0;
                currentCol = 0;

                //生検
                c3ListField.ListCell(currentCol, currentRow).Text = "<< 生検 >>";
                currentRow++;
                c3ListField.ListCell(currentCol, currentRow).Text = "　・自己負担有";
                currentRow++;
                c3ListField.ListCell(currentCol, currentRow).Text = "　・本人負担分企業請求";
                currentRow++;
                c3ListField.ListCell(currentCol, currentRow).Text = "　・全額健保請求";
                currentRow++;

                //申し込み方法
                switch (Util.ConvertToString(detail.CSLMETHOD).Trim())
                {
                    case "1":
                        c3ListField.ListCell(currentCol, currentRow).Text = "<< 申し込み方法 >>";
                        currentRow++;
                        c3ListField.ListCell(currentCol, currentRow).Text = "　・本人　ＴＥＬ（全部）";
                        currentRow++;
                        break;
                    case "2":
                        c3ListField.ListCell(currentCol, currentRow).Text = "<< 申し込み方法 >>";
                        currentRow++;
                        c3ListField.ListCell(currentCol, currentRow).Text = "　・本人　ＴＥＬ（ＦＡＸ有）";
                        currentRow++;
                        break;
                    case "3":
                        c3ListField.ListCell(currentCol, currentRow).Text = "<< 申し込み方法 >>";
                        currentRow++;
                        c3ListField.ListCell(currentCol, currentRow).Text = "　・本人　Ｅ－ＭＡＩＬ";
                        currentRow++;
                        break;
                    case "4":
                        c3ListField.ListCell(currentCol, currentRow).Text = "<< 申し込み方法 >>";
                        currentRow++;
                        c3ListField.ListCell(currentCol, currentRow).Text = "　・担当者　ＴＥＬ（全部）";
                        currentRow++;
                        break;
                    case "5":
                        c3ListField.ListCell(currentCol, currentRow).Text = "<< 申し込み方法 >>";
                        currentRow++;
                        c3ListField.ListCell(currentCol, currentRow).Text = "　・担当者　仮枠（ＦＡＸ）";
                        currentRow++;
                        break;
                    case "6":
                        c3ListField.ListCell(currentCol, currentRow).Text = "<< 申し込み方法 >>";
                        currentRow++;
                        c3ListField.ListCell(currentCol, currentRow).Text = "　・担当者　リスト";
                        currentRow++;
                        break;
                    case "7":
                        c3ListField.ListCell(currentCol, currentRow).Text = "<< 申し込み方法 >>";
                        currentRow++;
                        c3ListField.ListCell(currentCol, currentRow).Text = "　・担当者　Ｅ－ＭＡＩＬ";
                        currentRow++;
                        break;
                    default:
                        break;
                }

                //保険証記号／番号
                work = Util.ConvertToString(detail.ICHECK).Trim();
                work2 = "0";
                if (work == "1")
                {
                    c3ListField.ListCell(currentCol, currentRow).Text = "<< 保険証記号　／　番号 >>";
                    currentRow++;

                    c3ListField.ListCell(currentCol, currentRow).Text = "　・予約時確認";
                    currentRow++;

                    work2 = "1";
                }

                work = Util.ConvertToString(detail.IBRI).Trim();
                if (work == "1")
                {
                    if ( work2 != "1")
                    {
                        c3ListField.ListCell(currentCol, currentRow).Text = "<<保険証記号　／　番号 >>";
                        currentRow++;
                        work2 = "1";
                    }

                    c3ListField.ListCell(currentCol, currentRow).Text = "　・受付時確認（当日持参）";
                    currentRow++;
                }

                work = Util.ConvertToString(detail.IREP).Trim();
                if (work == "1")
                {
                    if (work2 != "1")
                    {
                        c3ListField.ListCell(currentCol, currentRow).Text = "<< 保険証記号　／　番号 >>";
                        currentRow++;
                        work2 = "1";
                    }

                    c3ListField.ListCell(currentCol, currentRow).Text = "　・成績表記載";
                    currentRow++;
                }

                work = Util.ConvertToString(detail.BILI).Trim();
                if (work == "1")
                {
                    if (work2 != "1")
                    {
                        c3ListField.ListCell(currentCol, currentRow).Text = "<< 保険証記号　／　番号 >>";
                        currentRow++;
                        work2 = "1";
                    }

                    c3ListField.ListCell(currentCol, currentRow).Text = "　・請求書記載";
                    currentRow++;
                }

                //本人・家族
                work = Util.ConvertToString(detail.BILC).Trim();
                work2 = "0";

                if (work == "1")
                {
                    c3ListField.ListCell(currentCol, currentRow).Text = "<< 本人・家族 >>";
                    currentRow++;

                    c3ListField.ListCell(currentCol, currentRow).Text = "　・請求書に出力";
                    currentRow++;

                    work2 = "1";
                }

                work = Util.ConvertToString(detail.REPC).Trim();
                if (work == "1")
                {
                    if (work2 != "1")
                    {
                        c3ListField.ListCell(currentCol, currentRow).Text = "<< 本人・家族 >>";
                        currentRow++;
                        work2 = "1";
                    }

                    c3ListField.ListCell(currentCol, currentRow).Text = "　・成績書に出力";
                    currentRow++;
                }

                //社員番号
                work = Util.ConvertToString(detail.BILE).Trim();
                work2 = "0";
                if (work == "1")
                {
                    c3ListField.ListCell(currentCol, currentRow).Text = "<< 社員番号 >>";
                    currentRow++;

                    c3ListField.ListCell(currentCol, currentRow).Text = "　・請求書に出力";
                    currentRow++;

                    work2 = "1";
                }

                //利用券の種類
                work = Util.ConvertToString(detail.TDIV).Trim();
                switch (work)
                {
                    case "1":
                        c3ListField.ListCell(currentCol, currentRow).Text = "<< 利用券の種類 >>";
                        currentRow++;
                        c3ListField.ListCell(currentCol, currentRow).Text = "　・貴社専用フォーム";
                        currentRow++;
                        break;
                    case "2":
                        c3ListField.ListCell(currentCol, currentRow).Text = "<< 利用券の種類 >>";
                        currentRow++;
                        c3ListField.ListCell(currentCol, currentRow).Text = "　・健康保険組合フォーム";
                        currentRow++;
                        break;
                    case "3":
                        c3ListField.ListCell(currentCol, currentRow).Text = "<< 利用券の種類 >>";
                        currentRow++;
                        c3ListField.ListCell(currentCol, currentRow).Text = "　・健保連フォーム";
                        currentRow++;
                        break;
                    case "4":
                        c3ListField.ListCell(currentCol, currentRow).Text = "<< 利用券の種類 >>";
                        currentRow++;
                        c3ListField.ListCell(currentCol, currentRow).Text = "　・聖路加フォーム";
                        currentRow++;
                        break;
                    default:
                        c3ListField.ListCell(currentCol, currentRow).Text = "<< 利用券の種類 >>";
                        currentRow++;
                        c3ListField.ListCell(currentCol, currentRow).Text = "　・無";
                        currentRow++;
                        break;
                }

                //利用券その他
                work = Util.ConvertToString(detail.TIC).Trim();
                work2 = "0";
                if (work == "1")
                {
                    c3ListField.ListCell(currentCol, currentRow).Text = "<< 利用券その他 >>";
                    currentRow++;

                    c3ListField.ListCell(currentCol, currentRow).Text = "　・事前回収有";
                    currentRow++;

                    work2 = "1";
                }

                work = Util.ConvertToString(detail.TICP).Trim();
                if (work == "1")
                {
                    if (work2 != "1")
                    {
                        c3ListField.ListCell(currentCol, currentRow).Text = "<< 利用券その他 >>";
                        currentRow++;
                        work2 = "1";
                    }

                    c3ListField.ListCell(currentCol, currentRow).Text = "　・当日持参";
                    currentRow++;
                }

                work = Util.ConvertToString(detail.TBIL).Trim();
                if (work == "1")
                {
                    if (work2 != "1")
                    {
                        c3ListField.ListCell(currentCol, currentRow).Text = "<< 利用券その他 >>";
                        currentRow++;
                        work2 = "1";
                    }

                    c3ListField.ListCell(currentCol, currentRow).Text = "　・請求書添付";
                    currentRow++;
                }

                //確認はがき送付
                work = Util.ConvertToString(detail.POSCD).Trim();
                c3ListField.ListCell(currentCol, currentRow).Text = "<< 確認はがき送付 >>";
                currentRow++;

                if (work == "1")
                {
                    c3ListField.ListCell(currentCol, currentRow).Text = "　・有";
                    currentRow++;
                }
                else
                {
                    c3ListField.ListCell(currentCol, currentRow).Text = "　・無";
                    currentRow++;
                }

                //結果票の送付
                c3ListField.ListCell(currentCol, currentRow).Text = "<< 結果表の送付 >>";
                currentRow++;
                c3ListField.ListCell(currentCol, currentRow).Text = "";
                currentRow++;

                //コメント
                c3ListField.ListCell(currentCol, currentRow).Text = "<< コメント >>";
                currentRow++;

                //【注意事項】・【団体請求関連情報】
                string note1 = "";
                string note2 = "";
                string note3 = "";
                string note4 = "";
                string orgcd = Util.ConvertToString(detail.ORGCD).Trim();
                string ctrptcd = Util.ConvertToString(detail.CTRPTCD).Trim();

                //注意事項　団体ノート、注意事項　契約ノート、
                //体請求関連情報 団体ノート、団体請求関連情報　契約ノートの順で出力する
                for (int i = 1; i <= 2; i++)
                {
                    for (int j = 1; j <= 2; j++)
                    {
                        dynamic pubNotes;

                        switch (i.ToString() + j.ToString())
                        {
                            case "11":
                                //注意事項　団体ノート
                                pubNotes = GetOrgPubNote(orgcd, "0");
                                break;
                            case "12":
                                //注意事項　契約ノート
                                pubNotes = GetCtrPubNote(ctrptcd, "0");
                                break;
                            case "21":
                                //団体請求関連情報　団体ノート
                                pubNotes = GetOrgPubNote(orgcd, "1");
                                break;
                            case "22":
                                //団体請求関連情報　契約ノート
                                pubNotes = GetCtrPubNote(ctrptcd, "1");
                                break;
                            default:
                                pubNotes = null;
                                break;
                        }

                        if (pubNotes == null)
                        {
                            break;
                        }

                        foreach (var pubNote in pubNotes)
                        {
                            string note = "";
                            if (j == 1)
                            {
                                //団体ノートの場合
                                note = Util.ConvertToString(pubNote.ORPUB).Trim();
                            }
                            else
                            {
                                //契約ノートの場合
                                note = Util.ConvertToString(pubNote.CTPUB).Trim();
                            }

                            int mojicnt = note.Length;

                            maxCnt = 0;

                            note1 = "";
                            note2 = "";
                            note3 = "";
                            note4 = "";

                            //出力文字列取得
                            for (int cnt = 1; cnt <= mojicnt; cnt++)
                            {
                                //次の文字のバイト数を取得
                                int bytecnt = WebHains.LenB(note.Substring(cnt - 1, 1));

                                //バイト計算
                                maxCnt += bytecnt;

                                if (maxCnt < 130)
                                {
                                    note1 += note.Substring(cnt - 1, 1);
                                }
                                else if (maxCnt > 129)
                                {
                                    note2 += note.Substring(cnt - 1, 1);
                                }
                                else if (maxCnt > 259)
                                {
                                    note3 += note.Substring(cnt - 1, 1);
                                }
                                else if (maxCnt > 389)
                                {
                                    note4 += note.Substring(cnt - 1, 1);
                                }

                            }

                            for (int k = 1; k <= 4; k++)
                            {
                                string outText = "";

                                switch(k)
                                {
                                    //出力文字列退避
                                    case 1: outText = note1;break;
                                    case 2: outText = note2; break;
                                    case 3: outText = note3; break;
                                    case 4: outText = note4; break;
                                }

                                if (currentRow >= 41)
                                {
                                    // ドキュメントの出力（３ページ目レイアウト）
                                    PrintOut(cnForm3);

                                    //ヘッダ出力
                                    c3strdayField.Text = Util.ConvertToString(detail.STRDATE).Trim();
                                    c3enddayField.Text = Util.ConvertToString(detail.ENDDATE).Trim();
                                    c3printdateField.Text = Util.ConvertToString(detail.PRINTDATE).Trim();
                                    c3orgnameField.Text = Util.ConvertToString(detail.ORGNAME).Trim();

                                    //ページ出力
                                    pageNo++;
                                    c3pageField.Text = pageNo.ToString();

                                    currentRow = 0;
                                    currentCol = 0;
                                }

                                //データ出力
                                if (outText != "")
                                {
                                    c3ListField.ListCell(currentCol, currentRow).Text = outText;
                                    currentRow++;
                                }

                            }

                        }

                    }

                }

                // ドキュメントの出力（３ページ目レイアウト）
                PrintOut(cnForm3);

            }

        }

        /// <summary>
        /// 契約パターン情報取得
        /// </summary>
        /// <param name="ctrptCd">契約パターンコード</param>
        /// <param name="csCd">コースコード</param>
        /// <returns></returns>
        private dynamic GetCtrptData(int ctrptCd, string csCd)
        {
            // SQLステートメント定義

            //コースによって処理分け
            string sql = "";
            switch (csCd)
            {
                case cscd_D001 : case cscd_D002:
                    //一日人間ドック・職員定期健康診断（ドック）用
                    sql += @"
                        select distinct
                            ctrpt_opt.ctrptcd optcd
                            , ctrpt_opt.setclasscd optset
                            , ctrpt_opt.optcd opcd
                            , ctrpt_opt.optbranchno opbrcd
                            , ctrpt_opt.optname oname
                            , ctrpt_optgrp.addcondition optg
                            , free.freefield1 free1
                            , ctrpt_opt.gender opgen
                            , nvl(ctrpt_opt.exceptlimit, 0) as exceptlimit
                            , ( 
                                select
                                    ctrpt_price.price 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '1'
                            ) madoguti
                            , ( 
                                select
                                    ctrpt_price.tax 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '1'
                            ) tmadoguti
                            , ( 
                                select
                                    ctrpt_price.price 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '2'
                            ) danprice
                            , ( 
                                select
                                    ctrpt_price.tax 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '2'
                            ) tdanprice
                            , ( 
                                select
                                    ctrpt_price.price 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '3'
                            ) futan2
                            , ( 
                                select
                                    ctrpt_price.tax 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '3'
                            ) tfutan2
                            , ( 
                                select
                                    ctrpt_price.price 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '4'
                            ) futan3
                            , ( 
                                select
                                    ctrpt_price.tax 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '4'
                            ) tfutan3 
                        from
                            ctrpt_opt
                            , ctrpt_optgrp
                            , ctrpt_optage
                            , free 
                        where
                            ctrpt_opt.ctrptcd = :ctrptcd 
                            and ctrpt_optgrp.ctrptcd = ctrpt_opt.ctrptcd 
                            and ctrpt_optgrp.optcd = ctrpt_opt.optcd 
                            and ctrpt_opt.csldivcd = free.freecd 
                            and ctrpt_optage.ctrptcd = ctrpt_opt.ctrptcd 
                            and ctrpt_optage.optcd = ctrpt_opt.optcd 
                            and ctrpt_optage.optbranchno = ctrpt_opt.optbranchno 
                        order by
                            ctrpt_opt.optcd
                            , ctrpt_opt.optbranchno
                    ";
                    break;

                case cscd_K001:
                    //企業健診
                    sql += @"
                        select distinct
                            ctrpt_opt.optcd opcd
                            , ctrpt_opt.optbranchno opbrcd
                            , ctrpt_opt.ctrptcd optcd
                            , ctrpt_opt.setclasscd optset
                            , ctrpt_opt.optname oname
                            , ctrpt_optgrp.addcondition optg
                            , free.freefield1 free1
                            , ctrpt_opt.gender opgen
                            , nvl(ctrpt_opt.exceptlimit, 0) as exceptlimit
                            , ( 
                                select
                                    ctrpt_price.price 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '1'
                            ) madoguti
                            , ( 
                                select
                                    ctrpt_price.tax 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '1'
                            ) tmadoguti
                            , ( 
                                select
                                    ctrpt_price.price 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '2'
                            ) danprice
                            , ( 
                                select
                                    ctrpt_price.tax 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '2'
                            ) tdanprice
                            , ( 
                                select
                                    ctrpt_price.price 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '3'
                            ) futan2
                            , ( 
                                select
                                    ctrpt_price.tax 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '3'
                            ) tfutan2
                            , ( 
                                select
                                    ctrpt_price.price 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '4'
                            ) futan3
                            , ( 
                                select
                                    ctrpt_price.tax 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '4'
                            ) tfutan3 
                        from
                            ctrpt_opt
                            , ctrpt_optgrp
                            , ctrpt_optage
                            , free 
                        where
                            ctrpt_opt.ctrptcd = :ctrptcd 
                            and ctrpt_optgrp.ctrptcd = ctrpt_opt.ctrptcd 
                            and ctrpt_optgrp.optcd = ctrpt_opt.optcd 
                            and ctrpt_opt.csldivcd = free.freecd 
                            and ctrpt_optage.ctrptcd = ctrpt_opt.ctrptcd 
                            and ctrpt_optage.optcd = ctrpt_opt.optcd 
                            and ctrpt_optage.optbranchno = ctrpt_opt.optbranchno 
                        order by
                            ctrpt_opt.optcd
                            , ctrpt_opt.optbranchno
                    ";
                    break;

                default:
                    sql += @"
                        select distinct
                            ctrpt_opt.ctrptcd optcd
                            , ctrpt_opt.setclasscd optset
                            , ctrpt_opt.optcd opcd
                            , ctrpt_opt.optbranchno opbrcd
                            , ctrpt_opt.optname oname
                            , ctrpt_optgrp.addcondition optg
                            , free.freefield1 free1
                            , ctrpt_opt.gender opgen
                            , nvl(ctrpt_opt.exceptlimit, 0) as exceptlimit
                            , ( 
                                select
                                    ctrpt_price.price 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '1'
                            ) madoguti
                            , ( 
                                select
                                    ctrpt_price.tax 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '1'
                            ) tmadoguti
                            , ( 
                                select
                                    ctrpt_price.price 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '2'
                            ) danprice
                            , ( 
                                select
                                    ctrpt_price.tax 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '2'
                            ) tdanprice
                            , ( 
                                select
                                    ctrpt_price.price 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '3'
                            ) futan2
                            , ( 
                                select
                                    ctrpt_price.tax 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '3'
                            ) tfutan2
                            , ( 
                                select
                                    ctrpt_price.price 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '4'
                            ) futan3
                            , ( 
                                select
                                    ctrpt_price.tax 
                                from
                                    ctrpt_price 
                                where
                                    ctrpt_price.ctrptcd = ctrpt_opt.ctrptcd 
                                    and ctrpt_price.optcd = ctrpt_opt.optcd 
                                    and ctrpt_price.optbranchno = ctrpt_opt.optbranchno 
                                    and seq = '4'
                            ) tfutan3 
                        from
                            ctrpt_opt
                            , ctrpt_optgrp
                            , ctrpt_optage
                            , free 
                        where
                            ctrpt_opt.ctrptcd = :ctrptcd 
                            and ctrpt_optgrp.ctrptcd = ctrpt_opt.ctrptcd 
                            and ctrpt_optgrp.optcd = ctrpt_opt.optcd 
                            and ctrpt_opt.csldivcd = free.freecd 
                            and ctrpt_optage.ctrptcd = ctrpt_opt.ctrptcd 
                            and ctrpt_optage.optcd = ctrpt_opt.optcd 
                            and ctrpt_optage.optbranchno = ctrpt_opt.optbranchno 
                        order by
                            optset
                    ";
                    break;
            }

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
        /// 年齢情報
        /// </summary>
        /// <param name="ctrptCd">契約パターンコード</param>
        /// <param name="setClassCd">セット分類コード</param>
        /// <param name="optCd">オプションコード</param>
        /// <param name="optBranchno">オプション枝番</param>
        /// <returns></returns>
        private dynamic GetAgeData(string ctrptCd, string setClassCd, string optCd, string optBranchno)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    ctrpt_opt.ctrptcd optcd
                    , ctrpt_opt.setclasscd optset
                    , ctrpt_opt.optcd
                    , ctrpt_opt.optbranchno
                    , ctrpt_optage.strage opsage
                    , ctrpt_optage.endage opeage 
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
                optbranchno = optBranchno
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 団体ノート情報取得
        /// </summary>
        /// <param name="ctrptCd">契約パターンコード</param>
        /// <param name="csKbn">コース区分</param>
        /// <returns></returns>
        private dynamic GetOrgPubNote(string ctrptCd, string csKbn)
        {
            // SQLステートメント定義
            string sql = "";

            switch (csKbn.Trim())
            {
                case "0":
                    sql = @"
                        select
                            orgpubnote.pubnote orpub 
                        from
                            orgpubnote 
                        where
                            orgpubnote.orgcd1 || orgpubnote.orgcd2 = :ctrptcd 
                            and orgpubnote.pubnotedivcd = :divcd1
                        order by
                            seq
                    ";
                    break;

                case "1":
                    sql = @"
                        select
                            orgpubnote.pubnote orpub 
                        from
                            orgpubnote 
                        where
                            orgpubnote.orgcd1 || orgpubnote.orgcd2 = :ctrptcd 
                            and orgpubnote.pubnotedivcd = :divcd2 
                        order by
                            seq
                    ";
                    break;

                default:
                    sql = @"
                        select
                            orgpubnote.pubnote orpub 
                        from
                            orgpubnote 
                        where
                            orgpubnote.orgcd1 || orgpubnote.orgcd2 = :ctrptcd 
                            and orgpubnote.pubnotedivcd = :divcd1 
                        order by
                            seq
                    ";
                    break;
            }

            // パラメータセット
            var sqlParam = new
            {
                ctrptcd = ctrptCd,
                divcd1 = PUBNOTE_DIVCD1,
                divcd2 = PUBNOTE_DIVCD2
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 契約ノート情報取得
        /// </summary>
        /// <param name="ctrptCd">契約パターンコード</param>
        /// <param name="csKbn">コース区分</param>
        /// <returns></returns>
        private dynamic GetCtrPubNote(string ctrptCd, string csKbn)
        {
            // SQLステートメント定義
            string sql = "";

            switch (csKbn.Trim())
            {
                case "0":
                    sql = @"
                        select
                            ctrptpubnote.pubnote ctpub 
                        from
                            ctrptpubnote 
                        where
                            ctrptpubnote.ctrptcd = :ctrptcd 
                            and ctrptpubnote.pubnotedivcd = :divcd1 
                        order by
                            seq
                    ";
                    break;

                case "1":
                    sql = @"
                        select
                            ctrptpubnote.pubnote ctpub 
                        from
                            ctrptpubnote 
                        where
                            ctrptpubnote.ctrptcd = :ctrptcd 
                            and ctrptpubnote.pubnotedivcd = :divcd2
                        order by
                            seq
                    ";
                    break;

                default:
                    sql = @"
                    select
                        ctrptpubnote.pubnote ctpub 
                    from
                        ctrptpubnote 
                    where
                        ctrptpubnote.ctrptcd = :ctrptcd 
                        and ctrptpubnote.pubnotedivcd = :divcd1
                    order by
                        seq
                    ";
                    break;
            }

            // パラメータセット
            var sqlParam = new
            {
                ctrptcd = ctrptCd,
                divcd1 = PUBNOTE_DIVCD1,
                divcd2 = PUBNOTE_DIVCD2
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            // 戻り値設定
            return result;
        }

    }
}
