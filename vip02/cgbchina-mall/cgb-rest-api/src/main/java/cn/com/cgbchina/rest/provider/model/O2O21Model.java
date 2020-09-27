package cn.com.cgbchina.rest.provider.model;

import java.util.List;

/**
 * Comment: Created by 11150321050126 on 2016/4/25.
 */
public class O2O21Model {
	public class Request {
		private String orderno;
		private String sum;
		private List<RequestLoop> loops;

		public String getOrderno() {
			return orderno;
		}

		public void setOrderno(String orderno) {
			this.orderno = orderno;
		}

		public String getSum() {
			return sum;
		}

		public void setSum(String sum) {
			this.sum = sum;
		}

		public List<RequestLoop> getLoops() {
			return loops;
		}

		public void setLoops(List<RequestLoop> loops) {
			this.loops = loops;
		}
	}

	public class RequestLoop {
		private String suborderno;
		private String codedata;
		private String fileurl;

		public String getSuborderno() {
			return suborderno;
		}

		public void setSuborderno(String suborderno) {
			this.suborderno = suborderno;
		}

		public String getCodedata() {
			return codedata;
		}

		public void setCodedata(String codedata) {
			this.codedata = codedata;
		}

		public String getFileurl() {
			return fileurl;
		}

		public void setFileurl(String fileurl) {
			this.fileurl = fileurl;
		}
	}

	public class Response {
		private String result_code;
		private String result_msg;

		public String getResult_code() {
			return result_code;
		}

		public void setResult_code(String result_code) {
			this.result_code = result_code;
		}

		public String getResult_msg() {
			return result_msg;
		}

		public void setResult_msg(String result_msg) {
			this.result_msg = result_msg;
		}
	}
}
