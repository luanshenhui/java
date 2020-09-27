package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * 订单批量发货 导入data操作类（导入数据和导出结果数据）
 * Created by zhoupeng on 2016/7/23.
 */
public class OrderInputDto implements Serializable {

    private static final long serialVersionUID = -3402032353200371335L;

    @Getter
    @Setter
    String successFlag = "";//成功标志
    @Getter
    @Setter
    String failReason = "";//失败原因
    @Getter
    @Setter
    private String vendorId;// 供应商代码
    @Getter
    @Setter
    private String vendorSnm;// 供应商名称简写
    @Getter
    @Setter
    String orderId = "";//订单号
    @Getter
    @Setter
    String ordermainId = "";//主订单号
    @Getter
    @Setter
    String curStatusId = "";//订单状态
    @Getter
    @Setter
    String curStatusNm = "";//状态中文描述
    @Getter
    @Setter
    String mailingNum = "";//货单号
    @Getter
    @Setter
    String doDate = "";//发货日期
    @Getter
    @Setter
    String doTime = "";//发货时间
    @Getter
    @Setter
    String csgName = "";//收货人
    @Getter
    @Setter
    String signDate = "";//签收日期
    @Getter
    @Setter
    String signTime = "";//签收时间
    @Getter
    @Setter
    String transcorpId = "";//物流公司序号
    @Getter
    @Setter
    String transcorpNm = "";//物流公司
    @Getter
    @Setter
    String servicePhone = "";//客服电话
    @Getter
    @Setter
    String serviceUrl = "";//查询网址
    @Getter
    @Setter
    String mailingMan = "";//物流公司投递员
    @Getter
    @Setter
    String mailingMobile = "";//投递员手机号码
    @Getter
    @Setter
    String doDesc = "";//处理备注
    @Getter
    @Setter
    String ordertypeId = "";//订单类型
    @Getter
    @Setter
    String goodsType = "";//订单类型
    @Getter
    @Setter
    Integer miaoshaActionFlag ;//客户秒杀活动标志
}
