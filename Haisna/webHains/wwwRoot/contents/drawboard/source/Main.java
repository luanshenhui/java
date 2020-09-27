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
�y�t�@�C�������z
//���ʃp�^�[���摜�@
	[�f�ÉȖ�]_[����].[�g���q]
//�l�ʉ摜
	[�f�ÉȖ�]_[����]_[���Ҕԍ�]_[�摜���ʎq]_[�t�@�C�����].[�g���q]
	���t�@�C����ʁE�E�E�������|�mstring�n
						�`����|�mdrawing�n
						�������|�mcomposit�n
ex.
	//���ʃp�^�[���摜�ijpg�t�@�C���j
		CNS_HTCS1.jpg
	//�l�ʉ摜�|�������ijpg�t�@�C���j
		CNS_HTCS1_00000001_2001-04-04_string.png
	//�l�ʉ摜�|�`����ijpg�t�@�C���j
		CNS_HTCS1_00000001_2001-04-04_drawing.png
	//�l�ʉ摜�|�������ijpg�t�@�C���j
		CNS_HTCS1_00000001_2001-04-04_composit.jpg

�y�ǉ��A�v���b�g�p�����[�^�z
�f�ÉȖ�	MedicalDepartmentName
����		Part
���Ҕԍ�	PatientNo
�摜���ʎq	PictureDiscernment
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

    public String MedicalDepartmentName=null;   //�f�ÉȖ�
    public String Part=null;                    //����
    public String PatientNo=null;               //���Ҕԍ�
    public String PictureDiscernment=null;      //�t�@�C�����
    
    URL url1;

    private MemoryImageSource drawSource;  //�`�惁�����[�C���[�W
    volatile Image imgPattern=null;   //���ʃC���[�W
    volatile Image imgString=null;    //�����C���[�W
    volatile Image imgDraw=null;      //�`��C���[�W
    volatile Image imgComposit=null;     //�����C���[�W
    volatile Image imgErr=null;       //�G���[��ʏo�͗p�C���[�W
    volatile Image imgTemp=null;       //�G���[(menu,colorpicker)��ʏo�͗p�C���[�W
    volatile Graphics offGstring;   //�����I�t�X�N���[��
    volatile Graphics offGcomposit; //�����I�t�X�N���[��
    volatile Graphics offGerr=null;   //�G���[��ʏo�͗p�I�t�X�N���[��
    volatile Graphics offGtmp=null;   //�G���[(menu,colorpicker)��ʏo�͗p�I�t�X�N���[��

    volatile MediaTracker tracker;

    String pext = ".png";   //�g���q
    String ext = ".jpg";    //�g���q

    int range = 0x20;   //2����16�i�� �����ɂ���F�̕��i�f�t�H���g��20�j�B color�Ŏw�肵��RGB�̊e�l�}range�������ɂ���F�͈̔� 
    int rate = 0;       //2����16�i�� �����̓x�����i�f�t�H���g��0�j�B 0�`FF�̊Ԃ̒l��ݒ肷��B0�ɋ߂��قǓ����̓x����������
    int sdwX = 2;       //���� �����ȕ����̉e��x�i�E�j�����̕��B���̒l�̏ꍇ�A������ 
    int sdwY = 2;       //���� �����ȕ����̉e��y�i���j�����̕��B���̒l�̏ꍇ�A�����

    int sleepInterval = 50;
    volatile boolean readCompleate = false;  //���ʃC���[�W�擾���f

    private boolean mainclosing=false;  //���C�������I�����f�t���O
    
    volatile String errMsg[];     //�G���[���b�Z�[�W�i�[
    volatile int errCnt=0;        //�G���[���b�Z�[�W��
    private int errMax=10;        //�G���[���b�Z�[�W����MAX���l
    
    volatile boolean connectServer = true;  //�T�[�o�[�R�l�N�g���f true:OK false:NG
    volatile boolean cnt = false;            //�J�E���g
    volatile boolean Maximum = true;        //�T�[�o�[�ڑ��� true:OK false:NG(�I�[�o�[)

    volatile boolean startFlg = false;

// =============================================================================
  public void init(){
    
    errMsg = new String[errMax];

    //�����O�ɃK�x�[�W�R���N�g
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

    //���̃Z�b�g�����l�����ɒʐM�N���X�̓T�[�o����K�v�ȉ摜�����[�h����B
    comm.setMedicalDepartmentName(MedicalDepartmentName);
    comm.setPart(Part);
    comm.setPatientNo(PatientNo);
    comm.setPictureDiscernment(PictureDiscernment);

    //�ʐM�N���X�̃X���b�h���N��
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

    //�G���[��ʏo�͗p
    imgErr = createImage(DIM_X,DIM_Y);
    offGerr = imgErr.getGraphics();
    offGerr.setColor(Color.white);
    offGerr.fillRect(0,0,DIM_X,DIM_Y);

    //�G���[(menu,colorpicker)��ʏo�͗p
    imgTemp = createImage(DIM_X,DIM_Y);
    offGtmp = imgTemp.getGraphics();
    offGtmp.setColor(Color.white);
    offGtmp.fillRect(0,0,DIM_X,DIM_Y);

    //���j���[�C���[�W�擾�`�F�b�N
    if (!menu.tracker.checkAll(true) || menu.tracker.isErrorAny()){
//shimo        
if (!menu.tracker.checkAll(true)) System.out.println("Main:menu�擾���s [tracker.checkAll]");
if (menu.tracker.isErrorAny()) System.out.println("Main:menu�擾���s [tracker.isErrorAny]");
//shimo
        if (menu.tracker.isErrorID(0)){
            System.out.println("Loading Graphics Error�Fmenu_normal.png");              
            errCnt = errCnt + 1;
            errMsg[errCnt] = "menu_normal.png�̎擾�Ɏ��s���܂����B";
        }
        if (menu.tracker.isErrorID(1)){
            System.out.println("Loading Graphics Error�Fmenu_bold.png");        
            errCnt = errCnt + 1;
            errMsg[errCnt] = "menu_bold.png�̎擾�Ɏ��s���܂����B";
        }
        if (menu.tracker.isErrorID(2)){
            System.out.println("Loading Graphics Error�Fmenu_light.png");              
            errCnt = errCnt + 1;
            errMsg[errCnt] = "menu_light.png�̎擾�Ɏ��s���܂����B";
        }
        return;
    }

    //�p�����[�^�`�F�b�N
    if (MedicalDepartmentName == null || MedicalDepartmentName.length() == 0 ||
        Part == null || Part.length() == 0 ||
        PatientNo == null || PatientNo.length() == 0 ||
        PictureDiscernment == null || PictureDiscernment.length() == 0){
        if (MedicalDepartmentName==null || MedicalDepartmentName.length() == 0){
            System.out.println("Can Not Parameter�FMedicalDepartmentName");
            errCnt = errCnt + 1;
            errMsg[errCnt] = "�p�����[�^�iMedicalDepartmentName�j�̎擾�Ɏ��s���܂����B";
        }
        if (Part==null || Part.length() == 0){
            System.out.println("Can Not Parameter�FPart");
            errCnt = errCnt + 1;
            errMsg[errCnt] = "�p�����[�^�iPart�j�̎擾�Ɏ��s���܂����B";
        }
        if (PatientNo==null || PatientNo.length() == 0){
            System.out.println("Can Not Parameter�FPatientNo");
            errCnt = errCnt + 1;
            errMsg[errCnt] = "�p�����[�^�iPatientNo�j�̎擾�Ɏ��s���܂����B";
        }
        if (PictureDiscernment==null || PictureDiscernment.length() == 0){
            System.out.println("Can Not Parameter�FPictureDiscernment");
            errCnt = errCnt + 1;
            errMsg[errCnt] = "�p�����[�^�iPictureDiscernment�j�̎擾�Ɏ��s���܂����B";
        }
        return;
    }

	try {
        URL url = getCodeBase();
        Toolkit toolkit = getToolkit();
        String prefix=url.getProtocol()+"://";
        
        //���ʃC���[�W
        Image preImgPattern = toolkit.createImage(
            new URL((prefix+url.getHost()+url.getFile()+"screenshot/"+
                    MedicalDepartmentName+"_"+
                    Part+
                    ext
                    )));

        //�����C���[�W
        Image preImgString = toolkit.createImage(
            new URL((prefix+url.getHost()+url.getFile()+"screenshot/"+
                    MedicalDepartmentName+"_"+
                    Part+"_"+
                    PatientNo+"_"+
                    PictureDiscernment+"_"+
                    "string"+
                    pext
                    )));
            
        //�`��C���[�W    
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

        //�o�b�N�J���[���F�𓧉�
        StringTokenizer strtokenWhite = new StringTokenizer("FFFFFF", "|");
        Color[] thruColor = new Color[strtokenWhite.countTokens()];
        for (int i = 0; strtokenWhite.hasMoreTokens(); i++) {
            thruColor[i] = new Color(Integer.parseInt(strtokenWhite.nextToken(), 16));
        }
        ImageFilter fltWhite = new CthruFilter(thruColor, range, rate);

        //�o�b�N�J���[���F�𓧉�
        StringTokenizer strtokenBlack = new StringTokenizer("000000", "|");
        Color[] thruColorB = new Color[strtokenBlack.countTokens()];
        for (int i = 0; strtokenBlack.hasMoreTokens(); i++) {
            thruColorB[i] = new Color(Integer.parseInt(strtokenBlack.nextToken(), 16));
        }
        ImageFilter fltBlack = new CthruFilter(thruColorB, range, rate);

        /* ���ʃC���[�W */
        if (!tracker.checkID(0) || !tracker.isErrorID(0)){
            ImageProducer producer = new FilteredImageSource(preImgPattern.getSource(), fltWhite);
            imgPattern = createImage(producer);
            producer = null;
        }else{
            System.out.println("Loading Graphics Error�FpreImgPattern");
            errCnt = errCnt + 1;
            errMsg[errCnt] = "preImgPattern�̎擾�Ɏ��s���܂����B";
            return;
        }

        /* �����C���[�W */
        imgString = createImage(DIM_X-RIGHT_MARGIN,DIM_Y-BOTTOM_MARGIN);
        offGstring = imgString.getGraphics();
        if (!tracker.checkID(1) || !tracker.isErrorID(1)){
            offGstring.drawImage(preImgString, 0, 0, DIM_X-RIGHT_MARGIN, DIM_Y-BOTTOM_MARGIN, this);  //�����̕����摜�𗬂�����
        }else{
            System.out.println("Not Found�FpreImgString");
            offGstring.setColor(Color.white);
            offGstring.fillRect(0,0,DIM_X-RIGHT_MARGIN,DIM_Y-BOTTOM_MARGIN);
        }

         /* �`��C���[�W */
        if (!tracker.checkID(2) || tracker.isErrorID(2)){
            System.out.println("Not Found�FpreImgDraw");
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

        /* �����C���[�W */
        imgComposit = createImage(DIM_X-RIGHT_MARGIN,DIM_Y-BOTTOM_MARGIN);
        offGcomposit = imgComposit.getGraphics();

        offGcomposit.drawImage(imgString, 0, 0, DIM_X-RIGHT_MARGIN, DIM_Y-BOTTOM_MARGIN, this);  //�����C���[�W
        offGcomposit.drawImage(imgDraw, 0, 0, DIM_X-RIGHT_MARGIN, DIM_Y-BOTTOM_MARGIN, this);    //�`��C���[�W
        offGcomposit.drawImage(imgPattern, 0, 0, DIM_X-RIGHT_MARGIN, DIM_Y-BOTTOM_MARGIN, this); //���ʃC���[�W

        readCompleate = true;   //���ʃC���[�W�擾����

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

    //�҂�
    while(!startFlg){
      try{
        Thread.sleep(50);
      }
      catch (InterruptedException e){
        System.out.println("destroy interrupted");
      }
    }
    System.out.println("******destroyStart");
    //Communicator�o�R�ŃT�[�o����endSignal�𑗂�
    comm.send("endSignal");

    //Communicator���I������܂őҋ@
    try{
        comm.join();
    }catch(InterruptedException e){
        System.out.println("repaint: While Communicator join: "+e);
    }

    //���C�������I��
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

    //�T�[�o�[�̐ڑ��m�F
    if (board.sentence!=null){
        if (errCnt==0 && cnt==false){
            if (Maximum==false){
                //�T�[�o�[�ڑ����I�[�o�[
                System.out.println("Maximum Client Number Reached.");
                errCnt = errCnt + 1;
                errMsg[errCnt] = "�T�[�o�[�����ݍ����Ă��邽�߁A�T�[�o�[�ɐڑ��ł��܂���ł����B";
                errCnt = errCnt + 1;
                errMsg[errCnt] = "���΂炭�����Ă��炲�g�p���������B";
            }else{
                //�T�[�o�[�ڑ����s
                System.out.println("Not Connecting to Server");
                errCnt = errCnt + 1;
                errMsg[errCnt] = "�T�[�o�[�ɐڑ��ł��܂���ł����B";
                errCnt = errCnt + 1;
                errMsg[errCnt] = "���O��ʂɖ߂艽�x���N���b�N���Ă��T�[�o�[�ɐڑ��ł��Ȃ��悤�ł�����A";
                errCnt = errCnt + 1;
                errMsg[errCnt] = "�V�X�e���Ǘ��҂ւ��A�����������B";
            }

            connectServer=false;
            cnt = true;
        }
    }

    if (connectServer == false || readCompleate == false || menu.tracker.isErrorAny()){
      //�G���[���b�Z�[�W�\��     
      //�t�H���g�w��
      Font font1 = new Font("Dialog", Font.PLAIN, 14);
      Font font2 = new Font("Dialog", Font.PLAIN, 12);

      offGerr.setColor(Color.red);    //�t�H���g��
      offGerr.setFont(font1);
      offGerr.drawString("��������DrawBord�����g�p�ł��܂���B",10,40);
      
      //DrawBoard���g�p�ł��Ȃ��ꍇ�ɏo��
      if (cnt==false) offGerr.drawString("�V�X�e���Ǘ��҂ւ��A�����������B",10,60);
      
      offGerr.setColor(Color.black);  //�t�H���g��       
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
                //�T�[�o���ڑ��ł��Ȃ������ꍇ�̂ݍēx�ڑ��m�F���s���B
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
    �f�t�H���g RGB ColorModel �C���[�W�̃s�N�Z�����C������ ImageFilter ��e�Ղɍ쐬���邽�߂̕��@��񋟂��܂��B
    �܂��AFilteredImageSource �ƘA�����āA�����C���[�W�Ƀt�B���^�������邽�߂Ɏg���܂��B
    ���̃N���X�́A1 �̃��\�b�h��ʂ��Ă��ׂẴs�N�Z���f�[�^��ϊ����邽�߂̌Ăяo����񋟂��钊�ۃN���X�ł��B
    ���̃��\�b�h�́AImageProducer �Ŏg�p����Ă��� ColorModel �Ɋ֌W�Ȃ��A�f�t�H���g�� RGB ColorModel ��
    �s�N�Z������x�ɕϊ����܂��B�g�p����t�B���^���쐬���邽�߂ɒ�`����K�v������̂́A
    filterRGB ���\�b�h�����ł��B
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
