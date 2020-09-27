using Dapper;
using Hainsi.Entity.Model.OrderReport;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System.Data;
using System.Transactions;

namespace Hainsi.Entity
{
    /// <summary>
    /// レポート情報データアクセスオブジェクト
    /// </summary>
    public class OrderReportDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public OrderReportDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// レポート情報を登録する
        /// </summary>
        /// <param name="data">レポート情報モデル</param>
        /// <returns>登録レコード件数</returns>
        public int Register(OrderReport data)
        {
            using (var ts = new TransactionScope())
            {
                // SQL定義
                string sql = @"
                        merge 
                        into orderreport 
                            using ( 
                                select
                                    :rsvno rsvno
                                    , :orderdiv orderdiv
                                    , :orderdate orderdate
                                    , :orderno orderno
                                    , :reportid reportid
                                    , :reportdiv reportdiv
                                    , :reportdivid reportdivid
                                    , :actname actname
                                    , :actid actid
                                    , :actpostcd actpostcd
                                    , :reporter reporter
                                    , :reporterid reporterid
                                    , :reportdate reportdate
                                    , :reportpostcd reportpostcd
                                    , :recogname recogname
                                    , :recogid recogid
                                    , :recogdate recogdate
                                    , :recogstatus recogstatus
                                    , :htmlreport htmlreport 
                                from
                                    dual
                            ) phantom 
                                on (orderreport.rsvno = phantom.rsvno 
                                and orderreport.orderno = phantom.orderno) 
                        when matched then
                        update set 
                            orderdate = phantom.orderdate
                            , reportid = phantom.reportid
                            , reportdiv = phantom.reportdiv
                            , reportdivid = phantom.reportdivid
                            , actname = phantom.actname
                            , actid = phantom.actid
                            , actpostcd = phantom.actpostcd
                            , reporter = phantom.reporter
                            , reporterid = phantom.reporterid
                            , reportdate = phantom.reportdate
                            , reportpostcd = phantom.reportpostcd
                            , recogname = phantom.recogname
                            , recogid = phantom.recogid
                            , recogdate = phantom.recogdate
                            , recogstatus = phantom.recogstatus
                            , htmlreport = phantom.htmlreport
                        when not matched then
                        insert ( 
                            rsvno
                            , orderdiv
                            , orderdate
                            , orderno
                            , reportid
                            , reportdiv
                            , reportdivid
                            , actname
                            , actid
                            , actpostcd
                            , reporter
                            , reporterid
                            , reportdate
                            , reportpostcd
                            , recogname
                            , recogid
                            , recogdate
                            , recogstatus
                            , htmlreport
                        ) 
                        values ( 
                            :rsvno
                            , :orderdiv
                            , :orderdate
                            , :orderno
                            , :reportid
                            , :reportdiv
                            , :reportdivid
                            , :actname
                            , :actid
                            , :actpostcd
                            , :reporter
                            , :reporterid
                            , :reportdate
                            , :reportpostcd
                            , :recogname
                            , :recogid
                            , :recogdate
                            , :recogstatus
                            , :htmlreport
                        ) 
                ";

                // パラメータセット
                var param = new OracleDynamicParameters();
                param.Add("rsvno", data.RsvNo, OracleDbType.Decimal, ParameterDirection.Input);
                param.Add("orderdiv", data.OrderDiv, OracleDbType.Varchar2, ParameterDirection.Input);
                param.Add("orderdate", data.OrderDate, OracleDbType.Date, ParameterDirection.Input);
                param.Add("orderno", data.OrderNo, OracleDbType.Decimal, ParameterDirection.Input);
                param.Add("reportid", data.ReportId, OracleDbType.Varchar2, ParameterDirection.Input);
                param.Add("reportdiv", data.ReportDiv, OracleDbType.Varchar2, ParameterDirection.Input);
                param.Add("reportdivid", data.ReportDivId, OracleDbType.Varchar2, ParameterDirection.Input);
                param.Add("actname", data.ActName, OracleDbType.Varchar2, ParameterDirection.Input);
                param.Add("actid", data.ActId, OracleDbType.Varchar2, ParameterDirection.Input);
                param.Add("actpostcd", data.ActPostCd, OracleDbType.Varchar2, ParameterDirection.Input);
                param.Add("reporter", data.Reporter, OracleDbType.Varchar2, ParameterDirection.Input);
                param.Add("reporterid", data.ReporterId, OracleDbType.Varchar2, ParameterDirection.Input);
                param.Add("reportdate", data.ReportDate, OracleDbType.Date, ParameterDirection.Input);
                param.Add("reportpostcd", data.ReportPostCd, OracleDbType.Varchar2, ParameterDirection.Input);
                param.Add("recogname", data.RecogName, OracleDbType.Varchar2, ParameterDirection.Input);
                param.Add("recogid", data.RecogId, OracleDbType.Varchar2, ParameterDirection.Input);
                param.Add("recogdate", data.RecogDate, OracleDbType.Date, ParameterDirection.Input);
                param.Add("recogstatus", data.RecogStatus, OracleDbType.Decimal, ParameterDirection.Input);
                param.Add("htmlreport", data.HtmlReport, OracleDbType.Clob, ParameterDirection.Input);

                // SQL実行
                int ret = connection.Execute(sql, param);

                // トランザクションをコミット
                ts.Complete();

                return ret;
            }
        }
    }
}
