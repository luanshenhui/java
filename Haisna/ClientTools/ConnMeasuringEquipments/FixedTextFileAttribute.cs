using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace ConnMeasuringEquipments
{
    /// <summary>
    /// クラス、構造体の固定長ファイル出力定義用属性
    /// </summary>
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Struct)]
    public class FixedTextFileAttribute : Attribute
    {
        /// <summary>
        /// エンコード
        /// </summary>
        public string Encode;

        /// <summary>
        /// クラスまたは構造体に定義されたエンコーディングを取得する
        /// </summary>
        /// <typeparam name="T">対象のクラス、構造体</typeparam>
        /// <returns>エンコード</returns>
        public static Encoding GetEncoding<T>()
        {
            var encAttr = Attribute.GetCustomAttribute(
                typeof(T), typeof(FixedTextFileAttribute)) as FixedTextFileAttribute;

            return Encoding.GetEncoding(encAttr.Encode);
        }

        /// <summary>
        /// 指定された属性に従って固定長テキストを作成して返す
        /// </summary>
        /// <typeparam name="T">出力対象データクラス、構造体</typeparam>
        /// <param name="o">出力データが格納されたオブジェクト</param>
        /// <returns></returns>
        public static string ConvertFixedText<T>(object o)
        {
            var values = (T)o;

            //指定されたエンコードを取得する
            Encoding enc = GetEncoding<T>();

            //データを固定長文字列にする
            StringBuilder result = new StringBuilder();
            foreach (PropertyInfo info in typeof(T).GetProperties())
            {
                //出力対象除外項目判定：Reject属性が設定されている項目を除外する
                var reject = Attribute.GetCustomAttribute(info, typeof(RejectAttribute));
                if (reject != null)
                {
                    continue;
                }

                //固定長定義属性を取得する
                var fixedAttr = Attribute.GetCustomAttribute(
                    info, typeof(FixedAttribute)) as FixedAttribute;
                //属性が設定されていないならその項目を出力対象から除外する
                if (fixedAttr == null)
                {
                    continue;
                }

                //出力項目値を出力する
                // string value = info.GetValue(values, null).ToString();
                string value = "";
                if (info.GetValue(values, null) != null)
                {
                    value = info.GetValue(values, null).ToString();
                }


                //指定バイトを超えている場合、後ろから１文字づつ削って指定バイトに調整する
                while (fixedAttr.ByteLength < enc.GetByteCount(value))
                {
                    value = value.Substring(0, value.Length - 1);
                }

                //不足長を指定文字で埋める
                //※PadRight,PadLeftの指定桁は文字数であり、バイト数ではない。
                //  従って、不足バイト数ではなく不足文字数に換算して指定する
                int padLen = fixedAttr.ByteLength - (enc.GetByteCount(value) - value.Length);
                switch (fixedAttr.PadType)
                {
                    case EPadType.After:
                        result.Append(value.PadRight(padLen, fixedAttr.PadChar));
                        break;

                    case EPadType.Before:
                        result.Append(value.PadLeft(padLen, fixedAttr.PadChar));
                        break;
                }
            }

            return result.ToString();
        }

        /// <summary>
        /// 固定長データレコードの取得
        /// </summary>
        /// <typeparam name="T">固定長タイプ</typeparam>
        /// <param name="values">値</param>
        /// <returns>固定長データレコード</returns>
        public static string GetFixedDataRecord<T>(IEnumerable<T> values)
        {
            string builder = "";
            foreach (T value in values)
            {
                builder += ConvertFixedText<T>(value);
            }
            return builder;
        }

    }

    /// <summary>
    /// 項目毎の固定長出力定義属性
    /// </summary>
    [AttributeUsage(AttributeTargets.Property)]
    public class FixedAttribute : Attribute
    {
        //バイト長
        public int ByteLength;
        //不足桁への文字埋めで使用する文字
        public char PadChar = ' ';
        //前埋め／後埋め
        public EPadType PadType = EPadType.After;
    }

    /// <summary>
    /// 固定長出力しない項目を指定するための属性
    /// </summary>
    [AttributeUsage(AttributeTargets.Property)]
    public class RejectAttribute : Attribute
    {
    }

    /// <summary>
    /// 不足桁文字埋めタイプ
    /// </summary>
    public enum EPadType
    {
        Before    //前埋め
        , After    //後埋め
    }
}