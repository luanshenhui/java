package cn.com.cgbchina.admin.controller;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.base.Throwables;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.user.dto.EspPublishInfDto;
import cn.com.cgbchina.user.model.EspPublishInfModel;
import cn.com.cgbchina.user.service.EspPublishInfService;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by Tanliang 公告管理
 *
 * @time:2016-6-8
 */
@Controller
@RequestMapping("/api/admin/publish") // 请求映射
@Slf4j
public class Publish {
    @Autowired
    private EspPublishInfService espPublishInfService;
    @Autowired
    private MessageSources messageSources;

    /**
     * 公告发布 保存功能
     *
     * @param publishDate
     * @param expireDate
     * @param publishTitle
     * @param publishType
     * @param linkHref
     * @param publishContent
     * @return
     */
    @RequestMapping(value = "/savePublish", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String savePublish(@RequestParam(value = "publishDate", required = true) String publishDate,
                              @RequestParam(value = "expireDate", required = true) String expireDate,
                              @RequestParam(value = "publishTitle", required = true) String publishTitle,
                              @RequestParam(value = "publishType", required = true) String publishType,
                              @RequestParam(value = "curStatus", required = true) String curStatus,
                              @RequestParam(value = "linkHref", required = false) String linkHref,
                              @RequestParam(value = "publishContent", required = false) String publishContent) {

        try {
            User user = UserUtil.getUser();
            EspPublishInfDto espPublishInfDto = new EspPublishInfDto();
            // 发布时间 将String时间转换为Date类型
            SimpleDateFormat time = new SimpleDateFormat("yyyy-MM-dd");
            Date startTime = time.parse(publishDate);
            espPublishInfDto.setPublishDate(startTime);
            // 到期时间
            Date endTime = time.parse(expireDate);
            espPublishInfDto.setExpireDate(endTime);
            // 公告类型
            espPublishInfDto.setPublishType(publishType);
            // 公告标题
            espPublishInfDto.setPublishTitle(publishTitle);
            // 链接地址
            if (StringUtils.isNotEmpty(linkHref)) {
                espPublishInfDto.setLinkHref(linkHref.trim());
            }
            // 公告内容
            if (StringUtils.isNotEmpty(publishContent)) {
                espPublishInfDto.setPublishContent(publishContent.trim());
            }
            //公告状态
            espPublishInfDto.setCurStatus(curStatus);
            // 新增
            Response<Boolean> result = espPublishInfService.createPublish(espPublishInfDto, user);
            if (result.isSuccess()) {
                return "ok";
            } else {
                log.error("savePublish.error,error code:{}", espPublishInfDto, result.getError());
                throw new ResponseException(500, messageSources.get(result.getError()));
            }
        } catch (Exception e) {
            log.error("savePublish.error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get("save.error"));
        }
    }

    /**
     * 公告发布 保存功能
     *
     * @param code
     * @param state
     * @return
     */
    @RequestMapping(value = "/updatePublishStatus", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean updatePublishStatus(@Param(value = "code") String code,
                               @Param(value = "state") String state) {
        User user = UserUtil.getUser();
        Response<Boolean> response = espPublishInfService.updatePublishStatus(state, code, user);
        if (response.isSuccess()) {
            return true;
        } else {
            throw new ResponseException(500, messageSources.get(response.getError()));
        }
    }

    @RequestMapping(value = "/edit/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String update(@PathVariable("id") Long id, EspPublishInfModel espPublishInfModel) {
        User user = UserUtil.getUser();
        espPublishInfModel.setId(id);
        espPublishInfModel.setModifyOper(user.getName());
        espPublishInfModel.setModifyTime(new Date());
        Response<Integer> result = espPublishInfService.update(espPublishInfModel);
        if (result.isSuccess()) {
            return "ok";
        }
        log.error("failed to update {},error code:{}", espPublishInfModel, result.getError());
        throw new ResponseException(500, messageSources.get(result.getError()));
    }
}
