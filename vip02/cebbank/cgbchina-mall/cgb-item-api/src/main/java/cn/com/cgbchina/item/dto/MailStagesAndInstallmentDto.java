/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.user.model.MailStagesModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/7/4.
 */


public class MailStagesAndInstallmentDto  implements Serializable{

    private static final long serialVersionUID = 5907651732080723510L;
    @Getter
    @Setter
    private List<MailStagesModel> mailStagesModelList;

    @Getter
    @Setter
    private List<Integer> periodList;
}

