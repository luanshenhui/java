using Fujitsu.Hainsi.WindowServices.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Configuration;
using System.IO;
using System.Net;
using System.Net.Http;
using System.ServiceProcess;
using System.Threading.Tasks;
using System.Runtime.InteropServices;

namespace Fujitsu.Hainsi.WindowServices.PersonalAttributeListener
{
    public class Program : ManagedInstaller
    {
        // ★★★★★設定をapp.configに逃がし、ConfigurationManager.OpenExeConfigurationで取得する（サービス名、説明、ポート番号、ポーリングの間隔、受信電文長、患者属性登録用APIのURL、など）

        public const string ServiceName = "PersonalAttributeListener";
        public const string DisplayName = "Hainsi Personal Attribute Listener";

        /// <summary>
        /// アプリケーションのメイン エントリ ポイントです。
        /// </summary>
        static void Main(string[] args)
        {
            // 引数が存在する場合はインストール／アンインストールを行う
            if (args.Length >= 1)
            {
                Install(ServiceName, args);
                return;
            }

            int port = int.Parse(ConfigurationManager.AppSettings["ServerPort"]);

            // 引数が存在しない場合はサービスを登録
            ServiceBase.Run(new Listener(ServiceName, port.ToString(), "1000", "10000", "10000")
            {
                IsEndOfReceptionCallback = IsEndOfReception,
                ReceptionCompletedCallback = ReceptionCompleted,
//                CreateResponseStreamCallback = CreateResponseStream
            });
        }

        static private bool IsEndOfReception(MemoryStream memoryStream)
        {
            // ★★★★★ 医事受信は受信電文長分を受信したら受信完了としているようなのでその判定をここに実装。

            return true;
        }

        static private byte[] ReceptionCompleted(string receivedStream)
        {
            // ★★★★★ API呼び出し
            // 電文を電文レイアウトに従い項目ごとに分割（string→dictionary形式に変換するようなparserクラスでも構えるか）
            // 純正の個人情報登録APIを呼ぶ。分割した項目のうち必要なもののみを選択
            
            // 受信電文をバイト単位で切って割り当てる
            var receivedValues = new PersonalData();
            receivedStream.AllocTo(ref receivedValues);
            
            // バリデーションチェック
            if (! IsValid(receivedValues))
            {
                return BuildResponse(receivedValues, ResponseStatus.Skip);
            }
                
            // パラメータ設定
            HttpContent content = BuildQueryParam(receivedValues);

            var postTask = Task.Run(() => SendPersonalData(content));
            postTask.Wait();

            return BuildResponse(receivedValues, ResponseStatus.Ok);
        }
        
        /// <summary>
        /// バリデーション
        /// </summary>
        /// <param name="values"></param>
        /// <returns>チェック結果</returns>
        static private bool IsValid(PersonalData values)
        {
            // エラーメッセージリスト
            var results = new List<ValidationResult>();

            // Validationチェック
            Validator.TryValidateObject(values, new ValidationContext(values), results, true);

            // エラーメッセージに対する処理
            foreach(var result in results)
            {
                Console.WriteLine(result.ErrorMessage);
            }

            // 結果
            return (results.Count == 0);
        }

        /// <summary>
        /// 応答電文を作成する
        /// </summary>
        /// <param name="values">受信電文</param>
        /// <param name="status">処理ステータス</param>
        /// <returns>応答電文</returns>
        static private byte[] BuildResponse(PersonalData values, ResponseStatus status)
        {
            try
            {
                var response = new ResponseValues();
                Allocator.MAlloc(ref response);

                // 連番
                values.Seq.ConvertAndCopyTo(ref response.seq);
                // システムコード
                values.SystemCode.ConvertAndCopyTo(ref response.systemCode);
                // 電文種別
                values.TelegramType.ConvertAndCopyTo(ref response.telegramType);
                // 継続フラグ
                values.ContinueFlag.ConvertAndCopyTo(ref response.continueFlag);
                // 宛先コード（受信電文の発信元コードを代入）
                values.SourceCode.ConvertAndCopyTo(ref response.distCode);
                // 発信元コード（受信電文の宛先コードを代入）
                values.DistCode.ConvertAndCopyTo(ref response.sourceCode);
                // 処理日
                DateTime.Now.ToString("yyyyMMdd").ConvertAndCopyTo(ref response.processingDate);
                // 処理時間
                DateTime.Now.ToString("hhmmss").ConvertAndCopyTo(ref response.processingTime);
                // 端末名
                ConfigurationManager.AppSettings["SendDataWsMei"].ConvertAndCopyTo(ref response.terminalName);
                // 利用者番号
                ConfigurationManager.AppSettings["SendDataRiyosyaId"].ConvertAndCopyTo(ref response.userId);
                // 処理区分
                values.ProcessingCateTag.ConvertAndCopyTo(ref response.processingCateTag);
                // 応答種別
                ConvertResponseStatusCode(status).ConvertAndCopyTo(ref response.responseCate);
                // 電文長
                string.Format("{0:D5}", Marshal.SizeOf(response)).ConvertAndCopyTo(ref response.telegramLength);
                // 改行コード
                values.LinefeedCode.ConvertAndCopyTo(ref response.linefeedCode);
                // 電文終端コード
                "\r".ConvertAndCopyTo(ref response.terminationCode);

                return response.ConvertToBytes();
            }
            catch
            {
                throw;
            }
        }

        /// <summary>
        /// POSTリクエストを送信する
        /// </summary>
        /// <returns>HTTPレスポンス</returns>
        static private async Task<HttpResponseMessage> SendPersonalData(HttpContent content)
        {

            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(ConfigurationManager.AppSettings["ApiUri"]);

                HttpResponseMessage responseMessage = null;
                try
                {
                    // POSTリクエスト発行
                    responseMessage = await client.PostAsync("api/person", content);

                    if(responseMessage.StatusCode != HttpStatusCode.Created)
                    {
                        throw new Exception(string.Format("想定外のレスポンスコードが戻されました[Code = {0}]", responseMessage.StatusCode.ToString()));
                    }
                }
                catch(Exception ex)
                {
                    if (responseMessage == null)
                    {
                        responseMessage = new HttpResponseMessage();
                    }
                    responseMessage.StatusCode = HttpStatusCode.InternalServerError;
                    responseMessage.ReasonPhrase = string.Format("RestHttpClient.SendRequest failed: {0}", ex);
                }
                return responseMessage;
            }
        }

        /// <summary>
        /// APIにPOSTするクエリを作成する
        /// </summary>
        /// <param name="values"></param>
        /// <returns></returns>
        static private HttpContent BuildQueryParam(PersonalData values)
        {
            // POSTデータ作成
            var postDataBuilder = new QueryParamBuilder();
            
            postDataBuilder
                .Add("perid", new string(values.PatientId))
                .Add("vidflg", "0")
                .Add("delflg", "0")
                .Add("upduser", ConfigurationManager.AppSettings["PersonUpdUser"])
                .Add("gender", new string(values.Sex))
                .Add("medrname", new string(values.KanaName))
                .Add("medname", new string(values.Name))
                .Add("medgender", new string(values.Sex))
                .Add("postcardaddr", "1")
                .Add("mednationcd", new string(values.Nationality))
                .Add("addrdiv", ConfigurationManager.AppSettings["PersonAddrDiv"])
                .Add("zipcd", new string(values.ZipCode1) + new string(values.ZipCode2))
                .Add("prefcd", new string(values.PrefecturesCode))
                .Add("cityname", new string(values.JAddressCode))
                .Add("address1", new string(values.AddressDetail1))
                .Add("address2", new string(values.AddressDetail2))
                .Add("tel1", new string(values.Tel))
                .Add("phone", new string(values.ContactTel))
                .Add("tel2", new string(values.CorporateTel))
                .Add("extension", new string(values.CorporateTelExtension));
            
            DateTime dt = DateTime.ParseExact(new string(values.Birth), "yyyMMdd", System.Globalization.CultureInfo.InvariantCulture);
            string birth = dt.ToString("yyyy/MM/dd");
            postDataBuilder
                .Add("birth", birth)
                .Add("medbirth", birth);
            
            DivideName(new string(values.Name), out string firstName, out string lastName);
            postDataBuilder
                .Add("firstname", firstName)
                .Add("lastname", lastName);
            
            DivideName(new string(values.KanaName), out string firstKName, out string lastKName);
            postDataBuilder
                .Add("firstkname", firstKName)
                .Add("lastkname", lastKName);

            return postDataBuilder.Build();
        }

        /// <summary>
        /// 氏名を苗字と名前に分ける
        /// </summary>
        /// <param name="name">氏名</param>
        /// <param name="firstName">名前</param>
        /// <param name="lastName">苗字</param>
        private static void DivideName(string name, out string firstName, out string lastName)
        {
            firstName = "　";
            lastName = "　";

            if (name != "")
            {
                var length = name.IndexOf("　");
                if (length < 0)
                {
                    lastName = name;
                }
                else
                {
                    lastName = name.Substring(0, length);
                    firstName = name.Substring(length + 1);
                }
            }
        }

        private enum ResponseStatus
        {
            Ok,
            Retry,
            Skip,
            Down,
            Else
        }

        /// <summary>
        /// ステータスコード変換
        /// </summary>
        /// <param name="status"></param>
        /// <returns></returns>
        static private string ConvertResponseStatusCode(ResponseStatus status)
        {
            var codes = new Dictionary<ResponseStatus, string>();
            codes.Add(ResponseStatus.Ok, "OK");
            codes.Add(ResponseStatus.Retry, "N1");
            codes.Add(ResponseStatus.Skip, "N2");
            codes.Add(ResponseStatus.Down, "N3");

            if (codes.ContainsKey(status))
            {
                return codes[status];
            }

            return "";
        }

        /// <summary>
        /// GETリクエストを送信する
        /// </summary>
        /// <returns>HTTPレスポンス</returns>
        //static private async Task<HttpResponseMessage> SendGetRequest()
        //{
        //    // URLクエリ作成
        //    NameValueCollection queryString = HttpUtility.ParseQueryString("");
        //    queryString.Add("id", "1");

        //    using (var client = new HttpClient())
        //    {
        //        client.BaseAddress = new Uri(ConfigurationManager.AppSettings["ApiUri"]);

        //        HttpResponseMessage responseMessage = null;
        //        try
        //        {
        //            // http://localhost/test/person にGETリクエスト発行
        //            responseMessage = await client.GetAsync("test/person" + "?" + queryString.ToString());
        //        }
        //        catch (Exception ex)
        //        {
        //            if (responseMessage == null)
        //            {
        //                responseMessage = new HttpResponseMessage();
        //            }
        //            responseMessage.StatusCode = HttpStatusCode.InternalServerError;
        //            responseMessage.ReasonPhrase = string.Format("RestHttpClient.SendRequest failed: {0}", ex);
        //        }

        //        return responseMessage;
        //    }
        //}

        //static private string CreateResponseStream(string receivedString)
        //{
        //    // ★★応答電文を作成
        //    // あまりも複雑な応答電文ならAPIにおまかせ、ってなるのかもしれないが

        //    Task<HttpResponseMessage> getTask = Task.Run(() => SendGetRequest());
        //    getTask.Wait();

        //    Task<string> resultTask = Task.Run(() => getTask.Result.Content.ReadAsStringAsync());
        //    resultTask.Wait();

        //    return resultTask.Result;
        //}
    }
}
