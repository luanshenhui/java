package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.admin.service.EPinService;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.NameValidator;
import cn.com.cgbchina.rest.visit.model.user.EEA1InfoResult;
import cn.com.cgbchina.user.dto.LoginDto;
import cn.com.cgbchina.user.dto.UserInfoDto;
import cn.com.cgbchina.user.model.UserInfoModel;
import cn.com.cgbchina.user.service.UserInfoService;
import cn.com.cgbchina.web.controller.CaptchaGenerator;
import cn.com.cgbchina.web.controller.LoginRedirector;
import cn.com.cgbchina.web.utils.Tools;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;

import static com.google.common.base.Objects.equal;
import static com.google.common.base.Preconditions.checkArgument;
import static com.spirit.util.Arguments.notNull;

/**
 * Created by 11140721050130 on 2016/5/4.
 */
@RequestMapping("/api/admin/user")
@Controller
@Slf4j
public class AdminUsers {

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
	@Resource
	private EPinService ePinService;

	@Value("#{app.domain}")
	private String domain;

	@RequestMapping(value = "/login", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public LoginDto login(@RequestParam("userName") String userName, @RequestParam("password") String password,
			@RequestParam("code") String code, @RequestParam(value = "type", defaultValue = "1") Integer type,
			@RequestParam(value = "target", required = false) String target, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			checkArgument(notNull(userName.trim()), "login.userName.empty");
			checkArgument(notNull(password.trim()), "login.password.can.not.be.empty");
			if (!checkCode(code, request)) {
				log.error("captcha.code.not.correct,code:{}", code);
				throw new ResponseException(500, messageSources.get("captcha.code.not.correct"));
			}
			Response<UserInfoModel> userInfo = userInfoService.findUserInfoById(userName);
			if (!userInfo.isSuccess()) {
				log.error("user.password.incorrect,userId:{}", userName);
				throw new ResponseException(500, messageSources.get(userInfo.getError()));
			}
			LoginDto loginDto = new LoginDto();
			if (Contants.LOGIN_ISFIRST_0.equals(userInfo.getResult().getIsFirst())) {
				// 必须修改密码
				loginDto.setIsUpPwd(true);
				return loginDto;
			}
			// 校验密码信息
			EEA1InfoResult eEA1InfoResult = ePinService.EEA1(request, password);
			request.getSession().removeAttribute("randomPwd");
			if (!Contants.RETRUN_CODE_000000.equals(eEA1InfoResult.getRetCode())) {
				log.error("pwd.service.error");
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.service.error"));
			}
			// 密码不相等
			if (!eEA1InfoResult.getPinBlock().equals(userInfo.getResult().getPassword())) {
				log.error("failed to login user by id={},type={},error code:{}", userName, type, userInfo.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("user.or.password.error"));
			}
			User user = userInfo.getResult();
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
		} catch (IllegalArgumentException e) {
			log.error("illegal param cause:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("vendor login failed ,cause:{}", Throwables.getStackTraceAsString(e));
			// 登录时提示信息错误 FROM 修改 验证码出错依然提示用户名或密码错误 chenle 2016.10.31 2016.10.31
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
			// 登录时提示信息错误 TO
		}
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
        // 一次密码加密
		EEA1InfoResult firstPwdResult = ePinService.EEA1(request, passwordFirst);
		// 密码机不成功返回
		if (!Contants.RETRUN_CODE_000000.equals(firstPwdResult.getRetCode())) {
			log.error("pwd.service.error");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.service.error"));
		}
		// 二次密码加密
		EEA1InfoResult secondPwdResult = ePinService.EEA1(request, passwordSecond);
		// 密码机不成功返回
		if (!Contants.RETRUN_CODE_000000.equals(secondPwdResult.getRetCode())) {
			log.error("pwd.service.error");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.service.error"));
		}
		// 密码加密
		EEA1InfoResult newPwdResult = ePinService.EEA1(request, passwordNew);
		// 密码机不成功返回
		if (!Contants.RETRUN_CODE_000000.equals(newPwdResult.getRetCode())) {
			log.error("pwd.service.error");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.service.error"));
		}
		request.getSession().removeAttribute("randomPwd");

		if (!userInfo.isSuccess()) {
			log.error("Response.error,error code: {}", userInfo.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(userInfo.getError()));
		}
		// 一次密码和二次密码校验
		if (!firstPwdResult.getPinBlock().equals(userInfo.getResult().getPwfirst())
				|| !secondPwdResult.getPinBlock().equals(userInfo.getResult().getPwsecond())) {
			log.error("first.or.cecond.password.fail");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("first.or.cecond.password.fail"));
		}
		try {
			UserInfoModel userInfoModel = new UserInfoModel();
			userInfoModel.setId(userInfo.getResult().getId());
			userInfoModel.setPassword(newPwdResult.getPinBlock());
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
			log.error("failed to modifyPwd vendorUser,cause:", e);
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
		//旧密码校验
		Response<UserInfoDto> userInfoR = userInfoService.findUserById(user.getId());
		if(!userInfoR.isSuccess()){
			log.error("user.password.incorrect,userId:{}", user.getId());
			throw new ResponseException(500, messageSources.get("user.password.incorrect"));
		}
		EEA1InfoResult oldInfoResult = ePinService.EEA1(request, passwordOld);
		if (!Contants.RETRUN_CODE_000000.equals(oldInfoResult.getRetCode())) {
			log.error("pwd.service.error");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.service.error"));
		}
		UserInfoDto oldUserInfoDto = userInfoR.getResult();
		if(!oldUserInfoDto.getPassword().equals(oldInfoResult.getPinBlock())){
			log.error("user.password.incorrect,userId:{}", user.getId());
			throw new ResponseException(500, messageSources.get("user.password.incorrect"));
		}
		// 密码加密
		EEA1InfoResult newPassResult = ePinService.EEA1(request, passwordNew);
		request.getSession().removeAttribute("randomPwd");
		// 密码机不成功返回
		if (!Contants.RETRUN_CODE_000000.equals(newPassResult.getRetCode())) {
			log.error("pwd.service.error");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.service.error"));
		}
		try {
			UserInfoModel userInfoModel = new UserInfoModel();
			userInfoModel.setId(user.getId());
			userInfoModel.setPassword(newPassResult.getPinBlock());
			// 更新密码
			Response res = userInfoService.updatePwdByCode(userInfoModel, passwordOld);
			if (!res.isSuccess()) {
				log.error("failed to modifyPwd adminUser,cause:{}", res.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(res.getError()));
			}

		} catch (Exception e) {
			log.error("failed to modifyPwd adminUser,cause:", e.getMessage());
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
			request.getSession().invalidate();
			return "ok";
		} catch (Exception e) {
			log.error("failed to logout user,cause:", e);
			throw new ResponseException(500, "user.logout.fail");
		}
	}

	@RequestMapping(value = "/add",method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String create(UserInfoDto userInfoDto,HttpServletRequest request) {
		User user = UserUtil.getUser();
		try {
			if (user == null) {
				throw new ResponseException("user.not.login.yet");
			}
			// 校验用户名是否重复
			checkArgument(NameValidator.isAllowedUserName(userInfoDto.getName()), "user.name.duplicated");
			userInfoDto.setCreateOper(user.getName());
			userInfoDto.setUserId(userInfoDto.getId());
			userInfoDto.setIsFirst(Contants.LOGIN_ISFIRST_0);
			userInfoDto.setPwsecond("");
            userInfoDto.setType(Contants.USER_TYPE_0);
			// 密码加密
			EEA1InfoResult eEA1InfoResult = ePinService.EEA1(request, userInfoDto.getPwfirst());
			request.getSession().removeAttribute("randomPwd");
			// 密码机不成功返回
			if (!Contants.RETRUN_CODE_000000.equals(eEA1InfoResult.getRetCode())) {
				log.error("pwd.service.error");
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.service.error"));
			}
			userInfoDto.setPwfirst(eEA1InfoResult.getPinBlock());
			Response<String> result = userInfoService.create(userInfoDto);

			if(!result.isSuccess()){
				log.error("request.error,error code: {}", result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, result.getError());
			}
			// checkState(result.isSuccess(), result.getError());
			return result.getResult();
		} catch (Exception e) {
			log.error("failed to create {},error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(messageSources.get(e.getMessage())));
		}
	}

	@RequestMapping(value = "audit/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String assign(@PathVariable("id") String id, UserInfoModel userInfoDto,HttpServletRequest request) {
		User user = UserUtil.getUser();
		userInfoDto.setModifyOper(user.getName());
		userInfoDto.setId(id);
		if ("2".equals(userInfoDto.getCheckStatus())) {
			userInfoDto.setPwsecond("");
		}
		if ("1".equals(userInfoDto.getCheckStatus())) {
			userInfoDto.setIsFirst(Contants.LOGIN_ISFIRST_0);
		}
		EEA1InfoResult eEA1InfoResult = ePinService.EEA1(request, userInfoDto.getPwsecond());
		request.getSession().removeAttribute("randomPwd");
		// 密码机不成功返回
		if (!Contants.RETRUN_CODE_000000.equals(eEA1InfoResult.getRetCode())) {
			log.error("pwd.service.error");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.service.error"));
		}
		userInfoDto.setPwsecond(eEA1InfoResult.getPinBlock());
		Response<Boolean> result = userInfoService.assign(userInfoDto);
		if (result.isSuccess()) {
			return "ok";
		}
		log.error("failed to assign userInfo {},error code:{}", userInfoDto, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "edit/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String update(@PathVariable("id") String id, UserInfoDto userInfoDto) {
		User user = UserUtil.getUser();
		userInfoDto.setModifyOper(user.getName());
		userInfoDto.setId(id);
		Response<Boolean> result = userInfoService.update(userInfoDto);
		if (result.isSuccess()) {
			return "ok";
		}
		log.error("failed to update userInfo {},error code:{}", userInfoDto, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

    @RequestMapping(value = "startStop/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String startStop(@PathVariable("id") String id, UserInfoDto userInfoDto) {
        User user = UserUtil.getUser();
        userInfoDto.setModifyOper(user.getName());
        userInfoDto.setId(id);
        Response<Boolean> result = userInfoService.update(userInfoDto);
        if (result.isSuccess()) {
            return "ok";
        }
        log.error("failed to update userInfo {},error code:{}", userInfoDto, result.getError());
        throw new ResponseException(500, messageSources.get(result.getError()));
    }

    @RequestMapping(value = "delete/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String delete(@PathVariable("id") String id, UserInfoDto userInfoDto) {
        User user = UserUtil.getUser();
        userInfoDto.setModifyOper(user.getName());
        userInfoDto.setId(id);
        Response<Boolean> result = userInfoService.update(userInfoDto);
        if (result.isSuccess()) {
            return "ok";
        }
        log.error("failed to update userInfo {},error code:{}", userInfoDto, result.getError());
        throw new ResponseException(500, messageSources.get(result.getError()));
    }

	/**
	 * 修改密码
	 * 
	 * @param userInfoDto
	 * @return add by liuhan
	 */
	@RequestMapping(value = "/updatePassWord", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String updatePassWord(UserInfoDto userInfoDto,HttpServletRequest request) {
		User user = UserUtil.getUser();
		userInfoDto.setModifyOper(user.getName());
		userInfoDto.setPwsecond("");
		EEA1InfoResult eEA1InfoResult = ePinService.EEA1(request, userInfoDto.getPwfirst());
		request.getSession().removeAttribute("randomPwd");
		// 密码机不成功返回
		if (!Contants.RETRUN_CODE_000000.equals(eEA1InfoResult.getRetCode())) {
			log.error("pwd.service.error");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.service.error"));
		}
		userInfoDto.setPwfirst(eEA1InfoResult.getPinBlock());
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
	@RequestMapping(value = "/getRandomCode", method = {RequestMethod.GET,RequestMethod.POST}, produces = MediaType.APPLICATION_JSON_VALUE)
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
		checkArgument(!userId.isEmpty(),"argument is null");
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
