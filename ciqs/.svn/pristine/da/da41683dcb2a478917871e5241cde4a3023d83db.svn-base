package com.dpn.ciqqlc.common.component;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.service.UserManageDb;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.model.UsersDTO;
import com.dpn.ciqqlc.standard.service.UserManageDbService;
import com.trs.idm.client.actor.ActorException;
import com.trs.idm.client.actor.SSOUser;
import com.trs.idm.client.actor.StdHttpSessionBasedActor;


/**
 * 从IDS传过来的用户信息
 * @author BingWuNing
 *
 */
@Service
@Transactional

public  class CustomerActor extends StdHttpSessionBasedActor {
	private static Logger logger = LoggerFactory.getLogger(CustomerActor.class);
	
    private UserManageDbService dbServ = null;
	
	
	
	//协作应用同步增加用户的实现.返回true, 表示同步成功;否则表示同步失败
	@Override
	public boolean addUser(SSOUser ssouser, HttpServletRequest request) throws ActorException {
				
		return false;//保存到本地数据库
	}
    //禁用用户
	@Override
	public boolean disableUser(SSOUser ssouser) throws ActorException {
		// TODO 自动生成的方法存根
		return false;
	}
	//启用用户
	@Override
	public boolean enableUser(SSOUser ssouser) throws ActorException {
		// TODO 自动生成的方法存根
		return false;
	}
	//从协作应用的自有登录页面的表单中获取用户名（匿名应用使用自已的登录页面需要实现）
	@Override
	public String extractUserName(HttpServletRequest request) throws ActorException {
		logger.info("extractUserName():from co-webapp extract username");
		String username = request.getParameter("loginName");
		return username;
	}
	//从协作应用的自有登录页面的表单中获取密码（匿名应用使用自已的登录页面需要实现）
	@Override
	public String extractUserPwd(HttpServletRequest request) throws ActorException {
		logger.info("extractUserPwd():from co-webapp extract password");
		String password = request.getParameter("password");
		return password;
	}
	//协作应用同步删除用户的实现. 返回true, 表示同步成功;否则表示同步失败.
	@Override
	public boolean removeUser(SSOUser ssouser, HttpServletRequest request) throws ActorException {

		return true;
	}
	//协作应用同步更新用户的实现. 返回true, 表示同步成功;否则表示同步失败.
	@Override
	public boolean updateUser(SSOUser ssouser, HttpServletRequest request) throws ActorException {		
		return true;
	}
    //判断协作应用中是否存在IDS会话中的当前用户
	@Override
	public boolean userExist(SSOUser ssouser) throws ActorException {
		try{
			UsersDTO userInfo = dbServ.findUsersByCode(ssouser.getUserName());
			if(userInfo==null||"".equals(userInfo)){
			  return false;	
			}else{
				if("A".equals(userInfo.getFlag_op())) {
					return true;
				}else{
					return false;
				}
			}
		}catch(Exception e){
			return false;
		}
	}
	//检查登录：判断协作应用当前Session是否登录
	@Override
	public boolean checkLocalLogin(HttpSession session) throws ActorException {
		
		UserInfoDTO user = (UserInfoDTO) session.getAttribute(Constants.USER_KEY);
		if(user==null||"".equals(user)){
			logger.info("checkLocalLogin():user is not login");
			return false;
		}else{
			logger.info("checkLocalLogin():user is already login");
			return true;
		}
	}
	
	//执行登录：加载登录的统一用户到协作应用的当前会话(Session对象)中, 完成协作应用自己的登录逻辑(不需要再次对用户进行认证, 只需要加载)
	   @Override
		public void loadLoginUser(HttpServletRequest request, SSOUser ssouser) throws ActorException {
			HttpSession session = request.getSession();	
			logger.info("loadLoginUser():Loding ssouser to ciqs:"+ssouser.getUserName());
			try{
				ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getSession().getServletContext());
				dbServ = (UserManageDb)ctx.getBean("userManageDbServ");
				UsersDTO userInfo = dbServ.findUsersByCode(ssouser.getUserName());
				logger.info("loadLoginUser():loading success!ssouser:"+ssouser.getUserName()+"userInfo:"+userInfo.getId());
				UserInfoDTO user = new UserInfoDTO();
				if(userInfo!=null) {
    			    if("A".equals(userInfo.getFlag_op())) {
    			        user.setId(userInfo.getId());
                        user.setName(userInfo.getName());
                        user.setOrg_code(userInfo.getOrg_code());
                        user.setOrg_code(userInfo.getOrg_code());
                        user.setOrg_name(userInfo.getOrg_name());
                        user.setOrg_type(userInfo.getOrg_type());
                        user.setDept_code(userInfo.getDept_code());
                        user.setPort_code(userInfo.getPort_code());
                        user.setFixed_phone(userInfo.getFixed_phone());
                        user.setManage_sign(userInfo.getManage_sign());
                        user.setMobile_phone_no(userInfo.getMobile_phone_no());
                        user.setDirecty_under_org(userInfo.getDirecty_under_org());
                        user.setDuties(userInfo.getDuties());
                        session.setAttribute(Constants.USER_KEY, user);
    			    }
    			}
				}catch(Exception e){
					logger.info("loadLoginUser():error:"+e.getMessage());
				}
			
			
			
		}
		//注销退出：完成协作应用自己的退出登录的逻辑
		@Override
		public void logout(HttpSession session) throws ActorException {
			System.out.println("logout():当前协作应用退出登录");
			session.removeAttribute(Constants.USER_KEY);
			session.invalidate();
		}
	}
