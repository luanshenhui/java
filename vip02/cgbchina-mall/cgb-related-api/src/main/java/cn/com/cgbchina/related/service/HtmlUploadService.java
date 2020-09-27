package cn.com.cgbchina.related.service;

import java.util.List;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.related.dto.EsphtmInfDto;
import cn.com.cgbchina.related.model.EsphtmInfModel;

/**
 * @author wusy
 * @version 1.0
 * @Since 2016/7/13.
 */

public interface HtmlUploadService {

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
	 * @return 分页信息
	 */
	public Response<Pager<EsphtmInfDto>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("actId") String actId, @Param("ordertypeId") String ordertypeId, @Param("actName") String actName,
			@Param("pageType") String pageType, @Param("oper") String oper, @Param("user") User user);

	/**
	 * 审核 静态页
	 * 
	 * @param esphtmInfModel 静态页面信息
	 * @return 是否成功
	 */
//	public Response auditHtml(EsphtmInfModel esphtmInfModel);

	/**
	 * 拒绝静态页
	 * 
	 * @param esphtmInfModel 静态页面信息
	 * @return 是否成功
	 */
//	public Response refuseHtml(EsphtmInfModel esphtmInfModel);

	/**
	 * 发布静态页
	 *
	 * @param esphtmInfModel 静态页面信息
	 * @return 是否成功
	 */
	public Response update(EsphtmInfModel esphtmInfModel);

	/**
	 * 指派静态页
	 * 
	 * @param esphtmInfModel 静态页面信息
	 * @return 是否成功
	 */
	public Response assignHtml(EsphtmInfModel esphtmInfModel);

	/**
	 * 新建静态页
	 * 
	 * @param esphtmInfModel 静态页面信息
	 * @return 是否成功
	 */
	public Response createHtml(EsphtmInfModel esphtmInfModel);

	/**
	 * 上传静态页
	 * 
	 * @param esphtmInfModel 静态页面信息
	 * @return 是否成功
	 */
	public Response updateHtml(EsphtmInfModel esphtmInfModel);

	/**
	 * 查询将要过期和已过期的数据
	 * 
	 * @param esphtmInfModel 静态页面信息
	 * @return 将要过期和已过期的数据
	 */
	public Response<List<EsphtmInfModel>> findEndHtml(EsphtmInfModel esphtmInfModel);

	/**
	 * 查询静态页面信息
	 *
	 * @param esphtmInfModel 静态页面信息
	 * @return 静态页面信息
	 */
	public Response<EsphtmInfModel> findByActId(EsphtmInfModel esphtmInfModel);

	/**
	 * 删除
	 *
	 * @param actId 静态页面信息
	 * @return 静态页面信息
	 */
	public Response<Boolean> delByActId(String actId);

}
