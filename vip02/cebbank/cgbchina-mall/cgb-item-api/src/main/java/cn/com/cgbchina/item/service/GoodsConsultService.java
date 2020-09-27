package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.GoodsConsultDto;
import cn.com.cgbchina.item.model.GoodsConsultModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;

/**
 * Created by liuhan on 16-4-12.
 */

public interface GoodsConsultService {

	/**
	 * 查询数据
	 *
	 * @param pageNo
	 * @param size
	 * @param isShow
	 * @param goodsName
	 * @return
	 */
	public Response<Pager<GoodsConsultDto>> findConsultAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("isShow") Integer isShow, @Param("goodsName") String goodsName, @Param("user") User user);

	/**
	 * 更改状态，已显示0，已屏蔽1
	 *
	 * @param idsList
	 * @param isShow
	 * @param userName
	 * @return
	 */
	public Response<Boolean> updateIsShowByIds(List<String> idsList, String isShow, String userName);

	/**
	 * 回复功能
	 *
	 * @param goodsConsultModel
	 * @param userName
	 * @return
	 */
	public Response<Boolean> updateReplyContent(GoodsConsultModel goodsConsultModel, String userName);

	/**
	 * 添加咨询
	 *
	 * @param goodsConsultModel
	 * @return
	 */
	public Response<Boolean> insertGoodsConsult(GoodsConsultModel goodsConsultModel);

}
