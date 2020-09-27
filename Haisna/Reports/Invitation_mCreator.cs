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
    /// 一括送付案内（メディローカス版）生成クラス
    /// </summary>
    public class Invitation_mCreator : PdfCreator
    {

        /// <summary>
        /// 帳票コード
        /// </summary>
        public override string ReportCd { get; } = "002055";

        /// <summary>
        /// 定数
        /// </summary>
        private const string CNST_FREE_COURSE = "MEDI0001";
        private const string CNST_FREE_OPTION = "MEDI0002";
        private const string CNST_FREE_TIME = "MEDI0003";
        
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
        /// 一括送付案内（メディローカス版）データを読み込む
        /// </summary>
        /// <returns>一括送付案内（メディローカス版）データ</returns>
        protected override List<dynamic> GetData()
        {
            // SQLステートメント定義
            string sql = @"
                select distinct
                    person.perid as perid
                    , 'A' || consult.rsvno || 'A' as rsvnobar
                    , consult.formouteng as formouteng
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
                    and consult.ctrptcd = ctrpt.ctrptcd 
                    and consult.cancelflg = :cancelflg  
                    and consult.rsvstatus = 0 
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
        /// <param name="data">ご案内書送付チェックリストデータ</param>
        protected override void SetFieldValue(CnForms cnForms, List<dynamic> data)
        {

            CnForm cnForm = cnForms[0];

            // フォームのオブジェクト取得
            CnObjects cnObjects = cnForm.CnObjects;
            CnLayers cnLayers = cnForm.CnLayers;

            // フォームの各項目を変数にセット
            var zukeiLayer = cnLayers["図形"];
            var yoyakujpnLayer = cnLayers["予約情報（日本語）"];
            var yoyakuengLayer = cnLayers["予約情報（英語）"];
            var yoyakudataLayer = cnLayers["予約情報（データ）"];
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


            string sysdate = DateTime.Today.ToShortDateString();

            int pageNo = 0;

            int dataPos = 0;

            // ページ内の項目に値をセット
            while (dataPos < data.Count)
            {
                var detail = data[dataPos];

                // キャンセルされた場合キャンセル用の例外をThrowする
                CheckCanceled();
                
                short currentLine = 0;

                //全レイヤの印刷をOFF
                zukeiLayer.VisibleAtPrint = false;
                yoyakujpnLayer.VisibleAtPrint = false;
                yoyakuengLayer.VisibleAtPrint = false;
                yoyakudataLayer.VisibleAtPrint = false;

                //共通予約者情報の編集
                //印刷レイヤの設定（ON）
                zukeiLayer.VisibleAtPrint = true;
                yoyakudataLayer.VisibleAtPrint = true;
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

                //受診日
                csldateField.Text = Util.ConvertToString(detail.CSLDATE);

                //曜日
                if (Util.ConvertToString(detail.FORMOUTENG) == "1")
                {
                    yobiField.Text = Util.ConvertToString(detail.EYOBI);
                }
                else
                {
                    yobiField.Text = Util.ConvertToString(detail.JYOBI);
                }

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
                if (Util.ConvertToString(detail.PERID) != "" && (Convert.ToString(detail.PERID).Substring(0, 1) == "@"))
                {
                    peridField.Text = "";
                }
                else
                {
                    peridField.Text = Util.ConvertToString(detail.PERID);
                }

                //自宅電話番号
                telhomeField.Text = Util.ConvertToString(detail.TELHOM);

                //会社電話番号
                teloffField.Text = Util.ConvertToString(detail.TELOFF);

                //携帯電話番号
                telperField.Text = Util.ConvertToString(detail.PHONE);

                //コース名取得
                var retCs = GetFree(detail.RSVNO, CNST_FREE_COURSE);

                if ( retCs.Count > 0 )
                {
                    if (Util.ConvertToString(detail.FORMOUTENG) == "1")
                    {
                        courseField.Text = Util.ConvertToString(retCs[0].FREEFIELD3).Trim();
                    }
                    else
                    {
                        courseField.Text = Util.ConvertToString(retCs[0].FREEFIELD2).Trim();
                    }
                }

                //オプション名編集
                var retOpt = GetFree(detail.RSVNO, CNST_FREE_OPTION);

                if (retOpt.Count > 0)
                {
                    currentLine = 0;

                    foreach ( var opt in retOpt )
                    {
                        if (Util.ConvertToString(detail.FORMOUTENG) == "1")
                        {
                            optionListField.ListCell(0, currentLine).Text = Util.ConvertToString(opt.FREEFIELD3).Trim();
                        }
                        else
                        {
                            optionListField.ListCell(0, currentLine).Text = Util.ConvertToString(opt.FREEFIELD2).Trim();
                        }
                        currentLine++;
                    }
                }

                //受付時間取得
                var retHour = GetFree(detail.RSVNO, CNST_FREE_TIME);

                if (retHour.Count > 0)
                {
                    hourField.Text = Util.ConvertToString(retHour[0].OPTNAME).Trim();
                }

                pageNo++;

                dataPos++;

                // ドキュメントの出力
                PrintOut(cnForm);

            }

        }


        /// <summary>
        /// メディローカス汎用情報取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="freeCd">汎用コード</param>
        /// <returns>検索結果（1：有, -1：無）</returns>
        private dynamic GetFree(int rsvNo, string freeCd)
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
                    and free.freecd like :freecd
                ";

            // パラメータセット
            var sqlParam = new
            {
                rsvno = rsvNo,
                freecd = freeCd + "%"
            };

            // SQLステートメント実行
            dynamic result = connection.Query(sql, sqlParam).ToList();

            // 戻り値設定
            return result;
        }


    }
}
