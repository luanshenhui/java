package cn.com.cgbchina.admin.controller;

import com.google.common.collect.Lists;
import com.spirit.category.model.AttributeKey;
import com.spirit.category.model.AttributeValue;
import com.spirit.category.model.BaseSku;
import com.spirit.category.model.DefaultItem;
import com.spirit.category.service.AttributeService;
import com.spirit.category.service.DefaultItemService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.Serializable;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/api/admin")
@Slf4j
public class DefaultItems {

    @Autowired
    private MessageSources messageSources;

    @Autowired
    private DefaultItemService defaultItemService;

    @Autowired
    private AttributeService attributeService;


    @RequestMapping(value = "/spus/{id}/defaultItem", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String create(@RequestBody DefaultItemDto defaultItemDto,
                         @PathVariable("id") Long spuId) {
        DefaultItem defaultItem = defaultItemDto.getDefaultItem();
        defaultItem.setSpuId(spuId);
        List<BaseSku> skus = defaultItemDto.getSkus();
        Response<Boolean> result = defaultItemService.create(defaultItem, skus);
        if (!result.isSuccess()) {
            log.error("create defaultItem failed, cause:{}", result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
        return "ok";
    }

    /**
     * 更新默认商品(模版商品)，这里要求skus的id必须不为空
     *
     * @param defaultItemDto 默认商品详情和skus
     * @return 是否更新成功
     */
    @RequestMapping(value = "/spus/{id}/defaultItem", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String update(@RequestBody DefaultItemDto defaultItemDto,
                         @PathVariable("id") Long spuId) {
        DefaultItem defaultItem = defaultItemDto.getDefaultItem();
        defaultItem.setSpuId(spuId);
        List<BaseSku> skus = defaultItemDto.getSkus();
        Response<Boolean> result = defaultItemService.update(defaultItem, skus);
        if (!result.isSuccess()) {
            log.error("update defaultItem failed, cause:{}", result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
        return "ok";
    }

    /**
     * 模版商品创建前，返回所有的sku属性
     * @param spuId spuId
     * @return      sku属性k-v对
     */
    @RequestMapping(value = "/spus/{id}/defaultItem", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<AttributeKeyValues> find(@PathVariable("id") Long spuId) {
        Map<AttributeKey, List<AttributeValue>> skuAttributeMap = attributeService.findSkuAttributesNoCache(spuId);
        return from(skuAttributeMap);
    }

    private static class AttributeKeyValues implements Serializable{
        private static final long serialVersionUID = -6080123043672519658L;
        @Getter
        @Setter
        private AttributeKey attributeKey;

        @Getter
        @Setter
        private List<AttributeValue> attributeValues;

    }

    private static class DefaultItemDto implements Serializable{
        private static final long serialVersionUID = 5121105816672786350L;

        @Getter
        @Setter
        private DefaultItem defaultItem;

        @Getter
        @Setter
        private List<BaseSku> skus;
    }

    private List<AttributeKeyValues> from(Map<AttributeKey, List<AttributeValue>> skuAttributeMap) {
        List<AttributeKeyValues> result = Lists.newArrayListWithCapacity(skuAttributeMap.keySet().size());
        for (AttributeKey attributeKey : skuAttributeMap.keySet()) {
            AttributeKeyValues akv = new AttributeKeyValues();
            akv.setAttributeKey(attributeKey);
            akv.setAttributeValues(skuAttributeMap.get(attributeKey));
            result.add(akv);
        }
        return result;
    }
}
