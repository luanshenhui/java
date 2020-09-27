package cn.com.cgbchina.trade.service;


import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.order.O2OOrderInfo;
import cn.com.cgbchina.rest.visit.model.order.SendOrderToO2OInfo;
import cn.com.cgbchina.rest.visit.service.order.OrderService;
import cn.com.cgbchina.trade.dao.OrderMainDao;
import cn.com.cgbchina.trade.dao.OrderOutSystemDao;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.manager.OrderCheckManager;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderOutSystemModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.vo.SystemEnvelopeVo;
import cn.com.cgbchina.user.model.ShopinfOutsystemModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.Node;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.*;


/**
 * Created by sf on 16-7-18.
 */
@Service
@Slf4j
public class OrderSendForO2OServiceImpl implements OrderSendForO2OService {

	@Resource
	OrderService testOrdersService;
	@Resource
	ItemService itemService;
	@Resource
	GoodsService goodsService;
	@Resource
	GoodsPayWayService goodsPayWayService;
	//@Resource
	//OrderService ordersService;
	@Resource
	VendorService vendorService;
	@Resource
	OrderSubDao orderSubDao;
    @Resource
	OrderMainDao orderMainDao;
	@Resource
	OrderOutSystemDao orderOutSystemDao;
	@Resource
	OrderCheckManager orderCheckManager;

	@Override
	public Response<BaseResult> sendO2OOrderProcess(SystemEnvelopeVo systemEnvolopeVo) {
		log.info("sendO2OOrderProcess start");
		String orderMainId = systemEnvolopeVo.getOrderno();
		List orderList = systemEnvolopeVo.getMessageCirculateList();

		TreeMap<String , String> returnMap = new TreeMap<String , String>();
		boolean handleFlag = false;

		Map orderMap = new HashMap();//map取值格式：key 值为：shop_id,url ,key ---value的值：document
		Response<BaseResult> result= Response.newResponse();
		result.setSuccess(true);
		log.info("sendO2OOrderProcess start2:" + orderList.size());
		try {
			if (orderList == null || orderList.size() <= 0) {
				//不存在小订单集合,各个渠道下单的时候调用,调用时只需要传输大订单号，推送失败时，订单将会插入到定时任务推送表
				if("".equals(orderMainId) || orderMainId == null){
					result.setError("订单号不能为空！");
					result.setSuccess(false);
					return result;
				}
				//调用临时接口
				result = orderSendForO2O(systemEnvolopeVo.getOrderno(), systemEnvolopeVo.getOrderId());
				if (!result.isSuccess()) {
					result.setSuccess(false);
				} else {
					log.info("O2O订单推送---推送成功");
				}
				//渠道下单标志
				handleFlag = true;

				//调用后的后续处理
				if(null != result.getResult()) {
					backProcess(orderMainId, systemEnvolopeVo.getOrderId(), result.getResult().getRetCode());
				}
			} else {
				//存在小订单集合的时候，此方法有批量推送，和手动推送调用
				result = orderBatchSendForO2O(systemEnvolopeVo);
				if (!result.isSuccess()) {
					result.setSuccess(false);
				} else {
					log.info("O2O订单推送---批量推送成功");
				}
				//调用后的后续处理
				if(null != result.getResult()) {
					for(int i = 0 ; i < systemEnvolopeVo.getMessageCirculateList().size() ; i ++) {
						orderMap = (Map)systemEnvolopeVo.getMessageCirculateList().get(i);
						backProcess(orderMainId, StringUtil.dealNullObject(orderMap.get("suborderno")), result.getResult().getRetCode());
					}
				}
				//批量还未完成测试用
				//BaseResult baseResult = new BaseResult();
				//baseResult.setRetCode("0");
				//log.debug("O2O订单推送---批量推送成功");
				//result.setResult(baseResult);
			}

		}catch(Exception e) {
			if(handleFlag){//非手动推送调用，非批量推送调用，需要插入批量推送表中
				backProcess(orderMainId, systemEnvolopeVo.getOrderId(), "5");
			}
			e.printStackTrace();
			log.error("O2O订单推送---异常原因:" + e.getMessage());
			result.setSuccess(false);
			result.setError("O2O订单推送---异常原因:" + e.getMessage());
		}
		return result;
	}

	@Override
	public Response orderBatchSendForO2O(SystemEnvelopeVo systemEnvolopeVo) {
		Response<BaseResult> result= Response.newResponse();
		result.setSuccess(true);
		try{
			SendOrderToO2OInfo sendOrderToO2OInfo = changeOrderListToMap(systemEnvolopeVo);
			log.info("开始调用O2O订单推送临时接口");
			BaseResult baseResult = testOrdersService.sendO2OOrderInfo(sendOrderToO2OInfo);
			if(!"0".equals(baseResult.getRetCode())) {
				log.info("调用临时接口失败");
			}
			result.setResult(baseResult);
			log.info("调用临时接口结束");

			return result;
		} catch (Exception e) {
			log.error(Throwables.getStackTraceAsString(e));
			result.setError("组装临时接口输入参数异常");
			result.setSuccess(false);
			return result;
		}
	}

	@Override
	public Response orderSendForO2O(String orderMainId, String orderId) {

		Response<BaseResult> result= Response.newResponse();
		result.setSuccess(false);
		try{
			SendOrderToO2OInfo sendOrderToO2OInfo = new SendOrderToO2OInfo();
			//小订单号不为空，则只推送指定的小订单
			if(!StringUtils.isEmpty(orderId)) {
				sendOrderToO2OInfo = changeEntityForOneOrder(orderMainId, orderId);
			}
			log.info("开始调用O2O订单推送临时接口");
			//BaseResult baseResult = ordersService.sendO2OOrderInfo(sendOrderToO2OInfo);
			//测试用
			BaseResult baseResult = testOrdersService.sendO2OOrderInfo(sendOrderToO2OInfo);

			if(!"0".equals(baseResult.getRetCode())) {
				log.info("调用临时接口失败");
				return result;
			}
			result.setResult(baseResult);
			log.info("调用临时接口结束");

			return result;
		} catch (Exception e) {
			result.setError("组装临时接口输入参数异常");
			result.setSuccess(false);
			return result;
		}
	}

	private SendOrderToO2OInfo changeEntityForOneOrder(String orderMainId, String orderId) throws Exception {
		SendOrderToO2OInfo sendOrderToO2OInfo = new SendOrderToO2OInfo();
		//SendOrderToO2OInfoVO sendVo = new SendOrderToO2OInfoVO();
		List sumList = new ArrayList();
		List priceList = new ArrayList();

		List<O2OOrderInfo> o2OOrderInfoList = new ArrayList<O2OOrderInfo>();
		O2OOrderInfo o2oOrderInfo;
		ItemModel itemModel = new ItemModel();
		OrderMainModel orderMainModel = new OrderMainModel();
		VendorInfoModel vendorInfoModel = new VendorInfoModel();
		ShopinfOutsystemModel shopinfOutsystemModel = new ShopinfOutsystemModel();

		BigDecimal calMoney = new BigDecimal(0);
		BigDecimal uitdrtamt = new BigDecimal(0);
		BigDecimal voucherPrice = new BigDecimal(0);

		OrderSubModel orderSubModel = orderSubDao.findInfoByConditions(orderId);
		if(null != orderSubModel) {
			orderMainModel = orderMainDao.findById(orderSubModel.getOrdermainId());
			Response<VendorInfoModel> response = vendorService.findVendorInfosByVendorId(orderSubModel.getVendorId());
			Response<ItemModel> res = itemService.findInfoById(orderSubModel.getGoodsId());
			if(res.isSuccess() && res.getResult() != null) {
				itemModel = res.getResult();
			}
			//根据供应商外系统编号关联查询外系统信息表
			if(response.isSuccess() && response.getResult() != null) {
				vendorInfoModel = response.getResult();
			}
		}
		//sumList = goodsPayWayService.findInfoByItemCode(orderId);
		//sendVo.setOrderno(orderMainId);
		//sendVo.setSum(sumList.size());

		if(null != orderSubModel && null != orderMainModel && null != vendorInfoModel && null != itemModel) {
			//for (Object obj : sumList) {
			o2oOrderInfo = new O2OOrderInfo();
			//Response<List<TblGoodsPaywayModel>> res = goodsPayWayService.findInfoByItemCode(itemModel.getCode());
			o2oOrderInfo.setSubOrderId(orderSubModel.getOrderId());
			o2oOrderInfo.setSOrderId(itemModel.getO2oCode());
			o2oOrderInfo.setGoodsId(itemModel.getO2oVoucherCode());
			o2oOrderInfo.setType(0);
			//if(res.isSuccess()) {
				//priceList = res.getResult();
				//goodsPaywayModel =(TblGoodsPaywayModel)priceList.get(0);
				//o2oOrderInfo.setPrice(goodsPaywayModel.getGoodsPrice());
				//o2oOrderInfo.setAmount(new BigDecimal(multiply(null != orderSubModel.getGoodsNum() ? orderSubModel.getGoodsNum()mapKdy = : "0", null != goodsPaywayModel.getGoodsPrice() ? goodsPaywayModel.getGoodsPrice().toString() : "0")));
			//}

			if(null != orderSubModel.getUitdrtamt()) {
				uitdrtamt = orderSubModel.getUitdrtamt();
			}
			if(null != orderSubModel.getVoucherPrice()) {
				voucherPrice = orderSubModel.getVoucherPrice();
			}

			calMoney = "JF".equals(orderSubModel.getOrdertypeId()) ? orderSubModel.getCalMoney() : null != orderSubModel.getTotalMoney() ? orderSubModel.getTotalMoney().add(uitdrtamt).add(voucherPrice) : new BigDecimal(0) ;
			o2oOrderInfo.setPrice(calMoney);

			o2oOrderInfo.setAmount(new BigDecimal(multiply(null != orderSubModel.getGoodsNum() ? orderSubModel.getGoodsNum().toString() : "0", null != calMoney ? calMoney.toString() : "0")));

			o2oOrderInfo.setNumber(orderSubModel.getGoodsNum());
			o2oOrderInfo.setMobile(orderMainModel.getCsgPhone1());
			o2OOrderInfoList.add(o2oOrderInfo);
			//}
			sendOrderToO2OInfo.setOrderno(orderMainId);
			sendOrderToO2OInfo.setPayment(calMoney);
			sendOrderToO2OInfo.setOrganId("");
			sendOrderToO2OInfo.setO2OOrderInfos(o2OOrderInfoList);
			sendOrderToO2OInfo.setVendorName(vendorInfoModel.getVendorId());

		} else {
			log.info("组装临时接口输入参数---订单等关联信息不存在");
			throw new Exception();
		}

		return sendOrderToO2OInfo;
	}

	private SendOrderToO2OInfo changeOrderListToMap(SystemEnvelopeVo systemEnvolopeVo) throws Exception {
		SendOrderToO2OInfo sendOrderToO2OInfo = new SendOrderToO2OInfo();

		Map orderMap = (Map<String, Object>)systemEnvolopeVo.getMessageCirculateList().get(0);
		OrderSubModel orderSubModel = orderSubDao.findById(StringUtil.dealNullObject(orderMap.get("suborderno")));
		log.info("changeOrderListToMap start2:" + orderSubModel.getOrderId());
        VendorInfoModel vendorInfoModel = new VendorInfoModel();
		ShopinfOutsystemModel shopinfOutsystemModel = new ShopinfOutsystemModel();
		if(null != orderSubModel) {
			Response<VendorInfoModel> response = vendorService.findVendorInfosByVendorId(orderSubModel.getVendorId());
			//根据供应商外系统编号关联查询外系统信息表
			if(null != response.getResult() && response.isSuccess()) {
				vendorInfoModel = response.getResult();
			}
		}

		if(null != orderSubModel && null != vendorInfoModel) {
			sendOrderToO2OInfo.setPayment(new BigDecimal(StringUtil.dealNull(systemEnvolopeVo.getPayment())));
			sendOrderToO2OInfo.setOrganId("");
			sendOrderToO2OInfo.setOrderno(systemEnvolopeVo.getOrderno());
			sendOrderToO2OInfo.setVendorName(vendorInfoModel.getVendorId());
			List sendO2OOrderInfoList = new ArrayList<O2OOrderInfo>();
			O2OOrderInfo sendO2OOrderInfo;

			for(int i = 0 ; i < systemEnvolopeVo.getMessageCirculateList().size() ; i ++) {//遍历小订单信息
				orderMap = (Map)systemEnvolopeVo.getMessageCirculateList().get(i);
				log.info(orderMap.toString());
				if(null != orderMap) {
					sendO2OOrderInfo = new O2OOrderInfo();
					sendO2OOrderInfo.setSubOrderId(StringUtil.dealNullObject(orderMap.get("suborderno")));
					sendO2OOrderInfo.setSOrderId(StringUtil.dealNullObject(orderMap.get("sorder_id")));
					sendO2OOrderInfo.setGoodsId(StringUtil.dealNullObject(orderMap.get("goods_id")));
					sendO2OOrderInfo.setType(null != orderMap.get("type") ? Integer.parseInt((String)orderMap.get("type")) : new Integer(0));
					sendO2OOrderInfo.setPrice(null != orderMap.get("price") ? (BigDecimal)orderMap.get("price") : new BigDecimal(0));
					sendO2OOrderInfo.setNumber(null != orderMap.get("number") ? Integer.parseInt((String)orderMap.get("number")) : new Integer(0));
					sendO2OOrderInfo.setAmount(new BigDecimal(multiply(null != orderMap.get("number") ? orderMap.get("number").toString() : "0", null != orderMap.get("price") ? orderMap.get("price").toString() : "0")));
					sendO2OOrderInfo.setMobile(StringUtil.dealNullObject(orderMap.get("mobile")));
					sendO2OOrderInfoList.add(sendO2OOrderInfo);
				}
			}
			sendOrderToO2OInfo.setO2OOrderInfos(sendO2OOrderInfoList);
		}
		return sendOrderToO2OInfo;
	}

	private String multiply(String numStr, String priceStr) throws Exception {
		BigDecimal num = new BigDecimal("0.00");
		BigDecimal price = new BigDecimal("0.00");
		String returStr = "0";
		if(!StringUtils.isEmpty(numStr) && !StringUtils.isEmpty(priceStr)){
			try{
				num = new BigDecimal(numStr);
				price = new BigDecimal(priceStr);
				returStr = num.multiply(price).toString();
				//log.info("总价钱为：" + num.multiply(price).toString());
			}catch(Exception e){
				return "0";
			}
		}

		return returStr;
	}

	private String returnResult(BaseResult baseResult) {
		String retResult = "";
		if(baseResult != null) {
			switch (baseResult.getRetCode()) {
				case "0":
					retResult = "成功";
					break;
				case "1":
					retResult = "客户不存在";
					break;
				case "2":
					retResult = "签名失败";
					break;
				case "3":
					retResult = "超时消息";
					break;
				case "4":
					retResult = "参数错误";
					break;
			}
		}
		return  retResult;
	}

	/**
	 *
	 * <p>Description:调用后的后续处理</p>
	 * @param orderMainId
	 * @param resultCode
	 * @param resultCode
	 */
	private void backProcess(String orderMainId, String orderId, String resultCode) {
		try{
			if(!"0".equals(resultCode)){//失败
				List list = orderOutSystemDao.findByOrderId(StringUtil.dealNull(orderId));//查询推送表中的订单是否存在，如果存在，则不再做插入操作
				if(list == null || list.size() <= 0){
					handleReturnVo(StringUtil.dealNull(orderMainId), StringUtil.dealNull(orderId));//增加到推送列表
				}else{
					log.info("订单信息：mainOrderId=" + orderMainId + "  suborderno=" + orderId + "  已经存在推送队列！此次不加入推送队列");
				}
			}
		}catch(Exception e){
			log.error("handleOrder:解析信息有误!失败信息：" + e.getMessage() , e);
		}
	}

	/**
	 *
	 * <p>Description:设置报文头信息,调用方法应该在传入对像时设置</p>
	 * @param systemEnvolopeVo
	 * @param shopId
	 */
	private void setServicContent(String shopId , SystemEnvelopeVo systemEnvolopeVo) {
		systemEnvolopeVo.setMsgtype("requestmessage");
		systemEnvolopeVo.setFormat("xml");
		systemEnvolopeVo.setVersion("1.0");
		systemEnvolopeVo.setShopid(shopId);
		systemEnvolopeVo.setMethod("11");//11推送方法标志
		systemEnvolopeVo.setTimestamp(DateHelper.getCurrentTime());
	}

	/**
	 *
	 * <p>Description:根据返回结果操作订单，结果信息失败的，插入推送表</p>
	 * @param document
	 * @param returnEnvolopeVo
	 */
	private void handleOrder(Document document, SystemEnvelopeVo returnEnvolopeVo) throws Exception {
		try{
			Element root = document.getRootElement();
			if(!"0".equals(returnEnvolopeVo.getResult_code())){//失败
				Node orderIdNode = document.selectSingleNode("//request_message/message/orderno");//大订单节点
				String mainOrderId = StringUtil.dealNullObject(orderIdNode.getText());
				List nodes = document.selectNodes("//request_message/message/items/item");
				for(int i = 0; i < nodes.size() ; i ++){
					Element element = (Element)nodes.get(i);
					Element subEle = (Element)element.selectSingleNode("suborderno");//小订单信息
					List list = orderOutSystemDao.findByOrderId(StringUtil.dealNullObject(subEle.getText()));//查询推送表中的订单是否存在，如果存在，则不再做插入操作
					if(list == null || list.size() <= 0){
						log.info("保存到推送队列订单信息：mainOrderId=" + mainOrderId + "  suborderno=" + subEle.getText());
						handleReturnVo(mainOrderId, StringUtil.dealNullObject(subEle.getText()));//增加到推送列表
					}else{
						log.info("订单信息：mainOrderId=" + mainOrderId + "  suborderno=" + subEle.getText() + "  已经存在推送队列！此次不加入推送队列");
					}
				}
			}
		}catch(Exception e){
			log.error("handleOrder:解析信息有误!失败信息：" + e.getMessage() , e);
			throw new Exception(e);
		}

	}

	/**
	 *
	 * <p>Description:根据返回结果对订单做处理，对于失败的订单增加到推送列表</p>
	 * @param mainOrderId
	 * @param subOrderId
	 * @throws Exception
	 */
	public void handleReturnVo(String mainOrderId, String subOrderId) throws Exception {
		try{
			OrderOutSystemModel orderOutSystemModel = new OrderOutSystemModel();
			orderOutSystemModel.setOrderMainId(mainOrderId);
			orderOutSystemModel.setOrderId(subOrderId);
			orderOutSystemModel.setTuisongFlag("0");
			orderOutSystemModel.setSystemRole("00");
			orderOutSystemModel.setCreateOper("system");
			orderOutSystemModel.setTimes(0);
			orderOutSystemDao.insert(orderOutSystemModel);
		}catch(Exception e){
			log.error("handleReturnVo:操作数据库失败：" + e.getMessage(), e);
			throw new Exception("数据库操作异常");
		}

	}

	/**
	 *
	 * <p>Description:验证vo信息</p>
	 * @param systemEnvolopeVo
	 */
	private void validateVoParams(SystemEnvelopeVo systemEnvolopeVo) throws Exception {
		if("".equals(StringUtil.dealNullObject(systemEnvolopeVo.getOrderno()))){
			throw new Exception("大订单号不能为空！");
		}
		if("".equals(StringUtil.dealNullObject(systemEnvolopeVo.getSum()))) {
			throw new Exception("商品总数量不能为空！");
		}
		if("".equals(StringUtil.dealNullObject(systemEnvolopeVo.getPayment()))){
			throw new Exception("订单总额不能为空！");
		}
	}

	/**
	 *
	 * <p>Description:参数验证</p>
	 * @param orderMap

	 */
	public void checkParamsMap(Map orderMap) throws Exception {
		if("".equals(StringUtil.dealNullObject((String) orderMap.get("suborderno")))){
			throw new Exception("小订单号不能为空！");
		}
		/*if("".equals(Tools.trim((String)orderMap.get("sorder_id")))){
			throw new Exception("订单编号不能为空！");
		}
		if("".equals(Tools.trim((String)orderMap.get("goods_id")))){
			throw new Exception("兑换券编号不能为空！");
		}*/
		if("".equals(StringUtil.dealNullObject((String) orderMap.get("price")))){
			throw new Exception("商品价格不能为空！");
		}
		if("".equals(StringUtil.dealNullObject((String) orderMap.get("number")))){
			throw new Exception("商品数量不能为空！");
		}
		if("".equals(StringUtil.dealNullObject((String) orderMap.get("mobile")))){
			throw new Exception("手机号码不能为空！");
		}
	}
}
