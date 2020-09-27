package cn.com.cgbchina.trade.service;

import java.util.*;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.SignAndVerify;
import cn.com.cgbchina.related.model.TblParametersModel;
import cn.com.cgbchina.trade.dto.AppStageMallPayVerificationReturnSubVO;
import com.google.common.base.Function;
import com.google.common.base.Predicate;
import com.google.common.base.Throwables;
import com.google.common.collect.Collections2;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.generator.service.IdGeneratorImpl;
import cn.com.cgbchina.item.service.*;
import cn.com.cgbchina.related.service.BusinessService;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.manager.*;
import cn.com.cgbchina.trade.model.*;
import cn.com.cgbchina.user.service.MemberAddressService;
import cn.com.cgbchina.user.service.VendorService;
import lombok.extern.slf4j.Slf4j;


@Service
@Slf4j
public class OrderCheckServiceImpl implements OrderCheckService {
	@Resource
	OrderBackupDao orderBackupDao;
	@Resource
	OrderSubDao orderSubDao;
	@Resource
	OrderMainDao orderMainDao;
	@Resource
	OrderTransDao orderTransDao;
	@Resource
	OrderPartBackDao orderPartBackDao;
	@Resource
	OrderReturnTrackDao orderReturnTrackDao;
	@Resource
	OrderOutSystemDao orderOutSystemDao;
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
	TblOrderCheckDao tblOrderCheckDao;
	@Resource
	VendorService VendorService;
	@Resource
	OrderSubManager orderSubManager;
	@Resource
	OrderTransManager orderTransManager;
	@Resource
	OrderDodetailManger orderDodetailManager;
	@Resource
	OrderMainManager orderMainManager;
	@Resource
	IdGeneratorImpl idGeneratorImpl;
	@Resource
	OrderReturnTrackManager orderReturnTrackManager;
	@Resource
	SmsTemplateService smsTemplateService;
	@Resource
	BusinessService businessService;
	@Resource
	OrderCheckManager orderCheckManager;
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
	@Value("#{app.entPublicKey}")
	private String entPublicKey;
	@Resource
	PaymentService paymentService;
	@Resource
	TblOrderHistoryDao tblOrderHistoryDao;
	@Resource
	TblOrdermainHistoryDao tblOrdermainHistoryDao;
	@Resource
	OrderReturnTrackDetailDao orderReturnTrackDetailDao;
	@Resource
	OrderTieinSaleService orderTieinSaleService;
	@Resource
	TblOrderExtend1Dao tblOrderExtend1Dao;
	@Resource
	TblEspCustCartDao tblEspCustCartDao;
	@Resource
	OrderCancelDao orderCancelDao;
	@Resource
	OrderDoDetailDao orderDoDetailDao;

	@Override
	public TblEspCustCartModel getTblEspCustCart(String cartId) {
		return tblEspCustCartDao.findById(cartId);
	}
	@Override
	public TblOrderExtend1Model queryTblOrderExtend1(Long orderExtend1Id){
		return tblOrderExtend1Dao.findById(orderExtend1Id);
	}
	public Integer updateOrder(OrderSubModel model){
		return orderSubManager.update1(model);
	}
	public void insertOrderCancel(OrderCancelModel model){
		orderCheckManager.insert(model);
	}
	public void insertOrderDoDetail(OrderDoDetailModel orderDoDetailModel){
		orderCheckManager.insert(orderDoDetailModel);
	}
	public List<OrderDoDetailModel> findByOrderId(String orderId){
		return orderDoDetailDao.findByOrderId(orderId);
	}

	/**
	 * 处理支付信息
	 *
	 * @param subVOs
	 * @param rollBackStockMap
	 * @param pointMap
	 */
	@Override
	public Response dealProcess(List<AppStageMallPayVerificationReturnSubVO> subVOs, Map<String, Integer> rollBackStockMap, Map<String, Long> pointMap) {
		Response ret = Response.newResponse();
		Predicate<Object> predicate = new Predicate<Object>() {
			@Override
			public boolean apply(Object input) {
				return input != null;
			}
		};
		List<OrderSubModel> subOrders = Lists.transform(subVOs, new Function<AppStageMallPayVerificationReturnSubVO, OrderSubModel>() {
			@Override
			public OrderSubModel apply(@NotNull AppStageMallPayVerificationReturnSubVO input) {
				return input.getSubOrder();
			}
		});
		List<OrderDoDetailModel> orderDoDetailModels = Lists.transform(subVOs, new Function<AppStageMallPayVerificationReturnSubVO, OrderDoDetailModel>() {
			@Override
			public OrderDoDetailModel apply(@NotNull AppStageMallPayVerificationReturnSubVO input) {
				return input.getOrderDoDetailModel();
			}
		});
		OrderMainModel orderMainModel = subVOs.get(0).getTblOrderMain();

		Predicate<TblEspCustCartModel> predicate2 = new Predicate<TblEspCustCartModel>() {
			@Override
			public boolean apply(TblEspCustCartModel input) {
				return input != null && input.getPayFlag() != null && "1".equals(input.getPayFlag());
			}
		};

		List<TblEspCustCartModel> tblEspCustCartModels = Lists.transform(subVOs, new Function<AppStageMallPayVerificationReturnSubVO, TblEspCustCartModel>() {
			@Override
			public TblEspCustCartModel apply(@NotNull AppStageMallPayVerificationReturnSubVO input) {
				return input.getTblEspCustCartModel();
			}
		});
		Collection<TblEspCustCartModel> espCustCartModels = Collections2.filter(tblEspCustCartModels, predicate2);

		List<OrderCheckModel> orderCheckModelList = Lists.transform(subVOs, new Function<AppStageMallPayVerificationReturnSubVO, OrderCheckModel>() {
			@Override
			public OrderCheckModel apply(@NotNull AppStageMallPayVerificationReturnSubVO input) {
				return input.getOrderCheckModel();
			}
		});
		Collection<OrderCheckModel> orderCheckModels = Collections2.filter(orderCheckModelList, predicate);

		List<OrderCheckModel> orderCheckModels2List = Lists.transform(subVOs, new Function<AppStageMallPayVerificationReturnSubVO, OrderCheckModel>() {
			@Override
			public OrderCheckModel apply(@NotNull AppStageMallPayVerificationReturnSubVO input) {
				return input.getOrderCheckModelPlus();
			}
		});
		Collection<OrderCheckModel> orderCheckModels2 = Collections2.filter(orderCheckModels2List, predicate);

		List<TblOrderExtend1Model> orderExtend1ModelsIList = Lists.transform(subVOs, new Function<AppStageMallPayVerificationReturnSubVO, TblOrderExtend1Model>() {
			@Override
			public TblOrderExtend1Model apply(@NotNull AppStageMallPayVerificationReturnSubVO input) {
				return input.getTblOrderExtendI();
			}
		});
		Collection<TblOrderExtend1Model> orderExtend1ModelsI = Collections2.filter(orderExtend1ModelsIList, predicate);

		List<TblOrderExtend1Model> orderExtend1ModelsUList = Lists.transform(subVOs, new Function<AppStageMallPayVerificationReturnSubVO, TblOrderExtend1Model>() {
			@Override
			public TblOrderExtend1Model apply(@NotNull AppStageMallPayVerificationReturnSubVO input) {
				return input.getTblOrderExtendU();
			}
		});
		Collection<TblOrderExtend1Model> orderExtend1ModelsU = Collections2.filter(orderExtend1ModelsUList, predicate);

		try {
			orderCheckManager.dealOrderwithTX(subOrders, rollBackStockMap, pointMap,
                    Lists.newArrayList(orderCheckModels),
					Lists.newArrayList(orderCheckModels2),
					Lists.newArrayList(orderExtend1ModelsI),
					Lists.newArrayList(orderExtend1ModelsU),
                    Lists.newArrayList(espCustCartModels),
                    orderMainModel,
                    orderDoDetailModels);
			ret.setSuccess(true);
		} catch (Exception e) {
			log.error("数据库更新异常, erro:{}", Throwables.getStackTraceAsString(e));
			ret.setError(e.getMessage());
		}
		return ret;
	}

	/** 大机试运行标识 1：试运行  0：试运行结束 */
	private static String runFlag;
	/** 大机试运行卡号8,9位 */
	private static String cardNoSubStr ;
	/**
	 * 是否使用新方法
	 * 试运行标识是0(试运行结束，使用新方法);试运行标识是1(试运行中,如果卡号8、9为是44,则使用新方法)
	 * @param cardNo
	 * @return
	 */
	public boolean isPractiseRun(String cardNo){
		if(needToUpdateRunFlag()){//判断是否需要更新runFlag
			// 大机试运行
			List<Map> list = orderSubDao.getBigMachineParam();
			if(null == list || 0==list.size()){
				runFlag="0";
			}else{
				Map codeModel = list.get(0);
				//如果试运行标识为空，则给默认值1（试运行结束）
				String pro_pri = String.valueOf(codeModel.get("proPri"));
				cardNoSubStr = String.valueOf(codeModel.get("proDesc"));
				if(0 == pro_pri.length()){
					runFlag="0";
				}else{
					runFlag=pro_pri;//更新runFlag
				}
				runFlag=pro_pri;//更新runFlag
				list.clear();
			}
		}
		if("0".equals(runFlag)){//0 试运行结束，使用新方法
			return true;
		} else if ("1".equals(runFlag)){//1试运行中，如果卡号8、9位是44的，就走新流程。
			//卡号为空或者卡长度不够9位
			if(null == cardNo || cardNo.length()<9){
				return false;
			}else{
				//卡号第8、9为是44，走新流程
				if(cardNoSubStr != null && cardNoSubStr.length() == 2){
					if(cardNoSubStr.charAt(0) == cardNo.charAt(7) && cardNoSubStr.charAt(1) == cardNo.charAt(8)){
						return true;
					}
				}
			}
			return false;
		}
		return true; //默认试运行结束
	}

	/**
	 * 检查runFlag是否需求更新
	 * 如果runFlag为空
	 */
	private static boolean needToUpdateRunFlag(){
		//初始化时候 标识位空时候，查询数据库
		if(null == runFlag || 0 == runFlag.length() ){
			log.info("runFlag:"+runFlag);
			return true;
		}
		return false;
	}

	public Object getTblOrderById(String orderId,String flag) {
		if("0".equals(flag)){
			OrderSubModel orderSubModel = orderSubDao.findById(orderId);
			if(orderSubModel==null){
				TblOrderHistoryModel tblOrderHistoryModel = tblOrderHistoryDao.findById(orderId);
				if(tblOrderHistoryModel!=null){
					return tblOrderHistoryModel;
				}
			}else{
				return orderSubModel;
			}
		}else if("1".equals(flag)){
			OrderBackupModel orderBackupModel = orderBackupDao.findById(orderId);
			if(orderBackupModel!=null)
				return orderBackupModel;
		}
		return null;
	}

	public void orderReturnwithTX(OrderSubModel tblOrder, OrderDoDetailModel orderDodetail,OrderCheckModel orderCheck,TblOrderHistoryModel orderHistory) {
		orderCheckManager.orderReturnwithTX( tblOrder, orderDodetail, orderCheck, orderHistory);
	}

	public List<Map> getBigMachineParam() {
		return orderSubDao.getBigMachineParam();
	}


	public TblOrderExtend1Model findExtend1ByOrderId (String orderId) {
		return tblOrderExtend1Dao.findByOrderId(orderId);
	}

	public Integer insertOutSystem (String mainId,String id){
		OrderOutSystemModel orderOutSystem = new OrderOutSystemModel();
		orderOutSystem.setOrderId(id);
		orderOutSystem.setOrderMainId(mainId);
		orderOutSystem.setTimes(0);
		orderOutSystem.setTuisongFlag("01");
		orderOutSystem.setSystemRole("99");
		orderOutSystem.setCreateOper("system");
		orderOutSystem.setCreateTime(new Date());
		orderOutSystem.setModifyOper("CC撤销订单超时");
		orderOutSystem.setModifyTime(new Date());
		return orderCheckManager.insert(orderOutSystem);
	}


	public List findJudgeQT(String ordertypeId, String sourceId) {
		Response<List<TblParametersModel>> response = businessService.findJudgeQT(ordertypeId,sourceId);
		if(!response.isSuccess()){
			log.error("Response.error,error code: {}", response.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
		}
		return response.getResult();
	}


	@Override
	public boolean verify_md(String inbuf, String sign) {
		return SignAndVerify.verify_md(inbuf, sign, entPublicKey);
	}


}
