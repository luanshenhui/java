/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.dao.AdvertisingManageDao;
import cn.com.cgbchina.related.manager.AdvertisingManager;
import cn.com.cgbchina.related.model.AdvertisingManageModel;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.service.VendorService;
import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Map;

/**
 * @author niufw
 * @version 1.0
 * @since 16-6-20.
 */
@Slf4j
@Service
public class AdvertisingManageServiceImpl implements AdvertisingManageService {
	@Resource
	private AdvertisingManageDao advertisingManageDao;
	@Resource
	private AdvertisingManager advertisingManager;
	@Resource
	private VendorService vendorService;


	@Override
	public Response<Pager<AdvertisingManageModel>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("checkStatus") String checkStatus, @Param("id") String id, @Param("createTime") String createTime,
			@Param("fullName") String fullName, @Param("ordertypeId") String ordertypeId,@Param("user")User user) {
		Response<Pager<AdvertisingManageModel>> response = new Response<Pager<AdvertisingManageModel>>();
		Map<String, Object> paramMap = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		String vendorId = user.getVendorId();
		if (StringUtils.isNotEmpty(checkStatus)) {
			paramMap.put("checkStatus", checkStatus);// 状态
		}
		if (StringUtils.isNotEmpty(id)) {
			id = id.trim(); // 去除前后空格
		}
		if (StringUtils.isNotEmpty(id)) {
			// 将查询条件放入到paramMap
			paramMap.put("id", id);// 申请编号
		}
		if (StringUtils.isNotEmpty(createTime)) {
			paramMap.put("createTime", createTime);// 申请日期
		}
		if (StringUtils.isNotEmpty(fullName)) {
			fullName = fullName.trim(); // 去除前后空格
		}
		if (StringUtils.isNotEmpty(fullName)) {
			// 将查询条件放入到paramMap
			paramMap.put("fullName", fullName);// 供应商
		}
		if (StringUtils.isNotEmpty(ordertypeId)) {
			paramMap.put("ordertypeId", ordertypeId);// 业务类型
		}
		if(StringUtils.isNotEmpty(vendorId)){
			paramMap.put("vendorId",vendorId);//供应商编码
		}
		paramMap.put("isValid", Contants.AD_IS_VALID_1);// 是否有效 (1 是)

		try {
			// 分页查询
			Pager<AdvertisingManageModel> pager = advertisingManageDao.findByPage(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());
			response.setResult(new Pager<AdvertisingManageModel>(pager.getTotal(), pager.getData()));
			return response;
		} catch (Exception e) {
			log.error("advertising.query.error", Throwables.getStackTraceAsString(e));
			response.setError("advertising.query.error");
			return response;
		}
	}

	/**
	 * 广告管理审核 niufw
	 * 
	 * @param advertisingManageModel
	 * @return
	 */
	@Override
	public Response<Boolean> advertisingCheck(AdvertisingManageModel advertisingManageModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验
			if (advertisingManageModel == null) {
				response.setError("check.advertising.error");
				return response;
			}
			//插入审核状态  2--已通过
			advertisingManageModel.setCheckStatus("1");
			Boolean result = advertisingManager.advertisingCheck(advertisingManageModel);
			if (!result) {
				response.setError("check.advertising.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("check.advertising.error", Throwables.getStackTraceAsString(e));
			response.setError("check.advertising.error");
			return response;
		}
	}

	/**
	 * 广告管理拒绝 niufw
	 * 
	 * @param advertisingManageModel
	 * @return
	 */
	@Override
	public Response<Boolean> advertisingRefuse(AdvertisingManageModel advertisingManageModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验
			if (advertisingManageModel == null) {
				response.setError("refuse.advertising.error");
				return response;
			}
			//插入审核状态  2--已拒绝
			advertisingManageModel.setCheckStatus("2");
			Boolean result = advertisingManager.advertisingRefuse(advertisingManageModel);
			if (!result) {
				response.setError("refuse.advertising.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("refuse.advertising.error", Throwables.getStackTraceAsString(e));
			response.setError("refuse.advertising.error");
			return response;
		}
	}

	/**
	 * 广告管理删除 niufw
	 * 
	 * @param id
	 * @return
	 */
	@Override
	public Response<Boolean> delete(Long id) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验
			if (id == null) {
				response.setError("delete.advertising.error");
				return response;
			}
			Boolean result = advertisingManager.delete(id);
			if (!result) {
				response.setError("delete.advertising.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("delete.advertising.error", Throwables.getStackTraceAsString(e));
			response.setError("delete.advertising.error");
			return response;
		}
	}

	/**
	 * 广告管理添加(供应商平台) niufw
	 *
	 * @param advertisingManageModel
	 * @return
	 */

	@Override
	public Response<Boolean> create(AdvertisingManageModel advertisingManageModel,String userType) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验
			if (advertisingManageModel == null) {
				response.setError("create.advertising.error");
				return response;
			}
			//待新增数据整理
			advertisingManageModel.setOrdertypeId(userType);//业务类型代码(YG：广发 JF:积分)
			Response<VendorInfoDto> vendorInfoDtoResponse = vendorService.findById(advertisingManageModel.getVendorId());//根据供应商id查询供应商全称
			if(vendorInfoDtoResponse.isSuccess()){
				VendorInfoDto vendorInfoDto = vendorInfoDtoResponse.getResult();
				advertisingManageModel.setFullName(vendorInfoDto.getFullName());//供应商全称
			}
			advertisingManageModel.setMediaType(Contants.AD_MEDIA_TYPE_0);//媒体类型(0 图片)
			advertisingManageModel.setCheckStatus(Contants.AD_CHECK_STATUS_0);//审核状态(0 待审核)
			advertisingManageModel.setIsValid(Contants.AD_IS_VALID_1);//是否有效( 1 是)
			advertisingManageModel.setCreateOperType(Contants.AD_CREATE_OPER_TYPE_1);//创建人类型(1 供应商)
			advertisingManageModel.setCreateOper(advertisingManageModel.getVendorId());//创建人


			Boolean result = advertisingManager.create(advertisingManageModel);
			if (!result) {
				response.setError("create.advertising.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("create.advertising.error", Throwables.getStackTraceAsString(e));
			response.setError("create.advertising.error");
			return response;
		}
	}

	/**
	 * 广告管理编辑(供应商平台) niufw
	 *
	 * @param advertisingManageModel
	 * @return
	 */

	@Override
	public Response<Boolean> update(AdvertisingManageModel advertisingManageModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验
			if (advertisingManageModel == null) {
				response.setError("update.advertising.error");
				return response;
			}
			//待编辑数据整理
			advertisingManageModel.setModifyOperType(Contants.AD_CREATE_OPER_TYPE_1);//修改人类型(1 供应商)
			advertisingManageModel.setCheckStatus(Contants.AD_CHECK_STATUS_0);//审核状态（0 待审核）

			Boolean result = advertisingManager.update(advertisingManageModel);
			if (!result) {
				response.setError("update.advertising.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("update.advertising.error", Throwables.getStackTraceAsString(e));
			response.setError("update.advertising.error");
			return response;
		}
	}
	/**
	 * 通过id取得
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<AdvertisingManageModel> findById(Integer id) {
		Response<AdvertisingManageModel> response = Response.newResponse();
		try {
			AdvertisingManageModel result = advertisingManageDao.findById(id);
			response.setResult(result);
			return response;
		} catch (Exception e) {
			log.error("find.advertising.by.id.error", Throwables.getStackTraceAsString(e));
			response.setError("find.advertising.by.id.error");
			return response;
		}
	}
}
