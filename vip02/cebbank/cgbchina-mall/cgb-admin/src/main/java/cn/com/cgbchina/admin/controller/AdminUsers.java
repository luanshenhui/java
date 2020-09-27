package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.NameValidator;
import cn.com.cgbchina.user.dto.LoginDto;
import cn.com.cgbchina.user.dto.UserInfoDto;
import cn.com.cgbchina.user.model.UserInfoModel;
import cn.com.cgbchina.user.service.UserInfoService;
import cn.com.cgbchina.web.controller.CaptchaGenerator;
import cn.com.cgbchina.web.controller.LoginRedirector;
import cn.com.cgbchina.web.utils.Tools;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.hash.HashFunction;
import com.google.common.hash.Hashing;
import com.spirit.common.model.Response;
import com.spirit.common.utils.CommonConstants;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.regex.Pattern;

import static com.google.common.base.Objects.equal;
import static com.google.common.base.Preconditions.checkArgument;

/**
 * Created by 11140721050130 on 2016/5/4.
 */
@RequestMapping("/api/admin/user")
@Controller
@Slf4j
public class AdminUsers {

	private static final Pattern mobilePattern = Pattern
			.compile("^((13[0-9])|(14[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$");
	private final Splitter splitter = Splitter.on('@').trimResults();
	private final static HashFunction md5 = Hashing.md5();
	private final static String CUSTOMER_LOGIN = "adminLogin";
	private final static String CUSTOMER_LOGIN_VALUE = "1";

	@Resource
	private UserInfoService userInfoService;
	@Autowired
	private MessageSources messageSources;
	@Autowired
	private LoginRedirector loginRedirector;
	@Resource
	private CaptchaGenerator captchaGenerator;

	@Value("#{app.domain}")
	private String domain;

	@RequestMapping(value = "/login", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public LoginDto login(@RequestParam("userName") String userName, @RequestParam("password") String password,
			@RequestParam("code") String code, @RequestParam(value = "type", defaultValue = "1") Integer type,
			@RequestParam(value = "target", required = false) String target, HttpServletRequest request,
			HttpServletResponse response) {
		if (!checkCode(code, request)) {
			log.error("captcha.code.not.correct,code:{}", code);
			throw new ResponseException(500, messageSources.get("captcha.code.not.correct"));
		}
		Response<UserInfoModel> userInfo = userInfoService.findUserInfoById(userName);
		if (!userInfo.isSuccess()) {
			log.error("user.password.incorrect,userId:{}", userName);
			throw new ResponseException(500, messageSources.get("user.password.error"));
		}
		LoginDto loginDto = new LoginDto();
		if (Contants.LOGIN_ISFIRST_0.equals(userInfo.getResult().getIsFirst())) {
			// 必须修改密码
			loginDto.setIsUpPwd(true);
			return loginDto;
		}
		Response<UserInfoModel> result = userInfoService.userLogin(userName, password);
		if (!result.isSuccess()) {
			log.error("failed to login user by id={},type={},error code:{}", userName, type, result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		}

		User user = result.getResult();
		request.getSession().setAttribute(CommonConstants.SESSION_USER_ID, user.getId());
		// 密码是否过期
		setPwdTimeOut(request, user.getId());
		// cookie CustomerLogin 设置为1,过期时间为30分钟
		Cookie adminLogin = new Cookie(CUSTOMER_LOGIN, CUSTOMER_LOGIN_VALUE);
		adminLogin.setMaxAge(30 * 60);
		// 在所有页面下都可见
		adminLogin.setPath("/");
		adminLogin.setDomain(domain);
		response.addCookie(adminLogin);
		// 添加跳转路径
		loginDto.setUrl(loginRedirector.redirectTarget(target, user));
		return loginDto;
	}

	/**
	 * 首次登录修改密码
	 * 
	 * @param passwordFirst 修改密码
	 * @param passwordSecond 修改密码
	 * @param passwordNew 修改密码
	 * @return
	 */
	@RequestMapping(value = "/modifyManagerPwd", method = RequestMethod.POST)
	@ResponseBody
	public void modifyManagerPwd(@RequestParam("userName") String userName,
			@RequestParam("passwordFirst") String passwordFirst, @RequestParam("passwordSecond") String passwordSecond,
			@RequestParam("passwordNew") String passwordNew, HttpServletRequest request, HttpServletResponse response) {
		if (Strings.isNullOrEmpty(passwordFirst) || Strings.isNullOrEmpty(passwordNew)
				|| Strings.isNullOrEmpty(passwordSecond) || Strings.isNullOrEmpty(userName)) {
			log.error("failed to modifyPwd adminUser,cause:", "param.not.null.fail");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("param.not.null.fail"));
		}
		Response<UserInfoModel> userInfo = userInfoService.findUserInfoById(userName);
		if (!userInfo.isSuccess()) {
			log.error("user.password.incorrect,userId:{}", userName);
			throw new ResponseException(500, messageSources.get("user.password.incorrect"));
		}

		try {
			UserInfoModel userInfoModel = new UserInfoModel();
			userInfoModel.setId(userInfo.getResult().getId());
			userInfoModel.setPassword(passwordNew);
			userInfoModel.setPwfirst(passwordFirst);
			userInfoModel.setPwsecond(passwordSecond);
			// 更新密码
			Response res = userInfoService.updateFirstPwdByCode(userInfoModel);
			if (!res.isSuccess()) {
				log.error("failed to modifyPwd vendorUser,cause:", "adminUser.modifyPwd.fail");
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(res.getError()));
			}
			// 存储信息
			User user = userInfo.getResult();
			request.getSession().setAttribute(CommonConstants.SESSION_USER_ID, user.getId());
			// cookie CustomerLogin 设置为1,过期时间为30分钟
			Cookie adminLogin = new Cookie(CUSTOMER_LOGIN, CUSTOMER_LOGIN_VALUE);
			adminLogin.setMaxAge(30 * 60);
			// 在所有页面下都可见
			adminLogin.setPath("/");
			adminLogin.setDomain(domain);
			response.addCookie(adminLogin);

		} catch (Exception e) {
			log.error("failed to modifyPwd vendorUser,cause:", e.getMessage());
			throw new ResponseException(Contants.ERROR_CODE_500, e.getMessage());
		}
	}

	/**
	 * 修改密码
	 * 
	 * @param passwordOld 修改密码
	 * @param passwordNew 修改密码
	 * @return
	 */
	@RequestMapping(value = "/modifyPwd", method = RequestMethod.POST)
	@ResponseBody
	public void modifyPwd(@RequestParam("passwordOld") String passwordOld,
			@RequestParam("passwordNew") String passwordNew, HttpServletRequest request, HttpServletResponse response) {
		if (Strings.isNullOrEmpty(passwordOld) || Strings.isNullOrEmpty(passwordNew)) {
			log.error("failed to modifyPwd adminUser,cause:", "param.not.null.fail");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("param.not.null.fail"));
		}
		User user = UserUtil.getUser();

		try {
			UserInfoModel userInfoModel = new UserInfoModel();
			userInfoModel.setId(user.getId());
			userInfoModel.setPassword(passwordNew);

			// 更新密码
			Response res = userInfoService.updatePwdByCode(userInfoModel, passwordOld);
			if (!res.isSuccess()) {
				log.error("failed to modifyPwd adminUser,cause:{}", res.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(res.getError()));
			}

		} catch (Exception e) {
			log.error("failed to modifyPwd vendorUser,cause:", e.getMessage());
			throw new ResponseException(Contants.ERROR_CODE_500, e.getMessage());
		}
	}

	private boolean checkCode(String code, HttpServletRequest request) {
		if (Strings.isNullOrEmpty(code)) {
			return false;
		}
		String sessionCode = captchaGenerator.getGeneratedText(request.getSession());
		// 验证码不正确
		if (!equal(code.toLowerCase(), sessionCode.toLowerCase())) {
			return false;
		}
		return true;
	}

	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	@ResponseBody
	public String logout(HttpServletRequest request) {
		try {
			User baseUser = UserUtil.getUser();
			request.getSession().invalidate();
			return "ok";
		} catch (Exception e) {
			log.error("failed to logout user,cause:", e);
			throw new ResponseException(500, "user.logout.fail");
		}
	}

	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String create(UserInfoDto userInfoDto) {
		User user = UserUtil.getUser();
		try {
			if (user == null) {
				throw new ResponseException("user.not.login.yet");
			}
			// 校验用户名是否重复
			checkArgument(NameValidator.isAllowedUserName(userInfoDto.getName()), "user.name.duplicated");
			// userInfoDto.setOrgCode(user.getOrgCode());
			userInfoDto.setCreateOper(user.getName());
			userInfoDto.setUserId(userInfoDto.getId());
			userInfoDto.setIsFirst("0");
			userInfoDto.setPwsecond("");
			Response<String> result = userInfoService.create(userInfoDto);
			// checkState(result.isSuccess(), result.getError());
			return result.getResult();
		} catch (IllegalArgumentException e) {
			log.error("failed to create {}, error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (IllegalStateException e) {
			log.error("failed to create {}, error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("failed to create {},error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(messageSources.get(e.getMessage())));
		}
	}

	@RequestMapping(value = "assign/{id}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String assign(@PathVariable("id") String id, UserInfoModel userInfoDto) {
		User user = UserUtil.getUser();
		userInfoDto.setModifyOper(user.getName());
		userInfoDto.setId(id);
		if ("2".equals(userInfoDto.getCheckStatus())) {
			userInfoDto.setPwsecond("");
		}
		if ("1".equals(userInfoDto.getCheckStatus())) {
			userInfoDto.setIsFirst("0");
		}
		// if ("1".equals(userInfoDto.getCheckStatus())) {
		// Response<UserInfoDto> userInfo = userInfoService.findUserById(id);
		// if (userInfo.getResult() != null) {
		// userInfoDto.setPassword(userInfo.getResult().getPwfirst() + userInfoDto.getPwsecond());
		// }
		// }
		Response<Boolean> result = userInfoService.assign(userInfoDto);
		if (result.isSuccess()) {
			return "ok";
		}
		log.error("failed to assign userInfo {},error code:{}", userInfoDto, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "{id}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String update(@PathVariable("id") String id, UserInfoDto userInfoDto) {
		User user = UserUtil.getUser();
		userInfoDto.setModifyOper(user.getName());
		userInfoDto.setId(id);
		log.error("id:"+userInfoDto.getId()+"....status:"+userInfoDto.getStatus());
		Response<Boolean> result = userInfoService.update(userInfoDto);
		if (result.isSuccess()) {
			return "ok";
		}
		log.info("修改..");
		log.error("result:"+result.isSuccess());
		log.error("failed to update userInfo {},error code:{}", userInfoDto, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 修改密码
	 * 
	 * @param userInfoDto
	 * @return add by liuhan
	 */
	@RequestMapping(value = "/updatePassWord", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String updatePassWord(UserInfoDto userInfoDto) {
		User user = UserUtil.getUser();
		userInfoDto.setModifyOper(user.getName());
		userInfoDto.setPwsecond("");
//		userInfoDto.setPassword("");
//		userInfoDto.setIsFirst("0");
		Response<Boolean> result = userInfoService.updatePassWord(userInfoDto);
		if (result.isSuccess()) {
			return "ok";
		}
		log.info("修改密码");
		log.error("failed to update userInfo {},error code:{}", userInfoDto, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 密码修改时间过期(过期时间为90天)
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/pwdTimeout", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean pwdTimeout(HttpServletRequest request) {
		Boolean bool = true;
		try {
			Object object = request.getSession().getAttribute("pwdTimeout");
			if (object != null) {
				bool = false;
			}
			request.getSession().removeAttribute("pwdTimeout");
			return bool;
		} catch (Exception e) {
			log.error("failed to pwdTimeout adminUser,cause:", e);
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("adminUser.find.fail"));
		}
	}

	/**
	 * 密码防重 获取随机数
	 *
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/getRandomCode", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String getRandomCode(HttpServletRequest request) {
		try {
			String randomPwd = Tools.randomPwd(6).trim();
			request.getSession().setAttribute("randomPwd", randomPwd);
			return randomPwd;
		} catch (Exception e) {
			log.error("failed to logout vendorUser,cause:", e);
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("vendorUser.logout.fail"));
		}
	}

	/**
	 * 登录密码是否修改超过90天存入session
	 * 
	 * @param request
	 * @param userId
	 */
	private void setPwdTimeOut(HttpServletRequest request, String userId) {
		try {
			Response<UserInfoModel> response = userInfoService.findUserInfoById(userId);
			// 查询是否成功
			if (response.isSuccess()) {
				UserInfoModel userInfoModel = response.getResult();
				// 比较时间于修改密码时间比较是否大于90天
				Date dt = new Date();
				if (userInfoModel.getEditPwTime() != null) {
					long time = dt.getTime() - userInfoModel.getEditPwTime().getTime();
					long timeout = time / (1000 * 60 * 60 * 24);
					// 过期的情况下
					if (timeout > 89) {
						request.getSession().setAttribute("pwdTimeout", true);
					}
				}
			}
		} catch (Exception e) {
			log.error("failed to pwdTimeout adminUser,cause:", e);
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("adminUser.find.fail"));
		}
	}

}
