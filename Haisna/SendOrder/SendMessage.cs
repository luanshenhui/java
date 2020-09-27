using System;
using System.IO;
using System.Linq;
using System.Net.Sockets;

namespace Hainsi.SendOrder
{
    /// <summary>
    /// 電文送信クラス
    /// </summary>
    public class SendMessage
    {
        /// <summary>
        /// 電文送信処理
        /// </summary>
        /// <param name="destination">電文送信先区分</param>
        /// <param name="orderDiv">オーダ種別</param>
        /// <param name="message">送信電文</param>
        /// <param name="receiveMessage">受信電文</param>
        public Constants.ResponseValueConstants Send(Constants.DestinationConstants destination, string orderDiv, string message, out string receiveMessage)
        {
            receiveMessage = "";

            // 電文送信先区分をチェックする
            switch (destination)
            {
                case Constants.DestinationConstants.PrintLabelToLains:      // ラベル印刷オーダ送信
                case Constants.DestinationConstants.ChangeStatusToRaypax:   // 状態変更オーダ送信
                    break;
                default:
                    string msg = "電文送信先区分に設定された値が不正です。";
                    throw new SendOrderException(msg);
            }

            // 送信電文をチェックする
            if (string.IsNullOrWhiteSpace(message))
            {
                string msg = "送信する電文が設定されていません。";
                throw new SendOrderException(msg);
            }

            // オーダ送信設定情報を取得する
            SendOrderSettingInfo sendOrderSettingInfo = null;
            try
            {
                sendOrderSettingInfo = SendOrderSettingInfo.ReadJsonFile();
            }
            catch (Exception ex)
            {
                string msg = "オーダ送信設定情報ファイルの取得でエラーが発生しました。";
                throw new SendOrderException(msg, ex);
            }

            // オーダ送信設定情報のソケット情報とメッセージ情報を取得する
            SendOrderSettingInfo.SocketInfo socketInfo = null;
            SendOrderSettingInfo.MsgInfo msgInfo = null;
            if (destination.Equals(Constants.DestinationConstants.PrintLabelToLains))
            {
                // ラベル印刷オーダ送信
                socketInfo = sendOrderSettingInfo.GetSocketInfo(Constants.SOCKETKEY_LAINS_PRINTLABEL);
                msgInfo = sendOrderSettingInfo.GetMsgInfo(Constants.MSGTKEY_LAINS_PRINTLABEL);
            }
            else if (destination.Equals(Constants.DestinationConstants.ChangeStatusToRaypax))
            {
                // 状態変更オーダ送信
                if (orderDiv.Equals(Constants.ORDERDIV_RAYPAX_TP))
                {
                    // 眼底オーダ（トプコン）
                    socketInfo = sendOrderSettingInfo.GetSocketInfo(Constants.SOCKETKEY_RAYPAX_TP);
                }
                else if (orderDiv.Equals(Constants.ORDERDIV_RAYPAX_FK))
                {
                    // ＣＡＶＩ・ＡＢＩ検査オーダ（フクダ電子）
                    socketInfo = sendOrderSettingInfo.GetSocketInfo(Constants.SOCKETKEY_RAYPAX_FK);
                }
                else
                {
                    // その他（横河）
                    socketInfo = sendOrderSettingInfo.GetSocketInfo(Constants.SOCKETKEY_RAYPAX_YG);
                }
                msgInfo = sendOrderSettingInfo.GetMsgInfo(Constants.MSGTKEY_RAYPAX);
            }

            if (socketInfo == null)
            {
                string msg = "ソケット設定情報を取得できません。";
                throw new SendOrderException(msg);
            }
            if (string.IsNullOrWhiteSpace(socketInfo.IpAddress))
            {
                string msg = "ソケット設定情報に未設定項目が存在します。";
                throw new SendOrderException(msg);
            }

            if (msgInfo == null)
            {
                string msg = "送信電文設定情報を取得できません。";
                throw new SendOrderException(msg);
            }
            if (msgInfo.Tags.Count() == 0)
            {
                string msg = "送信電文設定情報が未設定です。";
                throw new SendOrderException(msg);
            }

            // 受信電文の電文長を計算する
            var receiveByteLen = 
                msgInfo.Tags.Select(item => item.Length).Sum();

            // 応答種別の電文項目情報を取得する
            var tagSyubetu =
                msgInfo.Tags.Where(item => item.NameEn.Equals("SYUBETU")).FirstOrDefault();
            if (tagSyubetu == null)
            {
                string msg = "応答種別の電文項目情報を取得できません。";
                throw new SendOrderException(msg);
            }

            var result = Constants.ResponseValueConstants.Else;
            var retryCount = 0;

            while (true)
            {
                try
                {
                    // 相手側連携サーバに接続する
                    using (var client = new TcpClient(socketInfo.IpAddress.Trim(), socketInfo.PortNo))
                    using (var ns = client.GetStream())
                    {
                        // 送受信タイムアウト時間を設定する
                        ns.ReadTimeout = socketInfo.Timeout;
                        ns.WriteTimeout = socketInfo.Timeout;

                        // 電文を送信する
                        SendData(ns, message);

                        // 電文を受信する
                        receiveMessage = ReceiveData(ns, receiveByteLen);
                        if (receiveMessage.Equals(""))
                        {
                            string msg = "電文の受信に失敗しました。";
                            throw new SendOrderException(msg);
                        }

                        // 受信電文の応答種別を取得する
                        result = GetResponseValue(destination, tagSyubetu, receiveMessage);
                        if (result != Constants.ResponseValueConstants.Retry ||
                            retryCount >= 1)
                        {
                            // リトライ以外の場合
                            // もしくはリトライで、かつ既に１回リトライを行った場合は
                            // 処理を終了する
                            break;
                        }
                        else
                        {
                            // リトライ回数をカウントアップする
                            retryCount++;
                        }
                    }
                }
                catch (SendOrderException)
                {
                    throw;
                }
                catch (Exception ex)
                {
                    string msg = "相手側システムへの接続に失敗しました。";
                    throw new SendOrderException(msg, ex);
                }
            }

            // 処理結果を返す
            return result;
        }

        /// <summary>
        /// 電文送信処理
        /// </summary>
        /// <param name="ns">ソケットストリーム</param>
        /// <param name="message">送信電文</param>
        private void SendData(NetworkStream ns, string message)
        {
            // 送信電文をバイト配列に変換する
            var bytes = Strings.GetBytes(message);

            // 電文を送信する
            try
            {
                ns.Write(bytes, 0, bytes.Length);
                ns.Flush();
            }
            catch (IOException)
            {
                string msg = "電文送信タイムアウトが発生しました。";
                throw new SendOrderException(msg);
            }
        }

        /// <summary>
        /// 電文受信処理
        /// </summary>
        /// <param name="ns">ソケットストリーム</param>
        /// <param name="receiveByteLen">受信電文の電文長</param>
        /// <returns>受信電文</returns>
        private string ReceiveData(NetworkStream ns, int receiveByteLen)
        {
            using (var ms = new MemoryStream())
            {
                while (true)
                {
                    // データの一部を受信する
                    var receiveSize = 0;
                    var buffer = new byte[1024];
                    try
                    {
                        receiveSize = ns.Read(buffer, 0, buffer.Length);
                    }
                    catch (IOException)
                    {
                        string msg = "電文受信タイムアウトが発生しました。";
                        throw new SendOrderException(msg);
                    }

                    // ソケットが切断されたかをチェックする
                    if (receiveSize == 0)
                    {
                        string msg = "相手側システムが接続を切断しました。";
                        throw new SendOrderException(msg);
                    }

                    // 受信したデータを蓄積する
                    ms.Write(buffer, 0, receiveSize);

                    // 受信電文の電文長に満たない場合は受信処理を継続する
                    if (ms.ToArray().Length < receiveByteLen)
                    {
                        continue;
                    }

                    // 電文の受信が完了した場合
                    break;
                }

                // 受信したデータを返す
                return Strings.ConvertToString(ms.ToArray());
            }
        }

        /// <summary>
        /// 応答種別取得処理
        /// </summary>
        /// <param name="destination">電文送信先区分</param>
        /// <param name="tag">応答種別の電文項目情報</param>
        /// <param name="message">受信電文</param>
        /// <returns></returns>
        private Constants.ResponseValueConstants GetResponseValue(Constants.DestinationConstants destination, SendOrderSettingInfo.TagInfo tag, string message)
        {
            if (destination.Equals(Constants.DestinationConstants.PrintLabelToLains))
            {
                // ラベル印刷オーダ送信
                switch (Strings.SubstringEx(message, tag.StartPos, tag.Length))
                {
                    case "OK":  // 正常終了
                        return Constants.ResponseValueConstants.Ok;
                    case "N1":  // リトライ
                        return Constants.ResponseValueConstants.Retry;
                    case "N2":  // スキップ
                        return Constants.ResponseValueConstants.Skip;
                    case "N3":  // ダウン
                        return Constants.ResponseValueConstants.Down;
                    default:    // その他
                        return Constants.ResponseValueConstants.Else;
                }
            }
            else if (destination.Equals(Constants.DestinationConstants.ChangeStatusToRaypax))
            {
                // 状態変更オーダ送信
                switch (Strings.SubstringEx(message, tag.StartPos, tag.Length))
                {
                    case "00":  // 正常終了
                        return Constants.ResponseValueConstants.Ok;
                    case "10":  // リトライ
                        return Constants.ResponseValueConstants.Retry;
                    case "20":  // スキップ
                        return Constants.ResponseValueConstants.Skip;
                    case "30":  // ダウン
                        return Constants.ResponseValueConstants.Down;
                    default:    // その他
                        return Constants.ResponseValueConstants.Else;
                }
            }
            else
            {
                // その他
                return Constants.ResponseValueConstants.Else;
            }
        }
    }
}
