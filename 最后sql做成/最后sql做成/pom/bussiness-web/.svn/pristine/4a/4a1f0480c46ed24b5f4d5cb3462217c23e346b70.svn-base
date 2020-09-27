package cn.lsh.web.controller.login.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import login.model.DrewVo;
import login.model.FoltVoDraw;
import login.model.GroupUserVo;
import login.model.RoleVo;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import cn.lsh.web.controller.login.com.BaiduPush;
import cn.lsh.web.mapper.login.domain.AreaDomain;
import cn.lsh.web.mapper.login.domain.ColorUserVo;
import cn.lsh.web.mapper.login.domain.FoltDomain;
import cn.lsh.web.mapper.login.domain.GroupDomain;
import cn.lsh.web.mapper.login.domain.ImgDomain;
import cn.lsh.web.mapper.login.domain.ManagerDomain;
import cn.lsh.web.mapper.login.domain.PersonDomain;
import cn.lsh.web.mapper.login.domain.Role;
import cn.lsh.web.mapper.login.domain.RolePersonDomain;
import cn.lsh.web.service.service.LoginService;

import com.github.pagehelper.PageInfo;
import com.taobao.api.ApiException;
import com.taobao.api.DefaultTaobaoClient;
import com.taobao.api.TaobaoClient;
import com.taobao.api.request.AlibabaAliqinFcSmsNumSendRequest;
import com.taobao.api.response.AlibabaAliqinFcSmsNumSendResponse;

@Controller
@RequestMapping("/login")
public class LoginController extends  AbstractController{
	@Resource
	private LoginService loginService;
	
	@ResponseBody
	@RequestMapping(value="/login.action",method=RequestMethod.POST)
	public Map<String, Object> login(HttpServletRequest request,ManagerDomain m){
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			if(null==m|| null==m.getAccount() || m.getAccount().equals("") || null==m.getPassword() || m.getPassword().equals("")){
				returnMap.put("result", "failed");
				returnMap.put("msg", "用户名或密码不正确");
				return returnMap;
			}
			m=loginService.getLoginManager(m);
			if(null!=m){
				HttpSession session = request.getSession();
				session.setMaxInactiveInterval(0);
				session.setAttribute("userSession", m);
				returnMap.put("result", "success");
				return returnMap;
			}else{
				returnMap.put("result", "failed");
				returnMap.put("msg", "用户名或密码不正确");
				return returnMap;
			}
		} catch (Exception e) {
			returnMap.put("result", "failed");
			returnMap.put("msg", e.getMessage());
		}
		return returnMap;
		
	}
	
	@ResponseBody
	@RequestMapping(value="/getYzm.action",method=RequestMethod.POST)
	public String getYzm(HttpServletRequest request) throws ApiException{
		String tel=request.getParameter("tel");
		if(null==tel || tel.length()!=11){
			return "";
		}
		String s=BaiduPush.getFourRandom();
		TaobaoClient client = new DefaultTaobaoClient("http://gw.api.taobao.com/router/rest","23782150", "98f344016183651716b275080c554d40");
		AlibabaAliqinFcSmsNumSendRequest req = new AlibabaAliqinFcSmsNumSendRequest();
		req.setExtend( "" );
		req.setSmsType( "normal" );
		req.setSmsFreeSignName( "三增上学教育科技" );
		req.setSmsParamString( "{number:'"+s+"'}" );
		req.setRecNum( tel );
		req.setSmsTemplateCode( "SMS_65325038" );
		AlibabaAliqinFcSmsNumSendResponse rsp = client.execute(req);
		System.out.println(rsp.getBody());
		HttpSession session = request.getSession();
		session.setMaxInactiveInterval(0);
		session.setAttribute("yzm", s);
		session.setAttribute("tel", tel);
		return s;
	}
	
	/**
	 * 前端接口
	 * @param modelMap
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/getRolelist.action",method=RequestMethod.GET)
	public Map<String, Object> getRolelist(ModelMap modelMap,HttpServletRequest request,Role role){
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			List<RoleVo> rolelist =loginService.getRolelistVo(role);
			returnMap.put("result", "success");
			returnMap.put("data", rolelist);
		} catch (Exception e) {
			returnMap.put("result", "failed");
			returnMap.put("msg", e.getMessage());
		}
		return returnMap;
	}
	/**
	 * 时间接口
	 * @param modelMap
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/getLeaveTime.action",method=RequestMethod.GET)
	public Map<String, Object> getLeaveTime(ModelMap modelMap,HttpServletRequest request){
		Map<String, Object> returnMap = new HashMap<String, Object>();
		String person_id=request.getParameter("clentId");
		PersonDomain person =new PersonDomain();
		person.setPerson_id(person_id);
		try {
			person=loginService.getClientPerson(person);
			if(null!=person){
				String brithday=person.getBrithday();
				String time=BaiduPush.getLeveTime(brithday);
				returnMap.put("result", "success");
				returnMap.put("data", time);
			}else{
				returnMap.put("result", "failed");
				returnMap.put("msg", "没查询到手环日期");
			}
		} catch (Exception e) {
			returnMap.put("result", "failed");
			returnMap.put("msg", e.getMessage());
		}
		return returnMap;
	}
	
	/**
	 * http://localhost:8080/login/createPerson.action?person_id=333333&name=e&area=210000&remark=1&type=m&brithday=1985-03-31
	 * @param modelMap
	 * @param request
	 * @param person
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/createPerson.action",method=RequestMethod.GET)
	public Map<String, Object>  createPerson(ModelMap modelMap,HttpServletRequest request,PersonDomain person){
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			PersonDomain person2 =loginService.selectPerson(person);
			if(null==person2){
				String groupId=request.getParameter("groupId");
				loginService.createPerson(person,groupId);
				returnMap.put("result", "success");
				returnMap.put("msg", "1");
				return returnMap;
			}else{
				returnMap.put("result", "success");
				returnMap.put("msg", "2");
				return returnMap;
			}
		} catch (Exception e) {
			returnMap.put("result", "failed");
			returnMap.put("msg", e.getMessage());
		}
		return returnMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/findPersonOn.action",method=RequestMethod.GET)
	public Map<String, Object>  findPersonOn(ModelMap modelMap,HttpServletRequest request,PersonDomain person){
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			PersonDomain person2 =loginService.selectPerson(person);
			if(null==person2){
				returnMap.put("result", "success");
				returnMap.put("data", "0");
				return returnMap;
			}else{
				returnMap.put("result", "success");
				returnMap.put("data", "1");
				return returnMap;
			}
		} catch (Exception e) {
			returnMap.put("result", "failed");
			returnMap.put("msg", e.getMessage());
		}
		return returnMap;
	}
	
	/**
	 * 发送 色彩接口
	 * @param modelMap
	 * @param request
	 * @param folt
	 * @return
	 * http://localhost:8080/login/insertFolt.action?role_id=1111111111&c_b=1&person_id=SZ1499072837026&role_type=d
	 */
	@ResponseBody
	@RequestMapping(value="/insertFolt.action",method=RequestMethod.GET)
	public Map<String, Object>  insertFolt(ModelMap modelMap,HttpServletRequest request,FoltDomain folt){
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			List<String> list=loginService.getGroupPerson(folt);
			if(!list.isEmpty()){
				String msg=loginService.getMsg(folt);
				BaiduPush.PushBatchUniMsg(list.toArray(new String[list.size()]), msg+",推送测试");
			}
			loginService.insertFolt(folt);
			returnMap.put("result", "success");
		} catch (Exception e) {
			returnMap.put("result", "failed");
			returnMap.put("msg", e.getMessage());
			e.printStackTrace();
		}
		return returnMap;
	}
	/**
	 * 查找 手环号是否存在
	 * @param modelMap
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/selectWatchNum.action",method=RequestMethod.GET)
	public Map<String, Object>  selectWatchNum(ModelMap modelMap,HttpServletRequest request,GroupDomain group){
		Map<String, Object> returnMap = new HashMap<String, Object>();
		String person_id=request.getParameter("clentId");//
		group.setApp_id(person_id);
		group.setPerson_id(person_id);
		try {
			List<GroupDomain> list=loginService.selectWatchNum(group);
			if(!list.isEmpty()){
//				returnMap.put("data", list.get(0));
				returnMap.put("result", "success");
			}else{
				returnMap.put("result", "failed");
				returnMap.put("msg", "此编号不存在");
			}
		} catch (Exception e) {
			returnMap.put("result", "failed");
			returnMap.put("msg", e.getMessage());
		}
		return returnMap;
	}
	
	
	@RequestMapping(value="/init.action",method=RequestMethod.GET)
	public String init(ModelMap modelMap,HttpServletRequest request){
		return "login/login";
	
	}
	
	@RequestMapping(value="/groupList.action",method=RequestMethod.GET)
	public String groupList(ModelMap modelMap,HttpServletRequest request){
		String provinceid=request.getParameter("provinceid");
		modelMap.put("provinceid", provinceid);
		return "role/group";
	
	}
	
	@RequestMapping(value="/userList.action",method=RequestMethod.GET)
	public String userList(ModelMap modelMap,HttpServletRequest request){
		String groupId=request.getParameter("groupId");
		String time= loginService.getSysTime("yyyy年MM月");
		modelMap.put("groupId", groupId);
		modelMap.put("time", time);
		return "role/index";
	
	}

	@RequestMapping(value="/streetDraw.action",method=RequestMethod.GET)
	public String streetDraw(ModelMap modelMap,HttpServletRequest request){
		return "role/street";
	
	}
	
	
	@RequestMapping(value="/oracleDraw.action",method=RequestMethod.GET)
	public String oracleDraw(ModelMap modelMap,HttpServletRequest request){
		try {
			String personId=request.getParameter("personId");
			String personName=request.getParameter("personName");
			personName = URLDecoder.decode(personName, "UTF-8");
			String time= loginService.getSysTime("yyyy-MM");
			modelMap.put("personId", personId);
			modelMap.put("personName", personName);
			modelMap.put("time", time);
			return "role/oracle";
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return "role/oracle";
	
	}
	
	@RequestMapping(value="/province.action",method=RequestMethod.GET)
	public String province(ModelMap modelMap,HttpServletRequest request){
		return "role/province";
	}
	
	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest arg0,
			HttpServletResponse arg1) throws Exception {
		return null;
	}
	
	@RequestMapping(value="/loginOut.action",method=RequestMethod.GET)
	public String loginOut(ModelMap modelMap,HttpServletRequest request){
		request.getSession().invalidate();
		return "redirect:/login.html";
	}
	
	@ResponseBody
	@RequestMapping(value="/getProvinceList.action",method=RequestMethod.POST)
	public Map<String, Object> getProvinceList(ModelMap modelMap,HttpServletRequest request,GroupDomain group){
		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<AreaDomain> vo=loginService.getProvinceList(new AreaDomain());
		returnMap.put("data", vo);
		returnMap.put("result", "success");
		return returnMap;
	
	}
	
	@ResponseBody
	@RequestMapping(value="/getOracleDrew.action",method=RequestMethod.POST)
	public Map<String, Object> getOracleDrew(ModelMap modelMap,HttpServletRequest request,FoltDomain folt){
		if(null==folt){
			folt = new FoltDomain();
		}
		String person_id=request.getParameter("person_id");
		folt.setPerson_id(person_id);
		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<FoltVoDraw> vo;
		try {
			List<String> listday=loginService.printWeeks(request);
			vo = loginService.getOracleDrew(folt,listday);
			returnMap.put("listday", listday);
			returnMap.put("data", vo);
			returnMap.put("result", "success");
			return returnMap;
		} catch (Exception e) {
			logger.error(e);
			e.printStackTrace();
		}
		return returnMap;
	
	}
	
	@ResponseBody
	@RequestMapping(value="/getStreetDrew.action",method=RequestMethod.POST)
	public Map<String, Object> getStreetDrew(ModelMap modelMap,HttpServletRequest request,GroupDomain group){
		if(null==group){
			group=new GroupDomain();
		}
		group.setPerson_id(request.getParameter("person_id"));
		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<DrewVo> vo=loginService.getStreetDrew(group,request);
		returnMap.put("data", vo);
		returnMap.put("result", "success");
		return returnMap;
	
	}
	@ResponseBody
	@RequestMapping(value="/getAllList.action",method=RequestMethod.GET)
	public Map<String, Object> getAllList(ModelMap modelMap,HttpServletRequest request){
		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<RolePersonDomain> vo=loginService.getAllList(new RolePersonDomain());
		returnMap.put("data", vo);
		returnMap.put("result", "success");
		return returnMap;
	
	}
	
	@ResponseBody
	@RequestMapping(value = "/userListView.action", method = RequestMethod.GET)
	public Map<String, Object> userListView(HttpServletRequest request,
			@RequestParam(required = false, defaultValue = "0") int start,
			@RequestParam(required = false, defaultValue = "10") int length) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			// 处理分页
			if (length == -1) {
				length = Integer.MAX_VALUE;
			}
			int page = start / length + 1;
			// 处理快速查询条件
			ColorUserVo param = new ColorUserVo();
			param.setUserRole(request.getParameter("groupId"));
			// 获取分页数据
			PageInfo<ColorUserVo> list = loginService.findByWhere(page, length, param);
			// 设置返回结果内容
			returnMap.put("result", "success");
			returnMap.put("recordsFiltered", list.getTotal());
			returnMap.put("recordsTotal", list.getTotal());
			returnMap.put("data", list.getList());
		} catch (Exception ex) {
			logger.error(ex);
			returnMap.put("result", "failed");
			returnMap.put("msg", ex.getMessage());
		}
		return returnMap;
	}
	
	@ResponseBody
	@RequestMapping(value = "/groupListView.action", method = RequestMethod.GET)
	public Map<String, Object> groupListView(HttpServletRequest request,
			@RequestParam(required = false, defaultValue = "0") int start,
			@RequestParam(required = false, defaultValue = "10") int length) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		String provinceid=request.getParameter("provinceid");
		try {
			// 处理分页
			if (length == -1) {
				length = Integer.MAX_VALUE;
			}
			int page = start / length + 1;
			// 处理快速查询条件
			GroupDomain param = new GroupDomain();
			param.setArea(provinceid);
			// 获取分页数据
			PageInfo<GroupUserVo> list = loginService.groupListView(page, length, param);
			// 设置返回结果内容
			returnMap.put("result", "success");
			returnMap.put("recordsFiltered", list.getTotal());
			returnMap.put("recordsTotal", list.getTotal());
			returnMap.put("data", list.getList());
		} catch (Exception ex) {
			logger.error(ex);
			returnMap.put("result", "failed");
			returnMap.put("msg", ex.getMessage());
		}
		return returnMap;
	}
	
	
	/**
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("/groupDownload")
		 public void groupDownload(HttpServletRequest request,HttpServletResponse response) throws IOException{
		        String fileName="组"+BaiduPush.getSysTime("yyyyMMddHHmmss");
		        //填充projects数据
		        GroupDomain group =new GroupDomain();
		        group.setArea(request.getParameter("provinceid"));
		        List<GroupUserVo> vo=loginService.getGroupUserVoList(group);
		        List<Map<String,Object>> list=createExcelRecord(vo);
		        String columnNames[]={"组编号","人数","光环颜色1","光环颜色2","光环颜色3","光环颜色4","光环颜色5"};//列名
		        String keys[]    =     {"person_id","num","c_a","c_b","c_c","c_d","c_e"};//map中的key
		        ByteArrayOutputStream os = new ByteArrayOutputStream();
		        try {
		        	createWorkBook(list,keys,columnNames).write(os);
		        } catch (IOException e) {
		            e.printStackTrace();
		        }
		        byte[] content = os.toByteArray();
		        InputStream is = new ByteArrayInputStream(content);
		        // 设置response参数，可以打开下载页面
		        response.reset();
		        response.setContentType("application/vnd.ms-excel;charset=utf-8");
		        response.setHeader("Content-Disposition", "attachment;filename="+ new String((fileName + ".xls").getBytes(), "iso-8859-1"));
		        ServletOutputStream out = response.getOutputStream();
		        BufferedInputStream bis = null;
		        BufferedOutputStream bos = null;
		        try {
		            bis = new BufferedInputStream(is);
		            bos = new BufferedOutputStream(out);
		            byte[] buff = new byte[2048];
		            int bytesRead;
		            // Simple read/write loop.
		            while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
		                bos.write(buff, 0, bytesRead);
		            }
		        } catch (final IOException e) {
		            throw e;
		        } finally {
		            if (bis != null)
		                bis.close();
		            if (bos != null)
		                bos.close();
		        }
		
		
    }


	/**
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("/userDownload")
		 public void userDownload(HttpServletRequest request,HttpServletResponse response) throws IOException{
		        String fileName="用户"+BaiduPush.getSysTime("yyyyMMddHHmmss");
		        //填充projects数据
		        ColorUserVo user =new ColorUserVo();
		        user.setUserRole(request.getParameter("groupId"));
		        List<ColorUserVo> vo=loginService.getUserVoList(user);
		        List<Map<String,Object>> list=createUserRecord(vo);
		        String columnNames[]={"角色","光环颜色1","光环颜色2","光环颜色3","光环颜色4","光环颜色5","级别"};//列名
		        String keys[]    =     {"role","c_a","c_b","c_c","c_d","c_e","leve"};//map中的key
		        ByteArrayOutputStream os = new ByteArrayOutputStream();
		        try {
		        	createWorkBook(list,keys,columnNames).write(os);
		        } catch (IOException e) {
		            e.printStackTrace();
		        }
		        byte[] content = os.toByteArray();
		        InputStream is = new ByteArrayInputStream(content);
		        // 设置response参数，可以打开下载页面
		        response.reset();
		        response.setContentType("application/vnd.ms-excel;charset=utf-8");
		        response.setHeader("Content-Disposition", "attachment;filename="+ new String((fileName + ".xls").getBytes(), "iso-8859-1"));
		        ServletOutputStream out = response.getOutputStream();
		        BufferedInputStream bis = null;
		        BufferedOutputStream bos = null;
		        try {
		            bis = new BufferedInputStream(is);
		            bos = new BufferedOutputStream(out);
		            byte[] buff = new byte[2048];
		            int bytesRead;
		            // Simple read/write loop.
		            while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
		                bos.write(buff, 0, bytesRead);
		            }
		        } catch (final IOException e) {
		            throw e;
		        } finally {
		            if (bis != null)
		                bis.close();
		            if (bos != null)
		                bos.close();
		        }
		
		
    }
	
	 private List<Map<String, Object>> createUserRecord(List<ColorUserVo> vo) {
		  List<Map<String, Object>> listmap = new ArrayList<Map<String, Object>>();
	        Map<String, Object> map = new HashMap<String, Object>();
	        map.put("sheetName", "sheet1");
	        listmap.add(map);
	        ColorUserVo project=null;
	        for (int j = 0; j < vo.size(); j++) {
	            project=vo.get(j);
	            Map<String, Object> mapValue = new HashMap<String, Object>();
	            mapValue.put("role", project.getUserRole());
	            mapValue.put("leve", project.getLeve());
	            mapValue.put("c_a", project.getGhA());
	            mapValue.put("c_b", project.getGhB());
	            mapValue.put("c_c", project.getGhC());
	            mapValue.put("c_d", project.getGhD());
	            mapValue.put("c_e", project.getGhE());
	            listmap.add(mapValue);
	        }
	        return listmap;
	}

	public static Workbook createWorkBook(List<Map<String, Object>> list,String []keys,String columnNames[]) {
	        // 创建excel工作簿
	        Workbook wb = new HSSFWorkbook();
	        // 创建第一个sheet（页），并命名
	        Sheet sheet = wb.createSheet(list.get(0).get("sheetName").toString());
	        // 手动设置列宽。第一个参数表示要为第几列设；，第二个参数表示列的宽度，n为列高的像素数。
	        for(int i=0;i<keys.length;i++){
	            sheet.setColumnWidth((short) i, (short) (35.7 * 150));
	        }

	        // 创建第一行
	        Row row = sheet.createRow((short) 0);

	        // 创建两种单元格格式
	        CellStyle cs = wb.createCellStyle();
	        CellStyle cs2 = wb.createCellStyle();

	        // 创建两种字体
	        Font f = wb.createFont();
	        Font f2 = wb.createFont();

	        // 创建第一种字体样式（用于列名）
	        f.setFontHeightInPoints((short) 10);
	        f.setColor(IndexedColors.BLACK.getIndex());
	        f.setBoldweight(Font.BOLDWEIGHT_BOLD);

	        // 创建第二种字体样式（用于值）
	        f2.setFontHeightInPoints((short) 10);
	        f2.setColor(IndexedColors.BLACK.getIndex());

//	        Font f3=wb.createFont();
//	        f3.setFontHeightInPoints((short) 10);
//	        f3.setColor(IndexedColors.RED.getIndex());

	        // 设置第一种单元格的样式（用于列名）
	        cs.setFont(f);
	        cs.setBorderLeft(CellStyle.BORDER_THIN);
	        cs.setBorderRight(CellStyle.BORDER_THIN);
	        cs.setBorderTop(CellStyle.BORDER_THIN);
	        cs.setBorderBottom(CellStyle.BORDER_THIN);
	        cs.setAlignment(CellStyle.ALIGN_CENTER);

	        // 设置第二种单元格的样式（用于值）
	        cs2.setFont(f2);
	        cs2.setBorderLeft(CellStyle.BORDER_THIN);
	        cs2.setBorderRight(CellStyle.BORDER_THIN);
	        cs2.setBorderTop(CellStyle.BORDER_THIN);
	        cs2.setBorderBottom(CellStyle.BORDER_THIN);
	        cs2.setAlignment(CellStyle.ALIGN_CENTER);
	        //设置列名
	        for(int i=0;i<columnNames.length;i++){
	            Cell cell = row.createCell(i);
	            cell.setCellValue(columnNames[i]);
	            cell.setCellStyle(cs);
	        }
	        //设置每行每列的值
	        for (short i = 1; i < list.size(); i++) {
	            // Row 行,Cell 方格 , Row 和 Cell 都是从0开始计数的
	            // 创建一行，在页sheet上
	            Row row1 = sheet.createRow((short) i);
	            // 在row行上创建一个方格
	            for(short j=0;j<keys.length;j++){
	                Cell cell = row1.createCell(j);
	                cell.setCellValue(list.get(i).get(keys[j]) == null?" ": list.get(i).get(keys[j]).toString());
	                cell.setCellStyle(cs2);
	            }
	        }
	        return wb;
	    }

	private List<Map<String, Object>> createExcelRecord(List<GroupUserVo> vo) {
		  List<Map<String, Object>> listmap = new ArrayList<Map<String, Object>>();
	        Map<String, Object> map = new HashMap<String, Object>();
	        map.put("sheetName", "sheet1");
	        listmap.add(map);
	        GroupUserVo project=null;
	        for (int j = 0; j < vo.size(); j++) {
	            project=vo.get(j);
	            Map<String, Object> mapValue = new HashMap<String, Object>();
	            mapValue.put("person_id", project.getPerson_id());
	            mapValue.put("group_id", project.getGroup_id());
	            mapValue.put("leave", project.getLeave());
	            mapValue.put("num", project.getNum());
	            mapValue.put("app_id", project.getApp_id());
	            mapValue.put("c_a", project.getC_a());
	            mapValue.put("c_b", project.getC_b());
	            mapValue.put("c_c", project.getC_c());
	            mapValue.put("c_d", project.getC_d());
	            mapValue.put("c_e", project.getC_e());
	            listmap.add(mapValue);
	        }
	        return listmap;
	}
	private boolean pwdOk(String password, String passwordConfirm) {
		if(null!=password && null!=passwordConfirm && password.length()>5 && passwordConfirm.equals(password)){
			return true;
		}
		return false;
	}
	
	@ResponseBody
	@RequestMapping(value="/register.action",method=RequestMethod.POST)
	public Map<String, Object> register(HttpServletRequest request){
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			String passwordConfirm = request.getParameter("passwordConfirm");
			String tel = request.getParameter("tel");
			String yzm = request.getParameter("yzm");
			if(!this.pwdOk(password,passwordConfirm)){
				returnMap.put("result", "failed");
				returnMap.put("msg", "注册密码不一致");
				return returnMap;
			}
			HttpSession session = request.getSession();
			String sessionYzm=(String) session.getAttribute("yzm");
			if(null==sessionYzm || null==yzm){
				returnMap.put("result", "failed");
				returnMap.put("msg", "验证码错误");
				return returnMap;
			}else if(!sessionYzm.equals(yzm)){
				returnMap.put("result", "failed");
				returnMap.put("msg", "验证码错误");
				return returnMap;
			}
			String sessionTel=(String) session.getAttribute("tel");
			if(null!=sessionTel && null!=tel && sessionTel.equals(tel)){
				ManagerDomain d=new ManagerDomain();
				d.setAccount(username);
				ManagerDomain dom=loginService.getLoginManager(d);
				if(null!=dom){
					returnMap.put("result", "failed");
					returnMap.put("msg", "用户已存在");
					return returnMap;
				}
				d.setPassword(password);
				d.setTel(tel);
				d.setId(UUID.randomUUID().toString().replaceAll("-", ""));
				loginService.insertRegister(d);
			}else{
				returnMap.put("result", "failed");
				returnMap.put("msg", "请重新获取验证码验证");
				return returnMap;
			}
			/*ManagerDomain d=new ManagerDomain();
			d.setAccount(username);
			ManagerDomain dom=loginService.getLoginManager(d);
			if(null!=dom){
				returnMap.put("result", "failed");
				returnMap.put("msg", "用户已存在");
				return returnMap;
			}
			d.setPassword(password);
			d.setTel(tel);
			d.setId(UUID.randomUUID().toString().replaceAll("-", ""));
			loginService.insertRegister(d);*/
		} catch (Exception e) {
			returnMap.put("result", "failed");
			returnMap.put("msg", e.getMessage());
			e.printStackTrace();
			return returnMap;
		}
		returnMap.put("result", "success");
		return returnMap;
	}
	@ResponseBody
	@RequestMapping(value="/inputNewPassword",method=RequestMethod.POST)
	public Map<String, Object>  inputNewPassword(ModelMap modelMap,HttpServletRequest request){
		Map<String, Object> returnMap=this.getYzmAndTel(request);
		return returnMap;
	}
	
	@ResponseBody
	@RequestMapping(value="/updateUser",method=RequestMethod.POST)
	public Map<String, Object>  updateUser(ModelMap modelMap,HttpServletRequest request){
		Map<String, Object> returnMap=loginService.updateUser(request);
		return returnMap;
	}
	

	private Map<String, Object> getYzmAndTel(HttpServletRequest request) {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		String tel = request.getParameter("tel");
		String yzm = request.getParameter("yzm");
		HttpSession session = request.getSession();
		String sessionYzm=(String) session.getAttribute("yzm");
		if(null==sessionYzm || null==yzm){
			returnMap.put("result", "failed");
			returnMap.put("msg", "验证码错误");
			return returnMap;
		}else if(!sessionYzm.equals(yzm)){
			returnMap.put("result", "failed");
			returnMap.put("msg", "验证码错误");
			return returnMap;
		}
		String sessionTel=(String) session.getAttribute("tel");
		if(null!=sessionTel && null!=tel && sessionTel.equals(tel)){
			ManagerDomain d=new ManagerDomain();
			d.setTel(tel);
			ManagerDomain dom=loginService.getLoginManager(d);
			if(null!=dom){
				returnMap.put("result", "success");
				returnMap.put("data", dom);
				return returnMap;
			}
		}else{
			returnMap.put("result", "failed");
			returnMap.put("msg", "请重新获取验证码验证");
			return returnMap;
		}
		return returnMap;
	}

	@RequestMapping(value="/uploadimge",method=RequestMethod.POST)
	public String uploadimge(MultipartFile file,ModelMap modelMap,HttpServletRequest request){
		try {
			String colorName=request.getParameter("colorName");
			String colorType=request.getParameter("colorType");
			String roleType =request.getParameter("roleType");
			MultipartFile imgs=file;
			String filepath = request.getServletContext().getRealPath("/image");
			if(imgs!=null && !imgs.isEmpty()){
				boolean falg = BaiduPush.YzImgType(imgs);
				if (falg) {
					BaiduPush.saveFile(imgs, filepath,roleType+"_"+colorType);
				} else {
					System.out.println("图片格式不正确");
				}
			}
			loginService.updateRole(colorName,colorType,roleType);
			

		} catch (Exception e) {
			e.printStackTrace();
		}
		return this.oneRolePage(modelMap, request);
//		return "redirect:/login/imgInfo.action";
	}
	
	@RequestMapping(value="/saveRoleVo",method=RequestMethod.POST)
	public String saveRoleVo(@RequestParam MultipartFile file1,@RequestParam MultipartFile file2,
			@RequestParam MultipartFile file3,@RequestParam MultipartFile file4,
			@RequestParam MultipartFile file5,ModelMap modelMap,HttpServletRequest request){
		try {
			String filepath = request.getServletContext().getRealPath("/image");
			String roleType =request.getParameter("roleType");
			if(null==roleType || "".equals(roleType) || roleType.split("-").length!=2){
				return this.oneRolePage(modelMap, request);
			}
			roleType=roleType.split("-")[0];
			if(file1!=null && !file1.isEmpty()){
				boolean falg = BaiduPush.YzImgType(file1);
				if (falg) {
					BaiduPush.saveFile(file1, filepath,roleType+"_c_a");
				} else {
					System.out.println("图片格式不正确");
				}
			}
			if(file2!=null && !file2.isEmpty()){
				boolean falg = BaiduPush.YzImgType(file2);
				if (falg) {
					BaiduPush.saveFile(file2, filepath,roleType+"_c_b");
				} else {
					System.out.println("图片格式不正确");
				}
			}
			if(file3!=null && !file3.isEmpty()){
				boolean falg = BaiduPush.YzImgType(file3);
				if (falg) {
					BaiduPush.saveFile(file3, filepath,roleType+"_c_c");
				} else {
					System.out.println("图片格式不正确");
				}
			}
			if(file4!=null && !file4.isEmpty()){
				boolean falg = BaiduPush.YzImgType(file4);
				if (falg) {
					BaiduPush.saveFile(file4, filepath,roleType+"_c_d");
				} else {
					System.out.println("图片格式不正确");
				}
			}
			if(file5!=null && !file5.isEmpty()){
				boolean falg = BaiduPush.YzImgType(file5);
				if (falg) {
					BaiduPush.saveFile(file5, filepath,roleType+"_c_e");
				} else {
					System.out.println("图片格式不正确");
				}
			}
			loginService.insertRoleVo(request);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return this.roleList(modelMap, request);
	}
	
	@RequestMapping(value="/imgInfo",method=RequestMethod.GET)
	public String imgInfo(ModelMap modelMap,HttpServletRequest request){
		List <ImgDomain> list =loginService.getImgInfo();
		for(ImgDomain i:list){
			modelMap.put(i.getType(), i.getColorName());
		}
		return "role/img";
	}
	
	@RequestMapping(value="/updateManager.action",method=RequestMethod.GET)
	public String updateManager(ModelMap modelMap,HttpServletRequest request){
		return "role/password";
	}
	@RequestMapping(value="/addRolePage.action",method=RequestMethod.GET)
	public String addRolePage(ModelMap modelMap,HttpServletRequest request){
		return "role/addRolePage";
	}
	
	@ResponseBody
	@RequestMapping(value="/updatePassword",method=RequestMethod.POST)
	public Map<String, Object>  updatePassword(ModelMap modelMap,HttpServletRequest request){
		Map<String, Object> returnMap=loginService.updatePassword(request);
		return returnMap;
	}
		
	@RequestMapping(value="/roleList.action",method=RequestMethod.GET)
	public String roleList(ModelMap modelMap,HttpServletRequest request){
		return "role/roleList";
	
	}
	@ResponseBody
	@RequestMapping(value = "/roleListView.action", method = RequestMethod.GET)
	public Map<String, Object> roleListView(HttpServletRequest request,
			@RequestParam(required = false, defaultValue = "0") int start,
			@RequestParam(required = false, defaultValue = "10") int length) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			// 处理分页
			if (length == -1) {
				length = Integer.MAX_VALUE;
			}
			int page = start / length + 1;
			// 处理快速查询条件
			Role param = new Role();
			// 获取分页数据
			PageInfo<Role> list = loginService.findRoleList(page, length, param);
			// 设置返回结果内容
			returnMap.put("result", "success");
			returnMap.put("recordsFiltered", list.getTotal());
			returnMap.put("recordsTotal", list.getTotal());
			returnMap.put("data", list.getList());
		} catch (Exception ex) {
			logger.error(ex);
			returnMap.put("result", "failed");
			returnMap.put("msg", ex.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping(value="/oneRolePage.action",method=RequestMethod.GET)
	public String oneRolePage(ModelMap modelMap,HttpServletRequest request){
		String roleType=request.getParameter("roleType");
		Role role =new Role();
		role.setRole_type(roleType);
		role=loginService.getRole(role);
		modelMap.put("role", role);
		return "role/rolePage";
	}

}
