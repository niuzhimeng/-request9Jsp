<%@ page import="weaver.conn.RecordSetDataSource" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<script type="text/javascript" language="javascript">
    window.onload = function () {
        document.getElementById("loginForm").submit();
    }

</script>
<%
    // 单点SFA系统


    String name = "310771351@qq.com";
    String password = "123456";

%>

<html>
<body>
<form id="loginForm"
      action="http://bfpt.yunkeonline.cn/sso/api/login"
      method="post" style="display:none">
    <input type="hidden" id="name" name="name" value="<%=name%>"/>
    <input type="hidden" id="password" name="password" value="<%=password%>"/>

    <input type="hidden" id="_eventId" name="_eventId" value="submit"/>
    <input type="button" class="login-sign" name="" id="" value="跳转到sfa"/>
</form>
</body>
</html>




