package cn.com.cgbchina.admin.controller;

import java.util.List;

import javax.validation.Valid;

import cn.com.cgbchina.common.contants.Contants;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.related.dto.TblBankDto;
import cn.com.cgbchina.related.model.TblBankModel;
import cn.com.cgbchina.related.service.BankService;
import lombok.extern.slf4j.Slf4j;

/**
 * 分行管理
 */

@Controller
@RequestMapping("/api/admin/branchMaintenance")
@Slf4j
public class BranchMaintenance {

	@Autowired
	private BankService bankService;
	@Autowired
	private MessageSources messageSources;

	/**
	 * 添加分行
	 * 
	 * @param tblBankDto 添加参数
	 * @param bindingResult 校验结果
	 * @return 添加结果
	 *
	 *         geshuo 20160801
	 */
	@RequestMapping(value = "/add", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> create(@Valid TblBankDto tblBankDto, BindingResult bindingResult) {
		// 判断校验是否成功
		if (bindingResult.hasErrors()) {
			StringBuilder sb = new StringBuilder();
			List<FieldError> fieldErrors = bindingResult.getFieldErrors();
			for (FieldError fieldError : fieldErrors) {
				sb.append(fieldError.getDefaultMessage());
			}
			throw new ResponseException(500, sb.toString());
		}
		User user = UserUtil.getUser();
		String userId = user.getId();

		TblBankModel tblBankModel = new TblBankModel();
		BeanUtils.copyProperties(tblBankDto, tblBankModel);
		tblBankModel.setCreateOper(userId);
		tblBankModel.setModifyOper(userId);
		// 新增分行
		Response<Boolean> result = bankService.create(tblBankModel);
		if (result.isSuccess()) {
			return result;
		}
		log.error("failed to create {},error code:{}", tblBankModel, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 更新分行数据
	 * 
	 * @param tblBankDto 更新参数
	 * @param bindingResult 校验结果
	 * @return 更新结果
	 *
	 *         geshuo 20160802
	 */
	@RequestMapping(value = "/update", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> update(@Valid TblBankDto tblBankDto, BindingResult bindingResult) {

		// 判断校验是否成功
		if (bindingResult.hasErrors()) {
			StringBuilder sb = new StringBuilder();
			List<FieldError> fieldErrors = bindingResult.getFieldErrors();
			for (FieldError fieldError : fieldErrors) {
				sb.append(fieldError.getDefaultMessage());
			}
			throw new ResponseException(500, sb.toString());
		}
		User user = UserUtil.getUser();
		String userId = user.getId();

		TblBankModel tblBankModel = new TblBankModel();
		BeanUtils.copyProperties(tblBankDto, tblBankModel);
		tblBankModel.setCreateOper(userId);
		tblBankModel.setModifyOper(userId);
		// 更新分行
		Response<Boolean> result = bankService.update(tblBankModel);
		if (result.isSuccess()) {
			return result;
		}
		log.error("failed to update {},error code:{}", tblBankModel, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 批量删除分行
	 *
	 * @param id 分行id列表,以逗号分割
	 * @return 删除结果
	 *
	 *         geshuo 20160802
	 */
	@RequestMapping(value = "/deleteBatch", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> deleteBatch(String id) {
		Response<Boolean> response = new Response<>();
		if (StringUtils.isEmpty(id)) {
			// id不能为空
			response.setError("delete.id.notNull");
			throw new ResponseException(500, messageSources.get("delete.id.notNull"));
		}
		User user = UserUtil.getUser();
		String userId = user.getId();

		// 解析id数据
		List<Long> idList = Lists.newArrayList();
		String[] idArray = id.split(",");
		for (String idStr : idArray) {
			if (StringUtils.isNotEmpty(idStr)) {
				idList.add(Long.parseLong(idStr));
			}
		}

		// 开始删除
		Response<Integer> result = bankService.deleteBanks(idList, userId);
		if(!result.isSuccess()){
			log.error("Response.error,error code: {}", result.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
		}
		if (result.getResult() > 0) {
			response.setResult(true);
			return response;
		}
		log.error("failed to delete {},error code:{}", id, result.getError());
		response.setError(messageSources.get(result.getError()));
		throw new ResponseException(500, messageSources.get(result.getError()));
	}
}
