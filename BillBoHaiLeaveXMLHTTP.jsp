
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.attendance.domain.*"%>
<%@ page import="weaver.hrm.schedule.HrmAnnualManagement"%>
<%@ page import="weaver.hrm.schedule.HrmPaidSickManagement"%>
<%@ page import="weaver.hrm.schedule.manager.HrmScheduleManager"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page" />
<jsp:useBean id="dateUtil" class="weaver.common.DateUtil" scope="page" />
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="paidLeaveTimeManager" class="weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager" scope="page" />
<jsp:useBean id="attProcSetManager" class="weaver.hrm.attendance.manager.HrmAttProcSetManager" scope="page" />
<jsp:useBean id="attVacationManager" class="weaver.hrm.attendance.manager.HrmAttVacationManager" scope="page" />
<jsp:useBean id="colorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<%


User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;


String returnString="";

String operation=Util.null2String(request.getParameter("operation"));



//检查其它请假类型是否可行
if("checkOtherLeaveType".equals(operation)){
	int leaveType=Util.getIntValue(request.getParameter("leaveType"),0);
	int otherLeaveType=Util.getIntValue(request.getParameter("otherLeaveType"),0);
	int resourceId=Util.getIntValue(request.getParameter("resourceId"),0);
	String fromDate=Util.null2String(request.getParameter("fromDate"));
    String fromYear="";
	if(fromDate.length()>=4){
		fromYear=fromDate.substring(0,4);
	}

	int requestId=Util.getIntValue(request.getParameter("requestId"),0);

	StringBuffer sb=new StringBuffer();
	sb.append(" select 1 ")
	  .append("   from Bill_BoHaiLeave b ")
	  .append("  where b.resourceId=").append(resourceId)
	  .append("    and b.otherLeaveType=").append(otherLeaveType==1?2:1)		
	  .append("    and (b.leaveType=3  or b.leaveType=4) ");

	if(!fromYear.equals("")){
		sb.append(" and b.fromDate like '").append(fromYear).append("%'");
	}

	if(requestId>0){
		sb.append(" and b.requestId<>"+requestId);
	}

	RecordSet.executeSql(sb.toString());
	if(RecordSet.next()){
		returnString+="false";
	}else{
		returnString+="true";
	}    
} else if("getLeaveDays".equals(operation)){//根据起始日期、起始时间、结束日期、结束时间获得请假天数
HrmScheduleManager scheduleManager = new HrmScheduleManager(request, response);
	scheduleManager.setForSchedule(true);
	returnString = scheduleManager.getLeaveDays();

	

}
if("getAnnualInfo".equals(operation)){
	String resourceId = Util.null2String(request.getParameter("resourceId"));
	String currentDate = Util.null2String(request.getParameter("currentDate"));
	int nodetype = strUtil.parseToInt(Util.null2String(request.getParameter("nodetype")));
	int workflowid = strUtil.parseToInt(Util.null2String(request.getParameter("workflowid")));
    int nodeid = strUtil.parseToInt(Util.null2String(request.getParameter("nodeid")));
	String userannualinfo = HrmAnnualManagement.getUserAannualInfo(resourceId,currentDate);
	String thisyearannual = Util.TokenizerString2(userannualinfo,"#")[0];
	String lastyearannual = Util.TokenizerString2(userannualinfo,"#")[1];
	String allannual = Util.TokenizerString2(userannualinfo,"#")[2];
	String allannualdaysValue = allannual;
	 float[] freezeDays = attVacationManager.getFreezeDays(resourceId,currentDate);
	 if(freezeDays[0] > 0) allannual += " - "+freezeDays[0];	

	float realAllallannualdaysValue = strUtil.parseToFloat(allannualdaysValue, 0);
    if(attProcSetManager.isFreezeNodeId(workflowid, nodeid)) {
		realAllallannualdaysValue = (float)strUtil.round(realAllallannualdaysValue - freezeDays[0]);
	}
	returnString = "getAnnualInfo#"+allannualdaysValue+"#"+realAllallannualdaysValue+"#"+SystemEnv.getHtmlLabelName(21614,user.getLanguage())+"&nbsp;:&nbsp;"+lastyearannual+"<br>"+SystemEnv.getHtmlLabelName(21615,user.getLanguage())+"&nbsp;:&nbsp;"+thisyearannual+"<br>"+SystemEnv.getHtmlLabelName(21616,user.getLanguage())+"&nbsp;:&nbsp;"+allannual;	
}

if("getPSInfo".equals(operation)){
	String resourceId = Util.null2String(request.getParameter("resourceId"));
	String currentDate = Util.null2String(request.getParameter("currentDate"));
	String leavetype = Util.null2String(request.getParameter("leavetype"));
	List listtypes = new ArrayList(); 
	String typeName = ""; 
	if(leavetype.length() > 0){
		listtypes = colorManager.find(colorManager.getMapParam("field004:"+leavetype));
		HrmLeaveTypeColor tmpbean = (HrmLeaveTypeColor)listtypes.get(0);
		typeName = tmpbean.getField001();
	}
	int nodetype = strUtil.parseToInt(Util.null2String(request.getParameter("nodetype")));
	int workflowid = strUtil.parseToInt(Util.null2String(request.getParameter("workflowid")));
	String userpslinfo = HrmPaidSickManagement.getUserPaidSickInfo(resourceId, currentDate,leavetype);
	String thisyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[0], 0);
	String lastyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[1], 0);
	String allpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[2], 0);
	String allpsldaysValue = allpsldays;
	float realAllpsldaysValue = strUtil.parseToFloat(allpsldaysValue, 0);
	 float freezeDays = attVacationManager.getPaidFreezeDays(resourceId,leavetype);
	 if(freezeDays > 0) allpsldays += " - "+freezeDays;	
	if(attProcSetManager.isFreezeNode(workflowid, nodetype)) {
		realAllpsldaysValue = (float)strUtil.round(realAllpsldaysValue - freezeDays);
	}

	String combinelabelPS1 = SystemEnv.getHtmlLabelName(131649,user.getLanguage());
	String combinelabelPS2 = SystemEnv.getHtmlLabelName(131650,user.getLanguage());
	String combinelabelPS3 = SystemEnv.getHtmlLabelName(131651,user.getLanguage());
	if(typeName.length() > 0){
		combinelabelPS1 = SystemEnv.getHtmlLabelName(382185,user.getLanguage())+typeName+SystemEnv.getHtmlLabelName(496,user.getLanguage());
		combinelabelPS2 = SystemEnv.getHtmlLabelName(382186,user.getLanguage())+typeName+SystemEnv.getHtmlLabelName(496,user.getLanguage());
		combinelabelPS3 = SystemEnv.getHtmlLabelName(382187,user.getLanguage())+typeName+SystemEnv.getHtmlLabelName(496,user.getLanguage());
	}
	
	returnString ="getPSInfo#"+allpsldaysValue+"#"+realAllpsldaysValue+"#"+combinelabelPS1+"&nbsp;:&nbsp;"+lastyearpsldays+"<br>"+combinelabelPS2+"&nbsp;:&nbsp;"+thisyearpsldays+"<br>"+combinelabelPS3+"&nbsp;:&nbsp;"+allpsldays;
		
}

if("getTXInfo".equals(operation)){
	String resourceId = Util.null2String(request.getParameter("resourceId"));
	String currentDate = Util.null2String(request.getParameter("currentDate"));
	String paidLeaveDays = String.valueOf(paidLeaveTimeManager.getCurrentPaidLeaveDaysByUser(resourceId, currentDate, true));
	 float[] freezeDays = attVacationManager.getFreezeDays(resourceId);
	 if(freezeDays[2] > 0) paidLeaveDays += " - "+freezeDays[2];	
	returnString ="getTXInfo#"+SystemEnv.getHtmlLabelName(82854,user.getLanguage())+"&nbsp;:&nbsp;"+paidLeaveDays;	
}

if("initInfo".equals(operation)){
    String resourceId = Util.null2String(request.getParameter("resourceId"));
	String currentDate = Util.null2String(request.getParameter("currentDate"));
	String bohai = Util.null2String(request.getParameter("bohai"));
	String leavetype = Util.null2String(request.getParameter("leavetype"));
	int nodetype = strUtil.parseToInt(Util.null2String(request.getParameter("nodetype")));
	int nodeid = strUtil.parseToInt(Util.null2String(request.getParameter("nodeid")));
	int workflowid = strUtil.parseToInt(Util.null2String(request.getParameter("workflowid")));
	String userannualinfo = HrmAnnualManagement.getUserAannualInfo(resourceId,currentDate);
	String thisyearannual = Util.TokenizerString2(userannualinfo,"#")[0];
	String lastyearannual = Util.TokenizerString2(userannualinfo,"#")[1];
	String allannual = Util.TokenizerString2(userannualinfo,"#")[2];
	String userpslinfo = HrmPaidSickManagement.getUserPaidSickInfo(resourceId, currentDate,leavetype);
	String thisyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[0], 0);
	String lastyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[1], 0);
	String allpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[2], 0);
	String paidLeaveDays = String.valueOf(paidLeaveTimeManager.getCurrentPaidLeaveDaysByUser(resourceId, currentDate, true));
	String allannualValue = allannual;
	String allpsldaysValue = allpsldays;
	String paidLeaveDaysValue = paidLeaveDays;
	float[] freezeDays = attVacationManager.getFreezeDays(resourceId,currentDate);
	float freezePaidDays = attVacationManager.getPaidFreezeDays(resourceId,leavetype);
	if(freezeDays[0] > 0) allannual += " - "+freezeDays[0];
	if(freezeDays[2] > 0) paidLeaveDays += " - "+freezeDays[2];
	
	if(freezePaidDays > 0) allpsldays += " - "+freezePaidDays;
	float realAllannualValue = strUtil.parseToFloat(allannualValue, 0);
	float realAllpsldaysValue = strUtil.parseToFloat(allpsldaysValue, 0);
	float realPaidLeaveDaysValue = strUtil.parseToFloat(paidLeaveDaysValue, 0);
	
	if(bohai.equals("true")){
			realAllannualValue = (float)strUtil.round(realAllannualValue - freezeDays[0]);
			realAllpsldaysValue = (float)strUtil.round(realAllpsldaysValue - freezePaidDays);
			realPaidLeaveDaysValue = (float)strUtil.round(realPaidLeaveDaysValue - freezeDays[2]);
	}else{
		if(attProcSetManager.isFreezeNodeId(workflowid, nodeid)) {
			realAllannualValue = (float)strUtil.round(realAllannualValue - freezeDays[0]);
			realAllpsldaysValue = (float)strUtil.round(realAllpsldaysValue - freezePaidDays);
			realPaidLeaveDaysValue = (float)strUtil.round(realPaidLeaveDaysValue - freezeDays[2]);
		}
	}
	returnString =allannualValue+"#"+allpsldaysValue+"#"+paidLeaveDaysValue+"#"+realAllannualValue+"#"+realAllpsldaysValue+"#"+realPaidLeaveDaysValue;
}
%>

<%=Util.toHtml(returnString)%>
