package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.model.EspCustNewModel;
import com.spirit.common.model.Response;

import java.util.Map;

/**
 * @author
 * @version 1.0
 * @Since 2016/6/6.
 */
public interface EspCustNewService {

	/**
	 * 通过Id查询
	 *
	 * @param custId
	 * @return
	 */
	public Response<EspCustNewModel> findById(String custId);

	/**
	 * 更新
	 *
	 * @param espCustNewModel
	 * @return
	 */
	public Response<Integer> update(EspCustNewModel espCustNewModel);

	/**
	 * 更新使用生日次数
	 *
	 * @param custId
	 * @return
	 */
	public Response<Integer> updateBirthUsedCount(String custId);

	/**
	 * 获取生日价剩余兑换次数
	 * 
	 * @param custId 客户号
	 * @return 剩余次数
	 *
	 *         geshuo 20160721
	 */
	public Response<Integer> findBirthAvailableCount(String custId, Integer birthdayLimit);

	/**
	 * 更新数据
	 * 
	 * @param espCustNewModel 生日价使用次数信息表数据
	 * @return 是否成功
	 */
	public Response insOrUpdCustNew(EspCustNewModel espCustNewModel);

	/**
	 * 更新生日价使用次数
	 * 
	 * @param custId 会员ID
	 * @return 是否成功
	 */
	public Response updBirthUsedCount(String custId);

	/**
	 * 根据参数更新生日价使用次数
	 * 
	 * @param paramMap 更新参数
	 * @return 更新结果
	 *
	 *         geshuo 20160824
	 */
	Response<Integer> updateCustNewByParams(Map<String, Object> paramMap);

	/**
	 * 查询生日次数并更新
	 * 
	 * @param certNbr 证件号码
	 * @param custId 客户号
	 * @return 查询结果
	 *
	 *         geshuo 20160824
	 */
	Response<Map<String, Object>> getBirthUsedCount(String certNbr, String custId);
}
