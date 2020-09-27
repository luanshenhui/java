package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.ProductDto;
import cn.com.cgbchina.item.dto.UploadProductDto;
import cn.com.cgbchina.item.model.ProductModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;

/**
 * @author Tanliang
 * @since :2016-4-22
 */
public interface ProductService {
    /**
     * 产品页面分页以及查询功能
     *
     * @param pageNo
     * @param size
     * @param name
     * @param orderTypeId 业务类型代码 YG：广发 JF：积分
     * @return
     */
    public Response<Pager<ProductDto>> findAll(
            @Param("pageNo") Integer pageNo, @Param("size") Integer size,
            @Param("name") String name, @Param("brandName") String brandName,
            @Param("startTime") String startTime, @Param("endTime") String endTime,
            @Param("back_category1_id") String back_category1_id, @Param("back_category2_id") String back_category2_id,
            @Param("back_category3_id") String back_category3_id, @Param("order_type_id") String orderTypeId
    );

    /**
     * 根据产品id查看产品
     *
     * @param id
     * @return
     */
    public Response<ProductDto> findProductById(@Param("id") Long id);

    /**
     * 根据id删除产品
     *
     * @param id
     * @return
     */
    public Response<Boolean> deleteProductById(Long id);

    /**
     * 新增及编辑产品
     *
     * @param productDto
     * @return
     */
    public Response<Boolean> saveOrEditProduct(ProductDto productDto,User user);

    /**
     * 产品名称校验
     *
     * @param name
     * @return
     */
    public Response<Boolean> findByName(String name, Long id, Long backCategory3Id);

    /**
     * 检索产品列表
     *
     * @param productModel
     * @return
     */
    public Response<List<ProductModel>> findProductList(ProductModel productModel);

    /**
     * 通过产品ID列表检索产品列表
     *
     * @param ids
     * @return
     */
    public Response<List<ProductModel>> findByIds(List<Long> ids);

    /**
     * 根据产品名称查询产品信息
     *
     * @param name
     * @return
     */
    public Response<ProductModel> findProductByName(String name);

    /**
     * 产品导入
     *
     * @return
     * @throws Exception
     */
    public Response<List<UploadProductDto>> uploadProduct(List<UploadProductDto> details, String ordertypeId, User user) throws Exception;
}
