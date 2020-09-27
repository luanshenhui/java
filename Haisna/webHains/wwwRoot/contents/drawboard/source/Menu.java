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

import java.awt.*;
import java.awt.event.*;
import java.net.*;
import java.io.*;
import java.applet.Applet;
import java.applet.AppletContext;

// =============================================================================
// =============================================================================
// Menu class
// =============================================================================
// =============================================================================
public class Menu extends Canvas implements MouseListener, MouseMotionListener{

  private Board boardlink;              // Link to blackboard
  private Applet appletlink;            // Link to applet
  private Communicator commlink;        // Link to communicator module
  private AppletContext appletcontext;  // Link to applet's context
  private Main parent;                  // Link to Main class

  Object mode=new Freehand();             // Initial draw mode
  private short thick=3;                  // Initial thick
  private short people=0;                 // Initial people counter

  private Button mouseover=null;        // Mouse at nothing at start

  // Declaration of buttons
  private Button btn_freehand, btn_line, btn_box, btn_fillbox, btn_circle, btn_fillcircle, btn_texttool;

  private Button btn_splay,btn_eraser;
  
  private Button thick_1,thick_2,thick_3,thick_4,thick_5,thick_6;
  private Button th_select1,th_select2,th_select3;
  private Button th_copy,th_show,th_delete;

  private Button reset,undo,help;

  private Button thumbnail_coord;   // pseudobutton, location of small image
  private int counter_x,counter_y;  // counter coords

  private Image normal=null;      // Normal menu image
  private Image bold=null;        // Bold (mouseover) menu image
  private Image light=null;       // Light (selected) menu image
  volatile MediaTracker tracker;  // Main image load tracker

  String str_light;
  String str_bold;
  String str_normal;

  int counterColor=Color.lightGray.getRGB();  // default counter color
  int emptyThColor=Color.lightGray.getRGB();  // default empty thumbnail color

  volatile Image[][] small=new Image[3][3];        // Three clipboards

  volatile private int thumbnail=0;      // Initial thumbnail
  volatile private int network_status=0; // Initial network status OFF

  volatile URL url1=null;

  // =============================================================================
  // Constructor
  // =============================================================================
  public Menu(URL url, Main m) {
    url1=url;
    parent=m;

    btn_freehand=new Button(0,0,50,50);  // draw mode
    btn_line=new Button(50,0,100,40);
    btn_box=new Button(0,50,50,95);
    btn_fillbox=new Button(50,40,100,85);
    btn_circle=new Button(0,95,50,140);
    btn_fillcircle=new Button(50,85,100,123);
    btn_texttool=new Button(50,123,100,153);

    btn_splay=new Button(0,140,50,185);
    btn_eraser=new Button(50,153,100,190);

    thick_1=new Button(0,190,65,204); // thick select
    thick_2=new Button(0,204,65,214);
    thick_3=new Button(0,214,65,225);
    thick_4=new Button(0,225,65,238);
    thick_5=new Button(0,238,65,250);
    thick_6=new Button(0,250,65,265);

    th_select1=new Button(0,280,15,280+20);     // clipboard select
    th_select2=new Button(0,280+20,15,280+40);
    th_select3=new Button(0,280+40,15,280+60);

    th_copy=new Button(75,280,100,280+20);      // clipboard operations
    th_show=new Button(75,280+20,100,280+40);
    th_delete=new Button(75,280+40,100,280+60);

    undo=new Button(67,204,96,238);
    reset=new Button(67,239,96,270);      // screen reset
    help=new Button(50,429,100,437);      // screen help

    thumbnail_coord=new Button(17,285,77,335);    //smallscreen

    counter_x=81;
    counter_y=160;

    str_light="menu_light.png"; // image files
    str_bold="menu_bold.png";
    str_normal="menu_normal.png";

    // load images...
    if (normal==null || bold==null || light==null){
      String prefix=url.getProtocol()+"://";
      try{
        URL url_light;
        URL url_bold;
        URL url_normal;
        if (url.getHost().equals("")){
          url_light=new URL(prefix+url.getHost()+url.getFile()+"skin/"+str_light);
          url_bold=new URL(prefix+url.getHost()+url.getFile()+"skin/"+str_bold);
          url_normal=new URL(prefix+url.getHost()+url.getFile()+"skin/"+str_normal);
        }else{
          url_light=new URL(prefix+url.getHost()+":"+url.getPort()+url.getFile()+"skin/"+str_light);
          url_bold=new URL(prefix+url.getHost()+":"+url.getPort()+url.getFile()+"skin/"+str_bold);
          url_normal=new URL(prefix+url.getHost()+":"+url.getPort()+url.getFile()+"skin/"+str_normal);
        }
        normal=Toolkit.getDefaultToolkit().getImage(url_normal);
        bold=Toolkit.getDefaultToolkit().getImage(url_bold);
        light=Toolkit.getDefaultToolkit().getImage(url_light);
        repaint();
      }catch (java.net.MalformedURLException e){
        System.out.println("Bad URL - menu image file invalid!");
      };

      // ... and wait for it
      tracker = new MediaTracker(this);
      tracker.addImage(normal, 0);
      tracker.addImage(bold, 1);
      tracker.addImage(light, 2);
    }
  };


  // =============================================================================
  public void setBgColor(int c){
    this.setBackground(new Color(c));
  }

  // =============================================================================
  public void setCounterColor(int c){
    counterColor=c;
  }

  // =============================================================================
  public void setEmptyThColor(int c){
    emptyThColor=c;
  }

  // =============================================================================
  // repaint routine
  // =============================================================================
  public void paint(Graphics g){
    if (normal!=null){
      g.drawImage(normal,0,0,this);
    };

    Button but=null;
    if (mode instanceof Freehand) but=btn_freehand;
    if (mode instanceof Line) but=btn_line;
    if (mode instanceof Box) but=btn_box;
    if (mode instanceof FillBox) but=btn_fillbox;
    if (mode instanceof Circle) but=btn_circle;
    if (mode instanceof FillCircle) but=btn_fillcircle;
    if (mode instanceof LetterBox) but=btn_texttool;

    if (mode instanceof Splay) but=btn_splay;   //スプレー（格子）
    if (mode instanceof Eraser) but=btn_eraser;   //消しゴム

    g.drawImage(light,but.x1,but.y1,but.x2,but.y2,but.x1,but.y1,but.x2,but.y2,this);

    // highlight button other than current
    if (!but.equals(mouseover) && mouseover!=null){
      g.drawImage(bold,mouseover.x1,mouseover.y1,mouseover.x2,mouseover.y2,
        mouseover.x1,mouseover.y1,mouseover.x2,mouseover.y2,this);
    }

    // bold current thickness
    if (thick==1) but=thick_1;
    if (thick==2) but=thick_2;
    if (thick==3) but=thick_3;
    if (thick==4) but=thick_4;
    if (thick==5) but=thick_5;
    if (thick==6) but=thick_6;
    g.drawImage(light,but.x1,but.y1,but.x2,but.y2,but.x1,but.y1,but.x2,but.y2,this);

    // bold current clipboard number
    int y1=0;int y2=0;
    if (thumbnail==0)
      g.drawImage(light,
        th_select1.x1,th_select1.y1,th_select1.x2,th_select1.y2,
        th_select1.x1,th_select1.y1,th_select1.x2,th_select1.y2,
      this);
    if (thumbnail==1)
      g.drawImage(light,
        th_select2.x1,th_select2.y1,th_select2.x2,th_select2.y2,
        th_select2.x1,th_select2.y1,th_select2.x2,th_select2.y2,
      this);
    if (thumbnail==2)
      g.drawImage(light,
        th_select3.x1,th_select3.y1,th_select3.x2,th_select3.y2,
        th_select3.x1,th_select3.y1,th_select3.x2,th_select3.y2,
      this);

    // draw selected clipboard, if exist
    if (small[thumbnail][0]!=null){
      g.drawImage(small[thumbnail][0],
        thumbnail_coord.x1,thumbnail_coord.y1,thumbnail_coord.x2-thumbnail_coord.x1,thumbnail_coord.y2-thumbnail_coord.y1,
      this);
    }else{
      g.setColor(new Color(emptyThColor));
      g.fillRect(thumbnail_coord.x1,thumbnail_coord.y1,
        thumbnail_coord.x2-thumbnail_coord.x1,thumbnail_coord.y2-thumbnail_coord.y1);
    }
  }

  // =============================================================================
  public void update(Graphics g){
    paint(g);
  }

  // =============================================================================
  // make a link to blackboard
  // =============================================================================
  public void setBoard(Board bb){
    boardlink=bb;
  }

  // =============================================================================
  // make link to applet
  // =============================================================================
  public void setApplet(Applet aa){
    appletlink=aa;
  }

  // =============================================================================
  // make link to communicator
  // =============================================================================
  public void setCommunicator(Communicator c){
    commlink=c;
  }

  // =============================================================================
  // make link to applet context
  // =============================================================================
  public void setAppletContext(AppletContext aa){
    appletcontext=aa;
  }

  // =============================================================================
  // set new value of people counter
  // =============================================================================
  public void setPeople(short i){
    people=i;
    repaint();
  }

  // =============================================================================
  // set new value of people counter
  // =============================================================================
  public short getThick(){
    return thick;
  }

  // =============================================================================
  // mouse exited
  // =============================================================================
  public void mouseExited(MouseEvent e){
    mouseover=null;
    repaint();
  };

  // =============================================================================
  // Network status indicator
  // =============================================================================
  public void setNetworkStatus(int i){
    network_status=i;
    repaint();
    // 0 - OFF
    // 1 - ON
    // 2 - TRANSFER
  };

  // =============================================================================
  synchronized public void saveThumbnail(int nr){
    /* 合成イメージ */
    small[nr][0]=createImage(boardlink.DIM_X,boardlink.DIM_Y);
    Graphics gg=small[nr][0].getGraphics();
    parent.imgComposit.flush();
    gg.drawImage(parent.imgComposit,0,0,boardlink.DIM_X,boardlink.DIM_Y,parent);
    
    /* 文字イメージ */
    small[nr][1]=createImage(boardlink.DIM_X,boardlink.DIM_Y);
    Graphics gg2=small[nr][1].getGraphics();
    parent.imgString.flush();
    gg2.drawImage(parent.imgString,0,0,boardlink.DIM_X,boardlink.DIM_Y,parent);
    
    /* 描画イメージ */
    small[nr][2]=createImage(boardlink.DIM_X,boardlink.DIM_Y);
    Graphics gg3=small[nr][2].getGraphics();
    parent.imgDraw.flush();
    gg3.drawImage(parent.imgDraw,0,0,boardlink.DIM_X,boardlink.DIM_Y,parent);
  }

  // =============================================================================
  // mouse moved
  // =============================================================================
  public void mouseMoved(MouseEvent e){
    int x=e.getX();
    int y=e.getY();
    Button oldmouseover=mouseover;

    mouseover=null;
    if (btn_line.hit(x,y)) mouseover=btn_line;
    if (btn_freehand.hit(x,y)) mouseover=btn_freehand;
    if (btn_box.hit(x,y)) mouseover=btn_box;
    if (btn_fillbox.hit(x,y)) mouseover=btn_fillbox;
    if (btn_circle.hit(x,y)) mouseover=btn_circle;
    if (btn_fillcircle.hit(x,y)) mouseover=btn_fillcircle;
    if (btn_texttool.hit(x,y)) mouseover=btn_texttool;

    if (btn_splay.hit(x,y)) mouseover=btn_splay;
    if (btn_eraser.hit(x,y)) mouseover=btn_eraser;
    
    if (thick_1.hit(x,y))mouseover=thick_1;
    if (thick_2.hit(x,y))mouseover=thick_2;
    if (thick_3.hit(x,y))mouseover=thick_3;
    if (thick_4.hit(x,y))mouseover=thick_4;
    if (thick_5.hit(x,y))mouseover=thick_5;
    if (thick_6.hit(x,y))mouseover=thick_6;
    if (th_select1.hit(x,y))mouseover=th_select1;
    if (th_select2.hit(x,y))mouseover=th_select2;
    if (th_select3.hit(x,y))mouseover=th_select3;
    if (th_copy.hit(x,y))mouseover=th_copy;

    if (th_show.hit(x,y) && small[thumbnail][0]!=null)mouseover=th_show;
    if (th_delete.hit(x,y) && small[thumbnail][0]!=null)mouseover=th_delete;
    if (reset.hit(x,y))mouseover=reset;
    if (undo.hit(x,y))mouseover=undo;
    if (help.hit(x,y))mouseover=help;
    if (mouseover!=null && !mouseover.equals(oldmouseover) ){ // new button focus
      if (oldmouseover==null)oldmouseover=mouseover;
      repaint(
        Math.min(mouseover.x1,oldmouseover.x1),
        Math.min(mouseover.y1,oldmouseover.y1),
        Math.abs(Math.max(mouseover.x2,oldmouseover.x2)-Math.min(mouseover.x1,oldmouseover.x1)),
        Math.abs(Math.max(mouseover.y2,oldmouseover.y2)-Math.min(mouseover.y1,oldmouseover.y1))
      );
    }
    else if(oldmouseover!=null && mouseover==null){ // focus lost
      repaint(oldmouseover.x1,oldmouseover.y1,oldmouseover.x2,oldmouseover.y2);
    }
  };

  // =============================================================================
  public void mouseEntered(MouseEvent e){};

  // =============================================================================
  public void mousePressed(MouseEvent e){};

  // =============================================================================
  public void mouseReleased(MouseEvent e){};

  // =============================================================================
  public void mouseDragged(MouseEvent e){};

  // =============================================================================
  // mouse clicked
  // =============================================================================
  public void mouseClicked(MouseEvent e){
    if (e.getModifiers()==e.BUTTON1_MASK){
      int x=e.getX();
      int y=e.getY();

      if (btn_line.hit(x,y)) mode=new Line();
      if (btn_freehand.hit(x,y)) mode=new Freehand();
      if (btn_box.hit(x,y)) mode=new Box();
      if (btn_fillbox.hit(x,y)) mode=new FillBox();
      if (btn_circle.hit(x,y)) mode=new Circle();
      if (btn_fillcircle.hit(x,y)) mode=new FillCircle();
      if (btn_texttool.hit(x,y)) mode=new LetterBox();

      if (btn_splay.hit(x,y)) mode=new Splay();
      if (btn_eraser.hit(x,y)) mode=new Eraser();
      
      if (thick_1.hit(x,y)) thick=1;
      if (thick_2.hit(x,y)) thick=2;
      if (thick_3.hit(x,y)) thick=3;
      if (thick_4.hit(x,y)) thick=4;
      if (thick_5.hit(x,y)) thick=5;
      if (thick_6.hit(x,y)) thick=6;
      if (th_select1.hit(x,y)) thumbnail=0;
      if (th_select2.hit(x,y)) thumbnail=1;
      if (th_select3.hit(x,y)) thumbnail=2;

      if (th_copy.hit(x,y)){
        saveThumbnail(thumbnail);
      }

      if (th_delete.hit(x,y)){
        small[thumbnail][0]=null;   //合成イメージ
        small[thumbnail][1]=null;   //文字イメージ
        small[thumbnail][2]=null;   //描画イメージ
      }

      if (th_show.hit(x,y)){
        int X=boardlink.DIM_X;
        int Y=boardlink.DIM_Y;
        Container pContainer = this.getParent();
        while(!(pContainer instanceof Frame))
          pContainer = pContainer.getParent();
        if (small[thumbnail][0]!=null){
          ShowFrame sf=new ShowFrame((Frame)pContainer, true,
            X,Y,small[thumbnail][0],small[thumbnail][1],small[thumbnail][2], "Saved image number "+(thumbnail+1), commlink,
            parent.MedicalDepartmentName,parent.Part,parent.PatientNo,parent.PictureDiscernment
            );            
        }
      }

      if (reset.hit(x,y)){
        boardlink.reset_board();
      }

      if (undo.hit(x,y)){
        boardlink.undo_board(small[thumbnail][1],small[thumbnail][2]);
      }

      if (help.hit(x,y)){
          URL urlHelp=null;
          String prefix=url1.getProtocol()+"://";
          
          try {
              urlHelp = new URL(prefix+url1.getHost()+url1.getFile()+"help/"+"drawboard-doc.html");
              
          }catch(MalformedURLException ee) {}

          parent.getAppletContext().showDocument(urlHelp,"new");
  
      }

      repaint();
    };
  }

  // =============================================================================
  // =============================================================================
  static String substring(String str, int number){
    str=str.trim();
    str=removeTwoSpaces(str);
    int start=0;
    for (int i=0; i<number; i++){
      start=str.indexOf(" ",start+1);
      if (start<0) return null;
    }

    int end=0;
    end=str.indexOf(" ",start+1);
    if (end<=0) end=str.length();

    if (str.charAt(start)==' ') start++;
    return str.substring(start,end);
  }

  // =============================================================================
  public static String removeTwoSpaces (String str){
    if (str == null) return(null);
    char[] tempArray = new char[str.length()];
    int j = 0;
    if (!(str.charAt(0) == ' ' && str.charAt(1)==' ')){
      tempArray[j] = str.charAt(0);
      j++;
    }
    for (int i = 1; i < str.length(); i++){
      if (!(str.charAt(i) == ' ' && str.charAt(i-1)==' ')){
        tempArray[j] = str.charAt(i);
        j++;
      }
    }
    return(new String(tempArray, 0, j));
  }

}

// =============================================================================
// =============================================================================
// Button class
// =============================================================================
// =============================================================================
class Button{
  int x1,y1,x2,y2;

  // =============================================================================
  // constructor
  // =============================================================================
  Button(int xx1, int yy1, int xx2, int yy2){
    x1=xx1;x2=xx2;
    y1=yy1;y2=yy2;
  }

  // =============================================================================
  // is (x,y) point inside button?
  // =============================================================================
  public boolean hit(int x, int y){
    if (x1<=x && x<=x2 && y1<=y && y<=y2) return true;
    return false;
  }
}

