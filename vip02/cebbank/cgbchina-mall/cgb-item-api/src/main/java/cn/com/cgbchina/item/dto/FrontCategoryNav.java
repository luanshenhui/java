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
public class FrontCategoryNav implements Serializable {

    private static final long serialVersionUID = -4173267050558731910L;
    @Getter
    @Setter
    private FrontCategory secondLevel;
    @Getter
    @Setter
    private List<FrontCategory> thirdLevel;
}
