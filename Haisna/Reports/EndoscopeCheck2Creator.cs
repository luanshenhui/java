using Dapper;
using Hainsi.Common;
using Hainsi.ReportCore;
using Hainsi.Common.Constants;
using Hos.CnDraw;
using Hos.CnDraw.Object;
using Hos.CnDraw.Constants;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    /// <summary>
    /// 内視鏡チェックリスト生成クラス
    /// </summary>
    public class EndoscopeCheck2Creator : PdfCreator
    {
        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002190";

        /// <summary>
        /// 対象コースコード
        /// </summary>
        private const string CSCD1 = "100";
        private const string CSCD2 = "105";
        private const string CSCD3 = "110";

        /// <summary>
        /// 胃内視鏡(MAP)グループコード
        /// </summary>
        private const string M_GRPCD = "M622";

        /// <summary>
        /// 胃内視鏡リストグループコード
        /// </summary>
        private const string L_GRPCD = "X402";

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            DateTime wkDate;
            if (!DateTime.TryParse(queryParams["csldate"], out wkDate))
            {
                messages.Add("受診日が正しくありません。");
            }

            if (string.IsNullOrEmpty(queryParams["dayid"]))
            {
                messages.Add("当日IDを入力してください。");
            }

            int wkID;
            if (!int.TryParse(queryParams["dayid"], out wkID))
            {
                messages.Add("当日IDが正しくありません。");
            }

            return messages;
        }

        /// <summary>
        /// 内視鏡チェックリストデータを読み込む
        /// </summary>
        /// <returns>内視鏡チェックリストデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        to_char(consult.csldate, 'YYYY/MM/DD') as csldate
                        , receipt.dayid as dayid
                        , person.lastkname as lastkname
                        , person.firstkname as firstkname
                        , person.lastname as lastname
                        , person.firstname as firstname
                        , person.birth
                        , trunc( 
                            getcslage( 
                                person.birth
                                , consult.csldate
                                , to_char(consult.csldate, 'YYYYMMDD')
                            )
                        ) as age
                        , person.gender as gender
                        , person.perid as perid
                        , consult.rsvno as rsvno
                        , fc_get_result(consult.rsvno, '23350', '00') as s23350
                        , fc_get_result(consult.rsvno, '23351', '00') as s23351
                        , fc_get_result(consult.rsvno, '23352', '00') as s23352
                        , fc_get_result(consult.rsvno, '23353', '00') as s23353
                        , fc_get_result(consult.rsvno, '23354', '00') as s23354
                        , fc_get_result(consult.rsvno, '23355', '00') as s23355
                        , fc_get_result(consult.rsvno, '23357', '00') as s23357
                        , fc_get_result(consult.rsvno, '23359', '00') as s23359
                        , fc_get_result_code(consult.rsvno, '23350', '00') as c23350
                        , fc_get_result_code(consult.rsvno, '23351', '00') as c23351
                        , fc_get_result_code(consult.rsvno, '23352', '00') as c23352
                        , fc_get_result_code(consult.rsvno, '23353', '00') as c23353
                        , fc_get_result_code(consult.rsvno, '23354', '00') as c23354
                        , fc_get_result_code(consult.rsvno, '23355', '00') as c23355
                        , fc_get_result_code(consult.rsvno, '23357', '00') as c23357
                        , fc_get_result_code(consult.rsvno, '23359', '00') as c23359
                        , fc_get_result_code(consult.rsvno, '13120', '01') as c1312001
                        , fc_get_result_code(consult.rsvno, '13120', '02') as c1312002
                        , fc_get_result_code(consult.rsvno, '10060', '00') as c10060
                        , fc_get_result_code(consult.rsvno, '11161', '01') as c1116101
                        , fc_get_result_code(consult.rsvno, '11161', '02') as c1116102
                        , fc_get_result(consult.rsvno, '65110', '01') as s6511001
                        , fc_get_result_code(consult.rsvno, '65110', '02') as c6511002
                        , fc_get_result(consult.rsvno, '65110', '03') as s6511003
                        , fc_get_result(consult.rsvno, '65111', '01') as s6511101
                        , fc_get_result_code(consult.rsvno, '65111', '02') as c6511102
                        , fc_get_result(consult.rsvno, '65111', '03') as s6511103
                        , fc_get_result(consult.rsvno, '65112', '01') as s6511201
                        , fc_get_result_code(consult.rsvno, '65112', '02') as c6511202
                        , fc_get_result(consult.rsvno, '65112', '03') as s6511203
                        , fc_get_result(consult.rsvno, '65113', '01') as s6511301
                        , fc_get_result_code(consult.rsvno, '65113', '02') as c6511302
                        , fc_get_result(consult.rsvno, '65113', '03') as s6511303
                        , fc_get_result(consult.rsvno, '65114', '01') as s6511401
                        , fc_get_result_code(consult.rsvno, '65114', '02') as c6511402
                        , fc_get_result(consult.rsvno, '65114', '03') as s6511403
                        , fc_get_result(consult.rsvno, '65115', '01') as s6511501
                        , fc_get_result_code(consult.rsvno, '65115', '02') as c6511502
                        , fc_get_result(consult.rsvno, '65115', '03') as s6511503
                        , fc_get_result(consult.rsvno, '65120', '01') as s6512001
                        , fc_get_result_code(consult.rsvno, '65120', '02') as c6512002
                        , fc_get_result(consult.rsvno, '65120', '03') as s6512003
                        , fc_get_result(consult.rsvno, '65121', '01') as s6512101
                        , fc_get_result_code(consult.rsvno, '65121', '02') as c6512102
                        , fc_get_result(consult.rsvno, '65121', '03') as s6512103
                        , fc_get_result(consult.rsvno, '65122', '01') as s6512201
                        , fc_get_result_code(consult.rsvno, '65122', '02') as c6512202
                        , fc_get_result(consult.rsvno, '65122', '03') as s6512203
                        , fc_get_result(consult.rsvno, '65123', '01') as s6512301
                        , fc_get_result_code(consult.rsvno, '65123', '02') as c6512302
                        , fc_get_result(consult.rsvno, '65123', '03') as s6512303
                        , fc_get_result(consult.rsvno, '65124', '01') as s6512401
                        , fc_get_result_code(consult.rsvno, '65124', '02') as c6512402
                        , fc_get_result(consult.rsvno, '65124', '03') as s6512403
                        , fc_get_result(consult.rsvno, '65125', '01') as s6512501
                        , fc_get_result_code(consult.rsvno, '65125', '02') as c6512502
                        , fc_get_result(consult.rsvno, '65125', '03') as s6512503
                        , fc_get_result_code(final.rsvno, '23390', '01') as c2339001
                        , fc_get_result_code(final.rsvno, '23390', '11') as c2339011
                        , fc_get_result_code(final.rsvno, '23390', '02') as c2339002
                        , fc_get_result_code(final.rsvno, '23390', '03') as c2339003 
                    from
                        consult
                        , receipt
                        , person
                        , ( 
                            select
                                lastview.seq
                                , lastview.csldate
                                , lastview.rsvno
                                , lastview.perid 
                            from
                                ( 
                                    select
                                        rownum seq
                                        , csldate
                                        , rsvno
                                        , perid 
                                    from
                                        ( 
                                            select distinct
                                                consult.csldate
                                                , consult.rsvno
                                                , consult.perid 
                                            from
                                                consult
                                                , receipt
                                                , grp_i
                                                , rsl 
                                            where
                                                consult.perid = ( 
                                                    select
                                                        consult.perid 
                                                    from
                                                        consult
                                                        , receipt 
                                                    where
                                                        receipt.csldate = :csldate 
                                                        and receipt.dayid = :dayid
                                                        and receipt.rsvno = consult.rsvno
                                                ) 
                                                and consult.csldate < :csldate 
                                                and consult.cancelflg = :cancelflg
                                                and consult.cscd in (:cscd1, :cscd2, :cscd3) 
                                                and consult.rsvno = receipt.rsvno 
                                                and receipt.comedate is not null 
                                                and consult.rsvno = rsl.rsvno 
                                                and grp_i.grpcd = :grpcd 
                                                and grp_i.itemcd = rsl.itemcd 
                                                and grp_i.suffix = rsl.suffix 
                                            order by
                                                consult.csldate desc
                                        )
                                ) lastview 
                            where
                                lastview.seq = 1
                        ) final 
                    where
                        consult.csldate = :csldate
                        and consult.cancelflg = :cancelflg 
                        and consult.rsvno = receipt.rsvno 
                        and receipt.dayid = :dayid
                        and consult.perid = person.perid 
                        and consult.perid = final.perid(+)
                ";

            // パラメータセット
            var sqlParam = new
            {
                csldate = queryParams["csldate"],
                dayid = queryParams["dayid"],
                cancelflg = ConsultCancel.Used,
                cscd1 = CSCD1,
                cscd2 = CSCD2,
                cscd3 = CSCD3,
                grpcd = M_GRPCD
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">内視鏡チェックリストデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var csldateField = (CnDataField)cnObjects["CSLDATE"];
            var birthField = (CnDataField)cnObjects["BIRTH"];
            var ageField = (CnDataField)cnObjects["AGE"];
            var genderField = (CnDataField)cnObjects["GENDER"];
            var peridField = (CnDataField)cnObjects["PERID"];
            var dayidField = (CnDataField)cnObjects["DAYID"];
            var knameField = (CnDataField)cnObjects["KNAME"];
            var nameField = (CnDataField)cnObjects["NAME"];

            // 問診
            var s23350Field = (CnDataField)cnObjects["s23350"];
            var s23351Field = (CnDataField)cnObjects["s23351"];
            var s23352Field = (CnDataField)cnObjects["s23352"];
            var s23353Field = (CnDataField)cnObjects["s23353"];
            var s23354Field = (CnDataField)cnObjects["s23354"];
            var s23359Field = (CnDataField)cnObjects["s23359"];
            var s23355Field = (CnDataField)cnObjects["s23355"];
            var s23357Field = (CnDataField)cnObjects["s23357"];

            var longstcListField = (CnListField)cnObjects["longstc"];

            // 現病歴
            var s6511001Field = (CnDataField)cnObjects["s6511001"];
            var s6511101Field = (CnDataField)cnObjects["s6511101"];
            var s6511201Field = (CnDataField)cnObjects["s6511201"];
            var s6511301Field = (CnDataField)cnObjects["s6511301"];
            var s6511401Field = (CnDataField)cnObjects["s6511401"];
            var s6511501Field = (CnDataField)cnObjects["s6511501"];

            var c6511002Field = (CnDataField)cnObjects["c6511002"];
            var c6511102Field = (CnDataField)cnObjects["c6511102"];
            var c6511202Field = (CnDataField)cnObjects["c6511202"];
            var c6511302Field = (CnDataField)cnObjects["c6511302"];
            var c6511402Field = (CnDataField)cnObjects["c6511402"];
            var c6511502Field = (CnDataField)cnObjects["c6511502"];

            var s6511003Field = (CnDataField)cnObjects["s6511003"];
            var s6511103Field = (CnDataField)cnObjects["s6511103"];
            var s6511203Field = (CnDataField)cnObjects["s6511203"];
            var s6511303Field = (CnDataField)cnObjects["s6511303"];
            var s6511403Field = (CnDataField)cnObjects["s6511403"];
            var s6511503Field = (CnDataField)cnObjects["s6511503"];

            // 既往歴
            var s6512001Field = (CnDataField)cnObjects["s6512001"];
            var s6512101Field = (CnDataField)cnObjects["s6512101"];
            var s6512201Field = (CnDataField)cnObjects["s6512201"];
            var s6512301Field = (CnDataField)cnObjects["s6512301"];
            var s6512401Field = (CnDataField)cnObjects["s6512401"];
            var s6512501Field = (CnDataField)cnObjects["s6512501"];

            var c6512002Field = (CnDataField)cnObjects["c6512002"];
            var c6512102Field = (CnDataField)cnObjects["c6512102"];
            var c6512202Field = (CnDataField)cnObjects["c6512202"];
            var c6512302Field = (CnDataField)cnObjects["c6512302"];
            var c6512402Field = (CnDataField)cnObjects["c6512402"];
            var c6512502Field = (CnDataField)cnObjects["c6512502"];

            var s6512003Field = (CnDataField)cnObjects["s6512003"];
            var s6512103Field = (CnDataField)cnObjects["s6512103"];
            var s6512203Field = (CnDataField)cnObjects["s6512203"];
            var s6512303Field = (CnDataField)cnObjects["s6512303"];
            var s6512403Field = (CnDataField)cnObjects["s6512403"];
            var s6512503Field = (CnDataField)cnObjects["s6512503"];

            // 血圧、眼圧
            var c1312001Field = (CnDataField)cnObjects["c1312001"];
            var c1312002Field = (CnDataField)cnObjects["c1312002"];
            var c10060Field = (CnDataField)cnObjects["c10060"];
            var c1116101Field = (CnDataField)cnObjects["c1116101"];
            var c1116102Field = (CnDataField)cnObjects["c1116102"];

            // 処置オーダ（前回）
            var c2339001kField = (CnDataField)cnObjects["c2339001K"];
            var c2339011kField = (CnDataField)cnObjects["c2339011K"];
            var c2339002kField = (CnDataField)cnObjects["c2339002K"];
            var c2339003kField = (CnDataField)cnObjects["c2339003K"];
            var c2339001Field = (CnDataField)cnObjects["c2339001"];
            var c2339011Field = (CnDataField)cnObjects["c2339011"];
            var c2339002Field = (CnDataField)cnObjects["c2339002"];
            var c2339003Field = (CnDataField)cnObjects["c2339003"];

            string rsvNo;

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // 受診日
                if (DateTime.TryParse(Util.ConvertToString(queryParams["csldate"]), out DateTime dt))
                {
                    csldateField.Text = dt.ToString("yyyy/MM/dd");
                }
                // 生年月日
                if (DateTime.TryParse(Util.ConvertToString(detail.BIRTH), out DateTime birth))
                {
                    birthField.Text =
                    WebHains.GetShortEraName(birth) + WebHains.EraDateFormat(birth, "yy") + birth.ToString("(yyyy)/MM/dd");
                }
                // 年齢
                ageField.Text = Util.ConvertToString(detail.AGE);
                // 性別
                genderField.Text = (Util.ConvertToString(detail.GENDER) == "1") ? "男性" : "女性";
                // 患者ID
                peridField.Text = Util.ConvertToString(detail.PERID);
                // 当日ID
                dayidField.Text = Util.ConvertToString(detail.DAYID);
                // フリガナ
                knameField.Text = Util.ConvertToString(detail.LASTKNAME).Trim() + " " + Util.ConvertToString(detail.FIRSTKNAME).Trim();
                // 氏名
                nameField.Text = Util.ConvertToString(detail.LASTNAME).Trim() + "　" + Util.ConvertToString(detail.FIRSTNAME).Trim();

                // 問診1-1
                s23350Field.Text = Util.ConvertToString(detail.S23350);
                if (Util.ConvertToString(detail.C23350) == "0")
                {    
                    s23350Field.FillPattern = ConFillPattern.Pattern6;
                }
                else
                {
                    s23350Field.FillPattern = ConFillPattern.None;
                }
                // 問診1-2
                s23351Field.Text = Util.ConvertToString(detail.S23351);
                if (Util.ConvertToString(detail.C23351) == "1")
                {
                    s23351Field.FillPattern = ConFillPattern.Pattern6;
                }
                else
                {
                    s23351Field.FillPattern = ConFillPattern.None;
                }
                // 問診1-3;
                s23352Field.Text = Util.ConvertToString(detail.S23352);
                if (Util.ConvertToString(detail.C23352) == "1")
                {
                    s23352Field.FillPattern = ConFillPattern.Pattern6;
                }
                else
                {
                    s23352Field.FillPattern = ConFillPattern.None;
                }
                // 問診1-4
                s23353Field.Text = Util.ConvertToString(detail.S23353);
                if (Util.ConvertToString(detail.C23353) == "0" || Util.ConvertToString(detail.C23353) == "2")
                {
                    s23353Field.FillPattern = ConFillPattern.Pattern6;
                }
                else
                {
                    s23353Field.FillPattern = ConFillPattern.None;
                }
                // 問診1-5
                s23354Field.Text = Util.ConvertToString(detail.S23354);
                if (Util.ConvertToString(detail.C23354) == "0")
                {
                    s23354Field.FillPattern = ConFillPattern.Pattern6;
                }
                else
                {
                    s23354Field.FillPattern = ConFillPattern.None;
                }
                // 問診1-6
                s23359Field.Text = Util.ConvertToString(detail.S23359);
                if (Util.ConvertToString(detail.C23359) == "0")
                {
                    s23359Field.FillPattern = ConFillPattern.Pattern6;
                }
                else
                {
                    s23359Field.FillPattern = ConFillPattern.None;
                }
                // 問診1-7
                s23355Field.Text = Util.ConvertToString(detail.S23355);
                if (Util.ConvertToString(detail.C23355) == "0")
                {
                    s23355Field.FillPattern = ConFillPattern.Pattern6;
                }
                else
                {
                    s23355Field.FillPattern = ConFillPattern.None;
                }
                // 問診1-8
                s23357Field.Text = Util.ConvertToString(detail.S23357);
                if (Util.ConvertToString(detail.C23357) == "0" || Util.ConvertToString(detail.C23357) == "2")
                {
                    s23357Field.FillPattern = ConFillPattern.Pattern6;
                }
                else
                {
                    s23357Field.FillPattern = ConFillPattern.None;
                }

                // 予約番号退避（パラメタ用）
                rsvNo = Util.ConvertToString(detail.RSVNO);

                // 問診2
                short currentLine = 0;
                foreach (var monshinData in GetMonshin(rsvNo))
                {
                    if (currentLine >= longstcListField.ListRows.Length)
                    {
                        break;
                    }

                    longstcListField.ListCell(0, currentLine).Text = Util.ConvertToString(monshinData.LONGSTC);
                    currentLine++;
                }

                // 現病歴/病名
                s6511001Field.Text = Util.ConvertToString(detail.S6511001);
                s6511101Field.Text = Util.ConvertToString(detail.S6511101);
                s6511201Field.Text = Util.ConvertToString(detail.S6511201);
                s6511301Field.Text = Util.ConvertToString(detail.S6511301);
                s6511401Field.Text = Util.ConvertToString(detail.S6511401);
                s6511501Field.Text = Util.ConvertToString(detail.S6511501);

                // 現病歴/年齢
                c6511002Field.Text = Util.ConvertToString(detail.C6511002);
                c6511102Field.Text = Util.ConvertToString(detail.C6511102);
                c6511202Field.Text = Util.ConvertToString(detail.C6511202);
                c6511302Field.Text = Util.ConvertToString(detail.C6511302);
                c6511402Field.Text = Util.ConvertToString(detail.C6511402);
                c6511502Field.Text = Util.ConvertToString(detail.C6511502);

                // 現病歴/状況
                s6511003Field.Text = Util.ConvertToString(detail.S6511003);
                s6511103Field.Text = Util.ConvertToString(detail.S6511103);
                s6511203Field.Text = Util.ConvertToString(detail.S6511203);
                s6511303Field.Text = Util.ConvertToString(detail.S6511303);
                s6511403Field.Text = Util.ConvertToString(detail.S6511403);
                s6511503Field.Text = Util.ConvertToString(detail.S6511503);


                // 既往歴/病名
                s6512001Field.Text = Util.ConvertToString(detail.S6512001);
                s6512101Field.Text = Util.ConvertToString(detail.S6512101);
                s6512201Field.Text = Util.ConvertToString(detail.S6512201);
                s6512301Field.Text = Util.ConvertToString(detail.S6512301);
                s6512401Field.Text = Util.ConvertToString(detail.S6512401);
                s6512501Field.Text = Util.ConvertToString(detail.S6512501);

                // 既往歴/年齢
                c6512002Field.Text = Util.ConvertToString(detail.C6512002);
                c6512102Field.Text = Util.ConvertToString(detail.C6512102);
                c6512202Field.Text = Util.ConvertToString(detail.C6512202);
                c6512302Field.Text = Util.ConvertToString(detail.C6512302);
                c6512402Field.Text = Util.ConvertToString(detail.C6512402);
                c6512502Field.Text = Util.ConvertToString(detail.C6512502);

                // 既往歴/状況
                s6512003Field.Text = Util.ConvertToString(detail.S6512003);
                s6512103Field.Text = Util.ConvertToString(detail.S6512103);
                s6512203Field.Text = Util.ConvertToString(detail.S6512203);
                s6512303Field.Text = Util.ConvertToString(detail.S6512303);
                s6512403Field.Text = Util.ConvertToString(detail.S6512403);
                s6512503Field.Text = Util.ConvertToString(detail.S6512503);


                // 血圧収縮期
                c1312001Field.Text = Util.ConvertToString(detail.C1312001);
                c1312001Field.FillPattern = ConFillPattern.None;
                if (int.TryParse(Util.ConvertToString(detail.C1312001), out int tempBPH))
                {
                    if (tempBPH > 179)
                    {
                        c1312001Field.FillPattern = ConFillPattern.Pattern6;
                    }
                }

                // 血圧拡張期
                c1312002Field.Text = Util.ConvertToString(detail.C1312002);
                c1312002Field.FillPattern = ConFillPattern.None;
                if (int.TryParse(Util.ConvertToString(detail.C1312002), out int tempBPL))
                {
                    if (tempBPL > 109)
                    {
                        c1312002Field.FillPattern = ConFillPattern.Pattern6;
                    }
                }

                // 脈拍
                c10060Field.Text = Util.ConvertToString(detail.C10060);

                // 眼圧右
                c1116101Field.Text = Util.ConvertToString(detail.C1116101);
                c1116101Field.FillPattern = ConFillPattern.None;
                if (int.TryParse(Util.ConvertToString(detail.C1116101), out int tempEPR))
                {
                    if (tempEPR > 20)
                    {
                        c1116101Field.FillPattern = ConFillPattern.Pattern6;
                    }
                }

                // 眼圧左
                c1116102Field.Text = Util.ConvertToString(detail.C1116102);
                c1116102Field.FillPattern = ConFillPattern.None;
                if (int.TryParse(Util.ConvertToString(detail.C1116102), out int tempEPL))
                {
                    if (tempEPL > 20)
                    {
                        c1116102Field.FillPattern = ConFillPattern.Pattern6;
                    }
                }


                // 処置オーダ（前回）
                // ブスコパン
                if (string.IsNullOrEmpty(Util.ConvertToString(detail.C2339001).Trim()))
                {
                    c2339001kField.Text = "□";
                }
                else
                {
                    c2339001kField.Text = "■";
                }
                c2339001Field.Text = Util.ConvertToString(detail.C2339001);

                // スポラミン
                if (string.IsNullOrEmpty(Util.ConvertToString(detail.C2339011).Trim()))
                {
                    c2339011kField.Text = "□";
                }
                else
                {
                    c2339011kField.Text = "■";
                }
                c2339011Field.Text = Util.ConvertToString(detail.C2339011);

                // グルカゴン
                if (string.IsNullOrEmpty(Util.ConvertToString(detail.C2339002).Trim()))
                {
                    c2339002kField.Text = "□";
                }
                else
                {
                    c2339002kField.Text = "■";
                }
                c2339002Field.Text = Util.ConvertToString(detail.C2339002);

                // ドリミカム
                if (string.IsNullOrEmpty(Util.ConvertToString(detail.C2339003).Trim()))
                {
                    c2339003kField.Text = "□";
                }
                else
                {
                    c2339003kField.Text = "■";
                }
                c2339003Field.Text = Util.ConvertToString(detail.C2339003);


                // ドキュメントの出力
                PrintOut(cnForm);

            }
        }

        /// <summary>
        /// 問診データ取得
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <returns></returns>
        private dynamic GetMonshin(string rsvNo)
        {
            // SQLステートメント定義
            string sql = @"
                    select
                        sentence.longstc as longstc 
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
                        and rsl.itemcd = item_c.itemcd 
                        and rsl.suffix = item_c.suffix 
                        and item_c.stcitemcd = sentence.itemcd 
                        and item_c.itemtype = sentence.itemtype 
                        and rsl.result = sentence.stccd 
                    order by
                        grp_i.seq
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                grpcd = L_GRPCD
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();

        }
    }
}
