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
    /// 個人票生成クラス
    /// </summary>
    public class PatientCreator : PdfCreator
    {

        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002140";

        /// <summary>
        /// 汎用分類コード
        /// </summary>
        private string CNST_FREECLASSCD_CS = "PAT";       // 個人票対象コース　汎用分類コード
        private string CNST_FREECD_SP_ORG = "SPC%";       // 保健指導対象者団体　汎用コード

        /// <summary>
        /// セット分類コード
        /// </summary>
        private string CNST_SETCLASS_SP = "660";          // 契約情報の特定健診セット分類コード

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            //受診日チェック
            if (!DateTime.TryParse(queryParams["csldate"], out DateTime wkDate))
            {
                messages.Add("開始日付が正しくありません。");
            }

            //当日IDチェック
            string dayID = queryParams["dayid"];
            if (!string.IsNullOrEmpty(dayID))
            {
                //当日IDの入力がある場合、数値チェック
                string message = WebHains.CheckNumeric("当日ID", dayID, (int)LengthConstants.LENGTH_RECEIPT_DAYID);
                if (!string.IsNullOrEmpty(message))
                {
                    messages.Add(message);
                }
            }

            return messages;
        }

        /// <summary>
        /// 個人票データを読み込む
        /// </summary>
        /// <returns>個人票データ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select
                    receipt.dayid as dayid
                    , consult.csldate as csldate
                    , consult.rsvno as rsvno
                    , to_char(consult.csldate, 'YYYY/MM/DD') as ccsldate
                    , person.romename as ename
                    , person.lastkname || '  ' || person.firstkname as kname
                    , person.lastname || '  ' || person.firstname as name
                    , to_char(person.birth, 'YYYY/MM/DD') as birthday
                    , trunc( 
                        getcslage( 
                            to_char(person.birth, 'YYYYMMDD')
                            , consult.csldate
                            , to_char(consult.csldate, 'YYYYMMDD')
                        )
                    ) || '歳  ' || '(' || trunc(consult.age) || '歳) ' as age
                    , person.gender as gendercd
                    , decode(person.gender, 1, '男性', 2, '女性') as gender
                    , consult.perid as perid
                    , rsvgrp.rsvgrpname as rsvgrpname 
                from
                    consult
                    , receipt
                    , person
                    , rsvgrp
                    , free 
                where
                    consult.csldate = :csldate
                    and consult.cancelflg = :cancelflg  
                    and consult.rsvno = receipt.rsvno 
                ";

            //当日ID
            string dayId_work = queryParams["dayid"];
            if (!string.IsNullOrEmpty(dayId_work) )
            {
                sql += @"  and receipt.dayid = :dayId";
            }

            sql += @"
                    and consult.perid = person.perid 
                    and consult.rsvgrpcd = rsvgrp.rsvgrpcd 
                    and consult.cscd = free.freefield1 
                    and free.freeclasscd = :freeclass
                order by
                    consult.csldate
                    , receipt.dayid
                ";


            // パラメータセット
            var sqlParam = new
            {
                csldate = queryParams["csldate"],
                dayId = dayId_work,
                freeclass = CNST_FREECLASSCD_CS,
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
            var spcountText = (CnText)cnObjects["SPCOUNT"];                 //特定健診
            var dayidField = (CnDataField)cnObjects["DAYID"];               //当日ID
            var ccsldateField = (CnDataField)cnObjects["CCSLDATE"];         //受診日
            var peridField = (CnDataField)cnObjects["PERID"];               //患者ID
            var enameField = (CnDataField)cnObjects["ENAME"];               //ローマ字氏名
            var knameField = (CnDataField)cnObjects["KNAME"];               //フリガナ
            var nameField = (CnDataField)cnObjects["NAME"];                 //氏名
            var birthdayField = (CnDataField)cnObjects["BIRTHDAY"];         //生年月日
            var ageField = (CnDataField)cnObjects["AGE"];                   //年齢
            var genderField = (CnDataField)cnObjects["GENDER"];             //性別
            var rsvgrpnameField = (CnDataField)cnObjects["RSVGRPNAME"];     //群
            var perid2Field = (CnDataField)cnObjects["PERID2"];             //患者ID
            var kname2Field = (CnDataField)cnObjects["KNAME2"];             //フリガナ
            var name2Field = (CnDataField)cnObjects["NAME2"];               //氏名
            var birthday2Field = (CnDataField)cnObjects["BIRTHDAY2"];       //生年月日
            var age2Field = (CnDataField)cnObjects["AGE2"];                 //年齢
            var dayid2Field = (CnDataField)cnObjects["DAYID2"];             //当日ID
            var ename2Field = (CnDataField)cnObjects["ENAME2"];             //ローマ字氏名
            var shintaiText = (CnText)cnObjects["SHINTAI"];                 //身体測定
            var hukuiText = (CnText)cnObjects["HUKUI"];                     //腹囲
            var ketsuatsuText = (CnText)cnObjects["KETSUATSU"];             //血圧
            var saiketsuText = (CnText)cnObjects["SAIKETSU"];               //採血
            var echoText = (CnText)cnObjects["ECHO"];                       //腹部超音波
            var bechoText = (CnText)cnObjects["BECHO"];                     //乳房超音波
            var crText = (CnText)cnObjects["CR"];                           //胸部Ｘ線
            var ctText = (CnText)cnObjects["CT"];                           //胸部ＣＴ
            var ecgText = (CnText)cnObjects["ECG"];                         //心電図
            var kotsumitsudoText = (CnText)cnObjects["KOTSUMITSUDO"];       //骨密度
            var haikinouText = (CnText)cnObjects["HAIKINOU"];               //肺機能
            var shinsatsuText = (CnText)cnObjects["SHINSATSU"];             //診察
            var shiryokuText = (CnText)cnObjects["SHIRYOKU"];               //視力
            var ganteiText = (CnText)cnObjects["GANTEI"];                   //眼底・眼圧
            var tyouryokuText = (CnText)cnObjects["TYOURYOKU"];             //聴力
            var fujinkaText = (CnText)cnObjects["FUJINKA"];                 //婦人科
            var mmgText = (CnText)cnObjects["MMG"];                         //乳房Ｘ線
            var busukopanText = (CnText)cnObjects["BUSUKOPAN"];             //注射
            var giText = (CnText)cnObjects["GI"];                           //胃Ｘ線
            var gfText = (CnText)cnObjects["GF"];                           //内視鏡
            var gfcounterText = (CnText)cnObjects["GFCOUNTER"];             //内視鏡カウンター
            var shibouText = (CnText)cnObjects["SHIBOU"];                   //内臓脂肪面積
            var keidouText = (CnText)cnObjects["KEIDOU"];                   //頸動脈超音波
            var caviText = (CnText)cnObjects["CAVI"];                       //動脈硬化
            var optcountText = (CnText)cnObjects["OPTCOUNT"];               //新オプション検査（頸動脈超音波 or 動脈硬化）
            var shidouText = (CnText)cnObjects["SHIDOU"];                   //特定保健指導対象者表示
            var fujinkaechoText = (CnText)cnObjects["FUJINKAECHO"];         //
            var kakutanText = (CnText)cnObjects["KAKUTAN"];                 //喀痰細胞診
            var hpvText = (CnText)cnObjects["HPV"];                         //HPV
            var heartImage = (CnImage)cnObjects["HEART"];                   //ペースメーカ
            var stomachImage = (CnImage)cnObjects["STOMACH"];               //胃手術
            var edtaText = (CnText)cnObjects["EDTA"];                       //EDTA
            var injection1Text = (CnText)cnObjects["INJECTION1"];           // '注射時刻
            var injection2Text = (CnText)cnObjects["INJECTION2"];           // '注射時刻
            var injection3Text = (CnText)cnObjects["INJECTION3"];           // '注射時刻
            var alcoholImage = (CnImage)cnObjects["ALCOHOL"];               //アルコール禁止
            var scopolamineImage = (CnImage)cnObjects["SCOPOLAMINE"];       //ブチルスコポラミンアレルギー
            var inbodyText = (CnText)cnObjects["INBODY"];                   //インボディ
            var haikisyuText = (CnText)cnObjects["HAIKISYU"];               //CT肺気腫


            string sysdate = DateTime.Today.ToShortDateString();

            int pageNo = 0;

            // ページ内の項目に値をセット
            foreach (var detail in data)
            {
                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();

                //予約番号（パラメタ用）
                int rsvno = Convert.ToInt32(detail.RSVNO);

                //特定健診
                spcountText.Visible = false;
                if ( CheckSp(rsvno) > 0 ) 
                {
                    //データが存在する場合、表示
                    spcountText.Visible = true;
                }

                //特定保健指導対象者
                shidouText.Visible = false;
                if (CheckSpecialTarget(rsvno))
                {
                    //データが存在する場合、表示
                    shidouText.Visible = true;
                }

                // データフィールド

                //当日ID
                dayidField.Text = Util.ConvertToString(detail.DAYID);
                dayid2Field.Text = Util.ConvertToString(detail.DAYID);

                //受診日
                ccsldateField.Text = Util.ConvertToString(detail.CCSLDATE);

                //患者ID
                peridField.Text = Util.ConvertToString(detail.PERID);
                perid2Field.Text = Util.ConvertToString(detail.PERID);

                //ローマ字氏名
                enameField.Text = Util.ConvertToString(detail.ENAME);
                ename2Field.Text = Util.ConvertToString(detail.ENAME);

                //フリガナ
                knameField.Text = Util.ConvertToString(detail.KNAME);
                kname2Field.Text = Util.ConvertToString(detail.KNAME);

                //氏名
                nameField.Text = Util.ConvertToString(detail.NAME);
                name2Field.Text = Util.ConvertToString(detail.NAME);

                //生年月日
                birthdayField.Text = Util.ConvertToString(detail.BIRTHDAY);
                birthday2Field.Text = Util.ConvertToString(detail.BIRTHDAY);

                //年齢
                ageField.Text = Util.ConvertToString(detail.AGE);
                age2Field.Text = Util.ConvertToString(detail.AGE);

                //性別
                genderField.Text = Util.ConvertToString(detail.GENDER);

                //群
                rsvgrpnameField.Text = Util.ConvertToString(detail.RSVGRPNAME);

                //検査グループ名称(デフォルト＝グレー)
                shintaiText.TextColor = Color.FromArgb(190, 190, 190);
                hukuiText.TextColor = Color.FromArgb(190, 190, 190);
                ketsuatsuText.TextColor = Color.FromArgb(190, 190, 190);
                saiketsuText.TextColor = Color.FromArgb(190, 190, 190);
                echoText.TextColor = Color.FromArgb(190, 190, 190);
                bechoText.TextColor = Color.FromArgb(190, 190, 190);
                crText.TextColor = Color.FromArgb(190, 190, 190);
                ctText.TextColor = Color.FromArgb(190, 190, 190);
                ecgText.TextColor = Color.FromArgb(190, 190, 190);
                kotsumitsudoText.TextColor = Color.FromArgb(190, 190, 190);
                haikinouText.TextColor = Color.FromArgb(190, 190, 190);
                shinsatsuText.TextColor = Color.FromArgb(190, 190, 190);
                shiryokuText.TextColor = Color.FromArgb(190, 190, 190);
                ganteiText.TextColor = Color.FromArgb(190, 190, 190);
                tyouryokuText.TextColor = Color.FromArgb(190, 190, 190);
                fujinkaText.TextColor = Color.FromArgb(190, 190, 190);
                mmgText.TextColor = Color.FromArgb(190, 190, 190);
                busukopanText.TextColor = Color.FromArgb(190, 190, 190);
                giText.TextColor = Color.FromArgb(190, 190, 190);
                gfText.TextColor = Color.FromArgb(190, 190, 190);
                gfcounterText.TextColor = Color.FromArgb(190, 190, 190);
                shibouText.TextColor = Color.FromArgb(190, 190, 190);
                keidouText.TextColor = Color.FromArgb(190, 190, 190);
                caviText.TextColor = Color.FromArgb(190, 190, 190);
                fujinkaechoText.TextColor = Color.FromArgb(190, 190, 190);
                kakutanText.TextColor = Color.FromArgb(190, 190, 190);
                hpvText.TextColor = Color.FromArgb(190, 190, 190);
                injection1Text.TextColor = Color.FromArgb(190, 190, 190);
                injection2Text.TextColor = Color.FromArgb(190, 190, 190);
                injection3Text.TextColor = Color.FromArgb(190, 190, 190);
                inbodyText.TextColor = Color.FromArgb(190, 190, 190);
                haikisyuText.TextColor = Color.FromArgb(190, 190, 190);

                //新オプション検査
                optcountText.Visible = false;

                heartImage.Visible = false;
                stomachImage.Visible = false;
                edtaText.Visible = false;
                alcoholImage.Visible = false;
                scopolamineImage.Visible = false;

                //検査グループ名称判断用データ取得（値が"1"の場合、黒文字）
                var itemData = GetReceiptItem(rsvno);

                if (itemData != null)
                {
                    //身体測定
                    if (Util.ConvertToString(itemData.SHINTAI) == "1")
                    {
                        shintaiText.TextColor = Color.FromArgb(0, 0, 0);
                    }

                    //血圧
                    if (Util.ConvertToString(itemData.KETSUATSU) == "1")
                    {
                        ketsuatsuText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //採血
                    if (Util.ConvertToString(itemData.SAIKETSU) == "1")
                    {
                        saiketsuText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //腹部超音波
                    if (Util.ConvertToString(itemData.ECHO) == "1")
                    {
                        echoText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //乳房超音波
                    if (Util.ConvertToString(itemData.BECHO) == "1")
                    {
                        bechoText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //胸部Ｘ線
                    if (Util.ConvertToString(itemData.CR) == "1")
                    {
                        crText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //胸部ＣＴ
                    if (Util.ConvertToString(itemData.CT) == "1")
                    {
                        ctText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //心電図
                    if (Util.ConvertToString(itemData.ECG) == "1")
                    {
                        ecgText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //骨密度
                    if (Util.ConvertToString(itemData.KOTSUMITSUDO) == "1")
                    {
                        kotsumitsudoText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //肺機能
                    if (Util.ConvertToString(itemData.HAIKINOU) == "1")
                    {
                        haikinouText.TextColor = Color.FromArgb(0, 0, 0);
                    }

                    //診察
                    if (Util.ConvertToString(itemData.SHINSATSU) == "1")
                    {
                        shinsatsuText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //視力
                    if (Util.ConvertToString(itemData.SHIRYOKU) == "1")
                    {
                        shiryokuText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //眼底・眼圧
                    if (Util.ConvertToString(itemData.GANTEI) == "1")
                    {
                        ganteiText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //聴力
                    if (Util.ConvertToString(itemData.TYOURYOKU) == "1")
                    {
                        tyouryokuText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //婦人科
                    if (Util.ConvertToString(itemData.FUJINKA) == "1")
                    {
                        fujinkaText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //乳房Ｘ線
                    if (Util.ConvertToString(itemData.MMG) == "1")
                    {
                        mmgText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //注射
                    if (Util.ConvertToString(itemData.BUSUKOPAN) == "1")
                    {
                        busukopanText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //胃Ｘ線
                    if (Util.ConvertToString(itemData.GI) == "1")
                    {
                        giText.TextColor = Color.FromArgb(0, 0, 0);

                        injection1Text.TextColor = Color.FromArgb(0, 0, 0);
                        injection2Text.TextColor = Color.FromArgb(0, 0, 0);
                        injection3Text.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //内視鏡
                    if (Util.ConvertToString(itemData.GF) == "1")
                    {
                        gfText.TextColor = Color.FromArgb(0, 0, 0);
                        gfcounterText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //内臓脂肪面積
                    if (Util.ConvertToString(itemData.SHIBOU) == "1")
                    {
                        shibouText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //頸動脈超音波
                    if (Util.ConvertToString(itemData.KEIDOU) == "1")
                    {
                        keidouText.TextColor = Color.FromArgb(0, 0, 0);
                        optcountText.Visible = true;
                    }
                    //動脈硬化
                    if (Util.ConvertToString(itemData.CAVI) == "1")
                    {
                        caviText.TextColor = Color.FromArgb(0, 0, 0);
                        optcountText.Visible = true;
                    }
                    //婦人科超音波
                    if (Util.ConvertToString(itemData.FUJINKAECHO) == "1")
                    {
                        fujinkaechoText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //インボディ
                    if (Util.ConvertToString(itemData.INBODY) == "1")
                    {
                        inbodyText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //CT肺気腫
                    if (Util.ConvertToString(itemData.HAIKISYU) == "1")
                    {
                        haikisyuText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //腹囲
                    if (Util.ConvertToString(itemData.HUKUI) == "1")
                    {
                        hukuiText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //喀痰
                    if (Util.ConvertToString(itemData.KAKUTAN) == "1")
                    {
                        kakutanText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //HPV
                    if (Util.ConvertToString(itemData.HPV) == "1")
                    {
                        hpvText.TextColor = Color.FromArgb(0, 0, 0);
                    }
                    //ペースメーカ
                    if (Util.ConvertToString(itemData.HEART) == "1")
                    {
                        heartImage.Visible = true;
                    }
                    //胃手術
                    if (Util.ConvertToString(itemData.STOMACH) == "1")
                    {
                        stomachImage.Visible = true;
                    }
                    //EDTA
                    if (Util.ConvertToString(itemData.EDTA) == "1")
                    {
                        edtaText.Visible = true;
                    }
                    //アルコール禁止
                    if (Util.ConvertToString(itemData.ALCOHOL) == "1")
                    {
                        alcoholImage.Visible = true;
                    }
                    //ブチルスコポラミンアレルギー
                    if (Util.ConvertToString(itemData.SCOPOLAMINE) == "1")
                    {
                        scopolamineImage.Visible = true;
                    }

                }

                pageNo++;

                // ドキュメントの出力
                PrintOut(cnForm);

            }
        }

        /// <summary>
        /// 受診項目取得
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <returns></returns>
        private dynamic GetReceiptItem(int rsvno)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    max(result.shintai) as shintai
                    , max(result.ketsuatsu) as ketsuatsu
                    , max(result.saiketsu) as saiketsu
                    , max(result.echo) as echo
                    , max(result.cr) as cr
                    , max(result.ct) as ct
                    , max(result.ecg) as ecg
                    , max(result.kotsumitsudo) as kotsumitsudo
                    , max(result.haikinou) as haikinou
                    , max(result.shinsatsu) as shinsatsu
                    , max(result.shiryoku) as shiryoku
                    , max(result.gantei) as gantei
                    , max(result.tyouryoku) as tyouryoku
                    , max(result.fujinka) as fujinka
                    , max(result.mmg) as mmg
                    , max(result.becho) as becho
                    , max(result.mch) as mch
                    , max(result.busukopan) as busukopan
                    , max(result.gi) as gi
                    , max(result.gf) as gf
                    , max(result.cf) as cf
                    , max(result.shibou) as shibou
                    , max(result.keidou) as keidou
                    , max(result.cavi) as cavi
                    , max(result.fujinkaecho) as fujinkaecho
                    , max(result.inbody) as inbody
                    , ( 
                        select
                            decode(count(rsl.rsvno), 0, 0, 1) 
                        from
                            rsl
                            , grp_r 
                        where
                            rsl.rsvno = result.rsvno 
                            and rsl.itemcd = grp_r.itemcd 
                            and nvl(rsl.stopflg, ' ') <> 'S' 
                            and grp_r.grpcd = 'K0030'
                    ) as hukui
                    , ( 
                        select
                            decode(count(rsl.rsvno), 0, 0, 1) 
                        from
                            rsl
                            , grp_i 
                        where
                            rsl.rsvno = result.rsvno 
                            and rsl.itemcd = grp_i.itemcd 
                            and rsl.suffix = grp_i.suffix 
                            and nvl(rsl.stopflg, ' ') <> 'S' 
                            and grp_i.grpcd = 'X601'
                    ) as kakutan
                    , ( 
                        select
                            decode(count(rsl.rsvno), 0, 0, 1) 
                        from
                            rsl
                            , grp_r 
                        where
                            rsl.rsvno = result.rsvno 
                            and rsl.itemcd = grp_r.itemcd 
                            and nvl(rsl.stopflg, ' ') <> 'S' 
                            and grp_r.grpcd = 'K0595'
                    ) as hpv
                    , ( 
                        select
                            decode(count(rsl.rsvno), 0, 0, 1) 
                        from
                            rsl
                            , grp_r 
                        where
                            rsl.rsvno = result.rsvno 
                            and rsl.itemcd = grp_r.itemcd 
                            and nvl(rsl.stopflg, ' ') <> 'S' 
                            and grp_r.grpcd = 'K0545'
                    ) as haikisyu
                    , ( 
                        select
                            count(perresult.perid) 
                        from
                            perresult 
                        where
                            perresult.perid = result.perid 
                            and perresult.itemcd = '80010' 
                            and perresult.suffix = '00' 
                            and perresult.result is not null 
                            and perresult.result <> '1'
                    ) as heart
                    , ( 
                        select
                            count(perresult.perid) 
                        from
                            perresult 
                        where
                            perresult.perid = result.perid 
                            and perresult.itemcd = '80020' 
                            and perresult.suffix = '00' 
                            and perresult.result is not null 
                            and perresult.result <> '1'
                    ) as stomach
                    , ( 
                        select
                            count(perresult.perid) 
                        from
                            perresult 
                        where
                            perresult.perid = result.perid 
                            and perresult.itemcd = '80015' 
                            and perresult.suffix = '00' 
                            and perresult.result is not null 
                            and perresult.result <> '1'
                    ) as edta
                    , ( 
                        select
                            count(perresult.perid) 
                        from
                            perresult 
                        where
                            perresult.perid = result.perid 
                            and perresult.itemcd = '80014' 
                            and perresult.suffix = '00' 
                            and perresult.result is not null 
                            and perresult.result <> '1'
                    ) as alcohol
                    , ( 
                        select
                            count(perresult.perid) 
                        from
                            perresult 
                        where
                            perresult.perid = result.perid 
                            and perresult.itemcd = '80019' 
                            and perresult.suffix = '00' 
                            and perresult.result is not null 
                            and perresult.result <> '1'
                    ) as scopolamine 
                from
                    ( 
                        select
                            consult.perid as perid
                            , consult.rsvno as rsvno
                            , decode(grp_i.grpcd, 'M602', 1, 0) as shintai
                            , decode(grp_i.grpcd, 'M603', 1, 0) as ketsuatsu
                            , decode(grp_i.grpcd, 'X604', 1, 0) as saiketsu
                            , decode(grp_i.grpcd, 'M605', 1, 0) as echo
                            , decode(grp_i.grpcd, 'M607', 1, 0) as cr
                            , decode(grp_i.grpcd, 'M608', 1, 0) as ct
                            , decode(grp_i.grpcd, 'M609', 1, 0) as ecg
                            , decode(grp_i.grpcd, 'M610', 1, 0) as kotsumitsudo
                            , decode(grp_i.grpcd, 'M611', 1, 0) as haikinou
                            , decode(grp_i.grpcd, 'M613', 1, 0) as shinsatsu
                            , decode(grp_i.grpcd, 'M614', 1, 0) as shiryoku
                            , decode(grp_i.grpcd, 'M615', 1, 0) as gantei
                            , decode(grp_i.grpcd, 'M616', 1, 0) as tyouryoku
                            , decode(grp_i.grpcd, 'M617', 1, 0) as fujinka
                            , decode(grp_i.grpcd, 'M618', 1, 0) as mmg
                            , decode(grp_i.grpcd, 'M606', 1, 0) as becho
                            , decode(grp_i.grpcd, 'M619', 1, 0) as mch
                            , decode(grp_i.grpcd, 'M620', 1, 0) as busukopan
                            , decode(grp_i.grpcd, 'M621', 1, 0) as gi
                            , decode(grp_i.grpcd, 'M622', 1, 0) as gf
                            , decode(grp_i.grpcd, 'M629', 1, 0) as cf
                            , decode(grp_i.grpcd, 'M686', 1, 0) as shibou
                            , decode(grp_i.grpcd, 'M684', 1, 0) as keidou
                            , decode(grp_i.grpcd, 'M685', 1, 0) as cavi
                            , decode(grp_i.grpcd, 'M696', 1, 0) as fujinkaecho
                            , decode(grp_i.grpcd, 'X667', 1, 0) as inbody 
                        from
                            consult
                            , rsl
                            , grp_i
                            , kensa_master 
                        where
                            consult.rsvno = :rsvNo
                            and consult.rsvno = rsl.rsvno 
                            and rsl.itemcd = grp_i.itemcd 
                            and rsl.suffix = grp_i.suffix 
                            and grp_i.grpcd = kensa_master.zyushinsya_kensaryui_biko2 
                            and length(kensa_master.zyushinsya_kensaryui_biko2) > 0 
                            and nvl(rsl.stopflg, ' ') <> 'S' 
                        group by
                            consult.perid
                            , consult.rsvno
                            , grp_i.grpcd
                    ) result 
                group by
                    result.perid
                    , result.rsvno

                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvNo = rsvno
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return result;
        }

        /// <summary>
        /// 特定健診チェック
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <returns></returns>
        private dynamic CheckSp(int rsvno)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    count(ctrpt_opt.setclasscd) as spcount 
                from
                    consult
                    , receipt
                    , consult_o
                    , ctrpt_opt 
                where
                    consult.rsvno = :rsvNo
                    and consult.cancelflg = :cancelflg  
                    and consult.rsvno = receipt.rsvno 
                    and consult.rsvno = consult_o.rsvno 
                    and consult_o.ctrptcd = ctrpt_opt.ctrptcd 
                    and consult_o.optcd = ctrpt_opt.optcd 
                    and consult_o.optbranchno = ctrpt_opt.optbranchno 
                    and ctrpt_opt.setclasscd = :setclasscd
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvNo = rsvno,
                setclasscd = CNST_SETCLASS_SP,
                cancelflg = ConsultCancel.Used
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? 0 : Convert.ToInt32( result.SPCOUNT);
        }

        /// <summary>
        /// 特定保健指導対象者チェック
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <returns></returns>
        private dynamic CheckSpecialTarget(int rsvno)
        {
            // SQLステートメント定義
            string sql = @"
                select
                    consult.rsvno 
                from
                    consult
                    , receipt
                    , consult_o
                    , ctrpt_opt
                    , free 
                where
                    consult.rsvno = :rsvNo 
                    and consult.rsvno = receipt.rsvno 
                    and consult.cancelflg = :cancelflg  
                    and consult.rsvno = consult_o.rsvno 
                    and consult_o.ctrptcd = ctrpt_opt.ctrptcd 
                    and consult_o.optcd = ctrpt_opt.optcd 
                    and consult_o.optbranchno = ctrpt_opt.optbranchno 
                    and ctrpt_opt.setclasscd = :setclasscd 
                    and free.freecd like :freecd_sp
                    and consult.orgcd1 = free.freefield1 
                    and consult.orgcd2 = free.freefield2 
                    and trunc(consult.age) between to_number(free.freefield3) and to_number(free.freefield4) 
                    and consult.csldate between to_date(free.freefield5, 'YYYY/MM/DD') and to_date(free.freefield6, 'YYYY/MM/DD')
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvNo = rsvno,
                setclasscd = CNST_SETCLASS_SP,
                freecd_sp = CNST_FREECD_SP_ORG,
                cancelflg = ConsultCancel.Used
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? false : true;
        }

    }
}
