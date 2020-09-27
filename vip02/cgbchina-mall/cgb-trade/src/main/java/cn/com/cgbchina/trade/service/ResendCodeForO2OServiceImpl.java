package cn.com.cgbchina.trade.service;


import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.related.model.InfoOutSystemModel;
import cn.com.cgbchina.related.service.InfoOutSystemService;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.order.ResendOrderInfo;
import cn.com.cgbchina.rest.visit.service.order.OrderService;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.vo.GateWayEnvolopeVo;
import cn.com.cgbchina.trade.vo.NoAs400EnvolopeVo;
import cn.com.cgbchina.trade.vo.OutSysEnvelopeVo;
import cn.com.cgbchina.trade.vo.SystemEnvelopeVo;
import cn.com.cgbchina.user.model.ShopinfOutsystemModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import lombok.extern.slf4j.Slf4j;
import org.dom4j.Document;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * Created by sf on 16-8-1.
 */
@Service
@Slf4j
public class ResendCodeForO2OServiceImpl implements ResendCodeForO2OService {

	@Resource
	ItemService itemService;
	@Resource
	GoodsService goodsService;
	@Resource
	GoodsPayWayService goodsPayWayService;
	@Resource
	OrderService ordersService;
	@Resource
	VendorService vendorService;
	// @Resource
	// OrderService ordersService;
	@Resource
	OrderService testOrdersService;
	@Resource
	InfoOutSystemService infoOutSystemService;
	@Resource
	OrderSubDao orderSubDao;
	// @Resource
	// OrderMainDao orderMainDao;
	// @Resource
	// OrderOutSystemDao orderOutSystemDao;

	@Override
	public NoAs400EnvolopeVo service(GateWayEnvolopeVo gateWayEnvolopeVo) {
//		String senderSN = StringUtil.dealNull(gateWayEnvolopeVo.getSenderSN());
		String origin = StringUtil.dealNull(gateWayEnvolopeVo.getMessageEntityValue("origin"));//发起方
		String mallType = StringUtil.dealNull(gateWayEnvolopeVo.getMessageEntityValue("mallType"));//商城类型

		String orderno = StringUtil.dealNull(gateWayEnvolopeVo.getMessageEntityValue("orderno"));// 大订单号
		String suborderno = StringUtil.dealNull(gateWayEnvolopeVo.getMessageEntityValue("suborderno"));// 小订单号
		String mobile = StringUtil.dealNull(gateWayEnvolopeVo.getMessageEntityValue("mobile"));// 电话号码

		GateWayEnvolopeVo envolopeVo = new GateWayEnvolopeVo();
//		List list = null;
		SystemEnvelopeVo systemEnvelopeVo =  new SystemEnvelopeVo();
		try {
			Map paramsMap = new HashMap();
			paramsMap.put("orderno", orderno);
			paramsMap.put("suborderno", suborderno);
			paramsMap.put("mobile", mobile);
			paramsMap.put("origin", origin);
			paramsMap.put("mallType", mallType);
			systemEnvelopeVo = handleReceive(paramsMap);
			envolopeVo.setMessageEntityValue("result_code", systemEnvelopeVo.getResult_code());
			envolopeVo.setMessageEntityValue("result_msg", systemEnvelopeVo.getResult_msg());
		} catch (Exception e) {
			// logger.error("程序处理异常，异常原因" + e.getMessage());
			envolopeVo.setMessageEntityValue("result_code", "4");
			envolopeVo.setMessageEntityValue("result_msg", e.getMessage());
			return envolopeVo;
		}
		return envolopeVo;
	}

	public SystemEnvelopeVo handleReceive(Map map) throws Exception {

		SystemEnvelopeVo systemEnvelopeVo = new SystemEnvelopeVo();
		try {
			if ("".equals((String) map.get("orderno"))) {
				systemEnvelopeVo.setResult_code("4");
				systemEnvelopeVo.setResult_msg("受理失败，该订单没有可发送的验证码!错误码：01");
				return systemEnvelopeVo;
			}
			if ("".equals((String) map.get("suborderno"))) {
				systemEnvelopeVo.setResult_code("4");
				systemEnvelopeVo.setResult_msg("受理失败，该订单没有可发送的验证码!错误码：02");
				return systemEnvelopeVo;
			}
			if ("".equals((String) map.get("mallType"))) {
				systemEnvelopeVo.setResult_code("4");
				systemEnvelopeVo.setResult_msg("受理失败，该订单没有可发送的验证码!错误码：03");
				return systemEnvelopeVo;
			}
			if ("".equals((String) map.get("origin"))) {
				systemEnvelopeVo.setResult_code("4");
				systemEnvelopeVo.setResult_msg("受理失败，该订单没有可发送的验证码!错误码：04");
				return systemEnvelopeVo;
			}

			if ("02".equals((String) map.get("mallType"))) {// 积分商城
				// 设置重发交易方法
				systemEnvelopeVo.setMethod("13");
				systemEnvelopeVo.setOrderno((String) map.get("orderno"));
				systemEnvelopeVo.setMobile((String) map.get("mobile"));
				List orderInfList = new ArrayList();
				Map orderInfMap = new HashMap();
				orderInfMap.put("suborderno", (String) map.get("suborderno"));
				orderInfMap.put("mobile", (String) map.get("mobile"));
				orderInfList.add(orderInfMap);
				// 设置小订单信息
				systemEnvelopeVo.setMessageCirculateList(orderInfList);

				// SendOutSysEnvelopeService sysService =
				// (SendOutSysEnvelopeService)SpringUtil.getBean("outSystemCCOrderService");
				// 调用接口
				systemEnvelopeVo = (SystemEnvelopeVo) sendEnvolope(systemEnvelopeVo);
				// logger.info("订单重发/转发处理成功，返回码：" + systemEnvelopeVo.getResult_code() + "返回信息：" +
				// systemEnvelopeVo.getResult_msg());
			} else {
				systemEnvelopeVo.setResult_code("4");
				systemEnvelopeVo.setResult_msg("受理失败，该订单没有可发送的验证码!错误码：05");
				return systemEnvelopeVo;
			}
		} catch (Exception e) {
			// logger.error("CC重发处理请求失败！失败原因：" + e.getMessage());
			e.printStackTrace();
			systemEnvelopeVo.setResult_code("4");
			systemEnvelopeVo.setResult_msg(e.getMessage());
			return systemEnvelopeVo;
		}
		return systemEnvelopeVo;
	}

	public OutSysEnvelopeVo sendEnvolope(SystemEnvelopeVo systemEnvolopeVo) throws Exception {
		SystemEnvelopeVo returnEnvelopeVo = new SystemEnvelopeVo();
		try {
			returnEnvelopeVo = receiveSendhandleVo(systemEnvolopeVo);
		} catch (Exception e) {
			log.error("sendEnvolope:Exception" + e.getMessage(), e);
		}
		log.info("订单重发、转发处理成功");
		return returnEnvelopeVo;
	}

	/**
	 *
	 * <p>
	 * Description:逻辑处理
	 * </p>
	 * 
	 * @param systemEnvolopeVo
	 * @return
	 * @author:panhui
	 * @throws Exception
	 * @update:2013-9-1
	 */
	private SystemEnvelopeVo receiveSendhandleVo(SystemEnvelopeVo systemEnvolopeVo) throws Exception {
		String orderMainId = systemEnvolopeVo.getOrderno();
		List orderList = systemEnvolopeVo.getMessageCirculateList();
		String returnStr = new String();
		Document sendReturnDoc = null;
//		Map orderMap = new HashMap();
		SystemEnvelopeVo returnEnvolopeVo = new SystemEnvelopeVo();
		try {
			Map orderListMap = (Map) orderList.get(0);
			String suborderno = (String) orderListMap.get("suborderno");
			if (orderList == null || orderList.size() <= 0) {
				returnEnvolopeVo.setResult_code("4");
				returnEnvolopeVo.setResult_msg("受理失败，该订单没有可发送的验证码!错误码：08");
				return returnEnvolopeVo;
			}
			// 验证是否为积分商城订单
			if (!validateOrder(suborderno)) {
				returnEnvolopeVo.setResult_code("4");
				returnEnvolopeVo.setResult_msg("受理失败，该订单没有可发送的验证码!错误码：09");
				return returnEnvolopeVo;
			}
			// 验证大订单号和小订单号是否匹配
			if (!validateMainorderAndOrder(suborderno, orderMainId)) {
				returnEnvolopeVo.setResult_code("4");
				returnEnvolopeVo.setResult_msg("受理失败，该订单没有可发送的验证码!错误码：10");
				return returnEnvolopeVo;
			}

			// 验证验证码是否已经使用
			if (validateCodeIsUse(suborderno)) {
				returnEnvolopeVo.setResult_code("4");
				returnEnvolopeVo.setResult_msg("受理失败，该订单没有可发送的验证码!错误码：11");
				return returnEnvolopeVo;
			}
			ResendOrderInfo resendOrderInfo = changeOrderListToMap(systemEnvolopeVo);

			try {
				boolean saveSoapFlag = true;// 是否已经保存了失败返回报文标志

				log.info("开始调用重发、转发临时接口");
				// BaseResult baseResult = ordersService.resendOrder(resendOrderInfo);
				// 测试用
				BaseResult baseResult = testOrdersService.resendOrder(resendOrderInfo);
				// returnStr = sendMap(url, map , str[2],orderMainId);
				// 返回结果
				returnStr = baseResult.getRetErrMsg();
				log.info("接收返回报文信息：" + returnStr);
				returnEnvolopeVo.setResult_code(baseResult.getRetCode());
				returnEnvolopeVo.setResult_msg(returnStr);

				/*
				 * //解析报文 try{ returnMap = outSystemService.changeReturnToMap(returnStr); }catch(Exception e){
				 * log.error("解析报文失败！失败原因：" + e.getMessage()); log.error(e.getMessage()+" 保存返回报文！"); if(saveSoapFlag){
				 * outSystemDao.saveSoapForResolError(str[0],"MALL",orderMainId,"01","01","analyerror",returnStr);
				 * saveSoapFlag = false; } } String receiveSign = (String)returnMap.get("sign"); log.info("接收返回报文的签名：" +
				 * receiveSign); returnMap.remove("sign");
				 * 
				 * String signStr = Signature.md5Signature(returnMap, str[2]); log.info("签名返回报文信息sign：" + signStr);
				 * if(receiveSign == null || !receiveSign.equals(signStr)){ if(saveSoapFlag){
				 * outSystemDao.saveSoapForResolError(str[0],"MALL",orderMainId,"01","01","signerror",returnStr);
				 * saveSoapFlag = false; } throw new Exception("错误码:0007"); } //解密 String decodeAseXML = ""; try {
				 * log.info("密文消息体：" + (String)returnMap.get("message")); //本系统需要 decodeAseXML=
				 * EncryptionUtil.des3DecodeCBC(str[2], (String) returnMap.get("message")); log.info("*解密后的message数据:" +
				 * decodeAseXML); } catch (Exception e) { //成功接收返回报文记录，报文体为密文 if(saveSoapFlag){
				 * outSystemDao.saveSoapForResolError(str[0],"MALL",orderMainId,"01","01","secerror",returnStr);
				 * saveSoapFlag = false; } e.printStackTrace(); log.error("解密失败" + e.getMessage()); log.error("解密失败报文："
				 * + returnStr); throw new Exception("错误码:0008"); } returnMap.put("message",
				 * decodeAseXML);//将明文message，放到Map中
				 * 
				 * sendReturnDoc = DocumentHelper.parseText(decodeAseXML); //报文组装到返回vo returnEnvolopeVo =
				 * outSystemService.changeToReturnVo(sendReturnDoc); //成功接收返回报文记录，报文体明文 String sendStr =
				 * sendSoap(returnMap,null); MessageLogModel messageLogModel = new MessageLogModel();
				 * messageLogModel.setSendersn(returnMap.get("timestamp"));
				 * messageLogModel.setTradecode(returnMap.get("method"));
				 * messageLogModel.setSenderid((String)returnMap.get("shopid")); messageLogModel.setReceiverid("MALL");
				 * messageLogModel.setOrderid(orderMainId); messageLogModel.setOpertime(new Date());
				 * messageLogModel.setSendflag("01"); messageLogModel.setErrflag("01");
				 * messageLogModel.setErrcode(returnEnvolopeVo.getResult_code());
				 * messageLogModel.setMessagecontent(sendStr); messageLogService.insertMessageLog(messageLogModel);
				 * //outSystemDao.saveSoap((String)returnMap.get("shopid"),"MALL",orderMainId,"01","01",returnEnvolopeVo
				 * .getResult_code(),returnMap,null); log.info("对返回结果信息处理成功！");
				 */
			} catch (Exception e) {
				log.error("程序处理异常，异常原因：" + e.getMessage());
				returnEnvolopeVo.setResult_code("5");
				returnEnvolopeVo.setResult_msg("系统通讯异常！" + e.getMessage());
				return returnEnvolopeVo;
			}

		} catch (Exception e) {
			log.error("receiveSendhandleVo处理异常！异常原因：" + e.getMessage());
			log.error("Excetion", e);
			e.printStackTrace();
			returnEnvolopeVo.setResult_code("5");
			returnEnvolopeVo.setResult_msg("系统通讯异常！错误码：0011" + e.getMessage());
			return returnEnvolopeVo;
		}
		String msg = returnEnvolopeVo.getResult_msg();
		if (returnEnvolopeVo.getResult_code() != null && !"0".equals(returnEnvolopeVo.getResult_code())) {
			returnEnvolopeVo.setResult_code("5");
			returnEnvolopeVo.setResult_msg("系统通讯异常！错误码：0010" + msg);
		}
		return returnEnvolopeVo;
	}

	/**
	 *
	 * <p>
	 * Description:验证订单是否为积分商城订单
	 * </p>
	 * 
	 * @param suborderno
	 */
	private boolean validateOrder(String suborderno) throws Exception {
		OrderSubModel orderSubModel = null;
		try {
			orderSubModel = orderSubDao.findJfOrderById(suborderno);
			orderSubModel = new OrderSubModel();
		} catch (Exception e) {
			log.debug("验证订单是否为积分商城订单异常！");
		}
		if (orderSubModel != null) {
			return true;
		}
		return false;
	}

	/**
	 *
	 * <p>
	 * Description:设置报文头信息,调用方法应该在传入对像时设置
	 * </p>
	 * 
	 * @param systemEnvolopeVo
	 * @param shopId
	 */
	private void setServicContent(String shopId, SystemEnvelopeVo systemEnvolopeVo) {
		systemEnvolopeVo.setMsgtype("requestmessage");
		systemEnvolopeVo.setFormat("xml");
		systemEnvolopeVo.setVersion("1.0");
		systemEnvolopeVo.setShopid(shopId);
		systemEnvolopeVo.setMethod("13");//11推送方法标志
		systemEnvolopeVo.setTimestamp(DateHelper.getCurrentTime());
	}
	private ResendOrderInfo changeOrderListToMap(SystemEnvelopeVo systemEnvolopeVo) throws Exception {
		ResendOrderInfo resendOrderInfo = new ResendOrderInfo();
//		Map<String , Document> returnMap = new HashMap<String , Document>();
		List list = new ArrayList();
		String suborderno = "";
		String key = "";
		String mobile = "";

		try {
			list = systemEnvolopeVo.getMessageCirculateList();
			Map orderMap = (Map) list.get(0);
			suborderno = (String) orderMap.get("suborderno");
			mobile = (String) orderMap.get("mobile");
			VendorInfoModel vendorInfoModel = new VendorInfoModel();

			OrderSubModel orderSubModel = orderSubDao.findById(suborderno);
			if (null != orderSubModel) {
				Response<VendorInfoModel> response = vendorService.findVendorById(orderSubModel.getVendorId());
				// 根据供应商外系统编号关联查询外系统信息表
				if (response.isSuccess() && null != response.getResult()) {
					vendorInfoModel = response.getResult();
				}
				// Response<ShopinfOutsystemModel> resp =
				// vendorService.findShopInfoOutSysInfosById(vendorInfoModel.getOutSystemId());
				// shopinfOutsystemModel = resp.getResult();
			}

			/*
			 * if(shopinfOutsystemModel != null) {
			 * 
			 * log.info("密钥解密开始");
			 * 
			 * String shop_key = ""; try{ shop_key = ABEncrypt.DesCrypt(shopinfOutsystemModel.getShopKey(), "as");
			 * //shop_key =(String)resultMap.get("shop_key"); }catch(Exception e){ log.error("密钥解密失败，失败原因：" +
			 * e.getMessage(), e); throw new Exception("密钥解密失败"); }
			 * 
			 * log.info("解密后的shop_key:" + shop_key); key = shopinfOutsystemModel.getShopId() + "," +
			 * shopinfOutsystemModel.getActionUrl() + "," + shop_key; }else{ throw new Exception("商户信息不存在"); }
			 * log.info("changeOrderListToMap:key取值为：" + key); Element rootEle = doc.addElement("request_message");
			 * Element messageEle = rootEle.addElement("message");
			 * messageEle.addElement("orderno").addText(Tools.trim(systemEnvolopeVo.getOrderno()));
			 * messageEle.addElement("suborderno").addText(Tools.trim(suborderno));
			 * messageEle.addElement("mobile").addText(Tools.trim(mobile)); returnMap.put(key, doc);
			 */
			resendOrderInfo.setMobile(StringUtil.dealNull(mobile));
			resendOrderInfo.setOrderNo(StringUtil.dealNull(systemEnvolopeVo.getOrderno()));
			resendOrderInfo.setSubOrderNo(StringUtil.dealNull(suborderno));
			resendOrderInfo.setVendorName(vendorInfoModel.getVendorId());

		} catch (Exception e) {
			log.error("changeOrderListToMap:处理有误！错误原因：" + e.getMessage(), e);
		}
		return resendOrderInfo;
	}

	/**
	 *
	 * <p>
	 * Description:大订单号和小订单号是否匹配
	 * </p>
	 * 
	 * @param suborderno
	 * @return
	 */
	private boolean validateMainorderAndOrder(String suborderno, String orderMainId) throws Exception {
		List list = null;
		OrderSubModel orderSubModel = null;
		try {
			HashMap queryMap = Maps.newHashMap();
			queryMap.put("orderId", suborderno);
			queryMap.put("orderMainId", orderMainId);
			orderSubModel = orderSubDao.findByOrderMainIdAndOrderId(queryMap);
		} catch (Exception e) {
			log.info("大订单号和小订单号是否匹配检验时，操作数据库异常！");
		}
		if (orderSubModel != null) {
			return true;
		}
		return false;
	}

	/**
	 *
	 * <p>
	 * Description:验证验证码是否已经使用
	 * </p>
	 * 
	 * @param suborderno
	 * @return
	 */
	private boolean validateCodeIsUse(String suborderno) throws Exception {
		OrderSubModel orderSubModel = null;
		List<InfoOutSystemModel> infoOutSystemModelList = null;
		try{

			HashMap queryMap = Maps.newHashMap();
			queryMap.put("orderId", suborderno);
			queryMap.put("validateStatus", "01");//验证码验证成功标志01:已使用
			Response<List<InfoOutSystemModel>> response = infoOutSystemService.findInfoByValidateStatus(queryMap);
			//Response<List<InfoOutSystemModel>> response = new Response<List<InfoOutSystemModel>>();
			if(!response.isSuccess()){
				log.error("Response.error,error code: {}", response.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
			}
			infoOutSystemModelList = response.getResult();
		}catch(Exception e){
			log.info("验证验证码是否已经使用异常！");
		}
		if(null != infoOutSystemModelList && infoOutSystemModelList.size() > 0) {
			return true;
		}
		return false;
	}

}
