using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;

namespace Hainsi.Common
{
    public class ParamValues
    {
        /// <summary>
        /// パラメータ値
        /// </summary>
        private JToken OriginalValues { get; }

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="paramValues">パラメータ値</param>
        public ParamValues(JToken paramValues)
        {
            OriginalValues = paramValues;
        }

        /// <summary>
        /// trimした値
        /// </summary>
        /// <param name="key">変数名</param>
        /// <returns>trimした値</returns>
        public string this[string key] {
            get {
                return GetOriginalValue(key).Trim();
            }
        }
        
        /// <summary>
        /// オリジナルの値を取得
        /// </summary>
        /// <param name="key">変数名</param>
        /// <returns>変数値</returns>
        public string GetOriginalValue(string key)
        {
            return Util.ConvertToString(OriginalValues[key]);
        }
    }
}
