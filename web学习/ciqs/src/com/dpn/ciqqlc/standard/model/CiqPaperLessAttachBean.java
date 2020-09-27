package com.dpn.ciqqlc.standard.model;

import java.util.List;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.annotations.XStreamImplicit;


@XStreamAlias("ROOT")
public class CiqPaperLessAttachBean {

	@XStreamAlias("RESULT")
	private String RESULT;
	public String getRESULT() {
		return RESULT;
	}
	public void setRESULT(String rESULT) {
		RESULT = rESULT;
	}
	
	@XStreamAlias("DESC")
	private DESC DESC;
	public DESC getDESC() {
		return DESC;
	}
	public void setDESC(DESC dESC) {
		DESC = dESC;
	}
	public class DESC {
		
		@XStreamAlias("CONTENT")
		private CONTENT CONTENT;
		public CONTENT getCONTENT() {
			return CONTENT;
		}
		public void setCONTENT(CONTENT cONTENT) {
			CONTENT = cONTENT;
		}
		public class CONTENT {
			@XStreamAlias("DECLNO")
			private String DECLNO;
			
			public String getDECLNO() {
				return DECLNO;
			}
			public void setDECLNO(String dECLNO) {
				DECLNO = dECLNO;
			}
			@XStreamAlias("ATTACHS")
			private ATTACHS ATTACHS;
			public ATTACHS getATTACHS() {
				return ATTACHS;
			}
			public void setATTACHS(ATTACHS aTTACHS) {
				ATTACHS = aTTACHS;
			}
			public class ATTACHS {
				@XStreamImplicit(itemFieldName = "ATTACHINFO")
				private List<CiqPaperLessAttachInfoBean> ATTACHINFO;

				public List<CiqPaperLessAttachInfoBean> getATTACHINFO() {
					return ATTACHINFO;
				}

				public void setATTACHINFO(List<CiqPaperLessAttachInfoBean> aTTACHINFO) {
					ATTACHINFO = aTTACHINFO;
				}
				
			}
			
		}
		
	}
	
	
}
