package cn.com.cgbchina.related.dto;

import cn.com.cgbchina.related.model.ReportModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by tongxueying on 2016/8/12.
 */
public class ReportManageDto implements Serializable {
    private static final long serialVersionUID = 5821749330436569398L;
    @Getter
    @Setter
    private String simpleName;//供应商简称
    @Getter
    @Setter
    private ReportModel reportModel;
    @Getter
    @Setter
    private String fileName;//文件名
}
