package cn.com.cgbchina.trade.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.trade.dao.OrderGoodsDetailDao;
import cn.com.cgbchina.trade.dao.OrderMainDao;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;

import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.dto.ClearingDto;
import cn.com.cgbchina.trade.dto.ExchangeStatisticsDto;
import cn.com.cgbchina.trade.dto.GoodsDetailBatchDto;
import cn.com.cgbchina.trade.dto.MemberCountBatchDto;
import cn.com.cgbchina.trade.dto.MemberNumDto;
import cn.com.cgbchina.trade.dto.MemberSearchDto;
import cn.com.cgbchina.trade.dto.MemberShopCarDto;
import cn.com.cgbchina.trade.dto.OrderMainBatchDto;
import cn.com.cgbchina.trade.dto.OrderSubBatchDto;
import cn.com.cgbchina.trade.dto.OrderVirtualBatchDto;
import cn.com.cgbchina.trade.dto.SevenDaysInnDto;
import cn.com.cgbchina.trade.dto.VendorExchangeStatDto;
import cn.com.cgbchina.trade.model.OrderGoodsDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.base.Function;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import org.springframework.stereotype.Service;

/**
 * Description : 获取报表数据<br>
 * 日期 : 2016年6月27日<br>
 * 作者 : xiewl<br>
 * 项目 : cgb-trade<br>
 * 功能 : <br>
 */
@Service
@Slf4j
public class ReportServiceImpl implements ReportService {

	@Resource
	private OrderSubDao orderSubDao;
	@Resource
	private OrderMainDao orderMainDao;
	@Resource
	private OrderGoodsDetailDao orderGoodsDetailDao;

	@Override
	public Response<Pager<OrderSubBatchDto>> findStageReqCash(int pageNo, int size, Map<String, Object> params) {
		return null;
	}

	@Override
	public Response<Pager<OrderSubBatchDto>> findStageReturnGoods(int pageNo, int size, Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Response<Pager<OrderSubBatchDto>> findVendorGoodsBack(int pageNo, int size, Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * 商品销售明细报表（广发商城管理平台）<br>
	 * ordersub:已有条件,bonusTrnStartDate 支付时间起始 bonusTrnEndDate 支付时间结束<br>
	 */
	@Override
	public Response<Pager<OrderSubBatchDto>> findGoodsSaleDetail(int pageNo, int size, Map<String, Object> params) {
		// TODO:
		Response<Pager<OrderSubBatchDto>> response = new Response<Pager<OrderSubBatchDto>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		List<String> curStatusIds = Lists.newArrayList();
		curStatusIds.add("0308");
		curStatusIds.add("0309");
		curStatusIds.add("0306");
		curStatusIds.add("0310");
		curStatusIds.add("0312");
		curStatusIds.add("0334");
		curStatusIds.add("0327");
		curStatusIds.add("0335");
		curStatusIds.add("0380");
		curStatusIds.add("0381");
		params.put("curStatusIds", curStatusIds);
		List<String> ordertypeIds = Lists.newArrayList();
		ordertypeIds.add("YG");
		ordertypeIds.add("JF");
		params.put("ordertypeIds", ordertypeIds);
		// orderSub
		Pager<OrderSubModel> ordersubPager = orderSubDao.findLikeByPage(params, pageInfo.getOffset(),
				pageInfo.getLimit());
		List<OrderSubModel> orderSubModels = ordersubPager.getData();
		List<OrderSubBatchDto> orderSubBatchDtos = Lists.newArrayList();
		BeanUtils.copyProperties(orderSubModels, orderSubBatchDtos);
		List<String> ordermainIds = Lists.transform(orderSubModels, new Function<OrderSubModel, String>() {
			@Override
			public String apply(OrderSubModel model) {
				return model.getOrdermainId();
			}
		});
		// orderMain
		Map<String, Object> orderMainParams = Maps.newHashMap();
		orderMainParams.put("ordermainIds", ordermainIds);
		List<OrderMainModel> orderMainModels = orderMainDao.findByOrderMainIds(orderMainParams);
		for (OrderSubBatchDto orderSubBatchDto : orderSubBatchDtos) {
			for (OrderMainModel orderMainModel : orderMainModels) {
				if (orderSubBatchDto.getOrdermainId().equals(orderMainModel.getOrdermainId())) {
					BeanUtils.copyProperties(orderMainModel, orderSubBatchDto);
					break;
				}
			}
		}
		Pager<OrderSubBatchDto> orderSubBatchPager = new Pager<OrderSubBatchDto>(ordersubPager.getTotal(),
				orderSubBatchDtos);
		response.setResult(orderSubBatchPager);
		return response;
	}

	@Override
	public Response<Pager<OrderSubBatchDto>> findVendorSaleDetail(int pageNo, int size, Map<String, Object> params) {
		Response<Pager<OrderSubBatchDto>> response = new Response<Pager<OrderSubBatchDto>>();
		List<OrderSubBatchDto> orderSubBatchDtos = Lists.newArrayList();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		List<String> curStatusIds = Lists.newArrayList();
		curStatusIds.add(Contants.SUB_ORDER_STATUS_0301);
		curStatusIds.add(Contants.SUB_ORDER_STATUS_0316);
		curStatusIds.add(Contants.SUB_ORDER_STATUS_0307);
		curStatusIds.add(Contants.SUB_ORDER_STATUS_0305);
		curStatusIds.add(Contants.SUB_ORDER_STATUS_0304);
		params.put("curStatusIds1", curStatusIds);
		List<String> ordertypeIds = Lists.newArrayList();
		ordertypeIds.add(Contants.BUSINESS_TYPE_YG);
		ordertypeIds.add(Contants.BUSINESS_TYPE_FQ);
		params.put("ordertypeIds", ordertypeIds);
		Pager<OrderSubModel> orderSubPager = orderSubDao.findLikeByPage(params, pageInfo.getOffset(), pageInfo.getLimit());
		Long total = orderSubPager.getTotal();
		List<OrderSubModel> orderSubModels = orderSubPager.getData();
		for(OrderSubModel orderSubModel : orderSubModels){
			OrderSubBatchDto orderSubBatchDto = new OrderSubBatchDto();
			orderSubBatchDto.setOrderId(orderSubModel.getOrderId());
			orderSubBatchDto.setOrdermainId(orderSubModel.getOrdermainId());
			orderSubBatchDto.setGoodsNum(orderSubModel.getGoodsNum());
			orderSubBatchDto.setSinglePrice(orderSubModel.getSinglePrice());
			orderSubBatchDto.setVendorSnm(orderSubModel.getVendorSnm());
			orderSubBatchDto.setCurStatusId(orderSubModel.getCurStatusId());
			orderSubBatchDto.setCurStatusNm(orderSubModel.getCurStatusNm());
			orderSubBatchDto.setSourceNm(orderSubModel.getSourceNm());
			orderSubBatchDto.setVoucherNo(orderSubModel.getVoucherNo());
			orderSubBatchDto.setVouvherNm(orderSubModel.getVoucherNm());
			orderSubBatchDto.setVoucherPrice(orderSubModel.getVoucherPrice());
			orderSubBatchDto.setBonusTotalValue(orderSubModel.getBonusTotalvalue());
			orderSubBatchDto.setBonusPrice(orderSubModel.getBonusPrice());
			
			//取主订单信息
			OrderMainModel orderMainModel = orderMainDao.findById(orderSubModel.getOrdermainId());
			OrderMainBatchDto orderMainBatchDto = new OrderMainBatchDto();
			orderMainBatchDto.setPdtNbr(orderMainModel.getPdtNbr());
			String cardNo = orderMainModel.getCardno();
			if(cardNo != null && cardNo.length() > 4){
				cardNo = cardNo.substring(cardNo.length() - 4);
			}
			orderMainBatchDto.setCardNo(cardNo);
			orderSubBatchDto.setOrderMainBatchDto(orderMainBatchDto);
			
			//取订单商品详情信息
			Map<String, Object> goodsParam = Maps.newHashMap();
			goodsParam.put("orderNo", orderSubModel.getOrderId());
			OrderGoodsDetailModel orderGoodsDetailModel = orderGoodsDetailDao.findByOrderId(params);
			GoodsDetailBatchDto goodsDetailBatchDto = new GoodsDetailBatchDto();
			goodsDetailBatchDto.setGoodsCode(orderGoodsDetailModel.getGoodsCode());
			goodsDetailBatchDto.setGoodsNm(orderGoodsDetailModel.getGoodsName());
			goodsDetailBatchDto.setBackCategory1Id(orderGoodsDetailModel.getBackCategory1Id());
			goodsDetailBatchDto.setBackCategory2Id(orderGoodsDetailModel.getBackCategory2Id());
			goodsDetailBatchDto.setBackCategory3Id(orderGoodsDetailModel.getBackCategory3Id());
			goodsDetailBatchDto.setMailOrderCode(orderGoodsDetailModel.getMailOrderCode());
			orderSubBatchDto.setGoodsDetailBatchDto(goodsDetailBatchDto);
			
			orderSubBatchDtos.add(orderSubBatchDto);
		}
		Pager<OrderSubBatchDto> orderSubBatchPager = new Pager<OrderSubBatchDto>(total, orderSubBatchDtos);
		response.setResult(orderSubBatchPager);
		return response;
	}

	@Override
	public Response<Pager<OrderSubBatchDto>> findCommonGiftSale(int pageNo, int size, Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Response<Pager<OrderSubBatchDto>> findGoodBack(int pageNo, int size, Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Response<List<ClearingDto>> findClearingDetail(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Response<List<ExchangeStatisticsDto>> findExchangeStatistics(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Response<Pager<SevenDaysInnDto>> findSevenDaysInnDtos(int pageNo, int size, Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Response<List<OrderSubBatchDto>> findVendorSaleStatistics(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Response<Pager<OrderSubBatchDto>> findVendorSellDetail(int pageNo, int size, Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Response<List<MemberNumDto>> findMemberNumModel(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Response<List<VendorExchangeStatDto>> findVendorExchangeStat(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Response<Pager<OrderSubBatchDto>> findCreditCardReqMoney(int pageNo, int size, Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Response<Pager<OrderVirtualBatchDto>> findJFOrderByGoodsIds(int pageNo, int pageSize,
			Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Response<List<OrderVirtualBatchDto>> findJFOrderOfDayByGoodsIds(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Response<List<MemberSearchDto>> findMemberSearchRecord(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Response<List<MemberShopCarDto>> findMemberShopCarModel(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Response<List<MemberCountBatchDto>> findMemberGoodsFavorite(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Response<List<MemberCountBatchDto>> findMemberBrowseHistory(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

}
