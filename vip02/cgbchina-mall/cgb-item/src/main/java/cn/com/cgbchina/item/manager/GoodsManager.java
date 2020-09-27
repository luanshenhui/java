package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.RandomHelper;
import cn.com.cgbchina.generator.IdEnum;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.dao.AuditLoggingDao;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.GoodsXidSeqModelDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dao.TblGoodsPaywayDao;
import cn.com.cgbchina.item.dto.*;
import cn.com.cgbchina.item.model.AuditLoggingModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.PointPoolModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.PointsPoolService;
import com.google.common.base.Function;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Objects.equal;

/**
 * Created by 陈乐 on 2016/4/23.
 */
@Component
@Transactional
@Slf4j
public class GoodsManager {

	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	@Resource
	private GoodsDao goodsDao;
	@Resource
	private ItemDao itemDao;
	@Resource
	private AuditLoggingDao auditLoggingDao;
	@Resource
	private IdGenarator idGenarator;
	@Resource
	private TblGoodsPaywayDao tblGoodsPaywayDao;
	@Resource
	private GoodsXidSeqModelDao goodsXidSeqModelDao;
	@Resource
	private PointsPoolService pointsPoolService;


	private static final String APPROVE_TYPE_2 = "2";// 审核类型标识:初审
	private static final String APPROVE_TYPE_3 = "3";// 审核类型标识:复审
	private static final String APPROVE_TYPE_4 = "4";// 审核类型标识:商品信息变更审核
	private static final String APPROVE_TYPE_5 = "5";// 审核类型标识:价格变更审核
	private static final String APPROVE_TYPE_6 = "6";// 审核类型标识:商品下架审核
	private static final String APPROVE_TYPE_8 = "8";// 审核类型标识:礼品定价变更审核
	private static final String APPROVE_RESULT_PASS = "pass";// 审核结果标识：通过
	private static final String PAYWAY_RULE_ID_0 = "0";// 商品支付方式表-商品应用规则id
	private static final String PAYWAY_STAGES_FLAG_CASH = "1";// 商品支付方式表--是否支持分期[现金]
	private static final String PAYWAY_STAGES_FLAG_POINT = "0";// 商品支付方式表--是否支持分期[积分]
	private static final String PAYWAY_STAGES_FLAG_INC = "0";// 商品支付方式表--是否支持分期[手续费]
	private static final String PAYWAY_IS_BIRTH_0 = "0";// 商品支付方式表--是否生日价
	private final Splitter splitter = Splitter.on(',').trimResults();


	public void createGoods(GoodsModel goodsModel, List<ItemModel> itemList,String channel) {
		// 获取goods表主键(商品编码)
		String goodsCode = idGenarator.id(IdEnum.GOODS, goodsModel.getVendorId());
		goodsModel.setCode(goodsCode);
		// 插入商品数据
		goodsDao.insert(goodsModel);
		for (ItemModel itemModel:itemList) {
			String itemCode = idGenarator.id(IdEnum.ITEM, goodsModel.getVendorId());
			itemModel.setCode(itemCode);// 主键
			switch (channel){
				case Contants.ORDERTYPEID_YG:
					String mid = idGenarator.itemMid();
					Boolean midIsExit = checkMid(mid);
					while (midIsExit){
						mid = idGenarator.itemMid();
						midIsExit = checkMid(mid);
					}
					itemModel.setMid(mid);
					itemModel.setOid(mid);
					break;
				case Contants.ORDERTYPEID_JF:
					Integer xid = goodsXidSeqModelDao.findGoodsXidSeq();
					RandomHelper.randomString(3);
					goodsXidSeqModelDao.updateGoodsXidSeq();
					itemModel.setXid(xid.toString());
					break;
			}
			itemModel.setGoodsCode(goodsCode);
			itemModel.setCreateOper(goodsModel.getCreateOper());
		}
		if(Contants.ORDERTYPEID_JF.equals(channel)){
			List<TblGoodsPaywayModel> paywayList = insertAllGoodsPayWayJF(itemList,goodsModel.getCreateOper());
			tblGoodsPaywayDao.insertAllPayWay(paywayList);
		}

		itemDao.insertBatch(itemList);
	}

	public void createGoodsImport(GoodsModel goodsModel, List<GiftsImportDto.GiftItemDto> itemDtoList, String vendorNo, String channel) {
		// 获取goods表主键(商品编码)
		String goodsCode = idGenarator.id(IdEnum.GOODS, goodsModel.getVendorId());
		goodsModel.setCode(goodsCode);
		// 插入商品数据
		goodsDao.insert(goodsModel);
		List<ItemModel> itemList = Lists.newArrayList();
		for (GiftsImportDto.GiftItemDto itemModel:itemDtoList) {
			String itemCode = idGenarator.id(IdEnum.ITEM, goodsModel.getVendorId());
			itemModel.setCode(itemCode);// 主键
			switch (channel){
				case Contants.ORDERTYPEID_YG:
					String mid = idGenarator.itemMid();
					Boolean midIsExit = checkMid(mid);
					while (midIsExit){
						mid = idGenarator.itemMid();
						midIsExit = checkMid(mid);
					}
					itemModel.setMid(mid);
					itemModel.setOid(mid);
					break;
				case Contants.ORDERTYPEID_JF:
					itemModel.setCardLevelId(goodsModel.getCardLevelId());
					Integer xid = goodsXidSeqModelDao.findGoodsXidSeq();
					RandomHelper.randomString(3);
					goodsXidSeqModelDao.updateGoodsXidSeq();
					itemModel.setXid(xid.toString());
					break;
			}
			itemModel.setGoodsCode(goodsCode);
			itemModel.setCreateOper(goodsModel.getCreateOper());
			itemList.add(itemModel);
		}
		if(Contants.ORDERTYPEID_JF.equals(channel)){
			List<TblGoodsPaywayModel> paywayList = insertAllGoodsPayWayJF(itemList,goodsModel.getCreateOper());
			tblGoodsPaywayDao.insertAllPayWay(paywayList);
		}

		itemDao.insertBatch(itemList);
	}


	private Boolean checkMid(String mid){
		Long count = itemDao.findMidIsExist(mid);
		if(count>0){
			return Boolean.TRUE;//存在
		}
		return Boolean.FALSE;//不存在
	}

	private List<TblGoodsPaywayModel> insertAllGoodsPayWayJF(List<ItemModel> itemList,String userId){
		List<TblGoodsPaywayModel> paywayList = Lists.newArrayList();
		for(ItemModel itemModel:itemList){
			TblGoodsPaywayModel tblGoodsPaywayModel = new TblGoodsPaywayModel();
			tblGoodsPaywayModel.setGoodsPaywayId(idGenarator.id(IdEnum.PAY_WAY, userId));
			tblGoodsPaywayModel.setGoodsId(itemModel.getCode());// 单品编码
			tblGoodsPaywayModel.setIsAction("0");// 普通礼品
			tblGoodsPaywayModel.setIscheck(GoodsModel.ApproveStatus.EDITING_00.value());// 礼品审核状态，需修改
			tblGoodsPaywayModel.setCurStatus("0102");// 当前状态，默认为已启用
			tblGoodsPaywayModel.setPaywayCode(Contants.PAY_WAY_CODE_JF);// 支付方式
			tblGoodsPaywayModel.setMemberLevel(Contants.MEMBER_LEVEL_JP_CODE);
			if (null != itemModel.getMarketPrice()) {// 临时存储的金普价
				tblGoodsPaywayModel.setGoodsPoint(itemModel.getMarketPrice().longValue());
				itemModel.setMarketPrice(BigDecimal.ZERO); // TODO 临时字段清空 add by zhoupeng
			}
			tblGoodsPaywayModel.setCalMoney(itemModel.getPrice());// 采购价
			tblGoodsPaywayModel.setCreateOper(userId);
			tblGoodsPaywayModel.setModifyOper(userId);
			paywayList.add(tblGoodsPaywayModel);
		}
		return paywayList;
	}



	/**
	 * 更新单品信息
	 *
	 * @param itemModel
	 * @return
	 */
	public Integer updateItemDetail(ItemModel itemModel) {
		return itemDao.update(itemModel);
	}

	/**
	 * 更新商品表信息
	 *
	 * @param goodsModel
	 * @return
	 */
	public Boolean updateGoodsInfo(GoodsModel goodsModel) {
		return goodsDao.update(goodsModel)==1;
	}



	public Boolean examPresent(GoodsBatchDto goodsBatchDto, User user){
		GoodsModel goodsModel = goodsDao.findById(goodsBatchDto.getCode());
		if (null==goodsModel){
			throw new IllegalArgumentException("goods.not.exit");
		}
		// 礼品当前审核状态
		String currentApproveStatus = goodsModel.getApproveStatus();
		AuditLoggingModel auditLoggingModel = new AuditLoggingModel();//审核履历

		int updateR=0;//审核结果事物更新
		switch (goodsBatchDto.getApproveType()){
			case APPROVE_TYPE_2: //初审
				// 如果当前状态已经是待复审状态，说明已经被审核过了
				if (equal(currentApproveStatus, GoodsModel.ApproveStatus.TRIAL_SECOND_02.value())) {
					throw new IllegalArgumentException("gift.has.approved");
				}
				if (APPROVE_RESULT_PASS.equals(goodsBatchDto.getApproveResult())) {
					goodsModel.setApproveStatus(GoodsModel.ApproveStatus.TRIAL_SECOND_02.value());// 待复审状态
					//第三级卡产品编码
					if(!Strings.isNullOrEmpty(goodsBatchDto.getCards())){
						goodsModel.setCards(goodsBatchDto.getCards());
					}
					auditLoggingModel.setApproveType(Contants.PASS);// 审核结果类型(通过)
				} else {
					goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_70); // 初审拒绝状态
					auditLoggingModel.setApproveType(Contants.REJECT); // 审核结果：拒绝
				}
				auditLoggingModel.setBusinessType(Contants.SPSH_FIRST);// 审核履历业务类型：商品初审
				updateR = goodsDao.update(goodsModel);// 更新审核状态
				break;
			case APPROVE_TYPE_3://复审
				// 如果当前审核状态为已经通过，则直接返回结果
				if (equal(currentApproveStatus, GoodsModel.ApproveStatus.PASS.value())) {
					throw new IllegalArgumentException("gift.has.approved");
				}
				if (APPROVE_RESULT_PASS.equals(goodsBatchDto.getApproveResult())) {
					goodsModel.setApproveStatus(GoodsModel.ApproveStatus.TRIAL_PRICING.value());
					//第三级卡产品编码
					if(!Strings.isNullOrEmpty(goodsBatchDto.getCards())){
						goodsModel.setCards(goodsBatchDto.getCards());
					}
					auditLoggingModel.setApproveType(Contants.PASS);// 审核结果：通过
				}else{
					goodsModel.setApproveStatus(GoodsModel.ApproveStatus.REFUSE_SECOND_02.value());//复审拒绝状态
					auditLoggingModel.setApproveType(Contants.REJECT); // 审核结果：拒绝
				}
				auditLoggingModel.setBusinessType(Contants.SPSH_SECOND);// 审核履历业务类型:商品复审
				updateR = goodsDao.update(goodsModel);// 更新审核状态
				break;
			//礼品信息变更审核 type=4
			case APPROVE_TYPE_4:
				//查出单品
				if (APPROVE_RESULT_PASS.equals(goodsBatchDto.getApproveResult())) {
					String approveDifferent = goodsModel.getApproveDifferent();
					GoodFullDto goodFullDto = jsonMapper.fromJson(approveDifferent, GoodFullDto.class);
					GoodsModel jsonGoodModel = goodFullDto.getGoodsModel();
					// 商品变更审核通过：审核状态变为审核通过，销售状态不变，原商品信息更新
					//审核通过 03->06
					jsonGoodModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_06);
					//第三级卡产品编码
					if(!Strings.isNullOrEmpty(goodsBatchDto.getCards())){
						jsonGoodModel.setCards(goodsBatchDto.getCards());
					}
					// 审核结果类型(通过)履历
					auditLoggingModel.setApproveType(Contants.PASS);
					//成功更新表
					//更新商品和单品  更新成功 插入履历
					//boolean update = update(jsonGoodModel, goodFullDto.getItemList());
					boolean update = updateWithoutNull(jsonGoodModel,goodFullDto.getItemList(),"",user);
					if(update){
						updateR=1;
					}
				} else {
					// 商品变更审核拒绝：审核状态变为商品审核拒绝，销售状态不变，原商品信息不变
					goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_72);
					// 审核结果类型(拒绝)
					auditLoggingModel.setApproveType(Contants.REJECT);
					updateR=goodsDao.update(goodsModel);
				}

				// 审核履历业务类型
				auditLoggingModel.setBusinessType(Contants.SPSH_CHANGE);
				//清空approoveDiff字段
				goodsDao.clearApproveDiff(goodsBatchDto.getCode());
				break;
			//价格变更审核 type=5
			case APPROVE_TYPE_5:
				if (APPROVE_RESULT_PASS.equals(goodsBatchDto.getApproveResult())) {
					goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_06);
					auditLoggingModel.setApproveType(Contants.PASS);//通过
					String approveDifferent = goodsModel.getApproveDifferent();
					GoodsPaywayDto goodsPaywayJsonDto = jsonMapper.fromJson(approveDifferent, GoodsPaywayDto.class);
					List<GoodsPaywayDto> goodsPaywayDtos = goodsPaywayJsonDto.getGoodsPaywayDtos();
					List<ItemModel> itemModels = Lists.newArrayList();
					for(GoodsPaywayDto dto:goodsPaywayDtos){
						ItemModel itemModel = new ItemModel();
						itemModel.setCode(dto.getItemId());
						itemModels.add(itemModel);
					}
					deleteGoodsPayWay(itemModels,user);
					savePengingPriced(goodsPaywayDtos,Contants.GOODS_APPROVE_STATUS_06,user);//保存定价信息到支付方式表
					updateR=goodsDao.update(goodsModel);
				} else {
					// 价格变更审核拒绝：审核状态变为价格变更审核拒绝，销售状态不变，价格不变
					goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_73);
					// 审核结果类型(拒绝)
					auditLoggingModel.setApproveType(Contants.REJECT);
					updateR=goodsDao.update(goodsModel);
				}
				//清空approoveDiff字段
				goodsDao.clearApproveDiff(goodsBatchDto.getCode());
				// 审核履历业务类型
				auditLoggingModel.setBusinessType(Contants.SPSH_PRICE);
				break;
			//商品下架申请审核  type=6
			case APPROVE_TYPE_6:
				if (APPROVE_RESULT_PASS.equals(goodsBatchDto.getApproveResult())) {
					// 下架申请审核通过：审核状态变为审核通过
					goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_06);
					// 各渠道销售状态变为在库
					goodsModel.setChannelPoints(Contants.CHANNEL_POINTS_01);//积分商城
					goodsModel.setChannelCc(Contants.CHANNEL_CC_01); // CC
					goodsModel.setChannelPhone(Contants.CHANNEL_PHONE_01); // 手机商城
					goodsModel.setChannelSms(Contants.CHANNEL_SMS_01); // 短信
					goodsModel.setChannelIvr(Contants.CHANNEL_IVR_01); //IVR
					//第三级卡产品编码
					if(!Strings.isNullOrEmpty(goodsBatchDto.getCards())){
						goodsModel.setCards(goodsBatchDto.getCards());
					}
					// 审核结果类型(通过)
					auditLoggingModel.setApproveType(Contants.PASS);
				} else {
					// 下架申请审核拒绝：审核状态变为下架申请审核拒绝，销售状态不变
					goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_74);
					// 审核结果类型(拒绝)
					auditLoggingModel.setApproveType(Contants.REJECT);
				}
				// 审核履历业务类型
				auditLoggingModel.setBusinessType(Contants.SPSH_OFFSHELF);
				updateR=goodsDao.update(goodsModel);
				break;
			//礼品定价审核 type=8
			case APPROVE_TYPE_8:
				if(APPROVE_RESULT_PASS.equalsIgnoreCase(goodsBatchDto.getApproveResult())){
					goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_06);
					goodsModel.setChannelCc(Contants.CHANNEL_CC_01); // CC
					goodsModel.setChannelPhone(Contants.CHANNEL_PHONE_01); // 手机商城
					goodsModel.setChannelPoints(Contants.CHANNEL_POINTS_01); // 积分商城
					goodsModel.setChannelSms(Contants.CHANNEL_SMS_01);// 短信
					goodsModel.setChannelIvr(Contants.CHANNEL_IVR_01); // IVR
					auditLoggingModel.setApproveType(Contants.PASS);//通过
					String approveDifferent = goodsModel.getApproveDifferent();
					GoodsPaywayDto goodsPaywayJsonDto = jsonMapper.fromJson(approveDifferent, GoodsPaywayDto.class);
					List<GoodsPaywayDto> goodsPaywayDtos = goodsPaywayJsonDto.getGoodsPaywayDtos();
					List<ItemModel> itemModels = Lists.newArrayList();
					for(GoodsPaywayDto dto:goodsPaywayDtos){
						ItemModel itemModel = new ItemModel();
						itemModel.setCode(dto.getItemId());
						itemModels.add(itemModel);
					}
					deleteGoodsPayWay(itemModels,user);
					savePengingPriced(goodsPaywayDtos,Contants.GOODS_APPROVE_STATUS_06,user);//保存定价信息到支付方式表
				}else {
                   goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_75);
					// 审核结果类型(拒绝)
					auditLoggingModel.setApproveType(Contants.REJECT);
				}
				updateR=goodsDao.update(goodsModel);
				//清空approoveDiff字段
				goodsDao.clearApproveDiff(goodsBatchDto.getCode());
				// 审核履历业务类型
				auditLoggingModel.setBusinessType(Contants.SPSH_PRICED);
				break;


		}
		goodsModel.setModifyOper(user.getName());
		// 如果审核成功，记录审核履历
		if (updateR > 0) {
			// 审核履历
			auditLoggingModel.setOuterId(goodsBatchDto.getCode()); // 外部ID
			auditLoggingModel.setAuditor(user.getName()); // 审核人
			auditLoggingModel.setAuditorMemo(goodsBatchDto.getApproveMemo()); // 审核备注(审核意见)
			auditLoggingModel.setCreateOper(user.getName()); // 创建者
			auditLoggingModel.setModifyOper(user.getName()); // 修改者
			auditLoggingDao.insert(auditLoggingModel);
		}
		return Boolean.TRUE;
	}

	/**
	 * 定价保存
	 *
	 * @param goodsPaywayDtoList，status, user
	 */
	private void savePengingPriced(List<GoodsPaywayDto> goodsPaywayDtoList, String status, User user) {

		// 审核通过
		// if (Contants.GOODS_APPROVE_STATUS_06.equals(status)) {
		for (GoodsPaywayDto goodsPaywayDto : goodsPaywayDtoList) {
			if (goodsPaywayDto != null) {
				// 金普价
				List<TblGoodsPaywayModel> otherModels = new ArrayList<>();
				if(goodsPaywayDto.getGold() !=null){
					TblGoodsPaywayModel goodsPaywayModel1 = new TblGoodsPaywayModel();
					goodsPaywayModel1.setGoodsPaywayId(idGenarator.goodsPayWayId(Contants.BUSINESS_TYPE_JF));
					goodsPaywayModel1.setIscheck(status);
					goodsPaywayModel1.setIsBirth("0");
					goodsPaywayModel1.setIsAction("0");
					goodsPaywayModel1.setStagesFlagCash("0");
					goodsPaywayModel1.setStagesFlagInc("0");
					goodsPaywayModel1.setStagesFlagPoint("0");
					goodsPaywayModel1.setCalMoney(goodsPaywayDto.getCalMoney());
					goodsPaywayModel1.setPaywayCode(Contants.PAY_WAY_CODE_JF);
					goodsPaywayModel1.setGoodsId(goodsPaywayDto.getItemId());
					goodsPaywayModel1.setMemberLevel(Contants.MEMBER_LEVEL_JP_CODE);
					goodsPaywayModel1.setGoodsPrice(new BigDecimal(0));
					goodsPaywayModel1.setGoodsPoint(goodsPaywayDto.getGold());
					goodsPaywayModel1.setCurStatus(Contants.CUR_STATUS_0102);
					goodsPaywayModel1.setCreateOper(user.getName());
					goodsPaywayModel1.setCreateTime(new Date());
					otherModels.add(goodsPaywayModel1);
				}
				// 钛金/臻享白金
				if (goodsPaywayDto.getTitanium() != null) {
					TblGoodsPaywayModel goodsPaywayModel2 = new TblGoodsPaywayModel();
					goodsPaywayModel2.setGoodsPaywayId(idGenarator.goodsPayWayId(Contants.BUSINESS_TYPE_JF));
					goodsPaywayModel2.setIscheck(status);
					goodsPaywayModel2.setIsBirth("0");
					goodsPaywayModel2.setIsAction("0");
					goodsPaywayModel2.setStagesFlagCash("0");
					goodsPaywayModel2.setStagesFlagInc("0");
					goodsPaywayModel2.setStagesFlagPoint("0");
					goodsPaywayModel2.setCalMoney(goodsPaywayDto.getCalMoney());
					goodsPaywayModel2.setGoodsId(goodsPaywayDto.getItemId());
					goodsPaywayModel2.setMemberLevel(Contants.MEMBER_LEVEL_TJ_CODE);
					goodsPaywayModel2.setPaywayCode(Contants.PAY_WAY_CODE_JF);
					goodsPaywayModel2.setGoodsPrice(new BigDecimal(0));
					goodsPaywayModel2.setGoodsPoint(goodsPaywayDto.getTitanium());
					goodsPaywayModel2.setCurStatus(Contants.CUR_STATUS_0102);
					goodsPaywayModel2.setCreateOper(user.getName());
					goodsPaywayModel2.setCreateTime(new Date());
					otherModels.add(goodsPaywayModel2);
				}

				// 顶级/增值白金
				if (goodsPaywayDto.getTopLevel() != null) {
					TblGoodsPaywayModel goodsPaywayModel3 = new TblGoodsPaywayModel();
					goodsPaywayModel3.setGoodsPaywayId(idGenarator.goodsPayWayId(Contants.BUSINESS_TYPE_JF));
					goodsPaywayModel3.setIscheck(status);
					goodsPaywayModel3.setIsBirth("0");
					goodsPaywayModel3.setIsAction("0");
					goodsPaywayModel3.setStagesFlagCash("0");
					goodsPaywayModel3.setStagesFlagInc("0");
					goodsPaywayModel3.setStagesFlagPoint("0");
					goodsPaywayModel3.setCalMoney(goodsPaywayDto.getCalMoney());
					goodsPaywayModel3.setPaywayCode(Contants.PAY_WAY_CODE_JF);
					goodsPaywayModel3.setGoodsId(goodsPaywayDto.getItemId());
					goodsPaywayModel3.setMemberLevel(Contants.MEMBER_LEVEL_DJ_CODE);
					goodsPaywayModel3.setGoodsPrice(new BigDecimal(0));
					goodsPaywayModel3.setGoodsPoint(goodsPaywayDto.getTopLevel());
					goodsPaywayModel3.setCurStatus(Contants.CUR_STATUS_0102);
					goodsPaywayModel3.setCreateOper(user.getName());
					goodsPaywayModel3.setCreateTime(new Date());
					otherModels.add(goodsPaywayModel3);
				}
				// VIP
				if (goodsPaywayDto.getVip() != null) {
					TblGoodsPaywayModel goodsPaywayModel4 = new TblGoodsPaywayModel();
					goodsPaywayModel4.setGoodsPaywayId(idGenarator.goodsPayWayId(Contants.BUSINESS_TYPE_JF));
					goodsPaywayModel4.setIscheck(status);
					goodsPaywayModel4.setIsBirth("0");
					goodsPaywayModel4.setIsAction("0");
					goodsPaywayModel4.setStagesFlagCash("0");
					goodsPaywayModel4.setStagesFlagInc("0");
					goodsPaywayModel4.setStagesFlagPoint("0");
					goodsPaywayModel4.setCalMoney(goodsPaywayDto.getCalMoney());
					goodsPaywayModel4.setPaywayCode(Contants.PAY_WAY_CODE_JF);
					goodsPaywayModel4.setGoodsId(goodsPaywayDto.getItemId());
					goodsPaywayModel4.setMemberLevel(Contants.MEMBER_LEVEL_VIP_CODE);
					goodsPaywayModel4.setGoodsPrice(new BigDecimal(0));
					goodsPaywayModel4.setGoodsPoint(goodsPaywayDto.getVip());
					goodsPaywayModel4.setCurStatus(Contants.CUR_STATUS_0102);
					goodsPaywayModel4.setCreateOper(user.getName());
					goodsPaywayModel4.setCreateTime(new Date());
					otherModels.add(goodsPaywayModel4);
				}

				// 生日
				if (goodsPaywayDto.getBirthday() != null) {
					TblGoodsPaywayModel goodsPaywayModel5 = new TblGoodsPaywayModel();
					goodsPaywayModel5.setGoodsPaywayId(idGenarator.goodsPayWayId(Contants.BUSINESS_TYPE_JF));
					goodsPaywayModel5.setIscheck(status);
					goodsPaywayModel5.setCalMoney(goodsPaywayDto.getCalMoney());
					goodsPaywayModel5.setPaywayCode(Contants.PAY_WAY_CODE_JF);
					goodsPaywayModel5.setGoodsId(goodsPaywayDto.getItemId());
					goodsPaywayModel5.setMemberLevel(Contants.MEMBER_LEVEL_BIRTH_CODE);
					goodsPaywayModel5.setGoodsPrice(new BigDecimal(0));
					goodsPaywayModel5.setGoodsPoint(goodsPaywayDto.getBirthday());
					goodsPaywayModel5.setCurStatus(Contants.CUR_STATUS_0102);
					goodsPaywayModel5.setIsBirth("1");
					goodsPaywayModel5.setIsAction("0");
					goodsPaywayModel5.setStagesFlagCash("0");
					goodsPaywayModel5.setStagesFlagInc("0");
					goodsPaywayModel5.setStagesFlagPoint("0");
					goodsPaywayModel5.setCreateOper(user.getName());
					goodsPaywayModel5.setCreateTime(new Date());
					otherModels.add(goodsPaywayModel5);
				}

				// 积分+现金
				if (goodsPaywayDto.getPoints() != null) {
					// 判断金普卡在10000以内，不需要有积分+现金这个价格
					if (goodsPaywayDto.getGold().compareTo(10000L) < 0) {
						throw new IllegalArgumentException("price.less.then.ten.thousand.can.not.cash.and.price.error");
					} else {
						TblGoodsPaywayModel goodsPaywayModel6 = new TblGoodsPaywayModel();
						goodsPaywayModel6.setGoodsPaywayId(idGenarator.goodsPayWayId(Contants.BUSINESS_TYPE_JF));
						goodsPaywayModel6.setIscheck(status);
						goodsPaywayModel6.setIsBirth("0");
						goodsPaywayModel6.setIsAction("0");
						goodsPaywayModel6.setStagesFlagCash("0");
						goodsPaywayModel6.setStagesFlagInc("0");
						goodsPaywayModel6.setStagesFlagPoint("0");
						goodsPaywayModel6.setCalMoney(goodsPaywayDto.getCalMoney());

						goodsPaywayModel6.setPaywayCode(Contants.PAY_WAY_CODE_JFXJ);
						goodsPaywayModel6.setGoodsId(goodsPaywayDto.getItemId());
						goodsPaywayModel6.setMemberLevel(Contants.MEMBER_LEVEL_INTEGRAL_CASH_CODE);
						goodsPaywayModel6.setGoodsPrice(goodsPaywayDto.getPrice());
						goodsPaywayModel6.setGoodsPoint(goodsPaywayDto.getPoints());
						goodsPaywayModel6.setCurStatus(Contants.CUR_STATUS_0102);

						goodsPaywayModel6.setCreateOper(user.getName());
						goodsPaywayModel6.setCreateTime(new Date());
						otherModels.add(goodsPaywayModel6);
					}
				}
				if(otherModels.size()!=0 || !otherModels.isEmpty()){
					tblGoodsPaywayDao.insertAllPayWay(otherModels);
				}
			} else {
				throw new IllegalArgumentException("integral.pricing.error");
			}
		}
		}


	/**
	 *审核通过和拒绝 包括所有审核
	 * @return
     */
	public Boolean updateGoodsInfoForCheck(GoodsBatchDto goodsBatchDto, User user){

		//获取当月积分池的单位积分
		Response<PointPoolModel> pointPoolResponse = pointsPoolService.getCurMonthInfo();
		Long singlePoint = null;
		if(pointPoolResponse.isSuccess() && pointPoolResponse.getResult()!=null){
			singlePoint = pointPoolResponse.getResult().getSinglePoint();
		}

		// 取得商品信息
		GoodsModel goodsModel = goodsDao.findById(goodsBatchDto.getCode());
		if (goodsModel == null) {
			throw new IllegalArgumentException("goods.not.found");
		}
		// 商品当前审核状态
		String currentApproveStatus = goodsModel.getApproveStatus();
		//履历dto
		AuditLoggingModel auditLoggingModel = new AuditLoggingModel();
		int updateR=0;//审核结果事物更新
		List<ItemModel> itemList = Lists.newArrayList();
		switch (goodsBatchDto.getApproveType()) {
			//初审页面 type传过来是2
			case APPROVE_TYPE_2:
				// 如果当前状态已经是待复审状态，说明已经被审核过了
				if (equal(currentApproveStatus, Contants.GOODS_APPROVE_STATUS_02)) {
					throw new IllegalArgumentException("goods.has.approved");
				}
				if (APPROVE_RESULT_PASS.equals(goodsBatchDto.getApproveResult())) {
					// 初审通过：审核状态变为复审
					goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_02);
					// 审核结果类型(通过)
					auditLoggingModel.setApproveType(Contants.PASS);
					//第三级卡产品编码
					if(!Strings.isNullOrEmpty(goodsBatchDto.getCards())){
						goodsModel.setCards(goodsBatchDto.getCards());
					}
					//积分支付比例
					if(!Strings.isNullOrEmpty(goodsBatchDto.getRate())){
						BigDecimal bestRate = new BigDecimal(goodsBatchDto.getRate());
						itemList = itemDao.findItemDetailByGoodCode(goodsBatchDto.getCode());
						for(ItemModel itemModel:itemList){
							itemModel.setProductPointRate(bestRate);//积分支付比例
							itemModel.setBestRate(bestRate);//最佳倍率
							itemModel.setDisplayFlag(Integer.parseInt(goodsBatchDto.getDisplayFlag()));//是否仅显示全积分支付
							itemModel.setMaxPoint(BigDecimal.valueOf(singlePoint).multiply(itemModel.getPrice()).multiply(bestRate).longValue());//最大积分数量
						}
					}
				} else {
					// 初审拒绝：审核状态变为初审拒绝
					goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_70);
					// 审核结果类型(拒绝)
					auditLoggingModel.setApproveType(Contants.REJECT);
				}
				// 审核履历业务类型
				auditLoggingModel.setBusinessType(Contants.SPSH_FIRST);
				// 更新审核状态
				//updateR = goodsDao.update(goodsModel);
				boolean updateB = update(goodsModel,itemList);
				updateR=updateB?1:0;
				break;
			//复审页面 type=3
			case APPROVE_TYPE_3:
				// 如果当前审核状态为已经通过，则直接返回结果
				if (equal(currentApproveStatus, Contants.GOODS_APPROVE_STATUS_06)) {
					throw new IllegalArgumentException("goods.has.approved");
				}
				//复审通过 插入支付方式  7个渠道销售状态从00变为01
				if (APPROVE_RESULT_PASS.equals(goodsBatchDto.getApproveResult())) {
					// 复审通过：审核状态变为审核通过
					goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_06);
					// 各渠道销售状态变为在库
					goodsModel.setChannelMall(Contants.CHANNEL_MALL_01); // 广发商城
					goodsModel.setChannelMallWx(Contants.CHANNEL_MALL_WX_01); // 广发商城-微信
					goodsModel.setChannelCreditWx(Contants.CHANNEL_CREDIT_WX_01); // 信用卡中心-微信
					goodsModel.setChannelCc(Contants.CHANNEL_CC_01); // CC
					goodsModel.setChannelPhone(Contants.CHANNEL_PHONE_01); // 手机商城
					goodsModel.setChannelApp(Contants.CHANNEL_APP_01); // APP
					goodsModel.setChannelSms(Contants.CHANNEL_SMS_01); // 短信
					// 审核结果类型(通过)
					auditLoggingModel.setApproveType(Contants.PASS);
					//第三级卡产品编码
					if(!Strings.isNullOrEmpty(goodsBatchDto.getCards())){
						goodsModel.setCards(goodsBatchDto.getCards());
					}
					//积分支付比例
					if(!Strings.isNullOrEmpty(goodsBatchDto.getRate())){
						BigDecimal bestRate = new BigDecimal(goodsBatchDto.getRate());
						itemList = itemDao.findItemDetailByGoodCode(goodsBatchDto.getCode());
						for(ItemModel itemModel:itemList){
							itemModel.setProductPointRate(bestRate);//积分支付比例
							itemModel.setBestRate(bestRate);//最佳倍率
							itemModel.setDisplayFlag(Integer.parseInt(goodsBatchDto.getDisplayFlag()));//是否仅显示全积分支付
							itemModel.setMaxPoint(BigDecimal.valueOf(singlePoint).multiply(itemModel.getPrice()).multiply(bestRate).longValue());//最大积分数量
						}
					}

                    //插入支付方式
					List<ItemModel> itemListByGoodsCode = itemDao.findItemListByGoodsCode(goodsBatchDto.getCode());
					deleteGoodsPayWay(itemListByGoodsCode,user);
					insertGoodsPayWay(itemListByGoodsCode,user,goodsModel.getIsInner(),Contants.GOODS_APPROVE_STATUS_06,goodsModel.getMailOrderCode(),goodsModel.getOrdertypeId());

				} else {
					// 复审拒绝：审核状态变为复审拒绝
					goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_71);
					// 审核结果类型(拒绝)
					auditLoggingModel.setApproveType(Contants.REJECT);
				}
				// 审核履历业务类型
				auditLoggingModel.setBusinessType(Contants.SPSH_SECOND);
				//updateR = goodsDao.update(goodsModel);
				boolean updateB1 = update(goodsModel,itemList);
				updateR=updateB1?1:0;
				break;
			//商品信息变更审核 type=4
			case APPROVE_TYPE_4:
				//查出单品
				List<ItemModel> itemListByGoodsCode = itemDao.findItemListByGoodsCode(goodsBatchDto.getCode());
				if (APPROVE_RESULT_PASS.equals(goodsBatchDto.getApproveResult())) {
					String approveDifferent = goodsModel.getApproveDifferent();
					GoodFullDto goodFullDto = jsonMapper.fromJson(approveDifferent, GoodFullDto.class);
					GoodsModel jsonGoodModel = goodFullDto.getGoodsModel();
					// 商品变更审核通过：审核状态变为审核通过，销售状态不变，原商品信息更新
					//审核通过 03->06
					jsonGoodModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_06);
					// 审核结果类型(通过)履历
					auditLoggingModel.setApproveType(Contants.PASS);
					//第三级卡产品编码
					if(!Strings.isNullOrEmpty(goodsBatchDto.getCards())){
						jsonGoodModel.setCards(goodsBatchDto.getCards());
					}
					//积分支付比例
					if(!Strings.isNullOrEmpty(goodsBatchDto.getRate())){
						BigDecimal bestRate = new BigDecimal(goodsBatchDto.getRate());
						for(ItemModel itemModel:goodFullDto.getItemList()){
							itemModel.setProductPointRate(bestRate);//积分支付比例
							itemModel.setBestRate(bestRate);//最佳倍率
							itemModel.setDisplayFlag(Integer.parseInt(goodsBatchDto.getDisplayFlag()));//是否仅显示全积分支付
							itemModel.setMaxPoint(BigDecimal.valueOf(singlePoint).multiply(itemModel.getPrice()).multiply(bestRate).longValue());//最大积分数量
						}
					}
					//删除原有支付方式
					deleteGoodsPayWay(itemListByGoodsCode,user);
					//插入新的支付方式
					insertGoodsPayWay(goodFullDto.getItemList(),user,jsonGoodModel.getIsInner(),Contants.GOODS_APPROVE_STATUS_06,goodsModel.getMailOrderCode(),goodsModel.getOrdertypeId());
					//更新商品和单品  更新成功 插入履历
					boolean update = updateWithoutNull(jsonGoodModel, goodFullDto.getItemList(),"",user);
					updateR=update?1:0;
				} else {
					// 商品变更审核拒绝：审核状态变为商品审核拒绝，销售状态不变，原商品信息不变
					goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_72);
					// 审核结果类型(拒绝)
					auditLoggingModel.setApproveType(Contants.REJECT);
					updateR=goodsDao.update(goodsModel);
				}

				// 审核履历业务类型
				auditLoggingModel.setBusinessType(Contants.SPSH_CHANGE);
				//清空approoveDiff字段
				goodsDao.clearApproveDiff(goodsBatchDto.getCode());
				break;
			//价格变更审核 type=5
			case APPROVE_TYPE_5:
				if (APPROVE_RESULT_PASS.equals(goodsBatchDto.getApproveResult())) {
					List<ItemModel> oldItemList = itemDao.findItemListByGoodsCode(goodsBatchDto.getCode());
					String approveDifferent = goodsModel.getApproveDifferent();
					// 价格变更审核通过：审核状态变为审核通过，销售状态不变，价格更新
					GoodFullDto goodFullDto = jsonMapper.fromJson(approveDifferent, GoodFullDto.class);
					GoodsModel jsonGoodModel = goodFullDto.getGoodsModel();
					List<ItemModel> priceChangeList = goodFullDto.getItemList();
					if(priceChangeList!=null&&priceChangeList.size()!=0){
						ImmutableMap<String, ItemModel> changeMap = Maps.uniqueIndex(priceChangeList, new Function<ItemModel, String>() {
							@Override
							public String apply(ItemModel itemModel) {
								return itemModel.getCode();
							}
						});
						for(ItemModel item:oldItemList){
							ItemModel itemModel = changeMap.get(item.getCode());
							item.setPrice(itemModel.getPrice());
							item.setMarketPrice(itemModel.getMarketPrice());
							item.setFixPoint(itemModel.getFixPoint());//可能更改的值
						}
					}
					// 商品变更审核通过：审核状态变为审核通过，销售状态不变，原商品信息更新
					//审核通过 03->06
					jsonGoodModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_06);
					//第三级卡产品编码
					if(!Strings.isNullOrEmpty(goodsBatchDto.getCards())){
						jsonGoodModel.setCards(goodsBatchDto.getCards());
					}
					//积分支付比例
					if(!Strings.isNullOrEmpty(goodsBatchDto.getRate())){
						BigDecimal bestRate = new BigDecimal(goodsBatchDto.getRate());
						for(ItemModel itemModel:goodFullDto.getItemList()){
							itemModel.setProductPointRate(bestRate);//积分支付比例
							itemModel.setBestRate(bestRate);//最佳倍率
							itemModel.setDisplayFlag(Integer.parseInt(goodsBatchDto.getDisplayFlag()));//是否仅显示全积分支付
							itemModel.setMaxPoint(BigDecimal.valueOf(singlePoint).multiply(itemModel.getPrice()).multiply(bestRate).longValue());//最大积分数量
						}
					}

					// 审核结果类型(通过)履历
					auditLoggingModel.setApproveType(Contants.PASS);
					//成功更新表
					//删除原有支付方式
					deleteGoodsPayWay(oldItemList,user);
					//插入新的支付方式 oldItemList已经处理为新的
					insertGoodsPayWay(oldItemList,user,jsonGoodModel.getIsInner(),Contants.GOODS_APPROVE_STATUS_06,goodsModel.getMailOrderCode(),goodsModel.getOrdertypeId());
					// 审核结果类型(通过)
					auditLoggingModel.setApproveType(Contants.PASS);
					//更新商品和单品  更新成功 加入履历
					boolean update = updateItemPrice(jsonGoodModel,goodFullDto.getItemList());
					updateR=update?1:0;
				} else {
					// 价格变更审核拒绝：审核状态变为价格变更审核拒绝，销售状态不变，价格不变
					goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_73);
					// 审核结果类型(拒绝)
					auditLoggingModel.setApproveType(Contants.REJECT);
					updateR=goodsDao.update(goodsModel);
				}
                //清空approoveDiff字段
				goodsDao.clearApproveDiff(goodsBatchDto.getCode());
				// 审核履历业务类型
				auditLoggingModel.setBusinessType(Contants.SPSH_PRICE);
				break;
			//商品下架申请审核  type=6
			default:
				if (APPROVE_RESULT_PASS.equals(goodsBatchDto.getApproveResult())) {
					// 下架申请审核通过：审核状态变为审核通过
					goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_06);
					// 各渠道销售状态变为在库
					goodsModel.setChannelMall(Contants.CHANNEL_MALL_01); // 广发商城
					goodsModel.setChannelMallWx(Contants.CHANNEL_MALL_WX_01); // 广发商城-微信
					goodsModel.setChannelCreditWx(Contants.CHANNEL_CREDIT_WX_01); // 信用卡中心-微信
					goodsModel.setChannelCc(Contants.CHANNEL_CC_01); // CC
					goodsModel.setChannelPhone(Contants.CHANNEL_PHONE_01); // 手机商城
					goodsModel.setChannelApp(Contants.CHANNEL_APP_01); // APP
					goodsModel.setChannelSms(Contants.CHANNEL_SMS_01); // 短信

					//第三级卡产品编码
					if(!Strings.isNullOrEmpty(goodsBatchDto.getCards())){
						goodsModel.setCards(goodsBatchDto.getCards());
					}
					//积分支付比例
					if(!Strings.isNullOrEmpty(goodsBatchDto.getRate())){
						BigDecimal bestRate = new BigDecimal(goodsBatchDto.getRate());
						itemList = itemDao.findItemDetailByGoodCode(goodsBatchDto.getCode());
						for(ItemModel itemModel:itemList){
							itemModel.setProductPointRate(bestRate);//积分支付比例
							itemModel.setBestRate(bestRate);//最佳倍率
							itemModel.setDisplayFlag(Integer.parseInt(goodsBatchDto.getDisplayFlag()));//是否仅显示全积分支付
							itemModel.setMaxPoint(BigDecimal.valueOf(singlePoint).multiply(itemModel.getPrice()).multiply(bestRate).longValue());//最大积分数量
						}
					}

					// 审核结果类型(通过)
					auditLoggingModel.setApproveType(Contants.PASS);
				} else {
					// 下架申请审核拒绝：审核状态变为下架申请审核拒绝，销售状态不变
					goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_74);
					// 审核结果类型(拒绝)
					auditLoggingModel.setApproveType(Contants.REJECT);
				}
				// 审核履历业务类型
				auditLoggingModel.setBusinessType(Contants.SPSH_OFFSHELF);
				boolean updateB2 = update(goodsModel,itemList);
				updateR=updateB2?1:0;
				//updateR=goodsDao.update(goodsModel);
		}
		goodsModel.setModifyOper(user.getName());
		// 如果审核成功，记录审核履历
		if (updateR > 0) {
			// 审核履历
			auditLoggingModel.setOuterId(goodsBatchDto.getCode()); // 外部ID
			auditLoggingModel.setAuditor(user.getName()); // 审核人
			auditLoggingModel.setAuditorMemo(goodsBatchDto.getApproveMemo()); // 审核备注(审核意见)
			auditLoggingModel.setCreateOper(user.getName()); // 创建者
			auditLoggingModel.setModifyOper(user.getName()); // 修改者
			auditLoggingDao.insert(auditLoggingModel);
		}
       return Boolean.TRUE;
	}

	/**
	 * 更新商品上下架信息 同时，如果是广发商城渠道，则创建或删除索引
	 *
	 * @param goodsModel
	 * @return
	 */

	public Integer updateGoodsShelf(GoodsModel goodsModel) {
		return  goodsDao.update(goodsModel);
	}

	/**
	 * 根据供应商ID下架该供应商下所有渠道的所有商品
	 *
	 * @param vendorId
	 * @return
	 */
	public Integer updateChannelByVendorId(String vendorId,String businessTypeId) {
		Integer count = 0;
		if (Contants.BUSINESS_TYPE_YG.equals(businessTypeId)){
			count = goodsDao.updateChannelYgByVendorId(vendorId);
		}else{
			count = goodsDao.updateChannelJfByVendorId(vendorId);
		}
		return count;
	}


	/**
	 * 商品提交审核
	 *
	 * @param goodsDetailDto
	 */
	public void submitGoodsToApprove(GoodsDetailDto goodsDetailDto, User user) {
		// 更新商品表
		GoodsModel goodsModel = new GoodsModel();
		goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_01);
		goodsModel.setCode(goodsDetailDto.getCode());
		goodsModel.setApproveDifferent(goodsDetailDto.getApproveDifferent());
		goodsDao.update(goodsModel);
	}

	/**
	 * 批量插入商品支付方式表
	 * 
	 * @param itemModelList
	 * @param user
	 */
	private void insertGoodsPayWay(List<ItemModel> itemModelList, User user, String isAction, String approveStatus,
			String categoryNo, String orderTypeId) {
		List<TblGoodsPaywayModel> goodsPayWayList = Lists.newArrayList();// 用于批量插入的list
		TblGoodsPaywayModel goodsPaywayModel ;
		List<String> periodsList ;// 单品分期数list
		// 循环单品表格，生成多条支付方式信息
		for (ItemModel itemModel : itemModelList) {
			periodsList = splitter.splitToList(itemModel.getInstallmentNumber());
			// 循环分期数list，计算各个分期数的价格
			BigDecimal itemPrice = itemModel.getPrice();
			for (String period : periodsList) {
				goodsPaywayModel = new TblGoodsPaywayModel();
				String goodsPayWayId = idGenarator.goodsPayWayId(orderTypeId);// 生成code
				double doublePrice = itemPrice.doubleValue();
				BigDecimal perStage = new BigDecimal(doublePrice / Integer.parseInt(period));// 计算每期价格
				goodsPaywayModel.setGoodsPaywayId(goodsPayWayId);// 商品支付编码
				goodsPaywayModel.setGoodsId(itemModel.getCode());// 单品编码
				goodsPaywayModel.setPaywayCode(Contants.PAY_WAY_CODE_0001);// 支付方式代码（广发商城商品支付方式为现金）
				goodsPaywayModel.setPayType("");// 佣金代码
				goodsPaywayModel.setIncCode(0L);// 手续费率码
				goodsPaywayModel.setStagesCode(Integer.parseInt(period));// 分期数
				goodsPaywayModel.setRuleId(PAYWAY_RULE_ID_0);// 商品应用规则id
				goodsPaywayModel.setAuthFlat1("");// 限制1
				goodsPaywayModel.setAuthFlat2("");// 限制2
				goodsPaywayModel.setPerStage(perStage.setScale(2, RoundingMode.HALF_EVEN));// 每期价格
				goodsPaywayModel.setStagesFlagCash(PAYWAY_STAGES_FLAG_CASH); // 是否支持分期【现金】
				goodsPaywayModel.setStagesFlagPoint(PAYWAY_STAGES_FLAG_POINT); // 是否支持分期[积分]
				goodsPaywayModel.setStagesFlagInc(PAYWAY_STAGES_FLAG_INC);// 是否支持分期【手续费】
				goodsPaywayModel.setGoodsPoint(0L);// 积分数量
				goodsPaywayModel.setIsAction(isAction);// 活动类型
				goodsPaywayModel.setIsBirth(PAYWAY_IS_BIRTH_0);// 是否生日价
				goodsPaywayModel.setMemberLevel("");// 会员等级
				goodsPaywayModel.setGoodsPrice(itemPrice);// 现金
				goodsPaywayModel.setCalMoney(new BigDecimal(0.00));// 清算金额
				goodsPaywayModel.setGoodsPaywayDesc("");// 备注
				goodsPaywayModel.setIscheck(approveStatus);// 是否待复核
				goodsPaywayModel.setCurStatus(Contants.CUR_STATUS_0102);// 当前状态
				// 如果是一期并且存在一期邮购分期类别码，则一期的分期费率码为一期邮购分期类别码,//如果是其他期数，则就为邮购分期类别码
				if ("1".equals(period) && !Strings.isNullOrEmpty(itemModel.getStagesCode())) {
					goodsPaywayModel.setCategoryNo(itemModel.getStagesCode());// 分期费率
				} else {
					goodsPaywayModel.setCategoryNo(categoryNo);// 分期费率
				}
				goodsPaywayModel.setCreateOper(user.getId());// 创建人
				goodsPayWayList.add(goodsPaywayModel);// 添加到list
			}
		}
		// 批量插入
		if ( goodsPayWayList.size() != 0) {
			tblGoodsPaywayDao.insertAllPayWay(goodsPayWayList);
		}
	}

	/**
	 * 批量删除
	 * 
	 * @param itemModelList
	 */
	private void deleteGoodsPayWay(List<ItemModel> itemModelList, User user) {
		Map<String, Object> params = Maps.newHashMap();
		List<String> itemCodeList = Lists.transform(itemModelList, new Function<ItemModel, String>() {
			@Nullable
			@Override
			public String apply(@Nullable ItemModel input) {
				return input.getId();
			}
		});
		params.put("itemCodeList", itemCodeList);
		params.put("modifyOper", user.getId());
		tblGoodsPaywayDao.deletePayWay(params);
	}

	public void updateGoodsJF(ItemModel itemModel){
		itemDao.updateGoodsJF(itemModel);
	}
	public void updateGoodsYG(ItemModel itemModel){
		itemDao.updateGoodsYG(itemModel);
	}
	public Integer updateStock(String goodsId){
		return itemDao.updateStock(goodsId);
	}

	public boolean update(GoodsModel goodsModel, List<ItemModel> itemList) {
		Integer result = goodsDao.update(goodsModel);
		for (ItemModel itemModel :itemList) {
			itemDao.update(itemModel);
		}
		if (result > 0){
			return Boolean.TRUE;
		}
		return Boolean.FALSE;
	}

	/**
	 * 更新商品and单品信息
	 * 不带null条件判断
	 * @param goodsModel
	 * @param itemList
     * @return
     */
	public boolean updateWithoutNull(GoodsModel goodsModel,List<ItemModel> itemList,String channel,User user){
		Integer result = goodsDao.updateWithoutNull(goodsModel);
		for (ItemModel itemModel :itemList) {
			itemDao.updateWithoutNull(itemModel);
		}
		//如果是积分商城的礼品，删除原有支付方式表数据，插入新支付方式数据
		if(Contants.ORDERTYPEID_JF.equals(channel)){
			deleteGoodsPayWay(itemList,user);
			List<TblGoodsPaywayModel> paywayList = insertAllGoodsPayWayJF(itemList,user.getId());
			tblGoodsPaywayDao.insertAllPayWay(paywayList);
		}
		if (result > 0){
			return Boolean.TRUE;
		}
		return Boolean.FALSE;
	}

	private boolean updateItemPrice(GoodsModel goodsModel,List<ItemModel> itemModels){
		Integer result = goodsDao.update(goodsModel);
		for (ItemModel itemModel :itemModels) {
			itemDao.updatePrice(itemModel);
		}
		if (result > 0){
			return Boolean.TRUE;
		}
		return Boolean.FALSE;
	}

	public void importGoods(GoodsModel goodsModel,List<ItemModel> itemModels){
		goodsDao.insert(goodsModel);
		for(ItemModel item:itemModels){
			itemDao.insert(item);
		}
	}

}
