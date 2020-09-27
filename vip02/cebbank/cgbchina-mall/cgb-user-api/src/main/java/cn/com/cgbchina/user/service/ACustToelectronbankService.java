package cn.com.cgbchina.user.service;

import com.spirit.Annotation.Param;

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
	public String getUserBirth(@Param("certNo") String certNo);

}
