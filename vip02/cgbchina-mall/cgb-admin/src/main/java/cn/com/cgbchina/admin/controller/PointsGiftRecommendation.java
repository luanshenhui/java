package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.dto.GiftRecommendationDto;
import cn.com.cgbchina.item.model.GoodsPointRegionModel;
import cn.com.cgbchina.item.model.GoodsRecommendationJfModel;
import cn.com.cgbchina.item.service.PointsGiftRecommendationService;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import com.google.common.base.Splitter;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * Created by txy on 2016/8/1.
 */
@Controller
@RequestMapping("/api/admin/pointsGiftRecommendation")
@Slf4j
public class PointsGiftRecommendation {
    @Resource
    private MessageSources messageSources;
    @Resource
    private PointsGiftRecommendationService pointsGiftRecommendationService;

    /**
     * 新增积分区间
     *
     * @param goodsPointRegionModel
     * @return
     */
    @RequestMapping(value = "/create", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean create(GoodsPointRegionModel goodsPointRegionModel) {
        User user = UserUtil.getUser();
        goodsPointRegionModel.setMinPoint(goodsPointRegionModel.getMinPoint());
        goodsPointRegionModel.setMaxPoint(goodsPointRegionModel.getMaxPoint());
        goodsPointRegionModel.setCreateOper(user.getName());
        goodsPointRegionModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
        Response<Boolean> response = pointsGiftRecommendationService.createPointsRegion(goodsPointRegionModel);
        if (response.isSuccess()) {
           return response.getResult();
        }
        log.error("insert.error{}，error:{}",goodsPointRegionModel, response.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));
    }

    /**
     * 找出积分区间下的礼品
     *
     * @param goodsRecommendationJfModel
     * @return
     */
    @RequestMapping(value = "/findRecommendGift", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<Map<String,Object>> findRecommendGift(GoodsRecommendationJfModel goodsRecommendationJfModel) {
        Response<List<Map<String,Object>>> response = pointsGiftRecommendationService.findRecommendGift(goodsRecommendationJfModel);
        if (response.isSuccess()) {
            return response.getResult();
        }
        log.error("findRecommendGift.error{}，error:{}",goodsRecommendationJfModel, response.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));
    }

    /**
     * 新增积分区间下的礼品
     *
     * @param goodsRecommendationJfModel
     * @return
     */
    @RequestMapping(value = "/createPointsGift", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean createPointsGift(GoodsRecommendationJfModel goodsRecommendationJfModel) {
        User user = UserUtil.getUser();
        Response<Integer> response = pointsGiftRecommendationService.findMaxGiftSeq();
        if (response.isSuccess()) {
            Integer giftSeqMax = 0;
            if(null == response.getResult()){
                giftSeqMax = 0;
            }
            else {
                giftSeqMax = response.getResult() + 1;
            }
            goodsRecommendationJfModel.setRegionId(goodsRecommendationJfModel.getRegionId());//积分区间Id
            goodsRecommendationJfModel.setGoodsId(goodsRecommendationJfModel.getGoodsId()); //单品编码20位
            goodsRecommendationJfModel.setGoodsNm(goodsRecommendationJfModel.getGoodsNm()); //礼品名称
            goodsRecommendationJfModel.setGoodsXid(goodsRecommendationJfModel.getGoodsXid());//礼品编码5位
            goodsRecommendationJfModel.setJpPoint(goodsRecommendationJfModel.getJpPoint());//金普价
            goodsRecommendationJfModel.setDelFlag(Contants.DEL_FLAG_0);//删除标识0
            goodsRecommendationJfModel.setGoodsSeq(giftSeqMax);
            goodsRecommendationJfModel.setCreateOper(user.getName());
            goodsRecommendationJfModel.setCreateDate(DateHelper.getyyyyMMdd());
            goodsRecommendationJfModel.setCreateTime(DateHelper.getHHmmss());
            Response<Boolean> result = pointsGiftRecommendationService.createPointsGift(goodsRecommendationJfModel);
            if (result.isSuccess()) {
                return result.getResult();
            }
            log.error("insert.error{}，error:{}", goodsRecommendationJfModel,response.getError());
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));

        }
        log.error("failed. to ,find {},error code:{}", goodsRecommendationJfModel, response.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));
    }

    /**
     * 判断此积分区间是否可以推荐单品
     *
     * @param regionId
     * @return
     */
    @RequestMapping(value = "/findPointsGiftCount", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean findPointsGiftCount(Integer regionId) {
        Response<Boolean> response = pointsGiftRecommendationService.findPointsGiftCount(regionId);
        if (response.isSuccess()) {
            return response.getResult();
        }
        log.error("findPointsGiftCount.error{}，error:{}", regionId,response.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));
    }

    /**
     * 推荐单品check
     *
     * @param regionId
     * @param goodsXid
     * @return
     */
    @RequestMapping(value = "/findGiftInfCheck", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public GiftRecommendationDto findGiftInfCheck(Integer regionId, String goodsXid, Integer minPoint, Integer maxPoint) {
        Response<GiftRecommendationDto> response = pointsGiftRecommendationService.findGiftInfCheck(regionId, goodsXid,minPoint,maxPoint);
        if(response.isSuccess()){
            return response.getResult();
        }
        log.error("findGiftInfCheck.error.regionId{}，goodsXid{}，minPoint{},maxPoint{},error:{}", regionId,goodsXid,minPoint,maxPoint,response.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));
    }

    /**
     * 根据goodsXid找出礼品名称
     * @param goodsXid
     * @return
     */
    @RequestMapping(value = "/findGiftName", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public GiftRecommendationDto findGiftName(String goodsXid) {
        Response<GiftRecommendationDto> response= pointsGiftRecommendationService.findGiftName(goodsXid);
        if(response.isSuccess()){
           return response.getResult();
        }
        log.error("findGiftName.error{}，error:{}",goodsXid, response.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));
    }

    /**
     * 删除礼品
     * @param id
     * @return
     */
    @RequestMapping(value = "/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<Boolean> deleteGift(@PathVariable Integer id){
        // 获取用户信息
        User user = UserUtil.getUser();
        GoodsRecommendationJfModel goodsRecommendationJfModel = new GoodsRecommendationJfModel();
        goodsRecommendationJfModel.setId(id);
        goodsRecommendationJfModel.setModifyOper(user.getName());
        goodsRecommendationJfModel.setModifyDate(DateHelper.getyyyyMMdd());
        goodsRecommendationJfModel.setModifyTime(DateHelper.getHHmmss());
        Response<Boolean> response = pointsGiftRecommendationService.deleteGift(goodsRecommendationJfModel);
        if(response.isSuccess()){
           return response;
        }
        log.error("delete.error{}.error:{}", id,response.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));
    }

    /**
     * 交换顺序
     * @param currentId
     * @param currentSort
     * @param changeId
     * @param changeSort
     * @return
     */
    @RequestMapping(value = "/changeSort", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean changeGiftSort(Integer currentId, String currentSort, Integer changeId, String changeSort){
        Response<Boolean> response = pointsGiftRecommendationService.changeGiftSort(currentId,currentSort,changeId,changeSort);
        if (response.isSuccess()){
            return response.getResult();
        }
        log.error("changeSort.error.currentId{},currentSort{},changeId{},changeSort{},error:{}", currentId,currentSort,changeId,changeSort,response.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));
    }

    /**
     * 删除积分区间
     * @param regionId
     * @return
     */
    @RequestMapping(value = "/deletePointsRegion", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean deletePointsRegion(String regionId) {
        User user = UserUtil.getUser();
        checkArgument(StringUtils.isNotBlank(regionId),"regionId is null");
        List<String> regionIdList = Splitter.on(',').omitEmptyStrings().trimResults().splitToList(regionId);
        Map<String,Object> param = Maps.newHashMap();
        param.put("regionIdList",regionIdList);
        param.put("modifyOper",user.getName());
        Response<Boolean> response = pointsGiftRecommendationService.deletePointsRegion(param);
        if (response.isSuccess()){
            return response.getResult();
        }
        log.error("changeSort.error.regionId{},error:{}", regionId,response.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));
    }
}
