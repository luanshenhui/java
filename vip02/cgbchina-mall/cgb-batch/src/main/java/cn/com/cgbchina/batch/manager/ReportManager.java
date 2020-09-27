package cn.com.cgbchina.batch.manager;

import java.lang.reflect.Method;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Nullable;
import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import cn.com.cgbchina.batch.dao.BatchReportRegDao;
import cn.com.cgbchina.batch.dao.CartAddCountDao;
import cn.com.cgbchina.batch.dao.ReportDao;
import cn.com.cgbchina.batch.dto.CartAddCountDto;
import cn.com.cgbchina.batch.dto.ClearingDto;
import cn.com.cgbchina.batch.dto.ExchangeStatisticsDto;
import cn.com.cgbchina.batch.dto.IntegralExchangeDto;
import cn.com.cgbchina.batch.dto.MemberNumDto;
import cn.com.cgbchina.batch.dto.MemberSearchDto;
import cn.com.cgbchina.batch.dto.OrderBatchDto;
import cn.com.cgbchina.batch.dto.VendorExchangeStatDto;
import cn.com.cgbchina.batch.model.IntegralExchangeModel;
import cn.com.cgbchina.batch.model.OrderBatchModel;
import cn.com.cgbchina.batch.model.QueryParams;
import cn.com.cgbchina.batch.model.ReportModel;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.dto.MemberCountBatchDto;
import cn.com.cgbchina.related.dto.MemberSearchKeyWordDto;
import cn.com.cgbchina.related.service.KeywordSearchService;
import cn.com.cgbchina.rest.common.utils.BeanUtils;

import com.google.common.base.Function;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Ordering;
import com.spirit.category.model.BackCategory;
import com.spirit.category.model.Spu;
import com.spirit.category.service.BackCategoryHierarchy;
import com.spirit.category.service.SpuService;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.search.Pair;

/**
 * 
 * 日期 : 2016年7月14日<br>
 * 作者 : Administrator<br>
 * 项目 : cgb-related<br>
 * 功能 : 报表文件记录<br>
 */
@Component
@Slf4j
public class ReportManager {
	@Autowired
	private BatchReportRegDao reportRegDao;
	@Resource
	private ReportDao reportDao;
	@Resource
	private KeywordSearchService keywordSearchService;
	@Autowired
	private CartAddCountDao cartAddCountDao;
	@Autowired
    private SpuService spuService;
	@Autowired
    private BackCategoryHierarchy backCategoryHierarchy;
	private Map<Long, List<Pair>> backCategories;
	@Autowired
	private ReportSubManager reportSubManager;
	/**
	 * 
	 * Description : 更新或添加数据
	 * 
	 * @param reportModel
	 * @return
	 */
	public Integer insertOrUpdateReportReg(ReportModel reportModel) {
		List<ReportModel> reportModels = reportRegDao.findByCodeAndDate(reportModel);
		if (reportModels == null || reportModels.isEmpty()) {
			return reportSubManager.insert(reportModel);
		}

		String vendorId = reportModel.getVendorId();
		if (Strings.isNullOrEmpty(vendorId)) {// 对供应商的特殊处理
			boolean hasRecord = false;
			for (ReportModel model : reportModels) {
				if (Strings.isNullOrEmpty(model.getVendorId())) {
					hasRecord = true;
					break;
				}
			}
			if (!hasRecord) {
				return reportSubManager.insert(reportModel);
			}
		}

		// 更新数据
		ReportModel existReportModel = reportModels.get(0);
		existReportModel.setReportNm(reportModel.getReportNm());
		existReportModel.setReportTime(reportModel.getReportTime());
		existReportModel.setReportPath(reportModel.getReportPath());
		existReportModel.setOrdertypeId(reportModel.getOrdertypeId());
		existReportModel.setReportRecNum(reportModel.getReportRecNum());
		existReportModel.setVendorId(reportModel.getVendorId());
		existReportModel.setReportDesc(reportModel.getReportDesc());
		existReportModel.setAirlineType(reportModel.getAirlineType());
		return reportSubManager.update(existReportModel);
	}

	public Response<Integer> insertReportReg(ReportModel reportModel) {
		Response<Integer> response = new Response<Integer>();
		try {
			Integer result = insertOrUpdateReportReg(reportModel);
			if (result == null || result <= 0) {
				response.setError("ReportRegServiceImpl.insertReportReg.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (Exception e) {
			log.error("ReportManager.insertReportReg.error,error code{}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.insertReportReg.error");
			return response;
		}
	}

	/**
	 * 根据业务时间获取分期请款(广发商城)
	 * 
	 * @author xiewl
	 * @param queryParams 业务起始时间
	 * @return
	 */
	public Response<Pager<OrderBatchDto>> findStageReqCash(QueryParams queryParams) {
		Response<Pager<OrderBatchDto>> response = new Response<Pager<OrderBatchDto>>();
		try {
			Pager<OrderBatchDto> pager = new Pager<OrderBatchDto>();
			Pager<OrderBatchModel> orderBatchPager = reportDao.findStageReqCash(queryParams);
			List<OrderBatchDto> orderBatchDtos = Lists.newArrayList();
			List<OrderBatchModel> orderBatchModels = orderBatchPager.getData();
			orderBatchDtos = BeanUtils.copyList(orderBatchModels, OrderBatchDto.class);
			pager.setData(orderBatchDtos);
			pager.setTotal(orderBatchPager.getTotal());
			response.setResult(pager);
			return response;
		} catch (Exception e) {
			log.error("ReportManager.findStageReqCash.error: {}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findStageReqCash.error");
			return response;
		}
	}

	/**
	 * 根据业务时间获取分期退货统计信息(广发商城)
	 * 
	 * @author xiewl
	 * @param queryParams
	 * @return
	 */
	public Response<Pager<OrderBatchDto>> findStageReturnGoods(QueryParams queryParams) {
		Response<Pager<OrderBatchDto>> response = new Response<Pager<OrderBatchDto>>();
		try {
			Pager<OrderBatchDto> pager = new Pager<OrderBatchDto>();
			Pager<OrderBatchModel> orderBatchPager = reportDao.findStageReturnGoods(queryParams);
			List<OrderBatchDto> orderBatchDtos = Lists.newArrayList();
			List<OrderBatchModel> orderBatchModels = orderBatchPager.getData();
			convertBackgoriesNames(orderBatchModels);
			orderBatchDtos = BeanUtils.copyList(orderBatchModels, OrderBatchDto.class);
			pager.setData(orderBatchDtos);
			pager.setTotal(orderBatchPager.getTotal());
			response.setResult(pager);
			return response;
		} catch (Exception e) {
			log.error("ReportManager.findStageReturnGoods.error: {}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findStageReturnGoods.error");
			return response;
		}
	}

	/**
	 * 根据业务时间获取商户退货详细(供应商平台)
	 * 
	 * @author xiewl
	 * @param queryParams
	 * @return
	 */
	public Response<Pager<OrderBatchDto>> findVendorGoodsBack(QueryParams queryParams) {
		Response<Pager<OrderBatchDto>> response = new Response<Pager<OrderBatchDto>>();
		try {

			Pager<OrderBatchDto> pager = new Pager<OrderBatchDto>();
			Pager<OrderBatchModel> orderBatchPager = reportDao.findVendorGoodsBack(queryParams);
			orderBatchPager = convertCardType(orderBatchPager);
			List<OrderBatchDto> orderBatchDtos = Lists.newArrayList();
			List<OrderBatchModel> orderBatchModels = orderBatchPager.getData();
			convertBackgoriesNames(orderBatchModels);
			orderBatchDtos = BeanUtils.copyList(orderBatchModels, OrderBatchDto.class);
			pager.setData(orderBatchDtos);
			pager.setTotal(orderBatchPager.getTotal());
			response.setResult(pager);
			return response;
		} catch (Exception e) {
			log.error("ReportManager.findVendorGoodsBack.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findVendorGoodsBack.error");
			return response;
		}
	}

	/**
	 * 获取指定时间段商品销售明细(广发商城)
	 * 
	 * @author xiewl
	 * @param queryParams
	 * @return
	 */
	public Response<Pager<OrderBatchDto>> findGoodsSaleDetail(QueryParams queryParams) {
		Response<Pager<OrderBatchDto>> response = new Response<Pager<OrderBatchDto>>();
		try {
			Pager<OrderBatchDto> pager = new Pager<OrderBatchDto>();
			Pager<OrderBatchModel> orderBatchPager = reportDao.findGoodsSaleDetail(queryParams);
			List<OrderBatchDto> orderBatchDtos = Lists.newArrayList();
			List<OrderBatchModel> orderBatchModels = orderBatchPager.getData();
			convertBackgoriesNames(orderBatchModels);
			orderBatchDtos = BeanUtils.copyList(orderBatchModels, OrderBatchDto.class);
			pager.setData(orderBatchDtos);
			pager.setTotal(orderBatchPager.getTotal());
			response.setResult(pager);
			return response;
		} catch (Exception e) {
			log.error("ReportManager.findGoodsSaleDetail.error: {}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findGoodsSaleDetail.error");
			return response;
		}

	}

	/**
	 * Description : 获取指定时间段商户销售明细(广发商城)
	 * 
	 * @author Huangcy
	 * @param queryParams 查询参数(日期精确到天) : 1)startDate 开始日期; 2)endDate 结束日期
	 * @return
	 */
	public Response<Pager<OrderBatchDto>> findVendorSaleDetail(QueryParams queryParams) {
		Response<Pager<OrderBatchDto>> response = new Response<Pager<OrderBatchDto>>();
		try {
			Pager<OrderBatchModel> orderBatchModelPager = reportDao.findVendorSaleDetail(queryParams);
			List<OrderBatchModel> orderBatchModels = orderBatchModelPager.getData();
			convertBackgoriesNames(orderBatchModels);
			List<OrderBatchDto> orderBatchDtos = BeanUtils.copyList(orderBatchModels, OrderBatchDto.class);
			Pager<OrderBatchDto> orderBatchDtoPager = new Pager<OrderBatchDto>(orderBatchModelPager.getTotal(),
					orderBatchDtos);
			response.setResult(orderBatchDtoPager);
			return response;
		} catch (Exception e) {
			log.error("ReportManager.findVendorSaleDetail.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findVendorSaleDetail.error");
			return response;
		}
	}

	/**
	 * 获取指定时间段普通礼品销售明细(积分商城)
	 * 
	 * @author xiewl
	 * @param queryParams
	 * @return
	 */
	public Response<Pager<OrderBatchDto>> findCommonGiftSale(QueryParams queryParams) {
		Response<Pager<OrderBatchDto>> response = new Response<Pager<OrderBatchDto>>();
		try {
			Pager<OrderBatchDto> pager = new Pager<OrderBatchDto>();
			Pager<OrderBatchModel> orderBatchPager = reportDao.findCommonGiftSale(queryParams);
			List<OrderBatchDto> orderBatchDtos = Lists.newArrayList();
			List<OrderBatchModel> orderBatchModels = orderBatchPager.getData();
			convertBackgoriesNames(orderBatchModels);
			orderBatchDtos = BeanUtils.copyList(orderBatchModels, OrderBatchDto.class);
			pager.setData(orderBatchDtos);
			pager.setTotal(orderBatchPager.getTotal());
			response.setResult(pager);
			return response;
		} catch (Exception e) {
			log.error("ReportManager.findCommonGiftSale.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findCommonGiftSale.error");
			return response;
		}
	}

	/**
	 * 获取指定时间段退货详细(积分商城)
	 * 
	 * @author xiewl
	 * @param queryParams
	 * @return
	 */
	public Response<Pager<OrderBatchDto>> findGoodBack(QueryParams queryParams) {
		Response<Pager<OrderBatchDto>> response = new Response<Pager<OrderBatchDto>>();
		try {
			Pager<OrderBatchDto> pager = new Pager<OrderBatchDto>();
			Pager<OrderBatchModel> orderBatchPager = reportDao.findGoodBack(queryParams);
			List<OrderBatchDto> orderBatchDtos = Lists.newArrayList();
			List<OrderBatchModel> orderBatchModels = orderBatchPager.getData();
			convertBackgoriesNames(orderBatchModels);
			orderBatchDtos = BeanUtils.copyList(orderBatchModels, OrderBatchDto.class);
			pager.setData(orderBatchDtos);
			pager.setTotal(orderBatchPager.getTotal());
			response.setResult(pager);
			return response;
		} catch (Exception e) {
			log.error("ReportManager.findGoodBack.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findGoodBack.error");
			return response;
		}
	}

	/**
	 * 获取指定时间段结算详细(积分商城)
	 * 
	 * @author xiewl
	 * @param queryParams
	 * @return
	 */
	public Response<List<ClearingDto>> findClearingDetail(QueryParams queryParams) {
		Response<List<ClearingDto>> response = new Response<List<ClearingDto>>();
		try {
			List<OrderBatchModel> orderBatchModels = reportDao.findClearingDetail(queryParams);
			List<ClearingDto> clearingDtos = Lists.newArrayList();
			clearingDtos = BeanUtils.copyList(orderBatchModels, ClearingDto.class);
			response.setResult(clearingDtos);
			return response;
		} catch (Exception e) {
			log.error("ReportManager.findClearingDetail.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findClearingDetail.error");
			return response;
		}
	}

	/**
	 * 获取指定时间段兑换统计细节(积分商城)
	 * 
	 * @author xiewl
	 * @param queryParams
	 * @return
	 */
	public Response<List<ExchangeStatisticsDto>> findExchangeStatistics(QueryParams queryParams) {
		Response<List<ExchangeStatisticsDto>> response = new Response<List<ExchangeStatisticsDto>>();
		try {
			List<OrderBatchModel> orderBatchModels = reportDao.findExchangeStatistics(queryParams);
			convertBackgoriesNames(orderBatchModels);
			List<ExchangeStatisticsDto> exchangeStatisticsDtos = Lists.newArrayList();
			exchangeStatisticsDtos = BeanUtils.copyList(orderBatchModels, ExchangeStatisticsDto.class);
			response.setResult(exchangeStatisticsDtos);
			return response;
		} catch (Exception e) {
			log.error("ReportManager.findExchangeStatistics.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findExchangeStatistics.error");
			return response;
		}
	}

	/**
	 * 根据时间段获取商户销售统计报表数据(广发商城)
	 * 
	 * @author xiewl
	 * @param queryParams
	 * @return
	 */
	public Response<List<OrderBatchDto>> findVendorSaleStatistics(QueryParams queryParams) {
		Response<List<OrderBatchDto>> response = new Response<List<OrderBatchDto>>();
		try {
			List<OrderBatchModel> orderBatchModels = reportDao.findVendorSaleStatistics(queryParams);
			List<OrderBatchDto> orderBatchDtos = Lists.newArrayList();
			orderBatchDtos = BeanUtils.copyList(orderBatchModels, OrderBatchDto.class);
			response.setResult(orderBatchDtos);
			return response;
		} catch (Exception e) {
			log.error("ReportManager.findVendorSaleStatistics.error:{}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findVendorSaleStatistics.error");
			return response;
		}

	}

	/**
	 * 根据时间段获取商户销售明细报表(供应商平台)
	 * 
	 * @author xiewl
	 * @param queryParams
	 * @return
	 */
	public Response<Pager<OrderBatchDto>> findVendorSellDetail(QueryParams queryParams) {
		Response<Pager<OrderBatchDto>> response = new Response<Pager<OrderBatchDto>>();
		try {
			Pager<OrderBatchDto> pager = new Pager<OrderBatchDto>();
			Pager<OrderBatchModel> orderBatchPager = reportDao.findVendorSellDetail(queryParams);
			orderBatchPager = convertCardType(orderBatchPager);
			List<OrderBatchDto> orderBatchDtos = Lists.newArrayList();
			List<OrderBatchModel> orderBatchModels = orderBatchPager.getData();
			convertBackgoriesNames(orderBatchModels);
			orderBatchDtos = BeanUtils.copyList(orderBatchModels, OrderBatchDto.class);
			pager.setData(orderBatchDtos);
			pager.setTotal(orderBatchPager.getTotal());
			response.setResult(pager);
			return response;
		} catch (Exception e) {
			log.error("ReportManager.findVendorSellDetail.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findVendorSellDetail.error");
			return response;
		}
	}

	private Pager<OrderBatchModel> convertCardType(Pager<OrderBatchModel> orderBatchPager) {
		if (orderBatchPager != null && orderBatchPager.getTotal() > 0 && orderBatchPager.getData() != null) {
			List<OrderBatchModel> orderBatchs = orderBatchPager.getData();
			for (OrderBatchModel bean : orderBatchs) {
				if (StringUtils.isNotEmpty(bean.getCardType())) {
					switch (bean.getCardType()) {
					case "C":
						bean.setCardType("信用卡");
						break;
					case "Y":
						bean.setCardType("借记卡");
						break;
					default:
						break;
					}
				}
			}
		}
		return orderBatchPager;
	}

	/**
	 * 根据时间段获取会员数量(会员报表)
	 * 
	 * @author xiewl
	 * @param queryParams
	 * @return
	 */
	public Response<List<MemberNumDto>> findMemberNumDto(QueryParams queryParams) {
		Response<List<MemberNumDto>> response = new Response<List<MemberNumDto>>();
		try {
			List<OrderBatchModel> orderBatchModels = reportDao.findMemberNumDto(queryParams);
			List<MemberNumDto> memberNumDtos = Lists.newArrayList();
			memberNumDtos = BeanUtils.copyList(orderBatchModels, MemberNumDto.class);
			response.setResult(memberNumDtos);
			return response;
		} catch (Exception e) {
			log.error("ReportManager.findMemberNumDto.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findMemberNumDto.error");
			return response;
		}
	}

	/**
	 * 
	 * Description : 根据时间段获取商户兑换统计报表记录
	 * 
	 * @author Huangcy
	 * @param queryParams 查询参数(日期精确到天) : 1)startDate 开始日期; 2)endDate 结束日期
	 * @return
	 */
	public Response<List<VendorExchangeStatDto>> findVendorExchangeStat(QueryParams queryParams) {
		Response<List<VendorExchangeStatDto>> response = new Response<List<VendorExchangeStatDto>>();
		try {
			// 获取数据
			List<OrderBatchModel> orderBatchModels = reportDao.findVendorExchangeStat(queryParams);
			List<VendorExchangeStatDto> vendorExchangeStatDtos = Lists.newArrayList();
			VendorExchangeStatDto vendorExchangeStatDto = null;
			// 转换数据到Dto
			for (OrderBatchModel orderBatchModel : orderBatchModels) {
				vendorExchangeStatDto = new VendorExchangeStatDto();
				vendorExchangeStatDto.setVendorNm(orderBatchModel.getVendorSnm());
				vendorExchangeStatDto.setSumNum(orderBatchModel.getGoodsNum());
				vendorExchangeStatDto.setSumPrice(orderBatchModel.getTotalMoney());
				vendorExchangeStatDtos.add(vendorExchangeStatDto);
			}
			response.setResult(vendorExchangeStatDtos);
			return response;
		} catch (Exception e) {
			log.error("ReportManager.findVendorSaleDetail.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findVendorExchangeStat.error");
			return response;
		}
	}

	/**
	 * 根据时间段获取信用卡请款报表记录(供应商平台)
	 * 
	 * @author xiewl
	 * @param queryParams
	 * @return
	 */
	public Response<Pager<OrderBatchDto>> findCreditCardReqMoney(QueryParams queryParams) {
		Response<Pager<OrderBatchDto>> response = new Response<Pager<OrderBatchDto>>();
		try {
			Pager<OrderBatchDto> pager = new Pager<OrderBatchDto>();
			Pager<OrderBatchModel> orderBatchPager = reportDao.findCreditCardReqMoney(queryParams);
			List<OrderBatchDto> orderBatchDtos = Lists.newArrayList();
			List<OrderBatchModel> orderBatchModels = orderBatchPager.getData();
			convertBackgoriesNames(orderBatchModels);
			orderBatchDtos = BeanUtils.copyList(orderBatchModels, OrderBatchDto.class);
			pager.setData(orderBatchDtos);
			pager.setTotal(orderBatchPager.getTotal());
			response.setResult(pager);
			return response;
		} catch (Exception e) {
			log.error("ReportManager.findCreditCardReqMoney.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findCreditCardReqMoney.error");
			return response;
		}
	}

	/**
	 * Description : 通过虚拟礼品编号查询相应礼品的订单信息(积分商城)
	 * 
	 * @author Huangcy
	 * @param queryParams 查询参数(日期精确到天) : 1)startDate 开始日期; 2)endDate 结束日期 ; 3)goodsIds 虚拟礼品清单集合list; 4)aviationType 航空类型
	 *            （可能不存在,为null时不限制该条件）
	 * @return
	 */
	public Response<Pager<IntegralExchangeDto>> findJFOrderByGoodsIds(QueryParams queryParams) {
		Response<Pager<IntegralExchangeDto>> response = new Response<Pager<IntegralExchangeDto>>();
		try {
			// 获取数据
			Pager<IntegralExchangeModel> integralExchangeModelPager = reportDao.findJFOrderByPage(queryParams);
			List<IntegralExchangeModel> integralExchangeModels = integralExchangeModelPager.getData();
			// List<IntegralExchangeDto> integralExchangeDtos = Lists.newArrayList();
			// IntegralExchangeDto integralExchangeDto = null;
			// // 拷贝数据
			// for (IntegralExchangeModel integralExchangeModel : integralExchangeModels) {
			// integralExchangeDto = new IntegralExchangeDto();
			// BeanUtils.copy(integralExchangeModel, IntegralExchangeDto.class);
			// integralExchangeDtos.add(integralExchangeDto);
			// }
			List<IntegralExchangeDto> integralExchangeDtos = BeanUtils.copyList(integralExchangeModels,
					IntegralExchangeDto.class);
			Pager<IntegralExchangeDto> integralExchangeDtoPager = new Pager<IntegralExchangeDto>(
					integralExchangeModelPager.getTotal(), integralExchangeDtos);
			response.setResult(integralExchangeDtoPager);
			return response;
		} catch (Exception e) {
			log.error("ReportManager.findVendorSaleDetail.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findVendorSaleDetail.error");
			return response;
		}
	}

	/**
	 * Description : 通过虚拟礼品编号查询相应礼品的订单信息,用于日报表(积分商城)
	 * 
	 * @author Huangcy
	 * @param queryParams 查询参数(日期精确到时分秒) : 1)startDate 开始日期 ; 2)endDate 结束日期 ; 3)goodsIds 虚拟礼品清单集合
	 * @return
	 */
	public Response<List<IntegralExchangeDto>> findJFOrderOfDayByGoodsIds(QueryParams queryParams) {
		Response<List<IntegralExchangeDto>> response = new Response<List<IntegralExchangeDto>>();
		try {
			List<IntegralExchangeModel> integralExchangeModels = reportDao.findJFOrderOfDayAll(queryParams);
			List<IntegralExchangeDto> integralExchangeDtos = BeanUtils.copyList(integralExchangeModels,
					IntegralExchangeDto.class);
			response.setResult(integralExchangeDtos);
			return response;
		} catch (Exception e) {
			log.error("ReportManager.findVendorSaleDetail.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findVendorSaleDetail.error");
			return response;
		}
	}

	/**
	 * 根据时间段获取会员搜索记录(会员报表)
	 * 
	 * @author xiewl
	 * @param queryParams
	 * @return
	 */
	public Response<List<MemberSearchDto>> findMemberSearchRecord(QueryParams queryParams) {
		Response<List<MemberSearchDto>> response = new Response<List<MemberSearchDto>>();
		try {
			// 调用relate模块获取数据
			HashMap<String, Object> paramMap = Maps.newHashMap();
			paramMap.put("startDate", queryParams.getStartDate());
			paramMap.put("endDate", queryParams.getEndDate());

			// 获取广发商城前五十数据
			paramMap.put("ordertypeId", "YG");
			Response<List<MemberSearchKeyWordDto>> responseYG = keywordSearchService
					.countMemberSearchKeyWords(paramMap);
			if (!responseYG.isSuccess()) {
				response.setError(responseYG.getError());
				return response;
			}
			List<MemberSearchKeyWordDto> keyWordDtosYG = responseYG.getResult();

			// 获取积分商城前五十数据
			paramMap.put("ordertypeId", "JF");
			Response<List<MemberSearchKeyWordDto>> responseJF = keywordSearchService
					.countMemberSearchKeyWords(paramMap);
			if (!responseJF.isSuccess()) {
				response.setError(responseJF.getError());
				return response;
			}
			List<MemberSearchKeyWordDto> keyWordDtosJF = responseJF.getResult();

			List<MemberSearchDto> memberSearchDtos = Lists.newArrayList();
			int size = keyWordDtosYG.size() > 50 ? 50 : keyWordDtosYG.size();
			size = keyWordDtosJF.size() > size ? keyWordDtosJF.size() : size;
			for (int i = 0; i < size; i++) {
				MemberSearchKeyWordDto keyWordDtoYG = null;
				MemberSearchKeyWordDto keyWordDtoJF = null;
				if (i < keyWordDtosYG.size()) {
					keyWordDtoYG = keyWordDtosYG.get(i);
				}
				if (i < keyWordDtosJF.size()) {
					keyWordDtoJF = keyWordDtosJF.get(i);
				}
				MemberSearchDto memberSearchDto = new MemberSearchDto();
				if (keyWordDtoYG != null) {
					memberSearchDto.setKeyWordsYG(keyWordDtoYG.getKeyWords());
					memberSearchDto.setSearchNumYG(keyWordDtoYG.getSearchNum().toString());
				}
				if (keyWordDtoJF != null) {
					memberSearchDto.setKeyWordsJF(keyWordDtoJF.getKeyWords());
					memberSearchDto.setSearchNumJF(keyWordDtoJF.getSearchNum().toString());
				}
				memberSearchDtos.add(memberSearchDto);
			}

			response.setResult(memberSearchDtos);
			return response;
		} catch (Exception e) {
			log.error("ReportManager.findMemberSearchRecord.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findMemberSearchRecord.error");
			return response;
		}
	}

	/**
	 * 根据时间段获取会员购物车报表记录(会员报表)
	 * 
	 * @author xiewl
	 * @param date 查询的结束时间
	 * @param queryType 按周查询则"week" 按月查询则"month"
	 * @return
	 */
	public Response<List<MemberCountBatchDto>> findMemberShopCarModel(Date date, String queryType) {
		Response<List<MemberCountBatchDto>> response = new Response<>();
		try{
			List<MemberCountBatchDto> memberShopCarDtos = Lists.newArrayList();
			List<CartAddCountDto> cartAddCountDtos = Lists.newArrayList();
			if ("week".equals(queryType)) {
				String year = DateHelper.date2string(date, "yyyy");
				Calendar c = Calendar.getInstance();
				c.setTime(date);
				String week = String.valueOf(c.get(Calendar.WEEK_OF_YEAR));
				cartAddCountDtos = cartAddCountDao.getWeekList(year, week);
			} else if ("month".equals(queryType)) {
				String yearMonth = DateHelper.getyyyyMM(date);
				cartAddCountDtos = cartAddCountDao.getMonthList(yearMonth);
			} else {// 查询标志出错，虽然不可能但保留
				response.setError("查询标志错误,请检查MemberShopCarExcel.java 查询标志(mallType)");
				response.setSuccess(false);
				return response;
			}
			
			// 获取广发
			List<CartAddCountDto> cartCountYGs = getCartCountByMallType(cartAddCountDtos, Contants.MAll_GF);
			// 获取积分
			List<CartAddCountDto> cartCountJFs = getCartCountByMallType(cartAddCountDtos, Contants.MAll_POINTS);
			
			int maxNum = cartCountYGs.size() > cartCountJFs.size() ? cartCountYGs.size() : cartCountJFs.size();
			int minNum = cartCountYGs.size() < cartCountJFs.size() ? cartCountYGs.size() : cartCountJFs.size();
			for(int index = 0; index < minNum; index++){
				MemberCountBatchDto memberCountBatchDto = new MemberCountBatchDto();
				CartAddCountDto cartCountYG = cartCountYGs.get(index);
				CartAddCountDto cartCountJF = cartCountJFs.get(index);
				String goodsNameYG = reportDao.findGoodsNameByItemCode(cartCountYG.getGoodsId());
				String goodsNameJF = reportDao.findGoodsNameByItemCode(cartCountJF.getGoodsId());
				memberCountBatchDto.setGoodsCodeYG(cartCountYG.getGoodsId());
				memberCountBatchDto.setGoodsNameYG(goodsNameYG);
				memberCountBatchDto.setTimeYG(cartCountYG.getCountNum().intValue());
				memberCountBatchDto.setGoodsCodeJF(cartCountJF.getGoodsId());
				memberCountBatchDto.setGoodsNameJF(goodsNameJF);
				memberCountBatchDto.setTimeJF(cartCountJF.getCountNum().intValue());
				memberShopCarDtos.add(memberCountBatchDto);
			}
			
			if(cartCountYGs.size() > cartCountJFs.size()){
				for(int index = minNum; index < maxNum; index++){
					MemberCountBatchDto memberCountBatchDto = new MemberCountBatchDto();
					CartAddCountDto cartCountYG = cartCountYGs.get(index);
					String goodsNameYG = reportDao.findGoodsNameByItemCode(cartCountYG.getGoodsId());
					memberCountBatchDto.setGoodsCodeYG(cartCountYG.getGoodsId());
					memberCountBatchDto.setGoodsNameYG(goodsNameYG);
					memberCountBatchDto.setTimeYG(cartCountYG.getCountNum().intValue());
					memberShopCarDtos.add(memberCountBatchDto);
				}
			}else if(cartCountYGs.size() < cartCountJFs.size()){
				for(int index = minNum; index < maxNum; index++){
					MemberCountBatchDto memberCountBatchDto = new MemberCountBatchDto();
					CartAddCountDto cartCountJF = cartCountJFs.get(index);
					String goodsNameJF = reportDao.findGoodsNameByItemCode(cartCountJF.getGoodsId());
					memberCountBatchDto.setGoodsCodeJF(cartCountJF.getGoodsId());
					memberCountBatchDto.setGoodsNameJF(goodsNameJF);
					memberCountBatchDto.setTimeJF(cartCountJF.getCountNum().intValue());
					memberShopCarDtos.add(memberCountBatchDto);
				}
			}
			response.setResult(memberShopCarDtos);
		}catch(Exception e){
			log.error("ReportManager.findMemberShopCarModel.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findMemberShopCarModel.error");
		}
		return response;
	}

	/**
	 * Description : 获取不同商城，加入购物车次数最多前五十的商品数据
	 * 
	 * @param cartAddCountDtos
	 * @param mallType
	 * @return
	 */
	private List<CartAddCountDto> getCartCountByMallType(List<CartAddCountDto> cartAddCountDtos, String mallType) {
		List<CartAddCountDto> cartCountMall = Lists.newArrayList();
		for (CartAddCountDto dto : cartAddCountDtos) {
			if (mallType.equals(dto.getMallType())) {
				cartCountMall.add(dto);
			}
		}
		// 按加入次数排序，找出最多前五十
		cartCountMall = orderByCountNum(cartCountMall);
		if (cartCountMall != null && cartCountMall.size() > 50) {
			cartCountMall = cartCountMall.subList(0, 49);
		}
		return cartCountMall;
	}

	/**
	 * Description : 排序
	 * 
	 * @param cartCountMall
	 * @return
	 */
	private List<CartAddCountDto> orderByCountNum(List<CartAddCountDto> cartCountMall) {
		Ordering<CartAddCountDto> ordering = Ordering.natural().reverse()
				.onResultOf(new Function<CartAddCountDto, Long>() {
					@Override
					@Nullable
					public Long apply(@Nullable CartAddCountDto dto) {
						return dto.getCountNum() == null ? new Long(0) : dto.getCountNum();
					}
				});
		return ordering.sortedCopy(cartCountMall);
	}

	/**
	 * 获取后台类目名称(后台二级、三级、四级类目名称)
	 * @param orderBatchModels
	 */
	private void convertBackgoriesNames(List<OrderBatchModel> orderBatchModels){
		for(OrderBatchModel orderBatchModel : orderBatchModels){
			if(orderBatchModel.getProductId() == null){
				continue;
			}
			List<Pair> categoryList = getCategoryBy(orderBatchModel.getProductId());
			if(categoryList != null && categoryList.size() > 1){//存在二级及以上的类目
				int levelNum = categoryList.size()>4 ? 4 : categoryList.size();
				for(int i=1;i<levelNum;i++){
	                try {
	                    Method method = orderBatchModel.getClass().getMethod("setBackCategory" + i + "Id",String.class);
	                    method.invoke(orderBatchModel,categoryList.get(i).getName());
	                } catch (Exception e) {
	                    e.printStackTrace();
	                    log.error("no such method error",e);//won't happen
	                }
	            }
			}
		}
	}
	
	/**
	 * 获取后台类目信息，先取缓存，没有再取redis
	 * @param spuId 产品id
	 * @return
	 */
	private List<Pair> getCategoryBy(Long spuId){
		if(backCategories == null){
			backCategories = Maps.newHashMap();
		}
		List<Pair> pairs = backCategories.get(spuId);
		if(pairs == null){//缓存中没有后台类目信息时去redis取
			pairs = findCategoryBy(spuId);
			backCategories.put(spuId, pairs);
		}
		return pairs;
	}
	
	/**
	 * 通过产品spuId从redis查询类目信息
	 * @param spuId	产品id
	 * @return
	 */
	private List<Pair> findCategoryBy(Long spuId){
		List<Pair> pairs = null;
		try{
			Response<Spu> spuR = spuService.findById(spuId);
	        Long cateGoryId = spuR.getResult().getCategoryId();
	        List<BackCategory> backCategories = backCategoryHierarchy.ancestorsOf(cateGoryId);
	        pairs = Lists.newArrayListWithCapacity(backCategories.size());
	        for (BackCategory bc : backCategories) {
	            pairs.add(new Pair(bc.getName(), bc.getId()));
	        }
		}catch(Exception e){
            log.error("failed to find good's categorys by spuId,spuId:{},cause:{}", spuId, Throwables.getStackTraceAsString(e));
		}
        return pairs;
	}
	
	public Response<Map<String, String>> findBankCity() {
		Response<Map<String, String>> response = new Response<>();
		try {
			Map<String, String> bankCities = Maps.newHashMap();
			List<IntegralExchangeModel> integralExchangeModels = reportDao.findBankCity();
			if (integralExchangeModels != null) {
				for (IntegralExchangeModel integralExchangeModel : integralExchangeModels) {
					bankCities.put(integralExchangeModel.getCardNo(), integralExchangeModel.getCardCity());
				}
			}
			response.setResult(bankCities);
		} catch (Exception e) {
			log.error("ReportManager.findBankCity.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("ReportManager.findBankCity.error");
		}
		return response;
	}
}
