using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;

namespace Fujitsu.Hainsi.WindowServices.PersonalAttributeListener
{
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    class ResponseValues
    {
        /// <summary>連番</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 5)]
        public byte[] seq;

        /// <summary>システムコード</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
        public byte[] systemCode;

        /// <summary>電文種別</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
        public byte[] telegramType;

        /// <summary>継続フラグ</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
        public byte[] continueFlag;

        /// <summary>宛先コード</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
        public byte[] distCode;

        /// <summary>発信元コード</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
        public byte[] sourceCode;

        /// <summary>処理日</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
        public byte[] processingDate;

        /// <summary>処理時間</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 6)]
        public byte[] processingTime;

        /// <summary>端末名</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
        public byte[] terminalName;

        /// <summary>利用者番号</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
        public byte[] userId;

        /// <summary>処理区分</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
        public byte[] processingCateTag;

        /// <summary>応答種別</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
        public byte[] responseCate;

        /// <summary>電文長</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 5)]
        public byte[] telegramLength;

        /// <summary>改行コード</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
        public byte[] linefeedCode;

        /// <summary>電文終端コード</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
        public byte[] terminationCode;
    }
}
