/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * 撤单
 * @author 11150721040343
 * @version 1.0
 * @Since 2016/7/24
 */
public class RevocationOrderDto implements Serializable{

    private static final long serialVersionUID = -8866840828821179828L;

    @Getter
    @Setter
    private Integer id;//序号

    @Getter
    @Setter
    private String ordermainId;//主订单号

    @Getter
    @Setter
    private String orderId;//子订单号

    @Getter
    @Setter
    private String ordernbr;//银行订单号

    @Getter
    @Setter
    private String goodsMid;//分期编码

    @Getter
    @Setter
    private String goodsNm;//商品名称

    @Getter
    @Setter
    private String createDate;//下单日期

    @Setter
    @Getter
    private String createTime;//下单时间

    @Getter
    @Setter
    private String ordermainDesc;//客户备注

    @Getter
    @Setter
    private String curStatusNm;//订单状态


}
