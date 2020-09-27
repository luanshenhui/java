package cn.com.cgbchina.user.dto;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

/**
 * Created by 郝文佳 on 2016/5/24.
 */
public class VendorRoleEditDto implements Serializable {

	private static final long serialVersionUID = -6305264643420674420L;
	@Setter
	@Getter
	@NotNull
	private Long roleId;
	@Setter
	@Getter
	private List<Long> resourceIds;

}
