/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.service;

import java.util.List;

import cn.com.cgbchina.related.model.SmspRecordModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import cn.com.cgbchina.related.model.SmspCustModel;
import cn.com.cgbchina.related.model.SmspInfModel;
import cn.com.cgbchina.related.model.SmspMdlModel;

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
	public Response<Pager<SmspInfModel>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("id") String id, @Param("status") String status);

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
	 * 内管短信模板审核 niufw
	 *
	 * @param id
	 * @return
	 */
	public Response<Boolean> smsTemplateCheck(Long id);

	/**
	 * 内管短信模板拒绝 niufw
	 *
	 * @param id
	 * @return
	 */
	public Response<Boolean> smsTemplateRefuse(Long id);

	/**
	 * 短信模板管理批量提交 niufw
	 *
	 * @param smspInfModelList
	 * @return
	 */
	public Response<Integer> submitAll(List<SmspInfModel> smspInfModelList);

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
			@Param("id") Long id);

	/**
	 * 查询短信信息 niufw
	 * 
	 * @param smspId
	 * @return
	 */
	public Response<SmspMdlModel> findSmspMess(String smspId);

	/**
	 * 插入名单数据 niufw
	 * 
	 * @param smspCustModelList
	 * @return
	 */
	public Response<List<SmspCustModel>> createCust(List<SmspCustModel> smspCustModelList,Long id,String createOper,String filePath);

	/**
	 * 根据短信维护表id查询所有名单
	 * 
	 * @param id
	 * @return
	 */
	public Response<List<SmspCustModel>> findSmspCustById(Long id);

	/**
	 * 查询导入结果 niufw
	 *
	 * @return
	 */
	public Response<Pager<SmspRecordModel>> findImportResult(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
													  @Param("id") Long id);

}
