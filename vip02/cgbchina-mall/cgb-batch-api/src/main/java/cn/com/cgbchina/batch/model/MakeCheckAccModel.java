package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by w2001316 on 2016/7/28.
 */
@Getter
@Setter
@ToString
public class MakeCheckAccModel extends BaseModel implements Serializable {

    private static final long serialVersionUID = -7521036249204563748L;

    private String ordermainId;

    private String orderId;

    private String cardNo;

    private Date createTime;

    private String serialNo;

    private String defraytype;

    private BigDecimal amount;

    private String bonusType;

    private String bonusValue;

    private String bonusTxnCode;

    private String ismerge;

    private String bonusTotalvalue;

    private String sourceId;

    private String orderIdHost;

    private String integraltypeId;

    private String curStatusId;

    private Long id;

    private String ordertypeId;

    private String doDate;

    private String doTime;

    private String jfRefundSerialno;

    private String voucherNo;

    private String contIdcard;
}
