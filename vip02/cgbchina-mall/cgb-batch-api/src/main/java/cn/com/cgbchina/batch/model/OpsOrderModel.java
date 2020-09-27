package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;

/**
 * Created by dhc on 2016/7/19.
 */
@Getter
@Setter
@ToString
public class OpsOrderModel extends BaseModel implements Serializable{

    private static final long serialVersionUID = 4103991978872516735L;

    private String orderId;// 子订单号为：主订单号+2位顺序号如：201203280100000101一个主订单支持最多99个子订单

    private String orderMainId;// 主订单号

    private String cardNo;// 卡号

    private String vendorId;// 供应商代码

    private String sourceId;// 渠道代码00: 商城01: CallCenter02: IVR渠道03: 手机商城04: 短信渠道05: 微信广发银行06：微信广发信用卡

    private java.util.Date createTime;// 创建时间

    private String caseId; // BPS工单号

}
