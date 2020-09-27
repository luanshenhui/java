package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.trade.service.MakecheckjobService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

/**
 * Created by 11141021040453 on 2016/5/30.
 */
@Controller
@RequestMapping("/api/admin/MakeCheckJob")
@Slf4j
public class Makecheckjob {
    @Resource
    MakecheckjobService makecheckjobService;
    @Resource
    MessageSources messageSources;

    /**
     * 启动自动
     *
     * @param createDateParam
     * @return
     */
    @RequestMapping(value = "/onShoudong", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Integer onShoudong(String createDateParam) {
        Response<Integer> result = makecheckjobService.onShoudong(createDateParam);
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("update.error,error code:{}", result.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
    }

    /**
     * 发送
     *
     * @param createDateParam
     * @return
     */
    @RequestMapping(value = "/renew", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Integer renew(String createDateParam, HttpServletRequest request) {
        String ip = request.getRemoteAddr();
        Response<Integer> result = makecheckjobService.renew(createDateParam, ip);
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("update.error,error code:{}", result.getError());
        throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
    }
}
