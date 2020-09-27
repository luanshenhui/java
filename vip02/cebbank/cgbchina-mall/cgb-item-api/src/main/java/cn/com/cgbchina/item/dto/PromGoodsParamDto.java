package cn.com.cgbchina.item.dto;

import java.io.Serializable;
import java.util.List;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.ServicePromiseModel;
import lombok.Getter;
import lombok.Setter;

/**
 * Created by wang on 2016/6/24.
 */
public class PromGoodsParamDto implements Serializable {

	private static final long serialVersionUID = -8416882697231628759L;
	@Getter
	@Setter

	private String vendorId; // 供应商ID

	@Getter
	@Setter
	private String vendorName; // 供应商名称

	@Getter
	@Setter
	private String goodsName; // 商品名

	@Getter
	@Setter
	private String brandName;// 品牌

	@Getter
	@Setter
	private String backCategory1; //一级类目

	@Getter
	@Setter
	private String backCategory2; //二级类目

	@Getter
	@Setter
	private String backCategory3;	//三级类目

	@Getter
	@Setter
	private String count;		// 结果数量上限（空值表示无上限）

	@Getter
	@Setter
	private String ruledOut; //排除单品（需要从结果中排除的单品 例 10001，10002）
}
