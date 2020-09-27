using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;

namespace Fujitsu.Hainsi.WindowServices.Common
{
    public class WebAPI
    {
        /// <summary>
        /// POSTリクエストを送信する
        /// </summary>
        /// <param name="baseUri">Web APIのベースURI</param>
        /// <param name="uri">Web APIのURI</param>
        /// <param name="data">リクエストボディにセットするデータ</param>
        /// <returns>エラーメッセージ(string型)／取得したデータ(任意の型)</returns>
        public static async Task<dynamic> PostDataAsync<T>(string baseUri, string uri, T data)
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(baseUri);
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(
                    new MediaTypeWithQualityHeaderValue("application/json"));

                // POSTリクエストを送信する
                HttpResponseMessage response = 
                    await client.PostAsJsonAsync<T>(uri, data);

                // ステータスコードが成功以外の場合
                if (!response.IsSuccessStatusCode)
                {
                    try
                    {
                        IList<string> messages =
                            await response.Content.ReadAsAsync<IList<string>>();
                        if (messages != null)
                        {
                            // エラーメッセージが取得できた場合はそれを戻す
                            return string.Join("", messages);
                        }
                    }
                    catch
                    {
                        // 何もしない
                    }

                    // その他の場合は例外を発生させる
                    response.EnsureSuccessStatusCode();
                    return null;
                }

                // 処理が成功した場合
                return await response.Content.ReadAsAsync<dynamic>();
            }
        }

        /// <summary>
        /// PUTリクエストを送信する
        /// </summary>
        /// <param name="baseUri">Web APIのベースURI</param>
        /// <param name="uri">Web APIのURI</param>
        /// <param name="data">リクエストボディにセットするデータ</param>
        /// <returns>エラーメッセージ(string型)／取得したデータ(任意の型)</returns>
        public static async Task<dynamic> PutDataAsync<T>(string baseUri, string uri, T data)
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(baseUri);
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(
                    new MediaTypeWithQualityHeaderValue("application/json"));

                // PUTリクエストを送信する
                HttpResponseMessage response =
                    await client.PutAsJsonAsync<T>(uri, data);

                // ステータスコードが成功以外の場合
                if (!response.IsSuccessStatusCode)
                {
                    try
                    {
                        IList<string> messages =
                            await response.Content.ReadAsAsync<IList<string>>();
                        if (messages != null)
                        {
                            // エラーメッセージが取得できた場合はそれを戻す
                            return string.Join("", messages);
                        }
                    }
                    catch
                    {
                        // 何もしない
                    }

                    // その他の場合は例外を発生させる
                    response.EnsureSuccessStatusCode();
                    return null;
                }

                // 処理が成功した場合
                return await response.Content.ReadAsAsync<dynamic>();
            }
        }

        /// <summary>
        /// GETリクエストを送信する
        /// </summary>
        /// <param name="baseUri">Web APIのベースURI</param>
        /// <param name="uri">Web APIのURI</param>
        /// <returns>GETリクエストで取得したデータ</returns>
        public static async Task<dynamic> GetDataAsync(string baseUri, string uri)
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(baseUri);
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(
                    new MediaTypeWithQualityHeaderValue("application/json"));

                // GETリクエストを送信する
                HttpResponseMessage response = await client.GetAsync(uri);

                // ステータスコードが成功以外の場合
                if (!response.IsSuccessStatusCode)
                {
                    if (response.StatusCode == HttpStatusCode.NotFound)
                    {
                        // 該当するデータが存在しない場合はnullを戻す
                        return null;
                    }

                    // その他の場合は例外を発生させる
                    response.EnsureSuccessStatusCode();
                    return null;
                }

                // 取得したデータを戻す
                return await response.Content.ReadAsAsync<dynamic>();
            }
        }

        /// <summary>
        /// DELETEリクエストを送信する
        /// </summary>
        /// <param name="baseUri">Web APIのベースURI</param>
        /// <param name="uri">Web APIのURI</param>
        /// <returns>エラーメッセージ(string型)／取得したデータ(任意の型)</returns>
        public static async Task<dynamic> DeleteDataAsync(string baseUri, string uri)
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(baseUri);
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(
                    new MediaTypeWithQualityHeaderValue("application/json"));

                // DELETEリクエストを送信する
                HttpResponseMessage response =
                    await client.DeleteAsync(uri);

                // ステータスコードが成功以外の場合
                if (!response.IsSuccessStatusCode)
                {
                    try
                    {
                        IList<string> messages =
                            await response.Content.ReadAsAsync<IList<string>>();
                        if (messages != null)
                        {
                            // エラーメッセージが取得できた場合はそれを戻す
                            return string.Join("", messages);
                        }
                    }
                    catch
                    {
                        // 何もしない
                    }

                    // その他の場合は例外を発生させる
                    response.EnsureSuccessStatusCode();
                    return null;
                }

                // 処理が成功した場合
                return await response.Content.ReadAsAsync<dynamic>();
            }
        }
    }
}
