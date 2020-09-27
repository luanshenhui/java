package com.dpn.ciqqlc.http;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import asposewobfuscated.rq;

import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.common.util.PageBean;
import com.dpn.ciqqlc.http.form.AuthoritiesForm;
import com.dpn.ciqqlc.http.form.OrganizesForm;
import com.dpn.ciqqlc.http.form.ResourceForm;
import com.dpn.ciqqlc.http.form.RolesForm;
import com.dpn.ciqqlc.http.form.UsersForm;
import com.dpn.ciqqlc.http.result.AjaxResult;
import com.dpn.ciqqlc.standard.model.AuthoritiesDTO;
import com.dpn.ciqqlc.standard.model.CodeLibraryDTO;
import com.dpn.ciqqlc.standard.model.DeptmentsDTO;
import com.dpn.ciqqlc.standard.model.OrganizesDTO;
import com.dpn.ciqqlc.standard.model.Res_rolesDTO;
import com.dpn.ciqqlc.standard.model.ResourcesDTO;
import com.dpn.ciqqlc.standard.model.RolesDTO;
import com.dpn.ciqqlc.standard.model.UserConfigurationDTO;
import com.dpn.ciqqlc.standard.model.UserConfigurationModel;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.model.UserVisit;
import com.dpn.ciqqlc.standard.model.UsersDTO;
import com.dpn.ciqqlc.standard.model.VisitConfigurationDTO;
import com.dpn.ciqqlc.standard.service.CodeLibraryService;
import com.dpn.ciqqlc.standard.service.CommonUtilDbService;
import com.dpn.ciqqlc.standard.service.UserConfigDbService;
import com.dpn.ciqqlc.standard.service.UserManageDbService;
import com.dpn.ciqqlc.standard.service.UserManageFlowService;

/**
 * UserManageController.
 * 
 * @author
 * @since 1.0.0
 * @version 1.0.0
 */
/* *****************************************************************************
 * 备忘记录
 * -> 以"/users"作为URL前缀的action，进行用户管理的处理。
********************************************************************************
 * 变更履历
 * -> 
***************************************************************************** */
@Controller
@RequestMapping(
    value = "/users")
public class UserManageController {
	/**
	 * path
	 */
	private String path = "/users"; 
	/**
     * logger.
     * 
     * @since 1.0.0
     */
    private final Logger logger_ = LoggerFactory.getLogger(this.getClass());
    
    /**
     * DbServ.
     * 
     * @since 1.0.0
     */
    @Autowired
    @Qualifier("userManageDbServ")
    private UserManageDbService dbServ = null;
    
    /**
     * flowServ.
     * 
     * @since 1.0.0
     */
    @Autowired
    @Qualifier("userManageFlowService")
    private UserManageFlowService flowServ = null;
    
    /**
     * DbServ.
     * 
     * @since 1.0.0
     */
    @Autowired
    @Qualifier("commonUtilDbService")
    private CommonUtilDbService commDbServ = null;
    @Autowired
	@Qualifier("codeLibraryDb")
	private CodeLibraryService codeLibraryService = null;
    /*@Autowired
    @Qualifier("vslDecCiqFlowService")
    private VslDecCiqFlowService vslDecCiqFlow = null;*/
    
    @Autowired
    private UserConfigDbService userConfigDbService;
    
	/**
     * 查询组织列表
     * @param request
     * @return
     */
    @RequestMapping("/findOrganizes")
	public String findOrganizes(HttpServletRequest request,OrganizesForm org){
    	Map<String,String> map = new HashMap<String,String>();
		try{
			//分页处理
	        int pages = 1;
	        if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
	            pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
	        }
	        PageBean page_bean = new PageBean(pages, String.valueOf(Constants.PAGE_NUM));
			
			map.put("code", org.getOrgcode());
			map.put("name", org.getOrgname());
			map.put("type", org.getOrgtype());
			map.put("firstRcd", page_bean.getLow());
			map.put("lastRcd", page_bean.getHigh());
			
			List<OrganizesDTO> list = dbServ.findOrganizes(map);
			int counts = dbServ.findOrganizeCount(map);
			map =  null;
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
	        request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
	        request.setAttribute("counts",counts);
	        request.setAttribute("allPage", counts % page_bean.getPageSize()==0 ? (counts/page_bean.getPageSize()) : (counts/page_bean.getPageSize())+1);
	        request.setAttribute("orgcode",org.getOrgcode());
	        request.setAttribute("orgname",org.getOrgname());
		} catch (Exception e) {
			logger_.error("***********/users/findOrganizes************",e);
		}finally{
			map =  null;
		}
		return "userManage/organizes/index";
	}
    
    /**
     * 跳转到新增组织
     * @param request
     * @return
     */
    @RequestMapping("/organizesforward")
	public String organizesforward(HttpServletRequest request){
		return "userManage/organizes/add";
	}
    
    /**
     * 新增组织
     * @param request
     * @param org
     * @return
     */
    @RequestMapping("/addOrganizes")
    public String addOrganizes(HttpServletRequest request,OrganizesForm org){
		String param_msg = "N";
		Map<String,String> map = new HashMap<String,String>();
    	try{
//			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
			
			map.put("code", org.getOrgcode());
			
			int counts = dbServ.findOrganizeCount(map);
			if (counts > 0) {
					request.setAttribute(Constants.ERROR_INFO, "该单位代码已经存在");
					return "userManage/organizes/add";
			} else {
				map.put("orgname", org.getOrgname());
				map.put("portcode", org.getPortcode());
				map.put("orgtype", org.getOrgtype());
				map.put("directyUnderOrg", org.getDirectyUnderOrg());
				dbServ.addOrganizes(map);
				request.setAttribute(Constants.SUCCESS_INFO, "组织添加成功");
				param_msg = "Y";
			}
		} catch (Exception e) {
			
			logger_.error("***********/users/addOrganizes************",e);
			request.setAttribute(Constants.ERROR_INFO, "新建时异常");
			return "userManage/organizes/add";
		}finally{
			map =  null;
		}
		return "redirect:"+this.path+"/findOrganizes?param_msg="+param_msg;
	}
    
	/**
     * 按组织代码查询出组织跳转至修改页面
     * @param request
     * @param orgcode
     * @return
     */
    @RequestMapping("/toUpdateOrganizes")
    public String toUpdateOrganizes(HttpServletRequest request,
    			@RequestParam(value="orgcode", required=true)String orgcode){
    	try{
			OrganizesDTO orgDto = dbServ.findOrganizesByCode(orgcode);
			request.setAttribute("orgDto", orgDto);
		} catch (Exception e) {
			
			logger_.error("***********/users/toUpdateOrganizes************",e);
		}
    	return "userManage/organizes/update";
	}
    
    
    /**
     * 修改组织
     * @param request
     * @param org
     * @return
     */
    @RequestMapping("/updateOrganizes")
    public String updateOrganizes(HttpServletRequest request,OrganizesForm org){
		String param_msg = "N";
		Map<String,String> map = new HashMap<String,String>();
    	try{
//			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
			
			map.put("code", org.getOrgcode());
			map.put("orgname", org.getOrgname());
			map.put("portcode", org.getPortcode());
			map.put("orgtype", org.getOrgtype());
			map.put("directyUnderOrg", org.getDirectyUnderOrg());
			dbServ.updateOrganizes(map);
			param_msg = "Y";
		} catch (Exception e) {
			
			logger_.error("***********/users/updateOrganizes************",e);
			return "redirect:"+this.path+"/toUpdateOrganizes?param_msg="+param_msg+"&orgcode="+org.getOrgcode();
		}finally{
			map =  null;
		}
		return "redirect:"+this.path+"/findOrganizes?param_msg="+param_msg;
	}

    
    /**
     * 删除组织
     * @param request
     * @param org
     * @return
     */
    @RequestMapping("/delOrganizes")
    public String delOrganizes(HttpServletRequest request, @RequestParam(value="orgcode", required=true)String orgcode){
    	String param_msg = "N";
    	try{
//			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
			dbServ.delOrganizes(orgcode);
			param_msg = "Y";
		} catch (Exception e) {
			
			logger_.error("***********/users/delOrganizes************",e);
			return "redirect:"+this.path+"/findOrganizes?param_msg="+param_msg;
		}
		return "redirect:"+this.path+"/findOrganizes?param_msg="+param_msg;
	}
    
    
    /**
     * 查询用户列表
     * @param request
     * @return
     */
    @RequestMapping("/findUsers")
	public String findUsers(HttpServletRequest request,UsersForm userform){
    	Map<String,String> map = new HashMap<String,String>();
		try{
			//分页处理
	        int pages = 1;
	        if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
	            pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
	        }
	        PageBean page_bean = new PageBean(pages, String.valueOf(Constants.PAGE_NUM));
	       
			map.put("id", userform.getId());
			map.put("name", userform.getUsername());
			map.put("firstRcd", page_bean.getLow());
			map.put("lastRcd", page_bean.getHigh());
			List<UsersDTO> list = dbServ.findUsers(map);
			List<CodeLibraryDTO> dutyList = codeLibraryService.findCodeLibraryList("USER_DUTIES");
			int counts = dbServ.findUsersCount(map);
			request.setAttribute("dutyList", dutyList);
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
	        request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
            request.setAttribute("counts",counts);
	        request.setAttribute("allPage", counts % page_bean.getPageSize()==0 ? (counts/page_bean.getPageSize()) : (counts/page_bean.getPageSize())+1);
	        request.setAttribute("id",userform.getId());
	        request.setAttribute("name",userform.getUsername());
		} catch (Exception e) {
			
			logger_.error("***********/users/findOrganizes************",e);
		}finally{
			map =  null;
		}
		return "userManage/users/index";
	}
    
    
    /**
     * 跳转到新增用户
     * @param request
     * @return
     */
    @RequestMapping("/usersforward")
	public String usersforward(HttpServletRequest request){
    	try{
	    	List<OrganizesDTO> list  = dbServ.getAllOrgList();
	    	List<DeptmentsDTO> depyList  = dbServ.getAllDeptList();
	    	List<CodeLibraryDTO> dutyList = codeLibraryService.findCodeLibraryList("USER_DUTIES");
	    	request.setAttribute("dutyList", dutyList);
	    	request.setAttribute("list", list);
	    	request.setAttribute("depyList", depyList);
    	} catch (Exception e) {
			
			logger_.error("***********/users/usersforward************",e);
			request.setAttribute(Constants.ERROR_INFO, "组织代码加载异常");
			return "userManage/users/add";
		}
		return "userManage/users/add";
	}
    
    /**
     * 新增用户
     * @param request
     * @param org
     * @return
     */
    @RequestMapping("/addUsers")
    public String addUsers(HttpServletRequest request,UsersForm userform){
		String param_msg = "N";
		Map<String,String> map = new HashMap<String,String>();
    	try{
//			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
			
			map.put("id", userform.getId());
			
			int counts = dbServ.findUsersCount(map);
			if (counts > 0) {
					List<OrganizesDTO> list  = dbServ.getAllOrgList();
			    	List<DeptmentsDTO> depyList  = dbServ.getAllDeptList();
			    	request.setAttribute("list", list);
			    	request.setAttribute("depyList", depyList);
					request.setAttribute(Constants.ERROR_INFO, "该用户代码已经存在");
					return "userManage/users/add";
			}
			else {
				map.put("name", userform.getUsername());
				map.put("dept_code", userform.getDeptcode());
				map.put("level_code", userform.getLevelcode());
				map.put("org_code", userform.getOrgcode());
				map.put("fixed_phone", userform.getFixedphone());
				map.put("mobile_phone_no", userform.getMobilephone());
				map.put("card_no", userform.getCard_no());
				map.put("duties", userform.getDuties());
				dbServ.addUsers(map);
				param_msg = "Y";
			}
		} catch (Exception e) {
			
			logger_.error("***********/users/addUsers************",e);
			request.setAttribute(Constants.ERROR_INFO, "新建时异常");
			return "userManage/users/add";
		}finally{
			map =  null;
		}
		return "redirect:"+this.path+"/findUsers?param_msg="+param_msg;
	}
    
    /**
     * 跳转到添加角色页面
     * @param request
     * @param userId
     * @return
     */
    @RequestMapping("/toAddUserAuth")
    public String toAddUserAuth(HttpServletRequest request,
    		@RequestParam(value = "uid" , required = true) String userId){
    	
    	try {
			List<RolesDTO> list = dbServ.toAddUserAuth(userId);
			request.setAttribute("list", list);
		} catch (Exception e) {
			
			logger_.error("*******user/toAddUserAuth********************",e);
			request.setAttribute(Constants.ERROR_INFO, "查询失败");
		}
    	request.setAttribute("userCode", userId);
    	return "userManage/authorities/useradd";
    }
    
    @RequestMapping("/addUserAuth")
    public String addUserAuth(HttpServletRequest request,
    		AuthoritiesForm authForm){
    	String param_msg = "N";
    	try {
    		for (int i = 0; authForm.getRolesbox() != null
					&& i < authForm.getRolesbox().length; i++) {
				Map<String,String> map = new HashMap<String,String>();
				map.put("usercode", authForm.getUsercode());
				map.put("rolesbox", authForm.getRolesbox()[i]);
				int selectCount = dbServ.selectAuthor(map);
				if (selectCount > 0) {
					request.setAttribute(Constants.ERROR_INFO, "角色填加错误！");
					return "userManage/authorities/useradd";
				} else {
					dbServ.addUserAuth(map);
					param_msg = "Y";
				}
			}
		} catch (Exception e) {
			
			logger_.error("*******user/toAddUserAuth********************",e);
			request.setAttribute(Constants.ERROR_INFO, "查询失败");
		}
    	
    	return "redirect:" + this.path + "/findAuth?param_msg="+param_msg;
    }
    
    /**
     * 按组织代码查看用户
     * @param request
     * @param orgcode
     * @return
     */
    @RequestMapping("/showUser")
    public String showUser(HttpServletRequest request,
    			@RequestParam(value="uid", required=true)String uid){
    	try{
    		UsersDTO userDto = dbServ.findUsersByCode(uid);
    		List<OrganizesDTO> list  = dbServ.getAllOrgList();
	    	List<DeptmentsDTO> depyList  = dbServ.getAllDeptList();
	    	List<CodeLibraryDTO> dutyList = codeLibraryService.findCodeLibraryList("USER_DUTIES");
			request.setAttribute("dutyList", dutyList);
	    	request.setAttribute("list", list);
	    	request.setAttribute("depyList", depyList);
			request.setAttribute("userDto", userDto);
		} catch (Exception e) {
			
			logger_.error("***********/users/showUser************",e);
		}
    	return "userManage/users/detail";
	}
    
    
    /**
     * 按组织代码查询出用户跳转至修改页面
     * @param request
     * @param orgcode
     * @return
     */
    @RequestMapping("/toUpdateUsers")
    public String toUpdateUsers(HttpServletRequest request,
    			@RequestParam(value="uid", required=true)String uid){
    	try{
    		UsersDTO userDto = dbServ.findUsersByCode(uid);
    		List<OrganizesDTO> list = dbServ.getAllOrgList();
	    	List<DeptmentsDTO> depyList = dbServ.getAllDeptList();
	    	List<CodeLibraryDTO> dutyList = codeLibraryService.findCodeLibraryList("USER_DUTIES");
	    	request.setAttribute("dutyList", dutyList);
	    	request.setAttribute("list", list);
	    	request.setAttribute("depyList", depyList);
			request.setAttribute("userDto", userDto);
		} catch (Exception e) {
			
			logger_.error("***********/users/toUpdateUsers************",e);
		}
    	return "userManage/users/update";
	}
    
    
    /**
     * 修改用户
     * @param request
     * @param org
     * @return
     */
    @RequestMapping("/updateUsers")
    public String updateUsers(HttpServletRequest request,UsersForm userform){
		String param_msg = "N";
		Map<String,String> map = new HashMap<String,String>();
    	try{
//			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
			
			map.put("id", userform.getId());
			map.put("name", userform.getUsername());
			map.put("org_code", userform.getOrgcode());
			map.put("dept_code", userform.getDeptcode());
			map.put("level_code", userform.getLevelcode());
			map.put("fixed_phone", userform.getFixedphone());
			map.put("mobile_phone_no", userform.getMobilephone());
			map.put("card_no", userform.getCard_no());
			map.put("duties", userform.getDuties());
			dbServ.updateUsers(map);
			param_msg = "Y";
			
		} catch (Exception e) {
			logger_.error("***********/users/updateUsers************",e);
			return "redirect:"+this.path+"/toUpdateUsers?param_msg="+param_msg+"&uid="+userform.getId();
		}finally{
			map =  null;
		}
		return "redirect:"+this.path+"/findUsers?param_msg="+param_msg;
	}
    
    /**
     * 用户启/停用
     * @param request
     * @param user_id, flag_op
     * @return
     */
    @RequestMapping("/updateUsersFlagOp")
    public String updateUsersFlagOp(HttpServletRequest request,String user_id, String flag_op) {
        String param_msg = "N";
        try{
            Map<String,String> map = new HashMap<String,String>();
            map.put("id", user_id);
            map.put("flag_op", flag_op);
            dbServ.updateUsersFlagOp(map);
            param_msg = "Y";
        }
        catch(Exception e) {
            logger_.error("***********/users/updateUsersFlagOp************"+e.getMessage(), e);
            return "redirect:"+this.path+"/toUpdateUsers?param_msg="+param_msg+"&uid="+user_id;
        }
        return "redirect:"+this.path+"/findUsers?param_msg="+param_msg;
    }

    
    /**
     * 修改用户密码
     * @param request
     * @param org
     * @return
     */
    @RequestMapping("/resetPwd")
    public String resetPwd(HttpServletRequest request, @RequestParam(value="uid", required=true)String uid){
		String param_msg = "N";
		Map<String,String> map = new HashMap<String,String>();
    	try{
//			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
			
			map.put("id", uid);
			/*map.put("modify_user",user.getId());*/
			dbServ.resetPwd(map);
			param_msg = "Y";
		} catch (Exception e) {
			
			logger_.error("***********/users/resetPwd************",e);
			return "redirect:"+this.path+"/findUsers?param_msg="+param_msg+"&uid="+uid;
		}finally{
			map =  null;
		}
		return "redirect:"+this.path+"/findUsers?param_msg="+param_msg;
	}
    
    /**
     * 删除用户
     * @param request
     * @param org
     * @return
     */
    @RequestMapping("/delUsers")
    public String delUsers(HttpServletRequest request, @RequestParam(value="uid", required=true)String uid){
    	String param_msg = "N";
    	try{
//			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
    	    flowServ.delUsers(uid);
			param_msg = "Y";
		}
    	catch(Exception e) {
			logger_.error("***********/users/delUsers************",e);
			return "redirect:"+this.path+"/findUsers?param_msg="+param_msg;
		}
		return "redirect:"+this.path+"/findUsers?param_msg="+param_msg;
	}
    
    /**
     * 查询角色列表
     * @param request
     * @return
     */
    @RequestMapping("/findRoles")
	public String findRoles(HttpServletRequest request,RolesForm rolesform){
    	Map<String,String> map = new HashMap<String,String>();
		try{
			//分页处理
	        int pages = 1;
	        if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
	            pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
	        }
	        PageBean page_bean = new PageBean(pages, String.valueOf(Constants.PAGE_NUM));
			
			map.put("code", rolesform.getRolesid());
			map.put("name", rolesform.getRolesname());
			map.put("firstRcd", page_bean.getLow());
			map.put("lastRcd", page_bean.getHigh());
			List<RolesDTO> list = dbServ.findRoles(map);
			int counts = dbServ.findRolesCount(map);
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
	        request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
	        request.setAttribute("counts",counts);
	        request.setAttribute("allPage", counts % page_bean.getPageSize()==0 ? (counts/page_bean.getPageSize()) : (counts/page_bean.getPageSize())+1);
	        request.setAttribute("rolesid",rolesform.getRolesid());
	        request.setAttribute("rolesname",rolesform.getRolesname());
		} catch (Exception e) {
			
			logger_.error("***********/users/findRoles************",e);
		}finally{
			map =  null;
		}
		return "userManage/roles/index";
	}
    
    
    /**
     * 跳转到新增角色
     * @param request
     * @return
     */
    @RequestMapping("/rolesforward")
	public String rolesforward(HttpServletRequest request){
		return "userManage/roles/add";
	}
    
    /**
     * 新增角色
     * @param request
     * @param org
     * @return
     */
    @RequestMapping("/addRoles")
    public String addRoles(HttpServletRequest request,RolesForm rolesform){
		String param_msg = "N";
		Map<String,String> map = new HashMap<String,String>();
    	try{
//			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
			
			map.put("code", rolesform.getRolesid());
			
			int counts = dbServ.findRolesCount(map);
			if (counts > 0) {
					request.setAttribute(Constants.ERROR_INFO, "该角色代码已经存在");
					return "userManage/roles/add";
			} else {
				map.put("name", rolesform.getRolesname());
				/*map.put("created_user",user.getId());*/
				
				dbServ.addRoles(map);
				param_msg = "Y";
			}
		} catch (Exception e) {
			
			logger_.error("***********/users/addRoles************",e);
			request.setAttribute(Constants.ERROR_INFO, "新建时异常");
			return "userManage/roles/add";
		}finally{
			map =  null;
		}
		return "redirect:"+this.path+"/findRoles?param_msg="+param_msg;
	}
    
       
    /**
     * 删除角色
     * @param request
     * @param org
     * @return
     */
    @RequestMapping("/delRoles")
    public String delRoles(HttpServletRequest request, @RequestParam(value="code", required=true)String code){
    	String param_msg = "N";
    	try{
//			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
			dbServ.delRoles(code);
			param_msg = "Y";
		} catch (Exception e) {
			
			logger_.error("***********/users/delRoles************",e);
			return "redirect:"+this.path+"/findRoles?param_msg="+param_msg;
		}
		return "redirect:"+this.path+"/findRoles?param_msg="+param_msg;
	}
    
    /**
     * 跳转到角色添加用户页面
     * @param request
     * @param authoritiesForm
     * @return
     */
    @RequestMapping("/toAddAuth")
    public String toAddAuth(HttpServletRequest request, @RequestParam(value = "code",required = true) String roleCode){
    	if (StringUtils.isNotBlank(roleCode)){
    		request.setAttribute("rolesCode", roleCode);
    		return "userManage/authorities/rolesadd";
    	}else{
    		return "";
    	}
    }
    
    @RequestMapping("/selectUserInfo")
	public String selectUserInfo(HttpServletRequest request,
			AuthoritiesForm authoritiesForm,String page){
		try{
			//分页处理
	        int pages = 1;
	        if(page != null && !"".equals(page)) {
	            pages = Integer.parseInt(page == null ? "1" : page);
	        }
	        PageBean page_bean = new PageBean(pages, String.valueOf(Constants.PAGE_NUM));
	        Map<String,String> map = new HashMap<String,String>();
			map.put("firstRcd", page_bean.getLow());
			map.put("lastRcd", page_bean.getHigh());
			map.put("userCode", authoritiesForm.getUsercode() == null ? "" : authoritiesForm.getUsercode().trim());
			map.put("orgCode", authoritiesForm.getOrgcode() == null ? "" : authoritiesForm.getOrgcode().trim());
			map.put("rolesCode", authoritiesForm.getRolescode());
			List<UsersDTO> list = this.dbServ.selectUserOrg(map);
			int counts = this.dbServ.selectUserOrgCount(map);
			request.setAttribute("list", list);
			request.setAttribute("rolesCode", authoritiesForm.getRolescode());
			request.setAttribute("usercode", authoritiesForm.getUsercode());
			request.setAttribute("orgcode", authoritiesForm.getOrgcode());
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
	        request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
	        request.setAttribute("counts",counts);
	        request.setAttribute("allPage", counts % page_bean.getPageSize()==0 ? (counts/page_bean.getPageSize()) : (counts/page_bean.getPageSize())+1);
		} catch (Exception e) {
			request.setAttribute("errorInfo", "操作失败");
			this.logger_.error("****usermanager/selectUserInfo",e);
		}
		return "userManage/authorities/rolesadd";
	}
    
    /**
     * 增加权限
     * @param request
     * @param auform
     * @return
     */
    @RequestMapping("/addAuth")
    public String addAuth(HttpServletRequest request , AuthoritiesForm auform){
    	
    	try{
    		UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
					Constants.USER_KEY);
	
			for (int i = 0; auform.getIsBuy() != null
					&& i < auform.getIsBuy().length; i++) {
				Map<String,String> map = new HashMap<String,String>();
				map.put("rolescode", auform.getRolescode());
				map.put("isbuy", auform.getIsBuy()[i]);
				if (user != null && StringUtils.isNotBlank(user.getName())){
					map.put("sessionName", user.getName());
				}
//				map.put("sessionOrgcode", user.getOrg_code());
				this.dbServ.addAuthRoles(map);
			}
    	}catch(Exception e){
    		this.logger_.error("***ERROR***usermanager/addAuth",e);
    		request.setAttribute("errorInfo", "操作失败");
    		return "userManage/authorities/rolesadd";
    	}
    	//跳转到权限查看列表页
    	request.setAttribute("rolesCode",auform.getRolescode());
    	 return "redirect:"+this.path+"/findAuth?param_msg=Y";
    }
    
    /**
     * 查询权限列表
     * @param request
     * @param authForm
     * @return
     */
    @RequestMapping("/findAuth")
    public String findAuths(HttpServletRequest request , AuthoritiesForm authForm){
    	Map <String,String> map = new HashMap<String,String>();
    	try{
    		int page = 1;
    		if (StringUtils.isNotBlank(request.getParameter("page"))){
    			page = Integer.valueOf(request.getParameter("page"));
    		}
    		PageBean pg = new PageBean(page,String.valueOf(Constants.PAGE_NUM));
    		
    		map.put("userId", authForm.getUserid());
    		map.put("roleId", authForm.getRolesid());
			map.put("firstRcd", pg.getLow());
			map.put("lastRcd", pg.getHigh());    		
    		
    		List<AuthoritiesDTO> authList = dbServ.findAuths(map);
    		int authCount = dbServ.findAuthCounts(map);
    		
			request.setAttribute("list", authList);
			request.setAttribute("pages", Integer.toString(page));// 当前页码
	        request.setAttribute("itemInPage", pg.getPageSize());// 每页显示的记录数
	        request.setAttribute("counts",authCount);
	        request.setAttribute("allPage", authCount % pg.getPageSize()==0 ? (authCount/pg.getPageSize()) : (authCount/pg.getPageSize())+1);
	        request.setAttribute("userid", authForm.getUserid());
	        request.setAttribute("roleid", authForm.getRolesid());
    	}catch(Exception e){
			
			logger_.error("***********/users/findAuths************",e);
    	}finally{
    		map = null;
    	}
    	return "userManage/authorities/index";
    }
    
    /**
     * 权限删除
     * */
    @RequestMapping("/delAuth")
    public String delAuth (HttpServletRequest request , AuthoritiesForm authForm){
    	String param_msg = "N";
    	try{
    		flowServ.delAuth(authForm);
			param_msg = "Y";
    	}catch(Exception e){
    		
    		this.logger_.error("****************/users/delAuth************************",e);
    	}
    	return "redirect:" + this.path + "/findAuth?param_msg="+param_msg;
    }
        
    /**
     * 根据用户角色查看用户资源
     */
    @RequestMapping("/showRes")
    public String findResByRole(HttpServletRequest request,
    		@RequestParam(value = "code", required = true)String roleId){
    	Map<String,String> map = new HashMap<String,String>();
    	try{
    		//分页处理
    		int pages = 1;
    		if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
    			pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
    		}
    		PageBean page_bean = new PageBean(pages, String.valueOf(Constants.PAGE_NUM));
    		
    		map.put("roleId", roleId);
    		map.put("firstRcd", page_bean.getLow());
    		map.put("lastRcd", page_bean.getHigh());
    		List<RolesDTO> list = dbServ.findRes(map);
    		int counts = dbServ.findResCount(map);
    		
    		request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
	        request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
	        request.setAttribute("counts",counts);
	        request.setAttribute("allPage", counts % page_bean.getPageSize()==0 ? (counts/page_bean.getPageSize()) : (counts/page_bean.getPageSize())+1);    		
    		request.setAttribute("roleId", roleId);
    	}catch(Exception e){
    		
    		this.logger_.error("***********/user/findResByRole***************",e);
    		request.setAttribute(Constants.ERROR_INFO, "查询失败");
    	}finally{
    		map = null;
    	}
    	return "userManage/resources/index";
    }
    
     /**
     * 查询资源列表
     * @param request
     * @return
     */
    @RequestMapping("/findRes")
	public String findRes(HttpServletRequest request,ResourceForm resourceform){
    	Map<String,String> map = new HashMap<String,String>();
		try{
			//分页处理
	        int pages = 1;
	        if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
	            pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
	        }
	        PageBean page_bean = new PageBean(pages, String.valueOf(Constants.PAGE_NUM));
			
			map.put("resid", resourceform.getResstring());
			map.put("name", resourceform.getResname());
			map.put("roleId", resourceform.getRoleId());
			map.put("firstRcd", page_bean.getLow());
			map.put("lastRcd", page_bean.getHigh());
			List<RolesDTO> list = dbServ.findRes(map);
			int counts = dbServ.findResCount(map);
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
	        request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
	        request.setAttribute("counts",counts);
	        request.setAttribute("allPage", counts % page_bean.getPageSize()==0 ? (counts/page_bean.getPageSize()) : (counts/page_bean.getPageSize())+1);
		} catch (Exception e) {
			
			logger_.error("***********/users/findRes************",e);
		}finally{
			map =  null;
		}
		return "userManage/resources/index";
	}
    
    
    /**
     * 跳转到新增资源
     * @param request
     * @return
     */
    @RequestMapping("/resforward")
	public String resforward(HttpServletRequest request){
		return "userManage/resources/add";
	}
    
    /**
     * 新增资源
     * @param request
     * @param org
     * @return
     */
    @RequestMapping("/addRes")
    public String addRes(HttpServletRequest request,ResourceForm resourceform){
		String param_msg = "N";
		Map<String,String> map = new HashMap<String,String>();
    	try{
			map.put("resid", resourceform.getResstring());
			
			int counts = dbServ.findResCount(map);
			if (counts > 0) {
					request.setAttribute(Constants.ERROR_INFO, "该资源代码已经存在");
					return "userManage/resources/add";
			} else {
				map.put("id", UUID.randomUUID().toString());
				map.put("name", resourceform.getResname());
				map.put("res_string", resourceform.getResstring());
				map.put("res_desc", resourceform.getResdesc());
				
				dbServ.addRes(map);
				
				request.getSession().getServletContext().removeAttribute("ALLURL");
				List<ResourcesDTO> resourceList = this.dbServ.getUserUrl(null);
				String[] urls = new String[resourceList.size()];
	            for (int i = 0; i < resourceList.size(); i++) {
	                urls[i] = resourceList.get(i).getRes_string();
	            }
				request.getSession().getServletContext().setAttribute("ALLURL", urls);
				param_msg = "Y";
			}
		} catch (Exception e) {
			
			logger_.error("***********/users/addRes************",e);
			request.setAttribute(Constants.ERROR_INFO, "新建时异常");
			return "userManage/resources/add";
		}finally{
			map =  null;
		}
		return "redirect:"+this.path+"/findRes?param_msg="+param_msg;
	}
    
    
    
    /**
     * 查询资源跳转至修改页面
     * @param request
     * @param orgcode
     * @return
     */
    @RequestMapping("/toUpdateRes")
    public String toUpdateRes(HttpServletRequest request,
    			@RequestParam(value="code", required=true)String code){
    	try{
    		ResourcesDTO resDto = dbServ.findResByCode(code);
			request.setAttribute("resDto", resDto);
		} catch (Exception e) {
			
			logger_.error("***********/users/toUpdateRes************",e);
		}
    	return "userManage/resources/update";
	}
    
    
    /**
     * 修改资源
     * @param request
     * @param org
     * @return
     */
    @RequestMapping("/updateRes")
    public String updateRes(HttpServletRequest request,ResourceForm resourceform){
		String param_msg = "N";
		Map<String,String> map = new HashMap<String,String>();
    	try{
			
			map.put("id", resourceform.getId());
			map.put("name", resourceform.getResname());
			map.put("res_string", resourceform.getResstring());
			map.put("res_desc", resourceform.getResdesc());
			dbServ.updateRes(map);
			request.getSession().getServletContext().removeAttribute("ALLURL");
			List<ResourcesDTO> resourceList = this.dbServ.getUserUrl(null);
			String[] urls = new String[resourceList.size()];
            for (int i = 0; i < resourceList.size(); i++) {
                urls[i] = resourceList.get(i).getRes_string();
            }
			request.getSession().getServletContext().setAttribute("ALLURL", urls);
			param_msg = "Y";
		} catch (Exception e) {
			
			logger_.error("***********/users/updateRes************",e);
			return "redirect:"+this.path+"/toUpdateRes?param_msg="+param_msg+"&code="+resourceform.getId();
		}finally{
			map =  null;
		}
		return "redirect:"+this.path+"/findRes?param_msg="+param_msg;
	}
    
       
    /**
     * 删除资源
     * @param request
     * @param org
     * @return
     */
    @RequestMapping("/delRes")
    public String delRes(HttpServletRequest request,
    			@RequestParam(value="code", required=true)String code){
    	String param_msg = "N";
    	try{
//			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
			dbServ.delRes(code);
			
			request.getSession().getServletContext().removeAttribute("ALLURL");
			List<ResourcesDTO> resourceList = this.dbServ.getUserUrl(null);
			String[] urls = new String[resourceList.size()];
            for (int i = 0; i < resourceList.size(); i++) {
                urls[i] = resourceList.get(i).getRes_string();
            }
			request.getSession().getServletContext().setAttribute("ALLURL", urls);
			param_msg = "Y";
		} catch (Exception e) {
			
			logger_.error("***********/users/delRes************",e);
			return "redirect:"+this.path+"/findRes?param_msg="+param_msg;
		}
		return "redirect:"+this.path+"/findRes?param_msg="+param_msg;
	}
    
    
    
    /**
     * 跳转到资源分配给角色页面
     * @param request
     * @param org
     * @return
     */
    @RequestMapping("/toSetRole")
    public String toSetRole(HttpServletRequest request,
    			@RequestParam(value="code", required=true)String code){
    	Map<String,String> map = new HashMap<String,String>();
    	try{
    		map.put("code", code);
			List<RolesDTO> list = dbServ.findRolesByCode(map);//查询当前资源下未赋予的角色列表
			ResourcesDTO resDto = dbServ.findResByCode(code);//查询当前资源详情
			List<Res_rolesDTO>resRoleList = dbServ.findResRole(code);
			request.setAttribute("resRoleList", resRoleList);
			request.setAttribute("resDto", resDto);
			request.setAttribute("list",list);
		} catch (Exception e) {
			
			logger_.error("***********/users/toSetRole************",e);
			return "redirect:"+this.path+"/findRes?param_msg=N";
		}finally{
			map = null;
		}
		return "userManage/resources/rolesadd";
	}
    
    
    /**
     * 将资源分配给角色
     * @param request
     * @param org
     * @return
     */
    @RequestMapping("/setRole")
    public String setRole(HttpServletRequest request,ResourceForm resourceform){
    	try{
			UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(
					Constants.USER_KEY);
			if(resourceform.getRolesbox()!=null && resourceform.getRolesbox().length>0){
				if (user != null && user.getId() != null){
					resourceform.setCreator(user.getId());
				}
				flowServ.setRole(resourceform);
    		}
		} catch (Exception e) {
			
			logger_.error("***********/users/setRole************",e);
			return "redirect:"+this.path+"/findRes?param_msg=N";
		}
    	return "redirect:"+ this.path + "/toSetRole?param_msg=Y&code="+resourceform.getResid();
	}
    
    /**
     * 获取组织代码的ajax
     * @param request
     * @param org
     * @return
     */
    @RequestMapping("/ajaxOrganize")
    public String ajaxOrganize(HttpServletRequest request, String org_name){
        try{
            if(StringUtils.isNotEmpty(org_name)) {
            	//转码
//            	org_name = new String(org_name.getBytes("ISO-8859-1"),request.getCharacterEncoding());
                request.setAttribute("orgList", commDbServ.ajaxOrganize(org_name));
            }
        }
        catch(Exception e) {
            logger_.error("***********/users/ajaxOrganize************",e);
        }
        return "userManage/users/ajaxOrganize";
    }
    /*
    @ResponseBody
    @RequestMapping("/ajaxOrganize")
    public Map<String,Object> ajaxOrganize(HttpServletRequest request, @RequestParam(value="name", required=true)String name){
    	Map<String,Object> requestMap = new HashMap<String,Object>();
    	try{
			List<OrganizesDTO> orgList = commDbServ.ajaxOrganize(name);
			if(orgList !=null && orgList.size() > 0){
				OrganizesDTO dto = orgList.get(0);
				requestMap.put("orgcode", dto.getOrg_code());
			}
			//request.setAttribute("orgList",orgList);
		} catch (Exception e) {
			logger_.error("***********users/ajaxOrganize************",e);
			//return "userManage/users/ajaxOrganize";
		}
    	return requestMap;
	}
	*/
    
    
    /**
     * 退出
     */
    @RequestMapping("/logOut")
    public String logOut(HttpServletRequest request){
    	try{
    		request.getSession().removeAttribute(Constants.USER_KEY);
		} catch (Exception e) {
			
			logger_.error("***********/users/logOut************",e);
			return "redirect:"+"/loginForm.jsp";
		}
    	return "redirect:"+"/loginForm.jsp";
	}
    
    
    /**
     * 获取用户信息ajax
     * @param request
     * @param org
     * @return
     */
    @RequestMapping("/viweUserInfo")
    public void viweUserInfo(HttpServletRequest request,HttpServletResponse response){
    	try{
    		UserInfoDTO user =  (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
    		String message = user.getName()+"  ["+user.getOrg_name()+"]  ";
    		response.setContentType("application/x-text; charset=UTF-8");
			response.getWriter().print(message);
		} catch (Exception e) {
			
			logger_.error("***********/users/viweUserInfo************",e);
		}
	}
    
    //资源列表
    @RequestMapping("/findVisit")
    public String findVisit(HttpServletRequest request,VisitConfigurationDTO form){
    	
    	List<VisitConfigurationDTO> list = userConfigDbService.findVisitConfigList(form);
    	request.setAttribute("visitList", list);
    	request.setAttribute("bean", form);
    	
    	return "userManage/visit/index";
    }

    @RequestMapping("/toAddVisit")
    public String toAddVisit(HttpServletRequest request, VisitConfigurationDTO m){
    	
    	if(StringUtils.isNotEmpty(m.getId())){
    		request.setAttribute("bean", userConfigDbService.findVisitConfigById(m));
    	}
    	
    	return "userManage/visit/addVisit";
    }
    
    @RequestMapping("/addVisit")
    @ResponseBody
    public AjaxResult addVisit(HttpServletRequest request,VisitConfigurationDTO m){
    	
    	m.setCreateUser(getUser(request).getId());
    	if(StringUtils.isNotEmpty(m.getId())){
    		userConfigDbService.UpdateVisitConf(m);
    	}else{
    		m.setCreateTime(DateUtil.getNowDateTime());
    		userConfigDbService.insertVisitConf(m);
    	}
    	
    	return AjaxResult.suc("保存成功");
    }
    
    @RequestMapping("/updateUcOrderBy")
    @ResponseBody
    public AjaxResult addVisit(HttpServletRequest request,@RequestBody List<UserConfigurationDTO> dtos){

    	for (UserConfigurationDTO dto : dtos) {
    		if(StringUtils.isEmpty(dto.getId())){
    			return AjaxResult.error("错误");
    		}
    		userConfigDbService.updateUserConfiguration(dto);
		}
    	
    	return AjaxResult.suc("顺序更新成功");
    }
    
    @RequestMapping("/addVisitUser")
    @ResponseBody
    public AjaxResult addVisitUser(HttpServletRequest request,@RequestBody UserConfigurationModel um){
    	
    	if(StringUtils.isNotEmpty(um.getVisitId())){
    		
    		if(um.getVisitId() == null || um.getUidAlls() == null || um.getUidAlls().isEmpty() || um.getVisitId().isEmpty()){
    			return AjaxResult.error("请选择数据");
    		}
    		
    		List<String> delId = new ArrayList<>();
    		for (String uidAll : um.getUidAlls()) {
    			if(!um.getUids().contains(uidAll)){
    				delId.add(uidAll);
    			}
			}
    		
    		Map<String,Object> map = new HashMap<String, Object>();
    		map.put("visitId", um.getVisitId());
    		map.put("uidAlls", delId);
    		userConfigDbService.bathcDelUserConfiguration(map);
    		
    		for (String id : um.getUids()) {
    			
    			UserConfigurationDTO dto = new UserConfigurationDTO();
    			dto.setUserId(id);
    			dto.setVisitId(um.getVisitId());
    			int count = userConfigDbService.updateUserConfiguration(dto);
    			if(count == 0){
    				userConfigDbService.insertUserConfiguration(dto);
    			}
			}
    	}else if(StringUtils.isNotEmpty(um.getUserId())){
    		
    		if(StringUtils.isEmpty(um.getUserId()) || um.getvIds() == null || um.getvIds().isEmpty()){
    			return AjaxResult.error("请选择数据");
    		}
    		
    		Map<String,Object> map = new HashMap<String, Object>();
    		map.put("userId", um.getUserId());
    		map.put("not_vids", um.getvIds());
    		userConfigDbService.bathcDelUserConfiguration(map);
    		for (String id : um.getvIds()) {
    			UserConfigurationDTO dto = new UserConfigurationDTO();
    			dto.setUserId(um.getUserId());
    			dto.setVisitId(id);
    			int count = userConfigDbService.updateUserConfiguration(dto);
    			if(count == 0){
    				userConfigDbService.insertUserConfiguration(dto);
    			}
			}
    	}
    	
    	
    	return AjaxResult.suc("分配成功");
    }
    
    @RequestMapping("/delVisit")
    @ResponseBody
    public AjaxResult delVisit(HttpServletRequest request, UserConfigurationModel um){
    	
    	List<String> vids = um.getvIds();
    	
    	Map<String,Object> map = new HashMap<>();
    	map.put("vids", vids);
    	userConfigDbService.bathcDelUserConfiguration(map);
		userConfigDbService.batchDelVisitConf(map);

    	return AjaxResult.suc("删除成功");
    }
    
    @RequestMapping("/delUserVisit")
    @ResponseBody
    public AjaxResult delUserVisit(HttpServletRequest request,@RequestBody UserConfigurationModel um){
    	 
    	List<String> uids = um.getUcids();
    	
    	if(uids == null){
    		return AjaxResult.error("请选择要删除的数据");
    	}
    	Map<String,Object> map = new HashMap<>();
    	map.put("ids", uids);
    	userConfigDbService.bathcDelUserConfiguration(map);

    	return AjaxResult.suc("删除成功");
    }
    
    /**
     * 查询用户列表
     * @param request
     * @return
     */
    @RequestMapping("/findVisitUsers")
	public String findVisitUsers(HttpServletRequest request,UsersForm userform){
    	Map<String,String> map = new HashMap<String,String>();
		try{
			//分页处理
	        int pages = 1;
	        if(request.getParameter("page") != null && !"".equals(request.getParameter("page"))) {
	            pages = Integer.parseInt(request.getParameter("page") == null ? "1" : request.getParameter("page"));
	        }
	        PageBean page_bean = new PageBean(pages, String.valueOf(50));
	        page_bean.setPageSize(50);
			map.put("id", userform.getId());
			map.put("name", userform.getUsername());
			map.put("visitId", request.getParameter("visitId"));
			map.put("firstRcd", page_bean.getLow());
			map.put("lastRcd", page_bean.getHigh());
			List<UserVisit> list = userConfigDbService.findUsersV(map);
			List<CodeLibraryDTO> dutyList = codeLibraryService.findCodeLibraryList("USER_DUTIES");
			int counts = userConfigDbService.findUsersCountV(map);
			request.setAttribute("dutyList", dutyList);
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(pages));// 当前页码
	        request.setAttribute("itemInPage", page_bean.getPageSize());// 每页显示的记录数
            request.setAttribute("counts",counts);
	        request.setAttribute("allPage", counts % page_bean.getPageSize()==0 ? (counts/page_bean.getPageSize()) : (counts/page_bean.getPageSize())+1);
	        request.setAttribute("id",userform.getId());
	        request.setAttribute("name",userform.getUsername());
	        request.setAttribute("visitId", request.getParameter("visitId"));
		} catch (Exception e) {
			
			logger_.error("***********/users/findOrganizes************",e);
		}finally{
			map =  null;
		}
		return "userManage/visit/indexUser";
	}
    
    @RequestMapping("/toAddUserVisit")
    public String toAddUserVisit(HttpServletRequest request , UserConfigurationModel um){
    	
    	VisitConfigurationDTO dto = new VisitConfigurationDTO();
    	dto.setUserId(um.getUserId());
    	request.setAttribute("list", userConfigDbService.findVisitConfigList(dto));
    	request.setAttribute("userId", um.getUserId());
    	
    	return "userManage/visit/indexVisitList";
    }
    
    @RequestMapping("/findUserConf")
    public String findUserConf(HttpServletRequest request , UserConfigurationModel um){
    	try{
    		int page = 1;
    		if (StringUtils.isNotBlank(request.getParameter("page"))){
    			page = Integer.valueOf(request.getParameter("page"));
    		}
    		PageBean pg = new PageBean(page,String.valueOf(Constants.PAGE_NUM));
    		
			um.setFirstRcd(pg.getLow());
			um.setLastRcd(pg.getHigh());
			
			List<UserConfigurationModel> list =  userConfigDbService.findUserConfigList(um);
    		int count = userConfigDbService.findUserConfigListCount(um);
			request.setAttribute("list", list);
			request.setAttribute("pages", Integer.toString(page));// 当前页码
	        request.setAttribute("itemInPage", pg.getPageSize());// 每页显示的记录数
	        request.setAttribute("counts",count);
	        request.setAttribute("allPage", count % pg.getPageSize()==0 ? (count/pg.getPageSize()) : (count/pg.getPageSize())+1);
	        request.setAttribute("um", um);
    	}catch(Exception e){
			
			logger_.error("***********/users/findUserConf************",e);
    	}finally{
    	}
    	return "userManage/visit/indexUserConf";
    }


	UserInfoDTO getUser(HttpServletRequest request){
    	Object userObj = request.getSession().getAttribute(Constants.USER_KEY);
    	if(null != userObj){
    		return (UserInfoDTO)userObj;
    	}
    	return new UserInfoDTO();
    }
}
