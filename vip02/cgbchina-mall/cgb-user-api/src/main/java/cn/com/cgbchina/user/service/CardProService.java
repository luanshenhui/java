package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dto.CardProDto;
import cn.com.cgbchina.user.model.CardPro;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;
import java.util.Map;

/**
 * Created by 王奇 on 16-6-2.
 */
public interface CardProService {

	/**
	 * 分页查询，收藏列表
	 *
	 * @param pageNo 页码
	 * @param size 条数
	 * @return 结果对象
	 */
	public Response<Pager<CardPro>> findAllCardPro(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
												   @Param("user") User user);

	/**
	 * * 新增/修改卡类卡板信息
	 *
	 * @return
	 */
	public Response<Map<String, Boolean>> changeCardPro(@Param("cardPro") CardPro cardPro, @Param("user") User user);

	/**
	 * * 根据id查询卡类卡板信息
	 *
	 * @return
	 */
	public Response<CardPro> findCardProById(@Param("id") String id);

	/**
	 * * 根据id批量删除卡类卡板信息
	 *
	 * @return
	 */
	public Response<Map<String, Boolean>> delete(@Param("cardIds") String cardIds);

	/**
	 * 更新白金卡绑定状态 绑定时使用
	 *
	 * @param cardPro
	 * @return
	 */
	public Response<Boolean> updateIsBinding(CardPro cardPro);

	/**
	 * 更新白金卡绑定状态 解绑时使用
	 *
	 * @param formatId
	 * @return
	 */
	public Response<Boolean> updateUnBinding(String formatId);

	/**
	 * 获取已绑定的卡板信息
	 *
	 * @param pageNo
	 * @param size
	 * @param proCode
	 * @return
	 */
	public Response<Pager<CardProDto>> findCardProCode(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
													   @Param("proCode") String proCode);

	/**
	 * 根据参数查询
	 * @param paramMap 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160824
	 */
	Response<List<CardPro>> findByParams(Map<String,Object> paramMap);
}
