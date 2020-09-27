/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.dto;

import java.io.Serializable;
import java.util.List;

import cn.com.cgbchina.user.model.VendorModel;
import lombok.Getter;
import lombok.Setter;

/**
 * @author liuhan
 * @version 1.0
 * @Since 16-6-28.
 */
public class VendorsDto extends VendorModel implements Serializable {

    private static final long serialVersionUID = -1379126242888687884L;
    @Getter
    @Setter
    private List<VendorRoleDto> vendorRoleDtos;// 当前账户关联的角色
}
