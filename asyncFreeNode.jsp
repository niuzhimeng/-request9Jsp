<%@ page import="com.engine.workflow.biz.freeNode.FreeFlowOldDataAsyncBiz" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.BaseBean" %>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    int requestid  = Util.getIntValue(request.getParameter("requestid"));
    boolean asyncAll=  "1".equals(request.getParameter("asyncAll"));
    if(requestid > 0 || asyncAll) {
        FreeFlowOldDataAsyncBiz asyncBiz = new FreeFlowOldDataAsyncBiz();
        new BaseBean().writeLog("~~~~~~~~~~requestid~~~~~~~~~~:" + requestid);
        asyncBiz.executeAsync(requestid);
    }
%>