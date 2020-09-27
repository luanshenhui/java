package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.rest.visit.model.coupon.CouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponInfoResult;
import cn.com.cgbchina.rest.visit.service.coupon.CouponService;
import cn.com.cgbchina.trade.dao.RedisDao;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class RedisServiceImpl implements RedisService {

    @Resource
    private CartService cartService;
    @Resource
    private CouponService couponService;
	@Resource
	private RedisDao redisDao;

	@Override
	public Response<Boolean> deleteCoupons(final String userId) {
        return this.delete(Contants.REDIS_KEY_COUPON + userId);
	}

	@Override
	public Response<List<CouponInfo>> getCoupons(final String userId, final String contIdType, final String certNo) {
		Response<List<CouponInfo>> response = Response.newResponse();
        List<CouponInfo> couponInfoList = Lists.newArrayList();
        try {
            Object object = redisDao.get(Contants.REDIS_KEY_COUPON + userId);
            if (object == null) {
				Response<List<CouponInfo>> listResponse = this.getNewCouponInfos(
						contIdType,
						certNo,
						Byte.valueOf("0"));
					// 0：全部 1：已使用 2：未使用

				if (!listResponse.isSuccess()) {
					log.error("trade.redis.getCouponInfos.error, userId：{}", userId);
                    response.setError(listResponse.getError());
				} else {
                    List<CouponInfo> couponInfoList_temp = listResponse.getResult();
                    if (couponInfoList_temp.size() > 0) {
                        redisDao.create(Contants.REDIS_KEY_COUPON + userId, couponInfoList_temp);
                        response.setResult(couponInfoList_temp);
                    }
                    else {
                        response.setResult(couponInfoList);
                    }
				}
			}
			else {
				response.setResult((List<CouponInfo>)object);
			}

			// 成功返回
		} catch (Exception e) {
			log.error("trade.redis.getCoupons.error, {}", Throwables.getStackTraceAsString(e));
            response.setError("trade.redis.getCoupons.error");
		}
		return response;
	}

	@Override
	public Response<Boolean> deleteScores(final String userId) {
        return this.delete(Contants.REDIS_KEY_SCORE + userId);
	}

	@Override
	public Response<Map<String,BigDecimal>> getScores(final User user) {
		Response<Map<String,BigDecimal>> response = Response.newResponse();
		try {
            Object object = redisDao.get(Contants.REDIS_KEY_SCORE + user.getId());
			if (object == null) {
				Response<Map<String,BigDecimal>> listResponse = cartService.getUserScore(user);
				if (!listResponse.isSuccess()) {
					log.error("trade.redis.getUserScore.error,{}", user.getId());
					response.setError("trade.redis.getUserScore.error");
				} else {
                    Map<String,BigDecimal> userPointDto = listResponse.getResult();
					redisDao.create(Contants.REDIS_KEY_SCORE + user.getId(), userPointDto);
					response.setResult(userPointDto);
				}
			}
			else {
				response.setResult((Map<String,BigDecimal>)object);
			}

			// 成功返回
		} catch (Exception e) {
			log.error("trade.redis.getScores.error, {}", Throwables.getStackTraceAsString(e));
			response.setError("trade.redis.getScores.error");
		}
		return response;
	}

    @Override
    public Response<List<CouponInfo>> getNewCouponInfos(String contIdType, String certNo, Byte useState) {
        Response<List<CouponInfo>> response = Response.newResponse();
        List<CouponInfo> couponInfoList = Lists.newArrayList();
        response.setResult(couponInfoList);

        try {
            QueryCouponInfo queryCouponInfo = new QueryCouponInfo();
            queryCouponInfo.setChannel("BC");
            queryCouponInfo.setQryType("01");
            queryCouponInfo.setRowsPage("10");
            queryCouponInfo.setContIdType(contIdType);
            queryCouponInfo.setContIdCard(certNo);
            queryCouponInfo.setUseState(useState);
            queryCouponInfo.setPastDueState(Byte.valueOf("1"));

            int cPage = 0;// 从第一页开始请求
            while (true) {
                queryCouponInfo.setCurrentPage(String.valueOf(cPage));
                log.info("MA4000查询优惠券接口请求报文,{}", queryCouponInfo);
                QueryCouponInfoResult queryCouponInfoResult = couponService.queryCouponInfo(queryCouponInfo);
                log.info("MA4000查询优惠券接口返回报文,{}", queryCouponInfoResult);
                if (!Contants.RETRUN_CODE_000000.equals(queryCouponInfoResult.getRetCode())) {
                    log.error("failed to getValidate ,error :{}", queryCouponInfoResult.getRetErrMsg());
//                    response.setError("cart.getCouponInfo.error");
                    break;
                } else {
                    List<CouponInfo> coupons = queryCouponInfoResult.getCouponInfos();
                    if (coupons == null || coupons.size() == 0) {
                        break;
                    }
                    couponInfoList.addAll(coupons);
                    // 每页条数
                    int totalCount = Integer.parseInt(queryCouponInfoResult.getTotalCount());
                    // 总记录数
                    int totalPages = Integer.parseInt(queryCouponInfoResult.getTotalPages());
                    // 总页数
                    int pageCounts = (totalCount + totalPages - 1) / totalCount;
                    cPage++;
                    if (cPage > pageCounts) {
                        break;
                    }
                }
            }
        }
        catch (Exception e) {
            log.error("CouPonInfService.getCouponInfos.error,error code:{}", Throwables.getStackTraceAsString(e));
//            response.setError("find.coupon.error");
//            throw new ResponseException(Contants.ERROR_CODE_500, "find.coupon.error");
        }
        response.setResult(couponInfoList);
        return response;
    }
    private Response<Boolean> delete(final String key) {
        Response<Boolean> response = Response.newResponse();
        try {
            redisDao.delete(key);
            // 成功返回
            response.setSuccess(true);
        } catch (Exception e) {
            log.error("trade.redis.delete.error,{}", Throwables.getStackTraceAsString(e));
            response.setError("trade.redis.delete.error");
            return response;
        }
        return response;
    }

    //TODO需测试修改
    @Override
    public Response<Boolean> createOrderExportUrl(String userId, String dlUrl ,String orderTypeId){
        Response<Boolean> response = Response.newResponse();
        try {
            redisDao.create(Contants.REDIS_KEY_ORDEREXPORT + orderTypeId + userId, dlUrl);
            // 成功返回
            response.setResult(true);
        } catch (Exception e) {
            log.error("trade.redis.createOrderExportUrl.error,{}", Throwables.getStackTraceAsString(e));
            response.setError("trade.redis.createOrderExportUrl.error");
        }
        return response;
    }

    @Override
    public Response<String> getOrderExportUrl(String userId ,String orderTypeId){
        Response<String> response = Response.newResponse();
        try {
            Object object = redisDao.get(Contants.REDIS_KEY_ORDEREXPORT + orderTypeId + userId);
            if (object == null){
                response.setResult(null);
            }else{
                response.setResult(object.toString());
            }
        } catch (Exception e) {
            log.error("trade.redis.getOrderExportUrl.error,{}", Throwables.getStackTraceAsString(e));
            response.setError("trade.redis.getOrderExportUrl.error");
        }
        return response;
    }

    @Override
    public Response<Boolean> createApplayPaymentExportUrl(String userId,String systemType,String orderType,String dlUrl){
        Response<Boolean> response = Response.newResponse();
        try {
            redisDao.create(Contants.REDIS_KEY_APPLYPAYMENTEXPORT+systemType+orderType+userId, dlUrl);
            // 成功返回
            response.setResult(true);
        } catch (Exception e) {
            log.error("trade.redis.createApplyPaymentExportUrl.error,{}", Throwables.getStackTraceAsString(e));
            response.setError("trade.redis.createApplyPaymentExportUrl.error");
        }
        return response;
    }

    @Override
    public Response<String> getApplayPaymentExportUrl(String userId, String systemType, String orderType){
        Response<String> response = Response.newResponse();
        try {
            Object object = redisDao.get(Contants.REDIS_KEY_APPLYPAYMENTEXPORT+systemType+orderType+userId);
            if (object == null){
                response.setResult(null);
            }else{
                response.setResult(object.toString());
            }
        } catch (Exception e) {
            log.error("trade.redis.getApplayPaymentExportUrl.error,{}", Throwables.getStackTraceAsString(e));
            response.setError("trade.redis.getApplayPaymentExportUrl.error");
        }
        return response;
    }
}
