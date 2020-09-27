package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class EspPublishInfModel implements Serializable {

	private static final long serialVersionUID = -1467479370993019829L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String orderTypeId;// 业务类型id
	@Getter
	@Setter
	private String publishType;// 公告类型 00最新公告
	@Getter
	@Setter
	private String publishTitle;// 消息标题
	@Getter
	@Setter
	private String linkHref;// 链接地址
	@Getter
	@Setter
	private String groupCode;//
	@Getter
	@Setter
	private java.util.Date publishDate;// 发布日期
	@Getter
	@Setter
	private java.util.Date expireDate;// 过期日期
	@Getter
	@Setter
	private String publishDesc;// 备注
	@Getter
	@Setter
	private String curStatus;// 当前状态 0101：未启用 0102：已启用
	@Getter
	@Setter
	private String publishStatus;// 发布状态 00：已发布 01：等待审核 21：等待发布
	@Getter
	@Setter
	private String publishContent;// 发布内容
	@Getter
	@Setter
	private String publishAddr;//
	@Getter
	@Setter
	private String createOper;// 创建用户
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 最近修改用户
	@Getter
	@Setter
	private java.util.Date modifyTime;// 最近修改时间
	@Getter
	@Setter
	private Integer delFlag;// 逻辑删除标记 0：未删除 1：已删除
}