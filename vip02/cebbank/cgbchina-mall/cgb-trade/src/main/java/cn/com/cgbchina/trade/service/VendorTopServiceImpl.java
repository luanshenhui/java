package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.item.dto.GoodsDetailDto;
import cn.com.cgbchina.item.dto.RecommendGoodsDto;
import cn.com.cgbchina.item.service.FavoriteService;
import cn.com.cgbchina.item.service.GoodsDetailService;
import cn.com.cgbchina.trade.dao.OrderGoodsDetailDao;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.model.OrderGoodsDetailModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.*;

import static com.google.common.base.Objects.equal;

/**
 * Created by 张成 on 16-4-26.
 */

@Service
@Slf4j
public class VendorTopServiceImpl implements VendorTopService {
	// 注入收藏SERVICE
	@Resource
	private FavoriteService favoriteService;
	// 注入订单商品详情SERVICE
	@Resource
	private OrderGoodsDetailDao orderGoodsDetailDao;
	// 注入订单SERVICE
	@Resource
	private OrderSubDao orderSubDao;
	@Resource
	private GoodsDetailService goodsDetailService;

	@Override
	public Response<Map<String, Object>> find(User user) {
		// 实例化返回Response
		Response<Map<String, Object>> response = new Response<Map<String, Object>>();
		// 返回Response有两个LIST，需要用Map装一下
		Map<String, Object> paramMap = Maps.newHashMap();
		// 实例化收藏的list
		List<GoodsDetailDto> goodsList = new ArrayList<GoodsDetailDto>();
		// 实例化订单商品的list
		List<OrderSubModel> orderGoodsList = new ArrayList<OrderSubModel>();
		// 实例化订单的list
		List<OrderSubModel> orderSubList = new ArrayList<OrderSubModel>();
		try {
			Map<String,Object> favParamMap = Maps.newHashMap();
			if(user != null){
				favParamMap.put("vendorId", user.getVendorId());//供应商id
			}
			// 检索出用户收藏的goodsList
			goodsList = favoriteService.find(favParamMap);
			// 把它放到paramMap里名字叫favorite
			paramMap.put("favorite", goodsList);
			// 实例化订单检索的条件
			Map<String, Object> topOrderParam = Maps.newHashMap();
			String vendorId = user.getVendorId();
			if (StringUtils.isNotEmpty(vendorId) && !equal(vendorId, "0")) {
				// 把订单检索的条件写上
				topOrderParam.put("vendorId", vendorId);
			}
			// 查询所有成交的订单orderSubList
			orderSubList = orderSubDao.findSuccess(topOrderParam);
			// 用orderSubList成交的订单来查询交易最多的商品TOP10
			if (orderSubList != null && orderSubList.size() > 0) {
				orderGoodsList = orderSubDao.findTopOrder(orderSubList);
			}
			// 把它放到paramMap里名字叫order
			paramMap.put("order", orderGoodsList);
			// 扔给response
			response.setResult(paramMap);
			// 返回
			return response;
		} catch (Exception e) {
			log.error("get.favorite.top.error", Throwables.getStackTraceAsString(e));
			response.setError("get.favorite.top.error");
			return response;
		}
	}

	/**
	 * 查找供应商本周订单成交笔数、成交客户数
	 * 
	 * @return Map
	 */
	public Response<Map<String, Object>> findOrderCountByWeek(User user) {
		// 实例化返回Response
		Response<Map<String, Object>> response = new Response<Map<String, Object>>();
		try {
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
			Map<String, Object> params = Maps.newHashMap();
			// TODO
			params.put("vendorId", "222001");
			List<OrderSubModel> orderCount = orderSubDao.findOrderCountByWeekDay(params);
			List<OrderSubModel> personCount = orderSubDao.findPersonCountByWeekDay(params);
			Map<String, String> dbOrderMap = Maps.newHashMap();
			Map<String, String> dbPersonMap = Maps.newHashMap();
			for (OrderSubModel model : orderCount) {
				dbOrderMap.put(dateFormat.format(model.getCreateTime()), model.getOrderCount());
			}
			for (OrderSubModel model : personCount) {
				dbPersonMap.put(dateFormat.format(model.getCreateTime()), model.getPersonCount());
			}
			Calendar c = Calendar.getInstance();
			int weekday = c.get(Calendar.DAY_OF_WEEK) - 1;
			c.add(Calendar.DAY_OF_MONTH, -weekday);
			List<String> weekList = new ArrayList<String>();
			List<String> orderCountList = new ArrayList<String>();
			List<String> personCountList = new ArrayList<String>();

			weekList.add("周一");
			String date = dateFormat.format(c.getTime());
			orderCountList.add(findCount(date, dbOrderMap));
			personCountList.add(findCount(date, dbPersonMap));
			weekList.add("周二");
			c.add(Calendar.DAY_OF_YEAR, 1);
			date = dateFormat.format(c.getTime());
			orderCountList.add(findCount(date, dbOrderMap));
			personCountList.add(findCount(date, dbPersonMap));
			weekList.add("周三");
			c.add(Calendar.DAY_OF_YEAR, 1);
			date = dateFormat.format(c.getTime());
			orderCountList.add(findCount(date, dbOrderMap));
			personCountList.add(findCount(date, dbPersonMap));
			weekList.add("周四");
			c.add(Calendar.DAY_OF_YEAR, 1);
			orderCountList.add(findCount(date, dbOrderMap));
			personCountList.add(findCount(date, dbPersonMap));
			weekList.add("周五");
			c.add(Calendar.DAY_OF_YEAR, 1);
			orderCountList.add(findCount(date, dbOrderMap));
			personCountList.add(findCount(date, dbPersonMap));
			weekList.add("周六");
			c.add(Calendar.DAY_OF_YEAR, 1);
			orderCountList.add(findCount(date, dbOrderMap));
			personCountList.add(findCount(date, dbPersonMap));
			weekList.add("周日");
			c.add(Calendar.DAY_OF_YEAR, 1);
			orderCountList.add(findCount(date, dbOrderMap));
			personCountList.add(findCount(date, dbPersonMap));
			// 返回
			Map<String, Object> resultMap = Maps.newHashMap();
			resultMap.put("data", weekList);
			resultMap.put("orderCountList", orderCountList);
			resultMap.put("personCountList", personCountList);
			response.setResult(resultMap);
			return response;
		} catch (Exception e) {
			log.error("get.favorite.top.error", Throwables.getStackTraceAsString(e));
			response.setError("get.favorite.top.error");
			return response;
		}
	}

	/**
	 * 根据日期查找订单数
	 * 
	 * @param date
	 * @param dbMap
	 * @return
	 */
	private String findCount(String date, Map<String, String> dbMap) {
		String count = dbMap.get(date);
		if (count == null) {
			count = "0";
		}
		return count;
	}

	/**
	 * 查询热销产品
	 * 
	 * @return
	 */
	@Override
	public Response<List<Map<String, Object>>> findSellTop() {

		Response<List<Map<String, Object>>> result = new Response<List<Map<String, Object>>>();

		try {
			// 订单商品的list
			List<OrderSubModel> orderGoodsList;

			// List<OrderSubModel> orderGoodsTop4List = new ArrayList<OrderSubModel>();
			List<Map<String, Object>> listRecommendGoods = Lists.newArrayList();

			// 订单的list
			List<OrderSubModel> orderSubList;

			Map<String, Object> topSellParam = Maps.newHashMap();

			// 查询所有成交的订单orderSubList
			orderSubList = orderSubDao.findSuccess(topSellParam);

			if (null == orderSubList || orderSubList.size() == 0) {
				orderSubList = Lists.newArrayList();
			}
			// 用orderSubList成交的订单来查询交易最多的商品TOP10
			orderGoodsList = orderSubDao.findTopOrder(orderSubList);

			if(null == orderGoodsList){
				result.setError("get.favorite.top.empty");
				return result;
			}
			//TODO 不能写死循环3次，否则小于三件商品时，出现越界异常
			//for (int i = 0; i < 3; i++) {
			for (int i = 0; i < orderGoodsList.size(); i++) {
				if(i > 3){// 只显示前四条
					break;
				}
				Map<String, Object> itemGoodsMap = goodsDetailService
						.findItemInfoByItemCode(orderGoodsList.get(i).getGoodsId());
				if(itemGoodsMap!=null){
					listRecommendGoods.add(itemGoodsMap);
				}
			}

			result.setResult(listRecommendGoods);
			return result;
		} catch (Exception e) {
			log.error("get.favorite.top.error,error code {}", Throwables.getStackTraceAsString(e));
			result.setError("get.favorite.top.error");
			return result;
		}
	}
}
