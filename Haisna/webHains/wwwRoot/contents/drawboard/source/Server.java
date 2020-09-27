/*
Drawboard - Java applet used to make graphical teleconferences
Copyright (C) 2001  Tomek "TomasH" Zielinski, tomash@fidonet.org.pl

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

package drawboard;

import java.io.*;
import java.net.*;
import java.util.*;

import java.awt.*;
import java.awt.image.*;

// =============================================================================
// =============================================================================
public class Server implements Runnable{
  volatile ServerSocket serverSocket = null;      // ServerSocket
  volatile int PORT = 7904;                       // default port number
  final short RIGHT_MARGIN=Main.RIGHT_MARGIN;     // Menu width
  final short BOTTOM_MARGIN=Main.BOTTOM_MARGIN;   // Colorpicker height
  volatile SingleClientHandle[] sch=null;         // table of client sockets
  int MAX=15;                                     // deault maximum
  volatile static int CURRENT=0;                  // temporary people counter
//shimo
  int DELAY=5;                                   // delay between pings
//  int DELAY=30;                                   // delay between pings
//shimo
  short DIM_X=600, DIM_Y=450;                     // image size
  int color=0xFFFFFFFF;                           // default background color
  String ext = ".png";
  volatile int matrix[];                          // "offline" image pixel array
  static boolean cansave=true;                    // can server save pictures?
  String savepath=System.getProperty("user.dir")+File.separatorChar+"screenshot";
                                                  // default path for saving images
  static boolean runQuiet=false;                  // run without any output
  static boolean checkConnectFlg=false;
  Socket wksocket;

  // =============================================================================
  // "Starter"
  // =============================================================================
  public static void main(String[] args) throws IOException {
    new Server(args);
  }

  // =============================================================================
  // returns date and time for event logging...
  // =============================================================================
  public static String hour(){
    return hour(':');
  }

  // =============================================================================
  // ... and filename
  // =============================================================================
  public static String hour(char separator){
  Calendar now = Calendar.getInstance();
  return
    (((now.get(Calendar.YEAR)<10)?"0":"")+now.get(Calendar.YEAR))
    +separator+
    (((now.get(Calendar.MONTH)<9)?"0":"")+(now.get(Calendar.MONTH)+1))
    +separator+
    (((now.get(Calendar.DAY_OF_MONTH)<10)?"0":"")+now.get(Calendar.DAY_OF_MONTH))
    +separator+
    (((now.get(Calendar.HOUR_OF_DAY)<10)?"0":"")+now.get(Calendar.HOUR_OF_DAY))
    +separator+
    (((now.get(Calendar.MINUTE)<10)?"0":"")+now.get(Calendar.MINUTE))
    +separator+
    (((now.get(Calendar.SECOND)<10)?"0":"")+now.get(Calendar.SECOND));
  }

  // =============================================================================
  // Constructor (with options reading)
  // =============================================================================
  Server(String[] args){
    for (int a=0; a<args.length; a++)
      if (args[a].equalsIgnoreCase("-quiet")) runQuiet=true;
    for (int a=0; a<args.length; a++)
      if (args[a].equalsIgnoreCase("-h") || args[a].equalsIgnoreCase("--help") || args[a].equalsIgnoreCase("-help")){
        System.out.println("Command line switches:");
        System.out.println(" -x SIZEX       - applet horizontal size [pixels]     (default: 600)");
        System.out.println(" -y SIZEY       - applet vertical size [pixels]       (default: 450)");
        System.out.println(" -p PORT        - server port number                  (default: 7904)");
        System.out.println(" -m MAXCLIENTS  - maximum client number               (default: 15)");
        System.out.println(" -d DELAY       - delay between client ping [seconds] (default: 30)");
        System.out.println(" -c RRGGBB      - initial background color [hex]      (default: 0000FF)");
        System.out.println(" -s [on|off]    - allow image saving                  (default: on)");
        System.out.println(" -savepath DIR  - [full] image saving directory path  (default: ./screenshot )");
        System.out.println(" -quiet         - runs quiet (no text output)");
        System.out.println(" -help          - shows this help");
        System.out.println("");
        System.exit(0);
      }

    for (int a=0; a<args.length; a++){
      try{
          if (args[a].equalsIgnoreCase("-p")) PORT=java.lang.Integer.parseInt(args[a+1]);
          if (args[a].equalsIgnoreCase("-m")) MAX=java.lang.Integer.parseInt(args[a+1]);
          if (args[a].equalsIgnoreCase("-d")) DELAY=java.lang.Integer.parseInt(args[a+1]);
          if (args[a].equalsIgnoreCase("-x")) DIM_X=(short)java.lang.Integer.parseInt(args[a+1]);
          if (args[a].equalsIgnoreCase("-y")) DIM_Y=(short)java.lang.Integer.parseInt(args[a+1]);
          if (args[a].equalsIgnoreCase("-c")) color=
            255<<24+
            (java.lang.Integer.parseInt(args[a+1].substring(0,2),16))<<16+
            (java.lang.Integer.parseInt(args[a+1].substring(2,4),16))<<8+
            (java.lang.Integer.parseInt(args[a+1].substring(4,6),16));
          if (args[a].equalsIgnoreCase("-s"))
            if (args[a+1].equalsIgnoreCase("off"))
              cansave=false;
          if (args[a].equalsIgnoreCase("-savepath"))
            savepath=args[a+1];
      }catch(NumberFormatException e){
        System.err.println("Parameter '"+args[a]+" "+args[a+1]+"' is invalid, exiting.");
        System.exit(-1);
      }
      catch(ArrayIndexOutOfBoundsException e){
        System.err.println("Something is missing after "+args[a]+" switch, run with -help option to get help.");
        System.exit(-1);
      }

    }

System.out.println("PORT=" + PORT);
System.out.println("MAX=" + MAX);


    CURRENT=0;
    try{
      DIM_X-=RIGHT_MARGIN;
      DIM_Y-=BOTTOM_MARGIN;
      
      matrix=new int[DIM_X*DIM_Y];
      for (int i=0; i<matrix.length; i++)matrix[i]=color;

      sch = new SingleClientHandle[MAX];
      serverSocket = new ServerSocket(PORT);
      Thread thread=new Thread(this);
      //デーモンスレッドとする
      thread.setDaemon(true);
      thread.start();
      while( true ) {
        try {
          wksocket = serverSocket.accept();
          addClient(wksocket);
        }catch( SocketException e ) {
          System.err.println("Socket Error");
          wksocket.close();
          continue;
        }catch( IOException e ) {
          System.err.println("IO Error");
          wksocket.close();
          continue;
        }
      }
    }catch(IOException e){if(!runQuiet)System.out.println(e);}
  }

  // =============================================================================
  // Check current client number
  // =============================================================================
  synchronized void setCurrent(){
    CURRENT=0;
    for (int c=0; c<MAX; c++)
      if (sch[c]!=null) CURRENT++;
  }

  // =============================================================================
  // Cyclic ping sending and connection checking
  // =============================================================================
  synchronized void checkConnections(){
    setCurrent();
    for (int c=0; c<MAX; c++){
      if ((sch[c]!=null) && sch[c].finish==true){
        if (!runQuiet) System.out.println("** Number "+c+" hangs, disconnecting!");
        try{
          CURRENT--;
          sch[c].s.close();
          sch[c]=null;
        }catch(SocketException e){if (!runQuiet)System.out.println("**Socket error while closing socket "+e);}
        catch(IOException e){if (!runQuiet)System.out.println("**IO error while closing socket "+e);}
      } else if(sch[c]!=null){
       //通信確認
       sch[c].addObject("checkConnections");
      }
    }
  }

  // =============================================================================
  // Subthread calling checkConnections
  // =============================================================================
  public void run(){
    while (true){
      try{Thread.sleep(DELAY*1000);}catch(InterruptedException e){if (!runQuiet)System.out.println("**Hey, I'm sleeping! "+e);}
      checkConnections();
    }
  }

  // =============================================================================
  // Add (or refuse) new client
  // =============================================================================
  void addClient(Socket socket){
    int c=0;
    boolean flg=false;
    for (c=0; c<MAX; c++){
      if (sch[c]==null) {
        flg=true;
        break;
      }
    }
    if (!flg){
      try{
        socket.close();
      }catch(IOException ee){
        if (!runQuiet)System.out.println("Something wrong: "+ee);
      }
      return;
    }

    sch[c]=new SingleClientHandle(c,socket,this,runQuiet);
    if(!runQuiet) System.out.println(Server.hour()+"["+c+"] Connected from "+socket.getInetAddress().getHostAddress());

    setCurrent();
  }
}


// ===========================================================================
// ===========================================================================
class SingleClientHandle{
  volatile Vector v=null;     // Objects to send
  volatile int id;            // ID of this client
  volatile Socket s=null;     // socket
  volatile ObjectOutputStream oos=null;
  volatile ObjectInputStream ois=null;

  volatile String MedicalDepartmentName = null;
  volatile String Part = null;
  volatile String PatientNo=null;
  volatile String PictureDiscernment = null;

  volatile SingleSender sender;
  volatile SingleListener listener;
  Server serverlink=null;
  boolean finish=false;
  boolean runQuiet;

  // =============================================================================
  // Constructor
  // =============================================================================
  SingleClientHandle(int i, Socket socket, Server server,   boolean r){
    v=new Vector();
    runQuiet=r;
    id=i;
    s=socket;
    serverlink=server;
    try{
      ois=new ObjectInputStream(s.getInputStream());
      oos=new ObjectOutputStream(s.getOutputStream());
    }catch(IOException e){
      if (!runQuiet) System.out.println(Server.hour()+"["+id+"] Cannot get OO and OI streams, exiting. "+e);
      return;
    }
    sender=new SingleSender(oos,id, this,runQuiet);
    sender.start();
    listener=new SingleListener(ois,id, this,runQuiet);
    listener.start();
  }

  // =============================================================================
  // Add to send queue
  // =============================================================================
  synchronized void addObject(Object o){
    v.addElement(o);
  }

}

// ===========================================================================
// ===========================================================================
class SingleSender extends Thread{
  int id;
  boolean runQuiet;
  ObjectOutputStream oos=null;
  SingleClientHandle father=null;

  // =============================================================================
  // Constructor
  // =============================================================================
  SingleSender(ObjectOutputStream ooooss, int i, SingleClientHandle shc, boolean r){
    id=i;
    runQuiet=r;
    oos=ooooss;
    father=shc;
  }

  // =============================================================================
  // Sending responsible subthread
  // =============================================================================
  public void run(){
    try{
      if (!runQuiet) System.out.println(Server.hour()+"["+id+"] Sender: Sending archive packet");
      oos.writeObject(new Archive(father.serverlink.matrix,father.serverlink.DIM_X, father.serverlink.DIM_Y,Server.cansave));      
      oos.flush();
    }catch(IOException e){
      if (!runQuiet) System.out.println(Server.hour()+"["+id+"] Sender: Archive data sending error! "+e);
      father.finish=true;
    }

    while (!father.finish){
      while(father.v.isEmpty() && !father.finish){
        try{Thread.sleep(500);}catch(InterruptedException e){if (!runQuiet) System.out.println(Server.hour()+"["+id+"] Sender: Hey, I'm sleeping! "+e);}
      }
      if (!father.v.isEmpty()){
        try{
          Object a=father.v.firstElement();
          father.v.removeElementAt(0);
          oos.writeObject(a);
          oos.flush();

          //送信内容がEndSignalだったら終了
          if (a.toString().equalsIgnoreCase("endSignal") ) {
            System.out.println("Server Sender Get EndSignal");
            father.finish=true;
          }
        }catch(IOException e){
          if (!runQuiet) System.out.println(Server.hour()+"["+id+"] Sender: Could not send anything "+e);
          father.finish=true;
        }
      }
    }
    try{
      oos.close();
    }catch(IOException e){
      if (!runQuiet) System.out.println("IOException while closing OOS, ignoring "+e );
    }
    if (!runQuiet) System.out.println(Server.hour()+"["+id+"] Sender: Subthread ending");
  }
}


// ===========================================================================
// ===========================================================================
class SingleListener extends Thread{
  int id;
  boolean runQuiet;
  ObjectInputStream ois=null;
  SingleClientHandle father=null;

  // ===========================================================================
  // Constructor
  // =============================================================================
  SingleListener(ObjectInputStream ooiiss, int i, SingleClientHandle shc,  boolean r){
    ois=ooiiss;
    runQuiet=r;
    id=i;
    father=shc;
  }


  // ===========================================================================
  // Listen responsible thread
  // =============================================================================
  public void run(){
    Image img[];

    while (!father.finish){
      try{
        Object o=ois.readObject();

        //EndSignalを受け取ったら終了
        if (o.toString().equalsIgnoreCase("endSignal") ) {
            System.out.println("Server Listener Get EndSignal");

            //EndSignalをコミュニケ－タに送信
            father.addObject(o.toString());

            //senderが終了するまで待機
            try{
                father.sender.join();
            }catch(InterruptedException e){
                if (!runQuiet) System.out.println(Server.hour()+"["+id+"] Listener: While Sender join: "+e);
            }
        }

        if (o instanceof Archive){
        ((Archive)o).save(father.serverlink.savepath+File.separatorChar);
        }
      }catch(IOException e){if (!runQuiet) System.out.println(Server.hour()+
        "["+id+"] Listener: While reading got: "+e);
        father.finish=true;
      }
      catch(ClassNotFoundException e){
        if (!runQuiet) System.out.println(Server.hour()+"["+id+"] Listener: Strange class, trying to ignore: "+e);
      }
    }
    try{
      ois.close();
    }catch(IOException e){
      if (!runQuiet) System.out.println("IOException while closing OIS, ignoring "+e );
    }
    if (!runQuiet) System.out.println(Server.hour()+"["+id+"] Listener: ending");

  }
}

