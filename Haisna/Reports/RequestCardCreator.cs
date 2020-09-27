using Dapper;
using Hainsi.Common;
using Hainsi.ReportCore;
using Hos.CnDraw;
using Hos.CnDraw.Object;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    /// <summary>
    /// 依頼状生成クラス
    /// </summary>
    public class RequestCardCreator : PdfCreator
    {
        /// <summary>
        /// 判定分類コード（乳房）
        /// </summary>
        private const string JUDCLASSCD_BREAST = "24";

        /// <summary>
        /// 判定分類コード（婦人科）
        /// </summary>
        private const string JUDCLASSCD_GYNE = "31";

        /// <summary>
        /// 汎用コード（医師名）
        /// </summary>
        string FREECD_FOLDOCTOR = "FOLDOCTOR%";

        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd
        {
            get
            {
                switch (queryParams["judclasscd"])
                {
                    case JUDCLASSCD_BREAST:
                        // 乳房の依頼状
                        return "001030";
                    case JUDCLASSCD_GYNE:
                        // 婦人科の依頼状
                        return "001020";
                    default:
                        // 乳房、婦人科以外の依頼状
                        return "001010";
                }
            }
        }

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();
            string result;

            // 診断・依頼項目
            result = WebHains.CheckWideValue(
                "診断・依頼項目", queryParams["folitem"], 120, Common.Constants.Check.Necessary);
            if (result != null)
            {
                messages.Add(result + "（改行文字も含みます）");
            }

            // 所見
            result = WebHains.CheckWideValue("所見", queryParams["folnote"], 400);
            if (result != null)
            {
                messages.Add(result + "（改行文字も含みます）");
            }

            // 病医院名
            result = WebHains.CheckWideValue("病医院名", queryParams["secequipname"], 50);
            if (result != null)
            {
                messages.Add(result + "（改行文字も含みます）");
            }

            // 診療科
            result = WebHains.CheckWideValue(
                "診療科", queryParams["secequipcourse"], 50, Common.Constants.Check.Necessary);
            if (result != null)
            {
                messages.Add(result + "（改行文字も含みます）");
            }

            // 担当医師
            result = WebHains.CheckWideValue("担当医師", queryParams["secdoctor"], 40);
            if (result != null)
            {
                messages.Add(result + "（改行文字も含みます）");
            }

            // 住所
            result = WebHains.CheckLength("住所", queryParams["secequipaddr"], 120);
            if (result != null)
            {
                messages.Add(result + "（改行文字も含みます）");
            }

            // 電話番号
            result = WebHains.CheckLength("電話番号", queryParams["secequiptel"], 15);
            if (result != null)
            {
                messages.Add(result + "（改行文字も含みます）");
            }

            return messages;
        }

        /// <summary>
        /// 依頼状データを読み込む
        /// </summary>
        /// <returns>依頼状データ</returns>
        protected override List<dynamic> GetData()
        {
            // 乳房フォローアップ担当医師名を取得する
            string sql = @"
                select
                    freefield2 as doctorname 
                from
                    free 
                where
                    free.freecd like :freecd 
                    and free.freefield1 = :judclasscd 
                ";
            var sqlParam = new
            {
                freecd = FREECD_FOLDOCTOR,
                judclasscd = queryParams["judclasscd"],
            };
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();
            string folDoctorName = "";
            if (result != null)
            {
                folDoctorName = Util.ConvertToString(result.DOCTORNAME);
            }

            // 出力対象データを準備する
            var outputData = new
            {
                updUser = queryParams["upduser"],
                userName = queryParams["username"],
                rsvNo = queryParams["rsvno"],
                judClassCd = queryParams["judclasscd"],
                judClassName = queryParams["judclassname"],
                prtDiv = queryParams["prtdiv"],
                seq = queryParams["seq"],
                secEquipName = queryParams["secequipname"],
                secEquipCourse = queryParams["secequipcourse"],
                secDoctor = queryParams["secdoctor"],
                secEquipAddr = queryParams["secequipaddr"],
                secEquipTel = queryParams["secequiptel"],
                cslDate = queryParams["csldate"],
                perId = queryParams["perid"],
                age = queryParams["age"],
                dayId = queryParams["dayid"],
                name = queryParams["name"],
                kName = queryParams["kname"],
                birth = queryParams["birth"],
                gender = queryParams["gender"],
                folItem = queryParams["folitem"],
                folNote = queryParams["folnote"],
                folDoctorName = folDoctorName
            };

            // 出力対象データを戻す
            return new List<dynamic> {outputData};
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">依頼状データ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            // 出力対象データ
            var detail = data[0];

            // 依頼状１
            CnForm cnForm1 = cnForms[0];
            CnObjects cnObjects1 = cnForm1.CnObjects;
            var barLetterBarcodeField1 = (CnBarcodeField)cnObjects1["BARLETTER"];   // バーコード
            var letterNoField1 = (CnDataField)cnObjects1["LETTERNO"];               // バーコード番号(19桁)
            var hospitalField1 = (CnDataField)cnObjects1["HOSPITAL"];               // 医療機関名(他院)
            var departmentField1 = (CnDataField)cnObjects1["DEPARTMENT"];           // 診療科名
            var doctorField1 = (CnDataField)cnObjects1["DOCTOR"];                   // 担当医師名(他院)
            var judClassField1 = (CnDataField)cnObjects1["JUDCLASS"];               // 検査項目(一次)
            var patientField1 = (CnDataField)cnObjects1["PATIENT"];                 // 患者名
            var cslDateField1 = (CnDataField)cnObjects1["COCSLDATE"];               // 受診日
            var dayIdField1 = (CnDataField)cnObjects1["CODAYID"];                   // 当日ID
            var perIdField1 = (CnDataField)cnObjects1["COPERID"];                   // 患者ID
            var printDateField1 = (CnDataField)cnObjects1["PRINTDATE"];             // 依頼状作成日

            // 依頼状２
            CnForm cnForm2 = cnForms[1];
            CnObjects cnObjects2 = cnForm2.CnObjects;
            var printDateField2 = (CnDataField)cnObjects2["PRINTDATE"];             // 依頼状作成日
            var secEquipNameField2 = (CnDataField)cnObjects2["SECEQUIPNAME"];       // 医療機関名(他院)
            var secDoctorField2 = (CnDataField)cnObjects2["SECDOCTOR"];             // 担当医師名(他院)
            var kNameField2 = (CnDataField)cnObjects2["KNAME"];                     // カナ氏名
            var nameField2 = (CnDataField)cnObjects2["NAME"];                       // 氏名
            var cslDateField2 = (CnDataField)cnObjects2["CSLDATE"];                 // 受診日
            var ageField2 = (CnDataField)cnObjects2["AGE"];                         // 年齢
            var dayIdField2 = (CnDataField)cnObjects2["DAYID"];                     // 当日ID
            var birthField2 = (CnDataField)cnObjects2["BIRTH"];                     // 生年月日
            var genderField2 = (CnDataField)cnObjects2["GENDER"];                   // 性別
            var perIdField2 = (CnDataField)cnObjects2["PERID"];                     // 患者ID
            var folItemTextField2 = (CnTextField)cnObjects2["ITEM"];                // 診断・検査項目(一次)
            var folNoteTextField2 = (CnTextField)cnObjects2["NOTE"];                // 所見

            var secEquipCourseField2 = (CnDataField)null;                           // 診療科名(他院)
            var folDoctorField2 = (CnDataField)null;                                // 乳房フォロー医師名
            switch (queryParams["judclasscd"])
            {
                case JUDCLASSCD_BREAST:
                    // 乳房の依頼状
                    secEquipCourseField2 = (CnDataField)cnObjects2["SECEQUIPCOURSE"];
                    folDoctorField2 = (CnDataField)cnObjects2["FOLDOCTOR"];
                    break;
                case JUDCLASSCD_GYNE:
                    // 婦人科の依頼状
                    break;
                default:
                    // 乳房、婦人科以外の依頼状
                    secEquipCourseField2 = (CnDataField)cnObjects2["SECEQUIPCOURSE"];
                    break;
            }

            // 返信状
            CnForm cnForm3 = cnForms[2];
            CnObjects cnObjects3 = cnForm3.CnObjects;
            var kNameField3 = (CnDataField)cnObjects3["KNAME"];                     // カナ氏名
            var nameField3 = (CnDataField)cnObjects3["NAME"];                       // 氏名
            var cslDateField3 = (CnDataField)cnObjects3["CSLDATE"];                 // 受診日
            var ageField3 = (CnDataField)cnObjects3["AGE"];                         // 年齢
            var dayIdField3 = (CnDataField)cnObjects3["DAYID"];                     // 当日ID
            var birthField3 = (CnDataField)cnObjects3["BIRTH"];                     // 生年月日
            var genderField3 = (CnDataField)cnObjects3["GENDER"];                   // 性別
            var perIdField3 = (CnDataField)cnObjects3["PERID"];                     // 患者ID
            var replyBarcodeField3 = (CnBarcodeField)cnObjects3["BARREPLY"];        // バーコード
            var replyField3 = (CnDataField)cnObjects3["REPLYNO"];                   // バーコード番号(19桁)

            var planItemField3 = (CnDataField)null;                                 // 検査項目(一次)
            var reqDoctorField3 = (CnDataField)null;                                // 依頼医師名(依頼状印刷者)
            switch (queryParams["judclasscd"])
            {
                case JUDCLASSCD_BREAST:
                    // 乳房の依頼状
                    break;
                case JUDCLASSCD_GYNE:
                    // 婦人科の依頼状
                    reqDoctorField3 = (CnDataField)cnObjects3["REQDOCTOR"];
                    break;
                default:
                    // 乳房、婦人科以外の依頼状
                    planItemField3 = (CnDataField)cnObjects3["PLANITEM"];
                    break;
            }

            // 印刷日
            string printDate = "";
            switch (queryParams["judclasscd"])
            {
                case JUDCLASSCD_BREAST:
                    // 乳房の依頼状
                    printDate = DateTime.Today.ToString( "yyyy年 M月 d日");
                    break;
                case JUDCLASSCD_GYNE:
                    // 婦人科の依頼状
                    printDate = DateTime.Today.ToString("yyyy年 M月 d日");
                    break;
                default:
                    // 乳房、婦人科以外の依頼状
                    printDate = WebHains.EraDateFormat(DateTime.Today, "gg yy年 M月 d日");
                    break;
            }
            // 年齢
            string age = Util.ConvertToString(detail.age) + " 歳";
            // 受診日
            string cslDate = "";
            if (DateTime.TryParse(Util.ConvertToString(detail.cslDate), out DateTime tmpCslDate))
            {
                cslDate = tmpCslDate.ToString("yyyy年 M月 d日");
            }
            // 生年月日
            string birth = "";
            if (DateTime.TryParse(Util.ConvertToString(detail.birth), out DateTime tmpBirth))
            {
                birth = tmpBirth.ToString("yyyy年 M月 d日");
            }
            // バーコード
            string barcodeNo = "";
            Int32 tmpRsvNo = 0;
            Int32 tmpJudClassCd = 0;
            Int32 tmpPrtDiv = 0;
            Int32 tmpSeq = 0;
            if (Int32.TryParse(Util.ConvertToString(detail.rsvNo), out tmpRsvNo) &&
                Int32.TryParse(Util.ConvertToString(detail.judClassCd), out tmpJudClassCd) &&
                Int32.TryParse(Util.ConvertToString(detail.prtDiv), out tmpPrtDiv) &&
                Int32.TryParse(Util.ConvertToString(detail.seq), out tmpSeq))
            {
                barcodeNo = tmpRsvNo.ToString("000000000") + tmpJudClassCd.ToString("000") +
                    tmpPrtDiv.ToString("0") + tmpSeq.ToString("0000");
            }
            // 性別
            string gender = (Util.ConvertToString(detail.gender) == "1") ? "男" : "女";
            // 医師名
            string doctor = "";
            if (Util.ConvertToString(detail.secDoctor).Trim() != "")
            {
                doctor = Util.ConvertToString(detail.secDoctor).Trim() + "　先生御侍史";
            } else
            {
                doctor = "担当医　先生御侍史";
            }

            // キャンセルされた場合キャンセル用の例外をThrowする
            CheckCanceled();

            // 依頼状１
            barLetterBarcodeField1.SetData( "A" + barcodeNo + "A");
            letterNoField1.Text = "A" + barcodeNo + "A";
            hospitalField1.Text = Util.ConvertToString(detail.secEquipName).Trim();
            departmentField1.Text = Util.ConvertToString(detail.secEquipCourse).Trim();
            doctorField1.Text = doctor;
            judClassField1.Text = Util.ConvertToString(detail.judClassName).Trim();
            patientField1.Text = Util.ConvertToString(detail.name).Trim() + "　様";
            cslDateField1.Text = cslDate;
            dayIdField1.Text = Util.ConvertToString(detail.dayId).Trim();
            perIdField1.Text = Util.ConvertToString(detail.perId);
            printDateField1.Text = printDate;

            // キャンセルされた場合キャンセル用の例外をThrowする
            CheckCanceled();

            // 依頼状２
            printDateField2.Text = printDate;
            secEquipNameField2.Text = Util.ConvertToString(detail.secEquipName).Trim();
            secDoctorField2.Text = doctor;
            kNameField2.Text = Util.ConvertToString(detail.kName).Trim();
            nameField2.Text = Util.ConvertToString(detail.name).Trim();
            cslDateField2.Text = cslDate;
            ageField2.Text = age;
            dayIdField2.Text = "( " + Util.ConvertToString(detail.dayId).Trim() + " )";
            birthField2.Text = birth;
            genderField2.Text = gender;
            perIdField2.Text = Util.ConvertToString(detail.perId);
            folItemTextField2.Text = Util.ConvertToString(detail.folItem).Trim();
            folNoteTextField2.Text = Util.ConvertToString(detail.folNote).Trim();

            switch (queryParams["judclasscd"])
            {
                case JUDCLASSCD_BREAST:
                    // 乳房の依頼状
                    secEquipCourseField2.Text = Util.ConvertToString(detail.secEquipCourse).Trim();
                    folDoctorField2.Text = Util.ConvertToString(detail.folDoctorName).Trim();
                    break;
                case JUDCLASSCD_GYNE:
                    // 婦人科の依頼状
                    break;
                default:
                    // 乳房、婦人科以外の依頼状
                    secEquipCourseField2.Text = Util.ConvertToString(detail.secEquipCourse).Trim();
                    break;
            }

            // キャンセルされた場合キャンセル用の例外をThrowする
            CheckCanceled();

            // 返信状
            kNameField3.Text = Util.ConvertToString(detail.kName).Trim();
            nameField3.Text = Util.ConvertToString(detail.name).Trim();
            cslDateField3.Text = cslDate;
            ageField3.Text = age;
            dayIdField3.Text = "( " + Util.ConvertToString(detail.dayId).Trim() + " )";
            birthField3.Text = birth;
            genderField3.Text = gender;
            perIdField3.Text = Util.ConvertToString(detail.perId);
            replyBarcodeField3.SetData("A" + barcodeNo + "A");
            replyField3.Text = "A" + barcodeNo + "A";

            switch (queryParams["judclasscd"])
            {
                case JUDCLASSCD_BREAST:
                    // 乳房の依頼状
                    break;
                case JUDCLASSCD_GYNE:
                    // 婦人科の依頼状
                    reqDoctorField3.Text = Util.ConvertToString(detail.userName).Trim();
                    break;
                default:
                    // 乳房、婦人科以外の依頼状
                    planItemField3.Text = Util.ConvertToString(detail.judClassName).Trim();
                    break;
            }

            // ドキュメントを出力する
            // 依頼状１
            PrintOut(cnForm1);
            // 依頼状２
            PrintOut(cnForm2);
            // 返信状
            PrintOut(cnForm3);
        }
    }
}
