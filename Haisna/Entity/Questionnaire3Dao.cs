using Dapper;
using Entity.Helper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity.Model.Result;
using Newtonsoft.Json.Linq;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data;
using System.Linq;
using System.Threading;

namespace Hainsi.Entity
{
    /// <summary>
    /// Questionnaire3Daoデータアクセスオブジェクト
    /// </summary>
    public class Questionnaire3Dao : AbstractDao
    {
        /// <summary>
        /// Person処理アクセスオブジェクト
        /// </summary>
        readonly PersonDao personDao;

        /// <summary>
        /// Result処理アクセスオブジェクト
        /// </summary>
        readonly ResultDao resultDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        /// <param name="personDao">PersonDaoオブジェクト</param>
        /// <param name="resultDao">ResultDaoオブジェクト</param>
        public Questionnaire3Dao(IDbConnection connection, PersonDao personDao, ResultDao resultDao) : base(connection)
        {
            this.personDao = personDao;
            this.resultDao = resultDao;
        }

        private Dictionary<string, RslOcrSp3> mcolOcrNyuryoku; // OCR入力結果レコードのコレクション

        private int ocrErrCnt;                                  // エラー数
        private List<int> ocrErrNo = new List<int>();           // エラーNo
        private List<string> ocrErrState = new List<string>();  // エラー状態
        private List<string> ocrErrMsg = new List<string>();    // エラーメッセージ

        private bool stomachFlg; // 胃Ｘ線の依頼フラグ
        private bool fujinkaFlg; // 婦人科の依頼フラグ

        private const string OCR_ERRSTAT_ERROR = "1";           // エラー
        private const string OCR_ERRSTAT_WARNING = "2";         // ワーニング

        // OCR入力結果画面へ表示する検査項目
        private const string OCR_ITEM001 = "1";    //同意書（ドック全体）
        private const string OCR_ITEM002 = "2";    //同意書（ＧＦ）
        private const string OCR_ITEM003 = "3";    //同意書（ＨＰＶ）
        private const string OCR_ITEM004 = "4";    //ブスコパン可否
        private const string OCR_ITEM005 = "5";    //当日朝食摂取有無
        private const string OCR_ITEM006 = "6";    //現病歴受診中(1)OCR値－１
        private const string OCR_ITEM007 = "7";    //現病歴受診中(1)OCR値－２
        private const string OCR_ITEM008 = "8";    //現病歴受診中(1)OCR値－３
        private const string OCR_ITEM009 = "9";    //現病歴受診中(2)OCR値－１
        private const string OCR_ITEM010 = "10";   //現病歴受診中(2)OCR値－２
        private const string OCR_ITEM011 = "11";   //現病歴受診中(2)OCR値－３
        private const string OCR_ITEM012 = "12";   //現病歴受診中(3)OCR値－１
        private const string OCR_ITEM013 = "13";   //現病歴受診中(3)OCR値－２
        private const string OCR_ITEM014 = "14";   //現病歴受診中(3)OCR値－３
        private const string OCR_ITEM015 = "15";   //現病歴受診中(4)OCR値－１
        private const string OCR_ITEM016 = "16";   //現病歴受診中(4)OCR値－２
        private const string OCR_ITEM017 = "17";   //現病歴受診中(4)OCR値－３
        private const string OCR_ITEM018 = "18";   //現病歴受診中(5)OCR値－１
        private const string OCR_ITEM019 = "19";   //現病歴受診中(5)OCR値－２
        private const string OCR_ITEM020 = "20";   //現病歴受診中(5)OCR値－３
        private const string OCR_ITEM021 = "21";   //現病歴受診中(6)OCR値－１
        private const string OCR_ITEM022 = "22";   //現病歴受診中(6)OCR値－２
        private const string OCR_ITEM023 = "23";   //現病歴受診中(6)OCR値－３
        private const string OCR_ITEM024 = "24";   //過去病歴(1)OCR値－１
        private const string OCR_ITEM025 = "25";   //過去病歴(1)OCR値－２
        private const string OCR_ITEM026 = "26";   //過去病歴(1)OCR値－３
        private const string OCR_ITEM027 = "27";   //過去病歴(2)OCR値－１
        private const string OCR_ITEM028 = "28";   //過去病歴(2)OCR値－２
        private const string OCR_ITEM029 = "29";   //過去病歴(2)OCR値－３
        private const string OCR_ITEM030 = "30";   //過去病歴(3)OCR値－１
        private const string OCR_ITEM031 = "31";   //過去病歴(3)OCR値－２
        private const string OCR_ITEM032 = "32";   //過去病歴(3)OCR値－３
        private const string OCR_ITEM033 = "33";   //過去病歴(4)OCR値－１
        private const string OCR_ITEM034 = "34";   //過去病歴(4)OCR値－２
        private const string OCR_ITEM035 = "35";   //過去病歴(4)OCR値－３
        private const string OCR_ITEM036 = "36";   //現病歴受診終了(5)OCR値－１
        private const string OCR_ITEM037 = "37";   //現病歴受診終了(5)OCR値－２
        private const string OCR_ITEM038 = "38";   //現病歴受診終了(5)OCR値－３
        private const string OCR_ITEM039 = "39";   //現病歴受診終了(6)OCR値－１
        private const string OCR_ITEM040 = "40";   //現病歴受診終了(6)OCR値－２
        private const string OCR_ITEM041 = "41";   //現病歴受診終了(6)OCR値－３
        private const string OCR_ITEM042 = "42";   //家族病歴(1)OCR値－１
        private const string OCR_ITEM043 = "43";   //家族病歴(1)OCR値－２
        private const string OCR_ITEM044 = "44";   //家族病歴(1)OCR値－３
        private const string OCR_ITEM045 = "45";   //家族病歴(2)OCR値－１
        private const string OCR_ITEM046 = "46";   //家族病歴(2)OCR値－２
        private const string OCR_ITEM047 = "47";   //家族病歴(2)OCR値－３
        private const string OCR_ITEM048 = "48";   //家族病歴(3)OCR値－１
        private const string OCR_ITEM049 = "49";   //家族病歴(3)OCR値－２
        private const string OCR_ITEM050 = "50";   //家族病歴(3)OCR値－３
        private const string OCR_ITEM051 = "51";   //家族病歴(4)OCR値－１
        private const string OCR_ITEM052 = "52";   //家族病歴(4)OCR値－２
        private const string OCR_ITEM053 = "53";   //家族病歴(4)OCR値－３
        private const string OCR_ITEM054 = "54";   //家族病歴(5)OCR値－１
        private const string OCR_ITEM055 = "55";   //家族病歴(5)OCR値－２
        private const string OCR_ITEM056 = "56";   //家族病歴(5)OCR値－３
        private const string OCR_ITEM057 = "57";   //家族病歴(6)OCR値－１
        private const string OCR_ITEM058 = "58";   //家族病歴(6)OCR値－２
        private const string OCR_ITEM059 = "59";   //家族病歴(6)OCR値－３
        private const string OCR_ITEM060 = "60";   //手術
        private const string OCR_ITEM061 = "61";   //ヘリコバクター・ピロリ菌
        private const string OCR_ITEM062 = "62";   //上部消化管検査(食道ﾎﾟﾘｰﾌﾟ)
        private const string OCR_ITEM063 = "63";   //上部消化管検査(胃新生物)
        private const string OCR_ITEM064 = "64";   //上部消化管検査(慢性胃炎)
        private const string OCR_ITEM065 = "65";   //上部消化管検査(胃ﾎﾟﾘｰﾌﾟ)
        private const string OCR_ITEM066 = "66";   //上部消化管検査(胃潰瘍瘢痕)
        private const string OCR_ITEM067 = "67";   //上部消化管検査(十二指腸潰瘍痕)
        private const string OCR_ITEM068 = "68";   //上部消化管検査(その他)
        private const string OCR_ITEM069 = "69";   //上腹部超音波検査(胆のうﾎﾟﾘｰﾌﾟ)
        private const string OCR_ITEM070 = "70";   //上腹部超音波検査(胆石)
        private const string OCR_ITEM071 = "71";   //上腹部超音波検査(肝血管腫)
        private const string OCR_ITEM072 = "72";   //上腹部超音波検査(肝嚢胞)
        private const string OCR_ITEM073 = "73";   //上腹部超音波検査(脂肪肝)
        private const string OCR_ITEM074 = "74";   //上腹部超音波検査(腎結石)
        private const string OCR_ITEM075 = "75";   //上腹部超音波検査(腎嚢胞)
        private const string OCR_ITEM076 = "76";   //上腹部超音波検査(水腎症)
        private const string OCR_ITEM077 = "77";   //上腹部超音波検査(副腎腫瘍)
        private const string OCR_ITEM078 = "78";   //上腹部超音波検査(リンパ節腫大)
        private const string OCR_ITEM079 = "79";   //上腹部超音波検査(その他)
        private const string OCR_ITEM080 = "80";   //心電図検査(ＷＰＷ症候群)
        private const string OCR_ITEM081 = "81";   //心電図検査(完全右脚ﾌﾞﾛｯｸ)
        private const string OCR_ITEM082 = "82";   //心電図検査(不完全右脚ﾌﾞﾛｯｸ)
        private const string OCR_ITEM083 = "83";   //心電図検査(不整脈)
        private const string OCR_ITEM084 = "84";   //心電図検査(右胸心)
        private const string OCR_ITEM085 = "85";   //心電図検査(その他)
        private const string OCR_ITEM086 = "86";   //乳房検査(乳線症)
        private const string OCR_ITEM087 = "87";   //乳房検査(繊維腺腫)
        private const string OCR_ITEM088 = "88";   //乳房検査(乳房形成術)
        private const string OCR_ITEM089 = "89";   //乳房検査(その他)
        private const string OCR_ITEM090 = "90";   //妊娠している
        private const string OCR_ITEM091 = "91";   //体重変化値
        private const string OCR_ITEM092 = "92";   //直近体重変動
        private const string OCR_ITEM093 = "93";   //飲酒１（飲酒習慣）
        private const string OCR_ITEM094 = "94";   //現在飲酒回数
        private const string OCR_ITEM095 = "95";   //ビール大瓶 (夕)
        private const string OCR_ITEM096 = "96";   //ビール350ml缶 (夕)
        private const string OCR_ITEM097 = "97";   //ビール500ml缶 (夕)
        private const string OCR_ITEM098 = "98";   //日本酒 (夕)
        private const string OCR_ITEM099 = "99";   //焼酎 (夕)
        private const string OCR_ITEM100 = "100";  //ワイン (夕)
        private const string OCR_ITEM101 = "101";  //ウイスキー (夕)
        private const string OCR_ITEM102 = "102";  //その他 (夕)
        private const string OCR_ITEM103 = "103";  //喫煙
        private const string OCR_ITEM104 = "104";  //喫煙開始年齢
        private const string OCR_ITEM105 = "105";  //喫煙終了年齢
        private const string OCR_ITEM106 = "106";  //現在喫煙本数
        private const string OCR_ITEM107 = "107";  //運動不足認識
        private const string OCR_ITEM108 = "108";  //歩行時間
        private const string OCR_ITEM109 = "109";  //身体行動
        private const string OCR_ITEM110 = "110";  //軽い運動
        private const string OCR_ITEM111 = "111";  //睡眠状況
        private const string OCR_ITEM112 = "112";  //睡眠時間
        private const string OCR_ITEM113 = "113";  //就寝時間
        private const string OCR_ITEM114 = "114";  //最近数ヶ月の症状１－１
        private const string OCR_ITEM115 = "115";  //最近数ヶ月の症状１－２
        private const string OCR_ITEM116 = "116";  //最近数ヶ月の症状１－３
        private const string OCR_ITEM117 = "117";  //最近数ヶ月の症状１－４
        private const string OCR_ITEM118 = "118";  //最近数ヶ月の症状２－１
        private const string OCR_ITEM119 = "119";  //最近数ヶ月の症状２－２
        private const string OCR_ITEM120 = "120";  //最近数ヶ月の症状２－３
        private const string OCR_ITEM121 = "121";  //最近数ヶ月の症状２－４
        private const string OCR_ITEM122 = "122";  //最近数ヶ月の症状３－１
        private const string OCR_ITEM123 = "123";  //最近数ヶ月の症状３－２
        private const string OCR_ITEM124 = "124";  //最近数ヶ月の症状３－３
        private const string OCR_ITEM125 = "125";  //最近数ヶ月の症状３－４
        private const string OCR_ITEM126 = "126";  //最近数ヶ月の症状４－１
        private const string OCR_ITEM127 = "127";  //最近数ヶ月の症状４－２
        private const string OCR_ITEM128 = "128";  //最近数ヶ月の症状４－３
        private const string OCR_ITEM129 = "129";  //最近数ヶ月の症状４－４
        private const string OCR_ITEM130 = "130";  //最近数ヶ月の症状５－１
        private const string OCR_ITEM131 = "131";  //最近数ヶ月の症状５－２
        private const string OCR_ITEM132 = "132";  //最近数ヶ月の症状５－３
        private const string OCR_ITEM133 = "133";  //最近数ヶ月の症状５－４
        private const string OCR_ITEM134 = "134";  //最近数ヶ月の症状６－１
        private const string OCR_ITEM135 = "135";  //最近数ヶ月の症状６－２
        private const string OCR_ITEM136 = "136";  //最近数ヶ月の症状６－３
        private const string OCR_ITEM137 = "137";  //最近数ヶ月の症状６－４
        private const string OCR_ITEM138 = "138";  //Ａ型行動パターン実施の有無
        private const string OCR_ITEM139 = "139";  //Ａ型パターン・緊張時に腹痛
        private const string OCR_ITEM140 = "140";  //Ａ型パターン・気性が激しい
        private const string OCR_ITEM141 = "141";  //Ａ型パターン・責任感が強い
        private const string OCR_ITEM142 = "142";  //Ａ型パターン・仕事に自信あり
        private const string OCR_ITEM143 = "143";  //Ａ型パターン・早朝出勤
        private const string OCR_ITEM144 = "144";  //Ａ型パターン・約束時間に遅刻
        private const string OCR_ITEM145 = "145";  //Ａ型パターン・意見を貫く
        private const string OCR_ITEM146 = "146";  //Ａ型パターン・旅行
        private const string OCR_ITEM147 = "147";  //Ａ型パターン・他人からの指示
        private const string OCR_ITEM148 = "148";  //Ａ型パターン・車の運転
        private const string OCR_ITEM149 = "149";  //Ａ型パターン・帰宅時
        private const string OCR_ITEM150 = "150";  //最近１ヶ月の状態実施の有無
        private const string OCR_ITEM151 = "151";  //ひどく疲れた
        private const string OCR_ITEM152 = "152";  //へとへとだ
        private const string OCR_ITEM153 = "153";  //だるい
        private const string OCR_ITEM154 = "154";  //気が張り詰めている
        private const string OCR_ITEM155 = "155";  //不安だ
        private const string OCR_ITEM156 = "156";  //落ち着かない
        private const string OCR_ITEM157 = "157";  //ゆううつだ
        private const string OCR_ITEM158 = "158";  //何をするのも面倒だ
        private const string OCR_ITEM159 = "159";  //気分が晴れない
        private const string OCR_ITEM160 = "160";  //子宮がん検診の受診経験がある
        private const string OCR_ITEM161 = "161";  //検診の結果は
        private const string OCR_ITEM162 = "162";  //検診の結果（異型上皮クラス）
        private const string OCR_ITEM163 = "163";  //検診を受けた施設は
        private const string OCR_ITEM164 = "164";  //過去子宮頸がん検査で異常と言われた
        private const string OCR_ITEM165 = "165";  //過去子宮頸がん検査（異型上皮）
        private const string OCR_ITEM166 = "166";  //過去子宮頸がん検査（異型上皮クラス）
        private const string OCR_ITEM167 = "167";  //過去子宮頸がん検査（検査時期）
        private const string OCR_ITEM168 = "168";  //過去子宮頸がん検査（検査場所）
        private const string OCR_ITEM169 = "169";  //ＨＰＶ検査を受けたことがあるか
        private const string OCR_ITEM170 = "170";  //ＨＰＶ検査（結果）
        private const string OCR_ITEM171 = "171";  //ＨＰＶ検査（検査時期）
        private const string OCR_ITEM172 = "172";  //ＨＰＶ検査（検査場所）
        private const string OCR_ITEM173 = "173";  //子宮体がん検査を受けたことがあるか
        private const string OCR_ITEM174 = "174";  //子宮体がん検査の結果
        private const string OCR_ITEM175 = "175";  //子宮体がん検査の結果（擬陽性結果）
        private const string OCR_ITEM176 = "176";  //子宮体がん検査（検査時期）
        private const string OCR_ITEM177 = "177";  //子宮体がん検査（検査場所）
        private const string OCR_ITEM178 = "178";  //婦人科病気経験ない
        private const string OCR_ITEM179 = "179";  //婦人科病気経験子宮筋腫
        private const string OCR_ITEM180 = "180";  //婦人科病気経験子宮頚管ﾎﾟﾘｰﾌﾟ
        private const string OCR_ITEM181 = "181";  //婦人科病気経験内性子宮内膜症
        private const string OCR_ITEM182 = "182";  //婦人科病気経験外性子宮内膜症
        private const string OCR_ITEM183 = "183";  //婦人科病気経験子宮頸がん
        private const string OCR_ITEM184 = "184";  //婦人科病気経験子宮体がん
        private const string OCR_ITEM185 = "185";  //婦人科病気経験卵巣がん
        private const string OCR_ITEM186 = "186";  //婦人科病気経験良性卵巣腫瘍(右)
        private const string OCR_ITEM187 = "187";  //婦人科病気経験良性卵巣腫瘍(左)
        private const string OCR_ITEM188 = "188";  //婦人科病気経験絨毛性疾患
        private const string OCR_ITEM189 = "189";  //婦人科病気経験付属器炎
        private const string OCR_ITEM190 = "190";  //婦人科病気経験膣炎
        private const string OCR_ITEM191 = "191";  //婦人科病気経験膀胱子宮脱
        private const string OCR_ITEM192 = "192";  //婦人科病気経験乳がん
        private const string OCR_ITEM193 = "193";  //婦人科病気経験その他
        private const string OCR_ITEM194 = "194";  //ホルモン治療を受けたことがある
        private const string OCR_ITEM195 = "195";  //ﾎﾙﾓﾝ療法、何歳から
        private const string OCR_ITEM196 = "196";  //ﾎﾙﾓﾝ療法、何年間
        private const string OCR_ITEM197 = "197";  //現在不妊治療中
        private const string OCR_ITEM198 = "198";  //婦人科手術経験
        private const string OCR_ITEM199 = "199";  //婦人科手術経験右卵巣
        private const string OCR_ITEM200 = "200";  //婦人科手術経験右卵巣（結果）
        private const string OCR_ITEM201 = "201";  //婦人科手術経験右卵巣（部位）
        private const string OCR_ITEM202 = "202";  //婦人科手術経験右卵巣（年齢）
        private const string OCR_ITEM203 = "203";  //婦人科手術経験右卵巣（場所）
        private const string OCR_ITEM204 = "204";  //婦人科手術経験左卵巣
        private const string OCR_ITEM205 = "205";  //婦人科手術経験左卵巣（結果）
        private const string OCR_ITEM206 = "206";  //婦人科手術経験左卵巣（部位）
        private const string OCR_ITEM207 = "207";  //婦人科手術経験左卵巣（年齢）
        private const string OCR_ITEM208 = "208";  //婦人科手術経験左卵巣（場所）
        private const string OCR_ITEM209 = "209";  //婦人科手術経験子宮全摘術
        private const string OCR_ITEM210 = "210";  //婦人科手術経験子宮全摘術（術式）
        private const string OCR_ITEM211 = "211";  //子宮全摘術(年齢)
        private const string OCR_ITEM212 = "212";  //婦人科手術経験子宮全摘術（場所）
        private const string OCR_ITEM213 = "213";  //婦人科手術経験広汎子宮全摘術
        private const string OCR_ITEM214 = "214";  //婦人科手術経験広汎子宮全摘術（年齢）
        private const string OCR_ITEM215 = "215";  //婦人科手術経験広汎子宮全摘術（場所）
        private const string OCR_ITEM216 = "216";  //婦人科手術経験子宮頸部円錐切除術
        private const string OCR_ITEM217 = "217";  //婦人科手術経験子宮頸部円錐切除術（年齢）
        private const string OCR_ITEM218 = "218";  //婦人科手術経験子宮頸部円錐切除術（場所）
        private const string OCR_ITEM219 = "219";  //婦人科手術経験子宮筋腫核出術
        private const string OCR_ITEM220 = "220";  //婦人科手術経験子宮筋腫核出術（年齢）
        private const string OCR_ITEM221 = "221";  //婦人科手術経験子宮筋腫核出術（場所）
        private const string OCR_ITEM222 = "222";  //婦人科手術経験子宮膣上部切断術
        private const string OCR_ITEM223 = "223";  //婦人科手術経験子宮膣上部切断術（年齢）
        private const string OCR_ITEM224 = "224";  //婦人科手術経験子宮膣上部切断術（場所）
        private const string OCR_ITEM225 = "225";  //婦人科手術経験その他
        private const string OCR_ITEM226 = "226";  //婦人科手術経験その他（年齢）
        private const string OCR_ITEM227 = "227";  //婦人科手術経験その他（場所）
        private const string OCR_ITEM228 = "228";  //現在の性生活
        private const string OCR_ITEM229 = "229";  //妊娠の可能性
        private const string OCR_ITEM230 = "230";  //妊娠回数
        private const string OCR_ITEM231 = "231";  //出産回数
        private const string OCR_ITEM232 = "232";  //出産回数のうち帝王切開の回数
        private const string OCR_ITEM233 = "233";  //閉経した
        private const string OCR_ITEM234 = "234";  //閉経した(年齢)
        private const string OCR_ITEM235 = "235";  //最終月経(From年)
        private const string OCR_ITEM236 = "236";  //最終月経(From月)
        private const string OCR_ITEM237 = "237";  //最終月経(From日)
        private const string OCR_ITEM238 = "238";  //最終月経(To月)
        private const string OCR_ITEM239 = "239";  //最終月経(To日)
        private const string OCR_ITEM240 = "240";  //その他の月経(From年)
        private const string OCR_ITEM241 = "241";  //その他の月経(From月)
        private const string OCR_ITEM242 = "242";  //その他の月経(From日)
        private const string OCR_ITEM243 = "243";  //その他の月経(To月)
        private const string OCR_ITEM244 = "244";  //その他の月経(To日)
        private const string OCR_ITEM245 = "245";  //月経時の出血量
        private const string OCR_ITEM246 = "246";  //月経時の時、下腹部や腹部の痛み
        private const string OCR_ITEM247 = "247";  //月経以外に出血したことがある
        private const string OCR_ITEM248 = "248";  //月経以外に出血したことがある場合
        private const string OCR_ITEM249 = "249";  //気掛り症状ない
        private const string OCR_ITEM250 = "250";  //気がかり症状下腹部痛（月経痛以外で）
        private const string OCR_ITEM251 = "251";  //気がかり症状おりもの　（水様性）
        private const string OCR_ITEM252 = "252";  //気がかり症状おりもの　（血液．茶色も含む
        private const string OCR_ITEM253 = "253";  //家族で婦人科系がんいない
        private const string OCR_ITEM254 = "254";  //家族－子宮頸がん
        private const string OCR_ITEM255 = "255";  //家族－子宮頸がん（実母）
        private const string OCR_ITEM256 = "256";  //家族－子宮頸がん（実姉妹）
        private const string OCR_ITEM257 = "257";  //家族－子宮頸がん（その他の血縁）
        private const string OCR_ITEM258 = "258";  //家族で婦人科系がん子宮体がん
        private const string OCR_ITEM259 = "259";  //家族－子宮体がん（実母）
        private const string OCR_ITEM260 = "260";  //家族－子宮体がん（実姉妹）
        private const string OCR_ITEM261 = "261";  //家族－子宮体がん（その他の血縁）
        private const string OCR_ITEM262 = "262";  //家族で婦人科系がん卵巣がん
        private const string OCR_ITEM263 = "263";  //家族－卵巣がん（実母）
        private const string OCR_ITEM264 = "264";  //家族－卵巣がん（実姉妹）
        private const string OCR_ITEM265 = "265";  //家族－卵巣がん（その他の血縁）
        private const string OCR_ITEM266 = "266";  //家族で婦人科系がん病名その他
        private const string OCR_ITEM267 = "267";  //家族－その他の婦人科がん（実母）
        private const string OCR_ITEM268 = "268";  //家族－その他の婦人科がん（実姉妹）
        private const string OCR_ITEM269 = "269";  //家族－その他の婦人科がん（その他の血縁）
        private const string OCR_ITEM270 = "270";  //家族で婦人科系がん乳がん
        private const string OCR_ITEM271 = "271";  //家族－乳がん（実母）
        private const string OCR_ITEM272 = "272";  //家族－乳がん（実姉妹）
        private const string OCR_ITEM273 = "273";  //家族－乳がん（その他の血縁）
        private const string OCR_ITEM274 = "274";  //食習慣問診実施の有無
        private const string OCR_ITEM275 = "275";  //食事を食べる速さはいかがですか。
        private const string OCR_ITEM276 = "276";  //満腹まで食べることがありますか。
        private const string OCR_ITEM277 = "277";  //栄養のバランスを考えて食事をていますか。
        private const string OCR_ITEM278 = "278";  //味付けは濃い方ですか。
        private const string OCR_ITEM279 = "279";  //１日三食食べていますか。欠食がある日はありますか。
        private const string OCR_ITEM280 = "280";  //食事時刻は規則的ですか。
        private const string OCR_ITEM281 = "281";  //間食をとることはありますか。
        private const string OCR_ITEM282 = "282";  //夕食が外食となる日は、週に何日位ありますか。
        private const string OCR_ITEM283 = "283";  //夕食をとる時間が、午後9時以降になる日は週に何日位ありますか。
        private const string OCR_ITEM284 = "284";  //夕食後に飲食をとることは、週に何日位ありますか。
        private const string OCR_ITEM285 = "285";  //お菓子を食べたり、甘い飲み物を飲むことはありますか。
        private const string OCR_ITEM286 = "286";  //脂肪分の多い食事（揚げ物、油っこい料理、肉の脂身）を食べますか。
        private const string OCR_ITEM287 = "287";  //主食（ご飯、パン、麺）、芋類などを毎食、食べますか。
        private const string OCR_ITEM288 = "288";  //野菜をよく食べますか。
        private const string OCR_ITEM289 = "289";  //野菜の量はいかがですか。
        private const string OCR_ITEM290 = "290";  //果物をよく食べますか。
        private const string OCR_ITEM291 = "291";  //乳製品（牛乳、ヨーグルト、チーズ）をよく食べますか。
        private const string OCR_ITEM292 = "292";  //大豆製品（豆腐、納豆、豆乳など）をよく食べますか。
        private const string OCR_ITEM293 = "293";  //魚介類をよく食べますか。
        private const string OCR_ITEM294 = "294";  //肉類、卵などをよく食べますか。
        private const string OCR_ITEM295 = "295";  //栄養相談が必要と思われた場合、ご案内所をお送りしてもよいですか。
        private const string OCR_ITEM296 = "296";  //生活習慣改善意志
        private const string OCR_ITEM297 = "297";  //保健指導利用
        private const string OCR_ITEM298 = "298";  //健診前チェック担当者
        private const string OCR_ITEM299 = "299";  //婦人科病気経験卵巣腫瘍(右)
        private const string OCR_ITEM300 = "300";  //婦人科病気経験子宮内膜症
        private const string OCR_ITEM301 = "301";  //婦人科病気経験卵巣腫瘍(左)
        private const string OCR_ITEM302 = "302";  //婦人科病気経験月経異常
        private const string OCR_ITEM303 = "303";  //婦人科病気経験子宮がん
        private const string OCR_ITEM304 = "304";  //婦人科病気経験不妊
        private const string OCR_ITEM305 = "305";  //婦人科病気経験,その他
        private const string OCR_ITEM306 = "306";  //気掛り症状おりもの系
        private const string OCR_ITEM307 = "307";  //気掛り症状陰部がかゆい
        private const string OCR_ITEM308 = "308";  //気掛り症状下腹部痛(月経以外)
        private const string OCR_ITEM309 = "309";  //気掛り症状更年期症状がつらい
        private const string OCR_ITEM310 = "310";  //気掛り症状性交時に出血する
        private const string OCR_ITEM311 = "311";  //家族で婦人科系がん子宮頚がん
        private const string OCR_ITEM312 = "312";  //家族で婦人科系がん実母
        private const string OCR_ITEM313 = "313";  //家族で婦人科系がん実姉妹
        private const string OCR_ITEM314 = "314";  //家族で婦人科系がん家族その他
        private const string OCR_ITEM315 = "315";  //婦人科手術経験子宮筋腫核出術
        private const string OCR_ITEM316 = "316";  //子宮筋腫核出術(年齢)
        private const string OCR_ITEM317 = "317";  //婦人科手術経験卵巣摘出術
        private const string OCR_ITEM318 = "318";  //卵巣摘出術(年齢)
        private const string OCR_ITEM319 = "319";  //卵巣摘出個所

        // エラーメッセージNo
        private const string OCR_ERRMSGNO_001 = "1";     // 未記入エラー
        private const string OCR_ERRMSGNO_002 = "2";     // 未記入エラー（タイトルを登録する場合）
        private const string OCR_ERRMSGNO_003 = "3";     // 正常値範囲外エラー
        private const string OCR_ERRMSGNO_004 = "4";     // 重複エラー
        private const string OCR_ERRMSGNO_005 = "5";     // 記入されないはずの項目が記入されている場合のエラー
        private const string OCR_ERRMSGNO_006 = "6";     // 異性が記入している場合のエラー
        private const string OCR_ERRMSGNO_007 = "7";     // 0記入エラー
        private const string OCR_ERRMSGNO_008 = "8";     // 「ない」と重複する場合のエラー
        private const string OCR_ERRMSGNO_009 = "9";     // 「いない」と重複する場合のエラー
        private const string OCR_ERRMSGNO_010 = "10";    // がんの記入がない場合のエラー
        private const string OCR_ERRMSGNO_011 = "11";    // 家族に記入がない場合のエラー
        private const string OCR_ERRMSGNO_012 = "12";    // 未記入時に数値を登録する場合のエラー
        private const string OCR_ERRMSGNO_013 = "13";    // 他業務登録エラー
        private const string OCR_ERRMSGNO_014 = "14";    // 未記入時にﾃﾞﾌｫﾙﾄ値を登録
        private const string OCR_ERRMSGNO_015 = "15";    // 「？？」と重複する場合のエラー

        private const string OCR_ERRMSGNO_101 = "101";   // 飲酒量に記入がない場合のエラー
        private const string OCR_ERRMSGNO_102 = "102";   // 飲酒量に記入がない場合のエラー

        /// <summary>
        /// OCR内容確認修正日時を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// editOcrDate   OCR内容確認修正日時
        /// </returns>
        public dynamic SelectEditOcrDate(int rsvNo)
        {
            string sql; // SQLステートメント

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 検索条件を満たすノート分類テーブルのレコードを取得
            sql = @"
                    select
                      editocrdate 
                    from
                      receipt 
                    where
                      rsvno = :rsvno
                ";
            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// 婦人科の依頼があるかチェックする
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// 1:婦人科の依頼あり
        /// 0:婦人科の依頼なし
        /// -1:エラーあり
        /// </returns>
        public int CheckFujinka(int rsvNo)
        {
            string sql;                  // SQLステートメント
            int ret = 0;                 // 関数戻り値

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 婦人科の依頼項目を取得する
            sql = @"
                    select
                      rsl.result 
                    from
                      rsl
                      , grp_r 
                    where
                      rsl.rsvno = :rsvno 
                      and rsl.stopflg is null 
                      and grp_r.grpcd = 'K0590' 
                      and grp_r.itemcd = rsl.itemcd
                ";

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // 検索レコードが存在する場合
            if (current != null)
            {
                ret = 1;
            }
            else
            {
                ret = 0;
            }

            return ret;
        }

        /// <summary>
        /// 胃Ｘ線の依頼があるかチェックする
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// 1:胃Ｘ線の依頼あり
        /// 0:胃Ｘ線の依頼なし
        /// -1:エラーあり
        /// </returns>
        public int CheckStomach(int rsvNo)
        {
            string sql;                  // SQLステートメント
            int ret = 0;                 // 関数戻り値

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 胃Ｘ線の依頼項目を取得する
            sql = @"
                    select
                      rsl.result 
                    from
                      rsl
                      , grp_r 
                    where
                      rsl.rsvno = :rsvno 
                      and rsl.stopflg is null 
                      and grp_r.grpcd = 'K0160' 
                      and grp_r.itemcd = rsl.itemcd
                ";

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // 検索レコードが存在する場合
            if (current != null)
            {
                ret = 1;
            }
            else
            {
                ret = 0;
            }

            return ret;
        }

        /// <summary>
        /// 胃内視鏡の依頼があるかチェックする
        /// 依頼がある場合は内視鏡チェックリストが保存されているかをチェックする
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="gFCheckList">内視鏡チェックリスト(0:未保存、1:保存済み)</param>
        /// <returns>
        /// 1:胃内視鏡の依頼あり
        /// 0:胃内視鏡の依頼なし
        /// -1:エラーあり
        /// </returns>
        public int CheckGF(int rsvNo, ref string gFCheckList)
        {
            string sql;                   // SQLステートメント
            int ret = -1;                 // 関数戻り値

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 胃内視鏡の依頼項目を取得する
            sql = @"
                    select
                      rsl.result 
                    from
                      rsl
                      , grp_r 
                    where
                      rsl.rsvno = :rsvno 
                      and rsl.stopflg is null 
                      and grp_r.grpcd = 'K0180' 
                      and grp_r.itemcd = rsl.itemcd
                ";

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            // 検索レコードが存在する場合
            if (current != null)
            {
                ret = 1;
            }
            else
            {
                ret = 0;
            }

            // 内視鏡チェックリストの保存チェック
            if (!string.IsNullOrEmpty(gFCheckList))
            {
                // 胃内視鏡の依頼あり
                if (ret == 1)
                {
                    // キー値の設定
                    var param1 = new Dictionary<string, object>();
                    param1.Add("rsvno", rsvNo);

                    // 内視鏡チェックリストの内容を取得する
                    sql = @"
                            select
                              rsl.result 
                            from
                              rsl
                              , grp_i 
                            where
                              rsl.rsvno = :rsvno 
                              and rsl.stopflg is null 
                              and grp_i.grpcd = 'X024' 
                              and grp_i.itemcd = rsl.itemcd 
                              and grp_i.suffix = rsl.suffix
                        ";

                    dynamic current1 = connection.Query(sql, param).FirstOrDefault();

                    // 検索レコードが存在する場合
                    if (current1 != null)
                    {
                        gFCheckList = "1";
                    }
                    else
                    {
                        gFCheckList = "0";
                    }
                }
            }
            else
            {
                gFCheckList = "";
            }

            return ret;
        }

        /// <summary>
        /// 該当受診者の受診日チェック
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>
        /// cslDate 受診日
        /// csCd コースコード
        /// </returns>
        public dynamic CheckCslDate(int rsvNo)
        {
            string sql; // SQLステートメント

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            // 検索条件を満たすノート分類テーブルのレコードを取得
            sql = @"
                    select
                      to_char(consult.csldate, 'YYYY/MM/DD') as csldate
                      , consult.cscd as cscd 
                    from
                      consult 
                    where
                      consult.rsvno = :rsvno
                ";
            return connection.Query(sql, param).FirstOrDefault();
        }

        /// <summary>
        /// ＯＣＲ入力結果を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号（今回分）</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="lastDspMode">前回歴表示モード（0:すべて、1:同一コース、2:任意指定）</param>
        /// <param name="csGrp">前回歴表示モード＝0のとき、null
        ///                                     ＝1のとき、コースコード
        ///                                     ＝2のとき、コースグループコード
        /// </param>
        /// <param name="errCount"></param>
        /// <param name="arrErrNo">エラーNo</param>
        /// <param name="arrErrState">エラー状態</param>
        /// <param name="arrErrMsg">エラーメッセージ</param>
        /// <returns>
        /// perId 個人ＩＤ
        /// cslDate 受診日
        /// rsvNo 予約番号
        /// itemCd 検査項目コード
        /// suffix サフィックス
        /// itemName 検査項目名称
        /// rslFlg 検査結果存在フラグ(1:検査結果に存在する、0:検査結果に存在しない）
        /// result 検査結果
        /// stopFlg 検査中止フラグ
        /// lstCslDate 前回受診日
        /// lstRsvNo 前回予約番号
        /// lstRslFlg 前回検査結果存在フラグ(2:個人検査結果に存在する、1:検査結果に存在する、0:検査結果に存在しない）
        /// lstResult 前回検査結果
        /// lstStopFlg 前回検査中止フラグ
        /// arrErrNo エラーNo
        /// arrErrState エラー状態
        /// arrErrMsg エラーメッセージ
        /// </returns>
        public List<dynamic> SelectOcrNyuryoku(int rsvNo,
                                               string grpCd,
                                               int lastDspMode,
                                               string csGrp,
                                               ref int errCount,
                                               ref List<int> arrErrNo,
                                               ref List<string> arrErrState,
                                               ref List<string> arrErrMsg)
        {
            DateTime? editOcrDate = null;                    // OCR内容確認修正日時
            int ocrCheck;                                    // OCRチェック（0:OCR未チェック、1:OCRチェック済）
            string sql;
            string UniqueKey = "";                           // コレクションの対象キー

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);

            sql = @"
                    select
                      editocrdate 
                    from
                      receipt 
                    where
                      rsvno = :rsvno
                ";

            dynamic current = connection.Query(sql, param).FirstOrDefault();

            if (current != null)
            {
                // オブジェクトの参照設定
                editOcrDate = Convert.ToDateTime(current.EDITOCRDATE);
            }

            // OCRチェック(OCR内容確認修正日時が入っていないときはOCR未チェック)
            ocrCheck = string.IsNullOrEmpty(Convert.ToString(editOcrDate)) ? 0 : 1;

            // ＯＣＲ入力結果を取得する
            List<dynamic> dataResult = SelectRslOcr(rsvNo, grpCd, lastDspMode, csGrp, ocrCheck);

            if (dataResult.Count > 0)
            {
                mcolOcrNyuryoku = new Dictionary<string, RslOcrSp3>();

                int index = 0;

                foreach (dynamic rec in dataResult)
                {
                    RslOcrSp3 rslOcrSp3 = new RslOcrSp3
                    {
                        UniqueKey = Convert.ToString(rec.SEQ),
                        PerId = Convert.ToString(rec.PERID),
                        CslDate = rec.CSLDATE,
                        RsvNo = Convert.ToString(rec.RSVNO),
                        ItemCd = Convert.ToString(rec.ITEMCD),
                        Suffix = Convert.ToString(rec.SUFFIX),
                        ItemType = Convert.ToString(rec.ITEMTYPE),
                        ItemName = Convert.ToString(rec.ITEMNAME),
                        Figure1 = Convert.ToString(rec.FIGURE1),
                        Figure2 = Convert.ToString(rec.FIGURE2),
                        MaxValue = Convert.ToString(rec.MAXVALUE),
                        MinValue = Convert.ToString(rec.MINVALUE),
                        Unit = Convert.ToString(rec.UNIT),
                        RslFlg = Convert.ToString(rec.RSLFLG),
                        Result = Convert.ToString(rec.RESULT),
                        StopFlg = Convert.ToString(rec.STOPFLG),
                        RslCmtCd1 = Convert.ToString(rec.RSLCMTCD1),
                        RslCmtName1 = Convert.ToString(rec.RSLCMTNAME1),
                        RslCmtCd2 = Convert.ToString(rec.RSLCMTCD2),
                        RslCmtName2 = Convert.ToString(rec.RSLCMTNAME2),
                        LstCslDate = rec.LSTCSLDATE,
                        LstRsvNo = Convert.ToString(rec.LSTRSVNO),
                        LstRslFlg = Convert.ToString(rec.LSTRSLFLG),
                        LstResult = Convert.ToString(rec.LSTRESULT),
                        LstStopFlg = Convert.ToString(rec.LSTSTOPFLG),
                        LstRslCmtCd1 = Convert.ToString(rec.LSTRSLCMTCD1),
                        LstRslCmtName1 = Convert.ToString(rec.LSTRSLCMTNAME1),
                        LstRslCmtCd2 = Convert.ToString(rec.LSTRSLCMTCD2),
                        LstRslCmtName2 = Convert.ToString(rec.LSTRSLCMTNAME2),
                        Index = index + 1,

                    };
                    index++;
                    UniqueKey = Convert.ToString(rec.SEQ);
                    mcolOcrNyuryoku.Add(UniqueKey, rslOcrSp3);
                }

                // ＯＣＲ入力結果の入力チェック
                errCount = CheckRslOcr(rsvNo, ref arrErrNo, ref arrErrState, ref arrErrMsg);

                // 入力チェックのときに修正された検査結果を戻す
                foreach (dynamic rec in dataResult)
                {
                    UniqueKey = Convert.ToString(rec.SEQ);

                    if (!"-".Equals(UniqueKey))
                    {
                        rec.RESULT = mcolOcrNyuryoku[UniqueKey].Result;
                    }
                }
            }

            return dataResult;
        }

        /// <summary>
        /// ＯＣＲ入力結果の入力チェック
        /// </summary>
        /// <param name="rsvNo">予約番号（今回分）</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="lastDspMode">前回歴表示モード（0:すべて、1:同一コース、2:任意指定）</param>
        /// <param name="csGrp">前回歴表示モード＝0のとき、null ＝1のとき、コースコード ＝2のとき、コースグループコード</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="result">検査結果</param>
        /// <param name="stopFlg">検査中止フラグ</param>
        /// <param name="errCount"></param>
        /// <param name="arrErrNo">エラーNo</param>
        /// <param name="arrErrState">エラー状態</param>
        /// <param name="arrErrMsg">エラーメッセージ</param>
        /// <returns></returns>
        public int CheckOcrNyuryoku(int rsvNo,
                                    string grpCd,
                                    int lastDspMode,
                                    string csGrp,
                                    ref List<string> itemCd,
                                    ref List<string> suffix,
                                    ref List<string> result,
                                    ref List<string> stopFlg,
                                    ref int errCount,
                                    ref List<int> arrErrNo,
                                    ref List<string> arrErrState,
                                    ref List<string> arrErrMsg)
        {
            string UniqueKey = "";                           // コレクションの対象キー

            // ＯＣＲ入力結果を取得する
            List<dynamic> dataResult = SelectRslOcr(rsvNo, grpCd, lastDspMode, csGrp, 1);

            while (true)
            {
                if (dataResult.Count == 0)
                {
                    break;
                }

                mcolOcrNyuryoku = new Dictionary<string, RslOcrSp3>();

                int index = 0;

                foreach (dynamic rec in dataResult)
                {
                    RslOcrSp3 rslOcrSp3 = new RslOcrSp3
                    {
                        UniqueKey = Convert.ToString(rec.SEQ),
                        PerId = Convert.ToString(rec.PERID),
                        CslDate = rec.CSLDATE,
                        RsvNo = Convert.ToString(rec.RSVNO),
                        ItemCd = Convert.ToString(rec.ITEMCD),
                        Suffix = Convert.ToString(rec.SUFFIX),
                        ResultType = Convert.ToString(rec.RESULTTYPE),
                        ItemType = Convert.ToString(rec.ITEMTYPE),
                        ItemName = Convert.ToString(rec.ITEMNAME),
                        Figure1 = Convert.ToString(rec.FIGURE1),
                        Figure2 = Convert.ToString(rec.FIGURE2),
                        MaxValue = Convert.ToString(rec.MAXVALUE),
                        MinValue = Convert.ToString(rec.MINVALUE),
                        Unit = Convert.ToString(rec.UNIT),
                        RslFlg = Convert.ToString(rec.RSLFLG),
                        RslCmtCd1 = Convert.ToString(rec.RSLCMTCD1),
                        RslCmtName1 = Convert.ToString(rec.RSLCMTNAME1),
                        RslCmtCd2 = Convert.ToString(rec.RSLCMTCD2),
                        RslCmtName2 = Convert.ToString(rec.RSLCMTNAME2),
                        LstCslDate = rec.LSTCSLDATE,
                        LstRsvNo = Convert.ToString(rec.LSTRSVNO),
                        LstRslFlg = Convert.ToString(rec.LSTRSLFLG),
                        LstResult = Convert.ToString(rec.LSTRESULT),
                        LstStopFlg = Convert.ToString(rec.LSTSTOPFLG),
                        LstRslCmtCd1 = Convert.ToString(rec.LSTRSLCMTCD1),
                        LstRslCmtName1 = Convert.ToString(rec.LSTRSLCMTNAME1),
                        LstRslCmtCd2 = Convert.ToString(rec.LSTRSLCMTCD2),
                        LstRslCmtName2 = Convert.ToString(rec.LSTRSLCMTNAME2),
                        Index = index + 1,
                    };
                    index++;
                    UniqueKey = Convert.ToString(rec.SEQ);
                    mcolOcrNyuryoku.Add(UniqueKey, rslOcrSp3);
                }

                // 渡された検査結果と検査中止フラグをセット
                for (int i = 0; i < result.Count; i++)
                {
                    UniqueKey = Convert.ToString(dataResult[i].SEQ);

                    if (!"-".Equals(UniqueKey))
                    {
                        mcolOcrNyuryoku[UniqueKey].Result = result[i];
                        mcolOcrNyuryoku[UniqueKey].StopFlg = stopFlg[i];
                    }
                }

                // 婦人科の依頼があるかチェック（依頼なしのときは、婦人科問診の入力チェックをしない）
                if (CheckFujinka(rsvNo) == 1)
                {
                    fujinkaFlg = true;
                }
                else
                {
                    fujinkaFlg = false;
                }

                // ＯＣＲ入力結果の入力チェック
                errCount = CheckRslOcr(rsvNo, ref arrErrNo, ref arrErrState, ref arrErrMsg);

                // 検査中止フラグのセット
                int i2 = 1;
                foreach (string key in mcolOcrNyuryoku.Keys)
                {
                    // Ａ型行動パターン・テストの未回答
                    if (Convert.ToInt32(mcolOcrNyuryoku[OCR_ITEM139].Index) <= i2
                        && Convert.ToInt32(mcolOcrNyuryoku[OCR_ITEM149].Index) >= i2)
                    {
                        mcolOcrNyuryoku[key].StopFlg = "1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM138].Result)) ? "S" : "";
                    }

                    // 最近１ヶ月の状態の未回答
                    if (Convert.ToInt32(mcolOcrNyuryoku[OCR_ITEM151].Index) <= i2
                        && Convert.ToInt32(mcolOcrNyuryoku[OCR_ITEM159].Index) >= i2)
                    {
                        mcolOcrNyuryoku[key].StopFlg = "1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM150].Result)) ? "S" : "";
                    }

                    // 食習慣問診の未回答
                    if (Convert.ToInt32(mcolOcrNyuryoku[OCR_ITEM275].Index) <= i2
                        && Convert.ToInt32(mcolOcrNyuryoku[OCR_ITEM295].Index) >= i2)
                    {
                        mcolOcrNyuryoku[key].StopFlg = "1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM291].Result)) ? "S" : "";
                    }

                    i2 = i2 + 1;
                }

                // 入力チェックのときに修正された検査結果を戻す
                for (int i3 = 0; i3 < itemCd.Count; i3++)
                {
                    UniqueKey = Convert.ToString(dataResult[i3].SEQ);

                    if (!"-".Equals(UniqueKey))
                    {
                        result[i3] = mcolOcrNyuryoku[UniqueKey].Result;
                        stopFlg[i3] = mcolOcrNyuryoku[UniqueKey].StopFlg;
                    }
                }

                break;
            }

            return dataResult.Count;
        }

        /// <summary>
        /// ＯＣＲ入力結果を更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ipAddress">ＩＰアドレス</param>
        /// <param name="updUser">更新者</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="result">検査結果</param>
        /// <param name="rslCmtCd1">結果コメント１</param>
        /// <param name="rslCmtCd2">結果コメント２</param>
        /// <param name="message">メッセージ</param>
        /// <param name="stopFlg">検査中止フラグ</param>
        /// <param name="skipNoRec">真の場合は依頼のない検査項目をスキップ(中止フラグつき更新のみ有効)</param>
        /// <returns>
        /// True   正常終了
        /// False  エラーあり
        /// </returns>
        public bool UpdateOcrNyuryoku(int rsvNo,
                                      string ipAddress,
                                      string updUser,
                                      List<string> itemCd,
                                      List<string> suffix,
                                      List<string> result = null,
                                      List<string> rslCmtCd1 = null,
                                      List<string> rslCmtCd2 = null,
                                      List<string> message = null,
                                      List<string> stopFlg = null,
                                      bool skipNoRec = false)
        {
            long ret2;

            int msgCount = 0;               // メッセージ数
            List<string> arrResult = new List<string>();
            List<string> arrRslCmtCd1 = new List<string>();
            List<string> arrRslCmtCd2 = new List<string>();
            List<string> arrStopFlg = new List<string>();

            List<string> arrMessage = new List<string>();
            OracleParameter objMessage;

            int arraySize = itemCd.Count;   // 配列の要素数

            if (result != null)
            {
                arrResult = result;
            }
            else
            {
                for (int i = 0; i < arraySize; i++)
                {
                    arrResult.Add("");
                }
            }

            if (rslCmtCd1 != null)
            {
                arrRslCmtCd1 = rslCmtCd1;
            }
            else
            {
                for (int i = 0; i < arraySize; i++)
                {
                    arrRslCmtCd1.Add("");
                }
            }

            if (rslCmtCd2 != null)
            {
                arrRslCmtCd2 = rslCmtCd2;
            }
            else
            {
                for (int i = 0; i < arraySize; i++)
                {
                    arrRslCmtCd2.Add("");
                }
            }

            if (stopFlg != null)
            {
                arrStopFlg = stopFlg;
            }
            else
            {
                for (int i = 0; i < arraySize; i++)
                {
                    arrStopFlg.Add("");
                }
            }

            // 結果更新用ストアド呼び出し
            using (var cmd = new OracleCommand())
            {
                string sql;

                OracleParameter objRet;

                // キー値及び更新値の設定
                cmd.Parameters.Add("rsvno", OracleDbType.Long, rsvNo, ParameterDirection.Input);
                cmd.Parameters.Add("ipaddress", OracleDbType.Varchar2, ipAddress, ParameterDirection.Input);
                cmd.Parameters.Add("upduser", OracleDbType.Varchar2, updUser, ParameterDirection.Input);

                OracleParameter objItemCd = cmd.Parameters.AddTable("itemcd", itemCd.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_ITEM_P_ITEMCD);
                OracleParameter objSuffix = cmd.Parameters.AddTable("suffix", suffix.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_ITEM_C_SUFFIX);
                OracleParameter objResult = cmd.Parameters.AddTable("result", arrResult.ToArray(), ParameterDirection.InputOutput, OracleDbType.Varchar2, arraySize, 400);
                OracleParameter objRslCmtCd1 = cmd.Parameters.AddTable("rslcmtcd1", arrRslCmtCd1.ToArray(), ParameterDirection.InputOutput, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTCD);
                OracleParameter objRslCmtCd2 = cmd.Parameters.AddTable("rslcmtcd2", arrRslCmtCd2.ToArray(), ParameterDirection.InputOutput, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTCD);
                objMessage = cmd.Parameters.AddTable("message", ParameterDirection.Output, OracleDbType.Varchar2, 100, 256);
                objRet = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                if (stopFlg == null)
                {


                    // SQL定義
                    sql = @"
                        begin 
                            :ret := resultpackage.updateresult(
                                    :rsvno, 
                                    :ipaddress, 
                                    :upduser, 
                                    :itemcd, 
                                    :suffix, 
                                    :result, 
                                    :rslcmtcd1, 
                                    :rslcmtcd2, 
                                    :message
                            ); 
                        end;
                    ";
                }
                // 検査中止フラグ指定時
                else
                {
                    // キー値及び更新値の設定
                    cmd.Parameters.Add("updresult", OracleDbType.Int32, result == null || result.Count == 0 ? 0 : 1, ParameterDirection.Input);
                    cmd.Parameters.Add("updrslcmt1", OracleDbType.Int32, rslCmtCd1 == null || rslCmtCd1.Count == 0 ? 0 : 1, ParameterDirection.Input);
                    cmd.Parameters.Add("updrslcmt2", OracleDbType.Int32, rslCmtCd2 == null || rslCmtCd2.Count == 0 ? 0 : 1, ParameterDirection.Input);
                    cmd.Parameters.Add("skipnorec", OracleDbType.Int32, skipNoRec ? 1 : 0, ParameterDirection.Input);

                    OracleParameter objStopflg = cmd.Parameters.AddTable("stopflg", arrStopFlg.ToArray(), ParameterDirection.InputOutput, OracleDbType.Varchar2, arraySize, 1);

                    // 検査中止フラグ付き結果更新ストアド呼び出し
                    sql = @"
                        begin 
                            :ret := resultpackage.updateresultforstop(
                                    :rsvno, 
                                    :ipaddress, 
                                    :upduser, 
                                    :itemcd, 
                                    :suffix, 
                                    :result, 
                                    :rslcmtcd1, 
                                    :rslcmtcd2, 
                                    :stopflg, 
                                    :message, 
                                    :updresult, 
                                    :updrslcmt1, 
                                    :updrslcmt2, 
                                    :skipnorec); 
                        end;
                    ";
                }

                ExecuteNonQuery(cmd, sql);

                ret2 = ((OracleDecimal)objRet.Value).ToInt32();
            }

            bool ret = true;

            // チェックエラー時
            if (ret2 <= 0)
            {
                List<string> objMessageArr = ((OracleString[])objMessage.Value).Select(s => s.Value).ToList();
                if (message != null)
                {
                    // バインド配列内容を検索し、メッセージを取得
                    for (int i = 0; i < objMessageArr.Count; i++) {
                        message.Add(objMessageArr[i]);
                    }
                }

                ret = false;
            }

            if (ret)
            {
                var param = new Dictionary<string, object>();
                param.Add("rsvno", rsvNo);

                // OCR内容確認修正日時を更新
                string sql = @"
                              update receipt 
                              set
                                  editocrdate = sysdate 
                              where
                                  rsvno = :rsvno
                           ";

                connection.Execute(sql, param);
            }

            return ret;
        }

        /// <summary>
        /// 予約番号をキーに指定対象受診者のＯＣＲ入力結果を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号（今回分）</param>
        /// <param name="grpCd">グループコード</param>
        /// <param name="lastDspMode">前回歴表示モード（0:すべて、1:同一コース、2:任意指定）</param>
        /// <param name="csGrp">前回歴表示モード＝0のとき、null
        ///                                     ＝1のとき、コースコード
        ///                                     ＝2のとき、コースグループコード
        /// </param>
        /// <param name="ocrCheck">OCRチェック（0:OCR未チェック、1:OCRチェック済）</param>
        /// <param name="rslCmtName1">結果コメント名１</param>
        /// <param name="rslCmtName2">結果コメント名２</param>
        /// <param name="lstRslCmtName1">前回結果コメント名１</param>
        /// <param name="lstRslCmtName2">前回結果コメント名２</param>
        /// <returns>
        /// </returns>
        private List<dynamic> SelectRslOcr(int rsvNo,
                                           string grpCd,
                                           int lastDspMode,
                                           string csGrp,
                                           int ocrCheck,
                                           string rslCmtName1 = "",
                                           string rslCmtName2 = "",
                                           string lstRslCmtName1 = "",
                                           string lstRslCmtName2 = "")
        {
            string sql;

            // キー値の設定
            var param = new Dictionary<string, object>();
            param.Add("rsvno", rsvNo);
            param.Add("cscd", string.IsNullOrEmpty(csGrp) ? "" : csGrp.Trim());
            param.Add("grpcd", string.IsNullOrEmpty(grpCd) ? "" : grpCd.Trim());

            sql = @"
                    select
                      finalrsl.perid
                      , finalrsl.csldate
                      , finalrsl.rsvno
                      , finalrsl.seq
                      , finalrsl.itemcd
                      , finalrsl.suffix
                      , item_c.resulttype
                      , item_c.itemtype
                      , item_c.itemname
                      , item_h.figure1
                      , item_h.figure2
                      , item_h.maxvalue
                      , item_h.minvalue
                      , item_h.unit
                ";
            // 今回値
            sql += @"
                    , finalrsl.rslflg rslflg
                    , finalrsl.result result
                    , finalrsl.stopflg stopflg
                    , finalrsl.rslcmtcd1 rslcmtcd1
                 ";

            if (!string.IsNullOrEmpty(rslCmtName1))
            {
                sql += @"
                        , ( 
                          select
                            rslcmtname 
                          from
                            rslcmt 
                          where
                            rslcmtcd = finalrsl.rslcmtcd1
                        ) rslcmtname1
                     ";
            }
            else
            {
                sql += @"
                        ,null rslcmtname1
                     ";
            }

            sql += @"
                    ,finalrsl.rslcmtcd2 rslcmtcd2
                 ";

            if (!string.IsNullOrEmpty(rslCmtName2))
            {
                sql += @"
                        ,( 
                          select
                            rslcmtname 
                          from
                            rslcmt 
                          where
                            rslcmtcd = finalrsl.rslcmtcd2
                        ) rslcmtname2
                     ";
            }
            else
            {
                sql += @"
                        ,null rslcmtname2
                     ";
            }

            // 前回値
            sql += @"
                    , lastrsl.csldate lstcsldate
                    , lastrsl.rsvno lstrsvno
                    , lastrsl.rslflg lstrslflg
                    , lastrsl.result lstresult
                    , lastrsl.stopflg lststopflg
                    , lastrsl.rslcmtcd1 lstrslcmtcd1
                 ";

            if (!string.IsNullOrEmpty(lstRslCmtName1))
            {
                sql += @"
                        ,( 
                          select
                            rslcmtname 
                          from
                            rslcmt 
                          where
                            rslcmtcd = lastrsl.rslcmtcd1
                        ) lstrslcmtname1
                     ";
            }
            else
            {
                sql += @"
                        ,null lstrslcmtname1
                     ";
            }

            sql += @"
                    ,lastrsl.rslcmtcd2 lstrslcmtcd2
                 ";

            if (!string.IsNullOrEmpty(lstRslCmtName2))
            {
                sql += @"
                        ,( 
                          select
                            rslcmtname 
                          from
                            rslcmt 
                          where
                            rslcmtcd = lastrsl.rslcmtcd2
                        ) lstrslcmtname2
                     ";
            }
            else
            {
                sql += @"
                        ,null lstrslcmtname2
                     ";
            }

            // 検査結果View（検査結果が存在しない場合の対応）
            sql += @"
                    from
                      ( 
                        select
                          csldate
                          , rsvno
                          , perid
                          , seq
                          , itemcd
                          , suffix
                          , max(result) result
                          , max(stdvaluecd) stdvaluecd
                          , max(rslcmtcd1) rslcmtcd1
                          , max(rslcmtcd2) rslcmtcd2
                          , max(stopflg) stopflg
                          , max(rslflg) rslflg 
                        from
                          (
                 ";

            // 検査結果に存在するレコード(OCR未チェックのときはRSLOCR、OCRチェック済のときはRSLより読込)
            sql += String.Format(@"
                                select
                                  consultview.csldate
                                  , consultview.rsvno
                                  , consultview.perid
                                  , grp_i.seq
                                  , rsl.itemcd
                                  , rsl.suffix
                                  , rsl.result
                                  , rsl.stdvaluecd
                                  , rsl.rslcmtcd1
                                  , rsl.rslcmtcd2
                                  , rsl.stopflg
                                  , 1 rslflg 
                                from
                                  ( 
                                    select
                                      consult.csldate
                                      , consult.rsvno
                                      , consult.perid 
                                    from
                                      consult 
                                    where
                                      consult.rsvno = :rsvno 
                                      and consult.cancelflg = 0
                                  ) consultview
                                  , grp_i
                                  , {0} rsl 
                                where
                                  consultview.rsvno = rsl.rsvno 
                                  and grp_i.grpcd = :grpcd 
                                  and grp_i.itemcd = rsl.itemcd 
                                  and grp_i.suffix = rsl.suffix
                 ", ocrCheck == 0 ? "rslocr" : "rsl");

            // 検査結果項目の空レコード
            sql += @"
                    union all 
                    select
                      consultview.csldate
                      , consultview.rsvno
                      , consultview.perid
                      , grp_i.seq
                      , grp_i.itemcd
                      , grp_i.suffix
                      , null result
                      , null stdvaluecd
                      , null rslcmtcd1
                      , null rslcmtcd2
                      , null stopflg
                      , 0 rslflg 
                    from
                      ( 
                        select
                          consult.csldate
                          , consult.rsvno
                          , consult.perid 
                        from
                          consult 
                        where
                          consult.rsvno = :rsvno 
                          and consult.cancelflg = 0
                      ) consultview
                      , grp_i 
                    where
                      grp_i.grpcd = :grpcd
                 ";

            sql += @"
                    ) 
                    group by
                      csldate
                      , rsvno
                      , perid
                      , seq
                      , itemcd
                      , suffix) finalrsl
                      , 
                 ";

            // 前回検査結果View（前回検査結果＋個人検査結果、検査結果が存在しない場合の対応）
            sql += @"
                    ( 
                      select
                        rslview.csldate
                        , rslview.rsvno
                        , rslview.perid
                        , rslview.seq
                        , rslview.itemcd
                        , rslview.suffix
                        , nvl(perrslview.result, rslview.result) result
                        , rslview.stdvaluecd
                        , rslview.rslcmtcd1
                        , rslview.rslcmtcd2
                        , rslview.stopflg
                        , nvl(perrslview.rslflg, rslview.rslflg) rslflg 
                      from
                        (
                 ";

            sql += @"
                    select
                      csldate
                      , rsvno
                      , perid
                      , seq
                      , itemcd
                      , suffix
                      , max(result) result
                      , max(stdvaluecd) stdvaluecd
                      , max(rslcmtcd1) rslcmtcd1
                      , max(rslcmtcd2) rslcmtcd2
                      , max(stopflg) stopflg
                      , max(rslflg) rslflg 
                    from
                      (
                 ";

            // 検査結果に存在するレコード
            sql += @"
                    select
                      consultview.csldate
                      , consultview.rsvno
                      , consultview.perid
                      , grp_i.seq
                      , rsl.itemcd
                      , rsl.suffix
                      , rsl.result
                      , rsl.stdvaluecd
                      , rsl.rslcmtcd1
                      , rsl.rslcmtcd2
                      , rsl.stopflg
                      , 1 rslflg 
                    from
                      ( 
                        select
                          /*+ index_desc(consult consult_index4) */
                          consult.csldate
                          , consult.rsvno
                          , consult.perid 
                        from
                          consult 
                        where
                          consult.perid = ( 
                            select distinct
                              perid 
                            from
                              consult 
                            where
                              rsvno = :rsvno
                          ) 
                          and consult.csldate < ( 
                            select distinct
                              csldate 
                            from
                              consult 
                            where
                              rsvno = :rsvno
                      ) 
                 ";

            // コース指定
            switch (lastDspMode)
            {
                case 1:
                    sql += @"
                            and consult.cscd = :cscd
                         ";
                    break;

                case 2:
                    sql += @"
                            and consult.cscd in ( 
                              select
                                freefield1 cscd 
                              from
                                free 
                              where
                                freecd like :cscd || '%'
                            ) 
                         ";
                    break;
            }

            sql += @"
                    and consult.cancelflg = 0 
                    and rownum = 1) consultview
                    , rsl
                    , grp_i 
                    where
                      consultview.rsvno = rsl.rsvno 
                      and grp_i.grpcd = :grpcd 
                      and grp_i.itemcd = rsl.itemcd 
                      and grp_i.suffix = rsl.suffix
                 ";

            // 検査結果項目の空レコード
            sql += @"
                    union all 
                    select
                      consultview.csldate
                      , consultview.rsvno
                      , consultview.perid
                      , grp_i.seq
                      , grp_i.itemcd
                      , grp_i.suffix
                      , null result
                      , null stdvaluecd
                      , null rslcmtcd1
                      , null rslcmtcd2
                      , null stopflg
                      , 0 rslflg 
                    from
                      ( 
                        select
                          /*+ index_desc(consult consult_index4) */
                          consult.csldate
                          , consult.rsvno
                          , consult.perid 
                        from
                          consult 
                        where
                          consult.perid = ( 
                            select distinct
                              perid 
                            from
                              consult 
                            where
                              rsvno = :rsvno
                          ) 
                          and consult.csldate < ( 
                            select distinct
                              csldate 
                            from
                              consult 
                            where
                              rsvno = :rsvno
                      )
                 ";

            // コース指定
            switch (lastDspMode)
            {
                case 1:
                    sql += @"
                            and consult.cscd = :cscd
                         ";
                    break;

                case 2:
                    sql += @"
                            and consult.cscd in ( 
                              select
                                freefield1 cscd 
                              from
                                free 
                              where
                                freecd like :cscd || '%'
                            ) 
                         ";
                    break;
            }

            sql += @"
                    and consult.cancelflg = 0 
                    and rownum = 1) consultview
                    , grp_i 
                    where
                      grp_i.grpcd = :grpcd
                 ";

            sql += @"
                    ) 
                    group by
                      csldate
                      , rsvno
                      , perid
                      , seq
                      , itemcd
                      , suffix) rslview
                      , 
                 ";

            // 個人検査結果View
            sql += @"
                    ( 
                      select
                        null itemcd
                        , null suffix
                        , null seq
                        , null result
                        , 2 rslflg 
                      from
                        dual 
                      where
                        1 = 2
                    ) perrslview
                 ";

            sql += @"
                    where
                      rslview.itemcd = perrslview.itemcd(+) 
                      and rslview.suffix = perrslview.suffix(+)) lastrsl
                      , 
                 ";

            sql += @"
                    item_c
                    , item_h
                 ";

            sql += @"
                    where
                      finalrsl.itemcd = item_c.itemcd 
                      and finalrsl.suffix = item_c.suffix 
                      and finalrsl.itemcd = item_h.itemcd　 
                      and finalrsl.suffix = item_h.suffix　 
                      and finalrsl.csldate between item_h.strdate and item_h.enddate 
                      and finalrsl.itemcd = lastrsl.itemcd(+) 
                      and finalrsl.suffix = lastrsl.suffix(+)
                 ";

            sql += @"
                    order by
                      finalrsl.seq
                      , finalrsl.csldate desc
                 ";

            // 戻り値の設定
            return connection.Query(sql, param).ToList();
        }

        /// <summary>
        /// ＯＣＲ入力結果の入力チェック
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="arrErrNo">エラーNo</param>
        /// <param name="arrErrState">エラー状態</param>
        /// <param name="arrErrMsg">エラーメッセージ</param>
        private int CheckRslOcr(int rsvNo, ref List<int> arrErrNo, ref List<string> arrErrState, ref List<string> arrErrMsg)
        {
            string perId;         // 個人ID

            DateTime cslDate;     // 受診日
            int itemCnt;          // 検査項目数
            string uniqueKey;     //コレクションの対象キー
            string gender = "";   // 性別
            bool checkErrFlg;

            // エラー情報の初期化
            ocrErrCnt = 0;
            if (ocrErrNo != null) { ocrErrNo.Clear(); }
            if (ocrErrState != null) { ocrErrState.Clear(); }
            if (ocrErrMsg != null) { ocrErrMsg.Clear(); }

            perId = Convert.ToString(mcolOcrNyuryoku[OCR_ITEM001].PerId);
            cslDate = Convert.ToDateTime(mcolOcrNyuryoku[OCR_ITEM001].CslDate);

            // 個人情報を取得する
            dynamic current = personDao.SelectPerson_lukes(perId);

            gender = Convert.ToString(current.GENDER);

            // 胃Ｘ線の依頼があるかチェック（依頼なしのときは、ブスコパンの入力チェックをしない）
            if (CheckStomach(rsvNo) == 1)
            {
                stomachFlg = true;
            }
            else
            {
                stomachFlg = false;
            }

            // 婦人科の依頼があるかチェック（依頼なしのときは、婦人科問診の入力チェックをしない）
            if (CheckFujinka(rsvNo) == 1)
            {
                fujinkaFlg = true;
            }
            else
            {
                fujinkaFlg = false;
            }

            IList<ResultWithStatus> results = new List<ResultWithStatus>();
            IList<string> chkSeq = new List<string>();

            // 単体の入力チェック
            itemCnt = 0;
            foreach (string key in mcolOcrNyuryoku.Keys)
            {
                ResultWithStatus resultWithStatus = new ResultWithStatus();
                resultWithStatus.ItemCd = mcolOcrNyuryoku[key].ItemCd;
                resultWithStatus.Suffix = mcolOcrNyuryoku[key].Suffix;
                resultWithStatus.Result = mcolOcrNyuryoku[key].Result;

                results.Add(resultWithStatus);

                chkSeq.Add(Convert.ToString(mcolOcrNyuryoku[key].UniqueKey));
                itemCnt = itemCnt + 1;
            }

            // 検査結果入力チェック           
            resultDao.CheckResult(cslDate, ref results);

            for (int i = 0; i < itemCnt; i++)
            {
                // エラーあり？
                if (!string.IsNullOrEmpty(Convert.ToString(results[i].ResultError)))
                {
                    uniqueKey = chkSeq[i];
                    EditOcrError(chkSeq[i], OCR_ERRSTAT_ERROR, results[i].ResultError, Convert.ToString(mcolOcrNyuryoku[uniqueKey].ItemName));
                }
            }

            // 現病歴・既往歴問診票
            // センター使用欄：同意書（ドック全体）の入力必須チェック
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM001].Result)))
            {
                EditOcrError(OCR_ITEM001, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM001].ItemName));
            }

            // 胃Ｘ線の依頼があればブスコパンのチェックを行う
            // 胃Ｘ線の依頼があるときだけ入力チェック
            if (stomachFlg)
            {
                // 未記入の場合a
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM004].Result)))
                {
                    EditOcrError(OCR_ITEM004, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM004].ItemName));
                }
            }

            // 現病歴
            string[] arrItem1 = new string[] { OCR_ITEM006, OCR_ITEM009, OCR_ITEM012, OCR_ITEM015, OCR_ITEM018, OCR_ITEM021 };
            string[] arrItem2 = new string[] { OCR_ITEM007, OCR_ITEM010, OCR_ITEM013, OCR_ITEM016, OCR_ITEM019, OCR_ITEM022 };
            string[] arrItem3 = new string[] { OCR_ITEM008, OCR_ITEM011, OCR_ITEM014, OCR_ITEM017, OCR_ITEM020, OCR_ITEM023 };

            for (int i = 0; i < arrItem1.Length; i++)
            {
                // 「発症年齢」又は「治療状況」に記入があり、「病名」未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem1[i]].Result)) && (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem2[i]].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem3[i]].Result))))
                {
                    EditOcrError(arrItem1[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[arrItem1[i]].ItemName));
                }

                // 「病名」又は「治療状況」に記入があり、「発症年齢」未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem2[i]].Result)) && (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem1[i]].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem3[i]].Result))))
                {
                    EditOcrError(arrItem2[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[arrItem2[i]].ItemName));
                }

                // 「病名」又は「発症年齢」に記入があり、「治療状況」未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem3[i]].Result)) && (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem1[i]].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem2[i]].Result))))
                {
                    EditOcrError(arrItem3[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[arrItem3[i]].ItemName));
                }
            }

            // 既往歴
            string[] arrItem1_1 = new string[] { OCR_ITEM024, OCR_ITEM027, OCR_ITEM030, OCR_ITEM033, OCR_ITEM036, OCR_ITEM039 };
            string[] arrItem2_1 = new string[] { OCR_ITEM025, OCR_ITEM028, OCR_ITEM031, OCR_ITEM034, OCR_ITEM037, OCR_ITEM040 };
            string[] arrItem3_1 = new string[] { OCR_ITEM026, OCR_ITEM029, OCR_ITEM032, OCR_ITEM035, OCR_ITEM038, OCR_ITEM041 };

            for (int i = 0; i < arrItem1_1.Length; i++)
            {
                // 「発症年齢」又は「治療状況」に記入があり、「病名」未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem1_1[i]].Result)) && (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem2_1[i]].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem3_1[i]].Result))))
                {
                    EditOcrError(arrItem1_1[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[arrItem1_1[i]].ItemName));
                }

                // 「病名」又は「治療状況」に記入があり、「発症年齢」未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem2_1[i]].Result)) && (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem1_1[i]].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem3_1[i]].Result))))
                {
                    EditOcrError(arrItem2_1[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[arrItem2_1[i]].ItemName));
                }

                // 「病名」又は「発症年齢」に記入があり、「治療状況」未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem3_1[i]].Result)) && (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem1_1[i]].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem2_1[i]].Result))))
                {
                    EditOcrError(arrItem3_1[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[arrItem3_1[i]].ItemName));
                }
            }

            // 家族歴
            string[] arrItem1_2 = new string[] { OCR_ITEM042, OCR_ITEM045, OCR_ITEM048, OCR_ITEM051, OCR_ITEM054, OCR_ITEM057 };
            string[] arrItem2_2 = new string[] { OCR_ITEM040, OCR_ITEM043, OCR_ITEM049, OCR_ITEM052, OCR_ITEM055, OCR_ITEM058 };
            string[] arrItem3_2 = new string[] { OCR_ITEM044, OCR_ITEM047, OCR_ITEM050, OCR_ITEM053, OCR_ITEM056, OCR_ITEM059 };

            for (int i = 0; i < arrItem1_2.Length; i++)
            {
                // 「発症年齢」又は「治療状況」に記入があり、「病名」未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem1_2[i]].Result)) && (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem2_2[i]].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem3_2[i]].Result))))
                {
                    EditOcrError(arrItem1_2[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[arrItem1_2[i]].ItemName));
                }

                // 「病名」又は「発症年齢」に記入があり、「治療状況」未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem3_2[i]].Result)) && (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem1_2[i]].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem2_2[i]].Result))))
                {
                    EditOcrError(arrItem3_2[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[arrItem3_2[i]].ItemName));
                }
            }

            // 妊娠
            // 男性で「はい」または「いいえ」にﾁｪｯｸがある場合
            if ("1".Equals(gender) && !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM090].Result)))
            {
                EditOcrError(OCR_ITEM090, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_006, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM090].ItemName), "男性");
            }

            // 生活習慣病問診票（１）
            // 体重変化値
            // 未記入の場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM091].Result)))
            {
                EditOcrError(OCR_ITEM091, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM091].ItemName));
            }

            // 直近体重変動
            // 未記入の場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM092].Result)))
            {
                EditOcrError(OCR_ITEM092, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM092].ItemName));
            }

            // 飲酒１（飲酒習慣）
            // 未記入の場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM093].Result)))
            {
                // 「回数」に記入がない場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM094].Result)))
                {
                    EditOcrError(OCR_ITEM093, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM093].ItemName), "飲まない");
                    mcolOcrNyuryoku[OCR_ITEM093].Result = "3"; // 「飲まない」を登録
                }
                else
                {
                    EditOcrError(OCR_ITEM093, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM093].ItemName), "習慣的に飲む");
                    mcolOcrNyuryoku[OCR_ITEM093].Result = "1"; // 「習慣的に飲む」を登録
                }
            }

            // 「習慣的に飲む」に記入があり、「回数」に記入がない場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM094].Result)) && "1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM093].Result)))
            {
                EditOcrError(OCR_ITEM094, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM094].ItemName));
            }

            // 「ときどき飲む」に記入があり、「回数」に記入がない場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM094].Result)) && "2".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM093].Result)))
            {
                EditOcrError(OCR_ITEM094, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM094].ItemName));
            }

            // 「飲まない」に記入があり、「回数」に記入がある場合
            if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM094].Result)) && "3".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM093].Result)))
            {
                EditOcrError(OCR_ITEM094, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_005, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM094].ItemName));
            }

            // 「習慣的に飲む」に記入があり、飲酒量（「ビール大瓶」～「その他」）に記入がない場合
            if ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM093].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM095].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM096].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM097].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM098].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM099].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM100].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM101].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM102].Result)))
            {
                EditOcrError(OCR_ITEM093, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_101, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM093].ItemName));
            }

            // 「ときどき飲む」と「回数」に記入があり、飲酒量（「ビール大瓶」～「その他」）に記入がない場合
            if ("2".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM093].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM095].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM096].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM097].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM098].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM099].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM100].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM101].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM102].Result)))
            {
                EditOcrError(OCR_ITEM093, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_102, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM093].ItemName));
            }

            // 喫煙
            // 未記入の場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM103].Result)))
            {
                EditOcrError(OCR_ITEM103, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM103].ItemName), "吸わない");
                mcolOcrNyuryoku[OCR_ITEM103].Result = "2"; // 「吸わない」を登録
            }

            // 喫煙開始年齢
            // 「吸わない」が記入されているのに年齢が記入されている場合
            if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM104].Result)) && "2".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM103].Result)))
            {
                EditOcrError(OCR_ITEM104, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_005, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM104].ItemName));
            }

            // 「吸っている」「過去に吸っていた」に記入があり、「喫煙開始年齢」に記入がない場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM104].Result)) && ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM103].Result))
                || "3".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM103].Result))))
            {
                EditOcrError(OCR_ITEM104, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM104].ItemName));
            }

            // 喫煙終了年齢
            // 「吸わない」が記入されているのに年齢が記入されている場合
            if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM105].Result)) && "2".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM103].Result)))
            {
                EditOcrError(OCR_ITEM105, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_005, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM105].ItemName));
            }

            // 「過去に吸っていた」に記入があり、「喫煙終了年齢」に記入がない場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM105].Result)) && "3".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM103].Result)))
            {
                EditOcrError(OCR_ITEM105, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM105].ItemName));
            }

            // 現在喫煙本数
            // 「吸わない」が記入されているのに喫煙本数が記入されている場合
            if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM106].Result)) && "2".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM103].Result)))
            {
                EditOcrError(OCR_ITEM106, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_005, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM106].ItemName));
            }

            // 「吸っている」「過去に吸っていた」に記入があり、「喫煙本数」に記入がない場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM106].Result)) && ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM103].Result))
                || "3".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM103].Result))))
            {
                EditOcrError(OCR_ITEM106, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM106].ItemName));
            }

            // 身体行動
            // 未記入の場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM109].Result)))
            {
                EditOcrError(OCR_ITEM109, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM109].ItemName), "普通に動いている");
                mcolOcrNyuryoku[OCR_ITEM109].Result = "2"; // 「普通に動いている」を登録
            }

            // 軽い運動
            // 未記入の場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM110].Result)))
            {
                EditOcrError(OCR_ITEM110, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM110].ItemName), "週1～2日以内");
                mcolOcrNyuryoku[OCR_ITEM110].Result = "3"; // 「週1～2日以内」を登録
            }

            // 自覚症状
            string[] arrItem1_3 = new string[] { OCR_ITEM114, OCR_ITEM118, OCR_ITEM122, OCR_ITEM126, OCR_ITEM130, OCR_ITEM134 };
            string[] arrItem2_3 = new string[] { OCR_ITEM115, OCR_ITEM119, OCR_ITEM123, OCR_ITEM127, OCR_ITEM131, OCR_ITEM135 };
            string[] arrItem3_3 = new string[] { OCR_ITEM116, OCR_ITEM120, OCR_ITEM124, OCR_ITEM128, OCR_ITEM132, OCR_ITEM136 };
            string[] arrItem4_3 = new string[] { OCR_ITEM117, OCR_ITEM121, OCR_ITEM125, OCR_ITEM129, OCR_ITEM133, OCR_ITEM137 };

            for (int i = 0; i < arrItem1_3.Length; i++)
            {
                // 「数値」、「単位」又は「受診」に記入があり、「自覚症状内容」未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem1_3[i]].Result)) && (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem2_3[i]].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem3_3[i]].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem4_3[i]].Result))))
                {
                    EditOcrError(arrItem1_3[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[arrItem1_3[i]].ItemName));
                }

                // 「自覚症状内容」、「単位」又は「受診」に記入があり、「数値」未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem2_3[i]].Result)) && (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem1_3[i]].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem3_3[i]].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem4_3[i]].Result))))
                {
                    EditOcrError(arrItem2_3[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[arrItem2_3[i]].ItemName));
                }

                // 「自覚症状内容」、「数値」又は「受診」に記入があり、「単位」未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem3_3[i]].Result)) && (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem1_3[i]].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem2_3[i]].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem4_3[i]].Result))))
                {
                    EditOcrError(arrItem3_3[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[arrItem3_3[i]].ItemName));
                }

                // 「自覚症状内容」、「数値」又は「単位」に記入があり、「受診」未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem4_3[i]].Result)) && (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem1_3[i]].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem2_3[i]].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem3_3[i]].Result))))
                {
                    EditOcrError(arrItem4_3[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[arrItem4_3[i]].ItemName));
                }
            }

            // 生活習慣病問診票（２）
            // 「本人希望により未回答」のときは入力チェックしない
            if (!"1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM138].Result)))
            {
                // Ａ型行動パターン・テスト
                string[] arrItem01 = new string[] { OCR_ITEM139, OCR_ITEM140, OCR_ITEM141, OCR_ITEM142, OCR_ITEM143, OCR_ITEM144, OCR_ITEM145, OCR_ITEM146, OCR_ITEM147, OCR_ITEM148, OCR_ITEM149 };
                string[] arrItem02 = new string[] { "全くない", "穏やかな方", "全くない", "全くない", "全くない", "よく遅れる", "全くない", "成り行き任せ", "気が楽だと思う", "マイペース", "すぐになれる" };

                for (int i = 0; i < arrItem01.Length; i++)
                {
                    // 未記入の場合
                    if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem01[i]].Result)))
                    {
                        EditOcrError(arrItem01[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[arrItem01[i]].ItemName), arrItem02[i]);
                        mcolOcrNyuryoku[arrItem01[i]].Result = "1"; // 一番左を登録
                    }
                }
            }

            // 「本人希望により未回答」のときは入力チェックしない
            if (!"1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM150].Result)))
            {
                // 最近１ヶ月の状態
                string[] arrItem03 = new string[] { OCR_ITEM151, OCR_ITEM152, OCR_ITEM153, OCR_ITEM154, OCR_ITEM155, OCR_ITEM156, OCR_ITEM157, OCR_ITEM158, OCR_ITEM159 };

                for (int i = 0; i < arrItem03.Length; i++)
                {
                    // 未記入の場合
                    if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem03[i]].Result)))
                    {
                        EditOcrError(arrItem03[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[arrItem03[i]].ItemName), "ほとんどなかった");
                        mcolOcrNyuryoku[arrItem03[i]].Result = "1"; // 一番左を登録
                    }
                }
            }

            // 婦人科問診票
            // 女性のとき（かつ婦人科の依頼があるとき）だけ入力チェック
            if ("2".Equals(gender) && fujinkaFlg)
            {
                // 子宮がん検診の受診経験がある
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM160].Result)))
                {
                    EditOcrError(OCR_ITEM160, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM160].ItemName));
                }

                // 検診を受けた施設は
                // 「1.子宮がん検診経験(OCR_ITEM160)」なしで、「2.検診の結果、異型上皮のクラス」・「3.検診を受けた施設は」が記入されている場合
                if ("5".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM160].Result)))
                {
                    // 1.子宮がん検診経験＝”受けたことなし”
                    if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM161].Result))
                        || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM162].Result))
                        || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM163].Result)))
                    {
                        EditOcrError(OCR_ITEM160, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_015, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM160].ItemName), "受けたことなし");
                    }
                }

                // 「4.過去の子宮頸がん検査で異常は(OCR_ITEM164)」記入無又は「いいえ」で、結果(OCR_ITEM165)・異型上皮クラス(OCR_ITEM166)、時期(OCR_ITEM167)、場所(OCR_ITEM168)が記入されている場合
                if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM165].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM166].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM167].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM168].Result)))
                {
                    switch (Convert.ToString(mcolOcrNyuryoku[OCR_ITEM164].Result))
                    {
                        case "": // 記入無
                            EditOcrError(OCR_ITEM164, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM164].ItemName));
                            break;

                        case "1": // いいえ
                            EditOcrError(OCR_ITEM164, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_015, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM164].ItemName), "いいえ");
                            break;
                    }
                }

                // 5.HPV検査を受けたことがありますか
                // HPV検査(OCR_ITEM169)が未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM169].Result)))
                {
                    EditOcrError(OCR_ITEM169, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM169].ItemName));
                }

                // 「5.ＨＰＶ検査を受けたことは(OCR_ITEM169)」で「受けたことなし」で、結果(OCR_ITEM170)、時期(OCR_ITEM171)、施設(OCR_ITEM172)が記入されている場合
                if ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM169].Result)))
                {
                    if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM170].Result))
                        || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM171].Result))
                        || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM172].Result)))
                    {
                        EditOcrError(OCR_ITEM169, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_015, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM169].ItemName), "受けたことなし");
                    }
                }

                // 6.過去に子宮体がん検査を受けたことがありますか
                // 子宮体がん検査受診(OCR_ITEM173)が未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM173].Result)))
                {
                    EditOcrError(OCR_ITEM173, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM173].ItemName));
                }

                // 「6.子宮体がん検診経験(OCR_ITEM173)」が「いいえ」で、結果(OCR_ITEM174)、擬陽性(OCR_ITEM175)、時期(OCR_ITEM176)、施設(OCR_ITEM177)が記入されている場合
                if ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM173].Result)))
                {
                    // 1.子宮体がん検診経験＝”いいえ”
                    if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM174].Result))
                        || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM175].Result))
                        || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM176].Result)))
                    {
                        EditOcrError(OCR_ITEM173, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_015, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM173].ItemName), "いいえ");
                    }
                }

                // 7.今までに下記の病気になったことがありますか
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM178].Result)))
                {
                    // すべての項目が未記入の場合
                    if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM179].Result))
                        && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM180].Result))
                        && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM181].Result))
                        && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM182].Result))
                        && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM183].Result))
                        && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM184].Result))
                        && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM185].Result))
                        && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM186].Result))
                        && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM187].Result))
                        && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM188].Result))
                        && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM189].Result))
                        && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM190].Result))
                        && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM191].Result))
                        && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM192].Result))
                        && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM193].Result)))
                    {
                        EditOcrError(OCR_ITEM178, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM178].ItemName), "ない");
                        mcolOcrNyuryoku[OCR_ITEM178].Result = "1"; // 「ない」を登録
                    }
                }

                // 「ない」と重複回答の場合
                // （病気経験(OCR_ITEM178)が「ない」場合に、症状の選択がある場合）
                if ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM178].Result)))
                {
                    string[] arrItem04 = new string[] { OCR_ITEM179, OCR_ITEM180, OCR_ITEM181, OCR_ITEM182, OCR_ITEM183, OCR_ITEM184, OCR_ITEM185, OCR_ITEM186, OCR_ITEM187, OCR_ITEM188, OCR_ITEM189, OCR_ITEM190, OCR_ITEM191, OCR_ITEM192, OCR_ITEM193 };

                    for (int i = 0; i < arrItem04.Length; i++)
                    {
                        if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem04[i]].Result)))
                        {
                            EditOcrError(arrItem04[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[arrItem04[i]].ItemName));
                        }
                    }
                }

                // 8.ホルモン治療を受けたことがある
                // ホルモン治療が未記入で「ﾎﾙﾓﾝ療法、何歳から」～「ﾎﾙﾓﾝ療法、何年間」が記入ありの場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM194].Result))
                    && !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM195].Result))
                    && !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM196].Result)))
                {
                    EditOcrError(OCR_ITEM194, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM194].ItemName), "ない");
                    mcolOcrNyuryoku[OCR_ITEM194].Result = "1"; // 「ない」を登録
                }

                // ﾎﾙﾓﾝ療法、何歳から
                // 「ある」に記入し、年齢(OCR_ITEM195)未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM195].Result))
                    && "2".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM194].Result)))
                {
                    EditOcrError(OCR_ITEM195, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM195].ItemName));
                }

                // ﾎﾙﾓﾝ療法、何年間
                // 「ある」に記入し、期間(OCR_ITEM196)未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM196].Result))
                    && "2".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM194].Result)))
                {
                    EditOcrError(OCR_ITEM196, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM196].ItemName));
                }

                // 9.今までに婦人科の検査を受けたことがありますか
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM198].Result)))
                {
                    EditOcrError(OCR_ITEM198, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM198].ItemName), "受けたことなし");
                    mcolOcrNyuryoku[OCR_ITEM198].Result = "1"; // 「受けたことなし」を登録
                }

                // 「受けたことなし」と重複回答の場合
                // （病気経験(OCR_ITEM198)が「受けたことなし」場合に、症状の選択がある場合）
                if ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM198].Result)))
                {
                    string[] arrItem05 = new string[] { OCR_ITEM199, OCR_ITEM204, OCR_ITEM209, OCR_ITEM213, OCR_ITEM216, OCR_ITEM219, OCR_ITEM222, OCR_ITEM225 };

                    for (int i = 0; i < arrItem05.Length; i++)
                    {
                        if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem05[i]].Result)))
                        {
                            EditOcrError(arrItem05[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_008, Convert.ToString(mcolOcrNyuryoku[arrItem05[i]].ItemName));
                        }
                    }
                }

                // 右卵巣(OCR_ITEM199)～左卵巣(OCR_ITEM208)
                string[] arrItem06_1 = new string[] { OCR_ITEM199, OCR_ITEM204 };
                string[] arrItem06_2 = new string[] { OCR_ITEM200, OCR_ITEM205 };
                string[] arrItem06_3 = new string[] { OCR_ITEM201, OCR_ITEM206 };
                string[] arrItem06_4 = new string[] { OCR_ITEM202, OCR_ITEM207 };
                string[] arrItem06_5 = new string[] { OCR_ITEM203, OCR_ITEM208 };

                for (int i = 0; i < arrItem06_1.Length; i++)
                {
                    // 「結果」「部位」「年齢」「施設」のいずれかに記入があり、「病名」未記入の場合
                    if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem06_1[i]].Result))
                        && (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem06_2[i]].Result))
                        || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem06_3[i]].Result))
                        || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem06_4[i]].Result))
                        || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem06_5[i]].Result))))
                    {
                        EditOcrError(arrItem06_1[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[arrItem06_1[i]].ItemName));
                    }
                }

                // 子宮全摘術(OCR_ITEM226～OCR_ITEM228)
                string[] arrItem07_1 = new string[] { OCR_ITEM209 };
                string[] arrItem07_2 = new string[] { OCR_ITEM210 };
                string[] arrItem07_3 = new string[] { OCR_ITEM211 };
                string[] arrItem07_4 = new string[] { OCR_ITEM212 };

                for (int i = 0; i < arrItem07_1.Length; i++)
                {
                    // 「結果」「年齢」「施設」のいずれかに記入があり、「病名」未記入の場合
                    if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem07_1[i]].Result))
                        && (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem07_2[i]].Result))
                        || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem07_3[i]].Result))
                        || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem07_4[i]].Result))))
                    {
                        EditOcrError(arrItem07_1[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[arrItem07_1[i]].ItemName));
                    }
                }

                // 広範囲(OCR_ITEM213)～その他(OCR_ITEM227)
                string[] arrItem08_1 = new string[] { OCR_ITEM213, OCR_ITEM216, OCR_ITEM219, OCR_ITEM222, OCR_ITEM225 };
                string[] arrItem08_2 = new string[] { OCR_ITEM214, OCR_ITEM217, OCR_ITEM220, OCR_ITEM223, OCR_ITEM226 };
                string[] arrItem08_3 = new string[] { OCR_ITEM215, OCR_ITEM218, OCR_ITEM221, OCR_ITEM224, OCR_ITEM227 };

                for (int i = 0; i < arrItem08_1.Length; i++)
                {
                    // 「年齢」又は「施設」に記入があり、「病名」未記入の場合
                    if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem08_1[i]].Result))
                        && (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem08_2[i]].Result))
                        || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem08_3[i]].Result))))
                    {
                        EditOcrError(arrItem08_1[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[arrItem08_1[i]].ItemName));
                    }
                }

                // 12.妊娠回数
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM230].Result)))
                {
                    EditOcrError(OCR_ITEM230, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM230].ItemName));
                }

                // 出産回数
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM231].Result)))
                {
                    EditOcrError(OCR_ITEM231, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM231].ItemName));
                }

                // 13.閉経
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM233].Result)))
                {
                    EditOcrError(OCR_ITEM233, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM233].ItemName));
                }

                // 14.月経
                // 閉経「いいえ」に記入
                if ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM233].Result)))
                {
                    // ①最終月経　②その前の月経　③出血量　④月経痛
                    string[] arrItem09 = new string[] { OCR_ITEM235, OCR_ITEM236, OCR_ITEM237, OCR_ITEM238, OCR_ITEM239, OCR_ITEM240, OCR_ITEM241, OCR_ITEM242, OCR_ITEM243, OCR_ITEM244, OCR_ITEM245, OCR_ITEM246 };

                    for (int i = 0; i < arrItem09.Length; i++)
                    {
                        // 未記入の場合
                        if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem09[i]].Result)))
                        {
                            EditOcrError(arrItem09[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[arrItem09[i]].ItemName));
                        }
                    }
                }

                // 15.月経以外に出血したことがある
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM247].Result)))
                {
                    EditOcrError(OCR_ITEM247, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM247].ItemName), "ない");
                    mcolOcrNyuryoku[OCR_ITEM247].Result = "1"; // 「ない」を登録
                }

                // 出血の理由の未記入チェック
                if ("4".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM247].Result)))
                {
                    if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM248].Result)))
                    {
                        EditOcrError(OCR_ITEM248, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM248].ItemName));
                    }
                }

                // 「ない」と重複回答の場合
                // （気掛かり症状(OCR_ITEM247)が「ない」場合に、出血の選択がある場合）
                if ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM247].Result)))
                {
                    if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM248].Result)))
                    {
                        EditOcrError(OCR_ITEM248, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_008, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM248].ItemName));
                    }
                }

                // 16.下記の症状はありますか（気掛り症状ない）
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM249].Result)))
                {
                    EditOcrError(OCR_ITEM249, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM249].ItemName), "ない");
                    mcolOcrNyuryoku[OCR_ITEM249].Result = "1"; // 「ない」を登録
                }

                // 「ない」と重複回答の場合
                // （気掛かり症状(OCR_ITEM249)が「ない」場合に、症状の選択がある場合）
                if ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM249].Result)))
                {
                    string[] arrItem10 = new string[] { OCR_ITEM250, OCR_ITEM251, OCR_ITEM252 };

                    for (int i = 0; i < arrItem10.Length; i++)
                    {
                        // 未記入の場合
                        if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem10[i]].Result)))
                        {
                            EditOcrError(arrItem10[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_008, Convert.ToString(mcolOcrNyuryoku[arrItem10[i]].ItemName));
                        }
                    }
                }

                // 17.家族で婦人科系がんいない
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM253].Result)))
                {
                    EditOcrError(OCR_ITEM253, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM253].ItemName), "いない");
                    mcolOcrNyuryoku[OCR_ITEM253].Result = "1"; // 「いない」を登録
                }

                string[] arrItem11_1 = new string[] { OCR_ITEM254, OCR_ITEM258, OCR_ITEM262, OCR_ITEM266, OCR_ITEM270 };
                string[] arrItem11_2 = new string[] { OCR_ITEM255, OCR_ITEM259, OCR_ITEM263, OCR_ITEM267, OCR_ITEM271 };
                string[] arrItem11_3 = new string[] { OCR_ITEM256, OCR_ITEM260, OCR_ITEM264, OCR_ITEM268, OCR_ITEM272 };
                string[] arrItem11_4 = new string[] { OCR_ITEM257, OCR_ITEM261, OCR_ITEM265, OCR_ITEM269, OCR_ITEM273 };

                // いない、の場合に何らかの入力がある場合　重複回答
                checkErrFlg = false;

                if ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM253].Result)))
                {
                    while (true)
                    {
                        for (int i = 0; i < arrItem11_1.Length; i++)
                        {
                            if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem11_1[i]].Result)))
                            {
                                // 入力がある場合　エラー
                                EditOcrError(arrItem11_1[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_009, Convert.ToString(mcolOcrNyuryoku[arrItem11_1[i]].ItemName));
                                checkErrFlg = true;
                            }
                        }

                        if (checkErrFlg)
                        {
                            break;
                        }


                        for (int i = 0; i < arrItem11_2.Length; i++)
                        {
                            if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem11_2[i]].Result)))
                            {
                                // 入力がある場合　エラー
                                EditOcrError(arrItem11_2[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_009, Convert.ToString(mcolOcrNyuryoku[arrItem11_2[i]].ItemName));
                                checkErrFlg = true;
                            }
                        }

                        if (checkErrFlg)
                        {
                            break;
                        }

                        for (int i = 0; i < arrItem11_3.Length; i++)
                        {
                            if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem11_3[i]].Result)))
                            {
                                // 入力がある場合　エラー
                                EditOcrError(arrItem11_3[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_009, Convert.ToString(mcolOcrNyuryoku[arrItem11_3[i]].ItemName));
                                checkErrFlg = true;
                            }
                        }

                        if (checkErrFlg)
                        {
                            break;
                        }

                        for (int i = 0; i < arrItem11_4.Length; i++)
                        {
                            if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem11_4[i]].Result)))
                            {
                                // 入力がある場合　エラー
                                EditOcrError(arrItem11_4[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_009, Convert.ToString(mcolOcrNyuryoku[arrItem11_4[i]].ItemName));
                                checkErrFlg = true;
                            }
                        }

                        if (checkErrFlg)
                        {
                            break;
                        }

                        break;
                    }
                }

                // 家族の記入があり、対応するがんが未記入の場合
                for (int i = 0; i < arrItem11_1.Length; i++)
                {
                    if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem11_2[i]].Result))
                        || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem11_3[i]].Result))
                        || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem11_4[i]].Result)))
                    {
                        if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem11_1[i]].Result)))
                        {
                            EditOcrError(arrItem11_1[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_010, Convert.ToString(mcolOcrNyuryoku[arrItem11_1[i]].ItemName));
                        }
                    }
                }

                // がんの記入があり、対応する家族が未記入の場合
                for (int i = 0; i < arrItem11_1.Length; i++)
                {
                    if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem11_1[i]].Result)))
                    {
                        if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem11_2[i]].Result))
                            && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem11_3[i]].Result))
                            && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem11_4[i]].Result)))
                        {
                            EditOcrError(arrItem11_1[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_011, Convert.ToString(mcolOcrNyuryoku[arrItem11_1[i]].ItemName));
                        }
                    }
                }
            }
            else
            {
                if ("1".Equals(gender))
                {
                    // 男性の場合は全てクリア
                    int i = 1;
                    foreach (string key in mcolOcrNyuryoku.Keys)
                    {
                        if (i >= mcolOcrNyuryoku[OCR_ITEM160].Index && i <= mcolOcrNyuryoku[OCR_ITEM273].Index)
                        {
                            mcolOcrNyuryoku[key].Result = ""; // 未記入とする
                        }
                        i = i + 1;
                    }
                }
            }

            // 食習慣問診票
            // 「本人希望により未回答」のときは入力チェックしない
            if (!"1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM274].Result)))
            {

                string[] arrItem12 = new string[] { OCR_ITEM275, OCR_ITEM276, OCR_ITEM277, OCR_ITEM278, OCR_ITEM279,
                                                    OCR_ITEM280, OCR_ITEM281, OCR_ITEM282, OCR_ITEM283, OCR_ITEM284,
                                                    OCR_ITEM285, OCR_ITEM286, OCR_ITEM287, OCR_ITEM288, OCR_ITEM289,
                                                    OCR_ITEM290, OCR_ITEM291, OCR_ITEM292, OCR_ITEM293, OCR_ITEM294,
                                                    OCR_ITEM295};

                for (int i = 0; i < arrItem12.Length; i++)
                {
                    if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem12[i]].Result)))
                    {
                        // 未記入の場合
                        EditOcrError(arrItem12[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[arrItem12[i]].ItemName));
                    }
                }

            }

            // 生活習慣改善意志
            // 未記入の場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM296].Result)))
            {
                EditOcrError(OCR_ITEM296, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM296].ItemName));
            }

            // 生活指導利用
            // 未記入の場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM297].Result)))
            {
                EditOcrError(OCR_ITEM297, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM297].ItemName));
            }

            // 復帰値の格納
            arrErrNo = ocrErrNo;
            arrErrState = ocrErrState;
            arrErrMsg = ocrErrMsg;

            return ocrErrCnt;
        }

        /// <summary>
        /// ＯＣＲ入力結果のエラー情報編集
        /// </summary>
        /// <param name="uniqueKey">コレクションの対象キー</param>
        /// <param name="errState">エラー状態</param>
        /// <param name="errMsgNo">エラーメッセージNo</param>
        /// <param name="itemName">エラーメッセージの項目名</param>
        /// <param name="errMsgCmt">エラーメッセージの追加コメント</param>
        /// <returns>エラーメッセージ</returns>
        private void EditOcrError(string uniqueKey, string errState, string errMsgNo, string itemName, string errMsgCmt = "")
        {
            string errMsg = "";     // エラーメッセージ
            string comment;         // 追加コメント

            if (!string.IsNullOrEmpty(errMsgCmt))
            {
                comment = errMsgCmt;
            }
            else
            {
                comment = "";
            }

            // エラーメッセージ編集
            switch (errMsgNo)
            {
                case OCR_ERRMSGNO_001: // 未記入エラー

                    errMsg = "「" + itemName + "」が、未記入です。";
                    break;

                case OCR_ERRMSGNO_002: // 未記入エラー（タイトルを登録する場合）

                    errMsg = "「" + itemName + "」が、未記入だった為、「" + comment + "」とします。";
                    break;

                case OCR_ERRMSGNO_003: // 正常値範囲外エラー

                    errMsg = "「" + itemName + "」に、「数値」が記入されています。";
                    break;

                case OCR_ERRMSGNO_004: // 重複エラー

                    errMsg = "「" + itemName + "」が、複数チェックされている為「" + comment + "」とします。";
                    break;

                case OCR_ERRMSGNO_005: // 記入されないはずの項目が記入されている場合のエラー

                    errMsg = "「" + itemName + "」は、記入されないはずです。";
                    break;

                case OCR_ERRMSGNO_006: // 異性が記入している場合のエラー

                    errMsg = "「" + itemName + "」に、「" + comment + "」が記入しています。";
                    break;

                case OCR_ERRMSGNO_007: // 0記入エラー

                    errMsg = "「" + itemName + "」に、「0」が記入されている為、未記入とします。";
                    break;

                case OCR_ERRMSGNO_008: // 「ない」と重複する場合のエラー

                    errMsg = "「" + itemName + "」が「ない」と重複回答です。";
                    break;

                case OCR_ERRMSGNO_009: // 「いない」と重複する場合のエラー

                    errMsg = "「" + itemName + "」が「いない」と重複回答です。";
                    break;

                case OCR_ERRMSGNO_015: // 「？？」と重複する場合のエラー

                    if (string.IsNullOrEmpty(comment.Trim()))
                    {
                        errMsg = "「" + itemName + "」が重複回答です。";
                    }
                    else
                    {
                        errMsg = "「" + itemName + "」が、「" + comment + "」と重複回答です。";
                    }
                    break;

                case OCR_ERRMSGNO_010: // がんの記入がない場合のエラー

                    errMsg = "「" + itemName + "」と対応する「がん」が未記入です。";
                    break;

                case OCR_ERRMSGNO_011: // 家族に記入がない場合のエラー

                    errMsg = "「" + itemName + "」と対応する「家族」が未記入です。";
                    break;

                case OCR_ERRMSGNO_012: // 未記入時に数値を登録する場合のエラー

                    errMsg = "「" + itemName + "」が未記入ですが、数値の記入があるので登録します。";
                    break;

                case OCR_ERRMSGNO_013: // 他業務登録エラー

                    errMsg = "「" + itemName + "」は、他の業務で登録されている為、OCR読込で登録できません。";
                    break;

                case OCR_ERRMSGNO_014: // 未記入時にﾃﾞﾌｫﾙﾄ値を登録

                    errMsg = "「" + itemName + "」に記入がありますが、数値の記入がないので「数値」を登録します。";
                    break;

                // これより今回追加した入力チェック結果
                case OCR_ERRMSGNO_101: // 飲酒量に記入がない場合のエラー

                    errMsg = "「" + itemName + "」が「習慣的に飲む」ですが、飲酒量が未記入です。";
                    break;

                case OCR_ERRMSGNO_102: // 飲酒量に記入がない場合のエラー

                    errMsg = "「" + itemName + "」が「ときどき飲む」ですが、飲酒量が未記入です。";
                    break;

                // これよりResultPackage.CheckResultの入力チェック結果
                case "E01":

                    errMsg = "「" + itemName + "」には数値を入力してください。";
                    break;

                case "E02":

                    errMsg = "「" + itemName + "」の桁数に誤りがあります。";
                    break;

                case "E03":

                    errMsg = "「" + itemName + "」は８桁以内で入力してください。";
                    break;

                case "E04":

                    errMsg = "「" + itemName + "」の数値範囲に誤りがあります。";
                    break;

                case "E11":

                    errMsg = "「" + itemName + "」には-,+-,+のいずれかを入力してください。";
                    break;

                case "E21":

                    errMsg = "「" + itemName + "」には-,+-,+,2+～9+のいずれかを入力してください。";
                    break;

                case "E41":

                    errMsg = "「" + itemName + "」は登録されていない文章コードです。";
                    break;

                case "E6":

                    errMsg = "「" + itemName + "」検査項目テーブルの日付桁数に誤りがあります。";
                    break;

                case "E61":

                    errMsg = "「" + itemName + "」の桁数に誤りがあります。検査項目テーブルの整数桁数で入力してください。";
                    break;

                case "E62":

                    errMsg = "「" + itemName + "」は西暦４桁の年月日を入力してください。";
                    break;

                case "E63":

                    errMsg = "「" + itemName + "」は西暦４桁の年月を入力してください。";
                    break;

                case "E64":

                    errMsg = "「" + itemName + "」は月日を入力してください。";
                    break;

                case "E65":

                    errMsg = "「" + itemName + "」は日を入力してください。";
                    break;
            }

            //エラー情報の追加
            ocrErrNo.Add(GetOcrErrNo(uniqueKey));
            ocrErrState.Add(errState);
            ocrErrMsg.Add(errMsg);

            ocrErrCnt = ocrErrCnt + 1;
        }

        /// <summary>
        /// ０記入チェック
        /// </summary>
        /// <param name="result">検査項目</param>
        /// <returns>
        /// true   数値記入
        /// false  非数値記入
        /// </returns>
        public bool IsZero(string result)
        {
            bool isZero = false;
            double output = 0.0;

            try
            {
                if (double.TryParse(result, out output) && Convert.ToDouble(result) == 0)
                {
                    isZero = true;
                }
            }
            catch
            {
                isZero = false;
            }

            return isZero;
        }

        /// <summary>
        /// エラーNo取得
        /// </summary>
        /// <param name="item">検査項目</param>
        /// <returns></returns>
        public int GetOcrErrNo(string item)
        {
            int errNo = 999;

            switch (item)
            {
                case OCR_ITEM001:
                    errNo = 1;      //errNo : 同意書（ドック全体）
                    break;
                case OCR_ITEM002:
                    errNo = 1;      //errNo : 同意書（ＧＦ）
                    break;
                case OCR_ITEM003:
                    errNo = 1;      //errNo : 同意書（ＨＰＶ）
                    break;
                case OCR_ITEM004:
                    errNo = 2;      //errNo : ブスコパン可否
                    break;
                case OCR_ITEM005:
                    errNo = 3;      //errNo : 当日朝食摂取有無
                    break;
                case OCR_ITEM006:
                    errNo = 4;      //errNo : 現病歴受診中(1)OCR値－１
                    break;
                case OCR_ITEM007:
                    errNo = 4;      //errNo : 現病歴受診中(1)OCR値－２
                    break;
                case OCR_ITEM008:
                    errNo = 4;      //errNo : 現病歴受診中(1)OCR値－３
                    break;
                case OCR_ITEM009:
                    errNo = 5;      //errNo : 現病歴受診中(2)OCR値－１
                    break;
                case OCR_ITEM010:
                    errNo = 5;      //errNo : 現病歴受診中(2)OCR値－２
                    break;
                case OCR_ITEM011:
                    errNo = 5;      //errNo : 現病歴受診中(2)OCR値－３
                    break;
                case OCR_ITEM012:
                    errNo = 6;      //errNo : 現病歴受診中(3)OCR値－１
                    break;
                case OCR_ITEM013:
                    errNo = 6;      //errNo : 現病歴受診中(3)OCR値－２
                    break;
                case OCR_ITEM014:
                    errNo = 6;      //errNo : 現病歴受診中(3)OCR値－３
                    break;
                case OCR_ITEM015:
                    errNo = 7;      //errNo : 現病歴受診中(4)OCR値－１
                    break;
                case OCR_ITEM016:
                    errNo = 7;      //errNo : 現病歴受診中(4)OCR値－２
                    break;
                case OCR_ITEM017:
                    errNo = 7;      //errNo : 現病歴受診中(4)OCR値－３
                    break;
                case OCR_ITEM018:
                    errNo = 8;      //errNo : 現病歴受診中(5)OCR値－１
                    break;
                case OCR_ITEM019:
                    errNo = 8;      //errNo : 現病歴受診中(5)OCR値－２
                    break;
                case OCR_ITEM020:
                    errNo = 8;      //errNo : 現病歴受診中(5)OCR値－３
                    break;
                case OCR_ITEM021:
                    errNo = 9;      //errNo : 現病歴受診中(6)OCR値－１
                    break;
                case OCR_ITEM022:
                    errNo = 9;      //errNo : 現病歴受診中(6)OCR値－２
                    break;
                case OCR_ITEM023:
                    errNo = 9;      //errNo : 現病歴受診中(6)OCR値－３
                    break;
                case OCR_ITEM024:
                    errNo = 10;     //errNo : 過去病歴(1)OCR値－１
                    break;
                case OCR_ITEM025:
                    errNo = 10;     //errNo : 過去病歴(1)OCR値－２
                    break;
                case OCR_ITEM026:
                    errNo = 10;     //errNo : 過去病歴(1)OCR値－３
                    break;
                case OCR_ITEM027:
                    errNo = 11;     //errNo : 過去病歴(2)OCR値－１
                    break;
                case OCR_ITEM028:
                    errNo = 11;     //errNo : 過去病歴(2)OCR値－２
                    break;
                case OCR_ITEM029:
                    errNo = 11;     //errNo : 過去病歴(2)OCR値－３
                    break;
                case OCR_ITEM030:
                    errNo = 12;     //errNo : 過去病歴(3)OCR値－１
                    break;
                case OCR_ITEM031:
                    errNo = 12;     //errNo : 過去病歴(3)OCR値－２
                    break;
                case OCR_ITEM032:
                    errNo = 12;     //errNo : 過去病歴(3)OCR値－３
                    break;
                case OCR_ITEM033:
                    errNo = 13;     //errNo : 過去病歴(4)OCR値－１
                    break;
                case OCR_ITEM034:
                    errNo = 13;     //errNo : 過去病歴(4)OCR値－２
                    break;
                case OCR_ITEM035:
                    errNo = 13;     //errNo : 過去病歴(4)OCR値－３
                    break;
                case OCR_ITEM036:
                    errNo = 14;     //errNo : 現病歴受診終了(5)OCR値－１
                    break;
                case OCR_ITEM037:
                    errNo = 14;     //errNo : 現病歴受診終了(5)OCR値－２
                    break;
                case OCR_ITEM038:
                    errNo = 14;     //errNo : 現病歴受診終了(5)OCR値－３
                    break;
                case OCR_ITEM039:
                    errNo = 15;     //errNo : 現病歴受診終了(6)OCR値－１
                    break;
                case OCR_ITEM040:
                    errNo = 15;     //errNo : 現病歴受診終了(6)OCR値－２
                    break;
                case OCR_ITEM041:
                    errNo = 15;     //errNo : 現病歴受診終了(6)OCR値－３
                    break;
                case OCR_ITEM042:
                    errNo = 16;     //errNo : 家族病歴(1)OCR値－１
                    break;
                case OCR_ITEM043:
                    errNo = 16;     //errNo : 家族病歴(1)OCR値－２
                    break;
                case OCR_ITEM044:
                    errNo = 16;     //errNo : 家族病歴(1)OCR値－３
                    break;
                case OCR_ITEM045:
                    errNo = 17;     //errNo : 家族病歴(2)OCR値－１
                    break;
                case OCR_ITEM046:
                    errNo = 17;     //errNo : 家族病歴(2)OCR値－２
                    break;
                case OCR_ITEM047:
                    errNo = 17;     //errNo : 家族病歴(2)OCR値－３
                    break;
                case OCR_ITEM048:
                    errNo = 18;     //errNo : 家族病歴(3)OCR値－１
                    break;
                case OCR_ITEM049:
                    errNo = 18;     //errNo : 家族病歴(3)OCR値－２
                    break;
                case OCR_ITEM050:
                    errNo = 18;     //errNo : 家族病歴(3)OCR値－３
                    break;
                case OCR_ITEM051:
                    errNo = 19;     //errNo : 家族病歴(4)OCR値－１
                    break;
                case OCR_ITEM052:
                    errNo = 19;     //errNo : 家族病歴(4)OCR値－２
                    break;
                case OCR_ITEM053:
                    errNo = 19;     //errNo : 家族病歴(4)OCR値－３
                    break;
                case OCR_ITEM054:
                    errNo = 20;     //errNo : 家族病歴(5)OCR値－１
                    break;
                case OCR_ITEM055:
                    errNo = 20;     //errNo : 家族病歴(5)OCR値－２
                    break;
                case OCR_ITEM056:
                    errNo = 20;     //errNo : 家族病歴(5)OCR値－３
                    break;
                case OCR_ITEM057:
                    errNo = 21;     //errNo : 家族病歴(6)OCR値－１
                    break;
                case OCR_ITEM058:
                    errNo = 21;     //errNo : 家族病歴(6)OCR値－２
                    break;
                case OCR_ITEM059:
                    errNo = 21;     //errNo : 家族病歴(6)OCR値－３
                    break;
                case OCR_ITEM060:
                    errNo = 22;     //errNo : 手術
                    break;
                case OCR_ITEM061:
                    errNo = 23;     //errNo : ヘリコバクター・ピロリ菌
                    break;
                case OCR_ITEM062:
                    errNo = 24;     //errNo : 上部消化管検査(食道ﾎﾟﾘｰﾌﾟ)
                    break;
                case OCR_ITEM063:
                    errNo = 24;     //errNo : 上部消化管検査(胃新生物)
                    break;
                case OCR_ITEM064:
                    errNo = 24;     //errNo : 上部消化管検査(慢性胃炎)
                    break;
                case OCR_ITEM065:
                    errNo = 24;     //errNo : 上部消化管検査(胃ﾎﾟﾘｰﾌﾟ)
                    break;
                case OCR_ITEM066:
                    errNo = 24;     //errNo : 上部消化管検査(胃潰瘍瘢痕)
                    break;
                case OCR_ITEM067:
                    errNo = 24;     //errNo : 上部消化管検査(十二指腸潰瘍痕)
                    break;
                case OCR_ITEM068:
                    errNo = 24;     //errNo : 上部消化管検査(その他)
                    break;
                case OCR_ITEM069:
                    errNo = 25;     //errNo : 上腹部超音波検査(胆のうﾎﾟﾘｰﾌﾟ)
                    break;
                case OCR_ITEM070:
                    errNo = 25;     //errNo : 上腹部超音波検査(胆石)
                    break;
                case OCR_ITEM071:
                    errNo = 25;     //errNo : 上腹部超音波検査(肝血管腫)
                    break;
                case OCR_ITEM072:
                    errNo = 25;     //errNo : 上腹部超音波検査(肝嚢胞)
                    break;
                case OCR_ITEM073:
                    errNo = 25;     //errNo : 上腹部超音波検査(脂肪肝)
                    break;
                case OCR_ITEM074:
                    errNo = 26;     //errNo : 上腹部超音波検査(腎結石)
                    break;
                case OCR_ITEM075:
                    errNo = 26;     //errNo : 上腹部超音波検査(腎嚢胞)
                    break;
                case OCR_ITEM076:
                    errNo = 26;     //errNo : 上腹部超音波検査(水腎症)
                    break;
                case OCR_ITEM077:
                    errNo = 26;     //errNo : 上腹部超音波検査(副腎腫瘍)
                    break;
                case OCR_ITEM078:
                    errNo = 26;     //errNo : 上腹部超音波検査(リンパ節腫大)
                    break;
                case OCR_ITEM079:
                    errNo = 26;     //errNo : 上腹部超音波検査(その他)
                    break;
                case OCR_ITEM080:
                    errNo = 27;     //errNo : 心電図検査(ＷＰＷ症候群)
                    break;
                case OCR_ITEM081:
                    errNo = 27;     //errNo : 心電図検査(完全右脚ﾌﾞﾛｯｸ)
                    break;
                case OCR_ITEM082:
                    errNo = 27;     //errNo : 心電図検査(不完全右脚ﾌﾞﾛｯｸ)
                    break;
                case OCR_ITEM083:
                    errNo = 27;     //errNo : 心電図検査(不整脈)
                    break;
                case OCR_ITEM084:
                    errNo = 27;     //errNo : 心電図検査(右胸心)
                    break;
                case OCR_ITEM085:
                    errNo = 27;     //errNo : 心電図検査(その他)
                    break;
                case OCR_ITEM086:
                    errNo = 28;     //errNo : 乳房検査(乳線症)
                    break;
                case OCR_ITEM087:
                    errNo = 28;     //errNo : 乳房検査(繊維腺腫)
                    break;
                case OCR_ITEM088:
                    errNo = 28;     //errNo : 乳房検査(乳房形成術)
                    break;
                case OCR_ITEM089:
                    errNo = 28;     //errNo : 乳房検査(その他)
                    break;
                case OCR_ITEM090:
                    errNo = 29;     //errNo : 妊娠している
                    break;
                case OCR_ITEM091:
                    errNo = 30;     //errNo : 体重変化値
                    break;
                case OCR_ITEM092:
                    errNo = 31;     //errNo : 直近体重変動
                    break;
                case OCR_ITEM093:
                    errNo = 32;     //errNo : 飲酒１（飲酒習慣）
                    break;
                case OCR_ITEM094:
                    errNo = 32;     //errNo : 現在飲酒回数
                    break;
                case OCR_ITEM095:
                    errNo = 33;     //errNo : ビール大瓶 (夕)
                    break;
                case OCR_ITEM096:
                    errNo = 34;     //errNo : ビール350ml缶 (夕)
                    break;
                case OCR_ITEM097:
                    errNo = 35;     //errNo : ビール500ml缶 (夕)
                    break;
                case OCR_ITEM098:
                    errNo = 36;     //errNo : 日本酒 (夕)
                    break;
                case OCR_ITEM099:
                    errNo = 37;     //errNo : 焼酎 (夕)
                    break;
                case OCR_ITEM100:
                    errNo = 38;     //errNo : ワイン (夕)
                    break;
                case OCR_ITEM101:
                    errNo = 39;     //errNo : ウイスキー (夕)
                    break;
                case OCR_ITEM102:
                    errNo = 40;     //errNo : その他 (夕)
                    break;
                case OCR_ITEM103:
                    errNo = 41;     //errNo : 喫煙
                    break;
                case OCR_ITEM104:
                    errNo = 42;     //errNo : 喫煙開始年齢
                    break;
                case OCR_ITEM105:
                    errNo = 42;     //errNo : 喫煙終了年齢
                    break;
                case OCR_ITEM106:
                    errNo = 43;     //errNo : 現在喫煙本数
                    break;
                case OCR_ITEM107:
                    errNo = 44;     //errNo : 運動不足認識
                    break;
                case OCR_ITEM108:
                    errNo = 45;     //errNo : 歩行時間
                    break;
                case OCR_ITEM109:
                    errNo = 46;     //errNo : 身体行動
                    break;
                case OCR_ITEM110:
                    errNo = 47;     //errNo : 軽い運動
                    break;
                case OCR_ITEM111:
                    errNo = 48;     //errNo : 睡眠状況
                    break;
                case OCR_ITEM112:
                    errNo = 48;     //errNo : 睡眠時間
                    break;
                case OCR_ITEM113:
                    errNo = 48;     //errNo : 就寝時間
                    break;
                case OCR_ITEM114:
                    errNo = 49;     //errNo : 最近数ヶ月の症状１－１
                    break;
                case OCR_ITEM115:
                    errNo = 49;     //errNo : 最近数ヶ月の症状１－２
                    break;
                case OCR_ITEM116:
                    errNo = 49;     //errNo : 最近数ヶ月の症状１－３
                    break;
                case OCR_ITEM117:
                    errNo = 49;     //errNo : 最近数ヶ月の症状１－４
                    break;
                case OCR_ITEM118:
                    errNo = 50;     //errNo : 最近数ヶ月の症状２－１
                    break;
                case OCR_ITEM119:
                    errNo = 50;     //errNo : 最近数ヶ月の症状２－２
                    break;
                case OCR_ITEM120:
                    errNo = 50;     //errNo : 最近数ヶ月の症状２－３
                    break;
                case OCR_ITEM121:
                    errNo = 50;     //errNo : 最近数ヶ月の症状２－４
                    break;
                case OCR_ITEM122:
                    errNo = 51;     //errNo : 最近数ヶ月の症状３－１
                    break;
                case OCR_ITEM123:
                    errNo = 51;     //errNo : 最近数ヶ月の症状３－２
                    break;
                case OCR_ITEM124:
                    errNo = 51;     //errNo : 最近数ヶ月の症状３－３
                    break;
                case OCR_ITEM125:
                    errNo = 51;     //errNo : 最近数ヶ月の症状３－４
                    break;
                case OCR_ITEM126:
                    errNo = 52;     //errNo : 最近数ヶ月の症状４－１
                    break;
                case OCR_ITEM127:
                    errNo = 52;     //errNo : 最近数ヶ月の症状４－２
                    break;
                case OCR_ITEM128:
                    errNo = 52;     //errNo : 最近数ヶ月の症状４－３
                    break;
                case OCR_ITEM129:
                    errNo = 52;     //errNo : 最近数ヶ月の症状４－４
                    break;
                case OCR_ITEM130:
                    errNo = 53;     //errNo : 最近数ヶ月の症状５－１
                    break;
                case OCR_ITEM131:
                    errNo = 53;     //errNo : 最近数ヶ月の症状５－２
                    break;
                case OCR_ITEM132:
                    errNo = 53;     //errNo : 最近数ヶ月の症状５－３
                    break;
                case OCR_ITEM133:
                    errNo = 53;     //errNo : 最近数ヶ月の症状５－４
                    break;
                case OCR_ITEM134:
                    errNo = 54;     //errNo : 最近数ヶ月の症状６－１
                    break;
                case OCR_ITEM135:
                    errNo = 54;     //errNo : 最近数ヶ月の症状６－２
                    break;
                case OCR_ITEM136:
                    errNo = 54;     //errNo : 最近数ヶ月の症状６－３
                    break;
                case OCR_ITEM137:
                    errNo = 54;     //errNo : 最近数ヶ月の症状６－４
                    break;
                case OCR_ITEM138:
                    errNo = 55;     //errNo : Ａ型行動パターン実施の有無
                    break;
                case OCR_ITEM139:
                    errNo = 56;     //errNo : Ａ型パターン・緊張時に腹痛
                    break;
                case OCR_ITEM140:
                    errNo = 57;     //errNo : Ａ型パターン・気性が激しい
                    break;
                case OCR_ITEM141:
                    errNo = 58;     //errNo : Ａ型パターン・責任感が強い
                    break;
                case OCR_ITEM142:
                    errNo = 59;     //errNo : Ａ型パターン・仕事に自信あり
                    break;
                case OCR_ITEM143:
                    errNo = 60;     //errNo : Ａ型パターン・早朝出勤
                    break;
                case OCR_ITEM144:
                    errNo = 61;     //errNo : Ａ型パターン・約束時間に遅刻
                    break;
                case OCR_ITEM145:
                    errNo = 62;     //errNo : Ａ型パターン・意見を貫く
                    break;
                case OCR_ITEM146:
                    errNo = 63;     //errNo : Ａ型パターン・旅行
                    break;
                case OCR_ITEM147:
                    errNo = 64;     //errNo : Ａ型パターン・他人からの指示
                    break;
                case OCR_ITEM148:
                    errNo = 65;     //errNo : Ａ型パターン・車の運転
                    break;
                case OCR_ITEM149:
                    errNo = 66;     //errNo : Ａ型パターン・帰宅時
                    break;
                case OCR_ITEM150:
                    errNo = 67;     //errNo : 最近１ヶ月の状態実施の有無
                    break;
                case OCR_ITEM151:
                    errNo = 68;     //errNo : ひどく疲れた
                    break;
                case OCR_ITEM152:
                    errNo = 69;     //errNo : へとへとだ
                    break;
                case OCR_ITEM153:
                    errNo = 70;     //errNo : だるい
                    break;
                case OCR_ITEM154:
                    errNo = 71;     //errNo : 気が張り詰めている
                    break;
                case OCR_ITEM155:
                    errNo = 72;     //errNo : 不安だ
                    break;
                case OCR_ITEM156:
                    errNo = 73;     //errNo : 落ち着かない
                    break;
                case OCR_ITEM157:
                    errNo = 74;     //errNo : ゆううつだ
                    break;
                case OCR_ITEM158:
                    errNo = 75;     //errNo : 何をするのも面倒だ
                    break;
                case OCR_ITEM159:
                    errNo = 76;     //errNo : 気分が晴れない
                    break;
                case OCR_ITEM160:
                    errNo = 77;     //errNo : 子宮がん検診の受診経験がある
                    break;
                case OCR_ITEM161:
                    errNo = 78;     //errNo : 検診の結果は
                    break;
                case OCR_ITEM162:
                    errNo = 78;     //errNo : 検診の結果（異型上皮クラス）
                    break;
                case OCR_ITEM163:
                    errNo = 79;     //errNo : 検診を受けた施設は
                    break;
                case OCR_ITEM164:
                    errNo = 80;     //errNo : 過去子宮頸がん検査で異常と言われた
                    break;
                case OCR_ITEM165:
                    errNo = 81;     //errNo : 過去子宮頸がん検査（異型上皮）
                    break;
                case OCR_ITEM166:
                    errNo = 81;     //errNo : 過去子宮頸がん検査（異型上皮クラス）
                    break;
                case OCR_ITEM167:
                    errNo = 82;     //errNo : 過去子宮頸がん検査（検査時期）
                    break;
                case OCR_ITEM168:
                    errNo = 83;     //errNo : 過去子宮頸がん検査（検査場所）
                    break;
                case OCR_ITEM169:
                    errNo = 84;     //errNo : ＨＰＶ検査を受けたことがあるか
                    break;
                case OCR_ITEM170:
                    errNo = 85;     //errNo : ＨＰＶ検査（結果）
                    break;
                case OCR_ITEM171:
                    errNo = 86;     //errNo : ＨＰＶ検査（検査時期）
                    break;
                case OCR_ITEM172:
                    errNo = 87;     //errNo : ＨＰＶ検査（検査場所）
                    break;
                case OCR_ITEM173:
                    errNo = 88;     //errNo : 子宮体がん検査を受けたことがあるか
                    break;
                case OCR_ITEM174:
                    errNo = 89;     //errNo : 子宮体がん検査の結果
                    break;
                case OCR_ITEM175:
                    errNo = 89;     //errNo : 子宮体がん検査の結果（擬陽性結果）
                    break;
                case OCR_ITEM176:
                    errNo = 90;     //errNo : 子宮体がん検査（検査時期）
                    break;
                case OCR_ITEM177:
                    errNo = 91;     //errNo : 子宮体がん検査（検査場所）
                    break;
                case OCR_ITEM178:
                    errNo = 92;     //errNo : 婦人科病気経験ない
                    break;
                case OCR_ITEM179:
                    errNo = 92;     //errNo : 婦人科病気経験子宮筋腫
                    break;
                case OCR_ITEM180:
                    errNo = 92;     //errNo : 婦人科病気経験子宮頚管ﾎﾟﾘｰﾌﾟ
                    break;
                case OCR_ITEM181:
                    errNo = 93;     //errNo : 婦人科病気経験内性子宮内膜症
                    break;
                case OCR_ITEM182:
                    errNo = 93;     //errNo : 婦人科病気経験外性子宮内膜症
                    break;
                case OCR_ITEM183:
                    errNo = 94;     //errNo : 婦人科病気経験子宮頸がん
                    break;
                case OCR_ITEM184:
                    errNo = 94;     //errNo : 婦人科病気経験子宮体がん
                    break;
                case OCR_ITEM185:
                    errNo = 94;     //errNo : 婦人科病気経験卵巣がん
                    break;
                case OCR_ITEM186:
                    errNo = 95;     //errNo : 婦人科病気経験良性卵巣腫瘍(右)
                    break;
                case OCR_ITEM187:
                    errNo = 95;     //errNo : 婦人科病気経験良性卵巣腫瘍(左)
                    break;
                case OCR_ITEM188:
                    errNo = 95;     //errNo : 婦人科病気経験絨毛性疾患
                    break;
                case OCR_ITEM189:
                    errNo = 96;     //errNo : 婦人科病気経験付属器炎
                    break;
                case OCR_ITEM190:
                    errNo = 96;     //errNo : 婦人科病気経験膣炎
                    break;
                case OCR_ITEM191:
                    errNo = 96;     //errNo : 婦人科病気経験膀胱子宮脱
                    break;
                case OCR_ITEM192:
                    errNo = 97;     //errNo : 婦人科病気経験乳がん
                    break;
                case OCR_ITEM193:
                    errNo = 97;     //errNo : 婦人科病気経験その他
                    break;
                case OCR_ITEM194:
                    errNo = 98;     //errNo : ホルモン治療を受けたことがある
                    break;
                case OCR_ITEM195:
                    errNo = 99;     //errNo : ﾎﾙﾓﾝ療法、何歳から
                    break;
                case OCR_ITEM196:
                    errNo = 99;     //errNo : ﾎﾙﾓﾝ療法、何年間
                    break;
                case OCR_ITEM197:
                    errNo = 100;    //errNo : 現在不妊治療中
                    break;
                case OCR_ITEM198:
                    errNo = 101;    //errNo : 婦人科手術経験
                    break;
                case OCR_ITEM199:
                    errNo = 102;    //errNo : 婦人科手術経験右卵巣
                    break;
                case OCR_ITEM200:
                    errNo = 102;    //errNo : 婦人科手術経験右卵巣（結果）
                    break;
                case OCR_ITEM201:
                    errNo = 102;    //errNo : 婦人科手術経験右卵巣（部位）
                    break;
                case OCR_ITEM202:
                    errNo = 102;    //errNo : 婦人科手術経験右卵巣（年齢）
                    break;
                case OCR_ITEM203:
                    errNo = 102;    //errNo : 婦人科手術経験右卵巣（場所）
                    break;
                case OCR_ITEM204:
                    errNo = 103;    //errNo : 婦人科手術経験左卵巣
                    break;
                case OCR_ITEM205:
                    errNo = 103;    //errNo : 婦人科手術経験左卵巣（結果）
                    break;
                case OCR_ITEM206:
                    errNo = 103;    //errNo : 婦人科手術経験左卵巣（部位）
                    break;
                case OCR_ITEM207:
                    errNo = 103;    //errNo : 婦人科手術経験左卵巣（年齢）
                    break;
                case OCR_ITEM208:
                    errNo = 103;    //errNo : 婦人科手術経験左卵巣（場所）
                    break;
                case OCR_ITEM209:
                    errNo = 104;    //errNo : 婦人科手術経験子宮全摘術
                    break;
                case OCR_ITEM210:
                    errNo = 104;    //errNo : 婦人科手術経験子宮全摘術（術式）
                    break;
                case OCR_ITEM211:
                    errNo = 104;    //errNo : 子宮全摘術(年齢)
                    break;
                case OCR_ITEM212:
                    errNo = 104;    //errNo : 婦人科手術経験子宮全摘術（場所）
                    break;
                case OCR_ITEM213:
                    errNo = 105;    //errNo : 婦人科手術経験広汎子宮全摘術
                    break;
                case OCR_ITEM214:
                    errNo = 105;    //errNo : 婦人科手術経験広汎子宮全摘術（年齢）
                    break;
                case OCR_ITEM215:
                    errNo = 105;    //errNo : 婦人科手術経験広汎子宮全摘術（場所）
                    break;
                case OCR_ITEM216:
                    errNo = 106;    //errNo : 婦人科手術経験子宮頸部円錐切除術
                    break;
                case OCR_ITEM217:
                    errNo = 106;    //errNo : 婦人科手術経験子宮頸部円錐切除術（年齢）
                    break;
                case OCR_ITEM218:
                    errNo = 106;    //errNo : 婦人科手術経験子宮頸部円錐切除術（場所）
                    break;
                case OCR_ITEM219:
                    errNo = 107;    //errNo : 婦人科手術経験子宮筋腫核出術
                    break;
                case OCR_ITEM220:
                    errNo = 107;    //errNo : 婦人科手術経験子宮筋腫核出術（年齢）
                    break;
                case OCR_ITEM221:
                    errNo = 107;    //errNo : 婦人科手術経験子宮筋腫核出術（場所）
                    break;
                case OCR_ITEM222:
                    errNo = 108;    //errNo : 婦人科手術経験子宮膣上部切断術
                    break;
                case OCR_ITEM223:
                    errNo = 108;    //errNo : 婦人科手術経験子宮膣上部切断術（年齢）
                    break;
                case OCR_ITEM224:
                    errNo = 108;    //errNo : 婦人科手術経験子宮膣上部切断術（場所）
                    break;
                case OCR_ITEM225:
                    errNo = 109;    //errNo : 婦人科手術経験その他
                    break;
                case OCR_ITEM226:
                    errNo = 109;    //errNo : 婦人科手術経験その他（年齢）
                    break;
                case OCR_ITEM227:
                    errNo = 109;    //errNo : 婦人科手術経験その他（場所）
                    break;
                case OCR_ITEM228:
                    errNo = 110;    //errNo : 現在の性生活
                    break;
                case OCR_ITEM229:
                    errNo = 111;    //errNo : 妊娠の可能性
                    break;
                case OCR_ITEM230:
                    errNo = 112;    //errNo : 妊娠回数
                    break;
                case OCR_ITEM231:
                    errNo = 113;    //errNo : 出産回数
                    break;
                case OCR_ITEM232:
                    errNo = 113;    //errNo : 出産回数のうち帝王切開の回数
                    break;
                case OCR_ITEM233:
                    errNo = 114;    //errNo : 閉経した
                    break;
                case OCR_ITEM234:
                    errNo = 115;    //errNo : 閉経した(年齢)
                    break;
                case OCR_ITEM235:
                    errNo = 116;    //errNo : 最終月経(From年)
                    break;
                case OCR_ITEM236:
                    errNo = 116;    //errNo : 最終月経(From月)
                    break;
                case OCR_ITEM237:
                    errNo = 116;    //errNo : 最終月経(From日)
                    break;
                case OCR_ITEM238:
                    errNo = 116;    //errNo : 最終月経(To月)
                    break;
                case OCR_ITEM239:
                    errNo = 116;    //errNo : 最終月経(To日)
                    break;
                case OCR_ITEM240:
                    errNo = 117;    //errNo : その他の月経(From年)
                    break;
                case OCR_ITEM241:
                    errNo = 117;    //errNo : その他の月経(From月)
                    break;
                case OCR_ITEM242:
                    errNo = 117;    //errNo : その他の月経(From日)
                    break;
                case OCR_ITEM243:
                    errNo = 117;    //errNo : その他の月経(To月)
                    break;
                case OCR_ITEM244:
                    errNo = 117;    //errNo : その他の月経(To日)
                    break;
                case OCR_ITEM245:
                    errNo = 118;    //errNo : 月経時の出血量
                    break;
                case OCR_ITEM246:
                    errNo = 119;    //errNo : 月経時の時、下腹部や腹部の痛み
                    break;
                case OCR_ITEM247:
                    errNo = 120;    //errNo : 月経以外に出血したことがある
                    break;
                case OCR_ITEM248:
                    errNo = 121;    //errNo : 月経以外に出血したことがある場合
                    break;
                case OCR_ITEM249:
                    errNo = 122;    //errNo : 気掛り症状ない
                    break;
                case OCR_ITEM250:
                    errNo = 123;    //errNo : 気がかり症状下腹部痛（月経痛以外で）
                    break;
                case OCR_ITEM251:
                    errNo = 123;    //errNo : 気がかり症状おりもの　（水様性）
                    break;
                case OCR_ITEM252:
                    errNo = 123;    //errNo : 気がかり症状おりもの　（血液．茶色も含む
                    break;
                case OCR_ITEM253:
                    errNo = 124;    //errNo : 家族で婦人科系がんいない
                    break;
                case OCR_ITEM254:
                    errNo = 125;    //errNo : 家族－子宮頸がん
                    break;
                case OCR_ITEM255:
                    errNo = 125;    //errNo : 家族－子宮頸がん（実母）
                    break;
                case OCR_ITEM256:
                    errNo = 125;    //errNo : 家族－子宮頸がん（実姉妹）
                    break;
                case OCR_ITEM257:
                    errNo = 125;    //errNo : 家族－子宮頸がん（その他の血縁）
                    break;
                case OCR_ITEM258:
                    errNo = 126;    //errNo : 家族で婦人科系がん子宮体がん
                    break;
                case OCR_ITEM259:
                    errNo = 126;    //errNo : 家族－子宮体がん（実母）
                    break;
                case OCR_ITEM260:
                    errNo = 126;    //errNo : 家族－子宮体がん（実姉妹）
                    break;
                case OCR_ITEM261:
                    errNo = 126;    //errNo : 家族－子宮体がん（その他の血縁）
                    break;
                case OCR_ITEM262:
                    errNo = 127;    //errNo : 家族で婦人科系がん卵巣がん
                    break;
                case OCR_ITEM263:
                    errNo = 127;    //errNo : 家族－卵巣がん（実母）
                    break;
                case OCR_ITEM264:
                    errNo = 127;    //errNo : 家族－卵巣がん（実姉妹）
                    break;
                case OCR_ITEM265:
                    errNo = 127;    //errNo : 家族－卵巣がん（その他の血縁）
                    break;
                case OCR_ITEM266:
                    errNo = 128;    //errNo : 家族で婦人科系がん病名その他
                    break;
                case OCR_ITEM267:
                    errNo = 128;    //errNo : 家族－その他の婦人科がん（実母）
                    break;
                case OCR_ITEM268:
                    errNo = 128;    //errNo : 家族－その他の婦人科がん（実姉妹）
                    break;
                case OCR_ITEM269:
                    errNo = 128;    //errNo : 家族－その他の婦人科がん（その他の血縁）
                    break;
                case OCR_ITEM270:
                    errNo = 129;    //errNo : 家族で婦人科系がん乳がん
                    break;
                case OCR_ITEM271:
                    errNo = 129;    //errNo : 家族－乳がん（実母）
                    break;
                case OCR_ITEM272:
                    errNo = 129;    //errNo : 家族－乳がん（実姉妹）
                    break;
                case OCR_ITEM273:
                    errNo = 129;    //errNo : 家族－乳がん（その他の血縁）
                    break;
                case OCR_ITEM274:
                    errNo = 130;    //errNo : 食習慣問診実施の有無
                    break;
                case OCR_ITEM275:
                    errNo = 131;    //errNo : 食事を食べる速さはいかがですか。
                    break;
                case OCR_ITEM276:
                    errNo = 132;    //errNo : 満腹まで食べることがありますか。
                    break;
                case OCR_ITEM277:
                    errNo = 133;    //errNo : 栄養のバランスを考えて食事をていますか。
                    break;
                case OCR_ITEM278:
                    errNo = 134;    //errNo : 味付けは濃い方ですか。
                    break;
                case OCR_ITEM279:
                    errNo = 135;    //errNo : １日三食食べていますか。欠食がある日はありますか。
                    break;
                case OCR_ITEM280:
                    errNo = 136;    //errNo : 食事時刻は規則的ですか。
                    break;
                case OCR_ITEM281:
                    errNo = 137;    //errNo : 間食をとることはありますか。
                    break;
                case OCR_ITEM282:
                    errNo = 138;    //errNo : 夕食が外食となる日は、週に何日位ありますか。
                    break;
                case OCR_ITEM283:
                    errNo = 139;    //errNo : 夕食をとる時間が、午後9時以降になる日は週に何日位ありますか。
                    break;
                case OCR_ITEM284:
                    errNo = 140;    //errNo : 夕食後に飲食をとることは、週に何日位ありますか。
                    break;
                case OCR_ITEM285:
                    errNo = 141;    //errNo : お菓子を食べたり、甘い飲み物を飲むことはありますか。
                    break;
                case OCR_ITEM286:
                    errNo = 142;    //errNo : 脂肪分の多い食事（揚げ物、油っこい料理、肉の脂身）を食べますか。
                    break;
                case OCR_ITEM287:
                    errNo = 143;    //errNo : 主食（ご飯、パン、麺）、芋類などを毎食、食べますか。
                    break;
                case OCR_ITEM288:
                    errNo = 144;    //errNo : 野菜をよく食べますか。
                    break;
                case OCR_ITEM289:
                    errNo = 145;    //errNo : 野菜の量はいかがですか。
                    break;
                case OCR_ITEM290:
                    errNo = 146;    //errNo : 果物をよく食べますか。
                    break;
                case OCR_ITEM291:
                    errNo = 147;    //errNo : 乳製品（牛乳、ヨーグルト、チーズ）をよく食べますか。
                    break;
                case OCR_ITEM292:
                    errNo = 148;    //errNo : 大豆製品（豆腐、納豆、豆乳など）をよく食べますか。
                    break;
                case OCR_ITEM293:
                    errNo = 149;    //errNo : 魚介類をよく食べますか。
                    break;
                case OCR_ITEM294:
                    errNo = 150;    //errNo : 肉類、卵などをよく食べますか。
                    break;
                case OCR_ITEM295:
                    errNo = 151;    //errNo : 栄養相談が必要と思われた場合、ご案内所をお送りしてもよいですか。
                    break;
                case OCR_ITEM296:
                    errNo = 152;    //errNo : 生活習慣改善意志
                    break;
                case OCR_ITEM297:
                    errNo = 153;    //errNo : 保健指導利用
                    break;
                case OCR_ITEM298:
                    errNo = 0;      //errNo : 健診前チェック担当者
                    break;
            }

            return errNo;
        }

        /// <summary>
        /// RslOcrSp3内部クラス
        /// </summary>
        public class RslOcrSp3
        {
            /// <summary>
            /// UniqueKey
            /// </summary>
            public string UniqueKey;
            /// <summary>
            /// 個人ＩＤ
            /// </summary>
            public string PerId;
            /// <summary>
            /// 受診日
            /// </summary>
            public DateTime CslDate;
            /// <summary>
            /// 予約番号
            /// </summary>
            public string RsvNo;
            /// <summary>
            /// 検査項目コード
            /// </summary>
            public string ItemCd;
            /// <summary>
            /// サフィックス
            /// </summary>
            public string Suffix;
            /// <summary>
            /// 結果タイプ
            /// </summary>
            public string ResultType;
            /// <summary>
            /// 項目タイプ
            /// </summary>
            public string ItemType;
            /// <summary>
            /// 検査項目名称
            /// </summary>
            public string ItemName;
            /// <summary>
            /// 整数部桁数
            /// </summary>
            public string Figure1;
            /// <summary>
            /// 小数部桁数
            /// </summary>
            public string Figure2;
            /// <summary>
            /// 最大値
            /// </summary>
            public string MaxValue;
            /// <summary>
            /// 最小値
            /// </summary>
            public string MinValue;
            /// <summary>
            /// 単位
            /// </summary>
            public string Unit;
            /// <summary>
            /// 検査結果存在フラグ
            /// 1:検査結果に存在する、
            /// 0:検査結果に存在しない
            /// </summary>
            public string RslFlg;
            /// <summary>
            /// 検査結果
            /// </summary>
            public string Result;
            /// <summary>
            /// 検査中止フラグ
            /// </summary>
            public string StopFlg;
            /// <summary>
            /// 結果コメント１
            /// </summary>
            public string RslCmtCd1;
            /// <summary>
            /// 結果コメント名１
            /// </summary>
            public string RslCmtName1;
            /// <summary>
            /// 結果コメント２
            /// </summary>
            public string RslCmtCd2;
            /// <summary>
            /// 結果コメント名２
            /// </summary>
            public string RslCmtName2;
            /// <summary>
            /// 前回受診日
            /// </summary>
            public DateTime? LstCslDate;
            /// <summary>
            /// 前回予約番号
            /// </summary>
            public string LstRsvNo;
            /// <summary>
            /// 前回検査結果存在フラグ
            /// 2:個人検査結果に存在する、
            /// 1:検査結果に存在する、
            /// 0:検査結果に存在しない
            /// </summary>
            public string LstRslFlg;
            /// <summary>
            /// 前回検査中止フラグ
            /// </summary>
            public string LstStopFlg;
            /// <summary>
            /// 前回検査結果
            /// </summary>
            public string LstResult;
            /// <summary>
            /// 前回結果コメント１
            /// </summary>
            public string LstRslCmtCd1;
            /// <summary>
            /// 前回結果コメント名１
            /// </summary>
            public string LstRslCmtName1;
            /// <summary>
            /// 前回結果コメント２
            /// </summary>
            public string LstRslCmtCd2;
            /// <summary>
            /// 前回結果コメント名２
            /// </summary>
            public string LstRslCmtName2;
            /// <summary>
            /// Index
            /// </summary>
            public int Index;
        }
    }
}
