package cn.com.cgbchina.web.controller;

import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfo;
import cn.com.cgbchina.rest.visit.service.point.PointService;
import cn.com.cgbchina.trade.dto.CartDto;
import cn.com.cgbchina.trade.dto.CartResultDto;
import cn.com.cgbchina.trade.model.CartItem;
import cn.com.cgbchina.trade.model.UserCart;
import cn.com.cgbchina.trade.service.CartService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.util.JSONPObject;
import com.google.common.base.Charsets;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.google.common.hash.HashFunction;
import com.google.common.hash.Hashing;
import com.spirit.common.model.Response;
import com.spirit.common.utils.CommonConstants;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

@Controller
@RequestMapping("/api/cart")
public class Carts {

    private final static Logger log = LoggerFactory.getLogger(Carts.class);

    private final static HashFunction md5 = Hashing.md5();

    private final static int ONE_YEAR = (int) TimeUnit.DAYS.toSeconds(365);

    private final CartService cartService;

    private final CommonConstants commonConstants;

    private final MessageSources messageSources;

    public static final JsonMapper JSON_MAPPER = JsonMapper.nonEmptyMapper();

    @Autowired
    private PointService pointService;

    @Autowired
    public Carts(CartService cartService, CommonConstants commonConstants, MessageSources messageSources) {
        this.cartService = cartService;
        this.commonConstants = commonConstants;
        this.messageSources = messageSources;
    }

    @RequestMapping(value = "/batchDelete", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String batchDelete(@RequestParam("skuIds") String skuIds) {
        User user = UserUtil.getUser();

        List<String> parts = Splitter.on(',').omitEmptyStrings().trimResults().splitToList(skuIds);
        List<String> ids = Lists.newArrayListWithCapacity(parts.size());
        for (String key : parts) {
            ids.add(key);
        }
        if (ids.isEmpty()) {
            return "ok";
        }
        Response<Boolean> result = cartService.batchDeletePermanent(user.getId(), ids);
        if (!result.isSuccess()) {
            log.error("failed to batch delete cart for user {},skuIds:{},error code :{}", user, skuIds,
                    result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
        return "ok";
    }

    @RequestMapping(method = RequestMethod.POST, produces = "application/javascript")
    @ResponseBody
    public Integer changeCart(@RequestParam("skuId") String skuId,
                              @RequestParam(value = "quantity", defaultValue = "1") int quantity,
                              @RequestParam("payType") String payType, @RequestParam("instalments") String instalments,
                              @RequestParam("price") String price, HttpServletResponse response) {
        User user = UserUtil.getUser();
        Response<Integer> result = new Response<Integer>();
        if (user == null) {
            log.error("user is not load");
            result.setError("cart.find.fail");
            return result.getResult();
        }
        if (user != null) { // 用户已登录
            result = cartService.changePermanentCart(user.getId(), skuId, payType, instalments, price, quantity);
            if (!result.isSuccess()) {
                log.error("change permanent cart failed, skuId={},cause:{}", skuId, result.getError());
                throw new ResponseException(500, messageSources.get(result.getError()));
            }

        } else { // 未登录
            log.error("change permanent cart failed, skuId={},cause:{}", skuId, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
        return result.getResult();
    }

    /**
     * 获取用户当前购物车中的信息
     *
     * @return
     */
    @RequestMapping(value = "/queryCarts", method = RequestMethod.GET)
    @ResponseBody
    public CartResultDto queryCarts() {
        User user = UserUtil.getUser();
        if (user == null) {
            log.warn("query cart need user login!");
            throw new ResponseException(401, "user.not.login");
        }
        Response<CartResultDto> response = cartService.getPermanent(user);
        if (!response.isSuccess()) {
            log.error("failed to query cart for user {},error code :{}", user, response.getError());
            throw new ResponseException(500, messageSources.get(response.getError()));
        }

        return response.getResult();
    }

    /**
     * 获取用户当前购物车中指定单品的信息
     *
     * @return
     */
    @RequestMapping(value = "/queryCartsByKey", method = RequestMethod.GET)
    @ResponseBody
    public CartDto queryCartsByKey(@RequestParam("rediskey") String rediskey) {
        User user = UserUtil.getUser();
        CartDto cartDto = new CartDto();
        if (user == null) {
            log.warn("query cart need user login!");
            throw new ResponseException(401, "user.not.login");
        }
        Response<Map<String, String>> response = cartService.getMapPermanent(user);

        if (!response.isSuccess()) {
            log.error("failed to query cart for user {},error code :{}", user, response.getError());
            throw new ResponseException(500, messageSources.get(response.getError()));
        }
        if (response.getResult() != null) {
            Map<String, String> map = response.getResult();
            map.get(rediskey);
            cartDto = JSON_MAPPER.fromJson(map.get(rediskey), CartDto.class);
        }
        return cartDto;
    }

    /**
     * 获取用户当前购物车中指定单品的信息
     *
     * @return
     */
    @RequestMapping(value = "/userScore", method = RequestMethod.GET)
    @ResponseBody
    public String getUserScore() {
        String amount = "";

        amount = "9";
        /**
         * 调用bms011接口
         * ToDo
         */
        /*
		User user = UserUtil.getUser();

		QueryPointsInfo queryPointsInfo = new QueryPointsInfo();

		queryPointsInfo.setChannelID("");
		queryPointsInfo.setCurrentPage("1");
		queryPointsInfo.setCardNo("");

		if(pointService.queryPoint(queryPointsInfo).getSuccessCode() == "00"){
			amount = pointService.queryPoint(queryPointsInfo).getAmount();
		}
		*/
        return amount;
    }


    /**
     * 查询购物车数量
     *
     * @param callback
     * @param cartCookie
     * @return
     * @throws JsonProcessingException
     */
    @RequestMapping(value = "/count", method = RequestMethod.GET)
    @ResponseBody
    public JSONPObject count(@RequestParam("callback") String callback, @CookieValue(value = "cart", required = false) String cartCookie) throws JsonProcessingException {
        User user = UserUtil.getUser();
        Integer cartCount = 0;
        if (user == null) {
            cartCount = 0;
        } else {
            Response<Integer> result = cartService.getPermanentCount(user);
            if (!result.isSuccess()) {
                log.error("get permanent count failed, cause:{}", result.getError());
                throw new ResponseException(500, messageSources.get(result.getError()));
            }
            cartCount = result.getResult();
        }
        return new JSONPObject(callback, cartCount);
    }

}
