package com.dpn.ciqqlc.common.util;

public enum DocTypeEnum {

	/**案件移送函*/
	D_GP_A_Y_1("gp_anjian_ysh","D_GP_A_Y_1"),
	/**立案审批表*/
	D_GP_L_S_1("gp_lian_spb","D_GP_L_S_1"),
	/**延期审批表*/
	D_GP_Y_S_1("gp_yanqi_spb","D_GP_Y_S_1"),
	/**涉嫌案件申报单*/
	GP_AJ_SBD("gp_shexiananjian_sbd","GP_AJ_SBD"),
	/**行政处罚案件反馈表*/
	D_GP_XZCF_AJFKB("gp_xzcf_ajfkb","D_GP_XZCF_AJFKB"),
	/**调查报告*/
	D_GP_DCBG("gp_diaochabaogao","D_GP_DCBG"),
	/**行政处罚告知书*/
	D_GP_XZCF_GZS("gp_xzcf_gzs","D_GP_XZCF_GZS"),
	/**行政处罚案件办理审批表*/
	D_GP_XZCFAJ_SPB("gp_anjian_spb","D_GP_XZCFAJ_SPB"),
	/**行政处罚决定书*/
	D_GP_XZCF_JDS("gp_xzcf_jds","D_GP_XZCF_JDS"),
	/**行政处罚结案报告*/
	D_GP_XZCF_JABG("gp_xzcf_jabg","D_GP_XZCF_JABG"),
	/**默认*/
	DEFAULT("","");
	private String str;
	private String code;
	
    private DocTypeEnum( String str,String code) {
        this.str = str;
        this.code = code;
    } 
    
    public DocTypeEnum getCode(String name){
		if(name.startsWith("gp_anjian_ysh")){//案件移送函
			return D_GP_A_Y_1;
		}else if(name.startsWith("gp_lian_spb")){//立案审批表
			return D_GP_L_S_1;
		}else if(name.startsWith("gp_yanqi_spb")){//延期审批表
			return D_GP_Y_S_1;
		}else if(name.startsWith("gp_shexiananjian_sbd")){//涉嫌案件申报单
			return GP_AJ_SBD;
		}else if(name.startsWith("gp_xzcf_ajfkb")){//行政处罚案件反馈表
			return D_GP_XZCF_AJFKB;
		}else if(name.startsWith("gp_diaochabaogao")){//调查报告
			return D_GP_DCBG;
		}else if(name.startsWith("gp_xzcf_gzs")){//行政处罚告知书
			return D_GP_XZCF_GZS;
		}else if(name.startsWith("gp_anjian_spb")){//行政处罚案件办理审批表
			return D_GP_XZCFAJ_SPB;
		}else if(name.startsWith("gp_xzcf_jds")){//行政处罚决定书
			return D_GP_XZCF_JDS;
		}else if(name.startsWith("gp_xzcf_jabg")){//行政处罚结案报告
			return D_GP_XZCF_JABG;
		}
		return DEFAULT;
    }
	public String getStr() {
		return str;
	}
	public void setStr(String str) {
		this.str = str;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
    
    
}
