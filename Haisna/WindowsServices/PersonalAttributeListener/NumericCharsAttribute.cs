using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Fujitsu.Hainsi.WindowServices.PersonalAttributeListener
{
    [AttributeUsage(AttributeTargets.Property, AllowMultiple = false)]
    class NumericCharsAttribute : ValidationAttribute
    {
        /// <summary>
        /// 文字列が数値であることをチェックする
        /// </summary>
        /// <param name="value">チェック対象</param>
        /// <param name="validationContext">Validation情報</param>
        /// <returns>チェック結果</returns>
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            var chars = value as char[];

            var str = new string(chars).Trim();

            int tmp;
            if (!int.TryParse(str, out tmp))
            {
                return new ValidationResult(string.Format("{0} は数値ではありません。 : {1}", validationContext.DisplayName, str));
            }

            return ValidationResult.Success;
        }
    }
}
