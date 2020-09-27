using Dapper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity;
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
    /// 予約確認はがき(英語)生成クラス
    /// </summary>
    public class ReservePcard_eCreator : PdfCreator
    {

        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002400";

        /// <summary>
        /// 汎用コード
        /// </summary>
        private const string FREECD_CSLDIV = "CSLSNM%";     //受診区分取得用    
        private const string FREECD_CSCD = "LST000020%";    //コースコード取得用
        private const string FREECD_IBU = "LST000022%";    //胃検査取得用
        private const string FREECD_OPT = "LST000021%";    //胃検査取得用

        /// <summary>
        /// 汎用分類コード
        /// </summary>
        private const string FREECLASSCD_CSCD = "LST";  //コースコード取得用
        private const string FREECLASSCD_PRINTER = "YUDOPRINTER";  //誘導システムプリンタ

        /// <summary>
        /// オプションコード
        /// </summary>
        private const string OPTCD_CODE01 = "1000";
        private const string OPTCD_CODE02 = "1001";

        /// <summary>
        /// グループコード
        /// </summary>
        private const string GRPCD_IBU = "X502";    //胃検査
        
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
        /// 予約確認はがき(英語)データを読み込む
        /// </summary>
        /// <returns>予約確認はがき(英語)データ</returns>
        protected override List<dynamic> GetData()
        {
            //■プリンタ設定
            string prtPrinterName = "";
            string ipAdr = queryParams["ipAddress"];

            //帳票マスタからデフォルトプリンタ情報を取得する。
            var reportDao = new ReportDao(connection);
            dynamic reportRec = reportDao.SelectReport(ReportCd);
            if (reportRec != null)
            {
                //デフォルトプリンターを設定
                prtPrinterName = reportRec.DEFAULTPRINTER;
            }

            //出力先プリンタを取得する（汎用マスタ）
            var freeDao = new FreeDao(connection);
            IList<dynamic> freeRec = freeDao.SelectFreeByClassCd(0, FREECLASSCD_PRINTER);

            foreach (var rec in freeRec)
            {
                //IPアドレスが一致した場合
                if (ipAdr == rec.FREEFIELD1)
                {
                    //プリンタ名を取得して処理を抜ける
                    prtPrinterName = rec.FREEFIELD2;
                    break;
                }
            }
            if (!string.IsNullOrEmpty(prtPrinterName))
            {
                //プリンタ名がある場合、プリンタ名を設定。直接印刷対象とする
                SetPrinter(prtPrinterName);
            }

            //■SQLステートメント定義
            string sql = @"
                select distinct
                    peraddr3.zipcd as zipcd
                    , peraddr3.cityname as cityname
                    , peraddr3.address1 as address1
                    , peraddr3.address2 as address2
                    , person.lastname || '　' || person.firstname || '　様' as name
                    , person.romename as romename
                    , person.gender as gender
                    , person.birth as birth
                    , person.perid as perid
                    , peraddr1.tel1 as tel1
                    , peraddr2.tel1 as tel1_1
                    , peraddr1.phone as phone
                    , consult.csldate as csldate
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
                    , consult.ctrptcd as ctrptcd
                    , consult.cscd as cscd
                    , rsvgrp.strtime as strtime
                    , org.orgename as orgename
                    , ctrpt.csename as csename
                    , consult.rsvgrpcd as rsvgrpcd
                    , nvl( 
                        ( 
                            select
                                nvl(free.freefield3, 'Oneday medical checkup') 
                            from
                                free 
                            where
                                freecd like :freecd_csldiv 
                                and freefield1 = consult.csldivcd
                        ) 
                        , 'Oneday medical checkup'
                    ) as csldiv 
                from
                    peraddr peraddr1
                    , peraddr peraddr2
                    , peraddr peraddr3
                    , person
                    , consult
                    , rsvgrp
                    , org
                    , ctrpt
                    , free
                    , course_rsvgrp
                    , consult_o
                    , ctrpt_opt 
                where
                    consult.rsvno = :rsvno
                    and '0' = :actmode
                    and consult.prtonsave = '1' 
                    and person.perid = consult.perid 
                    and peraddr1.perid = consult.perid 
                    and peraddr1.addrdiv = '1' 
                    and peraddr2.perid(+) = consult.perid 
                    and peraddr2.addrdiv(+) = '2' 
                    and peraddr3.perid(+) = consult.perid 
                    and peraddr3.addrdiv(+) = consult.cardaddrdiv 
                    and rsvgrp.rsvgrpcd = consult.rsvgrpcd 
                    and org.orgcd1 = consult.orgcd1 
                    and org.orgcd2 = consult.orgcd2 
                    and ctrpt.ctrptcd = consult.ctrptcd 
                    and consult.cancelflg = :cancelflg  
                    and free.freecd like :freecd_cscd
                    and free.freeclasscd = :freeclasscd_cscd
                    and free.freefield1 = consult.cscd 
                    and course_rsvgrp.cscd = consult.cscd 
                    and course_rsvgrp.rsvgrpcd = consult.rsvgrpcd 
                    and consult.rsvno = consult_o.rsvno 
                    and consult_o.ctrptcd = ctrpt_opt.ctrptcd 
                    and consult_o.optcd = ctrpt_opt.optcd 
                    and consult_o.optbranchno = ctrpt_opt.optbranchno 
                    and consult_o.optcd in (:optcd_code01, :optcd_code02)

                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = queryParams["rsvno"],
                actmode = queryParams["actmode"],

                freecd_csldiv = FREECD_CSLDIV,
                freecd_cscd = FREECD_CSCD,
                freeclasscd_cscd = FREECLASSCD_CSCD,
                optcd_code01 = OPTCD_CODE01,
                optcd_code02 = OPTCD_CODE02,

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

            //出力先プリンタを取得する（汎用マスタ）
            string prtPrinterName = "";
            string ipAdr = queryParams["ipAddress"];

            var freeDao = new FreeDao(connection);

            IList<dynamic> freeRec = freeDao.SelectFreeByClassCd(0, FREECLASSCD_PRINTER);

            foreach (var rec in freeRec)
            {
                //IPアドレスが一致した場合
                if ( ipAdr == rec.FREEFIELD1)
                {
                    //プリンタ名を取得して処理を抜ける
                    prtPrinterName = rec.FREEFIELD2;
                    break;
                }
            }

            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var zipcdField = (CnDataField)cnObjects["ZIPCD"];
            var citynameField = (CnDataField)cnObjects["CITYNAME"];
            var addressTextField = (CnTextField)cnObjects["ADDRESS"];
            var nameTextField = (CnTextField)cnObjects["NAME"];
            var romenameField = (CnDataField)cnObjects["ROMENAME"];
            var genderField = (CnDataField)cnObjects["GENDER"];
            var birthField = (CnDataField)cnObjects["BIRTH"];
            var peridField = (CnDataField)cnObjects["PERID"];
            var tel1Field = (CnDataField)cnObjects["TEL1"];
            var tel1_1Field = (CnDataField)cnObjects["TEL1_1"];
            var phoneField = (CnDataField)cnObjects["PHONE"];
            var csldateField = (CnDataField)cnObjects["CSLDATE"];
            var eyobiField = (CnDataField)cnObjects["EYOBI"];
            var aaaField = (CnDataField)cnObjects["AAA"];
            var strtime1Field = (CnDataField)cnObjects["STRTIME1"];
            var bbbField = (CnDataField)cnObjects["BBB"];
            var strtime2Field = (CnDataField)cnObjects["STRTIME2"];
            var cccField = (CnDataField)cnObjects["CCC"];
            var strtime3Field = (CnDataField)cnObjects["STRTIME3"];
            var dddField = (CnDataField)cnObjects["DDD"];
            var strtime4Field = (CnDataField)cnObjects["STRTIME4"];
            var orgenameField = (CnDataField)cnObjects["ORGENAME"];
            var csenameField = (CnDataField)cnObjects["CSENAME"];
            var ikensaeField = (CnDataField)cnObjects["IKENSAE"];
            var freeField3ListField = (CnListField)cnObjects["FREEFIELD3"];
            var csldivField = (CnDataField)cnObjects["CSLDIV"];

            string sysdate = DateTime.Today.ToShortDateString();

            int pageNo = 0;

            //予約番号の取得
            int.TryParse(queryParams["rsvno"], out int rsvno);

            // ページ内の項目に値をセット
            foreach ( var detail in data )
            {

                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                //郵便番号
                if  ( Convert.ToString(detail.ZIPCD).Substring(0, 4).Trim() == "")
                {
                    zipcdField.Text = Util.ConvertToString(detail.ZIPCD).Trim();
                }
                else
                {
                    zipcdField.Text = Convert.ToString(detail.ZIPCD).Substring(0, 3) + "-" + Convert.ToString(detail.ZIPCD).Substring(3, 4);
                }

                //市区町村名
                citynameField.Text = Util.ConvertToString(detail.CITYNAME).Trim();

                //住所
                addressTextField.Text = Util.ConvertToString(detail.ADDRESS1).Trim() + "　" + Util.ConvertToString(detail.ADDRESS2).Trim();

                //宛先
                nameTextField.Text = Util.ConvertToString(detail.NAME).Trim();

                //ローマ字氏名
                romenameField.Text = Util.ConvertToString(detail.ROMENAME).Trim();

                //性別
                if (detail.GENDER == 1)
                {
                    genderField.Text = "(male)";
                }
                else
                {
                    genderField.Text = "(female)";
                }

                //生年月日
                if (DateTime.TryParse(Util.ConvertToString(detail.BIRTH), out DateTime birth))
                {
                    birthField.Text = birth.ToString("yyyy/MM/dd");
                }

                //患者ＩＤ
                if (Convert.ToString(detail.PERID).Substring(0, 1) == "@")
                {
                    peridField.Text = "";
                }
                else
                {
                    peridField.Text = Util.ConvertToString(detail.PERID);
                }

                //自宅ＴＥＬ
                tel1Field.Text = Util.ConvertToString(detail.TEL1);

                //勤務先ＴＥＬ
                tel1_1Field.Text = Util.ConvertToString(detail.TEL1_1);

                //携帯ＴＥＬ
                phoneField.Text = Util.ConvertToString(detail.PHONE);

                //受診日
                if (DateTime.TryParse(Util.ConvertToString(detail.CSLDATE), out DateTime csldate))
                {
                    csldateField.Text = csldate.ToString("yyyy/MM/dd");
                }

                //曜日
                eyobiField.Text = Util.ConvertToString(detail.EYOBI);

                //受付記号Ａ
                if (detail.CSCD == "105")
                {
                    aaaField.Text = "◎";
                }
                else
                {
                    if (detail.CSCD == "100")
                    {
                        if (detail.GENDER == 1)
                        {
                            if (detail.STRTIME == 800)
                            {
                                aaaField.Text = "◎";
                            }
                            else
                            {
                                aaaField.Text = "×";
                                aaaField.TextColor = Color.FromArgb(204, 204, 204);
                            }
                        }
                        else
                        {
                            if (detail.STRTIME == 820)
                            {
                                aaaField.Text = "◎";
                            }
                            else
                            {
                                aaaField.Text = "×";
                                aaaField.TextColor = Color.FromArgb(204, 204, 204);
                            }
                        }
                    }
                    else
                    {
                        if (detail.STRTIME == 940)
                        {
                            aaaField.Text = "◎";
                        }
                        else
                        {
                            aaaField.Text = "×";
                            aaaField.TextColor = Color.FromArgb(204, 204, 204);
                        }
                    }
                }

                //受付時間１
                if (detail.CSCD == "105")
                {
                    if (detail.GENDER == 1)
                    {
                        strtime1Field.Text = "8:00";
                    }
                    else
                    {
                        strtime1Field.Text = "8:20";
                    }
                }
                else
                {
                    if (detail.CSCD == "110")
                    {
                        strtime1Field.Text = "9:40";
                    }
                    else
                    {
                        if (detail.GENDER == 1)
                        {
                            strtime1Field.Text = "8:00";
                        }
                        else
                        {
                            strtime1Field.Text = "8:20";
                        }
                    }
                }
                if (aaaField.Text == "×")
                {
                    strtime1Field.TextColor = Color.FromArgb(204, 204, 204);
                }

                //受付記号Ｂ
                if (detail.CSCD == "105")
                {
                    bbbField.Text = "　";
                }
                else
                {
                    if (detail.CSCD == "100")
                    {
                        if (detail.GENDER == 1)
                        {
                            if (detail.STRTIME == 840)
                            {
                                bbbField.Text = "◎";
                            }
                            else
                            {
                                bbbField.Text = "×";
                                bbbField.TextColor = Color.FromArgb(204, 204, 204);
                            }
                        }
                        else
                        {
                            if (detail.STRTIME == 900)
                            {
                                bbbField.Text = "◎";
                            }
                            else
                            {
                                bbbField.Text = "×";
                                bbbField.TextColor = Color.FromArgb(204, 204, 204);
                            }
                        }
                    }
                    else
                    {
                        if (detail.STRTIME == 1345)
                        {
                            bbbField.Text = "◎";
                        }
                        else
                        {
                            bbbField.Text = "×";
                            bbbField.TextColor = Color.FromArgb(204, 204, 204);
                        }
                    }
                }

                //受付時間２
                if (detail.CSCD == "105")
                {
                    strtime2Field.Text = "";
                }
                else
                {
                    if (detail.CSCD == "110")
                    {
                        strtime2Field.Text = "13:45";
                    }
                    else
                    {
                        if (detail.GENDER == 1)
                        {
                            strtime2Field.Text = "8:40";
                        }
                        else
                        {
                            strtime2Field.Text = "9:00";
                        }
                    }
                }
                if (bbbField.Text == "×")
                {
                    strtime2Field.TextColor = Color.FromArgb(204, 204, 204);
                }


                //受付記号Ｃ
                if (detail.CSCD == "105")
                {
                    cccField.Text = "　";
                }
                else
                {
                    if (detail.CSCD == "100")
                    {
                        if (detail.GENDER == 1)
                        {
                            if (detail.STRTIME == 920)
                            {
                                cccField.Text = "◎";
                            }
                            else
                            {
                                cccField.Text = "×";
                                cccField.TextColor = Color.FromArgb(204, 204, 204);
                            }
                        }
                        else
                        {
                            if (detail.STRTIME == 1000)
                            {
                                cccField.Text = "◎";
                            }
                            else
                            {
                                cccField.Text = "×";
                                cccField.TextColor = Color.FromArgb(204, 204, 204);
                            }
                        }
                    }
                    else
                    {
                        cccField.Text = "　";
                    }
                }

                //受付時間３
                if (detail.CSCD == "105")
                {
                    strtime3Field.Text = "";
                }
                else
                {
                    if (detail.CSCD == "110")
                    {
                        strtime3Field.Text = "";
                    }
                    else
                    {
                        if (detail.GENDER == 1)
                        {
                            strtime3Field.Text = "9:20";
                        }
                        else
                        {
                            strtime3Field.Text = "10:00";
                        }
                    }
                }
                if (cccField.Text == "×")
                {
                    strtime3Field.TextColor = Color.FromArgb(204, 204, 204);
                }

                //受付記号Ｄ
                if (detail.CSCD == "105")
                {
                    dddField.Text = "　";
                }
                else
                {
                    if (detail.CSCD == "100")
                    {
                        if (detail.GENDER == 1)
                        {
                            if (detail.STRTIME == 1020)
                            {
                                dddField.Text = "◎";
                            }
                            else
                            {
                                dddField.Text = "×";
                                dddField.TextColor = Color.FromArgb(204, 204, 204);
                            }
                        }
                        else
                        {
                            if (detail.STRTIME == 1040)
                            {
                                dddField.Text = "◎";
                            }
                            else
                            {
                                dddField.Text = "×";
                                dddField.TextColor = Color.FromArgb(204, 204, 204);
                            }
                        }
                    }
                    else
                    {
                        dddField.Text = "　";
                    }
                }

                //受付時間４
                if (detail.CSCD == "105")
                {
                    strtime4Field.Text = "";
                }
                else
                {
                    if (detail.CSCD == "110")
                    {
                        strtime4Field.Text = "";
                    }
                    else
                    {
                        if (detail.GENDER == 1)
                        {
                            strtime4Field.Text = "10:20";
                        }
                        else
                        {
                            strtime4Field.Text = "10:40";
                        }
                    }
                }
                if (dddField.Text == "×")
                {
                    strtime4Field.TextColor = Color.FromArgb(204, 204, 204);
                }

                //団体名
                orgenameField.Text = Util.ConvertToString(detail.ORGENAME).Trim();

                //コース名
                if (detail.CSCD == "100" || detail.CSCD == "105")
                {
                    csenameField.Text = Util.ConvertToString(detail.CSLDIV).Trim();
                }
                else
                {
                    csenameField.Text = Util.ConvertToString(detail.CSENAME).Trim();
                }

                //胃検査名
                var retIkensa = GetIkensa(rsvno);

                if ( retIkensa != null )
                {
                    ikensaeField.Text = Util.ConvertToString(retIkensa.IKENSAE).Trim();
                }
                else
                {
                    ikensaeField.Text = "";
                }

                //オプション検査名
                var retOpt = GetOption(rsvno, detail.CTRPTCD);

                if (retOpt.Count > 0)
                {
                    //オプション検査印刷欄1列→2列に変更し、長い名称のオプション検査を左側に印刷するよう仕様変更
                    short currentLine = 0;
                    short col = 0;

                    foreach( var opt in retOpt )
                    {
                        freeField3ListField.ListCell(col, currentLine).Text = Util.ConvertToString(opt.FREEFIELD3).Trim();
                        currentLine++;

                        if (currentLine > (freeField3ListField.ListRows.Length - 1))
                        {
                            currentLine = 0;
                            col++;
                        }
                    }

                }
                else
                {
                    freeField3ListField.ListCell(0, 0).Text = "";
                    freeField3ListField.ListCell(0, 1).Text = "";
                }

                pageNo++;

                // ドキュメントの出力
                PrintOut(cnForm);

            }

            //PDF作成後に印刷処理を行う　※未実装
            if (pageNo > 0)
            {

            }

        }

        /// <summary>
        /// 胃検査
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>取得データ</returns>
        private dynamic GetIkensa(int rsvNo)
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
                    and gi.grpcd = :grpcd_i
                    and gi.itemcd = v_csil.itemcd 
                    and fr.freecd like :freecd_i 
                    and fr.freefield1 = gi.grpcd 
                    and fr.freefield2 = gi.seq
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                grpcd_i = GRPCD_IBU,
                freecd_i = FREECD_IBU,
                cancelflg = ConsultCancel.Used
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// オプション取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ctrptCd">契約パターンコード</param>
        /// <returns>取得リストデータ</returns>
        private dynamic GetOption(int rsvNo, int ctrptCd)
        {
            // SQLステートメント定義
            string sql = @"
                select distinct
                    nvl(free.freefield3, ' ') as freefield3
                    , decode( 
                        free.freefield7
                        , null
                        , 999
                        , to_number(trim(free.freefield7))
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
                    and free.freecd like :freecd_opt 
                    and free.freefield1 = ctrpt_opt.setclasscd 
                order by
                    2
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                ctrptcd = ctrptCd,
                freecd_opt = FREECD_OPT
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            // 戻り値設定
            return result;
        }

    }
}
