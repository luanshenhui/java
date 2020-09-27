package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.PointPoolModel;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.PointsPoolService;
import cn.com.cgbchina.rest.visit.model.point.QueryPointResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfo;
import cn.com.cgbchina.rest.visit.service.point.PointService;
import cn.com.cgbchina.rest.visit.vo.point.QueryPointsInfoResultVO;
import cn.com.cgbchina.trade.dao.CartDao;
import cn.com.cgbchina.trade.dto.CartDto;
import cn.com.cgbchina.trade.dto.CartItemsAttributeDto;
import cn.com.cgbchina.trade.dto.CartItemsAttributeSkuDto;
import cn.com.cgbchina.trade.dto.CartResultDto;
import cn.com.cgbchina.trade.model.CartItem;
import cn.com.cgbchina.user.service.UserFavoriteService;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.user.UserAccount;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Service
@Slf4j
public class CartServiceImpl implements CartService {

    public static final JsonMapper JSON_MAPPER = JsonMapper.nonEmptyMapper();
    @Resource
    private UserFavoriteService userFavoriteService;
    @Resource
    private GoodsService goodsService;
    @Resource
    private ItemService itemService;
    @Resource
    private CartDao cartDao;
    @Resource
    private PointService pointService;
    @Resource
    private PointsPoolService pointsPoolService;

    /**
     * 获取永久购物车中的物品
     *
     * @param user 系统自动注入的用户
     * @return 永久购物车中的物品
     */
    @Override
    public Response<CartResultDto> getPermanent(User user) {
        Response<CartResultDto> result = new Response<CartResultDto>();
        String userId = user.getId();
        try {
            CartResultDto userCarts = null;
            Map<String, String> skuIds = cartDao.getPermanent(userId);
            //  判断购物车是否为空
            if (skuIds.size() > 0) {
                //  获取用户购物车信息
                userCarts = buildUserCart(skuIds, user);
            }
            // 查询购物车内商品对应的店铺是否有店铺优惠券
            result.setResult(userCarts);
            log.info("return success",result.getResult());
            return result;
        } catch (Exception e) {
            log.error("failed to get permanent shop carts for user(id={}),cause:{}", userId,
                    Throwables.getStackTraceAsString(e));
            result.setError("cart.find.fail");
            return result;
        }
    }

    /**
     * 获取永久购物车中的物品(redis中未编辑Map直接返回)
     *
     * @param user 系统自动注入的用户
     * @return 永久购物车中的物品(redis中未编辑Map直接返回)
     */
    @Override
    public Response<Map<String, String>> getMapPermanent(User user) {
        Response<Map<String, String>> result = new Response<Map<String, String>>();
        String userId = user.getId();
        try {
            CartResultDto userCarts = null;
            Map<String, String> skuIds = cartDao.getPermanent(userId);
            result.setResult(skuIds);
            log.info("return sccess",result.getResult());
            return result;
        } catch (Exception e) {
            log.error("failed to get permanent shop carts for user(id={}),cause:{}", userId,
                    Throwables.getStackTraceAsString(e));
            result.setError("cart.find.fail");
            return result;
        }
    }

    /**
     * 获取永久购物车中的sku的种类个数
     *
     * @return sku的种类个数
     */
    @Override
    public Response<Integer> getPermanentCount(User user) {
        Response<Integer> result = new Response<Integer>();
        try {
            Map<String, String> skuIds = cartDao.getPermanent(user.getId());
            if (skuIds != null) {
                result.setResult(skuIds.size());
            } else {
                result.setResult(0);
            }
            result.setSuccess(true);
            log.info("return sccess",result.getResult());
            return result;
        } catch (Exception e) {
            log.error("failed to get count of sku in permanent cart by user{},cause:{}", user,
                    Throwables.getStackTraceAsString(e));
            result.setError("cart.count.fail");
            result.setSuccess(false);
            return result;
        }
    }

    /**
     * 为skuId进行归组分类（弃用）
     *
     * @param skuIds skuIds
     * @return 购物车
     */
    private CartResultDto buildUserCart(Map<String, String> skuIds, User user) {
        //  获取购物车内的商品信息
        CartResultDto cartItems = buildCartItems(skuIds, user);
        log.info("return sccess",cartItems);
        return cartItems;
    }

    /**
     * 增减永久购物车中的物品
     *
     * @param userId   userId
     * @param itemId   单品CODE
     * @param quantity 变化数量
     */
    public Response<Integer> changePermanentCart(String userId, String itemId, String payType, String instalments,
                                                 String price, int quantity) {
        Response<Integer> result = new Response<Integer>();
        if (itemId == null) {
            log.error("temporary shop cart args can not be null");
            result.setError("cart.find.fail");
            return result;
        }
        try {
            CartDto cartDto = new CartDto();
            // redis 存储 hash 的 key 值
            String mapKey = itemId + ":" + payType;
            Map<String, String> redisMap = cartDao.getPermanent(userId);
            Map<String, String> paramMap = Maps.newHashMap();
            if (redisMap != null && redisMap.size() > 0 && redisMap.containsKey(mapKey)) {
                // 已存在数据（修改单品购买数量）
                cartDto = JSON_MAPPER.fromJson(redisMap.get(mapKey), CartDto.class);
                if (cartDto.getItemCount() != null) {
                    // 数量累加
                    cartDto.setItemCount(quantity + cartDto.getItemCount());
                }
            } else {
                // 新加入购物车
                cartDto.setItemCode(itemId);
                cartDto.setPayType(payType);
                if (quantity <= 0) {
                    quantity = 1;
                }
                cartDto.setItemCount(quantity);
            }
            // 期数
            if (instalments != null && !"".equals(instalments)) {
                cartDto.setInstalments(instalments);
            }
            // 单价
            if (price != null && !"".equals(price)) {
                cartDto.setPrice(new BigDecimal(price));
            }

            // 暂闭start
            //获取当月积分池比例
//			Long lastSinglePoint = getLastSinglePoint();

//			//最高可抵扣积分
//			Long fixPoint = itemService.findById(itemId).getFixPoint();
//			if (fixPoint != null && !"".equals(fixPoint)){
//				cartDto.setFixPoint(fixPoint);
//			}
            // 暂闭end

            String josnString = JSON_MAPPER.toJson(cartDto);
            paramMap.put(mapKey, josnString);

            cartDao.changePermanentCart(userId, mapKey, paramMap);
            Map<String, String> skuIds = cartDao.getPermanent(userId);
            int count = 0;
            if (skuIds != null) {
                count = skuIds.size();
            }
            // 购物车中单品个数
            result.setResult(count);
            result.setSuccess(true);
            log.info("return sccess",result.getResult());
            return result;
        } catch (Exception e) {
            log.error("failed to add skuId(id={}) to permanent shop cart(id={}),cause:{}", userId, itemId,
                    Throwables.getStackTraceAsString(e));
            result.setError("cart.change.fail");
            return result;
        }
    }

    /**
     * 批量删除用户购物车中的skuIds
     *
     * @param userId 用户id
     * @param skuIds 待删除的skuId列表
     */
    @Override
    public Response<Boolean> batchDeletePermanent(String userId, Iterable<String> skuIds) {
        Response<Boolean> result = new Response<Boolean>();
        if (userId == null || skuIds == null) {
            log.error("userId and skuIds both can not be null");
            result.setError("cart.batch.delete.fail");
            log.info("return sccess",result.getError());
            return result;
        }
        try {
            List<String> itemCode = new ArrayList<String>();
            for (String skuId : skuIds) {
                itemCode.add(skuId);
            }
            cartDao.deleteByItemCode(userId, itemCode);
            result.setResult(Boolean.TRUE);
            log.info("return sccess",result.getResult());
            return result;
        } catch (Exception e) {
            log.error("failed to batch delete skuIds{} of user(id={}),cause:{}", skuIds, userId,
                    Throwables.getStackTraceAsString(e));
            result.setError("cart.batch.delete.fail");
            log.info("return error",result.getError());
            return result;
        }
    }

    /**
     * 清空用户的购物车
     *
     * @param key cookie中的key，或者用户id
     */
    @Override
    public Response<Boolean> empty(String key) {
        Response<Boolean> result = new Response<Boolean>();
        try {
            cartDao.delete(key);
            result.setResult(Boolean.TRUE);
            log.info("return sccess",result.getResult());
            return result;
        } catch (Exception e) {
            log.error("`empty` invoke fail. can't empty cart by key or uid: {}, e:{}", key, e);
            result.setError("cart.empty.fail");
            return result;
        }
    }

    /**
     * 获取购物车内单品code 并检索商品信息
     * @param skuIds
     * @param user
     * @return
     */
    private CartResultDto buildCartItems(Map<String, String> skuIds, User user) {
        CartResultDto result = new CartResultDto();
        try {
            //  循环购物车内信息
            for (Map.Entry<String, String> entry : skuIds.entrySet()) {
                CartDto cartDto = JSON_MAPPER.fromJson(entry.getValue(), CartDto.class);
                // 查询单品信息
                Response<ItemModel> itemResult = itemService.findByItemcode(cartDto.getItemCode());
                //  访问服务返回成功
                if (!itemResult.isSuccess()) {
                    log.error("item(itecode={}) is not found,skip", cartDto.getItemCode());
                    continue;
                }
                ItemModel itemModel = itemResult.getResult();
                // 查询商品信息
                Response<GoodsModel> goodsListResult = goodsService.findById(itemModel.getGoodsCode());
                //  访问服务返回成功
                if (!goodsListResult.isSuccess()) {
                    log.error("item(id={}) is not found,skip", cartDto.getItemCode());
                    continue;
                }
                GoodsModel goodsModel = goodsListResult.getResult();
                CartItem cartItem = new CartItem();
                //	获取用户各种和积分
                String commonAmount = "";    //用户普通积分
                String hopeAmount = "";    //用户希望积分
                String truthAmount = "";//用户真情积分
                String pointsTypeFormat = "";//商品积分类型转换
                Long fixPoint = Long.valueOf(0);//商品可用积分
                // 商品状态（广发商城状态00处理中 01在库 02上架）
                cartItem.setStatus(goodsModel.getChannelMall());
                // 商品名称
                cartItem.setItemName(goodsModel.getName());
                // 供应商id
                cartItem.setShopId(goodsModel.getVendorId());
                // 分区(礼品用)
                cartItem.setRegion(goodsModel.getRegionType());
                // 商品编号
                cartItem.setGoodsCode(goodsModel.getCode());
                //商品类型（00实物01虚拟02O2O）
                cartItem.setGoodsType(goodsModel.getGoodsType());
                //	获取用户积分
                Map<String, Object> allScore = getUserScore(user);
                commonAmount = allScore.get("commonAmount").toString();    //用户普通积分
                hopeAmount = allScore.get("hopeAmount").toString();    //用户希望积分
                truthAmount = allScore.get("truthAmount").toString();//用户真情积分
                //  判断返回数据不为空
                if (allScore != null) {
                    result.setCommonAmount(commonAmount);
                    result.setHopeAmount(hopeAmount);
                    result.setTruthAmount(truthAmount);
                }
                //获取积分类型 默认普通类型
                if (goodsModel.getPointsType() != null) {
                    pointsTypeFormat = formatItemJgId(goodsModel.getPointsType());
                    cartItem.setPointsType(pointsTypeFormat);
                }
                // 单品ID
                cartItem.setItemId(itemModel.getCode());
                // 购买数量
                cartItem.setCount(cartDto.getItemCount());
                // 分期数
                cartItem.setInstalments(cartDto.getInstalments());
                // 支付方式
                cartItem.setPayType(cartDto.getPayType());
                // 单品图片
                cartItem.setItemImage(itemModel.getImage1());
                // 单品价格
                cartItem.setPrice(itemModel.getPrice());
                // 库存
                cartItem.setStock(itemModel.getStock());
                //图片展示
                cartItem.setImgShow(itemModel.getImage1());
                //	商品可用积分
                if (itemModel.getFixPoint() != null) {
                    cartItem.setFixPoint(fixPoint);
                }
                /**
                 * Todo
                 * 调用活动组提供信息
                 * 反馈活动信息
                 */
                CartItemsAttributeDto itemsAttributeDto = JSON_MAPPER.fromJson(itemModel.getAttribute(),
                        CartItemsAttributeDto.class);
                List<CartItemsAttributeSkuDto> skus = itemsAttributeDto.getSkus();
                cartItem.setAttribute(skus);
                // 收藏状态
                Response<String> response = userFavoriteService.checkFavorite(itemModel.getCode(), user.getId());
                //  访问服务返回成功
                if (response.isSuccess()) {
                    cartItem.setFavoriteStatus(response.getResult());
                }
                // 单品总价
                if (itemModel.getPrice() != null) {
                    BigDecimal count = new BigDecimal(cartDto.getItemCount());
                    cartItem.setTotalPrice(itemModel.getPrice().multiply(count));
                }
                // 支付方式（1：立即支付 2：1期信用卡支付）
                if (Contants.CART_PAY_TYPE_1.equals(cartDto.getPayType())) { // 立即支付
                    result.getImmediatePaymentList().add(cartItem);
                } else if (Contants.CART_PAY_TYPE_2.equals(cartDto.getPayType())) { // 1期信用卡支付
                    //最高可抵扣积分

                    // 页面初始化显示可用最高抵值数
                    String userScore = "0";
                    //  用户普通积分
                    if ("001".equals(pointsTypeFormat)) {
                        userScore = commonAmount;
                    }
                    //  用户希望积分
                    else if ("002".equals(pointsTypeFormat)) {
                        userScore = hopeAmount;
                    }
                    //  用户真情积分
                    else if ("003".equals(pointsTypeFormat)) {
                        userScore = truthAmount;
                    }
                    //　商品最高可用积分与用户积分比较 两者取较小值
                    if (Long.parseLong(userScore) > fixPoint) {
                        cartItem.setAvailablePoint(fixPoint.toString());
                    } else {
                        cartItem.setAvailablePoint(userScore);
                    }
                    result.getInstallmentsList().add(cartItem);
                }
            }
            //积分池剩余积分
            Response<PointPoolModel> pointPoolModel = pointsPoolService.getLastInfo();
            //  访问服务返回成功
            if (pointPoolModel.isSuccess()) {
                Long maxPoint = pointPoolModel.getResult().getMaxPoint();
                Long usedPoint = pointPoolModel.getResult().getUsedPoint();
                Long surplusPoint = maxPoint - usedPoint;
                result.setSurplusPoint(surplusPoint);
            }
            log.info("return success",result.getSurplusPoint());
            return result;
        } catch (Exception e) {
            log.error("failed query cart data,cause:{}", Throwables.getStackTraceAsString(e));
            return result;
        }
    }

    /**
     * 调用bms011接口
     * 获取用户记录第一张信用卡卡号
     * 根据卡号获取用户下的所有积分
     *
     * @return
     */
    private Map getUserScore(User user) {
        String cardNo = "";
        Map amountMap = new HashMap();
        List<UserAccount> userCartDtoList = user.getAccountList();
        //  循环客户信息中的卡信息取出取出一张信用卡卡号
        for (UserAccount userAccount : userCartDtoList) {
            int cardType = userAccount.getCardType().toNumber();
            //  判断为信用卡
            if (30 == cardType) {
                cardNo = userAccount.getCardNo();
                break;
            }
        }
        amountMap = getAmount(cardNo);
        log.info("return success",amountMap);
        return amountMap;
    }

    /**
     * 根据用户卡号获取积分
     * 同样类型积分合并，通过单品积分过滤
     *
     * @param cardNo
     * @return
     */
    private Map<String, Object> getAmount(String cardNo) {
        Map amountMap = Maps.newHashMap();
        BigDecimal commonAmount = BigDecimal.valueOf(0);
        BigDecimal hopeAmount = BigDecimal.valueOf(0);
        BigDecimal truthAmount = BigDecimal.valueOf(0);

        QueryPointsInfo queryPointsInfo = new QueryPointsInfo();
        queryPointsInfo.setChannelID("MALL");
        queryPointsInfo.setCurrentPage("1");
        queryPointsInfo.setCardNo(cardNo);
        SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");//设置日期格式
        queryPointsInfo.setStartDate(df.format(new Date()));
        queryPointsInfo.setEndDate(df.format(new Date()));
        /*
         * ToDo
		 * 现数据库中 item表中没有记录积分类型的字段
		 * */
        QueryPointResult queryPointResult = pointService.queryPoint(queryPointsInfo);
        // 服务返回不为空
        if (queryPointResult != null) {
            List<QueryPointsInfoResultVO> queryPointsInfoResultVOList = queryPointResult.getQueryPointsInfoResults();
            String successCode = queryPointResult.getSuccessCode();
            // 服务返回
            if ("00".equals(successCode)) {
                for (QueryPointsInfoResultVO queryPointsInfoResultVO : queryPointsInfoResultVOList) {
                    //  用户普通积分累加
                    if ("001".equals(queryPointsInfoResultVO.getJgId())) {
                        commonAmount = commonAmount.add(queryPointsInfoResultVO.getAmount());
                    }
                    //  用户希望积分累加
                    if ("002".equals(queryPointsInfoResultVO.getJgId())) {
                        hopeAmount = hopeAmount.add(queryPointsInfoResultVO.getAmount());
                    }
                    //  用户真情积分累加
                    if ("003".equals(queryPointsInfoResultVO.getJgId())) {
                        truthAmount = truthAmount.add(queryPointsInfoResultVO.getAmount());
                    }
                }
            }
        }
        amountMap.put("commonAmount", commonAmount);
        amountMap.put("hopeAmount", hopeAmount);
        amountMap.put("truthAmount", truthAmount);
        log.info("return success",amountMap);
        return amountMap;
    }

    /**
     * 积分类型转义
     * @param itemJgId
     * @return
     */
    private String formatItemJgId(String itemJgId) {
        String itemJgIdFormat = "";
        switch (itemJgId) {
            case Contants.JGID_HOPE:
                itemJgIdFormat = Contants.JGID_HOPE_FORMAT;
                break;
            case Contants.JGID_TRUTH:
                itemJgIdFormat = Contants.JGID_TRUTH_FORMAT;
                break;
            //	普通积分
            default:
                itemJgIdFormat = Contants.JGID_COMMON_FORMAT;
                break;
        }
        log.info("return success",itemJgIdFormat);
        return itemJgIdFormat;
    }

    // 暂时封闭Start
    /**
     * 获得当前积分比
     * @return
     */
//	private Long getLastSinglePoint() {
//		//获取当月积分池比例Start
//		PointPoolModel pointPoolModel = new PointPoolModel();
//		pointPoolModel = pointsPoolService.getLastInfo();
//		Long lastSinglePoint = pointPoolModel.getSinglePoint();
//		//获取当月积分池比例End
//		return lastSinglePoint;
//	}
    // 暂时封闭End
}
