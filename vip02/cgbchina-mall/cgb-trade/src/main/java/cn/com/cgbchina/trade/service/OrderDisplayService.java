package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.KeyReader;
import cn.com.cgbchina.common.utils.SignManager;
import cn.com.cgbchina.common.utils.SignUtil;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.model.PromotionPayWayModel;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.item.service.PromotionPayWayService;
import cn.com.cgbchina.rest.visit.model.coupon.CouponInfo;
import cn.com.cgbchina.trade.dao.TblEspCustCartDao;
import cn.com.cgbchina.trade.dto.CarInfoDto;
import cn.com.cgbchina.trade.dto.OrderCommitInfoDto;
import cn.com.cgbchina.trade.model.AuctionRecordModel;
import cn.com.cgbchina.trade.model.TblEspCustCartModel;
import com.fasterxml.jackson.databind.JavaType;
import com.google.common.base.Function;
import com.google.common.base.Predicate;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.*;
import com.spirit.common.model.Response;
import com.spirit.exception.ServiceException;
import com.spirit.user.User;
import com.spirit.user.UserAccount;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.security.spec.InvalidKeySpecException;
import java.util.*;
import java.util.concurrent.*;

/**
 * Created by lvzd on 2016/9/20.
 */
@Slf4j
public class OrderDisplayService {
    @Resource
    PromotionPayWayService promotionPayWayService;
    @Resource
    GoodsPayWayService goodsPayWayService;
    @Resource
    GoodsService goodsService;
    @Resource
    ItemService itemService;
    @Resource
    MallPromotionService mallPromotionService;
    @Resource
    AuctionRecordService auctionRecordService;
    @Resource
    TblEspCustCartDao tblEspCustCartDao;
    @Resource
    private RedisService redisService;
    protected static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
    protected static JavaType carInfoType = jsonMapper.createCollectionType(ArrayList.class, CarInfoDto.class);

    /**
     * 广发商城提交订单画面初期显示
     *
     * @param skus 购物车id，优惠券
     * @param user
     * @return
     */
    protected Response<Map<String, Object>> findOrderInfoForCommitOrder(String skus, User user) {
        Response<Map<String, Object>> response = Response.newResponse();
        try {
            if (Strings.isNullOrEmpty(skus)) {
                throw new IllegalArgumentException("没有选择单品");
            }
            List<CarInfoDto> carInfoDtos = jsonMapper.fromJson(skus, carInfoType);
            Map<String, Object> result = Maps.newHashMap();
            String payType = "";
            if ("0".equals(carInfoDtos.get(0).getK())) {// 0元秒杀
                log.info("广发商城提交订单画面初期显示 0元秒杀 start");
                payType = initMiaosha(result, carInfoDtos.get(0).getI().toString(), user);
            } else if ("1".equals(carInfoDtos.get(0).getK())) {// 荷兰拍
                log.info("广发商城提交订单画面初期显示 荷兰拍 start");
                payType = initHelanpai(result, carInfoDtos, user);
            } else {
                log.info("广发商城提交订单画面初期显示 start");
                payType = initOther(result, carInfoDtos, user);
            }
            // 取得可支付卡号一览
            List<Map<String, String>> cardNos = getCardNoInfo(payType, user);
            result.put("cardNos", cardNos);
            response.setResult(result);
            log.info("广发商城提交订单画面初期显示 end");
            return response;
        }catch (NumberFormatException e) {
            log.error("OrderServiceImpl findOrderInfo query error{}", Throwables.getStackTraceAsString(e));
            response.setError("OrderServiceImpl.findOrderInfo.query.error.");
            return response;
        } catch (IllegalArgumentException e) {
            log.error("OrderServiceImpl findOrderInfo query error{}", Throwables.getStackTraceAsString(e));
            response.setError(e.getMessage());
            return response;
        } catch (InvalidKeySpecException e) {
            log.error("OrderServiceImpl findOrderInfo query error{}", Throwables.getStackTraceAsString(e));
            response.setError("OrderServiceImpl.findOrderInfo.query.error.");
            return response;
        } catch (ServiceException e) {
            Map<String, Object> result = Maps.newHashMap();
            result.put("orderIsNull", "1");
            response.setResult(result);
            return response;
        }catch (Exception e) {
            log.error("OrderServiceImpl findOrderInfo query error{}", Throwables.getStackTraceAsString(e));
            response.setError("OrderServiceImpl.findOrderInfo.query.error.");
            return response;
        }
    }

    private static List<String> transFormList(List<CarInfoDto> cartInfoList) {
        Predicate<String> predicate = new Predicate<String>() {
            @Override
            public boolean apply(String input) {
                return !input.isEmpty();
            }
        };
        List<String> couponids = Lists.transform(cartInfoList, new Function<CarInfoDto, String>() {
            @Override
            public String apply(@NotNull CarInfoDto input) {
                return input.getC();
            }
        });
        Collection<String> result = Collections2.filter(couponids, predicate);
        return Lists.newArrayList(result);
    }

    /**
     *
     * @param result
     * @param cartInfoList
     * @param user
     * @return
     */
    private String initOther(Map<String, Object> result, List<CarInfoDto> cartInfoList, User user) throws InterruptedException, ExecutionException {
        OrderInfo orderInfo = new OrderInfo();
        orderInfo.initCarInfo();
        // 查询优惠券
        List<String> couponids = transFormList(cartInfoList);
        List<CouponInfo> couponInfoList = null;
        if (!couponids.isEmpty()) {
            // 查询优惠券
            Response<List<CouponInfo>> listResponse = redisService.getNewCouponInfos(
                    user.getCertType(), user.getCertNo(),
                    Byte.valueOf("2"));

            if (listResponse == null || !listResponse.isSuccess()) {
                throw new IllegalArgumentException("优惠券信息异常");
            }
            couponInfoList = listResponse.getResult();
        }

        if (cartInfoList.size() == 1) {
            orderInfo.makeCarInfo(singleCarItem(cartInfoList.get(0), user, couponInfoList));
        } else {
            // 多线程执行
            ExecutorService executorService = Executors.newFixedThreadPool(cartInfoList.size());
            CompletionService completionService = new ExecutorCompletionService(executorService);
            for (CarInfoDto carInfoDto : cartInfoList) {
                completionService.submit(callSingleCarItem(carInfoDto, user, couponInfoList));
            }
            for (int j = 0; j < cartInfoList.size(); j++) {
                OrderInfo ret = (OrderInfo) completionService.take().get();
                if (ret.getError() != null) {
                    throw new IllegalArgumentException(ret.getError());
                }
                orderInfo.makeCarInfo(ret);
            }
            executorService.shutdown();
        }
        // 判断商品类型
        if (orderInfo.getMaterials().contains(Boolean.TRUE)) {
            result.put("goodsType", Contants.SUB_ORDER_TYPE_00);
        } else {
            result.put("goodsType", orderInfo.getGoodsType());
            result.put("userName", user.getName());
            result.put("phoneNo", user.getMobile());
        }
        // 遍历匹配好的满减活动Id,购物车Id集合
        if (orderInfo.getMjCartMap().size() > 0) {
            manjian(orderInfo);
        }

        for (TblEspCustCartModel cartModel : orderInfo.getCartModelList()) {
            createOrderCommitDto(cartModel, orderInfo);
        }
        orderInfo.setTotal(orderInfo.getTotal().add(orderInfo.getMjPriceTotal())); // 总价 + 满减商品总售价
        result.put("itemInfoList", orderInfo.getOrderCommitInfoDtos());
        result.put("payType", orderInfo.getPayType());
        result.put("total", orderInfo.getTotal()); // 满减此处计算（161126修改展示原价，增加满减优惠展示）
        result.put("deduction", orderInfo.getDeduction());
        result.put("voucherPrice", orderInfo.getVoucherPriceTotal());
        result.put("realPayment", orderInfo.getTotal().subtract(orderInfo.getDeduction()).subtract(orderInfo.getVoucherPriceTotal()).subtract(orderInfo.getDisPriceTotal()));// 实付款 = 订单总额 - 积分抵扣额 - 优惠券 - 满减总减价
        result.put("miaoFlag", "0");// 是否0元秒杀
        result.put("mjActivity", orderInfo.getDisPriceTotal());// 满减活动优惠
        return orderInfo.getPayType();
    }

    /**
     * 异步执行处理
     */
    private Callable<OrderInfo> callSingleCarItem(final CarInfoDto carInfo, final User user, final List<CouponInfo> couponInfoList) {
        Callable<OrderInfo> ret = new Callable<OrderInfo>() {
            @Override
            public OrderInfo call() throws Exception {
                try {
                    return singleCarItem(carInfo, user, couponInfoList);
                } catch (IllegalArgumentException e) {
                    OrderInfo error = new OrderInfo();
                    error.setError(e.getMessage());
                    return error;
                }
            }
        };
        return ret;
    }

    private OrderInfo singleCarItem(CarInfoDto carInfoDto, User user, List<CouponInfo> couponInfoList) {
        OrderInfo orderInfo = new OrderInfo();

        TblEspCustCartModel cartModel = tblEspCustCartDao.findById(carInfoDto.getI().toString());
        if (cartModel == null) {
            throw new ServiceException("购物车已没有此商品");
        }
        ItemModel itemMdl = itemService.findById(cartModel.getItemId());
        if (itemMdl != null) {
            cartModel.setItemList(Lists.newArrayList(itemMdl));
        } else {
            throw new IllegalArgumentException("没找到对应商品");
        }
        Response<GoodsModel> goodsModelResponse = goodsService.findById(itemMdl.getGoodsCode());
        if (!goodsModelResponse.isSuccess() || goodsModelResponse.getResult() == null) {
            throw new IllegalArgumentException("查询商品情报失败");
        }
        orderInfo.setGoodsModel(goodsModelResponse.getResult());

        Response<MallPromotionResultDto> promotionResultDtoResponse = mallPromotionService.findPromByItemCodes("1", cartModel.getItemId(), null);
        if (!promotionResultDtoResponse.isSuccess()) {
            throw new IllegalArgumentException("参加活动的商品发生变化");
        }
        MallPromotionResultDto promotionResultDto = promotionResultDtoResponse.getResult();
        // 购物车Id和活动
        if (promotionResultDto != null) {
            orderInfo.setMallPromotionResultDto(promotionResultDto);
        }
        // 满减
        if (promotionResultDto != null && promotionResultDto.getPromType() != 20) {
            Map<String, Object> param = Maps.newHashMap();
            param.put("goodsPaywayId", cartModel.getGoodsPaywayId());
            param.put("promId", promotionResultDto.getId());
            Response<PromotionPayWayModel> payWayModelResponse = promotionPayWayService.findPomotionPayWayInfoByParam(param);
            if (!payWayModelResponse.isSuccess() || payWayModelResponse.getResult() == null) {
                throw new IllegalArgumentException("活动支付方式发生变化请重新提交");
            }
            orderInfo.setPromotionPayWayModel(payWayModelResponse.getResult());
        }
        Response<TblGoodsPaywayModel> goodsPaywayModelResponse = goodsPayWayService.findGoodsPayWayInfo(cartModel.getGoodsPaywayId());
        if (!goodsPaywayModelResponse.isSuccess() || goodsPaywayModelResponse.getResult() == null) {
            throw new IllegalArgumentException("商品支付方式发生变化请重新提交");
        }
        orderInfo.setTblGoodsPaywayModel(goodsPaywayModelResponse.getResult());

        if (Contants.SUB_ORDER_TYPE_00.equals(goodsModelResponse.getResult().getGoodsType())) {
            orderInfo.setMaterial(true);
        }
        //1：信用卡；2借记卡
        String payType = cartModel.getOrdertypeId().equals(Contants.BUSINESS_TYPE_YG) ? "2" :
                cartModel.getOrdertypeId().equals(Contants.BUSINESS_TYPE_FQ) ? "1" : "";
        orderInfo.setPayType(payType);
        if (couponInfoList != null && !couponInfoList.isEmpty()) {
            // 查询优惠券
            for (CouponInfo couponInfo : couponInfoList) {
                if (couponInfo.getPrivilegeId().equals(carInfoDto.getC())) {
                    cartModel.setVoucherId(couponInfo.getProjectNO());
                    cartModel.setVoucherNo(couponInfo.getPrivilegeId());
                    cartModel.setVoucherName(couponInfo.getPrivilegeName());
                    cartModel.setVoucherPrice(couponInfo.getPrivilegeMoney() == null ? new BigDecimal(0) : couponInfo.getPrivilegeMoney());
                    break;
                }
            }
        }  else {
            cartModel.setVoucherId("");
            cartModel.setVoucherNo("");
            cartModel.setVoucherName("");
            cartModel.setVoucherPrice(new BigDecimal(0));
        }

        // 购物车Id和购物车
        orderInfo.setTblEspCustCartModel(cartModel);
        return orderInfo;
    }

    @Setter
    @Getter
    @ToString
    private class OrderInfo implements Serializable {
        private List<OrderCommitInfoDto> orderCommitInfoDtos;
        private String payType;
        private Map<Long, BigDecimal> cartMjPriceTotal;
        // 所有参加满减的售价总和
        private BigDecimal mjPriceTotal;
        // 所有参加满减的减价总和
        private BigDecimal disPriceTotal;
        private BigDecimal total;// 订单总额
        private BigDecimal deduction;// 积分抵扣金额
        private BigDecimal voucherPriceTotal;// 优惠券

        private TblGoodsPaywayModel tblGoodsPaywayModel;
        private PromotionPayWayModel promotionPayWayModel;
        private MallPromotionResultDto mallPromotionResultDto;
        private TblEspCustCartModel tblEspCustCartModel;
        private GoodsModel goodsModel;
        private String goodsType;
        private boolean material = false;
        private List<Boolean> materials;

        private Map<String, String> goodsNameMap;
        private Map<Long, TblGoodsPaywayModel> goodsPaywayMap;
        private Map<Long, PromotionPayWayModel> promotionPayWayModelMap;
        private Map<Long, MallPromotionResultDto> promotionMap;
        private Map<Long, TblEspCustCartModel> cartModelMap;
        private Map<Integer, List<Long>> mjCartMap;
        private List<TblEspCustCartModel> cartModelList;
        private String error;

        public void addCartMjPriceTotal(Long key, BigDecimal value) {
            if (cartMjPriceTotal == null) {
                cartMjPriceTotal = Maps.newHashMap();
            }
            cartMjPriceTotal.put(key, value);
        }

        private void addTblGoodsPaywayModel(Long id, TblGoodsPaywayModel tblGoodsPaywayModel) {
            if (tblGoodsPaywayModel == null) return;
            if (goodsPaywayMap == null) {
                goodsPaywayMap = Maps.newHashMap();
            }
            goodsPaywayMap.put(id, tblGoodsPaywayModel);
        }
        private void addPromotionPayway(Long id, PromotionPayWayModel promotionPayWayModel) {
            if (promotionPayWayModel == null) return;
            if (promotionPayWayModelMap == null) {
                promotionPayWayModelMap = Maps.newHashMap();
            }
            promotionPayWayModelMap.put(id, promotionPayWayModel);

        }
        private void addGoodsName(String goodCode, String goodsName) {
            if (goodCode == null || goodsName == null) return;
            if (goodsNameMap == null) {
                goodsNameMap = Maps.newHashMap();
            }
            goodsNameMap.put(goodCode, goodsName);
        }
        private void addCarModel(TblEspCustCartModel carModel) {
            if (carModel == null) return;
            if (cartModelList == null) {
                cartModelList = Lists.newArrayList();
            }
            cartModelList.add(carModel);
        }

        private void addCarModelMap(Long key, TblEspCustCartModel carModel) {
            if (cartModelMap == null) {
                cartModelMap = Maps.newHashMap();
            }
            cartModelMap.put(key, carModel);
        }
        private void addPromotionResultDto(Long id, MallPromotionResultDto mallPromotionResultDto) {
            if (mallPromotionResultDto == null) return;
            if (promotionMap == null) {
                promotionMap = Maps.newHashMap();
            }
            promotionMap.put(id, mallPromotionResultDto);

            if (mallPromotionResultDto.getId() != null && mallPromotionResultDto.getPromType() == 20) {
                if (mjCartMap == null) {
                    mjCartMap = Maps.newHashMap();
                }
                if (mjCartMap.containsKey(mallPromotionResultDto.getId())) {
                    mjCartMap.get(mallPromotionResultDto.getId()).add(id);
                } else {
                    mjCartMap.put(mallPromotionResultDto.getId(), Lists.newArrayList(id));
                }
            }
        }

        public void addTotal(BigDecimal tmp) {
            this.total = this.total.add(tmp);
        }
        public void addDeduction(BigDecimal tmp) {
            this.deduction = this.deduction.add(tmp);
        }
        public void addVoucherPriceTotal(BigDecimal tmp) {
            this.voucherPriceTotal = this.voucherPriceTotal.add(tmp);
        }
        public void addMjPriceTotal(BigDecimal price) {
            this.mjPriceTotal = this.mjPriceTotal.add(price);
        }
        public void addMjDisPriceTotal(BigDecimal disPrice) {
            this.disPriceTotal = this.disPriceTotal.add(disPrice);
        }
        public void addOrderCommitInfoDto(OrderCommitInfoDto orderCommitInfoDto) {
            if (orderCommitInfoDto == null) return;
            if (this.orderCommitInfoDtos == null) {
                this.orderCommitInfoDtos = Lists.newArrayList();
            }
            this.orderCommitInfoDtos.add(orderCommitInfoDto);
        }
        public void addMaterials(boolean material) {
            if (materials == null) {
                materials = Lists.newArrayList();
            }
            materials.add(material);
        }
        public void initCarInfo() {
            this.goodsNameMap = Maps.newHashMap();
            this.goodsPaywayMap = Maps.newHashMap();
            this.promotionMap = Maps.newHashMap();
            this.cartModelMap = Maps.newHashMap();
            this.mjCartMap = Maps.newHashMap();
            this.cartModelList = Lists.newArrayList();
            this.orderCommitInfoDtos = Lists.newArrayList();
            this.cartMjPriceTotal = Maps.newHashMap();
            this.mjPriceTotal = new BigDecimal(0);
            this.disPriceTotal = new BigDecimal(0);
            this.total = new BigDecimal(0);// 订单总额
            this.deduction = new BigDecimal(0);// 积分抵扣金额
            this.voucherPriceTotal = new BigDecimal(0);// 优惠券
            this.materials = Lists.newArrayList();
        }
        public void makeCarInfo(OrderInfo orderInfo) {
            addGoodsName(orderInfo.getGoodsModel().getCode(), orderInfo.getGoodsModel().getName());
            this.addMaterials(orderInfo.isMaterial());
            this.setGoodsType(orderInfo.getGoodsModel().getGoodsType());
            this.setPayType(orderInfo.getPayType());
            addCarModel(orderInfo.getTblEspCustCartModel());
            addPromotionResultDto(orderInfo.getTblEspCustCartModel().getId(), orderInfo.getMallPromotionResultDto());
            addTblGoodsPaywayModel(orderInfo.getTblEspCustCartModel().getId(), orderInfo.getTblGoodsPaywayModel());
            addPromotionPayway(orderInfo.getTblEspCustCartModel().getId(), orderInfo.getPromotionPayWayModel());
            this.addCarModelMap(orderInfo.getTblEspCustCartModel().getId(), orderInfo.getTblEspCustCartModel());
        }
    }
    private void createOrderCommitDto(TblEspCustCartModel cartModel, OrderInfo orderInfo) {

        // 取得购物车中内容
        String instalments = "";// 分期数
        BigDecimal goodsPrice = new BigDecimal(0);// 售价
        OrderCommitInfoDto orderCommitInfoDto = new OrderCommitInfoDto();
        ItemModel itemModel = cartModel.getItemList().get(0);
        BeanMapper.copy(itemModel, orderCommitInfoDto);
        orderCommitInfoDto.setMid(itemModel.getMid());
        // 商品数量
        orderCommitInfoDto.setItemCount(Integer.parseInt(cartModel.getGoodsNum()));
        MallPromotionResultDto promotionResultDto = orderInfo.getPromotionMap().get(cartModel.getId());
        TblGoodsPaywayModel goodsPaywayModel = orderInfo.getGoodsPaywayMap().get(cartModel.getId());
        // 活动
        if (promotionResultDto != null && promotionResultDto.getId() != null) {
            orderCommitInfoDto.setPromotion(promotionResultDto);
            // 折扣
            if (promotionResultDto.getPromType() == 10) {
                goodsPrice = promotionResultDto.getPromItemResultList().get(0).getPrice() == null ? new BigDecimal(0) :
                        promotionResultDto.getPromItemResultList().get(0).getPrice().multiply(promotionResultDto.getRuleDiscountRate()).divide(new BigDecimal(1), 2, BigDecimal.ROUND_DOWN);
                // 满减
            } else if (promotionResultDto.getPromType() == 20) {
                goodsPrice = promotionResultDto.getPromItemResultList().get(0).getPrice() == null ? new BigDecimal(0) : promotionResultDto.getPromItemResultList().get(0).getPrice();
                if (orderInfo.getCartMjPriceTotal() != null && orderInfo.getCartMjPriceTotal().size() > 0 && orderInfo.getCartMjPriceTotal().containsKey(cartModel.getId())) {
                    orderCommitInfoDto.setMjDisPrice(orderInfo.getCartMjPriceTotal().get(cartModel.getId()));
                }
                // 团购
            } else if (promotionResultDto.getPromType() == 40) {
                goodsPrice = promotionResultDto.getPromItemResultList().get(0).getLevelPrice() == null ? new BigDecimal(0) : promotionResultDto.getPromItemResultList().get(0).getLevelPrice();
            } else {
                goodsPrice = promotionResultDto.getPromItemResultList().get(0).getPrice() == null ? new BigDecimal(0) : promotionResultDto.getPromItemResultList().get(0).getPrice();
            }
            if (promotionResultDto.getPromType() != 20) {
                PromotionPayWayModel promotionPayWayModel = orderInfo.getPromotionPayWayModelMap().get(cartModel.getId());
                instalments = promotionPayWayModel.getStagesCode() == null ? "1" : String.valueOf(promotionPayWayModel.getStagesCode());
                // 支付方式Id
                orderCommitInfoDto.setPayWayId(promotionPayWayModel.getGoodsPaywayId());
            } else {
                instalments = goodsPaywayModel.getStagesCode() == null ? "1" : String.valueOf(goodsPaywayModel.getStagesCode());
                // 支付方式Id
                orderCommitInfoDto.setPayWayId(goodsPaywayModel.getGoodsPaywayId());
            }
            // 非活动
        } else {
            orderCommitInfoDto.setPromotion(new MallPromotionResultDto());
            goodsPrice = goodsPaywayModel.getGoodsPrice() == null ? new BigDecimal(0) : goodsPaywayModel.getGoodsPrice();
            instalments = goodsPaywayModel.getStagesCode() == null ? "1" : String.valueOf(goodsPaywayModel.getStagesCode());
            // 支付方式Id
            orderCommitInfoDto.setPayWayId(goodsPaywayModel.getGoodsPaywayId());
        }
        //原始价格
        orderCommitInfoDto.setOriPrice(goodsPaywayModel.getGoodsPrice() == null ? new BigDecimal(0) : goodsPaywayModel.getGoodsPrice());
        // 分期数
        orderCommitInfoDto.setInstalments(instalments);
        // 分期价格
        if (instalments != null && !instalments.equals("0")) {
            orderCommitInfoDto.setInstalmentsPrice(goodsPrice.divide(new BigDecimal(Integer.parseInt(instalments)), 2, BigDecimal.ROUND_DOWN));
        }

        // 实际价格
        orderCommitInfoDto.setPrice(goodsPrice);
        //1：信用卡
        if (Contants.CART_PAY_TYPE_1.equals(orderInfo.getPayType())) {
            // 固定积分
            if (cartModel.getFixBonusValue() != null && cartModel.getFixBonusValue() != 0L) {
                orderCommitInfoDto.setFixFlag(true);
                // 积分数
                orderCommitInfoDto.setJfCount(cartModel.getFixBonusValue() * orderCommitInfoDto.getItemCount());
                // 优惠后积分
                orderCommitInfoDto.setAfterDiscountJf(cartModel.getFixBonusValue() * orderCommitInfoDto.getItemCount());
                orderCommitInfoDto.setDisInstalmentsPrice(orderCommitInfoDto.getInstalmentsPrice());
            }
            // 非固定积分
            else {
                orderCommitInfoDto.setFixFlag(false);
                // 积分数
                orderCommitInfoDto.setJfCount(cartModel.getOriBonusValue() * orderCommitInfoDto.getItemCount());
                // 优惠后积分
                orderCommitInfoDto.setAfterDiscountJf(cartModel.getBonusValue() * orderCommitInfoDto.getItemCount());
                BigDecimal jfDiscount = orderCommitInfoDto.getJfCount() == 0l ? new BigDecimal(0) :
                        new BigDecimal(orderCommitInfoDto.getJfCount()).divide(new BigDecimal(cartModel.getSinglePoint()), 2, BigDecimal.ROUND_HALF_UP);
                // 总积分抵扣额
                orderInfo.addDeduction(jfDiscount);
                BigDecimal disinstalmentsPrice = ((orderCommitInfoDto.getPrice()).subtract(
                        jfDiscount.divide(new BigDecimal(orderCommitInfoDto.getItemCount()))).divide(new BigDecimal(instalments), 2, BigDecimal.ROUND_DOWN));
                orderCommitInfoDto.setDisInstalmentsPrice(disinstalmentsPrice);
            }
            // 单位积分
            orderCommitInfoDto.setSinglePrice(cartModel.getSinglePoint());
            // 折扣积分比例
            if (orderCommitInfoDto.getJfCount() != 0l) {
                orderCommitInfoDto.setDiscountPercent(new BigDecimal(orderCommitInfoDto.getAfterDiscountJf()).divide(new BigDecimal(orderCommitInfoDto.getJfCount()), 2, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal(10)));
            } else {
                orderCommitInfoDto.setDiscountPercent(new BigDecimal(10.00));
            }
            // 优惠券
            orderCommitInfoDto.setVoucherId(Strings.nullToEmpty(cartModel.getVoucherId()));
            orderCommitInfoDto.setVoucherNo(Strings.nullToEmpty(cartModel.getVoucherNo()));
            orderCommitInfoDto.setVoucherNm(Strings.nullToEmpty(cartModel.getVoucherName()));
            orderCommitInfoDto.setVoucherPrice(cartModel.getVoucherPrice() == null ? new BigDecimal(0) : cartModel.getVoucherPrice());
            // 总优惠券
            orderInfo.addVoucherPriceTotal(orderCommitInfoDto.getVoucherPrice());
        } else {
            //2借记卡
            orderCommitInfoDto.setJfCount(0l);
            orderCommitInfoDto.setDiscountPercent(new BigDecimal(10.00));
            orderCommitInfoDto.setSinglePrice(cartModel.getSinglePoint());
            orderCommitInfoDto.setAfterDiscountJf(0l);
            orderCommitInfoDto.setDisInstalmentsPrice(orderCommitInfoDto.getPrice());
            orderCommitInfoDto.setVoucherId("");
            orderCommitInfoDto.setVoucherNo("");
            orderCommitInfoDto.setVoucherNm("");
            orderCommitInfoDto.setVoucherPrice(new BigDecimal(0));
        }
        // 小计(因满减的单价经除法运算,合计有误差,故不参与求和)
        orderCommitInfoDto.setSubTotal((orderCommitInfoDto.getPromotion() != null &&
                orderCommitInfoDto.getPromotion().getId() != null &&
                orderCommitInfoDto.getPromotion().getPromType() == 20) ? new BigDecimal(0) :
                orderCommitInfoDto.getPrice().multiply(new BigDecimal(orderCommitInfoDto.getItemCount())));
        // 订单总额
        orderInfo.addTotal(orderCommitInfoDto.getSubTotal());
        // 商品名称
        orderCommitInfoDto.setGoodsName(orderInfo.getGoodsNameMap().get(itemModel.getGoodsCode()));
        // 购物车Id
        orderCommitInfoDto.setCartId(cartModel.getId().toString());
        orderCommitInfoDto.setGoodsCode(itemModel.getGoodsCode());
        orderCommitInfoDto.setImage1(itemModel.getImage1());

        // 用户等级名称
        orderCommitInfoDto.setCustmerNm(cartModel.getCustmerNm());
        // 返回的商品信息
        orderInfo.addOrderCommitInfoDto(orderCommitInfoDto);
    }
    private static class ValueComparator implements Comparator<Long> {
        Map<Long, BigDecimal> base;
        public ValueComparator(Map<Long, BigDecimal> base) {
            this.base = base;
        }
        public int compare(Long a, Long b) {
            if (base.get(a).compareTo(base.get(b)) >= 0) {
                return 1;
            } else {
                return -1;
            }
        }
    }

    /**
     * 满减活动订单信息
     * @param orderInfo
     */
    private static void manjian(OrderInfo orderInfo) {

        for (Map.Entry<Integer, List<Long>> entry : orderInfo.getMjCartMap().entrySet()) {
            Map<Long, BigDecimal> cartMjPrice = Maps.newHashMap();
            BigDecimal price = new BigDecimal(0);
            BigDecimal mjprice = new BigDecimal(0);
            BigDecimal mjTotalprice = new BigDecimal(0);
            Long cartId = null;
            for (Long id : entry.getValue()) {
                // 以参加此满减活动为一组的单品总价
                BigDecimal singlePrice = orderInfo.getPromotionMap().get(id).getPromItemResultList().get(0).getPrice();
                BigDecimal singleTotal = singlePrice.multiply(new BigDecimal(orderInfo.getCartModelMap().get(id).getGoodsNum()));
                TblEspCustCartModel cartModel = orderInfo.getCartModelMap().get(id);
                BigDecimal singleJF2Price = null;
                if (cartModel.getFixBonusValue() != null && cartModel.getFixBonusValue() != 0L) {
                    singleJF2Price = new BigDecimal("0");
                } else {
                    singleJF2Price = new BigDecimal(orderInfo.getCartModelMap().get(id).getOriBonusValue()).multiply(new BigDecimal(orderInfo.getCartModelMap().get(id).getGoodsNum())).
                            divide(new BigDecimal(orderInfo.getCartModelMap().get(id).getSinglePoint()), 2, BigDecimal.ROUND_HALF_UP);
                }
                price = price.add(singleTotal);
                if (singleTotal.subtract(singleJF2Price).intValue() == 0) continue;
                mjprice = mjprice.add(singleTotal);
                mjTotalprice = mjTotalprice.add(singleTotal.subtract(singleJF2Price));
                // 购物车Id,用于取购物车对应活动
                cartId = id;
                // 购物车Id,该购物车Id的单品总价
                cartMjPrice.put(id, singleTotal.subtract(singleJF2Price));
            }
            // 所有参加满减的售价总和
            orderInfo.addMjPriceTotal(price);
            if (cartMjPrice.size() ==  0)  {
                log.info("所有参加满减的售价总和：" + price + " " + " 所有参加满减的减价总和:" + 0);
                // 所有参加满减的减价总和
                orderInfo.addMjDisPriceTotal(new BigDecimal(0));
                return;
            }

            ValueComparator bvc =  new ValueComparator(cartMjPrice);
            TreeMap<Long, BigDecimal> sorted_map = new TreeMap<Long, BigDecimal>(bvc);
            sorted_map.putAll(cartMjPrice);

            BigDecimal disPrice = manjianDisPrice(orderInfo.getPromotionMap().get(cartId), mjTotalprice);
            int i = 1;
            BigDecimal totalAfterDisPrice = new BigDecimal(0);
            // 遍历购物车Id,总价集合
            for (Map.Entry<Long, BigDecimal> cartMjPriceEntry : sorted_map.entrySet()) {
                // 当循环不为最后一条记录时
                if (i != sorted_map.size()) {
                    // key: 购物车Id, value: 该购物车单品总价 - (该单品总价占参加该满减活动商品总价的比例 *　减价)  (该单品参加满减活动后的价钱)
                    BigDecimal carMjP = cartMjPriceEntry.getValue().divide(mjTotalprice, 2, BigDecimal.ROUND_DOWN).multiply(disPrice);
                    orderInfo.addCartMjPriceTotal(cartMjPriceEntry.getKey(), carMjP);
                    // 如果参加该满减活动购物车有多条,将每个单品满减活动后的价钱相加
                    totalAfterDisPrice = totalAfterDisPrice.add(carMjP);
                    // 当循环到最后一条时
                } else {
                    // 购物车大于一条
                    if (sorted_map.size() > 1) {
                        // 购物车Id, 总价 - 减价 - 以上所有单品的满减活动后价钱之和 (考虑到每个单品满减后之和与总满减的误差)
                        orderInfo.addCartMjPriceTotal(cartMjPriceEntry.getKey(), disPrice.subtract(totalAfterDisPrice));
                        // 购物车只有一条
                    } else {
                        // 购物车Id, 该单品参加满减活动后的价钱
                        orderInfo.addCartMjPriceTotal(cartMjPriceEntry.getKey(), disPrice);
                    }
                }
                i++;
            }
            log.info("所有参加满减的售价总和：" + price + " " + " 所有参加满减的减价总和:" + disPrice);
            // 所有参加满减的减价总和
            orderInfo.addMjDisPriceTotal(disPrice);
        }
    }

    private static BigDecimal manjianDisPrice(MallPromotionResultDto promotionResultDto, BigDecimal price) throws RuntimeException {
        BigDecimal disPrice = new BigDecimal(0);
        Map<Integer, BigDecimal> mjRuleMinMap = Maps.newTreeMap();
        for (int i = 10; i > 0; i--) {
            try {
                Integer ruleMinPay =  (Integer)MallPromotionResultDto.class.getMethod("getRuleMinPay".concat(String.valueOf(i))).invoke(promotionResultDto);
                Integer ruleFee =  (Integer)MallPromotionResultDto.class.getMethod("getRuleFee".concat(String.valueOf(i))).invoke(promotionResultDto);
                if (ruleMinPay != null && ruleMinPay.intValue() != 0) {
                    BigDecimal ruleMinPayB = new BigDecimal(ruleMinPay.intValue());
                    BigDecimal subRuleMinPay = price.subtract(ruleMinPayB);
                    if (subRuleMinPay.compareTo(new BigDecimal(0)) >= 0) {
                        mjRuleMinMap.put(subRuleMinPay.intValue(), new BigDecimal(ruleFee.toString()));
                    }
                }
            } catch (NoSuchMethodException e) {
                log.error("OrderService manjian error:{}",Throwables.getStackTraceAsString(e));
                throw new RuntimeException(e);
            } catch (InvocationTargetException e) {
                log.error("OrderService manjian error:{}", Throwables.getStackTraceAsString(e));
                throw new RuntimeException(e);
            } catch (IllegalAccessException e) {
                log.error("OrderService manjian error:{}", Throwables.getStackTraceAsString(e));
                throw new RuntimeException(e);
            }
        }
        if (mjRuleMinMap.size() > 0) disPrice = (BigDecimal) mjRuleMinMap.values().toArray()[0];
        return disPrice;
    }

    private String initMiaosha(Map<String, Object> result, String id, User user) {
        List<OrderCommitInfoDto> resultList = Lists.newArrayList();
        TblGoodsPaywayModel goodsPaywayModel = null;
        PromotionPayWayModel promotionPayWayModel = promotionPayWayService.findPomotionPayWayInfo(id).getResult();
        if (promotionPayWayModel == null) {
            throw new IllegalArgumentException("0元秒杀商品数据异常");
        } else {
            goodsPaywayModel = goodsPayWayService.findGoodsPayWayInfo(promotionPayWayModel.getGoodsPaywayId()).getResult();
            if (goodsPaywayModel == null) {
                throw new IllegalArgumentException("0元秒杀商品数据异常");
            }
        }
        ItemModel itemModel = itemService.findById(promotionPayWayModel.getGoodsId());
        if (itemModel == null) {
            throw new IllegalArgumentException("没找到对应0元秒杀商品");
        }
        GoodsModel goodsModel = goodsService.findById(itemModel.getGoodsCode()).getResult();
        if (goodsModel == null) {
            throw new IllegalArgumentException("没找到对应0元秒杀商品");
        }
        MallPromotionResultDto promotionResultDto = mallPromotionService.findPromByItemCodes("1", itemModel.getCode(), null).getResult();
        if (promotionResultDto == null) {
            throw new IllegalArgumentException("该商品没参加0元秒杀活动");
        }
        // 活动购买数量校验
        Boolean b = mallPromotionService.checkPromBuyCount(promotionResultDto.getId().toString(), promotionResultDto.getPeriodId(), "1", user, itemModel.getCode()).getResult();
        if (!b) {
            throw new IllegalArgumentException("活动可购买数量已达到上限");
        }
        OrderCommitInfoDto orderCommitInfoDto = new OrderCommitInfoDto();
        orderCommitInfoDto.setCode(itemModel.getCode());
        orderCommitInfoDto.setMid(itemModel.getMid());
        orderCommitInfoDto.setPayWayId(promotionPayWayModel.getGoodsPaywayId());
        orderCommitInfoDto.setOriPrice(goodsPaywayModel.getGoodsPrice());
        orderCommitInfoDto.setPrice(promotionPayWayModel.getGoodsPrice());
        orderCommitInfoDto.setImage1(itemModel.getImage1());
        orderCommitInfoDto.setItemCount(1);
        orderCommitInfoDto.setInstalments(promotionPayWayModel.getStagesCode().toString());
        orderCommitInfoDto.setInstalmentsPrice(promotionPayWayModel.getGoodsPrice());
        orderCommitInfoDto.setDisInstalmentsPrice(promotionPayWayModel.getGoodsPrice());
        orderCommitInfoDto.setSubTotal(promotionPayWayModel.getGoodsPrice());
        orderCommitInfoDto.setGoodsName(goodsModel.getName());
        orderCommitInfoDto.setGoodsCode(itemModel.getGoodsCode());
        orderCommitInfoDto.setSinglePrice(0l);
        orderCommitInfoDto.setJfCount(0l);
        orderCommitInfoDto.setAfterDiscountJf(0l);
        orderCommitInfoDto.setDiscountPercent(new BigDecimal(10.00));
        orderCommitInfoDto.setVoucherId("");
        orderCommitInfoDto.setVoucherNo("");
        orderCommitInfoDto.setVoucherNm("");
        orderCommitInfoDto.setVoucherPrice(new BigDecimal(0));
        orderCommitInfoDto.setFixFlag(false);
        orderCommitInfoDto.setCartId("");
        orderCommitInfoDto.setPromotion(promotionResultDto);
        orderCommitInfoDto.setMiaoFlag("1");
        resultList.add(orderCommitInfoDto);
        if (Contants.SUB_ORDER_TYPE_00.equals(goodsModel.getGoodsType())) {
            result.put("goodsType", Contants.SUB_ORDER_TYPE_00);
        } else {
            result.put("goodsType", goodsModel.getGoodsType());
            result.put("userName", user.getName());
            result.put("phoneNo", user.getMobile());
        }
        //1：信用卡；2借记卡
        String payType = "1";
        result.put("itemInfoList", resultList);
        result.put("payType", payType);
        result.put("total", new BigDecimal(0));
        result.put("deduction", new BigDecimal(0));
        result.put("voucherPrice", new BigDecimal(0));
        result.put("realPayment", new BigDecimal(0));
        result.put("miaoFlag", "1");
        return payType;
    }

    private String initHelanpai(Map<String, Object> result, List<CarInfoDto> carInfoDtos, User user) {
        List<OrderCommitInfoDto> resultList = Lists.newArrayList();
        BigDecimal total = new BigDecimal(0);// 订单总额
        BigDecimal deduction = new BigDecimal(0);// 积分抵扣金额
        BigDecimal voucherPriceTotal = new BigDecimal(0);// 优惠券
        List<String> ids = Lists.newArrayList();
        for (CarInfoDto carInfoDto : carInfoDtos) {
            ids.add(carInfoDto.getI().toString());
        }
        List<AuctionRecordModel> auctionModelList = auctionRecordService.findByIds(ids).getResult();
        if (auctionModelList.size() != carInfoDtos.size()) {
            throw new IllegalArgumentException("荷兰拍数据异常");
        }
        List<String> itemCodeList = null;
        Response<List<ItemModel>> modelResponse = null;
        List<String> goodsCodes = Lists.newArrayList();
        for (AuctionRecordModel auctionRecordModel : auctionModelList) {
            if (!Strings.isNullOrEmpty(auctionRecordModel.getOrderId())) {
                throw new ServiceException("已经拍到此商品");
            }
            itemCodeList = new ArrayList<String>();
            itemCodeList.add(auctionRecordModel.getItemId());
            modelResponse = itemService.findByCodes(itemCodeList);
            if (modelResponse.isSuccess() && modelResponse.getResult() != null && modelResponse.getResult().size() != 0) {
                auctionRecordModel.setItemList(modelResponse.getResult());
            } else {
                throw new IllegalArgumentException("没找到对应商品");
            }
            if (((new Date()).getTime() - auctionRecordModel.getAuctionTime().getTime()) / 60000 > 5) {
                throw new IllegalArgumentException("荷兰拍下单超时");
            }
            goodsCodes.add(auctionRecordModel.getItemList().get(0).getGoodsCode());
        }
        // 判断商品类型
        boolean isMaterial = false;
        String goodsType = Contants.SUB_ORDER_TYPE_00;
        Response<List<GoodsModel>> goodsModels = goodsService.findByCodes(goodsCodes);
        Map<String, String> goodsNameMap = Maps.newHashMap();
        for (GoodsModel goodsModel : goodsModels.getResult()) {
            goodsNameMap.put(goodsModel.getCode(), goodsModel.getName());
            goodsType = goodsModel.getGoodsType();
            if (Contants.SUB_ORDER_TYPE_00.equals(goodsModel.getGoodsType())) {
                isMaterial = true;
            }
        }
        if (isMaterial) {
            result.put("goodsType", Contants.SUB_ORDER_TYPE_00);
        } else {
            result.put("goodsType", goodsType);
            result.put("userName", user.getName());
            result.put("phoneNo", user.getMobile());
        }
        ItemModel itemModel = new ItemModel();// 购物车单品
        String instalments = "";// 分期数
        MallPromotionResultDto promotionResultDto = null;// 活动支付方式信息
        TblGoodsPaywayModel goodsPaywayModel = null;// 原支付方式信息
        for (AuctionRecordModel auctionRecordModel : auctionModelList) {
            itemModel = auctionRecordModel.getItemList().get(0);
            OrderCommitInfoDto orderCommitInfoDto = new OrderCommitInfoDto();
            orderCommitInfoDto.setCode(itemModel.getCode());
            orderCommitInfoDto.setMid(itemModel.getMid());
            // 商品数量
            orderCommitInfoDto.setItemCount(1);
            promotionResultDto = mallPromotionService.findPromByItemCodes("1", auctionRecordModel.getItemId(), null).getResult();
            if (promotionResultDto == null) {
                throw new IllegalArgumentException("该商品没参加荷兰拍活动");
            }
//            // 活动购买数量校验
//            Boolean b = mallPromotionService.checkPromBuyCount(promotionResultDto.getId().toString(), promotionResultDto.getPeriodId(), "1", user).getResult();
//            if (!b) {
//                throw new IllegalArgumentException("活动可购买数量已达到上限");
//            }
            goodsPaywayModel = goodsPayWayService.findGoodsPayWayInfo(auctionRecordModel.getGoodsPaywayId()).getResult();
            if (promotionResultDto != null && promotionResultDto.getId() != null) {
                orderCommitInfoDto.setPromotion(promotionResultDto);
            } else {
                throw new IllegalArgumentException("无此活动商品");
            }
            if (goodsPaywayModel == null) {
                throw new IllegalArgumentException("无此活动商品");
            }
            // 分期数
            instalments = goodsPaywayModel.getStagesCode() == null ? "1" : String.valueOf(goodsPaywayModel.getStagesCode());
            orderCommitInfoDto.setInstalments(instalments);
            // 分期价格
            if (instalments != null && !instalments.equals("0")) {
                orderCommitInfoDto.setInstalmentsPrice(auctionRecordModel.getAuctionPrice().divide(new BigDecimal(Integer.parseInt(instalments)), 2, BigDecimal.ROUND_DOWN));
            }
            // 支付方式Id
            orderCommitInfoDto.setPayWayId(goodsPaywayModel.getGoodsPaywayId());
            //原始价格
            orderCommitInfoDto.setOriPrice(goodsPaywayModel.getGoodsPrice() == null ? new BigDecimal(0) : goodsPaywayModel.getGoodsPrice());
            // 实际价格
            orderCommitInfoDto.setPrice(auctionRecordModel.getAuctionPrice());
            orderCommitInfoDto.setJfCount(0l);
            orderCommitInfoDto.setDiscountPercent(new BigDecimal(10.00));
            orderCommitInfoDto.setSinglePrice(0l);
            orderCommitInfoDto.setAfterDiscountJf(0l);
            orderCommitInfoDto.setDisInstalmentsPrice(orderCommitInfoDto.getInstalmentsPrice());
            orderCommitInfoDto.setVoucherId("");
            orderCommitInfoDto.setVoucherNo("");
            orderCommitInfoDto.setVoucherNm("");
            orderCommitInfoDto.setVoucherPrice(new BigDecimal(0));
            orderCommitInfoDto.setImage1(itemModel.getImage1());
            // 小计
            orderCommitInfoDto.setSubTotal(orderCommitInfoDto.getPrice().multiply(new BigDecimal(orderCommitInfoDto.getItemCount())));
            // 订单总额
            total = total.add(orderCommitInfoDto.getSubTotal());
            // 商品名称
            orderCommitInfoDto.setGoodsName(goodsNameMap.get(itemModel.getGoodsCode()));
            // 购物车Id
            orderCommitInfoDto.setCartId(auctionRecordModel.getId().toString());

            orderCommitInfoDto.setGoodsCode(itemModel.getGoodsCode());
            // 返回的商品信息
            resultList.add(orderCommitInfoDto);
        }
        String payType = "1";
        result.put("itemInfoList", resultList);
        result.put("payType", payType);
        result.put("total", total);
        result.put("deduction", deduction);
        result.put("voucherPrice", voucherPriceTotal);
        result.put("realPayment", total.subtract(deduction).subtract(voucherPriceTotal));// 实付款 = 订单总额 - 积分抵扣额 - 优惠券
        result.put("miaoFlag", "0");// 是否0元秒杀
        return payType;
    }

    protected List<Map<String, String>> getCardNoInfo(String payType, User user) throws Exception {
        List<Map<String, String>> cardNos = Lists.newArrayList();
        KeyReader keyReader = new KeyReader();
        for (UserAccount userAccount : user.getAccountList()) {
            HashMap cardInfo = Maps.newHashMap();
            String cardNo = userAccount.getCardNo();
            //1：信用卡；
            if (Contants.CART_PAY_TYPE_1.equals(payType) && UserAccount.CardType.CREDIT_CARD.equals(userAccount.getCardType())) {
                String cardSign = SignUtil.sign(cardNo, keyReader.readPrivateKey(SignManager.DEFAULT_RSA_PRI_KEY, true, SignManager.RSA_ALGORITHM_NAME));
                //脱敏，显示前四位和后四位
                String string1 = cardNo.substring(0,4);
                String string2 = cardNo.substring(cardNo.length()-4,cardNo.length());
                int length = cardNo.length() - string1.length() - string2.length();
                String string3 = StringUtils.center("*",length,"*");
                String newCardSign = string1 + string3 + string2;
                cardInfo.put("key", cardSign);
                cardInfo.put("value", newCardSign);
                cardNos.add(cardInfo);
            }
            // 2借记卡
            if (Contants.CART_PAY_TYPE_2.equals(payType) && !UserAccount.CardType.CREDIT_CARD.equals(userAccount.getCardType())) {
                String cardSign = SignUtil.sign(cardNo, keyReader.readPrivateKey(SignManager.DEFAULT_RSA_PRI_KEY, true, SignManager.RSA_ALGORITHM_NAME));
                //脱敏，显示前四位和后四位
                String string1 = cardNo.substring(0,4);
                String string2 = cardNo.substring(cardNo.length()-4,cardNo.length());
                int length = cardNo.length() - string1.length() - string2.length();
                String string3 = StringUtils.center("*",length,"*");
                String newCardSign = string1 + string3 + string2;
                cardInfo.put("key", cardSign);
                cardInfo.put("value", newCardSign);
                cardNos.add(cardInfo);
            }
        }
        return cardNos;
    }
}
