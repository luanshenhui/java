package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.GoodsDetailDto;
import cn.com.cgbchina.item.model.GoodsModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * Created by 张成 on 16-4-26.
 */
public interface VendorGoodsService {
	/**
	 * 查找供应商各种状态的商品数
	 * 
	 * @return 各种商品状态的个数
	 */
	public Response<GoodsDetailDto> find(@Param("user") User user);
}
