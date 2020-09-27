package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dto.GoodsDetailDto;
import cn.com.cgbchina.item.service.BrandService;
import cn.com.cgbchina.item.service.VendorGoodsService;
import cn.com.cgbchina.trade.dao.OrderGoodsDetailDao;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.model.OrderGoodsDetailModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by 张成 on 16-4-27.
 */
@Service
@Slf4j
public class AdminTopServiceImpl implements AdminTopService {

	// 注入订单OrderSubDao
	@Resource
	private OrderSubDao orderSubDao;
	// 注入订单商品SERVICE
	@Resource
	private VendorGoodsService vendorGoodsService;
	@Resource
	private BrandService brandService;

	@Override
	public Response<Map<String, Object>> find(User user) {
		log.error("adminTop start");
		// 实例化返回Response
		Response<Map<String, Object>> response = new Response<Map<String, Object>>();
		// 返回Response有两个LIST，需要用Map装一下
		Map<String, Object> paramMap = Maps.newHashMap();
		// 实例化订单的list
		List<OrderSubModel> orderSubList = new ArrayList<OrderSubModel>();
		// 实例化订单商品的list
		List<OrderSubModel> orderGoodsList = new ArrayList<OrderSubModel>();
		// 实例化top供应商的list
		List<OrderSubModel> orderVendorList = new ArrayList<OrderSubModel>();
		// 实例化top品牌的list
		List<OrderSubModel> orderBrandList = new ArrayList<OrderSubModel>();
		try {
			// 实例化订单检索的条件
			Map<String, Object> topGoodsParam = Maps.newHashMap();
			// 查询所有成交的订单orderSubList
			orderSubList = orderSubDao.findSuccess(topGoodsParam);
			log.error("adminTop orderSubList:size {}",orderSubList.size());
			// 用orderSubList成交的订单来查询交易最多的商品TOP3/5
			/* change start by geshuo 20160710:数组长度为0时,规避查询异常 ------------------ */
			List<OrderSubModel> top5OrderGoodsList = new ArrayList<>();
			if(orderSubList != null && orderSubList.size() > 0){
				log.error("adminTop orderSubList:size {}",orderSubList.size());
				top5OrderGoodsList = orderSubDao.findTopGoods(orderSubList);
			}
			/* change end by geshuo 20160710  -------------------------------------------- */

			if (top5OrderGoodsList != null) {
				if (top5OrderGoodsList.size() > 3) {
					orderGoodsList.add(top5OrderGoodsList.get(0));
					orderGoodsList.add(top5OrderGoodsList.get(1));
					orderGoodsList.add(top5OrderGoodsList.get(2));
				} else {
					orderGoodsList = top5OrderGoodsList;
				}
			}
			// 把它放到paramMap里名字叫goods
			paramMap.put("goods", orderGoodsList);
			// 用orderVendorList成交的订单来查询交易最多的供应商TOP5

			// 实例化供应商检索的条件
			Map<String, Object> topVendorParam = Maps.newHashMap();
			orderVendorList = orderSubDao.findTopVendor(topVendorParam);
			// 把它放到paramMap里名字叫vendor
			paramMap.put("vendor", orderVendorList);
			// 实例化品牌检索的条件
			Map<String, Object> topBrandParam = Maps.newHashMap();
			orderBrandList = orderSubDao.findTopBrand(topBrandParam);
			// 把它放到paramMap里名字叫brand
			paramMap.put("brand", orderBrandList);

			// 实例化商品model
			GoodsDetailDto goodsDetailDto = new GoodsDetailDto();
			goodsDetailDto = vendorGoodsService.find(user).getResult();

			//查询品牌审核数量
			Map<String, Object> brandParamMap = Maps.newHashMap();
			brandParamMap.put("ordertypeId",Contants.BUSINESS_TYPE_YG);
			brandParamMap.put("status", 2);//待审核
			Integer brandCount = brandService.findBrandCount(brandParamMap).getResult().intValue();
			goodsDetailDto.setBrandCount(brandCount);//品牌审核数量
			// 把它放到paramMap里名字叫approve
			paramMap.put("approve", goodsDetailDto);

			// 扔给response
			response.setResult(paramMap);
			// 返回
			return response;
		} catch (Exception e) {
			log.error("get.favorite.top.error{}", Throwables.getStackTraceAsString(e));
			response.setError("get.favorite.top.error");
			return response;
		}
	}

	/**
	 * 搜索页下部推荐商品用（top5）
	 * @return
	 */
	@Override
	public Response<Map<String, Object>> findTop5ForSearch() {
		// 实例化返回Response
		Response<Map<String, Object>> response = new Response<Map<String, Object>>();
		// 返回Response有两个LIST，需要用Map装一下
		Map<String, Object> paramMap = Maps.newHashMap();
		// 实例化订单的list
		List<OrderSubModel> orderSubList = new ArrayList<OrderSubModel>();
		try {
			// 实例化订单检索的条件
			Map<String, Object> topGoodsParam = Maps.newHashMap();
			// 查询所有成交的订单orderSubList
			orderSubList = orderSubDao.findSuccess(topGoodsParam);
			// 用orderSubList成交的订单来查询交易最多的商品TOP3/5
			List<OrderSubModel> top5OrderGoodsList = orderSubDao.findTopGoods(orderSubList);
			// 把它放到paramMap里名字叫goods
			paramMap.put("goods", top5OrderGoodsList);
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
}
