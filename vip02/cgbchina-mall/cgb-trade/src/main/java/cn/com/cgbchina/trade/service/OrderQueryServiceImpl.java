package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.OrderTieinSaleService;
import cn.com.cgbchina.item.service.PointsPoolService;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.ReflectUtil;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.dto.OrderCCInfoDto;
import cn.com.cgbchina.trade.dto.OrderQueryDto;
import cn.com.cgbchina.trade.manager.*;
import cn.com.cgbchina.trade.model.*;
import cn.com.cgbchina.user.service.MemberAddressService;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Function;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Ordering;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Nullable;
import javax.annotation.Resource;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by guixin1.ma on 16-8-3.
 */
@Service
@Slf4j
public class OrderQueryServiceImpl implements OrderQueryService {
	@Resource
	OrderSubDao orderSubDao;
	@Resource
	OrderMainDao orderMainDao;
	@Resource
	OrderTransDao orderTransDao;
	@Resource
	OrderDoDetailDao orderDoDetailDao;
	@Resource
	OrderPartBackDao orderPartBackDao;
	@Resource
	OrderReturnTrackDao orderReturnTrackDao;
	@Resource
	GoodsService goodsService;
	@Resource
	ItemService itemService;
	@Resource
	VendorService vendorService;
	@Resource
	CartService cartService;
	@Resource
	MemberAddressService memberAddressService;
	@Resource
	PointRelatedService pointRelatedService;
	@Resource
	GoodsPayWayService goodsPayWayService;
	@Resource
	PointsPoolService pointsPoolService;
	@Resource
	OrderSubManager orderSubManager;
	@Resource
	OrderTransManager orderTransManager;
	@Resource
	OrderDodetailManger orderDodetailManager;
	@Resource
	OrderMainManager orderMainManager;
	@Resource
	OrderReturnTrackManager orderReturnTrackManager;
	@Resource
	OrderQueryManager orderQueryManager;
	@Value("#{app.merchId}")
	private String merchId;
	@Value("#{app.returl}")
	private String returl;
	@Value("#{app.mainPrivateKey}")
	private String mainPrivateKey;
	@Value("#{app.payAddress}")
	private String payAddress;
	@Value("#{app.timeStart}")
	private String timeStart;
	@Value("#{app.timeEnd}")
	private String timeEnd;
	@Resource
	PaymentService paymentService;
	@Resource
	TblOrderHistoryDao tblOrderHistoryDao;
	@Resource
	OrderBackupDao orderBackupDao;
	@Resource
	TblOrdermainHistoryDao tblOrdermainHistoryDao;
	@Resource
	TblOrderMainBackupDao tblOrderMainBackupDao;
	@Resource
	OrderReturnTrackDetailDao orderReturnTrackDetailDao;
	@Resource
	OrderTieinSaleService orderTieinSaleService;
	@Resource
	TblOrderMainHisDao tblOrderMainHisDao;
	@Resource
	TblOrderExtend1Dao tblOrderExtend1Dao;
    @Resource
    MallPromotionService mallPromotionService;
    @Resource
    OrderCheckDao orderCheckDao;
    @Resource
    TblBatchStatusDao tblBatchStatusDao;
    @Resource
    AuctionRecordDao auctionRecordDao;
    @Resource
    private TblOrderDao2 tblOrderDao2;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	/**
	 * @param pageNo
	 * @param size
	 * @param custId 用户ID
	 * @param curStatusId
	 * @param isPayOn
	 * @param orderType
	 * @param statusIds
	 * @return
	 */
	@Override
	public Response<Pager<OrderQueryDto>> findByApp(@Param("pageNo") Integer pageNo,
											  @Param("size") Integer size,
											  @Param("custId") List<String> custId,
											  @Param("curStatusId") String curStatusId,
											  @Param("isPayOn") String isPayOn,
											  @Param("orderType") String orderType,
											  @Param("statusIds") String statusIds) {
		// 构造返回值及参数
		Response<Pager<OrderQueryDto>> response = new Response<Pager<OrderQueryDto>>();
		// 查询子订单参数
		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("create_Oper",custId);
		// 生成子订单查询SQL文配置参数
		String sqlContentParam = "";
		String sqlOrderType = "";
		if("01".equals(orderType)){		//01-YG
			sqlOrderType = "sqlOrderType_01";
		}else if("02".equals(orderType)){	// 02-FQ
			sqlOrderType = "sqlOrderType_02";
		}else if("03".equals(orderType)){	//03-JF
			sqlOrderType = "sqlOrderType_03";
		}else if("04".equals(orderType)){	//04-YG and FQ
			sqlOrderType = "sqlOrderType_04";
		}
		// "待支付"查询 (订单状态为待付款且大订单下只有一个小订单)
		if("1".equals(isPayOn)){
			sqlContentParam = "orderQueryByAPP_1";
			if("04".equals(orderType)){
				sqlContentParam = "orderQueryByAPP_2";
			}
		// 全部查询
		}else{
			if("9999".equals(curStatusId)){		//剔除待付款（0301）和已废单（0304）
				sqlContentParam = "orderQueryByAPP_3";
			}else if("0000".equals(curStatusId)){	//根据cur_status_ids查询
				sqlContentParam = "orderQueryByAPP_4";
				String[] statusArr = statusIds.split("\\|");
//				String statusStr = "";
				List<String> statusStr=Lists.newArrayList();
				boolean payOnFlag= false;
				for(int i=0;i<statusArr.length;i++){
					if("0301".equals(statusArr[i])){
						payOnFlag = true;
					}else{
						statusStr.add(statusArr[i]);
//						statusStr += "'"+statusArr[i]+"'," ;
					}
				}
//				if(!"".equals(statusStr)){
				if(!statusStr.isEmpty()){
					sqlContentParam = "orderQueryByAPP_5";
//					statusStr = statusStr.substring(0,statusStr.length()-1);
					paramMap.put("ordermainId",statusStr);
					if(payOnFlag){//如果cur_status_ids中包含0301（待付款），则只查询可继续支付的待付款（条件是订单状态为待付款且大订单下只有一个小订单）
						sqlContentParam = "orderQueryByAPP_6";
						if("04".equals(orderType)){
							sqlContentParam = "orderQueryByAPP_7";
						}
					}
				}else if(payOnFlag){//如果cur_status_ids中包含0301（待付款），则只查询可继续支付的待付款（条件是订单状态为待付款且大订单下只有一个小订单）
					sqlContentParam = "orderQueryByAPP_8";
					if("04".equals(orderType)){
						sqlContentParam = "orderQueryByAPP_9";
					}
				}else{
					sqlContentParam = "orderQueryByAPP_10";
				}
			}else{//查询指定状态的订单
				paramMap.put("cur_Status_Id",curStatusId);
				if("0301".equals(curStatusId)){
					sqlContentParam = "orderQueryByAPP_11";
					if("04".equals(orderType)){
						sqlContentParam = "orderQueryByAPP_12";
					}
				}else{
					sqlContentParam = "orderQueryByAPP_13";
				}
			}
		}
		paramMap.put("sqlContentParam",sqlContentParam);
		paramMap.put("sqlOrderType",sqlOrderType);
		// 封装分页参数
		Pager<OrderSubModel> pager = new Pager<>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		List<OrderQueryDto> orderQueryDtos = new ArrayList<OrderQueryDto>();
		try {
			// 获取子订单信息
			pager = orderSubDao.getOrdersByAutoSql(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
			// 获取单品 支付方式 货单 s商品
			List<OrderSubModel> orderSubModelList = pager.getData();
			List<ItemModel> itemModelList = Lists.newArrayList();
			List<OrderMainModel> OrderMainModelList = Lists.newArrayList();
			List<OrderTransModel> OrderTransModellList = Lists.newArrayList();
//			List<TblGoodsPaywayModel> TblGoodsPaywayModellList = Lists.newArrayList();
			List<GoodsModel> goodsModellList = Lists.newArrayList();
			if (orderSubModelList != null && !orderSubModelList.isEmpty()) {
				//主订单
				List<String> mainIdList = Lists.newArrayList();
				for (OrderSubModel orderSubModel : orderSubModelList) {
					mainIdList.add(orderSubModel.getOrdermainId());
				}
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("orderMainIdList", mainIdList);
				OrderMainModelList = orderMainDao.findOrdersByList(params);
				if (OrderMainModelList == null || OrderMainModelList.isEmpty()) {
					response.setError("OrderMainModelList.be.null");
					return response;
				}
				// 单品
				List<String> itemCodeList = Lists.newArrayList();
				for (OrderSubModel orderSubModel : orderSubModelList) {
					itemCodeList.add(orderSubModel.getGoodsId());
				}
				Response<List<ItemModel>> itemModelReponse = new Response<>();
				itemModelReponse = itemService.findByCodesAll(itemCodeList);
				if (!itemModelReponse.isSuccess() || itemModelReponse.getResult() == null
						|| itemModelReponse.getResult().isEmpty()) {
					response.setError("itemModelList.be.null");
					return response;
				}
				itemModelList = itemModelReponse.getResult();
				Response<List<TblGoodsPaywayModel>> TblGoodsPaywayModelReponse = new Response<>();
				TblGoodsPaywayModelReponse = goodsPayWayService.findGoodsPayWayByCodes(itemCodeList);
				if (!TblGoodsPaywayModelReponse.isSuccess() || TblGoodsPaywayModelReponse.getResult() == null
						|| TblGoodsPaywayModelReponse.getResult().isEmpty()) {
					response.setError("TblGoodsPaywayModellList.be.null");
					return response;
				}
//				TblGoodsPaywayModellList = TblGoodsPaywayModelReponse.getResult();
//				// 货单
				List<String> orderIdList = Lists.newArrayList();
				for (OrderSubModel orderSubModel : orderSubModelList) {
					orderIdList.add(orderSubModel.getOrderId());
				}
				OrderTransModellList = orderTransDao.findByOrderIds(orderIdList);
				if (OrderTransModellList == null) {
					OrderTransModellList = Lists.newArrayList();
				}
				// 获取商品
				List<String> goodsCodes = Lists.newArrayList();

				if (itemModelList != null && !itemModelList.isEmpty()) {
					for (ItemModel itemModel : itemModelList) {
						goodsCodes.add(itemModel.getGoodsCode());
					}
					Response<List<GoodsModel>> goodsModelReponse = new Response<>();
					goodsModelReponse = goodsService.findByCodes(goodsCodes);
					if (!goodsModelReponse.isSuccess() || goodsModelReponse.getResult() == null
							|| goodsModelReponse.getResult().isEmpty()) {
						response.setError("goodsModellList.be.null");
						return response;
					}
					goodsModellList = goodsModelReponse.getResult();
				}
			}
			// 循环处理List 封装dto
			SimpleDateFormat sdf_y = new SimpleDateFormat("yyyy");
			SimpleDateFormat sdf_md = new SimpleDateFormat("MM-dd");
			for (int o=0 ;o < orderSubModelList.size() ; o++){
				OrderQueryDto orderQueryDto = new OrderQueryDto();
				OrderSubModel orderModel = orderSubModelList.get(o);// orderSubModelList
				String main_Id =  orderModel.getOrdermainId();
				String goods_Id = orderModel.getGoodsId(); // itemModelList
//				String payWay_Id = orderModel.getGoodsPaywayId();//TblGoodsPaywayModellList
				String order_Id = orderModel.getOrderId();//OrderTransModellList
				// 加工子订单
//				orderModel.getOrdertypeId();														//订单类型___return
				orderQueryDto.setOrdertypeId(orderModel.getOrdertypeId());
//				orderModel.getOrderId();															//订单编号___return
				orderQueryDto.setOrderId(orderModel.getOrderId());
//				orderModel.getStagesNum();															//分期数___return
				orderQueryDto.setStagesNum(orderModel.getStagesNum());
//				orderModel.getSinglePrice();														//总金额金额___return
				orderQueryDto.setSinglePrice(orderModel.getSinglePrice());
//				orderModel.getIntegraltypeId();														//积分类型___return
				orderQueryDto.setIntegraltypeId(orderModel.getIntegraltypeId());
				orderQueryDto.setCreateTime(orderModel.getCreateTime());
				orderQueryDto.setModifyTime(orderModel.getModifyTime());
				if(orderModel.getModifyTime() != null){
					orderQueryDto.setModify_Date(sdf_y.format(orderModel.getModifyTime()));
					orderQueryDto.setModify_Time(sdf_md.format(orderModel.getModifyTime()));
				}
//				orderModel.getCurStatusId();														//订单状态___return
				orderQueryDto.setCurStatusId(orderModel.getCurStatusId());
//				orderModel.getGoodssendFlag();														//发货状态___return
				orderQueryDto.setGoodssendFlag(orderModel.getGoodssendFlag());
//				orderModel.getGoodsNm();															//商品名称___return
				orderQueryDto.setGoodsNm(orderModel.getGoodsNm());
//				orderModel.getGoodsNum();															//购买数量___return
				orderQueryDto.setGoodsNum(orderModel.getGoodsNum());
//				orderModel.getSourceId();															//订单渠道___return
				orderQueryDto.setSourceId(orderModel.getSourceId());
//				orderModel.getMerId();																//小商户号___return
				orderQueryDto.setMerId(orderModel.getMerId());
//				orderModel.getOrdermainId();														//大订单号___return
				orderQueryDto.setOrdermainId(orderModel.getOrdermainId());
//				orderModel.getCardno();																//卡号___return
				orderQueryDto.setCardno(orderModel.getCardno());
//				orderModel.getCardtype();															//卡片类型___return
				orderQueryDto.setCardtype(orderModel.getCardtype());
//				orderModel.getBonusPrice();															//积分抵扣金额___return
				orderQueryDto.setBonusPrice(orderModel.getBonusPrice());
//				orderModel.getTotalMoney();															//现金___return
				orderQueryDto.setTotalMoney(orderModel.getTotalMoney());
//				orderModel.getBonusTotalvalue();													//总积分值___return
				orderQueryDto.setBonusTotalvalue(orderModel.getBonusTotalvalue());
//				orderModel.getSingleBonus();														//单个总积___return
				orderQueryDto.setSingleBonus(orderModel.getSingleBonus());
//				//"颜色"																			//属性1___return
				orderQueryDto.setGoodsAttr1(orderModel.getGoodsAttr1());
//				orderModel.getGoodsColor();															//属性值1___return
				orderQueryDto.setGoodsColor(orderModel.getGoodsColor());
//				//"型号"																			//属性2___return
				orderQueryDto.setGoodsAttr2(orderModel.getGoodsAttr2());
//				orderModel.getGoodsModel();															//属性值2___return
				orderQueryDto.setGoodsModel(orderModel.getGoodsModel());
//				orderModel.getVoucherNo();															//优惠券编号___return
				orderQueryDto.setVoucherNo(orderModel.getVoucherNo());
//				orderModel.getVoucherNo();															//签收时间___return
				orderQueryDto.setReceivedTime(orderModel.getReceivedTime());
//				orderModel.getOrderIdHost();														//积分流水___return
				orderQueryDto.setOrderIdHost(orderModel.getOrderIdHost());
				// 加工主订单数据
				for(int t=0 ; t<OrderMainModelList.size() ; t++){
					OrderMainModel orderMainModel = OrderMainModelList.get(t);
					if(main_Id.equals(orderMainModel.getOrdermainId())){
						orderQueryDto.setOrdermainId(orderMainModel.getOrdermainId());
//						orderMainModel.getMerId();   												//大商户号___return
						orderQueryDto.setMerId(orderMainModel.getMerId());
						break;
					}
				}
				// 加工 item数据 good数据
				for(int i=0 ; i<itemModelList.size() ; i++){
					ItemModel itemModels = itemModelList.get(i);
					if(goods_Id.equals(itemModels.getCode())){
//						itemModels.getImage1();														//图片URL___return
						orderQueryDto.setGoods_Picture1(itemModels.getImage1());
// 						itemModels.getMarketPrice();												//市场价___return
						orderQueryDto.setMarketPrice(itemModels.getMarketPrice());
						orderQueryDto.setGoods_Id(itemModels.getCode());
						for(int g=0 ; g<goodsModellList.size() ; g++){
							if(itemModels.getGoodsCode().equals(goodsModellList.get(g).getCode())) {
								GoodsModel goodsModel = goodsModellList.get(g);
								orderQueryDto.setIntegral_Type(goodsModel.getPointsType());
								break;
							}
						}
						break;
					}
				}
				// 加工 货单
				for(int t=0 ; t<OrderTransModellList.size() ; t++){
					OrderTransModel orderTransModel = OrderTransModellList.get(t);
					if(order_Id.equals(orderTransModel.getOrderId())){
//						orderTransModel.getMailingNum();											//物流配送号___return
						orderQueryDto.setMailing_num(orderTransModel.getMailingNum());
						break;
					}
				}
				//加工支付方式
//				for(int p=0 ; p<TblGoodsPaywayModellList.size() ; p++){
//					TblGoodsPaywayModel tblGoodsPaywayModel = TblGoodsPaywayModellList.get(p);
//					if(payWay_Id.equals(tblGoodsPaywayModel.getGoodsPaywayId())){
////						tblGoodsPaywayModel.getPerStage();											//分期金额___return
//						orderQueryDto.setPer_Stage(tblGoodsPaywayModel.getPerStage());
//						orderQueryDto.setGoods_Price(tblGoodsPaywayModel.getGoodsPrice());
//						orderQueryDto.setIs_Action(tblGoodsPaywayModel.getIsAction());
//						break;
//					}
//				}
				// 售价
				BigDecimal totalMoney = orderModel.getTotalMoney();
				BigDecimal uitdrtamt = orderModel.getUitdrtamt();
				BigDecimal voucherPrice = orderModel.getVoucherPrice();
				BigDecimal price = BigDecimal.ZERO.setScale(2);
				if (totalMoney != null) {
					price = price.add(totalMoney);
				}
				if (uitdrtamt != null) {
					price = price.add(uitdrtamt);
				}
				if (voucherPrice != null) {
					price = price.add(voucherPrice);
				}
				Integer stagesNum = orderModel.getStagesNum();
				if (stagesNum == null || stagesNum == 0) {
					stagesNum = 1;
				}
				// 总价%分期数
				price = price.divide(new BigDecimal(stagesNum.intValue()), 2, BigDecimal.ROUND_DOWN);
				orderQueryDto.setPer_Stage(price);
				orderQueryDto.setGoods_Price(totalMoney);
				orderQueryDtos.add(orderQueryDto);
			}
			response.setResult(new Pager<OrderQueryDto>(pager.getTotal(), orderQueryDtos));
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl.find.qury.error", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.find.qury.error");
			return response;
		}
	}
	/**
	 * @param pageNo
	 * @param size
	 * @param custId 用户ID
	 * @param curStatusId
	 * @param isPayOn
	 * @return
	 */
	@Override
	public Response<Pager<OrderQueryDto>> findByWx(@Param("pageNo") Integer pageNo,
											   @Param("size") Integer size,
											   @Param("custId") List<String> custId,
											   @Param("curStatusId") String curStatusId,
		// 构造返回值及参数
											   @Param("isPayOn") String isPayOn) {
		Response<Pager<OrderQueryDto>> response = new Response<Pager<OrderQueryDto>>();
		String sqlContentParam = "";
		if(Contants.PAY_ON_NO.equals(isPayOn)){
			if (curStatusId.equals("9999")) {
				sqlContentParam = "orderQueryByWx_1";
			} else {
				sqlContentParam = "orderQueryByWx_2";
			}
		}else{
			sqlContentParam = "orderQueryByWx_3";
		}
		// 封装分页参数
		Pager<OrderSubModel> pager = new Pager<>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		List<OrderQueryDto> orderQueryDtos = new ArrayList<OrderQueryDto>();
		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("create_Oper", custId);
		paramMap.put("cur_Status_Id",curStatusId);
		paramMap.put("sqlContentParam",sqlContentParam);
		try {
			pager = orderSubDao.getOrdersByAutoSql(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
			// 获取单品 支付方式 货单 s商品
			List<OrderSubModel> orderSubModelList = pager.getData();
			List<ItemModel> itemModelList = Lists.newArrayList();
			List<OrderMainModel> orderMainModelList = Lists.newArrayList();
//			List<TblGoodsPaywayModel> tblGoodsPaywayModellList = Lists.newArrayList();
			List<GoodsModel> goodsModellList = Lists.newArrayList();
			if (orderSubModelList != null && !orderSubModelList.isEmpty()) {
				//主订单
				List<String> mainIdList = Lists.newArrayList();
				for (OrderSubModel orderSubModel : orderSubModelList) {
					mainIdList.add(orderSubModel.getOrdermainId());
				}
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("orderMainIdList", mainIdList);
				orderMainModelList = orderMainDao.findOrdersByList(params);
				if (orderMainModelList == null || orderMainModelList.isEmpty()) {
					response.setError("OrderMainModelList.be.null");
					return response;
				}
				// 单品
				List<String> itemCodeList = Lists.newArrayList();
				for (OrderSubModel orderSubModel : orderSubModelList) {
					itemCodeList.add(orderSubModel.getGoodsId());
				}
				Response<List<ItemModel>> itemModelReponse = new Response<>();
				itemModelReponse = itemService.findByCodesAll(itemCodeList);
				if (!itemModelReponse.isSuccess() || itemModelReponse.getResult() == null
						|| itemModelReponse.getResult().isEmpty()) {
					response.setError("itemModelList.be.null");
					return response;
				}
				itemModelList = itemModelReponse.getResult();
				// 支付方式
//				Response<List<TblGoodsPaywayModel>> tblGoodsPaywayModelReponse = new Response<>();
//				tblGoodsPaywayModelReponse = goodsPayWayService.findGoodsPayWayByCodes(itemCodeList);
//				if (!tblGoodsPaywayModelReponse.isSuccess() || tblGoodsPaywayModelReponse.getResult() == null
//						|| tblGoodsPaywayModelReponse.getResult().isEmpty()) {
//					response.setError("TblGoodsPaywayModellList.be.null");
//					return response;
//				}
//				tblGoodsPaywayModellList = tblGoodsPaywayModelReponse.getResult();
				// 获取商品
				List<String> goodsCodes = Lists.newArrayList();

				if (itemModelList != null && !itemModelList.isEmpty()) {
					for (ItemModel itemModel : itemModelList) {
						goodsCodes.add(itemModel.getGoodsCode());
					}
					Response<List<GoodsModel>> goodsModelReponse = new Response<>();
					goodsModelReponse = goodsService.findByCodes(goodsCodes);
					if (!goodsModelReponse.isSuccess() || goodsModelReponse.getResult() == null
							|| goodsModelReponse.getResult().isEmpty()) {
						response.setError("goodsModellList.be.null");
						return response;
					}
					goodsModellList = goodsModelReponse.getResult();
				}
			}
			// 循环处理List 封装dto
			SimpleDateFormat sdf_y = new SimpleDateFormat("yyyy");
			SimpleDateFormat sdf_md = new SimpleDateFormat("MM-dd");
			for (int o = 0; o < orderSubModelList.size(); o++) {
				OrderQueryDto orderQueryDto = new OrderQueryDto();
				OrderSubModel orderModel = orderSubModelList.get(o);// orderSubModelList
				String main_Id = orderModel.getOrdermainId();
				String goods_Id = orderModel.getGoodsId(); // itemModelList
//				String payWay_Id = orderModel.getGoodsPaywayId();//TblGoodsPaywayModellList
//				String order_Id = orderModel.getOrderId();//OrderTransModellList
				// 加工子订单
				//				orderModel.getOrdertypeId();														//订单类型___return
				orderQueryDto.setOrdertypeId(orderModel.getOrdertypeId());
				//				orderModel.getOrderId();															//订单编号___return
				orderQueryDto.setOrderId(orderModel.getOrderId());
				//				orderModel.getStagesNum();															//分期数___return
				orderQueryDto.setStagesNum(orderModel.getStagesNum());
				//				orderModel.getSinglePrice();														//总金额金额___return
				orderQueryDto.setSinglePrice(orderModel.getSinglePrice());
				//				orderModel.getIntegraltypeId();														//积分类型___return
				orderQueryDto.setIntegraltypeId(orderModel.getIntegraltypeId());
				orderQueryDto.setCreateTime(orderModel.getCreateTime());														//下单时间___return
				orderQueryDto.setModifyTime(orderModel.getModifyTime());
				if(orderModel.getModifyTime() != null) {
					orderQueryDto.setModify_Date(sdf_y.format(orderModel.getModifyTime()));
					orderQueryDto.setModify_Time(sdf_md.format(orderModel.getModifyTime()));
				}
				//				orderModel.getCurStatusId();														//订单状态___return
				orderQueryDto.setCurStatusId(orderModel.getCurStatusId());
				//				orderModel.getGoodssendFlag();														//发货状态___return
				orderQueryDto.setGoodssendFlag(orderModel.getGoodssendFlag());
				//				orderModel.getGoodsNm();															//商品名称___return
				orderQueryDto.setGoodsNm(orderModel.getGoodsNm());
				//				orderModel.getGoodsNum();															//购买数量___return
				orderQueryDto.setGoodsNum(orderModel.getGoodsNum());
				//				orderModel.getSourceId();															//订单渠道___return
				orderQueryDto.setSourceId(orderModel.getSourceId());
				//				orderModel.getMerId();																//小商户号___return
				orderQueryDto.setMerId(orderModel.getMerId());
				//				orderModel.getOrdermainId();														//大订单号___return
				orderQueryDto.setOrdermainId(orderModel.getOrdermainId());
				//				orderModel.getCardno();																//卡号___return
				orderQueryDto.setCardno(orderModel.getCardno());
				//				orderModel.getCardtype();															//卡片类型___return
				orderQueryDto.setCardtype(orderModel.getCardtype());
				//				orderModel.getBonusPrice();															//积分抵扣金额___return
				orderQueryDto.setBonusPrice(orderModel.getBonusPrice());
				//				orderModel.getTotalMoney();															//现金___return
				orderQueryDto.setTotalMoney(orderModel.getTotalMoney());
				//				orderModel.getBonusTotalvalue();													//总积分值___return
				orderQueryDto.setBonusTotalvalue(orderModel.getBonusTotalvalue());
				//				orderModel.getSingleBonus();														//单个总积___return
				orderQueryDto.setSingleBonus(orderModel.getSingleBonus());
				//				//"颜色"																			//属性1___return
				orderQueryDto.setGoodsAttr1(orderModel.getGoodsAttr1());
				//				orderModel.getGoodsColor();															//属性值1___return
				orderQueryDto.setGoodsColor(orderModel.getGoodsColor());
				//				//"型号"																			//属性2___return
				orderQueryDto.setGoodsAttr2(orderModel.getGoodsAttr2());
				//				orderModel.getGoodsModel();															//属性值2___return
				orderQueryDto.setGoodsModel(orderModel.getGoodsModel());
				//				orderModel.getVoucherNo();															//优惠券编号___return
				orderQueryDto.setVoucherNo(orderModel.getVoucherNo());
				//				orderModel.getVoucherNo();															//签收时间___return
				orderQueryDto.setReceivedTime(orderModel.getReceivedTime());
				//				orderModel.getOrderIdHost();														//积分流水___return
				orderQueryDto.setOrderIdHost(orderModel.getOrderIdHost());
				// 加工主订单数据
				for (int t = 0; t < orderMainModelList.size(); t++) {
					OrderMainModel orderMainModel = orderMainModelList.get(t);
					if (main_Id.equals(orderMainModel.getOrdermainId())) {
						orderQueryDto.setOrdermainId(orderMainModel.getOrdermainId());
						//						orderMainModel.getMerId();   												//大商户号___return
						orderQueryDto.setMerId(orderMainModel.getMerId());
						break;
					}
				}
				// 加工 item数据 good数据
				for (int i = 0; i < itemModelList.size(); i++) {
					ItemModel itemModels = itemModelList.get(i);
					if (itemModels.getCode().equals(goods_Id)) {
						//						itemModels.getImage1();														//图片URL___return
						orderQueryDto.setGoods_Picture1(itemModels.getImage1());
						// 						itemModels.getMarketPrice();												//市场价___return
						orderQueryDto.setMarketPrice(itemModels.getMarketPrice());
						orderQueryDto.setGoods_Id(itemModels.getCode());
						for (int g = 0; g < goodsModellList.size(); g++) {
							if (itemModels.getGoodsCode().equals(goodsModellList.get(g).getCode())) {
								GoodsModel goodsModel = goodsModellList.get(g);
								orderQueryDto.setIntegral_Type(goodsModel.getPointsType());
								break;
							}
						}
						break;
					}
				}
				//加工支付方式
//				for (int p = 0; p < tblGoodsPaywayModellList.size(); p++) {
//					TblGoodsPaywayModel tblGoodsPaywayModel = tblGoodsPaywayModellList.get(p);
//					if (payWay_Id.equals(tblGoodsPaywayModel.getGoodsPaywayId())) {
						//						tblGoodsPaywayModel.getPerStage();											//分期金额___return
//						orderQueryDto.setPer_Stage(tblGoodsPaywayModel.getPerStage());
//						orderQueryDto.setGoods_Price(tblGoodsPaywayModel.getGoodsPrice());
//						orderQueryDto.setIs_Action(tblGoodsPaywayModel.getIsAction());
//						break;
//					}
//				}
				// 售价
				BigDecimal totalMoney = orderModel.getTotalMoney();
				BigDecimal uitdrtamt = orderModel.getUitdrtamt();
				BigDecimal voucherPrice = orderModel.getVoucherPrice();
				BigDecimal price = BigDecimal.ZERO.setScale(2);
				if (totalMoney != null) {
					price = price.add(totalMoney);
				}
				if (uitdrtamt != null) {
					price = price.add(uitdrtamt);
				}
				if (voucherPrice != null) {
					price = price.add(voucherPrice);
				}
				Integer stagesNum = orderModel.getStagesNum();
				if (stagesNum == null || stagesNum == 0) {
					stagesNum = 1;
				}
				// 总价%分期数
				price = price.divide(new BigDecimal(stagesNum.intValue()), 2, BigDecimal.ROUND_DOWN);
				orderQueryDto.setPer_Stage(price);
				orderQueryDto.setGoods_Price(totalMoney);
				orderQueryDtos.add(orderQueryDto);
			}
			response.setResult(new Pager<OrderQueryDto>(pager.getTotal(), orderQueryDtos));
		} catch (Exception e) {
			log.error("OrderServiceImpl.find.qury.error", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.find.qury.error");
			return response;
		}
		return response;
	}

	/**
	 * @param pageNo
	 * @param size
	 * @param custId 用户ID
	 * @param curStatusId
	 * @return
	 */
	@Override
	public Response<Pager<OrderQueryDto>> find(@Param("pageNo") Integer pageNo,
												   @Param("size") Integer size,
												   @Param("custId") List<String> custId,
												   @Param("curStatusId") String curStatusId) {
		// 构造返回值及参数
		Response<Pager<OrderQueryDto>> response = new Response<Pager<OrderQueryDto>>();
		String sqlContentParam = "";
		if ("9999".equals(curStatusId)) {
			sqlContentParam = "orderQueryByWx_1";
		} else {
			sqlContentParam = "orderQueryByWx_2";
		}
		// 封装分页参数
		Pager<OrderSubModel> pager = new Pager<>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		List<OrderQueryDto> orderQueryDtos = new ArrayList<OrderQueryDto>();
		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("create_Oper", custId);
		paramMap.put("cur_Status_Id",curStatusId);
		paramMap.put("sqlContentParam",sqlContentParam);
		try {
			pager = orderSubDao.getOrdersByAutoSql(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
			// 获取单品 支付方式 货单 s商品
			List<OrderSubModel> orderSubModelList = pager.getData();
			List<ItemModel> itemModelList = Lists.newArrayList();
			List<OrderMainModel> OrderMainModelList = Lists.newArrayList();
//			List<TblGoodsPaywayModel> TblGoodsPaywayModellList = Lists.newArrayList();
			List<GoodsModel> goodsModellList = Lists.newArrayList();
			if (orderSubModelList != null && !orderSubModelList.isEmpty()) {
				log.info("orderSubModelList=======:   " + orderSubModelList.size());
				//主订单
				List<String> mainIdList = Lists.newArrayList();
				for (OrderSubModel orderSubModel : orderSubModelList) {
					mainIdList.add(orderSubModel.getOrdermainId());
				}
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("orderMainIdList", mainIdList);
				OrderMainModelList = orderMainDao.findOrdersByList(params);
				if (OrderMainModelList == null || OrderMainModelList.isEmpty()) {
					response.setError("OrderMainModelList.be.null");
					return response;
				}else{
					log.info("OrderMainModelList=======:   " + OrderMainModelList.size());
				}
				// 单品
				List<String> itemCodeList = Lists.newArrayList();
				for (OrderSubModel orderSubModel : orderSubModelList) {
					itemCodeList.add(orderSubModel.getGoodsId());
				}
				Response<List<ItemModel>> itemModelReponse = new Response<>();
				itemModelReponse = itemService.findByCodesAll(itemCodeList);
				if (!itemModelReponse.isSuccess() || itemModelReponse.getResult() == null
						|| itemModelReponse.getResult().isEmpty()) {
					response.setError("itemModelList.be.null");
					return response;
				}
				itemModelList = itemModelReponse.getResult();
				log.info("itemModelList=======:   " + itemModelList.size());
				// 支付方式
				Response<List<TblGoodsPaywayModel>> TblGoodsPaywayModelReponse = new Response<>();
				TblGoodsPaywayModelReponse = goodsPayWayService.findGoodsPayWayByCodes(itemCodeList);
				if (!TblGoodsPaywayModelReponse.isSuccess() || TblGoodsPaywayModelReponse.getResult() == null
						|| TblGoodsPaywayModelReponse.getResult().isEmpty()) {
					response.setError("TblGoodsPaywayModellList.be.null");
					return response;
				}
//				TblGoodsPaywayModellList = TblGoodsPaywayModelReponse.getResult();
//				log.info("TblGoodsPaywayModellList=======:   " + TblGoodsPaywayModellList.size());
				// 获取商品
				List<String> goodsCodes = Lists.newArrayList();

				if (itemModelList != null && !itemModelList.isEmpty()) {
					for (ItemModel itemModel : itemModelList) {
						goodsCodes.add(itemModel.getGoodsCode());
					}
					Response<List<GoodsModel>> goodsModelReponse = new Response<>();
					goodsModelReponse = goodsService.findByCodes(goodsCodes);
					if (!goodsModelReponse.isSuccess() || goodsModelReponse.getResult() == null
							|| goodsModelReponse.getResult().isEmpty()) {
						response.setError("goodsModellList.be.null");
						return response;
					}
					log.info("goodsModellList=======:   " + goodsModellList.size());
					goodsModellList = goodsModelReponse.getResult();
				}
			}
			// 循环处理List 封装dto
			SimpleDateFormat sdf_y = new SimpleDateFormat("yyyy");
			SimpleDateFormat sdf_md = new SimpleDateFormat("MM-dd");
			for (int o = 0; o < orderSubModelList.size(); o++) {
				OrderQueryDto orderQueryDto = new OrderQueryDto();
				OrderSubModel orderModel = orderSubModelList.get(o);// orderSubModelList
				String main_Id = orderModel.getOrdermainId();
				String goods_Id = orderModel.getGoodsId(); // itemModelList
//				String payWay_Id = orderModel.getPaywayCode();//TblGoodsPaywayModellList
//				String order_Id = orderModel.getOrderId();//OrderTransModellList
				// 加工子订单
				//				orderModel.getOrdertypeId();														//订单类型___return
				orderQueryDto.setOrdertypeId(orderModel.getOrdertypeId());
				//				orderModel.getOrderId();															//订单编号___return
				orderQueryDto.setOrderId(orderModel.getOrderId());
				//				orderModel.getStagesNum();															//分期数___return
				orderQueryDto.setStagesNum(orderModel.getStagesNum());
				//				orderModel.getSinglePrice();														//总金额金额___return
				orderQueryDto.setSinglePrice(orderModel.getSinglePrice());
				//				orderModel.getIntegraltypeId();														//积分类型___return
				orderQueryDto.setIntegraltypeId(orderModel.getIntegraltypeId());
				orderQueryDto.setCreateTime(orderModel.getCreateTime());
				orderQueryDto.setModifyTime(orderModel.getModifyTime());
				if(orderModel.getModifyTime() != null){
					orderQueryDto.setModify_Date(sdf_y.format(orderModel.getModifyTime()));
					orderQueryDto.setModify_Time(sdf_md.format(orderModel.getModifyTime()));
				}
				//				orderModel.getCurStatusId();														//订单状态___return
				orderQueryDto.setCurStatusId(orderModel.getCurStatusId());
				//				orderModel.getGoodssendFlag();														//发货状态___return
				orderQueryDto.setGoodssendFlag(orderModel.getGoodssendFlag());
				//				orderModel.getGoodsNm();															//商品名称___return
				orderQueryDto.setGoodsNm(orderModel.getGoodsNm());
				//				orderModel.getGoodsNum();															//购买数量___return
				orderQueryDto.setGoodsNum(orderModel.getGoodsNum());
				//				orderModel.getSourceId();															//订单渠道___return
				orderQueryDto.setSourceId(orderModel.getSourceId());
				//				orderModel.getMerId();																//小商户号___return
				orderQueryDto.setMerId(orderModel.getMerId());
				//				orderModel.getOrdermainId();														//大订单号___return
				orderQueryDto.setOrdermainId(orderModel.getOrdermainId());
				//				orderModel.getCardno();																//卡号___return
				orderQueryDto.setCardno(orderModel.getCardno());
				//				orderModel.getCardtype();															//卡片类型___return
				orderQueryDto.setCardtype(orderModel.getCardtype());
				//				orderModel.getBonusPrice();															//积分抵扣金额___return
				orderQueryDto.setBonusPrice(orderModel.getBonusPrice());
				//				orderModel.getTotalMoney();															//现金___return
				orderQueryDto.setTotalMoney(orderModel.getTotalMoney());
				//				orderModel.getBonusTotalvalue();													//总积分值___return
				orderQueryDto.setBonusTotalvalue(orderModel.getBonusTotalvalue());
				//				orderModel.getSingleBonus();														//单个总积___return
				orderQueryDto.setSingleBonus(orderModel.getSingleBonus());
				//				//"颜色"																			//属性1___return
				orderQueryDto.setGoodsAttr1(orderModel.getGoodsAttr1());
				//				orderModel.getGoodsColor();															//属性值1___return
				orderQueryDto.setGoodsColor(orderModel.getGoodsColor());
				//				//"型号"																			//属性2___return
				orderQueryDto.setGoodsAttr2(orderModel.getGoodsAttr2());
				//				orderModel.getGoodsModel();															//属性值2___return
				orderQueryDto.setGoodsModel(orderModel.getGoodsModel());
				//				orderModel.getVoucherNo();															//优惠券编号___return
				orderQueryDto.setVoucherNo(orderModel.getVoucherNo());
				//				orderModel.getVoucherNo();															//签收时间___return
				orderQueryDto.setReceivedTime(orderModel.getReceivedTime());
				//				orderModel.getOrderIdHost();														//积分流水___return
				orderQueryDto.setOrderIdHost(orderModel.getOrderIdHost());
				// 加工主订单数据
				for (int t = 0; t < OrderMainModelList.size(); t++) {
					OrderMainModel orderMainModel = OrderMainModelList.get(t);
					if (main_Id.equals(orderMainModel.getOrdermainId())) {
						orderQueryDto.setOrdermainId(orderMainModel.getOrdermainId());
						//						orderMainModel.getMerId();   												//大商户号___return
						orderQueryDto.setMerId(orderMainModel.getMerId());
						break;
					}
				}
				// 加工 item数据 good数据
				for (int i = 0; i < itemModelList.size(); i++) {
					ItemModel itemModels = itemModelList.get(i);
					if (goods_Id.equals(itemModels.getCode())) {
						//						itemModels.getImage1();														//图片URL___return
						orderQueryDto.setGoods_Picture1(itemModels.getImage1());
						// 						itemModels.getMarketPrice();												//市场价___return
						orderQueryDto.setMarketPrice(itemModels.getMarketPrice());
						orderQueryDto.setGoods_Id(itemModels.getCode());
						for (int g = 0; g < goodsModellList.size(); g++) {
							if (itemModels.getGoodsCode().equals(goodsModellList.get(g).getCode())) {
								GoodsModel goodsModel = goodsModellList.get(g);
								orderQueryDto.setIntegral_Type(goodsModel.getPointsType());
								break;
							}
						}
						break;
					}
				}
				//加工支付方式
//				for (int p = 0; p < TblGoodsPaywayModellList.size(); p++) {
//					TblGoodsPaywayModel tblGoodsPaywayModel = TblGoodsPaywayModellList.get(p);
//					if (payWay_Id.equals(tblGoodsPaywayModel.getGoodsPaywayId())) {
//						//						tblGoodsPaywayModel.getPerStage();											//分期金额___return
//						orderQueryDto.setPer_Stage(tblGoodsPaywayModel.getPerStage());
//						orderQueryDto.setGoods_Price(tblGoodsPaywayModel.getGoodsPrice());
//						orderQueryDto.setIs_Action(tblGoodsPaywayModel.getIsAction());
//						break;
//					}
//				}
				// 售价
				BigDecimal totalMoney = orderModel.getTotalMoney();
				BigDecimal uitdrtamt = orderModel.getUitdrtamt();
				BigDecimal voucherPrice = orderModel.getVoucherPrice();
				BigDecimal price = BigDecimal.ZERO.setScale(2);
				if (totalMoney != null) {
					price = price.add(totalMoney);
				}
				if (uitdrtamt != null) {
					price = price.add(uitdrtamt);
				}
				if (voucherPrice != null) {
					price = price.add(voucherPrice);
				}
				Integer stagesNum = orderModel.getStagesNum();
				if (stagesNum == null || stagesNum == 0) {
					stagesNum = 1;
				}
				// 总价%分期数
				price = price.divide(new BigDecimal(stagesNum.intValue()), 2, BigDecimal.ROUND_DOWN);
				orderQueryDto.setPer_Stage(price);
				orderQueryDto.setGoods_Price(totalMoney);
				orderQueryDtos.add(orderQueryDto);
			}
			response.setResult(new Pager<OrderQueryDto>(pager.getTotal(), orderQueryDtos));
		} catch (Exception e) {
			e.printStackTrace();
			log.error("OrderServiceImpl.find.qury.error", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.find.qury.error");
			return response;
		}
		return response;
	}

	/**
	 * 根据acceptedNo查询OrderMianId的集合
	 * @param acceptedNo
	 * @return
	 */
	@Override
	public Response<List<String>> findOrderMainIdByAcceptedNo(String acceptedNo){
		Response<List<String>> response = new Response<>();
		try{
			List<String> list = orderMainDao.findOrderMainIdByAcceptedNo(acceptedNo);
			response.setResult(list);
			return response;
		}catch (Exception e){
			log.error("OrderQueryService.findOrderMainIdByAcceptedNo.error", Throwables.getStackTraceAsString(e));
			response.setError("OrderQueryService.findOrderMainIdByAcceptedNo.error");
			return response;
		}
	}

	/**
	 * 更新广发商城小订单的流水号
	 * @param orderId
	 * @param orderIdHost
	 * @return
	 */
	@Override
	@Transactional
	public Response<Integer> updateOrderSerialNo(String orderId,String orderIdHost){
		Response<Integer> response = Response.newResponse();
		try{
			Map<String,Object> params = Maps.newHashMap();
			params.put("orderId",orderId);
			params.put("orderIdHost",orderIdHost);
			Integer count = orderQueryManager.updateOrderSerialNo(params);
			response.setResult(count);
			return response;
		} catch (Exception e){
			log.error("OrderQueryService.updateOrderSerialNo.error", Throwables.getStackTraceAsString(e));
			response.setError("OrderQueryService.updateOrderSerialNo.error");
			return response;
		}
	}

	/**
	 * MAL109 更新投递方式信息
	 * @param orderMainModel
	 * @param orderMainHis
	 * @return
	 */
	@Override
	public Response<Integer> orderPostChangewithTX(OrderMainModel orderMainModel, TblOrderMainHisModel orderMainHis) {
		Response<Integer> response = Response.newResponse();
		try {
			int count = 0;
			count += orderQueryManager.updateOrderMainAddr(orderMainModel);
			count += orderQueryManager.insert(orderMainHis);
			response.setResult(count);
			return response;
		} catch (Exception e){
			log.error("OrderQueryService.orderPostChangewithTX.error", Throwables.getStackTraceAsString(e));
			response.setError("OrderQueryService.orderPostChangewithTX.error");
			return response;
		}
	}

	/**
	 * Description : MAL114 订单历史地址信息查询
	 * @author xiewl
	 * @since 2016/09/03
	 * @param orderMainId
	 * @return
	 */
	@Override
	public Response<List<TblOrderMainHisModel>> findOrderMainHisByOrderMainId(String orderMainId) {
		Response<List<TblOrderMainHisModel>> response = new Response<>();
		List<TblOrderMainHisModel> orderMainHises = Lists.newArrayList();
		if (Strings.isNullOrEmpty(orderMainId)) {
			response.setSuccess(false);
			response.setError("find.ordermainhis.by.ordermain.id.error : order.main.id is null or empty");
			return response;
		}
		try {
			orderMainHises= tblOrderMainHisDao.findByOrderMainId(orderMainId);
			response.setResult(orderMainHises);
			response.setSuccess(true);
			return response;
		} catch (Exception e) {
			response.setSuccess(false);
			response.setError("find.ordermainhis.by.ordermain.id.error");
			return response;
		}
	}



	/**
	 * MAL113 分页查询订单信息
	 * @return
	 */
	@Override
	public Response<Pager<OrderCCInfoDto>> queryOrderInfo(Integer startPage, Integer limit, String orderId, String cardNo, String cont_idcard, String acceptedNo, String betweenDate, String bankOrderId) {
		Response<Pager<OrderCCInfoDto>> response = Response.newResponse();
        try{
            // 根据条件查询子订单表
            Map<String,Object> params = Maps.newHashMap();
			params.put("orderId",orderId);
			params.put("cardno",cardNo);
			params.put("startDate",betweenDate.split("\\|")[0]);
			params.put("endDate",betweenDate.split("\\|")[1]);
			Date nowDate = new Date();
			Date startDate = DateHelper.string2Date(betweenDate.split("\\|")[0], DateHelper.YYYYMMDD);
            List<OrderSubModel> orderInfo113 = orderSubDao.findOrderInfo113(params);
            if (nowDate.after(DateHelper.addMonth(startDate, 6))) {//大于六个月
            	List<TblOrderHistoryModel> tblOrderhistoryModels=  tblOrderHistoryDao.findForCCIntergral(params);
            	if (tblOrderhistoryModels!= null && tblOrderhistoryModels.isEmpty()) {
            		List<OrderSubModel>  orderHisoryModelsToSub =  BeanUtils.copyList(tblOrderhistoryModels, OrderSubModel.class);
            		orderInfo113.addAll(orderHisoryModelsToSub);
            	}
            }
            if (nowDate.after(DateHelper.addMonth(startDate, 24))) {//大于两年
            	Pager<OrderBackupModel> orderBackupModelPager =  orderBackupDao.findByPage(params, 0, Integer.MAX_VALUE);
            	if (orderBackupModelPager != null && orderBackupModelPager.getData()!= null && !orderBackupModelPager.getData().isEmpty()) {
            		List<OrderBackupModel>  orderBackupModels = orderBackupModelPager.getData();
            		List<OrderSubModel>  orderBackupModelsToSub =  BeanUtils.copyList(orderBackupModels, OrderSubModel.class);
            		orderInfo113.addAll(orderBackupModelsToSub);
            	}
			}
            // 根据条件查询主订单表
            Map<String,Object> params1 = Maps.newHashMap();
            params1.put("acceptedNo",acceptedNo);
            params1.put("contIdcard",cont_idcard);
            List<String> orderMainfor113 = orderMainDao.findOrderMainfor113(params1);
            if (nowDate.after(DateHelper.addMonth(startDate, 6))) {//大于六个月
            	List<String> orderMainHisMainIds =  tblOrdermainHistoryDao.findOrderMainfor113(params1);
            	if (orderMainHisMainIds != null && !orderMainHisMainIds.isEmpty()) {
            		orderMainfor113.addAll(orderMainHisMainIds);
            	}
            }
            if (nowDate.after(DateHelper.addMonth(startDate, 24))) {//大于两年
            	List<String> orderBackupMainIds =  tblOrderMainBackupDao.findOrderMainfor113(params1);
            	if (orderBackupMainIds != null && !orderBackupMainIds.isEmpty()) {
            		orderMainfor113.addAll(orderBackupMainIds);
            	}
			}
            List<TblOrderExtend1Model> orderExtend1for113 = Lists.newArrayList();
            // 判断如果bankOrderId不为空，查询订单扩展表
            if (bankOrderId != null && !"".equals(bankOrderId)){
                orderExtend1for113 = tblOrderExtend1Dao.findOrderExtend1for113(bankOrderId);
                // 循环list，取交集
				for (int i=0; i<orderInfo113.size(); i++){
					OrderSubModel orderSubModel = orderInfo113.get(i);
					String subOrderId = orderSubModel.getOrderId();
					boolean flag = false;
					for (TblOrderExtend1Model tblOrderExtend1Model : orderExtend1for113) {
						if (subOrderId.equals(tblOrderExtend1Model.getOrderId())){
							flag = true;
							break;
						}
					}
					if (!flag){
						orderInfo113.remove(i);
						continue;
					}
				}
            }

            // 循环子订单表和主订单表，取交集
			for (int m=0; m<orderInfo113.size(); m++){
				OrderSubModel orderSubModel = orderInfo113.get(m);
				String orderMainId = orderSubModel.getOrdermainId();
				boolean flag = false;
				for (String mainId : orderMainfor113) {
					if (orderMainId.equals(mainId)){
						flag = true;
						break;
					}
				}
				if (!flag){
					orderInfo113.remove(m);
					continue;
				}
			}

            // 查询支付方式
            List<String> payWayIdList = Lists.newArrayList();
			HashSet<String> set = new HashSet<String>();
            for (OrderSubModel orderSubModel : orderInfo113) {
				set.add(orderSubModel.getGoodsPaywayId());
            }
			payWayIdList.addAll(set);
            Response<List<TblGoodsPaywayModel>> tblGoodsPaywayModelReponse = new Response<>();
            tblGoodsPaywayModelReponse = goodsPayWayService.findByGoodsPayWayIdList(payWayIdList);
            if (!tblGoodsPaywayModelReponse.isSuccess() || tblGoodsPaywayModelReponse.getResult() == null
                    || tblGoodsPaywayModelReponse.getResult().isEmpty()) {
                response.setError("TblGoodsPaywayModellList.be.null");
                return response;
            }
            List<TblGoodsPaywayModel> tblGoodsPaywayModel = tblGoodsPaywayModelReponse.getResult();
            // 组合需要返回的list集合
            List<OrderCCInfoDto> orderCCInfoDtos = Lists.newArrayList();
            for (OrderSubModel orderSubModel : orderInfo113) {
                String orderSubId = orderSubModel.getOrderId();
                String goodsPayWayId = orderSubModel.getGoodsPaywayId();
                // 组装Dto
                OrderCCInfoDto orderCCInfoDto = new OrderCCInfoDto();
                orderCCInfoDto.setOrdermainId(orderSubModel.getOrdermainId());
                orderCCInfoDto.setOrderId(orderSubModel.getOrderId());
                orderCCInfoDto.setTotalMoney(orderSubModel.getTotalMoney());
                orderCCInfoDto.setIncTakePrice(orderSubModel.getIncTakePrice());
                orderCCInfoDto.setCreateTime(orderSubModel.getCreateTime());
                orderCCInfoDto.setCurStatusId(orderSubModel.getCurStatusId());
                orderCCInfoDto.setGoodssendFlag(orderSubModel.getGoodssendFlag());
                orderCCInfoDto.setGoodsNm(orderSubModel.getGoodsNm());
                orderCCInfoDto.setCardno(orderSubModel.getCardno());
                orderCCInfoDto.setSourceId(orderSubModel.getSourceId());
                orderCCInfoDto.setCurStatusNm(orderSubModel.getCurStatusNm());
                orderCCInfoDto.setVoucherNo(orderSubModel.getVoucherNo());
                orderCCInfoDto.setVoucherNm(orderSubModel.getVoucherNm());
                orderCCInfoDto.setVoucherPrice(orderSubModel.getVoucherPrice());
                orderCCInfoDto.setUitdrtamt(orderSubModel.getUitdrtamt());
                orderCCInfoDto.setBonusTotalvalue(orderSubModel.getBonusTotalvalue());
                orderCCInfoDto.setVendorId(orderSubModel.getVendorId());
                orderCCInfoDto.setVendorSnm(orderSubModel.getVendorSnm());
                orderCCInfoDto.setCustCartId(orderSubModel.getCustCartId());
                orderCCInfoDto.setActType(orderSubModel.getActType());
                orderCCInfoDto.setGoodsId(orderSubModel.getGoodsId());
                orderCCInfoDto.setStagesNum(orderSubModel.getStagesNum());
                // 添加分期方式代码和商品价格
                for (TblGoodsPaywayModel goodsPaywayModel : tblGoodsPaywayModel) {
                    if (goodsPayWayId != null && goodsPayWayId.equals(goodsPaywayModel.getGoodsPaywayId())){
                        orderCCInfoDto.setStagesCode(goodsPaywayModel.getStagesCode());
                        orderCCInfoDto.setGoodsPrice(goodsPaywayModel.getGoodsPrice());
                        break;
                    }
                }
                // 添加银行订单号
                TblOrderExtend1Model model = tblOrderExtend1Dao.findByOrderId(orderSubId);
                if (model != null) {
					orderCCInfoDto.setOrderNbr(model.getOrdernbr());
				}
                orderCCInfoDtos.add(orderCCInfoDto);
            }

            // 排序
            List<OrderCCInfoDto> ccInfoDtos = ordering(orderCCInfoDtos);
            // 剩余信息
            double totalCount = Double.valueOf(ccInfoDtos.size());
            int totalPages = (int) Math.ceil(totalCount / Double.valueOf(limit));
            // 分页
            List<OrderCCInfoDto> pageData = getPageData(ccInfoDtos, startPage, limit);
            response.setResult(new Pager<OrderCCInfoDto>(Long.valueOf(totalPages), pageData));
            return response;
        } catch (Exception e){
            log.error("OrderServiceImpl.queryOrderInfo.error", Throwables.getStackTraceAsString(e));
            response.setError("OrderServiceImpl.queryOrderInfo.error");
            return response;
        }
	}

    /**
     * 排序
     * @param info
     * @return
     */
    private List<OrderCCInfoDto> ordering(List<OrderCCInfoDto> info){
        Ordering<OrderCCInfoDto> orderCCordering = Ordering.natural().onResultOf(
                new Function<OrderCCInfoDto, String>() {
                    @Override
                    @Nullable
                    public String apply(@Nullable OrderCCInfoDto info) {
                        return info.getOrderId() == null ? "" : info.getOrderId();
                    }
                });
        info = orderCCordering.sortedCopy(info);
        return info;
    }

	/**
	 * 获取指定页数的数据
	 */
	private List<OrderCCInfoDto> getPageData(List<OrderCCInfoDto> infos, Integer curPage,Integer rPage) {
		List<ArrayList<OrderCCInfoDto>> infosPage = new ArrayList<ArrayList<OrderCCInfoDto>>();
		//数据拼装
		if(infos.size()>0&&rPage>0){
			//总页数
			Integer pageSize=(infos.size()+rPage-1)/rPage;
			//包装数据
			int maxSize=infos.size()-1;
			for(int i=1 ;i<pageSize+1;i++){
				//构造每页数据
				ArrayList<OrderCCInfoDto> data=new ArrayList<OrderCCInfoDto>();
				//最后一页
				if(i==pageSize){
					//加入全部数据
					for(int pg=1;pg<rPage+1;pg++){
						if((pageSize-1)*rPage+pg-1<=maxSize){
							data.add(infos.get((pageSize-1)*rPage+pg-1));
						}
					}
				}else{
					for(int j=1;j<rPage+1;j++){
						data.add(infos.get((i-1)*rPage+(j-1)));
					}
				}
				//循环每次添加一页数据
				infosPage.add(data);
			}
		}

		if (infosPage != null && !infosPage.isEmpty()) {
			return infosPage.get(curPage - 1);
		} else {
			return infos;
		}
	}

    /**
     * MAL113 更新订单信息
     * @return
     */
    @Override
    public Response<Boolean> updateOpsOrderChangewithTX(String curStatusId, String curStatusNm, String orderId, OrderDoDetailModel orderDodetail, Map<String, String> runTime, String cust_cart_id, String act_type, String goodsId, String orderNbr, OrderCheckModel orderCheck) {
        Response<Boolean> response = Response.newResponse();
        try{
            log.info("into updateOpsOrderChangewithTX");
            // 更新子订单
            OrderSubModel orderSubModel = new OrderSubModel();
            orderSubModel.setOrderId(orderId);
            orderSubModel.setCurStatusId(curStatusId);
            orderSubModel.setCurStatusNm(curStatusNm);
            orderSubModel.setModifyOper("System");
            orderQueryManager.updateOrder(orderSubModel);
            // 如果银行订单号不为空，则更新
            if(!(orderNbr == null || "".equals(orderNbr))){
                TblOrderExtend1Model tblOrderExtend1 = new TblOrderExtend1Model();
                tblOrderExtend1.setOrderId(orderId);
                tblOrderExtend1.setOrdernbr(orderNbr);
                orderQueryManager.updateByOrderId(tblOrderExtend1);
            }

            log.info("curStatusId:"+curStatusId);
            if("0307".equals(curStatusId)){
                OrderSubModel subModel = orderSubDao.findById(orderId);

                //tblOrderDao.updateOrderAct(orderId);//回滚活动人数

                // 回滚库存(按照批处理逻辑处理)
                if (goodsId != null) {
                    if (null == subModel.getActId() || "".equals(subModel.getActId())){
                        itemService.rollbackBacklogByNum(subModel.getGoodsId(),1);
                    }else {
                        // 判断活动，荷兰拍回滚，其他活动不回滚。。。
                        if (Contants.PROMOTION_PROM_TYPE_STRING_50.equals(subModel.getActType())){
                            String promId = subModel.getActId();// 活动id
                            String periodId = String.valueOf(subModel.getPeriodId());
                            String itemCode = subModel.getGoodsId(); //单品号
                            String buyCount = "-" + String.valueOf(subModel.getGoodsNum()); //回滚库存，减销量，所以传负数
                            User user = new User();
                            user.setId(subModel.getCreateOper());
                            mallPromotionService.updatePromSaleInfo(promId, periodId, itemCode, buyCount, user);
                        }
                    }
                }
            }
            /** 电子支付成功，去bps状态未明，cc状态查询，去bps返回无工单，退积分;积分成功记录在MAL115，支付成功的时候已插 */
            if(null!=orderCheck){
                orderQueryManager.insert(orderCheck);
            }

            if("0308".equals(curStatusId) || "0305".equals(curStatusId)){

                //tblEspCustCartDao.cleanCustCart(orderId);//更新购物车
                // 增加荷兰商品处理
                if(Contants.PROMOTION_PROM_TYPE_5.equals(Integer.valueOf(act_type)) && null!=cust_cart_id && cust_cart_id.length()!=0){
                    AuctionRecordModel auctionRecord = new AuctionRecordModel();
                    auctionRecord.setId(Long.valueOf(cust_cart_id));
                    auctionRecord.setPayFlag("1");
                    orderQueryManager.update(auctionRecord);
                }
            }

            orderQueryManager.insert(orderDodetail);
            log.info("runTime:"+runTime);
            if(runTime != null && runTime.size() > 0){
                log.info("runTime.size:"+runTime.size());
                orderQueryManager.updateBatchStatus(runTime);
            }
            response.setResult(Boolean.TRUE);
            return response;
        } catch (Exception e){
            log.error("OrderServiceImpl.updateOpsOrderChangewithTX.error", Throwables.getStackTraceAsString(e));
            response.setError("OrderServiceImpl.updateOpsOrderChangewithTX.error");
            return response;
        }
    }
    @Override
    public Response<List<String>> findCreteOperByCertNo(String certNo) {
	Response<List<String>> result=new Response<>();
	try {
	    List<String> createOperList=orderMainDao.findCreateOperNoByCertNo(certNo);
	    result.setResult(createOperList);
	} catch (Exception e) {
	    log.error("OrderServiceImpl.findCreteOperByCertNo.error", Throwables.getStackTraceAsString(e));
	    result.setError("OrderServiceImpl.findCreteOperByCertNo.error");
	}
	return result;
    }
    @Override
    public Response<List<OrderQueryDto>> findSubOrderNum(List<String> orderMainIds){
    	Response<List<OrderQueryDto>> result=new Response<>();
    	List<OrderQueryModel> list=tblOrderDao2.findSubOrderNum(orderMainIds);
    	if(list==null){
    		result.setError("query.param.is.empty");
    	}
    	List<OrderQueryDto> list1=new ArrayList<>();
    	for(OrderQueryModel model:list){
    		OrderQueryDto dto=new OrderQueryDto();
    		dto.setOrdermainId(model.getOrderMainId());
    		dto.setSubOrderNum(model.getSubOrderNum());
    		list1.add(dto);
    	}
    	result.setResult(list1);
    	return result;
    }

}
