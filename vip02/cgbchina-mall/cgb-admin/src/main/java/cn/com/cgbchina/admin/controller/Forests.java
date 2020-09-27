package cn.com.cgbchina.admin.controller;

import com.spirit.category.service.CategorySyncService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 前后台类目小森林
 */
@Controller
@RequestMapping("/api/admin/forest")
@Slf4j
public class Forests {

    private final CategorySyncService categorySyncService;

    @Autowired
    public Forests(CategorySyncService categorySyncService) {
        this.categorySyncService = categorySyncService;
    }

    @RequestMapping(value = "/backSync", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String backSync() {
        Response<Boolean> result = categorySyncService.publish("back");
        if (result.isSuccess()) {
            log.info("send backSync change signal");
            return "ok";
        } else {
            log.error("failed to sync back category, error code:{}", result.getError());
            throw new ResponseException(500, result.getError());
        }
    }

    @RequestMapping(value = "/frontSync", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String frontSync() {
        Response<Boolean> result = categorySyncService.publish("front");
        if (result.isSuccess()) {
            log.info("send frontSync change signal");
            return "ok";
        } else {
            log.error("failed to sync front category, error code:{}", result.getError());
            throw new ResponseException(500, result.getError());
        }
    }
}
