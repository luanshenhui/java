using Dapper;
using Hainsi.Common;
using Hainsi.ReportCore;
using Hainsi.Common.Constants;
using Hos.CnDraw;
using Hos.CnDraw.Object;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    /// <summary>
    /// 健診事前管理票生成クラス
    /// </summary>
    public class ReserveMediCreator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002057";

        /// <summary>
        /// 汎用コード(コース名)
        /// </summary>
        private const string FREECOURSE = "MEDI0001%";

        /// <summary>
        /// 汎用コード(オプション名)
        /// </summary>
        private const string FREEOPTION = "MEDI0002%";

        /// <summary>
        /// 汎用コード(時間名)
        /// </summary>
        private const string FREETIME = "MEDI0003%";

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            return messages;
        }

        /// <summary>
        /// 対象データ取得（健診事前管理票）
        /// </summary>
        /// <returns>健診事前管理票データ</returns>
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
                    , person.lastname || '  ' || person.firstname || '  ' || '様' as name
                    , person.lastkname || '  ' || person.firstkname as kananame
                    , decode( 
                        consult.formouteng
                        , 1
                        , person.romename
                        , person.lastkname || ' ' || person.firstkname
                    ) as tname
                    , person.gender as gender
                    , decode(person.gender, 1, 'male', 'female') as gendername
                    , decode(person.gender, 1, '男性', '女性') as gendernamej
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
                    , ctrpt.csname as csname
                    , ctrpt.csename as csename
                    , decode( 
                        consult.formouteng
                        , 1
                        , ctrpt.csename
                        , ctrpt.csname
                    ) as tcsname 
                from
                    consult
                    , peraddr peraddr1
                    , peraddr peraddr2
                    , peraddr peraddr3
                    , person
                    , rsvgrp
                    , org
                    , ctrpt 
                where
                    consult.perid = person.perid 
                    and peraddr1.perid(+) = consult.perid 
                    and peraddr1.addrdiv(+) = '1' 
                    and peraddr2.perid(+) = consult.perid 
                    and peraddr2.addrdiv(+) = '2' 
                    and peraddr3.perid(+) = consult.perid 
                    and peraddr3.addrdiv(+) = consult.formaddrdiv 
                    and consult.rsvgrpcd = rsvgrp.rsvgrpcd 
                    and consult.orgcd1 = org.orgcd1 
                    and consult.orgcd2 = org.orgcd2 
                --### 団体情報の「確認はがき」が「有」の団体のみ印刷可とする（メディローカスに要確認）
                    and org.postcard = 1 
                    and consult.ctrptcd = ctrpt.ctrptcd 
                    and consult.cancelflg = :cancelflg 
                --### 予約状況が「確定」のみ印刷可とする（メディローカスに要確認）
                    and consult.rsvstatus = 0 
                --### 団体情報の「一括送付案内」が「無」でも印刷可とする（メディローカスに要確認）
                    and consult.rsvno = :rsvno
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = queryParams["rsvno"],
                cancelflg = ConsultCancel.Used
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">健診事前管理票データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // レイヤの参照設定
            CnLayers cnLayers = cnForm.CnLayers;

            var layzukei = cnLayers["図形"];
            var layyoyakujpn = cnLayers["予約情報"];

            // フォームの各項目を変数にセット
            var zipcdField = (CnDataField)cnObjects["ZIPCD"];
            var citynameField = (CnDataField)cnObjects["CITYNAME"];
            var address1Field = (CnDataField)cnObjects["ADDRESS1"];
            var address2Field = (CnDataField)cnObjects["ADDRESS2"];
            var nameField = (CnDataField)cnObjects["NAME"];
            var barcodeField = (CnBarcodeField)cnObjects["BARCODE"];
            var barcdidField = (CnDataField)cnObjects["BARCDID"];
            var csldateField = (CnDataField)cnObjects["CSLDATE"];
            var yobiField = (CnDataField)cnObjects["YOBI"];
            var hourField = (CnDataField)cnObjects["HOUR"];
            var courseField = (CnDataField)cnObjects["COURSE"];
            var optionListField = (CnListField)cnObjects["OPTION"];
            var nameknField = (CnDataField)cnObjects["NAMEKN"];
            var genderField = (CnDataField)cnObjects["GENDER"];
            var birthField = (CnDataField)cnObjects["BIRTH"];
            var peridField = (CnDataField)cnObjects["PERID"];
            var telhomeField = (CnDataField)cnObjects["TELHOME"];
            var teloffField = (CnDataField)cnObjects["TELOFF"];
            var telperField = (CnDataField)cnObjects["TELPER"];


            // 全レイヤの印刷をON
            layzukei.VisibleAtPrint = true;
            layyoyakujpn.VisibleAtPrint = true;

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // 郵便番号
                zipcdField.Text = Util.ConvertToString(detail.ZIPCODE);
                // 市町村
                citynameField.Text = Util.ConvertToString(detail.CITYNAME);
                // 住所１
                address1Field.Text = Util.ConvertToString(detail.ADDRESS1);
                // 住所２
                address2Field.Text = Util.ConvertToString(detail.ADDRESS2);
                // 氏名
                nameField.Text = Util.ConvertToString(detail.NAME);
                // バーコード
                barcodeField.Data = Util.ConvertToString(detail.RSVNOBAR);
                barcdidField.Text = Util.ConvertToString(detail.RSVNOBAR);
                // 受診日
                csldateField.Text = Util.ConvertToString(detail.CSLDATE);
                // 曜日
                yobiField.Text = Util.ConvertToString(detail.JYOBI);

                // 受付時間、健診コース、オプション検査項目は汎用マスターに登録された名称を参照

                // 氏名カナ
                nameknField.Text = Util.ConvertToString(detail.TNAME);
                // 性別
                genderField.Text = Util.ConvertToString(detail.GENDERNAMEJ);
                // 生年月日
                birthField.Text = Util.ConvertToString(detail.BIRTH);
                // 患者ＩＤ
                string perId = Util.ConvertToString(detail.PERID);
                if (string.IsNullOrEmpty(perId) && perId.Substring(0, 1) == "@")
                {
                    peridField.Text = string.Empty;
                }
                else
                {
                    peridField.Text = perId;
                }
                // 自宅電話番号
                telhomeField.Text = Util.ConvertToString(detail.TELHOM);
                // 会社電話番号
                teloffField.Text = Util.ConvertToString(detail.TELOFF);
                // 携帯電話番号
                telperField.Text = Util.ConvertToString(detail.PHONE);

                // コース名取得
                var courseData = GetFree(Util.ConvertToString(detail.RSVNO), FREECOURSE);
                if (courseData.Count > 0)
                {
                    courseField.Text = Util.ConvertToString(courseData[0].FREEFIELD2);
                }

                // オプション検査取得
                short currentLine = 0;
                foreach (var optionData in GetFree(Util.ConvertToString(detail.RSVNO), FREEOPTION))
                {
                    // オプション検査名編集
                    optionListField.ListCell(0, currentLine).Text = Util.ConvertToString(optionData.FREEFIELD2);
                    currentLine += 1;
                }

                // 受付時間取得
                var timeData = GetFree(Util.ConvertToString(detail.RSVNO), FREETIME);
                if (timeData.Count > 0)
                {
                    hourField.Text = Util.ConvertToString(timeData[0].FREEFIELD2);
                }


                // ドキュメントの出力
                PrintOut(cnForm);
            }

        }

        /// <summary>
        /// メディローカスの健診コース、オプション検査、受付時間を汎用マスターから参照
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="freeSet">汎用コード</param>
        /// <returns></returns>
        private dynamic GetFree(string rsvNo,string freeSet)
        {
            // SQLステートメント定義
            string sql = @"
                select distinct
                    nvl(free.freefield2, ' ') as freefield2
                    , nvl(free.freefield3, ' ') as freefield3
                    , nvl(ctrpt_opt.optname, ' ') as optname 
                from
                    consult_o
                    , ctrpt_opt
                    , free 
                where
                    consult_o.rsvno = :rsvno
                    and consult_o.ctrptcd = ctrpt_opt.ctrptcd 
                    and consult_o.optcd = ctrpt_opt.optcd 
                    and consult_o.optbranchno = ctrpt_opt.optbranchno 
                    and ctrpt_opt.setclasscd = free.freefield1 
                    and free.freecd like :freeset
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                freeset = freeSet
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }
    }
}
