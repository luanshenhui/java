using Dapper;
using Entity.Helper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Hainsi.Entity.Model.Result;
using Newtonsoft.Json.Linq;
using Microsoft.VisualBasic;
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
    /// Questionnaire1Daoデータアクセスオブジェクト
    /// </summary>
    public class Questionnaire1Dao : AbstractDao
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
        public Questionnaire1Dao(IDbConnection connection, PersonDao personDao, ResultDao resultDao) : base(connection)
        {
            this.personDao = personDao;
            this.resultDao = resultDao;
        }

        private Dictionary<string, RslOcrSp> mcolOcrNyuryoku; // OCR入力結果レコードのコレクション

        private int ocrErrCnt;                                  // エラー数
        private List<int> ocrErrNo = new List<int>();           // エラーNo
        private List<string> ocrErrState = new List<string>();  // エラー状態
        private List<string> ocrErrMsg = new List<string>();    // エラーメッセージ

        private bool stomachFlg; // 胃Ｘ線の依頼フラグ
        private bool fujinkaFlg; // 婦人科の依頼フラグ

        private const string OCR_ERRSTAT_ERROR = "1";           // エラー
        private const string OCR_ERRSTAT_WARNING = "2";         // ワーニング

        // OCR入力結果画面へ表示する検査項目
        private const string OCR_ITEM001 = "65090-00"; //ブスコパン可否
        private const string OCR_ITEM002 = "61310-00"; //朝食摂取の有無
        private const string OCR_ITEM003 = "65110-01"; //病名
        private const string OCR_ITEM004 = "65110-02"; //発症年齢
        private const string OCR_ITEM005 = "65110-03"; //治療状況
        private const string OCR_ITEM006 = "65111-01"; //病名
        private const string OCR_ITEM007 = "65111-02"; //発症年齢
        private const string OCR_ITEM008 = "65111-03"; //治療状況
        private const string OCR_ITEM009 = "65112-01"; //病名
        private const string OCR_ITEM010 = "65112-02"; //発症年齢
        private const string OCR_ITEM011 = "65112-03"; //治療状況
        private const string OCR_ITEM012 = "65113-01"; //病名
        private const string OCR_ITEM013 = "65113-02"; //発症年齢
        private const string OCR_ITEM014 = "65113-03"; //治療状況
        private const string OCR_ITEM015 = "65114-01"; //病名
        private const string OCR_ITEM016 = "65114-02"; //発症年齢
        private const string OCR_ITEM017 = "65114-03"; //治療状況
        private const string OCR_ITEM018 = "65115-01"; //病名
        private const string OCR_ITEM019 = "65115-02"; //発症年齢
        private const string OCR_ITEM020 = "65115-03"; //治療状況
        private const string OCR_ITEM021 = "65120-01"; //病名
        private const string OCR_ITEM022 = "65120-02"; //発症年齢
        private const string OCR_ITEM023 = "65120-03"; //治療状況
        private const string OCR_ITEM024 = "65121-01"; //病名
        private const string OCR_ITEM025 = "65121-02"; //発症年齢
        private const string OCR_ITEM026 = "65121-03"; //治療状況
        private const string OCR_ITEM027 = "65122-01"; //病名
        private const string OCR_ITEM028 = "65122-02"; //発症年齢
        private const string OCR_ITEM029 = "65122-03"; //治療状況
        private const string OCR_ITEM030 = "65123-01"; //病名
        private const string OCR_ITEM031 = "65123-02"; //発症年齢
        private const string OCR_ITEM032 = "65123-03"; //治療状況
        private const string OCR_ITEM033 = "65124-01"; //病名
        private const string OCR_ITEM034 = "65124-02"; //発症年齢
        private const string OCR_ITEM035 = "65124-03"; //治療状況
        private const string OCR_ITEM036 = "65125-01"; //病名
        private const string OCR_ITEM037 = "65125-02"; //発症年齢
        private const string OCR_ITEM038 = "65125-03"; //治療状況
        private const string OCR_ITEM039 = "65130-01"; //病名
        private const string OCR_ITEM040 = "65130-02"; //発症年齢
        private const string OCR_ITEM041 = "65130-03"; //続柄
        private const string OCR_ITEM042 = "65131-01"; //病名
        private const string OCR_ITEM043 = "65131-02"; //発症年齢
        private const string OCR_ITEM044 = "65131-03"; //続柄
        private const string OCR_ITEM045 = "65132-01"; //病名
        private const string OCR_ITEM046 = "65132-02"; //発症年齢
        private const string OCR_ITEM047 = "65132-03"; //続柄
        private const string OCR_ITEM048 = "65133-01"; //病名
        private const string OCR_ITEM049 = "65133-02"; //発症年齢
        private const string OCR_ITEM050 = "65133-03"; //続柄
        private const string OCR_ITEM051 = "65134-01"; //病名
        private const string OCR_ITEM052 = "65134-02"; //発症年齢
        private const string OCR_ITEM053 = "65134-03"; //続柄
        private const string OCR_ITEM054 = "65135-01"; //病名
        private const string OCR_ITEM055 = "65135-02"; //発症年齢
        private const string OCR_ITEM056 = "65135-03"; //続柄
        private const string OCR_ITEM057 = "65092-00"; //手術をされた方へ
        private const string OCR_ITEM058 = "65091-00"; //妊娠していますか
        private const string OCR_ITEM059 = "65093-01"; //肺結核
        private const string OCR_ITEM060 = "65093-02"; //無気肺
        private const string OCR_ITEM061 = "65093-03"; //肺腺維症
        private const string OCR_ITEM062 = "65093-04"; //胸膜瘢痕
        private const string OCR_ITEM063 = "65093-05"; //陳旧性病変
        private const string OCR_ITEM064 = "65094-01"; //食道ポリープ
        private const string OCR_ITEM065 = "65094-02"; //胃新生物
        private const string OCR_ITEM066 = "65094-03"; //慢性胃炎
        private const string OCR_ITEM067 = "65094-04"; //胃ポリープ
        private const string OCR_ITEM068 = "65094-05"; //胃潰瘍瘢痕
        private const string OCR_ITEM069 = "65094-06"; //十二指腸
        private const string OCR_ITEM070 = "65094-07"; //その他
        private const string OCR_ITEM071 = "65095-01"; //胆のうポリープ
        private const string OCR_ITEM072 = "65095-02"; //胆石
        private const string OCR_ITEM073 = "65095-03"; //肝血管腫
        private const string OCR_ITEM074 = "65095-04"; //肝嚢胞
        private const string OCR_ITEM075 = "65095-05"; //脂肪肝
        private const string OCR_ITEM076 = "65095-06"; //腎結石
        private const string OCR_ITEM077 = "65095-07"; //腎嚢胞
        private const string OCR_ITEM078 = "65095-08"; //その他
        private const string OCR_ITEM079 = "65096-01"; //ＷＰＷ症候群
        private const string OCR_ITEM080 = "65096-02"; //完全右脚ブロック
        private const string OCR_ITEM081 = "65096-03"; //不完全右脚ブロック
        private const string OCR_ITEM082 = "65096-04"; //不整脈
        private const string OCR_ITEM083 = "65096-05"; //その他
        private const string OCR_ITEM084 = "65097-01"; //乳腺症
        private const string OCR_ITEM085 = "65097-02"; //繊維線種
        private const string OCR_ITEM086 = "65097-03"; //その他
        private const string OCR_ITEM087 = "63021-00"; //１８～２０歳の体重
        private const string OCR_ITEM088 = "63030-00"; //この半年での体重の変動
        private const string OCR_ITEM089 = "63040-00"; //週に何日飲みますか
        private const string OCR_ITEM090 = "63050-00"; //飲酒日数
        private const string OCR_ITEM091 = "60180-03"; //ビール大瓶
        private const string OCR_ITEM092 = "60181-03"; //ビール３５０ｍｌ缶
        private const string OCR_ITEM093 = "60182-03"; //ビール５００ｍｌ缶
        private const string OCR_ITEM094 = "60183-03"; //日本酒
        private const string OCR_ITEM095 = "60184-03"; //焼酎
        private const string OCR_ITEM096 = "60185-03"; //ワイン
        private const string OCR_ITEM097 = "60186-03"; //ウイスキー・ブランデー
        private const string OCR_ITEM098 = "60187-03"; //その他
        private const string OCR_ITEM099 = "63070-00"; //現在の喫煙
        private const string OCR_ITEM100 = "63080-00"; //吸い始めた年齢
        private const string OCR_ITEM101 = "63089-00"; //やめた年齢
        private const string OCR_ITEM102 = "63081-00"; //喫煙本数
        private const string OCR_ITEM103 = "63100-00"; //運動不足
        private const string OCR_ITEM104 = "63082-00"; //何分歩くか
        private const string OCR_ITEM105 = "75090-00"; //日常の身体活動
        private const string OCR_ITEM106 = "75100-00"; //運動習慣
        private const string OCR_ITEM107 = "63130-00"; //睡眠は十分ですか
        private const string OCR_ITEM108 = "63083-00"; //睡眠時間
        private const string OCR_ITEM109 = "63084-00"; //就寝時刻
        private const string OCR_ITEM110 = "63140-00"; //歯磨きについて
        private const string OCR_ITEM111 = "63150-00"; //現在の職業は
        private const string OCR_ITEM112 = "63160-00"; //休日は何日とれますか
        private const string OCR_ITEM113 = "63170-00"; //職場への通勤手段
        private const string OCR_ITEM114 = "63086-00"; //片道の通勤時間
        private const string OCR_ITEM115 = "63085-00"; //徒歩時間
        private const string OCR_ITEM116 = "63180-00"; //配偶者は
        private const string OCR_ITEM117 = "75530-00"; //親
        private const string OCR_ITEM118 = "75540-00"; //配偶者
        private const string OCR_ITEM119 = "75550-00"; //子供
        private const string OCR_ITEM120 = "75560-00"; //独居
        private const string OCR_ITEM121 = "75570-00"; //その他
        private const string OCR_ITEM122 = "75400-00"; //生活に満足
        private const string OCR_ITEM123 = "75410-00"; //１年以内につらい思い
        private const string OCR_ITEM124 = "75430-00"; //信仰心
        private const string OCR_ITEM125 = "75440-00"; //ボランティア活動
        private const string OCR_ITEM126 = "63240-01"; //自覚症状内容
        private const string OCR_ITEM127 = "63240-02"; //数値
        private const string OCR_ITEM128 = "63240-03"; //単位
        private const string OCR_ITEM129 = "63240-04"; //受診
        private const string OCR_ITEM130 = "63250-01"; //自覚症状内容
        private const string OCR_ITEM131 = "63250-02"; //数値
        private const string OCR_ITEM132 = "63250-03"; //単位
        private const string OCR_ITEM133 = "63250-04"; //受診
        private const string OCR_ITEM134 = "63260-01"; //自覚症状内容
        private const string OCR_ITEM135 = "63260-02"; //数値
        private const string OCR_ITEM136 = "63260-03"; //単位
        private const string OCR_ITEM137 = "63260-04"; //受診
        private const string OCR_ITEM138 = "63270-01"; //自覚症状内容
        private const string OCR_ITEM139 = "63270-02"; //数値
        private const string OCR_ITEM140 = "63270-03"; //単位
        private const string OCR_ITEM141 = "63270-04"; //受診
        private const string OCR_ITEM142 = "63280-01"; //自覚症状内容
        private const string OCR_ITEM143 = "63280-02"; //数値
        private const string OCR_ITEM144 = "63280-03"; //単位
        private const string OCR_ITEM145 = "63280-04"; //受診
        private const string OCR_ITEM146 = "63290-01"; //自覚症状内容
        private const string OCR_ITEM147 = "63290-02"; //数値
        private const string OCR_ITEM148 = "63290-03"; //単位
        private const string OCR_ITEM149 = "63290-04"; //受診
        private const string OCR_ITEM150 = "63594-00"; //本人希望により未回答
        private const string OCR_ITEM151 = "63810-00"; //ストレス、緊張時上腹部に痛み
        private const string OCR_ITEM152 = "63820-00"; //気性は激しい方ですか
        private const string OCR_ITEM153 = "63830-00"; //責任感が強いと言われた
        private const string OCR_ITEM154 = "63840-00"; //仕事に自信を持っている
        private const string OCR_ITEM155 = "63850-00"; //特別に早起きして職場に行く
        private const string OCR_ITEM156 = "63860-00"; //約束の時間に遅れる方
        private const string OCR_ITEM157 = "63870-00"; //正しいと思うことは貫く
        private const string OCR_ITEM158 = "63880-00"; //数時間旅行すると仮定
        private const string OCR_ITEM159 = "63890-00"; //他人から指示された場合
        private const string OCR_ITEM160 = "63900-00"; //車を追い抜かれた場合
        private const string OCR_ITEM161 = "63910-00"; //帰宅時リラックスした気分
        private const string OCR_ITEM162 = "63592-00"; //本人希望により未回答
        private const string OCR_ITEM163 = "63610-01"; //積極的に解決しようと努力する
        private const string OCR_ITEM164 = "63610-02"; //自分への挑戦と受け止める
        private const string OCR_ITEM165 = "63610-03"; //一休みするより頑張ろうとする
        private const string OCR_ITEM166 = "63610-04"; //衝動買いや高価な買い物をする
        private const string OCR_ITEM167 = "63610-05"; //同僚や家族と出歩いたり飲み食いする
        private const string OCR_ITEM168 = "63610-06"; //何か新しい事を始めようとする
        private const string OCR_ITEM169 = "63610-07"; //今の状況から抜け出る事は無理だと思う
        private const string OCR_ITEM170 = "63610-08"; //楽しかったことをボンヤリ考える
        private const string OCR_ITEM171 = "63610-09"; //どうすれば良かったのかを思い悩む
        private const string OCR_ITEM172 = "63610-10"; //現在の状況について考えないようにする
        private const string OCR_ITEM173 = "63610-11"; //体の調子の悪い時には病院に行こうかと思う
        private const string OCR_ITEM174 = "63610-12"; //以前よりタバコ・酒・食事の量が増える
        private const string OCR_ITEM175 = "63350-00"; //子宮ガンの検診を受けたことは
        private const string OCR_ITEM176 = "63360-00"; //健診を受けた施設は
        private const string OCR_ITEM177 = "63370-00"; //健診の結果は
        private const string OCR_ITEM178 = "63390-00"; //ない
        private const string OCR_ITEM179 = "63411-00"; //膣炎
        private const string OCR_ITEM180 = "63440-00"; //月経異常
        private const string OCR_ITEM181 = "63470-00"; //不妊
        private const string OCR_ITEM182 = "63400-00"; //子宮筋腫
        private const string OCR_ITEM183 = "63420-00"; //子宮内膜症
        private const string OCR_ITEM184 = "63450-00"; //子宮がん
        private const string OCR_ITEM185 = "63471-00"; //子宮頚管ポリープ
        private const string OCR_ITEM186 = "63410-00"; //卵巣腫瘍（右）
        private const string OCR_ITEM187 = "63430-00"; //卵巣腫瘍（左）
        private const string OCR_ITEM188 = "63460-00"; //乳がん
        private const string OCR_ITEM189 = "63480-00"; //びらん
        private const string OCR_ITEM190 = "63490-00"; //ホルモン治療
        private const string OCR_ITEM191 = "63491-00"; //歳
        private const string OCR_ITEM192 = "63500-00"; //年数
        private const string OCR_ITEM193 = "63510-00"; //婦人科の手術
        private const string OCR_ITEM194 = "63511-00"; //子宮全摘術
        private const string OCR_ITEM195 = "63540-00"; //歳
        private const string OCR_ITEM196 = "63512-00"; //卵巣摘出術
        private const string OCR_ITEM197 = "63541-00"; //歳
        private const string OCR_ITEM198 = "63542-00"; //部分
        private const string OCR_ITEM199 = "63520-00"; //子宮筋腫核出術
        private const string OCR_ITEM200 = "63543-00"; //歳
        private const string OCR_ITEM201 = "63546-00"; //妊娠回数
        private const string OCR_ITEM202 = "63547-00"; //出産回数
        private const string OCR_ITEM203 = "63548-00"; //帝王切開回数
        private const string OCR_ITEM204 = "63588-00"; //１年以内に妊娠または出産
        private const string OCR_ITEM205 = "63550-00"; //閉経しましたか
        private const string OCR_ITEM206 = "63551-00"; //歳
        private const string OCR_ITEM207 = "63552-03"; //開始年
        private const string OCR_ITEM208 = "63552-01"; //開始月
        private const string OCR_ITEM209 = "63552-02"; //開始日
        private const string OCR_ITEM210 = "63554-01"; //終了月
        private const string OCR_ITEM211 = "63554-02"; //終了日
        private const string OCR_ITEM212 = "63556-03"; //開始年
        private const string OCR_ITEM213 = "63556-01"; //開始月
        private const string OCR_ITEM214 = "63556-02"; //開始日
        private const string OCR_ITEM215 = "63558-01"; //終了月
        private const string OCR_ITEM216 = "63558-02"; //終了日
        private const string OCR_ITEM217 = "63560-00"; //月経周期
        private const string OCR_ITEM218 = "63561-00"; //不規則
        private const string OCR_ITEM219 = "63562-00"; //月経期間
        private const string OCR_ITEM220 = "63563-00"; //不規則
        private const string OCR_ITEM221 = "63564-00"; //出血量
        private const string OCR_ITEM222 = "63565-00"; //痛み
        private const string OCR_ITEM223 = "63566-00"; //月経以外に出血
        private const string OCR_ITEM224 = "63570-00"; //ない
        private const string OCR_ITEM225 = "63571-00"; //おりものが気になる
        private const string OCR_ITEM226 = "63572-00"; //陰部がかゆい
        private const string OCR_ITEM227 = "63573-00"; //下腹部が痛い
        private const string OCR_ITEM228 = "63574-00"; //更年期症状がつらい
        private const string OCR_ITEM229 = "63575-00"; //性交時に出血する
        private const string OCR_ITEM230 = "63577-00"; //性生活
        private const string OCR_ITEM231 = "63579-00"; //いない
        private const string OCR_ITEM232 = "63580-00"; //実母
        private const string OCR_ITEM233 = "63581-00"; //実姉妹
        private const string OCR_ITEM234 = "63582-00"; //その他
        private const string OCR_ITEM235 = "63583-00"; //子宮体ガン
        private const string OCR_ITEM236 = "63584-00"; //子宮頚ガン
        private const string OCR_ITEM237 = "63585-00"; //卵巣ガン
        private const string OCR_ITEM238 = "63586-00"; //乳がん
        private const string OCR_ITEM239 = "63587-00"; //その他の婦人科系ガン
        private const string OCR_ITEM240 = "63593-00"; //本人希望により未回答
        private const string OCR_ITEM241 = "61120-00"; //カロリー制限
        private const string OCR_ITEM242 = "61120-01"; //カロリー制限量
        private const string OCR_ITEM243 = "61130-00"; //食事の速度は速い
        private const string OCR_ITEM244 = "61140-00"; //満腹になるまで食べるほう
        private const string OCR_ITEM245 = "61150-00"; //食事の規則性は
        private const string OCR_ITEM246 = "61160-00"; //１週間の平均欠食回数
        private const string OCR_ITEM247 = "61170-00"; //バランスを考えて食べている
        private const string OCR_ITEM248 = "61180-00"; //甘いものはよく食べる
        private const string OCR_ITEM249 = "61190-00"; //脂肪分の多い食事を好む
        private const string OCR_ITEM250 = "61200-00"; //味付けは濃いほう
        private const string OCR_ITEM251 = "61210-00"; //間食をとることがある
        private const string OCR_ITEM252 = "61220-00"; //１週間の平均間食回数
        private const string OCR_ITEM253 = "61230-00"; //減塩醤油を使っている
        private const string OCR_ITEM254 = "60189-02"; //コーヒー・紅茶
        private const string OCR_ITEM255 = "60191-02"; //砂糖（小さじ）
        private const string OCR_ITEM256 = "60192-02"; //ミルク（小さじ）
        private const string OCR_ITEM257 = "60193-02"; //ジュース（スポーツ飲料も含む）
        private const string OCR_ITEM258 = "60239-02"; //果汁・野菜ジュース
        private const string OCR_ITEM259 = "60194-02"; //炭酸飲料
        private const string OCR_ITEM260 = "60195-02"; //アイス
        private const string OCR_ITEM261 = "60196-02"; //シャーベット
        private const string OCR_ITEM262 = "60205-02"; //クッキー
        private const string OCR_ITEM263 = "60206-02"; //あめ
        private const string OCR_ITEM264 = "60197-02"; //チョコレート
        private const string OCR_ITEM265 = "60198-02"; //スナック菓子
        private const string OCR_ITEM266 = "60199-02"; //ナッツ
        private const string OCR_ITEM267 = "60200-02"; //和菓子（まんじゅうなど）
        private const string OCR_ITEM268 = "60201-02"; //洋菓子（ケーキなど）
        private const string OCR_ITEM269 = "60202-02"; //ドーナツ
        private const string OCR_ITEM270 = "60203-02"; //ゼリー
        private const string OCR_ITEM271 = "60204-02"; //せんべい（あられ）
        private const string OCR_ITEM272 = "60207-01"; //普通牛乳
        private const string OCR_ITEM273 = "60208-01"; //普通ヨーグルト
        private const string OCR_ITEM274 = "60241-01"; //低脂肪牛乳
        private const string OCR_ITEM275 = "60242-01"; //低脂肪ヨーグルト
        private const string OCR_ITEM276 = "61240-00"; //毎日食べていますか
        private const string OCR_ITEM277 = "60101-01"; //ご飯（女性用茶碗）
        private const string OCR_ITEM278 = "60102-01"; //ご飯（男性用茶碗）
        private const string OCR_ITEM279 = "60103-01"; //ご飯（どんぶり茶碗）
        private const string OCR_ITEM280 = "60104-01"; //おにぎり
        private const string OCR_ITEM281 = "60110-01"; //そば・うどん（天ぷら）
        private const string OCR_ITEM282 = "60112-01"; //そば・うどん（たぬき）
        private const string OCR_ITEM283 = "60113-01"; //そば・うどん（ざる・かけ）
        private const string OCR_ITEM284 = "60136-01"; //ラーメン
        private const string OCR_ITEM285 = "60215-01"; //五目ラーメン
        private const string OCR_ITEM286 = "60216-01"; //焼きそば
        private const string OCR_ITEM287 = "60217-01"; //スパゲッティ（クリーム)
        private const string OCR_ITEM288 = "60218-01"; //スパゲッティ（その他)
        private const string OCR_ITEM289 = "60162-01"; //マカロニグラタン
        private const string OCR_ITEM290 = "60105-01"; //食パン６枚切り
        private const string OCR_ITEM291 = "60106-01"; //食パン８枚切り
        private const string OCR_ITEM292 = "60107-01"; //バター
        private const string OCR_ITEM293 = "60108-01"; //マーガリン
        private const string OCR_ITEM294 = "60109-01"; //ジャム類
        private const string OCR_ITEM295 = "60146-01"; //ミックスサンドイッチ
        private const string OCR_ITEM296 = "60219-01"; //菓子パン
        private const string OCR_ITEM297 = "60220-01"; //調理パン
        private const string OCR_ITEM298 = "60143-01"; //カツ丼
        private const string OCR_ITEM299 = "60145-01"; //親子丼
        private const string OCR_ITEM300 = "60144-01"; //天丼
        private const string OCR_ITEM301 = "60221-01"; //中華丼
        private const string OCR_ITEM302 = "60138-01"; //カレーライス
        private const string OCR_ITEM303 = "60139-01"; //チャーハン・ピラフ
        private const string OCR_ITEM304 = "60140-01"; //にぎり・ちらし寿司
        private const string OCR_ITEM305 = "60142-01"; //幕の内弁当
        private const string OCR_ITEM306 = "60114-01"; //シリアル等
        private const string OCR_ITEM307 = "60209-01"; //ミックスピザ
        private const string OCR_ITEM308 = "60222-01"; //刺身盛り合わせ
        private const string OCR_ITEM309 = "60223-01"; //煮魚・焼魚（ぶり、さんま、いわし等）
        private const string OCR_ITEM310 = "60224-01"; //煮魚・焼魚（かれい、たら、ひらめ等）
        private const string OCR_ITEM311 = "60210-01"; //魚のムニエル
        private const string OCR_ITEM312 = "60163-01"; //エビチリ
        private const string OCR_ITEM313 = "60225-01"; //八宝菜
        private const string OCR_ITEM314 = "60226-01"; //ステーキ(150g)
        private const string OCR_ITEM315 = "60156-01"; //焼き肉
        private const string OCR_ITEM316 = "60166-01"; //とりの唐揚
        private const string OCR_ITEM317 = "60157-01"; //ハンバーグ
        private const string OCR_ITEM318 = "60161-01"; //シチュー
        private const string OCR_ITEM319 = "60238-01"; //肉野菜炒め
        private const string OCR_ITEM320 = "60165-01"; //餃子・シュウマイ
        private const string OCR_ITEM321 = "60227-01"; //ハム・ウィンナー
        private const string OCR_ITEM322 = "60228-01"; //ベーコン
        private const string OCR_ITEM323 = "60211-01"; //フライ（コロッケ）
        private const string OCR_ITEM324 = "60169-01"; //フライ（トンカツ）
        private const string OCR_ITEM325 = "60170-01"; //フライ（えび）
        private const string OCR_ITEM326 = "60155-01"; //天ぷら
        private const string OCR_ITEM327 = "60229-01"; //すき焼き・しゃぶしゃぶ等
        private const string OCR_ITEM328 = "60141-01"; //寄鍋・たらちり等
        private const string OCR_ITEM329 = "60212-01"; //おでん
        private const string OCR_ITEM330 = "60117-01"; //生卵・ゆで卵
        private const string OCR_ITEM331 = "60119-01"; //目玉焼き
        private const string OCR_ITEM332 = "60120-01"; //卵焼き
        private const string OCR_ITEM333 = "60118-01"; //スクランブル
        private const string OCR_ITEM334 = "60164-01"; //かに玉
        private const string OCR_ITEM335 = "60160-01"; //冷・湯豆腐
        private const string OCR_ITEM336 = "60115-01"; //納豆
        private const string OCR_ITEM337 = "60230-01"; //マーボ豆腐
        private const string OCR_ITEM338 = "60231-01"; //五目豆
        private const string OCR_ITEM339 = "60131-01"; //野菜サラダ
        private const string OCR_ITEM340 = "60232-01"; //ノンオイルドレッシング
        private const string OCR_ITEM341 = "60233-01"; //マヨネーズ
        private const string OCR_ITEM342 = "60234-01"; //ドレッシング
        private const string OCR_ITEM343 = "60235-01"; //塩
        private const string OCR_ITEM344 = "60176-01"; //ポテト・マカロニサラダ
        private const string OCR_ITEM345 = "60178-01"; //煮物（芋入り）
        private const string OCR_ITEM346 = "60177-01"; //煮物（野菜のみ）
        private const string OCR_ITEM347 = "60237-01"; //煮物（ひじき・昆布等）
        private const string OCR_ITEM348 = "60213-01"; //肉じゃが
        private const string OCR_ITEM349 = "60179-01"; //野菜炒め（肉なし）
        private const string OCR_ITEM350 = "60126-01"; //おひたし
        private const string OCR_ITEM351 = "60175-01"; //酢の物
        private const string OCR_ITEM352 = "60132-01"; //味噌汁
        private const string OCR_ITEM353 = "60133-01"; //コンソメ
        private const string OCR_ITEM354 = "60134-01"; //ポタージュ
        private const string OCR_ITEM355 = "60121-01"; //チーズ
        private const string OCR_ITEM356 = "60188-01"; //枝豆
        private const string OCR_ITEM357 = "60135-01"; //果物
        private const string OCR_ITEM358 = "60240-01"; //お漬物
        private const string OCR_ITEM359 = "61250-00"; //毎日食べていますか
        private const string OCR_ITEM360 = "60101-02"; //ご飯（女性用茶碗）
        private const string OCR_ITEM361 = "60102-02"; //ご飯（男性用茶碗）
        private const string OCR_ITEM362 = "60103-02"; //ご飯（どんぶり茶碗）
        private const string OCR_ITEM363 = "60104-02"; //おにぎり
        private const string OCR_ITEM364 = "60110-02"; //そば・うどん（天ぷら）
        private const string OCR_ITEM365 = "60112-02"; //そば・うどん（たぬき）
        private const string OCR_ITEM366 = "60113-02"; //そば・うどん（ざる・かけ）
        private const string OCR_ITEM367 = "60136-02"; //ラーメン
        private const string OCR_ITEM368 = "60215-02"; //五目ラーメン
        private const string OCR_ITEM369 = "60216-02"; //焼きそば
        private const string OCR_ITEM370 = "60217-02"; //スパゲッティ（クリーム)
        private const string OCR_ITEM371 = "60218-02"; //スパゲッティ（その他)
        private const string OCR_ITEM372 = "60162-02"; //マカロニグラタン
        private const string OCR_ITEM373 = "60105-02"; //食パン６枚切り
        private const string OCR_ITEM374 = "60106-02"; //食パン８枚切り
        private const string OCR_ITEM375 = "60107-02"; //バター
        private const string OCR_ITEM376 = "60108-02"; //マーガリン
        private const string OCR_ITEM377 = "60109-02"; //ジャム類
        private const string OCR_ITEM378 = "60146-02"; //ミックスサンドイッチ
        private const string OCR_ITEM379 = "60219-02"; //菓子パン
        private const string OCR_ITEM380 = "60220-02"; //調理パン
        private const string OCR_ITEM381 = "60143-02"; //カツ丼
        private const string OCR_ITEM382 = "60145-02"; //親子丼
        private const string OCR_ITEM383 = "60144-02"; //天丼
        private const string OCR_ITEM384 = "60221-02"; //中華丼
        private const string OCR_ITEM385 = "60138-02"; //カレーライス
        private const string OCR_ITEM386 = "60139-02"; //チャーハン・ピラフ
        private const string OCR_ITEM387 = "60140-02"; //にぎり・ちらし寿司
        private const string OCR_ITEM388 = "60142-02"; //幕の内弁当
        private const string OCR_ITEM389 = "60114-02"; //シリアル等
        private const string OCR_ITEM390 = "60209-02"; //ミックスピザ
        private const string OCR_ITEM391 = "60222-02"; //刺身盛り合わせ
        private const string OCR_ITEM392 = "60223-02"; //煮魚・焼魚（ぶり、さんま、いわし等）
        private const string OCR_ITEM393 = "60224-02"; //煮魚・焼魚（かれい、たら、ひらめ等）
        private const string OCR_ITEM394 = "60210-02"; //魚のムニエル
        private const string OCR_ITEM395 = "60163-02"; //エビチリ
        private const string OCR_ITEM396 = "60225-02"; //八宝菜
        private const string OCR_ITEM397 = "60226-02"; //ステーキ(150g)
        private const string OCR_ITEM398 = "60156-02"; //焼き肉
        private const string OCR_ITEM399 = "60166-02"; //とりの唐揚
        private const string OCR_ITEM400 = "60157-02"; //ハンバーグ
        private const string OCR_ITEM401 = "60161-02"; //シチュー
        private const string OCR_ITEM402 = "60238-02"; //肉野菜炒め
        private const string OCR_ITEM403 = "60165-02"; //餃子・シュウマイ
        private const string OCR_ITEM404 = "60227-02"; //ハム・ウィンナー
        private const string OCR_ITEM405 = "60228-02"; //ベーコン
        private const string OCR_ITEM406 = "60211-02"; //フライ（コロッケ）
        private const string OCR_ITEM407 = "60169-02"; //フライ（トンカツ）
        private const string OCR_ITEM408 = "60170-02"; //フライ（えび）
        private const string OCR_ITEM409 = "60155-02"; //天ぷら
        private const string OCR_ITEM410 = "60229-02"; //すき焼き・しゃぶしゃぶ等
        private const string OCR_ITEM411 = "60141-02"; //寄鍋・たらちり等
        private const string OCR_ITEM412 = "60212-02"; //おでん
        private const string OCR_ITEM413 = "60117-02"; //生卵・ゆで卵
        private const string OCR_ITEM414 = "60119-02"; //目玉焼き
        private const string OCR_ITEM415 = "60120-02"; //卵焼き
        private const string OCR_ITEM416 = "60118-02"; //スクランブル
        private const string OCR_ITEM417 = "60164-02"; //かに玉
        private const string OCR_ITEM418 = "60160-02"; //冷・湯豆腐
        private const string OCR_ITEM419 = "60115-02"; //納豆
        private const string OCR_ITEM420 = "60230-02"; //マーボ豆腐
        private const string OCR_ITEM421 = "60231-02"; //五目豆
        private const string OCR_ITEM422 = "60131-02"; //野菜サラダ
        private const string OCR_ITEM423 = "60232-02"; //ノンオイルドレッシング
        private const string OCR_ITEM424 = "60233-02"; //マヨネーズ
        private const string OCR_ITEM425 = "60234-02"; //ドレッシング
        private const string OCR_ITEM426 = "60235-02"; //塩
        private const string OCR_ITEM427 = "60176-02"; //ポテト・マカロニサラダ
        private const string OCR_ITEM428 = "60178-02"; //煮物（芋入り）
        private const string OCR_ITEM429 = "60177-02"; //煮物（野菜のみ）
        private const string OCR_ITEM430 = "60237-02"; //煮物（ひじき・昆布等）
        private const string OCR_ITEM431 = "60213-02"; //肉じゃが
        private const string OCR_ITEM432 = "60179-02"; //野菜炒め（肉なし）
        private const string OCR_ITEM433 = "60126-02"; //おひたし
        private const string OCR_ITEM434 = "60175-02"; //酢の物
        private const string OCR_ITEM435 = "60132-02"; //味噌汁
        private const string OCR_ITEM436 = "60133-02"; //コンソメ
        private const string OCR_ITEM437 = "60134-02"; //ポタージュ
        private const string OCR_ITEM438 = "60121-02"; //チーズ
        private const string OCR_ITEM439 = "60188-02"; //枝豆
        private const string OCR_ITEM440 = "60135-02"; //果物
        private const string OCR_ITEM441 = "60240-02"; //お漬物
        private const string OCR_ITEM442 = "61260-00"; //毎日食べていますか
        private const string OCR_ITEM443 = "60101-03"; //ご飯（女性用茶碗）
        private const string OCR_ITEM444 = "60102-03"; //ご飯（男性用茶碗）
        private const string OCR_ITEM445 = "60103-03"; //ご飯（どんぶり茶碗）
        private const string OCR_ITEM446 = "60104-03"; //おにぎり
        private const string OCR_ITEM447 = "60110-03"; //そば・うどん（天ぷら）
        private const string OCR_ITEM448 = "60112-03"; //そば・うどん（たぬき）
        private const string OCR_ITEM449 = "60113-03"; //そば・うどん（ざる・かけ）
        private const string OCR_ITEM450 = "60136-03"; //ラーメン
        private const string OCR_ITEM451 = "60215-03"; //五目ラーメン
        private const string OCR_ITEM452 = "60216-03"; //焼きそば
        private const string OCR_ITEM453 = "60217-03"; //スパゲッティ（クリーム)
        private const string OCR_ITEM454 = "60218-03"; //スパゲッティ（その他)
        private const string OCR_ITEM455 = "60162-03"; //マカロニグラタン
        private const string OCR_ITEM456 = "60105-03"; //食パン６枚切り
        private const string OCR_ITEM457 = "60106-03"; //食パン８枚切り
        private const string OCR_ITEM458 = "60107-03"; //バター
        private const string OCR_ITEM459 = "60108-03"; //マーガリン
        private const string OCR_ITEM460 = "60109-03"; //ジャム類
        private const string OCR_ITEM461 = "60146-03"; //ミックスサンドイッチ
        private const string OCR_ITEM462 = "60219-03"; //菓子パン
        private const string OCR_ITEM463 = "60220-03"; //調理パン
        private const string OCR_ITEM464 = "60143-03"; //カツ丼
        private const string OCR_ITEM465 = "60145-03"; //親子丼
        private const string OCR_ITEM466 = "60144-03"; //天丼
        private const string OCR_ITEM467 = "60221-03"; //中華丼
        private const string OCR_ITEM468 = "60138-03"; //カレーライス
        private const string OCR_ITEM469 = "60139-03"; //チャーハン・ピラフ
        private const string OCR_ITEM470 = "60140-03"; //にぎり・ちらし寿司
        private const string OCR_ITEM471 = "60142-03"; //幕の内弁当
        private const string OCR_ITEM472 = "60114-03"; //シリアル等
        private const string OCR_ITEM473 = "60209-03"; //ミックスピザ
        private const string OCR_ITEM474 = "60222-03"; //刺身盛り合わせ
        private const string OCR_ITEM475 = "60223-03"; //煮魚・焼魚（ぶり、さんま、いわし等）
        private const string OCR_ITEM476 = "60224-03"; //煮魚・焼魚（かれい、たら、ひらめ等）
        private const string OCR_ITEM477 = "60210-03"; //魚のムニエル
        private const string OCR_ITEM478 = "60163-03"; //エビチリ
        private const string OCR_ITEM479 = "60225-03"; //八宝菜
        private const string OCR_ITEM480 = "60226-03"; //ステーキ(150g)
        private const string OCR_ITEM481 = "60156-03"; //焼き肉
        private const string OCR_ITEM482 = "60166-03"; //とりの唐揚
        private const string OCR_ITEM483 = "60157-03"; //ハンバーグ
        private const string OCR_ITEM484 = "60161-03"; //シチュー
        private const string OCR_ITEM485 = "60238-03"; //肉野菜炒め
        private const string OCR_ITEM486 = "60165-03"; //餃子・シュウマイ
        private const string OCR_ITEM487 = "60227-03"; //ハム・ウィンナー
        private const string OCR_ITEM488 = "60228-03"; //ベーコン
        private const string OCR_ITEM489 = "60211-03"; //フライ（コロッケ）
        private const string OCR_ITEM490 = "60169-03"; //フライ（トンカツ）
        private const string OCR_ITEM491 = "60170-03"; //フライ（えび）
        private const string OCR_ITEM492 = "60155-03"; //天ぷら
        private const string OCR_ITEM493 = "60229-03"; //すき焼き・しゃぶしゃぶ等
        private const string OCR_ITEM494 = "60141-03"; //寄鍋・たらちり等
        private const string OCR_ITEM495 = "60212-03"; //おでん
        private const string OCR_ITEM496 = "60117-03"; //生卵・ゆで卵
        private const string OCR_ITEM497 = "60119-03"; //目玉焼き
        private const string OCR_ITEM498 = "60120-03"; //卵焼き
        private const string OCR_ITEM499 = "60118-03"; //スクランブル
        private const string OCR_ITEM500 = "60164-03"; //かに玉
        private const string OCR_ITEM501 = "60160-03"; //冷・湯豆腐
        private const string OCR_ITEM502 = "60115-03"; //納豆
        private const string OCR_ITEM503 = "60230-03"; //マーボ豆腐
        private const string OCR_ITEM504 = "60231-03"; //五目豆
        private const string OCR_ITEM505 = "60131-03"; //野菜サラダ
        private const string OCR_ITEM506 = "60232-03"; //ノンオイルドレッシング
        private const string OCR_ITEM507 = "60233-03"; //マヨネーズ
        private const string OCR_ITEM508 = "60234-03"; //ドレッシング
        private const string OCR_ITEM509 = "60235-03"; //塩
        private const string OCR_ITEM510 = "60176-03"; //ポテト・マカロニサラダ
        private const string OCR_ITEM511 = "60178-03"; //煮物（芋入り）
        private const string OCR_ITEM512 = "60177-03"; //煮物（野菜のみ）
        private const string OCR_ITEM513 = "60237-03"; //煮物（ひじき・昆布等）
        private const string OCR_ITEM514 = "60213-03"; //肉じゃが
        private const string OCR_ITEM515 = "60179-03"; //野菜炒め（肉なし）
        private const string OCR_ITEM516 = "60126-03"; //おひたし
        private const string OCR_ITEM517 = "60175-03"; //酢の物
        private const string OCR_ITEM518 = "60132-03"; //味噌汁
        private const string OCR_ITEM519 = "60133-03"; //コンソメ
        private const string OCR_ITEM520 = "60134-03"; //ポタージュ
        private const string OCR_ITEM521 = "60121-03"; //チーズ
        private const string OCR_ITEM522 = "60188-03"; //枝豆
        private const string OCR_ITEM523 = "60135-03"; //果物
        private const string OCR_ITEM524 = "60240-03"; //お漬物
        private const string OCR_ITEM525 = "68010-00"; //生活習慣改善意志
        private const string OCR_ITEM526 = "68020-00"; //保健指導利用

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
            DateTime? editOcrDate = null;                  // OCR内容確認修正日時
            int ocrCheck;                                  // OCRチェック（0:OCR未チェック、1:OCRチェック済）
            string sql;
            string UniqueKey = "";                         // コレクションの対象キー

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
                mcolOcrNyuryoku = new Dictionary<string, RslOcrSp>();

                int index = 0;

                foreach (dynamic rec in dataResult)
                {

                    RslOcrSp rslOcrSp = new RslOcrSp
                    {
                        UniqueKey = rec.ITEMCD + "-" + rec.SUFFIX,
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
                    UniqueKey = rec.ITEMCD + "-" + rec.SUFFIX;
                    mcolOcrNyuryoku.Add(UniqueKey, rslOcrSp);
                }

                // ＯＣＲ入力結果の入力チェック
                errCount = CheckRslOcr(rsvNo, ref arrErrNo, ref arrErrState, ref arrErrMsg);

                // 入力チェックのときに修正された検査結果を戻す
                foreach (dynamic rec in dataResult)
                {
                    UniqueKey = rec.ITEMCD + "-" + rec.SUFFIX;

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
            string UniqueKey = "";                         // コレクションの対象キー

            // ＯＣＲ入力結果を取得する
            List<dynamic> dataResult = SelectRslOcr(rsvNo, grpCd, lastDspMode, csGrp, 1);

            while (true)
            {
                if (dataResult.Count == 0)
                {
                    break;
                }

                mcolOcrNyuryoku = new Dictionary<string, RslOcrSp>();

                int index = 0;

                foreach (dynamic rec in dataResult)
                {

                    RslOcrSp rslOcrSp = new RslOcrSp
                    {
                        UniqueKey = rec.ITEMCD + "-" + rec.SUFFIX,
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
                    UniqueKey = rec.ITEMCD + "-" + rec.SUFFIX;
                    mcolOcrNyuryoku.Add(UniqueKey, rslOcrSp);
                }

                // 渡された検査結果と検査中止フラグをセット
                for (int i1 = 0; i1 < result.Count; i1++)
                {
                    UniqueKey = itemCd[i1] + "-" + suffix[i1];

                    if (!"-".Equals(UniqueKey))
                    {
                        mcolOcrNyuryoku[UniqueKey].Result = result[i1];
                        mcolOcrNyuryoku[UniqueKey].StopFlg = stopFlg[i1];
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
                    if (Convert.ToInt32(mcolOcrNyuryoku[OCR_ITEM151].Index) <= i2
                        && Convert.ToInt32(mcolOcrNyuryoku[OCR_ITEM161].Index) >= i2)
                    {
                        mcolOcrNyuryoku[key].StopFlg = "1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM150].Result)) ? "S" : "";
                    }

                    // ストレス・コーピングテストの未回答
                    if (Convert.ToInt32(mcolOcrNyuryoku[OCR_ITEM163].Index) <= i2
                        && Convert.ToInt32(mcolOcrNyuryoku[OCR_ITEM174].Index) >= i2)
                    {
                        mcolOcrNyuryoku[key].StopFlg = "1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM162].Result)) ? "S" : "";
                    }

                    // 食習慣問診の未回答
                    if (Convert.ToInt32(mcolOcrNyuryoku[OCR_ITEM241].Index) <= i2
                        && Convert.ToInt32(mcolOcrNyuryoku[OCR_ITEM524].Index) >= i2)
                    {
                        mcolOcrNyuryoku[key].StopFlg = "1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM240].Result)) ? "S" : "";
                    }

                    i2 = i2 + 1;
                }

                // 入力チェックのときに修正された検査結果を戻す
                for (int i3 = 0; i3 < itemCd.Count; i3++)
                {
                    UniqueKey = itemCd[i3] + "-" + suffix[i3];

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
            List<string> objMessage1 = new List<string>();

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
            if (stopFlg == null)
            {

                using (var cmd = new OracleCommand())
                {

                    // キー値及び更新値の設定
                    cmd.Parameters.Add("rsvno", OracleDbType.Long, rsvNo, ParameterDirection.Input);
                    cmd.Parameters.Add("ipaddress", OracleDbType.Varchar2, ipAddress, ParameterDirection.Input);
                    cmd.Parameters.Add("upduser", OracleDbType.Varchar2, updUser, ParameterDirection.Input);

                    OracleParameter objItemCd = cmd.Parameters.AddTable("itemcd", itemCd.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_ITEM_P_ITEMCD);
                    OracleParameter objSuffix = cmd.Parameters.AddTable("suffix", suffix.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_ITEM_C_SUFFIX);
                    OracleParameter objResult = cmd.Parameters.AddTable("result", arrResult.ToArray(), ParameterDirection.InputOutput, OracleDbType.Varchar2, arraySize, 400);
                    OracleParameter objRslCmtCd1 = cmd.Parameters.AddTable("rslcmtcd1", arrRslCmtCd1.ToArray(), ParameterDirection.InputOutput, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTCD);
                    OracleParameter objRslCmtCd2 = cmd.Parameters.AddTable("rslcmtcd2", arrRslCmtCd2.ToArray(), ParameterDirection.InputOutput, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTCD);
                    OracleParameter objMessage = cmd.Parameters.AddTable("message", ParameterDirection.Output, OracleDbType.Varchar2, 100, 256);
                    OracleParameter objRet = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                    // SQL定義
                    string sql = @"
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

                    ExecuteNonQuery(cmd, sql);

                    ret2 = Convert.ToInt32((OracleDecimal)objRet.Value);

                    // 戻り値の設定(エラーに関わらず戻す値)
                    itemCd = ((OracleString[])objItemCd.Value).Select(s => s.Value).ToList();
                    suffix = ((OracleString[])objSuffix.Value).Select(s => s.Value).ToList();
                    result = ((OracleString[])objResult.Value).Select(s => s.Value).ToList();
                    rslCmtCd1 = ((OracleString[])objRslCmtCd1.Value).Select(s => s.Value).ToList();
                    rslCmtCd2 = ((OracleString[])objRslCmtCd2.Value).Select(s => s.Value).ToList();

                    objMessage1 = ((OracleString[])objMessage.Value).Select(s => s.Value).ToList();

                }
            }
            // 検査中止フラグ指定時
            else
            {
                using (var cmd = new OracleCommand())
                {
                    // キー値及び更新値の設定
                    cmd.Parameters.Add("rsvno", OracleDbType.Date, rsvNo, ParameterDirection.Input);
                    cmd.Parameters.Add("ipaddress", OracleDbType.Date, ipAddress, ParameterDirection.Input);
                    cmd.Parameters.Add("upduser", OracleDbType.Date, updUser, ParameterDirection.Input);
                    cmd.Parameters.Add("updresult", OracleDbType.Date, result.Count > 0 ? 0 : 1, ParameterDirection.Input);
                    cmd.Parameters.Add("updrslcmt1", OracleDbType.Date, rslCmtCd1.Count > 0 ? 0 : 1, ParameterDirection.Input);
                    cmd.Parameters.Add("updrslcmt2", OracleDbType.Date, rslCmtCd2.Count > 0 ? 0 : 1, ParameterDirection.Input);
                    cmd.Parameters.Add("skipnorec", OracleDbType.Date, skipNoRec ? 1 : 0, ParameterDirection.Input);

                    OracleParameter objItemCd = cmd.Parameters.AddTable("itemcd", itemCd.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_ITEM_P_ITEMCD);
                    OracleParameter objSuffix = cmd.Parameters.AddTable("suffix", suffix.ToArray(), ParameterDirection.Input, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_ITEM_C_SUFFIX);
                    OracleParameter objResult = cmd.Parameters.AddTable("result", arrResult.ToArray(), ParameterDirection.InputOutput, OracleDbType.Varchar2, arraySize, 400);
                    OracleParameter objRslCmtCd1 = cmd.Parameters.AddTable("rslcmtcd1", arrRslCmtCd1.ToArray(), ParameterDirection.InputOutput, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTCD);
                    OracleParameter objRslCmtCd2 = cmd.Parameters.AddTable("rslcmtcd2", arrRslCmtCd2.ToArray(), ParameterDirection.InputOutput, OracleDbType.Varchar2, arraySize, (int)LengthConstants.LENGTH_RSLCMT_RSLCMTCD);
                    OracleParameter objStopflg = cmd.Parameters.AddTable("stopflg", arrStopFlg.ToArray(), ParameterDirection.InputOutput, OracleDbType.Varchar2, arraySize, 1);
                    OracleParameter objMessage = cmd.Parameters.AddTable("message", ParameterDirection.Output, OracleDbType.Varchar2, 100, 256);
                    OracleParameter objRet = cmd.Parameters.Add("ret", OracleDbType.Int32, ParameterDirection.Output);

                    // 検査中止フラグ付き結果更新ストアド呼び出し
                    string sql = @"
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

                    ExecuteNonQuery(cmd, sql);

                    ret2 = ((OracleDecimal)objRet.Value).ToInt32();

                    objMessage1 = ((OracleString[])objMessage.Value).Select(s => s.Value).ToList();
                }
            }

            bool ret = true;

            // チェックエラー時
            if (ret2 <= 0)
            {
                if (message != null)
                {
                    // バインド配列内容を検索し、メッセージを取得
                    while (true)
                    {
                        if (msgCount >= objMessage1.Count)
                        {
                            break;
                        }

                        if (string.IsNullOrEmpty(Convert.ToString(objMessage1[msgCount])))
                        {
                            break;
                        }

                        arrMessage.Add(objMessage1[msgCount]);
                        msgCount = msgCount + 1;
                    }

                    message = arrMessage;
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

                ret2 = connection.Execute(sql, param);

                if (ret2 < 0)
                {
                    ret = false;
                }
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

            if (!string.IsNullOrEmpty(lstRslCmtName1))
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
            string perId;        // 個人ID
            DateTime cslDate;    // 受診日
            int itemCnt;         // 検査項目数
            string uniqueKey;    // コレクションの対象キー
            string gender = "";  // 性別

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

            // 単体の入力チェック
            itemCnt = 0;
            foreach (string key in mcolOcrNyuryoku.Keys)
            {
                ResultWithStatus resultWithStatus = new ResultWithStatus();
                resultWithStatus.ItemCd = mcolOcrNyuryoku[key].ItemCd;
                resultWithStatus.Suffix = mcolOcrNyuryoku[key].Suffix;
                resultWithStatus.Result = mcolOcrNyuryoku[key].Result;

                results.Add(resultWithStatus);

                itemCnt = itemCnt + 1;
            }

            // 検査結果入力チェック           
            resultDao.CheckResult(cslDate, ref results);
            for (int i = 0; i < itemCnt; i++)
            {
                // エラーあり？
                if (!string.IsNullOrEmpty(results[i].ResultError))
                {
                    uniqueKey = results[i].ItemCd + "-" + results[i].Suffix;
                    EditOcrError(uniqueKey, OCR_ERRSTAT_ERROR, results[i].ResultError, Convert.ToString(mcolOcrNyuryoku[uniqueKey].ItemName));
                }
            }

            // 現病歴・既往歴問診票
            // 胃Ｘ線の依頼があるときだけ入力チェック
            if (stomachFlg)
            {
                // 未記入の場合a
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM001].Result)))
                {
                    EditOcrError(OCR_ITEM001, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM001].ItemName));
                }
            }

            // 現病歴
            string[] arrItem1 = new string[] { OCR_ITEM003, OCR_ITEM006, OCR_ITEM009, OCR_ITEM012, OCR_ITEM015, OCR_ITEM018 };
            string[] arrItem2 = new string[] { OCR_ITEM004, OCR_ITEM007, OCR_ITEM010, OCR_ITEM013, OCR_ITEM016, OCR_ITEM019 };
            string[] arrItem3 = new string[] { OCR_ITEM005, OCR_ITEM008, OCR_ITEM011, OCR_ITEM014, OCR_ITEM017, OCR_ITEM020 };

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
            string[] arrItem1_1 = new string[] { OCR_ITEM021, OCR_ITEM024, OCR_ITEM027, OCR_ITEM030, OCR_ITEM033, OCR_ITEM036 };
            string[] arrItem2_1 = new string[] { OCR_ITEM022, OCR_ITEM025, OCR_ITEM028, OCR_ITEM031, OCR_ITEM034, OCR_ITEM037 };
            string[] arrItem3_1 = new string[] { OCR_ITEM023, OCR_ITEM026, OCR_ITEM029, OCR_ITEM032, OCR_ITEM035, OCR_ITEM038 };

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
            string[] arrItem1_2 = new string[] { OCR_ITEM039, OCR_ITEM042, OCR_ITEM045, OCR_ITEM048, OCR_ITEM051, OCR_ITEM054 };
            string[] arrItem2_2 = new string[] { OCR_ITEM040, OCR_ITEM043, OCR_ITEM046, OCR_ITEM049, OCR_ITEM052, OCR_ITEM055 };
            string[] arrItem3_2 = new string[] { OCR_ITEM041, OCR_ITEM044, OCR_ITEM047, OCR_ITEM050, OCR_ITEM053, OCR_ITEM056 };

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
            if ("1".Equals(gender) && !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM058].Result)))
            {
                EditOcrError(OCR_ITEM058, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_006, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM058].ItemName), "男性");
            }

            // 生活習慣病問診票（１）
            // 体重変化値
            // 未記入の場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM087].Result)))
            {
                EditOcrError(OCR_ITEM087, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM087].ItemName));
            }

            // 直近体重変動
            // 未記入の場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM088].Result)))
            {
                EditOcrError(OCR_ITEM088, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM088].ItemName));
            }

            // 飲酒１（飲酒習慣）
            // 未記入の場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM089].Result)))
            {
                // 「回数」に記入がない場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM090].Result)))
                {
                    EditOcrError(OCR_ITEM089, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM089].ItemName), "飲まない");
                    mcolOcrNyuryoku[OCR_ITEM089].Result = "3"; // 「飲まない」を登録
                }
                else
                {
                    EditOcrError(OCR_ITEM089, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM089].ItemName), "習慣的に飲む");
                    mcolOcrNyuryoku[OCR_ITEM089].Result = "1"; // 「習慣的に飲む」を登録
                }
            }

            // 「習慣的に飲む」に記入があり、「回数」に記入がない場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM090].Result)) && "1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM089].Result)))
            {
                EditOcrError(OCR_ITEM090, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM090].ItemName));
            }

            // 「ときどき飲む」に記入があり、「回数」に記入がない場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM090].Result)) && "2".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM089].Result)))
            {
                EditOcrError(OCR_ITEM090, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM090].ItemName));
            }

            // 「飲まない」に記入があり、「回数」に記入がある場合
            if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM090].Result)) && "3".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM089].Result)))
            {
                EditOcrError(OCR_ITEM090, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_005, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM090].ItemName));
            }

            // 「習慣的に飲む」に記入があり、飲酒量（「ビール大瓶」～「その他」）に記入がない場合
            if ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM089].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM091].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM092].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM093].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM094].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM095].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM096].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM097].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM098].Result)))
            {
                EditOcrError(OCR_ITEM089, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_101, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM089].ItemName));
            }

            // 「ときどき飲む」と「回数」に記入があり、飲酒量（「ビール大瓶」～「その他」）に記入がない場合
            if ("2".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM089].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM091].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM092].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM093].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM094].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM095].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM096].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM097].Result))
                && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM098].Result)))
            {
                EditOcrError(OCR_ITEM089, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_102, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM089].ItemName));
            }

            // 喫煙
            // 未記入の場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM099].Result)))
            {
                EditOcrError(OCR_ITEM099, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM099].ItemName), "吸わない");
                mcolOcrNyuryoku[OCR_ITEM089].Result = "2"; // 「吸わない」を登録
            }

            // 喫煙開始年齢
            // 「吸わない」が記入されているのに年齢が記入されている場合
            if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM100].Result)) && "2".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM099].Result)))
            {
                EditOcrError(OCR_ITEM100, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_005, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM100].ItemName));
            }

            // 「吸っている」「過去に吸っていた」に記入があり、「喫煙開始年齢」に記入がない場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM100].Result)) && ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM099].Result))
                || "3".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM099].Result))))
            {
                EditOcrError(OCR_ITEM100, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM100].ItemName));
            }

            // 喫煙終了年齢
            // 「吸わない」が記入されているのに年齢が記入されている場合
            if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM101].Result)) && "2".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM099].Result)))
            {
                EditOcrError(OCR_ITEM101, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_005, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM101].ItemName));
            }

            // 「過去に吸っていた」に記入があり、「喫煙終了年齢」に記入がない場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM101].Result)) && "3".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM099].Result)))
            {
                EditOcrError(OCR_ITEM101, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM101].ItemName));
            }

            // 現在喫煙本数
            // 「吸わない」が記入されているのに喫煙本数が記入されている場合
            if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM102].Result)) && "2".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM099].Result)))
            {
                EditOcrError(OCR_ITEM102, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_005, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM102].ItemName));
            }

            // 「吸っている」「過去に吸っていた」に記入があり、「喫煙本数」に記入がない場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM102].Result)) && ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM099].Result))
                || "3".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM099].Result))))
            {
                EditOcrError(OCR_ITEM102, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM102].ItemName));
            }

            // 身体行動
            // 未記入の場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM105].Result)))
            {
                EditOcrError(OCR_ITEM105, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM105].ItemName), "普通に動いている");
                mcolOcrNyuryoku[OCR_ITEM105].Result = "2"; // 「普通に動いている」を登録
            }

            // 軽い運動
            // 未記入の場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM106].Result)))
            {
                EditOcrError(OCR_ITEM106, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM106].ItemName), "週1～2日以内");
                mcolOcrNyuryoku[OCR_ITEM106].Result = "3"; // 「週1～2日以内」を登録
            }

            // 自覚症状
            string[] arrItem1_3 = new string[] { OCR_ITEM126, OCR_ITEM130, OCR_ITEM134, OCR_ITEM138, OCR_ITEM142, OCR_ITEM146 };
            string[] arrItem2_3 = new string[] { OCR_ITEM127, OCR_ITEM131, OCR_ITEM135, OCR_ITEM139, OCR_ITEM143, OCR_ITEM147 };
            string[] arrItem3_3 = new string[] { OCR_ITEM128, OCR_ITEM132, OCR_ITEM136, OCR_ITEM140, OCR_ITEM144, OCR_ITEM148 };
            string[] arrItem4_3 = new string[] { OCR_ITEM129, OCR_ITEM133, OCR_ITEM137, OCR_ITEM141, OCR_ITEM145, OCR_ITEM149 };

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
            if (!"1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM150].Result)))
            {
                // Ａ型行動パターン・テスト
                string[] arrItem01 = new string[] { OCR_ITEM151, OCR_ITEM152, OCR_ITEM153, OCR_ITEM154, OCR_ITEM155, OCR_ITEM156, OCR_ITEM157, OCR_ITEM158, OCR_ITEM159, OCR_ITEM160, OCR_ITEM161 };
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
            if (!"1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM162].Result)))
            {
                // ストレス・コーピングテスト
                string[] arrItem03 = new string[] { OCR_ITEM163, OCR_ITEM164, OCR_ITEM165, OCR_ITEM166, OCR_ITEM167, OCR_ITEM168, OCR_ITEM170, OCR_ITEM171, OCR_ITEM172, OCR_ITEM173, OCR_ITEM174 };

                for (int i = 0; i < arrItem03.Length; i++)
                {
                    // 未記入の場合
                    if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem03[i]].Result)))
                    {
                        EditOcrError(arrItem03[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[arrItem03[i]].ItemName), "全くしない");
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
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM175].Result)))
                {
                    EditOcrError(OCR_ITEM175, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM175].ItemName));
                }

                // 検診を受けた施設は
                // 子宮がん検診経験ありで、施設が未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM176].Result))
                    && Convert.ToInt32(mcolOcrNyuryoku[OCR_ITEM175].Result) >= 1
                    && Convert.ToInt32(mcolOcrNyuryoku[OCR_ITEM175].Result) <= 4)
                {
                    EditOcrError(OCR_ITEM176, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM176].ItemName));
                }

                // 検診の結果は
                // 子宮がん検診経験ありで、検診結果が未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM177].Result))
                    && Convert.ToInt32(mcolOcrNyuryoku[OCR_ITEM175].Result) >= 1
                    && Convert.ToInt32(mcolOcrNyuryoku[OCR_ITEM175].Result) <= 4)
                {
                    EditOcrError(OCR_ITEM176, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM177].ItemName));
                }

                // 婦人科病気経験ない
                // すべての項目が未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM178].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM179].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM180].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM181].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM182].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM183].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM184].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM185].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM186].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM187].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM188].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM189].Result)))
                {
                    EditOcrError(OCR_ITEM178, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM178].ItemName), "ない");
                    mcolOcrNyuryoku[OCR_ITEM178].Result = "1"; // 「ない」を登録
                }

                // 「ない」と重複回答の場合
                if ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM178].Result)))
                {
                    // ストレス・コーピングテスト
                    string[] arrItem04 = new string[] { OCR_ITEM179, OCR_ITEM180, OCR_ITEM181, OCR_ITEM182, OCR_ITEM183, OCR_ITEM184, OCR_ITEM185, OCR_ITEM186, OCR_ITEM187, OCR_ITEM188, OCR_ITEM189 };

                    for (int i = 0; i < arrItem04.Length; i++)
                    {
                        // 未記入の場合
                        if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem04[i]].Result)))
                        {
                            EditOcrError(arrItem04[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_008, Convert.ToString(mcolOcrNyuryoku[arrItem04[i]].ItemName));
                        }
                    }
                }

                // ホルモン治療を受けたことがある
                // ホルモン治療が未記入で「ﾎﾙﾓﾝ療法、何歳から」～「ﾎﾙﾓﾝ療法、何年間」が未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM190].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM191].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM192].Result)))
                {
                    EditOcrError(OCR_ITEM190, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM190].ItemName), "ない");
                    mcolOcrNyuryoku[OCR_ITEM190].Result = "1"; // 「ない」を登録
                }

                // ﾎﾙﾓﾝ療法、何歳から
                // 「ある」に記入し、年齢未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM191].Result))
                    && "2".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM190].Result)))
                {
                    EditOcrError(OCR_ITEM191, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM191].ItemName));
                }

                // ﾎﾙﾓﾝ療法、何年間
                // 「ある」に記入し、期間未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM192].Result))
                    && "2".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM190].Result)))
                {
                    EditOcrError(OCR_ITEM192, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM192].ItemName));
                }

                // 婦人科手術経験
                // すべての項目が未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM193].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM194].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM195].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM196].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM197].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM198].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM199].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM200].Result)))
                {
                    EditOcrError(OCR_ITEM193, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM193].ItemName), "ない");
                    mcolOcrNyuryoku[OCR_ITEM193].Result = "1"; // 「ない」を登録
                }

                // 「ある」に記入があり、各項目が未記入の場合
                if ("2".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM193].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM194].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM195].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM196].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM197].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM198].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM199].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM200].Result)))
                {
                    EditOcrError(OCR_ITEM193, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM193].ItemName));
                }

                // 「ない」と重複回答の場合
                if ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM193].Result)))
                {
                    // ストレス・コーピングテスト
                    string[] arrItem05 = new string[] { OCR_ITEM194, OCR_ITEM195, OCR_ITEM196, OCR_ITEM197, OCR_ITEM198, OCR_ITEM199, OCR_ITEM200 };

                    for (int i = 0; i < arrItem05.Length; i++)
                    {
                        // 未記入の場合
                        if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem05[i]].Result)))
                        {
                            EditOcrError(arrItem05[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_008, Convert.ToString(mcolOcrNyuryoku[arrItem05[i]].ItemName));
                        }
                    }
                }

                // 妊娠回数
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM201].Result)))
                {
                    EditOcrError(OCR_ITEM201, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM201].ItemName));
                }

                // 出産回数
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM202].Result)))
                {
                    EditOcrError(OCR_ITEM202, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM202].ItemName));
                }

                // 閉経
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM205].Result)))
                {
                    EditOcrError(OCR_ITEM205, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM205].ItemName));
                }

                // 閉経「いいえ」に記入
                if ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM205].Result)))
                {
                    // 11-1．最終月経 ～ 11-6．月経時、下腹部や腰部に痛み
                    string[] arrItem06 = new string[] { OCR_ITEM207, OCR_ITEM208, OCR_ITEM209, OCR_ITEM210, OCR_ITEM211, OCR_ITEM212, OCR_ITEM213, OCR_ITEM214, OCR_ITEM215, OCR_ITEM216, OCR_ITEM221, OCR_ITEM222 };

                    for (int i = 0; i < arrItem06.Length; i++)
                    {
                        // 未記入の場合
                        if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem06[i]].Result)))
                        {
                            EditOcrError(arrItem06[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[arrItem06[i]].ItemName));
                        }
                    }

                    // 11 - 3．月経周期(日か不規則のいづれか入力)
                    // 未記入の場合
                    if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM217].Result))
                        && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM218].Result)))
                    {
                        EditOcrError(OCR_ITEM217, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM217].ItemName));
                    }

                    // 11-4．月経期間(日か不規則のいづれか入力)
                    // 未記入の場合
                    if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM219].Result))
                        && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM220].Result)))
                    {
                        EditOcrError(OCR_ITEM219, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM219].ItemName));
                    }
                }

                // 月経以外に出血したことがある
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM223].Result)))
                {
                    EditOcrError(OCR_ITEM223, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM223].ItemName), "ない");
                    mcolOcrNyuryoku[OCR_ITEM223].Result = "1"; // 「ない」を登録
                }

                // 気掛り症状ない
                // すべての項目が未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM224].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM225].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM226].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM227].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM228].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM229].Result)))
                {
                    EditOcrError(OCR_ITEM224, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM224].ItemName), "ない");
                    mcolOcrNyuryoku[OCR_ITEM224].Result = "1"; // 「ない」を登録
                }

                // 「ない」と重複回答の場合
                if ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM224].Result)))
                {
                    string[] arrItem07 = new string[] { OCR_ITEM225, OCR_ITEM226, OCR_ITEM227, OCR_ITEM228, OCR_ITEM229 };

                    for (int i = 0; i < arrItem07.Length; i++)
                    {
                        // 未記入の場合
                        if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem07[i]].Result)))
                        {
                            EditOcrError(arrItem07[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_008, Convert.ToString(mcolOcrNyuryoku[arrItem07[i]].ItemName));
                        }
                    }
                }

                // 家族で婦人科系がんいない
                // 「家族で婦人科系がん実母」～「その他」の項目が未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM231].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM232].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM233].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM234].Result)))
                {
                    EditOcrError(OCR_ITEM231, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM231].ItemName), "いない");
                    mcolOcrNyuryoku[OCR_ITEM231].Result = "1"; // 「いない」を登録
                }

                // 「いない」と重複回答の場合
                if ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM231].Result)))
                {
                    string[] arrItem08 = new string[] { OCR_ITEM232, OCR_ITEM233, OCR_ITEM234 };

                    for (int i = 0; i < arrItem08.Length; i++)
                    {
                        // 未記入の場合
                        if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem08[i]].Result)))
                        {
                            EditOcrError(arrItem08[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_009, Convert.ToString(mcolOcrNyuryoku[arrItem08[i]].ItemName));
                        }
                    }
                }

                // 「家族で婦人科系がん実母」～「その他」に記入があり、がんの記入がない
                if ((!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM232].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM233].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM234].Result)))
                    && (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM235].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM236].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM237].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM238].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM239].Result))))
                {
                    EditOcrError(OCR_ITEM232, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_010, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM232].ItemName));
                }

                // 「いない」と重複回答の場合
                if ("1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM231].Result)))
                {
                    string[] arrItem09 = new string[] { OCR_ITEM235, OCR_ITEM236, OCR_ITEM237, OCR_ITEM238, OCR_ITEM239 };

                    for (int i = 0; i < arrItem09.Length; i++)
                    {
                        if (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem09[i]].Result)))
                        {
                            EditOcrError(arrItem09[i], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_009, Convert.ToString(mcolOcrNyuryoku[arrItem09[i]].ItemName));
                        }
                    }
                }

                // がんに記入があり、「家族で婦人科系がん実母」～「その他」に記入がない。
                if ((!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM235].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM236].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM237].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM238].Result))
                    || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM239].Result)))
                    && (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM232].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM233].Result))
                    && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM234].Result))))
                {
                    EditOcrError(OCR_ITEM235, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_011, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM235].ItemName));
                    mcolOcrNyuryoku[OCR_ITEM231].Result = "1"; // 「いない」を登録
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
                        if (i >= mcolOcrNyuryoku[OCR_ITEM175].Index && i <= mcolOcrNyuryoku[OCR_ITEM239].Index)
                        {
                            mcolOcrNyuryoku[key].Result = ""; // 未記入とする
                        }
                        i = i + 1;
                    }
                }
            }

            // 食習慣問診票
            // 「本人希望により未回答」のときは入力チェックしない
            if (!"1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM240].Result)))
            {
                // カロリー制限有無
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM241].Result))
                   && string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM242].Result)))
                {
                    EditOcrError(OCR_ITEM241, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM241].ItemName), "いいえ");
                    mcolOcrNyuryoku[OCR_ITEM241].Result = "2"; // 「いいえ」を登録
                }

                // 未記入でカロリー制限量の記入がある場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM241].Result))
                   && !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM242].Result)))
                {
                    EditOcrError(OCR_ITEM241, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM241].ItemName), "はい");
                    mcolOcrNyuryoku[OCR_ITEM241].Result = "1"; // 「はい」を登録
                }

                // カロリー制限量
                // カロリー制限有無が「はい」に記入があり、未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM242].Result))
                   && "1".Equals(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM241].Result)))
                {
                    EditOcrError(OCR_ITEM242, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM242].ItemName));
                }

                // 食事の速さ～脂肪分摂取習慣
                string[] arrItem10 = new string[] { OCR_ITEM243, OCR_ITEM244, OCR_ITEM245, OCR_ITEM247, OCR_ITEM248, OCR_ITEM249 };

                for (int j1 = 0; j1 < arrItem10.Length; j1++)
                {
                    // 未記入の場合
                    if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[arrItem10[j1]].Result)))
                    {
                        EditOcrError(arrItem10[j1], OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[arrItem10[j1]].ItemName), "それほどでもない");
                        mcolOcrNyuryoku[arrItem10[j1]].Result = "2"; // 「"それほどでもない"」を登録
                    }
                }

                // 塩分摂取習慣
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM250].Result)))
                {
                    EditOcrError(OCR_ITEM250, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM250].ItemName), "ふつう");
                    mcolOcrNyuryoku[OCR_ITEM250].Result = "2"; // 「"ふつう"」を登録
                }

                // 間食の有無
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM251].Result)))
                {
                    EditOcrError(OCR_ITEM251, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM251].ItemName), "食べない");
                    mcolOcrNyuryoku[OCR_ITEM251].Result = "1"; // 「"食べない"」を登録
                }

                // 減塩醤油使用の有無
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM253].Result)))
                {
                    EditOcrError(OCR_ITEM253, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM253].ItemName), "使っていない");
                    mcolOcrNyuryoku[OCR_ITEM253].Result = "2"; // 「"使っていない"」を登録
                }

                // コーヒー・紅茶～せんべい（あられ）
                int i = 1;
                foreach (string key in mcolOcrNyuryoku.Keys)
                {
                    if (i >= mcolOcrNyuryoku[OCR_ITEM254].Index && i <= mcolOcrNyuryoku[OCR_ITEM271].Index)
                    {
                        // ０記入エラー？
                        if (IsZero(mcolOcrNyuryoku[key].Result))
                        {
                            EditOcrError(mcolOcrNyuryoku[key].UniqueKey, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_007, Convert.ToString(mcolOcrNyuryoku[key].ItemName));
                            mcolOcrNyuryoku[key].Result = ""; // 未記入とする
                        }
                    }
                    i = i + 1;
                }

                // コーヒー・紅茶
                // 未記入で「砂糖」または「ミルク」に記入があるの場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM254].Result))
                    && (!string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM255].Result))
                       || !string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM256].Result))))
                {
                    EditOcrError(OCR_ITEM254, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM254].ItemName), "1.0杯");
                    mcolOcrNyuryoku[OCR_ITEM254].Result = "1.0"; // 「1.0杯」を登録
                }

                // 普通牛乳～低脂肪ヨーグルト
                int i1 = 1;
                foreach (string key in mcolOcrNyuryoku.Keys)
                {
                    if (i1 >= mcolOcrNyuryoku[OCR_ITEM272].Index && i1 <= mcolOcrNyuryoku[OCR_ITEM275].Index)
                    {
                        // ０記入エラー？
                        if (IsZero(mcolOcrNyuryoku[key].Result))
                        {
                            EditOcrError(mcolOcrNyuryoku[key].UniqueKey, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_007, Convert.ToString(mcolOcrNyuryoku[key].ItemName));
                            mcolOcrNyuryoku[key].Result = ""; // 未記入とする
                        }
                    }
                    i1 = i1 + 1;
                }

                // 朝食摂取習慣
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM276].Result)))
                {
                    EditOcrError(OCR_ITEM276, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM276].ItemName), "食べる");
                    mcolOcrNyuryoku[OCR_ITEM276].Result = "1"; // 「食べる」を登録
                }

                // 朝食：ご飯（女性用茶碗）～お漬物
                int i2 = 1;
                foreach (string key in mcolOcrNyuryoku.Keys)
                {
                    if (i2 >= mcolOcrNyuryoku[OCR_ITEM277].Index && i2 <= mcolOcrNyuryoku[OCR_ITEM358].Index)
                    {
                        // ０記入エラー？
                        if (IsZero(mcolOcrNyuryoku[key].Result))
                        {
                            EditOcrError(mcolOcrNyuryoku[key].UniqueKey, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_007, Convert.ToString(mcolOcrNyuryoku[key].ItemName));
                            mcolOcrNyuryoku[key].Result = ""; // 未記入とする
                        }
                    }
                    i2 = i2 + 1;
                }

                // 昼食摂取習慣
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM359].Result)))
                {
                    EditOcrError(OCR_ITEM359, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM359].ItemName), "食べる");
                    mcolOcrNyuryoku[OCR_ITEM359].Result = "1"; // 「食べる」を登録
                }

                // 昼食：ご飯（女性用茶碗）～お漬物
                int i3 = 1;
                foreach (string key in mcolOcrNyuryoku.Keys)
                {
                    if (i3 >= mcolOcrNyuryoku[OCR_ITEM360].Index && i3 <= mcolOcrNyuryoku[OCR_ITEM441].Index)
                    {
                        // ０記入エラー？
                        if (IsZero(mcolOcrNyuryoku[key].Result))
                        {
                            EditOcrError(mcolOcrNyuryoku[key].UniqueKey, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_007, Convert.ToString(mcolOcrNyuryoku[key].ItemName));
                            mcolOcrNyuryoku[key].Result = ""; // 未記入とする
                        }
                    }
                    i3 = i3 + 1;
                }

                // 夕食摂取習慣
                // 未記入の場合
                if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM442].Result)))
                {
                    EditOcrError(OCR_ITEM442, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM442].ItemName), "食べる");
                    mcolOcrNyuryoku[OCR_ITEM442].Result = "1"; // 「食べる」を登録
                }

                // 夕食：ご飯（女性用茶碗）～お漬物
                int i4 = 1;
                foreach (string key in mcolOcrNyuryoku.Keys)
                {
                    if (i4 >= mcolOcrNyuryoku[OCR_ITEM443].Index && i4 <= mcolOcrNyuryoku[OCR_ITEM524].Index)
                    {
                        // ０記入エラー？
                        if (IsZero(mcolOcrNyuryoku[key].Result))
                        {
                            EditOcrError(mcolOcrNyuryoku[key].UniqueKey, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_007, Convert.ToString(mcolOcrNyuryoku[key].ItemName));
                            mcolOcrNyuryoku[key].Result = ""; // 未記入とする
                        }
                    }
                    i4 = i4 + 1;
                }
            }

            // 生活習慣改善意志
            // 未記入の場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM525].Result)))
            {
                EditOcrError(OCR_ITEM525, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM525].ItemName));
            }

            // 生活指導利用
            // 未記入の場合
            if (string.IsNullOrEmpty(Convert.ToString(mcolOcrNyuryoku[OCR_ITEM526].Result)))
            {
                EditOcrError(OCR_ITEM526, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, Convert.ToString(mcolOcrNyuryoku[OCR_ITEM526].ItemName));
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
                    errNo = 1;          // errNo : ブスコパン可否                                                      
                    break;
                case OCR_ITEM002:
                    errNo = 2;          // errNo : 朝食摂取の有無                                                      
                    break;
                case OCR_ITEM003:
                    errNo = 3;          // errNo : 病名
                    break;
                case OCR_ITEM004:
                    errNo = 3;          // errNo : 発症年齢                                                            
                    break;
                case OCR_ITEM005:
                    errNo = 3;          // errNo : 治療状況                                                            
                    break;
                case OCR_ITEM006:
                    errNo = 4;          // errNo : 病名                                                                
                    break;
                case OCR_ITEM007:
                    errNo = 4;          // errNo : 発症年齢                                                            
                    break;
                case OCR_ITEM008:
                    errNo = 4;          // errNo : 治療状況                                                            
                    break;
                case OCR_ITEM009:
                    errNo = 5;          // errNo : 病名                                                                
                    break;
                case OCR_ITEM010:
                    errNo = 5;          // errNo : 発症年齢                                                            
                    break;
                case OCR_ITEM011:
                    errNo = 5;          // errNo : 治療状況                                                            
                    break;
                case OCR_ITEM012:
                    errNo = 6;          // errNo : 病名                                                                
                    break;
                case OCR_ITEM013:
                    errNo = 6;          // errNo : 発症年齢                                                            
                    break;
                case OCR_ITEM014:
                    errNo = 6;          // errNo : 治療状況                                                            
                    break;
                case OCR_ITEM015:
                    errNo = 7;          // errNo : 病名                                                                
                    break;
                case OCR_ITEM016:
                    errNo = 7;          // errNo : 発症年齢                                                            
                    break;
                case OCR_ITEM017:
                    errNo = 7;          // errNo : 治療状況                                                            
                    break;
                case OCR_ITEM018:
                    errNo = 8;          // errNo : 病名                                                                
                    break;
                case OCR_ITEM019:
                    errNo = 8;          // errNo : 発症年齢                                                            
                    break;
                case OCR_ITEM020:
                    errNo = 8;          // errNo : 治療状況                                                            
                    break;
                case OCR_ITEM021:
                    errNo = 9;          // errNo : 病名                                                                
                    break;
                case OCR_ITEM022:
                    errNo = 9;          // errNo : 発症年齢                                                            
                    break;
                case OCR_ITEM023:
                    errNo = 9;          // errNo : 治療状況                                                            
                    break;
                case OCR_ITEM024:
                    errNo = 10;         // errNo : 病名                                                                
                    break;
                case OCR_ITEM025:
                    errNo = 10;         // errNo : 発症年齢                                                            
                    break;
                case OCR_ITEM026:
                    errNo = 10;         // errNo : 治療状況                                                            
                    break;
                case OCR_ITEM027:
                    errNo = 11;         // errNo : 病名                                                                
                    break;
                case OCR_ITEM028:
                    errNo = 11;         // errNo : 発症年齢                                                            
                    break;
                case OCR_ITEM029:
                    errNo = 11;         // errNo : 治療状況                                                            
                    break;
                case OCR_ITEM030:
                    errNo = 12;         // errNo : 病名                                                                
                    break;
                case OCR_ITEM031:
                    errNo = 12;         // errNo : 発症年齢                                                            
                    break;
                case OCR_ITEM032:
                    errNo = 12;         // errNo : 治療状況                                                            
                    break;
                case OCR_ITEM033:
                    errNo = 13;         // errNo : 病名                                                                
                    break;
                case OCR_ITEM034:
                    errNo = 13;         // errNo : 発症年齢                                                            
                    break;
                case OCR_ITEM035:
                    errNo = 13;         // errNo : 治療状況                                                            
                    break;
                case OCR_ITEM036:
                    errNo = 14;         // errNo : 病名                                                                
                    break;
                case OCR_ITEM037:
                    errNo = 14;         // errNo : 発症年齢                                                            
                    break;
                case OCR_ITEM038:
                    errNo = 14;         // errNo : 治療状況                                                            
                    break;
                case OCR_ITEM039:
                    errNo = 15;         // errNo : 病名                                                                
                    break;
                case OCR_ITEM040:
                    errNo = 15;         // errNo : 発症年齢                                                            
                    break;
                case OCR_ITEM041:
                    errNo = 15;         // errNo : 続柄                                                                
                    break;
                case OCR_ITEM042:
                    errNo = 16;         // errNo : 病名                                                                
                    break;
                case OCR_ITEM043:
                    errNo = 16;         // errNo : 発症年齢                                                            
                    break;
                case OCR_ITEM044:
                    errNo = 16;         // errNo : 続柄                                                                
                    break;
                case OCR_ITEM045:
                    errNo = 17;         // errNo : 病名                                                                
                    break;
                case OCR_ITEM046:
                    errNo = 17;         // errNo : 発症年齢                                                            
                    break;
                case OCR_ITEM047:
                    errNo = 17;         // errNo : 続柄                                                                
                    break;
                case OCR_ITEM048:
                    errNo = 18;         // errNo : 病名                                                                
                    break;
                case OCR_ITEM049:
                    errNo = 18;         // errNo : 発症年齢                                                            
                    break;
                case OCR_ITEM050:
                    errNo = 18;         // errNo : 続柄                                                                
                    break;
                case OCR_ITEM051:
                    errNo = 19;         // errNo : 病名                                                                
                    break;
                case OCR_ITEM052:
                    errNo = 19;         // errNo : 発症年齢                                                            
                    break;
                case OCR_ITEM053:
                    errNo = 19;         // errNo : 続柄                                                                
                    break;
                case OCR_ITEM054:
                    errNo = 20;         // errNo : 病名                                                                
                    break;
                case OCR_ITEM055:
                    errNo = 20;         // errNo : 発症年齢                                                            
                    break;
                case OCR_ITEM056:
                    errNo = 20;         // errNo : 続柄                                                                
                    break;
                case OCR_ITEM057:
                    errNo = 21;         // errNo : 手術をされた方へ                                                    
                    break;
                case OCR_ITEM058:
                    errNo = 22;         // errNo : 妊娠していますか                                                    
                    break;
                case OCR_ITEM059:
                    errNo = 23;         // errNo : 肺結核                                                              
                    break;
                case OCR_ITEM060:
                    errNo = 23;         // errNo : 無気肺                                                              
                    break;
                case OCR_ITEM061:
                    errNo = 23;         // errNo : 肺腺維症                                                            
                    break;
                case OCR_ITEM062:
                    errNo = 23;         // errNo : 胸膜瘢痕                                                            
                    break;
                case OCR_ITEM063:
                    errNo = 23;         // errNo : 陳旧性病変                                                          
                    break;
                case OCR_ITEM064:
                    errNo = 24;         // errNo : 食道ポリープ                                                        
                    break;
                case OCR_ITEM065:
                    errNo = 24;         // errNo : 胃新生物                                                            
                    break;
                case OCR_ITEM066:
                    errNo = 24;         // errNo : 慢性胃炎                                                            
                    break;
                case OCR_ITEM067:
                    errNo = 24;         // errNo : 胃ポリープ                                                          
                    break;
                case OCR_ITEM068:
                    errNo = 24;         // errNo : 胃潰瘍瘢痕                                                          
                    break;
                case OCR_ITEM069:
                    errNo = 24;         // errNo : 十二指腸                                                            
                    break;
                case OCR_ITEM070:
                    errNo = 24;         // errNo : その他                                                              
                    break;
                case OCR_ITEM071:
                    errNo = 25;         // errNo : 胆のうポリープ                                                      
                    break;
                case OCR_ITEM072:
                    errNo = 25;         // errNo : 胆石                                                                
                    break;
                case OCR_ITEM073:
                    errNo = 25;         // errNo : 肝血管腫                                                            
                    break;
                case OCR_ITEM074:
                    errNo = 25;         // errNo : 肝嚢胞                                                              
                    break;
                case OCR_ITEM075:
                    errNo = 25;         // errNo : 脂肪肝                                                              
                    break;
                case OCR_ITEM076:
                    errNo = 25;         // errNo : 腎結石                                                              
                    break;
                case OCR_ITEM077:
                    errNo = 25;         // errNo : 腎嚢胞                                                              
                    break;
                case OCR_ITEM078:
                    errNo = 25;         // errNo : その他                                                              
                    break;
                case OCR_ITEM079:
                    errNo = 26;         // errNo : ＷＰＷ症候群                                                        
                    break;
                case OCR_ITEM080:
                    errNo = 26;         // errNo : 完全右脚ブロック                                                    
                    break;
                case OCR_ITEM081:
                    errNo = 26;         // errNo : 不完全右脚ブロック                                                  
                    break;
                case OCR_ITEM082:
                    errNo = 26;         // errNo : 不整脈                                                              
                    break;
                case OCR_ITEM083:
                    errNo = 26;         // errNo : その他                                                              
                    break;
                case OCR_ITEM084:
                    errNo = 27;         // errNo : 乳腺症                                                              
                    break;
                case OCR_ITEM085:
                    errNo = 27;         // errNo : 繊維線種                                                            
                    break;
                case OCR_ITEM086:
                    errNo = 27;         // errNo : その他                                                              
                    break;
                case OCR_ITEM087:
                    errNo = 28;         // errNo : １８～２０歳の体重                                                  
                    break;
                case OCR_ITEM088:
                    errNo = 29;         // errNo : この半年での体重の変動                                              
                    break;
                case OCR_ITEM089:
                    errNo = 30;         // errNo : 週に何日飲みますか                                                  
                    break;
                case OCR_ITEM090:
                    errNo = 30;         // errNo : 飲酒日数                                                            
                    break;
                case OCR_ITEM091:
                    errNo = 31;         // errNo : ビール大瓶                                                          
                    break;
                case OCR_ITEM092:
                    errNo = 32;         // errNo : ビール３５０ｍｌ缶                                                  
                    break;
                case OCR_ITEM093:
                    errNo = 33;         // errNo : ビール５００ｍｌ缶                                                  
                    break;
                case OCR_ITEM094:
                    errNo = 34;         // errNo : 日本酒                                                              
                    break;
                case OCR_ITEM095:
                    errNo = 35;         // errNo : 焼酎                                                                
                    break;
                case OCR_ITEM096:
                    errNo = 36;         // errNo : ワイン                                                              
                    break;
                case OCR_ITEM097:
                    errNo = 37;         // errNo : ウイスキー・ブランデー                                              
                    break;
                case OCR_ITEM098:
                    errNo = 38;         // errNo : その他                                                              
                    break;
                case OCR_ITEM099:
                    errNo = 39;         // errNo : 現在の喫煙                                                          
                    break;
                case OCR_ITEM100:
                    errNo = 40;         // errNo : 吸い始めた年齢                                                      
                    break;
                case OCR_ITEM101:
                    errNo = 40;         // errNo : やめた年齢                                                          
                    break;
                case OCR_ITEM102:
                    errNo = 41;         // errNo : 喫煙本数                                                            
                    break;
                case OCR_ITEM103:
                    errNo = 42;         // errNo : 運動不足                                                            
                    break;
                case OCR_ITEM104:
                    errNo = 43;         // errNo : 何分歩くか                                                          
                    break;
                case OCR_ITEM105:
                    errNo = 44;         // errNo : 日常の身体活動                                                      
                    break;
                case OCR_ITEM106:
                    errNo = 45;         // errNo : 運動習慣                                                            
                    break;
                case OCR_ITEM107:
                    errNo = 46;         // errNo : 睡眠は十分ですか                                                    
                    break;
                case OCR_ITEM108:
                    errNo = 46;         // errNo : 睡眠時間                                                            
                    break;
                case OCR_ITEM109:
                    errNo = 46;         // errNo : 就寝時刻                                                            
                    break;
                case OCR_ITEM110:
                    errNo = 47;         // errNo : 歯磨きについて                                                      
                    break;
                case OCR_ITEM111:
                    errNo = 48;         // errNo : 現在の職業は                                                        
                    break;
                case OCR_ITEM112:
                    errNo = 49;         // errNo : 休日は何日とれますか                                                
                    break;
                case OCR_ITEM113:
                    errNo = 50;         // errNo : 職場への通勤手段                                                    
                    break;
                case OCR_ITEM114:
                    errNo = 51;         // errNo : 片道の通勤時間                                                      
                    break;
                case OCR_ITEM115:
                    errNo = 51;         // errNo : 徒歩時間                                                            
                    break;
                case OCR_ITEM116:
                    errNo = 52;         // errNo : 配偶者は                                                            
                    break;
                case OCR_ITEM117:
                    errNo = 53;         // errNo : 親                                                                  
                    break;
                case OCR_ITEM118:
                    errNo = 53;         // errNo : 配偶者                                                              
                    break;
                case OCR_ITEM119:
                    errNo = 53;         // errNo : 子供                                                                
                    break;
                case OCR_ITEM120:
                    errNo = 53;         // errNo : 独居                                                                
                    break;
                case OCR_ITEM121:
                    errNo = 53;         // errNo : その他                                                              
                    break;
                case OCR_ITEM122:
                    errNo = 54;         // errNo : 生活に満足                                                          
                    break;
                case OCR_ITEM123:
                    errNo = 55;         // errNo : １年以内につらい思い                                                
                    break;
                case OCR_ITEM124:
                    errNo = 56;         // errNo : 信仰心                                                              
                    break;
                case OCR_ITEM125:
                    errNo = 57;         // errNo : ボランティア活動                                                    
                    break;
                case OCR_ITEM126:
                    errNo = 58;         // errNo : 自覚症状内容                                                        
                    break;
                case OCR_ITEM127:
                    errNo = 58;         // errNo : 数値                                                                
                    break;
                case OCR_ITEM128:
                    errNo = 58;         // errNo : 単位                                                                
                    break;
                case OCR_ITEM129:
                    errNo = 58;         // errNo : 受診                                                                
                    break;
                case OCR_ITEM130:
                    errNo = 59;         // errNo : 自覚症状内容                                                        
                    break;
                case OCR_ITEM131:
                    errNo = 59;         // errNo : 数値                                                                
                    break;
                case OCR_ITEM132:
                    errNo = 59;         // errNo : 単位                                                                
                    break;
                case OCR_ITEM133:
                    errNo = 59;         // errNo : 受診                                                                
                    break;
                case OCR_ITEM134:
                    errNo = 60;         // errNo : 自覚症状内容                                                        
                    break;
                case OCR_ITEM135:
                    errNo = 60;         // errNo : 数値                                                                
                    break;
                case OCR_ITEM136:
                    errNo = 60;         // errNo : 単位                                                                
                    break;
                case OCR_ITEM137:
                    errNo = 60;         // errNo : 受診                                                                
                    break;
                case OCR_ITEM138:
                    errNo = 61;         // errNo : 自覚症状内容                                                        
                    break;
                case OCR_ITEM139:
                    errNo = 61;         // errNo : 数値                                                                
                    break;
                case OCR_ITEM140:
                    errNo = 61;         // errNo : 単位                                                                
                    break;
                case OCR_ITEM141:
                    errNo = 61;         // errNo : 受診                                                                
                    break;
                case OCR_ITEM142:
                    errNo = 62;         // errNo : 自覚症状内容                                                        
                    break;
                case OCR_ITEM143:
                    errNo = 62;         // errNo : 数値                                                                
                    break;
                case OCR_ITEM144:
                    errNo = 62;         // errNo : 単位                                                                
                    break;
                case OCR_ITEM145:
                    errNo = 62;         // errNo : 受診                                                                
                    break;
                case OCR_ITEM146:
                    errNo = 63;         // errNo : 自覚症状内容                                                        
                    break;
                case OCR_ITEM147:
                    errNo = 63;         // errNo : 数値                                                                
                    break;
                case OCR_ITEM148:
                    errNo = 63;         // errNo : 単位                                                                
                    break;
                case OCR_ITEM149:
                    errNo = 63;         // errNo : 受診                                                                
                    break;
                case OCR_ITEM150:
                    errNo = 64;         // errNo : 本人希望により未回答                                                
                    break;
                case OCR_ITEM151:
                    errNo = 65;         // errNo : ストレス、緊張時上腹部に痛み                                        
                    break;
                case OCR_ITEM152:
                    errNo = 66;         // errNo : 気性は激しい方ですか                                                
                    break;
                case OCR_ITEM153:
                    errNo = 67;         // errNo : 責任感が強いと言われた                                              
                    break;
                case OCR_ITEM154:
                    errNo = 68;         // errNo : 仕事に自信を持っている                                              
                    break;
                case OCR_ITEM155:
                    errNo = 69;         // errNo : 特別に早起きして職場に行く                                          
                    break;
                case OCR_ITEM156:
                    errNo = 70;         // errNo : 約束の時間に遅れる方                                                
                    break;
                case OCR_ITEM157:
                    errNo = 71;         // errNo : 正しいと思うことは貫く                                              
                    break;
                case OCR_ITEM158:
                    errNo = 72;         // errNo : 数時間旅行すると仮定                                                
                    break;
                case OCR_ITEM159:
                    errNo = 73;         // errNo : 他人から指示された場合                                              
                    break;
                case OCR_ITEM160:
                    errNo = 74;         // errNo : 車を追い抜かれた場合                                                
                    break;
                case OCR_ITEM161:
                    errNo = 75;         // errNo : 帰宅時リラックスした気分                                            
                    break;
                case OCR_ITEM162:
                    errNo = 76;         // errNo : 本人希望により未回答                                                
                    break;
                case OCR_ITEM163:
                    errNo = 77;         // errNo : 積極的に解決しようと努力する                                        
                    break;
                case OCR_ITEM164:
                    errNo = 78;         // errNo : 自分への挑戦と受け止める                                            
                    break;
                case OCR_ITEM165:
                    errNo = 79;         // errNo : 一休みするより頑張ろうとする                                        
                    break;
                case OCR_ITEM166:
                    errNo = 80;         // errNo : 衝動買いや高価な買い物をする                                        
                    break;
                case OCR_ITEM167:
                    errNo = 81;         // errNo : 同僚や家族と出歩いたり飲み食いする                                  
                    break;
                case OCR_ITEM168:
                    errNo = 82;         // errNo : 何か新しい事を始めようとする                                        
                    break;
                case OCR_ITEM169:
                    errNo = 83;         // errNo : 今の状況から抜け出る事は無理だと思う                                
                    break;
                case OCR_ITEM170:
                    errNo = 84;         // errNo : 楽しかったことをボンヤリ考える                                      
                    break;
                case OCR_ITEM171:
                    errNo = 85;         // errNo : どうすれば良かったのかを思い悩む                                    
                    break;
                case OCR_ITEM172:
                    errNo = 86;         // errNo : 現在の状況について考えないようにする                                
                    break;
                case OCR_ITEM173:
                    errNo = 87;         // errNo : 体の調子の悪い時には病院に行こうかと思う                            
                    break;
                case OCR_ITEM174:
                    errNo = 88;         // errNo : 以前よりタバコ・酒・食事の量が増える                                
                    break;
                case OCR_ITEM175:
                    errNo = 89;         // errNo : 子宮ガンの検診を受けたことは                                        
                    break;
                case OCR_ITEM176:
                    errNo = 90;         // errNo : 健診を受けた施設は                                                  
                    break;
                case OCR_ITEM177:
                    errNo = 91;         // errNo : 健診の結果は                                                        
                    break;
                case OCR_ITEM178:
                    errNo = 92;         // errNo : ない                                                                
                    break;
                case OCR_ITEM179:
                    errNo = 92;         // errNo : 膣炎                                                                
                    break;
                case OCR_ITEM180:
                    errNo = 92;         // errNo : 月経異常                                                            
                    break;
                case OCR_ITEM181:
                    errNo = 92;         // errNo : 不妊                                                                
                    break;
                case OCR_ITEM182:
                    errNo = 92;         // errNo : 子宮筋腫                                                            
                    break;
                case OCR_ITEM183:
                    errNo = 92;         // errNo : 子宮内膜症                                                          
                    break;
                case OCR_ITEM184:
                    errNo = 92;         // errNo : 子宮がん                                                            
                    break;
                case OCR_ITEM185:
                    errNo = 92;         // errNo : 子宮頚管ポリープ                                                    
                    break;
                case OCR_ITEM186:
                    errNo = 92;         // errNo : 卵巣腫瘍（右）                                                      
                    break;
                case OCR_ITEM187:
                    errNo = 92;         // errNo : 卵巣腫瘍（左）                                                      
                    break;
                case OCR_ITEM188:
                    errNo = 92;         // errNo : 乳がん                                                              
                    break;
                case OCR_ITEM189:
                    errNo = 92;         // errNo : びらん                                                              
                    break;
                case OCR_ITEM190:
                    errNo = 93;         // errNo : ホルモン治療                                                        
                    break;
                case OCR_ITEM191:
                    errNo = 93;         // errNo : 歳                                                                  
                    break;
                case OCR_ITEM192:
                    errNo = 93;         // errNo : 年数                                                                
                    break;
                case OCR_ITEM193:
                    errNo = 94;         // errNo : 婦人科の手術                                                        
                    break;
                case OCR_ITEM194:
                    errNo = 95;         // errNo : 子宮全摘術                                                          
                    break;
                case OCR_ITEM195:
                    errNo = 95;         // errNo : 歳                                                                  
                    break;
                case OCR_ITEM196:
                    errNo = 96;         // errNo : 卵巣摘出術                                                          
                    break;
                case OCR_ITEM197:
                    errNo = 96;         // errNo : 歳                                                                  
                    break;
                case OCR_ITEM198:
                    errNo = 96;         // errNo : 部分                                                                
                    break;
                case OCR_ITEM199:
                    errNo = 97;         // errNo : 子宮筋腫核出術                                                      
                    break;
                case OCR_ITEM200:
                    errNo = 97;         // errNo : 歳                                                                  
                    break;
                case OCR_ITEM201:
                    errNo = 98;         // errNo : 妊娠回数                                                            
                    break;
                case OCR_ITEM202:
                    errNo = 99;         // errNo : 出産回数                                                            
                    break;
                case OCR_ITEM203:
                    errNo = 99;         // errNo : 帝王切開回数                                                        
                    break;
                case OCR_ITEM204:
                    errNo = 100;        // errNo : １年以内に妊娠または出産                                            
                    break;
                case OCR_ITEM205:
                    errNo = 101;        // errNo : 閉経しましたか                                                      
                    break;
                case OCR_ITEM206:
                    errNo = 101;        // errNo : 歳                                                                  
                    break;
                case OCR_ITEM207:
                    errNo = 102;        // errNo : 開始年                                                              
                    break;
                case OCR_ITEM208:
                    errNo = 102;        // errNo : 開始月                                                              
                    break;
                case OCR_ITEM209:
                    errNo = 102;        // errNo : 開始日                                                              
                    break;
                case OCR_ITEM210:
                    errNo = 102;        // errNo : 終了月                                                              
                    break;
                case OCR_ITEM211:
                    errNo = 102;        // errNo : 終了日                                                              
                    break;
                case OCR_ITEM212:
                    errNo = 103;        // errNo : 開始年                                                              
                    break;
                case OCR_ITEM213:
                    errNo = 103;        // errNo : 開始月                                                              
                    break;
                case OCR_ITEM214:
                    errNo = 103;        // errNo : 開始日                                                              
                    break;
                case OCR_ITEM215:
                    errNo = 103;        // errNo : 終了月                                                              
                    break;
                case OCR_ITEM216:
                    errNo = 103;        // errNo : 終了日                                                              
                    break;
                case OCR_ITEM217:
                    errNo = 104;        // errNo : 月経周期                                                            
                    break;
                case OCR_ITEM218:
                    errNo = 104;        // errNo : 不規則                                                              
                    break;
                case OCR_ITEM219:
                    errNo = 105;        // errNo : 月経期間                                                            
                    break;
                case OCR_ITEM220:
                    errNo = 105;        // errNo : 不規則                                                              
                    break;
                case OCR_ITEM221:
                    errNo = 106;        // errNo : 出血量                                                              
                    break;
                case OCR_ITEM222:
                    errNo = 107;        // errNo : 痛み                                                                
                    break;
                case OCR_ITEM223:
                    errNo = 108;        // errNo : 月経以外に出血                                                      
                    break;
                case OCR_ITEM224:
                    errNo = 109;        // errNo : ない                                                                
                    break;
                case OCR_ITEM225:
                    errNo = 109;        // errNo : おりものが気になる                                                  
                    break;
                case OCR_ITEM226:
                    errNo = 109;        // errNo : 陰部がかゆい                                                        
                    break;
                case OCR_ITEM227:
                    errNo = 109;        // errNo : 下腹部が痛い                                                        
                    break;
                case OCR_ITEM228:
                    errNo = 109;        // errNo : 更年期症状がつらい                                                  
                    break;
                case OCR_ITEM229:
                    errNo = 109;        // errNo : 性交時に出血する                                                    
                    break;
                case OCR_ITEM230:
                    errNo = 110;        // errNo : 性生活                                                              
                    break;
                case OCR_ITEM231:
                    errNo = 111;        // errNo : いない                                                              
                    break;
                case OCR_ITEM232:
                    errNo = 111;        // errNo : 実母                                                                
                    break;
                case OCR_ITEM233:
                    errNo = 111;        // errNo : 実姉妹                                                              
                    break;
                case OCR_ITEM234:
                    errNo = 111;        // errNo : その他                                                              
                    break;
                case OCR_ITEM235:
                    errNo = 112;        // errNo : 子宮体ガン                                                          
                    break;
                case OCR_ITEM236:
                    errNo = 112;        // errNo : 子宮頚ガン                                                          
                    break;
                case OCR_ITEM237:
                    errNo = 112;        // errNo : 卵巣ガン                                                            
                    break;
                case OCR_ITEM238:
                    errNo = 112;        // errNo : 乳がん                                                              
                    break;
                case OCR_ITEM239:
                    errNo = 112;        // errNo : その他の婦人科系ガン                                                
                    break;
                case OCR_ITEM240:
                    errNo = 113;        // errNo : 本人希望により未回答                                                
                    break;
                case OCR_ITEM241:
                    errNo = 114;        // errNo : カロリー制限                                                        
                    break;
                case OCR_ITEM242:
                    errNo = 114;        // errNo : カロリー制限量                                                      
                    break;
                case OCR_ITEM243:
                    errNo = 115;        // errNo : 食事の速度は速い                                                    
                    break;
                case OCR_ITEM244:
                    errNo = 116;        // errNo : 満腹になるまで食べるほう                                            
                    break;
                case OCR_ITEM245:
                    errNo = 117;        // errNo : 食事の規則性は                                                      
                    break;
                case OCR_ITEM246:
                    errNo = 117;        // errNo : １週間の平均欠食回数                                                
                    break;
                case OCR_ITEM247:
                    errNo = 118;        // errNo : バランスを考えて食べている                                          
                    break;
                case OCR_ITEM248:
                    errNo = 119;        // errNo : 甘いものはよく食べる                                                
                    break;
                case OCR_ITEM249:
                    errNo = 120;        // errNo : 脂肪分の多い食事を好む                                              
                    break;
                case OCR_ITEM250:
                    errNo = 121;        // errNo : 味付けは濃いほう                                                    
                    break;
                case OCR_ITEM251:
                    errNo = 122;        // errNo : 間食をとることがある                                                
                    break;
                case OCR_ITEM252:
                    errNo = 122;        // errNo : １週間の平均間食回数                                                
                    break;
                case OCR_ITEM253:
                    errNo = 123;        // errNo : 減塩醤油を使っている                                                
                    break;
                case OCR_ITEM254:
                    errNo = 124;        // errNo : コーヒー・紅茶                                                      
                    break;
                case OCR_ITEM255:
                    errNo = 125;        // errNo : 砂糖（小さじ）                                                      
                    break;
                case OCR_ITEM256:
                    errNo = 126;        // errNo : ミルク（小さじ）                                                    
                    break;
                case OCR_ITEM257:
                    errNo = 127;        // errNo : ジュース（スポーツ飲料も含む）                                      
                    break;
                case OCR_ITEM258:
                    errNo = 128;        // errNo : 果汁・野菜ジュース                                                  
                    break;
                case OCR_ITEM259:
                    errNo = 129;        // errNo : 炭酸飲料                                                            
                    break;
                case OCR_ITEM260:
                    errNo = 130;        // errNo : アイス                                                              
                    break;
                case OCR_ITEM261:
                    errNo = 131;        // errNo : シャーベット                                                        
                    break;
                case OCR_ITEM262:
                    errNo = 132;        // errNo : クッキー                                                            
                    break;
                case OCR_ITEM263:
                    errNo = 124;        // errNo : あめ                                                                
                    break;
                case OCR_ITEM264:
                    errNo = 125;        // errNo : チョコレート                                                        
                    break;
                case OCR_ITEM265:
                    errNo = 126;        // errNo : スナック菓子                                                        
                    break;
                case OCR_ITEM266:
                    errNo = 127;        // errNo : ナッツ                                                              
                    break;
                case OCR_ITEM267:
                    errNo = 128;        // errNo : 和菓子（まんじゅうなど）                                            
                    break;
                case OCR_ITEM268:
                    errNo = 129;        // errNo : 洋菓子（ケーキなど）                                                
                    break;
                case OCR_ITEM269:
                    errNo = 130;        // errNo : ドーナツ                                                            
                    break;
                case OCR_ITEM270:
                    errNo = 131;        // errNo : ゼリー                                                              
                    break;
                case OCR_ITEM271:
                    errNo = 132;        // errNo : せんべい（あられ）                                                  
                    break;
                case OCR_ITEM272:
                    errNo = 133;        // errNo : 普通牛乳                                                            
                    break;
                case OCR_ITEM273:
                    errNo = 134;        // errNo : 普通ヨーグルト                                                      
                    break;
                case OCR_ITEM274:
                    errNo = 133;        // errNo : 低脂肪牛乳                                                          
                    break;
                case OCR_ITEM275:
                    errNo = 134;        // errNo : 低脂肪ヨーグルト                                                    
                    break;
                case OCR_ITEM276:
                    errNo = 135;        // errNo : 毎日食べていますか                                                  
                    break;
                case OCR_ITEM277:
                    errNo = 136;        // errNo : ご飯（女性用茶碗）                                                  
                    break;
                case OCR_ITEM278:
                    errNo = 137;        // errNo : ご飯（男性用茶碗）                                                  
                    break;
                case OCR_ITEM279:
                    errNo = 138;        // errNo : ご飯（どんぶり茶碗）                                                
                    break;
                case OCR_ITEM280:
                    errNo = 139;        // errNo : おにぎり                                                            
                    break;
                case OCR_ITEM281:
                    errNo = 140;        // errNo : そば・うどん（天ぷら）                                              
                    break;
                case OCR_ITEM282:
                    errNo = 141;        // errNo : そば・うどん（たぬき）                                              
                    break;
                case OCR_ITEM283:
                    errNo = 142;        // errNo : そば・うどん（ざる・かけ）                                          
                    break;
                case OCR_ITEM284:
                    errNo = 143;        // errNo : ラーメン                                                            
                    break;
                case OCR_ITEM285:
                    errNo = 144;        // errNo : 五目ラーメン                                                        
                    break;
                case OCR_ITEM286:
                    errNo = 145;        // errNo : 焼きそば                                                            
                    break;
                case OCR_ITEM287:
                    errNo = 146;        // errNo : スパゲッティ（クリーム)                                             
                    break;
                case OCR_ITEM288:
                    errNo = 147;        // errNo : スパゲッティ（その他)                                               
                    break;
                case OCR_ITEM289:
                    errNo = 148;        // errNo : マカロニグラタン                                                    
                    break;
                case OCR_ITEM290:
                    errNo = 149;        // errNo : 食パン６枚切り                                                      
                    break;
                case OCR_ITEM291:
                    errNo = 150;        // errNo : 食パン８枚切り                                                      
                    break;
                case OCR_ITEM292:
                    errNo = 151;        // errNo : バター                                                              
                    break;
                case OCR_ITEM293:
                    errNo = 152;        // errNo : マーガリン                                                          
                    break;
                case OCR_ITEM294:
                    errNo = 153;        // errNo : ジャム類                                                            
                    break;
                case OCR_ITEM295:
                    errNo = 154;        // errNo : ミックスサンドイッチ                                                
                    break;
                case OCR_ITEM296:
                    errNo = 155;        // errNo : 菓子パン                                                            
                    break;
                case OCR_ITEM297:
                    errNo = 156;        // errNo : 調理パン                                                            
                    break;
                case OCR_ITEM298:
                    errNo = 157;        // errNo : カツ丼                                                              
                    break;
                case OCR_ITEM299:
                    errNo = 158;        // errNo : 親子丼                                                              
                    break;
                case OCR_ITEM300:
                    errNo = 159;        // errNo : 天丼                                                                
                    break;
                case OCR_ITEM301:
                    errNo = 160;        // errNo : 中華丼                                                              
                    break;
                case OCR_ITEM302:
                    errNo = 161;        // errNo : カレーライス                                                        
                    break;
                case OCR_ITEM303:
                    errNo = 162;        // errNo : チャーハン・ピラフ                                                  
                    break;
                case OCR_ITEM304:
                    errNo = 163;        // errNo : にぎり・ちらし寿司                                                  
                    break;
                case OCR_ITEM305:
                    errNo = 164;        // errNo : 幕の内弁当                                                          
                    break;
                case OCR_ITEM306:
                    errNo = 165;        // errNo : シリアル等                                                          
                    break;
                case OCR_ITEM307:
                    errNo = 166;        // errNo : ミックスピザ                                                        
                    break;
                case OCR_ITEM308:
                    errNo = 136;        // errNo : 刺身盛り合わせ                                                      
                    break;
                case OCR_ITEM309:
                    errNo = 137;        // errNo : 煮魚・焼魚（ぶり、さんま、いわし等）                                
                    break;
                case OCR_ITEM310:
                    errNo = 138;        // errNo : 煮魚・焼魚（かれい、たら、ひらめ等）                                
                    break;
                case OCR_ITEM311:
                    errNo = 139;        // errNo : 魚のムニエル                                                        
                    break;
                case OCR_ITEM312:
                    errNo = 140;        // errNo : エビチリ                                                            
                    break;
                case OCR_ITEM313:
                    errNo = 141;        // errNo : 八宝菜                                                              
                    break;
                case OCR_ITEM314:
                    errNo = 142;        // errNo : ステーキ(150g)                                                      
                    break;
                case OCR_ITEM315:
                    errNo = 143;        // errNo : 焼き肉                                                              
                    break;
                case OCR_ITEM316:
                    errNo = 144;        // errNo : とりの唐揚                                                          
                    break;
                case OCR_ITEM317:
                    errNo = 145;        // errNo : ハンバーグ                                                          
                    break;
                case OCR_ITEM318:
                    errNo = 146;        // errNo : シチュー                                                            
                    break;
                case OCR_ITEM319:
                    errNo = 147;        // errNo : 肉野菜炒め                                                          
                    break;
                case OCR_ITEM320:
                    errNo = 148;        // errNo : 餃子・シュウマイ                                                    
                    break;
                case OCR_ITEM321:
                    errNo = 149;        // errNo : ハム・ウィンナー                                                    
                    break;
                case OCR_ITEM322:
                    errNo = 150;        // errNo : ベーコン                                                            
                    break;
                case OCR_ITEM323:
                    errNo = 151;        // errNo : フライ（コロッケ）                                                  
                    break;
                case OCR_ITEM324:
                    errNo = 152;        // errNo : フライ（トンカツ）                                                  
                    break;
                case OCR_ITEM325:
                    errNo = 153;        // errNo : フライ（えび）                                                      
                    break;
                case OCR_ITEM326:
                    errNo = 154;        // errNo : 天ぷら                                                              
                    break;
                case OCR_ITEM327:
                    errNo = 155;        // errNo : すき焼き・しゃぶしゃぶ等                                            
                    break;
                case OCR_ITEM328:
                    errNo = 156;        // errNo : 寄鍋・たらちり等                                                    
                    break;
                case OCR_ITEM329:
                    errNo = 157;        // errNo : おでん                                                              
                    break;
                case OCR_ITEM330:
                    errNo = 158;        // errNo : 生卵・ゆで卵                                                        
                    break;
                case OCR_ITEM331:
                    errNo = 159;        // errNo : 目玉焼き                                                            
                    break;
                case OCR_ITEM332:
                    errNo = 160;        // errNo : 卵焼き                                                              
                    break;
                case OCR_ITEM333:
                    errNo = 161;        // errNo : スクランブル                                                        
                    break;
                case OCR_ITEM334:
                    errNo = 162;        // errNo : かに玉                                                              
                    break;
                case OCR_ITEM335:
                    errNo = 163;        // errNo : 冷・湯豆腐                                                          
                    break;
                case OCR_ITEM336:
                    errNo = 164;        // errNo : 納豆                                                                
                    break;
                case OCR_ITEM337:
                    errNo = 165;        // errNo : マーボ豆腐                                                          
                    break;
                case OCR_ITEM338:
                    errNo = 166;        // errNo : 五目豆                                                              
                    break;
                case OCR_ITEM339:
                    errNo = 136;        // errNo : 野菜サラダ                                                          
                    break;
                case OCR_ITEM340:
                    errNo = 137;        // errNo : ノンオイルドレッシング                                              
                    break;
                case OCR_ITEM341:
                    errNo = 138;        // errNo : マヨネーズ                                                          
                    break;
                case OCR_ITEM342:
                    errNo = 139;        // errNo : ドレッシング                                                        
                    break;
                case OCR_ITEM343:
                    errNo = 140;        // errNo : 塩                                                                  
                    break;
                case OCR_ITEM344:
                    errNo = 141;        // errNo : ポテト・マカロニサラダ                                              
                    break;
                case OCR_ITEM345:
                    errNo = 142;        // errNo : 煮物（芋入り）                                                      
                    break;
                case OCR_ITEM346:
                    errNo = 143;        // errNo : 煮物（野菜のみ）                                                    
                    break;
                case OCR_ITEM347:
                    errNo = 144;        // errNo : 煮物（ひじき・昆布等）                                              
                    break;
                case OCR_ITEM348:
                    errNo = 145;        // errNo : 肉じゃが                                                            
                    break;
                case OCR_ITEM349:
                    errNo = 146;        // errNo : 野菜炒め（肉なし）                                                  
                    break;
                case OCR_ITEM350:
                    errNo = 147;        // errNo : おひたし                                                            
                    break;
                case OCR_ITEM351:
                    errNo = 148;        // errNo : 酢の物                                                              
                    break;
                case OCR_ITEM352:
                    errNo = 149;        // errNo : 味噌汁                                                              
                    break;
                case OCR_ITEM353:
                    errNo = 150;        // errNo : コンソメ                                                            
                    break;
                case OCR_ITEM354:
                    errNo = 151;        // errNo : ポタージュ                                                          
                    break;
                case OCR_ITEM355:
                    errNo = 152;        // errNo : チーズ                                                              
                    break;
                case OCR_ITEM356:
                    errNo = 153;        // errNo : 枝豆                                                                
                    break;
                case OCR_ITEM357:
                    errNo = 154;        // errNo : 果物                                                                
                    break;
                case OCR_ITEM358:
                    errNo = 155;        // errNo : お漬物                                                              
                    break;
                case OCR_ITEM359:
                    errNo = 167;        // errNo : 毎日食べていますか                                                  
                    break;
                case OCR_ITEM360:
                    errNo = 168;        // errNo : ご飯（女性用茶碗）                                                  
                    break;
                case OCR_ITEM361:
                    errNo = 169;        // errNo : ご飯（男性用茶碗）                                                  
                    break;
                case OCR_ITEM362:
                    errNo = 170;        // errNo : ご飯（どんぶり茶碗）                                                
                    break;
                case OCR_ITEM363:
                    errNo = 171;        // errNo : おにぎり                                                            
                    break;
                case OCR_ITEM364:
                    errNo = 172;        // errNo : そば・うどん（天ぷら）                                              
                    break;
                case OCR_ITEM365:
                    errNo = 173;        // errNo : そば・うどん（たぬき）                                              
                    break;
                case OCR_ITEM366:
                    errNo = 174;        // errNo : そば・うどん（ざる・かけ）                                          
                    break;
                case OCR_ITEM367:
                    errNo = 175;        // errNo : ラーメン                                                            
                    break;
                case OCR_ITEM368:
                    errNo = 176;        // errNo : 五目ラーメン                                                        
                    break;
                case OCR_ITEM369:
                    errNo = 177;        // errNo : 焼きそば                                                            
                    break;
                case OCR_ITEM370:
                    errNo = 178;        // errNo : スパゲッティ（クリーム)                                             
                    break;
                case OCR_ITEM371:
                    errNo = 179;        // errNo : スパゲッティ（その他)                                               
                    break;
                case OCR_ITEM372:
                    errNo = 180;        // errNo : マカロニグラタン                                                    
                    break;
                case OCR_ITEM373:
                    errNo = 181;        // errNo : 食パン６枚切り                                                      
                    break;
                case OCR_ITEM374:
                    errNo = 182;        // errNo : 食パン８枚切り                                                      
                    break;
                case OCR_ITEM375:
                    errNo = 183;        // errNo : バター                                                              
                    break;
                case OCR_ITEM376:
                    errNo = 184;        // errNo : マーガリン                                                          
                    break;
                case OCR_ITEM377:
                    errNo = 185;        // errNo : ジャム類                                                            
                    break;
                case OCR_ITEM378:
                    errNo = 186;        // errNo : ミックスサンドイッチ                                                
                    break;
                case OCR_ITEM379:
                    errNo = 187;        // errNo : 菓子パン                                                            
                    break;
                case OCR_ITEM380:
                    errNo = 188;        // errNo : 調理パン                                                            
                    break;
                case OCR_ITEM381:
                    errNo = 189;        // errNo : カツ丼                                                              
                    break;
                case OCR_ITEM382:
                    errNo = 190;        // errNo : 親子丼                                                              
                    break;
                case OCR_ITEM383:
                    errNo = 191;        // errNo : 天丼                                                                
                    break;
                case OCR_ITEM384:
                    errNo = 192;        // errNo : 中華丼                                                              
                    break;
                case OCR_ITEM385:
                    errNo = 193;        // errNo : カレーライス                                                        
                    break;
                case OCR_ITEM386:
                    errNo = 194;        // errNo : チャーハン・ピラフ                                                  
                    break;
                case OCR_ITEM387:
                    errNo = 195;        // errNo : にぎり・ちらし寿司                                                  
                    break;
                case OCR_ITEM388:
                    errNo = 196;        // errNo : 幕の内弁当                                                          
                    break;
                case OCR_ITEM389:
                    errNo = 197;        // errNo : シリアル等                                                          
                    break;
                case OCR_ITEM390:
                    errNo = 198;        // errNo : ミックスピザ                                                        
                    break;
                case OCR_ITEM391:
                    errNo = 168;        // errNo : 刺身盛り合わせ                                                      
                    break;
                case OCR_ITEM392:
                    errNo = 169;        // errNo : 煮魚・焼魚（ぶり、さんま、いわし等）                                
                    break;
                case OCR_ITEM393:
                    errNo = 170;        // errNo : 煮魚・焼魚（かれい、たら、ひらめ等）                                
                    break;
                case OCR_ITEM394:
                    errNo = 171;        // errNo : 魚のムニエル                                                        
                    break;
                case OCR_ITEM395:
                    errNo = 172;        // errNo : エビチリ                                                            
                    break;
                case OCR_ITEM396:
                    errNo = 173;        // errNo : 八宝菜                                                              
                    break;
                case OCR_ITEM397:
                    errNo = 174;        // errNo : ステーキ(150g)                                                      
                    break;
                case OCR_ITEM398:
                    errNo = 175;        // errNo : 焼き肉                                                              
                    break;
                case OCR_ITEM399:
                    errNo = 176;        // errNo : とりの唐揚                                                          
                    break;
                case OCR_ITEM400:
                    errNo = 177;        // errNo : ハンバーグ                                                          
                    break;
                case OCR_ITEM401:
                    errNo = 178;        // errNo : シチュー                                                            
                    break;
                case OCR_ITEM402:
                    errNo = 179;        // errNo : 肉野菜炒め                                                          
                    break;
                case OCR_ITEM403:
                    errNo = 180;        // errNo : 餃子・シュウマイ                                                    
                    break;
                case OCR_ITEM404:
                    errNo = 181;        // errNo : ハム・ウィンナー                                                    
                    break;
                case OCR_ITEM405:
                    errNo = 182;        // errNo : ベーコン                                                            
                    break;
                case OCR_ITEM406:
                    errNo = 183;        // errNo : フライ（コロッケ）                                                  
                    break;
                case OCR_ITEM407:
                    errNo = 184;        // errNo : フライ（トンカツ）                                                  
                    break;
                case OCR_ITEM408:
                    errNo = 185;        // errNo : フライ（えび）                                                      
                    break;
                case OCR_ITEM409:
                    errNo = 186;        // errNo : 天ぷら                                                              
                    break;
                case OCR_ITEM410:
                    errNo = 187;        // errNo : すき焼き・しゃぶしゃぶ等                                            
                    break;
                case OCR_ITEM411:
                    errNo = 188;        // errNo : 寄鍋・たらちり等                                                    
                    break;
                case OCR_ITEM412:
                    errNo = 189;        // errNo : おでん                                                              
                    break;
                case OCR_ITEM413:
                    errNo = 190;        // errNo : 生卵・ゆで卵                                                        
                    break;
                case OCR_ITEM414:
                    errNo = 191;        // errNo : 目玉焼き                                                            
                    break;
                case OCR_ITEM415:
                    errNo = 192;        // errNo : 卵焼き                                                              
                    break;
                case OCR_ITEM416:
                    errNo = 193;        // errNo : スクランブル                                                        
                    break;
                case OCR_ITEM417:
                    errNo = 194;        // errNo : かに玉                                                              
                    break;
                case OCR_ITEM418:
                    errNo = 195;        // errNo : 冷・湯豆腐                                                          
                    break;
                case OCR_ITEM419:
                    errNo = 196;        // errNo : 納豆                                                                
                    break;
                case OCR_ITEM420:
                    errNo = 197;        // errNo : マーボ豆腐                                                          
                    break;
                case OCR_ITEM421:
                    errNo = 198;        // errNo : 五目豆                                                              
                    break;
                case OCR_ITEM422:
                    errNo = 168;        // errNo : 野菜サラダ                                                          
                    break;
                case OCR_ITEM423:
                    errNo = 169;        // errNo : ノンオイルドレッシング                                              
                    break;
                case OCR_ITEM424:
                    errNo = 170;        // errNo : マヨネーズ                                                          
                    break;
                case OCR_ITEM425:
                    errNo = 171;        // errNo : ドレッシング                                                        
                    break;
                case OCR_ITEM426:
                    errNo = 172;        // errNo : 塩                                                                  
                    break;
                case OCR_ITEM427:
                    errNo = 173;        // errNo : ポテト・マカロニサラダ                                              
                    break;
                case OCR_ITEM428:
                    errNo = 174;        // errNo : 煮物（芋入り）                                                      
                    break;
                case OCR_ITEM429:
                    errNo = 175;        // errNo : 煮物（野菜のみ）                                                    
                    break;
                case OCR_ITEM430:
                    errNo = 176;        // errNo : 煮物（ひじき・昆布等）                                              
                    break;
                case OCR_ITEM431:
                    errNo = 177;        // errNo : 肉じゃが                                                            
                    break;
                case OCR_ITEM432:
                    errNo = 178;        // errNo : 野菜炒め（肉なし）                                                  
                    break;
                case OCR_ITEM433:
                    errNo = 179;        // errNo : おひたし                                                            
                    break;
                case OCR_ITEM434:
                    errNo = 180;        // errNo : 酢の物                                                              
                    break;
                case OCR_ITEM435:
                    errNo = 181;        // errNo : 味噌汁                                                              
                    break;
                case OCR_ITEM436:
                    errNo = 182;        // errNo : コンソメ                                                            
                    break;
                case OCR_ITEM437:
                    errNo = 183;        // errNo : ポタージュ                                                          
                    break;
                case OCR_ITEM438:
                    errNo = 184;        // errNo : チーズ                                                              
                    break;
                case OCR_ITEM439:
                    errNo = 185;        // errNo : 枝豆                                                                
                    break;
                case OCR_ITEM440:
                    errNo = 186;        // errNo : 果物                                                                
                    break;
                case OCR_ITEM441:
                    errNo = 187;        // errNo : お漬物                                                              
                    break;
                case OCR_ITEM442:
                    errNo = 199;        // errNo : 毎日食べていますか                                                  
                    break;
                case OCR_ITEM443:
                    errNo = 200;        // errNo : ご飯（女性用茶碗）                                                  
                    break;
                case OCR_ITEM444:
                    errNo = 201;        // errNo : ご飯（男性用茶碗）                                                  
                    break;
                case OCR_ITEM445:
                    errNo = 202;        // errNo : ご飯（どんぶり茶碗）                                                
                    break;
                case OCR_ITEM446:
                    errNo = 203;        // errNo : おにぎり                                                            
                    break;
                case OCR_ITEM447:
                    errNo = 204;        // errNo : そば・うどん（天ぷら）                                              
                    break;
                case OCR_ITEM448:
                    errNo = 205;        // errNo : そば・うどん（たぬき）                                              
                    break;
                case OCR_ITEM449:
                    errNo = 206;        // errNo : そば・うどん（ざる・かけ）                                          
                    break;
                case OCR_ITEM450:
                    errNo = 207;        // errNo : ラーメン                                                            
                    break;
                case OCR_ITEM451:
                    errNo = 208;        // errNo : 五目ラーメン                                                        
                    break;
                case OCR_ITEM452:
                    errNo = 209;        // errNo : 焼きそば                                                            
                    break;
                case OCR_ITEM453:
                    errNo = 210;        // errNo : スパゲッティ（クリーム)                                             
                    break;
                case OCR_ITEM454:
                    errNo = 211;        // errNo : スパゲッティ（その他)                                               
                    break;
                case OCR_ITEM455:
                    errNo = 212;        // errNo : マカロニグラタン                                                    
                    break;
                case OCR_ITEM456:
                    errNo = 213;        // errNo : 食パン６枚切り                                                      
                    break;
                case OCR_ITEM457:
                    errNo = 214;        // errNo : 食パン８枚切り                                                      
                    break;
                case OCR_ITEM458:
                    errNo = 215;        // errNo : バター                                                              
                    break;
                case OCR_ITEM459:
                    errNo = 216;        // errNo : マーガリン                                                          
                    break;
                case OCR_ITEM460:
                    errNo = 217;        // errNo : ジャム類                                                            
                    break;
                case OCR_ITEM461:
                    errNo = 218;        // errNo : ミックスサンドイッチ                                                
                    break;
                case OCR_ITEM462:
                    errNo = 219;        // errNo : 菓子パン                                                            
                    break;
                case OCR_ITEM463:
                    errNo = 220;        // errNo : 調理パン                                                            
                    break;
                case OCR_ITEM464:
                    errNo = 221;        // errNo : カツ丼                                                              
                    break;
                case OCR_ITEM465:
                    errNo = 222;        // errNo : 親子丼                                                              
                    break;
                case OCR_ITEM466:
                    errNo = 223;        // errNo : 天丼                                                                
                    break;
                case OCR_ITEM467:
                    errNo = 224;        // errNo : 中華丼                                                              
                    break;
                case OCR_ITEM468:
                    errNo = 225;        // errNo : カレーライス                                                        
                    break;
                case OCR_ITEM469:
                    errNo = 226;        // errNo : チャーハン・ピラフ                                                  
                    break;
                case OCR_ITEM470:
                    errNo = 227;        // errNo : にぎり・ちらし寿司                                                  
                    break;
                case OCR_ITEM471:
                    errNo = 228;        // errNo : 幕の内弁当                                                          
                    break;
                case OCR_ITEM472:
                    errNo = 229;        // errNo : シリアル等                                                          
                    break;
                case OCR_ITEM473:
                    errNo = 230;        // errNo : ミックスピザ                                                        
                    break;
                case OCR_ITEM474:
                    errNo = 200;        // errNo : 刺身盛り合わせ                                                      
                    break;
                case OCR_ITEM475:
                    errNo = 201;        // errNo : 煮魚・焼魚（ぶり、さんま、いわし等）                                
                    break;
                case OCR_ITEM476:
                    errNo = 202;        // errNo : 煮魚・焼魚（かれい、たら、ひらめ等）                                
                    break;
                case OCR_ITEM477:
                    errNo = 203;        // errNo : 魚のムニエル                                                        
                    break;
                case OCR_ITEM478:
                    errNo = 204;        // errNo : エビチリ                                                            
                    break;
                case OCR_ITEM479:
                    errNo = 205;        // errNo : 八宝菜                                                              
                    break;
                case OCR_ITEM480:
                    errNo = 206;        // errNo : ステーキ(150g)                                                      
                    break;
                case OCR_ITEM481:
                    errNo = 207;        // errNo : 焼き肉                                                              
                    break;
                case OCR_ITEM482:
                    errNo = 208;        // errNo : とりの唐揚                                                          
                    break;
                case OCR_ITEM483:
                    errNo = 209;        // errNo : ハンバーグ                                                          
                    break;
                case OCR_ITEM484:
                    errNo = 210;        // errNo : シチュー                                                            
                    break;
                case OCR_ITEM485:
                    errNo = 211;        // errNo : 肉野菜炒め                                                          
                    break;
                case OCR_ITEM486:
                    errNo = 212;        // errNo : 餃子・シュウマイ                                                    
                    break;
                case OCR_ITEM487:
                    errNo = 213;        // errNo : ハム・ウィンナー                                                    
                    break;
                case OCR_ITEM488:
                    errNo = 214;        // errNo : ベーコン                                                            
                    break;
                case OCR_ITEM489:
                    errNo = 215;        // errNo : フライ（コロッケ）                                                  
                    break;
                case OCR_ITEM490:
                    errNo = 216;        // errNo : フライ（トンカツ）                                                  
                    break;
                case OCR_ITEM491:
                    errNo = 217;        // errNo : フライ（えび）                                                      
                    break;
                case OCR_ITEM492:
                    errNo = 218;        // errNo : 天ぷら                                                              
                    break;
                case OCR_ITEM493:
                    errNo = 219;        // errNo : すき焼き・しゃぶしゃぶ等                                            
                    break;
                case OCR_ITEM494:
                    errNo = 220;        // errNo : 寄鍋・たらちり等                                                    
                    break;
                case OCR_ITEM495:
                    errNo = 221;        // errNo : おでん                                                              
                    break;
                case OCR_ITEM496:
                    errNo = 222;        // errNo : 生卵・ゆで卵                                                        
                    break;
                case OCR_ITEM497:
                    errNo = 223;        // errNo : 目玉焼き                                                            
                    break;
                case OCR_ITEM498:
                    errNo = 224;        // errNo : 卵焼き                                                              
                    break;
                case OCR_ITEM499:
                    errNo = 225;        // errNo : スクランブル                                                        
                    break;
                case OCR_ITEM500:
                    errNo = 226;        // errNo : かに玉                                                              
                    break;
                case OCR_ITEM501:
                    errNo = 227;        // errNo : 冷・湯豆腐                                                          
                    break;
                case OCR_ITEM502:
                    errNo = 228;        // errNo : 納豆                                                                
                    break;
                case OCR_ITEM503:
                    errNo = 229;        // errNo : マーボ豆腐                                                          
                    break;
                case OCR_ITEM504:
                    errNo = 230;        // errNo : 五目豆                                                              
                    break;
                case OCR_ITEM505:
                    errNo = 200;        // errNo : 野菜サラダ                                                          
                    break;
                case OCR_ITEM506:
                    errNo = 201;        // errNo : ノンオイルドレッシング                                              
                    break;
                case OCR_ITEM507:
                    errNo = 202;        // errNo : マヨネーズ                                                          
                    break;
                case OCR_ITEM508:
                    errNo = 203;        // errNo : ドレッシング                                                        
                    break;
                case OCR_ITEM509:
                    errNo = 204;        // errNo : 塩                                                                  
                    break;
                case OCR_ITEM510:
                    errNo = 205;        // errNo : ポテト・マカロニサラダ                                              
                    break;
                case OCR_ITEM511:
                    errNo = 206;        // errNo : 煮物（芋入り）                                                      
                    break;
                case OCR_ITEM512:
                    errNo = 207;        // errNo : 煮物（野菜のみ）                                                    
                    break;
                case OCR_ITEM513:
                    errNo = 208;        // errNo : 煮物（ひじき・昆布等）                                              
                    break;
                case OCR_ITEM514:
                    errNo = 209;        // errNo : 肉じゃが                                                            
                    break;
                case OCR_ITEM515:
                    errNo = 210;        // errNo : 野菜炒め（肉なし）                                                  
                    break;
                case OCR_ITEM516:
                    errNo = 211;        // errNo : おひたし                                                            
                    break;
                case OCR_ITEM517:
                    errNo = 212;        // errNo : 酢の物                                                              
                    break;
                case OCR_ITEM518:
                    errNo = 213;        // errNo : 味噌汁                                                              
                    break;
                case OCR_ITEM519:
                    errNo = 214;        // errNo : コンソメ                                                            
                    break;
                case OCR_ITEM520:
                    errNo = 215;        // errNo : ポタージュ                                                          
                    break;
                case OCR_ITEM521:
                    errNo = 216;        // errNo : チーズ                                                              
                    break;
                case OCR_ITEM522:
                    errNo = 217;        // errNo : 枝豆                                                                
                    break;
                case OCR_ITEM523:
                    errNo = 218;        // errNo : 果物                                                                
                    break;
                case OCR_ITEM524:
                    errNo = 219;        // errNo : お漬物                                                              
                    break;
                case OCR_ITEM525:
                    errNo = 231;        // errNo : 生活習慣改善意志                                                       
                    break;
                case OCR_ITEM526:
                    errNo = 232;        // errNo : 保健指導利用                                                       
                    break;
            }

            return errNo;
        }


    }

    /// <summary>
    /// RslOcrSp内部クラス
    /// </summary>
    public class RslOcrSp
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
        /// (1:検査結果に存在する、
        /// 0:検査結果に存在しない）
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
