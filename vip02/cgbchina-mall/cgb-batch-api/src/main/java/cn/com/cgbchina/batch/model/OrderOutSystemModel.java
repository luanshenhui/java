package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
@Getter
@Setter
@ToString
public class OrderOutSystemModel extends BaseModel implements Serializable {

    private static final long serialVersionUID = -1996764215516165550L;
    private Long id;//自增主键
    private String orderMainId;//大订单编号
    private String orderId;//小订单编号
    private Integer times;//推送次数
    private String tuisongFlag;//是否推送成功标志
    private String systemRole;//外系统标志
    private String createOper;//创建人
    private java.util.Date createTime;//创建时间
    private String modifyOper;//修改人
    private java.util.Date modifyTime;//修改时间
}