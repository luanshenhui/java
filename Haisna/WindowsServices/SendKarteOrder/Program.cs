using Fujitsu.Hainsi.WindowServices.Common;
using Model = Hainsi.Entity.Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Reflection;

namespace Fujitsu.Hainsi.WindowServices.SendKarteOrder
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
            Else,
        }

        /// <summary>
        /// 送信区分
        /// </summary>
        /// <remarks>※追加する場合、GetOrderTypeNameの名称も追加すること</remarks>
        private enum OrderType
        {
            NoOrder,                // 送信対象外
            New,                    // 新規オーダ
            Modify,                 // 修正オーダ
            Delete,                 // 削除オーダ
        }

        /// <summary>
        /// 電文情報クラス
        /// </summary>
        private static TelegramInfo TelegramInfo = null;

        /// <summary>
        /// 受信電文の電文長
        /// </summary>
        private static int RecieveByteLen = 0;

        /// <summary>
        /// 送信電文の電文長
        /// </summary>
        private static int SendByteLen = 0;

        /// <summary>
        /// 接続リトライ回数
        /// </summary>
        private static int ConnetctRetryCount = 0;

        /// <summary>
        /// 送信リトライ回数
        /// </summary>
        private static int SendRetryCount = 0;

        /// <summary>
        /// 発信元コード
        /// </summary>
        private static string FromCode = "K";

        /// <summary>
        /// 端末名
        /// </summary>
        private static string ComputerName = "";

        /// <summary>
        /// 利用者ID
        /// </summary>
        private static string UserId = "";

        /// <summary>
        /// 利用者氏名
        /// </summary>
        private static string UserName = "";

        /// <summary>
        /// 胸部Ｘ線撮影方法判定用
        /// </summary>
        private static string KyobuItemCode = "";

        /// <summary>
        /// XML部テンプレートファイル名
        /// </summary>
        private static string XmltmpName = "";

        /// <summary>
        /// Web API のベースURL
        /// </summary>
        private static string ApiUri = "";

        /// <summary>
        /// 送信済データ退避領域
        /// </summary>
        private static Model.SendKarteOrder.SendKarteOrder save_sendorderdata= null;    //送信オーダ情報
        private static Model.OrderedDoc2.OrderedDoc2 save_orderedDoc2 = null;       //送信済オーダテーブル情報

        /// <summary>
        /// エラーログ未出力フラグ
        /// </summary>
        private static bool errNotOutFlg = false;   

        /// <summary>
        /// 変換情報クラス
        /// </summary>
        private static ConvDataInfo convDataInfo = null;

        /// <summary>
        /// 変換情報ファイルの区分
        /// </summary>
        private const string CONV_ZAIRYO = "ZAIRYO";                //材料
        private const string CONV_SAISHU = "SAISHU";                //採取方法

        /// <summary>
        /// 婦人科オーダ種別
        /// </summary>
        private const string ORDERDIV_FUJINKA = "ORDDIV000005";

        /// <summary>
        /// 婦人科関連項目
        /// </summary>
        private const string MENS_S_1 = "6355203";                  //最終月経（開始）年
        private const string MENS_S_2 = "6355201";                  //最終月経（開始）月
        private const string MENS_S_3 = "6355202";                  //最終月経（開始）日
        private const string MENS_E_1 = "6355401";                  //最終月経（終了）月
        private const string MENS_E_2 = "6355402";                  //最終月経（終了）日

        private const string MENS_PRE_S_1 = "6355603";              //その前月経（開始）年
        private const string MENS_PRE_S_2 = "6355601";              //その前月経（開始）月
        private const string MENS_PRE_S_3 = "6355602";              //その前月経（開始）日
        private const string MENS_PRE_E_1 = "6355801";              //その前月経（終了）月
        private const string MENS_PRE_E_2 = "6355802";              //その前月経（終了）日

        /// <summary>
        /// アプリケーションのメイン エントリ ポイントです。
        /// </summary>
        public static void Main(string[] args)
        {
            // ログ出力クラスを初期化する
            Logging.Initialize(Logging.DestSystemConstants.Smile);

            // サービス名
            string serviceName = ConfigurationManager.AppSettings["ServiceName"].Trim();

            // 引数が存在する場合は
            // サービスのインストール／アンインストールを行う
            if (args.Length >= 1)
            {
                Install(serviceName, args);
                return;
            }

            // ホスト名
            string hostName = ConfigurationManager.AppSettings["ServerHostName"];

            // ポート番号
            string port = ConfigurationManager.AppSettings["ServerPort"];

            // ポーリング間隔
            string pollingInterval = ConfigurationManager.AppSettings["PollingInterval"];

            // ソケット受信タイムアウト
            string socketRecieveTimeout = ConfigurationManager.AppSettings["SocketRecieveTimeout"];

            // ソケット送信タイムアウト
            string socketSendTimeout = ConfigurationManager.AppSettings["SocketSendTimeout"];

            // サービスを開始する
            ServiceBase.Run(new Service(
                serviceName, hostName, port, pollingInterval, socketRecieveTimeout, socketSendTimeout)
            {
                OnStartCallback = OnStart,
                GetSourceDataCallback = GetSourceData,
                EditSendMessageCallback = EditSendMessage,
                IsEndOfReceptionCallback = IsEndOfReception,
                ReceptionCompletedCallback = ReceptionCompleted,
                OutoutErrLogMsgCallback = OutoutErrLogMsg,
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

            // 送受信電文の電文長を計算する
            foreach (TelegramInfo.TelegramItem item in TelegramInfo.Items)
            {
                // 受信電文の項目のバイト数を加算する
                if (item.RecvUseFlg == 1)
                {
                    RecieveByteLen += item.Length;
                }

                // 送信電文の項目のバイト数を加算する
                if (item.SendUseFlg == 1)
                {
                    SendByteLen += item.Length;
                }
            }

            //接続リトライ回数
            int.TryParse(ConfigurationManager.AppSettings["ConnetctRetryCount"], out ConnetctRetryCount);

            //送信リトライ回数
            int.TryParse(ConfigurationManager.AppSettings["SendRetryCount"], out SendRetryCount);

            // 発信元コード
            FromCode = ConfigurationManager.AppSettings["FromCode"].Trim();
            if (string.IsNullOrEmpty(FromCode))
            {
                throw new Exception("発信元コードが設定されていません。");
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

            // 利用者氏名
            UserName = ConfigurationManager.AppSettings["SendDataRiyosyaName"].Trim();
            if (string.IsNullOrEmpty(UserName))
            {
                throw new Exception("利用者氏名が設定されていません。");
            }

            // 胸部Ｘ線撮影方法判定用
            KyobuItemCode = ConfigurationManager.AppSettings["KyobuItemCode"].Trim();

            //XML部テンプレートファイル名
            XmltmpName = ConfigurationManager.AppSettings["XmlTemplateFileName"].Trim();

            // Web API のベースURL
            ApiUri = ConfigurationManager.AppSettings["ApiUri"].Trim();
            if (string.IsNullOrEmpty(ApiUri))
            {
                throw new Exception("Web API のベースURLが設定されていません。");
            }

            // 変換情報を取得する
            try
            {
                convDataInfo = ConvDataInfo.ReadJsonFile();
            }
            catch (Exception ex)
            {
                string msg = "変換情報ファイルの取得処理でエラーが発生しました。";
                throw new Exception(msg, ex);
            }

        }

        /// <summary>
        /// 送信対象データ取得処理コールバック
        /// </summary>
        /// <returns></returns>
        private static dynamic GetSourceData()
        {
            // 送信対象データ（オーダ依頼対象データ）を取得する
            Task<dynamic> taskGetData = WebAPI.GetDataAsync(
                ApiUri, "api/v1/sendorders/orderlist");

            if (taskGetData.Result != null && taskGetData.Result.Count > 0)
            {
                string msg = "オーダ依頼対象情報を取得しました。対象件数:" + taskGetData.Result.Count.ToString() + "件";

                Logging.Output(
                    Logging.LogTypeConstants.FreeOutput, "Program", "GetSourceData", msg);
            }

            // 取得した送信対象データを戻す
            return taskGetData.Result;
        }

        /// <summary>
        /// 送信電文編集処理コールバック
        /// </summary>
        /// <param name="data">送信データ</param>
        /// <returns></returns>
        private static string EditSendMessage(dynamic data)
        {
            StringBuilder message = new StringBuilder();

            string msg = "";

            //退避情報クリア
            save_sendorderdata = null;
            save_orderedDoc2 = null;

            //エラーログ未出力ログフラグオフ
            errNotOutFlg = false;

            try
            {
                bool breakFlg = false;

                while (true)
                {
                    //送信区分チェック
                    switch ((string)data.senddiv)
                    {
                        case "1":
                        case "3":
                            break;

                        default:
                            //送信区分が1or3以外の場合はエラー
                            msg = "　予約番号:" + ConvertNull(data.rsvno)
                                    + " 個人ID:" + ConvertNull(data.perid)
                                    + " 受診日:" + ((DateTime)data.csldate).ToString("yyyy/MM/dd")
                                    + " 氏名:" + ConvertNull(data.pername)
                                    + " 不明な送信区分のため対象外とします。";

                            Logging.Output(
                                Logging.LogTypeConstants.Error, "Program", "EditSendMessage", msg);

                            //次の受信データに移動する
                            breakFlg = true;
                            break;
                    }
                    if (breakFlg) {break;}; //エラー時は抜ける

                    if (data.doccode == null)
                    {
                        //送信対象オーダが存在しない場合
                        msg = "　予約番号:" + ConvertNull(data.rsvno)
                                + " 個人ID:" + ConvertNull(data.perid)
                                + " 受診日:" + ((DateTime)data.csldate).ToString("yyyy/MM/dd")
                                + " 氏名:" + ConvertNull(data.pername)
                                + " 送信対象オーダが存在しません。";
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "Program", "EditSendMessage", msg);

                        //次の受信データに移動する
                        breakFlg = true;
                        break;
                    }
                    else
                    {
                        //送信対象オーダが存在する場合
                        msg = "　予約番号:" + ConvertNull(data.rsvno)
                                + " 個人ID:" + ConvertNull(data.perid)
                                + " 受診日:" + ((DateTime)data.csldate).ToString("yyyy/MM/dd")
                                + " 氏名:" + ConvertNull(data.pername)
                                + " 送信対象件数:1件";
                        Logging.Output(
                            Logging.LogTypeConstants.FreeOutput, "Program", "EditSendMessage", msg);
                    }
                    if (breakFlg) { break; }; //エラー時は抜ける

                    //オーダ送信済テーブルを読み込む
                    dynamic orderedDocDb = null;
                    try
                    {
                        Task<dynamic> taskGetData = WebAPI.GetDataAsync(ApiUri
                                                            , "api/v1/sendorders/orderedRead?rsvno=" + (int)data.rsvno +
                                                                                "&orderno=" + (int)data.orderno);

                        orderedDocDb = taskGetData.Result;
                    }
                    catch (Exception ex)
                    {
                        msg = "オーダ送信済テーブルの取得処理でエラーが発生しました。";
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "Program", "EditSendMessage", msg, ex);

                        return "";  //エラー時は終了
                    }

                    //オーダー送信済情報を置き換え
                    Model.OrderedDoc2.OrderedDoc2 orderedDoc2 = null;
                    if (orderedDocDb != null)
                    {
                        //オーダ送信済み情報あり
                        orderedDoc2 = new Model.OrderedDoc2.OrderedDoc2()
                        {
                            Rsvno = (int)orderedDocDb[0].rsvno,
                            DocCode = (string)orderedDocDb[0].doccode,
                            DocSeq = (string)orderedDocDb[0].docseq,
                            OrderNo = (int)orderedDocDb[0].orderno,
                            CreateDate = (DateTime)orderedDocDb[0].createdate,
                            OrderSeq = (int)orderedDocDb[0].orderseq,
                            PerId = (string)orderedDocDb[0].perid,
                            CslDate = (DateTime)orderedDocDb[0].csldate,
                            Age = (short)orderedDocDb[0].age,
                            DayId = (int)orderedDocDb[0].dayid,
                            SendDate = (DateTime)orderedDocDb[0].senddate,
                            Cscd = "",
                        };
                    }
                    else
                    {
                        //オーダ送信済み情報なし
                        orderedDoc2 = new Model.OrderedDoc2.OrderedDoc2(){};
                    }

                    //送信区分：新規・変更
                    breakFlg = false;
                    OrderType orderType = OrderType.NoOrder;
                    switch ((int)data.senddiv)
                    {
                        case 1:
                            //送信区分：新規・変更
                            if (orderedDocDb == null)
                            {
                                //オーダ送信済テーブルのレコードが存在しない（新規オーダ）
                                orderType = OrderType.New;
                            }
                            else
                            {
                                //オーダ送信済テーブルのレコードが存在しない（変更オーダ）
                                orderType = OrderType.Modify;
                            }
                            break;

                        case 3:
                            //送信区分：削除
                            orderType = OrderType.Delete;

                            //削除なのにオーダ送信済みテーブルのデータが存在しない。
                            if (orderedDocDb == null)
                            {
                                //送信対象外に変更
                                msg = "　　オーダ種別:" + ConvertNull(data.doccode) + ConvertNull(data.docseq) + ConvertNull(data.docname)
                                            + " タイプ:" + GetOrderTypeName(orderType)
                                            + " 個人ID:" + ConvertNull(data.perid)
                                            + " 受診日:" + data.csldate.ToString("yyyy/MM/dd")
                                            + " 削除対象オーダ送信済み対象項目が存在しないため送信対象外に変更します。";
                                Logging.Output(
                                    Logging.LogTypeConstants.FreeOutput, "Program", "EditSendMessage", msg);
                                breakFlg = true;
                            }
                            break;
                    }
                    if (breakFlg){ break; }  //送信対象外の場合、抜ける

                    //受診情報テーブル・個人テーブルを読み込む
                    dynamic consultData = null;
                    try
                    {
                        Task<dynamic> taskGetData = WebAPI.GetDataAsync(ApiUri
                                                            , "api/v1/sendorders/cslinfo?rsvno=" + (int)data.rsvno);

                        consultData = taskGetData.Result;
                    }
                    catch (Exception ex)
                    {
                        msg = "受診情報・個人情報テーブルの取得処理でエラーが発生しました。";
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "Program", "EditSendMessage", msg, ex);
                        breakFlg = true;
                        break;
                    }

                    if (consultData == null)
                    {
                        //受診情報テーブルのレコードが存在しない場合
                        msg = "　　オーダ種別:" + (string)data.doccode + (string)data.docseq + (string)data.docname
                                    + " タイプ:" + GetOrderTypeName(orderType)
                                    + " 個人ID:"
                                    + " 受診日:"
                                    + " 予約番号:" + (string)data.rsvno
                                    + " 受診情報テーブルにデータが存在しないため送信対象外に変更します。";
                        Logging.Output(
                            Logging.LogTypeConstants.FreeOutput, "Program", "EditSendMessage", msg);

                        //送信対象外に変更
                        breakFlg = true;
                        break;
                    }

                    if (consultData[0].per_perid == null)
                    {
                        //個人情報テーブルのレコードが存在しない場合
                        msg = "　　オーダ種別:" + (string)data.doccode + (string)data.docseq + (string)data.docname
                                    + " タイプ:" + GetOrderTypeName(orderType)
                                    + " 個人ID:" + (string)consultData[0].perid
                                    + " 受診日:" + ((DateTime)consultData[0].csldate).ToString("yyyy/MM/dd")
                                    + " 個人テーブルにデータが存在しないため送信できません。";
                        Logging.Output(
                            Logging.LogTypeConstants.FreeOutput, "Program", "EditSendMessage", msg);

                        //送信対象外に変更
                        breakFlg = true;
                        break;
                    }

                    //送信オーダ情報を退避する
                    Model.SendKarteOrder.SendKarteOrder sendOrderData = null;
                    if (orderedDocDb != null)
                    {
                        //オーダ送信済み情報あり
                        sendOrderData = new Model.SendKarteOrder.SendKarteOrder()
                        {
                            RsvNo = orderedDoc2.Rsvno,
                            PerId = string.Format("{0:D10}", orderedDoc2.PerId),
                            CslDate = orderedDoc2.CslDate,
                            DocCode = orderedDoc2.DocCode,
                            DocSeq = orderedDoc2.DocSeq,
                            DocName = data.docname,
                            DocTitle = data.doctitle,
                            RootTag = data.roottag,
                            CslTime = data.csltime,
                            OrderNo = orderedDoc2.OrderNo,
                            CreateDate = orderedDoc2.CreateDate,
                            OrderSeq = orderedDoc2.OrderSeq,
                            OrderType = (int)orderType,
                            PerName = consultData[0].pername,
                            Birth = consultData[0].birth,
                            Gender = consultData[0].gender,
                            Age = orderedDoc2.Age,
                            DayID = orderedDoc2.DayId,
                            Cscd = orderedDoc2.Cscd, //空だが現行踏襲

                            Item = new List<Model.SendKarteOrder.SendKarteOrder.SendKarteOrderItem>(),
                            Bef_Item = new List<Model.SendKarteOrder.SendKarteOrder.SendKarteOrderItem>(),
                        };

                    }
                    else
                    {
                        //オーダ送信済み情報なし

                        //オーダ依頼情報と受診情報から設定
                        orderedDoc2.Rsvno = (int)data.rsvno;
                        orderedDoc2.DocCode = (string)data.doccode;
                        orderedDoc2.DocSeq = data.docseq;
                        orderedDoc2.OrderNo = data.orderno;
                        orderedDoc2.CreateDate = DateTime.Now;
                        orderedDoc2.OrderSeq = 1;
                        orderedDoc2.PerId = consultData[0].perid;
                        orderedDoc2.CslDate = consultData[0].csldate;
                        orderedDoc2.Age = consultData[0].age;
                        orderedDoc2.DayId = data.dayid;
                        orderedDoc2.Cscd = consultData[0].cscd;

                        sendOrderData = new Model.SendKarteOrder.SendKarteOrder()
                        {
                            RsvNo = orderedDoc2.Rsvno,
                            PerId = string.Format("{0:D10}", orderedDoc2.PerId),
                            CslDate = data.csldate,
                            DocCode = data.doccode,
                            DocSeq = data.docseq,
                            DocName = data.docname,
                            DocTitle = data.doctitle,
                            RootTag = data.roottag,
                            CslTime = data.csltime,
                            OrderNo = data.orderno,
                            CreateDate = orderedDoc2.CreateDate,
                            OrderSeq = orderedDoc2.OrderSeq,
                            OrderType = (int)orderType,
                            PerName = consultData[0].pername,
                            Birth = consultData[0].birth,
                            Gender = consultData[0].gender,
                            Age = orderedDoc2.Age,
                            DayID = data.dayid,
                            Cscd = orderedDoc2.Cscd, //空だが現行踏襲

                            Item = new List<Model.SendKarteOrder.SendKarteOrder.SendKarteOrderItem>(),
                            Bef_Item = new List<Model.SendKarteOrder.SendKarteOrder.SendKarteOrderItem>(),
                        };

                    }

                    breakFlg = false;
                    switch ((int)data.senddiv)
                    {
                        //送信区分：新規・変更
                        case 1:
                            //※前回項目を取得しても使用してないので、削除。念のため残す。
                            ////変更前のオーダ送信済項目テーブル・オーダ連携検査項目詳細テーブルを読み込み、
                            ////送信オーダ項目情報を取得する
                            //if (!GetSendOrderItem(ref sendOrderData, (string)data.orderdiv, true))
                            //{
                            //    msg = "変更前の送信オーダ項目情報の取得処理でエラーが発生しました。";
                            //    Logging.Output(
                            //        Logging.LogTypeConstants.Error, "Program", "EditSendMessage", msg);
                            //    return "";
                            //}

                            //削除後に現在のオーダ対象項目を更新する
                            Model.OrderedItem2.OrderedItem2 updOrderItem = new Model.OrderedItem2.OrderedItem2
                            {
                                Rsvno = orderedDoc2.Rsvno,
                                DocCode = orderedDoc2.DocCode,
                                DocSeq = orderedDoc2.DocSeq,
                                ItemCd = "",
                                Suffix = "",
                            };
                            if (!UpdOrderItem(ref updOrderItem, true
                                            , ConvertNull(data.orderdiv)
                                            , ConvertNull(data.targetitem1), ConvertNull(data.targetitem2)))
                            {
                                return "";
                            }

                            //変更後のオーダ送信済項目テーブル・オーダ連携検査項目詳細テーブルを読み込み、
                            //送信オーダ項目情報を取得する
                            if (!GetSendOrderItem(ref sendOrderData, (string)data.orderdiv, false))
                            {
                                msg = "送信オーダ項目情報の取得処理でエラーが発生しました。";
                                Logging.Output(
                                    Logging.LogTypeConstants.Error, "Program", "EditSendMessage", msg);
                                return "";
                            }

                            if (sendOrderData.Item.Count == 0 )
                            {
                                //新規・変更時に、対象項目がない
                                msg = "　　オーダ種別:" + (string)data.doccode + (string)data.docseq + (string)data.docname
                                            + " タイプ:" + GetOrderTypeName(orderType)
                                            + " 個人ID:" + orderedDoc2.PerId
                                            + " 受診日:" + ((DateTime)orderedDoc2.CslDate).ToString("yyyy/MM/dd")
                                            + " 対象となる送信データが無いため送信対象外に変更します。";
                                Logging.Output(
                                    Logging.LogTypeConstants.FreeOutput, "Program", "EditSendMessage", msg);

                                //送信対象外に変更
                                breakFlg = true;
                                break;
                            }

                            if (orderType == OrderType.Modify)
                            {
                                //修正オーダの場合のみ前回の版数に１を加算する
                                //（削除オーダの場合は前回の版数で送信する）
                                if ( orderedDoc2.OrderSeq < 99 )
                                {
                                    orderedDoc2.OrderSeq++;
                                    orderedDoc2.Cscd = consultData[0].cscd;

                                    sendOrderData.OrderSeq = orderedDoc2.OrderSeq;
                                }
                            }

                            break;

                        //送信区分：削除
                        case 3:
                            //オーダ送信済項目テーブル・オーダ連携検査項目詳細テーブルを読み込み、
                            //送信オーダ項目情報を取得する
                            if (!GetSendOrderItem(ref sendOrderData, (string)data.orderdiv, false))
                            {
                                msg = "削除時の送信オーダ項目情報の取得処理でエラーが発生しました。";
                                Logging.Output(
                                    Logging.LogTypeConstants.Error, "Program", "EditSendMessage", msg);
                                return "";
                            }

                            //削除オーダの場合は前回の版数で送信する
                            orderedDoc2.Cscd = consultData[0].cscd;
                            break;
                    }
                    if (breakFlg) { break; }  //送信対象外の場合、抜ける

                    //対象外の場合はオーダ依頼処理を行わない
                    if (orderType == OrderType.NoOrder)
                    {
                        //送信対象外
                        breakFlg = true;
                        break;
                    }

                    //オーダ依頼送信処理
                    string logHeadderMsg = "　　オーダ種別:" + sendOrderData.DocCode + sendOrderData.DocSeq + sendOrderData.DocName
                                + " タイプ:" + GetOrderTypeName(orderType)
                                + " 版数:" + sendOrderData.OrderSeq.ToString()
                                + " オーダ番号:" + sendOrderData.OrderNo
                                + " 個人ID:" + sendOrderData.PerId
                                + " 受診日:" + (sendOrderData.CslDate).ToString("yyyy/MM/dd");


                    //■電文編集

                    //＝ソケット共通部＝
                    // 連番
                    message.Append("00000");
                    // システムコード("H"固定)
                    message.Append("H".PadRightEx(1));
                    // 情報種別("IR"固定)
                    message.Append("IR".PadRightEx(2));
                    // 継続フラグ("E"固定)
                    message.Append("E".PadRightEx(1));
                    // 宛先コード("E"固定)
                    message.Append("E".PadRightEx(1));
                    // 発信元コード(configから取得)
                    message.Append(FromCode.PadRightEx(1));
                    // 処理年月日
                    message.Append(DateTime.Now.ToString("yyyyMMdd").PadRightEx(8));
                    // 処理時刻
                    message.Append(DateTime.Now.ToString("HHmmss").PadRightEx(6));
                    // 端末名(configから取得)
                    message.Append(ComputerName.PadRightEx(8));
                    // 利用者番号(configから取得)
                    message.Append(UserId.PadRightEx(8));
                    // 処理区分
                    string syoriKbn = "";
                    switch ((OrderType)sendOrderData.OrderType)
                    {
                        case OrderType.New:
                            //新規オーダ
                            syoriKbn = "01";
                            break;

                        case OrderType.Modify:
                            //修正オーダ
                            syoriKbn = "02";
                            break;

                        case OrderType.Delete:
                            //削除オーダ
                            syoriKbn = "03";
                            break;

                        default:
                            //
                            msg = logHeadderMsg + "オーダ処理区分が不正です。送信電文が正しく作成できません。";
                            Logging.Output(
                               Logging.LogTypeConstants.FreeOutput, "Program", "EditSendMessage", msg);
                            return "";  //終了
                    }

                    message.Append(syoriKbn.PadRightEx(2));
                    // 応答種別(空白)
                    message.Append("".PadRightEx(2));
                    // 電文長(空白)　※電文作成後に編集
                    message.Append("".PadRightEx(5));
                    // 予備(空白)
                    message.Append("".PadRightEx(14));

                    //＝メッセージ共通部＝
                    //メッセージ宛先(8バイト)
                    message.Append("EXSNBJ".PadRightEx(8));
                    //メッセージタイプ(1バイト)
                    message.Append("A".PadRightEx(1));
                    // 利用者ID(configから取得)
                    message.Append(UserId.PadRightEx(8));
                    // メッセージ送信日時(14バイト)
                    message.Append(DateTime.Now.ToString("yyyyMMddHHmmss").PadRightEx(14));
                    // 送信端末ＩＤ(8バイト)(configから取得)
                    message.Append(ComputerName.PadRightEx(8));
                    // 継続フラグ(1バイト)(空白)
                    message.Append("".PadRightEx(1));
                    // 緊急メッセージフラグ(1バイト)(空白)
                    message.Append("".PadRightEx(1));
                    // 予備(9バイト)(空白)
                    message.Append("".PadRightEx(9));

                    //＝メッセージ内容共通部＝
                    // パスワード(32バイト)(空白)
                    message.Append("".PadRightEx(32));
                    // 代替利用者ＩＤ(8バイト)(空白)
                    message.Append("".PadRightEx(8));
                    // 検索開始キー(120バイト)(空白)
                    message.Append("".PadRightEx(120));
                    // 検索件数(5バイト)(空白)
                    message.Append("".PadRightEx(5));
                    // エラー情報(1バイト)(空白)
                    message.Append("".PadRightEx(1));
                    // オーダ位置情報(6バイト)
                    message.Append(new string('0', 6));

                    //＝メッセージ内容部＝

                    //＝オーダ共通部＝
                    // 患者ＩＤ(10バイト)
                    message.Append(sendOrderData.PerId.PadRightEx(10));
                    // 入外(1バイト)
                    message.Append("1".PadRightEx(1));
                    // 明細行数(4バイト)
                    message.Append(string.Format("{0:D4}", sendOrderData.Item.Count + 1));
                    // 可変部行数(4バイト)
                    message.Append(new string('0', 4));

                    //＝オーダ固定項目部＝
                    //＝伝票行＝

                    // エラーレベル(1バイト)
                    message.Append("~".PadRightEx(1));
                    // エラーコード(4バイト)
                    message.Append("".PadRightEx(4));
                    // 形式種別(1バイト)
                    string keisyuKbn = "";
                    switch ((OrderType)sendOrderData.OrderType)
                    {
                        case OrderType.New:
                            //新規オーダ
                            keisyuKbn = "1";
                            break;

                        case OrderType.Modify:
                            //修正オーダ
                            keisyuKbn = "3";
                            break;

                        case OrderType.Delete:
                            //削除オーダ
                            keisyuKbn = "2";
                            break;
                    }
                    message.Append(keisyuKbn.PadRightEx(1));

                    // 文書形態(1バイト)
                    message.Append("2".PadRightEx(1));
                    // 文書種別コード(4バイト)
                    message.Append(sendOrderData.DocCode.PadRightEx(4));
                    // 文書番号(30バイト)
                    // "HAINS" + 受診日（yyyymmdd形式） + オーダ番号（8桁0詰め） + "000000000"
                    string bunno = "HAINS" + sendOrderData.CslDate.ToString("yyyyMMdd")
                                            + string.Format("{0:D8}", sendOrderData.OrderNo)
                                            + new string('0', 5)
                                            + string.Format("{0:D4}", sendOrderData.DayID);
                    message.Append(bunno.PadRightEx(30));
                    // 文書版数(2バイト)
                    message.Append(string.Format("{0:D2}", sendOrderData.OrderSeq));
                    // アクティブフラグ(1バイト)
                    message.Append("1".PadRightEx(1));
                    // 親文書番号(30バイト)
                    message.Append(bunno.PadRightEx(30));
                    // オーダ番号(8バイト)
                    message.Append(string.Format("{0:D8}", sendOrderData.OrderNo));
                    // 文書日付(14バイト)
                    message.Append(sendOrderData.CslDate.ToString("yyyyMMdd") + sendOrderData.CslTime);
                    // 終了日付(14バイト)
                    message.Append(sendOrderData.CslDate.ToString("yyyyMMdd") + sendOrderData.CslTime);
                    // 発生日時(14バイト)　※オーダ作成日に変更
                    message.Append(sendOrderData.CreateDate.ToString("yyyyMMddHHmmss"));
                    // 更新日時(14バイト)
                    string updDate = "";
                    switch ((OrderType)sendOrderData.OrderType)
                    {
                        case OrderType.New:
                            //新規オーダ
                            updDate = "".PadRightEx(14);
                            break;
                        case OrderType.Modify:
                        case OrderType.Delete:
                            //修正オーダ、削除オーダ
                            updDate = DateTime.Now.ToString("yyyyMMddHHmmss").PadRightEx(14);
                            break;
                    }
                    message.Append(updDate);
                    // 文書タイトル(28バイト)
                    message.Append(sendOrderData.DocTitle.PadRightEx(28));
                    // 予備(20バイト)
                    message.Append("".PadRightEx(20));

                    //＝項目行＝
                    foreach(var item in sendOrderData.Item)
                    {
                        // エラーレベル(1バイト)
                        message.Append("~");
                        // エラーコード(4バイト)
                        message.Append("".PadRightEx(4));
                        // 空白(1バイト)
                        message.Append("".PadRightEx(1));
                        // 項目コード(8バイト)
                        message.Append(item.ItemCode.PadRightEx(8));
                        // 連結項目コード(8バイト)
                        message.Append("".PadRightEx(8));
                        // 項目属性(3バイト)
                        message.Append(item.ItemAttr.PadRightEx(3));
                        // 項目名称(50バイト)
                        message.Append(item.ItemName.PadRightEx(50));
                        // 数量(10バイト)
                        message.Append(item.Num.PadRightEx(10));
                        // 極量指示フラグ(1バイト)
                        message.Append(item.Kflg.PadRightEx(1));
                        // 選択単位フラグ(1バイト)
                        message.Append(item.UnitSelFlg.PadRightEx(1));
                        // 選択単位コード(3バイト)
                        message.Append(item.UnitCode.PadRightEx(3));
                        // 選択単位名称(4バイト)
                        message.Append(item.UnitName.PadRightEx(4));
                        // 予備単位コード(3バイト)
                        message.Append("".PadRightEx(3));
                        // 予備単位名称(4バイト)
                        message.Append("".PadRightEx(4));
                        // 単位換算量(9バイト)
                        message.Append(item.Conv.PadRightEx(9));
                        // 項目行日時(14バイト)
                        message.Append(new string('0', 14));
                        // ＴＯＯＬ開放固定領域１(4バイト)
                        message.Append("".PadRightEx(4));
                        // ＴＯＯＬ開放固定領域２(30バイト)
                        message.Append(item.Tool2.PadRightEx(30));
                        // タグＩＮＤＥＸ(8バイト)
                        message.Append(item.TagIndex.PadRightEx(8));
                        // タグ名称(20バイト)
                        message.Append(item.TagName.PadRightEx(20));
                    }

                    // ＸＭＬ部
                    if (EditXmlData(sendOrderData, out string editData))
                    {
                        //正常終了の場合、取得データを設定
                        message.Append(editData);
                    }
                    else
                    {
                        //エラーの場合終了
                        return "";
                    }

                    //電文内に電文長を挿入する（46バイト目、5バイト）
                    int sendLen = System.Text.Encoding.GetEncoding(932).GetByteCount(message.ToString());
                    message.Remove(45, 5);
                    message.Insert(45, string.Format("{0:D5}", sendLen));

                    //送信データを退避
                    save_sendorderdata = sendOrderData;

                    //送信済データを退避
                    save_orderedDoc2 = orderedDoc2;

                    //ログ出力
                    msg = "　　オーダ種別:" + sendOrderData.DocCode + sendOrderData.DocSeq + sendOrderData.DocName
                        + " タイプ:" + GetOrderTypeName((OrderType)sendOrderData.OrderType)
                        + " 版数:" + sendOrderData.OrderSeq
                        + " オーダ番号:" + sendOrderData.PerId
                        + " 個人ID:" + sendOrderData.OrderNo
                        + " 受診日:" + sendOrderData.CslDate.ToString("yyyy/MM/dd")
                        + " オーダを送信します。";

                    Logging.Output(
                        Logging.LogTypeConstants.FreeOutput, "Program", "EditSendMessage", msg);
                    break;
                }

                //送信対象外の場合はこの時点でオーダテーブルを削除する
                if(breakFlg)
                {
                    //この場合はエラーログを出力しない
                    errNotOutFlg = true;

                    //オーダテーブルを削除して終了する
                    DeleteOrderTbl((int)data.rsvno, (DateTime)data.orderdate, (string)data.orderdiv);
                    return "";
                }

            }
            catch (Exception ex)
            {
                msg = "　予約番号:" + (string)data.rsvno
                        + " 個人ID:" + (string)data.perid
                        + " 受診日:" + ((DateTime)data.csldate).ToString("yyyy/MM/dd")
                        + " 氏名:" + (string)data.pername
                        + " 電文編集中にエラーが発生しました。";

                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "EditSendMessage", msg, ex);
                return "";
            }


            return message.ToString();
        }

        /// <summary>
        /// 受信終了判定コールバック
        /// </summary>
        /// <param name="memoryStream"></param>
        /// <returns></returns>
        private static bool IsEndOfReception(MemoryStream memoryStream)
        {
            // 受信済みデータを取得する
            byte[] receivedBytes = memoryStream.ToArray();

            if (receivedBytes.Length < RecieveByteLen)
            {
                // 共通情報部分まで受信できていない場合は
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
        /// <param name="data">送信対象データ</param>
        /// <param name="retryCount">リトライ回数</param>
        /// <param name="receivedStream">受信電文</param>
        /// <returns></returns>
        private static Service.RecieveResultConstants ReceptionCompleted(dynamic data, int retryCount, string receivedStream)
        {
            // 受信電文を解析する
            List<string> errorList = null;
            Dictionary<string, string> values = null;
            TelegramInfo.Parse(receivedStream, ref errorList, ref values);

            // 応答種別
            string resStatusNamne = "";
            ResponseStatus resStatus;
            resStatusNamne = values["K-ANS-SBT"];

            switch (resStatusNamne)
            {
                case "OK":
                    resStatus = ResponseStatus.Ok;
                    break;
                case "N1":
                    resStatus = ResponseStatus.Retry;
                    break;
                case "N2":
                    resStatus = ResponseStatus.Skip;
                    break;
                case "N3":
                    resStatus = ResponseStatus.Down;
                    break;
                default:
                    resStatus = ResponseStatus.Else;
                    break;
            }

            // 応答種別受信
            Logging.Output(Logging.LogTypeConstants.ResponseReceived,resStatusNamne);

            if (resStatus == ResponseStatus.Ok)
            {
                //受信成功時のみ

                //オーダ送信済文書テーブルを更新する
                if (!UpdOrderedDoc2(ref save_orderedDoc2, save_sendorderdata.OrderType))
                {
                    return Service.RecieveResultConstants.Error;
                }

                //削除オーダの場合
                if (save_sendorderdata.OrderType.Equals((int)OrderType.Delete))
                {
                    //削除のみ行う
                    Model.OrderedItem2.OrderedItem2 updOrderItem = new Model.OrderedItem2.OrderedItem2
                    {
                        Rsvno = save_orderedDoc2.Rsvno,
                        DocCode = save_orderedDoc2.DocCode,
                        DocSeq = save_orderedDoc2.DocSeq,
                        ItemCd = "",
                        Suffix = "",
                    };
                    if (!UpdOrderItem(ref updOrderItem, false
                                    , ConvertNull(data.orderdiv)
                                    , ConvertNull(data.targetitem1), ConvertNull(data.targetitem2)))
                    {
                        return Service.RecieveResultConstants.Error;
                    }
                }

                //オーダテーブルを削除する
                if (!DeleteOrderTbl((int)data.rsvno, (DateTime)data.orderdate, (string)data.orderdiv))
                {
                    return Service.RecieveResultConstants.Error;
                }
            }

            if (resStatus == ResponseStatus.Retry && retryCount == 0)
            {
                // 応答種別がリトライでかつ初回のみリトライを行う
                return Service.RecieveResultConstants.Retry;
            }
            else if (resStatus == ResponseStatus.Ok)
            {
                // 正常（成功）
                return Service.RecieveResultConstants.Success;
            }
            else
            {
                // その他（エラー）
                return Service.RecieveResultConstants.Error;
            }
        }

        /// <summary>
        /// エラー出力
        /// </summary>
        /// <param name="data">エラー対象データ</param>
        private static void OutoutErrLogMsg(dynamic data)
        {
            if (!errNotOutFlg)
            {
                string msg = "";

                msg = "電子チャートへの依頼の送信に失敗しました。";
                msg += string.Format("[個人ID:{0},予約番号:{1}]", data.perid, data.rsvno);

                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "OutoutErrLogMsg", msg);
            }

        }

        /// <summary>
        /// 送付区分名称取得
        /// </summary>
        /// <param name="orderType"></param>
        /// <returns></returns>
        private static string GetOrderTypeName(OrderType orderType)
        {
            string retName = "";

            switch(orderType)
            {
                case OrderType.NoOrder:
                    //送信対象外
                    retName = "対象外";
                    break;
                case OrderType.New:
                    //新規オーダ
                    retName = "新規";
                    break;
                case OrderType.Modify:
                    //修正オーダ
                    retName = "修正";
                    break;
                case OrderType.Delete:
                    //削除オーダ
                    retName = "削除";
                    break;
            }

            return retName;
        }

        /// <summary>
        /// XML部の生成
        /// </summary>
        /// <param name="sendOrderData">送信オーダ情報</param>
        /// <param name="editData">生成されたXML部</param>
        /// <returns>true/false</returns>
        private static bool EditXmlData(Model.SendKarteOrder.SendKarteOrder sendOrderData 
                                      , out string editData)
        {
            editData = "";

            //XMLテンプレートファイル名編集
            string xmlFilePath = Path.Combine(
                                 Path.GetDirectoryName(Assembly.GetEntryAssembly().Location), XmltmpName);

            //ファイルの有無確認
            if(!File.Exists( xmlFilePath))
            {
                //ファイルが存在しない場合、エラーで終了
                string msg = "XMLテンプレートファイルが存在しないためオーダ送信処理を行うことが出来ません。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "EditXmlData", msg);
                return false;
            }

            //テンプレートファイルのロード
            XmlDocument xmldoc = new XmlDocument
            {
                PreserveWhitespace = true
            };
            try
            {
                xmldoc.Load(xmlFilePath);
            }
            catch(Exception ex)
            {
                //ロード時にエラーが発生した場合、エラーで終了
                string msg = "XMLテンプレートファイルの読み込みに失敗したためオーダ送信処理を行うことが出来ません。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "UpdOrderItem", msg, ex);
                return false;
            }

            string tagHead = "";

            //＝基本情報部＝
            tagHead = "/DOCHEAD/DOCINFO-G";

            //文書種別コード
            xmldoc.SelectSingleNode(tagHead + "/DOCCODE").InnerText = sendOrderData.DocCode;

            //文書タイトル
            xmldoc.SelectSingleNode(tagHead + "/DOC-TITLE").InnerText = sendOrderData.DocTitle;

            //文書日付
            xmldoc.SelectSingleNode(tagHead + "/DOCDATE").InnerText = sendOrderData.CslDate.ToString("yyyyMMdd")
                                                                   + sendOrderData.CslTime;

            //終了日付
            if (sendOrderData.RsvCnt == "0")
            {
                //検体検査、輸血、病理の場合（予約枠数が"0"）
                //終了日付のタグを削除する
                xmldoc.SelectSingleNode(tagHead).RemoveChild(xmldoc.SelectSingleNode(tagHead + "/ENDDATE"));
            }
            else
            {
                //その他の場合
                //終了日付を出力する
                xmldoc.SelectSingleNode(tagHead + "/ENDDATE").InnerText = sendOrderData.CslDate.ToString("yyyyMMdd")
                                                                       + sendOrderData.CslTime;
            }

            //＝情報フラグ部＝
            //アクティブフラグ
            xmldoc.SelectSingleNode("/DOCHEAD/DOCFLG-G/ACT-FLG").InnerText = "1";


            //＝文書番号部＝
            tagHead = "/DOCHEAD/DOCNO-G";

            //文書番号
            xmldoc.SelectSingleNode(tagHead + "/DOCNO").InnerText =
                                                         "HAINS" + sendOrderData.CslDate.ToString("yyyyMMdd")
                                                       + string.Format("{0:D8}", sendOrderData.OrderNo)
                                                       + new string('0', 5)
                                                       + string.Format("{0:D4}", sendOrderData.DayID);
            //文書版数
            xmldoc.SelectSingleNode(tagHead + "/DOCSEQ").InnerText = string.Format("{0:D2}", sendOrderData.OrderSeq);

            //親文書番号
            xmldoc.SelectSingleNode(tagHead + "/PDOCNO").InnerText =
                                                         "HAINS" + sendOrderData.CslDate.ToString("yyyyMMdd")
                                                       + string.Format("{0:D8}", sendOrderData.OrderNo)
                                                       + new string('0', 5)
                                                       + string.Format("{0:D4}", sendOrderData.DayID);

            //オーダ番号
            xmldoc.SelectSingleNode(tagHead + "/ODRNO").InnerText = string.Format("{0:D8}", sendOrderData.OrderNo);

            //＝診療情報部＝
            //（xmlテンプレートより設定）

            //＝予約部＝
            //（xmlテンプレートより設定）

            //＝患者情報＝
            tagHead = "/DOCHEAD/PID-G";

            //患者ＩＤ
            xmldoc.SelectSingleNode(tagHead + "/PID").InnerText = sendOrderData.PerId;

            //患者表記名
            xmldoc.SelectSingleNode(tagHead + "/PID-NAME").InnerText = sendOrderData.PerName;

            //患者性別
            xmldoc.SelectSingleNode(tagHead + "/PID-SEX").InnerText = sendOrderData.Gender.ToString();

            //患者生年月日
            xmldoc.SelectSingleNode(tagHead + "/PID-BIRTH").InnerText = sendOrderData.Birth.ToString("yyyyMMdd");

            //患者年齢
            xmldoc.SelectSingleNode(tagHead + "/PID-AGE").InnerText = Math.Floor(sendOrderData.Age).ToString("000") + "0000";

            //＝文書状態部＝
            tagHead = "/DOCHEAD/DOCSTS-G/DEL-G";

            switch((OrderType) sendOrderData.OrderType)
            {
                case OrderType.Delete:
                    //削除オーダ

                    //ユーザID
                    xmldoc.SelectSingleNode(tagHead + "/DEL-UID").InnerText = UserId;

                    //日時
                    xmldoc.SelectSingleNode(tagHead + "/DEL-DATE").InnerText = DateTime.Now.ToString("yyyyMMddHHmmss");

                    break;

                default:
                    //その他（タグ削除）
                    xmldoc.SelectSingleNode("/DOCHEAD/DOCSTS-G").RemoveChild(xmldoc.SelectSingleNode(tagHead));
                    break;
            }

            //＝変更部＝
            tagHead = "/DOCHEAD/DOCSTS-G/UPD-G";

            switch ((OrderType)sendOrderData.OrderType)
            {
                case OrderType.Modify:
                    //修正オーダ

                    //ユーザID
                    xmldoc.SelectSingleNode(tagHead + "/UPD-UID").InnerText = UserId;

                    //日時
                    xmldoc.SelectSingleNode(tagHead + "/UPD-DATE").InnerText = DateTime.Now.ToString("yyyyMMddHHmmss");

                    break;

                default:
                    //その他（タグ削除）
                    xmldoc.SelectSingleNode("/DOCHEAD/DOCSTS-G").RemoveChild(xmldoc.SelectSingleNode(tagHead));
                    break;
            }

            //＝依頼部＝
            tagHead = "/DOCHEAD/DOCSTS-G/IRI-G";

            switch ((OrderType)sendOrderData.OrderType)
            {
                case OrderType.New:
                case OrderType.Delete:
                    //新規・削除オーダ

                    //ユーザID
                    xmldoc.SelectSingleNode(tagHead + "/IRI-UID").InnerText = UserId;

                    //日時
                    //　受診日にする
                    xmldoc.SelectSingleNode(tagHead + "/IRI-DATE").InnerText = sendOrderData.CslDate.ToString("yyyyMMdd") + "000000";
                    break;

                default:
                    //その他（タグ削除）
                    xmldoc.SelectSingleNode("/DOCHEAD/DOCSTS-G").RemoveChild(xmldoc.SelectSingleNode(tagHead));
                    break;
            }

            //＝部門発生状態部＝
            tagHead = "/DOCHEAD/DOCSTS-G/BMCR-G";

            //ユーザID
            xmldoc.SelectSingleNode(tagHead + "/BMCR-UID").InnerText = UserId;

            //日時
            xmldoc.SelectSingleNode(tagHead + "/BMCR-DATE").InnerText = DateTime.Now.ToString("yyyyMMddHHmmss");


            //＝発生情報（記載情報）＝
            tagHead = "/DOCHEAD/CR-G";

            //発生者ID
            xmldoc.SelectSingleNode(tagHead + "/CR-UID").InnerText = UserId;

            //発生者
            xmldoc.SelectSingleNode(tagHead + "/CR-UNAME").InnerText = UserName;

            //発生日時　※オーダ作成日に変更
            xmldoc.SelectSingleNode(tagHead + "/CR-DATE").InnerText = sendOrderData.CreateDate.ToString("yyyyMMddHHmmss");

            //＝更新部＝
            tagHead = "/DOCHEAD/OP-G";

            //更新者ID
            xmldoc.SelectSingleNode(tagHead + "/OP-UID").InnerText = UserId;

            //更新者
            xmldoc.SelectSingleNode(tagHead + "/OP-UNAME").InnerText = UserName;

            //更新日時
            xmldoc.SelectSingleNode(tagHead + "/OP-DATE").InnerText = DateTime.Now.ToString("yyyyMMddHHmmss");

            //更新依頼医ID
            xmldoc.SelectSingleNode(tagHead + "/OP-RID").InnerText = UserId;

            //更新依頼医名
            xmldoc.SelectSingleNode(tagHead + "/OP-RNAME").InnerText = UserName;

            //編集したXMLデータの取得
            string retData = xmldoc.SelectSingleNode("/DOCHEAD").OuterXml;

            editData = "<DOCCNT>1</DOCCNT><DOC><" + sendOrderData.RootTag + ">"
                        + retData + "</" + sendOrderData.RootTag + "></DOC>";

            xmldoc = null;

            return true;

        }

        /// <summary>
        /// 送信オーダ項目情報を取得
        /// </summary>
        /// <param name="sendOrderData">送信オーダ情報</param>
        /// <param name="orderDiv">オーダ種別</param>
        /// <param name="kizonflg">既存データフラグ（true：既存データ読み込み、false=今回編集データ読み込み）</param>
        /// <returns>true/false</returns>
        private static bool GetSendOrderItem(ref Model.SendKarteOrder.SendKarteOrder sendOrderData
                                           , string orderDiv, bool kizonflg)
        {
            bool ret = false;

            //一時項目格納領域
            List<Model.SendKarteOrder.SendKarteOrder.SendKarteOrderItem>
                    itemList = new List<Model.SendKarteOrder.SendKarteOrder.SendKarteOrderItem>();

            //項目情報読み込み
            try
            {
                Task<dynamic> taskGetData = WebAPI.GetDataAsync(ApiUri
                                                    , "api/v1/sendorders/orderItem?"
                                                    + "orderdiv=" + orderDiv
                                                    + "&rsvno=" + sendOrderData.RsvNo
                                                    + "&docCode=" + sendOrderData.DocCode
                                                    + "&docSeq=" + sendOrderData.DocSeq
                                                    );

                if (taskGetData.Result != null)
                {
                    //データ取得
                    foreach (var rec in taskGetData.Result)
                    {
                        Model.SendKarteOrder.SendKarteOrder.SendKarteOrderItem
                            itemRec = new Model.SendKarteOrder.SendKarteOrder.SendKarteOrderItem
                            {
                                ItemCode = ConvertNull(rec.icode),
                                ItemAttr = ConvertNull(rec.iattr),
                                ItemName = ConvertNull(rec.iname),
                                Num = ConvertNull(rec.num),
                                Kflg = ConvertNull(rec.kflg),
                                UnitSelFlg = ConvertNull(rec.uslct),
                                UnitCode = ConvertNull(rec.ucode),
                                UnitName = ConvertNull(rec.unit),
                                Conv = ConvertNull(rec.conv),
                                TagIndex = ConvertNull(rec.tagindex),
                                TagName = ConvertNull(rec.tagname),
                                Tool2 = ConvertNull(rec.tool2),
                                SetFlg = (ConvertNull(rec.setflg) == "1"),
                                SetGrpCd = ConvertNull(rec.setgrpcd),
                                SendFlg = true,
                                EditInfo = ConvertNull(rec.editinfo)
                            };

                        //データ追加
                        itemList.Add(itemRec);

                    }

                }

            }
            catch
            {
                return false;
            }

            //取得データの調整
            try
            {
                for (int i = 0; i <= itemList.Count - 1; i++)
                {
                    if (itemList[i].SendFlg == true)
                    {
                        //送信フラグがtrueの場合、同じセットグループの項目の送信フラグをfalseにする
                        if( (!string.IsNullOrEmpty(itemList[i].ItemCode))
                                && (!string.IsNullOrEmpty(itemList[i].SetGrpCd))
                                && (itemList[i].SetFlg == true))
                        {
                            for (int j = i + 1; j <= itemList.Count - 1; j++)
                            {
                                if( (itemList[j].ItemCode == itemList[i].ItemCode) 
                                    && (itemList[j].SetGrpCd == itemList[i].SetGrpCd)
                                    && (itemList[j].SetFlg == true))
                                {
                                    itemList[j].SendFlg = false;
                                }
                            }
                        }
                    }
                }

                //婦人科編集
                while(true)
                {
                    //オーダ種別が婦人科以外の場合
                    if(orderDiv != ORDERDIV_FUJINKA)
                    {
                        //スキップ
                        break;
                    }

                    //最終月経、その前の月経を事前に読み込み編集する
                    List<string> rslData = new List<string>();

                    //材料となる結果を取得
                    for ( int i = 1; i <= 10; i++)
                    {
                        string temp = "";

                        switch (i)
                        {
                            case 1:
                                temp = MENS_S_1;break;
                            case 2:
                                temp = MENS_S_2;break;
                            case 3:
                                temp = MENS_S_3;break;
                            case 4:
                                temp = MENS_E_1;break;
                            case 5:
                                temp = MENS_E_2;break;
                            case 6:
                                temp = MENS_PRE_S_1;break;
                            case 7:
                                temp = MENS_PRE_S_2;break;
                            case 8:
                                temp = MENS_PRE_S_3;break;
                            case 9:
                                temp = MENS_PRE_E_1;break;
                            case 10:
                                temp = MENS_PRE_E_2;break;
                        }

                        string itemcd = "";
                        string suffix = "";
                        if (temp.Length > 5)
                        {
                            itemcd = temp.Substring(0, 5);
                            suffix = temp.Substring(5, 2);
                        }

                        if ((string.IsNullOrEmpty(itemcd)) || (string.IsNullOrEmpty(suffix))){continue;}

                        //該当結果取得
                        if (!GetResult(sendOrderData.RsvNo, itemcd, suffix, out string result))
                        {
                            //エラーはスルー
                        }

                        //結果追加
                        rslData.Add(result);
                    }

                    string buff = "";

                    string Mens_S = ""; //最終月経開始
                    string Mens_E = ""; //最終月経終了
                    string Mens_Pre_S = ""; //その前の月経（開始）
                    string Mens_Pre_E = ""; //その前の月経（終了）

                    //最終月経（開始）
                    buff = rslData[0] + "/" + rslData[1] + "/" + rslData[2];
                    if ( DateTime.TryParse(buff, out DateTime Mens_S_date))
                    {
                        Mens_S = Mens_S_date.ToString("yyyyMMdd");
                    }

                    //最終月経（終了）
                    buff = rslData[0] + "/" + rslData[3] + "/" + rslData[4];
                    if (DateTime.TryParse(buff, out DateTime Mens_E_date))
                    {
                        if(!string.IsNullOrEmpty(Mens_S))
                        {
                            if (Mens_S_date > Mens_E_date)
                            {
                                //開始日の方が大きくなる場合、終了日の年を１年増やす。(年末の期間を想定）
                                Mens_E_date = Mens_E_date.AddYears(1);
                                Mens_E = Mens_E_date.ToString("yyyyMMdd");
                            }
                            else
                            {
                                Mens_E = Mens_E_date.ToString("yyyyMMdd");
                            }
                        }
                    }

                    //その前の月経（開始）
                    buff = rslData[5] + "/" + rslData[6] + "/" + rslData[7];
                    if (DateTime.TryParse(buff, out DateTime Mens_Pre_S_date))
                    {
                        Mens_Pre_S = Mens_Pre_S_date.ToString("yyyyMMdd");
                    }

                    //その前の月経（終了）
                    buff = rslData[5] + "/" + rslData[8] + "/" + rslData[9];
                    if (DateTime.TryParse(buff, out DateTime Mens_Pre_E_date))
                    {
                        if (!string.IsNullOrEmpty(Mens_Pre_S))
                        {
                            if (Mens_Pre_S_date > Mens_Pre_E_date)
                            {
                                //開始日の方が大きくなる場合、終了日の年を１年増やす。(年末の期間を想定）
                                Mens_Pre_E_date = Mens_Pre_E_date.AddYears(1);
                                Mens_Pre_E = Mens_Pre_E_date.ToString("yyyyMMdd");
                            }
                            else
                            {
                                Mens_Pre_E = Mens_Pre_E_date.ToString("yyyyMMdd");
                            }
                        }
                    }

                    //婦人科細胞診の場合はORDERINFOを取得する
                    dynamic yudoOrderInfo = null;
                    bool yudoOrderExistFlg = false;

                    try
                    {
                        Task<dynamic> taskGetData = WebAPI.GetDataAsync(ApiUri
                                                 , "api/v1/sendorders/yudoInfo?"
                                                 + "rsvno=" + sendOrderData.RsvNo
                                                 + "&orderDiv=" + orderDiv
                                                 + "&orderNo=" + sendOrderData.OrderNo);
                        

                        yudoOrderInfo = taskGetData.Result;

                    }
                    catch
                    {
                        //オーダ情報読み込みでエラー
                        string msg = "　　予約番号:" + sendOrderData.RsvNo
                                    + " オーダ種別:" + orderDiv
                                    + " オーダ番号:" + sendOrderData.OrderNo
                                    + " 婦人科細胞診オーダ情報の取得でエラーが発生しました";
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "Program", "GetSendOrderItem", msg);
                        break;
                    }

                    if (yudoOrderInfo != null && yudoOrderInfo.Count > 0)
                    {
                        yudoOrderExistFlg = true;
                    }
                    else
                    {
                        //オーダ情報が見つからない
                        yudoOrderExistFlg = false;
                        string msg = "　　予約番号:" + sendOrderData.RsvNo
                                    + " オーダ種別:" + orderDiv
                                    + " オーダ番号:" + sendOrderData.OrderNo
                                    + " で対象となる婦人科細胞診オーダ情報(ORDERINFO)がありません。";
                        Logging.Output(
                            Logging.LogTypeConstants.Error, "Program", "GetSendOrderItem", msg);
                    }

                    //編集処理
                    foreach (Model.SendKarteOrder.SendKarteOrder.SendKarteOrderItem rec in itemList)
                    {
                        string editResult = "";
                        string[] ItemCodes = new string[0];
                        string[] RslCodes = new string[0];
                        dynamic RslDatas = null;
                        bool findFlg = false;

                        //ITEMORDERDETAILのEditInfoを"_"で分解
                        string[] editItems = ItemSplit(rec.EditInfo, "_", 1);

                        switch(editItems[1])
                        {
                            case "FJN-EV1":      //細胞診材料名
                                if (yudoOrderExistFlg)
                                {
                                    //変換
                                    if (GetZairyoConv((int)yudoOrderInfo[0].zaicd, (string)yudoOrderInfo[0].saisyucd
                                                    , (int)yudoOrderInfo[0].hosokucd
                                                    , out string convIcode, out string convIname))
                                    {
                                        rec.ItemCode = convIcode;
                                        rec.ItemName = convIname;
                                        // 材料名に個数を追加する「子宮 腟部（指定なし） 2個　　など」
                                        if (yudoOrderExistFlg)
                                        {
                                            if ((int)yudoOrderInfo[0].cnt > 0)
                                            {
                                                rec.ItemName = rec.ItemName + " " + yudoOrderInfo[0].cnt + "個";
                                            }
                                        }
                                    }
                                }
                                break;

                            case "FJN-EVB":      //採取方法
                                if (yudoOrderExistFlg)
                                {
                                    //変換
                                    if (GetSHouhouConv((string)yudoOrderInfo[0].shouhoucd
                                                      , out string convIcode, out string convIname))
                                    {
                                        rec.ItemCode = convIcode;
                                        rec.ItemName = convIname;
                                    }
                                }
                                break;

                            case "FJN-CDAL":     //コードセット（制限なし）
                                editResult = "";

                                // 再度EditInfoを補正
                                editItems = ItemSplit(rec.EditInfo, "_", 2);

                                // 項目コード設定を分解して取得
                                ItemCodes = ItemSplit(editItems[2], "|", 1);

                                //結果取得
                                if (!GetResults(sendOrderData.RsvNo, ItemCodes, out RslDatas))
                                {
                                    //エラーはスルー
                                }

                                //最初に出現した結果データを取得
                                foreach (var rsl in RslDatas)
                                {
                                    if ((rsl != null) && (!string.IsNullOrEmpty(ConvertNull(rsl))))
                                    {
                                        //値を退避して抜ける
                                        editResult = rsl;
                                        break;
                                    }
                                }

                                //結果セット
                                rec.ItemName = editResult;

                                break;

                            case "FJN-CDIN":    //コードセット（指定コードのみ）
                                editResult = "";

                                // 再度EditInfoを補正
                                editItems = ItemSplit(rec.EditInfo, "_", 3);

                                // 項目コード設定を分解して取得
                                ItemCodes = ItemSplit(editItems[2], "|", 1);

                                //結果取得
                                if (!GetResults(sendOrderData.RsvNo, ItemCodes, out RslDatas))
                                {
                                    //エラーはスルー
                                }

                                // 検査結果設定を分解して取得
                                RslCodes = ItemSplit(editItems[3], "|", 1);

                                //最初に出現した指定結果データを取得
                                findFlg = false;
                                foreach (var rsl in RslDatas)
                                {
                                    if ((rsl != null) && (!string.IsNullOrEmpty(ConvertNull(rsl))))
                                    {
                                        //EditInfoに設定された指定結果かチェック
                                        foreach (string rslcode in RslCodes)
                                        {
                                            if((rslcode != null) && ((string)rsl == rslcode))
                                            {
                                                //EditInfoに設定された指定結果がある場合、値を退避して抜ける
                                                editResult = rsl;
                                                findFlg = true;
                                                break;
                                            }
                                        }
                                        if (findFlg) { break; }
                                    }
                                }

                                //結果セット
                                rec.ItemName = editResult;
                                break;

                            case "FJN-CDEL":   //コードセット（指定コード以外）
                                editResult = "";

                                // 再度EditInfoを補正
                                editItems = ItemSplit(rec.EditInfo, "_", 3);

                                // 項目コード設定を分解して取得
                                ItemCodes = ItemSplit(editItems[2], "|", 1);

                                //結果取得
                                if (!GetResults(sendOrderData.RsvNo, ItemCodes, out RslDatas))
                                {
                                    //エラーはスルー
                                }

                                // 検査結果設定を分解して取得
                                RslCodes = ItemSplit(editItems[3], "|", 1);

                                //最初に出現した指定結果以外のデータを取得
                                findFlg = false;
                                foreach (var rsl in RslDatas)
                                {
                                    if ((rsl != null) && (!string.IsNullOrEmpty(ConvertNull(rsl))))
                                    {
                                        //EditInfoに設定された指定結果以外かチェック
                                        foreach (string rslcode in RslCodes)
                                        {
                                            if ((rslcode != null) && ((string)rsl != rslcode))
                                            {
                                                //EditInfoに設定された指定結果以外がある場合、値を退避して抜ける
                                                editResult = rsl;
                                                findFlg = true;
                                                break;
                                            }
                                        }
                                        if (findFlg) { break; }
                                    }
                                }

                                //結果セット
                                rec.ItemName = editResult;
                                break;

                            case "FJN-VLN":  //数値セット（編集なし）
                                editResult = "";

                                // 再度EditInfoを補正
                                editItems = ItemSplit(rec.EditInfo, "_", 2);

                                // 対象結果を検索
                                ItemCodes = new string[] { editItems[2] };

                                //結果取得
                                if (!GetResults(sendOrderData.RsvNo, ItemCodes, out RslDatas))
                                {
                                    //エラーはスルー
                                }

                                // 取得結果をそのまま
                                editResult = RslDatas[0];

                                // 結果セット
                                rec.ItemName = editResult;

                                break;

                            case "FJN-VLNF": //数値セット（ゼロ詰め編集）
                                editResult = "";

                                // 再度EditInfoを補正
                                editItems = ItemSplit(rec.EditInfo, "_", 3);

                                // 対象結果を検索
                                ItemCodes = new string[] { editItems[2] };
                            
                                if (!GetResults(sendOrderData.RsvNo, ItemCodes, out RslDatas))
                                {
                                    //エラーはスルー
                                }

                                // 桁取得
                                int.TryParse(editItems[3], out int keta);

                                // 取得結果を指定桁数でゼロ詰め編集
                                if (!string.IsNullOrEmpty((string)RslDatas[0]))
                                {
                                    editResult = Convert.ToString(RslDatas[0]).PadLeft(keta, '0');
                                }

                                // 結果セット
                                rec.ItemName = editResult;

                                break;

                            case "FJN-OPE": //婦人科手術歴
                                editResult = "";

                                // 再度EditInfoを補正
                                editItems = ItemSplit(rec.EditInfo, "_", 5);

                                // 対象結果を検索
                                ItemCodes = new string[] { editItems[2], editItems[3] };    //手術項目コード,当院・他院項目コード

                                if (!GetResults(sendOrderData.RsvNo, ItemCodes, out RslDatas))
                                {
                                    //エラーはスルー
                                }

                                // 「手術項目」の検査結果があった場合は結果をそのままセット。
                                // ただし、「当院・他院」の検査結果が”他院”の場合は"2"をセットし、かつICODEも変更する。
                                if (RslDatas[0] != "")
                                {
                                    rec.ItemName = RslDatas[1];
                                    if ((string)RslDatas[1] == editItems[4])
                                    {
                                        //場所が他院だった場合 INAME="2"、ICODE=指定のコードへ変更
                                        rec.ItemName = "2";
                                        if (editItems[5] != "")
                                        {
                                            rec.ItemCode = editItems[5];
                                        }
                                    }
                                }
                                break;

                            case "FJN-MENS-S":  //最終月経（開始年月日）
                                rec.ItemName = Mens_S;
                                break;

                            case "FJN-MENS-E":  //最終月経（終了年月日）
                                rec.ItemName = Mens_E;
                                break;

                            case "FJN-MENS-PRE-S":  //その前の月経（開始年月日）
                                rec.ItemName = Mens_Pre_S;
                                break;

                            case "FJN-MENS-PRE-E":  //その前の月経（終了年月日）
                                rec.ItemName = Mens_Pre_E;
                                break;
                        }

                    }

                    break;
                }

                //データ設定
                if(kizonflg == true)
                {
                    //既存フラグがtrueの場合
                    sendOrderData.Bef_Item = new List<Model.SendKarteOrder.SendKarteOrder.SendKarteOrderItem>();

                    //送信フラグが立っているデータを追加
                    for (int i = 0; i <= itemList.Count - 1; i++)
                    {
                        if( itemList[i].SendFlg)
                        {
                            //データ追加
                            sendOrderData.Bef_Item.Add(itemList[i]);
                        }
                    }
                }
                else
                {
                    //既存フラグがfalseの場合
                    sendOrderData.Item = new List<Model.SendKarteOrder.SendKarteOrder.SendKarteOrderItem>();

                    //送信フラグが立っているデータを追加
                    for (int i = 0; i <= itemList.Count - 1; i++)
                    {
                        if (itemList[i].SendFlg)
                        {
                            //データ追加
                            sendOrderData.Item.Add(itemList[i]);
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "GetSendOrderItem", "", ex);
                return false;
            }

            //戻り値設定
            ret = true;

            return ret;
        }

        /// <summary>
        /// 送信済オーダ文書２情報を更新
        /// </summary>
        /// <param name="updItem">更新対象データ</param>
        /// <param name="orderType">送信区分</param>
        /// <returns></returns>

        private static bool UpdOrderedDoc2(ref Model.OrderedDoc2.OrderedDoc2 updItem, int orderType)
        {
            try
            {
                Task<dynamic> taskPostData = WebAPI.PostDataAsync
                                                <Model.OrderedDoc2.OrderedDoc2>
                                                (ApiUri, "api/v1/sendorders/orderedUpd"
                                                        + "?orderType=" + orderType
                                                        , updItem);

                taskPostData.Wait();
            }
            catch (Exception ex)
            {
                string msg = "送信済オーダ文書２の更新処理でエラーが発生しました。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "UpdOrderedDoc2", msg, ex);
                return false;
            }

            return true;
        }

        /// <summary>
        /// 送信オーダ項目情報を更新
        /// </summary>
        /// <param name="updItem">更新対象データ</param>
        /// <param name="insertFlg">レコード作成フラグ</param>
        /// <param name="orderDiv">オーダ種別</param>
        /// <param name="targetItemCd1">オーダ情報取得用項目コード１</param>
        /// <param name="targetItemCd2">オーダ情報取得用項目コード２</param>
        /// <returns></returns>
        private static bool UpdOrderItem(ref Model.OrderedItem2.OrderedItem2 updItem, bool insertFlg
                                       , string orderDiv, string targetItemCd1, string targetItemCd2)
        {
            try
            {
                Task<dynamic> taskPostData = WebAPI.PostDataAsync
                                                <Model.OrderedItem2.OrderedItem2>
                                                (ApiUri, "api/v1/sendorders/orderItemUpd"
                                                        + "?InsertFlg=" + insertFlg
                                                        + "&orderDiv=" + orderDiv
                                                        + "&targetItemCd1=" + targetItemCd1
                                                        + "&targetItemCd2=" + targetItemCd2
                                                        + "&kyobuItemCode=" + KyobuItemCode
                                                        , updItem);

                taskPostData.Wait();
            }
            catch (Exception ex)
            {
                string msg = "送信オーダ項目情報の更新処理でエラーが発生しました。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "UpdOrderItem", msg, ex);
                return false;
            }

            return true;
        }

        /// <summary>
        /// 送信オーダテーブル情報を削除
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <param name="orderDate">オーダ日付</param>
        /// <param name="orderDiv">オーダ種別</param>
        /// <returns></returns>
        private static bool DeleteOrderTbl(int rsvno, DateTime orderDate, string orderDiv)
        {
            try
            {

                Model.SendKarteOrder.UpdateOrderTbl updItem = new Model.SendKarteOrder.UpdateOrderTbl
                {
                    RsvNo = rsvno,
                    OrderDate = orderDate,
                    OrderDiv = orderDiv
                };

                Task<dynamic> taskPostData = WebAPI.PostDataAsync
                                                <Model.SendKarteOrder.UpdateOrderTbl>
                                                (ApiUri, "api/v1/sendorders/orderlistDel"
                                                        , updItem 
                                                        );

                taskPostData.Wait();
            }
            catch (Exception ex)
            {
                string msg = "送信オーダテーブル情報の削除でエラーが発生しました。";
                Logging.Output(
                    Logging.LogTypeConstants.Error, "Program", "DeleteOrderTbl", msg, ex);
                return false;
            }

            return true;
        }
        
        /// <summary>
        /// 文字分解
        /// </summary>
        /// <param name="buff">変換対象文字列</param>
        /// <param name="delimiter">デリミタ</param>
        /// <param name="minCount">最小配列数</param>
        /// <returns></returns>
        private static string[] ItemSplit(string buff, string delimiter = ",", int minCount = 0)
        {
            string[] retList = new String[1];

            //文字列分解
            string[] array = buff.Split(Convert.ToChar(delimiter));

            //取得したデータを配列１番目から再設定する
            for(int i = 0; i <= array.Length - 1; i++)
            {
                Array.Resize(ref retList, retList.Length + 1);
                retList[retList.Length - 1] = array[i];
            }

            //最小の配列数が指定されている場合には要素を拡張する
            if(retList.Length < minCount)
            {
                Array.Resize(ref retList, minCount);
            }

            return retList;
        }

        /// <summary>
        /// 細胞診材料名（EV1）変換
        /// </summary>
        /// <param name="zaiCd">材料</param>
        /// <param name="saisyuCd">採取部位</param>
        /// <param name="hosokuCd">補足</param>
        /// <param name="convIcode">変換後コード</param>
        /// <param name="convIname">変換後名称</param>
        /// <returns></returns>
        private static bool GetZairyoConv(int zaiCd, string saisyuCd, int hosokuCd, out string convIcode, out string convIname)
        {
            bool ret = false;
            convIcode = "";
            convIname = "";

            //材料、採取部位、補足を"-"で結合したものをキーとする
            string key = zaiCd + "-" + saisyuCd + "-" + hosokuCd;

            ConvDataInfo.ConvInfoDetail retDetail = convDataInfo.GetItem(CONV_ZAIRYO, key);

            if (retDetail != null)
            {
                convIcode = retDetail.ConvCode;
                convIname = retDetail.ConvName;

                ret = true; 
            }

            return ret;
        }

        /// <summary>
        /// 採取方法（EVB）変換
        /// </summary>
        /// <param name="saisyuCd">採取方法</param>
        /// <param name="convIcode">変換後コード</param>
        /// <param name="convIname">変換後名称</param>
        /// <returns></returns>
        private static bool GetSHouhouConv(string saisyuCd, out string convIcode, out string convIname)
        {
            bool ret = false;

            //採取方法をキーとする
            string key = saisyuCd;
            convIcode = "";
            convIname = "";

            ConvDataInfo.ConvInfoDetail retDetail = convDataInfo.GetItem(CONV_SAISHU, key);

            if (retDetail != null)
            {
                convIcode = retDetail.ConvCode;
                convIname = retDetail.ConvName;

                ret = true;
            }

            return ret;
        }

        /// <summary>
        /// 結果取得（単体）
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <param name="itemcd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <param name="result">取得結果</param>
        /// <returns></returns>
        private static bool GetResult(int rsvno, string itemcd, string suffix, out string result)
        {
            bool ret = false;
            result = "";

            try
            {
                Task<dynamic> taskGetData = WebAPI.GetDataAsync(ApiUri
                                                            , "api/v1/sendorders/itemResult?"
                                                            + "rsvno=" + rsvno
                                                            + "&itemcd=" + itemcd
                                                            + "&suffix=" + suffix
                                                            );

                ret = true;

                if (taskGetData.Result != null &&  taskGetData.Result.Count > 0)
                {
                    var rsl = taskGetData.Result[0];
                    result = rsl.result;
                }

            }
            catch
            {
                //エラーはスルー
                ret = false;
                result = "";
            }

            return ret;
        }

        /// <summary>
        /// 結果取得（一括）
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <param name="itemData">対象項目</param>
        /// <param name="rslData">取得結果</param>
        /// <returns></returns>
        private static bool GetResults(int rsvno , string[] itemData, out dynamic rslData)
        {
            bool ret = false;
            rslData = null;

            //対象項目のパラメタを文字列に変更
            string item_para = string.Join("|", itemData);

            try
            {
                Task<dynamic> taskGetData = WebAPI.GetDataAsync(ApiUri
                                                            , "api/v1/sendorders/itemResults?"
                                                            + "rsvno=" + rsvno
                                                            + "&itemdata=" + item_para
                                                            );

                rslData = taskGetData.Result;

                ret = true;

            }
            catch
            {
                //エラーはスルー
                ret = false;
            }

            return ret;
        }

        /// <summary>
        /// null補正
        /// </summary>
        /// <param name="obj">変換前の値</param>
        /// <returns>変換後の文字列</returns>
        /// <remarks>nullエラー回避のため</remarks>
        private static string ConvertNull(dynamic obj)
        {
            return Convert.ToString(obj) ?? "";
        }

    }
}
