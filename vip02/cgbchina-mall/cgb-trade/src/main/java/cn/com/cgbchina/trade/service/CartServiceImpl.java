package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.dto.MallPromotionSaleInfoDto;
import cn.com.cgbchina.item.model.*;
import cn.com.cgbchina.item.service.*;
import cn.com.cgbchina.related.model.CouponInfModel;
import cn.com.cgbchina.related.service.CouPonInfService;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.user.*;
import cn.com.cgbchina.rest.visit.model.coupon.CouponInfo;
import cn.com.cgbchina.rest.visit.model.point.QueryPointResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfo;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfoResult;
import cn.com.cgbchina.rest.visit.service.point.PointService;
import cn.com.cgbchina.trade.dao.CartAddCountDao;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.dao.TblEspCustCartDao;
import cn.com.cgbchina.trade.dto.*;
import cn.com.cgbchina.trade.manager.CartManager;
import cn.com.cgbchina.trade.model.AuctionRecordModel;
import cn.com.cgbchina.trade.model.TblEspCustCartModel;
import cn.com.cgbchina.user.service.UserFavoriteService;
import com.google.common.base.*;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Collections2;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Ordering;
import com.google.common.primitives.Longs;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserAccount;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.*;

import static com.google.common.base.Preconditions.checkArgument;

@Service
@Slf4j
public class CartServiceImpl implements CartService {
    public static final JsonMapper jsonAlwaysMapper = JsonMapper.JSON_ALWAYS_MAPPER;
    @Resource
    private UserFavoriteService userFavoriteService;
    @Resource
    private GoodsService goodsService;
    @Resource
    private ItemService itemService;
    @Resource
    private PointService pointService;
    @Resource
    private PointsPoolService pointsPoolService;
    @Resource
    private CartManager cartManager;
    @Resource
    private TblEspCustCartDao tblEspCustCartDao;
    @Resource
    private GoodsPayWayService goodsPayWayService;
    @Resource
    private MallPromotionService mallPromotionService;
    @Resource
    private CouPonInfService couPonInfService;
    @Resource
    private PromotionPayWayService promotionPayWayService;
    @Resource
    private AuctionRecordService auctionRecordService;
    @Resource
    private OrderSubDao orderSubDao;
    @Resource
    private CartAddCountDao cartAddCountDao;
    @Resource
    private RedisService redisService;

//    private final LoadingCache<String, Response<MallPromotionResultDto>> cacheMallPromotion
//            = CacheBuilder.newBuilder().expireAfterWrite(5L, TimeUnit.MINUTES).build(
//            new CacheLoader<String, Response<MallPromotionResultDto>>() {
//                @Override
//                public Response<MallPromotionResultDto> load(String itemId) throws Exception {
//                    return mallPromotionService.findPromByItemCodes("1", itemId, Contants.PROMOTION_SOURCE_ID_00);
//                }
//            });
    private final LoadingCache<String, Response<PromotionPayWayModel>> cachePromotionPayWay
            = CacheBuilder.newBuilder().expireAfterWrite(5L, TimeUnit.MINUTES).build(
            new CacheLoader<String, Response<PromotionPayWayModel>>() {
                @Override
                public Response<PromotionPayWayModel> load(String two) throws Exception {
                    List<String> twos = Splitter.on(",").splitToList(two);
                    Map<String, Object> param = Maps.newHashMap();
                    param.put("goodsPaywayId", twos.get(0));
                    param.put("promId", twos.get(1));
                     return promotionPayWayService.findPomotionPayWayInfoByParam(param);
                }
            });
//    private final LoadingCache<String, Response<TblGoodsPaywayModel>> cacheGoodsPayWay
//            = CacheBuilder.newBuilder().expireAfterWrite(5L, TimeUnit.MINUTES).build(
//            new CacheLoader<String, Response<TblGoodsPaywayModel>>() {
//                @Override
//                public Response<TblGoodsPaywayModel> load(String goodsPaywayId) throws Exception {
//                    return goodsPayWayService.findGoodsPayWayInfo(goodsPaywayId);
//                }
//            });
//    private final LoadingCache<String, Response<String>> cacheFavorite
//            = CacheBuilder.newBuilder().expireAfterWrite(5L, TimeUnit.MINUTES).build(
//            new CacheLoader<String, Response<String>>() {
//                @Override
//                public Response<String> load(String itemIdCustId) throws Exception {
//                    List<String> itemIdCustIds = Splitter.on(",").splitToList(itemIdCustId);
//                    return userFavoriteService.checkFavoriteUser(itemIdCustIds.get(0), itemIdCustIds.get(1));
//                }
//            });
    private final LoadingCache<String, Response<TblCfgIntegraltypeModel>> cachePointsName
            = CacheBuilder.newBuilder().expireAfterWrite(5L, TimeUnit.MINUTES).build(
            new CacheLoader<String, Response<TblCfgIntegraltypeModel>>() {
                @Override
                public Response<TblCfgIntegraltypeModel> load(String pointsType) throws Exception {
                    return goodsService.findPointsNameByType(pointsType);
                }
            });

    private final LoadingCache<GoodsModel, Response<List<CouponInfModel>>> cacheCoupouForGet
            = CacheBuilder.newBuilder().expireAfterWrite(5L, TimeUnit.MINUTES).build(
            new CacheLoader<GoodsModel, Response<List<CouponInfModel>>>() {
                @Override
                public Response<List<CouponInfModel>> load(GoodsModel goodsModel) throws Exception {
                    return couPonInfService.findByGoodsInfo(goodsModel);
                }
            });
    private final LoadingCache<GoodsModel,  Response<List<CouponInfModel>>> cacheCouponForUse
            = CacheBuilder.newBuilder().expireAfterWrite(5L, TimeUnit.MINUTES).build(
            new CacheLoader<GoodsModel,  Response<List<CouponInfModel>>>() {
                @Override
                public  Response<List<CouponInfModel>> load(GoodsModel goodsModel) throws Exception {
                    return  couPonInfService.findByGoodsSpendableInfo(goodsModel);
                }
            });

    /**
     * 获取用户荷兰拍信息
     * @param user
     * @return
     */
    @Override
    public Response<AuctionRecordDto> findAutionRecordInfo(User user){
        log.info("Get CartService.findAutionRecordInfo");
        Response<AuctionRecordDto> response = Response.newResponse();
        // 荷兰拍信息
        AuctionRecordDto auctionRecord = new AuctionRecordDto();

        try {
            log.info("Go To AuctionRecordService.findByCustId");
            Response<List<AuctionRecordModel>> responseList = auctionRecordService.findByCustId(user);
            if (!responseList.isSuccess()||responseList.getResult()==null||responseList.getResult().isEmpty()) {
                auctionRecord = null;
            }else{
                //	荷兰拍信息列表
                List<AuctionRecordModel> auctionRecordList = responseList.getResult();
                // 荷兰拍条数
                Integer countNum = auctionRecordList.size();
                List<OrderTransParaDto> orderPara = Lists.transform(auctionRecordList, new Function<AuctionRecordModel, OrderTransParaDto>() {
                    @Nullable
                    @Override
                    public OrderTransParaDto apply(@Nullable AuctionRecordModel auctionRecordModel) {
                        OrderTransParaDto orderTransParaDto = new OrderTransParaDto();
                        orderTransParaDto.setK("1");
                        orderTransParaDto.setI(String.valueOf(auctionRecordModel.getId()));
                        orderTransParaDto.setC("");
                        return orderTransParaDto;
                    }
                });

                auctionRecord.setCountNum(countNum);
                auctionRecord.setAuctionRecordList(auctionRecordList);
                auctionRecord.setUrlStrBuffer(jsonAlwaysMapper.toJson(Lists.newArrayList(orderPara)));
            }
            response.setResult(auctionRecord);
            return response;
        }catch (Exception e) {
            log.error("auction.getUser.record.error{}", Throwables.getStackTraceAsString(e));
            response.setError("auction.getUser.record.error");
            return response;
        }
    }

    /**
     * 取得用户名下购物车内商品总数（按条数，不区分失效）
     */
    public Response<Integer> findCustCartNumByUser(User user){
        Response<Integer> response = Response.newResponse();
        try {
            Integer count = tblEspCustCartDao.findCountByUser(user.getCustId());
            response.setResult(count);
        }catch (Exception e){
            log.error("find.custCartNumByUser.error", Throwables.getStackTraceAsString(e));
            response.setError("find.custCartNumByUser.error");
        }
        return response;
    }

    public Response<Integer> findCustCartNumByUserItem(User user, String itemCode){
        Response<Integer> response = Response.newResponse();
        try {
            Integer count = tblEspCustCartDao.findCountByUserItem(user.getCustId(),itemCode);
            response.setResult(count);
        }catch (Exception e){
            log.error("find.findCustCartNumByUserItem.error", Throwables.getStackTraceAsString(e));
            response.setError("find.findCustCartNumByUserItem.error");
        }
        return response;
    }

    /**
     * 添加购物车 广发商城自用接口
     *
     * @param cartAddDto
     * @return
     * @author Congzy
     * @describe 变更DB存储
     */
    @Override
    public Response<Integer> createCartInfo(CartAddDto cartAddDto) {

        Response<Integer> result = Response.newResponse();
        try {
            CustCarAddReturn carAddReturn = this.addOneCartInfo(cartAddDto);
            String updateResult = carAddReturn.getReturnCode();
            if ("000000".equals(updateResult)) {
                result.setSuccess(true);
            }
            else {
                result.setError(carAddReturn.getReturnDes());
            }
            return result;
        } catch (Exception e) {
            log.error("trade.cart.add.error", Throwables.getStackTraceAsString(e));
            result.setError(e.getMessage());
            return result;
        }
    }

    /**
     * 添加购物车 商城提供接口(MAL304)
     *
     * @param custCarAdd
     * @return
     * @author Congzy
     * @describe 变更DB存储
     */
    @Override
    public CustCarAddReturn createCartInfoForOut(CustCarAdd custCarAdd) {
        return this.addOneCartInfo(this.changeOutCartAddEntity(custCarAdd));
    }
//

    /**
     * 查询购物车 广发商城自用接口
     *
     * @param user
     * @return
     */
    @Override
    public Response<CartDbResultDto> selectCartInfo(User user) {
        Response<CartDbResultDto> response = Response.newResponse();
        // 购物车信息总汇
        CartDbResultDto cartDbResultDto = new CartDbResultDto();

        try {
            // 【取得个人用户积分信息】
            Response<Map<String,BigDecimal>> userAccountResponse = redisService.getScores(user);
            if (userAccountResponse.isSuccess()) {
                // 用户积分帐号信息
                Map<String,BigDecimal> userPointDto = userAccountResponse.getResult();
                cartDbResultDto.setUserPointDto(userPointDto);
            }
            else {
                log.error("failed to getUserScore,error code:{}", userAccountResponse.getError());
//                response.setError(userAccountResponse.getError());
//                return response;
            }

            // 【积分池 剩余积分】
            Response<PointPoolModel> pointPoolModelResponse = pointsPoolService.getLastInfo();
            if (pointPoolModelResponse.isSuccess()) {
                PointPoolModel pointPoolModel = pointPoolModelResponse.getResult();
                // 积分池余额
                Long surplusPoint = pointPoolModel.getMaxPoint() - pointPoolModel.getUsedPoint();
                // 积分池余额录入
                cartDbResultDto.setSurplusPoint(surplusPoint.toString());
            }
            else {
                log.error("failed to getLastInfo,error code:{}", pointPoolModelResponse.getError());
//                response.setError(pointPoolModelResponse.getError());
//                return response;
                cartDbResultDto.setSurplusPoint("0");
            }

            // 查询优惠券 当前用户未使用的
            List<CouponInfo> couponInfoList = null;
            Response<List<CouponInfo>> couponInfoResponse = redisService.getCoupons(
                    user.getId(), user.getCertType(), user.getCertNo());
            if (couponInfoResponse.isSuccess()) {
                couponInfoList = couponInfoResponse.getResult();
            }
            else {
                log.error("failed to getCouponInfos,error code:{}", couponInfoResponse.getError());
                couponInfoList = Lists.newArrayList();
            }

            // 查询购物车
            Map<String, Object> tblEspCustCartParam = Maps.newHashMap();
            tblEspCustCartParam.put("custId", user.getCustId());
            tblEspCustCartParam.put("payFlag", "0");
            // 用户购物车信息
            List<TblEspCustCartModel> tblEspCustCartModelList = tblEspCustCartDao.findByCustId(tblEspCustCartParam);

            // 多线程执行
            ExecutorService executorService = Executors.newFixedThreadPool(tblEspCustCartModelList.size());
            CompletionService<CartItemDto> completionService = new ExecutorCompletionService<CartItemDto>(executorService);
            // 循环购物车信息 检索购物车信息获取相关信息
            for (TblEspCustCartModel tblEspCustCartModel : tblEspCustCartModelList) {
                completionService.submit(callAbleSelectOneCartItem(tblEspCustCartModel, couponInfoList, user));
            }
            for (int j = 0; j < tblEspCustCartModelList.size(); j++) {
                CartItemDto ret = completionService.take().get();
                this.setItemPositionInCarts(cartDbResultDto, ret);
            }
            executorService.shutdown();
            cartDbResultDto.setCountCartsInfo(tblEspCustCartModelList.size());
            // 排序
            this.sortCart(cartDbResultDto);
            response.setResult(cartDbResultDto);
            return response;
        } catch (Exception e) {
            log.error("trade.cart.select.error", Throwables.getStackTraceAsString(e));
            response.setError("trade.cart.select.error");
            return response;
        }
    }

    /**
     * 查询购物车 商城提供接口(MAL305)
     *
     * @param custCarQuery
     * @return
     * @author Congzy
     * @describe 变更DB存储
     */
    @Override
    public Response<CustCarQueryReturn> selectPhoneCartInfo(CustCarQuery custCarQuery) {
        Response<CustCarQueryReturn> response = Response.newResponse();
        CustCarQueryReturn custCarQueryReturn = new CustCarQueryReturn();
        List<CustCarQueryGoodsReturn> custCarQueryGoodsReturnList = Lists.newArrayList();
        String cust_id = custCarQuery.getCustId(); // 客户编号
        String cart_type = custCarQuery.getCartType(); // 购物车类型

        String rowsPage = custCarQuery.getRowsPage();
        // 当前页码
        String currentPage = custCarQuery.getCurrentPage();
        int rowsPageInt = Strings.isNullOrEmpty(rowsPage) ? 1 : Integer.parseInt(rowsPage);
        int currentPageInt = Strings.isNullOrEmpty(currentPage) ? 1 : Integer.parseInt(currentPage);
        Date nowDate = new Date();
        long dtV = nowDate.getTime() - (15 * 24 * 60 * 60 * 1000); // 15天
        Date dtDate = new Date(dtV);
        long dtJ = nowDate.getTime() - (1 * 24 * 60 * 60 * 1000);
        Date preDate = new Date(dtJ);// 积分 只能查前一天到现在的订单

        int firstResult;
        if (currentPageInt <= 1) {
            firstResult = 0;
        } else if (currentPageInt == 2) {
            firstResult = rowsPageInt;
        } else {
            firstResult = (rowsPageInt - 1) * rowsPageInt;
        }
        log.info("firstResult:{},rowsPageInt:{}", firstResult, rowsPageInt);
        // 购物车类型
        String orderType = "";
        String orderTypeFQ = null;
        if (Contants.BUSINESS_TYPE_YG.equals(cart_type)) {
            orderType = Contants.BUSINESS_TYPE_YG;
        } else if (Contants.BUSINESS_TYPE_FQ.equals(cart_type)) {
            orderType = Contants.BUSINESS_TYPE_FQ;
        } else if ("00".equals(cart_type)) {
            orderType = Contants.BUSINESS_TYPE_YG;
            orderTypeFQ = Contants.BUSINESS_TYPE_FQ;
        } else if (Contants.BUSINESS_TYPE_JF.equals(cart_type)) {
            orderType = Contants.BUSINESS_TYPE_JF;
        }
        // 组装查询条件
        Map<String, Object> param = Maps.newHashMap();
        param.put("custId", cust_id);
        param.put("ordertypeId", orderType);
        param.put("ordertypeIdFq", orderTypeFQ);
        param.put("payFlag", "0");
        param.put("fixBonusValue", 0);
        if (Contants.BUSINESS_TYPE_JF.equals(cart_type)) {// 积分只能查前一天
            param.put("addTime", DateHelper.date2string(preDate, DateHelper.YYYY_MM_DD_HH_MM_SS));
        } else {// 广发能查15天
            param.put("addTime", DateHelper.date2string(dtDate, DateHelper.YYYY_MM_DD_HH_MM_SS));
        }
        try {
            // 普通商品
            Pager<TblEspCustCartModel> pager = tblEspCustCartDao.findByPage(param, firstResult, rowsPageInt);
            log.info("查询购物车记录总数:{}", pager.getTotal());
            List<TblEspCustCartModel> tblEspCustCartModels = pager.getData();
            if (tblEspCustCartModels != null && tblEspCustCartModels.size() > 0) {
                // 多线程执行
                ExecutorService executorService = Executors.newFixedThreadPool(tblEspCustCartModels.size());
                CompletionService<CustCarAddReturn> completionService = new ExecutorCompletionService<CustCarAddReturn>(executorService);
                // 循环购物车信息 检索购物车信息获取相关信息
                for (TblEspCustCartModel tblEspCustCartModel : tblEspCustCartModels) {
                    completionService.submit(callAbleSelectOneCartItemOut(tblEspCustCartModel, cart_type, custCarQueryGoodsReturnList));
                }
                for (int j = 0; j < tblEspCustCartModels.size(); j++) {
                    CustCarAddReturn ret = completionService.take().get();
                }
                executorService.shutdown();
                custCarQueryReturn.setTotalPages(String.valueOf((int)Math.ceil((double)pager.getTotal()/(double)rowsPageInt)));
                custCarQueryReturn.setTotalCount(String.valueOf(pager.getTotal()));
                custCarQueryReturn.setGoods( this.sortCartOutList(custCarQueryGoodsReturnList));
                custCarQueryReturn.setReturnCode("000000");
                custCarQueryReturn.setReturnDes("");
            }
            response.setResult(custCarQueryReturn);
        } catch (Exception e) {
            log.error("query.selectphonecartinfo.error {}" ,e);
            custCarQueryReturn.setReturnCode("000009");
            custCarQueryReturn.setReturnDes("查询购物车发生异常");
            response.setResult(custCarQueryReturn);
            return response;
        }
        return response;
    }

    /**
     * 修改购物车 商城提供接口(MAL306)
     *
     * @param custCarUpdate
     * @return
     * @author Congzy
     * @describe 变更DB存储
     */
    @Override
    public Response<CustCarUpdateReturn> updateCartInfo(CustCarUpdate custCarUpdate) {
        Response<CustCarUpdateReturn> response = Response.newResponse();
        CustCarUpdateReturn custCarUpdateReturn = new CustCarUpdateReturn();
        try {
            // 修改购物车信息组装 只check非虚拟商品
            List<CustCarUpdateInfo> updateInfo = custCarUpdate.getUpdateInfos();
            int countAll = updateInfo.size();
            if (updateInfo != null && countAll > 0) {
                long goods_numcount = 0;

                int countCheck = 0;
                ExecutorService executorService = Executors.newFixedThreadPool(countAll);
                CompletionService<CustCarUpdateReturn> completionService = new ExecutorCompletionService<CustCarUpdateReturn>(executorService);

                for (CustCarUpdateInfo custCarUpdateInfo : updateInfo) {
                    if (!"01".equals(custCarUpdateInfo.getGoodsType())) {
                        long goods_num = custCarUpdateInfo.getGoodsNum() == null ? 0 : Long.parseLong(custCarUpdateInfo.getGoodsNum());
                        goods_numcount = goods_numcount + goods_num;
                        if (!Strings.isNullOrEmpty(custCarUpdateInfo.getGoodsType())) {
                            countCheck = countCheck + 1;
                            completionService.submit(callAbleCheckCartModify(custCarUpdateInfo));
                        }
                    }
                }
                if (goods_numcount > 99) {
                    custCarUpdateReturn.setReturnCode("000047");
                    custCarUpdateReturn.setReturnDes("购物车中选中的商品超过了99个");
                    response.setResult(custCarUpdateReturn);
                    return response;
                }

                for (int j = 0; j < countCheck; j++) {
                    custCarUpdateReturn = completionService.take().get();
                    // 有异常
                     if (!"000000".equals(custCarUpdateReturn.getReturnCode())) {
                         break;
                     }
                }
                executorService.shutdown();

                cartManager.update(updateInfo); // 更新
                custCarUpdateReturn.setReturnCode("000000"); // 成功返回
            }

        }
        catch (Exception e) {
            custCarUpdateReturn.setReturnCode("000027");
            custCarUpdateReturn.setReturnDes("修改购物车发生异常");
            log.error("trade.cart.update.error", Throwables.getStackTraceAsString(e));
            response.setError("trade.cart.update.error");
            return response;
        }
        response.setResult(custCarUpdateReturn);
        return response;
    }

    /**
     * 删除购物车 商城提供接口(MAL307)
     *
     * @param custCarDel
     * @return
     * @author Congzy
     * @describe 变更DB存储
     */
    @Override
    public Response<CustCarDelReturn> deleteCartInfo(CustCarDel custCarDel) {
        Response<CustCarDelReturn> response = Response.newResponse();
        CustCarDelReturn custCarDelReturn = new CustCarDelReturn();
        try {
            List<CustCarDelIds> custCarDelIds = custCarDel.getIds();
            List<String> delIds = Lists.transform(custCarDelIds, new Function<CustCarDelIds, String>() {
                @Override
                public String apply(@NotNull CustCarDelIds c) {
                    return c.getId() == null ? "" : c.getId();
                }
            });
            if (delIds != null && delIds.size() > 0) {
                // 删除
                cartManager.delete(delIds);
            }
            // 成功返回
            custCarDelReturn.setReturnCode("000000");
            response.setResult(custCarDelReturn);
        } catch (Exception e) {
            custCarDelReturn.setReturnCode("000027");
            custCarDelReturn.setReturnDes("删除购物车发生异常");
            response.setResult(custCarDelReturn);
            log.error("trade.cart.delete.error", Throwables.getStackTraceAsString(e));
            response.setError("trade.cart.delete.error");
            return response;
        }
        return response;
    }

    /**
     * 调用bms011接口 获取用户记录第一张信用卡卡号 根据卡号获取用户下的所有积分
     *
     * @return
     */
    @Override
    public Response<Map<String,BigDecimal>> getUserScore(User user) {
        Response<Map<String,BigDecimal>> response = Response.newResponse();
        Map<String,BigDecimal> userPoint = Maps.newHashMap();
        response.setResult(userPoint);
        try {
            List<UserAccount> userCartDtoList = user.getAccountList();
            log.info("cartService.getUserScore.userCartDtoList{}",userCartDtoList.toString());
            if (userCartDtoList != null) {
                Collection<UserAccount> creditCardList = Collections2.filter(userCartDtoList,
                        new Predicate<UserAccount>() {
                            @Override
                            public boolean apply(@NotNull UserAccount input) {
                                return UserAccount.CardType.CREDIT_CARD.equals(input.getCardType());
                            }
                        });
                Iterator<UserAccount> iterator = creditCardList.iterator();
                log.info("cartService.getUserScore.iterator{}",iterator.toString());
                if (iterator.hasNext()) {
                    String cardNo = iterator.next().getCardNo();
                    if (!Strings.isNullOrEmpty(cardNo)) {
                        int currentPage = 0;
                        QueryPointsInfo queryPointsInfo = new QueryPointsInfo();
                        queryPointsInfo.setChannelID("MALL");
                        queryPointsInfo.setCardNo(cardNo);
                        SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");// 设置日期格式
                        queryPointsInfo.setStartDate(df.format(new Date()));
                        queryPointsInfo.setEndDate(df.format(new Date()));
                        // 页码
                        int pageNum = 0;
                        while (true) {
                            queryPointsInfo.setCurrentPage(Integer.toString(currentPage));
                            // 获取用户各类积分的和 调用bms011接口
                            log.info("bms011接口 获取用户记录第一张信用卡卡号 根据卡号获取用户下的所有积分发送报文。。。。" + queryPointsInfo);
                            QueryPointResult queryPointResult = pointService.queryPoint(queryPointsInfo);
                            log.info("bms011接口 获取用户记录第一张信用卡卡号 根据卡号获取用户下的所有积分返回报文。。。。" + queryPointResult);
                            // 取得总页数
                            String strPageNum = queryPointResult == null ? "0" : queryPointResult.getTotalPages();
                            if (!Strings.isNullOrEmpty(strPageNum)) {
                                pageNum = Integer.parseInt(strPageNum);
                            }
                            if (queryPointResult != null) {
                                List<QueryPointsInfoResult> queryPointsInfoResultVOList = queryPointResult.getQueryPointsInfoResults();
                                String successCode = queryPointResult.getSuccessCode();
                                if ("00".equals(successCode)) {
                                    for (QueryPointsInfoResult queryPointsInfoResultVO : queryPointsInfoResultVOList) {
                                        if (userPoint.get(queryPointsInfoResultVO.getJgId())!=null){
                                            BigDecimal point = userPoint.get(queryPointsInfoResultVO.getJgId());
                                            point = point.add(queryPointsInfoResultVO.getAccount() == null ? BigDecimal.ZERO : queryPointsInfoResultVO.getAccount());
                                            userPoint.put(queryPointsInfoResultVO.getJgId(),point);
                                        }else{
                                            BigDecimal point = queryPointsInfoResultVO.getAccount() == null ? BigDecimal.ZERO : queryPointsInfoResultVO.getAccount();
                                            userPoint.put(queryPointsInfoResultVO.getJgId(),point);
                                        }
                                    }
                                    currentPage++;
                                    if (currentPage >= pageNum) {
                                        break;
                                    }
                                } else {
                                    log.error("trade.cart.get.successCode:{}", successCode);
//                                    response.setError("trade.cart.get.userscore");
//                                    return response;
                                    break;
                                }
                            } else {
                                log.error("trade.cart.get.queryPointResult:{}", queryPointResult);
//                                response.setError("trade.cart.get.userscore");
//                                return response;
                                break;
                            }
                        }
                    }
                }
            }
        }
        catch (Exception e) {
            log.error("trade.cart.get.userscore:{}", Throwables.getStackTraceAsString(e));
//            response.setError("trade.cart.get.userscore");
        }
        response.setResult(userPoint);
        return response;
    }


    /**
     * check 用户是否可兑换该商品
     * @param itemModel
     * @param goodsPoint
     * @param goodsNum
     * @param user
     * @return
     */
    public Response<Boolean> checkUsedBonus(ItemModel itemModel,BigDecimal goodsPoint,BigDecimal goodsNum,User user){
        Response<Boolean> response = Response.newResponse();
        try{
            if(itemModel.getVirtualIntegralLimit() == null || itemModel.getVirtualIntegralLimit().longValue() == 0l){
                response.setResult(true);
                return response;
            }else{
                Response<Long> usedBonusResponse = queryTotalBonusInAMonthByGoodsId(itemModel.getCode(),user);
                if(!usedBonusResponse.isSuccess()){
                    log.error("Response.error,error code: {}", usedBonusResponse.getError());
                    throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
                }
                long usedBonus = usedBonusResponse.getResult();
                if(new BigDecimal(itemModel.getVirtualIntegralLimit()).compareTo((goodsPoint.multiply(goodsNum).add(new BigDecimal(usedBonus))) ) < 0){
                    response.setResult(false);
                }
                else{
                    response.setResult(true);
                }
            }
            return response;
        }catch (Exception e){
            log.error("trade.cart.check.used.bonus", Throwables.getStackTraceAsString(e));
            response.setError("trade.cart.check.used.bonus");
            return  response;
        }
    }
    /**
     * 限购的虚拟商品购物车内是否存在
     */
    @Override
    public Response<Boolean> checkOnlyLimitInCart(Map<String,Object> custInfoJFParam,String itemCode){
        Response<Boolean> response = Response.newResponse();
        try {
            final String itemId = itemCode;	//新加入单品id
            List<TblEspCustCartModel> tblEspCustCartModelList = tblEspCustCartDao.findByCustId(custInfoJFParam);
            Collection<TblEspCustCartModel> listFilter = Collections2.filter(tblEspCustCartModelList,
                    new Predicate<TblEspCustCartModel>() {
                        @Override
                        public boolean apply(@NotNull TblEspCustCartModel input) {
                            return itemId.equals(input.getItemId());
                        }
                    });
            boolean bResult = listFilter.size() > 0 ? false : true;
            response.setResult(bResult);

            return response;
        }catch (Exception e){
            response.setError("trade.cart.check.only.virtual");
            return response;
        }
    }

    /**
     * 根据用户卡号获取积分，检验用户是否拥有该种类积分
     * @param pointsType
     * @return
     */
    public Response<BigDecimal> checkHavePointType(User user, String pointsType) {
        Response<BigDecimal> response = Response.newResponse();
        Response<Map<String,BigDecimal>> userAccountResponse = redisService.getScores(user);
        if (userAccountResponse.isSuccess()) {
            // 用户积分帐号信息
            Map<String,BigDecimal> userPointDto = userAccountResponse.getResult();
            BigDecimal pointNum = userPointDto.get(pointsType);
            if (pointNum == null){
                pointNum = BigDecimal.ZERO;
            }
            response.setResult(pointNum);
            log.info("getUserScore.pointsType:{},pointNum{},userPointDto:{}",pointsType,pointNum,userPointDto.toString());
        }
        else {
            log.error("failed to getUserScore,error code:{}", userAccountResponse.getError());
            response.setError(userAccountResponse.getError());
            return response;
        }
        return response;
    }

    /**
     * 删除购物车 订单提交成功后
     *
     * @param orderCommitInfoList
     * @return
     */
    @Override
    public Response<Boolean> deleteCartInfoFromOrder(List<OrderCommitInfoDto> orderCommitInfoList) {
        Response<Boolean> response = Response.newResponse();
        try {
            List<String> cartIdList = Lists.newArrayList();
            for (OrderCommitInfoDto orderCommitInfoDto : orderCommitInfoList) {
                if (!Strings.isNullOrEmpty(orderCommitInfoDto.getCartId())) {
                    cartIdList.add(orderCommitInfoDto.getCartId());
                }
            }
            if (!cartIdList.isEmpty()) {
                // 删除
                cartManager.delete(cartIdList);
            }
            // 成功返回
            response.setSuccess(true);
        } catch (Exception e) {
            log.error("trade.cart.delete.error", Throwables.getStackTraceAsString(e));
            response.setError("trade.cart.delete.error");
            return response;
        }
        return response;
    }

    @Override
    public Response<Map<String, List<VoucherInfoDto>>> getCouponInfo(List<CouponInfo> user_small_coupon_ForGet, GoodsModel goodsModel, int use) {
        Response<Map<String, List<VoucherInfoDto>>> response = Response.newResponse();
        Map<String, List<VoucherInfoDto>> map = Maps.newHashMap();
        try {
            List<VoucherInfoDto> result_Big_Voucher_ForGet = Lists.newArrayList();
            List<CouponInfModel> bigGoods_Voucher_ForGet = Lists.newArrayList();
            // user_couponInfosList   传入的是当前用户 所有优惠券 只跟人有关（包括已使用， 跟商品无关）
            // 获取商品可以使用的优惠卷列表
            // 领取优惠券 use == 0        只检索可以手动领取的（不包括 不可手动领取）   跟人无关，只跟商品有关
            if (use == 0 || use == 2) {  // 0：领取优惠券 1：选择使用优惠券 2: 前两种都要获得
                Response<List<CouponInfModel>> voucher_Big_ResponseForGet = cacheCoupouForGet.getUnchecked(goodsModel);
                if (!voucher_Big_ResponseForGet.isSuccess()) {
                    log.error("优惠券信息取得失败！");
//                    response.setError(couPonResponseForGet.getError());
                    return response;
                }
                bigGoods_Voucher_ForGet = voucher_Big_ResponseForGet.getResult();

                // 额外获得可以手动领取的优惠券  0：领取优惠券 1：选择使用优惠券 2: 前两种都要获得
                final List<String> small_coupon_Temp = Lists.transform(user_small_coupon_ForGet,
                        new Function<CouponInfo, String>() {
                            @Override
                            public String apply(@NotNull CouponInfo input) {
                                return input.getProjectNO();
                            }
                        });
                Collection<CouponInfModel> big_Voucher_NotReceived = Collections2.filter(bigGoods_Voucher_ForGet,
                        new Predicate<CouponInfModel>() {
                            @Override
                            public boolean apply(@NotNull CouponInfModel input) {
                                return !small_coupon_Temp.contains(input.getCouponId());
                            }
                        });

                for (CouponInfModel cuponInfModel : big_Voucher_NotReceived) {
                    VoucherInfoDto voucherInfoDto = new VoucherInfoDto();
                    voucherInfoDto.setVoucherId(cuponInfModel.getCouponId());
                    voucherInfoDto.setVoucherName(cuponInfModel.getCouponNm());
                    if (cuponInfModel.getBeginDate() != null) {
                        String startTime = DateHelper.date2string(cuponInfModel.getBeginDate(), DateHelper.YYYY_MM_DD);
                        voucherInfoDto.setStartTime(startTime);
                    }
                    if (cuponInfModel.getEndDate() != null) {
                        String endTime = DateHelper.date2string(cuponInfModel.getEndDate(), DateHelper.YYYY_MM_DD);
                        voucherInfoDto.setEndTime(endTime);
                    }
                    // 未领取的优惠券（领取用，前台显示用）
                    voucherInfoDto.setIsReceived(1);
                    result_Big_Voucher_ForGet.add(voucherInfoDto);
                }
            }
            //  所有当前有效的（可能包含  可手动领取 和 不可手动领取） 跟人无关，只跟商品有关
            Response<List<CouponInfModel>>  big_voucher_ResponseForUse = cacheCouponForUse.getUnchecked(goodsModel);
            if (!big_voucher_ResponseForUse.isSuccess()) {
                log.error("优惠券信息取得失败！");
                response.setError(big_voucher_ResponseForUse.getError());
                return response;
            }
            List<CouponInfModel> big_vouder_ForUse = big_voucher_ResponseForUse.getResult();

            // 筛选用户未使用的优惠券     1：已使用 2：已激活未使用 3: 未激活
            Collection<CouponInfo> user_small_coupon_tempCollection = Collections2.filter(user_small_coupon_ForGet,
                    new Predicate<CouponInfo>() {
                        @Override
                        public boolean apply(@NotNull CouponInfo input) {
                            return "2".equals(input.getUseActivatiState());
                        }
                    });
            List<CouponInfo> small_coupon_ForUse = Lists.newArrayList(user_small_coupon_tempCollection);

            // 取得当前用户购买某个商品时,可以使用的优惠卷列表  交集
            final List<String> couponIds = Lists.transform(big_vouder_ForUse,
                    new Function<CouponInfModel, String>() {
                        @Override
                        public String apply(@NotNull CouponInfModel input) {
                            return input.getCouponId();
                        }
                    });
            Collection<CouponInfo> small_couponInfosReceived = Collections2.filter(small_coupon_ForUse,
                    new Predicate<CouponInfo>() {
                        @Override
                        public boolean apply(@NotNull CouponInfo input) {
                            return couponIds.contains(input.getProjectNO());
                        }
                    });

            List<VoucherInfoDto> result_small_coupon_Used_ForUse = Lists.newArrayList();
            List<VoucherInfoDto> resultVoucherInfoUsed_ForGet = Lists.newArrayList();
            for (CouponInfo couponInfReceived : small_couponInfosReceived) {
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
                result_small_coupon_Used_ForUse.add(voucherInfoDto);
            }

            // 取得当前用户购买某个商品时,可以使用的优惠卷列表  交集
            final List<String> couponIds1 = Lists.transform(user_small_coupon_ForGet,
                    new Function<CouponInfo, String>() {
                        @Override
                        public String apply(@NotNull CouponInfo input) {
                            return input.getProjectNO();
                        }
                    });
            Collection<CouponInfModel> big_voucher_Received1 = Collections2.filter(bigGoods_Voucher_ForGet,
                    new Predicate<CouponInfModel>() {
                        @Override
                        public boolean apply(@NotNull CouponInfModel input) {
                            return couponIds1.contains(input.getCouponId());
                        }
                    });

            if (use == 0 || use == 2) {
                for (CouponInfModel couponInfModel : big_voucher_Received1) {
                    VoucherInfoDto voucherInfoDto = new VoucherInfoDto();
                    voucherInfoDto.setVoucherId(couponInfModel.getCouponId()); // 大类
                    voucherInfoDto.setVoucherName(couponInfModel.getCouponNm());
                    if (couponInfModel.getBeginDate() != null) {
                        String startTime = DateHelper.date2string(couponInfModel.getBeginDate(), DateHelper.YYYY_MM_DD);
                        voucherInfoDto.setStartTime(startTime);
                    }
                    if (couponInfModel.getEndDate() != null) {
                        String endTime = DateHelper.date2string(couponInfModel.getEndDate(), DateHelper.YYYY_MM_DD);
                        voucherInfoDto.setEndTime(endTime);
                    }
                    resultVoucherInfoUsed_ForGet.add(voucherInfoDto);
                }
            }

            map.put("CouponsForUse", result_small_coupon_Used_ForUse);

            result_Big_Voucher_ForGet.addAll(resultVoucherInfoUsed_ForGet);
            map.put("CouponsForGet", result_Big_Voucher_ForGet);
            response.setResult(map);
            return response;
        } catch (Exception e) {
            log.error("cart.getCouponInfo.error", Throwables.getStackTraceAsString(e));
            response.setError("cart.getCouponInfo.error");
            return response;
        }
    }


    /**
     * 异步执行 check购物车页面的一条数据
     *
     * @param custCarUpdateInfo 购物车中的一条
     * @return
     */
    private Callable<CustCarUpdateReturn> callAbleCheckCartModify(final CustCarUpdateInfo custCarUpdateInfo) {
        Callable<CustCarUpdateReturn> ret = new Callable<CustCarUpdateReturn>() {
            @Override
            public CustCarUpdateReturn call() throws Exception {
                try {
                    return checkCartModify(custCarUpdateInfo);
                } catch (Exception e) {
                    CustCarUpdateReturn custCarUpdateReturn = new CustCarUpdateReturn();
                    log.error("trade.cart.update.error", Throwables.getStackTraceAsString(e));
                    custCarUpdateReturn.setReturnCode("000027");
                    custCarUpdateReturn.setReturnDes("修改购物车发生异常:");
                    return custCarUpdateReturn;
                }
            }
        };
        return ret;
    }

    /**
     * 改变商品数量/提交购物车 时的check
     *
     * @param custCarUpdateInfo 购物车中的一条
     * @return
     */
    private CustCarUpdateReturn checkCartModify(CustCarUpdateInfo custCarUpdateInfo) {
        CustCarUpdateReturn custCarUpdateReturn = new CustCarUpdateReturn();
        try {
            checkArgument(!Strings.isNullOrEmpty(custCarUpdateInfo.getId()), "cartId.can.not.be.empty");
            checkArgument(!Strings.isNullOrEmpty(custCarUpdateInfo.getGoodsNum()), "goodsNum.can.not.be.empty");

            long goods_num = custCarUpdateInfo.getGoodsNum() == null? 0 : Long.parseLong(custCarUpdateInfo.getGoodsNum());

            String itemCode = custCarUpdateInfo.getItemCode();
            String promotionId = custCarUpdateInfo.getPromotionId();
            ItemModel itemModel = itemService.findById(itemCode);
            long stock = itemModel.getStock() == null ? 0 : itemModel.getStock().longValue();
            if (!Strings.isNullOrEmpty(promotionId)) { // 活动
                // 根据活动ID、场次ID、单品CODE、购买数量 检验是否超过库存
                Response<MallPromotionSaleInfoDto> mallPromotionSaleInfoDtoResponse
                        = mallPromotionService.findPromSaleInfoByPromId(
                        custCarUpdateInfo.getPromotionId(), custCarUpdateInfo.getPeriodId(), itemCode);
                // 库存
                if (!mallPromotionSaleInfoDtoResponse.isSuccess()) {
                    log.error("trade.cart.findPromSaleInfoByPromId.error:", mallPromotionSaleInfoDtoResponse.getError());
                    custCarUpdateReturn.setReturnCode("000027");
                    custCarUpdateReturn.setReturnDes("修改购物车发生异常");
                    return custCarUpdateReturn;
                } else {
                    if (mallPromotionSaleInfoDtoResponse.getResult() != null) {
                        stock = mallPromotionSaleInfoDtoResponse.getResult().getStockAmountTody().longValue()
                                - mallPromotionSaleInfoDtoResponse.getResult().getSaleAmountToday().longValue();
                    }
                }
            }
            if (stock < goods_num) {
                custCarUpdateReturn.setReturnCode("000099");
                StringBuffer stringBuffer = new StringBuffer();
                stringBuffer.append("您所填写的宝贝").append(custCarUpdateInfo.getGoodsName()).append("数量超过库存(")
                        .append(stock).append(" )！");
                custCarUpdateReturn.setReturnDes(stringBuffer.toString());
            }
            // 正常
            custCarUpdateReturn.setReturnCode("000000");
         }
        catch (IllegalArgumentException e) {
            log.error("checkCartModify is error:{}", Throwables.getStackTraceAsString(e));
            custCarUpdateReturn.setReturnCode("000027");
            custCarUpdateReturn.setReturnDes("修改购物车发生异常");
        }
        catch (Exception e) {
            log.error("checkCartModify is error:{}", Throwables.getStackTraceAsString(e));
            custCarUpdateReturn.setReturnCode("000027");
            custCarUpdateReturn.setReturnDes("修改购物车发生异常");
        }
        return custCarUpdateReturn;
    }

    /**
     * 异步执行 检索购物车页面的一条数据
     *
     * @param tblEspCustCartModel 购物车中的一条
     * @param couponInfoList 当前用户拥有的优惠券
     * @param user 用户
     * @return
     */
    private Callable<CartItemDto> callAbleSelectOneCartItem(final TblEspCustCartModel tblEspCustCartModel, final List<CouponInfo> couponInfoList, final User user) {
        Callable<CartItemDto> ret = new Callable<CartItemDto>() {
            @Override
            public CartItemDto call() throws Exception {
                try {
                    return makeOneCartItem(tblEspCustCartModel,
                            couponInfoList,
                            user);
                } catch (Exception e) {
                    CartItemDto error = new CartItemDto();
                    error.setError(e.getMessage());
                    return error;
                }
            }
        };
        return ret;
    }

    /**
     * 被异步调用 检索购物车页面的一条数据
     *
     * @param tblEspCustCartModel 购物车中的一条
     * @param couponInfoList 当前用户拥有的优惠券
     * @param user 用户
     * @return
     */
    private CartItemDto makeOneCartItem(TblEspCustCartModel tblEspCustCartModel, List<CouponInfo> couponInfoList, User user) {
        CartItemDto cartItemDto = new CartItemDto();
        try {
            // 临时设定的值（购物车中存的），在取得数据库最新数据后会更新，中间有错误时，就使用临时值
            cartItemDto.setCustCartId(tblEspCustCartModel.getId());            // 购物车id   [***设定***]
            cartItemDto.setItemId(tblEspCustCartModel.getItemId());            // 单品id     [***设定***]
            cartItemDto.setOrdertypeId(tblEspCustCartModel.getOrdertypeId());  // 订单类型   [***设定***]
            cartItemDto.setGoodsType(tblEspCustCartModel.getGoodsType());      // 商品类型（00实物01虚拟02O2O）[***设定***]
            cartItemDto.setGoodsNum(tblEspCustCartModel.getGoodsNum());        // 数量     [***设定***]
            cartItemDto.setGoodsName("失效");                                  // 商品名称                     [***设定***]

            String itemId = tblEspCustCartModel.getItemId();   // 单品id
            String goodsPaywayId = tblEspCustCartModel.getGoodsPaywayId().toString();    // 付款方式id
            String ordertypeId = tblEspCustCartModel.getOrdertypeId(); // 订单类型id 区分:分期订单:FQ 一次性订单:YG 积分订单：JF',
            // 单品信息
            ItemModel itemModel = itemService.findById(itemId);
            // 单品信息返回失败 跳出循环
            if (itemModel == null) {
                return setErrorCartSelect("itemModel.be.null",cartItemDto);
            }
            cartItemDto.setItemImg(itemModel.getImage1());              // 单品图片 [***设定***]
            // 单品编码 广发商城------单品表. 商品ID(mid) 积分商城------单品表. 礼品编码(xid)
            String itemCode = Contants.BUSINESS_TYPE_JF.equals(ordertypeId) ? itemModel.getXid() : itemModel.getMid();
            cartItemDto.setItemCode(itemCode);  // 单品编码（显示用） [***设定***]
            cartItemDto.setItemId(itemId);                              // 单品id   [***设定***]

            // 商品id
            String goodsId = itemModel.getGoodsCode();
            // 商品信息
            Response<GoodsModel> goodsModelResponse = goodsService.findCacheById(goodsId);
            if (!goodsModelResponse.isSuccess()) {
                return setErrorCartSelect(goodsModelResponse.getError(), cartItemDto);
            }
            GoodsModel goodsModel = goodsModelResponse.getResult();
            cartItemDto.setGoodsName(goodsModel.getName());             // 商品名称                      [***设定***]
            cartItemDto.setGoodsId(goodsId);                            // 商品id                        [***设定***]


            // 活动信息    // 活动类型10折扣20满减30秒杀40团购50荷兰拍
            // 是否属于活动商品标识,活动返回true，非活动返回false
            // 是活动 使用活动表 PromotionPayWay  活动信息支付表
            boolean bUsePromotionPayWay = false;

            // 【取得支付信息： 价格，分期数，库存等】
            BigDecimal oriPrice = BigDecimal.ZERO;  // 商品单价  原价
            int stagesCode = 1;  // 分期数

            String canChangeNum = "1";   // 可否改变购买数量 标识 1;可以 / 0:不可以  有积分，或是秒杀，不能改变
            boolean canUseCoupon = true; // 是否可使用优惠券标识
            Boolean promotionFlag = false;
//          bug 306614 活动结束无法确定实时性 cyj
            Response<MallPromotionResultDto> mallPromotionResultDtoResponse = mallPromotionService.findPromByItemCodes("1", itemId, Contants.PROMOTION_SOURCE_ID_00);
            if (!mallPromotionResultDtoResponse.isSuccess()) {
                return setErrorCartSelect(mallPromotionResultDtoResponse.getError(),cartItemDto);
            }
            MallPromotionResultDto mallPromotionResult = mallPromotionResultDtoResponse.getResult();
            if (mallPromotionResult != null) {
                // 活动类型 10 折扣 20 满减 30 秒杀 40 团购 50 荷兰拍
                promotionFlag = true;
                Integer promotionId = mallPromotionResult.getPromItemResultList().get(0).getPromotionId(); // 活动ID
                Integer promType = mallPromotionResult.getPromType();   // 活动类型

                //  50      荷兰拍  失效  （非荷兰拍商品 --> 荷兰拍）
                if (50 == promType.intValue()) {  //
                    return setErrorCartSelect("活动类型 50 荷兰拍  出现在购物车内属于失效商品",cartItemDto);
                }
                // 支付信息  10折扣,30 秒杀(非0元）,40团购  从活动获取  20满减,30秒杀（0元）,50荷兰拍 从商品支付表获取
                // 其实  30秒杀（0元）,50荷兰拍 已经失效 ，实际只有 20满减从商品支付表获取
                if (promType.intValue() != 20 && promType.intValue() != 50) {
                    bUsePromotionPayWay = true;

                    // 根据goodsPaywayId promotionId 检索支付信息 包装数据
                    Response<PromotionPayWayModel> promotionPayWayResponse = cachePromotionPayWay.getUnchecked(goodsPaywayId + "," + promotionId);
                    PromotionPayWayModel promotionPaywayModel;
                    if (promotionPayWayResponse.isSuccess()) {
                        promotionPaywayModel = promotionPayWayResponse.getResult();
                    } else {
                        return setErrorCartSelect(promotionPayWayResponse.getError(),cartItemDto);
                    }
                    // 获取支付信息失败跳出循环
                    if (promotionPaywayModel == null) {
                        return setErrorCartSelect("活动支付信息取得失败",cartItemDto );
                    }
                    // 分期数
                    stagesCode = promotionPaywayModel.getStagesCode() == null ? 1 : promotionPaywayModel.getStagesCode();
                    // 价格
                    oriPrice = promotionPaywayModel.getGoodsPrice() == null ? BigDecimal.ZERO : promotionPaywayModel.getGoodsPrice();

                }
                //  30（特殊）  0元秒杀 失效 （非0元秒杀 --> 0元秒杀）
                if (30 == promType.intValue()) {
                    canChangeNum = "0";  // 秒杀不能改变数量
                    if(BigDecimal.ZERO.equals(oriPrice)) {
                        return setErrorCartSelect("(30 秒杀 0元秒杀) 出现在购物车内属于失效商品", cartItemDto);
                    }
                }

                // 活动名称
                String promName = mallPromotionResult.getName() == null ? "无" : mallPromotionResult.getName().toString();
                // 活动名称缩写
                String promShortName = mallPromotionResult.getShortName() == null ? "无" : mallPromotionResult.getShortName().toString();

                //仅秒杀(非零元) 可用优惠券 其他活动皆不可用 团购也可以
                canUseCoupon = (30 == promType.intValue() || 40 == promType.intValue()) ? true : false;
                // 某些活动（现在是秒杀）可以设定某些商品在参加活动时不能使用优惠券
                Integer couponEnable = mallPromotionResult.getPromItemResultList().get(0).getCouponEnable(); //(1 可以 0 不可以)
                if (couponEnable != null && couponEnable.intValue() == 0) {
                    canUseCoupon = false;
                }

                cartItemDto.setPromotionFlag(promotionFlag);              // 是否是活动   [***设定***]
                cartItemDto.setPromName(promName);                        // 活动名       [***设定***]
                cartItemDto.setPromShortName(promShortName);              // 活动缩写     [***设定***]
                cartItemDto.setPromType(promType);                        // 活动类型     [***设定***]
                cartItemDto.setPromotionId(promotionId);                  // 活动id       [***设定***]
                cartItemDto.setMallPromotionResult(mallPromotionResult);  // 活动信息     [***设定***]
            }


            // 其他情况，使用 普通商品获取支付信息（包括积分）
            if (!bUsePromotionPayWay) {
                // 普通商品获取支付信息
                Response<TblGoodsPaywayModel> tblGoodsPaywayResponse = goodsPayWayService.findGoodsPayWayInfo(goodsPaywayId);
                TblGoodsPaywayModel tblGoodsPaywayModel;
                if (tblGoodsPaywayResponse.isSuccess()) {
                    tblGoodsPaywayModel = tblGoodsPaywayResponse.getResult();
                } else {
                    return setErrorCartSelect(tblGoodsPaywayResponse.getError(), cartItemDto);
                }
                // 获取支付信息失败跳出循环
                if (tblGoodsPaywayModel == null) {
                    return setErrorCartSelect("tblGoodsPaywayModelList.be.empty",cartItemDto);
                }

                // 分期数
                stagesCode = tblGoodsPaywayModel.getStagesCode() == null ? 1 : tblGoodsPaywayModel.getStagesCode();
                // 价格
                oriPrice = tblGoodsPaywayModel.getGoodsPrice() == null ? BigDecimal.ZERO : tblGoodsPaywayModel.getGoodsPrice();

                // 积分商城数据处理
                if (Contants.BUSINESS_TYPE_JF.equals(ordertypeId)) {
                    canUseCoupon = false;       // 积分商城不允许使用优惠券
                    String virtualLimitFlag;    //购买限制标识 1限制 0不限制
                    Integer virtualLimit = itemModel.getVirtualLimit();//购买限制
                    if (virtualLimit != null && virtualLimit.intValue() != 0) {
                        virtualLimitFlag = "1";
                    } else {
                        virtualLimitFlag = "0";
                    }
                    //积分(积分商城)
                    Long goodsPoint = tblGoodsPaywayModel.getGoodsPoint() == null ? Long.valueOf(0) : tblGoodsPaywayModel.getGoodsPoint();
                    // 兑换等级
//                    String exchangeLevelName = this.getExchangeLevelName(tblGoodsPaywayModel.getMemberLevel());
                    String exchangeLevelName = tblEspCustCartModel.getCustmerNm();
                    String maxUsedBonus = getMaxUsedBonus(itemModel, goodsPoint, user); // 积分限制购买数量

                    // 积分商城数据组
                    cartItemDto.setIntegral(goodsPoint.toString());                            // 积分     [***设定***]
                    cartItemDto.setExchangeLevelName(exchangeLevelName);                       // 兑换等级 [***设定***]
                    cartItemDto.setVirtualLimitFlag(virtualLimitFlag);                         // 购买限制 [***设定***]
                    cartItemDto.setMaxUsedBonus(maxUsedBonus);                                 //积分换购商品上限  [***设定***]
                }
            }
            // 根据发起方 获取当前渠道的商品 上架状态
            // 商品渠道信息 上架 开始时间结束时间
            // 区分 广发商城 积分商城
            String mallType = (Contants.BUSINESS_TYPE_JF.equals(ordertypeId) ? Contants.MAll_POINTS : Contants.MAll_GF);
            boolean isOnShelf = isOnShelf("00", mallType, goodsModel);
            // check 商品是否为上架状态
            if (!isOnShelf) {
                return setErrorCartSelect("goodsDetail.check.goodUndercarriage",cartItemDto);
            }

            // 商品积分类型 默认普通类型
            String pointsTypeFromModel = goodsModel.getPointsType();
            String pointsType = Strings.isNullOrEmpty(pointsTypeFromModel) ? Contants.JGID_COMMON : pointsTypeFromModel;

            // 商品数量
            int goodsNum = Integer.parseInt(tblEspCustCartModel.getGoodsNum());
            // 广发商城
            if (!Contants.BUSINESS_TYPE_JF.equals(ordertypeId)) {
                Long oriBonusOne = tblEspCustCartModel.getOriBonusValue(); // 原始抵扣积分
                Long oriBonusAll = oriBonusOne * goodsNum; //总的原始抵扣积分

                Long bonusOne = tblEspCustCartModel.getBonusValue(); // 抵扣积分
                Long bonusAll = bonusOne * goodsNum; //总的抵扣积分
                // 抵扣金额   = 原始抵扣积分 /  单位积分    向上取整 分期金额向下取整
                BigDecimal discount = BigDecimal.valueOf(oriBonusOne).divide(BigDecimal.valueOf(tblEspCustCartModel.getSinglePoint()), 2, BigDecimal.ROUND_HALF_UP);
                // 页面单价 = 售价 - 积分抵扣金额
                BigDecimal discountPrice = oriPrice.subtract(discount);
                discountPrice = BigDecimal.ZERO.compareTo(discountPrice) > 0 ? BigDecimal.ZERO :discountPrice;

                // 若为一期商品则分期数为一
                if (Contants.BUSINESS_TYPE_YG.equals(ordertypeId) || Contants.BUSINESS_TYPE_JF.equals(ordertypeId)) {
                    stagesCode = 1;
                }
                // 每期金额
                final String strDiscountPrice = discountPrice.divide(BigDecimal.valueOf(stagesCode), BigDecimal.ROUND_DOWN).toString();

                // 固定积分值
                Long fixBonusValue = tblEspCustCartModel.getFixBonusValue();
                String isFixBonusFlag;  // 默认非固定积分商品
                Long pageFixBonusValue;  // 默认固定积分值
                // 若固定积分值为0 则标识设置为非固定积分商品 固定积分为0
                if (0 == fixBonusValue.intValue()) {
                    isFixBonusFlag = "0";
                    pageFixBonusValue = 0L;
                }
                // 若固定积分值不为0 则标识设置为固定积分商品 固定积分为购物车表返回固定积分值
                else {
                    isFixBonusFlag = "1";
                    pageFixBonusValue = fixBonusValue * goodsNum;
                }

                // 若固定积分/抵扣积分/原抵扣积分有一个不是0 则有积分， 不能改变数量
                if (tblEspCustCartModel.getBonusValue().longValue() != 0
                        || tblEspCustCartModel.getOriBonusValue().longValue() != 0
                        || fixBonusValue != 0) {
                    canChangeNum = "0";  // 有积分不能变更数量
                }
                if (oriBonusOne != bonusOne) {
                    cartItemDto.setDiscountPercent(new BigDecimal(bonusOne).divide(new BigDecimal(oriBonusOne), 2, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal(10)));
                }
                else {
                    cartItemDto.setDiscountPercent(new BigDecimal(10.00));
                }
                cartItemDto.setCustmerNm(tblEspCustCartModel.getCustmerNm());    // 用户等级        [***设定***]
                cartItemDto.setPrice(discountPrice.toString());                  // 抵扣后价格        [***设定***]
                cartItemDto.setOriBonusValue(String.valueOf(oriBonusAll));       // 总的原始抵扣积分  [***设定***]
                cartItemDto.setBonusValue(bonusAll.toString());                  // 抵扣积分  [***设定***]
                cartItemDto.setStrDiscountPrice(strDiscountPrice);               // 每期金额          [***设定***]
                cartItemDto.setIsFixBonusFlag(isFixBonusFlag);                   // 默认非固定积分商品         [***设定***]
                cartItemDto.setPageFixBonusValue(pageFixBonusValue.toString());  // 默认固定积分值             [***设定***]
                cartItemDto.setCanChangeNum(canChangeNum);                       // 使用积分标识               [***设定***]
                cartItemDto.setDiscountPrice(discountPrice.toString());          // 页面单价=售价-积分抵扣金额 [***设定***]
                cartItemDto.setDiscountMoney(discount);                          // 抵扣金额 = 原始抵扣积分/单位积分  [***设定***]

                // 优惠券信息
                //	若本商品可以使用优惠券
                if (canUseCoupon) {
                    Response<Map<String, List<VoucherInfoDto>>> voucherInfoDtoListResponse = this.getCouponInfo(couponInfoList, goodsModel, 2);
                    if (!voucherInfoDtoListResponse.isSuccess()) {
                        return setErrorCartSelect(voucherInfoDtoListResponse.getError(), cartItemDto);
                    }
                    Map<String, List<VoucherInfoDto>> map = voucherInfoDtoListResponse.getResult();
                    List<VoucherInfoDto> voucherInfoDtoListForGet = map.get("CouponsForGet");
                    List<VoucherInfoDto> voucherInfoDtoListForUse = map.get("CouponsForUse");
                    final BigDecimal pricePay = discountPrice;
                    Collection<VoucherInfoDto> finalListForUseCol = Collections2.filter(voucherInfoDtoListForUse, new Predicate<VoucherInfoDto>() {
                        @Override
                        public boolean apply(@NotNull VoucherInfoDto input) {
                            if (input.getVoucherFigure() == null || Strings.isNullOrEmpty(input.getVoucherFigure())) {
                                return false;
                            }
                            else {
                                Boolean single = true;
                                if (input.getLimitMoney()!=null){
                                    single = pricePay.compareTo(input.getLimitMoney())>=0;
                                }
                                Boolean pay = pricePay.compareTo(new BigDecimal(input.getVoucherFigure())) >= 0;
                                return single && pay;
                            }
                        }
                    });
                    List<VoucherInfoDto> finalListForUseList = Lists.newArrayList(finalListForUseCol);
                    cartItemDto.setVoucherForGetList(voucherInfoDtoListForGet.size() > 0 ? voucherInfoDtoListForGet : null);  // 优惠券--供领取（包括已用,未用） [***设定***]
                    cartItemDto.setVoucherInfoDtoList(finalListForUseList.size() > 0 ? finalListForUseList : null); // 优惠券--供选择使用（未用）      [***设定***]
                }
            }
            // 访问收藏服务返回收藏信息
            String checkFavoriteUser = null;
            Response<String> checkFavoriteUserResponse = userFavoriteService.checkFavoriteUser(itemId, user.getCustId());
            if (checkFavoriteUserResponse.isSuccess()) {
//				return setErrorCartSelect(checkFavoriteUserResponse.getError(),cartItemDto);
                checkFavoriteUser = checkFavoriteUserResponse.getResult();
            }

            // 收藏信息若为null 则默认收藏标识为0 标识未收藏
            // 单品收藏标识 是否已经收藏(1:收藏 0:未收藏)
            String userFavoriteFlag = checkFavoriteUser == null ? "0" : checkFavoriteUser;
            cartItemDto.setUserFavoriteFlag(userFavoriteFlag); // 收藏 [***设定***]

            // 商品积分类型转换
            String pointsTypeFormat;
            //	商品积分名
            String pointsTypeName;
            // 商品积分类型信息
            Response<TblCfgIntegraltypeModel> cfgResponse = cachePointsName.getUnchecked(pointsType);
            if (cfgResponse.isSuccess()) {
                TblCfgIntegraltypeModel typeModel = cfgResponse.getResult();
                pointsTypeFormat = typeModel.getIntegraltypeId();
                pointsTypeName = typeModel.getIntegraltypeNm();
            } else {
                pointsTypeFormat = Contants.JGID_COMMON;
                pointsTypeName = Contants.JGID_COMMON_NAME;
            }

            // 【所有单品都需要设定的值】
            cartItemDto.setEffectiveFlag("0");  // 商品有效           [***设定***]

            cartItemDto.setBonusType(pointsTypeFormat);     // 商品积分类型转换  [***设定***]
            cartItemDto.setStagesCode(String.valueOf(stagesCode));      // 分期数   [***设定***]

            cartItemDto.setOriPrice(oriPrice.toString());               // 原价                          [***设定***]
            cartItemDto.setOrdertypeId(ordertypeId);                    // 订单类型                      [***设定***]
            cartItemDto.setPointsTypeName(pointsTypeName);              // 商品积分类型名称              [***设定***]
            cartItemDto.setGoodsType(goodsModel.getGoodsType());        // 商品类型（00实物01虚拟02O2O） [***设定***]
            //(满减与积分抵扣优先级调试)
        }
        catch (Exception e) {
            log.error("fail to makeCartItemDto, cartid={}, error:{}", tblEspCustCartModel.getId(), Throwables.getStackTraceAsString(e));
            cartItemDto.setError("cartId.can.not.be.empty");
        }
        return cartItemDto;
    }

    /**
     * 做成失效的有错误的商品
     *
     * @param error 错误
     * @param cartItemDto 购物车中的一条
     */
    private CartItemDto setErrorCartSelect(String error, CartItemDto cartItemDto) {
        log.error("fail to makeCartItemDto, cartid={}, error:{}", cartItemDto.getCustCartId(), error);

        cartItemDto.setError(error);
        cartItemDto.setEffectiveFlag("1"); // 商品失效
        return cartItemDto;
    }

    /**
     * 做成新活动分组
     *
     * @param promotionGroupList 购物车中的活动列表
     * @param mallPromotionResultDto 活动信息
     * @return 活动分组
     */
    private PromotionGroup makeNewPromotionGroup(List<PromotionGroup> promotionGroupList,
                                                 MallPromotionResultDto mallPromotionResultDto) {
        PromotionGroup promotionGroup = null;
        boolean bIsNewPromotion;
        final Integer promotionId = mallPromotionResultDto.getPromItemResultList().get(0).getPromotionId();
        if (promotionGroupList.size() == 0) {
            bIsNewPromotion = true;
        }
        else {
            Collection<PromotionGroup> promotionGroupCollections = Collections2.filter(promotionGroupList,
                    new Predicate<PromotionGroup>() {
                        @Override
                        public boolean apply(@NotNull PromotionGroup input) {
                            return input.getPromotionId().intValue() == promotionId.intValue();
                        }
                    });
            if (promotionGroupCollections.iterator().hasNext()) {
                bIsNewPromotion = false;
                promotionGroup = promotionGroupCollections.iterator().next();
            } else {
                bIsNewPromotion = true;
            }
        }

        if (bIsNewPromotion) {
            promotionGroup = new PromotionGroup();
            promotionGroup.setPromotionId(promotionId);
            promotionGroup.setPeriodId(mallPromotionResultDto.getPeriodId());
            promotionGroup.setPromType(mallPromotionResultDto.getPromType());

            RuleFeeInfoDto ruleFeeInfo = new RuleFeeInfoDto();
            //包装满减信息
            ruleFeeInfo.setRuleFee1(mallPromotionResultDto.getRuleFee1());
            ruleFeeInfo.setRuleFee2(mallPromotionResultDto.getRuleFee2());
            ruleFeeInfo.setRuleFee3(mallPromotionResultDto.getRuleFee3());
            ruleFeeInfo.setRuleFee4(mallPromotionResultDto.getRuleFee4());
            ruleFeeInfo.setRuleFee5(mallPromotionResultDto.getRuleFee5());
            ruleFeeInfo.setRuleFee6(mallPromotionResultDto.getRuleFee6());
            ruleFeeInfo.setRuleFee7(mallPromotionResultDto.getRuleFee7());
            ruleFeeInfo.setRuleFee8(mallPromotionResultDto.getRuleFee8());
            ruleFeeInfo.setRuleFee9(mallPromotionResultDto.getRuleFee9());
            ruleFeeInfo.setRuleFee10(mallPromotionResultDto.getRuleFee10());
            ruleFeeInfo.setRuleMinPay1(mallPromotionResultDto.getRuleMinPay1());
            ruleFeeInfo.setRuleMinPay2(mallPromotionResultDto.getRuleMinPay2());
            ruleFeeInfo.setRuleMinPay3(mallPromotionResultDto.getRuleMinPay3());
            ruleFeeInfo.setRuleMinPay4(mallPromotionResultDto.getRuleMinPay4());
            ruleFeeInfo.setRuleMinPay5(mallPromotionResultDto.getRuleMinPay5());
            ruleFeeInfo.setRuleMinPay6(mallPromotionResultDto.getRuleMinPay6());
            ruleFeeInfo.setRuleMinPay7(mallPromotionResultDto.getRuleMinPay7());
            ruleFeeInfo.setRuleMinPay8(mallPromotionResultDto.getRuleMinPay8());
            ruleFeeInfo.setRuleMinPay9(mallPromotionResultDto.getRuleMinPay9());
            ruleFeeInfo.setRuleMinPay10(mallPromotionResultDto.getRuleMinPay10());
            promotionGroup.setRuleFeeInfo(ruleFeeInfo);

            promotionGroup.setCartItemDtoList(Lists.<CartItemDto>newArrayList());
            promotionGroupList.add(promotionGroup);
        }
        return promotionGroup;
    }


    /**
     * 设定当前数据在购物车中的位置
     *
     * @param cartDbResultDto  购物车信息总汇
     * @param cartItemDto 购物车表中的一条
     */
    private void setItemPositionInCarts(CartDbResultDto cartDbResultDto,
                                        CartItemDto cartItemDto) {
        MallPromotionResultDto mallPromotionResultDto = cartItemDto.getMallPromotionResult();
        // 订单类型id 区分:分期订单:FQ 一次性订单:YG 积分订单：JF',
        String ordertypeId = cartItemDto.getOrdertypeId();
        // 广发商城
        if (!Contants.BUSINESS_TYPE_JF.equals(ordertypeId)) {
            // 购物车_广发商城信息总汇
            if (cartDbResultDto.getCartGfShopDto() == null) {
                cartDbResultDto.setCartGfShopDto(new CartGfShopDto());
            }
            CartGfShopDto cartGfShopDto = cartDbResultDto.getCartGfShopDto();

            // 广发商城 分期
            if (Contants.BUSINESS_TYPE_FQ.equals(ordertypeId)) {
                // 购物车_广发商城信息总汇
                if (cartGfShopDto.getCreditCard() == null) {
                    cartGfShopDto.setCreditCard(new CreditCardCartItemDto());
                }
                CreditCardCartItemDto creditCard = cartGfShopDto.getCreditCard();

                // 活动
                if (mallPromotionResultDto != null) {
                    if (creditCard.getPromotionList() == null) {
                        creditCard.setPromotionList(Lists.<PromotionGroup>newArrayList());
                    }
                    PromotionGroup promotionGroup =  makeNewPromotionGroup(creditCard.getPromotionList(), mallPromotionResultDto);
                    promotionGroup.getCartItemDtoList().add(cartItemDto);
                }
                // 一般
                else {
                    if (creditCard.getOrdinaryList() == null) {
                        creditCard.setOrdinaryList(Lists.<CartItemDto>newArrayList());
                    }
                    creditCard.getOrdinaryList().add(cartItemDto);
                }
            }
            // 广发商城 一期
            else if (Contants.BUSINESS_TYPE_YG.equals(ordertypeId)) {
                if (cartGfShopDto.getBankCardList() == null) {
                    cartGfShopDto.setBankCardList(Lists.<CartItemDto>newArrayList());
                }
                cartGfShopDto.getBankCardList().add(cartItemDto);
            }
        }
        // 积分商城
        else {
            if (cartDbResultDto.getCartJFShopDto() == null) {
                cartDbResultDto.setCartJFShopDto(new CartJFShopDto());
            }
            CartJFShopDto cartJFShopDto = cartDbResultDto.getCartJFShopDto();
            // 全积分
            if (!Contants.SUB_ORDER_TYPE_01.equals(cartItemDto.getGoodsType())) {
                if (cartJFShopDto.getPayForPointList() == null) {
                    cartJFShopDto.setPayForPointList(Lists.<CartItemDto>newArrayList());
                }
                cartJFShopDto.getPayForPointList().add(cartItemDto);
            }
            // 虚拟
            else {
                if (cartJFShopDto.getVirtualList() == null) {
                    cartJFShopDto.setVirtualList(Lists.<CartItemDto>newArrayList());
                }
                cartJFShopDto.getVirtualList().add(cartItemDto);
            }
        }
        cartItemDto.setMallPromotionResult(null);
    }


    /**
     * 购物车排序
     *
     * @param cartDbResultDto  购物车信息总汇
     */
    private void sortCart(CartDbResultDto cartDbResultDto) {
        // 广发商城
        CartGfShopDto cartGfShopDto = cartDbResultDto.getCartGfShopDto();
        if (cartGfShopDto != null) {
            // 广发商城 分期
            CreditCardCartItemDto creditCard = cartGfShopDto.getCreditCard();
            if (creditCard != null) {
                // 活动
                creditCard.setPromotionList(sortPromotionGroupList(creditCard.getPromotionList()));
                List<PromotionGroup> promotionGroupList = creditCard.getPromotionList();
                if (promotionGroupList != null) {
                    for (PromotionGroup promotionGroup : promotionGroupList) {
                        promotionGroup.setCartItemDtoList(sortCartItemList(promotionGroup.getCartItemDtoList()));
                    }
                }
                // 一般
                creditCard.setOrdinaryList(sortCartItemList(creditCard.getOrdinaryList()));
            }

            // 广发商城 一期
            cartGfShopDto.setBankCardList(sortCartItemList(cartGfShopDto.getBankCardList()));
        }
        // 积分商城
        CartJFShopDto cartJFShopDto = cartDbResultDto.getCartJFShopDto();
        if(cartJFShopDto != null) {
            // 全积分
            cartJFShopDto.setPayForPointList(sortCartItemList(cartJFShopDto.getPayForPointList()));
            // 虚拟
            cartJFShopDto.setVirtualList(sortCartItemList(cartJFShopDto.getVirtualList()));
        }
    }

    /**
     * 异步执行 检索购物车页面的一条数据 外部渠道
     *
     * @param tblEspCustCartModel 购物车中的一条
     * @param cart_type 卡类型
     * @param custCarQueryGoodsReturnList 查询返回值
     * @return 基础返回报文
     * @return
     */
    private Callable<CustCarAddReturn> callAbleSelectOneCartItemOut(final TblEspCustCartModel tblEspCustCartModel,
                                                                    final String cart_type,
                                                                    final List<CustCarQueryGoodsReturn> custCarQueryGoodsReturnList) {
        Callable<CustCarAddReturn> ret = new Callable<CustCarAddReturn>() {
            @Override
            public CustCarAddReturn call() throws Exception {
                try {
                    return makeOneCartItemOut(tblEspCustCartModel,
                            cart_type,
                            custCarQueryGoodsReturnList);
                } catch (Exception e) {
                    log.error("cartservice.select.cart.error,{}", Throwables.getStackTraceAsString(e));
                    return setCartAddReturnInfo("000009", "查询购物车发生异常", new CustCarAddReturn());
                }
            }
        };
        return ret;
    }

    /**
     * 被异步调用 检索购物车页面的一条数据
     *
     * @param tblEspCustCartModel 购物车中的一条
     * @param cart_type 卡类型
     * @param custCarQueryGoodsReturnList 查询返回值
     * @return 基础返回报文
     */
    private CustCarAddReturn makeOneCartItemOut(TblEspCustCartModel tblEspCustCartModel, String cart_type,
                                                List<CustCarQueryGoodsReturn> custCarQueryGoodsReturnList) {
        CustCarAddReturn carAddReturn = new CustCarAddReturn();
        try {
            // 通过单品ID查询单品表
            String itemId = tblEspCustCartModel.getItemId();
            ItemModel itemModel = itemService.findById(itemId);
            if (itemModel == null) {
                log.error("cartservice.can't find iteminfo");
                return this.setCartAddReturnInfo("000009", "查询购物车发生异常", carAddReturn);
            }

            // 通过商品code查询商品表
            Response<GoodsModel> goodsModelResponse = goodsService.findCacheById(itemModel.getGoodsCode());
            GoodsModel goodsModel = null;
            if (goodsModelResponse.isSuccess()) {
                goodsModel = goodsModelResponse.getResult();
            }
            if (goodsModel == null) {
                log.error("cartservice.can't find goodsinfo");
                return this.setCartAddReturnInfo("000009", "查询购物车发生异常", carAddReturn);
            } else if (!goodsModel.getChannelPhone().equals("02")) {
                log.error("cartservice.can't find ChannelPhone info");
                return this.setCartAddReturnInfo("000009", "查询购物车发生异常", carAddReturn);
            }
            //  满减活动从商品支付表获取支付信息，所以不需要查询活动
            // 查询商品支付方式表
            TblGoodsPaywayModel tblGoodsPaywayModel = null;
            //修改如果有活动就取活动价格 目前仅有手机端查购物车
            Response<MallPromotionResultDto> result = mallPromotionService
    		.findPromByItemCodes("1", itemModel.getCode(),"03");// 活动进行中
            boolean promotionFlag=false;
            if (result.isSuccess()) {
    	    if (result.getResult() != null) {
    		promotionFlag=true;
    	    }
    	    }
            if(promotionFlag){
        	Integer promotionId = result.getResult()
			.getPromItemResultList().get(0).getPromotionId();
        	Map<String, Object> param = new HashMap<>();
		param.put("goodsPaywayId", tblEspCustCartModel.getGoodsPaywayId());
		param.put("promId", promotionId);
		Response<PromotionPayWayModel> resultResponse = promotionPayWayService
			.findPomotionPayWayInfoByParam(param);
		if (resultResponse.isSuccess()) {
		    // 将活动payway赋值到普通payway两个VO完全一样 最后使用普通payway进行处理
		    tblGoodsPaywayModel = BeanUtils.copy(resultResponse.getResult(),
			    TblGoodsPaywayModel.class);
		    if (tblGoodsPaywayModel == null) {
			 return this.setCartAddReturnInfo("000009", "查询购物车发生异常", carAddReturn);
		    }
		}
            }else{
        	Response<TblGoodsPaywayModel> tblGoodsPaywayModelResponse = goodsPayWayService
                        .findGoodsPayWayInfo(tblEspCustCartModel.getGoodsPaywayId());
                if (tblGoodsPaywayModelResponse.isSuccess()) {
                    tblGoodsPaywayModel = tblGoodsPaywayModelResponse.getResult();
                }
            }


            if (tblGoodsPaywayModel == null) {
                log.error("cartservice.can't find goodsPayway info");
                return this.setCartAddReturnInfo("000009", "查询购物车发生异常", carAddReturn);
            } else if (tblGoodsPaywayModel.getIscheck().equals("d")
                    && !tblGoodsPaywayModel.getIsAction().equals("0")) {
                log.error("cartservice.can't find active goodsPayway info");
                return this.setCartAddReturnInfo("000009", "查询购物车发生异常", carAddReturn);
            }

            // 组装返回信息
            CustCarQueryGoodsReturn custCarQueryGoodsReturn = new CustCarQueryGoodsReturn();
            custCarQueryGoodsReturn.setId(tblEspCustCartModel.getId().toString());
            custCarQueryGoodsReturn.setCustId(tblEspCustCartModel.getCustId());
            custCarQueryGoodsReturn.setGoodsId(tblEspCustCartModel.getItemId());
            custCarQueryGoodsReturn.setGoodsNm(goodsModel.getName());
            String goods_num = tblEspCustCartModel.getGoodsNum() != null ? tblEspCustCartModel.getGoodsNum() : "0";// 商品数量
            String single_point = tblEspCustCartModel.getSinglePoint() != null
                    ? tblEspCustCartModel.getSinglePoint().toString() : "0";// 单位积分
            String oriBonusValue = tblEspCustCartModel.getOriBonusValue() != null
                    ? tblEspCustCartModel.getOriBonusValue().toString() : "0";// 抵扣总积分(取折扣前积分)
            String goodsPrice = String.valueOf(tblGoodsPaywayModel.getGoodsPrice() != null
                    ? tblGoodsPaywayModel.getGoodsPrice().toString() : "0");// 商品价格


            // n件商品的总抵扣积分
            String oriBonusValueSum = totPrice(oriBonusValue, goods_num);
            // n件商品共可以抵扣金额
            BigDecimal disCountSum = calGoodsPrice(new BigDecimal(single_point),
                    new BigDecimal(oriBonusValueSum));
            // 每件商品抵扣金额数目
            BigDecimal disCountForSingleGoods = getSingleDiscount(disCountSum, goods_num);
            String discount_goods_price = String
                    .valueOf(new BigDecimal(goodsPrice).subtract(disCountForSingleGoods));// 扣减每件商品抵扣的积分后的商品价格
            custCarQueryGoodsReturn.setGoodsPriceY(discount_goods_price);// 一期单件商品价格
            Integer stages_code = 0;
            String goods_price_f = "";
            if (tblGoodsPaywayModel.getStagesCode() != null && tblGoodsPaywayModel.getStagesCode()!=0 && tblGoodsPaywayModel.getPerStage() != null) {// 如果有分期
                stages_code = tblGoodsPaywayModel.getStagesCode();
                goods_price_f = fenPrice(discount_goods_price, String.valueOf(stages_code));// 重新计算的分期价格
            }
            custCarQueryGoodsReturn.setGoodsPriceF(goods_price_f);
            custCarQueryGoodsReturn.setStagesNum(stages_code.toString());
            custCarQueryGoodsReturn.setGoodsPrice(discount_goods_price);
            //custCarQueryGoodsReturn.setGoodsPoint(tblGoodsPaywayModel.getGoodsPoint() != null ? tblGoodsPaywayModel.getGoodsPoint().toString() : "0");
            //FIXME 以前从商品payway中获取 改为 从购物车中获取
            custCarQueryGoodsReturn.setGoodsPoint(oriBonusValue);//单个商品的积分
            custCarQueryGoodsReturn.setGoodsOid(Strings.nullToEmpty(itemModel.getOid()));
            custCarQueryGoodsReturn.setGoodsMid(Strings.nullToEmpty(itemModel.getMid()));
            custCarQueryGoodsReturn.setGoodsBacklog(itemModel.getStock() != null ? itemModel.getStock().toString() : "0");
            custCarQueryGoodsReturn.setAlertNum(itemModel.getStockWarning() != null ? itemModel.getStockWarning().toString() : "0");
            custCarQueryGoodsReturn.setGoodsXid(Strings.nullToEmpty(itemModel.getXid()));
            custCarQueryGoodsReturn.setJfType(Strings.nullToEmpty(goodsModel.getPointsType()));
            custCarQueryGoodsReturn.setGoodsPaywayId(tblEspCustCartModel.getGoodsPaywayId());// 商品支付编号
            custCarQueryGoodsReturn.setGoodsNum(tblEspCustCartModel.getGoodsNum());// 商品数目
            custCarQueryGoodsReturn.setOrdertypeId(tblEspCustCartModel.getOrdertypeId());// 订单类型ID
            custCarQueryGoodsReturn
                    .setAddDate(DateHelper.date2string(tblEspCustCartModel.getAddTime(), "yyyyMMdd"));// 添加日期
            custCarQueryGoodsReturn
                    .setAddTime(DateHelper.date2string(tblEspCustCartModel.getAddTime(), "HHmmss"));// 添加时间

            custCarQueryGoodsReturn.setPaywayCode(tblGoodsPaywayModel.getPaywayCode());
            //FIXME  0001代表 现金支付 0003代表现金加积分
            if(Contants.BUSINESS_TYPE_FQ.equals(tblEspCustCartModel.getOrdertypeId())){
        	//如果是广发商城 并且是使用了积分则说明是积分加现金支付
        	if(tblEspCustCartModel.getBonusValue()>0&&tblEspCustCartModel.getOriBonusValue()>0){
        	    custCarQueryGoodsReturn.setPaywayCode(Contants.PAY_WAY_CODE_JFXJ);
        	}
            }

            custCarQueryGoodsReturn.setPictureUrl(Strings.nullToEmpty(itemModel.getImage1()));
            if (cart_type != null && !Contants.BUSINESS_TYPE_JF.equals(cart_type)) {
                //custCarQueryGoodsReturn.setGoodsPoint(tblGoodsPaywayModel.getGoodsPoint() != null ? tblGoodsPaywayModel.getGoodsPoint().toString() : "0");// 积分查询不用作积分抵扣
              //FIXME 以前从商品payway中获取 改为 从购物车中获取
                custCarQueryGoodsReturn.setGoodsPoint(oriBonusValueSum);
            }
            custCarQueryGoodsReturn.setSinglePoint(tblEspCustCartModel.getSinglePoint() == null ? "0"
                    : tblEspCustCartModel.getSinglePoint().toString());// 当月单位积分
            custCarQueryGoodsReturnList.add(custCarQueryGoodsReturn);
        }
        catch (Exception e) {
            log.error("cartservice.select.cart.error,{}", Throwables.getStackTraceAsString(e));
            return this.setCartAddReturnInfo("000009", "查询购物车发生异常", carAddReturn);
        }
        log.error("cartservice.select.cart.success,{}");
        return this.setCartAddReturnInfo("000000", "", carAddReturn);
    }
    /**
     * 购物车各组数据的排序
     *
     * @param cartItemDtoList 购物车表中的一组（排序前）
     * @return 购物车表中的一组（排序后）
     */
    private List<CartItemDto> sortCartItemList(List<CartItemDto> cartItemDtoList) {
        if (cartItemDtoList == null || cartItemDtoList.size() == 0) {
            return cartItemDtoList;
        }
        Ordering<CartItemDto> ordering = new Ordering<CartItemDto>() {
            @Override
            public int compare(@NotNull CartItemDto left, @NotNull CartItemDto right) {
                return Longs.compare(left.getCustCartId(), right.getCustCartId());
            }
        };
        return ordering.sortedCopy(cartItemDtoList);
    }
    /**
     * 设定所有活动分组在购物车中活动信息的位置
     *
     * @param promotionGroupList 购物车表中的多组活动（排序前）
     * @return 购物车表中的多组活动(排序后）
     */
    private List<PromotionGroup> sortPromotionGroupList(List<PromotionGroup> promotionGroupList) {
        if (promotionGroupList == null || promotionGroupList.size() == 0) {
            return promotionGroupList;
        }
        Ordering<PromotionGroup> ordering = new Ordering<PromotionGroup>() {
            @Override
            public int compare(@NotNull PromotionGroup left, @NotNull PromotionGroup right) {
                return Longs.compare(left.getPromType(), right.getPromType());
            }
        };
        return ordering.sortedCopy(promotionGroupList);
    }

    /**
     * 购物车各组数据的排序
     *
     * @param list 购物车表中的一组（排序前）
     * @return 购物车表中的一组（排序后）
     */
    private List<CustCarQueryGoodsReturn> sortCartOutList(List<CustCarQueryGoodsReturn> list) {
        if (list == null || list.size() == 0) {
            return list;
        }
        Ordering<CustCarQueryGoodsReturn> ordering = new Ordering<CustCarQueryGoodsReturn>() {
            @Override
            public int compare(@NotNull CustCarQueryGoodsReturn left, @NotNull CustCarQueryGoodsReturn right) {
                return left.getId().compareTo(right.getId());
            }
        };
        return ordering.sortedCopy(list);
    }

    /**
     * 添加购物车时的校验结果做成
     *
     * @param errorCode 错误code
     * @param errorMessage 错误内容
     * @param custCarAddReturn 新增购物车时的返回报文
     */
    private CustCarAddReturn setCartAddReturnInfo(String errorCode, String errorMessage, CustCarAddReturn custCarAddReturn) {
        log.error("trade.cart.add.error,{}",errorMessage);
        custCarAddReturn.setReturnCode(errorCode);
        custCarAddReturn.setReturnDes(errorMessage);
        return custCarAddReturn;
    }

    /**
     * 添加购物车时的校验
     *
     * @param cartAddDto  购物车信息总汇
     * @return 校验结果
     */
    private CustCarAddReturn addOneCartInfo(CartAddDto cartAddDto) {
        CustCarAddReturn custCarAddReturn = new CustCarAddReturn();
        try {
            // 用来监听添加购物记录数 报表用的
            cartAddRecord(cartAddDto);

            // 发起方 调用方标识:如手机商城:03 外部提供接口 传递origin值 广发商城默认值"00"
            String origin = cartAddDto.getOrigin() == null ? "00" : cartAddDto.getOrigin().toString() ;
            // 商城类型 商城类型标识,如广发商城:01 积分商城02 广发商城默认值"01"
            String mallType = cartAddDto.getMallType() == null ? "01" : cartAddDto.getMallType().toString();
            String ordertypeId = cartAddDto.getOrdertypeId(); // 订单类型
            String custId = cartAddDto.getCustId(); // 客户号
            String itemId = cartAddDto.getItemId(); // 单品编码
            String goodsPaywayId = cartAddDto.getGoodsPaywayId(); // 支付方式编码
            Long bonusValue = cartAddDto.getBonusValue() == null ? 0L : cartAddDto.getBonusValue(); // 积分抵扣数
            int goodsNum = Strings.isNullOrEmpty(cartAddDto.getGoodsNum()) ? 0 : Integer.parseInt(cartAddDto.getGoodsNum());

            // chekck 传入数量是否小于1
            if (goodsNum < 1) {
                return setCartAddReturnInfo("000008", "商品数目不能小于1", custCarAddReturn);
            }

            // check单品是否存在
            ItemModel itemModel = itemService.findById(cartAddDto.getItemId());
            if (itemModel == null) {// 商品信息不存在
                return setCartAddReturnInfo("000010", "单品信息不存在", custCarAddReturn);
            }
            // check商品是否存在
            String goodId = itemModel.getGoodsCode();
            if (Strings.isNullOrEmpty(goodId)) {
                return setCartAddReturnInfo("000027", "goodsId为空", custCarAddReturn);
            }

            // 获取商品信息
            Response<GoodsModel> goodsModelResponse = goodsService.findById(goodId);
            if (!goodsModelResponse.isSuccess()) {
                return setCartAddReturnInfo("000027", "商品信息不存在", custCarAddReturn);
            }
            GoodsModel goodsModel = goodsModelResponse.getResult();
            boolean isOnShelf = isOnShelf(origin, mallType, goodsModel);
            // check 商品是否为上架状态
            if (!isOnShelf) {
                return setCartAddReturnInfo("000036", "商品不在上架状态", custCarAddReturn);
            }

            // 判断积分池余额
            Response<PointPoolModel> pointPoolModelResponse = pointsPoolService.getLastInfo();
            if (pointPoolModelResponse.isSuccess()) {
                PointPoolModel pointPoolModel = pointPoolModelResponse.getResult();
                // 积分池余额
                Long surplusPoint = pointPoolModel.getMaxPoint() - pointPoolModel.getUsedPoint();
                if (surplusPoint.longValue() <= 0 && bonusValue.longValue() > 0) {
                    return setCartAddReturnInfo("000070", "积分池不足", custCarAddReturn);
                }
            }
            else {
                return setCartAddReturnInfo("000027", "查询积分池信息异常", custCarAddReturn);
            }

            Map<String, Object> custInfoParam = Maps.newHashMap();
            custInfoParam.put("custId", custId);
            custInfoParam.put("itemId", itemId);
            custInfoParam.put("ordertypeId", ordertypeId);
            custInfoParam.put("goodsPaywayId", goodsPaywayId);

            // 广发商城
            if (Contants.CHANNEL_MALL_CODE.equals(origin)) {  // 广发商城特有部分
                Long oriBonusValue = cartAddDto.getOriBonusValue() == null ? Long.valueOf(0) : cartAddDto.getOriBonusValue(); // 原积分抵扣数
                custInfoParam.put("oriBonusValue", oriBonusValue);
                custInfoParam.put("payFlag", "0");
                custInfoParam.put("singlePoint", cartAddDto.getSinglePoint() == null ? Long.valueOf(0) : cartAddDto.getSinglePoint());
            }
            else {
                custInfoParam.put("bonusValue", bonusValue);
            }
            // check购物车单条信息是否存在
            TblEspCustCartModel tblEspCustCartModel = tblEspCustCartDao.findByCustInfo(custInfoParam);

            String goodsType = goodsModel.getGoodsType();
            boolean dbResult;
            // 不存在， 新做成
            if (tblEspCustCartModel == null) {
                // 包装插入数据
                TblEspCustCartModel tblEspCustCart = new TblEspCustCartModel();
                tblEspCustCart.setCustId(custId);
                tblEspCustCart.setGoodsType(goodsModel.getGoodsType());
                tblEspCustCart.setItemId(itemId);
                tblEspCustCart.setOrdertypeId(ordertypeId);
                tblEspCustCart.setGoodsPaywayId(goodsPaywayId);
                tblEspCustCart.setBonusValue(bonusValue);//积分抵扣数
                tblEspCustCart.setPayFlag("0");
                tblEspCustCart.setFixBonusValue(itemModel.getFixPoint() == null ? Long.valueOf(0) : itemModel.getFixPoint());
                tblEspCustCart.setCustmerNm(cartAddDto.getCustmerNm());//用户等级文字
                if (Contants.CHANNEL_MALL_CODE.equals(origin)) {  // 广发商城特有部分
                    // 00 广发商城 特有部分
                    Long oriBonusValue = cartAddDto.getOriBonusValue() == null ? Long.valueOf(0) : cartAddDto.getOriBonusValue(); // 原积分抵扣数
                    Long singlePoint = cartAddDto.getSinglePoint() == null ? Long.valueOf(0) : cartAddDto.getSinglePoint();  // 积分兑换比例
                    tblEspCustCart.setOriBonusValue(oriBonusValue);
                    tblEspCustCart.setSinglePoint(singlePoint);

                    //特殊数据传输start
                    tblEspCustCart.setVirtualMemberId(cartAddDto.getVirtualMemberId());//会员号
                    tblEspCustCart.setVirtualMemberNm(cartAddDto.getVirtualMemberNm());//会员姓名
                    tblEspCustCart.setVirtualAviationType(cartAddDto.getVirtualAviationType());//航空类型
                    tblEspCustCart.setEntryCard(cartAddDto.getEntryCard());//附属卡号
                    tblEspCustCart.setAttachIdentityCard(cartAddDto.getAttachIdentityCard());//留学生意外险附属卡证件号码
                    tblEspCustCart.setAttachName(cartAddDto.getAttachName());//留学生意外险附属卡姓名
                    tblEspCustCart.setPrepaidMob(cartAddDto.getPrepaidMob());//充值电话号码(保留)
                    tblEspCustCart.setSerialno(cartAddDto.getSerialno());//客户所输入的保单号(保留)
                    //FIXME 重新赋值没意义是不是保单号没设置上            //保单号(保留)
                    //tblEspCustCart.setSerialno(cartAddDto.getSerialno());
                    //特殊数据传输end
                    tblEspCustCart.setCardType(cartAddDto.getCardType());

                    if (Contants.BUSINESS_TYPE_JF.equals(ordertypeId) && Contants.GOODS_TYPE_ID_01.equals(goodsType)) {
                        //	 检索用户所有JF商城信息
                        Map<String, Object> custInfoJFParam = Maps.newHashMap();
                        custInfoJFParam.put("custId", custId);
                        custInfoJFParam.put("ordertypeId", Contants.BUSINESS_TYPE_JF);
                        //判断虚拟商品在购物车内仅存在一种
                        //如果新加入的礼品是虚拟礼品，需要判断购物车内是否存在其它虚拟礼品
                        Boolean isOnlyVirtualInCart = checkOnlyVirtualInCart(custInfoJFParam, itemId);
                        if (!isOnlyVirtualInCart) {
                            return setCartAddReturnInfo("000027", "尊敬的客户，虚拟商品一次只允许购买一种。", custCarAddReturn);
                        }
                    }
                }
                else {
                    Response<PointPoolModel> response = pointsPoolService.getCurMonthInfo();
                    if (response.isSuccess()) {
                        PointPoolModel pointPoolModel = response .getResult(); // tblGoodsInfBySqlDao.getPointPool();
                        if (pointPoolModel != null) {
                            Long singlePoint = pointPoolModel.getSinglePoint();
                            tblEspCustCart.setSinglePoint(singlePoint);
                        }
                    }
                    if(Contants.BUSINESS_TYPE_JF.equals(ordertypeId)&&Contants.CHANNEL_PHONE_CODE.equals(origin)){
                	//手机端积分商城单位积分比例为0
                	tblEspCustCart.setSinglePoint(0l);
                	//并且需要设置单品积分  根据goodsPaywayId来获取
                	Response<TblGoodsPaywayModel>  rs=goodsPayWayService.findGoodsPayWayInfo(goodsPaywayId);
                	if(rs.isSuccess()){
                	    if(rs.getResult()!=null){
                		bonusValue=rs.getResult().getGoodsPoint();
                		tblEspCustCart.setBonusValue(bonusValue);
                	    }
                	}
                    }
                    //TODO 高等级卡 用户是错误的
                    tblEspCustCart.setOriBonusValue(bonusValue);
                }

                tblEspCustCart.setGoodsNum(String.valueOf(goodsNum));
                dbResult = cartManager.insert(tblEspCustCart);
            }
            // 已经存在  ，check 数量 改变数量
            else {
                // 添加后单品数量 合计
                int newGoodsNum = Integer.parseInt(tblEspCustCartModel.getGoodsNum()) + goodsNum;
                // 积分商城的虚拟商品不check 99
                if (!Contants.GOODS_TYPE_ID_01.equals(goodsType) && newGoodsNum > 99){
                    return setCartAddReturnInfo("000028", "加入购物车单品数量超过99", custCarAddReturn);
                }
                List<CustCarUpdateInfo> updateInfo = Lists.newArrayList();
                CustCarUpdateInfo custCarUpdateInfo = new CustCarUpdateInfo();
                custCarUpdateInfo.setId(tblEspCustCartModel.getId().toString());
                custCarUpdateInfo.setGoodsNum(String.valueOf(newGoodsNum));
                updateInfo.add(custCarUpdateInfo);
                dbResult = cartManager.update(updateInfo);
            }
            if (!dbResult) { // 失败
                return setCartAddReturnInfo("000027", "更新数据库异常", custCarAddReturn);
            }
        }
        catch (Exception e) {
            log.error("checkCartAdd is error:{}", Throwables.getStackTraceAsString(e));
            return setCartAddReturnInfo("000027", "添加购物车发生异常", custCarAddReturn);
        }
        custCarAddReturn.setReturnCode("000000");
        custCarAddReturn.setReturnDes("添加购物成功");
        return custCarAddReturn;
    }


    /**
     * 外部接口添加的购物车的entity转换为商城的entity
     *
     * @param custCarAdd 外部接口添加的购物车信息
     * @return 商城购物车信息
     */
    private CartAddDto changeOutCartAddEntity(CustCarAdd custCarAdd) {
        CartAddDto cartAddDto = new CartAddDto();
        cartAddDto.setOrigin(custCarAdd.getOrigin());//渠道03:如手机商城  :00网上商城（包括广发，积分商城）CHANNEL_MALL_CODE
        cartAddDto.setMallType(custCarAdd.getMallType());//商城类型商城类型标识01:广发商城;"02":积分商城
        cartAddDto.setOrdertypeId(custCarAdd.getOrdertypeId());//订单类型id:分期订单:FQ一次性订单:YG积分订单：JF
        cartAddDto.setCustId(custCarAdd.getCustId());//客户id
        cartAddDto.setItemId(custCarAdd.getGoodsId());//单品id
        cartAddDto.setGoodsPaywayId(custCarAdd.getGoodsPaywayId());//付款方式id
        cartAddDto.setGoodsNum(custCarAdd.getGoodsNum());//数量
        cartAddDto.setBonusValue(Strings.isNullOrEmpty(custCarAdd.getBonusValue()) ? 0L : Long.parseLong(custCarAdd.getBonusValue()));//抵扣积分
        return cartAddDto;
    }

//    /**
//     * 取得兑换等级
//     *
//     * @param memberLevel 会员ID
//     */
//    private String getExchangeLevelName(String memberLevel) {
//        memberLevel = memberLevel == null ? "" : memberLevel;
//        String exchangeLevelName = ""; // 兑换等级
//        //兑换等级
//        // 尊越/臻享白金+钛金卡
//        if (Contants.MEMBER_LEVEL_TJ_CODE.equals(memberLevel)){
//            exchangeLevelName = Contants.MEMBER_LEVEL_TJ_NM;
//        }
//        //	顶级/增值白金卡
//        else if (Contants.MEMBER_LEVEL_DJ_CODE.equals(memberLevel)){
//            exchangeLevelName = Contants.MEMBER_LEVEL_DJ_NM;
//        }
//        //	VIP
//        else if (Contants.MEMBER_LEVEL_VIP_CODE.equals(memberLevel)){
//            exchangeLevelName = (Contants.MEMBER_LEVEL_VIP_NM).toUpperCase();
//        }
//        //	生日
//        else if (Contants.MEMBER_LEVEL_BIRTH_CODE.equals(memberLevel)){
//            exchangeLevelName = Contants.MEMBER_LEVEL_BIRTH_NM;
//        }
//        //	积分+现金
//        else if (Contants.MEMBER_LEVEL_INTEGRAL_CASH_CODE.equals(memberLevel)){
//            exchangeLevelName = Contants.MEMBER_LEVEL_INTEGRAL_CASH_NM;
//        }
//        //	普卡/金卡
//        else {
//            exchangeLevelName = Contants.MEMBER_LEVEL_JP_NM;
//        }
//        return exchangeLevelName;
//    }

    /**
     * 查询用户当月积分总数
     * @param itemId
     * @param user
     * @return
     */
    private Response<Long> queryTotalBonusInAMonthByGoodsId(String itemId,User user){
        Response<Long> response = new Response<Long>();
        String custId = user.getCustId();
        long returnValue = 0;
        Date firstDayofMonth = DateHelper.getFirstDayOfMonth();
        String strFirstDayofMonth = DateHelper.date2string(firstDayofMonth,DateHelper.YYYY_MM_DD_HH_MM_SS);
        String nowDate = DateHelper.getCurrentTime();
        try{
            Map<String, Object> paramMap = Maps.newHashMap();
            paramMap.put("itemId",itemId);
            paramMap.put("custId",custId);
            paramMap.put("strFirstDayofMonth",strFirstDayofMonth);
            paramMap.put("nowDate",nowDate);
            Long temp = orderSubDao.selectTotalBonusByParam(paramMap);
            returnValue = temp == null ? 0l:temp;
            response.setResult(returnValue);
            return  response;
        }catch (Exception e){
            log.error("trade.cart.total.bonus", Throwables.getStackTraceAsString(e));
            response.setError("trade.cart.total.bonus");
            return  response;
        }
    }
    /**
     * check 商品在所在渠道是否为上架状态
     *
     * @param origin goodsModel
     * @param mallType 商城类型
     * @param goodsModel 商品信息
     * @return true false
     * @author Congzy
     * @describe 私有方法
     */
    private boolean isOnShelf(String origin, String mallType, GoodsModel goodsModel) {
        String channelState = ""; // 发起渠道
        boolean isOnShelf; // 是否上架状态
        switch (origin) {
            // 广发商城
            case Contants.CHANNEL_MALL_CODE:
                // 广发商城 (分期)
                if (Contants.MAll_GF.equals(mallType)) {
                    channelState = goodsModel.getChannelMall();
                }
                // 积分商城
                else if (Contants.MAll_POINTS.equals(mallType)) {
                    channelState = goodsModel.getChannelPoints();
                }
                break;
            // 手机商城
            case Contants.CHANNEL_PHONE_CODE:
                channelState = goodsModel.getChannelPhone();
                break;
            // CallCenter
            case Contants.CHANNEL_CC_CODE:
                channelState = goodsModel.getChannelCc();
                break;
            // IVR渠道
            case Contants.CHANNEL_IVR_CODE:
                channelState = goodsModel.getChannelIvr();
                break;
            // 短信渠道
            case Contants.CHANNEL_SMS_CODE:
                channelState = goodsModel.getChannelSms();
                break;
            // APP渠道
            case Contants.CHANNEL_APP_CODE:
                channelState = goodsModel.getChannelApp();
                break;
            // 广发银行(微信)
            case Contants.CHANNEL_MALL_WX_CODE:
                channelState = goodsModel.getChannelMallWx();
                break;
            // 广发信用卡(微信)
            case Contants.CHANNEL_CREDIT_WX_CODE:
                channelState = goodsModel.getChannelCreditWx();
                break;
            default:
                channelState = "88";
                break;
        }
        // 判断商品是否为上架状态
        if (Contants.STATE_ON_SELL_CODE.equals(channelState)) {
            isOnShelf = true;
        } else {
            isOnShelf = false;
        }
        return isOnShelf;
    }

    /**
     *
     * 计算单件商品的积分抵扣金额
     *
     * @param bunusVal 购物车的某类商品的积分总数
     * @param goodNum 购物车的某类商品的数目
     * @return
     * @throws Exception
     */
    private BigDecimal getSingleDiscount(BigDecimal bunusVal, String goodNum) throws Exception {
        BigDecimal discount = new BigDecimal(0);
        try {

            if (!"0".equals(goodNum)) {
                discount = bunusVal.divide(new BigDecimal(goodNum), 2, BigDecimal.ROUND_HALF_UP);
            }
        } catch (Exception e) {
            log.error("bunusVal={},goodNum={}", bunusVal, goodNum);
            log.error("金额计算有误");
            return discount;
        }
        return discount;
    }

    /**
     * 计算分期价格（价格/期数）
     * @param price 价格
     * @param stages 期数
     * @return 总价
     * @throws Exception
     */
    private String fenPrice(String price, String stages) throws Exception {
        try {
            BigDecimal bd = new BigDecimal(price);
            return bd.divide(new BigDecimal(stages), BigDecimal.ROUND_DOWN).toString();
        } catch (Exception ex) {
            log.error("price={},stages={}", price, stages);
            log.error("金额计算有误");
            return "";
        }
    }

    /**
     * 积分兑换 用户最多能购买数量
     * @param itemModel
     * @param goodsPoint
     * @param user
     * @return
     */
    private String getMaxUsedBonus(ItemModel itemModel,Long goodsPoint,User user){
        String maxUsedBnous;
        Long virtualIntegralLimitFormat = itemModel.getVirtualIntegralLimit();
        BigDecimal virtualIntegralLimit = new BigDecimal(0);
        if (virtualIntegralLimitFormat != null){
            virtualIntegralLimit = new BigDecimal(virtualIntegralLimitFormat);//商品极限
        }
        Response<Long> usedBonusFormatResponse = queryTotalBonusInAMonthByGoodsId(itemModel.getCode(),user);
        if(!usedBonusFormatResponse.isSuccess()){
            log.error("Response.error,error code: {}", usedBonusFormatResponse.getError());
            throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
        }
        long usedBonusFormat = usedBonusFormatResponse.getResult();
        BigDecimal usedBonus = new BigDecimal(usedBonusFormat);	//用户已用
        if (itemModel.getVirtualIntegralLimit() == null || itemModel.getVirtualIntegralLimit() == 0l){
            maxUsedBnous = "无限大";
        }
        else {
            BigDecimal maxUsedBnousFormat = virtualIntegralLimit.subtract(usedBonus).divide(
                    BigDecimal.valueOf(goodsPoint),0,BigDecimal.ROUND_DOWN);
            maxUsedBnous = maxUsedBnousFormat.toString();
        }
        return maxUsedBnous;
    }

    /**
     * 虚拟商品在购物车内仅存在一种
     * @param custInfoJFParam
     * @param itemId
     * @return
     */
    private Boolean checkOnlyVirtualInCart(Map<String,Object> custInfoJFParam,String itemId){
        Boolean isOnly = true;
        try {
            List<TblEspCustCartModel> tblEspCustCartModelList = tblEspCustCartDao.findByCustId(custInfoJFParam);
            Collection<TblEspCustCartModel> listFilter = Collections2.filter(tblEspCustCartModelList,
                    new Predicate<TblEspCustCartModel>() {
                        @Override
                        public boolean apply(@NotNull TblEspCustCartModel input) {
                            return Contants.GOODS_TYPE_ID_01.equals(input.getGoodsType());
                        }
                    });
            if (listFilter.iterator().hasNext()) {
                isOnly = itemId.equals(listFilter.iterator().next().getItemId());
            }

            return isOnly;
        }catch (Exception e){
            log.error("trade.cart.check.only.virtual", Throwables.getStackTraceAsString(e));
            return isOnly;
        }
    }

    /**
     * Description:计算积分抵扣金额
     * @param singlePoint 单位积分
     * @param bunusVal 抵扣积分数
     * @return
     * @throws Exception
     */
    private BigDecimal calGoodsPrice(BigDecimal singlePoint, BigDecimal bunusVal) throws Exception {
        BigDecimal discount = new BigDecimal(0);
        try {
            if (singlePoint.compareTo(new BigDecimal(0)) != 0) {
                discount = bunusVal.divide(singlePoint, 2, BigDecimal.ROUND_HALF_UP);
            }
        } catch (Exception e) {
            log.error("金额计算有误");
            return discount;
        }
        return discount;
    }

    /**
     * 计算总价（单价*数量）
     * @param price 单价
     * @param count 数量
     * @return 总价
     * @throws Exception
     */
    private String totPrice(String price, String count) throws Exception {
        try {
            log.info("price={},count={}", price, count);
            BigDecimal bd = new BigDecimal(price);
            return bd.multiply(new BigDecimal(count)).toString();
        } catch (Exception ex) {
            log.error("金额计算有误");
            return "";
        }
    }

    /**
     * Description : 监听器 会员报表添加购物车记录 不要再删了
     * @since 20160908
     * @author xiewl
     * @param cartAddDto
     */
    @EventListener
    private void cartAddRecord(CartAddDto cartAddDto){
        CartAddCountDto cartAddCountDto = new CartAddCountDto();
        cartAddCountDto.setGoodsId(cartAddDto.getItemId());
        cartAddCountDto.setMallType(cartAddDto.getMallType());
        Date date = new Date();
        cartAddCountDto.setAddDate(date);
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        cartAddCountDto.setWeek(calendar.get(Calendar.WEEK_OF_YEAR));
        cartAddCountDao.update(cartAddCountDto);
    }
}
