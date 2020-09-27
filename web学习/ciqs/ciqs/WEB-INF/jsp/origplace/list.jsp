<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>原产地证书签发行政确认全过程执法记录</title>
    <%@ include file="/common/resource_show.jsp" %>
    <style type="text/css">
        input.datepick {
            background: #FFF url(/ciqs/static/dec/images/dpn.date.pick.gif) no-repeat right
            /* 	position: absolute; */
        }

        #title_a {
            color: #ccc
        }

        #title_a:hover {
            color: white;
        }

        .box-img-bg {
            background-image: url(../static/show/disc/bg.png);
            box-sizing: border-box;
            width: 1198px;
            height: 164px;
            padding: 0 200px;
            position: absolute;
            display: none;
            font-size: 20px;
            line-height: 35px;
            color: white;
        }

        .box-content-style {
            display: table-cell;
            vertical-align: middle;
            text-align: center;
        }
    </style>
    <script type="text/javascript">
        jQuery(document).ready(function () {
            $("#clearUp").click(function () {
                $("#dec_org_name").val('');
                $("#cert_no").val('');
                $("#org_reg_no").val('');
                $("#apply_date_over").val('');
                $("#apply_date_begin").val('');
                $("#dest_country").val('');
                $("#cert_type").val('');
            });
        });

        function pageUtil(page) {
            $("#orig_place").attr("action", "/ciqs/origplace/origList?page=" + page);
            $("#orig_place").submit();
        }
    </script>
</head>
<body class="bg-gary">
<div class="freeze_div_list">
    <div class="title-bg">
        <div class=" title-position margin-auto white">
            <div class="title">
                <!-- <a href="#" style="color:white; text-decoration: none;"><span  class="font-24px">原产地证书签发 </span></a> -->
                <span class="font-24px" style="color:white;">行政确认 /</span><a id="title_a"
                                                                             href="/ciqs/origplace/origList">原产地证书签发确认</a>
            </div>
            <%@ include file="/WEB-INF/jsp/userinfo.jsp" %>
        </div>
    </div>
    <div class="flow-bg">
        <div class="flow-position margin-auto">

            <ul class="white font-18px flow-height font-weight">
                <li>电子审单</li>
                <li>签证调查</li>
                <li>签证</li>
                <li style="width:126px">证书发放及归档</li>
                <li></li>
                <li></li>
                <li></li>
                <li></li>
            </ul>
            <ul>
                <li><img src="${ctx}/static/show/images/origplace/orgA1.png" width="107" height="103"
                         content="通过《原产地管理系统》对企业发送的电子数据按规定进行电子审单。审核证书内容是否与申请书、发票等内容一致，文字是否正确，有无错漏信息。具体记录内容包括申请书信息、发票信息以及证书信息"/>
                </li>
                <li><img src="${ctx}/static/show/images/origplace/orgA2.png" width="107" height="103"
                         content="签证过程中对签证产品进行核查。通过《原产地管理系统》审核企业提交的产品预审信息，选择调查方式，调查方式包括书面调查和实地调查。具体记录内容包括企业提交的相关电子资料、调查内容、调查记录、调查结论以及相关照片、视频记录。"/>
                </li>
                <li><img src="${ctx}/static/show/images/origplace/orgA3.png" width="107" height="103"
                         content="审核企业打印的带有条形码及证书并查看单证资料。对合格证书，由具有签证资格的签证人员在签证当局证明栏签字盖章。记录内容包括：使用移动执法终端拍摄签字盖章后的证书正本和随附资料"/>
                </li>
                <li><img src="${ctx}/static/show/images/origplace/orgA4.png" width="107" height="103"
                         content="签证人员对签字盖章后的证书及时发放，并在《原产地管理系统》做归档处理。对证书副本及必要的随附单据逐份清点后进行归档。记录内容包括：《原产地管理系统》记录及证书副本及随附单据归档。"/>
                </li>
                <li></li>
                <li></li>
                <li></li>
                <li></li>
            </ul>
        </div>
    </div>
</div>
<div class="blank_div_list">
</div>
<div class="margin-auto width-1200 search-box">
    <div id="alertBoxId" class="box-img-bg"><span class="box-content-style" id="alertContentId"></span></div>
    <form action="/ciqs/origplace/origList" method="post" id="orig_place">
        <table width="100%" border="0" class="table-search margin-auto">
            <tr>
                <td height="25" align="left" valign="middle">申请单位</td>
                <td height="25" align="left" valign="middle">申请开始日期</td>
                <td height="25" align="left" valign="middle">申请结束日期</td>
                <td height="25">企业备案号</td>
                <td height="25">证书号</td>
                <td height="25">&nbsp;</td>
            </tr>
            <tr>
                <td width="160" height="50" align="left" valign="middle"><input name="dec_org_name" type="text"
                                                                                class="search-input input-140px"
                                                                                id="dec_org_name"
                                                                                value="${obj.dec_org_name}"/></td>
                <td width="160" height="50"><input name="apply_date_begin" type="text"
                                                   class="search-input input-140px datepick" id="apply_date_begin"
                                                   value="${obj.apply_date_begin}"/></td>
                <td width="160" height="50"><input name="apply_date_over" type="text"
                                                   class="search-input input-140px datepick" id="apply_date_over"
                                                   value="${obj.apply_date_over}"/></td>
                <td width="160" height="50"><input name="org_reg_no" type="text" class="search-input input-140px"
                                                   id="org_reg_no" value="${obj.org_reg_no}"/></td>
                <td width="160" height="50"><input name="cert_no" type="text" class="search-input input-140px"
                                                   id="cert_no" value="${obj.cert_no}"/></td>
            </tr>
            <tr>
                <td height="25" align="left" valign="middle">直属局</td>
                <td height="25" align="left" valign="middle">分支机构</td>
                <td height="25">目的国家</td>
                <td height="25">证书种类</td>
                <td height="25"></td>
                <td height="25"></td>
                <td height="25">&nbsp;</td>
            </tr>
            <tr>
                <td width="160" height="50" align="left" valign="middle">
                    <select id="org_code" class="search-input input-175px" name="org_code">
                        <!-- 			<option value="CIQGVLN">辽宁出入境检验检疫局</option> -->
                        <option value="">全部</option>
                        <c:if test="${not empty allorgList }">
                            <c:forEach items="${allorgList}" var="row">
                                <c:if test="${obj.org_code == row.code}">
                                    <option selected="selected" value="${row.code}">${row.name}</option>
                                </c:if>
                                <c:if test="${obj.org_code!= row.code}">
                                    <option value="${row.code}">${row.name}</option>
                                </c:if>
                            </c:forEach>
                        </c:if>
                    </select>
                </td>
                <td width="160" height="50" align="left" valign="middle">
                    <select id="dept_code" class="search-input input-175px" name="dept_code">
                        <!-- 	        <option value="2119200101">大连出入境检验检疫局港湾办事处</option> -->
                        <option value="">全部</option>
                        <c:if test="${not empty alldepList }">
                            <c:forEach items="${alldepList}" var="row">
                                <c:if test="${obj.dept_code== row.code}">
                                    <option selected="selected" value="${row.code}">${row.name}</option>
                                </c:if>
                                <c:if test="${obj.dept_code != row.code}">
                                    <option value="${row.code}">${row.name}</option>
                                </c:if>
                            </c:forEach>
                        </c:if>
                    </select>
                </td>
                <td width="160" height="50">
                    <select id="dest_country" class="search-input input-145px" name="dest_country">
                        <option value="">全部</option>
                        <c:if test="${not empty countryList }">
                            <c:forEach items="${countryList}" var="row">
                                <c:if test="${obj.dest_country== row.num_code}">
                                    <option selected="selected" value="${row.num_code}">${row.cnname}</option>
                                </c:if>
                                <c:if test="${obj.dest_country != row.num_code}">
                                    <option value="${row.num_code}">${row.cnname}</option>
                                </c:if>
                            </c:forEach>
                        </c:if>
                    </select>
                </td>
                <td width="160" height="50">
                    <select id="cert_type" class="search-input input-145px" name="cert_type">
                        <option value="">全部</option>
                        <c:if test="${not empty libraryList }">
                            <c:forEach items="${libraryList}" var="row">
                                <c:if test="${obj.cert_type== row.code}">
                                    <option selected="selected" value="${row.code}">${row.name}</option>
                                </c:if>
                                <c:if test="${obj.cert_type != row.code}">
                                    <option value="${row.code}">${row.name}</option>
                                </c:if>
                            </c:forEach>
                        </c:if>
                    </select>
                </td>
                <td width="160" height="50"></td>
                <td height="50"></td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td style="width:250px">
                    <input type="submit" class="search-btn fo" value="搜索" style="cursor: pointer;"
                           onclick="pageUtil('')"/>
                </td>
                <td>
                    <input type="reset" class="search-btn fo" value="清空" style="cursor: pointer;"/>
                </td>
                <td></td>
            </tr>
        </table>
    </form>
</div>

<div class="margin-auto width-1200 tips">共找到<span class="yellow font-18px">
	<c:if test="${not empty list }">
        ${counts}
    </c:if>
	<c:if test="${empty list }">
        0
    </c:if>
	</span>条记录
</div>
<div class="margin-auto width-1200  data-box">
    <div class="margin-cxjg">
        <table class="margin-cxjg_table" border="0" cellspacing="0" cellpadding="0">
            <tr class="thead">
                <td>申请单位</td>
                <td>申请日期</td>
                <td>企业备案号</td>
                <td>证书号</td>
                <td>证书种类</td>
                <td>直属局</td>
                <td>分支机构</td>
                <td>发票号</td>
                <td>收货人</td>
                <td>目的国家</td>
                <td>出运日期</td>
                <td>操作</td>
            </tr>
            <c:if test="${not empty list }">
                <c:forEach items="${list}" var="row">
                    <tr class="thead_nr">
                        <td width="8%" height="90" align="center" class="font-18px">${row.dec_org_name}</td>
                        <td width="8%" height="90" align="center"><fmt:formatDate value="${row.apply_date}" type="both"
                                                                                  pattern="yyyy-MM-dd"/></td>
                        <td width="8%" height="90" align="center">${row.org_reg_no}</td>
                        <td width="8%" height="90" align="center">${row.cert_no}</td>
                        <td width="8%" height="90" align="center" class=" green">${row.cert_type}</td>
                        <td width="8%" height="90" align="center">${row.org_code}</td>
                        <td width="8%" height="90" align="center">${row.dept_code}</td>
                        <td width="8%" height="90" align="center">${row.receipt_no}</td>
                        <td width="8%" height="90" align="center">${row.consignee_cname}</td>
                        <td width="8%" height="90" align="center">${row.dest_country}</td>
                        <td width="8%" height="90" align="center"><fmt:formatDate value="${row.shipping_date}"
                                                                                  type="both"
                                                                                  pattern="yyyy-MM-dd"/></td>
                        <td height="90" align="center" valign="middle">
                            <a href='javascript:jumpPage("/ciqs/origplace/showOrig?id=${row.id}");'>
                                <span class="data-btn margin-auto">详细+</span></a></td>
                    </tr>
                </c:forEach>
            </c:if>
            <tfoot>
            <jsp:include page="/common/pageUtil.jsp" flush="true"/>
            </tfoot>
        </table>
    </div>
</div>
<div class="margin-auto width-1200 tips"></div>
<%-- <jsp:include page="/common/pageUtil.jsp" flush="true"/> --%>
</body>
<script type="text/javascript">
    $("li").mouseenter(function () {
        var img = this.getElementsByTagName("img")[0];
        var str = img.getAttribute("content");
        var alertBox = document.getElementById("alertBoxId");
        var alertContent = document.getElementById("alertContentId");
        alertContent.innerText = str;
        alertBox.style.display = 'table';
    });

    $("li").mouseleave(function () {
        var alertBox = document.getElementById("alertBoxId")
        alertBox.style.display = 'none';
    });
</script>
</html>
