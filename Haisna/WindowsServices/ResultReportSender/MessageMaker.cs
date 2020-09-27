using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.IO;
using System.Windows.Forms;

namespace Fujitsu.Hainsi.WindowServices.ResultReportSender
{
    public class MessageMaker
    {
        public enum MakeMode
        {
            New,
            Update
        }

        public MessageMaker()
        {
        }

        /// <summary>
        /// 指定の予約番号の電文を作成する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <returns></returns>
        public byte[] Make(int rsvNo)
        {

            // Html作成
            List<string> htmls = MakeHtmlReport(rsvNo);

            // 送信電文作成
            return MakeMessages(rsvNo, htmls);
        }
        
        /// <summary>
        /// 送信電文作成
        /// </summary>
        /// <param name="rsvNo">応答電文</param>
        /// <param name="htmls">レポートHTMLのリスト</param>
        /// <returns></returns>
        private byte[] MakeMessages(int rsvNo, List<string> htmls)
        {
            var responseInfo = new ResponseInfo();
            responseInfo.RsvNo = rsvNo;


            // 個人属性情報取得
            dynamic personAttribute = new PersonAttribute().Select(rsvNo);
            responseInfo.PerId = personAttribute.PERID;

            // 送信オーダ文書情報取得
            List<dynamic> orderDocs = new OrderDoc().Select(rsvNo);

            // 処理モード判定
            responseInfo.Mode = JudgeMakeMode(orderDocs);

            dynamic orderDoc = (orderDocs.Count > 0) ? orderDocs[0] : null;

            // オーダー番号取得
            responseInfo.OrderNo = GenerateOrderNo(responseInfo.Mode, orderDoc);

            // 文書版数取得
            responseInfo.DocSeq = new OrderDoc2().Select(responseInfo.Mode, rsvNo, responseInfo.OrderNo);

            // オーダー日付取得
            responseInfo.DocDate = JudeDocDate(responseInfo.Mode, personAttribute, orderDoc);

            responseInfo.Count = 0;
            var message = new StringBuilder();
            foreach (var html in htmls)
            {
                responseInfo.Count++;

                responseInfo.Html = html;

                // 電文を文字列で取得
                message.Append(MakeMessage(responseInfo));
            }

            // 電文を結合してバイト配列にして返す
            return Encoding.GetEncoding("shift_jis").GetBytes(message.ToString());
        }

        /// <summary>
        /// レポート1枚分の電文を作成する
        /// </summary>
        /// <param name="responseInfo">電文を作成するための情報</param>
        /// <returns></returns>
        private string MakeMessage(ResponseInfo responseInfo)
        {
            var message = new StringBuilder();

            // 連番
            int sendNo = new OrderDoc().GenerateNewSendNumber().SENDNO;
            message.Append(sendNo.ToString().PadLeft(5));

            // システムコード
            message.Append("H");

            // 電文種別
            message.Append("BE");

            // レコード継続支持
            message.Append("E");

            // 送信先システムコード
            message.Append(" ");

            // 送信元システムコード
            message.Append(" ");

            // 処理年月日
            message.Append(DateTime.Now.ToString("yyyyMMdd").PadRight(8));

            // 処理時間
            message.Append(DateTime.Now.ToString("hhmmss").PadRight(6));

            // 端末名
            message.Append(ConfigurationManager.AppSettings["MesTerm"].PadRight(8));

            // 利用者番号
            message.Append(ConfigurationManager.AppSettings["MesUId"].PadRight(8));

            // 処理区分 -> 01:新規、02:修正、03:削除
            message.Append(ConvertMakeCode(responseInfo.Mode).PadRight(2));

            // 応答種別
            message.Append("  ");

            // 電文長 -> 共通部:51 + 内容部:837～11909 + 終端:1
            var len = 51 + 837 + responseInfo.Html.Length + 1;
            message.Append(len.ToString().PadLeft(6, '0'));

            // 患者番号
            message.Append(responseInfo.PerId.ToString().PadLeft(10, '0'));

            // 実施日
            message.Append(responseInfo.DocDate + DateTime.Now.ToString("hhmmss"));

            // オーダー番号
            message.Append(responseInfo.OrderNo.ToString().PadRight(8));

            // 部門発生文書番号-> "FJH" + オーダ日付 + オーダ番号 + INIファイルの文書種別
            var docNo = "FJH" + new string('0', 6) + responseInfo.OrderNo.ToString() + ConfigurationManager.AppSettings["Dock"] + responseInfo.Count.ToString();
            message.Append(docNo.PadRight(30));

            // オーダ番号発番日 -> "00000000"固定
            message.Append(new string('0', 8));

            // 結果状態
            message.Append("1");

            // 報告書状態
            message.Append("1");

            // 入外区分
            message.Append(ConfigurationManager.AppSettings["NG"].PadLeft(1));

            // 部署(診療科)
            message.Append(ConfigurationManager.AppSettings["KA"].PadLeft(3));

            // 病棟
            message.Append(ConfigurationManager.AppSettings["DOCWD"].PadRight(3));

            // 文書種別
            message.Append(ConfigurationManager.AppSettings["Dock"].PadRight(4));

            // 文書タイトル -> INIファイル + ページ
            message.Append((ConfigurationManager.AppSettings["Title"] + "(" + responseInfo.Count.ToString() + "/4)").PadRight(50));

            // ツールパラメタ->
            //   ①"2"固定
            //   ②伝票種別
            //   ③未指定
            //   ④患者番号
            //   ⑤オーダ番号
            //   ⑥文書番号
            //   ⑦版数
            //   ⑧未指定
            var tmpList = new List<string>();
            tmpList.Add("2");
            tmpList.Add(ConfigurationManager.AppSettings["Dock"]);
            tmpList.Add("");
            tmpList.Add(responseInfo.PerId.ToString().PadLeft(10, '0'));
            tmpList.Add(responseInfo.OrderNo.ToString());
            tmpList.Add(docNo);
            tmpList.Add(responseInfo.DocSeq.ToString());
            tmpList.Add("");
            message.Append(string.Join(",", tmpList.ToArray()).PadRight(512));

            // イメージフラグ -> "0"固定
            message.Append("0");

            // ブラウザツールＩＤ -> "1002"固定
            message.Append("1002");

            // 報告者
            message.Append(ConfigurationManager.AppSettings["ReUName"].PadRight(20));

            // 報告書ＩＤ
            message.Append(ConfigurationManager.AppSettings["ReId"].PadRight(8));

            // 報告部署
            message.Append(ConfigurationManager.AppSettings["ReDep"].PadRight(3));

            // 報告日時
            message.Append(DateTime.Now.ToString("yyyyMMddhhmmss").PadRight(14));

            // 実施者
            message.Append(ConfigurationManager.AppSettings["JiUName"].PadRight(20));

            // 実施者ＩＤ
            message.Append(ConfigurationManager.AppSettings["JiId"].PadRight(8));

            // 実施部署
            message.Append(ConfigurationManager.AppSettings["JiDep"].PadRight(3));

            // 実施日時 -> 受診日
            message.Append((responseInfo.DocDate + new string('0', 6)).PadRight(14));

            // 承認者
            message.Append(ConfigurationManager.AppSettings["CheckUName"].PadRight(20));

            // 承認者ＩＤ
            message.Append(ConfigurationManager.AppSettings["CheckId"].PadRight(8));

            // 承認日時
            message.Append(DateTime.Now.ToString("yyyyMMddhhmmss").PadRight(14));

            // 承認状態 -> "1"固定
            message.Append("1");

            // ComLib連携フラグ -> "0"固定
            message.Append("0");

            // レポート情報 -> ＨＴＭＬレポート
            message.Append(responseInfo.Html.Trim());

            // 終端
            message.Append("\r");

            return message.ToString();
        }

        /// <summary>
        /// 処理モードを送信電文用のコードに変換する
        /// </summary>
        /// <param name="mode"></param>
        /// <returns></returns>
        private string ConvertMakeCode(MakeMode mode)
        {
            var codes = new Dictionary<MakeMode, string>();
            codes.Add(MakeMode.New, "01");
            codes.Add(MakeMode.Update, "02");

            if (codes.ContainsKey(mode))
            {
                return codes[mode];
            }

            return "";
        }

        /// <summary>
        /// 処理モードを判定する
        /// </summary>
        /// <param name="orderDocs"></param>
        /// <returns></returns>
        private MakeMode JudgeMakeMode(List<dynamic> orderDocs)
        {
            if (orderDocs.Count <= 0) return MakeMode.New;

            if (orderDocs[1].sendDiv = 2)
            {
                return MakeMode.New;
            }

            return MakeMode.Update;
        }

        /// <summary>
        /// オーダー番号を取得する
        /// </summary>
        /// <param name="mode"></param>
        /// <param name="orderDoc"></param>
        /// <returns></returns>
        private int GenerateOrderNo(MakeMode mode, dynamic orderDoc)
        {
            if (mode == MakeMode.New && orderDoc == null)
            {
                return new OrderDoc().GenerateNewOrderNumber();
            }

            return orderDoc.ORDERNO;
        }

        /// <summary>
        /// オーダー日付取得
        /// </summary>
        /// <param name="mode"></param>
        /// <param name="personalAttrib"></param>
        /// <param name="orderDoc"></param>
        /// <returns></returns>
        private string JudeDocDate(MakeMode mode, dynamic personalAttrib, dynamic orderDoc)
        {
            if (mode == MakeMode.New && orderDoc == null)
            {
                return personalAttrib.CSLDATE.ToString("yyyyMMdd");
            }

            return orderDoc.ORDERDATE.ToString("yyyyMMdd");
        }

        /// <summary>
        /// 結果レポートを作成する
        /// </summary>
        /// <param name="rsvNo"></param>
        /// <returns></returns>
        private List<string> MakeHtmlReport(int rsvNo)
        {
            string path = Application.StartupPath;

            var tmplFileNames = new List<string>();
            tmplFileNames.Add("HainsReportNew01.tmpl");

            var htmls = new List<string>();
            foreach(var tmplFileName in tmplFileNames)
            {
                var sr = new StreamReader(Path.Combine(path, tmplFileName));

                string s = sr.ReadToEnd();

                htmls.Add(s);
            }

            return htmls;
        }
    }
}
