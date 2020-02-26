<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="com.engine.workflow.util.CommonUtil" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="com.engine.workflow.biz.requestForm.PrintInfoBiz" %>
<%
	String requestid = Util.null2String(request.getParameter("requestid"));
	User user = CommonUtil.getUserByRequest(request, response);
	String url = "";
	if(user==null){
		url="/wui/index.html";
		response.sendRedirect(url);
		return;
	}

	Map<String,Object> printInfo = new PrintInfoBiz().getPrintInfo(requestid, user);
	List<Map<String, Object>> templates = (List<Map<String, Object>>)printInfo.get("templates");

	if(templates.size() == 1){	//只有一个模板直接跳转至打印页面
		Map<String,Object> info = templates.get(0);
		url = "/workflow/request/PrintRequestSPA.jsp?ismode="+info.get("ismode")+"&modeid="+info.get("modeid")+"&";
	}else{		//选择模板
		url = "/spa/workflow/index_form.jsp#/main/workflow/printReq?";
	}
	Enumeration em = request.getParameterNames();
	while(em.hasMoreElements()){
		String paramName = (String) em.nextElement();
		url += paramName + "=" + request.getParameter(paramName) + "&";
	}
	if(url.endsWith("&"))
		url = url.substring(0, url.length()-1);
	response.sendRedirect(url);
	return;
%>