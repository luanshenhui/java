package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;

/**
 * Created by txy on 2016/7/21.
 */
@Getter
@Setter
@ToString
public class SynBonusModel extends BaseModel implements Serializable {
    private static final long serialVersionUID = -9117532815431681419L;

    private String integraltypeId;//积分类型id

    private String integraltypeNm;//积分类型名称

    private String curStatus;//状态

    private String createOper;//创建人
}
