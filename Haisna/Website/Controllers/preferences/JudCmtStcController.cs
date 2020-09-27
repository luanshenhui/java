using Hainsi.Common.Constants;
using Hainsi.Entity;
using Hainsi.Entity.Model;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 判定コメント用WebAPIコントローラークラス
    /// </summary>
    //[Authorize]
    [Route("api/v1/judgescomments")]
    public class JudCmtStcController : Controller
    {
        /// <summary>
        /// 判定コメントデータアクセスオブジェクト
        /// </summary>
        readonly JudCmtStcDao judCmtStcDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="judCmtStcDao">判定コメントデータアクセスオブジェクト</param>
        public JudCmtStcController(JudCmtStcDao judCmtStcDao)
        {
            this.judCmtStcDao = judCmtStcDao;
        }

        /// <summary>
        /// 検索条件を満たす判定コメントの一覧を取得します。
        /// </summary>
        /// <param name="judClassCd">判定分類コード</param>
        /// <param name="key">検索キーの集合</param>
        /// <param name="page">ページ番号</param>
        /// <param name="limit">ページ当たりの最大件数</param>
        /// <param name="searchCode">検索用コード</param>
        /// <param name="searchString">検索用文字列</param>
        /// <param name="searchModeFlg">検索条件(0:判定分類の無いコメントも取得、0以外:判定分類の一致するコメントのみ)</param>
        /// <param name="recogLevel">認識レベル</param>
        /// <param name="getHihyouji">非表示(0:非表示は取得しない　0以外:すべて取得)</param>
        [HttpGet]
        [ProducesResponseType(typeof(PartialDataSet<JudgesComment>), 200)]
        [ProducesResponseType(404)]
        public IActionResult SelectJudCmtStcList(
            int? judClassCd = null,
            string[] key = null,
            int? page = null,
            int? limit = null,
            string searchCode = null,
            string searchString = null,
            int searchModeFlg = 0,
            int? recogLevel = null,
            int getHihyouji = 0
        )
        {
            // 開始位置を計算
            int? startPos = ((page != null) && (limit != null)) ? (page - 1) * limit : null;

            // 判定コメント一覧の取得
            PartialDataSet<dynamic> data = judCmtStcDao.SelectJudCmtStcList(judClassCd, key, startPos, limit, searchCode, searchString, searchModeFlg, recogLevel, getHihyouji);

            // データ件数が0件の場合
            if (data.TotalCount == 0)
            {
                return NotFound();
            }

            return Ok(data);
        }

        /// <summary>
        /// 判定コメント情報取得
        /// </summary>
        /// <param name="id">判定コメントコード</param>
        /// <returns></returns>
        [HttpGet("{id}", Name = "GetJudCmtStcById")]
        public IActionResult GetById(string id)
        {
            dynamic rec = judCmtStcDao.SelectJudCmtStcnew(id);

            // 指定グループが存在しない場合
            if (rec == null)
            {
                return NotFound();
            }

            return Ok(rec);
        }

        /// <summary>
        /// 新規登録
        /// </summary>
        /// <param name="data">判定コメント情報</param>
        /// <returns></returns>
        [HttpPost]
        public IActionResult Create([FromBody] JToken data)
        {
            //// 入力データバリデーション
            //IActionResult response = CreateBadRequest(judCmtStcDao.Validate(data));
            //if (response != null)
            //{
            //	return response;
            //}

            // 新規レコード挿入
            Insert result = judCmtStcDao.RegistJudCmtStc1("INS", data);

            // 登録結果が0件の場合、重複ステータスを返す
            if (result == Insert.Duplicate)
            {
                return StatusCode(StatusCodes.Status409Conflict);
            }

            return CreatedAtRoute("GetJudCmtStcById", new { id = data["judcmtcd"] }, data);
        }

        /// <summary>
        /// 更新処理
        /// </summary>
        /// <param name="id">判定コメントコード</param>
        /// <param name="data">判定コメント情報</param>
        /// <returns></returns>
        [HttpPut]
        public IActionResult Update(string id, [FromBody]JToken data)
        {
            // 判定コメントコードはURLで指定されたものを使う
            data["grpcd"] = id;

            //// 入力データバリデーション
            //IActionResult response = CreateBadRequest(judCmtStcDao.Validate(data));
            //if (response != null)
            //{
            //	return response;
            //}

            //int count = dao.RegistJudCmtStc1("UPD", data);

            // 更新されていなければ409
            //if (count == 0)
            //{
            //	return Conflict();
            //}

            //return Ok();

            Insert result = judCmtStcDao.RegistJudCmtStc1("UPD", data);

            // 重複していれば409
            if (result == Insert.Duplicate)
            {
                return StatusCode(StatusCodes.Status409Conflict);
            }

            return Ok();
        }

        /// <summary>
        /// 削除処理
        /// </summary>
        /// <param name="id">判定コメントコード</param>
        /// <returns></returns>
        [HttpDelete("{id}")]
        public IActionResult Delete(string id)
        {
            //int count = judCmtStcDao.DeleteJudCmtStc(id);

            ////削除対象がなければ404
            //if (count == 0)
            //{
            //	return NotFound();
            //}

            bool result = judCmtStcDao.DeleteJudCmtStc(id);

            // #ToDo booleanを戻り値にした場合、削除件数の把握ができず、レスポンスコードに404を返すかどうかの判断ができない

            return NoContent();
        }
    }
}
