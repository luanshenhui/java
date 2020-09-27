/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.FrontCategory;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/6/28.
 */
public class FrontCategoryTree implements Serializable {


    private static final long serialVersionUID = -9014369226359934896L;
    @Getter
    @Setter
    private Long firstId;
    @Getter
    @Setter
    private FrontCategory firstFrontCategory;
    @Getter
    @Setter
    private List<FrontCategoryNav> childFrontCategory;
}
