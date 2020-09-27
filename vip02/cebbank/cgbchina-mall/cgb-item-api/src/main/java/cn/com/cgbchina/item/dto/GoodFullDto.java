/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/7/8.
 */
public class GoodFullDto implements Serializable{

    @Getter
    @Setter
    private GoodsModel goodsModel; // 商品信息
    @Getter
    @Setter
    private List<ItemDto> itemList; // 单品（skus）
    @Getter
    @Setter
    private ItemDto defaultItem;// 默认显示单品
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
    private Map<String, List<Map<Long, String>>> itemGroup = Collections.emptyMap(); //for dubbo serialization sake

}
