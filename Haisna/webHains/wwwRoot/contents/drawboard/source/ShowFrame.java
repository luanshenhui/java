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

import java.awt.Frame;
import java.awt.image.*;
import java.awt.*;
import java.awt.event.*;


// =============================================================================
// =============================================================================
// Saved image window
// =============================================================================
// =============================================================================
public class ShowFrame extends Dialog {
    Image imgString; //文字
    Image imgDraw; //描画

  static boolean cansave=false;       // can server save the images?
    String MedicalDepartmentName=null;
    String Part=null;
    String PatientNo=null;
    String PictureDiscernment=null;

  // ===========================================================================
  // ===========================================================================
  class ExtraCanvas extends Canvas{
    Image img;

    ExtraCanvas(Image i){
      img=i;      
    }
    public void paint(Graphics g){
      g.drawImage(img,0,0,this);
    }
  }
  ExtraCanvas canvas; // Showed image


  // ===========================================================================
  // Constructor
  // =============================================================================
  ShowFrame(Frame owner, boolean modal, int x, int y, Image i, Image imgNewString, Image bgImage, String tytul, final Communicator commlink,
            String mdn,String part,String patientNo,String pd) {
    super(owner, tytul, modal);

    addWindowListener(new WindowAdapter(){        // handle window close
      public void windowClosing(WindowEvent e){
        dispose();
      }
    });

    canvas=new ExtraCanvas(i);

    imgString = imgNewString; //文字
    imgDraw = bgImage; //描画

    this.MedicalDepartmentName = mdn;
    this.Part = part;
    this.PatientNo = patientNo;
    this.PictureDiscernment = pd;

    canvas.setSize(x,y);
    add("North",canvas);

    java.awt.Button button=new java.awt.Button();
    java.awt.Button btnClose=new java.awt.Button(); //閉じるボタン

    if (cansave==true){
      if (Board.offline!=true){
        button.setLabel("Save image");
        button.setEnabled(true);
        btnClose.setLabel("close");
        btnClose.setEnabled(true);
      }else{
        button.setLabel("cannot save when connection is lost");
        button.setEnabled(false);
        btnClose.setLabel("close");
        btnClose.setEnabled(true);
      }
    }else{
      button.setLabel("image saving is disabled");
      button.setEnabled(false);
      btnClose.setLabel("close");
      btnClose.setEnabled(true);
    }

    button.addActionListener(new ActionListener(){

      // handle image saving:
      public void actionPerformed(ActionEvent e){

        //オブジェクト転送可能な形に変換を行う
        // grab pixels to array
        int[] pixels=new int[canvas.img.getWidth(null)*canvas.img.getHeight(null)];
        PixelGrabber pg = new PixelGrabber(canvas.img, 0, 0, canvas.img.getWidth(null),
          canvas.img.getHeight(null), pixels, 0, canvas.img.getWidth(null));
        try {
          pg.grabPixels();
        }

        catch (InterruptedException ee) {
          System.err.println("interrupted waiting for pixels.[ShowFrame.java:ShowFrame(Frame owner, boolean modal, int x, int y, Image i, Image imgNewString, Image bgImage, String tytul, final Communicator commlink,String mdn,String part,String patientNo,String pd)]");
          return;
        }
        if ((pg.getStatus() & ImageObserver.ABORT) != 0) {
          System.err.println("image fetch aborted or errored.[ShowFrame.java:ShowFrame(Frame owner, boolean modal, int x, int y, Image i, Image imgNewString, Image bgImage, String tytul, final Communicator commlink,String mdn,String part,String patientNo,String pd)]");
          return;
        }

        // and send it compressed to server
        //サーバへの保存前にイメージの圧縮を行う
        /* 文字 */
        int[] pixels2=new int[imgString.getWidth(null)*imgString.getHeight(null)];
        PixelGrabber pg2 = new PixelGrabber(imgString, 0, 0, imgString.getWidth(null),
          imgString.getHeight(null), pixels2, 0, imgString.getWidth(null));
        try {
          pg2.grabPixels();
        }
        catch (InterruptedException ee) {
          System.err.println("interrupted waiting for pixelsShowFrame.java:ShowFrame(Frame owner, boolean modal, int x, int y, Image i, Image imgNewString, Image bgImage, String tytul, final Communicator commlink,String mdn,String part,String patientNo,String pd");
          return;
        }
        if ((pg2.getStatus() & ImageObserver.ABORT) != 0) {
          System.err.println("image fetch aborted or erroredShowFrame.java:ShowFrame(Frame owner, boolean modal, int x, int y, Image i, Image imgNewString, Image bgImage, String tytul, final Communicator commlink,String mdn,String part,String patientNo,String pd");
          return;
        }
        
        /* 描画 */
        int[] pixels3=new int[imgDraw.getWidth(null)*imgDraw.getHeight(null)];
        PixelGrabber pg3 = new PixelGrabber(imgDraw, 0, 0, imgDraw.getWidth(null),
          imgDraw.getHeight(null), pixels3, 0, imgDraw.getWidth(null));
        try {
          pg3.grabPixels();
        }
        catch (InterruptedException ee) {
          System.err.println("interrupted waiting for pixelsShowFrame.java:ShowFrame(Frame owner, boolean modal, int x, int y, Image i, Image imgNewString, Image bgImage, String tytul, final Communicator commlink,String mdn,String part,String patientNo,String pd");
          return;
        }
        if ((pg3.getStatus() & ImageObserver.ABORT) != 0) {
          System.err.println("image fetch aborted or erroredShowFrame.java:ShowFrame(Frame owner, boolean modal, int x, int y, Image i, Image imgNewString, Image bgImage, String tytul, final Communicator commlink,String mdn,String part,String patientNo,String pd");
          return;
        }
        Archive arc=new Archive(pixels3,pixels2,pixels,(short)canvas.img.getWidth(null),(short)canvas.img.getHeight(null));
        arc.setMedicalDepartmentName(MedicalDepartmentName);
        arc.setPart(Part);
        arc.setPatientNo(PatientNo);
        arc.setPictureDiscernment(PictureDiscernment);
        if (Board.offline!=true){
          //Communicatorクラスを使用してサーバに画像を保存する
          commlink.send(arc);
          dispose();
        }

      }
    });

    btnClose.addActionListener(new ActionListener(){
      public void actionPerformed(ActionEvent e){
        dispose();
      }
    });

    add("Center",button);
    add("South",btnClose);

    this.setResizable(false);
    this.pack();
    this.show();
  }

}