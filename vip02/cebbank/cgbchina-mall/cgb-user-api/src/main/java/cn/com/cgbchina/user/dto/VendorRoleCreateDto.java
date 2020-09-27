package cn.com.cgbchina.user.dto;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

/**
 * Created by 郝文佳 on 2016/5/23.
 */
public class VendorRoleCreateDto  implements Serializable{
	private static final long serialVersionUID = 47176902797032405L;
	@Setter
	@Getter
	@NotNull
	private String name;
	@Setter
	@Getter
	private List<Long> resourceIds;

}
