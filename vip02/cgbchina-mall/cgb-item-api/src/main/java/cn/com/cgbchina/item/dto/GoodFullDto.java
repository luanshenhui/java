/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.AuditLoggingModel;
import cn.com.cgbchina.item.model.EspAreaInfModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.model.VendorModel;
import com.spirit.category.model.RichAttribute;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.apache.poi.openxml4j.opc.PackageRelationship;

import java.io.Serializable;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/7/8.
 */
@EqualsAndHashCode
@ToString
public class GoodFullDto implements Serializable{

    private static final long serialVersionUID = -6768568114672710584L;
    @Getter
    @Setter
    private GoodsModel goodsModel; // 商品信息
    @Getter
    @Setter
    private VendorInfoModel vendorInfoModel; // 供应商信息
    @Getter
    @Setter
    private List<ItemModel> itemList; // 单品（skus）
    @Getter
    @Setter
    private ItemModel defaultItem;// 默认显示单品
    @Setter
    @Getter
    private List<TblGoodsPaywayModel> pays;//商品支付方式
    @Getter
    @Setter
    private List<ServicePromiseIsSelectDto> servicePromiseIsSelectList;// 服务承诺选择list，查看商品及新增时会用到
    @Getter
    @Setter
    private List<VendorInfoModel> vendorInfoList;// 供应商list,新增时用
    @Getter
    @Setter
    private Map<String, List<Map<String, String>>> itemGroup = Collections.emptyMap(); //for dubbo serialization sake
    @Getter
    @Setter
    private List<RichAttribute> attributes = Collections.emptyList();



    @Setter
    @Getter
    private String servicePromiseStr;
    @Setter
    @Getter
    private List<RecommendGoodsDto> recommendGoodsList;
    @Setter
    @Getter
    private List<AuditLoggingModel> auditLoggingModelList;
    @Setter
    @Getter
    private String backCategory1Name;
    @Setter
    @Getter
    private String backCategory2Name;
    @Setter
    @Getter
    private String backCategory3Name;
    @Setter
    @Getter
    private String backCategory4Name;
    @Getter
    @Setter
    private EspAreaInfModel espAreaInfModel;
    @Getter
    @Setter
    private TblCfgIntegraltypeModel integralTypeModel;
    @Getter
    @Setter
    private String goodsPaywayDtoJson;
    @Getter
    @Setter
    private TblGoodsPaywayModel goodsPaywayModel;
    @Setter
    @Getter
    private Boolean correctFlag = true;

}
