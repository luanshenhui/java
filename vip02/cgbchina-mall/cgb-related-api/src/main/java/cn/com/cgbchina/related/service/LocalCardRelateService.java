package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.model.LocalCardRelateModel;
import com.spirit.common.model.Response;

import java.util.List;

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
	 * Description : 根据卡板id获取
	 * @param formatId
	 * @return
	 */
	public Response<LocalCardRelateModel> findByFormatId(String formatId);
}
