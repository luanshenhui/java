package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;

/**
 * Created by txy on 2016/7/22.
 */
@Getter
@Setter
@ToString
public class IvrRankModel extends BaseModel implements Serializable {
    private static final long serialVersionUID = -7583583677561990125L;

    private String integraltypeId;//积分类型Id

    private String integraltypeNm;// 积分类型名称

    private String curMonth;// 状态

    private String itemCode;//单品编码

    private Integer itemSum;//单品数量和
}
