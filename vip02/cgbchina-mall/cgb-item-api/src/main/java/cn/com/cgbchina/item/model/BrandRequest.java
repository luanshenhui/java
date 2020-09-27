package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class BrandRequest implements Serializable {

	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private String ordertypeId;// 业务类型代码yg：广发jf：积分
	@Getter
	@Setter
	private String goodsBrandName;// 品牌名
	@Getter
	@Setter
	private String goodsBrand;// 品牌代码
	@Getter
	@Setter
	private String brandImage;// 品牌图片goods_brand+上传图片的扩展名
	@Getter
	@Setter
	private String brandAuthorizeImage;// 资质图片
	@Getter
	@Setter
	private String vendorId;// 供应商id
	@Getter
	@Setter
	private java.util.Date startTime;// 生效时间
	@Getter
	@Setter
	private java.util.Date endTime;// 失效时间
	@Getter
	@Setter
	private String approveMemo;// 审核意见
	@Getter
	@Setter
	private Integer approveState;// 审核状态
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