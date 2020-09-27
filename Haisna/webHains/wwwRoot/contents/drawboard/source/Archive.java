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

import java.util.*;
import java.io.*;
import java.util.zip.*;
import java.lang.Math;
import java.io.Serializable;

import java.awt.*;
import java.awt.image.*;
import com.sun.image.codec.jpeg.*;

// =============================================================================
// =============================================================================
// Current image, maintained and distributed to new clients by server class
// =============================================================================
// =============================================================================
public class Archive implements Shape, Serializable{
  boolean savingenabled;  // can client request image-save?  (info for applet)
  short DIM_X;      // server image x dim
  short DIM_Y;      // server image y dim
  public int ID=0;  // sender's ID  (0 = server message)
  public String filename; // info for server, filename of screenshot

  //bitmap (zipped after creation, unzipped after transsmision)
  byte parcelDraw[];              //描画画像
  byte parcelString[];            //文字画像
  byte parcelComposit[];          //合成画像

  String sDrawing = "drawing";    //描画情報
  String sString = "string";      //文字情報
  String sComposit = "composit";  //合成情報

  String MedicalDepartmentName=null;
  String Part=null;
  String PatientNo=null;
  String PictureDiscernment=null;

  // =============================================================================
  // Archiveのプロパティ(診療科名)セットする
  // =============================================================================
  public void setMedicalDepartmentName(String mdn){
      this.MedicalDepartmentName = mdn;
  }
  // =============================================================================
  // Archiveのプロパティ(部位)セットする
  // =============================================================================
  public void setPart(String part){
      this.Part = part;
  }
  // =============================================================================
  // Archiveのプロパティ(患者番号)セットする
  // =============================================================================
  public void setPatientNo(String patientNo){
      this.PatientNo = patientNo;
  }
  // =============================================================================
  // Archiveのプロパティ(患者番号)セットする
  // =============================================================================
  public void setPictureDiscernment(String pd){
      this.PictureDiscernment = pd;
  }
  // =============================================================================
  // Set unique ID
  // =============================================================================
  public void setID(int i){ID=i;}

  // =============================================================================
  // Get unique ID
  // =============================================================================
  public int getID(){return ID;}

  // =============================================================================
  // Create current image package (server -> applet)
  // =============================================================================
  Archive (int[] whatDraw, short x, short y, boolean canSave){
    this(whatDraw,x,y);
    savingenabled=canSave;
  }

  // =============================================================================
  // Create current image package
  // =============================================================================
  Archive (int[] whatDraw, short x, short y){
    DIM_X=x;
    DIM_Y=y;

    //描画画像
    int offset=whatDraw.length;
    parcelDraw=new byte[offset*3];
    for (int i=0; i<whatDraw.length; i++){
      parcelDraw[i]=(byte)((whatDraw[i]>>16)&0xff);           // R
      parcelDraw[i+offset]=(byte)((whatDraw[i]>>8)&0xff);     // G
      parcelDraw[i+offset+offset]=(byte)(whatDraw[i]&0xff);   // B
    }

    // pack data
    Deflater def=new Deflater();
    def.setInput(parcelDraw,0,parcelDraw.length);  // Deflater.setInput(byte[]) has bug!
    def.finish();
    int bytesDone = def.deflate(parcelDraw);

    // and prepare to transfer
    byte tempDraw[]=new byte[bytesDone];
    for (int i=0; i<bytesDone; i++)
      tempDraw[i]=parcelDraw[i];
    parcelDraw=new byte[bytesDone];
    for (int i=0; i<bytesDone; i++)
      parcelDraw[i]=tempDraw[i];
    tempDraw=null;
    def.end();
    System.gc();
  }

  // =============================================================================
  // Create current image package（文字画像，合成画像を含む）
  // =============================================================================
  Archive (int[] whatDraw, int[] whatString, int[] whatComposit, short x, short y){
    DIM_X=x;
    DIM_Y=y;

    //描画画像
    int offset=whatDraw.length;
    parcelDraw=new byte[offset*3];
    for (int i=0; i<whatDraw.length; i++){
      parcelDraw[i]=(byte)((whatDraw[i]>>16)&0xff);           // R
      parcelDraw[i+offset]=(byte)((whatDraw[i]>>8)&0xff);     // G
      parcelDraw[i+offset+offset]=(byte)(whatDraw[i]&0xff);   // B
    }

    // pack data
    Deflater def=new Deflater();
    def.setInput(parcelDraw,0,parcelDraw.length);  // Deflater.setInput(byte[]) has bug!
    def.finish();
    int bytesDone = def.deflate(parcelDraw);

    // and prepare to transfer
    byte tempDraw[]=new byte[bytesDone];
    for (int i=0; i<bytesDone; i++)
      tempDraw[i]=parcelDraw[i];
    parcelDraw=new byte[bytesDone];
    for (int i=0; i<bytesDone; i++)
      parcelDraw[i]=tempDraw[i];
    tempDraw=null;
    def.end();
    
    //文字画像
    offset=whatString.length;
    parcelString=new byte[offset*3];
    for (int i=0; i<whatString.length; i++){
      parcelString[i]=(byte)((whatString[i]>>16)&0xff);           // R
      parcelString[i+offset]=(byte)((whatString[i]>>8)&0xff);     // G
      parcelString[i+offset+offset]=(byte)(whatString[i]&0xff);   // B
    }

    // pack data
    def=new Deflater();
    def.setInput(parcelString,0,parcelString.length);  // Deflater.setInput(byte[]) has bug!
    def.finish();
    bytesDone = def.deflate(parcelString);

    // and prepare to transfer
    byte tempString[]=new byte[bytesDone];
    for (int i=0; i<bytesDone; i++)
      tempString[i]=parcelString[i];
    parcelString=new byte[bytesDone];
    for (int i=0; i<bytesDone; i++)
      parcelString[i]=tempString[i];
    tempString=null;
    def.end();

    //合成画像
    offset=whatComposit.length;
    parcelComposit=new byte[offset*3];
    for (int i=0; i<whatComposit.length; i++){
      parcelComposit[i]=(byte)((whatComposit[i]>>16)&0xff);           // R
      parcelComposit[i+offset]=(byte)((whatComposit[i]>>8)&0xff);     // G
      parcelComposit[i+offset+offset]=(byte)(whatComposit[i]&0xff);   // B
    }

    // pack data
    def=new Deflater();
    def.setInput(parcelComposit,0,parcelComposit.length);  // Deflater.setInput(byte[]) has bug!
    def.finish();
    bytesDone = def.deflate(parcelComposit);

    // and prepare to transfer
    byte tempComposit[]=new byte[bytesDone];
    for (int i=0; i<bytesDone; i++)
      tempComposit[i]=parcelComposit[i];
    parcelComposit=new byte[bytesDone];
    for (int i=0; i<bytesDone; i++)
      parcelComposit[i]=tempComposit[i];
    tempComposit=null;
    def.end();

    System.gc();
  }

  // =============================================================================
  // Unpack zipped array(描画画像)
  // =============================================================================
  void unpackDraw(){
    byte tempDraw[]=new byte[DIM_X*DIM_Y*3];

    // unpack data...
    Inflater inf=new Inflater();
    inf.setInput(parcelDraw);
    inf.finished();
    try{
      inf.inflate(tempDraw);
    }catch(DataFormatException e){
      if (Server.runQuiet==false)
        System.out.println("Wrong archive data received "+e);
      return;
    };
    inf.end();
    parcelDraw=new byte[tempDraw.length];
    System.arraycopy(tempDraw,0,parcelDraw,0,tempDraw.length);
  }

  // =============================================================================
  // Unpack zipped array(文字画像)
  // =============================================================================
  void unpackString(){
    byte tempString[]=new byte[DIM_X*DIM_Y*3];

    // unpack data...
    Inflater inf=new Inflater();
    inf.setInput(parcelString);
    inf.finished();
    try{
      inf.inflate(tempString);
    }catch(DataFormatException e){
      if (Server.runQuiet==false)
        System.out.println("Wrong archive data received "+e);
      return;
    };
    inf.end();
    parcelString=new byte[tempString.length];
    System.arraycopy(tempString,0,parcelString,0,tempString.length);
  }

  // =============================================================================
  //Unpack zipped array(合成画像)
  // =============================================================================
  void unpackComposit(){
    byte tempComposit[]=new byte[DIM_X*DIM_Y*3];

    // unpack data...
    Inflater inf=new Inflater();
    inf.setInput(parcelComposit);
    inf.finished();
    try{
      inf.inflate(tempComposit);
    }catch(DataFormatException e){
      if (Server.runQuiet==false)
        System.out.println("Wrong archive data received "+e);
      return;
    };
    inf.end();
    parcelComposit=new byte[tempComposit.length];
    System.arraycopy(tempComposit,0,parcelComposit,0,tempComposit.length);
  }

  // =============================================================================
  // Draw current image on client's board, when it receives parcel
  // =============================================================================
  public void draw(int[] matrix, short width){

    unpackDraw();

    // copy unpacked data to the buffre
    int offset=matrix.length;
    for (int i=0; i<offset; i++)
      matrix[i]=
        parcelDraw[i+offset+offset]&0xff |
        (((parcelDraw[i+offset]&0xff)<<8)) |
        (((parcelDraw[i]&0xff)<<16)) |
        (((0xff)<<24));
  };

  // =============================================================================
  // Save received image to file in desired directory
  // =============================================================================
  void save(String path){
    //描画画像保存（.png）
    unpackDraw();

    int unzippedDraw[] = new int[DIM_X*DIM_Y];
    int offset=DIM_X*DIM_Y;
    for (int i=0; i<offset; i++)
      unzippedDraw[i]=
        parcelDraw[i+offset+offset]&0xff |
        (((parcelDraw[i+offset]&0xff)<<8)) |
        (((parcelDraw[i]&0xff)<<16)) |
        (((0xff)<<24));

    //ファイル名決定
    filename = path+MedicalDepartmentName+"_"+Part+"_"+PatientNo+"_"+PictureDiscernment+"_"+sDrawing;    

    //pngファイルへの保存
    PngEncoder encoder=new PngEncoder(unzippedDraw,(int)DIM_X,false,PngEncoder.FILTER_NONE,9);
    byte[] plikDraw=encoder.pngEncode(true);

    File fDraw = new File(filename+".png");
    try{
      RandomAccessFile  pDraw = new RandomAccessFile(fDraw,"rw");
      try{
        for (int i=0; i<plikDraw.length;i++)
          pDraw.writeByte(plikDraw[i]);
      }catch(IOException ee){
        if (Server.runQuiet==false)
          System.out.println(" error during saving file "+filename+".png: "+ee);
      }finally{
        pDraw.close();
      }
    }catch(FileNotFoundException e){
      if (Server.runQuiet==false)
        System.out.println(" error saving file "+filename+".png: "+e);
    }catch(SecurityException e){
      if (Server.runQuiet==false)
        System.out.println(" security error during saving file "+filename+".png: "+e);
    }catch(IOException e){
      if (Server.runQuiet==false)
        System.out.println(" error opening file "+filename+".png: "+e);
    }

    //文字画像保存（.png）
    unpackString();
    int unzippedString[] = new int[DIM_X*DIM_Y];
    offset=DIM_X*DIM_Y;
    for (int i=0; i<offset; i++)
      unzippedString[i]=
        parcelString[i+offset+offset]&0xff |
        (((parcelString[i+offset]&0xff)<<8)) |
        (((parcelString[i]&0xff)<<16)) |
        (((0xff)<<24));

    //ファイル名決定
    filename = path+MedicalDepartmentName+"_"+Part+"_"+PatientNo+"_"+PictureDiscernment+"_"+sString;    

    //pngファイルへの保存  
    encoder=new PngEncoder(unzippedString,(int)DIM_X,false,PngEncoder.FILTER_NONE,9);
    byte[] plikString=encoder.pngEncode(true);

    File fString = new File(filename+".png");    
    try{
      RandomAccessFile pString = new RandomAccessFile(fString,"rw");
      try{
        for (int i=0; i<plikString.length;i++)
          pString.writeByte(plikString[i]);
      }catch(IOException ee){
        if (Server.runQuiet==false)
          System.out.println(" error during saving file "+filename+".png: "+ee);
      }finally{
        pString.close();
      }
    }catch(FileNotFoundException e){
      if (Server.runQuiet==false)
        System.out.println(" error saving file "+filename+".png: "+e);
    }catch(SecurityException e){
      if (Server.runQuiet==false)
        System.out.println(" security error during saving file "+filename+".png: "+e);
    }catch(IOException e){
      if (Server.runQuiet==false)
        System.out.println(" error opening file "+filename+".png: "+e);
    }

    // 合成画像保存（.jpg）
    unpackComposit();
    
    int unzippedComposit[] = new int[DIM_X*DIM_Y];
    offset=DIM_X*DIM_Y;
    for (int i=0; i<offset; i++)
      unzippedComposit[i]=
        parcelComposit[i+offset+offset]&0xff |
        (((parcelComposit[i+offset]&0xff)<<8)) |
        (((parcelComposit[i]&0xff)<<16)) |
        (((0xff)<<24));

        //ファイル名決定
        filename = path+MedicalDepartmentName+"_"+Part+"_"+PatientNo+"_"+PictureDiscernment+"_"+sComposit;    

        //jpgファイルへの保存  
        FileOutputStream out = null;
        try{ out = new FileOutputStream(new File(filename+".jpg")); }
        catch(IOException ef){ System.out.println("Cannot open file"); }

        JPEGImageEncoder Jencoder = JPEGCodec.createJPEGEncoder(out);

        BufferedImage img=new BufferedImage(
        (int)DIM_X,(int)DIM_Y,BufferedImage.TYPE_INT_RGB
        );
        img.setRGB(0,0,(int)DIM_X,(int)DIM_Y,unzippedComposit,0,(int)DIM_X);

        JPEGEncodeParam param = Jencoder.getDefaultJPEGEncodeParam(img);
        param.setQuality(1.0f, false);
        Jencoder.setJPEGEncodeParam(param);
        try{ Jencoder.encode(img); }
        catch(Exception ex){ System.out.println("ファイル保存失敗"); }
  };

  // Not used in this class
  public void setx2y2(short x2, short y2){};
  public void init(short xx1,short yy1,int cc, short tt, short xx2, short yy2){}
}


// =============================================================================
// =============================================================================
// A single "drawing" interface
// =============================================================================
// =============================================================================
interface Shape {
  public void setID(int i);
  public int getID();
  public void draw(int[] matrix, short width);  // draw themselves
  public void setx2y2(short x2, short y2);      // modify current object
  public void init(short xx1,short yy1,int cc, short tt, short xx2, short yy2);
}

// =============================================================================
// =============================================================================
// Reset screen pseudoshape
// =============================================================================
// =============================================================================
class Reset implements Shape, Serializable{
  int RGB;
  public int ID=0;

  // Set unique ID
  public void setID(int i){ID=i;}

  // Get unique ID
  public int getID(){return ID;}

  // =============================================================================
  public Reset(int cc){
    RGB=cc;
  }

  // =============================================================================
  public void init(short xx1,short yy1,int cc, short tt, short xx2, short yy2){}

  // =============================================================================
  public void setx2y2(short xx2, short yy2){}

  // =============================================================================
  public void draw(int[] matrix, short width){
    for (int i=0; i<matrix.length; i++)
      matrix[i]=RGB;
  }
}


// ===========================================================================
// =============================================================================
// Single line shape
// =============================================================================
// =============================================================================
class Line implements Shape, Serializable{    
  short x1, y1, x2, y2;
  int RGB;
  short thick;
  public int ID=0;

  // =============================================================================
  // Set unique ID
  // =============================================================================
  public void setID(int i){ID=i;}

  // =============================================================================
  // Get unique ID
  // =============================================================================
  public int getID(){return ID;}

  // =============================================================================
  Line(){};

  // =============================================================================
  Line(short X1, short Y1, int c, short t){
    x1=X1;
    y1=Y1;
    RGB=c;
    thick=t;
  }

  // =============================================================================
  // Light one pixel
  // =============================================================================
  static void pixel(int[] matrix, short width, int x, int y, int color){
    if (x<width && x>=0 && y>=0 && y<matrix.length/width)
      matrix[y*width+x]=color;
  }

  // =============================================================================
  // Light screen "dot", diameter-thick circle
  // =============================================================================
  static final void dot(int[] matrix, short width, short x, short y, short thick, int color){
    int height=matrix.length/width;
    switch (thick){

      case 1:
        pixel(matrix,width,x,y,color);              //   *  - shape
        break;

      case 2:
        pixel(matrix,width,x,y,color);              //   X*  - shape
        pixel(matrix,width,x+1,y,color);
        pixel(matrix,width,x,y+1,color);
        pixel(matrix,width,x+1,y+1,color);
        break;

      case 3:
        pixel(matrix,width,x,y,color);
        pixel(matrix,width,x+1,y,color);      //    *
        pixel(matrix,width,x,y+1,color);      //   *X*
        pixel(matrix,width,x-1,y,color);      //    *
        pixel(matrix,width,x,y-1,color);
        break;

      case 4:
        pixel(matrix,width,x,y,color);
        pixel(matrix,width,x,y-1,color);    //  **
        pixel(matrix,width,x+1,y-1,color);  // *X**
        pixel(matrix,width,x-1,y,color);    // ****
        pixel(matrix,width,x+1,y,color);    //  **
        pixel(matrix,width,x+2,y,color);
        pixel(matrix,width,x-1,y+1,color);
        pixel(matrix,width,x,y+1,color);
        pixel(matrix,width,x+1,y+1,color);
        pixel(matrix,width,x+2,y+1,color);
        pixel(matrix,width,x,y+2,color);
        pixel(matrix,width,x+1,y+2,color);
        break;

      case 5:
        pixel(matrix,width,x,y,color);
        pixel(matrix,width,x,y-2,color);
        pixel(matrix,width,x-1,y-1,color);    //    *
        pixel(matrix,width,x,y-1,color);      //   ***
        pixel(matrix,width,x+1,y-1,color);    //  **X**
        pixel(matrix,width,x-2,y,color);      //   ***
        pixel(matrix,width,x-1,y,color);      //    *
        pixel(matrix,width,x,y,color);
        pixel(matrix,width,x+1,y,color);
        pixel(matrix,width,x+2,y,color);
        pixel(matrix,width,x-1,y+1,color);
        pixel(matrix,width,x,y+1,color);
        pixel(matrix,width,x+1,y+1,color);
        pixel(matrix,width,x,y+2,color);
        break;

      case 6:
        pixel(matrix,width,x,y,color);
        pixel(matrix,width,x,y-2,color);
        pixel(matrix,width,x+1,y-2,color);
        pixel(matrix,width,x-1,y-1,color);    //    **
        pixel(matrix,width,x,y-1,color);      //   ****
        pixel(matrix,width,x+1,y-1,color);    //  **X***
        pixel(matrix,width,x+2,y-1,color);    //  ******
        pixel(matrix,width,x-2,y,color);      //   ****
        pixel(matrix,width,x-1,y,color);      //    **
        pixel(matrix,width,x+1,y,color);
        pixel(matrix,width,x+2,y,color);
        pixel(matrix,width,x+3,y,color);
        pixel(matrix,width,x-2,y+1,color);
        pixel(matrix,width,x-1,y+1,color);
        pixel(matrix,width,x,y+1,color);
        pixel(matrix,width,x+1,y+1,color);
        pixel(matrix,width,x+2,y+1,color);
        pixel(matrix,width,x+3,y+1,color);
        pixel(matrix,width,x-1,y+2,color);
        pixel(matrix,width,x,y+2,color);
        pixel(matrix,width,x+1,y+2,color);
        pixel(matrix,width,x+2,y+2,color);
        pixel(matrix,width,x,y+3,color);
        pixel(matrix,width,x+1,y+3,color);
    }
  }

  // =============================================================================
  // Used also by another shapes
  // =============================================================================
  public final static void drawthickline(int[] matrix, short width,int RGB,
        short x0, short y0, short x1, short y1, short thick){

    int color=RGB;

    short x = x0, y = y0;
    int dx = x1-x0, dy = y1-y0;   // direction of line

    int sx = (dx > 0 ? 1 : (dx < 0 ? -1 : 0));    // increment or decrement depending on direction of line
    int sy = (dy > 0 ? 1 : (dy < 0 ? -1 : 0));

    if ( dx < 0 ) dx = -dx;    // decision parameters for voxel selection
    if ( dy < 0 ) dy = -dy;
    int ax = 2*dx, ay = 2*dy;
    int decx, decy;

    int max = dx, var = 0;    // determine largest direction component, single-step related variable
    if ( dy > max ) { var = 1; }

    switch ( var ){    // traverse Bresenham line
    case 0:  // single-step in x-direction
      for (decy=ay-dx; /**/; x += sx, decy += ay){
        dot(matrix,width,x,y,thick, color);
          if ( x == x1 ) break;            // take Bresenham step
          if ( decy >= 0 ) { decy -= ax; y += sy; }
        }
        break;
    case 1:  // single-step in y-direction
        for (decx=ax-dy; /**/; y += sy, decx += ax){
        dot(matrix,width,x,y,thick, color);
            if ( y == y1 ) break;            // take Bresenham step
            if ( decx >= 0 ) { decx -= ay; x += sx; }
        }
        break;
    }
  }

  // =============================================================================
  public void draw(int[] matrix, short width){
    drawthickline( matrix,width,RGB,x1,y1,x2, y2, thick);
  }

  // =============================================================================
  public void setx2y2(short xx2, short yy2){
    x2=xx2;y2=yy2;
  };

  // =============================================================================
  public void init(short xx1,short yy1,int cc, short tt, short xx2, short yy2){
    x1=xx1;
    y1=yy1;
    RGB=cc;
    thick=tt;
    x2=xx2;y2=yy2;
  };

}

// =============================================================================
// =============================================================================
// Circle (ellipse) shape
// =============================================================================
// =============================================================================
class Circle implements Shape, Serializable{
  short x1, y1, x2, y2;
  int RGB;
  short thick;
  public int ID=0;

  // =============================================================================
  // Set unique ID
  // =============================================================================
  public void setID(int i){ID=i;}

  // =============================================================================
  // Get unique ID
  // =============================================================================
  public int getID(){return ID;}

  // =============================================================================
  Circle(){};

  // =============================================================================
  Circle(short X, short Y, int c, short t){
    x1=X;
    y1=Y;
    RGB=c;
    thick=t;
  }

  // =============================================================================
  public static void elipsePoints(int[] matrix, final short width, final short xc, final short yc, final short x, final short y, final int RGB, final short thick){
    Line.dot(matrix,width,(short)(xc+x),(short)(yc+y),thick,RGB);
    Line.dot(matrix,width,(short)(xc+x),(short)(yc-y),thick,RGB);
    Line.dot(matrix,width,(short)(xc-x),(short)(yc+y),thick,RGB);
    Line.dot(matrix,width,(short)(xc-x),(short)(yc-y),thick,RGB);
   }

  // =============================================================================
  public static void ellipseDraw(int[] matrix, final short width, final short xc, final short yc, final short a, final short b, final int RGB, final short thick){
    int a2 = a*a;
    int b2 = b*b;

    int x, y, dec;
    for (x = 0, y = b, dec = 2*b2+a2*(1-2*b); b2*x <= a2*y; x++){
      elipsePoints( matrix, width,xc,yc,(short)x,(short)y,RGB,thick);
      if ( dec >= 0 )
          dec += 4*a2*(1-(y--));
      dec += b2*(4*x+6);
    }

    for (x = a, y = 0, dec = 2*a2+b2*(1-2*a); a2*y <= b2*x; y++){
      elipsePoints( matrix, width,xc,yc,(short)x,(short)y,RGB,thick);
      if ( dec >= 0 )
          dec += 4*b2*(1-(x--));
      dec += a2*(4*y+6);
    }

  }

  // =============================================================================
  public void draw(int[] matrix, short width){
    short xx=(short)Math.abs(x1-x2);
    short yy=(short)Math.abs(y1-y2);
    if (xx==00 || yy==00) return;
    short a=0, b=0;
    if (xx<yy){
      a=(short)Math.min(xx,yy);
      b=(short)Math.max(xx,yy);
    }else{
      b=(short)Math.min(xx,yy);
      a=(short)Math.max(xx,yy);
    }
    ellipseDraw(matrix,width,x1,y1,a,b,RGB, thick);
  }


  // =============================================================================
  public void setx2y2(short xx2, short yy2){
    x2=xx2;y2=yy2;
  };

  // =============================================================================
  public void init(short xx1,short yy1,int cc, short tt, short xx2, short yy2){
    x1=xx1;
    y1=yy1;
    RGB=cc;
    thick=tt;
    x2=xx2;y2=yy2;
  };

}


// =============================================================================
// =============================================================================
// Filled circle (ellipse) shape
// =============================================================================
// =============================================================================
class FillCircle extends Circle implements Shape, Serializable{
  public int ID=0;

  // =============================================================================
  // Set unique ID
  // =============================================================================
  public void setID(int i){ID=i;}

  // =============================================================================
  // Get unique ID
  // =============================================================================
  public int getID(){return ID;}

  // =============================================================================
  FillCircle(){};

  // =============================================================================
  FillCircle(short X, short Y, int c, short t){
    super(X, Y, c, t);
  }

  // =============================================================================
  public static void fillElipsePoints(int[] matrix, int xc, int yc, int x, int y, int RGB, int width){
    int ysize=matrix.length/width;
    for (int i=Math.max(0,xc-x); i<Math.min(width,xc+x); i++){
      if (yc-y>=0)  matrix[(yc-y)*width+i]=RGB;
    }
    for (int i=Math.max(0,xc-x); i<Math.min(width,xc+x); i++){
      if (yc+y<ysize) matrix[(yc+y)*width+i]=RGB;
    }
  }

  // =============================================================================
  public static void drawFillEllipse(int[] matrix, int x1, int y1, int x2, int y2, int RGB, int width){
    int xx=Math.abs(x1-x2);
    int yy=Math.abs(y1-y2);
    if (xx==00 || yy==00) return;
    int a=0, b=0;
    if (xx<yy){
      a=Math.min(xx,yy);
      b=Math.max(xx,yy);
    }else{
      b=Math.min(xx,yy);
      a=Math.max(xx,yy);
    }

    int a2 = a*a;
    int b2 = b*b;

    int x, y, dec;
    for (x = 0, y = b, dec = 2*b2+a2*(1-2*b); b2*x <= a2*y; x++){
      fillElipsePoints( matrix,x1,y1,x,y,RGB,width);
      if ( dec >= 0 )
          dec += 4*a2*(1-(y--));
      dec += b2*(4*x+6);
    }
    for (x = a, y = 0, dec = 2*a2+b2*(1-2*a); a2*y <= b2*x; y++){
      fillElipsePoints( matrix,x1,y1,x,y,RGB,width);
        if ( dec >= 0 )
            dec += 4*b2*(1-(x--));
        dec += a2*(4*y+6);
    }
  }

  // =============================================================================
  public void draw(int[] matrix, short width){
    drawFillEllipse( matrix,x1,y1,x2,y2,RGB,width);
  }
}


// =============================================================================
// ===========================================================================
// Box (rectangle) shape
// =============================================================================
// =============================================================================
class Box implements Shape, Serializable{
  short x1, y1, x2, y2;
  int RGB;
  short thick;
  public int ID=0;

  // =============================================================================
  // Set unique ID
  // =============================================================================
  public void setID(int i){ID=i;}

  // =============================================================================
  // Get unique ID
  // =============================================================================
  public int getID(){return ID;}

  // =============================================================================
  Box(){};

  // =============================================================================
  Box(short X, short Y, int c, short t){
    x1=X;
    y1=Y;
    RGB=c;
    thick=t;
  }

  // =============================================================================
  public void draw(int[] matrix, short width){
    Line.drawthickline(matrix,width,RGB,x1,y1,x2,y1, thick);
    Line.drawthickline(matrix,width,RGB,x2,y1,x2,y2, thick);
    Line.drawthickline(matrix,width,RGB,x2,y2,x1,y2, thick);
    Line.drawthickline(matrix,width,RGB,x1,y2,x1,y1, thick);
  }

  // =============================================================================
  public void setx2y2(short xx2, short yy2){
    x2=xx2;y2=yy2;
  };

  // =============================================================================
  public void init(short xx1,short yy1,int cc, short tt, short xx2, short yy2){
    x1=xx1;
    y1=yy1;
    RGB=cc;
    thick=tt;
    x2=xx2;y2=yy2;
  };
}


// =============================================================================
// ===========================================================================
// Filld box (rectangle) shape
// =============================================================================
// =============================================================================
class FillBox extends Box implements Shape, Serializable{
  public int ID=0;

  // Set unique ID
  public void setID(int i){ID=i;}

  // Get unique ID
  public int getID(){return ID;}

  // =============================================================================
  FillBox(){};

  // =============================================================================
  FillBox(short X, short Y, int c, short t){
    super(X, Y, c, t);
  }

  // =============================================================================
  public void draw(int[] matrix, short width){
    for (int y=Math.min(super.y1, super.y2); y<Math.max(super.y1, super.y2);y++){
      int offset=y*width;
      for (int x=Math.min(super.x1,super.x2); x<Math.max(super.x1,super.x2);x++){
        matrix[offset+x]=RGB;
      }
    }
  }
}


// ===========================================================================
// =============================================================================
// Freehand shape
// =============================================================================
// =============================================================================
class Freehand implements Shape, Serializable{
  final short SIZE=255;
  short x[]=new short[SIZE];
  short y[]=new short[SIZE];
  short counter=2;
  int RGB;
  short thick;
  public int ID=0;

  // =============================================================================
  // Set unique ID
  // =============================================================================
  public void setID(int i){ID=i;}

  // =============================================================================
  // Get unique ID
  // =============================================================================
  public int getID(){return ID;}

  // =============================================================================
  Freehand(){};

  // =============================================================================
  Freehand(short X, short Y, int c, short t){
    x[0]=X;
    y[0]=Y;

    RGB=c;
    thick=t;
  }

  // =============================================================================
  public void draw(int[] matrix, short width){
    for (short a=0; a<counter-1; a++){
      Line.drawthickline(matrix,width,RGB,x[a],y[a],x[a+1],y[a+1], thick);
    }
  }

  // =============================================================================
  public void setx2y2(short xx2, short yy2){
  };

  // =============================================================================
  boolean nextxy(short xx, short yy){
    x[counter]=xx;
    y[counter]=yy;
    counter++;
    if (counter==SIZE) return true; else return false;
  };

  // =============================================================================
  public void init(short xx1,short yy1,int cc, short tt, short xx2, short yy2){
    counter=2;
    x[0]=xx1;
    y[0]=yy1;

    RGB=cc;
    thick=tt;
    x[1]=xx2;
    y[1]=yy2;
  };

}


// =============================================================================
// =============================================================================
// Letter (single character)
// =============================================================================
// =============================================================================
class Letter implements Shape, Serializable{
  short x1, y1, x2, y2;
  int RGB;
  short thick;
  public int ID=0;

  // =============================================================================
  // Set unique ID
  public void setID(int i){ID=i;}

  // =============================================================================
  // Get unique ID
  // =============================================================================
  public int getID(){return ID;}

  // =============================================================================
  Letter(){};

  // =============================================================================
  Letter(short X, short Y, int c, short t){
    x1=X;
    y1=Y;
    RGB=c;
    thick=t;
  }

  // =============================================================================
  public void draw(int[] matrix, short width){
    int[][]letter=Alphabet.getLetter((char)thick);
    for (int y=letter.length-1; y>-1;y--){
      for (int x=0; x<letter[0].length;x++){
        if (letter[y][x]!=0)
          Line.pixel(matrix,width,x1+x,y1+y,RGB);
      }
    }
  }

  // =============================================================================
  public void setx2y2(short xx2, short yy2){
    x2=xx2;y2=yy2;
  };

  // =============================================================================
  public void init(short xx1,short yy1,int cc, short tt, short xx2, short yy2){
    x1=xx1;
    y1=yy1;
    RGB=cc;
    thick=tt;
    x2=xx2;y2=yy2;
  };
}


// =============================================================================
// =============================================================================
// LetterBox (texttool rectangle shape)
// =============================================================================
// =============================================================================
class LetterBox implements Shape, Serializable{    
  short x1, y1, x2, y2;
  int RGB;
  short thick;
  public int ID=0;

  // =============================================================================
  // Set unique ID
  // =============================================================================
  public void setID(int i){ID=i;}

  // =============================================================================
  // Get unique ID
  // =============================================================================
  public int getID(){return ID;}

  // =============================================================================
  LetterBox(){
      x2=y2=-1;
  };

  // =============================================================================
  LetterBox(short X, short Y, int c, short t){
    x1=X;
    y1=Y;
    RGB=c;
    thick=t;
    x2=y2=-1;
  }

  // =============================================================================
  public void draw(int[] matrix, short width){
    int ox=0;
    int oy=3;
    Line.drawthickline(matrix,width,RGB,(short)(ox+x2-3),(short)(oy+y2-10),(short)(ox+x2+3),(short)(oy+y2-10), (short)1);
    Line.drawthickline(matrix,width,RGB,(short)(ox+x2-3),(short)(oy+y2+3),(short)(ox+x2+3),(short)(oy+y2+3), (short)1);
    Line.drawthickline(matrix,width,RGB,(short)(ox+x2+3),(short)(oy+y2-10),(short)(ox+x2+3),(short)(oy+y2+3), (short)1);
    Line.drawthickline(matrix,width,RGB,(short)(ox+x2-3),(short)(oy+y2+3),(short)(ox+x2-3),(short)(oy+y2-10), (short)1);
  }

  // =============================================================================
  public void setx2y2(short xx2, short yy2){
    x2=xx2;y2=yy2;
  };

  // =============================================================================
  public void init(short xx1,short yy1,int cc, short tt, short xx2, short yy2){
    x1=xx1;
    y1=yy1;
    RGB=cc;
    thick=tt;
    x2=xx1;y2=yy1;
  };
}

// =============================================================================
// =============================================================================
// スプレー
// =============================================================================
// =============================================================================
class Splay extends Circle implements Shape, Serializable{
  public int ID=0;
  int on= 0;  //始点or終点の判断　0：始点　1:終点
    

  // =============================================================================
  // Set unique ID
  // =============================================================================
  public void setID(int i){
    ID=i;}

  // =============================================================================
  // Get unique ID
  // =============================================================================
  public int getID(){
    return ID;}

  // =============================================================================
  Splay(){};

  // =============================================================================
  Splay(short X, short Y, int c, short t){
    super(X, Y, c, t);
  }

  // =============================================================================
  public static void SplayPoints(int[] matrix, int xc, int yc, int x, int y, int RGB, int width){
    int ysize=matrix.length/width;

    for (int i=Math.max(0,xc-x); i<Math.min(width,xc+x); i++){
      if (yc-y>=0) {
        if (y%3==0 && ((yc-y)*width+i)%3==0){
            matrix[(yc-y)*width+i]=RGB;
        }
      }
    }
    for (int i=Math.max(0,xc-x); i<Math.min(width,xc+x); i++){
      if (yc+y<ysize) {
        if (y%3==0 && ((yc-y)*width+i)%3==0){
            matrix[(yc+y)*width+i]=RGB;
        }
      }
    }
  }

  // =============================================================================
  public static void drawSplay(int[] matrix, int x1, int y1, int x2, int y2, int RGB, int width){

    int xx=Math.abs(x1-x2);
    int yy=Math.abs(y1-y2);
    if (xx==00 || yy==00) return;
    int a=0, b=0;
    if (xx<yy){
      a=Math.min(xx,yy);
      b=Math.max(xx,yy);
    }else{
      b=Math.min(xx,yy);
      a=Math.max(xx,yy);
    }

    int a2 = a*a;
    int b2 = b*b;

    int x, y, dec;
    for (x = 0, y = b, dec = 2*b2+a2*(1-2*b); b2*x <= a2*y; x++){
      SplayPoints( matrix,x1,y1,x,y,RGB,width);
      if ( dec >= 0 )
          dec += 4*a2*(1-(y--));
      dec += b2*(4*x+6);
    }
    for (x = a, y = 0, dec = 2*a2+b2*(1-2*a); a2*y <= b2*x; y++){
      SplayPoints( matrix,x1,y1,x,y,RGB,width);
        if ( dec >= 0 )
            dec += 4*b2*(1-(x--));
        dec += a2*(4*y+6);
    }
  }

  // =============================================================================
  public void draw(int[] matrix, short width){
    drawSplay( matrix,x1,y1,x2,y2,RGB,width);
  }
}

// =============================================================================
// =============================================================================
// 消しゴム
// =============================================================================
// =============================================================================
class Eraser implements Shape, Serializable{
  short x1, y1, x2, y2;
  int RGB;
  short thick;
  public int ID=0;

  // =============================================================================
  // Set unique ID
  // =============================================================================
  public void setID(int i){
    ID=i;}

  // =============================================================================
  // Get unique ID
  // =============================================================================
  public int getID(){
    return ID;}

  // =============================================================================
  Eraser(){
      x2=y2=-1;
  };

  // =============================================================================
  Eraser(short X, short Y, int c, short t){
    x1=X;
    y1=Y;
    RGB=c;
    thick=t;
    x2=y2=-1;
  }

  // =============================================================================
  public void draw(int[] matrix, short width){
    int ox=0;
    int oy=3;
    
    if (RGB == Color.white.getRGB()){ 
        for (int i=0; i<=3; i++){
            for (int j=0; j<=10; j++){
                Line.drawthickline(matrix,width,RGB,(short)(ox+x2-i),(short)(oy+y2-j),(short)(ox+x2+i),(short)(oy+y2-j), (short)1);
            }
        }
        //描画イメージの消去されたところを透過する
        //バックカラー白色を透過
        StringTokenizer strtokenWhite = new StringTokenizer("000000", "|");
        Color[] thruColorWhite = new Color[strtokenWhite.countTokens()];
        for (int i = 0; strtokenWhite.hasMoreTokens(); i++) {
            thruColorWhite[i] = new Color(Integer.parseInt(strtokenWhite.nextToken(), 16));
        }
        ImageFilter fltWhite = new CthruFilter(thruColorWhite, 0x20, 0);

        //バックカラー黒色を透過
        StringTokenizer strtoken = new StringTokenizer("FFFFFF", "|");
        
        Color[] thruColor = new Color[strtoken.countTokens()];
        for (int i = 0; strtoken.hasMoreTokens(); i++) {
            thruColor[i] = new Color(Integer.parseInt(strtoken.nextToken(), 16));
        }
        ImageFilter flt = new CthruFilter(thruColor, 0x20, 0);

        MemoryImageSource drawSource=new MemoryImageSource(500,400, ColorModel.getRGBdefault(), matrix, 0, 500);
        Image imgDraw = Toolkit.getDefaultToolkit().createImage(drawSource);
        
        //バックカラー白色を透過
        ImageProducer bgproducerWhite = new FilteredImageSource(imgDraw.getSource(), fltWhite);
        Image tmpWhiteImg = Toolkit.getDefaultToolkit().createImage(bgproducerWhite);
        PixelGrabber pgWhite = new PixelGrabber(tmpWhiteImg, 0, 0,   
                                                        500, 
                                                        400, 
                                                        matrix, 0, 500);
        try {
            boolean bl = pgWhite.grabPixels();
        }
        catch (InterruptedException ee) {
            System.err.println("interrupted waiting for pixels.[Archive.java:draw(int[] matrix, short width)]");
        }
                        
        if ((pgWhite.getStatus() & ImageObserver.ABORT) != 0) {
            System.err.println("image fetch aborted or errored.[Archive.java:draw(int[] matrix, short width)]");
        }

        //バックカラー黒色を透過
        ImageProducer bgproducer = new FilteredImageSource(imgDraw.getSource(), flt);
        Image tmpImg = Toolkit.getDefaultToolkit().createImage(bgproducer);
        PixelGrabber pg = new PixelGrabber(tmpImg, 0, 0,   
                                                        500, 
                                                        400, 
                                                        matrix, 0, 500);
        try {
            boolean bl = pg.grabPixels();
        }
        catch (InterruptedException ee) {
            System.err.println("interrupted waiting for pixels.[Archive.java:draw(int[] matrix, short width)]");
        }
                        
        if ((pg.getStatus() & ImageObserver.ABORT) != 0) {
            System.err.println("image fetch aborted or errored.[Archive.java:draw(int[] matrix, short width)]");
        }
        
        bgproducer = null;
        tmpImg = null;
        pg = null;

    }else{  //□を表示
        Line.drawthickline(matrix,width,RGB,(short)(ox+x2-3),(short)(oy+y2-10),(short)(ox+x2+3),(short)(oy+y2-10), (short)1);
        Line.drawthickline(matrix,width,RGB,(short)(ox+x2-3),(short)(oy+y2+3),(short)(ox+x2+3),(short)(oy+y2+3), (short)1);
        Line.drawthickline(matrix,width,RGB,(short)(ox+x2+3),(short)(oy+y2-10),(short)(ox+x2+3),(short)(oy+y2+3), (short)1);
        Line.drawthickline(matrix,width,RGB,(short)(ox+x2-3),(short)(oy+y2+3),(short)(ox+x2-3),(short)(oy+y2-10), (short)1);
    }

  }

  // =============================================================================
  public void setx2y2(short xx2, short yy2){
    x2=xx2;y2=yy2;
    
  };

  // =============================================================================
  public void init(short xx1,short yy1,int cc, short tt, short xx2, short yy2){
    x1=xx1;
    y1=yy1;
    
    thick=tt;
    x2=xx1;y2=yy1;
    
    if (tt==0){
        //□を表示
        RGB=Color.black.getRGB();
    }else{
        //実際に消去
        RGB=Color.white.getRGB();
    }
    
  };
}

