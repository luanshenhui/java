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
    /// ご案内書送付チェックリスト生成クラス
    /// </summary>
    public class InstructionListCreator : PdfCreator
    {

        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002010";

        /// <summary>
        /// 胃検査種別情報取得用
        /// </summary>
        private string IBU_GRPCD = "X502";            // 胃検査種別情報取得用　グループコード
        private string IBU_FREECD = "LST000022%";     // 胃検査種別情報取得用　汎用コード

        /// <summary>
        /// 各検査項目取得用
        /// </summary>
        private string BEN_ITEMCD = "14305";          // 便潜血取得用
        private string TAN_ITEMCD = "21140";          // 喀痰取得用
        private string GYNE_ITEMCD = "27010";         // 婦人科取得用

        /// <summary>
        ///各オプションクラスコード取得用
        /// </summary>
        private string CT_CLASSCD1 = "007";         // オプションＣＴ取得用１
        private string CT_CLASSCD2 = "008";         // オプションＣＴ取得用２

        /// <summary>
        /// 経腹超音波取得用
        /// </summary>
        private string KEIFUKU_DIVCD1 = "100";         // 経腹超音波取得用１
        private string KEIFUKU_DIVCD2 = "500";         // 経腹超音波取得用２
        private string KEIFUKU_PUBNOTE = "%経腹超音波予約%"; // 経腹超音波取得用３

        /// <summary>
        /// 便中ピロリ取得用
        /// </summary>
        private string HP_ITEMCD = "14370";           // 便中ピロリ菌抗原取得用

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            DateTime wkDate;
            if (!DateTime.TryParse(queryParams["startdate"], out wkDate))
            {
                messages.Add("開始日付が正しくありません。");
            }

            if (!DateTime.TryParse(queryParams["enddate"], out wkDate))
            {
                messages.Add("終了日付が正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// ご案内書送付チェックリストデータを読み込む
        /// </summary>
        /// <returns>ご案内書送付チェックリストデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    course_p.csname as csname
                    , org.orgname as orgname
                    , to_char(consult.formprintdate, 'YYYY/MM/DD') as formprintdate
                    , to_char(consult.csldate, 'YYYY/MM/DD') as csldate
                    , decode(consult.formouteng, 1, '〇', ' ') as formouteng
                    , consult.rsvno as rsvno
                    , consult.ctrptcd as ctrptcd
                    , person.lastname || '　' || person.firstname as name
                    , decode(person.gender, 1, '男', 2, '女') as gender
                    , person.perid as perid
                    , to_char(sysdate, 'YYYY/MM/DD') as innsatubi
                    , trunc( 
                        getcslage( 
                            to_char(person.birth, 'YYYYMMDD')
                            , to_char(consult.csldate, 'YYYYMMDD')
                            , to_char(consult.csldate, 'YYYYMMDD')
                        )
                    ) || '歳(' || trunc(consult.age) || '歳)' as age

                    --胃検査種別情報取得（胃X線・胃内視鏡）
                    , ( 
                        select
                            free.freefield3 
                        from
                            consultitemlist
                            , grp_i
                            , free 
                        where
                            consultitemlist.rsvno = consult.rsvno 
                            and consultitemlist.cancelflg = :cancelflg 
                            and grp_i.grpcd = :ibu_grpcd 
                            and grp_i.itemcd = consultitemlist.itemcd 
                            and free.freecd like :ibu_freecd
                            and free.freefield1 = grp_i.grpcd 
                            and free.freefield2 = grp_i.seq
                    ) as ikensa

                    --便潜血チェック：検査項目「便潜血(出力用)（14305）」が予約情報に含まれているかで判断
                    , ( 
                        select
                            decode(count(sysdate), 0, '', '○') 
                        from
                            consultitemlist 
                        where
                            consultitemlist.rsvno = consult.rsvno 
                            and consultitemlist.cancelflg = :cancelflg 
                            and consultitemlist.itemcd = :ben_itemcd
                    ) as optben

                    --喀痰チェック：検査項目「喀痰細胞診（21140）」が予約情報に含まれているかで判断
                    , ( 
                        select
                            decode(count(sysdate), 0, '', '○') 
                        from
                            consultitemlist 
                        where
                            consultitemlist.rsvno = consult.rsvno 
                            and consultitemlist.cancelflg = :cancelflg 
                            and consultitemlist.itemcd = :tan_itemcd
                    ) as opttan

                    --婦人科チェック
                    , ( 
                        select
                            decode(count(sysdate), 0, '', '○') 
                        from
                            consultitemlist 
                        where
                            consultitemlist.rsvno = consult.rsvno 
                            and consultitemlist.cancelflg = :cancelflg 
                            and consultitemlist.itemcd = :gyne_itemcd
                    ) as optgyne

                    --オプションＣＴチェック：予約情報に検査セット「オプションＣＴ、オプションＣＴ・喀痰細胞診」が含まれているかで判断
                    , ( 
                        select
                            decode(count(sysdate), 0, '', '○') 
                        from
                            consult_o
                            , ctrpt_opt 
                        where
                            consult_o.rsvno = consult.rsvno 
                            and consult_o.ctrptcd = consult.ctrptcd 
                            and ctrpt_opt.ctrptcd = consult_o.ctrptcd 
                            and ctrpt_opt.optcd = consult_o.optcd 
                            and ctrpt_opt.optbranchno = consult_o.optbranchno 
                            and ctrpt_opt.setclasscd in (:ct_classcd1, :ct_classcd2)
                    ) as optct

                    --経腹超音波チェック：該当予約日（受診日）のコメントに「経腹超音波予約」文言が登録されているかで判断
                    , ( 
                        select
                            decode(count(sysdate), 0, '', '○') 
                        from
                            cslpubnote 
                        where
                            cslpubnote.rsvno = consult.rsvno 
                            and cslpubnote.pubnotedivcd in (:keifuku_divcd1, :keifuku_divcd1) 
                            and cslpubnote.delflg is null 
                            and cslpubnote.pubnote like :keifuku_pubnote
                    ) as keifuku

                    --便中ピロリ菌抗原検査チェック：検査項目「便中ピロリ菌抗原（14370）」が予約情報に含まれているかで判断
                    , ( 
                        select
                            decode(count(sysdate), 0, '', '○') 
                        from
                            consultitemlist 
                        where
                            consultitemlist.rsvno = consult.rsvno 
                            and consultitemlist.cancelflg = :cancelflg 
                            and consultitemlist.itemcd = :hp_itemcd
                    ) as opthp 
                from
                    person
                    , consult
                    , org
                    , course_p 
                where
                    consult.csldate >= :startdate
                ";

            //年月日
            DateTime.TryParse(queryParams["startdate"], out DateTime dtSdate);
            DateTime.TryParse(queryParams["enddate"], out DateTime dtEdate);

            //終了年月日
            string endDate = queryParams["enddate"];
            if (!string.IsNullOrEmpty(endDate))
            {
                sql += @"  and consult.csldate <= :enddate ";

                // 開始日より終了日が過去であれば値を交換
                if (dtSdate > dtEdate)
                {
                    DateTime wkDate = dtSdate;
                    dtSdate = dtEdate;
                    dtEdate = wkDate;
                }
            }

            //コースコード
            string csCd = queryParams["cscd"];
            if (!string.IsNullOrEmpty(csCd))
            {

                sql += @"  and consult.cscd = :cscd ";
            }

            //団体コード
            string orgCd1 = queryParams["orgcd1"];
            string orgCd2 = queryParams["orgcd2"];
            if (!string.IsNullOrEmpty(orgCd1) || !string.IsNullOrEmpty(orgCd2))
            {
                sql += @"  and consult.orgcd1 = :orgcd1
                           and consult.orgcd2 = :orgcd2";
            }

            sql += @"
                    and consult.orgcd1 = org.orgcd1 
                    and consult.orgcd2 = org.orgcd2 
                    and org.packagesend = 1 
                    and consult.cscd = course_p.cscd 
                    and consult.perid = person.perid 
                    and consult.cancelflg = :cancelflg 
                    and consult.rsvstatus = 0 
                order by
                    orgname
                    , name
                ";

            // パラメータセット
            var sqlParam = new
            {
                startDate = dtSdate,
                endDate = dtEdate,
                cscd = queryParams["cscd"],
                orgCd1 = queryParams["orgcd1"],
                orgcd2 = queryParams["orgcd2"],

                ibu_grpcd      = IBU_GRPCD,
                ibu_freecd     = IBU_FREECD,
                ben_itemcd     = BEN_ITEMCD,
                tan_itemcd     = TAN_ITEMCD,
                gyne_itemcd    = GYNE_ITEMCD,
                ct_classcd1    = CT_CLASSCD1,
                ct_classcd2    = CT_CLASSCD2,
                keifuku_divcd1 = KEIFUKU_DIVCD1,
                keifuku_divcd2 = KEIFUKU_DIVCD2,
                keifuku_pubnote= KEIFUKU_PUBNOTE,
                hp_itemcd      = HP_ITEMCD,

                cancelflg = ConsultCancel.Used
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

            // フォームの各項目を変数にセット
            var prtDateField = (CnDataField)cnObjects["PRTDATE"];
            var pageField = (CnDataField)cnObjects["PAGE"];
            var paraCsldateField = (CnDataField)cnObjects["PARACSLDATE"];
            var countListField = (CnListField)cnObjects["COUNT"];
            var csNameListField = (CnListField)cnObjects["CSNAME"];
            var ikensaListField = (CnListField)cnObjects["IKENSA"];
            var orgNameListField = (CnListField)cnObjects["ORGNAME"];
            var soufuDateListField = (CnListField)cnObjects["SOUFUDATE"];
            var csldateListField = (CnListField)cnObjects["CSLDATE"];
            var nameListField = (CnListField)cnObjects["NAME"];
            var genderListField = (CnListField)cnObjects["GENDER"];
            var ageListField = (CnListField)cnObjects["AGE"];
            var peridListField = (CnListField)cnObjects["PERID"];
            var engListField = (CnListField)cnObjects["ENG"];
            var opBenListField = (CnListField)cnObjects["OPBEN"];
            var opTanListField = (CnListField)cnObjects["OPTAN"];
            var opWomanListField = (CnListField)cnObjects["OPWOMAN"];
            var opctListField = (CnListField)cnObjects["OPCT"];
            var keifukuListField = (CnListField)cnObjects["KEIFUKU"];
            var ophpListField = (CnListField)cnObjects["OPHP"];

            string sysdate = DateTime.Today.ToShortDateString();

            int rowCount = 0;
            int pageNo = 0;

            int outCnt = 0;

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // 編集行を特定する
                var currentLine = (short)(rowCount % nameListField.ListRows.Length);

                // データフィールド

                //ＮＯ
                countListField.ListCell(0, currentLine).Text = Util.ConvertToString(outCnt + 1);

                //コース名
                csNameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.CSNAME);

                //胃の検査種別
                ikensaListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.IKENSA);

                //団体名
                orgNameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.ORGNAME);

                //送付案内日
                soufuDateListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.FORMPRINTDATE);

                //受診日
                csldateListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.CSLDATE);

                //氏名
                nameListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.NAME);

                //性別
                genderListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.GENDER);

                //受診時年齢
                ageListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.AGE);

                //患者ＩＤ
                peridListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.PERID);

                //英文
                engListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.FORMOUTENG);

                //便
                opBenListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.OPTBEN);

                //便中ピロリ菌抗原検査
                ophpListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.OPTHP);

                //喀痰容器
                opTanListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.OPTTAN);

                //婦人科診察
                opWomanListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.OPTGYNE);

                //経腹超音波
                keifukuListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.KEIFUKU);

                //胸部ＣＴ
                opctListField.ListCell(0, currentLine).Text = Util.ConvertToString(detail.OPTCT);

                // ページ内最大行に達したか、レコード最大数に達した場合
                if (currentLine == countListField.ListRows.Length - 1 || rowCount == data.Count - 1)
                {
                    pageNo++;

                    // ページ番号
                    pageField.Text = pageNo.ToString();

                    // 印刷日
                    prtDateField.Text = sysdate;

                    // 受診日
                    string strCslDate = "";
                    string endCslDate = "";

                    DateTime dt;
                    if (DateTime.TryParse(Util.ConvertToString(queryParams["startdate"]), out dt))
                    {
                        strCslDate = dt.ToString("yyyy年MM月dd日");
                    }
                    if (DateTime.TryParse(Util.ConvertToString(queryParams["enddate"]), out dt))
                    {
                        endCslDate = dt.ToString("yyyy年MM月dd日");
                    }
                    paraCsldateField.Text = strCslDate + " ～ " + endCslDate;

                    // ドキュメントの出力
                    PrintOut(cnForm);
                }

                // 行カウントをインクリメント
                rowCount++;

                // 連番をインクリメント
                outCnt++;
            }
        }
         
    }
}
