<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%
	List<Map<String,String>> userList = new ArrayList<Map<String,String>>();
	String userids =  Util.null2String(request.getParameter("userids"));
	if(!"".equals(userids)){
		if(userids.startsWith(",")){
			userids = userids.substring(1);
		}
		if(userids.endsWith(",")){
			userids = userids.substring(0,userids.length() - 1);
		}
		
		String [] userarr = userids.split(",");
		for(int i = 0; i < userarr.length; i++){
			String userid = Util.null2String(userarr[i]);			
			String imgsrc = resourceComInfo.getMessagerUrls(userid);
			String lastname = resourceComInfo.getLastname(userid);
			
			Map<String,String> userMap = new HashMap<String,String>();
			userMap.put("id",userid);
			userMap.put("text",lastname);
			userMap.put("imgsrc",imgsrc);

			userList.add(userMap);
		}
	}
	
	JSONArray jsArray = JSONArray.fromObject(userList);
%>

<%=jsArray.toString()%>