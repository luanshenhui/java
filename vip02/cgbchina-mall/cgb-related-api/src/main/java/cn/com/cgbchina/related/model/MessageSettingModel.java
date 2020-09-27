package cn.com.cgbchina.related.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class MessageSettingModel implements Serializable {

    private static final long serialVersionUID = -4650651089770048318L;
    @Getter
	@Setter
	private Long id;// id
	@Getter
	@Setter
	private String swichType;// 开关类型 0：商城公告显示开关 1：短信发送开关 2：支付开关
	@Getter
	@Setter
	private String isOpen;// 是否打开 0：打开 1：关闭
	@Getter
	@Setter
	private String delFlag;// 逻辑删除标记 0：未删除 1：已删除
	@Getter
	@Setter
	private String createOper;// 创建人
	@Getter
	@Setter
	private String modifyOper;// 更新人
	@Getter
	@Setter
	private java.util.Date modifyTime;// 更新时间
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
}