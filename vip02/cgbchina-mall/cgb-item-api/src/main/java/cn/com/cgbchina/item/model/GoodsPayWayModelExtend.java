package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;

/**
 *	日期		:	2016-7-5<br>
 *	作者		:	lizeyuan<br>
 *	项目		:	cgb-item-api<br>
 *	功能		:	MAL109返回对象  
 */
public class GoodsPayWayModelExtend  extends TblGoodsPaywayModel {
    @Getter
    @Setter
	private String vendorId;
    @Getter
    @Setter
	private String pictureUrl;
    @Getter
    @Setter
	private String goodsNm;
    @Getter
    @Setter
    private String goodsUrl;
    @Getter
    @Setter
    private String mid;
    @Getter
    @Setter
    private String xid;
    @Getter
    @Setter
    private String oid;
}