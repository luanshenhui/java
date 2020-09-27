package cn.com.cgbchina.rest.provider.vo.user;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class CustCarUpdateInfoVO extends BaseEntityVO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 6398126344599289160L;
	@NotNull
	private String id;
	@NotNull
	@XMLNodeName("goods_num")
	private String goodsNum;
	@XMLNodeName("goods_id")
	private String goodsId;
	@XMLNodeName("goods_type")
	private String goodsType;
	@XMLNodeName("item_code")
	private String itemCode;
	@XMLNodeName("promotion_id")
	private String promotionId;
	@XMLNodeName("period_id")
	private String periodId;
	@XMLNodeName("goods_name")
	private String goodsName;
}
