package chinsoft.service.orden;

import com.opensymphony.xwork2.ActionSupport;

public class OrdenAction extends ActionSupport {
	private String ordenID2;
	/**标记是复制还是新下单 0是 新下单 1复制 */
	private String  copyFlag;
	
	public String add() {


		return "addPage";
	}


	public String getOrdenID2() {
		return ordenID2;
	}

	public void setOrdenID2(String ordenID2) {
		this.ordenID2 = ordenID2;
	}


	public String getCopyFlag() {
		return copyFlag;
	}


	public void setCopyFlag(String copyFlag) {
		this.copyFlag = copyFlag;
	}
	
	

}
