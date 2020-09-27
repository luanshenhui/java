package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.dto.MakecheckjobErrorDto;
import cn.com.cgbchina.trade.model.TblMakecheckjobHistoryModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * @author liuhan
 * @version 1.0
 * @Since 16-6-15.
 */
public interface MakecheckjobService {
	/**
	 * 查询对账失败
	 *
	 * @param pageNo
	 * @param size
	 * @param startOpedate
	 * @param endOpedate
	 * @return
	 */
	public Response<Pager<TblMakecheckjobHistoryModel>> find(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("startOpedate") String startOpedate,
			@Param("endOpedate") String endOpedate, @Param("user") User user);

	/**
	 * 查询对账失败异常
	 *
	 * @param pageNo
	 * @param size
	 * @param startOpedate
	 * @param endOpedate
	 * @return
	 */
	public Response<Pager<MakecheckjobErrorDto>> findError(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("startOpedate") String startOpedate,
			@Param("endOpedate") String endOpedate, @Param("user") User user);

	/**
	 * 启动自动
	 *
	 * @param
	 * @return
	 */
	public Response<Integer> onShoudong(String createDateParam);

	/**
	 * 发送
	 *
	 * @param
	 * @return
	 */
	public Response<Integer> renew(String createDateParam, String ip);
}
