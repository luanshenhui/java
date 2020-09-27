package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 11141021040453 on 16-4-15. 单纯设置某种商品的虚拟属性
 */
@Deprecated
public class Merchandise implements Serializable {
	private static final long serialVersionUID = -8612608892608953765L;
	@Getter
	@Setter
	private String id;// 单品ID

	@Getter
	@Setter
	private String pictureUrl;// 图片路径

	@Getter
	@Setter
	private String name;// 商品名

	@Getter
	@Setter
	private String color;// 颜色

	@Getter
	@Setter
	private String rom;// 内存
}
