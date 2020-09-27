package cn.com.cgbchina.item.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by zhoupeng on 2016/6/29.
 */
public class BackCategoryImportDto implements Serializable {

    private static final long serialVersionUID = 980820307336077770L;
    @Getter
    @Setter
    private String successFlag;//成功标志
    @Getter
    @Setter
    private String failReason;//失败原因
    @Getter
    @Setter
    private String firstBackCategory;//第一级类目
    @Getter
    @Setter
    private String secondBackCategory;//第二级类目
    @Getter
    @Setter
    private String thirdBackCategory;//第三级类目
}
