package cn.com.cgbchina.related.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class ReportModel implements Serializable {

    private static final long serialVersionUID = 7041391148359600447L;
    @Getter
    @Setter
    private Integer reportId;//自增主键
    @Getter
    @Setter
    private String reportCode;//报表代码
    @Getter
    @Setter
    private String reportNm;//报表名称
    @Getter
    @Setter
    private String reportDate;//报表生成日期
    @Getter
    @Setter
    private String reportTime;//报表生成时间
    @Getter
    @Setter
    private String reportPath;//报表文件下载 [提供下载链接]下载显示文件名为报表名称+报表生成日期
    @Getter
    @Setter
    private String ordertypeId;//业务类型代码
    @Getter
    @Setter
    private Integer reportRecNum;//报表记录数
    @Getter
    @Setter
    private String vendorId;//合作商编号
    @Getter
    @Setter
    private String reportDesc;//报表描述
    @Getter
    @Setter
    private String airlineType;//航空类型标志
}
