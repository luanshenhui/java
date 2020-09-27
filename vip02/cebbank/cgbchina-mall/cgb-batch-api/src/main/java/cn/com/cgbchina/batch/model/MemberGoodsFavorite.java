package cn.com.cgbchina.batch.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 会员收藏夹
 * 
 * @author huangcy on 2016年5月31日
 */
public class MemberGoodsFavorite implements Serializable {
	/**
	 * 序号
	 */
	@Getter
	@Setter
	private Integer id;
	/**
	 * 商品编号(广发商城)
	 */
	@Getter
	@Setter
	private String goodsCodeYG;
	/**
	 * 商品名称(广发商城)
	 */
	@Getter
	@Setter
	private String goodsNameYG;
	/**
	 * 次数(广发商城)
	 */
	@Getter
	@Setter
	private Integer timeYG;
	/**
	 * 商品编号(积分商城)
	 */
	@Getter
	@Setter
	private String goodsCodeJF;
	/**
	 * 商品名称(积分商城)
	 */
	@Getter
	@Setter
	private String goodsNameJF;
	/**
	 * 次数(积分商城)
	 */
	@Getter
	@Setter
	private Integer timeJF;
}
