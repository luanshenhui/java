package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.item.dto.CommendRankDto;
import cn.com.cgbchina.item.dto.GoodsDetailDto;
import cn.com.cgbchina.item.model.CommendRankModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.FavoriteService;
import cn.com.cgbchina.item.service.GoodsDetailService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.model.OrderSubModel;
import com.google.common.base.Function;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.util.*;
import java.util.concurrent.TimeUnit;

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
//	@Resource
//	private OrderGoodsDetailDao orderGoodsDetailDao;
	// 注入订单SERVICE
	@Resource
	private OrderSubDao orderSubDao;
	@Resource
	private GoodsDetailService goodsDetailService;
	@Resource
	private ItemService itemService;

	private final LoadingCache<String, Map<String, Object>> topRankCache
			= CacheBuilder.newBuilder().expireAfterWrite(10L, TimeUnit.MINUTES).build(
			new CacheLoader<String, Map<String, Object>>() {
				@Override
				public Map<String, Object> load(String vendorId) throws Exception {
					// 返回Response有两个LIST，需要用Map装一下
					Map<String, Object> paramMap = Maps.newHashMap();
					CommendRankModel commendRankModel = new CommendRankModel();
					commendRankModel.setDelFlag(0);
					commendRankModel.setStatType("0006");//供应商热门收藏商品统计
					commendRankModel.setVendorId(vendorId);
					Response<List<CommendRankModel>> commendRankResponse = goodsDetailService.findCommendRankAll(commendRankModel);
					if (commendRankResponse.isSuccess() && commendRankResponse.getResult().size() > 0){
						List<CommendRankModel> commendRankModelList = commendRankResponse.getResult();
						final List<String> itemCodestemp = Lists.transform(commendRankModelList, new Function<CommendRankModel, String>() {
							@Override
							public String apply(@NotNull CommendRankModel input) {
								return input.getItemCode();
							}
						});
						Response<List<ItemModel>> response = itemService.findByCodes(Lists.<String>newArrayList(itemCodestemp));
						Map<String,String> itemmap = Maps.newHashMap();
						if (response.isSuccess()){
							List<ItemModel> itemModels = response.getResult();
							for(ItemModel itemModel : itemModels){
								itemmap.put(itemModel.getCode(),itemModel.getGoodsCode());
							}
						}
						List<CommendRankDto> commendRankDtoList = Lists.newArrayList();
						for(CommendRankModel commendRank : commendRankModelList){
							CommendRankDto commendRankDto = new CommendRankDto();
							commendRankDto.setGoodsCode(itemmap.get(commendRank.getItemCode()));
							commendRankDto.setItemCode(commendRank.getItemCode());
							commendRankDto.setStatNum(commendRank.getStatNum01());
							commendRankDto.setGoodsName(commendRank.getGoodsName());
							commendRankDtoList.add(commendRankDto);
						}
						paramMap.put("favorite", commendRankDtoList);
					}
					CommendRankModel commendRankOrderModel = new CommendRankModel();
					commendRankOrderModel.setDelFlag(0);
					commendRankOrderModel.setStatType("0007");//供应商热门收藏商品统计
					commendRankOrderModel.setVendorId(vendorId);
					Response<List<CommendRankModel>> commendRankOrderResponse = goodsDetailService.findCommendRankAll(commendRankOrderModel);
					if (commendRankOrderResponse.isSuccess() && commendRankOrderResponse.getResult().size() > 0){
						List<CommendRankModel> commendRankModelList = commendRankOrderResponse.getResult();
						final List<String> itemCodestemp2 = Lists.transform(commendRankModelList, new Function<CommendRankModel, String>() {
							@Override
							public String apply(@NotNull CommendRankModel input) {
								return input.getItemCode();
							}
						});
						Response<List<ItemModel>> response = itemService.findByCodes(Lists.<String>newArrayList(itemCodestemp2));
						Map<String,String> itemmap = Maps.newHashMap();
						if (response.isSuccess()){
							List<ItemModel> itemModels = response.getResult();
							for(ItemModel itemModel : itemModels){
								itemmap.put(itemModel.getCode(),itemModel.getGoodsCode());
							}
						}
						List<CommendRankDto> commendRankDtoList = Lists.newArrayList();
						for(CommendRankModel commendRank : commendRankModelList){
							CommendRankDto commendRankDto = new CommendRankDto();
							commendRankDto.setGoodsCode(itemmap.get(commendRank.getItemCode()));
							commendRankDto.setItemCode(commendRank.getItemCode());
							commendRankDto.setStatNum(commendRank.getStatNum01());
							commendRankDto.setGoodsName(commendRank.getGoodsName());
							commendRankDtoList.add(commendRankDto);
						}
						paramMap.put("order", commendRankDtoList);
					}
					return paramMap;
				}
			});


	//供应商热门收藏，热门销售
	@Override
	public Response<Map<String, Object>> find(User user, String orderType) {
		// 实例化返回Response
		Response<Map<String, Object>> response = new Response<Map<String, Object>>();
		// 返回Response有两个LIST，需要用Map装一下
		Map<String, Object> paramMap = Maps.newHashMap();
		//改为从批处理获得
		try {
			response.setResult(Maps.newHashMap(topRankCache.getUnchecked(user.getVendorId())));
			return response;
		}catch (Exception e) {
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
			//供应商一周成交笔数&成交用户数
			CommendRankModel orderCountpara = new CommendRankModel();
			orderCountpara.setVendorId(user.getVendorId());
			orderCountpara.setStatType("0005");
//			orderCountpara.setOrdertypeId("YG");
			orderCountpara.setDelFlag(0);
			Response<List<CommendRankModel>> orderCountreres = goodsDetailService.findCommendRankAll(orderCountpara);
			List<CommendRankModel> orderCount = null;
			if (orderCountreres.isSuccess()){
				orderCount = orderCountreres.getResult();
			}else{
				log.error("vendorTopService.findCommendRank.error");
			}
			Map<Integer ,CommendRankModel> dbOrderAndPerson = Maps.newHashMap();
			for (CommendRankModel model : orderCount){
				dbOrderAndPerson.put(model.getRank(),model);
			}
			List<String> weekList;
			List<String> orderCountList = Lists.newArrayList();
			List<String> personCountList = Lists.newArrayList();
			weekList = Arrays.asList("周一","周二","周三","周四","周五","周六","周日");
			for (int i=1; i<8 ; i++){
				if(dbOrderAndPerson.get(i)==null){
					orderCountList.add("0");
					personCountList.add("0");
				}else {
					if (dbOrderAndPerson.get(i).getStatNum01()==null){
						orderCountList.add("0");
					}else{
						orderCountList.add(dbOrderAndPerson.get(i).getStatNum01().toString());
					}
					if (dbOrderAndPerson.get(i).getStatNum02()==null){
						personCountList.add("0");
					}else{
						personCountList.add(dbOrderAndPerson.get(i).getStatNum02().toString());
					}
				}
			}
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
//	@Override
//    public Response<Map<String, Object>> findOrderCountByWeekPoint(User user) {
//        // 实例化返回Response
//        Response<Map<String, Object>> response = new Response<Map<String, Object>>();
//        try {
//			//供应商一周成交笔数&成交用户数
//			CommendRankModel orderCountpara = new CommendRankModel();
//			orderCountpara.setVendorId(user.getVendorId());
//			orderCountpara.setStatType("0005");
//			orderCountpara.setOrdertypeId("JF");
//			orderCountpara.setDelFlag(0);
//			Response<List<CommendRankModel>> orderCountreres = goodsDetailService.findCommendRankAll(orderCountpara);
//			List<CommendRankModel> orderCount = null;
//			if (orderCountreres.isSuccess()){
//				orderCount = orderCountreres.getResult();
//			}else{
//				log.error("vendorTopService.findCommendRank.error");
//			}
//			Map<Integer ,CommendRankModel> dbOrderAndPerson = Maps.newHashMap();
//			for (CommendRankModel model : orderCount){
//				dbOrderAndPerson.put(model.getRank(),model);
//			}
//			Calendar c = Calendar.getInstance();
//			int weekday = c.get(Calendar.DAY_OF_WEEK) - 1;
//			c.add(Calendar.DAY_OF_MONTH, -weekday);
//			List<String> weekList = new ArrayList<String>();
//			List<String> orderCountList = new ArrayList<String>();
//			List<String> personCountList = new ArrayList<String>();
//
//			weekList.add("周一");
//			orderCountList.add(dbOrderAndPerson.get(1).getStatNum01()==null?"0":dbOrderAndPerson.get(1).getStatNum01().toString());
//			personCountList.add(dbOrderAndPerson.get(1).getStatNum02()==null?"0":dbOrderAndPerson.get(1).getStatNum02().toString());
//			weekList.add("周二");
//			c.add(Calendar.DAY_OF_YEAR, 1);
//			orderCountList.add(dbOrderAndPerson.get(2).getStatNum01()==null?"0":dbOrderAndPerson.get(2).getStatNum01().toString());
//			personCountList.add(dbOrderAndPerson.get(2).getStatNum02()==null?"0":dbOrderAndPerson.get(2).getStatNum02().toString());
//			weekList.add("周三");
//			c.add(Calendar.DAY_OF_YEAR, 1);
//			orderCountList.add(dbOrderAndPerson.get(3).getStatNum01()==null?"0":dbOrderAndPerson.get(3).getStatNum01().toString());
//			personCountList.add(dbOrderAndPerson.get(3).getStatNum02()==null?"0":dbOrderAndPerson.get(3).getStatNum02().toString());
//			weekList.add("周四");
//			orderCountList.add(dbOrderAndPerson.get(4).getStatNum01()==null?"0":dbOrderAndPerson.get(4).getStatNum01().toString());
//			personCountList.add(dbOrderAndPerson.get(4).getStatNum02()==null?"0":dbOrderAndPerson.get(4).getStatNum02().toString());
//			weekList.add("周五");
//			orderCountList.add(dbOrderAndPerson.get(5).getStatNum01()==null?"0":dbOrderAndPerson.get(5).getStatNum01().toString());
//			personCountList.add(dbOrderAndPerson.get(5).getStatNum02()==null?"0":dbOrderAndPerson.get(5).getStatNum02().toString());
//			weekList.add("周六");
//			orderCountList.add(dbOrderAndPerson.get(6).getStatNum01()==null?"0":dbOrderAndPerson.get(6).getStatNum01().toString());
//			personCountList.add(dbOrderAndPerson.get(6).getStatNum02()==null?"0":dbOrderAndPerson.get(6).getStatNum02().toString());
//			weekList.add("周日");
//			orderCountList.add(dbOrderAndPerson.get(7).getStatNum01()==null?"0":dbOrderAndPerson.get(7).getStatNum01().toString());
//			personCountList.add(dbOrderAndPerson.get(7).getStatNum02()==null?"0":dbOrderAndPerson.get(7).getStatNum02().toString());
//			// 返回
//			Map<String, Object> resultMap = Maps.newHashMap();
//			resultMap.put("data", weekList);
//			resultMap.put("orderCountList", orderCountList);
//			resultMap.put("personCountList", personCountList);
//			response.setResult(resultMap);
//			return response;
//        } catch (Exception e) {
//            log.error("get.favorite.top.error", Throwables.getStackTraceAsString(e));
//            response.setError("get.favorite.top.error");
//            return response;
//        }
//    }

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

//	/**
//	 * 查询热销产品
//	 *
//	 * @return
//	 */
//	@Override
//	public Response<List<Map<String, Object>>> findSellTop() {
//
//		Response<List<Map<String, Object>>> result = new Response<List<Map<String, Object>>>();
//
//		try {
//			// 订单商品的list
//			List<OrderSubModel> orderGoodsList;
//
//			// List<OrderSubModel> orderGoodsTop4List = new ArrayList<OrderSubModel>();
//			List<Map<String, Object>> listRecommendGoods = Lists.newArrayList();
//
//			// 订单的list
//			List<OrderSubModel> orderSubList;
//
//			Map<String, Object> topSellParam = Maps.newHashMap();
//
//			// 查询所有成交的订单orderSubList
//			orderSubList = orderSubDao.findSuccess(topSellParam);
//
//			if (null == orderSubList || orderSubList.size() == 0) {
//				orderSubList = Lists.newArrayList();
//			}
//			// 用orderSubList成交的订单来查询交易最多的商品TOP10
//			topSellParam.put("subList",orderSubList);
//			orderGoodsList = orderSubDao.findTopOrder(topSellParam);
//
//			if(null == orderGoodsList){
//				result.setError("get.favorite.top.empty");
//				return result;
//			}
//			//:如果商品都下架会导致显示数量不对
//			for (int i = 0; i < orderGoodsList.size(); i++) {
//				if(listRecommendGoods.size() > 3){// 只显示前四条
//					break;
//				}
//				if(!Strings.isNullOrEmpty(orderGoodsList.get(i).getGoodsId())){
//					Map<String, Object> itemGoodsMap = goodsDetailService
//							.findItemInfoByItemCode(orderGoodsList.get(i).getGoodsId());
//					if(itemGoodsMap!=null){
//						listRecommendGoods.add(itemGoodsMap);
//					}
//				}
//			}
//
//			result.setResult(listRecommendGoods);
//			return result;
//		} catch (Exception e) {
//			log.error("get.favorite.top.error,error code {}", Throwables.getStackTraceAsString(e));
//			result.setError("get.favorite.top.error");
//			return result;
//		}
//	}


	/**
	 * 查询供应商首页数据（积分商城）
	 * @param user 用户信息
	 * @return 查询结果
	 *
	 * geshuo 20160816
	 */
	@Override
	public Response<Map<String, Object>> findPointsData(User user) {
		// 实例化返回Response
		Response<Map<String, Object>> response = Response.newResponse();
		// 返回Response有两个LIST，需要用Map装一下
		Map<String, Object> paramMap = Maps.newHashMap();
		// 实例化收藏的list
		List<GoodsDetailDto> goodsList;
		// 实例化订单商品的list
		List<OrderSubModel> orderGoodsList = Lists.newArrayList();
		// 实例化订单的list
		List<OrderSubModel> orderSubList;
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
			String vendorId = null;
			if(user!=null){
				vendorId = user.getVendorId();
			}
			if (StringUtils.isNotEmpty(vendorId) && !equal(vendorId, "0")) {
				// 把订单检索的条件写上
				topOrderParam.put("vendorId", vendorId);
			}
			// 查询所有成交的订单orderSubList
			topOrderParam.put("mallType",2);
			orderSubList = orderSubDao.findSuccess(topOrderParam);
			// 用orderSubList成交的订单来查询交易最多的商品TOP10
			if (orderSubList != null && orderSubList.size() > 0) {
				topOrderParam.put("subList",orderSubList);
				orderGoodsList = orderSubDao.findTopOrder(topOrderParam);
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
}
