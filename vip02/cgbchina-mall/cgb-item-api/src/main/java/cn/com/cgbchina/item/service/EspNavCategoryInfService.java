package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.model.EspNavCategoryInfModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import java.util.List;
import java.util.Map;

/**
 * Created by liuchang on 2016/8/4.
 */
public interface EspNavCategoryInfService {

    /**
     * 获取品牌分类
     *
     * @return
     */
    public Response<List<EspNavCategoryInfModel>> findEspNavCategoryInf();


    /**
     * 查询品牌分类
     * @param paramMap 查询参数
     * @return 查询结果
     *
     * geshuo 20160806
     */
    Response<Pager<EspNavCategoryInfModel>> findByPage(Map<String,Object> paramMap);

    public Response<Pager<EspNavCategoryInfModel>> findBrandCategoryAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
                                                                        @Param("categoryId") String categoryId, @Param("categoryName") String categoryName);

    /**
     * 新建品牌分类
     */
    public Response<Boolean> createBrandCate(EspNavCategoryInfModel espNavCategoryInfModel);

    /**
     * 更新品牌分类
     */
    public Response<Boolean> updateBrandCate(EspNavCategoryInfModel espNavCategoryInfModel);
    /**
     * 删除品牌分类
     */
    public Response<Boolean> deleteBrandCate(EspNavCategoryInfModel espNavCategoryInfModel);
}
