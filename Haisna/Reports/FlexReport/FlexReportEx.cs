using Dapper;
using Hainsi.Model.FlexReportCommon;
using Hos.CnDraw;
using Hos.CnDraw.Object;
using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Hainsi.Common;
using Microsoft.VisualBasic;

namespace Hainsi.Reports
{
    public class FlexReportEx
    {
        private IDbConnection connection;

        private const string FREECD_FLEXGRAPH = "FLEXGRAPH%";   // 汎用コード(グラフ項目)
        private const string FREECD_FREEDIV = "FREEDIV%";       // 汎用コード(フリー区分)
        private const string FREECD_RISKITEM = "SCRRISKITM%";   // 汎用コード(リスクポイント項目)

        private const string CSCD_TEIKEN1 = "0100";     // コースコード(定健１次)
        private const string CSCD_NYUSHA = "0700";      // コースコード(入健１次)
        private const string CSCD_TOKUTAI1 = "0800";    // コースコード(特退１次)
        private const string CSCD_TOKUTAI2 = "0801";    // コースコード(特退２次)
        private const string CSCD_FAMILY1 = "0900";     // コースコード(家族１次)
        private const string CSCD_FAMILY2 = "0901";     // コースコード(家族２次)
        private const string CSCD_TOKEN1 = "0500";      // コースコード(特健１次)
        private const string CSCD_TOKEN2 = "0600";      // コースコード(特健２次)
        private const string CSCD_TOKEN3 = "0501";      // コースコード(鉛)
        private const string CSCD_TOKEN4 = "0502";      // コースコード(有機溶剤)
        private const string CSCD_TOKEN5 = "0503";      // コースコード(じん肺)
        private const string CSCD_TOKEN6 = "0504";      // コースコード(ＶＤＴ)
        private const string CSCD_TOKEN7 = "0505";      // コースコード(電光性眼炎)
        private const string CSCD_TOKEN8 = "0506";      // コースコード(振動工具)
        private const string CSCD_TOKEN9 = "0507";      // コースコード(電離放射線)
        private const string CSCD_TOKEN10 = "0508";     // コースコード(打鍵者健診)
        private const string CSCD_TOKEN11 = "0509";     // コースコード(動力車健診)
        private const string CSCD_TOKEN12 = "0510";     // コースコード(医学適正検査)
        private const string CSCD_TOKEN13 = "0601";     // コースコード(ＶＤＴ２次)
        private const string CSCD_TOKEN14 = "0602";     // コースコード(打鍵者健診２次)
        private const string CSCD_TOKEN15 = "0603";     // コースコード(動力車健診２次)
        private const string CSCD_TOKEN16 = "0604";     // コースコード(医学適正検査２次)
        private const string CSCD_KAIGAI = "1000";      // コースコード(海外)

        private const string GRPCD_KIOU = "R001";       // グループコード(既往歴)
        private const string GRPCD_JIKAKU = "R002";     // グループコード(自覚症状)
        private const string GRPCD_KANSEN = "R003";     // グループコード(感染症)
        private const string GRPCD_KIOU2 = "R004";      // グループコード(既往歴)
        private const string GRPCD_GENBYO = "R005";     // グループコード(現病歴)
        private const string GRPCD_JIKAKU2 = "R006";    // グループコード(自覚症状)
        private const string GRPCD_TAKAKU = "R007";     // グループコード(他覚症状)
        private const string GRPCD_VDTNAIYO = "R008";   // グループコード(ＶＤＴ作業内容)
        private const string GRPCD_VDTKIOU = "R009";    // グループコード(ＶＤＴ既往歴)
        private const string GRPCD_VDTJYOTAI = "R010";  // グループコード(ＶＤＴ眼の状態)

        private const string ITEMCD_BREAST_K = "031000";    // 検査項目コード(胸部間接)
        private const string ITEMCD_BREAST_C = "032000";    // 検査項目コード(胸部直接)
        private const string ITEMCD_STOMACH_B = "042000";   // 検査項目コード(胃部直接)
        private const string ITEMCD_STOMACH_C = "043000";   // 検査項目コード(胃内視鏡)

        private const string ITEMCD_TOKEN3 = "300300";    // 検査項目コード(鉛判定)
        private const string ITEMCD_TOKEN4 = "523900";    // 検査項目コード(有機判定)
        private const string ITEMCD_TOKEN5 = "524900";    // 検査項目コード(じん肺判定)
        private const string ITEMCD_TOKEN6 = "519900";    // 検査項目コード(ＶＤＴ判定)
        private const string ITEMCD_TOKEN7 = "527900";    // 検査項目コード(電光判定)
        private const string ITEMCD_TOKEN8 = "527900";    // 検査項目コード(振動判定)
        private const string ITEMCD_TOKEN9 = "525900";    // 検査項目コード(電離判定)
        private const string ITEMCD_TOKEN10 = "526900";   // 検査項目コード(打鍵者判定)
        private const string ITEMCD_TOKEN11 = "300240";   // 検査項目コード(動力車判定)
        private const string ITEMCD_TOKEN12 = "300610";   // 検査項目コード(医学判定)

        private const string GUIDANCE_1 = "所見の説明";
        private const string GUIDANCE_2 = "生活・食事指導";
        private const string GUIDANCE_3 = "経過追跡";
        private const string GUIDANCE_4 = "要精密検査";
        private const string GUIDANCE_5 = "要治療";
        private const string GUIDANCE_6 = "受診のすすめ";
        private const string GUIDANCE_7 = "運動指導";
        private const string GUIDANCE_8 = "心理相談";

        private const string JUDCD_D = "D";     // 判定コード(要診察)
        private const string JUDCD_R = "R";     // 判定コード(再検査)

        private const int JUDCLASSCD_STOMACH = 70;    // 判定分類コード(胃)

        private const string GRPCD_IKBN = "X502";           // グループコード(胃区分)
        private const string GRPCD_ECHO = "X512";           // グループコード(上腹部超音波)
        private const string GRPCD_ALCOHOL = "X504";        // グループコード(飲酒摂取量)
        private const string GRPCD_SHIKOUHIN = "X505";      // グループコード(嗜好品)
        private const string GRPCD_TYOSYOKU = "X506";       // グループコード(朝食摂取習慣)
        private const string GRPCD_TYUSYOKU = "X507";       // グループコード(昼食摂取習慣)
        private const string GRPCD_YUSYOKU = "X508";        // グループコード(夕食摂取習慣)
        private const string GRPCD_BLOOD = "X509";          // グループコード(血液検査)
        private const string GRPCD_SYOKUCMT = "X510";       // グループコード(食習慣コメント)
        private const string GRPCD_KONDATECMT = "X511";     // グループコード(献立コメント)
        private const string GRPCD_JYOUBU = "X513";         // グループコード(上部消化管)
        private const string GRPCD_KYOUBU_X = "X514";       // グループコード(胸部Ｘ線)
        private const string GRPCD_KYOUBU_CT = "X515";      // グループコード(胸部ＣＴ)
        private const string GRPCD_DAICHOU = "X516";        // グループコード(大腸内視鏡)
        private const string GRPCD_KEIBU = "X517";          // グループコード(婦人科／診断・頚部細胞診)
        private const string GRPCD_NAISIN = "X518";         // グループコード(婦人科／内診)
        private const string GRPCD_NYURIGHT = "X519";       // グループコード(乳房超音波検査／右)
        private const string GRPCD_NYULEFT = "X520";        // グループコード(乳房超音波検査／左)
        private const string GRPCD_NYUBOU = "X521";         // グループコード(乳房超音波検査)
        private const string GRPCD_NYUBOUX = "X522";        // グループコード(乳房Ｘ線検査)
        private const string GRPCD_NYUBOUS = "X523";        // グループコード(乳房視触診)
        private const string GRPCD_GANTEI = "X527";         // グループコード(眼底所見)
        private const string GRPCD_FUJINKA_ECHO = "X532";   // グループコード(婦人科超音波所見)
        private const string META_DISEASE_GRPCD = "X068";   // 現病歴グループコード（メタボリック関連）
        private const string DISEASE_GRPCD = "X026";        // 現病歴・既往歴グループコード
        private const string ALCOHOL_GRPCD = "X038";        // アルコール換算グループコード
        private const string GRPCD_DAICYO_CT = "X529";      // グループコード(大腸３Ｄ－ＣＴ所見)
        private const string GRPCD_PLAQUE = "X530";         // グループコード(頸動脈超音波プラーク)

        private const string FREECD_IKBN = "LST000022%";    // 汎用コード(胃区分)
        private const string FREECD_ORGGRP = "LST00302%";   // 汎用コード(団体グループ)
        private const string FREECD_ORGGRP2 = "LST00304%";  // 汎用コード(団体グループ)
        private const string FREECD_ORGGRP3 = "LST00305%";  // 汎用コード(団体グループ)

        private const string CMT_KAKO1 = "「Ｃ」・「Ｄ」の判定結果については産業医の指示をお受け下さい。";
        private const string CMT_KAKO2 = "この結果表受理から１ヵ月後に、結果表をお持ちの上、すみだ健康開発室にいらして下さい。産業医との面談をお受け下さい。";
        private const string CMT_ADDKENSA = "追加検査（基準値参照）については、主治医もしくは所属の健康管理担当者にご相談ください。";
        private const string CMT_ADDKENSA_EN = "About optional blood test, please consult with a family doctor or person in charge of health care.";
        private const string CMT_ADDSPECIAL = "今後の保健指導については加入されている医療保険者にご相談ください。";
        private const string CMT_INBODY = "測定結果は健診当日にお渡し済みです。";
        private const string CMT_INBODY_E = "The measurement results have been handed to you on the day of the health check-up.";

        private const string INBODY_SETCLASSCD = "096";     // インボディセット分類コード

        private const string FREECD_BLOOD = "RPTV001";          // 血液検査
        private const string FREECD_DAICHOU = "RPTV002";        // 大腸内視鏡
        private const string FREECD_KYOUBU_CT = "RPTV003";      // 胸部ＣＴ
        private const string FREECD_KAKKUTAN = "RPTV004";       // 喀痰
        private const string FREECD_NYUBOUX = "RPTV005";        // 乳房Ｘ線検査
        private const string FREECD_NYUBOU = "RPTV006";         // 乳房超音波検査
        private const string FREECD_3DCT = "RPTV007";           // 大腸３Ｄ－ＣＴ
        private const string FREECD_KEICHOU = "RPTV008";        // 頸動脈超音波
        private const string FREECD_CAVI = "RPTV009";           // 動脈硬化
        private const string FREECD_FATCT = "RPTV010";          // 内臓脂肪測定
        private const string FREECD_NTPRO = "RPTV011";          // 心不全スクリーニング
        private const string FREECD_FUJINKAECHO = "RPTV012";    // 婦人科超音波
        private const string FREECD_ANA = "RPTV013";            // 抗核抗体
        private const string FREECD_CCPA = "RPTV014";           // 抗ＣＣＰ抗体
        private const string FREECD_FERRITIN = "RPTV015";       // フェリチン
        private const string FREECD_HP = "RPTV016";             // 便中ピロリ菌抗原検査
        private const string FREECD_PECT = "RPTV017";           // CT肺気腫
        private const string FREECD_VASCULITIS = "RPTV018";     // 血管炎検査
        private const string FREECD_FUJIN = "RPTD001";          // 婦人科
        private const string FREECD_NYUBOUS = "RPTD002";        // 乳房視触診
        private const string FREECD_KESSEI = "RPTD003";         // 血清
        private const string FREECD_PSA = "RPTD004";            // 前立腺
        private const string FREECD_NPT = "NPRT100%";           // 1日ドック出力項目制御管理コード
        private const string FREECD_NPT2 = "NPRT110%";          // 企業出力項目制御管理コード
        private const string FREECLASS_CTR = "CTR";             // オプション検査の個人負担金チェック
        private const string FREECLASS_NPT = "NPT";             // 成績書オプション出力管理より優先して健診コース別で出力を制御
        private const string FREECLASS_SPT = "SPT";             // 過去健診結果を出力する団体

        private const string ITEMCD_KAKKUTAN = "21140-01";
        private const int KESSEI_JUDCLASSCD = 17;           // 血清
        private const int PSA_JUDCLASSCD = 18;              // 前立腺
        private const int FUJIN_JUDCLASSCD = 25;            // 婦人科
        private const int OBJ_INVISIBLE = 1;
        private const int OBJ_VISIBLE = 2;

        private const string OPTION_CT = "K0540";        // Option CT
        private const string OPTION_NYUBOUX = "K0570";   // Option 乳房Ｘ線
        private const string OPTION_ECHO = "K0580";      // Option 乳房超音波
        private const string OPTION_KAKKUTAN = "K0610";  // Option 喀痰
        private const string OPTION_CEA = "K0410";       // Option 喀痰

        private const int OPRICE_CT = 15000;
        private const int OPRICE_NYUBOUX = 3000;
        private const int OPRICE_ECHO = 4000;
        private const int OPRICE_KAKKUTAN = 3000;

        private const string FU_SINDAN_CODE = "27820";      // 婦人科診断
        private const string FU_CLASS_CODE = "27010";       // 婦人科クラス
        private const string FU_NAISIN_CODE = "27030";      // 婦人科内診
        private const string FU_BETHE_CODE = "27050";       // 婦人科ベセスダ分類
        private const string FU_FCLASS_KEBU = "FC1";
        private const string FU_FCLASS_KEBU2 = "FC2";
        private const string FU_FCLASS_CLASS = "FC3";

        private const string ITEMCD_TYOSYOKU = "61240-00";     // 検査項目コード(朝食摂取習慣（有無）)
        private const string ITEMCD_TYUSYOKU = "61250-00";     // 検査項目コード(昼食摂取習慣（有無）)
        private const string ITEMCD_YUSYOKU = "61260-00";      // 検査項目コード(夕食摂取習慣（有無）)

        private const string IBU_NAISIKYODATE = "RESULT_23110-00";
        private const string IBU_NAISIKYOLABEL = "LabelNDate";

        private const int NYUBOU_JUDCLASSCD = 24;       // 乳房
        private const int NYUSYOKU_JUDCLASSCD = 54;     // 乳房触診
        private const int NYUXSEN_JUDCLASSCD = 55;      // 乳房Ｘ線
        private const int NYUCHOU_JUDCLASSCD = 56;      // 乳房超音波

        private const int DAI3DCT_JUDCLASSCD = 33;      // 大腸３Ｄ－ＣＴ
        private const int KEICHOU_JUDCLASSCD = 34;      // 頸動脈超音波
        private const int CAVI_JUDCLASSCD = 35;         // 動脈硬化
        private const int FATCT_JUDCLASSCD = 36;        // 内臓脂肪測定
        private const int NTPRO_JUDCLASSCD = 37;        // 心不全スクリーニング

        private const string CMTCD_META1 = "105003";        // メタボリックシンドロームに該当しません。
        private const string CMTCD_META2 = "105004";        // メタボリックシンドローム予備群に該当します。
        private const string CMTCD_META3 = "105005";        // メタボリックシンドローム基準に該当します。
        private const string CMTCD_META4 = "105006";        // メタボリックシンドロームについては、判定不能です。

        private const string SPECIAL_SETCLASSCD = "660";           // 特定健診セット分類コード

        private const string CMT_SMOKING = "④　現在、たばこを吸っている";
        private const string CMT_NO_SMOKING = "④　現在、たばこを吸っていない";

        private const string CMTCD_HPV = "102580";        // 1年後HPV検査を受けられることをお勧めします。

        private const double PI = 3.14159265358979;    // 円周率

        private const int EATINGHABITS_CENTER_X = 245;              // 正三角形中央の横位置(mm)
        private const int EATINGHABITS_CENTER_Y = 109;              // 正三角形中央の縦位置(mm)
        private const int EATINGHABITS_DISTANCE = 20;               // 正三角形中央から頂点までの距離(mm)
        private const int EATINGHABITS_DISTANCE_OF_MINVALUE = 2;    // 三角形中央から各プロット項目の最小値位置までの距離(mm)

        //TODO
        private const string EATINGHABITS_RECTANGLEFILLCOLOR = "&HF1D9C7";  // 三角形の背景色
        private const string EATINGHABITS_LINECOLOR = "&H7A471F";           // 三角形の線色
        private const string EATINGHABITS_RESULTCOLOR = "&HFF";             // 検査結果の線色

        private const int EATINGHABITS_LINEWIDTH = 26;          // 線の太さ(1/100mm)
        private const int EATINGHABITS_LINEBORDERWIDTH = 80;    // 三角形の線の太さ(1/100mm)
        private const int EATINGHABITS_RESULTLINEWIDTH = 80;    // 食習慣バランスの三角形の線の太さ(1/100mm)

        private const int EATINGHABITS_VERTEX1_CAPTION_X = 2;   // 食べ方(キャプション値の頂点からの相対X座標)
        private const int EATINGHABITS_VERTEX1_CAPTION_Y = -2;  // 食べ方(キャプション値の頂点からの相対Y座標)
        private const int EATINGHABITS_VERTEX1_RESULT_X = -3;   // 食べ方(頂点値の頂点からの相対X座標)
        private const int EATINGHABITS_VERTEX1_RESULT_Y = -2;   // 食べ方(頂点値の頂点からの相対Y座標)
        private const int EATINGHABITS_RESULT1_MAX = 0;         // 食べ方(頂点の点数値)
        private const int EATINGHABITS_RESULT1_MIN = -8;        // 食べ方(中央の点数値)

        private const int EATINGHABITS_VERTEX2_CAPTION_X = -5;  // 食習慣(キャプション値の頂点からの相対X座標)
        private const int EATINGHABITS_VERTEX2_CAPTION_Y = 1;   // 食習慣(キャプション値の頂点からの相対Y座標)
        private const int EATINGHABITS_VERTEX2_RESULT_X = -2;   // 食習慣(頂点値の頂点からの相対X座標)
        private const int EATINGHABITS_VERTEX2_RESULT_Y = -3;   // 食習慣(頂点値の頂点からの相対Y座標)
        private const int EATINGHABITS_RESULT2_MAX = 0;         // 食習慣(頂点の点数値)
        private const int EATINGHABITS_RESULT2_MIN = -11;       // 食習慣(中央の点数値)

        private const int EATINGHABITS_VERTEX3_CAPTION_X = -6;  // 食事内容(キャプション値の頂点からの相対X座標)
        private const int EATINGHABITS_VERTEX3_CAPTION_Y = 1;   // 食事内容(キャプション値の頂点からの相対Y座標)
        private const int EATINGHABITS_VERTEX3_RESULT_X = 1;    // 食事内容(頂点値の頂点からの相対X座標)
        private const int EATINGHABITS_VERTEX3_RESULT_Y = -3;   // 食事内容(頂点値の頂点からの相対Y座標)
        private const int EATINGHABITS_RESULT3_MAX = 0;         // 食事内容(頂点の点数値)
        private const int EATINGHABITS_RESULT3_MIN = -16;       // 食事内容(中央の点数値)

        private string HISTORYVIEW;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public FlexReportEx(IDbConnection connection)
        {
            this.connection = connection;
        }

        /// <summary>
        /// グラフ描画
        /// 備考　: γ -GTP､血糖値､総コレステロール､BMIの検査結果推移グラフを出力｡
        /// 　　　  縦軸は基準値の上限値､下限値を標準域とし､これに対して半減値､2倍値､5倍値､10倍値､20倍値を設け､各検査結果値をこの相対値に変換｡
        ///　　　   横軸は最新の受診情報と､最新の受診情報を含まない過去最大5回分の1次健診受診情報､そして入社健診を出力対象とする｡
        ///　　　   受診情報の並びは､最右を最新受診情報として左に行くほど過去となる｡そして最左を入社健診とする｡過去5回未満の場合､入社健診は右詰め｡
        /// </summary>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        /// <param name="colItems"></param>
        /// <param name="lngRsvNo"></param>
        /// <param name="lngTop"></param>
        /// <param name="lngLeft"></param>
        /// <param name="lngHeight"></param>
        /// <param name="lngWidth"></param>
        /// <param name="lngHanreiLeft"></param>
        private void DrawGraph(CnForm cnForm, RepItems colItems, int lngRsvNo, int lngTop, int lngLeft, int lngHeight, int lngWidth, int lngHanreiLeft)
        {
            const int HEIGHT_DEF = 47; // グラフ高さの基準値
            const int SPAN_Y1 = 1;     // topから20倍値までの間隔(上の基準値を元にした相対値)
            const int SPAN_Y2 = 2;     // 20倍値から10倍値までの間隔(上の基準値を元にした相対値)
            const int SPAN_Y3 = 3;     // 10倍値から5倍値までの間隔(上の基準値を元にした相対値)
            const int SPAN_Y4 = 4;     // 5倍値から2倍値までの間隔(上の基準値を元にした相対値)
            const int SPAN_Y5 = 5;     // 2倍値から基準値上限までの間隔(上の基準値を元にした相対値)
            const int SPAN_Y6 = 3;     // 基準値下限から1/2倍値までの間隔(上の基準値を元にした相対値)
            const int SPAN_Y7 = 2;     // 1/2倍値から最下までの間隔(上の基準値を元にした相対値)

            string strPrevItemCd;   // 直前の検査項目コード
            string strPrevSuffix;   // 直前のサフィックス

            IList<string> vntItemCd = new List<string>();       // 検査項目コードの配列
            IList<string> vntSuffix = new List<string>();       // サフィックスの配列
            IList<string> vntItemName = new List<string>();     // 検査項目名称の配列
            IList<string> vntMark = new List<string>();         // プロットマークの配列
            IList<DateTime> vntCslDate = new List<DateTime>();  // 受診日の配列
            IList<string> vntCsSName = new List<string>();      // コース略称の配列
            IList<string> vntResult = new List<string>();       // 検査結果の配列
            IList<string> vntLowerValue = new List<string>();   // 基準値(最小)の配列
            IList<string> vntUpperValue = new List<string>();   // 基準値(最大)の配列
            int lngCount;     // レコード数

            int lngHistoryCount;   // 受診歴数
            int lngLeftMargin;   // 左右のマージン値

            int lngHistoryLeft;    // 受診歴Ｘ座標の最左値
            int lngHistoryRight;   // 受診歴Ｘ座標の最右値
            int lngSpan;           // 各受診歴Ｘ座標の間隔

            int[] lngX;   // 各受診歴のＸ座標
            int lngSep;   // 目盛りの長さ

            int lngY20Sd;           // 20倍値(Ｙ座標)
            int lngY10Sd;           // 10倍値(Ｙ座標)
            int lngY5Sd;            // 5倍値(Ｙ座標)
            int lngY2Sd;            // 2倍値(Ｙ座標)
            int lngYUpper;          // 基準値上限(Ｙ座標)
            int lngYLower;          // 基準値下限(Ｙ座標)
            int lngYHalfSd;         // 1/2倍値(Ｙ座標)
            int lngYMinusSd;        // -1倍値(Ｙ座標)

            double dblResult;       // 検査結果
            double dblLowerValue;   // 基準値(最小)
            double dblUpperValue;   // 基準値(最大)

            double dblDiff;         // 基準値最大と最小の差分値
            double dbl20Sd;         // 20倍値(絶対値)
            double dbl10Sd;         // 10倍値(絶対値)
            double dbl5Sd;          // 5倍値(絶対値)
            double dbl2Sd;          // 2倍値(絶対値)
            double dblHalfSd;       // 1/2倍値(絶対値)
            double dblMinusSd;      // -1倍値(絶対値)

            int lngPrevX;           // 直前にプロットしたＸ座標
            int lngPrevY;           // 直前にプロットしたＹ座標
            int lngY;               // 検査結果のＹ座標
            bool blnEditName;       // 名前を編集したか
            int lngHanreiY;         // 凡例のＹ座標
            int lngHistoryIndex;    // 受診歴のインデックス


        }

        /// <summary>
        /// 報告書の外部クラス
        /// 備考　　 : ①本メソッドは個別仕様に対応する外部メソッドである
        /// 　　　　   ②本メソッドは１つの受診情報に対し、定義されたフォームファイル数分呼び出される
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        public void EditItem(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {
            // 基準値表示変換
            EditStdValue(cnForm);

            // フォーム名による処理振り分け
            switch (cnForm.Name)
            {
                // 健康診断報告書の場合
                case "TEIKEN":
                    EditItem_Teiken(colItems, objRepConsult, cnForm);
                    break;

                // 健康簿１枚目の場合
                case "KENKOUBO1":
                    EditItem_Kenkoubo1(colItems, objRepConsult, cnForm);
                    break;

                // 健康簿２枚目の場合
                case "KENKOUBO2":
                    EditItem_Kenkoubo2(colItems, objRepConsult, cnForm);
                    break;

                // 個人票の場合
                case "KOJINHYO":
                    EditItem_KojinHyo(colItems, objRepConsult, cnForm);
                    break;

                // 海外の場合
                case "KAIGAI":
                    EditItem_Kaigai(colItems, objRepConsult, cnForm);
                    break;

                // VDTの場合
                case "VDT":
                    EditItem_Vdt(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書１枚目、新６連成績書１枚目、肺ドック１枚目
                case "REPORT6_1":
                case "REPORT6NEW_1":
                case "REPORTHAI_1":
                    EditItem_Report6_1(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書２枚目、新６連成績書２枚目
                case "REPORT6_2":
                case "REPORT6NEW_2":
                    EditItem_Report6_2(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書３枚目、新６連成績書３枚目
                case "REPORT6_3":
                case "REPORT6NEW_3":
                    EditItem_Report6_3(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書４枚目、新６連成績書４枚目
                case "REPORT6_4":
                case "REPORT6NEW_4":
                    EditItem_Report6_4(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書５枚目、新６連成績書５枚目
                case "REPORT6_5":
                case "REPORT6NEW_5":
                    EditItem_Report6_5(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書６枚目、新６連成績書６枚目
                case "REPORT6_6":
                case "REPORT6NEW_6":
                    EditItem_Report6_6(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書英語版１枚目
                case "REPORT6E_1":
                    EditItem_Report6E_1(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書英語版２枚目
                case "REPORT6E_2":
                    EditItem_Report6E_2(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書英語版３枚目
                case "REPORT6E_3":
                    EditItem_Report6E_3(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書英語版４枚目
                case "REPORT6E_4":
                    EditItem_Report6E_4(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書英語版５枚目
                case "REPORT6E_5":
                    EditItem_Report6E_5(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書英語版５枚目
                case "REPORT6E_5_2011":
                    EditItem_Report6E_5_2011(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書英語版６枚目
                case "REPORT6E_6":
                    EditItem_Report6E_6(colItems, objRepConsult, cnForm);
                    break;

                // ３連成績書(企業版)１枚目
                case "Report_3ream_1":
                    EditItem_Report3_1(colItems, objRepConsult, cnForm);
                    break;

                // ３連成績書(企業版)２枚目
                case "Report_3ream_2":
                    EditItem_Report3_2(colItems, objRepConsult, cnForm);
                    break;

                // ３連成績書(企業版)３枚目
                case "Report_3ream_3":
                    EditItem_Report3_3(colItems, objRepConsult, cnForm);
                    break;

                // 総合判定表(１枚もの)
                case "Report_1ream":
                    EditItem_Report1(colItems, objRepConsult, cnForm);
                    break;

                // 総合判定表(肺ドック)
                case "REPORTHAI_2":
                    EditItem_ReportHAI_2(colItems, objRepConsult, cnForm);
                    break;

                // 法定項目成績表日本語版(A4)
                case "REPORTLAW":
                    EditItem_ReportLAW(colItems, objRepConsult, cnForm);
                    break;

                // 結核成績表（胸部X線のみ）日本語版(A5)
                case "REPORTCR":
                    EditItem_ReportCR(colItems, objRepConsult, cnForm);
                    break;

                // 新３連成績書(企業版)１枚目
                case "Report_3New_1":
                    EditItem_Report3N_1(colItems, objRepConsult, cnForm);
                    break;

                // 新３連成績書(企業版)２枚目
                case "Report_3New_2":
                    EditItem_Report3N_2(colItems, objRepConsult, cnForm);
                    break;

                // 新３連成績書(企業版)３枚目
                case "Report_3New_3":
                    EditItem_Report3N_3(colItems, objRepConsult, cnForm);
                    break;

                //  婦人科判定分離
                case "REPORT6N320_1":
                    EditItem_Report6N320_1(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書２枚目、新６連成績書２枚目
                // TODO case "REPORT6_2":
                case "REPORT6N320_2":
                    EditItem_Report6N320_2(colItems, objRepConsult, cnForm);
                    break;

                //  2011.01.01版対応
                // 新６連成績書２枚目
                case "REPORT6N320_2_2011":
                    EditItem_Report6N320_2(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書３枚目、新６連成績書３枚目
                // TODO case "REPORT6_3":
                case "REPORT6N320_3":
                    EditItem_Report6N320_3(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書４枚目、新６連成績書４枚目
                // TODO case "REPORT6_4":
                case "REPORT6N320_4":
                    EditItem_Report6N320_4(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書５枚目、新６連成績書５枚目
                // TODO case "REPORT6_5":
                case "REPORT6N320_5":
                    EditItem_Report6N320_5(colItems, objRepConsult, cnForm);
                    break;

                //  2011.01.01版対応
                // 新６連成績書４枚目
                case "REPORT6N320_4_2011":
                    EditItem_Report6N320_4_2011(colItems, objRepConsult, cnForm);
                    break;

                // 新６連成績書５枚目
                case "REPORT6N320_5_2011":
                    EditItem_Report6N320_5(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書６枚目、新６連成績書６枚目
                // TODO case "REPORT6_6":
                case "REPORT6N320_6":
                    EditItem_Report6N320_6(colItems, objRepConsult, cnForm);
                    break;

                // 特定健診成績書７枚目
                case "REPORT6N320_7":
                    EditItem_Report6N320_7(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書英語版１枚目
                case "REPORT6E321_1":
                    EditItem_Report6E321_1(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書英語版２枚目
                case "REPORT6E321_2":
                case "REPORT6E321_2_2011":
                    EditItem_Report6E321_2(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書英語版３枚目
                case "REPORT6E321_3":
                    EditItem_Report6E321_3(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書英語版４枚目
                case "REPORT6E321_4":
                    EditItem_Report6E321_4(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書英語版４枚目　2011.01.01板
                case "REPORT6E321_4_2011":
                    EditItem_Report6E321_4_2011(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書英語版５枚目
                case "REPORT6E321_5":
                case "REPORT6E321_5_2011":
                    EditItem_Report6E321_5(colItems, objRepConsult, cnForm);
                    break;

                // ６連成績書英語版６枚目
                case "REPORT6E321_6":
                    EditItem_Report6E321_6(colItems, objRepConsult, cnForm);
                    break;

                // 総合判定表(１枚もの)
                case "Report_N322":
                    EditItem_ReportN322(colItems, objRepConsult, cnForm);
                    break;
                // 総合判定表(１枚もの)　2011.01.01版
                case "Report_N322_2011":
                    EditItem_ReportN322_2011(colItems, objRepConsult, cnForm);
                    break;

                // 新３連成績書(今回のみ企業版)１枚目
                case "Report_3N323_1":
                    EditItem_Report3N323_1(colItems, objRepConsult, cnForm);
                    break;

                // 新３連成績書(今回のみ企業版)１枚目 　2011.01.01版
                case "Report_3N323_1_2011":
                    EditItem_Report3N323_1_2011(colItems, objRepConsult, cnForm);
                    break;

                // 新３連成績書(今回のみ企業版)１枚目(2013年版)
                case "Report_3N323_1_2013":
                    EditItem_Report3N323_1_2011(colItems, objRepConsult, cnForm);
                    EditItem_View_FujinkaEcho_Judge(objRepConsult, cnForm);
                    break;

                // 新３連成績書(今回のみ企業版)１枚目(2013年版)
                case "Report_3N323_1_20130401":
                    EditItem_Report3N323_1_20130401(colItems, objRepConsult, cnForm);
                    break;

                // 新３連成績書(今回のみ企業版)１枚目(2017年版)
                case "Report_3N323_1_2017":
                    EditItem_Report3N323_1_2017(colItems, objRepConsult, cnForm);
                    break;

                // 新３連成績書(今回のみ企業版)２枚目
                case "Report_3N323_2":
                    EditItem_Report3N323_2(colItems, objRepConsult, cnForm);
                    break;

                // 新３連成績書(今回のみ企業版)３枚目
                case "Report_3N323_3":
                    EditItem_Report3N323_3(colItems, objRepConsult, cnForm);
                    break;

                // 新３連成績書(今回のみ企業版)オプション
                case "Report_3N323_Opt":
                    EditItem_Report3N323_Option(colItems, objRepConsult, cnForm);
                    break;

                // 新３連成績書(今回のみ企業版)オプション(2013年版)
                case "Report_3N323_Opt_2013":
                    EditItem_Report3N323_Option(colItems, objRepConsult, cnForm);
                    EditItem_Report3N323_8_FujinkaEcho(colItems, objRepConsult, cnForm);
                    break;

                // 新３連成績書(今回のみ企業版)オプション(2013年版)
                case "Report_3N323_Opt_20130401":
                    EditItem_Report3N323_Option_20130401(colItems, objRepConsult, cnForm);
                    break;

                // 新３連成績書(今回のみ企業版)オプション(2017年版)
                case "Report_3N323_Opt_2017":
                    EditItem_Report3N323_Option_2017(colItems, objRepConsult, cnForm);
                    break;

                // 新３連成績書(企業版)１枚目
                case "Report_3N353_1":
                    EditItem_Report3N353_1(colItems, objRepConsult, cnForm);
                    break;

                // 新３連成績書(企業版)１枚目 　2011.01.01板
                case "Report_3N353_1_2011":
                    EditItem_Report3N353_1(colItems, objRepConsult, cnForm);
                    break;

                // 新３連成績書(企業版)２枚目
                case "Report_3N353_2":
                    EditItem_Report3N353_2(colItems, objRepConsult, cnForm);
                    break;

                // 新３連成績書(企業版)３枚目
                case "Report_3N353_3":
                    EditItem_Report3N353_3(colItems, objRepConsult, cnForm);
                    break;

                //  2011.01.01版対応
                // 新３連成績書(今回のみ企業版)３枚目
                case "Report_3N323_3_2011":
                    EditItem_Report3N323_3_2011(colItems, objRepConsult, cnForm);
                    break;

                // 新３連成績書(企業版)３枚目
                case "Report_3N353_3_2011":
                    EditItem_Report3N353_3_2011(colItems, objRepConsult, cnForm);
                    break;

                // 新５連成績書(今回のみ企業版)１枚目
                case "Report_5N820_2":
                    EditItem_Report5N820_2(colItems, objRepConsult, cnForm);
                    break;

                //  2011.01.01版対応
                // 新５連成績書(今回のみ企業版)１枚目 2011.01.01版
                case "Report_5N820_2_2011":
                    EditItem_Report5N820_2(colItems, objRepConsult, cnForm);
                    break;

                // 新５連成績書(今回のみ企業版)１枚目(2013年版)
                case "Report_5N820_2_2013":
                    EditItem_Report5N820_2(colItems, objRepConsult, cnForm);
                    EditItem_View_FujinkaEcho_Judge(objRepConsult, cnForm);
                    break;

                // 新５連成績書(今回のみ企業版)２枚目
                case "Report_5N820_3":
                    EditItem_Report5N820_3(colItems, objRepConsult, cnForm);
                    break;

                // 新５連成績書(今回のみ企業版)３枚目
                case "Report_5N820_4":
                    EditItem_Report5N820_4(colItems, objRepConsult, cnForm);
                    break;

                //  2011.01.01版対応
                // 新５連成績書(今回のみ企業版)３枚目 2011.01.01版
                case "Report_5N820_4_2011":
                    EditItem_Report5N820_4_2011(colItems, objRepConsult, cnForm);
                    break;

                // 新５連成績書(今回のみ企業版)４枚目
                case "Report_5N820_5":
                    EditItem_Report5N820_5(colItems, objRepConsult, cnForm);
                    break;

                //  2011.01.01版対応
                // 新５連成績書(今回のみ企業版)４枚目
                case "Report_5N820_5_2011":
                    EditItem_Report5N820_5(colItems, objRepConsult, cnForm);
                    break;

                // 新５連成績書(今回のみ企業版)６枚目
                case "Report_5N820_6":
                    EditItem_Report5N820_6(colItems, objRepConsult, cnForm);
                    break;

                // オプション検査結果表　2011.01.01版
                case "Report_N31_8":
                    EditItem_ReportN31_8(colItems, objRepConsult, cnForm);
                    break;

                // オプション検査結果表(2013年版)
                case "Report_N31_8_2013":
                    EditItem_ReportN31_8(colItems, objRepConsult, cnForm);
                    EditItem_ReportN31_8_2013(colItems, objRepConsult, cnForm);
                    break;

                // オプション検査結果表(2013年版)
                case "Report_N31_8_2017":
                    EditItem_ReportN31_8_2017(colItems, objRepConsult, cnForm);
                    break;

                // オプション検査結果表(英語)　2011.01.01版
                case "Report_N30_Opt":
                    EditItem_ReportN31E_8(colItems, objRepConsult, cnForm);
                    break;

                // オプション検査結果表(英語)(2013年版)
                case "Report_N30_Opt_2013":
                    EditItem_ReportN31E_8(colItems, objRepConsult, cnForm);
                    EditItem_ReportN31E_8_2013(colItems, objRepConsult, cnForm);
                    break;

                // オプション検査結果表(英語)(2017年版)
                case "Report_N30_Opt_2017":
                    EditItem_ReportN31E_8_2017(colItems, objRepConsult, cnForm);
                    break;

                // オプション検査結果表　2011.08.01版
                case "Report_N32_8":
                    EditItem_ReportN32_8(colItems, objRepConsult, cnForm);
                    break;

                // オプション検査結果表　2017.02.22版
                case "Report_N32_8_2017":
                    EditItem_ReportN32_8_2017(colItems, objRepConsult, cnForm);
                    break;

                // オプション検査結果表(英語)　2011.08.01版
                case "Report_N31_Opt":
                    EditItem_ReportN32E_8(colItems, objRepConsult, cnForm);
                    break;

                // オプション検査結果表(英語)　2017.02.23版
                case "Report_N31_Opt_2017":
                    EditItem_ReportN32E_8_2017(colItems, objRepConsult, cnForm);
                    break;

                // オプション検査結果表(英語)　2011.08.01版
                case "Report_Rsl":
                    EditItem_Report_RSL(colItems, objRepConsult, cnForm);
                    break;

                // 問診回答表(2012年10月版)
                case "REPORT6N320_5_2012":
                    // 従来の問診回答表編集処理
                    EditItem_Report6N320_5(colItems, objRepConsult, cnForm);
                    // 2012年版専用処理
                    EditItem_Report6N320_5_2012(colItems, objRepConsult, cnForm);

                    break;

                case "REPORT6E_5_2012":
                    // 従来の問診回答表編集処理
                    EditItem_Report6E_5_2011(colItems, objRepConsult, cnForm);
                    // 2012年版専用処理
                    EditItem_Report6N320_5_2012(colItems, objRepConsult, cnForm);

                    break;
            }

        }

        /// <summary>
        /// 健康簿１枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Kenkoubo1(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 健康簿２枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Kenkoubo2(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 健康診断個人票の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_KojinHyo(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 健康診断報告書の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Kaigai(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// VDT健康診断報告書の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Vdt(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 健康診断報告書の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Teiken(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 前回、前々回の判定編集
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="cnObjects">描画コレクション</param>
        private void EditLastJudge(int lngRsvNo, CnObjects cnObjects)
        {

        }

        /// <summary>
        /// ライフスタイルアドバイスの編集
        /// </summary>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <returns>編集文章</returns>
        private string EditLifeStyleAdvice(RepConsult objRepConsult)
        {
            return "";
        }

        /// <summary>
        /// 特殊健診検査結果の編集
        /// </summary>
        /// <param name="cnObjects">描画コレクション</param>
        /// <param name="strPerId">個人ＩＤ</param>
        private void EditToken(CnObjects cnObjects, string strPerId)
        {

        }

        /// <summary>
        /// 指導記録の編集
        /// </summary>
        /// <param name="cnObjects">描画コレクション</param>
        /// <param name="strPerId">個人ＩＤ</param>
        private void EditAfterCare(CnObjects cnObjects, string strPerId)
        {

        }

        /// <summary>
        /// 入社健診検査結果の編集
        /// </summary>
        /// <param name="cnObjects">描画コレクション</param>
        /// <param name="strPerId">個人ＩＤ</param>
        private void EditNyuken(CnObjects cnObjects, string strPerId)
        {

        }

        /// <summary>
        /// 入社健診受診履歴の編集
        /// </summary>
        /// <param name="cnObjects">描画コレクション</param>
        /// <param name="strPerId">個人ＩＤ</param>
        private void EditNyukenConsultHistory(CnObjects cnObjects, string strPerId)
        {

        }

        /// <summary>
        /// 基準値マークの編集
        /// </summary>
        /// <param name="cnForm">フォームオブジェクト</param>
        private void EditStdValue(CnForm cnForm)
        {

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="strSeq"></param>
        /// <returns></returns>
        private string GetRiskPointNameFromSeq(string strSeq)
        {
            return "";
        }

        /// <summary>
        /// 入社健診検査結果の読み込み
        /// </summary>
        /// <param name="strPerId">個人ＩＤ</param>
        /// <returns></returns>
        private RepResults SelectRsl_Nyuken(string strPerId)
        {
            return new RepResults();
        }

        /// <summary>
        /// 指定予約番号の受診情報を取得する
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="vntCslDate">受診日</param>
        /// <param name="vntCslTime">受付時間(フリー区分)</param>
        /// <returns>
        /// 戻り値　 : True   レコードあり
        /// 　　　　   False  レコードなし、または異常終了
        /// </returns>
        private bool SelectSecondConsult(int lngRsvNo, DateTime vntCslDate, string vntCslTime)
        {
            return true;
        }

        /// <summary>
        /// 入健受診履歴の項目であるかを検索
        /// </summary>
        /// <param name="token">トークン</param>
        /// <returns></returns>
        private bool IsConsultHistoryNyuken(IList<string> token)
        {
            return true;
        }

        /// <summary>
        /// 入社健診検査結果の項目であるかを検索
        /// </summary>
        /// <param name="token">トークン</param>
        /// <returns></returns>
        private bool IsResultNyuken(IList<string> token)
        {
            return true;
        }

        /// <summary>
        /// 指定個人のシステム年における個人就労情報を取得
        /// </summary>
        /// <param name="strPerId">個人ＩＤ</param>
        /// <returns>レコード</returns>
        private IList<dynamic> SelectPerWorkInfo(string strPerId)
        {
            return null;
        }

        /// <summary>
        /// 特殊健診受診情報の読み込み
        /// </summary>
        /// <param name="strPerId">個人ＩＤ</param>
        /// <returns>レコード</returns>
        private IList<dynamic> SelectConsult_Token(string strPerId)
        {
            return null;
        }

        /// <summary>
        /// 指定検査項目における結果を取得
        /// </summary>
        /// <param name="lngRsvNo"></param>
        /// <returns>レコード</returns>
        private dynamic SelectRsl_Token(int lngRsvNo)
        {
            return null;
        }

        /// <summary>
        /// 入社健診受診情報の読み込み
        /// </summary>
        /// <param name="strPerId">個人ＩＤ</param>
        /// <returns></returns>
        private RepHistory SelectConsult_Nyuken(string strPerId)
        {
            return new RepHistory();
        }

        /// <summary>
        /// 指定グループ内検査項目における結果入力項目を取得
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="strGrpCd">グループコード</param>
        /// <returns></returns>
        private IList<dynamic> SelectRsl(int lngRsvNo, string strGrpCd)
        {
            return null;
        }

        /// <summary>
        /// 指定グループ内検査項目の検査結果が存在する最新の受診日とその検査結果を取得
        /// </summary>
        /// <param name="strPerId">予約番号</param>
        /// <param name="strGrpCd">グループコード</param>
        /// <returns></returns>
        private IList<dynamic> SelectRsl_Kansen(string strPerId, string strGrpCd)
        {
            return null;
        }

        /// <summary>
        /// グラフ表示対象となる受診情報とそのグラフ検査項目及び結果を取得する
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="lngRsvNo">予約番号</param>
        /// <returns></returns>
        private IList<dynamic> SelectRslForGraph(RepItems colItems, int lngRsvNo)
        {
            return null;
        }

        /// <summary>
        /// 今回と前回のリスクポイントを読み込む
        /// </summary>
        /// <param name="objRepConsult">予約番号</param>
        /// <returns></returns>
        private IList<dynamic> SelectRslForRiskPoint(RepConsult objRepConsult)
        {
            return null;
        }

        /// <summary>
        /// ６連成績書１枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6_1(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書２枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6_2(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書GetPoint
        /// </summary>
        /// <param name="Index"></param>
        /// <param name="Score"></param>
        /// <param name="x"></param>
        /// <param name="Single"></param>
        /// <param name="y"></param>
        private void Report6_2_GetPoint(int Index, double Score, ref double x, ref double y)
        {
            const double BaseX = 284;
            const double BaseY = 103;
            const double LineSize = 39;


            Double dblRagian;   // ラジアン

            if(Score == 0){
                Report6_2_GetPoint(0, 100, ref x, ref y);
            }
            switch (Index)
            {
                case 0:
                    x = BaseX;
                    y = BaseY;
                    break;
                case 1:
                    x = BaseX;
                    y = BaseY - (LineSize / 100 * Score);
                    break;
                case 2:
                    dblRagian = 60 * (3.141592 / 180);
                    x = BaseX + Math.Cos(dblRagian) * (LineSize / 100 * Score);
                    dblRagian = 30 * (3.141592 / 180);
                    y = BaseY - Math.Cos(dblRagian) * (LineSize / 100 * Score);
                    break;
                case 3:
                    dblRagian = 30 * (3.141592 / 180);
                    x = BaseX + Math.Cos(dblRagian) * (LineSize / 100 * Score);
                    dblRagian = 60 * (3.141592 / 180);
                    y = BaseY - Math.Cos(dblRagian) * (LineSize / 100 * Score);
                    break;
                case 4:
                    x = BaseX + (LineSize / 100 * Score);
                    y = BaseY;
                    break;
                case 5:
                    dblRagian = 30 * (3.141592 / 180);
                    x = BaseX + Math.Cos(dblRagian) * (LineSize / 100 * Score);
                    dblRagian = 60 * (3.141592 / 180);
                    y = BaseY + Math.Cos(dblRagian) * (LineSize / 100 * Score);
                    break;
                case 6:
                    dblRagian = 60 * (3.141592 / 180);
                    x = BaseX + Math.Cos(dblRagian) * (LineSize / 100 * Score);
                    dblRagian = 30 * (3.141592 / 180);
                    y = BaseY + Math.Cos(dblRagian) * (LineSize / 100 * Score);
                    break;
                case 7:
                    x = BaseX;
                    y = BaseY + (LineSize / 100 * Score);
                    break;
                case 8:
                    dblRagian = 60 * (3.141592 / 180);
                    x = BaseX - Math.Cos(dblRagian) * (LineSize / 100 * Score);
                    dblRagian = 30 * (3.141592 / 180);
                    y = BaseY + Math.Cos(dblRagian) * (LineSize / 100 * Score);
                    break;
                case 9:
                    dblRagian = 30 * (3.141592 / 180);
                    x = BaseX - Math.Cos(dblRagian) * (LineSize / 100 * Score);
                    dblRagian = 60 * (3.141592 / 180);
                    y = BaseY + Math.Cos(dblRagian) * (LineSize / 100 * Score);
                    break;
                case 10:
                    x = BaseX - (LineSize / 100 * Score);
                    y = BaseY;
                    break;
                case 11:
                    dblRagian = 30 * (3.141592 / 180);
                    x = BaseX - Math.Cos(dblRagian) * (LineSize / 100 * Score);
                    dblRagian = 60 * (3.141592 / 180);
                    y = BaseY - Math.Cos(dblRagian) * (LineSize / 100 * Score);
                    break;
                case 12:
                    dblRagian = 60 * (3.141592 / 180);
                    x = BaseX - Math.Cos(dblRagian) * (LineSize / 100 * Score);
                    dblRagian = 30 * (3.141592 / 180);
                    y = BaseY - Math.Cos(dblRagian) * (LineSize / 100 * Score);
                    break;
            }
               
        }

        /// <summary>
        /// ６連成績書３枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6_3(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書４枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6_4(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書５枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6_5(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書６枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6_6(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書Graph1
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void DrawReport6_6_Graph1(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書Graph2
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void DrawReport6_6_Graph2(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書GetPoint
        /// </summary>
        /// <param name="Index"></param>
        /// <param name="Score"></param>
        /// <param name="x"></param>
        /// <param name="y"></param>
        private void Report6_6_GetPoint(int Index, double Score, double x, double y)
        {

        }

        /// <summary>
        /// 指定グループ内検査項目における文章を取得
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="strGrpCd">グループコード</param>
        /// <returns>レコード</returns>
        private IList<dynamic> SelectStc(int lngRsvNo, string strGrpCd)
        {
            string sql;             // SQLステートメント
            bool blnFind = false;   // 検索フラグ
            int lngCount = 0;       // レコード数
            IList<dynamic> retData = new List<dynamic>();

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("grpcd", strGrpCd);

            sql = @"
                    select
                        sentence.reptstc shortstc
                        , sentence.reptstc longstc 
                    from
                        rsl
                        , item_c
                        , grp_i
                        , sentence 
                    where
                        rsl.rsvno = :rsvno 
                        and grp_i.grpcd = :grpcd 
                        and rsl.itemcd = grp_i.itemcd 
                        and rsl.suffix = grp_i.suffix 
                        and rsl.itemcd = item_c.itemcd 
                        and rsl.suffix = item_c.suffix 
                        and item_c.itemcd = sentence.itemcd 
                        and item_c.itemtype = sentence.itemtype 
                        and rsl.result = sentence.stccd 
                    order by
                        nvl(sentence.printorder, 99999)
                        , grp_i.seq
                        , rsl.itemcd
                        , rsl.suffix
                ";

            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            // 配列形式で格納する(日本語版)
            foreach (var rec in data)
            {
                string strShortStc = Convert.ToString(rec.SHORTSTC);
                string strLongStc = Convert.ToString(rec.LONGSTC);

                // 重複しない文章のみ抽出する
                blnFind = false;
                int i = 0;
                while (!(i > (lngCount - 1)))
                {
                    if (strShortStc.Equals(Convert.ToString(data[i].SHORTSTC)) && strLongStc.Equals(Convert.ToString(data[i].LONGSTC)))
                    {
                        blnFind = true;
                        break;
                    }
                    i++;
                }
                if (!blnFind)
                {
                    retData.Add(rec);
                    lngCount++;
                }
            }

            return retData;
        }

        /// <summary>
        /// 指定グループ内検査項目における文章を取得
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="strGrpCd">グループコード</param>
        /// <returns>レコード</returns>
        private IList<dynamic> SelectStc_E(int lngRsvNo, string strGrpCd)
        {
            string sql;             // SQLステートメント
            bool blnFind = false;   // 検索フラグ
            int lngCount = 0;       // レコード数
            IList<dynamic> retData = new List<dynamic>();

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("grpcd", strGrpCd);

            sql = @"
                    select
                        sentence.engstc 
                    from
                        rsl
                        , item_c
                        , grp_i
                        , sentence 
                    where
                        rsl.rsvno = :rsvno 
                        and grp_i.grpcd = :grpcd 
                        and rsl.itemcd = grp_i.itemcd 
                        and rsl.suffix = grp_i.suffix 
                        and rsl.itemcd = item_c.itemcd 
                        and rsl.suffix = item_c.suffix 
                        and item_c.itemcd = sentence.itemcd 
                        and item_c.itemtype = sentence.itemtype 
                        and rsl.result = sentence.stccd 
                    order by
                        nvl(sentence.printorder, 99999)
                        , grp_i.seq
                        , rsl.itemcd
                        , rsl.suffix
 
                ";

            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            // 配列形式で格納する(日本語版)
            foreach (var rec in data)
            {
                string strEngStc = Convert.ToString(rec.ENGSTC);

                // 重複しない文章のみ抽出する
                blnFind = false;
                int i = 0;
                while (!(i > (lngCount - 1)))
                {
                    if (strEngStc.Equals(Convert.ToString(data[i].ENGSTC)))
                    {
                        blnFind = true;
                        break;
                    }
                    i++;
                }
                if (!blnFind)
                {
                    retData.Add(rec);
                    lngCount++;
                }
            }

            return retData;
        }

        /// <summary>
        /// 指定グループ内検査項目における文章を取得
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="strGrpCd">グループコード</param>
        /// <returns>レコード</returns>
        private IList<dynamic> SelectStc_2nd(int lngRsvNo, string strGrpCd)
        {
            string sql;             // SQLステートメント
            bool blnFind = false;   // 検索フラグ
            int lngCount = 0;       // レコード数
            IList<dynamic> retData = new List<dynamic>();

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("grpcd", strGrpCd);

            sql = @"
                    select
                        item_c.itemname
                        , sentence.reptstc shortstc
                        , sentence.reptstc longstc 
                    from
                        rsl
                        , item_c
                        , grp_i
                        , sentence 
                    where
                        rsl.rsvno = :rsvno 
                        and grp_i.grpcd = :grpcd 
                        and rsl.itemcd = grp_i.itemcd 
                        and rsl.suffix = grp_i.suffix 
                        and rsl.itemcd = item_c.itemcd 
                        and rsl.suffix = item_c.suffix 
                        and item_c.itemcd = sentence.itemcd 
                        and item_c.itemtype = sentence.itemtype 
                        and rsl.result = sentence.stccd 
                    order by
                        nvl(sentence.printorder, 99999)
                        , grp_i.seq
                        , rsl.itemcd
                        , rsl.suffix
 
                ";

            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            // 配列形式で格納する(日本語版)
            foreach (var rec in data)
            {
                string strShortStc = Convert.ToString(rec.SHORTSTC);
                string strLongStc = Convert.ToString(rec.LONGSTC);

                // 重複しない文章のみ抽出する
                blnFind = false;
                int i = 0;
                while (!(i > (lngCount - 1)))
                {
                    if (strShortStc.Equals(Convert.ToString(data[i].SHORTSTC)) && strLongStc.Equals(Convert.ToString(data[i].LONGSTC)))
                    {
                        blnFind = true;
                        break;
                    }
                    i++;
                }
                // 表示したくないものについて（空白設定されている所見）は無かったものとする
                if ("".Equals(strShortStc.Trim()) && "".Equals(strLongStc.Trim()))
                {
                    blnFind = true;
                }

                if (!blnFind)
                {
                    retData.Add(rec);
                    lngCount++;
                }
            }
            // 空白行削除時、配列にならない可能性のため
            if (lngCount > 1)
            {
                for (int idx = 0; idx < retData.Count; idx++)
                {
                    string strShortStc = Convert.ToString(retData[idx].SHORTSTC);
                    if (strShortStc.IndexOf("著変なし") >= 0)
                    {
                        retData[idx].SHORTSTC = "";
                        retData[idx].LONGSTC = "";
                    }
                }
            }

            return retData;
        }

        /// <summary>
        /// 指定検査項目における文章を取得(FUJIN)
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="strItemCd">検査項目</param>
        /// <param name="strFClass"></param>
        /// <returns>レコード</returns>
        private IList<dynamic> SelectStc_2nd_FUJIN(int lngRsvNo, string strItemCd, string strFClass)
        {
            string sql;             // SQLステートメント
            bool blnFind = false;   // 検索フラグ
            int lngCount = 0;       // レコード数
            IList<dynamic> retData = new List<dynamic>();

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("itemcd", strItemCd);
            sqlParam.Add("fclass", strFClass);

            sql = @"
                    select
                        item_c.itemname
                        , sentence.engstc shortstc
                        , sentence.reptstc longstc 
                    from
                        rsl
                        , item_c
                        , sentence 
                    where
                        rsl.rsvno = :rsvno 
                        and rsl.itemcd = :itemcd 
                        and rsl.itemcd = item_c.itemcd 
                        and rsl.suffix = item_c.suffix 
                        and item_c.itemcd = sentence.itemcd 
                        and item_c.itemtype = sentence.itemtype 
                        and rsl.result = sentence.stccd

                ";

            if ("NAISIN".Equals(strFClass))
            {
                sql += @"
                        and rsl.result not in ( 
                            select
                                freefield1 
                            from
                                free 
                            where
                                freeclasscd in ('FC1', 'FC2', 'FC3')
                        )
                    ";
            }
            else if (FU_FCLASS_KEBU.Equals(strFClass) || FU_FCLASS_CLASS.Equals(strFClass))
            {
                sql += @"
                        and rsl.result in ( 
                            select
                                freefield1 
                            from
                                free 
                            where
                                freeclasscd = :fclass
                        ) 
                    ";
            }
            sql += @"
                        order by
                            nvl(sentence.printorder, 99999)
                            , rsl.itemcd
                            , rsl.suffix
                ";

            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            // 配列形式で格納する(日本語版)
            foreach (var rec in data)
            {
                string strShortStc = Convert.ToString(rec.SHORTSTC);
                string strLongStc = Convert.ToString(rec.LONGSTC);

                // 重複しない文章のみ抽出する
                blnFind = false;
                int i = 0;
                while (!(i > (lngCount - 1)))
                {
                    if (strShortStc.Equals(Convert.ToString(data[i].SHORTSTC)) && strLongStc.Equals(Convert.ToString(data[i].LONGSTC)))
                    {
                        blnFind = true;
                        break;
                    }
                    i++;
                }
                // 表示したくないものについて（空白設定されている所見）は無かったものとする
                if ("".Equals(strShortStc.Trim()) && "".Equals(strLongStc.Trim()))
                {
                    blnFind = true;
                }

                if (!blnFind)
                {
                    retData.Add(rec);
                    lngCount++;
                }
            }
            // 空白行削除時、配列にならない可能性のため
            if (lngCount > 1)
            {
                for (int idx = 0; idx < retData.Count; idx++)
                {
                    string strShortStc = Convert.ToString(retData[idx].SHORTSTC);
                    if (strShortStc.IndexOf("著変なし") >= 0)
                    {
                        retData[idx].SHORTSTC = "";
                        retData[idx].LONGSTC = "";
                    }
                }
            }

            return retData;

        }

        /// <summary>
        /// 指定グループ内検査項目における英語文章を取得
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="strGrpCd">グループコード</param>
        /// <returns>レコード</returns>
        private IList<dynamic> SelectStc_2nd_E(int lngRsvNo, string strGrpCd)
        {
            string sql;             // SQLステートメント
            bool blnFind = false;   // 検索フラグ
            int lngCount = 0;       // レコード数
            IList<dynamic> retData = new List<dynamic>();

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("grpcd", strGrpCd);

            sql = @"
                    select
                        item_c.itemname
                        , sentence.engstc 
                    from
                        rsl
                        , item_c
                        , grp_i
                        , sentence 
                    where
                        rsl.rsvno = :rsvno 
                        and grp_i.grpcd = :grpcd 
                        and rsl.itemcd = grp_i.itemcd 
                        and rsl.suffix = grp_i.suffix 
                        and rsl.itemcd = item_c.itemcd 
                        and rsl.suffix = item_c.suffix 
                        and item_c.itemcd = sentence.itemcd 
                        and item_c.itemtype = sentence.itemtype 
                        and rsl.result = sentence.stccd 
                    order by
                        nvl(sentence.printorder, 99999)
                        , grp_i.seq
                        , rsl.itemcd
                        , rsl.suffix

                ";

            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            // 配列形式で格納する(日本語版)
            foreach (var rec in data)
            {
                string strEngStc = Convert.ToString(rec.ENGSTC);

                // 重複しない文章のみ抽出する
                blnFind = false;
                int i = 0;
                while (!(i > (lngCount - 1)))
                {
                    if (strEngStc.Equals(Convert.ToString(data[i].ENGSTC)))
                    {
                        blnFind = true;
                        break;
                    }
                    i++;
                }
                // 表示したくないものについて（空白設定されている所見）は無かったものとする
                if ("".Equals(strEngStc.Trim()))
                {
                    blnFind = true;
                }

                if (!blnFind)
                {
                    retData.Add(rec);
                    lngCount++;
                }
            }
            // 空白行削除時、配列にならない可能性のため
            if (lngCount > 1)
            {
                for (int idx = 0; idx < retData.Count; idx++)
                {
                    string strEngStc = Convert.ToString(retData[idx].ENGSTC);
                    if (strEngStc.IndexOf("NO SIGNIFICANT ABNORMALITY") >= 0)
                    {
                        retData[idx].ENGSTC = "";
                    }
                }
            }

            return retData;
        }

        /// <summary>
        /// 指定検査項目における文章を取得(FUJIN)
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="strItemCd">検査項目</param>
        /// <param name="strFClass"></param>
        /// <returns></returns>
        private IList<dynamic> SelectStc_2nd_E_FUJIN(int lngRsvNo, string strItemCd, string strFClass)
        {
            string sql;             // SQLステートメント
            bool blnFind = false;   // 検索フラグ
            int lngCount = 0;       // レコード数
            IList<dynamic> retData = new List<dynamic>();

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("itemcd", strItemCd);
            sqlParam.Add("fclass", strFClass);

            sql = @"
                    select
                        item_c.itemname
                        , sentence.engstc 
                    from
                        rsl
                        , item_c
                        , sentence 
                    where
                        rsl.rsvno = :rsvno 
                        and rsl.itemcd = :itemcd 
                        and rsl.itemcd = item_c.itemcd 
                        and rsl.suffix = item_c.suffix 
                        and item_c.itemcd = sentence.itemcd 
                        and item_c.itemtype = sentence.itemtype 
                        and rsl.result = sentence.stccd

                ";

            if ("NAISIN".Equals(strFClass))
            {
                sql += @"
                        and rsl.result not in ( 
                            select
                                freefield1 
                            from
                                free 
                            where
                                freeclasscd in ('FC1', 'FC2')
                        ) 

                    ";
            }
            else if (FU_FCLASS_KEBU.Equals(strFClass) || FU_FCLASS_CLASS.Equals(strFClass))
            {
                sql += @"
                        and rsl.result in ( 
                            select
                                freefield1 
                            from
                                free 
                            where
                                freeclasscd = :fclass
                        ) 
                    ";
            }
            sql += @"
                        order by
                            nvl(sentence.printorder, 99999)
                            , rsl.itemcd
                            , rsl.suffix

                ";

            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            // 配列形式で格納する(日本語版)
            foreach (var rec in data)
            {
                string strEngStc = Convert.ToString(rec.ENGSTC);

                // 重複しない文章のみ抽出する
                blnFind = false;
                int i = 0;
                while (!(i > (lngCount - 1)))
                {
                    if (strEngStc.Equals(Convert.ToString(data[i].ENGSTC)))
                    {
                        blnFind = true;
                        break;
                    }
                    i++;
                }
                // 表示したくないものについて（空白設定されている所見）は無かったものとする
                if ("".Equals(strEngStc.Trim()))
                {
                    blnFind = true;
                }

                if (!blnFind)
                {
                    retData.Add(rec);
                    lngCount++;
                }
            }
            // 空白行削除時、配列にならない可能性のため
            if (lngCount > 1)
            {
                for (int idx = 0; idx < retData.Count; idx++)
                {
                    string strEngStc = Convert.ToString(retData[idx].ENGSTC);
                    if (strEngStc.IndexOf("NO SIGNIFICANT ABNORMALITY") >= 0)
                    {
                        retData[idx].ENGSTC = "";
                    }
                }
            }

            return retData;
        }

        /// <summary>
        /// 指定グループ内検査項目における文章を取得
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="strGrpCd">グループコード</param>
        /// <returns>レコード</returns>
        private IList<dynamic> SelectStc_3rd(int lngRsvNo, string strGrpCd)
        {
            string sql;             // SQLステートメント
            IList<dynamic> retData = new List<dynamic>();

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("grpcd", strGrpCd);

            sql = @"
                    select
                        rsl.suffix
                        , sentence.reptstc shortstc
                        , sentence.reptstc longstc
                        , sentence.engstc 
                    from
                        rsl
                        , item_c
                        , grp_i
                        , sentence 
                    where
                        rsl.rsvno = :rsvno 
                        and grp_i.grpcd = :grpcd 
                        and rsl.itemcd = grp_i.itemcd 
                        and rsl.suffix = grp_i.suffix 
                        and rsl.itemcd = item_c.itemcd 
                        and rsl.suffix = item_c.suffix 
                        and item_c.itemcd = sentence.itemcd 
                        and item_c.itemtype = sentence.itemtype 
                        and rsl.result = sentence.stccd 
                    order by
                        nvl(sentence.printorder, 999)
                        , grp_i.seq
                        , rsl.itemcd
                        , rsl.suffix

                ";

            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            // 配列形式で格納する(日本語版)
            foreach (var rec in data)
            {
                string strSuffix = Convert.ToString(rec.SUFFIX);

                if (int.TryParse(strSuffix, out int wkSuffix))
                {
                    if ((wkSuffix % 2) == 0)
                    {
                        retData.Add(rec);
                    }
                }
            }

            return retData;
        }

        /// <summary>
        /// 指定グループ内検査項目における文章を取得
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="strItemCd">アイテムＮｏ.</param>
        /// <param name="strSuffix">サフィックス</param>
        /// <param name="lngHistory">定値（0:今回・1:前回・2:前々回）</param>
        /// <param name="LRFlg"></param>
        /// <returns></returns>
        private string SelectStc_RF(int lngRsvNo, string strItemCd, string strSuffix, int lngHistory, int LRFlg)
        {
            string sql;                 // SQLステートメント
            string result = "";         // 判定地
            string comment = "";        // コメント１
            string stopFlg = "";        // ストップフラグ
            string ret = "";

            if (lngHistory == 0)
            {
                result = "********";
            }

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("itemcd", strItemCd);
            sqlParam.Add("suffix", strSuffix);

            sql = @"
                    select
                        rsl.result
                        , rsl.rslcmtcd1
                        , rsl.stopflg 
                    from
                        rsl 
                    where
                        rsl.rsvno = :rsvno 
                        and rsl.itemcd = :itemcd 
                        and rsl.suffix = :suffix 

                ";

            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            // 配列形式で格納する(日本語版)
            foreach (var rec in data)
            {
                result = Convert.ToString(rec.RESULT);
                comment = Convert.ToString(rec.COMMENT);
                stopFlg = Convert.ToString(rec.STOPFLG);
            }
            // 視力検査中止の場合の処理
            if ("11020".Equals(strItemCd) || "11022".Equals(strItemCd))
            {
                if ("S".Equals(stopFlg))
                {
                    result = "--------";
                }
            }

            // 戻り値の設定
            if (LRFlg == 0)
            {
                ret = comment + result;
            } else
            {
                ret = result + comment;
            }

            return ret;
        }

        /// <summary>
        /// 判定コメントを取得
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="lngDispMode">グループコード</param>
        /// <returns>レコード</returns>
        private IList<dynamic> SelectJudCmt(int lngRsvNo, int lngDispMode)
        {
            string sql;         // SQLステートメント

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("dispmode", lngDispMode);

            // 指定グループ内検査項目における結果入力項目を取得
            sql = @"
                    select
                        judcmtstc.judcmtstc
                        , judcmtstc.judcmtstc_e
                        , judcmtstc.judclasscd
                        , judcmtstc.judcmtcd 
                    from
                        judcmtstc
                        , totaljudcmt 
                    where
                        totaljudcmt.rsvno = :rsvno 
                        and totaljudcmt.dispmode = :dispmode 
                        and totaljudcmt.judcmtcd is not null 
                        and totaljudcmt.judcmtcd = judcmtstc.judcmtcd 
                        and totaljudcmt.judcmtcd not in ('800100', '800110') 
                    order by
                        totaljudcmt.seq

                ";

            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            return data;
        }

        /// <summary>
        /// ROMENAMを取得
        /// </summary>
        /// <param name="strPerId">個人ＩＤ</param>
        /// <returns></returns>
        private string SelectConsult_ROMENAME(string strPerId)
        {
            string sql;             // SQLステートメント
            // 戻り値の初期化
            String SelectConsult_ROMENAME = "";
            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("perid", strPerId);
            sql = @"
                    select
                      person.romename 
                    from
                      person 
                    where
                      person.perid = :perid
                ";
            dynamic data = connection.Query(sql, sqlParam).FirstOrDefault();
            if (null!=data)
            {
                SelectConsult_ROMENAME = data.ROMENAME;
            }
            return SelectConsult_ROMENAME;
        }

        /// <summary>
        /// 団体グループを取得
        /// </summary>
        /// <param name="strOrgCd1">団体コード1</param>
        /// <param name="strOrgCd2">団体コード2</param>
        /// <param name="strOrgGrp">グループコード</param>
        /// <returns>レコード</returns>
        private Boolean SelectOrgGrp(string strOrgCd1, string strOrgCd2, string strOrgGrp)
        {
            string sql;             // SQLステートメン
            //    '初期処理
            bool blnOrgGrp=false;

            //    'キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("orgcd1", strOrgCd1);
            sqlParam.Add("orgcd2", strOrgCd2);
            sqlParam.Add("freecd", strOrgGrp);
            sql = @"
                select
                  orggrp_i.orgcd1
                  , orggrp_i.orgcd2 
                from
                  free
                  , orggrp_i 
                where
                  free.freecd like :freecd 
                  and orggrp_i.orgcd1 = :orgcd1 
                  and orggrp_i.orgcd2 = :orgcd2 
                  and orggrp_i.orggrpcd = free.freefield1
                ";
            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            //    '検索レコードが存在する場合
            if (data.Count > 0)
            {
                blnOrgGrp = true;
            }
            return blnOrgGrp;
        }

        /// <summary>
        /// 団体情報の成績表に保険証記号、番号を出力有無チェック
        /// </summary>
        /// <param name="strOrgCd1">団体コード1</param>
        /// <param name="strOrgCd2">団体コード2</param>
        /// <returns>レコード</returns>
        private bool SelectOrgIns(string strOrgCd1, string strOrgCd2)
        {
            string sql;             // SQLステートメント

            //'エラーハンドラの設定
            //On Error GoTo ErrorHandle

            //'初期処理
            bool blnOrgIns=false;
            //'キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("orgcd1", strOrgCd1);
            sqlParam.Add("orgcd2", strOrgCd2);

            // 団体グループに属するかチェックする
            sql = @"
                    select
                      org.orgcd1
                      , org.orgcd2 
                    from
                      org 
                    where
                      org.orgcd1 = :orgcd1 
                      and org.orgcd2 = :orgcd2 
                      and org.insreport = 1
                ";
            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();
            // 検索レコードが存在する場合
            if (data.Count > 0)
            {
                blnOrgIns = true;
            }
            return blnOrgIns;
        }

        /// <summary>
        /// 該当受診者の特定健診契約情報チェック（契約あり：TRUE、契約なし：FALSE）
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <returns>契約あり：TRUE、契約なし：FALSE</returns>
        private bool SelectSpecialChk(int lngRsvNo)
        {
            string sql;         // SQLステートメント
            
            // 初期処理
            bool blnSpecial = false;

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("setclasscd", SPECIAL_SETCLASSCD);

            // 指定予約番号の契約情報の中の特定健診セット情報を取得する
            sql = @"
                    select
                        ctrpt_opt.setclasscd 
                    from
                        consult
                        , receipt
                        , consult_o
                        , ctrpt_opt 
                    where
                        consult.rsvno = :rsvno 
                        and consult.rsvno = receipt.rsvno 
                        and consult.cancelflg = 0 
                        and consult.rsvno = consult_o.rsvno 
                        and consult_o.ctrptcd = ctrpt_opt.ctrptcd 
                        and consult_o.optcd = ctrpt_opt.optcd 
                        and consult_o.optbranchno = ctrpt_opt.optbranchno 
                        and ctrpt_opt.setclasscd = :setclasscd
                ";

            dynamic data = connection.Query(sql, sqlParam).FirstOrDefault();

            //  検索レコードが存在する場合
            if (null != data)
            {
                blnSpecial = true;
            }
            return blnSpecial;
        }


        /// <summary>
        /// 現病歴の薬剤治療中情報収集（高血圧、糖尿病、高脂血症）
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <returns></returns>
        private dynamic SelectMetaDisease(int lngRsvNo)
        {
            string sql;         // SQLステートメント

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("disease_grpcd", DISEASE_GRPCD);

            // 胃区分の名称を取得（RSLテーブル）
            sql = @"
                    select
                        sum(final.ketsuatsu) as ketsuatsu
                        , sum(final.tounyou) as tounyou
                        , sum(final.shisitsu) as shisitsu
                    from
                        (
                        select
                            rslview.rsvno as rsvno
                            , decode(rslview.result, '19', count(rslview.rsvno), 0) as ketsuatsu
                            , decode(rslview.result, '48', count(rslview.rsvno), 0) as tounyou
                            , decode(rslview.result, '47', count(rslview.rsvno), 0) as shisitsu
                        from
                            (
                              select
                                  rsl.rsvno
                                  , free.freefield3 result
                                  , rsl.itemcd
                                  , rsl.suffix
                              from
                                  rsl
                                  , consult
                                  , grp_i
                                  , free
                              where
                                  consult.rsvno = :rsvno
                                  and grp_i.grpcd = :disease_grpcd
                                  and rsl.rsvno = consult.rsvno
                                  and rsl.itemcd = grp_i.itemcd
                                  and rsl.suffix = grp_i.suffix
                                  and rsl.suffix = '01'
                                  and free.freecd = 'metadis' || rsl.result
                            ) rslview
                            , (
                                select
                                    rsl.rsvno
                                    , rsl.result
                                    , rsl.itemcd
                                    , rsl.suffix
                                from
                                    rsl
                                    , consult
                                    , grp_i
                                    , free
                                where
                                    consult.rsvno = :rsvno
                                    and grp_i.grpcd = :disease_grpcd
                                    and rsl.rsvno = consult.rsvno
                                    and rsl.itemcd = grp_i.itemcd
                                    and rsl.suffix = grp_i.suffix
                                    and rsl.suffix = '03'
                                    and free.freecd = 'metasts' || rsl.result
                            ) statview
                        where
                            rslview.rsvno = statview.rsvno
                            and rslview.itemcd = statview.itemcd
                        group by
                            rslview.rsvno
                            , rslview.result
                        ) final
                    group by
                        final.rsvno
                ";

            dynamic data = connection.Query(sql, sqlParam).ToList();

            return data;
        }

        /// <summary>
        /// 現病歴・既往歴チェック
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <returns></returns>
        private IList<dynamic> SelectDisease(int lngRsvNo)
        {
            string sql;         // SQLステートメント

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("disease_grpcd", DISEASE_GRPCD);

            // 胃区分の名称を取得（RSLテーブル）
            sql = @"
                    select
                        rslview.result as rsldisease
                        , statview.result as rslstatus 
                    from
                        ( 
                          select
                              rsl.rsvno
                              , rsl.result
                              , rsl.itemcd
                              , rsl.suffix 
                          from
                              rsl
                              , grp_i 
                          where
                              rsl.rsvno = :rsvno 
                              and grp_i.grpcd = :disease_grpcd 
                              and rsl.itemcd = grp_i.itemcd 
                              and rsl.suffix = grp_i.suffix 
                              and rsl.suffix = '01'
                        ) rslview
                        , (
                            select
                                rsl.rsvno
                                , rsl.result
                                , rsl.itemcd
                                , rsl.suffix 
                            from
                                rsl
                                , grp_i 
                            where
                                rsl.rsvno = :rsvno 
                                and grp_i.grpcd = :disease_grpcd 
                                and rsl.itemcd = grp_i.itemcd 
                                and rsl.suffix = grp_i.suffix 
                                and rsl.suffix = '03'
                        ) statview
                    where
                        rslview.rsvno = statview.rsvno(+) 
                        and rslview.itemcd = statview.itemcd(+)
                ";

            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            return data;
        }

        /// <summary>
        /// アルコール換算を取得
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <returns>アルコール</returns>
        private dynamic SelectRsl_ALCOHOL(int lngRsvNo)
        {
            string sql;         // SQLステートメント
            dynamic retData = new System.Dynamic.ExpandoObject();    // 戻り値
            
            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("alcohol_grpcd", GRPCD_IKBN);

            // 指定グループ内検査項目における結果入力項目を取得（1日アルコール合計）
            sql = @"
                    select
                        nvl(sum(lastview.alcohol), 0) as sumalcohol 
                    from
                        ( 
                        select
                            decode( 
                            rsl.itemcd
                            , '60180'
                            , to_number(rsl.result) * 1.26
                            , '60181'
                            , to_number(rsl.result) * 0.7
                            , '60182'
                            , to_number(rsl.result)
                            , '60183'
                            , to_number(rsl.result)
                            , '60184'
                            , to_number(rsl.result) * 0.5
                            , '60185'
                            , to_number(rsl.result) * 0.5
                            , '60186'
                            , to_number(rsl.result) * 0.5
                            , '60187'
                            , to_number(rsl.result) * 0.5
                            ) as alcohol 
                        from
                            rsl
                            , grp_i 
                        where
                            rsl.rsvno = :rsvno 
                            and grp_i.grpcd = :alcohol_grpcd 
                            and rsl.itemcd = grp_i.itemcd 
                            and rsl.suffix = grp_i.suffix 
                            and rsl.result is not null
                        ) lastview
                ";

            dynamic data = connection.Query(sql, sqlParam).ToList();

            return data;
        }

        /// <summary>
        /// 胃区分の名称を取得
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <returns></returns>
        private dynamic SelectIKbnName(int lngRsvNo)
        {
            string sql;         // SQLステートメント
            dynamic retData = new System.Dynamic.ExpandoObject();    // 戻り値

            // 初期処理
            retData.NAME = "";
            retData.ENGNAME = "";
            retData.SEQ = "";

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("grpcd", GRPCD_IKBN);
            sqlParam.Add("freecd", FREECD_IKBN);
            sqlParam.Add("cancelflg", "0");

            // 胃区分の名称を取得（RSLテーブル）
            sql = @"
                    select
                        free.freefield3
                        , free.freefield4
                        , ikbn.seq 
                    from
                        free
                        , ( 
                            select
                                grp_i.seq 
                            from
                                rsl
                                , grp_i 
                            where
                                rsl.rsvno = :rsvno 
                                and rsl.stopflg is null 
                                and grp_i.grpcd = :grpcd 
                                and grp_i.itemcd = rsl.itemcd
                        ) ikbn 
                    where
                        free.freecd like :freecd 
                        and free.freefield2 = ikbn.seq 
                        and free.freefield1 = :grpcd
                ";

            dynamic data = connection.Query(sql, sqlParam).FirstOrDefault();
            // 検索レコードが存在しない場合
            if (data == null)
            {
                // 胃区分の名称を取得（CONSULTITEMLISTテーブル）
                sql = @"
                        select
                            free.freefield3
                            , free.freefield4
                            , ikbn.seq 
                        from
                            free
                            , ( 
                                select
                                    grp_i.seq 
                                from
                                    consultitemlist
                                    , grp_i 
                                where
                                    consultitemlist.rsvno = :rsvno 
                                    and consultitemlist.cancelflg = :cancelflg 
                                    and grp_i.grpcd = :grpcd 
                                    and grp_i.itemcd = consultitemlist.itemcd
                            ) ikbn 
                        where
                            free.freecd like :freecd 
                            and free.freefield2 = ikbn.seq 
                            and free.freefield1 = :grpcd
                    ";
                data = connection.Query(sql, sqlParam).FirstOrDefault();
            }

            // 検索レコードが存在する場合
            if (data != null)
            {
                // 戻り値の設定
                retData.NAME = Convert.ToString(data.FREEFIELD3);
                retData.ENGNAME = Convert.ToString(data.FREEFIELD4);
                retData.SEQ = Convert.ToString(data.SEQ);
            }
            else
            {
                // コースコード検索
                sql = @"
                        select
                            cscd 
                        from
                            consult 
                        where
                            consult.rsvno = :rsvno
                    ";
                data = connection.Query(sql, sqlParam).FirstOrDefault();
                if ("100".Equals(Convert.ToString(data.CSCD))
                    || "800".Equals(Convert.ToString(data.CSCD))
                    || "810".Equals(Convert.ToString(data.CSCD))
                    || "820".Equals(Convert.ToString(data.CSCD))
                    || "850".Equals(Convert.ToString(data.CSCD)))
                {
                    // 戻り値の設定
                    retData.NAME = "(胃Ｘ線なし)";
                    retData.ENGNAME = "";
                    retData.SEQ = "";
                }
            }

            return retData;
        }

        /// <summary>
        /// 指定グループ内検査項目における結果入力項目を取得
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="strGrpCd">グループコード</param>
        /// <returns></returns>
        private IList<dynamic> SelectRsl2(int lngRsvNo, string strGrpCd)
        {
            string sql;         // SQLステートメント

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("grpcd", strGrpCd);

            // 指定グループ内検査項目における結果入力項目を取得
            sql = @"
                    select
                        item_c.itemcd
                        , item_c.suffix
                        , item_c.itemrname
                        , item_c.itemsname
                        , item_c.itemename
                        , rsl.result 
                    from
                        item_c
                        , grp_i
                        , rsl 
                    where
                        rsl.rsvno = :rsvno 
                        and grp_i.grpcd = :grpcd 
                        and rsl.itemcd = grp_i.itemcd 
                        and rsl.suffix = grp_i.suffix 
                        and rsl.itemcd = item_c.itemcd 
                        and rsl.suffix = item_c.suffix 
                        and rsl.result is not null 
                    order by
                        grp_i.seq
                ";

            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();


            return data;
        }

        /// <summary>
        /// 指定グループ内検査項目における結果入力項目を取得
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="strGrpCd">グループコード</param>
        /// <returns></returns>
        private IList<dynamic> SelectRsl2_2(int lngRsvNo, string strGrpCd)
        {
            string sql;         // SQLステートメント

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("grpcd", strGrpCd);

            // 指定グループ内検査項目における結果入力項目を取得
            sql = @"
                    select
                        item_c.itemcd
                        , item_c.suffix
                        , item_c.itemrname
                        , item_c.itemsname
                        , item_c.itemename
                        , rsl.result 
                    from
                        item_c
                        , grp_i
                        , rsl 
                    where
                        rsl.rsvno = :rsvno 
                        and grp_i.grpcd = :grpcd 
                        and rsl.itemcd = grp_i.itemcd 
                        and rsl.suffix = grp_i.suffix 
                        and rsl.itemcd = item_c.itemcd 
                        and rsl.suffix = item_c.suffix 
                        and rsl.result is not null 
                    union 
                    select
                        item_c.itemcd
                        , item_c.suffix
                        , item_c.itemrname
                        , item_c.itemsname
                        , item_c.itemename
                        , rsl.result 
                    from
                        item_c
                        , rsl 
                    where
                        rsl.rsvno = :rsvno 
                        and rsl.itemcd in ('18425', '18426') 
                        and rsl.itemcd = item_c.itemcd 
                        and rsl.suffix = item_c.suffix 
                        and rsl.result is not null
                ";

            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();


            return data;
        }

        /// <summary>
        /// 指定グループ内検査項目における結果入力項目を取得
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="strGrpCd">グループコード</param>
        /// <param name="strGrpCd2">グループコード2</param>
        /// <returns></returns>
        private IList<dynamic> SelectRsl2_3(int lngRsvNo, string strGrpCd, string strGrpCd2)
        {
            string sql;         // SQLステートメント

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("grpcd", strGrpCd);
            sqlParam.Add("grpcd2", strGrpCd2);

            // 指定グループ内検査項目における結果入力項目を取得
            sql = @"
                    select
                        item_c.itemcd
                        , item_c.suffix
                        , item_c.itemrname
                        , item_c.itemsname
                        , item_c.itemename
                        , rsl.result 
                    from
                        item_c
                        , grp_i
                        , rsl 
                    where
                        rsl.rsvno = :rsvno 
                        and grp_i.grpcd = :grpcd 
                        and rsl.itemcd = grp_i.itemcd 
                        and rsl.suffix = grp_i.suffix 
                        and rsl.itemcd = item_c.itemcd 
                        and rsl.suffix = item_c.suffix 
                        and rsl.result is not null 
                        and item_c.itemcd not in ( 
                            select
                                grp_r.itemcd 
                            from
                                consult_o a
                                , ctrpt_opt b
                                , ctrpt_price c
                                , ctrpt_org d
                                , ctrpt_grp e
                                , grp_r 
                            where
                                a.rsvno = :rsvno 
                                and a.ctrptcd = b.ctrptcd 
                                and a.optcd = b.optcd 
                                and a.optbranchno = b.optbranchno 
                                and a.ctrptcd = c.ctrptcd 
                                and a.optcd = c.optcd 
                                and a.optbranchno = c.optbranchno 
                                and c.ctrptcd = d.ctrptcd 
                                and c.seq = d.seq 
                                and e.grpcd = :grpcd2 
                                and b.ctrptcd = e.ctrptcd(+) 
                                and b.optcd = e.optcd(+) 
                                and b.optbranchno = e.optbranchno(+) 
                                and d.apdiv = 0 
                                and c.price > 0 
                                and e.grpcd = grp_r.grpcd
                        ) 
                    order by
                        grp_i.seq

                ";

            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            return data;
        }

        /// <summary>
        /// 指定グループ内検査項目における結果入力項目を取得
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="strGrpCd">グループコード</param>
        /// <returns></returns>
        private IList<dynamic> SelectRsl3(int lngRsvNo, string strGrpCd)
        {
            string sql;         // SQLステートメント

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("grpcd", strGrpCd);

            // 指定グループ内検査項目における結果入力項目を取得
            sql = @"
                    select
                        item_c.itemcd
                        , item_c.suffix
                        , item_c.itemrname
                        , item_c.itemsname
                        , item_c.itemename
                        , rsl.result
                        , item_h.unit
                        , item_h.eunit 
                    from
                        item_c
                        , grp_i
                        , rsl
                        , item_h 
                    where
                        rsl.rsvno = :rsvno 
                        and grp_i.grpcd = :grpcd 
                        and rsl.itemcd = grp_i.itemcd 
                        and rsl.suffix = grp_i.suffix 
                        and rsl.itemcd = item_c.itemcd 
                        and rsl.suffix = item_c.suffix 
                        and item_c.itemcd = item_h.itemcd 
                        and item_c.suffix = item_h.suffix 
                        and rsl.result is not null 
                    order by
                        grp_i.seq

                ";

            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            return data;
        }

        /// <summary>
        /// ６連成績書英語版１枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6E_1(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書英語版２枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6E_2(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書英語版３枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6E_3(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書英語版４枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6E_4(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書英語版５枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6E_5(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書英語版５枚目の編集  2011.01.01板
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6E_5_2011(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書英語版６枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6E_6(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// CsENameの編集
        /// </summary>
        /// <param name="strCsCd"></param>
        /// <returns></returns>
        private string SelectCsEName(string strCsCd)
        {
            String SelectCsEName = "";
            switch (strCsCd)
            {
                case "100": // １日ドック
                    SelectCsEName = "Oneday medical checkup ";
                    break;
                case "110": // 企業健診
                    SelectCsEName = "Medical checkup course ";
                    break;
            }
            return SelectCsEName;
        }

        /// <summary>
        /// ３連成績書１枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3_1(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ３連成績書２枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3_2(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ３連成績書３枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3_3(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 総合判定表１枚ものの編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report1(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 肺ドック成績書２枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_ReportHAI_2(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 法定項目成績書日本語版の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_ReportLAW(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {
            CnObjects colCnObjects;                        // 描画オブジェクトのコレクション
            CnObject objCnObject;                          // 描画オブジェクト
            RepHistory objHistory;                         // 受診履歴クラス
            IList<string> vntLongStc;                      // 文章
            IList<string> vntToken;                        // トークン
            int lngTokenCount;                             // トークン数
            int lngRslCount;                               // 結果件数
            String strIKbn;                                // 胃区分12
            String strSeq;                                 // SEQ
            String strJudCd;
            String strJudRName;
            int i;
            short j;
            short k;

            string[] judPriCode = new string[2];           // 固定ロジック用

            string[] judShortCode = new string[5];

            string[] abnormalMarkShortCode = new string[5];

            // 描画オブジェクトコレクションの参照設定
            colCnObjects = cnForm.CnObjects;

            //judPriCode(1) = "PRISHORTSTC_22160-01_22160-02_22160-03_22160-04_22160-05_22160-06"
            judPriCode[1] = "PRISHORTSTC_22160-01_22160-03_22160-05_22160-07_22160-09_22160-11";

            judShortCode[1] = "SHORTSTC_12050-00";
            judShortCode[2] = "SHORTSTC_12060-00";
            judShortCode[3] = "SHORTSTC_12070-00";
            judShortCode[4] = "SHORTSTC_12080-00";


            abnormalMarkShortCode[1] = "ABNORMALMARK_12050-00";
            abnormalMarkShortCode[2] = "ABNORMALMARK_12060-00";
            abnormalMarkShortCode[3] = "ABNORMALMARK_12070-00";
            abnormalMarkShortCode[4] = "ABNORMALMARK_12080-00";

            // 胸部Ｘ線
            // 今回のみ
            IList<dynamic> retData = SelectStc_2nd(objRepConsult.RsvNo, GRPCD_KYOUBU_X);
            lngRslCount = retData.Count;
            if (lngRslCount > 0)
            {
                objCnObject = colCnObjects["KYOUBUX"];
                j = 0;
                i = 0;
                k = 0;
                while (!(i > (lngRslCount - 1)) && !(k > (((CnListField)objCnObject).ListColumns.Count() - 1)))
                {
                    if (Strings.RTrim(retData[i].LONGSTC) == "")
                    {
                        ((CnListField)objCnObject).ListText(k, j, Strings.Trim(retData[i].LONGSTC));
                        j++;
                        if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                        {
                            j = 0;
                            k++;
                        }
                    }
                    i = i + 1;
                }
            }

            foreach (CnObject cnObject in colCnObjects)
            {
                switch (cnObject.Name.ToUpper())
                {
                    case "CSLDATE":
                        ((CnDataField)colCnObjects["CSLDATE"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);
                        break;
                    case "CSLDATEM":
                        ((CnDataField)colCnObjects["CSLDATEM"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);
                        break;
                    case "BIRTH":
                        ((CnDataField)colCnObjects["BIRTH"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.Birth);
                        break;
                    case "EDITCSLDATE":
                        ((CnDataField)colCnObjects["EDITCSLDATE"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);
                        break;
                    case "EDITCSLDATEM":
                        ((CnDataField)colCnObjects["EDITCSLDATEM"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);
                        break;
                    case "EDITBIRTH":
                        ((CnDataField)colCnObjects["EDITBIRTH"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.Birth);
                        break;
                    default:
                        // アンダースコアでカラム名を分割
                        vntToken = cnObject.Name.Split('_');
                        lngTokenCount = vntToken.Count;
                        if (lngTokenCount >= 1)
                        {
                            switch (PrintCommon.ExceptReplicationSign(vntToken[0]).ToUpper())
                            {
                                case "JUDRNAME":
                                    if (Convert.ToInt32(vntToken[1]) >= 1 && Convert.ToInt32(vntToken[1]) <= 28)
                                    {
                                        if ((lngTokenCount - 1) <= 1)
                                        {
                                            dynamic rslData = SelectJudHistoryRsl(objRepConsult.RsvNo, Convert.ToInt32(vntToken[1]), true);
                                            ((CnDataField)cnObject).Text = rslData.JUDRNAME;
                                            if (rslData.JUDRNAME.ToUpper() == "＊＊")
                                            {
                                                switch (Convert.ToInt32(vntToken[1]))
                                                {
                                                    case 4:
                                                        ((CnListField)colCnObjects[judPriCode[1]]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 6:
                                                        ((CnListField)colCnObjects["KYOUBUX"]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 22:
                                                        ((CnDataField)colCnObjects[judShortCode[1]]).Text = "＊＊＊＊＊";
                                                        ((CnDataField)colCnObjects[judShortCode[2]]).Text = "＊＊＊＊＊";
                                                        ((CnDataField)colCnObjects[judShortCode[3]]).Text = "＊＊＊＊＊";
                                                        ((CnDataField)colCnObjects[judShortCode[4]]).Text = "＊＊＊＊＊";
                                                        ((CnDataField)colCnObjects[abnormalMarkShortCode[1]]).Text = "";
                                                        ((CnDataField)colCnObjects[abnormalMarkShortCode[2]]).Text = "";
                                                        ((CnDataField)colCnObjects[abnormalMarkShortCode[3]]).Text = "";
                                                        ((CnDataField)colCnObjects[abnormalMarkShortCode[4]]).Text = "";
                                                        break;
                                                }
                                            }
                                            if (rslData.JUDRNAME.ToUpper() == "－－")
                                            {
                                                switch (Convert.ToInt32(vntToken[1]))
                                                {
                                                    case 4:
                                                        ((CnListField)colCnObjects[judPriCode[1]]).ListText(0, 0, "検査せず");
                                                        break;
                                                    case 6:
                                                        ((CnListField)colCnObjects["KYOUBUX"]).ListText(0, 0, "検査せず");
                                                        break;
                                                    case 22:
                                                        ((CnDataField)colCnObjects[judShortCode[1]]).Text = "検査せず";
                                                        ((CnDataField)colCnObjects[judShortCode[2]]).Text = "検査せず";
                                                        ((CnDataField)colCnObjects[judShortCode[3]]).Text = "検査せず";
                                                        ((CnDataField)colCnObjects[judShortCode[4]]).Text = "検査せず";
                                                        ((CnDataField)colCnObjects[abnormalMarkShortCode[1]]).Text = "";
                                                        ((CnDataField)colCnObjects[abnormalMarkShortCode[2]]).Text = "";
                                                        ((CnDataField)colCnObjects[abnormalMarkShortCode[3]]).Text = "";
                                                        ((CnDataField)colCnObjects[abnormalMarkShortCode[4]]).Text = "";
                                                        break;
                                                }
                                            }
                                        }
                                    }
                                    break;
                            }
                        }
                        break;
                }
            }

            colCnObjects["JUDRNAME_2"].Visible = false;
            colCnObjects["JUDRNAME_3"].Visible = false;
            colCnObjects["JUDRNAME_4"].Visible = false;
            colCnObjects["JUDRNAME_6"].Visible = false;
            colCnObjects["JUDRNAME_10"].Visible = false;
            colCnObjects["JUDRNAME_11"].Visible = false;
            colCnObjects["JUDRNAME_12"].Visible = false;
            colCnObjects["JUDRNAME_14"].Visible = false;
            colCnObjects["JUDRNAME_19"].Visible = false;
            colCnObjects["JUDRNAME_20"].Visible = false;
            colCnObjects["JUDRNAME_22"].Visible = false;

            Boolean blnOrgGrp = SelectOrgGrp(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_ORGGRP);
            if (blnOrgGrp)
            {
                colCnObjects["LBLEMPNO"].Visible = true;
                colCnObjects["LBLORGNAME"].Visible = true;
                colCnObjects["EMPNO"].Visible = true;
                colCnObjects["ORGNAME"].Visible = true;
            }
            else
            {
                colCnObjects["LBLEMPNO"].Visible = false;
                colCnObjects["LBLORGNAME"].Visible = false;
                colCnObjects["EMPNO"].Visible = false;
                colCnObjects["ORGNAME"].Visible = false;
            }

            Boolean blnOrgIns = SelectOrgIns(objRepConsult.OrgCd1, objRepConsult.OrgCd2);
            if (blnOrgIns)
            {
                colCnObjects["LBLISRSIGN"].Visible = true;
                colCnObjects["ISRSIGN"].Visible = true;
                colCnObjects["LBLISRNO"].Visible = true;
                colCnObjects["ISRNO"].Visible = true;
            }
            else
            {
                colCnObjects["LBLISRSIGN"].Visible = false;
                colCnObjects["ISRSIGN"].Visible = false;
                colCnObjects["LBLISRNO"].Visible = false;
                colCnObjects["ISRNO"].Visible = false;
            }
        }

        /// <summary>
        /// 健診基礎結果表（特定値のみ）
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report_RSL(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {
            CnObjects colCnObjects;                        // 描画オブジェクトのコレクション
            CnObject objCnObject;                          // 描画オブジェクト
            RepHistory objHistory;                         // 受診履歴クラス
            IList<string> vntLongStc;                      // 文章
            IList<string> vntToken;                        // トークン
            int lngTokenCount;                             // トークン数
            int lngRslCount;                               // 結果件数
            String strIKbn;                                // 胃区分12
            String strSeq;                                 // SEQ
            String strJudCd;
            String strJudRName;

            int[,] JudSenketu = new int[4,3];              // 便潜血判定用

            string[,] judLongStcCode = new string[4,3];    // 便潜血判定用

            string[] judShortCode = new string[5];

            string[] judResultCode = new string[3];

            string[,] judAbnormalMark = new string[4,3];    // 便潜血異常値マーク用

            string[] abnormalMarkShortCode = new string[5];

            string[] abnormalMarkResultCode = new string[3];

            // 描画オブジェクトコレクションの参照設定
            colCnObjects = cnForm.CnObjects;

            judLongStcCode[1,1] = "LONGSTC_14322-00";       // 便潜血１回目定性（今回）
            judLongStcCode[2,1] = "LONGSTC_14322-00_1";     // 便潜血１回目定性（前回）
            judLongStcCode[3,1] = "LONGSTC_14322-00_2";     // 便潜血１回目定性（前々回）
            judLongStcCode[1,2] = "LONGSTC_14325-00";       // 便潜血２回目定性（今回）
            judLongStcCode[2,2] = "LONGSTC_14325-00_1";     // 便潜血２回目定性（前回）
            judLongStcCode[3,2] = "LONGSTC_14325-00_2";     // 便潜血２回目定性（前々回）

            judAbnormalMark[1,1] = "ABNORMALMARK_14322-00";
            judAbnormalMark[2,1] = "ABNORMALMARK_14322-00_1";
            judAbnormalMark[3,1] = "ABNORMALMARK_14322-00_2";
            judAbnormalMark[1,2] = "ABNORMALMARK_14325-00";
            judAbnormalMark[2,2] = "ABNORMALMARK_14325-00_1";
            judAbnormalMark[3,2] = "ABNORMALMARK_14325-00_2";

            judShortCode[1] = "SHORTSTC_12050-00";          // 聴力右1000Hz
            judShortCode[2] = "SHORTSTC_12060-00";          // 聴力右4000Hz
            judShortCode[3] = "SHORTSTC_12070-00";          // 聴力左1000Hz
            judShortCode[4] = "SHORTSTC_12080-00";          // 聴力左1000Hz

            judResultCode[1] = "RESULT_16324-00";            //ＰＳＡ
            judResultCode[2] = "RESULT_14028-00";            //比重

            abnormalMarkShortCode[1] = "ABNORMALMARK_12050-00";
            abnormalMarkShortCode[2] = "ABNORMALMARK_12060-00";
            abnormalMarkShortCode[3] = "ABNORMALMARK_12070-00";
            abnormalMarkShortCode[4] = "ABNORMALMARK_12080-00";
            abnormalMarkResultCode[1] = "ABNORMALMARK_16324-00";
            abnormalMarkResultCode[2] = "ABNORMALMARK_14028-00";

            // 今回、前回、前々回受診情報
            // 今回
            ((CnDataField)colCnObjects["EDITCSLDATE"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);
            dynamic IKbnName = SelectIKbnName(objRepConsult.RsvNo);
            ((CnDataField)colCnObjects["EDITCSNAME"]).Text = objRepConsult.CsName + Convert.ToString(IKbnName.NAME);
            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (objHistory != null)
            {
                ((CnDataField)colCnObjects["EDITCSLDATE_1"]).Text = string.Format("{0:yyyy年M月d日}", objHistory.CslDate);
                dynamic IKbnName1 = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCnObjects["EDITCSNAME_1"]).Text = objHistory.CsName + Convert.ToString(IKbnName1.NAME);
            }
            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (objHistory != null)
            {
                ((CnDataField)colCnObjects["EDITCSLDATE_2"]).Text = string.Format("{0:yyyy年M月d日}", objHistory.CslDate);
                dynamic IKbnName2 = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCnObjects["EDITCSNAME_2"]).Text = objHistory.CsName + Convert.ToString(IKbnName2.NAME);
            }

            // 便潜血判定
            for (int i = 1; i <= 3; i++) {
                colCnObjects[judLongStcCode[i, 1]].Visible = true;
                colCnObjects[judLongStcCode[i, 2]].Visible = true;
                switch (Strings.StrConv(((CnDataField)colCnObjects[judLongStcCode[i, 1]]).Text, VbStrConv.Wide))
                {
                    case "検査せず":
                        JudSenketu[i,1] = 1;
                        break;
                    case "（－）":
                        JudSenketu[i,1] = 2;
                        break;
                    case "（＋－）":
                        JudSenketu[i,1] = 3;
                        break;
                    case "（＋）":
                        JudSenketu[i,1] = 4;
                        break;
                    case "（２＋）":
                        JudSenketu[i,1] = 5;
                        break;
                    default:
                        JudSenketu[i,1] = 0;
                        break;
                }
                switch (Strings.StrConv(((CnDataField)colCnObjects[judLongStcCode[i, 2]]).Text, VbStrConv.Wide))
                {
                    case "検査せず":
                        JudSenketu[i,2] = 1;
                        break;
                    case "（－）":
                        JudSenketu[i,2] = 2;
                        break;
                    case "（＋－）":
                        JudSenketu[i,2] = 3;
                        break;
                    case "（＋）":
                        JudSenketu[i,2] = 4;
                        break;
                    case "（２＋）":
                        JudSenketu[i,2] = 5;
                        break;
                    default:
                        JudSenketu[i,2] = 0;
                        break;
                }
                if (JudSenketu[i,1] < JudSenketu[i,2])
                {
                    colCnObjects[judLongStcCode[i, 1]].Visible = false;
                }
                else
                {
                    colCnObjects[judLongStcCode[i, 2]].Visible = false;
                }
                colCnObjects[judAbnormalMark[i, 1]].Visible = colCnObjects[judLongStcCode[i, 1]].Visible;
                colCnObjects[judAbnormalMark[i, 2]].Visible = colCnObjects[judLongStcCode[i, 2]].Visible;
            }

            foreach (CnObject cnObject in colCnObjects)
            {
                switch (cnObject.Name.ToUpper())
                {
                    case "CSLDATE":
                        ((CnDataField)colCnObjects["CSLDATE"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);
                        break;
                    case "CSLDATEM":
                        ((CnDataField)colCnObjects["CSLDATEM"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);
                        break;
                    case "BIRTH":
                        ((CnDataField)colCnObjects["BIRTH"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.Birth);
                        break;
                    case "EDITCSLDATE":
                        ((CnDataField)colCnObjects["EDITCSLDATE"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);
                        break;
                    case "EDITCSLDATEM":
                        ((CnDataField)colCnObjects["EDITCSLDATEM"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);
                        break;
                    case "EDITBIRTH":
                        ((CnDataField)colCnObjects["EDITBIRTH"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.Birth);
                        break;
                    case "RESULT_16325-00":
                    // 血清学（ＲＦ）
                        ((CnDataField)colCnObjects["RESULT_16325-00"]).Text = SelectStc_RF(objRepConsult.RsvNo, "16325", "00", 0, 1);
                        break;
                    case "RESULT_16325-00_1":
                    // 血清学（ＲＦ－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (objHistory != null)
                        {
                            ((CnDataField)colCnObjects["RESULT_16325-00_1"]).Text = SelectStc_RF(objHistory.RsvNo, "16325", "00", 1, 1);
                        }
                        break;
                    case "RESULT_16325-00_2":
                    // 血清学（ＲＦ－前々回）
                        objHistory = objRepConsult.Histories.Item(2);
                        if (objHistory != null)
                        {
                            ((CnDataField)colCnObjects["RESULT_16325-00_2"]).Text = SelectStc_RF(objHistory.RsvNo, "16325", "00", 2, 1);
                        }
                        break;
                    case "RESULT_11020-01":
                    // 視力（裸眼／右）
                        ((CnDataField)colCnObjects["RESULT_11020-01"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "01", 0, 1);
                        break;
                    case "RESULT_11020-01_1":
                    // 視力（裸眼／右－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (objHistory != null)
                        {
                            ((CnDataField)colCnObjects["RESULT_11020-01_1"]).Text = SelectStc_RF(objHistory.RsvNo, "11020", "01", 1, 1);
                        }
                        break;
                    case "RESULT_11020-01_2":
                    // 視力（裸眼／右－前々回）
                        objHistory = objRepConsult.Histories.Item(2);
                        if (objHistory != null)
                        {
                            ((CnDataField)colCnObjects["RESULT_11020-01_2"]).Text = SelectStc_RF(objHistory.RsvNo, "11020", "01", 2, 1);
                        }
                        break;
                    case "RESULT_11020-02":
                        // 視力（裸眼／左）
                        ((CnDataField)colCnObjects["RESULT_11020-02"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "02", 0, 1);
                        break;
                    case "RESULT_11020-02_1":
                    // 視力（裸眼／左－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (objHistory != null)
                        {
                            ((CnDataField)colCnObjects["RESULT_11020-02_1"]).Text = SelectStc_RF(objHistory.RsvNo, "11020", "02", 1, 1);
                        }
                        break;
                    case "RESULT_11020-02_2":
                    // 視力（裸眼／左－前々回）
                        objHistory = objRepConsult.Histories.Item(2);
                        if (objHistory != null)
                        {
                            ((CnDataField)colCnObjects["RESULT_11020-02_2"]).Text = SelectStc_RF(objHistory.RsvNo, "11020", "02", 2, 1);
                        }
                        break;
                    case "RESULT_11022-01":
                    // 視力（矯正／右）
                        ((CnDataField)colCnObjects["RESULT_11022-01"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "01", 0, 1);
                        break;
                    case "RESULT_11022-01_1":
                    // 視力（矯正／右－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (objHistory != null)
                        {
                            ((CnDataField)colCnObjects["RESULT_11022-01_1"]).Text = SelectStc_RF(objHistory.RsvNo, "11022", "01", 1, 1);
                        }
                        break;
                    case "RESULT_11022-01_2":
                    // 視力（矯正／右－前々回）
                        objHistory = objRepConsult.Histories.Item(2);
                        if (objHistory != null)
                        {
                            ((CnDataField)colCnObjects["RESULT_11022-01_2"]).Text = SelectStc_RF(objHistory.RsvNo, "11022", "01", 2, 1);
                        }
                        break;
                    case "RESULT_11022-02":
                    // 視力（矯正／左）
                        ((CnDataField)colCnObjects["RESULT_11022-02"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "02", 0, 1);
                        break;
                    case "RESULT_11022-02_1":
                    // 視力（矯正／左－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (objHistory != null)
                        {
                            ((CnDataField)colCnObjects["RESULT_11022-02_1"]).Text = SelectStc_RF(objHistory.RsvNo, "11022", "02", 1, 1);
                        }
                        break;
                    case "RESULT_11022-02_2":
                    // 視力（矯正／左－前々回）
                        objHistory = objRepConsult.Histories.Item(2);
                        if (objHistory != null)
                        {
                            ((CnDataField)colCnObjects["RESULT_11022-02_2"]).Text = SelectStc_RF(objHistory.RsvNo, "11022", "02", 2, 1);
                        }
                        break;
                    default:
                        // アンダースコアでカラム名を分割
                        vntToken = cnObject.Name.Split('_');
                        lngTokenCount = vntToken.Count;
                        if (lngTokenCount >= 1)
                        {
                            switch (PrintCommon.ExceptReplicationSign(vntToken[0]).ToUpper())
                            {
                                case "RESULT":
                                case "SHORTSTC":
                                case "LONGSTC":
                                    if (Strings.Right(Strings.RTrim(cnObject.Name), 2) == "_1" || Strings.Right(Strings.RTrim(cnObject.Name), 2) == "_2")
                                    {
                                        if (Strings.StrConv(Strings.Left(((CnDataField)cnObject).Text, 1), VbStrConv.Narrow) == "*")
                                        {
                                            ((CnDataField)cnObject).Text = "";
                                            ((CnDataField)colCnObjects[cnObject.Name.Replace(vntToken[0], "ABNORMALMARK")]).Text = "";
                                        }
                                    }
                                    break;
                                case "JUDRNAME":
                                    if (Convert.ToInt32(vntToken[1]) >= 1 && Convert.ToInt32(vntToken[1]) <= 28)
                                    {
                                        if (lngTokenCount - 1 <= 1)
                                        {
                                            dynamic rslData = SelectJudHistoryRsl(objRepConsult.RsvNo, Convert.ToInt32(vntToken[1]), true);
                                            ((CnDataField)cnObject).Text = rslData.JUDRNAME;
                                            if (rslData.JUDRNAME.ToUpper() == "＊＊")
                                            {
                                                switch (Convert.ToInt32(vntToken[1]))
                                                {
                                                    case 5:
                                                        ((CnDataField)colCnObjects["RESULT_13020-00"]).Text = "********";
                                                        ((CnDataField)colCnObjects["RESULT_13022-00"]).Text = "********";
                                                        ((CnDataField)colCnObjects["RESULT_13023-00"]).Text = "********";
                                                        ((CnDataField)colCnObjects["RESULT_13024-00"]).Text = "********";
                                                        ((CnDataField)colCnObjects["ABNORMALMARK_13020-00"]).Text = "";
                                                        ((CnDataField)colCnObjects["ABNORMALMARK_13022-00"]).Text = "";
                                                        ((CnDataField)colCnObjects["ABNORMALMARK_13023-00"]).Text = "";
                                                        ((CnDataField)colCnObjects["ABNORMALMARK_13024-00"]).Text = "";
                                                        break;
                                                    case 8:
                                                        ((CnDataField)colCnObjects["LONGSTC_14322-00"]).Text = "＊＊＊＊＊";
                                                        ((CnDataField)colCnObjects["ABNORMALMARK_14322-00"]).Text = "";
                                                        break;
                                                    case 18:
                                                        ((CnDataField)colCnObjects[judResultCode[1]]).Text = "********";
                                                        ((CnDataField)colCnObjects[abnormalMarkResultCode[1]]).Text = "";
                                                        break;
                                                    case 19:
                                                        ((CnDataField)colCnObjects[judResultCode[2]]).Text = "********";
                                                        ((CnDataField)colCnObjects[abnormalMarkResultCode[2]]).Text = "";
                                                        break;
                                                    case 22:
                                                        ((CnDataField)colCnObjects[judShortCode[1]]).Text = "＊＊＊＊＊";
                                                        ((CnDataField)colCnObjects[judShortCode[2]]).Text = "＊＊＊＊＊";
                                                        ((CnDataField)colCnObjects[judShortCode[3]]).Text = "＊＊＊＊＊";
                                                        ((CnDataField)colCnObjects[judShortCode[4]]).Text = "＊＊＊＊＊";
                                                        ((CnDataField)colCnObjects[abnormalMarkShortCode[1]]).Text = "";
                                                        ((CnDataField)colCnObjects[abnormalMarkShortCode[2]]).Text = "";
                                                        ((CnDataField)colCnObjects[abnormalMarkShortCode[3]]).Text = "";
                                                        ((CnDataField)colCnObjects[abnormalMarkShortCode[4]]).Text = "";
                                                        break;
                                                    case 28:
                                                        ((CnDataField)colCnObjects["RESULT_18426-00"]).Text = "********";
                                                        ((CnDataField)colCnObjects["RESULT_18425-00"]).Text = "********";
                                                        ((CnDataField)colCnObjects["ABNORMALMARK_18426-00"]).Text = "";
                                                        ((CnDataField)colCnObjects["ABNORMALMARK_18425-00"]).Text = "";
                                                        break;
                                                }
                                            }
                                            if (rslData.JUDRNAME.ToUpper() == "－－")
                                            {
                                                switch (Convert.ToInt32(vntToken[1]))
                                                {
                                                    case 5:
                                                        ((CnDataField)colCnObjects["RESULT_13020-00"]).Text = "--------";
                                                        ((CnDataField)colCnObjects["RESULT_13022-00"]).Text = "--------";
                                                        ((CnDataField)colCnObjects["RESULT_13023-00"]).Text = "--------";
                                                        ((CnDataField)colCnObjects["RESULT_13024-00"]).Text = "--------";
                                                        ((CnDataField)colCnObjects["ABNORMALMARK_13020-00"]).Text = "";
                                                        ((CnDataField)colCnObjects["ABNORMALMARK_13022-00"]).Text = "";
                                                        ((CnDataField)colCnObjects["ABNORMALMARK_13023-00"]).Text = "";
                                                        ((CnDataField)colCnObjects["ABNORMALMARK_13024-00"]).Text = "";
                                                        break;
                                                    case 8:
                                                        ((CnDataField)colCnObjects["LONGSTC_14322-00"]).Text = "検査せず";
                                                        ((CnDataField)colCnObjects["ABNORMALMARK_14322-00"]).Text = "";
                                                        break;
                                                    case 18:
                                                        ((CnDataField)colCnObjects[judResultCode[1]]).Text = "検査せず";
                                                        ((CnDataField)colCnObjects[abnormalMarkResultCode[1]]).Text = "";
                                                        break;
                                                    case 19:
                                                        ((CnDataField)colCnObjects[judResultCode[2]]).Text = "検査せず";
                                                        ((CnDataField)colCnObjects[abnormalMarkResultCode[2]]).Text = "";
                                                        break;
                                                    case 22:
                                                        ((CnDataField)colCnObjects[judShortCode[1]]).Text = "検査せず";
                                                        ((CnDataField)colCnObjects[judShortCode[2]]).Text = "検査せず";
                                                        ((CnDataField)colCnObjects[judShortCode[3]]).Text = "検査せず";
                                                        ((CnDataField)colCnObjects[judShortCode[4]]).Text = "検査せず";
                                                        ((CnDataField)colCnObjects[abnormalMarkShortCode[1]]).Text = "";
                                                        ((CnDataField)colCnObjects[abnormalMarkShortCode[2]]).Text = "";
                                                        ((CnDataField)colCnObjects[abnormalMarkShortCode[3]]).Text = "";
                                                        ((CnDataField)colCnObjects[abnormalMarkShortCode[4]]).Text = "";
                                                        break;
                                                    case 28:
                                                        ((CnDataField)colCnObjects["RESULT_18426-00"]).Text = "--------";
                                                        ((CnDataField)colCnObjects["RESULT_18425-00"]).Text = "--------";
                                                        ((CnDataField)colCnObjects["ABNORMALMARK_18426-00"]).Text = "";
                                                        ((CnDataField)colCnObjects["ABNORMALMARK_18425-00"]).Text = "";
                                                        break;
                                                }
                                            }
                                        }
                                    }
                                    break;
                            }
                        }
                        break;
                }
            }
            colCnObjects["JUDRNAME_2"].Visible = false;
            colCnObjects["JUDRNAME_3"].Visible = false;
            colCnObjects["JUDRNAME_5"].Visible = false;
            colCnObjects["JUDRNAME_8"].Visible = false;
            colCnObjects["JUDRNAME_10"].Visible = false;
            colCnObjects["JUDRNAME_11"].Visible = false;
            colCnObjects["JUDRNAME_12"].Visible = false;
            colCnObjects["JUDRNAME_13"].Visible = false;
            colCnObjects["JUDRNAME_14"].Visible = false;
            colCnObjects["JUDRNAME_15"].Visible = false;
            colCnObjects["JUDRNAME_16"].Visible = false;
            colCnObjects["JUDRNAME_17"].Visible = false;
            colCnObjects["JUDRNAME_18"].Visible = false;
            colCnObjects["JUDRNAME_19"].Visible = false;
            colCnObjects["JUDRNAME_20"].Visible = false;
            colCnObjects["JUDRNAME_22"].Visible = false;
            colCnObjects["JUDRNAME_23"].Visible = false;
            colCnObjects["JUDRNAME_28"].Visible = false;

            // ### 検査結果基準値履歴管理
            if (DateTime.Compare(objRepConsult.CslDate, DateTime.Parse("2005/01/07")) < 0)
            {
                colCnObjects["Label20050107-TSH"].Visible = false;
                colCnObjects["Label20050107-FT4"].Visible = false;
                colCnObjects["Label20050106-TSH"].Visible = true;
                colCnObjects["Label20050106-FT4"].Visible = true;

                if (DateTime.Compare(objRepConsult.CslDate, DateTime.Parse("2004/07/20")) < 0)
                {
                    colCnObjects["LBL20040719"].Visible = true;
                    colCnObjects["LBL20040720"].Visible = false;
                }
                else
                {
                    colCnObjects["LBL20040719"].Visible = false;
                    colCnObjects["LBL20040720"].Visible = true;
                }
            }
            else
            {
                colCnObjects["Label20050107-TSH"].Visible = true;
                colCnObjects["Label20050107-FT4"].Visible = true;
                colCnObjects["LBL20040720"].Visible = true;
                colCnObjects["Label20050106-TSH"].Visible = false;
                colCnObjects["Label20050106-FT4"].Visible = false;
                colCnObjects["LBL20040719"].Visible = false;
            }

            if (DateTime.Compare(objRepConsult.CslDate, DateTime.Parse("2004/10/30")) < 0)
            {
                colCnObjects["Label20041029"].Visible = true;
                colCnObjects["Label20041030"].Visible = false;
            }
            else
            {
                colCnObjects["Label20041029"].Visible = false;
                colCnObjects["Label20041030"].Visible = true;
            }

            if (DateTime.Compare(objRepConsult.CslDate, DateTime.Parse("2007/06/27")) < 0)
            {
                // TODO CnTextの使用確定不加
                ((CnText)colCnObjects["Label_CRP"]).Text = "（0.39≧）";
            }
            else
            {
                ((CnText)colCnObjects["Label_CRP"]).Text = "（0.3≧）";
            }
        }

        /// <summary>
        /// 結核成績書(胸部X線)日本語版の編集// 
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_ReportCR(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 指定対象受診者の判定結果を取得する
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="lngJudClassCd">判定分類コード</param>
        /// <param name="blnConvFlg">判定変換フラグ（今回歴はTrue、過去歴はFalse）</param>
        /// <returns>レコード</returns>
        private dynamic SelectJudHistoryRsl(int lngRsvNo, int lngJudClassCd, bool blnConvFlg)
        {
            string sql;         // SQLステートメント
            dynamic retData = new System.Dynamic.ExpandoObject();    // 戻り値
            bool blnHitFlg;     // ヒットフラグ

            // 初期処理
            retData.JUDCD = "";
            retData.JUDRNAME = "";

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("judclasscd", lngJudClassCd);

            // 乳房特殊処理用判定分類コード
            sqlParam.Add("nyujudclasscd", NYUBOU_JUDCLASSCD);
            sqlParam.Add("syokujudclasscd", NYUSYOKU_JUDCLASSCD);
            sqlParam.Add("xsenjudclasscd", NYUXSEN_JUDCLASSCD);
            sqlParam.Add("choujudclasscd", NYUCHOU_JUDCLASSCD);

            sql = @"
                    select
                        finalrsl.perid
                        , finalrsl.csldate
                        , finalrsl.rsvno
                        , judclass.judclasscd
                        , judclass.judclassname
                        , finalrsl.judcd
                        , jud.judrname 
                    from
                        jud
                        , judclass
                        , ( 
                            select
                                judclassview.csldate
                                , judclassview.rsvno
                                , judclassview.perid
                                , judclassview.judclasscd
                                , judrsl.judcd
                                , judrsl.upduser
                                , judrsl.updflg
                                , judrsl.judcmtcd 
                            from
                                ( 
                                    select
                                        finalconsult.csldate
                                        , finalconsult.rsvno
                                        , finalconsult.perid
                                        , finalconsult.cscd
                                        , course_jud.judclasscd 
                                    from
                                        ( 
                                            select
                                                csldate
                                                , rsvno
                                                , perid
                                                , cscd 
                                            from
                                                consult 
                                            where
                                                consult.rsvno = :rsvno 
                                                and consult.cancelflg = 0
                                        ) finalconsult
                                        , course_jud 
                                    where
                                        finalconsult.cscd = course_jud.cscd 
                                        and ( 
                                            course_jud.noreason = 1 
                                            or exists ( 
                                                select
                                                    rsl.rsvno 
                                                from
                                                    item_jud
                                                    , rsl 
                                                where
                                                    rsl.rsvno = finalconsult.rsvno 
                                                    and rsl.itemcd = item_jud.itemcd 
                                                    and rsl.stopflg is null 
                                                    and item_jud.judclasscd = course_jud.judclasscd
                                            ) 
                                            or ( 
                                                exists ( 
                                                    select
                                                        rsl.rsvno 
                                                    from
                                                        item_jud
                                                        , rsl 
                                                    where
                                                        rsl.rsvno = finalconsult.rsvno 
                                                        and rsl.itemcd = item_jud.itemcd 
                                                        and rsl.stopflg is null 
                                                        and item_jud.judclasscd in ( 
                                                            :syokujudclasscd
                                                            , :xsenjudclasscd
                                                            , :choujudclasscd
                                                        )
                                                ) 
                                                and course_jud.judclasscd = :nyujudclasscd
                                            )
                                        )
                                ) judclassview
                                , judrsl 
                            where
                                judclassview.rsvno = judrsl.rsvno(+) 
                                and judclassview.judclasscd = judrsl.judclasscd(+)
                        ) finalrsl 
                    where
                        finalrsl.judcd = jud.judcd(+) 
                        and finalrsl.judclasscd(+) = judclass.judclasscd 
                        and judclass.judclasscd = :judclasscd

                ";

            dynamic data = connection.Query(sql, sqlParam).FirstOrDefault();

            // 検索レコードが存在する場合
            if (data != null)
            {
                // 予約番号がＮＵＬＬの場合は
                if (string.IsNullOrEmpty(Convert.ToString(data.RSVNO)))
                {
                    blnHitFlg = true;
                } else
                {
                    blnHitFlg = false;
                }

                // 判定コード
                retData.JUDCD = Convert.ToString(data.JUDCD);
                // 判定報告名
                retData.JUDRNAME = Convert.ToString(data.JUDRNAME);

                // -- 「＊＊」の判定ロジック
                if (blnConvFlg)
                {
                    // 該当する依頼が無い！！
                    if (!blnHitFlg)
                    {
                        retData.JUDRNAME = "＊＊";

                        // 中止コメントの場合の処理を付加！！
                        if (SelectJudStoped(0, 0))          // ぱらめた必要なかった！！
                        {
                            retData.JUDRNAME = "－－";
                        }

                    }
                }
            }

            return retData;
        }

        /// <summary>
        /// 指定対象受診者の判定分類が検査中止になっているかを取得する
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="lngJudClassCd">判定分類コード</param>
        /// <returns></returns>
        public bool SelectJudStoped(int lngRsvNo, int lngJudClassCd)
        {
            string sql;             // SQLステートメント
            int lngCount = 0;       // カウンタ
            IList<string> strStoped = new List<string>();    // 中止フラグ格納領域

            bool ret = false;

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("judclasscd", lngJudClassCd);

            sql = @"
                    select distinct
                        decode(rsl.stopflg, null, 'OFF', 'ON') stoped 
                    from
                        rsl
                        , item_jud
                        , ( 
                            select
                                item_c.itemcd
                                , item_c.suffix 
                            from
                                item_jud
                                , item_c 
                            where
                                item_jud.itemcd = item_c.itemcd 
                                and item_jud.judclasscd = :judclasscd
                        ) juditem 
                    where
                        rsl.itemcd = juditem.itemcd 
                        and rsl.suffix = juditem.suffix 
                        and rsl.rsvno = :rsvno
                ";

            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            // 検索レコードが存在する場合
            foreach (var rec in data)
            {
                lngCount++;
                strStoped.Add(Convert.ToString(rec.STOPED));
            }

            // 戻り値の設定
            if (lngCount == 1)
            {
                if ("ON".Equals(strStoped[0]))
                {
                    // 返ってきた値が検査中止おんりーだったら検査中止項目！！
                    ret = true;
                }
            } else
            {
                // 一種類以外（種類なしも含む）の結果が返ってきたら検査中止項目ではない
            }

            return ret;
        }

        /// <summary>
        /// 新３連成績書１枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3N_1(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ３連成績書２枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3N_2(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 新３連成績書３枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3N_3(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// OrgRptOptテーブルを参照してオプション検査項目出力可否を制御する
        /// </summary>
        /// <param name="pOrgCd1"></param>
        /// <param name="pOrgCd2"></param>
        /// <param name="pRptOptCd"></param>
        /// <param name="VFlag"></param>
        /// <returns></returns>
        private bool ChkRptOpt(string pOrgCd1, string pOrgCd2, string pRptOptCd, int VFlag)
        {
            string sql;             // SQLステートメン
            //    '初期処理
            bool bolVisible = false;

            //    'キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("orgcd1", pOrgCd1);
            sqlParam.Add("orgcd2", pOrgCd2);
            sqlParam.Add("rptoptcd", pRptOptCd);
            sqlParam.Add("delflg", VFlag);
            // 指定オプション検査項目を取得
            sql = @"
                select
                  rptoptcd
                  , delflg 
                from
                  orgrptopt 
                where
                  orgcd1 = :orgcd1 
                  and orgcd2 = :orgcd2 
                  and rptoptcd = :rptoptcd 
                  and delflg = :delflg
                ";
            dynamic data = connection.Query(sql, sqlParam).FirstOrDefault();

            //    '検索レコードが存在する場合
            if (null!=data)
            {
                bolVisible = true;
            }
            return bolVisible;
        }

        /// <summary>
        /// OrgRptOptテーブルを参照してオプション検査項目出力可否を制御する
        /// </summary>
        /// <param name="pOrgCd1"></param>
        /// <param name="pOrgCd2"></param>
        /// <param name="pRptOptCd"></param>
        /// <param name="pJudClassCd"></param>
        /// <param name="VFlag"></param>
        /// <param name="bolSFlag"></param>
        /// <returns></returns>
        private dynamic SelectRptOpt(string pOrgCd1, string pOrgCd2, string pRptOptCd, string pJudClassCd, bool VFlag, bool bolSFlag)
        {
            return null;
        }

        /// <summary>
        /// OrgRptOptテーブルを参照してオプション検査項目出力可否を制御する。
        /// </summary>
        /// <param name="pOrgCd1"></param>
        /// <param name="pOrgCd2"></param>
        /// <param name="pRptOptCd"></param>
        /// <param name="pJudClass"></param>
        /// <param name="VFlag"></param>
        /// <param name="rCnt"></param>
        /// <returns></returns>
        private bool ChkRptJudOpt(string pOrgCd1, string pOrgCd2, string pRptOptCd, string pJudClass, bool VFlag, int rCnt)
        {
            return true;
        }

        /// <summary>
        /// 該当の団体の契約情報参照可否をチェックする
        /// </summary>
        /// <param name="pOrgCd1"></param>
        /// <param name="pOrgCd2"></param>
        /// <returns></returns>
        private bool CtrChkOrg(string pOrgCd1, string pOrgCd2)
        {
            string sql;             // SQLステートメント

            //'初期処理
            bool bolRet = false;
            //'キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("orgcd", pOrgCd1 + "-" + pOrgCd2);
            sqlParam.Add("freeclasscd", FREECLASS_CTR);

            // 指定オプション検査項目を取得
            sql = @"
                select
                  freefield1 
                from
                  free 
                where
                  freeclasscd = :freeclasscd 
                  and freefield1 = :orgcd
                ";
            dynamic data = connection.Query(sql, sqlParam).FirstOrDefault();
            if (null!=data)
            {
                bolRet = true;
            }
            return bolRet;
        }

        /// <summary>
        /// 契約情報で個人負担金を確認する
        /// </summary>
        /// <param name="pRsvNo"></param>
        /// <param name="pGrpCd"></param>
        /// <param name="pPrice"></param>
        /// <param name="pTotal"></param>
        /// <returns></returns>
        private bool OrgPriceItem(int pRsvNo, string pGrpCd, int pPrice, int pTotal = 0)
        {
            string sql;             // SQLステートメン
            //    '初期処理
            bool bolRet = false;

            //    'キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", pRsvNo);
            sqlParam.Add("grpcd", pGrpCd);
            sqlParam.Add("price", pPrice);
            sql = @"
                select
                  a.rsvno
                  , a.ctrptcd
                  , a.optcd
                  , a.optbranchno
                  , b.optname
                  , c.seq
                  , c.price
                  , c.orgdiv
                  , d.apdiv
                  , e.grpcd
                  , decode(d.apdiv, 0, '個人', 1, '契約団体', d.apdiv) orgname 
                from
                  consult_o a
                  , ctrpt_opt b
                  , ctrpt_price c
                  , ctrpt_org d
                  , ctrpt_grp e 
                where
                  a.rsvno = :rsvno 
                  and a.ctrptcd = b.ctrptcd 
                  and a.optcd = b.optcd 
                  and a.optbranchno = b.optbranchno 
                  and a.ctrptcd = c.ctrptcd 
                  and a.optcd = c.optcd 
                  and a.optbranchno = c.optbranchno 
                  and c.ctrptcd = d.ctrptcd 
                  and c.seq = d.seq 
                  and e.grpcd = :grpcd 
                  and b.ctrptcd = e.ctrptcd(+) 
                  and b.optcd = e.optcd(+) 
                  and b.optbranchno = e.optbranchno(+) 
                  and d.apdiv = 1 
                  and c.price > 0
                ";
            dynamic data = connection.Query(sql, sqlParam).FirstOrDefault();

            //    '検索レコードが存在する場合
            if (null!=data)
            {
                int price = data.PRICE;
                if (price == pPrice)
                {
                    bolRet = true;
                }
                else if(price> pPrice)
                {
                    if (pTotal>0 && pTotal== data.PRICE)
                    {
                        bolRet = true;
                    }
                }
            }
            return bolRet;
        }

        /// <summary>
        /// 指定オプション検査項目を確認する
        /// </summary>
        /// <param name="pOrgCd1"></param>
        /// <param name="pOrgCd2"></param>
        /// <param name="pCsCd"></param>
        /// <param name="pGrpCd"></param>
        /// <returns></returns>
        private bool ChkFreeNPRT(string pOrgCd1, string pOrgCd2, string pCsCd, string pGrpCd)
        {
            return true;
        }

        /// <summary>
        /// 指定グループ内検査項目における文章を取得
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="strGrpCd">グループコード</param>
        /// <returns></returns>
        private IList<dynamic> SelectStc_2nd_CT(int lngRsvNo, string strGrpCd)
        {
            return null;
        }

        /// <summary>
        /// 指定グループ内検査項目における文章を取得(E-CT)
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="strGrpCd">グループコード</param>
        /// <returns></returns>
        private IList<dynamic> SelectStc_2nd_E_CT(int lngRsvNo, string strGrpCd)
        {
            string sql;             // SQLステートメント
            bool blnFind = false;   // 検索フラグ
            bool blnSoken = false;
            bool blnDiag = false;
            int lngCount = 0;       // レコード数
            IList<dynamic> retData = new List<dynamic>();

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("grpcd", strGrpCd);

            sql = @"
                   select
                      item_c.itemname
                      , sentence.engstc
                      , sentence.shortstc
                      , item_c.itemcd 
                    from
                      rsl
                      , item_c
                      , grp_i
                      , sentence 
                    where
                      rsl.rsvno = :rsvno 
                      and grp_i.grpcd = :grpcd 
                      and rsl.itemcd = grp_i.itemcd 
                      and rsl.suffix = grp_i.suffix 
                      and rsl.itemcd = item_c.itemcd 
                      and rsl.suffix = item_c.suffix 
                      and item_c.itemcd = sentence.itemcd 
                      and item_c.itemtype = sentence.itemtype 
                      and rsl.result = sentence.stccd 
                    order by
                      nvl(sentence.printorder, 99999)
                      , grp_i.seq
                      , rsl.itemcd
                      , rsl.suffix
                ";

            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            // 配列形式で格納する(英語版)
            foreach (var rec in data)
            {
                string strShortStc = Convert.ToString(rec.SHORTSTC);
                string strLongStc = Convert.ToString(rec.LONGSTC);
                string strEngStc = Convert.ToString(rec.ENGSTC);
                // 重複しない文章のみ抽出する
                blnFind = false;
                int i = 0;
                while (!(i > (lngCount - 1)))
                {
                    if (strEngStc.Equals(Convert.ToString(data[i].ENGSTC)) && strShortStc.Equals(Convert.ToString(data[i].SHORTSTC)))
                    {
                        blnFind = true;
                        break;
                    }
                    i++;
                }

                // 表示したくないものについて（空白設定されている所見）は無かったものとする
                if ("".Equals(strShortStc.Trim()) && "".Equals(strLongStc.Trim()))
                {
                    blnFind = true;
                }
                if (strEngStc==null && strShortStc==null)
                {
                    blnFind = true;
                }


                if (!blnFind)
                {
                    retData.Add(rec);
                    lngCount++;
                }
            }
            // 空白行削除時、配列にならない可能性のため
            int iDiagCnt = 0;
            if (lngCount > 0)
            {
                for (int idx = 0; idx < retData.Count; idx++)
                {
                    string strEngStc = Convert.ToString(retData[idx].ENGSTC);
                    if (("").Equals(strEngStc) && strEngStc.IndexOf("NO SIGNIFICANT ABNORMALITY") == 0)
                    {
                        blnSoken = true;
                        break;
                    }
                    if (Convert.ToString(retData[idx].ITEMCD)== "21420")
                    {
                        iDiagCnt += 1;
                        if (retData[idx].SHORTSTC== "その他")
                        {
                            blnDiag = true;
                        }
                    }
                }

                if (!blnSoken && iDiagCnt == 1 && blnDiag)
                {
                    retData[lngCount].SHORTSTC = "OHTERS";
                    lngCount++;
                }
            }
            if (lngCount > 0)
            {
                for (int idx = 0; idx < retData.Count; idx++)
                {
                    string strEngStc = Convert.ToString(retData[idx].ENGSTC);
                    if (strEngStc.IndexOf("NO SIGNIFICANT ABNORMALITY") != 0)
                    {
                        retData[idx].ENGSTC = "";
                    }
                }
            }

            return retData;
        }

        /// <summary>
        /// 予約情報でのセット分類コード登録有無チェック
        /// </summary>
        /// <param name="lngRsvNo"></param>
        /// <param name="strSetClassCd"></param>
        /// <returns></returns>
        private bool CheckSetClass(int lngRsvNo, string strSetClassCd)
        {
            string sql;         // SQLステートメント
            Boolean bolRet = false;
            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("setclasscd", strSetClassCd);

            // 指定オプション検査項目を取得
            sql = @"
                 select
                  count(consult_o.rsvno) as setcount 
                from
                  consult_o
                  , ctrpt_opt 
                where
                  consult_o.rsvno = :rsvno 
                  and consult_o.ctrptcd = ctrpt_opt.ctrptcd 
                  and consult_o.optcd = ctrpt_opt.optcd 
                  and consult_o.optbranchno = ctrpt_opt.optbranchno 
                  and ctrpt_opt.setclasscd = :setclasscd
                ";
            dynamic data = connection.Query(sql, sqlParam).FirstOrDefault();
            if (null!=data && data.SETCOUNT>0)
            {
                bolRet = true;
            }
            return bolRet;
        }

        /// <summary>
        /// オプション血液検査の出力を決定。
        /// </summary>
        /// <param name="pRsvNo"></param>
        /// <returns></returns>
        private bool CheckOptionComment(int pRsvNo)
        {
            string sql;             // SQLステートメント
            bool bolRet=false;
            int iCnt1 =0;
            int iCnt2 =0;
            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", pRsvNo);
            // 指定オプション検査項目を取得
            sql = @"
                   select
                      count(rsl.itemcd) cnt1
                      , ( 
                        select
                          count(x.judcmtcd) 
                        from
                          totaljudcmt x 
                        where
                          x.rsvno = :rsvno 
                          and x.dispmode = 1 
                          and x.judcmtcd = '104100'
                      ) cnt2 
                    from
                      grp_i
                      , rsl 
                    where
                      rsl.rsvno = :rsvno 
                      and grp_i.grpcd = :grpcd 
                      and rsl.itemcd = grp_i.itemcd 
                      and rsl.suffix = grp_i.suffix 
                      and rsl.result is not null 
                    group by
                      rsl.rsvno
                ";
            dynamic data = connection.Query(sql, sqlParam).FirstOrDefault();
            if (null!=data)
            {
                iCnt1 = data.CNT1;
                iCnt2 = data.CNT2;
            }

            if (iCnt1 > 0 && iCnt2 == 0)
            {
                bolRet = true;
            }

            return bolRet;
        }

        /// <summary>
        /// 指定オプション検査項目を確認する
        /// </summary>
        /// <param name="pOrgCd1"></param>
        /// <param name="pOrgCd2"></param>
        /// <param name="VR"></param>
        /// <returns></returns>
        private bool HistoryViewChk(string pOrgCd1, string pOrgCd2, ref string VR)
        {
            string sql;             // SQLステートメント
            bool bolVisible;

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("orgcd", pOrgCd1);
            sqlParam.Add("freeclasscd", FREECLASS_SPT);

            // 指定オプション検査項目を取得
            sql = @"
                    select
                        freefield1
                        , freefield2
                        , freefield3 
                    from
                        free 
                    where
                        freeclasscd = :freeclasscd 
                        and freefield1 = :orgcd

                ";

            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            // 検索レコードが存在する場合
            if (data.Count > 0)
            {
                foreach (var rec in data)
                {
                    VR = rec.FREEFIELD3;
                }
                bolVisible = true;
            }
            else
            {
                VR = "";
                bolVisible = false;
            }
            return bolVisible;
        }

        /// <summary>
        /// 過去結果を出力する団体チェック
        /// </summary>
        /// <param name="OrgCd1"></param>
        /// <param name="OrgCd2"></param>
        /// <param name="iPage"></param>
        /// <param name="CrObj"></param>
        private void CheckVisible(string OrgCd1, string OrgCd2, int iPage, CnObjects CrObj)
        {
            CnObject objCrObject;                  // 描画オブジェクトのコレクション
            String strView = "";              
            String strObjName;        
            String strObjType;          
            String strTemp;

            if (HistoryViewChk(OrgCd1, OrgCd2, ref strView))
            {
                foreach (CnObject rec in CrObj)
                {
                    // strObjType = rec.ObjectType;
                    strObjName = rec.Name;
                    strTemp = strObjName.Substring(strObjName.Length - 2, 2);
                    if (strView.Trim().Equals("ZZ"))// 前回、前々回出力
                    {
                        if (strObjName.IndexOf("_1")>=0 || strObjName.IndexOf("_2") >= 0)
                        {
                            rec.Visible = true;
                        }
                        switch (strObjName)
                        {
                            case "JYOUBU1":
                            case "KYOUBUX1":
                            case "HUJINKA_NYUBOUS1":
                            case "HUJINKA_KEIBU1":
                            case "HUJINKA_NAISIN1":
                            case "GANTEI_SYOKEN1":
                                rec.Visible = true;
                                break;
                            case "JYOUBU2":
                            case "KYOUBUX2":
                            case "HUJINKA_NYUBOUS2":
                            case "HUJINKA_KEIBU2":
                            case "HUJINKA_NAISIN2":
                            case "GANTEI_SYOKEN2":
                                rec.Visible = true;
                                break;
                        }
                    }else if (strView.Trim().Equals("Z"))// 前回出力
                    {
                        if (strTemp.Equals("_1"))

                        {
                            rec.Visible = true;
                            switch (strObjName)
                            {
                                case "JYOUBU1":
                                case "KYOUBUX1":
                                case "HUJINKA_NYUBOUS1":
                                case "HUJINKA_KEIBU1":
                                case "HUJINKA_NAISIN1":
                                case "GANTEI_SYOKEN1":
                                    rec.Visible = true;
                                    break;
                            }
                        }else if (strTemp.Equals("_2"))
                        {
                            rec.Visible = false;
                            switch (strObjName)
                            {
                                case "JYOUBU2":
                                case "KYOUBUX2":
                                case "HUJINKA_NYUBOUS2":
                                case "HUJINKA_KEIBU2":
                                case "HUJINKA_NAISIN2":
                                case "GANTEI_SYOKEN2":
                                    rec.Visible = false;
                                    break;
                            }
                        }
                    }
                }
            }
            else // ---------------------------------------- - 今回出力
            {
                foreach (CnObject rec in CrObj)
                {
                    // strObjType = objCrObject.ObjectType
                    strObjName = rec.Name;
                    strTemp = strObjName.Substring(strObjName.Length - 2, 2);
                    if (strTemp.Equals("_1") || strTemp.Equals("_2"))
                    {
                        rec.Visible = false;
                    }
                    switch (strObjName)
                    {
                        case "JUDRNAME_1":
                        case "JUDRNAME_2":
                            rec.Visible = true;
                            break;
                        case "JYOUBU1":
                        case "KYOUBUX1":
                        case "HUJINKA_NYUBOUS1":
                        case "HUJINKA_KEIBU1":
                        case "HUJINKA_NAISIN1":
                        case "GANTEI_SYOKEN1":
                            rec.Visible = false;
                            break;
                        case "JYOUBU2":
                        case "KYOUBUX2":
                        case "HUJINKA_NYUBOUS2":
                        case "HUJINKA_KEIBU2":
                        case "HUJINKA_NAISIN2":
                        case "GANTEI_SYOKEN2":
                            rec.Visible = false;
                            break;
                    }
                }
            }
        }

        /// <summary>
        /// ５連成績書１枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report5N820_2(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ５連成績書２枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report5N820_3(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ５連成績書３枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report5N820_4(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ５連成績書３枚目の編集 2011.01.01版対応
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report5N820_4_2011(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ５連成績書４枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report5N820_5(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ５連成績書５枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report5N820_6(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書１枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6N320_1(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {
            CnObjects colCnObjects;     // 描画オブジェクトのコレクション

            string strAddress;          // 住所判定用
            bool FlgANK;                // 住所判定用

            // 描画オブジェクトコレクションの参照設定
            colCnObjects = cnForm.CnObjects;

            // 住所１行目（都道府県名 + 市区町村名）
            ((CnDataField)colCnObjects["EDITADDR1"]).Text = objRepConsult.PrefName + objRepConsult.CityName;
            // 住所２行目（住所１）
            ((CnDataField)colCnObjects["EDITADDR2"]).Text = objRepConsult.Address1;
            // 住所３行目（住所２）
            ((CnDataField)colCnObjects["EDITADDR3"]).Text = objRepConsult.Address2;
            // 受診日
            ((CnDataField)colCnObjects["EDITCSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
            // 生年月日
            ((CnDataField)colCnObjects["EDITBIRTH"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.Birth);
            // コース名
            dynamic IKbnName = SelectIKbnName(objRepConsult.RsvNo);
            ((CnDataField)colCnObjects["EDITCSNAME"]).Text = objRepConsult.CsName + Convert.ToString(IKbnName.NAME);

            FlgANK = false;
            strAddress = objRepConsult.PrefName.TrimEnd() + objRepConsult.CityName.TrimEnd() + objRepConsult.Address1.TrimEnd() + objRepConsult.Address2.TrimEnd();
            if (strAddress.Length == WebHains.LenB(strAddress))
            {
                for (int i = 0; i < strAddress.Length; i++)
                {
                    byte asc = (byte)Convert.ToChar(strAddress.Substring(i, 1));
                    if (asc >= 166 && asc <= 223)
                    {
                        FlgANK = true;
                        break;
                    }
                }
            } else
            {
                FlgANK = true;
            }
            if (FlgANK == false)
            {
                // カナなし
                ((CnDataField)colCnObjects["LASTNAME"]).Text = (objRepConsult.Gender == 1 ? "MR. " : "MS. ") + objRepConsult.LastName;
            } else
            {
                // カナあり
                ((CnDataField)colCnObjects["FIRSTNAME"]).Text = objRepConsult.FirstName.TrimEnd() + "　様";
            }

        }

        /// <summary>
        /// ６連成績書２枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6N320_2(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {
            const int ItemCount = 12;                           // グラフアイテム個数
            const int PerfectScore = 10;                        //最高スコア

            CnObjects colCnObjects;                             // 描画オブジェクトのコレクション
            CnObject objCnObject;                               // 描画オブジェクト
            RepHistory objHistory;                              // 受診履歴クラス
            double[] sngLastResult = new double[ItemCount];     // 前回歴検査結果
            RepResult objResult;                                // 検査結果クラス
            double[] sngResult = new double[ItemCount];         // 検査結果

            Boolean[] blnLastResult = new Boolean[ItemCount];
            Boolean[] blnResult = new Boolean[ItemCount];

            double sngBaseX = 0;                                // Ｘ座標（中心）
            double sngBaseY = 0;                                // Ｙ座標（中心）
            double sngLastX = 0;                                // Ｘ座標
            double sngLastY = 0;                                // Ｙ座標
            double sngX = 0;                                    // Ｘ座標
            double sngY = 0;                                    // Ｙ座標
            int lngIndex;                                       // 配列インデックス


            IList<string> vntToken;                             // トークン
            int lngTokenCount;                                  // トークン数
            Boolean blnLastGraphDraw;                           // グラフ描画フラグ（前回歴）
            Boolean blnGraphDraw = false;                       // グラフ描画フラグ
            int lngRslCount;                                    // 結果件数
            //Dim vntJudCmtStc            As Variant            // 判定コメント
            string strJudCntStc = "";                           // 判定コメント


            int i;

            // 描画オブジェクトコレクションの参照設定
            colCnObjects = cnForm.CnObjects;

            foreach (CnObject cnObject in colCnObjects)
            {
                switch (cnObject.Name.ToUpper())
                {
                    case "CSLDATE":
                        ((CnDataField)colCnObjects["CSLDATE"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate); 
                        break;
                    case "BIRTH":
                        ((CnDataField)colCnObjects["BIRTH"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.Birth);
                        break;
                    case "EDITCSLDATE":
                        ((CnDataField)colCnObjects["EDITCSLDATE"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);
                        break;
                    case "EDITBIRTH":
                        ((CnDataField)colCnObjects["EDITBIRTH"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.Birth); 
                        break;
                    default:
                        // アンダースコアでカラム名を分割
                        vntToken = cnObject.Name.Split('_');
                        lngTokenCount = vntToken.Count;
                        if (lngTokenCount >= 1) 
                        {
                            switch (PrintCommon.ExceptReplicationSign(vntToken[0]).ToUpper())
                            {
                                case "JUDRNAME":
                                    if ((lngTokenCount - 1) > 1)
                                    {
                                        if (objRepConsult.Histories.Item(vntToken[2]) != null)
                                        {
                                            dynamic rslData = SelectJudHistoryRsl(objRepConsult.Histories.Item(vntToken[2]).RsvNo, Convert.ToInt32(vntToken[1]), false);
                                            ((CnDataField)cnObject).Text = rslData.JUDRNAME;
                                        }
                                    }
                                    else
                                    { 
                                        dynamic rslData = SelectJudHistoryRsl(objRepConsult.RsvNo, Convert.ToInt32(vntToken[1]), true);
                                        ((CnDataField)cnObject).Text = rslData.JUDRNAME;
                                    }
                                break;
                            }
                        }
                        break;
                }
            }

            // グラフ基準線の出力
            // TODO
            // objCrForm.SetLine corLineSolid, 15, vbBlack
            Report6_2_GetPoint(0, 100, ref sngBaseX, ref sngBaseY);
            i = 1;
            while (!(i > ItemCount))
            { 
                if (i == 1) 
                {
                    Report6_2_GetPoint(ItemCount, 100, ref sngLastX, ref sngLastY);
                }
                Report6_2_GetPoint(i, 100, ref sngX, ref sngY);
                // TODO
                //objCrForm.DrawCrLine sngBaseX *100, sngBaseY * 100, sngX * 100, sngY * 100
                //objCrForm.DrawCrLine sngLastX *100, sngLastY * 100, sngX * 100, sngY * 100
                sngLastX = sngX;
                sngLastY = sngY;
                i = i + 1;
            }

            //検査結果を集計
            objHistory = objRepConsult.Histories.Item(1);
            blnLastGraphDraw = false;
            blnGraphDraw = false;
            i = 1;
            while (!(i > ItemCount))
            { 
                sngResult[i] = 0;
                sngLastResult[i] = 0;
                i = i + 1;
            }
            foreach (CnObject cnObject in colCnObjects)
            {
                // アンダースコアでカラム名を分割
                vntToken = cnObject.Name.Split('_');
                lngTokenCount = vntToken.Count;
                if (lngTokenCount == 3)
                {
                    if (vntToken[0] == "GRAPHITEM")
                    {
                        if (Double.TryParse(vntToken[1], out double wk))
                        {
                            lngIndex = Convert.ToInt32(vntToken[1]);
                            // 前回結果
                            if (null != objHistory)
                            {
                                objResult = objHistory.Results.Item(vntToken[2]);
                                if (null != objResult)
                                {
                                    if (Double.TryParse(objResult.Result, out double wk2))
                                    {
                                        sngLastResult[lngIndex] = Convert.ToInt32(objResult.Result);
                                        blnLastGraphDraw = true;
                                        blnLastResult[lngIndex] = true;
                                    }
                                }
                            }
                            // 今回
                            objResult = objRepConsult.Results.Item(vntToken[2]);
                            if (null != objResult)
                            {
                                if (Double.TryParse(objResult.Result, out double wk2))
                                {
                                    sngResult[lngIndex] = Convert.ToInt32(objResult.Result);
                                    blnGraphDraw = true;
                                    blnResult[lngIndex] = true;
                                }
                            }
                        }
                    }
                }
            }

            // 前回結果グラフを出力
            if (blnLastGraphDraw)
            {
                // 受診日を出力
                ((CnDataField)colCnObjects["GRAPHDATE2"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);
                objCnObject = colCnObjects["GRAPHCOLOR_2"];
                // TODO
                // objCnForm.SetLine objCrObject.LineStyle, objCrObject.LineWidth, objCrObject.LineColor
                i = 1;
                while (!(i > ItemCount))
                {
                    if (i == 1)
                    {
                        Report6_2_GetPoint(ItemCount, (PerfectScore - (sngLastResult[ItemCount] * sngLastResult[ItemCount])) / PerfectScore * 100, ref sngLastX, ref sngLastY);
                    }

                    Report6_2_GetPoint(i, (PerfectScore - (sngLastResult[i] * sngLastResult[i])) / PerfectScore * 100, ref sngX, ref sngY);

                    if (i == 1)
                    {
                        if (blnLastResult[ItemCount] && blnLastResult[i]) {
                            // TODO
                            // objCrForm.DrawCrLine sngLastX *100, sngLastY * 100, sngX * 100, sngY * 100
                        }
                    }
                    else
                    {
                        if (blnLastResult[i] && blnLastResult[i -1]) {
                            // TODO
                            // objCrForm.DrawCrLine sngLastX *100, sngLastY * 100, sngX * 100, sngY * 100
                        }
                    }

                    sngLastX = sngX;
                    sngLastY = sngY;
                    i = i + 1;
                }
            }

            // 今回結果グラフを出力
            // 受診日を出力
            ((CnDataField)colCnObjects["GRAPHDATE"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);
            if (blnGraphDraw)
            {
                objCnObject = colCnObjects["GRAPHCOLOR_1"];
                // objCrForm.SetLine objCrObject.LineStyle, objCrObject.LineWidth, objCrObject.LineColor
                i = 1;
                while (!(i > ItemCount))
                {
                    if (i == 1)
                    {
                        Report6_2_GetPoint(ItemCount, (PerfectScore - (sngResult[ItemCount] * sngResult[ItemCount])) / PerfectScore * 100, ref sngLastX, ref sngLastY);
                    }

                    Report6_2_GetPoint(i, (PerfectScore - (sngResult[i] * sngResult[i])) / PerfectScore * 100, ref sngX, ref sngY);
            
                    if (i == 1) 
                    {
                        if (blnResult[ItemCount] && blnResult[i])
                        {
                            // objCnForm.DrawCrLine sngLastX *100, sngLastY * 100, sngX * 100, sngY * 100
                        }
                    }
                    else
                    {
                        if (blnResult[i] && blnResult[i -1] ) 
                        {
                            // objCrForm.DrawCrLine sngLastX *100, sngLastY * 100, sngX * 100, sngY * 100
                        }
                    }

                    sngLastX = sngX;
                    sngLastY = sngY;
                    i = i + 1;
                }
            }

            // 総合判定コメント
            IList<dynamic> judCmtData = SelectJudCmt(objRepConsult.RsvNo, 1);
            if (judCmtData.Count > 0)
            {
                strJudCntStc = "";
                i = 0;
                while (!(i > (judCmtData.Count - 1)))
                {
                    strJudCntStc = strJudCntStc + judCmtData[i].JUDCMTSTC + Environment.NewLine;
                    i = i + 1;
                }

                // 指定団体グループ（花王）のとき、総合コメントを追加する処理
                bool blnOrgGrp2 = SelectOrgGrp(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_ORGGRP2);

                if (blnOrgGrp2)
                {
                    strJudCntStc = strJudCntStc + CMT_KAKO1 + Environment.NewLine;
                }

                // コメント２の追加
                bool blnOrgGrp3 = SelectOrgGrp(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_ORGGRP3);

                if (blnOrgGrp3) 
                {
                    strJudCntStc = strJudCntStc + CMT_KAKO2 + Environment.NewLine;
                }
            }

            // オプション血液検査が存在する場合コメントを自動で出力してくれる。
            if (CheckOptionComment(objRepConsult.RsvNo))
            {
                strJudCntStc = strJudCntStc + CMT_ADDKENSA + Environment.NewLine;
            }
            ((CnText)colCnObjects["TOTALCOMMENT"]).Text = strJudCntStc;

            // 生活指導事項
            IList<dynamic> jugCmtData = SelectJudCmt(objRepConsult.RsvNo, 2);
            if (jugCmtData.Count > 0 )
            {
                strJudCntStc = "";
                i = 0;
                while (!(i > (jugCmtData.Count - 1)))
                { 
                    strJudCntStc = strJudCntStc + jugCmtData[i].JUDCMTSTC + Environment.NewLine;
                    i = i + 1;
                }
                ((CnText)colCnObjects["JUGCMT"]).Text = strJudCntStc;
            }

            // 指定団体グループ以外の団体名・社員番号を非表示とする処理
            bool blnOrgGrp = SelectOrgGrp(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_ORGGRP);

            if (blnOrgGrp)
            {
                colCnObjects["LBLEMPNO"].Visible = true;
                colCnObjects["LBLORGNAME"].Visible = true;
                colCnObjects["EMPNO"].Visible = true;
                colCnObjects["ORGNAME"].Visible = true;
            } 
            else
            {
                colCnObjects["LBLEMPNO"].Visible = false;
                colCnObjects["LBLORGNAME"].Visible = false;
                colCnObjects["EMPNO"].Visible = false;
                colCnObjects["ORGNAME"].Visible = false;
            }

            bool blnOrgIns = SelectOrgIns(objRepConsult.OrgCd1, objRepConsult.OrgCd2);

            if (blnOrgIns)
            {
                colCnObjects["LBLISRSIGN"].Visible = true;
                colCnObjects["ISRSIGN"].Visible = true;
                colCnObjects["LBLISRNO"].Visible = true;
                colCnObjects["ISRNO"].Visible = true;
            }
            else 
            { 
                colCnObjects["LBLISRSIGN"].Visible = false;
                colCnObjects["ISRSIGN"].Visible = false;
                colCnObjects["LBLISRNO"].Visible = false;
                colCnObjects["ISRNO"].Visible = false;
            }
        }

        /// <summary>
        /// ６連成績書３枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6N320_3(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {
            CnObjects colCrObjects;                 // 描画オブジェクトのコレクション
            CnObject objCrObject;                   // 描画オブジェクト
            RepHistory objHistory;                  // 受診履歴クラス
            string vntLongStc;                      // 文章
            string[] vntToken;                      // トークン
            int lngTokenCount;                      //トークン数
            int lngRslCount;                        // 結果件数
            string strIKbn;                         // 胃区分
            string strSeq;                          // SEQ
            string strJudCd;
            string strJudRName;
            int i;
            short j;
            short k;
            int[,] JudSenketu = new int[4, 3]; // 便潜血判定用
            string[,] judLongStcCode = new string[4, 3]; // 便潜血判定用 
            string[] judPriCode = new string[3]; // 固定ロジック用
            string[] judResult = new string[4]; // 日付編集項目

            string[,] judAbnormalMark = new string[4, 3];            // 便潜血異常値マーク用


            //    描画オブジェクトコレクションの参照設定
            colCrObjects = cnForm.CnObjects;

            judLongStcCode[1, 1] = "LONGSTC_14322-00";
            judLongStcCode[2, 1] = "LONGSTC_14322-00_1";
            judLongStcCode[3, 1] = "LONGSTC_14322-00_2";
            judLongStcCode[1, 2] = "LONGSTC_14325-00";
            judLongStcCode[2, 2] = "LONGSTC_14325-00_1";
            judLongStcCode[3, 2] = "LONGSTC_14325-00_2";


            judAbnormalMark[1, 1] = "ABNORMALMARK_14322-00";
            judAbnormalMark[2, 1] = "ABNORMALMARK_14322-00_1";
            judAbnormalMark[3, 1] = "ABNORMALMARK_14322-00_2";
            judAbnormalMark[1, 2] = "ABNORMALMARK_14325-00";
            judAbnormalMark[2, 2] = "ABNORMALMARK_14325-00_1";
            judAbnormalMark[3, 2] = "ABNORMALMARK_14325-00_2";


            judPriCode[1] = "PRISHORTSTC_22180-01_22180-02_22180-03_22180-04_22180-05_22180-06_22180-07_22180-08_22180-09_22180-10";
            judPriCode[2] = "PRISHORTSTC_22160-01_22160-03_22160-05_22160-07_22160-09_22160-11";


            judResult[1] = "RESULT_23110-00";
            judResult[2] = "RESULT_23110-00_1";
            judResult[3] = "RESULT_23110-00_2";


            // 今回、前回、前々回受診情報
            // 今回        
            ((CnDataField)colCrObjects["EDITCSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
            dynamic IKbnName = SelectIKbnName(objRepConsult.RsvNo);

            ((CnDataField)colCrObjects["EDITCSNAME"]).Text = objRepConsult.CsName + Convert.ToString(IKbnName.NAME).Trim();
            ((CnDataField)colCrObjects["IKBN"]).Text = Convert.ToString(IKbnName.NAME).Trim();
            //  Ｘ線、内視鏡非表示処理
            colCrObjects[IBU_NAISIKYODATE].Visible = false;
            colCrObjects[IBU_NAISIKYOLABEL].Visible = false;
            colCrObjects[IBU_NAISIKYODATE + "_1"].Visible = false;
            colCrObjects[IBU_NAISIKYOLABEL + "_1"].Visible = false;
            colCrObjects[IBU_NAISIKYODATE + "_2"].Visible = false;
            colCrObjects[IBU_NAISIKYOLABEL + "_2"].Visible = false;

            switch (IKbnName.SEQ)
            {
                case "2":
                    colCrObjects[IBU_NAISIKYODATE].Visible = true;
                    colCrObjects[IBU_NAISIKYOLABEL].Visible = true;
                    break;
            }

            //   前回
            objHistory = objRepConsult.Histories.Item(1);

            if (objHistory != null)
            {
                ((CnDataField)colCrObjects["EDITCSLDATE_1"]).Text = string.Format("{0:YYYY年M月D日}", objHistory.CslDate);
                IKbnName = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCrObjects["EDITCSNAME_1"]).Text = objHistory.CsName + Convert.ToString(IKbnName.NAME).Trim();
                ((CnDataField)colCrObjects["IKBN_1"]).Text = Convert.ToString(IKbnName.NAME).Trim();
                // Ｘ線、内視鏡非表示処理
                switch (IKbnName.SEQ)
                {
                    case "2":
                        colCrObjects[IBU_NAISIKYODATE + "_1"].Visible = true;
                        colCrObjects[IBU_NAISIKYOLABEL + "_1"].Visible = true;
                        break;
                }
            }

            //  前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (objHistory != null)
            {
                ((CnDataField)colCrObjects["EDITCSLDATE_2"]).Text = string.Format("{0:YYYY年M月D日}", objHistory.CslDate);
                IKbnName = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCrObjects["EDITCSLDATE_2"]).Text = objHistory.CsName + Convert.ToString(IKbnName.NAME).Trim();
                ((CnDataField)colCrObjects["IKBN_2"]).Text = Convert.ToString(IKbnName.NAME).Trim();
                // Ｘ線、内視鏡非表示処理
                switch (IKbnName.SEQ)
                {
                    case "2":
                        colCrObjects[IBU_NAISIKYODATE + "_2"].Visible = true;
                        colCrObjects[IBU_NAISIKYOLABEL + "_2"].Visible = true;
                        break;
                }
            }


            //  上部消化管
            //  今回
            IList<dynamic> lngRsl = SelectStc_2nd(objRepConsult.RsvNo, GRPCD_JYOUBU);

            if (lngRsl.Count > 0)
            {
                objCrObject = colCrObjects["JYOUBU"];
                j = 0;
                i = 0;
                while (!((i > (lngRsl.Count - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                {

                    if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(0, j, lngRsl[i].LONGSTC.Trim());
                        j++;
                    }
                    i++;
                }
                j = 0;
                i = 0;
                k = 0;
                while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                {

                    if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                        j++;
                        if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                        {
                            j = 0;
                            k++;
                        }
                    }
                    i++;
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);

            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd(objHistory.RsvNo, GRPCD_JYOUBU);

                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["JYOUBU1"];
                    j = 0;
                    i = 0;
                    while (!((i > (data.Count - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                    {

                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(0, j, data[i].LONGSTC.Trim());
                            j++;
                        }
                        i++;
                    }
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {

                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd(objHistory.RsvNo, GRPCD_JYOUBU);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["JYOUBU2"];
                    j = 0;
                    i = 0;
                    while (!((i > (data.Count - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(0, j, data[i].LONGSTC.Trim());
                            j++;
                        }
                        i++;
                    }
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // ## 上腹部超音波 ##########
            // 今回
            lngRsl = SelectStc_2nd(objRepConsult.RsvNo, GRPCD_ECHO);
            if (lngRsl.Count > 0)
            {
                objCrObject = colCrObjects["ECHO"];
                j = 0;
                i = 0;
                while (!((i > (lngRsl.Count - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                {

                    if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(0, j, lngRsl[i].LONGSTC.Trim());
                        j++;
                    }
                    i++;
                }
                j = 0;
                i = 0;
                k = 0;
                while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                {

                    if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                        j++;
                        if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                        {
                            j = 0;
                            k++;
                        }
                    }
                    i++;
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd(objHistory.RsvNo, GRPCD_ECHO);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["ECHO_1"];
                    j = 0;
                    i = 0;
                    while (!((i > (data.Count - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(0, j, data[i].LONGSTC.Trim());
                            j++;
                        }
                        i++;
                    }
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd(objHistory.RsvNo, GRPCD_ECHO);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["ECHO2"];
                    j = 0;
                    i = 0;
                    while (!((i > (data.Count - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(0, j, data[i].LONGSTC.Trim());
                            j++;
                        }
                        i++;
                    }
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 胸部Ｘ線
            // 今回
            lngRsl = SelectStc_2nd(objRepConsult.RsvNo, GRPCD_KYOUBU_X);
            if (lngRsl.Count > 0)
            {
                objCrObject = colCrObjects["KYOUBUX"];
                j = 0;
                i = 0;
                k = 0;
                while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                {

                    if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                        j++;
                        if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                        {
                            j = 0;
                            k++;
                        }
                    }
                    i++;
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd(objHistory.RsvNo, GRPCD_KYOUBU_X);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["KYOUBUX1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd(objHistory.RsvNo, GRPCD_KYOUBU_X);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["KYOUBUX2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // On Error Resume Next
            // 便潜血判定
            // 障害対応 -> 表示制御のクリアを行う

            for (i = 1; i <= 3; i++)
            {
                colCrObjects[judLongStcCode[i, 1]].Visible = true;
                colCrObjects[judLongStcCode[i, 2]].Visible = true;
                switch (Strings.StrConv(((CnDataField)colCrObjects[judLongStcCode[i, 1]]).Text, VbStrConv.Wide))
                {
                    case "検査せず":
                        JudSenketu[i, 1] = 1;
                        break;
                    case "（－）":
                        JudSenketu[i, 1] = 2;
                        break;
                    case "（＋－）":
                        JudSenketu[i, 1] = 3;
                        break;
                    case "（＋）":
                        JudSenketu[i, 1] = 4;
                        break;
                    case "（２＋）":
                        JudSenketu[i, 1] = 5;
                        break;
                    default:
                        JudSenketu[i, 1] = 0;
                        break;

                }
                switch (Strings.StrConv(((CnDataField)colCrObjects[judLongStcCode[i, 2]]).Text, VbStrConv.Wide))
                {
                    case "検査せず":
                        JudSenketu[i, 2] = 1;
                        break;
                    case "（－）":
                        JudSenketu[i, 2] = 2;
                        break;
                    case "（＋－）":
                        JudSenketu[i, 2] = 3;
                        break;
                    case "（＋）":
                        JudSenketu[i, 2] = 4;
                        break;
                    case "（２＋）":
                        JudSenketu[i, 2] = 5;
                        break;
                    default:
                        JudSenketu[i, 2] = 0;
                        break;

                }
                if (JudSenketu[i, 1] < JudSenketu[i, 2])
                {
                    colCrObjects[judLongStcCode[i, 1]].Visible = false;
                }
                else
                {
                    colCrObjects[judLongStcCode[i, 2]].Visible = false;
                }
                colCrObjects[judAbnormalMark[i, 1]].Visible = colCrObjects[judLongStcCode[i, 1]].Visible;
                colCrObjects[judAbnormalMark[i, 2]].Visible = colCrObjects[judLongStcCode[i, 2]].Visible;
            }

            // On Error GoTo 0

            foreach (CnObject rec in colCrObjects)
            {
                switch (rec.Name.ToUpper())
                {
                    case "CSLDATE":
                        ((CnDataField)colCrObjects["CSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "CSLDATEM":
                        ((CnDataField)colCrObjects["CSLDATEM"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "BIRTH":
                        ((CnDataField)colCrObjects["BIRTH"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.Birth);
                        break;
                    case "EDITCSLDATE":
                        ((CnDataField)colCrObjects["EDITCSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.Birth);
                        break;
                    case "EDITCSLDATEM":
                        ((CnDataField)colCrObjects["EDITCSLDATEM"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.Birth);
                        break;
                    case "EDITBIRTH":
                        ((CnDataField)colCrObjects["EDITBIRTH"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.Birth);
                        break;
                    case "ECHO1":
                        string leftStr = ((CnListField)colCrObjects["ECHO1"]).ListText(0, 0);
                        leftStr = leftStr.Substring(0, 1);
                        if ("*".Equals(Strings.StrConv(leftStr, VbStrConv.Narrow)))
                        {
                            ((CnListField)colCrObjects["ECHO1"]).ListText(0, 0, "");
                        }
                        break;
                    case "ECHO2":
                        string leftStr2 = ((CnListField)colCrObjects["ECHO2"]).ListText(0, 0);
                        leftStr2 = leftStr2.Substring(0, 1);
                        if ("*".Equals(Strings.StrConv(leftStr2, VbStrConv.Narrow)))
                        {
                            ((CnListField)colCrObjects["ECHO2"]).ListText(0, 0, "");
                        }
                        break;
                    default:
                        // アンダースコアでカラム名を分割
                        vntToken = rec.Name.Split('_');
                        lngTokenCount = vntToken.Length;
                        if (lngTokenCount >= 1)
                        {
                            switch (PrintCommon.ExceptReplicationSign(vntToken[0]).ToUpper())
                            {
                                case "PRISHORTSTC":
                                    string rightStr = rec.Name.TrimEnd();
                                    rightStr = rightStr.Substring(rightStr.Length - 2, 2);
                                    if ("_1".Equals(rightStr) || "_2".Equals(rightStr))
                                    {
                                        if ("*".Equals(Strings.StrConv(((CnListField)rec).ListText(0, 0).Substring(0, 1), VbStrConv.Narrow)))
                                        {
                                            ((CnListField)rec).ListText(0, 0, "");
                                        }
                                    }
                                    break;
                                case "SHORTSTC":
                                case "LONGSTC":
                                    rightStr = rec.Name.TrimEnd();
                                    rightStr = rightStr.Substring(rightStr.Length - 2, 2);
                                    if ("_1".Equals(rightStr) || "_2".Equals(rightStr))
                                    {
                                        if ("*".Equals(Strings.StrConv(((CnDataField)rec).Text.Substring(0, 1), VbStrConv.Narrow)))
                                        {
                                            ((CnDataField)rec).Text = "";
                                        }
                                    }
                                    break;
                                case "RESULT":
                                    rightStr = rec.Name.TrimEnd();
                                    rightStr = rightStr.Substring(rightStr.Length - 2, 2);
                                    if ("_1".Equals(rightStr) || "_2".Equals(rightStr))
                                    {
                                        if ("*".Equals(Strings.StrConv(((CnDataField)rec).Text.Substring(0, 1), VbStrConv.Narrow)))
                                        {
                                            ((CnDataField)rec).Text = "";
                                        }
                                        for (i=1;i<= judResult.Length;i++)
                                        {
                                            if (rec.Name.Equals(judResult[i]))
                                            {
                                                ((CnDataField)rec).Text = string.Format("{0:YYYY年M月D日}", DateTime.ParseExact(((CnDataField)rec).Text, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture));
                                            }
                                        }
                                    }
                                    break;
                                case "JUDRNAME":
                                    if (Convert.ToInt16(vntToken[1]) >= 1 && Convert.ToInt16(vntToken[1]) <= 28)
                                    {
                                        if (vntToken.Length - 1 <= 1)
                                        {
                                            dynamic data = SelectJudHistoryRsl(objRepConsult.RsvNo, Convert.ToInt16(vntToken[1]), true);
                                            ((CnDataField)rec).Text = data.JUDRNAME;
                                            if (("＊＊").Equals(data.JUDRNAME.ToUpper()))
                                            {
                                                switch (Convert.ToInt16(vntToken[1]))
                                                {
                                                    case 1:
                                                        ((CnListField)colCrObjects[judPriCode[1]]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 4:
                                                        ((CnListField)colCrObjects[judPriCode[2]]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 5:
                                                        ((CnDataField)colCrObjects["RESULT_13020-00"]).Text = "********";
                                                        ((CnDataField)colCrObjects["RESULT_13022-00"]).Text = "********";
                                                        ((CnDataField)colCrObjects["RESULT_13023-00"]).Text = "********";
                                                        ((CnDataField)colCrObjects["RESULT_13024-00"]).Text = "********";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13020-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13022-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13023-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13024-00"]).Text = "";
                                                        break;
                                                    case 6:
                                                        ((CnListField)colCrObjects["KYOUBUX"]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 7:
                                                        ((CnListField)colCrObjects["JYOUBU"]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 8:
                                                        ((CnDataField)colCrObjects["LONGSTC_14322-00"]).Text = "＊＊＊＊＊";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_14322-00"]).Text = "";
                                                        break;
                                                    case 9:
                                                        ((CnListField)colCrObjects["ECHO"]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                }
                                            }

                                            if (("－－").Equals(data.JUDRNAME.ToUpper()))
                                            {
                                                switch (Convert.ToInt16(vntToken[1]))
                                                {
                                                    case 1:
                                                        ((CnListField)colCrObjects[judPriCode[1]]).ListText(0, 0, "検査せず");
                                                        break;
                                                    case 4:
                                                        ((CnListField)colCrObjects[judPriCode[2]]).ListText(0, 0, "検査せず");
                                                        break;
                                                    case 5:
                                                        ((CnDataField)colCrObjects["RESULT_13020-00"]).Text = "--------";
                                                        ((CnDataField)colCrObjects["RESULT_13022-00"]).Text = "--------";
                                                        ((CnDataField)colCrObjects["RESULT_13023-00"]).Text = "--------";
                                                        ((CnDataField)colCrObjects["RESULT_13024-00"]).Text = "--------";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13020-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13022-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13023-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13024-00"]).Text = "";
                                                        break;
                                                    case 6:
                                                        ((CnListField)colCrObjects["KYOUBUX"]).ListText(0, 0, "検査せず");
                                                        break;
                                                    case 7:
                                                        ((CnListField)colCrObjects["JYOUBU"]).ListText(0, 0, "検査せず");
                                                        break;
                                                    case 8:
                                                        ((CnDataField)colCrObjects["LONGSTC_14322-00"]).Text = "検査せず";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_14322-00"]).Text = "";
                                                        break;
                                                    case 9:
                                                        ((CnListField)colCrObjects["ECHO"]).ListText(0, 0, "検査せず");
                                                        break;
                                                }
                                            }
                                        }
                                    }
                                    break;
                            }
                        }
                        break;

                }
            }

            colCrObjects["JUDRNAME_1"].Visible = false;
            colCrObjects["JUDRNAME_2"].Visible = false;
            colCrObjects["JUDRNAME_3"].Visible = false;
            colCrObjects["JUDRNAME_4"].Visible = false;
            colCrObjects["JUDRNAME_5"].Visible = false;
            colCrObjects["JUDRNAME_6"].Visible = false;
            colCrObjects["JUDRNAME_7"].Visible = false;
            colCrObjects["JUDRNAME_8"].Visible = false;
            colCrObjects["JUDRNAME_9"].Visible = false;
            colCrObjects["JUDRNAME_10"].Visible = false;

            //  指定団体グループ以外の団体名・社員番号を非表示とする処理
            Boolean blnOrgGrp = SelectOrgGrp(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_ORGGRP);
            if (blnOrgGrp)
            {
                colCrObjects["LBLEMPNO"].Visible = true;
                colCrObjects["LBLORGNAME"].Visible = true;
                colCrObjects["EMPNO"].Visible = true;
                colCrObjects["ORGNAME"].Visible = true;
            }
            else
            {
                colCrObjects["LBLEMPNO"].Visible = false;
                colCrObjects["LBLORGNAME"].Visible = false;
                colCrObjects["EMPNO"].Visible = false;
                colCrObjects["ORGNAME"].Visible = false;
            }

            // 指定団体の成績表に保険証記号、番号を出力有無チェック Start
            Boolean blnOrgIns = SelectOrgIns(objRepConsult.OrgCd1, objRepConsult.OrgCd2);
            if (blnOrgIns)
            {
                colCrObjects["LBLISRSIGN"].Visible = true;
                colCrObjects["ISRSIGN"].Visible = true;
                colCrObjects["LBLISRNO"].Visible = true;
                colCrObjects["ISRNO"].Visible = true;
            }
            else
            {
                colCrObjects["LBLISRSIGN"].Visible = false;
                colCrObjects["ISRSIGN"].Visible = false;
                colCrObjects["LBLISRNO"].Visible = false;
                colCrObjects["ISRNO"].Visible = false;
            }
        }

        /// <summary>
        /// ６連成績書４枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6N320_4(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書４枚目の編集　2011.01.01版対応
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6N320_4_2011(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

            CnObjects colCrObjects;                        // 描画オブジェクトのコレクション
            RepHistory objHistory;                         // 受診履歴クラス
            String strIKbn;                                // 胃区分12
            CnObject objCrObject;                          // 描画オブジェクト
            string[] vntToken;                             // トークン
            int lngTokenCount;                             // トークン数
            CnObject objCrObject1;                         // 描画オブジェクト

            string vntLongStc;                             // 文章
            int lngRslCount;                               // 結果件数
            String strSeq;                                 // SEQ
            String strJudCd;
            String strJudRName;
            String strCrObjName;
            string[] abnormalMarkShortCode = new string[4];
            string[] abnormalMarkResultCode = new string[2];
            int i;
            short j;
            short k;

            string[] judShortCode = new string[4];

            string[] judResultCode = new string[2];

            //    描画オブジェクトコレクションの参照設定
            colCrObjects = cnForm.CnObjects;

            colCrObjects["Line200"].Visible = false;
            judShortCode[1] = "SHORTSTC_12050-00";
            judShortCode[2] = "SHORTSTC_12060-00";
            judShortCode[3] = "SHORTSTC_12070-00";
            judShortCode[4] = "SHORTSTC_12080-00";

            judResultCode[1] = "RESULT_16324-00";
            judResultCode[2] = "RESULT_14028-00";

            abnormalMarkShortCode[1] = "ABNORMALMARK_12050-00";
            abnormalMarkShortCode[2] = "ABNORMALMARK_12060-00";
            abnormalMarkShortCode[3] = "ABNORMALMARK_12070-00";
            abnormalMarkShortCode[4] = "ABNORMALMARK_12080-00";
            abnormalMarkResultCode[1] = "ABNORMALMARK_16324-00";
            abnormalMarkResultCode[2] = "ABNORMALMARK_14028-00";
            foreach (CnObject rec in colCrObjects)
            {
                switch (rec.Name.ToUpper())
                {
                    case "CSLDATE":
                        ((CnDataField)colCrObjects["CSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "CSLDATEM":
                        ((CnDataField)colCrObjects["CSLDATEM"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "BIRTH":
                        ((CnDataField)colCrObjects["BIRTH"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.Birth);
                        break;
                    case "EDITCSLDATE":
                        ((CnDataField)colCrObjects["EDITCSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "EDITCSLDATEM":
                        ((CnDataField)colCrObjects["EDITCSLDATEM"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "EDITBIRTH":
                        ((CnDataField)colCrObjects["EDITBIRTH"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.Birth);
                        break;
                    case "RESULT_16325-00":// 血清学（ＲＦ）
                        ((CnDataField)colCrObjects["RESULT_16325-00"]).Text = SelectStc_RF(objRepConsult.RsvNo, "16325", "00", 0, 1);
                        break;
                    case "RESULT_16325-00_1":// 血清学（ＲＦ－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_16325-00_1"]).Text = SelectStc_RF(objRepConsult.RsvNo, "16325", "00", 1, 1);
                        }
                        break;
                    case "RESULT_16325-00_2":// 血清学（ＲＦ－前々回）
                        objHistory = objRepConsult.Histories.Item(2);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_16325-00_2"]).Text = SelectStc_RF(objRepConsult.RsvNo, "16325", "00", 2, 1);
                        }
                        break;
                    case "RESULT_11020-01":// 視力（裸眼／右）
                        ((CnDataField)colCrObjects["RESULT_11020-01"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "01", 0, 1);
                        break;
                    case "RESULT_11020-01_1":// 視力（裸眼／右－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11020-01_1"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "01", 1, 1);
                        }
                        break;
                    case "RESULT_11020-01_2":// 視力（裸眼／右－前々回）
                        objHistory = objRepConsult.Histories.Item(2);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11020-01_2"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "01", 2, 1);
                        }
                        break;
                    case "RESULT_11020-02":// 視力（裸眼／左）
                        ((CnDataField)colCrObjects["RESULT_11020-02"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "02", 0, 1);
                        break;
                    case "RESULT_11020-02_1":// 視力（裸眼／左－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11020-02_1"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "02", 1, 1);
                        }
                        break;
                    case "RESULT_11020-02_2":// 視力（裸眼／左－前々回）
                        objHistory = objRepConsult.Histories.Item(2);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11020-02_2"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "02", 2, 1);
                        }
                        break;
                    case "RESULT_11022-01":// 視力（矯正／右）
                        ((CnDataField)colCrObjects["RESULT_11022-01"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "01", 0, 1);
                        break;
                    case "RESULT_11022-01_1":// 視力（矯正／右－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11022-01_1"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "01", 1, 1);
                        }
                        break;
                    case "RESULT_11022-01_2":// 視力（矯正／右－前々回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11022-01_2"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "01", 2, 1);
                        }
                        break;
                    case "RESULT_11022-02":// 視力（矯正／左）
                        ((CnDataField)colCrObjects["RESULT_11022-02"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "02", 0, 1);
                        break;
                    case "RESULT_11022-02_1":// （矯正／左－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11022-02_1"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "02", 1, 1);
                        }
                        break;
                    case "RESULT_11022-02_2":// 視力（矯正／左－前々回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11022-02_2"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "02", 2, 1);
                        }
                        break;
                    default:
                        // アンダースコアでカラム名を分割
                        vntToken = rec.Name.Split('_');
                        lngTokenCount = vntToken.Length;
                        if (lngTokenCount >= 1)
                        {
                            string rightStr = "";
                            switch (PrintCommon.ExceptReplicationSign(vntToken[0]).ToUpper())
                            {
                                case "RESULT":
                                case "SHORTSTC":
                                case "LONGSTC":
                                    rightStr = rec.Name.TrimEnd();
                                    rightStr = rightStr.Substring(rightStr.Length - 2, 2);
                                    if ("_1".Equals(rightStr) || "_2".Equals(rightStr))
                                    {
                                        if ("*".Equals(Strings.StrConv(((CnDataField)rec).Text.Substring(0, 1), VbStrConv.Narrow)))
                                        {
                                            ((CnDataField)rec).Text = "";
                                            ((CnDataField)colCrObjects[rec.Name.Replace(vntToken[0], "ABNORMALMARK")]).Text = "";
                                        }
                                    }
                                    break;
                                case "PRISHORTSTC":
                                    rightStr = rec.Name.TrimEnd();
                                    rightStr = rightStr.Substring(rightStr.Length - 2, 2);
                                    if ("_1".Equals(rightStr) || "_2".Equals(rightStr))
                                    {
                                        if ("*".Equals(Strings.StrConv(((CnListField)rec).ListText(0, 0).Substring(0, 1), VbStrConv.Narrow)))
                                        {
                                            ((CnListField)rec).ListText(0, 0, "");
                                        }
                                    }
                                    break;
                                case "JUDRNAME":
                                    if (Convert.ToInt16(vntToken[1]) >= 1 && Convert.ToInt16(vntToken[1]) <= 31)
                                    {
                                        if (vntToken.Length - 1 <= 1)
                                        {
                                            dynamic data = SelectJudHistoryRsl(objRepConsult.RsvNo, Convert.ToInt16(vntToken[1]), true);
                                            ((CnDataField)rec).Text = data.JUDRNAME;
                                            if (("＊＊").Equals(data.JUDRNAME.ToUpper()))
                                            {
                                                switch (Convert.ToInt16(vntToken[1]))
                                                {
                                                    case 18:
                                                        ((CnListField)colCrObjects[judResultCode[1]]).Text = "********";
                                                        ((CnListField)colCrObjects[abnormalMarkResultCode[1]]).Text = "";
                                                        break;
                                                    case 19:
                                                        ((CnListField)colCrObjects[judResultCode[2]]).Text = "********";
                                                        ((CnListField)colCrObjects[abnormalMarkResultCode[2]]).Text = "";
                                                        break;
                                                    case 21:
                                                        ((CnListField)colCrObjects["SHORTSTC_11176-00"]).Text = "＊＊＊＊＊";
                                                        ((CnListField)colCrObjects["SHORTSTC_11175-00"]).Text = "＊＊＊＊＊";
                                                        ((CnListField)colCrObjects["ABNORMALMARK_11176-00"]).Text = "";
                                                        ((CnListField)colCrObjects["ABNORMALMARK_11175-00"]).Text = "";
                                                        ((CnListField)colCrObjects["SHORTSTC_11530-00"]).Text = "＊＊＊＊＊";
                                                        break;
                                                    case 22:
                                                        ((CnListField)colCrObjects[judShortCode[1]]).Text = "＊＊＊＊＊";
                                                        ((CnListField)colCrObjects[judShortCode[2]]).Text = "＊＊＊＊＊";
                                                        ((CnListField)colCrObjects[judShortCode[3]]).Text = "＊＊＊＊＊";
                                                        ((CnListField)colCrObjects[judShortCode[4]]).Text = "＊＊＊＊＊";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[1]]).Text = "";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[2]]).Text = "";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[3]]).Text = "";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[4]]).Text = "";
                                                        break;
                                                }
                                            }
                                            if (("－－").Equals(data.JUDRNAME.ToUpper()))
                                            {
                                                switch (Convert.ToInt16(vntToken[1]))
                                                {
                                                    case 18:
                                                        ((CnListField)colCrObjects[judResultCode[1]]).Text = "検査せず";
                                                        ((CnListField)colCrObjects[abnormalMarkResultCode[1]]).Text = "";
                                                        break;
                                                    case 19:
                                                        ((CnListField)colCrObjects[judResultCode[2]]).Text = "検査せず";
                                                        ((CnListField)colCrObjects[abnormalMarkResultCode[2]]).Text = "";
                                                        break;
                                                    case 21:
                                                        ((CnListField)colCrObjects["SHORTSTC_11176-00"]).Text = "--------";
                                                        ((CnListField)colCrObjects["SHORTSTC_11175-00"]).Text = "--------";
                                                        ((CnListField)colCrObjects["ABNORMALMARK_11176-00"]).Text = "";
                                                        ((CnListField)colCrObjects["ABNORMALMARK_11175-00"]).Text = "";
                                                        ((CnListField)colCrObjects["SHORTSTC_11530-00"]).Text = "検査せず";
                                                        break;
                                                    case 22:
                                                        ((CnListField)colCrObjects[judShortCode[1]]).Text = "検査せず";
                                                        ((CnListField)colCrObjects[judShortCode[2]]).Text = "検査せず";
                                                        ((CnListField)colCrObjects[judShortCode[3]]).Text = "検査せず";
                                                        ((CnListField)colCrObjects[judShortCode[4]]).Text = "検査せず";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[1]]).Text = "";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[2]]).Text = "";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[3]]).Text = "";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[4]]).Text = "";
                                                        break;
                                                    case 28:
                                                        ((CnListField)colCrObjects["RESULT_18426-00"]).Text = "--------";
                                                        ((CnListField)colCrObjects["RESULT_18425-00"]).Text = "--------";
                                                        ((CnListField)colCrObjects["ABNORMALMARK_18426-00"]).Text = "";
                                                        ((CnListField)colCrObjects["ABNORMALMARK_18425-00"]).Text = "";
                                                        break;
                                                }
                                            }
                                        }
                                    }
                                    break;
                            }
                        }
                        break;

                }

                // 関西テレビ放送東京支社春期（ＣＥＡ有CHEST無）場合、
                // TSH、FT4をオプション項目に出力する。
                strCrObjName = (rec.Name).ToUpper();
                if (objRepConsult.OrgCd1.Equals("06035") && objRepConsult.OrgCd2.Equals("00006"))
                {
                    switch (strCrObjName)
                    {
                        case "RESULT_18426-00":
                            ((CnListField)colCrObjects[strCrObjName]).Text = "＊＊＊＊＊";
                            ((CnListField)colCrObjects["ABNORMALMARK_18426 - 00"]).Text = "";
                            break;
                        case "RESULT_18425-00":
                            ((CnListField)colCrObjects[strCrObjName]).Text = "＊＊＊＊＊";
                            ((CnListField)colCrObjects["ABNORMALMARK_18425-00"]).Text = "";
                            break;
                        case "RESULT_18426-00_1":
                            ((CnListField)colCrObjects[strCrObjName]).Text = "";
                            ((CnListField)colCrObjects["ABNORMALMARK_18426-00_1"]).Text = "";
                            break;
                        case "RESULT_18425-00_1":
                            ((CnListField)colCrObjects[strCrObjName]).Text = "";
                            ((CnListField)colCrObjects["ABNORMALMARK_18425-00_1"]).Text = "";
                            break;
                        case "RESULT_18426-00_2":
                            ((CnListField)colCrObjects[strCrObjName]).Text = "";
                            ((CnListField)colCrObjects["ABNORMALMARK_18426-00_2"]).Text = "";
                            break;
                        case "RESULT_18425-00_2":
                            ((CnListField)colCrObjects[strCrObjName]).Text = "";
                            ((CnListField)colCrObjects["ABNORMALMARK_18425-00_2"]).Text = "";
                            break;
                    }
                }
            }

            // 今回、前回、前々回受診情報
            // 今回
            ((CnDataField)colCrObjects["EDITCSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
            dynamic IKbnName = SelectIKbnName(objRepConsult.RsvNo);
            ((CnDataField)colCrObjects["EDITCSNAME"]).Text = objRepConsult.CsName + Convert.ToString(IKbnName.NAME).Trim();
            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (objHistory != null)
            {
                ((CnDataField)colCrObjects["EDITCSLDATE_1"]).Text = string.Format("{0:YYYY年M月D日}", objHistory.CslDate);
                IKbnName = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCrObjects["EDITCSNAME_1"]).Text = objHistory.CsName + Convert.ToString(IKbnName.NAME).Trim();
            }

            //  前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (objHistory != null)
            {
                ((CnDataField)colCrObjects["EDITCSLDATE_2"]).Text = string.Format("{0:YYYY年M月D日}", objHistory.CslDate);
                IKbnName = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCrObjects["EDITCSNAME_2"]).Text = objHistory.CsName + Convert.ToString(IKbnName.NAME).Trim();
            }

            // 乳房視触診
            // 今回
            objCrObject = colCrObjects["HUJINKA_NYUBOUS"];
            dynamic data2 = SelectJudHistoryRsl(objRepConsult.RsvNo, 54, true);
            switch (Convert.ToInt16(data2.JUDRNAME))
            {
                case "＊＊":
                    ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
                    break;
                case "－－":
                    ((CnListField)objCrObject).ListText(0, 0, "検査せず");
                    break;
                default:
                    j = 0;
                    IList<dynamic> lngRsl = SelectStc(objRepConsult.RsvNo, GRPCD_NYUBOUS);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }

                    }
                    break;
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd(objHistory.RsvNo, GRPCD_NYUBOUS);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_NYUBOUS1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd(objHistory.RsvNo, GRPCD_NYUBOUS);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_NYUBOUS2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }


            // -------------1.婦人科(頚部細胞診-診断) ----------------------------------------
            // 今回
            objCrObject = colCrObjects["HUJINKA_KEIBU"];
            if (((CnDataField)colCrObjects["JUDRNAME_31"]).Text.Equals("＊＊"))
            {
                ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
            }
            else
            {
                if (((CnDataField)colCrObjects["JUDRNAME_31"]).Text.Equals("－－"))
                {
                    ((CnListField)objCrObject).ListText(0, 0, "検査せず");
                }
                else
                {
                    IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objRepConsult.RsvNo, FU_SINDAN_CODE, FU_FCLASS_KEBU);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }
                        if (lngRslCount > 2)
                        {
                            colCrObjects["Line207"].Visible = true;
                        }
                    }
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_SINDAN_CODE, FU_FCLASS_KEBU);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_KEIBU1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                    if (lngRslCount > 2)
                    {
                        colCrObjects["Line207"].Visible = true;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_SINDAN_CODE, FU_FCLASS_KEBU);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_KEIBU2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                    if (lngRslCount > 2)
                    {
                        colCrObjects["Line207"].Visible = true;
                    }
                }
            }

            // -------------2.婦人科(ベセスダ分類) ----------------------------------------
            // 婦人科ベセスダ分類表記変更に伴うシステム変更 STR ###
            // 今回
            objCrObject = colCrObjects["HUJINKA_BETHESDA"];
            objCrObject1 = colCrObjects["HUJINKA_BETHESDA_RPT"];
            if (((CnDataField)colCrObjects["JUDRNAME_31"]).Text.Equals("＊＊"))
            {
                ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
                ((CnListField)objCrObject1).ListText(0, 0, "＊＊＊＊＊");
            }
            else
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objRepConsult.RsvNo, FU_BETHE_CODE, "");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].SHORTSTC.Trim());
                            ((CnListField)objCrObject1).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }

                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_BETHE_CODE, "");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_BETHESDA1"];
                    objCrObject1 = colCrObjects["HUJINKA_BETHESDA_RPT1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].SHORTSTC.Trim());
                            ((CnListField)objCrObject1).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_BETHE_CODE, "");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_BETHESDA2"];
                    objCrObject1 = colCrObjects["HUJINKA_BETHESDA_RPT2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].SHORTSTC.Trim());
                            ((CnListField)objCrObject1).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 婦人科ベセスダ分類表記変更に伴うシステム変更 END ###

            // -------------2.婦人科(クラス分類) ----------------------------------------
            // 今回
            objCrObject = colCrObjects["HUJINKA_CLASS"];
            if (((CnDataField)colCrObjects["JUDRNAME_31"]).Text.Equals("＊＊"))
            {
                ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
            }
            else
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objRepConsult.RsvNo, FU_CLASS_CODE, FU_FCLASS_CLASS);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_CLASS_CODE, FU_FCLASS_CLASS);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_CLASS1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_CLASS_CODE, FU_FCLASS_CLASS);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_CLASS2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // ------------- 婦人科(内診所見) ----------------------------------------------
            // 今回
            objCrObject = colCrObjects["HUJINKA_NASHOKEN"];
            if (((CnDataField)colCrObjects["JUDRNAME_30"]).Text.Equals("＊＊"))
            {
                ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
            }
            else
            {
                if (((CnDataField)colCrObjects["JUDRNAME_30"]).Text.Equals("－－"))
                {
                    ((CnListField)objCrObject).ListText(0, 0, "検査せず");
                }
                else
                {
                    IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objRepConsult.RsvNo, FU_NAISIN_CODE, "");
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }
                        if (lngRslCount > 3)
                        {
                            colCrObjects["Line200"].Visible = true;
                        }
                    }

                }

            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_NAISIN_CODE, "");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_NASHOKEN1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                    if (lngRslCount > 3)
                    {
                        colCrObjects["Line200"].Visible = true;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_NAISIN_CODE, "");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_NASHOKEN2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                    if (lngRslCount > 3)
                    {
                        colCrObjects["Line200"].Visible = true;
                    }
                }
            }


            // -------------( 婦人科内診-診断 )----------------------------------------
            // 今回
            objCrObject = colCrObjects["HUJINKA_NAISIN"];
            if (((CnDataField)colCrObjects["JUDRNAME_30"]).Text.Equals("＊＊"))
            {
                ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
            }
            else
            {
                if (((CnDataField)colCrObjects["JUDRNAME_30"]).Text.Equals("－－"))
                {
                    ((CnListField)objCrObject).ListText(0, 0, "検査せず");
                }
                else
                {
                    IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objRepConsult.RsvNo, FU_SINDAN_CODE, "NAISIN");
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }
                    }
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_SINDAN_CODE, "NAISIN");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_NAISIN1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_SINDAN_CODE, "NAISIN");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_NAISIN2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 婦人科(乳房Ｘ線検査)
            objCrObject = colCrObjects["HUJINKA_NYUBOUX"];
            data2 = SelectJudHistoryRsl(objRepConsult.RsvNo, 55, true);
            switch (Convert.ToInt16(data2.JUDRNAME))
            {
                case "＊＊":
                    ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
                    break;
                case "－－":
                    ((CnListField)objCrObject).ListText(0, 0, "検査せず");
                    break;
                default:
                    j = 0;
                    IList<dynamic> lngRsl = SelectStc(objRepConsult.RsvNo, GRPCD_NYUBOUX);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        i = 0;
                        while (!((i > (lngRslCount - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(0, j, lngRsl[i].LONGSTC.Trim());
                                j++;
                            }
                            i++;
                        }
                    }
                    break;
            }

            // 婦人科(乳房超音波検査)
            objCrObject = colCrObjects["HUJINKA_NYUBOU"];
            data2 = SelectJudHistoryRsl(objRepConsult.RsvNo, 56, true);
            switch (Convert.ToInt16(data2.JUDRNAME))
            {
                case "＊＊":
                    ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
                    break;
                case "－－":
                    ((CnListField)objCrObject).ListText(0, 0, "検査せず");
                    break;
                default:
                    j = 0;
                    k = 0;
                    if (!"".Equals(((CnDataField)colCrObjects["SHORTSTC_28700-01"]).Text.TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(0, j, ((CnDataField)colCrObjects["SHORTSTC_28700-01"]).Text);
                        j++;
                    }
                    if (!"".Equals(((CnDataField)colCrObjects["SHORTSTC_28700-02"]).Text.TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(0, j, ((CnDataField)colCrObjects["SHORTSTC_28700-02"]).Text);
                        j++;
                    }
                    IList<dynamic> lngRsl = SelectStc_3rd(objRepConsult.RsvNo, GRPCD_NYUBOU);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        i = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }
                    }
                    break;
            }

            // 眼底
            // 今回
            objCrObject = colCrObjects["GANTEI_SYOKEN"];
            if (((CnDataField)colCrObjects["JUDRNAME_21"]).Text.Equals("＊＊"))
            {

            }
            else
            {
                if (((CnDataField)colCrObjects["JUDRNAME_21"]).Text.Equals("－－"))
                {

                }
                else
                {
                    IList<dynamic> lngRsl = SelectStc_2nd(objRepConsult.RsvNo, GRPCD_GANTEI);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListRows.Count() - 1)))
                        {
                            j = 0;
                            while (!((i > (lngRslCount - 1)) || (j > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                            {
                                if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                                {
                                    ((CnListField)objCrObject).ListText(j, k, lngRsl[i].LONGSTC.Trim());
                                    j++;
                                }
                                i++;
                            }
                            k++;
                        }
                    }
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd(objHistory.RsvNo, GRPCD_GANTEI);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["GANTEI_SYOKEN1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListRows.Count() - 1)))
                    {
                        j = 0;
                        while (!((i > (lngRslCount - 1)) || (j > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(j, k, lngRsl[i].LONGSTC.Trim());
                                j++;
                            }
                            i++;
                        }
                        k++;
                    }
                }
            }
            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd(objHistory.RsvNo, GRPCD_GANTEI);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["GANTEI_SYOKEN2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListRows.Count() - 1)))
                    {
                        j = 0;
                        while (!((i > (lngRslCount - 1)) || (j > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(j, k, lngRsl[i].LONGSTC.Trim());
                                j++;
                            }
                            i++;
                        }
                        k++;
                    }
                }
            }

            // 判定用項目の可否設定
            colCrObjects["JUDRNAME_11"].Visible = false;
            colCrObjects["JUDRNAME_12"].Visible = false;
            colCrObjects["JUDRNAME_13"].Visible = false;
            colCrObjects["JUDRNAME_14"].Visible = false;
            colCrObjects["JUDRNAME_15"].Visible = false;
            colCrObjects["JUDRNAME_16"].Visible = false;
            colCrObjects["JUDRNAME_17"].Visible = false;
            colCrObjects["JUDRNAME_18"].Visible = false;
            colCrObjects["JUDRNAME_19"].Visible = false;
            colCrObjects["JUDRNAME_20"].Visible = false;
            colCrObjects["JUDRNAME_21"].Visible = false;
            colCrObjects["JUDRNAME_22"].Visible = false;
            colCrObjects["JUDRNAME_23"].Visible = false;
            colCrObjects["JUDRNAME_24"].Visible = false;
            colCrObjects["JUDRNAME_25"].Visible = false;
            colCrObjects["SHORTSTC_28700-01"].Visible = false;
            colCrObjects["SHORTSTC_28700-02"].Visible = false;

            // 指定団体グループ以外の団体名・社員番号を非表示とする処理
            Boolean blnOrgGrp = SelectOrgGrp(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_ORGGRP);
            if (blnOrgGrp)
            {
                colCrObjects["LBLEMPNO"].Visible = true;
                colCrObjects["LBLORGNAME"].Visible = true;
                colCrObjects["EMPNO"].Visible = true;
                colCrObjects["ORGNAME"].Visible = true;
            }
            else
            {
                colCrObjects["LBLEMPNO"].Visible = false;
                colCrObjects["LBLORGNAME"].Visible = false;
                colCrObjects["EMPNO"].Visible = false;
                colCrObjects["ORGNAME"].Visible = false;
            }

            Boolean blnOrgIns = SelectOrgIns(objRepConsult.OrgCd1, objRepConsult.OrgCd2);
            if (blnOrgIns)
            {
                colCrObjects["LBLISRSIGN"].Visible = true;
                colCrObjects["ISRSIGN"].Visible = true;
                colCrObjects["LBLISRNO"].Visible = true;
                colCrObjects["ISRNO"].Visible = true;
            }
            else
            {
                colCrObjects["LBLISRSIGN"].Visible = false;
                colCrObjects["ISRSIGN"].Visible = false;
                colCrObjects["LBLISRNO"].Visible = false;
                colCrObjects["ISRNO"].Visible = false;
            }


            if (objRepConsult.CslDate < Convert.ToDateTime("2005/01/07"))
            {
                colCrObjects["Label20050107-TSH"].Visible = false;
                colCrObjects["Label20050107-FT4"].Visible = false;
                colCrObjects["Label20050106-TSH"].Visible = true;
                colCrObjects["Label20050106-FT4"].Visible = true;
                if (objRepConsult.CslDate < Convert.ToDateTime("2004/07/20"))
                {
                    colCrObjects["LBL20040719"].Visible = true;
                    colCrObjects["LBL20040720"].Visible = false;
                }
                else
                {
                    colCrObjects["LBL20040719"].Visible = false;
                    colCrObjects["LBL20040720"].Visible = true;
                }
            }
            else
            {
                colCrObjects["Label20050107-TSH"].Visible = true;
                colCrObjects["Label20050107-FT4"].Visible = true;
                colCrObjects["LBL20040720"].Visible = true;
                colCrObjects["Label20050106-TSH"].Visible = false;
                colCrObjects["Label20050106-FT4"].Visible = false;
                colCrObjects["LBL20040719"].Visible = false;

            }

            if (objRepConsult.CslDate < Convert.ToDateTime("2004/10/30"))
            {
                colCrObjects["Label20041029"].Visible = true;
                colCrObjects["Label20041030"].Visible = false;
            }
            else
            {
                colCrObjects["Label20041029"].Visible = false;
                colCrObjects["Label20041030"].Visible = true;
            }

            if (objRepConsult.CslDate < Convert.ToDateTime("2007/06/27"))
            {
                ((CnDataField)colCrObjects["Label_CRP"]).Text = "（0.39≧）";
            }
            else
            {
                ((CnDataField)colCrObjects["Label_CRP"]).Text = "（0.3≧）";
            }
        }

        /// <summary>
        /// ６連成績書５枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6N320_5(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書６枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6N320_6(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 特定健診成績書７枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6N320_7(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {
            CnObjects colCnObjects;                         // 描画オブジェクトのコレクション
            CnObject objCnObject;                           // 描画オブジェクト
            RepItem objItem;                                // 検査項目クラス
            RepResult objResult;                            // 検査結果クラス
            int lngRslCount;                                 // 結果件数
            IList<string> vntToken;                         // トークン
            int lngTokenCount;                              // トークン数
            IList<string> vntLongStc;                       // 文章
            // Dim vntItemRName            As Variant          // 報告書項目名
            // Dim vntItemSName            As Variant          // 検査項目略称
            // Dim vntResult               As Variant          // 結果
            // Dim vntItemUnit             As Variant          // 単位
            IList<string> vntJudCmtStc;                      // 判定コメント
            IList<string> vntJudCmtCd;                       // 判定コメントコード
            IList<string> vntDiseaseCd;                      // 病名コード
            IList<string> vntStatusCd;                       // 治療状況コード
            string strJudCntStc = "";                        // 判定コメント
            int lngColIndex;                                 // 列インデックス
            int lngRowIndex;                                 // 行インデックス
            RepItemHistories colItemHistories;              // 検査項目履歴コレクション
            RepItemHistory objItemHistory;                  // 検査項目履歴クラス

            string strUnit;                                 // 単位
            string strJudCd;
            string strJudRName;
            int lngAlcohol;                                 // アルコール換算値

            int i;

            string[] judPriCode = new string[3];           // 固定ロジック用

            // 眼底所見印刷欄
            judPriCode[1] = "PRISHORTSTC_22180-01_22180-02_22180-03_22180-04_22180-05_22180-06_22180-07_22180-08_22180-09_22180-10";
            // 心電図所見印刷欄
            judPriCode[2] = "PRISHORTSTC_22160-01_22160-03_22160-05_22160-07_22160-09_22160-11";


            // 描画オブジェクトコレクションの参照設定
            colCnObjects = cnForm.CnObjects;


            // 喫煙歴関連変換
            if (((CnDataField)colCnObjects["SHORTSTC_63070-00"]).Text == "吸っている")
            {
                ((CnDataField)colCnObjects["SHORTSTC_63070-00"]).Text = "はい";
                ((CnDataField)colCnObjects["EDITSMOKING"]).Text = CMT_SMOKING;
            }
            else
            {
                ((CnDataField)colCnObjects["SHORTSTC_63070-00"]).Text = "いいえ";
                ((CnDataField)colCnObjects["EDITSMOKING"]).Text = CMT_NO_SMOKING;
            }

            // 睡眠で休養関連変換
            if (((CnDataField)colCnObjects["SHORTSTC_63130-00"]).Text == "よく眠れる") {
                ((CnDataField)colCnObjects["SHORTSTC_63130-00"]).Text = "はい";
            }
            else
            {
                if (((CnDataField)colCnObjects["SHORTSTC_63130-00"]).Text == "寝不足を感じる")
                {
                    ((CnDataField)colCnObjects["SHORTSTC_63130-00"]).Text = "いいえ";
                }
            }

            // 飲酒頻度関連表示形式変換
            if (((CnDataField)colCnObjects["SHORTSTC_63040-00"]).Text == "飲まない")
            {
                colCnObjects["RESULT_63050-00"].Visible = false;
                colCnObjects["Label_63050"].Visible = false;
                colCnObjects["SHORTSTC_63040-00"].Visible = true;
            }
            else
            {
                if (((CnDataField)colCnObjects["SHORTSTC_63040-00"]).Text == "習慣的に飲む" || ((CnDataField)colCnObjects["SHORTSTC_63040-00"]).Text == "ときどき飲む") {
                    colCnObjects["RESULT_63050-00"].Visible = true;
                    colCnObjects["Label_63050"].Visible = true;
                    colCnObjects["SHORTSTC_63040-00"].Visible = false;
                } 
                else
                {
                    colCnObjects["RESULT_63050-00"].Visible = false;
                    colCnObjects["Label_63050"].Visible = false;
                    colCnObjects["SHORTSTC_63040-00"].Visible = false;
                }
            }

            foreach (CnObject cnObject in colCnObjects)
            {
                switch (cnObject.Name.ToUpper())
                {
                    case "CSLDATE":
                        ((CnDataField)colCnObjects["CSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "CSLDATEM":
                        ((CnDataField)colCnObjects["CSLDATEM"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "BIRTH":
                        ((CnDataField)colCnObjects["BIRTH"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.Birth);
                        break;
                    case "EDITCSLDATE":
                        ((CnDataField)colCnObjects["EDITCSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "EDITCSLDATEM":
                        ((CnDataField)colCnObjects["EDITCSLDATEM"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "EDITBIRTH":
                        ((CnDataField)colCnObjects["EDITBIRTH"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.Birth);
                        break;
                    default:
                        // アンダースコアでカラム名を分割
                        vntToken = cnObject.Name.Split('_');
                        lngTokenCount = vntToken.Count;
                        if (lngTokenCount >= 1)
                        {
                            switch (PrintCommon.ExceptReplicationSign(vntToken[0]).ToUpper())
                            {
                                case "JUDRNAME":
                                    if (Convert.ToInt32(vntToken[1]) >= 1 && Convert.ToInt32(vntToken[1]) <= 31)
                                    {
                                        if ((lngTokenCount - 1) <= 1)
                                        {
                                            dynamic rslData = SelectJudHistoryRsl(objRepConsult.RsvNo, Convert.ToInt32(vntToken[1]), true);
                                            ((CnDataField)cnObject).Text = rslData.JUDRNAME;
                                            if (rslData.JUDRNAME.ToUpper() == "＊＊")
                                            {
                                                switch (Convert.ToInt32(vntToken[1]))
                                                {
                                                    case 1:
                                                        ((CnListField)colCnObjects[judPriCode[1]]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 3:
                                                        ((CnDataField)colCnObjects["RESULT_13120-01"]).Text = "****";
                                                        ((CnDataField)colCnObjects["RESULT_13120-02"]).Text = "****";
                                                        break;
                                                    case 4:
                                                        ((CnListField)colCnObjects[judPriCode[2]]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 10:
                                                        ((CnDataField)colCnObjects["RESULT_15022-00"]).Text = "****";
                                                        ((CnDataField)colCnObjects["RESULT_15023-00"]).Text = "****";
                                                        ((CnDataField)colCnObjects["RESULT_15021-00"]).Text = "****";
                                                        break;
                                                    case 11:
                                                        ((CnDataField)colCnObjects["RESULT_17520-00"]).Text = "****";
                                                        break;
                                                    case 12:
                                                        ((CnDataField)colCnObjects["RESULT_17422-00"]).Text = "****";
                                                        ((CnDataField)colCnObjects["RESULT_17423-00"]).Text = "****";
                                                        ((CnDataField)colCnObjects["RESULT_17420-00"]).Text = "****";
                                                        break;
                                                    case 14:
                                                        ((CnDataField)colCnObjects["RESULT_17027-00"]).Text = "****";
                                                        ((CnDataField)colCnObjects["RESULT_17028-00"]).Text = "****";
                                                        ((CnDataField)colCnObjects["RESULT_17029-00"]).Text = "****";
                                                        break;
                                                    case 19:
                                                        ((CnDataField)colCnObjects["SHORTSTC_14022-00"]).Text = "****";
                                                        ((CnDataField)colCnObjects["SHORTSTC_14021-00"]).Text = "****";
                                                        break;
                                                    case 21:
                                                        ((CnDataField)colCnObjects["SHORTSTC_11530-00"]).Text = "＊＊＊＊＊";
                                                        break;
                                                }
                                            }
                                            if (rslData.JUDRNAME.ToUpper() == "－－")
                                            {
                                                switch (Convert.ToInt32(vntToken[1]))
                                                {
                                                    case 1:
                                                        ((CnListField)colCnObjects[judPriCode[1]]).ListText(0, 0, "検査せず");
                                                        break;
                                                    case 3:
                                                        ((CnDataField)colCnObjects["RESULT_13120-01"]).Text = "****";
                                                        ((CnDataField)colCnObjects["RESULT_13120-02"]).Text = "****";
                                                        break;
                                                    case 4:
                                                        ((CnListField)colCnObjects[judPriCode[2]]).ListText(0, 0, "検査せず");
                                                        break;
                                                    case 10:
                                                        ((CnDataField)colCnObjects["RESULT_15022-00"]).Text = "****";
                                                        ((CnDataField)colCnObjects["RESULT_15023-00"]).Text = "****";
                                                        ((CnDataField)colCnObjects["RESULT_15021-00"]).Text = "****";
                                                        break;
                                                    case 11:
                                                        ((CnDataField)colCnObjects["RESULT_17520-00"]).Text = "****";
                                                        break;
                                                    case 12:
                                                        ((CnDataField)colCnObjects["RESULT_17422-00"]).Text = "****";
                                                        ((CnDataField)colCnObjects["RESULT_17423-00"]).Text = "****";
                                                        ((CnDataField)colCnObjects["RESULT_17420-00"]).Text = "****";
                                                        break;
                                                    case 14:
                                                        ((CnDataField)colCnObjects["RESULT_17027-00"]).Text = "****";
                                                        ((CnDataField)colCnObjects["RESULT_17028-00"]).Text = "****";
                                                        ((CnDataField)colCnObjects["RESULT_17029-00"]).Text = "****";
                                                        break;
                                                    case 19:
                                                        ((CnDataField)colCnObjects["SHORTSTC_14022-00"]).Text = "****";
                                                        ((CnDataField)colCnObjects["SHORTSTC_14021-00"]).Text = "****";
                                                        break;
                                                    case 21:
                                                        ((CnDataField)colCnObjects["SHORTSTC_11530-00"]).Text = "検査せず";
                                                        break;
                                                }
                                            }
                                        }
                                    }
                                    break;
                            }
                        }
                        break;
                }
            }

            // 特定健診階層化コメント
            IList<dynamic> judCmtData = SelectJudCmt(objRepConsult.RsvNo, 5);
            if (judCmtData.Count > 0)
            {
                strJudCntStc = "";
                i = 0;
                while (!(i > (judCmtData.Count - 1)))
                {
                    strJudCntStc = strJudCntStc + judCmtData[i].JUDCMTSTC + Environment.NewLine;
                    i++;
                }
                ((CnDataField)colCnObjects["SPECIALCOMMENT"]).Text = strJudCntStc;
            }

            // メタボリックシンドロームコメント
            IList<dynamic> vntJudCmtData = SelectJudCmt(objRepConsult.RsvNo, 1);
            if (vntJudCmtData.Count > 0) {
                strJudCntStc = "";
                i = 0;
                while (!(i > (vntJudCmtData.Count - 1)))
                {
                    if (vntJudCmtData[i].JUDCMTCD == CMTCD_META1 || vntJudCmtData[i].JUDCMTCD == CMTCD_META2 ||
                       vntJudCmtData[i].JUDCMTCD == CMTCD_META3 || vntJudCmtData[i].JUDCMTCD == CMTCD_META4)
                    {
                        strJudCntStc = strJudCntStc + vntJudCmtData[i].JUDCMTSTC + Environment.NewLine;
                    }
                    i = i + 1;
                }
            }
            ((CnTextField)colCnObjects["METACOMMENT"]).Text = strJudCntStc;

            // メタボリック関連現病歴薬剤治療状況チェック
            dynamic recData = SelectMetaDisease(objRepConsult.RsvNo);

            // 「血圧を下げる薬」関連変換
            if (recData.KETSUATSU > 0)
            {
                ((CnListField)colCnObjects["MONSHIN_65110-01_1"]).ListText(0, 0, "*");
                ((CnDataField)colCnObjects["DISEASE_PRESSURE"]).Text = "はい";
            }
            else
            {
                ((CnDataField)colCnObjects["DISEASE_PRESSURE"]).Text = "いいえ";
            }

            // 「インスリン注射又は血糖を下げる薬」関連変換
            if (recData.TOUNYOU > 0)
            {
                ((CnListField)colCnObjects["MONSHIN_65110-01_2"]).ListText(0, 0, "*");
                ((CnDataField)colCnObjects["DISEASE_SUGAR"]).Text = "はい";
            }
            else
            {
                ((CnDataField)colCnObjects["DISEASE_SUGAR"]).Text = "いいえ";
            }

            // 「コレステロールを下げる薬」関連変換
            if (recData.SHISITSU > 0)
            {
                ((CnListField)colCnObjects["MONSHIN_65110-01_3"]).ListText(0, 0, "*");
                ((CnDataField)colCnObjects["DISEASE_FAT"]).Text = "はい";
            }
            else
            {
                ((CnDataField)colCnObjects["DISEASE_FAT"]).Text = "いいえ";
            }

            // 当てはまる病名や治療状況がなかったら「いいえ」を設定
            ((CnDataField)colCnObjects["DISEASE1"]).Text = "いいえ";
            ((CnDataField)colCnObjects["DISEASE2"]).Text = "いいえ";
            ((CnDataField)colCnObjects["DISEASE3"]).Text = "いいえ";
            ((CnDataField)colCnObjects["DISEASE4"]).Text = "いいえ";
            // 病名関連問診結果設定（変換）
            IList<dynamic> vntDiseaseData = SelectDisease(objRepConsult.RsvNo);
            if (vntDiseaseData.Count > 0)
            {
                i = 0;
                while (!(i > (vntDiseaseData.Count - 1)))
                { 
                    // 脳梗塞、クモ膜下出血、脳出血
                    if (vntDiseaseData[i].RSLDISEASE == "2" || vntDiseaseData[i].RSLDISEASE == "3" || vntDiseaseData[i].RSLDISEASE == "4") 
                    {
                        ((CnDataField)colCnObjects["DISEASE1"]).Text = "はい";
                    }

                    // 狭心症、心筋梗塞
                    if (vntDiseaseData[i].RSLDISEASE == "20" || vntDiseaseData[i].RSLDISEASE == "21")
                    {
                        ((CnDataField)colCnObjects["DISEASE2"]).Text = "はい";
                    }

                    //「慢性腎不全」或いは治療状況が「透析中」の病名についてはマスター登録後コーディング
                    if (vntDiseaseData[i].RSLDISEASE == "55" || vntDiseaseData[i].RSLDISEASE == "11")
                    {
                        ((CnDataField)colCnObjects["DISEASE3"]).Text = "はい";
                    }

                    // 貧血
                    if (vntDiseaseData[i].RSLDISEASE == "50")
                    {
                        ((CnDataField)colCnObjects["DISEASE4"]).Text = "はい";
                    }

                    i = i + 1;
                }
            }

            // アルコール換算値設定
            dynamic alcoholData = SelectRsl_ALCOHOL(objRepConsult.RsvNo);

            if (Convert.ToInt32(alcoholData.SUMALCOHOL) < 1)
            {
                ((CnDataField)colCnObjects["ALCOHOL"]).Text = "１合未満";
            }
            else
            {
                if (Convert.ToInt32(alcoholData.SUMALCOHOL) < 2)
                {
                    ((CnDataField)colCnObjects["ALCOHOL"]).Text = "１～２合未満";
                }
                else
                {
                    if (Convert.ToInt32(alcoholData.SUMALCOHOL) < 3)
                    {
                        ((CnDataField)colCnObjects["ALCOHOL"]).Text = "２～３合未満";
                    }
                    else
                    {
                        ((CnDataField)colCnObjects["ALCOHOL"]).Text = "３合以上";
                    }
                }
            }

            // 補助項目の可否設定
            colCnObjects["JUDRNAME_1"].Visible = false;
            colCnObjects["JUDRNAME_3"].Visible = false;
            colCnObjects["JUDRNAME_4"].Visible = false;
            colCnObjects["JUDRNAME_10"].Visible = false;
            colCnObjects["JUDRNAME_11"].Visible = false;
            colCnObjects["JUDRNAME_12"].Visible = false;
            colCnObjects["JUDRNAME_14"].Visible = false;
            colCnObjects["JUDRNAME_19"].Visible = false;
            colCnObjects["JUDRNAME_21"].Visible = false;


            // 喫煙歴チェック用
            // colCrObjects["SHORTSTC_63070-00"].Visible = false;

            // 特定健診契約情報チェック
            bool blnSpecial = SelectSpecialChk(objRepConsult.RsvNo);

            // 契約情報（特定健診）によってステップ３のタイトルの「*階層化*」という言葉表示制御
            if (blnSpecial)
            {
                colCnObjects["Labelstep3"].Visible = true;
            }
            else
            {
                colCnObjects["Labelstep3"].Visible = false;
            }

            // ヘモグロビンの基準値は該当受診者の性別に合わせて印刷
            if (objRepConsult.Gender == 1)
            {
                colCnObjects["WAIST_LEAD_M"].Visible = true;
                colCnObjects["HEMO_LEAD_M"].Visible = true;
                colCnObjects["HEMO_CARE_M"].Visible = true;
                colCnObjects["WAIST_LEAD_F"].Visible = false;
                colCnObjects["HEMO_LEAD_F"].Visible = false;
                colCnObjects["HEMO_CARE_F"].Visible = false;
            }
            else
            {
                colCnObjects["WAIST_LEAD_M"].Visible = false;
                colCnObjects["HEMO_LEAD_M"].Visible = false;
                colCnObjects["HEMO_CARE_M"].Visible = false;
                colCnObjects["WAIST_LEAD_F"].Visible = true;
                colCnObjects["HEMO_LEAD_F"].Visible = true;
                colCnObjects["HEMO_CARE_F"].Visible = true;
            }

            // 指定団体グループ以外の団体名・社員番号を非表示とする処理
            bool blnOrgGrp = SelectOrgGrp(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_ORGGRP);

            // 性別に合わせてヘモグロビン基準値表示
            if (blnOrgGrp)
            {
                colCnObjects["LBLEMPNO"].Visible = true;
                colCnObjects["LBLORGNAME"].Visible = true;
                colCnObjects["EMPNO"].Visible = true;
                colCnObjects["ORGNAME"].Visible = true;
            }
            else
            {
                colCnObjects["LBLEMPNO"].Visible = false;
                colCnObjects["LBLORGNAME"].Visible = false;
                colCnObjects["EMPNO"].Visible = false;
                colCnObjects["ORGNAME"].Visible = false;
            }

            // 指定団体の成績表に保険証記号、番号を出力有無チェック
            bool blnOrgIns = SelectOrgIns(objRepConsult.OrgCd1, objRepConsult.OrgCd2);

            if (blnOrgIns)
            {
                colCnObjects["LBLISRSIGN"].Visible = true;
                colCnObjects["ISRSIGN"].Visible = true;
                colCnObjects["LBLISRNO"].Visible = true;
                colCnObjects["ISRNO"].Visible = true;
            }
            else
            {
                colCnObjects["LBLISRSIGN"].Visible = false;
                colCnObjects["ISRSIGN"].Visible = false;
                colCnObjects["LBLISRNO"].Visible = false;
                colCnObjects["ISRNO"].Visible = false;
            }
        }

        /// <summary>
        /// 総合判定表１枚ものの編集（2007.04.01 婦人科判定分類）
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_ReportN322(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 総合判定表１枚ものの編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_ReportN322_2011(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {
            CnObject objCnObject;           // 描画オブジェクト
            CnObject objCnObject1;          // 描画オブジェクト
            RepItem objItem;                // 検査項目クラス
            RepHistory objHistory;          // 受診履歴クラス
            RepItemHistory objItemHistory;  // 検査項目履歴クラス
            RepStdValue objStdValue;        // 基準値クラス

            CnObjects colCnObjects;         // 描画オブジェクトのコレクション
            RepItemHistories colItemHistories;  // 検査項目履歴コレクション
            RepStdValues colStdValues;      // 基準値コレクション

            IList<string> token;            // トークン

            string strJudCntStc = "";        // 判定コメント
            string strUnit;                 // 単位
            string strLowerValue;           // 基準値（以上）
            string strUpperValue;           // 基準値（以下）
            string strJudCd;
            string strJudRName;

            int lngTokenCount;          // トークン数
            int lngRslCount;            // 結果件数
            short lngColIndex;          // 列インデックス
            short lngRowIndex;          // 行インデックス

            // 描画オブジェクトコレクションの参照設定
            colCnObjects = cnForm.CnObjects;

            // 固定編集
            colCnObjects["Line200"].Visible = false;

            foreach (CnObject cnObject in colCnObjects)
            {
                switch (cnObject.Name.ToUpper())
                {
                    case "CSLDATE":
                        ((CnDataField)colCnObjects["CSLDATE"]).Text = string.Format("{0:yyyy年m月d日}", objRepConsult.CslDate);
                        break;
                    case "BIRTH":
                        ((CnDataField)colCnObjects["BIRTH"]).Text = string.Format("{0:yyyy年m月d日}", objRepConsult.Birth);
                        break;
                    default:
                        // アンダースコアでカラム名を分割
                        token = cnObject.Name.Split('_');
                        lngTokenCount = token.Count;
                        if (lngTokenCount >= 1)
                        {
                            // 項目名ごとの初期分岐
                            switch (PrintCommon.ExceptReplicationSign(cnObject.Name))
                            {
                                case "PRISHORTSTC":
                                    if ("_1".Equals(cnObject.Name.TrimEnd().Substring(cnObject.Name.Length - 2, 2))
                                        || "_2".Equals(cnObject.Name.TrimEnd().Substring(cnObject.Name.Length - 2, 2)))
                                    {
                                        if (((CnListField)cnObject).ListText(0, 0).Substring(0, 1) == "*")
                                        {
                                            ((CnListField)cnObject).ListText(0, 0, "");
                                        }
                                    }
                                    break;

                                case "RESULT":
                                case "SHORTSTC":
                                case "LONGSTC":
                                    if ("_1".Equals(cnObject.Name.TrimEnd().Substring(cnObject.Name.Length - 2, 2))
                                        || "_2".Equals(cnObject.Name.TrimEnd().Substring(cnObject.Name.Length - 2, 2)))
                                    {
                                        if (((CnDataField)cnObject).Text.Substring(0, 1) == "*")
                                        {
                                            ((CnDataField)cnObject).Text = "";
                                        }
                                    }
                                    break;

                                case "JUDRNAME":
                                    if (Convert.ToInt32(token[1]) >= 1 && Convert.ToInt32(token[1]) <= 44)
                                    {
                                        if ((token.Count - 1) > 1)
                                        {
                                            if (objRepConsult.Histories.Item(Convert.ToInt32(token[2])) != null)
                                            {
                                                dynamic rslData = SelectJudHistoryRsl(objRepConsult.Histories.Item(Convert.ToInt32(token[2])).RsvNo, Convert.ToInt32(token[1]), false);
                                                ((CnDataField)cnObject).Text = rslData.JUDRNAME;
                                            } else
                                            {
                                                dynamic rslData = SelectJudHistoryRsl(objRepConsult.RsvNo, Convert.ToInt32(token[1]), true);
                                                ((CnDataField)cnObject).Text = rslData.JUDRNAME;
                                            }
                                        }
                                    }
                                    break;
                            }
                        }
                        break;

                }
            }

            // 総合判定コメント
            IList<dynamic> judCmtData = SelectJudCmt(objRepConsult.RsvNo, 1);
            if (judCmtData.Count > 0)
            {
                strJudCntStc = "";
                foreach (var rec in judCmtData)
                {
                    strJudCntStc += rec.JUDCMTSTC + Environment.NewLine;
                }
            }

            // オプション血液検査が存在する場合コメントを自動で出力してくれる。
            if (CheckOptionComment(objRepConsult.RsvNo))
            {
                strJudCntStc += CMT_ADDKENSA + Environment.NewLine;
            }
            ((CnDataField)colCnObjects["TOTALCOMMENT"]).Text = strJudCntStc;

            // 血液検査
            objCnObject = colCnObjects["BLOODITEMRNAME"];
            CnListField cnListFieldBloodItemRName = (CnListField)objCnObject;

            IList<dynamic> rsl2Data = SelectRsl2(objRepConsult.RsvNo, GRPCD_BLOOD);
            if (rsl2Data.Count > 0)
            {
                lngRowIndex = 0;
                lngColIndex = 0;
                foreach (var rec in rsl2Data)
                {
                    // 出力位置の計算
                    // 下行、右列の順で表示する
                    if (lngRowIndex > (cnListFieldBloodItemRName.ListRows.Count() - 1))
                    {
                        lngRowIndex = 0;
                        lngColIndex++;
                    }
                    if (lngColIndex > (cnListFieldBloodItemRName.ListColumns.Count() - 1))
                    {
                        break;
                    }

                    // 単位、基準値を取得
                    strUnit = "";
                    strLowerValue = "";
                    strUpperValue = "";
                    objItem = colItems.Item(Convert.ToString(rec.ITEMCD) + "-" + Convert.ToString(rec.SUFFIX));
                    if (objItem != null)
                    {
                        // 単位を取得
                        colItemHistories = objItem.Histories;
                        if (colItemHistories != null)
                        {
                            objItemHistory = colItemHistories.Item(objRepConsult.CslDate);
                            if (objItemHistory != null)
                            {
                                strUnit = objItemHistory.Unit;
                            }
                        }

                        // 基準値を取得
                        colStdValues = objItem.StdValues;
                        if (colStdValues != null)
                        {
                            for (int i = 0; i < colStdValues.Count; i++)
                            {
                                while (true)
                                {
                                    if (objRepConsult.CslDate.CompareTo(colStdValues.Item(i).StrDate) == -1
                                        && objRepConsult.CslDate.CompareTo(colStdValues.Item(i).EndDate) == 1)
                                    {
                                        break;
                                    }

                                    if (!"".Equals(colStdValues.Item(i).CsCd) && !objRepConsult.CsCd.Equals(colStdValues.Item(i).CsCd))
                                    {
                                        break;
                                    }

                                    if (objRepConsult.Gender != colStdValues.Item(i).Gender)
                                    {
                                        break;
                                    }

                                    if ((string.Format("{0:000.00}", objRepConsult.Age)).CompareTo(colStdValues.Item(i).StrAge) == -1
                                        && (string.Format("{0:000.00}", objRepConsult.Age)).CompareTo(colStdValues.Item(i).EndAge) == 1)
                                    {
                                        break;
                                    }

                                    strLowerValue = colStdValues.Item(i).LowerValue;
                                    strUpperValue = colStdValues.Item(i).UpperValue;

                                    break;
                                }
                            }

                            // 結果表示
                            cnListFieldBloodItemRName.ListText(lngColIndex, lngRowIndex, rec.ITEMRNAME);
                            ((CnListField)colCnObjects["BLOODRESULT"]).ListText(lngColIndex, lngRowIndex, string.Format("{0:@@@@@@@@}", rec.RESULT));
                            ((CnListField)colCnObjects["BLOODUNIT"]).ListText(lngColIndex, lngRowIndex, strUnit);
                            if (!string.IsNullOrEmpty(strLowerValue) && !string.IsNullOrEmpty(strUpperValue))
                            {
                                ((CnListField)colCnObjects["BLOODSTDVALUE"]).ListText(lngColIndex, lngRowIndex, ("(" + strLowerValue.Trim() + "～" + strUpperValue.Trim() + ")"));
                            }
                            else if (!string.IsNullOrEmpty(strLowerValue))
                            {
                                ((CnListField)colCnObjects["BLOODSTDVALUE"]).ListText(lngColIndex, lngRowIndex, ("(" + strLowerValue.Trim() + "～" + ")"));

                            }
                            else if (!string.IsNullOrEmpty(strUpperValue))
                            {
                                ((CnListField)colCnObjects["BLOODSTDVALUE"]).ListText(lngColIndex, lngRowIndex, ("(" + "～" + strUpperValue.Trim() + ")"));
                            }

                            lngRowIndex++;
                        }
                    }
                }
            }
            if (cnListFieldBloodItemRName.ListText(0, 0) == "")
            {
                cnListFieldBloodItemRName.ListText(0, 0, "＊＊＊＊＊");
            }

            // 大腸内視鏡
            objCnObject = colCnObjects["DAICHOU"];
            CnListField cnListFieldDaichou = (CnListField)objCnObject;
            if ("＊＊".Equals(((CnDataField)colCnObjects["JUDRNAME_26"]).Text))
            {
                cnListFieldDaichou.ListText(0, 0, "＊＊＊＊＊");
                ((CnDataField)colCnObjects["RESULT_23530-00"]).Text = "********";
            }
            else
            {
                if ("－－".Equals(((CnDataField)colCnObjects["JUDRNAME_26"]).Text))
                {
                    cnListFieldDaichou.ListText(0, 0, "検査せず");
                    ((CnDataField)colCnObjects["RESULT_23530-00"]).Text = "";
                }
                else
                {
                    IList<dynamic> data = SelectStc(objRepConsult.RsvNo, GRPCD_DAICHOU);
                    if (data.Count > 0)
                    {
                        int j = 0;
                        int i = 0;
                        while (!(i > (data.Count - 1) || j > (cnListFieldDaichou.ListRows.Count() - 1)))
                        {

                        }
                    }
                }
            }


        }

        /// <summary>
        /// 新３連成績書１枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3N323_1(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 新３連成績書１枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3N323_1_2011(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 新３連成績書１枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3N323_1_20130401(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 新３連成績書１枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3N323_1_2017(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ３連成績書２枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3N323_2(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {
            CnObjects colCrObjects;                 // 描画オブジェクトのコレクション
            CnObject objCrObject;                   // 描画オブジェクト
            RepHistory objHistory;                  // 受診履歴クラス
            string vntLongStc;                      // 文章
            string[] vntToken;                      // トークン
            int lngTokenCount;                      //トークン数
            int lngRslCount;                        // 結果件数
            string strIKbn;                         // 胃区分
            string strSeq;                          // SEQ
            string strJudCd;
            string strJudRName;
            int i;
            short j;
            short k;
            int[,] JudSenketu = new int[3, 3]; // 便潜血判定用
            string[,] judLongStcCode = new string[3, 2]; // 便潜血判定用 
            string[] judPriCode = new string[2]; // 固定ロジック用
            string[] judResult = new string[3]; // 日付編集項目

            string strView;

            string[,] judAbnormalMark = new string[3, 2];            // 便潜血異常値マーク用


            //    描画オブジェクトコレクションの参照設定
            colCrObjects = cnForm.CnObjects;


            CheckVisible(objRepConsult.OrgCd1, objRepConsult.OrgCd2, 2, colCrObjects);


            judLongStcCode[1, 1] = "LONGSTC_14322-00";
            judLongStcCode[2, 1] = "LONGSTC_14322-00_1";
            judLongStcCode[3, 1] = "LONGSTC_14322-00_2";
            judLongStcCode[1, 2] = "LONGSTC_14325-00";
            judLongStcCode[2, 2] = "LONGSTC_14325-00_1";
            judLongStcCode[3, 2] = "LONGSTC_14325-00_2";


            judAbnormalMark[1, 1] = "ABNORMALMARK_14322-00";
            judAbnormalMark[2, 1] = "ABNORMALMARK_14322-00_1";
            judAbnormalMark[3, 1] = "ABNORMALMARK_14322-00_2";
            judAbnormalMark[1, 2] = "ABNORMALMARK_14325-00";
            judAbnormalMark[2, 2] = "ABNORMALMARK_14325-00_1";
            judAbnormalMark[3, 2] = "ABNORMALMARK_14325-00_2";


            judPriCode[1] = "PRISHORTSTC_22180-01_22180-02_22180-03_22180-04_22180-05_22180-06_22180-07_22180-08_22180-09_22180-10";
            judPriCode[2] = "PRISHORTSTC_22160-01_22160-03_22160-05_22160-07_22160-09_22160-11";


            judResult[1] = "RESULT_23110-00";
            judResult[2] = "RESULT_23110-00_1";
            judResult[3] = "RESULT_23110-00_2";


            // 今回、前回、前々回受診情報
            // 今回        
            ((CnDataField)colCrObjects["CSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
            dynamic IKbnName = SelectIKbnName(objRepConsult.RsvNo);

            ((CnDataField)colCrObjects["CSNAME"]).Text = objRepConsult.CsName + Convert.ToString(IKbnName.NAME).Trim();
            ((CnDataField)colCrObjects["IKBN"]).Text = Convert.ToString(IKbnName.NAME).Trim();
            //  Ｘ線、内視鏡非表示処理
            colCrObjects[IBU_NAISIKYODATE].Visible = false;
            colCrObjects[IBU_NAISIKYOLABEL].Visible = false;
            colCrObjects[IBU_NAISIKYODATE + "_1"].Visible = false;
            colCrObjects[IBU_NAISIKYOLABEL + "_1"].Visible = false;
            colCrObjects[IBU_NAISIKYODATE + "_2"].Visible = false;
            colCrObjects[IBU_NAISIKYOLABEL + "_2"].Visible = false;

            switch (IKbnName.SEQ)
            {
                case "2":
                    colCrObjects[IBU_NAISIKYODATE].Visible = true;
                    colCrObjects[IBU_NAISIKYOLABEL].Visible = true;
                    break;
            }

            //   前回
            objHistory = objRepConsult.Histories.Item(1);

            if (objHistory != null)
            {
                ((CnDataField)colCrObjects["CSLDATE_1"]).Text = string.Format("{0:YYYY年M月D日}", objHistory.CslDate);
                IKbnName = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCrObjects["CSNAME_1"]).Text = objHistory.CsName + Convert.ToString(IKbnName.NAME).Trim();
                ((CnDataField)colCrObjects["IKBN_1"]).Text = Convert.ToString(IKbnName.NAME).Trim();
                // Ｘ線、内視鏡非表示処理
                switch (IKbnName.SEQ)
                {
                    case "2":
                        colCrObjects[IBU_NAISIKYODATE + "_1"].Visible = true;
                        colCrObjects[IBU_NAISIKYOLABEL + "_1"].Visible = true;
                        break;
                }
            }

            //  前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (objHistory != null)
            {
                ((CnDataField)colCrObjects["CSLDATE_2"]).Text = string.Format("{0:YYYY年M月D日}", objHistory.CslDate);
                IKbnName = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCrObjects["CSNAME_2"]).Text = objHistory.CsName + Convert.ToString(IKbnName.NAME).Trim();
                ((CnDataField)colCrObjects["IKBN_2"]).Text = Convert.ToString(IKbnName.NAME).Trim();
                // Ｘ線、内視鏡非表示処理
                switch (IKbnName.SEQ)
                {
                    case "2":
                        colCrObjects[IBU_NAISIKYODATE + "_2"].Visible = true;
                        colCrObjects[IBU_NAISIKYOLABEL + "_2"].Visible = true;
                        break;
                }
            }


            //  上部消化管
            //  今回
            IList<dynamic> lngRsl = SelectStc_2nd(objRepConsult.RsvNo, GRPCD_JYOUBU);

            if (lngRsl.Count > 0)
            {
                objCrObject = colCrObjects["JYOUBU"];
                j = 0;
                i = 0;
                while (!((i > (lngRsl.Count - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                {

                    if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(0, j, lngRsl[i].LONGSTC.Trim());
                        j++;
                    }
                    i++;
                }
                j = 0;
                i = 0;
                k = 0;
                while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                {

                    if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                        j++;
                        if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                        {
                            j = 0;
                            k++;
                        }
                    }
                    i++;
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);

            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd(objHistory.RsvNo, GRPCD_JYOUBU);

                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["JYOUBU1"];
                    j = 0;
                    i = 0;
                    while (!((i > (data.Count - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                    {

                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(0, j, data[i].LONGSTC.Trim());
                            j++;
                        }
                        i++;
                    }
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {

                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd(objHistory.RsvNo, GRPCD_JYOUBU);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["JYOUBU2"];
                    j = 0;
                    i = 0;
                    while (!((i > (data.Count - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(0, j, data[i].LONGSTC.Trim());
                            j++;
                        }
                        i++;
                    }
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // ## 上腹部超音波 ##########
            // 今回
            lngRsl = SelectStc_2nd(objRepConsult.RsvNo, GRPCD_ECHO);
            if (lngRsl.Count > 0)
            {
                objCrObject = colCrObjects["ECHO"];
                j = 0;
                i = 0;
                while (!((i > (lngRsl.Count - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                {

                    if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(0, j, lngRsl[i].LONGSTC.Trim());
                        j++;
                    }
                    i++;
                }
                j = 0;
                i = 0;
                k = 0;
                while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                {

                    if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                        j++;
                        if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                        {
                            j = 0;
                            k++;
                        }
                    }
                    i++;
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd(objHistory.RsvNo, GRPCD_ECHO);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["ECHO_1"];
                    j = 0;
                    i = 0;
                    while (!((i > (data.Count - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(0, j, data[i].LONGSTC.Trim());
                            j++;
                        }
                        i++;
                    }
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd(objHistory.RsvNo, GRPCD_ECHO);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["ECHO_2"];
                    j = 0;
                    i = 0;
                    while (!((i > (data.Count - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(0, j, data[i].LONGSTC.Trim());
                            j++;
                        }
                        i++;
                    }
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 胸部Ｘ線
            // 今回
            lngRsl = SelectStc_2nd(objRepConsult.RsvNo, GRPCD_KYOUBU_X);
            if (lngRsl.Count > 0)
            {
                objCrObject = colCrObjects["KYOUBUX"];
                j = 0;
                i = 0;
                k = 0;
                while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                {

                    if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                        j++;
                        if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                        {
                            j = 0;
                            k++;
                        }
                    }
                    i++;
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd(objHistory.RsvNo, GRPCD_KYOUBU_X);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["KYOUBUX1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd(objHistory.RsvNo, GRPCD_KYOUBU_X);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["KYOUBUX2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // On Error Resume Next
            // 便潜血判定
            // 障害対応 -> 表示制御のクリアを行う

            for (i = 1; i <= 3; i++)
            {
                colCrObjects[judLongStcCode[i, 1]].Visible = true;
                colCrObjects[judLongStcCode[i, 2]].Visible = true;
                colCrObjects[judLongStcCode[1, 1]].Visible = true;
                colCrObjects[judLongStcCode[1, 2]].Visible = true;
                switch (Strings.StrConv(((CnDataField)colCrObjects[judLongStcCode[i, 1]]).Text, VbStrConv.Wide))
                {
                    case "検査せず":
                        JudSenketu[i, 1] = 1;
                        break;
                    case "（－）":
                        JudSenketu[i, 1] = 2;
                        break;
                    case "（＋－）":
                        JudSenketu[i, 1] = 3;
                        break;
                    case "（＋）":
                        JudSenketu[i, 1] = 4;
                        break;
                    case "（２＋）":
                        JudSenketu[i, 1] = 5;
                        break;
                    default:
                        JudSenketu[i, 1] = 0;
                        break;

                }
                switch (Strings.StrConv(((CnDataField)colCrObjects[judLongStcCode[i, 2]]).Text, VbStrConv.Wide))
                {
                    case "検査せず":
                        JudSenketu[i, 2] = 1;
                        break;
                    case "（－）":
                        JudSenketu[i, 2] = 2;
                        break;
                    case "（＋－）":
                        JudSenketu[i, 2] = 3;
                        break;
                    case "（＋）":
                        JudSenketu[i, 2] = 4;
                        break;
                    case "（２＋）":
                        JudSenketu[i, 2] = 5;
                        break;
                    default:
                        JudSenketu[i, 2] = 0;
                        break;

                }
                if (JudSenketu[i, 1] < JudSenketu[i, 2])
                {
                    colCrObjects[judLongStcCode[i, 1]].Visible = false;
                }
                else
                {
                    colCrObjects[judLongStcCode[i, 2]].Visible = false;
                }
                colCrObjects[judAbnormalMark[i, 1]].Visible = colCrObjects[judLongStcCode[i, 1]].Visible;
                colCrObjects[judAbnormalMark[i, 2]].Visible = colCrObjects[judLongStcCode[i, 2]].Visible;
            }

            // On Error GoTo 0

            foreach (CnObject rec in colCrObjects)
            {
                switch (rec.Name.ToUpper())
                {
                    case "CSLDATE":
                        ((CnDataField)colCrObjects["CSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "CSLDATEM":
                        ((CnDataField)colCrObjects["CSLDATEM"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "BIRTH":
                        ((CnDataField)colCrObjects["BIRTH"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.Birth);
                        break;
                    case "ECHO1":
                        string leftStr = ((CnListField)colCrObjects["ECHO1"]).ListText(0, 0);
                        leftStr = leftStr.Substring(0, 1);
                        if ("*".Equals(Strings.StrConv(leftStr, VbStrConv.Narrow)))
                        {
                            ((CnListField)colCrObjects["ECHO1"]).ListText(0, 0, "");
                        }
                        break;
                    case "ECHO2":
                        string leftStr2 = ((CnListField)colCrObjects["ECHO2"]).ListText(0, 0);
                        leftStr2 = leftStr2.Substring(0, 1);
                        if ("*".Equals(Strings.StrConv(leftStr2, VbStrConv.Narrow)))
                        {
                            ((CnListField)colCrObjects["ECHO2"]).ListText(0, 0, "");
                        }
                        break;
                    default:
                        // アンダースコアでカラム名を分割
                        vntToken = rec.Name.Split('_');
                        lngTokenCount = vntToken.Length;
                        if (lngTokenCount >= 1)
                        {
                            switch (PrintCommon.ExceptReplicationSign(vntToken[0]).ToUpper())
                            {
                                case "PRISHORTSTC":
                                    string rightStr = rec.Name.TrimEnd();
                                    rightStr = rightStr.Substring(rightStr.Length - 2, 2);
                                    if ("_1".Equals(rightStr) || "_2".Equals(rightStr))
                                    {
                                        if ("*".Equals(Strings.StrConv(((CnListField)rec).ListText(0, 0).Substring(0, 1), VbStrConv.Narrow)))
                                        {
                                            ((CnListField)rec).ListText(0, 0, "");
                                        }
                                    }
                                    break;
                                case "RESULT":
                                case "SHORTSTC":
                                case "LONGSTC":
                                    rightStr = rec.Name.TrimEnd();
                                    rightStr = rightStr.Substring(rightStr.Length - 2, 2);
                                    if ("_1".Equals(rightStr) || "_2".Equals(rightStr))
                                    {
                                        if ("*".Equals(Strings.StrConv(((CnDataField)rec).Text.Substring(0, 1), VbStrConv.Narrow)))
                                        {
                                            ((CnDataField)rec).Text = "";
                                        }
                                    }
                                    break;
                                // TODO
                                //                Case "SHORTSTC", "LONGSTC"
                                //                    If Right(RTrim(objCrObject.Name), 2) = "_1" Or Right(RTrim(objCrObject.Name), 2) = "_2" Then
                                //                        If StrConv(Left(objCrObject.Text, 1), vbNarrow) = "*" Then
                                //                            objCrObject.Text = ""
                                //                        End If
                                //                    End If
                                //                Case "RESULT"
                                //                    If Right(RTrim(objCrObject.Name), 2) = "_1" Or Right(RTrim(objCrObject.Name), 2) = "_2" Then
                                //                        If StrConv(Left(objCrObject.Text, 1), vbNarrow) = "*" Then
                                //                            objCrObject.Text = ""
                                //                        End If
                                //                    End If
                                //                    For i = 1 To UBound(judResult)
                                //                        If objCrObject.Name = judResult(i) Then
                                //                            objCrObject.Text = Format$(Format$(objCrObject.Text, "0000/00/00"), "yyyy年m月d日")
                                //                        End If
                                //                    Next i
                                case "JUDRNAME":
                                    if (Convert.ToInt16(vntToken[1]) >= 1 && Convert.ToInt16(vntToken[1]) <= 28)
                                    {
                                        if (vntToken.Length - 1 <= 1)
                                        {
                                            dynamic data = SelectJudHistoryRsl(objRepConsult.RsvNo, Convert.ToInt16(vntToken[1]), true);
                                            ((CnDataField)rec).Text = data.JUDRNAME;
                                            if (("＊＊").Equals(data.JUDRNAME.ToUpper()))
                                            {
                                                switch (Convert.ToInt16(vntToken[1]))
                                                {
                                                    case 1:
                                                        ((CnListField)colCrObjects[judPriCode[1]]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 4:
                                                        ((CnListField)colCrObjects[judPriCode[2]]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 5:
                                                        ((CnDataField)colCrObjects["RESULT_13020-00"]).Text = "********";
                                                        ((CnDataField)colCrObjects["RESULT_13022-00"]).Text = "********";
                                                        ((CnDataField)colCrObjects["RESULT_13023-00"]).Text = "********";
                                                        ((CnDataField)colCrObjects["RESULT_13024-00"]).Text = "********";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13020-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13022-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13023-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13024-00"]).Text = "";
                                                        break;
                                                    case 6:
                                                        ((CnListField)colCrObjects["KYOUBUX"]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 7:
                                                        ((CnListField)colCrObjects["JYOUBU"]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 8:
                                                        ((CnDataField)colCrObjects["LONGSTC_14322-00"]).Text = "＊＊＊＊＊";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_14322-00"]).Text = "";
                                                        break;
                                                    case 9:
                                                        ((CnListField)colCrObjects["ECHO"]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                }
                                            }

                                            if (("－－").Equals(data.JUDRNAME.ToUpper()))
                                            {
                                                switch (Convert.ToInt16(vntToken[1]))
                                                {
                                                    case 1:
                                                        ((CnListField)colCrObjects[judPriCode[1]]).ListText(0, 0, "検査せず");
                                                        break;
                                                    case 4:
                                                        ((CnListField)colCrObjects[judPriCode[2]]).ListText(0, 0, "検査せず");
                                                        break;
                                                    case 5:
                                                        ((CnDataField)colCrObjects["RESULT_13020-00"]).Text = "--------";
                                                        ((CnDataField)colCrObjects["RESULT_13022-00"]).Text = "--------";
                                                        ((CnDataField)colCrObjects["RESULT_13023-00"]).Text = "--------";
                                                        ((CnDataField)colCrObjects["RESULT_13024-00"]).Text = "--------";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13020-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13022-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13023-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13024-00"]).Text = "";
                                                        break;
                                                    case 6:
                                                        ((CnListField)colCrObjects["KYOUBUX"]).ListText(0, 0, "検査せず");
                                                        break;
                                                    case 7:
                                                        ((CnListField)colCrObjects["JYOUBU"]).ListText(0, 0, "検査せず");
                                                        break;
                                                    case 8:
                                                        ((CnDataField)colCrObjects["LONGSTC_14322-00"]).Text = "検査せず";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_14322-00"]).Text = "";
                                                        break;
                                                    case 9:
                                                        ((CnListField)colCrObjects["ECHO"]).ListText(0, 0, "検査せず");
                                                        break;
                                                }
                                            }
                                        }
                                    }
                                    break;
                            }
                        }
                        break;

                }
            }

            colCrObjects["JUDRNAME_1"].Visible = false;
            colCrObjects["JUDRNAME_2"].Visible = false;
            colCrObjects["JUDRNAME_3"].Visible = false;
            colCrObjects["JUDRNAME_4"].Visible = false;
            colCrObjects["JUDRNAME_5"].Visible = false;
            colCrObjects["JUDRNAME_6"].Visible = false;
            colCrObjects["JUDRNAME_7"].Visible = false;
            colCrObjects["JUDRNAME_8"].Visible = false;
            colCrObjects["JUDRNAME_9"].Visible = false;
            colCrObjects["JUDRNAME_10"].Visible = false;

            //  指定団体グループ以外の団体名・社員番号を非表示とする処理
            Boolean blnOrgGrp = SelectOrgGrp(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_ORGGRP);
            if (blnOrgGrp)
            {
                colCrObjects["LBLEMPNO"].Visible = true;
                colCrObjects["EMPNO"].Visible = true;
            }
            else
            {
                colCrObjects["LBLEMPNO"].Visible = false;
                colCrObjects["EMPNO"].Visible = false;
            }

            // 指定団体の成績表に保険証記号、番号を出力有無チェック Start
            Boolean blnOrgIns = SelectOrgIns(objRepConsult.OrgCd1, objRepConsult.OrgCd2);
            if (blnOrgIns)
            {
                colCrObjects["LBLISRSIGN"].Visible = true;
                colCrObjects["ISRSIGN"].Visible = true;
                colCrObjects["LBLISRNO"].Visible = true;
                colCrObjects["ISRNO"].Visible = true;
            }
            else
            {
                colCrObjects["LBLISRSIGN"].Visible = false;
                colCrObjects["ISRSIGN"].Visible = false;
                colCrObjects["LBLISRNO"].Visible = false;
                colCrObjects["ISRNO"].Visible = false;
            }

        }
   
        /// <summary>
        /// 新３連成績書３枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3N323_3(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 新３連成績書３枚目の編集 2011.01.01版
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3N323_3_2011(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {
            CnObjects colCrObjects;                        // 描画オブジェクトのコレクション
            CnObject objCrObject1;
            CnObject objCrObject;                          // 描画オブジェクト
            RepHistory objHistory;                         // 受診履歴クラス
            string vntLongStc;                             // 文章
            string[] vntToken;                             // トークン
            int lngTokenCount;                             // トークン数
            int lngRslCount;                               // 結果件数
            String strIKbn;                                // 胃区分12
            String strSeq;                                 // SEQ
            String strJudCd;
            String strJudRName;
            String strCrObjName;
            string[] abnormalMarkShortCode = new string[4];
            string[] abnormalMarkResultCode = new string[2];
            int i;
            short j;
            short k;

            Boolean bolVisible;
            Boolean bolKessei;

            string[] judShortCode = new string[4];

            string[] judResultCode = new string[2];

            //    描画オブジェクトコレクションの参照設定
            colCrObjects = cnForm.CnObjects;

            CheckVisible(objRepConsult.OrgCd1, objRepConsult.OrgCd2, 3, colCrObjects);
            colCrObjects["Line200"].Visible = false;
            judShortCode[1] = "SHORTSTC_12050-00";
            judShortCode[2] = "SHORTSTC_12060-00";
            judShortCode[3] = "SHORTSTC_12070-00";
            judShortCode[4] = "SHORTSTC_12080-00";

            judResultCode[1] = "RESULT_16324-00";
            judResultCode[2] = "RESULT_14028-00";

            abnormalMarkShortCode[1] = "ABNORMALMARK_12050-00";
            abnormalMarkShortCode[2] = "ABNORMALMARK_12060-00";
            abnormalMarkShortCode[3] = "ABNORMALMARK_12070-00";
            abnormalMarkShortCode[4] = "ABNORMALMARK_12080-00";
            abnormalMarkResultCode[1] = "ABNORMALMARK_16324-00";
            abnormalMarkResultCode[2] = "ABNORMALMARK_14028-00";
            foreach (CnObject rec in colCrObjects)
            {
                switch (rec.Name.ToUpper())
                {
                    case "CSLDATE":
                        ((CnDataField)colCrObjects["CSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "CSLDATEM":
                        ((CnDataField)colCrObjects["CSLDATEM"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "BIRTH":
                        ((CnDataField)colCrObjects["BIRTH"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.Birth);
                        break;
                    case "RESULT_16325-00":// 血清学（ＲＦ）
                        ((CnDataField)colCrObjects["RESULT_16325-00"]).Text = SelectStc_RF(objRepConsult.RsvNo, "16325", "00", 0, 1);
                        break;
                    case "RESULT_16325-00_1":// 血清学（ＲＦ－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null!= objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_16325-00_1"]).Text = SelectStc_RF(objRepConsult.RsvNo, "16325", "00", 1, 1);
                        }
                        break;
                    case "RESULT_16325-00_2":// 血清学（ＲＦ－前々回）
                        objHistory = objRepConsult.Histories.Item(2);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_16325-00_2"]).Text = SelectStc_RF(objRepConsult.RsvNo, "16325", "00", 2, 1);
                        }
                        break;
                    case "RESULT_11020-01":// 視力（裸眼／右）
                        ((CnDataField)colCrObjects["RESULT_11020-01"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "01", 0, 1);
                        break;
                    case "RESULT_11020-01_1":// 視力（裸眼／右－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11020-01_1"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "01", 1, 1);
                        }
                        break;
                    case "RESULT_11020-01_2":// 視力（裸眼／右－前々回）
                        objHistory = objRepConsult.Histories.Item(2);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11020-01_2"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "01", 2, 1);
                        }
                        break;
                    case "RESULT_11020-02":// 視力（裸眼／左）
                        ((CnDataField)colCrObjects["RESULT_11020-02"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "02", 0, 1);
                        break;
                    case "RESULT_11020-02_1":// 視力（裸眼／左－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11020-02_1"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "02", 1, 1);
                        }
                        break;
                    case "RESULT_11020-02_2":// 視力（裸眼／左－前々回）
                        objHistory = objRepConsult.Histories.Item(2);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11020-02_2"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "02", 2, 1);
                        }
                        break;
                    case "RESULT_11022-01":// 視力（矯正／右）
                        ((CnDataField)colCrObjects["RESULT_11022-01"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "01", 0, 1);
                        break;
                    case "RESULT_11022-01_1":// 視力（矯正／右－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11022-01_1"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "01", 1, 1);
                        }
                        break;
                    case "RESULT_11022-01_2":// 視力（矯正／右－前々回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11022-01_2"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "01", 2, 1);
                        }
                        break;
                    case "RESULT_11022-02":// 視力（矯正／左）
                        ((CnDataField)colCrObjects["RESULT_11022-02"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "02", 0, 1);
                        break;
                    case "RESULT_11022-02_1":// （矯正／左－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11022-02_1"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "02", 1, 1);
                        }
                        break;
                    case "RESULT_11022-02_2":// 視力（矯正／左－前々回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11022-02_2"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "02", 2, 1);
                        }
                        break;
                    default:
                         // アンダースコアでカラム名を分割
                        vntToken = rec.Name.Split('_');
                        lngTokenCount = vntToken.Length;
                        if (lngTokenCount >= 1)
                        {
                            string rightStr = "";
                            switch (PrintCommon.ExceptReplicationSign(vntToken[0]).ToUpper())
                            {
                                case "SHORTSTC":
                                case "LONGSTC":
                                case "RESULT":
                                    rightStr = rec.Name.TrimEnd();
                                    rightStr = rightStr.Substring(rightStr.Length - 2, 2);
                                    if ("_1".Equals(rightStr) || "_2".Equals(rightStr))
                                    {
                                        if ("*".Equals(Strings.StrConv(((CnDataField)rec).Text.Substring(0, 1), VbStrConv.Narrow)))
                                        {
                                            ((CnDataField)rec).Text = "";
                                            ((CnDataField)colCrObjects[rec.Name.Replace(vntToken[0], "ABNORMALMARK")]).Text = "";
                                        }
                                    }
                                    //  団体別成績書オプション管理　----------> START
                                    bolVisible = false;
                                    bolKessei = false;
                                    bolKessei = ChkRptOpt(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_KESSEI, OBJ_INVISIBLE);
                                    switch (vntToken[1])
                                    {
                                        case "17038-00":// 血清
                                        case "17040-00":
                                            colCrObjects[Convert.ToString(vntToken[0] + "_" + vntToken[1])].Visible = !bolKessei;
                                            colCrObjects["ABNORMALMARK_ " + vntToken[1]].Visible = !bolKessei;
                                            break;
                                        case "17042-00": // HCV
                                            colCrObjects[Convert.ToString(vntToken[0] + "_" + vntToken[1])].Visible = !bolKessei;
                                            colCrObjects["ABNORMALMARK_ " + vntToken[1]].Visible = !bolKessei;
                                            //  内田洋行場合出力項目制御
                                            if ((objRepConsult.OrgCd1.Trim()+ objRepConsult.OrgCd2.Trim()).Equals("0300500000"))
                                            {
                                                colCrObjects[Convert.ToString(vntToken[0] + "_" + vntToken[1])].Visible = false;
                                                colCrObjects["ABNORMALMARK_ " + vntToken[1]].Visible = false;
                                            }
                                            break;
                                        case "16225-00":// VDRL
                                        case "16220-00":// TPHA
                                            colCrObjects[Convert.ToString(vntToken[0] + "_" + vntToken[1])].Visible = !bolKessei;
                                            colCrObjects["ABNORMALMARK_ " + vntToken[1]].Visible = !bolKessei;
                                            // ソニ－生命、内田洋行場合出力項目制御
                                            if ((objRepConsult.OrgCd1.Trim() + objRepConsult.OrgCd2.Trim()).Equals("1500800000") ||
                                                (objRepConsult.OrgCd1.Trim() + objRepConsult.OrgCd2.Trim()).Equals("1501200000") ||
                                                (objRepConsult.OrgCd1.Trim() + objRepConsult.OrgCd2.Trim()).Equals("0300500000"))
                                            {
                                                colCrObjects[Convert.ToString(vntToken[0] + "_" + vntToken[1])].Visible = false;
                                                colCrObjects["ABNORMALMARK_ " + vntToken[1]].Visible = false;
                                            }
                                            break;
                                        case "16324-00":// 前立腺 (PSA)
                                            bolVisible = ChkRptOpt(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_PSA, OBJ_INVISIBLE);
                                            colCrObjects["RESULT_16324-00"].Visible = !bolKessei;
                                            colCrObjects["ABNORMALMARK_16324-00"].Visible = !bolKessei;
                                            break;
                                            //   団体別成績書オプション管理---------- > END

                                    }
                                    break;
                                case "PRISHORTSTC":
                                    rightStr = rec.Name.TrimEnd();
                                    rightStr = rightStr.Substring(rightStr.Length - 2, 2);
                                    if ("_1".Equals(rightStr) || "_2".Equals(rightStr))
                                    {
                                        if ("*".Equals(Strings.StrConv(((CnListField)rec).ListText(0, 0).Substring(0, 1), VbStrConv.Narrow)))
                                        {
                                            ((CnListField)rec).ListText(0, 0, "");
                                        }
                                    }
                                    break;
                                case "JUDRNAME":
                                    if (Convert.ToInt16(vntToken[1]) >= 1 && Convert.ToInt16(vntToken[1]) <= 31)
                                    {
                                        if (vntToken.Length - 1 <= 1) {
                                            dynamic data = SelectJudHistoryRsl(objRepConsult.RsvNo, Convert.ToInt16(vntToken[1]), true);
                                            ((CnDataField)rec).Text = data.JUDRNAME;
                                            if (("＊＊").Equals(data.JUDRNAME.ToUpper()))
                                            {
                                                switch (Convert.ToInt16(vntToken[1]))
                                                {
                                                    case 18:
                                                        ((CnListField)colCrObjects[judResultCode[1]]).Text= "********";
                                                        ((CnListField)colCrObjects[abnormalMarkResultCode[1]]).Text = "";
                                                        break;
                                                    case 19:
                                                        ((CnListField)colCrObjects[judResultCode[2]]).Text = "********";
                                                        ((CnListField)colCrObjects[abnormalMarkResultCode[2]]).Text = "";
                                                        break;
                                                    case 21:
                                                        ((CnListField)colCrObjects["SHORTSTC_11176-00"]).Text = "＊＊＊＊＊";
                                                        ((CnListField)colCrObjects["SHORTSTC_11175-00"]).Text = "＊＊＊＊＊";
                                                        ((CnListField)colCrObjects["ABNORMALMARK_11176-00"]).Text = "";
                                                        ((CnListField)colCrObjects["ABNORMALMARK_11175-00"]).Text = "";
                                                        ((CnListField)colCrObjects["SHORTSTC_11530-00"]).Text = "＊＊＊＊＊";
                                                        break;
                                                    case 22:
                                                        ((CnListField)colCrObjects[judShortCode[1]]).Text = "＊＊＊＊＊";
                                                        ((CnListField)colCrObjects[judShortCode[2]]).Text = "＊＊＊＊＊";
                                                        ((CnListField)colCrObjects[judShortCode[3]]).Text = "＊＊＊＊＊";
                                                        ((CnListField)colCrObjects[judShortCode[4]]).Text = "＊＊＊＊＊";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[1]]).Text = "";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[2]]).Text = "";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[3]]).Text = "";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[4]]).Text = "";
                                                        break;
                                                }
                                            }
                                            if (("－－").Equals(data.JUDRNAME.ToUpper()))
                                            {
                                                switch (Convert.ToInt16(vntToken[1]))
                                                {
                                                    case 18:
                                                        ((CnListField)colCrObjects[judResultCode[1]]).Text = "検査せず";
                                                        ((CnListField)colCrObjects[abnormalMarkResultCode[1]]).Text = "";
                                                        break;
                                                    case 19:
                                                        ((CnListField)colCrObjects[judResultCode[2]]).Text = "検査せず";
                                                        ((CnListField)colCrObjects[abnormalMarkResultCode[2]]).Text = "";
                                                        break;
                                                    case 21:
                                                        ((CnListField)colCrObjects["SHORTSTC_11176-00"]).Text = "--------";
                                                        ((CnListField)colCrObjects["SHORTSTC_11175-00"]).Text = "--------";
                                                        ((CnListField)colCrObjects["ABNORMALMARK_11176-00"]).Text = "";
                                                        ((CnListField)colCrObjects["ABNORMALMARK_11175-00"]).Text = "";
                                                        ((CnListField)colCrObjects["SHORTSTC_11530-00"]).Text = "検査せず";
                                                        break;
                                                    case 22:
                                                        ((CnListField)colCrObjects[judShortCode[1]]).Text = "検査せず";
                                                        ((CnListField)colCrObjects[judShortCode[2]]).Text = "検査せず";
                                                        ((CnListField)colCrObjects[judShortCode[3]]).Text = "検査せず";
                                                        ((CnListField)colCrObjects[judShortCode[4]]).Text = "検査せず";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[1]]).Text = "";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[2]]).Text = "";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[3]]).Text = "";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[4]]).Text = "";
                                                        break;
                                                    case 28:
                                                        ((CnListField)colCrObjects["RESULT_18426-00"]).Text = "--------";
                                                        ((CnListField)colCrObjects["RESULT_18425-00"]).Text = "--------";
                                                        ((CnListField)colCrObjects["ABNORMALMARK_18426-00"]).Text = "";
                                                        ((CnListField)colCrObjects["ABNORMALMARK_18425-00"]).Text = "";
                                                        break;
                                                }
                                            }
                                        }
                                    }
                                        break;
                            }
                        }
                            break;

                }

                // 関西テレビ放送東京支社春期（ＣＥＡ有CHEST無）場合、
                // TSH、FT4をオプション項目に出力する。
                strCrObjName = (rec.Name).ToUpper();
                if (objRepConsult.OrgCd1.Equals("06035") && objRepConsult.OrgCd2.Equals("00006"))
                {
                    switch (strCrObjName)
                    {
                        case "RESULT_18426-00":
                            ((CnListField)colCrObjects[strCrObjName]).Text= "＊＊＊＊＊";
                            ((CnListField)colCrObjects["ABNORMALMARK_18426 - 00"]).Text = "";
                            break;
                        case "RESULT_18425-00":
                            ((CnListField)colCrObjects[strCrObjName]).Text = "＊＊＊＊＊";
                            ((CnListField)colCrObjects["ABNORMALMARK_18425-00"]).Text = "";
                            break;
                        case "RESULT_18426-00_1":
                            ((CnListField)colCrObjects[strCrObjName]).Text = "";
                            ((CnListField)colCrObjects["ABNORMALMARK_18426-00_1"]).Text = "";
                            break;
                        case "RESULT_18425-00_1":
                            ((CnListField)colCrObjects[strCrObjName]).Text = "";
                            ((CnListField)colCrObjects["ABNORMALMARK_18425-00_1"]).Text = "";
                            break;
                        case "RESULT_18426-00_2":
                            ((CnListField)colCrObjects[strCrObjName]).Text = "";
                            ((CnListField)colCrObjects["ABNORMALMARK_18426-00_2"]).Text = "";
                            break;
                        case "RESULT_18425-00_2":
                            ((CnListField)colCrObjects[strCrObjName]).Text = "";
                            ((CnListField)colCrObjects["ABNORMALMARK_18425-00_2"]).Text = "";
                            break;
                    }
                }
            }

            // 今回、前回、前々回受診情報
            // 今回
            ((CnDataField)colCrObjects["CSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
            dynamic IKbnName = SelectIKbnName(objRepConsult.RsvNo);
            ((CnDataField)colCrObjects["CSNAME"]).Text = objRepConsult.CsName + Convert.ToString(IKbnName.NAME).Trim();
            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (objHistory != null)
            {
                ((CnDataField)colCrObjects["CSLDATE_1"]).Text = string.Format("{0:YYYY年M月D日}", objHistory.CslDate);
                IKbnName = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCrObjects["CSNAME_1"]).Text = objHistory.CsName + Convert.ToString(IKbnName.NAME).Trim();
            }

            //  前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (objHistory != null)
            {
                ((CnDataField)colCrObjects["CSLDATE_2"]).Text = string.Format("{0:YYYY年M月D日}", objHistory.CslDate);
                IKbnName = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCrObjects["CSNAME_2"]).Text = objHistory.CsName + Convert.ToString(IKbnName.NAME).Trim();
            }

            // 乳房視触診
            bolVisible = ChkRptOpt(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_NYUBOUS, OBJ_INVISIBLE);

            // 今回
            objCrObject = colCrObjects["HUJINKA_NYUBOUS"];
            dynamic data2 = SelectJudHistoryRsl(objRepConsult.RsvNo, 54, true);
            switch (Convert.ToInt16(data2.JUDRNAME))
            {
                case "＊＊":
                    ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
                    break;
                case "－－":
                    ((CnListField)objCrObject).ListText(0, 0, "検査せず");
                    break;
                default:
                    j = 0;
                    IList <dynamic> lngRsl = SelectStc(objRepConsult.RsvNo, GRPCD_NYUBOUS);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount>0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }

                    }
                    break;
            }
            colCrObjects["HUJINKA_NYUBOUS"].Visible = !bolVisible;

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null!= objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd(objHistory.RsvNo, GRPCD_NYUBOUS);
                lngRslCount = lngRsl.Count;
                if (lngRslCount>0)
                {
                    objCrObject = colCrObjects["HUJINKA_NYUBOUS1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd(objHistory.RsvNo, GRPCD_NYUBOUS);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_NYUBOUS2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }
            colCrObjects["HUJINKA_NYUBOUS2"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ"))
            {
                colCrObjects["HUJINKA_NYUBOUS2"].Visible = !bolVisible;
            }

            // 乳房Ｘ線検査 --------------------------------------------
            objCrObject = colCrObjects["HUJINKA_NYUBOUX"];
            data2 = SelectJudHistoryRsl(objRepConsult.RsvNo, 55, true);
            switch (Convert.ToInt16(data2.JUDRNAME))
            {
                case "＊＊":
                    ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
                    break;
                case "－－":
                    ((CnListField)objCrObject).ListText(0, 0, "検査せず");
                    break;
                default:
                    j = 0;
                    IList<dynamic> lngRsl = SelectStc(objRepConsult.RsvNo, GRPCD_NYUBOUX);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        i = 0;
                        while (!((i > (lngRslCount - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(0, j, lngRsl[i].LONGSTC.Trim());
                                j++;
                            }
                            i++;
                        }
                    }
                        break;
            }

            bolVisible = ChkRptOpt(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_NYUBOUX, OBJ_VISIBLE);
            if (bolVisible && CtrChkOrg(objRepConsult.OrgCd1, objRepConsult.OrgCd2))
            {
                bolVisible = OrgPriceItem(objRepConsult.RsvNo, OPTION_NYUBOUX, OPRICE_NYUBOUX, OPRICE_NYUBOUX + OPRICE_ECHO);
            }
            objCrObject.Visible = bolVisible;

            // 乳房超音波検査  =====================================================
            objCrObject = colCrObjects["HUJINKA_NYUBOU"];
            data2 = SelectJudHistoryRsl(objRepConsult.RsvNo, 56, true);
            switch (Convert.ToInt16(data2.JUDRNAME))
            {
                case "＊＊":
                    ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
                    break;
                case "－－":
                    ((CnListField)objCrObject).ListText(0, 0, "検査せず");
                    break;
                default:
                    j = 0;
                    k = 0;
                    if (!"".Equals(((CnDataField)colCrObjects["SHORTSTC_28700-01"]).Text.TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(0, j, ((CnDataField)colCrObjects["SHORTSTC_28700-01"]).Text);
                        j++;
                    }
                    if (!"".Equals(((CnDataField)colCrObjects["SHORTSTC_28700-02"]).Text.TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(0, j, ((CnDataField)colCrObjects["SHORTSTC_28700-02"]).Text);
                        j++;
                    }
                    IList<dynamic> lngRsl = SelectStc_3rd(objRepConsult.RsvNo, GRPCD_NYUBOU);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        i = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }
                    }
                    break;
            }
            bolVisible = ChkRptOpt(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_NYUBOU, OBJ_VISIBLE);
            if (bolVisible && CtrChkOrg(objRepConsult.OrgCd1, objRepConsult.OrgCd2))
            {
                bolVisible = OrgPriceItem(objRepConsult.RsvNo, OPTION_ECHO, OPRICE_ECHO, OPRICE_NYUBOUX + OPRICE_ECHO);
            }
            objCrObject.Visible = bolVisible;

            // '婦人科(診断・頚部細胞診) ***********************************************************************
            if (ChkFreeNPRT(objRepConsult.OrgCd1, objRepConsult.OrgCd2, objRepConsult.CsCd, Convert.ToString(FUJIN_JUDCLASSCD)))
            {
                bolVisible = true;
            }
            else
            {
                bolVisible = ChkRptOpt(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_FUJIN, OBJ_INVISIBLE);
            }

            // '-------------1.婦人科(頚部細胞診-診断) ----------------------------------------
            // 今回
            objCrObject = colCrObjects["HUJINKA_KEIBU"];
            if (((CnDataField)colCrObjects["JUDRNAME_31"]).Text.Equals("＊＊"))
            {
                ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
            }
            else
            {
                if (((CnDataField)colCrObjects["JUDRNAME_31"]).Text.Equals("－－"))
                {
                    ((CnListField)objCrObject).ListText(0, 0, "検査せず");
                }
                else
                {
                    IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objRepConsult.RsvNo, FU_SINDAN_CODE, FU_FCLASS_KEBU);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount>0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }
                        if (lngRslCount>2)
                        {
                            colCrObjects["Line207"].Visible = true;
                        }
                    }
                }
            }

            objCrObject.Visible = !bolVisible;

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_SINDAN_CODE, FU_FCLASS_KEBU);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_KEIBU1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                    if (lngRslCount > 2)
                    {
                        colCrObjects["Line207"].Visible = true;
                    }
                }
            }

            colCrObjects["HUJINKA_KEIBU1"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ") ||  HISTORYVIEW.Equals("Z"))
            {
                colCrObjects["HUJINKA_KEIBU1"].Visible = !bolVisible;
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_SINDAN_CODE, FU_FCLASS_KEBU);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_KEIBU2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                    if (lngRslCount > 2)
                    {
                        colCrObjects["Line207"].Visible = true;
                    }
                }
            }

            colCrObjects["HUJINKA_KEIBU2"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ"))
            {
                colCrObjects["HUJINKA_KEIBU2"].Visible = !bolVisible;
            }

            // -------------2.婦人科(ベセスダ分類) ----------------------------------------
            // 婦人科ベセスダ分類表記変更に伴うシステム変更 STR ###
            // 今回
            objCrObject = colCrObjects["HUJINKA_BETHESDA"];
            objCrObject1 = colCrObjects["HUJINKA_BETHESDA_RPT"];
            if (((CnDataField)colCrObjects["JUDRNAME_31"]).Text.Equals("＊＊"))
            {
                ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
                ((CnListField)objCrObject1).ListText(0, 0, "＊＊＊＊＊");
            }
            else
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objRepConsult.RsvNo, FU_BETHE_CODE, "");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].SHORTSTC.Trim());
                            ((CnListField)objCrObject1).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                   
                }
            }
            objCrObject.Visible = !bolVisible;
            objCrObject1.Visible = !bolVisible;

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_BETHE_CODE, "");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_BETHESDA1"];
                    objCrObject1 = colCrObjects["HUJINKA_BETHESDA_RPT1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].SHORTSTC.Trim());
                            ((CnListField)objCrObject1).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            colCrObjects["HUJINKA_BETHESDA1"].Visible = false;
            colCrObjects["HUJINKA_BETHESDA_RPT1"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ") || HISTORYVIEW.Equals("Z"))
            {
                colCrObjects["HUJINKA_BETHESDA1"].Visible = !bolVisible;
                colCrObjects["HUJINKA_BETHESDA_RPT1"].Visible = !bolVisible;
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_BETHE_CODE, "");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_BETHESDA2"];
                    objCrObject1 = colCrObjects["HUJINKA_BETHESDA_RPT2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].SHORTSTC.Trim());
                            ((CnListField)objCrObject1).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            colCrObjects["HUJINKA_BETHESDA2"].Visible = false;
            colCrObjects["HUJINKA_BETHESDA_RPT2"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ"))
            {
                colCrObjects["HUJINKA_BETHESDA2"].Visible = !bolVisible;
                colCrObjects["HUJINKA_BETHESDA_RPT2"].Visible = !bolVisible;
            }
            // 婦人科ベセスダ分類表記変更に伴うシステム変更 END ###


            // -------------2.婦人科(クラス分類) ----------------------------------------
            // 今回
            objCrObject = colCrObjects["HUJINKA_CLASS"];
            if (((CnDataField)colCrObjects["JUDRNAME_31"]).Text.Equals("＊＊"))
            {
                ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
            }
            else
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objRepConsult.RsvNo, FU_CLASS_CODE, FU_FCLASS_CLASS);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }
            objCrObject.Visible = !bolVisible;

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_CLASS_CODE, FU_FCLASS_CLASS);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_CLASS1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            colCrObjects["HUJINKA_CLASS1"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ") || HISTORYVIEW.Equals("Z"))
            {
                colCrObjects["HUJINKA_CLASS1"].Visible = !bolVisible;
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_CLASS_CODE, FU_FCLASS_CLASS);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_CLASS2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            colCrObjects["HUJINKA_CLASS2"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ"))
            {
                colCrObjects["HUJINKA_CLASS2"].Visible = !bolVisible;
            }


            // ------------- 婦人科(内診所見) ----------------------------------------------
            // 今回
            objCrObject = colCrObjects["HUJINKA_NASHOKEN"];
            if (((CnDataField)colCrObjects["JUDRNAME_30"]).Text.Equals("＊＊"))
            {
                ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
            }
            else
            {
                if (((CnDataField)colCrObjects["JUDRNAME_30"]).Text.Equals("－－"))
                {
                    ((CnListField)objCrObject).ListText(0, 0, "検査せず");
                }
                else
                {
                    IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objRepConsult.RsvNo, FU_NAISIN_CODE, "");
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }
                        if (lngRslCount > 3)
                        {
                            colCrObjects["Line200"].Visible = true;
                        }
                    }
                }
            }
            objCrObject.Visible = !bolVisible;

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_NAISIN_CODE, "");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_NASHOKEN1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                    if (lngRslCount > 3)
                    {
                        colCrObjects["Line200"].Visible = true;
                    }
                }
            }

            colCrObjects["HUJINKA_NASHOKEN1"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ") || HISTORYVIEW.Equals("Z"))
            {
                colCrObjects["HUJINKA_NASHOKEN1"].Visible = !bolVisible;
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_NAISIN_CODE, "");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_NASHOKEN2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                    if (lngRslCount > 3)
                    {
                        colCrObjects["Line200"].Visible = true;
                    }
                }
                // 婦人科診察前々回結果印刷出来ない不具合対応 END   ########################################
            }

            colCrObjects["HUJINKA_NASHOKEN2"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ"))
            {
                colCrObjects["HUJINKA_NASHOKEN2"].Visible = !bolVisible;
            }


            // -------------( 婦人科内診-診断 )----------------------------------------
            // 今回
            objCrObject = colCrObjects["HUJINKA_NAISIN"];
            if (((CnDataField)colCrObjects["JUDRNAME_30"]).Text.Equals("＊＊"))
            {
                ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
            }
            else
            {
                if (((CnDataField)colCrObjects["JUDRNAME_30"]).Text.Equals("－－"))
                {
                    ((CnListField)objCrObject).ListText(0, 0, "検査せず");
                }
                else
                {
                    IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objRepConsult.RsvNo, FU_SINDAN_CODE, "NAISIN");
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }
                    }
                }
            }

            objCrObject.Visible = !bolVisible;

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_SINDAN_CODE, "NAISIN");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_NAISIN1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            colCrObjects["HUJINKA_NAISIN1"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ") || HISTORYVIEW.Equals("Z"))
            {
                colCrObjects["HUJINKA_NAISIN1"].Visible = !bolVisible;
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_SINDAN_CODE, "NAISIN");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_NAISIN2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            colCrObjects["HUJINKA_NAISIN2"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ"))
            {
                colCrObjects["HUJINKA_NAISIN2"].Visible = !bolVisible;
            }

            // 眼底
            // 今回
            objCrObject = colCrObjects["GANTEI_SYOKEN"];
            if (((CnDataField)colCrObjects["JUDRNAME_21"]).Text.Equals("＊＊"))
            {
          
            }
            else
            {
                if (((CnDataField)colCrObjects["JUDRNAME_21"]).Text.Equals("－－"))
                {

                }
                else
                {
                    IList<dynamic> lngRsl = SelectStc_2nd(objRepConsult.RsvNo, GRPCD_GANTEI);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListRows.Count() - 1)))
                        {
                            j = 0;
                            while (!((i > (lngRslCount - 1)) || (j > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                            {
                                if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                                {
                                    ((CnListField)objCrObject).ListText(j, k, lngRsl[i].LONGSTC.Trim());
                                    j++;
                                }
                                i++;
                            }
                            k++;
                        }
                    }
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd(objHistory.RsvNo, GRPCD_GANTEI);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["GANTEI_SYOKEN1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListRows.Count() - 1)))
                    {
                        j = 0;
                        while (!((i > (lngRslCount - 1)) || (j > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(j,k, lngRsl[i].LONGSTC.Trim());
                                j++;
                            }
                            i++;
                        }
                        k++;
                    }
                }
            }
            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd(objHistory.RsvNo, GRPCD_GANTEI);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["GANTEI_SYOKEN2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListRows.Count() - 1)))
                    {
                        j = 0;
                        while (!((i > (lngRslCount - 1)) || (j > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(j, k, lngRsl[i].LONGSTC.Trim());
                                j++;
                            }
                            i++;
                        }
                        k++;
                    }
                }
            }

            // 判定用項目の可否設定
            colCrObjects["JUDRNAME_11"].Visible = false;
            colCrObjects["JUDRNAME_12"].Visible = false;
            colCrObjects["JUDRNAME_13"].Visible = false;
            colCrObjects["JUDRNAME_14"].Visible = false;
            colCrObjects["JUDRNAME_15"].Visible = false;
            colCrObjects["JUDRNAME_16"].Visible = false;
            colCrObjects["JUDRNAME_17"].Visible = false;
            colCrObjects["JUDRNAME_18"].Visible = false;
            colCrObjects["JUDRNAME_19"].Visible = false;
            colCrObjects["JUDRNAME_20"].Visible = false;
            colCrObjects["JUDRNAME_21"].Visible = false;
            colCrObjects["JUDRNAME_22"].Visible = false;
            colCrObjects["JUDRNAME_23"].Visible = false;
            colCrObjects["JUDRNAME_24"].Visible = false;
            colCrObjects["JUDRNAME_25"].Visible = false;
            colCrObjects["JUDRNAME_28"].Visible = false;
            colCrObjects["SHORTSTC_28700-01"].Visible = false;
            colCrObjects["SHORTSTC_28700-02"].Visible = false;
            if (objRepConsult.CslDate < Convert.ToDateTime("2005/01/07"))
            {
                colCrObjects["Label20050107-TSH"].Visible = false;
                colCrObjects["Label20050107-FT4"].Visible = false;
                colCrObjects["Label20050106-TSH"].Visible = true;
                colCrObjects["Label20050106-FT4"].Visible = true;
                if (objRepConsult.CslDate < Convert.ToDateTime("2004/07/20"))
                {
                    colCrObjects["LBL20040719"].Visible = true;
                    colCrObjects["LBL20040720"].Visible = false;
                }
                else
                {
                    colCrObjects["LBL20040719"].Visible = false;
                    colCrObjects["LBL20040720"].Visible = true;
                }
            }
            else
            {
                colCrObjects["Label20050107-TSH"].Visible = true;
                colCrObjects["Label20050107-FT4"].Visible = true;
                colCrObjects["LBL20040720"].Visible = true;
                colCrObjects["Label20050106-TSH"].Visible = false;
                colCrObjects["Label20050106-FT4"].Visible = false;
                colCrObjects["LBL20040719"].Visible = false;

            }

            if (objRepConsult.CslDate < Convert.ToDateTime("2004/10/30"))
            {
                colCrObjects["Label20041029"].Visible = true;
                colCrObjects["Label20041030"].Visible = false;
            }
            else
            {
                colCrObjects["Label20041029"].Visible = false;
                colCrObjects["Label20041030"].Visible = true;
            }
            // 指定団体グループ以外の団体名・社員番号を非表示とする処理
            Boolean blnOrgGrp = SelectOrgGrp(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_ORGGRP);
            if (blnOrgGrp)
            {
                colCrObjects["LBLEMPNO"].Visible = true;
                colCrObjects["EMPNO"].Visible = true;
            }
            else
            {
                colCrObjects["LBLEMPNO"].Visible = false;
                colCrObjects["EMPNO"].Visible = false;
            }

            Boolean blnOrgIns = SelectOrgIns(objRepConsult.OrgCd1, objRepConsult.OrgCd2);
            if (blnOrgIns)
            {
                colCrObjects["LBLISRSIGN"].Visible = true;
                colCrObjects["ISRSIGN"].Visible = true;
                colCrObjects["LBLISRNO"].Visible = true;
                colCrObjects["ISRNO"].Visible = true;
            }
            else
            {
                colCrObjects["LBLISRSIGN"].Visible = false;
                colCrObjects["ISRSIGN"].Visible = false;
                colCrObjects["LBLISRNO"].Visible = false;
                colCrObjects["ISRNO"].Visible = false;
            }
        }

        /// <summary>
        /// オプション検査結果表の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3N323_Option(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// オプション検査結果表の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3N323_Option_20130401(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// オプション検査結果表の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3N323_Option_2017(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {
            CnObjects colCnObjects;                        // 描画オブジェクトのコレクション
            CnObject objCnObject;                          // 描画オブジェクト
            RepHistory objHistory;                         // 受診履歴クラス
            IList<string> vntLongStc;                      // 文章
            IList<string> vntToken;                        // トークン
            IList<dynamic> lngRsl;                          // 文章,トークン

            int lngTokenCount;                             // トークン数
            int lngRslCount;                               // 結果件数
            String strIKbn;                                // 胃区分12
            String strSeq;                                 // SEQ
            String strJudCd;
            String strJudRName;
            String strSize;
            int i;
            short j;
            short k;
            Boolean bolVisible;
            string[] judPriCode = new string[2];           // 固定ロジック用

            string[] judShortCode = new string[5];

            string[] abnormalMarkShortCode = new string[5];
            RepResult objResult;                          // 検査結果クラス

            // 描画オブジェクトコレクションの参照設定
            colCnObjects = cnForm.CnObjects;

            // 今回
            ((CnDataField)colCnObjects["EDITCSLDATE"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);
            ((CnDataField)colCnObjects["DAYID1"]).Text = objRepConsult.DayId;
            dynamic IKbnName = SelectIKbnName(objRepConsult.RsvNo);
            ((CnDataField)colCnObjects["EDITCSNAME"]).Text = objRepConsult.CsName + Convert.ToString(IKbnName.NAME).Trim();

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                ((CnDataField)colCnObjects["EDITCSLDATE_1"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);
                IKbnName = SelectIKbnName(objRepConsult.RsvNo);
                ((CnDataField)colCnObjects["EDITCSNAME_1"]).Text = objRepConsult.CsName + Convert.ToString(IKbnName.NAME).Trim();
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                ((CnDataField)colCnObjects["EDITCSLDATE_2"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);
                IKbnName = SelectIKbnName(objRepConsult.RsvNo);
                ((CnDataField)colCnObjects["EDITCSNAME_2"]).Text = objRepConsult.CsName + Convert.ToString(IKbnName.NAME).Trim();
            }

            bolVisible = ChkRptOpt(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_3DCT, OBJ_VISIBLE);
            foreach (CnObject rec in colCnObjects)
            {
                switch (rec.Name.ToUpper())
                {
                    case "RESULT_17580-01": // 抗核抗体
                        if (("").Equals(SelectStc_RF(objRepConsult.RsvNo, "17580", "01", 0, 1).Trim()))
                        {
                            ((CnDataField)colCnObjects["RESULT_17580-01"]).Text = SelectStc_RF(objRepConsult.RsvNo, "17580", "01", 0, 1);
                        }
                        break;
                    case "RESULT_17580-01_1": // 抗核抗体（前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            if (("").Equals(SelectStc_RF(objRepConsult.RsvNo, "17580", "01", 1, 1).Trim()))
                            {
                                ((CnDataField)colCnObjects["RESULT_17580-01_1"]).Text = SelectStc_RF(objRepConsult.RsvNo, "17580", "01", 1, 1);
                            }
                        }
                        break;
                    case "RESULT_17580-01_2": // 抗核抗体（前々回）
                        objHistory = objRepConsult.Histories.Item(2);
                        if (null != objHistory)
                        {
                            if (("").Equals(SelectStc_RF(objRepConsult.RsvNo, "17580", "01", 2, 1).Trim()))
                            {
                                ((CnDataField)colCnObjects["RESULT_17580-01_1"]).Text = SelectStc_RF(objRepConsult.RsvNo, "17580", "01", 2, 1);
                            }
                        }
                        break;

                    case "RESULT_40060-00": // 抗ＣＣＰ抗体
                        if (("").Equals(SelectStc_RF(objRepConsult.RsvNo, "40060", "00", 0, 1).Trim()))
                        {
                            ((CnDataField)colCnObjects["RESULT_40060-00"]).Text = SelectStc_RF(objRepConsult.RsvNo, "40060", "00", 0, 1);
                        }
                        break;
                    case "RESULT_40060-00_1": // 抗ＣＣＰ抗体（前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            if (("").Equals(SelectStc_RF(objRepConsult.RsvNo, "40060", "00", 1, 1).Trim()))
                            {
                                ((CnDataField)colCnObjects["RESULT_40060-00_1"]).Text = SelectStc_RF(objRepConsult.RsvNo, "40060", "00", 1, 1);
                            }
                        }
                        break;
                    case "RESULT_40060-00_2": // 抗ＣＣＰ抗体（前々回）
                        objHistory = objRepConsult.Histories.Item(2);
                        if (null != objHistory)
                        {
                            if (("").Equals(SelectStc_RF(objRepConsult.RsvNo, "40060", "00", 2, 1).Trim()))
                            {
                                ((CnDataField)colCnObjects["RESULT_40060-00_2"]).Text = SelectStc_RF(objRepConsult.RsvNo, "40060", "00", 2, 1);
                            }
                        }
                        break;
                }
            }

            // 大腸３Ｄ－ＣＴ
            // 今回
            objCnObject = colCnObjects["DAICYOCT"];
            dynamic data = SelectJudHistoryRsl(objRepConsult.RsvNo, 33, true);
            switch (Convert.ToInt16(data.JUDRNAME))
            {
                case "＊＊":
                    ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    break;
                case "－－":
                    ((CnListField)objCnObject).ListText(0, 0, "検査せず");
                    break;
                default:
                    lngRsl = SelectStc_StcCd(objRepConsult.RsvNo, GRPCD_DAICYO_CT);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCnObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                strSize = "";

                                switch (lngRsl[i].STCCD.Trim())
                                {
                                    case "1001":
                                        if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23820-00"]).Text.Trim())))
                                        {
                                            strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23820-00"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23820-00"]).Text.Trim();
                                        }
                                         ((CnListField)objCnObject).ListText(k, j, lngRsl[i].LONGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["SHORTSTC_23830-00"]).Text.Trim());
                                        break;
                                    case "2001":
                                        if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23850-00"]).Text.Trim())))
                                        {
                                            strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23850-00"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23850-00"]).Text.Trim();
                                        }
                                         ((CnListField)objCnObject).ListText(k, j, lngRsl[i].LONGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["SHORTSTC_23860-00"]).Text.Trim());
                                        break;
                                    case "3001":
                                        if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23880-00"]).Text.Trim())))
                                        {
                                            strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23880-00"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23880-00"]).Text.Trim();
                                        }
                                         ((CnListField)objCnObject).ListText(k, j, lngRsl[i].LONGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["SHORTSTC_23890-00"]).Text.Trim());
                                        break;
                                    case "4001":
                                        if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23920-00"]).Text.Trim())))
                                        {
                                            strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23920-00"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23920-00"]).Text.Trim();
                                        }
                                         ((CnListField)objCnObject).ListText(k, j, lngRsl[i].LONGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["SHORTSTC_23930-00"]).Text.Trim());
                                        break;
                                    case "5001":
                                        if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23950-00"]).Text.Trim())))
                                        {
                                            strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23950-00"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23950-00"]).Text.Trim();
                                        }
                                         ((CnListField)objCnObject).ListText(k, j, lngRsl[i].LONGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["SHORTSTC_23960-00"]).Text.Trim());
                                        break;
                                    default:
                                        ((CnListField)objCnObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                                        break;
                                }
                                j++;
                                if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }

                    }
                    ((CnDataField)colCnObjects["RESULT_23981-00"]).Text = string.Format("{0:YYYY年M月D日}", DateTime.ParseExact(((CnDataField)colCnObjects["RESULT_23981-00"]).Text, "yyyy/MM/dd", System.Globalization.CultureInfo.InvariantCulture)) + "";
                    break;
            }

            // オプション検査印刷有無チェック結果反映
            objCnObject.Visible = bolVisible;
            ((CnDataField)colCnObjects["RESULT_23981-00"]).Visible = bolVisible;

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                lngRsl = SelectStc_StcCd(objRepConsult.RsvNo, GRPCD_DAICYO_CT);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCnObject = colCnObjects["DAICYOCT1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCnObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            strSize = "";

                            switch (lngRsl[i].STCCD.Trim())
                            {
                                case "1001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23820-00_1"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23820-00_1"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23820-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].LONGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["SHORTSTC_23830-00_1"]).Text.Trim());
                                    break;
                                case "2001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23850-00_1"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23850-00_1"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23850-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].LONGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["SHORTSTC_23860-00_1"]).Text.Trim());
                                    break;
                                case "3001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23880-00_1"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23880-00_1"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23880-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].LONGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["SHORTSTC_23890-00_1"]).Text.Trim());
                                    break;
                                case "4001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23920-00_1"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23920-00_1"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23920-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].LONGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["SHORTSTC_23930-00_1"]).Text.Trim());
                                    break;
                                case "5001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23950-00_1"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23950-00_1"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23950-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].LONGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["SHORTSTC_23960-00_1"]).Text.Trim());
                                    break;
                                default:
                                    ((CnListField)objCnObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                                    break;
                            }
                            j++;
                            if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }

                }
                else
                {
                    objResult = objHistory.Results.Item("23970-01");
                    if (null != objResult)
                    {
                        objCnObject = colCnObjects["DAICYOCT1"];
                        ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    }
                }
                ((CnDataField)colCnObjects["RESULT_23981-00_1"]).Text = string.Format("{0:YYYY年M月D日}", DateTime.ParseExact(((CnDataField)colCnObjects["RESULT_23981-00_1"]).Text, "yyyy/MM/dd", System.Globalization.CultureInfo.InvariantCulture)) + "";
            }

            // オプション検査印刷有無チェック結果反映
            colCnObjects["DAICYOCT1"].Visible = false;
            colCnObjects["RESULT_23981-00_1"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ") || HISTORYVIEW.Equals("Z"))
            {
                colCnObjects["DAICYOCT1"].Visible = bolVisible;
                colCnObjects["RESULT_23981-00_1"].Visible = bolVisible;
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                lngRsl = SelectStc_StcCd(objRepConsult.RsvNo, GRPCD_DAICYO_CT);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCnObject = colCnObjects["DAICYOCT2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCnObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            strSize = "";

                            switch (lngRsl[i].STCCD.Trim())
                            {
                                case "1001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23820-00_2"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23820-00_2"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23820-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].LONGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["SHORTSTC_23830-00_2"]).Text.Trim());
                                    break;
                                case "2001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23850-00_2"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23850-00_2"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23850-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].LONGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["SHORTSTC_23860-00_2"]).Text.Trim());
                                    break;
                                case "3001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23880-00_2"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23880-00_2"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23880-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].LONGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["SHORTSTC_23890-00_2"]).Text.Trim());
                                    break;
                                case "4001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23920-00_2"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23920-00_2"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23920-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].LONGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["SHORTSTC_23930-00_2"]).Text.Trim());
                                    break;
                                case "5001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23950-00_2"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23950-00_2"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23950-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].LONGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["SHORTSTC_23960-00_2"]).Text.Trim());
                                    break;
                                default:
                                    ((CnListField)objCnObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                                    break;
                            }
                            j++;
                            if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }

                }
                else
                {
                    objResult = objHistory.Results.Item("23970-01");
                    if (null != objResult)
                    {
                        objCnObject = colCnObjects["DAICYOCT2"];
                        ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    }
                }
                ((CnDataField)colCnObjects["RESULT_23981-00_2"]).Text = string.Format("{0:YYYY年M月D日}", DateTime.ParseExact(((CnDataField)colCnObjects["RESULT_23981-00_2"]).Text, "yyyy/MM/dd", System.Globalization.CultureInfo.InvariantCulture)) + "";
            }

            // オプション検査印刷有無チェック結果反映
            colCnObjects["DAICYOCT2"].Visible = false;
            colCnObjects["RESULT_23981-00_2"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ"))
            {
                colCnObjects["DAICYOCT2"].Visible = bolVisible;
                colCnObjects["RESULT_23981-00_2"].Visible = bolVisible;
            }

            // 頸動脈超音波
            // オプション検査印刷有無チェック
            bolVisible = ChkRptOpt(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_KEICHOU, OBJ_VISIBLE);
            // 今回
            lngRsl = SelectStc_StcCd(objRepConsult.RsvNo, GRPCD_PLAQUE);
            ((CnDataField)colCnObjects["PLAQUE"]).Text = "";
            lngRslCount = lngRsl.Count;
            if (lngRslCount > 0)
            {
                i = 0;
                while (!(i > (lngRslCount - 1)))
                {
                    if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).Trim()))
                    {
                        if (((CnDataField)colCnObjects["PLAQUE"]).Text.Trim() != Convert.ToString(lngRsl[i].LONGSTC).Trim())
                        {
                            ((CnDataField)colCnObjects["PLAQUE"]).Text = Convert.ToString(lngRsl[i].LONGSTC).Trim();
                        }
                        if (lngRsl[i].STCCD.Trim().Substring(3, 2).Equals("01"))
                        {
                            break;
                        }
                    }
                    i++;
                }

            }

            // オプション検査印刷有無チェック結果反映
            ((CnDataField)colCnObjects["PRISHORTSTC_22510-01_22510-02_22510-03_22510-04"]).Visible = bolVisible;
            ((CnDataField)colCnObjects["RESULT_22520-00"]).Visible = bolVisible;
            ((CnDataField)colCnObjects["RESULT_22620-00"]).Visible = bolVisible;
            ((CnDataField)colCnObjects["RESULT_22521-00"]).Visible = bolVisible;
            ((CnDataField)colCnObjects["RESULT_22621-00"]).Visible = bolVisible;
            ((CnDataField)colCnObjects["PLAQUE"]).Visible = bolVisible;

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                lngRsl = SelectStc_StcCd(objRepConsult.RsvNo, GRPCD_PLAQUE);
                lngRslCount = lngRsl.Count;
                ((CnDataField)colCnObjects["PLAQUE1"]).Text = "";
                if (lngRslCount > 0)
                {
                    i = 0;
                    while (!(i > (lngRslCount - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).Trim()))
                        {
                            if (((CnDataField)colCnObjects["PLAQUE1"]).Text.Trim() != Convert.ToString(lngRsl[i].LONGSTC).Trim())
                            {
                                ((CnDataField)colCnObjects["PLAQUE1"]).Text = Convert.ToString(lngRsl[i].LONGSTC).Trim();
                            }
                            if (lngRsl[i].STCCD.Trim().Substring(3, 2).Equals("01"))
                            {
                                break;
                            }
                        }
                        i++;
                    }

                }
            }

            // オプション検査印刷有無チェック結果反映
            colCnObjects["PRISHORTSTC_22510-01_22510-02_22510-03_22510-04_1"].Visible = false;
            colCnObjects["RESULT_22520-00_1"].Visible = false;
            colCnObjects["RESULT_22620-00_1"].Visible = false;
            colCnObjects["RESULT_22521-00_1"].Visible = false;
            colCnObjects["RESULT_22621-00_1"].Visible = false;
            colCnObjects["PLAQUE1"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ") || HISTORYVIEW.Equals("Z"))
            {
                colCnObjects["PRISHORTSTC_22510-01_22510-02_22510-03_22510-04_1"].Visible = bolVisible;
                colCnObjects["RESULT_22520-00_1"].Visible = bolVisible;
                colCnObjects["RESULT_22620-00_1"].Visible = bolVisible;
                colCnObjects["RESULT_22521-00_1"].Visible = bolVisible;
                colCnObjects["RESULT_22621-00_1"].Visible = bolVisible;
                colCnObjects["PLAQUE1"].Visible = bolVisible;
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                lngRsl = SelectStc_StcCd(objRepConsult.RsvNo, GRPCD_PLAQUE);
                lngRslCount = lngRsl.Count;
                ((CnDataField)colCnObjects["PLAQUE2"]).Text = "";
                if (lngRslCount > 0)
                {
                    i = 0;
                    while (!(i > (lngRslCount - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).Trim()))
                        {
                            if (((CnDataField)colCnObjects["PLAQUE2"]).Text.Trim() != Convert.ToString(lngRsl[i].LONGSTC).Trim())
                            {
                                ((CnDataField)colCnObjects["PLAQUE2"]).Text = Convert.ToString(lngRsl[i].LONGSTC).Trim();
                            }
                            if (lngRsl[i].STCCD.Trim().Substring(3, 2).Equals("01"))
                            {
                                break;
                            }
                        }
                        i++;
                    }

                }
            }

            // オプション検査印刷有無チェック
            bolVisible = ChkRptOpt(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_FUJINKAECHO, OBJ_VISIBLE);

            objCnObject = colCnObjects["FUJINKA_ECHO"];
            // 婦人科超音波の判定結果取得
            data = SelectJudHistoryRsl(objRepConsult.RsvNo, 38, true);
            switch (data.JUDRNAME)
            {
                case "＊＊":
                    ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    break;
                case "－－":
                    ((CnListField)objCnObject).ListText(0, 0, "検査せず");
                    break;
                default: // 婦人科超音波所見として出力する検査結果を読み込む
                    lngRsl = SelectStc(objRepConsult.RsvNo, GRPCD_FUJINKA_ECHO);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCnObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCnObject).ListText(k, j, Convert.ToString(lngRsl[i].LONGSTC).Trim());
                                j++;
                                if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }

                    }
                    break;
            }
            objCnObject.Visible = bolVisible;

            // 前回
            objCnObject = colCnObjects["FUJINKA_ECHO1"];
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                // 婦人科超音波所見として出力する検査結果を読み込む
                lngRsl = SelectStc(objRepConsult.RsvNo, GRPCD_FUJINKA_ECHO);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCnObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCnObject).ListText(k, j, Convert.ToString(lngRsl[i].LONGSTC).Trim());
                            j++;
                            if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }

                }
                else
                {
                    objResult = objHistory.Results.Item("22802-01");
                    if (null != objResult)
                    {
                        ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    }
                }
            }
            objCnObject.Visible = false;
            if (HISTORYVIEW.Equals("ZZ") || HISTORYVIEW.Equals("Z"))
            {
                objCnObject.Visible = bolVisible;
            }

            // 前々回
            objCnObject = colCnObjects["FUJINKA_ECHO2"];
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                // 婦人科超音波所見として出力する検査結果を読み込む
                lngRsl = SelectStc(objRepConsult.RsvNo, GRPCD_FUJINKA_ECHO);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCnObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCnObject).ListText(k, j, Convert.ToString(lngRsl[i].LONGSTC).Trim());
                            j++;
                            if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }

                }
                else
                {
                    objResult = objHistory.Results.Item("22802-01");
                    if (null != objResult)
                    {
                        ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    }
                }
            }
            objCnObject.Visible = false;
            if (HISTORYVIEW.Equals("ZZ"))
            {
                objCnObject.Visible = bolVisible;
            }

            // オプション検査印刷有無チェック結果反映
            colCnObjects["PRISHORTSTC_22510-01_22510-02_22510-03_22510-04_2"].Visible = false;
            colCnObjects["RESULT_22520-00_2"].Visible = false;
            colCnObjects["RESULT_22620-00_2"].Visible = false;
            colCnObjects["RESULT_22521-00_2"].Visible = false;
            colCnObjects["RESULT_22621-00_2"].Visible = false;
            colCnObjects["PLAQUE2"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ"))
            {
                colCnObjects["PRISHORTSTC_22510-01_22510-02_22510-03_22510-04_2"].Visible = bolVisible;
                colCnObjects["RESULT_22520-00_2"].Visible = bolVisible;
                colCnObjects["RESULT_22620-00_2"].Visible = bolVisible;
                colCnObjects["RESULT_22521-00_2"].Visible = bolVisible;
                colCnObjects["RESULT_22621-00_2"].Visible = bolVisible;
                colCnObjects["PLAQUE2"].Visible = bolVisible;
            }

            // On Error Resume Next
            // 頸動脈超音波：基準マークの可視状態を検査結果と合わせる
            colCnObjects["ABNORMALMARK_22520-00"].Visible = colCnObjects["RESULT_22520-00"].Visible;
            colCnObjects["ABNORMALMARK_22620-00"].Visible = colCnObjects["RESULT_22620-00"].Visible;
            colCnObjects["ABNORMALMARK_22521-00"].Visible = colCnObjects["RESULT_22521-00"].Visible;
            colCnObjects["ABNORMALMARK_22621-00"].Visible = colCnObjects["RESULT_22621-00"].Visible;
            colCnObjects["ABNORMALMARK_22520-00_1"].Visible = colCnObjects["RESULT_22520-00_1"].Visible;
            colCnObjects["ABNORMALMARK_22620-00_1"].Visible = colCnObjects["RESULT_22620-00_1"].Visible;
            colCnObjects["ABNORMALMARK_22521-00_1"].Visible = colCnObjects["RESULT_22521-00_1"].Visible;
            colCnObjects["ABNORMALMARK_22621-00_1"].Visible = colCnObjects["RESULT_22621-00_1"].Visible;
            colCnObjects["ABNORMALMARK_22520-00_2"].Visible = colCnObjects["RESULT_22520-00_2"].Visible;
            colCnObjects["ABNORMALMARK_22620-00_2"].Visible = colCnObjects["RESULT_22620-00_2"].Visible;
            colCnObjects["ABNORMALMARK_22521-00_2"].Visible = colCnObjects["RESULT_22521-00_2"].Visible;
            colCnObjects["ABNORMALMARK_22621-00_2"].Visible = colCnObjects["RESULT_22621-00_2"].Visible;
            
            colCnObjects["RESULT_23820-00"].Visible = false;
            colCnObjects["RESULT_23850-00"].Visible = false;
            colCnObjects["RESULT_23880-00"].Visible = false;
            colCnObjects["RESULT_23920-00"].Visible = false;
            colCnObjects["RESULT_23950-00"].Visible = false;

            colCnObjects["SHORTSTC_23830-00"].Visible = false;
            colCnObjects["SHORTSTC_23860-00"].Visible = false;
            colCnObjects["SHORTSTC_23890-00"].Visible = false;
            colCnObjects["SHORTSTC_23930-00"].Visible = false;
            colCnObjects["SHORTSTC_23960-00"].Visible = false;

            colCnObjects["RESULT_23820-00_1"].Visible = false;
            colCnObjects["RESULT_23850-00_1"].Visible = false;
            colCnObjects["RESULT_23880-00_1"].Visible = false;
            colCnObjects["RESULT_23920-00_1"].Visible = false;
            colCnObjects["RESULT_23950-00_1"].Visible = false;

            colCnObjects["SHORTSTC_23830-00_1"].Visible = false;
            colCnObjects["SHORTSTC_23860-00_1"].Visible = false;
            colCnObjects["SHORTSTC_23890-00_1"].Visible = false;
            colCnObjects["SHORTSTC_23930-00_1"].Visible = false;
            colCnObjects["SHORTSTC_23960-00_1"].Visible = false;

            colCnObjects["RESULT_23820-00_2"].Visible = false;
            colCnObjects["RESULT_23850-00_2"].Visible = false;
            colCnObjects["RESULT_23880-00_2"].Visible = false;
            colCnObjects["RESULT_23920-00_2"].Visible = false;
            colCnObjects["RESULT_23950-00_2"].Visible = false;

            colCnObjects["SHORTSTC_23830-00_2"].Visible = false;
            colCnObjects["SHORTSTC_23860-00_2"].Visible = false;
            colCnObjects["SHORTSTC_23890-00_2"].Visible = false;
            colCnObjects["SHORTSTC_23930-00_2"].Visible = false;
            colCnObjects["SHORTSTC_23960-00_2"].Visible = false;

            colCnObjects["UNIT_23820-00"].Visible = false;
            colCnObjects["UNIT_23850-00"].Visible = false;
            colCnObjects["UNIT_23880-00"].Visible = false;
            colCnObjects["UNIT_23920-00"].Visible = false;
            colCnObjects["UNIT_23950-00"].Visible = false;

            // 動脈硬化
            // オプション検査印刷有無チェック
            bolVisible = ChkRptOpt(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_CAVI, OBJ_VISIBLE);

            // オプション検査印刷有無チェック結果反映
            // 今回
            colCnObjects["RESULT_22710-01"].Visible = bolVisible;
            colCnObjects["SHORTSTC_22711-01"].Visible = bolVisible;
            colCnObjects["RESULT_22710-02"].Visible = bolVisible;
            colCnObjects["SHORTSTC_22711-02"].Visible = bolVisible;
            colCnObjects["RESULT_22720-01"].Visible = bolVisible;
            colCnObjects["RESULT_22720-02"].Visible = bolVisible;
            // 前回
            colCnObjects["RESULT_22710-01_1"].Visible = false;
            colCnObjects["SHORTSTC_22711-01_1"].Visible = false;
            colCnObjects["RESULT_22710-02_1"].Visible = false;
            colCnObjects["SHORTSTC_22711-02_1"].Visible = false;
            colCnObjects["RESULT_22720-01_1"].Visible = false;
            colCnObjects["RESULT_22720-02_1"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ") || HISTORYVIEW.Equals("Z"))
            {
                colCnObjects["RESULT_22710-01_1"].Visible = bolVisible;
                colCnObjects["SHORTSTC_22711-01_1"].Visible = bolVisible;
                colCnObjects["RESULT_22710-02_1"].Visible = bolVisible;
                colCnObjects["SHORTSTC_22711-02_1"].Visible = bolVisible;
                colCnObjects["RESULT_22720-01_1"].Visible = bolVisible;
                colCnObjects["RESULT_22720-02_1"].Visible = bolVisible;
            }
            // 前々回
            colCnObjects["RESULT_22710-01_2"].Visible = false;
            colCnObjects["SHORTSTC_22711-01_2"].Visible = false;
            colCnObjects["RESULT_22710-02_2"].Visible = false;
            colCnObjects["SHORTSTC_22711-02_2"].Visible = false;
            colCnObjects["RESULT_22720-01_2"].Visible = false;
            colCnObjects["RESULT_22720-02_2"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ"))
            {
                colCnObjects["RESULT_22710-01_2"].Visible = bolVisible;
                colCnObjects["SHORTSTC_22711-01_2"].Visible = bolVisible;
                colCnObjects["RESULT_22710-02_2"].Visible = bolVisible;
                colCnObjects["SHORTSTC_22711-02_2"].Visible = bolVisible;
                colCnObjects["RESULT_22720-01_2"].Visible = bolVisible;
                colCnObjects["RESULT_22720-02_2"].Visible = bolVisible;
            }

            // On Error Resume Next
            // 動脈硬化：基準マークの可視状態を検査結果と合わせる
            colCnObjects["ABNORMALMARK_22710-01"].Visible = colCnObjects["RESULT_22710-01"].Visible;
            colCnObjects["ABNORMALMARK_22710-02"].Visible = colCnObjects["RESULT_22710-02"].Visible;
            colCnObjects["ABNORMALMARK_22711-01"].Visible = colCnObjects["RESULT_22711-01"].Visible;
            colCnObjects["ABNORMALMARK_22711-02"].Visible = colCnObjects["RESULT_22711-02"].Visible;
            colCnObjects["ABNORMALMARK_22720-01"].Visible = colCnObjects["RESULT_22720-01"].Visible;
            colCnObjects["ABNORMALMARK_22720-02"].Visible = colCnObjects["RESULT_22720-02"].Visible;

            colCnObjects["ABNORMALMARK_22710-01_1"].Visible = colCnObjects["RESULT_22710-01_1"].Visible;
            colCnObjects["ABNORMALMARK_22710-02_1"].Visible = colCnObjects["RESULT_22710-02_1"].Visible;
            colCnObjects["ABNORMALMARK_22711-01_1"].Visible = colCnObjects["RESULT_22711-01_1"].Visible;
            colCnObjects["ABNORMALMARK_22711-02_1"].Visible = colCnObjects["RESULT_22711-02_1"].Visible;
            colCnObjects["ABNORMALMARK_22720-01_1"].Visible = colCnObjects["RESULT_22720-01_1"].Visible;
            colCnObjects["ABNORMALMARK_22720-02_1"].Visible = colCnObjects["RESULT_22720-02_1"].Visible;

            colCnObjects["ABNORMALMARK_22710-01_2"].Visible = colCnObjects["RESULT_22710-01_2"].Visible;
            colCnObjects["ABNORMALMARK_22710-02_2"].Visible = colCnObjects["RESULT_22710-02_2"].Visible;
            colCnObjects["ABNORMALMARK_22711-01_2"].Visible = colCnObjects["RESULT_22711-01_2"].Visible;
            colCnObjects["ABNORMALMARK_22711-02_2"].Visible = colCnObjects["RESULT_22711-02_2"].Visible;
            colCnObjects["ABNORMALMARK_22720-01_2"].Visible = colCnObjects["RESULT_22720-01_2"].Visible;
            colCnObjects["ABNORMALMARK_22720-02_2"].Visible = colCnObjects["RESULT_22720-02_2"].Visible;

            // 内臓脂肪測定
            // オプション検査印刷有無チェック
            bolVisible = ChkRptOpt(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_FATCT, OBJ_VISIBLE);


            // オプション検査印刷有無チェック結果反映
            // 今回
            colCnObjects["RESULT_24910-00"].Visible = bolVisible;
            colCnObjects["RESULT_24911-00"].Visible = bolVisible;
            colCnObjects["RESULT_24912-00"].Visible = bolVisible;
            colCnObjects["RESULT_24913-00"].Visible = bolVisible;
            colCnObjects["RESULT_24914-00"].Visible = bolVisible;
            colCnObjects["RESULT_24915-00"].Visible = bolVisible;
            // 前回
            colCnObjects["RESULT_24910-00_1"].Visible = false;
            colCnObjects["RESULT_24911-00_1"].Visible = false;
            colCnObjects["RESULT_24912-00_1"].Visible = false;
            colCnObjects["RESULT_24913-00_1"].Visible = false;
            colCnObjects["RESULT_24914-00_1"].Visible = false;
            colCnObjects["RESULT_24915-00_1"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ") || HISTORYVIEW.Equals("Z"))
            {
                colCnObjects["RESULT_24910-00_1"].Visible = bolVisible;
                colCnObjects["RESULT_24911-00_1"].Visible = bolVisible;
                colCnObjects["RESULT_24912-00_1"].Visible = bolVisible;
                colCnObjects["RESULT_24913-00_1"].Visible = bolVisible;
                colCnObjects["RESULT_24914-00_1"].Visible = bolVisible;
                colCnObjects["RESULT_24915-00_1"].Visible = bolVisible;
            }

            // 前々回
            colCnObjects["RESULT_24910-00_2"].Visible = false;
            colCnObjects["RESULT_24911-00_2"].Visible = false;
            colCnObjects["RESULT_24912-00_2"].Visible = false;
            colCnObjects["RESULT_24913-00_2"].Visible = false;
            colCnObjects["RESULT_24914-00_2"].Visible = false;
            colCnObjects["RESULT_24915-00_2"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ"))
            {
                colCnObjects["RESULT_24910-00_2"].Visible = bolVisible;
                colCnObjects["RESULT_24911-00_2"].Visible = bolVisible;
                colCnObjects["RESULT_24912-00_2"].Visible = bolVisible;
                colCnObjects["RESULT_24913-00_2"].Visible = bolVisible;
                colCnObjects["RESULT_24914-00_2"].Visible = bolVisible;
                colCnObjects["RESULT_24915-00_2"].Visible = bolVisible;
            }

            // 内臓脂肪：基準マークの可視状態を検査結果と合わせる
            colCnObjects["ABNORMALMARK_24910-00"].Visible = colCnObjects["RESULT_24910-00"].Visible;
            colCnObjects["ABNORMALMARK_24911-00"].Visible = colCnObjects["RESULT_24911-00"].Visible;
            colCnObjects["ABNORMALMARK_24912-00"].Visible = colCnObjects["RESULT_24912-00"].Visible;
            colCnObjects["ABNORMALMARK_24913-00"].Visible = colCnObjects["RESULT_24913-00"].Visible;
            colCnObjects["ABNORMALMARK_24914-00"].Visible = colCnObjects["RESULT_24914-00"].Visible;
            colCnObjects["ABNORMALMARK_24915-00"].Visible = colCnObjects["RESULT_24915-00"].Visible;
            colCnObjects["ABNORMALMARK_24910-00_1"].Visible = colCnObjects["RESULT_24910-00_1"].Visible;
            colCnObjects["ABNORMALMARK_24911-00_1"].Visible = colCnObjects["RESULT_24911-00_1"].Visible;
            colCnObjects["ABNORMALMARK_24912-00_1"].Visible = colCnObjects["RESULT_24912-00_1"].Visible;
            colCnObjects["ABNORMALMARK_24913-00_1"].Visible = colCnObjects["RESULT_24913-00_1"].Visible;
            colCnObjects["ABNORMALMARK_24914-00_1"].Visible = colCnObjects["RESULT_24914-00_1"].Visible;
            colCnObjects["ABNORMALMARK_24915-00_1"].Visible = colCnObjects["RESULT_24915-00_1"].Visible;
            colCnObjects["ABNORMALMARK_24910-00_2"].Visible = colCnObjects["RESULT_24910-00_2"].Visible;
            colCnObjects["ABNORMALMARK_24911-00_2"].Visible = colCnObjects["RESULT_24911-00_2"].Visible;
            colCnObjects["ABNORMALMARK_24912-00_2"].Visible = colCnObjects["RESULT_24912-00_2"].Visible;
            colCnObjects["ABNORMALMARK_24913-00_2"].Visible = colCnObjects["RESULT_24913-00_2"].Visible;
            colCnObjects["ABNORMALMARK_24914-00_2"].Visible = colCnObjects["RESULT_24914-00_2"].Visible;
            colCnObjects["ABNORMALMARK_24915-00_2"].Visible = colCnObjects["RESULT_24915-00_2"].Visible;

            // CT肺気腫検査追加 START
            // CT肺気腫
            // オプション検査印刷有無チェック
            bolVisible = ChkRptOpt(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_PECT, OBJ_VISIBLE);

            // オプション検査印刷有無チェック結果反映
            // 今回
            colCnObjects["RESULT_21630-01"].Visible = bolVisible;
            colCnObjects["RESULT_21630-02"].Visible = bolVisible;
            colCnObjects["RESULT_21630-03"].Visible = bolVisible;
            colCnObjects["RESULT_21620-01"].Visible = bolVisible;
            colCnObjects["RESULT_21620-02"].Visible = bolVisible;
            colCnObjects["RESULT_21620-03"].Visible = bolVisible;
            colCnObjects["RESULT_21660-01"].Visible = bolVisible;
            colCnObjects["RESULT_21660-02"].Visible = bolVisible;
            colCnObjects["RESULT_21660-03"].Visible = bolVisible;
            colCnObjects["RESULT_21650-01"].Visible = bolVisible;
            colCnObjects["RESULT_21650-02"].Visible = bolVisible;
            colCnObjects["RESULT_21650-03"].Visible = bolVisible;
            colCnObjects["RESULT_21670-00"].Visible = bolVisible;

            // 前回
            colCnObjects["RESULT_21630-01_1"].Visible = false;
            colCnObjects["RESULT_21630-02_1"].Visible = false;
            colCnObjects["RESULT_21630-03_1"].Visible = false;
            colCnObjects["RESULT_21620-01_1"].Visible = false;
            colCnObjects["RESULT_21620-02_1"].Visible = false;
            colCnObjects["RESULT_21620-03_1"].Visible = false;
            colCnObjects["RESULT_21660-01_1"].Visible = false;
            colCnObjects["RESULT_21660-02_1"].Visible = false;
            colCnObjects["RESULT_21660-03_1"].Visible = false;
            colCnObjects["RESULT_21650-01_1"].Visible = false;
            colCnObjects["RESULT_21650-02_1"].Visible = false;
            colCnObjects["RESULT_21650-03_1"].Visible = false;
            colCnObjects["RESULT_21670-00_1"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ") || HISTORYVIEW.Equals("Z"))
            {

                colCnObjects["RESULT_21630-01_1"].Visible = bolVisible;
                colCnObjects["RESULT_21630-02_1"].Visible = bolVisible;
                colCnObjects["RESULT_21630-03_1"].Visible = bolVisible;
                colCnObjects["RESULT_21620-01_1"].Visible = bolVisible;
                colCnObjects["RESULT_21620-02_1"].Visible = bolVisible;
                colCnObjects["RESULT_21620-03_1"].Visible = bolVisible;
                colCnObjects["RESULT_21660-01_1"].Visible = bolVisible;
                colCnObjects["RESULT_21660-02_1"].Visible = bolVisible;
                colCnObjects["RESULT_21660-03_1"].Visible = bolVisible;
                colCnObjects["RESULT_21650-01_1"].Visible = bolVisible;
                colCnObjects["RESULT_21650-02_1"].Visible = bolVisible;
                colCnObjects["RESULT_21650-03_1"].Visible = bolVisible;
                colCnObjects["RESULT_21670-00_1"].Visible = bolVisible;
            }

            // 前々回
            colCnObjects["RESULT_21630-01_2"].Visible = false;
            colCnObjects["RESULT_21630-02_2"].Visible = false;
            colCnObjects["RESULT_21630-03_2"].Visible = false;
            colCnObjects["RESULT_21620-01_2"].Visible = false;
            colCnObjects["RESULT_21620-02_2"].Visible = false;
            colCnObjects["RESULT_21620-03_2"].Visible = false;
            colCnObjects["RESULT_21660-01_2"].Visible = false;
            colCnObjects["RESULT_21660-02_2"].Visible = false;
            colCnObjects["RESULT_21660-03_2"].Visible = false;
            colCnObjects["RESULT_21650-01_2"].Visible = false;
            colCnObjects["RESULT_21650-02_2"].Visible = false;
            colCnObjects["RESULT_21650-03_2"].Visible = false;
            colCnObjects["RESULT_21670-00_2"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ"))
            {
                colCnObjects["RESULT_21630-01_2"].Visible = bolVisible;
                colCnObjects["RESULT_21630-02_2"].Visible = bolVisible;
                colCnObjects["RESULT_21630-03_2"].Visible = bolVisible;
                colCnObjects["RESULT_21620-01_2"].Visible = bolVisible;
                colCnObjects["RESULT_21620-02_2"].Visible = bolVisible;
                colCnObjects["RESULT_21620-03_2"].Visible = bolVisible;
                colCnObjects["RESULT_21660-01_2"].Visible = bolVisible;
                colCnObjects["RESULT_21660-02_2"].Visible = bolVisible;
                colCnObjects["RESULT_21660-03_2"].Visible = bolVisible;
                colCnObjects["RESULT_21650-01_2"].Visible = bolVisible;
                colCnObjects["RESULT_21650-02_2"].Visible = bolVisible;
                colCnObjects["RESULT_21650-03_2"].Visible = bolVisible;
                colCnObjects["RESULT_21670-00_2"].Visible = bolVisible;
            }

            // CT肺気腫：基準マークの可視状態を検査結果と合わせる
            colCnObjects["ABNORMALMARK_21670-00"].Visible = colCnObjects["RESULT_21670-00"].Visible;
            colCnObjects["ABNORMALMARK_21670-00_1"].Visible = colCnObjects["RESULT_21670-00_1"].Visible;
            colCnObjects["ABNORMALMARK_21670-00_2"].Visible = colCnObjects["RESULT_21670-00_2"].Visible;

            // 心不全スクリーニング
            // オプション検査印刷有無チェック
            bolVisible = ChkRptOpt(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_NTPRO, OBJ_VISIBLE);

            // オプション検査印刷有無チェック結果反映
            // 今回
            colCnObjects["RESULT_43470-00"].Visible = bolVisible;
            // 前回
            colCnObjects["RESULT_43470-00_1"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ") || HISTORYVIEW.Equals("Z"))
            {
                colCnObjects["RESULT_43470-00_1"].Visible = bolVisible;
            }
            // 前々回
            colCnObjects["RESULT_43470-00_2"].Visible = false;
            if (HISTORYVIEW.Equals("ZZ"))
            {
                colCnObjects["RESULT_43470-00_2"].Visible = bolVisible;
            }
            // 心不全スクリーニング：基準マークの可視状態を検査結果と合わせる
            colCnObjects["ABNORMALMARK_43470-00"].Visible = colCnObjects["RESULT_43470-00"].Visible;
            colCnObjects["ABNORMALMARK_43470-00_1"].Visible = colCnObjects["RESULT_43470-00_1"].Visible;
            colCnObjects["ABNORMALMARK_43470-00_2"].Visible = colCnObjects["RESULT_43470-00_2"].Visible;

            // 抗核抗体オプション検査印刷有無チェック
            bolVisible = false;
            bolVisible = ChkRptOpt(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_ANA, OBJ_VISIBLE);
            // 可否設定
            colCnObjects["RESULT_17580-01"].Visible = bolVisible;
            colCnObjects["RESULT_17580-01_1"].Visible = (HISTORYVIEW.Equals("Z") || HISTORYVIEW.Equals("ZZ")) ? bolVisible : false;
            colCnObjects["RESULT_17580-01_2"].Visible = (HISTORYVIEW.Equals("ZZ")) ? bolVisible : false;

            // 実際の基準値と基準値マスターの設定が異なる為、例外処理 START
            if (((CnDataField)colCnObjects["RESULT_17580-01"]).Text.IndexOf("＞") >= 0 || ((CnDataField)colCnObjects["RESULT_17580-01"]).Text.IndexOf(">") >= 0)
            {
                ((CnDataField)colCnObjects["ABNORMALMARK_17580-01"]).Text = "";
            }
            if (((CnDataField)colCnObjects["RESULT_17580-01_1"]).Text.IndexOf("＞") >= 0 || ((CnDataField)colCnObjects["RESULT_17580-01_1"]).Text.IndexOf(">") >= 0)
            {
                ((CnDataField)colCnObjects["ABNORMALMARK_17580-01_1"]).Text = "";
            }
            if (((CnDataField)colCnObjects["RESULT_17580-01_2"]).Text.IndexOf("＞") >= 0 || ((CnDataField)colCnObjects["RESULT_17580-01_2"]).Text.IndexOf(">") >= 0)
            {
                ((CnDataField)colCnObjects["ABNORMALMARK_17580-01_2"]).Text = "";
            }
            // 実際の基準値と基準値マスターの設定が異なる為、例外処理 END 

            // 抗核抗体：基準マークの可視状態を検査結果と合わせる
            colCnObjects["ABNORMALMARK_17580-01"].Visible = colCnObjects["RESULT_17580-01"].Visible;
            colCnObjects["ABNORMALMARK_17580-01_1"].Visible = colCnObjects["RESULT_17580-01_1"].Visible;
            colCnObjects["ABNORMALMARK_17580-01_2"].Visible = colCnObjects["RESULT_17580-01_2"].Visible;

            // 抗ＣＣＰ抗体オプション検査印刷有無チェック
            bolVisible = false;
            bolVisible = ChkRptOpt(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_CCPA, OBJ_VISIBLE);
            // 可否設定
            colCnObjects["RESULT_40060-00"].Visible = bolVisible;
            colCnObjects["RESULT_40060-00_1"].Visible = (HISTORYVIEW.Equals("Z") || HISTORYVIEW.Equals("ZZ")) ? bolVisible : false;
            colCnObjects["RESULT_40060-00_2"].Visible = (HISTORYVIEW.Equals("ZZ")) ? bolVisible : false;

            // 実際の基準値と基準値マスターの設定が異なる為、例外処理 START
            if (((CnDataField)colCnObjects["RESULT_40060-00"]).Text.IndexOf("＞") >= 0 || ((CnDataField)colCnObjects["RESULT_40060-00"]).Text.IndexOf(">") >= 0)
            {
                ((CnDataField)colCnObjects["ABNORMALMARK_40060-00"]).Text = "";
            }
            if (((CnDataField)colCnObjects["RESULT_40060-00_1"]).Text.IndexOf("＞") >= 0 || ((CnDataField)colCnObjects["RESULT_40060-00_1"]).Text.IndexOf(">") >= 0)
            {
                ((CnDataField)colCnObjects["ABNORMALMARK_40060-00_1"]).Text = "";
            }
            if (((CnDataField)colCnObjects["RESULT_40060-00_2"]).Text.IndexOf("＞") >= 0 || ((CnDataField)colCnObjects["RESULT_40060-00_2"]).Text.IndexOf(">") >= 0)
            {
                ((CnDataField)colCnObjects["ABNORMALMARK_40060-00_2"]).Text = "";
            }
            // 実際の基準値と基準値マスターの設定が異なる為、例外処理 END 

            // 抗ＣＣＰ抗体：基準マークの可視状態を検査結果と合わせる
            colCnObjects["ABNORMALMARK_40060-00"].Visible = colCnObjects["RESULT_40060-00"].Visible;
            colCnObjects["ABNORMALMARK_40060-00_1"].Visible = colCnObjects["RESULT_40060-00_1"].Visible;
            colCnObjects["ABNORMALMARK_40060-00_2"].Visible = colCnObjects["RESULT_40060-00_2"].Visible;

            // フェリチン、便中ピロリ菌抗原検査追加 ADD START
            // フェリチン印刷有無チェック
            bolVisible = false;
            bolVisible = ChkRptOpt(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_FERRITIN, OBJ_VISIBLE);
            // 可否設定
            colCnObjects["RESULT_17610-00"].Visible = bolVisible;
            colCnObjects["RESULT_17610-00_1"].Visible = (HISTORYVIEW.Equals("Z") || HISTORYVIEW.Equals("ZZ")) ? bolVisible : false;
            colCnObjects["RESULT_17610-00_2"].Visible = (HISTORYVIEW.Equals("ZZ")) ? bolVisible : false;

            // フェリチン：基準マークの可視状態を検査結果と合わせる
            colCnObjects["ABNORMALMARK_17610-00"].Visible = colCnObjects["RESULT_17610-00"].Visible;
            colCnObjects["ABNORMALMARK_17610-00_1"].Visible = colCnObjects["RESULT_17610-00_1"].Visible;
            colCnObjects["ABNORMALMARK_17610-00_2"].Visible = colCnObjects["RESULT_17610-00_2"].Visible;

            // 便中ピロリ菌抗原検査印刷有無チェック
            bolVisible = false;
            bolVisible = ChkRptOpt(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_HP, OBJ_VISIBLE);
            // 可否設定
            colCnObjects["SHORTSTC_14370-00"].Visible = bolVisible;
            colCnObjects["SHORTSTC_14370-00_1"].Visible = (HISTORYVIEW.Equals("Z") || HISTORYVIEW.Equals("ZZ")) ? bolVisible : false;
            colCnObjects["SHORTSTC_14370-00_2"].Visible = (HISTORYVIEW.Equals("ZZ")) ? bolVisible : false;
            // フェリチン、便中ピロリ菌抗原検査追加 ADD END

            // 血管炎検査結果印刷有無チェック
            bolVisible = false;
            bolVisible = ChkRptOpt(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_VASCULITIS, OBJ_VISIBLE);

            // ＰＲ３－ＡＮＣＡ印刷可否設定
            colCnObjects["SHORTSTC_43970-00"].Visible = bolVisible;
            colCnObjects["SHORTSTC_43970-00_1"].Visible = (HISTORYVIEW.Equals("Z") || HISTORYVIEW.Equals("ZZ")) ? bolVisible : false;
            colCnObjects["SHORTSTC_43970-00_2"].Visible = (HISTORYVIEW.Equals("ZZ")) ? bolVisible : false;

            // ＭＰＯ－ＡＮＣＡ印刷可否設定
            colCnObjects["SHORTSTC_43960-00"].Visible = bolVisible;
            colCnObjects["SHORTSTC_43960-00_1"].Visible = (HISTORYVIEW.Equals("Z") || HISTORYVIEW.Equals("ZZ")) ? bolVisible : false;
            colCnObjects["SHORTSTC_43960-00_2"].Visible = (HISTORYVIEW.Equals("ZZ")) ? bolVisible : false;

            // ＰＲ３－ＡＮＣＡ：基準マークの可視状態を検査結果と合わせる
            colCnObjects["ABNORMALMARK_43970-00"].Visible = colCnObjects["SHORTSTC_43970-00"].Visible;
            colCnObjects["ABNORMALMARK_43970-00_1"].Visible = colCnObjects["SHORTSTC_43970-00_1"].Visible;
            colCnObjects["ABNORMALMARK_43970-00_2"].Visible = colCnObjects["SHORTSTC_43970-00_2"].Visible;

            // ＭＰＯ－ＡＮＣＡ：基準マークの可視状態を検査結果と合わせる
            colCnObjects["ABNORMALMARK_43960-00"].Visible = colCnObjects["SHORTSTC_43960-00"].Visible;
            colCnObjects["ABNORMALMARK_43960-00_1"].Visible = colCnObjects["SHORTSTC_43960-00_1"].Visible;
            colCnObjects["ABNORMALMARK_43960-00_2"].Visible = colCnObjects["SHORTSTC_43960-00_2"].Visible;

            // 指定団体グループ以外の団体名・社員番号を非表示とする処理
            Boolean blnOrgGrp = SelectOrgGrp(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_ORGGRP);
            if (blnOrgGrp)
            {
                colCnObjects["LBLEMPNO"].Visible = true;
                colCnObjects["EMPNO"].Visible = true;
            }
            else
            {
                colCnObjects["LBLEMPNO"].Visible = false;
                colCnObjects["EMPNO"].Visible = false;
            }

            Boolean blnOrgIns = SelectOrgIns(objRepConsult.OrgCd1, objRepConsult.OrgCd2);
            if (blnOrgIns)
            {
                colCnObjects["LBLISRSIGN"].Visible = true;
                colCnObjects["ISRSIGN"].Visible = true;
                colCnObjects["LBLISRNO"].Visible = true;
                colCnObjects["ISRNO"].Visible = true;
            }
            else
            {
                colCnObjects["LBLISRSIGN"].Visible = false;
                colCnObjects["ISRSIGN"].Visible = false;
                colCnObjects["LBLISRNO"].Visible = false;
                colCnObjects["ISRNO"].Visible = false;
            }
        }

        /// <summary>
        /// ６連成績書英語版１枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6E321_1(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書英語版２枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6E321_2(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {
            const int ItemCount = 12;                           // グラフアイテム個数
            const int PerfectScore = 10;                        //最高スコア

            CnObjects colCrObjects;                             // 描画オブジェクトのコレクション
            CnObject objCrObject;                               // 描画オブジェクト
            RepHistory objHistory;                              // '受診履歴クラス
            RepResult objResult;                                // 検査結果クラス
            double[] sngLastResult=new double[ItemCount];       // 前回歴検査結果
            double[] sngResult = new double[ItemCount];         // 検査結果
            double sngBaseX =0;                                 // Ｘ座標（中心）
            double sngBaseY =0;                                 // Ｙ座標（中心）
            double sngLastX=0;                                  // Ｘ座標
            double sngLastY=0;                                  // Ｙ座標
            double sngX=0;                                      // Ｘ座標
            double sngY=0;                                      // Ｙ座標
            int lngIndex;                                       // 配列インデックス
            string[] vntToken;                                  // トークン
            int lngTokenCount;                                  // トークン数
            Boolean blnLastGraphDraw;                           // グラフ描画フラグ（前回歴）
            Boolean blnGraphDraw=false;                         // グラフ描画フラグ
            int lngRslCount;                                    // 結果件数
            //Dim vntJudCmtStc            As Variant            // 判定コメント
            string strJudCntStc ="";                            // 判定コメント
            string strJudCd;
            string strJudRName;
            int i;

            Boolean[] blnLastResult = new Boolean[ItemCount];
            Boolean[] blnResult = new Boolean[ItemCount];

            // 描画オブジェクトコレクションの参照設定
            colCrObjects = cnForm.CnObjects;

            foreach (CnObject rec in colCrObjects)
            {
                switch (rec.Name.ToUpper())
                {
                    case "CSLDATE":
                        ((CnDataField)colCrObjects["CSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "BIRTH":
                        ((CnDataField)colCrObjects["BIRTH"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.Birth);
                        break;
                    case "EDITCSLDATE":
                        ((CnDataField)colCrObjects["EDITCSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "EDITBIRTH":
                        ((CnDataField)colCrObjects["EDITBIRTH"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.Birth);
                        break;
                    case "GENDER":
                        ((CnDataField)colCrObjects["GENDER"]).Text = objRepConsult.Gender == 1 ? "Male":"Female";
                        break;
                    case "EDITGENDER":
                        ((CnDataField)colCrObjects["EDITGENDER"]).Text = objRepConsult.Gender == 1 ? "Male" : "Female";
                        break;
                    case "ROMENAME":
                        ((CnDataField)colCrObjects["ROMENAME"]).Text = SelectConsult_ROMENAME(objRepConsult.PerId);
                        break;
                    default:
                        vntToken = rec.Name.Split('_');
                        lngTokenCount = vntToken.Length;
                        if (lngTokenCount >= 1)
                        {
                            switch (PrintCommon.ExceptReplicationSign(vntToken[0]).ToUpper())
                            {
                                case "JUDRNAME":
                                    // 血管炎検査追加対応
                                    if (Convert.ToInt16(vntToken[1]) >= 1 && Convert.ToInt16(vntToken[1]) <= 44)
                                    {
                                        if (vntToken.Length-1>1)
                                        {
                                            if (null!=objRepConsult.Histories.Item(Convert.ToInt32(vntToken[2])))
                                            {   
                                                dynamic rslData = SelectJudHistoryRsl(objRepConsult.Histories.Item(Convert.ToInt32(vntToken[2])).RsvNo, Convert.ToInt32(vntToken[1]), false);
                                                ((CnDataField)rec).Text = rslData.JUDRNAME;
                                            }
                                        }
                                        else
                                        {
                                            dynamic rslData = SelectJudHistoryRsl(objRepConsult.RsvNo, Convert.ToInt32(vntToken[1]), true);
                                            ((CnDataField)rec).Text = rslData.JUDRNAME;
                                        }
                                    }
                                        break;
                            }
                        }
                            break;
                }
            }

            // グラフ基準線の出力
            // cnForm.SetLine corLineSolid, 15, vbBlack
            Report6_2_GetPoint(0, 100,ref sngBaseX, ref sngBaseY);
            i = 1;
            while (!(i> ItemCount))
            {
                if (i==1)
                {
                    Report6_2_GetPoint(ItemCount, 100, ref sngLastX, ref sngLastY);
                }
                Report6_2_GetPoint(i, 100, ref sngX, ref sngY);
                // cnForm.DrawCrLine sngBaseX *100, sngBaseY * 100, sngX * 100, sngY * 100
                // objCrForm.DrawCrLine sngLastX *100, sngLastY * 100, sngX * 100, sngY * 100
                sngLastX = sngX;
                sngLastY = sngY;
                i++;
            }
            // 検査結果を集計
            objHistory = objRepConsult.Histories.Item(1);
            blnLastGraphDraw = false;
            i = 1;
            while (!(i > ItemCount))
            {
                sngResult[i] = 0;
                sngLastResult[i] = 0;
                i++;
            }

            foreach (CnObject rec in colCrObjects)
            {
                // アンダースコアでカラム名を分割
                vntToken = rec.Name.Split('_');
                lngTokenCount = vntToken.Length;
                if (lngTokenCount==3)
                {
                    if (vntToken[0].Equals("GRAPHITEM"))
                    {
                        if (Double.TryParse(vntToken[0],out double wk))
                        {
                            lngIndex = Convert.ToInt32(vntToken[1]);
                            // 前回結果
                            if (null!= objHistory)
                            {
                                objResult = objHistory.Results.Item(vntToken[2]);
                                if (null!= objResult)
                                {
                                    if (Double.TryParse(objResult.Result, out double wk2))
                                    {
                                        sngLastResult[lngIndex] = Convert.ToInt32(objResult.Result);
                                        blnLastGraphDraw = true;
                                        blnLastResult[lngIndex] = true;
                                    }
                                }
                            }
                            // 今回
                            objResult = objRepConsult.Results.Item(vntToken[2]);
                            if (null != objResult)
                            {
                                if (Double.TryParse(objResult.Result, out double wk2))
                                {
                                    sngResult[lngIndex] = Convert.ToInt32(objResult.Result);
                                    blnGraphDraw = true;
                                    blnResult[lngIndex] = true;
                                }
                            }
                        }
                    }
                }
            }

            // 前回結果グラフを出力
            if (blnLastGraphDraw)
            {
                // 受診日を出力
                ((CnDataField)colCrObjects["GRAPHDATE2"]).Text = string.Format("{0:YYYY年M月D日}", objHistory.CslDate);
                objCrObject = colCrObjects["GRAPHCOLOR_2"];
                // TODO
                // objCrForm.SetLine objCrObject.LineStyle, objCrObject.LineWidth, objCrObject.LineColor
                i = 1;
                while (!(i > ItemCount))
                {
                    if (i==1)
                    {
                        Report6_2_GetPoint(ItemCount, (PerfectScore - (sngLastResult[ItemCount] * sngLastResult[ItemCount])) / PerfectScore * 100,ref sngLastX,ref sngLastY);
                    }
                    Report6_2_GetPoint(i, (PerfectScore - (sngLastResult[i] * sngLastResult[i])) / PerfectScore * 100, ref sngX, ref sngY);
                    // 'Null項目が失点０で出力される問題解決
                    if (i==1)
                    {
                        if (blnLastResult[ItemCount] &&  blnLastResult[i])
                        {
                            // TODO
                            // objCrForm.DrawCrLine sngLastX * 100, sngLastY * 100, sngX * 100, sngY * 100
                        }
                    }
                    else
                    {
                        if (blnLastResult[i] && blnLastResult[i - 1])
                        {
                            // TODO
                            // objCrForm.DrawCrLine sngLastX * 100, sngLastY * 100, sngX * 100, sngY * 100
                        }
                    }
                    sngLastX = sngX;
                    sngLastY = sngY;
                    i++;
                }
            }

            // '今回結果グラフを出力
            // '受診日を出力
            ((CnDataField)colCrObjects["GRAPHDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
            if (blnGraphDraw)
            {
                objCrObject = colCrObjects["GRAPHCOLOR_1"];
                // TODO
                // objCrForm.SetLine objCrObject.LineStyle, objCrObject.LineWidth, objCrObject.LineColor
                i = 1;
                while (!(i > ItemCount))
                {
                    if (i == 1)
                    {
                        Report6_2_GetPoint(ItemCount, (PerfectScore - (sngResult[ItemCount] * sngResult[ItemCount])) / PerfectScore * 100, ref sngLastX, ref sngLastY);
                    }
                    Report6_2_GetPoint(i, (PerfectScore - (sngResult[i] * sngResult[i])) / PerfectScore * 100, ref sngX, ref sngY);
                    if (i == 1)
                    {
                        if (blnResult[ItemCount] && blnResult[i])
                        {
                            // TODO
                            //  objCrForm.DrawCrLine sngLastX * 100, sngLastY * 100, sngX * 100, sngY * 100
                        }
                    }
                    else
                    {
                        if (blnResult[i] && blnResult[i -1])
                        {
                            // TODO
                            //  objCrForm.DrawCrLine sngLastX * 100, sngLastY * 100, sngX * 100, sngY * 100
                        }
                    }
                    sngLastX = sngX;
                    sngLastY = sngY;
                    i++;
                }
            }

            // 総合判定コメント
            IList < dynamic > data = SelectJudCmt(objRepConsult.RsvNo, 1);
            if (data.Count>0)
            {
                strJudCntStc = "";
                i = 0;
                while (!(i > (data.Count - 1)))
                {
                    strJudCntStc = strJudCntStc + data[i].JUDCMTCD + Environment.NewLine;
                    i++;
                }
                ((CnDataField)colCrObjects["TOTALCOMMENT"]).Text = strJudCntStc;
            }

            // オプション血液検査が存在する場合コメントを自動で出力してくれる。
            if (CheckOptionComment(objRepConsult.RsvNo))
            {
                strJudCntStc = strJudCntStc + CMT_ADDKENSA_EN + Environment.NewLine;
            }
            ((CnDataField)colCrObjects["TOTALCOMMENT"]).Text = strJudCntStc;

            // 生活指導事項
            data = SelectJudCmt(objRepConsult.RsvNo, 2);
            if (data.Count > 0)
            {
                strJudCntStc = "";
                i = 0;
                while (!(i > (data.Count - 1)))
                {
                    if (!strJudCntStc.Equals(""))
                    {
                        strJudCntStc = strJudCntStc + Environment.NewLine;
                    }
                    strJudCntStc = strJudCntStc + data[i].JUDCMTCD;
                    i ++;
                }
                ((CnDataField)colCrObjects["JUGCMT"]).Text = strJudCntStc;
            }
        }

        /// <summary>
        /// ６連成績書英語版３枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6E321_3(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {
            CnObjects colCrObjects;             // 描画オブジェクトのコレクション
            CnObject objCrObject;               // 描画オブジェクト
            RepHistory objHistory;              // 受診履歴クラス
            string[] vntToken;                  // トークン
            int lngRslCount;                    // 結果件数
            int lngTokenCount;                  // トークン数
            String strSeq;                      // SEQ
            String strIKbn;                     // 胃区分
            String strJudCd;
            String strJudRName;

            string vntLongStc;                  // 文章
            int i;
            short j;
            short k;

            int[,] JudSenketu = new int[3, 2]; // 便潜血判定用
            string[,] judEngStcCode = new string[3, 2];// 便潜血判定用
            string[] judPriEngCode = new string[2]; // 固定ロジック用
            string[] judResult = new string[3]; // 日付編集項目

            string[,] judAbnormalMark = new string[3, 2]; // 便潜血異常値マーク用

            // 描画オブジェクトコレクションの参照設定
            colCrObjects = cnForm.CnObjects;
            // 便潜血判定用
            judEngStcCode[1, 1] = "ENGSTC_14322-00";
            judEngStcCode[2, 1] = "ENGSTC_14322-00_1";
            judEngStcCode[3, 1] = "ENGSTC_14322-00_2";
            judEngStcCode[1, 2] = "ENGSTC_14325-00";
            judEngStcCode[2, 2] = "ENGSTC_14325-00_1";
            judEngStcCode[3, 2] = "ENGSTC_14325-00_2";


            judAbnormalMark[1, 1] = "ABNORMALMARK_14322-00";
            judAbnormalMark[2, 1] = "ABNORMALMARK_14322-00_1";
            judAbnormalMark[3, 1] = "ABNORMALMARK_14322-00_2";
            judAbnormalMark[1, 2] = "ABNORMALMARK_14325-00";
            judAbnormalMark[2, 2] = "ABNORMALMARK_14325-00_1";
            judAbnormalMark[3, 2] = "ABNORMALMARK_14325-00_2";


            judPriEngCode[1] = "PRIENGSTC_22180-01_22180-02_22180-03_22180-04_22180-05_22180-06_22180-07_22180-08_22180-09_22180-10";
            judPriEngCode[2] = "PRIENGSTC_22160-01_22160-03_22160-05_22160-07_22160-09_22160-11";

            judResult[1] = "RESULT_23110-00";
            judResult[2] = "RESULT_23110-00_1";
            judResult[3] = "RESULT_23110-00_2";

            // 今回、前回、前々回受診情報
            // 今回
            ((CnDataField)colCrObjects["EDITCSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
            dynamic IKbnName = SelectIKbnName(objRepConsult.RsvNo);
            ((CnDataField)colCrObjects["EDITCSNAME"]).Text = SelectCsEName(objRepConsult.CsCd) + Convert.ToString(IKbnName.NAME).Trim();
            ((CnDataField)colCrObjects["IKBN"]).Text = Convert.ToString(IKbnName.NAME).Trim();

            // Ｘ線、内視鏡非表示処理
            colCrObjects[IBU_NAISIKYODATE].Visible = false;
            colCrObjects[IBU_NAISIKYOLABEL].Visible = false;
            colCrObjects[IBU_NAISIKYODATE + "_1"].Visible = false;
            colCrObjects[IBU_NAISIKYOLABEL + "_1"].Visible = false;
            colCrObjects[IBU_NAISIKYODATE + "_2"].Visible = false;
            colCrObjects[IBU_NAISIKYOLABEL + "_2"].Visible = false;
            switch (IKbnName.SEQ)
            {
                case "2":
                    colCrObjects[IBU_NAISIKYODATE].Visible = true;
                    colCrObjects[IBU_NAISIKYOLABEL].Visible = true;
                    break;
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (objHistory != null)
            {
                ((CnDataField)colCrObjects["EDITCSLDATE_1"]).Text = string.Format("{0:YYYY年M月D日}", objHistory.CslDate);
                IKbnName = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCrObjects["EDITCSNAME_1"]).Text = SelectCsEName(objHistory.CsCd) + Convert.ToString(IKbnName.NAME).Trim();
                ((CnDataField)colCrObjects["IKBN_1"]).Text = Convert.ToString(IKbnName.NAME).Trim();
                // Ｘ線、内視鏡非表示処理
                switch (IKbnName.SEQ)
                {
                    case "2":
                        colCrObjects[IBU_NAISIKYODATE + "_1"].Visible = true;
                        colCrObjects[IBU_NAISIKYOLABEL + "_1"].Visible = true;
                        break;
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (objHistory != null)
            {
                ((CnDataField)colCrObjects["EDITCSLDATE_2"]).Text = string.Format("{0:YYYY年M月D日}", objHistory.CslDate);
                IKbnName = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCrObjects["EDITCSNAME_2"]).Text = SelectCsEName(objHistory.CsCd) + Convert.ToString(IKbnName.NAME).Trim();
                ((CnDataField)colCrObjects["IKBN_2"]).Text = Convert.ToString(IKbnName.NAME).Trim();
                // Ｘ線、内視鏡非表示処理
                switch (IKbnName.SEQ)
                {
                    case "2":
                        colCrObjects[IBU_NAISIKYODATE + "_2"].Visible = true;
                        colCrObjects[IBU_NAISIKYOLABEL + "_2"].Visible = true;
                        break;
                }
            }

            // 上部消化管
            // 今回
            IList<dynamic> lngRsl = SelectStc_2nd_E(objRepConsult.RsvNo, GRPCD_JYOUBU);

            if (lngRsl.Count > 0)
            {
                objCrObject = colCrObjects["JYOUBU"];
                // 上部消化管を２列に増やした！
                j = 0;
                i = 0;
                k = 0;
                while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                {

                    if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(k, j, lngRsl[i].ENGSTC.Trim());
                        j++;
                        if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                        {
                            j = 0;
                            k++;
                        }
                    }
                    i++;
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd_E(objHistory.RsvNo, GRPCD_JYOUBU);

                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["JYOUBU1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {

                        if (!"".Equals(Convert.ToString(data[i].ENGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].ENGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd_E(objHistory.RsvNo, GRPCD_JYOUBU);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["JYOUBU2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].ENGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].ENGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 上腹部超音波
            // 今回
            lngRsl = SelectStc_2nd_E(objRepConsult.RsvNo, GRPCD_ECHO);

            if (lngRsl.Count > 0)
            {
                objCrObject = colCrObjects["ECHO"];
                // 上腹部超音波英文所見６つ以上対応の為所見を２列に変更。ST --------------------
                j = 0;
                i = 0;
                k = 0;
                while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                {

                    if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(k, j, lngRsl[i].ENGSTC.Trim());
                        j++;
                        if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                        {
                            j = 0;
                            k++;
                        }
                    }
                    i++;
                }
                // 上腹部超音波英文所見６つ以上対応の為所見を２列に変更。ED--------------------
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);

            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd_E(objHistory.RsvNo, GRPCD_ECHO);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["ECHO1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].ENGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].ENGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);

            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd_E(objHistory.RsvNo, GRPCD_ECHO);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["ECHO2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].ENGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].ENGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 胸部Ｘ線
            // 今回
            lngRsl = SelectStc_2nd_E(objRepConsult.RsvNo, GRPCD_KYOUBU_X);

            if (lngRsl.Count > 0)
            {
                objCrObject = colCrObjects["KYOUBUX"];
                j = 0;
                i = 0;
                k = 0;
                while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                {

                    if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(k, j, lngRsl[i].ENGSTC.Trim());
                        j++;
                        if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                        {
                            j = 0;
                            k++;
                        }
                    }
                    i++;
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd_E(objHistory.RsvNo, GRPCD_KYOUBU_X);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["KYOUBUX1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].ENGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].ENGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd_E(objHistory.RsvNo, GRPCD_KYOUBU_X);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["KYOUBUX2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].ENGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].ENGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }
            // TODO
            // On Error Resume Next

            // 便潜血判定
            for (i = 1; i <= 3; i++)
            {
                // 障害対応 -> 表示制御のクリアを行う
                colCrObjects[judEngStcCode[i, 1]].Visible = true;
                colCrObjects[judEngStcCode[i, 2]].Visible = true;
                colCrObjects[judAbnormalMark[i, 1]].Visible = true;
                colCrObjects[judAbnormalMark[i, 2]].Visible = true;
                switch (Strings.StrConv(((CnDataField)colCrObjects[judEngStcCode[i, 1]]).Text, VbStrConv.Wide))
                {
                    case "TEST OMIT":
                        JudSenketu[i, 1] = 1;
                        break;
                    case "（－）":
                        JudSenketu[i, 1] = 2;
                        break;
                    case "（＋－）":
                        JudSenketu[i, 1] = 3;
                        break;
                    case "（＋）":
                        JudSenketu[i, 1] = 4;
                        break;
                    case "（２＋）":
                        JudSenketu[i, 1] = 5;
                        break;
                    default:
                        JudSenketu[i, 1] = 0;
                        break;

                }
                switch (Strings.StrConv(((CnDataField)colCrObjects[judEngStcCode[i, 2]]).Text, VbStrConv.Wide))
                {
                    case "TEST OMIT":
                        JudSenketu[i, 2] = 1;
                        break;
                    case "（－）":
                        JudSenketu[i, 2] = 2;
                        break;
                    case "（＋－）":
                        JudSenketu[i, 2] = 3;
                        break;
                    case "（＋）":
                        JudSenketu[i, 2] = 4;
                        break;
                    case "（２＋）":
                        JudSenketu[i, 2] = 5;
                        break;
                    default:
                        JudSenketu[i, 2] = 0;
                        break;

                }
                if (JudSenketu[i, 1] < JudSenketu[i, 2])
                {
                    colCrObjects[judEngStcCode[i, 1]].Visible = false;
                    colCrObjects[judAbnormalMark[i, 1]].Visible = false;
                }
                else
                {
                    colCrObjects[judEngStcCode[i, 2]].Visible = false;
                    colCrObjects[judAbnormalMark[i, 2]].Visible = false;
                }
            }

            // TODO On Error GoTo 0

            foreach (CnObject rec in colCrObjects)
            {
                switch (rec.Name.ToUpper())
                {
                    case "CSLDATE":
                        ((CnDataField)colCrObjects["CSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "CSLDATEM":
                        ((CnDataField)colCrObjects["CSLDATEM"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "BIRTH":
                        ((CnDataField)colCrObjects["BIRTH"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.Birth);
                        break;

                    case "EDITCSLDATE":
                        ((CnDataField)colCrObjects["EDITCSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "EDITCSLDATEM":
                        ((CnDataField)colCrObjects["EDITCSLDATEM"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "EDITBIRTH":
                        ((CnDataField)colCrObjects["EDITBIRTH"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.Birth);
                        break;
                    case "GENDER":
                        ((CnDataField)colCrObjects["GENDER"]).Text = objRepConsult.Gender == 1 ? "Male" : "Female";
                        break;
                    case "EDITGENDER":
                        ((CnDataField)colCrObjects["EDITGENDER"]).Text = objRepConsult.Gender == 1 ? "Male" : "Female";
                        break;
                    case "ROMENAME":// ローマ字名
                        ((CnDataField)colCrObjects["ROMENAME"]).Text = SelectConsult_ROMENAME(objRepConsult.PerId);
                        break;
                    case "ECHO1":
                        string leftStr = ((CnListField)colCrObjects["ECHO1"]).ListText(0, 0);
                        leftStr = leftStr.Substring(0, 1);
                        if ("*".Equals(Strings.StrConv(leftStr, VbStrConv.Narrow)))
                        {
                            ((CnListField)colCrObjects["ECHO1"]).ListText(0, 0, "");
                        }
                        break;
                    case "ECHO2":
                        string leftStr2 = ((CnListField)colCrObjects["ECHO2"]).ListText(0, 0);
                        leftStr2 = leftStr2.Substring(0, 1);
                        if ("*".Equals(Strings.StrConv(leftStr2, VbStrConv.Narrow)))
                        {
                            ((CnListField)colCrObjects["ECHO2"]).ListText(0, 0, "");
                        }
                        break;
                    default:
                        // アンダースコアでカラム名を分割
                        vntToken = rec.Name.Split('_');
                        lngTokenCount = vntToken.Length;
                        if (lngTokenCount >= 1)
                        {
                            switch (PrintCommon.ExceptReplicationSign(vntToken[0]).ToUpper())
                            {
                                case "PRISHORTSTC":
                                case "PRILONGSTC":
                                case "PRIENGSTC":
                                    string rightStr = rec.Name.TrimEnd();
                                    rightStr = rightStr.Substring(rightStr.Length - 2, 2);
                                    if ("_1".Equals(rightStr) || "_2".Equals(rightStr))
                                    {
                                        if ("*".Equals(Strings.StrConv(((CnListField)rec).ListText(0, 0).Substring(0, 1), VbStrConv.Narrow)))
                                        {
                                            ((CnListField)rec).ListText(0, 0, "");
                                        }
                                    }
                                    break;
                                case "LONGSTC":
                                case "ENGSTC":
                                    rightStr = rec.Name.TrimEnd();
                                    rightStr = rightStr.Substring(rightStr.Length - 2, 2);
                                    if ("_1".Equals(rightStr) || "_2".Equals(rightStr))
                                    {
                                        if ("*".Equals(Strings.StrConv(((CnDataField)rec).Text.Substring(0, 1), VbStrConv.Narrow)))
                                        {
                                            ((CnDataField)rec).Text = "";
                                        }
                                    }
                                    break;
                                case "RESULT":
                                    rightStr = rec.Name.TrimEnd();
                                    rightStr = rightStr.Substring(rightStr.Length - 2, 2);
                                    if ("_1".Equals(rightStr) || "_2".Equals(rightStr))
                                    {
                                        if ("*".Equals(Strings.StrConv(((CnDataField)rec).Text.Substring(0, 1), VbStrConv.Narrow)))
                                        {
                                            ((CnDataField)rec).Text = "";
                                        }
                                    }
                                    for (i = 1; i <= judResult.Length-1; i++)
                                    {
                                        if (rec.Name.Equals(judResult[i]))
                                        {
                                            ((CnDataField)rec).Text = string.Format("{0:YYYY年M月D日}", DateTime.ParseExact(((CnDataField)rec).Text, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture));
                                        }
                                    }
                                    break;
                                case "JUDRNAME":
                                    if (Convert.ToInt16(vntToken[1]) >= 1 && Convert.ToInt16(vntToken[1]) <= 28)
                                    {
                                        if (vntToken.Length - 1 <= 1)
                                        {
                                            dynamic data = SelectJudHistoryRsl(objRepConsult.RsvNo, Convert.ToInt16(vntToken[1]), true);
                                            ((CnDataField)rec).Text = data.JUDRNAME;
                                            if (("＊＊").Equals(data.JUDRNAME.ToUpper()))
                                            {
                                                switch (Convert.ToInt16(vntToken[1]))
                                                {
                                                    case 1:
                                                        ((CnListField)colCrObjects[judPriEngCode[1]]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 4:
                                                        ((CnListField)colCrObjects[judPriEngCode[2]]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 5:
                                                        ((CnDataField)colCrObjects["RESULT_13020-00"]).Text = "********";
                                                        ((CnDataField)colCrObjects["RESULT_13022-00"]).Text = "********";
                                                        ((CnDataField)colCrObjects["RESULT_13023-00"]).Text = "********";
                                                        ((CnDataField)colCrObjects["RESULT_13024-00"]).Text = "********";

                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13020-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13022-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13023-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13024-00"]).Text = "";
                                                        break;
                                                    case 6:
                                                        ((CnListField)colCrObjects["KYOUBUX"]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 7:
                                                        ((CnListField)colCrObjects["JYOUBU"]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 8:
                                                        ((CnDataField)colCrObjects["ENGSTC_14322-00"]).Text = "＊＊＊＊＊";
                                                        break;
                                                    case 9:
                                                        ((CnListField)colCrObjects["ECHO"]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                }
                                            }
                                            if (("－－").Equals(data.JUDRNAME.ToUpper()))
                                            {
                                                switch (Convert.ToInt16(vntToken[1]))
                                                {
                                                    case 1:
                                                        ((CnListField)colCrObjects[judPriEngCode[1]]).ListText(0, 0, "TEST NOT DONE");
                                                        break;
                                                    case 4:
                                                        ((CnListField)colCrObjects[judPriEngCode[2]]).ListText(0, 0, "TEST NOT DONE");
                                                        break;
                                                    case 5:
                                                        ((CnDataField)colCrObjects["RESULT_13020-00"]).Text = "--------";
                                                        ((CnDataField)colCrObjects["RESULT_13022-00"]).Text = "--------";
                                                        ((CnDataField)colCrObjects["RESULT_13023-00"]).Text = "--------";
                                                        ((CnDataField)colCrObjects["RESULT_13024-00"]).Text = "--------";

                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13020-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13022-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13023-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13024-00"]).Text = "";
                                                        break;
                                                    case 6:
                                                        ((CnListField)colCrObjects["KYOUBUX"]).ListText(0, 0, "TEST NOT DONE");
                                                        break;
                                                    case 7:
                                                        ((CnListField)colCrObjects["JYOUBU"]).ListText(0, 0, "TEST NOT DONE");
                                                        break;
                                                    case 8:
                                                        ((CnDataField)colCrObjects["ENGSTC_14322-00"]).Text = "TEST NOT DONE";
                                                        break;
                                                    case 9:
                                                        ((CnListField)colCrObjects["ECHO"]).ListText(0, 0, "TEST NOT DONE");
                                                        break;
                                                }
                                            }
                                        }
                                    }
                                    break;
                            }
                        }
                        break;
                }
            }

            colCrObjects["JUDRNAME_1"].Visible = false;
            colCrObjects["JUDRNAME_2"].Visible = false;
            colCrObjects["JUDRNAME_3"].Visible = false;
            colCrObjects["JUDRNAME_4"].Visible = false;
            colCrObjects["JUDRNAME_5"].Visible = false;
            colCrObjects["JUDRNAME_6"].Visible = false;
            colCrObjects["JUDRNAME_7"].Visible = false;
            colCrObjects["JUDRNAME_8"].Visible = false;
            colCrObjects["JUDRNAME_9"].Visible = false;
            colCrObjects["JUDRNAME_10"].Visible = false;
        }

        /// <summary>
        /// ６連成績書英語版４枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6E321_4(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書英語版４枚目の編集 2011.01.01板
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6E321_4_2011(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書英語版５枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6E321_5(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ６連成績書英語版６枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6E321_6(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ３連成績書１枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3N353_1(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ３連成績書２枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3N353_2(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {
            CnObjects colCrObjects;             // 描画オブジェクトのコレクション
            CnObject objCrObject;               // 描画オブジェクト
            RepHistory objHistory;              // 受診履歴クラス
            string vntLongStc;                  // 文章
            string[] vntToken;                  // トークン
            int lngTokenCount;                  // トークン数
            int lngRslCount;                    // 結果件数
            String strIKbn;                     // 胃区分
            String strSeq;                      // SEQ
            String strJudCd;
            String strJudRName;
            int i;
            short j;
            short k;

            int[,] JudSenketu = new int[4, 3];// 便潜血判定用
            string[,] judLongStcCode = new string[4, 3];// 便潜血判定用
            string[] judPriCode = new string[3]; // 固定ロジック用
            string[] judResult = new string[4]; // 日付編集項目

            string[,] judAbnormalMark = new string[4, 3]; // 便潜血異常値マーク用

            // 描画オブジェクトコレクションの参照設定
            colCrObjects = cnForm.CnObjects;

            judLongStcCode[1, 1] = "LONGSTC_14322-00";
            judLongStcCode[2, 1] = "LONGSTC_14322-00_1";
            judLongStcCode[3, 1] = "LONGSTC_14322-00_2";
            judLongStcCode[1, 2] = "LONGSTC_14325-00";
            judLongStcCode[2, 2] = "LONGSTC_14325-00_1";
            judLongStcCode[3, 2] = "LONGSTC_14325-00_2";


            judAbnormalMark[1, 1] = "ABNORMALMARK_14322-00";
            judAbnormalMark[2, 1] = "ABNORMALMARK_14322-00_1";
            judAbnormalMark[3, 1] = "ABNORMALMARK_14322-00_2";
            judAbnormalMark[1, 2] = "ABNORMALMARK_14325-00";
            judAbnormalMark[2, 2] = "ABNORMALMARK_14325-00_1";
            judAbnormalMark[3, 2] = "ABNORMALMARK_14325-00_2";


            judPriCode[1] = "PRISHORTSTC_22180-01_22180-02_22180-03_22180-04_22180-05_22180-06_22180-07_22180-08_22180-09_22180-10";
            judPriCode[2] = "PRISHORTSTC_22160-01_22160-03_22160-05_22160-07_22160-09_22160-11";

            judResult[1] = "RESULT_23110-00";
            judResult[2] = "RESULT_23110-00_1";
            judResult[3] = "RESULT_23110-00_2";

            // 今回、前回、前々回受診情報
            // 今回
            ((CnDataField)colCrObjects["CSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
            dynamic IKbnName = SelectIKbnName(objRepConsult.RsvNo);
            ((CnDataField)colCrObjects["CSNAME"]).Text = objRepConsult.CsName + Convert.ToString(IKbnName.NAME).Trim();
            ((CnDataField)colCrObjects["IKBN"]).Text = Convert.ToString(IKbnName.NAME).Trim();

            // Ｘ線、内視鏡非表示処理
            colCrObjects[IBU_NAISIKYODATE].Visible = false;
            colCrObjects[IBU_NAISIKYOLABEL].Visible = false;
            colCrObjects[IBU_NAISIKYODATE + "_1"].Visible = false;
            colCrObjects[IBU_NAISIKYOLABEL + "_1"].Visible = false;
            colCrObjects[IBU_NAISIKYODATE + "_2"].Visible = false;
            colCrObjects[IBU_NAISIKYOLABEL + "_2"].Visible = false;
            switch (IKbnName.SEQ)
            {
                case "2":
                    colCrObjects[IBU_NAISIKYODATE].Visible = true;
                    colCrObjects[IBU_NAISIKYOLABEL].Visible = true;
                    break;
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (objHistory != null)
            {
                ((CnDataField)colCrObjects["CSLDATE_1"]).Text = string.Format("{0:YYYY年M月D日}", objHistory.CslDate);
                IKbnName = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCrObjects["CSNAME_1"]).Text = objHistory.CsName + Convert.ToString(IKbnName.NAME).Trim();
                ((CnDataField)colCrObjects["IKBN_1"]).Text = Convert.ToString(IKbnName.NAME).Trim();
                // Ｘ線、内視鏡非表示処理
                switch (IKbnName.SEQ)
                {
                    case "2":
                        colCrObjects[IBU_NAISIKYODATE + "_1"].Visible = true;
                        colCrObjects[IBU_NAISIKYOLABEL + "_1"].Visible = true;
                        break;
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (objHistory != null)
            {
                ((CnDataField)colCrObjects["CSLDATE_2"]).Text = string.Format("{0:YYYY年M月D日}", objHistory.CslDate);
                IKbnName = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCrObjects["CSNAME_2"]).Text = objHistory.CsName + Convert.ToString(IKbnName.NAME).Trim();
                ((CnDataField)colCrObjects["IKBN_2"]).Text = Convert.ToString(IKbnName.NAME).Trim();
                // Ｘ線、内視鏡非表示処理
                switch (IKbnName.SEQ)
                {
                    case "2":
                        colCrObjects[IBU_NAISIKYODATE + "_2"].Visible = true;
                        colCrObjects[IBU_NAISIKYOLABEL + "_2"].Visible = true;
                        break;
                }
            }

            // 上部消化管
            // 今回
            IList<dynamic> lngRsl = SelectStc_2nd(objRepConsult.RsvNo, GRPCD_JYOUBU);

            if (lngRsl.Count > 0)
            {
                objCrObject = colCrObjects["JYOUBU"];
                // 上部消化管を２列に増やした！
                j = 0;
                i = 0;
                while (!((i > (lngRsl.Count - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                {

                    if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(0, j, lngRsl[i].LONGSTC.Trim());
                        j++;
                    }
                    i++;
                }
                j = 0;
                i = 0;
                k = 0;
                while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                {

                    if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                        j++;
                        if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                        {
                            j = 0;
                            k++;
                        }
                    }
                    i++;
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd(objHistory.RsvNo, GRPCD_JYOUBU);

                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["JYOUBU1"];
                    j = 0;
                    i = 0;
                    while (!((i > (data.Count - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                    {

                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(0, j, data[i].LONGSTC.Trim());
                            j++;
                        }
                        i++;
                    }
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {

                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd(objHistory.RsvNo, GRPCD_JYOUBU);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["JYOUBU2"];
                    j = 0;
                    i = 0;
                    while (!((i > (data.Count - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(0, j, data[i].LONGSTC.Trim());
                            j++;
                        }
                        i++;
                    }
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 上腹部超音波
            // 今回
            lngRsl = SelectStc_2nd(objRepConsult.RsvNo, GRPCD_ECHO);

            if (lngRsl.Count > 0)
            {
                objCrObject = colCrObjects["ECHO"];
                j = 0;
                i = 0;
                while (!((i > (lngRsl.Count - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                {

                    if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(0, j, lngRsl[i].LONGSTC.Trim());
                        j++;
                    }
                    i++;
                }
               
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);

            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd(objHistory.RsvNo, GRPCD_ECHO);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["ECHO_1"];
                    j = 0;
                    i = 0;
                    while (!((i > (data.Count - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(0, j, data[i].LONGSTC.Trim());
                            j++;
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);

            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd(objHistory.RsvNo, GRPCD_ECHO);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["ECHO_2"];
                    j = 0;
                    i = 0;
                    while (!((i > (data.Count - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(0, j, data[i].LONGSTC.Trim());
                            j++;
                        }
                        i++;
                    }
                }
            }

            // 胸部Ｘ線
            // 今回
            lngRsl = SelectStc_2nd(objRepConsult.RsvNo, GRPCD_KYOUBU_X);

            if (lngRsl.Count > 0)
            {
                objCrObject = colCrObjects["KYOUBUX"];
                j = 0;
                i = 0;
                k = 0;
                while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                {

                    if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                        j++;
                        if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                        {
                            j = 0;
                            k++;
                        }
                    }
                    i++;
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd(objHistory.RsvNo, GRPCD_KYOUBU_X);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["KYOUBUX1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> data = SelectStc_2nd(objHistory.RsvNo, GRPCD_KYOUBU_X);
                if (data.Count > 0)
                {
                    objCrObject = colCrObjects["KYOUBUX2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (data.Count - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, data[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }
            // TODO
            // On Error Resume Next

            // 便潜血判定
            for (i = 1; i <= 3; i++)
            {
                // 障害対応 -> 表示制御のクリアを行う
                colCrObjects[judLongStcCode[i, 1]].Visible = true;
                colCrObjects[judLongStcCode[i, 2]].Visible = true;
                switch (Strings.StrConv(((CnDataField)colCrObjects[judLongStcCode[i, 1]]).Text, VbStrConv.Wide))
                {
                    case "検査せず":
                        JudSenketu[i, 1] = 1;
                        break;
                    case "（－）":
                        JudSenketu[i, 1] = 2;
                        break;
                    case "（＋－）":
                        JudSenketu[i, 1] = 3;
                        break;
                    case "（＋）":
                        JudSenketu[i, 1] = 4;
                        break;
                    case "（２＋）":
                        JudSenketu[i, 1] = 5;
                        break;
                    default:
                        JudSenketu[i, 1] = 0;
                        break;

                }
                switch (Strings.StrConv(((CnDataField)colCrObjects[judLongStcCode[i, 2]]).Text, VbStrConv.Wide))
                {
                    case "検査せず":
                        JudSenketu[i, 2] = 1;
                        break;
                    case "（－）":
                        JudSenketu[i, 2] = 2;
                        break;
                    case "（＋－）":
                        JudSenketu[i, 2] = 3;
                        break;
                    case "（＋）":
                        JudSenketu[i, 2] = 4;
                        break;
                    case "（２＋）":
                        JudSenketu[i, 2] = 5;
                        break;
                    default:
                        JudSenketu[i, 2] = 0;
                        break;

                }
                if (JudSenketu[i, 1] < JudSenketu[i, 2])
                {
                    colCrObjects[judLongStcCode[i, 1]].Visible = false;
                }
                else
                {
                    colCrObjects[judLongStcCode[i, 2]].Visible = false;
                }
                colCrObjects[judAbnormalMark[i, 1]].Visible = colCrObjects[judLongStcCode[i, 1]].Visible;
                colCrObjects[judAbnormalMark[i, 2]].Visible = colCrObjects[judLongStcCode[i, 2]].Visible;
            }

            // TODO On Error GoTo 0

            foreach (CnObject rec in colCrObjects)
            {
                switch (rec.Name.ToUpper())
                {
                    case "CSLDATE":
                        ((CnDataField)colCrObjects["CSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "CSLDATEM":
                        ((CnDataField)colCrObjects["CSLDATEM"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "BIRTH":
                        ((CnDataField)colCrObjects["BIRTH"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.Birth);
                        break;
                    case "ECHO1":
                        string leftStr = ((CnListField)colCrObjects["ECHO1"]).ListText(0, 0);
                        leftStr = leftStr.Substring(0, 1);
                        if ("*".Equals(Strings.StrConv(leftStr, VbStrConv.Narrow)))
                        {
                            ((CnListField)colCrObjects["ECHO1"]).ListText(0, 0, "");
                        }
                        break;
                    case "ECHO2":
                        string leftStr2 = ((CnListField)colCrObjects["ECHO2"]).ListText(0, 0);
                        leftStr2 = leftStr2.Substring(0, 1);
                        if ("*".Equals(Strings.StrConv(leftStr2, VbStrConv.Narrow)))
                        {
                            ((CnListField)colCrObjects["ECHO2"]).ListText(0, 0, "");
                        }
                        break;
                    default:
                        // アンダースコアでカラム名を分割
                        vntToken = rec.Name.Split('_');
                        lngTokenCount = vntToken.Length;
                        if (lngTokenCount >= 1)
                        {
                            switch (PrintCommon.ExceptReplicationSign(vntToken[0]).ToUpper())
                            {
                                case "PRISHORTSTC":
                                    string rightStr = rec.Name.TrimEnd();
                                    rightStr = rightStr.Substring(rightStr.Length - 2, 2);
                                    if ("_1".Equals(rightStr) || "_2".Equals(rightStr))
                                    {
                                        if ("*".Equals(Strings.StrConv(((CnListField)rec).ListText(0, 0).Substring(0, 1), VbStrConv.Narrow)))
                                        {
                                            ((CnListField)rec).ListText(0, 0, "");
                                        }
                                    }
                                    break;
                                case "RESULT":
                                case "SHORTSTC":
                                case "LONGSTC":
                                    rightStr = rec.Name.TrimEnd();
                                    rightStr = rightStr.Substring(rightStr.Length - 2, 2);
                                    if ("_1".Equals(rightStr) || "_2".Equals(rightStr))
                                    {
                                        if ("*".Equals(Strings.StrConv(((CnDataField)rec).Text.Substring(0, 1), VbStrConv.Narrow)))
                                        {
                                            ((CnDataField)rec).Text = "";
                                        }
                                    }
                                    break;
                                //Case "SHORTSTC", "LONGSTC"
                                //    If Right(RTrim(objCrObject.Name), 2) = "_1" Or Right(RTrim(objCrObject.Name), 2) = "_2" Then
                                //        If StrConv(Left(objCrObject.Text, 1), vbNarrow) = "*" Then
                                //            objCrObject.Text = ""
                                //        End If
                                //    End If
                                //Case "RESULT"
                                //    If Right(RTrim(objCrObject.Name), 2) = "_1" Or Right(RTrim(objCrObject.Name), 2) = "_2" Then
                                //        If StrConv(Left(objCrObject.Text, 1), vbNarrow) = "*" Then
                                //            objCrObject.Text = ""
                                //        End If
                                //    End If
                                //    For i = 1 To UBound(judResult)
                                //        If objCrObject.Name = judResult(i) Then
                                //            objCrObject.Text = Format$(Format$(objCrObject.Text, "0000/00/00"), "yyyy年m月d日")
                                //        End If
                                //    Next i
                                case "JUDRNAME":
                                    if (Convert.ToInt16(vntToken[1]) >= 1 && Convert.ToInt16(vntToken[1]) <= 28)
                                    {
                                        if (vntToken.Length - 1 <= 1)
                                        {
                                            dynamic data = SelectJudHistoryRsl(objRepConsult.RsvNo, Convert.ToInt16(vntToken[1]), true);
                                            ((CnDataField)rec).Text = data.JUDRNAME;
                                            if (("＊＊").Equals(data.JUDRNAME.ToUpper()))
                                            {
                                                switch (Convert.ToInt16(vntToken[1]))
                                                {
                                                    case 1:
                                                        ((CnListField)colCrObjects[judPriCode[1]]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 4:
                                                        ((CnListField)colCrObjects[judPriCode[2]]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 5:
                                                        ((CnDataField)colCrObjects["RESULT_13020-00"]).Text = "********";
                                                        ((CnDataField)colCrObjects["RESULT_13022-00"]).Text = "********";
                                                        ((CnDataField)colCrObjects["RESULT_13023-00"]).Text = "********";
                                                        ((CnDataField)colCrObjects["RESULT_13024-00"]).Text = "********";

                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13020-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13022-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13023-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13024-00"]).Text = "";
                                                        break;
                                                    case 6:
                                                        ((CnListField)colCrObjects["KYOUBUX"]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 7:
                                                        ((CnListField)colCrObjects["JYOUBU"]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                    case 8:
                                                        ((CnDataField)colCrObjects["LONGSTC_14322-00"]).Text = "＊＊＊＊＊";

                                                        ((CnDataField)colCrObjects["ABNORMALMARK_14322-00"]).Text = "";
                                                        break;
                                                    case 9:
                                                        ((CnListField)colCrObjects["ECHO"]).ListText(0, 0, "＊＊＊＊＊");
                                                        break;
                                                }
                                            }
                                            if (("－－").Equals(data.JUDRNAME.ToUpper()))
                                            {
                                                switch (Convert.ToInt16(vntToken[1]))
                                                {
                                                    case 1:
                                                        ((CnListField)colCrObjects[judPriCode[1]]).ListText(0, 0, "検査せず");
                                                        break;
                                                    case 4:
                                                        ((CnListField)colCrObjects[judPriCode[2]]).ListText(0, 0, "検査せず");
                                                        break;
                                                    case 5:
                                                        ((CnDataField)colCrObjects["RESULT_13020-00"]).Text = "--------";
                                                        ((CnDataField)colCrObjects["RESULT_13022-00"]).Text = "--------";
                                                        ((CnDataField)colCrObjects["RESULT_13023-00"]).Text = "--------";
                                                        ((CnDataField)colCrObjects["RESULT_13024-00"]).Text = "--------";

                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13020-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13022-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13023-00"]).Text = "";
                                                        ((CnDataField)colCrObjects["ABNORMALMARK_13024-00"]).Text = "";
                                                        break;
                                                    case 6:
                                                        ((CnListField)colCrObjects["KYOUBUX"]).ListText(0, 0, "検査せず");
                                                        break;
                                                    case 7:
                                                        ((CnListField)colCrObjects["JYOUBU"]).ListText(0, 0, "検査せず");
                                                        break;
                                                    case 8:
                                                        ((CnDataField)colCrObjects["LONGSTC_14322-00"]).Text = "検査せず";

                                                        ((CnDataField)colCrObjects["ABNORMALMARK_14322-00"]).Text = "";
                                                        break;
                                                    case 9:
                                                        ((CnListField)colCrObjects["ECHO"]).ListText(0, 0, "検査せず");
                                                        break;
                                                }
                                            }
                                        }
                                    }
                                        break;
                            }
                        }
                            break;
                }
            }

            colCrObjects["JUDRNAME_1"].Visible = false;
            colCrObjects["JUDRNAME_2"].Visible = false;
            colCrObjects["JUDRNAME_3"].Visible = false;
            colCrObjects["JUDRNAME_4"].Visible = false;
            colCrObjects["JUDRNAME_5"].Visible = false;
            colCrObjects["JUDRNAME_6"].Visible = false;
            colCrObjects["JUDRNAME_7"].Visible = false;
            colCrObjects["JUDRNAME_8"].Visible = false;
            colCrObjects["JUDRNAME_9"].Visible = false;
            colCrObjects["JUDRNAME_10"].Visible = false;

            // 指定団体グループ以外の団体名・社員番号を非表示とする処理
            Boolean blnOrgGrp = SelectOrgGrp(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_ORGGRP);
            if (blnOrgGrp)
            {
                colCrObjects["LBLEMPNO"].Visible = true;
                colCrObjects["EMPNO"].Visible = true;
            }
            else
            {
                colCrObjects["LBLEMPNO"].Visible = false;
                colCrObjects["EMPNO"].Visible = false;
            }

            // 指定団体の成績表に保険証記号、番号を出力有無チェック Start
            Boolean blnOrgIns = SelectOrgIns(objRepConsult.OrgCd1, objRepConsult.OrgCd2);
            if (blnOrgIns)
            {
                colCrObjects["LBLISRSIGN"].Visible = true;
                colCrObjects["ISRSIGN"].Visible = true;
                colCrObjects["LBLISRNO"].Visible = true;
                colCrObjects["ISRNO"].Visible = true;
            }
            else
            {
                colCrObjects["LBLISRSIGN"].Visible = false;
                colCrObjects["ISRSIGN"].Visible = false;
                colCrObjects["LBLISRNO"].Visible = false;
                colCrObjects["ISRNO"].Visible = false;
            }

        }

        /// <summary>
        /// ３連成績書３枚目の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3N353_3(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// ３連成績書３枚目の編集 2011.01.01版
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3N353_3_2011(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {
            CnObjects colCrObjects;                        // 描画オブジェクトのコレクション
            RepHistory objHistory;                         // 受診履歴クラス
            String strIKbn;                                // 胃区分12
            CnObject objCrObject;                          // 描画オブジェクト
            string[] vntToken;                             // トークン
            int lngTokenCount;                             // トークン数
            CnObject objCrObject1;                         // 描画オブジェクト

            string vntLongStc;                             // 文章
            int lngRslCount;                               // 結果件数
            String strSeq;                                 // SEQ
            String strJudCd;
            String strJudRName;
            String strCrObjName;
            string[] abnormalMarkShortCode = new string[4];
            string[] abnormalMarkResultCode = new string[2];
            int i;
            short j;
            short k;

            Boolean bolVisible;
            Boolean bolKessei;

            string[] judShortCode = new string[4];

            string[] judResultCode = new string[2];

            //    描画オブジェクトコレクションの参照設定
            colCrObjects = cnForm.CnObjects;

            colCrObjects["Line200"].Visible = false;
            judShortCode[1] = "SHORTSTC_12050-00";
            judShortCode[2] = "SHORTSTC_12060-00";
            judShortCode[3] = "SHORTSTC_12070-00";
            judShortCode[4] = "SHORTSTC_12080-00";

            judResultCode[1] = "RESULT_16324-00";
            judResultCode[2] = "RESULT_14028-00";

            abnormalMarkShortCode[1] = "ABNORMALMARK_12050-00";
            abnormalMarkShortCode[2] = "ABNORMALMARK_12060-00";
            abnormalMarkShortCode[3] = "ABNORMALMARK_12070-00";
            abnormalMarkShortCode[4] = "ABNORMALMARK_12080-00";
            abnormalMarkResultCode[1] = "ABNORMALMARK_16324-00";
            abnormalMarkResultCode[2] = "ABNORMALMARK_14028-00";
            foreach (CnObject rec in colCrObjects)
            {
                switch (rec.Name.ToUpper())
                {
                    case "CSLDATE":
                        ((CnDataField)colCrObjects["CSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "CSLDATEM":
                        ((CnDataField)colCrObjects["CSLDATEM"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
                        break;
                    case "BIRTH":
                        ((CnDataField)colCrObjects["BIRTH"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.Birth);
                        break;
                    case "RESULT_16325-00":// 血清学（ＲＦ）
                        ((CnDataField)colCrObjects["RESULT_16325-00"]).Text = SelectStc_RF(objRepConsult.RsvNo, "16325", "00", 0, 1);
                        break;
                    case "RESULT_16325-00_1":// 血清学（ＲＦ－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_16325-00_1"]).Text = SelectStc_RF(objRepConsult.RsvNo, "16325", "00", 1, 1);
                        }
                        break;
                    case "RESULT_16325-00_2":// 血清学（ＲＦ－前々回）
                        objHistory = objRepConsult.Histories.Item(2);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_16325-00_2"]).Text = SelectStc_RF(objRepConsult.RsvNo, "16325", "00", 2, 1);
                        }
                        break;
                    case "RESULT_11020-01":// 視力（裸眼／右）
                        ((CnDataField)colCrObjects["RESULT_11020-01"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "01", 0, 1);
                        break;
                    case "RESULT_11020-01_1":// 視力（裸眼／右－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11020-01_1"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "01", 1, 1);
                        }
                        break;
                    case "RESULT_11020-01_2":// 視力（裸眼／右－前々回）
                        objHistory = objRepConsult.Histories.Item(2);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11020-01_2"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "01", 2, 1);
                        }
                        break;
                    case "RESULT_11020-02":// 視力（裸眼／左）
                        ((CnDataField)colCrObjects["RESULT_11020-02"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "02", 0, 1);
                        break;
                    case "RESULT_11020-02_1":// 視力（裸眼／左－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11020-02_1"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "02", 1, 1);
                        }
                        break;
                    case "RESULT_11020-02_2":// 視力（裸眼／左－前々回）
                        objHistory = objRepConsult.Histories.Item(2);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11020-02_2"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11020", "02", 2, 1);
                        }
                        break;
                    case "RESULT_11022-01":// 視力（矯正／右）
                        ((CnDataField)colCrObjects["RESULT_11022-01"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "01", 0, 1);
                        break;
                    case "RESULT_11022-01_1":// 視力（矯正／右－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11022-01_1"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "01", 1, 1);
                        }
                        break;
                    case "RESULT_11022-01_2":// 視力（矯正／右－前々回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11022-01_2"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "01", 2, 1);
                        }
                        break;
                    case "RESULT_11022-02":// 視力（矯正／左）
                        ((CnDataField)colCrObjects["RESULT_11022-02"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "02", 0, 1);
                        break;
                    case "RESULT_11022-02_1":// （矯正／左－前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11022-02_1"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "02", 1, 1);
                        }
                        break;
                    case "RESULT_11022-02_2":// 視力（矯正／左－前々回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            ((CnDataField)colCrObjects["RESULT_11022-02_2"]).Text = SelectStc_RF(objRepConsult.RsvNo, "11022", "02", 2, 1);
                        }
                        break;
                    default:
                        // アンダースコアでカラム名を分割
                        vntToken = rec.Name.Split('_');
                        lngTokenCount = vntToken.Length;
                        if (lngTokenCount >= 1)
                        {
                            string rightStr = "";
                            switch (PrintCommon.ExceptReplicationSign(vntToken[0]).ToUpper())
                            {
                                case "SHORTSTC":
                                case "LONGSTC":
                                case "RESULT":
                                    rightStr = rec.Name.TrimEnd();
                                    rightStr = rightStr.Substring(rightStr.Length - 2, 2);
                                    if ("_1".Equals(rightStr) || "_2".Equals(rightStr))
                                    {
                                        if ("*".Equals(Strings.StrConv(((CnDataField)rec).Text.Substring(0, 1), VbStrConv.Narrow)))
                                        {
                                            ((CnDataField)rec).Text = "";
                                            ((CnDataField)colCrObjects[rec.Name.Replace(vntToken[0], "ABNORMALMARK")]).Text = "";
                                        }
                                    }
                                    break;
                                case "PRISHORTSTC":
                                    rightStr = rec.Name.TrimEnd();
                                    rightStr = rightStr.Substring(rightStr.Length - 2, 2);
                                    if ("_1".Equals(rightStr) || "_2".Equals(rightStr))
                                    {
                                        if ("*".Equals(Strings.StrConv(((CnListField)rec).ListText(0, 0).Substring(0, 1), VbStrConv.Narrow)))
                                        {
                                            ((CnListField)rec).ListText(0, 0, "");
                                        }
                                    }
                                    break;
                                case "JUDRNAME":
                                    if (Convert.ToInt16(vntToken[1]) >= 1 && Convert.ToInt16(vntToken[1]) <= 31)
                                    {
                                        if (vntToken.Length - 1 <= 1)
                                        {
                                            dynamic data = SelectJudHistoryRsl(objRepConsult.RsvNo, Convert.ToInt16(vntToken[1]), true);
                                            ((CnDataField)rec).Text = data.JUDRNAME;
                                            if (("＊＊").Equals(data.JUDRNAME.ToUpper()))
                                            {
                                                switch (Convert.ToInt16(vntToken[1]))
                                                {
                                                    case 18:
                                                        ((CnListField)colCrObjects[judResultCode[1]]).Text = "********";
                                                        ((CnListField)colCrObjects[abnormalMarkResultCode[1]]).Text = "";
                                                        break;
                                                    case 19:
                                                        ((CnListField)colCrObjects[judResultCode[2]]).Text = "********";
                                                        ((CnListField)colCrObjects[abnormalMarkResultCode[2]]).Text = "";
                                                        break;
                                                    case 21:
                                                        ((CnListField)colCrObjects["SHORTSTC_11176-00"]).Text = "＊＊＊＊＊";
                                                        ((CnListField)colCrObjects["SHORTSTC_11175-00"]).Text = "＊＊＊＊＊";
                                                        ((CnListField)colCrObjects["ABNORMALMARK_11176-00"]).Text = "";
                                                        ((CnListField)colCrObjects["ABNORMALMARK_11175-00"]).Text = "";
                                                        ((CnListField)colCrObjects["SHORTSTC_11530-00"]).Text = "＊＊＊＊＊";
                                                        break;
                                                    case 22:
                                                        ((CnListField)colCrObjects[judShortCode[1]]).Text = "＊＊＊＊＊";
                                                        ((CnListField)colCrObjects[judShortCode[2]]).Text = "＊＊＊＊＊";
                                                        ((CnListField)colCrObjects[judShortCode[3]]).Text = "＊＊＊＊＊";
                                                        ((CnListField)colCrObjects[judShortCode[4]]).Text = "＊＊＊＊＊";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[1]]).Text = "";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[2]]).Text = "";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[3]]).Text = "";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[4]]).Text = "";
                                                        break;
                                                }
                                            }
                                            if (("－－").Equals(data.JUDRNAME.ToUpper()))
                                            {
                                                switch (Convert.ToInt16(vntToken[1]))
                                                {
                                                    case 18:
                                                        ((CnListField)colCrObjects[judResultCode[1]]).Text = "検査せず";
                                                        ((CnListField)colCrObjects[abnormalMarkResultCode[1]]).Text = "";
                                                        break;
                                                    case 19:
                                                        ((CnListField)colCrObjects[judResultCode[2]]).Text = "検査せず";
                                                        ((CnListField)colCrObjects[abnormalMarkResultCode[2]]).Text = "";
                                                        break;
                                                    case 21:
                                                        ((CnListField)colCrObjects["SHORTSTC_11176-00"]).Text = "--------";
                                                        ((CnListField)colCrObjects["SHORTSTC_11175-00"]).Text = "--------";
                                                       ((CnListField)colCrObjects["ABNORMALMARK_11176-00"]).Text = "";
                                                            ((CnListField)colCrObjects["ABNORMALMARK_11175-00"]).Text = "";
                                                        ((CnListField)colCrObjects["SHORTSTC_11530-00"]).Text = "検査せず";
                                                        break;
                                                    case 22:
                                                        ((CnListField)colCrObjects[judShortCode[1]]).Text = "検査せず";
                                                        ((CnListField)colCrObjects[judShortCode[2]]).Text = "検査せず";
                                                        ((CnListField)colCrObjects[judShortCode[3]]).Text = "検査せず";
                                                        ((CnListField)colCrObjects[judShortCode[4]]).Text = "検査せず";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[1]]).Text = "";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[2]]).Text = "";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[3]]).Text = "";
                                                        ((CnListField)colCrObjects[abnormalMarkShortCode[4]]).Text = "";
                                                        break;
                                                    case 28:
                                                        ((CnListField)colCrObjects["RESULT_18426-00"]).Text = "--------";
                                                        ((CnListField)colCrObjects["RESULT_18425-00"]).Text = "--------";
                                                        ((CnListField)colCrObjects["ABNORMALMARK_18426-00"]).Text = "";
                                                        ((CnListField)colCrObjects["ABNORMALMARK_18425-00"]).Text = "";
                                                        break;
                                                }
                                            }
                                        }
                                    }
                                    break;
                            }
                        }
                        break;

                }

                // 関西テレビ放送東京支社春期（ＣＥＡ有CHEST無）場合、
                // TSH、FT4をオプション項目に出力する。
                strCrObjName = (rec.Name).ToUpper();
                if (objRepConsult.OrgCd1.Equals("06035") && objRepConsult.OrgCd2.Equals("00006"))
                {
                    switch (strCrObjName)
                    {
                        case "RESULT_18426-00":
                            ((CnListField)colCrObjects[strCrObjName]).Text = "＊＊＊＊＊";
                            ((CnListField)colCrObjects["ABNORMALMARK_18426 - 00"]).Text = "";
                            break;
                        case "RESULT_18425-00":
                            ((CnListField)colCrObjects[strCrObjName]).Text = "＊＊＊＊＊";
                            ((CnListField)colCrObjects["ABNORMALMARK_18425-00"]).Text = "";
                            break;
                        case "RESULT_18426-00_1":
                            ((CnListField)colCrObjects[strCrObjName]).Text = "";
                            ((CnListField)colCrObjects["ABNORMALMARK_18426-00_1"]).Text = "";
                            break;
                        case "RESULT_18425-00_1":
                            ((CnListField)colCrObjects[strCrObjName]).Text = "";
                            ((CnListField)colCrObjects["ABNORMALMARK_18425-00_1"]).Text = "";
                            break;
                        case "RESULT_18426-00_2":
                            ((CnListField)colCrObjects[strCrObjName]).Text = "";
                            ((CnListField)colCrObjects["ABNORMALMARK_18426-00_2"]).Text = "";
                            break;
                        case "RESULT_18425-00_2":
                            ((CnListField)colCrObjects[strCrObjName]).Text = "";
                            ((CnListField)colCrObjects["ABNORMALMARK_18425-00_2"]).Text = "";
                            break;
                    }
                }
            }

            // 今回、前回、前々回受診情報
            // 今回
            ((CnDataField)colCrObjects["CSLDATE"]).Text = string.Format("{0:YYYY年M月D日}", objRepConsult.CslDate);
            dynamic IKbnName = SelectIKbnName(objRepConsult.RsvNo);
            ((CnDataField)colCrObjects["CSNAME"]).Text = objRepConsult.CsName + Convert.ToString(IKbnName.NAME).Trim();
            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (objHistory != null)
            {
                ((CnDataField)colCrObjects["CSLDATE_1"]).Text = string.Format("{0:YYYY年M月D日}", objHistory.CslDate);
                IKbnName = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCrObjects["CSNAME_1"]).Text = objHistory.CsName + Convert.ToString(IKbnName.NAME).Trim();
            }

            //  前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (objHistory != null)
            {
                ((CnDataField)colCrObjects["CSLDATE_2"]).Text = string.Format("{0:YYYY年M月D日}", objHistory.CslDate);
                IKbnName = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCrObjects["CSNAME_2"]).Text = objHistory.CsName + Convert.ToString(IKbnName.NAME).Trim();
            }

            // 乳房視触診
            // 今回
            objCrObject = colCrObjects["HUJINKA_NYUBOUS"];
            dynamic data2 = SelectJudHistoryRsl(objRepConsult.RsvNo, 54, true);
            switch (Convert.ToInt16(data2.JUDRNAME))
            {
                case "＊＊":
                    ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
                    break;
                case "－－":
                    ((CnListField)objCrObject).ListText(0, 0, "検査せず");
                    break;
                default:
                    j = 0;
                    IList<dynamic> lngRsl = SelectStc(objRepConsult.RsvNo, GRPCD_NYUBOUS);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }

                    }
                    break;
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd(objHistory.RsvNo, GRPCD_NYUBOUS);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_NYUBOUS1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd(objHistory.RsvNo, GRPCD_NYUBOUS);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_NYUBOUS2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 乳房Ｘ線検査 --------------------------------------------
            objCrObject = colCrObjects["HUJINKA_NYUBOUX"];
            data2 = SelectJudHistoryRsl(objRepConsult.RsvNo, 55, true);
            switch (Convert.ToInt16(data2.JUDRNAME))
            {
                case "＊＊":
                    ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
                    break;
                case "－－":
                    ((CnListField)objCrObject).ListText(0, 0, "検査せず");
                    break;
                default:
                    j = 0;
                    IList<dynamic> lngRsl = SelectStc(objRepConsult.RsvNo, GRPCD_NYUBOUX);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        i = 0;
                        while (!((i > (lngRslCount - 1)) || (j > ((CnListField)objCrObject).ListRows.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(0, j, lngRsl[i].LONGSTC.Trim());
                                j++;
                            }
                            i++;
                        }
                    }
                    break;
            }

            // 婦人科(乳房超音波検査)
            objCrObject = colCrObjects["HUJINKA_NYUBOU"];
            data2 = SelectJudHistoryRsl(objRepConsult.RsvNo, 56, true);
            switch (data2.JUDRNAME)
            {
                case "＊＊":
                    ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
                    break;
                case "－－":
                    ((CnListField)objCrObject).ListText(0, 0, "検査せず");
                    break;
                default:
                    j = 0;
                    k = 0;
                    if (!"".Equals(((CnDataField)colCrObjects["SHORTSTC_28700-01"]).Text.TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(0, j, ((CnDataField)colCrObjects["SHORTSTC_28700-01"]).Text);
                        j++;
                    }
                    if (!"".Equals(((CnDataField)colCrObjects["SHORTSTC_28700-02"]).Text.TrimEnd()))
                    {
                        ((CnListField)objCrObject).ListText(0, j, ((CnDataField)colCrObjects["SHORTSTC_28700-02"]).Text);
                        j++;
                    }
                    IList<dynamic> lngRsl = SelectStc_3rd(objRepConsult.RsvNo, GRPCD_NYUBOU);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        i = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }
                    }
                    break;
            }

            // -------------1.婦人科(頚部細胞診-診断) ----------------------------------------
            // 今回
            objCrObject = colCrObjects["HUJINKA_KEIBU"];
            if (((CnDataField)colCrObjects["JUDRNAME_31"]).Text.Equals("＊＊"))
            {
                ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
            }
            else
            {
                if (((CnDataField)colCrObjects["JUDRNAME_31"]).Text.Equals("－－"))
                {
                    ((CnListField)objCrObject).ListText(0, 0, "検査せず");
                }
                else
                {
                    IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objRepConsult.RsvNo, FU_SINDAN_CODE, FU_FCLASS_KEBU);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }
                        if (lngRslCount > 2)
                        {
                            colCrObjects["Line207"].Visible = true;
                        }
                    }
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_SINDAN_CODE, FU_FCLASS_KEBU);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_KEIBU1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                    if (lngRslCount > 2)
                    {
                        colCrObjects["Line207"].Visible = true;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_SINDAN_CODE, FU_FCLASS_KEBU);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_KEIBU2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                    if (lngRslCount > 2)
                    {
                        colCrObjects["Line207"].Visible = true;
                    }
                }
            }

            // -------------2.婦人科(ベセスダ分類) ----------------------------------------
            // 婦人科ベセスダ分類表記変更に伴うシステム変更 STR ###
            // 今回
            objCrObject = colCrObjects["HUJINKA_BETHESDA"];
            objCrObject1 = colCrObjects["HUJINKA_BETHESDA_RPT"];
            if (((CnDataField)colCrObjects["JUDRNAME_31"]).Text.Equals("＊＊"))
            {
                ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
                ((CnListField)objCrObject1).ListText(0, 0, "＊＊＊＊＊");
            }
            else
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objRepConsult.RsvNo, FU_BETHE_CODE, "");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].SHORTSTC.Trim());
                            ((CnListField)objCrObject1).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }

                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_BETHE_CODE, "");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_BETHESDA1"];
                    objCrObject1 = colCrObjects["HUJINKA_BETHESDA_RPT1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].SHORTSTC.Trim());
                            ((CnListField)objCrObject1).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_BETHE_CODE, "");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_BETHESDA2"];
                    objCrObject1 = colCrObjects["HUJINKA_BETHESDA_RPT2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].SHORTSTC.Trim());
                            ((CnListField)objCrObject1).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 婦人科ベセスダ分類表記変更に伴うシステム変更 END ###

            // -------------2.婦人科(クラス分類) ----------------------------------------
            // 今回
            objCrObject = colCrObjects["HUJINKA_CLASS"];
            if (((CnDataField)colCrObjects["JUDRNAME_31"]).Text.Equals("＊＊"))
            {
                ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
            }
            else
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objRepConsult.RsvNo, FU_CLASS_CODE, FU_FCLASS_CLASS);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_CLASS_CODE, FU_FCLASS_CLASS);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_CLASS1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_CLASS_CODE, FU_FCLASS_CLASS);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_CLASS2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // ------------- 婦人科(内診所見) ----------------------------------------------
            // 今回
            objCrObject = colCrObjects["HUJINKA_NASHOKEN"];
            if (((CnDataField)colCrObjects["JUDRNAME_30"]).Text.Equals("＊＊"))
            {
                ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
            }
            else
            {
                if (((CnDataField)colCrObjects["JUDRNAME_30"]).Text.Equals("－－"))
                {
                    ((CnListField)objCrObject).ListText(0, 0, "検査せず");
                }
                else
                {
                    IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objRepConsult.RsvNo, FU_NAISIN_CODE, "");
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }
                        if (lngRslCount > 3)
                        {
                            colCrObjects["Line200"].Visible = true;
                        }
                    }

                }

            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_NAISIN_CODE, "");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_NASHOKEN1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                    if (lngRslCount > 3)
                    {
                        colCrObjects["Line200"].Visible = true;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_NAISIN_CODE, "");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_NASHOKEN2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                    if (lngRslCount > 3)
                    {
                        colCrObjects["Line200"].Visible = true;
                    }
                }
            }


            // -------------( 婦人科内診-診断 )----------------------------------------
            // 今回
            objCrObject = colCrObjects["HUJINKA_NAISIN"];
            if (((CnDataField)colCrObjects["JUDRNAME_30"]).Text.Equals("＊＊"))
            {
                ((CnListField)objCrObject).ListText(0, 0, "＊＊＊＊＊");
            }
            else
            {
                if (((CnDataField)colCrObjects["JUDRNAME_30"]).Text.Equals("－－"))
                {
                    ((CnListField)objCrObject).ListText(0, 0, "検査せず");
                }
                else
                {
                    IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objRepConsult.RsvNo, FU_SINDAN_CODE, "NAISIN");
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }
                    }
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_SINDAN_CODE, "NAISIN");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_NAISIN1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd_FUJIN(objHistory.RsvNo, FU_SINDAN_CODE, "NAISIN");
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["HUJINKA_NAISIN2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                        {
                            ((CnListField)objCrObject).ListText(k, j, lngRsl[i].LONGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCrObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }

            // 眼底
            // 今回
            objCrObject = colCrObjects["GANTEI_SYOKEN"];
            if (((CnDataField)colCrObjects["JUDRNAME_21"]).Text.Equals("＊＊"))
            {

            }
            else
            {
                if (((CnDataField)colCrObjects["JUDRNAME_21"]).Text.Equals("－－"))
                {

                }
                else
                {
                    IList<dynamic> lngRsl = SelectStc_2nd(objRepConsult.RsvNo, GRPCD_GANTEI);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListRows.Count() - 1)))
                        {
                            j = 0;
                            while (!((i > (lngRslCount - 1)) || (j > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                            {
                                if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                                {
                                    ((CnListField)objCrObject).ListText(j, k, lngRsl[i].LONGSTC.Trim());
                                    j++;
                                }
                                i++;
                            }
                            k++;
                        }
                    }
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd(objHistory.RsvNo, GRPCD_GANTEI);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["GANTEI_SYOKEN1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListRows.Count() - 1)))
                    {
                        j = 0;
                        while (!((i > (lngRslCount - 1)) || (j > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(j, k, lngRsl[i].LONGSTC.Trim());
                                j++;
                            }
                            i++;
                        }
                        k++;
                    }
                }
            }
            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                IList<dynamic> lngRsl = SelectStc_2nd(objHistory.RsvNo, GRPCD_GANTEI);
                lngRslCount = lngRsl.Count;
                if (lngRslCount > 0)
                {
                    objCrObject = colCrObjects["GANTEI_SYOKEN2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCrObject).ListRows.Count() - 1)))
                    {
                        j = 0;
                        while (!((i > (lngRslCount - 1)) || (j > ((CnListField)objCrObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].LONGSTC).TrimEnd()))
                            {
                                ((CnListField)objCrObject).ListText(j, k, lngRsl[i].LONGSTC.Trim());
                                j++;
                            }
                            i++;
                        }
                        k++;
                    }
                }
            }

            // 判定用項目の可否設定
            colCrObjects["JUDRNAME_11"].Visible = false;
            colCrObjects["JUDRNAME_12"].Visible = false;
            colCrObjects["JUDRNAME_13"].Visible = false;
            colCrObjects["JUDRNAME_14"].Visible = false;
            colCrObjects["JUDRNAME_15"].Visible = false;
            colCrObjects["JUDRNAME_16"].Visible = false;
            colCrObjects["JUDRNAME_17"].Visible = false;
            colCrObjects["JUDRNAME_18"].Visible = false;
            colCrObjects["JUDRNAME_19"].Visible = false;
            colCrObjects["JUDRNAME_20"].Visible = false;
            colCrObjects["JUDRNAME_21"].Visible = false;
            colCrObjects["JUDRNAME_22"].Visible = false;
            colCrObjects["JUDRNAME_23"].Visible = false;
            colCrObjects["JUDRNAME_24"].Visible = false;
            colCrObjects["JUDRNAME_25"].Visible = false;
            colCrObjects["SHORTSTC_28700-01"].Visible = false;
            colCrObjects["SHORTSTC_28700-02"].Visible = false;
            if (objRepConsult.CslDate < Convert.ToDateTime("2005/01/07"))
            {
                colCrObjects["Label20050107-TSH"].Visible = false;
                colCrObjects["Label20050107-FT4"].Visible = false;
                colCrObjects["Label20050106-TSH"].Visible = true;
                colCrObjects["Label20050106-FT4"].Visible = true;
                if (objRepConsult.CslDate < Convert.ToDateTime("2004/07/20"))
                {
                    colCrObjects["LBL20040719"].Visible = true;
                    colCrObjects["LBL20040720"].Visible = false;
                }
                else
                {
                    colCrObjects["LBL20040719"].Visible = false;
                    colCrObjects["LBL20040720"].Visible = true;
                }
            }
            else
            {
                colCrObjects["Label20050107-TSH"].Visible = true;
                colCrObjects["Label20050107-FT4"].Visible = true;
                colCrObjects["LBL20040720"].Visible = true;
                colCrObjects["Label20050106-TSH"].Visible = false;
                colCrObjects["Label20050106-FT4"].Visible = false;
                colCrObjects["LBL20040719"].Visible = false;

            }

            if (objRepConsult.CslDate < Convert.ToDateTime("2004/10/30"))
            {
                colCrObjects["Label20041029"].Visible = true;
                colCrObjects["Label20041030"].Visible = false;
            }
            else
            {
                colCrObjects["Label20041029"].Visible = false;
                colCrObjects["Label20041030"].Visible = true;
            }
            // 指定団体グループ以外の団体名・社員番号を非表示とする処理
            Boolean blnOrgGrp = SelectOrgGrp(objRepConsult.OrgCd1, objRepConsult.OrgCd2, FREECD_ORGGRP);
            if (blnOrgGrp)
            {
                colCrObjects["LBLEMPNO"].Visible = true;
                colCrObjects["EMPNO"].Visible = true;
            }
            else
            {
                colCrObjects["LBLEMPNO"].Visible = false;
                colCrObjects["EMPNO"].Visible = false;
            }

            Boolean blnOrgIns = SelectOrgIns(objRepConsult.OrgCd1, objRepConsult.OrgCd2);
            if (blnOrgIns)
            {
                colCrObjects["LBLISRSIGN"].Visible = true;
                colCrObjects["ISRSIGN"].Visible = true;
                colCrObjects["LBLISRNO"].Visible = true;
                colCrObjects["ISRNO"].Visible = true;
            }
            else
            {
                colCrObjects["LBLISRSIGN"].Visible = false;
                colCrObjects["ISRSIGN"].Visible = false;
                colCrObjects["LBLISRNO"].Visible = false;
                colCrObjects["ISRNO"].Visible = false;
            }
        }

        /// <summary>
        /// オプション検査結果表の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_ReportN31_8(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// オプション検査結果表の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_ReportN31_8_2017(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// オプション検査結果表(英語)の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_ReportN31E_8(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// オプション検査結果表(英語)の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_ReportN31E_8_2017(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {
  
            CnObject objCnObject;                        // 描画オブジェクト
            RepHistory objHistory;                       // 受診履歴クラス
            CnObjects colCnObjects;                      // 描画オブジェクトのコレクション
            int lngRslCount;                            // 結果件数
            int i;
            short j;
            short k;
            RepResult objResult;                        // 検査結果クラス
            IList<dynamic> lngRsl;

            // 描画オブジェクトコレクションの参照設定
            colCnObjects = cnForm.CnObjects;

            // 受診日
            ((CnDataField)colCnObjects["EDITCSLDATEM"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);

            // 当日ID
            ((CnDataField)colCnObjects["DAYIDM"]).Text = objRepConsult.DayId;

            // 生年月日
            ((CnDataField)colCnObjects["EDITBIRTH"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.Birth);

            // 性別
            ((CnDataField)colCnObjects["EDITGENDER"]).Text = objRepConsult.Gender == 1 ? "Male" : "Female";

            // コース名
            dynamic IKbnName = SelectIKbnName(objRepConsult.RsvNo);
            ((CnDataField)colCnObjects["EDITCSNAME"]).Text = SelectCsEName(objRepConsult.CsCd) + Convert.ToString(IKbnName.NAME).Trim();

            // ローマ字名
            ((CnDataField)colCnObjects["ROMENAME"]).Text = SelectConsult_ROMENAME(objRepConsult.PerId);

            // 今回
            ((CnDataField)colCnObjects["EDITCSLDATE"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);
            ((CnDataField)colCnObjects["DAYID"]).Text = objRepConsult.DayId;
            IKbnName = SelectIKbnName(objRepConsult.RsvNo);
            ((CnDataField)colCnObjects["EDITCSNAME"]).Text = SelectCsEName(objRepConsult.CsCd) + Convert.ToString(IKbnName.NAME).Trim();

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                ((CnDataField)colCnObjects["EDITCSLDATE_1"]).Text = string.Format("{0:yyyy年M月d日}", objHistory.CslDate);
                IKbnName = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCnObjects["EDITCSNAME_1"]).Text = SelectCsEName(objHistory.CsCd) + Convert.ToString(IKbnName.NAME).Trim();
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                ((CnDataField)colCnObjects["EDITCSLDATE_2"]).Text = string.Format("{0:yyyy年M月d日}", objHistory.CslDate);
                IKbnName = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCnObjects["EDITCSNAME_2"]).Text = SelectCsEName(objHistory.CsCd) + Convert.ToString(IKbnName.NAME).Trim();
            }


            // 胸部ＣＴ
            objCnObject = colCnObjects["KYOUBUCT"];
            dynamic data = SelectJudHistoryRsl(objRepConsult.RsvNo, 27, true);
            switch (data.JUDRNAME)
            {
                case "＊＊":
                    ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    break;
                case "－－":
                    ((CnListField)objCnObject).ListText(0, 0, "TEST OMITTED");
                    break;
                default:
                    lngRsl = SelectStc_2nd_E_CT(objRepConsult.RsvNo, GRPCD_DAICHOU);
                    if (lngRsl.Count > 0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCnObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                            {
                                ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }
                    }
                    break;
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                lngRsl = SelectStc_2nd_E_CT(objHistory.RsvNo, GRPCD_KYOUBU_CT);
                if (lngRsl.Count > 0)
                {
                    objCnObject = colCnObjects["KYOUBUCT1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCnObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                        {
                            ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
                else
                {
                    objResult = objHistory.Results.Item("21220-01");
                    if (null != objResult)
                    {
                        objCnObject = colCnObjects["KYOUBUCT1"];
                        ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                lngRsl = SelectStc_2nd_E_CT(objHistory.RsvNo, GRPCD_KYOUBU_CT);
                if (lngRsl.Count > 0)
                {
                    objCnObject = colCnObjects["DAICHOU2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCnObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                        {
                            ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
                else
                {
                    objResult = objHistory.Results.Item("21220-01");
                    if (null != objResult)
                    {
                        objCnObject = colCnObjects["KYOUBUCT2"];
                        ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    }
                }

            }

            // 婦人科(乳房Ｘ線検査)
            objCnObject = colCnObjects["HUJINKA_NYUBOUX"];
            data = SelectJudHistoryRsl(objRepConsult.RsvNo, 55, true);
            switch (Convert.ToInt16(data.JUDRNAME))
            {
                case "＊＊":
                    ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    break;
                case "－－":
                    ((CnListField)objCnObject).ListText(0, 0, "TEST OMITTED");
                    break;
                default:
                    j = 0;
                    lngRsl = SelectStc_E(objRepConsult.RsvNo, GRPCD_NYUBOUX);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        i = 0;
                        while (!((i > (lngRslCount - 1)) || (j > ((CnListField)objCnObject).ListRows.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                            {
                                ((CnListField)objCnObject).ListText(0, j, lngRsl[i].ENGSTC.Trim());
                                j++;
                            }
                            i++;
                        }
                    }
                    break;
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                j = 0;
                lngRsl = SelectStc_E(objHistory.RsvNo, GRPCD_NYUBOUX);
                if (lngRsl.Count > 0)
                {
                    i = 0;
                    objCnObject = colCnObjects["HUJINKA_NYUBOUX1"];
                    while (!((i > (lngRsl.Count - 1)) || (j > ((CnListField)objCnObject).ListRows.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                        {
                            ((CnListField)objCnObject).ListText(0, j, lngRsl[i].ENGSTC.Trim());
                            j++;
                        }
                        i++;
                    }
                }
                else
                {
                    objResult = objHistory.Results.Item("27770-01");
                    if (null != objResult)
                    {
                        objCnObject = colCnObjects["HUJINKA_NYUBOUX1"];
                        ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                j = 0;
                lngRsl = SelectStc_E(objHistory.RsvNo, GRPCD_NYUBOUX);
                if (lngRsl.Count > 0)
                {
                    i = 0;
                    objCnObject = colCnObjects["HUJINKA_NYUBOUX2"];
                    while (!((i > (lngRsl.Count - 1)) || (j > ((CnListField)objCnObject).ListRows.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                        {
                            ((CnListField)objCnObject).ListText(0, j, lngRsl[i].ENGSTC.Trim());
                            j++;
                        }
                        i++;
                    }
                }
                else
                {
                    objResult = objHistory.Results.Item("27770-01");
                    if (null != objResult)
                    {
                        objCnObject = colCnObjects["HUJINKA_NYUBOUX2"];
                        ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    }
                }
            }

            // 婦人科(乳房超音波検査)
            objCnObject = colCnObjects["HUJINKA_NYUBOU"];
            data = SelectJudHistoryRsl(objRepConsult.RsvNo, 56, true);
            switch (data.JUDRNAME)
            {
                case "＊＊":
                    ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    break;
                case "－－":
                    ((CnListField)objCnObject).ListText(0, 0, "TEST OMITTED");
                    break;
                default:
                    j = 0;
                    k = 0;
                    if (!"".Equals(((CnDataField)colCnObjects["ENGSTC_28700-01"]).Text.TrimEnd()))
                    {
                        ((CnListField)objCnObject).ListText(0, j, ((CnDataField)colCnObjects["ENGSTC_28700-01"]).Text);
                        j++;
                    }
                    if (!"".Equals(((CnDataField)colCnObjects["ENGSTC_28700-02"]).Text.TrimEnd()))
                    {
                        ((CnListField)objCnObject).ListText(0, j, ((CnDataField)colCnObjects["ENGSTC_28700-02"]).Text);
                        j++;
                    }
                    lngRsl = SelectStc_3rd(objRepConsult.RsvNo, GRPCD_NYUBOU);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        i = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCnObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                            {
                                ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }
                    }
                    break;
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                objCnObject = colCnObjects["HUJINKA_NYUBOU1"];
                j = 0;
                k = 0;
                if ((Strings.StrConv(Strings.Left(((CnDataField)colCnObjects["ENGSTC_28700-01_1"]).Text, 1), VbStrConv.Narrow) == "*")
                    || Strings.StrConv(Strings.Left(((CnDataField)colCnObjects["ENGSTC_28700-02_1"]).Text, 1), VbStrConv.Narrow) == "*")
                {
                    ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                }
                else
                {
                    if (!("").Equals(((CnDataField)colCnObjects["ENGSTC_28700-01_1"]).Text.TrimEnd()))
                    {
                        ((CnListField)objCnObject).ListText(0, j, ((CnDataField)colCnObjects["ENGSTC_28700-01_1"]).Text);
                        j++;
                    }
                    if (!("").Equals(((CnDataField)colCnObjects["ENGSTC_28700-02_1"]).Text.TrimEnd()))
                    {
                        ((CnListField)objCnObject).ListText(0, j, ((CnDataField)colCnObjects["ENGSTC_28700-02_1"]).Text);
                        j++;
                    }
                    lngRsl = SelectStc_3rd(objHistory.RsvNo, GRPCD_NYUBOU);
                    if (lngRsl.Count > 0)
                    {
                        i = 0;
                        while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCnObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                            {
                                ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }
                    }

                }

            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                objCnObject = colCnObjects["HUJINKA_NYUBOU2"];
                j = 0;
                k = 0;
                if ((Strings.StrConv(Strings.Left(((CnDataField)colCnObjects["ENGSTC_28700-01_2"]).Text, 1), VbStrConv.Narrow) == "*")
                    || Strings.StrConv(Strings.Left(((CnDataField)colCnObjects["ENGSTC_28700-02_2"]).Text, 1), VbStrConv.Narrow) == "*")
                {
                    ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                }
                else
                {
                    if (!("").Equals(((CnDataField)colCnObjects["ENGSTC_28700-01_2"]).Text.TrimEnd()))
                    {
                        ((CnListField)objCnObject).ListText(0, j, ((CnDataField)colCnObjects["ENGSTC_28700-01_2"]).Text);
                        j++;
                    }
                    if (!("").Equals(((CnDataField)colCnObjects["ENGSTC_28700-02_2"]).Text.TrimEnd()))
                    {
                        ((CnListField)objCnObject).ListText(0, j, ((CnDataField)colCnObjects["ENGSTC_28700-02_2"]).Text);
                        j++;
                    }
                    lngRsl = SelectStc_3rd(objHistory.RsvNo, GRPCD_NYUBOU);
                    if (lngRsl.Count > 0)
                    {
                        i = 0;
                        while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCnObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                            {
                                ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim());
                                j++;
                                if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }
                    }

                }

            }

            // 婦人科超音波
            // 今回
            objCnObject = colCnObjects["FUJINKA_ECHO"];
            // 婦人科超音波の判定結果取得
            data = SelectJudHistoryRsl(objRepConsult.RsvNo, 38, true);
            switch (data.JUDRNAME)
            {
                case "＊＊":
                    ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    break;
                case "－－":
                    ((CnListField)objCnObject).ListText(0, 0, "TEST OMITTED");
                    break;
                default:
                    // 婦人科超音波所見として出力する検査結果を読み込む
                    lngRsl = SelectStc_E(objRepConsult.RsvNo, GRPCD_FUJINKA_ECHO);
                    lngRslCount = lngRsl.Count;
                    if (lngRslCount > 0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRslCount - 1)) || (k > ((CnListField)objCnObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                            {
                                ((CnListField)objCnObject).ListText(k, j, Convert.ToString(lngRsl[i].ENGSTC).Trim());
                                j++;
                                if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }

                    }
                    break;
            }

            // 前回
            objCnObject = colCnObjects["FUJINKA_ECHO1"];
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                // 婦人科超音波所見として出力する検査結果を読み込む
                lngRsl = SelectStc_E(objHistory.RsvNo, GRPCD_FUJINKA_ECHO);
                if (lngRsl.Count > 0)
                {
                    i = 0;
                    j = 0;
                    k = 0;
                    while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCnObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                        {
                            ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
                else
                {
                    objResult = objHistory.Results.Item("22802-01");
                    if (null != objResult)
                    {
                        ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    }
                }
            }

            // 前々回
            objCnObject = colCnObjects["FUJINKA_ECHO2"];
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                // 婦人科超音波所見として出力する検査結果を読み込む
                lngRsl = SelectStc_E(objHistory.RsvNo, GRPCD_FUJINKA_ECHO);
                if (lngRsl.Count > 0)
                {
                    i = 0;
                    j = 0;
                    k = 0;
                    while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCnObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                        {
                            ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim());
                            j++;
                            if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                }
            }
            else
            {
                objResult = objHistory.Results.Item("22802-01");
                if (null != objResult)
                {
                    ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                }
            }

            colCnObjects["ENGSTC_28700-01"].Visible = false;
            colCnObjects["ENGSTC_28700-02"].Visible = false;
            colCnObjects["ENGSTC_28700-01_1"].Visible = false;
            colCnObjects["ENGSTC_28700-02_1"].Visible = false;
            colCnObjects["ENGSTC_28700-01_2"].Visible = false;
            colCnObjects["ENGSTC_28700-02_2"].Visible = false;
        }

        /// <summary>
        /// オプション検査結果表の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_ReportN32_8(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// オプション検査結果表の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_ReportN32_8_2017(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// オプション検査結果表(英語)の編集２
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_ReportN32E_8(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// オプション検査結果表(英語)の編集２
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_ReportN32E_8_2017(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {
            CnObject objCnObject;                        // 描画オブジェクト
            RepItem objItem;                             // 検査項目クラス
            RepHistory objHistory;                       // 受診履歴クラス
            RepItemHistory objItemHistory;               // 検査項目履歴クラス
            RepStdValue objStdValue;                     // 基準値クラス

            CnObjects colCnObjects;                      // 描画オブジェクトのコレクション
            RepItemHistories colItemHistories;           // 検査項目履歴コレクション
            RepStdValues colStdValues;                   // 基準値コレクション

            String strSeq;                               // 比較率の最大値を持つ項目のSEQ
            String strIKbn;                              // 胃区分

            //        Dim vntEngStc; As Variant          '文章
            //Dim vntStcCd; As Variant          '文章コード

            String strJudCd;
            String strJudRName;
            String strSize;

            int lngRslCount;            // 結果件数

            int i;
            short j;
            short k;

            RepResult objResult;        // 検査結果クラス
            IList<dynamic> lngRsl;

            // 描画オブジェクトコレクションの参照設定
            colCnObjects = cnForm.CnObjects;

            // 受診日
            ((CnDataField)colCnObjects["EDITCSLDATEM"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);

            // 当日ID
            ((CnDataField)colCnObjects["DAYIDM"]).Text = objRepConsult.DayId;

            // 生年月日
            ((CnDataField)colCnObjects["EDITBIRTH"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.Birth);

            // 性別
            ((CnDataField)colCnObjects["EDITGENDER"]).Text = objRepConsult.Gender == 1 ? "Male" : "Female";

            // コース名
            dynamic IKbnName = SelectIKbnName(objRepConsult.RsvNo);
            ((CnDataField)colCnObjects["EDITCSNAME"]).Text = SelectCsEName(objRepConsult.CsCd) + Convert.ToString(IKbnName.NAME).Trim();

            // ローマ字名
            ((CnDataField)colCnObjects["ROMENAME"]).Text = SelectConsult_ROMENAME(objRepConsult.PerId);

            // 今回
            ((CnDataField)colCnObjects["EDITCSLDATE"]).Text = string.Format("{0:yyyy年M月d日}", objRepConsult.CslDate);
            ((CnDataField)colCnObjects["DAYID"]).Text = objRepConsult.DayId;
            IKbnName = SelectIKbnName(objRepConsult.RsvNo);
            ((CnDataField)colCnObjects["EDITCSNAME"]).Text = SelectCsEName(objRepConsult.CsCd) + Convert.ToString(IKbnName.NAME).Trim();

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null!= objHistory)
            {
                ((CnDataField)colCnObjects["EDITCSLDATE_1"]).Text = string.Format("{0:yyyy年M月d日}", objHistory.CslDate);
                IKbnName = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCnObjects["EDITCSNAME_1"]).Text = SelectCsEName(objHistory.CsCd) + Convert.ToString(IKbnName.NAME).Trim();
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                ((CnDataField)colCnObjects["EDITCSLDATE_2"]).Text = string.Format("{0:yyyy年M月d日}", objHistory.CslDate);
                IKbnName = SelectIKbnName(objHistory.RsvNo);
                ((CnDataField)colCnObjects["EDITCSNAME_2"]).Text = SelectCsEName(objHistory.CsCd) + Convert.ToString(IKbnName.NAME).Trim();
            }

            foreach (CnObject rec in colCnObjects)
            {
                switch (rec.Name.ToUpper())
                {
                    case "RESULT_17580-01":
                        // 抗核抗体
                        if (!("").Equals(SelectStc_RF(objRepConsult.RsvNo, "17580", "01", 0, 1).Trim()))
                        {
                            ((CnDataField)colCnObjects["RESULT_17580-01"]).Text = SelectStc_RF(objRepConsult.RsvNo, "17580", "01", 0, 1);
                        }
                        break;
                    case "RESULT_17580-01_1":
                        // 抗核抗体（前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null!= objHistory)
                        {
                            if (!("").Equals(SelectStc_RF(objHistory.RsvNo, "17580", "01", 1, 1).Trim()))
                            {
                                ((CnDataField)colCnObjects["RESULT_17580-01_1"]).Text = SelectStc_RF(objHistory.RsvNo, "17580", "01", 1, 1);
                            }
                        }
                        break;
                    case "RESULT_17580-01_2":
                        // 抗核抗体（前々回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            if (!("").Equals(SelectStc_RF(objHistory.RsvNo, "17580", "01", 2, 1).Trim()))
                            {
                                ((CnDataField)colCnObjects["RESULT_17580-01_2"]).Text = SelectStc_RF(objHistory.RsvNo, "17580", "01", 2, 1);
                            }
                        }
                        break;

                    case "RESULT_40060-00":
                        // 抗ＣＣＰ抗体
                        if (!("").Equals(SelectStc_RF(objRepConsult.RsvNo, "40060", "00", 0, 1).Trim()))
                        {
                            ((CnDataField)colCnObjects["RESULT_40060-00"]).Text = SelectStc_RF(objRepConsult.RsvNo, "40060", "00", 0, 1);
                        }
                        break;
                    case "RESULT_40060-00_1":
                        // 抗ＣＣＰ抗体（前回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            if (!("").Equals(SelectStc_RF(objHistory.RsvNo, "40060", "00", 1, 1).Trim()))
                            {
                                ((CnDataField)colCnObjects["RESULT_40060-00_1"]).Text = SelectStc_RF(objHistory.RsvNo, "40060", "00", 1, 1);
                            }
                        }
                        break;
                    case "RESULT_40060-00_2":
                        // 抗ＣＣＰ抗体（前々回）
                        objHistory = objRepConsult.Histories.Item(1);
                        if (null != objHistory)
                        {
                            if (!("").Equals(SelectStc_RF(objHistory.RsvNo, "40060", "00", 2, 1).Trim()))
                            {
                                ((CnDataField)colCnObjects["RESULT_40060-00_2"]).Text = SelectStc_RF(objHistory.RsvNo, "40060", "00", 2, 1);
                            }
                        }
                        break;
                }
            }

            // 大腸内視鏡
            objCnObject = colCnObjects["DAICHOU"];
            dynamic data = SelectJudHistoryRsl(objRepConsult.RsvNo, 26, true);
            switch (data.JUDRNAME)
            {
                case "＊＊":
                    ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    ((CnDataField)colCnObjects["RESULT_23530-00"]).Text = "********";
                    break;
                case "－－":
                    ((CnListField)objCnObject).ListText(0, 0, "TEST OMITTED");
                    ((CnDataField)colCnObjects["RESULT_23530-00"]).Text = "";
                    break;
                default:
                    lngRsl = SelectStc_E(objRepConsult.RsvNo, GRPCD_DAICHOU);
                    if (lngRsl.Count>0)
                    {
                        j = 0;
                        i = 0;
                        while (!((i > (lngRsl.Count - 1)) || (j > ((CnListField)objCnObject).ListRows.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                            {
                                ((CnListField)objCnObject).ListText(0, j, lngRsl[i].ENGSTC.Trim());
                                j++;
                            }
                            i++;
                        }
                    }
                    ((CnDataField)colCnObjects["RESULT_23530-00"]).Text = string.Format("{0:YYYY年M月D日}", DateTime.ParseExact(((CnDataField)colCnObjects["RESULT_23530-00"]).Text, "yyyy/MM/dd", System.Globalization.CultureInfo.InvariantCulture));
                    break;
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                lngRsl = SelectStc_E(objHistory.RsvNo, GRPCD_DAICHOU);
                if (lngRsl.Count > 0)
                {
                    objCnObject = colCnObjects["DAICHOU1"];
                    j = 0;
                    i = 0;
                    while (!((i > (lngRsl.Count - 1)) || (j > ((CnListField)objCnObject).ListRows.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                        {
                            ((CnListField)objCnObject).ListText(0, j, lngRsl[i].ENGSTC.Trim());
                            j++;
                        }
                        i++;
                    }
                }
                ((CnDataField)colCnObjects["RESULT_23530-00_1"]).Text = string.Format("{0:YYYY年M月D日}", DateTime.ParseExact(((CnDataField)colCnObjects["RESULT_23530-00_1"]).Text, "yyyy/MM/dd", System.Globalization.CultureInfo.InvariantCulture));
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                lngRsl = SelectStc_E(objHistory.RsvNo, GRPCD_DAICHOU);
                if (lngRsl.Count > 0)
                {
                    objCnObject = colCnObjects["DAICHOU2"];
                    j = 0;
                    i = 0;
                    while (!((i > (lngRsl.Count - 1)) || (j > ((CnListField)objCnObject).ListRows.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                        {
                            ((CnListField)objCnObject).ListText(0, j, lngRsl[i].ENGSTC.Trim());
                            j++;
                        }
                        i++;
                    }
                }
                ((CnDataField)colCnObjects["RESULT_23530-00_2"]).Text = string.Format("{0:YYYY年M月D日}", DateTime.ParseExact(((CnDataField)colCnObjects["RESULT_23530-00_2"]).Text, "yyyy/MM/dd", System.Globalization.CultureInfo.InvariantCulture));
            }

            // 大腸３Ｄ－ＣＴ
            // 今回
            objCnObject = colCnObjects["DAICYOCT"];
            data = SelectJudHistoryRsl(objRepConsult.RsvNo, 33, true);
            switch (data.JUDRNAME)
            {
                case "＊＊":
                    ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    break;
                case "－－":
                    ((CnListField)objCnObject).ListText(0, 0, "TEST OMITTED");
                    break;
                default:
                    lngRsl = SelectStc_StcCd_E(objRepConsult.RsvNo, GRPCD_DAICHOU);
                    if (lngRsl.Count > 0)
                    {
                        j = 0;
                        i = 0;
                        k = 0;
                        while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCnObject).ListColumns.Count() - 1)))
                        {
                            if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).TrimEnd()))
                            {
                                strSize = "";
                                switch (lngRsl[i].STCCD.Trim())
                                {
                                    case "1001":
                                        if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23820-00"]).Text.Trim())))
                                        {
                                            strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23820-00"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23820-00"]).Text.Trim();
                                        }
                                         ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["ENGSTC_23830-00"]).Text.Trim());
                                        break;
                                    case "2001":
                                        if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23850-00"]).Text.Trim())))
                                        {
                                            strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23850-00"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23850-00"]).Text.Trim();
                                        }
                                         ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["ENGSTC_23860-00"]).Text.Trim());
                                        break;
                                    case "3001":
                                        if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23880-00"]).Text.Trim())))
                                        {
                                            strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23880-00"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23880-00"]).Text.Trim();
                                        }
                                         ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["ENGSTC_23890-00"]).Text.Trim());
                                        break;
                                    case "4001":
                                        if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23920-00"]).Text.Trim())))
                                        {
                                            strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23920-00"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23920-00"]).Text.Trim();
                                        }
                                         ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["ENGSTC_23930-00"]).Text.Trim());
                                        break;
                                    case "5001":
                                        if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23950-00"]).Text.Trim())))
                                        {
                                            strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23950-00"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23950-00"]).Text.Trim();
                                        }
                                         ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["ENGSTC_23960-00"]).Text.Trim());
                                        break;
                                    default:
                                        ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim());
                                        break;
                                }
                                j++;
                                if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                                {
                                    j = 0;
                                    k++;
                                }
                            }
                            i++;
                        }
                    }
                    ((CnDataField)colCnObjects["RESULT_23981-00"]).Text = string.Format("{0:YYYY年M月D日}", DateTime.ParseExact(((CnDataField)colCnObjects["RESULT_23981-00"]).Text, "yyyy/MM/dd", System.Globalization.CultureInfo.InvariantCulture));
                    break;
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                lngRsl = SelectStc_StcCd_E(objHistory.RsvNo, GRPCD_DAICYO_CT);
                if (lngRsl.Count > 0)
                {
                    objCnObject = colCnObjects["DAICYOCT1"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCnObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].ENGSTC).TrimEnd()))
                        {
                            strSize = "";
                            switch (lngRsl[i].STCCD.Trim())
                            {
                                case "1001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23820-00_1"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23820-00_1"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23820-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["ENGSTC_23830-00_1"]).Text.Trim());
                                    break;
                                case "2001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23850-00_1"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23850-00_1"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23850-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["ENGSTC_23860-00_1"]).Text.Trim());
                                    break;
                                case "3001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23880-00_1"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23880-00_1"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23880-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["ENGSTC_23890-00_1"]).Text.Trim());
                                    break;
                                case "4001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23920-00_1"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23920-00_1"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23920-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["ENGSTC_23930-00_1"]).Text.Trim());
                                    break;
                                case "5001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23950-00_1"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23950-00_1"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23950-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["ENGSTC_23960-00_1"]).Text.Trim());
                                    break;
                                default:
                                    ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim());
                                    break;
                            }
                            j++;
                            if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                ((CnDataField)colCnObjects["RESULT_23981-00_1"]).Text = string.Format("{0:YYYY年M月D日}", DateTime.ParseExact(((CnDataField)colCnObjects["RESULT_23981-00_1"]).Text, "yyyy/MM/dd", System.Globalization.CultureInfo.InvariantCulture));
                }
                else
                {
                    objResult = objHistory.Results.Item("23970-01");
                    if (null != objResult)
                    {
                        objCnObject = colCnObjects["DAICYOCT1"];
                        ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    }
                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                lngRsl = SelectStc_StcCd_E(objHistory.RsvNo, GRPCD_DAICYO_CT);
                if (lngRsl.Count > 0)
                {
                    objCnObject = colCnObjects["DAICHOU2"];
                    j = 0;
                    i = 0;
                    k = 0;
                    while (!((i > (lngRsl.Count - 1)) || (k > ((CnListField)objCnObject).ListColumns.Count() - 1)))
                    {
                        if (!"".Equals(Convert.ToString(data[i].ENGSTC).TrimEnd()))
                        {
                            strSize = "";
                            switch (lngRsl[i].STCCD.Trim())
                            {
                                case "1001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23820-00_2"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23820-00_2"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23820-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["ENGSTC_23830-00_2"]).Text.Trim());
                                    break;
                                case "2001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23850-00_2"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23850-00_2"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23850-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["ENGSTC_23860-00_2"]).Text.Trim());
                                    break;
                                case "3001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23880-00_2"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23880-00_2"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23880-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["ENGSTC_23890-00_2"]).Text.Trim());
                                    break;
                                case "4001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23920-00_2"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23920-00_2"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23920-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["ENGSTC_23930-00_2"]).Text.Trim());
                                    break;
                                case "5001":
                                    if (!(("").Equals(((CnDataField)colCnObjects["RESULT_23950-00_2"]).Text.Trim())))
                                    {
                                        strSize = Strings.StrConv(((CnDataField)colCnObjects["RESULT_23950-00_2"]).Text.Trim(), VbStrConv.Wide) + ((CnDataField)colCnObjects["UNIT_23950-00"]).Text.Trim();
                                    }
                                     ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim() + strSize + "　" + ((CnDataField)colCnObjects["ENGSTC_23960-00_2"]).Text.Trim());
                                    break;
                                default:
                                    ((CnListField)objCnObject).ListText(k, j, lngRsl[i].ENGSTC.Trim());
                                    break;
                            }
                            j++;
                            if (j > (((CnListField)objCnObject).ListRows.Count() - 1))
                            {
                                j = 0;
                                k++;
                            }
                        }
                        i++;
                    }
                ((CnDataField)colCnObjects["RESULT_23981-00_2"]).Text = string.Format("{0:YYYY年M月D日}", DateTime.ParseExact(((CnDataField)colCnObjects["RESULT_23981-00_2"]).Text, "yyyy/MM/dd", System.Globalization.CultureInfo.InvariantCulture));
                }
                else
                {
                    objResult = objHistory.Results.Item("23970-01");
                    if (null != objResult)
                    {
                        objCnObject = colCnObjects["DAICYOCT2"];
                        ((CnListField)objCnObject).ListText(0, 0, "＊＊＊＊＊");
                    }
                }
            }

            // 頸動脈超音波
            // 今回
            lngRsl = SelectStc_StcCd_E(objRepConsult.RsvNo, GRPCD_PLAQUE);
            ((CnListField)colCnObjects["PLAQUE"]).Text = "";
            if (lngRsl.Count>0)
            {
                i = 0;
                while (!((i > (lngRsl.Count - 1))))
                {
                    if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).Trim()))
                    {
                        if (((CnDataField)colCnObjects["PLAQUE"]).Text.Trim() != Convert.ToString(lngRsl[i].ENGSTC).Trim())
                        {
                            ((CnDataField)colCnObjects["PLAQUE"]).Text = Convert.ToString(lngRsl[i].ENGSTC).Trim();
                        }
                        if (lngRsl[i].STCCD.Trim().Substring(3, 2).Equals("01"))
                        {
                            break;
                        }
                    }
                    i++;
                }
            }

            // 前回
            objHistory = objRepConsult.Histories.Item(1);
            if (null != objHistory)
            {
                lngRsl = SelectStc_StcCd_E(objHistory.RsvNo, GRPCD_PLAQUE);
                lngRslCount = lngRsl.Count;
                ((CnDataField)colCnObjects["PLAQUE1"]).Text = "";
                if (lngRslCount > 0)
                {
                    i = 0;
                    while (!(i > (lngRslCount - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).Trim()))
                        {
                            if (((CnDataField)colCnObjects["PLAQUE1"]).Text.Trim() != Convert.ToString(lngRsl[i].ENGSTC).Trim())
                            {
                                ((CnDataField)colCnObjects["PLAQUE1"]).Text = Convert.ToString(lngRsl[i].ENGSTC).Trim();
                            }
                            if (lngRsl[i].STCCD.Trim().Substring(3, 2).Equals("01"))
                            {
                                break;
                            }
                        }
                        i++;
                    }

                }
            }

            // 前々回
            objHistory = objRepConsult.Histories.Item(2);
            if (null != objHistory)
            {
                lngRsl = SelectStc_StcCd_E(objHistory.RsvNo, GRPCD_PLAQUE);
                lngRslCount = lngRsl.Count;
                ((CnDataField)colCnObjects["PLAQUE2"]).Text = "";
                if (lngRslCount > 0)
                {
                    i = 0;
                    while (!(i > (lngRslCount - 1)))
                    {
                        if (!"".Equals(Convert.ToString(lngRsl[i].ENGSTC).Trim()))
                        {
                            if (((CnDataField)colCnObjects["PLAQUE2"]).Text.Trim() != Convert.ToString(lngRsl[i].ENGSTC).Trim())
                            {
                                ((CnDataField)colCnObjects["PLAQUE2"]).Text = Convert.ToString(lngRsl[i].ENGSTC).Trim();
                            }
                            if (lngRsl[i].STCCD.Trim().Substring(3, 2).Equals("01"))
                            {
                                break;
                            }
                        }
                        i++;
                    }

                }
            }

            // 「抗核抗体」、「抗ＣＣＰ抗体」実際の基準値と基準値マスターの設定が異なる為、例外処理 START
            // 抗核抗体
            if (((CnDataField)colCnObjects["RESULT_17580-01"]).Text.IndexOf("＞") >= 0 || ((CnDataField)colCnObjects["RESULT_17580-01"]).Text.IndexOf(">") >= 0)
            {
                ((CnDataField)colCnObjects["ABNORMALMARK_17580-01"]).Text = "";
            }
            if (((CnDataField)colCnObjects["RESULT_17580-01_1"]).Text.IndexOf("＞") >= 0 || ((CnDataField)colCnObjects["RESULT_17580-01_1"]).Text.IndexOf(">") >= 0)
            {
                ((CnDataField)colCnObjects["ABNORMALMARK_17580-01_1"]).Text = "";
            }
            if (((CnDataField)colCnObjects["RESULT_17580-01_2"]).Text.IndexOf("＞") >= 0 || ((CnDataField)colCnObjects["RESULT_17580-01_2"]).Text.IndexOf(">") >= 0)
            {
                ((CnDataField)colCnObjects["ABNORMALMARK_17580-01_2"]).Text = "";
            }

            // 抗ＣＣＰ抗体
            if (((CnDataField)colCnObjects["RESULT_40060-00"]).Text.IndexOf("＞") >= 0 || ((CnDataField)colCnObjects["RESULT_40060-00"]).Text.IndexOf(">") >= 0)
            {
                ((CnDataField)colCnObjects["ABNORMALMARK_40060-00"]).Text = "";
            }
            if (((CnDataField)colCnObjects["RESULT_40060-00_1"]).Text.IndexOf("＞") >= 0 || ((CnDataField)colCnObjects["RESULT_40060-00_1"]).Text.IndexOf(">") >= 0)
            {
                ((CnDataField)colCnObjects["ABNORMALMARK_40060-00_1"]).Text = "";
            }
            if (((CnDataField)colCnObjects["RESULT_40060-00_2"]).Text.IndexOf("＞") >= 0 || ((CnDataField)colCnObjects["RESULT_40060-00_2"]).Text.IndexOf(">") >= 0)
            {
                ((CnDataField)colCnObjects["ABNORMALMARK_40060-00_2"]).Text = "";
            }

            // インボディオプション検査受診の場合、特定コメント出力 START
            if (CheckSetClass(objRepConsult.RsvNo, INBODY_SETCLASSCD))
            {
                ((CnDataField)colCnObjects["INBODYCOMMENT"]).Text = CMT_INBODY_E;
            }
            else
            {
                ((CnDataField)colCnObjects["INBODYCOMMENT"]).Text = "＊＊＊＊＊";
            }
            // インボディオプション検査受診の場合、特定コメント出力 END
            // 「抗核抗体」、「抗ＣＣＰ抗体」実際の基準値と基準値マスターの設定が異なる為、例外処理 END 

            colCnObjects["RESULT_23820-00"].Visible = false;
            colCnObjects["RESULT_23850-00"].Visible = false;
            colCnObjects["RESULT_23880-00"].Visible = false;
            colCnObjects["RESULT_23920-00"].Visible = false;
            colCnObjects["RESULT_23950-00"].Visible = false;

            colCnObjects["ENGSTC_23830-00"].Visible = false;
            colCnObjects["ENGSTC_23860-00"].Visible = false;
            colCnObjects["ENGSTC_23890-00"].Visible = false;
            colCnObjects["ENGSTC_23930-00"].Visible = false;
            colCnObjects["ENGSTC_23960-00"].Visible = false;

            colCnObjects["RESULT_23820-00_1"].Visible = false;
            colCnObjects["RESULT_23850-00_1"].Visible = false;
            colCnObjects["RESULT_23880-00_1"].Visible = false;
            colCnObjects["RESULT_23920-00_1"].Visible = false;
            colCnObjects["RESULT_23950-00_1"].Visible = false;

            colCnObjects["ENGSTC_23830-00_1"].Visible = false;
            colCnObjects["ENGSTC_23860-00_1"].Visible = false;
            colCnObjects["ENGSTC_23890-00_1"].Visible = false;
            colCnObjects["ENGSTC_23930-00_1"].Visible = false;
            colCnObjects["ENGSTC_23960-00_1"].Visible = false;

            colCnObjects["RESULT_23820-00_2"].Visible = false;
            colCnObjects["RESULT_23850-00_2"].Visible = false;
            colCnObjects["RESULT_23880-00_2"].Visible = false;
            colCnObjects["RESULT_23920-00_2"].Visible = false;
            colCnObjects["RESULT_23950-00_2"].Visible = false;

            colCnObjects["ENGSTC_23830-00_2"].Visible = false;
            colCnObjects["ENGSTC_23860-00_2"].Visible = false;
            colCnObjects["ENGSTC_23890-00_2"].Visible = false;
            colCnObjects["ENGSTC_23930-00_2"].Visible = false;
            colCnObjects["ENGSTC_23960-00_2"].Visible = false;

            colCnObjects["UNIT_23820-00"].Visible = false;
            colCnObjects["UNIT_23850-00"].Visible = false;
            colCnObjects["UNIT_23880-00"].Visible = false;
            colCnObjects["UNIT_23920-00"].Visible = false;
            colCnObjects["UNIT_23950-00"].Visible = false;
        }

        /// <summary>
        /// 指定グループ内検査項目における文章を取得（大腸３Ｄ－ＣＴ、頸動脈超音波用）
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="strGrpCd">グループコード</param>
        /// <returns></returns>
        private IList<dynamic> SelectStc_StcCd(int lngRsvNo, string strGrpCd)
        {
            string sql;             // SQLステートメント
            bool blnFind = false;   // 検索フラグ
            int lngCount = 0;       // レコード数
            IList<dynamic> retData = new List<dynamic>();

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("grpcd", strGrpCd);
            sql = @"
                   select
                      sentence.reptstc shortstc
                      , sentence.reptstc longstc
                      , sentence.stccd 
                    from
                      rsl
                      , item_c
                      , grp_i
                      , sentence 
                    where
                      rsl.rsvno = :rsvno 
                      and grp_i.grpcd = :grpcd 
                      and rsl.itemcd = grp_i.itemcd 
                      and rsl.suffix = grp_i.suffix 
                      and rsl.itemcd = item_c.itemcd 
                      and rsl.suffix = item_c.suffix 
                      and item_c.itemcd = sentence.itemcd 
                      and item_c.itemtype = sentence.itemtype 
                      and rsl.result = sentence.stccd 
                    order by
                      nvl(sentence.printorder, 99999)
                      , grp_i.seq
                      , rsl.itemcd
                      , rsl.suffix
                ";
            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            // 配列形式で格納する(日本語版)
            foreach (var rec in data)
            {
                string strShortStc = Convert.ToString(rec.SHORTSTC);
                string strLongStc = Convert.ToString(rec.LONGSTC);

                // 重複しない文章のみ抽出する
                blnFind = false;
                int i = 0;
                while (!(i > (lngCount - 1)))
                {
                    if (strShortStc.Equals(Convert.ToString(data[i].SHORTSTC)) && strLongStc.Equals(Convert.ToString(data[i].LONGSTC)))
                    {
                        blnFind = true;
                        break;
                    }
                    i++;
                }
                if (!blnFind)
                {
                    retData.Add(rec);
                    lngCount++;
                }
            }

            return retData;
        }

        /// <summary>
        /// 指定グループ内検査項目における文章を取得（大腸３Ｄ－ＣＴ、頸動脈超音波用）
        /// </summary>
        /// <param name="lngRsvNo">予約番号</param>
        /// <param name="strGrpCd">グループコード</param>
        /// <returns></returns>
        private IList<dynamic> SelectStc_StcCd_E(int lngRsvNo, string strGrpCd)
        {
            string sql;             // SQLステートメント
            bool blnFind = false;   // 検索フラグ
            int lngCount = 0;       // レコード数
            IList<dynamic> retData = new List<dynamic>();

            // キー値の設定
            IDictionary<string, object> sqlParam = new Dictionary<string, object>();
            sqlParam.Add("rsvno", lngRsvNo);
            sqlParam.Add("grpcd", strGrpCd);

            sql = @"
                  select
                      sentence.engstc
                      , sentence.stccd 
                    from
                      rsl
                      , item_c
                      , grp_i
                      , sentence 
                    where
                      rsl.rsvno = :rsvno 
                      and grp_i.grpcd = :grpcd 
                      and rsl.itemcd = grp_i.itemcd 
                      and rsl.suffix = grp_i.suffix 
                      and rsl.itemcd = item_c.itemcd 
                      and rsl.suffix = item_c.suffix 
                      and item_c.itemcd = sentence.itemcd 
                      and item_c.itemtype = sentence.itemtype 
                      and rsl.result = sentence.stccd 
                    order by
                      nvl(sentence.printorder, 99999)
                      , grp_i.seq
                      , rsl.itemcd
                      , rsl.suffix
                ";

            IList<dynamic> data = connection.Query(sql, sqlParam).ToList();

            // 配列形式で格納する(日本語版)
            foreach (var rec in data)
            {
                string strEngStc = Convert.ToString(rec.ENGSTC);

                // 重複しない文章のみ抽出する
                blnFind = false;
                int i = 0;
                while (!(i > (lngCount - 1)))
                {
                    if (strEngStc.Equals(Convert.ToString(data[i].ENGSTC)))
                    {
                        blnFind = true;
                        break;
                    }
                    i++;
                }
                if (!blnFind)
                {
                    retData.Add(rec);
                    lngCount++;
                }
            }

            return retData;
        }

        /// <summary>
        /// 2012年版問診回答表編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report6N320_5_2012(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 食習慣問診編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditEatingHabits(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 食習慣問診グラフ編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void DrawGraph_EatingHabits(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 婦人科総合判定可視制御
        /// </summary>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_View_FujinkaEcho_Judge(RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// オプション検査結果表(婦人科超音波全結果)の編集(企業用)
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_Report3N323_8_FujinkaEcho(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// 婦人科超音波全検査結果の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_FujinkaEcho_AllResults(
            RepItems colItems,
            RepConsult objRepConsult,
            CnForm cnForm,
            bool blnEnglish,
            bool blnVisible = true,
            bool blnControlViewLastResult = false)
        {

        }

        /// <summary>
        /// 婦人科超音波検査結果の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_FujinkaEcho_Result(
            RepItems colItems,
            RepConsult objRepConsult,
            CnObject cnForm,
            bool blnEnglish,
            bool blnVisible,
            string strDefResult,
            bool blnControlViewLastResult)
        {

        }

        /// <summary>
        /// オプション検査結果表(2013年版)婦人科超音波所見の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_ReportN31_8_2013(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

        /// <summary>
        /// オプション検査結果表(英語・2013年版)婦人科超音波所見の編集
        /// </summary>
        /// <param name="colItems">検査項目コレクション</param>
        /// <param name="objRepConsult">受診情報クラス</param>
        /// <param name="cnForm">CoReportフォームオブジェクト</param>
        private void EditItem_ReportN31E_8_2013(RepItems colItems, RepConsult objRepConsult, CnForm cnForm)
        {

        }

    }
}
