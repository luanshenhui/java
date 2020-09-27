/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import cn.com.cgbchina.related.manager.EsphtmInfManager;
import org.springframework.stereotype.Service;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;

import cn.com.cgbchina.related.dao.EsphtmInfDao;
import cn.com.cgbchina.related.dto.EsphtmInfDto;
import cn.com.cgbchina.related.model.EsphtmInfModel;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.service.VendorService;
import lombok.extern.slf4j.Slf4j;

/**
 * @author wusy
 * @version 1.0
 * @Since 2016/7/13.
 */
@Service
@Slf4j
public class HtmlUploadServiceImpl implements HtmlUploadService {

	@Resource
	private EsphtmInfDao esphtmInfDao;// 静态页面上传表
	@Resource
	private EsphtmInfManager esphtmInfManager;
	@Resource
	private VendorService vendorService;

	/**
	 * 静态页面上传查询列表
	 * 
	 * @param pageNo 页数
	 * @param size 每页条数
	 * @param actId 静态页面编码
	 * @param ordertypeId 业务代码
	 * @param actName 页面名称
	 * @param pageType 页面类型
	 * @param oper 上传者
	 * @return 页面数据
	 */
	@Override
	public Response<Pager<EsphtmInfDto>> find(Integer pageNo, Integer size, String actId, String ordertypeId,
			String actName, String pageType, String oper, User user) {
		Response<Pager<EsphtmInfDto>> result = new Response<Pager<EsphtmInfDto>>();
		Pager<EsphtmInfDto> pagerDto = new Pager<EsphtmInfDto>();
		List<EsphtmInfDto> pagerList = new ArrayList<EsphtmInfDto>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> param = Maps.newHashMap();
		try {
			// 加参数
			param.put("delFlag", 0);
			if (StringUtils.isNotEmpty(actId)) {
				param.put("actId", actId);
			}
			if (StringUtils.isNotEmpty(ordertypeId)) {
				param.put("ordertypeId", ordertypeId);
			}
			if (StringUtils.isNotEmpty(actName)) {
				param.put("actName", actName);
			}
			if (StringUtils.isNotEmpty(pageType)) {
				param.put("pageType", pageType);
			}
			if (StringUtils.isNotEmpty(oper)) {
				param.put("oper", oper);
			}
			if (StringUtils.isNotEmpty(user.getVendorId())) {
				param.put("vendorId", user.getVendorId());
			}
			// 获取分页数据
			Pager<EsphtmInfModel> pager = esphtmInfDao.findByPage(param, pageInfo.getOffset(), pageInfo.getLimit());
			if(pager != null){
				for (EsphtmInfModel esphtmInfModel : pager.getData()) {
					EsphtmInfDto esphtmInfDto = new EsphtmInfDto();
					if (StringUtils.isNotEmpty(esphtmInfModel.getVendorId())) {
						Response<VendorInfoDto> response = vendorService.findById(esphtmInfModel.getVendorId());
						if(!response.isSuccess()){
							continue;
						}
						BeanMapper.copy(esphtmInfModel, esphtmInfDto);
						esphtmInfDto.setSimpleName(response.getResult().getSimpleName());
						pagerList.add(esphtmInfDto);
					} else {
						BeanMapper.copy(esphtmInfModel, esphtmInfDto);
						esphtmInfDto.setSimpleName("内管");
						pagerList.add(esphtmInfDto);
					}
				}
				pagerDto.setData(pagerList);
				pagerDto.setTotal(pager.getTotal());
			}


			// 没有数据
			if (pager == null) {
				result.setResult(new Pager<EsphtmInfDto>(0L, Collections.<EsphtmInfDto> emptyList()));
				return result;
			}
			// 数据成功
			result.setResult(pagerDto);
			result.setSuccess(true);
			return result;
		} catch (Exception e) {
			log.error("html.find.error,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("html.find.error");
			return result;
		}
	}

	/**
	 * 通过静态页
	 * 
	 * @param esphtmInfModel 静态页面信息
	 * @return Response
	 */
//	@Override
//	public Response auditHtml(EsphtmInfModel esphtmInfModel) {
//		Response response = new Response();
//		try {
//
//			// 更新通过，状态变为待发布]
//			Boolean bool = esphtmInfManager.update(esphtmInfModel) != 1;
//			if (bool) {
//				// 没更新成功
//				log.error("pass html error");
//				response.setError("pass.html.error");
//				return response;
//			}
//			response.setSuccess(true);
//			return response;
//		} catch (Exception e) {
//			log.error("pass html error,cause:{}", Throwables.getStackTraceAsString(e));
//			response.setError("pass.html.error");
//			return response;
//		}
//	}

	/**
	 * 拒绝静态页
	 * 
	 * @param esphtmInfModel 静态页面信息
	 * @return
	 */
//	@Override
//	public Response refuseHtml(EsphtmInfModel esphtmInfModel) {
//		Response response = new Response();
//		try {
//
//			// 更新拒绝，状态变为审核拒绝
//			Boolean bool = esphtmInfManager.updatePublishStatus(esphtmInfModel) != 1;
//			if (bool) {
//				// 没更新成功
//				log.error("refuse html error");
//				response.setError("refuse.html.error");
//				return response;
//			}
//			response.setSuccess(true);
//			return response;
//		} catch (Exception e) {
//			log.error("refuse html error,cause:{}", Throwables.getStackTraceAsString(e));
//			response.setError("refuse.html.error");
//			return response;
//		}
//	}

	/**
	 * 发布静态页
	 *
	 * @param esphtmInfModel 静态页面信息
	 * @return
	 */
	@Override
	public Response update(EsphtmInfModel esphtmInfModel) {
		Response response = new Response();
		try {

			// 更新拒绝，状态变为审核拒绝
			Boolean bool = esphtmInfManager.update(esphtmInfModel) != 1;
			if (bool) {
				// 没更新成功
				log.error("html publish error");
				response.setError("html.publish.error");
				return response;
			}
			response.setSuccess(true);
			return response;
		} catch (Exception e) {
			log.error("publish html error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("html.publish.error");
			return response;
		}
	}

	/**
	 * 指派静态页
	 * 
	 * @param esphtmInfModel 静态页面信息
	 * @return
	 */
	@Override
	public Response assignHtml(EsphtmInfModel esphtmInfModel) {
		Response<Boolean> response = Response.newResponse();
		try {

			// 更新指定人
			Boolean bool = esphtmInfManager.updateVendorId(esphtmInfModel) != 1;
			if (bool) {
				// 没更新成功
				log.error("assign html error");
				response.setError("assign.html.error");
				return response;
			}
			response.setResult(true);
			return response;
		} catch (Exception e) {
			log.error("assign html error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("assign.html.error");
			return response;
		}
	}

	/**
	 * 新建静态页
	 * 
	 * @param esphtmInfModel 静态页面信息
	 * @return Response
	 */
	@Override
	public Response createHtml(EsphtmInfModel esphtmInfModel) {
		Response response = new Response();
		try {
			// 新建静态页
			Boolean bool = esphtmInfManager.create(esphtmInfModel) != 1;

			if (bool) {
				// 新建没成功
				log.error("create html error");
				response.setError("create.html.error");
				return response;
			}
			response.setSuccess(true);
			return response;
		} catch (Exception e) {
			log.error("create html error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("create.html.error");
			return response;
		}
	}

	/**
	 * 上传静态页
	 * 
	 * @param esphtmInfModel 静态页面信息
	 * @return Response
	 */
	@Override
	public Response updateHtml(EsphtmInfModel esphtmInfModel) {
		Response response = new Response();
		try {
			// 上传静态页
			Boolean bool = esphtmInfManager.update(esphtmInfModel) != 1;
			if (bool) {
				// 新建没成功
				log.error("update html error");
				response.setError("update.html.error");
				return response;
			}
			response.setSuccess(true);
			return response;
		} catch (Exception e) {
			log.error("update html error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("update.html.error");
			return response;
		}
	}

	/**
	 * 查询将要过期和已过期的数据
	 * 
	 * @param esphtmInfModel 静态页面信息
	 * @return 将要过期和已过期的数据
	 */
	@Override
	public Response<List<EsphtmInfModel>> findEndHtml(EsphtmInfModel esphtmInfModel) {
		Response<List<EsphtmInfModel>> response = new Response<List<EsphtmInfModel>>();
		try {
			List<EsphtmInfModel> list = esphtmInfDao.findEndHtml(esphtmInfModel);
			response.setResult(list);
			return response;
		} catch (Exception e) {
			log.error("findEndHtml html error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("findEndHtml.html.error");
			return response;
		}
	}

	/**
	 * 查询静态页面信息
	 *
	 * @param esphtmInfModel 静态页面信息
	 * @return 静态页面信息
	 */
	@Override
	public Response<EsphtmInfModel> findByActId(EsphtmInfModel esphtmInfModel) {
		Response<EsphtmInfModel> response = new Response<EsphtmInfModel>();
		try {
			EsphtmInfModel model = esphtmInfDao.findById(esphtmInfModel.getActId());
			response.setResult(model);
			return response;
		} catch (Exception e) {
			log.error("find html by actId error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("html.find.error");
			return response;
		}
	}

	@Override
	public Response<Boolean> delByActId(String actId){
		Response<Boolean> response = Response.newResponse();
		boolean flag = esphtmInfManager.delByActId(actId);
		if(flag)
			response.setResult(Boolean.TRUE);
		return response;
	}
}
