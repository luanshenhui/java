package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.ServicePromiseDao;
import cn.com.cgbchina.item.dto.ServicePromiseCheckDto;
import cn.com.cgbchina.item.manager.ServicePromiseManager;
import cn.com.cgbchina.item.model.ServicePromiseModel;
import com.google.common.base.Joiner;
import com.google.common.base.Optional;
import com.google.common.base.Splitter;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import static com.spirit.util.Arguments.notEmpty;

/**
 * Created by 11140721050130 on 16-3-18.
 */
@Service
@Slf4j
public class ServicePromiseServiceImpl implements ServicePromiseService {
    @Resource
    private ServicePromiseDao servicePromiseDao;
    @Resource
    private ServicePromiseManager servicePromiseManager;

    private final static Splitter splitter = Splitter.on(',').trimResults().omitEmptyStrings();
    // 定义本地缓存（根据服务承诺id取的服务承诺信息）
    private final LoadingCache<String, Optional<ServicePromiseModel>> servicePromiseCache;

    // 声明缓存
    public ServicePromiseServiceImpl() {
        // 生成本地缓存信息
        servicePromiseCache = CacheBuilder.newBuilder().expireAfterWrite(5, TimeUnit.MINUTES)
                .build(new CacheLoader<String, Optional<ServicePromiseModel>>() {
                    @Override
                    public Optional<ServicePromiseModel> load(String promiseid) throws Exception {
                        return Optional.fromNullable(servicePromiseDao.findServiceByIdEffective(Long.parseLong(promiseid)));
                    }
                });
    }

    //通过缓存取得服务承诺
    public Response<ServicePromiseModel> findServicePromiseByid(String promiseid) {
        Response<ServicePromiseModel> response = Response.newResponse();
        // 取得服务承诺的缓存信息
        try {
            Optional<ServicePromiseModel> goodsBrandModelCache = servicePromiseCache.getUnchecked(promiseid);
            // 如果缓存存在赋值给model
            if (goodsBrandModelCache.isPresent()) {
                response.setResult(goodsBrandModelCache.get());
            }
        } catch (Exception e) {
            log.error("servicePromise.getservicePromoiseCache.error");
            response.setError("servicePromise.getservicePromoiseCache.error");
        }
        return response;
    }

    /**
     * 服务承诺新增
     *
     * @param servicePromiseModel
     * @return
     */
    @Override
    public Response<Boolean> create(ServicePromiseModel servicePromiseModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            Boolean result = servicePromiseManager.create(servicePromiseModel);
            if (!result) {
                response.setError("insert.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("insert.defaultserach.error", Throwables.getStackTraceAsString(e));
            response.setError("insert.error");
            return response;
        }
    }

    /**
     * 服务承诺更新
     *
     * @param servicePromiseModel
     * @return
     */
    @Override
    public Response<Boolean> update(String code, ServicePromiseModel servicePromiseModel) {
        Response<Boolean> response = new Response<Boolean>();
        if (StringUtils.isEmpty(servicePromiseModel.getName())) {
            response.setError("name.not.empty");
            return response;
        }
        try {
            // 获取ID
            servicePromiseModel.setCode(Integer.valueOf(code));
            Boolean result = servicePromiseManager.update(servicePromiseModel);
            if (!result) {
                response.setError("update.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("update.defaultserach.error", Throwables.getStackTraceAsString(e));
            response.setError("update.error");
            return response;
        }

    }

    /**
     * 服务承诺删除
     *
     * @param servicePromiseModel
     * @return
     */
    @Override
    public Response<Boolean> delete(ServicePromiseModel servicePromiseModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            Boolean result = servicePromiseManager.delete(servicePromiseModel);
            if (!result) {
                response.setError("delete.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("delete servicePromise error", Throwables.getStackTraceAsString(e));
            response.setError("delete.error");
            return response;
        }
    }

    /**
     * 服务承诺查询
     *
     * @param pageNo
     * @param size
     * @param name
     * @return
     */
    @Override
    public Response<Pager<ServicePromiseModel>> find(Integer pageNo, Integer size, String name) {
        Response<Pager<ServicePromiseModel>> response = new Response<Pager<ServicePromiseModel>>();
        Map<String, Object> paramMap = Maps.newHashMap();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        // 根据条件查询 当有name的时候 根据name查询
        if (StringUtils.isNotEmpty(name)) {
            name = name.trim(); // 去除前后空格
        }
        if (StringUtils.isNotEmpty(name)) {
            paramMap.put("name", name);
        }
        try {
            Pager<ServicePromiseModel> pager = servicePromiseDao.findByPage(paramMap, pageInfo.getOffset(),
                    pageInfo.getLimit());
            response.setResult(pager);
            return response;
        } catch (Exception e) {
            log.error("default term query error ", Throwables.getStackTraceAsString(e));
            response.setError("default.term.query.error");
            return response;
        }

    }

    /**
     * 服务承诺名称重复校验
     *
     * @param name
     * @return
     */
    @Override
    public Response<ServicePromiseCheckDto> findNameByName(Long code, String name, Integer sort) {
        Response<ServicePromiseCheckDto> response = new Response<ServicePromiseCheckDto>();
        ServicePromiseCheckDto servicePromiseCheckDto = new ServicePromiseCheckDto();
        // 新增和编辑对name的校验区分 当code为null时是新增操作 不为null时是编辑操作
        if (code != null) {
            // 当为编辑操作时 先通过id查出该条数据的name
            ServicePromiseModel servicePromiseModel = servicePromiseDao.findById(code);
            // 如果name不相同 代表编辑操作更改了name 这样就是查询全部的name来校验 如果name相同 即可以编辑
            if (!name.equals(servicePromiseModel.getName())) {
                // 取得搜索词名称相同的条数 大于0代表有重复
                Long total = servicePromiseDao.findNameByName(name);
                if (total != 0) {
                    servicePromiseCheckDto.setNameCheck(false);
                    response.setResult(servicePromiseCheckDto);
                } else {
                    servicePromiseCheckDto.setNameCheck(true);
                    response.setResult(servicePromiseCheckDto);
                }
            }
            // 顺序校验
            if (!sort.equals(servicePromiseModel.getSort())) {
                Long sortTotal = servicePromiseDao.findSortBySort(sort);
                if (sortTotal != 0) {
                    servicePromiseCheckDto.setSortCheck(false);
                    response.setResult(servicePromiseCheckDto);
                } else {
                    servicePromiseCheckDto.setSortCheck(true);
                    response.setResult(servicePromiseCheckDto);
                }
            } else {
                servicePromiseCheckDto.setSortCheck(true);
                response.setResult(servicePromiseCheckDto);
            }
        } else {
            // 新增时走以下方法
            Long total = servicePromiseDao.findNameByName(name);
            if (total != 0) {
                servicePromiseCheckDto.setNameCheck(false);
                response.setResult(servicePromiseCheckDto);
            } else {
                servicePromiseCheckDto.setNameCheck(true);
                response.setResult(servicePromiseCheckDto);
            }
            Long sortTotal = servicePromiseDao.findSortBySort(sort);
            if (sortTotal != 0) {
                servicePromiseCheckDto.setSortCheck(false);
                response.setResult(servicePromiseCheckDto);
            } else {
                servicePromiseCheckDto.setSortCheck(true);
                response.setResult(servicePromiseCheckDto);
            }
        }

        return response;
    }

    @Override
    public Response<List<ServicePromiseModel>> findAllebled() {
        Response<List<ServicePromiseModel>> result = Response.newResponse();
        List<ServicePromiseModel> servicePromiseModels = servicePromiseDao.findAllAbled();
        if (!notEmpty(servicePromiseModels)) {
            log.error("failed to find service promise");
            result.setResult(Collections.<ServicePromiseModel>emptyList());
            return result;
        }
        result.setResult(servicePromiseModels);
        return result;
    }

    @Override
    public  Response<String> findCodeByNames(String names){
        Response<String> response = Response.newResponse();
        try {
            List<String> serviceList = splitter.splitToList(names);
            List<String> codes = servicePromiseDao.findCodeByNames(serviceList);
            Joiner  joiner = Joiner.on(",");
            response.setResult(joiner.join(codes));
            return response;
        }catch (Exception e){
            log.error("find.code.by.name.error,cause.by{}",Throwables.getStackTraceAsString(e));
            response.setError("find.code.by.name.error");
            return response;
        }

    }
}
