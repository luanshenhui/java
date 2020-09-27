package cn.com.cgbchina.trade.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class OrderReturnTrackDetailModel implements Serializable {

    private static final long serialVersionUID = -3590621858516378988L;
    @Getter
    @Setter
    private Long id;// id
    @Getter
    @Setter
    private String orderId;//订单号
    @Getter
    @Setter
    private String curStatusId;//当前状态代码-0301待付款,0304已废单,0360已取消,0316订单状态未明,0305处理中,0307支付失败,0308支付成功,0312已撤单,0306发货处理中,0309已发货,0310已签收,0380拒绝签收,0381无人签收,0334退货申请,0327退货成功,0335拒绝退货申请,0382系统拒绝该订单,0332请款申请,0333拒绝请款,0350同意请款,0351请款中,0311请款成功,0352请款失败
    @Getter
    @Setter
    private String curStatusNm;//当前状态名称
    @Getter
    @Setter
    private String ordertypeId;//业务类型代码YG:广发商城(一期)JF:积分商城FQ:广发商城(分期)
    @Getter
    @Setter
    private String ordertypeNm;//业务类型名称
    @Getter
    @Setter
    private Integer operationType;//撤单/退货标记 0：撤单 1：退货
    @Getter
    @Setter
    private String memo;//撤单/退货原因
    @Getter
    @Setter
    private String memoExt;//补充说明
    @Getter
    @Setter
    private String doDesc;//撤单/退货描述
    @Getter
    @Setter
    private String extend1;//保留字段
    @Getter
    @Setter
    private String extend2;//保留字段
    @Getter
    @Setter
    private String createOper;//创建人
    @Getter
    @Setter
    private java.util.Date createTime;//创建时间
    @Getter
    @Setter
    private String modifyOper;//修改人
    @Getter
    @Setter
    private java.util.Date modifyTime;//修改时间
}