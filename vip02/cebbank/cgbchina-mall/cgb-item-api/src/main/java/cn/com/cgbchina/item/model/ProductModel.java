package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class ProductModel implements Serializable {

	private static final long serialVersionUID = -6465750382663081139L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String name;// 名称
	@Getter
	@Setter
	private String manufacturer;// 生产厂家
	@Getter
	@Setter
	private String ordertypeId;// 业务类型代码YG：广发JF：积分
	@Getter
	@Setter
	private Long goodsBrandId;// 品牌ID
	@Getter
	@Setter
	private Long backCategory1Id;// 一级后台类目
	@Getter
	@Setter
	private Long backCategory2Id;// 二级后台类目
	@Getter
	@Setter
	private Long backCategory3Id;// 三级后台类目
	@Getter
	@Setter
	private String status;// 产品状态0启用1禁用
	@Getter
	@Setter
	private String createType;// 创建类型0平台创建1自动创建
	@Getter
	@Setter
	private String attribute;// 属性
	@Getter
	@Setter
	private String delFlag;// 逻辑删除标识0未删除1已删除
	@Getter
	@Setter
	private String createOper;// 创建者
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 修改者
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
}