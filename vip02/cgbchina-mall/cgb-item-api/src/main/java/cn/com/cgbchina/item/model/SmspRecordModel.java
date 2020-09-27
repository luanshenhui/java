package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class SmspRecordModel implements Serializable {

    private static final long serialVersionUID = 1818520079603014569L;
    @Getter
    @Setter
    private Long id;//自增主键
    @Getter
    @Setter
    private Long sId;//短信模板id
    @Getter
    @Setter
    private Integer totalNum;//总条数
    @Getter
    @Setter
    private Integer successNum;//成功条数
    @Getter
    @Setter
    private Integer failNum;//失败条数
    @Getter
    @Setter
    private Integer repeatNum;//重复条数
    @Getter
    @Setter
    private String loadStatus;//导入状态
    @Getter
    @Setter
    private String filePath;//文件链接地址
    @Getter
    @Setter
    private String createOper;//创建人
    @Getter
    @Setter
    private java.util.Date createTime;//创建时间
}