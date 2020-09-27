using System.Collections.Generic;

namespace Hainsi.Common.Table
{
    class ColumnWordRules
    {
        /// <summary>
        /// カラムに対する文字列のルール一覧を作成する
        /// </summary>
        /// <returns>ルール一覧</returns>
        public static Dictionary<string, WordRuleModel> CreateRule()
        {
            // キーをカラム名、値をルールで設定する
            // 文字列にルールがないものについては設定しない
            return new Dictionary<string, WordRuleModel>
            {
                ["GRP_P.GRPCD"] = WordRules.GetAlphanumericRule(),
                ["ORG.ORGCD1"] = WordRules.GetAlphanumericRule(),
                ["ORG.ORGCD2"] = WordRules.GetAlphanumericRule(),
                ["ORGADDR.ZIPCD"] = WordRules.GetNumberRule(),
                ["ORGADDR.PREFCD"] = WordRules.GetNumberRule(),
                ["ORGADDR.DIRECTTEL"] = WordRules.GetHalfwordRule(),
                ["ORGADDR.TEL"] = WordRules.GetHalfwordRule(),
                ["ORGADDR.EXTENSION"] = WordRules.GetHalfwordRule(),
                ["ORGADDR.FAX"] = WordRules.GetHalfwordRule(),
                ["ORGADDR.EMAIL"] = WordRules.GetHalfwordRule(),
                ["ORGADDR.CHARGEEMAIL"] = WordRules.GetHalfwordRule()
            };
        }

     }
}
