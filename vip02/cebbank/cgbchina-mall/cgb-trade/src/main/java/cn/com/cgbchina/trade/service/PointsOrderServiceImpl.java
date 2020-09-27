package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.model.BuyerInfo;
import cn.com.cgbchina.trade.model.Merchandise;
import cn.com.cgbchina.trade.model.OrderInfo;
import cn.com.cgbchina.trade.model.Transportation;

import com.google.common.collect.Lists;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by 11141021040453 on 16-4-15.
 */
@Service
public class PointsOrderServiceImpl implements PointsOrderService {
	static List<OrderInfo> orderInfos = Lists.newArrayList();

	static {
		OrderInfo orderInfo = null;
		Merchandise merchandise = null;
		BuyerInfo buyerInfo = null;
		Transportation transportation = null;
		for (int i = 0; i < 100; i++) {
			orderInfo = new OrderInfo();
			merchandise = new Merchandise();
			buyerInfo = new BuyerInfo();
			transportation = new Transportation();
			orderInfo.setHostId("10" + i);
			orderInfo.setId("1000" + i);
			orderInfo.setNumber("123456789" + i);
			SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-DD HH:mm:ss");
			java.util.Date time = null;
			try {
				time = sdf.parse(sdf.format(new Date()));
			} catch (ParseException e) {
				e.printStackTrace();
			}
			orderInfo.setTime(time);
			orderInfo.setType("实物");
			orderInfo.setChannel("广发商城");
			orderInfo.setCustomer("AAA");
			orderInfo.setOrderSum(BigDecimal.valueOf(6088.00));
			orderInfo.setServiceStatus("退货完成");
			orderInfo.setPayment(BigDecimal.valueOf(6088.00));
			orderInfo.setInstalentsStatus("分期2029.33×3含优惠券100.00含积分12000");
			orderInfo.setSum(1);
			orderInfo.setDealStatus("已发码");
			merchandise.setId("987654321" + i);
			merchandise.setPictureUrl("图片");
			merchandise.setName("苹果iPhone6Plus");
			merchandise.setColor("深空灰色");
			merchandise.setRom("64G");
			orderInfo.setMerchandise(merchandise);
			orderInfo.setStage("多期");
			orderInfo.setStageSum(BigDecimal.valueOf(129.00));
			orderInfo.setCoupon(BigDecimal.valueOf(192.00));
			orderInfo.setPoints(BigDecimal.valueOf(20000));
			orderInfo.setSeller("上海海牙湾贸易有限公司" + i);
			buyerInfo.setName("王大大" + i);
			buyerInfo.setCode("230221199813301");
			buyerInfo.setMobile1("13945614347");
			buyerInfo.setMobile2("13944445555");
			buyerInfo.setPostcode("134201");
			buyerInfo.setAddress("广东省广州市越秀区黄海路1-1号23栋105室");
			buyerInfo.setRequestTime("只有工作日送货" + i);
			buyerInfo.setMessage("尽快发货");
			orderInfo.setBuyerInfo(buyerInfo);
			transportation.setId("123467" + i);
			transportation.setTime(time);
			transportation.setCode("23222233333" + i);
			transportation.setCompany("中通快递");
			orderInfo.setTransportation(transportation);
			orderInfo.setFlag("0");
			orderInfos.add(orderInfo);
		}
	}

	/**
	 * 查找账户
	 * 
	 * @param pageNo
	 * @return
	 */
	public Response<Pager<OrderInfo>> find(@Param("pageNo") Integer pageNo) {
		if (pageNo == null) {
			pageNo = 1;
		}
		Response<Pager<OrderInfo>> response = new Response<Pager<OrderInfo>>();
		List<OrderInfo> retorderInfos = orderInfos;
		Integer start = (pageNo - 1) * 20;
		Integer end = pageNo * 20;
		retorderInfos = orderInfos.subList(start, end);
		Pager<OrderInfo> pager = new Pager<OrderInfo>(new Long(orderInfos.size()), retorderInfos);
		response.setResult(pager);
		return response;
	}

	/**
	 * 查看订单详情
	 * 
	 * @param id
	 * @return
	 */
	public Response<OrderInfo> findOrderInfo(@Param("id") String id) {
		if (id == null || "".equals(id)) {
			id = "10000";
		}
		Response<OrderInfo> response = new Response<OrderInfo>();
		for (OrderInfo orderInfo : orderInfos) {
			if (id.equals(orderInfo.getId())) {
				response.setResult(orderInfo);
				break;
			}
		}
		return response;
	}

}
