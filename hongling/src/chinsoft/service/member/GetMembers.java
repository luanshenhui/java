package chinsoft.service.member;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.MemberManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class GetMembers extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			int	nPageSize=CDict.PAGE_SIZE;
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
			String strKeyword = getParameter("searchKeywords");
			if ("".equals(strKeyword)) {
				strKeyword=getParameter("searchKeyword");
			}
			String strParentUsername = getParameter("searchParent");
			int searchGroupIDs=Utility.toSafeInt(getParameter("searchGroupID"));
			int searchStatusID=Utility.toSafeInt(getParameter("searchStatusID"));
			
			// 从哪个页面过来
			// from如果为caiwu,则从客户单价过来，否则，从用户管理过来
			String from = getParameter("from");
			
			String strParentCode = "";
			if(!"".equals(strParentUsername)){
				Member member = new MemberManager().getMemberByUsername(strParentUsername);
				if(member != null){
					strParentCode = member.getCode();
				}
			}
			
			List<Member> data = new MemberManager().getMembers(nPageIndex, nPageSize, strKeyword, strParentCode,searchGroupIDs,searchStatusID, from);
			long nCount = new MemberManager().getMembersCount(strKeyword, strParentCode,searchGroupIDs,searchStatusID, from);

			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(data);
			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("getmembers_err" + e.getMessage());
		}
	}
}
