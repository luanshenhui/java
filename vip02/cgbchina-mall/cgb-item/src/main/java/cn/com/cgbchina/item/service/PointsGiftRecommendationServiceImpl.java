package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.*;
import cn.com.cgbchina.item.dto.GiftRecommendationDto;
import cn.com.cgbchina.item.manager.PointsGiftRecommendationManager;
import cn.com.cgbchina.item.model.*;
import com.google.common.base.Function;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Preconditions.checkArgument;
import static com.spirit.util.Arguments.notNull;

/**
 * Created by txy on 2016/8/1.
 */
@Service
@Slf4j
public class PointsGiftRecommendationServiceImpl implements PointsGiftRecommendationService {
    @Resource
    private PointsGiftRecommendationManager pointsGiftRecommendationManager;
    @Resource
    private GoodsPointRegionDao goodsPointRegionDao;
    @Resource
    private GoodsRecommendationJfDao goodsRecommendationJfDao;
    @Resource
    private ItemDao itemDao;
    @Resource
    private GoodsDao goodsDao;
    @Resource
    private TblGoodsPaywayDao tblGoodsPaywayDao;


    /**
     * 新增积分区间
     *
     * @param goodsPointRegionModel
     * @return
     */
    @Override
    public Response<Boolean> createPointsRegion(GoodsPointRegionModel goodsPointRegionModel) {
        Response<Boolean> response = Response.<Boolean>newResponse();
        try {
            Boolean result = pointsGiftRecommendationManager.createPointsRegion(goodsPointRegionModel);
            if (!result) {
                response.setError("pointsRegion.create.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (Exception e) {
            log.error("pointsRegion.create.error", Throwables.getStackTraceAsString(e));
            response.setError("pointsRegion.create.error");
            return response;
        }
    }

    /**
     * 查询所有的积分区间
     *
     * @return
     */
    @Override
    public Response<List<GoodsPointRegionModel>> findPointRegionAll() {
        Response<List<GoodsPointRegionModel>> response = Response.<List<GoodsPointRegionModel>>newResponse();
        try {
            List<GoodsPointRegionModel> goodsPointRegionModels = goodsPointRegionDao.findGoodsPointRegionList();
            response.setResult(goodsPointRegionModels);
        } catch (Exception e) {
            log.error("pointsRegion.findPointRegionAll.error", Throwables.getStackTraceAsString(e));
            response.setError("findPointRegionAll.error");
        }
        return response;
    }

    /**
     * 找出积分区间下的礼品
     *
     * @param goodsRecommendationJfModel
     * @return
     */
    @Override
    public Response<List<Map<String,Object>>> findRecommendGift(GoodsRecommendationJfModel goodsRecommendationJfModel) {
        Response<List<Map<String,Object>>> response = Response.newResponse();
        try {
            List<GoodsRecommendationJfModel> goodsRecommendationJfModels = goodsRecommendationJfDao.findRecommendGift(goodsRecommendationJfModel);
            if(null == goodsRecommendationJfModels || goodsRecommendationJfModels.isEmpty()){
                response.setResult(null);
                return response;
            }
            List<String> codes = Lists.transform(goodsRecommendationJfModels,new Function<GoodsRecommendationJfModel, String>() {
                @NotNull
                @Override
                public String apply(@NotNull GoodsRecommendationJfModel input) {
                    return input.getGoodsId();
                }
            });
            List<ItemModel> itemModels = itemDao.findByCodes(codes);
            if(null == itemModels || itemModels.isEmpty()){
                response.setResult(null);
                return response;
            }
            Map<String, ItemModel> map = Maps.uniqueIndex(itemModels, new Function<ItemModel, String>() {
                @NotNull
                @Override
                public String apply(@NotNull ItemModel input) {
                    return input.getCode();
                }
            });
            List<Map<String, Object>> results = Lists.newArrayListWithExpectedSize(goodsRecommendationJfModels.size());
            for(GoodsRecommendationJfModel model : goodsRecommendationJfModels){
                ItemModel itemModel = map.get(model.getGoodsId());
                if (null == itemModel)
                    continue;
                Map<String, Object> item = Maps.newHashMapWithExpectedSize(2);
                item.put("model" , model);
                item.put("goodsCode" , itemModel.getGoodsCode());
                results.add(item);
            }
            response.setResult(results);
        } catch (Exception e) {
            log.error("findRecommendGift.error: reason: -> {} ", Throwables.getStackTraceAsString(e));
            response.setError("findRecommendGift.error");
        }
        return response;
    }

    /**
     * 新增积分区间下的礼品
     *
     * @param goodsRecommendationJfModel
     * @return
     */
    @Override
    public Response<Boolean> createPointsGift(GoodsRecommendationJfModel goodsRecommendationJfModel) {
        Response<Boolean> response = Response.<Boolean>newResponse();
        try {
            Boolean result = pointsGiftRecommendationManager.createPointsGift(goodsRecommendationJfModel);
            if (!result) {
                response.setError("pointsGift.create.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (Exception e) {
            log.error("pointsGift.create.error", Throwables.getStackTraceAsString(e));
            response.setError("pointsGift.create.error");
            return response;
        }
    }

    /**
     * 判断此积分区间是否可以推荐单品
     *
     * @param regionId
     * @return
     */
    @Override
    public Response<Boolean> findPointsGiftCount(Integer regionId) {
        Response<Boolean> response = Response.newResponse();
        try {
            checkArgument(notNull(regionId), "regionId is null");
            Long count = goodsRecommendationJfDao.findPointsGiftCount(regionId);
            if (count >= 4) {
                response.setResult(Boolean.FALSE);
            } else {
                response.setResult(Boolean.TRUE);
            }
            return response;
        } catch (Exception e) {
            log.error("findPointsGiftCount.PointsGiftRecommendation.error", Throwables.getStackTraceAsString(e));
            response.setError("findPointsGiftCount.error");
            return response;
        }
    }

    /**
     * 单品check
     *
     * @param regionId
     * @param goodsXid
     * @param minPoint
     * @param maxPoint
     * @return
     */
    @Override
    public Response<GiftRecommendationDto> findGiftInfCheck(Integer regionId, String goodsXid, Integer minPoint, Integer maxPoint) {
        Response<GiftRecommendationDto> response = Response.newResponse();
        try {
            checkArgument(notNull(regionId), "regionId is null");
            checkArgument(StringUtils.isNotBlank(goodsXid), "goodsXid is null");
            checkArgument(notNull(minPoint), "minPoint is null");
            checkArgument(notNull(maxPoint), "maxPoint is null");
            GiftRecommendationDto giftRecommendationDto = new GiftRecommendationDto();
            Map<String, Object> params = Maps.newHashMap();
            params.put("regionId", regionId);
            params.put("goodsId", goodsXid);
            Long total = goodsRecommendationJfDao.findUsedGiftCheck(params);//判断这个单品在这个此积分区间是否被推荐过
            if (total > 0) {
                giftRecommendationDto.setGiftCodeCheck(Boolean.FALSE);
            } else {
                giftRecommendationDto.setGiftCodeCheck(Boolean.TRUE);// 此单品没有被推荐过
                ItemModel itemModel = itemDao.findItemByXid(goodsXid);
                if (itemModel != null) {
                    GoodsModel goodsModel = goodsDao.findById(itemModel.getGoodsCode());
                    if (goodsModel != null) {
                        if (!Contants.CHANNEL_POINTS_02.equals(goodsModel.getChannelPoints())) {// 判断该单品是否已在积分商城上架
                            giftRecommendationDto.setGiftOnShelveCheck(Boolean.FALSE);
                        } else {
                            giftRecommendationDto.setGiftOnShelveCheck(Boolean.TRUE);
                            TblGoodsPaywayModel tblGoodsPaywayModel = tblGoodsPaywayDao.findJPPoints(itemModel.getCode());//取得金普价
                            if (tblGoodsPaywayModel != null) {
                                Long jpPointPrice = tblGoodsPaywayModel.getGoodsPoint();
                                if ((jpPointPrice >= minPoint) && (jpPointPrice < maxPoint)) {
                                    giftRecommendationDto.setGiftPointsPriceCheck(Boolean.TRUE);
                                    giftRecommendationDto.setGoodsPoint(jpPointPrice);//金普价
                                } else {
                                    giftRecommendationDto.setGiftPointsPriceCheck(Boolean.FALSE);
                                }
                            }
                        }
                    }
                }
            }
            response.setResult(giftRecommendationDto);
            return response;
        } catch (Exception e) {
            log.error("findGiftInfCheck.PointsGiftRecommendation.error", Throwables.getStackTraceAsString(e));
            response.setError("findGiftInfCheck.error");
            return response;
        }
    }

    /**
     * 根据goodsXid找出礼品名称
     *
     * @param goodsXid
     * @return
     */
    @Override
    public Response<GiftRecommendationDto> findGiftName(String goodsXid) {
        Response<GiftRecommendationDto> response = Response.newResponse();
        try {
            checkArgument(StringUtils.isNotBlank(goodsXid), "goodsXid is null");
            GiftRecommendationDto giftRecommendationDto = new GiftRecommendationDto();
            ItemModel itemModel = itemDao.findItemByXid(goodsXid);
            if (itemModel != null) {
                GoodsModel goodsModel = goodsDao.findById(itemModel.getGoodsCode());
                giftRecommendationDto.setName(goodsModel.getName());
                giftRecommendationDto.setCode(itemModel.getCode());
            }
            response.setResult(giftRecommendationDto);
            return response;
        } catch (Exception e) {
            log.error("findGiftName.PointsGiftRecommendation.error", Throwables.getStackTraceAsString(e));
            response.setError("findGiftName.error");
            return response;
        }
    }

    /**
     * 删除礼品
     *
     * @param goodsRecommendationJfModel
     * @return
     */
    @Override
    public Response<Boolean> deleteGift(GoodsRecommendationJfModel goodsRecommendationJfModel) {
        Response<Boolean> response = Response.newResponse();
        try {
            Boolean result = pointsGiftRecommendationManager.deleteGift(goodsRecommendationJfModel);
            if (!result) {
                response.setError("delete.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (Exception e) {
            log.error("deleteGift.PointsGiftRecommendation.error", Throwables.getStackTraceAsString(e));
            response.setError("deleteGift.error");
            return response;
        }
    }

    /**
     * 找出最大顺序
     *
     * @return
     */
    @Override
    public Response<Integer> findMaxGiftSeq() {
        Response<Integer> response = Response.newResponse();
        try {
            Integer result = goodsRecommendationJfDao.findMaxGiftSeq();
            response.setSuccess(Boolean.TRUE);
            response.setResult(result);
            return response;
        } catch (Exception e) {
            log.error("find.maxSort.error", Throwables.getStackTraceAsString(e));
            response.setError("find.maxSort.error");
            return response;
        }
    }

    /**
     * 交换顺序
     *
     * @param currentId
     * @param currentSort
     * @param changeId
     * @param changeSort
     * @return
     */
    @Override
    public Response<Boolean> changeGiftSort(Integer currentId, String currentSort, Integer changeId, String changeSort) {
        Response<Boolean> response = Response.newResponse();
        try {
            checkArgument(notNull(currentId), "currentId is null");
            checkArgument(StringUtils.isNotBlank(currentSort), "currentSort is null");
            checkArgument(notNull(changeId), "changeId is null");
            checkArgument(StringUtils.isNotBlank(changeSort), "changeSort is null");
            Map<String, Object> param = Maps.newHashMap();
            param.put("currentId", currentId);
            param.put("changeSort", changeSort);
            Map<String, Object> changeParam = Maps.newHashMap();
            changeParam.put("changeId", changeId);
            changeParam.put("currentSort", currentSort);
            Boolean current = pointsGiftRecommendationManager.currentGift(param);
            Boolean change = pointsGiftRecommendationManager.changeGift(changeParam);
            if (current == false || change == false) {
                response.setError("changeGiftSort.error");
                return response;
            }
            response.setResult(Boolean.TRUE);
            return response;
        } catch (Exception e) {
            log.error("change.gift.sort.error", Throwables.getStackTraceAsString(e));
            response.setError("gift.sort.error");
            return response;
        }
    }

    /**
     * 删除积分区间
     *
     * @param param
     * @return
     */
    @Override
    public Response<Boolean> deletePointsRegion(Map<String,Object> param) {
        Response<Boolean> response = Response.newResponse();
        try {
            Boolean result = pointsGiftRecommendationManager.deletePointsRegion(param);
            if (!result) {
                response.setError("delete.points.region.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (Exception e) {
            log.error("deletePointsRegion.error", Throwables.getStackTraceAsString(e));
            response.setError("deletePointsRegion.error");
            return response;
        }
    }
}
