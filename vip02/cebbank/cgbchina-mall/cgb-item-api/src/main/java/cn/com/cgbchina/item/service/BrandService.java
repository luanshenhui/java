package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.BrandAuthorizeDto;
import cn.com.cgbchina.item.dto.UploadBrandsDto;
import cn.com.cgbchina.item.model.BrandAuthorizeModel;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;
import java.util.Map;

/**
 * Created by Liuhan on 16-4-13.
 */
public interface BrandService {

	/**
	 * 添加品牌
	 *
	 * @param brandAuthorizeModel
	 * @return
	 */
	public Response<Long> create(BrandAuthorizeDto brandAuthorizeModel, User user);

	/**
	 * 修改品牌/审核通过，拒绝
	 *
	 * @param brandAuthorizeModel
	 * @return
	 */
	public Response<Boolean> update(BrandAuthorizeDto brandAuthorizeModel, User user, String orderType);

	/**
	 * 查找所有品牌授权信息
	 *
	 * @param pageNo
	 * @param size
	 * @param type
	 * @param createTime
	 * @param brandName
	 * @param brandImage
	 * @param vendorName
	 * @param approveState
	 * @param endTime
	 * @return
	 */
	public Response<Pager<BrandAuthorizeDto>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
												   @Param("type") String type, @Param("createTime") String createTime, @Param("brandName") String brandName,
												   @Param("brandImage") String brandImage, @Param("vendorName") String vendorName,
												   @Param("approveState") String approveState, @Param("endTime") String endTime,
												   @Param("v_startTime") String v_startTime, @Param("v_endTime") String v_endTime,
												   @Param("v_startModifyTime") String v_startModifyTime, @Param("v_endModifyTime") String v_endModifyTime,
												   @Param("orderType") String orderType, @Param("user") User user);

	/**
	 * 查找所有品牌信息
	 *
	 * @param pageNo
	 * @param size
	 * @param type
	 * @param brandName
	 * @return
	 */
	public Response<Pager<GoodsBrandModel>> findBrandAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
														 @Param("type") String type, @Param("brandName") String brandName,
														 @Param("brandInforStatus") String brandInforStatus, @Param("user") User user,
														 @Param("orderType") String orderType);

	/**
	 * 通过品牌名称查询品牌ID
	 *
	 * @param brandName
	 * @param ordertypeId  业务id YG 广发，JF 积分
	 * @return
	 */
	public Response<GoodsBrandModel> findBrandByName(String brandName, String ordertypeId);

	/**
	 * 校验品牌名称
	 *
	 * @param brandName,businessType
	 * @return
	 */
	public Response<GoodsBrandModel> checkBrandName(String brandName, String businessType);

	/**
	 * 查询所有品牌的名字
	 *
	 * @return
	 * @Add by tanliang
	 */
	public Response<List<String>> findBrandNameAll();

	/**
	 * 查找需要审核的品牌的个数
	 *
	 * @return 审核的品牌的个数
	 */
	public Response<Long> findBrandCount(Map<String, Object> paramMap);

	/**
	 * 查询所有品牌的名字和品牌模糊查询（产品用）
	 *
	 * @return
	 * @Add by tanliang
	 */

	public Response<Pager<GoodsBrandModel>> findBrandByParam(String brandName, String ordertypeId, Integer pageNo, Integer size);

	/**
	 * 通过品牌iD查询品牌信息
	 *
	 * @param id
	 * @return
	 */
	public Response<GoodsBrandModel> findBrandInfoById(Long id);

	/**
	 * 通过品牌ID查询品牌
	 *
	 * @param ids
	 * @return
	 */
	public Response<List<GoodsBrandModel>> findByIds(@Param("ids") List<Long> ids);

	/**
	 * 查询所有可用品牌
	 *
	 * @return
	 * @Add by chenle
	 */
	public Response<List<GoodsBrandModel>> findAllBrands();

	/**
	 * 查询所有品牌装修数据
	 *
	 * @return
	 * @Add by zhangc
	 */

	public Response<List<GoodsBrandModel>> findBrandList();

	/**
	 * 查询所有品牌信息（供应商新增商品时用）
	 *
	 * @return
	 * @Add by chenle
	 */
	public Response<List<BrandAuthorizeModel>> findBrandListForVendor(String vendorId, String brandName,String ordertypeId);

	/**
	 * 根据品牌名称模糊查询品牌list
	 *
	 * @param brandName
	 * @return
	 * @Add by chenle
	 */
	public Response<List<GoodsBrandModel>> findBrandListByName(String brandName);

	/**
	 * 查询所有可用品牌 供特殊积分倍率使用
	 *
	 * @return
	 * @Add by yuxinxin
	 */
	public Response<List<GoodsBrandModel>> findAllBrandsSpecial(String brandName);

	/**
	 * 新增品牌信息（内管新增品牌）
	 *
	 * @param goodsBrandModel
	 * @return
	 */
	public Response<Boolean> createBrandInfo(GoodsBrandModel goodsBrandModel);

	/**
	 * 更新品牌信息(内管编辑、审核)
	 *
	 * @param goodsBrandModel
	 * @return
	 */
	public Response<Boolean> updateBrandInfo(GoodsBrandModel goodsBrandModel);

	/**
	 * 根据品牌名称查询该品牌是否被供应商授权过
	 *
	 * @param brandName
	 * @return
	 */
	public Response<Boolean> findIsAuthroizeByName(String brandName, String orderType);

	/**
	 * 删除品牌信息
	 *
	 * @param id
	 * @return
	 */
	public Response<Boolean> deleteBrandInfo(Long id);

	/**
	 * 根据id查询品牌授权信息
	 *
	 * @param id
	 * @return
	 */
	public Response<BrandAuthorizeModel> findBrandAuthorizeById(Long id);

	/**
	 * 品牌导入
	 *
	 * @param models
	 * @return
	 */
	public Response<List<UploadBrandsDto>> uploadBrands(List<UploadBrandsDto> models, User user, String ordertypeId);

	/**
	 * 判断该品牌该供应商是否可用
	 * @param brandName
	 * @param vendorId
	 * @return
	 */
	public Response<Boolean> findBrandAuthorizeByVendorId(String brandName,String vendorId);

}
