
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="com.engine.workflow.biz.freeNode.FreeNodeBiz" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%

    /*用户验证*/
    User user = HrmUserVarify.getUser (request , response) ;
    if(user==null) {
        response.sendRedirect("/login/Login.jsp");
        return;
    }

    String requestid = Util.null2String(request.getParameter("requestid")) ;
    String workflowid = Util.null2String(request.getParameter("workflowid")) ;
    String isAllowNodeFreeFlow = Util.null2String(request.getParameter("isAllowNodeFreeFlow")) ;
    String isFree = Util.null2String(request.getParameter("isFree")) ;

    String showChartUrl = "";
    rs.executeSql("select * from workflow_base where id='"+workflowid+"'");
    if(rs.next()){
        showChartUrl = Util.null2String(rs.getString("showChartUrl"));
    }

    if(!"".equals(showChartUrl)) {
        showChartUrl += showChartUrl.indexOf("?") > 0 ? "&" : "?";
        showChartUrl += "requestid="+requestid+"&workflowid="+workflowid;
        response.sendRedirect(showChartUrl);
        return;
    }

    String urlParams = "isFromAutodirect=1&isFromWfForm=true&requestId="+requestid+"&workflowId="+workflowid;
    boolean hasFreeNode = FreeNodeBiz.hasFreeNode(Util.getIntValue(requestid));
    urlParams += "&isFlowModel=0";
    urlParams += "&isReadOnlyModel=true";
    urlParams += "&isAllowNodeFreeFlow=" + isAllowNodeFreeFlow;
    urlParams += "&isFree=" + isFree;
    urlParams += "&hasFreeNode=" + (hasFreeNode ? "1" : "0");
    urlParams += "&f_weaver_belongto_userid="+Util.null2String(request.getParameter("f_weaver_belongto_userid"));
    urlParams += "&f_weaver_belongto_usertype="+Util.null2String(request.getParameter("f_weaver_belongto_usertype"));
    urlParams += "&authSignatureStr="+Util.null2String(request.getParameter("authSignatureStr"));
    urlParams += "&authStr="+Util.null2String(request.getParameter("authStr"));

    response.sendRedirect("/workflow/workflowDesign/readOnly-index.html?" + urlParams);
    return;
%>