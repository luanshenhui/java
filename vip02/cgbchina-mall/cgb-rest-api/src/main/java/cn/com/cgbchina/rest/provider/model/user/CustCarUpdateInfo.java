package cn.com.cgbchina.rest.provider.model.user;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class CustCarUpdateInfo extends BaseEntity implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 6398126344599289160L;
	private String id;
	private String itemCode;
	private String goodsNum;
	private String goodsId;
	private String goodsType;
	private String promotionId;
	private String periodId;
	private String goodsName;
}
