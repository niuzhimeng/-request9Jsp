<%@ page import="weaver.conn.RecordSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    // 单点项目管理系统
    BaseBean baseBean = new BaseBean();

    RecordSet recordSet = new RecordSet();
    String loginId = user.getLoginid();

    try {
        String userCode = user.getLoginid();
        String timestamp = TimeUtil.getCurrentTimeString().replace("-", "/");

        String userKey = "";

        String url = "http://pm.bucnc.com:8888/Services/Identification/Server/login.ashx?sso=1&ssoProvider=UserKey" +
                "&userkey=" + userKey + "&service=%2findex.aspx";

    } catch (Exception e) {
        baseBean.writeLog("单点项目管理异常： " + e);
    }
%>





