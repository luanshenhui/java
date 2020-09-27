package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.service.order.OrderService;
import cn.com.cgbchina.trade.dao.OrderMainDao;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.manager.PayManager;
import cn.com.cgbchina.trade.model.*;
import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.vo.SystemEnvelopeVo;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.VendorService;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


/**
 * Created by sf on 16-7-20.
 */
@Service
@Slf4j
public class DealO2OOrderServiceImpl implements DealO2OOrderService {

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
	@Resource
	OrderSendForO2OService orderSendForO2OService;

	@Resource
	OrderSubDao orderSubDao;
	@Resource
	OrderMainDao orderMainDao;
	@Resource
	OrderOutSystemDao orderOutSystemDao;
	@Resource
	PayManager payManager;

	@Override
	public Response<BaseResult> dealO2OOrdersAfterPaySucc(String orderId) {

		OrderSubModel orderSubModel = orderSubDao.findById(orderId);
		Response<BaseResult> res = Response.newResponse();
		try {
			Response<VendorInfoModel> response = vendorService.findVendorInfosByVendorId(orderSubModel.getVendorId());
			VendorInfoModel vendorInfoModel = new VendorInfoModel();
			if(response.isSuccess() && null != response.getResult()){
				vendorInfoModel = response.getResult();
			}
			// 实时推送
			if("3".equals(vendorInfoModel.getVendorRole()) && "00".equals(vendorInfoModel.getActionFlag())) {
				//new ThreadPoolUtil().getThreadPool().execute(new SendO2OOrderThread(orderSendForO2OService, orderMainId, orderId));
				// 测试用
				//orderSendForO2OService.orderSendForO2O(orderMainId, orderId);
				// 测试用 新的
				SystemEnvelopeVo systemEnvolopeVo = new SystemEnvelopeVo();
				systemEnvolopeVo.setOrderId(orderId);
				systemEnvolopeVo.setOrderno(orderSubModel.getOrdermainId());
				res = orderSendForO2OService.sendO2OOrderProcess(systemEnvolopeVo);
				if(!res.isSuccess()) {
					log.error("O2O订单推送---出错原因:{}", res.getError());
				}
				return res;
			}
			// 批量推送
			if("3".equals(vendorInfoModel.getVendorRole()) && "01".equals(vendorInfoModel.getActionFlag())) {
				saveBatchO2OOrder(orderId,orderSubModel.getOrdermainId());
				return res;
			}
		}catch(Exception e) {
			log.error("O2O订单推送---异常：" , e);
			res.setError("O2O订单推送---异常：");
			res.setSuccess(false);
			return res;
		}
		res.setSuccess(false);
		res.setError("O2O订单推送---条件不符，不推送");
		return res;

	}

	@Override
	public Response<BaseResult> dealO2OOrdersAfterPaySucc(String orderId,String orderMainId,String vendorId) {
		Response<BaseResult> res = Response.newResponse();
		try {
			Response<VendorInfoModel> response = vendorService.findVendorInfosByVendorId(vendorId);
			VendorInfoModel vendorInfoModel = new VendorInfoModel();
			if(response.isSuccess() && null != response.getResult()){
				vendorInfoModel = response.getResult();
			}
			// 实时推送
			if("3".equals(vendorInfoModel.getVendorRole()) && "00".equals(vendorInfoModel.getActionFlag())) {
				//new ThreadPoolUtil().getThreadPool().execute(new SendO2OOrderThread(orderSendForO2OService, orderMainId, orderId));
				// 测试用
				//orderSendForO2OService.orderSendForO2O(orderMainId, orderId);
				// 测试用 新的
				SystemEnvelopeVo systemEnvolopeVo = new SystemEnvelopeVo();
				systemEnvolopeVo.setOrderId(orderId);
				systemEnvolopeVo.setOrderno(orderMainId);
				res = orderSendForO2OService.sendO2OOrderProcess(systemEnvolopeVo);
				if(!res.isSuccess()) {
					log.error("O2O订单推送---出错原因:{}", res.getError());
				}
				return res;
			}
			// 批量推送
			if("3".equals(vendorInfoModel.getVendorRole()) && "01".equals(vendorInfoModel.getActionFlag())) {
				saveBatchO2OOrder(orderId,orderMainId);
				return res;
			}
		}catch(Exception e) {
			log.error("O2O订单推送---异常：" , e);
			res.setError("O2O订单推送---异常：");
			res.setSuccess(false);
			return res;
		}
		res.setSuccess(false);
		res.setError("O2O订单推送---条件不符，不推送");
		return res;
	}

	/**
	 * MAL401 020业务与商城供应商平台对接 ,当更新订单信息后，进行O2O推送处理
	 * 
	 */
	@Override
	public Response<BaseResult> dealO2OOrdersAfterPaySucc(String orderMainId,OrderSubModel orderSubModel) {
		Response<BaseResult> res = Response.newResponse();
		try {
			List<OrderSubModel> orderSubModels = orderSubDao.findByOrderMainId(orderMainId);
			if(orderSubModels != null && !orderSubModels.isEmpty()){
				for(OrderSubModel subModel : orderSubModels){
					Response<VendorInfoModel> response = vendorService.findVendorInfosByVendorId(subModel.getVendorId());
					VendorInfoModel vendorInfoModel = new VendorInfoModel();
					if(response.isSuccess() && null != response.getResult()){
						vendorInfoModel = response.getResult();
					}
					// 实时推送
					if("3".equals(vendorInfoModel.getVendorRole()) && "00".equals(vendorInfoModel.getActionFlag())) {
						SystemEnvelopeVo systemEnvolopeVo = new SystemEnvelopeVo();
						systemEnvolopeVo.setOrderId(subModel.getOrderId());
						systemEnvolopeVo.setOrderno(orderMainId);
						res = orderSendForO2OService.sendO2OOrderProcess(systemEnvolopeVo);
						if(!res.isSuccess()) {
							log.error("O2O订单推送---出错原因:{}", res.getError());
							throw new Exception(res.getError());
						}
					}
					// 批量推送
					if("3".equals(vendorInfoModel.getVendorRole()) && "01".equals(vendorInfoModel.getActionFlag())) {
						saveBatchO2OOrder(subModel.getOrderId(),orderMainId);
					}
				}
			}
		}catch(Exception e) {
			log.error("O2O订单推送---异常：" , e);
			res.setError("O2O订单推送---异常：");
			res.setSuccess(false);
			return res;
		}
		BaseResult baseResult = new BaseResult();
		baseResult.setRetCode("000000");
		baseResult.setRetErrMsg("O2O订单推送结束");
		res.setResult(baseResult);
		return res;
	}

	private void saveBatchO2OOrder(String orderId,String orderMainId) throws Exception {
		OrderOutSystemModel orderOutSystemModel = new OrderOutSystemModel();
		orderOutSystemModel.setOrderId(orderId);
		orderOutSystemModel.setOrderMainId(orderMainId);
		orderOutSystemModel.setTimes(0);
		orderOutSystemModel.setTuisongFlag("0");
		orderOutSystemModel.setSystemRole("00");// O2O
		orderOutSystemModel.setCreateTime(new Date());
		orderOutSystemModel.setCreateOper("来自第三方");
		payManager.insert(orderOutSystemModel);
	}
}
