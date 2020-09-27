using Hainsi.Common;
using Hainsi.Entity;
using Hainsi.Entity.Model.Person;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 個人アクセス用WebAPIコントローラークラス
    /// </summary>
    //[Authorize]
    [Route("api/v1/people")]
    public class PersonController : Controller
    {
        /// <summary>
        /// 個人データアクセスオブジェクト
        /// </summary>
        readonly PersonDao personDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="personDao">個人データアクセスオブジェクト</param>
        public PersonController(PersonDao personDao)
        {
            this.personDao = personDao;
        }

        /// <summary>
        /// 指定個人IDの個人情報を削除します。
        /// </summary>
        /// <param name="perId">個人ID</param>
        [HttpDelete("{perId}")]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(String), 400)]
        public IActionResult DeletePerson(string perId)
        {
            int ret = personDao.DeletePerson(perId);

            string message = "";
            switch (ret)
            {
                case 0:
                    return NoContent();
                case -1:
                    message = "アフターケア情報が存在します。削除できません。";
                    break;
                case -2:
                    message = "受診情報が存在します。削除できません。";
                    break;
                case -3:
                    message = "傷病休業情報が存在します。削除できません。";
                    break;
                case -4:
                    message = "就労情報が存在します。削除できません。";
                    break;
                default:
                    message = "その他のエラーが発生しました" + "（エラーコード＝ " + ret + "）。";
                    break;
            }
            return BadRequest(message);
        }

        /// <summary>
        /// 指定個人IDの個人情報を取得します。
        /// </summary>
        /// <param name="perId">個人ID</param>
        [HttpGet("{perId}", Name = "GetByPerId")]
        [ProducesResponseType(typeof(SelectPerson), 200)]
        [ProducesResponseType(404)]
        public IActionResult GetPerson_lukes(string perId)
        {
            dynamic data = personDao.SelectPerson_lukes(perId);

            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定個人IDの個人住所情報を取得します。
        /// </summary>
        /// <param name="perId">個人ID</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{perId}/addresses")]
        public IActionResult GetPersonAddr(string perId)
        {
            List<dynamic> list = personDao.SelectPersonAddr(perId);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 指定個人IDの個人属性情報を取得します。
        /// </summary>
        /// <param name="perId">個人ID</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{perId}/details")]
        public IActionResult GetPersonDetaillukes(string perId)
        {
            dynamic data = personDao.SelectPersonDetail_lukes(perId);

            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 指定個人IDの個人情報を取得します（簡易版）。
        /// </summary>
        /// <param name="perId">個人ID</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("{perId}/informations")]
        public IActionResult GetPersonInf(string perId)
        {
            dynamic data = personDao.SelectPersonInf(perId);

            if (data == null)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 検索条件を満たす個人情報の一覧を取得します。
        /// </summary>
        /// <param name="keyword">検索キーの集合</param>
        /// <param name="addrDiv">住所区分</param>
        /// <param name="page">開始位置</param>
        /// <param name="limit">取得件数</param>
        /// <param name="birth">生年月日</param>
        /// <param name="gender">性別</param>
        /// <param name="romeNameMultiple">複合検索フラグ</param>
        /// <param name="delFlgUseOnly">True指定時は削除フラグが"0"(使用中)のレコードのみ検索</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet]
        public IActionResult GetPersonList(string keyword, int addrDiv, int page, int limit, DateTime? birth = null, int gender = 0, bool romeNameMultiple = false, bool delFlgUseOnly = false)
        {
            // 半角カナを全角カナに変換する
            keyword = WebHains.StrConvKanaWide(keyword);

            // 小文字を大文字に変換する
            keyword = string.IsNullOrEmpty(keyword) ? "" : keyword.ToUpper();

            // 全角空白を半角空白に置換する
            keyword = keyword.Replace('　', ' ');

            // レコード数の取得
            int totalCount = personDao.SelectPersonListCount(keyword, birth, gender, romeNameMultiple, delFlgUseOnly);
            if (totalCount == 0)
            {
                return NotFound();
            }

            // レコードの取得
            int startPos = (page - 1) * limit + 1;
            IList<dynamic> data = personDao.SelectPersonList(keyword, addrDiv, startPos, limit, birth, gender, romeNameMultiple, delFlgUseOnly);

            return Ok(new { totalCount, data });
        }

        /// <summary>
        /// 検索条件を満たす個人情報の件数を取得します。
        /// </summary>
        /// <param name="keyword">検索キーの集合</param>
        /// <param name="birth">生年月日</param>
        /// <param name="gender">性別</param>
        /// <param name="romeNameMultiple">複合検索フラグ</param>
        /// <param name="delFlgUseOnly">True指定時は削除フラグが"0"(使用中)のレコードのみ検索</param>
        /// <response code="200">成功</response>
        [HttpGet("count")]
        public IActionResult GetPersonListCount(string keyword, DateTime? birth = null, int gender = 0, bool romeNameMultiple = false, bool delFlgUseOnly = false)
        {
            int ret = personDao.SelectPersonListCount(keyword, birth, gender, romeNameMultiple, delFlgUseOnly);

            return Ok(ret);
        }

        /// <summary>
        /// 個人情報各値の妥当性チェックを行います。
        /// </summary>
        /// <param name="data">個人情報</param>
        /// <param name="perId">個人情報</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost("{perId}/validation")]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult ValidateForMntPersonal( [FromBody] Person data, string perId= null)
        {
            IList<string> messages = personDao.ValidateForMntPersonal(data, perId);
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            return NoContent();
        }

        /// <summary>
        /// 個人情報を作成します。
        /// </summary>
        /// <param name="data">個人情報</param>
        [HttpPost]
        [ProducesResponseType(typeof(SelectPerson), 201)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult Insert([FromBody] InsertPerson data)
        {
            string refPerId = data.PerId;

            IList<string> checkMessages = personDao.ValidateForMntPersonal(data, refPerId);
            if ((checkMessages != null) && (checkMessages.Count > 0))
            {
                return BadRequest(checkMessages);
            }

            // 更新ユーザー
            data.UpdUser = data.UpdUser ?? HttpContext.Session.GetString("userId");
            // TODO
            data.UpdUser = "HAINS$";

            // 個人情報の新規作成を行う
            List<string> messages = personDao.UpdateAllPersonInfo_lukes("insert", ref refPerId, data);
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            // 正常に作成された場合は作成時に得られた個人IDをキーに個人情報を読む
            dynamic person = personDao.SelectPerson_lukes(refPerId);

            // 新規レコードが作成された場合にREST APIでレスポンスデータを返す標準的な方法
            // ・レスポンスステータスコードには201を設定する
            // ・第１引数でGetPerson_lukesメソッドで定義した"GetByPerId"という名前を指定
            // ・第２引数はGetPerson_lukesメソッドのperId値にrefPerIdを設定する、という意味
            // ・第３引数で直前で取得したperson(個人情報が格納されている)を指定
            // ・この指定により、personの内容がJSONで返されると同時に、レスポンスヘッダに次の行が追加される
            //   Location: http://localhost:(Port)/api/v1/people/(refPerIdの値)
            return CreatedAtRoute("GetByPerId", new { perId = refPerId }, person);
        }

        /// <summary>
        /// 指定個人IDの個人情報を更新します。
        /// </summary>
        /// <param name="perId">個人ID</param>
        /// <param name="data">個人情報</param>
        [HttpPut("{perId}")]
        [ProducesResponseType(204)]
        [ProducesResponseType(typeof(List<string>), 400)]
        public IActionResult Update(string perId, [FromBody] Person data)
        {
            IList<string> checkMessages = personDao.ValidateForMntPersonal(data, perId);
            if ((checkMessages != null) && (checkMessages.Count > 0))
            {
                return BadRequest(checkMessages);
            }

            // 更新ユーザー
            data.UpdUser = HttpContext.Session.GetString("userId");
            // TODO
            data.UpdUser = "HAINS$";

            // 個人情報を更新する
            List<string> messages = personDao.UpdateAllPersonInfo_lukes("update", ref perId, data);
            if ((messages != null) && (messages.Count > 0))
            {
                return BadRequest(messages);
            }

            // 正常時は204(No Content)を返す
            return NoContent();
        }
    }
}
