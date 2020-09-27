package cn.com.cgbchina.restful.provider.service.order;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.log.service.MessageLogService;
import cn.com.cgbchina.related.service.InfoOutSystemService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.CCVerificationCodeQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.CCVerificationCodeReturnVO;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.order.ResendOrderInfo;
import cn.com.cgbchina.rest.visit.service.order.OrderService;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.vo.SystemEnvelopeVo;
import cn.com.cgbchina.user.service.VendorService;


import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;


/**
 * MAL121 CC重发验证码 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 */
@Service
@TradeCode(value = "MAL121")
@Slf4j
public class CCVerificationCodeProvideServiceImpl implements SoapProvideService<CCVerificationCodeQueryVO, CCVerificationCodeReturnVO> {
    @Resource
    OrderService o2oOrderService;
    @Resource
    InfoOutSystemService infoOutSystemService;
    @Resource
    VendorService vendorService;
    @Resource
    MessageLogService messageLogService;
    @Resource
    cn.com.cgbchina.trade.service.OrderService orderService;
    
    @Override
    public CCVerificationCodeReturnVO process(SoapModel<CCVerificationCodeQueryVO> model, CCVerificationCodeQueryVO content) {
        CCVerificationCodeReturnVO cCVerificationCodeReturnVO = new CCVerificationCodeReturnVO();

        log.info("【MAL121】流水：" + model.getSenderSN() + "，进入cc重发/转发验证码接口");
        String senderSN = StringUtil.dealNull(model.getSenderSN());
        String origin = StringUtil.dealNull(content.getOrigin());//发起方
        String mallType = StringUtil.dealNull(content.getMallType());//商城类型

        String orderno = StringUtil.dealNull(content.getOrderNo());//大订单号
        String suborderno = StringUtil.dealNull(content.getSubOrderNo());//小订单号
        String mobile = StringUtil.dealNull(content.getMobile());//电话号码

        log.info("【MAL121】流水：" + senderSN + "，CC重发/转发验证码请求，orderno=" + orderno + ",suborderno=" + suborderno + ",mobile=" + mobile + "origin=" + origin + "mallType=" + mallType);

        SystemEnvelopeVo systemEnvelopeVo = new SystemEnvelopeVo();
        try {
            Map<String, Object> paramsMap = Maps.newHashMap();
            paramsMap.put("orderno", orderno);
            paramsMap.put("suborderno", suborderno);
            paramsMap.put("mobile", mobile);
            paramsMap.put("origin", origin);
            paramsMap.put("mallType", mallType);
            systemEnvelopeVo = handleReceive(paramsMap);
            cCVerificationCodeReturnVO.setResultCode(systemEnvelopeVo.getResult_code());
            cCVerificationCodeReturnVO.setResultMsg(systemEnvelopeVo.getResult_msg());
        } catch (Exception e) {
            log.error("程序处理异常，异常原因" + e.getMessage());
            cCVerificationCodeReturnVO.setResultCode("4");
            cCVerificationCodeReturnVO.setResultMsg(e.getMessage());
            return cCVerificationCodeReturnVO;
        }

        return cCVerificationCodeReturnVO;
    }

    /**
     * 处理请求
     */
    public SystemEnvelopeVo handleReceive(Map<String, Object> map) throws Exception {
        log.info("come in to handleReceive to handle");
        SystemEnvelopeVo systemEnvelopeVo = new SystemEnvelopeVo();
        try {
            if ("".equals((String) map.get("orderno"))) {
                throw new Exception("受理失败，该订单没有可发送的验证码!错误码：01");
            }
            if ("".equals((String) map.get("suborderno"))) {
                throw new Exception("受理失败，该订单没有可发送的验证码!错误码：02");
            }
            if ("".equals((String) map.get("mallType"))) {
                throw new Exception("受理失败，该订单没有可发送的验证码!错误码：03");
            }
            if ("".equals((String) map.get("origin"))) {
                throw new Exception("受理失败，该订单没有可发送的验证码!错误码：04");
            }
            OrderSubModel orderSubModel = null;
            Response<OrderSubModel> orderSubResponse  = orderService.findOrderSubById((String) map.get("suborderno"));
            if (orderSubResponse.isSuccess() && orderSubResponse.getResult() != null) {
            	orderSubModel = orderSubResponse.getResult() ;
			}else {
				 throw new Exception("受理失败，没有该订单信息!错误码：05");
			}
            if ("".equals((String) map.get("mobile"))) {
            	Response<OrderMainModel> orderMainModelResponse =  orderService.findOrderMainById((String) map.get("orderno"));
            	if (orderMainModelResponse != null && orderMainModelResponse.getResult() != null) {
            		OrderMainModel orderMainModel = orderMainModelResponse.getResult();
            		map.put("mobile",orderMainModel.getCsgPhone1());
            	} else {
					  throw new Exception("受理失败，没有该订单信息!错误码：05");
				}
            }

            if ("02".equals((String) map.get("mallType"))) {//积分商城
                //设置重发交易方法
                systemEnvelopeVo.setMethod("13");
                systemEnvelopeVo.setOrderno((String) map.get("orderno"));
                List<Map<String, Object>> orderInfList = Lists.newArrayList();
                Map<String, Object> orderInfMap = Maps.newHashMap();
                orderInfMap.put("suborderno", (String) map.get("suborderno"));
                orderInfList.add(orderInfMap);
                //设置小订单信息
                systemEnvelopeVo.setMessageCirculateList(orderInfList);
                //调用接口
                ResendOrderInfo resendOrderInfo = new ResendOrderInfo();
                resendOrderInfo.setOrderNo((String) map.get("orderno"));
                resendOrderInfo.setSubOrderNo((String) map.get("suborderno"));
                resendOrderInfo.setVendorName(orderSubModel.getVendorId());
                resendOrderInfo.setMobile((String) map.get("mobile"));
                BaseResult baseResult =  o2oOrderService.resendOrder(resendOrderInfo);//调用重发接口
                //systemEnvelopeVo = (SystemEnvelopeVo) sendEnvolope(systemEnvelopeVo);
                systemEnvelopeVo.setResult_code(baseResult.getRetCode());
                systemEnvelopeVo.setResult_msg(baseResult.getRetErrMsg());
                log.info("订单重发/转发处理成功，返回码：" + systemEnvelopeVo.getResult_code() + "返回信息：" + systemEnvelopeVo.getResult_msg());
            } else {
                throw new Exception("受理失败，该订单没有可发送的验证码!错误码：05");
            }
        } catch (Exception e) {
            log.error("CC重发处理请求失败！失败原因：" + e.getMessage());
            e.printStackTrace();
            systemEnvelopeVo.setResult_code("4");
            systemEnvelopeVo.setResult_msg(e.getMessage());
            return systemEnvelopeVo;
        }
        return systemEnvelopeVo;
    }

}
