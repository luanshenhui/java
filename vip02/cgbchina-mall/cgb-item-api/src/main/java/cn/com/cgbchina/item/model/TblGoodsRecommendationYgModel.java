package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;

public class TblGoodsRecommendationYgModel implements Serializable {

	private static final long serialVersionUID = 4810274232715844970L;
	@Getter
	@Setter
	private Integer id;// 自增主键
	@Getter
	@Setter
	private Long typePid;// 后台一级类目(商品大类id)
	@Getter
	@Setter
	private String goodsId;// 单品id（商品id）!! 单品code
	@Getter
	@Setter
	private String goodsNm;// 单品名称（商品名称）
	@Getter
	@Setter
	private String goodsOid;// 商品一期编码
	@Getter
	@Setter
	private String goodsMid;// 商品分期编码
	@Getter
	@Setter
	private Integer goodsSeq;// 显示顺序
	@Getter
	@Setter
	private String delFlag;// 删除标志 0-未删除 1-已删除
	@Getter
	@Setter
	private String createOper;// 创建人
	@Getter
	@Setter
	private String createDate;// 创建日期
	@Getter
	@Setter
	private String createTime;// 创建时间
	@Getter
	@Setter
	private String modifyOper;// 修改人
	@Getter
	@Setter
	private String modifyDate;// 修改日期
	@Getter
	@Setter
	private String modifyTime;// 修改时间
	@Getter
	@Setter
	private String keepField1;// 保留字段
	@Getter
	@Setter
	private String keepField2;// 保留字段
	@Getter
	@Setter
	private String keepField3;// 保留字段
}