/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.PromotionPayWayDao;
import cn.com.cgbchina.item.manager.PromotionPayWayManager;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.model.PromotionPayWayModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Preconditions.checkArgument;
import static com.spirit.util.Arguments.notNull;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/7/26.
 */

@Service
@Slf4j
public class PromotionPayWayServiceImpl implements PromotionPayWayService {

	@Resource
	private GoodsPayWayService goodsPayWayService;
	@Resource
	private PromotionPayWayManager promotionPayWayManager;
	@Resource
	private PromotionPayWayDao promotionPayWayDao;

	@Override
	public Response<Integer> createPromotionPayWay(List<PromotionPayWayModel> oldModelList, User user) {
		Response<Integer> result = new Response<>();
		List<PromotionPayWayModel> promotionPayWayList = Lists.newArrayList();
		List<String> itemCodes = Lists.newArrayList();
		try {
			for(PromotionPayWayModel oldModel:oldModelList){
				checkArgument(StringUtils.isNotBlank(oldModel.getGoodsId()), "item.code.not.be.null");// 入参：单品code
				checkArgument(StringUtils.isNotBlank(oldModel.getPromId()), "promo.id.not.be.null");// 入参：活动id
				checkArgument(notNull(oldModel.getPromType()), "prom.type.not.be.null");// 入参：活动类型
				checkArgument(notNull(oldModel.getGoodsPrice()), "goods.price.not.be.null");// 入参：活动价格
				//传入单品编码list
				itemCodes.add(oldModel.getGoodsId());
				}
			// 根据单品编码list，查询tbl_goods_payWay表中的支付方式list
			List<TblGoodsPaywayModel> goodsPaywayList = Lists.newArrayList();
			Response<List<TblGoodsPaywayModel>> response = goodsPayWayService.findGoodsPayWayByCodes(itemCodes);
			if(response.isSuccess()){
				goodsPaywayList = response.getResult();
			}
			if (!goodsPaywayList.isEmpty()) {
				// 将活动价格以及每期的价格插入到表中
				PromotionPayWayModel newPromotionPayWayModel = null;
				for(PromotionPayWayModel oldModel:oldModelList){//传入数据
					BigDecimal activityPrice = oldModel.getGoodsPrice();// 活动价格
					for(TblGoodsPaywayModel goodsPaywayModel:goodsPaywayList){//商品支付方式表数据
						//如果两个单品编码相同，则copy到新的Model中
						if(goodsPaywayModel.getGoodsId().equals(oldModel.getGoodsId())){
							newPromotionPayWayModel = new PromotionPayWayModel();
							BeanMapper.copy(goodsPaywayModel, newPromotionPayWayModel);
							newPromotionPayWayModel.setPromId(oldModel.getPromId());// 活动id
							newPromotionPayWayModel.setPromType(oldModel.getPromType());// 活动类型
							newPromotionPayWayModel.setGoodsPrice(oldModel.getGoodsPrice());// 活动价格
							BigDecimal perStage=activityPrice.divide(BigDecimal.valueOf(goodsPaywayModel.getStagesCode()),2,BigDecimal.ROUND_HALF_UP);// 计算每期价格
							newPromotionPayWayModel.setPerStage(perStage);// 每期价格
							newPromotionPayWayModel.setCreateOper(user.getId());// 创建人
							promotionPayWayList.add(newPromotionPayWayModel);
						}
					}
				}
				// 批量插入
				Integer count = promotionPayWayManager.createPromotionPayWay(promotionPayWayList);
				result.setResult(count);
			} else {
				log.error("goods.pay.way.list.is.null{}", promotionPayWayList);
				result.setError("goods.pay.way.list.is.null");
			}
		} catch (IllegalArgumentException e) {
			result.setError(e.getMessage());
		} catch (Exception e) {
			log.error("insert.promotion.pay.way.error{}", Throwables.getStackTraceAsString(e));
			result.setError("insert.promotion.pay.way.error");
		}
		return result;
	}

	/**
	 * 查询支付方式（商品详情页使用）
	 */
	public Response<List<PromotionPayWayModel>> findPromotionByItemCode(String itemCode, Integer id) {
		Response<List<PromotionPayWayModel>> response = new Response<>();
		try {
			List<PromotionPayWayModel> tblGoodsPaywayList = promotionPayWayDao.findInfoByItemCode(itemCode, id);
			response.setResult(tblGoodsPaywayList);
		} catch (Exception e) {
			log.error("tblPromotionPaywayModel query error", e);
			response.setError("tblPromotionPaywayModel.query.error");
		}
		return response;
	}

	/**
	 * 返回支付方式信息
	 *
	 * @return
	 */
	@Override
	public Response<PromotionPayWayModel> findPomotionPayWayInfo(String goodsPaywayId) {
		Response<PromotionPayWayModel> response = new Response<>();
		try {
			PromotionPayWayModel promotionPayWayModel = promotionPayWayDao.findById(goodsPaywayId);
			response.setResult(promotionPayWayModel);
			return response;
		} catch (Exception e) {
			log.error("tblGoodsPaywayModel query error", Throwables.getStackTraceAsString(e));
			response.setError("tblGoodsPaywayModel.query.error");
			return response;
		}
	}

	/**
	 * 返回支付方式信息
	 * by goodsPaywayId promotionId
	 *
	 * @return
	 */
	public Response<PromotionPayWayModel> findPomotionPayWayInfoByParam(Map<String,Object> param) {
		Response<PromotionPayWayModel> response = new Response<PromotionPayWayModel>();
		try {
			PromotionPayWayModel promotionPayWayModel = promotionPayWayDao.findByPromotionMap(param);
			response.setResult(promotionPayWayModel);
			return response;
		} catch (Exception e) {
			log.error("tblGoodsPaywayModel query error", e);
			response.setError("tblGoodsPaywayModel.query.error");
			return response;
		}
	}
	@Override
	public Response<PromotionPayWayModel> findMaxPromotionPayway(String itemCode, String promId) {
		Response<PromotionPayWayModel> response = Response.newResponse();
		try {
			Map<String, Object> params = Maps.newHashMap();
			params.put("itemCode",itemCode);
			params.put("promId",promId);
			PromotionPayWayModel promotionPayWayModel = promotionPayWayDao.findMaxPromotionPayway(params);
			response.setResult(promotionPayWayModel);
		} catch (Exception e) {
			log.error("findMaxPromotionPayway.",e);
			response.setError("findMaxGoodsPayway.query.error");
		}
		return response;
	}

	@Override
	public Response<List<PromotionPayWayModel>> findPromotionPayWayByGoodsIdAndPromType(String goodsId, String promType) {
		Response<List<PromotionPayWayModel>> response = Response.newResponse();
		try {
			// 查询商品活动支付方式
			List<PromotionPayWayModel> promotionPaywayModels = promotionPayWayDao.findByGoodsIdAndPromType(goodsId,promType);
			if (promotionPaywayModels != null && promotionPaywayModels.size() > 0) {
				response.setResult(promotionPaywayModels);
			}
		}catch (Exception e) {
			log.error("【findPromotionPayWayByGoodsId.error】MAL313 查询商品活动支付方式 失败",e);
			response.setError("RestPromotionServiceImpl.findPromotionPayWayByGoodsId.error");
		}
		return response;
	}
}
