/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.vendor.controller;

import static com.google.common.base.Objects.equal;
import static com.google.common.base.Preconditions.checkArgument;

import java.util.Date;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.hash.HashFunction;
import com.google.common.hash.Hashing;
import com.spirit.common.model.Response;
import com.spirit.common.utils.CommonConstants;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.NameValidator;
import cn.com.cgbchina.rest.visit.model.user.EEA1InfoResult;
import cn.com.cgbchina.user.dto.LoginDto;
import cn.com.cgbchina.user.model.VendorModel;
import cn.com.cgbchina.user.service.VendorUserService;
import cn.com.cgbchina.vendor.service.EPinService;
import cn.com.cgbchina.web.controller.CaptchaGenerator;
import cn.com.cgbchina.web.controller.LoginRedirector;
import cn.com.cgbchina.web.utils.Tools;
import lombok.extern.slf4j.Slf4j;

/**
 * @author wusy
 * @version 1.0
 * @created at 2016/5/27.
 */
@RequestMapping("/api/vendor/user")
@Controller
@Slf4j
public class VendorUsers {

	private static final Pattern mobilePattern = Pattern
			.compile("^((13[0-9])|(14[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$");
	private final Splitter splitter = Splitter.on('@').trimResults();
	private final static HashFunction md5 = Hashing.md5();
	private final static String CUSTOMER_LOGIN = "vendorLogin";
	private final static String CUSTOMER_LOGIN_VALUE = "1";

	@Autowired
	private VendorUserService vendorService;
	@Autowired
	private MessageSources messageSources;
	@Autowired
	private LoginRedirector loginRedirector;
	@Resource
	private CaptchaGenerator captchaGenerator;
	@Autowired
	private EPinService ePinService;

	@Value("#{app.domain}")
	private String domain;

	/**
	 * 供应商登录
	 *
	 * @param userName 用户名
	 * @param password 密码
	 * @param code 验证码
	 * @param type
	 * @param target 页面url
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/login", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public LoginDto login(@RequestParam("userName") String userName, @RequestParam("password") String password,
			@RequestParam("code") String code, @RequestParam(value = "type", defaultValue = "1") Integer type,
			@RequestParam(value = "target", required = false) String target, HttpServletRequest request,
			HttpServletResponse response) {

		if (!checkCode(code, request)) {
			log.error("captcha.code.not.correct,code:{}", code);
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("captcha.code.not.correct"));
		}
		// 获取用户信息
		Response<VendorModel> result = vendorService.vendorLogin(userName, password);
		LoginDto loginDto = new LoginDto();
		if (!result.isSuccess()) {
			log.error("failed to login user by id={},type={},error code:{}", userName, type, result.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
		}
		// 如果为首次登录的管理员,必须修改密码
		if (Contants.LOGIN_ISFIRST_0.equals(result.getResult().getIsFirst())
				&& Contants.LOGIN_LEVEL_0.equals(result.getResult().getLevel())) {
			// 必须修改密码
			loginDto.setIsUpPwd(true);
			return loginDto;
		}
		// 校验密码信息
		EEA1InfoResult eEA1InfoResult = ePinService.EEA1(request, password);
		request.getSession().removeAttribute("randomPwd");
		// 密码机不成功返回
		if (!Contants.RETRUN_CODE_000000.equals(eEA1InfoResult.getRetCode())) {
			log.error("pwd.service.error");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.service.error"));
		}
		// 密码不相等
		if (!eEA1InfoResult.getPinBlock().equals(result.getResult().getPassword())) {
			log.error("failed to login user by id={},type={},error code:{}", userName, type, result.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("user.or.password.error"));
		}
		// 存储信息
		User user = result.getResult();
		request.getSession().setAttribute(CommonConstants.SESSION_USER_ID, user.getId());
		request.getSession().setAttribute("vendorIsFirstLogin", result.getResult().getIsFirst());
		// 密码是否过期
		setPwdTimeOut(request, user.getId());
		// cookie CustomerLogin 设置为1,过期时间为30分钟
		Cookie vendorLogin = new Cookie(CUSTOMER_LOGIN, CUSTOMER_LOGIN_VALUE);
		vendorLogin.setMaxAge(30 * 60);
		// 在所有页面下都可见
		vendorLogin.setPath("/");
		vendorLogin.setDomain(domain);
		response.addCookie(vendorLogin);
		// 添加跳转路径
		loginDto.setUrl(loginRedirector.redirectTarget(target, user));
		return loginDto;

	}

	/**
	 * 验证码校验
	 *
	 * @param code 验证码
	 * @param request
	 * @return
	 */
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

	/**
	 * 首次登录修改密码（管理员）
	 *
	 * @param passwordFirst
	 * @param passwordSecond
	 * @param passwordNew
	 * @param request
	 */
	@RequestMapping(value = "/modifyManagerPwd", method = RequestMethod.POST)
	@ResponseBody
	public void modifyManagerPwd(@RequestParam("userName") String userName,
			@RequestParam("passwordFirst") String passwordFirst, @RequestParam("passwordSecond") String passwordSecond,
			@RequestParam("passwordNew") String passwordNew, HttpServletRequest request, HttpServletResponse response) {
		if (Strings.isNullOrEmpty(passwordNew) || Strings.isNullOrEmpty(passwordFirst)
				|| Strings.isNullOrEmpty(passwordSecond) || Strings.isNullOrEmpty(userName)) {
			log.error("failed to modifyPwd vendorUser,cause:", "param.not.null.fail");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("param.not.null.fail"));
		}
		Response<VendorModel> userInfo = vendorService.findByVendorCode(userName);

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
		EEA1InfoResult eEA1InfoResult = ePinService.EEA1(request, passwordNew);
		// 密码机不成功返回
		if (!Contants.RETRUN_CODE_000000.equals(eEA1InfoResult.getRetCode())) {
			log.error("pwd.service.error");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.service.error"));
		}
		request.getSession().removeAttribute("randomPwd");
		// 一次密码和二次密码校验
		if (!firstPwdResult.getPinBlock().equals(userInfo.getResult().getPwfirst())
				|| !secondPwdResult.getPinBlock().equals(userInfo.getResult().getPwsecond())) {
			log.error("first.or.cecond.password.fail");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("first.or.cecond.password.fail"));
		}
		try {
			VendorModel vendorModel = new VendorModel();
			vendorModel.setId(userInfo.getResult().getId());
			vendorModel.setCode(userInfo.getResult().getCode());
			vendorModel.setPassword(eEA1InfoResult.getPinBlock());
			// 更新密码
			Response res = vendorService.updatePwdByCode(vendorModel);
			if (!res.isSuccess()) {
				log.error("failed to modifyPwd vendorUser,cause:", "vendorUser.modifyPwd.fail");
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(res.getError()));
			}
			// 存储信息
			User user = userInfo.getResult();
			request.getSession().setAttribute(CommonConstants.SESSION_USER_ID, user.getId());
			// cookie CustomerLogin 设置为1,过期时间为30分钟
			Cookie vendorLogin = new Cookie(CUSTOMER_LOGIN, CUSTOMER_LOGIN_VALUE);
			vendorLogin.setMaxAge(30 * 60);
			// 在所有页面下都可见
			vendorLogin.setPath("/");
			vendorLogin.setDomain(domain);
			response.addCookie(vendorLogin);

		} catch (Exception e) {
			log.error("failed to modifyPwd vendorUser,cause:", e.getMessage());
			throw new ResponseException(Contants.ERROR_CODE_500, e.getMessage());
		}
	}

	/**
	 * 修改密码
	 *
	 * @param passwordNew
	 * @param request
	 */
	@RequestMapping(value = "/modifyPwd", method = RequestMethod.POST)
	@ResponseBody
	public void modifyPwd(@RequestParam("passwordNew") String passwordNew, HttpServletRequest request) {
		if (Strings.isNullOrEmpty(passwordNew)) {
			log.error("failed to modifyPwd vendorUser,cause:", "param.not.null.fail");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("param.not.null.fail"));
		}
		User user = UserUtil.getUser();
		Response<VendorModel> userInfo = vendorService.findVendorById(Long.parseLong(user.getId()));

		// 密码加密
		EEA1InfoResult eEA1InfoResult = ePinService.EEA1(request, passwordNew);
		request.getSession().removeAttribute("randomPwd");
		// 密码机不成功返回
		if (!Contants.RETRUN_CODE_000000.equals(eEA1InfoResult.getRetCode())) {
			log.error("pwd.service.error");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.service.error"));
		}

		try {
			VendorModel vendorModel = new VendorModel();
			vendorModel.setId(user.getId());
			vendorModel.setCode(userInfo.getResult().getCode());
			vendorModel.setPassword(eEA1InfoResult.getPinBlock());
			// 更新密码
			Response res = vendorService.updatePwdByCode(vendorModel);
			if (!res.isSuccess()) {
				log.error("failed to modifyPwd vendorUser,cause:", "vendorUser.modifyPwd.fail");
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(res.getError()));
			}

		} catch (Exception e) {
			log.error("failed to modifyPwd vendorUser,cause:", e);
			throw new ResponseException(Contants.ERROR_CODE_500, e.getMessage());
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
	 * 密码修改时间过期（过期时间为90天）
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
				request.getSession().removeAttribute("pwdTimeout");
			}
			return bool;
		} catch (Exception e) {
			log.error("failed to pwdTimeout vendorUser,cause:", e);
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("vendorUser.find.fail"));
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
			Response<VendorModel> response = vendorService.findVendorById(Long.parseLong(userId));
			// 查询是否成功
			if (response.isSuccess()) {
				VendorModel vendorModel = response.getResult();
				// 比较时间是否大于90天
				Date dt = new Date();
				if (vendorModel.getEditPwTime() != null) {
					long time = dt.getTime() - vendorModel.getEditPwTime().getTime();
					long timeout = time / (1000 * 60 * 60 * 24);

					if (timeout > 89) {
						request.getSession().setAttribute("pwdTimeout", true);
					}
				}
			}
		} catch (Exception e) {
			log.error("failed to pwdTimeout vendorUser,cause:", e);
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("vendorUser.find.fail"));
		}
	}

	/**
	 * 退出登录
	 *
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	@ResponseBody
	public String logout(HttpServletRequest request) {
		try {
			request.getSession().invalidate();
			return "ok";
		} catch (Exception e) {
			log.error("failed to logout vendorUser,cause:", e);
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("vendorUser.logout.fail"));
		}
	}

	/**
	 * session中获取是否第一次登录
	 *
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/vendorIsFirstLogin", method = RequestMethod.POST)
	@ResponseBody
	public Boolean vendorIsFirstLogin(HttpServletRequest request) {
		Boolean isFirst = false;
		try {
			// 获取账户信息
			Object object = request.getSession().getAttribute("vendorIsFirstLogin");
			if (object != null) {
				if (Contants.LOGIN_ISFIRST_0.equals(object.toString())) {
					isFirst = true;
				}
				request.getSession().removeAttribute("vendorIsFirstLogin");
			}
			return isFirst;
		} catch (Exception e) {
			log.error("failed to logout vendorUser,cause:", e);
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("vendorUser.logout.fail"));
		}
	}

	/**
	 * 新建子帐号
	 *
	 * @param vendorModel
	 * @return
	 */
	@RequestMapping(value = "/create", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String create(VendorModel vendorModel, HttpServletRequest request, HttpServletResponse response) {
		User user = UserUtil.getUser();
		try {
			if (user == null) {
				throw new ResponseException("user.not.login.yet");
			}
			if (Strings.isNullOrEmpty(vendorModel.getPassword())) {
				log.error("failed to modifyPwd vendorUser,cause:", "login.password.can.not.be.empty");
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("login.password.can.not.be.empty"));
			}
			// 校验用户名是否重复
			checkArgument(NameValidator.isAllowedUserName(vendorModel.getName()), "user.name.duplicated");
			// 校验密码信息
			EEA1InfoResult eEA1InfoResult = ePinService.EEA1(request, vendorModel.getPassword());
			vendorModel.setPassword(eEA1InfoResult.getPinBlock());
			vendorModel.setShopType("YG");
			vendorModel.setStatus("0102");
			vendorModel.setLevel("1");
			vendorModel.setCode(vendorModel.getId());
			vendorModel.setVendorId(user.getVendorId());
			vendorModel.setModifyOper(user.getName());
			vendorModel.setCreateOper(user.getName());
			vendorModel.setParentId(user.getId());
			vendorModel.setIsSub("1");
			request.getSession().removeAttribute("randomPwd");
			Response<String> result = vendorService.create(vendorModel);
			return result.getResult();
		} catch (IllegalArgumentException e) {
			log.error("failed to create {}, error:{}", user, e.getMessage());
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (IllegalStateException e) {
			log.error("failed to create {}, error:{}", user, e.getMessage());
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("failed to create {},error code:{}", vendorModel, e.getMessage());
			throw new ResponseException(500, messageSources.get(messageSources.get(e.getMessage())));
		}
	}

	/**
	 * 修改
	 *
	 * @param vendorModel
	 * @return add by liuhan
	 */
	@RequestMapping(value = "/update", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String updateAll(VendorModel vendorModel) {
		User user = UserUtil.getUser();
		if (user == null) {
			throw new ResponseException("user.not.login.yet");
		}
		if (Strings.isNullOrEmpty(vendorModel.getPassword())) {
			log.error("failed to modifyPwd vendorUser,cause:", "login.password.can.not.be.empty");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("login.password.can.not.be.empty"));
		}
		vendorModel.setModifyOper(user.getName());
		Response<Boolean> result = vendorService.updateAll(vendorModel);
		if (result.isSuccess()) {
			return "ok";
		}
		log.error("failed to update userInfo {},error code:{}", vendorModel, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 修改密码
	 *
	 * @param vendorModel
	 * @param request
	 * @param responsel
	 * @return add by liuhan
	 */
	@RequestMapping(value = "/updatePassWord", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String updatePassWord(VendorModel vendorModel, HttpServletRequest request, HttpServletResponse responsel) {
		User user = UserUtil.getUser();
		if (Strings.isNullOrEmpty(vendorModel.getPassword())) {
			log.error("failed to modifyPwd vendorUser,cause:", "param.not.null.fail");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("param.not.null.fail"));
		}
		// 校验密码信息
		EEA1InfoResult eEA1InfoResult = ePinService.EEA1(request, vendorModel.getPassword());
		vendorModel.setModifyOper(user.getName());
		vendorModel.setPassword(eEA1InfoResult.getPinBlock());
		vendorModel.setEditPwTime(new Date());
		request.getSession().removeAttribute("randomPwd");
		Response<Boolean> result = vendorService.updateAll(vendorModel);
		if (result.isSuccess()) {
			return "ok";
		}
		log.error("failed to update userInfo {},error code:{}", vendorModel, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 删除子帐号
	 *
	 * @param id
	 * @param vendorModel
	 * @return add by liuhan
	 */
	@RequestMapping(value = "{id}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String update(@PathVariable("id") String id, VendorModel vendorModel) {
		User user = UserUtil.getUser();
		vendorModel.setModifyOper(user.getName());
		vendorModel.setId(id);
		Response<Boolean> result = vendorService.updateAll(vendorModel);
		if (result.isSuccess()) {
			return "ok";
		}
		log.error("failed to update userInfo {},error code:{}", vendorModel, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}
}
