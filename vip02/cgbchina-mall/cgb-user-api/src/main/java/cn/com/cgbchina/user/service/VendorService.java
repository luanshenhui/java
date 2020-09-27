package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dto.CooperationDto;
import cn.com.cgbchina.user.dto.MailStagesDto;
import cn.com.cgbchina.user.dto.StageRateDto;
import cn.com.cgbchina.user.dto.VendorDto;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.dto.VendorInfoIdDto;
import cn.com.cgbchina.user.dto.VendorRatioUploadDto;
import cn.com.cgbchina.user.model.ShopinfOutsystemModel;
import cn.com.cgbchina.user.model.TblVendorRatioModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.model.VendorModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;

/**
 * Created by niufw on 16-2-26.
 */

public interface VendorService {

	/**
	 * 根据条件查询供应商
	 *
	 * @param pageNo
	 * @param size
	 * @param vendorId
	 * @param simpleName
	 * @return
	 */
	public Response<Pager<VendorInfoDto>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
											   @Param("vendorId") String vendorId, @Param("simpleName") String simpleName, @Param("type") String type,
											   @Param("shopType") String shopType);

	/**
	 * 根据vendorId查询(内管平台用)
	 *
	 * @param vendorId
	 * @return
	 */
	public Response<VendorInfoDto> findById(@Param("vendorId") String vendorId);

	/**
	 * 内管供应商编辑页面组件专用
	 *
	 * @param vendorId
	 * @return
	 */
	public Response<CooperationDto> findForEditById(@Param("vendorId") String vendorId);

	/**
	 * 根据vendorId查询(内管平台用)
	 *
	 * @param vendorId
	 * @return
	 */
	public Response<VendorInfoDto> findByIdForCheck(@Param("vendorId") String vendorId);

	/**
	 * 根据vendorId查询(供应商平台用)
	 *
	 * @param user
	 * @return
	 */
	public Response<VendorInfoDto> findByVendorId(@Param("") User user);

	/**
	 * 商城合作商添加
	 *
	 * @param vendorInfoDto
	 * @return
	 */

	public Response<Boolean> create(VendorInfoDto vendorInfoDto, StageRateDto stageRateDto,
									MailStagesDto mailStagesDto);

	/**
	 * 商城合作商编辑
	 *
	 * @param vendorInfoDto
	 * @return
	 */
	public Response<Boolean> update(VendorInfoDto vendorInfoDto, StageRateDto stageRateDto, MailStagesDto mailStagesDto,
									List stageRateIdList, List mailStagesIdList, String createName);

	/**
	 * 商城合作商删除
	 *
	 * @param vendorId
	 * @return
	 */
	public Response<Boolean> delete(String vendorId);

	/**
	 * 商城合作商审核
	 *
	 * @param vendorId
	 * @return
	 */
	public Response<Boolean> vendorCheck(String vendorId, String pwsecond, String refuseDesc);

	/**
	 * 商城合作商拒绝
	 *
	 * @param vendorId
	 * @param refuseDesc
	 * @return
	 */
	public Response<Boolean> vendorRefuse(String vendorId, String refuseDesc);

	/**
	 * 模糊查询（也可作为查询所有供应商）
	 *
	 * @return
	 */
	public Response<List<VendorInfoModel>> findAll(VendorInfoModel vendorInfoModel);

	/**
	 * 根据供应商简称查询供应商id集合
	 *
	 * @param simpleName
	 * @return
	 */
	public Response<List<String>> findIdByName(String simpleName);

	/**
	 * 根据供应商Id停用子帐号id
	 *
	 * @param vendorId
	 * @return
	 */
	public Response<Boolean> updateByParentId(String vendorId);

	/**
	 * 根据供应商Id删除子帐号
	 *
	 * @param vendorId
	 * @return
	 */
	public Response<Boolean> deleteByParentId(String vendorId);

	/**
	 * 新增时校验合作商编号和用户编号是否存在
	 *
	 * @param vendorId
	 * @param vendorCode
	 * @return
	 */
	public Response<Integer> vendorCreateCheck(String vendorId, String vendorCode);

	/**
	 * 根据父id查询其子帐号
	 *
	 * @param pageNo
	 * @param size
	 * @param vendorId
	 * @return
	 */
	public Response<Pager<VendorDto>> findByParentId(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
													 @Param("vendorId") String vendorId);

	/**
	 * 供应商用户账号管理 启用未启用状态修改
	 *
	 * @param code
	 * @param status
	 * @return
	 */
	public Response<Boolean> changeStatus(String code, String status);

	/**
	 * 根据vendorIds查询(商城用)
	 *
	 * @param vendorIds
	 * @return
	 */
	public Response<List<VendorInfoModel>> findByVendorIds(List<String> vendorIds);

	/**
	 * 获取全部供应商供特殊积分倍率设置使用
	 *
	 * @return
	 */
	public Response<List<VendorInfoModel>> findAllVendor(String simpleName);

	/**
	 * 根据名称查供应商 如果名字为空 默认查所有
	 * @param simpleName
	 * @return
     */
	public Response<List<VendorInfoIdDto>> findVenDtoByName(String simpleName);


	/**
	 * 根据供应商id及分期数查询相应的比率信息
	 * @param vendorId
	 * @param installmentNumber
	 * @return
	 */
	public Response<TblVendorRatioModel> findRatioByVendorId(String vendorId, Integer installmentNumber);


	/**
	 * 根据供应商id查询该供应商的比率信息
	 * @param vendorId
	 * @return
	 */
	public Response<List<TblVendorRatioModel>> findRaditListByVendorId(String vendorId);

	/**
	 * 去除指定供应商ID的供应商列表
	 * @param vendorIds
	 * @return
	 */
	public Response<List<VendorInfoIdDto>> findVenDtoByVendorIds(List<String> vendorIds);

	/**
	 * 根据供应商ID查询供应商信息
	 * @param vendorId
	 * @return
	 */
	public Response<VendorInfoModel> findVendorById(String vendorId);

	/**
	 * 根据vendorId查询(内管平台用)
	 *
	 * @param vendorIdList
	 * @return
	 */
	public Response<List<VendorInfoDto>> findByListId(List<String> vendorIdList);


    /**
     * 供应商导入
     *
     * @param vendorInfoModels
     * @return
     */
    public Response<List<VendorRatioUploadDto>> uploadVendorRatios(List<VendorRatioUploadDto> vendorInfoModels, User user);

	/**
	 * 根据查询条件查询供应商信息
	 * @param vendorId
	 * @return
	 */
	public Response<VendorInfoModel> findInfoByConditions(String vendorId);

	/**
	 * 根据查询条件查询角色等信息
	 * @param vendorId
	 * @return
	 */
	public Response<VendorInfoModel> findVendorRoleByConditions(String vendorId);

	/**
	 * 根据供应商Id查询角色等信息
	 * @param vendorId
	 * @return
	 */
	public Response<VendorInfoModel> findVendorInfosByVendorId(String vendorId);

	/**
	 * 根据主键查询外系统信息
	 * @param id
	 * @return
	 */
	public Response<ShopinfOutsystemModel> findShopInfoOutSysInfosById(Long id);

	/**
	 * 查询需要推送的数量
	 * @param vendorIdList 供应商id列表
	 * @return 数量
	 *
	 * geshuo 20160824
	 */
	public Response<Long> findNeedActionCount(List<String> vendorIdList);


	public Response<String> getUserType(@Param("User") User user);

	/**
	 * 根绝id查询供应商用户信息
	 *
	 * @param id
	 * @return
	 */
	public Response<VendorModel> findVendorUserById(Long id);

	/**
	 * 根据渠道查询供应商
	 * @param channel
	 * @return
	 */
    Response<List<VendorInfoModel>> findVendorByChannel(String channel);

	/**
	 * 查询 供应商 信息列表
	 *
	 * @param model 查询条件
	 * @return models
	 * add by zhoupeng
     */
	Response<List<VendorInfoModel>> findVendorsByModel(VendorInfoModel model);

	/**
	 * 内管新建商品时品牌授权反查供应商使用
	 * @param vendorIds
	 * @return
     */
	public Response<List<VendorInfoModel>> findByVendorIdsForBrandAuth(List<String> vendorIds);

	/**
	 * 根据vendorId查询
	 * @param vendorIdList
	 * @return
	 */
	public Response<List<VendorModel>> findByListIds(List<String> vendorIdList);
}
