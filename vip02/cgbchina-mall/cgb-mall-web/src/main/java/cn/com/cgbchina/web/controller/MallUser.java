/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.web.controller;

import static com.google.common.base.Objects.equal;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.CompletionService;
import java.util.concurrent.ExecutorCompletionService;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.cgbchina.rest.visit.model.coupon.CouponInfo;
import cn.com.cgbchina.trade.service.RedisService;
import cn.com.cgbchina.user.service.UserInfoService;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
import cn.com.cgbchina.rest.visit.model.coupon.ProvideCouponResult;
import cn.com.cgbchina.rest.visit.model.user.ChannelPwdInfo;
import cn.com.cgbchina.rest.visit.model.user.CheckChannelPwdResult;
import cn.com.cgbchina.rest.visit.model.user.LoginInfo;
import cn.com.cgbchina.rest.visit.model.user.LoginResult;
import cn.com.cgbchina.rest.visit.model.user.MobileValidCode;
import cn.com.cgbchina.rest.visit.model.user.MobileValidCodeResult;
import cn.com.cgbchina.rest.visit.model.user.QueryUserInfo;
import cn.com.cgbchina.rest.visit.model.user.RandomCode;
import cn.com.cgbchina.rest.visit.model.user.RegisterInfo;
import cn.com.cgbchina.rest.visit.model.user.RegisterResult;
import cn.com.cgbchina.rest.visit.service.coupon.CouponService;
import cn.com.cgbchina.rest.visit.service.user.UserService;
import cn.com.cgbchina.user.dto.CheckPwdDto;
import cn.com.cgbchina.user.dto.LoginDto;
import cn.com.cgbchina.user.dto.LoginSettingDto;
import cn.com.cgbchina.user.model.EspCustNewModel;
import cn.com.cgbchina.user.service.EspCustNewService;
import cn.com.cgbchina.user.service.MallUserService;
import cn.com.cgbchina.web.utils.ClientRSADecode;
import cn.com.cgbchina.web.utils.Tools;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.common.utils.CommonConstants;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

/**
 * @author wusy
 * @version 1.0
 */
@RequestMapping("/api/user")
@Controller
@Slf4j
public class MallUser {
	private final static String CUSTOMER_LOGIN = "mallLogin";
	private final static String CUSTOMER_LOGIN_VALUE = "1";

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
	@Autowired
	private ClientRSADecode clientRSADecode;
	@Autowired
	private EspCustNewService espCustNewService;
	@Resource
	private RedisService redisService;
	@Resource
	private UserInfoService userInfoService;

	@Value("#{app.domain}")
	private String domain;

	@Value("#{app.mainSite}")
	private String mainSite;
	private final Pattern checkPhone = Pattern.compile("^[+]{0,1}(\\d){1,3}[ ]?([-]?((\\d)|[ ]){1,12})+$");
	private final Pattern checkMobile = Pattern.compile("^1[3|4|5|7|8][0-9]{9}$");

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
			@RequestParam("isCreditCard") String isCreditCard, @RequestParam("logonType") String logonType,
			@RequestParam(value = "target", required = false) String target, HttpServletRequest request,
			HttpServletResponse response, @RequestParam("transferFlowNo") String transferFlowNo) {

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
		if (1 == list.get(0).getOpenCloseFlag()) {
			log.error(list.get(0).getPrompt());
			// 返回错误信息
			loginDto.setErrorMes(list.get(0).getPrompt());
			return loginDto;
		}

		// 验证码不空的情况下，验证正确性
		if (!checkCode(code, request)) {
			log.error("captcha.code.not.correct,code:{}", code);
			// 返回错误信息
			loginDto.setErrorMes(messageSources.get("captcha.code.not.correct"));
			return loginDto;
		}

		// 加密的ip/mac数据进行解密
		String clientIP = clientRSADecode.getProclaimedIP(ip);
		String clientMacAdress = clientRSADecode.getProclaimedMAC(mac);

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
		loginInfo.setTransferFlowNo(transferFlowNo);

		// 项目校验
		if (ValidateUtil.validateModel(loginInfo).length() != 0) {
			loginDto.setErrorMes(messageSources.get("model.is.empty"));
			return loginDto;
		}
		// 调用网银接口登录
		log.info("login interface start");
		LoginResult loginResult = userService.login(loginInfo);
		log.info("login interface end");
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
						CheckPwdDto checkPwdDto = new CheckPwdDto();
						checkPwdDto.setAccountNo(userName);
						checkPwdDto.setMobileNo(loginResult.getMobileNo());
						checkPwdDto.setCertNo(loginResult.getCertNo());
						checkPwdDto.setCertType(loginResult.getCertType());
						checkPwdDto.setCustomerName(loginResult.getCustomerName());
						checkPwdDto.setEmail(loginResult.getEmail());
						checkPwdDto.setTransferFlowNo(transferFlowNo);
						checkPwdDto.setPhoneNo(loginResult.getPhoneNo());
						// 存储信息
						request.getSession().setAttribute("checkPwdDto", checkPwdDto);
						loginDto.setUrl("http://" + mainSite + "/check_pwd?isCheckPassword="
								+ loginResult.getIsCheckPassword() + "&isCreditCard=" + isCreditCard);
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
				LoginSettingDto loginSettingDto = new LoginSettingDto();
				loginSettingDto.setAccountNo(userName);
				loginSettingDto.setAccPassword(aPassword);
				loginSettingDto.setEmail(loginResult.getEmail());
				loginSettingDto.setTransferFlowNo(transferFlowNo);
				loginSettingDto.setPhoneNo(loginResult.getPhoneNo());
				loginSettingDto.setMobileNo(loginResult.getMobileNo());
				// 存储信息
				request.getSession().setAttribute("loginSettingDto", loginSettingDto);
				loginDto.setUrl("http://" + mainSite + "/login_setting?isCreditCard=" + isCreditCard);
				return loginDto;
			} else {
				log.error("failed to login user by id={},error code:{}", userName, loginResult.getRetErrMsg());
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
		// 返回信息存储
		request.getSession().setAttribute(CommonConstants.SESSION_USER_ID, user.getId());

		// cookie CustomerLogin 设置为1,过期时间为30分钟
		Cookie mallUser = new Cookie(CUSTOMER_LOGIN, CUSTOMER_LOGIN_VALUE);
		mallUser.setMaxAge(30 * 60);
		// 在所有页面下都可见
		mallUser.setPath("/");
		mallUser.setDomain(domain);
		response.addCookie(mallUser);

		// 查询用户是否已经登录
		Response<Boolean> result = mallUserService.selectLoginLog(loginResult.getCustomerId());
		if(!result.isSuccess()){
			log.error("Response.error,error code: {}", result.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
		}
		if (!result.getResult()) {
			// 发放优惠卷,获取优惠卷名称
			String couponNm = firstSendCoupon(loginResult.getCertNo(), loginResult.getCertType());
			loginDto.setCouponNm(couponNm);
		}
		// 插入登录log,插入或更新生日价使用次数信息表
		if (StringUtils.isNotEmpty(loginResult.getCustomerId())) {
			insertLog(loginResult.getCustomerId(), clientIP, clientMacAdress, Contants.LOGIN_STATUS_TRUE, request);
			EspCustNewModel espCustNewModel = new EspCustNewModel();
			espCustNewModel.setCustId(loginResult.getCustomerId());
			espCustNewModel.setBirthUsedCount(0);
			espCustNewModel.setLoginIp(clientIP);
			espCustNewModel.setLoginMac(clientMacAdress);
			espCustNewModel.setSessionId(loginResult.getCustomerId());
			insOrUpdCustNew(espCustNewModel);
		}
		loginDto.setUrl(loginRedirector.redirectTarget(target, user));

		try {
			ExecutorService executorService = Executors.newCachedThreadPool();
			CompletionService<Boolean> completionService
					= new ExecutorCompletionService<Boolean>(executorService);
			completionService.submit(getCouponInfos(loginResult.getCertType(),
					loginResult.getCertNo(),
					user.getId()));
			executorService.shutdown();
		}
		catch (Exception e) {
			log.info("优惠券接口调用失败:{}", e.getMessage());
			log.info(e.getMessage());

		}
		return loginDto;
	}

	/**
	 * 异步执行优惠券取得
	 */
	private Callable<Boolean> getCouponInfos(final String contIdType, final String certNo, final String userid) {
		 Callable<Boolean> ret = new Callable() {
			@Override
			public Boolean call() throws Exception {
				Response<List<CouponInfo>> listResponse = redisService.getCoupons(
						userid,
						contIdType,
						certNo);
				return false;
			}
		};
		return ret;
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
		// 如果是信用卡，需添加
		if ("0".equals(registerInfo.getIsCreditCard().toString())) {
			registerInfo.setPinBlockFlag("N");
			registerInfo.setValidDateFlag("1");
			// 信用卡有效日期处理 从前天输入的mmyy格式转换成 接口要用的yymm格式
			String cardValidPeriod = registerInfo.getCardValidPeriod();
			registerInfo.setCardValidPeriod(cardValidPeriod.substring(2, 4) + cardValidPeriod.substring(0, 2));
		}
		// 获取信息
		Object obj = request.getSession().getAttribute("loginSettingDto");
		if (obj != null) {
			Map<String, Object> map = (Map<String, Object>) obj;
			registerInfo.setAccPassword(Strings.nullToEmpty((String) (map.get("accPassword"))));
			registerInfo.setEmail(Strings.nullToEmpty((String) (map.get("email"))));
			registerInfo.setAccountNo(Strings.nullToEmpty((String) (map.get("accountNo"))));
			registerInfo.setBacktradeSN(Strings.nullToEmpty((String) (map.get("transferFlowNo"))));
			// 如果返回的电话值跟移动手机值一样 用户没有修改联系电话
			// 默认取手机号当前联系电话
			// 如果session中取得联系电话号为空 那么校验规则
			if (Strings.isNullOrEmpty((String) map.get("phoneNo"))) {
				if (registerInfo.getMobileNo().equals(registerInfo.getPhoneNo())) {
					registerInfo.setMobileNo(Strings.nullToEmpty((String) (map.get("mobileNo"))));
					registerInfo.setPhoneNo(Strings.nullToEmpty((String) (map.get("mobileNo"))));
				} else {
					// 如果不相等 说明用户有改动联系电话 那么对更改后的联系电话进行校验
					registerInfo.setMobileNo(Strings.nullToEmpty((String) (map.get("mobileNo"))));
					// 处理电话
					if (checkMobile.matcher(registerInfo.getPhoneNo()).matches()
							|| checkPhone.matcher(registerInfo.getPhoneNo()).matches()) {
						// 更新后的联系电话写入session
						map.put("phoneNo", registerInfo.getPhoneNo());
						request.getSession().setAttribute("loginSettingDto", map);

					} else {
						throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("phone.check.error"));
					}

				}
			} else {
				// 如果session中的联系电话不为空 说明不是默认的 此时判断用户是否有更改
				String sessionPhoneNumber = (String) map.get("phoneNo");
				if ((sessionPhoneNumber.substring(0, 3) + "****" + sessionPhoneNumber.substring(7,
						((String) map.get("phoneNo")).length())).equals(registerInfo.getPhoneNo())) {
					// 说明联系电话已经回显 但是用户没有修改
					registerInfo.setPhoneNo(sessionPhoneNumber);
				} else {
					// 不相等 用户修改了已经存在的联系电话
					// 处理电话
					if (checkMobile.matcher(registerInfo.getPhoneNo()).matches()
							|| checkPhone.matcher(registerInfo.getPhoneNo()).matches()) {
						// 更新后的联系电话写入session
						map.put("phoneNo", registerInfo.getPhoneNo());
						request.getSession().setAttribute("loginSettingDto", map);
					} else {
						throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("phone.check.error"));
					}

				}
			}

		}
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
		log.info("register interface start");
		RegisterResult registerResult = userService.register(registerInfo);
		log.info("register interface end");
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
		request.getSession().removeAttribute("loginSettingDto");
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
		// 首次登录发放优惠卷 获取优惠卷名称
		String couponNm = firstSendCoupon(registerResult.getCertNo(), registerResult.getCertType());
		loginDto.setCouponNm(couponNm);
		// 插入登录log,插入或更新生日价使用次数信息表
		if (StringUtils.isNotEmpty(registerResult.getCustomerId())) {
			insertLog(registerResult.getCustomerId(), clientIP, clientMacAdress, Contants.LOGIN_STATUS_TRUE, request);
			EspCustNewModel espCustNewModel = new EspCustNewModel();
			espCustNewModel.setCustId(registerResult.getCustomerId());
			espCustNewModel.setBirthUsedCount(0);
			espCustNewModel.setLoginIp(clientIP);
			espCustNewModel.setLoginMac(clientMacAdress);
			espCustNewModel.setSessionId(registerResult.getCustomerId());
			insOrUpdCustNew(espCustNewModel);
		}

		loginDto.setUrl(loginRedirector.redirectTarget(target, user));
		return loginDto;
	}

	/**
	 * 首次优惠卷设置
	 * 
	 * @param certNo 证件号
	 * @param certType 证件类型
	 */
	private String firstSendCoupon(String certNo, String certType) {
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
			provideCouponPage.setNum(1);
			log.info("provideCoupon start");
			ProvideCouponResult result = couponService.provideCoupon(provideCouponPage);
			log.info("provideCoupon end");
			if(result!=null){
				log.error("首次登陆发放优惠卷结果{}" + result);
				log.error("首次登陆发放返回值{},返回中文信息{}", result.getRetCode(), result.getRetErrMsg());
			}

			// 发放优惠卷是否成功
			if (result != null) {
				if (Contants.RETRUN_CODE_000000.equals(result.getReturnCode()))
					return res.getResult().getCouponNm();
			}
		}
		return null;
	}

	/**
	 * 获取手机短信验证码
	 * 
	 * @param request
	 */
	@RequestMapping(value = "/getValidate", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean getValidate(HttpServletRequest request) {
		String mobileNo = null;
		Object obj = request.getSession().getAttribute("loginSettingDto");
		if (obj != null) {
			Map<String, Object> map = (Map<String, Object>) obj;
			mobileNo = Strings.nullToEmpty((String) (map.get("mobileNo")));
		}

		if (!StringUtils.isNotEmpty(mobileNo)) {
			log.error("user.mobile.empty");
			// 返回错误信息
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("user.mobile.empty"));
		}
		//对接收验证码次数进行验证
		Response<String> response = userInfoService.checkPin(mobileNo);
		if(!response.isSuccess()){
			log.error("failed to find PIN，error:{}", response.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));
		}
		String pinCheck = response.getResult();
		if("more6".equals(pinCheck)){
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("user.mobile.pin.most"));
		}
		if("less60".equals(pinCheck)){
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("user.mobile.pin.less"));
		}
		MobileValidCode mobileValidCode = new MobileValidCode();
		mobileValidCode.setMobileNo(mobileNo);
		// 获取短息验证码
		log.info("getMobileValidCode interface start");
		MobileValidCodeResult mobileValidCodeResult = userService.getMobileValidCode(mobileValidCode);
		log.info("getMobileValidCode interface end");
		if (!Contants.LOGIN_RETRUN_CODE_00000000.equals(mobileValidCodeResult.getRetCode())) {
			log.error("failed to getValidate ,error :{}", mobileValidCodeResult.getRetErrMsg());
			// 返回错误信息
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("getValidate.is.failed"));
		}
		return true;

	}

	/**
	 * 渠道校验密码
	 * 
	 * @param channelPwdInfo 渠道验证信息
	 * @return 验证信息
	 */
	@RequestMapping(value = "/checkPwd", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public LoginDto checkPwd(ChannelPwdInfo channelPwdInfo, @RequestParam("transferFlowNo") String transferFlowNo,
			@RequestParam("isCreditCard") String isCreditCard, HttpServletRequest request) {
		String email = "";
		String phoneNo = "";
		// 获取信息
		Object obj = request.getSession().getAttribute("checkPwdDto");
		if (obj != null) {
			Map<String, Object> map = (Map<String, Object>) obj;
			channelPwdInfo.setAccountNo(Strings.nullToEmpty((String) (map.get("accountNo"))));
			channelPwdInfo.setCertNo(Strings.nullToEmpty((String) (map.get("certNo"))));
			channelPwdInfo.setCustomerName(Strings.nullToEmpty((String) (map.get("customerName"))));
			channelPwdInfo.setCertType(Strings.nullToEmpty((String) (map.get("certType"))));
			channelPwdInfo.setMobileNo(Strings.nullToEmpty((String) (map.get("mobileNo"))));
			channelPwdInfo.setBacktradeSN(Strings.nullToEmpty((String) (map.get("transferFlowNo"))));
			channelPwdInfo.setTransferFlowNo(Strings.nullToEmpty(transferFlowNo));
			email = Strings.nullToEmpty((String) (map.get("email")));
			phoneNo = Strings.nullToEmpty((String) (map.get("phoneNo")));
		}
		// 项目校验
		if (ValidateUtil.validateModel(channelPwdInfo).length() != 0) {
			log.error("model.is.empty");
			// 返回错误信息
			throw new ResponseException(Contants.ERROR_CODE_500, "model.is.empty");

		}
		// 渠道密码校验
		log.info("checkChannelPwd interface start");
		CheckChannelPwdResult checkChannelPwdResult = userService.checkChannelPwd(channelPwdInfo);
		log.info("checkChannelPwd interface end");
		if (!Contants.LOGIN_RETRUN_CODE_00000000.equals(checkChannelPwdResult.getRetCode())) {
			log.error("failed to checkPwd ,error :{}", checkChannelPwdResult.getRetErrMsg());
			// 返回错误信息
			throw new ResponseException(Contants.ERROR_CODE_500, checkChannelPwdResult.getRetErrMsg());
		}

		LoginDto loginDto = new LoginDto();
		// 获取用户信息
		QueryUserInfo queryUserInfo = new QueryUserInfo();
		queryUserInfo.setCertNo(channelPwdInfo.getCertNo());
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
			request.getSession().removeAttribute("checkPwdDto");
			LoginSettingDto loginSettingDto = new LoginSettingDto();
			loginSettingDto.setAccountNo(channelPwdInfo.getAccountNo());
			loginSettingDto.setAccPassword(channelPwdInfo.getAccPassword());
			loginSettingDto.setEmail(email);
			loginSettingDto.setTransferFlowNo(transferFlowNo);
			loginSettingDto.setPhoneNo(phoneNo);
			loginSettingDto.setMobileNo(channelPwdInfo.getMobileNo());
			// 存储信息
			request.getSession().setAttribute("loginSettingDto", loginSettingDto);
			loginDto.setUrl("http://" + mainSite + "/mall/login_setting?isCreditCard=" + isCreditCard);
			return loginDto;
		} else {
			loginDto.setErrorMes(checkChannelPwdResult.getRetErrMsg());
			return loginDto;
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
		// 验证码不正确
		if (!equal(code.toLowerCase(), sessionCode.toLowerCase())) {
			return false;
		}
		return true;
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
			log.error("logout.fail,cause:{}", e);
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
			log.info("getRandomCodeReq interface start");
			RandomCode randomCode = userService.getRandomCodeReq();
			log.info("getRandomCodeReq interface end");
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
	 * 获取联系信息
	 * 
	 * @return 返回联系信息
	 */
	@RequestMapping(value = "/getPhone", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public LoginSettingDto getPhone(HttpServletRequest request) {
		LoginSettingDto loginSettingDto = new LoginSettingDto();
		try {
			Object obj = request.getSession().getAttribute("loginSettingDto");
			if (obj != null) {
				Map<String, Object> map = (Map<String, Object>) obj;
				loginSettingDto.setMobileNo(Strings.nullToEmpty((String) (map.get("mobileNo"))));
				loginSettingDto.setPhoneNo(Strings.nullToEmpty((String) (map.get("phoneNo"))));
			}
			// 联系方式特殊处理
			loginSettingDto.setMobileNo(loginSettingDto.getMobileNo().substring(0, 3) + "****"
					+ loginSettingDto.getMobileNo().substring(7, loginSettingDto.getMobileNo().length()));
			if (!Strings.isNullOrEmpty(loginSettingDto.getPhoneNo())) {
				loginSettingDto.setPhoneNo(loginSettingDto.getPhoneNo().substring(0, 3) + "****"
						+ loginSettingDto.getPhoneNo().substring(7, loginSettingDto.getPhoneNo().length()));
			} else {
				// 如果接口返回的电话号为空 那么默认要回显手机号
				loginSettingDto.setPhoneNo(loginSettingDto.getMobileNo().substring(0, 3) + "****"
						+ loginSettingDto.getMobileNo().substring(7, loginSettingDto.getMobileNo().length()));
			}
			return loginSettingDto;
		} catch (Exception e) {
			log.error("get.phone.code.fail,cause:{}", e);
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("get.phone.code.fail"));
		}
	}

	/**
	 * 更新生日价使用次数信息表数据
	 * 
	 * @param espCustNewModel 生日价使用次数信息表数据
	 */
	private void insOrUpdCustNew(EspCustNewModel espCustNewModel) {
		// 获取生日价使用次数信息表， 如果有就更新，没有就插入
		Response response = espCustNewService.insOrUpdCustNew(espCustNewModel);
		if (!response.isSuccess()) {
			log.error("insOrUpdCustNew is error");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));
		}

	}

	/**
	 * 获取足迹
	 * 
	 * @return 返回足迹信息
	 */
	@RequestMapping(value = "/getBrowseHistory", method = RequestMethod.GET)
	@ResponseBody
	public List<BrowseHistoryInfoDto> getBrowseHistory() {
		List<BrowseHistoryInfoDto> browseHistoryList2 = Lists.newArrayList();
		try {
			User user = UserUtil.getUser();
			// 查询足迹
			Response<Pager<BrowseHistoryInfoDateDto>> re = browseHistoryService.browseHistoryByPager(user, 0, 10);

			// 判断取回数据非空，防控指针
			if (!re.isSuccess()) {
				return Lists.newArrayList();
			}
			// 如果不空，接受list
			if (re.getResult() == null) {
				return Lists.newArrayList();
			}
			if (re.getResult().getData() == null && re.getResult().getData().size() <= 0) {
				return Lists.newArrayList();
			}
			List<BrowseHistoryInfoDateDto> browseHistoryList = re.getResult().getData();
			List<BrowseHistoryInfoDto> browseHistoryInfoList = new ArrayList<BrowseHistoryInfoDto>();
			// 整理数据
			// 如果第一个值存在，接收
			if (browseHistoryList != null && browseHistoryList.size() > 0) {
				browseHistoryInfoList = browseHistoryList.get(0).getBrowseHistoryInfoDto();
			}
			// 如果第一个值存在，第二个值存在，取前两项接收
			if (browseHistoryInfoList != null && browseHistoryInfoList.size() > 0) {
				browseHistoryList2.add(browseHistoryInfoList.get(0));
				if (browseHistoryInfoList.size() > 1) {
					browseHistoryList2.add(browseHistoryInfoList.get(1));
				}
			}
			// 返回list
			return browseHistoryList2;
		} catch (Exception e) {
			log.error("get.browse.history.error", e);
			return Lists.newArrayList();
		}
	}
}
