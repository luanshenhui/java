package cn.com.cgbchina.restful.provider.service.user;

import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.user.OrderHistoryAddressQueryDetailReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.OrderHistoryAddressQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.OrderHistoryAddressQueryVO;
import cn.com.cgbchina.trade.model.TblOrderMainHisModel;
import cn.com.cgbchina.trade.model.TblOrdermainHistoryModel;
import cn.com.cgbchina.trade.service.OrderQueryService;
import cn.com.cgbchina.trade.service.TblOrderMainHistoryService;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

import java.util.Date;
import java.util.List;

/**
 * MAL114 订单历史地址信息查询 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 */
@Service
@TradeCode(value = "MAL114")
@Slf4j
public class OrderHistoryAddressQueryProvideServiceImpl implements SoapProvideService<OrderHistoryAddressQueryVO, OrderHistoryAddressQueryReturnVO> {
    @Resource
    TblOrderMainHistoryService tblOrderMainHistoryService;
    @Resource
    OrderQueryService orderQueryService;

    @Override
    public OrderHistoryAddressQueryReturnVO process(SoapModel<OrderHistoryAddressQueryVO> model, OrderHistoryAddressQueryVO content) {
        OrderHistoryAddressQueryReturnVO orderHistoryAddressQueryReturnVO = new OrderHistoryAddressQueryReturnVO();

        String ordermainId = content.getOrdermainId();

        //查询订单历史地址
        try {
            log.info("【MAL114】订单历史地址查询，订单号：" + ordermainId);
            Response<List<TblOrderMainHisModel>>  response =  orderQueryService.findOrderMainHisByOrderMainId(ordermainId);
            log.info("【MAL114】订单历史地址查询，订单号：" + ordermainId + "。订单历史地址记录数：" + "1");
            List<OrderHistoryAddressQueryDetailReturnVO> list = Lists.newArrayList();
            if (response.getResult() != null) {
            	List<TblOrderMainHisModel> orderMainHises = response.getResult();
            	if (orderMainHises != null && !orderMainHises.isEmpty()) {
            		for (TblOrderMainHisModel orderMainHis : orderMainHises) {    					
            			OrderHistoryAddressQueryDetailReturnVO detailReturnVO = new OrderHistoryAddressQueryDetailReturnVO();
            			detailReturnVO.setPostCode(orderMainHis.getCsgPostcode());
            			detailReturnVO.setCsgProvince(orderMainHis.getCsgProvince());
            			detailReturnVO.setCsgCity(orderMainHis.getCsgCity());
            			detailReturnVO.setCsgBorough(orderMainHis.getCsgBorough());
            			detailReturnVO.setDeliveryAddr(orderMainHis.getCsgAddress());
            			detailReturnVO.setDeliveryName(orderMainHis.getContNm());
            			detailReturnVO.setDeliveryMobile(orderMainHis.getCsgPhone1());
            			detailReturnVO.setDeliveryPhone(orderMainHis.getContHphone());
            			detailReturnVO.setPromotors(orderMainHis.getPromotors());
            			if (orderMainHis.getModifyTime() != null) {							
            				String updateDate = DateHelper.date2string(orderMainHis.getModifyTime(), DateHelper.YYYYMMDDHHMMSS).substring(0, 8);
            				detailReturnVO.setUpdateDate(updateDate);
            				String updateTime = DateHelper.date2string(orderMainHis.getModifyTime(), DateHelper.YYYYMMDDHHMMSS).substring(8, 14);
            				detailReturnVO.setUpdateTime(updateTime);
						}
            			list.add(detailReturnVO);
    				}
				}
            }
            orderHistoryAddressQueryReturnVO.setAddresses(list);
        } catch (Exception e) {
            log.error("exception", e);
            orderHistoryAddressQueryReturnVO.setReturnCode("000009");
            orderHistoryAddressQueryReturnVO.setReturnDes(e.toString());
            return orderHistoryAddressQueryReturnVO;
        }
        orderHistoryAddressQueryReturnVO.setReturnCode("000000");
        return orderHistoryAddressQueryReturnVO;
    }

}
