package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.EspNavCategoryInfDao;
import cn.com.cgbchina.item.dao.GoodsBrandDao;
import cn.com.cgbchina.item.manager.EspNavCategoryInfManager;
import cn.com.cgbchina.item.model.EspNavCategoryInfModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.DecimalFormat;
import java.util.List;
import java.util.Map;

/**
 * Created by liuchang on 2016/8/4.
 */

@Service
@Slf4j
public class EspNavCategoryInfServiceImpl implements EspNavCategoryInfService{

    @Resource
    private EspNavCategoryInfDao espNavCategoryInfDao;
    @Resource
    private EspNavCategoryInfManager espNavCategoryInfManager;
    @Resource
    private GoodsBrandDao goodsBrandDao;

    /**
     * 获取品牌分类
     *
     * @return
     */
    public Response<List<EspNavCategoryInfModel>> findEspNavCategoryInf(){
        Response<List<EspNavCategoryInfModel>> response = Response.newResponse();
        try {
            List<EspNavCategoryInfModel> model = espNavCategoryInfDao.findBrandTypes();
            response.setResult(model);
        } catch (Exception e) {
            log.error("find.esp.nav.category.inf.error{}", Throwables.getStackTraceAsString(e));
            response.setError("find.esp.nav.category.inf.error");
        }
        return response;
    }

    /**
     * 查询品牌分类
     * @param paramMap 查询参数
     * @return 查询结果
     *
     * geshuo 20160806
     */
    @Override
    public Response<Pager<EspNavCategoryInfModel>> findByPage(Map<String,Object> paramMap){
        Response<Pager<EspNavCategoryInfModel>> response = Response.newResponse();
        try{
            Pager<EspNavCategoryInfModel> pager = espNavCategoryInfDao.findByPage(paramMap);
            response.setResult(pager);
        } catch (Exception e){
            log.error("EspNavCategoryInfServiceImpl.findByPage.error Exception:{}", Throwables.getStackTraceAsString(e));
            response.setError("find.esp.nav.category.page.error");
        }
        return response;

    }

    public Response<Pager<EspNavCategoryInfModel>> findBrandCategoryAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
                                                                        @Param("categoryId") String categoryId, @Param("categoryName") String categoryName) {
        // 实例化返回Response
        Response<Pager<EspNavCategoryInfModel>> response = Response.newResponse();
        Map<String, Object> paramMap = Maps.newHashMap();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        try {
            // 查询条件
            paramMap.put("offset", pageInfo.getOffset());
            paramMap.put("limit", pageInfo.getLimit());
            if(categoryId != null && !categoryId.isEmpty()){
                paramMap.put("categoryId",categoryId);
            }
            if(categoryName != null && !categoryName.isEmpty()){
                paramMap.put("categoryName",categoryName);
            }
            Pager<EspNavCategoryInfModel> pager = espNavCategoryInfDao.findByPage(paramMap);
            response.setResult(pager);
            return response;
        } catch (Exception e) {
            log.error("brand.query.error", Throwables.getStackTraceAsString(e));
            response.setError("brand.query.error");
            return response;
        }
    }


    public Response<Boolean> createBrandCate(EspNavCategoryInfModel espNavCategoryInfModel){
        Response<Boolean> result = Response.newResponse();
        try {
            Integer maxid = espNavCategoryInfDao.findMaxId();
            maxid = maxid + 1;
            String categoryId;
            if (maxid < 1000){
                DecimalFormat df=new DecimalFormat("0000");
                categoryId=df.format(maxid);
            }else {
                categoryId=maxid.toString();
            }
            espNavCategoryInfModel.setId(maxid.longValue());
            espNavCategoryInfModel.setCategoryId(categoryId);
            Integer count = espNavCategoryInfManager.insert(espNavCategoryInfModel);
            if (count == 1) {
                result.setResult(Boolean.TRUE);
            }else {
                result.setError("");
            }
        }catch (Exception e){
            result.setError("brand.category.create.error");
        }
        return result;
    }

    public Response<Boolean> updateBrandCate(EspNavCategoryInfModel espNavCategoryInfModel){
        Response<Boolean> result = Response.newResponse();
        try {
            EspNavCategoryInfModel esmodel = espNavCategoryInfDao.findById(espNavCategoryInfModel.getId());
            espNavCategoryInfModel.setCategoryId(esmodel.getCategoryId());
            Integer count = espNavCategoryInfManager.updateBrandCate(espNavCategoryInfModel);
            if (count == 1) {
                result.setResult(Boolean.TRUE);
            }else {
                result.setResult(Boolean.FALSE);
            }
        }catch (Exception e){
            result.setError("brand.category.update.error");
        }
        return result;
    }

    public Response<Boolean> deleteBrandCate(EspNavCategoryInfModel espNavCategoryInfModel){
        Response<Boolean> result = Response.newResponse();
        try {
            Map<String, Object> params = Maps.newHashMap();
            EspNavCategoryInfModel espNavCategory = espNavCategoryInfDao.findById(espNavCategoryInfModel.getId());
            if (espNavCategory != null){
                params.put("brandCategoryId",espNavCategory.getCategoryId());
            }
            Long brand = goodsBrandDao.findBrandCountByParam(params);
            if (brand != null && brand > 0l){
                result.setError("brand.category.delete.brandnotnull");
            }else {
                EspNavCategoryInfModel deleteModle = new EspNavCategoryInfModel();
                deleteModle.setModifyOper(espNavCategoryInfModel.getModifyOper());
                deleteModle.setId(espNavCategoryInfModel.getId());
                deleteModle.setDelFlag(1);
                Integer count = espNavCategoryInfManager.update(deleteModle);
                if (count == 1) {
                    result.setResult(Boolean.TRUE);
                } else {
                    result.setResult(Boolean.FALSE);
                }
            }
        } catch (Exception e){
            result.setError("brand.category.delete.error");
        }
        return result;
    }
}
