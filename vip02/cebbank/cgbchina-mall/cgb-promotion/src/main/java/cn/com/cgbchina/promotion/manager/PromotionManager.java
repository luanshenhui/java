package cn.com.cgbchina.promotion.manager;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.promotion.dao.PromotionDao;
import cn.com.cgbchina.promotion.dao.PromotionPeriodDao;
import cn.com.cgbchina.promotion.dao.PromotionRangeDao;
import cn.com.cgbchina.promotion.dao.PromotionVendorDao;
import cn.com.cgbchina.promotion.dto.PromotionRangeAddDto;
import cn.com.cgbchina.promotion.dto.RangeStatusDto;
import cn.com.cgbchina.promotion.model.PromotionModel;
import cn.com.cgbchina.promotion.model.PromotionPeriodModel;
import cn.com.cgbchina.promotion.model.PromotionRangeModel;
import cn.com.cgbchina.promotion.model.PromotionVendorModel;
import cn.com.cgbchina.user.service.VendorService;
import com.fasterxml.jackson.databind.JavaType;
import com.google.common.base.Function;
import com.google.common.collect.Collections2;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import org.apache.commons.collections.IteratorUtils;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.LocalDateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import java.util.*;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/6/13.
 */
@Component
@Transactional
public class PromotionManager {
	private final DateTimeFormatter dateTimeFormat = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
	private final JsonMapper jsonMapper = JsonMapper.JSON_ALWAYS_MAPPER;
	private JavaType listPromotionRange = JsonMapper.JSON_ALWAYS_MAPPER.createCollectionType(List.class,
			PromotionRangeAddDto.class);
	@Resource
	private PromotionDao promotionDao;
	@Resource
	private PromotionVendorDao promotionVendorDao;
	@Resource
	private PromotionRangeDao promotionRangeDao;
	@Resource
	private PromotionPeriodDao promotionPeriodDao;
	@Resource
	private ItemService itemService;
	@Resource
	private GoodsService goodsService;
	@Resource
	private VendorService vendorService;

	/**
	 * 新增活动（供应商用）
	 *
	 * @param promotionModel
	 * @param promotionVendorModel
	 * @param list
	 * @return
	 */
	public Boolean vendorAdd(PromotionModel promotionModel, PromotionVendorModel promotionVendorModel,
			List<PromotionRangeModel> list) {
		promotionDao.insert(promotionModel);
		promotionModel = promotionDao.vendorFindByCode(promotionModel.getPromCode());
		// 取得活动ID
		if (promotionModel != null) {
			promotionVendorModel.setPromotionId(promotionModel.getId());
		}
		for (PromotionRangeModel model : list) {
			model.setPromotionId(promotionModel.getId());
		}
		promotionVendorDao.insert(promotionVendorModel);
		promotionRangeDao.insertAllForVendor(list);
		return Boolean.TRUE;
	}

	/**
	 * 新增/修改活动商品（供应商用）
	 *
	 * @param list
	 * @return
	 */
	public Boolean addRangeForVendor(List<PromotionRangeModel> list) {
		try {
			if (list == null) {
				return Boolean.FALSE;
			}
			if (list.size() > 0) {
				for (PromotionRangeModel model : list) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("promotionId", model.getPromotionId());
					params.put("selectCode", model.getSelectCode());
					List<PromotionRangeModel> checkList = promotionRangeDao.findByParams(params);
					if (checkList != null && checkList.size() > 0) {
						model.setId(checkList.get(0).getId());
						promotionRangeDao.update(model);
					} else {
						promotionRangeDao.insert(model);
					}
				}
			}
		} catch (Exception e) {
			return Boolean.FALSE;
		}
		return Boolean.TRUE;
	}

	/**
	 * 供应商新增/修改活动 供应商新增活动
	 * 
	 * @param promotionModel
	 * @param range
	 */
	public void changePromotionForVendor(PromotionModel promotionModel, String range, String saveType) {
		// ID 不存在，新增
		if (promotionModel.getId() == null) {
			promotionDao.insertAdminPromotion(promotionModel);
		} else {
			promotionDao.updateAdminPromotion(promotionModel);
		}
		// 变更选品范围
		changePromotionRange(promotionModel, range, saveType);
		// 变更活动状态
		if(StringUtils.isNotEmpty(saveType) && "1".equals(saveType)) {
			Integer checkStatus = this.changeCheckStatus(promotionModel.getId());
			if (checkStatus != null) {
				Map<String, Object> rangeMap = new HashMap<String, Object>();
				rangeMap.put("id", promotionModel.getId());
				rangeMap.put("checkStatus", checkStatus);
				promotionDao.updateCheckStatusForVendor(rangeMap);
			}
		}
	}

	/**
	 * 供应商报名
	 * 
	 * @param promotionModel
	 * @param range
	 */
	public void changePromotionRange(PromotionModel promotionModel, String range, String saveType) {

		List<PromotionRangeAddDto> rangeModelList = jsonMapper.fromJson(range, listPromotionRange);

		PromotionRangeModel promotionRangeModel = null;
		List<PromotionRangeModel> insertRangers = Lists.newArrayList();
		List<PromotionRangeModel> updateRangers = Lists.newArrayList();
		List<String> dbRangeList = Lists.newArrayList();
		if (promotionModel.getId() != null) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("promotionId", promotionModel.getId());
			dbRangeList = promotionRangeDao.findSelectCodeByPromId(promotionModel.getId());
		}

		for (PromotionRangeAddDto promotionRangeAddDto : rangeModelList) {
			promotionRangeModel = new PromotionRangeModel();
			promotionRangeModel.setPromotionId(promotionModel.getId());
			promotionRangeModel.setRangeType(0);// 固定单品
			promotionRangeModel.setSelectCode(promotionRangeAddDto.getSelectCode().trim());
			promotionRangeModel.setSelectName(promotionRangeAddDto.getSelectName().trim());
			/* COMMENT OUT BY geshuo 20160709:　已经存在的单品不改变它的审核状态　----------*/
//			promotionRangeModel.setCheckStatus("0");// 0 待审核
			promotionRangeModel.setIsValid(1);// 正常状态
			promotionRangeModel.setSeq(promotionRangeAddDto.getSeq());// 排序
			promotionRangeModel.setPrice(promotionRangeAddDto.getPrice());// 售价
			promotionRangeModel.setStock(promotionRangeAddDto.getStock());// 活动商品数量
			promotionRangeModel.setCostBy(1);// 费用承担房 供应商
			promotionRangeModel.setCouponEnable(promotionRangeAddDto.getCouponEnable());// 是否使用优惠卷
			promotionRangeModel.setLevelMinCount(promotionRangeAddDto.getLevelMinCount());
			promotionRangeModel.setLevelPrice(promotionRangeAddDto.getLevelPrice());
			promotionRangeModel.setStartPrice(promotionRangeAddDto.getStartPrice());
			promotionRangeModel.setMinPrice(promotionRangeAddDto.getMinPrice());
			promotionRangeModel.setFeeRange(promotionRangeAddDto.getFeeRange());
			promotionRangeModel.setCreateOperType(Contants.PROMOTION_CREATE_OPER_TYPE_1);// 创建者类型

			// 通过单品id查询供商品 通过商品得到供应商id
			ItemModel itemModel = itemService.findById(promotionRangeAddDto.getSelectCode().trim());
			String goodsCode = itemModel.getGoodsCode();// 单品查商品id
			Response<GoodsModel> goodsModelResponse = goodsService.findById(goodsCode);// 商品id查商品
			GoodsModel goodsModel = goodsModelResponse.getResult();
			String vendorId = goodsModel.getVendorId();// 根据供应商id查询供应商名
			promotionRangeModel.setVendorId(vendorId);// 供应商id
			promotionRangeModel.setCreateOper(promotionModel.getCreateOper());
			promotionRangeModel.setModifyOper(promotionModel.getCreateOper());
			promotionRangeModel.setCreateTime(new Date());
			promotionRangeModel.setModifyTime(new Date());
			if (dbRangeList != null && dbRangeList.size() > 0) {
				// DB已存在，更新
				if (dbRangeList.contains(promotionRangeModel.getSelectCode())) {
					updateRangers.add(promotionRangeModel);
					dbRangeList.remove(promotionRangeModel.getSelectCode());
				} else {
					/* ADD START BY geshuo 20160709:　新添加的单品审核状态设置为 0-待审核 　----------*/
					promotionRangeModel.setCheckStatus("0");
					/* ADD END BY geshuo 20160709　-------------------------------------------------*/
					insertRangers.add(promotionRangeModel);
				}
			} else {
				/* ADD START BY geshuo 20160709:　新添加的单品审核状态设置为 0-待审核 　----------*/
				promotionRangeModel.setCheckStatus("0");
				/* ADD END BY geshuo 20160709　-------------------------------------------------*/
				insertRangers.add(promotionRangeModel);
			}
		}
		// 修改活动范围的情况下，画面也删除的选品，DB中对应数据无效化
		if (dbRangeList != null && dbRangeList.size() > 0) {
			for (String selectCode : dbRangeList) {
				promotionRangeModel = new PromotionRangeModel();
				promotionRangeModel.setPromotionId(promotionModel.getId());
				promotionRangeModel.setSelectCode(selectCode);
				promotionRangeModel.setIsValid(0);
				updateRangers.add(promotionRangeModel);
			}
		}
		// 批量插入
		if (insertRangers.size() > 0) {
			promotionRangeDao.insertAllForAdmin(insertRangers);
		}
		// 批量修
		if (updateRangers.size() > 0) {
			for (PromotionRangeModel model : updateRangers) {
				promotionRangeDao.updateByCodeAndPromId(model);
			}
		}

		/* change start by geshuo 20160709:保存时不需要再次修改状态 ------------------ */
		if(StringUtils.isNotEmpty(saveType) && "1".equals(saveType)){
			//saveType：0-保存  1-提交
			// 更改DB活动状态区分
			Integer checkStatus = this.changeCheckStatus(promotionModel.getId());
			if (checkStatus != null) {
				Map<String, Object> rangeMap = new HashMap<String, Object>();
				rangeMap.put("id", promotionModel.getId());
				rangeMap.put("checkStatus", checkStatus);
				promotionDao.updateCheckStatusForVendor(rangeMap);
			}
		}
		/* change end by geshuo 20160709 ------------------------------------------- */
	}

	/**
	 * 实时变更DB活动状态（仅 待复审、部分通过、全部通过、未通过复审）
	 * 
	 * @return
	 */
	private Integer changeCheckStatus(Integer promotionId) {
		Integer checkStatus = null;
		RangeStatusDto dto = promotionRangeDao.rangeStatus(promotionId);
		if (dto == null || (dto.getAll() != null && dto.getAll() == 0)) {
			return null;
		}
		// 全部待审核
		if (dto.getAll() == dto.getReady()) {
			//待复审
			checkStatus = Contants.PROMOTION_STATE_5;
		} else if (dto.getAll() == dto.getRefuse()) {
			//change by geshuo 20160709:未通过复审
			checkStatus = Contants.PROMOTION_STATE_6;
		} else if (dto.getAll() == dto.getAlready()) {
			//change by geshuo 20160709:复审通过
			checkStatus = Contants.PROMOTION_STATE_7;
		} else if (dto.getAll() > dto.getAlready() || dto.getAll() > dto.getRefuse()) {
			//change by geshuo 20160709:部分通过审核
			checkStatus = Contants.PROMOTION_STATE_8;
		}
		return checkStatus;
	}

	public void insertAdminPromotion(PromotionModel promotionModel, String range) {
		promotionDao.insertAdminPromotion(promotionModel);

		if (promotionModel.getPromType() == 10 || promotionModel.getPromType() == 20) {
			if (StringUtils.isNotEmpty(range)) {
				// 折扣和满减插入维护供应商表 如果range范围为空 不做处理 默认所有供应商有效
				String[] venderIds = range.split(",");//
				List<PromotionVendorModel> venders = Lists.newArrayList();
				PromotionVendorModel promotionVendorModel = null;

				for (String str : venderIds) {
					promotionVendorModel = new PromotionVendorModel();
					promotionVendorModel.setIsValid(1);
					promotionVendorModel.setPromotionId(promotionModel.getId());
					promotionVendorModel.setVendorId(str);
					venders.add(promotionVendorModel);
				}
				promotionVendorDao.insertAll(venders);
			}
		}
		if (promotionModel.getPromType() == 30 || promotionModel.getPromType() == 40
				|| promotionModel.getPromType() == 50) {
			List<PromotionRangeAddDto> rangeModelList = jsonMapper.fromJson(range, listPromotionRange);
			//
			PromotionRangeModel promotionRangeModel = null;
			List<PromotionRangeModel> rangers = Lists.newArrayList();
			for (PromotionRangeAddDto promotionRangeAddDto : rangeModelList) {
				promotionRangeModel = new PromotionRangeModel();

				promotionRangeModel.setPromotionId(promotionModel.getId());
				promotionRangeModel.setRangeType(0);// 写死 都是单品
				promotionRangeModel.setSelectCode(promotionRangeAddDto.getSelectCode().trim());
				promotionRangeModel.setSelectName(promotionRangeAddDto.getSelectName());
				promotionRangeModel.setCheckStatus("0");// 0 待审核
				promotionRangeModel.setIsValid(1);// 正常状态
				promotionRangeModel.setSeq(promotionRangeAddDto.getSeq());// 排序
				promotionRangeModel.setPrice(promotionRangeAddDto.getPrice());// 售价
				promotionRangeModel.setStock(promotionRangeAddDto.getStock());// 活动商品数量
				if (promotionModel.getPromType() == 40) {
					promotionRangeModel.setCostBy(1);// 费用承担房 团购的时候写死 承担方就是供应商 其他的可以选择
				} else {
					promotionRangeModel.setCostBy(promotionRangeAddDto.getCostBy());// 其他
				}
				promotionRangeModel.setCouponEnable(promotionRangeAddDto.getCouponEnable());// 是否使用优惠卷
				// promotionRangeModel.setLevelMinCount(promotionRangeAddDto.getLevelMinCount()); //参团人数此处不维护 商城会维护
				promotionRangeModel.setLevelPrice(promotionRangeAddDto.getLevelPrice());
				promotionRangeModel.setStartPrice(promotionRangeAddDto.getStartPrice());
				promotionRangeModel.setMinPrice(promotionRangeAddDto.getMinPrice());
				promotionRangeModel.setFeeRange(promotionRangeAddDto.getFeeRange());
				promotionRangeModel.setCreateOperType(promotionModel.getCreateOperType());// 创建者类型
				promotionRangeModel.setCreateOper(promotionModel.getCreateOper());
				// 通过单品id查询供商品 通过商品得到供应商id 查不到的话为Null
				ItemModel itemModel = itemService.findById(promotionRangeAddDto.getSelectCode().trim());
				if (itemModel == null) {
					throw new IllegalArgumentException("item.not.exist");
				}
				String goodsCode = itemModel.getGoodsCode();// 单品查商品id
				Response<GoodsModel> goodsModelResponse = goodsService.findById(goodsCode);// 商品id查商品
				GoodsModel goodsModel = goodsModelResponse.getResult();
				String vendorId = goodsModel.getVendorId();// 根据供应商id查询供应商名
				promotionRangeModel.setVendorId(vendorId);// 供应商id
				rangers.add(promotionRangeModel);
			}
			// 插入活动范围
			promotionRangeDao.insertAllForAdmin(rangers);

		}

	}

	public void updateAdminPromotion(final PromotionModel promotionModel, String range) {
		promotionDao.updateAdminPromotion(promotionModel);
		// 更新主要集中在商品的更新上 其他基本信息不变
		// 活动主更新已经在service中处理好 直接更新
		// 下面处理活动范围
		if (promotionModel.getPromType() == 10 || promotionModel.getPromType() == 20) {
			// 这种情况 range是供应商
			// 折扣和满减插入维护供应商表 如果range范围为空 不做处理 默认所有供应商有效
			List<String> venderIds = null;
			if ("".equals(range)) {
				venderIds = Collections.emptyList();
			} else {
				venderIds = Lists.newArrayList(range.split(","));
			}

			// 得到数据库中当前活动的所有供应商 跟编辑后的供应商结果做比较
			List<String> dumpVenderIds = promotionVendorDao.findVendorByPromotionId(promotionModel.getId());
			List<PromotionVendorModel> readyToDelete = Lists.newArrayList();
			List<PromotionVendorModel> readyToAdd = Lists.newArrayList();
			// 要插入数据库的
			for (String temp : venderIds) {
				if (!dumpVenderIds.contains(temp)) {
					PromotionVendorModel promotionVendorModel = new PromotionVendorModel();
					promotionVendorModel.setPromotionId(promotionModel.getId());
					promotionVendorModel.setVendorId(temp);
					promotionVendorModel.setIsValid(1);// 正常状态
					readyToAdd.add(promotionVendorModel);
				}
			}
			if (readyToAdd.size() != 0) {
				// 这是新增的
				promotionVendorDao.insertAll(readyToAdd);
			}

			// 要在数据库中删除的
			for (String temp : dumpVenderIds) {
				if (!venderIds.contains(temp)) {
					PromotionVendorModel promotionVendorModel = new PromotionVendorModel();
					promotionVendorModel.setVendorId(temp);
					promotionVendorModel.setPromotionId(promotionModel.getId());
					readyToDelete.add(promotionVendorModel);
				}

			}
			if (readyToDelete.size() != 0) {
				// 要删除掉的供应商
				promotionVendorDao.logicDelete(readyToDelete);
			}

		} else {
			// 这种情况 range是活动单品
			List<PromotionRangeAddDto> rangeModelList = JsonMapper.nonEmptyMapper().fromJson(range, listPromotionRange);

			// 得到当前已经在数据库中的当前活动的所有单品
			List<String> selectCodeByPromId = promotionRangeDao.findSelectCodeByPromId(promotionModel.getId());
			List<PromotionRangeAddDto> readyToAdd = Lists.newArrayList();
			List<PromotionRangeAddDto> readyToUpdate = Lists.newArrayList();

			for (PromotionRangeAddDto rangeAddDto : rangeModelList) {
				if (selectCodeByPromId.contains(rangeAddDto.getSelectCode())) {
					// 如果db中包含前台传过来这条单品 那么就是更新
					readyToUpdate.add(rangeAddDto);
					// 并从数据库中那个集合删掉要更新的 到最后剩下的就是要删除的
					selectCodeByPromId.remove(rangeAddDto.getSelectCode());
				} else {
					// 找不到的就是要新建的
					readyToAdd.add(rangeAddDto);
				}
			}
			final String userId = promotionModel.getModifyOper();

			// 得到三个集合
			// 待添加集合
			if (readyToAdd.size() > 0) {
				List<PromotionRangeModel> insertList = IteratorUtils.toList(
						Collections2.transform(readyToAdd, new Function<PromotionRangeAddDto, PromotionRangeModel>() {
							@Nullable
							@Override
							public PromotionRangeModel apply(@Nullable PromotionRangeAddDto input) {
								PromotionRangeModel promotionRangeModel = new PromotionRangeModel();
								BeanMapper.copy(input, promotionRangeModel);
								promotionRangeModel.setPromotionId(promotionModel.getId());
								promotionRangeModel.setCreateOper(userId);
								promotionRangeModel.setCreateOperType(0);// 写死 创建人类型为内管
								promotionRangeModel.setIsValid(1);// 单品类型 1正常
								promotionRangeModel.setCheckStatus("0");// 待审核
								promotionRangeModel.setRangeType(0);// 单品
								return promotionRangeModel;
							}
						}).iterator());
				promotionRangeDao.insertAllForAdmin(insertList);
			}
			// 待更新集合
			if (readyToUpdate.size() > 0) {
				List<PromotionRangeModel> updateList = IteratorUtils.toList((Collections2.transform(readyToUpdate,
						new Function<PromotionRangeAddDto, PromotionRangeModel>() {
							@Nullable
							@Override
							public PromotionRangeModel apply(@Nullable PromotionRangeAddDto input) {
								PromotionRangeModel promotionRangeModel = new PromotionRangeModel();
								BeanMapper.copy(input, promotionRangeModel);
								promotionRangeModel.setPromotionId(promotionModel.getId());
								promotionRangeModel.setModifyOper(userId);
								promotionRangeModel.setModifyOperType(0);// 写死都是内管

								return promotionRangeModel;
							}
						})).iterator());
				Map<String,Object> updateMap=Maps.newHashMap();
				updateMap.put("rangeList",updateList);
				promotionRangeDao.updateAllForAdmin(updateMap);
			}
			if (selectCodeByPromId.size() > 0) {
				// 待删除的
				Map<String, Object> delete = Maps.newHashMap();
				delete.put("promotionId", promotionModel.getId());
				delete.put("removeCode", selectCodeByPromId);
				promotionRangeDao.logicDelete(delete);
			}

		}

	}

	/**
	 * 更新审核状态
	 */
	public void updateCheckStatus(Integer id, User user, String auditLog, Integer checkStatus) {
		PromotionModel oldPromotion = promotionDao.findById(id);// 数据库中原有数据 主要用来处理审核履历
		String oldAuditLog = oldPromotion.getAuditLog();// 审核履历
		String checkAuditLog = "";
		// 生成本次的审核履历
		String newAuditLog = LocalDateTime.now().toString(dateTimeFormat);
		if (checkStatus == 3) {// 已提交(已审批通过) 3
			newAuditLog = newAuditLog + "通过初审";
		} else if (checkStatus == 4) {// 已提交(未审批通过)
			newAuditLog = newAuditLog + "未通过初审";
		}
		newAuditLog = newAuditLog + ",审核意见【" + auditLog + "】，【审核人:" + user.getName() + "】";
		if (StringUtils.isEmpty(oldAuditLog)) {
			// 以前的日志为空
			checkAuditLog = newAuditLog;
		} else {
			// 以前日志不为空 那么 旧日志新日志拼一起 中间用换行符拼接
			checkAuditLog = oldAuditLog + "</br>" + newAuditLog;
		}
		// 2016/04/08 10：30：20 通过初审，审核意见【】，【审核人：内审员1】

		Map<String, Object> checkMap = Maps.newHashMap();
		checkMap.put("auditOper", user.getId());// 审核人 审核日期在mapper中写死
		checkMap.put("id", id);
		checkMap.put("auditLog", checkAuditLog);
		checkMap.put("checkStatus", checkStatus);
		promotionDao.updateCheckStatus(checkMap);
		// 已提交 未通过审批 直接返回 不再处理循环任务的数据
		if (checkStatus == 4) {
			return;
		}
		// 如果审核状态通过了 需要把所有的活动循环数据刷新到活动时间表
		String loopType = oldPromotion.getLoopType();// 如果有循环数据 则说明活动范围为循环字段中的一些
		if (StringUtils.isEmpty(loopType)) {
			// 如果没有循环数据 则说明活动的范围就是整个活动开始时间和活动结束时间
			PromotionPeriodModel promotionPeriodModel = new PromotionPeriodModel();
			promotionPeriodModel.setPromotionId(oldPromotion.getId());
			promotionPeriodModel.setBeginDate(oldPromotion.getBeginDate());
			promotionPeriodModel.setEndDate(oldPromotion.getEndDate());
			promotionPeriodDao.insert(promotionPeriodModel);
		} else {
			// 处理循环数据为真实存在的活动
			String loopData = oldPromotion.getLoopData();
			Date loopBeginTime1 = oldPromotion.getLoopBeginTime1();
			Date loopEndTime1 = oldPromotion.getLoopEndTime1();

			Date loopBeginTime2 = oldPromotion.getLoopBeginTime2();
			Date loopEndTime2 = oldPromotion.getLoopEndTime2();

			List<String> loop = Arrays.asList(loopData.split(","));// 循环正式数据

			List<LocalDateTime> everyday = Lists.newArrayList();
			// 整个活动的开始时间
			LocalDateTime localBeginDateTime = LocalDateTime.fromDateFields(oldPromotion.getBeginDate());
			// 整个活动的结束时间
			LocalDateTime localEndDateTime = LocalDateTime.fromDateFields(oldPromotion.getEndDate());
			// 先把参加活动的所有天数搞出来 然后在判断这些天的时间段在没在当前活动范围内
			if ("d".equals(loopType)) {
				// 按天循环
				// LocalDateTime localBeginTime = LocalDateTime.fromDateFields(oldPromotion.getBeginDate());

				// 循环数据中，有多少被包含在这个区间段之内
				// 每日的创建开始与结束日期之间的所有
				// 如果开始时间
				while (localBeginDateTime.isBefore(localEndDateTime)) {
					everyday.add(localBeginDateTime);
					localBeginDateTime = localBeginDateTime.plusDays(1);
				}

			}
			if ("w".equals(loopType)) {
				// 按周循环

				// 循环数据中，有多少被包含在这个区间段之内
				// 每日的创建开始与结束日期之间的所有

				while (localBeginDateTime.isBefore(localEndDateTime)) {
					// 大区间内符合条件的天数加入集合
					if (loop.contains(Integer.valueOf(localBeginDateTime.getDayOfWeek()).toString())) {
						everyday.add(localBeginDateTime);
					}
					localBeginDateTime = localBeginDateTime.plusDays(1);
				}

			}
			if ("m".equals(loopType)) {
				// 按月循环
				// 循环数据中，有多少被包含在这个区间段之内
				// 每日的创建开始与结束日期之间的所有

				while (localBeginDateTime.isBefore(localEndDateTime)) {
					// 大区间内符合条件的天数加入集合
					if (loop.contains(Integer.valueOf(localBeginDateTime.getDayOfMonth()).toString())) {
						everyday.add(localBeginDateTime);
					}
					localBeginDateTime = localBeginDateTime.plusDays(1);
				}

			}
			List<PromotionPeriodModel> readyToInsert = Lists.newArrayList();
			// 拿到所有符合条件的天数 此时数据只有日期有用 时间都是开始时间后面的时间部分 下面处理这些日期 加上开始时间和结束时间
			PromotionPeriodModel promotionPeriodModel = null;
			for (LocalDateTime temp : everyday) {
				// 如果时间段一有数据
				if (loopBeginTime1 != null && loopEndTime1 != null) {

					LocalDateTime tempBeginTime = temp
							.withHourOfDay(LocalDateTime.fromDateFields(loopBeginTime1).getHourOfDay())
							.withMinuteOfHour(LocalDateTime.fromDateFields(loopBeginTime1).getMinuteOfHour())
							.withSecondOfMinute(LocalDateTime.fromDateFields(loopBeginTime1).getSecondOfMinute());
					LocalDateTime tempEndTime = temp
							.withHourOfDay(LocalDateTime.fromDateFields(loopEndTime1).getHourOfDay())
							.withMinuteOfHour(LocalDateTime.fromDateFields(loopEndTime1).getMinuteOfHour())
							.withSecondOfMinute(LocalDateTime.fromDateFields(loopEndTime1).getSecondOfMinute());
					if (tempEndTime.isBefore(localEndDateTime)) {
						// 循环有效 插
						promotionPeriodModel = new PromotionPeriodModel();
						promotionPeriodModel.setPromotionId(id);
						promotionPeriodModel.setBeginDate(tempBeginTime.toDate());
						promotionPeriodModel.setEndDate(tempEndTime.toDate());
						readyToInsert.add(promotionPeriodModel);
					}
				}
				// 如果时间段2有数据
				if (loopBeginTime2 != null && loopEndTime2 != null) {

					LocalDateTime tempBeginTime = temp
							.withHourOfDay(LocalDateTime.fromDateFields(loopBeginTime2).getHourOfDay())
							.withMinuteOfHour(LocalDateTime.fromDateFields(loopBeginTime2).getMinuteOfHour())
							.withSecondOfMinute(LocalDateTime.fromDateFields(loopBeginTime2).getSecondOfMinute());
					LocalDateTime tempEndTime = temp
							.withHourOfDay(LocalDateTime.fromDateFields(loopEndTime2).getHourOfDay())
							.withMinuteOfHour(LocalDateTime.fromDateFields(loopEndTime2).getMinuteOfHour())
							.withSecondOfMinute(LocalDateTime.fromDateFields(loopEndTime2).getSecondOfMinute());

					if (tempEndTime.isBefore(localEndDateTime)) {
						// 循环有效 插
						promotionPeriodModel = new PromotionPeriodModel();
						promotionPeriodModel.setPromotionId(id);
						promotionPeriodModel.setBeginDate(tempBeginTime.toDate());
						promotionPeriodModel.setEndDate(tempEndTime.toDate());
						readyToInsert.add(promotionPeriodModel);
					}
				}

			}
			// 插入所有活动数据 以后会有定时任务扫描他
			promotionPeriodDao.insertAll(readyToInsert);

		}

	}

	/**
	 * 复审通过 没有单品审核的情况，审核的是活动 要通过全通过，要拒绝全拒绝
	 * 
	 * @param promotionId
	 * @param auditLog
	 * @param status
	 * @param user
	 */
	public void doubleCheckPromotion(Integer promotionId, String auditLog, Integer status, User user) {
		// 当前活动的所有信息
		PromotionModel promotionModel = promotionDao.findById(promotionId);
		// 构建活动本身的更新信息
		Map<String, Object> promotionMap = Maps.newHashMap();
		promotionMap.put("id", promotionId);
		promotionMap.put("checkStatus", status);
		promotionMap.put("promotionId", promotionId);
		promotionMap.put("auditOper", user.getId());
		String log = null;
		if (status == 7) {// 通过复审
			// 通过
			log = LocalDateTime.now().toString(dateTimeFormat) + "通过审核，审核意见:【" + auditLog + "】," + "审核员:【"
					+ user.getName() + "】";
			promotionMap.put("auditLog", log);
		} else {
			// 拒绝
			log = promotionModel.getAuditLog() + LocalDateTime.now().toString(dateTimeFormat) + "拒绝审核，审核意见:【" + auditLog
					+ "】," + "审核员:【" + user.getName() + "】";
			promotionMap.put("auditLog", log);
		}

		// 添加一个活动的审核日志并置状态
		promotionDao.updateCheckStatus(promotionMap);
		Map<String, Object> rangeMap = Maps.newHashMap();
		rangeMap.put("promotionId", promotionId);
		if (status == 7) {
			// 通过复审就把他下面所有的单品状态变成审核成功
			// 并把该活动下关联的所有单品的审核

			rangeMap.put("checkStatus", "1");// 已通过
		} else {
			rangeMap.put("checkStatus", "2");// 已拒绝
		}
		rangeMap.put("auditOper", user.getId());
		promotionRangeDao.updateStatusByPromotion(rangeMap);

	}

	public void doubleCheckRange(Map<String, Object> rangeMap, Map<String, Object> promotionMap) {
		// 添加一个审核日志 无审核意见
		promotionRangeDao.updateCheckStatus(rangeMap);
		// 计算出主活动状态并改变
		promotionDao.offAndDelete(promotionMap);
	}

}
