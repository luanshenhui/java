package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.dto.OrderInputDto;
import cn.com.cgbchina.trade.dto.OrderOutputDto;
import cn.com.cgbchina.trade.dto.OrderQueryConditionDto;
import cn.com.cgbchina.trade.manager.OrderSubManager;
import cn.com.cgbchina.trade.model.*;
import com.google.common.base.Function;
import com.google.common.base.Throwables;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.jms.mq.QueueSender;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * 订单 导入导出
 *
 * Created by zhoupeng on 2016/7/20.
 */
@Service
@Slf4j
public class OrderIOServiceImpl implements OrderIOService {

	private final static String SUCCESS_FLAG_Y = "成功";
	private final static String SUCCESS_FLAG_N = "失败";
	public static final String YGoutportConsign = "YGoutportConsign";// 广发发货导出
	public static final String YGimportConsign = "YGimportConsign";// 广发发货导入
	public static final String YGoutportOrdersign = "YGoutportOrdersign";// 广发签收导出
	public static final String YGimportOrdersign = "YGimportOrdersign";// 广发签收导入
	public static final String JFoutportConsign = "JFoutportConsign";// 积分发货导出
	public static final String JFimportConsign = "JFimportConsign";// 积分发货导入
	public static final String JFoutportOrdersign = "JFoutportOrdersign";// 积分签收导出
	public static final String YGOrderRevokeExport = "YGOrderRevokeExport";// 广发（一期）撤单导出
	public static final String JFimportOrdersign = "JFimportOrdersign";// 积分签收导入

	@Resource
	OrderSubDao orderSubDao;
    @Resource
    OrderMainDao orderMainDao;
	@Resource
    OrderTransDao orderTransDao;
    @Resource
    OrderSubManager orderSubManager;
    @Resource
    OrderPartBackDao orderPartBackDao;
	@Resource
	TblOrderHistoryDao tblOrderHistoryDao;
	@Resource
	ItemService itemService;
	@Resource
	GoodsPayWayService goodsPayWayService;
	@Autowired
	@Qualifier("orderSender")
	private QueueSender queueSender;
	@Autowired
	private RedisService redisService;

	/**
	 * 批量导出订单信息
	 *
	 * @return
	 */
	@Override
	public Response<List<OrderOutputDto>> exportOrderInfo(Map mapQuery, User user) {

		// 构造返回值及参数
		Response<List<OrderOutputDto>> response = new Response<List<OrderOutputDto>>();

		try {
			Map<String, Object> paramMap = conditionsToMap(mapQuery, user);

			Map<String, Object> mapResult = findOrderInfo(paramMap, user, YGoutportConsign);
			// 判断 处理对象时候有值
			if (null != mapResult) {
				// 更新 订单信息
				Boolean flag = orderSubManager.updateBatch((List<OrderSubModel>) mapResult.get("orderSubModelList"),
						(List<OrderDoDetailModel>) mapResult.get("orderDoDetailModels"));
				if (flag) {
					response.setResult((List<OrderOutputDto>) mapResult.get("orderOutputDtos"));
				} else {
					log.error("exportOrderInfo.updateBatch,update failed");
					response.setError("BatchUpdate.OrderStatus.fails");
				}
			} else {
				// 没有查询到数据
				response.setResult(null);
			}
		} catch (Exception e) {
			log.error("exportOrderInfo.operate.failed,error msg:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderIOServiceImpl.output.error");
		}
		return response;
	}

	/**
	 * 批量签收导出
	 *
	 * @return
	 */
	@Override
	public Response<List<OrderOutputDto>> exportOrderSign(Map mapQuery, User user) {

		// 构造返回值及参数
		Response<List<OrderOutputDto>> response = new Response<List<OrderOutputDto>>();
		try {
			Map<String, Object> paramMap = conditionsToMap(mapQuery, user);

			Map<String, Object> mapResult = findOrderInfo(paramMap, user, YGoutportOrdersign);
			if (null != mapResult) {
				response.setSuccess(Boolean.TRUE);
				response.setResult((List<OrderOutputDto>) mapResult.get("orderOutputDtos"));
			} else {
				// 没有查询到数据
				response.setResult(null);
			}
		} catch (Exception e) {
			log.error("OrderIOServiceImpl.exportOrderSign(),error msg:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderIOServiceImpl.output.error");
		}
		return response;
	}

	private List<String> getOrderMainIds(List<OrderSubModel> orderSubModelList) {
		List<String> orderMainIds = Lists.transform(orderSubModelList, new Function<OrderSubModel, String>() {
			@NotNull
			@Override
			public String apply(@NotNull OrderSubModel input) {
				return input.getOrdermainId();
			}
		});
		return orderMainIds;
	}

	private Map<String, OrderMainModel> getOrderMainMap(List<OrderMainModel> orderMainModels) {
		Map<String, OrderMainModel> orderMainMap = Maps.uniqueIndex(orderMainModels,
				new Function<OrderMainModel, String>() {
					@NotNull
					@Override
					public String apply(@NotNull OrderMainModel input) {
						return input.getOrdermainId();
					}
				});
		return orderMainMap;
	}

	private List<String> getItems(List<OrderSubModel> orderSubModelList) {
		List<String> itemCodes = Lists.transform(orderSubModelList, new Function<OrderSubModel, String>() {
			@NotNull
			@Override
			public String apply(@NotNull OrderSubModel input) {
				return input.getGoodsId();
			}
		});
		Set<String> set = new HashSet<String>();
		set.addAll(itemCodes);// 取出

		List<String> itemList = Lists.newArrayList(set);
		return itemList;
	}

	private Map<String, ItemModel> getItemMap(List<ItemModel> items) {
		Map<String, ItemModel> itemMap = Maps.uniqueIndex(items, new Function<ItemModel, String>() {
			@NotNull
			@Override
			public String apply(@NotNull ItemModel input) {
				return input.getCode();
			}
		});
		return itemMap;
	}

	private List<String> getOrderIds(List<OrderSubModel> orderSubModelList) {
		List<String> orderIds = Lists.transform(orderSubModelList, new Function<OrderSubModel, String>() {
			@NotNull
			@Override
			public String apply(@NotNull OrderSubModel input) {
				return input.getOrderId();
			}
		});
		return orderIds;
	}

	/**
	 * 获取goodsPayway信息
	 *
	 * @param subModels
	 * @return
	 */
	private Map<String, TblGoodsPaywayModel> getGoodsPaywayMap(List<OrderSubModel> subModels) {

		List<String> ids = Lists.transform(subModels, new Function<OrderSubModel, String>() {
			@NotNull
			@Override
			public String apply(@NotNull OrderSubModel input) {
				return input.getGoodsPaywayId();
			}
		});

		Response<List<TblGoodsPaywayModel>> paywayResponse = goodsPayWayService
				.findByGoodsPayWayIdList(Lists.newArrayList(ids));
		if (!paywayResponse.isSuccess()) {
			log.debug("GoodsPayWayService.findByGoodsPayWayIdList.fail,code:{}", paywayResponse.getError());
			return null;
		}
		List<TblGoodsPaywayModel> models = paywayResponse.getResult();
		if (null == models || models.isEmpty())
			return null;
		Map<String, TblGoodsPaywayModel> paywayModelMap = Maps.uniqueIndex(models,
				new Function<TblGoodsPaywayModel, String>() {
					@NotNull
					@Override
					public String apply(@NotNull TblGoodsPaywayModel input) {
						return input.getGoodsPaywayId();
					}
				});
		return paywayModelMap;
	}

	/**
	 * 查询 即将导出的订单信息 对象 批量发货，批量签收
	 *
	 * @param paramMap 查询条件
	 * @param user 操作人
	 * @param orderType 业务类型
	 * @return map
	 */
	private Map<String, Object> findOrderInfo(Map<String, Object> paramMap, User user, String orderType) {

		// 获取子订单列表数据 六个月之内订单
		List<OrderSubModel> orderSubModelList = queryOrderTb(paramMap);

		List<OrderOutputDto> orderOutputDtos = Lists.newArrayList();
		List<OrderDoDetailModel> orderDoDetailModels = Lists.newArrayList();
		Map<String, Object> mapResult = null;
		OrderOutputDto orderOutputDto = null;
		OrderMainModel orderMainModel = null;
		OrderTransModel orderTransModel = null;
		String orderMainId = "";

        if (null == orderSubModelList || orderSubModelList.isEmpty()) {
            return mapResult;
        }

		// 查询payway信息
		Map<String, TblGoodsPaywayModel> paywayIds = getGoodsPaywayMap(orderSubModelList);

		if (null == paywayIds) {
			paywayIds = Maps.newHashMapWithExpectedSize(1);
		}

		// 主订单数据
		List<String> orderMainIds = getOrderMainIds(orderSubModelList);

		Map<String, OrderMainModel> orderMainMap;
		Map<String, ItemModel> itemMap;
		Map<String, OrderTransModel> transModelMap;
		Map<String, Object> param = ImmutableMap.<String, Object> of("orderMainIdList", orderMainIds);
		List<OrderMainModel> orderMainModels = orderMainDao.findOrdersByList(param);

		if (null != orderMainModels && !orderMainModels.isEmpty()) {
			orderMainMap = getOrderMainMap(orderMainModels);
		} else {
			orderMainMap = Maps.newHashMapWithExpectedSize(1);
		}

		// 单品信息查询
		List<String> itemCodes = getItems(orderSubModelList);
		Response<List<ItemModel>> itemRes = itemService.findByCodes(itemCodes);
		if (itemRes.isSuccess()) {
			List<ItemModel> items = itemRes.getResult();
			if (null != items && !items.isEmpty()) {
				itemMap = getItemMap(items);
			} else {
				itemMap = Maps.newHashMapWithExpectedSize(1);
			}
		} else {
			itemMap = Maps.newHashMapWithExpectedSize(1);
		}
		//查询物流信息
		List<String> orderIds = getOrderIds(orderSubModelList);

		List<OrderTransModel> orderTransModels = orderTransDao.findByOrderIds(orderIds);
		if(orderTransModels == null){
			transModelMap = Maps.newHashMap();
		}
		transModelMap = getOrderTransMap(orderTransModels);
        // 遍历orderSubModel，构造返回值
        for (int i = 0; i < orderSubModelList.size(); i++) {
            OrderSubModel orderSubModel = orderSubModelList.get(i);

			if (!orderMainId.equals(orderSubModel.getOrdermainId())) {
				orderMainId = orderSubModel.getOrdermainId() == null ? "" : orderSubModel.getOrdermainId();
				orderMainModel = orderMainMap.get(orderMainId);
			}
			orderTransModel = transModelMap.get(orderSubModel.getOrderId());
			//防止物流信息为空
			if (orderTransModel == null){
				orderTransModel = new OrderTransModel();
			}

			// 查询礼品编码和商品编码
			String goodsId = orderSubModel.getGoodsId();
			String xid = "";// 礼品编码
			String mid = "";// 商品编码
			ItemModel itemModel = itemMap.get(goodsId);

			if (itemModel != null) {
				xid = itemModel.getXid();
				mid = itemModel.getMid();
			}

			if (null != orderMainModel) {
				// 送货时间01: 工作日、双休日与假日均可送货02: 只有工作日送货（双休日、假日不用送）03: 只有双休日、假日送货（工作日不用送货）
				String bpCustGrp = orderMainModel.getBpCustGrp() == null ? "" : orderMainModel.getBpCustGrp();

				switch (bpCustGrp) {
				case "01":
					bpCustGrp = "工作日、双休日与假日均可送货";
					break;
				case "02":
					bpCustGrp = "只有工作日送货（双休日、假日不用送）";
					break;
				case "03":
					bpCustGrp = "只有双休日、假日送货（工作日不用送货）";
					break;
				default:
					break;
				}
				// 发货状态
				String goodssendFlag = orderSubModel.getGoodssendFlag() == null ? "" : orderSubModel.getGoodssendFlag();
				switch (goodssendFlag) {
				case Contants.GOODS_SEND_FLAG_0:
					goodssendFlag = Contants.GOODS_SEND_NAME_0;
					break;
				case Contants.GOODS_SEND_FLAG_1:
					goodssendFlag = Contants.GOODS_SEND_NAME_1;
					break;
				case Contants.GOODS_SEND_FLAG_2:
					goodssendFlag = Contants.GOODS_SEND_NAME_2;
					break;
				default:
					break;
				}

				// 客户等级
				String custType = orderSubModel.getCustType() == null ? "" : orderSubModel.getCustType();
				switch (custType) {
				case Contants.CUST_LEVEL_CODE_A:
					custType = Contants.CUST_LEVEL_NAME_A;
					break;
				case Contants.CUST_LEVEL_CODE_B:
					custType = Contants.CUST_LEVEL_NAME_B;
					break;
				case Contants.CUST_LEVEL_CODE_C:
					custType = Contants.CUST_LEVEL_NAME_C;
					break;
				case Contants.CUST_LEVEL_CODE_D:
					custType = Contants.CUST_LEVEL_NAME_D;
					break;
				default:
					break;
				}

				// 00: 商城01: CallCenter02: IVR渠道03: 手机商城04: 短信渠道05: 微信广发银行06：微信广发信用卡09:APP
				String sourceId = orderSubModel.getSourceId();
				String custorderMainDesc = "";
				String ccorderMainDesc = "";
				switch (sourceId) {
				case Contants.PROMOTION_SOURCE_ID_00:
					sourceId = Contants.PROMOTION_SOURCE_NAME_00;
					custorderMainDesc = orderMainModel.getOrdermainDesc();
					break;
				case Contants.PROMOTION_SOURCE_ID_01:
					sourceId = Contants.PROMOTION_SOURCE_NAME_01;
					ccorderMainDesc = orderMainModel.getOrdermainDesc();
					break;
				case Contants.PROMOTION_SOURCE_ID_02:
					sourceId = Contants.PROMOTION_SOURCE_NAME_02;
					break;
				case Contants.PROMOTION_SOURCE_ID_03:
					sourceId = Contants.PROMOTION_SOURCE_NAME_03;
					break;
				case Contants.PROMOTION_SOURCE_ID_04:
					sourceId = Contants.PROMOTION_SOURCE_NAME_04;
					break;
				case Contants.PROMOTION_SOURCE_ID_05:
					sourceId = Contants.PROMOTION_SOURCE_NAME_05;
					break;
				case Contants.PROMOTION_SOURCE_ID_06:
					sourceId = Contants.PROMOTION_SOURCE_NAME_06;
					break;
				case Contants.PROMOTION_SOURCE_ID_09:
					sourceId = Contants.PROMOTION_SOURCE_NAME_09;
					break;
				default:
					sourceId = "未知渠道";
					break;
				}
				TblGoodsPaywayModel goodsPaywayModel = paywayIds.get(orderSubModel.getGoodsPaywayId());
				// 格式化金额
				DecimalFormat f1 = new DecimalFormat("0.00");
				String singlePrice = "￥" + f1.format(goodsPaywayModel == null ? 0
						: goodsPaywayModel.getGoodsPrice() == null ? 0 : goodsPaywayModel.getGoodsPrice());
				String totalMoney = "￥"
						+ f1.format(orderSubModel.getTotalMoney() == null ? 0 : orderSubModel.getTotalMoney());
				String voucherPrice = "￥"
						+ f1.format(orderSubModel.getVoucherPrice() == null ? 0 : orderSubModel.getVoucherPrice());

				// -----------------------------------准备DB更新数据----------------------------------------

				String actionFlag = "是";
				// 待发货的订单导出------> 需要更新数据。批量导出已发货的订单 只需要导出订单即可
				if (YGoutportConsign.equals(orderType) || JFoutportConsign.equals(orderType)) {

					// 0 不是，1 是 活动秒杀产品
					String actType = orderSubModel.getActType();// 是否为秒杀商品
					int miaoFlag = orderSubModel.getMiaoshaActionFlag() == null ? 0
							: orderSubModel.getMiaoshaActionFlag();// 活动商品 0 非活动商品 1 活动商品
					// 若订单状态为"支付成功"，则修改为"发货中"更新订单状态为发货中，插入订单历史操作表, 注意：0元秒杀订单不做处理
					// log.info("批量发货：合作商的订单0元秒杀标志位：" + miaoFlag);
					if (!(Contants.PROMOTION_PROM_TYPE_STRING_30.equals(actType) && 1 == miaoFlag
							&& 0 == BigDecimal.ZERO.compareTo(orderSubModel.getTotalMoney()))) {
						// 0元秒杀商品 除外
						// 不是活动商品
						if (0 == miaoFlag) {
							actionFlag = "否";
						}
						orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0306);
						orderSubModel.setCurStatusNm(Contants.SUB_ORDER_DELIVER_HANDLING);
					}

					Date date = new Date();
					String userId = user.getId();
					orderSubModel.setModifyOper(userId);
					orderSubModel.setModifyTime(date);
					// 明细表
					OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
					orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
					orderDoDetailModel.setDoTime(date);
					orderDoDetailModel.setDoUserid(userId);
					orderDoDetailModel.setUserType("2");
					orderDoDetailModel.setStatusId(Contants.SUB_ORDER_STATUS_0306);
					orderDoDetailModel.setStatusNm(Contants.SUB_ORDER_DELIVER_HANDLING);
					orderDoDetailModel.setMsgContent("");
					orderDoDetailModel.setDoDesc("");
					orderDoDetailModel.setCreateOper(userId);
					orderDoDetailModel.setCreateTime(date);
					orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
					orderDoDetailModels.add(orderDoDetailModel);
				}

				// -----------------------------------准备导出Excel数据----------------------------------------
				// 收货地址拼接 修改306500 导出报表收货地址显示有误 niufw
				if (StringUtils.isEmpty(orderMainModel.getCsgProvince())) {
					orderMainModel.setCsgProvince("");
				}
				if (StringUtils.isEmpty(orderMainModel.getCsgCity())) {
					orderMainModel.setCsgCity("");
				}
				if (StringUtils.isEmpty(orderMainModel.getCsgBorough())) {
					orderMainModel.setCsgBorough("");
				}
				if (StringUtils.isEmpty(orderMainModel.getCsgAddress())) {
					orderMainModel.setCsgAddress("");
				}
				String csgAddress = orderMainModel.getCsgProvince() + orderMainModel.getCsgCity()
						+ orderMainModel.getCsgBorough() + orderMainModel.getCsgAddress();
				if (StringUtils.isEmpty(csgAddress)) {
					csgAddress = "";
				}

				orderOutputDto = new OrderOutputDto(i + 1, orderSubModel.getOrderId(), orderSubModel.getGoodsCode(),
						xid, mid, orderSubModel.getGoodsNm(), singlePrice, orderSubModel.getSpecShopno(), actionFlag,
						orderSubModel.getGoodsNum(), orderSubModel.getStagesNum(), totalMoney,
						orderSubModel.getUitdrtamt(), voucherPrice, orderSubModel.getGoodsBrand(),
						orderSubModel.getGoodsModel(), orderSubModel.getGoodsColor(), orderSubModel.getGoodsPresent(),
						orderSubModel.getGoodsPresentDesc(), orderMainModel.getInvoice(), orderMainModel.getContNm(),
						orderMainModel.getCsgName(), orderMainModel.getCsgPhone1(), orderMainModel.getCsgPhone2(),
						csgAddress, orderMainModel.getCsgPostcode(), sourceId, custorderMainDesc, ccorderMainDesc,
						bpCustGrp, orderSubModel.getCurStatusNm(), orderSubModel.getSinStatusNm(), goodssendFlag,
						custType, orderSubModel.getOrderDesc(), orderMainModel.getOrdermainDesc(),
						orderTransModel.getTranscorpNm(),orderTransModel.getMailingNum());
				// 设置供应商信息
				orderOutputDto.setVendorId(orderSubModel.getVendorId());
				orderOutputDto.setVendorSnm(orderSubModel.getVendorSnm());

				orderOutputDtos.add(orderOutputDto);
			}
		}

		mapResult = Maps.newHashMapWithExpectedSize(3);
		mapResult.put("orderSubModelList", orderSubModelList);
		mapResult.put("orderDoDetailModels", orderDoDetailModels);
		mapResult.put("orderOutputDtos", orderOutputDtos);
		return mapResult;
	}


	/**
	 * 查询条件处理
	 *
	 * @param mapQuery
	 * @param user
	 * @return
	 */
	private Map<String, Object> conditionsToMap(Map mapQuery, User user) {
		Map<String, Object> paramMap = Maps.newHashMap();
		// 剔除无值得条件
		for (Object key : mapQuery.entrySet()) {
			Map.Entry entry = (Map.Entry) key;
			String keyTemp = String.valueOf(entry.getKey());
			String valueTemp = String.valueOf(entry.getValue());
			if (null != valueTemp && !"".equals(valueTemp) && !"null".equals(valueTemp))
				paramMap.put(keyTemp, valueTemp);
		}

		// 查询条件 默认 商品类型 实物
		if (!paramMap.containsKey("goodsType")) {
			paramMap.put("goodsType", "00");
		}

		String ordertypeId = (String) mapQuery.get("ordertypeId");
		// 广发 内管 供应商
		if (!Contants.BUSINESS_TYPE_JF.equals(ordertypeId)) {
			if (null != ordertypeId) {
				if (Contants.BUSINESS_TYPE_YG.equals(ordertypeId)) {
					List<String> orderTypeIdList = Lists.newArrayList();
					paramMap.put("goodsTypeFlag", Contants.SUB_ORDER_TYPE_01);
					orderTypeIdList.add(Contants.BUSINESS_TYPE_YG);
					paramMap.put("ordertypeIds", orderTypeIdList);

				} else {
					List<String> orderTypeIdList = Lists.newArrayList();
					paramMap.put("goodsTypeFlag", Contants.SUB_ORDER_TYPE_01);
					orderTypeIdList.add(Contants.BUSINESS_TYPE_FQ);
					paramMap.put("ordertypeIds", orderTypeIdList);
				}
			} else {
				List<String> orderTypeIdList = Lists.newArrayList();
				// 商城默认不处理“虚拟商品”订单
				paramMap.put("goodsTypeFlag", Contants.SUB_ORDER_TYPE_01);
				// 非积分订单
				orderTypeIdList.add(Contants.BUSINESS_TYPE_YG);
				orderTypeIdList.add(Contants.BUSINESS_TYPE_FQ);
				paramMap.put("ordertypeIds", orderTypeIdList);
			}
		}

        // 默认选择逻辑删除
        paramMap.put("delFlag", Contants.DEL_INTEGER_FLAG_0);
        String type = paramMap.get("tabtype").toString();
        // 订单状态（默认查询交易成功的订单）
        if ("3".equals(type)) {
            paramMap.put("curStatusId", Contants.SUB_ORDER_STATUS_0308);
        } else if ("4".equals(type)) {
            paramMap.put("curStatusId", Contants.SUB_ORDER_STATUS_0309);
        }
        // 获取供应商ID
        String vendorId = user.getVendorId();
        checkArgument(StringUtils.isNotBlank(vendorId), "vendorId.can.not.be.empty");
        paramMap.put("vendorId", vendorId);

        return paramMap;
    }

    /**
     * 移除 空值
     *
     * @param mapQuery
     * @return
     */
    private Map<String, Object> removeEmpty(Map mapQuery) {
        Map<String, Object> paramMap = Maps.newHashMap();
        // 剔除无值得条件
        for (Object key : mapQuery.entrySet()) {
            Map.Entry entry = (Map.Entry) key;
            String keyTemp = String.valueOf(entry.getKey());
            String valueTemp = String.valueOf(entry.getValue());
            if (null != valueTemp && !"".equals(valueTemp) && !"null".equals(valueTemp))
                paramMap.put(keyTemp, valueTemp);
        }
        return paramMap;
    }

	/**
	 * * 批量发货 (广发【暂定】)
	 *
	 * @param dtos 导入数据
	 * @param user 操作人
	 * @return Response<List<OrderInputDto>>
	 */
	@Override
	public Response<Object> importOrderInfo(List<OrderInputDto> dtos, User user) {
		Response<Object> response = new Response<Object>();
		uploadOrderInfo(response, dtos, user, YGimportConsign);
		return response;
	}

	@Override
	public Response<Object> importOrdersign(List<OrderInputDto> dtos, User user) {
		Response<Object> response = new Response<Object>();
		uploadOrderInfo(response, dtos, user, YGimportOrdersign);
		return response;
	}

	/**
	 * 操作对象 批量发货，批量签收（广发、积分）
	 *
	 * 更新order表，新增orderdetail表，ordertrans表
	 *
	 * @param response 最终返回对象
	 * @param dtos 导入对象
	 * @param user 操作人
	 * @param orderType 业务类型
	 */
	private void uploadOrderInfo(Response<Object> response, List<OrderInputDto> dtos, User user, String orderType) {

		List<OrderInputDto> orderInputDtos = null; // 处理后的导出结果信息

		// 操作的表对象
		List<OrderDoDetailModel> orderDoDetailModels = null;// 订单履历信息
		List<OrderTransModel> orderTransModels = null; // 物流信息
		List<OrderSubModel> orderSubModels = null; // 订单子表信息
		Map<String, Object> resultData = null;// 返回 导入订单的导入结果
		List<String> checkOrderId = null; // 排重 导入的订单号相同的订单 只允许操作一次

		Date date = new Date();// 获取当前时间
		Boolean isImportSuccess = Boolean.TRUE;
		String vendorId = "";
		String vendorNm = "";
		try {
			if (null == dtos || dtos.size() == 0) {
				response.setError("Import.Order.fails");
				return;
			}
			checkOrderId = Lists.newArrayListWithExpectedSize(dtos.size());
			orderDoDetailModels = Lists.newArrayListWithExpectedSize(dtos.size());
			orderTransModels = Lists.newArrayListWithExpectedSize(dtos.size());
			orderInputDtos = Lists.newArrayListWithExpectedSize(dtos.size());
			orderSubModels = Lists.newArrayListWithExpectedSize(dtos.size());
			for (OrderInputDto dto : dtos) {
				Map<String, Object> resultMap = checkExcelContents(dto, orderType, date, user, checkOrderId);
				orderInputDtos.add((OrderInputDto) resultMap.get("orderInputDto"));
				if (!(boolean) resultMap.get("isRight")) {
					isImportSuccess = Boolean.FALSE;
				} else {
					// 成功处理
					orderDoDetailModels.add((OrderDoDetailModel) resultMap.get("orderDoDetailModel"));
					orderTransModels.add((OrderTransModel) resultMap.get("orderTransModel"));
					orderSubModels.add((OrderSubModel) resultMap.get("orderSubModel"));
					if ("".equals(vendorId) || "".equals(vendorNm)) {
						vendorId = String.valueOf(resultMap.get("vendorId"));
						vendorNm = String.valueOf(resultMap.get("vendorNm"));
					}
				}
			}
			// Boolean flag = true;//
			if (!orderSubModels.isEmpty() && !orderDoDetailModels.isEmpty() && !orderTransModels.isEmpty()) {
				Boolean flag = orderSubManager.updateBatch(orderSubModels, orderDoDetailModels, orderTransModels,
						orderType);
				response.setSuccess(flag);
				if (!flag) {
					response.setError("Import.Order.BatchUpdate.fails");
					return;
				}
			}

			resultData = Maps.newHashMapWithExpectedSize(4);
			resultData.put("orderInputDtos", orderInputDtos);
			resultData.put("isImportSuccess", isImportSuccess);
			resultData.put("vendorNm", vendorNm);
			resultData.put("vendorId", vendorId);
			response.setResult(resultData);
		} catch (Exception e) {
			log.error("OrderIOServiceImpl.importOrderInfo.error,error code:{}", Throwables.getStackTraceAsString(e));
			response.setError("Import.Order.fails");
		}
	}

	/**
	 * 检查 excel 导入内容是否合法
	 *
	 * @param dto 导入的数据对象
	 * @param orderType 业务区分 YGimportConsign YGimportOrdersign JFimportConsign JFimportOrdersign
	 * @param date
	 * @param user
	 * @param checkExist
	 * @return Map<String, Object>
	 */
	private Map<String, Object> checkExcelContents(OrderInputDto dto, String orderType, Date date, User user,
			List<String> checkExist) {
		Boolean isRight = Boolean.TRUE;

		String errorMsg = "";
		String vendorId = "";
		String vendorNm = "";
		Map<String, Object> mapModels = Maps.newHashMap();
		OrderInputDto resultDto = new OrderInputDto();
		BeanMapper.copy(dto, resultDto);

		OrderSubModel orderSubModel = null; // 子订单信息
		OrderSubModel orderSubModelUpdate = null; // 子订单信息 即将更新回数据库中
		OrderDoDetailModel orderDoDetailModel = null; // 订单详细
		OrderMainModel orderMainModel = null; // 主订单
		OrderTransModel orderTransModel = null; // 物流

		if (StringUtils.isEmpty(dto.getOrderId())) {
			isRight = Boolean.FALSE;
			errorMsg = errorMsg + ", 订单号不能为空";
		} else if (checkExist.contains(dto.getOrderId())) {
			isRight = Boolean.FALSE;
			errorMsg = errorMsg + ", 订单号重复";
		} else {
			String orderId = dto.getOrderId().trim();
			int i = orderId.indexOf("\n");
			int j = orderId.indexOf("\r");
			if (i != -1) {
				orderId = orderId.substring(0, i);
			} else if (j != -1) {
				orderId = orderId.substring(0, j);
			}
			if (orderId.length() != 18) {
				isRight = Boolean.FALSE;
				errorMsg = errorMsg + ", 订单号只能为18位";
			} else {
				orderSubModel = orderSubDao.findById(orderId);
				if (null != orderSubModel && !"".equals(orderSubModel.getOrderId())) {
					orderMainModel = orderMainDao.findById(orderSubModel.getOrdermainId());
				}
			}

			if (null == orderSubModel || null == orderMainModel) {
				isRight = Boolean.FALSE;
				errorMsg = errorMsg + ", 该商户名下不存在此订单";
			} else {
				String goodsType = orderSubModel.getGoodsType();

				vendorNm = orderSubModel.getVendorSnm();
				vendorId = orderSubModel.getVendorId();

				if (!Contants.GOODS_TYPE_ID_00.equals(goodsType)) {
					isRight = Boolean.FALSE;
					errorMsg = errorMsg + ", O2O或虚拟商品的订单无法进行发货";
				}

				if (!user.getVendorId().equals(orderSubModel.getVendorId())) {
					isRight = Boolean.FALSE;
					errorMsg = errorMsg + ", 该商户名下不存在此订单";
				}

				orderSubModelUpdate = new OrderSubModel();
				BeanMapper.copy(orderSubModel, orderSubModelUpdate);

				// 广发,积分发货
				if (YGimportConsign.equals(orderType) || JFimportConsign.equals(orderType)) {

					if (StringUtils.isEmpty(dto.getTranscorpNm())) {
						isRight = Boolean.FALSE;
						errorMsg = errorMsg + ", 物流公司不能为空";
					}
					// else if (StringUtils.isEmpty(dto.getServicePhone())) {
					// isRight = Boolean.FALSE;
					// errorMsg = errorMsg + ", 客服电话不能为空";
					// } else if (StringUtils.isEmpty(dto.getMailingMan())) {
					// isRight = Boolean.FALSE;
					// errorMsg = errorMsg + ", 物流公司投递员不能为空";
					// } else if (StringUtils.isEmpty(dto.getMailingMobile())) {
					// isRight = Boolean.FALSE;
					// errorMsg = errorMsg + ", 投递员手机号码不能为空";
					// }

					// 验证货单号(是否为空，是否存在特殊字符，长度)
					if (StringUtils.isEmpty(dto.getMailingNum())) {
						isRight = Boolean.FALSE;
						errorMsg = errorMsg + ", 货单号不能为空";
					} else {
						if (dto.getMailingNum().length() > 50) {
							isRight = Boolean.FALSE;
							errorMsg = errorMsg + ", 货单号过长";
						}
					}
					// 判断订单状态0306,0308
					if (!(Contants.SUB_ORDER_STATUS_0306.equals(orderSubModel.getCurStatusId())
							|| Contants.SUB_ORDER_STATUS_0308.equals(orderSubModel.getCurStatusId()))) {
						isRight = Boolean.FALSE;
						errorMsg = errorMsg + ", 该订单状态不能用于发货";
					}

					// 判断发货日期
					int createDate = 0;// 下单时间
					int consignDate = 0;// 发货时间

					if (StringUtils.isEmpty(dto.getDoDate())) {
						dto.setDoDate(DateHelper.getyyyyMMdd());
					} else {
						if (dto.getDoDate().length() == 8) {
							if (!isValidDateTime(dto.getDoDate(), "yyyyMMdd", 8)) {
								isRight = Boolean.FALSE;
								errorMsg = errorMsg + ", 发货日期不是有效日期格式(提示：yyyyMMdd)";
							} else {
								createDate = Integer
										.parseInt(DateHelper.date2string(orderSubModel.getCreateTime(), "yyyyMMdd"));
								consignDate = Integer.parseInt(dto.getDoDate());
								if (createDate > consignDate) {
									isRight = Boolean.FALSE;
									errorMsg = errorMsg + ", 发货日期不能小于下单日期";
								}
							}
						} else {
							isRight = Boolean.FALSE;
							errorMsg = errorMsg + ", 发货日期必须是8位";
						}
					}
					// 判断发货时间
					int createTime;// 下单时间
					int consignTime;// 发货时间
					if (StringUtils.isEmpty(dto.getDoTime())) {
						resultDto.setDoTime(DateHelper.getHHmmss());
					} else {
						if (!isValidDateTime(dto.getDoTime(), "HHmmss", 6)) {
							isRight = Boolean.FALSE;
							errorMsg = errorMsg + ", 发货时间不是有效时间格式";
						} else {
							createTime = Integer
									.parseInt(DateHelper.date2string(orderSubModel.getCreateTime(), "HHmmss"));
							consignTime = Integer.parseInt(dto.getDoTime());
							if (createDate != 0 && createDate == consignDate && createTime > consignTime) {
								isRight = Boolean.FALSE;
								errorMsg = errorMsg + ", 下单,发货同一天时,发货时间不能小于下单时间";
							}
						}
					}

					if (Contants.GOODS_TYPE_ID_01.equals(orderSubModel.getGoodsType())) {
						isRight = Boolean.FALSE;
						errorMsg = errorMsg + ", 该订单为虚拟礼品订单，无法进行发货处理";
					}

					// 0 不是，1 是 活动秒杀产品
					String actType = orderSubModel.getActType();// 是否为秒杀商品
					int miaoFlag = orderSubModel.getMiaoshaActionFlag() == null ? 0
							: orderSubModel.getMiaoshaActionFlag();// 活动商品 0 非活动商品 1 活动商品

					// 若订单状态为"支付成功"，则修改为"发货中"更新订单状态为发货中，插入订单历史操作表, 注意：0元秒杀订单不做状态转换处理
					// log.info("批量发货：合作商的订单0元秒杀标志位：" + miaoFlag);
					if (!(Contants.PROMOTION_PROM_TYPE_STRING_30.equals(actType) && 1 == miaoFlag
							&& 0 == BigDecimal.ZERO.compareTo(orderSubModel.getTotalMoney()))) {
						resultDto.setCurStatusId(Contants.SUB_ORDER_STATUS_0309);
						resultDto.setCurStatusNm(Contants.SUB_ORDER_DELIVERED);

						orderSubModelUpdate.setCurStatusId(Contants.SUB_ORDER_STATUS_0309);
						orderSubModelUpdate.setCurStatusNm(Contants.SUB_ORDER_DELIVERED);
					} else {
						// log.info("0元订单当前状态：" + orderBean.getCur_status_id());
						resultDto.setCurStatusId(Contants.SUB_ORDER_STATUS_0308);
						resultDto.setCurStatusNm(Contants.SUB_ORDER_PAYMENT_SUCCEED);

						orderSubModelUpdate.setCurStatusId(Contants.SUB_ORDER_STATUS_0308);
						orderSubModelUpdate.setCurStatusNm(Contants.SUB_ORDER_PAYMENT_SUCCEED);
					}

				}
				// 广发,积分签收
				else if (YGimportOrdersign.equals(orderType) || JFimportOrdersign.equals(orderType)) {
					// 判断原订单状态0309
					if (!Contants.SUB_ORDER_STATUS_0309.equals(orderSubModel.getCurStatusId())) {
						isRight = Boolean.FALSE;
						errorMsg = errorMsg + ",该订单状态不能用于签收";
					}
					// 判断上传订单状态0310 已签收
					if (!Contants.SUB_ORDER_STATUS_0310.equals(dto.getCurStatusId())) {
						isRight = Boolean.FALSE;
						errorMsg = errorMsg + ",上传订单状态只能为已签收(0310)";
					}
					// 判断签收人是否为空，为空则使用默认收货人
					if (StringUtils.isEmpty(dto.getCsgName())) {
						resultDto.setCsgName(orderMainModel.getCsgName());
					}
					// 判断签收日期
					int createDate = 0;// 发货日期
					int ordersignDate = 0;// 签收日期
					if (StringUtils.isEmpty(dto.getSignDate())) {
						resultDto.setSignDate(DateHelper.getyyyyMMdd());
					} else {
						if (dto.getSignDate().length() == 8) {
							if (!isValidDateTime(dto.getSignDate(), "yyyyMMdd", 8)) {
								isRight = Boolean.FALSE;
								errorMsg = errorMsg + ", 签收日期不是有效日期格式";
							} else {
								createDate = Integer
										.parseInt(DateHelper.date2string(orderSubModel.getCreateTime(), "yyyyMMdd"));
								ordersignDate = Integer.parseInt(dto.getSignDate());
								if (createDate > ordersignDate) {
									isRight = Boolean.FALSE;
									errorMsg = errorMsg + ", 签收日期不能小于下单日期";
								}
							}
						} else {
							isRight = Boolean.FALSE;
							errorMsg = errorMsg + ", 签收日期必须是8位";
						}
					}
					if (isRight) {
						resultDto.setCurStatusId(Contants.SUB_ORDER_STATUS_0310);
						resultDto.setCurStatusNm(Contants.SUB_ORDER_SIGNED);
						resultDto.setDoDesc(resultDto.getCsgName() + "|" + resultDto.getSignDate());

						orderSubModelUpdate.setCurStatusId(Contants.SUB_ORDER_STATUS_0310);
						orderSubModelUpdate.setCurStatusNm(Contants.SUB_ORDER_SIGNED);
					}
				} else {
					isRight = Boolean.FALSE;
					errorMsg = errorMsg + ", 订单操作方法错误";
				}

				if (isRight) {
					// 准备数据
					// 导出信息数据
					resultDto.setVendorSnm(orderSubModel.getVendorSnm());
					resultDto.setVendorId(orderSubModel.getVendorId());

					// 子订单数据
					orderSubModelUpdate.setModifyOper(user.getId());
					orderSubModelUpdate.setModifyTime(date);
					orderSubModelUpdate.setVendorOperFlag("1");
					if (Contants.SUB_ORDER_STATUS_0310.equals(orderSubModelUpdate.getCurStatusId())) {
						orderSubModelUpdate.setGoodssendFlag("2");
						orderSubModelUpdate.setReceivedTime(date);
					} else {
						orderSubModelUpdate.setGoodssendFlag("1");
					}
					// 订单明细数据
					orderDoDetailModel = new OrderDoDetailModel();
					orderDoDetailModel.setStatusId(orderSubModelUpdate.getCurStatusId());
					orderDoDetailModel.setStatusNm(orderSubModelUpdate.getCurStatusNm());
					orderDoDetailModel.setOrderId(orderSubModelUpdate.getOrderId());
					orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
					orderDoDetailModel.setDoDesc(resultDto.getDoDesc());
					orderDoDetailModel.setCreateOper(user.getId());
					orderDoDetailModel.setDoUserid(user.getId());
					orderDoDetailModel.setCreateTime(date);
					orderDoDetailModel.setMsgContent("");
					orderDoDetailModel.setDoTime(date);
					orderDoDetailModel.setUserType("2");

					// 订单发货物流配送信息
					orderTransModel = new OrderTransModel();
					orderTransModel.setMailingMobile(resultDto.getMailingMobile());
					orderTransModel.setOrderId(orderSubModelUpdate.getOrderId());
					orderTransModel.setServicePhone(resultDto.getServicePhone());
					orderTransModel.setTranscorpNm(resultDto.getTranscorpNm());
					orderTransModel.setMailingNum(resultDto.getMailingNum());
					orderTransModel.setMailingMan(resultDto.getMailingMan());
					orderTransModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
					orderTransModel.setServiceUrl(resultDto.getServiceUrl());
					orderTransModel.setDoDesc(resultDto.getDoDesc());
					orderTransModel.setCreateOper(user.getId());
					orderTransModel.setCreateTime(date);
					orderTransModel.setDoTime(date);
				}
			}
		}

		if (isRight) {
			resultDto.setSuccessFlag(SUCCESS_FLAG_Y);
			checkExist.add(resultDto.getOrderId());
		} else {
			resultDto.setSuccessFlag(SUCCESS_FLAG_N);
			resultDto.setFailReason(errorMsg.trim().substring(1));
		}
		mapModels.put("orderSubModel", orderSubModelUpdate);
		mapModels.put("orderDoDetailModel", orderDoDetailModel);
		mapModels.put("orderTransModel", orderTransModel);
		mapModels.put("orderInputDto", resultDto);
		mapModels.put("vendorNm", vendorNm);
		mapModels.put("vendorId", vendorId);
		mapModels.put("isRight", isRight);
		return mapModels;
	}

	/**
	 * 如果时间跨度在当前表内，则只查询当前表，如果时间跨度涉及历史表，再查询当前表和历史表
	 *
	 * @return String
	 */
	private static String getTableNameByDate(String modifyBeginDate) {
		GregorianCalendar endDateTemp = new GregorianCalendar(TimeZone.getDefault(), Locale.CHINA);
		endDateTemp.setTime(new Date());
		endDateTemp.add(Calendar.DAY_OF_MONTH, -180);

		String historyDate = DateHelper.getyyyyMMdd(endDateTemp.getTime());// 200天以内的订单

		int i_beginDate = Integer.parseInt(modifyBeginDate);

		int i_historyDate = Integer.parseInt(historyDate);
		if (i_beginDate >= i_historyDate) {
			return "1";// 当前表
		}
		return "2";// 当前表和历史表
	}

	/**
	 * 日期格式校验
	 */
	private Boolean isValidDateTime(String dateTime, String format, int length) {
		boolean tag = false;
		if (null != dateTime && dateTime.length() == length) {

			SimpleDateFormat sdf = new SimpleDateFormat(format);
			sdf.setLenient(false);

			try {
				Date dd = sdf.parse(dateTime);
				if (null != dd)
					tag = true;
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		return tag;
	}

	/**
	 * 根据条件检出订单 -- 内官 订单管理
	 *
     * @param mapQuery 查询条件
     * @return  OrderSubModel
	 */
	public Response<List<OrderSubModel>> exportOrderView(Map mapQuery) {

        Response<List<OrderSubModel>> response = Response.newResponse();
        try {
//			Map<String, Object> paramMap = removeEmpty(mapQuery);

            paramSimple(mapQuery);
            // 获取子订单列表数据 六个月之内订单
            List<OrderSubModel> orderSubModelList = queryOrderTb(mapQuery);
            response.setResult(orderSubModelList);
        } catch (Exception e) {
            log.error("ExportOrderView.findOrder.error:{}", Throwables.getStackTraceAsString(e));
            response.setError("findOrder.error");
        }
        return response;
    }

    /**
     * 相同条件查询
     *
     * @param mapQuery
     */
    private void paramSimple(Map<String, Object> mapQuery) {
        //默认查询一个月得订单
        if (!mapQuery.containsKey("searchType")) {
            Date today = new Date();
            String startTime = DateHelper.date2string(DateHelper.addDay(today, -30), DateHelper.YYYY_MM_DD);
            String endTime = DateHelper.date2string(today, DateHelper.YYYY_MM_DD);
            mapQuery.put("startTime", startTime);
            mapQuery.put("endTime", endTime);
        }
        // 判断商品编码为空
        if (mapQuery.containsKey("goodsId")) {
            Response<List<String>> itemCodeListByMidOrXidResponse = itemService.findItemCodeListByMidOrXid(String.valueOf(mapQuery.get("goodsId")));
            if (!itemCodeListByMidOrXidResponse.isSuccess()) {
                log.error("OrderService find ,itemService findItemCodeListByMidOrXid be wrong");
                throw new ResponseException("ItemServiceImpl.findItemCodeListByMidOrXid.error");
            }
            List<String> itemCodeListByMidOrXidResponseResult = itemCodeListByMidOrXidResponse.getResult();
            if (itemCodeListByMidOrXidResponseResult != null && !itemCodeListByMidOrXidResponseResult.isEmpty()) {
                mapQuery.put("goodsIdList", itemCodeListByMidOrXidResponseResult);
            }
        }
    }

    /**
     * 物流信息查询
     *
     * @param orderIds 订单id集合
     * @return OrderTransModels
     */
    @Override
    public Response<List<OrderTransModel>> findOrderTrans(List<String> orderIds){
        Response<List<OrderTransModel>> response = Response.newResponse();
        try {
            List<OrderTransModel> models = orderTransDao.findByOrderIds(orderIds);
            response.setResult(models);
        } catch (Exception e) {
            log.error("OrderIOServiceImpl.findOrderTrans.error:{}", Throwables.getStackTraceAsString(e));
            response.setError("findOrderTrans.error");
        }
        return response;
    }

	private Map<String, OrderTransModel> getOrderTransMap(List<OrderTransModel> orderTransModels) {
		Map<String, OrderTransModel> orderMainMap = Maps.uniqueIndex(orderTransModels,
				new Function<OrderTransModel, String>() {
					@NotNull
					@Override
					public String apply(@NotNull OrderTransModel input) {
						return input.getOrderId();
					}
				});
		return orderMainMap;
	}

    /**
     * 主订单信息查询
     *
     * @param orderMainIds 主订单id集合
     * @return OrderTransModels
     */
    public Response<List<OrderMainModel>> findOrderMains(List<String> orderMainIds){
        Response<List<OrderMainModel>> response = Response.newResponse();
        try {
            Map<String, Object> param = ImmutableMap.<String, Object> of("orderMainIdList", orderMainIds);
            List<OrderMainModel> orderMainModels = orderMainDao.findOrdersByList(param);
            response.setResult(orderMainModels);
        } catch (Exception e) {
            log.error("OrderIOServiceImpl.findOrderMains.error:{}", Throwables.getStackTraceAsString(e));
            response.setError("findOrderMains.error");
        }
        return response;
    }

	/**
	 * 订单查询方法
	 *
	 * @param paramMap 查询条件
	 * @return OrderSubModels
	 */
	private List<OrderSubModel> queryOrderTb(Map<String, Object> paramMap) {

		List<OrderSubModel> orderSubModelList = null;

		// 格式化 时间
		// String starTime = paramMap.get("startTime").toString();
		// Date dateTemp = DateHelper.string2Date(starTime, DateHelper.YYYY_MM_DD);
		// String startTime = dateTemp == null ? "" : DateHelper.getyyyyMMdd(dateTemp);
		// 优化合作商发货 批量导出Sql start modify by dengbing
		// String tbl_flag = getTableNameByDate(startTime); // 1:当前表， 2：当前表+历史表
		// if ("1".equals(tbl_flag)) {
		// // 当前表
		// orderSubModelList = orderSubDao.findLike(paramMap);
		// } else {
		// // 6个月以上的数据 包含 现有的订单
		// List<TblOrderHistoryModel> tblOrderHistoryModelList = tblOrderHistoryDao.findLike(paramMap);
		// if (null != tblOrderHistoryModelList) {
		// for (TblOrderHistoryModel tblOrderHistoryModel : tblOrderHistoryModelList) {
		// OrderSubModel orderSubModel = new OrderSubModel();
		// BeanMapper.copy(tblOrderHistoryModel, orderSubModel);
		// if (null == orderSubModelList)
		// orderSubModelList = Lists.newArrayListWithExpectedSize(tblOrderHistoryModelList.size());
		// orderSubModelList.add(orderSubModel);
		// }
		// }
		// List<OrderSubModel> subModels = orderSubDao.findLike(paramMap);
		// if (null != subModels && subModels.size() > 0) {
		// if (null == orderSubModelList)
		// orderSubModelList = Lists.newArrayListWithExpectedSize(subModels.size());
		// orderSubModelList.addAll(subModels);
		// }
		// }
		String limitFlag = "";
		if (paramMap.containsKey("limitFlag"))
			limitFlag = paramMap.get("limitFlag").toString();

		if (StringUtils.isEmpty(limitFlag) || !"on".equals(limitFlag)) {
			orderSubModelList = orderSubDao.findLike(paramMap);
		} else {
			List<TblOrderHistoryModel> tblOrderHistoryModelList = tblOrderHistoryDao.findLike(paramMap);
			if (null != tblOrderHistoryModelList) {
				for (TblOrderHistoryModel tblOrderHistoryModel : tblOrderHistoryModelList) {
					OrderSubModel orderSubModel = new OrderSubModel();
					BeanMapper.copy(tblOrderHistoryModel, orderSubModel);
					if (null == orderSubModelList)
						orderSubModelList = Lists.newArrayListWithExpectedSize(tblOrderHistoryModelList.size());
					orderSubModelList.add(orderSubModel);
				}
			}
		}
		return orderSubModelList;
	}
	public Response<Boolean> creatOrderServiceExcel(OrderQueryConditionDto conditionDto, String orderTypeId){
		String startTime = conditionDto.getStartTime();
		String endTime = conditionDto.getEndTime();
		if (StringUtils.isNotEmpty(startTime)){
			conditionDto.setStartTime(DateHelper.date2string(DateTime.parse(startTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
		}
		if (StringUtils.isNotEmpty(endTime)){
			conditionDto.setEndTime(DateHelper.date2string(DateTime.parse(endTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).plusDays(1).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
		}
		Response<Boolean> response = Response.newResponse();
		try {
			creatUserExport(conditionDto.getFindUserId(),"01",orderTypeId);
			queueSender.send("shop.cgb.order.export.notify", conditionDto);
			response.setResult(true);
		}catch (Exception e){
			response.setError("shop.creatOrder.error");
		}
		return response;
	}
	public void creatUserExport(String userId, String dlUrl, String orderTypeId){
		redisService.createOrderExportUrl(userId,dlUrl,orderTypeId);
	}
	public String getUserExport(String userId ,String orderTypeId){
		Response<String> urlResponse = redisService.getOrderExportUrl(userId,orderTypeId);
		if(urlResponse.isSuccess()){
			String url = urlResponse.getResult();
			if (url == null){
				return "00";
			}else {
				return url;
			}
		}else {
			return "99";
		}
	}

	public Response<Boolean> deleteOrderExport(User user, String fileName){
		Response<Boolean> response = Response.newResponse();

		try {
			OrderQueryConditionDto conditionDto = new OrderQueryConditionDto();
			conditionDto.setFindUserId(user.getId());
			conditionDto.setOrderFileName(fileName);
			conditionDto.setDelFile("delete");
			queueSender.send("shop.cgb.order.export.notify", conditionDto);
			response.setResult(true);
		}catch (Exception e){
			response.setError("shop.creatOrder.error");
		}
		return response;
	}
}
