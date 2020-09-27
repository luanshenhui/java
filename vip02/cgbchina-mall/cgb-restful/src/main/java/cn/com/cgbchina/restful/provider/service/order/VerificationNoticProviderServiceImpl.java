package cn.com.cgbchina.restful.provider.service.order;

import javax.annotation.Resource;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.model.InfoOutSystemModel;
import cn.com.cgbchina.related.service.InfoOutSystemService;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.service.OrderService;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.VerificationNotic;
import cn.com.cgbchina.rest.provider.model.order.VerificationNoticReturn;
import cn.com.cgbchina.rest.provider.service.XMLProvideService;
import cn.com.cgbchina.rest.provider.vo.order.VerificationNoticReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.VerificationNoticVO;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 验证通知接口 从xml对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "22")
@Slf4j
public class VerificationNoticProviderServiceImpl implements
		XMLProvideService<VerificationNoticVO, VerificationNoticReturnVO> {
	@Resource
	OrderService orderService;
	@Resource
	InfoOutSystemService infoOutSystemService;

	@Override
	public VerificationNoticReturnVO process(VerificationNoticVO model) {
		VerificationNotic verificationNotic = BeanUtils.copy(model,
				VerificationNotic.class);
		VerificationNoticReturn verificationNoticReturn = this.notic(verificationNotic);
		return BeanUtils.copy(verificationNoticReturn,
				VerificationNoticReturnVO.class);
	}

	private VerificationNoticReturn notic(VerificationNotic verificationNotic) {
		VerificationNoticReturn res = BeanUtils.randomClass(VerificationNoticReturn.class);
		String errMsg = "";
		Response<List<InfoOutSystemModel>> response;
		List<InfoOutSystemModel> infoOutSystemModelList;
		log.info("调用验证成功通知接口");
		if(verificationNotic != null) {
			errMsg = checkBackMsgValidate(verificationNotic);
			// 接口传入参数校验异常
			if(!"".equals(errMsg)) {
				res.setReturnCode("false");
				res.setReturnDes(errMsg);
				return res;
			} else {
				// 判断在行外系统记录表是否已经存在
				response = findByOrderId(verificationNotic.getSubOrderNo());
				if(!response.isSuccess()){
					log.error("Response.error,error code: {}", response.getError());
					throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
				}
				infoOutSystemModelList = response.getResult();
				if(infoOutSystemModelList != null && infoOutSystemModelList.size() > 0){
					//如果存在，则更改状态
					InfoOutSystemModel infoOutSystemModel = new InfoOutSystemModel();
					infoOutSystemModel.setOrderId(verificationNotic.getSubOrderNo());
					infoOutSystemModel.setVerifyCode(verificationNotic.getCodeData());
					infoOutSystemModel.setValidateStatus("01");
					infoOutSystemModel.setVerifyId(verificationNotic.getVerifyId().toString());
					infoOutSystemModel.setModifyOper("system");

					updateInfoByOrderId(infoOutSystemModel);
					res.setReturnCode("true");
					res.setReturnDes("成功");
				}else{
					res.setReturnCode("false");
					res.setReturnDes("不存在订单信息");
					return res;
				}
			}
		} else {
			res.setReturnCode("false");
			res.setReturnDes("接口传入参数不能为空！");
			return res;
		}

		log.info("调用验证成功通知接口");
		return res;
	}

	private String checkBackMsgValidate(VerificationNotic verificationNotic) {
		Response<OrderSubModel> response;
		String errMsg = "";
		try{
			// 大订单号
			if(verificationNotic.getOrderNo() == null || "".equals(verificationNotic.getOrderNo())) {
				errMsg = "大订单号不能为空！";
				return errMsg;
			}
			// 小订单号
			if(verificationNotic.getSubOrderNo() == null || "".equals(verificationNotic.getSubOrderNo())) {
				errMsg = "小订单号不能为空！";
				return errMsg;
			}
			// 验证码
			if(verificationNotic.getCodeData() == null || "".equals(verificationNotic.getCodeData())) {
				errMsg = "验证的验证码不能为空！";
				return errMsg;
			}
			// 验证唯一标识
			if(verificationNotic.getVerifyId() == null || "".equals(String.valueOf(verificationNotic.getVerifyId()))) {
				errMsg = "验证唯一标识不能为空！";
				return errMsg;
			}
			//验证订单信息,已签收的订单信息
			HashMap queryMap = Maps.newHashMap();
			queryMap.put("orderId", verificationNotic.getSubOrderNo());
			queryMap.put("curStatusId", "0310");
			response = findInfoByCurStatusId(queryMap);
			if(!response.isSuccess()){
				log.error("Response.error,error code: {}", response.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
			}
			OrderSubModel rderSubModel = response.getResult();
			if(rderSubModel == null) {
				errMsg = "订单信息不存在！";
				return errMsg;
			}
		}catch(Exception e){
			log.error("数据验证失败！失败原因:" + e.getMessage());
			errMsg = e.getMessage();
		}
		return errMsg;
	}

	/**
	 * 根据当前状态查询
	 * @param paramMap
	 * @return
	 *
	 */
	private Response<OrderSubModel> findInfoByCurStatusId(Map<String, Object> paramMap){
		Response<OrderSubModel> response = new Response<>();
		OrderSubModel orderSubModel = new OrderSubModel();
		try{
			Map<String,Long> result = Maps.newHashMap();
			response = orderService.findInfoByCurStatusId(paramMap);
			if(response.isSuccess()) {
				orderSubModel = response.getResult();
			}
			response.setResult(orderSubModel);
			return response;
		}catch (Exception e){
			log.error("OrderServiceImpl findInfoByCurStatusId query error", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);
			//response.setError("OrderServiceImpl.findGoodsBuyCount.query.error");
			return response;
		}
	}

	private Response<Integer> updateInfoByOrderId(InfoOutSystemModel infoOutSystemModel) {
		Response<Integer> response = Response.newResponse();

		try {
			Integer result = 0;
			response = infoOutSystemService.updateInfoByOrderId(infoOutSystemModel);
			response.setResult(result);
			return response;
		} catch (Exception e) {
			//log.error("infoOutSystemModel.update.error", Throwables.getStackTraceAsString(e));
			//response.setError("infoOutSystemModel.update.error");
			return response;
		}
	}

	private Response<List<InfoOutSystemModel>> findByOrderId(String orderId) {
		Response<List<InfoOutSystemModel>> response = Response.newResponse();
		List<InfoOutSystemModel> infoOutSystemList =  new ArrayList();
		try {
			response = infoOutSystemService.findInfoByOrderId(orderId);
			if(response.isSuccess()) {
				infoOutSystemList = response.getResult();
			}

			response.setResult(infoOutSystemList);
		} catch (Exception e) {
			return response;
		}
		return response;
	}
}
