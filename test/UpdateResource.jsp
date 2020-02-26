<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 完美门店流程，带出省份、区县、城市
    // 开业准备流程表名
    String status = request.getParameter("status");
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    try {
        recordSet.executeUpdate("update hrmresource set status = ? where id = ?", status, "21");
        new ResourceComInfo().removeResourceCache();
    } catch (Exception e) {
        baseBean.writeLog("完美门店流程，带出字段异常： " + e);
    }


%>












