package cn.com.cgbchina.vendor.controller;

import cn.com.cgbchina.item.model.BrandAuthorizeModel;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.service.BrandService;
import com.google.common.base.Function;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.spirit.category.dto.AttributeDto;
import com.spirit.category.dto.SpuWithDomain;
import com.spirit.category.model.AttributeKey;
import com.spirit.category.model.AttributeValue;
import com.spirit.category.model.DefaultItem;
import com.spirit.category.model.RichAttribute;
import com.spirit.category.model.Spu;
import com.spirit.category.service.AttributeService;
import com.spirit.category.service.DefaultItemService;
import com.spirit.category.service.SpuService;
import com.spirit.common.model.Response;
import com.spirit.common.utils.CommonConstants;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.Getter;
import lombok.Setter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.validation.constraints.NotNull;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/api/vendor/spu")
public class Spus {
    private final static Logger log = LoggerFactory.getLogger(Spus.class);

    @Autowired
    private SpuService spuService;

    @Autowired
    private AttributeService attributeService;

    @Autowired
    private MessageSources messageSources;

    @Autowired
    private DefaultItemService defaultItemService;

    @Autowired
    private BrandService brandService;

    @Autowired
    private CommonConstants commonConstants;

    @RequestMapping(value = "/spus/{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public RichSpu find(@PathVariable("id") Long spuId) {
        Response<Spu> result = spuService.findById(spuId);
        if (!result.isSuccess()) {
            log.error("find spu(id={}) failed,error code:{}", spuId, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
        Spu spu = result.getResult();
        List<RichAttribute> spuAttributes = attributeService.findSpuAttributesNoCacheBy(spuId);
        List<AttributeKey> skuAttributeKeys = attributeService.findSkuKeysNoCacheBy(spuId);
        List<AttributeDto> attributeDtos = createDtoFrom(spuAttributes, skuAttributeKeys);
        RichSpu richSpu = new RichSpu();
        richSpu.setSpu(spu);
        richSpu.setAttributes(attributeDtos);
        return richSpu;
    }

    @RequestMapping(value = "/spuDetail/{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> findByDetail(@PathVariable("id") Long spuId) {
        Response<Spu> result = spuService.findById(spuId);
        if (!result.isSuccess()) {
            log.error("find spu(id={}) failed,error code:{}", spuId, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }

        List<RichAttribute> spuAttributes = attributeService.findSpuAttributesBy(spuId);
        Map<AttributeKey, List<AttributeValue>> skuAttributeMap = attributeService.findSkuAttributesBy(spuId);
        List<AttributeKeyValues> skuKeyValues = from(skuAttributeMap);

        Response<DefaultItem> defaultItemR = defaultItemService.findDefaultItemBySpuId(spuId);
        if (!defaultItemR.isSuccess()) {
            log.warn("failed to find defaultItem for spuId={}, error code:{}", spuId, defaultItemR.getError());
            return ImmutableMap.of("spu", result.getResult(), "spuAttributes", spuAttributes, "skuAttributes", skuKeyValues);
        }

        DefaultItem defaultItem = defaultItemR.getResult();
        return ImmutableMap.of("defaultItem", defaultItem, "spu", result.getResult(),
                "spuAttributes", spuAttributes, "skuAttributes", skuKeyValues);

    }

    private List<AttributeDto> createDtoFrom(List<RichAttribute> spuAttributes, List<AttributeKey> skuAttributeKeys) {
        List<AttributeDto> attributeDtos = Lists.newArrayListWithCapacity(spuAttributes.size() + skuAttributeKeys.size());
        for (RichAttribute spuAttribute : spuAttributes) {
            AttributeDto attributeDto = new AttributeDto(spuAttribute.getAttributeKeyId(), null, spuAttribute.getAttributeValue(), false, spuAttribute.getAttributeKey());
            attributeDtos.add(attributeDto);
        }
        for (AttributeKey skuAttributeKey : skuAttributeKeys) {
            AttributeDto attributeDto = new AttributeDto(skuAttributeKey.getId(), null, null, true, skuAttributeKey.getName());
            attributeDtos.add(attributeDto);
        }
        return attributeDtos;
    }

    @RequestMapping(value = "/add/spus", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public SpuWithDomain create(@RequestParam("data") String data) {
        try {
            RichSpu richSpu = JsonMapper.nonEmptyMapper().fromJson(data, RichSpu.class);
            Spu spu = richSpu.getSpu();
            Response<Spu> result = spuService.create(spu);
            List<AttributeDto> attributes = richSpu.getAttributes();
            if (attributes != null && !attributes.isEmpty()) {
                attributeService.addForSpu(spu.getId(), attributes);
            }
            SpuWithDomain spuDto = new SpuWithDomain();
            BeanMapper.copy(result.getResult(), spuDto);
            spuDto.setContextDomain(commonConstants.getMainContext());
            spuDto.setDomain(commonConstants.getHrefProps().getProperty("main"));
            log.info("user id={} create spu by data {}", UserUtil.getUser().getId(), data);
            return spuDto;
        } catch (Exception e) {
            log.error("failed to create spu (data={}),cause:{}", data, e);
            throw new ResponseException(500, messageSources.get("spu.create.fail"));
        }
    }

    @RequestMapping(value = "/update/spus", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String update(@RequestParam("data") String data) {
        RichSpu richSpu = JsonMapper.nonEmptyMapper().fromJson(data, RichSpu.class);
        Spu spu = richSpu.getSpu();
        if (spu.getId() == null) {
            throw new ResponseException(500, "spu.id.not.specify");
        }
        Response<Boolean> r = spuService.update(spu.getId(), spu.getName(), spu.getBrandId());
        if (r.isSuccess()) {
            List<AttributeDto> attributes = richSpu.getAttributes();
            attributeService.addForSpu(spu.getId(), attributes);
            log.info("user id={} update spu by data {}", UserUtil.getUser().getId(), data);
        } else {
            log.error("failed to update spu name where id={},error code : {}", spu.getId(), r.getResult());
            throw new ResponseException(500, messageSources.get(r.getError()));
        }
        return "ok";

    }


    @RequestMapping(value = "/spus/{id}/del", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String delete(@PathVariable("id") Long id) {
        try {
            spuService.delete(id);
            log.info("user id={} delete spu id={}", UserUtil.getUser().getId(), id);
            return messageSources.get("spu.delete.success");
        } catch (Exception e) {
            log.error("failed to delete spu (id={}),cause:{}", id, e);
            throw new ResponseException(500, messageSources.get("spu.delete.fail"));
        }
    }

    @RequestMapping(value = "/brands", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<GoodsBrandModel> findAllBrands() {
        User user = UserUtil.getUser();
        Response<List<BrandAuthorizeModel>> result = brandService.findBrandListForVendor(user.getVendorId(),"",user.getUserType());
        List<BrandAuthorizeModel> brandlist;
        if (result.isSuccess()){
            brandlist = result.getResult();
        } else {
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
        final List<Long> itemCodes = Lists.transform(brandlist, new Function<BrandAuthorizeModel, Long>() {
            @Override
            public Long apply(@NotNull BrandAuthorizeModel input) {
                return input.getGoodsBrandId();
            }
        });
        Response<List<GoodsBrandModel>> resultBrand = brandService.findByIds(Lists.<Long>newArrayList(itemCodes));
        if(!resultBrand.isSuccess()) {
            log.error("failed to find all brands, error code:{}", result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
        return resultBrand.getResult();
    }

    @RequestMapping(value = "/spus/{spuId}/brand", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public GoodsBrandModel findBrandBySpu(@PathVariable("spuId") Long spuId) {
        Response<Spu> spuR = spuService.findById(spuId);
        if(!spuR.isSuccess()) {
            log.error("failed to find spu by id ({}),error code:{}", spuId, spuR.getError());
            throw new ResponseException(500, messageSources.get(spuR.getError()));
        }
        Spu spu = spuR.getResult();
        Response<GoodsBrandModel> brandR = brandService.findBrandInfoById(Long.valueOf(spu.getBrandId()));
        if(!brandR.isSuccess()) {
            log.error("failed to  find brand by id ({}), error code:{}", spu.getBrandId(), brandR.getError());
            throw new ResponseException(500, messageSources.get(brandR.getError()));
        }
        return brandR.getResult();
    }

    public static class RichSpu {
        @Getter
        @Setter
        private Spu spu;

        @Getter
        @Setter
        private List<AttributeDto> attributes;
    }

    public static class AttributeKeyValues {
        @Getter
        @Setter
        private AttributeKey attributeKey;

        @Getter
        @Setter
        private List<AttributeValue> attributeValues;

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
