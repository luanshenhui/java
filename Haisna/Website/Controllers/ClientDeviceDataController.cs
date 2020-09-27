using Hainsi.Entity;
using Hainsi.Entity.Model;
using Hainsi.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

#pragma warning disable CS1591

namespace Hainsi.Controllers
{
    //[Authorize]
    [Route("api/[controller]")]
    public class ClientDeviceDataController : Controller
    {
        /// <summary>
        /// 計測結果データアクセスオブジェクト
        /// </summary>
        readonly ClientPostDao clientPostDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="clientPostDao">計測結果データアクセスオブジェクト</param>
        public ClientDeviceDataController(ClientPostDao clientPostDao)
        {
            this.clientPostDao = clientPostDao;
        }

        /// <summary>
        /// 血圧情報を登録する
        /// </summary>
        /// <param name="id">Execキー</param>
        /// <param name="values">血圧データ</param>
        /// <returns></returns>
        [HttpPost("{id}")]
        public IActionResult Create(long id, BloodPressureModel values)
        {
            ClientDeviceModel tableModel = ConvertToTableModel(id, values);

            int count = clientPostDao.Register(tableModel);

            return Created(Request.Path, count);
        }

        /// <summary>
        /// POSTされたクライアントデータをテーブルに登録する形に変換する
        /// </summary>
        /// <param name="execKey">Execキー</param>
        /// <param name="postValues">APIにポストされたデータ</param>
        /// <returns>テーブルに登録するデータ</returns>
        private ClientDeviceModel ConvertToTableModel(long execKey, ClientDeviceApiModel postValues)
        {
            var clientDeviceValues = new ClientDeviceModel();

            clientDeviceValues.ExecKey = execKey;
            clientDeviceValues.IpAddress = HttpContext.Connection.RemoteIpAddress.ToString();
            clientDeviceValues.PostClass = postValues.PostClass;
            clientDeviceValues.Data = postValues.BuildJsonData();

            return clientDeviceValues;
        }

        /// <summary>
        /// 指定のEXECKEYのデータを取得する
        /// </summary>
        /// <param name="id">Execキー</param>
        /// <returns></returns>
        [HttpGet("{id}")]
        public IActionResult GetById(long id)
        {
            dynamic response = clientPostDao.Select(id);

            if (response == null)
            {
                return NotFound();
            }

            return Ok(response.DATA);
        }
    }
}
