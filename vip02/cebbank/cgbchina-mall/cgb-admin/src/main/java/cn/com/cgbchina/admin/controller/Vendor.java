/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.admin.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.spirit.exception.UserNotLoginException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.admin.service.EPinService;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.rest.visit.model.user.EEA1InfoResult;
import cn.com.cgbchina.user.dto.MailStagesDto;
import cn.com.cgbchina.user.dto.StageRateDto;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.VendorModel;
import cn.com.cgbchina.user.service.VendorService;
import lombok.extern.slf4j.Slf4j;

/**
 * @author niufw
 * @version 1.0
 * @since 2016/04/15
 */
@Controller
@RequestMapping("/api/admin/mall")
@Slf4j
public class Vendor {
	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	@Autowired
	VendorService vendorService;

	@Autowired
	MessageSources messageSources;

	@Autowired
	GoodsService goodService;

	@Autowired
	private EPinService ePinService;

	/**
	 * 商城合作商添加
	 *
	 * @param vendorInfoDto
	 * @return
	 */
	@RequestMapping(value = "/vendorCreate", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> create(VendorInfoDto vendorInfoDto,HttpServletRequest request,
									HttpServletResponse response) {
		// 从登录信息中获取用户id和用户名称并插入到model中
		 User user = UserUtil.getUser();
		 if ( user == null) {
			 throw  new UserNotLoginException("user.not.login");
		 }
		 String createOper = user.getName();
		 vendorInfoDto.setCreateOper(createOper);
		// 将分期费率的数据整合存入StageRateDto
		String json = vendorInfoDto.getStageRate();
		StageRateDto stageRateDto = jsonMapper.fromJson(json, StageRateDto.class);
		// 将邮购分期的数据整合存入MailStagesDto
		String jsonMailStages = vendorInfoDto.getMailStages();
		MailStagesDto mailStagesDto = jsonMapper.fromJson(jsonMailStages, MailStagesDto.class);
		// 校验
		try {
			// 校验
			// dto转化为Json
			String diffinfoForUpdate = jsonMapper.toJson(vendorInfoDto);
			vendorInfoDto.setDiffinfoForUpdate(diffinfoForUpdate);
			//对一次密码进行加密开始
			VendorModel vendorModel = vendorInfoDto.getVendorModel();
			String password = vendorInfoDto.getPasswordFirst();
			// 校验密码信息
			EEA1InfoResult eEA1InfoResult = ePinService.EEA1(request, password);
			request.getSession().removeAttribute("randomPwd");
			// 密码机不成功返回
			if (!Contants.RETRUN_CODE_000000.equals(eEA1InfoResult.getRetCode())) {
				log.error("pwd.service.error");
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.service.error"));
			}
			vendorModel.setPwfirst(eEA1InfoResult.getPinBlock());
			vendorInfoDto.setVendorModel(vendorModel);
			//对一次密码进行加密结束
			// 新增
			Response<Boolean> result = vendorService.create(vendorInfoDto, stageRateDto, mailStagesDto);
			if(!result.isSuccess()){
				log.error("create.vendor.error，erro:{}",result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}

			return result;
		} catch (IllegalArgumentException e) {
			log.error("create.vendor.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("create.vendor.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("create.vendor.error"));
		}
	}

	/**
	 * 商城合作商编辑
	 *
	 * @param vendorInfoDto
	 * @return
	 */
	@RequestMapping(value = "/vendorUpdate", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> update(VendorInfoDto vendorInfoDto,HttpServletRequest request,
									HttpServletResponse response) {
		// 分期费率和邮购分期删除的id的集合
		List stageRateIdList = jsonMapper.fromJson(vendorInfoDto.getStageRateIdList(), List.class);
		List mailStagesIdList = jsonMapper.fromJson(vendorInfoDto.getMailStagesIdList(), List.class);
		// 将分期费率的数据整合存入StageRateDto
		String json = vendorInfoDto.getStageRate();
		StageRateDto stageRateDto = jsonMapper.fromJson(json, StageRateDto.class);
		// 将邮购分期的数据整合存入MailStagesDto
		String jsonMailStages = vendorInfoDto.getMailStages();
		MailStagesDto mailStagesDto = jsonMapper.fromJson(jsonMailStages, MailStagesDto.class);
		// 校验
		try {
			// 校验
			// dto转化为Json
			String diffinfoForUpdate = jsonMapper.toJson(vendorInfoDto);
			vendorInfoDto.setDiffinfoForUpdate(diffinfoForUpdate);
			//如果一次密码不为空，对一次密码进行加密开始
			String password = vendorInfoDto.getPasswordFirst();
			if(StringUtils.notEmpty(password)){
				VendorModel vendorModel = vendorInfoDto.getVendorModel();
				// 校验密码信息
				EEA1InfoResult eEA1InfoResult = ePinService.EEA1(request, password);
				request.getSession().removeAttribute("randomPwd");
				// 密码机不成功返回
				if (!Contants.RETRUN_CODE_000000.equals(eEA1InfoResult.getRetCode())) {
					log.error("pwd.service.error");
					throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.service.error"));
				}
				vendorModel.setPwfirst(eEA1InfoResult.getPinBlock());
				vendorInfoDto.setVendorModel(vendorModel);
				//对一次密码进行加密结束
			}
			// 更新
			Response<Boolean> result = vendorService.update(vendorInfoDto, stageRateDto, mailStagesDto, stageRateIdList,
					mailStagesIdList);
			if (!result.isSuccess()){
				log.error("update.vendor.error，erro:{}",result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result;
		} catch (IllegalArgumentException e) {
			log.error("update.vendor.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("update.vendor.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("update.vendor.error"));
		}
	}

	/**
	 * 商城合作商删除
	 *
	 * @param vendorId
	 * @return
	 */
	@RequestMapping(value = "/vendorDelete", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> delete(String vendorId) {

		Response<Boolean> result = new Response<Boolean>();
		// 校验
		try {
			// 校验

			// 删除
			Response<Boolean> deleteResult = vendorService.delete(vendorId);
			if (!deleteResult.isSuccess()){
				log.error("delete.vendor.error，erro:{}",result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			// 删除供应商的同时下架产品
			Response<Boolean> updateResult = goodService.updateChannelByVendorId(vendorId);
			if (!updateResult.isSuccess()){
				log.error("update.channel.error，erro:{}",result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			// 删除供应商的同时删除子账户
			Response<Boolean> deleteByParentId = vendorService.deleteByParentId(vendorId);
			if (!deleteByParentId.isSuccess()){
				log.error("delete.son.error，erro:{}",result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}

			if (deleteResult.getResult() == true && updateResult.getResult() == true && deleteByParentId.getResult()) {
				result.setResult(true);
			} else {
				result.setResult(false);
			}
			if (!result.isSuccess()){
				log.error("delete.vendor.error，erro:{}",result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result;
		} catch (IllegalArgumentException e) {
			log.error("delete.vendor.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("delete.vendor.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("delete.vendor.error"));
		}
	}

	/**
	 * 商城合作商审核
	 *
	 * @param vendorId
	 * @param pwsecond
	 * @param refuseDesc
	 * @return
	 */
	@RequestMapping(value = "/vendorCheck", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> vendorCheck(String vendorId, String pwsecond, String refuseDesc, String status,
			String vendorStatus,HttpServletRequest request,HttpServletResponse response) {
		try {
			// 校验
			//对二次密码进行加密开始
			if(StringUtils.notEmpty(pwsecond)){
				// 校验密码信息
				EEA1InfoResult eEA1InfoResult = ePinService.EEA1(request, pwsecond);
				request.getSession().removeAttribute("randomPwd");
				// 密码机不成功返回
				if (!Contants.RETRUN_CODE_000000.equals(eEA1InfoResult.getRetCode())) {
					log.error("pwd.service.error");
					throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.service.error"));
				}
				pwsecond = eEA1InfoResult.getPinBlock();
				//对一次密码进行加密结束
			}else{
				//查询数据库中是否有二次密码
				//逻辑：前台传过来的二次密码为空，数据库中的二次密码也为空，则抛出异常；否则正常执行
				Response<VendorInfoDto> vendorInfoDtoResponse = vendorService.findById(vendorId);
				VendorInfoDto vendorInfoDto = vendorInfoDtoResponse.getResult();
				VendorModel vendorModel = vendorInfoDto.getVendorModel();
				String twoPassword = vendorModel.getPwsecond();
				if(StringUtils.isEmpty(twoPassword)){
					log.error("pwd.control.error");
					throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.control.error"));
				}
			}

			// 审核
			Response<Boolean> updateResult = new Response<Boolean>();
			Response<Boolean> updateByParentId = new Response<Boolean>();
			updateResult.setResult(false);
			updateByParentId.setResult(false);
			Response<Boolean> checkResult = vendorService.vendorCheck(vendorId, pwsecond, refuseDesc);
			// 当修改了供应商状态为未启用且审核成功时将该供应商的产品下架
			if (checkResult.getResult()) {
				if (Contants.VENDOR_COMMON_STATUS_0101.equals(status)) {
					updateResult = goodService.updateChannelByVendorId(vendorId);
					if (!updateResult.isSuccess()){
						log.error("check.vendorInfo.update.channel.error，erro:{}",updateResult.getError());
						throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(updateResult.getError()));
					}
				}
				// 当修改了供应商用户状态为未启用且审核成功时将该供应商的子账户停用,同时将产品下架
				if (Contants.VENDOR_COMMON_STATUS_0101.equals(vendorStatus)) {
					updateByParentId = vendorService.updateByParentId(vendorId);
					if (!updateByParentId.isSuccess()){
						log.error("check.vendor.update.son.error，erro:{}",updateByParentId.getError());
						throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(updateByParentId.getError()));
					}
					updateResult = goodService.updateChannelByVendorId(vendorId);
					if (!updateResult.isSuccess()){
						log.error("check.vendor.update.channel.error，erro:{}",updateResult.getError());
						throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(updateResult.getError()));
					}
				}
			}
			if (!checkResult.isSuccess()){
				log.error("check.vendor.error，erro:{}",checkResult.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(checkResult.getError()));
			}
			return checkResult;

		} catch (IllegalArgumentException e) {
			log.error("check.vendor.error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("check.vendor.error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("check.vendor.error"));
		}
	}

	/**
	 * 商城合作商拒绝
	 *
	 * @param vendorId
	 * @param refuseDesc
	 * @return
	 */
	@RequestMapping(value = "/vendorRefuse", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> vendorRefuse(String vendorId, String refuseDesc) {
		try {
			// 校验

			// 拒绝
			Response<Boolean> result = vendorService.vendorRefuse(vendorId, refuseDesc);
			if (!result.isSuccess()){
				log.error("refuse.vendor.error，erro:{}",result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result;
		} catch (IllegalArgumentException e) {
			log.error("refuse.vendor.error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("refuse.vendor.error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("refuse.vendor.error"));
		}
	}

	/**
	 * 合作商新增校验
	 *
	 * @param vendorId
	 * @param vendorCode
	 * @return
	 */
	@RequestMapping(value = "/vendorCreateCheck", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Integer> vendorCreateCheck(String vendorId, String vendorCode) {
		try {
			Response<Integer> result = vendorService.vendorCreateCheck(vendorId, vendorCode);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("check.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("check.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("check.error"));
		}
	}

	/**
	 * 供应商用户账号管理 启用未启用状态修改
	 *
	 * @param code
	 * @param status
	 * @return
	 */
	@RequestMapping(value = "/changeStatus", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> changeStatus(String code, String status) {
		try {
			// 校验

			// 修改状态
			Response<Boolean> updateResult = vendorService.changeStatus(code, status);
			if (!updateResult.isSuccess()){
				log.error("change.status.error，erro:{}",updateResult.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(updateResult.getError()));
			}
			return updateResult;

		} catch (IllegalArgumentException e) {
			log.error("change.status.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("change.status.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("check.error"));
		}
	}
}
