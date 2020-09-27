package cn.com.cgbchina.trade.service;

import static com.google.common.base.Preconditions.checkNotNull;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.trade.dto.OrderPartBackDto;
import cn.com.cgbchina.trade.model.*;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.LocalDate;
import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;

import cn.com.cgbchina.item.dto.ItemsAttributeDto;
import cn.com.cgbchina.item.dto.ItemsAttributeSkuDto;
import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.dto.OrderInfoDto;
import cn.com.cgbchina.trade.dto.OrderItemAttributeDto;
import cn.com.cgbchina.trade.manager.OrderDodetailManger;
import cn.com.cgbchina.trade.manager.OrderPartBackManager;
import cn.com.cgbchina.trade.manager.OrderReturnTrackDetailManager;
import cn.com.cgbchina.trade.manager.OrderSubManager;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by yuxinxin on 16-4-29.
 */

@Service
@Slf4j
public class OrderPartBackServiceImpl implements OrderPartBackService {
	@Resource
	private OrderPartBackDao orderPartBackDao;
	@Resource
	private OrderPartBackManager orderPartBackManager;
	private final static JsonMapper JSON_MAPPER = JsonMapper.nonEmptyMapper();
	@Resource
	private OrderSubDao orderSubDao;
	@Resource
	TblOrderHistoryDao tblOrderHistoryDao;
	@Resource
	private OrderSubManager orderSubManager;
	@Resource
	private OrderReturnTrackDetailManager orderReturnTrackDetailManager;
	@Resource
	private OrderMainDao orderMainDao;
	@Resource
	private OrderReturnTrackDetailDao orderReturnTrackDetailDao;
	@Resource
	private OrderDodetailManger orderDodetailManger;
    @Resource
    private  TblOrderExtend1Dao tblOrderExtend1Dao;

	/**
	 * 审核撤单 供应商端使用此方法
	 *
	 * @param orderSubModel
	 * @return
	 */
	@Override
	public Response<Boolean> updateRevocation(OrderSubModel orderSubModel, String memo, String memoExt) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			OrderReturnTrackDetailModel orderReturnTrackDetailModel = new OrderReturnTrackDetailModel();
			// 更新订单表中的订单状态
			orderSubModel.setCurStatusId("0312");
			orderSubModel.setCurStatusNm("已撤单");
			orderSubModel.setSaleAfterStatus("0312");
			Boolean result = orderSubManager.updateStatues(orderSubModel);
			// 更新失败
			if (!result) {
				response.setError("update.reviewed.error");
				return response;
			}
			// 向履历model中添加数据
			orderReturnTrackDetailModel.setMemo(memo);
			orderReturnTrackDetailModel.setMemoExt(memoExt);
			orderReturnTrackDetailModel.setOrderId(orderSubModel.getOrderId());// 订单号
			orderReturnTrackDetailModel.setOrdertypeId(orderSubModel.getOrdertypeId());// 业务类型
			orderReturnTrackDetailModel.setOrdertypeNm(orderSubModel.getOrdertypeNm());// 业务名称
			orderReturnTrackDetailModel.setOperationType(0);// 0是撤单 1是退货
			orderReturnTrackDetailModel.setCreateOper(orderSubModel.getModifyOper());
			orderReturnTrackDetailModel.setCurStatusId("0312");// 状态
			orderReturnTrackDetailModel.setCurStatusNm("已撤单");// 状态名称
			// 向履历表中插入（退货/撤单履历表）
			result = orderReturnTrackDetailManager.insert(orderReturnTrackDetailModel);
			if (!result) {
				response.setError("update.reviewed.error");
				return response;
			}

			// 向订单履历中插入（订单处理历史明细表）
			OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
			orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
			orderDoDetailModel.setDoUserid(orderSubModel.getModifyOper());
			orderDoDetailModel.setStatusId("0312");
			orderDoDetailModel.setStatusNm("已撤单");
			orderDoDetailModel.setUserType("2");// 2 供应商操作
			orderDoDetailModel.setDelFlag(0);
			orderDoDetailModel.setCreateOper(orderSubModel.getModifyOper());
			result = orderDodetailManger.insert(orderDoDetailModel);
			if (!result) {
				response.setError("update.reviewed.error");
				return response;
			}
			// ******************************************start************************
			// TODO 退货接口NSCT018 商城退款请求（旧：NSCT008）以及积分优惠卷对账文件的操作保留（2016-07-11）

			// 根据主订单号获取主订单表中的订货人手机号码
			/*
			 * OrderMainModel orderMainModel = orderMainDao.findById(orderSubModel.getOrdermainId()); //
			 * 撤销流程成功后发送短信至客户手机 if(orderMainModel.getContMobPhone()!=null
			 * &&!orderMainModel.getContMobPhone().trim().equals("")){ SendMobileMsg
			 * send=(SendMobileMsg)SpringUtil.getBean("MSG072FH00013"); Map mobileMap = new HashMap();
			 * mobileMap.put("contMobPhone", orderMainModel.getContMobPhone()); mobileMap.put("goodsNm",
			 * orderSubModel.getGoodsNm()); mobileMap.put("account", orderSubModel.getGoodg); mobileMap.put("reaccount",
			 * total_Money); Map returnMap = send.sendMsg(mobileMap); if(returnMap!=null){ String reMsg = (String)
			 * returnMap.get("msg"); log.info(reMsg); } }
			 */

			// 一期订单线下退款 线上更新订单状态和插入履历 二期全部线上处理
			// *************************************end*****************************

			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("update reviewed error", Throwables.getStackTraceAsString(e));
			response.setError("update.reviewed.error");
			return response;
		}

	}

	/**
	 * 供应商撤单 新更改后的撤单查询
	 *
	 * @param pageNo
	 * @param size
	 * @param startTime
	 * @param endTime
	 * @param sourceId
	 * @param orderId
	 * @param ordertypeId
	 * @param ordermainId
	 * @return
	 */
	@Override
	public Response<Pager<OrderPartBackDto>> findRevocationAll(@Param("_USER_") User user, @Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("startTime") String startTime, @Param("endTime") String endTime,
			@Param("orderId") String orderId, @Param("sourceId") String sourceId,
			@Param("ordertypeId") String ordertypeId, @Param("ordermainId") String ordermainId) {
		log.error("---------------------撤单管理开始{}", System.currentTimeMillis());
		// 构造返回值及参数
		Response<Pager<OrderPartBackDto>> response = new Response<Pager<OrderPartBackDto>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> paramMap = Maps.newHashMap();
		// 判断主订单号为空
		if (StringUtils.isNotBlank(ordermainId)) {
			paramMap.put("ordermainId", ordermainId.trim());
		}
		// 判断订单号为空
		if (StringUtils.isNotBlank(orderId)) {
			paramMap.put("orderId", orderId.trim());
		}

        LocalDate endDate = LocalDate.now();
        // LocalDate startDateMIn6 = endDate.minusMonths(6);
        LocalDate startDateMIn100 = endDate.minusDays(100);
        //页面初始化时间为null
        if(StringUtils.isBlank(startTime) && StringUtils.isBlank(endTime)){
            paramMap.put("startTime", startDateMIn100.toString());
            paramMap.put("endTime", endDate.toString());
        }
		// 判断商城是否查询100天之内的数据
		// 判断订单时间
		if (StringUtils.isNotBlank(startTime)) {
			paramMap.put("startTime", startTime);
		}
		// 判断订单时间
		if (StringUtils.isNotBlank(endTime)) {
			paramMap.put("endTime",endTime);
		}

		// 判断分期类型为空
		if (StringUtils.isNotBlank(ordertypeId)) {
			paramMap.put("ordertypeId", ordertypeId);
		}
		if (StringUtils.isNotBlank(sourceId)) {
			paramMap.put("sourceId", sourceId);
		}
		String vendorId = user.getId();
		if (StringUtils.isNotBlank(vendorId)) {
			paramMap.put("vendorId", vendorId);
		}
		try {
			// 获取子订单列表数据
			// 获取子订单列表数据 100天之前订单取自history表
			Pager<OrderSubModel> pager = new Pager<>();
			List<OrderSubModel> orderSubModelList = new ArrayList<OrderSubModel>();
			pager = orderSubDao.findLikeByPagePart(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
			orderSubModelList = pager.getData();
			Pager<TblOrderHistoryModel> pagerTblOrderHistory = tblOrderHistoryDao.findLikeByPage(paramMap,
					pageInfo.getOffset(), pageInfo.getLimit());
			List<TblOrderHistoryModel> tblOrderHistoryModelList = pagerTblOrderHistory.getData();
			for (TblOrderHistoryModel tblOrderHistoryModel : tblOrderHistoryModelList) {
				OrderSubModel orderSubModel = new OrderSubModel();
				BeanMapper.copy(tblOrderHistoryModel, orderSubModel);
				orderSubModelList.add(orderSubModel);
			}
			List<OrderPartBackDto> orderPartBackDtos = new ArrayList<OrderPartBackDto>();
            OrderPartBackDto orderPartBackDto = null;
			// 遍历orderSubModel，构造返回值
			for (OrderSubModel orderSubModel : orderSubModelList) {
                orderPartBackDto = new OrderPartBackDto();

				List<OrderReturnTrackDetailModel> orderReturnTrackDetailModelList = new ArrayList<>();
                //查询退货撤单履历表
				orderReturnTrackDetailModelList = orderReturnTrackDetailDao.findByOrderId(orderSubModel.getOrderId());
				for (OrderReturnTrackDetailModel orderReturnTrackDetailModel : orderReturnTrackDetailModelList) {
					OrderReturnTrackDetailModel orderReturnTrackDetailModelData = new OrderReturnTrackDetailModel();
					BeanMapper.copy(orderReturnTrackDetailModel, orderReturnTrackDetailModelData);
                    orderPartBackDto.setOrderReturnTrackDetailModel(orderReturnTrackDetailModelData);
				}
                //获取银行订单号
                TblOrderExtend1Model tblOrderExtend1Model = new TblOrderExtend1Model();
                tblOrderExtend1Model = tblOrderExtend1Dao.findByOrderId(orderSubModel.getOrderId());
                orderPartBackDto.setTblOrderExtend1Model(tblOrderExtend1Model);
                orderPartBackDto.setOrderSubModel(orderSubModel);
                //获取主订单表中的订货人姓名
                OrderMainModel orderMainModel = new OrderMainModel();
                orderMainModel = orderMainDao.findById(orderSubModel.getOrdermainId());
                orderPartBackDto.setOrderMainModel(orderMainModel);
				// 获取商品销售属性
				String json = orderSubModel.getGoodsAttr1();
				List<OrderItemAttributeDto> orderItemAttributeDtoList = Lists.newArrayList();
				// json转list
				if (StringUtils.isNotEmpty(json)) {
					ItemsAttributeDto itemsAttributeDto = JSON_MAPPER.fromJson(json, ItemsAttributeDto.class);
					if (itemsAttributeDto != null) {
						List<ItemsAttributeSkuDto> skus = Lists.newArrayList();
						skus = itemsAttributeDto.getSkus();
						if (!skus.isEmpty() && skus != null) {
							for (ItemsAttributeSkuDto itemsAttributeSkuDto : skus) {
								OrderItemAttributeDto orderItemAttributeDto = new OrderItemAttributeDto();
								orderItemAttributeDto.setAttributeName(itemsAttributeSkuDto.getAttributeValueName());
								if (itemsAttributeSkuDto.getValues() != null
										&& !itemsAttributeSkuDto.getValues().isEmpty()) {
									orderItemAttributeDto.setAttributeValueName(
											itemsAttributeSkuDto.getValues().get(0).getAttributeValueName());
								}
								orderItemAttributeDtoList.add(orderItemAttributeDto);
							}
						}
					}
                    orderPartBackDto.setOrderItemAttributeDtos(orderItemAttributeDtoList);
				}
                orderPartBackDtos.add(orderPartBackDto);
			}
			response.setResult(new Pager<OrderPartBackDto>(pager.getTotal(), orderPartBackDtos));
			log.error("撤单管理结束{}", System.currentTimeMillis());
			return response;
		} catch (Exception e) {
			log.error("OrderPartBackServiceImpl.find.qury.error{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderPartBackServiceImpl.find.qury.error");
			return response;
		}
	}

	/**
	 * 批量更新
	 *
	 * @param updateAll
	 * @return
	 */
	public Response<Integer> updateAllRevocation(User user,List<String> updateAll, String memo,String memoExt) {
		Response<Integer> response = new Response<Integer>();
		try {
			checkNotNull(updateAll, "updateAll is Null");
			Map<String, Object> paramMap = Maps.newHashMap();
			paramMap.put("idList", updateAll);
			paramMap.put("modifyOper", user.getName());

           /* paramMap.put("memo",memo);
            paramMap.put("memoExt",memoExt);*/
			// 更新
            Integer count = orderSubManager.updateAllRevocation(paramMap);
            // 更新失败
            if (count<=0) {
                response.setError("update.reviewed.error");
                return response;
            }
            for(String orderId :updateAll){
                OrderSubModel orderSubModel =  orderSubDao.findById(orderId);
                OrderReturnTrackDetailModel orderReturnTrackDetailModel = new OrderReturnTrackDetailModel();
                // 向履历model中添加数据
                orderReturnTrackDetailModel.setMemo(memo);
                orderReturnTrackDetailModel.setMemoExt(memoExt);
                orderReturnTrackDetailModel.setOrderId(orderSubModel.getOrderId());// 订单号
                orderReturnTrackDetailModel.setOrdertypeId(orderSubModel.getOrdertypeId());// 业务类型
                orderReturnTrackDetailModel.setOrdertypeNm(orderSubModel.getOrdertypeNm());// 业务名称
                orderReturnTrackDetailModel.setOperationType(0);// 0是撤单 1是退货
                orderReturnTrackDetailModel.setCreateOper(user.getName());
                orderReturnTrackDetailModel.setCurStatusId("0312");// 状态
                orderReturnTrackDetailModel.setCurStatusNm("已撤单");// 状态名称
                // 向履历表中插入（退货/撤单履历表）
                Boolean result = orderReturnTrackDetailManager.insert(orderReturnTrackDetailModel);
                if (!result) {
                    response.setError("update.reviewed.error");
                    return response;
                }

                // 向订单履历中插入（订单处理历史明细表）
                OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
                orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
                orderDoDetailModel.setDoUserid(user.getName());
                orderDoDetailModel.setStatusId("0312");
                orderDoDetailModel.setStatusNm("已撤单");
                orderDoDetailModel.setUserType("2");// 2 供应商操作
                orderDoDetailModel.setDelFlag(0);
                orderDoDetailModel.setCreateOper(user.getName());
                result = orderDodetailManger.insert(orderDoDetailModel);
                if (!result) {
                    response.setError("update.reviewed.error");
                    return response;
                }
            }
            response.setResult(count);
            return response;
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.info("update.all.revocation.error", Throwables.getStackTraceAsString(e));
			response.setError("update.all.revocation.error");
			return response;
		}
	}

}
