package com.cebbank.ccis.cebmall.user.service;

import com.cebbank.ccis.cebmall.user.model.TblParametersModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;

/**
 * @author liuhan
 * @version 1.0
 * @Since 16-6-7.
 */
public interface BusinessService {
	/**
	 * 查询全部启停控制信息
	 *
	 * @param pageNo
	 * @param size
	 * @param parametersType
	 * @param ordertypeId
	 * @return
	 */
	public Response<Pager<TblParametersModel>> findBusinessControlAll(@Param("pageNo") Integer pageNo,
                                                                      @Param("size") Integer size, @Param("parametersType") String parametersType,
                                                                      @Param("ordertypeId") String ordertypeId);

	/**
	 * 修改启动暂停
	 *
	 * @param tblParametersModel
	 * @return
	 */
	public Response<Boolean> update(TblParametersModel tblParametersModel, User user);

	/**
	 * 修改业务话术
	 *
	 * @param tblParametersModel
	 * @return
	 */
	public Response<Boolean> updatePrompt(TblParametersModel tblParametersModel, User user);


	/**
	 * 获取web渠道的登录信息
	 *
	 * @return
	 */
	public Response<List<TblParametersModel>> findByWebLogin();

	/**
	 * MAL501 和 MAL104 接口
	 *
	 * @param ordertypeId
	 * @param sourceId
	 * @return
	 */
	public Response<List<TblParametersModel>> findJudgeQT(String ordertypeId, String sourceId);

	/**
	 * 获取业务启停信息
	 * @param parametersType
	 * @param ordertypeId
	 * @param sourceId
	 * @return  yanjie。cao
	 */
	public Response<List<TblParametersModel>> findParameters(Integer parametersType, String ordertypeId, String sourceId);


}
