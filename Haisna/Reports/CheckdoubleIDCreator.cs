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
    /// 二重IDチェックリスト生成クラス
    /// </summary>
    public class CheckdoubleIDCreator : PdfCreator
    {

        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002060";

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
        /// 二重IDチェックリストデータを読み込む
        /// </summary>
        /// <returns>二重IDチェックリストデータ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    cs.csldate as rstcsldate
                    , nvl(pr.lastname || '  ' || pr.firstname, ' ') as rstname
                    , nvl(pr.romename, ' ') as rstromename
                    , nvl(to_char(pr.birth, 'YYYYMMDD'), ' ') as rstbirth
                    , pr.birth
                    , nvl(pr.lastkname || '　' || pr.firstkname, ' ') as rstkname
                    , nvl(pr.gender, 0) as rstgender
                    , nvl(pa.tel1, ' ') as rsttel1
                    , nvl(pa.cityname || pa.address1 || pa.address2, ' ') as rstaddr
                    , cs.rsvno as rstrsvno
                    , decode(cs.rsvstatus, 0, '確定', 1, '保留', 2, '未確定') as rsvstatus 
                from
                    consult cs
                      left join peraddr pa on pa.perid= cs.perid 
                                          and pa.addrdiv = 1 
                    , person pr
                where
                    cs.csldate between :startdate and :enddate
                ";

            //予約状況
            string rsvStatus = queryParams["rsvstatus"];
            if (!string.IsNullOrEmpty(rsvStatus) && rsvStatus.Trim() != "3")
            {
                sql += @"  and cs.rsvstatus = :rsvstatus ";
            }

            sql += @"
                    and cs.perid like '@%' 
                    and pr.perid = cs.perid 
                    and cs.cancelflg = :cancelflg  
                order by
                    cs.csldate
                    , cs.rsvno
                ";

            // パラメータセット
            var sqlParam = new
            {
                startDate = queryParams["startdate"],
                endDate = queryParams["enddate"],
                rsvstatus = rsvStatus,
                cancelflg = ConsultCancel.Used
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// CoReportsフォームオブジェクトの各フィールドに値をセットする
        /// </summary>
        /// <param name="cnForms">CoReportsフォームオブジェクトのコレクション</param>
        /// <param name="data">二重IDチェックリストデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {
            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;

            // フォームの各項目を変数にセット
            var titlersvstatusField = (CnDataField)cnObjects["TITLERSVSTATUS"];
            var pagenoField = (CnDataField)cnObjects["PAGENO"];
            var printdateField = (CnDataField)cnObjects["PRINTDATE"];
            var csldateField = (CnDataField)cnObjects["CSLDATE"];

            var rstnameField = (CnDataField)cnObjects["RSTNAME"];
            var rstromenameField = (CnDataField)cnObjects["RSTROMENAME"];
            var birthField = (CnDataField)cnObjects["BIRTH"];
            var rstknameField = (CnDataField)cnObjects["RSTKNAME"];
            var rstgenderField = (CnDataField)cnObjects["RSTGENDER"];
            var rsttel1Field = (CnDataField)cnObjects["RSTTEL1"];
            var rstaddrField = (CnDataField)cnObjects["RSTADDR"];
            var rsvstatusField = (CnDataField)cnObjects["RSVSTATUS"];

            var countperidListField = (CnListField)cnObjects["COUNTPERID"];
            var peridListField = (CnListField)cnObjects["PERID"];
            var mednameListField = (CnListField)cnObjects["MEDNAME"];
            var medrnameListField = (CnListField)cnObjects["MEDRNAME"];
            var medbirthListField = (CnListField)cnObjects["MEDBIRTH"];
            var knameListField = (CnListField)cnObjects["KNAME"];
            var medgenderListField = (CnListField)cnObjects["MEDGENDER"];
            var tel1ListField = (CnListField)cnObjects["TEL1"];
            var addrListField = (CnListField)cnObjects["ADDR"];

            string sysdate = DateTime.Today.ToShortDateString();

            int rowCount = 0;
            int pageNo = 0;

            int outCnt = 0;

            short currentLine = 0;

            string titleText = "";
            string csldate = "";
            string genderName = "";

            DateTime birth;

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                // 明細データを取得
                var listData = GetListData(Util.ConvertToString(detail.RSTROMENAME), Util.ConvertToString(detail.RSTKNAME), Util.ConvertToString(detail.RSTBIRTH), Util.ConvertToString(detail.RSTGENDER));

                outCnt = 0;
                rowCount = 0;

                // 明細データ編集
                if (listData.Count > 0 )
                {
                    foreach (var item in listData)
                    {
                        // 編集行を特定する
                        currentLine = (short)(rowCount % countperidListField.ListRows.Length);

                        // ＳＥＱ
                        countperidListField.ListCell(0, currentLine).Text = Util.ConvertToString(outCnt + 1);

                        // 患者ＩＤ
                        peridListField.ListCell(0, currentLine).Text = Util.ConvertToString(item.PERID);

                        // 氏名（漢字）
                        mednameListField.ListCell(0, currentLine).Text = Util.ConvertToString(item.MEDNAME);

                        // 氏名（ローマ字）
                        medrnameListField.ListCell(0, currentLine).Text = Util.ConvertToString(item.MEDRNAME);

                        // 生年月日
                        DateTime.TryParse(Convert.ToString(item.MEDBIRTH), out birth);
                        medbirthListField.ListCell(0, currentLine).Text = WebHains.EraDateFormat(birth, "ggyy/MM/dd");

                        // 氏名（カナ）
                        knameListField.ListCell(0, currentLine).Text = Util.ConvertToString(item.KNAME);

                        // 性別
                        genderName = "";

                        if (Util.ConvertToString(item.MEDGENDER) == "1")
                        {
                            genderName = "男性";
                        }
                        else
                        {
                            genderName = "女性";
                        }
                        medgenderListField.ListCell(0, currentLine).Text = genderName;

                        // 電話番号
                        tel1ListField.ListCell(0, currentLine).Text = Util.ConvertToString(item.TEL1);

                        // 住所
                        addrListField.ListCell(0, currentLine).Text = Util.ConvertToString(item.ADDR);

                        // ページ内最大行に達した場合
                        if (currentLine == countperidListField.ListRows.Length - 1 )
                        {
                            pageNo++;

                            // ページ番号
                            pagenoField.Text = pageNo.ToString();

                            // 印刷日
                            printdateField.Text = sysdate;

                            // タイトル予約状況
                            titleText = "";
                            switch (queryParams["rsvstatus"])
                            {
                                case "0":
                                    titleText = "（ 確定 ）";
                                    break;

                                case "1":
                                    titleText = "（ 保留 ）";
                                    break;

                                case "2":
                                    titleText = "（ 未確定 ）";
                                    break;

                                default:
                                    titleText = "（ すべて ）";
                                    break;
                            }
                            titlersvstatusField.Text = titleText;

                            // 受診日
                            csldate = "";
                            if (DateTime.TryParse(Util.ConvertToString(detail.RSTCSLDATE), out DateTime dt))
                            {
                                csldate = dt.ToString("yyyy/MM/dd");
                            }
                            csldateField.Text = csldate;

                            // 氏名（漢字）
                            rstnameField.Text = Util.ConvertToString(detail.RSTNAME);

                            // 氏名（ローマ字）
                            rstromenameField.Text = Util.ConvertToString(detail.RSTROMENAME);

                            // 生年月日
                            DateTime.TryParse(Convert.ToString(detail.BIRTH), out birth);
                            birthField.Text = WebHains.EraDateFormat(birth, "ggyy/MM/dd");

                            // 氏名（カナ）
                            rstknameField.Text = Util.ConvertToString(detail.RSTKNAME);

                            // 性別
                            genderName = "";
                            if (Util.ConvertToString(detail.RSTGENDER) == "1")
                            {
                                genderName = "男性";
                            }
                            else
                            {
                                genderName = "女性";
                            }
                            rstgenderField.Text = genderName;

                            // 電話番号
                            rsttel1Field.Text = Util.ConvertToString(detail.RSTTEL1);

                            // 住所
                            rstaddrField.Text = Util.ConvertToString(detail.RSTADDR);

                            // 予約状況
                            rsvstatusField.Text = Util.ConvertToString(detail.RSVSTATUS);

                            // ドキュメントの出力
                            PrintOut(cnForm);

                            // 現在編集行のリセット
                            currentLine = 0;
                        }

                        // 行カウントをインクリメント
                        rowCount++;

                        // 連番をインクリメント
                        outCnt++;

                    }
                }

                if (outCnt == 0 || currentLine > 0)
                {
                    pageNo++;

                    // ページ番号
                    pagenoField.Text = pageNo.ToString();

                    // 印刷日
                    printdateField.Text = sysdate;

                    // タイトル予約状況
                    titleText = "";
                    switch (queryParams["rsvstatus"])
                    {
                        case "0":
                            titleText = "（ 確定 ）";
                            break;

                        case "1":
                            titleText = "（ 保留 ）";
                            break;

                        case "2":
                            titleText = "（ 未確定 ）";
                            break;

                        default:
                            titleText = "（ すべて ）";
                            break;
                    }
                    titlersvstatusField.Text = titleText;

                    // 受診日
                    csldate = "";
                    if (DateTime.TryParse(Util.ConvertToString(detail.RSTCSLDATE), out DateTime dt2))
                    {
                        csldate = dt2.ToString("yyyy/MM/dd");
                    }
                    csldateField.Text = csldate;

                    // 氏名（漢字）
                    rstnameField.Text = Util.ConvertToString(detail.RSTNAME);

                    // 氏名（ローマ字）
                    rstromenameField.Text = Util.ConvertToString(detail.RSTROMENAME);

                    // 生年月日
                    DateTime.TryParse(Convert.ToString(detail.BIRTH), out birth);
                    birthField.Text = WebHains.EraDateFormat(birth, "ggyy/MM/dd");

                    // 氏名（カナ）
                    rstknameField.Text = Util.ConvertToString(detail.RSTKNAME);

                    // 性別
                    genderName = "";
                    if (Util.ConvertToString(detail.RSTGENDER) == "1")
                    {
                        genderName = "男性";
                    }
                    else
                    {
                        genderName = "女性";
                    }
                    rstgenderField.Text = genderName;

                    // 電話番号
                    rsttel1Field.Text = Util.ConvertToString(detail.RSTTEL1);

                    // 住所
                    rstaddrField.Text = Util.ConvertToString(detail.RSTADDR);

                    // 予約状況
                    rsvstatusField.Text = Util.ConvertToString(detail.RSVSTATUS);

                    // ドキュメントの出力
                    PrintOut(cnForm);

                    // 現在編集行のリセット
                    currentLine = 0;
                }

            }

        }
        
        /// <summary>
        /// 明細データ取得
        /// </summary>
        /// <param name="rstRomeName">ローマ字氏名</param>
        /// <param name="rstKName">カナ氏名</param>
        /// <param name="rstBirth">生年月日</param>
        /// <param name="rstGender">性別</param>
        /// <returns></returns>
        private dynamic GetListData(string rstRomeName, string rstKName, string rstBirth, string rstGender)

        {
            // SQLステートメント定義
            string sql = @"
                select
                    1
                    , pr.perid
                    , pr.medname
                    , pr.medrname
                    , pr.medbirth
                    , pr.lastkname || ' ' || pr.firstkname as kname
                    , pr.medgender
                    , pa1.tel1
                    , pa.cityname || pa.address1 || pa.address2 as addr 
                from
                    person pr 
                    left join peraddr pa 
                        on pa.perid = pr.perid 
                        and pa.addrdiv = 4 
                    left join peraddr pa1 
                        on pa1.perid = pr.perid 
                        and pa1.addrdiv = 1 
                where
                    ( 
                        ( 
                            (pr.medrname = :kname) 
                            and (pr.birth = :birth)
                        )
                    ) 
                    and to_char(pr.medbirth, 'YYYYMMDD') > '18680908' 
                    and pr.perid not like '@%' 
                union all 
                select
                    2
                    , pr.perid
                    , pr.medname
                    , pr.medrname
                    , pr.medbirth
                    , pr.lastkname || ' ' || pr.firstkname as kname
                    , pr.medgender
                    , pa1.tel1
                    , pa.cityname || pa.address1 || pa.address2 as addr 
                from
                    person pr 
                    left join peraddr pa 
                        on pa.perid = pr.perid 
                        and pa.addrdiv = 4 
                    left join peraddr pa1 
                        on pa1.perid = pr.perid 
                        and pa1.addrdiv = 1 
                where
                    ( 
                        ( 
                            (pr.medrname = :romename) 
                            and (pr.birth = :birth)
                        )
                    ) 
                    and to_char(pr.medbirth, 'YYYYMMDD') > '18680908' 
                    and pr.perid not like '@%' 
                union all 
                select
                    3
                    , pr.perid
                    , pr.medname
                    , pr.medrname
                    , pr.medbirth
                    , pr.lastkname || ' ' || pr.firstkname as kname
                    , pr.medgender
                    , pa1.tel1
                    , pa.cityname || pa.address1 || pa.address2 as addr 
                from
                    person pr 
                    left join peraddr pa 
                        on pa.perid = pr.perid 
                        and pa.addrdiv = 4 
                    left join peraddr pa1 
                        on pa1.perid = pr.perid 
                        and pa1.addrdiv = 1 
                where
                    ( 
                        ( 
                            (pr.medrname = :kname) 
                            and (pr.birth <> :birth)
                        )
                    ) 
                    and to_char(pr.medbirth, 'YYYYMMDD') > '18680908' 
                    and pr.perid not like '@%' 
                union all 
                select
                    4
                    , pr.perid
                    , pr.medname
                    , pr.medrname
                    , pr.medbirth
                    , pr.lastkname || ' ' || pr.firstkname as kname
                    , pr.medgender
                    , pa1.tel1
                    , pa.cityname || pa.address1 || pa.address2 as addr 
                from
                    person pr 
                    left join peraddr pa 
                        on pa.perid = pr.perid 
                        and pa.addrdiv = 4 
                    left join peraddr pa1 
                        on pa1.perid = pr.perid 
                        and pa1.addrdiv = 1 
                where
                    ( 
                        ( 
                            (pr.medrname = :romename) 
                            and (pr.birth <> :birth)
                        )
                    ) 
                    and to_char(pr.medbirth, 'YYYYMMDD') > '18680908' 
                    and pr.perid not like '@%' 
                union all 
                select
                    5
                    , pr.perid
                    , pr.medname
                    , pr.medrname
                    , pr.medbirth
                    , pr.lastkname || ' ' || pr.firstkname as kname
                    , pr.medgender
                    , pa1.tel1
                    , pa.cityname || pa.address1 || pa.address2 as addr 
                from
                    person pr 
                    left join peraddr pa 
                        on pa.perid = pr.perid 
                        and pa.addrdiv = 4 
                    left join peraddr pa1 
                        on pa1.perid = pr.perid 
                        and pa1.addrdiv = 1 
                where
                    ( 
                        ( 
                            (pr.medrname <> :romename) 
                            and ( 
                                nvl( 
                                    substr(pr.medrname, instr(pr.medrname, ' ') + 1, 99)
                                    , ' '
                                ) = nvl(substr('', instr('', ' ') + 1, 99), ' ')
                            ) 
                            and (pr.birth = :birth)
                        ) 
                        or ( 
                            (pr.medrname <> :romename) 
                            and pr.birth = :birth 
                            and pr.gender = :gender
                        )
                    ) 
                    and to_char(pr.medbirth, 'YYYYMMDD') > '18680908' 
                    and pr.perid not like '@%' 
                order by
                    1
                    , 4
                    , 5
                ";

            // パラメータセット
            var sqlParam = new
            {
                romename = rstRomeName,
                kname = rstKName,
                birth = rstBirth,
                gender = rstGender
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            // 戻り値設定
            return result;
        }

    }
}
