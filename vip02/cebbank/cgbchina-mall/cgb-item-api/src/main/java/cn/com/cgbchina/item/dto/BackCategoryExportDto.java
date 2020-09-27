package cn.com.cgbchina.item.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by zhoupeng on 2016/7/2.
 */
public class BackCategoryExportDto extends BackCategoryImportDto implements Serializable {

    private static final long serialVersionUID = -1895203129539982308L;
    @Getter
    @Setter
    private Long firstBackCategoryId;//第一级类目 id
    @Getter
    @Setter
    private Long secondBackCategoryId;//第二级类目 id
    @Getter
    @Setter
    private Long thirdBackCategoryId;//第三级类目 id
    @Setter
    @Getter
    private Long attributeId;        //属性id
    @Getter
    @Setter
    private Integer attributeType;   //属性类型
    @Setter
    @Getter
    private String attributeName;    //属性名

}
