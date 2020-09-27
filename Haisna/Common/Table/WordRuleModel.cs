using System;

namespace Hainsi.Common.Table
{
    class WordRuleModel
    {
        /// <summary>
        /// 文字列制約
        /// </summary>
        public Func<string, bool> Rule { get; set; }
        /// <summary>
        /// バリデーションエラー時のメッセージ
        /// </summary>
        public string Message { get; set; }
    }
}
