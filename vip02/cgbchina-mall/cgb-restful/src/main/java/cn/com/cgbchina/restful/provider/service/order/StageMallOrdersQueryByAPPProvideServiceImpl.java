package cn.com.cgbchina.restful.provider.service.order;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrdersQueryByAPP;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrdersInfoByAPPVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrdersQueryByAPPReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrdersQueryByAPPVO;
import cn.com.cgbchina.trade.dto.OrderQueryDto;
import cn.com.cgbchina.trade.service.OrderQueryService;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

/**
 * MAL308 订单查询(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL308")
@Slf4j
public class StageMallOrdersQueryByAPPProvideServiceImpl implements
		SoapProvideService<StageMallOrdersQueryByAPPVO, StageMallOrdersQueryByAPPReturnVO> {
	@Resource
	OrderQueryService orderQueryService;

	@Override
	public StageMallOrdersQueryByAPPReturnVO process(SoapModel<StageMallOrdersQueryByAPPVO> model,
			StageMallOrdersQueryByAPPVO content) {
		// 入参
		StageMallOrdersQueryByAPP stageMallOrdersQueryByAPP = BeanUtils.copy(content, StageMallOrdersQueryByAPP.class);
		// StageMallOrdersQueryByAPPReturn stageMallOrdersQueryByAPPReturn =
		// stageMallOrdersQueryByAPPService.query(stageMallOrdersQueryByAPP);
		// // 出参
		// StageMallOrdersQueryByAPPReturnVO stageMallOrdersQueryByAPPReturnVO =
		// BeanUtils.copy(stageMallOrdersQueryByAPPReturn,
		// StageMallOrdersQueryByAPPReturnVO.class);
		StageMallOrdersQueryByAPPReturnVO stageMallOrdersQueryByAPPReturnVO = new StageMallOrdersQueryByAPPReturnVO();
		// 接受参数
		String origin = stageMallOrdersQueryByAPP.getOrigin(); // 发起方
		String cust_id = stageMallOrdersQueryByAPP.getCustId(); // 客户编号（微信送的是证件号）
		
		String rowsPage = stageMallOrdersQueryByAPP.getRowsPage(); // 页面大小
		String currentPage = stageMallOrdersQueryByAPP.getCurrentPage(); // 当前页
		String cur_status_id = stageMallOrdersQueryByAPP.getCurStatusId(); // 当前订单状态
		String pay_on = stageMallOrdersQueryByAPP.getPayOn(); // 是否可继续支付(广发微信商城需求增加) 1-是，0-否（待支付查询时送1）
		String orderType = stageMallOrdersQueryByAPP.getOrderType(); // 20151009
																		// APP需求增加“业务类型”
																		// 空或00-所有，01-一期，02-分期
																		// ，03-积分
		String curStatusIds = stageMallOrdersQueryByAPP.getCurStatusIds(); // 20151009APP需求增加“当前订单状态集”
		log.info("cur_status_id  ====: " + cur_status_id);
		log.info("cust_id  ====: " + cust_id);
		log.info("origin  ====: " + origin);
		// 校验参数
		if ("0000".equals(cur_status_id) && ("".equals(curStatusIds) || curStatusIds == null)) {
			stageMallOrdersQueryByAPPReturnVO.setReturnCode("000008");
			stageMallOrdersQueryByAPPReturnVO.setReturnDes("当cur_status_id=0000时，cur_status_ids必填");
			return stageMallOrdersQueryByAPPReturnVO;
		}
		// 页面大小
		int rowsPageInt = 1;
		int currentPageInt = 1;
		if (rowsPage != null && !"".equals(rowsPage)) {
			rowsPageInt = Integer.parseInt(rowsPage);
		}
		if (currentPage != null && !"".equals(currentPage)) {
			currentPageInt = Integer.parseInt(currentPage);
		}
		 boolean WXFlag = false;
		Response<Pager<OrderQueryDto>> resultResponse = new Response<Pager<OrderQueryDto>>();
		try {
		    //数迁后由于根据证件号获取了多个客户号 所以将查询订单 改为用多个客户号进行查询
		    List<String>custIds=new ArrayList<>();
		    custIds.add(cust_id);
			// 微信渠道
			if (Contants.CHANNEL_SN_WX.equals(origin) || Contants.CHANNEL_SN_WS.equals(origin)
					|| Contants.CHANNEL_SN_YX.equals(origin) || Contants.CHANNEL_SN_YS.equals(origin)) {
				 WXFlag = true;
			    	//微信渠道需要将 证件号转换为客户号
			    	Response<List<String>> custIdResponse=orderQueryService.findCreteOperByCertNo(cust_id);
			    	if(custIdResponse.isSuccess()){
			    	custIds=custIdResponse.getResult();
			    	}
			    
				resultResponse = orderQueryService
						.findByWx(currentPageInt, rowsPageInt, custIds, cur_status_id, pay_on);
				// APP渠道
			} else if (Contants.SOURCE_ID_APP.equals(origin)) {
				resultResponse = orderQueryService.findByApp(currentPageInt, rowsPageInt, custIds, cur_status_id,
						pay_on, orderType, curStatusIds);
				// 手机渠道
			} else {
				resultResponse = orderQueryService.find(currentPageInt, rowsPageInt, custIds, cur_status_id);
			}

			if (!resultResponse.isSuccess()) {// 出错
				throw new RuntimeException(resultResponse.getError());
			}
			// 获取总的条数
			Long totalCount = 0L;
			if (resultResponse.getResult() != null) {
				totalCount = resultResponse.getResult().getTotal();
			}
			// 获取总的分页数
			Long totalPages = 0L;
			if (totalCount % rowsPageInt > 0) {
				totalPages = totalCount / rowsPageInt + 1;
			} else {
				totalPages = totalCount / rowsPageInt;
			}
			stageMallOrdersQueryByAPPReturnVO.setTotalPages(totalPages.toString());
			stageMallOrdersQueryByAPPReturnVO.setTotalCount(totalCount.toString());
			List<OrderQueryDto> list=null;
			if (resultResponse.getResult() != null && resultResponse.getResult() != null
					&& resultResponse.getResult().getData().size() > 0
					&& resultResponse.getResult().getData().get(0) != null) {
				stageMallOrdersQueryByAPPReturnVO.setMainmerId(resultResponse.getResult().getData().get(0)
						.getOrdermainId());
				list = resultResponse.getResult().getData();
				// 封装List
				stageMallOrdersQueryByAPPReturnVO.setStageMallOrdersInfos(processListData(list));
			}
			if(WXFlag){//微信渠道
				if (list != null && list.size() > 0){
					List<OrderQueryDto> subOrderNumList = null;
					if(Contants.PAY_ON_NO.equals(pay_on)){//查询全部状态订单，先获取大订单下的小订单(待付款)数量用于判断订单是否可继续支付
						List<String> orderMainIds=new ArrayList<>();
						for(int i=0;i<list.size();i++){
							OrderQueryDto orderDto = list.get(i);
							if(Contants.SUB_ORDER_STATUS_0301.equals(orderDto.getCurStatusId())){
								orderMainIds.add(orderDto.getOrdermainId());
							}
						}
						//***********用来过滤那种一个大订单下好多个小订单的订单*******************
						if(orderMainIds.size()>0){
							//查询大订单下的小订单(待付款)数量  
							Response<List<OrderQueryDto>> response = orderQueryService.findSubOrderNum(orderMainIds);
							if(!response.isSuccess()){
								log.error(model.getSenderSN()+"|"+response.getError()+"|"+JsonMapper.nonDefaultMapper().toJson(orderMainIds));
							}else{
								subOrderNumList = response.getResult();
							}
							//把子订单数大于1的给改成不可支付。
							for(StageMallOrdersInfoByAPPVO vo :stageMallOrdersQueryByAPPReturnVO.getStageMallOrdersInfos()){
								if(Contants.PAY_ON_YES.equals(vo.getPayOn())){
									for(OrderQueryDto dto:subOrderNumList){
										if(dto.getOrdermainId().equals(vo.getOrdermainId())){
											if(dto.getSubOrderNum()>1|| StringUtils.isEmpty(vo.getCardNo())){
												vo.setPayOn(Contants.PAY_ON_NO);
											}
										}
									}
								}
							}
						}
					}
				}
			}
		} catch (Exception e) {
			log.error(e.getMessage(),e);
			stageMallOrdersQueryByAPPReturnVO.setReturnCode("000009");
			stageMallOrdersQueryByAPPReturnVO.setReturnDes("订单查询发生异常");
			return stageMallOrdersQueryByAPPReturnVO;
		}
		stageMallOrdersQueryByAPPReturnVO.setReturnCode("000000");
		stageMallOrdersQueryByAPPReturnVO.setReturnDes("成功");
		return stageMallOrdersQueryByAPPReturnVO;
	}

	private List<StageMallOrdersInfoByAPPVO> processListData(List list) {
		List<StageMallOrdersInfoByAPPVO> stageMallOrdersInfos = new ArrayList<StageMallOrdersInfoByAPPVO>();
		for (int i = 0; i < list.size(); i++) {
			StageMallOrdersInfoByAPPVO vo = new StageMallOrdersInfoByAPPVO();
			OrderQueryDto orderQueryDto = (OrderQueryDto) list.get(i);
			// 订单类型 ordertype_id
			vo.setOrdertypeId(dealNull(orderQueryDto.getOrdertypeId()));
			// 订单编号 order_id
			vo.setOrderId(dealNull(orderQueryDto.getOrderId()));
			// 分期数 stages_num
			vo.setStagesNum(orderQueryDto.getStagesNum() == null ? "" : orderQueryDto.getStagesNum().toString());
			// 总金额金额 single_price
			vo.setSinglePrice(orderQueryDto.getSinglePrice() == null ? "" : orderQueryDto.getSinglePrice().toString());
			// 分期金额 per_stage
			vo.setPerStage(orderQueryDto.getPer_Stage() == null ? "" : orderQueryDto.getPer_Stage().toString());
			// 积分类型 jf_type
			vo.setJfType(dealNull(orderQueryDto.getIntegraltypeId()));
			// 单个积分值 single_point
			vo.setSinglePoint(orderQueryDto.getSingleBonus() == null ? "" : orderQueryDto.getSingleBonus().toString());
			// 总积分值 total_point
			vo.setTotalPoint(orderQueryDto.getBonusTotalvalue() == null ? "" : orderQueryDto.getBonusTotalvalue()
					.toString());
			// 现金 goods_price
			vo.setGoodsPrice(orderQueryDto.getGoods_Price() == null ? "" : orderQueryDto.getGoods_Price().toString());
			// 下单日期 create_date
			// vo.setCreateDate(orderQueryDto.getModify_Date());
			vo.setCreateDate(DateHelper.getyyyyMMdd(orderQueryDto.getCreateTime()));
			// 订单状态 cur_status_id
			vo.setCurStatusId(dealNull(orderQueryDto.getCurStatusId()));
			// 发货状态 goodssend_flag
			vo.setGoodssendFlag(dealNull(orderQueryDto.getGoodssendFlag()));
			// 商品名称 goods_nm
			vo.setGoodsNm(dealNull(orderQueryDto.getGoodsNm()));
			// 图片URL picture_url
			vo.setPictureUrl(dealNull(orderQueryDto.getGoods_Picture1()));
			// 是否可继续支付 pay_on 0301 - cur_Status_Id
			String payOn = "0";
			if ("0301".equals(orderQueryDto.getCurStatusId()))
				payOn = "1";
			vo.setPayOn(payOn);
			// 市场价 market_price
			if (orderQueryDto.getMarketPrice() == null) {
				vo.setMarketPrice("0");
			} else {
				vo.setMarketPrice(orderQueryDto.getMarketPrice().toString());
			}
			// 属性一 goods_attr1
			vo.setGoodsAttr1(dealNull(orderQueryDto.getGoodsAttr1()));
			// 属性值一 goods_color
			vo.setGoodsColor(dealNull(orderQueryDto.getGoodsColor()));
			// 属性二 goods_attr2
			vo.setGoodsAttr2(dealNull(orderQueryDto.getGoodsAttr2()));
			// 属性值二 GOODS_MODEL
			vo.setGoodsModel(dealNull(orderQueryDto.getGoodsModel()));
			// 购买数量 GOODS_NUM
			vo.setGoodsNum(orderQueryDto.getGoodsNum() == null ? "" : orderQueryDto.getGoodsNum().toString());
			// 订单渠道 SOURCE_ID
			vo.setSourceId(dealNull(orderQueryDto.getSourceId()));
			// 物流配送号 mailing_num
			vo.setMailingNum(dealNull(orderQueryDto.getMailing_num()));
			// 积分流水 tradeSeqNo
			vo.setTradeSeqNo(dealNull(orderQueryDto.getOrderIdHost()));
			// 优惠券编号 privilegeId
			vo.setPrivilegeId(dealNull(orderQueryDto.getVoucherNo()));
			// 小商户号 mer_id
			vo.setMerId(dealNull(orderQueryDto.getMerId()));
			// 积分抵扣金额 discountPrivMon
			if (orderQueryDto.getBonusPrice() == null) {
				vo.setDiscountPrivMon("");
			} else {
				vo.setDiscountPrivMon(orderQueryDto.getBonusPrice().toString());
			}
			// 下单时间 create_time
			// vo.setCreateTime(orderQueryDto.getModify_Time());
			vo.setCreateTime(DateHelper.getHHmmss(orderQueryDto.getCreateTime()));

			// 大订单号 ordermain_id
			vo.setOrdermainId(dealNull(orderQueryDto.getOrdermainId()));
			// 卡号 cardno
			vo.setCardNo(dealNull(orderQueryDto.getCardno()));
			vo.setCardType(dealNull(orderQueryDto.getCardtype()));
			// 卡片类型 cardtype
			String receivedTime = "";
			if (orderQueryDto.getReceivedTime() != null) {
				SimpleDateFormat sdf_ = new SimpleDateFormat("YYYYMMddHHmmss");
				receivedTime = sdf_.format(orderQueryDto.getReceivedTime());
			}
			vo.setReceivedTime(receivedTime);
			// 订单签收时间 RECEIVED_TIME
			stageMallOrdersInfos.add(vo);
		}

		return stageMallOrdersInfos;

	}

	private String dealNull(String input) {
		return input == null ? "" : input;
	}
}
