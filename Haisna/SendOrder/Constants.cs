namespace Hainsi.SendOrder
{
    /// <summary>
    /// 定数クラス
    /// </summary>
    public class Constants
    {
        #region 電文種別
        /// <summary>
        /// 採尿ラベル依頼
        /// </summary>
        public static readonly string MSGDIV_PRINTLABEL1 = "LU";

        /// <summary>
        /// 採血ラベル依頼
        /// </summary>
        public static readonly string MSGDIV_PRINTLABEL2 = "LH";

        /// <summary>
        /// 採血ラベル依頼（婦人科診察室１）
        /// </summary>
        public static readonly string MSGDIV_PRINTLABEL3 = "L1";

        /// <summary>
        /// 採血ラベル依頼（婦人科診察室２）
        /// </summary>
        public static readonly string MSGDIV_PRINTLABEL4 = "L2";

        /// <summary>
        /// 採血ラベル依頼（婦人科診察室３）
        /// </summary>
        public static readonly string MSGDIV_PRINTLABEL5 = "L3";
        #endregion

        #region 状態区分
        /// <summary>
        /// 未実施
        /// </summary>
        public static readonly string STATUSDIV_NOMEDIEX = "10";

        /// <summary>
        /// 検査開始
        /// </summary>
        public static readonly string STATUSDIV_STARTMEDIEX = "20";

        /// <summary>
        /// 検査終了
        /// </summary>
        public static readonly string STATUSDIV_ENDMEDIEX = "30";

        /// <summary>
        /// 技師コメント入力
        /// </summary>
        public static readonly string STATUSDIV_CMTINPUTCOMPLETE = "40";

        /// <summary>
        /// 面接開始
        /// </summary>
        public static readonly string STATUSDIV_STARTINTERVIEW = "51";

        /// <summary>
        /// 面接終了
        /// </summary>
        public static readonly string STATUSDIV_ENDINTERVIEW = "52";

        /// <summary>
        /// 中止
        /// </summary>
        public static readonly string STATUSDIV_STOPMEDIEX = "90";
        #endregion

        #region オーダ種別
        /// <summary>
        /// 検体検査オーダ
        /// </summary>
        public static readonly string ORDERDIV_LABOTEST = "ORDDIV000001";

        /// <summary>
        /// 血型・検体検査オーダ
        /// </summary>
        public static readonly string ORDERDIV_LABOBLOODTEST = "ORDDIV000003";

        /// <summary>
        /// 喀痰オーダ
        /// </summary>
        public static readonly string ORDERDIV_KAKUTAN = "ORDDIV000004";

        /// <summary>
        /// 婦人科オーダ
        /// </summary>
        public static readonly string ORDERDIV_FUJINKA = "ORDDIV000005";

        /// <summary>
        /// 眼底オーダ（トプコン）
        /// </summary>
        public static readonly string ORDERDIV_RAYPAX_TP = "ORDDIV000013";

        /// <summary>
        /// ＣＡＶＩ・ＡＢＩ検査オーダ（フクダ電子）
        /// </summary>
        public static readonly string ORDERDIV_RAYPAX_FK = "ORDDIV000019";
        #endregion

        #region オーダ区分
        /// <summary>
        /// 検体検査
        /// </summary>
        public static readonly string ORDDIV_LAINS = "1";

        /// <summary>
        /// RAYPAX
        /// </summary>
        public static readonly string ORDDIV_RAYPAX = "6";
        #endregion

        #region 電文送信先区分
        /// <summary>
        /// 電文送信先区分
        /// </summary>
        public enum DestinationConstants
        {
            /// <summary>
            /// ラベル印刷オーダ送信
            /// </summary>
            PrintLabelToLains = 1,

            /// <summary>
            /// 状態変更オーダ送信
            /// </summary>
            ChangeStatusToRaypax = 2,
        }
        #endregion

        #region ソケット情報キー
        /// <summary>
        /// ラベル印刷オーダ（検体検査）
        /// </summary>
        public static readonly string SOCKETKEY_LAINS_PRINTLABEL = "LAINS_PRINTLABEL";

        /// <summary>
        /// 状態変更オーダ（横河）
        /// </summary>
        public static readonly string SOCKETKEY_RAYPAX_YG = "RAYPAX_YG";

        /// <summary>
        /// 状態変更オーダ（トプコン）
        /// </summary>
        public static readonly string SOCKETKEY_RAYPAX_TP = "RAYPAX_TP";

        /// <summary>
        /// 状態変更オーダ（フクダ電子）
        /// </summary>
        public static readonly string SOCKETKEY_RAYPAX_FK = "RAYPAX_FK";
        #endregion

        #region 電文情報キー
        /// <summary>
        /// ラベル印刷オーダ（検体検査）
        /// </summary>
        public static readonly string MSGTKEY_LAINS_PRINTLABEL = "LAINS_PRINTLABEL";

        /// <summary>
        /// 状態変更オーダ
        /// </summary>
        public static readonly string MSGTKEY_RAYPAX = "RAYPAX";
        #endregion

        #region 応答電文の応答種別
        /// <summary>
        /// 応答電文の応答種別
        /// </summary>
        public enum ResponseValueConstants
        {
            /// <summary>
            /// 正常終了
            /// </summary>
            Ok = 1,

            /// <summary>
            /// リトライ
            /// </summary>
            Retry = 2,

            /// <summary>
            /// スキップ
            /// </summary>
            Skip = 3,

            /// <summary>
            /// ダウン
            /// </summary>
            Down = 4,

            /// <summary>
            /// その他
            /// </summary>
            Else = 5,
        }
        #endregion
    }
}
