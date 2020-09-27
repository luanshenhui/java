using Hainsi.Common;
using Hainsi.Entity;
using Hainsi.ReportCore;
using Hainsi.ReportCore.Model;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;

namespace Hainsi.Controllers
{
    /// <summary>
    /// レポーティングコントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/reports")]
    public class ReportController : Controller
    {
        // レポート作成進捗確認用URLのフォーマット
        private const string ProgressPath = "/api/v1/reports/{0}/progress";

        /// <summary>
        /// レポーティングマネージャークラスのインスタンス
        /// </summary>
        readonly ReportManager reportManager;

        /// <summary>
        /// 帳票管理情報データアクセスオブジェクト
        /// </summary>
        readonly ReportDao reportDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="reportManager">レポーティングマネージャークラスのインスタンス</param>
        /// <param name="reportDao">帳票管理情報データアクセスオブジェクト</param>
        public ReportController(ReportManager reportManager, ReportDao reportDao)
        {
            this.reportManager = reportManager;
            this.reportDao = reportDao;
        }

        /// <summary>
        /// レポート作成
        /// </summary>
        /// <returns>プリントSEQのJSON</returns>
        [HttpPost("{id}")]
        public IActionResult Create(string id, [FromBody] JToken queryParams)
        {
            // TODO
            // string userId = HttpContext.Session.GetString("userId");
            string userId = "HAINS$";

            // ユーザIDを取得できなければ401を返す
            if (string.IsNullOrEmpty(userId))
            {
                return Unauthorized();
            }

            // インスタンス取得
            ReportCreator reportCreator = reportManager.CreateInstance(id);

            // クラスが存在しなければ404を返す
            if (reportCreator == null)
            {
                return NotFound();
            }

            // ユーザIDをセット
            reportManager.UserId = userId;

            //パラメータをセット
            reportCreator.SetQueryParam(new ParamValues(queryParams));

            // 実行
            PrintSeqViewModel result = reportManager.Execute(reportCreator);

            // メッセージ発生時はUnprocessable Entityを返す
            if ((result.Messages != null) && (result.Messages.Count > 0))
            {
                return BadRequest(new { errors = result.Messages });
            }

            // ロケーションに進捗チェック用のURLをセット
            // return AcceptedAtRoute("GetReportProgress", new { id = result.PrintSeq });
            // return Get((long)result.PrintSeq);

            // 作成データの確認処理（暫定）
            FileViewModel fileView = reportManager.ReadFileViewModel((long)result.PrintSeq);
            if (fileView == null || fileView.DataFile.Length == 0)
            {
                return NotFound();
            }
            return Ok(result);
        }

        /// <summary>
        /// 進捗状況を取得
        /// </summary>
        /// <param name="id">プリントSEQのGETデータ</param>
        /// <returns>進捗状況</returns>
        [HttpGet("{id}/progress", Name = "GetReportProgress")]
        public IActionResult GetProgress(int id)
        {
            // 進捗確認
            ProgressViewModel result = reportManager.ReadProgressViewModel(id);
            return Ok(result);
        }

        /// <summary>
        /// ファイルダウンロード
        /// </summary>
        /// <param name="id">プリントSEQのPOSTデータ</param>
        /// <returns>ファイル</returns>
        [HttpGet("{id}")]
        public IActionResult Get(long id)
        {
            // ファイル取得
            FileViewModel fileView = reportManager.ReadFileViewModel(id);

            // ファイルが存在しない場合
            if (fileView == null || fileView.DataFile.Length == 0)
            {
                return NotFound();
            }

            // ファイルコンテンツを返す
            return File(fileView.DataFile, fileView.MimeType, fileView.FileName);
        }

        /// <summary>
        /// #ToDo
        /// 出力様式一覧取得（暫定）
        /// </summary>
        /// <returns></returns>
        [HttpGet("style")]
        public IActionResult GetStyle(string vieworder)
        {
            var data = new List<dynamic>();
            for (int i = 0; i < 50; i++)
            {
                data.Add(
                    new
                    {
                        reportcd = 100 + i,
                        reportname = "出力様式名" + i.ToString()
                    }
                );
            }

            if (vieworder == "1")
            {
                data.Reverse();
            }

            var ds = new Dictionary<string, List<dynamic>>
            {
                { "data", data }
            };

            // データ件数が0件の場合
            if (data.Count == 0)
            {
                return NotFound();
            }

            return Ok(ds);
        }

        /// <summary>
        /// レポート作成
        /// </summary>
        /// <returns>プリントSEQのJSON</returns>
        [HttpGet("/api/v1/documents/{reportName}")]
        public IActionResult CreateDocument(string reportName,  IDictionary<string, string> queryParams)
        {
            // TODO
            // string userId = HttpContext.Session.GetString("userId");
            string userId = "HAINS$";

            // ユーザIDを取得できなければ401を返す
            if (string.IsNullOrEmpty(userId))
            {
                return Unauthorized();
            }

            // インスタンス取得
            ReportCreator reportCreator = reportManager.CreateInstance(reportName);

            // クラスが存在しなければ404を返す
            if (reportCreator == null)
            {
                return NotFound();
            }

            // ユーザIDをセット
            reportManager.UserId = userId;

            //パラメータをセット
            var param = new JObject();
            foreach (var elem in queryParams)
            {
                param[elem.Key] = elem.Value;
            }
            reportCreator.SetQueryParam(new ParamValues(param));

            // 実行
            PrintSeqViewModel result = reportManager.Execute(reportCreator);

            // メッセージ発生時はUnprocessable Entityを返す
            if ((result.Messages != null) && (result.Messages.Count > 0))
            {
                return BadRequest(new { errors = result.Messages });
            }

            // 作成データの確認処理（暫定）
            return Get((long)result.PrintSeq);
        }

        /// <summary>
        /// 帳票テーブル情報を取得する
        /// </summary>
        /// <param name="reportFlg">報告書フラグ</param>
        /// <param name="selectViewOrder">true時は表示順に従い取得</param>
        /// <returns></returns>
        [HttpGet]
        public IActionResult GetReportList(int? reportFlg = null, bool selectViewOrder = false)
        {
            List<dynamic> list = reportDao.SelectReportList(reportFlg, selectViewOrder);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }
    }
}
