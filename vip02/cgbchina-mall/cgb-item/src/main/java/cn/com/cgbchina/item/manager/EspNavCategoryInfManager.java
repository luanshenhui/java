package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.item.dao.EspNavCategoryInfDao;
import cn.com.cgbchina.item.dao.GoodsBrandDao;
import cn.com.cgbchina.item.model.EspNavCategoryInfModel;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by zhangLin on 2016/11/21.
 */
@Transactional
@Component
public class EspNavCategoryInfManager {
    @Resource
    private EspNavCategoryInfDao espNavCategoryInfDao;
    @Resource
    private GoodsBrandDao goodsBrandDao;

    public Integer insert(EspNavCategoryInfModel espNavCategoryInfModel){
        Integer count = espNavCategoryInfDao.insert(espNavCategoryInfModel);
        return count;
    }

    public Integer update(EspNavCategoryInfModel espNavCategoryInfModel){
        Integer count = espNavCategoryInfDao.update(espNavCategoryInfModel);
        return count;
    }

    public Integer updateBrandCate(EspNavCategoryInfModel espNavCategoryInfModel) {
        Integer espcount = espNavCategoryInfDao.update(espNavCategoryInfModel);
        GoodsBrandModel goodsBrandModel = new GoodsBrandModel();
        goodsBrandModel.setBrandCategoryId(espNavCategoryInfModel.getCategoryId());
        goodsBrandModel.setBrandCategoryName(espNavCategoryInfModel.getCategoryName());
        goodsBrandModel.setModifyOper(espNavCategoryInfModel.getModifyOper());
        goodsBrandDao.updateBrandCategory(goodsBrandModel);
        return espcount;
    }

}
