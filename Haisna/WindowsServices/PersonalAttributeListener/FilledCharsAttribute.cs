using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Fujitsu.Hainsi.WindowServices.PersonalAttributeListener
{
    /// <summary>
    /// 固定長で抜き取った値をチェックする
    /// </summary>
    [AttributeUsage(AttributeTargets.Property, AllowMultiple = false)]
    class FilledCharsAttribute : RequiredAttribute
    {
        /// <summary>
        /// 固定長で抜き取った値に対しての共通チェック処理
        /// </summary>
        /// <param name="value">固定長の値</param>
        /// <param name="validationContext">Validationの設定値</param>
        /// <returns>Validationの結果</returns>
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            if (value == null)
            {
                return new ValidationResult(string.Format("{0} に値が割り当てられていません。", validationContext.DisplayName));
            }

            var chars = value as char[];
            if (chars == null)
            {
                return new ValidationResult(string.Format("{0} はchar[]型ではありません。", validationContext.DisplayName));
            }

            if (chars.Contains('\0'))
            {
                return new ValidationResult(string.Format("{0} は文字列長が不十分です。(長さ {1}): {2}", validationContext.DisplayName, chars.Length.ToString(), new string(chars).Trim('\0')));
            }

            return ValidationResult.Success;
        }
    }
}
