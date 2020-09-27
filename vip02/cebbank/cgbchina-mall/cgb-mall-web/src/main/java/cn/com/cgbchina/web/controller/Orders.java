package cn.com.cgbchina.web.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.KeyReader;
import cn.com.cgbchina.common.utils.SignManager;
import cn.com.cgbchina.common.utils.SignUtil;
import cn.com.cgbchina.trade.dto.*;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderTransModel;
import cn.com.cgbchina.trade.service.OrderPartBackService;
import cn.com.cgbchina.trade.service.OrderService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserAccount;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * Created by 11140721050130 on 2016/4/3.
 */
@Controller
@RequestMapping("/api/mall/myOrders")
@Slf4j
public class Orders {
    @Resource
    OrderPartBackService orderPartBackService;
    @Resource
    MessageSources messageSources;
    @Resource
    private OrderService orderService;
    @Value("#{app.expressUrl}")
    private String expressUrl;

    /**
     * 确认订单方法 add by zhangc
     */
    @RequestMapping(value = "/affirm", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public PagePaymentReqDto affirmOrder(@RequestBody OrderCommitSubmitDto orderCommitSubmitDto) {
        // 获取用户信息
        User user = UserUtil.getUser();
        UserAccount selectedCardInfo = new UserAccount();
        PagePaymentReqDto pagePaymentReqDto = new PagePaymentReqDto();
        try {
            String cardNo = orderCommitSubmitDto.getCardNo();
            checkArgument(!cardNo.isEmpty(), "cardNo can not be empty");
            KeyReader keyReader = new KeyReader();
            for (UserAccount userAccount : user.getAccountList()) {
                String cardSign = SignUtil.sign(userAccount.getCardNo(), keyReader
                        .readPrivateKey(SignManager.DEFAULT_RSA_PRI_KEY, true, SignManager.RSA_ALGORITHM_NAME));
                if (cardNo.equals(cardSign)) {
                    selectedCardInfo = userAccount;
                    orderCommitSubmitDto.setCardNo(userAccount.getCardNo());
                    break;
                }
            }
        } catch (IllegalArgumentException e) {
            log.error("create.error,error code: {}", Throwables.getStackTraceAsString(e));
            pagePaymentReqDto.setErrorMsg(e.getMessage());
            return pagePaymentReqDto;
        } catch (Exception e) {
            log.error("create.error,error code:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("order.create.error"));
        }
        Response<Map<String, PagePaymentReqDto>> result = orderService.createOrder(orderCommitSubmitDto,
                selectedCardInfo, user);
        if (result.isSuccess()) {
            return result.getResult().get("result");
        } else {
            pagePaymentReqDto.setErrorMsg(result.getError());
            return pagePaymentReqDto;
        }
    }

    /**
     * 支付临时使用 add by wujiao
     */
    @RequestMapping(value = "/demoPay", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String demoPay(@RequestBody OrderCommitSubmitDto orderCommitSubmitDto) {
        try {
            orderService.demoPay(orderCommitSubmitDto.getOrderId(), orderCommitSubmitDto.getPayFlag(),
                    UserUtil.getUser());
            switch (orderCommitSubmitDto.getPayFlag()) {
                case "0":
                    return Contants.SUB_ORDER_STATUS_0308;
                case "1":
                    return Contants.SUB_ORDER_STATUS_0307;
                case "2":
                    return Contants.SUB_ORDER_STATUS_0305;
                default:
                    return Contants.SUB_ORDER_STATUS_0308;
            }
        } catch (IllegalArgumentException e) {
            log.error("create.error,error code:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
        } catch (Exception e) {
            log.error("create.error,error code:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("order.create.error"));
        }
    }


    /**
     * 分页查询，根据类型查询
     *
     * @param pageNo
     * @param size
     * @param mallType
     * @return
     */
    @RequestMapping(method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Pager<OrderInfoDto> findOrderByPersonalCenter(Integer pageNo, Integer size, String mallType) {
        // 获取用户
        User user = UserUtil.getUser();

        // 调用接口
        Response<Pager<OrderInfoDto>> result = orderService.find(pageNo, size, null, null, null, null, null, null,
                null, null, null, null, null, null, null, null, null, mallType, user);

        if (result.isSuccess()) {
            return result.getResult();
        }

        log.error("insert.error, {},error code:{}", mallType, result.getError());
        throw new ResponseException(500, messageSources.get(result.getError()));

    }

    /**
     * 更新订单状态 取消订单
     *
     * @param ordermainId
     * @return
     */
    @RequestMapping(value = "/updateOrder", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public  Map<String, Object> cancelOrder(String ordermainId) {
        User user = UserUtil.getUser();
        String id = user.getId();
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("ordermainId", ordermainId);
        paramMap.put("id", id);
        Response<Map<String, Object>> result = orderService.updateOrderMall(paramMap);
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("failed to cancelOrder{},error code:{}", ordermainId, result.getError());
        throw new ResponseException(500, messageSources.get(result.getError()));
    }

    /**
     * 商城用户提醒订单发货
     *
     * @param orderId
     * @return
     */
    @RequestMapping(value = "/remind", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean remind(String orderId) {
        User user = UserUtil.getUser();
        String id = user.getId();
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("orderId", orderId);
        paramMap.put("id", id);
        Response<Map<String, Boolean>> result = orderService.updateOrderRemind(orderId, id);
        if (result.isSuccess()) {
            if (result.getResult().get("result")) {
                return Boolean.TRUE;
            } else {
                return Boolean.FALSE;
            }
        }
        log.error("failed to remind{},error code:{}", orderId, result.getError());
        throw new ResponseException(500, messageSources.get(result.getError()));
    }

    /**
     * 查询物流信息
     *
     * @param orderId
     * @return
     */
    @RequestMapping(value = "/watchTrans", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public OrderTransModel watchTrans(String orderId) {
        Response<OrderTransModel> result = orderService.findOrderTrans(orderId);
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("failed to watchTrans{},error code:{}", orderId, result.getError());
        throw new ResponseException(500, messageSources.get(result.getError()));
    }

    /**
     * 查询退货详情
     *
     * @param orderId
     * @return
     */
    @RequestMapping(value = "/watchRevoke", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public OrderReturnDetailDto watchRevoke(String orderId) {
        Response<OrderReturnDetailDto> result = orderService.findOrderReturnDetail(orderId);
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("failed to watchRevoke{},error code:{}", orderId, result.getError());
        throw new ResponseException(500, messageSources.get(result.getError()));
    }

    /**退货撤单
     *
     * @param orderId
     * @param season
     * @param supplement
     * @param typeFlag
     * @return
     */
    @RequestMapping(value = "/revoke", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String,Object>revoke(String orderId, String season, String supplement, String typeFlag) {
        try {
            User user = UserUtil.getUser();
            String userId = user.getId();
            Response<Map<String, Object>> result = new Response<>();
            Map<String, String> paramMap = new HashMap<>();
            checkArgument(StringUtils.isNotBlank(orderId), "orderId.is.null");
            checkArgument(StringUtils.isNotBlank(season), "orderId.is.null");
            checkArgument(StringUtils.isNotBlank(typeFlag), "typeFlag.is.null");
            checkArgument(StringUtils.isNotBlank(userId), "userId.is.null");
            paramMap.put("orderId", orderId);
            paramMap.put("season", season);
            paramMap.put("supplement", supplement);
            paramMap.put("typeFlag", typeFlag);
            paramMap.put("userId", userId);
            switch (typeFlag){
                case Contants.SUB_ORDER_STATUS_0335:
                    result = orderService.returnOrderMall(paramMap);
                    break;
                case Contants.SUB_ORDER_STATUS_0310:
                    result = orderService.returnOrderMall(paramMap);
                    break;
                case Contants.SUB_ORDER_STATUS_0308:
                    result = orderService.revokeOrderMall(paramMap);
                    break;
                default:
                    throw new ResponseException(500, messageSources.get("typeFlag.be.wrong"));
            }
            if (result.isSuccess()) {
                 return result.getResult();
            }
            log.error("failed to revoke{},error code:{}", orderId,season, supplement,typeFlag,result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }catch (IllegalArgumentException e){
            log.error("failed to revoke, error code::{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get(e.getMessage()));
        }
    }

    /**
     * 通过订单id查询订单状态
     *
     * @param orderId
     * @return
     * @Add by Liuhan
     */
    @RequestMapping(value = "/{orderId}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public OrderSubModel findBrandByName(@PathVariable String orderId) {
        try {
            // 校验
            checkArgument(StringUtils.isNotBlank(orderId), "id is null");
            OrderSubModel result = orderService.findOrderId(orderId);
            return result;
        } catch (IllegalArgumentException e) {
            log.error("select.errror，erro:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get(e.getMessage()));
        } catch (Exception e) {
            log.error("select.errror，erro:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get("create.error"));
        }
    }

    /***
     * 获取查看物流信息的url
     *
     * @return
     */
    @RequestMapping(value = "/queryLogisticsUrl")
    @ResponseBody
    public String queryLogisticsUrl() {
        return expressUrl;
    }
}
