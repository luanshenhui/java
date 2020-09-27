/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.SpecialPointScaleDao;
import cn.com.cgbchina.item.dto.SpecialPointsRateDto;
import cn.com.cgbchina.item.manager.SpecialPointsRateManager;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.PointPoolModel;
import cn.com.cgbchina.item.model.SpecialPointScaleModel;
import com.google.common.base.Function;
import com.google.common.base.Joiner;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.category.model.BackCategory;
import com.spirit.category.model.Spu;
import com.spirit.category.service.BackCategoryHierarchy;
import com.spirit.category.service.SpuService;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.search.Pair;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Preconditions.checkNotNull;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 2016/05/31
 */

@Service
@Slf4j
public class SpecialPointsRateServiceImpl implements SpecialPointsRateService {
	@Resource
	private SpecialPointScaleDao specialPointScaleDao;
	@Resource
	private SpecialPointsRateManager specialPointsRateManager;
	@Resource
	private GoodsService goodsService;
	@Resource
	private PointsPoolService pointsPoolService;
	@Resource
	private SpuService spuService;
	@Resource
	private BackCategoryHierarchy bch;

	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();


	/**
	 * 特殊积分倍率查询
	 *
	 * @param pageNo
	 * @param size
	 * @return
	 */
	@Override
	public Response<Pager<SpecialPointScaleModel>> findAll(Integer pageNo, Integer size) {
		Response<Pager<SpecialPointScaleModel>> response = new Response<Pager<SpecialPointScaleModel>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> paramMap = Maps.newHashMap();
		try {
			Pager<SpecialPointScaleModel> pager = specialPointScaleDao.findByPage(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());

			if (pager.getTotal() > 0) {
				List<SpecialPointScaleModel> data = pager.getData();
				for(SpecialPointScaleModel model:data){
					//如果type是2，则取三级类目id，到redis中查找各级名称
					if("2".equals(model.getType())){
						String[] bcIds = model.getTypeId().split(">");
						Long backCategory3Id = Long.parseLong(bcIds[bcIds.length-1]);
						List<BackCategory> bcList = bch.ancestorsOf(backCategory3Id);
						List<String> typeValList = Lists.newArrayList();
						for(int i = 1;i<bcList.size();i++){
							typeValList.add(bcList.get(i).getName());
						}
						String typeVal = Joiner.on(">").join(typeValList);
						model.setTypeVal(typeVal);
					}
				}
				response.setResult(new Pager<SpecialPointScaleModel>(pager.getTotal(), data));
			}else {
				response.setResult(new Pager<SpecialPointScaleModel>(0L, Collections.<SpecialPointScaleModel> emptyList()));
			}
			return response;
		} catch (Exception e) {
			log.error("reject goods query error ", Throwables.getStackTraceAsString(e));
			response.setError("reject.goods.query.error");
			return response;
		}
	}

	/**
	 * 特殊积分倍率删除
	 *
	 * @param specialPointScaleModel
	 * @return
	 */
	@Override
	public Response<Boolean> delete(SpecialPointScaleModel specialPointScaleModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			Boolean result = specialPointsRateManager.delete(specialPointScaleModel);
			if (!result) {
				response.setError("delete.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("delete.defaultserach.error", Throwables.getStackTraceAsString(e));
			response.setError("delete.error");
			return response;
		}
	}

	/**
	 * 批量删除
	 *
	 * @param deteleAllSpecial
	 * @return
	 */
	public Response<Integer> updateAllRejectGoods(List<Long> deteleAllSpecial) {
		Response<Integer> response = new Response<Integer>();
		try {
			checkNotNull(deteleAllSpecial, "deteleAllSpecial is Null");
			Map<String, Object> paramMap = Maps.newHashMap();
			paramMap.put("idList", deteleAllSpecial);
			// 删除操作 批量删除
			Integer count = specialPointsRateManager.updateAllRejectGoods(paramMap);
			if (count > 0) {
				response.setResult(count);
				return response;
			} else {
				response.setError("detele.all.special.error");
				return response;
			}
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.info("detele all special error", Throwables.getStackTraceAsString(e));
			response.setError("detele.all.special.error");
			return response;
		}
	}

	/**
	 * 特殊积分倍率新增
	 *
	 * @param specialPointScaleModel
	 * @return
	 */
	@Override
	public Response<Boolean> create(SpecialPointScaleModel specialPointScaleModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// json解串
			SpecialPointsRateDto specialPointScaleModelJson = jsonMapper.fromJson(specialPointScaleModel.getTypeVal(),
					SpecialPointsRateDto.class);
			// 循环取出Json 向数据库插入
			Boolean result = false;
			for (SpecialPointScaleModel model : specialPointScaleModelJson.getSpecialPointScaleModelList()) {
				model.setScale(specialPointScaleModel.getScale());// 倍率
				model.setCreateOper(specialPointScaleModel.getCreateOper());// 创建人
				model.setType(specialPointScaleModel.getType());// 类型
				model.setDisplayFlag(specialPointScaleModel.getDisplayFlag());//是否只显示全积分（0 否，1 是）
				// 根据所选类型值是否存在确定是更新还是新增，存在--更新 不存在--新增
				if (typeValCheck(model.getType(), model.getTypeId()).getResult() == true) {
					result = specialPointsRateManager.create(model);
				} else {
					result = specialPointsRateManager.updateByTypeId(model);
				}
				if (!result) {
					response.setError("insert.error");
					return response;
				}
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("insert error", Throwables.getStackTraceAsString(e));
			response.setError("insert.error");
			return response;
		}
	}

	/**
	 * 特殊积分倍率更新
	 *
	 * @param specialPointScaleModel
	 * @return
	 */
	@Override
	public Response<Boolean> update(SpecialPointScaleModel specialPointScaleModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 获取ID
			Boolean result = specialPointsRateManager.update(specialPointScaleModel);
			if (!result) {
				response.setError("update.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("update error", Throwables.getStackTraceAsString(e));
			response.setError("update.error");
			return response;
		}

	}

	/**
	 * 类型值唯一性校验
	 *
	 * @param type
	 * @param typeId
	 * @return
	 */
	private Response<Boolean> typeValCheck(String type, String typeId) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			if (StringUtils.isNotEmpty(type) && StringUtils.isNotEmpty(typeId)) {
				SpecialPointScaleModel specialPointScaleModel = new SpecialPointScaleModel();
				specialPointScaleModel.setType(type);
				specialPointScaleModel.setTypeId(typeId);
				List<SpecialPointScaleModel> result = specialPointScaleDao.typeValCheck(specialPointScaleModel);
				// 如果已经存在，查询结果大于0,进行更新；否则进行新增
				if (result.size() > 0) {
					response.setResult(false);
				} else {
					response.setResult(true);
				}
			}
			return response;
		} catch (Exception e) {
			log.error("check error", Throwables.getStackTraceAsString(e));
			response.setError("pointPool.check.error");
			return response;
		}
	}

	/**
	 * 计算最佳倍率
	 * 
	 * @param goodsModel
	 * @return
	 */
	@Override
	public Response<BigDecimal> calculateBestRate(GoodsModel goodsModel) {
		// 优先级：商品->后台类目->品牌->供应商->积分池
		Response<BigDecimal> response = new Response<>();
		BigDecimal bestRate = new BigDecimal(0);
		try {
			SpecialPointScaleModel specialPointScaleModel = new SpecialPointScaleModel();
			// 计算后台类目对应倍率--对应type为2
			specialPointScaleModel.setType("2");
			Response<Spu> spuR = spuService.findById(goodsModel.getProductId());
			Long cateGoryId = spuR.getResult().getCategoryId();
			List<BackCategory> backCategoriesR = bch.ancestorsOf(cateGoryId);
			List<Pair> categoryList = Lists.newArrayListWithCapacity(backCategoriesR.size());
			for(int i=1;i<backCategoriesR.size();i++){
				categoryList.add(new Pair(backCategoriesR.get(i).getName(), backCategoriesR.get(i).getId()));
			}
			List<String> ids = Lists.transform(categoryList, new Function<Pair, String>() {
						@NotNull
						@Override
						public String apply(@NotNull Pair input) {
							return input.getId().toString();
						}
					});

			String categoryUnion = Joiner.on(">").skipNulls().join(ids);
			specialPointScaleModel.setTypeId(categoryUnion);

			List<SpecialPointScaleModel> specialList = specialPointScaleDao.typeValCheck(specialPointScaleModel);
			if (specialList != null && specialList.size() > 0) {
				bestRate = specialList.get(0).getScale();
				response.setResult(bestRate);
			}else{
				// 计算品牌对应倍率--对应type为1
				specialPointScaleModel = new SpecialPointScaleModel();
				specialPointScaleModel.setType("1");
				specialPointScaleModel.setTypeId(goodsModel.getGoodsBrandId().toString());
				specialList = specialPointScaleDao.typeValCheck(specialPointScaleModel);
				if (specialList != null && specialList.size() > 0){
					bestRate = specialList.get(0).getScale();
					response.setResult(bestRate);
				}else {
					// 计算供应商对应倍率--对应type为0
					specialPointScaleModel = new SpecialPointScaleModel();
					specialPointScaleModel.setType("0");
					specialPointScaleModel.setTypeId(goodsModel.getVendorId());
					specialList = specialPointScaleDao.typeValCheck(specialPointScaleModel);
					if (specialList != null && specialList.size() > 0){
						bestRate = specialList.get(0).getScale();
						response.setResult(bestRate);
					}else {
						// 计算当月积分池对应倍率
						Response<PointPoolModel> poolResponse = pointsPoolService.getCurMonthInfo();
						if(poolResponse.isSuccess()){
							bestRate = poolResponse.getResult().getPointRate();
							response.setResult(bestRate);
						}
					}
				}
			}
		}catch (Exception e){
			log.error("calculate.best.rate.error{}", Throwables.getStackTraceAsString(e));
			response.setError("calculate.best.rate.error");
		}

		return response;
	}

	/**
	 * 查询商品是否显示全积分比例兑换
	 * @param goodsId 单品id
	 * @return 是否显示
	 *
	 * geshuo 20160816
	 */
	public Response<Boolean> findDisplayFlag(String goodsId){
		Response<Boolean> response = Response.newResponse();
		try{
			Map<String,Object> paramMap = Maps.newHashMap();
			paramMap.put("type",3);//商品的类型是3
			paramMap.put("typeId",goodsId);//商品id
			List<SpecialPointScaleModel> dataList = specialPointScaleDao.findByParams(paramMap);
			if(dataList == null || dataList.size() == 0){
				//没查询到数据
				response.setResult(Boolean.FALSE);
			} else {
				//有数据场合
				SpecialPointScaleModel scaleModel = dataList.get(0);//根据传递的参数，应该只能查到一个数据
				if(scaleModel.getDisplayFlag() == 1){
					response.setResult(Boolean.TRUE);//显示全积分
				} else {
					response.setResult(Boolean.FALSE);
				}
			}
		}catch(Exception e){
			log.error("SpecialPointsRateServiceImpl.findDisplayFlag.error Exception:{}", Throwables.getStackTraceAsString(e));
			response.setError("goods.find.display.error");
		}
		return response;
	}
}
