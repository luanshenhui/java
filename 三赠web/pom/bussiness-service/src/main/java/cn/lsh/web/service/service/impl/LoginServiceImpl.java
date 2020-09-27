package cn.lsh.web.service.service.impl;

import java.net.URLDecoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.TreeMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import login.model.Cvo;
import login.model.DrewVo;
import login.model.FoltVo;
import login.model.FoltVoDraw;
import login.model.GroupUserVo;
import login.model.RoleVo;

import org.springframework.stereotype.Repository;

import cn.lsh.web.mapper.login.dao.LoginDao;
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
import cn.lsh.web.service.service.MapKeyComparator;

import com.github.pagehelper.PageInfo;

@Repository("loginService")
public class LoginServiceImpl implements LoginService{

	
	@Resource
	private LoginDao loginDao;

	@Override
	public PageInfo<ColorUserVo> findByWhere(int page, int length,
			ColorUserVo param) throws Exception {
		PageInfo<ColorUserVo> l;
		try {
			l = loginDao.findByWhere(page,length,param);
			for(ColorUserVo u:l.getList()){
				if(null==u.getGhA()){
					u.setGhA("0");
				}
				if(null==u.getGhB()){
					u.setGhB("0");
				}
				if(null==u.getGhC()){
					u.setGhC("0");
				}
				if(null==u.getGhD()){
					u.setGhD("0");
				}
				if(null==u.getGhE()){
					u.setGhE("0");
				}
			}
			return l;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}


	@Override
	public PageInfo<GroupUserVo> groupListView(int page, int length,
			GroupDomain param) {
		return loginDao.groupListView(page,length,param);
	}


	@Override
	public List<GroupUserVo> getGroupUserVoList(GroupDomain g) {
		return loginDao.getGroupUserVoList(g);
	}


	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public List<DrewVo> getStreetDrew(GroupDomain group, HttpServletRequest request) {
		String month=request.getParameter("month");
		if(null==month || month.equals("")){
			group.setNowDate(this.getNowYear("yyyy-MM"));
		}else{
			group.setNowDate(this.getNowMonth(month));
		}
		List<FoltVo> vo=loginDao.getStreetDrew(group);
		List<DrewVo> list=new ArrayList<DrewVo>();
		List<Role> rolelist=loginDao.getRoleList(new Role());
		for(Role r:rolelist){
			DrewVo v=new DrewVo();
			v.setLabel(r.getRole_name());
			if(r.getRole_type().equals("a")){
				v.setColor("#ffce54");
			}else if(r.getRole_type().equals("b")){
				v.setColor("#3DB9D3");
			}else if(r.getRole_type().equals("c")){
				v.setColor("#ff0000");
			}else if(r.getRole_type().equals("d")){
				v.setColor("#df4782");
			}else if(r.getRole_type().equals("e")){
				v.setColor("#000079");
			}else if(r.getRole_type().equals("f")){
				v.setColor("green");
			}else if(r.getRole_type().equals("g")){
				v.setColor("pink");
			}else if(r.getRole_type().equals("h")){
				v.setColor("#"+this.getFourRandom()+"99");
			}else{
				v.setColor("#"+this.getFourRandom()+"00");
			}
			Map map=initMap();
			for(int a=0;a<vo.size();a++){
				if(vo.get(a).getRole_type().equals(r.getRole_type())){
					map.put(vo.get(a).getTime(), vo.get(a).getCount());
				}
			}
			v.setData(initArr(map));
			list.add(v);
		}
		return list;
	}

    private String getNowMonth(String month) {
		String year=month.split("-")[0];
		month=month.split("-")[1];
		if(month.equals("Jan")){
			month="01";
		}else if(month.equals("Feb")){
			month="02";
		}else if(month.equals("Mar")){
			month="03";
		}else if(month.equals("Apr")){
			month="04";
		}else if(month.equals("May")){
			month="05";
		}else if(month.equals("Jun")){
			month="06";
		}else if(month.equals("Jul")){
			month="07";
		}else if(month.equals("Aug")){
			month="08";
		}else if(month.equals("Sep")){
			month="09";
		}else if(month.equals("Oct")){
			month="10";
		}else if(month.equals("Nov")){
			month="11";
		}else if(month.equals("Dec")){
			month="12";
		}
		return year+"-"+month;
	}


	private  String getFourRandom(){
        Random random = new Random();
        String fourRandom = random.nextInt(10000) + "";
        int randLength = fourRandom.length();
        if(randLength<4){
          for(int i=1; i<=4-randLength; i++)
              fourRandom = "0" + fourRandom  ;
      }
        return fourRandom;
    }


	@SuppressWarnings("rawtypes")
	private Object[] initArr(Map map) {
		List l=initAttay(map);
		return  l.toArray();
	}


	@SuppressWarnings({ "rawtypes", "unchecked" })
	private List initAttay(Map map) {
//		map = new TreeMap<String, String>(new Comparator<String>(){
//            public int compare(String obj1, String obj2) {
//                return obj2.compareTo(obj1);
//            }
//        });
		map=this.sortMapByKey(map);
		Set<Integer> keySet = map.keySet();
		Iterator<Integer> it = keySet.iterator();
		List list = new ArrayList();
		while (it.hasNext()) {
			List l = new ArrayList<String>();
			Object key = it.next();
			Object value = map.get(key);
			l.add(key);
			l.add(value);
			list.add(l);
		}
		return list;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private Map sortMapByKey(Map map) {
		if (map == null || map.isEmpty()) {
			return null;
		}

		Map<String, String> sortMap = new TreeMap<String, String>(
				new MapKeyComparator());

		sortMap.putAll(map);
		return sortMap;
	}


	@SuppressWarnings({ "unchecked", "rawtypes" })
	private Map initMap() {
		Map map=new HashMap<String, String>();
		for(int i=1;i<=31;i++){
			if(i<10){
				map.put("0"+i, "0");
			}else{
				map.put(String.valueOf(i), "0");
			}
		}
		return map;
	}


	@Override
	public List<AreaDomain> getProvinceList(AreaDomain areaDomain) {
		return loginDao.getProvinceList(areaDomain);
	}


	public String getNowYear(String str){
		Date d = new Date();  
		SimpleDateFormat sdf = new SimpleDateFormat(str);  
		return sdf.format(d); 
		
	}


	@Override
	public String getSysTime(String string) {
		return getNowYear(string);
	}


	@Override
	public List<ColorUserVo> getUserVoList(ColorUserVo user) {
		List<ColorUserVo> list=loginDao.getUserVoList(user);
		for(ColorUserVo u:list){
			if(null==u.getGhA()){
				u.setGhA("0");
			}
			if(null==u.getGhB()){
				u.setGhB("0");
			}
			if(null==u.getGhC()){
				u.setGhC("0");
			}
			if(null==u.getGhD()){
				u.setGhD("0");
			}
			if(null==u.getGhE()){
				u.setGhE("0");
			}
		}
		return list;
	}


	public int getMonthWeek (String date) throws Exception {   
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");  
	    Date s = sdf.parse(date);  
	    Calendar ca = Calendar.getInstance();  
//	    ca.setTime(new Date());
	    ca.setTime(s);  
//	    ca.setFirstDayOfWeek(Calendar.MONDAY);  
//	    System.out.println(ca.getActualMaximum(Calendar.WEEK_OF_MONTH));
		return ca.getActualMaximum(Calendar.WEEK_OF_MONTH);  
	}


	@Override
	  public List<String> printWeeks(HttpServletRequest request) throws ParseException {
	        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	        Calendar calendar = Calendar.getInstance();
	        String year=request.getParameter("month");
	        if(null==year || year.equals("")){
	        	calendar.set(Calendar.DATE, 1);
			}else{
				Date date = format.parse(this.getNowMonth(year)+"-01");  
			    calendar.setTime(date);
			}
	        int month = calendar.get(Calendar.MONTH);
	        List<String> l=new ArrayList<String>(); 
	        while (calendar.get(Calendar.MONTH) == month) {
//	            if (calendar.get(Calendar.DAY_OF_WEEK) == Calendar.MONDAY) {
	                StringBuilder builder = new StringBuilder();
	                builder.append(format.format(calendar.getTime()));
	                builder.append("/");
	                calendar.add(Calendar.DATE, 6);
	                builder.append(format.format(calendar.getTime()));
	                System.out.println(builder.toString());
	                l.add(builder.toString());
//	            }
	            calendar.add(Calendar.DATE, 1);
	        }
			return l;
	    }

	

	@Override
	public List<FoltVoDraw> getOracleDrew(FoltDomain folt, List<String> listday)
			throws Exception {
		List<String> colorList=new ArrayList<String>();
		colorList.add("c_a");
		colorList.add("c_b");
		colorList.add("c_c");
		colorList.add("c_d");
		colorList.add("c_e");
		List<FoltVoDraw> foltList=new ArrayList<FoltVoDraw>();
		for(String c:colorList){
			FoltVoDraw fo=new FoltVoDraw();
			List<Integer> data=new ArrayList<Integer>();
			for(String s:listday){
				FoltVo v=new FoltVo();
				v.setBeginTime(s.split("/")[0].toString());
				v.setOverTime(s.split("/")[1].toString());
				v.setFoltColor(c);
				v.setPersonId(folt.getPerson_id());
				Integer i=loginDao.getOracleDrew(v);
				data.add(i);
			}
			fo.setColor(getColor(c));
			fo.setData(data);
			fo.setName(getName(c));
			foltList.add(fo);
		}
//		int d= getMonthWeek(getNowYear("yyyy-MM"));
		return foltList;
	}


	private String getName(String c) {
		if(c.equals("c_a")){
			return "光环颜色1";
		}else if(c.equals("c_b")){
			return "光环颜色2";
		}else if(c.equals("c_c")){
			return "光环颜色3";
		}else if(c.equals("c_d")){
			return "光环颜色4";
		}else if(c.equals("c_e")){
			return "光环颜色5";
		}
		return "";
	}


	private String getColor(String c) {
		if(c.equals("c_a")){
			return "yellow";
		}else if(c.equals("c_b")){
			return "green";
		}else if(c.equals("c_c")){
			return "red";
		}else if(c.equals("c_d")){
			return "black";
		}else if(c.equals("c_e")){
			return "blue";
		}
		return "";
	}


	@Override
	public ManagerDomain getLoginManager(ManagerDomain m) {
		return loginDao.getLoginManager(m);
	}


	@Override
	public void createPerson(PersonDomain person,String groupId) throws Exception{
		try {
			if(null==person.getArea()){
				throw new Exception("用户定位失败");
			}else{
				String area=URLDecoder.decode(person.getArea(), "UTF-8");
				person.setArea(area);
			}
			person.setCreate_time(this.getSysTime("yyyy-MM-dd HH:mm:ss"));
			AreaDomain area=loginDao.getProvinceCode(person);
			if(null==area){
				throw new Exception("用户定位失败");
			}
			person.setArea(area.getProvinceid());
			loginDao.createPerson(person);
			GroupDomain group=new GroupDomain();
			if(null!=person.getType() && person.getType().equals("2")){
				group.setApp_id(person.getPerson_id());
				group.setPerson_id(groupId);
			}else{
				group.setApp_id(person.getPerson_id());
				group.setPerson_id(person.getPerson_id());
			}
			loginDao.createGroup(group);
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("创建异常");
		}
		
	}

	

	@Override
	public void insertFolt(FoltDomain folt) throws Exception {
		try {
			if(null==folt.getC_a()){
				folt.setC_a("0");
			}
			if(null==folt.getC_b()){
				folt.setC_b("0");
			}
			if(null==folt.getC_c()){
				folt.setC_c("0");
			}
			if(null==folt.getC_d()){
				folt.setC_d("0");
			}
			if(null==folt.getC_e()){
				folt.setC_e("0");
			}
			folt.setCreate_time(this.getSysTime("yyyy-MM-dd HH:mm:ss"));
			PersonDomain person =new PersonDomain();
			person.setPerson_id(folt.getPerson_id());
			person =loginDao.selectPerson(person);
			folt.setRole_type(person.getName());
			loginDao.insertFolt(folt);
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		
	}


	@Override
	public List<Role> getRolelist(Role role) throws Exception{
		return loginDao.getRoleList(role);
	}


	@Override
	public void updateImgName(ImgDomain img) {
		loginDao.updateImgName(img);
		
	}


	@Override
	public List<ImgDomain> getImgInfo() {
		return loginDao.getImgInfo(new ImgDomain());
	}


	@Override
	public void insertRegister(ManagerDomain d) {
		loginDao.insertRegister(d);
		
	}

	private boolean pwdOkS(String password, String passwordConfirm) {
		if(null!=password && null!=passwordConfirm && password.length()>5 && passwordConfirm.equals(password)){
			return true;
		}
		return false;
	}

	@Override
	public Map<String, Object> updateUser(HttpServletRequest request) {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			String account = request.getParameter("username");
			String password = request.getParameter("password");
			String passwordConfirm = request.getParameter("passwordConfirm");
			HttpSession session = request.getSession();
			String sessionTel=(String) session.getAttribute("tel");
			if(null==sessionTel || null==account || "".equals(account)){
				returnMap.put("result", "failed");
				returnMap.put("msg", "你可能进行非法操作，请从新申请修改密码");
				return returnMap;
			}
			if(!this.pwdOkS(password,passwordConfirm)){
				returnMap.put("result", "failed");
				returnMap.put("msg", "输入密码不一致");
				return returnMap;
			}
			ManagerDomain d=new ManagerDomain();
			d.setAccount(account);
			d.setPassword(password);
			d.setTel(sessionTel);
			loginDao.updateUser(d);
			returnMap.put("result", "success");
			returnMap.put("data", "");
			return returnMap;
		} catch (Exception e) {
			returnMap.put("result", "failed");
			returnMap.put("msg", e.getMessage());
			e.printStackTrace();
		}
		return returnMap;
	}


	@Override
	public Map<String, Object> updatePassword(HttpServletRequest request) {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			String password = request.getParameter("password");
			String passwordConfirm = request.getParameter("passwordConfirm");
			ManagerDomain user=(ManagerDomain) request.getSession().getAttribute("userSession");
			if(!this.pwdOkS(password,passwordConfirm)){
				returnMap.put("result", "failed");
				returnMap.put("msg", "输入密码不一致");
				return returnMap;
			}
			if(null!=user){
				ManagerDomain d=new ManagerDomain();
				d.setAccount(user.getAccount());
				d.setPassword(password);
				loginDao.updateUser(d);
				returnMap.put("result", "success");
				returnMap.put("data", "");
				return returnMap;
			}
		} catch (Exception e) {
			returnMap.put("result", "failed");
			returnMap.put("msg", e.getMessage());
			e.printStackTrace();
		}
		return returnMap;
	}


	@Override
	public PageInfo<Role> findRoleList(int page, int length, Role param) {
		return loginDao.findRoleList(page,length,param);
	}


	@Override
	public Role getRole(Role role) {
		return loginDao.getRole(role);
	}


	@Override
	public void updateRole(String colorName, String colorType,
			String roleType) {
		Role role=new Role();
		if(colorType.equals("c_a")){
			role.setC_a(colorName);
		}else if(colorType.equals("c_b")){
			role.setC_b(colorName);
		}else if(colorType.equals("c_c")){
			role.setC_c(colorName);
		}else if(colorType.equals("c_d")){
			role.setC_d(colorName);
		}else if(colorType.equals("c_e")){
			role.setC_e(colorName);
		}
		role.setRole_type(roleType);
		loginDao.updateRole(role);
		
	}


	@Override
	public List<RoleVo> getRolelistVo(Role role) {
		List<Role> list=loginDao.getRoleList(role);
		List<RoleVo> volist=new ArrayList<RoleVo>();
		for(Role r:list){
			RoleVo v=new RoleVo();
			v.setRole_name(r.getRole_name());
			v.setRole_type(r.getRole_type());
			List<Cvo> l=new ArrayList<Cvo>();
			Cvo c1=new Cvo();
			c1.setItemColor("image/"+r.getRole_type()+"_c_a.png");
			c1.setItemName(r.getC_a());
			Cvo c2=new Cvo();
			c2.setItemColor("image/"+r.getRole_type()+"_c_b.png");
			c2.setItemName(r.getC_b());
			Cvo c3=new Cvo();
			c3.setItemColor("image/"+r.getRole_type()+"_c_c.png");
			c3.setItemName(r.getC_c());
			Cvo c4=new Cvo();
			c4.setItemColor("image/"+r.getRole_type()+"_c_d.png");
			c4.setItemName(r.getC_d());
			Cvo c5=new Cvo();
			c5.setItemColor("image/"+r.getRole_type()+"_c_e.png");
			c5.setItemName(r.getC_e());
			l.add(c1);
			l.add(c2);
			l.add(c3);
			l.add(c4);
			l.add(c5);
			v.setList(l);
			volist.add(v);
		}
		return volist;
	}


	@Override
	public void insertRoleVo(HttpServletRequest request) throws Exception{
		String roleType=request.getParameter("roleType").toString().split("-")[0];
		String roleName=request.getParameter("roleType").toString().split("-")[1];	
		String c_a=request.getParameter("c_a");
		String c_b=request.getParameter("c_b");
		String c_c=request.getParameter("c_c");
		String c_d=request.getParameter("c_d");
		String c_e=request.getParameter("c_e");
		Role r=new Role();
		r.setC_a(c_a);
		r.setC_b(c_b);
		r.setC_c(c_c);
		r.setC_d(c_d);
		r.setC_e(c_e);
		r.setRole_name(roleName);
		r.setRole_type(roleType);
		loginDao.insertRoleVo(r);
	}


	@Override
	public List<RolePersonDomain> getAllList(RolePersonDomain rolePersonDomain) {
		return loginDao.getAllList(rolePersonDomain);
	}


	@Override
	public List<GroupDomain> selectWatchNum(GroupDomain group) {
		return loginDao.selectWatchNum(group);
	}


	@Override
	public PersonDomain getClientPerson(PersonDomain personDomain) {
		return loginDao.getClientPerson(personDomain);
	}


	@Override
	public List<String> getGroupPerson(FoltDomain folt) {
		return loginDao.getGroupPerson(folt);
	}


	@Override
	public String getMsg(FoltDomain folt) {
		List<ImgDomain> list=loginDao.getMsg(folt);
		Map<String, String> map=new HashMap<String, String>();
		for(ImgDomain f :list){
			map.put(f.getType(), f.getColorName());
		}
		if(null!=folt.getC_a()){
			return (String)map.get("c_a");
		}else if(null!=folt.getC_b()){
			return (String)map.get("c_b");
		}else if(null!=folt.getC_c()){
			return (String)map.get("c_c");
		}else if(null!=folt.getC_d()){
			return (String)map.get("c_d");
		}else if(null!=folt.getC_e()){
			return (String)map.get("c_e");
		}
		return "";
	}


	@Override
	public PersonDomain selectPerson(PersonDomain person) {
		return loginDao.selectPerson(person);
	}


	public LoginDao getLoginDao() {
		return loginDao;
	}


	public void setLoginDao(LoginDao loginDao) {
		this.loginDao = loginDao;
	}

	
}
