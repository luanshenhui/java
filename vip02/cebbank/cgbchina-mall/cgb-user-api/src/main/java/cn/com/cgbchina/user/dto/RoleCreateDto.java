package cn.com.cgbchina.user.dto;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

/**
 * Created by 郝文佳 on 2016/5/23.
 */
public class RoleCreateDto  implements Serializable{
	private static final long serialVersionUID = 9103078620459361445L;
	@Setter
	@Getter
	@NotNull
	@Length(max = 49)
	private String name;
	@Setter
	@Getter
	private List<Long> resourceIds;
}
