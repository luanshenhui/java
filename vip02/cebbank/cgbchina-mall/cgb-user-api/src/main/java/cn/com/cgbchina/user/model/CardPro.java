package cn.com.cgbchina.user.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class CardPro implements Serializable {

	private static final long serialVersionUID = -3375094088827536915L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String cardproNm;// 卡产品名称
	@Getter
	@Setter
	private String cardLevel;// 卡等级
	@Getter
	@Setter
	private String cardDesc;// 卡描述
	@Getter
	@Setter
	private String cardBin;// card_bin
	@Getter
	@Setter
	private String bankNm;// 分行
	@Getter
	@Setter
	private String relacardNo;// 联名卡代号
	@Getter
	@Setter
	private String formatId;// 卡版代号
	@Getter
	@Setter
	private String pdtNbr;// 卡类
	@Getter
	@Setter
	private String bankNo;// 分行号
	@Getter
	@Setter
	private String plan1;// 推广计划1
	@Getter
	@Setter
	private String plan2;// 推广计划2
	@Getter
	@Setter
	private String plan3;// 推广计划3
	@Getter
	@Setter
	private String plan4;// 推广计划4
	@Getter
	@Setter
	private String plan5;// 推广计划5
	@Getter
	@Setter
	private String bounsType;// 积分类型
	@Getter
	@Setter
	private String bounsFlat;// 是否合作方积分
	@Getter
	@Setter
	private String comPeople;// 联系人
	@Getter
	@Setter
	private String comTel;// 联系方式
	@Getter
	@Setter
	private String cardLevelId;// 卡等级id
	@Getter
	@Setter
	private String createOper;// 创建操作员id
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 修改操作员id
	@Getter
	@Setter
	private java.util.Date modifyTime;// 修改时间
	@Getter
	@Setter
	private String delFlag;// 逻辑删除标示0未删除1已删除
	@Getter
	@Setter
	private Integer isBinding;// 是否绑定白金卡等级 默认0未绑定 1已绑定

}