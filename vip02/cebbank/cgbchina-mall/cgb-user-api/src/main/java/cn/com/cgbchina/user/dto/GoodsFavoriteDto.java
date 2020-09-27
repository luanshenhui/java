package cn.com.cgbchina.user.dto;

import cn.com.cgbchina.user.model.MemberGoodsFavoriteModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 张成 on 16-4-28.
 */
public class GoodsFavoriteDto extends MemberGoodsFavoriteModel implements Serializable {

	private static final long serialVersionUID = 7999227826143662653L;

	@Getter
	@Setter
	private String count;// 热门交易TOP10交易数

}
