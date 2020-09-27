package com.cebbank.ccis.cebmall.admin.controller;

import com.spirit.category.dto.RichCategory;
import com.spirit.category.model.CategoryMapping;
import com.spirit.category.model.FrontCategory;
import com.spirit.category.service.FrontCategoryService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Created by 郝文佳 on 2016/4/28.
 */
@Controller
@Slf4j
@RequestMapping("/api/admin/frontCategories")
public class FrontCategories {

    @Autowired
    private FrontCategoryService frontCategoryService;

    @Autowired
    private MessageSources messageSources;

    @RequestMapping(method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<RichCategory> list(@RequestParam(required = false) String channel) {
        Response<List<RichCategory>> result = frontCategoryService.childrenOfNoCache(0L, channel);
        if (result.isSuccess()) {
            return result.getResult();
        } else {
            log.error("failed to load root front categories,error code:{}", result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
    }

    @RequestMapping(value = "/{id}/children", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<RichCategory> childrenOf(@PathVariable("id") Long categoryId, @RequestParam(value = "channel", required = false) String channel) {
        Response<List<RichCategory>> result = frontCategoryService.childrenOfNoCache(categoryId, channel);
        if (result.isSuccess()) {
            return result.getResult();
        } else {
            log.error("failed to load sub front categories of {},error code :{}", categoryId, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
    }

    @RequestMapping(value = "add", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public FrontCategory newCategory(FrontCategory frontCategory) {
        Response<Long> result = frontCategoryService.create(frontCategory);
        if (result.isSuccess()) {
            Long id = result.getResult();
            frontCategory.setId(id);
            return frontCategory;
        } else {
            log.error("failed to create {},error code: {}", frontCategory, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
    }


    @RequestMapping(value = "/del/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String removeChild(@PathVariable("id") Long id) {

        Response<Boolean> result = frontCategoryService.delete(id);
        if (result.isSuccess()) {
            return messageSources.get("category.delete.success");
        } else {
            log.error("failed to delete front category {},error code :{}", id, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }

    }

    @RequestMapping(value = "/mapping", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String createMapping(@RequestParam("fid") Long frontCategoryId, @RequestParam("bid") Long backCategoryId,
                                @RequestParam("path") String path) {
        Response<Boolean> result = frontCategoryService.createMapping(frontCategoryId, backCategoryId, path);
        if (result.isSuccess()) {
            return messageSources.get("mapping.create.success");
        } else {
            log.error("failed to create category mapping where frontCategoryId= {},error code:{}", frontCategoryId, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }

    }

    @RequestMapping(value = "/mapping/remove", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean removeMapping(@RequestParam("fid") Long frontCategoryId, @RequestParam("bid") Long backCategoryId,
                                 @RequestParam("path") String path) {
        Response<Boolean> result = frontCategoryService.removeMapping(frontCategoryId, backCategoryId, path);
        if (!result.isSuccess()) {
            log.error("fail to remove mapping by fid={}, bid={}, path={}, error code:{}",
                    frontCategoryId, backCategoryId, path, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
        return result.getResult();
    }

    @RequestMapping(value = "/{categoryId}/mapping", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<CategoryMapping> findByCategoryId(@PathVariable("categoryId") Long categoryId) {

        Response<List<CategoryMapping>> result = frontCategoryService.findMappingList(categoryId);
        if (result.isSuccess()) {
            return result.getResult();
        } else {
            log.error("failed to find category mapping for categoryId {},error code :{}", categoryId, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
    }

    @RequestMapping(value = "/{categoryId}/mapping", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String deleteByCategoryId(@PathVariable("categoryId") Long categoryId) {

        Response<Boolean> result = frontCategoryService.deleteMapping(categoryId);
        if (result.isSuccess()) {
            return "ok";
        } else {
            log.error("failed to delete category mapping for categoryId {},error code :{}", categoryId, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
    }

    @RequestMapping(value = "/update/{categoryId}", method = RequestMethod.POST)
    @ResponseBody
    public String updateCategory(@PathVariable("categoryId") Long categoryId,
                                 @RequestParam("name") String name) {
        Response<Boolean> result = frontCategoryService.update(categoryId, name);
        if (result.isSuccess()) {
            return messageSources.get("category update success");
        } else {
            log.error("failed to update front category{}, cause:{}", categoryId, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
    }

    @RequestMapping(value = "/icon/{categoryId}", method = RequestMethod.POST)
    @ResponseBody
    public String updateIcon(@PathVariable("categoryId") Long categoryId,
                                 @RequestParam("url") String url) {
        Response<Boolean> result = frontCategoryService.updateIcon(categoryId, url);
        if (result.isSuccess()) {
            return messageSources.get("category update success");
        } else {
            log.error("failed to update front category{}, cause:{}", categoryId, result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
    }

}
