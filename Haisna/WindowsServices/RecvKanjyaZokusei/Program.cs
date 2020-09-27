using Fujitsu.Hainsi.WindowServices.Common;
using Model = Hainsi.Entity.Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace Fujitsu.Hainsi.WindowServices.RecvKanjyaZokusei
{
    public class Program : ManagedInstaller
    {
        /// <summary>
        /// 応答種別
        /// </summary>
        private enum ResponseStatus
        {
            Ok,
            Retry,
            Skip,
            Down,
        }

        /// <summary>
        /// 処理区分（削除）
        /// </summary>
        private const string SYORI_KBN_DEL = "03";

        /// <summary>
        /// 電文情報クラス
        /// </summary>
        private static TelegramInfo TelegramInfo = null;

        /// <summary>
        /// 共通情報部分の電文長
        /// </summary>
        private static int KihonByteLen = 0;

        /// <summary>
        /// 個人.更新者
        /// </summary>
        private static string PersonUpdUser = "";

        /// <summary>
        /// 個人住所情報.住所区分
        /// </summary>
        private static string PersonAddrDiv = "";

        /// <summary>
        /// 端末名
        /// </summary>
        private static string ComputerName = "";

        /// <summary>
        /// 利用者ID
        /// </summary>
        private static string UserId = "";

        /// <summary>
        /// Web API のベースURL
        /// </summary>
        private static string ApiUri = "";

        /// <summary>
        /// アプリケーションのメイン エントリ ポイントです。
        /// </summary>
        static void Main(string[] args)
        {
            // ログ出力クラスを初期化する
            Logging.Initialize(Logging.DestSystemConstants.Hope);

            // サービス名
            string serviceName = ConfigurationManager.AppSettings["ServiceName"].Trim();

            // 引数が存在する場合は
            // サービスのインストール／アンインストールを行う
            if (args.Length >= 1)
            {
                Install(serviceName, args);
                return;
            }

            // ポート番号
            string port = ConfigurationManager.AppSettings["ServerPort"];

            // ポーリング間隔
            string pollingInterval = ConfigurationManager.AppSettings["PollingInterval"];

            // ソケット受信タイムアウト
            string socketRecieveTimeout = ConfigurationManager.AppSettings["SocketRecieveTimeout"];

            // ソケット送信タイムアウト
            string socketSendTimeout = ConfigurationManager.AppSettings["SocketSendTimeout"];

            // サービスを開始する
            ServiceBase.Run(new Listener(
                serviceName, port, pollingInterval, socketRecieveTimeout, socketSendTimeout)
            {
                OnStartCallback = OnStart,
                IsEndOfReceptionCallback = IsEndOfReception,
                ReceptionCompletedCallback = ReceptionCompleted,
            });
        }

        /// <summary>
        /// 開始処理コールバック
        /// </summary>
        /// <param name="telegramInfo">電文情報クラス</param>
        private static void OnStart(TelegramInfo telegramInfo)
        {
            // 電文情報クラスを取得する
            TelegramInfo = telegramInfo;

            // 共通情報部分の電文長を計算する
            foreach (TelegramInfo.TelegramItem item in TelegramInfo.Items)
            {
                // 共通情報部分の項目のバイト数を加算する
                if (item.TelegType == TelegramInfo.TelegramItem.TelegTypeConstants.common)
                {
                    KihonByteLen += item.Length;
                }
            }

            // 個人.更新者
            PersonUpdUser = ConfigurationManager.AppSettings["PersonUpdUser"].Trim();
            if (string.IsNullOrEmpty(PersonUpdUser))
            {
                throw new Exception("個人.更新者が設定されていません。");
            }

            // 個人住所情報.住所区分
            PersonAddrDiv = ConfigurationManager.AppSettings["PersonAddrDiv"].Trim();
            if (string.IsNullOrEmpty(PersonAddrDiv))
            {
                throw new Exception("個人住所情報.住所区分が設定されていません。");
            }

            // 端末名
            ComputerName = ConfigurationManager.AppSettings["SendDataWsMei"].Trim();
            if (string.IsNullOrEmpty(ComputerName))
            {
                throw new Exception("端末名が設定されていません。");
            }

            // 利用者ID
            UserId = ConfigurationManager.AppSettings["SendDataRiyosyaId"].Trim();
            if (string.IsNullOrEmpty(UserId))
            {
                throw new Exception("利用者IDが設定されていません。");
            }

            // Web API のベースURL
            ApiUri = ConfigurationManager.AppSettings["ApiUri"].Trim();
            if (string.IsNullOrEmpty(ApiUri))
            {
                throw new Exception("Web API のベースURLが設定されていません。");
            }
        }

        /// <summary>
        /// 受信終了判定コールバック
        /// </summary>
        /// <param name="memoryStream">受信電文</param>
        /// <returns>True:受信処理完了、False:受信処理継続</returns>
        private static bool IsEndOfReception(MemoryStream memoryStream)
        {
            // 受信済みデータを取得する
            byte[] receivedBytes = memoryStream.ToArray();

            if (receivedBytes.Length < KihonByteLen)
            {
                // 共通情報部分まで受信できていない場合は
                // 受信処理を継続する
                return false;
            }

            // 電文長のデータを取得する
            TelegramInfo.TelegramItem item = 
                TelegramInfo.FindItem(TelegramInfo.Items, "DENBUN-LNG");
            string tempLength = receivedBytes.ConvertToString(item.StartPos - 1, item.Length);
            int length = 0;
            if (!int.TryParse(tempLength, out length))
            {
                // 電文長を数値に変換できない場合は
                // 受信処理を中止する
                throw new Exception(
                    "電文長に数値以外の値が設定されています 電文長：[" + tempLength + "]" +
                    " 受信済み電文：[" + receivedBytes.ConvertToString() + "]");
            }

            if (receivedBytes.Length < length)
            {
                // 受信済みデータのサイズが電文長に満たない場合は
                // 受信処理を継続する
                return false;
            }

            // 電文を全て受信できたため
            // 受信処理を終了する
            return true;
        }

        /// <summary>
        /// 受信完了コールバック
        /// </summary>
        /// <param name="receivedStream">受信電文</param>
        /// <returns>送信電文</returns>
        private static byte[] ReceptionCompleted(string receivedStream)
        {
            // 受信電文を解析する
            List<string> errorList = null;
            Dictionary<string, string> values = null;
            TelegramInfo.Parse(receivedStream, ref errorList, ref values);

            // １件以上エラーが存在する場合
            if (errorList.Count > 0)
            {
                Logging.Output(
                    Logging.LogTypeConstants.DataError,
                    string.Join("／", errorList.ToArray()));

                // 電文の解析でエラーが発生した場合は
                // 応答種別を"N2"（スキップ）とする
                return BuildResponse(values, ResponseStatus.Skip);
            }

            // 患者番号（先頭部分の0を取り除く）
            int.TryParse(values["KJ-ID"].Trim(), out int tmpPerId);
            string perId = tmpPerId.ToString();

            Task<dynamic> taskGetData = null;
            try
            {
                // 個人属性情報を取得する
                taskGetData = WebAPI.GetDataAsync(ApiUri, "api/v1/people/" + perId);
                taskGetData.Wait();
            }
            catch (Exception ex)
            {
                // エラー内容をログに出力する
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted",
                    "個人属性情報の取得処理に失敗しました。", ex);

                // 個人属性情報の取得処理に失敗した場合は
                // 応答種別を"N2"（スキップ）とする
                return BuildResponse(values, ResponseStatus.Skip);
            }

            // 登録データを作成する
            dynamic data = BuildPostBodyData(perId, taskGetData.Result, values);

            try
            {
                if (taskGetData.Result == null)
                {
                    // 個人属性情報を新規登録する
                    Task<dynamic> taskPostData = 
                        WebAPI.PostDataAsync(ApiUri, "api/v1/people", data);
                    taskPostData.Wait();

                    if (taskPostData.Result != null && taskPostData.Result is string)
                    {
                        // エラー内容をログに出力する
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted",
                            "個人属性情報の登録処理に失敗しました。" + (string)taskPostData.Result);

                        // 個人属性情報の登録処理に失敗した場合は
                        // 応答種別を"N2"（スキップ）とする
                        return BuildResponse(values, ResponseStatus.Skip);
                    }
                }
                else
                {
                    // 個人属性情報を更新する
                    Task<dynamic> taskPutData = 
                        WebAPI.PutDataAsync(ApiUri, "api/v1/people/" + perId, data);
                    taskPutData.Wait();

                    if (taskPutData.Result != null && taskPutData.Result is string)
                    {
                        // エラー内容をログに出力する
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted",
                            "個人属性情報の登録処理に失敗しました。" + (string)taskPutData.Result);

                        // 個人属性情報の登録処理に失敗した場合は
                        // 応答種別を"N2"（スキップ）とする
                        return BuildResponse(values, ResponseStatus.Skip);
                    }
                }

                // 処理区分が"03"（削除）の場合は
                // エラーログを出力する
                if (values["SYORI-KBN"].Trim().Equals(SYORI_KBN_DEL))
                {
                    Logging.Output(
                        Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted",
                        "医事システムにて、削除実施[" + "個人番号: " + values["KJ-ID"].Trim() + "]");
                }

                // 個人属性情報の登録処理に成功した場合は
                // 応答種別を"OK"（正常終了）とする
                return BuildResponse(values, ResponseStatus.Ok);
            }
            catch (Exception ex)
            {
                // エラー内容をログに出力する
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "ReceptionCompleted",
                    "個人属性情報の登録処理に失敗しました。", ex);

                // 個人属性情報の登録処理に失敗した場合は
                // 応答種別を"N2"（スキップ）とする
                return BuildResponse(values, ResponseStatus.Skip);
            }
        }

        /// <summary>
        /// 応答電文を作成する
        /// </summary>
        /// <param name="values">受信電文データ</param>
        /// <param name="status">処理ステータス</param>
        /// <returns>応答電文</returns>
        private static byte[] BuildResponse(Dictionary<string, string> values, ResponseStatus status)
        {
            StringBuilder sendData = new StringBuilder();

            // 応答種別を変換する
            var statusCodes = new Dictionary<ResponseStatus, string>()
            {
                { ResponseStatus.Ok, "OK" },
                { ResponseStatus.Retry, "N1" },
                { ResponseStatus.Skip, "N2" },
                { ResponseStatus.Down, "N3" },
            };
            string statusCode = 
                statusCodes.ContainsKey(status) ? statusCodes[status] : "";

            for (int i = 0; i < TelegramInfo.ExpandItems.Count; i++)
            {
                if (TelegramInfo.ExpandItems[i].TelegType == TelegramInfo.TelegramItem.TelegTypeConstants.common)
                {
                    string data = "";
                    switch (TelegramInfo.ExpandItems[i].NameEn)
                    {
                        case "TO-C":            // 宛先コード
                            // 受信電文の発信元コードを代入
                            data = values["FROM-C"].Trim();
                            break;
                        case "FROM-C":          // 発信元コード
                            // 受信電文の宛先コードを代入
                            data = values["TO-C"].Trim();
                            break;
                        case "SYORI-H":         // 処理日付
                            data = DateTime.Now.ToString("yyyyMMdd");
                            break;
                        case "SYORI-TIME":      // 処理時間
                            data = DateTime.Now.ToString("HHmmss");
                            break;
                        case "WS-MEI":          // 端末名
                            data = ComputerName;
                            break;
                        case "RIYOSYA-ID":      // 利用者ＩＤ
                            data = UserId;
                            break;
                        case "SYUBETU":         // 応答種別
                            data = statusCode;
                            break;
                        case "DENBUN-LNG":      // 電文長
                            // 共通部 - 予備 + 電文終端コード"0D"
                            data = string.Format("{0:D5}", 
                                KihonByteLen - TelegramInfo.FindItem(TelegramInfo.ExpandItems, "FILLER").Length + 1);
                            break;
                        case "FILLER":          // 予備
                            // 予備は応答電文として出力しない
                            continue;
                        default:                // その他
                            data = values[TelegramInfo.ExpandItems[i].NameEn];
                            break;
                    }

                    if (TelegramInfo.ExpandItems[i].Type == TelegramInfo.TelegramItem.DataTypeConstants.numeric)
                    {
                        // 数値の場合は右詰め
                        data = data.PadLeftEx(TelegramInfo.ExpandItems[i].Length);
                    }
                    else
                    {
                        // 文字列の場合は左詰め
                        data = data.PadRightEx(TelegramInfo.ExpandItems[i].Length);
                    }

                    sendData.Append(data);
                }
            }

            // 電文終端コード"0D"
            sendData.Append("\r");

            // 応答種別送信
            Logging.Output(
                Logging.LogTypeConstants.RetrunResponse,
                statusCode);

            return sendData.ToString().GetBytes();
        }

        /// <summary>
        /// Web APIにPOST/PUTする個人属性情報データを作成する
        /// </summary>
        /// <param name="perId">個人ID</param>
        /// <param name="person">現時点の個人属性情報データ</param>
        /// <param name="values">受信電文データ</param>
        /// <returns>個人情報モデルデータ</returns>
        static private Model.Person.Person BuildPostBodyData(string perId, dynamic person, IDictionary<string, string> values)
        {
            // 氏名
            string name = values["KJ-JEF-NM"].Trim();

            // 氏名を苗字と名前に分割する
            DivideName(name, out string firstName, out string lastName);

            // ローマ字氏名
            string rName = values["KJ-RA-NM"].Trim();
            if (rName.GetByteCount() > 60)
            {
                Logging.Output(
                    Logging.LogTypeConstants.FreeOutput, "Program", "BuildQueryParam",
                    "個人番号:" + values["KJ-ID"].Trim() + "　ローマ字氏名桁数オーバー");
                rName = rName.CutLeft(60).TrimEnd();
            }

            // カナ氏名
            string kanaName = values["KJ-NM"].Trim();

            // カナ氏名を苗字と名前に分割する
            DivideName(kanaName, out string firstKName, out string lastKName);
            if (firstKName.GetByteCount() > 50)
            {
                Logging.Output(
                    Logging.LogTypeConstants.FreeOutput, "Program", "BuildQueryParam",
                    "個人番号:" + values["KJ-ID"].Trim() + "　カナ氏名(名)桁数オーバー");
                firstKName = firstKName.CutLeft(50).TrimEnd();
            }
            if (lastKName.GetByteCount() > 50)
            {
                Logging.Output(
                    Logging.LogTypeConstants.FreeOutput, "Program", "BuildQueryParam",
                    "個人番号:" + values["KJ-ID"].Trim() + "　カナ氏名(姓)桁数オーバー");
                lastKName = lastKName.CutLeft(50).TrimEnd();
            }

            // 医事連携カナ氏名
            string medKName = kanaName;
            if (medKName.GetByteCount() > 60)
            {
                Logging.Output(
                    Logging.LogTypeConstants.FreeOutput, "Program", "BuildQueryParam",
                    "個人番号:" + values["KJ-ID"].Trim() + "　医事連携カナ氏名桁数オーバー");
                medKName = medKName.CutLeft(60).TrimEnd();
            }

            // 生年月日
            string birth = "";
            if (DateTime.TryParseExact(
                    values["KJ-BIRTH"].Trim(), "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture,
                    System.Globalization.DateTimeStyles.None, out DateTime dt))
            {
                birth = dt.ToString("yyyy/MM/dd");
            }

            // 性別
            string gender = values["KJ-SEX"].Trim();

            // 都道府県コード
            string prefCd = values["KJ-ADRS-TDFK-C"].Trim();

            // 住所コード部分の日本語名称
            string cityName = values["KJ-ADRS-JEF"].Trim();

            // 詳細住所１
            string address1 = values["KJ-SYOSAI-JEF"].Trim();

            // 詳細住所２
            string address2 = values["KJ-SYOSAI-JEF2"].Trim();

            // 郵便番号
            string zipCd = values["KJ-POST-C"].Trim();

            // 電話番号
            string tel1 = values["KJ-TEL"].Trim();

            // 連絡先電話番号
            string phone = values["KJ-CONE-TEL"].Trim();

            // 会社電話番号
            string tel2 = values["KJ-CORP-TEL"].Trim();

            // 会社内線番号
            string extension = values["KJ-CORP-TEL-NAISEN"].Trim();

            // 国籍コード
            string nationCd = values["KJ-KOKUSEKI-C"].Trim();

            // POST/PUTデータを作成する
            Model.Person.Person data = null;
            Model.Person.Addresses[] addresses = { };
            Model.Person.Addresses address = null;

            if (person == null)
            {
                // 新規作成の場合
                data = new Model.Person.InsertPerson();

                // 個人ID
                ((Model.Person.InsertPerson)data).PerId = perId;
                // 仮IDフラグ
                data.VidFlg = "0";
                // 削除フラグ
                data.DelFlg = "0";
                // 姓
                data.LastName = lastName;
                // 名
                data.FirstName = firstName;
                // カナ姓
                data.LastKName = lastKName;
                // カナ名
                data.FirstKName = firstKName;
                // ローマ字名
                data.RomeName = rName;
                // 生年月日
                data.Birth = birth;
                // 性別
                data.Gender = gender;
                // 更新者
                data.UpdUser = PersonUpdUser;
                // 1年目はがき宛先
                data.PostCardAddr = "1";

                // 個人住所情報（自宅）
                Array.Resize(ref addresses, addresses.Length + 1);
                addresses[addresses.Length - 1] = new Model.Person.Addresses();
                address = addresses[addresses.Length - 1];
                // 住所区分
                address.AddrDiv = "1";
                // 電話番号1
                address.Tel = tel1;
                // 携帯番号
                address.Phone = phone;
                // 電話番号２
                address.SubTel = tel2;
                // 内線
                address.Extension = extension;
                // 郵便番号
                address.ZipCd = zipCd;
                // 都道府県コード　※都道府県コードは登録しない
                // address.PrefCd = prefCd;
                // 市区町村名
                address.CityName = cityName;
                // 住所1
                address.Address1 = address1;
                // 住所2
                address.Address2 = address2;
            }
            else
            {
                // 更新の場合
                data = new Model.Person.Person();
            }

            // 医事連携ローマ字名
            data.MedRName = rName;
            // 医事連携漢字氏名
            data.MedName = (lastName + "　" + firstName).TrimEnd();
            // 医事連携カナ氏名
            data.MedKName = medKName;
            // 医事連携生年月日
            data.MedBirth = birth;
            // 医事連携性別
            data.MedGender = gender;
            // 医事連携更新日時
            data.MedUpdDate = DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss");
            // 医事連携国籍区分
            data.MedNationCd = nationCd;

            // 個人住所情報（医事住所）
            Array.Resize(ref addresses, addresses.Length + 1);
            addresses[addresses.Length - 1] = new Model.Person.Addresses();
            address = addresses[addresses.Length - 1];
            // 住所区分
            address.AddrDiv = PersonAddrDiv;
            // 電話番号1
            address.Tel = tel1;
            // 携帯番号
            address.Phone = phone;
            // 電話番号２
            address.SubTel = tel2;
            // 内線
            address.Extension = extension;
            // 郵便番号
            address.ZipCd = zipCd;
            // 都道府県コード
            address.PrefCd = prefCd;
            // 市区町村名
            address.CityName = cityName;
            // 住所1
            address.Address1 = address1;
            // 住所2
            address.Address2 = address2;

            // 個人住所情報
            data.Addresses = addresses;

            return data;
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

            if (lastName.Trim().Equals(""))
            {
                lastName = "　";
            }
            if (firstName.Trim().Equals(""))
            {
                firstName = "　";
            }
        }
    }
}
