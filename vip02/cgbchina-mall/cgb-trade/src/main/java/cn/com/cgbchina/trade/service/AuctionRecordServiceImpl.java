package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.trade.dao.AuctionRecordDao;
import cn.com.cgbchina.trade.manager.OrderMainManager;
import cn.com.cgbchina.trade.model.AuctionRecordModel;
import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by wangqi on 16-7-28.
 */

@Service
@Slf4j
public class AuctionRecordServiceImpl implements AuctionRecordService {
	@Resource
	private AuctionRecordDao auctionRecordDao;
	@Resource
	private OrderMainManager orderMainManager;
	@Resource
	private MallPromotionService mallPromotionService;

	/**
	 * 取得荷兰拍单品拍卖纪录
	 * @param promId
	 * @param periodId
	 * @param itemCode
	 * @return
	 */
	@Override
	public Response<List<AuctionRecordModel>> findByParam(String promId, String periodId, String itemCode) {
		// 实例化返回Response
		Response<List<AuctionRecordModel>> response = new Response<List<AuctionRecordModel>>();

		try {
			Map<String, Object> paramMap = Maps.newHashMap();
			paramMap.put("auctionId",promId);
			paramMap.put("periodId",periodId);
			paramMap.put("itemId",itemCode);
			paramMap.put("isBacklock","1");
			List<AuctionRecordModel> list = auctionRecordDao.findByParam(paramMap);
			// 返回
			response.setResult(list);
			return response;
		} catch (Exception e) {
			log.error("AuctionRecordServiceImpl.findByParam.error", Throwables.getStackTraceAsString(e));
			response.setError("AuctionRecordServiceImpl.findByParam.error");
			return response;
		}
	}

	/**
	 * 根据拍卖ID取得拍卖纪录
	 * @param id
	 * @return
	 */
	@Override
	public Response<AuctionRecordModel> findById(String id) {
		// 实例化返回Response
		Response<AuctionRecordModel> response = new Response<AuctionRecordModel>();

		try {
			AuctionRecordModel auctionRecordModel = auctionRecordDao.findById(Long.valueOf(id));
			// 返回
			response.setResult(auctionRecordModel);
		} catch (Exception e) {
			log.error("AuctionRecordServiceImpl.findById.error", e);
			response.setError("AuctionRecord.findById.error");
		}
		return response;

	}

	/**
	 * 根据拍卖ID取得拍卖纪录
	 * @param ids
	 * @return
	 */
	@Override
	public Response<List<AuctionRecordModel>> findByIds(List<String> ids) {
		// 实例化返回Response
		Response<List<AuctionRecordModel>> response = new Response<List<AuctionRecordModel>>();

		try {
			Map<String, Object> paramMap = Maps.newHashMap();
			if (ids.size() == 0) {
				response.setError("AuctionRecordServiceImpl.findByParam.error");
				return response;
			}
			List<AuctionRecordModel> auctionRecordModelList = auctionRecordDao.findByIds(ids);
			// 返回
			response.setSuccess(true);
			response.setResult(auctionRecordModelList);
			return response;
		} catch (Exception e) {
			log.error("AuctionRecordServiceImpl.findById.error", Throwables.getStackTraceAsString(e));
			response.setError("AuctionRecordServiceImpl.findById.error");
			return response;
		}
	}

	/**
	 * 新增拍卖纪录
	 *
	 * @return
	 */
	public Response<Long> insert(AuctionRecordModel auctionRecordModel) {
		Response<Long> response = Response.newResponse();
		try{
			if (auctionRecordModel == null) {
				response.setError("not.null");
				return response;
			}
			orderMainManager.insert(auctionRecordModel);
			response.setResult(auctionRecordModel.getId());
			return response;
		} catch (Exception e) {
			log.error("AuctionRecordServiceImpl.insert.error", Throwables.getStackTraceAsString(e));
			response.setError("AuctionRecordServiceImpl.insert.error");
			return response;
		}
	}

	/**
	 * 按用户检索拍卖纪录
	 * @param user
	 * @return
	 */
	public Response<List<AuctionRecordModel>> findByCustId(@Param("User") User user){
		log.info("Get AuctionRecordService.findByCustId");
		Response<List<AuctionRecordModel>> response = Response.newResponse();
		try {
			if(user != null){
				Map<String, Object> paramMap = Maps.newHashMap();
				paramMap.put("custId",user.getCustId());
				//按用户检索拍卖纪录
				List<AuctionRecordModel> auctionRecordModelList = auctionRecordDao.findByParam(paramMap);
				log.info("Result AuctionRecordService.findByCustId result{}",auctionRecordModelList);
				//五分钟内时间
				long sysTime = System.currentTimeMillis();
				//如果返回拍卖纪录不为null
				if (auctionRecordModelList != null){
					List<AuctionRecordModel> validAuctionList = new ArrayList<>();
					String orderId = "";
					Long auctionTime =0L;
					//循环返回拍卖纪录
					for(AuctionRecordModel auctionRecordModel : auctionRecordModelList){
						orderId = auctionRecordModel.getOrderId();
						auctionTime = auctionRecordModel.getAuctionTime().getTime() +(5 * 60 * 1000);
						Long inFiveMinute = sysTime - auctionTime;
						//订单为空 拍卖时间在五分钟之内
						if (orderId == null && inFiveMinute < 0){
							validAuctionList.add(auctionRecordModel);
						}
						else{
							continue;
						}
					}
					log.info("response AuctionRecordService.findByCustId validAuctionList{}",validAuctionList);
					response.setResult(validAuctionList);
				}
				else {
					response.setResult(auctionRecordModelList);
				}
			}
			else{
				response.setError("auction.get.userInfo.error");
			}
		}catch (Exception e) {
			log.error("auction.getUser.record.error{}", Throwables.getStackTraceAsString(e));
			response.setError("auction.getUser.record.error");
		}
		return response;
	}

	/**
	 * 更新拍卖记录表
	 * @param auctionRecordModel
	 * @return
	 */
	public Response<Integer> updatePayFlag(AuctionRecordModel auctionRecordModel){
		Response<Integer> response = new Response<Integer>();
		try{
			if (auctionRecordModel == null) {
				response.setError("not.null");
				return response;
			}
			Integer count = orderMainManager.update(auctionRecordModel);
			response.setResult(count);
			return response;
		} catch (Exception e) {
			log.error("AuctionRecordServiceImpl.update.error{}", Throwables.getStackTraceAsString(e));
			response.setError("AuctionRecordServiceImpl.update.error");
			return response;
		}
	}

	/**
	 * 更新拍卖记录表
	 * @param auctionRecordModel
	 * @return
	 */
	public Response<Integer> updateByIdAndBackLock(AuctionRecordModel auctionRecordModel){
		Response<Integer> response = new Response<Integer>();
		try{
			if (auctionRecordModel != null) {
				response.setError("not.null");
				return response;
			}
			Integer count = orderMainManager.updateByIdAndBackLock(auctionRecordModel);
			response.setResult(count);
			return response;
		} catch (Exception e) {
			log.error("AuctionRecordServiceImpl.update.error{}", Throwables.getStackTraceAsString(e));
			response.setError("AuctionRecordServiceImpl.update.error");
			return response;
		}
	}

	/**
	 * 新增或更新拍卖纪录
	 *add by zhangshiqiang
	 * @return
	 */
	public Response<Long> insertOrUpdate(AuctionRecordModel auctionRecordModel,User user) {
		Response<Long> response = Response.newResponse();
		try{
			//查询拍卖记录表是否纯在当前用户所拍卖的此商品信息
			Map<String, Object> paramMap = Maps.newHashMap();
			paramMap.put("custId",auctionRecordModel.getCustId());
			paramMap.put("itemId",auctionRecordModel.getItemId());
			paramMap.put("isBacklock","1");

			List<AuctionRecordModel> result = auctionRecordDao.findByParam(paramMap);
			//如果存在则更新拍卖价格和拍卖时间
			if(!result.isEmpty()
					&& StringUtils.isEmpty(result.get(0).getOrderId())){
				AuctionRecordModel resultModel = result.get(0);
				auctionRecordModel.setId(resultModel.getId());
				orderMainManager.update(auctionRecordModel);
			}else{
				// 如果不存在则插入拍卖纪录
				orderMainManager.insert(auctionRecordModel);
				// 记销量
				String promId = String.valueOf(auctionRecordModel.getAuctionId());
				String periodId = String.valueOf(auctionRecordModel.getPeriodId());
				String itemId = String.valueOf(auctionRecordModel.getItemId());
				mallPromotionService.updatePromSaleInfo(promId, periodId, itemId, "1", user);
			}
			response.setResult(auctionRecordModel.getId());

		} catch (Exception e) {
			log.error("AuctionRecordServiceImpl.insert.error{}", Throwables.getStackTraceAsString(e));
			response.setError("AuctionRecordServiceImpl.insert.error");
		}
		return response;

	}


	/**
	 * 更新拍卖记录表
	 * @param auctionRecordModel
	 * @return
	 */
	public Response<Integer> updatePayFlagForOrder(AuctionRecordModel auctionRecordModel){
		Response<Integer> response = new Response<Integer>();
		try{
			if (auctionRecordModel == null) {
				response.setError("not.null");
				return response;
			}
			Integer count = auctionRecordDao.updateHollandOrder(auctionRecordModel);
			response.setResult(count);
			return response;
		} catch (Exception e) {
			log.error("AuctionRecordServiceImpl.updateHollandOrder.error", Throwables.getStackTraceAsString(e));
			response.setError("AuctionRecordServiceImpl.updateHollandOrder.error");
			return response;
		}
	}
}
