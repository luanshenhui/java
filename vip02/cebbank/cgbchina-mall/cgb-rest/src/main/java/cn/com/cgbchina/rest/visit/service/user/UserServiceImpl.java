package cn.com.cgbchina.rest.visit.service.user;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.connect.ConnectOtherSys;
import cn.com.cgbchina.rest.common.model.EBankModel;
import cn.com.cgbchina.rest.common.process.EBankVo2XMLProcessImpl;
import cn.com.cgbchina.rest.common.process.EBankXml2VoProcessImpl;
import cn.com.cgbchina.rest.common.process.InputSoapBodyProcessImpl;
import cn.com.cgbchina.rest.common.process.InputSoapHanderProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputSoapProcessImpl;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.ReflectUtil;
import cn.com.cgbchina.rest.common.utils.SOAPUtils;
import cn.com.cgbchina.rest.common.utils.ValidateUtil;
import cn.com.cgbchina.rest.common.utils.WebUtil;
import cn.com.cgbchina.rest.visit.model.user.ChannelPwdInfo;
import cn.com.cgbchina.rest.visit.model.user.CheckChannelPwdResult;
import cn.com.cgbchina.rest.visit.model.user.EEA1Info;
import cn.com.cgbchina.rest.visit.model.user.EEA1InfoResult;
import cn.com.cgbchina.rest.visit.model.user.EEA2Info;
import cn.com.cgbchina.rest.visit.model.user.EEA2InfoResult;
import cn.com.cgbchina.rest.visit.model.user.EEA5Info;
import cn.com.cgbchina.rest.visit.model.user.EEA5InfoResult;
import cn.com.cgbchina.rest.visit.model.user.EEA6Info;
import cn.com.cgbchina.rest.visit.model.user.EEA6InfoResult;
import cn.com.cgbchina.rest.visit.model.user.LoginInfo;
import cn.com.cgbchina.rest.visit.model.user.LoginResult;
import cn.com.cgbchina.rest.visit.model.user.MobileValidCode;
import cn.com.cgbchina.rest.visit.model.user.MobileValidCodeResult;
import cn.com.cgbchina.rest.visit.model.user.QueryUserInfo;
import cn.com.cgbchina.rest.visit.model.user.RandomCode;
import cn.com.cgbchina.rest.visit.model.user.RegisterInfo;
import cn.com.cgbchina.rest.visit.model.user.RegisterResult;
import cn.com.cgbchina.rest.visit.model.user.UserInfo;
import cn.com.cgbchina.rest.visit.vo.EEARequest;
import cn.com.cgbchina.rest.visit.vo.coupon.QueryCouponInfoVO;
import cn.com.cgbchina.rest.visit.vo.user.ChannelPwdInfoVO;
import cn.com.cgbchina.rest.visit.vo.user.CheckChannelPwdResultVO;
import cn.com.cgbchina.rest.visit.vo.user.EEA1InfoVO;
import cn.com.cgbchina.rest.visit.vo.user.EEA2InfoVO;
import cn.com.cgbchina.rest.visit.vo.user.EEA5InfoVO;
import cn.com.cgbchina.rest.visit.vo.user.EEA6InfoVO;
import cn.com.cgbchina.rest.visit.vo.user.LoginInfoVO;
import cn.com.cgbchina.rest.visit.vo.user.LoginResultVO;
import cn.com.cgbchina.rest.visit.vo.user.MobileValidCodeResultVO;
import cn.com.cgbchina.rest.visit.vo.user.MobileValidCodeVO;
import cn.com.cgbchina.rest.visit.vo.user.RandomCodeVO;
import cn.com.cgbchina.rest.visit.vo.user.RegisterInfoVO;
import cn.com.cgbchina.rest.visit.vo.user.RegisterResultVO;
import cn.com.cgbchina.rest.visit.vo.user.UserInfoVO;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class UserServiceImpl implements UserService {
	@Resource
	private InputSoapHanderProcessImpl inputSoapHanderProcessImpl;
	@Resource
	private InputSoapBodyProcessImpl inputSoapBodyProcessImpl;
	@Resource
	private OutputSoapProcessImpl outputSoapProcessImpl;
	@Resource
	private EBankVo2XMLProcessImpl bankVo2XMLProcessImpl;
	@Resource
	private EBankXml2VoProcessImpl bankXml2VoProcessImpl;

	@Override
	public LoginResult login(LoginInfo notify) {
		LoginInfoVO sendVo = BeanUtils.copy(notify, LoginInfoVO.class);
		EBankModel<LoginInfoVO> model = SOAPUtils.createEBankModel(sendVo);
		model.setSenderSN("WN");
		model.setSrcChannel("WN");
		Map<String, String> outMap = bankVo2XMLProcessImpl.packing(model, Map.class);
		String returnXml = ConnectOtherSys.connectEBank(outMap, "EBOT01");
		LoginResultVO resultOther = (LoginResultVO) bankXml2VoProcessImpl.packing(returnXml, LoginResultVO.class);
		String retCode = resultOther.getRetCode();
		// 未知含义代码
		if (retCode.equals("000000") || retCode.equals("00000001")) {
			ValidateUtil.validateModel(resultOther);
		}
		LoginResult result = BeanUtils.copy(resultOther, LoginResult.class);
		if (resultOther.getHostReturnCode() != null) {
			result.setRetCode(resultOther.getHostReturnCode());
		}
		if (resultOther.getHostErrorMessage() != null) {
			result.setRetErrMsg(resultOther.getHostErrorMessage());
		}
		return result;
	}

	@Override
	public RegisterResult register(RegisterInfo notify) {
		byte creditCard = 0;
		if (notify.getIsCreditCard() == creditCard) {// true:是信用卡
			if (notify.getCheckType() != null || notify.getPasswordType() != null || notify.getCheckPwdType() != null
					|| notify.getCheckCertType() != null) {
				throw new RuntimeException("[信用卡时 checkType,passwordType,checkPwdType,checkcertType 必须为空]");
			}
			if (notify.getCvv2Code() == null || notify.getCardValidPeriod() == null) {
				throw new RuntimeException("[信用卡时 cvv2code,cardvalidperiod 必填]");
			}
		} else {
			if (notify.getCvv2Code() != null || notify.getCvv2CodeFlag() != null || notify.getCardValidPeriod() != null
					|| notify.getPinBlockFlag() != null || notify.getValidDateFlag() != null) {
				throw new RuntimeException(
						"[非信用卡时 cvv2code,cvv2codeflag,cardvalidperiod,piblockflag,validdateflag 必须为空]");
			}
		}
		RegisterInfoVO sendVo = BeanUtils.copy(notify, RegisterInfoVO.class);
		EBankModel<RegisterInfoVO> model = SOAPUtils.createEBankModel(sendVo);

		RegisterInfoVO content = model.getContent();
		content.setPinBlockFlag("N");
		content.setCheckType((byte) 1);
		content.setPasswordType((byte) 3);
		content.setCheckPwdType((byte) 0);
		content.setCardExpiryDateFlag("N");
		content.setTransferFlowNo("WN" + transTime + BeanUtils.randomNum(8));
		Map<String, String> outMap = bankVo2XMLProcessImpl.packing(model, Map.class);
		String returnXml = ConnectOtherSys.connectEBank(outMap, "EBOT02");
		RegisterResultVO resultOther = (RegisterResultVO) bankXml2VoProcessImpl.packing(returnXml,
				RegisterResultVO.class);
		ValidateUtil.validateModel(resultOther);
		RegisterResult result = BeanUtils.copy(resultOther, RegisterResult.class);
		if (resultOther.getHostReturnCode() != null) {
			result.setRetCode(resultOther.getHostReturnCode());
		}
		if (resultOther.getHostErrorMessage() != null) {
			result.setRetErrMsg(resultOther.getHostErrorMessage());
		}
		return result;
	}

	@Override
	public MobileValidCodeResult getMobileValidCode(MobileValidCode code) {
		MobileValidCodeVO sendVo = BeanUtils.copy(code, MobileValidCodeVO.class);
		EBankModel<MobileValidCodeVO> model = SOAPUtils.createEBankModel(sendVo);
		Map<String, String> outMap = bankVo2XMLProcessImpl.packing(model, Map.class);
		String returnXml = ConnectOtherSys.connectEBank(outMap, "EBAC02");
		MobileValidCodeResultVO resultOther = (MobileValidCodeResultVO) bankXml2VoProcessImpl.packing(returnXml,
				MobileValidCodeResultVO.class);
		String retCode = resultOther.getRetCode();
		if (retCode.equals("000000")) {
			ValidateUtil.validateModel(resultOther);
		}

		MobileValidCodeResult result = BeanUtils.copy(resultOther, MobileValidCodeResult.class);
		if (resultOther.getHostReturnCode() != null) {
			result.setRetCode(resultOther.getHostReturnCode());
		}
		if (resultOther.getHostErrorMessage() != null) {
			result.setRetErrMsg(resultOther.getHostErrorMessage());
		}
		return result;
	}

	@Override
	public UserInfo getCousrtomInfo(QueryUserInfo userInfo) {
		QueryCouponInfoVO sendVo = BeanUtils.copy(userInfo, QueryCouponInfoVO.class);
		EBankModel<QueryCouponInfoVO> model = SOAPUtils.createEBankModel(sendVo);
		Map<String, String> outMap = bankVo2XMLProcessImpl.packing(model, Map.class);
		String returnXml = ConnectOtherSys.connectEBank(outMap, "EBOT04");
		UserInfoVO resultOther = (UserInfoVO) bankXml2VoProcessImpl.packing(returnXml, UserInfoVO.class);
		String retCode = resultOther.getRetCode();
		if (retCode.equals("000000")) {
			ValidateUtil.validateModel(resultOther);
		}
		UserInfo result = BeanUtils.copy(resultOther, UserInfo.class);
		if (resultOther.getHostReturnCode() != null) {
			result.setRetCode(resultOther.getHostReturnCode());
		}
		if (resultOther.getHostErrorMessage() != null) {
			result.setRetErrMsg(resultOther.getHostErrorMessage());
		}
		return result;
	}

	@Override
	public CheckChannelPwdResult checkChannelPwd(ChannelPwdInfo info) {
		ChannelPwdInfoVO sendVo = BeanUtils.copy(info, ChannelPwdInfoVO.class);
		EBankModel<ChannelPwdInfoVO> model = SOAPUtils.createEBankModel(sendVo);
		Map<String, String> outMap = bankVo2XMLProcessImpl.packing(model, Map.class);
		String returnXml = ConnectOtherSys.connectEBank(outMap, "EBOT12");
		CheckChannelPwdResultVO resultOther = (CheckChannelPwdResultVO) bankXml2VoProcessImpl.packing(returnXml,
				CheckChannelPwdResultVO.class);
		ValidateUtil.validateModel(resultOther);
		CheckChannelPwdResult result = BeanUtils.copy(resultOther, CheckChannelPwdResult.class);
		if (resultOther.getHostReturnCode() != null) {
			result.setRetCode(resultOther.getHostReturnCode());
		}
		if (resultOther.getHostErrorMessage() != null) {
			result.setRetErrMsg(resultOther.getHostErrorMessage());
		}
		return result;
	}

	private String Appid = "NS";
	private String sysID = "NIBS";
	private String transFlag = "1";
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
	private String transTime = sdf.format(new Date());

	@Override
	public EEA1InfoResult getEncipherTextByEEA1(EEA1Info info) {

		EEA1InfoVO infoVO = BeanUtils.copy(info, EEA1InfoVO.class);
		EEARequest<EEA1InfoVO> req = new EEARequest<EEA1InfoVO>();
		req.setAppID(Appid);
		req.setServiceCode("EEA1");
		req.setSysID(sysID);
		req.setTransFlag(transFlag);
		req.setTransTime(transTime);

		infoVO.setRsaName("NS.RSA2048INDEX0.RSA");
		infoVO.setZakName("NS.EPin000000000.ZAK");
		info.setRandom(BeanUtils.randomString(5));

		req.setClientIPAddr(WebUtil.getlocalIP());
		req.setContent(infoVO);
		String xml = infoToXML(req).replace("\n", "");

		String respXML = ConnectOtherSys.connectPwd(xml);
		EEA1InfoResult eea1InfoResult = new EEA1InfoResult();
		// eea1InfoResult.setPinBlock(respXML);
		eea1InfoResult = (EEA1InfoResult) XMLToResult(respXML, EEA1InfoResult.class);
		ValidateUtil.validateModel(eea1InfoResult);
		// eea1InfoResult.setPinBlock(pinBlock)
		return eea1InfoResult;
	}

	@Override
	public EEA2InfoResult getEncipherTextByEEA2(EEA2Info info) {
		EEA2InfoVO infoVO = BeanUtils.copy(info, EEA2InfoVO.class);
		EEARequest<EEA2InfoVO> req = new EEARequest<EEA2InfoVO>();
		req.setContent(infoVO);
		String xml = infoToXML(req).replace("\n", "");
		String respXML = ConnectOtherSys.connectPwd(xml);
		EEA2InfoResult eea2InfoResult = null;
		ValidateUtil.validateModel(eea2InfoResult);
		eea2InfoResult = (EEA2InfoResult) XMLToResult(respXML, EEA2InfoResult.class);
		return eea2InfoResult;
	}

	@Override
	public EEA5InfoResult getEncipherTextByEEA5(EEA5Info info) {
		EEA5InfoVO infoVO = BeanUtils.copy(info, EEA5InfoVO.class);
		EEARequest<EEA5InfoVO> req = new EEARequest<EEA5InfoVO>();
		req.setAppID(Appid);
		req.setServiceCode("EEA5");
		req.setSysID(sysID);
		req.setTransFlag(transFlag);
		req.setTransTime(transTime);

		infoVO.setKeyName("NS.INDEX00000000.SM2");
		infoVO.setZakName("NS.EPin000000000.ZAK");
		info.setRandom(BeanUtils.randomString(5));

		req.setClientIPAddr(WebUtil.getlocalIP());
		req.setContent(infoVO);

		String xml = infoToXML(req).replace("\n", "");
		String respXML = ConnectOtherSys.connectPwd(xml);
		EEA5InfoResult eea5InfoResult = new EEA5InfoResult();
		eea5InfoResult.setMac(respXML);
		ValidateUtil.validateModel(eea5InfoResult);
		eea5InfoResult = (EEA5InfoResult) XMLToResult(respXML, EEA5InfoResult.class);
		return eea5InfoResult;
	}

	@Override
	public EEA6InfoResult getEncipherTextByEEA6(EEA6Info info) {
		EEA6InfoVO infoVO = BeanUtils.copy(info, EEA6InfoVO.class);
		EEARequest<EEA6InfoVO> req = new EEARequest<EEA6InfoVO>();
		req.setContent(infoVO);
		String xml = infoToXML(req).replace("\n", "");
		String respXML = ConnectOtherSys.connectPwd(xml);
		EEA6InfoResult eea6InfoResult = null;
		ValidateUtil.validateModel(eea6InfoResult);
		eea6InfoResult = (EEA6InfoResult) XMLToResult(respXML, EEA6InfoResult.class);
		return eea6InfoResult;
	}

	private Object XMLToResult(String respXML, Class clazz) {
		Object res = null;
		Map<String, String> bodyMap = new HashMap<String, String>();
		try {
			Document document = DocumentHelper.parseText(respXML);
			Element rootEle = document.getRootElement();

			List responseCode = rootEle.selectNodes("/union/head/responseCode");
			String responseCodeText = null;
			if (responseCode != null && responseCode.size() > 0) {
				responseCodeText = ((Element) (responseCode.get(0))).getText();
			}
			List responseRemark = rootEle.selectNodes("/union/head/responseRemark");
			String responseRemarkText = null;
			if (responseRemark != null && responseRemark.size() > 0) {
				responseRemarkText = ((Element) (responseRemark.get(0))).getText();
			}
			try {
				Iterator bodyits = rootEle.elementIterator("body");
				Iterator its = ((Element) bodyits.next()).elementIterator();
				while (its.hasNext()) {
					Element ele = (Element) its.next();
					System.out.println(ele.getName() + " " + ele.getText());
					bodyMap.put(ele.getName(), ele.getText());
				}
			} catch (Exception e) {
				log.info("【获取个人网银业务数据不正确，body为空】" + respXML);
			}
			try {
				res = clazz.newInstance();
			} catch (InstantiationException | IllegalAccessException e) {
				throw new RuntimeException(e);
			}
			if (clazz.getSimpleName().equals("EEA1InfoResult")) {
				EEA1InfoResult resInfo = (EEA1InfoResult) res;
				resInfo.setPinBlock(bodyMap.get("pinBlock"));
				resInfo.setRetCode(responseCodeText);
				resInfo.setRetErrMsg(responseRemarkText);
				return resInfo;
			}
			if (clazz.getSimpleName().equals("EEA2InfoResult")) {
				EEA2InfoResult resInfo = (EEA2InfoResult) res;
				resInfo.setPinBlock(bodyMap.get("pinBlock"));
				return resInfo;
			}
			if (clazz.getSimpleName().equals("EEA5InfoResult")) {
				EEA5InfoResult resInfo = (EEA5InfoResult) res;
				resInfo.setMac(bodyMap.get("mac"));
				return resInfo;
			}
			if (clazz.getSimpleName().equals("EEA6InfoResult")) {
				EEA6InfoResult resInfo = (EEA6InfoResult) res;
				resInfo.setPinBlock(bodyMap.get("pinBlock"));
				return resInfo;
			}

		} catch (DocumentException e1) {
			throw new RuntimeException("返回的XML格式不正确" + respXML);
		}

		return null;
	}

	public String infoToXML(EEARequest req) {
		Document document = DocumentHelper.createDocument();
		document.setXMLEncoding("GBK");

		Element headerEle = document.addElement("union").addElement("head");

		Object content = req.getContent();
		Map<String, String> header = ReflectUtil.getObjMap(req);
		for (String key : header.keySet()) {
			headerEle.addElement(key).addText(header.get(key));
		}
		Element bodyEle = document.getRootElement().addElement("body");
		Map<String, String> body = ReflectUtil.getObjMap(content);
		for (String key : body.keySet()) {
			bodyEle.addElement(key).addText(body.get(key));
		}
		return document.asXML();
	}

	public static void main(String[] args) throws IOException, DocumentException {
		UserServiceImpl usi = new UserServiceImpl();
		EEA1Info info = new EEA1Info();
		info.setPinBlock(
				"6AD70D58CE1C09CD98AF51D0612CC30B12CE561973B9EBE278CB248E12DE14267F773225E511CE1CBDCFFD4C83C40A63CB4003D3EA14935699F19676F05FB54B8049A7A94BA060BD976C67FCAAFE4D6750C20871D216EE9147CAAC27939469E97A4B2B4764FDA5A3AD800E2CD7772C0DA0D941DF01AA484B2DF5191AC02A82CC318DA7351207C38C656201B957052240EE46D173D88EC5B716969C4536017CF873FE0EC3684F6C7E124595602C61E99E70D9843047426508D5A05E980B6D984605274F6F0084A37D62F79CC12EEAD8479E3850AFEDD2F57DA99217A0A4A1196E98D7852EC957C7F60CF022FD5C9CF7E4227F3E23A35E397A38989E6092267183");
		usi.getEncipherTextByEEA1(info);
		// String xml = FileUtils.readFileToString(new
		// File("D:/zx/电商/02 接口设计/EEA1result.xml"));
		// Document document = DocumentHelper.parseText(xml);
	}

	@Override
	public RandomCode getRandomCodeReq() {
		Map<String, String> map = new HashMap<String, String>();
		map.put("srcChannel", "WN");
		map.put("rf", "XML");
		String returnXml = ConnectOtherSys.connectEBank(map, "EBOT13");
		RandomCodeVO resultOther = (RandomCodeVO) bankXml2VoProcessImpl.packing(returnXml, RandomCodeVO.class);
		ValidateUtil.validateModel(resultOther);
		RandomCode result = BeanUtils.copy(resultOther, RandomCode.class);
		return result;
	}

}
