package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.trade.model.*;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by yanjie.cao on 16-4-26.
 */
public class OrderQueryDto extends OrderSubModel implements Serializable {


	private static final long serialVersionUID = -3591869887193033874L;
	@Getter
	@Setter
	private java.math.BigDecimal per_Stage; //b
	@Getter
	@Setter
	private java.math.BigDecimal goods_Price;//b
	@Getter
	@Setter
	private String is_Action;//b
	@Getter
	@Setter
	private String integral_Type;//c
	@Getter
	@Setter
	private String goods_Picture1;//c
	@Getter
	@Setter
	private String goods_Id;//c
	@Getter
	@Setter
	private String modify_Date;//c
	@Getter
	@Setter
	private String modify_Time;//c
	@Getter
	@Setter
	private String mailing_num;//d
	@Getter
	@Setter
	private java.math.BigDecimal marketPrice;// 市场价格
	@Setter
	@Getter
	private Integer subOrderNum;//子订单数量

}
