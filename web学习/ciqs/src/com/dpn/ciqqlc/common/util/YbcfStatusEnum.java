package com.dpn.ciqqlc.common.util;

import java.util.EnumSet;

public enum YbcfStatusEnum {

	/**一般处罚环节-审核状态-未审核*/
	GNRL_PNSMT_SHH_STATUS_0("0","未审核"),                               

	/**一般处罚环节-审核状态-通过*/
	GNRL_PNSMT_SHH_STATUS_1("1","通过"),                            

	/**一般处罚环节-审核状态-未通过*/
	GNRL_PNSMT_SHH_STATUS_2("2","未通过"),                                       

	/**一般处罚环节-审核状态-退回*/
	GNRL_PNSMT_SHH_STATUS_3("3","退回"),                                         

	/**一般处罚环节-审核状态-全部*/
	GNRL_PNSMT_SHH_STATUS_4("4","全部"),                                         
	
	/** 送达执行 */
	GNRL_PNSMT_SHH_STATUS_13("13","送达执行"),
	
	/** 结案归档 */
	GNRL_PNSMT_SHH_STATUS_14("14","结案归档"),
	
	/** 移送*/
	GNRL_PNSMT_SHH_STATUS_15("15","移送"),
	                                                                                                                                 
	/**未经检验擅自销售或使用进口商品                                       */
	GNRL_PNSMT_SHH_STATUS_21("21","未经检验擅自销售或使用进口商品"), 
	/**进出口假冒伪劣商品                                       */
	GNRL_PNSMT_SHH_STATUS_22("22","进出口假冒伪劣商品"), 
	/**伪造、变造、买卖或者盗窃商检单证、标志、封识             */
	GNRL_PNSMT_SHH_STATUS_23("23","伪造、变造、买卖或者盗窃商检单证、标志、封识"),
	/**使用伪造、变造的检验证单、标志、封识                     */
	GNRL_PNSMT_SHH_STATUS_24("24","使用伪造、变造的检验证单、标志、封识"),
	/**销售、使用经法定检验不合格的进口商品                     */
	GNRL_PNSMT_SHH_STATUS_25("25","销售、使用经法定检验不合格的进口商品"),
	/**不如实提供真实情况取得有关证单                           */
	GNRL_PNSMT_SHH_STATUS_26("26","不如实提供真实情况取得有关证单"),
	/**对法定检验的进出口商品不予报检，逃避检验                 */
	GNRL_PNSMT_SHH_STATUS_27("27","对法定检验的进出口商品不予报检，逃避检验"),
	/**报检受托人未合理审查导致骗取单证                         */
	GNRL_PNSMT_SHH_STATUS_28("28","报检受托人未合理审查导致骗取单证"),
	/**代理报检企业扰乱报检秩序                                 */
	GNRL_PNSMT_SHH_STATUS_29("29","代理报检企业扰乱报检秩序"),
	/**未经许可擅自将动植物产品卸离运输工具或运递               */
	GNRL_PNSMT_SHH_STATUS_30("30","未经许可擅自将动植物产品卸离运输工具或运递"),
	/**报检的动植物产品与实际不符                               */
	GNRL_PNSMT_SHH_STATUS_31("31","报检的动植物产品与实际不符"),
	/**使用、买卖、伪造、变造动植物检疫单证、标志、封识         */
	GNRL_PNSMT_SHH_STATUS_32("32","使用、买卖、伪造、变造动植物检疫单证、标志、封识"),
	/**擅自拆除、遗弃木质包装，伪造、变更、盗用IPPC专用标识     */
	GNRL_PNSMT_SHH_STATUS_33("33","擅自拆除、遗弃木质包装，伪造、变更、盗用IPPC专用标识"),
	/**拒绝接受检疫或者抵制卫生监督，拒不接受卫生处理           */
	GNRL_PNSMT_SHH_STATUS_34("34","拒绝接受检疫或者抵制卫生监督，拒不接受卫生处理"),
	/**逃避检疫，向国境卫生检疫机关隐瞒真实情况、隐瞒疫情或伪造情节         */
	GNRL_PNSMT_SHH_STATUS_35("35","逃避检疫，向国境卫生检疫机关隐瞒真实情况、隐瞒疫情或伪造情节"),
	/**伪造或者涂改检疫单、证，不如实申报疫情           */        
	GNRL_PNSMT_SHH_STATUS_36("36","伪造或者涂改检疫单、证，不如实申报疫情"),
	/**买卖卫生检疫单证或者买卖伪造、变造的卫生检疫单证 */        
	GNRL_PNSMT_SHH_STATUS_37("37","买卖卫生检疫单证或者买卖伪造、变造的卫生检疫单证"),
	/**其他 */
	GNRL_PNSMT_SHH_STATUS_38("38","其他"),
	
	DEFAULT("","全部");
	private String code;
	private String name;
	
    private YbcfStatusEnum( String code,String name) {
        this.code = code;
        this.name = name;
    } 
    
    public static Object[] toList(){
    	
    	EnumSet<YbcfStatusEnum> esSet = EnumSet.allOf(YbcfStatusEnum.class);
    	return esSet.toArray();
    }
    public static YbcfStatusEnum getCode(String str){
		
    	YbcfStatusEnum b = YbcfStatusEnum.DEFAULT;
    	
    	switch (str) {
			case "0":
				b = GNRL_PNSMT_SHH_STATUS_0;
				break;
			case "1":
				b = GNRL_PNSMT_SHH_STATUS_1;
				break;
			case "2":
				b = GNRL_PNSMT_SHH_STATUS_2;
				break;
			case "3":
				b = GNRL_PNSMT_SHH_STATUS_3;
				break;
			case "4":
				b = GNRL_PNSMT_SHH_STATUS_4;
				break;
			case "13":
				b = GNRL_PNSMT_SHH_STATUS_13;
				break;
			case "14":
				b = GNRL_PNSMT_SHH_STATUS_14;
				break;
			case "15":
				b = GNRL_PNSMT_SHH_STATUS_15;
				break;
			case "21":
				b = GNRL_PNSMT_SHH_STATUS_21;
				break;
			case "22":
				b = GNRL_PNSMT_SHH_STATUS_22;
				break;
			case "23":
				b = GNRL_PNSMT_SHH_STATUS_23;
				break;
			case "24":
				b = GNRL_PNSMT_SHH_STATUS_24;
				break;
			case "25":
				b = GNRL_PNSMT_SHH_STATUS_25;
				break;
			case "26":
				b = GNRL_PNSMT_SHH_STATUS_26;
				break;
			case "27":
				b = GNRL_PNSMT_SHH_STATUS_27;
				break;
			case "28":
				b = GNRL_PNSMT_SHH_STATUS_28;
				break;
			case "29":
				b = GNRL_PNSMT_SHH_STATUS_29;
				break;
			case "30":
				b = GNRL_PNSMT_SHH_STATUS_30;
				break;
			case "31":
				b = GNRL_PNSMT_SHH_STATUS_31;
				break;
			case "32":
				b = GNRL_PNSMT_SHH_STATUS_32;
				break;
			case "33":
				b = GNRL_PNSMT_SHH_STATUS_33;
				break;
			case "34":
				b = GNRL_PNSMT_SHH_STATUS_34;
				break;
			case "35":
				b = GNRL_PNSMT_SHH_STATUS_35;
				break;
			case "36":
				b = GNRL_PNSMT_SHH_STATUS_36;
				break;
			case "37":
				b = GNRL_PNSMT_SHH_STATUS_37;
				break;
			case "38":
				b = GNRL_PNSMT_SHH_STATUS_38;
				break;
			default:
				break;
		}
    	
    	return b;
    }

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
    
    
}
