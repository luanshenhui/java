/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.web.controller;

import static com.google.common.base.Objects.equal;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.cgbchina.rest.visit.model.user.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.common.utils.CommonConstants;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.ValidateUtil;
import cn.com.cgbchina.item.dto.BrowseHistoryInfoDateDto;
import cn.com.cgbchina.item.dto.BrowseHistoryInfoDto;
import cn.com.cgbchina.item.service.BrowseHistoryService;
import cn.com.cgbchina.related.model.CouponInfModel;
import cn.com.cgbchina.related.model.TblParametersModel;
import cn.com.cgbchina.related.service.BusinessService;
import cn.com.cgbchina.related.service.CouPonInfService;
import cn.com.cgbchina.rest.visit.model.coupon.ProvideCouponPage;
import cn.com.cgbchina.rest.visit.service.coupon.CouponService;
import cn.com.cgbchina.rest.visit.service.user.UserService;
import cn.com.cgbchina.user.dto.LoginDto;
import cn.com.cgbchina.user.service.MallUserService;
import cn.com.cgbchina.web.utils.ClientRSADecode;
import cn.com.cgbchina.web.utils.Tools;
import lombok.extern.slf4j.Slf4j;

/**
 * @author wusy
 * @version 1.0
 * @Since 2016/7/2.
 */
@RequestMapping("/api/user")
@Controller
@Slf4j
public class MallUser {
	private final static String CUSTOMER_LOGIN = "mallLogin";
	private final static String CUSTOMER_LOGIN_VALUE = "1";
	private static Integer ERRORCOUNT = 0; // 输入的错误密码次数

	@Autowired
	private MallUserService mallUserService;
	@Autowired
	private UserService userService;
	@Autowired
	private CouponService couponService;
	@Autowired
	private CouPonInfService couPonInfService;
	@Autowired
	private LoginRedirector loginRedirector;
	@Resource
	private CaptchaGenerator captchaGenerator;
	@Autowired
	private MessageSources messageSources;
	@Autowired
	private BusinessService businessService;
	@Autowired
	private BrowseHistoryService browseHistoryService;

	@Value("#{app.domain}")
	private String domain;

	@Value("#{app.mainSite}")
	private String mainSite;

	/**
	 * 商城用户登录
	 *
	 * @param userName 登录名
	 * @param aPassword A加密
	 * @param ePassword E加密
	 * @param code 验证码
	 * @param ip ip
	 * @param mac mac
	 * @param hardNo hardNo
	 * @param mainNo mainNo
	 * @param isCreditCard 信用卡判断
	 * @param logonType 登录类型
	 * @param target 路径
	 * @param request request
	 * @param response response
	 * @return 登录返回信息
	 */
	@RequestMapping(value = "/login", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public LoginDto login(@RequestParam("userName") String userName, @RequestParam("aPassword") String aPassword,
			@RequestParam("ePassword") String ePassword, @RequestParam("code") String code,
			@RequestParam("clientIP") String ip, @RequestParam("clientMacAdress") String mac,
			@RequestParam("clientHarddiskNo") String hardNo, @RequestParam("clientMainboardNo") String mainNo,
			@RequestParam("isCreditCard") Byte isCreditCard, @RequestParam("logonType") Byte logonType,
			@RequestParam(value = "target", required = false) String target, HttpServletRequest request,
			HttpServletResponse response) {

		LoginDto loginDto = new LoginDto();

		// 校验启停
		Response<List<TblParametersModel>> re = businessService.findByWebLogin();
		if (!re.isSuccess()) {
			log.error("business.find.web.login.error");
			// 返回错误信息
			loginDto.setErrorMes(messageSources.get(re.getError()));
			return loginDto;
		}
		List<TblParametersModel> list = re.getResult();
		// 商城停止登录
		if (0 == list.get(0).getOpenCloseFlag()) {
			log.error(list.get(0).getPrompt());
			// 返回错误信息
			loginDto.setErrorMes(list.get(0).getPrompt());
			return loginDto;
		}

		// 验证码不空的情况下，验证正确性
		if (StringUtils.isNotEmpty(code)) {
			if (!checkCode(code, request)) {
				log.error("captcha.code.not.correct,code:{}", code);
				// 返回错误信息
				loginDto.setErrorMes("captcha.code.not.correct");
				return loginDto;
			}
		}

		// 加密的ip/mac数据进行解密
		ClientRSADecode clientRSADecode = new ClientRSADecode();
		String clientIP = clientRSADecode.getProclaimedIP(ip);
		String clientMacAdress = clientRSADecode.getProclaimedMAC(mac);
		log.info("login clientIP:************" + clientIP);
		log.info("login clientMacAdress:***********" + clientMacAdress);

		// 登录
		LoginInfo loginInfo = new LoginInfo();
		loginInfo.setAccPassword(aPassword);
		loginInfo.setUserPassword(ePassword);
		loginInfo.setIsCreditCard(isCreditCard);
		loginInfo.setLogonType(logonType);
		loginInfo.setLoginId(userName);
		loginInfo.setClientIP(ip);
		loginInfo.setClientMainboardNo(mainNo);
		loginInfo.setClientHarddiskNo(hardNo);
		loginInfo.setClientMacAddress(mac);

		// 项目校验
		if (ValidateUtil.validateModel(loginInfo).length() != 0) {
			loginDto.setErrorMes(messageSources.get("model.is.empty"));
			return loginDto;
		}
		// 调用网银接口登录
		LoginResult loginResult = userService.login(loginInfo);
		if (loginResult == null) {
			loginDto.setErrorMes(messageSources.get("login.info.is.empty"));
			return loginDto;
		}

		if (!Contants.LOGIN_RETRUN_CODE_00000000.equals(loginResult.getRetCode())) {
			// 帐号正确，但是没有注册网银
			if (Contants.LOGIN_RETRUN_CODE_00000002.equals(loginResult.getRetCode())) {
				// 电话为空
				if (loginResult.getMobileNo() == null || loginResult.getMobileNo().length() == 0) {
					loginDto.setErrorMes(messageSources.get("user.bank.mobile.empty"));
					return loginDto;
				}
				// 电话格式不正确
				if (ValidateUtil.validateModel(loginResult).length() != 0) {
					loginDto.setErrorMes(messageSources.get("user.bank.mobile.fail"));
					return loginDto;
				}
				// 电话银行/手机银行进行校验
				if (Contants.IS_CHECK_PASSWORD_PHONE.equals(loginResult.getIsCheckPassword())
						|| Contants.IS_CHECK_PASSWORD_MOBILE.equals(loginResult.getIsCheckPassword())) {
					if ("0".equals(loginResult.getCheckChannelState())) {
						// 渠道密码校验画面
						loginDto.setUrl(
								"http://shop.cgb.cn/check_pwd?isCheckPassword=" + loginResult.getIsCheckPassword()
										+ "&accountNo=" + userName + "&certNo=" + loginResult.getCertNo() + "&certType="
										+ loginResult.getCertType() + "&customerName=" + loginResult.getCustomerName()
										+ "&isCreditCard=" + isCreditCard + "&mobileNo=" + loginResult.getMobileNo());
						return loginDto;
					} else {
						if ("2".equals(loginResult.getCheckChannelState())) {
							loginDto.setErrorMes(messageSources.get("check.channel.state.2"));
						} else if ("4".equals(loginResult.getCheckChannelState())) {
							loginDto.setErrorMes(messageSources.get("check.channel.state.4"));
						} else if ("5".equals(loginResult.getCheckChannelState())) {
							loginDto.setErrorMes(messageSources.get("check.channel.state.5"));
						} else if ("6".equals(loginResult.getCheckChannelState())) {
							loginDto.setErrorMes(messageSources.get("check.channel.state.6"));
						} else if ("A".equals(loginResult.getCheckChannelState())) {
							loginDto.setErrorMes(messageSources.get("check.channel.state.A"));
						} else {
							loginDto.setErrorMes(messageSources.get("check.channel.state.other"));
						}
						if (StringUtils.isNotEmpty(loginResult.getCustomerId())) {
							insertLog(loginResult.getCustomerId(), clientIP, clientMacAdress,
									Contants.LOGIN_STATUS_FALSE, request);
						}
						return loginDto;
					}
				} else if (!Contants.IS_CHECK_PASSWORD_NULL.equals(loginResult.getIsCheckPassword())) {
					if (StringUtils.isNotEmpty(loginResult.getCustomerId())) {
						insertLog(loginResult.getCustomerId(), clientIP, clientMacAdress, Contants.LOGIN_STATUS_FALSE,
								request);
					}
					loginDto.setErrorMes((messageSources.get("check.password")));
					return loginDto;
				}
				// 注册
				loginDto.setUrl("http://" + mainSite + "/login_setting?isCreditCard=" + isCreditCard + "&accountNo="
						+ userName + "&accPassword=" + aPassword + "&mobileNo=" + loginResult.getMobileNo() + "&email="
						+ loginResult.getEmail());
				return loginDto;
			} else {
				log.error("failed to login user by id={},error code:{}", userName, loginResult.getRetErrMsg());
				// 判断session错误是否已经存在
				if (request.getSession().getAttribute(userName + "pwErorr") != null) {
					ERRORCOUNT = ERRORCOUNT + 1;
				} else {
					ERRORCOUNT = 0;
				}
				request.getSession().setAttribute(userName + "pwErorr", ERRORCOUNT);// 错误次数绑定session
				// 返回错误次数
				loginDto.setCount(ERRORCOUNT);
				// 返回错误信息
				loginDto.setErrorMes(loginResult.getRetErrMsg());
				if (StringUtils.isNotEmpty(loginResult.getCustomerId())) {
					insertLog(loginResult.getCustomerId(), clientIP, clientMacAdress, Contants.LOGIN_STATUS_FALSE,
							request);
				}
				return loginDto;
			}
		}
		// 登录白名单启用
		if (0 == list.get(1).getOpenCloseFlag()) {
			// 查询当前存在用户是否在白名单当中
			Response<Boolean> bool = mallUserService.findWhiteCustIdList(loginResult.getCustomerId());
			if (!bool.isSuccess()) {
				// 返回错误信息
				loginDto.setErrorMes(messageSources.get(bool.getError()));
				return loginDto;
			}
			// 是否用户在白名单当中
			if (!bool.getResult()) {
				// 返回错误信息
				loginDto.setErrorMes(list.get(1).getPrompt());
				return loginDto;
			}
		}

		// 登录成功
		// 存储信息
		request.getSession().setAttribute(loginResult.getCustomerId(), loginResult);
		User user = new User();
		user.setId(loginResult.getCustomerId());
		user.setName(loginResult.getCustomerName());
		user.setMobile(loginResult.getMobileNo());
		// 返回信息存储
		request.getSession().setAttribute(CommonConstants.SESSION_USER_ID, user.getId());

		// 清除错误绑定次数
		request.getSession().removeAttribute(userName + "pwErorr");
		// cookie CustomerLogin 设置为1,过期时间为30分钟
		Cookie mallUser = new Cookie(CUSTOMER_LOGIN, CUSTOMER_LOGIN_VALUE);
		mallUser.setMaxAge(30 * 60);
		// 在所有页面下都可见
		mallUser.setPath("/");
		mallUser.setDomain(domain);
		response.addCookie(mallUser);

		// 插入登录log
		if (StringUtils.isNotEmpty(loginResult.getCustomerId())) {
			insertLog(loginResult.getCustomerId(), clientIP, clientMacAdress, Contants.LOGIN_STATUS_TRUE, request);
		}
		// 查询用户是否已经登录 TODO 第二次交付内容，待开发
		// Response<Boolean> result = mallUserService.selectLoginLog(loginResult.getCustomerId());
		// if (!result.getResult()) {
		// // 发放优惠卷
		// firstSendCoupon(loginResult.getCertNo(), loginResult.getCertType());
		// }

		loginDto.setUrl(loginRedirector.redirectTarget(target, user));
		return loginDto;

	}

	/**
	 * 首次登录设置
	 *
	 * @param registerInfo 首次设置信息
	 * @param ip ip
	 * @param mac mac
	 * @param verifyCode 手机验证码
	 * @param target 路径
	 * @param request request
	 * @param response response
	 * @return 注册返回信息
	 */
	@RequestMapping(value = "/register", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public LoginDto loginSetting(RegisterInfo registerInfo, @RequestParam("clientIP") String ip,
			@RequestParam("clientMacAdress") String mac, @RequestParam("verifyCode") String verifyCode,
			@RequestParam(value = "target", required = false) String target, HttpServletRequest request,
			HttpServletResponse response) {

		LoginDto loginDto = new LoginDto();
		// 项目校验
		if (ValidateUtil.validateModel(registerInfo).length() != 0) {
			loginDto.setErrorMes(messageSources.get("register.model.is.empty"));
			return loginDto;
		}

		registerInfo.setSmsCheckCode(verifyCode);
		// 加密的ip/mac数据进行解密
		ClientRSADecode clientRSADecode = new ClientRSADecode();
		String clientIP = clientRSADecode.getProclaimedIP(ip);
		String clientMacAdress = clientRSADecode.getProclaimedMAC(mac);
		log.info("login clientIP:************" + clientIP);
		log.info("login clientMacAdress:***********" + clientMacAdress);

		// 注册
		RegisterResult registerResult = userService.register(registerInfo);
		if (registerResult == null) {
			loginDto.setErrorMes("register.info.is.empty");
			return loginDto;
		}
		if (!Contants.LOGIN_RETRUN_CODE_00000000.equals(registerResult.getRetCode())) {
			log.error("failed to register user by id={},type={},error code:{}", registerInfo.getCertNo(),
					registerResult.getRetErrMsg());
			// 返回错误信息
			loginDto.setErrorMes(registerResult.getRetErrMsg());
			return loginDto;
		}
		// 注册成功
		request.getSession().setAttribute(registerResult.getCustomerId(), registerResult);
		User user = new User();
		user.setId(registerResult.getCustomerId());
		// 返回信息存储
		request.getSession().setAttribute(CommonConstants.SESSION_USER_ID, user.getId());

		// cookie CustomerLogin 设置为1,过期时间为30分钟
		Cookie mallUser = new Cookie(CUSTOMER_LOGIN, CUSTOMER_LOGIN_VALUE);
		mallUser.setMaxAge(30 * 60);
		// 在所有页面下都可见
		mallUser.setPath("/");
		mallUser.setDomain(domain);
		response.addCookie(mallUser);
		// 插入登录log
		if (StringUtils.isNotEmpty(registerResult.getCustomerId())) {
			insertLog(registerResult.getCustomerId(), clientIP, clientMacAdress, Contants.LOGIN_STATUS_TRUE, request);
		}
		// 首次登录发放优惠卷 TODO 第二次交付内容，待开发
		// firstSendCoupon(registerResult.getCertNo(), registerResult.getCertType());
		loginDto.setUrl(loginRedirector.redirectTarget(target, user));
		return loginDto;
	}

	/**
	 * 首次优惠卷设置
	 * 
	 * @param certNo 证件号
	 * @param certType 证件类型
	 */
	private void firstSendCoupon(String certNo, String certType) {
		// 获取首次发放优惠卷信息
		Response<CouponInfModel> res = couPonInfService.findByFirstLogin();
		// 是否有首次登录优惠券设置
		if (res.isSuccess()) {

			// 首次登录发放优惠卷
			ProvideCouponPage provideCouponPage = new ProvideCouponPage();
			provideCouponPage.setChannel(Contants.CHANNEL_BC);
			provideCouponPage.setContIdCard(certNo);
			provideCouponPage.setContIdType(certType);
			provideCouponPage.setGrantType(Contants.GRANT_TYPE_1);
			provideCouponPage.setProjectNO(res.getResult().getCouponId());

			couponService.provideCoupon(provideCouponPage);
		}
	}

	/**
	 * 获取手机短信验证码
	 *
	 * @param mobileNo 手机号
	 */
	@RequestMapping(value = "/getValidate", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public void getValidate(@RequestParam("mobileNo") String mobileNo) {
		try {
			if (!StringUtils.isNotEmpty(mobileNo)) {
				log.error("user.mobile.empty");
				// 返回错误信息
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("user.mobile.empty"));
			}
			MobileValidCode mobileValidCode = new MobileValidCode();
			mobileValidCode.setMobileNo(mobileNo);
			// 获取短息验证码
			MobileValidCodeResult mobileValidCodeResult = userService.getMobileValidCode(mobileValidCode);
			if (!Contants.LOGIN_RETRUN_CODE_00000000.equals(mobileValidCodeResult.getRetCode())) {
				log.error("failed to getValidate ,error :{}", mobileValidCodeResult.getRetErrMsg());
				// 返回错误信息
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("getValidate.is.failed"));
			}
		} catch (Exception e) {
			log.error("get.validate.false,cause:", e);
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("getValidate.is.failed"));
		}
	}

	/**
	 * 渠道校验密码
	 *
	 * @param channelPwdInfo 渠道验证信息
	 * @return 验证信息
	 */
	@RequestMapping(value = "/checkPwd", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public LoginDto checkPwd(ChannelPwdInfo channelPwdInfo, @RequestParam("isCreditCard") String isCreditCard) {
		try {
			// 项目校验
			if (ValidateUtil.validateModel(channelPwdInfo).length() != 0) {
				log.error("model.is.empty");
				// 返回错误信息
				throw new ResponseException(Contants.ERROR_CODE_500, "model.is.empty");

			}
			// 渠道密码校验
			CheckChannelPwdResult checkChannelPwdResult = userService.checkChannelPwd(channelPwdInfo);
			if (!Contants.LOGIN_RETRUN_CODE_00000000.equals(checkChannelPwdResult.getRetCode())) {
				log.error("failed to checkPwd ,error :{}", checkChannelPwdResult.getRetErrMsg());
				// 返回错误信息
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("checkPwd.is.failed"));
			}

			LoginDto loginDto = new LoginDto();
			// 获取用户信息
			QueryUserInfo queryUserInfo = new QueryUserInfo();
			queryUserInfo.setCertNo(channelPwdInfo.getCertNo());
			UserInfo user = userService.getCousrtomInfo(queryUserInfo);
			if ("0".equals(checkChannelPwdResult.getIsCheckPass().toString())) {
				// 电话为空
				if (channelPwdInfo.getMobileNo() == null || channelPwdInfo.getMobileNo().length() == 0) {
					loginDto.setErrorMes(messageSources.get("user.bank.mobile.empty"));
					return loginDto;
				}
				// 电话格式不正确
				if (!Tools.isPhone(channelPwdInfo.getMobileNo())) {
					loginDto.setErrorMes(messageSources.get("user.bank.mobile.fail"));
					return loginDto;
				}
				// 校验成功跳转注册
				loginDto.setUrl("http://" + mainSite + "/login_setting?isCreditCard=" + isCreditCard + "&accountNo="
						+ channelPwdInfo.getAccountNo() + "&accPassword=" + channelPwdInfo.getAccPassword()
						+ "&mobileNo=" + channelPwdInfo.getMobileNo() + "&email=" + user.getEmail());
				return loginDto;
			} else {
				loginDto.setErrorMes(checkChannelPwdResult.getRetErrMsg());
				return loginDto;
			}
		} catch (Exception e) {
			log.error("get.validate.false,cause:", e);
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("checkPwd.is.failed"));
		}
	}

	/**
	 * 校验验证码
	 *
	 * @param code 验证码
	 * @param request request
	 * @return 校验是否正确
	 */
	private boolean checkCode(String code, HttpServletRequest request) {
		// 验证码为空
		if (Strings.isNullOrEmpty(code)) {
			return false;
		}
		// 校验验证码
		String sessionCode = captchaGenerator.getGeneratedText(request.getSession());
		// 验证码是否正确
		return equal(code, sessionCode);
	}

	/**
	 * 登录之后插入log
	 *
	 * @param custId 用户ID
	 * @param clientIP ip
	 * @param clientMacAdress mac
	 * @param status 状态
	 */
	private void insertLog(String custId, String clientIP, String clientMacAdress, String status,
			HttpServletRequest request) {
		Response<Long> response = mallUserService.mallLoginLog(custId, clientIP, clientMacAdress, status);
		if (!response.isSuccess()) {
			log.error("insert.login.false,cause:", response.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("insert.login.false"));
		}
		// 退出登录时候使用
		request.getSession().setAttribute("loginLogId", response.getResult());
	}

	/**
	 * 退出登录
	 *
	 * @param request request
	 * @return 是否退出成功
	 */
	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	@ResponseBody
	public Boolean logout(HttpServletRequest request) {
		try {
			// 获取登录者ID
			Object obj = request.getSession().getAttribute("loginLogId");
			if (obj != null) {
				// 退出商城
				Response response = mallUserService.updateLogoutTime(Long.parseLong(obj.toString()));
				if (!response.isSuccess()) {
					log.error("logout.fail,cause:", response.getError());
					throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("logout.fail"));
				}
			}
			request.getSession().invalidate();
			return true;
		} catch (Exception e) {
			log.error("logout.fail,cause:", e);
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("logout.fail"));
		}
	}

	/**
	 * 密码防重
	 *
	 * @return 返回随机数
	 */
	@RequestMapping(value = "/getRandomCode", method = RequestMethod.POST)
	@ResponseBody
	public String getRandomCode() {
		try {
			// 获取随机数
			RandomCode randomCode = userService.getRandomCodeReq();
			if (randomCode == null) {
				return null;
			} else {
				return randomCode.getTransferFlowNo() + "|" + randomCode.getRandomPwd();
			}
		} catch (Exception e) {
			log.error("get.random.code.fail,cause:", e);
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("get.random.code.fail"));
		}
	}

	/**
	 * 获取足迹
	 *
	 * @return 返回足迹信息
	 */
	@RequestMapping(value = "/getBrowseHistory", method = RequestMethod.POST)
	@ResponseBody
	public List<BrowseHistoryInfoDto> getBrowseHistory() {
		List<BrowseHistoryInfoDateDto> browseHistoryList = new ArrayList<BrowseHistoryInfoDateDto>();
		List<BrowseHistoryInfoDto> browseHistoryList2 = new ArrayList<BrowseHistoryInfoDto>();
		try {
			// 查询足迹
			browseHistoryList = browseHistoryService.browseHistoryByPager(0, 10).getResult().getData();
			List<BrowseHistoryInfoDto> browseHistoryInfoList = new ArrayList<BrowseHistoryInfoDto>();
			// 整理数据
			if (browseHistoryList != null && browseHistoryList.size() > 0) {
				browseHistoryInfoList = browseHistoryList.get(0).getBrowseHistoryInfoDto();
			}
			if (browseHistoryInfoList != null && browseHistoryInfoList.size() > 0) {
				browseHistoryList2.add(browseHistoryInfoList.get(0));
				if (browseHistoryInfoList.size() > 1) {
					browseHistoryList2.add(browseHistoryInfoList.get(1));
				}
			}
			return browseHistoryList2;
		} catch (Exception e) {
			log.error("get.browse.history.error", e);
			return Lists.newArrayList();
		}
	}
}
