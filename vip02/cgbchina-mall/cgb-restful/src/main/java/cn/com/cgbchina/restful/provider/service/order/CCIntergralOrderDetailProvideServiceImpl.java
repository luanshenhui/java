package cn.com.cgbchina.restful.provider.service.order;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderDetailChildren;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderDetailReturn;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrdersQuery;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrderDetailQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrderDetailReturnVO;
import cn.com.cgbchina.trade.model.OrderBackupModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderTransModel;
import cn.com.cgbchina.trade.model.OrderVirtualModel;
import cn.com.cgbchina.trade.model.TblOrderHistoryModel;
import cn.com.cgbchina.trade.model.TblOrderMainBackupModel;
import cn.com.cgbchina.trade.model.TblOrdermainHistoryModel;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.trade.service.TblOrderMainBackupService;
import cn.com.cgbchina.trade.service.TblOrderMainHistoryService;
import cn.com.cgbchina.trade.service.TblOrderMainService;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.util.BeanMapper;

/**
 * MAL108 CC积分商城订单详细信息查询 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL108")
@Slf4j
public class CCIntergralOrderDetailProvideServiceImpl implements  SoapProvideService <CCIntergralOrderDetailQueryVO,CCIntergralOrderDetailReturnVO>{
	@Resource
	TblOrderMainService tblOrderMainService;
	@Resource
	TblOrderMainHistoryService tblOrderMainHistoryService;
	@Resource
	TblOrderMainBackupService tblOrderMainBackupService;
	@Resource
	OrderService orderService;
	@Resource
	GoodsService goodsService;

	@Override
	public CCIntergralOrderDetailReturnVO process(SoapModel<CCIntergralOrderDetailQueryVO> model, CCIntergralOrderDetailQueryVO content) {

		//校验
		if(content == null){
			throw new ResponseException(Contants.ERROR_CODE_500, "content.time.query.error");
		}
		// 定义返回值
		CCIntergralOrderDetailReturn cCIntergralOrderDetailReturn = new CCIntergralOrderDetailReturn();
		// 取出传入的参数
		CCIntergralOrdersQuery cCIntergralOrdersQuery = BeanUtils.copy(content, CCIntergralOrdersQuery.class);
		String orderMainId = cCIntergralOrdersQuery.getOrderMainId();//主订单号
		//主订单号为空的情况返回参数为空
		// donghb 0905 start
		if(StringUtils.isEmpty(orderMainId)){
			// donghb 0905 end
			cCIntergralOrderDetailReturn.setChannelSN("CCAG");
			cCIntergralOrderDetailReturn.setSuccessCode("00");
			cCIntergralOrderDetailReturn.setReturnCode("000008");
			cCIntergralOrderDetailReturn.setReturnDes("参数为空");
			CCIntergralOrderDetailReturnVO cCIntergralOrderDetailReturnVO = BeanUtils.copy(cCIntergralOrderDetailReturn,
					CCIntergralOrderDetailReturnVO.class);
			return cCIntergralOrderDetailReturnVO;
		}
		//在tbl_order_main  tblordermain_backup  tblordermain_history 3个表里查询主订单信息
		Response<OrderMainModel> orderMainResponse = tblOrderMainService.findByOrderMainId(orderMainId);
		if(!orderMainResponse.isSuccess()){
			log.error("orderMain.time.query.error，error:{}", orderMainResponse.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, "orderMain.time.query.error");
		}
		Response<TblOrdermainHistoryModel> ordermainHistoryResponse = tblOrderMainHistoryService.findByOrderMainId(orderMainId);
		if (!ordermainHistoryResponse.isSuccess()) {
			log.error("orderMainHistory.time.query.error，error:{}", ordermainHistoryResponse.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, "orderMainHistory.time.query.error");
		}
		Response<TblOrderMainBackupModel> orderMainBackupResponse = tblOrderMainBackupService.findByOrderMainId(orderMainId);
		if (!orderMainBackupResponse.isSuccess()) {
			log.error("orderMainBackup.time.query.error，error:{}", orderMainBackupResponse.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, "orderMainBackup.time.query.error");
		}
		//3个表中均无主订单的情况返回找不到主订单
		if(orderMainResponse.getResult() == null && ordermainHistoryResponse.getResult() == null && orderMainBackupResponse.getResult() == null){
			cCIntergralOrderDetailReturn.setChannelSN("CCAG");
			cCIntergralOrderDetailReturn.setSuccessCode("00");
			cCIntergralOrderDetailReturn.setReturnCode("000013");
			cCIntergralOrderDetailReturn.setReturnDes("找不到订单");
			CCIntergralOrderDetailReturnVO cCIntergralOrderDetailReturnVO = BeanUtils.copy(cCIntergralOrderDetailReturn,
					CCIntergralOrderDetailReturnVO.class);
			return cCIntergralOrderDetailReturnVO;
		}
		//主订单存在情况下，在tbl_order  tblorder_history  tblorder_backup 3个表里查询子订单信息
		Response<List<OrderSubModel>> orderSubResponse = orderService.findByorderMainId(orderMainId);
		if(!orderSubResponse.isSuccess()){
			log.error("tbl_order.find.query.error，error:{}", orderMainResponse.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, "tbl_order.find.query.error");
		}
		Response<List<TblOrderHistoryModel>> orderHistoryResponse = orderService.findHistoryByorderMainId(orderMainId);
		if(!orderHistoryResponse.isSuccess()){
			log.error("tblorder_history.find.query.error，error:{}", orderMainResponse.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, "tblorder_history.find.query.error");
		}
		Response<List<OrderBackupModel>> orderBackupResponse = orderService.findBackupByorderMainId(orderMainId);
		if(!orderBackupResponse.isSuccess()){
			log.error("tblorder_backup.find.query.error，error:{}", orderMainResponse.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, "tblorder_backup.find.query.error");
		}
		//将主订单的历史表和备份表数据copy到主订单表的model
		List<OrderMainModel> orderMainModelList = new ArrayList<>();
		OrderMainModel orderMainModelRaw  = orderMainResponse.getResult();//原始主订单model
		if(orderMainModelRaw != null){
			orderMainModelList.add(orderMainModelRaw);
		}
		TblOrdermainHistoryModel tblOrdermainHistoryModel = ordermainHistoryResponse.getResult();//主订单历史表model
		if(tblOrdermainHistoryModel != null){
			OrderMainModel orderMainModelHistory = new OrderMainModel();
			BeanMapper.copy(tblOrdermainHistoryModel,orderMainModelHistory);
			orderMainModelList.add(orderMainModelHistory);
		}
		TblOrderMainBackupModel tblOrderMainBackupModel = orderMainBackupResponse.getResult();///主订单备份表model
		if(tblOrderMainBackupModel != null){
			OrderMainModel orderMainModelBackup = new OrderMainModel();
			BeanMapper.copy(tblOrderMainBackupModel,orderMainModelBackup);
			orderMainModelList.add(orderMainModelBackup);
		}

		//循环主订单list进行组装返回数据
		for(OrderMainModel orderMainModel : orderMainModelList){
			if(orderMainModel != null){
				cCIntergralOrderDetailReturn.setOrderDate(DateHelper.date2string(orderMainModel.getCreateTime(), "yyyyMMdd"));
				cCIntergralOrderDetailReturn.setPostCode(orderMainModel.getCsgPostcode());
				cCIntergralOrderDetailReturn.setCsgProvince(orderMainModel.getCsgProvince());
				cCIntergralOrderDetailReturn.setCsgCity(orderMainModel.getCsgCity());
				cCIntergralOrderDetailReturn.setDeliveryAddr(orderMainModel.getCsgAddress());
				cCIntergralOrderDetailReturn.setDeliveryName(orderMainModel.getCsgName());
				cCIntergralOrderDetailReturn.setDeliveryMobile(orderMainModel.getCsgPhone1());
				cCIntergralOrderDetailReturn.setDeliveryPhone(orderMainModel.getCsgPhone2());
			}
		}

		//将子订单的历史表和备份表数据copy到主订单表的model
		List<OrderSubModel> orderSubModelList = orderSubResponse.getResult();
		//子订单历史表数据copy到orderSubModel
		List<TblOrderHistoryModel> tblOrderHistoryModelList = orderHistoryResponse.getResult();
		for(TblOrderHistoryModel tblOrderHistoryModel : tblOrderHistoryModelList){
			if(tblOrderHistoryModel != null){
				OrderSubModel orderSubModel = new OrderSubModel();
				BeanMapper.copy(tblOrderHistoryModel,orderSubModel);
				orderSubModelList.add(orderSubModel);
			}
		}
		//子订单备份表数据copy到orderSubModel
		List<OrderBackupModel> orderBackupModelList = orderBackupResponse.getResult();
		for(OrderBackupModel orderBackupModel : orderBackupModelList){
			if(orderBackupModel != null){
				OrderSubModel orderSubModel = new OrderSubModel();
				BeanMapper.copy(orderBackupModel,orderSubModel);
				orderSubModelList.add(orderSubModel);
			}
		}
		String loopCount = String.valueOf(orderSubModelList.size());
		cCIntergralOrderDetailReturn.setLoopCount(loopCount);
		//组装需要返回的数据(固定参数)
		cCIntergralOrderDetailReturn.setChannelSN("CCAG");
		cCIntergralOrderDetailReturn.setSuccessCode("01");
		cCIntergralOrderDetailReturn.setReturnCode("000000");
		cCIntergralOrderDetailReturn.setReturnDes("正常");
		cCIntergralOrderDetailReturn.setOrderMainId(orderMainId);
		cCIntergralOrderDetailReturn.setLoopTag("0000");
		cCIntergralOrderDetailReturn.setDoDate("");
		cCIntergralOrderDetailReturn.setTranscorpNm("");
		cCIntergralOrderDetailReturn.setMailingMun("");
		cCIntergralOrderDetailReturn.setServicePhone("");

		//子订单详细信息
		List<CCIntergralOrderDetailChildren> childOrders = new ArrayList<CCIntergralOrderDetailChildren>();
		for(OrderSubModel orderSubModel : orderSubModelList){
			CCIntergralOrderDetailChildren ccIntergralOrderDetailChildren = new CCIntergralOrderDetailChildren();
			ccIntergralOrderDetailChildren.setOrderId(orderSubModel.getOrderId());//子订单号
			ccIntergralOrderDetailChildren.setOrderName(orderSubModel.getCurStatusNm());//订单状态
			ccIntergralOrderDetailChildren.setGoodsName(orderSubModel.getGoodsNm());//商品名称
			ccIntergralOrderDetailChildren.setGoodsNo(orderSubModel.getGoodsNum().toString());//商品数量
			if(orderSubModel.getTotalMoney().doubleValue()>0){
				ccIntergralOrderDetailChildren.setConsumeType("1");//类型：积分+现金
			}else{
				ccIntergralOrderDetailChildren.setConsumeType("0");//类型：纯积分
			}
			String intergralNo = Long.toString(orderSubModel.getSingleBonus());
			ccIntergralOrderDetailChildren.setIntergralNo(intergralNo);//积分值
			ccIntergralOrderDetailChildren.setJfType(orderSubModel.getBonusType());//积分类型编码
			ccIntergralOrderDetailChildren.setJfTypeName(orderSubModel.getBonusTypeNm());//积分类型名称
			String goodsPrice = StringUtil.bigDecimalToString(orderSubModel.getSinglePrice(), 12);//xiewl 20161012
			ccIntergralOrderDetailChildren.setGoodsPrice(goodsPrice);//现金值
			ccIntergralOrderDetailChildren.setVendorFnm(orderSubModel.getVendorSnm());//供应商全称
			//虚拟商品获取其他信息
			Response<List<OrderVirtualModel>> orderVirtualResponse = orderService.findVirtualByOrderId(orderSubModel.getOrderId());
			if(!orderVirtualResponse.isSuccess()){
				log.error("virtual.find.query.error，error:{}", orderMainResponse.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, "virtual.find.query.error");
			}
			List<OrderVirtualModel> orderVirtualModelList = orderVirtualResponse.getResult();
			if(orderVirtualModelList.size() > 0){
				OrderVirtualModel orderVirtualModel = orderVirtualModelList.get(0);
				ccIntergralOrderDetailChildren.setVirtualAllMileage(String.valueOf(orderVirtualModel.getVirtualAllMileage()));//里程
				ccIntergralOrderDetailChildren.setVirtualAllPrice(String.valueOf(orderVirtualModel.getVirtualAllPrice()));//兑换金额
				ccIntergralOrderDetailChildren.setVirtualMemberId(orderVirtualModel.getVirtualMemberId());//会员号
				ccIntergralOrderDetailChildren.setVirtualMemberNm(orderVirtualModel.getVirtualMemberNm());//会员姓名
				ccIntergralOrderDetailChildren.setVAviationType(orderVirtualModel.getVirtualAviationType());//航空类型
			}
			//查询商品表goods表获取礼品类型
			Response<GoodsModel> goodsModelResponse = goodsService.findById(orderSubModel.getGoodsId());
			GoodsModel goodsModel = goodsModelResponse.getResult();
			if(goodsModel != null){
				ccIntergralOrderDetailChildren.setGoodsType(goodsModel.getGoodsType());//礼品类型
			}else{
				ccIntergralOrderDetailChildren.setGoodsType("");
			}

			Response<OrderTransModel> orderTransResponse = orderService.findOrderTrans(orderSubModel.getOrderId());
			if(!orderVirtualResponse.isSuccess()){
				log.error("OrderService.findOrderTrans.error，error:{}", orderMainResponse.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, "OrderService.findOrderTrans.error");
			}
			OrderTransModel orderTransModel = orderTransResponse.getResult();
			if(orderTransModel != null){
				ccIntergralOrderDetailChildren.setDoDate(DateHelper.date2string(orderTransModel.getDoTime(), "yyyyMMdd"));//发货日期
				ccIntergralOrderDetailChildren.setTranscorpNm(orderTransModel.getTranscorpNm());//快递公司
				ccIntergralOrderDetailChildren.setMailingMun(orderTransModel.getMailingNum());//快递单号
				ccIntergralOrderDetailChildren.setServicePhone(orderTransModel.getServicePhone());//快递公司联系电话
			}else{
				ccIntergralOrderDetailChildren.setDoDate("");//发货日期
				ccIntergralOrderDetailChildren.setTranscorpNm("");//快递公司
				ccIntergralOrderDetailChildren.setMailingMun("");//快递单号
				ccIntergralOrderDetailChildren.setServicePhone("");//快递公司联系电话
			}

			childOrders.add(ccIntergralOrderDetailChildren);
		}
		cCIntergralOrderDetailReturn.setChildOrders(childOrders);
		CCIntergralOrderDetailReturnVO cCIntergralOrderDetailReturnVO = BeanUtils.copy(cCIntergralOrderDetailReturn,
				CCIntergralOrderDetailReturnVO.class);
		return cCIntergralOrderDetailReturnVO;
	}

}
