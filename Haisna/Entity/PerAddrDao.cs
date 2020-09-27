using Dapper;
using Hainsi.Entity.Model;
using System.Data;

namespace Hainsi.Entity
{
    /// <summary>
    /// 個人住所情報データアクセスオブジェクト
    /// </summary>
    public class PerAddrDao : AbstractDao
    {
        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public PerAddrDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// ユーザ登録時の連絡先住所情報を登録する
        /// </summary>
        /// <param name="param">個人情報</param>
        /// <returns>登録件数</returns>
        public int InsertContactPerAddr(PersonAttributeModel param)
        {
            // SQL定義
            string sql = @"
                    merge
                    into peraddr
                        using (
                            select
                                :perid perid
                                , 1 addrdiv
                                , :zipcd zipcd
                                , :cityname cityname
                                , :address1 address1
                                , :address2 address2
                                , :tel1 tel1
                                , :phone phone
                                , :tel2 tel2
                                , :extension extension
                            from
                                dual
                        ) phantom
                            on (
                                peraddr.perid = phantom.perid
                                and peraddr.addrdiv = phantom.addrdiv
                            ) when not matched then
                    insert (
                        perid
                        , addrdiv
                        , zipcd
                        , cityname
                        , address1
                        , address2
                        , tel1
                        , phone
                        , tel2
                        , extension
                    )
                    values (
                        phantom.perid
                        , phantom.addrdiv
                        , phantom.zipcd
                        , phantom.cityname
                        , phantom.address1
                        , phantom.address2
                        , phantom.tel1
                        , phantom.phone
                        , phantom.tel2
                        , phantom.extension
                    )
                    ";

            // パラメータセット
            var sqlParam = new
            {
                perid = param.PerId,
                zipcd = param.ZipCd,
                cityname = param.CityName,
                address1 = param.Address1,
                address2 = param.Address2,
                tel1 = param.Tel1,
                phone = param.Phone,
                tel2 = param.Tel2,
                extension = param.Extension
            };

            // SQL実行
            return connection.Execute(sql, sqlParam);
        }

        /// <summary>
        ///住所情報を登録する
        /// </summary>
        /// <param name="param">個人情報</param>
        /// <returns>登録件数</returns>
        public int RegisterPerAddr(PersonAttributeModel param)
        {
            // SQL定義
            string sql = @"
                    merge
                    into peraddr
                        using (
                            select
                                :perid perid
                                , :addrdiv addrdiv
                                , :zipcd zipcd
                                , :prefcd prefcd
                                , :cityname cityname
                                , :address1 address1
                                , :address2 address2
                                , :tel1 tel1
                                , :phone phone
                                , :tel2 tel2
                                , :extension extension
                            from
                                dual
                        ) phantom
                            on (
                                peraddr.perid = phantom.perid
                                and peraddr.addrdiv = phantom.addrdiv
                            ) when not matched then
                    insert (
                        perid
                        , addrdiv
                        , zipcd
                        , prefcd
                        , cityname
                        , address1
                        , address2
                        , tel1
                        , phone
                        , tel2
                        , extension
                    )
                    values (
                        phantom.perid
                        , phantom.addrdiv
                        , phantom.zipcd
                        , phantom.prefcd
                        , phantom.cityname
                        , phantom.address1
                        , phantom.address2
                        , phantom.tel1
                        , phantom.phone
                        , phantom.tel2
                        , phantom.extension
                    ) when matched then update
                    set
                        zipcd = phantom.zipcd
                        , prefcd = phantom.prefcd
                        , cityname = phantom.cityname
                        , address1 = phantom.address1
                        , address2 = phantom.address2
                        , tel1 = phantom.tel1
                        , phone = phantom.phone
                        , tel2 = phantom.tel2
                        , extension = phantom.extension

                ";

            // パラメータセット
            var sqlParam = new
            {
                perid = param.PerId,
                addrdiv = param.AddrDiv,
                zipcd = param.ZipCd,
                prefcd = param.PrefCd,
                cityname = param.CityName,
                address1 = param.Address1,
                address2 = param.Address2,
                tel1 = param.Tel1,
                phone = param.Phone,
                tel2 = param.Tel2,
                extension = param.Extension
            };

            // SQL実行
            return connection.Execute(sql, sqlParam);
        }
    }
}
