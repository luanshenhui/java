package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dao.TblGoodsPaywayDao;
import cn.com.cgbchina.item.dto.GoodFullDto;
import cn.com.cgbchina.item.dto.GoodsDetailDto;
import cn.com.cgbchina.item.dto.GoodsPaywayDto;
import cn.com.cgbchina.item.dto.MakePriceDto;
import cn.com.cgbchina.item.manager.GoodsManager;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * @author
 * @version 1.0
 * @Since 2016/7/4.
 */
@Service
@Slf4j
public class GoodsPayWayServiceImpl implements GoodsPayWayService {

	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	@Resource
	private TblGoodsPaywayDao tblGoodsPayWayDao;
	@Resource
	private ItemDao itemDao;
	@Resource
	private GoodsManager goodsManager;
	@Resource
	private GoodsDao goodsDao;

	/**
	 * 返回支付方式信息
	 *
	 * @return
	 */
	@Override
	public Response<TblGoodsPaywayModel> findGoodsPayWayInfo(String goodsPaywayId) {
		Response<TblGoodsPaywayModel> response = new Response<TblGoodsPaywayModel>();
		try {
			TblGoodsPaywayModel goodsPaywayModel = tblGoodsPayWayDao.findById(goodsPaywayId);
			response.setResult(goodsPaywayModel);
		} catch (Exception e) {
			log.error("tblGoodsPaywayModel query error{}", Throwables.getStackTraceAsString(e));
			response.setError("tblGoodsPaywayModel.query.error");
		}
		return response;

	}

	/**
	 * 通过单品ＩＤ和分期数查询返回支付方式信息
	 *
	 * @return
	 */
	@Override
	public Response<TblGoodsPaywayModel> findByItemCodeAndStagesCode(Map<String, Object> params) {
		Response<TblGoodsPaywayModel> response = new Response<TblGoodsPaywayModel>();
		try {
			TblGoodsPaywayModel tblGoodsPaywayModel = tblGoodsPayWayDao.findByItemCodeAndStagesCode(params);
			response.setResult(tblGoodsPaywayModel);
			return response;
		} catch (Exception e) {
			log.error("tblGoodsPaywayModel query error{}", Throwables.getStackTraceAsString(e));
			response.setError("tblGoodsPaywayModel.query.error");
			return response;
		}
	}

	/**
	 * 查询商品支付方式表
	 *
	 * @param goodsCode
	 * @return
	 */
	@Override
	public Response<List<GoodsPaywayDto>> findGoodsPayway(String goodsCode) {
		Response<List<GoodsPaywayDto>> response = new Response<List<GoodsPaywayDto>>();
		List<GoodsPaywayDto> goodsPaywayDtoList = new ArrayList<GoodsPaywayDto>();
		try {
			List<ItemModel> itemModelList = itemDao.findItemListByGoodsCode(goodsCode);
			for (ItemModel itemModel : itemModelList) {
				if(itemModel != null){
					GoodsPaywayDto goodsPaywayDto = new GoodsPaywayDto();
					List<TblGoodsPaywayModel> goodsPaywayModel = tblGoodsPayWayDao.findByItemCode(itemModel.getCode());
					for (TblGoodsPaywayModel tblGoodsPaywayModel : goodsPaywayModel) {
						if(tblGoodsPaywayModel != null){
							if (Contants.MEMBER_LEVEL_JP_CODE.equals(tblGoodsPaywayModel.getMemberLevel())) {
								goodsPaywayDto.setGold(tblGoodsPaywayModel.getGoodsPoint());
							} else if (Contants.MEMBER_LEVEL_TJ_CODE.equals(tblGoodsPaywayModel.getMemberLevel())) {
								goodsPaywayDto.setTitanium(tblGoodsPaywayModel.getGoodsPoint());
							} else if (Contants.MEMBER_LEVEL_DJ_CODE.equals(tblGoodsPaywayModel.getMemberLevel())) {
								goodsPaywayDto.setTopLevel(tblGoodsPaywayModel.getGoodsPoint());
							} else if (Contants.MEMBER_LEVEL_VIP_CODE.equals(tblGoodsPaywayModel.getMemberLevel())) {
								goodsPaywayDto.setVip(tblGoodsPaywayModel.getGoodsPoint());
							} else if (Contants.MEMBER_LEVEL_BIRTH_CODE.equals(tblGoodsPaywayModel.getMemberLevel())) {
								goodsPaywayDto.setBirthday(tblGoodsPaywayModel.getGoodsPoint());
							} else {
								goodsPaywayDto.setPoints(tblGoodsPaywayModel.getGoodsPoint());
								goodsPaywayDto.setPrice(tblGoodsPaywayModel.getGoodsPrice());
							}
						}
					}
					goodsPaywayDto.setCalMoney(itemModel.getPrice());//采购价 -- 清算价
					goodsPaywayDto.setItemId(itemModel.getCode());
					goodsPaywayDtoList.add(goodsPaywayDto);
				}
			}
			response.setResult(goodsPaywayDtoList);
			return response;
		} catch (Exception e) {
			log.error("tblGoodsPaywayModel query error{}", Throwables.getStackTraceAsString(e));
			response.setError("tblGoodsPaywayModel.query.error");
			return response;
		}
	}

	/**
	 * 查询goods表临时字段内容  定价审核审核按钮查看用
	 *
	 * @param goodsCode
	 * @return
	 */
	public Response<List<GoodsPaywayDto>> findChangePriceInfo(String goodsCode){
		Response<List<GoodsPaywayDto>> response = Response.newResponse();
		try {
			// 定价或变价
			GoodsModel goodsModel = goodsDao.findById(goodsCode);
			String approveDifferent = goodsModel.getApproveDifferent();
			GoodsPaywayDto goodsPaywayDto = jsonMapper.fromJson(approveDifferent, GoodsPaywayDto.class);
			if(goodsPaywayDto!=null){
				response.setResult(goodsPaywayDto.getGoodsPaywayDtos());
			}
			return response;
		}catch (Exception e) {
			log.error("find.price.info.from.goods.error{}", Throwables.getStackTraceAsString(e));
			response.setError("find.price.info.from.goods.error");
			return response;
		}
	}

	/**
	 * 积分定价
	 *
	 * @param goodsCode
	 * @return
	 */
	@Override
	public Response<List<GoodsPaywayDto>> makePrice(String goodsCode, String stockParam, BigDecimal argumentTJ,
													BigDecimal argumentDJ, BigDecimal argumentVIP,
													BigDecimal argumentBirth, BigDecimal argumentPP,
													List<MakePriceDto> makePriceDtos){
		Response<List<GoodsPaywayDto>> response = Response.newResponse();
		List<GoodsPaywayDto> goodsPaywayDtoList = new ArrayList<GoodsPaywayDto>();
		try {
			List<ItemModel> itemModelList = itemDao.findItemListByGoodsCode(goodsCode);
			for (ItemModel itemModel : itemModelList) {
				GoodsPaywayDto goodsPaywayDto = new GoodsPaywayDto();
				Long jp = 0L;
				List<TblGoodsPaywayModel> goodsPaywayModel = tblGoodsPayWayDao.findGoodsPayway(itemModel.getCode());
				for (TblGoodsPaywayModel tblGoodsPaywayModel : goodsPaywayModel) {
					if(tblGoodsPaywayModel != null){
						String memberLevel = tblGoodsPaywayModel.getMemberLevel();
						if (Contants.MEMBER_LEVEL_JP_CODE.equals(memberLevel)) {
							jp = tblGoodsPaywayModel.getGoodsPoint();
							goodsPaywayDto.setGold(roundHalfUp(jp));
						}
						BigDecimal normalPoint = new BigDecimal(jp);
						// 尊越/臻享白金价
						Long zxPoint = roundHalfUp((normalPoint.multiply(argumentTJ).longValue()));
						goodsPaywayDto.setTitanium(zxPoint);

						// 顶级/增值白金价
						Long djPoint = roundHalfUp((normalPoint.multiply(argumentDJ).longValue()));
						goodsPaywayDto.setTopLevel(djPoint);

						// VIP
						Long vipPoint = roundHalfUp((normalPoint.multiply(argumentVIP).longValue()));
						goodsPaywayDto.setVip(vipPoint);

						// 生日
						Long birthPoint = (normalPoint.multiply(argumentBirth).setScale(0, BigDecimal.ROUND_HALF_UP)).longValue();
						goodsPaywayDto.setBirthday(birthPoint);

						// 积分+现金
						BigDecimal calMoney = tblGoodsPaywayModel.getCalMoney();
						goodsPaywayDto.setCalMoney(calMoney);

						// 采购价×（1+采购上浮系数）
            			BigDecimal purchase = calMoney.multiply(new BigDecimal(1).add(new BigDecimal(stockParam)));

						// 现金=采购价×（1+采购上浮系数）×现金比例 四舍五入取整
						BigDecimal cash = (purchase.multiply(argumentPP)).setScale(0, BigDecimal.ROUND_HALF_UP);
						goodsPaywayDto.setPrice(cash);

						// 积分 = 采购价*（1 + 采购上浮系数）*（1-现金比例）/金普卡积分系数
						BigDecimal argumentNormal = new BigDecimal(0);
						for(MakePriceDto model : makePriceDtos){
							if(model != null){
								BigDecimal downLimit = new BigDecimal(model.getDownLimit());
								BigDecimal upLimit =  new BigDecimal(model.getUpLimit());
								int down = purchase.compareTo(downLimit);
								int up = purchase.compareTo(upLimit);
								if(down == 1 || down == 0){
									if(up == -1){
										argumentNormal = model.getArgumentNormal();
									}
								}
							}
						}
						if(argumentNormal.compareTo(BigDecimal.ZERO) != 0){
							BigDecimal point = (purchase.multiply((new BigDecimal(1).subtract(argumentPP)))).
									divide(argumentNormal,10,BigDecimal.ROUND_HALF_UP);
							Long pointLong = roundHalfUp(point.longValue());
							goodsPaywayDto.setPoints(pointLong);
						}
					}
				}
				goodsPaywayDto.setItemId(itemModel.getCode());
				goodsPaywayDtoList.add(goodsPaywayDto);
			}
			response.setResult(goodsPaywayDtoList);
			return response;
		} catch (Exception e) {
			log.error("integral.pricing.error{}", Throwables.getStackTraceAsString(e));
			response.setError("integral.pricing.error");
			return response;
		}
	}

	/**
	 * 按千位四舍五入计算
	 *
	 * @return
	 */
	private Long roundHalfUp(Long num){
		BigDecimal bigDecimal = new BigDecimal(num);
		Long result = (((bigDecimal.divide(BigDecimal.valueOf(1000L))).setScale(0, BigDecimal.ROUND_HALF_UP))
				.multiply(BigDecimal.valueOf(1000L))).longValue();
		return result;
	}

	/**
	 * 保存礼品改价
	 *
	 * @param json, user
	 * @return
	 */
	@Override
	public Response<Boolean> saveChangePriced(String json, User user, String status){
		Response<Boolean> response = new Response<>();
		try {
			GoodsPaywayDto paywayDto = jsonMapper.fromJson(json, GoodsPaywayDto.class);
			GoodsModel goodsModel = new GoodsModel();
			goodsModel.setCode(paywayDto.getGoodsCode());
			goodsModel.setApproveDifferent(json);
			goodsModel.setApproveStatus(status);
			goodsModel.setModifyOper(user.getName());
			List<GoodsPaywayDto> goodsPaywayDtos = paywayDto.getGoodsPaywayDtos();
			for(GoodsPaywayDto goodsPaywayDto:goodsPaywayDtos){
				if (goodsPaywayDto.getPoints() != null) {
					// 判断金普卡在10000以内，不需要有积分+现金这个价格
					if (goodsPaywayDto.getGold().compareTo(new Long(10000)) < 0) {
						response.setError("price.less.then.ten.thousand.can.not.cash.and.price.error");
						return response;
					}
				}
			}
			goodsManager.update(goodsModel, Collections.<ItemModel>emptyList());
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("save.change.price.error{}", Throwables.getStackTraceAsString(e));
			response.setError("save.change.price.error");
		}
		return response;
	}

	@Override
	public Response<Integer> updatePayWayMemberLevel(List<TblGoodsPaywayModel> tblGoodsPaywayModelList) {
		Response<Integer> response = new Response<Integer>();
		try {
			Integer result = 0;
			for (TblGoodsPaywayModel tblGoodsPaywayModel : tblGoodsPaywayModelList) {
				//result = presentManager.updatePayWayMemberLevel(tblGoodsPaywayModel);
			}
			response.setResult(result);
			return response;
		} catch (Exception e) {
			log.error("tblGoodsPaywayModel query error{}", Throwables.getStackTraceAsString(e));
			response.setError("tblGoodsPaywayModel.query.error");
			return response;
		}

	}

	@Override
	public Response<List<TblGoodsPaywayModel>> findInfoByItemCode(String itemCode) {
		Response<List<TblGoodsPaywayModel>> response = new Response<>();
		try {
			List<TblGoodsPaywayModel> tblGoodsPaywayList = tblGoodsPayWayDao.findInfoByItemCode(itemCode);
			response.setResult(tblGoodsPaywayList);
		} catch (Exception e) {
			response.setError("tblGoodsPaywayModel.query.error");
			return response;
		}
		return response;
	}

	@Override
	public Response<TblGoodsPaywayModel> findMaxGoodsPayway(String itemCode) {
		Response<TblGoodsPaywayModel> response = Response.newResponse();
		try {
			TblGoodsPaywayModel tblGoodsPaywayModel = tblGoodsPayWayDao.findMaxGoodsPayway(itemCode);
			response.setResult(tblGoodsPaywayModel);
		} catch (Exception e) {
			log.error("查找商品最高分期数失败{}",Throwables.getStackTraceAsString(e));
			response.setError("findMaxGoodsPayway.query.error");
		}
		return response;
	}

	@Override
	public Response<List<TblGoodsPaywayModel>> findGoodsPayWayByCodes(List<String> itemCodes){
		Response<List<TblGoodsPaywayModel>> response = Response.newResponse();
		try {
			List<TblGoodsPaywayModel> paywayList = tblGoodsPayWayDao.findByGoodsIds(itemCodes);
			response.setResult(paywayList);
		}catch (Exception e){
			log.error("find.goods.pay.way.by.item.code.list.error{}", Throwables.getStackTraceAsString(e));
			response.setError("find.goods.pay.way.by.item.code.list.error");
		}
		return response;
	}
	/**
	 * 通过单品ID和是否待复核查询(分期方式代码降序)
	 * @param itemCode
	 * @return
	 */
	@Override
	public Response<List<TblGoodsPaywayModel>> findGoodsPayWayInfoList(String itemCode) {
		Response<List<TblGoodsPaywayModel>> response = new Response<>();
		try {
			List<TblGoodsPaywayModel> tblGoodsPaywayList = tblGoodsPayWayDao.findByGoodsPaywayInfo(itemCode);
			response.setResult(tblGoodsPaywayList);
		} catch (Exception e) {
			response.setError("tblGoodsPaywayModel.query.error");
			return response;
		}
		return response;
	}

	/**
	 * 通过单品ID和是否待复核查询(会员等级升序)
	 * @param itemCode
	 * @return
	 */
	@Override
	public Response<List<TblGoodsPaywayModel>> findGoodsPayWayInfoJFList(String itemCode) {
		Response<List<TblGoodsPaywayModel>> response = new Response<>();
		try {
			List<TblGoodsPaywayModel> tblGoodsPaywayList = tblGoodsPayWayDao.findByGoodsPaywayInfoJF(itemCode);
			response.setResult(tblGoodsPaywayList);
		} catch (Exception e) {
			log.error("通过单品ID和是否待复核查询{}",Throwables.getStackTraceAsString(e));
			response.setError("tblGoodsPaywayModel.query.error");
		}
		return response;
	}

	@Override
	public Response<List<TblGoodsPaywayModel>> findByGoodsIdAndMemberLevel(Map<String, Object> params) {
		Response<List<TblGoodsPaywayModel>> response = new Response<>();
		try {
			List<TblGoodsPaywayModel> tblGoodsPaywayList = tblGoodsPayWayDao.findByGoodsIdAndMemberLevel(params);
			response.setResult(tblGoodsPaywayList);
		} catch (Exception e) {
			response.setError("tblGoodsPaywayModel.query.error");
			return response;
		}
		return response;
	}

	@Override
	public Response<List<TblGoodsPaywayModel>> findByGoodsPayWayIdList(List<String> goodsPayWayIdList) {
		Response<List<TblGoodsPaywayModel>> response = Response.newResponse();
		try {
			if (goodsPayWayIdList==null||goodsPayWayIdList.isEmpty()){
				log.error("findByGoodsPayWayIdList goodsPayWayIdList be empty");
				response.setError("findByGoodsPayWayIdList.goodsPayWayIdList.empty");
				return response;
			}
			List<TblGoodsPaywayModel>tblGoodsPayWayModelList=tblGoodsPayWayDao.findByGoodsPayWayIdList(goodsPayWayIdList);
			response.setResult(tblGoodsPayWayModelList);
			return response;
		} catch (Exception e) {
			log.error("findByGoodsPayWayIdList query error{}", Throwables.getStackTraceAsString(e));
			response.setError("findByGoodsPayWayIdList.query.error");
			return response;
		}
	}

	/**
	 * 插入商品支付方式表
	 *
	 * @param tblGoodsPaywayModelList
	 * @return
	 */
	@Override
	public Response<Integer> createPayWayMemberLevel(List<TblGoodsPaywayModel> tblGoodsPaywayModelList) {
		Response<Integer> response = new Response<Integer>();
		try {
			Integer result = 0;
			// 批量插入
			if(tblGoodsPaywayModelList!=null && tblGoodsPaywayModelList.size()!=0){
				//presentManager.insertAllPayWay(tblGoodsPaywayModelList);
			}
			response.setResult(result);
			return response;
		} catch (Exception e) {
			log.error("tblGoodsPaywayModel query error{}", Throwables.getStackTraceAsString(e));
			response.setError("tblGoodsPaywayModel.query.error");
			return response;
		}
	}

	/**
	 * 根据参数查询支付方式
	 * @param paramMap 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160818
	 */
	@Override
	public Response<List<TblGoodsPaywayModel>> findGoodsPayWayByParams(Map<String,Object> paramMap){
		Response<List<TblGoodsPaywayModel>> response = Response.newResponse();
		try {
			//执行查询
			List<TblGoodsPaywayModel> dataList = tblGoodsPayWayDao.findGoodsPayWayByParams(paramMap);
			response.setResult(dataList);
			return response;
		} catch (Exception e) {
			log.error("GoodsPayWayServiceImpl.findGoodsPayWayByParams.error Exception:{}", Throwables.getStackTraceAsString(e));
			response.setError("GoodsPayWayServiceImpl.findGoodsPayWayByParams.error");
			return response;
		}
	}

	@Override
	public Response<List<TblGoodsPaywayModel>> findPaywayByGoodsIds(String goodsId) {
		Response<List<TblGoodsPaywayModel>> response = Response.newResponse();
		try {
			List<TblGoodsPaywayModel> tblGoodsPaywayList = tblGoodsPayWayDao.findPaywayByGoodsIds(goodsId);
			response.setResult(tblGoodsPaywayList);
		} catch (Exception e) {
			log.error("findPaywayByGoodsIds error {}",Throwables.getStackTraceAsString(e));
			response.setError("tblGoodsPaywayModel.query.error");
			return response;
		}
		return response;
	}

	@Override
	public Response<List<TblGoodsPaywayModel>> findJxpayway(String goodsId,String goodsPaywayId,String isMoney) {
		Response<List<TblGoodsPaywayModel>> response = Response.newResponse();
		try {
			List<TblGoodsPaywayModel> tblGoodsPaywayList = Lists.newArrayList();
			tblGoodsPaywayList = tblGoodsPayWayDao.findJxpayway(goodsId, goodsPaywayId, isMoney);
			response.setResult(tblGoodsPaywayList);
		} catch (Exception e) {
			log.error("findJxpayway{}",Throwables.getStackTraceAsString(e));
			response.setError("tblGoodsPaywayModel.query.error");
			return response;
		}
		return response;
	}

	/**
	 * 查询生日价支付信息
	 * 
	 * @param goodsId
	 * @return
	 */
	@Override
	public Response<TblGoodsPaywayModel> getBirthPayway(String goodsId) {
		Response<TblGoodsPaywayModel> response = Response.newResponse();
		try {
			TblGoodsPaywayModel tblGoodsPaywayModel = tblGoodsPayWayDao.getBirthPayway(goodsId);
			response.setResult(tblGoodsPaywayModel);
		} catch (Exception e) {
			log.error("获取生日价支付信息失败{}",Throwables.getStackTraceAsString(e));
			response.setError("tblGoodsPaywayModel.query.error");
		}
		return response;
	}

	@Override
	public Response<TblGoodsPaywayModel> findGoodsPayWayInfoById(String goodsPaywayId) {
		Response<TblGoodsPaywayModel> response = new Response<TblGoodsPaywayModel>();
		try {
			TblGoodsPaywayModel goodsPaywayModel = tblGoodsPayWayDao.findPwById(goodsPaywayId);
			response.setResult(goodsPaywayModel);
		} catch (Exception e) {
			log.error("tblGoodsPaywayModel query error{}", Throwables.getStackTraceAsString(e));
			response.setError("tblGoodsPaywayModel.query.error");
		}
		return response;
	}
}
