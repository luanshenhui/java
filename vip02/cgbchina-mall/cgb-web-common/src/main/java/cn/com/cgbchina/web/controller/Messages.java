package cn.com.cgbchina.web.controller;

import cn.com.cgbchina.user.model.PersonalMessageModel;
import cn.com.cgbchina.user.service.PersonalMessageService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import com.spirit.web.MessageSources;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by Tanliang on 16-5-20.
 */
@Controller
@RequestMapping("/api/messages") // 请求映射
@Slf4j
public class Messages {
    @Autowired
    private PersonalMessageService personalMessageService;
    @Autowired
    private MessageSources messageSources;

    /**
     * 消息全部已读功能
     *
     * @param type
     * @return
     * @author:tanliang
     */
    @RequestMapping(value = "/allMessageRead", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean messageRead(@RequestParam(value = "type", required = false) String type) {
        try {
            User user = UserUtil.getUser();
            PersonalMessageModel personalMessageModel = new PersonalMessageModel();
            personalMessageModel.setCustId(user.getId());
            if ("".equals(type)) {
                type = null;
            }
            if (type != null) {
                personalMessageModel.setType(type);
            }
            Response<Boolean> result = personalMessageService.updateAllMessage(personalMessageModel);
            if (result.isSuccess()) {
                return result.getResult();
            } else {
                log.error("allMessageRead error,error code:{}", type, result.getError());
                throw new ResponseException(500, messageSources.get(result.getError()));
            }
        } catch (Exception e) {
            log.error("messageType error.error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get("type.error"));
        }
    }


    @RequestMapping(value = "/readMessage", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean readMessage(Long id) {
//		User user  = UserUtil.getUser();
        PersonalMessageModel personalMessageModel = new PersonalMessageModel();
        personalMessageModel.setId(id);
        personalMessageModel.setIsRead("1");
        Response<Boolean> response = personalMessageService.updateToRead(id);
        if (response.isSuccess()) {
            return Boolean.TRUE;
        }
        log.error("failed to update message {},error code:{}", personalMessageModel, response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));

    }
}
