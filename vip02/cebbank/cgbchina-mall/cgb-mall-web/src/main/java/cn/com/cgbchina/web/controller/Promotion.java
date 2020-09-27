package cn.com.cgbchina.web.controller;

import cn.com.cgbchina.promotion.dto.GoodsGroupBuyDto;
import cn.com.cgbchina.promotion.dto.MallPromotionResultDto;
import cn.com.cgbchina.promotion.service.MallPromotionService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Controller
@RequestMapping("/api/mall/promotion")
public class Promotion {

    private final static Logger log = LoggerFactory.getLogger(Promotion.class);

    @Autowired
    private MessageSources messageSources;

    @Autowired
    private MallPromotionService mallPromotionService;


    /**
     * 根据类目id查询活动商品列表
     *
     * @return geshuo 20160705
     */
    @RequestMapping(value = "/queryGroupGoods", method = RequestMethod.GET)
    @ResponseBody
    public List<GoodsGroupBuyDto> queryGroupGoods(HttpServletRequest request) {
        String promotionId = request.getParameter("promotionId");
        String categoryId = request.getParameter("categoryId");
        String[] promotionIds = promotionId.split(",");

        List<Integer> idList = new ArrayList<>();
        for(String id: promotionIds){
            idList.add(Integer.parseInt(id));
        }

        //根据类目查询活动商品
        Response<List<GoodsGroupBuyDto>> response = mallPromotionService.findGroupBuyGoodsByCategory(idList, Long.parseLong(categoryId));
        if (response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to query group goods {},error code:{}", categoryId, response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 根据活动ID 获取活动基本信息和活动选品集合（List）
     *
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/findPromotionByPromId", method = RequestMethod.GET)
    @ResponseBody
    public MallPromotionResultDto findPromotionByPromId(String promId) {

        //根据类目查询活动商品
        Response<MallPromotionResultDto> response = mallPromotionService.findPromotionByPromId(promId);
        if (response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to query group goods {},error code:{}", promId, response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 取得正在进行或即将开始的活动
     *
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/findPromInfoForOnline", method = RequestMethod.GET)
    @ResponseBody
    public MallPromotionResultDto findPromInfoForOnline() {

        // 取得正在进行或即将开始的活动
        Response<MallPromotionResultDto> response = mallPromotionService.findPromInfoForOnline();
        if (response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to query group goods {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 根据活动类型获取活动基本信息列表（距离现时点最近的活动包含选品列表）
     *
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/findPromListByPromType", method = RequestMethod.GET)
    @ResponseBody
    public List<MallPromotionResultDto> findPromListByPromType() {

        // 取得正在进行或即将开始的活动
        Response<List<MallPromotionResultDto>> response = mallPromotionService.findPromListByPromType();
        if (response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to query group goods {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 根据单品CODE List 获取现时点参加的活动
     *
     * @param type 0:包含即将开始活动 1：只需要进行中活动
     * @param itemCodes 单品CODE 逗号分隔拼接
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/findPromByItemCodes", method = RequestMethod.GET)
    @ResponseBody
    public MallPromotionResultDto findPromByItemCodes(String type, String itemCodes) {

        // 取得正在进行或即将开始的活动
        Response<MallPromotionResultDto> response = mallPromotionService.findPromByItemCodes(type, itemCodes);
        if (response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to query group goods {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 根据活动ID、选品ID、用户ID 记录销售数量（同时判断是否达到限购标准）
     *
     * @param promId 活动ID
     * @param itemCode 单品CODE
     * @param buyCount 购买数量
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/changePromSaleInfo", method = RequestMethod.GET)
    @ResponseBody
    public Boolean changePromSaleInfo(String promId, String itemCode,String buyCount) {
        User user = UserUtil.getUser();
        // 根据活动ID、选品ID、用户ID 记录销售数量（同时判断是否达到限购标准）
        /*Response<Boolean> response = mallPromotionService.changePromSaleInfo(promId, itemCode,user);
        if (response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to query group goods {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));*/
        // TODO
        return true;
    }

    /**
     * 根据活动ID 获取活动参加情报
     *
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/findPromSaleInfoByPromId", method = RequestMethod.GET)
    @ResponseBody
    public MallPromotionResultDto findPromSaleInfoByPromId(String promId, String itemCode) {
        User user = UserUtil.getUser();
        // 根据活动ID 获取活动参加情报
        Response<MallPromotionResultDto> response = mallPromotionService.findPromSaleInfoByPromId(promId, itemCode,user);
        if (response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to query group goods {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 根据活动ID检验活动是否有效
     *
     * @param promId 活动ID
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/checkPromtion", method = RequestMethod.GET)
    @ResponseBody
    public Boolean checkPromtion(String promId) {
        User user = UserUtil.getUser();

        // TODO 待编辑

        // 测试用
        return true;
        /*log.error("failed to query group goods {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));*/
    }

    /**
     * 根据活动ID、购买数量检验用户是否达到限购
     *
     * @param promId 活动ID
     * @param buyCount 购买数量
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/checkPromBuyCount", method = RequestMethod.GET)
    @ResponseBody
    public Boolean checkPromBuyCount(String promId, String buyCount) {
        User user = UserUtil.getUser();
        // TODO 待编辑

        // 测试用
        return true;
        /*log.error("failed to query group goods {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));*/
    }

    /**
     * 根据活动ID、单品CODE、购买数量 检验是否超过库存
     *
     * @param promId 活动ID
     * @param itemCode 单品CODE
     * @param buyCount 购买数量
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/checkPromItemStock", method = RequestMethod.GET)
    @ResponseBody
    public Boolean checkPromItemStock(String promId, String itemCode, String buyCount) {
        User user = UserUtil.getUser();
        // TODO 待编辑

        // 测试用
        return true;
        /*log.error("failed to query group goods {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));*/
    }
}
