package cn.com.cgbchina.web.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.related.model.TblParametersModel;
import cn.com.cgbchina.related.service.BusinessService;
import cn.com.cgbchina.rest.provider.model.user.CustCarDel;
import cn.com.cgbchina.rest.provider.model.user.CustCarDelIds;
import cn.com.cgbchina.rest.provider.model.user.CustCarDelReturn;
import cn.com.cgbchina.rest.provider.model.user.CustCarUpdate;
import cn.com.cgbchina.rest.provider.model.user.CustCarUpdateReturn;
import cn.com.cgbchina.rest.visit.model.coupon.CouponInfo;
import cn.com.cgbchina.trade.dto.CartItemDto;
import cn.com.cgbchina.trade.dto.VoucherInfoDto;
import cn.com.cgbchina.trade.service.CartService;
import cn.com.cgbchina.trade.service.RedisService;
import com.google.common.base.Predicate;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Collections2;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.Collection;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/api/cart")
@Slf4j
public class Carts {

    private final CartService cartService;
    private final MessageSources messageSources;
    @Autowired
    private RedisService redisService;
    @Autowired
    private GoodsService goodsService;
    @Resource
    BusinessService businessService;

    @Autowired
    public Carts(CartService cartService,  MessageSources messageSources) {
        this.cartService = cartService;
        this.messageSources = messageSources;
    }

    /**
     * 查询购物车数量
     *
     * @return
     */
    @RequestMapping(value = "/count", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<Integer> count() {
        User user = UserUtil.getUser();
        Response<Integer> response = Response.newResponse();
        Integer cartCount = 0;
        if (user == null) {
            cartCount = 0;
        } else {
            Response<Integer> countR = cartService.findCustCartNumByUser(user);
            if (countR.isSuccess()) {
                cartCount = countR.getResult();
            } else {
                log.error("get permanent count failed, cause:{}", countR.getError());
                throw new ResponseException(500, messageSources.get(countR.getError()));
            }
        }
        response.setResult(cartCount);
        return response;
    }

    /**
     * 购物车编辑
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/updateCount", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public CustCarUpdateReturn updateCount(@RequestBody CustCarUpdate custCarUpdate) {
        Response<CustCarUpdateReturn> response = cartService.updateCartInfo(custCarUpdate);
        if (response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to update ,error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 购物车删除
     *
     * @param ids 删除购物车信息
     * @return
     */
    @RequestMapping(value = "/delete", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String delete(@RequestParam("ids") String ids) {
        CustCarDel custCarDel = new CustCarDel();
        try {
            String[] arrayIds = ids.split(",");
            List<CustCarDelIds> list = Lists.newArrayList();
            for (String id : arrayIds) {
                CustCarDelIds custCarDelIds = new CustCarDelIds();
                custCarDelIds.setId(id);
                list.add(custCarDelIds);
            }
            custCarDel.setIds(list);
            Response<CustCarDelReturn> response = cartService.deleteCartInfo(custCarDel);
            if (response.isSuccess()) {
                return "ok";
            }
            log.error("failed to delete CustCarDelVO {},error code:{}", custCarDel, response.getError());
            throw new ResponseException(500, messageSources.get(response.getError()));
        } catch (IllegalArgumentException e) {
            log.error("failed to create {}, error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get(e.getMessage()));
        } catch (IllegalStateException e) {
            log.error("failed to create {}, error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get(e.getMessage()));
        } catch (Exception e) {
            log.error("failed to create {},error code:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get(messageSources.get(e.getMessage())));
        }
    }

    /**
     * 获取最新的优惠券信息
     * @return
     */
    @RequestMapping(value = "/getNewCoupons", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<VoucherInfoDto> getNewCoupons() {
        try {
            User user = UserUtil.getUser();
            List<CouponInfo> couponInfoList_user;
            Response<List<CouponInfo>> couponInfoResponse = redisService.getCoupons(user.getId(),
                    user.getCertType(), user.getCertNo());
            if (couponInfoResponse.isSuccess()) {
                couponInfoList_user = couponInfoResponse.getResult();
            } else {
                log.error("trade.cart.get.voucher.info");
                throw new ResponseException(500, messageSources.get("trade.cart.get.voucher.info"));
            }
            List<VoucherInfoDto> userHaveVoucher = Lists.newArrayList();
            if (couponInfoList_user.size() > 0){
                for (CouponInfo couponInfReceived : couponInfoList_user) {
                    VoucherInfoDto voucherInfoDto = new VoucherInfoDto();
                    voucherInfoDto.setVoucherId(couponInfReceived.getProjectNO()); // 大类
                    voucherInfoDto.setVoucherNo(couponInfReceived.getPrivilegeId());  //id
                    voucherInfoDto.setVoucherName(couponInfReceived.getPrivilegeName());
                    String money = couponInfReceived.getPrivilegeMoney() == null ? "0"
                            : couponInfReceived.getPrivilegeMoney().toString();
                    voucherInfoDto.setVoucherFigure(money);
                    voucherInfoDto.setStartTime(couponInfReceived.getBeginDate());
                    voucherInfoDto.setEndTime(couponInfReceived.getEndDate());
                    voucherInfoDto.setLimitMoney(couponInfReceived.getLimitMoney());
                    // 用户已领取未使用的优惠券 （按照小类存放，1大类对应多张）  用途：选择使用
                    // 前台用  0：未使用未选中
                    // 前台用  1：未使用已选中
                    voucherInfoDto.setIsReceived(0); // 未使用
                    userHaveVoucher.add(voucherInfoDto);
                }
            }
            return userHaveVoucher;
        } catch (Exception e) {
            log.error("trade.cart.get.voucher.info", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get(messageSources.get(e.getMessage())));
        }
    }

    /**
     * 广发商城 购物车点击结算校验是否可以支付
     */
    @RequestMapping(value = "/checkParameters", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<Boolean> checkParameters(String orderTypeId) {
        if (StringUtils.isBlank(orderTypeId) || ((!Contants.BUSINESS_TYPE_JF.equals(orderTypeId)) && (!Contants.BUSINESS_TYPE_YG.equals(orderTypeId)))) {
            log.error("failed to checkParameters,error orderTypeId:{}", orderTypeId);
            throw new ResponseException(500, messageSources.get("业务类型参数异常"));
        }
        //商城web端
        String sourceId = Contants.ORDER_SOURCE_ID_MALL;
        //登录信息0 ，支付信息 2
        Integer parametersType = 2;
        Response<List<TblParametersModel>> bussinessResponse = businessService.findParameters(parametersType, orderTypeId, sourceId);
        if (!bussinessResponse.isSuccess()) {
            log.error("businessService.findJudgeQT.error,error code: {}", bussinessResponse.getError());
            throw new ResponseException(500, messageSources.get(bussinessResponse.getError()));
        }
        if (bussinessResponse.getResult() == null || bussinessResponse.getResult().isEmpty()) {
            log.error("businessServic.findJudgeQT.error,result be null");
            throw new ResponseException(500, messageSources.get("获取业务启停数据失败"));
        }
        //业务上 只存在一条
        TblParametersModel tblParametersModel = bussinessResponse.getResult().get(0);
//			0启动 1停止
        if (tblParametersModel.getOpenCloseFlag() == null || 1 == tblParametersModel.getOpenCloseFlag()) {
            if (StringUtils.isBlank(tblParametersModel.getPrompt())) {
                if (Contants.BUSINESS_TYPE_JF.equals(orderTypeId)) {
                    throw new ResponseException(500, messageSources.get("当前积分商城不允许支付"));
                } else {
                    throw new ResponseException(500, messageSources.get("当前广发商城不允许支付"));
                }
            } else {
                throw new ResponseException(500, messageSources.get(tblParametersModel.getPrompt()));
            }
        }
        Response<Boolean> response = Response.newResponse();
        response.setResult(Boolean.TRUE);
        return response;
    }

}
