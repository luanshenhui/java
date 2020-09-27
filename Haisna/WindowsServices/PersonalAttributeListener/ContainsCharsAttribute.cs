using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Fujitsu.Hainsi.WindowServices.PersonalAttributeListener
{
    [AttributeUsage(AttributeTargets.Property, AllowMultiple = false)]
    class ContainsCharsAttribute : ValidationAttribute
    {
        /// <summary>有効文字列</summary>
        private string[] Values { get; }

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="values">有効文字列</param>
        public ContainsCharsAttribute(string[] values) : base()
        {
            Values = values;
        }

        /// <summary>
        /// 有効文字列かどうかをチェックする
        /// </summary>
        /// <param name="value">チェック対象文字列</param>
        /// <param name="validationContext">Validation設定値</param>
        /// <returns>Validation結果</returns>
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            var chars = value as char[];
            var str = new string(chars).Trim();

            if (!Values.Contains(str))
            {
                return new ValidationResult(string.Format("{0} は有効文字列ではありません : {1}", validationContext.DisplayName, str));
            }

            return ValidationResult.Success;
        }
    }
}
