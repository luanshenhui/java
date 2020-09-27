package com.lsh.dlrc.web;

import java.awt.AWTException;
import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.StringSelection;
import java.awt.datatransfer.Transferable;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;





import com.alibaba.fastjson.JSON;
import com.github.junrar.Archive;
import com.github.junrar.rarfile.FileHeader;
import com.lsh.dlrc.common.DBUtil;
import com.lsh.dlrc.common.ImageUtil;
import com.lsh.dlrc.common.MhtUtil;
import com.lsh.dlrc.domain.LshTable;
import com.lsh.dlrc.domain.Mobel;
import com.lsh.dlrc.domain.PersonDomain;
import com.lsh.dlrc.domain.Photo;
import com.lsh.dlrc.domain.PordDeptDomain;
import com.lsh.dlrc.domain.Post;
import com.lsh.dlrc.domain.RcDomain;
import com.lsh.dlrc.domain.User;
import com.lsh.dlrc.service.Service;




@Controller
@RequestMapping(value = "/web")
public class WebController {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	private List<Photo> phoneList;
	
	@Autowired
	private Service service;
	
	@InitBinder
	public void InitBinder(WebDataBinder binder) {
		try {
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");  
			dateFormat.setLenient(false);  
			binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping("/oracleTest")
	public String oracleTest(HttpServletRequest request) {
		List<LshTable> tableList = service.getTableList(new LshTable());
		System.err.println(tableList.toString());
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", 2);
		service.testP(param);
		System.out.println((List<Post>) param.get("v_cursor"));
		List<Post> testlsh=(List<Post>) param.get("v_cursor");
		System.err.println(testlsh);
		return testlsh.toString();
	}
	
	@RequestMapping("/list")
    public String list(HttpServletRequest request,RcDomain domain){
		try {
			int pages = 1;
			if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
			        pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
			}
			domain.setBeginPage(((pages-1)*10));
			domain.setEndPage(10);
			/****************************************oracle test****************************************************/
			List<LshTable> tableList=service.getTableList(new LshTable());
			System.err.println(tableList);
			/****************************************oracle test****************************************************/
			List<RcDomain> list=service.selectListPage(domain);
			int counts=service.selectCount(domain);
			request.setAttribute("domain", domain);
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// ｵｱﾇｰﾒｳﾂ�
			request.setAttribute("itemInPage", 10);// ﾃｿﾒｳﾏﾔﾊｾｵﾄｼﾇﾂｼﾊ�
			request.setAttribute("counts",counts);
		} catch (NumberFormatException e) {
			e.printStackTrace();
			logger.debug(e.getMessage());
		}
    	return "list";
	}
	
	@RequestMapping("/myAddList")
    public String myAddList(HttpServletRequest request,User user){
		try {
			int pages = 1;
			if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
			        pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
			}
			user.setBeginPage(((pages-1)*10));
			user.setEndPage(10);
			List<User> list=service.selectUserListPage(user);
			int counts=service.selectUserCount(user);
			request.setAttribute("domain", user);
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// ｵｱﾇｰﾒｳﾂ�
			request.setAttribute("itemInPage", 10);// ﾃｿﾒｳﾏﾔﾊｾｵﾄｼﾇﾂｼﾊ�
			request.setAttribute("counts",counts);
		} catch (NumberFormatException e) {
			e.printStackTrace();
			logger.debug(e.getMessage());
		}
    	return "myAddList";
	}
	
	
//	@PlatPermission(validate=true)
//	@RequestMapping(params="action=reg") 
    @RequestMapping("/add" )
    public String add(HttpServletRequest request){
		System.out.println("111111111111");
    	return "add";
    }
	
    @RequestMapping("/addTab" )
    public String addTab(HttpServletRequest request){
		System.out.println("111111111111");
    	return "addTab";
    }
    
    @RequestMapping("/stockSend" )
    public String stockSend(HttpServletRequest request){
		System.out.println("---------stockSend-----------");
    	return "stockSend";
    }
    
    @RequestMapping("/updateTab" )
    public String updateTab(HttpServletRequest request,User user){
		System.out.println(request.getParameter("id"));
		String key=request.getParameter("id");
		long id=Long.parseLong(key);
		user.setId(id);
		user=service.selectOneUser(user);
		request.setAttribute("id", request.getParameter("id"));
		request.setAttribute("obj", user);
		return "updateTab";
    }
	
	@RequestMapping("/info")
    public String info(HttpServletRequest request,@RequestParam(value="tel", required=true)String tel){
		try {
			RcDomain domain=new RcDomain();
			domain.setTel(tel);
			List<RcDomain> list=service.selectList(domain);
			request.setAttribute("list", list);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
		}
    	return "info";
	}
	
	@ResponseBody
	@RequestMapping("/update")
    public String update(HttpServletRequest request,@RequestParam(value="tel", required=true)String tel){
		try {
			RcDomain domain=new RcDomain();
			domain.setTel(tel);
			domain.setDel("0");
			service.updateDomain(domain);
			return "success";
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
		}
		return "error";
	}
	
	@ResponseBody
	@RequestMapping(value = "/addOne", method = RequestMethod.POST)
    public String addOne(HttpServletRequest request,@RequestParam(value="tel", required=true)String tel,RcDomain domain){
		try {
			domain.setEmil("auto");
			service.insertDomain(domain);
			System.out.println(domain);
			return "success";
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
		}
		return "error";
	}
	
	@ResponseBody
	@RequestMapping(value = "/addUserOne", method = RequestMethod.POST)
    public String addUserOne(HttpServletRequest request,User user){
		try {
			service.insertUser(user);
			return "success";
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
		}
		return "error";
	}
	
	@ResponseBody
	@RequestMapping(value = "/updateUserOne", method = RequestMethod.POST)
    public String updateUserOne(HttpServletRequest request,User user){
		try {
			service.updateUserOne(user);
			return "success";
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
		}
		return "error";
	}
	
	@RequestMapping("/updateUser")
    public String updateUser(HttpServletRequest request,HttpServletResponse response,User user){
		response.setContentType("text/html;charset=gb2312");
		PrintWriter out = null;
		try {
			out=response.getWriter();
			service.updateUser(user);
			out.println("<script>");
			out.print("alert('ﾐﾞｸﾄｳﾉｹｦ!');location.href=document.referrer;");
			out.println("</script>");
			out.flush();
			out.close();
		} catch (Exception e) {
			out.println("<script>");
			out.print("alert('ﾐﾞｸﾄﾊｧｰﾜ!');location.href=document.referrer;");
			out.println("</script>");
			out.flush();
			out.close();
			logger.debug(e.getMessage());
			e.printStackTrace();
		}
    	return "redirect:/web/myAddList";
	}
	
	@RequestMapping("/updateList")
    public String updateList(HttpServletRequest request,HttpServletResponse response,@RequestParam(value="tel", required=true)String tel){
		response.setContentType("text/html;charset=gb2312");
		PrintWriter out = null;
		try {
			out=response.getWriter();
			RcDomain domain=new RcDomain();
			domain.setTel(tel);
			domain.setDel("0");
			service.updateDomain(domain);
			out.println("<script>");
			out.print("alert('ﾐﾞｸﾄｳﾉｹｦ!');location.href=document.referrer;");
			out.println("</script>");
			out.flush();
			out.close();
		} catch (Exception e) {
			out.println("<script>");
			out.print("alert('ﾐﾞｸﾄﾊｧｰﾜ!');location.href=document.referrer;");
			out.println("</script>");
			out.flush();
			out.close();
			logger.debug(e.getMessage());
			e.printStackTrace();
		}
    	return "redirect:/web/list";
	}
	
	
	@RequestMapping("/jztreeTest")
    public String ztreeTest(HttpServletRequest request){
		System.out.println("-------------jztreeTest---------------");
    	return "jztreeTest";
	}
	
	@RequestMapping("/jztreeDemo")
    public String jztreeDemo(HttpServletRequest request){
		System.out.println("-------------jztreeDemo---------------");
    	return "jztreeDemo";
	}
	
	@RequestMapping("/jztreeDemo2")
    public String jztreeDemo2(HttpServletRequest request){
		List<PordDeptDomain> list=service.getPordDeptDomain(new PordDeptDomain());
		System.out.println(JSON.toJSONString(list));
		request.setAttribute("list", JSON.toJSONString(list));
//		Photo photo=new Photo();
//		photo.setId(2);
//		List<Photo> listphone=service.getPhoto(photo);
//		request.setAttribute("listphone", listphone);
//		phoneList=listphone;
//		System.out.println(photo);
		System.out.println("-------------jztreeDemo2---------------");
    	return "jztreeDemo2";
	}
	
	@RequestMapping("/jztreeDemo3")
    public String jztreeDemo3(HttpServletRequest request){
		System.out.println("-------------jztreeDemo3---------------");
    	return "jztreeDemo3";
	}
	
	@ResponseBody
	@RequestMapping("/jztreeAjax")
    public void jztreeAjax(HttpServletRequest request,HttpServletResponse response){
		List<PordDeptDomain> list=service.getPordDeptDomain(new PordDeptDomain());
		Map<String,Object> map=new HashMap<String, Object>();
		System.out.println(JSON.toJSONString(list));
		map.put("list", list);
		System.out.println("-------------jztreeAjax---------------");
		 response.setCharacterEncoding("UTF-8");
	     response.setContentType("text/html;charset=UTF-8");
	     try {
			response.getWriter().print(JSON.toJSONString(list));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
//    	return  JSON.toJSONString(list);
	}
	
	/**
     * ｴ｡ﾄ｣ｰ蟒｡ｵ釋ﾓﾇｩﾃ�
     * @param request
     * @param resp
     * @param id
     * @return
     * @throws Exception 
     */
/*    @RequestMapping(value = "getImage", method = RequestMethod.GET)
    public void getImage(HttpServletRequest request, HttpServletResponse response,String id){
//        String sql = "SELECT SIGNATURE FROM RDP_PSIGNATURE P WHERE P.USER_ID = '"+id+"'";
        OutputStream os = null;
        try {
//            RecordSet rs = OperDbUtil.getRecordSet(sql);
            os = response.getOutputStream();
            //ﾉ雜ｨﾊ莎ﾄｼ�ﾍｷ
//            response.setHeader("Content-disposition", "attachment;filename=" + URLEncoder.encode(id,"UTF-8"));
            //ﾉ靹ﾃﾏ�ﾓｦﾍｷ
            response.setContentType("image/jpeg;charset=utf-8");
//            if(rs.next()){
//                byte[] buf = rs.getBlob(1);
                if(buf == null) return;
                //ﾇ蠢ﾕﾊ莎�    
                response.reset();            
                os.write(buf);
//            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        //ﾊﾍｷﾅﾗﾊﾔｴ
        finally{
            try {
                os.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }*/
	
    @RequestMapping(value = "/getImage", method = RequestMethod.GET)
	public void getImage(HttpServletRequest request,HttpServletResponse response, String id) {
		OutputStream os = null;
		try {
			for (Photo p : phoneList) {
				if (p.getId() == Long.parseLong(id)) {
					os = response.getOutputStream();
					response.setContentType("image/jpeg;charset=utf-8");
					byte[] buf = p.getPhoto();
					if (buf == null)
						return;
					response.reset();
					os.write(buf);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		// ﾊﾍｷﾅﾗﾊﾔｴ
		finally {
			try {
				os.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public List<Photo> getPhoneList() {
		return phoneList;
	}

	public void setPhoneList(List<Photo> phoneList) {
		this.phoneList = phoneList;
	}
    
	
	@RequestMapping("/insertWeiXin")
	public String insertWeiXin(HttpServletRequest request) {
		try {
			Mobel mobel = new Mobel();
			mobel.setZt(188);
//			mobel.setId(1880411);
			List<Mobel> listMobel = service.getMobelList(mobel);
			Robot robot = new Robot();
			// ﾉ靹ﾃRobotｲ揵昮ｻｸｯﾗﾄﾐﾝﾃﾟﾊｱｼ�,ｷｴﾐﾐｹ�ｿ�
			robot.setAutoDelay(500);
			// ｻ｡ﾆﾁﾄｻｷﾖｱ貭ﾊ
			// Dimension d = Toolkit.getDefaultToolkit().getScreenSize();
			// System.out.println(d);
			// ﾒﾔﾆﾁﾄｻｵﾄｳﾟｴ邏ｴｽｨｸﾘﾐﾎ
			// Rectangle screenRect = new Rectangle(d);
			String tel="";
			for (Mobel m : listMobel) {
				for (int v = 100; v <= 9999; v++) {
					// ﾒﾆｶｯﾊ�
					robot.mouseMove(1150, 90);
					onclick(robot);
					robot.delay(1000);
					tel=m.getId() + mobelStr(v);
					useSysClipboard(tel);
					/* ｵ羹鰈ﾒ */
					robot.delay(1000);
					robot.mouseMove(1100, 160);
					robot.delay(1000);
					System.out.println("ｵ羹鰈ﾒ ");
					onclick(robot);
					// /*ｽﾘﾍｼ*/
					robot.delay(1000);
					// BufferedImage bufferedImage
					// =robot.createScreenCapture(screenRect);
					BufferedImage bufferedImage = robot.createScreenCapture(new Rectangle(900, 90, 400,400));
					// ｱ｣ｴ貎ﾘﾍｼ
					File file = new File("C:/Users/Administrator/Desktop/weixinScreen.png");
					ImageIO.write(bufferedImage, "png", file);
					// ｺﾋﾒｻｲｽ｣ｬｵ羹ﾒX｣ｨﾓﾐﾓﾃｻｧ｣ｬﾔ蠢ﾕ｡｣ﾎﾞﾓﾃｻｧ｣ｬｿﾕｲﾙﾗｩ
					// ｲ鰉ｯﾓﾐﾓﾃｻｧｵﾄﾇ鯀ｬｵ羹� 3ﾏﾂ <- ｻﾘﾖｳﾃ�
					
					for (int i = 0; i < 3; i++) {
						robot.delay(1000);
						robot.mouseMove(925, 90);
						onclick(robot);
					}
					
					// ｣ｨｲ鰉ｯｲｻｵｽﾓﾃｻｧｵﾄﾇ鯀ｬｵ羹�+｣ｩ
					robot.delay(1000);
					robot.mouseMove(1365, 90);
					onclick(robot);
					// ﾌ晴ﾓﾅﾑ
					robot.delay(1000);
					robot.mouseMove(1200, 180);
					onclick(robot);
					readImage2DB("C:/Users/Administrator/Desktop/weixinScreen.png",tel);
					// ｵ羹晴ﾓ
					robot.delay(1000);
					onclick(robot);
				}
			}
		} catch (AWTException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		System.out.println("-------------insertWeiXin---------------");
		return "redirect:/web/weiXinDemo";
	}
	
	/**
     * ｸｴﾖﾆﾊ�ｾﾝｵｽｼﾐｰ蟯｢ﾕｳﾌｴｲ｢ｰｴﾏﾂｻﾘｳｵ
     * @param writeMe ﾐ靨ｪﾕｳﾌﾄｵﾘﾖｷ
     * @throws java.awt.AWTException
     */
	private static void useSysClipboard(String writeMe) throws AWTException { 
        Robot robot=new Robot();
        System.out.println(writeMe);
        Clipboard clip = Toolkit.getDefaultToolkit().getSystemClipboard();  
        clip.setContents(new StringSelection(""), null);
        Transferable tText = new StringSelection(writeMe);  
        clip.setContents(tText, null);
        
        robot.keyPress(KeyEvent.VK_CONTROL);
        robot.keyPress(KeyEvent.VK_V);
        robot.keyRelease(KeyEvent.VK_V);
        robot.keyRelease(KeyEvent.VK_CONTROL);
    }


	private void onclick(Robot robot) {
		robot.mousePress(InputEvent.BUTTON1_MASK);
		System.out.println("ﾊ�ｵ･ｻ�");
		robot.mouseRelease(InputEvent.BUTTON1_MASK);
		
	}

	private String mobelStr(int i) {
		String s=String.valueOf(i);
		if(s.length()==4){
			return s;
		}
		if(s.length()==3){
			return "0"+s;
		}
		if(s.length()==2){
			return "00"+s;
		}
		if(s.length()==1){
			return "000"+s;
		}
		return s;
	}

	@RequestMapping(value = "/weiXinDemo", method = RequestMethod.GET)
    public String weiXinDemo(HttpServletRequest request,String b,String e){
		Photo photo=new Photo();
//		photo.setId(2);
		if(null!=b && !"".equals(b)){
			photo.setBegin(Long.parseLong(b));
		}
		if(null!=e && !"".equals(e)){
			photo.setEnd(Long.parseLong(e));
		}
		List<Photo> listphone=service.getPhoto(photo);
		request.setAttribute("listphone", listphone);
		phoneList=listphone;
		System.out.println("-------------weiXinDemo---------------");
    	return "weiXinDemo";
	}
	
    // ｽｫﾍｼﾆｬｲ衒�ﾊ�ｾﾝｿ�  
    public static void readImage2DB(String path,String tel) {  
//        String path = "D:/1.PNG";  
        Connection conn = null;  
        PreparedStatement ps = null;  
        FileInputStream in = null;  
        try {  
            in = ImageUtil.readImage(path);  
            conn = DBUtil.getConn();  
            String sql = "insert into photo (id,name,photo)values(?,?,?)";  
            ps = conn.prepareStatement(sql);  
            ps.setLong(1, Long.parseLong(tel));  
            ps.setString(2, "Tom");  
            ps.setBinaryStream(3, in, in.available());  
            int count = ps.executeUpdate();  
            if (count > 0) {  
                System.out.println("ｲ衒�ｳﾉｹｦ｣｡");  
            } else {  
                System.out.println("ｲ衒�ﾊｧｰﾜ｣｡");  
            }  
        } catch (Exception e) {  
            e.printStackTrace();  
        } finally {  
            DBUtil.closeConn(conn);  
            if (null != ps) {  
                try {  
                    ps.close();  
                } catch (SQLException e) {  
                    e.printStackTrace();  
                }  
            }  
        }  
  
    }  
    public static void main(String[] args) {
		System.out.println(new BigInteger("18804110000"));
	}
    
    // 复制文件
	private void copyFile(File fromFile, File toFile) {
		try {
			FileInputStream ins = new FileInputStream(fromFile);
			FileOutputStream out = new FileOutputStream(toFile);
			byte[] b = new byte[1024];
			int n = 0;
			while ((n = ins.read(b)) != -1) {
				out.write(b, 0, n);
			}
			ins.close();
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 判断文件 类型是不是 压缩文件
	private String isZip_Rar(File file) {
		try {
			String fileType = file.getName().substring(file.getName().lastIndexOf(".") + 1);
			if(fileType.equals("zip") || fileType.equals("rar")) {
				return fileType;
			}
			return fileType;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
	private void unRar(String  unRarFileName, String outputDirectory) {
        //ﾉ嵭ﾉｽ簷ｹﾎﾄｼ�
        Archive a = null;
        FileOutputStream fos = null;
        try{
            a = new Archive(new File(unRarFileName));
            FileHeader fh = a.nextFileHeader();
            while(fh!=null){
                if(!fh.isDirectory()){
                    //ｵｱﾇｰﾎﾄｼ�ｵﾄﾏ犖ﾔﾂｷｾｶ
                    String compressFileName = fh.getFileNameW().isEmpty()?fh.getFileNameString():fh.getFileNameW();
                    String destFileName = "";
                    //ｷﾇwindowsﾏｵﾍｳ ｺﾜﾖﾘﾒｪ
                    if(File.separator.equals("/")){
                        //ｵｱﾇｰﾎﾄｼ�ｵﾄｾﾔﾂｷｾｶ
                        destFileName = outputDirectory + File.separator + compressFileName.replaceAll("\\\\", "/");
                        //windowsﾏｵﾍｳ
                    }else{
                        destFileName = outputDirectory + File.separator + compressFileName.replaceAll("/", "\\\\");
                    }
                    //ﾈ｡ｵﾃﾄｸﾎﾄｼ�ｼﾐ｣ｬﾈ郢軏ｻｴ贇ﾚｾﾍｴｴｽｨﾎﾄｼ�ｼﾐ
                    File file = new File(destFileName);
                    File parent = file.getParentFile();
                    if (parent != null && !parent.exists()) {
                        parent.mkdirs();
                    }
                    //ｽ簷ｹﾋﾄｼ�
                    fos = new FileOutputStream(new File(destFileName));
                    a.extractFile(fh, fos);
                }
                fh = a.nextFileHeader();
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(fos!=null){
                try{fos.close();}catch(Exception e){e.printStackTrace();}
            }
            if(a!=null){
                try{a.close();}catch(Exception e){e.printStackTrace();}
            }
        }
    }
	
	
	@RequestMapping(value = "/mthJob", method = RequestMethod.GET)
    public String mthJob(HttpServletRequest request){
		try {
			String path = "D:\\BaiduNetdiskDownload\\dlrc-15-01\\新しいフォルダー";  // 解析文件目录
			File f = new File(path);
			if (!f.exists()) {
				System.out.println(path + " not exists");
				return null;
			}
			File fa[] = f.listFiles();
			for (int i = 0; i < fa.length; i++) {
				System.out.println(fa.length + "  ﾖｮ  " + i + " ｵﾄ  "
						+ fa[i].getName());
				File fs = fa[i];
				if (fs.isDirectory()) {
					System.out.println(fs.getName() + " [isDirectory]");
				} else {
					if (null!=isZip_Rar(fs) && isZip_Rar(fs).equals("mht")) {
						PersonDomain person=this.getPersonFromHtml(fs);
						System.out.println(person);
					} else if (null!=isZip_Rar(fs) && isZip_Rar(fs).equals("html")) {
						
					} else {// ﾎﾄｼ�ｾﾍｸｴﾖﾆｹ�ﾈ･
						// copyFile(fs, new File(WORD_PATH + "/" + fs.getName()));
					}
				}
				// fs.delete();
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;

	}
	
	@SuppressWarnings("unused")
	private PersonDomain getPersonFromHtml(File fs) throws IOException {
		Element element2 = null;
		PersonDomain person=new PersonDomain();
		if (!(new File("D:/" + "mhtToHtml2" ).isDirectory())) {
			new File("D:/" + "mhtToHtml2" ).mkdir();
		}
		MhtUtil.mht2html(fs.getPath(), "D:/" + "mhtToHtml2" + "/"
				+ fs.getName().split("\\.")[0] + "." + "html");
		File input = new File("D:/" + "mhtToHtml2" + "/"
				+ fs.getName().split("\\.")[0] + "." + "html");
		Document document = Jsoup.parse(input, "UTF-8");
		Elements elements = document.select("body table tr td table");
		Element element = elements.get(0);
		Element ee = element.select("tbody table").get(1);
		Element e0 = element.select("tbody table").get(0);
		Element e3 = null;
		if (element.select("tbody table").get(3).select("table").get(0)
				.select("table").size() > 1) {
			e3 = element.select("tbody table").get(3).select("table")
					.get(0).select("table").get(2);
			String XL = e3.select("table").get(0).select("tbody").get(0)
					.select("tr").get(1).select("td").get(1).text()
					.toString();// ﾑｧﾀ�
			person.setEducation(XL);
			String SCH = e3.select("table").get(0).select("tbody").get(0)
					.select("tr").get(3).select("td").get(1).text()
					.toString();// ｽﾌﾓ�ｾｭﾀ�
			person.setSch(SCH);
		} else {
			System.out.println("-------------------");
		}

		element2 = element;
		String NAME = e0.select("table").get(0).select("tbody").get(0)
				.select("tr").get(0).select("td").get(0).text();
		person.setName(NAME);
		try {
			String IMAGE = e0.select("table").get(0).select("tbody").get(0)
					.select("tr").get(0).select("td").get(0).select("img")
					.get(0).attr("src");
			person.setImage(IMAGE);
		} catch (Exception e1) {
			System.out.println("-----------ﾎﾞｴﾋimg-----------");
		}
		String ADDRESS2 = "";
		try {
			ADDRESS2 = ee.select("tr").get(1).select("td").get(1).text();
		} catch (Exception e2) {
		}
		try {
			String CITY = ee.select("tr").get(1).select("td").get(3).text();// ｻｧｿﾚ
			person.setCity(CITY);
		} catch (Exception e2) {
		}
		try {
			String SEX = ee.select("tr").get(0).select("td").get(0).text()
					.split("\\|")[1];// ﾐﾔｱ�
			person.setSex(SEX);
		} catch (Exception e1) {
			System.out.println("-------------ﾐﾔｱ�-----------------");
		}
		try {
			String WORKYEAR = ee.select("tr").get(0).select("td").get(0).text()
					.split("\\|")[0];// ｹ､ﾗｭﾑ�
			person.setWorkyear(WORKYEAR);
		} catch (Exception e2) {
		}
		String both;
		try {
			both = ee.select("tr").get(0).select("td").get(0).text()
					.split("\\|")[2];
			both = both.replace("｣ｨ", ":").replace("｣ｩ", ":");
			String AGE = both.split(":")[0];// ﾄ�ﾁ�
			person.setAge(AGE);
			String BORTH = both.split(":")[1];// ﾉ抦ﾕ
			person.setBorth(BORTH);
		} catch (Exception e1) {
			System.out.println("-------------ﾎﾞﾉ抦ﾕ-----------------");
		}

		Elements arr = ee.select("tr");
		for (Element e : arr) {
			if (e.select("td").get(0).text().contains("ｵ遑｡ｻｰ")) {
				String TEL = e.select("td").get(1).text().substring(0, 11);// ｵ扈ｰ
				person.setTel(TEL);
			}
			if (e.select("td").get(0).text().contains("E-mail")) {
				String EMIL = e.select("td").get(1).text();// emil
				person.setEmil(EMIL);
			}
			if (e.select("td").get(0).text().contains("ｵﾘ｡｡ﾖｷ")) {
				String ADDRESS = e.select("td").get(1).text();// emil
				person.setAddress(ADDRESS);
			}
		}
		if (person.getAddress().equals("")) {
			person.setAddress(ADDRESS2);
		}
		return person;
	}
	
	
}
