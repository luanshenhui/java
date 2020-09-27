<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>要求船方预先准备清单</title>
<%@ include file="/common/resource_show.jsp"%>
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css"></link>
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<script src="${ctx}/static/viewer/assets/js/bootstrap.min.js"></script>
<script src="${ctx}/static/viewer/dist/viewer.js"></script>
<script src="${ctx}/static/viewer/demo/js/main.js"></script>
<script type="text/javascript" src="/ciqs/cuplayer/Images/swfobject.js"></script>
<style type="text/css">
body div {
	width: 1000px;
	margin: 5px auto;
}
/* div{
   overflow:auto;
   font-size: 22px;
} */
.chatTitle {
	text-align: center;
	font-size: 30px;
	font-weight: 600;
}

.tableLine {
	border: 1px solid #000;
}

.fangxingLine {
	font-size: 10;
	margin-left: 5px;
	margin-right: 5px;
	border: 2px solid #000;
	font-weight: 900;
	padding-left: 3px;
	padding-right: 3px;
}

.tableLine2 {
	border: 1px solid #000;
	padding-left: 10px;
}

.tableLine_noright {
	padding-left: 10px;
	border-top-width: 1px;
	border-bottom-width: 1px;
	border-left-width: 1px;
	border-top-style: solid;
	border-bottom-style: solid;
	border-left-style: solid;
	border-top-color: #000;
	border-bottom-color: #000;
	border-left-color: #000;
}

.tableLine_noleft {
	padding-left: 10px;
	border-top-width: 1px;
	border-right-width: 1px;
	border-bottom-width: 1px;
	border-top-style: solid;
	border-right-style: solid;
	border-bottom-style: solid;
	border-top-color: #000;
	border-right-color: #000;
	border-bottom-color: #000;
}
</style>
</head>
<body>
	<script type="text/javascript">
		$("#imgd1").hide();
		//图片预览
		function toImgDetail(path) {
			console.log(path)
			url = "/ciqs/showVideo?imgPath=" + path;
			$("#imgd1").attr("src", url);
			$("#imgd1").click();
		}
	</script>
	<div>
		<div class="chatTitle">要求船方预先准备清单</div>
		<h3>Documents required further</h3>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<c:if test="${doc.option_1=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					International Sewage Pollution Prevention Certificate
				</td>
			</tr>			
			</c:if>
			
			<c:if test="${doc.option_2=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Garbage management Plan
				</td>
			</tr>			
			</c:if>
			
			<c:if test="${doc.option_3=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Garbage record book
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_4=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Water safety plan (or water management plan)
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_5=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Potable water analysis report
				</td>
			</tr>			
			</c:if>
			
			<c:if test="${doc.option_6=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Waste management plan
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_7=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Management plan for food safety (including food temperature record)
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_8=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Management plan for vector control
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_9=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Medical log
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_10=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					IMO ballast water reporting form
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_11=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Ballast-water record book
				</td>
			</tr>
			</c:if>
		</table>
		<h3>whole areas</h3>
		<div>Area 1 Quarters</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			
			<c:if test="${doc.option_12=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Construction drawings of sanitary facilities and ventilation.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_13=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Cleaning procedures and logs.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_14=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Construction plans demonstrating how cross-contamination is avoided in specified clean and dirty areas.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_15=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Smoke tests at exhaust and at air intakes close to exhaust.
				</td>
			</tr>
			</c:if>
		</table>
		<div>Area 2 Galley, pantry and service areas</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<c:if test="${doc.option_16=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Cleaning schedule and logs.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_17=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Purchase records and shipboard documentation of food sources (wrapping or other
						identification on the packaging, or a written product identification sheet).
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_18=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Food storage in–out record.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_19=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Drainage construction drawings.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_20=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Previous inspection reports.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_21=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Pest logbook with information on sightings.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_22=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Temperature records for food storage, cooling logs and thermometer readings.
				</td>
			</tr>
			</c:if>
		</table>
		<div>Area 3 stores</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<c:if test="${doc.option_23=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Cleaning and maintenance schedule and logs
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_24=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Purchase records and shipboard documentation of food source (e.g. wrapping or other identification on packaging, or written product identification sheets).
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_25=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Food storage in–out records.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_26=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Construction drawings
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_27=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Previous inspection reports.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_28=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Pest logbook with information on sightings.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_29=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Records of food storage temperatures, cooling logs and thermometer readings
				</td>
			</tr>
			</c:if>
		</table>
		<div>Area 4 Child-care facilities</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<c:if test="${doc.option_30=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					written procedures and policies on cleaning, maintenance and waste management;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_31=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					written guidance on control measures if symptoms of infection occur in children; guidelines
					will include handling of body fluids, record keeping, notification of disease, communication,
					outbreak management and exclusion policies in case of illness;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_32=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
				vaccination list of child-care staff.
				</td>
			</tr>
			</c:if>
		</table>
		<div>Area 5 Medical facilities</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<c:if test="${doc.option_33=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
				up-to-date ship’s log and/or medical logbook, including treatment list;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_34=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					crew member interviews if the medical log is not available during inspection or entries are inadequate; if written information is required, request Maritime Declaration of Health from the State Party;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_35=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					training and certification of staff assigned to medical care;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_36=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					lists of medicines, vaccines, disinfectants and insecticides;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_37=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					number of passengers, mix of patients (passenger  ships only), medical equipment in place and procedures performed, depending on ship’s voyage pattern and size;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_38=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					cleaning, sanitation, maintenance and waste policies and procedures;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_39=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					specific disease surveillance logs (e.g. gastrointestinal disease), where applicable;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_40=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					operational manuals for high-risk facilities and devices such as an intensive-care unit, blood transfusion facility, operating theatre or haemodialysis facility;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_41=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					specimens collected and results if disease occurs on board; if possible, international certificates of vaccination or prophylaxis.
				</td>
			</tr>
			</c:if>
		</table>
		<div>Area 6 swimming pools and spas</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<c:if test="${doc.option_42=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					schematic plan for recreational water facilities, plant and systems;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_43=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					written scheme for controlling the risk from exposure to disease-causing microorganisms;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_44=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					pool installation, design and construction, maintenance and operation specif_ications;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_45=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					 training records for crew responsible for control methods;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_46=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					monitoring records;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_47=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					test results (e.g. pH, residual chlorine and bromine levels, temperature, microbiological
						levels);
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_48=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					regular cleaning procedures;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_49=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					emergency cleaning and disinfection procedures.
				</td>
			</tr>
			</c:if>
		</table>
		<div>Area 7 solid and medical waste</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<c:if test="${doc.option_50=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					a garbage management plan for every ship of 400 tons gross tonnage and above, and every
					ship certified to carry 15 persons or more; this document should contain all information requested
					in the Marine Environment Protection Committee Guidelines for the development of
					garbage management plans;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_51=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					a garbage record book for every ship of 400 tons gross tonnage and above, and every ship
					certified to carry 15 persons or more; this document should contain information on amounts
					of different waste types produced on board, plus information including discharge and incineration
					processes;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_52=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					International safety management manual;
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_53=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					maintenance instructions for waste processing units (e.g. incinerator);
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_54=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					construction plans of sewage system to check drains in waste areas.
				</td>
			</tr>
			</c:if>
		</table>
		<div>Area 8 engine room</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<c:if test="${doc.option_55=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					None applicable.
				</td>
			</tr>
			</c:if>
		</table>
		<div>Area 9 Potable water</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<c:if test="${doc.option_56=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Constructional drawings of potable water system.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_57=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Drinking-water analysis reports.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_58=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Medical logbook or gastrointestinal record book (or both).
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_59=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Water safety plan.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_60=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Maintenance instructions of treatment devices.
				</td>
			</tr>
			</c:if>
		</table>
		<div>Area 10 sewage</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<c:if test="${doc.option_61=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Technical drawings of sewage system.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_62=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					IMO International Sewage Pollution Prevention (ISPP) certificate.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_63=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					International Safety Management (ISM) manual.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_64=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Sewage management plan (if available).
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_65=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Maintenance instructions of sewage treatment plant (if installed).
				</td>
			</tr>
			</c:if>
		</table>
		<div>Area 11 Ballast water</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<c:if test="${doc.option_66=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					Constructional drawings of ballast-water reporting system.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_67=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					IMO’s ballast water reporting form.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_68=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					 International safety management manual.
				</td>
			</tr>
			</c:if>
			
			<c:if test="${doc.option_69=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					 Maintenance instructions for ballast-water treatment plant.
				</td>
			</tr>
			</c:if>
		</table>
		<div>Area 13 other systems and areas</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			
			<c:if test="${doc.option_70=='0' }">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					 Integrated vector management plan.
				</td>
			</tr>
			</c:if>
		</table>
		<div>手动新增</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<c:forEach items="${shoudong }" var="res">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					${res }
				</td>
			</tr>
			</c:forEach>
		</table>
		
		<input type="button"
			style="margin: 40px 40px 0px 260px; width: 80px; height: 30px;"
			value="打印" onclick="window.print()" /> <input type="button"
			style="margin: 40px 40px 0px 80px; width: 80px; height: 30px;"
			value="返回" onclick="javascript:window.opener=null;window.open('','_self');window.close();" />
	</div>
	<!-- 图片 -->
	<div class="row" style="z-index: 200000;">
		<div class="col-sm-8 col-md-6" style="z-index: 200000;">
			<div class="docs-galley" style="z-index: 200000;">
				<ul class="docs-pictures clearfix" style="z-index: 200000;">
					<li><img id="imgd1" style="z-index: 200000;" src=""
						alt="Cuo Na Lake" /></li>
				</ul>
			</div>
		</div>
	</div>
</body>
	<script type="text/javascript">
		$("#imgd1").hide();
		
		$(".baba").each(function(){
			var tr = $(this).parent();
			var span = $(this).find("span").eq(0);
			console.log(span.text().trim())
			if(span.text().trim() == ''){
				tr.remove()
			}
			if(document.referrer.indexOf("showtoprocessInfo_jsp")!=-1){
				$(this).remove()
			}
		});
		
	</script>
</html>