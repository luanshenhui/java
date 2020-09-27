using Dapper;
using Hainsi.ReportCore;
using System.Collections.Generic;
using System.Linq;

namespace Hainsi.Reports
{
    //[LoggingParam]
    public class OrganizationCsvCreator : CsvCreator
    {
        /// <summary>
        /// 団体データを読み込み
        /// </summary>
        /// <returns>団体データ</returns>
        protected override List<dynamic> GetData()
        {
            string sql =
                  @"
                    select
                        org.orgcd1 団体コード１
                        , org.orgcd2 団体コード２
                        , org.delflg 削除フラグ
                        , org.upddate 更新日
                        , hainsuser.username 更新者
                        , org.orgkname カナ名称
                        , org.orgname 漢字名称
                        , org.orgbillname 請求書用名称
                        , org.orgsname 略称
                        , org.orgdivcd 団体種別
                        , orgaddr.zipcd 郵便番号
                        , orgaddr.prefcd 都道府県コード
                        , orgaddr.cityname 市区町村名
                        , orgaddr.address1 住所１
                        , orgaddr.address2 住所２
                        , orgaddr.tel 電話番号代表
                        , orgaddr.directtel　 電話番号直通
                        , orgaddr.extension 内線
                        , orgaddr.fax ＦＡＸ
                        , org.bank 銀行名
                        , org.branch 支店名
                        , org.accountkind 口座種別
                        , org.accountno 口座番号
                        , org.notes 特記事項
                        , org.spare1 予備１
                        , org.spare2 予備２
                        , org.spare3 予備３ 
                    from
                        org
                        , orgaddr
                        , hainsuser 
                    where
                        org.orgcd1 = orgaddr.orgcd1 
                        and org.orgcd2 = orgaddr.orgcd2 
                        and org.upduser = hainsuser.userid 
                    order by
                        org.orgcd1
                        , org.orgcd2";


            var sqlParam = new
            {};

            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// バリデーション
        /// </summary>
        /// <returns>エラーメッセージのリスト</returns>
        public override List<string> Validate()
        {
            var messages = new List<string>();

            return messages;
        }
    }
}
