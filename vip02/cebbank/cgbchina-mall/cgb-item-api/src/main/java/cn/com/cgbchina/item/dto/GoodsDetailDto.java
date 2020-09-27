package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.*;
import cn.com.cgbchina.user.model.MailStagesModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.model.VendorModel;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

public class GoodsDetailDto extends GoodsModel implements Serializable{

	private static final long serialVersionUID = 5773315507668638635L;
	@Getter
	@Setter
	private String goodsCode;// 商品编码
	@Getter
	@Setter
	private String itemCode;// 单品编码
	@Getter
	@Setter
	private String vendorName;// 供应商名称
	@Getter
	@Setter
	private String brandName;// 品牌名称
	@Getter
	@Setter
	private String apprvoeMessage;// 审核意见
	@Getter
	@Setter
	private List<ItemModel> itemList;// 单品list
	@Getter
	@Setter
	private String manufacturer;// 生产厂家
	@Getter
	@Setter
	private List<RecommendGoodsDto> recommendGoodsList;// 关联商品list
	@Getter
	@Setter
	private List<ServicePromiseModel> servicePromiseModelList;// 服务承诺list,新增商品时用到
	@Getter
	@Setter
	private List<VendorInfoModel> vendorInfoList;// 供应商list,新增时用
	@Getter
	@Setter
	private List<MailStagesModel> mailStagesList;// 邮购分期类别码，新增时用
	@Getter
	@Setter
	private VendorModel vendorUser;// 供应商信息，查看时用
	@Getter
	@Setter
	private List<ServicePromiseIsSelectDto> servicePromiseIsSelectList;// 服务承诺选择list，查看商品及新增时会用到
	@Getter
	@Setter
	private List<GoodsBrandModel> brandList;// 品牌列表新增时用
	@Getter
	@Setter
	private String favCount;// 收藏数
	@Getter
	@Setter
	private Integer unSubmitCount;// 未提交审核的商品
	@Getter
	@Setter
	private Integer waitFirstCount;// 待初审核的商品
	@Getter
	@Setter
	private Integer waitSecondCount;// 待复审核的商品
	@Getter
	@Setter
	private Integer waitCount;// 待审核的商品
	@Getter
	@Setter
	private Integer saleCount;// 出售中的商品
	@Getter
	@Setter
	private Integer unPassCount;// 未通过审核的商品
	@Getter
	@Setter
	private Integer deadCount;// 下架的商品
	@Getter
	@Setter
	private Integer brandCount;// 待审核品牌数
	@Getter
	@Setter
	private Integer waitUpCount;// 05待上架数
    @Getter
    @Setter
    private Integer waitDownCount;//待下架数
    @Getter
    @Setter
    private Integer priceCount;//价格审核数
    @Getter
    @Setter
    private Integer changeCount;//价格审核变动数
	@Getter
	@Setter
	private Integer shelfApproveCount;//下架申请审核数量
	@Getter
	@Setter
	private String backCategory1Name;// 第一级后台类目
	@Getter
	@Setter
	private String backCategory2Name;// 第二级后台类目
	@Getter
	@Setter
	private String backCategory3Name;// 第三级后台类目
	@Getter
	@Setter
	private ItemsAttributeDto itemsAttributeDto;// 单品销售属性Dto
	@Getter
	@Setter
	private ItemsAttributeDto goodsAttr;// 商品销售属性及其他属性
	@Getter
	@Setter
	private List<ItemDto> itemDtoList; // 查看商品详情及编辑时用到的单品表格相关信息
	@Getter
	@Setter
	private List<AuditLoggingModel> auditLoggingModelList;// 审核记录list

}
