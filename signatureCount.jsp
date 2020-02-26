<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<jsp:useBean id="RequestSignatureManager" class="weaver.workflow.request.RequestSignatureManager" scope="page" />
<%

int requestId = Util.getIntValue(request.getParameter("requestId"),0);
int nodeId = Util.getIntValue(request.getParameter("nodeId"),0);
int userId = Util.getIntValue(request.getParameter("userId"),0);
int loginType = Util.getIntValue(request.getParameter("loginType"),1);
int workflowid= Util.getIntValue(request.getParameter("workflowid"),0);

JSONArray resultArray = new JSONArray();
JSONObject json = new JSONObject();

boolean hasSignatureSucceed = false;
String signatureNodes = "";
boolean isSignatureNodes = false;
RecordSet rs = new RecordSet();
rs.executeQuery("select signatureNodes from workflow_createdoc  where workflowId=" + workflowid);
if(rs.next()){
    signatureNodes = rs.getString(1);
}
if(("," + signatureNodes + ",").indexOf("," + nodeId + ",") >= 0 && nodeId > 0) {
    isSignatureNodes = true;
}
if(isSignatureNodes){
    hasSignatureSucceed = RequestSignatureManager.ifHasSignatureSucceed(requestId,nodeId,userId,loginType);
}else{
    hasSignatureSucceed = true;
}
json.put("signatureCount",hasSignatureSucceed);
resultArray.add(json);


out.print(resultArray.toString());
%>