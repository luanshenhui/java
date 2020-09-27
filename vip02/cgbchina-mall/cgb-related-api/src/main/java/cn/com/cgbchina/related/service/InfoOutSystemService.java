package cn.com.cgbchina.related.service;

import java.util.List;
import java.util.Map;

import com.spirit.common.model.Response;

import cn.com.cgbchina.related.model.InfoOutSystemModel;

/**
 * @author
 * @version 1.0
 * @Since 2016/6/6.
 */
public interface InfoOutSystemService {
	public Response<Integer> updateInfoByOrderId(InfoOutSystemModel infoOutSystemModel);

	public Response<List<InfoOutSystemModel>> findByOrderId(String orderId);

	public Response<InfoOutSystemModel> validateOrderId(String subOrderNo);

	public Response<Integer> insert(InfoOutSystemModel infoOutSystemModel);

	public Response<Integer> updateValidateCode(InfoOutSystemModel infoOutSystemModel);

	public Response<Integer> insertMsgStatus(InfoOutSystemModel infoOutSystemModel);

	/**
	 * 倒序获取对象集合
	 * @return
	 * @add by yanjie.cao
	 */
	public Response<List<InfoOutSystemModel>> findByOrderIdDesc(String orderId);

	public Response<List<InfoOutSystemModel>> findInfoByValidateStatus(Map<String, Object> paramMap);

	public Response<List<InfoOutSystemModel>> findInfoByOrderId(String orderId);
}
