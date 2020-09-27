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
    /// 請求書チェックリスト（成績書）生成クラス
    /// </summary>
    public class BillRepCheckCreator : PdfCreator
    {

        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002360";

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            if (string.IsNullOrEmpty(queryParams["year"]) || string.IsNullOrEmpty(queryParams["month"]))
            {
                messages.Add("受診年月が未入力です。");
            }
            else
            {
                if (! DateTime.TryParse(queryParams["year"] + "/" + queryParams["month"] + "/01", out DateTime wkDate))
                {
                    messages.Add("受診年月が正しくありません。");
                }
            }

            return messages;
        }

        /// <summary>
        /// 請求書チェックリスト（成績書）データを読み込む
        /// </summary>
        /// <returns>請求書チェックリスト（成績書）データ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select distinct
                    com.orgcd1 as orgcd1
                    , com.orgcd2 as orgcd2
                    , og.orgname as orgname
                    , decode(og.ticketaddbill, 1, '○', ' ') as ticketaddbill
                    , decode(og.billreport, 1, '○', ' ') as billreport
                    , decode(og.billreport, 2, '○', ' ') as billlaw
                    , decode(og.billspecial, 1, '○', ' ') as billspecial
                    , decode(og.billfd, 1, '○', ' ') as billfd
                    , decode(og.billins, 1, '○', ' ') as billins
                    , decode(og.billcsldiv, 1, '○', ' ') as billcsldiv
                    , decode(og.insreport, 1, '○', ' ') as insreport
                    , decode(og.reptcsldiv, 1, '○', ' ') as reptcsldiv
                    , :startdate_dtm as startdate
                    , :startdate as cslyyyymm
                    , finalopt.rptv001 as rptv001
                    , finalopt.rptv002 as rptv002
                    , finalopt.rptv003 as rptv003
                    , finalopt.rptv004 as rptv004
                    , finalopt.rptv005 as rptv005
                    , finalopt.rptv006 as rptv006
                    , finalopt.rptd001 as rptd001
                    , finalopt.rptd002 as rptd002
                    , finalopt.rptd003 as rptd003
                    , finalopt.rptd004 as rptd004 
                from
                    consult co
                    , consult_m com
                    , org og
                    , ( 
                        select
                            orgopt.orgcd1 orgcd1
                            , orgopt.orgcd2 orgcd2
                            , max(orgopt.rptv001) rptv001
                            , max(orgopt.rptv002) rptv002
                            , max(orgopt.rptv003) rptv003
                            , max(orgopt.rptv004) rptv004
                            , max(orgopt.rptv005) rptv005
                            , max(orgopt.rptv006) rptv006
                            , max(orgopt.rptd001) rptd001
                            , max(orgopt.rptd002) rptd002
                            , max(orgopt.rptd003) rptd003
                            , max(orgopt.rptd004) rptd004 
                        from
                            ( 
                                select
                                    org.orgcd1 orgcd1
                                    , org.orgcd2 orgcd2
                                    , decode(opt.rptoptcd, 'RPTV001', '○', '') rptv001
                                    , decode(opt.rptoptcd, 'RPTV002', '○', '') rptv002
                                    , decode(opt.rptoptcd, 'RPTV003', '○', '') rptv003
                                    , decode(opt.rptoptcd, 'RPTV004', '○', '') rptv004
                                    , decode(opt.rptoptcd, 'RPTV005', '○', '') rptv005
                                    , decode(opt.rptoptcd, 'RPTV006', '○', '') rptv006
                                    , decode(opt.rptoptcd, 'RPTD001', '', '○') rptd001
                                    , decode(opt.rptoptcd, 'RPTD002', '', '○') rptd002
                                    , decode(opt.rptoptcd, 'RPTD003', '', '○') rptd003
                                    , decode(opt.rptoptcd, 'RPTD004', '', '○') rptd004 
                                from
                                    org org
                                    , orgrptopt opt 
                                where
                                    org.orgcd1 = opt.orgcd1(+) 
                                    and org.orgcd2 = opt.orgcd2(+)
                            ) orgopt 
                        group by
                            orgopt.orgcd1
                            , orgopt.orgcd2
                    ) finalopt 
                where
                    co.rsvno = com.rsvno 
                    and co.orgcd1 = com.orgcd1 
                    and co.orgcd2 = com.orgcd2 
                    and co.orgcd1 = og.orgcd1 
                    and co.orgcd2 = og.orgcd2 
                    and co.orgcd1 = finalopt.orgcd1 
                    and co.orgcd2 = finalopt.orgcd2 
                    and co.cancelflg = :cancelflg  
                    and com.orgcd1 not in (:orgcd1_person)
                    and com.orgcd2 not in (:orgcd2_person)
                    and co.csldate between to_date(:startdate, 'YYYY/MM') and last_day(to_date(:startdate, 'YYYY/MM')) 
                order by
                    com.orgcd1
                    , com.orgcd2
                ";

            // パラメータセット
            string strDate = "";
            DateTime.TryParse(queryParams["year"] + "/" + queryParams["month"] + "/01", out DateTime startdate);
            strDate = startdate.ToString("yyyyMM");

            var sqlParam = new
            {
                startdate_dtm = startdate.ToString("yyyy/MM/dd"),
                startDate = strDate,
                orgcd1_person = WebHains.ORGCD1_PERSON,
                orgcd2_person = WebHains.ORGCD2_PERSON,

                cancelflg = ConsultCancel.Used
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">請求書チェックリスト（成績書）データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var closedateField = (CnDataField)cnObjects["CLOSEDATE"];
            var prtdateField = (CnDataField)cnObjects["PRINTDATE"];
            var pagenoField = (CnDataField)cnObjects["PAGENO"];
            var orgnameListField = (CnListField)cnObjects["ORGNAME"];
            var billreportListField = (CnListField)cnObjects["BILLREPORT"];
            var billlawListField = (CnListField)cnObjects["BILLLAW"];
            var rptv001ListField = (CnListField)cnObjects["RPTV001"];
            var rptv002ListField = (CnListField)cnObjects["RPTV002"];
            var rptv003ListField = (CnListField)cnObjects["RPTV003"];
            var rptv004ListField = (CnListField)cnObjects["RPTV004"];
            var rptd003ListField = (CnListField)cnObjects["RPTD003"];
            var rptd004ListField = (CnListField)cnObjects["RPTD004"];
            var rptd002ListField = (CnListField)cnObjects["RPTD002"];
            var rptv005ListField = (CnListField)cnObjects["RPTV005"];
            var rptv006ListField = (CnListField)cnObjects["RPTV006"];
            var rptd001ListField = (CnListField)cnObjects["RPTD001"];
            var billspecialListField = (CnListField)cnObjects["BILLSPECIAL"];
            var insreportListField = (CnListField)cnObjects["INSREPORT"];
            var reptcsldivListField = (CnListField)cnObjects["REPTCSLDIV"];
            var ticketaddbillListField = (CnListField)cnObjects["TICKETADDBILL"];

            string sysdate = DateTime.Today.ToShortDateString();

            int pageNo = 0;
            int outCnt = 0;

            short currentLine = 0;

            //キー設定
            //（パラメタで年月指定されているが、おそらく年月毎に改ページさせようとしていたため踏襲）
            string newKey = "";
            string oldKey = "";
            string csldate = "";

            if ( data.Count > 0 )
            {
                newKey = data[0].CSLYYYYMM;
                oldKey = newKey;
                DateTime.TryParse(Util.ConvertToString(data[0].STARTDATE), out DateTime csldate_dtm);
                csldate = WebHains.EraDateFormat(csldate_dtm, "ggyy年 MM月分");
            }

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // キー設定
                newKey = detail.CSLYYYYMM;
                DateTime.TryParse(Util.ConvertToString(detail.STARTDATE), out DateTime csldate_dtm);
                csldate = WebHains.EraDateFormat(csldate_dtm, "ggyy年 MM月分");

                // ページ内最大行に達した場合か、キーが変わった場合
                if (currentLine == orgnameListField.ListRows.Length || newKey != oldKey)
                {
                    pageNo++;

                    // ページ番号
                    pagenoField.Text = pageNo.ToString();

                    // 印刷日
                    prtdateField.Text = sysdate;

                    // 締め日
                    closedateField.Text = csldate;

                    // ドキュメントの出力
                    PrintOut(cnForm);

                    // 行カウントをクリア
                    currentLine = 0;

                    // キー更新
                    if (newKey != oldKey)
                    {
                        oldKey = newKey;
                    }

                }

                //団体名
                orgnameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.ORGNAME);

                //レポート３連
                billreportListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.BILLREPORT);
                
                //レポート法定項目
                billlawListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.BILLLAW);
                
                //血液
                rptv001ListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.RPTV001);
                
                //大腸内視鏡
                rptv002ListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.RPTV002);
                
                //ＣＴ
                rptv003ListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.RPTV003);
                
                //喀痰
                rptv004ListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.RPTV004);
                
                //血清
                rptd003ListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.RPTD003);
                
                //前立腺
                rptd004ListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.RPTD004);
                
                //乳房触診
                rptd002ListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.RPTD002);
                
                //マンモ
                rptv005ListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.RPTV005);
                
                //乳房エコー
                rptv006ListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.RPTV006);
                
                //婦人科
                rptd001ListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.RPTD001);
                
                //成績書特定健診
                billspecialListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.BILLSPECIAL);
                
                //請求書（保険証）
                insreportListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.INSREPORT);
                
                //請求書（本／家）
                reptcsldivListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.REPTCSLDIV);
                
                //利用券添付
                ticketaddbillListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.TICKETADDBILL);

                currentLine++;
                outCnt++;

            }

            //終了処理
            if (currentLine > 0 )
            {
                pageNo++;

                // ページ番号
                pagenoField.Text = pageNo.ToString();

                // 印刷日
                prtdateField.Text = sysdate;

                // 締め日
                closedateField.Text = csldate;

                // ドキュメントの出力
                PrintOut(cnForm);

            }

        }
         
    }
}
