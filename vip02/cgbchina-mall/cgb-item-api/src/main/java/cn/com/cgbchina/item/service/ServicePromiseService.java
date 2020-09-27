package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.ServicePromiseCheckDto;
import cn.com.cgbchina.item.model.ServicePromiseModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import java.util.List;

public interface ServicePromiseService {

	//通过缓存取得服务承诺
	public Response<ServicePromiseModel> findServicePromiseByid(String promiseid);

	/**
	 * 添加服务承诺
	 * 
	 * @param servicePromiseModel
	 * @return
	 */
	public Response<Boolean> create(ServicePromiseModel servicePromiseModel);

	/**
	 * 删除服务承诺
	 * 
	 * @param servicePromiseModel
	 * @return
	 */
	public Response<Boolean> delete(ServicePromiseModel servicePromiseModel);

	/**
	 * 更新服务承诺
	 * 
	 * @param servicePromiseModel
	 * @return
	 */
	public Response<Boolean> update(String code, final ServicePromiseModel servicePromiseModel);

	/**
	 * 查询服务承诺列表
	 *
	 * @param pageNo
	 * @param size
	 * @param name
	 * @return
	 */
	public Response<Pager<ServicePromiseModel>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("name") String name);

	/**
	 * 服务承诺名称校验
	 * 
	 * @param name
	 * @return
	 */
	public Response<ServicePromiseCheckDto> findNameByName(Long code, String name, Integer sort);

	Response<List<ServicePromiseModel>> findAllebled();

	public  Response<String> findCodeByNames(String names);
}
