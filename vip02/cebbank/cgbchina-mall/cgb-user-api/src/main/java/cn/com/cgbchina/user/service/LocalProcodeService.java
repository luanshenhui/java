package cn.com.cgbchina.user.service;


import cn.com.cgbchina.user.dto.LocalProcodeDto;
import cn.com.cgbchina.user.model.LocalProcodeModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;



/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/6/6.
 */
public interface LocalProcodeService {
	Response<Pager<LocalProcodeModel>> findAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size);

	/**
	 *
	 * @param proCode
	 * @return
	 */
	public Response<LocalProcodeModel> findByProCode(String proCode);

	/**
	 * 添加白金卡等级
	 * 
	 * @param localProcodeModel
	 * @return
	 */
	public Response<Boolean> create(LocalProcodeModel localProcodeModel);

	/**
	 * 删除白金卡等级
	 * 
	 * @param localProcodeModel
	 * @return
	 */
	public Response<Boolean> delete(LocalProcodeModel localProcodeModel);

	/**
	 * 更新白金卡等级
	 * 
	 * @param localProcodeModel
	 * @return
	 */
	public Response<Boolean> update(Long id, final LocalProcodeModel localProcodeModel);

	/**
	 * 服务承诺名称校验
	 * 
	 * @param proCode
	 * @param proNm
	 * @return
	 */
	public Response<LocalProcodeDto> findNameByName(String proCode, String proNm, Long id);
}
