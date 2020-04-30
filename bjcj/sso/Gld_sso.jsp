<%@ page import="org.apache.axis.client.Call" %>
<%@ page import="org.apache.axis.client.Service" %>
<%@ page import="org.apache.axis.encoding.XMLType" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="javax.xml.rpc.ParameterMode" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    // 单点广联达OA系统
    BaseBean baseBean = new BaseBean();

    RecordSet recordSet = new RecordSet();
    String loginId = user.getLoginid();

    try {

        Service service = new Service();
        Call call = (Call) service.createCall();
        call.setTargetEndpointAddress("WSUrl");
        call.setOperationName("runBiz");//设置操作名
        /*设置⼊⼝参数*/
        call.addParameter("packageName", XMLType.XSD_STRING, ParameterMode.IN);
        call.addParameter("unitId", XMLType.XSD_STRING, ParameterMode.IN);
        call.addParameter("processName", XMLType.XSD_STRING, ParameterMode.IN);
        call.setReturnType(XMLType.XSD_STRING);

        /*调⽤⻔户系统WebService服务，返回结果*/
        String[] params = {"common", "0", "biz.bizCheckSSO"};
        String msg = (String) call.invoke(params);//obj是代表返回⼀个XML格式的串
        baseBean.writeLog("验证返回msg： " + msg);
    } catch (Exception e) {
        baseBean.writeLog("单点广联达OA异常： " + e);
    }
%>





