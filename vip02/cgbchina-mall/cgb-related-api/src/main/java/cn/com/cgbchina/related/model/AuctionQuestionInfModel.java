package cn.com.cgbchina.related.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class AuctionQuestionInfModel implements Serializable {

	private static final long serialVersionUID = -5317574285132077690L;

	@Getter
	@Setter
	private Long id;// 自增主键
	@Getter
	@Setter
	private Integer type;// 类型(目前只有连接) 1-规则 2-答疑 3-链接
	@Getter
	@Setter
	private String name;// 类型名
	@Getter
	@Setter
	private String linkUrl;// 白名单url
	@Getter
	@Setter
	private Integer delFlag;// 逻辑删除标记 0：未删除 1：已删除
	@Getter
	@Setter
	private String createOper;// 创建人
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 修改人
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
}