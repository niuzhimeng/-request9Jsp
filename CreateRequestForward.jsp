<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="com.api.workflow.util.ServiceUtil"%>
<%@ page import="com.engine.workflow.biz.requestForm.RequestFormBiz" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.workflow.workflow.WorkflowVersion"%>
<%
	String workflowid = Util.null2String(request.getParameter("workflowid"));
	workflowid = WorkflowVersion.getActiveVersionWFID(workflowid);

	User user = RequestFormBiz.getFormUser(request, response, true);
	if(user == null) {
	    response.sendRedirect("/wui/index.html");
	    return;
	}

	boolean createSPA = ServiceUtil.judgeWfCreateForwardSPA(workflowid, user.getUID());
	String url = createSPA ? "/spa/workflow/static4form/index.html?_rdm="+System.currentTimeMillis()+"#/main/workflow/req?iscreate=1&" : "/workflow/request/AddRequest.jsp?haveVerifyForward=true&";
	Enumeration em = request.getParameterNames();
	while(em.hasMoreElements()){
		String paramName = (String) em.nextElement();
		String paramValue = request.getParameter(paramName);
		if("workflowid".equals(paramName)) {
			paramValue = workflowid;
		}
		url += paramName + "=" + paramValue + "&";
	}
	if(url.endsWith("&"))
		url = url.substring(0, url.length()-1);
	response.sendRedirect(url);
	return;
%>