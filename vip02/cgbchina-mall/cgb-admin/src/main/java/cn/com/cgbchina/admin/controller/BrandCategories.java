package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.item.model.EspNavCategoryInfModel;
import cn.com.cgbchina.item.service.EspNavCategoryInfService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
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

import javax.annotation.Resource;

/**
 * Created by zhangLin on 2016/11/21.
 */
@Controller
@RequestMapping("/api/admin/brandCategories")
@Slf4j
public class BrandCategories {
    @Resource
    private EspNavCategoryInfService espNavCategoryInfService;
    @Autowired
    private MessageSources messageSources;
    /**
     * 新增品牌信息
     */
    @RequestMapping(value = "/add-categories", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean createBrand(EspNavCategoryInfModel espNavCategoryInfModel) {
        User user = UserUtil.getUser();
        if (espNavCategoryInfModel.getCategoryName() == null || espNavCategoryInfModel.getCategoryName().isEmpty()){
            throw new ResponseException(500, messageSources.get("brand.category.null.name"));
        }
        if (espNavCategoryInfModel.getCategorySeq() == null){
            throw new ResponseException(500, messageSources.get("brand.category.null.seq"));
        }
        //基础数据组装
        espNavCategoryInfModel.setParentId("04");
        espNavCategoryInfModel.setLevel("1");
        espNavCategoryInfModel.setForwardType("");
        espNavCategoryInfModel.setCreateOper(user.getId());
        espNavCategoryInfModel.setModifyOper(user.getId());
        espNavCategoryInfModel.setDelFlag(0);
        Response<Boolean> response = espNavCategoryInfService.createBrandCate(espNavCategoryInfModel);
        if (response.isSuccess()){
            Boolean bool = response.getResult();
            if (Boolean.TRUE.equals(bool)){
                return Boolean.TRUE;
            }else {
                throw new ResponseException(500, messageSources.get("brand.category.create.error"));
            }
        }else {
            throw new ResponseException(500, messageSources.get(response.getError()));
        }
    }

    /**
     * 更新品牌信息
     */
    @RequestMapping(value = "/update-categories", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean updateBrand(EspNavCategoryInfModel espNavCategoryInfModel) {
        User user = UserUtil.getUser();
        if (espNavCategoryInfModel.getCategoryName() == null || espNavCategoryInfModel.getCategoryName().isEmpty()){
            throw new ResponseException(500, messageSources.get("brand.category.null.name"));
        }
        if (espNavCategoryInfModel.getCategorySeq() == null){
            throw new ResponseException(500, messageSources.get("brand.category.null.seq"));
        }
        EspNavCategoryInfModel updateModel = new EspNavCategoryInfModel();
        //更新数据组合
        updateModel.setCategoryName(espNavCategoryInfModel.getCategoryName());
        updateModel.setCategorySeq(espNavCategoryInfModel.getCategorySeq());
        updateModel.setId(espNavCategoryInfModel.getId());
        updateModel.setCategoryDesc(espNavCategoryInfModel.getCategoryDesc());
        //基础数据组装
        updateModel.setModifyOper(user.getId());
        Response<Boolean> response = espNavCategoryInfService.updateBrandCate(updateModel);
        if (response.isSuccess()){
            Boolean bool = response.getResult();
            if (Boolean.TRUE.equals(bool)){
                return Boolean.TRUE;
            }else {
                throw new ResponseException(500, messageSources.get("brand.category.update.error"));
            }
        }else {
            throw new ResponseException(500, messageSources.get(response.getError()));
        }
    }
    /**
     * 删除
     */
    @RequestMapping(value = "/delete-categories", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean deleteBrand(EspNavCategoryInfModel espNavCategoryInfModel) {
        User user = UserUtil.getUser();
        espNavCategoryInfModel.setModifyOper(user.getId());
        Response<Boolean> response = espNavCategoryInfService.deleteBrandCate(espNavCategoryInfModel);
        if (response.isSuccess()){
            Boolean bool = response.getResult();
            if (Boolean.TRUE.equals(bool)){
                return Boolean.TRUE;
            }else {
                throw new ResponseException(500, messageSources.get("brand.category.delete.error"));
            }
        }else {
            throw new ResponseException(500, messageSources.get(response.getError()));
        }
    }
}
