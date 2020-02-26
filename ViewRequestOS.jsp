<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.conn.RecordSet" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.login.CheckIpNetWork" %>
<%@ page import="weaver.interfaces.outter.CheckIpNetWorkForUpcoming" %>
<%
        /**
         * 这个页面只打开其他系统的页面。其他页面误入直接跳转到ViewRequest.jsp
         */
	User user = HrmUserVarify.getUser (request , response) ;
    int requestid = Util.getIntValue(request.getParameter("requestid"));
    int workflowid = Util.getIntValue(request.getParameter("workflowid"));
    int sysid = Util.getIntValue(request.getParameter("sysid"));
    int reflush = Util.getIntValue(request.getParameter("reflush"),0);
    if(reflush==1){
%>
<script type='text/javascript'>
  //var pwindow=window.parent.document.getElementById("bodyiframe").contentWindow;
  try{
    window.parent.opener.btnWfCenterReload.onclick();
  }catch(e){}
  try{
    window.parent.opener._table.reLoad();
  }catch(e){

  }
  setTimeout(function(){
      try{
        window.parent.opener.btnWfCenterReload.onclick();
      }catch(e){}
      try{
        window.parent.opener._table.reLoad();
      }catch(e){

      }
      window.close();
    }
    ,1500);
</script>
<%
}else{
    if(requestid>0){
        //OA的流程
        response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid);
    }else{
        //打开统一待办的流程

        RecordSet rs = new RecordSet();
        //查询打开的前缀和url
        String pcprefixurl = "";
        String pcouterfixurl = "";
        String pcurl = "" ;
        String syscode = "";
        rs.executeSql("select s.Pcprefixurl, s.pcouterfixurl, d.pcurl,s.syscode,s.pcentranceurl from ofs_sysinfo s ,ofs_todo_data d where d.sysid=s.sysid and d.requestid="+requestid+" and s.sysid="+sysid+" and userid="+user.getUID()+" and islasttimes=1 and d.workflowid="+workflowid);
        if(rs.next()){
            pcprefixurl = Util.null2String(rs.getString(1));
            pcouterfixurl = Util.null2String(rs.getString(2));
            pcurl = Util.null2String(rs.getString(3));
            syscode = Util.null2String(rs.getString(4));
        }
        //TODO 判断是否存在中专页面
        String pcentranceurl = Util.null2String(rs.getString("pcentranceurl"));
        if(!"".equals(pcentranceurl)){
            //跳转中转页面
            response.sendRedirect(pcurl);
            return;
        }
        String autologinFlag = "0";//
        RecordSet recordSet = new RecordSet();
        
		String sqlForStatus = "SELECT * FROM autologin_status WHERE syscode='"+syscode+"'";
        recordSet.execute(sqlForStatus);
        if (recordSet.next()) {
            autologinFlag = Util.null2String(recordSet.getString("status"),"0");
        }
        //0代表不开启，则所有通过内网访问
        //1代表开启，并且有设置网段
        //2代表开启，但是没有设置网段
//        System.out.println("autologinFlag is " + autologinFlag);
        if (autologinFlag.equals("0")){

            if(pcurl.startsWith("http") || pcurl.startsWith("https")){
                response.sendRedirect(pcurl);
            }else{
                response.sendRedirect(pcprefixurl+pcurl);
            }
        } else if (autologinFlag.equals("2")) {

            if(pcurl.startsWith("http") || pcurl.startsWith("https")){
                response.sendRedirect(pcurl);
            }else{
                response.sendRedirect(pcouterfixurl+pcurl);
            }
        }else if (autologinFlag.equals("1")){
            String clientIp = Util.getIpAddr(request);
//            CheckIpNetWork checkIpNetWorkForUpcoming = new CheckIpNetWork();
            CheckIpNetWorkForUpcoming checkIpNetWorkForUpcoming = new CheckIpNetWorkForUpcoming();
            boolean notInOuter = checkIpNetWorkForUpcoming.checkIpSeg(clientIp);
//            System.out.println("不在网段内？"+notInOuter);
            if (notInOuter) {
                //不在网段策略中
//                System.out.println("不在网段中:"+pcouterfixurl+pcurl);
                if(pcurl.startsWith("http") || pcurl.startsWith("https")){
                    response.sendRedirect(pcurl);
                }else{
                    response.sendRedirect(pcouterfixurl+pcurl);
                }
            } else {
                //在网段策略中
//                System.out.println("在网段中:"+pcprefixurl+pcurl);

                if(pcurl.startsWith("http") || pcurl.startsWith("https")){
                    response.sendRedirect(pcurl);
                }else{
                    response.sendRedirect(pcprefixurl+pcurl);
                }
            }
        }



    }


}


%>
