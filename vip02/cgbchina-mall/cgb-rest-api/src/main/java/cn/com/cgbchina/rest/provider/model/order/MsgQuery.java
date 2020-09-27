package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * 短彩信回执接口
 * 
 * @author Lizy
 *
 */
@Setter
@Getter
public class MsgQuery extends BaseQueryEntity implements Serializable {

	/**
	 *
	 */
	private static final long serialVersionUID = 6152622807562595646L;
	private String orderNo;
	private String suborderNo;
	private String msgType;
	private String mobile;
	private String status;
	private String statusMsg;
}
