using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Fujitsu.Hainsi.WindowServices.PersonalAttributeListener
{
    [AttributeUsage(AttributeTargets.Property, AllowMultiple = false)]
    class RequiredCharsAttribute : FilledCharsAttribute
    {
        /// <summary>
        /// 文字列の必須チェックを行う
        /// </summary>
        /// <param name="value">チェック対象文字列</param>
        /// <param name="validationContext">Validation情報</param>
        /// <returns>Validation結果</returns>
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            var result = base.IsValid(value, validationContext);

            if (result != null && !result.Equals(ValidationResult.Success))
            {
                return result;
            }

            var chars = value as char[];

            if (new string(chars).Trim() == "")
            {
                return new ValidationResult(string.Format("{0} の値は必須ですが空白がセットされています。", validationContext.DisplayName));
            }

            return ValidationResult.Success;
        }
    }
}
