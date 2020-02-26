<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="com.api.workflow.util.ServiceUtil"%>
<%@ page import="com.engine.workflow.biz.requestForm.RequestFormBiz" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String requestid = Util.null2String(request.getParameter("requestid"));
	int isrequest = Util.getIntValue(request.getParameter("isrequest"),0);
	
	int isintervenor = Util.getIntValue(request.getParameter("isintervenor"),0);
	int ismonitor = Util.getIntValue(request.getParameter("ismonitor"),0);
	boolean isQueryCurrentNode = isintervenor == 1 || ismonitor == 1;

	User user = RequestFormBiz.getFormUser(request, response, true);
	if(user == null) {
		response.sendRedirect("/wui/index.html");
		return;
	}
	boolean reqSpaPage = ServiceUtil.isReqRoute(requestid,user,isrequest,isQueryCurrentNode);
	String url = "";
	if(reqSpaPage){
		url = "/spa/workflow/static4form/index.html?_rdm="+System.currentTimeMillis()+"#/main/workflow/req?";
		//session.setAttribute("theme", "ecology9");
	}else{
		url = "/workflow/request/ViewRequest.jsp?haveVerifyForward=true&";
	}
	Enumeration em = request.getParameterNames();
	while(em.hasMoreElements()){
		String paramName = (String) em.nextElement();
		url += paramName + "=" + request.getParameter(paramName) + "&";
	}
	if(url.endsWith("&"))
		url = url.substring(0, url.length()-1);
	//request.getRequestDispatcher(url).forward(request, response);
	//if(url.indexOf("timestamp=") == -1)
	//	url += "&timestamp="+System.currentTimeMillis();
	response.sendRedirect(url);
%>