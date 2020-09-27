package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.model.OrderSubModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Map;

import static com.google.common.base.Objects.equal;

/**
 * Created by 张成 on 16-4-26.
 */
@Service
@Slf4j
public class VendorOrderServiceImpl implements VendorOrderService {

	// 注入订单SERVICE
	@Resource
	private OrderSubDao orderSubDao;
//	@Resource
//	private OrderMainDao orderMainDao;

	@Override
	public Response<OrderSubModel> find(User user) {
		// 实例化返回Response
		Response<OrderSubModel> response = new Response<OrderSubModel>();
		// 实例化订单检索的条件
		Map<String, Object> paramMap = Maps.newHashMap();
		// 实例化订单mode
        OrderSubModel orderSub = new OrderSubModel();
		try {

			String vendorId = user.getVendorId();
			if (StringUtils.isNotEmpty(vendorId) && !equal(vendorId, "0")) {
				// 把订单检索的条件写上
				paramMap.put("vendorId", vendorId);
			}
            paramMap.put("orderTypeYg","orderTypeYg");
			// 查询所有成交的订单orderSubList
            orderSub = orderSubDao.findOrderCount(paramMap);
            orderSub.setOrdertypeId(user.getUserType());
			// 扔给response
			response.setResult(orderSub);
			// 返回
			return response;
		} catch (Exception e) {
			log.error("get.order.top.error", Throwables.getStackTraceAsString(e));
			response.setError("get.order.top.error");
			return response;
		}
	}
    @Override
    public Response<OrderSubModel> findPoint(User user) {
        // 实例化返回Response
        Response<OrderSubModel> response = new Response<OrderSubModel>();
        // 实例化订单检索的条件
        Map<String, Object> paramMap = Maps.newHashMap();
        // 实例化订单mode
        OrderSubModel orderSub = new OrderSubModel();
        try {
            String vendorId = user.getVendorId();
            if (StringUtils.isNotEmpty(vendorId) && !equal(vendorId, "0")) {
                // 把订单检索的条件写上
                paramMap.put("vendorId", vendorId);
            }
            paramMap.put("orderTypeJf","orderTypeJf");
            // 查询所有成交的订单orderSubList
            orderSub = orderSubDao.findOrderCountPoints(paramMap);

            // 扔给response
            response.setResult(orderSub);
            // 返回
            return response;
        } catch (Exception e) {
            log.error("get.order.top.error", Throwables.getStackTraceAsString(e));
            response.setError("get.order.top.error");
            return response;
        }
    }
}
