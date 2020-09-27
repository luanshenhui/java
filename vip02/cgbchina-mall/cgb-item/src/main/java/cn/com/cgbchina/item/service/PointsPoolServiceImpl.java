package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.PointPoolDao;
import cn.com.cgbchina.item.dto.PointsPoolDto;
import cn.com.cgbchina.item.manager.PointPoolManager;
import cn.com.cgbchina.item.model.PointPoolModel;
import com.google.common.base.Optional;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * Created by niufw on 16-4-7.
 */
@Service
@Slf4j
public class PointsPoolServiceImpl implements PointsPoolService {

    @Resource
    private PointPoolDao pointPoolDao;
    @Resource
    private PointPoolManager pointPoolManager;

    // 定义本地缓存（根据服务承诺id取的服务承诺信息）
    private final LoadingCache<String, Optional<PointPoolModel>> pointPoolCache;

    // 声明缓存
    public PointsPoolServiceImpl() {
        // 生成本地缓存信息
        pointPoolCache = CacheBuilder.newBuilder().expireAfterWrite(5, TimeUnit.MINUTES)
                .build(new CacheLoader<String, Optional<PointPoolModel>>() {
                    @Override
                    public Optional<PointPoolModel> load(String promiseid) throws Exception {
                        return Optional.fromNullable(pointPoolDao.getCurMonthInfo());
                    }
                });
    }

    //通过缓存当月积分池
    public PointPoolModel findPointsPoolService() {
        String promiseid = "1";
        // 取得品牌的缓存信息
        Optional<PointPoolModel> goodsBrandModelCache = pointPoolCache.getUnchecked(promiseid);
        // 如果缓存存在赋值给model
        if (goodsBrandModelCache.isPresent()) {
            return goodsBrandModelCache.get();
        }
        return null;
    }

    @Override
    public Response<Pager<PointsPoolDto>> findAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
                                                  @Param("curMonth") String curMonth) {
        Response<Pager<PointsPoolDto>> response = new Response<Pager<PointsPoolDto>>();
        List<PointsPoolDto> pointsPoolDtos = Lists.newArrayList();
        Map<String, Object> paramMap = Maps.newHashMap();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        if (StringUtils.isNotEmpty(curMonth)) {
            curMonth = curMonth.trim(); // 去除前后空格
        }
        if (StringUtils.isNotEmpty(curMonth)) {
            // 将查询条件放入到paramMap
            paramMap.put("curMonth", curMonth);// 月份
        }
        try {
            Pager<PointPoolModel> pager = pointPoolDao.findByPage(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
            if (pager.getTotal() > 0) {
                // 获取当前时间
                Date time = new Date();
                SimpleDateFormat curTimeFormat = new SimpleDateFormat("yyyyMM");
                String curTime = curTimeFormat.format(time);
                // 遍历将pointPoolModel的值赋给pointsPoolDto，同时加入当前时间
                List<PointPoolModel> pointPoolModels = pager.getData();
                for (PointPoolModel pointPoolModel : pointPoolModels) {
                    PointsPoolDto pointsPoolDto = new PointsPoolDto();
                    BeanMapper.copy(pointPoolModel, pointsPoolDto);
                    // 定义result是当前时间和当前月份的比较结果,flag是用于前台页面识别
                    Integer result = curTime.compareTo(pointPoolModel.getCurMonth());
                    Integer flag = 0;
                    if (result > 0) {
                        flag = 1;
                    } else if (result < 0) {
                        flag = -1;
                    }
                    pointsPoolDto.setFlag(flag);
                    pointsPoolDtos.add(pointsPoolDto);
                }
                response.setResult(new Pager<PointsPoolDto>(pager.getTotal(), pointsPoolDtos));
                return response;
            } else {
                response.setResult(new Pager<PointsPoolDto>(0L, Collections.<PointsPoolDto>emptyList()));
                return response;
            }
        } catch (Exception e) {
            log.error("pointPool.time.query.error", Throwables.getStackTraceAsString(e));
            response.setError("pointPool.time.query.error");
            return response;
        }
    }

    /**
     * 积分池添加
     *
     * @param pointPoolModel
     * @return
     */
    @Override
    public Response<Boolean> create(PointPoolModel pointPoolModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            // 校验
            if (pointPoolModel == null) {
                response.setError("create.pointPool.error");
                return response;
            }
            Boolean result = pointPoolManager.create(pointPoolModel);
            if (!result) {
                response.setError("create.pointPool.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("create.pointPool.error", Throwables.getStackTraceAsString(e));
            response.setError("create.pointPool.error");
            return response;
        }
    }

    /**
     * 积分池编辑
     *
     * @param pointPoolModel
     * @return
     */
    @Override
    public Response<Boolean> update(PointPoolModel pointPoolModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            // 校验
            if (pointPoolModel == null) {
                response.setError("update.pointPool.error");
                return response;
            }
            Boolean result = pointPoolManager.update(pointPoolModel);
            if (!result) {
                response.setError("update.pointPool.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("update.pointPool.error", Throwables.getStackTraceAsString(e));
            response.setError("update.pointPool.error");
            return response;
        }
    }

    /**
     * 积分池删除
     *
     * @param id
     * @return
     */
    @Override
    public Response<Boolean> delete(Long id) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            // 校验
            Boolean result = pointPoolManager.delete(id);
            if (!result) {
                response.setError("delete.pointPool.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("delete.pointPool.error", Throwables.getStackTraceAsString(e));
            response.setError("delete.pointPool.error");
            return response;
        }
    }

    /**
     * 月份唯一性校验
     *
     * @param curMonth
     * @return
     */
    @Override
    public Response<Integer> curMonthCheck(String curMonth) {
        Response<Integer> response = new Response<Integer>();
        try {
            if (StringUtils.isNotEmpty(curMonth)) {
                PointPoolModel result = pointPoolDao.curMonthCheck(curMonth);
                if (result != null) {
                    response.setResult(1); // 月份已存在
                } else {
                    response.setResult(2);
                }
            }
            return response;
        } catch (Exception e) {
            log.error("check.month.error", Throwables.getStackTraceAsString(e));
            response.setError("pointPool.check.error");
            return response;
        }
    }

    /**
     * 获取最近积分池信息
     *
     * @return
     */
    @Override
    public Response<PointPoolModel> getLastInfo() {
        Response<PointPoolModel> response = new Response<PointPoolModel>();
        try {
            PointPoolModel pointPoolModel = pointPoolDao.getLastInfo();
            response.setResult(pointPoolModel);
            return response;
        } catch (Exception e) {
            log.error("pointPool.getLastInfo.error{}", Throwables.getStackTraceAsString(e));
            response.setError("pointPool.getLastInfo.error");
            return response;
        }

    }

    /**
     * 获取当月积分池，如果当月未设置积分池信息，则找距离最近的一个月
     * 商品详情页用
     *
     * @return
     */

    @Override
    public Response<PointPoolModel> getCurOrLastInfo() {
        Response<PointPoolModel> response = new Response<PointPoolModel>();
        try {
            PointPoolModel pointPoolModel = pointPoolDao.getCurOrLastInfo();
            response.setResult(pointPoolModel);
            return response;
        } catch (Exception e) {
            log.error("pointPool.getCurOrLastInfo.error{}", Throwables.getStackTraceAsString(e));
            response.setError("pointPool.getCurOrLastInfo.error");
            return response;
        }
    }


    /**
     * 回滚积分池
     *
     * @param paramMap
     * @return
     */
    @Override
    public Response<Boolean> dealPointPool(Map<String, Object> paramMap) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            pointPoolManager.dealPointPool(paramMap);
            response.setResult(Boolean.TRUE);
        } catch (IllegalArgumentException e) {
            log.error(e.getMessage(), paramMap, Throwables.getStackTraceAsString(e));
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("create.error,error code:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, "couponInf.update.error");
        }
        return response;
    }

    /**
     * 获取当月积分池信息
     *
     * @return
     */
    @Override
    public Response<PointPoolModel> getCurMonthInfo() {
        Response<PointPoolModel> response = new Response<PointPoolModel>();
        try {
            PointPoolModel pointPoolModel = pointPoolDao.getCurMonthInfo();
            if (pointPoolModel == null) {
                response.setError("pointPool.getCurMonthInfo.error");
                return response;
            }
            response.setResult(pointPoolModel);
            return response;
        } catch (Exception e) {
            log.error("pointPool.getCurMonthInfo.error{}", Throwables.getStackTraceAsString(e));
            response.setError("pointPool.getCurMonthInfo.error");
            return response;
        }
    }

    /**
     * 增加已用积分
     *
     * @param paramMap
     * @return
     */
    @Override
    public Response<Boolean> subtractPointPool(Map<String, Object> paramMap) {
        Response<Boolean> response = Response.newResponse();
        try {
            pointPoolManager.subtractPointPool(paramMap);
            response.setResult(Boolean.TRUE);
            return response;
        } catch (Exception e) {
            log.error("pointPool.subtractPointPool.error,error code:{}", Throwables.getStackTraceAsString(e));
            response.setError("pointPool.subtractPointPool.error");
            return response;
        }
    }
    
    /**
     * 积分池编辑
     *
     * @param pointPoolModel
     * @return
     */
    @Override
    public Response<Boolean> updateById(PointPoolModel pointPoolModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            // 校验
            if (pointPoolModel == null) {
                response.setError("update.pointPool.error");
                return response;
            }
            Boolean result = pointPoolManager.updateById(pointPoolModel);
            if (!result) {
                response.setError("update.pointPool.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("update.pointPool.error", Throwables.getStackTraceAsString(e));
            response.setError("update.pointPool.error");
            return response;
        }
    }
    
}
