package cn.com.cgbchina.item.manager;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.generator.IdEnum;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.dao.*;
import cn.com.cgbchina.item.dto.*;
import cn.com.cgbchina.item.model.*;
import cn.com.cgbchina.item.service.AttributeValueService;
import cn.com.cgbchina.item.service.BackCategoriesService;
import cn.com.cgbchina.item.service.GoodsOperateDetailService;
import cn.com.cgbchina.item.service.ItemIndexService;
import cn.com.cgbchina.user.model.TblVendorRatioModel;
import cn.com.cgbchina.user.service.VendorService;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by 陈乐 on 2016/4/23.
 */
@Component
@Transactional
@Slf4j
public class GoodsManager {
	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	private static JsonMapper defaultJsonMapper = JsonMapper.nonDefaultMapper();
	@Resource
	private GoodsDao goodsDao;
	@Resource
	private ItemDao itemDao;
	@Resource
	private AuditLoggingDao auditLoggingDao;
	@Resource
	private IdGenarator idGenarator;
	@Autowired
	private AttributeValueService attributeValueService;
	@Autowired
	private BackCategoriesService backCategoriesService;
	@Resource
	private ProductDao productDao;
	@Autowired
	private ItemIndexService itemIndexService;
	@Autowired
	private GoodsOperateDetailService goodsOperateDetailService;
	@Resource
	private TblGoodsPaywayDao tblGoodsPaywayDao;
	@Autowired
	private VendorService vendorService;
	private static final String APPROVE_TYPE_2 = "2";//审核类型标识:初审
	private static final String APPROVE_TYPE_3 = "3";//审核类型标识:复审
	private static final String APPROVE_TYPE_4 = "4";//审核类型标识:商品信息变更审核
	private static final String APPROVE_TYPE_5 = "5";//审核类型标识:价格变更审核
	private static final String APPROVE_RESULT_PASS ="pass";//审核结果标识：通过


	public void createGoods(GoodsDetailDto goodsDetailDto, User user) {
		GoodsModel goodsModel = new GoodsModel();
		Integer count = 0;
		// 获取goods表主键(商品编码)
		String goodsCode = idGenarator.id(IdEnum.GOODS, user.getId());
		goodsDetailDto.setCode(goodsCode);
		// 业务类型代码
		goodsDetailDto.setOrdertypeId(Contants.BUSINESS_TYPE_YG);
		// 数据生成时，默认的各个渠道的销售状态置为处理中
		goodsDetailDto.setChannelMall(Contants.CHANNEL_MALL_00); // 广发商城
		goodsDetailDto.setChannelMallWx(Contants.CHANNEL_MALL_WX_00); // 广发商城-微信
		goodsDetailDto.setChannelCreditWx(Contants.CHANNEL_CREDIT_WX_00); // 信用卡中心-微信
		goodsDetailDto.setChannelCc(Contants.CHANNEL_CC_00); // CC
		goodsDetailDto.setChannelPhone(Contants.CHANNEL_PHONE_00); // 手机商城
		goodsDetailDto.setChannelApp(Contants.CHANNEL_APP_00); // APP
		goodsDetailDto.setChannelSms(Contants.CHANNEL_SMS_00); // 短信
		goodsDetailDto.setPointsType(Contants.JGID_COMMON);//商品积分类型默认设为普通积分
		// 创建者
		goodsDetailDto.setCreateOper(user.getName());
		goodsDetailDto.setModifyOper(user.getName());
		// 设定新增属性的KEY值
		String jsonGoods = setAttributeValueKey(goodsDetailDto.getAttribute());
		goodsDetailDto.setAttribute(jsonGoods);
		// 批量插入单品信息
		List<ItemModel> itemInfoList = new ArrayList<ItemModel>();
		for (int i = 0; i < goodsDetailDto.getItemList().size(); i++) {
			ItemModel itemModel = goodsDetailDto.getItemList().get(i);
			String itemCode = null;
			itemCode = idGenarator.id(IdEnum.ITEM, user.getId());
			itemModel.setCode(itemCode);
			itemModel.setGoodsCode(goodsCode);
			itemModel.setCreateOper(user.getName());
			itemModel.setModifyOper(user.getName());
			// 默认为非置顶
			itemModel.setStickFlag(Contants.STICK_FLAG_0);
			String jsonItem = setAttributeValueKey(itemModel.getAttribute());
			itemModel.setAttribute(jsonItem);
			itemInfoList.add(itemModel);
			goodsDetailDto.getItemList().get(i).setCode(itemCode);
		}
		itemDao.insertBatch(itemInfoList);
		if (Contants.GOODS_APPROVE_STATUS_01.equals(goodsDetailDto.getApproveStatus())) {
			// TODO 商品支付方式
			TblVendorRatioModel tblVendorRatioModel = findVendorRatio(goodsDetailDto.getVendorId(), 1);
			Long incCode = null;
			if (tblVendorRatioModel != null) {
				incCode = tblVendorRatioModel.getId();
			}
			saveGoodsPayWay(itemInfoList, user, goodsDetailDto.getMailOrderCode(), incCode);
		}
		BeanMapper.copy(goodsDetailDto, goodsModel);
		// 审核数据diff设定
		if (Contants.GOODS_APPROVE_STATUS_01.equals(goodsDetailDto.getApproveStatus())) {
			String diff = "";
			diff = defaultJsonMapper.toJson(goodsDetailDto);
			goodsModel.setApproveDifferent(diff);
		}
		goodsDao.insert(goodsModel);
		// 调用后台类目计数器，传入三级类目id
		backCategoriesService.changeCount(goodsModel.getBackCategory3Id(), 1L);
		// 如果是供应商进行插入商品则插入商品操作历史
		if (!Strings.isNullOrEmpty(user.getVendorId())) {
			GoodsOperateDetailModel goodsOperateDetailModel = new GoodsOperateDetailModel();
			BeanMapper.copy(goodsDetailDto, goodsOperateDetailModel);
			goodsOperateDetailModel.setGoodCode(goodsCode);
			goodsOperateDetailModel.setGoodName(goodsDetailDto.getName());
			goodsOperateDetailModel.setOperateType(Contants.GOODS_OPERATE_TYPE_1);
			goodsOperateDetailService.createGoodsOperate(goodsOperateDetailModel);
		}
	}

	/**
	 * 编辑商品
	 *
	 * @param goodsDetailDto
	 * @param user
	 */
	public void updataGoods(GoodsDetailDto goodsDetailDto, User user) {
		GoodsModel goodsModel = new GoodsModel();
		// 如果前台传入数据中approveStatus不是00 那么就将整个数据存入goods表中approveDifferent字段,并不对其他字段进行更新
		if (!Contants.GOODS_APPROVE_STATUS_00.equals(goodsDetailDto.getApproveStatus())) {
			// 审核状态设定
			if (Contants.GOODS_APPROVE_STATUS_06.equals(goodsDetailDto.getApproveStatus())) {
				// 原审核状态为审核通过时，设定为商品变更审核
				goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_03);
			} else if (Contants.GOODS_APPROVE_STATUS_70.equals(goodsDetailDto.getApproveStatus())) {
				// 原审核状态为初审拒绝时，设定为待初审
				goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_01);
			} else if (Contants.GOODS_APPROVE_STATUS_71.equals(goodsDetailDto.getApproveStatus())) {
				// 原审核状态为复审拒绝时，设定为待初审
				goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_01);
			} else if (Contants.GOODS_APPROVE_STATUS_72.equals(goodsDetailDto.getApproveStatus())) {
				// 原审核状态为商品变更审核拒绝时，设定为商品变更审核
				goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_03);
			} else if (Contants.GOODS_APPROVE_STATUS_73.equals(goodsDetailDto.getApproveStatus())) {
				// 原审核状态为价格变更审核拒绝时，设定为商品变更审核
				goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_03);
			} else if (Contants.GOODS_APPROVE_STATUS_74.equals(goodsDetailDto.getApproveStatus())) {
				// 原审核状态为下架申请审核拒绝时，设定为商品变更审核
				goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_03);
			} else {
				goodsModel.setApproveStatus(goodsDetailDto.getApproveStatus());
				TblVendorRatioModel tblVendorRatioModel = findVendorRatio(goodsDetailDto.getVendorId(), 1);
				Long incCode = null;
				if (tblVendorRatioModel != null) {
					incCode = tblVendorRatioModel.getId();
				}
				saveGoodsPayWay(goodsDetailDto.getItemList(), user, goodsDetailDto.getMailOrderCode(), incCode);
			}
			// 审核数据diff设定
			String diff = "";
			diff = defaultJsonMapper.toJson(goodsDetailDto);
			goodsModel.setCode(goodsDetailDto.getGoodsCode());
			goodsModel.setApproveDifferent(diff);
			goodsDao.update(goodsModel);
		} else {
			updateGoodsDetail(goodsDetailDto, user, Boolean.FALSE);
		}
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
	public Integer updateGoodsInfo(GoodsModel goodsModel) {
		return goodsDao.update(goodsModel);
	}

	/**
	 * 更新商品上下架信息 同时，如果是广发商城渠道，则创建或删除索引
	 * 
	 * @param goodsModel
	 * @return
	 */

	public Integer updateGoodsShelf(GoodsModel goodsModel) {
		Integer count = goodsDao.update(goodsModel);
		if(count>0 && !Strings.isNullOrEmpty(goodsModel.getChannelMall())){
			List<ItemModel> itemModelList = itemDao.findItemDetailByGoodCode(goodsModel.getCode());
			if (Contants.CHANNEL_MALL_02.equals(goodsModel.getChannelMall())) {
				for (ItemModel itemModel : itemModelList) {
					itemIndexService.deltaItemIndex(itemModel.getCode());
				}
			} else {
				for (ItemModel itemModel : itemModelList) {
					itemIndexService.deleteItemIndex(itemModel.getCode());
				}
			}
		}
		return count;
	}

	/**
	 * 根据供应商ID下架该供应商下所有渠道的所有商品
	 *
	 * @param vendorId
	 * @return
	 */
	public Integer updateChannelByVendorId(String vendorId) {
		return goodsDao.updateChannelByVendorId(vendorId);
	}

	/**
	 * 批量更新商品状态
	 *
	 * @param goodsModelList
	 * @return
	 */
	public Integer updateAllGoodsStatus(List<GoodsModel> goodsModelList) {
		return goodsDao.updateAllGoodsStatus(goodsModelList);
	}

	/**
	 * 商品审核
	 *
	 * @param goodsCode
	 * @param approveType
	 * @param approveResult
	 * @param approveMemo
	 * @param user
	 */
	public boolean examGoods(String goodsCode, String approveType, String approveResult, String approveMemo,
			User user) {
		// approveType 用于区分是什么审核
		// 2:初审 3：复审 4：商品变更审核 5：商品价格变更审核 6：商品下架申请审核
		AuditLoggingModel auditLoggingModel = new AuditLoggingModel();
		GoodsModel goodsModel = new GoodsModel();
		GoodsDetailDto goodsDetailDto = new GoodsDetailDto();
		Boolean diffFlag = Boolean.FALSE;
		// 取得商品信息
		goodsModel = goodsDao.findById(goodsCode);
		if (APPROVE_TYPE_2.equals(approveType)) {
			if (APPROVE_RESULT_PASS.equals(approveResult)) {
				// 初审通过：审核状态变为复审
				goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_02);
				// 审核结果类型(通过)
				auditLoggingModel.setApproveType(Contants.PASS);
			} else {
				// 初审拒绝：审核状态变为初审拒绝
				goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_70);
				// 审核结果类型(拒绝)
				auditLoggingModel.setApproveType(Contants.REJECT);
			}
			// 审核履历业务类型
			auditLoggingModel.setBusinessType(Contants.SPSH_FIRST);
		} else if (APPROVE_TYPE_3.equals(approveType)) {
			if (APPROVE_RESULT_PASS.equals(approveResult)) {
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
				diffFlag = Boolean.TRUE;
			} else {
				// 复审拒绝：审核状态变为复审拒绝
				goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_71);
				// 审核结果类型(拒绝)
				auditLoggingModel.setApproveType(Contants.REJECT);
			}
			// 审核履历业务类型
			auditLoggingModel.setBusinessType(Contants.SPSH_SECOND);
		} else if (APPROVE_TYPE_4.equals(approveType)) {
			if (APPROVE_RESULT_PASS.equals(approveResult)) {
				// 商品变更审核通过：审核状态变为审核通过，销售状态不变，原商品信息更新
				goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_06);
				// 审核结果类型(通过)
				auditLoggingModel.setApproveType(Contants.PASS);
				diffFlag = Boolean.TRUE;
			} else {
				// 商品变更审核拒绝：审核状态变为商品审核拒绝，销售状态不变，原商品信息不变
				goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_72);
				// 审核结果类型(拒绝)
				auditLoggingModel.setApproveType(Contants.REJECT);
			}
			// 审核履历业务类型
			auditLoggingModel.setBusinessType(Contants.SPSH_CHANGE);
		} else if (APPROVE_TYPE_5.equals(approveType)) {
			if (APPROVE_RESULT_PASS.equals(approveResult)) {
				// 价格变更审核通过：审核状态变为审核通过，销售状态不变，价格更新
				goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_06);
				// 审核结果类型(通过)
				auditLoggingModel.setApproveType(Contants.PASS);
				diffFlag = Boolean.TRUE;
			} else {
				// 价格变更审核拒绝：审核状态变为价格变更审核拒绝，销售状态不变，价格不变
				goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_73);
				// 审核结果类型(拒绝)
				auditLoggingModel.setApproveType(Contants.REJECT);
			}
			// 审核履历业务类型
			auditLoggingModel.setBusinessType(Contants.SPSH_PRICE);
		} else {
			if (APPROVE_RESULT_PASS.equals(approveResult)) {
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
				// 审核结果类型(通过)
				auditLoggingModel.setApproveType(Contants.PASS);
				// 删除索引
				List<ItemModel> itemModelList = itemDao.findItemDetailByGoodCode(goodsModel.getCode());
				for (ItemModel itemModel : itemModelList) {
					itemIndexService.deleteItemIndex(itemModel.getCode());
				}
			} else {
				// 下架申请审核拒绝：审核状态变为下架申请审核拒绝，销售状态不变
				goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_74);
				// 审核结果类型(拒绝)
				auditLoggingModel.setApproveType(Contants.REJECT);
			}
			// 审核履历业务类型
			auditLoggingModel.setBusinessType(Contants.SPSH_OFFSHELF);
		}
		// 更新产品信息
		BeanMapper.copy(goodsModel, goodsDetailDto);
		try {
			goodsDetailDto.setGoodsCode(goodsModel.getCode());
			updateGoodsDetail(goodsDetailDto, user, diffFlag);
		} catch (Exception e) {
			e.printStackTrace();
		}

		// 产品ID不存在的情况，在复审通过后，调用新增产品接口
		if (goodsDetailDto.getProductId() == null && APPROVE_TYPE_3.equals(approveType) && APPROVE_RESULT_PASS.equals(approveResult)) {
			ProductModel productModel = new ProductModel();
			productModel.setBackCategory1Id(goodsDetailDto.getBackCategory1Id()); // 一级类目
			productModel.setBackCategory2Id(goodsDetailDto.getBackCategory2Id()); // 二级类目
			productModel.setBackCategory3Id(goodsDetailDto.getBackCategory3Id()); // 三级类目
			productModel.setGoodsBrandId(goodsDetailDto.getGoodsBrandId()); // 品牌ID
			productModel.setName(goodsDetailDto.getName()); // 名称
			productModel.setAttribute(goodsDetailDto.getAttribute()); // 属性
			productModel.setDelFlag(Contants.DEL_FLAG_0); // 逻辑删除标志位
			productModel.setOrdertypeId(Contants.BUSINESS_TYPE_YG);// 业务类型代码
			productModel.setStatus(Contants.USEING_COMMON_STATUS_0);// 产品状态
			productModel.setCreateType(Contants.CERATE_TYPE_ADMIN_0);// 创建类型
			productModel.setCreateOper(user.getName());
			if (!Strings.isNullOrEmpty(goodsDetailDto.getManufacturer())) {
				productModel.setManufacturer(goodsDetailDto.getManufacturer()); // 生产企业
			}
			Long productId = productDao.insert(productModel);
			// 更新商品表中产品ID字段
			GoodsModel goodsProduct = new GoodsModel();
			goodsProduct.setCode(goodsCode);
			goodsProduct.setProductId(productId);
			goodsProduct.setModifyOper(user.getName());
			goodsDao.update(goodsProduct);
		}

		// 审核履历
		auditLoggingModel.setOuterId(goodsCode); // 外部ID
		auditLoggingModel.setAuditor(user.getName()); // 审核人
		auditLoggingModel.setAuditorMemo(approveMemo); // 审核备注(审核意见)
		auditLoggingModel.setCreateOper(user.getName()); // 创建者
		auditLoggingModel.setModifyOper(user.getName()); // 修改者
		auditLoggingDao.insert(auditLoggingModel);

		return Boolean.TRUE;
	}

	/**
	 * 更新商品及单品详细信息
	 *
	 * @param goodsDetailDto
	 * @param user
	 * @param diffFlag
	 */
	private void updateGoodsDetail(GoodsDetailDto goodsDetailDto, User user, Boolean diffFlag) {
		GoodsModel goodsModel = new GoodsModel();
		ItemsAttributeDto goodAttr = null;
		GoodsDetailDto goodsDetail = new GoodsDetailDto();
		// 新的单品信息列表
		List<ItemModel> newItemList = new ArrayList<ItemModel>();
		if (Contants.GOODS_APPROVE_STATUS_70.equals(goodsDetailDto.getApproveStatus())
				|| Contants.GOODS_APPROVE_STATUS_71.equals(goodsDetailDto.getApproveStatus())
				|| Contants.GOODS_APPROVE_STATUS_72.equals(goodsDetailDto.getApproveStatus())
				|| Contants.GOODS_APPROVE_STATUS_73.equals(goodsDetailDto.getApproveStatus())
				|| Contants.GOODS_APPROVE_STATUS_74.equals(goodsDetailDto.getApproveStatus())
				// || Contants.GOODS_APPROVE_STATUS_01.equals(goodsDetailDto.getApproveStatus())
				|| Contants.GOODS_APPROVE_STATUS_02.equals(goodsDetailDto.getApproveStatus())) {
			// 审核状态是拒绝、待初审、待复审，只更新审核状态其他信息不变
			goodsModel.setCode(goodsDetailDto.getGoodsCode());
			goodsModel.setApproveStatus(goodsDetailDto.getApproveStatus());
			goodsModel.setModifyOper(user.getName());
			// 清空审核数据diff
			if (!Contants.GOODS_APPROVE_STATUS_02.equals(goodsDetailDto.getApproveStatus())) {
				goodsModel.setApproveDifferent("");
			}
			goodsDao.update(goodsModel);
			return;
		} else if (Contants.GOODS_APPROVE_STATUS_00.equals(goodsDetailDto.getApproveStatus())) {
			// 审核状态是编辑中，将attribute字段中的值放入属性表中
			goodAttr = jsonMapper.fromJson(goodsDetailDto.getAttribute(), ItemsAttributeDto.class);
			BeanMapper.copy(goodsDetailDto, goodsModel);
			BeanMapper.copy(goodsDetailDto, goodsDetail);
			newItemList = goodsDetailDto.getItemList();
		} else if (Contants.GOODS_APPROVE_STATUS_06.equals(goodsDetailDto.getApproveStatus())) {
			// 审核状态是审核通过，将approve_different字段中的值放入属性表中
			if (diffFlag.equals(Boolean.TRUE)) {
				// 将approve_different字段中的值放入属性表中
				goodsDetail = jsonMapper.fromJson(goodsDetailDto.getApproveDifferent(), GoodsDetailDto.class);
				goodAttr = jsonMapper.fromJson(goodsDetail.getAttribute(), ItemsAttributeDto.class);
				BeanMapper.copy(goodsDetail, goodsModel);
				newItemList = goodsDetail.getItemList();
				// 复审通过：审核状态变为审核通过
				goodsModel.setApproveStatus(goodsDetailDto.getApproveStatus());
				// 设定各渠道销售状态
				goodsModel.setChannelMall(goodsDetailDto.getChannelMall()); // 广发商城
				goodsModel.setChannelMallWx(goodsDetailDto.getChannelMallWx()); // 广发商城-微信
				goodsModel.setChannelCreditWx(goodsDetailDto.getChannelCreditWx()); // 信用卡中心-微信
				goodsModel.setChannelCc(goodsDetailDto.getChannelCc()); // CC
				goodsModel.setChannelPhone(goodsDetailDto.getChannelPhone()); // 手机商城
				goodsModel.setChannelApp(goodsDetailDto.getChannelApp()); // APP
				goodsModel.setChannelSms(goodsDetailDto.getChannelSms()); // 短信
				goodsModel.setCode(goodsDetailDto.getGoodsCode());
				if (Strings.isNullOrEmpty(goodsModel.getRecommendGoods1Code())) {
					goodsModel.setRecommendGoods1Code("");
				}
				if (Strings.isNullOrEmpty(goodsModel.getRecommendGoods2Code())) {
					goodsModel.setRecommendGoods2Code("");
				}
				if (Strings.isNullOrEmpty(goodsModel.getRecommendGoods3Code())) {
					goodsModel.setRecommendGoods3Code("");
				}
				goodsModel.setApproveDifferent("");
			} else {
				// 只更新下架和销售状态
				goodsModel.setCode(goodsDetailDto.getGoodsCode());
				goodsModel.setApproveStatus(goodsDetailDto.getApproveStatus());
				// 设定各渠道销售状态
				goodsModel.setChannelMall(goodsDetailDto.getChannelMall()); // 广发商城
				goodsModel.setChannelMallWx(goodsDetailDto.getChannelMallWx()); // 广发商城-微信
				goodsModel.setChannelCreditWx(goodsDetailDto.getChannelCreditWx()); // 信用卡中心-微信
				goodsModel.setChannelCc(goodsDetailDto.getChannelCc()); // CC
				goodsModel.setChannelPhone(goodsDetailDto.getChannelPhone()); // 手机商城
				goodsModel.setChannelApp(goodsDetailDto.getChannelApp()); // APP
				goodsModel.setChannelSms(goodsDetailDto.getChannelSms()); // 短信
				goodsModel.setModifyOper(user.getName());
				goodsModel.setApproveDifferent("");
				goodsDao.update(goodsModel);
				return;
			}
		}

		// 设定新增属性的KEY值
		String jsonGoods = setAttributeValueKey(goodsDetail.getAttribute());
		goodsModel.setAttribute(jsonGoods);
		goodsDao.update(goodsModel);

		// 单品更新前取得原有单品信息列表
		List<ItemModel> originalItemList = itemDao.findItemDetailByGoodCode(goodsModel.getCode());
		// 新增单品信息列表
		List<ItemModel> addItemList = new ArrayList<ItemModel>();
		// 更新单品信息列表
		List<ItemModel> updateItemList = new ArrayList<ItemModel>();
		// 删除单品信息列表
		List<ItemModel> deleteItemList = new ArrayList<ItemModel>();

		// 根据更新单品信息列表分为新增、更新、删除列表
		// 新增、更新列表
		for (int i = 0; i < newItemList.size(); i++) {
			// 新单品编码
			String newItemCode = newItemList.get(i).getCode();
			if (newItemCode == null || newItemCode.trim().equals("")) {
				// 新增单品
				addItemList.add(newItemList.get(i));
				continue;
			}
			for (int j = 0; j < originalItemList.size(); j++) {
				// 原单品编码
				String originalItemCode = originalItemList.get(j).getCode();
				if (newItemCode.equals(originalItemCode)) {
					// 更新单品
					updateItemList.add(newItemList.get(i));
					break;
				}
			}
		}
		// 删除列表
		for (int m = 0; m < originalItemList.size(); m++) {
			// 删除FLAG
			boolean deleteFlag = true;
			for (int n = 0; n < updateItemList.size(); n++) {
				if (originalItemList.get(m).getCode().equals(updateItemList.get(n).getCode())) {
					deleteFlag = false;
					break;
				}
			}
			if (deleteFlag) {
				deleteItemList.add(originalItemList.get(m));
			}
		}

		// 新增单品
		for (ItemModel itemModel : addItemList) {
			String itemCode = null;
			itemCode = idGenarator.id(IdEnum.ITEM, user.getId());
			itemModel.setCode(itemCode);
			itemModel.setGoodsCode(goodsModel.getCode());
			itemModel.setCreateOper(user.getName());
			itemModel.setModifyOper(user.getName());
			itemModel.setStickFlag(Contants.STICK_FLAG_0);
			String jsonItem = setAttributeValueKey(itemModel.getAttribute());
			itemModel.setAttribute(jsonItem);
		}
		if (addItemList != null && addItemList.size() != 0) {
			itemDao.insertBatch(addItemList);
		}
		// 更新单品
		for (ItemModel itemModel : updateItemList) {
			String jsonItem = setAttributeValueKey(itemModel.getAttribute());
			itemModel.setAttribute(jsonItem);
			itemDao.updateItem(itemModel);
		}

		// 删除单品
		for (ItemModel itemModel : deleteItemList) {
			itemModel.setDelFlag(Contants.DEL_FLAG_1);
			itemDao.update(itemModel);
		}
	}

	/**
	 * 设定属性KEY值
	 * 
	 * @param attributeString
	 * @return
	 */
	public String setAttributeValueKey(String attributeString) {
		ItemsAttributeDto goodAttr = jsonMapper.fromJson(attributeString, ItemsAttributeDto.class);
		if (goodAttr != null) {
			List<ItemAttributeDto> attributes = goodAttr.getAttributes();
			// 循环取出dto-attribute
			if (attributes != null) {
				for (ItemAttributeDto attribute : attributes) {
					if (StringUtils.isNotEmpty(attribute.getAttributeValueName())) {
						// 得到该vaule的name
						String attributeName = attribute.getAttributeValueName();
						// 创建AttributeValue实例 取得id所需
						AttributeValue attributeValue = new AttributeValue();
						attributeValue.setValue(attributeName);
						// 调用sevice返回该值得id
						Response<AttributeValue> attributeValueResponse = attributeValueService.create(attributeValue);
						// 得到attribute的Id并且返回给value
						Long attributeValueKey = attributeValueResponse.getResult().getId();
						attribute.setAttributeValueKey(attributeValueKey);
					}
				}
			}
			// 循环取出dto-skus-value下的lIST
			List<ItemsAttributeSkuDto> skus = goodAttr.getSkus();
			if(skus!=null){
				for (ItemsAttributeSkuDto sku : skus) {
					List<ItemAttributeDto> values = sku.getValues();
					if (values != null) {
						for (ItemAttributeDto value : values) {
							// 新增属性缺少key 取得名字不为空并且key为空的value
							// 对所有的name都进行复查 确定value值 没有value的增加有value的更新
							if (StringUtils.isNotEmpty(value.getAttributeValueName())) {
								// 得到该vaule的name
								String attributeName = value.getAttributeValueName();
								// 创建AttributeValue实例
								AttributeValue attributeValue = new AttributeValue();
								// 把name给实例
								attributeValue.setValue(attributeName);
								// 调用sevice返回该值得id
								Response<AttributeValue> attributeValueResponse = attributeValueService
										.create(attributeValue);
								// 得到attribute的Id并且返回给value
								Long attributeValueKey = attributeValueResponse.getResult().getId();
								value.setAttributeValueKey(attributeValueKey);
							}
						}
					}
				}
			}
		}
		String json = defaultJsonMapper.toJson(goodAttr);
		return json;
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
		// TODO 商品支付方式
		List<ItemModel> itemModelList = itemDao.findItemDetailByGoodCode(goodsDetailDto.getCode());
		TblVendorRatioModel tblVendorRatioModel = findVendorRatio(goodsDetailDto.getVendorId(), 1);
		Long incCode = null;
		if (tblVendorRatioModel != null) {
			incCode = tblVendorRatioModel.getId();
		}
		saveGoodsPayWay(itemModelList, user, goodsDetailDto.getMailOrderCode(), incCode);
	}

	/**
	 * 新增商品支付方式
	 * 
	 * @param itemModels
	 * @param user
	 */
	private void saveGoodsPayWay(List<ItemModel> itemModels, User user, String mailCode, Long incCode) {
		List<TblGoodsPaywayModel> paywayList = Lists.newArrayList();
		for (ItemModel itemModel : itemModels) {
			TblGoodsPaywayModel tblGoodsPaywayModel = new TblGoodsPaywayModel();
			tblGoodsPaywayModel.setGoodsPaywayId(idGenarator.id(IdEnum.PAY_WAY, user.getId()));
			tblGoodsPaywayModel.setPaywayCode("0001");
			tblGoodsPaywayModel.setGoodsId(itemModel.getCode());// 单品编码
			tblGoodsPaywayModel.setStagesCode(1);// 暂时默认为1期
			tblGoodsPaywayModel.setPerStage(itemModel.getPrice());
			tblGoodsPaywayModel.setIsAction("0");// 普通商品
			tblGoodsPaywayModel.setIscheck("1");// 商品审核状态，需修改
			tblGoodsPaywayModel.setCurStatus("0102");// 当前状态，默认为已启用
			tblGoodsPaywayModel.setCreateOper(user.getName());
			tblGoodsPaywayModel.setModifyOper(user.getName());
			tblGoodsPaywayModel.setIncCode(incCode);
			if (!Strings.isNullOrEmpty(itemModel.getStagesCode())) {
				tblGoodsPaywayModel.setCategoryNo(itemModel.getStagesCode());
			} else {
				tblGoodsPaywayModel.setCategoryNo(mailCode);
			}
			paywayList.add(tblGoodsPaywayModel);
		}
		tblGoodsPaywayDao.insertBatch(paywayList);
	}

	private TblVendorRatioModel findVendorRatio(String vendorId, Integer period) {
		TblVendorRatioModel tblVendorRatioModel = new TblVendorRatioModel();
		Response<TblVendorRatioModel> response = vendorService.findRatioByVendorId(vendorId, period);
		if (response.isSuccess()) {
			tblVendorRatioModel = response.getResult();
		}
		return tblVendorRatioModel;
	}

	/**
	 * 导出商品的新增
	 * 
	 * @param goodsItemDto
	 * @param user
	 * @return
	 */
	public GoodsAndItemCodeDto importGoodsData(GoodsItemDto goodsItemDto, User user) {
		GoodsAndItemCodeDto goodsAndItemCodeDto = new GoodsAndItemCodeDto();
		String goodsCode = "";
		String itemCode = "";
		// 导入商品的新增与正常的新增商品的区别：item传入的不是list
		if (goodsItemDto.getGoodsModel() != null) {
			// 1.整理数据--插入goods表
			GoodsModel goodsModel = goodsItemDto.getGoodsModel();
			// 1.1插入各渠道值--处理中（00）
			goodsModel.setChannelMall(Contants.CHANNEL_MALL_00);// 广发商城
			goodsModel.setChannelMallWx(Contants.CHANNEL_MALL_WX_00); // 广发商城-微信
			goodsModel.setChannelCreditWx(Contants.CHANNEL_CREDIT_WX_00); // 信用卡中心-微信
			goodsModel.setChannelCc(Contants.CHANNEL_CC_00); // CC
			goodsModel.setChannelPhone(Contants.CHANNEL_PHONE_00); // 手机商城
			goodsModel.setChannelApp(Contants.CHANNEL_APP_00); // APP
			goodsModel.setChannelSms(Contants.CHANNEL_SMS_00); // 短信
			// 1.2创建者、修改者
			goodsModel.setCreateOper(user.getName());
			goodsModel.setModifyOper(user.getName());
			// 1.3生成商品编码
			goodsCode = idGenarator.id(IdEnum.GOODS, user.getId());
			goodsModel.setCode(goodsCode);
			// 1.4创建类型(暂时写平台创建)
			goodsModel.setCreateType(Contants.CREATE_TYPE_0);
			// 1.5商品导入后审核状态默认为编辑中（00）
			goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_00);
			goodsDao.insert(goodsModel);
		}
		// 2.更新goods表attribute字段
		if (goodsItemDto.getGoodAttr() != null) {
			GoodsModel goodsModel = new GoodsModel();
			goodsModel.setAttribute(jsonMapper.toJson(goodsItemDto.getGoodAttr()));
			goodsModel.setCode(goodsItemDto.getItemModel().getGoodsCode());
			goodsDao.update(goodsModel);
		}
		// 3.插入item表
		ItemModel itemModel = goodsItemDto.getItemModel();
		// 3.1生成单品编码
		itemCode = idGenarator.id(IdEnum.ITEM, user.getId());
		itemModel.setCode(itemCode);
		// 3.2置顶标志--默认为非置顶（0）
		itemModel.setStickFlag(Contants.STICK_FLAG_0);
		// 3.3商品编码
		if (!Strings.isNullOrEmpty(goodsCode)) {
			itemModel.setGoodsCode(goodsCode);
		}
		itemDao.insert(itemModel);
		// 4.返回结果：goodscode和itemcode
		if (Strings.isNullOrEmpty(goodsCode)) {
			goodsAndItemCodeDto.setGoodsCode(itemModel.getGoodsCode());
		} else {
			goodsAndItemCodeDto.setGoodsCode(goodsCode);
		}
		goodsAndItemCodeDto.setItemCode(itemCode);
		return goodsAndItemCodeDto;
	}

}
