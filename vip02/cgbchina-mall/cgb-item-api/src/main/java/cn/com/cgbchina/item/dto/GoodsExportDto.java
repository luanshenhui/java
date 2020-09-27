package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import com.google.common.base.Strings;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import java.io.Serializable;
import java.util.List;

/**
 * Created by zhangLin on 2016/12/10.
 */

@Getter
@Setter
@ToString
public class GoodsExportDto implements Serializable{

    private static final long serialVersionUID = -2409710372277898349L;
    private String vendorId;//供应商编码

    private String marketPrice;// 市场价格get

    private String price;// 实际价格

    private String stock;// 实际库存

    private String stockWarning;// 库存预警

    private String o2oCode;// o2o商品编码

    private String o2oVoucherCode;// o2o兑换券编码

    private String installmentNumber;// 期数

    private String stagesCode;// 一期邮购分期类别码

    private String fixPoint;// 固定积分

    private String mid;// 商品ID(分期唯一值用于外系统)

    private String xid;// 礼品编码

    private String bid;// 虚拟礼品代号

    private String cardLevelId;// 卡等级编码

    private String image1;//图片1

    private String image2;//图片2

    private String image3;//图片3

    private String image4;//图片4

    private String image5;//图片5

    private String attributeKey1;

    private String attributeName1;

    private String attributeValue1;

    private String attributeKey2;

    private String attributeName2;

    private String attributeValue2;

    private String productId;

    private String name;

    private String isInner;

    private String cards;

    private String goodsType;

    private String mailOrderCode;

    private String adWord;

    private String giftDesc;

    private String serviceType;

    private String recommendGoods;

    private String introduction;

    private String goodsCode;

    private String pointsType; //积分类型

    private String limitCount;//限购数量

    private String regionType ;//分区

    private String brandName;//品牌名称


    private final ImmutableMap<String, String> goodsTypeMap =ImmutableMap.<String,String>builder().put("00","实物").put("01","虚拟").put("02","O2O").build();
    private final ImmutableMap<String, String> isInnerMap = ImmutableMap.of("0", "内宣","1", "非内宣");
    private final ImmutableMap<String, String> cardLevelMap = ImmutableMap.<String,String>builder().put("00", "无限制").put("01", "普卡").put("02", "金卡").put("03", "钛金卡").put("04", "臻享白金卡").put("05", "增值白金卡").put("06", "顶级卡").build();


    public void copyItemModel(ItemModel itemModel){
        this.marketPrice= nullToString(itemModel.getMarketPrice());// 市场价格get
        this.price = nullToString(itemModel.getPrice());// 实际价格
        this.stock = nullToString(itemModel.getStock());// 实际库存
        this.stockWarning = nullToString(itemModel.getStockWarning());
        this.o2oCode = nullToString(itemModel.getO2oCode());// o2o商品编码
        this.o2oVoucherCode = nullToString(itemModel.getO2oVoucherCode());// o2o兑换券编码
        this.installmentNumber = nullToString(itemModel.getInstallmentNumber());// 最高期数
        this.stagesCode = itemModel.getStagesCode();// 一期邮购分期类别码
        this.fixPoint = nullToString(itemModel.getFixPoint());// 固定积分
        this.mid = nullToString(itemModel.getMid());// 商品ID(分期唯一值用于外系统)
        this.xid = nullToString(itemModel.getXid());// 礼品编码
        this.bid = nullToString(itemModel.getBid());// 虚拟礼品代号
        this.cardLevelId = itemModel.getCardLevelId();// 卡等级编码
        this.attributeKey1 = itemModel.getAttributeKey1();
        this.attributeName1 = itemModel.getAttributeName1();
        this.attributeValue1 = itemModel.getAttributeValue1();
        this.attributeKey2 = itemModel.getAttributeKey2();
        this.attributeName2 = itemModel.getAttributeName2();
        this.attributeValue2 = itemModel.getAttributeValue2();
    }

    public void copyGoodsModel(GoodsModel goodsModel){
        this.goodsCode = goodsModel.getCode();
        this.productId = nullToString(goodsModel.getProductId());
        this.name = goodsModel.getName();
        this.isInner = isInnerMap.get(goodsModel.getIsInner());
        this.cards = goodsModel.getCards();
        this.goodsType = (goodsTypeMap.get(goodsModel.getGoodsType()));
        this.mailOrderCode = nullToString(goodsModel.getMailOrderCode());
        this.adWord = nullToString(goodsModel.getAdWord());
        this.giftDesc = nullToString(goodsModel.getGiftDesc());
        this.serviceType = nullToString(goodsModel.getServiceType());
        this.recommendGoods = commaString(goodsModel.getRecommendGoods1Code(),goodsModel.getRecommendGoods2Code(),goodsModel.getRecommendGoods3Code());
        this.introduction = nullToString(goodsModel.getIntroduction());
        this.limitCount = nullToString(goodsModel.getLimitCount());
        if(!Strings.isNullOrEmpty(goodsModel.getCardLevelId())){
            this.cardLevelId = (cardLevelMap.get(goodsModel.getCardLevelId()));
        }
        this.brandName = goodsModel.getGoodsBrandName();
        this.vendorId = goodsModel.getVendorId();
    }

    private String nullToString(Object object){
        if(object == null){
            return "";
        }else {
            return object.toString();
        }
    }

    private String commaString(String... temp){
        List<String> notnull = Lists.newArrayList();
        for(String tempString : temp){
            if (tempString != null){
                notnull.add(tempString);
            }
        }
        if(notnull.size() == 0 ){
            return "";
        }
        String commaString = "";
        for(int i = 0;i<notnull.size();i++){
            if (i == notnull.size() - 1){
                commaString = commaString + notnull.get(i);
            }else {
                commaString = commaString + notnull.get(i) + ",";
            }
        }
        return commaString;
    }
}
