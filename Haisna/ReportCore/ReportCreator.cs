using Hainsi.Common;
using Microsoft.Extensions.Configuration;
using System.Collections.Generic;
using System.Data;

namespace Hainsi.ReportCore
{
    abstract public class ReportCreator
    {
        /// <summary>
        /// 定義体のファイル名を返す
        /// </summary>
        /// <param name="reportCd">帳票コード</param>
        /// <returns>定義体ファイル名</returns>
        public delegate List<string> ReadFormFileNamesDeledate(string reportCd);

        /// <summary>
        /// キャンセルチェック処理
        /// </summary>
        /// <remarks>キャンセルされていればReportLogCancelExceptionをthrowする</remarks>
        public delegate void CheckCanceledDelegate();

        /// <summary>
        /// 構成情報オブジェクト
        /// </summary>
        protected IConfiguration configuration;

        /// <summary>
        /// コネクションオブジェクト
        /// </summary>
        protected IDbConnection connection;

        /// <summary>
        /// 帳票コード
        /// </summary>
        public virtual string ReportCd { get; }

        /// <summary>
        /// 帳票名
        /// </summary>
        public virtual string ReportName { get; }

        /// <summary>
        /// MIMEタイプ
        /// </summary>
        public virtual Report.MimeType MimeType { get; }

        /// <summary>
        /// パラメータ
        /// </summary>
        protected ParamValues queryParams;

        /// <summary>
        /// 印刷ステータス
        /// </summary>
        public Report.Status Status { get; protected set; }

        /// <summary>
        /// 出力カウント
        /// </summary>
        public int OutputCount { get; protected set; }

        /// <summary>
        /// 一時ファイルのパス
        /// </summary>
        public string TempFilePath { get; protected set; }

        /// <summary>
        /// ファイル名
        /// </summary>
        public string FileName { get; protected set; }

        /// <summary>
        /// 定義体のファイル名を返す
        /// </summary>
        /// <returns>定義体ファイル名</returns>
        public ReadFormFileNamesDeledate ReadFormFileNames;

        /// <summary>
        /// キャンセルチェック処理
        /// </summary>
        /// <remarks>キャンセルされていればReportLogCancelExceptionをthrowする</remarks>
        public CheckCanceledDelegate CheckCanceled;

        /// <summary>
        /// パラメータをセット
        /// </summary>
        /// <param name="queryParam">パラメータ</param>
        public virtual void SetQueryParam(ParamValues queryParam)
        {
            queryParams = queryParam;
        }

        /// <summary>
        /// ファイル作成の実装
        /// </summary>
        public abstract void CreateContent();

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージ</returns>
        public virtual List<string> Validate()
        {
            return null;
        }

        /// <summary>
        /// 構成情報オブジェクトを設定します。
        /// </summary>
        /// <param name="configuration"></param>
        public void SetConfiguration(IConfiguration configuration)
        {
            this.configuration = configuration;
        }

        /// <summary>
        /// コネクションオブジェクトを設定します。
        /// </summary>
        /// <param name="connection"></param>
        public void SetConnection(IDbConnection connection)
        {
            this.connection = connection;
        }
    }
}
