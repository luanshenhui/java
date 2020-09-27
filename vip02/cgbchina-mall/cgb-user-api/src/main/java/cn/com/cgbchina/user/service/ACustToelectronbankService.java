package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.model.ACustToelectronbankModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;

import java.util.List;
import java.util.Map;

/**
 * Created by 11141021040453 on 16-4-13.
 */
public interface ACustToelectronbankService {

	/**
	 * 获取用户生日
	 * 
	 * @param certNo
	 * @return
	 */
	public String getUserBirth(@Param("certNo") String certNo, List<String> cardNos);

	/**
	 * 客户信息查询,外部接口调用
	 * @param paramMap 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160721
	 */
	public Response<List<ACustToelectronbankModel>> findCustInfoByParams(Map<String, Object> paramMap);


	public Response<List<ACustToelectronbankModel>> findUserBirthInfo(String certNbr);

	/**
	 * Description : 根据卡号集合 查询商城卡客户信息
	 * @param cards 卡号
	 * @return 返回 Key 为卡号，value 为 客户信息 的集合
	 */
	public Response<Map<String,ACustToelectronbankModel>> findCustsByCards(List<String> cards);

}
