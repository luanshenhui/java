using Hainsi.Common.Constants;
using Hainsi.Entity;
using Hainsi.Entity.Model.PubNote;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// #ToDo
    /// PubNoteコントローラ（暫定）
    /// </summary>
    //[Authorize]
    [Route("api/v1/pubnotes")]
    public class PubNoteController : Controller
    {
        /// <summary>
        /// データアクセスオブジェクト
        /// </summary>
        readonly PubNoteDao pubNoteDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="pubNoteDao">データアクセスオブジェクト</param>
        public PubNoteController(PubNoteDao pubNoteDao)
        {
            this.pubNoteDao = pubNoteDao;
        }

        /// <summary>
        /// 指定された条件のコメントを取得する
        /// </summary>
        /// <param name="selInfo">検索情報（1:受診情報、2:個人、3:団体、4:契約 0:個人＋受診情報)</param>
        /// <param name="histFlg">0:今回のみ、1:過去のみ、2:全件</param>
        /// <param name="startDate">表示期間（開始日）</param>
        /// <param name="endDate">表示期間（終了日）</param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <param name="seq">０のとき全件</param>
        /// <param name="pubNoteDivCd">受診情報ノート分類コード</param>
        /// <param name="dispKbn">表示対象</param>
        /// <param name="incDelNote">1:削除データも結果に含める</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet(Name = "GetBySeq")]
        public IActionResult GetPubNote(
            int selInfo, 
            int histFlg, 
            string startDate = null, 
            string endDate = null, 
            int rsvNo = 0, 
            string perId = null,
            string orgCd1 = null, 
            string orgCd2 = null, 
            string ctrPtCd = null, 
            int seq = 0, 
            string pubNoteDivCd = null, 
            int dispKbn = 0, 
            string incDelNote = null)
        {
            // ユーザー TODO
            //string userId = HttpContext.Session.GetString("userId");
            string userId = "HAINS$";

            List<dynamic> list = pubNoteDao.SelectPubNote(selInfo, histFlg, startDate, endDate, rsvNo, perId,
                orgCd1, orgCd2, ctrPtCd, seq, pubNoteDivCd, dispKbn, userId, incDelNote);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 指定ユーザに対して権限のあるノート分類の一覧を取得する
        /// </summary>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/users/me/pubnotedivisions")]
        public IActionResult GetPubNoteDivList()
        {
            // ユーザー TODO
            //string userId = HttpContext.Session.GetString("userId");
            string userId = "HAINS$";
            List <dynamic> list = pubNoteDao.SelectPubNoteDivList(userId);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// ノート分類コードに対するノート分類名を取得する
        /// </summary>
        /// <param name="pubNoteDivCd">ノート分類コード</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("~/api/v1/users/me/pubnotedivision")]
        public dynamic GetPubNoteDiv(string pubNoteDivCd)
        {
            dynamic data = pubNoteDao.SelectPubNoteDiv(pubNoteDivCd);

            // データ件数が0件の場合
            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// コメントを登録する
        /// </summary>
        /// <param name="data">コメント情報</param>
        /// <returns></returns>
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        [HttpPost]
        public IActionResult InsertPubNote([FromBody] CommentPubNote data)
        {
            IList<string> messages = pubNoteDao.CheckPubNoteValue(data);
            if(messages.Count>0)
            {
                return BadRequest(messages);
            }

            // 更新ユーザー TODO
            //string userId = HttpContext.Session.GetString("userId");
            string userId = "HAINS$";
            data.UpdUser = userId;

            // コメント情報の新規作成を行う
            Insert ret = pubNoteDao.EntryPubNote("insert", data, out int newSeq);

            // 新規レコードが作成された場合にREST APIでレスポンスデータを返す標準的な方法
            return CreatedAtRoute("GetBySeq", data);
        }

        /// <summary>
        /// コメントを更新する
        /// </summary>
        /// <param name="seq">SEQ</param>
        /// <param name="data">コメント情報</param>
        /// <returns></returns>
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        [HttpPut("{seq}")]
        public IActionResult UpdatePubNote(string seq, [FromBody] CommentPubNote data)
        {
            IList<string> messages = pubNoteDao.CheckPubNoteValue(data);
            if (messages.Count > 0)
            {
                return BadRequest(messages);
            }

            // 更新ユーザー TODO
            //string userId = HttpContext.Session.GetString("userId");
            string userId = "HAINS$";
            data.UpdUser = userId;

            // コメント情報の更新作成を行う
            Insert ret = pubNoteDao.EntryPubNote("update", data, out int newSeq);

            // 正常時は204(No Content)を返す
            return NoContent();
        }

        /// <summary>
        /// コメントを削除する
        /// </summary>
        /// <param name="selInfo">検索情報（1:受診情報、2:個人、3:団体、4:契約）</param>
        /// <param name="seq"></param>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="perId">個人ＩＤ</param>
        /// <param name="orgCd1">団体コード１</param>
        /// <param name="orgCd2">団体コード２</param>
        /// <param name="ctrPtCd">契約パターンコード</param>
        /// <returns></returns>
        [HttpDelete("{seq}")]
        public IActionResult DeletePubNote(int selInfo, int seq, int? rsvNo = null, string perId = null, string orgCd1 = null, string orgCd2 = null, string ctrPtCd = null)
        {
            // コメント情報の更新作成を行う
            Insert ret = pubNoteDao.DeletePubNote(selInfo, seq, rsvNo, perId, orgCd1, orgCd2, ctrPtCd);

            // 正常時は204(No Content)を返す
            return NoContent();
        }
    }
}
