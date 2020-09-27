using System.Collections.Generic;

namespace Hainsi.Common.Table
{
    class WordRules
    {
        /// <summary>
        /// カラムに対する文字列のルールを返す
        /// </summary>
        /// <param name="column">カラム名</param>
        /// <returns>ルール</returns>
        public static WordRuleModel GetRule(string column)
        {
            Dictionary<string, WordRuleModel> rules = ColumnWordRules.CreateRule();

            // 該当するカラムがなければデフォルトルールを返す
            if (!rules.ContainsKey(column))
            {
                return GetDefaultRule();
            }

            return rules[column];
        }

        /// <summary>
        /// デフォルトの文字列ルール
        /// </summary>
        /// <returns>ルール</returns>
        public static WordRuleModel GetDefaultRule()
        {
            return new WordRuleModel
            {
                Rule = (string value) => {
                    return true;
                },
                Message = "{0}は半角{1}文字以内で入力してください。"
            };
        }

        /// <summary>
        /// 半角英数の文字列ルール
        /// </summary>
        /// <returns>ルール</returns>
        public static WordRuleModel GetAlphanumericRule()
        {
            return new WordRuleModel
            {
                Rule = (string value) => {
                    return string.IsNullOrEmpty(value) || Util.IsAlphanumeric(value);
                },
                Message = "{0}は{1}文字以内の半角英数字で入力してください。"
            };
        }

        /// <summary>
        /// 半角英数記号の文字列ルール
        /// </summary>
        /// <returns>ルール</returns>
        public static WordRuleModel GetHalfwordRule()
        {
            return new WordRuleModel
            {
                Rule = (string value) => {
                    return string.IsNullOrEmpty(value) || Util.IsHalfword(value);
                },
                Message = "{0}は{1}文字以内の半角英数字記号で入力してください。"
            };
        }

        /// <summary>
        /// 半角数字の文字列ルール
        /// </summary>
        /// <returns>ルール</returns>
        public static WordRuleModel GetNumberRule()
        {
            return new WordRuleModel
            {
                Rule = (string value) => {
                    return string.IsNullOrEmpty(value) || Util.IsNumber(value);
                },
                Message = "{0}は{1}文字以内の半角数字で入力してください。"
            };
        }
    }
}
