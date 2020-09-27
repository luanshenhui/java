#pragma warning disable CS1591

namespace Hainsi.Models
{
    public abstract class ClientDeviceApiModel
    {
        public string Token { get; set; }
        public string PostClass { get; set; }

        /// <summary>
        /// DB登録用のJSONデータを作成する
        /// </summary>
        /// <returns>JSONデータ</returns>
        public abstract string BuildJsonData();
    }
}