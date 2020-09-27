import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.Socket;
import java.util.Timer;
import java.util.TimerTask;


public class SocketClient {


    public static void main(String[] args) {


        TimerTask task = new TimerTask() {
            @Override
            public void run() {

                System.out.println("=======================");
                try {

                    //第一次任务
                    InetAddress ia = InetAddress.getByName("172.16.63.113");
                    Socket socket = new Socket(ia, 9999);
                    final DataOutputStream out = new DataOutputStream(socket.getOutputStream());
                    final DataInputStream in = new DataInputStream(socket.getInputStream());

                    out.writeUTF("start");

                    for (int i = 0; i < 1; i++) {
                        System.out.println("1111");
                        out.writeUTF("<rule id='业务id111'><expression id='表达式结果1'>{select count(*) from TEST} > 1 and" +
                                " {select count(*) from TEST} > 5 </expression><expression id='表达式结果2'>{select count(*) from TEST} > 1 and {select count(*) from TEST} > 2 </expression></rule>");

                        System.out.println(">111>"+in.readUTF());
                        System.out.println("222");
                        out.writeUTF("<rule id='业务id222'><expression id='表达式结果1'>{select count(*) from TEST} > 1 and" +
                                " {select count(*) from TEST} > 5 </expression><expression id='表达式结果2'>{select count(*) from TEST} > 1 and {select count(*) from TEST} > 2 </expression></rule>");
                        System.out.println(">22>>"+in.readUTF());
                    }
                    out.writeUTF("stop");

                    out.flush();
//                    ByteArrayOutputStream bos = new ByteArrayOutputStream();
//                    IOUtils.copy(in, bos);
//
//                    System.out.println("=====================" + new String(bos.toByteArray()));
//                    boolean flag2 = true;
//                    while (flag2) {
//                        String result = in.readUTF();
//                        System.out.println(result);
//                        if (result.equals("stop")) {
//                            flag2 = false;
//                        }
////                Thread.sleep(1000);
//                    }

                    socket.getKeepAlive();

//                        out.close();
//            in.close();
                    socket.close();

                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        };

        Timer timer = new Timer();


        timer.schedule(task, 3000, 10000);

//            out.writeUTF("start");
//            for (int i = 0; i < 1; i++) {
//                out.writeUTF("<rule id='业务id'><expression id='表达式结果1'>{select count(*) from TEST where fujian is null and shili=[aaa] } > 1 and {select count(*) from TEST} > 5 </expression><expression id='表达式结果2'>{select count(*) from TEST} > 1 and {select count(*) from TEST} > 2 </expression></rule>");
//                out.writeUTF("<rule id='业务id'><expression id='表达式结果1'>{select count(*) from TEST} > 1 and {select count(*) from TEST} > 5 </expression><expression id='表达式结果2'>{select count(*) from TEST} > 1 and {select count(*) from TEST} > 2 </expression></rule>");
//            }
//            out.writeUTF("stop");
//            out.flush();
//            boolean flag = true;
//            while (flag) {
//                String result = in.readUTF();
//                System.out.println(result);
//                if (result.equals("stop")) {
//                    flag = false;
//                }
//                Thread.sleep(1000);
//            }
//            out.close();
//            in.close();
//            socket.close();
//
//
//            //第二次任务
//            InetAddress ia2 = InetAddress.getByName("192.168.1.110");
//            Socket socket2 = new Socket(ia2, 9999);
//            DataOutputStream out2 = new DataOutputStream(socket2.getOutputStream());
//            DataInputStream in2 = new DataInputStream(socket2.getInputStream());
//
//            out2.writeUTF("start");
//            for (int i = 0; i < 1; i++) {
//                out2.writeUTF("<rule id='业务id'><expression id='表达式结果1'>{select count(*) from TEST} > 1 and {select count(*) from TEST} > 5 </expression><expression id='表达式结果2'>{select count(*) from TEST} > 1 and {select count(*) from TEST} > 2 </expression></rule>");
//                out2.writeUTF("<rule id='业务id'><expression id='表达式结果1'>{select count(*) from TEST} > 1 and {select count(*) from TEST} > 5 </expression><expression id='表达式结果2'>{select count(*) from TEST} > 1 and {select count(*) from TEST} > 2 </expression></rule>");
//            }
//            out2.writeUTF("stop");
//            out2.flush();
//            boolean flag2 = true;
//            while (flag2) {
//                String result = in2.readUTF();
//                System.out.println(result);
//                if (result.equals("stop")) {
//                    flag2 = false;
//                }
//                Thread.sleep(1000);
//            }
//            out2.close();
//            in2.close();
//            socket2.close();


    }

}
