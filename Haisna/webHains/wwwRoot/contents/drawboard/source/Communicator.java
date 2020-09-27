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
import java.awt.Color;

// =============================================================================
// =============================================================================
public class Communicator extends Thread {
  private volatile Board table=null;  // link to blackboard
  volatile Menu menu=null;            // link to menu
  private volatile Main parent=null;  // link to parent

  private volatile String host=null;  // name of host
  private volatile int port;          // port number
  private volatile Socket s=null;     // communication socket
  volatile ObjectOutputStream oos=null;   // oos
  volatile ObjectInputStream ois=null;    // ois

  volatile boolean communicatorclosing=false;   // true if closing comm module
  Sender sender=null;                           // subthread
  Thread th;

    private volatile String MedicalDepartmentName=null; //診療科名
    private volatile String Part=null;                  //部位
    private volatile String PatientNo=null;             //患者番号
    private volatile String PictureDiscernment=null;    //画像識別子
    
  // =============================================================================
  // Constructor
  // =============================================================================
  public Communicator(Board b, URL u, Menu m, int p, Main par) {
    parent=par;
    table=b;
    menu=m;
    if (u.getHost().equals(""))
      host=null;
    else
      host=u.getHost();
    port=p;
  }

  // =============================================================================
  public void setMedicalDepartmentName(String mdn){
      this.MedicalDepartmentName = mdn;
  }

  // =============================================================================
  public void setPart(String part){
      this.Part = part;
  }

  // =============================================================================
  public void setPatientNo(String patientNo){
      this.PatientNo = patientNo;
  }

  // =============================================================================
  public void setPictureDiscernment(String pd){
      this.PictureDiscernment = pd;
  }


  // =============================================================================
  // Connect to remote host
  // =============================================================================
  synchronized void connect(){
    oos=null;
    ois=null;
    menu.setNetworkStatus(0);
    while (oos==null || ois==null){
      System.out.println("Connecting to server");
      table.setCursorAndSentence(true, "Connecting to server");
      try{
        s=null;
        s=new Socket(host,port);
      }catch(IOException e){
        table.setCursorAndSentence(true, "Connect to server failed, pausing 5 seconds");
        try{Thread.sleep(5000);}catch(InterruptedException ee){System.out.println("**What?? I'm sleeping! "+ee);};
      }
      try{
        oos=new ObjectOutputStream(s.getOutputStream());
        ois=new ObjectInputStream(s.getInputStream());
      }catch(NullPointerException e){
      }catch(IOException e){
        parent.Maximum = false;
        table.setCursorAndSentence(true, "Maximum client number reached. Waiting 15 seconds");
        try{Thread.sleep(15000);}catch(InterruptedException ee){System.out.println("**What?? I'm sleeping! "+ee);};

      }
    }
    menu.setNetworkStatus(1);

    // Got connection, rut sender thread
    sender=new Sender(this);
    th=new Thread(sender);
    th.start();

    return;
  }

  // =============================================================================
  // Add object to outgoing queue
  // =============================================================================
  void send(Object o){
    sender.addToQueue(o);
    return;
  }

  // =============================================================================
  // Receiveing subthread
  // =============================================================================
  public void run(){
    if (host==null){
      System.out.println("**Applet loaded from local file, not remote server");
      System.out.println("**Network communication disabled");
      table.network_disabled=true;
      return;
    }

    connect();

    //send(new PictureTokenizer(this.MedicalDepartmentName, this.Part, this.PatientNo, this.PictureDiscernment));

    while (!communicatorclosing){
      try{
        menu.setNetworkStatus(1);
        Object a=ois.readObject();

        //通信確立したら
        if (!parent.startFlg){
           parent.startFlg=true;
        }

        //終了シグナルを受け取ったら終了
        if (a.toString().equalsIgnoreCase("endSignal") ){
            System.out.println("Communicator Get EndSignal");
            communicatorclosing=true;
            continue;
        }


        if (a instanceof Archive){
          if ( (((Shape)a).getID())==parent.ID) continue;

          table.setCursorAndSentence(false, null); // First transfer OK

          // process information about image saving possibility
          if (((Archive)a).savingenabled==true) ShowFrame.cansave=true;

          // If server image size is inadequate, disconnect and disable network communication
          if (((Archive)a).DIM_X!=table.DIM_X || ((Archive)a).DIM_Y!=table.DIM_Y){
            communicatorclosing=true;
            table.setCursorAndSentence(false, "Wrong server image size, see doc for details");
            System.out.println("Server image size invalid");
            System.out.println("Local image size: "+table.DIM_X+"x"+table.DIM_Y);
            System.out.println("Remote image size: "+((Archive)a).DIM_X+"x"+((Archive)a).DIM_Y);
            continue;
          }
        }
      }catch (IOException e){
        System.out.println("IO Exception in second thread: "+e);
        if (!communicatorclosing) connect();
      }
      catch (ClassNotFoundException e){System.out.println("Received something unreadable: "+e);}
    }

    //sender終了させる
    send("senderEndSignal");
    try{
      //senderが終了するまで待機
      th.join();
    }catch(InterruptedException e){
      System.out.println("While Sender Join: "+e);
    }

    menu.setNetworkStatus(0);
    table.network_disabled=true;
    try{
      if (ois!=null) ois.close();
      if (oos!=null) oos.close();
      if (s!=null) s.close();
    }catch(SocketException e){System.out.println("**Socket error while stopping communicator "+e);}
    catch(IOException e){System.out.println("**IO error while while stopping communicator "+e);}
  }


  // =============================================================================
  // Help method, for debugging only; author: dimitri@dima.dhs.org, http://dima.dhs.org/
  // returns approximation of Object size
  // =============================================================================
  public static int getSize(Object object) {
      int size = -1;
      try {
          ByteArrayOutputStream bo = new ByteArrayOutputStream();
          ObjectOutputStream oo = new ObjectOutputStream(bo);
          oo.writeObject(object);
          oo.close();
          size = bo.size();
      } catch(Exception e) {
          System.out.println("oops:" + e);
      }
      return size;
  }

  // =============================================================================
  // Developer help method, converts AWT.Color to integer
  // =============================================================================
  public static int color2int(Color c){
    return c.getRGB();
  }
}


// =============================================================================
// =============================================================================
class Sender implements Runnable{
  Communicator com=null;  // link to communicator
  volatile Vector v;      // array of items to transmit
  boolean senderclosing=false;   // true if closing Sender module

  // =============================================================================
  // Constructor
  // =============================================================================
  Sender(Communicator c){
    com=c;
    v=new Vector(5);
  }

  // =============================================================================
  // Sending subthread
  // =============================================================================
  public void run(){
    while (!senderclosing){
      com.menu.setNetworkStatus(1);
      while(v.isEmpty()){
        try{
          Thread.sleep(500);
        }catch(InterruptedException e){
          System.out.println("**Hey, I'm sleeping! "+e);
        }
      }

      com.menu.setNetworkStatus(2);
      if (v.firstElement().toString().equalsIgnoreCase("senderEndSignal") ) {
         //送信内容がsenderEndSignalだったら送信せずに終了
         System.out.println("Sender Get EndSignal");
         senderclosing=true;
      }else{
         //サーバに送信
        try{
          com.oos.writeObject(v.firstElement());
          com.oos.flush();
          v.removeElementAt(0);
        }catch(IOException e){
          System.out.println("Connection lost, some elements too :"+e);
          v.removeAllElements();
          com.connect();
        }
      }
    }
  };

  // =============================================================================
  // Add to outgoing queue
  // =============================================================================
  void addToQueue(Object o){
    v.addElement(o);
  }
}