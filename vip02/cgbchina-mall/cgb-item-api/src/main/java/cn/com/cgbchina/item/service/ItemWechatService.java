package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.ItemWechatDto;
import cn.com.cgbchina.item.dto.UploadItemWeChatDto;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;
import java.util.Map;

/**
 * @author Tanliang
 * @version 1.0
 * @Since 16-6-13.
 */
public interface ItemWechatService {
	/**
	 * 微信商品分页以及查询功能
	 * 
	 * @param pageNo
	 * @param size
	 * @param mid
	 * @param name
	 * @param vendorName
	 * @return
	 */
	public Response<Pager<ItemWechatDto>> findAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("code") String mid, @Param("name") String name, @Param("vendorName") String vendorName);

	/**
	 * 编辑微信商品（更改排序）
	 * 
	 * @param wxOrder
	 * @return
	 */
	public Response<Boolean> editItemWeChat(Long wxOrder, String code);

	/**
	 * 导入---微信商品信息
	 *
	 * @param models 即将操作的数据
	 * @param user 操作人
	 *
	 *  throw Exception 异常抛出
	 */
	public Response<Map<String, Object>> uploadItemWeChat(List<UploadItemWeChatDto> models, User user)
			throws Exception;
	//删除微信商品渠道排序信息
	public Response<Boolean> deleteItemWechate(String itemCode);

}
