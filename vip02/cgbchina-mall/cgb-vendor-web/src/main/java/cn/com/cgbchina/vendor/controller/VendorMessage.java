package cn.com.cgbchina.vendor.controller;

import cn.com.cgbchina.user.model.VendorMessageModel;
import cn.com.cgbchina.user.service.VendorMessageService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.exception.UserNotLoginException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by 111140821050151 on 2016/9/8.
 */
@Controller
@RequestMapping("/api/vendor/message")
@Slf4j
public class VendorMessage {
    @Autowired
    private MessageSources messageSources;
    @Autowired
    private VendorMessageService vendorMessageService;


    /**
     * 全部标记为已读
     * @param typeId
     * @return
     */
    @RequestMapping(value = "/readAll", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean readAll(String typeId) {
        User user = UserUtil.getUser();
        if (user == null) {
            throw new UserNotLoginException(messageSources.get("user.not.login.yet"));
        }
        Response<Boolean> response = vendorMessageService.readAll(typeId,user);
        if(response.isSuccess()){
            return Boolean.TRUE;
        }
        log.error("failed to update all message{},error code:{}",typeId , response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 消息已读
     */
    @RequestMapping(value = "/readMessage", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean readMessage(String id ){
        User user = UserUtil.getUser();
        if (user == null) {
            throw new UserNotLoginException(messageSources.get("user.not.login.yet"));
        }
        Response<Boolean> response = vendorMessageService.readMessage(id);
        if(response.isSuccess()){
            return Boolean.TRUE;
        }
        log.error("failed to update  message{},error code:{}",id , response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }
}
