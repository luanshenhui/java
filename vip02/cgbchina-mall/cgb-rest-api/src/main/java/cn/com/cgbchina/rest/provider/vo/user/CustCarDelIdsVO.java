package cn.com.cgbchina.rest.provider.vo.user;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import lombok.Getter;
import lombok.Setter;

import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL304 加入购物车(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class CustCarDelIdsVO implements Serializable {

	@Getter
	@Setter
	private String id;
}
