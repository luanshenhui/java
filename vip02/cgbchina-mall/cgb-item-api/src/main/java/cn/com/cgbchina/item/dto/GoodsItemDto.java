package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.*;
import cn.com.cgbchina.user.model.VendorInfoModel;
import com.spirit.category.dto.AttributeDto;
import com.spirit.category.model.RichAttribute;
import com.spirit.common.model.Pager;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * Created by Cong on 2016/5/26.
 */
@ToString
@EqualsAndHashCode
public class GoodsItemDto implements Serializable {

    private static final long serialVersionUID = -4695236337565796714L;
    @Getter
    @Setter
    private GoodsModel goodsModel;

    @Getter
    @Setter
    private ItemModel itemModel;

    @Getter
    @Setter
    private ItemGoodsDetailDto itemGoodsDetailDto;

    @Getter
    @Setter
    private Map<String, List<Map<String, String>>> goodAttr;

    @Getter
    @Setter
    private AttributeDto itemAttr;

    @Getter
    @Setter
    private List<ItemModel> itemModelList;

    @Getter
    @Setter
    private List<ItemGoodsDetailDto> itemGoodsDetailDtoList;
    @Getter
    @Setter
    private List<ServicePromiseModel> servicePromiseModelList;
    @Getter
    @Setter
    private Long lastSinglePoint;    //单位积分
    @Getter
    @Setter
    private List<CardScaleDto> cardScaleDtoList;        //卡优惠比例
    @Getter
    @Setter
    private List<TblGoodsPaywayModel> tblGoodsPaywayModels;//支付方式
    @Getter
    @Setter
    private Boolean isSelect;//分期数是否被选中
    @Getter
    @Setter
    private Integer periods;//分期数
    @Setter
    @Getter
    private String pointsTypeName;// 积分类型名
    @Setter
    @Getter
    private Map<String, Object> fictitiousGiftType;//虚拟礼品编号对应值
    @Setter
    @Getter
    private List<RichAttribute> spuAttributes;//产品属性
    @Getter
    @Setter
    private VendorInfoModel vendorInfoModel;//供应商信息
    @Getter
    @Setter
    private Pager<GoodsConsultModel> goodsConsultModelPager;//咨询信息
}
