package cn.com.cgbchina.cms.web;

import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.web.utils.SafeHtmlValidator;
import com.spirit.common.model.Response;
import com.spirit.core.service.ItemCustomService;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller("designItems")
@RequestMapping("/api/design")
@Slf4j
public class ItemDesign {

    @Autowired
    private ItemCustomService itemCustomService;
    @Autowired
    private ItemService itemService;

    @Autowired
    private MessageSources messageSources;


    @RequestMapping(value = "/items/{itemId}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    public void saveItemCustom(@PathVariable Long itemId, @RequestParam String template) {
        if (template.length() > 50 * 1024) {
            log.error("template length is {},and long than 10k", template.length());
            throw new ResponseException(500, messageSources.get("content.too.long"));
        }
        if (SafeHtmlValidator.checkScriptAndEvent(template)) {
            log.error("has invalid html content: template({})", template);
            throw new ResponseException(403, "invalid.html");
        }
//        BaseUser user = UserUtil.getUser();
//        Response<Item> itemR = itemService.findById(itemId);
//        if(!itemR.isSuccess()){
//            log.error("failed to find item(id={}) error code:{}", itemId, itemR.getError());
//            throw new ResponseException(500,messageSources.get(itemR.getError()));
//        }
//        if (!Objects.equal(itemR.getResult().getUserId(), user.getId())) {
//            throw new ResponseException(403, "item not belong to u");
//        }
//        Response<Boolean> saveR = itemCustomService.save(itemId, template);
//        if(!saveR.isSuccess()){
//            log.error("failed to save itemCustom of item(id={}) error code:{}", itemId, saveR.getError());
//            throw new ResponseException(500,messageSources.get(saveR.getError()));
//        }
    }

    @RequestMapping(value = "/item-templates/{spuId}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    public void saveItemTemplate(@PathVariable Long spuId, @RequestParam String template) {
        if (SafeHtmlValidator.checkScriptAndEvent(template)) {
            log.error("has invalid html content: template({})", template);
            throw new ResponseException(403, "invalid.html");
        }
        Response<Boolean> saveR = itemCustomService.saveTemplate(spuId, template);
        if (!saveR.isSuccess()) {
            log.error("failed to save item template of spu(id={}) error code:{}", spuId, saveR.getError());
            throw new ResponseException(500, messageSources.get(saveR.getError()));
        }
    }
}
