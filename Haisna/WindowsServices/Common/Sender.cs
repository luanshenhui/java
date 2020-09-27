using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Net.Sockets;

namespace Fujitsu.Hainsi.WindowServices.Common
{
    public class Sender
    {
        private readonly string serverAddress;
        private readonly int serverPort;
        private readonly int timeOut;

        private readonly Encoding enc = Encoding.UTF8;

        //private Func<byte[]> MakeByteStream;
        private Action<byte[]> ActionByResponse;

        public Sender(Distination distination, Action<byte[]> ActionByResponse)
        {
            serverAddress = distination.ServerAddress;
            serverPort = distination.ServerPort;
            timeOut = distination.TimeOut;
            //this.MakeByteStream = MakeByteStream;
            this.ActionByResponse = ActionByResponse;
        }

        public void Send(byte[] byteSteram)
        {
            byte[] recievedBytes;

            using (var client = new TcpClient(serverAddress, serverPort))
            using (NetworkStream netStream = client.GetStream())
            {
                //if (MakeByteStream == null) return;

                client.ReceiveTimeout = timeOut;
                client.SendTimeout = timeOut;

                // ソケットで送信するデータをセット
                //byte[] sendBuffer = MakeByteStream();
                byte[] sendBuffer = byteSteram;

                // 送信処理
                netStream.Write(sendBuffer, 0, sendBuffer.Length);
                netStream.Flush();

                // 受信処理
                using (var memoryStream = new MemoryStream())
                {
                    int receiveSize = 0;
                    byte[] buffer = new byte[1024];

                    while (true)
                    {
                        // データの一部を受信する
                        receiveSize = netStream.Read(buffer, 0, buffer.Length);

                        // 受信可能なデータが存在しない場合は終了
                        if (receiveSize == 0)
                        {
                            break;
                        }

                        // 受信したデータを蓄積
                        memoryStream.Write(buffer, 0, receiveSize);
                    }

                    recievedBytes = memoryStream.ToArray();
                }
            }

            ActionByResponse(recievedBytes);
        }
    }
}
