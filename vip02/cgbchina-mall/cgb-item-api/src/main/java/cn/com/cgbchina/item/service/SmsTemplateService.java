/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.SmspInfDto;
import cn.com.cgbchina.item.model.SmspCustModel;
import cn.com.cgbchina.item.model.SmspInfModel;
import cn.com.cgbchina.item.model.SmspMdlModel;
import cn.com.cgbchina.item.model.SmspRecordModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import java.util.List;
import java.util.Map;

/**
 * @author niufw
 * @version 1.0
 * @since 16-6-20.
 */
public interface SmsTemplateService {
	/**
	 * 内管短信模板分页查询 niufw
	 *
	 * @param pageNo
	 * @param size
	 * @param id
	 * @param status
	 * @return
	 */
	public Response<Pager<SmspInfDto>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("id") String id, @Param("status") String status, @Param("type") String type);

	/**
	 * 内管短信模板添加 niufw
	 *
	 * @param smspInfModel
	 * @return
	 */

	public Response<Boolean> create(SmspInfModel smspInfModel);

	/**
	 * 内管短信模板编辑 niufw
	 *
	 * @param smspInfModel
	 * @return
	 */
	public Response<Boolean> update(SmspInfModel smspInfModel);

	/**
	 * 内管短信模板删除 niufw
	 *
	 * @param id
	 * @return
	 */
	public Response<Boolean> delete(Long id);

	/**
	 * 内管短信模板提交 niufw
	 *
	 * @param id
	 * @return
	 */
	public Response<Boolean> submit(Long id);

	/**
	 *
	 * 状态更新
	 * 
	 * @param smspInfModel 更新对象
	 * @return Boolean
	 */
	public Response<Boolean> updateStatus(SmspInfModel smspInfModel);

	/**
	 * 内管短信模板拒绝 niufw
	 *
	 * @param id
	 * @return
	 */
	// public Response<Boolean> smsTemplateRefuse(Long id);

	/**
	 * 短信模板管理批量提交 niufw
	 *
	 * @param smspInfModelList
	 * @return
	 */
	public Response<String> submitAll(List<SmspInfModel> smspInfModelList);

	/**
	 * 短信模板管理批量删除 niufw
	 *
	 * @param smspInfModelList
	 * @return
	 */
	public Response<Integer> deleteAll(List<SmspInfModel> smspInfModelList);

	/**
	 * 查询所有的短信模板 niufw
	 *
	 * @return
	 */
	public Response<List<SmspMdlModel>> findAllSmsTemplate();

	/**
	 * 查询所有的短信客户群(名单预览) niufw
	 *
	 * @return
	 */
	public Response<Pager<SmspCustModel>> findByPager(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("id") Long id, @Param("userType") Integer userType);

	/**
	 * 查询短信信息 niufw
	 * 
	 * @param smspId
	 * @return
	 */
	public Response<SmspMdlModel> findSmspMess(String smspId);

	/**
	 * 短信模板审核白名单添加 niufw
	 * 
	 * @param smspCustModel
	 * @return
	 */
	public Response<Boolean> addNameForAudit(SmspCustModel smspCustModel);

	/**
	 * 查询导入结果 niufw
	 *
	 * @return
	 */
	public Response<Pager<SmspRecordModel>> findImportResult(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("id") Long id);

	/**
	 * 审核页面白名单管理批量删除 niufw
	 *
	 * @param smspCustModelList
	 * @return
	 */
	public Response<Integer> deleteNameForAudit(List<SmspCustModel> smspCustModelList);

	/**
	 * 审核页面短信发送
	 * 
	 * @param dto
	 * @return BaseResult
	 */
	public Response<Boolean> sendMessage(SmspInfDto dto);

	/**
	 * 按电话查询
	 *
	 * @param phone
	 * @return
	 */
	Response<List<SmspCustModel>> findAllByPhone(@Param("pageNo") String phone);

	Response<Map> findAllById(String smspId);

	Response<SmspInfModel> findAllByIds(List<String> ids);

	Response<Boolean> createRecord(SmspRecordModel smspRecordModel);
}
