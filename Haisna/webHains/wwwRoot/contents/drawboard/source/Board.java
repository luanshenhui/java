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

import java.awt.Canvas;
import java.awt.*;
import java.applet.Applet;
import java.awt.event.*;
import java.awt.image.*;
import java.util.*;


// =============================================================================
// =============================================================================
public class Board implements MouseListener, MouseMotionListener, KeyListener, FocusListener{
  short DIM_X;          // canvas width
  short DIM_Y;          // canvas heigth

  private Object element;   // current draw element (line, circle, etc.)
  String sentence;  // information sequence

  private Main parent=null;                 // link to Main object
  private Communicator comm=null;           // Link to communicator
  private ColorPicker colorpicker=null;     // link to ColorPicker
  private Menu me;                          // link to menu

  private boolean outbound;                 // true, if cursor is out canvas
  boolean network_disabled=false;           // true if applet opened from local file
  static boolean offline=true;             // true if not connected at the moment
  private short mousekey=0;                 // which mouse key pressed

//Hoso
    String moji="";
    int cnt;
//Hoso

  // =============================================================================
  // Constructor
  // =============================================================================
  public Board(short XX, short YY, Main p) {
    parent=p;
    DIM_X=XX;
    DIM_Y=YY;
    int color=Color.blue.getRGB();
  }

  // ===========================================================================
  // Repaint the Board
  // =============================================================================
  public void paint(Graphics g){

    // double buffering
    System.arraycopy(parent.matrix,0,parent.matrix2,0,parent.matrix.length);
    if ((!outbound)&&(element!=null)){
      draw(element,parent.matrix2);
    }

    if (network_disabled && sentence==null)sentence="WARNING: Network communication disabled, see doc for details";
    if (sentence!=null){
      //サーバーに接続できない
      parent.connectServer = false; //サーバーコネクト判断:NG
      parent.paint(g);
    }else{
      parent.connectServer = true;  //サーバーコネクト判断:OK
      colorpicker.setVisible(true);
      me.setVisible(true);
      
      
      if (parent.readCompleate) {
       //文字イメージ
       parent.imgString.flush();
       parent.offGcomposit.drawImage(parent.imgString, 0, 0, DIM_X, DIM_Y, null);
       //描画イメージ        
       parent.imgDraw.flush();
       parent.offGcomposit.drawImage(parent.imgDraw, 0, 0, DIM_X, DIM_Y, null);
       //部位イメージ
       parent.offGcomposit.drawImage(parent.imgPattern, 0, 0, DIM_X, DIM_Y, null);
       //合成イメージ
       parent.imgComposit.flush();
       g.drawImage(parent.imgComposit, 0, 0, DIM_X, DIM_Y, null);
      }
    }

  }

  // =============================================================================
  public void update(Graphics g){
        parent.imgComposit.flush();
        g.drawImage(parent.imgComposit, 0, 0, DIM_X, DIM_Y, null);
  }

  // ===========================================================================
  // Draw element
  // =============================================================================
  void draw(Object element, int[] mat){
    ((Shape)element).draw(mat, DIM_X);
  }


  // ===========================================================================
  // Makes links between Board and ColorPicker/Menu
  // =============================================================================
  void setLinks(ColorPicker c, Menu m, Communicator com){
    comm=com;
    colorpicker=c;
    me=m;
  }

  // ===========================================================================
  // Returns current draw mode
  // =============================================================================
  Object current_mode(){
    Object ret=null;
    try{
      ret=me.mode.getClass().newInstance();
    }catch(Exception e){System.out.println("Reinitialize of element failed: "+e);}
    return ret;
  }

  // ===========================================================================
  // Returns current thickness
  // =============================================================================
  short current_thick(){
    return me.getThick();
  }

  // ===========================================================================
  // Returns current color
  // =============================================================================
  int current_color(){
    return colorpicker.current.getRGB();
  }

  // =============================================================================
  // Set the WAIT cursor on and off
  // =============================================================================
  void setCursorAndSentence(boolean b, String s){
    sentence=s;
    offline=b;
    if (b){
      parent.setCursor(new Cursor(Cursor.WAIT_CURSOR));
    }else{
      parent.setCursor(new Cursor(Cursor.CROSSHAIR_CURSOR));
    }
  }


  // ===========================================================================
  // Resets board
  // =============================================================================
  void reset_board(){
    
    //文字イメージ消去
    parent.offGstring.setColor(Color.white);
    parent.offGstring.fillRect(0,0,DIM_X,DIM_Y);

    //描画イメージ消去
    int color=Color.black.getRGB();
    for (int i=0; i<parent.matrix.length; i++)parent.matrix[i]=color;

    //バックカラー黒色を透過
    StringTokenizer strtoken = new StringTokenizer("000000", "|");
    Color[] thruColor = new Color[strtoken.countTokens()];
    for (int i = 0; strtoken.hasMoreTokens(); i++) {
        thruColor[i] = new Color(Integer.parseInt(strtoken.nextToken(), 16));
    }
    ImageFilter flt = new CthruFilter(thruColor, parent.range, parent.rate);

    MemoryImageSource drawSource=new MemoryImageSource(DIM_X,DIM_Y, ColorModel.getRGBdefault(), parent.matrix, 0, DIM_X);
    Image imgDraw = Toolkit.getDefaultToolkit().createImage(drawSource);
    
    ImageProducer bgproducer = new FilteredImageSource(imgDraw.getSource(), flt);
    Image tmpImg = Toolkit.getDefaultToolkit().createImage(bgproducer);
    PixelGrabber pg = new PixelGrabber(tmpImg, 0, 0,   
                                                    DIM_X, 
                                                    DIM_Y, 
                                                    parent.matrix, 0, DIM_X);
    try {
        boolean bl = pg.grabPixels();
    }
    catch (InterruptedException ee) {
        System.err.println("interrupted waiting for pixels.[Board.java:reset_board()]");
    }
                    
    if ((pg.getStatus() & ImageObserver.ABORT) != 0) {
        System.err.println("image fetch aborted or errored.[Board.java:reset_board()]");
    }
    bgproducer = null;
    tmpImg = null;
    pg = null;

}

  // ===========================================================================
  // Undo board
  // =============================================================================
  void undo_board(Image imgString, Image imgDraw){

    //バックカラー黒色を透過
    StringTokenizer strtoken = new StringTokenizer("000000", "|");
    Color[] thruColor = new Color[strtoken.countTokens()];
    for (int i = 0; strtoken.hasMoreTokens(); i++) {
        thruColor[i] = new Color(Integer.parseInt(strtoken.nextToken(), 16));
    }
    ImageFilter flt = new CthruFilter(thruColor, parent.range, parent.rate);

    //imgString:文字イメージ imgDraw:描画イメージ
    if (imgString!=null && imgDraw!=null){
        // 文字イメージ
        parent.offGstring.drawImage(imgString, 0, 0, DIM_X, DIM_Y, null);

        // 描画イメージ
        ImageProducer producer = new FilteredImageSource(imgDraw.getSource(), flt);
        imgDraw = Toolkit.getDefaultToolkit().createImage(producer);

        flt = null;
        producer = null;
        
        int[] pixels=new int[imgDraw.getWidth(null)*imgDraw.getHeight(null)];
        PixelGrabber pg = new PixelGrabber(imgDraw, 0, 0, imgDraw.getWidth(null),
          imgDraw.getHeight(null), pixels, 0, imgDraw.getWidth(null));
        try {
          pg.grabPixels();
        }
        catch (InterruptedException ee) {
          System.err.println("interrupted waiting for pixels.[Board.java:undo_board(Image imgString, Image imgDraw)]");
          return;
        }
        if ((pg.getStatus() & ImageObserver.ABORT) != 0) {
          System.err.println("image fetch aborted or errored.[Board.java:undo_board(Image imgString, Image imgDraw)]");
          return;
        }
        System.arraycopy(pixels,0,parent.matrix,0,pixels.length);
        
    }else{
        // 文字イメージ
        parent.offGstring.setColor(Color.white);
        parent.offGstring.fillRect(0,0,DIM_X,DIM_Y);

        //描画イメージ消去
        int color=Color.black.getRGB();
        for (int i=0; i<parent.matrix.length; i++)parent.matrix[i]=color;

        MemoryImageSource drawSource=new MemoryImageSource(DIM_X,DIM_Y, ColorModel.getRGBdefault(), parent.matrix, 0, DIM_X);
        Image imgNewDraw = Toolkit.getDefaultToolkit().createImage(drawSource);
        
        ImageProducer bgproducer = new FilteredImageSource(imgNewDraw.getSource(), flt);
        Image tmpImg = Toolkit.getDefaultToolkit().createImage(bgproducer);
        PixelGrabber pg = new PixelGrabber(tmpImg, 0, 0,   
                                                        DIM_X, 
                                                        DIM_Y, 
                                                        parent.matrix, 0, DIM_X);
        try {
            boolean bl = pg.grabPixels();
        }
        catch (InterruptedException ee) {
            System.err.println("interrupted waiting for pixels.[Board.java:undo_board(Image imgString, Image imgDraw)]");
        }
                        
        if ((pg.getStatus() & ImageObserver.ABORT) != 0) {
            System.err.println("image fetch aborted or errored.[Board.java:undo_board(Image imgString, Image imgDraw)]");
        }
        bgproducer = null;
        tmpImg = null;
        pg = null;
    }
  }

  public void focusLost(FocusEvent e){}
  public void focusGained(FocusEvent e){
    parent.requestFocus();
  }

  public void keyReleased(KeyEvent e){}
  public void keyPressed(KeyEvent e){}
  public void keyTyped(KeyEvent e){
    if (!outbound){
      if (current_mode() instanceof LetterBox){

        int iChar = e.getKeyChar();

        if (iChar > 31) {
            moji = moji + String.valueOf((char)e.getKeyChar());
            if (moji!="") {
                parent.offGstring.setColor(colorpicker.current);
                parent.offGstring.drawString(moji, (short)(((LetterBox)element).x2), (short)(((LetterBox)element).y2));
                // ... and move texttool cursor
                int iKeyChar = e.getKeyChar();
                if (iKeyChar > 256) {
                    ((LetterBox)element).setx2y2(
                    (short)(((LetterBox)element).x2+2+12),
                    ((LetterBox)element).y2);
                } else {
                    ((LetterBox)element).setx2y2(
                    (short)(((LetterBox)element).x2+2+Alphabet.getWidth(e.getKeyChar())),
                    ((LetterBox)element).y2);
                }
                moji="";
            }
        }
      }
    }
  }

  // =============================================================================
  public void mouseExited(MouseEvent e){
    outbound=true;
  }
  // =============================================================================
  public void mouseEntered(MouseEvent e){
    outbound=false;

    // LetterBox is initialized on enter, not click
    if (current_mode() instanceof LetterBox){
      element=current_mode();
      ((Shape)element).init((short)e.getX(),(short)e.getY(),current_color(), current_thick(),(short)e.getX(),(short)e.getY());
      parent.requestFocus();
    }else if (current_mode() instanceof Eraser){    //消しゴム
      element=current_mode();
      ((Shape)element).init((short)e.getX(),(short)e.getY(),current_color(), (short)0,(short)e.getX(),(short)e.getY());
      parent.requestFocus();
    }else{
      element=null;
    }
  }

  // =============================================================================
  public void mouseClicked(MouseEvent e){}

  // =============================================================================
  public void mouseMoved(MouseEvent e){
    // texttool watches mousemove, not only mousedrag
    if (element instanceof LetterBox){
      ((Shape)element).init((short)e.getX(),(short)e.getY(),current_color(), current_thick(),(short)e.getX(),(short)e.getY());
    }
    if (element instanceof Eraser){
      ((Shape)element).init((short)e.getX(),(short)e.getY(),current_color(), (short)0,(short)e.getX(),(short)e.getY());

    }
    
  }


  // ===========================================================================
  // Handle mouse press
  // =============================================================================
  public void mousePressed(MouseEvent e){
    boolean stateChanged=false;
    if (mousekey==0){
      if (e.getModifiers()==e.BUTTON1_MASK){
        mousekey=1;
        stateChanged=true;
      }
      else
        mousekey=2;
    }

    if (mousekey==1 && stateChanged){
      element=current_mode();
      ((Shape)element).init((short)e.getX(),(short)e.getY(),current_color(), current_thick(),(short)e.getX(),(short)e.getY());
    }

    if (mousekey==1 && element instanceof LetterBox){
      ((Shape)element).setx2y2((short)e.getX(),(short)e.getY());
    }

    if (mousekey==1 && element instanceof Eraser){        
      //描画イメージ  
      ((Shape)element).init((short)e.getX(),(short)e.getY(),current_color(), (short)1,(short)e.getX(),(short)e.getY());
      ((Shape)element).setx2y2((short)e.getX(),(short)e.getY());
      draw(element,parent.matrix);

      //文字イメージ
      int x=e.getX()-2;
      int y=e.getY()-7;
      parent.offGstring.setColor(Color.white);
      parent.offGstring.fillRect(x,y,6,13);      
      
    }

    if (mousekey==2){
      colorpicker.setNewColor(parent.matrix[e.getY()*DIM_X+e.getX()]);
    }

  }

  // ===========================================================================
  // Handle mouse drag
  // =============================================================================
  public void mouseDragged(MouseEvent e){

    if (mousekey==1){
      // This code cannot be placed in mouseExited and mouseEntered because of IE JVM bug
      if (e.getX()<0 || e.getX()>DIM_X || e.getY()<0 || e.getY()>DIM_Y){
        outbound=true;
      }else{
        outbound=false;
      }

      if (element instanceof Freehand) {  // Freehand is special mode because of limited element capacity...
        if (((Freehand)element).nextxy((short)e.getX(),(short)e.getY())){
          draw(element,parent.matrix);
          element=new Freehand((short)e.getX(),(short)e.getY(),current_color(), current_thick());
          ((Freehand)element).init ((short)e.getX(),(short)e.getY(),current_color(), current_thick(),(short)e.getX(),(short)e.getY());
        }
      }
      else if (element instanceof Eraser) {
            //描画イメージ
            ((Shape)element).init((short)e.getX(),(short)e.getY(),current_color(), (short)1,(short)e.getX(),(short)e.getY());
            ((Shape)element).setx2y2((short)e.getX(),(short)e.getY());
            draw(element,parent.matrix);
            //文字イメージ
            int x=e.getX()-2;
            int y=e.getY()-7;
            parent.offGstring.setColor(Color.white);
            parent.offGstring.fillRect(x,y,6,13);
      }
      else if ((!outbound)&&(element!=null)){
            ((Shape)element).setx2y2((short)e.getX(),(short)e.getY());
      }
      else if ((outbound)&&(element!=null)){
          if (e.getX()<0 || e.getX()>DIM_X){
            ((Shape)element).setx2y2((short)DIM_X,(short)e.getY());
          }else if (e.getY()<0 || e.getY()>DIM_Y){
            ((Shape)element).setx2y2((short)e.getX(),(short)DIM_Y);
          }
      }
    }

    if (mousekey==2)
      if (e.getX()>=0 && e.getX()<DIM_X && e.getY()>=0 && e.getY()<DIM_Y)
        colorpicker.setNewColor(parent.matrix[e.getY()*DIM_X+e.getX()]);

  }

  // ===========================================================================
  // Handle mouse relase
  // =============================================================================
  public void mouseReleased(MouseEvent e){
    if (mousekey==1){
      if (element instanceof LetterBox){
        
      }else if (element instanceof Eraser){
        //描画イメージ
        ((Shape)element).init((short)e.getX(),(short)e.getY(),current_color(), (short)0,(short)e.getX(),(short)e.getY());
      }else if ((element!=null)){
            draw(element,parent.matrix);
            element=null;
      }
    }
    mousekey=0;
  }
}

