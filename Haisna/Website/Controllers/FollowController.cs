using Hainsi.Common.Constants;
using Hainsi.Entity;
using Hainsi.Entity.Model.Follow;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Hainsi.Controllers
{
    /// <summary>
    /// グループコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/followups")]
    public class FollowController : Controller
    {
        /// <summary>
        /// グループデータアクセスオブジェクト
        /// </summary>
        readonly FollowDao followDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="followDao">グループデータアクセスオブジェクト</param>
        public FollowController(FollowDao followDao)
        {
            this.followDao = followDao;
        }

        /// <summary>
        /// 指定予約番号のフォロー状況管理情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/followups/{judClassCd}")]
        public IActionResult GetFollowInfo(int rsvNo, int judClassCd)
        {
            dynamic ds = followDao.SelectFollow_Info(rsvNo, judClassCd);

            // データ件数が0件の場合
            if (ds == null)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// 結果情報の診断名を取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/followups/{judClassCd}/results")]
        public IActionResult GetFollowRslList(int rsvNo, int judClassCd)
        {
            IList<dynamic> ds = followDao.SelectFollowRslList(rsvNo, judClassCd);

            // データ件数が0件の場合
            if (ds == null || ds.Count <= 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// 受診者・検査項目毎に二次検査実施区分（医療施設区分）、判定結果を一括で登録・変更
        /// </summary>
        /// <param name="data">グループ情報
        /// rsvNo       予約番号[配列]
        /// judClassCd  検査項目（判定分類）[配列]
        /// secEquipDiv 二次検査実施区分（医療施設区分）[配列]
        /// judCd       判定結果[配列]
        /// updUser　   更新者
        /// </param>
        /// <response code="204">成功</response>
        [HttpPost]
        public IActionResult InsertFollowInfo([FromBody] FollowInfo data)
        {
            // セットデータのチェック
            IList<FollowResult> items = data.FollowResult;

            // 予約番号
            List<int> rsvNo = new List<int>();

            // 検査項目（判定分類）
            List<int> judClassCd = new List<int>();

            // 二次検査実施区分（医療施設区分）
            List<string> secEquipDiv = new List<string>();

            // 判定結果
            List<string> judCd = new List<string>();

            // 各配列値の更新処理
            foreach (var rec in items)
            {
                rsvNo.Add(Convert.ToInt32(rec.RsvNo));
                judClassCd.Add(Convert.ToInt32(rec.JudClassCd));
                secEquipDiv.Add(rec.SecEquipDiv);
                judCd.Add(Convert.ToString(rec.JudCd));
            }

            string updUser = HttpContext.Session.GetString("userid");
            updUser = "HAINS$";

            // 更新対象データが存在するときのみ判定結果保存
            followDao.InsertFollow_Info(rsvNo.ToArray(), judClassCd.ToArray(), secEquipDiv.ToArray(), judCd.ToArray(), updUser);

            // 正常時は204(No Content)を返す
            return NoContent();
        }

        /// <summary>
        /// フォローアップ情報更新処理
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">検査項目（判定分類）</param>
        /// <param name="data">
        /// secEquipDiv 二次検査実施（施設）区分
        /// updUser 更新者ID
        /// judCd 判定コード
        /// statusCd ステータス
        /// secEquipName 病医院名
        /// secEquipCourse 診療科
        /// secDoctor 担当医師
        /// secEquipAddr 住所
        /// secEquipTel 電話番号
        /// secPlanDate 二次検査予定日
        /// rsvTestUS 二次検査項目US
        /// rsvTestCT 二次検査項目CT
        /// rsvTestMRI 二次検査項目MRI
        /// rsvTestBF 二次検査項目BF
        /// rsvTestGF 二次検査項目GF
        /// rsvTestCF 二次検査項目CF
        /// rsvTestEM 二次検査項目注腸
        /// rsvTestTM 二次検査項目腫瘍マーカー
        /// rsvTestEtc 二次検査項目その他
        /// rsvTestRemark 二次検査項目その他コメント
        /// rsvTestRefer 二次検査項目リファー>
        /// rsvTestReferText 二次検査項目リファー科
        /// secRemark 備考
        /// secCslYear 二次実施日（年）
        /// secCslMonth 二次実施日（月）
        /// secCslDay 二次実施日（日）
        /// </param>
        /// <response code="204">成功</response>
        [HttpPut("~/api/v1/consultations/{rsvNo}/followups/{judClassCd}")]
        public IActionResult UpdateFollowInfo(int rsvNo, int judClassCd, [FromBody] UpdateFollow_Info data)
        {
            DateTime? secPlanDate;
            if (data.SecPlanDate == null)
            {
                secPlanDate = null;
            }
            else
            {
                secPlanDate = Convert.ToDateTime(data.SecPlanDate);
            }
            int secEquipDiv = Convert.ToInt32(data.SecEquipDiv);
            // string updUser = HttpContext.Session.GetString("userid");
            string updUser = "HAINS$";
            string judCd = data.JudCd;
            int statusCd = data.StatusCd == null ? 0 : Convert.ToInt32(data.StatusCd);
            string secEquipName = data.SecEquipName;
            string secEquipCourse = data.SecEquipCourse;
            string secDoctor = data.SecDoctor;
            string secEquipAddr = data.SecEquipAddr;
            string secEquipTel = data.SecEquipTel;
            int rsvTestUS = data.RsvTestUS == null ? 0 : Convert.ToInt32(data.RsvTestUS);
            int rsvTestCT = data.RsvTestCT == null ? 0 : Convert.ToInt32(data.RsvTestCT);
            int rsvTestMRI = data.RsvTestMRI == null ? 0 : Convert.ToInt32(data.RsvTestMRI);
            int rsvTestBF = data.RsvTestBF == null ? 0 : Convert.ToInt32(data.RsvTestBF);
            int rsvTestGF = data.RsvTestGF == null ? 0 : Convert.ToInt32(data.RsvTestGF);
            int rsvTestCF = data.RsvTestCF == null ? 0 : Convert.ToInt32(data.RsvTestCF);
            int rsvTestEM = data.RsvTestEM == null ? 0 : Convert.ToInt32(data.RsvTestEM);
            int rsvTestTM = data.RsvTestTM == null ? 0 : Convert.ToInt32(data.RsvTestTM);
            int rsvTestEtc = data.RsvTestEtc == null ? 0 : Convert.ToInt32(data.RsvTestEtc);
            string rsvTestRemark = data.RsvTestRemark;
            int rsvTestRefer = data.RsvTestRefer == null ? 0 : Convert.ToInt32(data.RsvTestRefer);
            string rsvTestReferText = data.RsvTestReferText;
            string secRemark = data.SecRemark;

            // 請求書コメントの妥当性チェックを行う
            List<string> messages = followDao.ValidateFollow_Info(secEquipName, secEquipCourse, secDoctor, secEquipAddr, secEquipTel, secRemark);
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            //フォローアップ情報更新処理
            followDao.UpdateFollow_Info(rsvNo,
                                        judClassCd,
                                        secEquipDiv,
                                        updUser,
                                        judCd,
                                        statusCd,
                                        secEquipName,
                                        secEquipCourse,
                                        secDoctor,
                                        secEquipAddr,
                                        secEquipTel,
                                        secPlanDate,
                                        rsvTestUS,
                                        rsvTestCT,
                                        rsvTestMRI,
                                        rsvTestBF,
                                        rsvTestGF,
                                        rsvTestCF,
                                        rsvTestEM,
                                        rsvTestTM,
                                        rsvTestEtc,
                                        rsvTestRemark,
                                        rsvTestRefer,
                                        rsvTestReferText,
                                        secRemark);

            // 正常時は204(No Content)を返す
            return NoContent();
        }

        /// <summary>
        /// フォローガイドの入力チェック
        /// </summary>
        /// <param name="data">
        /// secPlanYear 二次検査予定日（年）
        /// secPlanMonth 二次検査予定日（月）
        /// secPlanDay 二次検査予定日（日）
        /// secPlanDate 二次検査予定日
        /// secEquipName 病医院名
        /// secEquipCourse 診療科
        /// secDoctor 担当医師
        /// secEquipAddr 住所
        /// secEquipTel 電話番号
        /// secRemark 備考
        /// </param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost("validation")]
        public IActionResult CheckFollow(JToken data)
        {
            string secEquipName = Convert.ToString(data["secequipname"]);
            string secEquipCourse = Convert.ToString(data["secequipcourse"]);
            string secDoctor = Convert.ToString(data["secdoctor"]);
            string secEquipAddr = Convert.ToString(data["secequipaddr"]);
            string secEquipTel = Convert.ToString(data["secequiptel"]);
            string secRemark = Convert.ToString(data["secremark"]);

            // 入力データバリデーション
            List<string> messages = followDao.ValidateFollow_Info(secEquipName,
                                                              secEquipCourse,
                                                              secDoctor,
                                                              secEquipAddr,
                                                              secEquipTel,
                                                              secRemark);

            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            return NoContent();
        }

        /// <summary>
        /// フォローアップ情報承認（又は承認解除）処理
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">検査項目（判定分類）</param>
        /// <param name="reqConfirmFlg">結果承認処理区分（0：承認取消、1：承認）</param>
        /// <response code="204">成功</response>
        [HttpPut("~/api/v1/consultations/{rsvNo}/followups/{judClassCd}/approval")]
        public IActionResult UpdateFollowInfoConfirm(int rsvNo, int judClassCd, string reqConfirmFlg)
        {

            string updUser = HttpContext.Session.GetString("userid");
            updUser = "HAINS$";

            //フォローアップ情報更新処理
            followDao.UpdateFollow_Info_Confirm(rsvNo, judClassCd, reqConfirmFlg, updUser);

            // 正常時は204(No Content)を返す
            return NoContent();
        }

        /// <summary>
        /// フォローアップ情報削除処理
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <response code="204">成功</response>
        [HttpDelete("~/api/v1/consultations/{rsvNo}/followups/{judClassCd}")]
        public IActionResult DeleteFollowInfo(int rsvNo, int judClassCd)
        {
            string updUser = HttpContext.Session.GetString("userid");
            updUser = "HAINS$";

            followDao.DeleteFollow_Info(rsvNo, judClassCd, updUser);

            // 正常時は204(No Content)を返す
            return NoContent();
        }

        /// <summary>
        /// 二次検査結果情報別疾患（診断名）情報取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="seq">一連番号</param>
        /// <param name="rslFlg">結果抽出区分</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/followups/{judClassCd}/diseases")]
        public IActionResult GetFollowRslItemList(int rsvNo, int judClassCd, int seq, bool rslFlg = false)
        {
            IList<dynamic> ds = followDao.SelectFollowRslItemList(rsvNo, judClassCd, seq, rslFlg);

            // データ件数が0件の場合
            if (ds == null || ds.Count <= 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// 指定日付（受診日）範囲の勧奨対象者リスト取得する
        /// </summary>
        /// <param name="startCslDate">開始受診日</param>
        /// <param name="endCslDate">終了受診日</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="pastMonth">経過月数</param>
        /// <param name="startPos">表示開始位置</param>
        /// <param name="pageMaxLine">１ページ表示ＭＡＸ行</param>
        /// <param name="checkDateStat">勧奨日条件チェック</param>
        /// <param name="countFlg">集計フラグ(true:予約番号が重複しない件数、false:レコード件数)</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/followups/exhortations")]
        public IActionResult GetExhortList(DateTime? startCslDate,
                                                 DateTime? endCslDate,
                                                 int? judClassCd,
                                                 int pastMonth,
                                                 int startPos,
                                                 int pageMaxLine,
                                                 string checkDateStat,
                                                 bool countFlg = false)
        {
            string updUser = HttpContext.Session.GetString("userid");

            PartialDataSet item = followDao.SelectExhortList(startCslDate,
                                                    endCslDate,
                                                    judClassCd,
                                                    updUser,
                                                    pastMonth,
                                                    startPos,
                                                    pageMaxLine,
                                                    checkDateStat,
                                                    false);

            // データ件数が0件の場合
            if (item.TotalCount == 0)
            {
                return NotFound();
            }

            PartialDataSet exhortItems = null;

            // データ件数が0件の場合
            if (item.TotalCount > 0)
            {
                exhortItems = followDao.SelectExhortList(startCslDate,
                                                 endCslDate,
                                                 judClassCd,
                                                 updUser,
                                                 pastMonth,
                                                 startPos,
                                                 pageMaxLine,
                                                 checkDateStat,
                                                 true);
            }

            var data = new Dictionary<string, dynamic>
            {
                { "exhortitems", exhortItems},
                { "allcount", item.TotalCount},
                { "allexhortitemcount",exhortItems.TotalCount}
            };

            return Ok(data);
        }

        /// <summary>
        /// 指定予約番号の直前のフォロー情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns>フォロー情報</returns>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/followups/before")]
        public IActionResult GetFollowBefore(int rsvNo)
        {
            dynamic ds = followDao.SelectFollow_Before(rsvNo);

            // データ件数が0件の場合
            if (ds == null)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// 指定個人IDのフォロー情報の受診歴一覧を取得する
        /// </summary>
        /// <param name="perId">個人ID</param>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/people/{perId}/followups/histories")]
        public IActionResult GetFollowHistory(string perId, int rsvNo)
        {
            IList<dynamic> ds = followDao.SelectFollowHistory(perId, rsvNo);

            // データ件数が0件の場合
            if (ds == null || ds.Count <= 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// フォロー対象検査項目を取得する
        /// </summary>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("items")]
        public IActionResult GetFollowItem()
        {
            dynamic ds = followDao.SelectFollowItem();

            // データ件数が0件の場合
            if (ds == null)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// 指定予約番号の基準値以上判定情報（フォロー対象情報）を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judFlg">結果抽出区分</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/followups/target")]
        public IActionResult GetTargetFollow(int rsvNo, bool judFlg)
        {
            IList<dynamic> ds = followDao.SelectTargetFollow(rsvNo, judFlg);

            // データ件数が0件の場合
            if (ds == null || ds.Count <= 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// 指定日付（受診日）範囲のフォローアップ対象者及び選択者を取得する
        /// </summary>
        /// <param name="startCslDate">開始受診日</param>
        /// <param name="endCslDate">終了受診日</param>
        /// <param name="perId">個人ID</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="equipDiv">フォロー(二次検査施設)区分</param>
        /// <param name="confirmDiv">二次検査結果承認区分</param>
        /// <param name="addUser">フォローアップ初期登録者ID</param>
        /// <param name="pageMaxLine">1ページ表示MAX行</param>
        /// <param name="startPos">表示開始位置</param>
        /// <param name="countFlg">集計フラグ(true:予約番号が重複しない件数、false:レコード件数)</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/followups/target")]
        public IActionResult GetTargetFollowList(
            DateTime? startCslDate,
            DateTime? endCslDate,
            string perId,
            string judClassCd,
            string equipDiv,
            string confirmDiv,
            string addUser,
            int pageMaxLine,
            int startPos,
            bool countFlg = false)
        {
            // 検索条件を満たしかつ指定開始位置、件数分のレコードを取得
            startPos = (startPos - 1) * pageMaxLine + 1;
            PartialDataSet ds = followDao.SelectTargetFollowList(
                                   startCslDate,
                                   endCslDate,
                                   perId,
                                   judClassCd,
                                   equipDiv,
                                   confirmDiv,
                                   addUser,
                                   pageMaxLine,
                                   startPos,
                                   countFlg = false);

            // データ件数が0件の場合
            if (ds.TotalCount == 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// 指定検索条件の変更履歴を取得する
        /// </summary>
        /// <param name="startUpdDate">検索条件：更新日（開始）</param>
        /// <param name="endUpdDate">検索条件：更新日（終了）</param>
        /// <param name="searchUpdUser">検索条件：更新者</param>
        /// <param name="searchUpdClass">検索条件：更新分類（０：すべて）</param>
        /// <param name="orderbyItem">並べ替え項目(0:更新日,1:更新者,2:分類・項目）</param>
        /// <param name="orderbyMode">並べ替え方法(0:昇順,1:降順)</param>
        /// <param name="page">取得開始位置</param>
        /// <param name="limit">１ページ表示ＭＡＸ行（０：ＭＡＸ行指定無し）</param>
        /// <param name="rsvNo">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("logs")]
        public IActionResult GetFollowLogList(DateTime? startUpdDate, DateTime? endUpdDate,
          string searchUpdUser, string searchUpdClass, int orderbyItem, int orderbyMode, int page, int limit, int? rsvNo)
        {
            // 検索条件を満たしかつ指定開始位置、件数分のレコードを取得
            int startPos = (page - 1) * limit + 1;
            PartialDataSet ds = followDao.SelectFollowLogList(startUpdDate, endUpdDate, searchUpdUser, searchUpdClass, orderbyItem, orderbyMode, startPos, limit, rsvNo);

            // データ件数が0件の場合
            if (ds.Data.Count == 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// フォローアップ結果情報を取得する（受診者・判定分類別特定結果情報）
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="seq">一連番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/{judClassCd}/{seq}/followups")]
        public IActionResult GetFollowRsl(int rsvNo, int judClassCd, int seq)
        {
            dynamic ds = followDao.SelectFollow_Rsl(rsvNo, judClassCd, seq);

            return Ok(ds);
        }

        /// <summary>
        /// 指定予約番号、判定分類、SEQのフォローアップ結果情報を削除します。
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="seq">SEQ</param>
        /// <response code="204">成功</response>
        [HttpDelete("~/api/v1/consultations/{rsvNo}/followups/{judClassCd}/{seq}")]
        public IActionResult DeleteFollowRsl(int rsvNo, int judClassCd, int seq)
        {
            // string updUser = HttpContext.Session.GetString("userid");
            string updUser = "HAINS$";

            followDao.DeleteFollow_Rsl(rsvNo, judClassCd, seq, updUser);

            // 正常時は204(No Content)を返す
            return NoContent();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="seq">SEQ</param>
        /// <param name="data">
        /// secCslDate     二次検査年月日
        /// updUser        更新者
        /// testUS         検査方法US
        /// testCT         検査方法CT
        /// testMRI        検査方法MRI
        /// testBF         検査方法BF
        /// testGF         検査方法GF
        /// testCF         検査方法CF
        /// testEM         検査方法EM
        /// testTM         検査方法TM
        /// testEtc        検査方法その他
        /// testRemark     検査方法その他コメント
        /// testRefer      リファー
        /// testReferText  リファー科
        /// resultDiv      二次検査結果
        /// disRemark      疾患その他コメント
        /// polWithout     処置不要
        /// polFollowup    経過観察
        /// polMonth       経過観察期間
        /// polReExam      １年後健診
        /// polDiagSt      本院紹介精査
        /// polDiag        他院紹介精査
        /// polEtc1        治療なしその他
        /// polRemark1     治療なしその他コメント
        /// polSugery      外科治療
        /// polEndoscope   内視鏡的治療
        /// polChemical    化学療法
        /// polRadiation   放射線治療
        /// polReferSt     本院紹介治療
        /// polRefer       他院紹介治療
        /// polEtc2        治療ありその他
        /// polRemark2     治療ありその他コメント
        /// itemCd         検査項目コード
        /// suffix         サフィックス
        /// result         結果
        /// newSeq         新しいSEQ
        /// </param>
        /// <response code="204">成功</response>
        [HttpPut("~/api/v1/consultations/{rsvNo}/followups/{judClassCd}/{seq}/rsl")]
        public IActionResult UpdateFollowRsl(int rsvNo, int judClassCd, int seq, [FromBody] UpdateFollow_Rsl data)
        {
            DateTime? secCslDate;
            if (data.SecCslDate == null)
            {
                secCslDate = null;
            }
            else
            {
                secCslDate = Convert.ToDateTime(data.SecCslDate);
            }
            string updUser = "HAINS$";
            string testUS = data.TestUS;
            string testCT = data.TestCT;
            string testMRI = data.TestMRI;
            string testBF = data.TestBF;
            string testGF = data.TestGF;
            string testCF = data.TestCF;
            string testEM = data.TestEM;
            string testTM = data.TestTM;
            string testEtc = data.TestEtc;
            string testRemark = data.TestRemark;
            string testRefer = data.TestRefer;
            string testReferText = data.TestReferText;
            string resultDiv = data.ResultDiv;
            string disRemark = data.DisRemark;
            string polWithout = data.PolWithout;
            string polFollowup = data.PolFollowup;
            string polMonth = null;
            if (data.PolMonth != null)
            {
                polMonth = data.PolMonth.Trim();
            }
            string polReExam = data.PolReExam;
            string polDiagSt = data.PolDiagSt;
            string polDiag = data.PolDiag;
            string polEtc1 = data.PolEtc1;
            string polRemark1 = data.PolRemark1;
            string polSugery = data.PolSugery;
            string polEndoscope = data.PolEndoscope;
            string polChemical = data.PolChemical;
            string polRadiation = data.PolRadiation;
            string polReferSt = data.PolReferSt;
            string polRefer = data.PolRefer;
            string polEtc2 = data.PolEtc2;
            string polRemark2 = data.PolRemark2;
            string[] itemCd = data.ItemCd;
            string[] suffix = data.Suffix;
            string[] result = data.Result;
            int newSeq;


            // 請求書コメントの妥当性チェックを行う
            List<string> messages = followDao.ValidateFollow_Rsl(polMonth, testRemark, disRemark, polRemark1, polRemark2);
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            //フォローアップ情報更新処理
            followDao.UpdateFollow_Rsl(rsvNo,
                                        judClassCd,
                                        seq,
                                        secCslDate,
                                         updUser,
                                         testUS,
                                         testCT,
                                         testMRI,
                                         testBF,
                                         testGF,
                                         testCF,
                                         testEM,
                                         testTM,
                                         testEtc,
                                         testRemark,
                                         testRefer,
                                         testReferText,
                                         resultDiv,
                                         disRemark,
                                         polWithout,
                                         polFollowup,
                                         polMonth,
                                         polReExam,
                                         polDiagSt,
                                         polDiag,
                                         polEtc1,
                                         polRemark1,
                                         polSugery,
                                         polEndoscope,
                                         polChemical,
                                         polRadiation,
                                         polReferSt,
                                         polRefer,
                                         polEtc2,
                                         polRemark2,
                                         itemCd,
                                         suffix,
                                         result,
                                         out newSeq);

            // 正常時は204(No Content)を返す
            return NoContent();
        }

        /// <summary>
        /// 受診者別検査項目別結果データ取得
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="itemCd">検査項目コード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/consultations/{rsvNo}/followups/{itemCd}/result")]
        public IActionResult GetResult(int rsvNo, string itemCd)
        {
            string result = followDao.GetResult(rsvNo, itemCd);

            return Ok(result);
        }
    }
}
