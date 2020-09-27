package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import javax.annotation.Nullable;
import java.io.Serializable;

public class BrandAuthorizeModel implements Serializable {


	private static final long serialVersionUID = 8891309541402581235L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private Long goodsBrandId;// 品牌id
	@Getter
	@Setter
	private String ordertypeId;// 业务类型代码YG：广发JF：积分
	@Getter
	@Setter
	@Nullable
	private String brandName;// 品牌名称
	@Getter
	@Setter
	private String brandImage;// 品牌图片goods_brand+上传图片的扩展名
	@Getter
	@Setter
	private String brandAuthorizeImage;// 资质图片
	@Getter
	@Setter
	private String brandStatus;// 品牌状态0启用1禁用
	@Getter
	@Setter
	private java.util.Date startTime;// 生效时间
	@Getter
	@Setter
	private java.util.Date endTime;// 失效时间
	@Getter
	@Setter
	private java.util.Date noauthorizeNotifyTime;// 授权提醒发送时间，用于将过期品牌消息提醒
	@Getter
	@Setter
	private String vendorId;// 供应商id
	@Getter
	@Setter
	private String approverId;// 审核人id
	@Getter
	@Setter
	private String approveMemo;// 审核意见
	@Getter
	@Setter
	private String approveState;// 审核状态00待审核01审核通过02审核拒绝
	@Getter
	@Setter
	private String delFlag;// del_flag 逻辑删除标识0未删除1已删除
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
	@Getter
	@Setter
	private String approveDiff;// 审核数据
}