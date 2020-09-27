using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConnMeasuringEquipments
{
    /// <summary>
    /// 固定長データにおける各列毎の情報設定用モデル
    /// ※シリアルポートからの電文を固定長で区切るための各列指定として使用する
    /// </summary>
    class FixedLengthModel
    {
        // 列名
        public String Name { set; get; }

        // 列の長さ
        public int Length { set; get; }

        // 結果データかどうか？（filler等の結果データでないものにはfalseを設定）
        public bool IsResultData { set; get; }

        public FixedLengthModel(string name, int length, bool isResultdata)
        {
            Name = name;
            Length = length;
            IsResultData = isResultdata;
        }


    }
}
