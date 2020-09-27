package chinsoft.service.member;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import chinsoft.business.ExcelHelper;
import chinsoft.business.MemberManager;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;
public class ExportMembers extends BaseServlet{
	private static final long serialVersionUID = 3941900143254890884L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			String strKeyword = request.getParameter("keywords");
			String strParentUsername = request.getParameter("parent");
			int searchGroupIDs=Utility.toSafeInt(request.getParameterValues("searchGroupIDs"));
			int searchStatusID=Utility.toSafeInt(request.getParameterValues("searchStatusID"));
			String strParentCode = "";
			if(!"".equals(strParentUsername)){
				Member member = new MemberManager().getMemberByUsername(strParentUsername);
				if(member != null){
					strParentCode = member.getCode();
				}
			}
			List<Member> allMembersList = new MemberManager().getMembers(0, 1000000, strKeyword, strParentCode,searchGroupIDs,searchStatusID,"");
			// 表头
			ArrayList<String> headList = new ArrayList<String>();
			headList.add(ResourceHelper.getValue("Common_Index"));
			headList.add(ResourceHelper.getValue("Member_Name"));
			headList.add(ResourceHelper.getValue("Member_Username"));
			headList.add(ResourceHelper.getValue("Member_CompanyName"));
			headList.add(ResourceHelper.getValue("Member_CompanyShortName"));
			headList.add(ResourceHelper.getValue("Member_Contact"));
			headList.add(ResourceHelper.getValue("Member_ContractNo"));
			headList.add(ResourceHelper.getValue("Member_Group"));
			headList.add(ResourceHelper.getValue("Member_Parent"));
			headList.add(ResourceHelper.getValue("Member_CmtPrice"));
			headList.add(ResourceHelper.getValue("Member_ReceiveAddress"));
			headList.add(ResourceHelper.getValue("Common_Status"));
			headList.add(ResourceHelper.getValue("Member_LastLoginDate"));
			headList.add(ResourceHelper.getValue("Member_RegistDate"));
			headList.add(ResourceHelper.getValue("Member_Memo"));
			headList.add(ResourceHelper.getValue("Member_OrdenPre"));
			// 要写入的数据
			List<List<String>> cells = new ArrayList<List<String>>();
			int i = 0;
			for (Member member : allMembersList) {
				i++;
				List<String> memberStr = new ArrayList<String>();
				memberStr.add(i + "");
				//memberStr.add(member.getID());
				memberStr.add(member.getName());
				memberStr.add(member.getUsername());
				memberStr.add(member.getCompanyName());
				memberStr.add(member.getCompanyShortName());
				memberStr.add(member.getContact());
				memberStr.add(member.getContractNo());
				//memberStr.add(member.getCustomerCode());
				memberStr.add(member.getGroupName());
				//memberStr.add(member.getIsTrustName());
				memberStr.add(member.getParentName());
				memberStr.add(Utility.toSafeString(member.getCmtPrice()));
				//memberStr.add(member.getPayTypeName());
				memberStr.add(member.getReceiveAddress());
				memberStr.add(member.getStatusName());				
				memberStr.add(Utility.dateToStr(member.getLastLoginDate(),"yyyy-MM-dd HH:mm:ss"));
				memberStr.add(Utility.dateToStr(member.getRegistDate(),"yyyy-MM-dd HH:mm:ss"));
				memberStr.add(member.getMemo());
				memberStr.add(member.getOrdenPre());
				cells.add(memberStr);
			}
			// 设置导出文件名
			String fileName = "memberList-" + Utility.dateToStr(new Date(),"yyyy-MM-dd")
					+ ".xls";
			response.reset();
			// 禁止数据缓存。
	        response.setHeader("Pragma", "no-cache");
			
			try {
				response.setHeader(
						"Content-Disposition",
						"attachment;filename=\""
								+ new String(fileName.getBytes("UTF8"),
										"iso-8859-1") + "\"");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			response.setContentType("application/octet-stream;charset=UTF-8");
			ExcelHelper.exportExcel(headList, cells, Workbook.createWorkbook(response
					.getOutputStream()),ResourceHelper.getValue("Customer_Info"));
			return;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
