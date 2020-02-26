
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="java.io.*" %>
<%@ page import="com.engine.workflow.biz.customizeBrowser.BrowserFieldValueComInfo" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/datacenter/maintenance/inputreport/InputReportHrmInclude.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<!DOCTYPE html>
<%
    if (user.getUID() != 1) {
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }
%>
<%@ include file="/workflow/request/CommonUtils.jsp" %>
<%
    int openRefreshThread = 1;
    int refreshTimeInterval = 10;

    RecordSet rs  = new RecordSet();
    rs.executeQuery("select openRefreshThread,refreshTimeInterval from workflow_fielddata_cache_prop ");
    if(rs.next()) {
        openRefreshThread = rs.getInt("openRefreshThread");
        refreshTimeInterval =  rs.getInt("refreshTimeInterval");
    }

    String isShowCacheData = Util.null2String(request.getParameter("isShowCacheData"));

    String method = Util.null2String(request.getParameter("method"));
    if("submit".equals(method)) {
        openRefreshThread  = Util.getIntValue(request.getParameter("openRefreshThread"));
        refreshTimeInterval  = Util.getIntValue(request.getParameter("refreshTimeInterval"));
        rs.executeUpdate("update workflow_fielddata_cache_prop set openRefreshThread = ? ,refreshTimeInterval = ? ",openRefreshThread,refreshTimeInterval);

        int clearAllCache  = Util.getIntValue(request.getParameter("clearAllCache"));
        if(1 ==  clearAllCache) {
            rs.executeUpdate("delete from workflow_fielddata_cache ");
            BrowserFieldValueComInfo bfvComInfo = new BrowserFieldValueComInfo();
            bfvComInfo.removeCache();
        }

        int deleteCacheRequestid = Util.getIntValue(request.getParameter("deleteCacheRequestid"));
        if(deleteCacheRequestid > 0) {
            rs.executeQuery("select requestid,fieldid,detailid from workflow_fielddata_cache where requestid = ? ",deleteCacheRequestid);
            BrowserFieldValueComInfo bfvComInfo = new BrowserFieldValueComInfo();
            while(rs.next()) {
                String key = rs.getInt("requestid") +"_" + Util.null2String(rs.getString("fieldid")) +"_" +rs.getInt("detailid");
                bfvComInfo.deleteCache(key);
            }
            rs.executeUpdate("delete from workflow_fielddata_cache where requestid  = ?" ,deleteCacheRequestid);
        }
    }

    String requestid  = Util.null2String(request.getParameter("requestid"));
%>
<html>
<head>
    <link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
    <script language="javascript" src="/js/weaver_wev8.js"></script>
    <script language="javascript" src="/proj/js/common_wev8.js"></script>
    <style type="text/css">
        .submit-button{
            margin-top:20px;
            margin-left: 20px;
        }
        .btn{
            color: #fff;
            background-color: #30b5ff;
            padding-left: 20px !important;
            padding-right: 20px !important;
            height: 30px;
            line-height: 30px;
            vertical-align: middle;
            border: 1px solid #30b5ff;
            cursor: pointer;
        }
    </style>

</head>
<body>
<script type="javascript">

</script>
<div class="main">
    <form id="form" action="/workflow/request/CustomizeBrowserCacheUtil.jsp" method="post" >
        <wea:layout type="twoCol" attributes="{'expandAllGroup':'true'}">
            <wea:group context='自定义浏览框缓存相关设置 (设置重启生效)' attributes="{'class':'e8_title e8_title_1'}">
                <wea:item>
                    是否启用自定义浏览框名称缓存功能
                </wea:item>
                <wea:item>
                    <input name="openRefreshThread" <%if(openRefreshThread == 1) {%> checked <%}%>  type="radio" value="1"/><label>开启</label>
                    <input name="openRefreshThread" <%if(openRefreshThread == 0) {%> checked <%}%>  type="radio" value="0"/><label>关闭</label>
                </wea:item>
                <wea:item>
                    浏览框名称缓存线程更新间隔
                </wea:item>
                <wea:item>
                    <input type="text" name="refreshTimeInterval" value="<%=refreshTimeInterval %>" onkeyup="clearNoNum(this)"  style="width:100px;"/>(单位：分钟)
                </wea:item>
                <wea:item>
                    <span style="color:red;">是否清除所有的浏览框名称缓存数据（保存后生效）</span>
                </wea:item>
                <wea:item>
                    <input name="clearAllCache"  type="radio" value="1"/><label>是</label>
                    <input name="clearAllCache"  checked type="radio" value="0"/><label>否</label>
                </wea:item>
                <wea:item>
                    <span style="color:red;">清除流程缓存(输入流程ID)</span>
                </wea:item>
                <wea:item>
                    <input name="deleteCacheRequestid"  type="text" value=""/>
                </wea:item>
            </wea:group>
        </wea:layout>
        <input type="hidden" name="method" value="submit"/>
        <div class="submit-button"><input class="btn" type="button" value="提交" onclick="submit()"/></div>
    </form>
</div>
</body>
</html>
