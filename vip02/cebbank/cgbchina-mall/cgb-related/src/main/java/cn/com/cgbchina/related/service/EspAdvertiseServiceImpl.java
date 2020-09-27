/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.dao.EspAdvertiseDao;
import cn.com.cgbchina.related.manager.EspAdvertiseManager;
import cn.com.cgbchina.related.model.EspAdvertiseModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Map;
import static com.google.common.base.Preconditions.checkArgument;
/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-6-30.
 */
@Service
@Slf4j
public class EspAdvertiseServiceImpl implements EspAdvertiseService{
    @Resource

    private EspAdvertiseManager espAdvertiseManager;
     @Resource
     private EspAdvertiseDao espAdvertiseDao;
    /**
     * 手机广告新增
     *
     * @param espAdvertiseModel
     * @return
     */
    @Override
    public Response<Boolean> create(EspAdvertiseModel espAdvertiseModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            checkArgument(StringUtils.isNotBlank(espAdvertiseModel.getOrdertypeId()), "espAdvertiseModel is null");
            espAdvertiseModel.setPageType("P1");//页面类型 01：首页,02：频道,P1 :手机广告
            espAdvertiseModel.setPublishStatus("21");//发布状态  21是等待发布
            espAdvertiseModel.setIsStop("0");//是否启用标志 0-停止，1-启用
            espAdvertiseManager.insert(espAdvertiseModel);
            response.setResult(Boolean.TRUE);
        } catch (IllegalArgumentException e) {
            log.error(e.getMessage(), espAdvertiseModel, Throwables.getStackTraceAsString(e));
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("create.error,error code:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, "default.create.error");
        }
        return response;
    }

    /**
     * 手机广告更新
     *
     * @param id
     * @param espAdvertiseModel
     * @return
     */
    @Override
    public Response<Boolean> update(String id, EspAdvertiseModel espAdvertiseModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            checkArgument(StringUtils.isNotBlank(espAdvertiseModel.getLinkType()), "espAdvertiseModel is null");
            // 获取ID
            espAdvertiseModel.setId(Long.valueOf(id));
            Boolean result = espAdvertiseManager.update(espAdvertiseModel);
            response.setResult(Boolean.TRUE);
        } catch (IllegalArgumentException e) {
            log.error(e.getMessage(), espAdvertiseModel, Throwables.getStackTraceAsString(e));
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("create.error,error code:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(Contants.ERROR_CODE_500, "default.update.error");
        }
        return response;
    }

    /**
     * 删除
     *
     * @param espAdvertiseModel
     * @return
     */
    @Override
    public Response<Boolean> delete(EspAdvertiseModel espAdvertiseModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            Boolean result = espAdvertiseManager.delete(espAdvertiseModel);
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
            log.error("delete.espAdvertise.error", Throwables.getStackTraceAsString(e));
            response.setError("delete.error");
            return response;
        }
    }
    /**
     * 发布手机广告
     *
     * @param espAdvertiseModel
     * @return
     */
    @Override
    public Response<Boolean> updateAdvetiseStatus(EspAdvertiseModel espAdvertiseModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            espAdvertiseModel.setPublishStatus("00");
            Boolean result = espAdvertiseManager.updateAdvetiseStatus(espAdvertiseModel);
            if (!result) {
                response.setError("update.espAdvertise.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("update.espAdvertise.error", Throwables.getStackTraceAsString(e));
            response.setError("update.espAdvertise.error");
            return response;
        }
    }
    /**
     * 更新启用状态
     *
     * @param espAdvertiseModel
     * @return
     */
    @Override
    public Response<Boolean> updateIsStop(EspAdvertiseModel espAdvertiseModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            if("0".equals(espAdvertiseModel.getIsStop())){
                espAdvertiseModel.setIsStop("1");
            }else{
                espAdvertiseModel.setIsStop("0");
            }
            Boolean result = espAdvertiseManager.updateIsStop(espAdvertiseModel);
            if (!result) {
                response.setError("update.espAdvertise.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("update.espAdvertise.error", Throwables.getStackTraceAsString(e));
            response.setError("update.espAdvertise.error");
            return response;
        }
    }

    /**
     * 手机广告查询
     * @param pageNo
     * @param size
     * @param advertisePos
     * @param publishStatus
     * @return
     */
    @Override
    public Response<Pager<EspAdvertiseModel>> findByPage(Integer pageNo, Integer size,String ordertypeId,String advertisePos,String publishStatus) {
        Response<Pager<EspAdvertiseModel>> response = new Response<Pager<EspAdvertiseModel>>();
        Map<String, Object> paramMap = Maps.newHashMap();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        // 根据条件查询 去掉前后空格
        if (StringUtils.isNotEmpty(ordertypeId)) {
            paramMap.put("ordertypeId", ordertypeId.trim().replace(" ", ""));
        }
        if (StringUtils.isNotEmpty(advertisePos)) {
            paramMap.put("advertisePos", advertisePos.trim().replace(" ", ""));
        }
        if (StringUtils.isNotEmpty(publishStatus)) {
            paramMap.put("publishStatus", publishStatus.trim().replace(" ", ""));
        }
        try {
            Pager<EspAdvertiseModel> pager = espAdvertiseDao.findByPage(paramMap, pageInfo.getOffset(),
                    pageInfo.getLimit());
            response.setResult(pager);
            return response;
        } catch (Exception e) {
            log.error("default term query error ", Throwables.getStackTraceAsString(e));
            response.setError("default.term.query.error");
            return response;
        }

    }

}
