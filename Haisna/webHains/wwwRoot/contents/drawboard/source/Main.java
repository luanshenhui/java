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
/*
【ファイル命名】
//部位パターン画像　
	[診療科名]_[部位].[拡張子]
//個人別画像
	[診療科名]_[部位]_[患者番号]_[画像識別子]_[ファイル種別].[拡張子]
	→ファイル種別・・・文字情報－［string］
						描画情報－［drawing］
						合成情報－［composit］
ex.
	//部位パターン画像（jpgファイル）
		CNS_HTCS1.jpg
	//個人別画像－文字情報（jpgファイル）
		CNS_HTCS1_00000001_2001-04-04_string.png
	//個人別画像－描画情報（jpgファイル）
		CNS_HTCS1_00000001_2001-04-04_drawing.png
	//個人別画像－合成情報（jpgファイル）
		CNS_HTCS1_00000001_2001-04-04_composit.jpg

【追加アプレットパラメータ】
診療科名	MedicalDepartmentName
部位		Part
患者番号	PatientNo
画像識別子	PictureDiscernment
*/

package drawboard;

import java.applet.Applet;
import java.awt.*;
import java.awt.event.*;
import java.awt.image.*;
import java.net.*;

import java.util.*;

// =============================================================================
// =============================================================================
public class Main extends Applet implements Runnable{
  final static short RIGHT_MARGIN=100;    // Menu width
  final static short BOTTOM_MARGIN=50;    // Colorpicker height
  private short DIM_X, DIM_Y;             // Window dimensions
  private int PORT=7904;                  // Port number
  int ID=0;

  volatile int matrix[];                        // Offline image array
  volatile int matrix2[];                       // Temporary offline image array
  Thread repainter;                             // Image repaint thread
  boolean listenersInitialized=false;           // Initializes event listeners when images loaded

  Board board;            // Blackboard instance
  ColorPicker picker;     // Colorpicker instance
  Menu menu;              // Menu instance
  Communicator comm=null; // Communication module

  int initBgColor=Color.white.getRGB();   // initial background color (before server connection)

  int initPenColor=0xFF10139E;            // initial pen color
  int counterColor=Color.gray.getRGB();   // menu people counter color
  int menuBgColor=Color.black.getRGB();   // menu background color
  int menuEmptyThColor=Color.darkGray.getRGB(); // menu empty clipboard color

  Alphabet a=new Alphabet();  // fake initialization, IE requires one instance of
                              // any class to use its static methods

    public String MedicalDepartmentName=null;   //診療科名
    public String Part=null;                    //部位
    public String PatientNo=null;               //患者番号
    public String PictureDiscernment=null;      //ファイル種別
    
    URL url1;

    private MemoryImageSource drawSource;  //描画メモリーイメージ
    volatile Image imgPattern=null;   //部位イメージ
    volatile Image imgString=null;    //文字イメージ
    volatile Image imgDraw=null;      //描画イメージ
    volatile Image imgComposit=null;     //合成イメージ
    volatile Image imgErr=null;       //エラー画面出力用イメージ
    volatile Image imgTemp=null;       //エラー(menu,colorpicker)画面出力用イメージ
    volatile Graphics offGstring;   //文字オフスクリーン
    volatile Graphics offGcomposit; //合成オフスクリーン
    volatile Graphics offGerr=null;   //エラー画面出力用オフスクリーン
    volatile Graphics offGtmp=null;   //エラー(menu,colorpicker)画面出力用オフスクリーン

    volatile MediaTracker tracker;

    String pext = ".png";   //拡張子
    String ext = ".jpg";    //拡張子

    int range = 0x20;   //2桁の16進数 透明にする色の幅（デフォルトは20）。 colorで指定したRGBの各値±rangeが透明にする色の範囲 
    int rate = 0;       //2桁の16進数 透明の度合い（デフォルトは0）。 0～FFの間の値を設定する。0に近いほど透明の度合いが強い
    int sdwX = 2;       //整数 透明な部分の影のx（右）方向の幅。負の値の場合、左方向 
    int sdwY = 2;       //整数 透明な部分の影のy（下）方向の幅。負の値の場合、上方向

    int sleepInterval = 50;
    volatile boolean readCompleate = false;  //部位イメージ取得判断

    private boolean mainclosing=false;  //メイン処理終了判断フラグ
    
    volatile String errMsg[];     //エラーメッセージ格納
    volatile int errCnt=0;        //エラーメッセージ数
    private int errMax=10;        //エラーメッセージ数のMAX数値
    
    volatile boolean connectServer = true;  //サーバーコネクト判断 true:OK false:NG
    volatile boolean cnt = false;            //カウント
    volatile boolean Maximum = true;        //サーバー接続数 true:OK false:NG(オーバー)

    volatile boolean startFlg = false;

// =============================================================================
  public void init(){
    
    errMsg = new String[errMax];

    //処理前にガベージコレクト
    System.gc();
    try {
    // Generate unique ID (well, not uniqe, but count the probability :)))
    ID=(int)(Math.random()*1000000000)*1000000+(
      (int)(System.currentTimeMillis()&0xfffff));

    // Determine applet size
    try{
      DIM_X = (short)(Integer.parseInt( getParameter( "width" )));
      DIM_Y = (short)(Integer.parseInt( getParameter( "height")));
    }catch(Exception e){DIM_X=600; DIM_Y=450;} // usefult only when developing with JBuilder
    this.setSize(DIM_X,DIM_Y);

    //Read runtime parameters
    readParameters();

    // Initialize arrays
    matrix=new int[(DIM_X-RIGHT_MARGIN)*(DIM_Y-BOTTOM_MARGIN)];
    matrix2=new int[(DIM_X-RIGHT_MARGIN)*(DIM_Y-BOTTOM_MARGIN)];

    repainter=new Thread(this);
    repainter.setPriority(Thread.MIN_PRIORITY);
    repainter.start();

    this.setLayout(null);

    url1=getCodeBase();
    menu=new Menu(url1, this);

    menu.setSize(RIGHT_MARGIN,DIM_Y);
    menu.setCursor(new Cursor(Cursor.HAND_CURSOR));
    menu.setBounds(DIM_X-RIGHT_MARGIN,0,RIGHT_MARGIN,DIM_Y);
    add(menu);
    menu.setVisible(false);

    /// picker
    picker=new ColorPicker(DIM_X-RIGHT_MARGIN,BOTTOM_MARGIN);
    picker.setSize(DIM_X-RIGHT_MARGIN,BOTTOM_MARGIN);
    picker.setCursor(new Cursor(Cursor.CROSSHAIR_CURSOR));
    picker.setBounds(0,DIM_Y-50,DIM_X-100,50);
    add(picker);
    picker.setVisible(false);

    // board
    board=new Board((short)(DIM_X-RIGHT_MARGIN),(short)(DIM_Y-BOTTOM_MARGIN), this);

    // Communicator
    comm=new Communicator(board, getCodeBase(), menu, PORT, this);
    
    // Make links between objects
    board.setLinks(picker, menu, comm);
    menu.setBoard(board);
    menu.setApplet(this);
    menu.setAppletContext(this.getAppletContext());
    menu.setCommunicator(comm);

    //このセットした値を元に通信クラスはサーバから必要な画像をロードする。
    comm.setMedicalDepartmentName(MedicalDepartmentName);
    comm.setPart(Part);
    comm.setPatientNo(PatientNo);
    comm.setPictureDiscernment(PictureDiscernment);

    //通信クラスのスレッドを起動
    comm.start();

    // Set extra data
    picker.setNewColor(initPenColor);  // initial pen color
    menu.setBgColor(menuBgColor);
    menu.setCounterColor(counterColor);
    menu.setEmptyThColor(menuEmptyThColor);

    setCursor(new Cursor(Cursor.CROSSHAIR_CURSOR));

    try{
      menu.tracker.waitForAll();
    }catch(InterruptedException e){}

    //エラー画面出力用
    imgErr = createImage(DIM_X,DIM_Y);
    offGerr = imgErr.getGraphics();
    offGerr.setColor(Color.white);
    offGerr.fillRect(0,0,DIM_X,DIM_Y);

    //エラー(menu,colorpicker)画面出力用
    imgTemp = createImage(DIM_X,DIM_Y);
    offGtmp = imgTemp.getGraphics();
    offGtmp.setColor(Color.white);
    offGtmp.fillRect(0,0,DIM_X,DIM_Y);

    //メニューイメージ取得チェック
    if (!menu.tracker.checkAll(true) || menu.tracker.isErrorAny()){
//shimo        
if (!menu.tracker.checkAll(true)) System.out.println("Main:menu取得失敗 [tracker.checkAll]");
if (menu.tracker.isErrorAny()) System.out.println("Main:menu取得失敗 [tracker.isErrorAny]");
//shimo
        if (menu.tracker.isErrorID(0)){
            System.out.println("Loading Graphics Error：menu_normal.png");              
            errCnt = errCnt + 1;
            errMsg[errCnt] = "menu_normal.pngの取得に失敗しました。";
        }
        if (menu.tracker.isErrorID(1)){
            System.out.println("Loading Graphics Error：menu_bold.png");        
            errCnt = errCnt + 1;
            errMsg[errCnt] = "menu_bold.pngの取得に失敗しました。";
        }
        if (menu.tracker.isErrorID(2)){
            System.out.println("Loading Graphics Error：menu_light.png");              
            errCnt = errCnt + 1;
            errMsg[errCnt] = "menu_light.pngの取得に失敗しました。";
        }
        return;
    }

    //パラメータチェック
    if (MedicalDepartmentName == null || MedicalDepartmentName.length() == 0 ||
        Part == null || Part.length() == 0 ||
        PatientNo == null || PatientNo.length() == 0 ||
        PictureDiscernment == null || PictureDiscernment.length() == 0){
        if (MedicalDepartmentName==null || MedicalDepartmentName.length() == 0){
            System.out.println("Can Not Parameter：MedicalDepartmentName");
            errCnt = errCnt + 1;
            errMsg[errCnt] = "パラメータ（MedicalDepartmentName）の取得に失敗しました。";
        }
        if (Part==null || Part.length() == 0){
            System.out.println("Can Not Parameter：Part");
            errCnt = errCnt + 1;
            errMsg[errCnt] = "パラメータ（Part）の取得に失敗しました。";
        }
        if (PatientNo==null || PatientNo.length() == 0){
            System.out.println("Can Not Parameter：PatientNo");
            errCnt = errCnt + 1;
            errMsg[errCnt] = "パラメータ（PatientNo）の取得に失敗しました。";
        }
        if (PictureDiscernment==null || PictureDiscernment.length() == 0){
            System.out.println("Can Not Parameter：PictureDiscernment");
            errCnt = errCnt + 1;
            errMsg[errCnt] = "パラメータ（PictureDiscernment）の取得に失敗しました。";
        }
        return;
    }

	try {
        URL url = getCodeBase();
        Toolkit toolkit = getToolkit();
        String prefix=url.getProtocol()+"://";
        
        //部位イメージ
        Image preImgPattern = toolkit.createImage(
            new URL((prefix+url.getHost()+url.getFile()+"screenshot/"+
                    MedicalDepartmentName+"_"+
                    Part+
                    ext
                    )));

        //文字イメージ
        Image preImgString = toolkit.createImage(
            new URL((prefix+url.getHost()+url.getFile()+"screenshot/"+
                    MedicalDepartmentName+"_"+
                    Part+"_"+
                    PatientNo+"_"+
                    PictureDiscernment+"_"+
                    "string"+
                    pext
                    )));
            
        //描画イメージ    
        Image preImgDraw = toolkit.createImage(
            new URL((prefix+url.getHost()+url.getFile()+"screenshot/"+
                    MedicalDepartmentName+"_"+
                    Part+"_"+
                    PatientNo+"_"+
                    PictureDiscernment+"_"+
                    "drawing"+
                    pext
                    )));

        tracker = new MediaTracker(this);
        tracker.addImage(preImgPattern, 0);
        tracker.addImage(preImgString, 1);
        tracker.addImage(preImgDraw, 2);
        try{
            tracker.waitForAll();
        }catch(InterruptedException e){}

        //バックカラー白色を透過
        StringTokenizer strtokenWhite = new StringTokenizer("FFFFFF", "|");
        Color[] thruColor = new Color[strtokenWhite.countTokens()];
        for (int i = 0; strtokenWhite.hasMoreTokens(); i++) {
            thruColor[i] = new Color(Integer.parseInt(strtokenWhite.nextToken(), 16));
        }
        ImageFilter fltWhite = new CthruFilter(thruColor, range, rate);

        //バックカラー黒色を透過
        StringTokenizer strtokenBlack = new StringTokenizer("000000", "|");
        Color[] thruColorB = new Color[strtokenBlack.countTokens()];
        for (int i = 0; strtokenBlack.hasMoreTokens(); i++) {
            thruColorB[i] = new Color(Integer.parseInt(strtokenBlack.nextToken(), 16));
        }
        ImageFilter fltBlack = new CthruFilter(thruColorB, range, rate);

        /* 部位イメージ */
        if (!tracker.checkID(0) || !tracker.isErrorID(0)){
            ImageProducer producer = new FilteredImageSource(preImgPattern.getSource(), fltWhite);
            imgPattern = createImage(producer);
            producer = null;
        }else{
            System.out.println("Loading Graphics Error：preImgPattern");
            errCnt = errCnt + 1;
            errMsg[errCnt] = "preImgPatternの取得に失敗しました。";
            return;
        }

        /* 文字イメージ */
        imgString = createImage(DIM_X-RIGHT_MARGIN,DIM_Y-BOTTOM_MARGIN);
        offGstring = imgString.getGraphics();
        if (!tracker.checkID(1) || !tracker.isErrorID(1)){
            offGstring.drawImage(preImgString, 0, 0, DIM_X-RIGHT_MARGIN, DIM_Y-BOTTOM_MARGIN, this);  //既存の文字画像を流し込む
        }else{
            System.out.println("Not Found：preImgString");
            offGstring.setColor(Color.white);
            offGstring.fillRect(0,0,DIM_X-RIGHT_MARGIN,DIM_Y-BOTTOM_MARGIN);
        }

         /* 描画イメージ */
        if (!tracker.checkID(2) || tracker.isErrorID(2)){
            System.out.println("Not Found：preImgDraw");
            preImgDraw = createImage(DIM_X-RIGHT_MARGIN,DIM_Y-BOTTOM_MARGIN);
            Graphics tmpG = preImgDraw.getGraphics();
            tmpG.setColor(Color.black);
            tmpG.fillRect(0,0,DIM_X-RIGHT_MARGIN,DIM_Y-BOTTOM_MARGIN);
        }

        ImageProducer bgproducer = new FilteredImageSource(preImgDraw.getSource(), fltBlack);
        Image tmpImg = createImage(bgproducer);
        PixelGrabber pg = new PixelGrabber(tmpImg, 0, 0,   
                                                        DIM_X-RIGHT_MARGIN, 
                                                        DIM_Y-BOTTOM_MARGIN, 
                                                        matrix, 0, DIM_X-RIGHT_MARGIN);
        try {
            boolean bl = pg.grabPixels();
        }
        catch (InterruptedException ee) {
            System.err.println("interrupted waiting for pixels.[Main.java:init()]");
        }
        if ((pg.getStatus() & ImageObserver.ABORT) != 0) {
            System.err.println("image fetch aborted or errored.[Main.java:init()]");
        }

        System.arraycopy(matrix,0,matrix2,0,matrix.length);
        drawSource=new MemoryImageSource((DIM_X-RIGHT_MARGIN),(DIM_Y-BOTTOM_MARGIN), ColorModel.getRGBdefault(), matrix2, 0, (DIM_X-RIGHT_MARGIN));
        imgDraw = createImage(drawSource);
            
        bgproducer = null;
        tmpImg = null;
        pg = null;

        /* 合成イメージ */
        imgComposit = createImage(DIM_X-RIGHT_MARGIN,DIM_Y-BOTTOM_MARGIN);
        offGcomposit = imgComposit.getGraphics();

        offGcomposit.drawImage(imgString, 0, 0, DIM_X-RIGHT_MARGIN, DIM_Y-BOTTOM_MARGIN, this);  //文字イメージ
        offGcomposit.drawImage(imgDraw, 0, 0, DIM_X-RIGHT_MARGIN, DIM_Y-BOTTOM_MARGIN, this);    //描画イメージ
        offGcomposit.drawImage(imgPattern, 0, 0, DIM_X-RIGHT_MARGIN, DIM_Y-BOTTOM_MARGIN, this); //部位イメージ

        readCompleate = true;   //部位イメージ取得成功

        thruColor = null;
        fltWhite = null;
        fltBlack = null;
        preImgPattern = null;
        preImgString = null;
        preImgDraw = null;

    } catch (Exception e) {
        System.out.println(e + ".[Main.java:init()]");
	} 

  }catch (NullPointerException e) {
     System.err.println(e + ".[Main.java:init()]");
  }

  }


  // =============================================================================
  // Close all connections and exit
  // =============================================================================
  public void destroy(){

    //待ち
    while(!startFlg){
      try{
        Thread.sleep(50);
      }
      catch (InterruptedException e){
        System.out.println("destroy interrupted");
      }
    }
    System.out.println("******destroyStart");
    //Communicator経由でサーバ側にendSignalを送る
    comm.send("endSignal");

    //Communicatorが終了するまで待機
    try{
        comm.join();
    }catch(InterruptedException e){
        System.out.println("repaint: While Communicator join: "+e);
    }

    //メイン処理終了
    mainclosing=true;
    System.gc();

  }

  // =============================================================================
  // Subthread, repaints image
  // =============================================================================
  public void run(){
    while(!mainclosing){
      try{
        Thread.sleep(sleepInterval);
      }
      catch (InterruptedException e){
        System.out.println("repaint thread interrupted");
      }
      repaint();
    }
  }

  // =============================================================================
  // Blackboard area repaint
  // =============================================================================
  public void paint(Graphics g){

    //サーバーの接続確認
    if (board.sentence!=null){
        if (errCnt==0 && cnt==false){
            if (Maximum==false){
                //サーバー接続数オーバー
                System.out.println("Maximum Client Number Reached.");
                errCnt = errCnt + 1;
                errMsg[errCnt] = "サーバーが混み合っているため、サーバーに接続できませんでした。";
                errCnt = errCnt + 1;
                errMsg[errCnt] = "しばらくたってからご使用ください。";
            }else{
                //サーバー接続失敗
                System.out.println("Not Connecting to Server");
                errCnt = errCnt + 1;
                errMsg[errCnt] = "サーバーに接続できませんでした。";
                errCnt = errCnt + 1;
                errMsg[errCnt] = "※前画面に戻り何度かクリックしてもサーバーに接続できないようでしたら、";
                errCnt = errCnt + 1;
                errMsg[errCnt] = "システム管理者へご連絡ください。";
            }

            connectServer=false;
            cnt = true;
        }
    }

    if (connectServer == false || readCompleate == false || menu.tracker.isErrorAny()){
      //エラーメッセージ表示     
      //フォント指定
      Font font1 = new Font("Dialog", Font.PLAIN, 14);
      Font font2 = new Font("Dialog", Font.PLAIN, 12);

      offGerr.setColor(Color.red);    //フォント赤
      offGerr.setFont(font1);
      offGerr.drawString("ただいまDrawBordがご使用できません。",10,40);
      
      //DrawBoardが使用できない場合に出力
      if (cnt==false) offGerr.drawString("システム管理者へご連絡ください。",10,60);
      
      offGerr.setColor(Color.black);  //フォント黒       
      offGerr.setFont(font2);

      int j=60;
      for (int i=1; i<errMax; i++){
        j = j+20;
        if (errMsg[i]!=null){
            offGerr.drawString(errMsg[i],10,j);
        }
      }
      g.drawImage(imgErr, 0, 0, DIM_X, DIM_Y, this);
    }else{
      g.setColor(new Color(menuBgColor));
      g.fillRect(0,0,DIM_X,DIM_Y);
    }
  }

  // =============================================================================
  // Graphics handle
  // =============================================================================
  public void update(Graphics g){

    try {
        if (readCompleate) {
            if (connectServer == false || !menu.tracker.checkAll(true) || menu.tracker.isErrorAny()){
                picker.setVisible(false);
                menu.setVisible(false);
                paint(g);
                //サーバが接続できなかった場合のみ再度接続確認を行う。
                if (connectServer == false) board.paint(g);
                if (cnt==false){
                }
            }else{
                if (!listenersInitialized) setListeners(g);
                board.paint(g);
            }
        }
    } catch (Exception e) {
        System.err.println(e + ".[Main.java:update()]");
	}
  }

  // =============================================================================
  // After menu images loaded
  // =============================================================================
  public void setListeners(Graphics g){
    listenersInitialized=true;
    picker.setVisible(true);
    picker.addMouseListener(picker);
    picker.addMouseMotionListener(picker);
    menu.setVisible(true);
    menu.addMouseListener(menu);
    menu.addMouseMotionListener(menu);
    addMouseListener(board);
    addMouseMotionListener(board);

    enableEvents(AWTEvent.KEY_EVENT_MASK);
    addKeyListener(board);
    addFocusListener(board);
    requestFocus();
  }

  // =============================================================================
  // Read HTML-embedded parameters
  // =============================================================================
  void readParameters(){

    try{
      if (getParameter("port")!=null){
        PORT=Integer.parseInt(getParameter("port"));
        System.out.println("Non-default port number defined: "+PORT);
      }
    }catch(NumberFormatException e){System.out.println("Wrong port number, reverting to default value: "+PORT);}

    try{
      if (getParameter("MedicalDepartmentName")!=null){
        MedicalDepartmentName=getParameter("MedicalDepartmentName");
      }
    }catch(NumberFormatException e){System.out.println("Wrong MedicalDepartmentName, reverting to default value: "+MedicalDepartmentName);}

    try{
      if (getParameter("Part")!=null){
        Part=getParameter("Part");
      }
    }catch(NumberFormatException e){System.out.println("Wrong Part, reverting to default value: "+Part);}

    try{
      if (getParameter("PatientNo")!=null){
        PatientNo=getParameter("PatientNo");
      }
    }catch(NumberFormatException e){System.out.println("Wrong PatientNo, reverting to default value: "+PatientNo);}

    try{
      if (getParameter("PictureDiscernment")!=null){
        PictureDiscernment=getParameter("PictureDiscernment");
      }
    }catch(NumberFormatException e){System.out.println("Wrong PictureDiscernment, reverting to default value: "+PictureDiscernment);}
  }
}

// =============================================================================
// =============================================================================
class CthruFilter extends RGBImageFilter {
    /* RGBImageFilter:
    デフォルト RGB ColorModel イメージのピクセルを修正する ImageFilter を容易に作成するための方法を提供します。
    また、FilteredImageSource と連結して、既存イメージにフィルタをかけるために使われます。
    このクラスは、1 つのメソッドを通してすべてのピクセルデータを変換するための呼び出しを提供する抽象クラスです。
    このメソッドは、ImageProducer で使用されている ColorModel に関係なく、デフォルトの RGB ColorModel で
    ピクセルを一度に変換します。使用するフィルタを作成するために定義する必要があるのは、
    filterRGB メソッドだけです。
    */
    private Color[] color;
    private int range;
    private int rate;
    private Color backColor;
    
  // =============================================================================
    public CthruFilter(Color[] color, int range, int rate) {
        
        this.color = color;
        this.range = range;
        this.rate = (rate<<24) | 0x00FFFFFF;
        this.backColor = Color.white;
        canFilterIndexColorModel = true;
    }

  // =============================================================================
    private boolean nearColor(int rgb, Color col) {
        
        int r = (rgb & 0x00FF0000) >> 16;
        int g = (rgb & 0x0000FF00) >> 8;
        int b = (rgb & 0x000000FF);
        if ((Math.abs(r - col.getRed()) <= range)
            && (Math.abs(g - col.getGreen()) <= range)
            && (Math.abs(b - col.getBlue()) <= range))
        {
            return true;
        }
        return false;
    }

  // =============================================================================
    public int filterRGB(int x, int y, int rgb) {
        
        if (color == null) return rgb;
        if (backColor != null && (rgb & 0xFF000000) == 0) return backColor.getRGB();
        boolean flag = false;
        for (int i = 0; i < color.length; i++) {
            if (nearColor(rgb, color[i])) {
                flag = true;
                break;
            }
        }
        if (flag) {
            return rate & rgb;
        } else {
            return rgb;
        }
    }
}
