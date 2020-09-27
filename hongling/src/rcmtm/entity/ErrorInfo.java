package rcmtm.entity;

public class ErrorInfo {
	
	private boolean flag;//请求是否成功(true成功,false失败)
	private int Error;//错误代码
	private String Errormsg;//错误信息
	
	public boolean isFlag() {
		return flag;
	}
	public void setFlag(boolean flag) {
		this.flag = flag;
	}
	public int getError() {
		return Error;
	}
	public void setError(int error) {
		Error = error;
	}
	public String getErrormsg() {
		return Errormsg;
	}
	public void setErrormsg(String errormsg) {
		Errormsg = errormsg;
	}
}
