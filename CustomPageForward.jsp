<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%
	String __jsppath__ = request.getParameter("__address__");
	if(!"".equals(__jsppath__)){
	    request.getRequestDispatcher(__jsppath__).forward(request, response);
	}
	return;
%>