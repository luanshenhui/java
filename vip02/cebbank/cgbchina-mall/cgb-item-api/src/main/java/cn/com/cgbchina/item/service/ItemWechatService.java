package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.ItemWechatDto;
import cn.com.cgbchina.item.dto.UploadItemWeChatDto;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import java.util.List;

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
	 * @param code
	 * @param name
	 * @param vendorName
	 * @return
	 */
	public Response<Pager<ItemWechatDto>> findAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("code") String code, @Param("name") String name, @Param("vendorName") String vendorName);

	/**
	 * 根据单品code 删除单品（逻辑删除）
	 * 
	 * @param code
	 * @return
	 */
	public Response<Boolean> deleteItemByCode(String code);

	/**
	 * 编辑微信商品（更改排序）
	 * 
	 * @param wxOrder
	 * @return
	 */
	public Response<Boolean> editItemWeChat(Long wxOrder, String code);

	/**
	 * 导入微信商品
	 *
	 * @param models
	 */
	// TODO 错误代码，自己更正
	public Response<Boolean> uploadItemWeChat(List<UploadItemWeChatDto> models)throws Exception;

}
