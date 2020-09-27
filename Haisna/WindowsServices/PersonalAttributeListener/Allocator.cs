using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;

namespace Fujitsu.Hainsi.WindowServices.PersonalAttributeListener
{
    static class Allocator
    {
        private static readonly Encoding enc = Encoding.GetEncoding("shift_jis");

        /// <summary>
        /// 文字列をStructLayoutを実装したオブジェクトに割り当てる
        /// </summary>
        /// <typeparam name="T">StructLayoutを割り当てたクラス</typeparam>
        /// <param name="input">文字列</param>
        /// <param name="structLayout">文字列を割り当てるオブジェクト</param>
        public static void AllocTo<T>(this string input, ref T structLayout)
        {
            // 文字列をバイト変換
            var bytes = enc.GetBytes(input);

            // オブジェクトのサイズを取得
            int size = Marshal.SizeOf(structLayout);

            // オブジェクトのサイズをバッファに確保
            var buffer = new byte[size];

            // オブジェクトに割り当てるサイズを取得する
            // これが文字列より長かったり、オブジェクトサイズより長かったりするとエラーになるため
            int allocLength = bytes.Length;
            if (allocLength > size) allocLength = size;

            // バッファに文字列をコピーする
            Array.Copy(bytes, buffer, allocLength);

            // メモリを確保しポインタを取得
            IntPtr ptr = Marshal.AllocCoTaskMem(size);

            // バッファに確保した値をメモリにコピー
            Marshal.Copy(buffer, 0, ptr, size);

            // 確保したメモリをオブジェクトに割り当て
            structLayout = (T)Marshal.PtrToStructure(ptr, typeof(T));
        }

        /// <summary>
        /// StructLayoutを実装したオブジェクトにメモリを割り当てる
        /// </summary>
        /// <typeparam name="T">StructLayoutを割り当てたクラス</typeparam>
        /// <param name="structure">メモリを割り当てるオブジェクト</param>
        public static void MAlloc<T>(ref T structure)
        {
            
            // オブジェクトのサイズ取得
            int size = Marshal.SizeOf(structure);

            // バッファ確保
            var buffer = new byte[size];

            // メモリを確保しポインタを取得
            IntPtr ptr = Marshal.AllocCoTaskMem(size);

            // バッファに確保した値をメモリにコピー
            // オブジェクトにメモリは確保されてはいるが空ではないためバイト配列をコピーしてクリアする
            Marshal.Copy(buffer, 0, ptr, size);

            // 確保したメモリをオブジェクトに割り当て
            structure = (T)Marshal.PtrToStructure(ptr, typeof(T));

        }

        /// <summary>
        ///  StructLayoutを実装したオブジェクトをバイト配列に変換する
        /// </summary>
        /// <typeparam name="T">StructLayoutを割り当てたクラス</typeparam>
        /// <param name="structure"></param>
        /// <returns></returns>
        public static byte[] ConvertToBytes<T>(this T structure)
        {
            // オブジェクトのサイズ取得
            int size = Marshal.SizeOf(structure);

            // バッファ確保
            var bytes = new byte[size];

            // メモリを確保しポインタを取得
            IntPtr ptr = Marshal.AllocCoTaskMem(size);

            // オブジェクトを確保したメモリに割り当て
            Marshal.StructureToPtr(structure, ptr, false);

            // メモリの内容をバイト配列にコピー
            Marshal.Copy(ptr, bytes, 0, size);

            // メモリを開放
            Marshal.FreeCoTaskMem(ptr);

            return bytes;
        }


        /// <summary>
        /// 文字の配列をバイト列にコピーする
        /// </summary>
        /// <param name="input">入力</param>
        /// <param name="target">割当先</param>
        public static void ConvertAndCopyTo(this char[] input, ref byte[] target)
        {
            ConvertAndCopyTo(new string(input), ref target);
        }

        /// <summary>
        /// 文字列をバイト列にコピーする
        /// </summary>
        /// <param name="input">入力</param>
        /// <param name="target">割当先</param>
        public static void ConvertAndCopyTo(this string input, ref byte[] target)
        {
            var bytes = enc.GetBytes(input);

            Array.Copy(bytes, target, target.Length);
        }
    }
}
