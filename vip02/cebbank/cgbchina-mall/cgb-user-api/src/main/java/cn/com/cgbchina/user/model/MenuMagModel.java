package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class MenuMagModel implements Serializable {

	private static final long serialVersionUID = -6151461503308422358L;
	@Getter
	@Setter
	private Long id;// 资源编码
	@Getter
	@Setter
	private String name;// 资源名称
	@Getter
	@Setter
	private String link;// 链接
	@Getter
	@Setter
	private Integer sort;// 排序
	@Getter
	@Setter
	private Long pid;// 父节点ID
	@Getter
	@Setter
	private String memuType;// 资源类型（0按钮，1菜单）
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
	@Getter
	@Setter
	private Integer delFlag;// 逻辑删除标记 0：未删除 1：已删除
	@Getter
	@Setter
	private String icon;// 图标
	@Getter
	@Setter
	private String dataPaths;//
	@Getter
	@Setter
	private String isEnabled;
    @Getter
    @Setter
    private String alias;

}