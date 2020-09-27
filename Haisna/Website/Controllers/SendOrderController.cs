using Hainsi.Entity;
using Hainsi.SendOrder;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using Hainsi.Entity.Model.SendKarteOrder;
using Hainsi.Entity.Model.OrderedDoc2;
using Hainsi.Entity.Model.OrderedItem2;

namespace Hainsi.Controllers
{
    /// <summary>
    /// オーダ送信コントローラ
    /// </summary>
    //[Authorize]
    [Route("api/v1/sendorders")]
    public class SendOrderController : Controller
    {
        /// <summary>
        /// 構成情報オブジェクト
        /// </summary>
        readonly IConfiguration configuration;

        /// <summary>
        /// オーダ送信データアクセスオブジェクト
        /// </summary>
        readonly SendOrderDao sendOrderDao;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="configuration">構成情報オブジェクト</param>
        /// <param name="sendOrderDao">オーダ送信データアクセスオブジェクト</param>
        public SendOrderController(IConfiguration configuration, SendOrderDao sendOrderDao)
        {
            this.configuration = configuration;
            this.sendOrderDao = sendOrderDao;
        }

        /// <summary>
        /// LAINSに検体ラベル印刷オーダを送信する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="msgDiv">電文種別</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("printlabel")]
        public IActionResult SendPrintLabelOrderToLains(int rsvNo, string msgDiv)
        {
            Logging.Instance.Info(
                Logging.LoggingTypeConstants.PrintLabel,
                string.Format("検体ラベル印刷オーダ送信[{0},{1}]", rsvNo, msgDiv));

            // 引数の予約番号をチェックする
            if (rsvNo <= 0)
            {
                Logging.Instance.Error(
                    Logging.LoggingTypeConstants.PrintLabel,
                    string.Format("予約番号が不正です。[{0}]", rsvNo));

                return BadRequest(new List<string>()
                    { "予約番号が不正です。" });
            }

            // 引数の電文種別をチェックする
            if (string.IsNullOrWhiteSpace(msgDiv))
            {
                Logging.Instance.Error(
                    Logging.LoggingTypeConstants.PrintLabel,
                    "電文種別が不正です。");

                return BadRequest(new List<string>()
                    { "電文種別が不正です。" });
            }

            // 引数の電文種別をチェックする
            if (msgDiv.Trim().Equals(Constants.MSGDIV_PRINTLABEL1) ||
                msgDiv.Trim().Equals(Constants.MSGDIV_PRINTLABEL2) ||
                msgDiv.Trim().Equals(Constants.MSGDIV_PRINTLABEL3) ||
                msgDiv.Trim().Equals(Constants.MSGDIV_PRINTLABEL4) ||
                msgDiv.Trim().Equals(Constants.MSGDIV_PRINTLABEL5))
            {
                // 採尿ラベル依頼
                // 採血ラベル依頼
                // 採血ラベル依頼（婦人科診察室１）
                // 採血ラベル依頼（婦人科診察室２）
                // 採血ラベル依頼（婦人科診察室３）
            }
            else
            {
                // その他
                Logging.Instance.Error(
                    Logging.LoggingTypeConstants.PrintLabel,
                    string.Format("電文種別に設定された値が不正です。[{0}]", msgDiv));

                return BadRequest(new List<string>()
                    { "電文種別に設定された値が不正です。" });
            }

            // 送信オーダ文書情報を取得する
            List<dynamic> orderedDocs = null;
            try
            {
                orderedDocs = sendOrderDao.SelectOrderedDoc(rsvNo, Constants.ORDDIV_LAINS);
            }
            catch (Exception ex)
            {
                Logging.Instance.Error(
                    Logging.LoggingTypeConstants.PrintLabel,
                    "送信オーダ文書情報の取得に失敗しました。", ex);

                return BadRequest(new List<string>()
                    { "送信オーダ文書情報の取得に失敗しました。" });
            }

            // 該当するオーダ情報が存在しない場合
            if (orderedDocs == null || orderedDocs.Count == 0)
            {
                Logging.Instance.Error(
                    Logging.LoggingTypeConstants.PrintLabel,
                    "送信オーダ対象情報が存在しません。");

                return BadRequest(new List<string>()
                    { "送信オーダ対象情報が存在しません。" });
            }

            foreach (var item in orderedDocs)
            {
                // オーダ種別をチェックする
                if (msgDiv.Trim().Equals(Constants.MSGDIV_PRINTLABEL1) ||
                    msgDiv.Trim().Equals(Constants.MSGDIV_PRINTLABEL3) ||
                    msgDiv.Trim().Equals(Constants.MSGDIV_PRINTLABEL4) ||
                    msgDiv.Trim().Equals(Constants.MSGDIV_PRINTLABEL5))
                {
                    // 採尿ラベル依頼
                    // 採血ラベル依頼（婦人科診察室１）
                    // 採血ラベル依頼（婦人科診察室２）
                    // 採血ラベル依頼（婦人科診察室３）
                    if (!Convert.ToString(item.ORDERDIV).Trim().ToUpper().Equals(Constants.ORDERDIV_LABOTEST))
                    {
                        // 検体検査オーダ以外の場合は処理を行わない
                        continue;
                    }
                }
                else if (msgDiv.Trim().Equals(Constants.MSGDIV_PRINTLABEL2))
                {
                    // 採血ラベル依頼
                    if (!Convert.ToString(item.ORDERDIV).Trim().ToUpper().Equals(Constants.ORDERDIV_LABOTEST) &&
                        !Convert.ToString(item.ORDERDIV).Trim().ToUpper().Equals(Constants.ORDERDIV_LABOBLOODTEST))
                    {
                        // 検体検査オーダ／血型・検体検査オーダ以外の場合は処理を行わない
                        continue;
                    }
                }

                // オーダ送信情報をチェックする
                if (Convert.ToString(item.ORDERDOC ?? "").Trim().Equals(""))
                {
                    // オーダ送信情報が存在しない場合は処理を行わない
                    continue;
                }

                // 連番を取得する
                var seqNo = 0;
                try
                {
                    seqNo = sendOrderDao.SelectSeqNo();
                }
                catch (Exception ex)
                {
                    Logging.Instance.Error(
                        Logging.LoggingTypeConstants.PrintLabel,
                        "連番の取得に失敗しました。", ex);

                    return BadRequest(new List<string>()
                        { "連番の取得に失敗しました。" });
                }

                // 送信電文を編集する
                string message = Convert.ToString(item.ORDERDOC);
                // 連番（1バイト目から5バイト）
                message = Strings.ReplaceEx(message, 1, Strings.PadRightEx(seqNo.ToString("D5"), 5));
                // 電文種別（7バイト目から2バイト）　"LU","LH","L1","L2","L3"
                message = Strings.ReplaceEx(message, 7, Strings.PadRightEx(msgDiv, 2));
                // 処理日（12バイト目から8バイト）　システム日付
                message = Strings.ReplaceEx(
                    message, 12, Strings.PadRightEx(DateTime.Now.ToString("yyyyMMdd"), 8));
                // 処理時間（20バイト目から6バイト）　システム時刻
                message = Strings.ReplaceEx(
                    message, 20, Strings.PadRightEx(DateTime.Now.ToString("HHmmss"), 6));
                // 処理区分（42バイト目から2バイト）　"02:変更"固定
                message = Strings.ReplaceEx(message, 42, Strings.PadRightEx("02", 2));
                // 処理種別（67バイト目から2バイト）　"02:変更"固定
                message = Strings.ReplaceEx(message, 67, Strings.PadRightEx("02", 2));
                if (item.PERID != null)
                {
                    // カナ氏名（1,527バイト目から50バイト）　ローマ字氏名をセットする
                    message = Strings.ReplaceEx(
                        message, 1527, Strings.PadRightEx(Convert.ToString(item.ROMENAME).Trim(), 50));
                    // 漢字氏名（1,577バイト目から20バイト）
                    message = Strings.ReplaceEx(
                        message, 1577, Strings.PadRightEx(Convert.ToString(item.NAME_N).Trim(), 20));
                    // 性別（1,597バイト目から1バイト）
                    message = Strings.ReplaceEx(
                        message, 1597, Strings.PadRightEx(Convert.ToInt32(item.GENDER).ToString(), 1));
                    // 生年月日（1,598バイト目から8バイト）
                    message = Strings.ReplaceEx(
                        message, 1598, Strings.PadRightEx(Convert.ToString(item.BIRTHDATE).Trim(), 8));
                }

                Logging.Instance.Info(
                    Logging.LoggingTypeConstants.PrintLabel,
                    string.Format("送信電文[{0}]", message));

                // 電文内の個人属性を再編集しているため、
                // 変更した電文を送信オーダ文書情報テーブルに更新する
                try
                {
                    int result =
                        sendOrderDao.UpdateOrderedDoc(
                            rsvNo, Convert.ToString(item.ORDERDIV),
                            Convert.ToDateTime(item.ORDERDATE),
                            Convert.ToInt32(item.ORDERNO), message);
                    if (result == 0)
                    {
                        Logging.Instance.Error(
                            Logging.LoggingTypeConstants.PrintLabel,
                            "送信オーダ文書情報テーブルの更新に失敗しました。");

                        return BadRequest(new List<string>()
                            { "送信オーダ文書情報テーブルの更新に失敗しました。" });
                    }
                }
                catch (Exception ex)
                {
                    Logging.Instance.Error(
                        Logging.LoggingTypeConstants.PrintLabel,
                        "送信オーダ文書情報テーブルの更新に失敗しました。", ex);

                    return BadRequest(new List<string>()
                        { "送信オーダ文書情報テーブルの更新に失敗しました。" });
                }

                // 電文を送信する
                try
                {
                    var sendMessage = new SendMessage();
                    Constants.ResponseValueConstants result =
                        sendMessage.Send(
                            Constants.DestinationConstants.PrintLabelToLains,
                            Convert.ToString(item.ORDERDIV).Trim().ToUpper(),
                            message, out string receiveMessage);

                    Logging.Instance.Info(
                        Logging.LoggingTypeConstants.PrintLabel,
                        string.Format("受信電文[{0}]", receiveMessage));

                    if (result != Constants.ResponseValueConstants.Ok)
                    {
                        var status = "";
                        switch (result)
                        {
                            case Constants.ResponseValueConstants.Retry:
                                status = "リトライ";
                                break;
                            case Constants.ResponseValueConstants.Skip:
                                status = "スキップ";
                                break;
                            case Constants.ResponseValueConstants.Down:
                                status = "ダウン";
                                break;
                        }

                        Logging.Instance.Error(
                            Logging.LoggingTypeConstants.PrintLabel,
                            string.Format("オーダ送信処理に失敗しました。[{0}]", status));

                        return BadRequest(new List<string>()
                            { "オーダ送信処理に失敗しました。" });
                    }
                }
                catch (Exception ex)
                {
                    Logging.Instance.Error(
                        Logging.LoggingTypeConstants.PrintLabel,
                        "オーダ送信処理に失敗しました。", ex);

                    return BadRequest(new List<string>() { ex.Message });
                }

                // オーダ送信テーブルのレコードを登録する
                try
                {
                    // オーダ区分　1:オーダ依頼
                    // 処理区分　　5:その他
                    // 送信区分　　1:新規・変更
                    int result = sendOrderDao.InsertOrderTbl(
                        rsvNo, 1, 5, Convert.ToString(item.ORDERDIV).Trim().ToUpper(),
                        1, Convert.ToInt32(item.ORDERNO));
                    if (result == 0)
                    {
                        Logging.Instance.Error(
                            Logging.LoggingTypeConstants.PrintLabel,
                            "オーダ送信テーブルの登録に失敗しました。");

                        return BadRequest(new List<string>()
                            { "オーダ送信テーブルの登録に失敗しました。" });
                    }
                }
                catch (Exception ex)
                {
                    Logging.Instance.Error(
                        Logging.LoggingTypeConstants.PrintLabel,
                        "オーダ送信テーブルの登録に失敗しました。", ex);

                    return BadRequest(new List<string>()
                        { "オーダ送信テーブルの登録に失敗しました。" });
                }
            }

            // 正常時は204(No Content)を返す
            return NoContent();
        }

        /// <summary>
        /// RAYPAXに状態変更オーダを送信する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="orderDiv">オーダ種別（状態区分が「51:面接開始」「52:面接終了」以外の場合のみ指定する）</param>
        /// <param name="statusDiv">状態区分（10:未実施、20:検査開始、30:検査終了、40:技師コメント、51:面接開始、52:面接終了、90:中止）</param>
        /// <param name="roomNo">検査室番号</param>
        /// <param name="roomName">検査室名</param>
        /// <param name="stopComment">中止コメント（状態区分が「90:中止」の場合のみ指定する）</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("changestatus")]
        public IActionResult SendChangeStatusOrderToRaypax(int rsvNo, string orderDiv, string statusDiv, string roomNo, string roomName, string stopComment)
        {
            Logging.Instance.Info(
                Logging.LoggingTypeConstants.ChangeStatus,
                string.Format("状態変更オーダ送信[{0},{1},{2},{3},{4},{5}]", rsvNo, orderDiv, statusDiv, roomNo, roomName, stopComment));

            // 引数の予約番号をチェックする
            if (rsvNo <= 0)
            {
                Logging.Instance.Error(
                    Logging.LoggingTypeConstants.ChangeStatus,
                    string.Format("予約番号が不正です。[{0}]", rsvNo));

                return BadRequest(new List<string>()
                    { "予約番号が不正です。" });
            }

            // 引数の状態区分をチェックする
            if (string.IsNullOrWhiteSpace(statusDiv))
            {
                Logging.Instance.Error(
                    Logging.LoggingTypeConstants.ChangeStatus,
                    "状態区分が不正です。");

                return BadRequest(new List<string>()
                    { "状態区分が不正です。" });
            }

            // 引数の状態区分をチェックする
            if (statusDiv.Trim().Equals(Constants.STATUSDIV_NOMEDIEX) ||
                statusDiv.Trim().Equals(Constants.STATUSDIV_STARTMEDIEX) ||
                statusDiv.Trim().Equals(Constants.STATUSDIV_ENDMEDIEX) ||
                statusDiv.Trim().Equals(Constants.STATUSDIV_STARTINTERVIEW) ||
                statusDiv.Trim().Equals(Constants.STATUSDIV_ENDINTERVIEW) ||
                statusDiv.Trim().Equals(Constants.STATUSDIV_STOPMEDIEX) ||
                statusDiv.Trim().Equals(Constants.STATUSDIV_CMTINPUTCOMPLETE))
            {
                // 未実施
                // 検査開始
                // 検査終了
                // 面接開始
                // 面接終了
                // 中止
                // 技師コメント入力
            }
            else
            {
                // その他
                Logging.Instance.Error(
                    Logging.LoggingTypeConstants.ChangeStatus,
                    string.Format("状態区分に設定された値が不正です。[{0}]", statusDiv));

                return BadRequest(new List<string>()
                    { "状態区分に設定された値が不正です。" });
            }

            // 引数のオーダ種別をチェックする
            if (statusDiv.Trim().Equals(Constants.STATUSDIV_STARTINTERVIEW) ||
                statusDiv.Trim().Equals(Constants.STATUSDIV_ENDINTERVIEW))
            {
                // 面接開始
                // 面接終了
            }
            else
            {
                // 引数のオーダ種別をチェックする
                if (string.IsNullOrWhiteSpace(orderDiv))
                {
                    Logging.Instance.Error(
                        Logging.LoggingTypeConstants.ChangeStatus,
                        "オーダ種別が不正です。");

                    return BadRequest(new List<string>()
                        { "オーダ種別が不正です。" });
                }
            }

            // 引数の検査室番号をチェックする
            if (string.IsNullOrWhiteSpace(roomNo))
            {
                Logging.Instance.Error(
                    Logging.LoggingTypeConstants.ChangeStatus,
                    "検査室番号が不正です。");

                return BadRequest(new List<string>()
                    { "検査室番号が不正です。" });
            }

            // 引数の検査室名をチェックする
            if (string.IsNullOrWhiteSpace(roomName))
            {
                Logging.Instance.Error(
                    Logging.LoggingTypeConstants.ChangeStatus,
                    "検査室名が不正です。");

                return BadRequest(new List<string>()
                    { "検査室名が不正です。" });
            }

            // 送信オーダ文書情報を取得する
            List<dynamic> orderedDocs = null;
            try
            {
                orderedDocs = sendOrderDao.SelectOrderedDoc(rsvNo, Constants.ORDDIV_RAYPAX);
            }
            catch (Exception ex)
            {
                Logging.Instance.Error(
                    Logging.LoggingTypeConstants.ChangeStatus,
                    "送信オーダ文書情報の取得に失敗しました。", ex);

                return BadRequest(new List<string>()
                    { "送信オーダ文書情報の取得に失敗しました。" });
            }

            // 該当するオーダ情報が存在しない場合
            if (orderedDocs == null || orderedDocs.Count == 0)
            {
                Logging.Instance.Error(
                    Logging.LoggingTypeConstants.ChangeStatus,
                    "送信オーダ対象情報が存在しません。");

                return BadRequest(new List<string>()
                    { "送信オーダ対象情報が存在しません。" });
            }

            foreach (var item in orderedDocs)
            {
                // オーダ種別をチェックする
                if (statusDiv.Trim().Equals(Constants.STATUSDIV_STARTINTERVIEW) ||
                    statusDiv.Trim().Equals(Constants.STATUSDIV_ENDINTERVIEW))
                {
                    // 面接開始
                    // 面接終了
                    if (Convert.ToString(item.ORDERDIV).Trim().ToUpper().Equals(Constants.ORDERDIV_RAYPAX_TP) ||
                        Convert.ToString(item.ORDERDIV).Trim().ToUpper().Equals(Constants.ORDERDIV_RAYPAX_FK))
                    {
                        // 横河以外のオーダの場合は処理を行わない
                        continue;
                    }
                }
                else
                {
                    // その他
                    if (!Convert.ToString(item.ORDERDIV).Trim().ToUpper().Equals(orderDiv.Trim().ToUpper()))
                    {
                        // 引数で指定されているオーダ種別と一致しない場合は処理を行わない
                        continue;
                    }
                }

                // オーダ送信情報をチェックする
                if (Convert.ToString(item.ORDERDOC ?? "").Trim().Equals(""))
                {
                    // オーダ送信情報が存在しない場合は処理を行わない
                    continue;
                }

                // 送信電文を編集する
                string message = Convert.ToString(item.ORDERDOC);
                // 送信日時（6バイト目から14バイト）　システム日時
                message = Strings.ReplaceEx(
                    message, 6, Strings.PadRightEx(DateTime.Now.ToString("yyyyMMddHHmmss"), 14));
                // 処理区分（20バイト目から1バイト）　"2:変更"固定
                message = Strings.ReplaceEx(message, 20, Strings.PadRightEx("2", 1));
                // 検査開始の場合
                if (statusDiv.Trim().Equals(Constants.STATUSDIV_STARTMEDIEX) &&
                    item.PERID != null)
                {
                    // 氏名（73バイト目から60バイト）
                    message = Strings.ReplaceEx(
                        message, 73, Strings.PadRightEx(Convert.ToString(item.NAME_N).Trim(), 60));
                    // カナ氏名（133バイト目から60バイト）
                    message = Strings.ReplaceEx(
                        message, 133, Strings.PadRightEx(Convert.ToString(item.NAME_K).Trim(), 60));
                    // ローマ字氏名（193バイト目から60バイト）
                    message = Strings.ReplaceEx(
                        message, 193, Strings.PadRightEx(Convert.ToString(item.ROMENAME).Trim(), 60));
                    // 性別（253バイト目から1バイト）
                    message = Strings.ReplaceEx(
                        message, 253, Strings.PadRightEx(Convert.ToInt32(item.GENDER).ToString(), 1));
                    // 生年月日（254バイト目から8バイト）
                    message = Strings.ReplaceEx(
                        message, 254, Strings.PadRightEx(Convert.ToString(item.BIRTHDATE).Trim(), 8));
                }
                // 状態区分（262バイト目から2バイト）　状態区分
                message = Strings.ReplaceEx(message, 262, Strings.PadRightEx(statusDiv, 2));
                // 実施日時（292バイト目から14バイト）　システム日時
                message = Strings.ReplaceEx(
                    message, 292, Strings.PadRightEx(DateTime.Now.ToString("yyyyMMddHHmmss"), 14));
                // 検査室番号（306バイト目から3バイト）　検査室番号
                message = Strings.ReplaceEx(message, 306, Strings.PadRightEx(roomNo, 3));
                // 検査室名（309バイト目から20バイト）　検査室名
                message = Strings.ReplaceEx(message, 309, Strings.PadRightEx(roomName, 20));
                // 中止の場合
                if (statusDiv.Trim().Equals(Constants.STATUSDIV_STOPMEDIEX))
                {
                    // 依頼可変データ数（329バイト目から3バイト）　現在の値に1を加算する
                    var count = int.Parse(Strings.SubstringEx(message, 329, 3)) + 1;
                    message = Strings.ReplaceEx(message, 329, Strings.PadRightEx(count.ToString("D3"), 3));
                    // 可変データ部　データ種別（3バイト）　"901"固定
                    message += Strings.PadRightEx("901", 3);
                    // 可変データ部　項目コード（8バイト）　空白固定
                    message += Strings.PadRightEx("", 8);
                    // 可変データ部　項目名（60バイト）　中止コメント
                    message += Strings.PadRightEx((stopComment ?? "").Trim(), 60);
                }
                // 電文長（24バイト目から7バイト）
                message = Strings.ReplaceEx(
                    message, 24, Strings.PadRightEx(Strings.GetByteCount(message).ToString("D7"), 7));

                Logging.Instance.Info(
                    Logging.LoggingTypeConstants.ChangeStatus,
                    string.Format("送信電文[{0}]", message));

                // 状態区分が検査開始の場合は、電文内の個人属性を再編集しているため、
                // 変更した電文を送信オーダ文書情報テーブルに更新する
                if (statusDiv.Trim().Equals(Constants.STATUSDIV_STARTMEDIEX))
                {
                    try
                    {
                        int result = 
                            sendOrderDao.UpdateOrderedDoc(
                                rsvNo, Convert.ToString(item.ORDERDIV), 
                                Convert.ToDateTime(item.ORDERDATE),
                                Convert.ToInt32(item.ORDERNO), message);
                        if (result == 0)
                        {
                            Logging.Instance.Error(
                                Logging.LoggingTypeConstants.ChangeStatus,
                                "送信オーダ文書情報テーブルの更新に失敗しました。");

                            return BadRequest(new List<string>()
                                { "送信オーダ文書情報テーブルの更新に失敗しました。" });
                        }
                    }
                    catch (Exception ex)
                    {
                        Logging.Instance.Error(
                            Logging.LoggingTypeConstants.ChangeStatus,
                            "送信オーダ文書情報テーブルの更新に失敗しました。", ex);

                        return BadRequest(new List<string>()
                            { "送信オーダ文書情報テーブルの更新に失敗しました。" });
                    }
                }

                // 電文を送信する
                try
                {
                    var sendMessage = new SendMessage();
                    Constants.ResponseValueConstants result =
                        sendMessage.Send(
                            Constants.DestinationConstants.ChangeStatusToRaypax,
                            Convert.ToString(item.ORDERDIV).Trim().ToUpper(),
                            message, out string receiveMessage);

                    Logging.Instance.Info(
                        Logging.LoggingTypeConstants.ChangeStatus,
                        string.Format("受信電文[{0}]", receiveMessage));

                    if (result != Constants.ResponseValueConstants.Ok)
                    {
                        var status = "";
                        switch (result)
                        {
                            case Constants.ResponseValueConstants.Retry:
                                status = "リトライ";
                                break;
                            case Constants.ResponseValueConstants.Skip:
                                status = "スキップ";
                                break;
                            case Constants.ResponseValueConstants.Down:
                                status = "ダウン";
                                break;
                        }

                        Logging.Instance.Error(
                            Logging.LoggingTypeConstants.ChangeStatus,
                            string.Format("オーダ送信処理に失敗しました。[{0}]", status));

                        return BadRequest(new List<string>()
                            { "オーダ送信処理に失敗しました。" });
                    }
                }
                catch (Exception ex)
                {
                    Logging.Instance.Error(
                        Logging.LoggingTypeConstants.ChangeStatus,
                        "オーダ送信処理に失敗しました。", ex);

                    return BadRequest(new List<string>() { ex.Message });
                }
            }

            // 正常時は204(No Content)を返す
            return NoContent();
        }

        /// <summary>
        /// 病理ラベルを印刷する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="orderDiv">オーダ種別</param>
        /// <param name="orderNo">オーダ番号</param>
        /// <param name="seq">SEQ</param>
        /// <param name="roomId">部屋ID</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPut("byorilabel")]
        public IActionResult PrintByoriLabel(int rsvNo, string orderDiv, int orderNo, int seq, string roomId)
        {
            Logging.Instance.Info(
                Logging.LoggingTypeConstants.ByoriLabel,
                string.Format("病理ラベル印刷[{0},{1},{2},{3},{4}]", rsvNo, orderDiv, orderNo, seq, roomId));

            // 処理対象データを取得する
            List<dynamic> byoriLabelList = null;
            try
            {
                byoriLabelList = sendOrderDao.SelectByoriLabelInfo(rsvNo, orderDiv, orderNo, seq);
            }
            catch (Exception ex)
            {
                Logging.Instance.Error(
                    Logging.LoggingTypeConstants.ByoriLabel,
                    "処理対象データの取得に失敗しました。", ex);

                return BadRequest(new List<string>()
                    { "処理対象データの取得に失敗しました。" });
            }

            // 処理対象データが存在しない場合は処理を終了する
            if (byoriLabelList == null || byoriLabelList.Count == 0)
            {
                Logging.Instance.Info(
                    Logging.LoggingTypeConstants.ByoriLabel,
                    "処理対象データが存在しません。");

                // 正常時は204(No Content)を返す
                return NoContent();
            }

            // 病理ラベル印刷設定情報を取得する
            ByoriLabelSettingInfo byoriLabelSettingInfo = null;
            try
            {
                byoriLabelSettingInfo = ByoriLabelSettingInfo.ReadJsonFile();
            }
            catch (Exception ex)
            {
                Logging.Instance.Error(
                    Logging.LoggingTypeConstants.ByoriLabel,
                    "病理ラベル印刷設定情報ファイルの取得でエラーが発生しました。", ex);

                return BadRequest(new List<string>()
                    { "病理ラベル印刷設定情報ファイルの取得でエラーが発生しました。" });
            }

            // 部屋IDを基に出力先プリンタ名を取得する
            var printerName = "";
            if (orderDiv.Equals(Constants.ORDERDIV_KAKUTAN))
            {
                // 喀痰の場合
                printerName = byoriLabelSettingInfo.GetPrinterNameForKakutan(roomId);
            }
            else if (orderDiv.Equals(Constants.ORDERDIV_FUJINKA))
            {
                // 婦人科の場合
                printerName = byoriLabelSettingInfo.GetPrinterNameForFujinka(roomId);
            }

            Logging.Instance.Info(
                Logging.LoggingTypeConstants.ByoriLabel,
                string.Format("プリンタ'{0}'に病理ラベルを印刷します。", printerName));

            // 病理ラベルを印刷する
            try
            {
                var byoriLabel = new ByoriLabel();
                byoriLabel.PrintByoriLabel(byoriLabelList, printerName, configuration);
            }
            catch (Exception ex)
            {
                Logging.Instance.Error(
                    Logging.LoggingTypeConstants.ByoriLabel,
                    "病理ラベルの印刷に失敗しました。", ex);

                return BadRequest(new List<string>() { ex.Message });
            }

            // オーダ送信ジャーナルにレコードを登録する
            try
            {
                // オーダ区分　3:病理オーダ
                // 処理区分　　5:その他
                // 送信区分　　0:未送信
                int result = sendOrderDao.InsertOrderJnl(rsvNo, 3, 5, 0, orderNo);
                if (result == 0)
                {
                    Logging.Instance.Error(
                        Logging.LoggingTypeConstants.ByoriLabel,
                        "オーダ送信ジャーナルの登録に失敗しました。");

                    return BadRequest(new List<string>()
                        { "オーダ送信ジャーナルの登録に失敗しました。" });
                }
            }
            catch (Exception ex)
            {
                Logging.Instance.Error(
                    Logging.LoggingTypeConstants.ByoriLabel,
                    "オーダ送信ジャーナルの登録に失敗しました。", ex);

                return BadRequest(new List<string>()
                    { "オーダ送信ジャーナルの登録に失敗しました。" });
            }

            // 正常時は204(No Content)を返す
            return NoContent();
        }

        /// <summary>
        /// 電子チャートの依頼送信データを取得する
        /// </summary>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("orderlist")]
        public IActionResult GetSendOrderData()
        {
            // 依頼送信対象データを取得する
            List<dynamic> list = sendOrderDao.SelectSendOrderList();

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>   
        /// 電子チャートのオーダ依頼送信情報を削除する
        /// </summary>
        /// <param name="updData">更新オーダテーブル情報</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost("orderlistDel")]
        public IActionResult DeleteSendOrderData([FromBody] UpdateOrderTbl updData)
        {
            // 電子チャートのオーダ依頼送信情報を削除する
            try
            {
                int result = sendOrderDao.DeleteSendOrderList(updData);

                if (result == 0)
                {
                    return BadRequest(new List<string>()
                                { "オーダ送信テーブルの削除に失敗しました。" });
                }
            }
            catch
            {
                return BadRequest(new List<string>()
                            { "オーダ送信テーブルの削除に失敗しました。" });
            }

            // 正常時は204(No Content)を返す
            return NoContent();
        }

        /// <summary>
        /// 電子チャートのオーダ依頼対象データの受診情報を取得する
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("cslinfo")]
        public IActionResult GetOrderConsult(int rsvno)
        {
            // 電子チャートのオーダ依頼対象データの受診情報を取得する
            List<dynamic> list = sendOrderDao.SelectOrderConsult(rsvno);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 電子チャートのオーダ依頼項目情報を取得する
        /// </summary>
        /// <param name="orderDiv">オーダ種別</param>
        /// <param name="rsvno">予約番号</param>
        /// <param name="docCode">文書コード</param>
        /// <param name="docSeq">文書SEQ</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("orderItem")]
        public IActionResult GetSendOrderItem(string orderDiv, int rsvno, string docCode, string docSeq)
        {
            // オーダ依頼項目情報を取得する
            List<dynamic> list = sendOrderDao.SelectSendOrderItem(orderDiv, rsvno, docCode, docSeq);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>   
        /// 電子チャートのオーダ依頼項目情報を更新する
        /// </summary>
        /// <param name="orderItem">送信オーダ項目情報</param>
        /// <param name="InsertFlg">レコード挿入フラグ</param>
        /// <param name="orderDiv">オーダ種別</param>
        /// <param name="targetItemCd1">オーダ情報取得用項目コード１</param>
        /// <param name="targetItemCd2">オーダ情報取得用項目コード２</param>
        /// <param name="kyobuItemCode">胸部Ｘ線撮影方法判定用コード</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost("orderItemUpd")]
        public IActionResult UpdSendOrderItem([FromBody] OrderedItem2 orderItem, bool InsertFlg
                                               , string orderDiv, string targetItemCd1, string targetItemCd2
                                               , string kyobuItemCode)
        {
            // オーダ依頼項目情報を更新する
            try
            {
                int result =
                    sendOrderDao.UpdateSendOrderItem(orderItem, InsertFlg
                                                   , orderDiv, targetItemCd1, targetItemCd2
                                                   , kyobuItemCode);

                if (result == 0)
                {
                    return BadRequest(new List<string>()
                                { "送信オーダ文書情報テーブルの更新に失敗しました。" });
                }
            }
            catch
            {
                return BadRequest(new List<string>()
                            { "送信オーダ文書情報テーブルの更新に失敗しました。" });
            }

            // 正常時は204(No Content)を返す
            return NoContent();
        }

        /// <summary>
        /// 電子チャートの依頼時に使用する検査結果を取得する
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <param name="itemcd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("itemResult")]
        public IActionResult GetItemResult(int rsvno, string itemcd, string suffix)
        {
            // 電子チャートの依頼時に使用する検査結果を取得する
            List<dynamic> list = sendOrderDao.SelectItemResult(rsvno, itemcd, suffix);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 電子チャートの依頼時に使用する検査結果を取得する（一括）
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <param name="itemdata">検査項目情報</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("itemResults")]
        public IActionResult GetItemResults(int rsvno, string itemdata)
        {
            // 電子チャートの依頼時に使用する検査結果を取得する（一括）
            List<dynamic> list = sendOrderDao.SelectItemResults(rsvno, itemdata);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 誘導システムで発行した婦人科オーダ情報を取得する
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <param name="orderDiv">オーダ種別</param>
        /// <param name="orderNo">オーダ番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("yudoInfo")]
        public IActionResult GetYudoOrderInfo(int rsvno, string orderDiv, int orderNo)
        {
            // 誘導システムで発行した婦人科オーダ情報を取得する
            List<dynamic> list = sendOrderDao.SelectYudoOrderInfo(rsvno, orderDiv, orderNo);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 送信済オーダ文書２情報を取得する
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <param name="orderno">オーダ番号</param>
        /// <response code="200">成功</response>
        /// <response code="404">データなし</response>
        [HttpGet("orderedRead")]
        public IActionResult GetByRsvOrderNo(int rsvno, int orderno)
        {
            // 送信オーダ文書情報を取得する
            List<dynamic> list = sendOrderDao.SelectByRsvOrderNo(rsvno, orderno);

            // データ件数が0件の場合
            if (list == null || list.Count <= 0)
            {
                return NotFound();
            }

            return Ok(list);
        }

        /// <summary>
        /// 送信済オーダ文書２情報を更新する
        /// </summary>
        /// <param name="orderedDoc2">送信済オーダ文書２情報</param>
        /// <param name="orderType">オーダ種別</param>
        /// <response code="204">成功</response>
        /// <response code="400">リクエスト不正</response>
        [HttpPost("orderedUpd")]
        public IActionResult UpdOrderedDoc2([FromBody] OrderedDoc2 orderedDoc2, int orderType)
        {
            // オーダ依頼項目情報を更新する
            try
            {
                int result =
                    sendOrderDao.UpdateOrderedDoc2(orderedDoc2, orderType);

                if (result == 0)
                {
                    return BadRequest(new List<string>()
                                { "送信済オーダ文書２テーブルの更新に失敗しました。" });
                }
            }
            catch
            {
                return BadRequest(new List<string>()
                            { "送信済オーダ文書２テーブルの更新に失敗しました。" });
            }

            // 正常時は204(No Content)を返す
            return NoContent();
        }
    }
}
