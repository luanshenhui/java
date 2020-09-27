package com.dpn.ciqqlc.common.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.xml.namespace.QName;

import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.io.xml.DomDriver;

public class ElectronicSealUtil {

    private static final Logger logger_ = LoggerFactory.getLogger(ElectronicSealUtil.class);	
	private static Properties properties = new Properties();
	
	//配置文件
	static  {
		InputStream is = null;
		try {
			is = ElectronicSealUtil.class.getResourceAsStream("/elecSeal.properties");
			properties.load(is);	
			is.close();
		} catch (Exception e) {
			logger_.error("Can not read elecSeal.properties file, Please confirm file in src folder.", e);
		} finally {
			if (is != null) {
				try {
					is.close();
				} catch (IOException e) {
					logger_.error("Close InputStream error.", e);
				}
			}			
		}		
	}

	/**
	 * 电子签章请求
	 * @param fileUrl 文件地址
	 * @param ruleNo 电子签章规则编号
	 * @return ElecSealResult status 成功："SUCC" result：文件名称
	 * 								   失败："ERR" result:失败内容
	 * @throws Exception
	 */
	public static boolean getElectronicSealPDF(String fileUrl, String ruleNo) throws Exception {
		logger_.error("**** ElectronicSealUtil.getElectronicSealPDF Param fileUrl = " + fileUrl + ", ruleNo=" + ruleNo);
		String respResultStr = null;
		//电子签章请求
		try {
			String xmlStr = getReqParamVal(fileUrl, "ciqs.pdf", ruleNo);
			logger_.error("**** ElectronicSealUtil.getElectronicSealPDF requsetParam xmlStr = " + xmlStr);
			String wsdlUrl = getProps("ELECTRONIC_SEAL_WEBSERVICE_ADDRESS");
			String nameSpaceUri = getProps("ELECTRONIC_SEAL_NAMESPACE_URI");
			Service service = new Service();
			Call call;
			call = (Call) service.createCall();
			call.setTargetEndpointAddress(new java.net.URL(wsdlUrl));
			call.setOperationName(new QName(nameSpaceUri, "sealAutoPdf"));
			respResultStr = (String) call.invoke(new Object[] { xmlStr });
			logger_.error("**** ElectronicSealUtil.getElectronicSealPDF respResultStr = " + respResultStr);
		} catch (Exception e) {
			logger_.error("**** ElectronicSealUtil.getElectronicSealPDF call.invoke request exception.", e);
			return false;
		}
		//接收请求结果
		try {
			SealDocResponse respResultObj = (SealDocResponse) getObjFromXMLString(respResultStr, SealDocResponse.class);
			if (respResultObj != null) {
				if ("0".equals(respResultObj.getFileList().getTreeNode().getRetCode()) == false) {
					logger_.error("**** ElectronicSealUtil.getElectronicSealPDF SealDocResponse RetCode is 1. fileUrl = " + fileUrl
							+ "RetMsg = " + respResultObj.getFileList().getTreeNode().getFileMsg());
					return false;
				}
			} else {
				logger_.error("**** ElectronicSealUtil.getElectronicSealPDF SealDocResponse is null.");
				return false;
			}
		} catch (Exception e) {
			logger_.error("**** ElectronicSealUtil.getElectronicSealPDF getObjFromXMLString exception.", e);
			return false;
		}
		return true;
	}
	
	/**
	 * 获取请求参数
	 */
	public static String getReqParamVal(String fileUrl, String fileName, String ruleNo) {
		StringBuffer p_xmlStr = new StringBuffer();
		p_xmlStr.append("<?xml version=\"1.0\" encoding=\"utf-8\" ?> \n")
				.append("<SealDocRequest> \n")
				.append("<BASE_DATA> \n")
				.append("\t<SYS_ID>").append(getProps("SYS_ID")).append("</SYS_ID> \n") 					//应用系统id写死
				.append("\t<USER_ID>").append(getProps("USER_ID")).append("</USER_ID> \n")					//用户id写死
				.append("\t<USER_PSD>").append(getProps("USER_PSD")).append("</USER_PSD> \n")				//用户密码写死
				.append("</BASE_DATA> \n")
				.append("<META_DATA> \n")
				.append("\t<IS_MERGER>").append(getProps("IS_MERGER")).append("</IS_MERGER> \n")			//是否模板合并写死
				.append("</META_DATA> \n")
				.append("<FILE_LIST> \n")
				.append("\t<TREE_NODE> \n")
				.append("\t\t<FILE_NO>").append(fileName).append("</FILE_NO> \n")							//文档名称
				.append("\t\t<IS_CODEBAR>").append(getProps("IS_CODEBAR")).append("</IS_CODEBAR> \n")		//是否加二维码
				.append("\t\t<SEAL_TYPE>").append(getProps("SEAL_TYPE")).append("</SEAL_TYPE> \n")			//盖章方式
				.append("\t\t<RULE_TYPE>").append(getProps("RULE_TYPE")).append("</RULE_TYPE> \n")			//规则方式
				.append("\t\t<RULE_NO>").append(ruleNo).append("</RULE_NO> \n")								//规则号
				.append("\t\t<CJ_TYPE>").append(getProps("CJ_TYPE")).append("</CJ_TYPE> \n")				//应用场景
				.append("\t\t<REQUEST_TYPE>").append(getProps("REQUEST_TYPE")).append("</REQUEST_TYPE> \n")	//文档名称
				.append("\t\t<FILE_PATH>").append(fileUrl).append("</FILE_PATH> \n")			//文档路径
				.append("\t\t<AREA_SEAL>").append(getProps("AREA_SEAL")).append("</AREA_SEAL> \n")		//是否添加标记印章
				.append("\t</TREE_NODE> \n")
				.append("</FILE_LIST> \n")
				.append("</SealDocRequest>");
		return p_xmlStr.toString();
	}
	
	/**
	 * 解析接口返回值
	 * @param String xmlString
	 * @param Classclazz
	 * @return Object
	 */
	public static Object getObjFromXMLString(String xmlString, Class clazz) {
		XStream xs = new XStream(new DomDriver());
		xs.processAnnotations(clazz);
		Object obj = xs.fromXML(xmlString);		
		return obj;
	}

	/**
	 * 电子签章返回值
	 * @author fengjun
	 */
	@XStreamAlias("SealDocResponse")
	class SealDocResponse {
		@XStreamAlias("FILE_LIST")
		private FileList fileList;

		public FileList getFileList() {
			return fileList;
		}

		public void setFileList(FileList fileList) {
			this.fileList = fileList;
		}
	}

	class FileList {
		@XStreamAlias("TREE_NODE")
		private TreeNode treeNode;

		public TreeNode getTreeNode() {
			return treeNode;
		}

		public void setTreeNode(TreeNode treeNode) {
			this.treeNode = treeNode;
		}
	}

	class TreeNode {
		@XStreamAlias("RET_CODE")
		private String retCode;
		
		@XStreamAlias("FILE_NAME")
		private String fileName;
		
		@XStreamAlias("FILE_MSG")
		private String fileMsg;

		public String getRetCode() {
			return retCode;
		}

		public void setRetCode(String retCode) {
			this.retCode = retCode;
		}

		public String getFileName() {
			return fileName;
		}

		public void setFileName(String fileName) {
			this.fileName = fileName;
		}

		public String getFileMsg() {
			return fileMsg;
		}

		public void setFileMsg(String fileMsg) {
			this.fileMsg = fileMsg;
		}
	}

	/**
	 * 获得配置文件信息
	 * @param key
	 * @return
	 */
	public static String getProps(String key) {
		Object obj = properties.get(key);
		if (null == obj) {
			return "";
		}
		String returnStr = (String) obj;
		return returnStr.trim();
	}

	public static void main(String[] args) throws Exception {
		boolean result = ElectronicSealUtil.getElectronicSealPDF("/message/ciqqlc/ca/seal/testfile/fengjunTest.pdf", "1,2");
		System.out.println(result);
	}
}
