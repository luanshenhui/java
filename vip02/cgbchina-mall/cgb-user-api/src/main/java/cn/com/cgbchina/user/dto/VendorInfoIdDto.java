package cn.com.cgbchina.user.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/6/25.
 */
public class VendorInfoIdDto implements Serializable {

	private static final long serialVersionUID = -7620028591482432099L;
	@Setter
	@Getter
	private String vendorId;
	@Setter
	@Getter
	private String fullName;
	@Setter
	@Getter
	private String simpleName;

}
