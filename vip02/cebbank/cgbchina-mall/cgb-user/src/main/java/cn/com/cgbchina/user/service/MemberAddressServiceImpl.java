/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.user.dao.MemberAddressDao;
import cn.com.cgbchina.user.dto.MemberAddressDto;
import cn.com.cgbchina.user.manager.MemberAddressManager;
import cn.com.cgbchina.user.model.MemberAddressModel;
import lombok.extern.slf4j.Slf4j;

/**
 * @author niufw
 * @version 1.0
 * @since 2016/04/15
 */
@Service
@Slf4j
public class MemberAddressServiceImpl implements MemberAddressService {
	@Resource
	private MemberAddressDao memberAddressDao;
	@Resource
	private MemberAddressManager memberAddressManager;

	/**
	 * 查询某用户所有的收货地址
	 *
	 * @param pageNo
	 * @param size
	 * @param user
	 * @return
	 */
	@Override
	public Response<Pager<MemberAddressModel>> findAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("user") User user) {
		Response<Pager<MemberAddressModel>> response = new Response<Pager<MemberAddressModel>>();
		Map<String, Object> paramMap = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		String custId = user.getCustId();
		if (StringUtils.isNotEmpty(custId)) {
			// 将查询条件放入到paramMap
			paramMap.put("custId", custId);// 会员编号
		}
		try {
			Pager<MemberAddressModel> pager = memberAddressDao.findByPage(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());
			List<MemberAddressModel> memberAddressModels = pager.getData();
			response.setResult(new Pager<MemberAddressModel>(pager.getTotal(), memberAddressModels));
			return response;
		} catch (Exception e) {
			log.error("member.address.query.error", Throwables.getStackTraceAsString(e));
			response.setError("member.address.query.error");
			return response;
		}
	}

	/**
	 * 新增收货地址
	 *
	 * @param memberAddressDto
	 * @return
	 */

	@Override
	public Response<Boolean> create(MemberAddressDto memberAddressDto) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验
			if (memberAddressDto == null) {
				response.setError("memberAddressDto.null");
				response.setSuccess(false);
				return response;
			}
			// 如果新增的地址是默认的，则将该用户下其他的地址设为非默认
			String isDefault = memberAddressDto.getIsDefault();
			String custId = memberAddressDto.getCustId();
			Boolean updateResult = false;
			List<MemberAddressModel> memberAddressModelList = memberAddressDao.findByCustId(custId);
			// 限制最多10条收货地址
			if (memberAddressModelList.size() >= 10) {
				response.setError("create.address.count.error");
				return response;
			}
			// 当新建的收货地址是默认时，将其余的收货地址设为非默认
			if ("0".equals(isDefault)) {
				if (memberAddressModelList != null && memberAddressModelList.size() > 0) {
					for (MemberAddressModel memberAddress : memberAddressModelList) {
						memberAddress.setIsDefault("1");
						updateResult = memberAddressManager.update(memberAddress);
					}
				}
			}
			// 整合区号、座机号、分机号成电话
			String areaCode = memberAddressDto.getAreaCode();
			String telNumber = memberAddressDto.getTelNumber();
			String extNumber = memberAddressDto.getExtNumber();
			String telephone = "";
			if (StringUtils.isNotEmpty(areaCode)) {
				telephone = areaCode;
			}
			if (StringUtils.isNotEmpty(telNumber)) {
				if (StringUtils.isNotEmpty(telephone)) {
					telephone = telephone + "-" + telNumber;
				} else {
					telephone = telNumber;
				}
			}
			if (StringUtils.isNotEmpty(extNumber)) {

				if (StringUtils.isNotEmpty(telephone)) {
					telephone = telephone + "-" + extNumber;
				} else {
					telephone = extNumber;
				}
			}
			memberAddressDto.setTelephone(telephone);
			// 添加
			MemberAddressModel memberAddressModel = new MemberAddressModel();
			BeanMapper.copy(memberAddressDto, memberAddressModel);
			Boolean result = memberAddressManager.create(memberAddressModel);
			if (!result) {
				response.setError("create.address.error");
				response.setSuccess(false);
				return response;
			}
			response.setResult(result && updateResult);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			response.setSuccess(false);
			return response;
		} catch (Exception e) {
			log.error("create.address.error", Throwables.getStackTraceAsString(e));
			response.setError("create.address.error");
			response.setSuccess(false);
			return response;
		}
	}

	/**
	 * 根据收货地址id修改
	 *
	 * @param memberAddressDto
	 * @return
	 */
	@Override
	public Response<Boolean> update(MemberAddressDto memberAddressDto) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验
			if (memberAddressDto == null) {
				response.setError("update.address.error");
				return response;
			}
			// 如果修改的地址是默认的，则将该用户下其他的地址设为非默认
			String isDefault = memberAddressDto.getIsDefault();
			String custId = memberAddressDto.getCustId();
			Boolean updateResult = false;
			if ("0".equals(isDefault)) {
				List<MemberAddressModel> memberAddressModelList = memberAddressDao.findByCustId(custId);
				if (memberAddressModelList != null && memberAddressModelList.size() > 0) {
					for (MemberAddressModel memberAddress : memberAddressModelList) {
						memberAddress.setIsDefault("1");
						updateResult = memberAddressManager.update(memberAddress);
					}
				}
			}
			// 整合区号、座机号、分机号成电话
			String areaCode = memberAddressDto.getAreaCode();
			String telNumber = memberAddressDto.getTelNumber();
			String extNumber = memberAddressDto.getExtNumber();
			String telephone = "";
			if (StringUtils.isNotEmpty(areaCode)) {
				telephone = areaCode;
			}
			if (StringUtils.isNotEmpty(telNumber)) {
				if (StringUtils.isNotEmpty(telephone)) {
					telephone = telephone + "-" + telNumber;
				} else {
					telephone = telNumber;
				}
			}
			if (StringUtils.isNotEmpty(extNumber)) {

				if (StringUtils.isNotEmpty(telephone)) {
					telephone = telephone + "-" + extNumber;
				} else {
					telephone = extNumber;
				}
			}
			memberAddressDto.setTelephone(telephone);
			MemberAddressModel memberAddressModel = new MemberAddressModel();
			BeanMapper.copy(memberAddressDto, memberAddressModel);
			// 编辑
			Boolean result = memberAddressManager.update(memberAddressModel);
			if (!result) {
				response.setError("update.address.error");
				return response;
			}
			response.setResult(result && updateResult);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("update.address.error", Throwables.getStackTraceAsString(e));
			response.setError("update.address.error");
			return response;
		}
	}

	/**
	 * 根据收货地址id删除
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<Boolean> delete(Long id) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验(long型为空校验)
			 if (id == null) {
			 response.setError("delete.address.error");
			 return response;
			 }
			Boolean result = memberAddressManager.delete(id);
			if (!result) {
				response.setError("delete.address.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("delete.address.error", Throwables.getStackTraceAsString(e));
			response.setError("delete.address.error");
			return response;
		}
	}

	/**
	 * 根据收货地址id设置默认
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<Boolean> setDefault(Long id, String custId) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验
			Boolean updateResult = false;
			// 查询该该用户下所有收货地址
			List<MemberAddressModel> memberAddressModelList = memberAddressDao.findByCustId(custId);
			if (memberAddressModelList != null && memberAddressModelList.size() > 0) {
				for (MemberAddressModel memberAddress : memberAddressModelList) {
					// 将该用户所有收货地址设为非默认-1
					memberAddress.setIsDefault(Contants.MALL_ADDRESS_STATUS_1);
					updateResult = memberAddressManager.update(memberAddress);
				}
			}
			// 把该id的收货地址的默认状态改为0 - 默认
			Boolean setDefault = memberAddressManager.setDefault(id);
			response.setResult(setDefault && updateResult);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("default.address.error", Throwables.getStackTraceAsString(e));
			response.setError("default.address.error");
			return response;
		}
	}

	/**
	 * 根据ＩＤ取得地址情报
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<MemberAddressModel> findById(Long id) {
		Response<MemberAddressModel> response = new Response<MemberAddressModel>();
		try {
			MemberAddressModel memberAddressModel = memberAddressDao.findById(id);
			response.setResult(memberAddressModel);
			return response;
		} catch (Exception e) {
			log.error("member.address.query.error", Throwables.getStackTraceAsString(e));
			response.setError("member.address.query.error");
			return response;
		}
	}

	/**
	 * 如果存在默认地址不更新，不存在的话根据收获地址id设置默认
	 *
	 * @param id
	 * @param custId
	 * @return
	 */
	public Response<Boolean> setDefaultNotExists(Long id, String custId) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验
			Boolean updateResult = false;
			Boolean exist = false;
			// 查询该该用户下所有收货地址
			List<MemberAddressModel> memberAddressModelList = memberAddressDao.findByCustId(custId);
			if (memberAddressModelList != null && memberAddressModelList.size() > 0) {
				for (MemberAddressModel memberAddress : memberAddressModelList) {
					if (Contants.MALL_ADDRESS_STATUS_0.equals(memberAddress.getIsDefault())) {
						exist = true;
						break;
					}
				}
			}
			if (exist) {
				response.setResult(true);
			} else {
				if (memberAddressModelList != null && memberAddressModelList.size() > 0) {
					for (MemberAddressModel memberAddress : memberAddressModelList) {
						// 将该用户所有收货地址设为非默认-1
						memberAddress.setIsDefault(Contants.MALL_ADDRESS_STATUS_1);
						updateResult = memberAddressManager.update(memberAddress);
					}
				}
				// 把该id的收货地址的默认状态改为0 - 默认
				Boolean setDefault = memberAddressManager.setDefault(id);
				response.setResult(setDefault && updateResult);
			}
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("setDefaultNotExists.error", Throwables.getStackTraceAsString(e));
			response.setError("setDefaultNotExists.error");
			return response;
		}
	}
}
