package cn.com.cgbchina.web.controller;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;

import cn.com.cgbchina.item.dto.GoodsGroupBuyDto;
import cn.com.cgbchina.item.dto.UserHollandaucLimit;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.utils.DistributedLocks;
import org.joda.time.LocalDateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.BeanMapper;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.dto.AuctionRecordDto;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.dto.MallPromotionSaleInfoDto;
import cn.com.cgbchina.item.dto.PromAuctionRecordResultDto;
import cn.com.cgbchina.item.dto.PromotionItemResultDto;
import cn.com.cgbchina.item.model.PromotionPayWayModel;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.item.service.PromotionPayWayService;
import cn.com.cgbchina.related.model.AuctionQuestionInfModel;
import cn.com.cgbchina.related.service.AuctionQuestionInfService;
import cn.com.cgbchina.trade.model.AuctionRecordModel;
import cn.com.cgbchina.trade.service.AuctionRecordService;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/api/mall/promotion")
@Slf4j
public class Promotion {

    @Autowired
    private MessageSources messageSources;

    @Autowired
    private MallPromotionService mallPromotionService;

    @Autowired
    private AuctionRecordService auctionRecordService;

    @Autowired
    private GoodsPayWayService goodsPayWayService;

    @Autowired
    private PromotionPayWayService promotionPayWayService;

    @Autowired
    private ItemService itemService;

    @Autowired
    private AuctionQuestionInfService auctionQuestionInfService;
    @Autowired
    private JedisTemplate jedisTemplate;


    private DateTimeFormatter dft = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");

    /**
     * 根据活动id和场次id获取活动商品列表
     *
     */
    @RequestMapping(value = "/queryGroupGoods", method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String,Object> queryGroupGoods(@RequestParam("promotionId") Integer promotionId,@RequestParam("periodId") Integer periodId) {
        //根据类目查询活动商品
        Response<Map<String,Object>> response = mallPromotionService.findGoodsByPromAndPeriod(promotionId,periodId);
        if(response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to query group goods {},error code:{}", promotionId, response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }
    /**
     * 根据分类id和活动商品列表
     *
     */
    @RequestMapping(value = "/queryGroupGoodsByClassify", method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<GoodsGroupBuyDto> queryGroupGoodsByClassify(Integer promotionId,Long classifyId,Integer periodId) {
        //根据类目查询活动商品
        Response<List<GoodsGroupBuyDto>> response = mallPromotionService.findGroupGoodsByClassifyAndProm(promotionId, classifyId,periodId);
        if(response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to query group goods {},error code:{}", promotionId, response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }




    /**
     * 根据活动ID 获取活动基本信息和活动选品集合（List）
     *
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/findPromotionByPromIdAndPeriodId", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public MallPromotionResultDto findPromotionByPromId(String promId,String periodId) {

        //根据类目查询活动商品
        Response<MallPromotionResultDto> response = mallPromotionService.findPromotionByPromIdAndPeriodId(promId,periodId);
        if(response.isSuccess()) {
            MallPromotionResultDto mallPromotionResultDto = response.getResult();
            if (mallPromotionResultDto == null) {
                return response.getResult();
            }
            List<PromotionItemResultDto> itemList = mallPromotionResultDto.getPromItemResultList();
            for (PromotionItemResultDto promotionItemResultDto : itemList) {
                Response<PromotionPayWayModel> promPayway = promotionPayWayService.findMaxPromotionPayway(promotionItemResultDto.getSelectCode(),promId);
                if (promPayway.isSuccess()) {
                    if (promPayway.getResult() != null) {
                        // 最高期
                        promotionItemResultDto.setInstallmentNumber(String.valueOf(promPayway.getResult().getStagesCode()));
                        // 每期价格
                        promotionItemResultDto.setPrice(promPayway.getResult().getPerStage());
                    }
                }
            }
            return response.getResult();
        }
        log.error("failed to query group goods {},error code:{}", promId, response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 取得荷兰拍数据
     *
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/findHollandauc", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public MallPromotionResultDto findHollandauc() {

        // 取得荷兰拍数据
        Response<MallPromotionResultDto> response = mallPromotionService.findHollandauc();
        if(response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to query group goods {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 取得已拍完荷兰拍单品List
     *
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/findHollandaucForOver", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<PromotionItemResultDto> findHollandaucForOver(String promId, String periodId) {

        // 取得荷兰拍数据
        Response<List<PromotionItemResultDto>> response = mallPromotionService.findHollandaucForOver(promId, periodId);
        if(response.isSuccess()) {
            if(response.getResult() != null) {
                for (PromotionItemResultDto dto : response.getResult()) {
                    Response<List<AuctionRecordModel>> result = auctionRecordService.findByParam(promId, periodId, dto.getSelectCode());
                    if(result.isSuccess()) {
                        List<AuctionRecordModel> modelList = result.getResult();
                        List<AuctionRecordDto> auctionList = BeanMapper.mapList(modelList, AuctionRecordDto.class);
                        for (AuctionRecordDto auctionRecord : auctionList){
                            String strTemp = auctionRecord.getCustId();
                            if(strTemp.length() > 8){
                                String beginStr = strTemp.substring(0,3);
                                String endStr = strTemp.substring(strTemp.length() - 3,strTemp.length());
                                auctionRecord.setCustId(beginStr + "***" + endStr);
                            }
                        }
                        dto.setAuctionList(auctionList);
                    }
                }
            }
            return response.getResult();
        }
        log.error("failed to query findHollandaucForOver {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 取得拍卖纪录
     *
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/findAuctionRecord", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public PromAuctionRecordResultDto findAuctionRecord(String id) {

        // 取得拍卖纪录
        Response<AuctionRecordModel> response = auctionRecordService.findById(id);
        String nowTime = LocalDateTime.now().toString(dft);
        if(response.isSuccess()) {
            PromAuctionRecordResultDto resultDto = new PromAuctionRecordResultDto();
            BeanUtils.copyProperties(response.getResult(), resultDto);
            ItemModel itemModel = itemService.findById(resultDto.getItemId());

            // 图片
            resultDto.setImage1(itemModel.getImage1());
            Response<TblGoodsPaywayModel> responsePy = goodsPayWayService.findGoodsPayWayInfo(resultDto.getGoodsPaywayId());
            if(responsePy.isSuccess()) {
                TblGoodsPaywayModel pyModel = responsePy.getResult();
                Integer stagesCode = 1;
                if (pyModel != null) {
                    // 原价
                    resultDto.setOldPrice(pyModel.getGoodsPrice());
                    // 期数
                    stagesCode = pyModel.getStagesCode();
                    resultDto.setMaxNumber(pyModel.getStagesCode());
                }
                // 起拍价
                BigDecimal auctionPrice = resultDto.getAuctionPrice();
                resultDto.setNowDate(nowTime);
                // 起拍价
                if(stagesCode != null && auctionPrice != null) {
                    BigDecimal perStage = auctionPrice.divide(new BigDecimal(stagesCode), 2, BigDecimal.ROUND_UP);
                    resultDto.setPerStage(perStage);
                }
            }
            return resultDto;
        }
        log.error("failed to query findHollandaucForOver {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 立即拍卖
     * price字段用于跟后台计算出的结果进行比较 看看差异
     * @return wangqi 20160730
     */
    @RequestMapping(value = "/insertAuctionRecord", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Long insertAuctionRecord(String promId, String periodId, String itemCode, String goodsName,String price) {

        User user = UserUtil.getUser();
        if (user == null) {
            log.error("failed to check insertAuctionRecord {},error code:{}", "MallPromotionServiceImpl.user.null");
            throw new ResponseException(500, messageSources.get("MallPromotionServiceImpl.user.null"));
        }

        String lockName="prom-limit-lock:"+promId+":"+periodId+":"+itemCode+":"+user.getId();
        //获取分布式锁 防止攻击
        // 获取分布式锁
        String	lockId = DistributedLocks.acquireLockWithTimeout(jedisTemplate, lockName, 50, 10000);
        if (lockId == null) {
            log.info("check prom buy count repeat action,lockname={}"+lockName);
            throw new ResponseException(500,messageSources.get("lock.get.error"));
        }
        try {
        Date nowDate = LocalDateTime.now().toDate();
        // 取得拍卖纪录
        Response<Boolean> checkResponse = mallPromotionService.checkAuction(promId, periodId, itemCode, user);
        if(checkResponse.isSuccess()) {
            Response<TblGoodsPaywayModel> goodsPayway = goodsPayWayService.findMaxGoodsPayway(itemCode);
            if(goodsPayway.isSuccess()) {
                TblGoodsPaywayModel goodsPaywayModel = null;
                if (goodsPayway.getResult() != null) {
                    goodsPaywayModel = goodsPayway.getResult();
                }
                //得到荷兰拍计算出来的钱
                Response<PromotionItemResultDto> calculateResponse = mallPromotionService.findHollandaucByItemCode(promId, periodId, itemCode);
                if(calculateResponse.isSuccess()) {
                    PromotionItemResultDto promotionItemResultDto = calculateResponse.getResult();

                    BigDecimal pagePrice=new BigDecimal(price);//传输正确

                    //后台服务器计算出来的钱跟前台js计算出来的钱比较
                    BigDecimal maxPrice=promotionItemResultDto.getStartPrice();//起始价格 最大价格
                    BigDecimal minPrice=promotionItemResultDto.getMinPrice();//终止价格 最小价格

                    AuctionRecordModel model = new AuctionRecordModel();
                    model.setPeriodId(Integer.valueOf(periodId));// 场次ID
                    model.setAuctionId(Long.valueOf(promId));// 活动ID
                    //前台传过来的钱是否在这个区间范围内  如果在就用不在就用服务器计算出来的
                    if(isBetweenPrice(maxPrice,minPrice,pagePrice)){
                        model.setAuctionPrice(pagePrice);// 拍卖价格
                    }else {
                        //价格超出区间范围  有误 人为攻击直接抛异常
                        throw new ResponseException(500,messageSources.get("prom.auction.price.overflow.error"));
                    }
                    model.setAuctionTime(nowDate);// 拍卖时间
                    model.setModifyTime(LocalDateTime.now().toDate());
                    model.setCustId(user.getId());// 用户ID
                    model.setCell(user.getMobile());// 手机号
                    model.setItemId(itemCode);// 单品code
                    model.setGoodsNm(goodsName);// 商品名
                    model.setIsBacklock("1");// 是否锁定库存 0：否  1：是
                    model.setPayFlag("0");// 是否完成支付 0：否  1：是
                    if (goodsPaywayModel != null) {
                        model.setGoodsPaywayId(goodsPaywayModel.getGoodsPaywayId()); // 支付方式
                    }
                    Response<Long> response = auctionRecordService.insertOrUpdate(model,user);
                    if(response.isSuccess()) {
                        // 拍卖纪录表主键ID
                        return response.getResult();
                    }
                    log.error("failed to insertOrUpdate insertAuctionRecord {},error code:{}", response.getError());
                    throw new ResponseException(500, messageSources.get(response.getError()));
                }
                log.error("failed to calculate insertAuctionRecord {},error code:{}", calculateResponse.getError());
                throw new ResponseException(500, messageSources.get(calculateResponse.getError()));
            }
            log.error("failed to goodsPayway insertAuctionRecord {},error code:{}", goodsPayway.getError());
            throw new ResponseException(500, messageSources.get(goodsPayway.getError()));


        }
        log.error("failed to check insertAuctionRecord {},error code:{}", checkResponse.getError());
        throw new ResponseException(500, messageSources.get(checkResponse.getError()));
        }catch (ResponseException e){
            throw e;
        }finally {
            DistributedLocks.releaseLock(jedisTemplate,lockName, lockId);
        }
    }
    //判断某一个价格是否在两个价格之间 包含左右区间
    private boolean isBetweenPrice(BigDecimal max,BigDecimal min,BigDecimal check){
        return (max.compareTo(check)==1||max.compareTo(check)==0)&&(min.compareTo(check)==-1||min.compareTo(check)==0);
    }

    /**
     * 取得秒杀活动列表（距离现时点最近的活动包含选品列表）
     *
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/findPromListByPromType", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<MallPromotionResultDto> findPromListByPromType(String promType) {
        // 根据活动类型取得活动列表
        Response<List<MallPromotionResultDto>> response = mallPromotionService.findPromListByPromType(promType);
        if(response.isSuccess()) {
            List<MallPromotionResultDto> resultList = response.getResult();
            for (MallPromotionResultDto mallPromotionResultDto : resultList) {
                List<PromotionItemResultDto> itemList = mallPromotionResultDto.getPromItemResultList();
                if (itemList == null) {
                    continue;
                }
                for (PromotionItemResultDto promotionItemResultDto : itemList) {
                    Response<PromotionPayWayModel> promPayway = promotionPayWayService.findMaxPromotionPayway(promotionItemResultDto.getSelectCode(), String.valueOf(promotionItemResultDto.getPromotionId()));
                    if (promPayway.isSuccess()) {
                        if (promPayway.getResult() != null) {
                            // 最高期
                            promotionItemResultDto.setInstallmentNumber(String.valueOf(promPayway.getResult().getStagesCode()));
                            // 每期价格
                            promotionItemResultDto.setPrice(promPayway.getResult().getPerStage());
                        }
                    }
                }
            }
            return response.getResult();
        }
        log.error("failed to query group goods {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 根据单品CODE List 获取现时点参加的活动
     *
     * @param type     0:包含即将开始活动 1：只需要进行中活动
     * @param itemCode 单品CODE
     * @return MallPromotionForItemResultDto List
     */
    @RequestMapping(value = "/findPromByItemCodes", method = RequestMethod.GET)
    @ResponseBody
    public MallPromotionResultDto findPromByItemCodes(String type, String itemCode) {

        // 取得正在进行或即将开始的活动
        Response<MallPromotionResultDto> response = mallPromotionService.findPromByItemCodes(type, itemCode, Contants.PROMOTION_SOURCE_ID_00);
        if(response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to query group goods {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 根据活动ID、选品ID、用户ID 记录销售数量（同时判断是否达到限购标准）
     *
     * @param promId   活动ID
     * @param periodId 场次ID
     * @param itemCode 单品CODE
     * @param buyCount 购买数量
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/changePromSaleInfo", method = RequestMethod.GET)
    @ResponseBody
    public Boolean changePromSaleInfo(String promId, String periodId, String itemCode, String buyCount) {
        User user = UserUtil.getUser();
        // 取得正在进行或即将开始的活动
        Response<Boolean> response = mallPromotionService.updatePromSaleInfo(promId, periodId, itemCode, buyCount, user);
        if(response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to query group goods {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 根据活动ID 获取活动销售信息
     *
     * @param promId   活动ID
     * @param periodId 场次ID
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/findPromSaleInfoByPromId", method = RequestMethod.GET)
    @ResponseBody
    public MallPromotionSaleInfoDto findPromSaleInfoByPromId(String promId, String periodId, String itemCode) {
        // 根据活动ID 获取活动参加情报
        Response<MallPromotionSaleInfoDto> response = mallPromotionService.findPromSaleInfoByPromId(promId, periodId, itemCode);
        if(response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to query group goods {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 根据活动ID检验活动是否有效
     *
     * @param promId   活动ID
     * @param periodId 场次ID
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/checkPromtion", method = RequestMethod.GET)
    @ResponseBody
    public Boolean checkPromtion(String promId, String periodId) {

        // 根据活动ID 获取活动参加情报
        Response<Boolean> response = mallPromotionService.findPromValidByPromId(promId, periodId);
        if(response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to query group goods {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 根据活动ID、购买数量检验用户是否达到限购
     *
     * @param promId   活动ID
     * @param periodId 场次ID
     * @param buyCount 购买数量
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/checkPromBuyCount", method = RequestMethod.GET)
    @ResponseBody
    public Boolean checkPromBuyCount(String promId, String periodId, String buyCount,String itemCode) {
        User user = UserUtil.getUser();
        // 根据活动ID 获取活动参加情报
        Response<Boolean> response = mallPromotionService.checkPromBuyCount(promId, periodId, buyCount, user,itemCode);
        if(response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to query group goods {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 根据活动ID、场次ID 记录拍卖次数。如果已没有拍卖机会，则直接返回0
     *
     * @param promId   活动ID
     * @param periodId 场次ID
     * @return wangqi 20160713
     */
    @RequestMapping(value = "/insertPromForHollandauc", method = RequestMethod.GET)
    @ResponseBody
    public Long insertPromForHollandauc(String promId, String periodId) {
        User user = UserUtil.getUser();
        // 根据活动ID 获取活动参加情报
        Response<Long> response = mallPromotionService.insertPromForHollandauc(promId, periodId, user);
        if(response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to query group goods {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }


    /**
     * 获取荷兰拍拍卖规则
     *
     * @return zhangc 20160812
     */
    @RequestMapping(value = "/findHollandaucQuestion", method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<AuctionQuestionInfModel> findHollandaucQuestion() {
        Response<Pager<AuctionQuestionInfModel>> response = auctionQuestionInfService.findAll(1,10,null,null);
        if(response.isSuccess()) {
            if(response.getResult() != null) {
                return response.getResult().getData();
            }
            log.error("failed to get auction rule {},error code:{}", response.getError());
            return Collections.emptyList();
        }
        log.error("failed to get auction rule {},error code:{}", response.getError());
        return Collections.emptyList();
    }
    @RequestMapping(value = "/getUserHollandaucLimit", method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public UserHollandaucLimit getUserHollandaucLimit(String promId, String periodId){
        User user = UserUtil.getUser();
        //没登录不显示
        if(user ==null){
            return null;
        }
        //无活动不显示
        Response<UserHollandaucLimit> userHollandaucLimitResponse = mallPromotionService.getUserHollandaucLimit(promId, periodId, user);
        if(userHollandaucLimitResponse.isSuccess()){
            return userHollandaucLimitResponse.getResult();
        }
        log.error("获取用户限购失败{}",userHollandaucLimitResponse.getError());
        throw new ResponseException(500,messageSources.get("get.user.hollandauc.limit.error"));


    }

}
