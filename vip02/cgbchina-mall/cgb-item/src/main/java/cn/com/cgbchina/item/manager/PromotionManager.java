package cn.com.cgbchina.item.manager;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Strings.isNullOrEmpty;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import cn.com.cgbchina.common.utils.GoodsCheckUtil;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.collections.IteratorUtils;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.LocalDateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.JavaType;
import com.google.common.base.Function;
import com.google.common.base.MoreObjects;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Collections2;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.category.model.BackCategory;
import com.spirit.category.model.Spu;
import com.spirit.category.service.BackCategoryHierarchy;
import com.spirit.category.service.SpuService;
import com.spirit.common.model.Response;
import com.spirit.search.Pair;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dao.PromotionDao;
import cn.com.cgbchina.item.dao.PromotionPeriodDao;
import cn.com.cgbchina.item.dao.PromotionRangeDao;
import cn.com.cgbchina.item.dao.PromotionVendorDao;
import cn.com.cgbchina.item.dto.DuliCheckTimeDto;
import cn.com.cgbchina.item.dto.ItemGoodsDetailDto;
import cn.com.cgbchina.item.dto.PromotionRangeAddDto;
import cn.com.cgbchina.item.dto.RangeStatusDto;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.PromotionModel;
import cn.com.cgbchina.item.model.PromotionPeriodModel;
import cn.com.cgbchina.item.model.PromotionRangeModel;
import cn.com.cgbchina.item.model.PromotionVendorModel;
import lombok.extern.slf4j.Slf4j;


/**
 * @author wenjia.hao
 * @version 1.0
 */
@Component
@Transactional
@Slf4j
@SuppressWarnings("unchecked")
public class PromotionManager {
    private final DateTimeFormatter dateTimeFormat = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
    private final JsonMapper jsonMapper = JsonMapper.JSON_ALWAYS_MAPPER;
    private JavaType listPromotionRange = JsonMapper.JSON_ALWAYS_MAPPER.createCollectionType(List.class,
            PromotionRangeAddDto.class);
    @Resource
    private PromotionDao promotionDao;
    @Resource
    private PromotionVendorDao promotionVendorDao;
    @Resource
    private PromotionRangeDao promotionRangeDao;
    @Resource
    private PromotionPeriodDao promotionPeriodDao;
    @Resource
    private ItemDao itemDao;
    @Resource
    private GoodsDao goodsDao;
    @Resource
    private SpuService spuService;
    @Resource
    private BackCategoryHierarchy backCategoryHierarchy;


    /**
     * 供应商新增/修改活动 供应商新增活动
     *
     */
    public void changePromotionForVendor(PromotionModel promotionModel, String range, String saveType,
                                         String vendorId) {
        // ID 不存在，新增
        if (promotionModel.getId() == null) {
            promotionDao.insertAdminPromotion(promotionModel);
            // 如果是提交审核 状态为 待初审:2 待复审:5 那么更新period表 保存不更新period表
            if (promotionModel.getCheckStatus().equals(2) || promotionModel.getCheckStatus().equals(5)) {
                promotionPeriodDao.deletePeriodByPromId(promotionModel.getId());
                insertPeriod(promotionModel);
            }
        } else {
            promotionDao.updateAdminPromotion(promotionModel);
            // 如果是提交审核 状态为 待初审:2 待复审:5 那么更新period表 保存不更新period表
            if (promotionModel.getCheckStatus().equals(2) || promotionModel.getCheckStatus().equals(5)) {
                promotionPeriodDao.deletePeriodByPromId(promotionModel.getId());
                insertPeriod(promotionModel);
            }
        }
        // 变更选品范围
        changePromotionRange(promotionModel, range, vendorId);
        // 变更活动状态
        if (StringUtils.isNotEmpty(saveType) && "1".equals(saveType)) {
            Integer checkStatus;
            // 只有报名的时候状态才是算出来的 创建人是内管的时候 才需要算状态
            if (promotionModel.getIsSignup() == 1 && "0".equals(promotionModel.getCreateOper())) {
                checkStatus = this.changeCheckStatus(promotionModel.getId());
            } else {
                // 其他时候
                checkStatus = promotionModel.getCheckStatus();
            }
            if (checkStatus != null) {
                Map<String, Object> rangeMap = new HashMap<>();
                rangeMap.put("id", promotionModel.getId());
                rangeMap.put("checkStatus", checkStatus);
                promotionDao.updateCheckStatusForVendor(rangeMap);
            }
        }
    }

    /**
     * 供应商报名 更新跟新增都用
     *
     * @param promotionModel 活动基本信息对象  就用个id
     */
    public String changePromotionRange(PromotionModel promotionModel, String range, String vendorId) {
        String result = "";
        List<PromotionRangeAddDto> rangeModelList = jsonMapper.fromJson(range, listPromotionRange);
        // 去除重复单品结果
        final List<PromotionRangeAddDto> resultList = itemDuliCheck(rangeModelList, promotionModel.getBeginDate(),
                promotionModel.getEndDate(), promotionModel.getId());
        if (resultList.size() == 0) {
            throw new IllegalArgumentException("prom.all.item.check.fail");
        }
        if (rangeModelList.size() > resultList.size()) {
            result = "部分单品同时间段内已经参加其他活动，系统已自动剔除";
        }
        PromotionModel currentModel = promotionDao.findById(promotionModel.getId()); //数据库中的
        PromotionRangeModel promotionRangeModel;
        List<PromotionRangeModel> insertRangers = Lists.newArrayList();
        List<PromotionRangeModel> updateRangers = Lists.newArrayList();
        List<PromotionRangeModel> dbRangeList = Lists.newArrayList();// db中已经存在的数据
        Map<Integer, PromotionRangeModel> dbRangeMap = null;// db中已存数据的映射map
        if (promotionModel.getId() != null) {
            Map<String, Object> params = Maps.newHashMap();
            params.put("promotionId", String.valueOf(promotionModel.getId()));
            params.put("vendorId", vendorId);
            dbRangeList = promotionRangeDao.findByPromIdAndVendor(params);
            dbRangeMap = Maps.uniqueIndex(dbRangeList, new Function<PromotionRangeModel, Integer>() {
                @Override
                public Integer apply(PromotionRangeModel input) {
                    return input.getId();
                }
            });
        }
        for (PromotionRangeAddDto promotionRangeAddDto : resultList) {
            // 此dto 有id是更新
            if (promotionRangeAddDto.getId() != null) {

                //分报名的时候变更还是供应商自己修改的时候变更
                //创建人是内管  供应商报名情况
                PromotionRangeModel dbModel = dbRangeMap.get(promotionRangeAddDto.getId());
                if(Integer.valueOf(0).equals(currentModel.getCreateOperType())){
                // 更新分两种情况 有变更 更新数据并置状态为待复审 无变更 不动
                if (dbModel.getPerStock().equals(promotionRangeAddDto.getStock())) {//db中的stock是整个活动的库存  前台传来参数的stock是单场库存
                    // 库存相等 没有变更
                    continue;
                } else {
                    // 这条数据要更新 只更新库存
                    PromotionRangeModel update=new PromotionRangeModel();
                    update.setId(promotionRangeAddDto.getId());
                    update.setPerStock(promotionRangeAddDto.getStock());
                    update.setStock(getPeriodCount(currentModel)*promotionRangeAddDto.getStock());//前台传过来的stock是单场库存
                    update.setCheckStatus("0");// 更新的重新变成待审核
                    update.setModifyTime(DateTime.now().toDate());
                    update.setModifyOper(vendorId);
                    updateRangers.add(update);
                    continue;
                }
                    //活动创建人类型供应商 修改还需要修改排序
                }else {
                        // 这条数据要更新 更新库存和排序
                        PromotionRangeModel update=new PromotionRangeModel();
                        update.setSeq(promotionRangeAddDto.getSeq());//排序扔进去
                        update.setId(promotionRangeAddDto.getId());
                        update.setPerStock(promotionRangeAddDto.getStock());
                        update.setStock(getPeriodCount(currentModel)*promotionRangeAddDto.getStock());//前台传过来的stock是单场库存
                        update.setCheckStatus("0");// 更新的重新变成待审核
                        update.setModifyTime(DateTime.now().toDate());
                        update.setModifyOper(vendorId);
                        updateRangers.add(update);
                        continue;

                }



            }
            // 无id是新建
            promotionRangeModel = new PromotionRangeModel();
            promotionRangeModel.setPromotionId(promotionModel.getId());
            promotionRangeModel.setRangeType(0);// 固定单品
            promotionRangeModel.setSelectCode(promotionRangeAddDto.getSelectCode().trim());
            promotionRangeModel.setSelectName(promotionRangeAddDto.getSelectName().trim());
            String backCategory = promotionRangeAddDto.getBackCategory();
            //获取商品
            ItemModel itemModel = itemDao.findById(promotionRangeAddDto.getSelectCode().trim());
            if (itemModel == null) {
                throw new IllegalArgumentException("prom.find.backcategory.error");
            }
            GoodsModel goodsModel = goodsDao.findById(itemModel.getGoodsCode());
            if (goodsModel == null) {
                throw new IllegalArgumentException("prom.find.backcategory.error");
            }
            promotionRangeModel.setGoodsCode(goodsModel.getCode());
            if (StringUtils.isNotEmpty(backCategory)) {
                String[] catIdList = backCategory.split(",");
                for (int i = 0; i < catIdList.length; i++) {
                    String catId = catIdList[i];
                    if (!Strings.isNullOrEmpty(catId)) {
                        switch (i) {
                            case 0:
                                promotionRangeModel.setBackCategory1Id(Long.parseLong(catId));
                                break;
                            case 1:
                                promotionRangeModel.setBackCategory2Id(Long.parseLong(catId));
                                break;
                            case 2:
                                promotionRangeModel.setBackCategory3Id(Long.parseLong(catId));
                                break;
                        }
                    }
                }
            } else {
             //如果为空  手动调接口获取
                Response<List<Pair>> pairListResponse = this.findCategoryByGoodsCode(goodsModel.getCode());
                if (pairListResponse.isSuccess()) {
                    List<Pair> categoryList = pairListResponse.getResult();
                    for (int i = 1; i < categoryList.size(); i++) {
                        Long categoryId = categoryList.get(i).getId();
                        switch (i) {
                            case 1:
                                promotionRangeModel.setBackCategory1Id(categoryId);
                                break;
                            case 2:
                                promotionRangeModel.setBackCategory2Id(categoryId);
                                break;
                            case 3:
                                promotionRangeModel.setBackCategory3Id(categoryId);
                                break;
                            default:
                                break;
                        }
                    }
                }
            }
            promotionRangeModel.setCheckStatus("0");// 0 待审核 新增都是待审核
            promotionRangeModel.setIsValid(1);// 正常状态
            promotionRangeModel.setSeq(promotionRangeAddDto.getSeq());// 排序
            promotionRangeModel.setPrice(promotionRangeAddDto.getPrice());// 售价
            promotionRangeModel.setStock(getPeriodCount(currentModel)*promotionRangeAddDto.getStock());// 活动商品总库存
            promotionRangeModel.setPerStock(promotionRangeAddDto.getStock());//单场库存  用户的输入
            promotionRangeModel.setCostBy(1);// 费用承担方 供应商
            promotionRangeModel.setCreateOperType(Contants.PROMOTION_CREATE_OPER_TYPE_1);// 创建者类型
            promotionRangeModel.setVendorId(vendorId);// 供应商id
            promotionRangeModel.setCreateOper(promotionModel.getCreateOper());
            promotionRangeModel.setCreateTime(DateTime.now().toDate());
            insertRangers.add(promotionRangeModel);
        }
        // db存在 resultList不存在的就是要删除的 取出不删除的ids
        List<Integer> notChangeList = Lists.newArrayList();
        for (PromotionRangeAddDto temp : resultList) {
            if (temp.getId() != null) {
                PromotionRangeModel promotionRangeModel1 = dbRangeMap.get(temp.getId());
                if (promotionRangeModel1 != null) {
                    // db里有 resultList也有 不动
                    notChangeList.add(promotionRangeModel1.getId());
                }
            }
        }

        List<Integer> readyToDelete = Lists.newArrayList();
        for (PromotionRangeModel prom : dbRangeList) {
            if (!notChangeList.contains(prom.getId())) {
                readyToDelete.add(prom.getId());
            }
        }
        // 待更新集合
        if (updateRangers.size() > 0) {
            promotionRangeDao.updateRangesByIds(updateRangers);

        }
        // 待插入集合
        if (insertRangers.size() > 0) {
            // 插入数据库
            promotionRangeDao.insertAllForVendor(insertRangers);
        }
        // 待删除集合
        if (readyToDelete.size() > 0) {
            promotionRangeDao.deleteByIds(readyToDelete);
        }
        // 所有操作完成后提交时变更活动状态
        //针对供应商报名的情况才需要变更活动状态 供应商自己的新增跟编辑不需要变更主状态 此时的主活动状态已经计算完毕
        if (promotionModel.getCheckStatus() == null) {
            Integer checkStatus = this.changeCheckStatus(promotionModel.getId());
            if (checkStatus != null) {
                Map<String, Object> rangeMap = new HashMap<>();
                rangeMap.put("id", promotionModel.getId());
                rangeMap.put("checkStatus", checkStatus);
                promotionDao.updateCheckStatusForVendor(rangeMap);
            }
        }
        return result;

    }
    private Response<List<Pair>> findCategoryByGoodsCode(String goodsCode) {
        Response<List<Pair>> response = Response.newResponse();
        if (Strings.isNullOrEmpty(goodsCode)) {
            log.error("goodsCode can not be empty,goodsCode:{}", goodsCode);
            response.setError("params.illegal");
            return response;
        }
        try {
            GoodsModel goodsModel = goodsDao.findById(goodsCode);
            Long spuId = goodsModel.getProductId();
            Response<Spu> spuR = spuService.findById(spuId);
            Long cateGoryId = spuR.getResult().getCategoryId();
            List<BackCategory> backCategoriesR = backCategoryHierarchy.ancestorsOf(cateGoryId);
            List<Pair> pairs = Lists.newArrayListWithCapacity(backCategoriesR.size());
            for (BackCategory bc : backCategoriesR) {
                pairs.add(new Pair(bc.getName(), bc.getId()));
            }
            response.setResult(pairs);
            return response;
        } catch (Exception e) {
            log.error("failed to find good's categorys by goodsCode,goodsCode:{},cause:{}", goodsCode, Throwables.getStackTraceAsString(e));
            response.setError("query.error");
            return response;
        }
    }
    private GoodsModel findGoodsModelByItemCode(String itemCode) {
        ItemModel itemModel = itemDao.findById(itemCode);
        return goodsDao.findById(itemModel.getGoodsCode());
    }

    /**
     * 实时变更DB活动状态（仅 待复审、部分通过、全部通过、未通过复审）
     *
     */
    private Integer changeCheckStatus(Integer promotionId) {
        Integer checkStatus = null;
        RangeStatusDto dto = promotionRangeDao.rangeStatus(promotionId);
        if (dto == null || (dto.getAll() != null && dto.getAll().equals(0))) {
            return null;
        }
        // 逻辑：
        // 全部选品都是待审核状态，活动状态：待复审
        // 全部选品都是已拒绝状态，活动状态：未通过复审
        // 全部选品都是审核通过状态，活动状态：复审通过
        // 除以上外， 活动状态：部分通过审核

        // 全部待审核
        if (dto.getAll().equals(dto.getReady())) {
            // 待复审
            checkStatus = Contants.PROMOTION_STATE_5;
        } else if (dto.getAll().equals(dto.getRefuse())) {
            // change by geshuo 20160709:未通过复审
            checkStatus = Contants.PROMOTION_STATE_6;
        } else if (dto.getAll().equals(dto.getAlready())) {
            // change by geshuo 20160709:复审通过
            checkStatus = Contants.PROMOTION_STATE_7;
        } else if (dto.getAll() > dto.getAlready() || dto.getAll() > dto.getRefuse()) {
            // change by geshuo 20160709:部分通过审核
            checkStatus = Contants.PROMOTION_STATE_8;
        }
        return checkStatus;
    }

    /**
     * 插入可选择的供应商
     * @param promotionId 活动id
     * @param range  供应商范围 使用,分隔
     */
    private void insertVendor(Integer promotionId,String range){
        if (StringUtils.isNotEmpty(range)) {
            // 折扣和满减插入维护供应商表 如果range范围为空 不做处理 默认所有供应商有效
            List<String> venderIds=Splitter.on(",").trimResults().omitEmptyStrings().splitToList(range);
            List<PromotionVendorModel> venders = Lists.newArrayList();
            PromotionVendorModel promotionVendorModel;
            for (String str : venderIds) {
                promotionVendorModel = new PromotionVendorModel();
                promotionVendorModel.setIsValid(1);
                promotionVendorModel.setPromotionId(promotionId);
                promotionVendorModel.setVendorId(str);
                venders.add(promotionVendorModel);
            }
            promotionVendorDao.insertAll(venders);
        }
    }



    private Boolean needSignUp(Integer promType){
       return Integer.valueOf(10).equals(promType) ||Integer.valueOf(20).equals(promType);
   }
    private Boolean oppositeNeedSignUp(Integer promType){
        return Integer.valueOf(30).equals(promType) ||Integer.valueOf(40).equals(promType)||Integer.valueOf(50).equals(promType);
    }


    public String insertAdminPromotion(PromotionModel promotionModel, String range) {
        String result = "";
        promotionDao.insertAdminPromotion(promotionModel);
        // 如果是提交审核 状态为 待初审2 待复审5 那么更新period表 保存不更新period表
        if (promotionModel.getCheckStatus().equals(2) || promotionModel.getCheckStatus().equals(5)) {
            insertPeriod(promotionModel);
        }
        if (needSignUp(promotionModel.getPromType())) {
            //插入供应商
            insertVendor(promotionModel.getId(),range);
        }
        if (oppositeNeedSignUp(promotionModel.getPromType())) {
            List<PromotionRangeAddDto> rangeModelList = jsonMapper.fromJson(range, listPromotionRange);
            // 对活动单品的数据合理进行check 剔除同时间段已经参加别的活动的单品
            List<PromotionRangeAddDto> resultList = itemDuliCheck(rangeModelList, promotionModel.getBeginDate(),
                    promotionModel.getEndDate(), null);
            // 如果全部被剔除了 活动无效
            if (resultList.size() == 0) {
                throw new IllegalArgumentException("prom.all.item.check.fail");
            }
            if (rangeModelList.size() > resultList.size()) {
                result = "部分单品同时间段内已经参加其他活动，系统已自动剔除";
            }
            PromotionRangeModel promotionRangeModel;
            //得到periodcount 用于计算总库存
            Integer periodCount = getPeriodCount(promotionModel);
            List<PromotionRangeModel> rangers = Lists.newArrayList();
            for (PromotionRangeAddDto promotionRangeAddDto : resultList) {
                promotionRangeModel = new PromotionRangeModel();
                promotionRangeModel.setPromotionId(promotionModel.getId());
                promotionRangeModel.setRangeType(0);// 写死 都是单品
                promotionRangeModel.setSelectCode(promotionRangeAddDto.getSelectCode().trim());
                promotionRangeModel.setSelectName(promotionRangeAddDto.getSelectName());
                promotionRangeModel.setCheckStatus("0");// 0 待审核
                promotionRangeModel.setIsValid(1);// 正常状态
                promotionRangeModel.setSeq(promotionRangeAddDto.getSeq());// 排序
                promotionRangeModel.setGroupClassify(promotionRangeAddDto.getGroupClassify());//如果是团购 插入团购分类
                GoodsModel goodsModel = findGoodsModelByItemCode(promotionRangeAddDto.getSelectCode().trim());
                //
                String backCategory = promotionRangeAddDto.getBackCategory();
                if (StringUtils.isNotEmpty(backCategory)) {
                    String[] catIdList = backCategory.split(",");
                    for (int i = 0; i < catIdList.length; i++) {
                        String catId = catIdList[i];
                        if (!Strings.isNullOrEmpty(catId)) {
                            switch (i) {
                                case 0:
                                    promotionRangeModel.setBackCategory1Id(Long.parseLong(catId));
                                    break;
                                case 1:
                                    promotionRangeModel.setBackCategory2Id(Long.parseLong(catId));
                                    break;
                                case 2:
                                    promotionRangeModel.setBackCategory3Id(Long.parseLong(catId));
                                    break;
                                default:
                                    break;
                            }
                        }
                    }
                } else {
                    //如果为空  手动调接口获取
                    Response<List<Pair>> pairListResponse = this.findCategoryByGoodsCode(goodsModel.getCode());
                    if (pairListResponse.isSuccess()) {
                        List<Pair> categoryList = pairListResponse.getResult();
                        for (int i = 1; i < categoryList.size(); i++) {
                            Long categoryId = categoryList.get(i).getId();
                            switch (i) {
                                case 1:
                                    promotionRangeModel.setBackCategory1Id(categoryId);
                                    break;
                                case 2:
                                    promotionRangeModel.setBackCategory2Id(categoryId);
                                    break;
                                case 3:
                                    promotionRangeModel.setBackCategory3Id(categoryId);
                                    break;
                                default:
                                    break;
                            }
                        }
                    }
                }
                promotionRangeModel.setPrice(promotionRangeAddDto.getPrice());// 售价
                //活动商品总数量
                promotionRangeModel.setStock(promotionRangeAddDto.getStock()*periodCount);// 活动商品数量
                promotionRangeModel.setPerStock(promotionRangeAddDto.getStock());//单场库存
                promotionRangeModel.setCostBy(promotionRangeAddDto.getCostBy());// 其他
                promotionRangeModel.setCouponEnable(promotionRangeAddDto.getCouponEnable());// 是否使用优惠卷
                // promotionRangeModel.setLevelMinCount(promotionRangeAddDto.getLevelMinCount()); //参团人数此处不维护 商城会维护
                promotionRangeModel.setLevelPrice(promotionRangeAddDto.getLevelPrice());
                promotionRangeModel.setStartPrice(promotionRangeAddDto.getStartPrice());
                promotionRangeModel.setMinPrice(promotionRangeAddDto.getMinPrice());
                promotionRangeModel.setFeeRange(promotionRangeAddDto.getFeeRange());
                promotionRangeModel.setCreateOperType(promotionModel.getCreateOperType());// 创建者类型
                promotionRangeModel.setCreateOper(promotionModel.getCreateOper());

                String vendorId = goodsModel.getVendorId();// 根据供应商id查询供应商名
                promotionRangeModel.setVendorId(vendorId);// 供应商id
                promotionRangeModel.setGoodsCode(goodsModel.getCode());//商品code
                rangers.add(promotionRangeModel);
            }

            // 插入活动范围 有可能当前添加的活动单品已经都参加别的活动被筛选掉了
            if (rangers.size() > 0) {
                promotionRangeDao.insertAllForAdmin(rangers);
            }
        }
        return result;

    }

    /**
     * 单品查重
     */
    private List<PromotionRangeAddDto> itemDuliCheck(List<PromotionRangeAddDto> rangeModelList, Date beginDate,
                                                     Date endDate, Integer ignorePromId) {
        // 前两种活动单品check不在这
        List<PromotionRangeAddDto> resultList = Lists.newArrayList();
        // 如果传入了活动id 说明是更新 更新的时候单品的重复性校验要排除自身
        for (PromotionRangeAddDto promotionRangeAddDto : rangeModelList) {
            // 根据选品获取活动ids
            List<Integer> promIds = promotionRangeDao.getPromByItemId(promotionRangeAddDto.getSelectCode());
            // 如果他不等于空 默认为更新 需要
            if (ignorePromId != null) {
                if (promIds.size() > 0) {
                    Iterator<Integer> iterator = promIds.iterator();
                    while (iterator.hasNext()) {
                        if (iterator.next().equals(ignorePromId)) {
                            iterator.remove();
                        }
                    }
                }
            }
            if (promIds.size() > 0) {
                // 选品筛选有效活动id
                List<Integer> ridOfIds = promotionDao.getRidOfIds(promIds);
                // 只有筛选完剩下的有效活动有 才会再次查重
                if (ridOfIds.size() > 0) {
                    // 查到重复单品
                    // 检查该单品对应的活动区间是否重复
                    Map<String, Object> map = Maps.newHashMap();
                    map.put("promIdList", ridOfIds);
                    // 只需要判断 这一个时间是否重复就可以
                    DuliCheckTimeDto duliCheckTimeDto = new DuliCheckTimeDto();
                    duliCheckTimeDto.setBeginDate(beginDate);
                    duliCheckTimeDto.setEndDate(endDate);
                    ArrayList<DuliCheckTimeDto> duliCheckTimeDtos = Lists.newArrayList(duliCheckTimeDto);
                    map.put("timeList", duliCheckTimeDtos);
                    Integer duliCheck = promotionPeriodDao.findDuliCheck(map);
                    // 没有重复活动单品
                    if (duliCheck == null) {
                        resultList.add(promotionRangeAddDto);
                    }
                } else {
                    // 剔除无效的活动后 如果剩下的有效活动没有了 那么就不用check了 一定可以加入
                    resultList.add(promotionRangeAddDto);
                }
            } else {
                resultList.add(promotionRangeAddDto);
            }
        }
        return resultList;
    }

    /**
     * 编辑活动中可报名的供应商
     */
    private void editPromVendor(final PromotionModel promotionModel, String range){
        // 这种情况 range是供应商
        // 折扣和满减插入维护供应商表 如果range范围为空 不做处理 默认所有供应商有效
        List<String> venderIds;
        if ("".equals(range)) {
            venderIds = Collections.emptyList();
        } else {
            venderIds = Lists.newArrayList(range.split(","));
        }

        // 得到数据库中当前活动的所有供应商 跟编辑后的供应商结果做比较
        List<String> dumpVenderIds = promotionVendorDao.findVendorByPromotionId(promotionModel.getId());
        List<PromotionVendorModel> readyToDelete = Lists.newArrayList();
        List<PromotionVendorModel> readyToAdd = Lists.newArrayList();
        // 要插入数据库的
        for (String temp : venderIds) {
            if (!dumpVenderIds.contains(temp)) {
                PromotionVendorModel promotionVendorModel = new PromotionVendorModel();
                promotionVendorModel.setPromotionId(promotionModel.getId());
                promotionVendorModel.setVendorId(temp);
                promotionVendorModel.setIsValid(1);// 正常状态
                readyToAdd.add(promotionVendorModel);
            }
        }
        if (readyToAdd.size() != 0) {
            // 这是新增的
            promotionVendorDao.insertAll(readyToAdd);
        }

        // 要在数据库中删除的
        for (String temp : dumpVenderIds) {
            if (!venderIds.contains(temp)) {
                PromotionVendorModel promotionVendorModel = new PromotionVendorModel();
                promotionVendorModel.setVendorId(temp);
                promotionVendorModel.setPromotionId(promotionModel.getId());
                readyToDelete.add(promotionVendorModel);
            }

        }
        if (readyToDelete.size() != 0) {
            // 要删除掉的供应商
            promotionVendorDao.logicDelete(readyToDelete);
        }
    }
    public String updateAdminPromotion(final PromotionModel promotionModel, String range) {
        String result = "";
        promotionDao.updateAdminPromotion(promotionModel);
        // 如果是提交审核 状态为 待初审2 待复审5 那么更新period表 保存不更新period表
        if (promotionModel.getCheckStatus().equals(2) || promotionModel.getCheckStatus().equals(5)) {
            insertPeriod(promotionModel);
        }
        // 更新主要集中在商品的更新上 其他基本信息不变
        // 活动主更新已经在service中处理好 直接更新
        // 下面处理活动范围
        if (needSignUp(promotionModel.getPromType())) {
           editPromVendor(promotionModel,range);
        } else if(oppositeNeedSignUp(promotionModel.getPromType())) {
            // 这种情况 range是活动单品
            List<PromotionRangeAddDto> rangeModelList = jsonMapper.fromJson(range, listPromotionRange);
            // 秒杀不check时间 但是check单品
            // 后三种活动的单品重复性check 前两种活动的单品重复性check不在这
            // 对活动单品的数据合理进行check 剔除同时间段已经参加别的活动的单品
            List<PromotionRangeAddDto> resultList = itemDuliCheck(rangeModelList, promotionModel.getBeginDate(),
                    promotionModel.getEndDate(), promotionModel.getId());
            // 如果全部被剔除或部分被剔除，给出提示 但是这个活动还可以添加 但是单品没有了
            if (resultList.size() == 0) {
                // 所有单品被全部剔除 这次修改完后的单品被全部剔除 修改失效
                throw new IllegalArgumentException("prom.all.item.check.fail");
            }
            if (rangeModelList.size() > resultList.size()) {
                result = "有单品同时间段内已经参加其他活动，系统已自动剔除";
            }
            //checkRangeStock(resultList, promotionModel.getPromType());
            // 得到当前已经在数据库中的当前活动的所有单品
            Map<String, Object> params = Maps.newHashMap();
            params.put("promotionId", promotionModel.getId());
            List<String> selectCodeByPromId = promotionRangeDao.findSelectCodeByPromId(params);
            final List<PromotionRangeAddDto> readyToAdd = Lists.newArrayList();
            List<String> addItemCodeList = Lists.newArrayList();
            List<PromotionRangeAddDto> readyToUpdate = Lists.newArrayList();
            // 剔除重复单品后的集合处理
            for (PromotionRangeAddDto rangeAddDto : resultList) {
                if (selectCodeByPromId.contains(rangeAddDto.getSelectCode())) {
                    // 如果db中包含前台传过来这条单品 那么就是更新
                    readyToUpdate.add(rangeAddDto);
                    // 并从数据库中那个集合删掉要更新的 到最后剩下的就是要删除的
                    selectCodeByPromId.remove(rangeAddDto.getSelectCode());
                } else {
                    // 找不到的就是要新建的
                    readyToAdd.add(rangeAddDto);
                    addItemCodeList.add(rangeAddDto.getSelectCode());
                }
            }
            final String userId = promotionModel.getModifyOper();
            Map<String, String> vendorIdMap = Maps.newHashMap();// 供应商idMap
            Map<String, String> goodsCodeMap = Maps.newHashMap();// key:商品id value:单品id
            final Map<String, String> itemCodeMap = Maps.newHashMap();//key 单品id .value商品id

            // 得到三个集合
            // 待添加集合
            if (readyToAdd.size() > 0) {
                Response<List<ItemGoodsDetailDto>> itemListResult = findByIds(addItemCodeList);
                if (itemListResult.isSuccess()) {
                    List<ItemGoodsDetailDto> itemList = itemListResult.getResult();
                    List<String> goodsCodeList = Lists.newArrayList();// 商品id列表
                    for (ItemGoodsDetailDto itemDto : itemList) {
                        String goodsCode = itemDto.getGoodsCode();
                        goodsCodeList.add(goodsCode);
                        goodsCodeMap.put(goodsCode, itemDto.getCode());
                        itemCodeMap.put(itemDto.getCode(), goodsCode);      //抽出根据单品code查询商品code

                    }
                    // 查询商品信息
                    List<GoodsModel> goodsList = goodsDao.findByCodes(goodsCodeList);
                    for (GoodsModel goodsModel : goodsList) {
                        String itemCode = goodsCodeMap.get(goodsModel.getCode());
                        if (StringUtils.isEmpty(itemCode)) {
                            continue;
                        }
                        vendorIdMap.put(itemCode, goodsModel.getVendorId());
                    }
                    // 设置vendorId
                    for (PromotionRangeAddDto addDto : readyToAdd) {
                        String vendorId = vendorIdMap.get(addDto.getSelectCode());
                        addDto.setVendorId(vendorId);
                    }
                }

                List<PromotionRangeModel> insertList = IteratorUtils.toList(
                        Collections2.transform(readyToAdd, new Function<PromotionRangeAddDto, PromotionRangeModel>() {
                            @Override
                            public PromotionRangeModel apply(PromotionRangeAddDto input) {
                                PromotionRangeModel promotionRangeModel = new PromotionRangeModel();
                                BeanMapper.copy(input, promotionRangeModel);
                                String backCategory = input.getBackCategory();
                                if (StringUtils.isNotEmpty(backCategory)) {
                                    String[] catIds = backCategory.split(",");
                                    if (catIds.length == 3) {
                                        if (StringUtils.isNotEmpty(catIds[0])) {
                                            promotionRangeModel.setBackCategory1Id(Long.parseLong(catIds[0]));
                                        }
                                        if (StringUtils.isNotEmpty(catIds[1])) {
                                            promotionRangeModel.setBackCategory2Id(Long.parseLong(catIds[1]));
                                        }
                                        if (StringUtils.isNotEmpty(catIds[2])) {
                                            promotionRangeModel.setBackCategory3Id(Long.parseLong(catIds[2]));
                                        }
                                    }
                                }
                                promotionRangeModel.setPromotionId(promotionModel.getId());
                                promotionRangeModel.setCreateOper(userId);
                                promotionRangeModel.setCreateOperType(0);// 写死 创建人类型为内管
                                promotionRangeModel.setIsValid(1);// 单品类型 1正常
                                promotionRangeModel.setCheckStatus("0");// 待审核
                                promotionRangeModel.setRangeType(0);// 单品
                                promotionRangeModel.setPerStock(input.getStock());//页面传来stock是单场库存
                                promotionRangeModel.setStock(getPeriodCount(promotionModel)*input.getStock());
                                promotionRangeModel.setGoodsCode(itemCodeMap.get(input.getSelectCode()));
                                promotionRangeModel.setGroupClassify(input.getGroupClassify());//团购
                                return promotionRangeModel;
                            }
                        }).iterator());
                promotionRangeDao.insertAllForAdmin(insertList);
            }
            // 待更新集合
            if (readyToUpdate.size() > 0) {
                List<PromotionRangeModel> updateList = IteratorUtils.toList((Collections2.transform(readyToUpdate,
                        new Function<PromotionRangeAddDto, PromotionRangeModel>() {
                            @Override
                            public PromotionRangeModel apply(PromotionRangeAddDto input) {
                                PromotionRangeModel promotionRangeModel = new PromotionRangeModel();
                                if (input != null) {
                                    BeanMapper.copy(input, promotionRangeModel);
                                    String backCategory = input.getBackCategory();
                                    if (StringUtils.isNotEmpty(backCategory)) {
                                        String[] catIds = backCategory.split(",");
                                        if (catIds.length == 3) {
                                            if (StringUtils.isNotEmpty(catIds[0])) {
                                                promotionRangeModel.setBackCategory1Id(Long.parseLong(catIds[0]));
                                            }
                                            if (StringUtils.isNotEmpty(catIds[1])) {
                                                promotionRangeModel.setBackCategory2Id(Long.parseLong(catIds[1]));
                                            }
                                            if (StringUtils.isNotEmpty(catIds[2])) {
                                                promotionRangeModel.setBackCategory3Id(Long.parseLong(catIds[2]));
                                            }
                                        }
                                    }
                                }
                                promotionRangeModel.setStock(getPeriodCount(promotionModel)*input.getStock());//总库存
                                promotionRangeModel.setPerStock(input.getStock());//单场库存
                                promotionRangeModel.setPromotionId(promotionModel.getId());
                                promotionRangeModel.setModifyOper(userId);
                                promotionRangeModel.setModifyOperType(0);// 写死都是内管
                                promotionRangeModel.setGroupClassify(input.getGroupClassify());//团购用
                                return promotionRangeModel;
                            }
                        })).iterator());
                Map<String, Object> updateMap = Maps.newHashMap();
                updateMap.put("rangeList", updateList);
                promotionRangeDao.updateAllForAdmin(updateMap);
            }
            if (selectCodeByPromId.size() > 0) {
                // 待删除的
                Map<String, Object> delete = Maps.newHashMap();
                delete.put("promotionId", promotionModel.getId());
                delete.put("removeCode", selectCodeByPromId);
                promotionRangeDao.logicDelete(delete);
            }

        }
        return result;

    }

    private Response<List<ItemGoodsDetailDto>> findByIds(List<String> ids) {
        Response<List<ItemGoodsDetailDto>> response = new Response<>();
        if (ids == null || ids.size() == 0) {
            response.setResult(Collections.<ItemGoodsDetailDto>emptyList());
            return response;
        }
        try {
            List<ItemModel> itemModelList = itemDao.findNoCode(ids);

            List<String> goodsCodes = Lists.transform(itemModelList, new Function<ItemModel, String>() {
                @Override
                public String apply( ItemModel input) {
                    return input.getGoodsCode();
                }
            });
            List<GoodsModel> goodsList = goodsDao.findGoodsListByItemCodeList(goodsCodes);
            Map<String, GoodsModel> goodsModelHashMap = Maps.uniqueIndex(goodsList, new Function<GoodsModel, String>() {
                @Override
                public String apply( GoodsModel input) {
                    return input.getCode();
                }
            });

            List<ItemGoodsDetailDto> itemModelResult = new ArrayList<>();
            for (ItemModel itemModel : itemModelList) {
                ItemGoodsDetailDto itemGoodsDetailDto = new ItemGoodsDetailDto();
                BeanUtils.copyProperties(itemGoodsDetailDto, itemModel);

                GoodsModel goodsModel = goodsModelHashMap.get(itemModel.getGoodsCode());
                if (goodsModel != null) {
                    itemGoodsDetailDto.setGoodsName(goodsModel.getName());
                    itemGoodsDetailDto.setVendorId(goodsModel.getVendorId());// 供应商id
                    itemGoodsDetailDto.setGoodsType(goodsModel.getGoodsType());// 商品类型（00实物01虚拟02O2O）
                    if (StringUtils.isNotEmpty(goodsModel.getPointsType())) {
                        itemGoodsDetailDto.setPointsType(goodsModel.getPointsType());// 积分类型id
                    }
                    itemGoodsDetailDto.setGoodsBrandName(goodsModel.getGoodsBrandName());// 品牌名称
                    itemGoodsDetailDto.setChannelCc(goodsModel.getChannelCc());// CC状态
                    itemGoodsDetailDto.setChannelIvr(goodsModel.getChannelIvr());// ivr状态
                    // 名称加上属性
                    itemGoodsDetailDto.setGoodsName(goodsModel.getName() + buildItemName(itemModel));
                }
                //调用共通方法，查找单品最高期数
                Integer maxInstallmentNumber = GoodsCheckUtil.getMaxInstallmentNumber(itemModel.getInstallmentNumber());
                itemGoodsDetailDto.setMaxNumber(maxInstallmentNumber.toString());
                BigDecimal newPrice = itemModel.getPrice();
                itemGoodsDetailDto.setPrice(newPrice.divide(new BigDecimal(maxInstallmentNumber), 2, BigDecimal.ROUND_HALF_UP));// 分期价格
                itemModelResult.add(itemGoodsDetailDto);
            }
            response.setResult(itemModelResult);
        } catch (Exception e) {
            log.error("findByCodes.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("findByCodes.item.error");
        }
        return response;
    }

    private String buildItemName(ItemModel itemModel) {
        String itemName = " ";
        if (!isNullOrEmpty(itemModel.getAttributeName1()) && !"无".equals(itemModel.getAttributeName1())) {
            itemName += "/" + itemModel.getAttributeName1();
        }
        if (!isNullOrEmpty(itemModel.getAttributeName2()) && !"无".equals(itemModel.getAttributeName2())) {
            itemName += "/" + itemModel.getAttributeName2();
        }
        return itemName;
    }
    /**
     * 更新审核状态
     */
    public void updateCheckStatus(Integer id, User user, String auditLog, Integer checkStatus) {
        PromotionModel oldPromotion = promotionDao.findById(id);// 数据库中原有数据 主要用来处理审核履历
        //判断当前状态是否允许初审
        if(!Contants.PROMOTION_STATE_2.equals(oldPromotion.getCheckStatus())){
          //不是待初审
            throw new IllegalArgumentException("prom.first.check.already");
        }
        String oldAuditLog = oldPromotion.getAuditLog();// 审核履历
        String checkAuditLog;
        // 生成本次的审核履历
        String newAuditLog = LocalDateTime.now().toString(dateTimeFormat);
        if (checkStatus.equals(3)) {// 已提交(已审批通过) 3
            newAuditLog = newAuditLog + "通过初审";
        } else if (checkStatus.equals(4)) {// 已提交(未审批通过)
            newAuditLog = newAuditLog + "未通过初审";
        }
        newAuditLog = newAuditLog + ",审核意见【" + auditLog + "】，【审核人:" + user.getName() + "】";
        if (StringUtils.isEmpty(oldAuditLog)) {
            // 以前的日志为空
            checkAuditLog = newAuditLog;
        } else {
            // 以前日志不为空 那么 旧日志新日志拼一起 中间用换行符拼接
            checkAuditLog = oldAuditLog + "</br>" + newAuditLog;
        }
        // 2016/04/08 10：30：20 通过初审，审核意见【】，【审核人：内审员1】
        Map<String, Object> checkMap = Maps.newHashMap();
        checkMap.put("auditOper", user.getId());// 审核人 审核日期在mapper中写死
        checkMap.put("id", id);
        checkMap.put("auditLog", checkAuditLog);
        checkMap.put("checkStatus", checkStatus);
        promotionDao.updateCheckStatus(checkMap);
        // 已提交 未通过审批 删除period表
        if (checkStatus.equals(4)) {
            promotionPeriodDao.deletePeriodByPromId(id);
        }
    }
    /**
     * 获取循环任务中一共有几场
     */
    private List<PromotionPeriodModel> getPeriodModels(PromotionModel oldPromotion){
        if(StringUtils.isEmpty(oldPromotion.getLoopType())){
            //不是循环任务
            return Collections.emptyList();
        }
        // 处理循环数据为真实存在的活动
        String loopType=oldPromotion.getLoopType();
        String loopData = oldPromotion.getLoopData();
        Date loopBeginTime1 = oldPromotion.getLoopBeginTime1();
        Date loopEndTime1 = oldPromotion.getLoopEndTime1();

        Date loopBeginTime2 = oldPromotion.getLoopBeginTime2();
        Date loopEndTime2 = oldPromotion.getLoopEndTime2();

        List<String> loop = Arrays.asList(loopData.split(","));// 循环正式数据

        List<LocalDateTime> everyday = Lists.newArrayList();
        LocalDateTime originBeginDateTime=LocalDateTime.fromDateFields(oldPromotion.getBeginDate());
        LocalDateTime originEndDateTime=LocalDateTime.fromDateFields(oldPromotion.getEndDate());
       // 整个活动的开始时间
        LocalDateTime localBeginDateTime = LocalDateTime.fromDateFields(oldPromotion.getBeginDate());
        // 整个活动的结束时间
        LocalDateTime localEndDateTime = LocalDateTime.fromDateFields(oldPromotion.getEndDate());
        // 先把参加活动的所有天数搞出来 然后在判断这些天的时间段在没在当前活动范围内
        if ("d".equals(loopType)) {
            // 按天循环
            // 循环数据中，有多少被包含在这个区间段之内
            // 每日的创建开始与结束日期之间的所有
            // 如果开始时间
            while (localBeginDateTime.isBefore(localEndDateTime)) {
                everyday.add(localBeginDateTime);
                localBeginDateTime = localBeginDateTime.plusDays(1);
            }

        }
        if ("w".equals(loopType)) {
            // 按周循环

            // 循环数据中，有多少被包含在这个区间段之内
            // 每日的创建开始与结束日期之间的所有

            while (localBeginDateTime.isBefore(localEndDateTime)) {
                // 大区间内符合条件的天数加入集合
                if (loop.contains(String.valueOf(localBeginDateTime.getDayOfWeek()))) {
                    everyday.add(localBeginDateTime);
                }
                localBeginDateTime = localBeginDateTime.plusDays(1);
            }

        }
        if ("m".equals(loopType)) {
            // 按月循环
            // 循环数据中，有多少被包含在这个区间段之内
            // 每日的创建开始与结束日期之间的所有

            while (localBeginDateTime.isBefore(localEndDateTime)) {
                // 大区间内符合条件的天数加入集合
                if (loop.contains(String.valueOf(localBeginDateTime.getDayOfMonth()))) {
                    everyday.add(localBeginDateTime);
                }
                localBeginDateTime = localBeginDateTime.plusDays(1);
            }

        }
        List<PromotionPeriodModel> readyToInsert = Lists.newArrayList();
        // 拿到所有符合条件的天数 此时数据只有日期有用 时间都是开始时间后面的时间部分 下面处理这些日期 加上开始时间和结束时间
        PromotionPeriodModel promotionPeriodModel;
        for (LocalDateTime temp : everyday) {
            // 如果时间段一有数据
            if (loopBeginTime1 != null && loopEndTime1 != null) {

                LocalDateTime tempBeginTime = temp
                        .withHourOfDay(LocalDateTime.fromDateFields(loopBeginTime1).getHourOfDay())
                        .withMinuteOfHour(LocalDateTime.fromDateFields(loopBeginTime1).getMinuteOfHour())
                        .withSecondOfMinute(LocalDateTime.fromDateFields(loopBeginTime1).getSecondOfMinute());
                LocalDateTime tempEndTime = temp
                        .withHourOfDay(LocalDateTime.fromDateFields(loopEndTime1).getHourOfDay())
                        .withMinuteOfHour(LocalDateTime.fromDateFields(loopEndTime1).getMinuteOfHour())
                        .withSecondOfMinute(LocalDateTime.fromDateFields(loopEndTime1).getSecondOfMinute());
                if ((tempEndTime.isBefore(originEndDateTime)||tempEndTime.equals(originEndDateTime)) && (tempBeginTime.isAfter(originBeginDateTime)||tempBeginTime.equals(originBeginDateTime))) {
                    // 循环有效 插
                    promotionPeriodModel = new PromotionPeriodModel();
                    promotionPeriodModel.setPromotionId(oldPromotion.getId());
                    promotionPeriodModel.setBeginDate(tempBeginTime.toDate());
                    promotionPeriodModel.setEndDate(tempEndTime.toDate());
                    readyToInsert.add(promotionPeriodModel);
                }
            }
            // 如果时间段2有数据
            if (loopBeginTime2 != null && loopEndTime2 != null) {

                LocalDateTime tempBeginTime = temp
                        .withHourOfDay(LocalDateTime.fromDateFields(loopBeginTime2).getHourOfDay())
                        .withMinuteOfHour(LocalDateTime.fromDateFields(loopBeginTime2).getMinuteOfHour())
                        .withSecondOfMinute(LocalDateTime.fromDateFields(loopBeginTime2).getSecondOfMinute());
                LocalDateTime tempEndTime = temp
                        .withHourOfDay(LocalDateTime.fromDateFields(loopEndTime2).getHourOfDay())
                        .withMinuteOfHour(LocalDateTime.fromDateFields(loopEndTime2).getMinuteOfHour())
                        .withSecondOfMinute(LocalDateTime.fromDateFields(loopEndTime2).getSecondOfMinute());

                if ((tempEndTime.isBefore(originEndDateTime)||tempEndTime.equals(originEndDateTime)) && (tempBeginTime.isAfter(originBeginDateTime)||tempBeginTime.equals(originBeginDateTime))) {
                    // 循环有效 插
                    promotionPeriodModel = new PromotionPeriodModel();
                    promotionPeriodModel.setPromotionId(oldPromotion.getId());
                    promotionPeriodModel.setBeginDate(tempBeginTime.toDate());
                    promotionPeriodModel.setEndDate(tempEndTime.toDate());
                    readyToInsert.add(promotionPeriodModel);
                }
            }

        }
        return readyToInsert;

    }
    private Integer getPeriodCount(PromotionModel promotionModel){
        String loopType = promotionModel.getLoopType();
        if(StringUtils.isEmpty(loopType)){
            return 1;
        }else {
            return getPeriodModels(promotionModel).size();
        }
    }

    /**
     *插入活动场次表
     */
    private void insertPeriod(PromotionModel promotionModel) {
        // 如果审核状态通过了 需要把所有的活动循环数据刷新到活动时间表
        String loopType = promotionModel.getLoopType();// 如果有循环数据 则说明活动范围为循环字段中的一些
        if (StringUtils.isEmpty(loopType)) {
            // 如果没有循环数据 则说明活动的范围就是整个活动开始时间和活动结束时间
            PromotionPeriodModel promotionPeriodModel = new PromotionPeriodModel();
            promotionPeriodModel.setPromotionId(promotionModel.getId());
            promotionPeriodModel.setBeginDate(promotionModel.getBeginDate());
            promotionPeriodModel.setEndDate(promotionModel.getEndDate());
            promotionPeriodDao.insert(promotionPeriodModel);
        } else {
            promotionPeriodDao.insertAll(getPeriodModels(promotionModel));
        }
    }

    /**
     * 复审通过 没有单品审核的情况，审核的是活动 要通过全通过，要拒绝全拒绝
     *
     */
    public void doubleCheckPromotion(Integer promotionId, String auditLog, Integer status, User user) {
        // 当前活动的所有信息
        PromotionModel promotionModel = promotionDao.findById(promotionId);
        //活动开始时间已过 并且为通过 不允许审核
        if(LocalDateTime.fromDateFields(promotionModel.getBeginDate()).isBefore(LocalDateTime.now())&&Integer.valueOf(7).equals(status)){
         throw new IllegalArgumentException("prom.double.check.pass.by");
        }
        checkArgument(ImmutableSet.of(3, 5).contains(promotionModel.getCheckStatus()), "prom.check.status.change.error");
        // 构建活动本身的更新信息
        Map<String, Object> promotionMap = Maps.newHashMap();
        promotionMap.put("id", promotionId);
        promotionMap.put("checkStatus", status);
        promotionMap.put("promotionId", promotionId);
        promotionMap.put("auditOper", user.getId());
        String log;
        if (status.equals(7)) {// 通过复审
            // 通过
            log = MoreObjects.firstNonNull(promotionModel.getAuditLog(), "")
                    + LocalDateTime.now().toString(dateTimeFormat) + "通过审核，审核意见:【" + auditLog + "】," + "审核员:【"
                    + user.getName() + "】";
            promotionMap.put("auditLog", log);
        } else {
            // 拒绝
            log = MoreObjects.firstNonNull(promotionModel.getAuditLog(), "")
                    + LocalDateTime.now().toString(dateTimeFormat) + "拒绝审核，审核意见:【" + auditLog + "】," + "审核员:【"
                    + user.getName() + "】";
            promotionMap.put("auditLog", log);
        }
        // 添加一个活动的审核日志并置状态
        promotionDao.updateCheckStatus(promotionMap);
        Map<String, Object> rangeMap = Maps.newHashMap();
        rangeMap.put("promotionId", promotionId);
        if (status.equals(7)) {
            // 通过复审就把他下面所有的单品状态变成审核成功
            // 并把该活动下关联的所有单品的审核

            rangeMap.put("checkStatus", "1");// 已通过
        } else {
            rangeMap.put("checkStatus", "0");// 保持待审核状态不改变
        }
        rangeMap.put("auditOper", user.getId());
        promotionRangeDao.updateStatusByPromotion(rangeMap);
        // 如果未通过复审 那么删除period表中已经同步成功的数据
        if (status.equals(6)) {
            promotionPeriodDao.deletePeriodByPromId(promotionId);
        }

    }

    public void doubleCheckRange(Map<String, Object> rangeMap, Map<String, Object> promotionMap) {
        // 添加一个审核日志 无审核意见
        promotionRangeDao.updateCheckStatus(rangeMap);
        // 计算出主活动状态并改变
        promotionDao.offAndDelete(promotionMap);
    }

    public int updatePromotionStock(List<Map<String, String>> promItemMap) {
        int ret = 0;
        for (Map<String, String> map : promItemMap) {
            String promId = map.get("promId");
            String itemCode = map.get("itemCode");
            String itemCount = map.get("itemCount");
            Map<String, Object> param = Maps.newHashMap();
            param.put("promotionId", Integer.valueOf(promId));
            param.put("selectCode", itemCode);
            param.put("itemCount", Integer.valueOf(itemCount));
            ret = promotionRangeDao.updatePromotionStock(param);
            if (ret <= 0) {
                throw new RuntimeException("活动库存更新失败");
            }
        }
        return ret;
    }

    public int updateRollbackPromotionStock(List<Map<String, Object>> promItemMap) {
        int ret = 0;
        for (Map<String, Object> map : promItemMap) {
            String promId = (String) map.get("promId");
            //TODO 如果活动Id是空 说明是旧订单迁移过来的 不回滚库存
            if(StringUtils.isEmpty(promId)){
                continue;
            }
            String itemCode = (String) map.get("itemCode");
            Integer itemCount = (Integer) map.get("itemCount");
            Map<String, Object> param = Maps.newHashMap();
            param.put("promotionId", Integer.valueOf(promId));
            param.put("selectCode", itemCode);
            param.put("itemCount", itemCount);
            ret = promotionRangeDao.updateRollbackPromotionStock(param);
            if (ret <= 0) {
                throw new RuntimeException("活动库存回滚失败");
            }
        }
        return ret;
    }


    public Integer offAndDelete(Map<String, Object> map) {
        return promotionDao.offAndDelete(map);
    }

    public Integer updateOffLine(Map<String, Object> map) {
        return promotionDao.updateOffLine(map);
    }

    public Integer updateSaleCount(Map<String, Object> map) {
        return promotionRangeDao.updateSaleCount(map);
    }

}
