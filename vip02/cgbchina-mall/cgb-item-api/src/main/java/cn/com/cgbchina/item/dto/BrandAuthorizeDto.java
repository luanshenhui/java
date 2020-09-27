package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.BrandAuthorizeModel;
import com.spirit.common.model.Pager;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by liuhan on 16-5-10.
 */
public class BrandAuthorizeDto extends BrandAuthorizeModel implements Serializable {


	private static final long serialVersionUID = 6464509925175731139L;
	@Getter
	@Setter
	private String simpleName;// 供应商简称

	@Getter
	@Setter
	private String v_startTime;// 生效时间

	@Getter
	@Setter
	private String v_endTime;// 失效时间
}
