package com.cebbank.ccis.cebmall.admin.controller;

import com.cebbank.ccis.cebmall.common.enums.ChannelType;
import com.google.common.collect.Lists;
import com.spirit.category.dto.RichCategory;
import com.spirit.category.dto.SpuWithDomain;
import com.spirit.category.model.BackCategory;
import com.spirit.category.model.Spu;
import com.spirit.category.service.BackCategoryService;
import com.spirit.category.service.SpuService;
import com.spirit.common.model.Response;
import com.spirit.common.utils.CommonConstants;
import com.spirit.exception.ResponseException;
import com.spirit.util.BeanMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static com.spirit.util.Arguments.isNull;

@Controller
@RequestMapping("/api/admin/backCategories")
@Slf4j
public class BackCategories {

    @Autowired
    private BackCategoryService backCategoryService;
    @Autowired
    private SpuService spuService;
    @Autowired
    private CommonConstants commonConstants;
    @Autowired
    private MessageSources messageSources;


    @RequestMapping(method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<RichCategory> list(@RequestParam(required = false) String channel) {
        Response<List<RichCategory>> result = backCategoryService.childrenOfNoCache(0L, channel);
        if (result.isSuccess()) {
            return result.getResult();
        } else {
            log.error("failed to load root back categories,error code:{}", result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
    }

    @RequestMapping(value = "/{id}/children", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<RichCategory> childrenOf(@PathVariable("id") Long categoryId, @RequestParam(value = "channel", required = false) String channel) {
        Response<List<RichCategory>> result = backCategoryService.childrenOfNoCache(categoryId, channel);
        if (result.isSuccess()) {
            return result.getResult();
        } else {
            log.error("failed to load sub back categories of {},error code :{}", categoryId, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
    }

    @RequestMapping(value = "add", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public BackCategory newCategory(BackCategory backCategory, @RequestParam(value = "channel", required = false) String channel) {
        if (isNull(ChannelType.from(channel))) {
            backCategory.setChannel(channel);
        }
        Response<Long> result = backCategoryService.create(backCategory);
        if (result.isSuccess()) {
            Long id = result.getResult();
            backCategory.setId(id);
            return backCategory;
        } else {
            log.error("failed to create {},error code: {}", backCategory, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
    }

    @RequestMapping(value = "/del/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String removeChild(@PathVariable("id") Long id) {

        Response<Boolean> result = backCategoryService.delete(id);
        if (result.isSuccess()) {
            return messageSources.get("category.delete.success");
        } else {
            log.error("failed to delete back category {},cause:{}", id, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
    }

    @RequestMapping(value = "/{categoryId}/spus", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<SpuWithDomain> findByCategoryId(@PathVariable("categoryId") Long categoryId) {
        Response<List<Spu>> result = spuService.findByCategoryIdNoCache(categoryId);
        if (result.isSuccess()) {
            List<Spu> spus = result.getResult();
            List<SpuWithDomain> spuWithDomains = Lists.newArrayListWithCapacity(spus.size());
            for (Spu spu : spus) {
                SpuWithDomain spuWithDomain = new SpuWithDomain();
                BeanMapper.copy(spu, spuWithDomain);
                spuWithDomain.setContextDomain(commonConstants.getMainContext());
                spuWithDomain.setDomain(commonConstants.getHrefProps().getProperty("main"));
                spuWithDomains.add(spuWithDomain);
            }
            return spuWithDomains;
        } else {
            log.error("failed to find Spus for back categoryId {},error code :{}", categoryId, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
    }

    @RequestMapping(value = "/update/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String updateCategory(@PathVariable("id") Long categoryId,
                                 @RequestParam(value = "name") String name) {
        Response<Boolean> result = backCategoryService.update(categoryId, name);
        if (result.isSuccess()) {
            return messageSources.get("category.update.success");
        } else {
            log.error("failed to update back category {}, cause:{}", categoryId, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
    }

    @RequestMapping(value = "/findByLevel", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<BackCategory> findByLevel(@RequestParam(value = "level", defaultValue = "2") Integer level) {
        Response<List<BackCategory>> result = backCategoryService.findByLevelNoCache(level);
        if (!result.isSuccess()) {
            log.error("failed to find back category by level={}, error code:{}", level, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
        return result.getResult();
    }

}
