using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;
using System.Linq;

#pragma warning disable CS1591

namespace Entity.Helper
{
    public static class SqlHelper
    {
        /// <summary>
        /// OracleParameterCollectionコレクションに配列バインド用のパラメータを追加します。
        /// </summary>
        /// <param name="collection">OracleParameterCollectionオブジェクト</param>
        /// <param name="name">パラメータ名</param>
        /// <param name="val">値</param>
        /// <param name="direction">OracleParameterディレクション</param>
        /// <param name="dbType">OracleParameterのデータ型</param>
        /// <param name="size">OracleParameterのサイズ</param>
        /// <param name="length">要素の長さ</param>
        /// <returns>追加したOracleParameterオブジェクトのインスタンス</returns>
        public static OracleParameter AddTable(
            this OracleParameterCollection collection,
            string name,
            Object val,
            ParameterDirection direction,
            OracleDbType dbType,
            int size,
            int length
        )
        {
            OracleParameter param = collection.Add(name, dbType, size, val, direction);
            param.CollectionType = OracleCollectionType.PLSQLAssociativeArray;

            if (length > 0)
            {
                param.ArrayBindSize = Enumerable.Range(0, size).Select(x => length).ToArray();
            }

            return param;
        }

        /// <summary>
        /// OracleParameterCollectionコレクションに配列バインド用のパラメータを追加します。
        /// </summary>
        /// <param name="collection">OracleParameterCollectionオブジェクト</param>
        /// <param name="name">パラメータ名</param>
        /// <param name="direction">OracleParameterディレクション</param>
        /// <param name="dbType">OracleParameterのデータ型</param>
        /// <param name="size">OracleParameterのサイズ</param>
        /// <param name="length">要素の長さ</param>
        /// <returns>追加したOracleParameterオブジェクトのインスタンス</returns>
        public static OracleParameter AddTable(
            this OracleParameterCollection collection,
            string name,
            ParameterDirection direction,
            OracleDbType dbType,
            int size,
            int length
        )
        {
            return AddTable(collection, name, null, direction, dbType, size, length);
        }
    }
}
