package cn.com.cgbchina.item.service;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import java.util.Map;

/**
 * Created by 张成 on 16-4-27.
 */
public interface AdminTopService {

	/**
	 * 查找广发商城或积分商城的TOP信息， type=YG：广发 type=JF：积分
	 * 
	 * @return Map 三个list
	 */
	public Response<Map<String, Object>> find(@Param("_USER_") User user);

}
