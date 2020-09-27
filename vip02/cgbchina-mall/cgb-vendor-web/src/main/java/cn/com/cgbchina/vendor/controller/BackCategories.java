package cn.com.cgbchina.vendor.controller;

import cn.com.cgbchina.item.model.BrandAuthorizeModel;
import cn.com.cgbchina.item.service.BrandService;
import com.google.common.base.Function;
import com.google.common.base.Throwables;
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
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.BeanMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.antlr.v4.runtime.misc.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Controller
@RequestMapping("/api/vendor/backCategories")
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
    @Autowired
    private BrandService brandService;


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

    @RequestMapping(value = "/{categoryId}/spus", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<SpuWithDomain> findByCategoryId(@PathVariable("categoryId") Long categoryId) {
        Response<List<Spu>> result = spuService.findByCategoryIdNoCache(categoryId);
        User user = UserUtil.getUser();
        Response<List<BrandAuthorizeModel>> brandlistResponse = brandService.findBrandListForVendor(user.getVendorId(),"",user.getUserType());
        List<BrandAuthorizeModel> brandlist;
        if (brandlistResponse.isSuccess()){
            brandlist = brandlistResponse.getResult();
        } else {
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
        if(brandlist == null){
            return Lists.newArrayListWithCapacity(0);
        }
        final List<Long> itemCodes = Lists.transform(brandlist, new Function<BrandAuthorizeModel, Long>() {
            @Override
            public Long apply(@NotNull BrandAuthorizeModel input) {
                return input.getGoodsBrandId();
            }
        });
        Set<Long> uniqueKeySet = new HashSet<Long>();
        uniqueKeySet.addAll(itemCodes);
        if (result.isSuccess()) {
            List<Spu> spus = result.getResult();
            if (spus == null){
                return Lists.newArrayListWithCapacity(0);
            }
            List<SpuWithDomain> spuWithDomains = Lists.newArrayListWithCapacity(spus.size());
            for (Spu spu : spus) {
                try{
                    if (uniqueKeySet.contains(Long.valueOf(spu.getBrandId().longValue()))) {
                        SpuWithDomain spuWithDomain = new SpuWithDomain();
                        BeanMapper.copy(spu, spuWithDomain);
                        spuWithDomain.setContextDomain(commonConstants.getMainContext());
                        spuWithDomain.setDomain(commonConstants.getHrefProps().getProperty("main"));
                        spuWithDomains.add(spuWithDomain);
                    }
                }catch (Exception e){
                    log.error("backCategories.error.spu:{},Exception:{}",spu.getId(), Throwables.getStackTraceAsString(e));
                }
            }
            return spuWithDomains;
        } else {
            log.error("failed to find Spus for back categoryId {},error code :{}", categoryId, result.getError());
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
