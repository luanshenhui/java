/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.model.EspAdvertiseModel;
import cn.com.cgbchina.related.service.EspAdvertiseService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-7-1.
 */
@Controller
@RequestMapping("/api/admin/espAdvertise")
@Slf4j
public class EspAdvertise {
    @Autowired
    private EspAdvertiseService espAdvertiseService;
    @Autowired
    MessageSources messageSources;

    /**
     * 手机广告新增
     *
     * @param espAdvertiseModel
     * @return
     */
    @RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean create(EspAdvertiseModel espAdvertiseModel,String partitionsKeyword,String classificationsKeyword) {
        // 获取登录人
        User user = UserUtil.getUser();
        String createName = user.getName();
        espAdvertiseModel.setCreateOper(createName);
        Response<Boolean> booleanResponse = espAdvertiseService.create(espAdvertiseModel);
        if (booleanResponse.isSuccess()) {
            return booleanResponse.getResult();
        }
        log.error("insert.error，erro:{}", booleanResponse.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(booleanResponse.getError()));
    }

    /**
     * 手机广告更新
     *
     * @param id
     * @param espAdvertiseModel
     * @return
     */
    @RequestMapping(value = "/{id}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean update(@PathVariable String id, EspAdvertiseModel espAdvertiseModel) {
        Response<Boolean> result = new Response<Boolean>();
        User user = UserUtil.getUser();
        String createName = user.getName();
        espAdvertiseModel.setModifyOper(createName);
        result = espAdvertiseService.update(id, espAdvertiseModel);
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("update.error，erro:{}", result.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
    }
    /**
     *手机广告删除
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<Boolean> delete(@PathVariable Long id) {
        Response<Boolean> result = new Response<Boolean>();
        try {

            EspAdvertiseModel espAdvertiseModel = new EspAdvertiseModel();
            espAdvertiseModel.setId(Long.valueOf(id));
            User user = UserUtil.getUser();
            espAdvertiseModel.setModifyOper(user.getName());
            result = espAdvertiseService.delete(espAdvertiseModel);
        } catch (Exception e) {
            log.error("detele.advertise.error，erro:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get(e.getMessage()));
        }
        return result;

    }
    /**
     *手机广告发布
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<Boolean> updateAdvetiseStatus(@PathVariable Long id) {
        Response<Boolean> result = new Response<Boolean>();
        try {
            EspAdvertiseModel espAdvertiseModel = new EspAdvertiseModel();
            espAdvertiseModel.setId(Long.valueOf(id));
            User user = UserUtil.getUser();
            espAdvertiseModel.setModifyOper(user.getName());
            result = espAdvertiseService.updateAdvetiseStatus(espAdvertiseModel);
        } catch (Exception e) {
            log.error("update.advertise.error，erro:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get(e.getMessage()));
        }
        return result;

    }
    /**
     *手机广告启用状态更新
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/updateIsStop", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<Boolean> updateIsStop(Long id,String isStop) {
        Response<Boolean> result = new Response<Boolean>();
        try {
            checkArgument(StringUtils.isNotBlank(isStop), "isStop.not.empty");//开启状态不能为空
            EspAdvertiseModel espAdvertiseModel = new EspAdvertiseModel();
            espAdvertiseModel.setId(Long.valueOf(id));
            espAdvertiseModel.setIsStop(isStop);
            User user = UserUtil.getUser();
            espAdvertiseModel.setModifyOper(user.getName());
            result = espAdvertiseService.updateIsStop(espAdvertiseModel);
        } catch (IllegalArgumentException e) {
            log.error("update.advertise.error，erro:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get(e.getMessage()));
        } catch (Exception e) {
            log.error("update.advertise.error，erro:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get(e.getMessage()));
        }
        return result;

    }
}
