package cn.com.cgbchina.item.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/6/22.
 */
public class VendorIdNameDto implements Serializable {

	private static final long serialVersionUID = -7243660746642187618L;
	@Setter
	@Getter
	private String vendorId;
	@Setter
	@Getter
	private String simpleName;

}
