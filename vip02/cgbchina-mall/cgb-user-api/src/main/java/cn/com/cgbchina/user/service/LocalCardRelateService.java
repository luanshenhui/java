package cn.com.cgbchina.user.service;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.user.model.LocalCardRelateModel;
import com.spirit.common.model.Response;



/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-6-13.
 */
public interface LocalCardRelateService {
	/**
	 * 添加绑定关系
	 * 
	 * @param proCode
	 * @return
	 */
	public Response<Boolean> create(String[] array, String proCode);

	/**
	 * 根据proCode查询对应的所有formatId
	 *
	 * @param proCode
	 * @return
	 */
	public List<LocalCardRelateModel> findFormatIdAll(String proCode);

	/**
	 * 解除绑定关系
	 *
	 * @param localCardRelateModel
	 * @return
	 */
	public Response<Boolean> delete(LocalCardRelateModel localCardRelateModel);

	/**
	 * 根据主键查询结果
	 *
	 * @param formatId
	 * @return
	 */
	public Response<LocalCardRelateModel> findByFormatId(String formatId);

	/**
	 * 根据参数查询列表
	 * @param paramMap 查询参数
	 * @return 结果列表
	 *
	 * geshuo 20160721
	 */
	public Response<List<LocalCardRelateModel>> findLocalCardByParams(Map<String,Object> paramMap);
}
