using Hainsi.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Hainsi.Controllers
{
    /// <summary>
    /// 個人アクセス用WebAPIコントローラークラス
    /// </summary>
    [Authorize]
	public class PersonGuideController : BaseApiController
	{

        ///// <summary>
        ///// 個人のリストを取得します。
        ///// </summary>
        ///// <param name="keyword">検索キーワード</param>
        ///// <param name="page">ページ番号</param>
        ///// <param name="limit">検索件数</param>
        ///// <response code="200">成功</response>
        ///// <response code="404">データなし</response>
        //public IHttpActionResult Get(string keyword = "", int page = 1, int limit = 20)
        //{
        //    var count = 0;
        //    Func<int, int, int, string> getPersonCd2 = (int cnt, int pg, int lim) =>
        //    {
        //        return (cnt + (pg - 1) * lim).ToString("00000");
        //    };
        //    var data = new
        //    {
        //        data = new[] {
        //            new {personId = "0001100001", personname = "テスト患者００１", personnameeng = "TESTKANJA００１", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100002", personname = "テスト患者００２", personnameeng = "TESTKANJA００２", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100003", personname = "テスト患者００３", personnameeng = "TESTKANJA００３", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100004", personname = "テスト患者００４", personnameeng = "TESTKANJA００４", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100005", personname = "テスト患者００５", personnameeng = "TESTKANJA００５", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100006", personname = "テスト患者００６", personnameeng = "TESTKANJA００６", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100007", personname = "テスト患者００７", personnameeng = "TESTKANJA００７", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100008", personname = "テスト患者００８", personnameeng = "TESTKANJA００８", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100009", personname = "テスト患者００９", personnameeng = "TESTKANJA００９", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100010", personname = "テスト患者０１０", personnameeng = "TESTKANJA０１０", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100011", personname = "テスト患者０１１", personnameeng = "TESTKANJA０１１", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100012", personname = "テスト患者０１２", personnameeng = "TESTKANJA０１２", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100013", personname = "テスト患者０１３", personnameeng = "TESTKANJA０１３", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100014", personname = "テスト患者０１４", personnameeng = "TESTKANJA０１４", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100015", personname = "テスト患者０１５", personnameeng = "TESTKANJA０１５", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100016", personname = "テスト患者０１６", personnameeng = "TESTKANJA０１６", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100017", personname = "テスト患者０１７", personnameeng = "TESTKANJA０１７", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100018", personname = "テスト患者０１８", personnameeng = "TESTKANJA０１８", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100019", personname = "テスト患者０１９", personnameeng = "TESTKANJA０１９", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //            new {personId = "0001100020", personname = "テスト患者０２０", personnameeng = "TESTKANJA０２０", personbirthday = "H05.1.30", personsex = "男性", personphoneno = "08012345678", personAddress = "東京"},
        //        },
        //        TotalCount = 2500
        //    };

        //    return Ok(data);
        //}

        /// <summary>
		/// 一覧を取得する
		/// </summary>
		/// <param name="query">検索条件</param>
		/// <returns>一覧</returns>
        /// <response code="200">成功</response>
		/// <response code="404">データなし</response>
        public IHttpActionResult Get()
        {
            var dao = new PersonDao();
            DataSet ds = dao.SelectPersonList(UrlQuery);

            // データ件数が0件の場合
            if (ds.Data.Count == 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }


        ///// <summary>
        ///// 指定した個人情報を取得します。
        ///// </summary>
        ///// <response code="200">成功</response>
        ///// <response code="404">データなし</response>
        //[Route("api/person/{personCd1}/{personCd2}")]
        //public IHttpActionResult Get(string personCd1, string personCd2)
        //{
        //    var data = new
        //    {
        //        personcd1 = "00001",
        //        personcd2 = "00000",
        //        personname = "テスト株式会社",
        //        personsname = "（株）テスト",
        //    };

        //    return Ok(data);
        //}

        /// <summary>
        /// 指定した個人情報を取得します。
        /// </summary>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [Route("api/person/{personId}")]
        public IHttpActionResult Get(string personId)
        {
            var dao = new PersonDao();
            dynamic rec = dao.SelectPerson(personId);

            // 指定個人情報が存在しない場合
            if (rec == null)
            {
                return NotFound();
            }

            return Ok(rec);
        }
    }
}
