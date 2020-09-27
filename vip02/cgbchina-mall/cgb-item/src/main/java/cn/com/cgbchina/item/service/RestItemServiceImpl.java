package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.CouponScaleDao;
import cn.com.cgbchina.item.dao.GoodsCommendDao;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dao.PointPoolDao;
import cn.com.cgbchina.item.dao.TblGoodsPaywayDao;
import cn.com.cgbchina.item.dao.TblGoodsPointRegionDao;
import cn.com.cgbchina.item.dao.TblGoodsRecommendationJfDao;
import cn.com.cgbchina.item.dao.TblGoodsRecommendationYgDao;
import cn.com.cgbchina.item.dao.XnlpBZBXDao;
import cn.com.cgbchina.item.dao.XnlpCZBXDao;
import cn.com.cgbchina.item.dao.XnlpCZDLDao;
import cn.com.cgbchina.item.dao.XnlpLXSYDao;
import cn.com.cgbchina.item.dao.XnlpZQBXDao;
import cn.com.cgbchina.item.dto.CCJudgeGoodsDetailDto;
import cn.com.cgbchina.item.dto.GoodsDetailExtend;
import cn.com.cgbchina.item.dto.GoodsItemDto;
import cn.com.cgbchina.item.dto.RestGoodsPayWayDto;
import cn.com.cgbchina.item.dto.SPGoodsDetailDto;
import cn.com.cgbchina.item.dto.XnlpODSDto;
import cn.com.cgbchina.item.model.AppBackLogInfo;
import cn.com.cgbchina.item.model.AppGoodsDetailModel;
import cn.com.cgbchina.item.model.AppGoodsInfo;
import cn.com.cgbchina.item.model.AppStageInfo;
import cn.com.cgbchina.item.model.CCIntergalPresentParams;
import cn.com.cgbchina.item.model.CouponScaleModel;
import cn.com.cgbchina.item.model.GoodsCommendModel;
import cn.com.cgbchina.item.model.GoodsDetaillModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.GoodsPayWayModelExtend;
import cn.com.cgbchina.item.model.IntegrationGiftModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.PointPoolModel;
import cn.com.cgbchina.item.model.RestCCIntergalPresentDetail;
import cn.com.cgbchina.item.model.StageMallGoodsDetailStageInfoVO;
import cn.com.cgbchina.item.model.StageMallGoodsParams;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.model.TblGoodsPointRegionModel;
import cn.com.cgbchina.item.model.TblGoodsRecommendationYgModel;
import cn.com.cgbchina.item.model.XnlpBZBXModel;
import cn.com.cgbchina.item.model.XnlpCZBXModel;
import cn.com.cgbchina.item.model.XnlpCZDLModel;
import cn.com.cgbchina.item.model.XnlpLXSYModel;
import cn.com.cgbchina.item.model.XnlpZQBXModel;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.ACustToelectronbankModel;
import cn.com.cgbchina.user.service.ACustToelectronbankService;
import cn.com.cgbchina.user.service.EspCustNewService;
import cn.com.cgbchina.user.service.VendorService;
import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.category.service.BackCategoryService;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import lombok.extern.slf4j.Slf4j;

import org.elasticsearch.common.base.Strings;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static com.google.common.base.Strings.isNullOrEmpty;

@Service
@Slf4j
public class RestItemServiceImpl implements RestItemService {
	@Resource
	private ItemService itemService;
	@Resource
	private GoodsService goodsService;
	@Resource
	private PointPoolDao pointPoolDao;
	@Resource
	EspCustNewService espCustNewService;
	@Resource
	VendorService vendorService;
	@Resource
	private TblGoodsPaywayDao tblGoodsPaywayDao;
	@Resource
	private GoodsDao goodsDao;
	@Resource
	private ItemDao itemDao;
	@Resource
	private TblGoodsPointRegionDao tblGoodsPointRegionDao;
	@Resource
	private TblGoodsRecommendationJfDao tblGoodsRecommendationJfDao;
	DecimalFormat decimalFormat=new DecimalFormat("0.00");
//	@Resource
//	VendorInfoDao vendorInfoDao;
	@Resource
    BackCategoryService backCategoryService;
//	@Resource
//	GoodsRegionDao goodsRegionDao;
	@Resource
	private XnlpBZBXDao xnlpBZBXDao;
	@Resource
	private XnlpZQBXDao xnlpZQBXDao;
	@Resource
	private XnlpCZBXDao xnlpCZBXDao;
	@Resource
	private XnlpCZDLDao xnlpCZDLDao;
	@Resource
	private XnlpLXSYDao xnlpLXSYDao;
	@Resource
	private GoodsCommendDao goodsCommendDao;

	@Resource
	private ACustToelectronbankService aCustToelectronbankService;
	@Resource
	private CouponScaleDao couponScaleDao;
	@Resource
	private TblGoodsRecommendationYgDao tblGoodsRecommendationYgDao;
	@Resource
	private CfgIntegraltypeService cfgIntegraltypeService;

	@Override
	public Response<RestCCIntergalPresentDetail> findGoodsByItemid(String itemId, String origin) {
		// 请求传过来的5位的礼品编码 xid
		//ItemModel itemModel = itemService.findById(itemId);
		ItemModel itemModel = itemDao.findItemByXid(itemId);
		Response<RestCCIntergalPresentDetail> response = new Response<RestCCIntergalPresentDetail>();
		RestCCIntergalPresentDetail result = null;
		try {
			if (itemModel != null) {
				Response<GoodsModel> goodsModelResp = goodsService.findById(itemModel.getGoodsCode());
				if(goodsModelResp != null && !goodsModelResp.isSuccess()){
					log.error("Response.error,error code: {}", goodsModelResp.getError());
					throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
				}
				if (goodsModelResp != null && goodsModelResp.getResult() != null) {
					GoodsModel goodsModel = goodsModelResp.getResult();
					// 查询礼品在相应 的渠道是否已经 上架
					boolean ccflag = ("01".equals(origin) && goodsModel.getChannelCc().equals("02"));
					boolean ivrFlag = "02".equals(origin) && goodsModel.getChannelIvr().equals("02");
					if (ccflag || ivrFlag) {
						result = new RestCCIntergalPresentDetail();
						result.setGoodsName(goodsModel.getName());// 礼品名称
						result.setVendorId(goodsModel.getVendorId());// 合作商ID
//						Response<String> colorResp = itemAttributeService.findSkusValue(itemModel.getAttribute(), "颜色");
//						Response<String> goodsModelValueResp = itemAttributeService.findSkusValue(
//								itemModel.getAttribute(), "型号");
//						if (colorResp.isSuccess()) {
//							result.setGoodsColor(colorResp.getResult());// 礼品颜色
//						}
//						if (goodsModelResp.isSuccess()) {
//							result.setGoodsModel(goodsModelValueResp.getResult());// 型号
//						}
						
						String color = "";
						String model = "";
						if(itemModel.getAttributeKey1() != null){
							if(itemModel.getAttributeKey1().contains("颜色")){
								color = itemModel.getAttributeName1();
							}
							if(itemModel.getAttributeKey1().contains("型号")){
								model = itemModel.getAttributeName1();
							}
						}
						if(itemModel.getAttributeKey2() != null){
							if(itemModel.getAttributeKey2().contains("颜色")){
								color = itemModel.getAttributeName2();
							}
							if(itemModel.getAttributeKey2().contains("型号")){
								model = itemModel.getAttributeName2();
							}
						}
						result.setGoodsColor(color);//颜色
						result.setGoodsModel(model);//型号
						
						result.setGoodsMsg(itemModel.getFreightWeight());// 包装信息
						result.setGoodsGuarantee(goodsModel.getServiceType());// 报修条款

						result.setGoodsPresent(goodsModel.getGiftDesc());// 赠品
						result.setGoodsPresentDesc(goodsModel.getGiftDesc());// 赠品说明
						result.setGoodsDesc(goodsModel.getGoodsMemo());// 礼品备注
						result.setGoodsDetailDesc(goodsModel.getIntroduction());// 礼品描述
						response.setResult(result);
					}
				}
			}
		} catch (RuntimeException ex) {
			// throw new
			// RuntimeException("[MAL102 CC积分商城礼品详细查询 通过GOODID查找礼品 ResetItemServiceImpl.findGoodsByItemid ]\n",
			// ex);
			log.error("[MAL102 CC积分商城礼品详细查询 通过GOODID查找礼品 ResetItemServiceImpl.findGoodsByItemid ]\n", ex);
		}

		return response;
	}

	@Override
	public Response<List<GoodsPayWayModelExtend>> findGoodsByBackCategory1Id(Long backCategory1Id) {
		Response<List<GoodsPayWayModelExtend>> resp = new Response<List<GoodsPayWayModelExtend>>();
		try {
			List<GoodsPayWayModelExtend> goodsPayWayModelExtends = new ArrayList<GoodsPayWayModelExtend>();
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("backCategory1Id", backCategory1Id);
			params.put("delFlag", 0);
			params.put("channelMall", "02");
			params.put("approveStatus", "06");
			params.put("onShelfCcDate", new Date());
			params.put("offShelfCcDate", new Date());
			// 查找 GOODS
			Pager<GoodsModel> goodsModels = goodsDao.findByPage(params, 0, 20);
			if (goodsModels != null && goodsModels.getData() != null) {
				List<GoodsModel> goodsMoList = goodsModels.getData();
				List<String> goodsIds = new ArrayList<String>();// 记录GOODSID，查询items和tblGoodsPayWay
				for (GoodsModel goodsModel : goodsMoList) {
					GoodsPayWayModelExtend goodsPayWayModelExtend = new GoodsPayWayModelExtend();
					goodsPayWayModelExtend.setGoodsId(goodsModel.getCode());
					goodsPayWayModelExtend.setVendorId(goodsModel.getVendorId());
					goodsPayWayModelExtend.setGoodsNm(goodsModel.getName());
					goodsIds.add(goodsModel.getCode());
					goodsPayWayModelExtends.add(goodsPayWayModelExtend);

				}
				List<ItemModel> itemModels = itemDao.findItemListByGoodsCodeList(goodsIds);
				// 匹配itemModel里面的属性 图片路径 详细页面URL
				if (itemModels != null) {
					for (GoodsPayWayModelExtend goodsPayWayModelExtend : goodsPayWayModelExtends) {
						for (ItemModel itemModel : itemModels) {
							if (goodsPayWayModelExtend.getGoodsId().equals(itemModel.getGoodsCode())) {
								// TODO:图片裁切没做
								goodsPayWayModelExtend.setPictureUrl(itemModel.getImage1());
								// TODO:详细URL没拼
								goodsPayWayModelExtend.setGoodsUrl("");
								goodsPayWayModelExtend.setXid(itemModel.getXid());
								// TODO:MID OID未补全
								goodsPayWayModelExtend.setMid("");
								goodsPayWayModelExtend.setOid("");
								break;
							}
						}
					}
				}
				List<TblGoodsPaywayModel> tblGoodsPaywayModels = tblGoodsPaywayDao.findByGoodsIds(goodsIds);
				// 查找单品支付方式 并匹配
				if (tblGoodsPaywayModels != null) {
					for (GoodsPayWayModelExtend goodsPayWayModelExtend : goodsPayWayModelExtends) {
						for (TblGoodsPaywayModel tblGoodsPaywayModel : tblGoodsPaywayModels) {
							if (goodsPayWayModelExtend.getGoodsId().equals(tblGoodsPaywayModel.getGoodsId())) {
								goodsPayWayModelExtend.setGoodsPrice(tblGoodsPaywayModel.getGoodsPrice());
								goodsPayWayModelExtend.setStagesCode(tblGoodsPaywayModel.getStagesCode());
								goodsPayWayModelExtend.setPerStage(tblGoodsPaywayModel.getPerStage());
								// goodsPayWayModelExtend.setPerStage()
								break;
							}
						}
					}
				}
				resp.setResult(goodsPayWayModelExtends);

			}
		} catch (RuntimeException ex) {
			log.error("通过第三类目找查相应的商品 (MAL109用)异常", ex);
		}
		// tblGoodsPaywayDao.findByPage(params, 0, 20);
		return resp;
	}

	@Override
	public Response<Integer> getRegionFromBonus(long bonus) {
		Response<Integer> response = new Response<Integer>();
		try {
			// 查询所有未删除的积分区间
			List<TblGoodsPointRegionModel> tblGoodsPointRegions = tblGoodsPointRegionDao.getRegionFromBonus();
			for (int i = 0; i < tblGoodsPointRegions.size(); i++) {
				TblGoodsPointRegionModel tblGoodsPointRegion = tblGoodsPointRegions.get(i);
				Long minPoint = tblGoodsPointRegion.getMinPoint();
				Long maxPoint = tblGoodsPointRegion.getMaxPoint();
				if (maxPoint != null) {// 如果积分上限不为空
					if (bonus >= minPoint && bonus < maxPoint) {
						response.setResult(tblGoodsPointRegion.getRegionId());
						return response;
					}
				} else if (maxPoint == null) {// 如果积分上限为空，代表上限为无限
					if (bonus >= minPoint) {
						response.setResult(tblGoodsPointRegion.getRegionId());
						return response;
					}
				}
			}
			// 没有数据返回-1
			response.setResult(-1);
			return response;
		} catch (Exception e) {
			// 设置执行失败
			response.setError("select.getRegionFromBonus.error");
			// 查询失败写入log
			log.error("select.getRegionFromBonus.error", Throwables.getStackTraceAsString(e));
		}
		return response;
	}

	@Override
	public Response<List<IntegrationGiftModel>> getItemGiftListByRegionId(Integer regionId) {
		Response<List<IntegrationGiftModel>> response = new Response<List<IntegrationGiftModel>>();
		try {
			List<String> itemCodeList = null;
			// 根据积分区间ID 查询所有推荐礼品
			itemCodeList = tblGoodsRecommendationJfDao.findItemCodeListByRegionId(regionId);
			// 如果没有积分区间推荐礼品
			if (itemCodeList == null || itemCodeList.size() == 0) {
				response.setResult(new ArrayList<IntegrationGiftModel>());
				return response;
			}
			// 定义返回数据
			List<IntegrationGiftModel> resultDataList = new ArrayList<IntegrationGiftModel>();
			// 如果推荐礼品个数大于0则根据单品ID拼装礼品数据
			Response<List<ItemModel>> itemDetailList = itemService.findByCodesNoOrder(itemCodeList);
			if (itemDetailList.isSuccess()) {
				List<ItemModel> itemList = itemDetailList.getResult();
				if (itemList.size() > 0) {
					List<String> goodsCodeList = new ArrayList<String>();
					for (ItemModel itemModel : itemList) {
						// 设置 goodsCode
						goodsCodeList.add(itemModel.getGoodsCode());
					}
					// 根据goodsCodeList查详情列表
					makeGiftDetail(response, resultDataList, itemList, goodsCodeList);
				}
			} else {
				log.error("【RestItemServiceImpl.getItemGiftListByRegionId】根据itemCodes查询item详情列表失败");
			}
		} catch (Exception e) {
			response.setError("select.getItemGiftListByRegionId.error");
			log.error("select.getItemGiftListByRegionId.error", Throwables.getStackTraceAsString(e));
		}
		return response;
	}

	private void makeGiftDetail(Response<List<IntegrationGiftModel>> response,
			List<IntegrationGiftModel> resultDataList, List<ItemModel> itemList, List<String> goodsCodeList) {
		Response<List<GoodsModel>> goodsGiftResult = goodsService.findGiftByCodes(goodsCodeList);
		if (goodsGiftResult.isSuccess()) {
			List<GoodsModel> goodsModelList = goodsGiftResult.getResult();
			if (goodsModelList != null ) {
				for (GoodsModel goodsModel : goodsModelList) {

					for (ItemModel itemModel : itemList) {
						if(itemModel.getGoodsCode().equals(goodsModel.getCode())){
							IntegrationGiftModel giftModel = new IntegrationGiftModel();
							giftModel.setGoodsCode(goodsModel.getCode());

							// 设置vendorId
							giftModel.setVendorId(goodsModel.getVendorId());
							// 根据合作商Id取得合作商信息
							String vendor_fnm = "";
							if (goodsModel.getVendorId() != null && !goodsModel.getVendorId().isEmpty()) {
								Response<VendorInfoDto> vendorInfoResponse = vendorService.findById(goodsModel.getVendorId());
								if (vendorInfoResponse.isSuccess()) {
									vendor_fnm = vendorInfoResponse.getResult().getFullName();
								}

							}
							// 设置供应商全名
							giftModel.setVendorFnm(vendor_fnm);
							// 设置商品名称
							giftModel.setName(goodsModel.getName());

							// 设置itemCode
							giftModel.setItemCode(itemModel.getCode());
							// 设置xid
							giftModel.setXid(itemModel.getXid());
							// 设置积分数量 （这里是金普积分）
							Long goodsPoint = null;
							// itemCode不为空 则查询积分数量
							if (itemModel.getCode() != null) {
								List<TblGoodsPaywayModel> list = tblGoodsPaywayDao
										.findGoodsPaywayModelListByItemCode(itemModel.getCode());
								if (list != null && list.size() > 0) {
									TblGoodsPaywayModel tblGoodsPaywayModel = list.get(0);
									if (tblGoodsPaywayModel != null) {
										goodsPoint = tblGoodsPaywayModel.getGoodsPoint();
									}
								}
							}
							// 设置金普积分数量
							giftModel.setJpBonus(goodsPoint);
							// 设置图片地址
							giftModel.setPictureUrl(itemModel.getImage1());
							// 添加到返回数据的VO
							resultDataList.add(giftModel);
						}
					}


					// 设置返回值
					response.setResult(resultDataList);
				}
			} else {
				response.setResult(new ArrayList<IntegrationGiftModel>());
			}
		} else {
			log.error("【RestItemServiceImpl.getItemGiftListByRegionId】根据goodsCodes查询goodsGift详情列表失败");
		}
	}

	/**
	 * Description MAL322: 获取客户可使用生日价的次数
	 *
	 * @param custId
	 * @return
	 */
	@Override
	public Response<String> findCustBirthTimes(String custId) {
		// TODO
		Response<String> response = new Response<>();
		Response<Integer> espCustNewResponse = espCustNewService.findBirthAvailableCount(custId, Integer.valueOf(10));
		String birthUsedCount = "";
		if (espCustNewResponse.isSuccess()) {
			birthUsedCount = String.valueOf(espCustNewResponse.getResult());
		}
		response.setSuccess(true);
		response.setResult(birthUsedCount);
		return response;
	}

	/**
	 * Description : MAL322: 获取最优等级支付方式
	 *
	 * @param custLevel
	 * @param goodsId
	 * @return
	 */
	@Override
	public Response<TblGoodsPaywayModel> findPreferencePayway(String custLevel, String goodsId) {
		Response<TblGoodsPaywayModel> response = new Response<>();
		if (!isNullOrEmpty(custLevel) && !isNullOrEmpty(goodsId)) {
			List<TblGoodsPaywayModel> goodsPaywayModels = tblGoodsPaywayDao.findByGoodsIds(Lists.newArrayList(goodsId));
			List<String> paywayList = getPaywayList(custLevel);
			for (String payway : paywayList) {
				for (TblGoodsPaywayModel goodsPayway : goodsPaywayModels) {
					if (payway.equals(goodsPayway.getMemberLevel())
							&& Contants.PAY_WAY_CODE_JF.equals(goodsPayway.getPaywayCode())) {
						response.setResult(goodsPayway);
						response.setSuccess(true);
						return response;
					}
				}
			}
		} else {
			response.setSuccess(false);
		}
		return response;
	}

	/**
	 * Description : 根据客户最优界别返回纯积分 支付的最优价格级别
	 *
	 * @param custLevel
	 * @return
	 */
	public List<String> getPaywayList(String custLevel) {
		List<String> paywayList = Lists.newArrayList();
		if (Contants.MEMBER_LEVEL_DJ_CODE.equals(custLevel)) {
			paywayList.add(Contants.MEMBER_LEVEL_DJ_CODE);
			paywayList.add(Contants.MEMBER_LEVEL_TJ_CODE);
			paywayList.add(Contants.MEMBER_LEVEL_JP_CODE);
		} else if (Contants.MEMBER_LEVEL_TJ_CODE.equals(custLevel)) {
			paywayList.add(Contants.MEMBER_LEVEL_TJ_CODE);
			paywayList.add(Contants.MEMBER_LEVEL_JP_CODE);
		} else if (Contants.MEMBER_LEVEL_VIP_CODE.equals(custLevel)) {
			paywayList.add(Contants.MEMBER_LEVEL_VIP_CODE);
			paywayList.add(Contants.MEMBER_LEVEL_JP_CODE);
		} else {
			paywayList.add(Contants.MEMBER_LEVEL_JP_CODE);
		}
		return paywayList;
	}

	/**
	 * 接口322: 判断客户卡板和商品卡板是否满足需求
	 *
	 * @author xiewl
	 */
	@Override
	public Response<Boolean> judgeCardFormatNbr(String goodsId, List<String> cardFormatNbrs) {
		Response<Boolean> response = new Response<>();
		ItemModel itemModel = itemService.findById(goodsId);
		
		if (itemModel != null) {
			GoodsModel goodsModel = goodsDao.findById(itemModel.getGoodsCode());
			String formatId = goodsModel.getCards();
			// 如果商品的卡板代码设置了WWWW，这不进行校验
			if ("WWWW".equals(formatId)) {
				response.setResult(true);
				return response;
			}
			if (formatId == null || "".equals(formatId.trim())) {
				// TODO : 如果卡板id为空，则从分区表中获取卡板信息，但新商城取消分区表
				tblGoodsPointRegionDao.findById(Integer.valueOf(goodsModel.getRegionType()));
				response.setResult(false);
				return response;
			}
			String[] fIds = formatId.split(",");
			if (cardFormatNbrs != null) {
				for (String fId : fIds) {
					if (!isNullOrEmpty(fId)) {
						for (String cardFormatNbr : cardFormatNbrs) {
							if (fId.equals(cardFormatNbr)) {
								response.setResult(true);
								return response;
							}
						}
					}
				}
			}
		}
		response.setResult(false);
		return response;
	}

	/**
	 * Description : MAL322: 获取生日价支付方式
	 *
	 * @param goodsId
	 * @return
	 */
	@Override
	public Response<TblGoodsPaywayModel> findBirthPayway(String goodsId) {
		Response<TblGoodsPaywayModel> response = new Response<>();
		Map<String, Object> params = Maps.newHashMap();
		params.put("goodsId", goodsId);
		params.put("memberLevel", Contants.MEMBER_LEVEL_BIRTH_CODE);
		Pager<TblGoodsPaywayModel> pager = tblGoodsPaywayDao.findByPage(params, 0, 100);
		List<TblGoodsPaywayModel> paywayModels = pager.getData();
		if (paywayModels != null && paywayModels.size() > 0) {
			TblGoodsPaywayModel paywayModel = paywayModels.get(0);
			response.setSuccess(true);
			response.setResult(paywayModel);
		} else {
			response.setSuccess(false);
			response.setError("no data");
		}
		return response;
	}

	/**
	 * Description : MAL322: 获取积分加现金支付方式
	 *
	 * @param goodsId
	 * @return
	 */
	@Override
	public Response<TblGoodsPaywayModel> findJmPayway(String goodsId) {
		Response<TblGoodsPaywayModel> response = new Response<>();
		Map<String, Object> params = Maps.newHashMap();
		params.put("goodsId", goodsId);
		params.put("memberLevel", Contants.MEMBER_LEVEL_INTEGRAL_CASH_CODE);
		Pager<TblGoodsPaywayModel> pager = tblGoodsPaywayDao.findByPage(params, 0, 100);
		List<TblGoodsPaywayModel> paywayModels = pager.getData();
		if (paywayModels != null && paywayModels.size() > 0) {
			TblGoodsPaywayModel paywayModel = paywayModels.get(0);
			response.setSuccess(true);
			response.setResult(paywayModel);
		} else {
			response.setSuccess(false);
			response.setError("no data");
		}
		return response;
	}

	// /**
	// * Description : 通用 根据id获取分区信息
	// *
	// * @param id
	// * @return
	// */
	// @Override
	// public Response<GoodsRegionModel> findGoodsRegionById(String id) {
	// Response<GoodsRegionModel> response = new Response<>();
	// GoodsRegionModel goodsRegion = goodsRegionDao.findById(Long.valueOf(id));
	// response.setSuccess(true);
	// if (goodsRegion != null) {
	// response.setResult(goodsRegion);
	// } else {
	// response.setResult(new GoodsRegionModel());
	// }
	// return response;
	// }

	/**
	 * Description : MAL202 IVR排行列表查询 根据商品列表查出对应库存大于0且在上架时间内的商品
	 *
	 * @param itemCodes
	 * @return
	 */
	@Override
	public Response<List<GoodsItemDto>> findIVRRankGoodsInfoByGoodsCodes(List itemCodes) {
		List<ItemModel> itemModelList = itemDao.findByCodes(itemCodes);
		List<String> goodsCodes = new ArrayList<String>();
		List<GoodsItemDto> goodsItemDtos = new ArrayList<GoodsItemDto>();
		Response<List<GoodsItemDto>> response = new Response<List<GoodsItemDto>>();
		if (itemModelList != null) {
			for (ItemModel item : itemModelList) {
				if (!goodsCodes.contains(item.getGoodsCode())) {
					goodsCodes.add(item.getGoodsCode());
				}
			}
			// 获取商品信息
			List<GoodsModel> goodsModels = goodsDao.findOnSaleGoodsByCode(goodsCodes);
			// 获取支付方式
			List<TblGoodsPaywayModel> goodsPayways = tblGoodsPaywayDao.findByGoodsIdsNoActive(itemCodes);

			for (ItemModel item : itemModelList) {
				for (GoodsModel good : goodsModels) {
					if (item.getGoodsCode().equals(good.getCode())) {
						GoodsItemDto goodsItemDto = new GoodsItemDto();
						goodsItemDto.setGoodsModel(good);
						goodsItemDto.setItemModel(item);
						goodsItemDtos.add(goodsItemDto);
						break;
					}
				}
			}
			for (GoodsItemDto goodsDto : goodsItemDtos) {
				List<TblGoodsPaywayModel> goodsPaywaysForDto = Lists.newArrayList();
				for (TblGoodsPaywayModel payway : goodsPayways) {
					if (goodsDto.getItemModel().getCode().equals(payway.getGoodsId())) {
						goodsPaywaysForDto.add(payway);
					}
				}
				goodsDto.setTblGoodsPaywayModels(goodsPaywaysForDto);
			}
			response.setResult(goodsItemDtos);
		}
		response.setSuccess(true);
		return response;
	}

	/*
	 * (non-Javadoc)
	 *
	 * @see
	 * cn.com.cgbchina.item.service.RestItemService#getGoodsDetailByItemCodeAndOmid
	 * (java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public Response<GoodsDetaillModel> getGoodsDetailByItemCodeAndOmid(String omid, String itemCode, String contIdCard) {
		// 定义最终返回结果集
		Response<GoodsDetaillModel> result = new Response<>();
		GoodsDetaillModel goodsDetail = new GoodsDetaillModel();
		// 查询商品信息 itemCode
		Response<ItemModel> itemResponse = null;
		ItemModel item  = null;
		GoodsModel goods = null;
		if (Strings.isNullOrEmpty(omid) && Strings.isNullOrEmpty(itemCode)) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("channelCc", "02");
			params.put("ordertypeId", Contants.BUSINESS_TYPE_YG );
			Pager<GoodsModel> goodsPager =  goodsDao.findByPage(params, 0, 10);
			if (goodsPager!= null && goodsPager.getData() != null) {
				goods = goodsPager.getData().get(0);
				Map<String, Object> itemParam = new HashMap<String, Object>();
				itemParam.put("goodsCode", goods.getCode());
				Pager<ItemModel> itemPager = itemService.findByPage(itemParam, 0, 10);
				if (itemPager !=null && itemPager.getData() != null) {
					item = itemPager.getData().get(0);
				}
			}
		}else{			
			itemResponse = itemService.findByIdAndOidOrMid(itemCode, omid);
			if (itemResponse.isSuccess()) {
			item = itemResponse.getResult();
			} else {
				result.setError("【getGoodsDetailByItemCodeAndOmid.item.error】根据omid:" + omid + "和itemcode:" + itemCode
						+ "获取商品失败");
			}
		}
		if (item != null) {
			// goods赋值
			goods = goodsDao.findGoodsByGoodsCode(item.getGoodsCode());
			if (goods == null) {// 没有查询到商品
				result.setSuccess(false);
				result.setResult(null);
				return result;
			}
			goodsDetail.setGoodsId(item.getCode());
			// 商品名称
			goodsDetail.setGoodsNm(goods.getName());
			goodsDetail.setGoodsMid(item.getMid());
			goodsDetail.setGoodsOid(item.getOid());
			goodsDetail.setGoodsXid(item.getXid());
			goodsDetail.setGoodsPrice(item.getPrice() == null ? null : item.getPrice().toString());
			// 供应商ID 在goods表
			goodsDetail.setVendorId(goods.getVendorId());
			// 查库给vendorInfoMode赋值
			Response<VendorInfoDto> vendorInfoModeResponse = vendorService.findById(goods.getVendorId());
			VendorInfoDto vendorInfoDto = new VendorInfoDto();
			if (vendorInfoModeResponse.isSuccess()&& vendorInfoModeResponse.getResult() !=null) {// 如果没供应商ID则new空的供应商
				vendorInfoDto = vendorInfoModeResponse.getResult();
			}
			// 供应商名称
			goodsDetail.setVendorFnm(vendorInfoDto.getFullName());
			// 供应商名称
			goodsDetail.setVendorSnm(vendorInfoDto.getSimpleName());
//				// 三级后台类目
//				// 缓存取分类名
//				// 二级后台类目
			// 获取 颜色和尺寸属性代码
			String color = null;
			String size = null;
			if(item.getAttributeKey1() != null){
				if(item.getAttributeKey1().contains("颜色")){
					color = item.getAttributeName1();
				}
				if(item.getAttributeKey1().contains("尺寸")){
					size = item.getAttributeName1();
				}
			}
			if(item.getAttributeKey2() != null){
				if(item.getAttributeKey2().contains("颜色")){
					color = item.getAttributeName2();
				}
				if(item.getAttributeKey2().contains("尺寸")){
					size = item.getAttributeName2();
				}
			}
			
			// 继续赋值
			goodsDetail.setGoodsColor(color);
			goodsDetail.setGoodsSize(size);
			goodsDetail.setGoodsBacklog(item.getStock() == null ? null : item.getStock().toString());
			goodsDetail.setGoodsBaseDesc(goods.getGoodsBaseDesc());
			goodsDetail.setGoodsDetailDesc(goods.getIntroduction());
			goodsDetail.setPhone(vendorInfoDto.getPhone());
			// 原代码设置的就是null字符串
			goodsDetail.setPaywayIdY("null");
			goodsDetail.setGoodsPresent(goods.getGiftDesc());
			// 根据item编号得到分期商品支付方式 集合
			List<TblGoodsPaywayModel> payList = tblGoodsPaywayDao.getGoodsPayawy(item.getCode());
			String goods_price = "";
			String is_action = "";
			String use_coupon = "";
			List<StageMallGoodsDetailStageInfoVO> datalist = new ArrayList<>();
			if (payList != null && payList.size() > 0) {
				int loop_count = payList.size();
				goodsDetail.setLoopCount(String.valueOf(loop_count));// 循环域大小
				for (int index = 0; index < payList.size(); index++) {
					TblGoodsPaywayModel payObj = payList.get(index);
					goods_price = dealNull(payObj.getGoodsPrice());
					is_action = dealNull(payObj.getIsAction());
					if(payObj.getStagesCode() != null && payObj.getStagesCode() >1){
						StageMallGoodsDetailStageInfoVO stageInfoVO = new StageMallGoodsDetailStageInfoVO();
						stageInfoVO.setStagesNum(dealNull(payObj.getStagesCode()));
						stageInfoVO.setPerStage(dealNull(payObj.getPerStage()));
						stageInfoVO.setPaywayIdF(dealNull(payObj.getGoodsPaywayId()));
						datalist.add(stageInfoVO);
					}
				}
			}
			goodsDetail.setStageMallGoodsDetailStageInfos(datalist);
			goodsDetail.setGoodsPrice(goods_price);// 总价
			log.info("商品总价：" + goods_price);
			// TODO 活动类型 0:普通商品 1:团购 2:秒杀
			// TODO 由于依赖 在外层获取
			// -----------------------
			goodsDetail.setActionType("");// 1:团购 2:秒杀 0:普通商品
			// -----------------------

			// 优惠券需求中关于积分

			// 优惠券需求中关于积分 获取当前年月
			String curMonth = (new SimpleDateFormat("yyyyMM")).format(new Date());
			String canIntegral = "";// 可兑换积分 倍率X售价X单位积分
			String unitIntegral = "";// 单位积分
			// 根据当前月份来查询对应的积分池数据
			List<PointPoolModel> l = pointPoolDao.getPointPool(curMonth);
			long availableIntegral = 0;// 积分池剩余积分
			if (l != null && l.size() > 0) {
				PointPoolModel m = (PointPoolModel) l.get(0);
				String maxPoint = dealNull(m.getMaxPoint());
				String usedPoint = dealNull(m.getUsedPoint());
				unitIntegral = dealNull(m.getSinglePoint());
				String pointRate = dealNull(m.getPointRate());// 全局倍率
				String bestRate = dealNull(item.getBestRate());// 产品倍率
				log.info("当月最大积分数：" + maxPoint + "已用积分数：" + usedPoint + "最高倍率：" + pointRate + "产品倍率:" + bestRate);
				// 倍率优先取"产品倍率"，若"产品倍率"为空，则取"全局倍率"
				String rate = "".equals(bestRate) ? pointRate : bestRate;
				if (!"".equals(maxPoint)) {
					availableIntegral = Long.parseLong(maxPoint) - Long.parseLong(usedPoint);
					if (availableIntegral > 0) {// 剩余积分大于0时，才能使用积分抵扣
						canIntegral = String.valueOf(Math.round(Long.parseLong(unitIntegral) * Double.parseDouble(rate)
								* Double.parseDouble(goods_price)));// 单位积分X倍率X售价
					}
				}
			}
			// 可用积分
			goodsDetail.setCanIntegral(canIntegral);
			// 单位积分
			goodsDetail.setUnitIntegral(unitIntegral);
		}else {
			result.setSuccess(false);
			result.setResult(null);
			return result;
		}
		result.setSuccess(true);
		result.setResult(goodsDetail);
		return result;
	}

	public static String dealNull(Object str) {
		if (str == null) {
			return "";
		}
		return str.toString().trim();
	}

	/**
	 * Description : MAL312 获取支付方式
	 *
	 * @param stageMallGoodsParams
	 * @return
	 * @author xiewl
	 */
	@Override
	public Response<List<TblGoodsPaywayModel>> queryGoodsPayway(StageMallGoodsParams stageMallGoodsParams) {
		Response<List<TblGoodsPaywayModel>> response = new Response<List<TblGoodsPaywayModel>>();
		HashMap<String, Object> queryParams = Maps.newHashMap();
		String mallType = stageMallGoodsParams.getMallType();
		queryParams.put("ischeckNot", "d");
		queryParams.put("curStatus", Contants.CUR_STATUS_0102);
		if ("01".equals(mallType)) {// 分期

		} else {
			queryParams.put("goodsPointRange", stageMallGoodsParams.getQuerybyPointRange());
		}
		try {
			Pager<TblGoodsPaywayModel> pager = tblGoodsPaywayDao.findByPage(queryParams, 0, Integer.MAX_VALUE);
			if (pager != null && pager.getTotal() > 0) {
				response.setSuccess(true);
				response.setResult(pager.getData());
				return response;
			} else {
				response.setSuccess(false);
				response.setError("query.goodsPayway.false");
				return response;
			}
		} catch (Exception e) {
			log.error("get.goodsPayway.error", e);
			response.setSuccess(false);
			response.setError("query.goodsPayway.false");
			return response;
		}

	}

	/**
	 * Description : MAL312 获取商品信息
	 *
	 * @param stageMallGoodsParams
	 * @return
	 */
	@Override
	public Response<List<GoodsModel>> findGood(StageMallGoodsParams stageMallGoodsParams) {
		Response<List<GoodsModel>> response = new Response<List<GoodsModel>>();
		HashMap<String, Object> queryParams = Maps.newHashMap();
		String mallType = stageMallGoodsParams.getMallType();
		if ("01".equals(mallType)) {// 分期
			queryParams.put("nowOnShelfMallDate", true);
			// 查询条件
			String query = stageMallGoodsParams.getQuery();
			//if (!Strings.isNullOrEmpty(query)) {
			//	queryParams.put("name", query);
			//}
			// 后台三级类目
			String backCategory3Id = stageMallGoodsParams.getTypeId();
			if (!isNullOrEmpty(backCategory3Id)) {
				queryParams.put("backCategory3Id", backCategory3Id);
			}
			// 后台二级类目
			String backCategory2Id = stageMallGoodsParams.getTypePid();
			if (!isNullOrEmpty(backCategory2Id)) {
				queryParams.put("backCategory2Id", backCategory2Id);
			}
			String orgin = stageMallGoodsParams.getOrigin();
			if (Contants.CHANNEL_SN_WX.equals(orgin)) {
				queryParams.put("channelMallWx", Contants.CHANNEL_MALL_WX_02);
			} else if (Contants.CHANNEL_SN_WS.equals(orgin)) {
				queryParams.put("channelCreditWx",  Contants.CHANNEL_CREDIT_WX_02);
			} else {
				queryParams.put("channelPhone",  Contants.CHANNEL_PHONE_02);
			}
			if (!isNullOrEmpty(query)) {
				queryParams.put("nameLike", query);
			}
			queryParams.put("ordertypeId", Contants.BUSINESS_TYPE_YG);
		} else {
			queryParams.put("channelPhone", Contants.CHANNEL_PHONE_02);
			if (!isNullOrEmpty(stageMallGoodsParams.getQuerybyGoodsNm())) {
				queryParams.put("name", stageMallGoodsParams.getQuerybyGoodsNm());
			}
			queryParams.put("ordertypeId", Contants.BUSINESS_TYPE_JF);
		}
		try {
			List<GoodsModel> goodsModels = goodsDao.findAll(queryParams);
			if (goodsModels != null && !goodsModels.isEmpty()) {
				response.setSuccess(true);
				response.setResult(goodsModels);
				return response;
			} else {
				response.setSuccess(false);
				response.setError("query.good.false");
				return response;
			}
		} catch (Exception e) {
			log.error("get.good.error", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);
			response.setError("query.good.false");
			return response;
		}
	}

	@Override
	public Response<List<TblGoodsRecommendationYgModel>> findGoodsByBackCategory1Id4109(Long backCategory1Id) {
		List<TblGoodsRecommendationYgModel> model=tblGoodsRecommendationYgDao.findGoodsRecommendationByType(String.valueOf(backCategory1Id));
		Response<List<TblGoodsRecommendationYgModel>> response=new Response<>();
		if(model==null){
			response.setSuccess(false);
			response.setError("-1");
		}
		response.setResult(model);
		return response;

	}

	@Override
	public Response<GoodsDetailExtend> findWXYXo2oGoodsDetail(String mid) {
		Response<GoodsDetailExtend> response = new Response<GoodsDetailExtend>();
		try {
			if (isNullOrEmpty(mid)) {// mid为空不知道查询哪个商品
				throw new RuntimeException();
			}
			ItemModel itemModel = itemDao.findByMid(mid);
			if (itemModel == null) {// 没有查询到商品
				response.setResult(null);
				return response;
			}

			GoodsModel goodsModel = goodsDao.findById(itemModel.getGoodsCode());
			if (goodsModel == null || !"YG".equals(goodsModel.getOrdertypeId())) {// 没有查询到符合条件商品
				response.setResult(null);
				return response;
			}

			List<TblGoodsPaywayModel> goodsPaywayModels = tblGoodsPaywayDao.findByGoodsId(itemModel.getCode());
			if (goodsPaywayModels == null || goodsPaywayModels.isEmpty()) {// 没有相应的支付方式
				response.setResult(null);
				return response;
			}

			GoodsDetailExtend goodsDetailExtend = new GoodsDetailExtend();
			goodsDetailExtend.setGoodsId(itemModel.getCode());
			goodsDetailExtend.setGoodsNm(goodsModel.getName());
			goodsDetailExtend.setGoodsMid(itemModel.getMid());
			//goodsDetailExtend.setGoodsColor(itemModel.getAttribute());
			goodsDetailExtend.setGoodsSize(goodsModel.getFreightSize());
			goodsDetailExtend.setGoodsBacklog(itemModel.getStock() == null ? null : itemModel.getStock().toString());
			goodsDetailExtend.setGoodsDetailDesc(goodsModel.getIntroduction());
			BigDecimal marketPrice = itemModel.getMarketPrice();
			goodsDetailExtend.setMarketPrice(marketPrice == null ? null : marketPrice.toString());
			goodsDetailExtend.setImage1(itemModel.getImage1());
			goodsDetailExtend.setChannelMallWx(goodsModel.getChannelMallWx());
			goodsDetailExtend.setChannelCreditWx(goodsModel.getChannelCreditWx());
			// TODO 待处理
			goodsDetailExtend.setGoodsDesc("");
			// 组装该单品的支付方式
			List<RestGoodsPayWayDto> goodsPayWayDtos = Lists.newArrayList();
			for (TblGoodsPaywayModel goodsPaywayModel : goodsPaywayModels) {
				RestGoodsPayWayDto goodsPayWayDto = new RestGoodsPayWayDto();
				goodsPayWayDto.setGoodsPaywayId(goodsPaywayModel.getGoodsPaywayId());
				BigDecimal goodsPrice = goodsPaywayModel.getGoodsPrice();
				goodsPayWayDto.setGoodsPrice(goodsPrice == null ? null : goodsPrice.toString());
				goodsPayWayDtos.add(goodsPayWayDto);
			}
			goodsDetailExtend.setGoodsPayWayDtos(goodsPayWayDtos);

			response.setResult(goodsDetailExtend);
		} catch (Exception e) {
			log.error("【findWXYXo2oGoodsDetail.error】MAL421 根据mid 查询微信易信O2O0元秒杀商品详情失败");
			response.setError("RestItemServiceImpl.findWXYXo2oGoodsDetail.error");
		}
		return response;
	}

	@Override
	public Response<List<SPGoodsDetailDto>> findSPGoodsDetail(String origin, String queryType, String queryCondition) {
		Response<List<SPGoodsDetailDto>> response = new Response<List<SPGoodsDetailDto>>();
		try {
			List<SPGoodsDetailDto> spGoodsDetailDtos = new ArrayList<SPGoodsDetailDto>();
			Map<String, Object> goodsParams = Maps.newHashMap();
			Map<String, Object> itemParams = Maps.newHashMap();
			Map<String, Object> paywayParams = Maps.newHashMap();
			// 01：查询广发商城下品牌的新品上市
			// 02：查询广发商城下品牌的限时抢购
			// 05：查询广发商城下的置顶商品列表
			if ("01".equals(queryType) || "02".equals(queryType)) {
				goodsParams.put("goodsBrandId", queryCondition);// 按品牌取
			} else if ("05".equals(queryType)) {
				itemParams.put("stickFlag", 1);// 取置顶商品
				paywayParams.put("isBirth", "1");
			}

			// 根据渠道确定该渠道的上架商品
			if (Contants.CHANNEL_APP_CODE.equals(origin)) {
				goodsParams.put("channelApp", Contants.CHANNEL_APP_02);
			} else if (Contants.CHANNEL_PHONE_CODE.equals(origin)) {
				goodsParams.put("channelPhone", Contants.CHANNEL_PHONE_02);
			} else if (Contants.CHANNEL_MALL_WX_CODE.equals(origin)) {
				goodsParams.put("channelMallWX", Contants.CHANNEL_MALL_WX_02);
			} else if (Contants.CHANNEL_CREDIT_WX_CODE.equals(origin)) {
				goodsParams.put("channelCreditWX", Contants.CHANNEL_CREDIT_WX_02);
			}

			// 获取goods信息
			List<GoodsModel> goodsModels = goodsDao.findOnSaleSPGoodsByBrand(goodsParams);
			if(goodsModels == null || goodsModels.isEmpty()){//不存在符合条件的商品,返回空集合
				response.setResult(spGoodsDetailDtos);
				return response;
			}
			Map<String, GoodsModel> goodsModelMap = new HashMap<String, GoodsModel>();
			List<String> goodsCodes = new ArrayList<String>();
			for (GoodsModel goodsModel : goodsModels) {
				goodsModelMap.put(goodsModel.getCode(), goodsModel);// 将GoodsModel对象存到map，方便关联查询
				goodsCodes.add(goodsModel.getCode());
			}

			// 根据goodsCode查询关联的item信息
			itemParams.put("goodsCodes", goodsCodes);
			List<ItemModel> itemModels = itemDao.findItemsByGoodsCodeAndStick(itemParams);
			if(itemModels == null || itemModels.isEmpty()){//不存在符合条件的商品,返回空集合
				response.setResult(spGoodsDetailDtos);
				return response;
			}
			
			Map<String, ItemModel> itemModelMap = new HashMap<String, ItemModel>();
			List<String> itemCodes = new ArrayList<String>();
			if ("02".equals(queryType)) {
				//根据品牌查询推荐商品
				List<GoodsCommendModel> goodsCommendModels = goodsCommendDao.findGoodsCommends(queryCondition);
				String commendType = "15";// 限时抢购
				for (ItemModel itemModel : itemModels) {
					for (GoodsCommendModel goodsCommendModel : goodsCommendModels) {
						if (goodsCommendModel.getGoodsId().equals(itemModel.getCode())
								&& commendType.equals(goodsCommendModel.getCommendType())) {
							itemModelMap.put(itemModel.getCode(), itemModel);// 将GoodsModel对象存到map，方便关联查询
							itemCodes.add(itemModel.getCode());
						}
					}
				}
			} else if ("01".equals(queryType) || "05".equals(queryType)) {
				for (ItemModel itemModel : itemModels) {
					itemModelMap.put(itemModel.getCode(), itemModel);// 将GoodsModel对象存到map，方便关联查询
					itemCodes.add(itemModel.getCode());
				}
			}

			if(itemCodes.isEmpty()){//不存在符合条件的商品,返回空集合
				response.setResult(spGoodsDetailDtos);
				return response;
			}
			// 获取支付方式信息
			paywayParams.put("itemCodes", itemCodes);
			List<TblGoodsPaywayModel> tblGoodsPaywayModels = tblGoodsPaywayDao.findGoodsPaywayByItemCodes(paywayParams);

			for (String itemCode : itemModelMap.keySet()) {
				ItemModel itemModel = itemModelMap.get(itemCode);
				SPGoodsDetailDto spGoodsDetailDto = new SPGoodsDetailDto();
				GoodsModel goodsModel = goodsModelMap.get(itemModel.getGoodsCode());
				spGoodsDetailDto.setGoodsId(itemModel.getCode());
				spGoodsDetailDto.setGoodsNm(goodsModel.getName());
				spGoodsDetailDto.setGoodsMid(itemModel.getMid());
				spGoodsDetailDto.setGoodsOid(itemModel.getOid());
				spGoodsDetailDto.setGoodsXid(itemModel.getXid());
				BigDecimal goodsPrice = itemModel.getPrice();
				spGoodsDetailDto.setGoodsPrice(goodsPrice == null ? null : goodsPrice.toString());
				BigDecimal marketPrice = itemModel.getMarketPrice();
				spGoodsDetailDto.setMarketPrice(marketPrice == null ? null : marketPrice.toString());
				spGoodsDetailDto.setPictureUrl(itemModel.getImage1());
				long amount = itemModel.getGoodsTotal() + itemModel.getStock();
				spGoodsDetailDto.setGoodsTotal(Long.toString(amount));
				spGoodsDetailDto.setGoodsBacklog(itemModel.getStock().toString());
				BigDecimal bestRate = itemModel.getBestRate();
				spGoodsDetailDto.setBestRate(bestRate == null ? null : bestRate.toString());
				spGoodsDetailDto.setStickOrder(itemModel.getStickOrder().toString());
				for (TblGoodsPaywayModel tblGoodsPaywayModel : tblGoodsPaywayModels) {
					if (itemModel.getCode().equals(tblGoodsPaywayModel.getGoodsId())) {
						spGoodsDetailDto.setIsAction(tblGoodsPaywayModel.getIsAction());
						spGoodsDetailDto.setGoodsPaywayId(tblGoodsPaywayModel.getGoodsPaywayId());
						break;
					}
				}
				spGoodsDetailDtos.add(spGoodsDetailDto);
			}

			response.setResult(spGoodsDetailDtos);
		} catch (Exception e) {
			log.error("【findSPGoodsDetail.error】MAL335 特殊商品列表查询 失败 : ", e);
			response.setError("RestItemServiceImpl.findSPGoodsDetail.error");
		}

		return response;
	}

	@Override
	public Response<List<SPGoodsDetailDto>> findSPGoodsDetailByGoodsIds(String origin, List<String> goodsIds) {
		Response<List<SPGoodsDetailDto>> response = new Response<List<SPGoodsDetailDto>>();
		try {
			Map<String, Object> goodsParams = Maps.newHashMap();
			// 根据渠道确定该渠道的上架商品
			if (Contants.CHANNEL_APP_CODE.equals(origin)) {
				goodsParams.put("channelApp", Contants.CHANNEL_APP_02);
			} else if (Contants.CHANNEL_PHONE_CODE.equals(origin)) {
				goodsParams.put("channelPhone", Contants.CHANNEL_PHONE_02);
			} else if (Contants.CHANNEL_MALL_WX_CODE.equals(origin)) {
				goodsParams.put("channelMallWX", Contants.CHANNEL_MALL_WX_02);
			} else if (Contants.CHANNEL_CREDIT_WX_CODE.equals(origin)) {
				goodsParams.put("channelCreditWX", Contants.CHANNEL_CREDIT_WX_02);
			}

			// 根据单品编号查询相应的单品
			List<ItemModel> itemModels = itemDao.findByCodesNoOrder(goodsIds);
			if(itemModels == null || itemModels.isEmpty()){//不存在符合条件的商品,返回空集合
				response.setResult(new ArrayList<SPGoodsDetailDto>());
				return response;
			}

			// 获取goods信息
			List<String> goodsCodes = new ArrayList<String>();
			// 获取相关goods的code
			for (ItemModel itemModel : itemModels) {
				if (!goodsCodes.contains(itemModel.getGoodsCode())) {
					goodsCodes.add(itemModel.getGoodsCode());
				}
			}
			goodsParams.put("goodsCodes", goodsCodes);
			// 根据goodsCodes查询相应渠道上架的商品
			List<GoodsModel> goodsModels = goodsDao.findOnSaleSPGoodsByIds(goodsParams);

			List<SPGoodsDetailDto> spGoodsDetailDtos = new ArrayList<SPGoodsDetailDto>();
			for (ItemModel itemModel : itemModels) {
				for (GoodsModel goodsModel : goodsModels) {
					if (itemModel.getGoodsCode().equals(goodsModel.getCode())) {
						SPGoodsDetailDto spGoodsDetailDto = new SPGoodsDetailDto();
						spGoodsDetailDto.setGoodsId(itemModel.getCode());
						spGoodsDetailDto.setGoodsNm(goodsModel.getName());
						spGoodsDetailDto.setGoodsMid(itemModel.getMid());
						spGoodsDetailDto.setGoodsOid(itemModel.getOid());
						spGoodsDetailDto.setGoodsXid(itemModel.getXid());
						BigDecimal goodsPrice = itemModel.getPrice();
						spGoodsDetailDto.setGoodsPrice(goodsPrice == null ? null : goodsPrice.toString());
						BigDecimal marketPrice = itemModel.getMarketPrice();
						spGoodsDetailDto.setMarketPrice(marketPrice == null ? null : marketPrice.toString());
						spGoodsDetailDto.setPictureUrl(itemModel.getImage1());
						long amount = itemModel.getGoodsTotal() + itemModel.getStock();
						spGoodsDetailDto.setGoodsTotal(Long.toString(amount));
						spGoodsDetailDto.setGoodsBacklog(itemModel.getStock().toString());
						BigDecimal bestRate = itemModel.getBestRate();
						spGoodsDetailDto.setBestRate(bestRate == null ? null : bestRate.toString());
						spGoodsDetailDto.setStickOrder(itemModel.getStickOrder().toString());
						spGoodsDetailDto.setGoodsNm(goodsModel.getName());
						spGoodsDetailDtos.add(spGoodsDetailDto);
						break;
					}
				}
			}

			response.setResult(spGoodsDetailDtos);
		} catch (Exception e) {
			log.error("【findSPGoodsDetailByPaywayIds.error】MAL335 特殊商品列表查询 失败", e);
			response.setError("RestItemServiceImpl.findSPGoodsDetailByPaywayIds.error");
		}
		return response;
	}

	@Override
	public Response<StageMallGoodsDetailStageInfoVO> findHighestStageInfoByGoodsId(String goodsId) {
		Response<StageMallGoodsDetailStageInfoVO> response = new Response<StageMallGoodsDetailStageInfoVO>();
		try {
			TblGoodsPaywayModel tblGoodsPaywayModel = tblGoodsPaywayDao.findHighestStageInfo(goodsId);
			StageMallGoodsDetailStageInfoVO goodsDetailStageInfoVO = new StageMallGoodsDetailStageInfoVO();
			goodsDetailStageInfoVO.setStagesNum(String.valueOf(tblGoodsPaywayModel.getStagesCode()));
			BigDecimal perStage = tblGoodsPaywayModel.getPerStage();
			goodsDetailStageInfoVO.setPerStage(perStage == null ? null : perStage.toString());
			goodsDetailStageInfoVO.setPaywayIdF(tblGoodsPaywayModel.getGoodsPaywayId());
			response.setResult(goodsDetailStageInfoVO);
		} catch (Exception e) {
			log.error("【findHighestStageInfoByGoodsId.error】MAL335 查询最高分期信息出错", e);
			response.setError("RestItemServiceImpl.findHighestStageInfoByGoodsId.error");
		}
		return response;
	}

	@Override
	public Response<CCJudgeGoodsDetailDto> findGoodsInfByXid(String goodsXid) {
		Response<CCJudgeGoodsDetailDto> response = new Response<CCJudgeGoodsDetailDto>();
		try {
			ItemModel itemModel = itemDao.findItemByXid(goodsXid);
			if (itemModel == null) {// 商品不存在
				response.setResult(null);
				return response;
			}

			GoodsModel goodsModel = goodsDao.findById(itemModel.getGoodsCode());
			if (goodsModel == null || !Contants.CHANNEL_APP_02.equals(goodsModel.getChannelCc())) {// 该商品没上架
				response.setResult(null);
				return response;
			}

			CCJudgeGoodsDetailDto ccJudgeGoodsDetailDto = new CCJudgeGoodsDetailDto();
			ccJudgeGoodsDetailDto.setGoodsId(itemModel.getCode());
			ccJudgeGoodsDetailDto.setGoodsXid(itemModel.getXid());
			ccJudgeGoodsDetailDto.setRegionType(goodsModel.getRegionType());
			ccJudgeGoodsDetailDto.setCards(goodsModel.getCards());
			ccJudgeGoodsDetailDto.setLimitCount(itemModel.getVirtualLimit());
			ccJudgeGoodsDetailDto.setVirtualLimitDays(itemModel.getVirtualLimitDays());

			response.setResult(ccJudgeGoodsDetailDto);
		} catch (Exception e) {
			log.error("【findGoodsInfByXid.error】MAL201 CC积分商城预判查询商品信息出错", e);
			response.setError("RestItemServiceImpl.findGoodsInfByXid.error");
		}
		return response;
	}

	// @Override
	// public Response<String> findAreaFormatId(String regionType) {
	// Response<String> response = new Response<String>();
	// try {
	// String areaFormatId = goodsRegionDao.findCardsByCode(regionType);
	// response.setResult(areaFormatId);
	// } catch (Exception e) {
	// log.error("【findAreaFormatId.error】MAL201 CC积分商城预判查询分区卡板出错");
	// response.setError("RestItemServiceImpl.findAreaFormatId.error");
	// }
	// return response;
	// }

	@Override
	public Response<List<XnlpODSDto>> findXnlpByCertAndCardNo(String certNo, String cardNo, String type) {
		Response<List<XnlpODSDto>> response = new Response<List<XnlpODSDto>>();
		try {
			List<XnlpODSDto> xnlpODSDtos = new ArrayList<XnlpODSDto>();
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("certNo", certNo);
			params.put("cardNo", cardNo);
			XnlpODSDto xnlpODSDto = null;
			if ("1".equals(type)) {// 真情类保险
				List<XnlpZQBXModel> xnlpZQBXModels = xnlpZQBXDao.findZQBXByCertAndCard(params);
				for (XnlpZQBXModel xnlpZQBXModel : xnlpZQBXModels) {
					xnlpODSDto = new XnlpODSDto();
					xnlpODSDto.setCustName(xnlpZQBXModel.getCustName());
					xnlpODSDto.setCertNbr(xnlpZQBXModel.getCertNbr());
					xnlpODSDto.setCard4(xnlpZQBXModel.getCard4());
					xnlpODSDto.setServerStart(xnlpZQBXModel.getServerStart());
					xnlpODSDtos.add(xnlpODSDto);
				}
			} else if ("2".equals(type)) {// 标准类保险
				List<XnlpBZBXModel> xnlpBZBXModels = xnlpBZBXDao.findBZBXByCertAndCard(params);
				for (XnlpBZBXModel xnlpBZBXModel : xnlpBZBXModels) {
					xnlpODSDto = new XnlpODSDto();
					xnlpODSDto.setCustName(xnlpBZBXModel.getCustName());
					xnlpODSDto.setCertNbr(xnlpBZBXModel.getCertNbr());
					xnlpODSDto.setCard4(xnlpBZBXModel.getCard4());
					xnlpODSDto.setServerStart(xnlpBZBXModel.getServerStart());
					xnlpODSDtos.add(xnlpODSDto);
				}
			} else if ("3".equals(type)) {// 车主卡类保险
				List<XnlpCZBXModel> xnlpCZBXModels = xnlpCZBXDao.findCZBXByCertAndCard(params);
				for (XnlpCZBXModel xnlpCZBXModel : xnlpCZBXModels) {
					xnlpODSDto = new XnlpODSDto();
					xnlpODSDto.setCustName(xnlpCZBXModel.getCustName());
					xnlpODSDto.setCertNbr(xnlpCZBXModel.getCertNbr());
					xnlpODSDto.setCard4(xnlpCZBXModel.getCard4());
					xnlpODSDto.setServerStart(xnlpCZBXModel.getServerStart());
					xnlpODSDtos.add(xnlpODSDto);
				}
			} else if ("4".equals(type)) {// 道路救援类保险
				List<XnlpCZDLModel> xnlpCZDLModels = xnlpCZDLDao.findCZDLByCertAndCard(params);
				for (XnlpCZDLModel xnlpCZDLModel : xnlpCZDLModels) {
					xnlpODSDto = new XnlpODSDto();
					xnlpODSDto.setCustName(xnlpCZDLModel.getCustName());
					xnlpODSDto.setCertNbr(xnlpCZDLModel.getCertNbr());
					xnlpODSDto.setCard4(xnlpCZDLModel.getCard4());
					xnlpODSDto.setServerStart(xnlpCZDLModel.getServerStart());
					xnlpODSDtos.add(xnlpODSDto);
				}
			} else if ("5".equals(type)) {// 留学生旅行意外险
				List<XnlpLXSYModel> xnlpLXSYModels = xnlpLXSYDao.findLXSYByCert(params);
				for (XnlpLXSYModel xnlpLXSYModel : xnlpLXSYModels) {
					xnlpODSDto = new XnlpODSDto();
					xnlpODSDto.setCustName(xnlpLXSYModel.getCustName());
					xnlpODSDto.setCertNbr(xnlpLXSYModel.getCertNbr());
					xnlpODSDto.setCard4(xnlpLXSYModel.getCard4());
					xnlpODSDto.setServerStart(xnlpLXSYModel.getServerStart());
					xnlpODSDtos.add(xnlpODSDto);
				}
			}

			response.setResult(xnlpODSDtos);
		} catch (Exception e) {
			log.error("【findXnlpByCertAndCardNo.error】MAL201 CC积分商城预判查询ods导入的虚拟礼品出错", e);
			response.setError("RestItemServiceImpl.findXnlpByCertAndCardNo.error");
		}
		return response;
	}

	/**
	 * Description : MAL312 获取商品信息
	 *
	 * @param stageMallGoodsParams
	 * @return
	 */
	@Override
	public Response<List<ItemModel>> findItems(StageMallGoodsParams stageMallGoodsParams) {
		Response<List<ItemModel>> response = new Response<List<ItemModel>>();
		HashMap<String, Object> queryParams = Maps.newHashMap();
		String mallType = stageMallGoodsParams.getMallType();
		String query = stageMallGoodsParams.getQueryByGoodsId();
		if ("01".equals(mallType)) {// 分期
			if (!isNullOrEmpty(query)) {
				if (query.length() == 5) {
					Pattern pattern = Pattern.compile("[a-zA_Z0-9]{5}");
					Matcher matcher = pattern.matcher(query);
					if (matcher.find()) {
						queryParams.put("mid", query);
					}
				}
			}
		} else {
			if (!isNullOrEmpty(stageMallGoodsParams.getQueryByGoodsId())) {
				queryParams.put("xid", stageMallGoodsParams.getQueryByGoodsId());
			}
			if (!isNullOrEmpty(stageMallGoodsParams.getQuerybyGoodsNm())) {
				queryParams.put("goodsNmLike", stageMallGoodsParams.getQueryByGoodsId());
			}
			if (!isNullOrEmpty(stageMallGoodsParams.getQuerybyArea())) {
				queryParams.put("areaCode", stageMallGoodsParams.getQueryByGoodsId());
			}
			if (!isNullOrEmpty(stageMallGoodsParams.getQuerybyPointRange())) {
				queryParams.put("xidAndGoodsName", stageMallGoodsParams.getQueryByGoodsId());
			}
		}
		try {
			Pager<ItemModel> pager = itemDao.findByPage(queryParams, 0, Integer.MAX_VALUE);
			if (pager != null && pager.getTotal() > 0) {
				response.setSuccess(true);
				response.setResult(pager.getData());
				return response;
			} else {
				response.setSuccess(false);
				response.setError("query.items.false");
				return response;
			}
		} catch (Exception e) {
			log.error("get.items.error", e);
			response.setSuccess(false);
			response.setError("query.items.false");
			return response;
		}
	}

	/**
	 * Description : MAL101 分期商城(商品搜索列表)
	 * 
	 * @param params
	 * @return
	 */
	@Override
	public Response<List<GoodsModel>> findGoodsByCCIntergalPresent(CCIntergalPresentParams params) {
		Response<List<GoodsModel>> response = new Response<List<GoodsModel>>();
		HashMap<String, Object> queryParams = Maps.newHashMap();
		String goodsName = params.getKeyValue();
		String pointsType = params.getJfType();
		String orgin = params.getOrigin();//渠道来源 01CC 02IVR
		if (!isNullOrEmpty(goodsName)) {
			queryParams.put("nameLike", goodsName);
		}
		if (!isNullOrEmpty(pointsType)) {
			//queryParams.put("pointsType", pointsType);xiewl:数迁数据没有pointType，业务缺陷
		}
		if (Contants.SOURCE_ID_CC.equals(orgin)) {
			queryParams.put("channelCc", Contants.CHANNEL_CC_02);
		} else {
			queryParams.put("channelIvr", Contants.CHANNEL_IVR_02);
		}
		queryParams.put("delFlag", Contants.DEL_FLAG_0);
		queryParams.put("ordertypeId", Contants.ORDERTYPEID_JF);
		try {
			List<GoodsModel> goodsModels = goodsDao.findAllByCC(queryParams);
			if (goodsModels != null) {
				response.setSuccess(true);
				response.setResult(goodsModels);
			} else {
				log.error("query.CCIntergalPresent.false");
				response.setSuccess(false);
				response.setError("query.CCIntergalPresent.false");
			}
		} catch (Exception e) {
			log.error("query.CCIntergalPresent.false", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);
			response.setError("query.CCIntergalPresent.false");
		}
		return response;
	}

	/**
	 * Description : MAL101 根据goodsid 获取payway
	 * 
	 * @param goodsIds
	 * @return
	 */
	@Override
	public Response<List<TblGoodsPaywayModel>> findPaywayByGoodsId(List<String> goodsIds) {
		Response<List<TblGoodsPaywayModel>> response = new Response<List<TblGoodsPaywayModel>>();
		try {
			List<TblGoodsPaywayModel> goodsPaywayModels = tblGoodsPaywayDao.findByGoodsIds(goodsIds);
			if (goodsPaywayModels != null) {
				response.setSuccess(true);
				response.setResult(goodsPaywayModels);
			} else {
				log.error("query.paywayByGoodsId.false");
				response.setSuccess(false);
				response.setError("query.paywayByGoodsId.false");
			}
		} catch (Exception e) {
			log.error("query.paywayByGoodsId.false", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);
			response.setError("query.paywayByGoodsId.false");
		}
		return response;
	}

	/**
	 * Description : MAL101 分期商城(商品搜索列表)
	 * 
	 * @param params
	 * @return
	 */
	@Override
	public Response<List<ItemModel>> findItemsByCCIntergralPresent(CCIntergalPresentParams params) {
		Response<List<ItemModel>> response = new Response<List<ItemModel>>();
		HashMap<String, Object> queryParams = Maps.newHashMap();
		queryParams.put("xidNotNull", "1");
		queryParams.put("delFlag", "0");
		if (params.getGoodsXid() != null && !"".equals(params.getGoodsXid()) ) {
			queryParams.put("xid", params.getGoodsXid());
		}
		try {
			Pager<ItemModel> pager = itemDao.findByPage(queryParams, 0, Integer.MAX_VALUE);
			if (pager != null && pager.getTotal() > 0) {
				response.setSuccess(true);
				response.setResult(pager.getData());
			} else {
				log.error("query.CCIntergalPresent.false");
				response.setSuccess(false);
				response.setError("query.CCIntergalPresent.false");
			}
		} catch (Exception e) {
			log.error("query.CCIntergalPresent.false", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);
			response.setError("query.CCIntergalPresent.false");
		}
		return response;
	}

	/**
	 * Description : MAL101 分期商城(商品搜索列表)
	 * 
	 * @param params
	 * @return
	 */
	@Override
	public Response<List<TblGoodsPaywayModel>> findPaywaysByCCIntergralPresent(CCIntergalPresentParams params) {
		Response<List<TblGoodsPaywayModel>> response = new Response<List<TblGoodsPaywayModel>>();
		HashMap<String, Object> queryParams = Maps.newHashMap();
		queryParams.put("memberLevel", Contants.MEMBER_LEVEL_JP_CODE);
		queryParams.put("ischeckNot", "d");
		queryParams.put("goodsPointRange", params.getBonusRegion());
		try {
			Pager<TblGoodsPaywayModel> pager = tblGoodsPaywayDao.findByPage(queryParams, 0, Integer.MAX_VALUE);
			if (pager != null && pager.getTotal() > 0) {
				response.setSuccess(true);
				response.setResult(pager.getData());
			} else {
				log.error("query.CCIntergalPresent.false");
				response.setSuccess(false);
				response.setError("query.CCIntergalPresent.false");
			}
		} catch (Exception e) {
			log.error("query.CCIntergalPresent.false", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);
			response.setError("query.CCIntergalPresent.false");
		}
		return response;
	}
	
	/**
	 * Description : MAL313 查询商品详情
	 * 
	 * @param itemCode 商品code
	 * @param origin 发起方
	 * @param contIdcard 证件号码
	 * @param custId 证件号
	 * @param queryType 查询类型
	 * @param goodsIds 商品code数组 用于查询一组库存
	 * 
	 * @return
	 */
	@Override
	public Response<AppGoodsDetailModel> findGoodsDetailByApp(String itemCode, String origin, String contIdcard,
			String custId, String queryType, String[] goodsIds) {
		// queryType
		// 0或者空 ：查商品详情所有信息
		// 1：只查商品详情的基本信息（不包含可兑换积分、单位积分和优惠券信息）；
		// 2：只查可兑换积分、单位积分和优惠券信息（不包含商品详情的基本信息）；
		// origin 发起方 微信广发银行：WX；微信信用卡中心：WS；易信广发银行：YX；易信信用卡中心：YS ; 手机：03 ; APP：09
		// 定义返回值
		Response<AppGoodsDetailModel> result = new Response<>();
		boolean WXFlag = false;
		if (Contants.CHANNEL_SN_WX.equals(origin) || Contants.CHANNEL_SN_WS.equals(origin)
				|| Contants.CHANNEL_SN_YX.equals(origin) || Contants.CHANNEL_SN_YS.equals(origin)) {
			WXFlag = true;
		}
		// 判断商品CODE是否存在
		if (isNullOrEmpty(itemCode)) {
			result.setError("returnCode:000008:非法参数,商品编码不能为空！");
			return result;
		}
		if ("1".equals(queryType)) {
			// 1：只查商品详情的基本信息（不包含可兑换积分、单位积分和优惠券信息）
			return queryGoodsBaseInfo(itemCode, origin, contIdcard, custId, queryType, result);
		} else if ("2".equals(queryType)) {
			// 2：只查可兑换积分、单位积分和优惠券信息（不包含商品详情的基本信息），APP需求增加查询收藏状态和提醒状态
			return queryWXIntegralAndCoupon(itemCode, origin, contIdcard, custId, queryType, WXFlag, result);
		} else if ("3".equals(queryType)) {
			// 3：只查询实际库存数量（goods_backlog）、总库存（goods_total）返回
			return queryGoodsBacklog(itemCode, origin, contIdcard, custId, queryType, result, goodsIds);
		} else {
			// 查商品详情所有信息，APP需求增加查询收藏状态和提醒状态
			return queryGoodsDetail(itemCode, origin, contIdcard, custId, queryType, result);
		}
		
	}

	private Response<AppGoodsDetailModel> queryGoodsBaseInfo(String itemCode, String origin, String contIdcard,
			String custId, String queryType, Response<AppGoodsDetailModel> result) {

		try {
			AppGoodsDetailModel appGoodsDetailModel = new AppGoodsDetailModel();
			// int stages_num = 1;
			String mallType = "";
			// String do_date = new SimpleDateFormat("yyyyMMdd").format(new Date());
			// 查询这件商品是广发商城还是积分商城
			GoodsModel goodsModel = new GoodsModel();
			ItemModel itemModel = itemDao.findById(itemCode);
			// 调用查询商品信息接口
			if (itemModel != null) {
				goodsModel = goodsDao.findById(itemModel.getGoodsCode());
				// 上架判断
				if ("03".equals(origin) && !"02".equals(goodsModel.getChannelPhone())) {
					result.setError("returnCode:000036:商品不在上架状态");
					return result;
				}
				if (goodsModel == null || itemModel == null) {
					result.setError("returnCode:000010:商品信息错误");
					return result;
				}
				// TODO 有效期判断

				// 设置值
				appGoodsDetailModel.setGoodsType("1");//默认普通商品
				appGoodsDetailModel.setGoodsNm(goodsModel.getName());
				appGoodsDetailModel.setGoodsMid(itemModel.getMid());
				appGoodsDetailModel.setGoodsOid(itemModel.getOid());
				appGoodsDetailModel.setGoodsXid(itemModel.getXid());
				// stages_num 一定是空 所以不做处理

				// 获取paywayList
				List<TblGoodsPaywayModel> paywayList = tblGoodsPaywayDao.findByGoodsIds(Arrays.asList(itemCode));
				String goods_price = "";
				if (paywayList != null) {
					List<AppStageInfo> list = new ArrayList<>();
					for (TblGoodsPaywayModel tblGoodsPaywayModel : paywayList) {
						AppStageInfo appstageInfo = new AppStageInfo();
						appstageInfo.setStagesNum(tblGoodsPaywayModel.getStagesCode() != null ? tblGoodsPaywayModel
								.getStagesCode().toString() : "");
						appstageInfo.setPerStage(tblGoodsPaywayModel.getPerStage().toString());
						appstageInfo.setPaywayIdF(tblGoodsPaywayModel.getGoodsPaywayId());
						list.add(appstageInfo);
						goods_price = tblGoodsPaywayModel.getGoodsPrice().toString();
					}
					appGoodsDetailModel.setStageInfo(list);
				}
				appGoodsDetailModel.setGoodsPrice(goods_price == null ? "" : goods_price);
				mallType = goodsModel.getOrdertypeId();
				// 如果查询的是积分商城，则添加积分商城相关字段
				if (Contants.BUSINESS_TYPE_JF.equals(goodsModel.getOrdertypeId())) {
					appGoodsDetailModel.setJfType(goodsModel.getPointsType() == null ? "" : goodsModel.getPointsType());
					appGoodsDetailModel.setGoods_type(goodsModel.getGoodsType() == null ? "" : goodsModel
							.getGoodsType());
					appGoodsDetailModel.setAreaCode(goodsModel.getRegionType() == null ? "" : goodsModel
							.getRegionType());
				}
				// 设置积分类型名称
				if (StringUtils.isNotEmpty(goodsModel.getPointsType())) {
					Response<TblCfgIntegraltypeModel> modelResponse = cfgIntegraltypeService.findById(goodsModel.getPointsType());
					if (modelResponse.isSuccess()) {
						appGoodsDetailModel.setJfTypeNm(modelResponse.getResult().getIntegraltypeNm());
					}
				}
				if(paywayList != null){
					for (TblGoodsPaywayModel tblGoodsPaywayModel : paywayList) {
						if ("0000".equals(tblGoodsPaywayModel.getMemberLevel())) {
							appGoodsDetailModel.setJpPricePayid(tblGoodsPaywayModel.getGoodsPaywayId());
							appGoodsDetailModel
									.setJpPrice(tblGoodsPaywayModel.getGoodsPoint() != null ? tblGoodsPaywayModel
											.getGoodsPoint().toString() : null);
						}
						if ("0001".equals(tblGoodsPaywayModel.getMemberLevel())) {
							appGoodsDetailModel.setTzPricePayid(tblGoodsPaywayModel.getGoodsPaywayId());
							appGoodsDetailModel
									.setTzPrice(tblGoodsPaywayModel.getGoodsPoint() != null ? tblGoodsPaywayModel
											.getGoodsPoint().toString() : null);
						}
						if ("0002".equals(tblGoodsPaywayModel.getMemberLevel())) {
							appGoodsDetailModel.setDzPricePayid(tblGoodsPaywayModel.getGoodsPaywayId());
							appGoodsDetailModel
									.setDzPrice(tblGoodsPaywayModel.getGoodsPoint() != null ? tblGoodsPaywayModel
											.getGoodsPoint().toString() : null);
						}
						if ("0003".equals(tblGoodsPaywayModel.getMemberLevel())) {
							appGoodsDetailModel.setVipPricePayid(tblGoodsPaywayModel.getGoodsPaywayId());
							appGoodsDetailModel
									.setVipPrice(tblGoodsPaywayModel.getGoodsPoint() != null ? tblGoodsPaywayModel
											.getGoodsPoint().toString() : null);
						}
						if ("0004".equals(tblGoodsPaywayModel.getMemberLevel())) {
							appGoodsDetailModel.setBrhPricePayid(tblGoodsPaywayModel.getGoodsPaywayId());
							appGoodsDetailModel
									.setBrhPrice(tblGoodsPaywayModel.getGoodsPoint() != null ? tblGoodsPaywayModel
											.getGoodsPoint().toString() : null);
						}
						if ("0005".equals(tblGoodsPaywayModel.getMemberLevel())) {
							appGoodsDetailModel.setBrhPricePayid(tblGoodsPaywayModel.getGoodsPaywayId());
							appGoodsDetailModel
									.setJfxjPricePayid(tblGoodsPaywayModel.getGoodsPoint() != null ? tblGoodsPaywayModel
											.getGoodsPoint().toString() : null);
							appGoodsDetailModel.setJfPart(tblGoodsPaywayModel.getGoodsPoint() != null ? tblGoodsPaywayModel
									.getGoodsPoint().toString() : null);
							appGoodsDetailModel.setXjPart(tblGoodsPaywayModel.getGoodsPrice().toString());
						}
						// 20151013 APP需求增加“活动积分” start
						if ("0006".equals(tblGoodsPaywayModel.getMemberLevel())) {
							appGoodsDetailModel.setActPointId(tblGoodsPaywayModel.getGoodsPaywayId());
							appGoodsDetailModel
									.setActPoint(tblGoodsPaywayModel.getGoodsPoint() != null ? tblGoodsPaywayModel
											.getGoodsPoint().toString() : null);
						}
						// 20151013 APP需求增加“活动积分” end
					}
				}

				Response<VendorInfoDto> vendor = vendorService.findById(goodsModel.getVendorId());
				VendorInfoDto vendorModel = new VendorInfoDto();
				// 获取供应商信息
				if (vendor.isSuccess()) {
					vendorModel = vendor.getResult();
				}

				appGoodsDetailModel.setVendorId(vendorModel.getVendorId());
				appGoodsDetailModel.setVendorFnm(vendorModel.getFullName());
				appGoodsDetailModel.setVendorSnm(vendorModel.getSimpleName());
				appGoodsDetailModel.setVendorPhone(vendorModel.getPhone());
				appGoodsDetailModel.setVendorTime(vendorModel.getVendorTime());
				appGoodsDetailModel.setTypePid("");// 商品大类别ID obj[11]
				appGoodsDetailModel.setLevelPnm("");
				appGoodsDetailModel.setTypeId("");
				appGoodsDetailModel.setLevelNm("");

				appGoodsDetailModel.setGoodsSize(goodsModel.getFreightSize());
				String goods_detail_desc = goodsModel.getGoodsBaseDesc();//
				appGoodsDetailModel.setGoodsProp2(itemModel.getWxProp1() == null ? "" : itemModel.getWxProp1());
				String prop=goodsModel.getIntroduction();
				if (Contants.BUSINESS_TYPE_JF.equals(goodsModel.getOrdertypeId())) {
					// 手机渠道JF商品的商品详情过滤标签、图片、特殊字符 --20151224
					goods_detail_desc = goods_detail_desc == null ? "" : deleteImg(goods_detail_desc);
					prop = prop ==null ?"":deleteImg(prop);
				} else {
					// 2015-01-21 2015年3月版需求，图片需拼接内网ip的形式，以便手机端可展示该图片
				}
				appGoodsDetailModel.setGoodsProp1(prop);
				appGoodsDetailModel.setGoodsDetailDesc(goods_detail_desc);// 商品基本描述
				// 原数据为空
				appGoodsDetailModel.setPaywayIdY("");
				// 原始设置为0
				appGoodsDetailModel.setAlertNum("0");
				String picture_url = "";
				String marketPrice = "";
				AppBackLogInfo appBackLogInfo = new AppBackLogInfo();
				// 数量 goodsBacklog
				appBackLogInfo.setGoodsBackLog(itemModel.getStock().toString());
				// 总供货数量【只增不减】
				long amount = itemModel.getGoodsTotal() + itemModel.getStock();
				appBackLogInfo.setGoodsTotal(Long.toString(amount));
				appGoodsDetailModel.setBacklogInfo(Arrays.asList(appBackLogInfo));
				// 场次id act_id
				appGoodsDetailModel.setMarketPrice(marketPrice);
				boolean WXFlag = false;
				if (Contants.CHANNEL_SN_WX.equals(origin) || Contants.CHANNEL_SN_WS.equals(origin)
						|| Contants.CHANNEL_SN_YX.equals(origin) || Contants.CHANNEL_SN_YS.equals(origin)) {
					WXFlag = true;
				}
				if (WXFlag) {// 微信渠道
					String countLimit = "9";// 限购数
					if (!"".equals(countLimit)) {
						countLimit = String.valueOf(Math.round(Double.parseDouble(countLimit)));
						picture_url = itemModel.getImage1();
					}
					//如果库存小于限购数   将限购数设置为库存
					if(!Strings.isNullOrEmpty(itemModel.getStock().toString())&&Integer.valueOf(itemModel.getStock().toString())<Integer.valueOf(countLimit)){
					    countLimit=itemModel.getStock().toString();
					}
					appGoodsDetailModel.setCountLimit(countLimit);// 限购
					// 微信渠道
					if ("02".equals(goodsModel.getChannelCreditWx())){
						// 转换为微信上架状态
						appGoodsDetailModel.setWechatAStatus("0203");
					} else if ("01".equals(goodsModel.getChannelCreditWx())){
						// 转换为微信上架状态
						appGoodsDetailModel.setWechatAStatus("0204");
					} else {
						// 新商城状态
						appGoodsDetailModel.setWechatAStatus(goodsModel.getChannelCreditWx());
					}
					if ("02".equals(goodsModel.getChannelMallWx())){
						// 转换为微信上架状态
						appGoodsDetailModel.setWechatStatus("0203");
					} else if ("01".equals(goodsModel.getChannelMallWx())){
						// 转换为微信下架状态
						appGoodsDetailModel.setWechatStatus("0204");
					} else {
						// 新商城状态
						appGoodsDetailModel.setWechatStatus(goodsModel.getChannelMallWx());
					}

				} else if (Contants.SOURCE_ID_APP.equals(origin)) {// APP渠道
					if ("02".equals(goodsModel.getChannelApp())) {
						appGoodsDetailModel.setAppStatus("0203");// APP状态
					}else if ("01".equals(goodsModel.getChannelApp())){
						// 转换为APP下架状态
						appGoodsDetailModel.setAppStatus("0204");
					} else {
						appGoodsDetailModel.setAppStatus(goodsModel.getChannelApp());// APP状态
					}
					picture_url = makeImage(itemModel, picture_url);
				} else {// 手机渠道
					if ("JF".equals(mallType)) {
						picture_url = itemModel.getImage1();
					} else {
						picture_url = makeImage(itemModel, picture_url);
					}
				}



				// #######################################
				// 返回商品属性一、属性二、属性值一、属性值二的内容--20160217 APP需求(二期)
				List<AppGoodsInfo> goodsInfos = new ArrayList<>();
				
				AppGoodsInfo appGoodsInfo = new AppGoodsInfo();
				appGoodsInfo.setGoodsId(itemModel.getCode());// 商品编码
				appGoodsInfo.setGoodsAttr1(itemModel.getAttributeKey1()==null?"":itemModel.getAttributeKey1());// 属性一
				appGoodsInfo.setGoodsAttr2(itemModel.getAttributeKey2()==null?"":itemModel.getAttributeKey2());// 属性二
				appGoodsInfo.setGoodsColor(itemModel.getAttributeName1()==null?"":itemModel.getAttributeName1());
				appGoodsInfo.setGoodsModel(itemModel.getAttributeName2()==null?"":itemModel.getAttributeName2());
				goodsInfos.add(appGoodsInfo);
				// begin 此处添加商品组概念  手机银行不需要添加
				if(!origin.equals(Contants.ORDER_SOURCE_ID_MOBILE)){
					List<String> goodsIdList=new ArrayList<>();
					goodsIdList.add(itemModel.getGoodsCode());
					Response<List<ItemModel>>  rsitem=itemService.findItemListByGoodsCodeList(goodsIdList);
					if(rsitem.isSuccess()){
						List<ItemModel> list=rsitem.getResult();
						for (ItemModel itemModel2 : list) {
							if(!itemModel.getCode().equals(itemModel2.getCode())){
								AppGoodsInfo appGoodsInfos = new AppGoodsInfo();
								appGoodsInfos.setGoodsId(itemModel2.getCode());// 商品编码
								appGoodsInfos.setGoodsAttr1(itemModel2.getAttributeKey1()==null?"":itemModel2.getAttributeKey1());// 属性一
								appGoodsInfos.setGoodsAttr2(itemModel2.getAttributeKey2()==null?"":itemModel2.getAttributeKey2());// 属性二
								appGoodsInfos.setGoodsColor(itemModel2.getAttributeName1()==null?"":itemModel2.getAttributeName1());
								appGoodsInfos.setGoodsModel(itemModel2.getAttributeName2()==null?"":itemModel2.getAttributeName2());
								goodsInfos.add(appGoodsInfos);
							}
						}
					}
				}
				// end 添加商品组结束
				
				// 获取 颜色和尺寸属性代码
				appGoodsDetailModel.setGoodsInfo(goodsInfos);
				// 商品组 已取消
				appGoodsDetailModel.setPictureUrl(picture_url);// 图片

				// 20151014 APP需求 start
				appGoodsDetailModel.setVendorTime(vendorModel.getServiceTime());// 供应商上班时间
				// TODO
				// if ("1".equals(actionType)) {// 团购
				// appGoodsDetailModel.setActionCount("");// TODO 已参加活动的数量--团购商品返回已参加活动的数量
				// }
				Long soldNum = itemModel.getGoodsTotal();
				appGoodsDetailModel.setSoldNum(soldNum.toString());// 已售数量
				appGoodsDetailModel.setBestRate(itemModel.getBestRate() == null ? null : itemModel.getBestRate()
						.doubleValue());
				// 设置 返回值
				result.setResult(appGoodsDetailModel);
			} else {
				result.setError("returnCode:000010:商品信息错误");
				return result;
			}

		} catch (Exception e) {
			result.setError("returnCode:000009:商品详细信息查询异常");
			return result;
		}

		return result;
	}

	private String makeImage(ItemModel itemModel, String picture_url) {
		// 如果是APP渠道(广发商城)，需要给手机图片,最多取五张图片,用分隔符“|”
		if (StringUtils.isNotEmpty(itemModel.getImage1())) {
			picture_url += "|" + itemModel.getImage1();
		}
		if (StringUtils.isNotEmpty(itemModel.getImage2())) {
			picture_url += "|" + itemModel.getImage2();
		}
		if (StringUtils.isNotEmpty(itemModel.getImage3())) {
			picture_url += "|" + itemModel.getImage3();
		}
		if (StringUtils.isNotEmpty(itemModel.getImage4())) {
			picture_url += "|" + itemModel.getImage4();
		}
		if (StringUtils.isNotEmpty(itemModel.getImage5())) {
			picture_url += "|" + itemModel.getImage5();
		}
		if (picture_url.length() > 0) {// 去掉第一位|
			picture_url = picture_url.substring(1, picture_url.length());
		}
		return picture_url;
	}

	private Response<AppGoodsDetailModel> queryWXIntegralAndCoupon(String itemCode, String origin, String contIdcard,
			String custId, String queryType, boolean WXFlag, Response<AppGoodsDetailModel> result) {
		AppGoodsDetailModel resultDate = new AppGoodsDetailModel();
		GoodsModel goodsModel = new GoodsModel();
		ItemModel itemModel = itemDao.findById(itemCode);
		
		if (itemModel!=null&&itemModel.getGoodsCode()!=null) {

			goodsModel=goodsDao.findById(itemModel.getGoodsCode());
			resultDate.setGoodsModel(goodsModel);
			// 上架判断
			if ("03".equals(origin) && !"02".equals(goodsModel.getChannelPhone())) {
				result.setError("returnCode:000036:商品不在上架状态");
				return result;
			}
			if (goodsModel == null || itemModel == null) {
				result.setError("returnCode:000010:商品信息错误");
				return result;
			}
			// TODO 有效期之内判断
			String goods_price = "";
			List<TblGoodsPaywayModel> paywayList = tblGoodsPaywayDao.findByGoodsPaywayInfo(itemCode);
			resultDate.setMarketPrice(itemModel.getMarketPrice()==null?"":decimalFormat.format(itemModel.getMarketPrice()));
			if (paywayList != null) {
				TblGoodsPaywayModel payway = paywayList.get(0);
				if (payway != null) {
					goods_price = payway.getGoodsPrice() == null ? "" : payway.getGoodsPrice().toString();
				}
				// 获取用户可兑换积分

				PointPoolModel pointPoolModel  = pointPoolDao.getCurMonthInfo();
				long availableIntegral = 0;// 积分池剩余积分
				String canIntegral = "";// 可兑换积分 倍率X售价X单位积分
				String unitIntegral = "";// 单位积分
				String ifFixPoint = "";// 是否固定积分

				if (itemModel.getFixPoint()==null) {
					ifFixPoint = "0";
				} else {
					ifFixPoint = "1";
				}

				String maxPoint = pointPoolModel.getMaxPoint() == null ? "" : pointPoolModel.getMaxPoint()
						.toString();
				String usedPoint = pointPoolModel.getUsedPoint() == null ? "" : pointPoolModel.getUsedPoint()
						.toString();
				unitIntegral = pointPoolModel.getSinglePoint() == null ? "" : pointPoolModel.getSinglePoint()
						.toString();
				String pointRate = pointPoolModel.getPointRate() == null ? "" : pointPoolModel.getPointRate()
						.toString();// 全局倍率
				String bestRate = itemModel.getBestRate() == null ? "" : itemModel.getBestRate().toString();// 产品倍率
				log.info("当月最大积分数：" + maxPoint + "已用积分数：" + usedPoint + "最高倍率：" + pointRate + "产品倍率:" + bestRate);
				// 倍率优先取"产品倍率"，若"产品倍率"为空，则取"全局倍率"
				String rate = "".equals(bestRate) ? pointRate : bestRate;
				resultDate.setRate(rate);
				if (!"".equals(maxPoint)) {
					availableIntegral = Long.parseLong(maxPoint) - Long.parseLong(usedPoint);
					if (availableIntegral > 0) {// 剩余积分大于0时，才能使用积分抵扣
						// 如果是手机的请求,无需考虑商品是否维护固定积分，保持现有的规则计算可使用积分，如果是微信/APP的请求，则如果ifFixPoint是1则取固定积分的值返回给微信
						if ("1".equals(ifFixPoint) && (WXFlag || Contants.SOURCE_ID_APP.equals(origin))) {
							canIntegral = itemModel.getFixPoint() == null ? "0" : itemModel.getFixPoint().toString();
						} else {
							canIntegral = String.valueOf(Math.round(Long.parseLong(unitIntegral)
									* Double.parseDouble(rate) * Double.parseDouble(goods_price)));// 单位积分X倍率X售价
						}
					}
				}
				// 设置值
				resultDate.setCanIntegral(canIntegral);// 可兑换积分
				resultDate.setUnitIntegral(unitIntegral);// 单位积分
				resultDate.setIfFixPoint(ifFixPoint);// 是否固定积分 1-是；0-否
				// 返回活动在调用服务中处理
				result.setResult(resultDate);
				return result;
			}

		} else {
			result.setError("returnCode:000010:商品信息错误");
			return result;
		}
		return result;
	}

	private Response<AppGoodsDetailModel> queryGoodsBacklog(String itemCode, String origin, String contIdcard,
			String custId, String queryType, Response<AppGoodsDetailModel> result, String[] goodsIds) {
		try {
			List<ItemModel> itemList = itemDao.findByCodes(Arrays.asList(goodsIds));
			if (itemList != null && itemList.size() > 0) {

				List<AppBackLogInfo> backLogInfolist = new ArrayList<>();
				for (ItemModel itemModel : itemList) {
					AppBackLogInfo backlogInfo = new AppBackLogInfo();
					// 库存数量
					backlogInfo.setGoodsBackLog(itemModel.getStock().toString());
					// 总供货数量【只增不减】
					long amount = itemModel.getGoodsTotal() + itemModel.getStock();
					backlogInfo.setGoodsTotal(Long.toString(amount));
					backLogInfolist.add(backlogInfo);
				}
				AppGoodsDetailModel appGoodsDetailModel = new AppGoodsDetailModel();
				// 设置库存值
				appGoodsDetailModel.setBacklogInfo(backLogInfolist);
				// 返回库存值
				result.setResult(appGoodsDetailModel);
			}
		} catch (Exception e) {
			result.setError("returnCode:000009:商品库存查询异常！");
		}
		return result;
	}

	private Response<AppGoodsDetailModel> queryGoodsDetail(String itemCode, String origin, String contIdcard,
			String custId, String queryType, Response<AppGoodsDetailModel> result) {
		// 设置返回参数
		AppGoodsDetailModel appGoodsDetailModel = new AppGoodsDetailModel();
		String goodsId = itemCode;// 商品CODE
		String mallType = "";// 传入的商城类型
		if (cn.com.cgbchina.common.utils.StringUtils.isEmpty(goodsId)) {
			result.setError("returnCode:000008:非法参数,商品编码不能为空！");
			return result;
		}
		boolean WXFlag = false;
		// 渠道判断
		if (Contants.CHANNEL_SN_WX.equals(origin) || Contants.CHANNEL_SN_WS.equals(origin)
				|| Contants.CHANNEL_SN_YX.equals(origin) || Contants.CHANNEL_SN_YS.equals(origin)) {
			WXFlag = true;
		}

		// int stages_num = 1; 这个字段没用到
		// 查询商品信息
		ItemModel itemModel = itemDao.findById(itemCode);
		GoodsModel goodsModel = new GoodsModel();
		if (itemModel != null && itemModel.getCode() != null) {
			goodsModel = goodsDao.findById(itemModel.getGoodsCode());
			appGoodsDetailModel.setGoodsModel(goodsModel);
			// 上架判断
			if ("03".equals(origin) && !"02".equals(goodsModel.getChannelPhone())) {
				result.setError("returnCode:000036:商品不在上架状态");
				return result;
			}
			// 商品信息判断
			if (goodsModel == null || itemModel == null) {
				result.setError("returnCode:000010:商品信息错误");
				return result;
			}
			mallType = goodsModel.getOrdertypeId();// 业务类型代码YG：广发JF：积分
			// TODO 有效期
			// 设置值
			appGoodsDetailModel.setGoodsType("1");
			appGoodsDetailModel.setGoodsNm(goodsModel.getName());
			appGoodsDetailModel.setGoodsMid(itemModel.getMid());
			appGoodsDetailModel.setGoodsOid(itemModel.getOid());
			appGoodsDetailModel.setGoodsXid(itemModel.getXid());
			appGoodsDetailModel.setMarketPrice(itemModel.getMarketPrice()==null?"":decimalFormat.format(itemModel.getMarketPrice()));
			// stages_num 一定是空 所以不做处理
			// 获取paywayList
			List<TblGoodsPaywayModel> paywayList = tblGoodsPaywayDao.findByGoodsIds(Arrays.asList(itemCode));
			String goods_price = "";
			if (paywayList != null) {
				List<AppStageInfo> list = new ArrayList<>();
				for (TblGoodsPaywayModel tblGoodsPaywayModel : paywayList) {

					AppStageInfo appstageInfo = new AppStageInfo();
					appstageInfo.setStagesNum(tblGoodsPaywayModel.getStagesCode() == null ? "" : tblGoodsPaywayModel
							.getStagesCode().toString());
					appstageInfo.setPerStage(tblGoodsPaywayModel.getPerStage() == null ? "" : tblGoodsPaywayModel.getPerStage().toString());
					appstageInfo.setPaywayIdF(tblGoodsPaywayModel.getGoodsPaywayId());
					list.add(appstageInfo);
					goods_price = tblGoodsPaywayModel.getGoodsPrice() == null ? "" : tblGoodsPaywayModel.getGoodsPrice().toString();
				}
				appGoodsDetailModel.setStageInfo(list);
			}
			appGoodsDetailModel.setGoodsPrice(goods_price);
			// 如果查询的是积分商城，则添加积分商城相关字段
			if (Contants.BUSINESS_TYPE_JF.equals(goodsModel.getOrdertypeId())) {
				appGoodsDetailModel.setJfType(goodsModel.getPointsType());
				appGoodsDetailModel.setGoods_type(goodsModel.getGoodsType());
				appGoodsDetailModel.setAreaCode(goodsModel.getRegionType());
				// 设置积分类型名称
				if (StringUtils.isNotEmpty(goodsModel.getPointsType())) {
					Response<TblCfgIntegraltypeModel> modelResponse = cfgIntegraltypeService.findById(goodsModel.getPointsType());
					if (modelResponse.isSuccess()) {
						appGoodsDetailModel.setJfTypeNm(modelResponse.getResult().getIntegraltypeNm());
					}
				}
				for (TblGoodsPaywayModel tblGoodsPaywayModel : paywayList) {
					if ("0000".equals(tblGoodsPaywayModel.getMemberLevel())) {
						appGoodsDetailModel.setJpPricePayid(tblGoodsPaywayModel.getGoodsPaywayId());
						appGoodsDetailModel
								.setJpPrice(tblGoodsPaywayModel.getGoodsPoint() != null ? tblGoodsPaywayModel
										.getGoodsPoint().toString() : null);
					}
					if ("0001".equals(tblGoodsPaywayModel.getMemberLevel())) {
						appGoodsDetailModel.setTzPricePayid(tblGoodsPaywayModel.getGoodsPaywayId());
						appGoodsDetailModel
								.setTzPrice(tblGoodsPaywayModel.getGoodsPoint() != null ? tblGoodsPaywayModel
										.getGoodsPoint().toString() : null);
					}
					if ("0002".equals(tblGoodsPaywayModel.getMemberLevel())) {
						appGoodsDetailModel.setDzPricePayid(tblGoodsPaywayModel.getGoodsPaywayId());
						appGoodsDetailModel
								.setDzPrice(tblGoodsPaywayModel.getGoodsPoint() != null ? tblGoodsPaywayModel
										.getGoodsPoint().toString() : null);
					}
					if ("0003".equals(tblGoodsPaywayModel.getMemberLevel())) {
						appGoodsDetailModel.setVipPricePayid(tblGoodsPaywayModel.getGoodsPaywayId());
						appGoodsDetailModel
								.setVipPrice(tblGoodsPaywayModel.getGoodsPoint() != null ? tblGoodsPaywayModel
										.getGoodsPoint().toString() : null);
					}
					if ("0004".equals(tblGoodsPaywayModel.getMemberLevel())) {
						appGoodsDetailModel.setBrhPricePayid(tblGoodsPaywayModel.getGoodsPaywayId());
						appGoodsDetailModel
								.setBrhPrice(tblGoodsPaywayModel.getGoodsPoint() != null ? tblGoodsPaywayModel
										.getGoodsPoint().toString() : null);
					}
					if ("0005".equals(tblGoodsPaywayModel.getMemberLevel())) {
						appGoodsDetailModel
								.setJfxjPricePayid(tblGoodsPaywayModel.getGoodsPaywayId());
						appGoodsDetailModel.setJfPart(tblGoodsPaywayModel.getGoodsPoint() != null ? tblGoodsPaywayModel
								.getGoodsPoint().toString() : null);
						appGoodsDetailModel.setXjPart(tblGoodsPaywayModel.getGoodsPrice().toString());
					}
					// 20151013 APP需求增加“活动积分” start
					if ("0006".equals(tblGoodsPaywayModel.getMemberLevel())) {
						appGoodsDetailModel.setActPointId(tblGoodsPaywayModel.getGoodsPaywayId());
						appGoodsDetailModel
								.setActPoint(tblGoodsPaywayModel.getGoodsPoint() != null ? tblGoodsPaywayModel
										.getGoodsPoint().toString() : null);
					}
					// 20151013 APP需求增加“活动积分” end
				}
			}
			Response<VendorInfoDto> vendor = vendorService.findById(goodsModel.getVendorId());
			VendorInfoDto vendorModel = new VendorInfoDto();
			// 获取供应商信息
			if (vendor.isSuccess()) {
				vendorModel = vendor.getResult();
			}
			appGoodsDetailModel.setVendorId(vendorModel.getVendorId());
			appGoodsDetailModel.setVendorFnm(vendorModel.getFullName());
			appGoodsDetailModel.setVendorSnm(vendorModel.getSimpleName());
			appGoodsDetailModel.setVendorPhone(vendorModel.getPhone());
			appGoodsDetailModel.setVendorTime(vendorModel.getVendorTime());
			appGoodsDetailModel.setTypePid("");
			appGoodsDetailModel.setLevelPnm("");
			//appGoodsDetailModel.setTypePid(goodsModel.getBackCategory2Id().toString());// 商品大类别ID obj[11]
			// 缓存取分类名
//			Response<BackCategory> rt = backCategoryService.findById(goodsModel.getBackCategory2Id());
//			if (rt.isSuccess() && rt.getResult() != null) {
//				appGoodsDetailModel.setLevelPnm(rt.getResult().getName());
//			}
			//appGoodsDetailModel.setTypeId(goodsModel.getBackCategory3Id().toString());
			appGoodsDetailModel.setTypeId("");
			appGoodsDetailModel.setLevelNm("");
			// 缓存取分类名
//			Response<BackCategory> rst = backCategoryService.findById(goodsModel.getBackCategory3Id());
//			if (rst.isSuccess() && rst.getResult() != null) {
//				appGoodsDetailModel.setLevelNm(rst.getResult().getName());
//			}
			appGoodsDetailModel.setGoodsSize(goodsModel.getFreightSize());
			String goodsBacklog = itemModel.getStock().toString();// 实际库存数量
			long amount = itemModel.getGoodsTotal() + itemModel.getStock();
			String goodsTotal = Long.toString(amount);// 总库存
			AppBackLogInfo appBackLogInfo = new AppBackLogInfo();
			// 数量 goodsBacklog
			appBackLogInfo.setGoodsBackLog(goodsBacklog);
			// 总供货数量【只增不减】
			appBackLogInfo.setGoodsTotal(goodsTotal);
			appGoodsDetailModel.setBacklogInfo(Arrays.asList(appBackLogInfo));
			String goods_detail_desc = goodsModel.getGoodsBaseDesc();//
			// 图片特殊处理
			String prop=goodsModel.getIntroduction();
			if (Contants.BUSINESS_TYPE_JF.equals(goodsModel.getOrdertypeId())) {
				// 手机渠道JF商品的商品详情过滤标签、图片、特殊字符 --20151224
				goods_detail_desc = goods_detail_desc == null ? "" : deleteImg(goods_detail_desc);
				prop= prop==null ?"" :deleteImg(prop);
			}
			//手机商城使用
			appGoodsDetailModel.setGoodsDetailDesc(goodsModel.getIntroduction());// 商品基本描述
			//APP使用
			appGoodsDetailModel.setGoodsProp1(prop);
			appGoodsDetailModel.setGoodsProp2("");
			// 原数据为空
			appGoodsDetailModel.setPaywayIdY("");
			// 原始设置为0
			appGoodsDetailModel.setAlertNum("0");
			// modifyDate
			String picture_url = "";
			// 由于依赖活动信息在接口实现
			// 活动状态
			// 市场价
			// 商品类型 1非活动商品 2团购 4 零元秒杀 3非零元秒杀
			if (WXFlag) {// 微信渠道
				String countLimit = "9";// 限购数
				if (!"".equals(countLimit)) {
					countLimit = String.valueOf(Math.round(Double.parseDouble(countLimit)));
					picture_url = makeImage(itemModel, picture_url);
				}
				//如果库存小于限购数   将限购数设置为库存
				if(!Strings.isNullOrEmpty(goodsBacklog)&&Integer.valueOf(goodsBacklog)<Integer.valueOf(countLimit)){
				    countLimit=goodsBacklog;
				}
				appGoodsDetailModel.setCountLimit(countLimit);// 限购
				// 微信渠道
				appGoodsDetailModel.setWechatAStatus(goodsModel.getChannelCreditWx());
				appGoodsDetailModel.setWechatStatus(goodsModel.getChannelMallWx());

			} else if (Contants.SOURCE_ID_APP.equals(origin)) {// APP渠道

				if ("02".equals(goodsModel.getChannelApp())) {
					appGoodsDetailModel.setAppStatus("0203");// APP状态上架
				} else if ("01".equals(goodsModel.getChannelApp())) {
					appGoodsDetailModel.setAppStatus("0204");// APP状态下架
				} else {
					appGoodsDetailModel.setAppStatus(goodsModel.getChannelApp());// APP状态
				}
				picture_url = makeImage(itemModel, picture_url);
			} else {// 手机渠道
				if ("JF".equals(mallType)) {
					picture_url = itemModel.getImage1();
				} else {
					picture_url = makeImage(itemModel, picture_url);
				}
			}

			// #######################################
			// 返回商品属性一、属性二、属性值一、属性值二的内容--20160217 APP需求(二期)
			List<AppGoodsInfo> goodsInfos = new ArrayList<>();
			AppGoodsInfo appGoodsInfo = new AppGoodsInfo();
			appGoodsInfo.setGoodsId(itemModel.getCode());// 商品编码
			appGoodsInfo.setGoodsAttr1(itemModel.getAttributeKey1()==null?"":itemModel.getAttributeKey1());// 属性一
			appGoodsInfo.setGoodsAttr2(itemModel.getAttributeKey2()==null?"":itemModel.getAttributeKey2());// 属性二
			appGoodsInfo.setGoodsColor(itemModel.getAttributeName1()==null?"":itemModel.getAttributeName1());
			appGoodsInfo.setGoodsModel(itemModel.getAttributeName2()==null?"":itemModel.getAttributeName2());
			goodsInfos.add(appGoodsInfo);
			// begin 此处添加商品组概念  手机银行不需要添加
			if(!origin.equals(Contants.ORDER_SOURCE_ID_MOBILE)){
				List<String> goodsIdList=new ArrayList<>();
				goodsIdList.add(itemModel.getGoodsCode());
				Response<List<ItemModel>>  rsitem=itemService.findItemListByGoodsCodeList(goodsIdList);
				if(rsitem.isSuccess()){
					List<ItemModel> list=rsitem.getResult();
					for (ItemModel itemModel2 : list) {
						if(!itemModel.getCode().equals(itemModel2.getCode())){
							AppGoodsInfo appGoodsInfos = new AppGoodsInfo();
							appGoodsInfos.setGoodsId(itemModel2.getCode());// 商品编码
							appGoodsInfos.setGoodsAttr1(itemModel2.getAttributeKey1()==null?"":itemModel2.getAttributeKey1());// 属性一
							appGoodsInfos.setGoodsAttr2(itemModel2.getAttributeKey2()==null?"":itemModel2.getAttributeKey2());// 属性二
							appGoodsInfos.setGoodsColor(itemModel2.getAttributeName1()==null?"":itemModel2.getAttributeName1());
							appGoodsInfos.setGoodsModel(itemModel2.getAttributeName2()==null?"":itemModel2.getAttributeName2());
							goodsInfos.add(appGoodsInfos);
						}
					}
				}
			}
			// end 添加商品组结束
			appGoodsDetailModel.setGoodsInfo(goodsInfos);
			// 图片地址
			appGoodsDetailModel.setPictureUrl(picture_url);
			// 新商城没有商品组的概念了

			// 获取用户可兑换积分
			String curMonth = new SimpleDateFormat("yyyyMM").format(new Date());
			List<PointPoolModel> list = pointPoolDao.getPointPool(curMonth);
			long availableIntegral = 0;// 积分池剩余积分
			String canIntegral = "";// 可兑换积分 倍率X售价X单位积分
			String unitIntegral = "";// 单位积分
			String ifFixPoint = "";// 是否固定积分
			if (Strings.isNullOrEmpty(itemModel.getFixPoint()==null?"":itemModel.getFixPoint().toString())) {
				ifFixPoint = "0";
			} else {
				ifFixPoint = "1";
			}
 			if (list != null && list.size() > 0) {
				PointPoolModel pointPoolModel = list.get(0);
				String maxPoint = pointPoolModel.getMaxPoint() == null ? "" : pointPoolModel.getMaxPoint().toString();
				String usedPoint = pointPoolModel.getUsedPoint() == null ? "" : pointPoolModel.getUsedPoint()
						.toString();
				unitIntegral = pointPoolModel.getSinglePoint() == null ? "" : pointPoolModel.getSinglePoint()
						.toString();
				String pointRate = pointPoolModel.getPointRate() == null ? "" : pointPoolModel.getPointRate()
						.toString();// 全局倍率
				String bestRate = itemModel.getBestRate() == null ? "" : itemModel.getBestRate().toString();// 产品倍率
				log.info("当月最大积分数：" + maxPoint + "已用积分数：" + usedPoint + "最高倍率：" + pointRate + "产品倍率:" + bestRate);
				// 倍率优先取"产品倍率"，若"产品倍率"为空，则取"全局倍率"
				String rate = "".equals(bestRate) ? pointRate : bestRate;
				appGoodsDetailModel.setRate(rate);//设置倍率如果
				if (!"".equals(maxPoint)) {
					availableIntegral = Long.parseLong(maxPoint) - Long.parseLong(usedPoint);
					if (availableIntegral > 0) {// 剩余积分大于0时，才能使用积分抵扣
						// 如果是手机的请求,无需考虑商品是否维护固定积分，保持现有的规则计算可使用积分，如果是微信/APP的请求，则如果ifFixPoint是1则取固定积分的值返回给微信
						if ("1".equals(ifFixPoint) && (WXFlag || Contants.SOURCE_ID_APP.equals(origin))) {
							canIntegral = itemModel.getFixPoint() == null ? "" : itemModel.getFixPoint().toString();
						} else {
							canIntegral = String.valueOf(Math.round(Long.parseLong(unitIntegral) * Double.parseDouble(rate)
									* Double.parseDouble(goods_price)));// 单位积分X倍率X售价
						}
					}
				}
			}
 			//
 			
			// 设置值
			appGoodsDetailModel.setCanIntegral(canIntegral);// 可兑换积分
			appGoodsDetailModel.setUnitIntegral(unitIntegral);// 单位积分
			appGoodsDetailModel.setIfFixPoint(ifFixPoint);// 是否固定积分 1-是；0-否

			// 优惠券处理

			// 微信端实现客户等级进行积分折扣
			if (WXFlag || Contants.SOURCE_ID_APP.equals(origin)) {// APP渠道也实现客户等级进行积分折扣 --20151014 APP需求
				Map custLevelMap = getCustLevelInfo(contIdcard);
				appGoodsDetailModel.setCustLevel((String) custLevelMap.get("custLevel"));// 客户级别
				appGoodsDetailModel.setCustPointRate((String) custLevelMap.get("custPointRate"));// 客户级别折扣比例
			}
			appGoodsDetailModel.setVendorTime(vendorModel.getServiceTime());

			// 如果是团购则 设置已参加活动的数量-团购商品返回已参加活动的数量 actionCount
			Long soldNum = itemModel.getGoodsTotal();
			appGoodsDetailModel.setSoldNum(soldNum + "");
			appGoodsDetailModel.setBestRate(itemModel.getBestRate() != null ? itemModel.getBestRate().doubleValue()
					: null);

			if (cn.com.cgbchina.common.utils.StringUtils.isEmpty(custId)) {// 客户号不为空 查询收藏状态 和提醒状态
				// 目前该表不迁移
			}
			// 设置数据
			result.setResult(appGoodsDetailModel);
		} else {
			result.setError("returnCode:000010:商品信息错误");
		}
		return result;
	}

	private Map getCustLevelInfo(String certNbr) {
		Map returnMap = new HashMap();
		if (StringUtils.isEmpty(certNbr)) {
			// 如果没有送证件号码，客户等级为0
			returnMap.put("custLevel", "0");// 客户级别
			returnMap.put("custPointRate", "0");// 客户级别折扣比例
		} else {
			String memberLevel = Contants.MEMBER_LEVEL_JP;// 默认金普等级
			String custLevel = "1";// 默认金普等级
			Date birthday = null;
			Response<List<ACustToelectronbankModel>> resp = aCustToelectronbankService
					.findUserBirthInfo(certNbr);

			if (resp.isSuccess()) {
				List<ACustToelectronbankModel> m = resp.getResult();
				List<CouponScaleModel> piontDisList = couponScaleDao.findAll();
				Map map = new HashMap();
				for (CouponScaleModel couponScaleModel : piontDisList) {
					map.put(couponScaleModel.getType(), couponScaleModel.getScale());
				}
				if (m != null && m.size() > 0) {
					ACustToelectronbankModel md = m.get(0);
					String cardLevel = md.getCardLevelCd();// 卡等级代码
					String VipTp = md.getVipTpCd();// 客户VIP标志
					birthday = md.getBirthDay();// 客户生日
					// 通过客户证件号码,客户级别（数据集市提供的数据）,客户标识计算出客户最优等级（商城的客户级别）
					memberLevel = calMemberLevel(certNbr, cardLevel, VipTp, m);
					float disc = 1.00f;
					if (piontDisList != null && piontDisList.size() > 0) {
						if (Contants.MEMBER_LEVEL_JP.equals(memberLevel)) {
							// 金普
							disc = Float.parseFloat(map.get(memberLevel).toString());
							custLevel = "1";
						} else if (Contants.MEMBER_LEVEL_TJ.equals(memberLevel)) {
							// 钛金卡 + 臻享白金
							disc = Float.parseFloat(map.get(memberLevel).toString());
							custLevel = "2";
						} else if (Contants.MEMBER_LEVEL_DJ.equals(memberLevel)) {
							// 增值白金卡+顶级卡
							disc = Float.parseFloat(map.get(memberLevel).toString());
							custLevel = "3";
						} else if (Contants.MEMBER_LEVEL_VIP.equals(memberLevel)) {
							// VIP等级
							disc = Float.parseFloat(map.get(memberLevel).toString());
							custLevel = "4";
						}
						if (birthday != null && isBirthday(birthday)) {
							float birthDisc = disc = Float.parseFloat(map.get(memberLevel).toString());
							if (birthDisc < disc) {
								disc = birthDisc;
								custLevel = "5";// 生日
							}
						}
					}
					returnMap.put("custLevel", custLevel);// 客户级别
					returnMap.put("custPointRate", String.valueOf(disc));// 客户级别折扣比例
				} else {
					// 若在本地客户表查不到数据（因该数据会从核心同步过来，但会存在延迟几天），则默认为金普等级
					returnMap.put("custLevel", custLevel);// 客户级别
					returnMap.put("custPointRate", String.valueOf(Float.parseFloat(map.get(memberLevel).toString())));// 客户级别折扣比例
				}

			}
		}

		return returnMap;
	}

	/**
	 * @ 判断date的月份与当天的月份是否一致
	 */
	public boolean isBirthday(Date date) {
		if (date != null) {
			GregorianCalendar mydate = new GregorianCalendar(TimeZone.getDefault(), Locale.CHINA);
			mydate.setTime(date);
			SimpleDateFormat sdf = new SimpleDateFormat("MM");
			String currDayMM = sdf.format(date.getTime());
			SimpleDateFormat sdf1 = new SimpleDateFormat("yyyyMMdd");
			String birthDay = sdf1.format(date);
			if (birthDay.length() == 4 && birthDay.substring(0, 2).equals(currDayMM)) {
				return true;
			}
			if (birthDay.length() == 8 && birthDay.substring(4, 6).equals(currDayMM)) {
				return true;
			}
		}
		return false;
	}

	private String calMemberLevel(String certNbr, String cardLevel, String VipTp, List<ACustToelectronbankModel> m) {
		// 格式化客户标识
		if (VipTp != null && VipTp.length() > 2) {
			VipTp = VipTp.substring(0, 2);
		}
		if (Contants.LEVEL_CODE_4.equals(cardLevel)) {
			// 若为顶级卡,返回增值白金/顶级级别
			return Contants.MEMBER_LEVEL_DJ;
		} else if (Contants.LEVEL_CODE_3.equals(cardLevel)) {
			// 若为白金卡,通过卡板代码判断白金等级
			List<ACustToelectronbankModel> cardInfoList = m;
			if (cardInfoList != null) {
				for (int i = 0; i < cardInfoList.size(); i++) {
					ACustToelectronbankModel cardInfoMap = cardInfoList.get(i);
					String cardLevelId = cardInfoMap.getCardLevelCd();
					if (Contants.INCREMENT_BJ.equals(cardLevelId)) {
						// 若为增值白金卡板,返回顶级卡级别
						return Contants.MEMBER_LEVEL_DJ;
					}
				}
			}
			// 若为普通白金,判断客户标识
			if ("VV".equals(VipTp) || "P1".equals(VipTp)) {
				// 客户标识为VV/P1,提升客户等级为顶级/增值白金等级
				return Contants.MEMBER_LEVEL_DJ;
			} else {
				return Contants.MEMBER_LEVEL_TJ;
			}
		} else if (Contants.LEVEL_CODE_2.equals(cardLevel)) {
			// 若为钛金卡,判断客户标识
			if ("VV".equals(VipTp) || "P1".equals(VipTp)) {
				// 客户标识为VV/P1,提升客户等级为顶级/增值白金等级
				return Contants.MEMBER_LEVEL_DJ;
			} else {
				return Contants.MEMBER_LEVEL_TJ;
			}
		} else {
			// 若为金卡或普卡,判断客户标识
			if ("VV".equals(VipTp) || "P1".equals(VipTp)) {
				// 客户标识为VV/P1,提升客户等级为顶级/增值白金等级
				return Contants.MEMBER_LEVEL_DJ;
			} else if ("P2".equals(VipTp)) {
				// 客户标识为P2,提升客户等级为钛金卡
				return Contants.MEMBER_LEVEL_TJ;
			} else if (isVip(VipTp)) {
				// 客户标识为V1/V2/V3,提升客户等级为VIP等级
				return Contants.MEMBER_LEVEL_VIP;
			} else {
				// 返回金普卡等级
				return Contants.MEMBER_LEVEL_JP;
			}
		}
	}

	private boolean isVip(String VipTp) {
		// 格式化客户标识
		if (VipTp != null && VipTp.length() > 2) {
			VipTp = VipTp.substring(0, 2);
		}
		if ("VV".equals(VipTp) || "V1".equals(VipTp) || "V2".equals(VipTp) || "V3".equals(VipTp)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * 屏蔽标签
	 * 
	 * @param goods_detail_desc
	 * @return
	 */
	private String deleteImg(String goods_detail_desc) {
		goods_detail_desc = goods_detail_desc.replaceAll("&lt;", "<");
		goods_detail_desc = goods_detail_desc.replaceAll("&gt;", ">");
		goods_detail_desc = goods_detail_desc.replaceAll("<[^>]*>", "");// 替换掉html标签里面的内容
		goods_detail_desc = goods_detail_desc.replace("^", "");
		String regex0 = "<(\\/br|br)[\\/\\s]*>";// 替换换行符<br>
		Pattern pattern0 = Pattern.compile(regex0, Pattern.CASE_INSENSITIVE);
		Matcher matcher0 = pattern0.matcher(goods_detail_desc);
		while (matcher0.find()) {
			goods_detail_desc = goods_detail_desc.replaceAll(matcher0.group(), "^");
		}

		String regex = "<[a-zA-Z0-9\"\\=\\s\\.\\:\\/\\#\\-;]*>";// 去除html标签
		Pattern pattern = Pattern.compile(regex);
		Matcher matcher = pattern.matcher(goods_detail_desc);
		while (matcher.find()) {
			goods_detail_desc = goods_detail_desc.replace(matcher.group(), "");
		}
		String regex1 = "&[a-zA-Z]*;";// 去除转义的html字符
		Pattern pattern1 = Pattern.compile(regex1);
		Matcher matcher1 = pattern1.matcher(goods_detail_desc);
		while (matcher1.find()) {
			goods_detail_desc = goods_detail_desc.replace(matcher1.group(), "");
		}
		return goods_detail_desc;
	}
}
