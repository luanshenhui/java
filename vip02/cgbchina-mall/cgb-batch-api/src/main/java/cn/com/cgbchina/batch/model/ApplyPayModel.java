package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by zhangLin on 2016/12/29.
 */
@Getter
@Setter
public class ApplyPayModel extends BaseModel implements Serializable {
    private static final long serialVersionUID = 8829539817566231159L;
    private String goodsNm;
    private String goodsNum;
    private String totalMoney;
    private String calMoney;
    private String goodssendFlag;
    private String batchNo;
    private String sinStatusNm;
    private String balanceStatus;
    private String vendorSnm;
    private String orderId;
    private String cardno;
    private String contNm;
    private String xid;
}
