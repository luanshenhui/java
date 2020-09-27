package cn.com.cgbchina.rest.provider.vo.activity;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL326 分区查询接口
 * 
 * @author lizy 2016/4/28.
 */
public class AreaQueryReturnVO   implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7493151002455081784L;
	private String returnCode;
	private String returnDes;
	
	public String getReturnCode() {
		return returnCode;
	}

	public void setReturnCode(String returnCode) {
		this.returnCode = returnCode;
	}

	public String getReturnDes() {
		return returnDes;
	}

	public void setReturnDes(String returnDes) {
		this.returnDes = returnDes;
	}

	private List<AreaInfoVO> areaInfos = new ArrayList<AreaInfoVO>();

	public List<AreaInfoVO> getAreaInfos() {
		return areaInfos;
	}

	public void setAreaInfos(List<AreaInfoVO> areaInfos) {
		this.areaInfos = areaInfos;
	}

}
