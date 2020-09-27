<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String webpath = request.getContextPath();
%>
<html>
<head>
<title>选择加签人</title>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<link rel="stylesheet" href="<%=webpath%>/view/common/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="<%=webpath%>/view/common/scripts/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript">

	var procInstanceId = "<%=request.getParameter("procInstanceId")%>";
	var currWorkitemId = "<%=request.getParameter("workitemId")%>";
	var activityInstId = "<%=request.getParameter("activityInstId")%>";
</script>
<script type="text/javascript"
	src="<%=webpath%>/view/workflow/management/workitem/addSigner.js">
</script>
</head>
<body class="popUp-body">
	<form action="reassign.do">
		<div style="margin: 5px auto auto 5px;" class="main_label_outline">
			<table>
				<tr>
					<td class="popUp-treeTitle">
					加签类型：
					</td>
					<td>
						<select id="signType" name="signType">
							<option value="0">主送加签</option>
							<option value="1">抄送加签</option>
						</select>
					</td>
				</tr>
			</table>
		</div>
		<div id="div1"  style="margin: 5px auto auto 5px;" class="main_label_outline">
			<table  width="100%" height="300" border="0"">
				<tr>
					<td class="popUp-treeTitle" valign="top" width=45% colspan=2>组织机构：
					</td>
					<td class="popUp-treeTitle" colspan=1>人员列表：
					</td>
				</tr>
				<tr height=150>
					<td >
						<ul id="treeDemo" class="h345 ztree popUp-treeBox popUp-edit"></ul>
					</td>
					<td width=10% align="center" valign="center">
						<table>
							<tr>
								<td>
									<input type="button"  id="add" value=">>" onClick="addReassign()"></div>
								</td>
							</tr>
							<tr>
								<td>
									<input type="button" id="delete" value="<<" onClick="removeReassign()"></div>
	                  </td></tr>
	                 </table>
	             </td>
	              <td align="left" valign="center" width=45% >
		               <select id="assignTo" name="assignTo" size="24" multiple="true" style="width:100%;height:345px;">

					   </select>
	              </td>
             </tr>
         </table>
	 </div>
     <input type="button" style="float: right; margin: 5px auto auto 5px;" value="取消" onClick="cancel_onclick()">
     <input type="button" style="float: right; margin: 5px auto auto 5px;" value="确定" onClick="ok_onclick()">
	 <input type="hidden" id="operation"/>
     <input type="hidden" id="workitemID"/>
     <input type="hidden" id="submitAuthor"/>
     <input type="hidden" id="approvalinfo"/>
     <input type="hidden" value='<%=request.getContextPath()%>' id="path" />
	 </form>
  </body>
</html>
