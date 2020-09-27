package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.EscapeUtil;
import cn.com.cgbchina.item.dao.GroupClassifyRedisDao;
import cn.com.cgbchina.item.dao.PromotionDao;
import cn.com.cgbchina.item.dao.PromotionPeriodDao;
import cn.com.cgbchina.item.dao.PromotionRangeDao;
import cn.com.cgbchina.item.dao.PromotionRedisDao;
import cn.com.cgbchina.item.dao.PromotionVendorDao;
import cn.com.cgbchina.item.dto.ItemMakeDto;
import cn.com.cgbchina.item.indexer.ItemRealTimeIndexer;
import cn.com.cgbchina.item.manager.PromotionManager;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.GroupClassify;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.dto.AdminPromotionAddDto;
import cn.com.cgbchina.item.dto.AdminPromotionDetailDto;
import cn.com.cgbchina.item.dto.AdminPromotionQueryDto;
import cn.com.cgbchina.item.dto.AdminPromotionResultDto;
import cn.com.cgbchina.item.dto.AdminPromotionStatisticsDto;
import cn.com.cgbchina.item.dto.AdminPromotionUpdateDto;
import cn.com.cgbchina.item.dto.DuliCheckTimeDto;
import cn.com.cgbchina.item.dto.FullCutDto;
import cn.com.cgbchina.item.dto.PromItemDto;
import cn.com.cgbchina.item.dto.RangeStatusDto;
import cn.com.cgbchina.item.dto.VendorIdNameDto;
import cn.com.cgbchina.item.model.PromotionModel;
import cn.com.cgbchina.item.model.PromotionPayWayModel;
import cn.com.cgbchina.item.model.PromotionPeriodModel;
import cn.com.cgbchina.item.model.PromotionRangeModel;
import cn.com.cgbchina.item.model.PromotionVendorModel;
import cn.com.cgbchina.promotion.service.EspActRemindService;
import cn.com.cgbchina.scheduler.model.TaskScheduled;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Function;
import com.google.common.base.MoreObjects;
import com.google.common.base.Throwables;
import com.google.common.collect.*;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.jms.mq.QueueSender;
import com.spirit.search.Pair;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.LocalDateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import static cn.com.cgbchina.item.model.GoodsModel.Status.ON_SHELF;

@Service
@Slf4j
@SuppressWarnings("unchecked")
public class PromotionServiceImpl implements PromotionService {
    private final JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
    private final DateTimeFormatter dateTimeFormatCal = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
    private final DateTimeFormatter dateOnlyFormatter = DateTimeFormat.forPattern("yyyy-MM-dd");
    private final Map<Integer, String> typeNameMap = ImmutableMap.<Integer, String>builder().put(10, "折扣")
            .put(20, "满减").put(30, "秒杀").put(40, "团购").put(50, "荷兰拍").build();
    private final ImmutableMap<String, String> sourceNameMap = ImmutableMap.<String, String>builder().put("00", "商城")
            .put("01", "CC").put("02", "IVR").put("03", "手机商城").put("04", "短信").put("05", "微信广发银行").put("06", "微信广发信用卡")
            .put("09", "APP").build();
    @Resource
    private PromotionDao promotionDao;
    @Resource
    private PromotionRangeDao promotionRangeDao;
    @Resource
    private PromotionManager promotionManager;
    @Resource
    private PromotionVendorDao promotionVendorDao;
    @Resource
    private VendorService vendorService;
    @Resource
    private ItemService itemService;
    @Resource
    private GoodsService goodsService;
    @Resource
    private BrandService brandService;
    @Resource
    private VendorPromotionService vendorPromotionService;
    @Resource
    private PromotionPayWayService promotionPayWayService;
    @Resource
    private PromotionPeriodDao promotionPeriodDao;
    @Resource
    private PromotionRedisDao promotionRedisDao;
    @Resource
    private ItemRealTimeIndexer itemRealTimeIndexer;
    @Resource
    private EspActRemindService espActRemindService;
    @Resource
    private GroupClassifyRedisDao groupClassifyRedisDao;


    @Autowired
    @Qualifier("queueSender")
    private QueueSender queueSender;

    @Override
    public Response<Pager<PromotionModel>> adminPromotionPagination(@Param("pageNo") Integer pageNo,
                                                                    @Param("size") Integer size, @Param("id") String id, @Param("shortName") String shortName,
                                                                    @Param("promType") Integer promType, @Param("state") Integer state,
                                                                    @Param("createOperType") Integer createOperType, @Param("beginDate") String beginDate,
                                                                    @Param("endDate") String endDate, @Param("sourceId") String sourceId, @Param("tabType") String tabType) {

        Response<Pager<PromotionModel>> response = new Response<>();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        Map<String, Object> queryMap = Maps.newHashMap();
        queryMap.put("offset", pageInfo.getOffset());
        queryMap.put("limit", pageInfo.getLimit());
        if (StringUtils.isNotEmpty(id)) {
            queryMap.put("id", id);
        }
        if (StringUtils.isNotEmpty(shortName)) {
            queryMap.put("shortName", EscapeUtil.allLikeStr(shortName));
        }
        if (promType != null) {
            queryMap.put("promType", promType);
        }
        if (state != null) {
            queryMap.put("checkStatus", state);
        }
        if (createOperType != null) {
            queryMap.put("createOperType", createOperType);
        }
        if (StringUtils.isNotEmpty(beginDate)) {
            DateTime beginDateTime = dateOnlyFormatter.parseDateTime(beginDate);
            queryMap.put("beginDate", beginDateTime.toDate());
        }
        if (StringUtils.isNotEmpty(endDate)) {
            // 因为传来的参数格式为yyyy-MM-dd，所以转换后的时间为00:00:00
            DateTime endDateTime = dateOnlyFormatter.parseDateTime(endDate);
            // 为了能查到当天的记录，结束时间设置为第二天的0点
            queryMap.put("endDate", endDateTime.plusDays(1).toDate());
        }
        if (StringUtils.isNotEmpty(beginDate) && StringUtils.isNotEmpty(endDate)) {
            // 开始日期与结束日期都存在的话 如果结束日期在开始日期前面 返回空
            DateTime beginDateTime = dateOnlyFormatter.parseDateTime(beginDate);
            DateTime endDateTime = dateOnlyFormatter.parseDateTime(endDate);
            if (beginDateTime.isAfter(endDateTime)) {
                response.setResult(Pager.empty(PromotionModel.class));
                return response;
            }
        }
        if (StringUtils.isNotEmpty(sourceId)) {
            queryMap.put("sourceId", EscapeUtil.allLikeStr(sourceId));
        }
        if (StringUtils.isNotEmpty(tabType)) {
            // 0:所有 1:编辑中 2:待开始 3:进行中 4:已结束
            queryMap.put("tabType", tabType);
        }

        try {
            Pager<PromotionModel> promotionModelPager = promotionDao.findByAdminPage(queryMap);
            response.setResult(promotionModelPager);
        } catch (Exception e) {
            log.error("failed to query promotion{}", Throwables.getStackTraceAsString(e));
            response.setError("query.error");
        }
        return response;
    }

    /**
     * 创建活动（内管、供应商共用）
     *
     * @param createOperType       创建人类型(0 内管，1 供应商）
     * @param adminPromotionAddDto 活动信息
     * @param user                 用户信息
     */
    @Override
    public Response<String> addAdminPromotion(String createOperType, AdminPromotionAddDto adminPromotionAddDto,
                                              User user) {
        Response<String> response = new Response<>();
        String managerResult = "";
        try {
            // 循环任务合理性判断
            if (StringUtils.isNotEmpty(adminPromotionAddDto.getLoopType())) {
                List<DuliCheckTimeDto> loopJob = getLoopJob(adminPromotionAddDto.getLoopType(),
                        adminPromotionAddDto.getLoopData(), adminPromotionAddDto.getLoopBeginTime1(),
                        adminPromotionAddDto.getLoopEndTime1(), adminPromotionAddDto.getLoopBeginTime2(),
                        adminPromotionAddDto.getLoopEndTime2(), adminPromotionAddDto.getBeginDate(),
                        adminPromotionAddDto.getEndDate());
                if (loopJob.size() == 0) {
                    response.setError("prom.loop.time.check.error");
                    return response;
                }
            }

            PromotionModel promotionModel = new PromotionModel();
            if (StringUtils.isNotEmpty(adminPromotionAddDto.getId())) {
                promotionModel.setId(Integer.parseInt(adminPromotionAddDto.getId()));// geshuo:修改后保存时,已经存在id
            }
            promotionModel.setCreateOperType(Integer.valueOf(createOperType));
            String mallSystemCode = "yg";
            promotionModel.setOrdertypeId(mallSystemCode);// 通过此接口创建的都是广发商城
            promotionModel.setIsValid(1);// 默认正常状态
            promotionModel.setCreateOper(user.getId());
            promotionModel.setName(adminPromotionAddDto.getName());// 活动名称
            promotionModel.setShortName(adminPromotionAddDto.getShortName());// 简称
            promotionModel.setPromType(adminPromotionAddDto.getPromType());// 设置活动类型
            promotionModel.setDescription(adminPromotionAddDto.getDescription());// 设置描述=
            Date beginDate = adminPromotionAddDto.getBeginDate();// 活动开始时间
            Date endDate = adminPromotionAddDto.getEndDate();// 活动结束时间
            DateTime beginDateTime = new DateTime(beginDate);// 开始时间包装
            DateTime endDateTime = new DateTime(endDate);// 结束时间包装

            // 开始时间不得晚于结束时间
            if (beginDateTime.isAfter(endDateTime)) {
                response.setError("prom.begin.after.end.error");
                return response;
            }
            promotionModel.setBeginDate(beginDate);// 开始
            promotionModel.setEndDate(endDate);
            if (adminPromotionAddDto.getPromType().equals(10) || adminPromotionAddDto.getPromType().equals(20)) {
                if (StringUtils.isNotEmpty(createOperType) && "0".equals(createOperType)) {// 创建者类型 0内管 1供应商
                    DateTime beginEntryDateTime = dateTimeFormatCal
                            .parseDateTime(adminPromotionAddDto.getBeginEntryDate());// 报名开始时间
                    DateTime endEntryDateTime = dateTimeFormatCal.parseDateTime(adminPromotionAddDto.getEndEntryDate());// 报名结束时间
                    // 活动报名开始时间必须晚于现在
                    if (!beginEntryDateTime.isAfterNow()) {
                        response.setError("prom.beginTimeEntry.check.error");
                        return response;
                    }
                    // 开始报名时间在结束报名时间之后
                    if (beginEntryDateTime.isAfter(endEntryDateTime)) {
                        response.setError("prom.entry.time.after.error");
                        return response;
                    }
                    // 报名结束时间不得晚于活动开始时间
                    if (endEntryDateTime.isAfter(beginDateTime)) {
                        response.setError("prom.begin.entry.after.error");
                        return response;
                    }
                    promotionModel.setBeginEntryDate(beginEntryDateTime.toDate());
                    promotionModel.setEndEntryDate(endEntryDateTime.toDate());
                }
            }

            // 优惠规则校验
            switch (adminPromotionAddDto.getPromType()) {
                case (10): {
                    // 折扣情况
                    BigDecimal ruleDiscountRate = adminPromotionAddDto.getRuleDiscountRate();// 折扣比例
                    if (ruleDiscountRate.compareTo(BigDecimal.ZERO) != 1
                            || ruleDiscountRate.compareTo(BigDecimal.ONE) != -1) {
                        response.setError("prom.rule.discount.rate.error");
                        return response;
                    }
                    promotionModel.setRuleDiscountRate(ruleDiscountRate);
                    Integer ruleLimitBuyCount = adminPromotionAddDto.getRuleLimitBuyCount();// 限购数量
                    if (ruleLimitBuyCount != null && ruleLimitBuyCount <= 0) {
                        response.setError("prom.rule.limit.buy.count.error");
                        return response;
                    }
                    promotionModel.setRuleLimitBuyCount(ruleLimitBuyCount);
                    Integer ruleLimitBuyType = adminPromotionAddDto.getRuleLimitBuyType();// 限购种类，0 单日内限购，1 整个活动限购
                    if (ruleLimitBuyType != 0 && ruleLimitBuyType != 1) {
                        response.setError("prom.rule.limit.buy.type.error");
                        return response;
                    }
                    promotionModel.setRuleLimitBuyType(ruleLimitBuyType);
                    promotionModel.setIsSignup(1);
                    break;
                }
                case (20): {
                    // 满减
                    // 最多十条的满减优惠
                    String fullCutJson = adminPromotionAddDto.getFullCut();
                    if (StringUtils.isEmpty(fullCutJson)) {
                        response.setError("insert.error");
                        return response;
                    }
                    List<FullCutDto> fullCutDtoList = jsonMapper.fromJson(fullCutJson,
                            jsonMapper.createCollectionType(List.class, FullCutDto.class));
                    // 反射处理set方法 按顺序填入满减规则
                    for (int i = 0; i < fullCutDtoList.size(); i++) {
                        Method setFullMethod = promotionModel.getClass().getMethod("setRuleMinPay" + (i + 1),
                                Integer.class);
                        setFullMethod.invoke(promotionModel, fullCutDtoList.get(i).getFull());
                        Method setCutMethod = promotionModel.getClass().getMethod("setRuleFee" + (i + 1), Integer.class);
                        setCutMethod.invoke(promotionModel, fullCutDtoList.get(i).getCut());
                    }
                    // 满减需要报名
                    promotionModel.setIsSignup(1);
                    break;
                }
                case (30):
                case (40): {
                    // 秒杀、团购一样
                    Integer ruleLimitBuyCount = adminPromotionAddDto.getRuleLimitBuyCount();// 限购数量
                    if (ruleLimitBuyCount != null && ruleLimitBuyCount <= 0) {
                        response.setError("prom.rule.limit.buy.count.error");
                        return response;
                    }
                    promotionModel.setRuleLimitBuyCount(adminPromotionAddDto.getRuleLimitBuyCount());
                    Integer ruleLimitBuyType = adminPromotionAddDto.getRuleLimitBuyType();// 限购种类，0 单日内限购，1 整个活动限购
                    if (ruleLimitBuyType != 0 && ruleLimitBuyType != 1) {
                        response.setError("prom.rule.limit.buy.type.error");
                        return response;
                    }
                    promotionModel.setRuleLimitBuyType(adminPromotionAddDto.getRuleLimitBuyType());
                    promotionModel.setIsSignup(0);
                    break;
                }

                case (50): {
                    Integer ruleFrequency = adminPromotionAddDto.getRuleFrequency();// 降价频率
                    if (ruleFrequency <= 0) {
                        response.setError("prom.rule.frequency");
                        return response;
                    }
                    promotionModel.setRuleFrequency(ruleFrequency);

                    Integer ruleLimitBuyCount = adminPromotionAddDto.getRuleLimitBuyCount();// 限购数量
                    if (ruleLimitBuyCount != null && ruleLimitBuyCount <= 0) {
                        response.setError("prom.rule.limit.buy.count.error");
                        return response;
                    }
                    promotionModel.setRuleLimitBuyCount(ruleLimitBuyCount);
                    Integer ruleLimitBuyType = adminPromotionAddDto.getRuleLimitBuyType();// 限购种类，0 单日内限购，1 整个活动限购
                    if (ruleLimitBuyType != 0 && ruleLimitBuyType != 1) {
                        response.setError("prom.rule.limit.buy.type.error");
                        return response;
                    }
                    promotionModel.setRuleLimitBuyType(ruleLimitBuyType);

                    promotionModel.setRuleLimitTicket(adminPromotionAddDto.getRuleLimitTicket());
                    // 可拍次数
                    promotionModel.setRuleGroupCount(adminPromotionAddDto.getRuleGroupCount());// 可拍次数
                    promotionModel.setIsSignup(0);
                    break;
                }
            }

            // 循环任务check
            // 非空 表示有循环任务
            if (StringUtils.isNotEmpty(adminPromotionAddDto.getLoopType())) {
                // 类型只有三种 d 按天循环 w按星期循环 m按月循环
                if (!"d".equalsIgnoreCase(adminPromotionAddDto.getLoopType())
                        && !"w".equalsIgnoreCase(adminPromotionAddDto.getLoopType())
                        && !"m".equalsIgnoreCase(adminPromotionAddDto.getLoopType())) {
                    response.setError("prom.loop.type.error");
                    return response;
                }
                promotionModel.setLoopType(adminPromotionAddDto.getLoopType());
                // 循环任务判断成功准备插入
                promotionModel.setLoopType(adminPromotionAddDto.getLoopType());
                promotionModel.setLoopData(adminPromotionAddDto.getLoopData());
                promotionModel.setLoopBeginTime1(adminPromotionAddDto.getLoopBeginTime1());
                promotionModel.setLoopBeginTime2(adminPromotionAddDto.getLoopBeginTime2());
                promotionModel.setLoopEndTime1(adminPromotionAddDto.getLoopEndTime1());
                promotionModel.setLoopEndTime2(adminPromotionAddDto.getLoopEndTime2());
            }
            // 只有荷兰拍同一时间段不允许存在两个 其他活动类型不对时间段重复性进行校验
            if (adminPromotionAddDto.getPromType().equals(50)) {
                // 判断当前活动是否与其他活动存在时间段冲突
                Boolean timeDuliCheck = checkDuliTime(adminPromotionAddDto.getBeginDate(),
                        adminPromotionAddDto.getEndDate(), adminPromotionAddDto.getPromType(),
                        adminPromotionAddDto.getLoopType(), adminPromotionAddDto.getLoopData(),
                        adminPromotionAddDto.getLoopBeginTime1(), adminPromotionAddDto.getLoopEndTime1(),
                        adminPromotionAddDto.getLoopBeginTime2(), adminPromotionAddDto.getLoopEndTime2(), null);
                if (timeDuliCheck) {
                    response.setError("prom.duliCheck.error");
                    return response;
                }
            }
            // 销售渠道WEB端已处理，此处不需要后续处理
            promotionModel.setSourceId(adminPromotionAddDto.getSourceId());

            Integer checkStatus;
            if (StringUtils.isNotEmpty(createOperType) && "0".equals(createOperType)) {// 创建者类型 0内管 1供应商
                promotionModel.setCheckStatus(adminPromotionAddDto.getCheckStatus());
                // 平台选品处理
                managerResult = promotionManager.insertAdminPromotion(promotionModel, adminPromotionAddDto.getRange());
            } else if (StringUtils.isNotEmpty(createOperType) && "1".equals(createOperType)) {// 供应商创建活动
                // 保存
                String saveType = adminPromotionAddDto.getSaveType();
                if ("0".equals(saveType)) {
                    checkStatus = 0;// 添加(未提交审批) 0
                } else { // 提交
                    checkStatus = 5;// 待复审 5 供应商创建活动 跳过初审阶段
                }
                if (promotionModel.getId() == null) {
                    // 不需要报名
                    promotionModel.setIsSignup(Contants.PROMOTION_IS_SIGNUP_0);
                    // 创建人类型供应商
                    promotionModel.setCreateOperType(Contants.PROMOTION_CREATE_OPER_TYPE_1);
                } else {
                    promotionModel.setModifyOper(user.getId());
                    promotionModel.setModifyOperType(Contants.PROMOTION_CREATE_OPER_TYPE_1);
                }
                // 供应商选品处理
                promotionModel.setCheckStatus(checkStatus);// 放入处理完成的活动状态
                // 供应商ID
                String vendorId = user.getVendorId();
                promotionManager.changePromotionForVendor(promotionModel, adminPromotionAddDto.getRange(), saveType,
                        vendorId);
            }
            response.setResult(managerResult);
        } catch (IllegalArgumentException e) {
            log.error("fail to create promotion {}", Throwables.getStackTraceAsString(e));
            response.setError(e.getMessage());

        } catch (Exception e) {
            log.error("fail to create promotion {}", Throwables.getStackTraceAsString(e));
            response.setError("create.error");
        }
        return response;
    }

    /**
     * 检查这个活动是否有重复的时间段 有允许添加
     *
     * @return true 有重复不允许添加 false 没有时间交集 允许添加
     */
    private Boolean checkDuliTime(Date beginDate, Date endDate, Integer promType, String loopType, String loopData,
                                  Date loopBeginTime1, Date loopEndTime1, Date loopBeginTime2, Date loopEndTime2, Integer promtionUpdateId) {
        Boolean flag = Boolean.FALSE;
        // 判断现在添加的活动是否有效 是否有重复的同一个类型的活动在相同的活动范围内 有的话不允许加入
        Map<String, Object> duplicateMap = Maps.newHashMap();
        duplicateMap.put("startTime", beginDate);
        duplicateMap.put("endTime", endDate);
        duplicateMap.put("promType", promType);
        List<Integer> avaliableList = promotionDao.findAvaliable(duplicateMap);
        // 结果集数量如果大于零 那么说明了活动的大时间段有交集
        if (avaliableList.size() > 0) {
            // 如果活动id不为空 说明是更新 更新的时候不能跟自己的时间段进行重复校验
            if (promtionUpdateId != null) {
                Iterator<Integer> iterator = avaliableList.iterator();
                while (iterator.hasNext()) {
                    if (promtionUpdateId.equals(iterator.next())) {
                        iterator.remove();// 移除
                    }
                }
                // 集合处理完成后 如果一条数据也没剩 就不会有时间重复
                if (avaliableList.size() == 0) {
                    return Boolean.FALSE;
                }
            }

            // 大时间段有交集 并不意味着这个活动就有交集
            // 拿到所有展开的小时间段
            // 如果这个活动没有循环任务 那么大时间有交集
            if (StringUtils.isEmpty(loopType)) {
                // 判断这个时间有没有跟任何展开的小时间有交集
                Map<String, Object> singleMap = Maps.newHashMap();
                List<DuliCheckTimeDto> singleList = Lists.newArrayList();
                DuliCheckTimeDto duliCheckTimeDto = new DuliCheckTimeDto();
                duliCheckTimeDto.setBeginDate(beginDate);
                duliCheckTimeDto.setEndDate(endDate);
                singleList.add(duliCheckTimeDto);
                singleMap.put("timeList", singleList);
                singleMap.put("promIdList", avaliableList);
                Integer singleDuliCheck = promotionPeriodDao.findDuliCheck(singleMap);
                // 查到有重复
                if (singleDuliCheck != null) {
                    flag = Boolean.TRUE;
                }
            } else {
                // 大时间段有交集 还有循环任务的话 那么判断新建活动的大时间段与已存
                // 小时间段是否有交集 有的话 不允许建立
                // 新建的活动本身是循环任务 那么
                Map<String, Object> circleMap = Maps.newHashMap();
                circleMap.put("promIdList", avaliableList);
                List<DuliCheckTimeDto> loopJobList = getLoopJob(loopType, loopData, loopBeginTime1, loopEndTime1,
                        loopBeginTime2, loopEndTime2, beginDate, endDate);
                circleMap.put("timeList", loopJobList);
                Integer duliCheck = promotionPeriodDao.findDuliCheck(circleMap);
                if (duliCheck != null) {
                    // 查出来重复的了 那么不允许插入
                    flag = Boolean.TRUE;
                }
            }

        }
        return flag;
    }

    /**
     * 得到新添加的活动的具体的时间循环时间段
     */
    private List<DuliCheckTimeDto> getLoopJob(String loopType, String loopData, Date loopBeginTime1, Date loopEndTime1,
                                              Date loopBeginTime2, Date loopEndTime2, Date beginDate, Date endDate) {
        // 处理循环数据为真实存在的活动
        List<String> loop = Arrays.asList(loopData.split(","));// 循环正式数据
        List<LocalDateTime> everyday = Lists.newArrayList();// 只有日期
        LocalDateTime originBeginDateTime=LocalDateTime.fromDateFields(beginDate);
        LocalDateTime originEndDateTime=LocalDateTime.fromDateFields(endDate);
        // 整个活动的开始时间
        LocalDateTime localBeginDateTime = LocalDateTime.fromDateFields(beginDate);
        // 整个活动的结束时间
        LocalDateTime localEndDateTime = LocalDateTime.fromDateFields(endDate);
        // 先把参加活动的所有天数出来 然后在判断这些天的时间段在没在当前活动范围内
        if ("d".equalsIgnoreCase(loopType)) {
            // 按天循环
            // LocalDateTime localBeginTime = LocalDateTime.fromDateFields(oldPromotion.getBeginDate());
            // 循环数据中，有多少被包含在这个区间段之内
            // 每日的创建开始与结束日期之间的所有
            // 如果开始时间
            while (localBeginDateTime.isBefore(localEndDateTime)) {
                everyday.add(localBeginDateTime);
                localBeginDateTime = localBeginDateTime.plusDays(1);
            }
        }
        if ("w".equalsIgnoreCase(loopType)) {
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
        if ("m".equalsIgnoreCase(loopType)) {
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
        List<DuliCheckTimeDto> readyToInsert = Lists.newArrayList();
        // 拿到所有符合条件的天数 此时数据只有日期有用 时间都是开始时间后面的时间部分 下面处理这些日期 加上开始时间和结束时间
        DuliCheckTimeDto duliCheckTimeDto ;
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
                    duliCheckTimeDto = new DuliCheckTimeDto();
                    duliCheckTimeDto.setBeginDate(tempBeginTime.toDate());
                    duliCheckTimeDto.setEndDate(tempEndTime.toDate());
                    readyToInsert.add(duliCheckTimeDto);
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
                    duliCheckTimeDto = new DuliCheckTimeDto();
                    duliCheckTimeDto.setBeginDate(tempBeginTime.toDate());
                    duliCheckTimeDto.setEndDate(tempEndTime.toDate());
                    readyToInsert.add(duliCheckTimeDto);
                }
            }
        }
        return readyToInsert;
    }

    /**
     * 活动更新
     */
    @Override
    public Response<String> updateAdminPromotion(AdminPromotionUpdateDto adminPromotionUpdateDto, User user) {
        Response<String> response = new Response<>();
        String result;
        try {
            // 当前活动编辑前的旧对象
            PromotionModel oldPromotion = promotionDao.findById(adminPromotionUpdateDto.getId());
            if (oldPromotion == null
                    || !ImmutableSet.of(0, 1, 4, 6, 11, 12, 13).contains(oldPromotion.getCheckStatus())) {
                // 当前活动状态不允许编辑
                response.setError("promotion.edit.refuse");
                return response;
            }
            // 构建活动更新对象
            PromotionModel promotionModel = new PromotionModel();
            promotionModel.setId(adminPromotionUpdateDto.getId());// 活动
            promotionModel.setModifyOperType(0);// 修改类型写死 都是内管
            promotionModel.setModifyOper(user.getId());// 修改人类型
            promotionModel.setName(adminPromotionUpdateDto.getName());// 活动名称
            promotionModel.setShortName(adminPromotionUpdateDto.getShortName());// 简称
            promotionModel.setPromType(adminPromotionUpdateDto.getPromType());// 设置活动类型 活动类型不让改
            promotionModel.setDescription(adminPromotionUpdateDto.getDescription());// 设置描述=
            Date beginDate = adminPromotionUpdateDto.getBeginDate();// 活动开始时间
            Date endDate = adminPromotionUpdateDto.getEndDate();// 活动结束时间
            DateTime beginDateTime = new DateTime(beginDate);// 开始时间包装
            DateTime endDateTime = new DateTime(endDate);// 结束时间包装
            // DateTime now = DateTime.now();// 当前时间

            // 开始时间不得晚于结束时间
            if (beginDateTime.isAfter(endDateTime)) {
                response.setError("prom.begin.after.end.error");
                return response;
            }
            promotionModel.setBeginDate(beginDate);
            promotionModel.setEndDate(endDate);
            if (adminPromotionUpdateDto.getPromType().equals(10) || adminPromotionUpdateDto.getPromType().equals(20)) {
                DateTime beginEntryDateTime = dateTimeFormatCal
                        .parseDateTime(adminPromotionUpdateDto.getBeginEntryDate());// 报名开始时间
                DateTime endEntryDateTime = dateTimeFormatCal.parseDateTime(adminPromotionUpdateDto.getEndEntryDate());// 报名结束时间
                // 活动报名开始时间必须晚于现在
                if (!beginEntryDateTime.isAfterNow()) {
                    response.setError("prom.beginTimeEntry.check.error");
                    return response;
                }
                // 开始报名时间在结束报名时间之后
                if (beginEntryDateTime.isAfter(endEntryDateTime)) {
                    response.setError("prom.entry.time.after.error");
                    return response;
                }
                // 报名结束时间不得早于活动开始时间
                if (endEntryDateTime.isAfter(beginDateTime)) {
                    response.setError("prom.begin.entry.after.error");
                    return response;
                }

                promotionModel.setBeginEntryDate(beginEntryDateTime.toDate());
                promotionModel.setEndEntryDate(endEntryDateTime.toDate());
            }
            // 优惠规则校验
            switch (adminPromotionUpdateDto.getPromType()) {
                case (10): {
                    // 折扣情况
                    BigDecimal ruleDiscountRate = adminPromotionUpdateDto.getRuleDiscountRate();// 折扣比例
                    if (ruleDiscountRate.compareTo(BigDecimal.ZERO) != 1
                            || ruleDiscountRate.compareTo(BigDecimal.ONE) != -1) {
                        response.setError("prom.rule.discount.rate.error");
                        return response;
                    }
                    promotionModel.setRuleDiscountRate(adminPromotionUpdateDto.getRuleDiscountRate());
                    Integer ruleLimitBuyCount = adminPromotionUpdateDto.getRuleLimitBuyCount();// 限购数量
                    if (ruleLimitBuyCount != null && ruleLimitBuyCount <= 0) {
                        response.setError("prom.rule.limit.buy.count.error");
                        return response;
                    }
                    promotionModel.setRuleLimitBuyCount(adminPromotionUpdateDto.getRuleLimitBuyCount());
                    Integer ruleLimitBuyType = adminPromotionUpdateDto.getRuleLimitBuyType();// 限购种类，0 单日内限购，1 整个活动限购
                    if (ruleLimitBuyType != 0 && ruleLimitBuyType != 1) {
                        response.setError("prom.rule.limit.buy.type.error");
                        return response;
                    }
                    promotionModel.setRuleLimitBuyType(adminPromotionUpdateDto.getRuleLimitBuyType());
                    break;
                }
                case (20): {
                    // 满减
                    // 最多十条的满减优惠
                    String fullCutJson = adminPromotionUpdateDto.getFullCut();
                    if (StringUtils.isEmpty(fullCutJson)) {
                        response.setError("insert.error");
                        return response;
                    }
                    List<FullCutDto> fullCutDtoList = jsonMapper.fromJson(fullCutJson,
                            jsonMapper.createCollectionType(List.class, FullCutDto.class));
                    // 反射处理set方法 按顺序填入满减规则
                    for (int i = 0; i < fullCutDtoList.size(); i++) {
                        Method setFullMethod = promotionModel.getClass().getMethod("setRuleMinPay" + (i + 1),
                                Integer.class);
                        setFullMethod.invoke(promotionModel, fullCutDtoList.get(i).getFull());
                        Method setCutMethod = promotionModel.getClass().getMethod("setRuleFee" + (i + 1), Integer.class);
                        setCutMethod.invoke(promotionModel, fullCutDtoList.get(i).getCut());
                    }
                    // 满减需要报名
                    promotionModel.setIsSignup(1);
                    break;
                }
                case (30):
                case (40): {
                    // 秒杀和团购一样
                    Integer ruleLimitBuyCount = adminPromotionUpdateDto.getRuleLimitBuyCount();// 限购数量
                    if (ruleLimitBuyCount != null && ruleLimitBuyCount <= 0) {
                        response.setError("prom.rule.limit.buy.count.error");
                        return response;
                    }
                    promotionModel.setRuleLimitBuyCount(adminPromotionUpdateDto.getRuleLimitBuyCount());
                    Integer ruleLimitBuyType = adminPromotionUpdateDto.getRuleLimitBuyType();// 限购种类，0 单日内限购，1 整个活动限购
                    if (ruleLimitBuyType != 0 && ruleLimitBuyType != 1) {
                        response.setError("prom.rule.limit.buy.type.error");
                        return response;
                    }
                    promotionModel.setRuleLimitBuyType(adminPromotionUpdateDto.getRuleLimitBuyType());
                    break;
                }

                case (50): {
                    Integer ruleFrequency = adminPromotionUpdateDto.getRuleFrequency();// 降价频率
                    if (ruleFrequency <= 0) {
                        response.setError("prom.rule.frequency");
                        return response;
                    }
                    promotionModel.setRuleFrequency(adminPromotionUpdateDto.getRuleFrequency());

                    Integer ruleLimitBuyCount = adminPromotionUpdateDto.getRuleLimitBuyCount();// 限购数量
                    if (ruleLimitBuyCount != null && ruleLimitBuyCount <= 0) {
                        response.setError("prom.rule.limit.buy.count.error");
                        return response;
                    }
                    promotionModel.setRuleLimitBuyCount(adminPromotionUpdateDto.getRuleLimitBuyCount());
                    Integer ruleLimitBuyType = adminPromotionUpdateDto.getRuleLimitBuyType();// 限购种类，0 单日内限购，1 整个活动限购
                    if (ruleLimitBuyType != 0 && ruleLimitBuyType != 1) {
                        response.setError("prom.rule.limit.buy.type.error");
                        return response;
                    }
                    promotionModel.setRuleLimitBuyType(adminPromotionUpdateDto.getRuleLimitBuyType());

                    promotionModel.setRuleLimitTicket(adminPromotionUpdateDto.getRuleLimitTicket());// 可拍次数
                    promotionModel.setRuleGroupCount(adminPromotionUpdateDto.getRuleGroupCount());// 可拍次数
                    break;
                }
            }

            // 循环任务check
            // 不是空说明有循环任务
            if (StringUtils.isNotEmpty(adminPromotionUpdateDto.getLoopType())) {
                // 类型只有三种 d 按天循环 w按星期循环 m按月循环
                if (!"d".equalsIgnoreCase(adminPromotionUpdateDto.getLoopType())
                        && !"w".equalsIgnoreCase(adminPromotionUpdateDto.getLoopType())
                        && !"m".equalsIgnoreCase(adminPromotionUpdateDto.getLoopType())) {
                    response.setError("prom.loop.type.error");
                    return response;
                }
                promotionModel.setLoopType(adminPromotionUpdateDto.getLoopType());
                // 循环任务时间先后
                if (adminPromotionUpdateDto.getLoopBeginTime1() != null
                        && adminPromotionUpdateDto.getLoopEndTime1() != null) {
                    if (adminPromotionUpdateDto.getLoopBeginTime1().after(adminPromotionUpdateDto.getLoopEndTime1())) {
                        // 开始时间晚于结束时间 报错
                        response.setError("prom.loop.time.later.error");
                        return response;
                    }
                }
                if (adminPromotionUpdateDto.getLoopBeginTime2() != null
                        && adminPromotionUpdateDto.getLoopEndTime2() != null) {
                    if (adminPromotionUpdateDto.getLoopBeginTime2().after(adminPromotionUpdateDto.getLoopEndTime2())) {
                        // 开始时间晚于结束时间 报错
                        response.setError("prom.loop.time.before.error");
                        return response;
                    }
                }
                // 循环任务合理性判断
                if (StringUtils.isNotEmpty(adminPromotionUpdateDto.getLoopType())) {
                    List<DuliCheckTimeDto> loopJob = getLoopJob(adminPromotionUpdateDto.getLoopType(),
                            adminPromotionUpdateDto.getLoopData(), adminPromotionUpdateDto.getLoopBeginTime1(),
                            adminPromotionUpdateDto.getLoopEndTime1(), adminPromotionUpdateDto.getLoopBeginTime2(),
                            adminPromotionUpdateDto.getLoopEndTime2(), adminPromotionUpdateDto.getBeginDate(),
                            adminPromotionUpdateDto.getEndDate());
                    if (loopJob.size() == 0) {
                        response.setError("prom.loop.time.check.error");
                        return response;
                    }
                }
                // 其他业务合理性不做判断
                // 循环任务判断成功准备插入
                promotionModel.setLoopType(adminPromotionUpdateDto.getLoopType());
                promotionModel.setLoopData(adminPromotionUpdateDto.getLoopData());
                promotionModel.setLoopBeginTime1(adminPromotionUpdateDto.getLoopBeginTime1());
                promotionModel.setLoopBeginTime2(adminPromotionUpdateDto.getLoopBeginTime2());
                promotionModel.setLoopEndTime1(adminPromotionUpdateDto.getLoopEndTime1());
                promotionModel.setLoopEndTime2(adminPromotionUpdateDto.getLoopEndTime2());
            }





            // 秒杀不check时间重复 允许同一时间段存在两个秒杀活动 manager中check单品
            if (adminPromotionUpdateDto.getPromType().equals(50)) {
                // 判断当前活动是否与其他活动存在时间段冲突
                Boolean timeDuliCheck = checkDuliTime(adminPromotionUpdateDto.getBeginDate(),
                        adminPromotionUpdateDto.getEndDate(), adminPromotionUpdateDto.getPromType(),
                        adminPromotionUpdateDto.getLoopType(), adminPromotionUpdateDto.getLoopData(),
                        adminPromotionUpdateDto.getLoopBeginTime1(), adminPromotionUpdateDto.getLoopEndTime1(),
                        adminPromotionUpdateDto.getLoopBeginTime2(), adminPromotionUpdateDto.getLoopEndTime2(),
                        adminPromotionUpdateDto.getId());
                if (timeDuliCheck) {
                    response.setError("prom.duliCheck.error");
                    return response;
                }
            }
            // 销售渠道前台已处理 后台直接拿
            promotionModel.setSourceId(adminPromotionUpdateDto.getSourceId());
            promotionModel.setOrdertypeId("YG");
            // 处理活动范
            promotionModel.setCheckStatus(adminPromotionUpdateDto.getCheckStatus());// 设置状态，前台已经处理好
            result = promotionManager.updateAdminPromotion(promotionModel, adminPromotionUpdateDto.getRange());
            response.setResult(result);

        }catch (IllegalArgumentException e){
            response.setError(e.getMessage());
        } catch (Exception e) {
            log.error("fail to create promotion{}", Throwables.getStackTraceAsString(e));
            response.setError("update.error");
        }
        return response;
    }
    /**
     * 审核状态 用于初审
     */
    @Override
    public Response<Boolean> updateCheckStatus(Integer id, User user, String auditLog, Integer checkStatus) {
        Response<Boolean> response = new Response<>();
        try {

            promotionManager.updateCheckStatus(id, user, auditLog, checkStatus);
            // 如果初审通过 为报名结束时间建立消息队列
            if (Integer.valueOf(3).equals(checkStatus)) {
                PromotionModel prom = promotionDao.findById(id);
                LocalDateTime endEntryDate = LocalDateTime.fromDateFields(prom.getEndEntryDate());// 报名结束时间
                // 创建任务
                TaskScheduled taskScheduled = new TaskScheduled();
                taskScheduled.setTaskGroup("cn.com.cgbchina.batch.service.PromotionSyncService");
                taskScheduled.setTaskName("syncDBtoRedis");
                taskScheduled.setDesc("同步活动db到redis");
                taskScheduled.setTaskType("promotion");
                taskScheduled.setPromotionId(String.valueOf(id));
                taskScheduled.setPromotionStartDate(endEntryDate.toDate());
                taskScheduled.setStatus("1");
                //参数计算
                String yesterday = endEntryDate.minusDays(1).toString(DateHelper.YYYYMMDD);//昨天
                String[] args = {yesterday};
                taskScheduled.setParamArgs(args);
                queueSender.send("shop.cgb.scheduler.notify", taskScheduled);
            }

            response.setResult(Boolean.TRUE);
        }catch (IllegalArgumentException e){
            response.setError(e.getMessage());
        } catch (Exception e) {
            log.error("fail to update promotion;cause by{}", Throwables.getStackTraceAsString(e));
            response.setError("update.error");
        }
        return response;
    }

    /**
     * 活动删除
     */
    @Override
    public Response<Boolean> offAndDelete(Integer promotionId, Integer checkStatus) {
        Response<Boolean> response = new Response<>();
        try {
            Map<String, Object> map = Maps.newHashMap();
            map.put("checkStatus", checkStatus);
            map.put("id", promotionId);
            promotionManager.offAndDelete(map);
            //活动删除取消短信通知
            Map<String,Object> param=Maps.newHashMap();
            param.put("actId",promotionId);
            param.put("delFlag",1);
            espActRemindService.deleteRemindByParams(param);
            response.setResult(Boolean.TRUE);
        } catch (Exception e) {
            log.error("fail to update promotion offAndDelete;cause by:{}：", Throwables.getStackTraceAsString(e));
            response.setError("update.error");
        }
        return response;
    }

    /**
     * 查看详情
     *
     */

    @Override
    public Response<AdminPromotionDetailDto> findDetailById(Integer promotionId) {
        Response<AdminPromotionDetailDto> response = new Response<>();
        try {
            PromotionModel promotionModel = promotionDao.findById(promotionId);// 活动本身数据
            AdminPromotionDetailDto adminPromotionDetailDto = new AdminPromotionDetailDto();
            // 活动范围分两种，一种是那供应商 一种是拿单品
            if (promotionModel.getPromType() == 10 || promotionModel.getPromType() == 20) {
                List<PromotionVendorModel> promotionVendors = promotionVendorDao.findByPromotion(promotionId);
                // 如果查不到的话 说明是所有供应商都参加的状态
                if (promotionVendors.size() == 0) {
                    adminPromotionDetailDto.setVendorIdNameDtos(Collections.<VendorIdNameDto>emptyList());
                } else {
                    // 有供应商的话 查询所有供应商
                    // 得到查询id集合
                    List<String> vendorIds = Lists.newArrayList();
                    for (PromotionVendorModel promotionVendorModel : promotionVendors) {

                        vendorIds.add(promotionVendorModel.getVendorId());
                    }

                    Response<List<VendorInfoModel>> vendorInfoResult = vendorService.findByVendorIds(vendorIds);
                    if (!vendorInfoResult.isSuccess()) {
                        log.error("fail to excute interface vendorService findBy VendorIds",
                                vendorInfoResult.getError());
                        response.setError("query,error");
                        return response;
                    }
                    List<VendorInfoModel> vendorInfoModels = vendorInfoResult.getResult();
                    List<VendorIdNameDto> list = BeanMapper.mapList(vendorInfoModels,
                            VendorIdNameDto.class);
                    adminPromotionDetailDto.setVendorIdNameDtos(list);

                }
                // 得到当前活动所有供应商已经报名的单品 供审核用
                Map<String, Object> promo = Maps.newHashMap();
                promo.put("promotionId", promotionId);
                promo.put("offset", 0);
                promo.put("limit", 10);
                // 因为这里只有查看详情页显示第一个默认的十条数据 第二页不通过此接口获取 所以写死只返回十条即可
                Response<List<PromItemDto>> promRangeByParam = vendorPromotionService.findPromRangeByParam(promo);
                adminPromotionDetailDto.setPromItemDtos(promRangeByParam.getResult());

            } else if (promotionModel.getPromType() == 30 || promotionModel.getPromType() == 40
                    || promotionModel.getPromType() == 50) {

                List<PromotionRangeModel> promotionRangeModels = promotionRangeDao.findByPromId(promotionId);// 活动选品数据
                //获取团购分类
                List<GroupClassify> groupClassifieList = groupClassifyRedisDao.allGroupClassify();
                adminPromotionDetailDto.setGroupClassifies(groupClassifieList);
                ImmutableMap<Long, GroupClassify> longGroupClassifyImmutableMap = Maps.uniqueIndex(groupClassifieList, new Function<GroupClassify, Long>() {
                    @Override
                    public Long apply(GroupClassify groupClassify) {
                        return groupClassify.getId();
                    }
                });
                // 通过选品数据 把选品对应的单品详情查出来
                List<PromItemDto> promItemList = Lists.newArrayList();
                if (promotionRangeModels != null) {
                    for (PromotionRangeModel model : promotionRangeModels) {
                        PromItemDto dto = new PromItemDto();
                        dto.setId(model.getId()); // 活动选取范围ID
                        dto.setItemCode(model.getSelectCode()); // 选品编码
                        dto.setGoodsName(model.getSelectName()); // 选品名称
                        dto.setPrice(model.getPrice()); // 选品价格
                        dto.setStock(model.getStock()); // 总库存
                        dto.setAuditLog(model.getAuditLog()); // 审核日志
                        dto.setCostBy(model.getCostBy());// 费用承担方
                        dto.setSort(String.valueOf(model.getSeq()));// 排序
                        dto.setCouponEnable(model.getCouponEnable());// 是否使用优惠卷
                        dto.setLevelPrice(model.getLevelPrice());// 阶梯之售价
                        dto.setStartPrice(model.getStartPrice());// 起拍价
                        dto.setMinPrice(model.getMinPrice());// 最低价
                        dto.setFeeRange(model.getFeeRange());// 降价金额
                        dto.setPerStock(model.getPerStock());//单场库存
                        dto.setGroupClassify(model.getGroupClassify());//如果是团购 此项有值
                        GroupClassify groupClassify = longGroupClassifyImmutableMap.get(model.getGroupClassify());
                        if(groupClassify!=null){
                        dto.setGroupClassifyName(groupClassify.getName());//团购类别名称
                             }
                        if (StringUtils.isNotEmpty(model.getVendorId())) {
                            Response<VendorInfoDto> vendorInfoDtoResponse = vendorService.findById(model.getVendorId());// 得到供应商信息
                            if (!vendorInfoDtoResponse.isSuccess()) {
                                response.setError("find.detail.error");
                                return response;
                            }
                            dto.setVendor(vendorInfoDtoResponse.getResult().getSimpleName());// 供应商简称 用于前台显示
                        }
                        ItemModel itemModel = itemService.findItemDetailByCode(model.getSelectCode());
                        if (itemModel != null) {
                            Response<GoodsModel> goodsModelResponse = goodsService.findById(itemModel.getGoodsCode());
                            GoodsModel goodsModel = goodsModelResponse.getResult();
                            StringBuilder backCategoryIds = new StringBuilder();
                            if (goodsModel != null) {
                                // 后台类目
                                Response<List<Pair>> pairResponse = goodsService.findCategoryByGoodsCode(itemModel.getGoodsCode());
                                if (!pairResponse.isSuccess()) {
                                    log.error("findDetailById.findCategoryByGoodsCode.error{}", pairResponse.getError());
                                    response.setError(pairResponse.getError());
                                    return response;
                                }
                                List<Pair> pairList = pairResponse.getResult();
                                int size = pairList.size();
                                Pair pair;
                                // 第一级是所有分类，不需要显示
                                for (int i = 1; i < size; i++) {
                                    pair = pairList.get(i);
                                    switch (i) {
                                        case 1:
                                            dto.setBackCategory1Name(pair.getName());
                                            backCategoryIds.append(pair.getId().toString());
                                            break;
                                        case 2:
                                            dto.setBackCategory2Name(pair.getName());
                                            backCategoryIds.append(",");
                                            backCategoryIds.append(pair.getId().toString());
                                            break;
                                        case 3:
                                            dto.setBackCategory3Name(pair.getName());
                                            backCategoryIds.append(",");
                                            backCategoryIds.append(pair.getId().toString());
                                            break;
                                        case 4:
                                            dto.setBackCategory4Name(pair.getName());
                                            backCategoryIds.append(",");
                                            backCategoryIds.append(pair.getId().toString());
                                            break;
                                        default:
                                            break;
                                    }
                                }

                                // 品牌
                                GoodsBrandModel goodsBrandModel = brandService
                                        .findBrandInfoById(goodsModel.getGoodsBrandId()).getResult();
                                dto.setGoodsBrandName(goodsBrandModel.getBrandName());
                                dto.setBackCategory(backCategoryIds.toString());// 设置类目Id
                            }
                        }

                        promItemList.add(dto);
                    }
                }

                adminPromotionDetailDto.setPromItemDtos(promItemList);

            } else {
                response.setError("promotion.type.error");
                return response;
            }
            // 处理一些编号类的字段 便于前台显示
            AdminPromotionResultDto adminPromotionResultDto = new AdminPromotionResultDto();
            BeanMapper.copy(promotionModel, adminPromotionResultDto);

            if (promotionModel.getPromType() == 10) {
                // 格式化折扣比例
                adminPromotionResultDto.setRuleDiscountRateFormat(promotionModel.getRuleDiscountRate().toString());
            }
            if (promotionModel.getPromType() == 20) {
                // 格式化满减数据 把十个字段变成一个List
                List<Integer> ruleMinPays = Lists.newArrayList();
                List<Integer> ruleFees = Lists.newArrayList();
                int seq = 1;
                Method getRuleMinPay = promotionModel.getClass().getMethod("getRuleMinPay" + seq);// ruleMinPay
                Method getRuleFee = promotionModel.getClass().getMethod("getRuleFee" + seq);
                while (getRuleMinPay.invoke(promotionModel) != null) {
                    ruleMinPays.add((Integer) getRuleMinPay.invoke(promotionModel));
                    ruleFees.add((Integer) getRuleFee.invoke(promotionModel));
                    seq++;
                    if (seq > 10) {
                        break;
                    } else {
                        getRuleMinPay = promotionModel.getClass().getMethod("getRuleMinPay" + seq);
                        getRuleFee = promotionModel.getClass().getMethod("getRuleFee" + seq);
                    }

                }
                adminPromotionResultDto.setRuleMinPays(ruleMinPays);
                adminPromotionResultDto.setRuleFees(ruleFees);

            }

            // 处理渠道数据
            String[] sourceIds = promotionModel.getSourceId().split("\\|\\|");
            // 渠道数据结果
            StringBuilder sourceResult = new StringBuilder();
            for (String temp : Arrays.copyOfRange(sourceIds, 1, sourceIds.length)) {
                sourceResult.append(sourceNameMap.get(temp)).append(",");
            }
            adminPromotionResultDto.setSourceNames(sourceResult.substring(0, sourceResult.length() - 1));// 渠道数据处理
            // 处理循环任务数据
            if (promotionModel.getLoopType() != null) {
                String loopJobFormat = "";
                if (Contants.PROMOTION_LOOP_TYPE_D.equals(promotionModel.getLoopType())) {
                    loopJobFormat = "每天";
                } else if (Contants.PROMOTION_LOOP_TYPE_W.equals(promotionModel.getLoopType())) {
                    loopJobFormat = "每周";
                } else if (Contants.PROMOTION_LOOP_TYPE_M.equals(promotionModel.getLoopType())) {
                    loopJobFormat = "每月";
                }
                if (promotionModel.getLoopBeginTime1() != null && promotionModel.getLoopEndTime1() != null) {
                    DateFormat.getTimeInstance().format(promotionModel.getLoopBeginTime1());
                    loopJobFormat = loopJobFormat + "（"
                            + DateFormat.getTimeInstance().format(promotionModel.getLoopBeginTime1()) + "-"
                            + DateFormat.getTimeInstance().format(promotionModel.getLoopEndTime1().getTime()) + "）";
                }

                if (promotionModel.getLoopBeginTime2() != null && promotionModel.getLoopEndTime2() != null) {
                    loopJobFormat = loopJobFormat + "（"
                            + DateFormat.getTimeInstance().format(promotionModel.getLoopBeginTime2()) + "-"
                            + DateFormat.getTimeInstance().format(promotionModel.getLoopEndTime2()) + "）";
                }
                adminPromotionResultDto.setLoopJobFormat(loopJobFormat);
            }
            // 处理活动类型
            adminPromotionResultDto
                    .setPromTypeName(MoreObjects.firstNonNull(typeNameMap.get(promotionModel.getPromType()), "类型有误"));
            if (promotionModel.getCreateOperType() == 0) {
                adminPromotionResultDto.setCreateOperTypeName("内管");
            } else {
                adminPromotionResultDto.setCreateOperTypeName("供应商");
            }
            adminPromotionDetailDto.setAdminPromotionResultDto(adminPromotionResultDto);

            response.setResult(adminPromotionDetailDto);

        } catch (IllegalArgumentException e) {
            log.error("fail to find detail promotion Exception:{}", Throwables.getStackTraceAsString(e));
            response.setError(e.getMessage());
        } catch (Exception e) {
            log.error("fail to find detail promotion Exception:{}", Throwables.getStackTraceAsString(e));
            response.setError("query.error");
        }
        return response;

    }

    /**
     * 复审活动 一次一个活动 要过都过 要不过都不过
     *
     * @param status      7通过复审 6 未通过复审
     */
    @Override
    public Response<Boolean> doubleCheckPromotion(Integer promotionId, String auditLog, Integer status, User user) {
        Response<Boolean> response = new Response<>();
        try {
            promotionManager.doubleCheckPromotion(promotionId, auditLog, status, user);
            // 获取当前活动结果
            // 复审完活动 启动批处理执行db同步到redis 异步处理
            // 复审成功发送mq
            if (Integer.valueOf(7).equals(status)) {
                queueSender.send(DateTime.now().minusDays(1).toString(DateHelper.YYYYMMDD));
                List<PromotionPeriodModel> promotionPeriodModels = promotionPeriodDao.findPeriodByPromIds(Lists.newArrayList(promotionId));
                for (PromotionPeriodModel promotionPeriodModel : promotionPeriodModels) {
                    // 开始
                    TaskScheduled taskScheduled = new TaskScheduled();
                    taskScheduled.setTaskGroup("cn.com.cgbchina.item.service.PromotionService");
                    taskScheduled.setTaskName("syncPromoDataToIndexStart");
                    taskScheduled.setDesc("同步商品的活动信息到索引");
                    taskScheduled.setTaskType("promotion");
                    taskScheduled.setPromotionId(String.valueOf(promotionId));

                    taskScheduled.setPromotionStartDate(new DateTime(promotionPeriodModel.getBeginDate()).plusSeconds(1).toDate());
                    taskScheduled.setStatus("1");
                    String[] args = {promotionId.toString(), "02"};
                    taskScheduled.setParamArgs(args);
                    taskScheduled.setPeriodId(String.valueOf(promotionPeriodModel.getId()));//加入场次id区别
                    queueSender.send("shop.cgb.scheduler.notify", taskScheduled);

                    TaskScheduled taskScheduledEnd = new TaskScheduled();
                    taskScheduledEnd.setTaskGroup("cn.com.cgbchina.item.service.PromotionService");
                    taskScheduledEnd.setTaskName("syncPromoDataToIndexEnd");
                    taskScheduledEnd.setDesc("同步商品的活动信息到索引");
                    taskScheduledEnd.setTaskType("promotion");
                    taskScheduledEnd.setPromotionId(String.valueOf(promotionId));
                    taskScheduledEnd.setPromotionStartDate(new DateTime(promotionPeriodModel.getEndDate()).plusSeconds(1).toDate());
                    taskScheduledEnd.setStatus("1");
                    String[] argsEnd = {promotionId.toString(), "-1"};
                    taskScheduledEnd.setParamArgs(argsEnd);
                    taskScheduledEnd.setPeriodId(String.valueOf(promotionPeriodModel.getId()));
                    queueSender.send("shop.cgb.scheduler.notify", taskScheduledEnd);
                }
            }
            response.setResult(Boolean.TRUE);
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
        } catch (Exception e) {
            log.error("fail to check promotion cause by{}", Throwables.getStackTraceAsString(e));
            response.setError("promotion.check.error");
        }

        return response;
    }

    /**
     * 复审单品 一次一条 只适用于有供应商报名的时候 内管审核供应商下报名上来的单品 每审核一条单品 这种情况 每审核一条单品 都需要根据range计算出主活动表应该有什么样的状态 并改之
     *
     * @param id          通过的是那条单品
     */
    @Override
    public Response<Boolean> doubleCheckRange(Integer id, Integer promotionId, String auditLog, Integer status,
                                              User user, String itemId) {
        Response<Boolean> response = new Response<>();
        try {
            PromotionModel promotionModel = promotionDao.findById(promotionId);
            LocalDateTime endEntryDate = LocalDateTime.fromDateFields(promotionModel.getEndEntryDate());
            if (endEntryDate.isBefore(LocalDateTime.now())) {
                throw new IllegalArgumentException("prom.entry.end.date.passby");
            }

            // 活动支付方式
            PromotionPayWayModel promotionPayWayModel = new PromotionPayWayModel();
            Integer promType = promotionModel.getPromType();
            PromotionRangeModel promotionRangeModel = promotionRangeDao.findById(id);
            //判断当前商品的状态是否是待审核
            if(!"0".equals(promotionRangeModel.getCheckStatus())){
                throw new IllegalArgumentException("prom.item.check.already");
            }
            // 只有折扣跟满减两种情况
            promotionPayWayModel.setPromId(promotionModel.getId().toString());
            promotionPayWayModel.setGoodsId(itemId);
            promotionPayWayModel.setPromType(promotionModel.getPromType());
                // 活动类型为折扣 要乘以折扣比例
            if (Integer.valueOf(10).equals(promType)) {
                promotionPayWayModel.setGoodsPrice(
                        promotionRangeModel.getPrice().multiply(promotionModel.getRuleDiscountRate()));
            } else {
                promotionPayWayModel.setGoodsPrice(promotionRangeModel.getPrice());
            }
            List<PromotionPayWayModel> rangeList = Lists.newArrayList();
            rangeList.add(promotionPayWayModel);
            promotionPayWayService.createPromotionPayWay(rangeList, user);

            // 把当前本条单品的审核状态改了
            Map<String, Object> rangeMap = Maps.newHashMap();
            rangeMap.put("checkStatus", status);
            rangeMap.put("id", id);
            rangeMap.put("promotionId", promotionId);
            rangeMap.put("auditOper", user.getId());
            if (status == 1) {
                // 通过
                rangeMap.put("auditLog",
                        MoreObjects.firstNonNull(promotionRangeModel.getAuditLog(), "")
                                + LocalDateTime.now().toString(dateTimeFormatCal) + "审核通过，审核意见:【】," + "审核员:【"
                                + user.getName() + "】");
            } else {
                // 拒绝
                rangeMap.put("auditLog",
                        MoreObjects.firstNonNull(promotionRangeModel.getAuditLog(), "")
                                + LocalDateTime.now().toString(dateTimeFormatCal) + "审核拒绝，审核意见:【"
                                + MoreObjects.firstNonNull(auditLog, "") + "】," + "审核员:【" + user.getName() + "】");
            }
            // 把总活动的状态算出来 改了
            RangeStatusDto rangeStatusDto = promotionRangeDao.rangeStatus(promotionId);
            Map<String, Object> promotionMap = Maps.newHashMap();
            promotionMap.put("id", promotionId);
            // 如果此次操作是通过
            if (status == 1) {
                // 这条单品如果通过了 那么主活动只能有两种状态
                // 全部通过复审
                if (rangeStatusDto.getAlready() + 1 == rangeStatusDto.getAll()) {
                    // 如果已经通过复审的数量 加上现在通过复审的一条等于活动商品总数
                    promotionMap.put("checkStatus", 7);

                } else { // 部分通过复审
                    // 其他都是部分通过复审
                    promotionMap.put("checkStatus", 8);
                }
            } else {
                // status 2 这条单品被拒绝了
                // 这个参数的值不是1 就是2

                if (rangeStatusDto.getAlready() > 0) {
                    // 已经有审核通过的了 部分通过
                    promotionMap.put("checkStatus", 8);

                } else if (rangeStatusDto.getRefuse() + 1 == rangeStatusDto.getAll()) {
                    // 当前活动下的单品 已经被全部拒绝了 那么置活动主状态为复审未通过
                    promotionMap.put("checkStatus", 6);
                } else {
                    // 其他中情况 都处于待复审状态 只有活动刚开始报名 并且审核的前些条商品都被拒了 才有可能保持待复审状态
                    // 走过了带复审 就无法通过任何操作回到带复审了
                    promotionMap.put("checkStatus", 5);
                }

            }

            promotionManager.doubleCheckRange(rangeMap, promotionMap);
            response.setSuccess(Boolean.TRUE);
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
        } catch (Exception e) {
            log.error("fail to find promotion range,cause by{}", Throwables.getStackTraceAsString(e));
            response.setError("promotion.item.check.error");
        }
        return response;
    }

    // 查询接口
    @Override
    public Response<Pager<PromItemDto>> findRanges(Integer promotionId, Integer checkStatus, String vendorName,
                                                   String itemName) {
        Response<Pager<PromItemDto>> response = new Response<>();
        try {
            Map<String, Object> queryMap = Maps.newHashMap();

            if (StringUtils.isNotEmpty(vendorName)) {

                Response<List<String>> vendorServiceIdByName = vendorService.findIdByName(vendorName);
                // 空集合不放
                if (vendorServiceIdByName.getResult().size() > 0) {
                    queryMap.put("vendorIds", vendorServiceIdByName.getResult());
                } else {
                    // 空集合就返回空
                    response.setResult(Pager.empty(PromItemDto.class));
                    return response;
                }
            }
            if (checkStatus != null) {
                queryMap.put("checkStatus", checkStatus);
            }
            if (StringUtils.isNotEmpty(itemName)) {
                queryMap.put("selectName", itemName);
            }
            queryMap.put("promotionId", promotionId);
            Integer resultCount = promotionRangeDao.promRangeByParamCount(queryMap);
            if (resultCount == 0) {
                response.setResult(Pager.empty(PromItemDto.class));
                return response;
            }
            Response<List<PromItemDto>> promRangeByParam = vendorPromotionService.findPromRangeByParam(queryMap);
            if (!promRangeByParam.isSuccess()) {
                response.setError("query.error");
                return response;
            }
            response.setResult(new Pager<>(Long.valueOf(resultCount), promRangeByParam.getResult()));
        } catch (Exception e) {
            log.error("fail to find range {}", Throwables.getStackTraceAsString(e));
            response.setError("query.error");
        }
        return response;
    }

    @Override
    public Response<List<PromotionModel>> findPromotionByRange(Map<String, Object> map) {
        Response<List<PromotionModel>> response = new Response<>();
        try {
            // 当前单品code参加的所有活动
            List<Integer> promotionIds = promotionRangeDao.findPromotionId(map);
            // 拿到所有活动
            List<PromotionModel> promotionByIds = promotionDao.findPromotionByIds(promotionIds);
            response.setResult(promotionByIds);
        } catch (Exception e) {
            log.error("fail to find promotion by itemId cause by{}", Throwables.getStackTraceAsString(e));
            response.setError("query.error");
        }
        return response;
    }

    @Override
    public Response<Pager<AdminPromotionQueryDto>> findCheckManage(@Param("id") String id,
                                                                   @Param("shortName") String shortName, @Param("promType") String promType,
                                                                   @Param("checkStatus") String checkStatus, @Param("createOperType") String createOperType,
                                                                   @Param("beginDate") String beginDate, @Param("endDate") String endDate, @Param("pageNo") Integer pageNo,
                                                                   @Param("size") Integer size, String sourceId) {
        Response<Pager<AdminPromotionQueryDto>> response = new Response<>();
        // 只有内管添加的折扣和满减有初审 其他情况没有初审
        // 所以初审页面写死两个查询条件 一个是创建类型为内管 一个活动类型为折扣和满减
        Map<String, Object> queryMap = Maps.newHashMap();
        if (StringUtils.isNotEmpty(id)) {
            queryMap.put("id", id);
        }
        if (StringUtils.isNotEmpty(shortName)) {
            queryMap.put("shortName", EscapeUtil.allLikeStr(shortName));
        }
        if (StringUtils.isNotEmpty(promType)) {
            queryMap.put("promType", promType);
        }
        if (StringUtils.isNotEmpty(checkStatus)) {
            queryMap.put("checkStatus", checkStatus);
        }
        if (StringUtils.isNotEmpty(beginDate)) {
            queryMap.put("beginDate", beginDate);
        }
        if (StringUtils.isNotEmpty(endDate)) {
            queryMap.put("endDate", endDate);
        }
        if (StringUtils.isNotEmpty(sourceId)) {
            queryMap.put("sourceId", EscapeUtil.allLikeStr(sourceId));
        }
        PageInfo pageInfo = new PageInfo(pageNo, size);
        queryMap.put("offset", pageInfo.getOffset());
        queryMap.put("limit", pageInfo.getLimit());
        try {
            Integer resultCount = promotionDao.checkManagerCount(queryMap);
            if (resultCount == 0) {
                response.setResult(Pager.empty(AdminPromotionQueryDto.class));
                return response;
            }
            List<PromotionModel> checkManager = promotionDao.findCheckManager(queryMap);
            List<AdminPromotionQueryDto> list = BeanMapper.mapList(checkManager, AdminPromotionQueryDto.class);
            response.setResult(new Pager<>(Long.valueOf(resultCount), list));
        } catch (Exception e) {
            log.error("fail to query,cause by{}", Throwables.getStackTraceAsString(e));
            response.setError("query.error");
        }
        return response;
    }

    @Override
    public Response<Pager<AdminPromotionQueryDto>> findDoubleCheck(@Param("id") String id,
                                                                   @Param("shortName") String shortName, @Param("promType") String promType,
                                                                   @Param("createOperType") String createOperType, @Param("beginDate") String beginDate,
                                                                   @Param("endDate") String endDate, @Param("doubleCheckStatus") String checkStatus,
                                                                   @Param("pageNo") Integer pageNo, @Param("size") Integer size, @Param("sourceId") String sourceId) {

        Response<Pager<AdminPromotionQueryDto>> response = new Response<>();
        Map<String, Object> queryMap = Maps.newHashMap();
        if (StringUtils.isNotEmpty(id)) {
            queryMap.put("id", id);
        }
        if (StringUtils.isNotEmpty(shortName)) {
            queryMap.put("shortName", EscapeUtil.allLikeStr(shortName));
        }
        if (StringUtils.isNotEmpty(promType)) {
            queryMap.put("promType", promType);
        }
        if (StringUtils.isNotEmpty(checkStatus)) {
            queryMap.put("checkStatus", checkStatus);
        }
        if (StringUtils.isNotEmpty(createOperType)) {
            queryMap.put("createOperType", createOperType);
        }
        if (StringUtils.isNotEmpty(beginDate)) {
            queryMap.put("beginDate", beginDate);
        }
        if (StringUtils.isNotEmpty(endDate)) {
            queryMap.put("endDate", endDate);
        }
        if (StringUtils.isNotEmpty(sourceId)) {
            queryMap.put("sourceId", EscapeUtil.allLikeStr(sourceId));
        }
        PageInfo pageInfo = new PageInfo(pageNo, size);
        queryMap.put("offset", pageInfo.getOffset());
        queryMap.put("limit", pageInfo.getLimit());
        try {
            Integer resultCount = promotionDao.doubleCheckManagerCount(queryMap);
            if (resultCount == 0) {
                response.setResult(Pager.empty(AdminPromotionQueryDto.class));
                return response;
            }

            List<PromotionModel> doubleCheckManager = promotionDao.findDoubleCheckManager(queryMap);
            // 格式化返回数据
            List<AdminPromotionQueryDto> list = BeanMapper.mapList(doubleCheckManager,
                    AdminPromotionQueryDto.class);
            response.setResult(new Pager<>(Long.valueOf(resultCount), list));
        } catch (Exception e) {
            log.error("fail to query promotion {}", Throwables.getStackTraceAsString(e));
            response.setError("query.error");
        }
        return response;

    }

    @Override
    public Response<Boolean> updateOffLine(Integer promotionId, Integer status, User user) {
        Response<Boolean> response = new Response<>();
        try {
            // 更新主db
            Map<String, Object> map = Maps.newHashMap();
            map.put("checkStatus", status);
            map.put("id", promotionId);
            map.put("modifyOper", user.getId());
            promotionManager.updateOffLine(map);
            // 如果活动已经同步到redis中了 需要把redis中的同步完成的活动干掉哪怕正在进行
            promotionRedisDao.offLineProm(promotionId);
            this.syncPromoDataToIndexEnd(promotionId.toString(), "02");
            response.setResult(Boolean.TRUE);
        } catch (Exception e) {
            log.error("下线活动失败 活动id={},cause by{}", promotionId, Throwables.getStackTraceAsString(e));
            response.setError("update.error");
        }
        return response;
    }

    @Override
    public Response<Pager<AdminPromotionStatisticsDto>> findPromStatistics(@Param("promId") Integer id,
                                                                           @Param("itemCode") String selectCode, @Param("itemName") String selectName, @Param("pageNo") Integer pageNo,
                                                                           @Param("size") Integer size) {
        Response<Pager<AdminPromotionStatisticsDto>> response = Response.newResponse();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        try {
            // 根据活动id查出活动基本信息
            PromotionModel promotionModel = promotionDao.findPromStatistics(id);
            // 构建单品查询条件map
            Map<String, Object> rangeQueryMap = Maps.newHashMap();
            if (StringUtils.isNotEmpty(selectCode)) {
                rangeQueryMap.put("selectCode", selectCode);
            }
            if (StringUtils.isNotEmpty(selectName)) {
                rangeQueryMap.put("selectName", selectName);
            }
            rangeQueryMap.put("promId", id);// 活动id
            rangeQueryMap.put("offset", pageInfo.getOffset());
            rangeQueryMap.put("limit", pageInfo.getLimit());
            Pager<PromotionRangeModel> rangeForStatistics = promotionRangeDao.findRangeForStatistics(rangeQueryMap);
            List<AdminPromotionStatisticsDto> resultStaticsDtos = Lists.newArrayList();
            List<PromotionRangeModel> data = rangeForStatistics.getData();
            for (PromotionRangeModel promotionRangeModel : data) {
                AdminPromotionStatisticsDto adminPromotionStatisticsDto = new AdminPromotionStatisticsDto();
                // 根据活动id查出活动基本信息
                // 活动基本信息放入结果集
                adminPromotionStatisticsDto.setId(promotionModel.getId());// 活动主键id
                adminPromotionStatisticsDto.setSelectCode(promotionRangeModel.getSelectCode());// 单品名称
                adminPromotionStatisticsDto.setSelectName(promotionRangeModel.getSelectName());// 单品名称
                adminPromotionStatisticsDto.setShortName(promotionModel.getShortName());// 活动简称
                adminPromotionStatisticsDto.setBeginDate(promotionModel.getBeginDate());// 开始时间
                adminPromotionStatisticsDto.setEndDate(promotionModel.getEndDate());// 结束时间
                adminPromotionStatisticsDto.setPromType(promotionModel.getPromType());// 活动类型
                adminPromotionStatisticsDto.setCreateOperType(promotionModel.getCreateOperType());// 创建者类型
                adminPromotionStatisticsDto.setCheckStatus(promotionModel.getCheckStatus());// 活动类型
                adminPromotionStatisticsDto.setSaleCount(promotionRangeModel.getSaleCount());// 销量
                adminPromotionStatisticsDto.setStock(promotionRangeModel.getStock());//库存
                adminPromotionStatisticsDto.setGoodsCode(promotionRangeModel.getGoodsCode());//商品code
                resultStaticsDtos.add(adminPromotionStatisticsDto);
            }
            response.setResult(new Pager<>(rangeForStatistics.getTotal(), resultStaticsDtos));
        } catch (Exception e) {
            log.error("获取活动统计失败{}", Throwables.getStackTraceAsString(e));
            response.setError("query.error");
        }
        return response;
    }

    /**
     * 增加销量
     *
     * @param promId     活动id
     * @param selectCode 单品号
     * @param saleCount  销量 买了多少件
     */
    @Override
    public Response<Boolean> updateSaleCount(Integer promId, String selectCode, Integer saleCount) {
        Response<Boolean> response = Response.newResponse();
        try {
            Map<String, Object> map = Maps.newHashMap();
            map.put("promotionId", promId);
            map.put("selectCode", selectCode);
            map.put("saleCount", saleCount);
            promotionManager.updateSaleCount(map);
            response.setResult(Boolean.TRUE);
        } catch (Exception e) {
            log.error("更新活动单品销量失败{}", Throwables.getStackTraceAsString(e));
            response.setError("prom.update.sale.count.error");
        }
        return response;

    }

	/**
	 * 根据活动类型查询活动对应的单品id List
	 */
	@Override
	public Response<List<String>> findPromotionsGoods(String promotionType,String sourceId) {
		Response<List<String>> response = new Response<>();
		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("promType", promotionType);
		paramMap.put("statusList", Lists.newArrayList("7"));
        paramMap.put("sourceId",sourceId);
		List<Integer> promotionModelIds = promotionDao.findAvailablePromotionIds(paramMap);
		List<String> result = Lists.newArrayList();
		for(Integer promotionId : promotionModelIds) {
			Map<String, Object> map = Maps.newHashMap();
			map.put("promotionId", promotionId);
			List<String> selectCodeList = promotionRangeDao.findSelectCodeByPromId(map);
			for(String code : selectCodeList) {
				result.add(code);
			}
		}	
		response.setResult(result);
		return response;
	}

    /**
     * 判断当前单品集合是否有活动使用，有活动使用返回false 没有活动使用返回ture
     */
    @Override
    public Response<Boolean>  getStatusByItemCode(String goodsCode){
        Response<Boolean> response=Response.newResponse();
        try {
            Response<List<ItemModel>> itemListByGoodsCodeList = itemService.findItemListByGoodsCodeList(Lists.newArrayList(goodsCode));
            if(itemListByGoodsCodeList.isSuccess()) {
                List<Integer> promIds = promotionRangeDao.findWorkPromByItem(Lists.transform(itemListByGoodsCodeList.getResult(), new Function<ItemModel, String>() {
                    @Override
                    public String apply( ItemModel itemModel) {
                        return itemModel.getCode();
                    }
                }));
                if (promIds.size() == 0) {
                    response.setResult(Boolean.TRUE);
                    return response;
                }
                Long workPromByIds = promotionDao.findWorkPromByIds(promIds);
                response.setResult(workPromByIds == 0);
            }
        }catch (Exception e){
            log.error("fail to getStatusByItemCode",e);
            response.setError("query.error");
        }
        return response;
    }
    @Override
    public Response<Boolean> syncPromoDataToIndexStart(String... args) {
        return this.syncPromoDataToIndex(args);
    }
    @Override
    public Response<Boolean> syncPromoDataToIndexEnd(String... args) {
        return this.syncPromoDataToIndex(args);
    }
    private Response<Boolean> syncPromoDataToIndex(String... args) {
        Response<Boolean> response = new Response<>();
        try {
            log.info("通过活动商品索引信息开始，参数为{}",Arrays.toString(args));
            Map<String,Object> queryMap=Maps.newHashMap();
            queryMap.put("promotionId",args[0]);
            queryMap.put("checkStatus",1);
            List<PromotionRangeModel> promotionRangeModels = promotionRangeDao.findByParams(queryMap);// 活动选品数据
            log.info("活动选品信息{}",Collections2.transform(promotionRangeModels, new Function<PromotionRangeModel, Integer>() {
                @Override
                public Integer apply(PromotionRangeModel input) {
                    return input.getId();
                }
            }));
            for (PromotionRangeModel promotionRangeModel : promotionRangeModels) {
                String itemId = promotionRangeModel.getSelectCode();
                ItemModel itemModel = itemService.findById(itemId);
                if (itemModel != null) {
                    ItemMakeDto itemMakeDto = new ItemMakeDto();
                    itemMakeDto.setGoodsCode(itemModel.getGoodsCode());
                    itemMakeDto.setStatus(ON_SHELF);
                    itemMakeDto.setSynchroPromoData(true);
                    itemRealTimeIndexer.index(itemMakeDto); // ON_SHELF("02", "上架"),OFF_SHELF("01", "下架"), DELETED("-1", "删除");
                }
            }
            //成功执行
            response.setResult(Boolean.TRUE);
            log.info("同步活动索引信息成功");
        } catch (Exception e) {
            log.error("同步商品的活动索引信息异常{}", Throwables.getStackTraceAsString(e));
            response.setError("同步商品的活动索引信息异常" + Throwables.getStackTraceAsString(e));
        }
        return response;
    }

    public Response<List<PromotionModel>> findPromotionByIds(List<Integer> promotionIds) {
        Response<List<PromotionModel>> response = Response.newResponse();
        try {
            List<PromotionModel> promotionModels = promotionDao.findPromotionByIds(promotionIds);
            response.setResult(promotionModels);
        } catch (Exception e){
            response.setError("promotionService.findPromotionByIds.error");
        }
        return response;
    }
}
